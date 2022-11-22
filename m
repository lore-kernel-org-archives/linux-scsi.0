Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B8CC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbiKVDnU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbiKVDnH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:43:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0B92A721
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 19:43:03 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM3ZVTA003638;
        Tue, 22 Nov 2022 03:40:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5nofshYxqzXBhNqAIG/J/gVWIRoWH3JQAkPTm5/r5A4=;
 b=QfUYs98R5qNvhSkT45z8Kk/FlSLwzVM7+cg3iDrut0seE+/mAiKw/ySYNzsnQB1O8LaE
 fhkMdJlDfqGLhnnk75Z23W6vvt42ElxfM+jdnW4CqlkTJDF4tmuVqJEBF6rJi4e+Nlps
 QISZbaS2BPrTRlfMOs8WWiU8ihsTj7Q42cgh8mKkIE1ZHv6dZldTVBskBgRxKTlouywN
 Ky5I4YdTsYrRJZ6PC6+jVgEThH1aTH6n/ojt7J1aETCNvb6f3SqMM/bEXVPdahe2Oh+w
 qHzU393fOraVROspIpJho4eeYGKJol9BF0Ry6hfIIaMcata8WlP9nM1Jy7EDgL+1o8Ce GQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0edq1cdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:48 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM1HtW4039501;
        Tue, 22 Nov 2022 03:40:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkb0yjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DE1Qlc2JFFrvb0MpLzqrdzXkaC/5gLNHklUUGuTEfUtw3+CVA2v05uYuQ5pBgmx69dmFrJW68eN8ecLgHWC/Z9BGWFx8PCr+xVGmS6AzcKugXxCP8UENC4UfHLafT0CB/j2NnwiyiSr2L6Scw1Qdoez/WpL84ss0SPY9nGxOeOyplycuU5ZjWoxC1g0R6aEk0qryNbzRdTEQp17Wu1EnBGaEdHb6Ac4n7SegvSmR8BLOZ0BHw1u4mjirg+WNs67p7Q/UVfqsPJFbPNx1ReT3iXkaOIBin72RtZx37tyXuNNdbt7Fh+0w+RV7qVgk0EAaMtRpvh7gxrl8yITfF0NtWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5nofshYxqzXBhNqAIG/J/gVWIRoWH3JQAkPTm5/r5A4=;
 b=C90+Hq2AzYmh6xtv9I1JMCedOAiMVsAH94YdEda+FNUqtVYyXZcp/kkqChymcmUxK+MbKT+yeW+yYiAGUSqd259brzXI5GJomqw710YFSfBXqFvA7p1H1YpMVTKOBUDSpaStF/KD9hB4rfCKMug6zhO5VcemWDhfdmv/aqtHmt3UVe05nCPSBH0Xq53j2YpjgINQ5fq88kQldZ4puZo2YxsLFk+H4PlUDeL3Y9GsuexnEoGr3kkmhzeJaLO6SGFgjOMb9XenXL0uabAqBefqkBsKnZpUsPHHgwNz7BaKadMElaDO3CtzaQx42+6eRf8j1IGVAzuHm8705IShbEKT4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nofshYxqzXBhNqAIG/J/gVWIRoWH3JQAkPTm5/r5A4=;
 b=l6YGkhMlUB6wmsbmzc38ImAMn8g/5hQ1GJXzLKZNkRjtmLsMe2K2h20PNzdLLZm3QB/MSKRDtIXngAGnvgfhuD151LtTPzsAHOdRqUGbahHa4IBr4/Ha+bwKGoVu8kKYCb/I4VtxVv7rtxIb4sndblwGeaCmmcLT70gtQS/6AY8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4472.namprd10.prod.outlook.com (2603:10b6:510:30::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:40:45 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:40:44 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 13/15] scsi: target_core_pscsi: Convert to scsi_execute_cmd
