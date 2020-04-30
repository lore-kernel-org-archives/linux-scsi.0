Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9D1C83010
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E1192076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R+EyU5hQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgD3NUR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57372 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbgD3NUI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2020 09:20:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UDJLxg114097;
        Thu, 30 Apr 2020 13:19:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xy/1qwI9qxwIfg0g+daxb1BAP6f5f0orcFwzrnuEKeM=;
 b=R+EyU5hQ6Z1iWZncsaPASQfN7CjWDX0os5GShUuFAO4ielQ3zlmcKTKbnhOGV8PTp+CP
 J50h9B5SGMPy13rBnRGmCxQ6UWpwoziRlUCUmkju51eERgS2+hhGj6lRieycPyLA6usY
 lF2Z8ly7anYyuvfDHk834tdaWulES4AZn8xcnwjhmIS0FPRiqhELeK4VUqJYArvMN1Hv
 /KhXIERtNBVnmGWgYScuSQ+Gm6GrvduxBvMfxL/U/fnB7Fgk0PLle1cLFKnuOX/IpuDu
 ygvFQ0swGAGNNrxybQ0v9h4hwWh9TFHOktQ/3o35Cc48RIq3xS/7S/r49GTuc+Z4JZAZ iA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30p01p1x7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 13:19:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UDGsYb038508;
        Thu, 30 Apr 2020 13:17:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30qtf775gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 13:17:54 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UDHqoS020254;
        Thu, 30 Apr 2020 13:17:53 GMT
Received: from [10.154.112.177] (/10.154.112.177)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 06:17:52 -0700
Subject: Re: [PATCH] scsi: qla2xxx: use true,false for need_mpi_reset
To:     Jason Yan <yanaijie@huawei.com>, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, aeasi@marvell.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200430121751.15232-1-yanaijie@huawei.com>
From:   himanshu.madhani@oracle.com
Organization: Oracle Corporation
Message-ID: <59d50953-cebe-3dd4-e48e-d3283da923f5@oracle.com>
Date:   Thu, 30 Apr 2020 08:17:51 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430121751.15232-1-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1011
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300108
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 4/30/20 7:17 AM, Jason Yan wrote:
> Fix the following coccicheck warning:
> 
> drivers/scsi/qla2xxx/qla_tmpl.c:1031:6-20: WARNING: Assignment of 0/1 to
> bool variable
> drivers/scsi/qla2xxx/qla_tmpl.c:1062:3-17: WARNING: Assignment of 0/1 to
> bool variable
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>   drivers/scsi/qla2xxx/qla_tmpl.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
> index 819c46f31c05..281973b317a8 100644
> --- a/drivers/scsi/qla2xxx/qla_tmpl.c
> +++ b/drivers/scsi/qla2xxx/qla_tmpl.c
> @@ -1028,7 +1028,7 @@ void
>   qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
>   {
>   	ulong flags = 0;
> -	bool need_mpi_reset = 1;
> +	bool need_mpi_reset = true;
>   
>   #ifndef __CHECKER__
>   	if (!hardware_locked)
> @@ -1059,7 +1059,7 @@ qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
>   			       "-> fwdt1 fwdump residual=%+ld\n",
>   			       fwdt->dump_size - len);
>   		} else {
> -			need_mpi_reset = 0;
> +			need_mpi_reset = false;
>   		}
>   
>   		vha->hw->mpi_fw_dump_len = len;
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani
Oracle Linux Engineering
