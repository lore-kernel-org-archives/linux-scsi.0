Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D6C4C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 16:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F33C4610A5
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 16:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhHSQac (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 12:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbhHSQab (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 12:30:31 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF6AC061575
        for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2021 09:29:55 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y11so5982764pfl.13
        for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2021 09:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fH3jndA73Muj5Z7/jJV+9iDeqGv9eyos1s414UzV8R8=;
        b=Egm+rSRW4mllJa9ivxoGy5K/jv/BQx4d8+v4ZLNwPp5Z6/USOKF4+KkUpYHeLi0yJD
         OVsVlX/WQDJjKXuNDCX5oWI9NNNFFvoAjfvKFMkguzM2o0av9QaBQYZR7BOBblatogR1
         ZyVcgC+0zVBTUQAAOdT2LBCNxF6Qn/53L4kFBFq11k5ecLbfrCICACHb6XPMBa+ma5tc
         hNP+PhEk44xOj0VVKie+f8ORLUUZUJORjSKzcvMQlgEi537I8aMbBSF+GjY5UUBVKXkc
         5RodVicpjVUd1Ja8qjAuuTbGgc3SbT7qgOxBlbZYx/vTiA2AOG7ArGbhKwhIgdbZvz/w
         8yWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fH3jndA73Muj5Z7/jJV+9iDeqGv9eyos1s414UzV8R8=;
        b=V3WMEbzkejgNsP55kaDqh6ikJ2EUKYKbkoXtABbOImwQYlXTN6EcIUk+E0yiMhjjY7
         N3sqplot/XHiIggpmDvGlh5Q7pWbRPvnuaep6dLMsfms2AAkwacSS+5bKS3JK2tuBB4B
         Bq/OBDD3qE12keWihBNURxMTtR5aME1Z8mtI+lA1AFYjw0VC3YfPrG9x3PMEViANpQqz
         b5acejtGIeuBk+fycQzK3ozczjNNuKUojKCjZDGoxytUCqu+tK1eb3rEQZISiphsBj38
         ebmeJWnBRBECGGAjryYjZ6bVdMLQ+Jyv/XhT/uYXdpo2v9YTUdILyDEZwVOqsnoDnfH5
         PjEg==
X-Gm-Message-State: AOAM531YyS1YhL7y/EA7tyeEoJ4jk0YbliVlNlYwpWMMwPzhKSRz5Khp
        hfRMiFAhoR4SsHGdLfPOoHSvHSJQkdQ=
X-Google-Smtp-Source: ABdhPJw44eyxS6eRYJi20D3xbRB8PyheoPwnLnHXUiEtXV5JrhJYmVHMqt1Zb5p0mlJJ8EoUdkmmFg==
X-Received: by 2002:a05:6a00:7cc:b029:3e0:e9f3:5835 with SMTP id n12-20020a056a0007ccb02903e0e9f35835mr14861068pfu.66.1629390595049;
        Thu, 19 Aug 2021 09:29:55 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b15sm4722641pgj.60.2021.08.19.09.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 09:29:54 -0700 (PDT)
Subject: Re: [PATCH 0/5] lpfc: fixes for SCSI EH rework
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210818090827.134342-1-hare@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <996b714d-e316-33ff-706b-7bac162587e8@gmail.com>
Date:   Thu, 19 Aug 2021 09:29:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210818090827.134342-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/18/2021 2:08 AM, Hannes Reinecke wrote:
> Hi all,
> 
> with the SCSI EH rework the scsi_cmnd argument for the SCSI EH callbacks
> is going away, so we need to fixup the drivers to work without it.
> 
> This patchset modifies the lpfc driver to not rely on a specific command
> for the EH callbacks.
> 
> As usual, comments and reviews are welcome.
> 
> 
> Hannes Reinecke (5):
>    lpfc: kill lpfc_bus_reset_handler
>    lpfc: drop lpfc_no_handler()
>    lpfc: use fc_block_rport()
>    lpfc: use rport as argument for lpfc_send_taskmgmt()
>    lpfc: use rport as argument for lpfc_chk_tgt_mapped()
> 
>   drivers/scsi/lpfc/lpfc_scsi.c | 138 +++++-----------------------------
>   1 file changed, 20 insertions(+), 118 deletions(-)
> 

I think I've acked all of these in their prior posting

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james

