Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 029E5C77B73
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 00:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjDLA7h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 20:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjDLA7f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 20:59:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6F73C0D;
        Tue, 11 Apr 2023 17:59:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A10E62883;
        Wed, 12 Apr 2023 00:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FFEC433D2;
        Wed, 12 Apr 2023 00:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681261173;
        bh=21X7G3ujtwPj1BsO2o9DbkG+h4dix6yYEdsKo2U3vak=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=C5c1EjPJnpgMVWPGANVK6LJh/SL1io4hnzRhHLLmUjrXZXwkekJjHomj3ri2hTqsr
         4/xsjNCwRbY7ET0jWgMQr5IBbCwIq7rsLwMVBn8Y5IBrqj+ZwaPw/1UAbjr7QrwGNv
         Exbkz+R3AadRZsqQ8gURY7+2fb3ZhpW8gnOFgo7vJh3tOCeSfalCQ5YAuwHFs1oUIk
         M3BRA2CIEY4KxuHlG8RSrOaPx+arav7SArZ6AS7XUvIvtmLktHpiHAaeBplAhES3eu
         ZiljESdElPUnMtOuUyVPvtrTXMm5TQL4mHkhsiRgB2qVSmMyS5syPtu0mqpcKB0yNd
         qjFuwKM6WumJQ==
Message-ID: <85d6ea79-eda1-de58-6ce4-1fab90335ac8@kernel.org>
Date:   Wed, 12 Apr 2023 09:59:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v6 09/19] scsi: allow enabling and disabling command
 duration limits
To:     Niklas Cassel <nks@flawful.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
References: <20230406113252.41211-1-nks@flawful.org>
 <20230406113252.41211-10-nks@flawful.org> <20230411061648.GD18719@lst.de>
 <e9cf65ce-e1f0-4d99-31e7-75b8e88e2a89@kernel.org>
 <20230411072317.GA22683@lst.de>
 <15ad7cf9-e385-9cea-964a-4a2eac35385c@kernel.org>
 <ZDVLsIi/OhkxNcGb@x1-carbon>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZDVLsIi/OhkxNcGb@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/11/23 20:59, Niklas Cassel wrote:
> On Tue, Apr 11, 2023 at 04:38:48PM +0900, Damien Le Moal wrote:
>> On 4/11/23 16:23, Christoph Hellwig wrote:
>>> On Tue, Apr 11, 2023 at 04:09:34PM +0900, Damien Le Moal wrote:
>>>> But yes, I guess we could just unconditionally enable CDL for ATA on device scan
>>>> to be on par with scsi, which has CDL always enabled.
>>>
>>> I'd prefer that.  With a module option to not enable it just to be
>>> safe.
>>
>> Then it may be better to move the cdl_enable attribute store definition for ATA
>> devices to libata. That would be less messy that way. Let me see if that can be
>> done cleanly.
> 
> I don't think that the SCSI mode select can just be replaced with simple
> SET FEATURES in libata.
> 
> If we move the SET FEATURES call to a function in libata, and then use a
> function pointer in the scsi_host_template, and let only libata set this
> function pointer (similar to e.g. how the queue_depth sysfs attribute works),
> then the code will no longer work for SATA devices connected to a SAS HBA.
> 
> 
> 
> The current code simply checks if VPD page89 (the ATA Information VPD
> page - which is defined in the SCSI to ATA Translation (SAT) standard)
> exists. This page (and thus the sdev->vpd_pg89 pointer) will only exist
> if either:
> 1) An ATA device is connected to a SATA controller. This page will then
> be implemented by libata.
> 2) An ATA device is connected to a SAS HBA. The SAS HB will then provide
> this page. (The page will not exist for SCSI devices connected to the
> same SAS HBA.)
> 
> For case 1) with the current code, scsi.c will call scsi_mode_select()
> which will be translated by libata before being sent down to the device.
> 
> For case 2) with the current code, scsi.c will send down a SCSI mode
> select to the SAS HBA, and the SAS HBA will be responsible for translating
> the command before sending it to the device.
> 
> So I actually think that the current way to check if vpd page89 exists
> is probably the "cleanest" solution that I can think of.
> 
> If you have a better suggestion that will work for both case 1) and
> case 2), I will be happy to change the code accordingly.

Good point. If we move the code for cdl_enable to libata, then we will not be
covering the SAS HBA cases.

Christoph,

I do not see a cleaner solution... Can we keep this patch as is ? Any other idea ?

