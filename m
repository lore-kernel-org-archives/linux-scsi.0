From: Victor Helmholtz <victor.helmholtz@gmail.com>
Subject: Problem with HDDs getting dropped from RAID
Date: Wed, 26 Apr 2017 12:13:37 +0100
Message-ID: <600B745D-3E3E-4819-8715-65CA43E4875D@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:34113 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1036253AbdDZLNl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Apr 2017 07:13:41 -0400
Received: by mail-wr0-f172.google.com with SMTP id l9so21430971wre.1
        for <linux-scsi@vger.kernel.org>; Wed, 26 Apr 2017 04:13:40 -0700 (PDT)
Received: from [192.168.1.124] (cpc87197-aztw31-2-0-cust114.18-1.cable.virginm.net. [82.45.11.115])
        by smtp.gmail.com with ESMTPSA id d25sm22531326wrd.54.2017.04.26.04.13.38
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 26 Apr 2017 04:13:39 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have a problem with drives in my RAID. Some of drives are getting =
disconnected whenever I am trying to write significant amount of data to =
the array.

My problematic RAID6 consisting of 7 drives:
 * 2 x WDC WD15EADS-22P8B0
 * 5 x SAMSUNG HD154UI

The drives are connected through HP SAS expander to LSI SAS 9201-16i. =
The raid device is encrypted using cryptsetup (cryptsetup --cipher =
aes-xts-plain64 --key-size 256 --key-file ./keyN.bin open --type plain =
/dev/mdN cN) and the filesystem I am using on top of it is ext4. I am =
running Debian jessie with linux kernel from backports (4.9.0-1-amd64 #1 =
SMP Debian 4.9.6-3 (2017-01-28) x86_64 GNU/Linux).

The filesystem on the array was mostly full (500 GB free out of 7500 GB) =
and the data was an archived data for which I have a backup. They array =
worked fine for reading but whenever I tried writing to the filesystem =
any significant amount of data (more than 20GB - 100GB) the drives got =
dropped from the array.

I thought that one of the disks might be failing so I ran badblocks =
(badblocks -wsv /dev/sdX) on each of the drives (simultaneously for all =
of them) and none of the drives reported any error. I check the =
S.M.A.R.T. reports and they don't look bad either. I have recorded =
kernel messages during one of the incidents:

