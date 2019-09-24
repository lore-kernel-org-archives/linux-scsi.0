Return-Path: <SRS0=Cwhq=XT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF8DC432C1
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 02:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EC5020673
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 02:32:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qdKmzZOc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388759AbfIXCco (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Sep 2019 22:32:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37552 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728089AbfIXCcn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2019 22:32:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O2TKqM067684;
        Tue, 24 Sep 2019 02:32:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=3p8PT/4DdGrSyR3ARdnCcVuRR4tJiOi2d40JrsPX0es=;
 b=qdKmzZOcYX+EZHj2yd3EQhWnrOUPpAAOnS4X6LGEBsQe64FdISs8J8K5q9z+7eSlJJ37
 cA4i/OGAL+AaZNDAn4xWNL7zitXzxZeYGmewfHeumeCgA8oj3xtuTXw5pTpSggKo4sIL
 HKxsavSvEVW7S0BdttjwpfRelOV7nFNh/LezLtBhzwKLlX4EcpxUUHgNw+QCkdQBN24k
 gHzyisCofghsAdxlr9DBJE4pLcYLriswe1uvxB8+1+p4d+lkmbL2FkHx75BjY8TLR/LD
 Vz/NquFJBoKCW43huacuXq0r7JlkSekwwaZUQSmHT2C2EorBEa7G/fVDP63WG3HksB9q CA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2v5btptvpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 02:32:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O2STPi125015;
        Tue, 24 Sep 2019 02:30:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2v6yvqnckt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 02:30:38 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8O2UZAp015797;
        Tue, 24 Sep 2019 02:30:35 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Sep 2019 19:30:35 -0700
To:     Austin Kim <austindh.kim@gmail.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        QLogic-Storage-Upstream@cavium.com
Subject: Re: [PATCH] scsi: qedf: Remove always false 'tmp_prio < 0' statement
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190919075548.GA112801@LGEARND20B15>
Date:   Mon, 23 Sep 2019 22:30:33 -0400
In-Reply-To: <20190919075548.GA112801@LGEARND20B15> (Austin Kim's message of
        "Thu, 19 Sep 2019 16:55:48 +0900")
Message-ID: <yq1o8za4e9i.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909240024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909240024
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Austin,

> Since tmp_prio is declared as u8, the following statement is always false.
>    tmp_prio < 0
>
> So remove 'always false' statement.

Applied to 5.4/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
