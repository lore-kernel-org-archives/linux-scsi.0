Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 450A9C4363C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7819208C7
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="biVW6ZTL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgJGDsp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:48:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38714 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727277AbgJGDsc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:48:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973jQdR167215;
        Wed, 7 Oct 2020 03:48:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xe9Ot11OxmnX6dtBoATbV349RbXWBMkQeGzq5/9ILsA=;
 b=biVW6ZTLOY/ulS/+jj9IqYfUVioa6KHzS34MNVuyGmlPY1HJyqLDY3v6RS0AVBEO/f5k
 FE3nYgy9OASSonYuqYPu1CU+qVI6lCTP21DlQbdN2+FPoTe8N6FKb6zoMk2nTvtJrIhX
 GatEJknGyHEXMS+LRvEGE2vckYhK3jgGv0wariUc23Np5/FUzoz838cuNdUiuwHQyyNo
 49nnSpRGZgG9jEEy9LjJ2nOnaTJzGtgRQK0VC6iYMVX6oSum4vB605g9TXaXWAzMMU86
 emtSrR1EIEyBaoTm+k84jGyfPKvCrPfUml1DyzOA+xsO/Ij+Dwo1iV08CIycwQaxXlYZ Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33xhxmydc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 03:48:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973ipHD194572;
        Wed, 7 Oct 2020 03:48:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3410jy2s31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 03:48:16 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0973mFAL002137;
        Wed, 7 Oct 2020 03:48:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 20:48:15 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, John Garry <john.garry@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxarm@huawei.com
Subject: Re: [PATCH 0/7] hisi_sas: Add runtime PM support for v3 hw
Date:   Tue,  6 Oct 2020 23:47:54 -0400
Message-Id: <160204240582.16940.11605895826280013600.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1601649038-25534-1-git-send-email-john.garry@huawei.com>
References: <1601649038-25534-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2 Oct 2020 22:30:31 +0800, John Garry wrote:

> This series adds runtime PM support for v3 hw. Consists of:
> - Switch to new PM suspend and resume framework
> - Add links to devices to ensure host cannot be suspended while devices
>   are not
> - Filter out phy events during suspend to avoid deadlock
> - Add controller RPM support
> - And some more minor misc related changes
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/7] scsi: hisi_sas: Use hisi_hba->cq_nvecs for calling calling synchronize_irq()
      https://git.kernel.org/mkp/scsi/c/7f054da7738a
[2/7] scsi: hisi_sas: Switch to new framework to support suspend and resume
      https://git.kernel.org/mkp/scsi/c/6c459ea1542b
[3/7] scsi: hisi_sas: Add controller runtime PM support for v3 hw
      https://git.kernel.org/mkp/scsi/c/65ff4aef7e9b
[4/7] scsi: hisi_sas: Add check for methods _PS0 and _PR0
      https://git.kernel.org/mkp/scsi/c/e06596d5000c
[5/7] scsi: hisi_sas: Add device link between SCSI devices and hisi_hba
      https://git.kernel.org/mkp/scsi/c/16fd4a7c5917
[6/7] scsi: hisi_sas: Filter out new PHY up events during suspend
      https://git.kernel.org/mkp/scsi/c/b14a37e011d8
[7/7] scsi: hisi_sas: Recover PHY state according to the status before reset
      https://git.kernel.org/mkp/scsi/c/69f4ec1edb13

-- 
Martin K. Petersen	Oracle Linux Engineering
