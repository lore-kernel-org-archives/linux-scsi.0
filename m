Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC74C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 02:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbiBACDl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 21:03:41 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:59942 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232404AbiBACD3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Jan 2022 21:03:29 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VMZ5tE008734;
        Tue, 1 Feb 2022 02:03:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=K+C2yKEzGI53F5KoRxVBDAIX5gSVsenjuFSfnGFWE7s=;
 b=U78yEQU63q6WtwexyPYdlLc/Py11FKoZV9x2NCvKowQtJ2sjtTXFe9qOqr1j76ApA4V1
 2GiqsYHC/pKdvV1a56vAURNdDaNE3jEzTQdzOI6Br+Ncph64yJBc7cATOT8ryGTmIw04
 GILv3cRo9QhUDURh3BaN90dONRQfrZsKihsoUTYPq8ITNSImTwtvuAz+T7++pdfQpk0K
 oDraegRXXI2YD2McOZ0cug4dmYDttu6oM0QJQIvdsjy8PrXztR/2FyVSq7/qbLFkbBwH
 0tQwwsNEQVIb+uc9nFbyh1VPVTry3v4R5ZNvYYUJ4ZasaRuVQapgOcQgUAO0DPG5ZxYm 8A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxnk2gs7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 02:03:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2111tJJh078942;
        Tue, 1 Feb 2022 02:03:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3dvtpy6w4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 02:03:25 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21123EPb096319;
        Tue, 1 Feb 2022 02:03:25 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3dvtpy6w3w-1;
        Tue, 01 Feb 2022 02:03:24 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Ajish Koshy <Ajish.Koshy@microchip.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH] scsi: pm80xx: Fix double completion for SATA devices
Date:   Mon, 31 Jan 2022 21:03:19 -0500
Message-Id: <164368097300.23346.2953285264590332271.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220124082255.86223-1-Ajish.Koshy@microchip.com>
References: <20220124082255.86223-1-Ajish.Koshy@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: kfMMIgg2ELINBSMaC1rADqU3VO9BhYB3
X-Proofpoint-ORIG-GUID: kfMMIgg2ELINBSMaC1rADqU3VO9BhYB3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 24 Jan 2022 13:52:55 +0530, Ajish Koshy wrote:

> For SATA devices, correct the double
> completion issue.
> 
> Current code handles completions for sata
> devices in  mpi_sata_completion() and
> mpi_sata_event().
> 
> [...]

Applied to 5.17/scsi-fixes, thanks!

[1/1] scsi: pm80xx: Fix double completion for SATA devices
      https://git.kernel.org/mkp/scsi/c/c26b85ea1636

-- 
Martin K. Petersen	Oracle Linux Engineering
