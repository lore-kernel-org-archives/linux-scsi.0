Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32195CA90AF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 16:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11BBA20730
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 16:45:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pnioNyNT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgELQpJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 12:45:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43974 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgELQpJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2020 12:45:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CGhFV9072388;
        Tue, 12 May 2020 16:45:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=EjXkCkc4I6jgHhXA1bjQBazGNbrrCmBVL/M3fVIs4dE=;
 b=pnioNyNT3yKXvBZojKV8ywZnKCs2/mregFWwLTy6ggGSGg3vZioj0YajYf0aWHdj9LYB
 IlClbsWQhJ8lojgS5vqoeKCtA3Qa5t0YkeG8I8lpVJPbjXGX0Ih9fdBiDritJYBFERpG
 YBp7izqITfqjYPrBd4Gyi2Rdk4etlw1Yy2q0EL8OOnRiLIgw4kvcI408374Cpqn5+dko
 ImH4BeyOEbIuMx1iJmSix84ryoDb3LbYwuIP6urYnfXLMDRXcFxidZpxK81YAPUByGSf
 hfppRi1sY8PRJtqH6YbGJNCrG9LCQrhUAvO5YWSzn1VxMwGnRwrI8Wa2bGtkaCehWlrN aA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30x3mbv4wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 16:45:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CGga4c158966;
        Tue, 12 May 2020 16:45:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30xbgk91x1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 16:45:00 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04CGiwhl021957;
        Tue, 12 May 2020 16:44:59 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 09:44:58 -0700
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v5 00/15] Fix qla2xxx endianness annotations
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200511200946.7675-1-bvanassche@acm.org>
Date:   Tue, 12 May 2020 12:44:56 -0400
In-Reply-To: <20200511200946.7675-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Mon, 11 May 2020 13:09:31 -0700")
Message-ID: <yq1mu6d14s7.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 impostorscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120127
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Bart!

> This patch series fixes the endianness annotations in the qla2xxx
> driver.  Please consider this patch series for the v5.8 kernel.

I in reading v5 I noticed that Arun's reviews were missing from patches
1, (2), 3, 5, 7, and 9. Not sure if other v4 review tags were missed.
Please verify when you repost.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
