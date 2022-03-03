Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49AF8C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 21:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbiCCVHX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Mar 2022 16:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234395AbiCCVHW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2022 16:07:22 -0500
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2ACD4CAC
        for <linux-scsi@vger.kernel.org>; Thu,  3 Mar 2022 13:06:36 -0800 (PST)
Received: by mail-pg1-f178.google.com with SMTP id 6so1217507pgg.0
        for <linux-scsi@vger.kernel.org>; Thu, 03 Mar 2022 13:06:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fYK9iS3VwUHayMTX9GEVvQlQTgbQbyUzigqv/h3uHEA=;
        b=RibNvZ8biwF/6mAeDuq+lEft16P0cH7jUi7Yq2IBu8tHMoVLi7WUVW6pM4iSyeLKzg
         rsielDbJOSUUvfNcQE5JaUhbPyzaeKbpMzHDh38vlBHVtwvvn0GjsG+8Wx3qnx0yVugu
         4LPg2ug3/NB2XuKcXSSVta12m7l0IcVxJwbKUCqYXGM4geK1PCW+WXZQklmqSlzPBBym
         Gvkto7KEbXTaUiEhcLlHiufxhHA/FEkoxfy2Omgn33gwXjmnZgB0Wm44VZAs9JpwJIdN
         2j4hyAeII5FFQSkSYQeEfICffYd/uF0Otgh89KTtKQIO7sLyOKVmJ0I3w5vckpizBOum
         GLog==
X-Gm-Message-State: AOAM533H2GSW9y/5JiNiIeHob6gaKXXfV0pGPbAHie5tUI4ol46R8LOT
        WWhbmfixocUtOjEF+fgck6vnbT49DwU=
X-Google-Smtp-Source: ABdhPJzSFzz6D2olWFeFIrnFdFYzsaHyu9OKT8FoKYXAxsyIwhOIHdknGdgxG96lEAqiw/2UEzQcfA==
X-Received: by 2002:a63:7e43:0:b0:374:75ce:4d80 with SMTP id o3-20020a637e43000000b0037475ce4d80mr31679256pgn.589.1646341596005;
        Thu, 03 Mar 2022 13:06:36 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id bd6-20020a056a00278600b004f68f9fbbd5sm1837593pfb.129.2022.03.03.13.06.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 13:06:35 -0800 (PST)
Message-ID: <c088db8c-19cf-182f-8d2f-e990b5a0c35c@acm.org>
Date:   Thu, 3 Mar 2022 13:06:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 09/14] scsi: sd: Fix discard errors during revalidate
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-10-martin.petersen@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220302053559.32147-10-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/22 21:35, Martin K. Petersen wrote:
> +	if (mode == SD_LBP_DEFAULT)
> +		sdkp->provisioning_override = false;
> +	else
> +		sdkp->provisioning_override = true;

This can be changed into the following?

sdkp->provisioning_override = mode != SD_LBP_DEFAULT;

> +	if (mode == SD_LBP_DEFAULT && !sdkp->provisioning_override) {

Hmm ... is provisioning_override ever true for the SD_LBP_DEFAULT mode? If not, 
can "&& !sdkp->provisioning_override" be left out?

> +	bool		lblvpd;

Please add a comment that explains what lblvpd stands for.

Thanks,

Bart.
