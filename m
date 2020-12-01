Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE38C64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85A842085B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:20:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a/XWwFwt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgLAFU2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 00:20:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56042 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgLAFU2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 00:20:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B15JYAp182626;
        Tue, 1 Dec 2020 05:19:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=iXPwDitu46Sxh4Jq3/B4YIM9dtHuwcuEvSOCi4QwxCU=;
 b=a/XWwFwtlp/0T7z+xu80NQlet8FYAl48GZDAiKNwkwsQH6fmsW+t+73EbKVgpm7kOTWb
 ysX9kaL9ScH8fBjmybjGdo0DeLQHnO1McYHJ8/aSE+QzWwqLZrA9JyNndxzNB+4nb4pS
 0tGLNIpgMjHDQ8o+xZG+HMoIyzN96Fy9Ygi68ZSvwkybXMdr8QOXI787fa/m0B3sj884
 qxHbeSDf9PN4WXB+1O73UP7XmvV1N9zJUSUkIb0Xmk6tLyNPj1F5na7PGs9bVrq7ifJV
 dUsNTHaDmqbBkFdax3dyeajtB3q71mVZW97yria4SVAM7WFti3/jWy/upJPpLm+P7f/k Vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 353dyqgmxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 05:19:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B15A3DP168498;
        Tue, 1 Dec 2020 05:19:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3540exfty5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 05:19:44 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B15Jh19023850;
        Tue, 1 Dec 2020 05:19:43 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Mon, 30 Nov 2020 21:19:27 -0800
ORGANIZATION: Oracle Corporation
MIME-Version: 1.0
Message-ID: <yq1sg8qgl2h.fsf@ca-mkp.ca.oracle.com>
Date:   Mon, 30 Nov 2020 21:19:26 -0800 (PST)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <james.smart@broadcom.com>
Cc:     linux-scsi@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] lpfc: Correct null ndlp reference on routine exit
References: <20201130181226.16675-1-james.smart@broadcom.com>
In-Reply-To: <20201130181226.16675-1-james.smart@broadcom.com> <(James>
 <Smart's> <message> <of> <"Mon> <> <30> <Nov> <2020> <10:12:26> <-0800")>
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=1 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=1 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010035
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> smatch correctly called out a logic error with accessing a pointer after
> checking it for null.
>  drivers/scsi/lpfc/lpfc_els.c:2043 lpfc_cmpl_els_plogi()
>  error: we previously assumed 'ndlp' could be null (see line 1942)
>
> Adjust the exit point to avoid the trace printf ndlp reference. A trace
> entry was already generated when the ndlp was checked for null.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
