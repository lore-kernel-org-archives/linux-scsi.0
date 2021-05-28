Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3761FC4708D
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 21:12:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D81861378
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 21:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhE1VNs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 May 2021 17:13:48 -0400
Received: from gateway31.websitewelcome.com ([192.185.143.51]:22965 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229612AbhE1VNs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 May 2021 17:13:48 -0400
X-Greylist: delayed 1494 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 May 2021 17:13:48 EDT
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id BAA4F37389
        for <linux-scsi@vger.kernel.org>; Fri, 28 May 2021 15:25:25 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id mj2rlNHcF8ElSmj2rllfEL; Fri, 28 May 2021 15:25:25 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rq70nIWsmoQ2YZEIR9/oT6C24kx+FJeD2kfZR6jODaE=; b=DRFqCW0Hsul78XaW39HA9Gviu5
        bEkO/lDjLxUt5F9gH8w52Iw+pwrSrlqroO2RswZ7bELqwI/OTBUJRXtLbqu4/fImECv7XQrYlCflW
        653fUi5h04xYitH+V77aO3J4jcPwPgKlRlynF1KGNGgKHsFP2zIshZVQiOUJNgBoufHBs8VWEoW2F
        qsoPy3nqvVnM+j/d0Yycih543jmpv0ZI/LanPp/XSSDOTJgKAxBI67THE4/bHn7uU5lhnKaqijUPr
        4OjBVXLpFuJwuXp7LLKo4nX/8xy+egY2LANn8ml2Gd9QW3hsCoCb5NYalp218a/Ud1MBvZFRxVFVN
        RdnzImTQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:38336 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lmj2n-003gin-Ht; Fri, 28 May 2021 15:25:21 -0500
Subject: Re: [PATCH 2/3] scsi: esas2r: Switch to flexible array member
To:     Kees Cook <keescook@chromium.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210528181337.792268-1-keescook@chromium.org>
 <20210528181337.792268-3-keescook@chromium.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <d35acc33-bade-ffac-3f00-ed2ecb451316@embeddedor.com>
Date:   Fri, 28 May 2021 15:26:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210528181337.792268-3-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lmj2n-003gin-Ht
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:38336
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 14
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/28/21 13:13, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), avoid intentionally writing across
> neighboring array fields.
> 
> Remove old-style 1-byte array in favor of a flexible array[1] to avoid
> future false-positive cross-field memcpy() warning in:
> 
> esas2r_vda.c:
> 	memcpy(vi->cmd.gsv.version_info, esas2r_vdaioctl_versions, ...)
> 
> The change in struct size doesn't change other structure sizes (it is
> already maxed out to 256 bytes, for example here:
> 
>         union {
>                 struct atto_ioctl_vda_scsi_cmd scsi;
>                 struct atto_ioctl_vda_flash_cmd flash;
>                 struct atto_ioctl_vda_diag_cmd diag;
>                 struct atto_ioctl_vda_cli_cmd cli;
>                 struct atto_ioctl_vda_smp_cmd smp;
>                 struct atto_ioctl_vda_cfg_cmd cfg;
>                 struct atto_ioctl_vda_mgt_cmd mgt;
>                 struct atto_ioctl_vda_gsv_cmd gsv;
>                 u8 cmd_info[256];
>         } cmd;
> 
> No sizes are calculated using the enclosing structure, so no other
> updates are needed.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
--
Gustavo

> ---
>  drivers/scsi/esas2r/atioctl.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/esas2r/atioctl.h b/drivers/scsi/esas2r/atioctl.h
> index 4aca3d52c851..ff2ad9b38575 100644
> --- a/drivers/scsi/esas2r/atioctl.h
> +++ b/drivers/scsi/esas2r/atioctl.h
> @@ -1141,7 +1141,7 @@ struct __packed atto_ioctl_vda_gsv_cmd {
>  
>  	u8 rsp_len;
>  	u8 reserved[7];
> -	u8 version_info[1];
> +	u8 version_info[];
>  	#define ATTO_VDA_VER_UNSUPPORTED 0xFF
>  
>  };
> 
