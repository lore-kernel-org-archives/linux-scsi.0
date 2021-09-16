Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C721C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 13:23:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5BD261212
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 13:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240099AbhIPNZK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 09:25:10 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18910 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240011AbhIPNZJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Sep 2021 09:25:09 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18GDEP7W012754;
        Thu, 16 Sep 2021 13:23:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=+pKtelzY3I4dJccR8Upi1hCaMkDdop1pntAY8ckDoHY=;
 b=oV40HBGrUICLcY2YCzUrwxKu/vuDZRowklKzdfDqLxSqDLPC36URgkbPfo//LxZJOym5
 rPo21Fbrn5aOlZc7Xeu2w1bDfpAa0ZHqZKgN2eaFiHne+no1WMJRNDQpVXDsFfPQ0tcq
 eaWy8+B4BwQE9yUdIirgGKHsWhg0WGM3pXLzb2KBMQZtqAtnf1wcJ+hRg8IGMLjeVa19
 I9UJhkLdnZRyLTz6vbNXixKvyBEDanGnEBGq/1PmFAMag0x35akh+HdO4YulFg4qeHj9
 Xl+8gUYqT/2sPqtpEXazfuiXZuDwZZPqaoGGOgwszAgECxf93XSTUpkq82Tzhx++YhfD OQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=+pKtelzY3I4dJccR8Upi1hCaMkDdop1pntAY8ckDoHY=;
 b=SNT0fb8h/l54w0Eh1F6p47sU3qbFtvgZGgnxqCm5x4DyyKZw80yfuhGrLWl1OwAZJEZK
 FQo0ZY04z6DyEGR/vjntw/NFG6HGoa1AMMO6ZxYQZ1auz4O/TlT0IPg6hPs8NaWZQr8c
 pPYTfPDxP+T54eMbBayJLLS1mbsDuTAL2Cs4rTfYFUCCBUEQPIYZEZC9KncDiJ7vToFd
 IWxjEPLcWv11ZPNyFMilqfyrcSVvnEawMCWqArrWQPGvlQSAg752UwsL20OHg5WqA+Po
 zfkxqU0+zk4Iym141/3JnUqokjlqkBnjKcaCbrwS4FpMCAzbdz+SAuS+ilfp/N6y7zPi SA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3s74j80t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 13:23:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GDLgrL191215;
        Thu, 16 Sep 2021 13:23:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3020.oracle.com with ESMTP id 3b167v7aak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 13:23:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9SNa2PHU+V3vfGMJPvywiKyLAEpqsc0tofi0XWgwF/HM+KnuMs4BcXJX1QoeisyglCapXBIB8m4KL3m+xNcVBbMRXRY6sKqSzoTBJpCQcYVohQ/FrMJEtynHY/twbJA9anjJHKihaN2XZUg5bDu0w1MVW7Gz2ynlht5RKtq4MhGOv4aSdPv1DlEkI4qRG7mAs/0bWxOEBCwf4SiEWYmhpXViqm4PCMZu2fMCKG/iM3nNRCOT5hCi5hG1vfR7sYr6APdjlQYJdWC710osofBQacoIagUfmxdMyaRbvlwNKx0r2mhPyWG5ggLr1ub+zRNqb848xA1Gyd6NXUWYYtHRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+pKtelzY3I4dJccR8Upi1hCaMkDdop1pntAY8ckDoHY=;
 b=DVI5RqIH+qrY5qZUQd2qtzKBMkYiBkQHiH3byTIMZWGmf4Hcxy0nkixWr01NyDerZS/yqifMyOkn27gMvmsTOSUOyE81k7R/60hLOsGuLjY4G5iqSfZPxOUUBx80ENgnrb1C6xwkwgV4Ykz7TPpLK6kY8TdkvExl1AZ61NqRC8xMAu32j8Wh0n5XZoaUgOarcuowMJtqQZNihZqrxPZVUGfjQLQqvgb/7jYU0by50CyDuQc2j8wBcNNtFRDND+g3Lwxe/bSEu7cxfH9Dd09RDWeStOhSfFDj4G0RW2vfgVoLxHoG9Nrcsc5EkkoZuRs9cMT7V3Va7xMy/YD94fxEFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+pKtelzY3I4dJccR8Upi1hCaMkDdop1pntAY8ckDoHY=;
 b=VVwKRBTipWqoSGTY/ROoLqRoMH+lH+wgq6OiXN89olvpfC9cDK/V+Do3mrCByLmpKK/fpXt39k5813gp/8cGuxguz32GkZoXFYWHqh+sLrcdiyn9quaLT/T5u2FZ5zEu/VWg9iepcHYb3yu6tIXv66yCHloKNL4aDFsaoAG55Z0=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1615.namprd10.prod.outlook.com
 (2603:10b6:301:7::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 13:23:43 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 13:23:43 +0000
Date:   Thu, 16 Sep 2021 16:23:31 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     James Smart <james.smart@broadcom.com>
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: lpfc: use correct scnprintf() limit
Message-ID: <20210916132331.GE25094@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0117.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::14) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by ZR0P278CA0117.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Thu, 16 Sep 2021 13:23:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bb573e3-d7fb-46ae-502b-08d979153447
X-MS-TrafficTypeDiagnostic: MWHPR10MB1615:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1615706245B672E4A2D32A628EDC9@MWHPR10MB1615.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6v5cxvLtyVx/uW+lxUBrSqIpH665P6brDnd90P6H0HoW1VO8LRaRUY3oj3OMHnmhKfEWMMt/bkuLArIOd6uqJnkCFZpLoxCp8Tr7KsPsKenQASfk/94QoGMJjmFs9EZ1H8Ev803sxM/IrxZ/1lE+UTAdSPhKW12ADET/itBzIAj+i3pgcBFQ9CoVMT6NlB2GD42qS2q1h2oWZwP+8DOxf4GFBSTTwM3XTtSNgn6p+FFXO7MD22TnJqOfFshuHfsMHMKX70ri8ZJIsL9BMa5EC+KU467SQ4tnCR+fFsI8tHD/TcaNicwnrNlaFn0I+j5E7cBY9GP1z5tHhGlBWlhdeHdCBTpQS/uaVLB2Uz2YuTQAIiQ9dPl/TPhAuhmEEIM7wNwSl8eg/AuHFGtmUssdLmeXgrzw5WQG1TqDTX0BbttlRk/P2oC75yEAQYcxohzVUps8T1CJSC8xEP17NRo+9tyZdi1gmouHvVKFURAS36X2moU47fs6piBo+niuDeOfL7oIvp2xGBDleL4MOrye+vTz63X4NQ6TW8zswWrBFnL07V6OhTtJbWOz7RM51v70/PhnynnYagxVn05qPVLh+sGz98BnaT9AJL7AljEinOM++gnTJmfQi/qJeo6E8qfiu1MHDnaG33Bm/k/jzVBkUds7sH9ZU1bZYlRO5c8YlqTNeubsR3Zy2nTX9eFcXs3w7TI4U4l2ayVXA16Q2ksQJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(376002)(136003)(346002)(66556008)(186003)(8936002)(8676002)(1076003)(9576002)(6916009)(4326008)(9686003)(6496006)(316002)(478600001)(6666004)(86362001)(33656002)(5660300002)(54906003)(2906002)(44832011)(66946007)(956004)(38350700002)(83380400001)(55016002)(33716001)(38100700002)(66476007)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uyRqWV47bumMjD2gRtqCAl3XH/LYpPJNcWflrEk5hDEf5ny+Sncpv4qm0oHw?=
 =?us-ascii?Q?0wnMwfLBhJ9ZbCuGEjC21QrNd0DqMJmNBsJLtMv1Jlo+OMXNyyCoLoAh1EYY?=
 =?us-ascii?Q?ab6zeluXc3gKQMAADUnTlyeA2HwaNHNlV4/UwEEbE54tRUSrCsil0y84SjYf?=
 =?us-ascii?Q?/gfgKZMZpeOJy1AMSlpWvgjoL7eG/FVJwsEpq5SoXT2LKn3qRuEv7xX9ygj1?=
 =?us-ascii?Q?tGNPXQpkxCoyuXEJLiWxloIIqxGL6+iqyncR75E+TKnDCnzL5lWBDNWeBTm9?=
 =?us-ascii?Q?XI1HReYyZyyF5FlQTh+NrEFBdMoRG8ElE2n1FYgMBO+pBIGNDpIixBjeDqsI?=
 =?us-ascii?Q?YSLQJ8tLNxgLS11IDkwWUio8IHPa40nzRBf2kRq/sztzOogEcLJkLsgFJmCp?=
 =?us-ascii?Q?HZ/j71yLdbqH/mA3aW/ZG5ujNLtk0bBeeOwizXLrQrveWM19uf9FTdVdIN1d?=
 =?us-ascii?Q?8eGpcoTfzGtaMBY0fNAvPv5wTpVy/aSclEP+lSzRxCtdnMJA1hZXB6+oAick?=
 =?us-ascii?Q?WJrbh8f06tiQFcOtj93KjfP6u2xZO1tiugST+1kVdnTgOwyCjnqIcq819mvW?=
 =?us-ascii?Q?wAVCw+awdvVVmO1AB9IWp8iyOfuL9aQ9YLg7MB5LMSdkaoW7m+Kt+eOPPVPM?=
 =?us-ascii?Q?PaVjMznya5r8KZ0pYyx5Dc8WyvlTsfEHTjOzrW7Tw+R9bg3krIRyDdgOAlNV?=
 =?us-ascii?Q?kcMIC5D8qgU6dwh5zm+NTX9Ej0VjUxx922KBrpTEFWvhwg8j5jVaFt8SCaDK?=
 =?us-ascii?Q?M2/RLVHgHoosalB71N70uONorQ3kRbMWy4EYuvXcTuxH1vTIDlREHekVXP8Z?=
 =?us-ascii?Q?3UHiGsPLJyOKQi1z+IIPWqNzVVSGeYTzLztHc4nplJwXNPv2ExsrlO5Wd/W4?=
 =?us-ascii?Q?PjUWdBczymxduPkiIuhCqf+cQVNiTGE/ohPyZxfI1wp8mnjYVvESbf/aU3Lv?=
 =?us-ascii?Q?MOZrv9kcrnItwxB5Cfyus+2TaXnJvHiALXqxNybvo1wS14g+inAMjQl3BDJO?=
 =?us-ascii?Q?9wpSRSPlkp59xcdMNHh+ak7p6tEjXnMsmwUmIYkwiKjJXLnhbRuFzyo7+eO8?=
 =?us-ascii?Q?cX6+MfwcoKV0nulpGjwEvEpFf/BWELdcFGzPlZ2fscoBSbxRn3WKVpyyiGLK?=
 =?us-ascii?Q?b4qluIovWAT7c6XczPhFSao3PreH7mlIVZXVcWEBVaIcabloo4EEjg559tCT?=
 =?us-ascii?Q?j0T5RD5FRGrbNKAlwdjmZhmepACCrYvZsSkYQMxASFgkFKDEshIuCKAoNMqX?=
 =?us-ascii?Q?RZwcnJfcAzkEzZlTEEbLpEevctsORhMTEoWTVRlE/I12Fbk1je5iwLTi2HOS?=
 =?us-ascii?Q?pgZSW2lMiVfsTmKjb3tUevfP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bb573e3-d7fb-46ae-502b-08d979153447
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 13:23:43.0757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Cnb43nMcrWj5YN3j8edvfT8SoNCmiqXSW8QwoUixzBiYXOHg34myRSrTx5PlIwPfn+rsQw3XMDdpCyCh/D4iO4oc7c+s2AAcbIp6QXogRE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1615
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160085
X-Proofpoint-ORIG-GUID: N9uF9-Y2nsRaqm7MxQ4yRta_9eJvEf10
X-Proofpoint-GUID: N9uF9-Y2nsRaqm7MxQ4yRta_9eJvEf10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The limit should be "PAGE_SIZE - len" instead of "PAGE_SIZE".
We're not going to hit the limit so this fix will not affect runtime.

Fixes: 5b9e70b22cc5 ("scsi: lpfc: raise sg count for nvme to use available sg resources")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index b35bf70a8c0d..1e5a30eb04de 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -6204,7 +6204,8 @@ lpfc_sg_seg_cnt_show(struct device *dev, struct device_attribute *attr,
 	len = scnprintf(buf, PAGE_SIZE, "SGL sz: %d  total SGEs: %d\n",
 		       phba->cfg_sg_dma_buf_size, phba->cfg_total_seg_cnt);
 
-	len += scnprintf(buf + len, PAGE_SIZE, "Cfg: %d  SCSI: %d  NVME: %d\n",
+	len += scnprintf(buf + len, PAGE_SIZE - len,
+			"Cfg: %d  SCSI: %d  NVME: %d\n",
 			phba->cfg_sg_seg_cnt, phba->cfg_scsi_seg_cnt,
 			phba->cfg_nvme_seg_cnt);
 	return len;
-- 
2.20.1

