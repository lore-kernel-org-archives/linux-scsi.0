Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85023C433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 03:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6348B2073A
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 03:42:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xc1+Ft6B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgGUDmP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 23:42:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35304 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgGUDmO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 23:42:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L3cPlO024075;
        Tue, 21 Jul 2020 03:42:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Qu5VI9IExxbULOFm3KIJVqweHPeLJFYkWNovW3KkwWE=;
 b=Xc1+Ft6BS7ycJl9oSl6oLP5hDceQbNEFgrxe7Rgdw6fbUeXuL3R5xU1yGfdpARznfWvQ
 J5CvcoLOciVSwKto9wBXSX1wj4l4HAXGbfeXkkXAuksuC4uPSvVcis1vwpnw5qsj5cxf
 MsY/tN5+DdM+wyKIl18D57Z9ILl3WWiE+YhGeLIfLDkEWOV4gS+2nrtVTI8qV9GEjUaO
 ljH9lb9TQsF1iVM5q4oHv2MMzoPh/3w7kWZVzQJm02W3APmtmAxXCk9hubRyhFP7SVOh
 pVXLophdW7wQg3DWFNdtJvNBmjULmte7fMQUzuej+Ifzy6xqncOZqcUnrVJGT1OAbceV 0w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32brgraf1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Jul 2020 03:42:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L3fr2F016770;
        Tue, 21 Jul 2020 03:42:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32dnafpspg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 03:42:12 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06L3gBSR015487;
        Tue, 21 Jul 2020 03:42:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 20:42:10 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] scsi: sd_zbc: don't check max zone append sectors for max hw sectors
Date:   Mon, 20 Jul 2020 23:42:06 -0400
Message-Id: <159530290480.22526.1721810110518997496.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716091606.38316-1-johannes.thumshirn@wdc.com>
References: <20200716091606.38316-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=953 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1015 mlxlogscore=977
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210023
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 16 Jul 2020 18:16:06 +0900, Johannes Thumshirn wrote:

> Don't check for the maximum zone append sectors to be not bigger than the
> maximum hardware sectors in sd, as the block layer is already enforcing
> this limit when setting the max zone append sectors.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: sd_zbc: Don't limit max_zone_append sectors to max_hw_sectors
      https://git.kernel.org/mkp/scsi/c/eb3e9de0c932

-- 
Martin K. Petersen	Oracle Linux Engineering
