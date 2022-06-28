Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B7D7CCA47E
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 20:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiF1UMQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiF1ULx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 16:11:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EE745537;
        Tue, 28 Jun 2022 13:02:55 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SJBVqU006351;
        Tue, 28 Jun 2022 20:02:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=vDqx+3+BhHBkQbg1kh9CEIH62EEnJrJ9BDupq6pbeak=;
 b=RMGegNfDvo0U9GOJapykfu/axd07lIds6kXZ36Th1igxQqbEpyNPEIjq5MVTuKz927Hx
 7q5GHik0wyPv3n2JTXAmaKdjSk0ULvF6DX+9SKjjSc1t0CLuI85B56b/jAF43VCt/mAA
 ic77Bx/aAEvCP8IcsrH7EN/ulZrzNfyGiBKj6Dv6G2LZvMY5IycXzb/fvgMinRxp1YdH
 h3x+0KLbsoLa7fYDXgvkBKpZVIQF/wSZ9SAlBMU9YTTUAr/H7NRrtGBcJYiFtFoivk9+
 tl+gooM7q+LcZ3ygzaH30OfARjTTYOg4ki69a8V0SStZqX2HeZIRD+VB2xONLf7bmAkc kQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gws52f6mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 20:02:48 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25SJtS1c033544;
        Tue, 28 Jun 2022 20:02:47 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gwrt25gqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 20:02:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4ICu2IbcPh6iZXcIPcToJnWIy2QmQQgx8RwqtF3YYuzzS0pvKsOzCnMYnihC4eaYtlcRbTHSzmKIRA9mD7RWhcyYcKRN+f0iv+24Jp2YUuhJNTt8rRw63+NSSMy6Son3C4WeQJ6iXy9lIH31l6ekkfZrWjBLM+65xr5s9lWlwViKnlqAQ+J2i9eWaEUFQqy3vO3rqf6/y1rFdgiP0KvTTfT0z2pdomKnuuGMZncDTKpM4eJquig91RoAwYL1WhtfKD10m6X1T/sO4j46h99jhZI+j0wxa7rWiAGP+rjhaA00zYd2Dbx/61154/KGC06sDne8uDDvlHNgv01jK5rtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vDqx+3+BhHBkQbg1kh9CEIH62EEnJrJ9BDupq6pbeak=;
 b=enJ5ffnY/7tYMaLWUTKFoiYcRErOHG5UJHbaa7BXMI2g1XjL0FnckleM17X5w+li/028wYyFbo9hHTXXB7LQolpTiHPlxZP/fhtJInbhHxdchNC80KN6I6z6HWE6aZikS8ZuVLTNxAPUJ132g/wjYO1B9w0cd9gj8lc0kEXSwXi0PavUQ+4yrV/xQS0eXi+aST8Q9aXCzRmOvSnQZl3R4GPFlLfVZFdJmThlUzbUYT+L2fmxJGK/DsBh0RgQZm1mHn58Ghj/1OpdBXsQ2cYVEmkvMmsSHwcK5NhjijXsYWxqzYssPnpFo0JnpZQDD7IOsypoDHlY9/FiGhjATCmGdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDqx+3+BhHBkQbg1kh9CEIH62EEnJrJ9BDupq6pbeak=;
 b=Em8CZT9pwGCt4GaleFgnPTbfak6CNd/6O8ZJpj+eQem9blDWwzHsEQjyCu3wsIaNtwmgHrkDKFG+0WksXlEe32he3D9zHndB2vW8QzvwPzdKXyeqruxJHXsoZKLtXow2yrCXtKtaOTWOIZ8BDU6f0S7SSoVGMz3qqgRFH+9fOPY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY4PR1001MB2376.namprd10.prod.outlook.com (2603:10b6:910:48::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 20:02:43 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 20:02:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@infradead.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 1/5] scsi: target: Remove incorrect zero blocks WRITE_SAME check
