Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA24C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiJCR4e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiJCRzM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:55:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC8C11C29
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:54:52 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOIct006279;
        Mon, 3 Oct 2022 17:53:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=wx55CpMcerkKOO4XlPesewojj9SabUqzqSEDbSnVQfY=;
 b=SbwTQs4k3zlnBqgtvYQUD5KNke9K18zqLcsXFnn9v02GYXo8Velw6AsRL992Vw3fCmGu
 wqcSy3WZNhMabpYAL3EZhaDmu1pvWohUciFRKB5IIT59oLnXdXcFeh9RHXxXK3p9pJIK
 5lv7jMMPQSKiAiiKvzSbJIh5Jwq+nml/mWqVkgIAxVhjnJCoxoHFMviS+fzRJWHkRhtJ
 KRh4FSfXyG94iSvZW043Ttsxj2N0AEHDb8N9CImt/FtmeTU/X4TWeRoYKDGPO3PKhJFJ
 wmDDllmpcX3u210c0zJN2oN/PvMh7ilH0d8EBnt8Z+b4V63se44VmcvTkDMb9N2uKJpn lQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxbyn48t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:42 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293Hd0xi015519;
        Mon, 3 Oct 2022 17:53:41 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03g3m0-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AN02iv34Rp8CFLWETB5OBBRki84KylpzW20PrRi5KzM0fxzWGzcD0cjWLNXPkuLOO2P9VId/QLzP+EcXWn9EfarUqnCtwFkp1XHoLxPta79nl748XqsMcc4MoG+Qwtt1hbEeGCLUFIXP4PD9MU1SYGnjvRHR5hQHoSvAKbhVSoHpokFLzZJgUf4xAxJGBm+nmjUi2oW48DYmc5pc7DorJa8kDv6OXqMR6m33LCqx69Z/GpkMYkb+UR0PRj61Jb9AJWAz8dSUIc6ry53OaDgteDiKettZfeXZx4eF4RJZU9dEs7c37idZXylwK9Zkt3Bth85FqdPFNl4EJDCeEAqsRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wx55CpMcerkKOO4XlPesewojj9SabUqzqSEDbSnVQfY=;
 b=I53zZCMGeAlF62l/D/D4VqtEaameJbVa28JVNMUbNCptowMTlIWpC3DPi/ugK4c+G+8iqc+iX9jX6wGvhDUm8UHa8Z9gE98wOed3AANBZBggKNqxxvB0wE+H5K4+ESBqGYNPe53g1FaYUUfOhmUyLFiFqf+qrINSu4YBXNIhQJSg5Ok+DFR1dwj2Iwh5JK8uoaKm+cXF06vQP5h7snI4q7EelwfdPY/aTDmr5jd47e2dA7GEkOirMSlk0zNL30dqc1h167XhheysptYrTBNUsixeHryjEWr3kgOQF+IhO12an1UWw6gy7VoCzvHZ7zlvgjJ2fTr/9Sumk6LE5Cbfvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wx55CpMcerkKOO4XlPesewojj9SabUqzqSEDbSnVQfY=;
 b=urRnrj6bxi228fI8IxOOOVAlgxG/10ehav3USpJqRo/WaYm6DwSq9Ubq8mjZgebhEMyHWG2XlziKwFEXpAWQp9PhV3HRkhF+UIGuSOD5TVBeD66flN05OMjtlEfF0xZG4Bdeg9I3XFZoYjc1YtnuKskYD7gyymY2KXZLoBm7Bkk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4834.namprd10.prod.outlook.com (2603:10b6:208:307::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:33 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:33 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 06/35] hwmon: drivetemp: Convert to scsi_exec_req
