Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83BABC55199
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 14:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B54E206B9
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 14:27:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C57OLapJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgD0O1v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 10:27:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40946 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727999AbgD0O1u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 10:27:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03REPCQf118770;
        Mon, 27 Apr 2020 14:27:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YPRVbTXHaJELNJa4anIRIAIsVcTbWrSa8JWQbQWEy2E=;
 b=C57OLapJ2B5Dv/uN3KgWBudWJzcMOMFCzV36sjBGSaswsJ1gbYObOA64Dhym5Rn+XHGE
 c8y++BLB9t2QpuqVajWDk7ixOp9tnrRjygqCihSW/XMisb2U2C5j2VcbodoMD6EbWnev
 eApVVpA7+79sDU6oPKO/Arw1Aw4g45owyJabLN7zserKIOOP5DECEYxYNxjGSPc+aklF
 H/GydYEyvIcpTYrP3rZTkKr+rK7Rw0FU14FAKdMQknUlGKzvF1IwRxYBTNQdwZeRZiMX
 EaLV/HgGy51O7QtZeM+ljxRxmiw+54GRq3WR/BUv/0l+QXxFVPV1PpeyzR9lS4f5Ae2+ IQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30p01uge64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 14:27:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03REQbs1014083;
        Mon, 27 Apr 2020 14:27:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30mxpdbw28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 14:27:36 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03RERYrI016821;
        Mon, 27 Apr 2020 14:27:34 GMT
Received: from [10.154.123.249] (/10.154.123.249)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 07:27:34 -0700
Subject: Re: [PATCH v4 05/11] qla2xxx: Make a gap in struct
 qla2xxx_offld_chain explicit
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-6-bvanassche@acm.org>
From:   himanshu.madhani@oracle.com
Organization: Oracle Corporation
Message-ID: <d63f4b0b-9eea-9ae7-5c77-4b37a2040193@oracle.com>
Date:   Mon, 27 Apr 2020 09:27:31 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427030310.19687-6-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9603 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9603 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 adultscore=0 suspectscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270121
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 4/26/20 10:03 PM, Bart Van Assche wrote:
> This patch makes struct qla2xxx_offld_chain compatible with ARCH=i386.
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qla2xxx/qla_dbg.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
> index 433e95502808..b106b6808d34 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.h
> +++ b/drivers/scsi/qla2xxx/qla_dbg.h
> @@ -238,6 +238,7 @@ struct qla2xxx_offld_chain {
>   	uint32_t chain_size;
>   
>   	uint32_t size;
> +	uint32_t reserved;
>   	u64	 addr;
>   };
>   
> 

I think this should to be verified with Marvell Firmware folks. (I don't 
have API document handy with me anymore)

-- 
Himanshu Madhani
Oracle Linux Engineering
