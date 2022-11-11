Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A60C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Nov 2022 15:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbiKKPv3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Nov 2022 10:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234226AbiKKPv1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2022 10:51:27 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D9B5FAC
        for <linux-scsi@vger.kernel.org>; Fri, 11 Nov 2022 07:51:26 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABFSaAw037684;
        Fri, 11 Nov 2022 15:51:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=IEfyUDklbzIJhAWSo7UQVcNs43D/8ojCwvm+KMrmcCo=;
 b=RUeE5KXRs4RwWBTR2/MqYPz/yC1msCsb2JMXs1fEr8LvvZ7dHUEc3nEtHeqcS85rNjsM
 ApHU9x2FpUp7R8fpAlsp8OvW2lfN7FvW9oOCeuWLs3QmyNXhU0hFYggY4bFs3Ds0JONC
 Uypd8XoXbP3NIrx8l3GYbPB7UBxT8UrozfyqOvNZ7kpCMJcvkScPiZk5IS5Y033Ziwbx
 iDbAlwtNR73YHfWHUDal0lvmFDINT4GTkGXPNSZQRo/1Y1DtjxROXgXQLyBjh9URrM23
 wwxLfDSvzt0bsC9mOC5Kilg9ETTZnO/Vxa7Nik/t9Ab9gl8SNQ0G1ItFpxAE1Fffi087 iQ== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kss2r0p2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 15:51:17 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ABFoACu000766;
        Fri, 11 Nov 2022 15:51:16 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 3kngnfbbvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 15:51:16 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ABFpHUX27722334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 15:51:17 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7205B7805E;
        Fri, 11 Nov 2022 16:46:36 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A535F7805C;
        Fri, 11 Nov 2022 16:46:35 +0000 (GMT)
Received: from lingrow.int.hansenpartnership.com (unknown [9.211.128.15])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 11 Nov 2022 16:46:35 +0000 (GMT)
Message-ID: <4f1992b1a90aa9e5d143ac47eadae508a20b9f9c.camel@linux.ibm.com>
Subject: Re: [PATCH v2] scsi: scsi_transport_sas: fix error handling in
 sas_rphy_add()
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, john.g.garry@oracle.com
Date:   Fri, 11 Nov 2022 10:51:13 -0500
In-Reply-To: <20221111144433.2421680-1-yangyingliang@huawei.com>
References: <20221111144433.2421680-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fHDts0S1__cKW6M-LZls2-bfQaqHp21U
X-Proofpoint-ORIG-GUID: fHDts0S1__cKW6M-LZls2-bfQaqHp21U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_08,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 impostorscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 clxscore=1011
 lowpriorityscore=0 suspectscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211110103
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2022-11-11 at 22:44 +0800, Yang Yingliang wrote:
> In sas_rphy_add(), if transport_add_device() fails, the device
> is not added, the return value is not checked, it won't goto
> error path, when removing rphy in normal remove path, it causes
> null-ptr-deref, because transport_remove_device() is called to
> remove the device that was not added.
> 
> Unable to handle kernel NULL pointer dereference at virtual address
> 0000000000000108
> pc : device_del+0x54/0x3d0
> lr : device_del+0x37c/0x3d0
> Call trace:
>  device_del+0x54/0x3d0
>  attribute_container_class_device_del+0x28/0x38
>  transport_remove_classdev+0x6c/0x80
>  attribute_container_device_trigger+0x108/0x110
>  transport_remove_device+0x28/0x38
>  sas_rphy_remove+0x50/0x78 [scsi_transport_sas]
>  sas_port_delete+0x30/0x148 [scsi_transport_sas]
>  do_sas_phy_delete+0x78/0x80 [scsi_transport_sas]
>  device_for_each_child+0x68/0xb0
>  sas_remove_children+0x30/0x50 [scsi_transport_sas]
>  sas_rphy_remove+0x38/0x78 [scsi_transport_sas]
>  sas_port_delete+0x30/0x148 [scsi_transport_sas]
>  do_sas_phy_delete+0x78/0x80 [scsi_transport_sas]
>  device_for_each_child+0x68/0xb0
>  sas_remove_children+0x30/0x50 [scsi_transport_sas]
>  sas_remove_host+0x20/0x38 [scsi_transport_sas]
>  scsih_remove+0xd8/0x420 [mpt3sas]
> 
> Fix this by checking and handling return value of
> transport_add_device()
> in sas_rphy_add().
> 
> Fixes: c7ebbbce366c ("[SCSI] SAS transport class")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v1 -> v2:
>   Update commit message.
> ---
>  drivers/scsi/scsi_transport_sas.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_transport_sas.c
> b/drivers/scsi/scsi_transport_sas.c
> index 74b99f2b0b74..accc0afa8f77 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -1526,7 +1526,11 @@ int sas_rphy_add(struct sas_rphy *rphy)
>         error = device_add(&rphy->dev);
>         if (error)
>                 return error;
> -       transport_add_device(&rphy->dev);
> +       error = transport_add_device(&rphy->dev);
> +       if (error) {
> +               device_del(&rphy->dev);
> +               return error;
> +       }
>         transport_configure_device(&rphy->dev);
>         if (sas_bsg_initialize(shost, rphy))
>                 printk("fail to a bsg device %s\n", dev_name(&rphy-
> >dev));

There is a slight problem with doing this in that if
transport_device_add() ever fails it's likely because memory pressure
caused the allocation of the internal_container to fail. What that
means is that the visible sysfs attributes don't get added, but
otherwise the rphy is fully functional as far as the driver sees it, so
this condition doesn't have to be a fatal error which kills the device.

There are two ways of handling this:

   1. The above to move the condition from an ignored to a fatal error.
      It's so rare that we almost never see it in practice and if it
      ever happened, the machine is so low on memory that something
      else is bound to fail an allocation and kill the device anyway,
      so treating it as non-fatal likely serves no purpose.
   2. Simply to make the assumption that transport_remove_device() is
      idempotent true by adding a flag in the internal_class to signify
      removal is required. This would preserve current behaviour and
      have the bonus that it only requires a single patch, not one
      patch per transport class object that has this problem.

I'd probably prefer 2. since it's way less work, but others might have
different opinions.

James

