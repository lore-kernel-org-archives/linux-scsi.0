Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C69A9C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 15:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A92EC2070A
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 15:56:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TaElExOt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgEOP47 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 11:56:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60954 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgEOP47 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 11:56:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FFrCne146473;
        Fri, 15 May 2020 15:56:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=MlZs9pCWA7HZJ2HZeTNyA85HfoE0Xil7xoVU278CPz8=;
 b=TaElExOti3oa6RgLS+iiSBLg3LllDJjm95gFN11k0oetqHEvjGn/YNi/rtnlzWfavii8
 4XlJmhu1R0/P0iqyyRZpnHyP1FLG0aL5W+yT1tufJ5gBeMgEoeSiu+VcT4jLwgZLcBjO
 4rs2oueOicEDvSM3si13v7CuhoyRs4k3q77Dcqb+u9PpKQBqejD2Efb0EYMEot59BbNk
 8d7gaR5tfhaKiUU2XcqBe++MThgBSkY+wN65mdgL4aOU01UQJPmdsFHB4UbE+w7IjXKM
 1GWazcdv69N1MlxsgisDu5a/CmE8EMd92NiVLpnwsnbT9vUWZMoIN4IG12+NjRFlaH99 7w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 311nu5mb4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 15:56:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FFqoXg023000;
        Fri, 15 May 2020 15:54:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3100yru2hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 15:54:49 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04FFsm8g019471;
        Fri, 15 May 2020 15:54:48 GMT
Received: from [192.168.1.24] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 May 2020 08:54:47 -0700
Subject: Re: [PATCH v6 09/15] qla2xxx: Use register names instead of register
 offsets
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Daniel Wagner <dwagner@suse.de>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200514213516.25461-1-bvanassche@acm.org>
 <20200514213516.25461-10-bvanassche@acm.org>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle Corporation
Message-ID: <c1d70a8e-e436-a42b-0b9f-0cf65cc640d4@oracle.com>
Date:   Fri, 15 May 2020 10:54:46 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200514213516.25461-10-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 cotscore=-2147483648
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150135
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/14/20 4:35 PM, Bart Van Assche wrote:
> Make qla27xx_write_remote_reg() easier to read by using register names
> instead of register offsets. The 'pahole' tool has been used to convert
> register offsets into register names. See also commit cbb01c2f2f63
> ("scsi: qla2xxx: Fix MPI failure AEN (8200) handling").
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Cc: Arun Easi <aeasi@marvell.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qla2xxx/qla_tmpl.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
> index 4a4d92046cbf..645496091186 100644
> --- a/drivers/scsi/qla2xxx/qla_tmpl.c
> +++ b/drivers/scsi/qla2xxx/qla_tmpl.c
> @@ -17,14 +17,14 @@ static void
>   qla27xx_write_remote_reg(struct scsi_qla_host *vha,
>   			 u32 addr, u32 data)
>   {
> -	char *reg = (char *)ISPREG(vha);
> +	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
>   
>   	ql_dbg(ql_dbg_misc, vha, 0xd300,
>   	       "%s: addr/data = %xh/%xh\n", __func__, addr, data);
>   
> -	WRT_REG_DWORD(reg + IOBASE(vha), 0x40);
> -	WRT_REG_DWORD(reg + 0xc4, data);
> -	WRT_REG_DWORD(reg + 0xc0, addr);
> +	WRT_REG_DWORD(&reg->iobase_addr, 0x40);
> +	WRT_REG_DWORD(&reg->iobase_c4, data);
> +	WRT_REG_DWORD(&reg->iobase_window, addr);
>   }
>   
>   void
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani
Oracle Linux Engineering
