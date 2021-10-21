Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98101C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 832A4610CB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhJUDpo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:45:44 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46304 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230308AbhJUDpR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:17 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L345vQ029738;
        Thu, 21 Oct 2021 03:43:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=K6wG7Ep/J4JsoztJf8FxLR5R5BsaZx44NQKR0rjrexY=;
 b=Mhulv6DjcU+uIfthaiZTrY77B3+2wf7alAGNE3PmBaAYDAIFyGJiYWBpXmwUrQ8kqAtv
 2OgDexJ+H7ICrkTTwe3cvH96+xfdRLCEvoh3l7AronDB4ms7NKeY14b9oXzW+8sq+vE0
 ALAV2af+u4IQr7HMlaCy/L/JhBSpNnCjsa6Kf1dkFtnaf2MxvbeRGCcJbcsXB2fFAEJD
 YQjpiaFNgXxjgK86TJyNG43s5aErV7FjIa/P3CK7RJ6L26+8g/9+ngDM4P2T7pvYKvxv
 1QV9laoGGlXYstYIHH4eZJvgXi0SeabyLR3CVzpzAU3NSvH9STPYxeP/wxuffIS9oqPh IQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkwj3wv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:42:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3etvU078225;
        Thu, 21 Oct 2021 03:42:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshem14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:42:58 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu7q082116;
        Thu, 21 Oct 2021 03:42:58 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-4;
        Thu, 21 Oct 2021 03:42:57 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 00/88] Call scsi_done() directly
Date:   Wed, 20 Oct 2021 23:42:35 -0400
Message-Id: <163478764102.7011.2655425489517891604.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: MGtRWeq6ym4vz3mUyy_xzOA0aCITIR3U
X-Proofpoint-GUID: MGtRWeq6ym4vz3mUyy_xzOA0aCITIR3U
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 7 Oct 2021 13:27:55 -0700, Bart Van Assche wrote:

> This patch series increases IOPS by 5% on my test setup in a single-threaded
> test with queue depth 1 on top of the scsi_debug driver. Please consider this
> patch series for kernel v5.16.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[01/88] scsi: core: Use a structure member to track the SCSI command submitter
        https://git.kernel.org/mkp/scsi/c/bf23e619039d
[02/88] scsi: core: Rename scsi_mq_done() into scsi_done() and export it
        https://git.kernel.org/mkp/scsi/c/a710eacb9d13
[03/88] ata: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/58bf201dfc03
[04/88] firewire: sbp2: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/409d337e6bd6
[05/88] ib_srp: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/5f9ae9eecb15
[06/88] message: fusion: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/1ae6d167793c
[07/88] zfcp_scsi: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/68f89c50cd0c
[08/88] 3w-9xxx: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/3e6d3832dc1b
[09/88] 3w-sas: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/2adf975e899a
[10/88] 3w-xxxx: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/9dd9b96c2623
[11/88] 53c700: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/656f26ade03a
[12/88] BusLogic: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/0800a26aaa80
[13/88] NCR5380: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/117cd238adfe
[14/88] a100u2w: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/e42be9e75a02
[15/88] aacraid: Introduce aac_scsi_done()
        https://git.kernel.org/mkp/scsi/c/1dec65e32fb5
[16/88] aacraid: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/7afdb8637997
[17/88] acornscsi: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/396dd2c0b7b2
[18/88] advansys: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/f3bc9338e08d
[19/88] aha152x: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/3ab3b151ff12
[20/88] aha1542: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/135223527c81
[21/88] aic7xxx: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/07ebbc3a8067
[22/88] arcmsr: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/3f0b59b6852d
[23/88] atp870u: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/681fa5252fd4
[24/88] bfa: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/4316b5b8b2c6
[25/88] bnx2fc: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/a75af82a77d2
[26/88] csiostor: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/0979e265e4b7
[27/88] cxlflash: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/e82d6b179b14
[28/88] dc395x: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/6c365b880093
[29/88] dpt_i2o: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/e6ed928effb6
[30/88] esas2r: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/52e65d1c25a6
[31/88] esp_scsi: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/f8ab27d96494
[32/88] fas216: Introduce struct fas216_cmd_priv
        https://git.kernel.org/mkp/scsi/c/caffd3ad966e
