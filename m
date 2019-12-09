Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EBEAC43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 23:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D58B9206D5
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 23:36:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dzICqf1+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfLIXgu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 18:36:50 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40396 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfLIXgu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 18:36:50 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB9NYp6V007385;
        Mon, 9 Dec 2019 23:36:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=FUn4+wZ8MwQoBN3dQA79Zd6mGKRVxIG1T9ICxuIa8wg=;
 b=dzICqf1+DGGr8iku4xHjNIFUmgfBNwjxvu8gqbh/CIJpciKWsNQQOVDYU39soEvIObBr
 HZCAl4bPkt+ZfIWklDjpHVfiyCtyS7uvwb2id8W+9KJjgWfSUm3M6TM8Rk3dw+09PEJ7
 cgHUYhaL/FXIZfXjClOlQVsfpOZaBr4yKwQapGoQxaRYuwuF1dbVaiY7/NI2XHQUtsXG
 FJkMVoC+RccMAgPLFaRro0wG8/2E++7WqZ7HonEc9uMG4cOzm4A38LlVIpsGCJ6XPSGQ
 xEHksgGArvQnRnZGKzj9LXgVKyqJSN6p3KWp10aUFtYmnEKc1YQP8MG2uxAZ6/E+1B8v CA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wr4qraqcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Dec 2019 23:36:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB9NTBVv186443;
        Mon, 9 Dec 2019 23:36:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2wsru82q6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Dec 2019 23:36:47 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB9NakGg019362;
        Mon, 9 Dec 2019 23:36:46 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Dec 2019 15:36:46 -0800
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH v3 00/13] scsi: qla2xxx: Bug fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
Date:   Mon, 09 Dec 2019 18:36:44 -0500
In-Reply-To: <20191125165702.1013-1-r.bolshakov@yadro.com> (Roman Bolshakov's
        message of "Mon, 25 Nov 2019 19:56:49 +0300")
Message-ID: <yq1blshqdf7.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=736
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912090185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=801 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912090186
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Roman,

> The patch series contains fixes for qla2xxx and solves two visible
> issues:
>   - Target port in N2N topology doesn't perform login if it has higher
>     WWPN than initiator
>   - ABORT TASK TMF leads to crash if it's received shortly after ACL of
>     an initiator is deleted and there's active I/O from the initiator

I was concerned about the churn in this series but the actual code
changes are mostly simple and to the point.

Applied to 5.5/scsi-fixes with a couple of checkpatch tweaks. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
