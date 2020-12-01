Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F93C64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9AE12084C
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:10:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GmZdzM8f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgLAFKR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 00:10:17 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58426 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgLAFKR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 00:10:17 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B14mubZ008380;
        Tue, 1 Dec 2020 05:04:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=W4tjkkVhfMuLAdQwDNTaat2ycnsRYoh0JUbRwt8n6U4=;
 b=GmZdzM8fYcpbNi9gmSDRH+CdeBWzzK1ydnM0oZ0QSTFwroJ1hN5nyCUagUnJtHjhAJgQ
 r03gzcaol6YsPwA24cDLGym1mHKNnqACu3EFSvJBtKkLqt6DaRXQy0RWjW1JALIg8Es9
 Re4SGALCHeczyhKZtm6ND/bvFt7c7HOdmI6btHfKPGFYokUQUgYBA+KfKFXKChI/fMt9
 /Z92ba0ZcoyZ8f95jy67hzhFC5VKF19Jwsj4R+5G1XTEhA+NqZsoatKHHgDow24obycO
 pnTbn5hXRAQraBDjc9TzxRtLqVRCTEGBz12VDOaQzxqMIZi2Qkx1tpuiY5P7ILt/29uI eQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 353c2arqdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 05:04:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B14pJpM051412;
        Tue, 1 Dec 2020 05:04:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3540fwatx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 05:04:33 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B154W50022156;
        Tue, 1 Dec 2020 05:04:32 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 21:04:31 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     satishkh@cisco.com, Karan Tilak Kumar <kartilak@cisco.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, arulponn@cisco.com, sebaddel@cisco.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: Change shost_printk with FNIC_FCS_DBG
Date:   Tue,  1 Dec 2020 00:04:21 -0500
Message-Id: <160636449894.25598.14793812208014212251.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120220712.16708-1-kartilak@cisco.com>
References: <20201120220712.16708-1-kartilak@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 20 Nov 2020 14:07:12 -0800, Karan Tilak Kumar wrote:

> Replacing shost_printk with FNIC_FCS_DBG so that
> these log messages are controlled by fnic_log_level
> flag in fnic_fip_handler_timer.
> 
> Bumping up version number from 47 to 49 to
> maintain same level as internal version.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: fnic: Change shost_printk() to FNIC_FCS_DBG()
      https://git.kernel.org/mkp/scsi/c/90b3a938031f

-- 
Martin K. Petersen	Oracle Linux Engineering