Date:   Mon, 21 Nov 2022 21:39:32 -0600
Message-Id: <20221122033934.33797-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122033934.33797-1-michael.christie@oracle.com>
References: <20221122033934.33797-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:610:cc::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4472:EE_
X-MS-Office365-Filtering-Correlation-Id: 70868683-161f-4495-32d0-08dacc3b562b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IvYVkGFQFFvrHSXTt7rzKxeodsFerCxnUNlOs+v1OxSUqrIQ7ZPh/jMJJhFYMpWnnPAOmnhYIy0rwNDeK+eSPWi5x+IFZfHWRr6DHYZcjNyw9DJSiZYxMk7EjEppNsatYkIJtUkreLZjY39dRPnHYQwItY9+Znw/4R/EJs1N4XpSU1RuQD0XS8HLBVcwyaR//znt1aPkidt3CZj2h798pNYaMhdTexPg4w/hEsngv9MjaEpxEQqETommHQalu8noPNExkGAxxNclv5r4lIACgNjU3DL0Y2LShN3LeDqqXG4sX2L4l01IppZDviQKOiKxINiLqR8sNjP2n9o/tfXijS2hjAcEiklr55dl/JcTgml1YGQajppCfDAz+xcdN/wtafaoGzwqrkQ/yzMm3/jB8J250nFPHI+i3e/Bvs7PEwR/5vUdRhEIL4Mn0UKhNgTnWjqic2m7oZiJYdSZvWPiN+Lffpb2iY3Ak0m2Az1kOGh0M2efTsEbsXSgDgsMmRq08N9sMO0PMJ/YCwzNkl/wzoXBoXEHwGhMMiEbcrGCzuCJn1P+pPYbDxuMEDCGt9FWWv3CAJDuAGxhhpb5sArYeCCEv2J5uo12+SNvszzkklZkSQI/qhVsY3f7qTkoUoTi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(36756003)(38100700002)(41300700001)(2906002)(83380400001)(86362001)(66476007)(6486002)(66556008)(8676002)(316002)(66946007)(4326008)(6512007)(186003)(26005)(1076003)(8936002)(478600001)(5660300002)(2616005)(6506007)(107886003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GsTq49jPFnAWSagxsH6SYU9NkwnN1PdovSi1tQ3sp+UJrj4TuFMH6y+igNeE?=
 =?us-ascii?Q?KtduaPHorfiF6oCpwglFmbXrlQFWRaHfWCreWyHfepBH4xTGhWe0ifGfjHUd?=
 =?us-ascii?Q?ykgUiGQ1yRwL7W/fp/HJpsiOmkGWV70p8Uc4JjirDvhx3CZFWT0xPohHSgmp?=
 =?us-ascii?Q?L3XRmVlN2CAdtzUU9Jt9ECfD5FnUS7zW0Ct3Mo0mXFHTe9JvG1kglVPLxeM0?=
 =?us-ascii?Q?48YC415dxdxdneV4j7R6lKZ43Ic05m4uKT5ms9EnEpnldvowxe+Ay6k486DL?=
 =?us-ascii?Q?RePAypKYlQM6WX+vxM6XsjzuuE9OY/d17jjpnPk65sCs6FndgAaRpECBI8gg?=
 =?us-ascii?Q?fslIdyDbAKBikn679s6U/rd8fJvUF1oYqXhtiIb2n0XM6PxVob6WSAvUMKE5?=
 =?us-ascii?Q?yqyE8OFl9peYkaRwCf7UXZukNUKnnhyE62/Nid2ZqksU9KpYve+ENB+ySyyv?=
 =?us-ascii?Q?mt108RsAtD+OUTanqQ3uvCaZznRcm7BHNR3FZgmEiPuQphWv1MlJN8Vnq7EE?=
 =?us-ascii?Q?VZfGPP+LVs4o1mJqLsFofwS96ZrSzaLYxjyTOJlef8q4Nl2fruYsGv7dUD13?=
 =?us-ascii?Q?wcdvNZwN9bYZHXanMumobMLPMfXlZRS07sG0dqtOarSOJRdSuycmIx8CYAtD?=
 =?us-ascii?Q?y8Nj9L1QveXMXroZoJUh39Evcg1CjwXK3TYGJwH4aG+DdFeMkokvBS7/TAf/?=
 =?us-ascii?Q?6qaXeSjYbJ810NIU3FtmKeoxLm5bFPrZilTfhePyJsPOBVmz3g8HJK3jAmGr?=
 =?us-ascii?Q?5iGsEzblXTqKTOZaAjoheFdZ+vqbYmm3sV60XEj2p3SXvyTctcFZDfhKXt2P?=
 =?us-ascii?Q?6WkLJgvFGIEuNkdhmg9CoxcbupkvqxkUf3iiQ4JNcnumcuuv1z0wX3pJPO0o?=
 =?us-ascii?Q?DH11DKufEaWYWupJk7gHRzK3wZSff7b2SgPcyRvGF0z7anCDYDRLAE7aNEti?=
 =?us-ascii?Q?+ezPlRThx3cRDBgdagg2Sg41VvKIV7Xj4JPPqseFi18McJXTwfIXFS2WCwid?=
 =?us-ascii?Q?PgqP0RdJ9Vk678bM/cjDKYevPQyOG4tN54YJSVh7yVDu206jXsSzXwx/ZGb/?=
 =?us-ascii?Q?9CH2eg1k944cnFHixDAUT8ZKr5X9rwaN+fzugXssiypUebdeD4eOfsS4tZ0H?=
 =?us-ascii?Q?0XroyPSeBAWHzoY4+byXoKQQW58+DvJJu9oExuYtBL3NwhZKns3WhSuUllut?=
 =?us-ascii?Q?KhwhKr0CiFJsB518x7bW5WXKNPooM34elARvwB+G93Lv+a+sNTbXHp6lVCPu?=
 =?us-ascii?Q?hBooQqQyDlJ7GQsq9W+hahL+Dwn45B+ZX2YjL+/OULYc+vhFww7eHeDxrWts?=
 =?us-ascii?Q?xwHoJJi/reznmGGBeSSAkHIbG830HQi/ldqwwSlPrO8Hi+95Jax/H+w7Tiid?=
 =?us-ascii?Q?+Eb0jLdEBEIY4cR6JCW+V8D0mEiaEzaI8eCP2pd8zMlQtbP4sE+5xGeEx+Y3?=
 =?us-ascii?Q?Lb1kmxYvWIF7zuz4UKR5hfpi50OV5CBwGXI1OHvsU2BwkncnT2p5RVvI3a35?=
 =?us-ascii?Q?iUItiqFiZz20w9dtmNYLLci5i/L66ZMYTyttB0VgXEN0ElsC3ml2F+DB+wuo?=
 =?us-ascii?Q?yUWX+jM+iTZ7L1rmP66NvUfIWFpMTwuvccWJC1R/BHRNzgcmon/TMakhVJw7?=
 =?us-ascii?Q?jA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: zJwmo8m6JaaaEQOKeMXGt7lNNkVldTtL/Z/vRCcVtxL7cngOFHOnGlUvPTYMoLijjrsE/pZ2NQP4UpRKc3+gbTXcnit8ADJyiTG8aXitXkvh+P6Lkc5NhgCBZlldKbMnAS0iLJ4J6AuMhGbau/4cT69fkdnTbAQnyOdFbUsOKyNxoLiTFFXUYW5lHSZf9J2SKnt8BnWuPiSEAt8Q0DsoIG/+tM6ARM1nUDLtaegxe0vA7HsDJLfRvHVxMQE6fwCjZmdtooDzD5V53RFID0hkJXMsHAc1PDtC20N9RE9xf306To8RZUEB5DvCRaxghWbDVlbEAqQD3YLS+sA/U9vkK/XK1ggeyf+HGmiD8UksYO1FUmD1SCJ8vnpEXzO8BzlDctrO6vB8tMWhLd8gDEfI1PprMSx/3Kyr3G74TLs3ERp/RrxiK/SpARRG+hI8makKmUnYX26vCIVtQ4cyQTd8nr4iRw3/y83yy3XrhYOuHrzx4z4Y21G/hm3sUqCkL2qTPJ59OkuaODX1T4B8xBI42YfGDOEqY22YGxHuFRI6zxSA3+Kh+AHGtlm+FRjt50pxegdqH1CmBBBk+fAjR/4+Aca9R2/1eCmDnX+fWyW1DMFzRW8Zvhl6iJjRJx+kcV4KPVVGuCwRNchuE3PBrDW7Bt+eLajKswG6owKM15PPcRrRInR7WDz8ddaj1Fk/Z6jtYgPGlQoPnJT4Ths1eX4IkBS3iJhpRkgyBUfmOrsDQDX2z9f8Yf08jbAK4TMPnTZpHsWMVXM2nC+Jw1+rFLf/xHYoluuP1P+S8p10PvG+cLSJ+RwfzhjOYc3wjXEBqk6TJY8sdxq4pGisvk+N5bsdXbKZKUWC2WCKiU3QLeljRTdApRzBQQPEiExTyONfncqO
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70868683-161f-4495-32d0-08dacc3b562b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:40:44.8248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mWLBozWbQT17SoynUKWY97eYgzlHTNXH+ZWGZT4CiHBn11yvz4xKxDcnXWfarWrprmB4yelRtLn6aQYG5ajf6X8gWzEL71HNgEKVZEz3zJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4472
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211220024
X-Proofpoint-GUID: kQTYXKwusdBjfhclzri_9g5ZWjLRxClf
X-Proofpoint-ORIG-GUID: kQTYXKwusdBjfhclzri_9g5ZWjLRxClf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert pscsi to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_pscsi.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 69a4c9581e80..f0e4813627f5 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -144,8 +144,8 @@ static void pscsi_tape_read_blocksize(struct se_device *dev,
 	cdb[0] = MODE_SENSE;
 	cdb[4] = 0x0c; /* 12 bytes */
 
-	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf, 12, NULL,
-			HZ, 1, NULL);
+	ret = __scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, buf, 12, HZ, 1,
+				 NULL);
 	if (ret)
 		goto out_free;
 
