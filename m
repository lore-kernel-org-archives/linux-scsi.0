From: Mayuresh Chitale <mchitale@apm.com>
Subject: SIL3132 APM X-gene 1 timeout error
Date: Wed, 21 Oct 2015 13:54:55 +0530
Message-ID: <CAL-zptOg0sEG-1B9AyMLaTxBi+n5suFF0BdYuHhmvj-C24QFNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:32816 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbbJUIY4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 04:24:56 -0400
Received: by obbwb3 with SMTP id wb3so35227023obb.0
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 01:24:56 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, tj@kernel.org

Hi All,

I am seeing the following messages during boot up of latest kernel
image on APM X-Gene 1 Mustang board with sil3132 card plugged in and 2
disks connected. Similar messages are also seen during dd/xdd
operations. This happens even when libata.force=noncq parameter is set
on command line. No errors are seen with a single disk.

Populating /dev using udev: udevd[867]: starting version 182
ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
ata1.00: failed command: READ FPDMA QUEUED
ata1.00: cmd 60/08:00:88:03:00/00:00:00:00:00/40 tag 0 ncq 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1: hard resetting link
ata2.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x6 frozen
ata2.00: failed command: READ FPDMA QUEUED
ata2.00: cmd 60/08:00:80:07:40/00:00:1f:00:00/40 tag 0 ncq 4096 in
         res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2.00: status: { DRDY }
ata2.00: failed command: READ FPDMA QUEUED
ata2.00: cmd 60/08:08:80:5f:38/00:00:3a:00:00/40 tag 1 ncq 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2.00: status: { DRDY }
ata2: hard resetting link
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
ata1: spurious interrupt (slot_stat 0x0 active_tag -84148995 sactive 0x1)
ata1.00: configured for UDMA/100
ata1.00: device reported invalid CHS sector 0
ata1: EH complete
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
ata2.00: failed to read native max address (err_mask=0x3)
ata2.00: HPA support seems broken, skipping HPA handling
ata2.00: revalidation failed (errno=-5)
ata2: hard resetting link
ata2: controller in dubious state, performing PORT_RST
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
ata2.00: configured for UDMA/100
ata2.00: device reported invalid CHS sector 0
ata2.00: device reported invalid CHS sector 0
ata2: EH complete
done

The PCIe analyser capture does not show any errors but displaying
Sil3132 port command error register in sil24_error_intr shows a value
of 6 (DIRECTIONERROR) or 7 (UNDERRUNERROR).  The sil data sheet
mentions that it supports a direct command transfer method and I
wanted to use that to see if that makes any difference. But it looks
like the driver doesn't support this method. Is that correct? I was
wondering if anyone has faced a similar issue with the sil3132 card.
