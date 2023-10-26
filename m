Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BC5C25B48
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 12:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbjJZMY7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 08:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjJZMY6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 08:24:58 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C876C192
        for <linux-scsi@vger.kernel.org>; Thu, 26 Oct 2023 05:24:54 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39QCATKm017494;
        Thu, 26 Oct 2023 12:24:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=HWZ15pM8cbQu+Xzq+HRFZvHFApsy1NR+bFtT4q/M8yY=;
 b=p1f89aKPOnUSNSl/QbBg6YbsHmS6B4qgNThg50KKpOTAW7zzjbxPdO8yVDuY27Rt9+Xc
 90FbxZXd56dUmAgtFK4rDWwTt4MNGCuKRtQ1d2rlRKLEyc3tq0tWidS3RsptfB0/+4r/
 XnGvxz54t7ahrdRNJ3rUg0Soo43R6a3bg5ETM6EcImd9ActvWSawSWNdXQlybipXuFWq
 Q2pBsln5RRjsuGh5O844JRYCkyDJIYMne9RrlErF5i7Pq9ahot76GLvecpgQwMnJdmd0
 RDMiNo9x8NWBwGWDpIOygSOPMn4P8ePDFYUAKU06CWQtTKI9tfgOXVNh1Nxpn480r1Fm XQ== 
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tyqvqgf93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 12:24:44 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39QAFAEL024356;
        Thu, 26 Oct 2023 12:24:40 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tvu6kdn6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 12:24:40 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39QCOcIh10289794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Oct 2023 12:24:38 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B28752004B;
        Thu, 26 Oct 2023 12:24:38 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99BBA20049;
        Thu, 26 Oct 2023 12:24:38 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.152.212.253])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 26 Oct 2023 12:24:38 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.96.1)
        (envelope-from <bblock@linux.ibm.com>)
        id 1qvzPi-00Al8G-1D;
        Thu, 26 Oct 2023 14:24:38 +0200
Date:   Thu, 26 Oct 2023 14:24:38 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 04/10] scsi: Use scsi_device as argument to
 eh_device_reset_handler()
Message-ID: <20231026122438.GI1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
References: <20231023092837.33786-1-hare@suse.de>
 <20231023092837.33786-5-hare@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20231023092837.33786-5-hare@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fh2eylczC5QvOzXyLuYcGr6DptHY31sI
