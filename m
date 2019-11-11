Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D11C1C43331
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 17:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8FB92173B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 17:32:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="SqCK8jYB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfKKRcX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 12:32:23 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:45160 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726763AbfKKRcW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Nov 2019 12:32:22 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 2C135411D9;
        Mon, 11 Nov 2019 17:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        user-agent:in-reply-to:content-disposition:content-type
        :content-type:mime-version:references:message-id:subject:subject
        :from:from:date:date:received:received:received; s=mta-01; t=
        1573493539; x=1575307940; bh=VRbk039SuTyl94+al1WLDW44hs3Kd0uQqm/
        zaMNHqos=; b=SqCK8jYBhb6h98cBYZ9U8j9u5iXzqtosqapnq9sQ8ZOmvXfHd0c
        bVitVXXpI0v88gK/izOeK98vTPmt0CycRFF1Xq1TeHhYeIzpbPaW3JhzqIETLxTf
        QA20NwGrsRa8mTMC1IYQnMqnWGPWvLFBK/Bdd0qvjMIeE7kaZuFZoNe8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tyIsa3l5oh_q; Mon, 11 Nov 2019 20:32:19 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 130E9404CF;
        Mon, 11 Nov 2019 20:32:18 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 11
 Nov 2019 20:32:17 +0300
Date:   Mon, 11 Nov 2019 20:32:15 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Thomas Abraham <tabraham@suse.com>
CC:     <hmadhani@marvell.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hare@suse.com>
Subject: Re: [PATCH] scsi: qla2xxx: avoid crash in
 qlt_handle_abts_completion() if mcmd == NULL
Message-ID: <20191111173215.a35ffurfmfy7ffbz@SPB-NB-133.local>
References: <20191104181803.5475-1-tabraham@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191104181803.5475-1-tabraham@suse.com>
User-Agent: NeoMutt/20180716
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Thomas,

The fix for the issue was sent earlier:
https://patchwork.kernel.org/patch/11141981/

It's not important to me what fixes goes into tree but I'd like to keep
the commit message because it covers how the situation arises. Also, the
cover letter of the patch series points out another issue not covered in
either of the fixes (lack of explicit LOGO instead of BA_RJT).

Thank you,
Roman

On Mon, Nov 04, 2019 at 01:18:03PM -0500, Thomas Abraham wrote:
> qlt_ctio_to_cmd() will return a NULL mcmd if h == QLA_TGT_SKIP_HANDLE. If
> the error subcodes don't match the exact codes checked a crash will occur
> when calling free_mcmd on the null mcmd
> 
> Signed-off-by: Thomas Abraham <tabraham@suse.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index a06e56224a55..611ab224662f 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -5732,7 +5732,8 @@ static void qlt_handle_abts_completion(struct scsi_qla_host *vha,
>  			    vha->vp_idx, entry->compl_status,
>  			    entry->error_subcode1,
>  			    entry->error_subcode2);
> -			ha->tgt.tgt_ops->free_mcmd(mcmd);
> +			if (mcmd)
> +				ha->tgt.tgt_ops->free_mcmd(mcmd);
>  		}
>  	} else if (mcmd) {
>  		ha->tgt.tgt_ops->free_mcmd(mcmd);
> -- 
> 2.16.4
> 
