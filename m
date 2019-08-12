Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76299C433FF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 21:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B6FF20820
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 21:01:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="g6QfY1Zq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbfHLVBS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 17:01:18 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:55224 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727148AbfHLVBR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Aug 2019 17:01:17 -0400
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Aug 2019 17:01:16 EDT
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 6E3B34181D;
        Mon, 12 Aug 2019 20:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        user-agent:in-reply-to:content-disposition:content-type
        :content-type:mime-version:references:message-id:subject:subject
        :from:from:date:date:received:received:received; s=mta-01; t=
        1565643143; x=1567457544; bh=PIs0l6x5WlVYSwUmGFm7oRRXxRMo+cpPQ/z
        7SC15QZo=; b=g6QfY1ZqxMi/RuJJ5R7TvHXRJf+728wR2dcuzDC6xups+SU6Cyl
        48XNeeXr0pXLGhoet3MVjKuyEzfBUKWVcDPdJcwzi/krV8TiEWOELu9EOo8io0OK
        WKY9Uz1JOg52e5wdJ2XNn+gnQJKh8JvdoLhwd6WrMk8OST003Wb+EfbY=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WrcUC9xcDsEy; Mon, 12 Aug 2019 23:52:23 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 31F17412D0;
        Mon, 12 Aug 2019 23:52:23 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 12
 Aug 2019 23:52:22 +0300
Date:   Mon, 12 Aug 2019 23:52:22 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: Re: [PATCH v2 46/58] qla2xxx: Make qlt_handle_abts_completion() more
 robust
Message-ID: <20190812205222.qmse275ofl3g52bk@SPB-NB-133.local>
References: <20190809030219.11296-1-bvanassche@acm.org>
 <20190809030219.11296-47-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190809030219.11296-47-bvanassche@acm.org>
User-Agent: NeoMutt/20180716
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 08, 2019 at 08:02:07PM -0700, Bart Van Assche wrote:
> Avoid that this function crashes if mcmd == NULL.
> 
> Cc: Himanshu Madhani <hmadhani@marvell.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index d25c3fa43601..cc0c99b5f3fb 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -5731,7 +5731,7 @@ static void qlt_handle_abts_completion(struct scsi_qla_host *vha,
>  			    entry->error_subcode2);
>  			ha->tgt.tgt_ops->free_mcmd(mcmd);
>  		}
> -	} else {
> +	} else if (mcmd) {
>  		ha->tgt.tgt_ops->free_mcmd(mcmd);
>  	}
>  }
> -- 
> 2.22.0
> 

Thanks for working on the fix, the crash can be observed sometimes on
target shutdown.

I've been inspecting the piece of code multiple times and still don't
understand if we get mcmd == NULL only when ABTS completes successfully
or there is ABTS failure together with inability to find mcmd in the
request queue? In that case, there're two more paths that could crash.

And the second question is whether the NULL received from
qlt_ctio_to_cmd is a sign of another sporadic issue somewhere else in
the driver?

Best regards,
Roman
