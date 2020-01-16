Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27151C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 03:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDFC922522
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 03:50:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JNuIMv1J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbgAPDuW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jan 2020 22:50:22 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43456 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728925AbgAPDuW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2020 22:50:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G3mui9102865;
        Thu, 16 Jan 2020 03:50:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=njSDr3bJ/+EnSfFJ9jR4/8Ugjsh/dZbMCVbhPZJZtxc=;
 b=JNuIMv1JJr/8hOoQUCDBrYhhvRPl2l3gkW4DopO2N6ycuVFzyTfgcuILJI2YX5IxHRlx
 Ja24itqL8K1rEScMk7HG+bjmD22YvBroTUSCpY/dFjqcj2E81v4LFQyFcnViCdkDHeyq
 XnU7nJBKQdxl8fR+U9pEnFUlUG7OrtiPZZxsb6vS/v3sbnfaM8NCpxmTQxz/ivMWlZI+
 taJwUSVMhYxY0M7xsuPWt5UJRcWaN/GgKnj+Tr4ZiIRNeKGeh1YwlGilfiTvN6sVeDmw
 K+p8ZLOStKOp/R2cUprxw3hsNIAFrVnM8hmTGjy73S2+sqflu7nRvBE4RBOEr+Ce51m/ cA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xf73tyxdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 03:50:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G3mtRo139207;
        Thu, 16 Jan 2020 03:50:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xj1psa7uf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 03:50:13 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00G3oBFR017415;
        Thu, 16 Jan 2020 03:50:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 19:50:11 -0800
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        kernel@collabora.com
Subject: Re: [PATCH RESEND] iscsi: Don't destroy session if there are outstanding connections
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191226203148.2172200-1-krisman@collabora.com>
Date:   Wed, 15 Jan 2020 22:50:09 -0500
In-Reply-To: <20191226203148.2172200-1-krisman@collabora.com> (Gabriel Krisman
        Bertazi's message of "Thu, 26 Dec 2019 15:31:48 -0500")
Message-ID: <yq1y2u8njpq.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=979
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160029
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Gabriel,

> A faulty userspace that calls destroy_session() before destroying the
> connections can trigger the failure.  This patch prevents the issue by
> refusing to destroy the session if there are outstanding connections.

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
