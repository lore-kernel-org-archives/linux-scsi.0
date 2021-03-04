Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B29E7C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 06:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73EC564E84
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 06:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbhCDG0I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 01:26:08 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:53275 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235153AbhCDG0F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Mar 2021 01:26:05 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614839144; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=mfsvHB9fDbs1Qdb97UhB6YQLLdl8ZqvKH01Jl/iGVFA=;
 b=R7Cxq/wUaeFgFtU6H9s/T/pEaQeGQXplzCVL6tCl+5Nl9y3Snuv+ExSkx2QwqabxX6BpetZP
 ZMZk3qBMvp8xu/ZflLzTUfo2Nic6R2uMT/NQ+MQmSND87FRvv9Aq4s8pIqENmqxszZBUFnqg
 54+A5MJmmKdAKyrx2Bjrnop5ZJM=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 60407d4d64e0747df94e11a9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 04 Mar 2021 06:25:17
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 23CE1C43467; Thu,  4 Mar 2021 06:25:16 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 895AEC433CA;
        Thu,  4 Mar 2021 06:25:15 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 04 Mar 2021 14:25:15 +0800
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
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: Re: [PATCH v26 4/4] scsi: ufs: Add HPB 2.0 support
In-Reply-To: <20210303062926epcms2p6aa6737e5ed3916eed9ab80011aad3d83@epcms2p6>
References: <20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p2>
 <CGME20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p6>
 <20210303062926epcms2p6aa6737e5ed3916eed9ab80011aad3d83@epcms2p6>
Message-ID: <94311b42ef6ee34ba5908fcefefa4010@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> 
> -	if (!ufshpb_is_support_chunk(transfer_len))
> -		return;
> +	if (!ufshpb_is_support_chunk(hpb, transfer_len) &&
> +	    (ufshpb_is_legacy(hba) && (transfer_len != 
> HPB_LEGACY_CHUNK_HIGH)))
> +		return 0;
> 

This is looks awkward, can we put the checks in 
ufshpb_is_support_chunk()?

Thanks,

Can Guo.
