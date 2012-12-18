From: =?UTF-8?B?TWljaGHFgiBNaXN6ZXdza2k=?= <michal.miszewski@gemius.com>
Subject: megaraid_sas: problem with specific hardware only with kernel 3.2.5
 and above
Date: Tue, 18 Dec 2012 17:07:27 +0100
Message-ID: <50D094BF.7000701@gemius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eithel.gem.pl ([85.232.225.132]:58640 "EHLO eithel.gem.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab2LRQp3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Dec 2012 11:45:29 -0500
Received: from localhost ([127.0.0.1] helo=[172.16.211.51])
	by eithel.gem.pl with esmtpa (Exim 4.69 (FreeBSD))
	(envelope-from <michal.miszewski@gemius.com>)
	id 1TkzhY-000Gh3-GI
	for linux-scsi@vger.kernel.org; Tue, 18 Dec 2012 17:07:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

megaraid_sas driver fails to initialize the storage controller on
some Intel platforms. The issue concerns at least the following hardwar=
e:

Intel Server System R2000IP, which includes:
- Intel Server Board S2600IP4
- Intel Integrated RAID Module RMS25CB080 with RES2SV240 RAID Expander =
Card

The RAID module is listed by lspci as:
01:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 220=
8
[Thunderbolt] (rev 03)

By trying different kernels, we found out, that the problem occurs with
3.2.5 and newer versions. The problem doesn't occur with kernel 3.2.4=20
and older.

On kernel version 3.2.5 the output is:

   megasas: 00.00.06.12-rc1 Wed. Oct. 5 17:00:00 PDT 2011
   megasas: 0x1000:0x005b:0x8086:0x3513: bus 1:slot 0:func 0
   megaraid_sas 0000:01:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 2=
6
   megaraid_sas 0000:01:00.0: setting latency timer to 64
   megasas: Waiting for FW to come to ready state
   megasas: FW in FAULT state!!

On kernel 3.2.4:

   megasas: 00.00.06.12-rc1 Wed. Oct. 5 17:00:00 PDT 2011
   megasas: 0x1000:0x005b:0x8086:0x3513: bus 1:slot 0:func 0
   megaraid_sas 0000:01:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 2=
6
   megaraid_sas 0000:01:00.0: setting latency timer to 64
   megasas: FW now in Ready state

The 3.2.5 introduces only one modification:

"PCI: Rework ASPM disable code"
(commit 3c076351c4027a56d5005a39a0b518a4ba393ce2)

It looks like this change in kernel behavior for mainboards that don't
report the support for ASPM has impact on the SAS controller
itself, its' firmware or further communication between the driver and
hardware.

We tried the following firmware versions from Intel:
- 23.9.0-0018 (dated 2012-11-17)
- 23.7.0-0033 (the current one)

I can collect more information about the hardware, boot logs etc. and
test the provided patches according to your directions.

Thanks in advance for any help with this issue.

--=20
Micha=C5=82 Miszewski
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
