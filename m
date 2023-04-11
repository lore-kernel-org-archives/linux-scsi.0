Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57669C77B6F
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 07:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjDKHJl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 03:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjDKHJk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 03:09:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972A0212F;
        Tue, 11 Apr 2023 00:09:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F8836222F;
        Tue, 11 Apr 2023 07:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E634C433EF;
        Tue, 11 Apr 2023 07:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681196977;
        bh=NYgZ6zuxde82GQHKz3xIojLYA6xo8YNrc2uMkoQx8dI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=sVl2AXWYQML9nx+tHYScRwBtKN/jhh7c8V4P/HduNgKjraPWMs5WMJFGhzJ3V4f5m
         kh+O9imUidQnze9zuZmzNpoQyjkX9CE+M7ZAe066GsE5yugum8gR2g87Ap7ZA2Uwcm
         Znq1D0bqNVoVbcZTO7Pq0V2WcdwaqzxNTRc6E9ZZ/ebokZ0NzrmOzqVjdyoGH184ah
         IBjoyBqIeZukl0egdN4uYIRFziC+SP+hiLYpGxH/UzyDIIudgTD3lfzeBmAc/0n0/c
         dYVTKr6+oSqsRS0q/CgkDcajPkJtD+yDrBkSSWDKI+T50SLIOJAJFGCfC3air4wPfS
         Oi6kA5ugKa5Yg==
Message-ID: <e9cf65ce-e1f0-4d99-31e7-75b8e88e2a89@kernel.org>
Date:   Tue, 11 Apr 2023 16:09:34 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v6 09/19] scsi: allow enabling and disabling command
 duration limits
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Niklas Cassel <nks@flawful.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
References: <20230406113252.41211-1-nks@flawful.org>
 <20230406113252.41211-10-nks@flawful.org> <20230411061648.GD18719@lst.de>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230411061648.GD18719@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/11/23 15:16, Christoph Hellwig wrote:
> On Thu, Apr 06, 2023 at 01:32:38PM +0200, Niklas Cassel wrote:
>> +	/*
>> +	 * For ATA devices, CDL needs to be enabled with a SET FEATURES command.
>> +	 */
>> +	if (is_ata) {
> 
> I don't think these hacks have any business in the SCSI layer.  We should
> probbaly just do this unconditionally for CDL enabled ATA devices at
> probe time.

Yes, this is not pretty, but this has the advantage of not requiring a lot of
special code for ata, especially the sysfs attribute does not have to be defined
in both scsi and ata.

But yes, I guess we could just unconditionally enable CDL for ATA on device scan
to be on par with scsi, which has CDL always enabled.
