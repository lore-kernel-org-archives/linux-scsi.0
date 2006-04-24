From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SCSI trow USB-STORAGE or SBP2 Debug for buggy device Kernels
	2.6.X
Date: Mon, 24 Apr 2006 13:38:08 -0500
Message-ID: <1145903888.3528.21.camel@mulgrave.il.steeleye.com>
References: <200604241029.14932.gustavo@compunauta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:51376 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751109AbWDXSiT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Apr 2006 14:38:19 -0400
In-Reply-To: <200604241029.14932.gustavo@compunauta.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gustavo Guillermo =?ISO-8859-1?Q?P=E9rez?= <gustavo@compunauta.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

On Mon, 2006-04-24 at 10:29 -0500, Gustavo Guillermo P=C3=A9rez wrote:
> Then I have an Idea, what happen if on scsi_lib.c where resides the f=
aulty=20
> code:
> if (!(req->flags & REQ_QUIET))
>               dev_printk(KERN_INFO,
>               &cmd->device->sdev_gendev,
>               "Device not ready.\n");
>               scsi_end_request(cmd, 0, this_count, 1);
>               return;
> I change scsi_end_request(cmd, 0, this_count, 1);
> by a comparison about vendor ID and Model
> and then if is a buggy one executes scsi_requeue_command(q, cmd); ins=
tead of=20
> scsi_end_request(cmd, 0, this_count, 1);

Let's actually debug the problem before trying to fix it.  It would be
helpful to know what type of not-ready this is (and whether it's
internally generated in usb or firewire, but that comes later).

Try this addition and see what it tells us.

James

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7b0f9a3..cd9df1b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1074,9 +1074,12 @@ void scsi_io_completion(struct scsi_cmnd
 				scsi_requeue_command(q, cmd);
 				return;
 			}
-			if (!(req->flags & REQ_QUIET))
+			if (!(req->flags & REQ_QUIET)) {
 				scmd_printk(KERN_INFO, cmd,
-					   "Device not ready.\n");
+					   "Device not ready: ");
+				scsi_print_sense_hdr("", &sshdr);
+			}
+			=09
 			scsi_end_request(cmd, 0, this_count, 1);
 			return;
 		case VOLUME_OVERFLOW:


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
