Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3DEEC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Nov 2023 14:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbjKCO51 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Nov 2023 10:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjKCO51 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Nov 2023 10:57:27 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A26134
        for <linux-scsi@vger.kernel.org>; Fri,  3 Nov 2023 07:57:24 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1cc2575dfc7so17853925ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Nov 2023 07:57:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699023444; x=1699628244;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/pQmloQJnPzW3AQi+grxv5YPEbH7FoGxYsG2frmI2Ik=;
        b=QTHrZVdwftp4JfLd/KPnD2EXuWcJeqDdJM4C4zZvOrEJUQpFm838Sn6qE03Ir8Cryv
         M5zz31rnzOnPJdoAUuNbI+jieVYTvDLlTO3L7GTh16+4oK0SkfJq4bpQ5P5L/1ceHbYq
         uYREvVgt3jyMw2LEvtovo9QpJVCTMKIac8PCRgS9FggxwKOPXt8ddtFSysQPXKP2TEmB
         XYuz7MkUXx0ViL6IJoDW/Zonlcss8Cg/DrlTG5obAUmhgdDfWT6YsHkWC4E5GdYvejXZ
         LCX3x18QbEd3+FtFFqQ2n5f0dy9NUgfsNLBOiuryyrnkcYf9rs3mT62IYP9H/rrrXs7e
         LzsA==
X-Gm-Message-State: AOJu0Yz3lsA+mTmsUaW0ND9ev2pndxSuTORwMf56mbngwhbN+K8H7Qbn
        htQh4oQMPUrk6OVnrr/hpUo=
X-Google-Smtp-Source: AGHT+IGw7ClGS24M2p/OtXtTzs7B2bXAaeiosKkYdtiBRLKDcjbT9LerWlVVCM0Xu0491oL017zk/g==
X-Received: by 2002:a17:90b:111:b0:27d:61ff:3d3b with SMTP id p17-20020a17090b011100b0027d61ff3d3bmr18548594pjz.38.1699023443825;
        Fri, 03 Nov 2023 07:57:23 -0700 (PDT)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id ml3-20020a17090b360300b0028010142010sm1558584pjb.21.2023.11.03.07.57.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Nov 2023 07:57:22 -0700 (PDT)
Message-ID: <a017262a-b367-4500-90a9-bc099fe08a5d@acm.org>
Date:   Fri, 3 Nov 2023 07:57:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: fix racing issue between ufshcd_mcq_abort
 and ISR
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com
References: <20231027084329.4067-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231027084329.4067-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/23 01:43, peter.wang@mediatek.com wrote:
> If command timeout happen and cq complete irq raise at the same time,
> ufshcd_mcq_abort null the lprb->cmd and NULL poiner KE in ISR.

Please add a Fixes: tag. Otherwise this patch looks good to me.

Thanks,

Bart.
