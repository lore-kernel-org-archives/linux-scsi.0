Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C0A5C64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EEF3216C4
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:33:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZMdkUT4e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgLAFdW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 00:33:22 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47808 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgLAFdW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 00:33:22 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B15Pv6G187564;
        Tue, 1 Dec 2020 05:32:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=u/74Y6/LEJEDqI3LGT/nDi4hUN+vgcUNJDMaKHlk3kk=;
 b=ZMdkUT4eHvmK7Y6kWM5iDt9pDnNC4vuoRa3yx5+hPfhPHpdcsRMzhNuWf0YRWiPH2k9g
 tvaPWmoQVZ2fAMVls0Tw3BiwRDewH7ExYYBGbCO2JdALEW5GDnd/6EX67O0hpDIBTfO1
 l87K5+MkXBHvY94KbOK2n+UmsPuBbQsuO7KXjlYj/gvG4RScn+Kltrpj6Z6VBAHebkrI
 JY55dnQvf4+bS8d8l8EtavBuH4dAG/kwQ9hd1YxbxXE8nflnqIdmHsdpHDTlmaY+I6zP
 0DmCgfs8IyFsU7koHo3prTNCTvzRXTeyAzIMTBPLs7TAtGHUgrdhhszezrEmq9AX8nYH pA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 353dyqgny7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 05:32:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B15QErQ047782;
        Tue, 1 Dec 2020 05:32:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3540arphgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 05:32:35 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B15WUhG030619;
        Tue, 1 Dec 2020 05:32:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 21:32:28 -0800
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] SCSI: bnx2i: requires MMU
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtyygkgt.fsf@ca-mkp.ca.oracle.com>
References: <20201129070916.3919-1-rdunlap@infradead.org>
Date:   Tue, 01 Dec 2020 00:32:26 -0500
In-Reply-To: <20201129070916.3919-1-rdunlap@infradead.org> (Randy Dunlap's
        message of "Sat, 28 Nov 2020 23:09:16 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=977 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010036
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=1 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010036
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Randy,

> The SCSI_BNX2_ISCSI kconfig symbol selects CNIC and CNIC selects UIO,
> which depends on MMU.  Since 'select' does not follow dependency
> chains, add the same MMU dependency to SCSI_BNX2_ISCSI.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
