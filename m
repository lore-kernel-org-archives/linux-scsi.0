Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC541C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 04:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbiGNEXs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 00:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbiGNEXJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 00:23:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F3A27FEE;
        Wed, 13 Jul 2022 21:22:45 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E3mtjB020536;
        Thu, 14 Jul 2022 04:22:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=qqQoPJEn9o0XaXmiw3FJvD7o2uy7D2pyuKTKKsv4/gM=;
 b=xsba4z+RPMfHmkE+LQ4bZwL470OJsXfFe01jpJSaSKxCmtigT5lh3he77MtjrEl2GU6v
 gy77DVXZQb50srGJYbe2nlQ0j7og+p9nrmno3TWHObt1Rl/CmMVAROkcBbSHJ5VukN/Y
 IbQyCEAPP7a0Gq/8wyoR3mTGOQUqp0nSY0mkKCJrj+NVDio+jNMo1Pbdia1CV48Dw8ES
 ylM8vEzrf3D3fXdT5fhWzlZQaiPsRwdIEI3MnAi2hnWWiEVwmcMC5JLDZ7tWSM2Afj2W
 oe+RjKGxlK+uTBLc2zW1Ac6q+MsiMtGqXVOnFcWi7FXavkJ/Vohz2ZgjJFJu0aK3gdGz qA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71xrkxsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26E4ApYp040463;
        Thu, 14 Jul 2022 04:22:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h70451jq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:37 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 26E4MWBv023864;
        Thu, 14 Jul 2022 04:22:37 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h70451jnc-9;
        Thu, 14 Jul 2022 04:22:37 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-m68k@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        arnd@kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, geert@linux-m68k.org
Subject: Re: [PATCH v2 0/3] Converting m68k WD33C93 drivers to DMA API
Date:   Thu, 14 Jul 2022 00:22:29 -0400
Message-Id: <165777182483.7272.12553166750416691884.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630033302.3183-1-schmitzmic@gmail.com>
References: <20220630033302.3183-1-schmitzmic@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: R5CCJnRVyCuVajHWaoMQpmyq11k0dxNA
X-Proofpoint-ORIG-GUID: R5CCJnRVyCuVajHWaoMQpmyq11k0dxNA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 30 Jun 2022 15:32:59 +1200, Michael Schmitz wrote:

> This series was precipitated by Arnd removing CONFIG_VIRT_TO_BUS. The
> m68k WD33C93 still used virt_to_bus to convert virtual addresses to
> physical addresses suitable for the DMA engines (note m68k does not
> have an IOMMU and uses a direct mapping for DMA addresses).
> 
> Arnd suggested to use dma_map_single() to set up dma mappings instead
> of open-coding much the same in every driver dma_setup() function.
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[1/3] scsi - a3000.c: convert m68k WD33C93 drivers to DMA API
      https://git.kernel.org/mkp/scsi/c/e214806d52b8
[2/3] scsi - a2091.c: convert m68k WD33C93 drivers to DMA API
      https://git.kernel.org/mkp/scsi/c/479accbbb839
[3/3] scsi - gvp11.c: convert m68k WD33C93 drivers to DMA API
      https://git.kernel.org/mkp/scsi/c/158da6bcae7a

-- 
Martin K. Petersen	Oracle Linux Engineering
