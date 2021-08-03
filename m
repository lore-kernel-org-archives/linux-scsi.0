Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 335E4C4338F
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 17:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EEEB61029
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 17:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237437AbhHCRBm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Aug 2021 13:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237582AbhHCQ6s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2021 12:58:48 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B00AC061388;
        Tue,  3 Aug 2021 09:57:32 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id k4so12874365wms.3;
        Tue, 03 Aug 2021 09:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=GjLc7onVdzdr8zDnow2vfGguyGyW9hjky8/FH15iwqc=;
        b=o+02R0oINmfghGgFaSZDs1kl7pKeMfhT6v5PMbdfZYAItdge960vVkgB/FXgv0YoT9
         bicCvJLBEbt5RdOwxAhLvh8t6inMcWu8ljzTud+xwlRCtpvoo1sszUAsMtGgrzd6PK5u
         aE3wfYWwZhgLHQuSv0GW9Ra4vD4PZtHDJ779xjYzWsaAWAtDSky3Z753paV/OlsF5xro
         tgpuc8n7I5zWCC4FfHYgOTSnWuabDeoDCabjt5lNYWGcUdMQH1T7MOoHGssP8szgDzyy
         8/ZoSjonu51+FTIDUjL9EE5dl0rKUpThT8rGSm4XU6Uz8Kf9QFvqj+S1pZnpbD3AmFpS
         MVLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=GjLc7onVdzdr8zDnow2vfGguyGyW9hjky8/FH15iwqc=;
        b=VbGaTmBr3kSBmW8g98ZZbUyCL5Y59JDkPMz1BX3mBX/235UVlBOX9Fi9ME3w+YQRdj
         tvOATys7KoAR4DHeLEEyohg9kTum9jF3vBpZ8wZZfDNvmcpdsRz5GPg7rW/z96nA0G/2
         1sTekFH3CPZ5ydTf4vaHIQ/OpAodKG9+OxHtGIMPqdpScDkSiplVm9kguT5cQVgknn0p
         DBAa05WRDE8ZrvIeZayvRVmmZ7g1S0EVvwpQnaMvR8BSmc/SqHyJpotYOhljlKtN9XH3
         PEWSL8+ALxzw0TngGULgfo+3+7SCeq1E12AW9zZWSjIY89NBHGQTqb1ScXhfDwtEKmhE
         QuKA==
X-Gm-Message-State: AOAM532LyhzwvgQyboTp0n0jcuZ/5wUDrB671aEcgKSr1YJsVzTfESk9
        /8F0dLr68o75oevMVcHXqF4=
X-Google-Smtp-Source: ABdhPJwHbIUNR0p/86NH4ueKS6v7ZicJ3tHWqv+a3IF4Mc469T9Eu5jXhS8GFZyEFJSnUNd9wGjvsw==
X-Received: by 2002:a1c:7c10:: with SMTP id x16mr23041319wmc.41.1628009851136;
        Tue, 03 Aug 2021 09:57:31 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.googlemail.com with ESMTPSA id s1sm3103057wmj.8.2021.08.03.09.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:57:30 -0700 (PDT)
Message-ID: <73a79fbbec661cd898feda9064a10c6c182d7fad.camel@gmail.com>
Subject: Re: [PATCH 14/15] scsi: ufs: ufs-exynos: multi-host configuration
 for exynosauto
From:   Bean Huo <huobean@gmail.com>
To:     Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Can Guo <cang@codeaurora.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org
Date:   Tue, 03 Aug 2021 18:57:28 +0200
In-Reply-To: <20210709065711.25195-15-chanho61.park@samsung.com>
References: <20210709065711.25195-1-chanho61.park@samsung.com>
         <CGME20210709065747epcas2p10c59e097d9770fc02134cb0545c9de4f@epcas2p1.samsung.com>
         <20210709065711.25195-15-chanho61.park@samsung.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-07-09 at 15:57 +0900, Chanho Park wrote:
> We divide this M-HCI as PH(Physical Host) and VHs(Virtual Host). The
> PH
> 
> supports all UFSHCI functions(all SAPs) same as conventional UFSHCI
> but
> 
> the VH only supports data transfer function. Thus, except UTP_CMD_SAP
> and
> 
> UTP_TMPSAP, the PH should handle all the physical features.

Hi Chanho park,

You mentioned this in your coverletter:

"There are two types of host controllers on the UFS host controller
that we designed. The UFS device has a Function Arbitor that arranges
commands of each host. When each host transmits a command to the
Arbitor, the Arbitor transmits it to the UTP layer".

where does this "Function Arbitor" exit? From your comments, seems it
exists on the UFS device side? right? If this is true, where is related
code in your patch?? Maybe you only submited partial of your real
driver parch for this controller??

Bean

