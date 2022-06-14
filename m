Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03483C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jun 2022 02:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353824AbiFNCqI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 22:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353016AbiFNCpz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 22:45:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510675642D
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 19:23:33 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25E0xTvJ027234;
        Tue, 14 Jun 2022 02:23:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=Qatiz0CA5BjNIgFeTXjzxv4iEoNImHJZ/PVPsMJQEOs=;
 b=ns3AXHGJ5OE9gM8G9f4S9xS6AwkdPhQnsfu/JVLWlPS5ZXH68KjbUG/KK8Y5yU5MDv4F
 ytPk8il7dlv4+qiW/fYSE7xG+D+CSo9MbE1fg7mSZJRMnRC2Huj5Beu3CXXh+08Q6q36
 FU+x/JUnIDbx23nMjnqWf65jz+LM7SjSMkxWRJJ9RRnOux07z8B8G64Y99pQJ0R2nwpQ
 kZ23KPbUeWgHlM4y1niNn+2G9bBJNJFDH94vs3ZGNl4B7IKEhMIp9jqM/ZC6wyI9s9F/
 DDiyw74Y6fWj+ruEaZUqz8EcRCzgoDAZwWCFX9PRyva6qX8HWTbdsbMAI6oMXSwbYU5z +Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjns4jmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 02:23:07 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25E2M3Mp033547;
        Tue, 14 Jun 2022 02:23:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gphfy80hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 02:23:07 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 25E2N6Fq034641;
        Tue, 14 Jun 2022 02:23:06 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gphfy80g2-1;
        Tue, 14 Jun 2022 02:23:06 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] Fix compilation warnings with gcc12
Date:   Mon, 13 Jun 2022 22:23:00 -0400
Message-Id: <165517336591.25359.12892685078086996808.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220609022456.409087-1-damien.lemoal@opensource.wdc.com>
References: <20220609022456.409087-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: mCA2EcsH_DfJvdlZuso2Hdnw1sc3_Vvy
X-Proofpoint-ORIG-GUID: mCA2EcsH_DfJvdlZuso2Hdnw1sc3_Vvy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 9 Jun 2022 11:24:53 +0900, Damien Le Moal wrote:

> Patch 1 and 2 fix compilation warnings with gcc 12, leading to kernel
> compilation failures if CONFIG_WERROR is enabled. Patch 3 complement
> these fixes to have a consistent code with regard to sas responses.
> 
> Damien Le Moal (3):
>   scsi: libsas: introduce struct smp_disc_resp
>   scsi: libsas: introduce struct smp_rg_resp
>   scsi: libsas: introduce struct smp_rps_resp
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[1/3] scsi: libsas: introduce struct smp_disc_resp
      https://git.kernel.org/mkp/scsi/c/c3752f44604f
[2/3] scsi: libsas: introduce struct smp_rg_resp
      https://git.kernel.org/mkp/scsi/c/44f2bfe9ef08
[3/3] scsi: libsas: introduce struct smp_rps_resp
      https://git.kernel.org/mkp/scsi/c/3dafe0648ddd

-- 
Martin K. Petersen	Oracle Linux Engineering
