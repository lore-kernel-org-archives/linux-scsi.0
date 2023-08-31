Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 212AEC83F14
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 01:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345658AbjHaBtZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 21:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345645AbjHaBtM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 21:49:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01D6CC5
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 18:49:08 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37V0EXE6012030;
        Thu, 31 Aug 2023 01:48:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=VFypUA9t0NykZe1bz4oeU01HoFufvmVO4apMf8AEJiM=;
 b=pShTlH1k1V0wbs5biq+9UDOz7kBTYj297I52GKGSKwItXzz4qx+ukq7sWjKNdCrYvvay
 56bjruZBBo7uqe5hsed7MC31xH+R9dk7RWABw2lCrHTe6SulRnOEOz9f53iztaT1aILM
 JXKSFlw+IKBU80EaVJEus6rN2Z9M+/uBz/XALi4TI2mY8qLG3TZ1tNgSIDt8n1sI9NJf
 jxgrLWDI6iFnpVg/TqSqG7EE5eFzpI9Mx+1NGTi1D/IB9RzG8G+tGVcsjPxpwshCm2IA
 ay1qME8WhpVjM7xQBtq7lBGVm8DfY/o1ly6kgLTXs5tkcmVlGrGM/96LdMNCIOMHYI06 Aw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sq9xt8sm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:48:53 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37V10WeN032801;
        Thu, 31 Aug 2023 01:48:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sr6dqtxk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:48:53 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37V1mnKl000352;
        Thu, 31 Aug 2023 01:48:52 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3sr6dqtxfw-2;
        Thu, 31 Aug 2023 01:48:52 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Don Brace <don.brace@microchip.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v2] scsi: core: Improve type safety of scsi_rescan_device()
Date:   Wed, 30 Aug 2023 21:48:29 -0400
Message-Id: <169344360110.1293881.1841454614798787637.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230822153043.4046244-1-bvanassche@acm.org>
References: <20230822153043.4046244-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-31_01,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxlogscore=972 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308310014
X-Proofpoint-ORIG-GUID: mgd6ymjbZxiHRuRiiIfaBgmMOH1CW2ET
X-Proofpoint-GUID: mgd6ymjbZxiHRuRiiIfaBgmMOH1CW2ET
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 22 Aug 2023 08:30:41 -0700, Bart Van Assche wrote:

> Most callers of scsi_rescan_device() have the scsi_device pointer readily
> available. Pass a struct scsi_device pointer to scsi_rescan_device()
> instead of a struct device pointer. This change prevents that a
> pointer to another struct device would be passed accidentally to
> scsi_rescan_device().
> 
> Remove the scsi_rescan_device() declaration from the scsi_priv.h header
> file since it duplicates the declaration in <scsi/scsi_host.h>.
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[1/1] scsi: core: Improve type safety of scsi_rescan_device()
      https://git.kernel.org/mkp/scsi/c/79519528a180

-- 
Martin K. Petersen	Oracle Linux Engineering
