Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC02C77B75
	for <linux-scsi@archiver.kernel.org>; Mon, 15 May 2023 22:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243499AbjEOW6r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 May 2023 18:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjEOW6q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 May 2023 18:58:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7AAD851;
        Mon, 15 May 2023 15:58:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE546623D9;
        Mon, 15 May 2023 22:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C953C433EF;
        Mon, 15 May 2023 22:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684191524;
        bh=HNeutJ4JFpQQ4wKNKhCHw5j5tW44s9XT4QS3pN3QQ3U=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=uVWCWHUDQMXHIzEGeQK3A1SvYdwy5f6ucoNTg5I53bFXyTZgdm3y8Wb091oRjtWfN
         oyQDVRsAP5EQxGYZjlAr39yxd5i4eDugAbfzdBcsTjMd55FgP1V+PNSMGR8CvEu5TS
         JKUDflPezPfBefye4IhU4e45kTjV1dgdHaKTAZFq3KrBm/dbg16xvt8f7GyqXA9X2h
         V60ik6AtV/B1LtcubhE2Elt2GTS7TCsLhjtg1Jx4qaZtx6vFGzj2DzNw6udi9NuRJg
         /oVV8O8fY0ubEXQzF5N3d7WBQJKKHMUDDlwTySwfVV13OTEHaL/lcLgg5EmRaM308n
         NXO86OtGXpzeQ==
Message-ID: <ae2385ae-1b56-4d14-ab90-7d7ae94b9dc0@kernel.org>
Date:   Tue, 16 May 2023 07:58:42 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v7 00/19] Add Command Duration Limits support
To:     Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
References: <20230511011356.227789-1-nks@flawful.org>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230511011356.227789-1-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/05/11 10:13, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>

[...]

> Damien Le Moal (13):
>   ioprio: cleanup interface definition
>   block: introduce ioprio hints
>   block: introduce BLK_STS_DURATION_LIMIT

Jens,

We really need your review / Ack (if appropriate) of the first 3 patches of this
series. Can you please do that as soon as possible so that Martin can queue the
series through the scsi tree ?

Thank you.

>   scsi: support retrieving sub-pages of mode pages
>   scsi: support service action in scsi_report_opcode()
>   scsi: detect support for command duration limits
>   scsi: allow enabling and disabling command duration limits
>   scsi: sd: set read/write commands CDL index
>   ata: libata: detect support for command duration limits
>   ata: libata-scsi: handle CDL bits in ata_scsiop_maint_in()
>   ata: libata-scsi: add support for CDL pages mode sense
>   ata: libata: add ATA feature control sub-page translation
>   ata: libata: set read/write commands CDL index
> 
> Niklas Cassel (6):
>   scsi: core: allow libata to complete successful commands via EH
>   scsi: rename and move get_scsi_ml_byte()
>   scsi: sd: handle read/write CDL timeout failures
>   ata: libata-scsi: remove unnecessary !cmd checks
>   ata: libata: change ata_eh_request_sense() to not set CHECK_CONDITION
>   ata: libata: handle completion of CDL commands using policy 0xD


-- 
Damien Le Moal
Western Digital Research

