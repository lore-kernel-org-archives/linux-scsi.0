Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC514C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 15:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BD1B20758
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 15:45:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="swiwDxiW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgEOPpK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 11:45:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50348 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgEOPpK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 11:45:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FFbaAX026514;
        Fri, 15 May 2020 15:44:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=1+tmDik4nldXbJypXaUhJGdOyXd8Xu5EjWsUz55WNq0=;
 b=swiwDxiW+E50V8KoiFNCvJYi9QUnywNiBtzj86gkR7Uj4ghIJTEjkfPTEKfe/Mq6J/bU
 Z3hKbk5ChtXeRnVPcZH+6qqzUqqf7iaA9HkGly4XMrtZJjINFVjvytfjCWYPyt5DAiKv
 qc7W+UTAu1GxGoTuRqCo1N94XsFmaxotY60sX5XiWhEQcfTF/uDOO6H58+1TU7N2w1mA
 hR4WHmh3pqVYmWt7I6KJYh0uZClcdEX5XJyM5EWjZbMWBNmzfuu7OUYW3haSDeYNT6/4
 7kgF4AjChK0/N9wmATW/Rjp/RtPUj1mM7QOmTp4mKjyeW39/wDn8ODy4HSjCGSvoAP2P sQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3100xwv3vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 15:44:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FFcB0a154889;
        Fri, 15 May 2020 15:44:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3100yf33mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 15:44:58 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04FFitcD013397;
        Fri, 15 May 2020 15:44:55 GMT
Received: from [192.168.1.24] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 May 2020 08:44:55 -0700
Subject: Re: [PATCH v6 06/15] qla2xxx: Make a gap in struct
 qla2xxx_offld_chain explicit
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>, Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200514213516.25461-1-bvanassche@acm.org>
 <20200514213516.25461-7-bvanassche@acm.org>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle Corporation
Message-ID: <1780ae48-5865-a5d0-51d5-ebf8f0b83ab9@oracle.com>
Date:   Fri, 15 May 2020 10:44:53 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200514213516.25461-7-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005150133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150133
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/14/20 4:35 PM, Bart Van Assche wrote:
> This patch makes struct qla2xxx_offld_chain compatible with ARCH=i386.
> 
> Reviewed-by: Daniel Wagner <dwagner@suse.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Arun Easi <aeasi@marvell.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
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
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani
Oracle Linux Engineering
