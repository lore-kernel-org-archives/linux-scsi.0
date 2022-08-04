Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05322C00144
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 03:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237407AbiHDDlp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 23:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237168AbiHDDlV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 23:41:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2684B4D176
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 20:41:21 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2741iIKU017622;
        Thu, 4 Aug 2022 03:41:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=JKqO1n16VKH7YKx/wwV5AEU/dxTol50UCjRObIePMw8=;
 b=c8eOiHEzVuP2TIZR48k6QlKfCf42Hlyu999B6ejgsesHrm9tM2DDDqMo9CP4Zm5J9eLj
 DsdcjL9bendvkW1/BjC/ouEvoIkhUGE8Pdz8Wzet8Et5lBImKODW6dFwP86DfHSIGWfG
 gM5dQ57WhsqDDaUjF2DNT9PjnpHuUECh4YnTMSnqDTRsDi8i1w+EYERBvuMAyO++jFBQ
 3wY/zIExVMl2o9Vl5idRg85jeG7WDCQJoa6smKh8XOcDZb0jge8fsSqAAMVWpZDtWT/L
 krEKEJTADSpO2FjyR77B0yoa4N/ZazlC4iu3oGMBCGCWznpmFptW0QRJBbPwyqZBay8F uQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmvh9ucvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:12 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2741TSSi002997;
        Thu, 4 Aug 2022 03:41:11 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu33w4xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2JxP87c58903ntSln5hstmdfMTNcQEcZkkYI2jRYBZCs21Fz4mQIH53ccrHfn8t0Gb9VoKtszCF5ERrgyeGmbL+4Pg7Rae0d13mA3G07MGGEnJrDC1qB8OIzoz7NgovIDqUGHwGsKz0V2mLSi2QeYeQeCyLisJHGO8U2oiPTgtI/YRFIuhLREYb9sECnVM61q7X24mKvzakDppHkOitCIoIOYWajKewLFuAf816wWQ4JyTNyVK1FU0bhEIYb2Neiewgd8Lue3ZebTFVD9csw54ASH/lvAY9939qukZgk41CtIsn/9N/ndoN/Cngx9YNJPp89gWETu7M05apysZ18g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKqO1n16VKH7YKx/wwV5AEU/dxTol50UCjRObIePMw8=;
 b=YpSK/M/Zdyh/keyRdhv9E9brqS3Sl7w8CeZO0K1LJf12TeE0pHPRzbEA2yPEC+r9m5JzgPvbWtRaF36op5/69tp7pWt73fZ1TFKsqSAeWOwggOKlL/MLb0racdlUKFeLxwCWvN3va9fH0S8O7MIHeXoCHh/vbky6f2MVArF3uj/z3G/4X9B+Xh1pYqpf4Kn8NuK1qvggwuNoa3za5bD99MyPD7P82Zn0WBniI5PfgXbgnNEjoOky0gmtnZKDDgbebrFsMZINDAwLokvggNK4jV4Zb0ZbKnQLKhyaS78wEc+5nQPVlgQu8qGQ2Hfs98bpHT0Riw0Jp9uqmz/H0c/gxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKqO1n16VKH7YKx/wwV5AEU/dxTol50UCjRObIePMw8=;
 b=bBUSSiqqWqnYFq7xThNgHFRfWO9Yk5qfNe+x74LBQksNUpmvEpL53mAA8ZIcKjq+jNaduJ1DpJu6ZBA4AVvm10W+CS7mhxj9ODHPKr8tCFolYGOHXu9WQuVbkO9EmcybDH9vY698snvSnot0RX6gByKcn3YMhye1oqp4jyPWRQQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM4PR10MB6037.namprd10.prod.outlook.com (2603:10b6:8:bb::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Thu, 4 Aug 2022 03:41:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 03:41:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, manoj@linux.ibm.com, mrochs@linux.ibm.com,
        ukrishn@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 05/10] scsi: virtio_scsi: Drop DID_NEXUS_FAILURE use.
