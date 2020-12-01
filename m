Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A018FC64E8A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BAF3206D8
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:06:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bCL7QAlv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgLAFGS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 00:06:18 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34190 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgLAFGS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 00:06:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B14nRoZ128486;
        Tue, 1 Dec 2020 05:05:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=UH/MTZHOJOk9K1NU5J4NiU3Lrba9H4GwpTcISbqpVgQ=;
 b=bCL7QAlvBtuIM5+kZB3eLMs8VBAbT/LTD8BAB+6BGUw/cHcuPRA7dXdlquLWAfVwHQJe
 gTxfMJEqhPt9lhb+QZb4eWoyGtR4FaYObourFCMNvM52RArozQHhFzzFDL0RLK1Zwwx6
 Dz+Z0DIMYeFafqLYj86XzNjm+ChHZLysL32YFnPRclQpLrM7pS40oQ681lfHuBMmlaZ8
 bZq45Yxmy5oG1/UujGJuMlsW9lQCGcYJvV3F7Gzgh14Tlx9RAAwkOwRoTpq27AcTPYRu
 xPf9HFQGiU+fz2hTC+QltkaUc4tcKf3CVwJBhaUli4IUmIL6XjRtOb6nIzVaIQeZQ3/Y Vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 353dyqgm07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 05:05:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B14o43l114749;
        Tue, 1 Dec 2020 05:05:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3540exfdsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 05:05:34 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B155YiQ018978;
        Tue, 1 Dec 2020 05:05:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Mon, 30 Nov 2020 21:04:32 -0800
MIME-Version: 1.0
Message-ID: <160636449895.25598.1467986293426617155.b4-ty@oracle.com>
Date:   Mon, 30 Nov 2020 21:04:22 -0800 (PST)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     satishkh@cisco.com, Karan Tilak Kumar <kartilak@cisco.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, arulponn@cisco.com,
        linux-kernel@vger.kernel.org, sebaddel@cisco.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: set scsi_set_resid only for underflow
References: <20201121015134.18872-1-kartilak@cisco.com>
In-Reply-To: <20201121015134.18872-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.29.2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 20 Nov 2020 17:51:34 -0800, Karan Tilak Kumar wrote:

> Fix to set scsi_set_resid() only if
> FCPIO_ICMND_CMPL_RESID_UNDER is set.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: fnic: Set scsi_set_resid() only for underflow
      https://git.kernel.org/mkp/scsi/c/74ae6d6a6805

-- 
Martin K. Petersen	Oracle Linux Engineering
