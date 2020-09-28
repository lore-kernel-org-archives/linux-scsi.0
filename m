Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D531CC2D0A8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 20:52:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84294208D5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 20:52:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qiXfWA6Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgI1UwP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 16:52:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36842 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgI1UwP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2020 16:52:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SKn84L004348;
        Mon, 28 Sep 2020 20:52:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bIfvq6V610Wu/Clpe6HNRbzaQkzEDfUrawDUj4KvF7I=;
 b=qiXfWA6ZtBhQKzVB73JeHDnMe5p0uQByxshtKbDexl5YWX1/ErKnu7zDlfrW28CG5+PH
 odevIbXVrDGMsqSEWPqUP26YGwcI7PPiO1dC7eC+xrGbOZzF8jY0vUrC/ucRxAs5wQ+U
 1KDvBGUfVdlQ0jrxZSLQZl9DPciBarCUFQqAAWLl71se5SgHSRhO1KHoZX/1cyfDMlzh
 v/Eawy2lOy1pq5mdeCWBspxgbYVmV5k7k+UDqUGLokgHh80gjC7ttDKT8rqz5S6WJSGi
 R6NG7AYfR9W6gqxv+IGaQM7GXd2gLactF7ZF3b6V13DqgfFTm4y1nK5Rnh0rR2M2iYvR dA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33sx9my91p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 20:52:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SKoO57103650;
        Mon, 28 Sep 2020 20:52:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33tfhwqucm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 20:52:11 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08SKqAAY029522;
        Mon, 28 Sep 2020 20:52:10 GMT
Received: from [10.154.166.223] (/10.154.166.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 13:52:10 -0700
Subject: Re: [PATCH 2/7] qla2xxx: Fix buffer-buffer credit extraction error
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200928055023.3950-1-njavali@marvell.com>
 <20200928055023.3950-3-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Message-ID: <ca1d6bad-f0aa-b09b-e49a-e57555a982ec@oracle.com>
Date:   Mon, 28 Sep 2020 15:52:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200928055023.3950-3-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280159
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/20 12:50 AM, Nilesh Javali wrote:
> +	if (rval == QLA_SUCCESS) {
> +		__be32 *q = (__be32 *)&ha->plogi_els_payld.fl_csp;
> +
> +		bp = (uint32_t *)ha->init_cb;
> +		cpu_to_be32_array(q, bp, sz / 4);
> +		ha->flags.plogi_template_valid = 1;
> +	} else {
> +		ql_dbg(ql_dbg_init, vha, 0x00d1,
> +		       "PLOGI ELS param read fail.\n");
> +	}

How about making this more readable as following

if (rval != QLA_SUCCESS) {
	ql_dbg(ql_dbg_ini, vha, 0x00d1,
		"PLOGI ELS parameter read failed.\n");
	return;
  }

  *q = (__be32 *)&ha->plogi_els_payld.fl_csp;
  bp = (uint32_t *)ha->init_cb;
  cpu_to_be32_array(q, bp, sz / 4);
  ha->flags.plogi_template_valid = 1;


Otherwise looks good

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                         Oracle Linux Engineering
