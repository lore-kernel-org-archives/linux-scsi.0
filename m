From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: Usage of scsi_get_lba.
Date: Tue, 1 Jun 2010 13:25:24 +0530
Message-ID: <94500BE52867E04AB51827CFE16FC752028F714B9E@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:41178 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754096Ab0FAIT2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jun 2010 04:19:28 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "Moore, Eric" <Eric.Moore@lsi.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>

I was trying to use scsi_get_lba to get the lba associated with a particular scsi_cmnd. I am able to get proper values when I send I/O through dd or FS. But when I use the sg interface either sg_dd or sg_raw the value I am getting through scsi_get_lba is not matching with the one in the CDB.

Do we need to have some change in sg module for handling this, or is there anything wrong in the way I access the scsi_get_lba or sending command through sg?

Any suggestion or help is highly appreciated.

For I/O through DD
Jun  1 20:19:14 linux-eph1 kernel: sd 16:0:1:0: [sdc] CDB: Write(10): 2a 00 00 00 00 00 00 00 08 00
Jun  1 20:19:14 linux-eph1 kernel: LBA 0x0000000000000000

For a Non Zero LBA
Jun  1 20:19:35 linux-eph1 kernel: sd 16:0:1:0: [sdc] CDB: Write(10): 2a 00 00 00 0f f8 00 00 08 00
Jun  1 20:19:35 linux-eph1 kernel: LBA 0x0000000000000ff8

For I/O through sg_dd
Jun  1 20:19:45 linux-eph1 kernel: sd 16:0:1:0: [sg2] CDB: Write(10): 2a 00 00 00 0f ff 00 00 01 00
Jun  1 20:19:45 linux-eph1 kernel: LBA 0xffffffffffffffff

Jun  1 20:20:26 linux-eph1 kernel: sd 16:0:1:0: [sg2] CDB: Write(10): 2a 00 00 00 0f f8 00 00 08 00
Jun  1 20:20:26 linux-eph1 kernel: LBA 0xffffffffffffffff

Kernel Version
Linux linux-eph1 2.6.34-rc3-00626-gcee693e-dirty #3 SMP Mon May 24 16:41:33 IST 2010 x86_64 x86_64 x86_64 GNU/Linux

Thanks
Sathya