Date:   Mon,  3 Oct 2022 12:52:52 -0500
Message-Id: <20221003175321.8040-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0003.namprd11.prod.outlook.com
 (2603:10b6:610:54::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BLAPR10MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cc21e7f-3493-46f5-ee21-08daa568302b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oAr9IClu6qz8b6PzEUJxe6g9Zn9FJILmPA2JB7eDFldNh4p5O8hvibU1jnZ62D4LQKRjfkc3AIC8reMWBgIgioUK6DoAQJ38ISbAnKFueuGHmPys0Gjxr0eR7Mg4ITOrROytlsPF/1zwu92ygW75mgg3V5aGAm1zH9Cj/0lF0N2XmIBTpLo1Ilj2CEf0fCFooCb3keZvfXXt1DNr6xisc7demcotkgTG8zph9wCrxrzV0CH+sRlGq0815ao79LDpOW2WIedFZwWUjOC9OlAgX0pLyS46xheus4E7ZQzL5qUgX+G4eQgZ3fLCU8efQDryZ+PSHX0caq4qQKaU/5k34SfmWV4eyGT9DPURy13fOkttu07mzN16GnxAoHwNc+cXMGJ9sbcDRG6APxsOOHAn47vjutmP4mTJGaAlt0mdKlmIKWmX4fdyMg1FMQVg/bud0yZVeEY3RTiTRAs/HrDxNeEG59aLKuoxfU0yZKTZCTt5l5vI7I0QdxU6cGbiC72Bsj0dQ6XLtVEqRUGh7CnUrCMl/ri2EBx0nb+kRbU71ByQdQLOEPb5yht7XLw2qIKIVsAGR0vh25zB6GybgI6PpgCcGafMXwUlaNdcb2W2sUWkou1sARm85tXtofAJ+SopCCAelnqngR09vpMUulrozrjH3GvAwBoJezc/15lVOk6CADT/GnBt/JG0S8epX+zYRAepbK7sMs7bnEPpotpQ8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(86362001)(83380400001)(38100700002)(186003)(41300700001)(8936002)(5660300002)(316002)(8676002)(66946007)(66556008)(66476007)(4326008)(6506007)(6666004)(107886003)(26005)(1076003)(2616005)(2906002)(6512007)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lwFbPMERYniVHNu2yzntngLPrNUSMaufkygABFXLkvuC+QjiKqK87jm3BcPC?=
 =?us-ascii?Q?C3QpaWnKiAxprDCAflTtaU4awnHZOTZY1T9Pt7zx0Om1mvJ8SH8u3I/zczZP?=
 =?us-ascii?Q?BJV2yac2s8JXl6XEtRpufpl0gDER92ltTL0gGFFHOaKfdBQ0VdLnxbBSPbIg?=
 =?us-ascii?Q?bdgFq47OPf139DP3JrCf9z2bZuUcjWUNwTHNHpLVChuMraE99U7rm4hdVEBp?=
 =?us-ascii?Q?dv1fLhjf4rs90kNDEQN2u6OSBruLVBQXA/HkmmyIlGrnrMW1/hgHYdlZ4Jht?=
 =?us-ascii?Q?ndnTQBcVfZwWc92mzoQ4a9Bfci7z/H9/q1uOk75jjM+tEqk2mLyiAqXN00N/?=
 =?us-ascii?Q?R2Ggwvsc2x9bRG9Bn4Uw3dcp15EBLB5blvCV6RWemeszq1MnKtrwAnwPahta?=
 =?us-ascii?Q?cKZdwTGDBRK4sIlhhpFzRanBM87/t+HWgxF9ZTmQ6ZtT6tktCaLw4X7t/GUS?=
 =?us-ascii?Q?zlG005OSM9q5r6CI1k9PGbU10wSHJQdUfxsIXzdaIdPPAEUvwAksR9Qm14ob?=
 =?us-ascii?Q?A/IPZe2Lm1eyiMW0l1u8Xylx/2zIaHLG17AQoflcTcvJZKQ2ANUFjwB6P/xO?=
 =?us-ascii?Q?m3q0iXKbsQy8ORWtRYZX+nuYcBYYlMirEsX7Ojb2fQu73+vWa3r0M2HRnVvR?=
 =?us-ascii?Q?HkCoZNhiHqHrrngvzThSKTEddA1WfIFG6HDc7jJnZxwEDcqVpQ4IGVfSZ4ys?=
 =?us-ascii?Q?nUyc1UicHqGHuvvl2UbtYUbsLZk3P5ihVgLdcObC4t7/wvDPTkRjHXgMKULC?=
 =?us-ascii?Q?8s1DF33kDxzKBuB45leoZrcX8KvLoxPzYXz0q8v1k4zcyVkq+r4t6terBK5z?=
 =?us-ascii?Q?C4Q1FTdZRvDluBFBl2G/pPZQ7dYrNiaIxI5MvS/MVt1wdOiTuDbpbD9zv8Vg?=
 =?us-ascii?Q?YrHlfuxkgapntIdtAXM7QQfJaCSSmmHr9Nwih9bLVvQWfJQR4RD7dW/+TkLi?=
 =?us-ascii?Q?g0AUoPb3HCBRcqnrMlaFMizetrxxpjgJZECpoNeoMIpJqHWDhOvQmybC40+O?=
 =?us-ascii?Q?HwrGWTUIqIf0okWGwcGQ8woAenCGOM48taVT++IWFCw28DAGkF4A3xpLMEGI?=
 =?us-ascii?Q?b2kl7PDtsr2KzeuNi5aC11hBVs3ZA68/j643R34O5mL38tT5WWquzTk1+ZoE?=
 =?us-ascii?Q?82sFt9GxSzH5vVBDXOMvlSYgBigPBDv01j0OT3uPcsRU49701MlGj1TBprgJ?=
 =?us-ascii?Q?CmhEyjHft7uQ+BKhy7Wmnf9VAol0HIqvM/azPz57dmgaq/8v1W5ApIZVtcjn?=
 =?us-ascii?Q?AMjsyi1lr/vVy+UAHDmnlqThoMotkC9B7KyyBshid7hjY3SgvxCBXlQo2FwO?=
 =?us-ascii?Q?oRgo3ild5STuUmc6fPyIFu0EnokWZpdaEZiXJYSb/q7BNbCoqrpo6nmmA65m?=
 =?us-ascii?Q?T92RjDHDbdNni5iLYTn8gVAtlKkyS6SXDD/ChVTHOXFeD4XTuFiCuzb+Acdj?=
 =?us-ascii?Q?2y0ydPqzp13B5pWozlhNcbJ/i5Bo7LL3T7tQP7hEiY/8v6xrgvciLtuY/GdG?=
 =?us-ascii?Q?OytDk7sNJwqOdA448qOWd3KBCv9BSVjrqH3nnEOs5x0v2uNhGLl4jJbV1iU0?=
 =?us-ascii?Q?hDcjMp/BBbzSRg4f1giHkbLJutij3/7kGhiotvbO8iQrpL9NNjNQ3JfAbisM?=
 =?us-ascii?Q?WQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cc21e7f-3493-46f5-ee21-08daa568302b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:33.0963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bnVA/kqOaHrZr/VZbUvC1iPIe5Jk2W9emJ6+5vMlUPYLNhDsrcfSNg32lqXbea4evBdQMbd9l9YwNB9Mbsgx8MVonlnh+kLruy/KsDlS5As=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: OmRBoDSD8VxkSy2d2Iz2oqv6Kye4P3_j
X-Proofpoint-ORIG-GUID: OmRBoDSD8VxkSy2d2Iz2oqv6Kye4P3_j
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
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

