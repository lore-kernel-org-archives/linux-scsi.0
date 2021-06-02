Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D98E4C47083
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 19:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE5D6613E9
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 19:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhFBTIC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 15:08:02 -0400
Received: from gateway20.websitewelcome.com ([192.185.69.18]:20655 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229491AbhFBTHz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 15:07:55 -0400
X-Greylist: delayed 1425 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jun 2021 15:07:55 EDT
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id EA65E400D85CB
        for <linux-scsi@vger.kernel.org>; Wed,  2 Jun 2021 13:29:09 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id oVmvlSSpUVBxyoVmvlvrAh; Wed, 02 Jun 2021 13:40:21 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2+ckpTm7lC7sdsELuV1F3Ug7vq+/kF0ixFZ4mssOTYk=; b=bjBGFnyNlgjsN/VB7sJaQ9zp7F
        6aGjV3FuZ64vfzF9XdbUciQBC2LvZrnCkdnPbaQQiJdhBRzA+Qxvk9/PCxj7A2YowYig43ql/DJ+i
        Ii4O7zxpy0jwBq3Idu3YmZJg2TR64qt5Zqc3v3GOb7bA1TMxsTmNJmNmA/Oc4nmq2bt65I7Tc5hN6
        lnT++xh/N8xgW0U3adCP1DjzeGUFhQUOuADapf/9d4KSmnV3iBMHgBBwB6Cz7Z9WFdbL2iFZ3u/Al
        9c6O4Sbjsxxe9vHqArvipwsC0CRTYZByysk4FC7939f43cIPB708ragh8jVEWv5T5Rjg1dv1JB7EB
        DopBmrcw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:52308 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1loVmr-004LkR-2L; Wed, 02 Jun 2021 13:40:17 -0500
Subject: Re: [PATCH v2] scsi: fcoe: Statically initialize flogi_maddr
To:     Kees Cook <keescook@chromium.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Joe Perches <joe@perches.com>, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210602180000.3326448-1-keescook@chromium.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <389cfd5c-ea78-2da9-9d00-8743eda8bb0d@embeddedor.com>
Date:   Wed, 2 Jun 2021 13:41:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210602180000.3326448-1-keescook@chromium.org>
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
X-Exim-ID: 1loVmr-004LkR-2L
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:52308
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 7
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/2/21 13:00, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy() avoid using an inline const buffer
> argument and instead just statically initialize the destination array
> directly.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
--
Gustavo

> ---
> v2:
>  - use "static const" (Joe)
> v1: https://lore.kernel.org/lkml/20210528181337.792268-2-keescook@chromium.org/
> ---
>  drivers/scsi/fcoe/fcoe.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index 89ec735929c3..5ae6c207d3ac 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -293,7 +293,7 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
>  	struct fcoe_ctlr *fip = fcoe_to_ctlr(fcoe);
>  	struct netdev_hw_addr *ha;
>  	struct net_device *real_dev;
> -	u8 flogi_maddr[ETH_ALEN];
> +	static const u8 flogi_maddr[ETH_ALEN] = FC_FCOE_FLOGI_MAC;
>  	const struct net_device_ops *ops;
>  
>  	fcoe->netdev = netdev;
> @@ -336,7 +336,6 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
>  	 * or enter promiscuous mode if not capable of listening
>  	 * for multiple unicast MACs.
>  	 */
> -	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
>  	dev_uc_add(netdev, flogi_maddr);
>  	if (fip->spma)
>  		dev_uc_add(netdev, fip->ctl_src_addr);
> @@ -442,7 +441,7 @@ static void fcoe_interface_remove(struct fcoe_interface *fcoe)
>  {
>  	struct net_device *netdev = fcoe->netdev;
>  	struct fcoe_ctlr *fip = fcoe_to_ctlr(fcoe);
> -	u8 flogi_maddr[ETH_ALEN];
> +	static const u8 flogi_maddr[ETH_ALEN] = FC_FCOE_FLOGI_MAC;
>  	const struct net_device_ops *ops;
>  
>  	/*
> @@ -458,7 +457,6 @@ static void fcoe_interface_remove(struct fcoe_interface *fcoe)
>  	synchronize_net();
>  
>  	/* Delete secondary MAC addresses */
> -	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
>  	dev_uc_del(netdev, flogi_maddr);
>  	if (fip->spma)
>  		dev_uc_del(netdev, fip->ctl_src_addr);
> 
