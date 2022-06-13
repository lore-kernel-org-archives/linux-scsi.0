Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD43C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 09:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240453AbiFMJoP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 05:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239912AbiFMJoH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 05:44:07 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DAA11179
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 02:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1655113446; x=1686649446;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RuD/TK0xJwTunRs1tXbq1ySa0ymvXEIcsR9lmtZ0bZM=;
  b=E4nkwbOzZHW7ktWrm3Du56ZdAByn/Jl2HA7lb++BHgRML06+TmRJrKev
   pHhSygynzKIjFPV0jp0f1f4RUuAnuwxm+gcpPH8KeGeJ9Oj5Ek+nYfd0T
   L4EvPAWCehmxj9hZUezUZjdwLy5art2m7+7sRVsuugysBo7SJjEEYbk0T
   Zjcm1yroxpFjfa+NTGO87Y0CHKwoWskEtBjh1h5C6lbyybl78q1GMJ8J7
   3UYv++WZU7wc+kAe4XEVAgBwcfwcCVqtKYMk+2Ip5t0wKCICGsZSndl7w
   2BMEX+znstPmGcUKa4tdDb951KYbuAeNJLC9eYFu9dGPSwyQtfIXoAuBN
   w==;
X-IronPort-AV: E=Sophos;i="5.91,297,1647273600"; 
   d="scan'208";a="203754498"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2022 17:44:05 +0800
IronPort-SDR: i85cYmymBTFSNhhN95Fxe5TFRrybLTJib94TMAD3FDLk/NNzGUcHAAA002YdAd2Negpbkfs9OF
 A6gwrz3EDIu0uPVoAlrshfONdS3+ZR4q6t/2Fsw4F4S4Z48c8BgDz+X9zhtuVtvyKU7JN1Elul
 /L1FEnITVmr5WJPTCu87LTDRjM5bwPtlxbyM+qY81/pIwQs3Jxub6VcypEw1lrg/XX3G4QWajC
 OefbRJfPZR62heZgn/TyyhHaQpao4/LzZy8AZZhlywqh8R+ExPj/rjtGyW02TK3h9yz7ARK5Q9
 d2pg9oxPhMWyTwVyJOra9GoG
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jun 2022 02:07:08 -0700
IronPort-SDR: dgmYHysk1SIs8+U4qPXZtypxOqM6KBuy42cnIS32KN0OxYw1Yh9hZSRZawwf3jhO2pvhPkwvLx
 5BNN7KRyx9uxCIaVp+1pQK5F6wGQ6+XFKwkfIXfPkZ5bkLrn/6C5f48eOxJ+16Npji3JZpzxr1
 b7MOKdTU33yheS+beDKRqYoLClQzW4MXauCMJuCCoFcRgQh8O7NTFi3tb9RSkHccLCezPVuF1w
 pyDPbKxCoUusjT1dbJEEsmyj70qkPdLJKjo6vT5itOj6oXz9gHQPlr4Fx2QUyaO7lQ//sRXKaq
 f68=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jun 2022 02:44:05 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LM68h0lVzz1SVp3
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 02:44:04 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1655113443; x=1657705444; bh=RuD/TK0xJwTunRs1tXbq1ySa0ymvXEIcsR9
        lmtZ0bZM=; b=rMRIqfbSux6farRSdMLjirKerrwfQgPBAfkblXCqNxwiojtEAch
        h9WsQQvmDJwnNyf9Y2D+9i2lVTTWXH2bktwCKqt7Xkif4STB6ermqnarYEOjZGwL
        tbCxQ2oZyTOEEMtjIWSb/XuwpPdab6oxCU2ImbVb5OU5HG1ttzHkznfd6iczueKL
        GQdecX1mMl8XpwTirghBExYH0TJjJOnZwuhnb75RiGaGR1efaRqJhEtplwOpdyqT
        eHUjFvSTO7/sZ+na5QnW32FpgfcAmWJF3WGrXaWNvfNZf6C7ZvBe80zv/NBLgwiW
        VYwi7qUcDrJ1/vKQ1gCUgAcp7LSOlNgXuww==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id aXjFUPCbaj3T for <linux-scsi@vger.kernel.org>;
        Mon, 13 Jun 2022 02:44:03 -0700 (PDT)
