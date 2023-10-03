Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D4AE8FDB8
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 20:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241089AbjJCUvQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 16:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbjJCUvP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 16:51:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC84AAC
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 13:51:10 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 393I54qK019675;
        Tue, 3 Oct 2023 20:51:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=aUEazPO19jsmAjR7IDQiI5HKb/28GrPnYqAxS4TmsS8=;
 b=vD/nnf+8pFYzdTR76qR9DSDkrqaKGVwxt5iMlalj8gWuOQOu/swywYOWeAn2pLD6UbzZ
 Jaak+mJ+VoGyym7ko53AQ8+10N1nVfxfHoqPRZp8Q4EoEm0g+GtrHge25KsE19NQhL9u
 PnJ07LdxM6PECvMsoRYffcf2ltOZ4sSYFWjz+Reu/Ayum+WZJLqKk/2VOo/qubbf18Mu
 gvfdfDt8cBCPZxHuhIIt780gZsGgGw/7+4OouKHBj5tH+JZhk3kb/PoMOay5+ScPRR0J
 WE8tGk6IH5+yWyQ6rVEj/BNEkdEDWElhFlni1T2hz2X/n8tbwMuLTs/P6azQYo0aaBw6 +Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tebjbwnsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:01 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 393K0bYv025731;
        Tue, 3 Oct 2023 20:51:00 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea4d11hd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZPZE7MC8I2mR3dEk6UbNfHCqYNs7aRGI2mXyHRC5sOI6bOJ9AFpcY4bLr/xss0z91oo9ikEGI0k/FOJ9XN8Wlu513bE6oW5zh2sfcxZN3TeHv7xiqHognU6lyv36gJnKG1jrm8uIqBr0trV1Wn98q4FMrJUatb5VW8o6kcJmJC7MeM3Tc0Jcwcmq/VtT1+EPReIyDhGfZ5mz+44QDarxyw0HZa1876y7tO4O8Uo894H1g86jvgoavWmZJa9N9pLoP6bLpDsz4z5pnzNtpGNHFocHqOnEJcV98tx6MMjL440WuFG8SXE1SOnr3InKljVWUYg3wJjKe5wHUVWvGHPxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aUEazPO19jsmAjR7IDQiI5HKb/28GrPnYqAxS4TmsS8=;
 b=dAmDt02gxWbUzWQYmTmBmbxh643y+HSW83TZnC9i1rr8bUOMCfO9K03AO6bOw7MZaOe4tT7K+OHZERzXNtPXSZi1KT33coOnDmPlooKFin7g+f1u8ZcSu40Rh1CpId0Ce7v0kUhrdjYhO6ScVA16jeDM45tEIX3zw3Pc/abWETIRQCqFMytiH0q72e61Iutg/5kHxCQAP4Ef/oXHYZ4a4/t9g9L6OrC7zy/ycRlwVmU1FVhmhhszxKyxb7CM7Ctw7KOxzjNKSDVvtb4oB02sKlhyEcUy9oGSxj8k7VSv4upSHRv0hE8sVB22U0msKJRRx5rKvcXJGCFlikM6henUDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUEazPO19jsmAjR7IDQiI5HKb/28GrPnYqAxS4TmsS8=;
 b=cFuy0lLNESxPO9cjkpWjBvbR3PZA2xNfTvJiUVhxlVFy67YZCKCfB3Sy+Aq78I9vLcfMb9V5H35LGkS0/y9l7pnQS8Lpoipa2gDnNkwusCH9j0BzlhBbh1hz+9V992ETtRMhL5xlgEtrTNwWo5nU5TJ7vko6pZc62PT5IJxKp8w=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6794.namprd10.prod.outlook.com (2603:10b6:208:43a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.33; Tue, 3 Oct
 2023 20:50:58 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Tue, 3 Oct 2023
 20:50:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 01/12] scsi: sd: Fix sshdr use in read_capacity_16
