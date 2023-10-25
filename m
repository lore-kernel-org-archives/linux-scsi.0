Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7559DC07545
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 11:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbjJYLqa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 07:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233862AbjJYLq3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 07:46:29 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EEBA129
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2023 04:46:27 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39PBgqfo008716;
        Wed, 25 Oct 2023 11:45:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=2yjDB4HyQPgP6AnDUNr7IlMLMN19vpWT8K66gjdxHuQ=;
 b=r1WiLSAiJGMuj14r110o1aFCwM6/c8i6p7z1xeHbIiAR0ih+q+JQJ3a/DyDweXJjcu2O
 gkAUVSbxVamO+25awhqq+KhWWIU3VDoTRk5z0JZA9BeyueaUJgoaFIBLR3DyqEylubcJ
 jU/DXdAH4ELKwgxvtc4iPZnsPcpxzNaH+vRqJ79An3Th+sOXLfYn3NC25OsfItiSt5er
 /CPdH7Eo3pQpZAaIzpvYBtA52RRXwZeyZw+BZ7lWfTOyKp0Rf5Oxqsvc9J94RUET6kE7
 2xpGsYm6ocY9dBQq3mRqUy7CbWDtiuH0oxaMbAN1dBsmDI8GGOBTwOtFQXbIaVfffZW/ +Q== 
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ty1yw0prb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 11:45:25 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39PBaf5o004991;
        Wed, 25 Oct 2023 11:40:25 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tvtfkp178-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 11:40:24 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39PBeMhY22807130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 11:40:23 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D31D420043;
        Wed, 25 Oct 2023 11:40:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE2B420040;
        Wed, 25 Oct 2023 11:40:22 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.171.40.191])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 25 Oct 2023 11:40:22 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.96.1)
        (envelope-from <bblock@linux.ibm.com>)
        id 1qvcFK-00APId-0Q;
        Wed, 25 Oct 2023 13:40:22 +0200
Date:   Wed, 25 Oct 2023 13:40:22 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 01/10] scsi: Use Scsi_Host as argument for
 eh_host_reset_handler
Message-ID: <20231025114022.GD1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
References: <20231023092837.33786-1-hare@suse.de>
 <20231023092837.33786-2-hare@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20231023092837.33786-2-hare@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TFEJx0I8UEKBbTQ_MI6vrJssT5vEsRzx
X-Proofpoint-GUID: TFEJx0I8UEKBbTQ_MI6vrJssT5vEsRzx
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-25_01,2023-10-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310250101
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Hannes,

On Mon, Oct 23, 2023 at 11:28:28AM +0200, Hannes Reinecke wrote:
> diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
> index 022198c51350..96983bb1cc45 100644
> --- a/Documentation/scsi/scsi_mid_low_api.rst
> +++ b/Documentation/scsi/scsi_mid_low_api.rst
> @@ -777,9 +777,9 @@ Details::
>  
>      /**
>      *      eh_host_reset_handler - reset host (host bus adapter)
> -    *      @scp: SCSI host that contains this device should be reset
> +    *      @shp: SCSI host that should be reset
>      *
> -    *      Returns SUCCESS if command aborted else FAILED
> +    *      Returns SUCCESS if host has been reset else FAILED

This should also mention FAST_IO_FAIL now that we touch this documentation
anyway. Same for the other callbacks that you change later in the patchset.

>      *
>      *      Locks: None held
>      *
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> index 9080a73b4ea6..4f9729cf4098 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -1955,34 +1955,27 @@ mptscsih_bus_reset(struct scsi_cmnd * SCpnt)
>  
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>  /**
> - *	mptscsih_host_reset - Perform a SCSI host adapter RESET (new_eh variant)
> - *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
> + *	mptscsih_host_reset - Perform a SCSI host adapter RESET
> + *	@sh: Pointer to Scsi_Host structure, which is reset due to
>   *
>   *	(linux scsi_host_template.eh_host_reset_handler routine)
>   *
>   *	Returns SUCCESS or FAILED.
>   */
>  int
> -mptscsih_host_reset(struct scsi_cmnd *SCpnt)
> +mptscsih_host_reset(struct Scsi_Host *sh)
>  {
> -	MPT_SCSI_HOST *  hd;
> +	MPT_SCSI_HOST *  hd = shost_priv(sh);
>  	int              status = SUCCESS;
>  	MPT_ADAPTER	*ioc;
>  	int		retval;
>  
> -	/*  If we can't locate the host to reset, then we failed. */
> -	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
> -		printk(KERN_ERR MYNAM ": host reset: "
> -		    "Can't locate host! (sc=%p)\n", SCpnt);
> -		return FAILED;
> -	}
> -
>  	/* make sure we have no outstanding commands at this stage */
>  	mptscsih_flush_running_cmds(hd);
>  
>  	ioc = hd->ioc;
> -	printk(MYIOC_s_INFO_FMT "attempting host reset! (sc=%p)\n",
> -	    ioc->name, SCpnt);
> +	printk(MYIOC_s_INFO_FMT "attempting host reset!\n",
> +	    ioc->name);

