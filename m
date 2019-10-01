Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC91C32792
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 02:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEED52075C
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 02:34:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FayHMLs6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbfJACeR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 22:34:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56322 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfJACeR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Sep 2019 22:34:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x912XpDq109207;
        Tue, 1 Oct 2019 02:34:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=8CMSKrVlKikAeKlcuQfuGg6O9SDv1F1EG6X+AHsfxfE=;
 b=FayHMLs6SyfC6eX7JhCskjXXJhTQR3TdmDbqA8Ju/x2i9JhZQ/XXPtFyfb4+NuLDXul1
 TGHwleTp7+GgIe07LKi3kwNDZRpOIx6qFySbHFQJHBK7ycgs1Q7UIZ4HiQJSEK+G01sQ
 H/quVXULRviiNwyzrFBIJOtsJTkeXCs9MdG3elUVcMLIh1hl2/dIFsI8NZ42qf3mMIs4
 Pc1UwsRMOOGMpU9gsWjO5FWcKlAs1bwjU/307I5qNHPY2tyQRNYWruRaJ4ON+ZpZntgC
 hTK5mTJqWZT/DvtfY50fYEdPsBB9icej9EzcwaF6+0/pD+fPQJEItu/mpuUG8NkaUk7L Qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2v9xxuju4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 02:34:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x912Xcfh195217;
        Tue, 1 Oct 2019 02:34:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vbmpxg7ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 02:34:13 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x912YCOp017975;
        Tue, 1 Oct 2019 02:34:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 19:34:12 -0700
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        suganath-prabu.subramani@broadcom.com, sathya.prakash@broadcom.com
Subject: Re: [PATCH 00/13] Enhancements w.r.t to diag buffer and few bug fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
Date:   Mon, 30 Sep 2019 22:34:10 -0400
In-Reply-To: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
        (Sreekanth Reddy's message of "Fri, 13 Sep 2019 09:04:37 -0400")
Message-ID: <yq1v9t9yz19.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=857
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=955 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010025
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> This patch series contains enhancements w.r.t to diag buffer support
> and few bug fix patches.

Applied to 5.5/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
