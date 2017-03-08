From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: out of range LBA using sg_raw
Date: Wed, 8 Mar 2017 19:51:54 +0530
Message-ID: <cf343e80707394b8945cd7643f7beecd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi -

Need help to understand  if below is something we should consider to be
fixed in megaraid_sas driver or call as unreal exposure.

I have created slice VD of size 10GB (raid 1) using 2 drives.  Each
Physical Drive size is 256GB.

Last LBA of the VD and  actual Physical disk associated with that VD is
different. Actual Physical disk has larger range of LBA compare VD.

Below is readcap detail of VD0

# sg_readcap /dev/sdu
Read Capacity results:
   Last logical block address=20971519 (0x13fffff), Number of
blocks=20971520
   Logical block length=512 bytes
Hence:
   Device size: 10737418240 bytes, 10240.0 MiB, 10.74 GB

Using below sg_raw command, we should see "LBA out of range" sense.  In
CDB 0x28, pass LBA beyond last lba of VD 0x13fffff.

sg_raw -r 4k /dev/sdx 28 00 01 4f ff ff 00 00 08 00

It works if VD created behind MR controller does not support Fast Path
Write.
In case of Fast Path Write, driver convert LBA of VD to underlying
Physical disk and send IO direct to the physical disk. Since Physical disk
has enough LBA range to respond, it will not send "LBA out of range
sense".

Megaraid_Sas driver never validate range of LBA for VD as it assume to be
validated by upper layer in scsi stack. Other sg_tool method like sg_dd,
sg_write, dd etc has checks of LBA range and driver never receive out of
range LBA.

What is a suggestion ? Shall I add check in megaraid_sas driver or it is
not a valid scenario as "sg_raw" tool can send any type of command which
does not require multiple sanity in driver.

Thanks, Kashyap
