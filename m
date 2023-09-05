Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE90CCF9E1
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238111AbjIEXQo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjIEXQn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:16:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49640CC7
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:16:40 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385MtGaf023608;
        Tue, 5 Sep 2023 23:16:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=gTSE2a6BO3s2C8UMe7WzTaLOcg3O0jUxS68uzH2jhkk=;
 b=VI7GxuPZ7DObN3vcAbZeitTXdLxikBh1bdNYwhB9YP6nuRrePyCm+jyZ587/D+MCTOfp
 0Rn7v80AgAbrmJ0AzWPzvcFrZVUCgxjUOlnY2H+8Vw+tuXaecNCAttZdXaT+0CteBNTh
 6LC3bLTaYEmkWEaX5p3Mu5JFuwAblYjeittv2/xXEXlBL6g4JdMFeKBu1of8RDYKQf0p
 78Om4S9v8tYLUwNeDz/+VXOcwZ4sRjItwx9fo2W9k3M+8dtgbR0pnNC39OK1ymAByw0n
 Gm2aTmNwtswfJEmTHXtPPXrM2ecKOxXVOu3Lsbl8rRUdV1dtvkbDL1LRWjEK54i1Hnha SQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxdhg818j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:33 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385MtVoV006568;
        Tue, 5 Sep 2023 23:16:32 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5x0ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kxLPeIddA8MbaYCTme1Cw7LPzlRtiNcrEu+HKe1m6Qj0OA2m/OW2Y/Nm8Wk3nd0zms9jPb0piUrZkKeZO+KSxQpzTMU5LIrFsls73N94Lz0ZxGafKq++gnKJkzzN5wHtdQ56QI/lfaT3HLcWKSpGYoN/OScunxmrEeIeRMNV0C59Eat1FjoP4hNdCEQEiWxcgH0+G24HNaebsZvtC9+tGW5JDmytJUU2tM34rGlUPLkYMyZtDPiBkKgXjmNBEwgWyHh0gMaGS/+PG5vnIg6HM26XEoxRecoULeOBjwT4E60g3CdZBZM8zUb4fq7xjIXMpwtClu+D9WyS5onMI7x13g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gTSE2a6BO3s2C8UMe7WzTaLOcg3O0jUxS68uzH2jhkk=;
 b=QVLFoSsGtnd+x9pYdQQxZlhhjQTetW3lXJWiim1wU5Y1OtA9Kh8bE2wJj6jeWrjfWR6/ODvKzUF4mzf1wHsB1rqlqTFYFoxyK9Z2kcZiZbH5wz/3S9wtbIB1bHvB5/txVaVlDAVZNRQH+gEqObKzUf6uRauRqW4xWrD2UZ20d+OcavlvugVYEQmGdBGd75y8HIkemHXmWcp51UgsWIZtY3TxQ5LbRjbhcMSRfefPZMeLEXI9WMKzb0SVamRhFMW61mGdkVdHrCv/3ZZoXGeoBedaOyxkfrkYWL/Spj9RYP7CGOcnnHo4FjrWrMvczpDdal/scDLgA0f0Of3giJ6KEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gTSE2a6BO3s2C8UMe7WzTaLOcg3O0jUxS68uzH2jhkk=;
 b=mc0U5lxu+QwRr8iQF49pkA3eNAWgXrY9yq80PfbY1WUBD9V/qABKZukkWjs0hQqRMaxiSesBsn4uAyEFBkhXyP5n9armmgDnJpc3FU9KE+uFPzka2x5Pk8C55a/vBguh942ZdwLfougHuVpc5+vecJh4qdZL1iAdUwAxcB6m7YA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:30 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 22/34] scsi: Have scsi-ml retry scsi_mode_sense UAs