@@ -195,8 +195,8 @@ pscsi_get_inquiry_vpd_serial(struct scsi_device *sdev, struct t10_wwn *wwn)
 	cdb[2] = 0x80; /* Unit Serial Number */
 	put_unaligned_be16(INQUIRY_VPD_SERIAL_LEN, &cdb[3]);
 
-	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf,
-			      INQUIRY_VPD_SERIAL_LEN, NULL, HZ, 1, NULL);
+	ret = __scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, buf,
+				 INQUIRY_VPD_SERIAL_LEN, HZ, 1, NULL);
 	if (ret)
 		goto out_free;
 
@@ -230,9 +230,9 @@ pscsi_get_inquiry_vpd_device_ident(struct scsi_device *sdev,
 	cdb[2] = 0x83; /* Device Identifier */
 	put_unaligned_be16(INQUIRY_VPD_DEVICE_IDENTIFIER_LEN, &cdb[3]);
 
-	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf,
-			      INQUIRY_VPD_DEVICE_IDENTIFIER_LEN,
-			      NULL, HZ, 1, NULL);
+	ret = __scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, buf,
+				 INQUIRY_VPD_DEVICE_IDENTIFIER_LEN, HZ, 1,
+				 NULL);
 	if (ret)
 		goto out;
 
-- 
2.25.1

