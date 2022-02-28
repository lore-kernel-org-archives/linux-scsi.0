Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F2AC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 03:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiB1Dqb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 22:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiB1Dqa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 22:46:30 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734FD5F4F2
        for <linux-scsi@vger.kernel.org>; Sun, 27 Feb 2022 19:45:52 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21RMwaGR029567;
        Mon, 28 Feb 2022 03:43:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=F0oQCp93XdUBACxDrDR9KXOSdz1LxzZqbtbOOZwNQnc=;
 b=tStAT1tFrrjL/l6Lsi6ux9YCa7Y092HrB/AOLlrn/Fe+UwyUpbIm15ogZN6DklGs8Lrf
 WuwFgVj65/lZ5iBcjsKK1dWzn6ToKtyu/1U3H4MgDM5FYyRom3TCroCbJX+kgs4g+12Z
 IZtGinVcKgl7zhbGLZ7scZxQEREnrXWEadmGHTcwkAurEdFnZiV8GqHFslE38F5uPvT4
 A1zTDqLqrBFW4XnmMCrenz0QvmzYE/WUu1wKV2NlWWkyvFWk5CEql51coYsVEeJfjh0o
 pqzXb6I1UxTJBzFSWMm/P1Esg8MT8O7MD29KmbcxUvZyw8ZOrZxZsVDsRFOhgl8tSQ9v SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efbttayer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 03:43:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21S3b9sW157657;
        Mon, 28 Feb 2022 03:43:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3efa8bxntu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 03:43:27 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21S3hPvo165853;
        Mon, 28 Feb 2022 03:43:26 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3efa8bxnt3-3;
        Mon, 28 Feb 2022 03:43:26 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Chesnokov Gleb <Chesnokov.G@raidix.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] qla2xxx: Use named initializers for q_dev_state
Date:   Sun, 27 Feb 2022 22:43:17 -0500
Message-Id: <164601967776.4503.7005012522837837681.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <AS8PR10MB495298515A7553C8D6D6E74D9D349@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
References: <AS8PR10MB495298515A7553C8D6D6E74D9D349@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: b2x0pvfFR4xg24Qdze8Qr5bpeuef8jqE
X-Proofpoint-ORIG-GUID: b2x0pvfFR4xg24Qdze8Qr5bpeuef8jqE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 15 Feb 2022 17:13:59 +0000, Chesnokov Gleb wrote:

> Make q_dev_state a little more readable and maintainable by using
> named initializers.
> 
> Also convert QLA8XXX_DEV_* macros into an enum and remove
> qla83xx_dev_state_to_string(), which is a duplicate of qdev_state().
> 
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[2/2] qla2xxx: Use named initializers for q_dev_state
      https://git.kernel.org/mkp/scsi/c/1f652aa0e469

-- 
Martin K. Petersen	Oracle Linux Engineering
