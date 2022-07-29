Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0360CC3F6B0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 20:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238853AbiG2UGN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 16:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiG2UGM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 16:06:12 -0400
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135C363914;
        Fri, 29 Jul 2022 13:06:09 -0700 (PDT)
Received: by mail-pg1-f179.google.com with SMTP id r186so4807971pgr.2;
        Fri, 29 Jul 2022 13:06:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=FB+0W8v8UDMpFz9rL6S4eZJw9kfVH7QjSk7HN7wEXkY=;
        b=ZL2Nad0F5qbfqgqCmDIZh/o8X9lxNfaSlUUJguj9EgE24iF+8Lwx9B2uf5ozVPHP+L
         6CiCO7ivF5wPW0EJMdE78UwPmPknQ5ayCDaQjeZHJ8PO19MZKXaY42DdLzLNsOcoxrkB
         9WseFS/LL7IIdy9iy+DmzKn1CGpxdjac+kize8btUUOZC7QWAo7JuoQ80B5Kpeher3rz
         sIigJJ5K/TjMU8xdRYz1AD1o3VzE5tsih1gno1G8lfLKInKAMWso8lapxFSvjxDhpOQW
         A04GxNwmWkxBiszCYh9ewNiR+cl+vv7CNO/n26S0budgw+4FjMy001OsLSTROv93hD8x
         TdKQ==
X-Gm-Message-State: AJIora+ZSEvOhh7gLYVudxwTv8FCRdqdv7PC6q92Kbnx8T/q4ttisWVX
        KRGraLste8rrLxAoudv7JeE=
X-Google-Smtp-Source: AGRyM1tInMycz2iLxo2bv+KHymYOshzLCE6LdcJ59I+SaA75WRa0GNpXbX3yXBDfQg1M+2RWj8IR7A==
X-Received: by 2002:aa7:8554:0:b0:52b:cfed:168b with SMTP id y20-20020aa78554000000b0052bcfed168bmr5148694pfn.4.1659125169057;
        Fri, 29 Jul 2022 13:06:09 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:f090:7a49:3465:6a5? ([2620:15c:211:201:f090:7a49:3465:6a5])
        by smtp.gmail.com with ESMTPSA id g197-20020a6252ce000000b0052531985e3esm3356171pfb.22.2022.07.29.13.06.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 13:06:08 -0700 (PDT)
Message-ID: <d473f4b3-9aba-fe39-d88c-b762d9d779b0@acm.org>
Date:   Fri, 29 Jul 2022 13:06:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V3] scsi: ufs: Get boot device storage type from command
 line
Content-Language: en-US
To:     "Chetan Chinnadagudihundi Ravindranath (Consultant) (QUIC)" 
        <quic_cchinnad@quicinc.com>
Cc:     jejb@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <1659034814-3473-1-git-send-email-quic_cchinnad@quicinc.com>
 <77330f3a-5f73-e10f-7e85-f3df304aa4d7@acm.org>
 <f1cf652a-4a36-fe60-5a98-14b9d97c9a41@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f1cf652a-4a36-fe60-5a98-14b9d97c9a41@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/29/22 05:54, Chetan Chinnadagudihundi Ravindranath (Consultant) 
(QUIC) wrote:
> Please suggest any efficient way of making ufs-cmdline part of vmlinux.

A patch description should not only explain what has been changed but 
also why a change is being made. Information about why support is being 
added for the androidboot.bootdevice parameter in the Qualcomm UFS host 
controller driver is missing from the patch description.

Please also address Christoph's comment about this new command-line 
parameter not being used anywhere in the upstream kernel tree.

Thanks,

Bart.
