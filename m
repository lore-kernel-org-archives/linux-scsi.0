Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB33C54FCC
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16272206E9
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:40:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M7MqKt4b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgDUVkh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 17:40:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46920 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgDUVkh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2020 17:40:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03LLX3Yc087341;
        Tue, 21 Apr 2020 21:40:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=57IxdGGPmram9FZjAoPqqKa/rmUtB46ZiJt/mgUY4SY=;
 b=M7MqKt4bSP8N/I36XAcyNIfxTlo5+NDoxYopF44cXCtusoIhTHekMoSQ97cEvyxU50ik
 w24muDe7RFh+rocjjsP6bqCFY/SeQgCTIUtWMcnLBuTzpS0saGqr78IK8XBtId3SjSsl
 hUhhVTr2KutyokQ87O1WDCwCb7PPkZJ0rK2zx/QsUzKa+ynt5hvoDSWDxHhN0+3DBX+X
 ZIxMkT1EsOMEAO1KBJpWnYYPJjgl83V6oRAJ8TmRCapyK9PxwGSFQQm4OUT8pZksJjkr
 226DNnDrG3+2F/3iVL5fT8iRsrDfCcjUieqHoh0zgu3ijJ8sPScsUu9ojo+hCrHm21Pg EQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30fsgkyf9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 21:40:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03LLcakv195448;
        Tue, 21 Apr 2020 21:40:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30gbbexs5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 21:40:34 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03LLeXhI007712;
        Tue, 21 Apr 2020 21:40:33 GMT
Received: from [10.154.114.8] (/10.154.114.8)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 14:40:33 -0700
Subject: Re: [PATCH v2] lpfc: remove duplicate unloading checks
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
References: <20200421203354.49420-1-jsmart2021@gmail.com>
From:   himanshu.madhani@oracle.com
Organization: Oracle Corporation
Message-ID: <1dd0d717-d74a-c7e2-24fe-4a2f10ab002a@oracle.com>
Date:   Tue, 21 Apr 2020 16:40:31 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200421203354.49420-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004210156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004210156
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 4/21/20 3:33 PM, James Smart wrote:
> During code reviews several instances of duplicate module unloading checks
> were found.
> 
> Remove the duplicate checks.
> 
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v2: reworked lpfc_els.c mod to keep check prior to locks
> ---
>   drivers/scsi/lpfc/lpfc_els.c   | 10 ++--------
>   drivers/scsi/lpfc/lpfc_nvme.c  |  5 -----
>   drivers/scsi/lpfc/lpfc_nvmet.c | 11 -----------
>   3 files changed, 2 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 80d1e661b0d4..565a21401660 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -7936,19 +7936,13 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
>   	if (unlikely(!pring))
>   		return;
>   
> -	if ((phba->pport->load_flag & FC_UNLOADING))
> +	if (phba->pport->load_flag & FC_UNLOADING)
>   		return;
> +
>   	spin_lock_irq(&phba->hbalock);
>   	if (phba->sli_rev == LPFC_SLI_REV4)
>   		spin_lock(&pring->ring_lock);
>   
> -	if ((phba->pport->load_flag & FC_UNLOADING)) {
> -		if (phba->sli_rev == LPFC_SLI_REV4)
> -			spin_unlock(&pring->ring_lock);
> -		spin_unlock_irq(&phba->hbalock);
> -		return;
> -	}
> -
>   	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
>   		cmd = &piocb->iocb;
>   
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
> index a45936e08031..12d2b2775773 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.c
> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
> @@ -1491,11 +1491,6 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
>   
>   	phba = vport->phba;
>   
> -	if (vport->load_flag & FC_UNLOADING) {
> -		ret = -ENODEV;
> -		goto out_fail;
> -	}
> -
>   	if (unlikely(vport->load_flag & FC_UNLOADING)) {
>   		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR,
>   				 "6124 Fail IO, Driver unload\n");
> diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
> index 565419bf8d74..5f5aecea5b55 100644
> --- a/drivers/scsi/lpfc/lpfc_nvmet.c
> +++ b/drivers/scsi/lpfc/lpfc_nvmet.c
> @@ -841,9 +841,6 @@ lpfc_nvmet_xmt_ls_rsp(struct nvmet_fc_target_port *tgtport,
>   	struct ulp_bde64 bpl;
>   	int rc;
>   
> -	if (phba->pport->load_flag & FC_UNLOADING)
> -		return -ENODEV;
> -
>   	if (phba->pport->load_flag & FC_UNLOADING)
>   		return -ENODEV;
>   
> @@ -938,11 +935,6 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
>   		goto aerr;
>   	}
>   
> -	if (phba->pport->load_flag & FC_UNLOADING) {
> -		rc = -ENODEV;
> -		goto aerr;
> -	}
> -
>   #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
>   	if (ctxp->ts_cmd_nvme) {
>   		if (rsp->op == NVMET_FCOP_RSP)
> @@ -1062,9 +1054,6 @@ lpfc_nvmet_xmt_fcp_abort(struct nvmet_fc_target_port *tgtport,
>   	struct lpfc_queue *wq;
>   	unsigned long flags;
>   
> -	if (phba->pport->load_flag & FC_UNLOADING)
> -		return;
> -
>   	if (phba->pport->load_flag & FC_UNLOADING)
>   		return;
>   
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani
Oracle Linux Engineering
