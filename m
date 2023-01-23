Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18DDC05027
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbjAWWMY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233131AbjAWWMB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:12:01 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322AB3929F
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:11:39 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLi7Ha011527;
        Mon, 23 Jan 2023 22:11:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=2G3PzWon0bmtxLzmPCX0+Gpuo2oqfRuxnTaFksRKmwg=;
 b=CcV2s7RPpnY3GRkt0pLbFNvECVrpwopcO7npRK449+smPa5OGSsjYx5McAFQY/5NbLuF
 jDgHrfNfRD70BDx1U3KGYhSQgY8uDPSX+E+BqdDhQsYsvH+nzC4T1ZAjDmO9SpAKb0/7
 umFKrzOWQc6zSUO5lf0QkSAKTuAnF42DAgkPmI3gDIp0D21FLmPs3FRXulZAJV9x9Ihg
 HtTBDgLQ4yV/k9CN6Dg2DmElLCqdTHcmNhiB9ZcSOpffSy5DrEjbcnKQhFqWR0id9s3l
 6xU7hANYHvHVCBYIhZNmaV5rxcouMhIgI3HVT7RxhQ1w1qMI/nu0T1479hgy9DRJmMzQ sg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86u2v27q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:05 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NL8deo039567;
        Mon, 23 Jan 2023 22:11:04 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gaxjsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=goKuDmbev1Z1XI8Mzbl43ULGlC9KVDFlV8SBK6Gw8UDQkMCCPqT+1NO1fZUvIjTDNzN7+NQv5qSY9wCQ+hIQZS9Q79AvF000gf+lhm7NXMYjxA6C1y42Zx0kRbIw4iIip/26EhGkkaSN6vx718Mj2SDwKW9muFdBXVbnHcyUjdDOp6aXS7q64pO47fwvOZxPjftn96kfSjWaUPBhyFxjBHBcbcRv+9W5di9iyfNdNW1ZANip1TORagOnsPO4jO1m0reNDFjyoc7wEqeAG1Rvw6cB6odwTR+z3j9pPUcjv+5jSzaS9B6YhsHuUIpHuz/SEM3uABCLihTZsNdpa4v6fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2G3PzWon0bmtxLzmPCX0+Gpuo2oqfRuxnTaFksRKmwg=;
 b=PadWnlMju4625E2akqhBYpfz+Qw0AF3CBK0bTXBdAFGPk1Gh7iQ7Em9hWl9tmYn6xuq8Di/JTF6RxAjf+ZyHpCcO5cHvi0zPtyDmJ9t9UOkby7zCXwiyflcJ6GXZd2y0GLvT18iy97317fMlD+ypCZH0FPVKNKczYCZJyj9ZGlhaZMCRxe4bMsZHPc5lYCshGNcdv6otZsD6paIjldSYXZ9mCgBjZr6Mxd4qv4MW2x18bnd3Hc8MQn8tzx1TKQMsox00sPcJcNPsS5oK5klrQUllekbssdCPz+Z/JdbANU2IBaPBRC9/i2AoDOIJ/imd+wYSl7JFxx+kNS6fZhNzew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2G3PzWon0bmtxLzmPCX0+Gpuo2oqfRuxnTaFksRKmwg=;
 b=lhYKgH64d03uHw2FbDwccUPOApa2kgJTIit/VKBEC5FTbwH+iLfnB9gO5WeXgm7uM+oVtWTPtlgTbkZiJkZaXG/pkkM0pXTrPIm6huaA45ighENzNyuycqkhE2l2SMsfVv0UflOMjj6Dm3JTw/Lp15yAupF7PgrVRXXGGvwHPc0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY5PR10MB6167.namprd10.prod.outlook.com (2603:10b6:930:31::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.9; Mon, 23 Jan 2023 22:11:02 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:11:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 08/22] scsi: Have scsi-ml retry sd_spinup_disk errors
