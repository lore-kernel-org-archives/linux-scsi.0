Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8159DC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 10:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FE3161284
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 10:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhKKKiQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 05:38:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37886 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232922AbhKKKiP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Nov 2021 05:38:15 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ABAHaHO004256;
        Thu, 11 Nov 2021 10:35:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=/hpsZJ1bCSQfwAmmWkn7uUeO6iNkv02N9EZFyQ7gnGI=;
 b=HimeU2D5kbCaYDvgkbZxQ2st5N01FgSADQ4mbfnr3XZ//hiBy/PsH8kdCxlsgAzxaKhg
 LhEfjD7p4vYMl/yLgrhtSAeaT9VJkwhMmfK5zAuUca4zLTPZgBm2JEiLt0zClkH8u94E
 Adbd+ZJju78AAqBX4Vg8rbu3SvTv22YsvkVZ+FAN6o3epiuBUs921rSsZleeA2hj2u8+
 5NlDym5g066CwV60dz3WaZf0yZBXgEpsVwqBu9FRyk1/LfUBkte80tQV3/KvQIurNPL3
 h76VC69hDTmPI68rDjgaZfLZzdUp8VCEJXUTaC723f1ov3Ltpa+5k2rfdBl8M/NfuLBd CA== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c919y8bmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 10:35:20 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ABAXc6x030838;
        Thu, 11 Nov 2021 10:35:17 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3c5hba1w3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 10:35:17 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ABAZFZc11600272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 10:35:15 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2390E11C05C;
        Thu, 11 Nov 2021 10:35:15 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A82311C04C;
        Thu, 11 Nov 2021 10:35:14 +0000 (GMT)
Received: from [9.145.16.148] (unknown [9.145.16.148])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Nov 2021 10:35:14 +0000 (GMT)
Message-ID: <0cdf8e28-2fcc-9aa6-e8cb-ef1c0c77bd69@linux.ibm.com>
Date:   Thu, 11 Nov 2021 11:35:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] scsi: fix scsi device attributes registration
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>
References: <20211111084551.446548-1-damien.lemoal@opensource.wdc.com>
From:   Steffen Maier <maier@linux.ibm.com>
In-Reply-To: <20211111084551.446548-1-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ixwrj5A9d0zMzRVCR-1MBKABr5UAfbUi
X-Proofpoint-ORIG-GUID: ixwrj5A9d0zMzRVCR-1MBKABr5UAfbUi
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-11_03,2021-11-08_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 priorityscore=1501 impostorscore=0 clxscore=1011
 spamscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111110064
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/21 09:45, Damien Le Moal wrote:
> Since the sdev_gendev device of a scsi device defines its attributes
> using scsi_sdev_attr_groups as the groups field value of its device
> type, the execution of device_add() in scsi_sysfs_add_sdev() register
> with sysfs only the attributes defined using scsi_sdev_attr_groups. As
> a results, the attributes defined by an LLD using the scsi host
> sdev_groups attribute groups are never registered with sysfs and not
> visible to the users.
> 
> Fix this problem by removing scsi_sdev_attr_groups and manually setting
> the groups field of a scsi device sdev_gendev to point to the scsi
> device gendev_attr_groups. As the first entry of this array of
> attribute groups is scsi_sdev_attr_group, using gendev_attr_groups as
> the gendev groups result in all defined attributes to be created in
> sysfs when device_add() is called.
> 
> Fixes: 92c4b58b15c5 ("scsi: core: Register sysfs attributes earlier")
> cc: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>   drivers/scsi/scsi_sysfs.c | 7 +------
>   1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index d3d362289ecc..92c92853f516 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1301,11 +1301,6 @@ static struct attribute_group scsi_sdev_attr_group = {
>   	.is_bin_visible = scsi_sdev_bin_attr_is_visible,
>   };
>   
> -static const struct attribute_group *scsi_sdev_attr_groups[] = {
> -	&scsi_sdev_attr_group,
> -	NULL
> -};
> -
>   static int scsi_target_add(struct scsi_target *starget)
>   {
>   	int error;
> @@ -1575,7 +1570,6 @@ int scsi_sysfs_add_host(struct Scsi_Host *shost)
>   static struct device_type scsi_dev_type = {
>   	.name =		"scsi_device",
>   	.release =	scsi_device_dev_release,
> -	.groups =	scsi_sdev_attr_groups,
>   };
>   
>   void scsi_sysfs_device_initialize(struct scsi_device *sdev)
> @@ -1601,6 +1595,7 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
>   		}
>   	}
>   	WARN_ON_ONCE(j >= ARRAY_SIZE(sdev->gendev_attr_groups));
> +	sdev->sdev_gendev.groups = sdev->gendev_attr_groups;
>   
>   	device_initialize(&sdev->sdev_dev);
>   	sdev->sdev_dev.parent = get_device(&sdev->sdev_gendev);
> 

Damien, which kernel were you using?

Isn't this fixed by?:

next:

https://lore.kernel.org/linux-scsi/163478764102.7011.9375895285870786953.b4-ty@oracle.com/t/#mab0eeb4a8d8db95c3ace0013bfef775736e124cb
("scsi: core: Fix early registration of sysfs attributes for scsi_device")
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=5.16/scsi-staging&id=3a71f0f7a51259b3cb95d79cac1e19dcc5e89ce9
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=5.16/scsi-queue&id=3a71f0f7a51259b3cb95d79cac1e19dcc5e89ce9
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=for-next&id=3a71f0f7a51259b3cb95d79cac1e19dcc5e89ce9
=>
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next-history.git/commit/?h=next-20211028&id=503f375baa99edff894eb1a534d2ac0b4f799573

soon in vanilla:

https://lore.kernel.org/linux-scsi/163612851260.17201.4106345384610850520.pr-tracker-bot@kernel.org/t/#md79869a3966ccceb30eef658b85743e49cf31dc1


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