Date:   Wed,  3 Aug 2022 22:40:55 -0500
Message-Id: <20220804034100.121125-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804034100.121125-1-michael.christie@oracle.com>
References: <20220804034100.121125-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0221.namprd03.prod.outlook.com
 (2603:10b6:610:e7::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0a9783e-1dc2-43df-6174-08da75cb2bb4
X-MS-TrafficTypeDiagnostic: DM4PR10MB6037:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fgavgBHZXkoEUdPfh3ZA72KDR6LeE2/ZynDZGJed/FpSNpEOFIT17WoJbrce5oDI3yee8bUadW9mGNsvkMekcbILQ9N1ODychNO2Iau6uSpL/2H4HE1JYjwhEHVfADnKWUBSnpOS/XdyRK9ewUXEEjTpxxFWjIe++WYM2S4Zoqh9Bu43VCQD8mUDRBkU3xRCdMTOPG302KihUIsXT3VS0+Zr0Lf9FxdIihPFhpuPLFWb2Kz4YiWRJ/vLAXxGKtRQVcPJVYCT6VZUEt3r8xP1uSJ9DR0XlIHuXGVKDHJf7pP3u8KGk3yQ/CwYJ7kE32HzF/xO0wjQ1usH9DYaIa1HDZJRLVTeCVkpplCBhjMPtjRQ0KhmZ+sTz1fenPnGliCWcsKMnGLvPk5znQ0kPWNZPZPcVIaXxo4VDrvZObKgD9/Ww1WnCdaIgvqSC5wRymF0ZSVgcmUfhohMhnuWCZ3ydRunAxmND/rhMAQ1QnTKsVzt2nX8/G1XLJTEK753gpqxC8gp9/FY0X5t4/MbTXJl8SY3Y6R/q7JSUXacgCYfUbfSm2KObA98YS4FnIftNhHQnG6rzK7iniQyRBs6qUaSFxtPTMiu5ctXWyzik2Za0+VIMwtyO/uf2LOOeN84Kk1rSDliAHTGsU09vHj7yIz6Gl5eKv5+9xKBH4QD+cPkTkZuiqbcuH5PcvmH6TeP5jhw5dMguJBq1toHKPo9wj7M2J2YQ/n9ZpWRubBMb/cLqMtHjxXuEoWBRw89ZqdHMdtrUUZBJ6KfE+/xaV0ItaadDK2JCSUBZenI+GN8Qs5nPFM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(346002)(366004)(396003)(136003)(1076003)(107886003)(186003)(2616005)(41300700001)(6666004)(6506007)(7416002)(36756003)(2906002)(5660300002)(478600001)(6486002)(4326008)(66946007)(8676002)(86362001)(66476007)(8936002)(38100700002)(66556008)(921005)(83380400001)(6512007)(316002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x5mtVmHmLCzHaUxUjHD5MentUZq4Ei62Htx8O6UGnNbCmE8ye0Rp0kq5rvCe?=
 =?us-ascii?Q?n34TmssQ9ldQpqivu4wzXyvDC6Bw3J8jYSHBfNyuoDOV1EvxgRzXBQ0Qk43e?=
 =?us-ascii?Q?YKdGmUvNGM+vEd7fm7p9ZElfSggms82QRZ0Htk3dXj72GZ6RnFobCQ6UH6jN?=
 =?us-ascii?Q?25a3ED3BNs/tlwIczkRlfdt+23jdKs231XMt99MLES3dsymmD+KgXJuXc86V?=
 =?us-ascii?Q?FnaApaqfY/JkU+RuFFmvcrDCKhrErj3vW5tib11e1hYA6zfFLKAfaFo1lUG0?=
 =?us-ascii?Q?O9gfS7zlQCvHKYRgVV2RlvM0rPBIder9MD582hL3e3ObnOqB3ms4mY/f9CB0?=
 =?us-ascii?Q?+Y4+DvifXVqfmXMliUTy5rvn9vy7hrq8LJO3yxomjwR3nB9mV36mcdJIjrDI?=
 =?us-ascii?Q?WzT25Axn1jeprFNTUIpwIWZDNJpkGG8gwwQK9ziNwnKqhd/Phhenrq7bhW/8?=
 =?us-ascii?Q?2fHWg8I0oCkImJw/0pcYLSpdVhcHqG2f/bgECCCyf/LhgIUBd0PVsGSMAI1N?=
 =?us-ascii?Q?kBrKqx9horgwDOCOokrAp8mfPEaR5ShAPPpnEgOcYK2C2dIdrsHh+M1RHUDu?=
 =?us-ascii?Q?BAdB8HtvMy5JzoCNRK/RdAr1bwiqwXDGhR/iUe0EelAa+41ueSP2S8hc8ZaW?=
 =?us-ascii?Q?QHqj9wkblKlo27FAze3gfBffoWvbl8HOdp5nkeB28ZoxR20RyRjbMTKSvaXY?=
 =?us-ascii?Q?ZcGHxwArTQgwTua9AA5Zs1lgWwe+kqA2r9l8dk46mhe/83XZbb3A6/1qAoNC?=
 =?us-ascii?Q?En0gfbsKbtg5qg2vjji7OVZ4R8Ekla1OHGbsR9DX55PbRxLhvOBHOBLZ4fe5?=
 =?us-ascii?Q?/36aMy+VPb8J/rljK9aeDAezYNr12JJFGIWznjWtdp2QFNrP6H9hwZMg3TzG?=
 =?us-ascii?Q?CK6oXDt6fPzOvqbbvM0ehLdzpHtfSvzP1rvFkOlsP58S7V/PNkMfJPzlTtBd?=
 =?us-ascii?Q?QZ577UTi9RpjJp0v3fBRHayfKpzhGUgG3fmX07Wxnt/w4wBvKrn/16uEKJeH?=
 =?us-ascii?Q?9c0BQqK65iCeFdR87uSxEir+G6OUCoYML7Iqv9HhFe2HBIUdXroIWRQZuXLj?=
 =?us-ascii?Q?0zXaOQC+7IVgMtKvngmYCeG5Njg7qd9mdWghAfDQ40plBxpflPPa6MNWtDHO?=
 =?us-ascii?Q?iJARdODA8J0L2Ga0r4TTEU3dJXIgA1kKBBqfy6zfZ8UCfEWY2kTAe7B+1cZP?=
 =?us-ascii?Q?3pdTvZlrDLZDGhJd+ONwaK9kj1NKGVPZKf2V5RDOI0cBjKPGm9gWuLkPT1ti?=
 =?us-ascii?Q?wm5G57Ugo5ZGA8drWWHoMc3IvKCHKqZYmiKu0W4lFu6MqUMN8MnBzW+nvB4h?=
 =?us-ascii?Q?zegpkK6On+ZYQ59rSrWK+b96jIBkShmWibAiHNB53EjTZid9YzHuLM1ZYvoE?=
 =?us-ascii?Q?qgl8cpiE1qME2yPcv7eRMPS60x6J76vT9WNyDfmItv0veML+xN/cX97XevZJ?=
 =?us-ascii?Q?rPgsvuaLvo+hwuumEZDbZTxqNAZxc2nQD+lOV7eR+ndmsLdSgqUiZ5DG6QDS?=
 =?us-ascii?Q?dCDkhxhIIoDzOqr2L7ieZmi/CYRshRvl6tKGZBbxm5ssqe6UFpKAad2dVVR0?=
 =?us-ascii?Q?k7+eyK+zSU1hDzPv3u90l4MlpQ7QtfpijhiQ58GZ0cQz2v5ENbGYHrbSY245?=
 =?us-ascii?Q?nQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0a9783e-1dc2-43df-6174-08da75cb2bb4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 03:41:09.9180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gstssQY+37sniUzgoKcNwAfjR1ku9PxxejhjI83pNlqte1FRMG2nFXmCOtx835CVsJrd+tORrSpsUcjs2LzFAwDgefsQ4JOiAb/bl+E48IU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6037
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_07,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208040015
X-Proofpoint-ORIG-GUID: 9L0fE3rUpcrMBmK_O2giFiHjZ7m74eDV
X-Proofpoint-GUID: 9L0fE3rUpcrMBmK_O2giFiHjZ7m74eDV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DID_NEXUS_FAILURE is internal to the SCSI layer. Drivers must not use it
because:

1. It's not propagated upwards, so SG IO/passthrough users will not see an
error and think a command was successful.

2. There is no handling for them in scsi_decide_disposition so it results
in the scsi eh running.

It looks like virtio_scsi gets this when something like qemu returns
VIRTIO_SCSI_S_NEXUS_FAILURE. It looks like qemu returns that error code
if host OS returns DID_NEXUS_FAILURE (qemu's internal
SCSI_HOST_RESERVATION_ERROR maps to DID_NEXUS_FAILURE). This shouldn't
happen for linux since we don't propagate that error code to userspace.

This has us convert VIRTIO_SCSI_S_NEXUS_FAILURE to a
SAM_STAT_RESERVATION_CONFLICT in case some other virt layer is returning
it. In that case we will still get the reservation confict failure we
expect.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/virtio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 112d8c3962b0..00cf6743db8c 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -144,7 +144,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 		set_host_byte(sc, DID_BAD_TARGET);
 		break;
 	case VIRTIO_SCSI_S_NEXUS_FAILURE:
-		set_host_byte(sc, DID_NEXUS_FAILURE);
+		set_status_byte(sc, SAM_STAT_RESERVATION_CONFLICT);
 		break;
 	default:
 		scmd_printk(KERN_WARNING, sc, "Unknown response %d",
-- 
2.25.1

