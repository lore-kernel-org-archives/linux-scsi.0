Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF94C432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 21:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B05D923123
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 21:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbhALVri (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 16:47:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55030 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726987AbhALVrg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Jan 2021 16:47:36 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CLXEdq026468;
        Tue, 12 Jan 2021 16:46:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vG0liYip6v8+w7vW9CcQBVY9mm7AlLYEpuYzgSp5wqE=;
 b=GGNTRQfmYbZ+/Au8TfJ3oRfWVY61EYSfARL1wcjTPaAZeS3vN1cxYu9PJMteIYwRzXgI
 Xb68GXVcI/CFLqX1AWx3Q8dZneDz5iF3dMqLzZsWNsY5LhHIpvYCMH/rjtdYq1NIABZK
 aaqDCHLJeKVaZA5zT+5MFiHNU4PFVb39rUupaauHQEccc3s9l2361MariZY5KTwvBQUs
 7DGcFAAZSsQF1pOEKM+87pnIK9aKuc9/3kzgnS0nxVIR//Hhh3csh69x4y4OxBupe1me
 qenZQSD3+a+FBOSyoXEWSKlV/sXwIG5hnjGGUQIFxWV2cEl2FrgNLrj46wTdiSKy75eg IQ== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361hj4uvav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 16:46:49 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CLWFlW015748;
        Tue, 12 Jan 2021 21:46:48 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma05wdc.us.ibm.com with ESMTP id 35y4491001-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 21:46:48 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CLkkIF7471446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:46:46 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD497BE063;
        Tue, 12 Jan 2021 21:46:46 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FEDEBE054;
        Tue, 12 Jan 2021 21:46:46 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.211.156.88])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 21:46:46 +0000 (GMT)
Subject: Re: [PATCH v4 18/21] ibmvfc: send Cancel MAD down each hw scsi
 channel
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20210111231225.105347-1-tyreld@linux.ibm.com>
 <20210111231225.105347-19-tyreld@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <27876949-1427-a0b6-277c-e21628669a36@linux.vnet.ibm.com>
Date:   Tue, 12 Jan 2021 15:46:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210111231225.105347-19-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_16:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 clxscore=1015 adultscore=0 impostorscore=0 mlxlogscore=999 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120128
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/11/21 5:12 PM, Tyrel Datwyler wrote:
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index b0b0212344f3..24e1278acfeb 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -2418,18 +2418,79 @@ static struct ibmvfc_event *ibmvfc_init_tmf(struct ibmvfc_queue *queue,
>  	return evt;
>  }
>  
> -/**
> - * ibmvfc_cancel_all - Cancel all outstanding commands to the device
> - * @sdev:	scsi device to cancel commands
> - * @type:	type of error recovery being performed
> - *
> - * This sends a cancel to the VIOS for the specified device. This does
> - * NOT send any abort to the actual device. That must be done separately.
> - *
> - * Returns:
> - *	0 on success / other on failure
> - **/
> -static int ibmvfc_cancel_all(struct scsi_device *sdev, int type)
> +static int ibmvfc_cancel_all_mq(struct scsi_device *sdev, int type)
> +{
> +	struct ibmvfc_host *vhost = shost_priv(sdev->host);
> +	struct ibmvfc_event *evt, *found_evt, *temp;
> +	struct ibmvfc_queue *queues = vhost->scsi_scrqs.scrqs;
> +	unsigned long flags;
> +	int num_hwq, i;
> +	LIST_HEAD(cancelq);
> +	u16 status;
> +
> +	ENTER;
> +	spin_lock_irqsave(vhost->host->host_lock, flags);
> +	num_hwq = vhost->scsi_scrqs.active_queues;
> +	for (i = 0; i < num_hwq; i++) {
> +		spin_lock(queues[i].q_lock);
> +		spin_lock(&queues[i].l_lock);
> +		found_evt = NULL;
> +		list_for_each_entry(evt, &queues[i].sent, queue_list) {
> +			if (evt->cmnd && evt->cmnd->device == sdev) {
> +				found_evt = evt;
> +				break;
> +			}
> +		}
> +		spin_unlock(&queues[i].l_lock);
> +

I really don't like the way the first for loop grabs all the q_locks, and then
there is a second for loop that drops all these locks... I think this code would
be cleaner if it looked like:

		if (found_evt && vhost->logged_in) {
			evt = ibmvfc_init_tmf(&queues[i], sdev, type);
			evt->sync_iu = &queues[i].cancel_rsp;
			ibmvfc_send_event(evt, vhost, default_timeout);
			list_add_tail(&evt->cancel, &cancelq);
		}

		spin_unlock(queues[i].q_lock);

	}

> +		if (!found_evt)
> +			continue;
> +
> +		if (vhost->logged_in) {
> +			evt = ibmvfc_init_tmf(&queues[i], sdev, type);
> +			evt->sync_iu = &queues[i].cancel_rsp;
> +			ibmvfc_send_event(evt, vhost, default_timeout);
> +			list_add_tail(&evt->cancel, &cancelq);
> +		}
> +	}
> +
> +	for (i = 0; i < num_hwq; i++)
> +		spin_unlock(queues[i].q_lock);
> +	spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +
> +	if (list_empty(&cancelq)) {
> +		if (vhost->log_level > IBMVFC_DEFAULT_LOG_LEVEL)
> +			sdev_printk(KERN_INFO, sdev, "No events found to cancel\n");
> +		return 0;
> +	}
> +
> +	sdev_printk(KERN_INFO, sdev, "Cancelling outstanding commands.\n");
> +
> +	list_for_each_entry_safe(evt, temp, &cancelq, cancel) {
> +		wait_for_completion(&evt->comp);
> +		status = be16_to_cpu(evt->queue->cancel_rsp.mad_common.status);

You probably want a list_del(&evt->cancel) here.

> +		ibmvfc_free_event(evt);
> +
> +		if (status != IBMVFC_MAD_SUCCESS) {
> +			sdev_printk(KERN_WARNING, sdev, "Cancel failed with rc=%x\n", status);
> +			switch (status) {
> +			case IBMVFC_MAD_DRIVER_FAILED:
> +			case IBMVFC_MAD_CRQ_ERROR:
> +			/* Host adapter most likely going through reset, return success to
> +			 * the caller will wait for the command being cancelled to get returned
> +			 */
> +				break;
> +			default:
> +				break;

I think this default break needs to be a return -EIO.

> +			}
> +		}
> +	}
> +
> +	sdev_printk(KERN_INFO, sdev, "Successfully cancelled outstanding commands\n");
> +	return 0;
> +}
> +
> +static int ibmvfc_cancel_all_sq(struct scsi_device *sdev, int type)
>  {
>  	struct ibmvfc_host *vhost = shost_priv(sdev->host);
>  	struct ibmvfc_event *evt, *found_evt;
> @@ -2498,6 +2559,27 @@ static int ibmvfc_cancel_all(struct scsi_device *sdev, int type)
>  	return 0;
>  }
>  



-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

