Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0340BC0044D
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 03:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F0B020754
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 03:12:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n2xdJFi9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387658AbgCLDMC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 23:12:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39320 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387453AbgCLDMC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 23:12:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3Bp2g146961;
        Thu, 12 Mar 2020 03:11:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=OYSuTOTjcPPFisULBlKET82iKgFLW3T6hyi+6amkn/g=;
 b=n2xdJFi95ly0jcbHuXT/wIozg0BWQraJIdgxNCOi1DY8qhoBp7LWFq9R8GXAk4Yyf1yd
 3KiBbk3yBCPyakxAFz81RKKyYLwQk5cFjsHqjqYrsKseiSXbLWBWEudZ43sULoVsJElW
 WZIDYBy1hrQd1Z/3bty2nbS33LqbzG7ZtT8tIQOGBUt2TDHZ0Uy0irJ2T4vaBt+hwB3o
 j/xwavaqG3bDyQxmP3iV+CSY2rTJlTPACIZY3G4oq9dZFJ/vMI5eygkf9HznEKbY7hOa
 0GYCkn/eKCHAqE/wRfsWzy/PKXmR9nVVLvSK7c9Xs1ggx9lJlUN7hTGBm6h7MxjWd3yY pA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ym31uq4j3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:11:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C38Wg8114916;
        Thu, 12 Mar 2020 03:11:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2yp8qy921m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:11:51 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02C3BoOg023419;
        Thu, 12 Mar 2020 03:11:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 20:11:49 -0700
To:     John Garry <john.garry@huawei.com>
Cc:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Luo Jiaxing <luojiaxing@huawei.com>
Subject: Re: [PATCH] scsi: hisi_sas: Use dev_err() in read_iost_itct_cache_v3_hw()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1583940144-230800-1-git-send-email-john.garry@huawei.com>
Date:   Wed, 11 Mar 2020 23:11:47 -0400
In-Reply-To: <1583940144-230800-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Wed, 11 Mar 2020 23:22:24 +0800")
Message-ID: <yq1sgie9si4.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=798
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=875 mlxscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120014
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> The print of pr_err() does not come with device information, so
> replace it with dev_err(). Also improve the grammar in the message.

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
