From: Grant Grundler <grundler@chromium.org>
Subject: sd_done and WRITE_SAME broken?
Date: Thu, 24 Sep 2015 12:08:04 -0700
Message-ID: <CANEJEGuhqKXQVPTK4fn8BxBzn-tnu6mC11GviGJbEOEd8nTH9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:36619 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbbIXTIG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2015 15:08:06 -0400
Received: by ykdt18 with SMTP id t18so93789777ykd.3
        for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2015 12:08:05 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

drivers/scsi/sd.c

1706                 if (sshdr.asc == 0x20 || sshdr.asc == 0x24) {
1707                         switch (op) {
1708                         case UNMAP:
1709                                 sd_config_discard(sdkp, SD_LBP_DISABLE);
1710                                 break;
1711                         case WRITE_SAME_16:
1712                         case WRITE_SAME:
1713                                 if (unmap)
1714                                         sd_config_discard(sdkp,
SD_LBP_DISABLE);
1715                                 else {
1716                                         sdkp->device->no_write_same = 1;
1717                                         sd_config_write_same(sdkp);
1718
1719                                         good_bytes = 0;
1720                                         req->__data_len =
blk_rq_bytes(req);
1721                                         req->cmd_flags |= REQ_QUIET;
1722                                 }
1723                         }
1724                 }

line 1720 is assigning the same value to same field in same req.
That's probably not what was intended but I don't know what is needed
here.

cheers,
grant
