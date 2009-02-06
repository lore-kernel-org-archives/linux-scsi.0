From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [ PATCH 3/3 ] tests in mpt_config().
Date: Fri, 6 Feb 2009 14:23:31 +0100
Message-ID: <200902061423.32797.bs@q-leap.de>
References: <200902061408.46652.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.q-leap.de ([88.79.172.217]:44249 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbZBFNXf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 08:23:35 -0500
In-Reply-To: <200902061408.46652.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, Andrew Morton <akpm@linux-foundation.org>

Add basic checks to mpt_config(). This is a backport from the mpt fusion 4.17 driver.

Signed-off-by: Bernd Schubert <bs@q-leap.de>

---
 drivers/message/fusion/mptbase.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

Index: linus-git/drivers/message/fusion/mptbase.c
===================================================================
--- linus-git.orig/drivers/message/fusion/mptbase.c
+++ linus-git/drivers/message/fusion/mptbase.c
@@ -5868,6 +5868,26 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS
 		return -EPERM;
 	}
 
+	/* don't send a config page during diag reset */
+	spin_lock_irqsave(&ioc->diagLock, flags);
+	if (ioc->ioc_reset_in_progress) {
+		dfailprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+			    "%s: busy with host reset\n", ioc->name, __func__));
+		spin_unlock_irqrestore(&ioc->diagLock, flags);
+		return -EBUSY;
+	}
+	spin_unlock_irqrestore(&ioc->diagLock, flags);
+
+	/* don't send if no chance of success */
+	if (!ioc->active
+	||  mpt_GetIocState(ioc, 1) != MPI_IOC_STATE_OPERATIONAL) {
+		dfailprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+			    "%s: ioc not operational, %d, %xh\n",
+		ioc->name, __func__, ioc->active,
+		mpt_GetIocState(ioc, 0)));
+		return -EFAULT;
+	}
+
 	/* Get and Populate a free Frame
 	 */
 	if ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {


-- 
Bernd Schubert
Q-Leap Networks GmbH
