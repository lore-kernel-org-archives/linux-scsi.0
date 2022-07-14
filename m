Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779EDC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 04:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbiGNEXA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 00:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbiGNEWm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 00:22:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6116527B34
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 21:22:40 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E3mvrv014137;
        Thu, 14 Jul 2022 04:22:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=CVzTKmKmstGOW+Wglfg8ckmvL9TqLEqMnT6w6DVQZ68=;
 b=LaZKZ9+3dnC1GngBadjpZPpRo2veA+tYnaAkC/v44nqgqHKTfx/DEhAolTC3opiMtwIo
 n7xsmNwtogpKK0iYG45zvzMZk/nX20a93C0UP5bH/4IadvdAFJat8e72bi/PCVjxndJu
 GE8y7oqNOo6YojRFXjJz6nG3AP4nCni0T9BoJE1ThquUhJit6VTD+hKhWuEAxaQhPtTS
 cfgleukw8wAk/9KXndJhhN50UfwWLlmZ9rvK1TqTKyBuVxogae3MsCtBoovgbtZdcN2e
 VrtrZCDXUQRFt2vcnUjIVvGzGA143YGcuBoTD4NW9ydOCD/HXxBTsaCpX4mwCeTtlL5m xw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71scc289-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26E4AeHJ039875;
        Thu, 14 Jul 2022 04:22:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h70451jq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:38 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 26E4MWC1023864;
        Thu, 14 Jul 2022 04:22:38 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h70451jnc-11;
        Thu, 14 Jul 2022 04:22:38 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] mpi3mr: Use shared host tagset
Date:   Thu, 14 Jul 2022 00:22:31 -0400
Message-Id: <165777182482.7272.1724849532580738290.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628074848.5036-1-sreekanth.reddy@broadcom.com>
References: <20220628074848.5036-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: I_cqqwhCig3beZ0plCFx42nMSsUON3by
X-Proofpoint-ORIG-GUID: I_cqqwhCig3beZ0plCFx42nMSsUON3by
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 28 Jun 2022 13:18:46 +0530, Sreekanth Reddy wrote:

> - Enabled the shared host tagset,
> - Also increased the cmd_per_lun to 128.
> 
> Sreekanth Reddy (2):
>   mpi3mr: Enable shared host tagset
>   mpi3mr: Increase cmd_per_lun to 128
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[1/2] mpi3mr: Enable shared host tagset
      https://git.kernel.org/mkp/scsi/c/465191d6526a
[2/2] mpi3mr: Increase cmd_per_lun to 128
      https://git.kernel.org/mkp/scsi/c/d29ea7b71621

-- 
Martin K. Petersen	Oracle Linux Engineering
