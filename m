Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5BBC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjKNBiS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbjKNBiL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:38:11 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC601B5
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:38:08 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNs3pf030154;
        Tue, 14 Nov 2023 01:38:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=CDWpIPIdWSUdGwwTJR8qL2jDZ+410X72bl/pqP5LwQ8=;
 b=1cOL+LjGpgXf25SEwYF7xSrqQEMlg2vG0oIpN98pToKYuEAyqNtdeZozT2/W1pA7WEuV
 2JHuaizKhoY/HLY4XVF5Nh51T5LngIKuwKjqCxbUDuRo0afBomEBw+XGXeEPQYSpsCqR
 eSoBarLwRf8tAYEuKKh7cOr96t7Jw1a6512AglC2f+bU99H09BwebIb4WoqO4itHLaLG
 HxzmdI8b3ydkvfPUeEwceM4RQSYJXR0MToUDW/wfFCa27CTLqLMFvcxA8Z3WKqyidwpX
 nv08V1/lksKbOAe+oQw2NzLcP/WPDiq+Dv9BYmb6aOEHEKkrA4ky/jOMoGCJV5L3lDO8 7Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2n9v56p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:37:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE1Badw022702;
        Tue, 14 Nov 2023 01:37:58 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxpxgwjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:37:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcyjoouCcDf6n0DuBXsW9hFCVa/H+PENCrcg8rC7b+r0gwO5TbC/9UqXz/j2mlMJ9iYieSdYf5Prbhpwwiexbd276nW0s5CpgUOxiQew68awCNNhC9WkggAj+PYbAClCxUkENAYcSrZeIjyleIU6DwRQcSVpt/hkzR1SRMA5Pf+zTn8JjJ/vs8d8kL/XG+WyF3wf+Rz9Q0yQfWWXrXc4LixvPWZ676ecLyPeXLlimuZp8utaAqZeeGGNT1PrLDt2tvDEgj080YFFQvEnOCyM429fHLIGoJ7H63Mpxtz5SDoIAQpypuwFawq0Ppk8sWYTTn6qW//Wro09LUUeBk/uaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDWpIPIdWSUdGwwTJR8qL2jDZ+410X72bl/pqP5LwQ8=;
 b=hX3Rq49504wIyaT1ozeqq6vkKKvhVJO/bX+OWOuuS5y58/dAIgFSs4TGjxiE4+xcfMqR42LNV2PoMDBG4etcRQW60FmlfmICobCACfNkC2OH1df3dv+whb8rwND1MOk66fq+WjgKlA3gHXgA507OYTlM3Z5IE34fIcvFFcrN3o4/8Q2JjHly/s3epGTSW/QrI9LQdEwpUYnfzi6lPzeh9zC8BwEU+FxPyA/6Lbhl+EDmKefJ+1lIgKD79UgiamcAFGYyXAMjdoGJB/2+3WdbwV6A0aT6E5+wMiSYphEeRdFUrrNyYubDJ8pO3ONLx5bnuj7spfzFiIemY6Ezd4LGDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CDWpIPIdWSUdGwwTJR8qL2jDZ+410X72bl/pqP5LwQ8=;
 b=Q3dqZsoFVC0F3CRDDVFUxKGWRRxXZLbX0t06Gi8MDTgOwp6NQwIIp2TNT9Meaz06Xzy2i+uDIrwCO6BSA9kt/jz639CGh+tH9pFgU+uvesTwylaCGsowBcp/jpoRah6gdjXhVy5kp5gjTASDWlXPtv/C550lIPCl8APmxi8xWys=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4199.namprd10.prod.outlook.com (2603:10b6:610:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:37:56 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:37:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 03/20] scsi: retry INQUIRY after timeout
