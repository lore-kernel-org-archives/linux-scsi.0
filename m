Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18054C54E4B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5861206B7
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:28:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YXwBHSy3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbgELD2s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 23:28:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40710 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbgELD2r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 23:28:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3N1U4130524;
        Tue, 12 May 2020 03:28:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=m5qrEoeVo3J6HsD0ioGFPBGzKVsrLJsPeIFoyJcaAV8=;
 b=YXwBHSy3cTHGUavYcZeM0c0oAbMSnsYCzQOXERAhc2EHCOcAhtvTAMGPCxsOeG87cyx0
 y5OxK4zuNyy+jUgsUKjhkbDUdiPtrPDPozI1lNhRtHSfPSDhPb+XBmlN5j/jVEkvR8tQ
 gEoPawV+id5ZKK40o7j5makJrhKFX7GY5kUA+MYAq1mmx0yTkfNOMfZOiBtin9xDp2Cr
 aaU69IqPuh2Dh+/xKRAQUtxSu8srmucL2KJLdRA9+Sk1/oAhksC7KmrAk1XTUZmIdIuB
 wqOsaraWaSRP3ylvSF7/iV+24Oo7QxLOYm9QMfalRWA6yZJ9oS78VafRD2AshA4DW93K vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30x3gsggnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 03:28:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3NdpR074826;
        Tue, 12 May 2020 03:28:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30x63nx9xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 03:28:44 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04C3ShIS018967;
        Tue, 12 May 2020 03:28:43 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 May 2020 20:28:42 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_debug: fix an error handling bug in sdeb_zbc_model_str()
Date:   Mon, 11 May 2020 23:28:29 -0400
Message-Id: <158925392375.17325.5928930344403606433.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509100408.GA5555@mwanda>
References: <20200509100408.GA5555@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1015 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120029
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 9 May 2020 13:04:08 +0300, Dan Carpenter wrote:

> This test is checking the wrong variable.  It should be testing "ret".
> The "sdeb_zbc_model" variable is an enum (unsigned in this situation)
> and we never assign negative values to it.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: scsi_debug: Fix an error handling bug in sdeb_zbc_model_str()
      https://git.kernel.org/mkp/scsi/c/47742bde281b

-- 
Martin K. Petersen	Oracle Linux Engineering
