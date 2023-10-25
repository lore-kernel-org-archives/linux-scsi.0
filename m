Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC105C07545
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 15:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbjJYPLb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 11:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbjJYPLa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 11:11:30 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A59712F
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2023 08:11:27 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39PF9txW028711;
        Wed, 25 Oct 2023 15:11:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=DmuAF6DfcpG9q/YgiL1s+GcV6w0SSnWtywV+PfE/DxI=;
 b=tGZ6Z+qKD86U25cTAm2Cli8m+QFtC71IpE7XvR/AgL4Cy/qNj4WCRwxXlvgPtdA5aZYP
 koC+/ci32TwJwYlVozN2PXLsAjHMCxhLz4e2tmwWsDpbTY/zde7FmifHP6tmvwM36mND
 C44pFFWJdQbBo6ZiSpuJQsAGrG4GeirQNyRfH+AXUZXABig0DDqK9hc3y+6x4rjgh2NU
 Tsn0erDH1WvYdYcJnWShG9/4XDbpl9r+KYfKUCBN9tCRu3nhzlt7CqNoOm/wt9SXVLL4
 Pos/b28ginMQ+j3fYgLUhCkFubMKPXxvukMMymSUwM7hJ6WV+OkgdUlUS1RqDFo778vQ Lg== 
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ty5dwr1cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 15:11:15 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39PD3PCC010305;
        Wed, 25 Oct 2023 15:11:14 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tvsbyqkv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 15:11:14 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39PFBCPU13042232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 15:11:12 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 347652005A;
        Wed, 25 Oct 2023 15:11:12 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BE1C2004F;
        Wed, 25 Oct 2023 15:11:12 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.171.40.191])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 25 Oct 2023 15:11:12 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.96.1)
        (envelope-from <bblock@linux.ibm.com>)
        id 1qvfXL-00AVVX-1r;
        Wed, 25 Oct 2023 17:11:11 +0200
Date:   Wed, 25 Oct 2023 17:11:11 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 03/10] scsi: Use scsi_target as argument for
 eh_target_reset_handler()
Message-ID: <20231025151111.GF1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
References: <20231023092837.33786-1-hare@suse.de>
 <20231023092837.33786-4-hare@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20231023092837.33786-4-hare@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9a0E1lClRM92fErPauv6vuoWCsLPdTwx
X-Proofpoint-ORIG-GUID: 9a0E1lClRM92fErPauv6vuoWCsLPdTwx
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-25_04,2023-10-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310250131
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 23, 2023 at 11:28:30AM +0200, Hannes Reinecke wrote:
> diff --git a/Documentation/scsi/scsi_eh.rst b/Documentation/scsi/scsi_eh.rst
> index 553aff3062d5..cfaf841317ed 100644
> --- a/Documentation/scsi/scsi_eh.rst
> +++ b/Documentation/scsi/scsi_eh.rst
> @@ -411,6 +412,14 @@ scmd->allowed.
>  	    resetting clears all scmds on the sdev, there is no need
>  	    to choose error-completed scmds.
>  
> +	2. If !list_empty(&eh_work_q), invoke scsi_eh_target_reset().
> +
> +	``scsi_eh_target_reset``
> +
> +	    hostt->eh_target_reset_handler() is invoked for each target.

It's only invoked for targets that have commands on the work-q, not each. We
could have 16 rports open, but only one of them has a command that timed out,
and is in EH.

At least that is what I thought it does.

