From: Kai =?iso-8859-1?Q?M=E4kisara?= <kai.makisara@kolumbus.fi>
Subject: Re: aic7xxx & st: BUG at include/asm/dma-mapping.h:37
Date: Fri, 8 Aug 2003 20:30:03 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030808173003.GA3231@kai.makisara.local>
References: <20030806231359.A28252@mail.kroptech.com> <Pine.LNX.4.56.0308072346560.1035@kai.makisara.local> <20030807201916.A1065@mail.kroptech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep06-0.kolumbus.fi ([193.229.0.57]:46673 "EHLO
	fep06-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S271719AbTHHRaF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2003 13:30:05 -0400
Content-Disposition: inline
In-Reply-To: <20030807201916.A1065@mail.kroptech.com>
List-Id: linux-scsi@vger.kernel.org
To: Adam Kropelin <akropel1@rochester.rr.com>
Cc: linux-scsi@vger.kernel.org, gibbs@scsiguy.com

Thus spake Adam Kropelin (akropel1@rochester.rr.com):

> On Fri, Aug 08, 2003 at 12:00:56AM +0300, Kai Makisara wrote:
...
> I tried aic7xxx_old and hit the same BUG so Justin's driver would seem
> to be exonerated. The new backtrace is below. The commonality is clearly
> the st driver and the SCSI midlayer. Perhaps I'll try to verbosify
> things a bit in that area and see what comes up.
> 
I reproduced the problem with an aha2940. The patch at the end of this
message fixes the problem but I must think a little more before
sending a permanent fix (at least some comments must be added).

In case someone wonders what this has to do with the symptoms: the bug
lead to setting sr_use_sg to one even when the byte count was zero and
DMA direction DMA_NONE. The byte count in the first s/g segment was
non-zero. Different SCSI HBA drivers handle this inconsistency
differently and this is why I have not seen this in my tests.

This bug has been in st for quite a long time. Thanks for finally
detecting it :-)

-- 
Kai
----------------------------8<--------------------------------------
--- linux-2.6/drivers/scsi/st.c.2.6t2	2003-08-08 19:17:54.000000000 +0300
+++ linux-2.6/drivers/scsi/st.c	2003-08-08 19:56:49.000000000 +0300
@@ -2340,6 +2340,7 @@
 	int timeout;
 	long ltmp;
 	int ioctl_result;
+	int saved_do_dio;
 	int chg_eof = TRUE;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	Scsi_Request *SRpnt;
@@ -2609,8 +2610,15 @@
 		return (-ENOSYS);
 	}
 
+	/* Save the direct i/o state in case this is called from
+	   error recovery */
+	saved_do_dio = STp->buffer->do_dio;
+	STp->buffer->do_dio = 0;
+
 	SRpnt = st_do_scsi(NULL, STp, cmd, datalen, direction,
 			   timeout, MAX_RETRIES, TRUE);
+
+	STp->buffer->do_dio = saved_do_dio;
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
