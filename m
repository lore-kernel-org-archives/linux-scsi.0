Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5896C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 05:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344734AbiEDFvC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 01:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiEDFvB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 01:51:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225FB29CB0
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 22:47:27 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242MCRCi030007;
        Tue, 3 May 2022 00:51:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=TgP+5FqaHsxrZg7rHg/1r5zCslDQQgLB5dspfSLRGl0=;
 b=kUjKjPT8NNXgCwUSiYupAWmYKxUP8vVvg4CO27R3n7Cud2/NzXNRU4Xp1QBrwYKKxAMg
 TndScYryzEBuCVrt+XsRyMYIIb6LuVnzR7LZxXVwWhzb+KCQ8iALf8/51/+lbh5HzaZo
 fRkudUNHUr1YshgvI94q+9h8lFt8SSYOGls1WIEoXqLlCmd9G43piX+4VJ1T/ynuLkJ5
 k5r60T6IV6CUOPtDamrfaj3GQuQ2lk+v7K2/YwA65tFaH+tJdoysvy5SA22q1cDWHby0
 s9h6958hC79s84w57ZT03PSpycoTd/W4Cao7NZ5iymoLNrWf8eWgIfiuyT1x9969VC75 sg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruq0cp5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:51:54 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2430opUs008910;
        Tue, 3 May 2022 00:51:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:51:52 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2430pljG010389;
        Tue, 3 May 2022 00:51:52 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x4g-10;
        Tue, 03 May 2022 00:51:52 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Konstantin Vyshetsky <vkon@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] scsi: ufs: Increase fDeviceInit poll frequency
Date:   Mon,  2 May 2022 20:51:20 -0400
Message-Id: <165153836358.24053.314007428580310574.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220421002429.3136933-1-bvanassche@acm.org>
References: <20220421002429.3136933-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 37qnsyCaICEDH8tOwGVUBi6wMgS84s2C
X-Proofpoint-GUID: 37qnsyCaICEDH8tOwGVUBi6wMgS84s2C
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 20 Apr 2022 17:24:29 -0700, Bart Van Assche wrote:

> From: Konstantin Vyshetsky <vkon@google.com>
> 
> UFS devices are expected to clear fDeviceInit flag in single digit
> milliseconds. Current values of 5 to 10 millisecond sleep add to
> increased latency during the initialization and resume path. This CL
> lowers the sleep range to 500 to 1000 microseconds.
> 
> [...]

Applied to 5.19/scsi-queue, thanks!

[1/1] scsi: ufs: Increase fDeviceInit poll frequency
      https://git.kernel.org/mkp/scsi/c/a4e6496fca3f

-- 
Martin K. Petersen	Oracle Linux Engineering
