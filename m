Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_TONAME_EQ_TOLOCAL_SHORT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA31BC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 00:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D50D20828
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 00:54:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TOlR71rG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfLJAyq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 19:54:46 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59176 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfLJAyp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 19:54:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBA0iAIS071063;
        Tue, 10 Dec 2019 00:54:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=e3cl4wKiP2m9gerRTdI/Zvi5abkL8narEviaojDWOEk=;
 b=TOlR71rGnXfRnjL5g+SYlAWR9ROiIZNn7pBEj7RUmsTdhpSmX3v6b7u7OgDm3gtbZb+7
 2FD7yOE3xtY0wIDr35dFFkfRmVrWjYh83xfrcaBRvbn4ZO/M5Hku3HdvvBmZShO27ng+
 AzCysEHBhz6NhllPC5NKyCg3HsUH9LvrMfhB4NKNs0CNJOttTo15VElUGOXyHErU7JiB
 A1AT95ziN2MxVZDgz37yRYShIQhl2ChCEugidRuwS9fWhcFQlsmBsBiVwjtEQigOizGy
 /T4rIGvvwq8Rj+qmBDzpvcjOs4LRotHoNr0Te3cY8Upgz5wZdCI3eMJbpLqw5GD8u3P3 CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wrw4myuhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 00:54:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBA0sDoo073282;
        Tue, 10 Dec 2019 00:54:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2wsv8av5na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 00:54:21 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBA0sGaO017826;
        Tue, 10 Dec 2019 00:54:16 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Dec 2019 16:54:15 -0800
To:     sheebab <sheebab@cadence.com>
Cc:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <beanhuo@micron.com>, <yuehaibing@huawei.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <vigneshr@ti.com>, <rafalc@cadence.com>, <mparab@cadence.com>
Subject: Re: [PATCH v2] scsi: ufs: Update L4 attributes on manual hibern8 exit in  Cadence UFS.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1575606303-10917-1-git-send-email-sheebab@cadence.com>
Date:   Mon, 09 Dec 2019 19:54:12 -0500
In-Reply-To: <1575606303-10917-1-git-send-email-sheebab@cadence.com>
        (sheebab@cadence.com's message of "Fri, 6 Dec 2019 05:25:03 +0100")
Message-ID: <yq1d0cxngp7.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912100006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912100005
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


sheebab,

> Backup L4 attributes duirng manual hibern8 entry and restore the L4
> attributes on manual hibern8 exit as per JESD220C.
>
> Signed-off-by: Sheeba B <sheebab@cadence.com>

Please make sure your Author: matches your Signed-off-by:.

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
