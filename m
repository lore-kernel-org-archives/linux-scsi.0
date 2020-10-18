Return-Path: <SRS0=jquQ=DZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BEAC433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Oct 2020 22:47:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3FF322272
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Oct 2020 22:47:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nn5oeuKL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgJRWqz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Oct 2020 18:46:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51230 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgJRWqy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Oct 2020 18:46:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09IMdOnK164523;
        Sun, 18 Oct 2020 22:46:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=V2AF6mLh43s8o2WI9+ncHrjGsHjWPSdrdgrxXTDAc94=;
 b=nn5oeuKLzUB7QLpQJqTGXli1I1rPMeTX+G5fPNC8UvXPGpbeh/dAylN44D+y9JvkVc0J
 RvvgkglVTi8v+HrHiucdLrL0woS5j2yjbX5rAbrPYIp2iKbclxqgDn8D82aj3M8iiY9L
 e0jnY1mY2mIu24LqNKK96JZpnHrY98T9iIHcfh2es7nnGwCPaOEm4NsRHopa+2uuunhV
 QY3RtRXV6lBlNHGm4iojZI8h1PzCj6e+hzvU+sLNNAZFrDXSAiL21uqrQea9Tw2NVQhk
 r7tMIQxFHOZm7yjNHqi2Rou2yfWsUhopRkfhJxfa4kVvfC/qLtS9MkgSfMcqY1x9udWt yQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 347rjkjwk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 18 Oct 2020 22:46:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09IMjt8d186179;
        Sun, 18 Oct 2020 22:46:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 348a6k9j0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 18 Oct 2020 22:46:52 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09IMkpuv008655;
        Sun, 18 Oct 2020 22:46:51 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 18 Oct 2020 15:46:51 -0700
Subject: Re: [PATCH] scsi: target: tcmu: scatter_/gather_data_area rework
To:     Bodo Stroesser <bostroesser@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20201016195839.27440-1-bostroesser@gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <89399f74-86e5-1217-c06e-f5ac4f9b5853@oracle.com>
Date:   Sun, 18 Oct 2020 17:46:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201016195839.27440-1-bostroesser@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9778 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010180180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9778 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 clxscore=1015 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010180179
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/16/20 2:58 PM, Bodo Stroesser wrote:
> +
> +static inline void tcmu_copy_data(struct tcmu_dev *udev,
> +				  struct tcmu_cmd *tcmu_cmd, uint32_t direction,
> +				  struct scatterlist *sg, unsigned int sg_nents,
> +				  struct iovec **iov,
> +				  int data_len)

It's a nice cleanup. I only have a small nit. This line should have been merged
with the one above it.
