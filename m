Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B49EC352A6
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 04:55:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E914423A5B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 04:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgLHEyz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 23:54:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58780 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgLHEyz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 23:54:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B84nOD7063996;
        Tue, 8 Dec 2020 04:54:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=cxdiY7R8sWSnecVOSB9mkurqAKO1jwbskRB08x3Lxk4=;
 b=DJTvHZ0mpHF+ZoFWlLTQPzIGu43rp45SFS0mDp1tsZEnFw5yUlWfAmog0er7KfDR5cGe
 p0LoET9QA+rD/fjJ0Db2FJLbGuoJ2aCcQiz0VqbEshoTFwOePbFLvecmpjuyBa0BKRbB
 4cuZaGPyVBz1nLATLjKD/FepzHMV9NnVAcH34XCUbxV+I0AgyhhxiVXhYBzpUWvGUshY
 mXBjpbLP9gGQSZgreJ8z7zt9Lf2kbrXbrvprgja6tgy47DXdtLLA9v1NGKTFTL7o+Kn9
 HBuVJHRtvNtPPZ2VGRRN6GE7KJ+OaFo2ddV2BtZIKQ/beAQmyucnutPQSuerQjeqfxur nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35825m0suc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 04:54:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B84oS8e160951;
        Tue, 8 Dec 2020 04:52:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 358m3x7fa9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 04:52:10 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B84q9Ii025073;
        Tue, 8 Dec 2020 04:52:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 20:52:08 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     rnayak@codeaurora.org, hongwus@codeaurora.org, salyzyn@google.com,
        saravanak@google.com, asutoshd@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        ziqichen@codeaurora.org, Can Guo <cang@codeaurora.org>,
        nguyenb@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/2] Subject: [PATCH v3 0/2] Refactor ufshcd_setup_clocks() to remove param skip_ref_clk
Date:   Mon,  7 Dec 2020 23:52:00 -0500
Message-Id: <160740299785.710.6250212296871342809.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1606356063-38380-1-git-send-email-cang@codeaurora.org>
References: <1606356063-38380-1-git-send-email-cang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=952
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=964 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080029
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 25 Nov 2020 18:00:59 -0800, Can Guo wrote:

> Allow vendor drivers to decide which clock should be kept on when
> clk gating or suspend disables clocks while link is active.
> 
> Change since v2:
> - Fixed a typo in commit title
> - Changed naming always_on_while_link_active to keep_link_active
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[1/2] scsi: ufs: Refactor ufshcd_setup_clocks() to remove skip_ref_clk
      https://git.kernel.org/mkp/scsi/c/81309c247a4d
[2/2] scsi: ufs-qcom: Keep core_clk_unipro ON while link is active
      https://git.kernel.org/mkp/scsi/c/96f08cc5943c

-- 
Martin K. Petersen	Oracle Linux Engineering
