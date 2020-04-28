Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 941A8C83000
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 14:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 752F2206D6
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 14:51:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jCW3hAgZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgD1Ou6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 10:50:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45370 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727878AbgD1Ou6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2020 10:50:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SEmpuT116964;
        Tue, 28 Apr 2020 14:50:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=21bkKoVEDcFItNpAZkSZgketfx0K3t7FQdrYOmCXnPU=;
 b=jCW3hAgZbJUKMmmZkFPGdiEJOqCIc+5ynLGimPU6zQvVRnxd2ilU5Ou/968dVRCGba6o
 cHgh1Q0qisyk8aTXXR58Sc1GYi7ZdJ7pSzRf9n7tbLbB8GrTE/VlNlhJbtspwK/Gb5dY
 T1grJgeG8dc7YXiYrqVU03qn1N+yrMUas3BOW5RbqH8GyqFvM+/TMUcGxwamFc4b4d0z
 qMe4l8ksN2nKs1wzcRozVgVGNQywFmnKs5pZf4rz3T+GmbkIaULeEGTD7FmgDnnM3qga
 tjWoIJ+7vxBcUmHsXlBVWdiDadW+7LzML2J+BhIpnkDtAppxfqVZabenkxcVTpn1NDc6 Qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30nucg0egh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 14:50:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SEb5vD179570;
        Tue, 28 Apr 2020 14:50:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30my0dbqwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 14:50:51 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03SEomVU022423;
        Tue, 28 Apr 2020 14:50:49 GMT
Received: from [192.168.1.24] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 07:50:48 -0700
Subject: Re: [PATCH][next] scsi: qla2xxx: make 1 bit bit-fields unsigned int
To:     Colin King <colin.king@canonical.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Arun Easi <aeasi@marvell.com>, linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200428102013.1040598-1-colin.king@canonical.com>
From:   himanshu.madhani@oracle.com
Organization: Oracle Corporation
Message-ID: <ba9f540a-f46a-9380-e097-20d02abed2e1@oracle.com>
Date:   Tue, 28 Apr 2020 09:50:47 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200428102013.1040598-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280116
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 4/28/20 5:20 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The bitfields mpi_fw_dump_reading and mpi_fw_dumped are currently signed
> which is not recommended as the representation is an implementation defined
> behaviour.  Fix this by making the bit-fields unsigned ints.
> 
> Fixes: cbb01c2f2f63 ("scsi: qla2xxx: Fix MPI failure AEN (8200) handling")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index daa9e936887b..172ea4e5887d 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -4248,8 +4248,8 @@ struct qla_hw_data {
>   	int		fw_dump_reading;
>   	void		*mpi_fw_dump;
>   	u32		mpi_fw_dump_len;
> -	int		mpi_fw_dump_reading:1;
> -	int		mpi_fw_dumped:1;
> +	unsigned int	mpi_fw_dump_reading:1;
> +	unsigned int	mpi_fw_dumped:1;
>   	int		prev_minidump_failed;
>   	dma_addr_t	eft_dma;
>   	void		*eft;
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani
Oracle Linux Engineering