[22148.047650] mpt2sas_cm0: log_info(0x31120b10): originator(PL), =
code(0x12), sub_code(0x0b10)
(Previous message repeated multiple times...)
[22159.797403] mpt2sas_cm0: log_info(0x31120b10): originator(PL), =
code(0x12), sub_code(0x0b10)
[22175.047239] mpt2sas_cm0: log_info(0x31111000): originator(PL), =
code(0x11), sub_code(0x1000)
(Previous message repeated multiple times...)
[22273.046355] mpt2sas_cm0: log_info(0x31111000): originator(PL), =
code(0x11), sub_code(0x1000)
[22273.046437] sd 0:0:6:0: [sdg] tag#2 FAILED Result: =
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
[22273.046441] sd 0:0:6:0: [sdg] tag#2 CDB: Write(10) 2a 00 86 93 fa e8 =
00 04 00 00
[22273.046448] blk_update_request: I/O error, dev sdg, sector 2257844968
[22273.046713] sd 0:0:6:0: [sdg] tag#1 FAILED Result: =
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
[22273.046715] sd 0:0:6:0: [sdg] tag#1 CDB: Write(10) 2a 00 86 93 f6 e8 =
00 04 00 00
[22273.046717] blk_update_request: I/O error, dev sdg, sector 2257843944
[22273.047830] sd 0:0:6:0: [sdg] tag#19 FAILED Result: =
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
[22273.047832] sd 0:0:6:0: [sdg] tag#19 CDB: Write(10) 2a 00 86 93 fe e8 =
00 04 00 00
[22273.047833] blk_update_request: I/O error, dev sdg, sector 2257845992
[22297.545811] mpt2sas_cm0: log_info(0x31111000): originator(PL), =
code(0x11), sub_code(0x1000)
(Previous message repeated multiple times...)
[22297.545874] mpt2sas_cm0: log_info(0x31111000): originator(PL), =
code(0x11), sub_code(0x1000)
[22297.545883] sd 0:0:6:0: [sdg] tag#24 FAILED Result: =
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
[22297.545890] mpt2sas_cm0: log_info(0x31111000): originator(PL), =
code(0x11), sub_code(0x1000)
[22297.545893] sd 0:0:6:0: [sdg] tag#24 CDB: Write(10) 2a 00 86 94 12 e8 =
00 04 00 00
[22297.545896] mpt2sas_cm0: log_info(0x31111000): originator(PL), =
code(0x11), sub_code(0x1000)
[22297.545898] blk_update_request: I/O error, dev sdg, sector 2257851112
[22297.545905] mpt2sas_cm0: log_info(0x31111000): originator(PL), =
code(0x11), sub_code(0x1000)
(Previous message repeated multiple times...)
[22297.546029] mpt2sas_cm0: log_info(0x31111000): originator(PL), =
code(0x11), sub_code(0x1000)
[22297.546062] sd 0:0:6:0: [sdg] tag#16 FAILED Result: =
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
[22297.546066] sd 0:0:6:0: [sdg] tag#16 CDB: Write(10) 2a 00 86 94 02 e8 =
00 04 00 00
[22297.546069] blk_update_request: I/O error, dev sdg, sector 2257847016
[22297.546070] sd 0:0:6:0: [sdg] tag#23 FAILED Result: =
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
[22297.546073] sd 0:0:6:0: [sdg] tag#23 CDB: Write(10) 2a 00 86 94 0e e8 =
00 04 00 00
[22297.546074] blk_update_request: I/O error, dev sdg, sector 2257850088
[22297.546160] sd 0:0:6:0: [sdg] tag#22 FAILED Result: =
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
[22297.546162] sd 0:0:6:0: [sdg] tag#22 CDB: Write(10) 2a 00 86 94 0a e8 =
00 04 00 00
[22297.546163] blk_update_request: I/O error, dev sdg, sector 2257849064
[22297.546272] sd 0:0:6:0: [sdg] tag#19 FAILED Result: =
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
[22297.546274] sd 0:0:6:0: [sdg] tag#19 CDB: Synchronize Cache(10) 35 00 =
00 00 00 00 00 00 00 00
[22297.546277] sd 0:0:6:0: [sdg] tag#21 FAILED Result: =
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
[22297.546280] blk_update_request: I/O error, dev sdg, sector 2064
[22297.546281] sd 0:0:6:0: [sdg] tag#21 CDB: Write(10) 2a 00 86 94 06 e8 =
00 04 00 00
[22297.546283] blk_update_request: I/O error, dev sdg, sector 2257848040
[22297.546326] md: super_written gets error=3D-5
[22297.546330] md/raid:md1: Disk failure on sdg1, disabling device.
md/raid:md1: Operation continuing on 6 devices.
[22297.546416] sd 0:0:6:0: [sdg] tag#20 FAILED Result: =
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
[22297.546418] sd 0:0:6:0: [sdg] tag#20 CDB: Write(10) 2a 00 86 94 6a e8 =
00 01 18 00
[22297.546419] blk_update_request: I/O error, dev sdg, sector 2257873640
[22297.546493] sd 0:0:6:0: [sdg] tag#18 FAILED Result: =
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
[22297.546494] sd 0:0:6:0: [sdg] tag#18 CDB: Write(10) 2a 00 86 94 66 e8 =
00 04 00 00
[22297.546495] blk_update_request: I/O error, dev sdg, sector 2257872616
[22297.546609] sd 0:0:6:0: [sdg] tag#17 FAILED Result: =
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
[22297.546610] sd 0:0:6:0: [sdg] tag#17 CDB: Write(10) 2a 00 86 94 62 e8 =
00 04 00 00
[22297.546611] blk_update_request: I/O error, dev sdg, sector 2257871592
[22297.546715] sd 0:0:6:0: [sdg] tag#15 FAILED Result: =
hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK
[22297.546716] sd 0:0:6:0: [sdg] tag#15 CDB: Write(10) 2a 00 86 94 5e e8 =
00 04 00 00
[22297.546717] blk_update_request: I/O error, dev sdg, sector 2257870568
[22322.045468] mpt2sas_cm0: log_info(0x31111000): originator(PL), =
code(0x11), sub_code(0x1000)

It looks to me like the problem is somewhere in HBA driver but I guess =
it might as well be a problem with md or dm-crypt. Could anybody advice =
on how to solve this problem? Is it possible to enable more verbose =
debug output from kernel and drivers?

Thanks
Victor=
