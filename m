Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 863CCC388F7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 03:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 278022168B
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 03:07:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0bwNlWqU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgKKDHV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 22:07:21 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33198 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgKKDHV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 22:07:21 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB34EvI112024;
        Wed, 11 Nov 2020 03:07:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=pDhZtW2wBrJNAE3dqfTKIZBKxcJj6f4SqkNm3TrsrzI=;
 b=0bwNlWqUx5IqrrwcZpPxaK2nryOz9gtFIAvNWWyoHP/5iqAF3+eDsIKwtzYirjbm3Gzo
 qbyQxq8wKqA+UDhEIr6MLbxjc0GHQyGDYWL6ZNSwGxkdKClYTLGUPS5qlnIue25Dmttf
 ETYUJLsFh3pXK2qN7LUSeUuUDXJc7WfybfI/Hnb6Yd8uQrNG+NO/2QNQ5fWJVo6kfX92
 wsXUrAj3hLue+DeOqJWl9BHl3uBWMwvxMoCPbyE8YbvEE5i5gJvXInTwcbchJNGNOQyn
 E7eYDZlROunBt+vUjy+l6oJayuHyO/KNcq1yHZiqLjYwRZZwcey2Pjts8+aVzPMrSlPt PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3ay5w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 03:07:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB318sP002761;
        Wed, 11 Nov 2020 03:05:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34qgp7pwhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 03:05:13 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB3591h020607;
        Wed, 11 Nov 2020 03:05:10 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 19:05:08 -0800
To:     mwilck@suse.com
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] scsi: scsi_vpd_lun_id(): fix designator priorities
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eel0ha2c.fsf@ca-mkp.ca.oracle.com>
References: <20201029170846.14786-1-mwilck@suse.com>
Date:   Tue, 10 Nov 2020 22:05:07 -0500
In-Reply-To: <20201029170846.14786-1-mwilck@suse.com> (mwilck@suse.com's
        message of "Thu, 29 Oct 2020 18:08:45 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=3 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011110013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1011 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=3
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110013
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Martin,

> The current code would use the first descriptor, because it's longer
> than the NAA descriptor. But this is wrong, the kernel is supposed to
> prefer NAA descriptors over T10 vendor ID. Designator length should
> only be used to compare designators of the same type.
>
> This patch addresses the issue by separating designator priority and
> length.

I am concerned that we're going to break existing systems since their
/dev/disk/by-* names might change as a result of this. Thoughts?

-- 
Martin K. Petersen	Oracle Linux Engineering
