Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E43C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:43:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A45402177B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:43:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="UzBVkh4t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbgIHGnR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 02:43:17 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11968 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728115AbgIHGnR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 02:43:17 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0886esdQ001979;
        Mon, 7 Sep 2020 23:43:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=xs56d2C/NYDIV25+23YdcJiJQUhJ3VMb5DccgFWDyug=;
 b=UzBVkh4tWB2VBqA2ak5HvG82DxSj+1H3hVSDEiFMUZyUfwNYk4VtMgVdfjqUbT6FE3H8
 uFUkzdZl4xOfjwvG+pTVmW11Ksp21gqtyo3nur8P3+0QrpXTwQ61/Z0yi8AtwrWYl1DL
 qAVlXK1BfG9i5J86DHRsVXDxWnd1ryOQfivC0W7os5aYojQzn5RH4u1yl6m7lYuUOM33
 lltRRu3aRPyS7Y8DduPMEXsOa7Q+2x2+EAVVCDkbXPk7Gn4WLa8PTF2j3n2X+xQ78ya7
 sQ9QFf7I4NaPS14osR2nzQrnBQyJrWzpGTZmGc/iEq2H616sOx3i21lBZMSzohXKa0m0 nw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 33ccvr1980-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 23:43:11 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 23:43:10 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 23:43:09 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Sep 2020 23:43:09 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id D95773F703F;
        Mon,  7 Sep 2020 23:43:08 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 0886h8Wb020003;
        Mon, 7 Sep 2020 23:43:08 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Mon, 7 Sep 2020 23:43:08 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Daniel Wagner <dwagner@suse.de>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Nilesh Javali" <njavali@marvell.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 2/4] qla2xxx: Simplify return value logic in
 qla2x00_get_sp_from_handle()
In-Reply-To: <20200831161854.70879-3-dwagner@suse.de>
Message-ID: <alpine.LRH.2.21.9999.2009072342380.28578@irv1user01.caveonetworks.com>
References: <20200831161854.70879-1-dwagner@suse.de>
 <20200831161854.70879-3-dwagner@suse.de>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_02:2020-09-08,2020-09-08 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 31 Aug 2020, 9:18am, Daniel Wagner wrote:

> 
> Refactor qla2x00_get_sp_from_handle() to avoid the unecessary
> goto if early returns are used. With this we can also avoid
> preinitilzing the sp pointer.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>  drivers/scsi/qla2xxx/qla_isr.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index 27bcd346af7c..5d278155e4e7 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1716,7 +1716,7 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
>  {
>  	struct qla_hw_data *ha = vha->hw;
>  	sts_entry_t *pkt = iocb;
> -	srb_t *sp = NULL;
> +	srb_t *sp;
>  	uint16_t index;
>  
>  	index = LSW(pkt->handle);
> @@ -1728,13 +1728,13 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
>  			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
>  		else
>  			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
> -		goto done;
> +		return NULL;
>  	}
>  	sp = req->outstanding_cmds[index];
>  	if (!sp) {
>  		ql_log(ql_log_warn, vha, 0x5032,
>  		    "Invalid completion handle (%x) -- timed-out.\n", index);
> -		return sp;
> +		return NULL;
>  	}
>  	if (sp->handle != index) {
>  		ql_log(ql_log_warn, vha, 0x5033,
> @@ -1743,8 +1743,6 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
>  	}
>  
>  	req->outstanding_cmds[index] = NULL;
> -
> -done:
>  	return sp;
>  }
>  

Looks good.

Regards,
-Arun
