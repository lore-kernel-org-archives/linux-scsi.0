Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE25C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 22:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DDB620776
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 22:09:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nlTe8JO0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgE2WJC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 18:09:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60564 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbgE2WJB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2020 18:09:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04TM8eId155992;
        Fri, 29 May 2020 22:08:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=qedDwc2aEc/U17HxBqyELpRMoiYkZznjcLXjG+GsT6E=;
 b=nlTe8JO0BZlhAy6csK+8Cl4PvTONkVmtuKQLpxktVS24CuK35qmvLiUaypDPauSWWobm
 xj99qJjZ7VtFLR9pyp+sqdBauTP47ns5w1u7f8f93d5MA8S9LG1vVCuqAcUi0B/f4p3i
 K4WwNsC6cPIoCKipYKQ2kBz6IqRHHW7XNYGNBLgrnQa83LdtZEcOwEiVF6teNargOoZZ
 j5XejHCcl5BbL2OfjF6gU+qm5naMSf/i3yQvl4ZIFZ1GinPRxoGscjQjYazRuafamV0O
 LjdxdcI4c22PZQXjdt9mfvaoYBx6LjhwKDU7yAu7Rt0nZJNHvkts2rOjiB2TY5ztCaAn 8g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 318xbkcqte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 29 May 2020 22:08:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04TM31Mg010946;
        Fri, 29 May 2020 22:06:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 317ds4wp2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 May 2020 22:06:50 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04TM6kX5030254;
        Fri, 29 May 2020 22:06:47 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 29 May 2020 15:06:46 -0700
Subject: Re: [PATCH 2/5] target_core_pscsi: use __scsi_device_lookup()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200529134730.146573-1-hare@suse.de>
 <20200529134730.146573-3-hare@suse.de>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <1c47b356-de00-b799-ce28-a886ed309853@oracle.com>
Date:   Fri, 29 May 2020 17:06:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200529134730.146573-3-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9636 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005290159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9636 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 cotscore=-2147483648
 suspectscore=0 bulkscore=0 clxscore=1011 impostorscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005290159
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/29/20 8:47 AM, Hannes Reinecke wrote:
> Instead of walking the list of devices manually use the helper
> function to return the device directly.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: Bart van Assche <bvanassche@acm.org>
> ---
>   drivers/target/target_core_pscsi.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index c9d92b3e777d..5fb852d1281f 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -496,11 +496,9 @@ static int pscsi_configure_device(struct se_device *dev)
>   	}
>   
>   	spin_lock_irq(sh->host_lock);
> -	list_for_each_entry(sd, &sh->__devices, siblings) {
> -		if ((pdv->pdv_channel_id != sd->channel) ||
> -		    (pdv->pdv_target_id != sd->id) ||
> -		    (pdv->pdv_lun_id != sd->lun))
> -			continue;
> +	sd = __scsi_device_lookup(sh, pdv->pdv_channel_id,
> +				  pdv->pdv_target_id, pdv->pdv_lun_id);
> +	if (sd) {
>   		/*
>   		 * Functions will release the held struct scsi_host->host_lock
>   		 * before calling calling pscsi_add_device_to_list() to register
> 

Do you need a check in pscsi_set_configfs_dev_params to make sure 
pdv_channel_id is withing the 16 value limit? If not, userspace could 
use pdv_channel_id = (1 << 17) and when you shift that by 16, will we 
end up with 0 after the cast?

It's probably only going to come up in QA/testing type of setups since 
as you said there's never been a case with a channel_id that large.
