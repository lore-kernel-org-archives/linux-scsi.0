From: yang jun <yangjun.donglife123@gmail.com>
Subject: [SCSI] sr: sr_mutex hurts multi-drive performance
Date: Sun, 27 Oct 2013 18:15:50 +0800
Message-ID: <CAO4Pk4yky7xOxBucvLXX8JMxNk=HsKsf2ermCrf_VimXumhfBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f194.google.com ([209.85.214.194]:44810 "EHLO
	mail-ob0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3J0KPu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Oct 2013 06:15:50 -0400
Received: by mail-ob0-f194.google.com with SMTP id vb8so681516obc.1
        for <linux-scsi@vger.kernel.org>; Sun, 27 Oct 2013 03:15:50 -0700 (PDT)
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