Date:   Tue,  3 Oct 2023 15:50:43 -0500
Message-Id: <20231003205054.84507-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003205054.84507-1-michael.christie@oracle.com>
References: <20231003205054.84507-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0127.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::29) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 09b3b919-b7f9-450c-2eb4-08dbc452724a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tuj1ZSp+fOXDW0Iie28CMwlnn9zZCDX9Fsg98dMAjikiJtLjEECsLXCg+jSTMTejk/VSm5AdANV8KEDMMZag9Sum48GoqEhVwjjjLcDKcBYhJdPkYBbpPjE6dk8z+MhX2I4vQzqUQLgry8sJowrUzFT+CgvZ2Ke5Alu0iUQH7/Ja8D3jiLUelm1QUCJd0BYXL9NuX+f+R2Ypp5CCAHvXnYkw8q4DIstBnmPIhv/nO785qy51o1TGlVgJm4z8TNeO5xOozfDREtZjJObj4P2x4Stv/QmOjITPSrdC+ga9BQlnQXph7GSME5VVFaJ1H5mihrOvmzcBHxt1dySJucVa4mDNQfJKD8lFXq/kd/iFpr4g9jsDLkJ8oPUNNfUQZU6gM261KgQcvaxBEd3GdNffv7xih+YHuq7SCil67wxrRn9hcpOhAKYPNTkuHz+oNCOJMPY4Yyi3TSdxEFznOAYHWKf/M3/gI1gijUzp0XaOrKQtYt6LW4/feIpz3/y+rPt+DliukqiPmIlN3nJZYItAQ/x1akXARepWP6A15smr+Yw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(396003)(136003)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(1076003)(107886003)(41300700001)(6486002)(2616005)(6506007)(316002)(6512007)(66556008)(66476007)(66946007)(8676002)(4326008)(8936002)(5660300002)(26005)(478600001)(6666004)(83380400001)(38100700002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ve3cigjG3wxZ/8p9rteY2Ak6IS69vDOglUdjVnHw8F+6sNn02/bICH/UpUjk?=
 =?us-ascii?Q?iVN624vQ9XPXB9DZQjQMSSppV5ksoB57Y5H2xIiDFs9c0EC8+bO2OmQQZcCw?=
 =?us-ascii?Q?Oq2I/xv4So2aFrJRSbaJ34um0XAJu9m/j5Z4dR5Kw0f84t9DpHeZnr1soT3m?=
 =?us-ascii?Q?mqtHJY/B4Ew5ZAb9ChFwQrwNYxUfaVWMUze2V/lHtlG0r/oliyyM94TogeHA?=
 =?us-ascii?Q?LTHT1nvRadbUgNHIChnvGnje2eRWBB2LfKyVsH129KvF/y0huydPwm+i70GB?=
 =?us-ascii?Q?ndmfEzcZQS9LTSaInbt8lzfvOAeAbOFUz0sJOJOCbZ58cRCIJPq+8G0sgmS9?=
 =?us-ascii?Q?WrCXmWU3glTbz/Gr+VUqgjt2EhhsxOQa0h4hmr0pitpBz4nzRzh6WhujNVom?=
 =?us-ascii?Q?Xwx0PSXVx2jWGqqhDk7Fz+tJ55aOrTGCP9o68AW+D9u5FjsZsBJDmUoD7B1E?=
 =?us-ascii?Q?SSDT4uP6TT5/I3bkQ0i9XBC37epNGc/rTFqk3F9Yo11CTei5CusWAN0kdmX9?=
 =?us-ascii?Q?Mx2xcgyq/qkxKOUr3dgvQViRfeGibsdD6nPY/vSUPQ2L0OgKnG5eFDc65vow?=
 =?us-ascii?Q?Crdc2fwx/Y0fCzqdtFwN9x9Z8OoewN6zDoXfrt4k16WRx+bQcL7fgVYPG48J?=
 =?us-ascii?Q?u2jdcDuzZ9FGaEcmeryA3203OZ2OYyNbLuckj0WmIpbC8GXZ7yfYBSLPmbH+?=
 =?us-ascii?Q?qFC81117UUX9TCfrfpVrcPIdnscYBGPcoYwV5f967o24rJMN/aE4geZM7bij?=
 =?us-ascii?Q?ww047hmFvwdwAvp1lWsjKGKcgwr5/C2iYI2VNJTrDt4eM5OJ65gPXgm8I9a3?=
 =?us-ascii?Q?rbL/fWIhdOSlecGA8GznG8MjmvgZZFds67wCGyiWbe7TkQ+xcpBvMDZ7u/ew?=
 =?us-ascii?Q?lHBXfFoAyaS/JNrXm8BrfrPVyOtlWz2ojGokie1c4otcpLJoqKsrWKDlh/eb?=
 =?us-ascii?Q?ojBfJ+9hCZSwN6nGDhwEjpoYb+wKv/faJYKO0KX0pIC6eHW2gklGA62pCf42?=
 =?us-ascii?Q?hoRakBGZ1+yGNhRCuUOHf1kW1ls/o1LIJh4ULoRI7vSKgnsW8pTUDD09qnOI?=
 =?us-ascii?Q?JgUM3V6L5A2ZgBOu7V/i7+AnF59q44eoUIidEN0gQUpmGth/MqzHaUsN67fe?=
 =?us-ascii?Q?D7tW/7J3HZfAXfAGfcgnnvTrh1vaP9+Rx+nC5FV13GbXa5fdmRDBkvflLx77?=
 =?us-ascii?Q?fmSSWEbcRZgP9tCX5iiobP0IMJhDUXfrlplb4jBDIYgKPa8weIj1UWG8ROr2?=
 =?us-ascii?Q?oau7fpzUFWL1iQkzKYl08IB7xEDJ4D/F4dsvq9TaaOqwjPnoLdnkv5uh/ouo?=
 =?us-ascii?Q?3SXYUshf2Nx6+ba3rAW/V6rDr7XmPWbBeLdkMRyrYXWfa+WAnES7KliaLcf+?=
 =?us-ascii?Q?szVQlSbVPoucqXp7LG1mIRyTzU7UnWLyBh4y8q0gDhw842sbaMh/Q4oGW8S9?=
 =?us-ascii?Q?UAwc0zXdA7QvW1KDarceMsH6VAyzwwhz5KbMzpf7OPE+bQUfbIlyWTXqfu5z?=
 =?us-ascii?Q?DmNfhX2AsXTBlhHK500AUKRocypTRomIRn2gPxNrt/TYaky+KLE0RuI9wJ9q?=
 =?us-ascii?Q?qQfSJLknx/PvpGlv/T3dnjAyZoR5PtU8hNrtZnNiAH9mel3m5F5TpIZXvZup?=
 =?us-ascii?Q?1A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: AtByhag0Hkui/7nRHjjDad6O6tlp/Ljjcvmcq4eqmPcqH1ZcUjP5XGgw0rn0qbDxBGe9GQpdOWrygu8vR7WfrJur+HateT5OBiYEDq6wAEHw+BkE1HyFy0hJH489SlFB1FOwgh7HkKWa/Z7VAI7xHHZAqDhPh4q2kPY0cca5ZTVAZxK6dEdt2wtFGotbwbhlnSC9mGq8cpujXpOMcbyiDwGieEbPV14T1Avqk64Kn+Epp59dPhWuEJ8W0EAm8RjTM/q3+CJ5+drPv7tFqvvqc6LekN/OSVnDYEng8v5xKIjjmKEt4g7CDw2i0ycuV7mgB/o0lix3mqmmZqOOFWaa/zPyBxgcL6wdHtXEqtZKwS1RSZQo7bhEZJDHvB/mfdCunDW7zI+5Hz7qghLEp/g9lU+j7QBmGdEfIcUUlbNRSPR8thfD3BmCMxtr1qaWtV3SZ/SHWra1xE6y9SbRdlXTaxv4NWSy/L5yV5z10RonBBCxRi9XruQu1M4V/iCGQYQNF2+h649ABb3LAx5FrS7+HpSt0MIUshki4h4NG4m0i2xt1ngeNkj+naaNWlb4yZlbNg59GCIkom8Mcc5zTbPc+P1alxnEIplcQ/j4SbhELhpqStol76Kos0BDy4WWhgDC1C9apo0TFqbCp84ZEQIPUOTA0Ee4xbRB+Tspp0grc2XwtBvqhF6KfYGNa6T5OeHND8e/ZpILoN/Ws8YI8uce11XLLRSwqpQY7CdWE75Q9ezzI+dyeRTFv12wHRsQ26xrDFkc1VPAcrEYaAc1zylKk830yhL1M62Qv/56FypsZdtR1JzojJqHk4FnNpuoPHYJ8fQqBkMG1M6MjzfFS2yY6nbGtfgvMwwkMFJwaFl7ZPquVuJlt3gDwwMmTuBHpU3I
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09b3b919-b7f9-450c-2eb4-08dbc452724a
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 20:50:58.8009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eqrY1Y1NpiFw2U5C7ST464y/ErEtvUvYo5axFJSFHnX9vVpAem1FlDwZTvcH/+yFBSivPbaQmV1WZU+Qtc8UAi78LuuCgABU81JFKU6ta6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6794
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-03_18,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310030158
X-Proofpoint-GUID: v-4rcGU90P19iVsfGiTQDymRC5OTGluW
X-Proofpoint-ORIG-GUID: v-4rcGU90P19iVsfGiTQDymRC5OTGluW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when we get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c92a317ba547..cc78b5e49f32 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2388,11 +2388,10 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
 					      buffer, RC16_LEN, SD_TIMEOUT,
 					      sdkp->max_retries, &exec_args);
-
-		if (media_not_present(sdkp, &sshdr))
-			return -ENODEV;
-
 		if (the_result > 0) {
+			if (media_not_present(sdkp, &sshdr))
+				return -ENODEV;
+
 			sense_valid = scsi_sense_valid(&sshdr);
 			if (sense_valid &&
 			    sshdr.sense_key == ILLEGAL_REQUEST &&
-- 
2.34.1

