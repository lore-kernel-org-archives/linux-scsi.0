From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] extracting resid from struct scsi_cmnd
Date: Sun, 28 Nov 2004 23:01:27 +1000
Message-ID: <41A9CC27.9020207@torque.net>
References: <20041127124222.GA1200@abulafia> <20041127154849.GA24460@suse.de> <41A9319F.9070206@torque.net> <20041128091201.GA10485@suse.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080501040507010807030206"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:21995 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261456AbUK1NBc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Nov 2004 08:01:32 -0500
In-Reply-To: <20041128091201.GA10485@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080501040507010807030206
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Jens Axboe wrote:
> On Sun, Nov 28 2004, Douglas Gilbert wrote:
> 
>>Jens,
>>While on the subject of extracting info from struct scsi_cmnd
>>I have noticed that scsi_cmnd::resid doesn't make it into
>>sg_io_hdr::resid in the block layer SG_IO implementation.
>>"rq->data_len" is put there instead and it invariably has a
>>value of 0.
>>
>>"struct request" does not have a 'resid' field which is defined
>>as the number of bytes requested to be transferred less the actual
>>number transferred.
> 
> 
> ->data_len is that value, after execution of the request. If rq->data_len
> == 0 for a SCSI request that with residual bytes, then that's a bug.

Jens,
Ok, it looks like a bug then. Here is an example with the
scsi_debug version I just sent to this list and a recent sg3_utils
(e.g. v1.11 beta at the top of http://www.torque.net/sg ).
That scsi_debug version sets resid and sg3_utils reports resid != 0
when the verbose flag is given.

Here is what I am seeing:

# sg_inq -v /dev/sg0
      inquiry cdb: 12 00 00 00 24 00
...
   Product identification: scsi_debug
   Product revision level: 0004
      inquiry cdb: 12 01 00 00 fc 00
      inquiry: resid=124
      inquiry cdb: 12 01 80 00 fc 00
      inquiry: resid=124
   Unit serial number: 2000

# sg_inq -v /dev/sda
      inquiry cdb: 12 00 00 00 24 00
...
   Product identification: scsi_debug
   Product revision level: 0004
      inquiry cdb: 12 01 00 00 fc 00
      inquiry cdb: 12 01 80 00 fc 00
   Unit serial number: 2000

So the sg driver indicates that of the 252 bytes
requested (for VPD pages 0x0 and 0x80) only 128 bytes
were returned [and 128 bytes is an over-allowance by
scsi_debug for those pages]. The sd driver remains silent
implying resid is 0 .

rq->data_len is only written in one place in the scsi mid level
(in scsi_io_completion() inside scsi_lib.c). The attached
patch places cmd->resid into rq->data_len (rather than decrementing
it by cmd->bufflen) and fixes the problem shown above. I then
built a file system on the scsi_debug virtual disk and copied
files to and from it and there were no ill effects.

Changelog:
    - during successful command completion place resid from SCSI
      LLDs into request::data_len so that block SG_IO ioctl reports
      resid

Doug Gilbert




--------------080501040507010807030206
Content-Type: text/x-patch;
 name="scsi_lib2610rc2resid.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_lib2610rc2resid.diff"

--- linux/drivers/scsi/scsi_lib.c	2004-11-15 20:53:03.000000000 +1000
+++ linux/drivers/scsi/scsi_lib.c2610rc2resid	2004-11-28 22:12:22.070160152 +1000
@@ -728,7 +728,7 @@
 				req->sense_len = len;
 			}
 		} else
-			req->data_len -= cmd->bufflen;
+			req->data_len = cmd->resid;
 	}
 
 	/*


--------------080501040507010807030206--
