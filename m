From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sg jiffy library calls [was: sg kill local jiffies problems]
Date: Mon, 06 Sep 2004 18:51:38 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <413C251A.1050105@torque.net>
References: <413A778C.1000302@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000806030704000801010308"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:31626 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S267624AbUIFIwP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2004 04:52:15 -0400
In-Reply-To: <413A778C.1000302@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bunk@fs.tum.de, Michel.R.Garnier@wanadoo.fr

This is a multi-part message in MIME format.
--------------000806030704000801010308
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Douglas Gilbert wrote:
> It has been reported that the change to sg.c in lk 2.6.9-rc1-bk5
> to use library jiffy functions breaks sg (albeit under vmware).
> Evidentally sg devices are no longer recognised after that change.
> 
> Reverting that changeset removes the problem. Strange, it is not
> obvious why.
> 
> At some stage I must have detected negative time spans (yeh yeh it
> never happens) and my versions returned 0 in this case; otherwise
> the implementations look very similar.

The following patch fixes the problem. It is
against lk 2.6.9-rc1-bk7 (i.e. after "standard"
jiffy_to_millisecs macros replaced sg versions).

Change:
    - make sure a (large) user supplied timeout value does
      not result in a negative timeout passed to the midlevel

Doug Gilbert



--------------000806030704000801010308
Content-Type: text/x-patch;
 name="sg_269rc1bk7jif.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_269rc1bk7jif.diff"

--- linux/drivers/scsi/sg.c	2004-09-01 11:48:55.000000000 +1000
+++ linux/drivers/scsi/sg.c269rc1bk7jif	2004-09-06 17:00:56.000000000 +1000
@@ -576,6 +576,7 @@
 	sg_io_hdr_t *hp;
 	unsigned char cmnd[sizeof (dummy_cmdp->sr_cmnd)];
 	int timeout;
+	unsigned long ul_timeout;
 
 	if (count < SZ_SG_IO_HDR)
 		return -EINVAL;
@@ -610,7 +611,8 @@
 			return -EBUSY;	/* reserve buffer already being used */
 		}
 	}
-	timeout = msecs_to_jiffies(srp->header.timeout);
+	ul_timeout = msecs_to_jiffies(srp->header.timeout);
+	timeout = (ul_timeout < INT_MAX) ? ul_timeout : INT_MAX;
 	if ((!hp->cmdp) || (hp->cmd_len < 6) || (hp->cmd_len > sizeof (cmnd))) {
 		sg_remove_request(sfp, srp);
 		return -EMSGSIZE;

--------------000806030704000801010308--
