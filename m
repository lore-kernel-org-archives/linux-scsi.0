Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B871C6379F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41F8922282
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:32:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bcpIPdON"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgKTDb6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:31:58 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35056 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgKTDb6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 22:31:58 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3QOHm097173;
        Fri, 20 Nov 2020 03:31:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=jZzw6NnBwJsSdZ8FeenVzB6ax163h1FH9Fc2vam9rOo=;
 b=bcpIPdONL2kv+54BfR6mSNjbhaFOG+RjIIh9akYRezA+ko5iVr0oU1GgdBRV3IHOJs5O
 QMKgZ4700HHWbrjIn/dB2ahAEcrrG0SosoRZnsSwBWIWTXVoviuGgkMoQRGkC9sB1PJv
 os5wBeOi4z44NEjXyusDiit7hX1rhjfUq9bGkO8iVGiLi6D84RCEdisGXSQg2KISAHly
 I49ePil/d5J9xUHKOJOSx9xDAMbw5x5DgOdf9RJsXDlsU2TPMdByMHfCE55xYx/fldcH
 i4zL/MZH6K4/uheAKU7qfEa5HTuPGEVrG+VIcy3BMUPcXgzagFjH65nH6WPkXMvWWzOE Hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34t76m8qxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Nov 2020 03:31:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3OfRD029248;
        Fri, 20 Nov 2020 03:31:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34ts60wh97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 03:31:51 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AK3VoOR025900;
        Fri, 20 Nov 2020 03:31:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 19:31:50 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        linux-scsi@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] scsi: core: fix -Wformat
Date:   Thu, 19 Nov 2020 22:31:43 -0500
Message-Id: <160584262848.7157.14296415602219986964.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201107081132.2629071-1-ndesaulniers@google.com>
References: <20201107081132.2629071-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 7 Nov 2020 00:11:32 -0800, Nick Desaulniers wrote:

> Clang is more aggressive about -Wformat warnings when the format flag
> specifies a type smaller than the parameter. Turns out, struct
> Scsi_Host's member can_queue is actually an int. Fixes:
> 
> [-Wformat]
> shost_rd_attr(can_queue, "%hd\n");
> ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>                           %d

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: core: Fix -Wformat for scsi_host
      https://git.kernel.org/mkp/scsi/c/883928201b00

-- 
Martin K. Petersen	Oracle Linux Engineering