Nitpick: you could remove the line-break here now.

>  
>  	/*  If our attempts to reset the host failed, then return a failed
>  	 *  status.  The host will be taken off line by the SCSI mid-layer.
> @@ -1993,8 +1986,8 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
>  	else
>  		status = SUCCESS;
>  
> -	printk(MYIOC_s_INFO_FMT "host reset: %s (sc=%p)\n",
> -	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
> +	printk(MYIOC_s_INFO_FMT "host reset: %s\n",
> +	    ioc->name, (retval == 0 ? "SUCCESS" : "FAILED" ));
                                                          ^
Nitpick: IFF you remove the line-break above, maybe also remove the Plenk
         here.

>  
>  	return status;
>  }
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index f925f8664c2c..6dbffb1bc293 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -1717,18 +1717,15 @@ static int twa_scsi_biosparam(struct scsi_device *sdev, struct block_device *bde
>  } /* End twa_scsi_biosparam() */
>  
>  /* This is the new scsi eh reset function */
> -static int twa_scsi_eh_reset(struct scsi_cmnd *SCpnt)
> +static int twa_scsi_eh_reset(struct Scsi_Host *shost)
>  {
> -	TW_Device_Extension *tw_dev = NULL;
> +	TW_Device_Extension *tw_dev = shost_priv(shost);
>  	int retval = FAILED;
>  
> -	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
> -
>  	tw_dev->num_resets++;
>  
> -	sdev_printk(KERN_WARNING, SCpnt->device,
> -		"WARNING: (0x%02X:0x%04X): Command (0x%x) timed out, resetting card.\n",
> -		TW_DRIVER, 0x2c, SCpnt->cmnd[0]);
> +	shost_printk(KERN_WARNING, shost,
> +		     "WARNING: Command timed out, resetting card.");

Why remove the end-of-line `\n`? IIRC `printk()` generally doesn't append one
automatically.

>  
>  	/* Make sure we are not issuing an ioctl or resetting from ioctl */
>  	mutex_lock(&tw_dev->ioctl_lock);
> diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
> index 55989eaa2d9f..c18a07591505 100644
> --- a/drivers/scsi/3w-sas.c
> +++ b/drivers/scsi/3w-sas.c
> @@ -1423,18 +1423,15 @@ static int twl_scsi_biosparam(struct scsi_device *sdev, struct block_device *bde
>  } /* End twl_scsi_biosparam() */
>  
>  /* This is the new scsi eh reset function */
> -static int twl_scsi_eh_reset(struct scsi_cmnd *SCpnt)
> +static int twl_scsi_eh_reset(struct Scsi_Host *shost)
>  {
> -	TW_Device_Extension *tw_dev = NULL;
> +	TW_Device_Extension *tw_dev = shost_priv(shost);
>  	int retval = FAILED;
>  
> -	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
> -
>  	tw_dev->num_resets++;
>  
> -	sdev_printk(KERN_WARNING, SCpnt->device,
> -		"WARNING: (0x%02X:0x%04X): Command (0x%x) timed out, resetting card.\n",
> -		TW_DRIVER, 0x2c, SCpnt->cmnd[0]);
> +	shost_printk(KERN_WARNING, shost,
> +		     "WARNING: Command timed out, resetting card.");

...

>  
>  	/* Make sure we are not issuing an ioctl or resetting from ioctl */
>  	mutex_lock(&tw_dev->ioctl_lock);
> diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
> index f39c9ec2e781..190597e6b3d2 100644
> --- a/drivers/scsi/3w-xxxx.c
> +++ b/drivers/scsi/3w-xxxx.c
> @@ -1366,25 +1366,22 @@ static int tw_scsi_biosparam(struct scsi_device *sdev, struct block_device *bdev
>  } /* End tw_scsi_biosparam() */
>  
>  /* This is the new scsi eh reset function */
> -static int tw_scsi_eh_reset(struct scsi_cmnd *SCpnt)
> +static int tw_scsi_eh_reset(struct Scsi_Host *shost)
>  {
> -	TW_Device_Extension *tw_dev=NULL;
> +	TW_Device_Extension *tw_dev = shost_priv(shost);
>  	int retval = FAILED;
>  
> -	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
> -
>  	tw_dev->num_resets++;
>  
> -	sdev_printk(KERN_WARNING, SCpnt->device,
> -		"WARNING: Command (0x%x) timed out, resetting card.\n",
> -		SCpnt->cmnd[0]);
> +	shost_printk(KERN_WARNING, shost,
> +		"WARNING: Command timed out, resetting card.");

...

>  
>  	/* Make sure we are not issuing an ioctl or resetting from ioctl */
>  	mutex_lock(&tw_dev->ioctl_lock);
>  
>  	/* Now reset the card and some of the device extension data */
>  	if (tw_reset_device_extension(tw_dev)) {
> -		printk(KERN_WARNING "3w-xxxx: scsi%d: Reset failed.\n", tw_dev->host->host_no);
> +		shost_printk(KERN_WARNING, shost, "Reset failed.\n");
>  		goto out;
>  	}
>  
> diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
> index e6289c6af5ef..efa6f2527428 100644
> --- a/drivers/scsi/arm/fas216.c
> +++ b/drivers/scsi/arm/fas216.c
> @@ -2649,16 +2649,16 @@ static void fas216_init_chip(FAS216_Info *info)
>  }
>  
>  /**
> - * fas216_eh_host_reset - Reset the host associated with this command
> - * @SCpnt: command specifing host to reset
> + * fas216_eh_host_reset - Reset the host

Nitpick:

I think kdoc style wants the function to have `()` appended (now that you
change that line anyway).

    * fas216_eh_host_reset() - Reset the host.

> + * @shost: host to reset
>   *
> - * Reset the host associated with this command.
> + * Reset the specified host.
>   * Returns: FAILED if unable to reset.
>   * Notes: io_request_lock is taken, and irqs are disabled
>   */
> -int fas216_eh_host_reset(struct scsi_cmnd *SCpnt)
> +int fas216_eh_host_reset(struct Scsi_Host *shost)
>  {
> -	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
> +	FAS216_Info *info = shost_priv(shost);
>  
>  	spin_lock_irq(info->host->host_lock);
>  
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index 10cf5775a939..1faf4566b884 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -829,11 +829,11 @@ int ips_eh_abort(struct scsi_cmnd *SC)
>  /* NOTE: this routine is called under the io_request_lock spinlock          */
>  /*                                                                          */
>  /****************************************************************************/
> -static int __ips_eh_reset(struct scsi_cmnd *SC)
> +static int __ips_eh_reset(struct Scsi_Host *shost)
>  {
>  	int ret;
>  	int i;
> -	ips_ha_t *ha;
> +	ips_ha_t *ha = shost_priv(shost);
>  	ips_scb_t *scb;
>  
>  	METHOD_TRACE("ips_eh_reset", 1);
> @@ -842,20 +842,6 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
>  	return (FAILED);
>  #else
>  
> -	if (!SC) {
> -		DEBUG(1, "Reset called with NULL scsi command");
> -
> -		return (FAILED);
> -	}
> -
> -	ha = (ips_ha_t *) SC->device->host->hostdata;
> -
> -	if (!ha) {

I wonder whether we really know `ha` is always set here? At least from the
changeset it doesn't appear obvious to me. We get `ha` via the provided
`shost` and `shost_priv()`, but that doesn't necessarily mean the pointer is
not NULL.

> -		DEBUG(1, "Reset called with NULL ha struct");
> -
> -		return (FAILED);
> -	}
> -
>  	if (!ha->active)
>  		return (FAILED);
>  
> diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
> index 013fbfb911b9..43acad67d95f 100644
> --- a/drivers/scsi/megaraid.h
> +++ b/drivers/scsi/megaraid.h
> @@ -2502,8 +2502,8 @@ megaraid_abort_handler(struct scsi_cmnd *scp)
>  }
>  
>  /**
> - * megaraid_reset_handler - device reset handler for mailbox based driver

...

> - * @scp		: reference command
> + * megaraid_reset_handler - host reset handler for mailbox based driver
> + * @shost	: host to reset
>   *
>   * Reset handler for the mailbox based controller. First try to find out if
>   * the FW is still live, in which case the outstanding commands counter mut go
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 3d4f13da1ae8..cdd56144c841 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -2890,21 +2890,18 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
>  
>  /**
>   * megasas_generic_reset -	Generic reset routine
> - * @scmd:			Mid-layer SCSI command
> + * @shost:			Mid-layer SCSI host
>   *
> - * This routine implements a generic reset handler for device, bus and host
> - * reset requests. Device, bus and host specific reset handlers can use this
> + * This routine implements a generic reset handler for host
> + * reset requests. Host specific reset handlers can use this
>   * function after they do their specific tasks.

Nitpick: this comment really does sound sorta strange now, especially since
         this function is only called from one place.

>   */
> -static int megasas_generic_reset(struct scsi_cmnd *scmd)
> +static int megasas_generic_reset(struct Scsi_Host *shost)
>  {
>  	int ret_val;
> -	struct megasas_instance *instance;
> -
> -	instance = (struct megasas_instance *)scmd->device->host->hostdata;
> +	struct megasas_instance *instance = shost_priv(shost);
>  
> -	scmd_printk(KERN_NOTICE, scmd, "megasas: RESET cmd=%x retries=%x\n",
> -		 scmd->cmnd[0], scmd->retries);
> +	shost_printk(KERN_NOTICE, shost, "megasas: RESET\n");
>  
>  	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
>  		dev_err(&instance->pdev->dev, "cannot recover from previous reset failures\n");
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 040031eb0c12..d52412870b54 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -4028,9 +4028,9 @@ static int mpi3mr_eh_host_reset(struct scsi_cmnd *scmd)
>  
>  	retval = SUCCESS;
>  out:
> -	sdev_printk(KERN_INFO, scmd->device,
> -	    "Host reset is %s for scmd(%p)\n",
> -	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> +	shost_printk(KERN_INFO, shost,
> +	    "Host reset is %s\n",
> +	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"));

Nitpick: superfluous parentheses.

>  
>  	return retval;
>  }
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 7e103d711825..94a4bd5d2841 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1731,8 +1725,8 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
>  
>  eh_host_reset_lock:
>  	ql_log(ql_log_info, vha, 0x8017,
> -	    "ADAPTER RESET %s nexus=%ld:%d:%llu.\n",
> -	    (ret == FAILED) ? "FAILED" : "SUCCEEDED", vha->host_no, id, lun);
> +	    "ADAPTER RESET %s host=%ld.\n",
> +	    (ret == FAILED) ? "FAILED" : "SUCCEEDED", vha->host_no);

...

>  
>  	return ret;
>  }
> diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
> index c38f648da3d7..36298dbadb14 100644
> --- a/drivers/scsi/snic/snic_scsi.c
> +++ b/drivers/scsi/snic/snic_scsi.c
> @@ -2306,34 +2313,6 @@ snic_reset(struct Scsi_Host *shost)
>  	ret = SUCCESS;
>  
>  reset_end:
> -	return ret;
> -} /* end of snic_reset */
> -
> -/*
> - * SCSI Error handling calls driver's eh_host_reset if all prior
> - * error handling levels return FAILED.
> - *
> - * Host Reset is the highest level of error recovery. If this fails, then
> - * host is offlined by SCSI.
> - */
> -int
> -snic_host_reset(struct scsi_cmnd *sc)
> -{
> -	struct Scsi_Host *shost = sc->device->host;
> -	u32 start_time  = jiffies;
> -	int ret;
> -
> -	SNIC_SCSI_DBG(shost,
> -		      "host reset:sc %p sc_cmd 0x%x req %p tag %d flags 0x%llx\n",
> -		      sc, sc->cmnd[0], scsi_cmd_to_rq(sc),
> -		      snic_cmd_tag(sc), CMD_FLAGS(sc));
> -
> -	ret = snic_reset(shost);
> -
> -	SNIC_TRC(shost->host_no, snic_cmd_tag(sc), (ulong) sc,
> -		 jiffies_to_msecs(jiffies - start_time),
> -		 0, SNIC_TRC_CMD(sc), SNIC_TRC_CMD_STATE_FLAGS(sc));

Is it ok to loose those twp debug/logging statements? They seem to have some
information about timing.

> -
>  	return ret;
>  } /* end of snic_host_reset */
>  

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
