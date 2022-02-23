Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBEDC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 22:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbiBWWsJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 17:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244242AbiBWWsA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 17:48:00 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0504550E
        for <linux-scsi@vger.kernel.org>; Wed, 23 Feb 2022 14:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645656450; x=1677192450;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FrJAGwZeYWHfXv1AsM+/sIsLnOvd7cITvSK6RBGROv4=;
  b=LJT1cKIfgs+ZRND2KKk+b9QLpsReeaNaOWuIW5l2TyVKuy6nMa61D6IZ
   Stzg8MzSR3cHVTCsJ2nKCWI2rSsxPEZVGXEasFZ0jCS/ccxshlCCukgRg
   tBFgFWZbEQhBeOtpFIQSWxLuD0h5iolPqupminhSa9tUihUseViuf4agT
   3GzKyms9Dx0kRPWluTtwS5vZoyaYQalG5TiO1UJpKKVFkDhVPxR3d4ykW
   ylvbJ8vg1tWHEXE/OqluskZeTnc6l7LP1coIML2pa7o6vFvnoq5t9NxoS
   9hmItmFuzFbw8jCu63iGEbXMTT+yQCWiShX4sPOFUiHDa0MgsuXbe86s4
   g==;
X-IronPort-AV: E=Sophos;i="5.88,392,1635177600"; 
   d="scan'208";a="305700899"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Feb 2022 06:47:28 +0800
IronPort-SDR: exVj/QcSa5j0937KVYld5fMmqgqfKQNsM+VM+tl5e69Ko9NJn7V8N1KsoiJi8v7uo/WRRcFodz
 cFdFNAM4E9FIkLg6kkHtJQJFnkCM75cp0/nuH2HzbO3EV9fhnLAvHiNtnuZhd18xCpcQ+ehuzr
 t3rh+YYIEjJCmSVwfCRGNK4tSJX2bX1yniQgwtfeYAAksCjBKxnbJ9RXc7bPf5MatobZYXIWz+
 sX6bD/F03qT4GaK6lDRMGP5nMrYgQ6nHBB1my/kxx2rZd5U7U4zgVbZgtILeabVTmLI0Q9d71J
 QaFN760wgtDcz5Mwnn1CA5C3
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 14:18:59 -0800
IronPort-SDR: HJL/YRhvqLpruuE8RuySAbO7MPkURF14IKRzURthKSCkRIMFKsaxOS23HXQpqit02Qi5JNNwcv
 JMB1sdsGpxVT2+4ZVJwC00LkS1SvqnVNh9Qxr3seVEp9D7IRxFPYUSCp0O6D1BijWxetc0e2SI
 LIpUuDCYuTYL6Ocvw0IINtKQHfQCh1nE7HPVrL3h7ipHwE9zm+dIfh+MP7gbU4odj2xzSlIf/r
 UYAT5qbW7k/1BxXNXj//IuAtdUwly6cGAI9LG7ETvOgz7DdeLUpuT3y5zV8OwiFp45EqyeIkS6
 YWE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 14:47:29 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K3rlN054Gz1SVnx
        for <linux-scsi@vger.kernel.org>; Wed, 23 Feb 2022 14:47:27 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645656447; x=1648248448; bh=FrJAGwZeYWHfXv1AsM+/sIsLnOvd7cITvSK
        6RBGROv4=; b=tPny8VZKoG1MGnyhSzapEA9qNskBayg2XnJOGLmByz53wjPCTDO
        POPaLtSLzl/ZPl+QP04dykbSE25MvX3c1PtdHUaicRLrzJQPdDAHoQ9ByPhUPYC7
        AaoCW79tGOSDP0Y0B+MRRWkljsBS/i4t59T5GnWExyuQ7DnPMcoWeHzAt0xqQzv/
        vPgIh4TyBOHd8KTm+ZYv116h8kJm5THnv+i8YvsRER+EK9k85nNoe5c3woRxIk2G
        mk2/6I0n4Eg1nBOecFFiv6Z0SUZBqPwtWwAx+7bcB7SOWnb2avdMCp8tQFVzi3nb
        2r0m+Pa8GGSYI/wwakqQTLNK9DiiWuMpBSg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vzS-pyo31orX for <linux-scsi@vger.kernel.org>;
        Wed, 23 Feb 2022 14:47:27 -0800 (PST)
Received: from [10.225.163.81] (unknown [10.225.163.81])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K3rlL5YVrz1Rvlx;
        Wed, 23 Feb 2022 14:47:26 -0800 (PST)
Message-ID: <1d41eaea-f2ef-6af1-e1d1-c588286fe338@opensource.wdc.com>
Date:   Thu, 24 Feb 2022 07:47:25 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: sd: Unaligned partial completion
Content-Language: en-US
To:     dgilbert@interlog.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     SCSI development list <linux-scsi@vger.kernel.org>
References: <ae40bef0-702f-04c4-9219-47502c37d977@interlog.com>
 <yq11qzyh4zj.fsf@ca-mkp.ca.oracle.com>
 <22a343a6-f659-3938-b83e-a3842486bbb8@interlog.com>
 <yq1r17ub8fi.fsf@ca-mkp.ca.oracle.com>
 <55661371-3526-36e8-5743-c59a75a5374c@interlog.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <55661371-3526-36e8-5743-c59a75a5374c@interlog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/24/22 06:37, Douglas Gilbert wrote:
