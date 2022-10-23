Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67DFEC3A59D
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiJWDEn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiJWDEd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:04:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B9926F5
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:04:25 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29N2tKAl015631;
        Sun, 23 Oct 2022 03:04:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=w6ze2qNHltbPDGym7a+87QbyUKKhBwuwBnx4llIGzf8=;
 b=WgWq+GtkZpL7wuGk5MOLq+16VNyKvsTFkdVw3WbMx2h+iC2vEy4qK6MZtjGfBwBKdM7r
 IEyy0JspM8WAP8hTTZQHtvzKTqJofadQ71K3pP3hIEnjOAs/4oneH4UFGamxr2ylI/Dw
 W2OlFb+0Dza6O//mk/6MO2WIqf64unoln5tI0jH/MniSdoxmPUITfXjpWgCoxZGEkryO
 O989NOpryIi+M7y93EFhokFZ7RgMwdEovqbShMyXntblhBdv05xeDOiwTtN5L2tkgLs/
 Z0AQurdJr/TLCBFxVXoBismwTuuFppDN/ZWVw3xsieFN4jpdOF8luUM2NR4dfmEyp3Qs dg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a2s4pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKH3su000972;
        Sun, 23 Oct 2022 03:04:17 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y8gryx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQexT1yn0tFjNlT8C8UgFP3twFe2a1HZskRpqY9E7u5/mqg9F3aqo24yJ+0lBsrGPe3N4/nyiIvhg8IAYjOFRjkJZThIYfdsduwX8H1ghr3qRvUqx9cZOTJ1THQS/NP2hq//dNnL1aZaQZaosaegmzivsEtT3xd/RoQPgkc8MoF1gLbL0ISz+hhyMkDPmiZtlciIKSftR7dughuG2op2qUc6Zw0KRm1HrZ3rQNURfdkfMBoDjAJbPvvcY1IyrvZ00OwY5k+5cjRvr9mqxpVHHhVbdlCAZIsHXSLEZDD52PL0s5+LfLC/HKzsRg5rwrv9puJkOLFIP/YSck4LRo4xlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w6ze2qNHltbPDGym7a+87QbyUKKhBwuwBnx4llIGzf8=;
 b=LllKifzDZwWqtzc/rhUYOuBOUK5YtTwwOybppF7jsLvcGsBgX2MSShh6TJ6Wcm1gxnOv8cFBv+ZPmm9FC3BJGFfQfi159/5NP75S9zs3cx4uxizgDUZeD31CaTmqUMeRBdJKiVNsB/Hh/6norKjmRS/uozdq6rmrv3dJwJPRmXiSOhjZ/dLAXlppFu0IJ6WDd/0xNSU3GUzqnDlebv69S0At+IFN8JlB4X1OoVlqJqorwMG4Yi3WkzisgHMi6dfmFmkjJqn7FC8LL7ZeDZLcRwGA7F/6yoBqZL+A6fuIhdKREpcgDj1ck/nMFwpjhCSz4euC2VS0pJR3iOpmwSghnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w6ze2qNHltbPDGym7a+87QbyUKKhBwuwBnx4llIGzf8=;
 b=KGHND0B4B3oa6P11O86ptRM9ESRsV7SGIGxdTWcm0NjSgAwPFpdVDE+vgOWxVXSYis3jbNuEoFOeZOGUKbJ3AaEntRV43Dri+iWKvd983TkN1ULDz94Z/26jFpJqQBeHSrRcDlISODHAtdlDAQytiq4gUPBIrSZut5zKNbsfepY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 03:04:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH v5 06/35] hwmon: drivetemp: Convert to scsi_exec_req
