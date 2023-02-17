Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61328C636D6
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Feb 2023 21:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBQVf2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Feb 2023 16:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjBQVf2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Feb 2023 16:35:28 -0500
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7220461859
        for <linux-scsi@vger.kernel.org>; Fri, 17 Feb 2023 13:35:25 -0800 (PST)
Received: by mail-pl1-f175.google.com with SMTP id f8so2933200plr.10
        for <linux-scsi@vger.kernel.org>; Fri, 17 Feb 2023 13:35:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3B5c+BDFGRsoxxkn1mVjIriRZj7zrFh+tjcJdk07gIE=;
        b=m7DmNiUcgvTIQxXfNM9fs3utT4lwPpVf0efzgqqTJUw4m0xGAEki4jjhtmD0rmUn++
         dUJqmwT4XxIZL4o98GkZwIfo+horsSNoRm5cNk04msN2pIIc4rkf5gNvHpwhzvAPD3k5
         HMYFHBmtWjRmPE1jkUyIs4mxvw6wuoIE+FHxP4FHpVrqCYCC6vbYbs6VwomUvWt5tRye
         64OJIiHEpwE4OjrePBMbYYoYW5qrywHN8c92Ho/g343E8HV2kuUaRiva/msRMhyTOiOK
         KaKRm5CVkPWGTUoq7TlFZyBFSx1JsJtZmHpYEkNQrnRznVN0Kd10XFae5jk4/kpisZHC
         0k/A==
X-Gm-Message-State: AO0yUKU9fUcqYBXH1ehW6cOcyxjoS55enkIR70NJDGOPVe9sYwf92KsG
        TkhjIhiwuCxgF0qXqzdSzcg=
X-Google-Smtp-Source: AK7set9uzu/9c+y9chCP+7gaPabSkKSP29ldPoQ6npmWcue5sZ64EkqyYXH7cOLhqAvhVFW0OKXHaA==
X-Received: by 2002:a17:903:18b:b0:19a:924f:e509 with SMTP id z11-20020a170903018b00b0019a924fe509mr1758369plg.57.1676669724718;
        Fri, 17 Feb 2023 13:35:24 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:832f:7b01:7693:4be? ([2620:15c:211:201:832f:7b01:7693:4be])
        by smtp.gmail.com with ESMTPSA id x17-20020a170902ea9100b0019a6cce2060sm3585840plb.57.2023.02.17.13.35.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Feb 2023 13:35:23 -0800 (PST)
Message-ID: <352f6339-ebd2-bb87-3607-3751e9093bfe@acm.org>
Date:   Fri, 17 Feb 2023 13:35:21 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3] scsi: ufs: initialize devfreq synchronously
Content-Language: en-US
To:     Adrien Thierry <athierry@redhat.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20230217194423.42553-1-athierry@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230217194423.42553-1-athierry@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/17/23 11:44, Adrien Thierry wrote:
> During ufs initialization, devfreq initialization is asynchronous:
> ufshcd_async_scan() calls ufshcd_add_lus(), which in turn initializes
> devfreq for ufs. The simple ondemand governor is then loaded. If it is
> built as a module, request_module() is called and throws a warning:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
