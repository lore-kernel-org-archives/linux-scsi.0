Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E314C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 05:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbiAYFnk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jan 2022 00:43:40 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:45318 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235474AbiAYFlH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jan 2022 00:41:07 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20P1VRwV019388;
        Tue, 25 Jan 2022 05:41:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=2NVdr37+zcx63HS62l8fb5PFSCRtjRBWuNvmVX0Ujxk=;
 b=TAhUWZNBrl2uDZAgPKKzOqn/nz7pno1fj/yGGDyj82ifW9qK8esd1KtZh+ikrHZeJtOX
 u6NZ2NQ3lRnfXQauUi2kXWdAvGOAoTLnYbGPuwWElPKYOudRKECanWNvUqoyTPcVcSW7
 R+V48I4L3zkuNQuAqG154F8PpKW1lCATH6d8zMxinbc6nljpO1WyCoBjp00YQctn3Twk
 Dvj29ZjEruLRAoNGDApT2hUyo3jE7hlgyO4Fd5pICynCqofJsUQ/AA1mY/cLlfuRztBp
 P99nUBUNSPU37V1g/80ZbeH/in22eVWgy9xV6jtgDMt1WkyVkw3seibZvqfMd7uSzYWh nQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dsy7asxqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 05:41:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20P5euJw181683;
        Tue, 25 Jan 2022 05:41:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3dr71x1sry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 05:41:03 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 20P5evOd181790;
        Tue, 25 Jan 2022 05:41:03 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3dr71x1sgc-7;
        Tue, 25 Jan 2022 05:41:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     mingzhe.zou@easystack.cn
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH] target: make sure the np under each tpg is unique
Date:   Tue, 25 Jan 2022 00:40:43 -0500
Message-Id: <164308671269.32373.14354011382688338927.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220111054742.19582-1-mingzhe.zou@easystack.cn>
References: <20220111054742.19582-1-mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: AMeu2RWt8jbb6uV7MZa_uvvL7e76ivz7
X-Proofpoint-ORIG-GUID: AMeu2RWt8jbb6uV7MZa_uvvL7e76ivz7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 11 Jan 2022 13:47:42 +0800, mingzhe.zou@easystack.cn wrote:

> From: ZouMingzhe <mingzhe.zou@easystack.cn>
> 
> iscsit_tpg_check_network_portal() has two-layer for loop, and
> should return true When a match is found. Then, the tpg loop
> will still continue after break the tpg_np loop. If this tpg_np
> is not the last, the match value will be changed.
> 
> [...]

Applied to 5.17/scsi-fixes, thanks!

[1/1] target: make sure the np under each tpg is unique
      https://git.kernel.org/mkp/scsi/c/a861790afaa8

-- 
Martin K. Petersen	Oracle Linux Engineering
