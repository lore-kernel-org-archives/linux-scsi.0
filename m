Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5F1C10DCE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 22:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8DA62253D
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 22:53:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DmkyRt8+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgCJWxl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 18:53:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46248 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgCJWxl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 18:53:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02AMqYjg067920;
        Tue, 10 Mar 2020 22:53:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=tDtPSacGNCm3nntw2r8/WEQTxeJG6V6vEyDZIdTjMC4=;
 b=DmkyRt8+ZwJb+qLOo6pcD03HZTDPrToZvfGrM2pm4rdyny1Qc/+bsVBk4Pdz4EW0cM79
 bSl/9W4nWg26MtyBOk0FZHw4qlHyChnv9JwJGhAn05w7YVLuQ7suQijj1rXtax0a3WDx
 QF6EG2H6ySu4UYIG3HxZ5zZ/yia2hSMbgq1xrqw85ByzEVvM3zWgEgXI84Q9j0s9r4sg
 U5TCwSDNgPeGKMmR3OqiGCKrYJl6t/JxJnDgMxAWynddGoolWAfhq7LMFGVqIwfo1cv6
 E1CW+dUd1QuzyU89l0JtKP9q0b/iB7cXld70F2jKdWLPrseWUjEMgMc5Okb/9L1vbMEP 1g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ym31ugefn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 22:53:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02AMrOYC050605;
        Tue, 10 Mar 2020 22:53:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2yp8qr355g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 22:53:24 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02AMrCuP001177;
        Tue, 10 Mar 2020 22:53:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 15:53:12 -0700
To:     Brian King <brking@linux.vnet.ibm.com>
Cc:     tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, sfr@canb.auug.org.au
Subject: Re: [PATCH] ibmvfc: Fix NULL return compiler warning
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1583159961-15903-1-git-send-email-brking@linux.vnet.ibm.com>
Date:   Tue, 10 Mar 2020 18:53:10 -0400
In-Reply-To: <1583159961-15903-1-git-send-email-brking@linux.vnet.ibm.com>
        (Brian King's message of "Mon, 2 Mar 2020 08:39:21 -0600")
Message-ID: <yq1pndju8ix.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003100135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003100135
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Brian,

> Fix up a compiler warning introduced via 54b04c99d02e

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
