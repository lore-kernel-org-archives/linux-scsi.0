From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Sun, 05 Jan 2014 21:14:41 -0500
Message-ID: <52CA1191.8060804@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com> <1387236657-4852-1-git-send-email-psusi@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:65485 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaAFCOn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jan 2014 21:14:43 -0500
In-Reply-To: <1387236657-4852-1-git-send-email-psusi@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: todd.e.brandt@linux.intel.com
Cc: tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 12/16/2013 06:30 PM, Phillip Susi wrote:
> For some reason, the system hangs on resume if I issue the REQUEST
> SENSE command after blk_pre_runtime_suspend.  My understanding is
> that the REQ_PM flag should make the command process even though
> the queue is RPM_SUSPENDING, but it doesn't seem to work.  Anyone
> have any idea why?

So I found the problem but I'm confused by it.  I thought that the
REQ_PM flag was supposed to make sure the request was dispatched even
though the device was still suspended ( or suspending ).  It seems
that this is not the case, and only requests with the type set to
REQ_TYPE_PM_RESUME are dispatched during suspend/resume.  The
following patch fixes the hang, but I'm not sure why it is needed or
if it is generally appropriate:

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7bd7f0d..c5ce50d 100644
- --- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -227,7 +227,9 @@ int scsi_execute(struct scsi_device *sdev, const
unsigned char *cmd,
        req->sense_len = 0;
        req->retries = retries;
        req->timeout = timeout;
- -       req->cmd_type = REQ_TYPE_BLOCK_PC;
+       if (flags & REQ_PM)
+               req->cmd_type = REQ_TYPE_PM_RESUME;
+       else req->cmd_type = REQ_TYPE_BLOCK_PC;
        req->cmd_flags |= flags | REQ_QUIET | REQ_PREEMPT;

        /*


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSyhGRAAoJEI5FoCIzSKrwbB4IAJqrtJuw92+rJQqkC7W5qRe8
psqgHiplkb9HCb3po95kM3c+05xjukoYNOk4+1s2iS0Adu288pSch2D20qPsT9Pc
DOHdU4iyaZ85gLxOIxdpCa+YYBYAzB8LEkqSMMvuhRkMqa008kclvVfqYtGhmw2g
DJcvuyowXLHQrpx+AA+CqY7aWxMK46uiNIwE3v8GA17augRzfltijMDZU/9SjG/7
lIe4V4lVf9SeWphVh0BSWULT84QOVQhcYGO/zK+I7xei2igPAHpBzHuUfXqs44PB
Z37eHf1JENZkuyekBDth+PsrnuiVZG20ECvymipoEQGv1iQ6R/QZsviNv/XUDgo=
=nAGL
-----END PGP SIGNATURE-----
