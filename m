Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 328B4C433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 03:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01958619A7
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 03:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhCaDV4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 23:21:56 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:41512 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbhCaDVt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 23:21:49 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617160909; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=ivUpf+CR1j921S+V2zzG1O7pU102BuBZciI4i8H1+m0=;
 b=R2alvtBmbdzPMqdNIvcnIpY5OOasnAmalYHzuR1jmKE+enY1EUxiEDNZqGVA90CB2Er3ZdR7
 L97qz50fIbyQLrdWtWL2d7KjVpEoKOxDqQdmgqPoS53eYqIueWTPQCxvaZh1hjj6yJzq6LWy
 kSJw2R+pmrFuNNSPkz9FgzhJhps=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 6063eacc8166b7eff7b51dae (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 31 Mar 2021 03:21:48
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 13AFFC43462; Wed, 31 Mar 2021 03:21:48 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EB476C433CA;
        Wed, 31 Mar 2021 03:21:46 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 31 Mar 2021 11:21:46 +0800
From:   Can Guo <cang@codeaurora.org>
To:     daejun7.park@samsung.com
Cc:     Greg KH <gregkh@linuxfoundation.org>, avri.altman@wdc.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        asutoshd@codeaurora.org, stanley.chu@mediatek.com,
        bvanassche@acm.org, huobean@gmail.com,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
Subject: Re: [PATCH v32 4/4] scsi: ufs: Add HPB 2.0 support
In-Reply-To: <20210331011839epcms2p45d3d059fcd9e85a548014a79c3f388bc@epcms2p4>
References: <20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p3>
 <CGME20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p4>
 <20210331011839epcms2p45d3d059fcd9e85a548014a79c3f388bc@epcms2p4>
Message-ID: <0c05e460470d2b9f5aebd9b6935ef42d@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-31 09:18, Daejun Park wrote:
> This patch supports the HPB 2.0.
> 
> The HPB 2.0 supports read of varying sizes from 4KB to 512KB.
> In the case of Read (<= 32KB) is supported as single HPB read.
> In the case of Read (36KB ~ 512KB) is supported by as a combination of
> write buffer command and HPB read command to deliver more PPN.
> The write buffer commands may not be issued immediately due to busy 
> tags.
> To use HPB read more aggressively, the driver can requeue the write 
> buffer
> command. The requeue threshold is implemented as timeout and can be
> modified with requeue_timeout_ms entry in sysfs.
> 
> Reviewed-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---

Please allow me a few more days in April to have this whole series
tested one more time.

Thanks,
Can Guo.
