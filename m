Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09DCAC77B73
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 05:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjDLFcg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Apr 2023 01:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjDLFcf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2023 01:32:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DB04680;
        Tue, 11 Apr 2023 22:32:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A15C262E2B;
        Wed, 12 Apr 2023 05:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDA3C433D2;
        Wed, 12 Apr 2023 05:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681277554;
        bh=KIISW2jjpNw+QGm0yeVN7GW7ppN72UB3M07SmBIXSPw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=isC4AekiN7KHGY2BqbJcFMLoVw/jHq5qX17mehd5oD50Cc2SYBDD5ukPogTHWJmTJ
         oMvQVn0n2CIWj3RJh6dUioFzs9dwFyA7SytJ6YG5Qp2YF85nXGHYFsR5wLLO4MISUV
         A8BfbYSrL5ETfLPWu4av/0H7WwojXvCHF2/jLPHX4ma1eB4pdnvtjXcgorFDwyvFTs
         /7cWZC/7SzkPWs9RM9DYjiDVToiTkcpfjYDck+kHzc7qo4zh8PR1ZgFs1Ve/hO5djB
         Iz4DjCGeIs6tC3mN7kL5HzsXyfwCT50My3cTu8qWxMtA2cLREWJV5uHE90iHWWHVaX
         yUbCIF4ou/ykw==
Message-ID: <3ac7f4a1-eaa6-d1db-3056-b0ed6681ef36@kernel.org>
Date:   Wed, 12 Apr 2023 14:32:30 +0900
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
 <15ad7cf9-e385-9cea-964a-4a2eac35385c@kernel.org>
 <ZDVLsIi/OhkxNcGb@x1-carbon>
 <85d6ea79-eda1-de58-6ce4-1fab90335ac8@kernel.org>
 <20230412044348.GA17806@lst.de>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230412044348.GA17806@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/23 13:43, Christoph Hellwig wrote:
> On Wed, Apr 12, 2023 at 09:59:30AM +0900, Damien Le Moal wrote:
>> Good point. If we move the code for cdl_enable to libata, then we will not be
>> covering the SAS HBA cases.
>>
>> Christoph,
>>
>> I do not see a cleaner solution... Can we keep this patch as is ? Any other idea ?
> 
> I guess we have to.  But it's really ugly and someone in T13 really needs
> to be slapped..

It is T10 rather than T13 that screwed up: if SPC also defined a CDL feature
on/off through mode sense/select, we would not need any "if (is_ata)"...
For ATA/T13, the on/off makes sense because of the mutual exclusion with NCQ
priority.