Date:   Mon, 13 Nov 2023 19:37:33 -0600
Message-Id: <20231114013750.76609-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS0PR17CA0001.namprd17.prod.outlook.com
 (2603:10b6:8:191::19) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: d423dbed-d20f-4eaa-2cec-08dbe4b253cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VSlVJVu6MQPQNrpxJQVJ+kA1FI8rP03m+WzQx5OX8445GXJp+PbXgI/RK4GXtEns+PEtj0Gc87IfuLHhRPIQihvcuCA2xF09aqSUAQdGpnc3caswOnGB9XW21BYDlDzrHxTnQB4r3sKtOICoyF/wV3zHqk9uipkNz1hAzplA93RH/f08L1Kfy+mXAv+SrE5DhcP9HvO/kc1/O5YCmJpTicJumdv5uHbh4HHhl7trKf92zzOGRjKTbCT4R7x/+r7xTTSR/PTv491ZqpneXYEZNYEY/DyMDNv5FEcvemsHkIhgEvVoDAzCAWQ0PadEytjZR+J5BnoWnUE9hYXZxCQq8ZeJEo7NPqqAZSLsVThq/PtHS5f6s6JPDQBhVYZTPns2H7Nf349lyz2InEZ1M9uDdavVAt0iCQ+Lp72FUuRXn19HPr5wwbVrKuwvuikDEsMqowtSpkH2CfY0tXKOLAdzloL4clVEP+RkO++O2T+hcmNjHefxQPA/WnZsz5k++k37OqLzSTXjg/5DSI7T4Pq/20IlTtZaG3Re7Rz9C406byvP/F5sdo9ZouRf06aAWqTpwedA/A0SDy3UlG5QqTrh8nFcbqXUmUxWU8hUkzaCVgUoxVpLuRQAeQ/K68Uc+oWl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(83380400001)(107886003)(1076003)(2616005)(26005)(2906002)(3613699003)(38100700002)(36756003)(86362001)(41300700001)(6666004)(8676002)(8936002)(4326008)(6486002)(478600001)(6506007)(66476007)(66946007)(66556008)(316002)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fPgmGRZmui5TEoJUvUcUwjo26jqGtojF4fkCi1MykTR2OXYR+IEngoIxfa2C?=
 =?us-ascii?Q?67zf/B7agKKlByMasxsWZAvEy/443f1meqdvl0OMKVe77KosBIHn5s04pqJ7?=
 =?us-ascii?Q?VS77EQUYatrQJS2pZHJNm2EE6z6DStQI+M7RpG61dmmTzRRbng7AMht0ToP3?=
 =?us-ascii?Q?cj7jc7ySAUbyQDWqm0e5ROhIT1Se6In9PRjEoDEOc/KCLh4Sr5j/U0pA8fPO?=
 =?us-ascii?Q?V8200z/m12mB2K7/xigspAX2e2K6kALIiM45nymnNoqtsd4p6DIt8faseZAH?=
 =?us-ascii?Q?xuUmbmjT6i4/JNwB1ezVVsnsY451Z5YCUByvhpLfQ0V3jmX3EoVyqxde8zsW?=
 =?us-ascii?Q?3uxmuvOO894Ug/tLkDkrBQ3e2ZUSOnwWQyO+Ae5gcvkPxJk8XKASfq+Exp7O?=
 =?us-ascii?Q?uMq330Z2AEbLEVb12AKabMLt8qIZ5M5dgTMdON/fa5N6llKeG1hZK8E9blmX?=
 =?us-ascii?Q?QPtauY0LxtQEjNvriApcDsNb4U6eQWRETgnN6p3qWKcuX/zczlpK4WZ8ztRK?=
 =?us-ascii?Q?Z7+H5NJINgh9bYdEsK4M2cOLNVWGEstUqBa1DsJCgEgVR4U4R2xtON/LzWLQ?=
 =?us-ascii?Q?nk7Wb/A42jgY7rSK8b9G6hbyWXYxKOGWzs/WqlQVt98ppOt9XHJpn6RwkIc9?=
 =?us-ascii?Q?N/PVHe+ESWK4i3bM5k2cTNJsyJACETmg9qAOGqVTSo7XoOsxH9y4wJKrNkye?=
 =?us-ascii?Q?1Qnu7EiQUgCpeORDGP/05bk1RTNRcoqIjmRbBlZ4uYfsa57UsgQHNq6hrI7q?=
 =?us-ascii?Q?46Sb2cORSt/2JZlnrny+KZGHaLxe4JrIKESHSnXdVwJttAt8kYOB/VPeEmKw?=
 =?us-ascii?Q?N5dGdQ3NmzDllRznqG7eKgXpIrZ5Zt+Rep1zKZ7glEMgn7hwYqArsBo5OpDo?=
 =?us-ascii?Q?cFzGf53i0hXUHnb8yOwhaYIrErJEQRuMzqOvwED/93J/c1Iuvfb5Tnp4eb8I?=
 =?us-ascii?Q?nmgzx0O18qxLPLCmp4tgw58tkE8DVXjnmQ2Otfv9HwSCthBKjYQbv7u9WhFS?=
 =?us-ascii?Q?xECxSuoJVEASAaxlQxTRREjYuG5qHUA1eroFOwL247mgh5wn5JA68YTaizYr?=
 =?us-ascii?Q?ztWayGJj91Myf5dbpxN1peXk5WVculYAh6eHkebYb3oq+2N5InQwICnfFTG0?=
 =?us-ascii?Q?JrfHm9RsgzcOWZEXU7kux1y+HqmUk7WOHSMHb5geYVIyTrHJCyDbPqsaugv4?=
 =?us-ascii?Q?UEd8Pu5Xg+2U1tpgmBP5DaQU9xuSYb0j1TqPXbs2WyehkLnfrOxfIJ3ZWj2z?=
 =?us-ascii?Q?zRHPLm8nznrz2BpjUbo9HjmaXijoosuxwNQ/yE7VCAUgcZM18aW6Snp6aIcD?=
 =?us-ascii?Q?AAuQvweMjUGxZpULYT+EaS/ohypiNCRdF6JAuYGW7Fh17BxrnqWJhDG8M3YF?=
 =?us-ascii?Q?VHoZI4O4u8+5NO+Gi8bJb6WKUiZ80d+eE9eKggx7rJVgbrOTm7ClubRRs+JF?=
 =?us-ascii?Q?hlQfiibPwAPnAAogcX5k/22rVohRGVEMKEu3VcFbjnjDW7WO1+LaVD9uS3lD?=
 =?us-ascii?Q?O+jua61yRw6rqcTA2WRvBQjg7D5pSaJ1OQIZR9XH3aLG9tVfhqt0ioC8HKSL?=
 =?us-ascii?Q?iNdaKCZFzxYcl8ZrPRalPiU3MTMrp3D0V0vVLlpwDWZ6cIbjTOLzhE+pRl6J?=
 =?us-ascii?Q?EA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: CXGVW/XU3WczD1nw8r0Uh8N7nwV05XCIwD96W26J2Nrnpr3TbC5TkvGFcnH4bN5TosGBiLJSM5jybGWC3SlHZSVe1TzW3jxclAUPMjnUx3i6QqTeNGg2V7RPz5EAtDxKtFOB6/a4W7f2O20xD+dTQtW0aVKoNDZv/RXS0bblOkBb3h1r2/+jxWR1vHplrGx17/2fNQFW7k0JH1EHlMEfU/8e1q+lZxlYxDbFJjEbDvSe9GSwkhY9JLi8gaeDvgj8eW8TlW/Ns2mmBvrZCu9H+iI01f1GfTXn/sGZvFOMIPYRmfOAoCey55yOrN+WogO4Y+V2OzDT65zaQSvloMu807N89ma9w+EWswQwg3ZZ8nAA6h+NMspc+7968BZm9vdQKQaRDgjNhLhYyKV71KwOfyqGsaxN6/hv/WE5qWvzrS2Di3pxfVnZ3ie53rrTrV8fzEr9vfyxJ8EYkmDXCZom5bTGkloXZWv8yTxwU7lUFVsz+Ke61/St2knjYCKoWWvO9Tyn71Fe1GmRpqm8P/ILm2CBIy3Zz0u+jLOT1Qp+ntIwso3kospT4SRIlSEST+2fLqmR8KHo2rff8kM5dRxCI7mVOCHGC/WVoGCuMXadMY6pBGdVGAvXJLJvFcGIwgpS6IFmggI34qG+9n7CPxc0tsHNu7wDNgbhG1odpYYqfhF9ZqEOVwR9Pn+SfJj6et8ntPb9otDd8kprJrHM9/tQnn3CJNVghkToOjnWfiW7WEAe1NWd8dCqDXt1skXMO2U0lTj9/GDJHfaTsZPy6+15vlzKJzf8vedZz0AMpqBKoyJ1hN53Bhplc28WCffSkXu/XnzJJT/zabYgBqmteAXwhDkg8Q70WbfRNuvvTW98fbGI4erJOBxVfZzN85R8K8KW
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d423dbed-d20f-4eaa-2cec-08dbe4b253cd
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:37:56.5184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: urOWVqHd/LEe8kbq4oViGBfgcfi298Kw6KciOwiMR5kPSwKqm/CCLiLTtKt2q3SHOAtwxhVkBqQgEX4BGMV59PzmhWwb1JbI2UF44W6F3OI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311140010
X-Proofpoint-GUID: KWhOhJudI1nyO0tSgDYSlEAd8gSwNIO5
X-Proofpoint-ORIG-GUID: KWhOhJudI1nyO0tSgDYSlEAd8gSwNIO5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Description from: Martin Wilck <mwilck@suse.com>:

The SCSI mid layer doesn't retry commands after DID_TIME_OUT (see
scsi_noretry_cmd()). Packet loss in the fabric can cause spurious timeouts
during SCSI device probing, causing device probing to fail. This has been
observed in FCoE uplink failover tests, for example.

This patch fixes the issue by retrying the INQUIRY.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index eeb53c28581f..8da0990b2dde 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -665,6 +665,10 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			.asc = 0x29,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
+		{
+			.allowed = 1,
+			.result = DID_TIME_OUT << 16,
+		},
 		{}
 	};
 	struct scsi_failures failures = {
-- 
2.34.1

