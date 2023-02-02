Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CCD8C05027
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 18:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjBBS1V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Feb 2023 13:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjBBS1U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2023 13:27:20 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24200611F2
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 10:27:20 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id ha3-20020a17090af3c300b00230222051a6so2656912pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 02 Feb 2023 10:27:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dXReSzo1HlqJheY+xggupOvWiB85mY42hjnN8IAvOyY=;
        b=sFRdsJp9+Te+GeJChTxv5o7bQsHmy7QHvVaYYkASB3T1CrwWlN0J7mix6XmZ7dl+vQ
         J4Yf4+7gyMkOOliKHOcHq6FvvePCEpa5rxxu/VE8UvdiNB64eYhhzAaqq7JQtsS8OkuZ
         KVlze8QQoj1Y9/TYrAF7uS8mBUKmy5CMhc2EDbNuKuAX2Nde+pI0VjYyN0YsilQjVZKS
         EZeprzarAjtqdY1HuGdUH08DbMhO6s+fKslbMOQAf61mNkjxvjdSGtDfdprNJzJ6sHRz
         q50TeNslXZB/SlN35Srn/m+W6ABT8uz53Z7NfoO+UClfFnDzdssN5LlfrINwJqRGZ7yP
         UWGw==
X-Gm-Message-State: AO0yUKXT+1l3cY1EP0foY/6OiiP2P5MD5Kcu2Ca/Ct70Son5NJIUWCjE
        c50jjvsiJu1pFupyv6V+tJk=
X-Google-Smtp-Source: AK7set9RFQzkJPjbPrUo+uvU+26li0BXQUsK9XJ/0nMlXyBL0MskrdcxKWwHlIJEATgRgj+4ouStug==
X-Received: by 2002:a17:90b:1d02:b0:22c:b47f:d5fe with SMTP id on2-20020a17090b1d0200b0022cb47fd5femr7401928pjb.14.1675362439489;
        Thu, 02 Feb 2023 10:27:19 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:bf7f:37aa:6a01:bf09? ([2620:15c:211:201:bf7f:37aa:6a01:bf09])
        by smtp.gmail.com with ESMTPSA id o60-20020a17090a0a4200b00229bc852468sm3539252pjo.0.2023.02.02.10.27.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 10:27:18 -0800 (PST)
Message-ID: <0e955a31-1d3a-beca-4581-dbcdefc47674@acm.org>
Date:   Thu, 2 Feb 2023 10:27:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] scsi: ufs: probe hba and add lus synchronously
Content-Language: en-US
To:     Adrien Thierry <athierry@redhat.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20230202182116.38334-1-athierry@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230202182116.38334-1-athierry@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/2/23 10:21, Adrien Thierry wrote:
> This patch fixes both the warning and the deadlock, by probing hba and
> lus synchronously during ufs initialization.

I'm concerned that this change will slow down booting of Android 
devices. Please find another solution, e.g. building devfreq and the 
ondemand governor into the kernel instead of as loadable kernel modules.

Thanks,

Bart.

