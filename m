Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D37CC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 22:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiGLWIM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 18:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiGLWIK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 18:08:10 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F3FBEB41
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 15:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1657663687; x=1689199687;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rwtOJ13hetNqw1SJinQMWjx0Bzi08NEomTZFMZTXnt8=;
  b=HOjEijNOfLXkk61jVxc++Ibi4ITy2sxY7VQBr2f8acRJbyCBBkPH2/Fu
   OV5YwcW/8UVForg6y7n3vSlHsHKXfgfz9lVbZsUQelwSimAeEpoQKyzue
   wGuNcu+2nWXvtW222milY0/houg0/R90uo0xuH3Pf1mMnrC9GnNe/QWAt
   DOQyswb4J1B2wJgt+h438N1XmkQHQq6m5SGduMhH3rYTijyFYrtQljqR1
   BRNceZn8jUBu+UUDOZJ/kS6GRU7FChvxnYjYjOAqXY/AkFV2S3iXWDsex
   /NMSiJjFfk7mBWqHPfAuQUf99FxZh9iN2nn4jS8oZ91sPokl9ZJDAAmBt
   A==;
X-IronPort-AV: E=Sophos;i="5.92,266,1650902400"; 
   d="scan'208";a="205541543"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jul 2022 06:08:05 +0800
IronPort-SDR: rfqz0diU9+QNaAIs2JyVOiO6eLd3dcxH+79AnwciBq4THq+nHSVkw0udeY5zXKLaxeALBd2NRU
 wYOuqdnBBH8VrtpVL2ocww2KUDUXe5OuokYDJLN8bwKeZJPtPOCUFF8JsMXzJ1O4tm8w9py4yr
 3xJILTO98w3CQADWFLDSimPS2fRxV6qkfs1ThPnxMSLlluPud22cMbyYqxKD6qqow2lk8BOPFd
 5DgUfnZ3atB5v75Kly859V2b/6T6XvMbPaT/QzsWTeKFBIlZNTogdoh0yETU7g8SoSnnrQFgNz
 KowXSemxN1+2HQOqk77B4sNT
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jul 2022 14:29:43 -0700
IronPort-SDR: PFPJuBwKTkma8B1Tntj7PSu4R6N2EIm8d8lXr+caKMw8Nx3/Or9gKblAs5DoRBkgzgAA5AFWxQ
 DS4x/wWzli9h9CTZCcvlcqIQTXcHMkNU0sJ2veW0sgL1iVvqx5qYkud3l+bnKv2dbodckBx2jx
 eHgoUC1+Zi9zFY73HhYuhNFPmrL74Aa8y1qiKQsTToSZ7xV2rgtrIC84i585Ff2j6roiTC6ELa
 fWFN8T/0pXEmhzJpks4WRToQDShkbYBc4y7CY/CQl+CZcNjMPUQCnnbPCG7FsQPN5AaSACB1TO
 C8I=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jul 2022 15:08:08 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LjFHq0VF5z1Rwnl
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 15:08:07 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1657663686; x=1660255687; bh=rwtOJ13hetNqw1SJinQMWjx0Bzi08NEomTZ
        FMZTXnt8=; b=lJx6K97gBxHBny5+ZsDSneOFPEDfRup1SSLKlL15oGdkROi/h26
        v+RZj6NXiJ3HpkgBo4E38zEn51Sp2d3i/r4wAl5IzYQX2v3VM2usxe0ls68grHcP
        UtaSgEznabuFdsKEdw0H90bN9oYoSHMAXHxykeSnj+IkjhbKkfxkl+XLS7jF1rBA
        N7XXUJ4o5avN9Vu396uirEXAJdPejNzAw+2SFj5ZPYHkMcC7z3yJJ7v0l1skXwjq
        NFYgYOeYb03ubNpOmY3xOwp7kY6CgZRNJZcrxMJNXGvoI4rtK3nAXSnyCbJ1Z6JH
        WTMY0/4KS+zLLCGYLc2lcCQNmvRQ2gN+52A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id NkURfXEkMRkS for <linux-scsi@vger.kernel.org>;
        Tue, 12 Jul 2022 15:08:06 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LjFHn3hz4z1RtVk;
        Tue, 12 Jul 2022 15:08:05 -0700 (PDT)