Date:   Tue, 28 Jun 2022 15:02:26 -0500
Message-Id: <20220628200230.15052-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628200230.15052-1-michael.christie@oracle.com>
References: <20220628200230.15052-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR21CA0019.namprd21.prod.outlook.com
 (2603:10b6:5:174::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c50a8b37-ba16-45f0-a3f9-08da594126d4
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2376:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m2SC/eZ3iU6ekQu/YbEakiBfQjl5FRT0ZeUAEygC9rVK+djg5K/KFnWnynnQPLKAdu2/nDgU5FpYPyOTPtSYNnoWqlYW1j1HMAcOTYkcJb11U9H3dVFCxONKb8YUzHxOYQC1KeCoEr7446TeqIzDNnvHXw4M5qnAt15W6NT4WkgJfcpG9tPhKVqCyz1tkivfHhF86qED5LRiJ3YQqAGsC2yrSS4hHM8DbOAG+OUXLde7vzECid9CEaEtobazdKzv0FFk7IJoY4hi7NQLHIcWq+mn3R+qcZe7O3noau2l7YGjh6bvaBO5vVlyqW8aBCW7uju6gdYkmIhSx17GeolfsVnjo/VMbdFFM7cdM6MWgTdJCvw0WG+HMMWQKLOK+ft1va441Lq8KnrvMR0NXzy6t3/AlxvEyEQ6NE+uZ2oNl2qONTzUmR7m70NCAum8c3s3UeIvbYe2VWAJPVRYbq7zqwj5hOHrbMUeu8aNkIisfwFN/klvZHjAMtJXn2zNJ1TEhbTeFIymqKqTllnpAi9AmdzEe9Q4KaLbx7tBL73Hwc72Wm7rT+1WV0YaJ30vuxzWVVmW4niCyti9Qd142A8tiWkVs3fssjABaWiPD/szMaxT/dBUsJJjt+4oQpUYmidR3LDR/G3G2kOk8cqAN47yeGOMVLTrBDhUc6X4MHMmau68g+WzgwxCvva4U9RhQG12AGaAhWYXKl8U+9l4m+r2c4Io/CP0CBR5fxHpG31zRbxkV80OfXUKnOcp/DmMsr4D7qByL4wb9bOJSKTT4HMTnCSXBLeAaRbVmhWA3A9EuJE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(39860400002)(366004)(376002)(186003)(83380400001)(8676002)(6666004)(6506007)(2616005)(52116002)(1076003)(54906003)(26005)(41300700001)(6512007)(38350700002)(38100700002)(66946007)(36756003)(4744005)(4326008)(2906002)(5660300002)(478600001)(86362001)(6486002)(8936002)(66476007)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dit+AFpaLAXYxN3tAsTdAreuaqChDhfYmRee0yLLwIVqVdDb8YElaqragGR9?=
 =?us-ascii?Q?t3D/h5YJDkyVYURntnYA5jaMqkrThtxlM6IIEFWkMfcbGLzU48ztwEDQyz82?=
 =?us-ascii?Q?X/qc8uEX1Lkuw5k5A2Ojpfb7rFb0ZuwlR2ZqU2SRRfp0rFmLcxUR2PNJ5/cg?=
 =?us-ascii?Q?1WfkO5+x0cMk0jH1ecyuMv5xhQPL9er3f6ec44KCxDr47q1TktOD80sy6CAk?=
 =?us-ascii?Q?a4mr7f7TJyk+tkhpwcy/GS7AHEqnSXSAeWaNZHyGUjtcda0roySfVYTeaUN4?=
 =?us-ascii?Q?Y5/6Q7KFCrllVDKA+wMWuLMb7TcvWxaI4zh67iuiY43iD6h0KCyLGShqKxg4?=
 =?us-ascii?Q?d++w8nryrWbdQOuNSjb801H+3h8OnS3jLhQwPZBSguV1Fpn9/oKNC3Hc64ij?=
 =?us-ascii?Q?MeXG3m7ldqa5lO6oVYBt5CI2FxylLyi1NlRPW1LSypL8YFXqFBJ0JIFGRrlL?=
 =?us-ascii?Q?4kz2Gmuv9P5DBlw3wtPRvCRUoR00nmCp3xOqGw7+dY2jjVcD636eiQ2SYA+x?=
 =?us-ascii?Q?chA1x03pLZqX+L0282wYsxzncXkGWA+faMqJKrEqVK/mSDGWpMo1Q8ZWEear?=
 =?us-ascii?Q?lCKkkH/sBW4SigRiVPU1qugMXp7O2RCXDRe2o4dZOgmGjmPwqctPdVkanXbS?=
 =?us-ascii?Q?K9/X+6vp366Kfb+HZFfNazWH0ErYVnQn2kmBoWm30Z+dsANT5bajArZUqfWL?=
 =?us-ascii?Q?nMrsubVriJfMVeT1VOPd7OegiDJXRn8sEPxaRu+W8NTzvjKxm+DLoRHHx5qF?=
 =?us-ascii?Q?r7ayRgsXOD+hbg6F62XmgUT7hlt4kQZc7rKlUyhGgsX1UdHPRfgsTGlrxf2v?=
 =?us-ascii?Q?4xsSuGpdTPn0WJJCn1q9Tz3uVDafm0wNJP+YdqjmGnl4yaM+4f6vlb9kHHM3?=
 =?us-ascii?Q?MAGgkUXaqAA55HsgfY2Qzwy+FsuCt+VbS+AId3Nh03ReKZCTcecrEQkGo07G?=
 =?us-ascii?Q?/An6dPOjKYF0mmq1lzD++r5RjNMeX1lQ7ipnvjWO9Iu2k1vfe0ZnO+ivZTCj?=
 =?us-ascii?Q?mxBFPMOpwWmosNWOvNzeCDKzGj2mMbCkKstuJJK/tFgavZ6Kv1+B+bHE2T6c?=
 =?us-ascii?Q?IN2rK5hrh+x2xnn1BpUPhPz3YjBRsaFUWnnBwGnCTFC9++HodXabbIQEVvrN?=
 =?us-ascii?Q?qRJudsYKcqGWzHklFVTdeYVIYseC3tmHjefNwy02XedR8shtoGMvW/dEya8W?=
 =?us-ascii?Q?tmHGwekiMslzWunoaNgpZYGTF/9BdleoothX2qKLJityvs2KXNA8R8ZeJOpH?=
 =?us-ascii?Q?iS46iOUYu9QSSVH8iWSX/3XgnZ/2pL1Csy+hwDaYI9EV0ldu22NE5ROiMACi?=
 =?us-ascii?Q?fcNNz1YM5NvADeM0rkqFx83U6M+7O5aJTnWjpnFNDIdnLCCS/Etb5/AvMllv?=
 =?us-ascii?Q?tUQgaDeeV9ELVX64h1n5XBPjd9ztiEX+6s+y5pVhTyP0Ep0Ei6IkIt3nt3Ww?=
 =?us-ascii?Q?I2pTvL8lyebZZkGzBfrWnMxCaS+/VzTN0vZsVf1fAOso3OcRi95t1woX0Akw?=
 =?us-ascii?Q?TU+77mMVmAJ2oRnrVs/PCmci6Wey8KAr0/W6h5gFOJoxaZObnCziOtVfNZ+X?=
 =?us-ascii?Q?8Lu5VoB1ViL2C/FeLctGjKrLP26sosJI66gXPh2hGlGqkJ9BEVmjdLPYllQG?=
 =?us-ascii?Q?YA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c50a8b37-ba16-45f0-a3f9-08da594126d4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 20:02:38.7281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S2dsOTuRaGX6W4+41eEbgzrQ7S+pDeGqR7hYMiXcKPVti5Od7VSt2tI7YLV4DBa0Y1KF5e6Xt/aZr+cY2AaYZg2x0FU7OAtQvG4aUAwsMM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2376
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-28_11:2022-06-28,2022-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206280079
X-Proofpoint-ORIG-GUID: xceHaC2WOqstjq7N5nTyB2CCwynct-rU
X-Proofpoint-GUID: xceHaC2WOqstjq7N5nTyB2CCwynct-rU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We use WSNZ=1 so if we get a WRITE_SAME with zero logical blocks we are
supposed to fail it. We do this check and failure in target_core_sbc.c
before calling into the backend, so we can remove the incorrect check in
target_core_file.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_file.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 6c8d8b051bfd..e8440e5dd804 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -438,10 +438,6 @@ fd_execute_write_same(struct se_cmd *cmd)
 	unsigned int len = 0, i;
 	ssize_t ret;
 
-	if (!nolb) {
-		target_complete_cmd(cmd, SAM_STAT_GOOD);
-		return 0;
-	}
 	if (cmd->prot_op) {
 		pr_err("WRITE_SAME: Protection information with FILEIO"
 		       " backends not supported\n");
-- 
2.25.1

