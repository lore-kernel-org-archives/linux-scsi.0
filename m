Return-Path: <SRS0=uqxd=XG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60CE4C49ED7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 01:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 330E721928
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 01:21:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aBy9W5KK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfIKBVr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Sep 2019 21:21:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35626 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfIKBVr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Sep 2019 21:21:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8B1Jddo084795;
        Wed, 11 Sep 2019 01:21:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=oH4QM0Qw1pFC5GvWP3vJI4d4LjD3X3mGjFrvjo3uis4=;
 b=aBy9W5KKmL+G/N7nKwBRq3XC6ilUt/CUIYM6OvCK41DGAwCEYIRY0mgbeGT6bEQqEMyV
 7HQh1dFxW+SNsBw+Sxgi/BlcODpf+QaYtWlWUCZ68em0ZCv7qI6uMaDzFbj2Kmz7zCeM
 CjtIr8lRtsuFhGkZ0mp6qe9i2f6YeyNwTvLa20LDjgRw6V6dI+VIVAR2m9bdyEr3U8Li
 D8shO+pp6hAGHmzFk/9MKT26ub5d3zoRABrJvcfik0tY5LgaI9q4ttSVgQuF6CsLwv2s
 B8rhrez/zvkFRJ842Us+xplg2SmzmnDljJW+qyqBl5zqN60jLfjvDb2OyH50yk73CLI0 Mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2uw1jy6s1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Sep 2019 01:21:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8B1IpCm168932;
        Wed, 11 Sep 2019 01:21:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2uxd6dbc9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Sep 2019 01:21:37 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8B1LavZ032321;
        Wed, 11 Sep 2019 01:21:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Sep 2019 18:21:36 -0700
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <hare@suse.de>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <yi.zhang@huawei.com>
Subject: Re: [PATCH] scsi: fcoe: fix null-ptr-deref Read in fc_release_transport
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1566279789-58207-1-git-send-email-zhengbin13@huawei.com>
Date:   Tue, 10 Sep 2019 21:21:34 -0400
In-Reply-To: <1566279789-58207-1-git-send-email-zhengbin13@huawei.com>
        (zhengbin's message of "Tue, 20 Aug 2019 13:43:09 +0800")
Message-ID: <yq1ftl3fx0h.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=907
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909110005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=990 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909110005
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


zhengbin,

> In fcoe_if_init, if fc_attach_transport(&fcoe_vport_fc_functions)
> fails, need to free the previously memory and return fail,
> otherwise will trigger null-ptr-deref Read in fc_release_transport.

Applied to 5.4/scsi-queue. Thank you.

-- 
Martin K. Petersen	Oracle Linux Engineering
