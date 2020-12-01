Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E05C64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 04:43:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65ABD206E9
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 04:43:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FcIwGc2l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgLAEnk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 23:43:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55230 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728229AbgLAEnk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 23:43:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B14ZP8u101667;
        Tue, 1 Dec 2020 04:42:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=mWRHIlJyWznLHPBoX5SJAPxO+7J8JHTpfQ/+PEr3Ho4=;
 b=FcIwGc2lbgbrAEhRj3rJGzpgirc3heCzMoykd14V6Xm37n5uptq60oacZkdJHkAfljFA
 00X3NlhztmVdauLNRclvIZLNzgWVHz7ay7U2QW7IDYxJQqgvR3l4dYDvsNWQ6S75ReVs
 RXthP88Lr8QW6b/7WDQ7cZf+w1JIfUsXeojYZB1/cybCIlRiFCOz72MWeVXdjt3ODEG6
 VE7OUV12CDZvJPBcxpYYS8Pv7YyWbdX8VYMeejZc6ThVDi/F26sCR+n0C4U50ot4nv+M
 Nr2f5bTcSQKrk3sc39Pv7OsEAKf62sHPpXDaMKr9ur5jqbGDbY5b3CdyNtQ4JYam3jvw lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 353dyqgj4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 04:42:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B14ZIY5010286;
        Tue, 1 Dec 2020 04:42:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3540fw9v3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 04:42:51 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B14goWP006521;
        Tue, 1 Dec 2020 04:42:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 20:42:49 -0800
To:     John Garry <john.garry@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH v2 0/3] hisi_sas: A small bunch of misc patches
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1oai1dn.fsf@ca-mkp.ca.oracle.com>
References: <1606207594-196362-1-git-send-email-john.garry@huawei.com>
Date:   Mon, 30 Nov 2020 23:42:46 -0500
In-Reply-To: <1606207594-196362-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Tue, 24 Nov 2020 16:46:31 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1011 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=1 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010031
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> This series contains a small bunch of patches for the driver, including:
> - Fix-up on error paths for v3 hw driver
> - Relocate as much debugfs code as possible to v3 hw driver since
>   no other hw drivers support it
> - A small tidy-up patch

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