Received: from [10.225.163.77] (unknown [10.225.163.77])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LM68d0Ml7z1Rvlc;
        Mon, 13 Jun 2022 02:44:00 -0700 (PDT)
Message-ID: <d2e452cd-6a91-f25d-748e-94f560deb1bb@opensource.wdc.com>
Date:   Mon, 13 Jun 2022 18:43:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH RFC v2 03/18] scsi: core: Implement reserved command
 handling
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com, brking@us.ibm.com,
        hare@suse.de, hch@lst.de
Cc:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        chenxiang66@hisilicon.com
References: <1654770559-101375-1-git-send-email-john.garry@huawei.com>
 <1654770559-101375-4-git-send-email-john.garry@huawei.com>
 <b4a0ede5-95a3-4388-e808-7627b5484d01@opensource.wdc.com>
 <7f80f3b6-84f6-de48-4e69-4562c96e62c5@huawei.com>
 <e4b108ba-cbc9-5237-f873-2fcea94f2b85@opensource.wdc.com>
 <53fa2856-54f2-c075-2eed-4f05c3459597@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <53fa2856-54f2-c075-2eed-4f05c3459597@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/13/22 18:34, John Garry wrote:
> On 13/06/2022 10:06, Damien Le Moal wrote:
>>>> We cannot have more than 32 tags.
>>> We may have 32 regular tags and 1 reserved tag for SATA.
>> Right. But that is the messy part though. That extra 1 tag is actually not
>> a tag since all internal commands are non-NCQ commands that do not need a
>> tag...
> 
> But apart from SATA, libsas LLDDs do need a real tag for the libata 
> internal command.

Yes, but that is really to manage the LLD command descriptor and not for
the device to use in the case of non-NCQ commands. There is not
necessarily a 1:1 equivalence between the HBA command descriptor tag and
ATA command tag.

> 
>>
>> I am working on command duration limits support currently. This feature
>> set has a new horrendous "improvement": a command can be aborted by the
>> device if it fails its duration limit, but the abort is done with a good
>> status + sense data available bit set so that the device queue is not
>> aborted entirely like with a regular NCQ command error.
>>
>> For such aborted commands, the command sense data is set to
>> "COMPLETED/DATA UNAVAILABLE". In this case, the host needs to go read the
>> new "successful NCQ sense data log" to check that the command sense is
>> indeed "COMPLETED/DATA UNAVAILABLE". And to go read that log page without
>> stalling the device queue, we would need an internal NCQ (queuable) command.
>>
>> Currently, that is not possible to do cleanly as there are no guarantees
>> we can get a free tag (there is a race between block layer tag allocation
>> and libata internal tag counting). So a reserved tag for that would be
>> nice. We would end up with 31 IO tags at most + 1 reserved tag for NCQ
>> commands + ATA_TAG_INTERNAL for non-NCQ. That last one would be rendered
>> rather useless. But that also means that we kind-of go back to the days
>> when Linux showed ATA drives max QD of 31...
> 
> So must the ATA_TAG_INTERNAL qc always be available for non-NCQ action 
> like EH, and that is why you cannot reuse for this internal NCQ 
> (queuable) command?

Currently, ATA_TAG_INTERNAL is always used for non-NCQ commands. Seeing a
qc with that tag means it is *not* NCQ.

I am trying to see if I can reuse the tag from one of the commands that
completed with that weird good status/sense data available. The problem
though is that this all needs to be done *before* calling
qc->complete_fn() which will free the tag. So we endup with 2 qcs that
have the same tag, the second one (for the read log command) temporarily
using the tag but still going through the same completion path without the
original command fully completed yet. It is a real mess.

> 
>>
>> I am still struggling with this particular use case and trying to make it
>> fit with your series. Trying out different things right now.
>>
> 
> ok
> 
>>
>>>> I think keeping can_queue as the max queue depth with at most
>>>> nr_reserved_cmds tags reserved is better.
>>> Maybe the wording in the comment can be improved as it originally
>>> focused on SAS HBAs where there are no special rules for tagset depth or
>>> how the tagset should be carved up to handle regular and reserved commands.
>> Indeed. And that would be for HBAs that do*not*  use libsas/libata.
>> Otherwise, the NCQ vs non-NCQ reserved tag mess is there.
>>
> 
> Thanks,
> John


-- 
Damien Le Moal
Western Digital Research