Date:   Mon, 23 Jan 2023 16:10:32 -0600
Message-Id: <20230123221046.125483-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0136.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::38) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CY5PR10MB6167:EE_
X-MS-Office365-Filtering-Correlation-Id: efd22205-800d-451d-4a5f-08dafd8eb70d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BT83KPyAAgzT2wI16fvKWrXiPtDsZq8herw4XWfXUvi1QIIpm/PD2gwwxd0f1z6vqL0XxwCiHZ4epQZO5I7Be7YqmajUePImFTaxHL1LWP5JKArGiaNjnGMpcTBpybQ3ZBl08bvKl8nAm1c4qKPDMehHb38pIAR0wwCVtc2okbd8uFLBrlGXBQMGGrxs5wemmUnX9s4BM26rAtsA43sU3sKT0bGUj1NGAdzpdAS2uvVdib3A7a9cUXrLlpbB4cL8CAaKFIqQw6mCu6NjNNZIS/Hg+8EzWVfFEmMnQXBwMqQ8AzacDgrSaK9NitYOrAY8qqr6GukoZ7wSoJpKeUbB3cQ+i451DmDDtRb22WhlentaqDV9uJhu2BGVmo/q8M24x20Snmr0YZja+fhrB/Tb80jFgpjIl8Zuf2l6WKEv5j2Y8LoFwN8HsBGZlo9dG+XwguoHYZRUynAnWC2u5mv7X+KJ8TdYk0thc69so3cf9RS3N0pg/7tTDynOW/rVkKNcROxpGUmtGKUaMP+CVeBHJxBRCEwZNm+XojjDE/ORueX6ch6u7qs1U1SvAtT+8xWoQ8REuwGv6GfVbfTbYqUSlH7AXgfxJnv1cJrSxIs1PXUpf9T6DzQY3Sk83/7kCn25PKCzm1Om06zPsg0IdxGK9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199015)(86362001)(2906002)(8676002)(66946007)(26005)(6512007)(66476007)(186003)(41300700001)(4326008)(2616005)(478600001)(66556008)(1076003)(6486002)(6506007)(107886003)(316002)(6666004)(38100700002)(5660300002)(8936002)(83380400001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mOx0a6xUvFRXmVt2bZA+WvC32zPtAID/7Sx+wqBP0ddIaysc85jsrQQd+BWr?=
 =?us-ascii?Q?NErtOWV+r1d+WpVb708EeztS9QDTnB1cVJoTGy6zYfL5/c3uSyHVksqKMzlw?=
 =?us-ascii?Q?UVaQhDKDOOorePh8beaiFhFvPb5rpErItZJFMhe0iMz+1mAt/uTg5HYoFFqs?=
 =?us-ascii?Q?YacgHfabonIIEdkxLJZ7see+BoWLyTRPbL0rC4hc24ArZX7raEqUpnR+UzwS?=
 =?us-ascii?Q?coPEh+5+Jf5qTec/HwqzjtkfkbBL0MjpLJ99BmvlBUJq92uDeae/6wu0XS/N?=
 =?us-ascii?Q?ewaYBSQyDD290r2sq0f1b4koHx1+yn7SauZtuXoAtIvkxHO9WV5Iybo4a3TZ?=
 =?us-ascii?Q?he8R8iPtj6NsjW5kPtc3AO0s+uhvrWMaJtJ28I47cv44s9irkYlO3UM5Rkg0?=
 =?us-ascii?Q?LqBL5bVmcJznYCSACb1gz2edRu4XrLXVs8uTf6P1MNBLZ/65dA2PZIfCzn3l?=
 =?us-ascii?Q?QSxh993FcZjKYDCHSe7JAhtgMqkbUUqEI+W9kqX95jtSIt3j6BMlQLwnqWOD?=
 =?us-ascii?Q?klGMQmsdxL4bUiPaqaBkIwHiG4PY29SBu4wRKoConO2AsYnmVjTi+nK9jhYu?=
 =?us-ascii?Q?VpQ2zW5mogpENTl030uxvjnwBz0mBxgUVsaMAG9aYMyosgxZpj3zYcFNtJvV?=
 =?us-ascii?Q?IvE/v3yDkJg6hKoI8z7s0UM/0F4GFyFWDzp8sovTCOVMmMJMzDcviKxUzbtj?=
 =?us-ascii?Q?RxPVriuYWTV0U2UTMIYx5T3WkQoJTUS6KQ40BawGmP/Q+jA+0FhYnus/2y4l?=
 =?us-ascii?Q?FjFsnKrdixtYUydQDZjeEOZcKtUzDP28mfhg5l0K2fTsC75Yh6UhigOUVoNF?=
 =?us-ascii?Q?6QbpoY2Jqyi3n0l4bWL6UjIB+GyxlUUaH0lDgu7oILH2pqqmHhqBY9yBT46C?=
 =?us-ascii?Q?rxJpVXwGFebYZw59D02In3PLc6O/ba3bU7EIYjJ2SXvKgRL+9qRw+d+V5FZ1?=
 =?us-ascii?Q?cyAcDoeshZppeCNn//tw/FyWt8WA9XSJ+vYblcnACRnPvnKZ6OplSsaKGT/L?=
 =?us-ascii?Q?Maz6KIxThB6ThjtgwtWgtNwKNs1g/kDMR6OHGzuwgRyVV2qx3gR/cCH3V8K7?=
 =?us-ascii?Q?k5uOk8BHzZUrptrPgCGXB6+JOGALkcL0Bm9JME2AE5iuU0mFNDkrSWBqiPOg?=
 =?us-ascii?Q?20ca3Cawzsi5f2cNl/5TOVneSUy76leA+dm3J2uHT+X4sgnt8sr4QlORfMAY?=
 =?us-ascii?Q?ctJhDYBHvw16jfd+98AaI9cA6mO9kJXYMDzWsn7EggfvgTpbRjC4HTkgb0sp?=
 =?us-ascii?Q?AAk8evQRfwsAqmA3Hni+BZHahrrC9ixZ+Hzph5v3BcfqaVwGXvnBWWWPSCkG?=
 =?us-ascii?Q?albUapfB/bexeXFhC1JKVnZV5LMyE0LVjuV0YnpzIq899gTmNW2dRJlzjNRb?=
 =?us-ascii?Q?yGAZFT3BL5BMsPAJOy92As7qyphGYvXk0Lxjg+0DNQjBFeMMz2lKAIGPbiln?=
 =?us-ascii?Q?bjV98neX8NTiObDJapa6yqWy/e6aOhWNnua0rWG22MueJ0kO8UW9NP5PgoXi?=
 =?us-ascii?Q?Z82mXLULKtKpPejTNozTZ7BEMt8VbBr+6ikr5X0MsCcO+S8at3XgRw6GqsmM?=
 =?us-ascii?Q?nBKmOqhutsqiEImsa28tuWHkSO+0ZNoDjzcXypcs0ESrxogp2KKy4qiPTmBA?=
 =?us-ascii?Q?iw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: eSVAyY5Lp8d5HVnCCHPrUkUlXyaTCvgen3dRIlsvkGLhXWKT8c7FesFFqC1JRzrFTz8LKHxUa6YDB0TlIS4Du/ezNZxoEZoI73nu4BoytbeRsuI3g2U0kQUaco+yxZuuaO35QRPLx4lGle7GJCo5TALMl803/nZFLy0EUGAxzgb3NIPAZk7A51jHFGrbsuKhjvavY5Cohwo3vPaXAqDTIpJxw7vLGg/vS+VHk8RHA8wkBs8HDXKjGGa6G2OmOTuhHfOXNMmofb1t/CXW64pxzzATsm590jQ2qvh4SY6a1NktDzTZ0s7vfGdCnTczfBMa1ttuvV8JUuZ5vQuFdkQNC3EY3RBj5oHZrOIIoVYXCjJsEMZ8gIiMQMWr4TuUhbDvidXYgUlTkx+uECu2AdlDSwTt5PPe3YO2lc2EGmsDxWwE5hsD0ICBGJ1DhOr50p0I7X0fuTNyOTP9bqzzJWFHa80d+ZUBhdrRapWLGa6pLs+VnjfDpoZI2WN35y7VfMhD6EGAxPqk/LIBXA1yLMnGVedqgjIIoMpw8UpBzd8ixaZNc1yIZXyfrutTXCKlEhwyruXzkp21mcH0k+aPOqob3bXeqJX2xwWZzb6WLwbOt/e4Gy+y9SxnZZtibBRTOWCKJmOTQSa25ckEOlN5nexDs4jjeWX84FWH5jGyXmcsZZi/KlZ9gpFuSnfn8LKTIXS9MjCWpY3cUvBJuc3VvUzoFMR/k/gW/kRVCnPMojvBfFqVtcPahMTeMaalJ7vuyupSBgOsFwEk7H5rgDz1x2/Q9YGdws0vtdUtxuZMDqbkNXVEv4b06Yam3mvmlx/rHFJMzyiNDjENFy8QaHSjJVAC542GWZ+LFaSXnmOoDVEQRNtKC3qUHBlenHVeXPWXo6SN
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efd22205-800d-451d-4a5f-08dafd8eb70d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:11:02.6037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f3uJn78UAhrNRHbjUKVBN4SnVoRG9Su5ujBNtv43Kn9dz+uHGrlSJLMNkaUbklMuEzAv5TJnrEsPUEsC2qMkOB0iup/Ki9ZriXBxwsi8UGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6167
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301230210
X-Proofpoint-GUID: Hzc8GbaYDDP1rE7vNKEbON-U8qQHhGP_
X-Proofpoint-ORIG-GUID: Hzc8GbaYDDP1rE7vNKEbON-U8qQHhGP_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This simplifies sd_spinup_disk so scsi-ml retries errors for it. Note that
we retried specifically on a UA and also if scsi_status_is_good returned
failed which would happen for all check conditions. In this patch we use
SCMD_FAILURE_STAT_ANY which will trigger for the same conditions as
when scsi_status_is_good returns false. This will cover all CCs including
UAs so there is no explicit failures arrary entry for UAs.

We do not handle the outside loop's retries because we want to sleep
between tries and we don't support that yet.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 70 ++++++++++++++++++++++++++---------------------
 1 file changed, 39 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ec7045a828dd..89aabab82763 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2093,53 +2093,61 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 static void
 sd_spinup_disk(struct scsi_disk *sdkp)
 {
-	unsigned char cmd[10];
+	static const u8 cmd[10] = { TEST_UNIT_READY };
 	unsigned long spintime_expire = 0;
-	int retries, spintime;
+	int spintime, sense_valid = 0;
 	unsigned int the_result;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		/* Fail immediately for Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.result = SCMD_FAILURE_STAT_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
-	int sense_valid = 0;
 
 	spintime = 0;
 
 	/* Spin up drives, as required.  Only do this at boot time */
 	/* Spinup needs to be done for module loads too. */
 	do {
-		retries = 0;
+		bool media_was_present = sdkp->media_present;
 
-		do {
-			bool media_was_present = sdkp->media_present;
+		scsi_reset_failures(failures);
 
-			cmd[0] = TEST_UNIT_READY;
-			memset((void *) &cmd[1], 0, 9);
+		the_result = scsi_execute_cmd(sdkp->device, cmd, REQ_OP_DRV_IN,
+					      NULL, 0, SD_TIMEOUT,
+					      sdkp->max_retries, &exec_args);
 
-			the_result = scsi_execute_cmd(sdkp->device, cmd,
-						      REQ_OP_DRV_IN, NULL, 0,
-						      SD_TIMEOUT,
-						      sdkp->max_retries,
-						      &exec_args);
-
-			/*
-			 * If the drive has indicated to us that it
-			 * doesn't have any media in it, don't bother
-			 * with any more polling.
-			 */
-			if (media_not_present(sdkp, &sshdr)) {
-				if (media_was_present)
-					sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
-				return;
-			}
+		/*
+		 * If the drive has indicated to us that it doesn't have any
+		 * media in it, don't bother with any more polling.
+		 */
+		if (media_not_present(sdkp, &sshdr)) {
+			if (media_was_present)
+				sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
+			return;
+		}
 
-			if (the_result)
-				sense_valid = scsi_sense_valid(&sshdr);
-			retries++;
-		} while (retries < 3 &&
-			 (!scsi_status_is_good(the_result) ||
-			  (scsi_status_is_check_condition(the_result) &&
-			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
+		if (the_result)
+			sense_valid = scsi_sense_valid(&sshdr);
 
 		if (!scsi_status_is_check_condition(the_result)) {
 			/* no sense, TUR either succeeded or failed
-- 
2.25.1

