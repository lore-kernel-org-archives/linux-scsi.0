Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF5EC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 04:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AE97206DF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 04:04:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gZloYcKa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgGCEEJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 00:04:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33814 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgGCEEJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 00:04:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0633wv3N096864;
        Fri, 3 Jul 2020 04:04:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=iyMM3nlF9phvfL2xAlL1dPVvLw+GV8+D1vqtYApdbiM=;
 b=gZloYcKaxNaoN7Zyw07lqmCdnsU/8keRdMfKhIMcviDIXfDaeMqQr9j15LSZUok5HoTt
 IoeQZRoTlhb2D3a95VDIgpGCI8uGZVneIq1VwlyKdht9W4H90tve/7xMAFcUVbvaR09U
 /AeOJnR73n8fCO7+EallqkcBGizG02ZlLn7y36AbTDOTft7Qr5beG+6ayDVCkLQTnVyy
 C0HOACSKc0E88HE2sUcTvZsxogfVeFk5yE3AKg1anKGffSGpsITyNHz4ocO1iWe3P2iG
 bx+jdT8sBhSlAqaXpIpJ8Gy8bovaptJNH4bW3BDzCczBDcEuHaWahqk26S7xyHCBdyAz IQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31wxrnkp4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 03 Jul 2020 04:04:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0633vuIb063561;
        Fri, 3 Jul 2020 04:04:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 31xg21ytfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jul 2020 04:04:06 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 063446Vu002604;
        Fri, 3 Jul 2020 04:04:06 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jul 2020 04:04:05 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v4 0/2] qla2xxx SAN Congestion Management (SCM) support
Date:   Fri,  3 Jul 2020 00:03:57 -0400
Message-Id: <159374899164.14731.8657061725127309547.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200630102229.29660-1-njavali@marvell.com>
References: <20200630102229.29660-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=784 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=793
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 30 Jun 2020 03:22:27 -0700, Nilesh Javali wrote:

> Martin,
> 
> Please apply the updated qla2xxx patch series implementing SAN
> Congestion Management (SCM) support to the scsi tree at your
> earliest convenience.
> 
> We will follow this up with another patchset to add SCM statistics to
> the scsi transport fc, as recommended by James.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/2] scsi: qla2xxx: Change in PUREX to handle FPIN ELS requests
      https://git.kernel.org/mkp/scsi/c/62e9dd177732
[2/2] scsi: qla2xxx: SAN congestion management implementation
      https://git.kernel.org/mkp/scsi/c/9f2475fe7406

-- 
Martin K. Petersen	Oracle Linux Engineering
