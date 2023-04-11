Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814AFC76196
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 08:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjDKIkw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 04:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjDKIkv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 04:40:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3CD121;
        Tue, 11 Apr 2023 01:40:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDE4461DBF;
        Tue, 11 Apr 2023 08:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA6BC433EF;
        Tue, 11 Apr 2023 08:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681202450;
        bh=DH/Wedy/FTrfpXYGKKLe6o9ML0Q1OWiJXYZnr0antg8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=PUXVQnqJSKryWkvozhGn4QqamCWMYaY+He/OL/BaJPoR2KinnaWVxvr3GxBh2MIpw
         tBGb+4CfThl50aqOVPBWQeSsAWEE+h5RIKGqz9YHXTGFxDSwdoABaiOFpUlOAWbI5N
         b03AHMyRgcsoGC19M2qro5yuwpDZJ79FFVRLYnliZVd2Q8mishG2qsKtZAeAg3YIAo
         8SZpzWrV+g7BZHe7CYsxfahwDp9qqyqhMhxtJA2FPsF/HGv4WzR80lS1i8i0/eq3eH
         WAYqfL/4h0SSrHEGmtHBB9HKrwbyLo+LIO4Auhe2+OOC/Ns1sb2s5nadVAS3eln2Fx
         JtIv0MYA6slRg==
Message-ID: <16dbe246-873f-2f89-6bfa-585b29b735d0@kernel.org>
Date:   Tue, 11 Apr 2023 17:40:47 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v6 09/19] scsi: allow enabling and disabling command
 duration limits
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
References: <20230406113252.41211-1-nks@flawful.org>
 <20230406113252.41211-10-nks@flawful.org> <20230411061648.GD18719@lst.de>
 <e9cf65ce-e1f0-4d99-31e7-75b8e88e2a89@kernel.org>
 <20230411072317.GA22683@lst.de>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230411072317.GA22683@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/11/23 16:23, Christoph Hellwig wrote:
> On Tue, Apr 11, 2023 at 04:09:34PM +0900, Damien Le Moal wrote:
>> But yes, I guess we could just unconditionally enable CDL for ATA on device scan
>> to be on par with scsi, which has CDL always enabled.
> 
> I'd prefer that.  With a module option to not enable it just to be
> safe.

Thinking more about this, we cannot unconditionally enable CDL. The reason is
that CDL and NCQ priority are mutually exclusive: if CDL is enabled, NCQ
priority cannot be used. So with CDL unconditionally enabled, we cannot have NCQ
priority enabled, preventing the user from choosing its preferred IO latency
control method.

