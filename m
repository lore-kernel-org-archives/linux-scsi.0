Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE154C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Feb 2022 07:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354685AbiBDHoD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Feb 2022 02:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbiBDHoC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Feb 2022 02:44:02 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7A7C061714;
        Thu,  3 Feb 2022 23:44:02 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id me13so16734067ejb.12;
        Thu, 03 Feb 2022 23:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=I+eZ5r9Zo5doiib4NPJfnmz4nNAlQRvPDILFlHosWIo=;
        b=hxUUl68KuPh2LTqCNo4nw0bJ0mudIv3oVas6Ejo0tEEytOL/hGGlm7pwMgJZSSlxr0
         okHlc2gtlgSMpYPQbGBeDTQrZZFhQFVC5g43ITnfGiRzNpI09j//sLdhvjJuOQByENth
         NaQ7mnlQwvHbqUxdYf5l5qaWSIkKCROZPoOpaCTi2L9RSGzWthiGvW0ukZQ7Skm4FuOK
         34bqZX3Fadt0F3Lfi2tOrW+dmL90RBqSy1XWGf/RVCGbul5BfG2LpaNGoFSDmZ/wPAnu
         dU84bD53uWlrvIVdQt7WR3Wnlf2FOFBSQ8s/taxxrUwBSr+NLNdPmk1JzJi5CHBI7Xet
         gXSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=I+eZ5r9Zo5doiib4NPJfnmz4nNAlQRvPDILFlHosWIo=;
        b=MOu75jA0MGaQvhlwRfkcg7vU+A09fn9d9xIeT+JEFzCuDYm879avMUH3+CuFKWCKxq
         AfXTmheX8dub9jSUzYauO1F/mbdR38h8+tNU1YUxTltN7kBtP7MMxwweUjIbBiA091M9
         0YdFQdcf/8Lh5LEev31dH1+bStVSYA6t6Ny3AHFCwTD/+hbV53jplmRlCXtJ2KuFVAUw
         +pPhPJLoOqII9lXwjStyFsidLzUIqNq9Ir1Fq7q6EDRAUoHK5f2Yy06wkYRvE86eF594
         S0ik7VdUYWpM81mgIlmrnQQT9ve3zGQKhihuxUTUrf8CegRFCgRvGqSvKUKwjuzCNcFa
         DPVQ==
X-Gm-Message-State: AOAM530xpPhL+oIu7HKW2XH6hm2htifiAlpqdKnIfM6Na2FtGJFYQqV7
        zJ9XFPmCS1LHiilgaunGANI=
X-Google-Smtp-Source: ABdhPJx1amdsi5+ctCgbOedLbQzMNVsDB7TAIXU/ONObuYY5mkNoRQvRdS4empd7YgKXCXePfLmhfQ==
X-Received: by 2002:a17:907:3f1a:: with SMTP id hq26mr1452818ejc.562.1643960640534;
        Thu, 03 Feb 2022 23:44:00 -0800 (PST)
Received: from [192.168.2.27] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id v23sm374545ejf.21.2022.02.03.23.43.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 23:43:59 -0800 (PST)
Message-ID: <e033bbdf-5c07-8085-030d-a9954b321f08@gmail.com>
Date:   Fri, 4 Feb 2022 08:43:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 0/1] t10-pi bio split fix
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Ivanov, Dmitry (HPC)" <dmitry.ivanov2@hpe.com>
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@acm.org>,
        "Lyashkov, Alexey" <alexey.lyashkov@hpe.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        device-mapper development <dm-devel@redhat.com>
References: <SJ0PR84MB18220278F9CA4C597E2467E8C2279@SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM>
 <yq1tudfz49v.fsf@ca-mkp.ca.oracle.com>
From:   Milan Broz <gmazyland@gmail.com>
In-Reply-To: <yq1tudfz49v.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/02/2022 04:44, Martin K. Petersen wrote:
> 
> Dmitry,
> 
>> My only concern is dm_crypt target which operates on bip_iter directly
>> with the code copy-pasted from bio_integrity_advance:
>>
>> static int dm_crypt_integrity_io_alloc(struct dm_crypt_io *io, struct bio *bio)
>> {
>> 	struct bio_integrity_payload *bip;
>> 	unsigned int tag_len;
>> 	int ret;
>>
>> 	if (!bio_sectors(bio) || !io->cc->on_disk_tag_size)
>> 		return 0;
>>
>> 	bip = bio_integrity_alloc(bio, GFP_NOIO, 1);
>> 	if (IS_ERR(bip))
>> 		return PTR_ERR(bip);
>>
>> 	tag_len = io->cc->on_disk_tag_size * (bio_sectors(bio) >> io->cc->sector_shift);
>>
>> 	bip->bip_iter.bi_size = tag_len;
>> 	bip->bip_iter.bi_sector = io->cc->start + io->sector;
>>                 ^^^
>>
>> 	ret = bio_integrity_add_page(bio, virt_to_page(io->integrity_metadata),
>> 				     tag_len, offset_in_page(io->integrity_metadata));
>> ...
>> }
> 
> I copied Milan and Mike who are more familiar with the dm-drypt internals.

Hi,

What's the problem here you are trying to fix?
Even if I read linux-block posts, I do not understand the context...

Anyway, cc to Mikulas and dm-devel, as dm-integrity/dm-crypt is
the major user of bio_integrity here.

If you touch the code, please be sure you run cryptsetup testsuite
with the integrity tests.
(IOW integritysetup tests and LUKS2 with authenticated encryption
that uses dm-crypt over dm-integrity.)

All we need is that dm-integrity can process bio integrity data
directly. (I know some people do not like it, but this was
the most "elegant" solution here.)

Here dm-crypt uses the data for authenticated encryption (additional
auth tag in bio field), so because dm-crypt owns bio, integrity data
must be allocated in dm-crypt (stacked over dm-integrity).

Milan
