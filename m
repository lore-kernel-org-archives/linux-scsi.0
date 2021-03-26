Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399F1C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 04:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED53A61A42
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 04:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhCZEwn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Mar 2021 00:52:43 -0400
Received: from gateway33.websitewelcome.com ([192.185.145.190]:32858 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229519AbhCZEwc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Mar 2021 00:52:32 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Mar 2021 00:52:32 EDT
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id A3D24D41E
        for <linux-scsi@vger.kernel.org>; Thu, 25 Mar 2021 23:07:19 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id PdkllrCflL7DmPdkllIExX; Thu, 25 Mar 2021 23:07:19 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BabjA7K6Rd4GbMEOPxHc3o+Eu2YyL/Dtp8lkz/vVHUc=; b=DDPetxrWqLa80enjnpAuxTSSBj
        ZGVMZsEaBiBHxQI7jQ5AAMrk0KTPuGaRqQkmsmTOLTQi3Ksyf2Rn2uiVMt15l9TWI4HkDzZsF3vto
        ghD5Hkdb2Ly9Av9BVnXWykCja6MFp7zxjZqAIFsq3dCJ+8blURFVCZnLyj9IGCxgb4Q/yQSa/7vlR
        7bg5e7qo9yM4T1iYwgMF1YvOSJ4Tuh9ZUKQA0g04+uwHV5qIUnDPgS+ARhB3bT3l82UZGPFKG1H6k
        iihigTYAMcSyU3p5Ifmf0072orwtuM/vIMXhcrOgfO4vXheFJuJSVZYs/vP7r8FRsHcbiiUdLkd0m
        87/owZGw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:58534 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lPdkk-0002mT-N0; Thu, 25 Mar 2021 23:07:19 -0500
Subject: Re: [PATCH][next] scsi: aacraid: Replace one-element array with
 flexible-array member
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210304203822.GA102218@embeddedor>
 <yq135wkm410.fsf@ca-mkp.ca.oracle.com>
 <668e3f30-1ffb-31e3-231b-705489993885@embeddedor.com>
 <yq1a6qqk68h.fsf@ca-mkp.ca.oracle.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <d79bde59-16c5-e006-0e31-c33c17f0ce3d@embeddedor.com>
Date:   Thu, 25 Mar 2021 22:07:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <yq1a6qqk68h.fsf@ca-mkp.ca.oracle.com>
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
X-Exim-ID: 1lPdkk-0002mT-N0
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:58534
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 5
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,


On 3/25/21 22:34, Martin K. Petersen wrote:
> 
> Gustavo,
> 
>> Precisely this sort of confusion is one of the things we want to avoid
>> by using flexible-array members instead of one-element arrays.
> 
> Ah, you're right!
> 
> Now that I look at it again I also don't think that was the issue that
> originally caused concern.
> 
> @@ -4020,7 +4020,8 @@ static int aac_convert_sgraw2(struct aac_raw_io2 *rio2, int pages, int nseg, int
>  		}
>  	}
>  	sge[pos] = rio2->sge[nseg-1];
> -	memcpy(&rio2->sge[1], &sge[1], (nseg_new-1)*sizeof(struct sge_ieee1212));
> +	memcpy(&rio2->sge[1], &sge[1],
> +	       flex_array_size(rio2, sge, nseg_new - 1));
>  
>  	kfree(sge);
>  	rio2->sgeCnt = cpu_to_le32(nseg_new);
> 
> I find it counter-intuitive to use the type of the destination array to
> size the amount of source data to copy. "Are source and destination same

The destination and source arrays are of the same type. :)

drivers/scsi/aacraid/aachba.c:
3999         struct sge_ieee1212 *sge;

> type? Does flex_array_size() do the right thing given the ->sge[1]
> destination offset?". It wasn't immediately obvious. To me, "copy this
> many scatterlist entries" in the original is much more readable.

Yeah; it does the right thing because flex_array_size() doesn't know about
offsets. It just calculates the amount of bytes to be copied based on the
type of the object passed as second argument and a "count" passed as third
argument. So, in this case, the "count" is "nseg_new - 1", which in some
way is already taking care of that sge[1] offset.

--
Gustavo
