Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1306C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 03:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbhLGDtl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 22:49:41 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55726 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234400AbhLGDtl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 22:49:41 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5QxT007515;
        Tue, 7 Dec 2021 03:46:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=c7Wju0PrbVwiTKJqEWcp+cwFJmehCOpsD1bpIRs+jMI=;
 b=EqZkB1ipBGRq2Mtvq/yYxIUQge0Ev9X7XYCJhebKQJZERCseONyEVG5C556Yr/SbBSNN
 pBK3v/9srQaa3i24Bs+ohCYviGPTZl0YKNnyeelaf3/Muee10y0iTYmnoi2kVBXBVJER
 Y3r2goQiY40a650OfVEc3hfDaXaPXkYNiOoVkdNg0wVK/40DdmMRF9um3YFXnrxDpFf4
 RV+aSlQMPMZU2MLfE+/fOFpb6bzHLL+EZlpTSS9K7np6aAZPTjdOVLucUtYKLDSYhvv1
 DVO8Sf4iEdFBB+Xt6H7OJ0OAJyJm9fiZjb2REf0TzH2Bl/hZFJ6PyISzdU/6h477cV+d zQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csd2ybx8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 03:46:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B73fCn7086707;
        Tue, 7 Dec 2021 03:46:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3csc4sq0fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 03:46:08 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1B73k80u096868;
        Tue, 7 Dec 2021 03:46:08 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3csc4sq0fa-1;
        Tue, 07 Dec 2021 03:46:08 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, damien.lemoal@opensource.wdc.com
Subject: Re: [PATCH v3 1/2] scsi: sd_zbc: Simplify zone full condition check
Date:   Mon,  6 Dec 2021 22:46:07 -0500
Message-Id: <163884871675.22039.1281107040123359835.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211201142821.64650-1-Niklas.Cassel@wdc.com>
References: <20211201142821.64650-1-Niklas.Cassel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: oiGf-Q7FtEyLutXZo40TMOw0Yk2OHznv
X-Proofpoint-ORIG-GUID: oiGf-Q7FtEyLutXZo40TMOw0Yk2OHznv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 1 Dec 2021 14:28:30 +0000, Niklas Cassel wrote:

> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> According to the ZBC (and ZAC) specification, a zone that has Zone Type set
> to Conventional, must also have its Zone Condition set to
> "Not Write Pointer".
> 
> Therefore, a conventional zone will never have Zone Condition set to
> "Full", which means that we can omit the non-conventional prerequisite from
> the zone full condition check.
> 
> [...]

Applied to 5.17/scsi-queue, thanks!

[1/2] scsi: sd_zbc: Simplify zone full condition check
      https://git.kernel.org/mkp/scsi/c/13202ebf5f33
[2/2] scsi: sd_zbc: Clean up sd_zbc_parse_report() setting of wp
      https://git.kernel.org/mkp/scsi/c/bf3f120fd61c

-- 
Martin K. Petersen	Oracle Linux Engineering
