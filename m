From: miyoshi@hpc.bs1.fc.nec.co.jp
Subject: [HELP] qla2200 driver over 4G memory
Date: Wed, 19 Jun 2002 19:02:28 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020619190228S.miyoshi@hpc.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgate4.nec.co.jp ([10.7.69.193])
	by TYO202.gate.nec.co.jp (8.11.6/3.7W01080315) with ESMTP id g5JA0me07608
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2002 19:00:48 +0900 (JST)
Received: from mailsv4.nec.co.jp (mailgate51.nec.co.jp [10.7.69.196]) by mailgate4.nec.co.jp (8.11.6/3.7W-MAILGATE-NEC) with ESMTP
	id g5JA0km03529 for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2002 19:00:47 +0900 (JST)
Received: from mailsv.bs1.fc.nec.co.jp (venus.d2.bs1.fc.nec.co.jp [10.34.77.164]) by mailsv4.nec.co.jp (8.11.6/3.7W-MAILSV4-NEC) with ESMTP
	id g5JA0j200929 for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2002 19:00:45 +0900 (JST)
Received: from localhost (pingu.hpc.bs1.fc.nec.co.jp [10.34.77.220])
	by mailsv.bs1.fc.nec.co.jp (8.12.0/3.7W-HPC5.2F(mailsv)01041614) with ESMTP id g5J9tCLw022679
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2002 18:55:12 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi, all

I am using QLA2200 on my IA64 box and when I read data to
the area which strides over 4G boundaries, it seems to read
the disk data into wrap-around memory area.

I wrote small test kernel patch and read disk contents to
physical 0x1ffffc000 to 0x200013fff (0x18000 bytes.)
It reads first 16K bytes into 0x1ffffc000-0x1ffffffff correctly
but destroys 0x100000000-0x100013fff.

I checked the incorrect data contents via kdb, and also
my printk() in qla2100_64bit_start_scsi() says the address is
correctly written into request ring, as far as I understood
the driver code correctly.

Does anybody have idea?

Thanks,
