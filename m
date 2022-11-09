Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E83C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 18:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbiKISrp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 13:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiKISro (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 13:47:44 -0500
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF9C2BD4
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 10:47:43 -0800 (PST)
Received: by mail-pf1-f180.google.com with SMTP id z26so17550600pff.1
        for <linux-scsi@vger.kernel.org>; Wed, 09 Nov 2022 10:47:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zWLVGcItYWJnx+G7pF/u9+JcnDvmEQJyKc6lc6++y78=;
        b=qvHPgklTxLzMpe4MeKUv5RGLpAOBDn4AzOH2kYTCP7j9cLxKcdmmk5YoP2pn/w/RjI
         ofa36tjuoCG5QOot6xEM5uUqqRei7nhrIF8tVaukmKbGFp7JtHKA/0srjq9Wk4UME/LU
         CCyo43XlmW3fzWjde6+h3SpDPQQjSHF+x+wkIYmrPXhFN92UVaNjTAqiNyLoX8kWKesN
         dd49km6fiW2jAaxXnDisdRSsR5kHgprAkXSqE8Saq27aOSEt5Fn3E6t/BT3H2F7PEcxE
         chipz/3B1dwt6Ma6sr5SxlinGPgmbaTK7xwuTPtlTPCsvS8SUWt6EGM9m+cifcVUopsR
         O0SA==
X-Gm-Message-State: ACrzQf0khyLdlfqtXQRfER25qlZ1y1WKZWyO+/+eipC4jDXNLOY5kfst
        UY1adCHjic/DW2yw497yW+JAz4cldUI=
X-Google-Smtp-Source: AMsMyM49GbFuPkcKmTJGpX04llbOoi5VfN4Ze3rs9xFWuhrNWg9cENvDFWJLtagVzS0pBKLwXpvNSg==
X-Received: by 2002:a63:914a:0:b0:46f:7e1c:6584 with SMTP id l71-20020a63914a000000b0046f7e1c6584mr52159892pge.562.1668019663059;
        Wed, 09 Nov 2022 10:47:43 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:68b6:5dae:a00c:c3b? ([2620:15c:211:201:68b6:5dae:a00c:c3b])
        by smtp.gmail.com with ESMTPSA id z11-20020a1709027e8b00b00186f81a074fsm9367563pla.290.2022.11.09.10.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 10:47:42 -0800 (PST)
Message-ID: <9744635e-b600-6cf2-1db5-28dd34b0a8ad@acm.org>
Date:   Wed, 9 Nov 2022 10:47:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v6 26/35] scsi: sd: Have scsi-ml retry sd_sync_cache
 errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221104231927.9613-1-michael.christie@oracle.com>
 <20221104231927.9613-27-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221104231927.9613-27-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/22 16:19, Mike Christie wrote:
> +	static const u8 cmd[10] = { SYNCHRONIZE_CACHE };
> +	int res;

[ ... ]

> +	/*
> +	 * Leave the rest of the command zero to indicate flush everything.
> +	 */
> +	res = scsi_exec_req(((struct scsi_exec_args) {
> +				.sdev = sdp,
> +				.cmd = cmd,
> +				.data_dir = DMA_NONE,
> +				.sshdr = sshdr,
> +				.timeout = timeout,
> +				.retries = sdkp->max_retries,
> +				.req_flags = RQF_PM,
> +				.failures = failures }));

The "leave the rest" comment seems misplaced to me. I think it should be 
moved above the cmd[10] definition. If that comment is moved, please add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

