Return-Path: <SRS0=AwsL=WE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66760C433FF
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 08:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F4DB2173C
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 08:42:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Dt0bwRV7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730722AbfHHIma (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 04:42:30 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:51998 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfHHIma (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 04:42:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565253750; x=1596789750;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=I0hTHuDiR37tNOspHOOVjlBxb4Dy+b8X+sXXcFd2qWE=;
  b=Dt0bwRV7bMfLq72T3n26yRAZdOtr60nEO46bfKgaVqb4t8OtVydQB984
   pl7FwVV63ikrMuKP7n/qyNzlG75cB7rqq9Si6s26xXeDGRRmMlfAD/YOF
   hHmHIN72vkEkPQYRRd7/V7aX4wRKyxqt9qBzoBLJu9Myu8P4smqG5sdtz
   sn/1rYam7u1hdtkKm5B4tgzFH8uEY0AtUTH2PrDs8efNJufZPiDJRv71F
   LuEyRW1iJZRGZMtTLbQg/A1499Bi4U7Pl/6pc/Rp1qVJmVCIUZg4J2/fo
   hoCij/PmDuExFieXPLlq+bBs0Yw+MYk8bjPIrFEeNAbvrEjBvwWK7fqMo
   Q==;
IronPort-SDR: fkw5HZoZgCwDZN0MBzMOHtYZ8qcpKUBCttBEuGx1IZ0xMPUfhBpbCdf5M7yPecsgoOmQZydVfT
 wM3QmNsOe3zwGEOX+cb9LlGfF+KejIP/D5+1ACKymBWIFdcYqSFDNhOuaPrhfzth4OTkk7Gka4
 8cJpcmWqNz8AWPr+0xySH8s/sOZt0IQs6Qj7cAjEvRcMqF41qDZSy/C+vQDn1uerpZ9SSB1QjT
 wQMQuPMgf64tI1cjafFJy/VnfmIXhmQyFOsl7YebDhcGBn4tVgllAjzKO+xntCIzu+YLmolaDA
 8kM=
X-IronPort-AV: E=Sophos;i="5.64,360,1559491200"; 
   d="scan'208";a="119965685"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2019 16:42:23 +0800
IronPort-SDR: KsjLFhczKbdmBLXRDm1t7NtkblW8CUMoQZ+c1tu5UKAjBFg2WULyf94TApcWKlE3n2Ts8OF1Gb
 RlCsSqG0ItawcIyPdIl0lPZlfxkNs5fZ8BltAUC4mpma66BDSurKnQmy3MN0Q+RabGB7Nsxrm4
 kVnRNrijbCA/NrXiOWaVybu8+/yMZ/JQNPnzSDzLSPXdCr1nB7YYi7YKhX/9i2VMsRKs+EKmuD
 zjmOj0XpaX2khZ3bns+zk8F5BzS9romb8Onb9x5IcPUy+/JXgd+0K/VJYjWGUy/9ZDAc+acPwg
 Q1DOUE+YUE3+EnuIoTPxlLOY
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 01:40:07 -0700
IronPort-SDR: bK/b11V60DjQRhE6Jmi31Vt0Uf5+x+E1XeJzbyiIPAV5Me1hX9jfgis5ktVZ19k9xno8FYlIRh
 0GPyMmAakteboqdnLr7y76DA1fyEDk2E11xJiQ6yE+RsHGIRVMgaszCCee4AUUyyWwc5BAFmcV
 XM5shTQWC2BQr5jGgQCmq5whhR1Fxp+cpw4JDVpS9zC4PetJwRLQJDWOeg8UWMrvqdSjaRnvfk
 8Cy8UwGNjBsXjrjcCyDmJ0d8lIgF9eu1JMDW0/miB7fvqN9HpZC/Wb20uu4qAOEThUPWIaKn8H
 070=
Received: from naota.dhcp.fujisawa.hgst.com ([10.149.53.115])
  by uls-op-cesaip01.wdc.com with SMTP; 08 Aug 2019 01:42:23 -0700
Received: (nullmailer pid 4102131 invoked by uid 1000);
        Thu, 08 Aug 2019 08:42:21 -0000
Date:   Thu, 8 Aug 2019 17:42:21 +0900
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     Mike Christie <mchristi@redhat.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: target/tcm_loop: update upper limit of LUN
Message-ID: <20190808084221.agvnr5yflxzdvtgh@naota.dhcp.fujisawa.hgst.com>
References: <20190805062313.343221-1-naohiro.aota@wdc.com>
 <5D485A56.9070208@redhat.com>
 <20190806024505.gpabcyu57vhvnrto@naota.dhcp.fujisawa.hgst.com>
 <5D49BBFC.7020402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5D49BBFC.7020402@redhat.com>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 06, 2019 at 12:42:20PM -0500, Mike Christie wrote:
>On 08/05/2019 09:45 PM, Naohiro Aota wrote:
>> On Mon, Aug 05, 2019 at 11:33:26AM -0500, Mike Christie wrote:
>>> On 08/05/2019 01:23 AM, Naohiro Aota wrote:
>>>> targetcli-fb (or its library: rtslib-fb) allows us to create LUN up to
>>>> 65535. On the other hand, the kernel driver is limiting max_lun to 0.
>>>>
>>>> This limitation causes an actual problem when you delete a loopback
>>>> device
>>>> (using /sys/class/scsi_device/${lun}/device/delete) and rescan it (using
>>>> /sys/class/scsi_host/host${h}/scan). You can delete the device, but
>>>> cannot
>>>> rescan it because its LUN is larger than the max_lun and so the scan
>>>> request results in -EINVAL error in scsi_scan_host_selected().
>>>
>>> How are you kicking off this rescan?
>>>
>>> Just to make sure I understood you, does the initial LU have LUN 0, you
>>> delete that, then are you creating another LU with a LUN value that is
>>> not 0?
>>
>> Not exactly. I'm working on a case multiple device is added at once to
>> one loopback scsi host. You can create two or more device using
>> "targetcli" command and they may have their LUN larger than 0. For
>> example,
>>
>> $ sudo targetcli
>> /backstores/fileio> cd /loopback
>> /loopback> create
>> Created target naa.5001405218077d66.
>> /loopback> exit
>> $ sudo truncate -s 1048576 /mnt/nvme/foo{1,2,3}
>> $ sudo targetcli /backstores/fileio create name=foo1
>> file_or_dev=/mnt/nvme/foo1
>> Created fileio foo1 with size 1048576
>> $ sudo targetcli /loopback/naa.5001405218077d66/luns create
>> /backstores/fileio/foo1
>> Created LUN 0.
>> (Do the same above for foo2 and foo3)
>>
>> Then, you'll see each of them has LUN 0, 1, 2 assigned: (rtslib scans
>> used LUN and assign free one)
>>
>> $ lsscsi
>> ...
>> [7:0:1:0]    disk    LIO-ORG  foo1             4.0   /dev/sdd
>> [7:0:1:1]    disk    LIO-ORG  foo2             4.0   /dev/sde
>> [7:0:1:2]    disk    LIO-ORG  foo3             4.0   /dev/sdf
>>
>> Now, you can delete one of these device:
>>
>> $ echo 1 > /sys/class/scsi_device/7\:0\:1\:2/device/delete
>> $ lsscsi
>> ...
>> [7:0:1:0]    disk    LIO-ORG  foo1             4.0   /dev/sdd
>> [7:0:1:1]    disk    LIO-ORG  foo2             4.0   /dev/sde
>>
>> But, you cannot recover it by the scanning:
>>
>
>Why are you using the scsi sysfs interface instead of the target
>configfs interface?

Xfstests btrfs/003 uses the SCSI sysfs interface to emulate missing block device. We can use any SCSI devices to run the test case, so we cannot use target configfs here.

Even the end result of missing "/dev/sd?" is the same, they are two distinct interfaces. So, we need to fix the broken result of the SCSI sysfs interface anyway?

>I know the comment for max_lun says it wants to support 1 LUN, but the
>code like in tcm_loop_port_link seems to support multiple LUNs, so your
>patch looks like it could be ok. I would just set max_luns to the kernel
>(scsi-ml/lio) limit and not some userspace value.

Hm, taking look at the code (target_fabric_make_lun), there is no upper limit check there. So, set max_lun = U64_MAX right?
I once considered that but when I create LUN larger than 65535, "targetcli ls" died complaining "LUN must be 0 to 65535". So I used 65536 here.

Or, should we use max_lun = U64_MAX and fix userland side? They need to be the same, anyway, I believe...

>I think the only problem you might have with your patch is that if you
>delete the device via the scsi sysfs interface you will not be able to
>unmap the LUN from LIO until you add it back due to tcm_loop_port_unlink
>failing to look up the device and being able to decrement the tpg refcount.

Ah, I didn't notice that point. I'll address that and send a new version.

Regards,
