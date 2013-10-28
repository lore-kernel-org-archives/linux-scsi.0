From: yang jun <yangjun.donglife123@gmail.com>
Subject: [SCSI] sr: sr_mutex ,multi-drive performance is bad
Date: Mon, 28 Oct 2013 22:30:58 +0800
Message-ID: <CAO4Pk4wxUN-O_m5KcdZgmTTRG2w8icqva+0dxu7HRO=rEpbArg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f193.google.com ([209.85.128.193]:53975 "EHLO
	mail-ve0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab3J1OnL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2013 10:43:11 -0400
Received: by mail-ve0-f193.google.com with SMTP id c14so752891vea.0
        for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2013 07:43:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Dear Mr.Axboe,

The latest kernel sr_module still uses single mutex,it will serialise
all sr ioctls. Otto Meta had mentioned this on Jan 1st, 2013 . Some
record tools such as growisofs use SG_IO to write data to disc, so if
there are multiple cdroms being recorded at the same time=A3=ACit will =
be
very slowly.

I saw sd_module before,it had removed BKL and made "openers" atomic_t
in scsi_disk. Shall we do the same thing to sr_module? That is, to
remove sr_mutex and make "use_count" atomic_t in cdrom_device_info.

Yours Sincerely,
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