Date:   Sat, 22 Oct 2022 22:03:34 -0500
Message-Id: <20221023030403.33845-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR15CA0002.namprd15.prod.outlook.com
 (2603:10b6:610:51::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: 474a4a0d-b71d-4efd-443d-08dab4a34527
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y7snAkhzXf7VY8pEkr5bkr6J2pLwz9xj9o6PfMJcfwdveXM25pXPjNleKqo3p7JrUDZE2vkVnqmkB/ygJtgddZiBLywBioFdFJYmGxxRt1QfZbxTxLNVPRe6DsSzB7MKsjYPlUJExjdSKrT8IpPbRM9gzdLPsjhHJaY6R48EsMPiORJsZDCgvqdanJDN+Xdv3Tj2M+9/AXalGIEBZl2ZDP9fpif2d6hAhOezNgtf04RivZ7+CVBh2aWoYqjc0rynCEq+0z6pn/CR0XNdqyxqFcBGBTpmV5OrwJlC5D3o6Se3kc/Vjj2SvdTGlM4jbG56kUOOWlWoymWM6BU6w9Lz2xxoVNM33TVMr2Qspm8cA003FczSRVljjvCdY9M+cLrvN4jrzLx4SAzqCm7CAMcUQ/o3VNF7FtXVbCpW9IuwtaBUU0muv2nWolBJMgUUaQNSrIddPp6ptujVuP5KaqaftvEF7GdZHyPH36AbbZDwJd57hyN+GPJzY827awZsMC6H5gHSgTbu/f68+sVSEMhIslZiPz7j5eOMEdckvPVc42q61TXRjKZ8le7fErv7rVtl7VJjjH6nWtDzP8VGEwYgHq/nS6LHHq8BHJmMOl/vm4M2uIjFJTL/O/rc/D2meeCC18fGsMj16yjYJh2eglln9to+bu2Si+U36V4GWhvGC2ph95JW0LYbxYmWGgGFFonGA0pxnwkQU7AiDI6n3X8auw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(478600001)(8676002)(4326008)(36756003)(186003)(1076003)(66476007)(66556008)(86362001)(66946007)(38100700002)(41300700001)(6486002)(83380400001)(2906002)(6506007)(54906003)(26005)(2616005)(316002)(6512007)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vZ+Omu2jwdA+IzSAunnSnqkWEnOmUrEmorcZ9amrS7AE6+aixYIBEaVMY4Gr?=
 =?us-ascii?Q?ImuQP1r9C9sC59HImxaM29wJ5+V2DXI9LgjTmW93kP/VL3UCTCElq4uHrhGj?=
 =?us-ascii?Q?0SQLhFq2h0Lz/b12QKz6LDbVYDFIKj8QtNn6gejgGuFb89/KmPUJfDpsXepD?=
 =?us-ascii?Q?SEC88oDtnUxr/WMmPlExhZ3q+Wjpa1xQ3sTHTWJZwFbPMPI36wtctEM95pN8?=
 =?us-ascii?Q?ztQUpy0Hqk1RXtxlHdJoHGF3pVqwRnNyNOG6oQTIIojQ0RYApFGt9pHsL9rl?=
 =?us-ascii?Q?fcY/6p/XMWeNtrHg2RfsfPmy7WAwHyf/b0tL3JzUPu0ZE8L450Bs78dqCP1k?=
 =?us-ascii?Q?VpO9IRPSMUfq6Y6tCsN8e8EjeqGltBKgiLuzDZ49zfMFHySz9EnMDPi8mCZG?=
 =?us-ascii?Q?zbdnkuVF/iGmkEh4HTlU5UQkJ08wALgE4wyJmO/6LJhr4kmEFI6ucrIHa0cl?=
 =?us-ascii?Q?wO0nyTubFwueFiBd/xxPgfw/Zw0K4hYqP+nrond0gSStHe/HIDvmoHx6EjIV?=
 =?us-ascii?Q?lFv8P0Lt8VKCTRvD72a6OBVSxAPUOxyKw6YQSY9/1n3MHKoCUuS1zt4w8ynm?=
 =?us-ascii?Q?eAhAhVfO5jXXXJIJDdZIwRCXdArkdeGC7XqfzbhB4Wmge9F7n+nUKmiEuiSw?=
 =?us-ascii?Q?u87Z1vHlKxlfsn9EDlrrilP2TePrbFFtuwcwKXl1WuflPZp1w8G0ARi+8/3Q?=
 =?us-ascii?Q?4E/ZzC/kofsKn8kfOuLbHg42kHPuXqr8M/4kzuKGDrSWQeOTd6tn4l09Enuf?=
 =?us-ascii?Q?/wkC5OtOoP0jveEzLOI5+YGuD1bOjUDkLFNiha9XwrLtrI/9RY8GmSymBeOF?=
 =?us-ascii?Q?x5rqwgry7zkc8D9Z+b/h6A+vFvI/OFEAJEpCXVxBr7BKCa+3QuV5+IUBO7nT?=
 =?us-ascii?Q?odNCgsyeVW7fnIbGen5Z2aBKcYPRWNcTW4CWPA5Mj3M9zshc9NlLCSkBsQW8?=
 =?us-ascii?Q?arsXKMBXztW3xhvLIFJXEj2V8C97bN0PvyNerOmZcEpm8s54dGvxoRP4/CZ4?=
 =?us-ascii?Q?DWQ9n/OiCcYO/ryddJzBeoxGFGXrz+435cg7BNTL/fL2viR78WdPn/brvIvb?=
 =?us-ascii?Q?SYpeW/utMy1hdM/D26Qg2MUUr5KyUu2yYN5ARVPoxjvlXGkz+X/8zgZLI7g3?=
 =?us-ascii?Q?TfYRXQe6HqkRScFtcWUFCYIaCHqZKX8JsKJfYyqyVk0Am+mivj1vpheR/1Q1?=
 =?us-ascii?Q?L3erdLbaYJMPyeKKJI5juWXI1puQvKwH8biwESddnyU4I77cy8RR6/WHkj3p?=
 =?us-ascii?Q?oPV26pEN/jSlazA1OSkqdPnkpt4wWnxDmGH4v7YJ/0LWYWynwjEHO6vJud0U?=
 =?us-ascii?Q?/dEPVP+OthV9TO+rxpycLKmxciDTdzh4tMe65OP/5Bx6z6aQ6FgjZbfe5SyX?=
 =?us-ascii?Q?IvcrCCTNlAPcys1OwHKNwHUJORnG+dANntKLhBPinecm+FRDroMnFGj2QyPq?=
 =?us-ascii?Q?jaOn+279xCjdWVw/OOJQQ91XEpc1zyBClCqTEu8PUul1WruL5DfqcKrFloub?=
 =?us-ascii?Q?MZnDdr+0ew/meXkSnJx0Y1MEhncgzoD8P1i192w3N/rCr0Xq8nCSruxvAcLt?=
 =?us-ascii?Q?4HIj18i0/VARRDU0rPYP+uFxMLpbOR9xU+Xq4yhrrVDisPnFWD80Vm3w4Bhy?=
 =?us-ascii?Q?yQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 474a4a0d-b71d-4efd-443d-08dab4a34527
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:16.0310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qJO5DJz/2dqIEPK6K1X01qzawXYmc1gAUBxBpuSmgK81e0X7gAzlQU/XdCGVNaafONmsPDCjZETFDiGxuGuWrIw0nr70Gn03R65zo2VV/4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-GUID: UmlcKa2gXX8D5JopRz0ZJD5TMB_M9_-k
X-Proofpoint-ORIG-GUID: UmlcKa2gXX8D5JopRz0ZJD5TMB_M9_-k
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/hwmon/drivetemp.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
index 5bac2b0fc7bb..ec208cac9c7f 100644
--- a/drivers/hwmon/drivetemp.c
+++ b/drivers/hwmon/drivetemp.c
@@ -192,9 +192,14 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 	scsi_cmd[12] = lba_high;
 	scsi_cmd[14] = ata_command;
 
-	return scsi_execute_req(st->sdev, scsi_cmd, data_dir,
-				st->smartdata, ATA_SECT_SIZE, NULL, HZ, 5,
-				NULL);
+	return scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = st->sdev,
+					.cmd = scsi_cmd,
+					.data_dir = data_dir,
+					.buf = st->smartdata,
+					.buf_len = ATA_SECT_SIZE,
+					.timeout = HZ,
+					.retries = 5 }));
 }
 
 static int drivetemp_ata_command(struct drivetemp_data *st, u8 feature,
-- 
2.25.1

