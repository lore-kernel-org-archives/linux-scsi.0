Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF163C2BB1D
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 03:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDA6820759
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 03:18:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QyXVk2aw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387714AbgCLDSU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 23:18:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44138 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387453AbgCLDSU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 23:18:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3BaNS146920;
        Thu, 12 Mar 2020 03:15:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=p5IfXvS/P3WbGDOKAj9bk3Y/A1Ox++n5S6ue07kJMls=;
 b=QyXVk2awPv3hozaHbeLZr70IpymUcwrhVelT8UtyH9mEtaMiqHfUd7GN1IAzIhxp0mUB
 D3Aqstj/hFWWiwn2w9k9DuRTAZ8tO522UfAHb8Om7pmPtuUVDIDC2xraoaJQsVQKBzOa
 FctYSB3IZ5gh5OkuPBzREjbPb+DGPMOvQI2B+A77CgvHXW3NyXdI9BnxGiga9c75VefR
 ZdPbpk9PGrTsQT6epMizRAqRy0u8XDGUfvocLwlLoxnmbWKkmozZd5TR9X1evTqAVZIw
 MWPEbIZDyJhPuteuw3va7q/pbmabxGU2nOOXpuA/07NjTHwn36Ki8mCJnbMrtzXTYPSq Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ym31uq4vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:15:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C37HIu011734;
        Thu, 12 Mar 2020 03:15:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2yp8p5npfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:15:36 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02C3FY43031972;
        Thu, 12 Mar 2020 03:15:35 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 20:15:34 -0700
To:     Ryan Attard <ryanattard@ryanattard.info>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        axboe@kernel.dk, dgilbert@interlog.com, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com
Subject: Re: [PATCH 1/1 RESEND] Allow non-root users to perform ZBC commands.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200226170518.92963-1-ryanattard@ryanattard.info>
        <20200226170518.92963-2-ryanattard@ryanattard.info>
Date:   Wed, 11 Mar 2020 23:15:31 -0400
In-Reply-To: <20200226170518.92963-2-ryanattard@ryanattard.info> (Ryan
        Attard's message of "Wed, 26 Feb 2020 11:05:19 -0600")
Message-ID: <yq1blp29sbw.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=932
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120014
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ryan,

> Allow users with read permissions to issue REPORT ZONE commands and
> users with write permissions to manage zones on block devices
> supporting the ZBC specification.

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