X-Proofpoint-GUID: fh2eylczC5QvOzXyLuYcGr6DptHY31sI
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-26_10,2023-10-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310260106
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 23, 2023 at 11:28:31AM +0200, Hannes Reinecke wrote:
> diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
> index 5c062fb35cf6..dc562da7b2b9 100644
> --- a/drivers/scsi/a100u2w.c
> +++ b/drivers/scsi/a100u2w.c
> @@ -944,16 +944,15 @@ static int inia100_bus_reset(struct Scsi_Host * shost, unsigned int channel)
>  /*****************************************************************************
>   Function name  : inia100_device_reset
>   Description    : Reset the device
> - Input          : host  -       Pointer to host adapter structure
> + Input          : dev  -       Pointer to scsi device structure
>   Output         : None.
>   Return         : pSRB  -       Pointer to SCSI request block.
>  *****************************************************************************/
> -static int inia100_device_reset(struct scsi_cmnd * cmd)
> +static int inia100_device_reset(struct scsi_device * dev)
>  {				/* I need Host Control Block Information */
>  	struct orc_host *host;
> -	host = (struct orc_host *) cmd->device->host->hostdata;
> -	return orc_device_reset(host, cmd->device);
> -
> +	host = (struct orc_host *) dev->host->hostdata;

Nitpick: you could use `shost_priv()` here.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 63d95aa8a5f3..289269140e4e 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -4141,30 +4141,28 @@ static int mpi3mr_eh_target_reset(struct scsi_target *starget)
> -static int mpi3mr_eh_dev_reset(struct scsi_cmnd *scmd)
> +static int mpi3mr_eh_dev_reset(struct scsi_device *sdev)
>  {
> -	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
> +	struct mpi3mr_ioc *mrioc = shost_priv(sdev->host);
>  	struct mpi3mr_stgt_priv_data *stgt_priv_data;
>  	struct mpi3mr_sdev_priv_data *sdev_priv_data;
>  	u16 dev_handle;
>  	u8 resp_code = 0;
>  	int retval = FAILED, ret = 0;
>  
> -	sdev_printk(KERN_INFO, scmd->device,
> -	    "Attempting Device(lun) Reset! scmd(%p)\n", scmd);
> -	scsi_print_command(scmd);
> +	sdev_printk(KERN_INFO, sdev,

Nitpick: you can remove the line-break after `sdev,`

> +	    "Attempting Device(lun) Reset!\n");
>  
> -	sdev_priv_data = scmd->device->hostdata;
> +	sdev_priv_data = sdev->hostdata;
>  	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
> -		sdev_printk(KERN_INFO, scmd->device,
> +		sdev_printk(KERN_INFO, sdev,
>  		    "SCSI device is not available\n");
>  		retval = SUCCESS;
>  		goto out;
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 1f3ce2aafed6..e1da6a811dac 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -3376,20 +3376,17 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
>  	u8	tr_timeout = 30;
>  	int r;
>  
> -	struct scsi_target *starget = scmd->device->sdev_target;
> +	struct scsi_target *starget = sdev->sdev_target;
>  	struct MPT3SAS_TARGET *target_priv_data = starget->hostdata;
>  
> -	sdev_printk(KERN_INFO, scmd->device,
> -	    "attempting device reset! scmd(0x%p)\n", scmd);
> -	_scsih_tm_display_info(ioc, scmd);
> +	sdev_printk(KERN_INFO, sdev,

...

> +	    "attempting device reset!\n");
>  
> -	sas_device_priv_data = scmd->device->hostdata;
> +	sas_device_priv_data = sdev->hostdata;
> diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
> index 01c0d571de90..0d03b361ed72 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.h
> +++ b/drivers/scsi/pcmcia/nsp_cs.h
> @@ -297,8 +297,6 @@ static        int        nsp_show_info  (struct seq_file *m,
>  static int nsp_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *SCpnt);
>  
>  /* Error handler */
> -/*static int nsp_eh_abort       (struct scsi_cmnd *SCpnt);*/
> -/*static int nsp_eh_device_reset(struct scsi_cmnd *SCpnt);*/

Hmm, this is a bit off-topic; is it? You don't change anything else in this
header. Hmm, maybe because it's the old device-reset handler that still has
`scsi_cmnd` as arg.

>  static int nsp_eh_bus_reset    (struct Scsi_Host *host, unsigned int channel);
>  static int nsp_eh_host_reset   (struct Scsi_Host *host);
>  static int nsp_bus_reset       (nsp_hw_data *data);
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index 626bc28d20e2..9bd330610d58 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -797,18 +797,18 @@ qla1280_wait_for_pending_commands(struct scsi_qla_host *ha, int bus, int target)
>   *    wait for the results (or time out).
>   *
>   * Input:
> + *      sdev = Linux SCSI device
>   *      cmd = Linux SCSI command packet of the command that cause the
>   *            bus reset.
> - *      action = error action to take (see action_t)
>   *
>   * Returns:
>   *      SUCCESS or FAILED
>   *
>   **************************************************************************/
>  static int
> -qla1280_error_action(struct scsi_cmnd *cmd, enum action action)
> +qla1280_error_action(struct scsi_device *sdev, struct scsi_cmnd *cmd)
>  {
> -	struct scsi_qla_host *ha;
> +	struct scsi_qla_host *ha = shost_priv(sdev->host);
>  	int bus, target, lun;
>  	struct srb *sp;
>  	int i, found;
> @@ -816,14 +816,14 @@ qla1280_error_action(struct scsi_cmnd *cmd, enum action action)
>  	int wait_for_bus=-1;
>  	int wait_for_target = -1;
>  	DECLARE_COMPLETION_ONSTACK(wait);
> +	enum action action = cmd ? ABORT_COMMAND : DEVICE_RESET;
>  
>  	ENTER("qla1280_error_action");
>  
> -	ha = (struct scsi_qla_host *)(CMD_HOST(cmd)->hostdata);
>  	sp = scsi_cmd_priv(cmd);

That is wrong now that `cmd` can be `NULL`. In that case this will return
something near address 0 and the rest of the function will fall apart.

	static inline void *scsi_cmd_priv(struct scsi_cmnd *cmd)
	{
		return cmd + 1;
	}

> -	bus = SCSI_BUS_32(cmd);
> -	target = SCSI_TCN_32(cmd);
> -	lun = SCSI_LUN_32(cmd);
> +	bus = sdev->channel;
> +	target = sdev->id;
> +	lun = sdev->lun;
>  
>  	dprintk(4, "error_action %i, istatus 0x%04x\n", action,
>  		RD_REG_WORD(&ha->iobase->istatus));
> diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
> index 36298dbadb14..e1f6004dcd6b 100644
> --- a/drivers/scsi/snic/snic_scsi.c
> +++ b/drivers/scsi/snic/snic_scsi.c
> @@ -2099,6 +2098,7 @@ snic_device_reset(struct scsi_cmnd *sc)
>  	int start_time = jiffies;
>  	int ret = FAILED;
>  	int dr_supp = 0;
> +	struct scsi_cmnd tmf_sc, *sc = &tmf_sc;

No quite sure why you need that `tmf_sc` and it's address in `sc`? `sc` is
first used here:

    sc = blk_mq_rq_to_pdu(req);

which overwrites the value, and `tmf_sc` is not used at all. Or am I missing
something?

>  
>  	SNIC_SCSI_DBG(shost, "dev_reset\n");
>  	dr_supp = snic_dev_reset_supported(sdev);

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