> +	    If target reset succeeds, all failed scmds on all ready or
> +	    offline sdevs on the target are EH-finished.
> +
>  	3. If !list_empty(&eh_work_q), invoke scsi_eh_bus_reset()
>  
>  	``scsi_eh_bus_reset``
> diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
> index 43083efc554b..8a075da5641b 100644
> --- a/Documentation/scsi/scsi_mid_low_api.rst
> +++ b/Documentation/scsi/scsi_mid_low_api.rst
> @@ -758,6 +758,24 @@ Details::
>  	int eh_bus_reset_handler(struct Scsi_Host * host, unsigned int channel)
>  
>  
> +    /**
> +    *      eh_target_reset_handler - issue SCSI target reset
> +    *      @starget: identifies SCSI target to be reset
> +    *
> +    *      Returns SUCCESS if command aborted else FAILED

Same as in Patch 1. Or in a later patch, if you prefer.

> +    *
> +    *      Locks: None held
> +    *
> +    *      Calling context: kernel thread
> +    *
> +    *      Notes: Invoked from scsi_eh thread. No other commands will be
> +    *      queued on current host during eh.
> +    *
> +    *      Optionally defined in: LLD
> +    **/
> +	int eh_target_reset_handler(struct scsi_target * starget)
> +
> +
>      /**
>      *      eh_device_reset_handler - issue SCSI device reset
>      *      @scp: identifies SCSI device to be reset
> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
> index 300f8e955a53..a9d274cabb37 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -2012,7 +2020,7 @@ static const struct scsi_host_template mptsas_driver_template = {
>  	.change_queue_depth 		= mptscsih_change_queue_depth,
>  	.eh_timed_out			= mptsas_eh_timed_out,
>  	.eh_abort_handler		= mptscsih_abort,
> -	.eh_device_reset_handler	= mptscsih_dev_reset,
> +	.eh_target_reset_handler	= mptsas_eh_target_reset,

Huh, it that correct? Replace the device reset handler with the target
handler? That seems odd.

>  	.eh_host_reset_handler		= mptscsih_host_reset,
>  	.bios_param			= mptscsih_bios_param,
>  	.can_queue			= MPT_SAS_CAN_QUEUE,
> diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
> index 6c5920db1e9d..d379dea7074c 100644
> --- a/drivers/message/fusion/mptspi.c
> +++ b/drivers/message/fusion/mptspi.c
> @@ -834,7 +840,7 @@ static const struct scsi_host_template mptspi_driver_template = {
>  	.slave_destroy			= mptspi_slave_destroy,
>  	.change_queue_depth 		= mptscsih_change_queue_depth,
>  	.eh_abort_handler		= mptscsih_abort,
> -	.eh_device_reset_handler	= mptscsih_dev_reset,
> +	.eh_target_reset_handler	= mptspi_eh_target_reset,

...

>  	.eh_bus_reset_handler		= mptscsih_bus_reset,
>  	.eh_host_reset_handler		= mptscsih_host_reset,
>  	.bios_param			= mptscsih_bios_param,
> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index 76c136d39bf1..5c9a7c9f9a98 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -340,9 +340,12 @@ static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
>  	return zfcp_scsi_task_mgmt_function(sdev, FCP_TMF_LUN_RESET);
>  }
>  
> -static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
> +/*
> + * Note: We need to select a LUN as the storage array doesn't
> + * necessarily supports LUN 0 and might refuse the target reset.

That might be true, I don't really know, but it's not the reason why we added
this "search a sdev" logic to the function. The firmware for FCP channels
needs a valid "LUN handle" for each FCP request we send, otherwise it's
rejected. So we have to find a valid handle. This is an artifact from
HBA virtualisation before NPIV on Z.

There is more details in
674595d8519f ("scsi: zfcp: decouple our scsi_eh callbacks from scsi_cmnd")

From my perspective you can just remove the comment, or change it to match
the part about `zfcp_scsi_eh_target_reset_handler()` in what Steffen wrote in
the commit.

> + */
> +static int zfcp_scsi_eh_target_reset_handler(struct scsi_target *starget)
>  {
> -	struct scsi_target *starget = scsi_target(scpnt->device);
>  	struct fc_rport *rport = starget_to_rport(starget);
>  	struct Scsi_Host *shost = rport_to_shost(rport);
>  	struct scsi_device *sdev = NULL, *tmp_sdev;
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 98aa17a6448a..244b7a6f8616 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -6045,15 +6045,15 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
>   *  0x2002 - Success
>   **/
>  static int
> -lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
> +lpfc_target_reset_handler(struct scsi_target *starget)
>  {
> -	struct Scsi_Host  *shost = cmnd->device->host;
> -	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
> +	struct fc_rport *rport = starget_to_rport(starget);
> +	struct Scsi_Host  *shost = rport_to_shost(rport);
>  	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
>  	struct lpfc_rport_data *rdata;
>  	struct lpfc_nodelist *pnode;
> -	unsigned tgt_id = cmnd->device->id;
> -	uint64_t lun_id = cmnd->device->lun;
> +	unsigned tgt_id = starget->id;
> +	uint64_t lun_id = 0;

Well, hopefully storage targets for LPFC can deal with LUN 0 :)

>  	struct lpfc_scsi_event_header scsi_event;
>  	int status;
>  	u32 logit = LOG_FCP;
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index c60014e07b44..bee950f11576 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -4804,21 +4804,25 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
>  
>  /*
>   * megasas_reset_target_fusion : target reset function for fusion adapters
> - * scmd: SCSI command pointer
> + * @shost: SCSI host pointer
> + * @starget: SCSI target pointer
>   *
>   * Returns SUCCESS if all commands associated with target aborted else FAILED
>   */
>  
> -int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
> +int megasas_reset_target_fusion(struct Scsi_Host *shost,
> +				struct scsi_target *starget)
>  {
>  
>  	struct megasas_instance *instance;
> +	struct scsi_device *sdev;
>  	int ret = FAILED;
> -	u16 devhandle;
> -	struct MR_PRIV_DEVICE *mr_device_priv_data;
> -	mr_device_priv_data = scmd->device->hostdata;
> +	u16 devhandle = USHRT_MAX;
> +	struct MR_PRIV_DEVICE *mr_device_priv_data = NULL;
>  
> -	instance = (struct megasas_instance *)scmd->device->host->hostdata;
> +	instance = (struct megasas_instance *)shost->hostdata;

`shost_priv()`? And you can move that to the top as well I think.

> +	starget_printk(KERN_INFO, starget,
> +		    "target reset called\n");
>  
>  	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) {
>  		dev_err(&instance->pdev->dev, "Controller is not OPERATIONAL,"
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 381e07f2b718..63d95aa8a5f3 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -4090,54 +4090,41 @@ static int mpi3mr_eh_bus_reset(struct Scsi_Host *shost, unsigned int channel)
>   * Return: SUCCESS of successful termination of the scmd else
>   *         FAILED
>   */
> -static int mpi3mr_eh_target_reset(struct scsi_cmnd *scmd)
> +static int mpi3mr_eh_target_reset(struct scsi_target *starget)
>  {
> -	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
> +	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
> +	struct mpi3mr_ioc *mrioc = shost_priv(shost);
>  	struct mpi3mr_stgt_priv_data *stgt_priv_data;
> -	struct mpi3mr_sdev_priv_data *sdev_priv_data;
>  	u16 dev_handle;
>  	u8 resp_code = 0;
>  	int retval = FAILED, ret = 0;
>  
> -	sdev_printk(KERN_INFO, scmd->device,
> -	    "Attempting Target Reset! scmd(%p)\n", scmd);
> -	scsi_print_command(scmd);
> -
> -	sdev_priv_data = scmd->device->hostdata;
> -	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
> -		sdev_printk(KERN_INFO, scmd->device,
> -		    "SCSI device is not available\n");
> -		retval = SUCCESS;
> -		goto out;
> -	}
> +	starget_printk(KERN_INFO, starget,
> +	    "Attempting Target Reset!\n");

Nitpick: you can remove the line-break.

>  
> -	stgt_priv_data = sdev_priv_data->tgt_priv_data;
> +	stgt_priv_data = starget->hostdata;
>  	dev_handle = stgt_priv_data->dev_handle;
>  	if (stgt_priv_data->dev_removed) {
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index f82551783feb..fc0510cd367c 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1662,7 +1664,8 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
>  					     " target: %d\n",
>  					     current->comm, id));
>  		list_for_each_entry_safe(scmd, next, &tmp_list, eh_entry) {
> -			if (scmd_id(scmd) != id)
> +			if (scmd_channel(scmd) != channel ||
> +			    scmd_id(scmd) != id)

Hmm, interesting. So this was broken before as well?

Tbh., this seems like a fix that could go to stable? Should we have a separate
patch for it?

>  				continue;
>  
>  			if (rtn == SUCCESS)

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
