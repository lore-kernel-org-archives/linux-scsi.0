Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA18AC2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 20:13:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79E8522263
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 20:13:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fTRUI1t1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgJZUNV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 16:13:21 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58070 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgJZUNU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 16:13:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QJx9kU002361;
        Mon, 26 Oct 2020 20:13:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=iSJjVIqHD8zV7sVdSwfe1Wtw0iLXxpGMvl37bjbOvBk=;
 b=fTRUI1t1c15SbyaPGEUXKCXOdE14np03eFYfL/sV4Ov2oX8c/eNOH37AEGKG25jC5PrM
 Ky9Hdk4I6Pwig3piBzXfT6PEB+S92QPenDTDPAb0USnl3zELoon359kpHMdFbnpxfhwV
 2p1awY7/v33nBriVnQf2FJn/1gM67YBLFX27nPGOOVPrWVItjOUh1grPvI9iGEv1pLW3
 34X4BB+1YpZziQQaLVtMew+eJoQUqrCjM8nbbCEa0xn4FXvyEAaQQHS+7rVp68sooxeM
 D6Y1nHTmXAE6RIwZLeob3i/0bgyasD6baje7F7GfoYMQq7SmJOY7KYoumXubPyeBVqPd 6w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34c9sapqxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 20:13:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QK0IW3097405;
        Mon, 26 Oct 2020 20:13:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34cx1pwjhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 20:13:14 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QKDD9U025527;
        Mon, 26 Oct 2020 20:13:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 13:13:13 -0700
To:     Daniel Wagner <dwagner@suse.de>
Cc:     Nilesh Javali <njavali@marvell.com>, Arun Easi <aeasi@marvell.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v4] qla2xxx: Return EBUSY on fcport deletion
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18sbsagqx.fsf@ca-mkp.ca.oracle.com>
References: <20201014073048.36219-1-dwagner@suse.de>
Date:   Mon, 26 Oct 2020 16:13:11 -0400
In-Reply-To: <20201014073048.36219-1-dwagner@suse.de> (Daniel Wagner's message
        of "Wed, 14 Oct 2020 09:30:48 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=1 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260132
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Daniel,

> When the fcport is about to be deleted we should return EBUSY instead
> of ENODEV. Only for EBUSY the request will be requeued in a multipath
> setup.
>
> Also when the firmware has not yet started return EBUSY to avoid
> dropping the request.

Applied to 5.10/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
