Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC2BC33C8C
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 05:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E5E421783
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 05:57:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S3noAXMn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbfKSFuY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 00:50:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34118 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730774AbfKSFuX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 00:50:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJ5huvb132126;
        Tue, 19 Nov 2019 05:50:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=qypDKl94mesip5g2Yd4v0FaRyXY1OqCoOiPXzwPXz0w=;
 b=S3noAXMnqQxfCTbAXElErsKykDwUkFf48rUpmvOjTBc+4713kZT1kLw/LsFwmOr4lrkV
 4PJXmrTunpbcsCZoeKPdKtANj7NevY9oO77MYP4QAx8Pe9aqjd+TQEWPq2IDdNMnjvGN
 eUjdgRIU0zrk4YlteeGHruNjp2s8vBWnf9qTaX6qyshUqDlxqNotaXQU7dVeHKRev8We
 1LGczkVy5zEDVDbo2a5VucM9E8t5hqKwo8xBDUtVJBOLuoI4nZkzIWPnxPbB1fr8QLUL
 /lk7VpQdsevOwdLdcaXRXT2FAn7UPmKptQM0sLyJgrEvNysrvDYEDzpV5kd6kgh8zKFW 9A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wa92pmjd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 05:50:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJ5hOVr013308;
        Tue, 19 Nov 2019 05:50:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wbxge8wab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 05:50:16 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAJ5oEQn008331;
        Tue, 19 Nov 2019 05:50:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 21:50:14 -0800
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v4 1/5] scsi: Adjust DBD setting in mode sense for caching mode page per LLD
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1573624824-671-1-git-send-email-cang@codeaurora.org>
        <1573624824-671-2-git-send-email-cang@codeaurora.org>
Date:   Tue, 19 Nov 2019 00:50:11 -0500
In-Reply-To: <1573624824-671-2-git-send-email-cang@codeaurora.org> (Can Guo's
        message of "Tue, 12 Nov 2019 22:00:19 -0800")
Message-ID: <yq1tv70h0to.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=795
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911190053
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=866 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911190053
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

> UFS JEDEC standards require DBD field to be set to 1 in mode sense
> command.  This patch allows LLD to define the setting of DBD if
> required.

These changes look OK to me, btw. Please make sure each patch has a
changelog which reflects how the review feedback was addressed.

-- 
Martin K. Petersen	Oracle Linux Engineering
