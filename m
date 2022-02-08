Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD45AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 05:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347274AbiBHFc5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 00:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346978AbiBHEub (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2022 23:50:31 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88EACC0401E5
        for <linux-scsi@vger.kernel.org>; Mon,  7 Feb 2022 20:50:30 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2182qw5k011806;
        Tue, 8 Feb 2022 04:50:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=pg+cdMyFAshmUSHSmPdRjzvMYnXuluUGKUDa87tRlws=;
 b=zG+BD9qNzGHLwM7FkLzAdh+JNt355LdbxiublsnUa6o+gDYIRMjj/IhwwD0khpMlDwnO
 q6G8Ftvh/TYNj8axDmiiR+PAwKo200r2sDF8yCJjKiW1L8P2oKVYBZCrXrkD/ndSPH/D
 /5GyrFHfV5fSA0h1jM9IYqSovg430myfqOKtl8Ueh43SkqgM62MxKfFcabmWayLblcu9
 38FsgHjq3oemlNwC1Z2iE7XhHjLYaUngPMgOSIGOiL02odDRrGscOWh9cZ8sBKxzVag3
 a/hd+bEHRXcM+IeGKCqdwtdIiYjiCAIMMJrCcirzt27/PWZ+HXvrqD2pegAj+KDrmz9R og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e345sj3yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 04:50:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2184fjC4008303;
        Tue, 8 Feb 2022 04:50:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3e1ebycs5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 04:50:28 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2184nxwa033941;
        Tue, 8 Feb 2022 04:50:28 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3e1ebycs5a-2;
        Tue, 08 Feb 2022 04:50:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: Remove NVME protocol support of kernel has NVME_FC support disabled
Date:   Mon,  7 Feb 2022 23:50:25 -0500
Message-Id: <164429578052.16306.10104984807930126973.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220207180516.73052-1-jsmart2021@gmail.com>
References: <20220207180516.73052-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: ZGXoDtCkiUMxuhmSadMLyZ9JLMBxgrNZ
X-Proofpoint-ORIG-GUID: ZGXoDtCkiUMxuhmSadMLyZ9JLMBxgrNZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 7 Feb 2022 10:05:16 -0800, James Smart wrote:

> The driver is intiating NVME PRLI's to determine NVME support to devices.
> This should not be occurring if CONFIG_NVME_FC support is disabled.
> 
> Corrected by changing the default value for FC4 support. Currently it
> defaults to FCP and NVME. With change, when NVME_FC support is not enabled
> in the kernel, the default value is just SCSI.
> 
> [...]

Applied to 5.17/scsi-fixes, thanks!

[1/1] lpfc: Remove NVME protocol support of kernel has NVME_FC support disabled
      https://git.kernel.org/mkp/scsi/c/c80b27cfd93b

-- 
Martin K. Petersen	Oracle Linux Engineering
