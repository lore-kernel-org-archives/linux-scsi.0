Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1010C25B48
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 13:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbjJZNsd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 09:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjJZNsc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 09:48:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02BD1A2
        for <linux-scsi@vger.kernel.org>; Thu, 26 Oct 2023 06:48:29 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39QDj6wo010711;
        Thu, 26 Oct 2023 13:47:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=EwI6ifmD/TIxZdtVhsJeIKltEXlqy2T6nqSEx2HZt0Y=;
 b=B90l+Ya+atHV1gF5W6hSFdD7L0CoJvztjM4u50OvPyrjPnXbMdltPCIsoLHQEmywRsGE
 L8H+ryPPy8lJZ5jaK/rs5piRfCAEwbvfJfU6ch1Hm/xka2xndl67CXIuHgACOxmWMY/o
 xpSovxrsm7yEpiKREKfHIe1qdYGmvBHqeGDsrIIFM6B0Lo+oeXF/RI/ZaxHzSNd4o/85
 McUMRSo+LeT1ZuPuotPT5ZK+DC6TQEy/c7hSWd511eTu8rFQSi3XHc+8w8GOoGlNaq6p
 70U17MUrx9oq3koGqMoIWhX/yyIPRLFf1W9auP3qEHcgs+XLAUerMi1CX4VWyB4ENGsD yw== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tys9002kp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 13:47:41 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39QBVPxV023834;
        Thu, 26 Oct 2023 13:47:40 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tvryteps7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 13:47:40 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39QDlc5e35520814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Oct 2023 13:47:38 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B61C92004B;
        Thu, 26 Oct 2023 13:47:38 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5D6220040;
        Thu, 26 Oct 2023 13:47:38 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.152.212.253])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 26 Oct 2023 13:47:38 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.96.1)
        (envelope-from <bblock@linux.ibm.com>)
        id 1qw0i2-00ApmV-1I;
        Thu, 26 Oct 2023 15:47:38 +0200
Date:   Thu, 26 Oct 2023 15:47:38 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 07/10] scsi: Do not allocate scsi command in
 scsi_ioctl_reset()
Message-ID: <20231026134738.GM1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
References: <20231023092837.33786-1-hare@suse.de>
 <20231023092837.33786-8-hare@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20231023092837.33786-8-hare@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ewym8aomtlJ3nW_IjTFGLzzYagUQlT-m
X-Proofpoint-GUID: ewym8aomtlJ3nW_IjTFGLzzYagUQlT-m
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-26_11,2023-10-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 suspectscore=0 phishscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310260118
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 23, 2023 at 11:28:34AM +0200, Hannes Reinecke wrote:
> As we now have moved the error handler functions to not rely on
> a scsi command we can drop the out-of-band scsi command allocation
> from scsi_ioctl_reset().
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi_error.c | 95 ++++++++++++++++-----------------------
>  1 file changed, 39 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 7c9c376affda..63b762d5d66f 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -896,28 +895,29 @@ static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
>  
>  /**
>   * scsi_try_bus_reset - ask host to perform a bus reset
> - * @scmd:	SCSI cmd to send bus reset.
> + * @host:	SCSI host to send bus reset.
> + * @channel:	Number of the bus to be reset
>   */
> -static enum scsi_disposition scsi_try_bus_reset(struct scsi_cmnd *scmd)
> +static enum scsi_disposition scsi_try_bus_reset(struct Scsi_Host *host,
> +						int channel)

This should be `unsigned int`, to align with `eh_bus_reset_handler()`.

>  {
>  	unsigned long flags;
>  	enum scsi_disposition rtn;
> -	struct Scsi_Host *host = scmd->device->host;
>  	const struct scsi_host_template *hostt = host->hostt;
>  
> -	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
> -		"%s: Snd Bus RST\n", __func__));
> +	SCSI_LOG_ERROR_RECOVERY(3, shost_printk(KERN_INFO, host,
> +		"%s: Snd Bus RST to bus %d\n", __func__, channel));

And then this should be %u              ^^

>  
>  	if (!hostt->eh_bus_reset_handler)
>  		return FAILED;
>  
> -	rtn = hostt->eh_bus_reset_handler(host, scmd_channel(scmd));
> +	rtn = hostt->eh_bus_reset_handler(host, channel);
> @@ -1014,11 +1014,15 @@ scsi_try_to_abort_cmd(const struct scsi_host_template *hostt, struct scsi_cmnd *
>  
>  static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
>  {
> -	if (scsi_try_to_abort_cmd(scmd->device->host->hostt, scmd) != SUCCESS)
> -		if (scsi_try_bus_device_reset(scmd) != SUCCESS)
> -			if (scsi_try_target_reset(scmd) != SUCCESS)
> -				if (scsi_try_bus_reset(scmd) != SUCCESS)
> -					scsi_try_host_reset(scmd);
> +	struct Scsi_Host *host = scmd->device->host;
> +	struct scsi_target *starget = scsi_target(scmd->device);
> +	int channel = scmd->device->channel;

Probably better
    
    unsigned int channel = scmd_channel(scmd);

> +
> +	if (scsi_try_to_abort_cmd(host->hostt, scmd) != SUCCESS)
> +		if (scsi_try_bus_device_reset(scmd->device) != SUCCESS)
> +			if (scsi_try_target_reset(host, starget) != SUCCESS)
> +				if (scsi_try_bus_reset(host, channel) != SUCCESS)
> +					scsi_try_host_reset(host);
>  }
>  
>  /**
> @@ -2470,22 +2456,22 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
>  			break;
>  		fallthrough;
>  	case SG_SCSI_RESET_BUS:
> -		rtn = scsi_try_bus_reset(scmd);
> +		rtn = scsi_try_bus_reset(shost, dev->channel);

Probably also use `sdev_channel(dev)`

>  		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
>  			break;
>  		fallthrough;

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
