Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E06FCC433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:48:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A247F21D42
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:48:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="lFHs5NRf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgIHGr4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 02:47:56 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16584 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727898AbgIHGrz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 02:47:55 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0886euY1002070;
        Mon, 7 Sep 2020 23:47:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=eOJboNLK/sEyISHuh+3TUISkvbBw5hy/wrZiXLFigo0=;
 b=lFHs5NRf3JTaFp3FH5bzDcdw2Qlm0AYgFFQuNVLOoXY3DIHIIS3So5ktjK/+4VBIJgwl
 1b3uufLvRK5lFdutoh2e10M1E5iB3tuf76VsfVTmKB7l6VxyRQ6qKIvX21SUZOWFd2Ea
 /y8ywCH6aEgaxipEhVpgIrMH3/Z0QuSDGw/Y1N/QP8zHAN6x+794K2zS/HLx4zHNqrUr
 zHnWMG4EEakkYj5x+WiUkSGVMAjiBB+OKGo4xs9bLu12086IkIeeMv0DzGZIzFSTHtqO
 uIMH4mUNTvi4Tb5q4vvHTZw0WX7vsh4hLf6fRyC3qhZI/xXM0z3bK8jrPR0R7vhxQvsz ww== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 33ccvr19hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 23:47:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 23:47:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Sep 2020 23:47:49 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id AEA313F703F;
        Mon,  7 Sep 2020 23:47:48 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 0886lm8r024498;
        Mon, 7 Sep 2020 23:47:48 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Mon, 7 Sep 2020 23:47:48 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Daniel Wagner <dwagner@suse.de>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Nilesh Javali" <njavali@marvell.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 4/4] qla2xxx: Handle incorrect entry_type entries
In-Reply-To: <20200831161854.70879-5-dwagner@suse.de>
Message-ID: <alpine.LRH.2.21.9999.2009072346360.28578@irv1user01.caveonetworks.com>
References: <20200831161854.70879-1-dwagner@suse.de>
 <20200831161854.70879-5-dwagner@suse.de>
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
> It was observed on an ISP8324 16Gb HBA with fw=8.08.203 (d0d5) that
> pkt->entry_type was MBX_IOCB_TYPE/0x39 with an sp->type SRB_SCSI_CMD
> which is invalid and should not be possible.
> 
> A careful code review of the crash dump didn't reveal any short
> comings. Reading the entry_type from the crash dump shows the expected
> value of STATUS_TYPE/0x03 but the call trace shows that
> qla24xx_mbx_iocb_entry() is used.
> 
> One possible explanation is when pkt->entry_type is read it doesn't
> contain the correct information. That means the driver observes an data
> race by the firmware.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>  drivers/scsi/qla2xxx/qla_isr.c | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index b787643f5031..22aa4c0b901d 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3392,6 +3392,33 @@ void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *vha,
>  	sp->done(sp, comp_status);
>  }
>  
> +static void qla24xx_process_mbx_iocb_response(struct scsi_qla_host *vha,
> +	struct rsp_que *rsp, struct sts_entry_24xx *pkt)
> +{
> +	srb_t *sp;
> +
> +	sp = qla2x00_get_sp_from_handle(vha, rsp->req, pkt);
> +	if (!sp)
> +		return;
> +
> +	if (sp->type == SRB_SCSI_CMD ||
> +	    sp->type == SRB_NVME_CMD ||
> +	    sp->type == SRB_TM_CMD) {
> +		/* Some firmware version don't update the entry_type
> +		 * correctly.  It was observed entry_type contained
> +		 * MBCX_IOCB_TYPE instead of the expected STATUS_TYPE
> +		 * for sp->type SRB_SCSI_CMD, SRB_NVME_CMD or
> +		 * SRB_TM_CMD.
> +		 */

Could you drop the above comment about firmware, as it is speculation at
this point?


> +		ql_log(ql_log_warn, vha, 0x509d,
> +		       "Firmware didn't update entry_type correctly\n");
> +		qla2x00_status_entry(vha, rsp, pkt);
> +		return;

It'd be best to take a chip reset path, rather than assuming the
packet is good and having the appropriate handler called (hacky).
An approach similar to the one done at the beginning of
qla2x00_get_sp_from_handle() is what I had in mind.

> +	}
> +
> +	qla24xx_mbx_iocb_entry(vha, rsp->req, (struct mbx_24xx_entry *)pkt);
> +}
> +
>  /**
>   * qla24xx_process_response_queue() - Process response queue entries.
>   * @vha: SCSI driver HA context
> @@ -3499,8 +3526,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
>  			    (struct abort_entry_24xx *)pkt);
>  			break;
>  		case MBX_IOCB_TYPE:
> -			qla24xx_mbx_iocb_entry(vha, rsp->req,
> -			    (struct mbx_24xx_entry *)pkt);
> +			qla24xx_process_mbx_iocb_response(vha, rsp, pkt);

I'd have preferred a common approach across the different IOCB types
as an attempt to harden the code, but that will be a little more
involved work. This looks ok.

Regards,
-Arun