[33/88] fas216: Stop using scsi_cmnd.scsi_done
        https://git.kernel.org/mkp/scsi/c/696fec18e17c
[34/88] fdomain: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/a0c22474cbc6
[35/88] fnic: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/a7510fbd879e
[36/88] hpsa: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/82f01edcf9a8
[37/88] hptiop: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/574015a83731
[38/88] ibmvscsi: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/85f6dd08c86a
[39/88] imm: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/0233196eb238
[40/88] initio: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/25e1d89669ec
[41/88] ipr: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/acd3c42d18f7
[42/88] ips: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/98cc0e69ba5d
[43/88] libfc: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/e0f63b2181cb
[44/88] libiscsi: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/b4b84edc5d39
[45/88] libsas: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/e803bc52b04b
[46/88] lpfc: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/ca068c2c6ca0
[47/88] mac53c94: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/c0e70ea3f719
[48/88] megaraid: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/012f14b269da
[49/88] megaraid: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/9e0603656fdf
[50/88] mesh: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/aaf2173b5cc3
[51/88] mpi3mr: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/1a30fd18f21b
[52/88] mpt3sas: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/b0c3007922f4
[53/88] mvumi: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/ca495999075b
[54/88] myrb: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/0061e3f5e0c2
[55/88] myrs: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/1c21a4f495cf
[57/88] ncr53c8xx: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/f0f4f79a4f7d
[58/88] nsp32: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/48760367a401
[59/88] pcmcia: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/ca0d62d29bb1
[60/88] pmcraid: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/f13cc234bec9
[61/88] ppa: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/7bc195c75134
[62/88] ps3rom: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/3ca2385af905
[63/88] qedf: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/ef697683d3eb
[64/88] qla1280: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/2d1609afd6d7
[65/88] qla2xxx: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/79e30b884a01
[66/88] qla4xxx: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/fdcfbd6517d9
[67/88] qlogicfas408: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/da65bc05cf91
[68/88] qlogicpti: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/c33a2dca9853
[69/88] scsi_debug: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/6c2c7d6aa439
[70/88] smartpqi: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/0ca190805784
[71/88] snic: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/70a5caf11f8c
[72/88] stex: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/4acf838e80ba
[73/88] storvsc_drv: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/0c31fa0e6619
[74/88] sym53c8xx_2: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/37425f5d07cc
[75/88] ufs: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/35c3730a9657
[76/88] virtio_scsi: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/b4194fcb1b51
[77/88] vmw_pvscsi: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/aeb2627dcfd9
[78/88] wd33c93: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/9c4f6be7ddec
[79/88] wd719x: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/f11e4da6bfc1
[80/88] xen-scsifront: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/fd17badb664e
[81/88] staging: rts5208: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/ae4ea859c079
[82/88] staging: unisys: visorhba: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/4879f233b4f8
[83/88] target/tcm_loop: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/b9d82b7dea2c
[84/88] usb: Call scsi_done() directly
        https://git.kernel.org/mkp/scsi/c/46c97948e9b5
[85/88] scsi: core: Call scsi_done directly
        https://git.kernel.org/mkp/scsi/c/11b68e36b167
[86/88] isci: Remove a declaration
        https://git.kernel.org/mkp/scsi/c/814818fd4816
[87/88] fas216: Introduce the function fas216_queue_command_internal()
        https://git.kernel.org/mkp/scsi/c/0feb3429d735
[88/88] scsi: Remove the 'done' argument from SCSI queuecommand_lck functions
        https://git.kernel.org/mkp/scsi/c/af049dfd0b10

-- 
Martin K. Petersen	Oracle Linux Engineering