Message-ID: <6d228185-1ce3-b0c8-71b8-badfe78505b7@opensource.wdc.com>
Date:   Wed, 13 Jul 2022 07:08:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 3/3] scsi: sd_zbc: Fix handling of RC BASIS
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>
References: <20220711230051.15372-1-bvanassche@acm.org>
 <20220711230051.15372-4-bvanassche@acm.org>
 <90cb95f0-7d8b-af10-9480-76a2163993e2@opensource.wdc.com>
 <95f2f1d5-3e32-bb6f-b8e4-df0c232ed6eb@opensource.wdc.com>
 <7f58e047-8fa8-7300-3062-ab1d22495b2d@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <7f58e047-8fa8-7300-3062-ab1d22495b2d@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/22 02:14, Bart Van Assche wrote:
> On 7/11/22 16:28, Damien Le Moal wrote:
>> On 7/12/22 08:11, Damien Le Moal wrote:
>>> On 7/12/22 08:00, Bart Van Assche wrote:
>>>> Using the RETURNED LOGICAL BLOCK ADDRESS field + 1 as the capacity (largest
>>>> addressable LBA) if RC BASIS = 0 is wrong if there are sequential write
>>>> required zones. Hence only use the RC BASIS = 0 capacity if there are no
>>>> sequential write required zones.
>>>
>>> This does not make sense to me: RC BASIS == 0 is defined like this:
>>>
>>> The RETURNED LOGICAL BLOCK ADDRESS field indicates the highest LBA of a
>>> contiguous range of zones that are not sequential write required zones
>>> starting with the first zone.
>>>
>>> Do you have these cases:
>>> 1) host-managed disks:
>>> SWR zones are *mandatory* so there is at least one. Thus read capacity
>>> will return either 0 if there are no conventional zones (they are
>>> optional) or the total capacity of the set of contiguous conventional
>>> zones starting at lba 0. In either case, read capacity does not give you
>>> the actual total capacity and you have to look at the report zones reply
>>> max lba field.
>>> 2) host-aware disks:
>>> There are no SWR zones, there cannot be any. You can only have
>>> conventional zones (optionally) and sequential write preferred zones. So
>>> "the highest LBA of a contiguous range of zones that are not sequential
>>> write required zones starting with the first zone" necessarily is always
>>> the total capacity. RC BASIS = 0 is non-sensical for host-aware drives.
>>
>> What I meant to say here for the host-aware case is that RC BASIS is
>> irrelevant. Both RC BASIS = 0 and = 1 end up with read capacity giving the
>> actual total capacity. ANd for good reasons: the host-aware model is
>> designed to be backward compatible with regular disks, which do not have
>> RC BASIS, so RC BASIS = 0, always.
> Hi Damien,
> 
> I agree that for host-aware block devices (conventional + sequential write
> preferred zones) RC BASIS is irrelevant.
> 
> What I'm concerned about is host-managed block devices (conventional + sequential
> write required zones) that report an incorrect RC BASIS value (0 instead of 1).
> Shouldn't sd_zbc_check_capacity() skip the capacity reported by host-managed block
> devices that report RC BASIS = 0?

If that is so much a concern, we could do something like this:

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 6acc4f406eb8..32da54e7b68a 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -716,17 +716,15 @@ static int sd_zbc_check_capacity(struct scsi_disk
*sdkp, unsigned char *buf,
        if (ret)
                return ret;

-       if (sdkp->rc_basis == 0) {
-               /* The max_lba field is the capacity of this device */
-               max_lba = get_unaligned_be64(&buf[8]);
-               if (sdkp->capacity != max_lba + 1) {
-                       if (sdkp->first_scan)
-                               sd_printk(KERN_WARNING, sdkp,
-                                       "Changing capacity from %llu to
max LBA+1 %llu\n",
-                                       (unsigned long long)sdkp->capacity,
-                                       (unsigned long long)max_lba + 1);
-                       sdkp->capacity = max_lba + 1;
-               }
+       /* The max_lba field is the capacity of this device */
+       max_lba = get_unaligned_be64(&buf[8]);
+       if (sdkp->capacity != max_lba + 1) {
+               if (sdkp->first_scan)
+                       sd_printk(KERN_WARNING, sdkp,
+                               "Changing capacity from %llu to max LBA+1
%llu\n",
+                               (unsigned long long)sdkp->capacity,
+                               (unsigned long long)max_lba + 1);
+               sdkp->capacity = max_lba + 1;
        }

        if (sdkp->zone_starting_lba_gran == 0) {

That is, always check the reported capacity against max_lba of report
zones reply, regardless of rc_basis (and we can even then drop the
rc_basis field from struct scsi_disk).

But I would argue that any problem with the current code would mean a
buggy device firmware. For such case, the device FW should be fixed or we
should add a quirk for it.

> 
> Thanks,
> 
> Bart.


-- 
Damien Le Moal
Western Digital Research
