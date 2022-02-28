Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A62FEC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 03:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiB1Dqb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 22:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiB1Dqa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 22:46:30 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784845F4F3
        for <linux-scsi@vger.kernel.org>; Sun, 27 Feb 2022 19:45:52 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21RN22iI030109;
        Mon, 28 Feb 2022 03:43:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=LcwBiMCkMADMzJJPEI1reoJ0TDDECfPlbi4wRuosCmI=;
 b=SSOY8JxZq5RGHVNcpwuVyXEAgvpHeZaD8FTyHx4A/aL41k+LhhhJ7zhk/pfX4UxXbAQA
 sS9HePXtqQU35GJZF+dh/yKEFxP+wOzDYHf00EP9PbKmM8ZmLCJT1RjSvsRI9tYbQk0w
 jUhoA8qibg7wgXv2ZZygdVTqeFKJPIbqGdIQkpBuieUo+lw/F9dGaWxWOfaphYoJA/QX
 lDpSVRx36FNuxLOglK70E7Whqcz/Ad8js0t33bKv1j6fskX1Ew/fwQ+KC7fuOryZlyEt
 7dfxQL3ty8xj5OZDYi0gWfJivU0DG2C+C+koPQJdGWwbDhxa73let7arTCcJLubKpeT8 bQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efamcb0p2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 03:43:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21S3bBKU157758;
        Mon, 28 Feb 2022 03:43:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3efa8bxntm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 03:43:26 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21S3hPvm165853;
        Mon, 28 Feb 2022 03:43:26 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3efa8bxnt3-2;
        Mon, 28 Feb 2022 03:43:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Chesnokov Gleb <Chesnokov.G@raidix.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] qla2xxx: Use named initializers for port_[d]state_str
Date:   Sun, 27 Feb 2022 22:43:16 -0500
Message-Id: <164601967776.4503.18277105734482155805.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <AS8PR10MB495215841EB25C16DBC0CB409D349@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
References: <AS8PR10MB495215841EB25C16DBC0CB409D349@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: PiGo_5c4KOIfAR2CT1c387JnfXIYFuaZ
X-Proofpoint-GUID: PiGo_5c4KOIfAR2CT1c387JnfXIYFuaZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 15 Feb 2022 17:13:53 +0000, Chesnokov Gleb wrote:

> Make port_state_str and port_dstate_str a little more readable and
> maintainable by using named initializers.
> 
> Also convert FCS_* macros into an enum.
> 
> 

Applied to 5.18/scsi-queue, thanks!

[1/2] qla2xxx: Use named initializers for port_[d]state_str
      https://git.kernel.org/mkp/scsi/c/6e0e85d39e52

-- 
Martin K. Petersen	Oracle Linux Engineering
