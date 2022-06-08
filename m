Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219E6CCA482
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 06:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbiFHGBk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 02:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238601AbiFHFv5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 01:51:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7E0113A11;
        Tue,  7 Jun 2022 20:34:43 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257NUv1w014268;
        Wed, 8 Jun 2022 02:28:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=UnmqXkpiTAP51sDtRl4BUGeSYwx+BbIJjn7jP9GGSSA=;
 b=cil1gp1W3a6YoNE7HWm1YZZQyC8N/J7S/LFm0XrvqvB81u8XyLtVNu8gfR0HUh2lxPy5
 JCjH7I9nbGnx9H1bR1XMGDPpnclO96silMrZpftTCf6k0S/ys2nuQfO6PQBTfk8PozDa
 CyHLer0bPO04K2iea7qXgbD92Sm8C+jDqFP/e9v7ruomzWzLfJh0XDZ2M4SUE+pXp0XG
 Tr6arrxFm+lZzi9Ln16wpOeSIHT/1VjHtH15nAgOzQPt5VbKVc5yELm4zVpMbqmTacU9
 kEujsaiqyfv76wXKA1tQMVviZljmLXFJQBfcQ6oX3D5BHKc62mUp8AJdZb0gMX4eM7SV BA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ggvxmwffa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 02:28:03 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2582ATsj037982;
        Wed, 8 Jun 2022 02:28:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu334ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 02:28:03 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2582RxlV032073;
        Wed, 8 Jun 2022 02:28:02 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu33499-4;
        Wed, 08 Jun 2022 02:28:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, damien.lemoal@opensource.wdc.com,
        Tyler Erickson <tyler.erickson@seagate.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org, muhammad.ahmad@seagate.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/3] ata,sd: Fix reading concurrent positioning ranges
Date:   Tue,  7 Jun 2022 22:27:56 -0400
Message-Id: <165465514542.8982.625569084964110654.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220602225113.10218-1-tyler.erickson@seagate.com>
References: <20220602225113.10218-1-tyler.erickson@seagate.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: qRnPzEOXv_0mWC_6WnAvzLhqJ_6rCYex
X-Proofpoint-ORIG-GUID: qRnPzEOXv_0mWC_6WnAvzLhqJ_6rCYex
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2 Jun 2022 16:51:10 -0600, Tyler Erickson wrote:

> This patch series fixes reading the concurrent positioning ranges.
> 
> The first patch fixes reading this in libata, where it was reading
> more data than a drive necessarily supports, resulting in a
> command abort.
> 
> The second patch fixes the SCSI translated data to put the VPD page
> length in the correct starting byte.
> 
> [...]

Applied to 5.19/scsi-fixes, thanks!

[3/3] scsi: sd: Fix interpretation of VPD B9h length
      https://git.kernel.org/mkp/scsi/c/f92de9d11042

-- 
Martin K. Petersen	Oracle Linux Engineering
