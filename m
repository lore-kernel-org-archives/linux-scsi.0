Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A13BEEE4993
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 09:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbjHUJE1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 05:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbjHUJE0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 05:04:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE67CC
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 02:04:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C51E7611BE
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 09:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233F1C433C9;
        Mon, 21 Aug 2023 09:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692608664;
        bh=35gI5dNKcyVpa+UL7/qtc9ebhiX7bm1BQJPbFcKp2uk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=LFgAmomZM+GgBTp/JyweeWC/3gmnU9mGNxKTP29XjmgJEXujF/MZ2bE5vgift21wS
         wrlh+Blw7o1EAEt9ONFa+HPaSud8hG6ggzeXcDEH40yWJHYPXil+nvrxnXOjlaFVJa
         7EyN/Yp+0fpJXVTRzJSCizt3L4tMrsBWvp4aQBec1BL5SRPeouAzJDm+4eUO/zClYP
         1q5NPIWk4KEMXG5u9AvETlrGoGOc7bqDn8k4iuMmlblgmv5XfvHJ1L7fGBrnRSm7mD
         8acMXnKCyFj841I4rZYVl9VWQqwQvG1xS1nBdVzx1scjSCqt5WDxGfxpJcMSN4sZKs
         rhJ0pM7711e/g==
Message-ID: <0f24ed39-a044-6a33-4779-fc3b0a10fccc@kernel.org>
Date:   Mon, 21 Aug 2023 18:04:21 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 0/2] Returning FIS on success for CDL
To:     Igor Pylypiv <ipylypiv@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
Cc:     linux-scsi@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>
References: <20230819213040.1101044-1-ipylypiv@google.com>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230819213040.1101044-1-ipylypiv@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/20/23 06:30, Igor Pylypiv wrote:
> This patch series plumbs libata's request for a result taskfile
> (ATA_QCFLAG_RESULT_TF) through libsas to pm80xx LLDD. Other libsas LLDDs
> can start using the newly added return_fis_on_success as well, if needed.
> 
> For Command Duration Limits policy 0xD (command completes without
> an error) libata needs FIS in order to detect the ATA_SENSE bit and read
> the Sense Data for Successful NCQ Commands log (0Fh). pm80xx HBAs do not
> return FIS on success by default, hence, the driver is updated to set
> the RETFIS bit (Return FIS on good completion) when requested by libsas.

For both patches:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

