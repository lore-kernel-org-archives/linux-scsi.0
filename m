Return-Path: <SRS0=mhd7=ZW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1770AC432C0
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Nov 2019 10:24:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC47C2075A
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Nov 2019 10:24:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="SLyp+/zQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfK3KYC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 Nov 2019 05:24:02 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:52488 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725792AbfK3KYC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 30 Nov 2019 05:24:02 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id C307843E13;
        Sat, 30 Nov 2019 10:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1575109439;
         x=1576923840; bh=kS1TZnNgm/y32AtY1lAhczcllp4fikZAscsMCHXMgt8=; b=
        SLyp+/zQJt1Zf3IKVpp+pO2Jgc1vr+6oFbDX6CPCLjrnbRAQk88/UtQamdsrBsUc
        DTQWwrcK/VSTynxgZq7Xuwc66PFi1R0qapHMAoBguQaOMcqp/1P2oSTzXcfUgCmh
        fz/7Y8ZWNAAaiuy1q6vrZTr+P2ZHABSztxkRVef1IF4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AqgB9iYW6DO9; Sat, 30 Nov 2019 13:23:59 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 5D76A41258;
        Sat, 30 Nov 2019 13:23:58 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Sat, 30
 Nov 2019 13:23:58 +0300
Date:   Sat, 30 Nov 2019 13:23:58 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Martin Wilck <Martin.Wilck@suse.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: qla2xxx: don't shut down firmware before
 closing sessions
Message-ID: <20191130102358.axyzfb5vxorbvuti@SPB-NB-133.local>
References: <20191129202627.19624-1-martin.wilck@suse.com>
 <20191129202627.19624-2-martin.wilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191129202627.19624-2-martin.wilck@suse.com>
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 29, 2019 at 08:26:36PM +0000, Martin Wilck wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Since 45235022da99, the firmware is shut down early in the controller
> shutdown process. This causes commands sent to the firmware (such as LOGO)
> to hang forever. Eventually one or more timeouts will be triggered.
> Move the stopping of the firmware until after sessions have terminated.
> 
> Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 43d0aa0..0cc127d 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3710,6 +3710,16 @@ qla2x00_remove_one(struct pci_dev *pdev)
>  	}
>  	qla2x00_wait_for_hba_ready(base_vha);
>  
> +	qla2x00_wait_for_sess_deletion(base_vha);
> +
> +	/*
> +	 * if UNLOAD flag is already set, then continue unload,
> +	 * where it was set first.
> +	 */
> +	if (test_bit(UNLOADING, &base_vha->dpc_flags))
> +		return;
> +
> +	set_bit(UNLOADING, &base_vha->dpc_flags);

Hi Martin,

Moving qla2x00_wait_for_sess_deletion up ensures hw->wq is flushed
before shutdown is done.

But I think we need to set UNLOADING bit earlier to break-up async
discovery chain. The comment just above qla2x00_wait_for_sess_deletion
definition mentions that.

Thanks,
Roman
