Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E80E3C33CB1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 10:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C711E24689
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 10:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732762AbgANKOa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 05:14:30 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2266 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731618AbgANKO3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jan 2020 05:14:29 -0500
Received: from LHREML710-CAH.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 5E4C7F05A0FF8FF6253B;
        Tue, 14 Jan 2020 10:14:28 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML710-CAH.china.huawei.com (10.201.108.33) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 14 Jan 2020 10:14:27 +0000
Received: from [127.0.0.1] (10.202.226.43) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Tue, 14 Jan
 2020 10:14:27 +0000
Subject: Re: How to reset HBA when using libsas/mvsas
To:     =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <CAOE4rSyVSfRRc9vFK_EM9SJMPoZD6PAmiA+2LqyFx2C26ht-6A@mail.gmail.com>
 <60f0fed7-43c7-c979-c375-d2ab4c21e141@huawei.com>
 <CAOE4rSxb9q565HLScxxWJiJ+ei8U1Fgh4XQvJuL2+VVhvqVhKg@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <716f9346-a1bb-d934-246a-5566a39a8be9@huawei.com>
Date:   Tue, 14 Jan 2020 10:14:26 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <CAOE4rSxb9q565HLScxxWJiJ+ei8U1Fgh4XQvJuL2+VVhvqVhKg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.226.43]
X-ClientProxiedBy: lhreml729-chm.china.huawei.com (10.201.108.80) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/01/2020 23:57, Dāvis Mosāns wrote:
> pirmd., 2020. g. 13. janv., plkst. 11:51 — lietotājs John Garry
> (<john.garry@huawei.com>) rakstīja:
>> If you just want to rest the disk, you can reset the PHY to which the
>> disk is attached through sysfs, which is essentially is same as ejecting
>> and reinserting the disk:
>> 2. Go to PHY sysfs folder and disable+enable the PHY:
> 
> Awesome, this works great for me.
> Thanks!
> 
> 
>>> I have tried:
>>> $ echo 1 > /sys/block/sdf/device/delete
>>> $ echo '- - -' > /sys/class/scsi_host/host0/scan
>>>
>>> but it doesn't work as it doesn't detect any new drives.
>>
>> I'm not sure if this is the correct method.
> 
> Searching on internet it's most common suggestion and I didn't saw
> anything else.
> https://unix.stackexchange.com/a/404408/51019
> .
> 

So this works on my HBA which uses libsas:

root@ubuntu:~# echo 1 > /sys/block/sdf/device/delete
root@ubuntu:~# fdisk -l
Disk /dev/sdb: 3.7 TiB, 4000787030016 bytes, 7814037168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 3875281E-32EA-404B-B0AD-FCAC27BDE061

Device         Start        End    Sectors   Size Type
/dev/sdb1       2048   14037134   14035087   6.7G Linux filesystem
/dev/sdb2   14039040  781403713  767364674 365.9G Linux filesystem
/dev/sdb3  781404160 7814037134 7032632975   3.3T Linux filesystem


Disk /dev/sdd: 279.5 GiB, 300069052416 bytes, 586072368 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sda: 186.3 GiB, 200049647616 bytes, 390721968 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 131072 bytes
Disklabel type: gpt
Disk identifier: EAFDDE26-1C4A-408E-922E-B87F73F144AE

Device       Start       End   Sectors   Size Type
/dev/sda1     2048   1050623   1048576   512M EFI System
/dev/sda2  1050624 390721535 389670912 185.8G Linux filesystem


Disk /dev/sdc: 186.3 GiB, 200049647616 bytes, 390721968 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 131072 bytes
Disklabel type: gpt
Disk identifier: 300604F0-7782-FF48-A2E8-7358D80434C8

Device       Start       End   Sectors   Size Type
/dev/sdc1     2048   1000000    997953 487.3M EFI System
/dev/sdc2  1001472   2000000    998529 487.6M Linux RAID
/dev/sdc3  2000896 390721934 388721039 185.4G Linux RAID


Disk /dev/sde: 186.3 GiB, 200049647616 bytes, 390721968 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 131072 bytes
Disklabel type: gpt
Disk identifier: 0C412946-1EFE-FD44-8EF3-246E6DCC64E6

Device       Start       End   Sectors   Size Type
/dev/sde1     2048   1000000    997953 487.3M EFI System
/dev/sde2  1001472   2000000    998529 487.6M Linux RAID
/dev/sde3  2000896 390721934 388721039 185.4G Linux RAID


Disk /dev/sdh: 186.3 GiB, 200049647616 bytes, 390721968 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 131072 bytes


Disk /dev/sdg: 186.3 GiB, 200049647616 bytes, 390721968 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 131072 bytes
root@ubuntu:~# echo '- - -' > /sys/class/scsi_host/host0/scan
[321323.142794] scsi 0:0:5:0: Direct-Access     SanDisk  LT0200MO 
  P404 PQ: 0 ANSI: 6
root@ubuntu:~# [321323.654846] sd 0:0:5:0: [sdf] 390721968 512-byte 
logical blocks: (200 GB/186 GiB)
[321323.696872] sd 0:0:5:0: [sdf] Write Protect is off
[321323.701776] sd 0:0:5:0: [sdf] Mode Sense: cf 00 10 08
[321323.778903] sd 0:0:5:0: [sdf] Write cache: disabled, read cache: 
disabled, supports DPO and FUA
[321323.901542] sd 0:0:5:0: [sdf] Optimal transfer size 131072 bytes
[321324.441562]  sdf: sdf1 sdf2 sdf3
[321325.122283] sd 0:0:5:0: [sdf] Attached SCSI disk

root@ubuntu:~#


I'm not sure what's going wrong with mvsas. The actual code for 
triggering the scan is generic.

Cheers,
John