Date:   Tue,  5 Sep 2023 18:15:35 -0500
Message-Id: <20230905231547.83945-23-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0084.namprd06.prod.outlook.com
 (2603:10b6:5:336::17) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 50c4dbd0-7773-4ecf-9f4e-08dbae662351
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xFdPplmj7TPnRlEhQqYR/eCElE2dnqZD2eefIJmeuSOYlmi7aTieohLHh6/1wej+BKVUNGMrbeju+AUdmJPZCNBlVaPVUjqIRiW+5LJLDfBvmr4AkKjhoI5ZnUV+6ljXtTXh2SVeFfirEHSH7KVn5cBP7hbYEQcBTOHh3tGHVd9T54/g8OGvliPzM8JlmHzqMMlPDkNz/tz1yxVQzbQHX67iHUEzeWPBk0+pcw6xMZCsuZymAYLk3Baks+Syiu9Y6D8hafOlBVse4dtlqGWUaFBh3MQzzY4B8F3u5v35224KaBc5a99kW8hA1m81FSOxSG3KxJ1QSwb+xL4hRJIbZkodNU2I7V7ql5+N1EWfTw/0mWcJYYjqA7f7Mmgg/jA+YjMp1/sIV17b/piv1F8R9VV9VVZBLqekYEtwGvXNWdLyhC5aw0k1mRP+qnXR+PTZomXtwy8lhiWGOW1R9jifpKWkoq3YeFVOPYX2DXZG/9ltYMx8tc6zQ5dEknzsM1PGs974cTg8a03oCFVAyo2SshWcYLLRyZlsjf62hy0He3ak2cE+N7utzoV/j30/41A3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(316002)(66476007)(107886003)(66946007)(66556008)(8936002)(4326008)(8676002)(1076003)(2616005)(478600001)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K17JdWVo8seSvPxuf3NAbXS2Rc4Ac2YrX7J6uXTDHplnPYWF14r8jGA+/+Up?=
 =?us-ascii?Q?oF65deayPLq/1UiMBf8ZfT/qBwYc+n+GgLKjYgpOoQMOXgv/DskGckCeWpxW?=
 =?us-ascii?Q?8kuCKQDiZg8KuxkHabuXnQ1EKl9FJGgRJwsVvy8zEKVYZnwFtvh77h1OtAWq?=
 =?us-ascii?Q?Ak/bMcUZ7dZVgO77ldcmhjT0jpdOvZq3F2Jsov4WytB3XXaKJorpx2brgMuP?=
 =?us-ascii?Q?loUSEGUMBFIQcRz2LxfmXjUPHut+28rGq9jxjVDTJq+CiPxKElXZEOsuMe9y?=
 =?us-ascii?Q?YTh8w0m4L/vcWN5SMssKLdhqmgVSSbUMRaSmN7SIH6qc3b/o9wPbIFQvIINq?=
 =?us-ascii?Q?DSQ9OEES7XUquvQqtDrxxtqn1ESgVpWcEAu3dNvZiIyY6ps4QAX9jXsz1Rtc?=
 =?us-ascii?Q?W5FQx/+Oag6EwyQ99GhPD2Qd3LhDLip1ls/uMnGoukgHd0B/9yqIAbk9aujP?=
 =?us-ascii?Q?PV3ohK3r+kAJ31O2h9LUdbVLJjz9rJXOQ6us3eQRHdZp3ixMnKXrGQ5w95DH?=
 =?us-ascii?Q?zMnKB/XXeLUGrIoGzu9Tipal892Dy5grThdQZJBl8loKSZMvENmXCVKCxkVj?=
 =?us-ascii?Q?QqxeuUwJhDEO7beoH9qGgJzH4p1xWctvzJK4mKAjW33xR4YlMGeUqUBxXXv7?=
 =?us-ascii?Q?lPrKyqGMcCDGPvXr7YWVhS6sRBBAPbSEQG8UBUuq42tF9rotQnU57ffOA6yD?=
 =?us-ascii?Q?bl7jJMLJhVFNNq3BFOFoKelBWHbLY7tfpqaGxKp31aHeBAeYZzw1Nrx0wHeP?=
 =?us-ascii?Q?te0vBMgQMaY09yK1J16FUIH16t/cpD9R0TuB4DJJ3HmzUOQPalES9k6V3gjN?=
 =?us-ascii?Q?cmk40SLVDSFSBJwq25pzObS6y5587TJno3GUCkytYZmMxA2DLjHCybtXqecB?=
 =?us-ascii?Q?GAb9G2hg6tjrNGFn3Cn6EgDBSK8CP92OzraoqDlDlKVQakMHAXN+DKfGBJCt?=
 =?us-ascii?Q?XiDpA1y33swVE3RgtZBM5af5cJExCQEka4bTPe0sNWBu9ha/aAl7VTkLPa2g?=
 =?us-ascii?Q?N5xf3widJf+BFpN6750aewdZjguZhOcIuffcUiB3AKYl4TO9D2zjoephvQ2x?=
 =?us-ascii?Q?skXC47SuZf/snu7suavL8eOkRX50ZqyneEpdCz+dv9YzFwGCNuu8Lw9cDmVo?=
 =?us-ascii?Q?gHhfrPNslgjQjY8PBGV66WfG4LrCeBtTqaMicwXJyN0Fh+eN0ocqBmNGU4+1?=
 =?us-ascii?Q?M38N6cDYreulTQdJTTRNt2X1qSksgjd33AmJSLzRlQAfQ6mL6k4aV1ciOnFb?=
 =?us-ascii?Q?91RtEKszQJDtw4lNsqbptz/EubVB0TQCuLHVgCQ7jDYxANJGOwWrC7vNSJX0?=
 =?us-ascii?Q?YieSQquOQdwYakRQzKNniMmN1cAx9SwNcgpyHduGP44AujzOGQDHRNtUQd6x?=
 =?us-ascii?Q?No6rUv2V9hL3oviMyKc7RJCbP1BQcAMY07t0CIcA01/UzjlAq1Fopu9P26TS?=
 =?us-ascii?Q?XjXHRFXVpGu/JI9E6wBN5pGgAG7wBEv/Yj6i2fIlODBbnFYwODPEonv1iccp?=
 =?us-ascii?Q?wQcryrj1b966keL8NEId6BwHMpT5ZGGBmn7/JIGW75gbjdH0Yh0hY/38nSav?=
 =?us-ascii?Q?H2r4TY4doDhNjWvFhaV4sSh5WGwNMPJVWJhQjTHS7EiAyoakbMxfVQUbb9e8?=
 =?us-ascii?Q?gA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: waAPeMq9rv7XP/PVe5Pn8VZ4VmYBktOzD3bLizyXGiFRTZcSKAFLzPWZtZ4NpqVeeBp3rQ4AqkMxU/xGRW5L7O+hqlGZ2EwBDc6+KnP3BJED9J1frErv2H4lpwd8wHpv44kwIuwsqxcqYVhYsdfgha7g9k9uWL5l1rlQU73YszkoJPWF6RSl2xUrYfLtCKwP2rpPlluI1V+DM2C/qbPyrAIyQq39d2nBqU7IVgYezuTqOppbBdcrKZ4xRb1uWok3k2RMs/G1bUxDYblV/b13B7r6LiU0s0/YJ/ujUCD350mQCRGTCpynRQ6RTUZ7/9zO4fPpi1Xmtpq6S6E5lRYvQZM6Gf0VxIv7W7onnCFUzUKVSULGtBWwBHGTW5LzgRAwWlIFkTiq29tpPcTnMIMy3yfNJLPMJG8oKoBaVtMvFSnvqA9VTG7hofWyQZcY5sxfV9uud6jgR2h0/kKOem0Bfks0P8/xeCyWWiPVLsxnUK9lwm+0wKLd8xQxWjHVOQCpVQ/F3YeaJyTId9YgpZoN4MMl02LBiPWhexYiV1aU19Et2Qr1ZPzcDRyf3rCtnQgZo/SwLGgcRlo50qubEydVFWkhkOfZFHmRudfN0L7UIoS15s5z5f0FpH+8PgIeNOKfvBr3z+dG8dxrBzKC7vLoWCFZf9vjaxg9tU7/k4FQ0IwH6ZCOI37jCIO9M4IBnYC8sh6pvb4ki6eM3n4bPpCgjVmCgkUUhTpLPBXUJ+/HpRLXzaFg89XRIBMh74fPYg6Y33k73CNsTWmmCD6Jnh9f9rCSaoVJLMhfNv5RyomBCOaswY+vu8fckPI/tCzm8pWBpmX9wNRqfCNHvxyQpAfh7Y0BGtgm6jowXCehDj97swF7Ub/yw4LF0ISbdOb7/Thj
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50c4dbd0-7773-4ecf-9f4e-08dbae662351
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:30.6927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s8CORZEkUij3/m3a7g+B2C9W+rDT8JuYkeGq/onb2mH+/gaIOOpk1kyV7NiV4v2naBj/CIkfktJrAqXqP8CsPSOXejf3VYIP+wsFhbMPawE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: 10-7Mt3KbRjfZBmC8O07_kts0Wh4_M8e
X-Proofpoint-ORIG-GUID: 10-7Mt3KbRjfZBmC8O07_kts0Wh4_M8e
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_mode_sense have scsi-ml retry UAs instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d9432bbb64fd..67d74f175c4c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2186,11 +2186,22 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage, int subpage,
 	unsigned char cmd[12];
 	int use_10_for_ms;
 	int header_length;
-	int result, retry_count = retries;
+	int result;
 	struct scsi_sense_hdr my_sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = retries,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		/* caller might not be interested in sense, but we need it */
 		.sshdr = sshdr ? : &my_sshdr,
+		.failures = failures,
 	};
 
 	memset(data, 0, sizeof(*data));
@@ -2252,12 +2263,6 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage, int subpage,
 					goto retry;
 				}
 			}
-			if (scsi_status_is_check_condition(result) &&
-			    sshdr->sense_key == UNIT_ATTENTION &&
-			    retry_count) {
-				retry_count--;
-				goto retry;
-			}
 		}
 		return -EIO;
 	}
-- 
2.34.1

