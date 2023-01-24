Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C145EC54E94
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 19:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234671AbjAXTeN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 14:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbjAXTeA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 14:34:00 -0500
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A527151C42;
        Tue, 24 Jan 2023 11:33:11 -0800 (PST)
Received: by mail-pj1-f41.google.com with SMTP id y3-20020a17090a390300b00229add7bb36so15023999pjb.4;
        Tue, 24 Jan 2023 11:33:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e+RvVCnMqI8JeUm4l/oSsr4iQuO8Gj7BAAPaVYUhiME=;
        b=0CfX7+f1pwBfFSSQ3zsa5+GS+GGSCd25uz0rYjrZPPmeCjgO0BG4w0Gz3RDbhaCcj0
         50o5//Zq7ukzUEsB3svN0Pzt2gPICx9LNSMIFAOCsfcyQk9ZY+IR3keJVhsxIER1tKK8
         PQXudoNKWV3Zz53thQRATei1jCXkQgz1dbuyaACgL4cgoyibjbv0zq1XWDPG/U/u7CY1
         oyITFoMAAgJoR2SE7wrZ3FJl5OB+nGaqlSdJEu1/1yWg2fFB2CpeuyrIz8dHJ2xH8YaI
         cj3QYlhzo4eFm6ChVMqf6L2cCso25Cdy/tX1KoNdrWxrvROhLtTu3W6moYitlddUzqhy
         stsg==
X-Gm-Message-State: AFqh2koaolSnZlntKYOjbIBEq/NFZAQPR0fPc4tL1cg3MCYpSud5ENdo
        ofXiuRK0KWfDRQQ/0KMfd70=
X-Google-Smtp-Source: AMrXdXvAi+dYEvQsYZV3o5cFVAuQZ6in9nnfkQi7KrTedcbqrrpWq+B+7X8dN3tHB2wYtuf1GbL22Q==
X-Received: by 2002:a17:902:bd95:b0:192:5282:6833 with SMTP id q21-20020a170902bd9500b0019252826833mr27802519pls.29.1674588775723;
        Tue, 24 Jan 2023 11:32:55 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:c69a:cf2c:dc2d:7829? ([2620:15c:211:201:c69a:cf2c:dc2d:7829])
        by smtp.gmail.com with ESMTPSA id bb2-20020a170902bc8200b0018bc4493005sm2004129plb.269.2023.01.24.11.32.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 11:32:55 -0800 (PST)
Message-ID: <2d40af65-7c4f-d0a2-bae3-47d2803da840@acm.org>
Date:   Tue, 24 Jan 2023 11:32:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 04/18] scsi: rename and move get_scsi_ml_byte()
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-5-niklas.cassel@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230124190308.127318-5-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 11:02, Niklas Cassel wrote:
> SCSI has two different getters:
> - get_XXX_byte() (in scsi_cmnd.h) which takes a struct scsi_cmnd *, and
> - XXX_byte() (in scsi.h) which takes a scmd->result.
> The proper name for get_scsi_ml_byte() should thus be without the get_
> prefix, as it takes a scmd->result. Rename the function to rectify this.
> (This change was suggested by Mike Christie.)
> 
> Additionally, move get_scsi_ml_byte() to scsi_priv.h since both scsi_lib.c
> and scsi_error.c will need to use this helper in a follow-up patch.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
