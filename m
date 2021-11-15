Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D889BC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 11:43:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB60163212
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 11:43:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhKOLqv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 06:46:51 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16706 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231176AbhKOLqn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Nov 2021 06:46:43 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFAnjWp014745;
        Mon, 15 Nov 2021 11:43:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=zvozI2Ee7t6EQWp0cARYBkxJvR4i8EMHtx37GEh1bss=;
 b=TZFTc1KP/excXK3vlEwIrKP04yJwz8e1i1f93JstoGdqRTd61SgnuDRfFhZFguk2xI8K
 n8Rzp47nG/gv8P8fUPZM1rdWNisWm7aVYRCLW5iq5u06h0YBJ/6gUKWsncTg47hB9SXf
 1q9PDsqLHbvYa2F+wlnY+wfdvaw2yUoiiFuB2lC9wuDA/CoratOM10XZ272o+YHIY+R2
 +Yq3x/6tPOvarfTLMOQ3Kil3um6FwntGuwJe6jFXYtQT3boQl8Rr6ySdk45+7QHc1v79
 A90brM48XPhyu5V+ZhPeat+9k3+pAyV3N/YTAw8vmN9IepLOWaTrte/ZoLQy0duqydZq AA== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cbke6vhm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:43:45 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AFBd6AD011774;
        Mon, 15 Nov 2021 11:43:42 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3ca509c8ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 11:43:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AFBheBd49807688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 11:43:40 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 130D85204F;
        Mon, 15 Nov 2021 11:43:40 +0000 (GMT)
Received: from [9.145.81.248] (unknown [9.145.81.248])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B33B05205F;
        Mon, 15 Nov 2021 11:43:39 +0000 (GMT)
Message-ID: <c01c238d-6fc4-83fb-2288-dbb21bdd642f@linux.ibm.com>
Date:   Mon, 15 Nov 2021 12:43:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] scsi: simplify registration of scsi host sysfs attributes
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>
References: <20211115092922.367777-1-damien.lemoal@opensource.wdc.com>
From:   Steffen Maier <maier@linux.ibm.com>
In-Reply-To: <20211115092922.367777-1-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fDCVWdTNHWnbj1wDqI9qs60THGqBWjZ2
X-Proofpoint-ORIG-GUID: fDCVWdTNHWnbj1wDqI9qs60THGqBWjZ2
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_10,2021-11-15_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111150063
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/15/21 10:29, Damien Le Moal wrote:
> Similarly to the way attribute groups are registered for a scsi device
> using the device sdev_gendev, a scsi host attribute groups can be
> registered by specifying the generic attribute groups using the groups
> field of the scsi_host_type (struct device_type) and set the array of
> host attribute groups provided by the LLDD using the groups field of the
> host shost_dev generic device. This partially reverts the changes
> introduced by commit 92c4b58b15c5 ("scsi: core: Register sysfs
> attributes earlier"), avoiding the for loop to build a size limited
> array of attribute groups from the generic attributes and LLDD provided
> attribut groups.

See also 
https://lore.kernel.org/linux-scsi/2f5e5d18-7ba9-10f6-1855-84546172b473@linux.ibm.com/T/#md21644c177f45a0721d4fa3bdb84fbafb2bc8981 
?

E.g. your patch does not seem to remove the now unused(?) 
Scsi_Host.shost_dev_attr_groups ?

Not sure which is better: Bart using the scsi_host class or your below patch 
using scsi_host device_type.

> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>   drivers/scsi/hosts.c      | 15 +++------------
>   drivers/scsi/scsi_priv.h  |  2 +-
>   drivers/scsi/scsi_sysfs.c |  7 ++++++-
>   3 files changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 8049b00b6766..c3b6812aac5b 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -359,6 +359,7 @@ static void scsi_host_dev_release(struct device *dev)
>   static struct device_type scsi_host_type = {
>   	.name =		"scsi_host",
>   	.release =	scsi_host_dev_release,
> +	.groups =	scsi_sysfs_shost_attr_groups,
>   };
>   
>   /**
> @@ -377,7 +378,7 @@ static struct device_type scsi_host_type = {
>   struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>   {
>   	struct Scsi_Host *shost;
> -	int index, i, j = 0;
> +	int index;
>   
>   	shost = kzalloc(sizeof(struct Scsi_Host) + privsize, GFP_KERNEL);
>   	if (!shost)
> @@ -483,17 +484,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>   	shost->shost_dev.parent = &shost->shost_gendev;
>   	shost->shost_dev.class = &shost_class;
>   	dev_set_name(&shost->shost_dev, "host%d", shost->host_no);
> -	shost->shost_dev.groups = shost->shost_dev_attr_groups;
> -	shost->shost_dev_attr_groups[j++] = &scsi_shost_attr_group;
> -	if (sht->shost_groups) {
> -		for (i = 0; sht->shost_groups[i] &&
> -			     j < ARRAY_SIZE(shost->shost_dev_attr_groups);
> -		     i++, j++) {
> -			shost->shost_dev_attr_groups[j] =
> -				sht->shost_groups[i];
> -		}
> -	}
> -	WARN_ON_ONCE(j >= ARRAY_SIZE(shost->shost_dev_attr_groups));
> +	shost->shost_dev.groups = sht->shost_groups;
>   
>   	shost->ehandler = kthread_run(scsi_error_handler, shost,
>   			"scsi_eh_%d", shost->host_no);
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index a278fc8948f4..f8ca22d495d9 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -144,7 +144,7 @@ extern struct scsi_transport_template blank_transport_template;
>   extern void __scsi_remove_device(struct scsi_device *);
>   
>   extern struct bus_type scsi_bus_type;
> -extern const struct attribute_group scsi_shost_attr_group;
> +extern const struct attribute_group *scsi_sysfs_shost_attr_groups[];
>   
>   /* scsi_netlink.c */
>   #ifdef CONFIG_SCSI_NETLINK
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 55addd78fde4..c3b93d2de081 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -424,10 +424,15 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
>   	NULL
>   };
>   
> -const struct attribute_group scsi_shost_attr_group = {
> +static const struct attribute_group scsi_shost_attr_group = {
>   	.attrs =	scsi_sysfs_shost_attrs,
>   };
>   
> +const struct attribute_group *scsi_sysfs_shost_attr_groups[] = {
> +	&scsi_shost_attr_group,
> +	NULL,
> +};
> +
>   static void scsi_device_cls_release(struct device *class_dev)
>   {
>   	struct scsi_device *sdev;
> 


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z and LinuxONE

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
