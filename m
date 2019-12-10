Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07278C04E30
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 00:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1C50206E0
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 00:47:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PPeuo6b/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfLJAr0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 19:47:26 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53716 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfLJAr0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 19:47:26 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBA0iIq7071117;
        Tue, 10 Dec 2019 00:47:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=rnFHKhiM80GCoR9y0TQmY4jUyuRzZfTuSm/NGujIq+w=;
 b=PPeuo6b/kcWtBug2Ldd4xWmPUORugd2zn/RbHktdxVOkOgLKsMtpZyf5lL18T/wzcZLW
 aphmXbukWA1izc9OAgDRSMXBPBGdvCncXtWNKId30qVyqcaa/tye0kFIcTPo1v5yglJH
 F+Z1Zo0XuirX0uvJ0jnz8AZmoFYNQS1xOmAlWKVmMbMFMJPDWJxg01A8erA42vrJ6C61
 zc/eBNDMLrBqZc1bp307P+8Z5JQEz8pspnghYhNNJF7w656GQs5ysdi23VAJ5OtBOduM
 RVUMDsspxArtD09CIVXexLdrnyNBgb3biunl30/bjA9vDytaaVjvPw5XcMhjbiSg++1e 1A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wrw4myu0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 00:47:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBA0hnRI021607;
        Tue, 10 Dec 2019 00:47:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wsfv3wd3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 00:47:18 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBA0lFnQ022801;
        Tue, 10 Dec 2019 00:47:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Dec 2019 16:47:15 -0800
To:     Can Guo <cang@qti.qualcomm.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: Re: [PATCH v3 0/4]  UFS driver general fixes bundle 5
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1574751214-8321-1-git-send-email-cang@qti.qualcomm.com>
Date:   Mon, 09 Dec 2019 19:47:12 -0500
In-Reply-To: <1574751214-8321-1-git-send-email-cang@qti.qualcomm.com> (Can
        Guo's message of "Mon, 25 Nov 2019 22:53:29 -0800")
Message-ID: <yq1pngxnh0v.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=671
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912100005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=753 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912100005
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

> This bundle includes 4 general fixes for UFS driver.

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
