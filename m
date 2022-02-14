Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0826FC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 23:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbiBNXPK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 18:15:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbiBNXPF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 18:15:05 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F081B1260;
        Mon, 14 Feb 2022 15:14:55 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso771335pjt.4;
        Mon, 14 Feb 2022 15:14:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nETstMqDsUgY1ol5sqoAgcJEiMxxRMwJ0IST7xoKWd0=;
        b=ZI+QWe6I2r5XK3Bh8Ts2DCdhnJ6jy4q5BNs+QLJWsKNniZ8repowxt3PKFUpp7sByD
         NYKVfyFuCDIXn0wYM3lVcG2SeOMEjkH5/c2RDwlHXvMZwF2LRRXRx7qcscyb9qURSCDK
         MrIr4dDaKSGPCZU6OJQRhnYJg9/JTtQSQ3Cx3ab10PuOecnfA/G4pf2a4LF0737jOX/F
         SueK/l4oyo/AGqwSSUCiKUtA/BdBfCKuxTTtqvxKIKo7EKkvKOMu6PXrGdPJ2F/792eF
         C/oIMAEaleJI0bz0QdWO8jNqVq8EZOVf6oN5VfIJDsKLsps8Be/POcK8nr9LPWtaKKCx
         XNIA==
X-Gm-Message-State: AOAM531Umnm7SUmqxeUWHgDE04ed9qeonrdAI5YbJli52UryITnGGL2X
        UZxLC2pBNFZQjEsae39ZH+E=
X-Google-Smtp-Source: ABdhPJyISTaL3/LMs7A46KrDWriQGEXzZP/4aFrcZTJKZrQm2ZhmFcx0Z7XHKRwBxy6ZuS5DOAm3nA==
X-Received: by 2002:a17:902:eb8c:: with SMTP id q12mr1192716plg.131.1644880494523;
        Mon, 14 Feb 2022 15:14:54 -0800 (PST)
Received: from ?IPV6:2600:1010:b05a:bf8:a70d:56bb:b427:8042? ([2600:1010:b05a:bf8:a70d:56bb:b427:8042])
        by smtp.gmail.com with ESMTPSA id q1sm20435010pfs.112.2022.02.14.15.14.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 15:14:53 -0800 (PST)
Message-ID: <7a324bb2-c748-4d48-8f55-13f35de5a35e@acm.org>
Date:   Mon, 14 Feb 2022 15:14:51 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] scsi: ufs: Fix divide zero case in ufshcd_map_queues()
Content-Language: en-US
To:     j-young.choi@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CGME20220214103352epcms2p79697c0fcaa2755dd89af9de887ff14cd@epcms2p7>
 <1891546521.01644873481638.JavaMail.epsvc@epcpadp4>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1891546521.01644873481638.JavaMail.epsvc@epcpadp4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/14/22 02:33, Jinyoung CHOI wrote:
> Before calling blk_mq_map_queues(), the mq_map and nr_queues belonging
> to "struct blk_mq_queue_map" must be a vaild value.
                                     ^^   ^^^^^
                                   have   valid

> If nr_queues is set to 0, the system may encounter the "divide zero"
> depending on the type of architecture.

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