> On 2022-02-22 22:27, Martin K. Petersen wrote:
>>
>> Douglas,
>>
>>> No, of course not. But the kernel should inspect all UAs especially
>>> the one that says: CAPACITY DATA HAS CHANGED !
>>
>> It does. And uses it to emit an event to userland.
>>
>> In most cases when capacity has changed it is because the user grew
>> their LUN. And doing the right thing in that case is to let userland
>> decide how to deal with it.
>>
>> You could argue that the kernel should do something if the device
>> capacity shrinks. But it is unclear to me what "the right thing" is in
>> all cases. What if there is not a mounted filesystem in the affected
>> block range? Maybe the reduced block range it is not even described by
>> an entry in the partition table? Should we do something? How does SCSI
>> know how much of the capacity is actively in use, if any? Also, what's a
>> partition?
>>
>> In addition, given our experience with NVMe devices which, for $OTHER_OS
>> reasons, truncated their capacity when they experienced media problems,
>> I am not sure we want to encourage anybody ever going down this
>> path. What a mess!
> 
> But this misses my point. sbc5r01.pdf says this:
> 
>    "If the device server supports changing the block descriptor parameters
>     by a MODE SELECT command and the number of logical blocks or the
>     logical block length is changed, then the device server establishes
>     a unit attention condition of:
>        a) CAPACITY DATA HAS CHANGED as described in 4.10; and
>        b) MODE PARAMETERS CHANGED as described in SPC-6.
> 
> My point is: if "the logical block length is changed" then the sd driver
> can NOT reliably issue any IO commands (READ or WRITE) until it does a
> READ CAPACITY command to find out whether the LB size has changed, and
> if so, to what.
> 
>>> Also more and more settings in SCSI *** are giving the option to
>>> return an error (even MEDIUM ERROR) if the initiator is reading a
>>> block that has never been written. So if the sd driver is looking for
>>> a partition table (LBA 0 ?)  then you have a chicken and egg problem
>>> that retrying will not solve.
>>
>> For a general purpose OS it is completely unreasonable to expect that
>> the OS has prior knowledge about which blocks were written. How is that
>> even supposed to work if you plug in a USB drive from a different
>> machine/OS? It also breaks the notion of array disks being
>> self-describing which is now effectively an industry requirement.
>>
>> I am very happy to take patches that prevent us from retrying forever
>> when a device is being disagreeable. But I am also very comfortable with
>> the notion of not bothering to support devices that behave in a
>> nonsensical way. Just because the SCSI spec allows something doesn't
>> mean we should support it.
>>
>>> The sd driver should take its lead from SBC, not ZBC.
>>
>> The sd driver is the driver for both protocols.
> 
> This "unaligned" usage seems to come from ZBC and first appeared in
> SPC-4, ASC/ACSQ code [0x21,0x4]: "Unaligned WRITE command". It is
> the only use of the word "unaligned" in SPC-4, SPC-5 and spc6r06.pdf
> and it is not defined (in those documents) or in the SBC specs.
> Surprisingly it is used, but not defined in zbc2r12.pdf .
> 
> To me "unaligned" means some sort of transport issue which this is
> not ***. It simply means the WRITE was not issued with a starting
> LBA which corresponded to that zone's write pointer. This is
> for "sequential write required" (swr)zones. IMO the ASC message
> should be akin to: "Sequential write requirement violated".
> 
> Until Linux utilities catch up with zoned disks, users of zoned
> disks are going to see a lot of that "unaligned"  error! Currently
> you can't partition a zoned disk because those utilities try to
> WRITE shadow copies further out on the disk and violate the
> write pointer settings of swr zones (then crash and burn).
> You can create a BTR file system on a whole zoned disk (e.g. /dev/sdb)
> but only if you have a recent enough btrfs-prog package ****. Any
> Debian user caught in this bind, try using the binary Sid package at:
>      https://packages.debian.org/sid/btrfs-progs
> 
> 
> Life is a little easier fo ZBC/ZAC zoned disks which typically
> start with conventional (normal random WRITE capable) zones (for 1%
> of the available storage) before the swr zones commence. ZNS (for
> NVMe) doesn't support conventional zones.
> 
> Doug Gilbert
> 
> 
> ***  well where sd.c generated that "unaligned" error it was because
>       it tried to READ one block at LBA 0 and thought it was 4096
>       bytes long. It wasn't (due to a MODE SELECT) so it got back
>       512 bytes. Is that an alignment error ??

Personally, I consider it as such because the retry to process the
remaining will necessarily fail, or worse, do bad things to the drive
sectors, since the addressing is off by a factor of 8. Retrying the
remaining of any of these "unaligned" commands is dangerous. For a read,
this can lead to data leaks, and for a write, that can destroy the FS on
the disk.

> 
> **** building btrfs-prog from its github source is not a pleasant
>       experience, IMO


-- 
Damien Le Moal
Western Digital Research
