From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fusion - mptspi - reset handler shouldn't be called
	for other bus protocals
Date: Wed, 17 May 2006 18:06:52 -0500
Message-ID: <1147907212.3463.99.camel@mulgrave.il.steeleye.com>
References: <20060517221724.GA8700@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:57534 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751140AbWEQXG7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 19:06:59 -0400
In-Reply-To: <20060517221724.GA8700@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2006-05-17 at 16:17 -0600, Eric Moore wrote:
> All registered reset callback handlers are called during reset processing.
> The mptspi modules has its own reset callback handler, just recently
> added for issuing domain validation after host reset.  If either the mptsas or
> mptfc driver are loaded, this callback could be called. Thus resulting
> in domain validation being issued for sas or fibre end devices.
> This patch insures domain validation is only occuring on spi end devices
> 
> This is urgent bug fix. Pls apply this to scsi-rc-fixes-2.6,
> as well as this patch posted yesterday:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=114782261719616&w=2

That's a pretty nasty bug ... and it will bite on the other reset
handlers, won't it as well?  Shouldn't we be fixing it this way instead:

James

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 9080853..a300840 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1605,6 +1605,21 @@ mpt_resume(struct pci_dev *pdev)
 }
 #endif
 
+static int
+mpt_signal_reset(int index, MPT_ADAPTER *ioc, int reset_phase)
+{
+	if ((MptDriverClass[index] == MPTSPI_DRIVER &&
+	     ioc->bus_type != SPI) ||
+	    (MptDriverClass[index] == MPTFC_DRIVER &&
+	     ioc->bus_type != FC) ||
+	    (MptDriverClass[index] == MPTSAS_DRIVER &&
+	     ioc->bus_type != SAS))
+		/* make sure we only call the relevant reset handler
+		 * for the bus */
+		return 0;
+	return (MptResetHandlers[index])(ioc, reset_phase);
+}
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *	mpt_do_ioc_recovery - Initialize or recover MPT adapter.
@@ -1885,14 +1900,14 @@ #endif
 			if ((ret == 0) && MptResetHandlers[ii]) {
 				dprintk((MYIOC_s_INFO_FMT "Calling IOC post_reset handler #%d\n",
 						ioc->name, ii));
-				rc += (*(MptResetHandlers[ii]))(ioc, MPT_IOC_POST_RESET);
+				rc += mpt_signal_reset(ii, ioc, MPT_IOC_POST_RESET);
 				handlers++;
 			}
 
 			if (alt_ioc_ready && MptResetHandlers[ii]) {
 				drsprintk((MYIOC_s_INFO_FMT "Calling alt-%s post_reset handler #%d\n",
 						ioc->name, ioc->alt_ioc->name, ii));
-				rc += (*(MptResetHandlers[ii]))(ioc->alt_ioc, MPT_IOC_POST_RESET);
+				rc += mpt_signal_reset(ii, ioc->alt_ioc, MPT_IOC_POST_RESET);
 				handlers++;
 			}
 		}
@@ -3267,11 +3282,11 @@ #endif
 				if (MptResetHandlers[ii]) {
 					dprintk((MYIOC_s_INFO_FMT "Calling IOC pre_reset handler #%d\n",
 							ioc->name, ii));
-					r += (*(MptResetHandlers[ii]))(ioc, MPT_IOC_PRE_RESET);
+					r += mpt_signal_reset(ii, ioc, MPT_IOC_PRE_RESET);
 					if (ioc->alt_ioc) {
 						dprintk((MYIOC_s_INFO_FMT "Calling alt-%s pre_reset handler #%d\n",
 								ioc->name, ioc->alt_ioc->name, ii));
-						r += (*(MptResetHandlers[ii]))(ioc->alt_ioc, MPT_IOC_PRE_RESET);
+						r += mpt_signal_reset(ii, ioc->alt_ioc, MPT_IOC_PRE_RESET);
 					}
 				}
 			}
@@ -5706,11 +5721,11 @@ #endif
 			if (MptResetHandlers[ii]) {
 				dtmprintk((MYIOC_s_INFO_FMT "Calling IOC reset_setup handler #%d\n",
 						ioc->name, ii));
-				r += (*(MptResetHandlers[ii]))(ioc, MPT_IOC_SETUP_RESET);
+				r += mpt_signal_reset(ii, ioc, MPT_IOC_SETUP_RESET);
 				if (ioc->alt_ioc) {
 					dtmprintk((MYIOC_s_INFO_FMT "Calling alt-%s setup reset handler #%d\n",
 							ioc->name, ioc->alt_ioc->name, ii));
-					r += (*(MptResetHandlers[ii]))(ioc->alt_ioc, MPT_IOC_SETUP_RESET);
+					r += mpt_signal_reset(ii, ioc->alt_ioc, MPT_IOC_SETUP_RESET);
 				}
 			}
 		}


