Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F315C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Feb 2023 15:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbjBIP0x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Feb 2023 10:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjBIP0w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2023 10:26:52 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B815E977B
        for <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2023 07:26:50 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id w5so3144629plg.8
        for <linux-scsi@vger.kernel.org>; Thu, 09 Feb 2023 07:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+UdBZmdkOhEPaPhlAj4vTlNEap6Ax6LJyB/F057B7Qw=;
        b=fXeKs4eiZbcH1bx5GOxL4ZVo+V+WE4jESFTPo0j4XJPufZsKMzSIN3S+PnmXWD2jze
         MJ0FdxxO1EmON8v6n5PwCOD/AlPp6u8kOiszkOnxGHI0rkTo8vVtyBkSIl5hYuEQHI6L
         pPIOp5N2HffI2l69OTDoWoypEuB4cxzwLRRxQamE6E8FvlVtBAKiNawXe+phVYIzSQnq
         Fihw7CMp5JQ+RFxJM2ImkmaOYMVhVgg3aXvn0NMV5ipMmhT7x3xPMKy1ENtc1D6Bm1PS
         Q7mbyUaooME57T//R77kpaZL1hWMDA3nU8/gzz4RNioegqI4Y8UcsqmhkGlhBZW/naNi
         CJOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+UdBZmdkOhEPaPhlAj4vTlNEap6Ax6LJyB/F057B7Qw=;
        b=s4q6/Qlf6808Uj80asykNAx8oFIgk9nsZWKXFUMBpTA0S4vdcf2wgGTMhRRoMTGrUo
         3y/YRDWcknkBSShCTJBmnpSVfCJew9eJ5+x26+xBNNYj748CaD/QQctEBoy1z1b9SV9p
         PnbYCXaeDnrkP0KA9NMgDAW9mjlQ7Z6JV9uwPdFu8BUC63LaUakrpEIuzHTW9eS9aRwk
         XDUCTqAthclge4EoBD0rVbsrhK/1/Uw0svhUBCAudeYv4mkobX9Uq9Mj/gCY9hy7zyzw
         beEd71EZbly1tkc0SWcrLoqHJc9a9ChE1uhlSpyXrq6pSy2k2/ZX8V6Xy4xwYnd8VF50
         Tt1Q==
X-Gm-Message-State: AO0yUKXUUsgVIWoJurONoDxg9NNEDos+qSIwii+pijF8hWmADbdi2uUH
        m/xkI1vj8u3iJiYbj+Oqgek=
X-Google-Smtp-Source: AK7set/ffJdqRgAX73nP/Ove3iSHGnWM875sJ+CxTv5ffBq4GMDUSgWCQnvIcuaSWWeHaNVARnvVdA==
X-Received: by 2002:a05:6a20:1611:b0:be:9e43:82be with SMTP id l17-20020a056a20161100b000be9e4382bemr14684958pzj.16.1675956410175;
        Thu, 09 Feb 2023 07:26:50 -0800 (PST)
Received: from [192.168.50.208] (ip68-109-79-27.oc.oc.cox.net. [68.109.79.27])
        by smtp.gmail.com with ESMTPSA id y21-20020a634b15000000b004eca54eab50sm605808pga.28.2023.02.09.07.26.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 07:26:49 -0800 (PST)
Message-ID: <84a86eeb-c60b-aa3b-64cf-2dbc2aeffcc7@gmail.com>
Date:   Thu, 9 Feb 2023 07:26:48 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] scsi:scsi_transport_fc:Add an additional flag to
 fc_host_fpin_rcv()
Content-Language: en-US
To:     Muneendra Kumar <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     hare@suse.de, emilne@redhat.com, mkumar@redhat.com,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
References: <20230209034326.882514-1-muneendra.kumar@broadcom.com>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <20230209034326.882514-1-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/2023 7:43 PM, Muneendra Kumar wrote:
> From: Muneendra <muneendra.kumar@broadcom.com>
> 
> The LLDD and the stack currently process FPINs received from the fabric,
> but the stack is not aware of any action taken by the driver to alleviate
> congestion. The current interface between the driver and the SCSI stack is
> limited to passing the notification mainly for statistics and heuristics.
> 
> The reaction to an FPIN could be handled either by the driver or by the
> stack (marginal path and failover). This patch enhances the interface to
> indicate if action on an FPIN has already been reacted to by the
> LLDDs or not.Add an additional flag to fc_host_fpin_rcv() to indicate
> if the FPIN has been acknowledged/reacted to by the driver.
> 
> Also added a new event code FCH_EVT_LINK_FPIN_ACK to notify to the user
> that the event has been acknowledged/reacted by the LLDD driver
> 
> Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc_els.c     |  2 +-
>   drivers/scsi/qla2xxx/qla_isr.c   |  2 +-
>   drivers/scsi/scsi_transport_fc.c | 10 +++++++---
>   include/scsi/scsi_transport_fc.h |  4 +++-
>   4 files changed, 12 insertions(+), 6 deletions(-)
> 

Reviewed-by: James Smart <jsmart2021@gmail.com>

Looks good.

Thanks

-- james


