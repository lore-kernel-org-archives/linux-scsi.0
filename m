Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB7DC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jan 2022 12:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiAJMzV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jan 2022 07:55:21 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:64320 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343506AbiAJMyt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jan 2022 07:54:49 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20ACaLgJ008421;
        Mon, 10 Jan 2022 12:54:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=UbIswSfyXb8cOz38/uGQxVcqwikHib3kemjrCLQtl1A=;
 b=hLx7eskDYkV4ln8OpC+ZTNLPvQ0AQI4+1QTJ4rO/4d5wR72etfoexprcLHRIlEJ2mtDg
 Rnbrk4mfswAop49e0LWZsbPMI7gn9mtPag+CClv4WK5M66q6MzInNvQte4roLCpKIcFP
 fYk5jL2EtrjK4dlBmhpkZoBOw93IfV6ptGZoTQUwzVIRn1K7We7zb51VcN0MwBiLUs0N
 NTYmSrLZhPzwT01+2UM68xB5xoOPfcSWTGvbL9XXdlHIg+xfq4V3ZG6tOBafOVsyxLD+
 sxomar8pintXzIeXBRT6hfVEH7C73ANLM0Lb1zS3uZDuU0hRE/f0huDiWkKhff2o28ca tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3df35u31uc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 12:54:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20ACoQ2o087611;
        Mon, 10 Jan 2022 12:54:41 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2042.outbound.protection.outlook.com [104.47.56.42])
        by aserp3030.oracle.com with ESMTP id 3df0nchgaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 12:54:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLVYPMazbQ0Xhy8Jy9D3TEQAa2Pa/0hfFxivHGdDf5q8vmMAbTtZPLcfv1aCPsu8A8J2gI0/Nhnyn+/hHEWtXdALd4isMfYj8kR6Cuf1xWjSe9yD2vlUzGmmFdFsk8xeOn3NGa1b3em5Pt9UM+3lB1p7NoWXb1K89CvdRm+4wdTyMmE/hHrG5JeGM7NnEGXtA49iGQt6n3vc10iqwc+gcRJqafcE8QVginGCTIUdfKcX/G/7mRm/DX4R37F6qQlHIHOYo+xKrlwsrqjuohtkn+YR6jpdJZlRMBsp2LXyO4OTSTpVUFzUIQ3jYii+/CogMI+B+RgAQClpKa6rARMOkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UbIswSfyXb8cOz38/uGQxVcqwikHib3kemjrCLQtl1A=;
 b=bsW89tAF4x8bdH797a1m6ZH1d5GzZy4lDsAYbF1j9i20BpG6r+t+Rym+IokoKTeBlUQ3NS1U9ym1JTlYRpdWC4Gh9+H2mB5vmZCtFMzTBlhoOjTYVF23JtJIgAFyi8MtDMAY5sRT+Om8y2LP0MrIAT79Zclz0pPSc/ApgIubIgRJZOnbMMv3PSoZrDQ73bBuZM7QYOGNSNFsb9dHY333k/WtUjwetoDhKyZcb4NXpf1n7Mve9ylhJNqYpAJcQ5B79xwpRoObg8PlqT3WYcdqVv6YEFETTR3Zw7GikZ4FBOo9Zc1q8VlXZAeah3qaoeFzTmyVzW/hDs5CQGWFsMbKaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UbIswSfyXb8cOz38/uGQxVcqwikHib3kemjrCLQtl1A=;
 b=PA6Cyqc6IVAVl9uTC5pOFuffVQhSP9RzfnGDvWXr/EVmfV2IkH9u+Lcdsur965P4uCJYKxHjSEhE25xr10hXtEiqUHLZJtEzUzwkBqwoXuhRPIrpxLavv47AMLtD8748Poz5YsYpfie5WLV/SO2mDGTnKILOdJ2mWZOgreepMC8=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW4PR10MB5677.namprd10.prod.outlook.com
 (2603:10b6:303:18b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Mon, 10 Jan
 2022 12:54:40 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8%4]) with mapi id 15.20.4867.012; Mon, 10 Jan 2022
 12:54:40 +0000
Date:   Mon, 10 Jan 2022 15:54:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     chenxiang66@hisilicon.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: hisi_sas: Fix some issues related to
 asd_sas_port->phy_list
