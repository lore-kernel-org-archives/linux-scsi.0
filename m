From: Douglas Gilbert <dougg@torque.net>
Subject: strange ide-cd MODE_SENSE response [2.6.8.1]
Date: Tue, 17 Aug 2004 12:54:01 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41217349.4060302@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub2.uq.edu.au ([130.102.149.128]:37133 "EHLO
	mailhub2.uq.edu.au") by vger.kernel.org with ESMTP id S268164AbUHQITY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 04:19:24 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: axboe@suse.de

In lk 2.6.8.1 (and 2.6.7) if a MODE_SENSE (6 byte variant) is sent
to an "ide-cd" device (e.g. /dev/hdc) then it responds with a
"CONDITION MET" SCSI status and no sense buffer.

According to MMC, MODE_SENSE (6) is not supported. In this case a
polite SCSI device should set a SCSI status of "CHECK CONDITION"
with a sense key of ILLEGAL_REQUEST and appropriate ASC/ASCQ
values (i.e. operation code not supported).

The relevant code in ide-cd.c seems to be:

         /*
          * it's silly to pretend we understand 6-byte sense commands, just
          * reject with ILLEGAL_REQUEST and the caller should take the
          * appropriate action
          */
         if (c[0] == MODE_SENSE || c[0] == MODE_SELECT) {
                 rq->errors = ILLEGAL_REQUEST;
                 return BLKPREP_KILL;
         }

I couldn't see how that BLKPREP_KILL was processed.

Why have such code? I have a Yamaha SCSI cd writer that
correctly supports MODE_SENSE (6) and MODE_SENSE (10).
Support for MODE_SENSE (10) is mandatory in the MMC
standard but it would be surprising if it said a
MMC device could _not_ support MODE_SENSE (6).

The failure can be seen with the sg3_utils package and
commands like this:
    sg_modes -6 /dev/hdc
    sginfo -C -6 /dev/hdc


Doug Gilbert

