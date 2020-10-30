Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B21C4363A
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 02:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57E2720756
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 02:20:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HX2yPDki"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgJ3CU1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 22:20:27 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56370 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgJ3CU1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 22:20:27 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09U2FXQK143934;
        Fri, 30 Oct 2020 02:20:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8RV3DVUM4dxiFGT4hEb0ar6t+vieEVsI4rpYwnOrKds=;
 b=HX2yPDkitG1NjY2snzcZpTyrfMLqisYtaeUR2HnPxhwbXU6LVjkzPBbfgC80TvOyes2l
 rsjVB9+Xt0pfU9GgbQi0fOEa2nkmX/wdUY2ZLkst+ghVtQY1+8vhTQmHYAZgYT0+eURM
 ImNNiyaCUjKIyyKYHaRd5flzKfiN/kwkJoJInguyJe9AIx75ynNZ4qoj1pWuYKn5/kQs
 Z16ONbDLlypiVUfMMn8lDuWXRKGjPG7KGYLpmgPNHck46ENUm7smVvncFdVoza47NcJG
 7HVlTX70Ak6zNVjzoQf08Pc1WkF+nsEZCUmncDVpw49F//8KI4cFYICInd2RUMfsouod Hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9sb7w6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 02:20:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09U2KDDm171495;
        Fri, 30 Oct 2020 02:20:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34cx617265-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 02:20:22 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09U2KIUR003180;
        Fri, 30 Oct 2020 02:20:18 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 19:20:18 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Don Brace <don.brace@microsemi.com>,
        esc.storagedev@microsemi.com, linux-kernel@vger.kernel.org,
        takafumi@sslab.ics.keio.ac.jp
Subject: Re: [PATCH v3] scsi: hpsa: fix memory leak in hpsa_init_one
Date:   Thu, 29 Oct 2020 22:20:17 -0400
Message-Id: <160402432641.14215.8278310688594247277.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027073125.14229-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
References: <CAEYrHjmJRmcKX+F8R_wjd146FXnSHekodauG_eNQBXArE4OBeA@mail.gmail.com> <20201027073125.14229-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=739
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010300016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=756 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 27 Oct 2020 07:31:24 +0000, Keita Suzuki wrote:

> When hpsa_scsi_add_host fails, h->lastlogicals is leaked since it lacks
> free in the error handler.
> 
> Fix this by adding free when hpsa_scsi_add_host fails.

Applied to 5.10/scsi-fixes, thanks!

[1/1] scsi: hpsa: Fix memory leak in hpsa_init_one()
      https://git.kernel.org/mkp/scsi/c/af61bc1e33d2

-- 
Martin K. Petersen	Oracle Linux Engineering