Message-ID: <20220110125428.GA5230@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZRAP278CA0008.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::18) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d415fcd2-ba79-4b0d-4d1e-08d9d4385d5a
X-MS-TrafficTypeDiagnostic: MW4PR10MB5677:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB5677609DB1D271063F4FF5C08E509@MW4PR10MB5677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:595;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ixTaok+ss9HFYU/ZfzZjsvM/7gNFxcLn+lDym56E8Iiz/J6RFreYMFRVdSkYzfz1RUh1VNR6/RyfCTpD1u0sWxI76YphPdDw8q4NRQ32xR0cf6CpJVHT+jKrps2VfsKgVTle/+BD8w30psgAszSYKO3Wx6JBcBTtqcr32v2qCc2W/EVTWEmFurRTc5J66VE+jeJv6ZiJC+Akztjurm4pnJPPY55O6kg0aavcTJo/BOzoVdY0pahyh4VrWMdycTelb6zPj/vqwZox7tfJ3e4lAXN8FqqkdngF4Iz0MOJ3/Q1zgEVSUFLf8Q9t/lTZ0qEO4borDtYzTSCLlHCkjRg4ZTpZjNlhPfqkuiVN24oP0zJ2dQBC/vlE+4nxo3hBb7OFYyQ8oMrTsWR9taRKry/fWSm/L3hN9Fd2QoxVRMbrV+mDOIWscdYqQx/1EtWcYAu2KHFjM+zVnimdAT5Pl49Z1JF7sddy7qFdMcznlu46VRk6rTAU93AVqs5JA6KvM5ETMGLmnVhHwlyeVpWagik79MJSGS1KQ2VOBDIrVfAir80WIXWsXvHVAMaik4agPYXOLyebEdUe8vPjNoX8ppjmaUdRW0dhClPyRU/nNn/R/ZjAg2BY/xdxkiic+D5QBxLWeT9cZXPfaSb6g2KFiLsMjXDcZ3awjMZqYfKQeXevT4ya7Gmp93i/wiXSdcntOK4jCLcgNH/zlCEVa9yg9hxYZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(86362001)(38100700002)(83380400001)(38350700002)(33656002)(316002)(6916009)(4326008)(6666004)(6506007)(66946007)(66476007)(66556008)(8936002)(186003)(52116002)(9686003)(8676002)(6512007)(6486002)(5660300002)(508600001)(2906002)(26005)(1076003)(33716001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jToxuljLExP9MzoVpfjIh3w9S/BM2IJf1/HeS/8ptDmfXPySX18/tM7d8m7g?=
 =?us-ascii?Q?PRu63lyJqIh5FWuWyyob3g75bYqjlzPbdEKqJ/RfRO4WwmTmPToNKpGsaNHa?=
 =?us-ascii?Q?/9wRA4mYL1Mb+ZYLxp62KevkhJ5+WcNpVfMZ8nce+gLPROtcIlIOCPnIj3ee?=
 =?us-ascii?Q?xASs6Y6z4qLJMxIG2sl0awSJv5cXWApdOVNVxKmGPMe1XEaou6DIAXX9Oj62?=
 =?us-ascii?Q?RDw+IASe1UPtHnrFjDyQYMzaBhwu8v1PXi2Lwb6aEfYX2FLPcyMRo10qf4ot?=
 =?us-ascii?Q?j21txSJgSNmoOcMh4Xnf7DFhblVspsg6JT0a3gIRWWbskRjxyoUD0iYZJBnX?=
 =?us-ascii?Q?btR/uOulQcGgFx2/jMfqnuWe4B8XGD3eSTbbp7kgSeiEUm9W9OT5+iRRwfrd?=
 =?us-ascii?Q?cXCRir55WCfIe+d8JVb9DtTQ2da/5GRFzLQ8/yd7HzSlH7uI7qc9r0FEvxps?=
 =?us-ascii?Q?hKDBPQDS24izLTK3VEudx6LzHsBp0h0rUHSoHOV4dy4MGixTCx66mUyvbq4L?=
 =?us-ascii?Q?IY563HWkOos51Abe/FO1UpFWcOpVthUf7gcLUJjniZAOLgulKLJGD00ZBTkF?=
 =?us-ascii?Q?gXVBorZ5E75zqw2FstrBZYpvGpQHJ5hJFC6DTWzLgsYRqO+baRBd1bpmQUVs?=
 =?us-ascii?Q?Ca9WskBDnN3PnERle39gInw/DJ7flrA0WH8ydInEabdhkbWe/Q3UFZtI5eDN?=
 =?us-ascii?Q?E4+uUL9DoFf/N98QzA0DzW8PxfAbraBxJDPTiV7kFUE2y601ecKrnuT27rAm?=
 =?us-ascii?Q?0Gig9wTQZ6384ak9UIvjqVMbRJwChxv3d2ZPxKFOwhpTc8AQ30aMzVZozww1?=
 =?us-ascii?Q?TXpdbvTRP8J5kAwZQ05Ifvo6J0fYhokDXwIEu8WsC1w94a+XeAY78MlcbNnw?=
 =?us-ascii?Q?lg4HITn9zSz765SiC1dhnRrOxphdOPgQytxQuAfPlBE5d7ONDOTwJG57QTXv?=
 =?us-ascii?Q?bodKkCada0lnru+1FivjzsuPJl/PZMV3gX38fjJrdj6NhZattIAadLq2VZgx?=
 =?us-ascii?Q?4BlFHGVOmRWnJBFzEhHMrO3xmtBeqw6bSspo0ozzChF7M75Rfx9tEO06gBYR?=
 =?us-ascii?Q?tqxQoGMjaVRQqJu4HzvujipnzeFLAzRirP7chm7jhptrN7ZLejeexps/Q+mf?=
 =?us-ascii?Q?spucfrLhayiQSKhsOEEt2IINUtL2ksrc1TEE6lhtlALYUC6mCJwlVKp5H6Dc?=
 =?us-ascii?Q?b2IK9Mjw/61SDs0ZTB//z2PRHE1WLfWH7C6TWrsyxAMc1xf5aHpJCSwwNMqX?=
 =?us-ascii?Q?kU00DrEwZnKIeqARaXQdYj34PKhig2ct17hKOdQb6gvPyLvqbp5aMoCCmtrT?=
 =?us-ascii?Q?gANoMUvzgPRhRPqEnvPuOXbLizO2wMhQSVOFTzJlxZCZKkn/sBnx30YKHovh?=
 =?us-ascii?Q?NYmJ+geETnRgp1Zh70d8R7IoF4pKb80XIcatUxEZwHbmOEGvi6Ijepyh/GlH?=
 =?us-ascii?Q?Bu4RlGMYPq2WvpPOWh/20/uZ673Etq3hysL7v5aV8lqLqQZVlVXCTEH+RX+M?=
 =?us-ascii?Q?m6esyJ7hkq5jKsRyGlAvo0QSXkMXX90DtvzNHfhW/mqlBeg49qYWxS4ft2Sz?=
 =?us-ascii?Q?SRFO+5u4TjCxhckgyLD4z+cVo7gEsjj0gRuRbEzc0hwnQoi2Ux5fckjAhFRG?=
 =?us-ascii?Q?OkomA8w+x4kWY7qxQVYjUc7eWMSmK1DfNP8KnLGq+eAa8c4AOT7eUTkeYjGO?=
 =?us-ascii?Q?Etxncm5YYY/fblpKi19RkQKQSLA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d415fcd2-ba79-4b0d-4d1e-08d9d4385d5a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 12:54:40.1904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kNBgBoneXAhkm8AtF5KSdSEIjhl7eCshlGVmOqa7J24ekZ6/OjwGpBdUV8vQ0pQLuBX1a8asdrxXVtNJ2miLmNTfeHGQ+9l43d7LfDkji9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5677
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10222 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201100090
X-Proofpoint-ORIG-GUID: 9WYYryg8nOd5mEFqKEzAgpQI_tOrl4kL
X-Proofpoint-GUID: 9WYYryg8nOd5mEFqKEzAgpQI_tOrl4kL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Xiang Chen,

The patch 29e2bac87421: "scsi: hisi_sas: Fix some issues related to
asd_sas_port->phy_list" from Dec 20, 2021, leads to the following
Smatch static checker warning:

	drivers/scsi/hisi_sas/hisi_sas_main.c:1536 hisi_sas_send_ata_reset_each_phy()
	error: potentially dereferencing uninitialized 'sas_phy'.

drivers/scsi/hisi_sas/hisi_sas_main.c
    1519 static void hisi_sas_send_ata_reset_each_phy(struct hisi_hba *hisi_hba,
    1520                                              struct asd_sas_port *sas_port,
    1521                                              struct domain_device *device)
    1522 {
    1523         struct hisi_sas_tmf_task tmf_task = { .force_phy = 1 };
    1524         struct ata_port *ap = device->sata_dev.ap;
    1525         struct device *dev = hisi_hba->dev;
    1526         int s = sizeof(struct host_to_dev_fis);
    1527         int rc = TMF_RESP_FUNC_FAILED;
    1528         struct asd_sas_phy *sas_phy;
    1529         struct ata_link *link;
    1530         u8 fis[20] = {0};
    1531         u32 state;
    1532         int i;
    1533 
    1534         state = hisi_hba->hw->get_phys_state(hisi_hba);
    1535         for (i = 0; i < hisi_hba->n_phy; i++) {
--> 1536                 if (!(state & BIT(sas_phy->id)))
                                           ^^^^^^^
This is no longer initialized anywhere.

    1537                         continue;
    1538                 if (!(sas_port->phy_mask & BIT(i)))
    1539                         continue;
    1540 
    1541                 ata_for_each_link(link, ap, EDGE) {
    1542                         int pmp = sata_srst_pmp(link);
    1543 
    1544                         tmf_task.phy_id = i;
    1545                         hisi_sas_fill_ata_reset_cmd(link->device, 1, pmp, fis);
    1546                         rc = hisi_sas_exec_internal_tmf_task(device, fis, s,
    1547                                                              &tmf_task);
    1548                         if (rc != TMF_RESP_FUNC_COMPLETE) {
    1549                                 dev_err(dev, "phy%d ata reset failed rc=%d\n",
    1550                                         i, rc);
    1551                                 break;
    1552                         }
    1553                 }
    1554         }
    1555 }

regards,
dan carpenter
