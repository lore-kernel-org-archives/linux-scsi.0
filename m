Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A28CAC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82C902078E
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:13:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CV4M+oT9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgHRDNP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 23:13:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57790 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgHRDNO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 23:13:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I38RM6134878;
        Tue, 18 Aug 2020 03:12:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=5yqBFvVmP7SjhOSQr96od3VpcBjEYTPTrY/Nozi0giY=;
 b=CV4M+oT9gFZ/4cLx2nRYuV+NF5q6hCIbtSlJ8q6q3Q9ERb1DEUbhsRDdex3LFs1VynU5
 FSz5pdOSVxsicyYqPFR3xXO4Q0iueEj3p4qJbThdX+9a75M8579YCKhOPBDuAdUDAm6Y
 vltGvZFdWlSME9ssHdfc+t4CgthOpHi7xDUkyw8Cz7HR1HCPhrGtui64EtP7EEEZPyts
 zfEaIAbs1nSIHahA/801pf5uH/V5tF2jqAzu5jx5btIZvEJ5zu5avgyz5vn+r6uXzToB
 64YSHjzXNPFSMUA1tWj28j8lxC4Kk1jMRRab+Zv0o/hDrn4vTu8+DVGLHIjdev8uU3oe gg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32x74r27dx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 03:12:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I37iiN111582;
        Tue, 18 Aug 2020 03:12:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32xsm1q4xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 03:12:49 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07I3CmlQ029865;
        Tue, 18 Aug 2020 03:12:48 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 20:12:48 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, bvanassche@acm.org,
        avri.altman@wdc.com, jejb@linux.ibm.com, alim.akhtar@samsung.com,
        Stanley Chu <stanley.chu@mediatek.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-mediatek@lists.infradead.org, matthias.bgg@gmail.com,
        chaotian.jing@mediatek.com, peter.wang@mediatek.com,
        linux-arm-kernel@lists.infradead.org, cc.chou@mediatek.com,
        kuohong.wang@mediatek.com, andy.teng@mediatek.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, beanhuo@micron.com,
        linux-kernel@vger.kernel.org, chun-hung.wu@mediatek.com
Subject: Re: [PATCH v3] scsi: ufs: Fix possible infinite loop in ufshcd_hold
Date:   Mon, 17 Aug 2020 23:12:32 -0400
Message-Id: <159772029325.19587.9193434104087348194.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200809050734.18740-1-stanley.chu@mediatek.com>
References: <20200809050734.18740-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 9 Aug 2020 13:07:34 +0800, Stanley Chu wrote:

> In ufshcd_suspend(), after clk-gating is suspended and link is set
> as Hibern8 state, ufshcd_hold() is still possibly invoked before
> ufshcd_suspend() returns. For example, MediaTek's suspend vops may
> issue UIC commands which would call ufshcd_hold() during the command
> issuing flow.
> 
> Now if UFSHCD_CAP_HIBERN8_WITH_CLK_GATING capability is enabled,
> then ufshcd_hold() may enter infinite loops because there is no
> clk-ungating work scheduled or pending. In this case, ufshcd_hold()
> shall just bypass, and keep the link as Hibern8 state.

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: ufs: Fix possible infinite loop in ufshcd_hold
      https://git.kernel.org/mkp/scsi/c/93b6c5db0602

-- 
Martin K. Petersen	Oracle Linux Engineering
