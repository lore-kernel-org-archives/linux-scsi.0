Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1CDCC43460
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F2406135F
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236940AbhDCXY2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49786 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236956AbhDCXYS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NO4Te162545;
        Sat, 3 Apr 2021 23:24:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=p40n1bd20cr1m6MtdJ5XHV4tBBzC41ZMwVLt5dIExxo=;
 b=kXzMtE1JJMQG6ND7HLudaAigUiRDk+yDZnplRuTpZhXU0M3WH1cTrSJAvWrk5Fu8Pbcn
 gRBBsV59OyhLVuVuAytpt+6psF3FdgojEQTrqtpd4XstojwDxCDELFlv/zeI9VElZ1j3
 Q+unwxZZ9J4hoiW7lXFtDJjQtVjM9jLlxoQURXQW8KGwyxcgRi0mOPX3nUIF9K82NlDk
 dfvJcmt/H3Zctkm9k4GjAkexDN5cioqCZzjSSkEcLz1C+oT+6aK8Ddav6jMi0F3FOII0
 r9lq9MkUXzQuuROcKmc26YfdZTgT+5Y04a1HS2cfTbWtZ/hO5eRW2a+DXsI81b/VYkm/ wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37pgam8rpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKsHS116809;
        Sat, 3 Apr 2021 23:24:03 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2050.outbound.protection.outlook.com [104.47.45.50])
        by userp3020.oracle.com with ESMTP id 37pfpkbsnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JVFB+XQibOl2ijzJXl4Yj/rhIy22f6NK/X/ErOoXad9LecEsZGYw4Tj9aG2J3vpAGD3Iu2kUAR5hZSFrl+fjJnyvSh25qkere1wtJxxLw5zzvrqnH6VySO7ap/RIDU4XxfpbOKsm3YcI3je4uwYaIlbLbuGnNP7E0giG4gcFVyX8KoG/UijQuDLlEUPshDDDzgbZ7DjkJcKU8hlNOApaT5g78LJDZ+lNwdZaJHhqy/hBzvZfB1Lz6IlQ8vjLBHqT/lMaEZLeS1TiPs/ZaWIQN568c2GS8Y/7vdi93+V/cWzp26utoL4BFZnefJVKSVW1RXY1zP0RhH1l4N1TwrnNog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p40n1bd20cr1m6MtdJ5XHV4tBBzC41ZMwVLt5dIExxo=;
 b=OVVXDp5BWLfCx24VaOdVu95TEg+p56HclZ3Kp2tek/gX5M4UR3r9jyPVz3b3nAJWplCr9oXJH339+zAg6LNJuTIQaKalawgK7S0LyAaPSSzcvap1CJCunEzsXXj7PaCsfmV4Wp0NgUOWA7m6BCJAeCCgL90tROCebItlpE+qhp/9k5QN1xwcjbbmd7Kli0GFAyfkrMWWGzqlzRoRPWGoRRDABftVKWVo3sEfRmjADCgo2x3pXp3lL7bj3937YwlV4E/6pbaeDtrGAlvh6LSj06NQrSGA0OmLe1U7ABQIsM/2EEJYthnbFBF2q5wxZ9JENgyvGaqUzeGB8oh8ErcYgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p40n1bd20cr1m6MtdJ5XHV4tBBzC41ZMwVLt5dIExxo=;
 b=Y0GfrCmgzS8P7c6/yf+Xy6U6vWwzI/sTcv2Ge99uZLLnGkSOTGeIxoSwOXYoEv42psptFKF5FVXzVoWqYvGCV9piQmC+q8Bv8jLBMYzIERgVEoB4D6E/e/jn39motw/QTWJCaLdWgtxhLUPxuRkph7adTPJTs3dH9HsEvxv4VX8=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:24:01 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 13/40] scsi: be2iscsi: use scsi_host_busy_iter
Date:   Sat,  3 Apr 2021 18:23:06 -0500
Message-Id: <20210403232333.212927-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210403232333.212927-1-michael.christie@oracle.com>
References: <20210403232333.212927-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb7ac6ae-7d6e-415e-eec4-08d8f6f7906b
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB35263F9963B706F588EE83A8F1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P2Y9dWNxEPK56dpUkewB0xaNFilak/dkkr5HvG9PGdvLOc2DKPN5fqe4++RD2VKht+Le5N23olsTP5mfJT/GsdByqTupC6AXOzLKEK1aSueb4aN90yJavcZrVHms61WYAvAxeaUneBLMkGMVWS+mplNAVnmIMyjFbpG/gwaIs21vDQviKl3PPWP84vLlVIQWmd82EB0AFNwlju3CfBrmycoyWBDrD1yKgBhkeQR71NyBQFehzQMEid0MIFSg1HekGPrTIIeuX4DWeFl1FuRP/uJ6t/P6r2Rf5YeOQkUDFnLkKwGJ/LYeCm8dG6hV8C7wifTZKLVy4LHtZOS2Y3RF4lZAJVBLnKfzav+gYLK7S0kQQjQFvboilMWdopxg1hPjF7J/zi1GclDtRQmvrneDIODeg8NGXhmLaRjo2NWWeRow7iu0evYZN/zMG/ZSYzHesJZw67BTQ2uFMh7e9xDnx55Jp91D5dO7AkWWsl3o/FUETyQYFyorf4IcKcStNtBBlq/X1pYQ756uBsEqketMSemu/nYDPGPaO1x19UGrHCuCPlSNGDRBqMmFyMPs3k3iCwbQ3eNmBh9uyWeHHd14BpexmCsEHRi3Bt1IPGxxkxH3058gorkZJYOiWSHy5KaXbnrzmoTPpYxj+AFeQamj2Lp/efPYFlDGl5WrTt9U4fCrwXCeXT6HDvFl+AR5BPtrb5ssaHyhz8lPKH5ftc37SA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(107886003)(1076003)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uHpoUgJ4ei9HszzdEKeLB+4teI0oo39ILMckykBPLf3KrEXKDCTKYnvWgpyD?=
 =?us-ascii?Q?DBcU6uAX9ZRwtPIiDAMa7MnzRscOo0QZdOr/zBGXxXDiJSXGLYIvErjacJdm?=
 =?us-ascii?Q?elZyzI4q/p40x5uzYzwSeQqbfih3sJXOmefw3FwtIw99bOzGiGxAHW+EArFf?=
 =?us-ascii?Q?pB15yOsLZkXpQcAzU+zKigzHpFxL7PPLyKNtGFdMGrSCdm71+Bj2qydn/AWk?=
 =?us-ascii?Q?JTwDN0IMu4zBtsRojVX9nrG22QSqJlndxbg9zYPncYZFdja+5fIyO4E7HEEm?=
 =?us-ascii?Q?hgor/d/aJ9DWQX3yMa8hAtZskdRvMNte+FNmwhKCBYHwH9GRT/w8cnGR4lBZ?=
 =?us-ascii?Q?NU3wEKPi76N6V11pZkCYzyhO6IHivk/YCbsixfQfSOFMxUzahmA6QFqXIAAS?=
 =?us-ascii?Q?9T/+EdE+NSOT22fGjM6t7wEEfDBhKEzrXsGrLP0fJXKiHHEUDyPS8qKyna1B?=
 =?us-ascii?Q?dBQa1gdc401BHX3/b5/J+iqupHjpkWQlfYHmZxskhgIRM9KnePkHfb0wyo6I?=
 =?us-ascii?Q?h1RIbC6yF3HSLSgb4OjoTj2m6T4DGCqzQA3XGdg+3fI1wnc1OeMbCmVQhp3I?=
 =?us-ascii?Q?6YBH/L9IN4t88ZEjigk0r65DkR7PyQC+yq8SRX9T6J5YXpWbM22U7Vx+Jrk3?=
 =?us-ascii?Q?2Hr22k5VPRPlRvd1mOK5DOpunvJ4Pet6Sok6tpiD2OcyOJWYjRHR4FXIEZZ8?=
 =?us-ascii?Q?Rw2OfwB5LmbbIpW+TuJ0eaUxFuBDJijNDduF4xCmDk92omJlLGnW4TtVOuJZ?=
 =?us-ascii?Q?vHrLyXy0D+eSJHeIRis1z62NbOGnuRkmezczTIecYIJl8/fsbTlPLpYO0moG?=
 =?us-ascii?Q?SgnQLUYD42rVhbVoP49emvMAC46uhK39rzJ6eZu6tLKJQhvHjR/rBIH6UcV7?=
 =?us-ascii?Q?fazFWI0TAKStlSwph9rHeSmuSG2oEpMZPoOdS/J/Jun9nxc68qM/KVzEGktW?=
 =?us-ascii?Q?jjxPNSfVW8teOqzXewvS59czYpzIoqshyxnSuezLjpThMliRd6/D7SlwgVuQ?=
 =?us-ascii?Q?TX3hQljyy37FWTLHqj1QiC8hUXgmCRzLxJ/MT9ts0wccS7L5PGYZsV6IGDP1?=
 =?us-ascii?Q?GiTP7VC7Xg+VvDeWA6GLsWWmAcql2pn3SggSwJfai7nSCJ3EdNe5OqJp07tD?=
 =?us-ascii?Q?5lLAoLe9BLg8Wl0uoCeRsd2liZ8qXxvrfynGVBB92WDro4IUp9pXnixTw/1f?=
 =?us-ascii?Q?I8Yl771o7o6aJntEVT6aFtXeF12oN+4Bx6sWvKGcOM6Orkt2eqlKI6h/kFS5?=
 =?us-ascii?Q?33FkpRfp3Oxj4E/jfy+NZ8+C7GWt8O1YMaKwO312MhXLPDf5kg40lf5E4516?=
 =?us-ascii?Q?/9gYV+OJIoX+0khxqdssj68P?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb7ac6ae-7d6e-415e-eec4-08d8f6f7906b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:01.5161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6k+XKYYeNbp9rqIJJDkO0cUqXgjsJ6h+bw5ep5I1hjOucHXI1GXiqbemZMLbFT4kRFvwfPbSRhgDjtDplne7gppuB6bIEsYlEwRoGctV72U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: ed4VM3oRAU9WqCpwoDiqSd0yu3PMcQlW
X-Proofpoint-GUID: ed4VM3oRAU9WqCpwoDiqSd0yu3PMcQlW
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0 bulkscore=0
 clxscore=1015 phishscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the iscsi scsi_host_busy_iter helper so we are not digging into
libiscsi structs and because the session cmds array is being removed.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c | 108 ++++++++++++++++++--------------
 1 file changed, 61 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index bcb12e674795..4d4e3d606e25 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -265,21 +265,63 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 	return iscsi_eh_abort(sc);
 }
 
+struct beiscsi_invldt_cmd_tbl {
+	struct invldt_cmd_tbl tbl[BE_INVLDT_CMD_TBL_SZ];
+	struct iscsi_task *task[BE_INVLDT_CMD_TBL_SZ];
+};
+
+static bool beiscsi_dev_reset_sc_iter(struct scsi_cmnd *sc, void *data,
+				      bool rsvd)
+{
+	struct iscsi_task *task = (struct iscsi_task *)sc->SCp.ptr;
+	struct iscsi_sc_iter_data *iter_data = data;
+	struct beiscsi_invldt_cmd_tbl *inv_tbl = iter_data->data;
+	struct beiscsi_conn *beiscsi_conn = iter_data->conn->dd_data;
+	struct beiscsi_hba *phba = beiscsi_conn->phba;
+	int nents = iter_data->rc;
+	struct beiscsi_io_task *io_task;
+
+	/*
+	 * Can't fit in more cmds? Normally this won't happen b'coz
+	 * BEISCSI_CMD_PER_LUN is same as BE_INVLDT_CMD_TBL_SZ.
+	 */
+	if (iter_data->rc == BE_INVLDT_CMD_TBL_SZ) {
+		iter_data->rc = BE_INVLDT_CMD_TBL_SZ + 1;
+		return false;
+	}
+
+	/* get a task ref till FW processes the req for the ICD used */
+	__iscsi_get_task(task);
+	io_task = task->dd_data;
+	/* mark WRB invalid which have been not processed by FW yet */
+	if (is_chip_be2_be3r(phba)) {
+		AMAP_SET_BITS(struct amap_iscsi_wrb, invld,
+			      io_task->pwrb_handle->pwrb, 1);
+	} else {
+		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, invld,
+			      io_task->pwrb_handle->pwrb, 1);
+	}
+
+	inv_tbl->tbl[nents].cid = beiscsi_conn->beiscsi_conn_cid;
+	inv_tbl->tbl[nents].icd = io_task->psgl_handle->sgl_index;
+	inv_tbl->task[nents] = task;
+	nents++;
+
+	iter_data->rc = nents;
+	return true;
+}
+
 static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 {
-	struct beiscsi_invldt_cmd_tbl {
-		struct invldt_cmd_tbl tbl[BE_INVLDT_CMD_TBL_SZ];
-		struct iscsi_task *task[BE_INVLDT_CMD_TBL_SZ];
-	} *inv_tbl;
+	struct iscsi_sc_iter_data iter_data;
+	struct beiscsi_invldt_cmd_tbl *inv_tbl;
 	struct iscsi_cls_session *cls_session;
 	struct beiscsi_conn *beiscsi_conn;
-	struct beiscsi_io_task *io_task;
 	struct iscsi_session *session;
 	struct beiscsi_hba *phba;
 	struct iscsi_conn *conn;
-	struct iscsi_task *task;
 	unsigned int i, nents;
-	int rc, more = 0;
+	int rc;
 
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
@@ -302,56 +344,28 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 			    "BM_%d : invldt_cmd_tbl alloc failed\n");
 		return FAILED;
 	}
-	nents = 0;
-	/* take back_lock to prevent task from getting cleaned up under us */
-	spin_lock(&session->back_lock);
-	for (i = 0; i < conn->session->cmds_max; i++) {
-		task = conn->session->cmds[i];
-		if (!task->sc)
-			continue;
 
-		if (sc->device->lun != task->sc->device->lun)
-			continue;
-		/**
-		 * Can't fit in more cmds? Normally this won't happen b'coz
-		 * BEISCSI_CMD_PER_LUN is same as BE_INVLDT_CMD_TBL_SZ.
-		 */
-		if (nents == BE_INVLDT_CMD_TBL_SZ) {
-			more = 1;
-			break;
-		}
-
-		/* get a task ref till FW processes the req for the ICD used */
-		__iscsi_get_task(task);
-		io_task = task->dd_data;
-		/* mark WRB invalid which have been not processed by FW yet */
-		if (is_chip_be2_be3r(phba)) {
-			AMAP_SET_BITS(struct amap_iscsi_wrb, invld,
-				      io_task->pwrb_handle->pwrb, 1);
-		} else {
-			AMAP_SET_BITS(struct amap_iscsi_wrb_v2, invld,
-				      io_task->pwrb_handle->pwrb, 1);
-		}
+	iter_data.data = inv_tbl;
+	iter_data.lun = sc->device->lun;
+	iter_data.rc = 0;
+	iter_data.fn = beiscsi_dev_reset_sc_iter;
 
-		inv_tbl->tbl[nents].cid = beiscsi_conn->beiscsi_conn_cid;
-		inv_tbl->tbl[nents].icd = io_task->psgl_handle->sgl_index;
-		inv_tbl->task[nents] = task;
-		nents++;
-	}
-	spin_unlock(&session->back_lock);
+	iscsi_conn_for_each_sc(conn, &iter_data);
 	spin_unlock_bh(&session->frwd_lock);
 
-	rc = SUCCESS;
-	if (!nents)
-		goto end_reset;
-
-	if (more) {
+	nents = iter_data.rc;
+	if (nents > BE_INVLDT_CMD_TBL_SZ) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
 			    "BM_%d : number of cmds exceeds size of invalidation table\n");
+		nents = BE_INVLDT_CMD_TBL_SZ;
 		rc = FAILED;
 		goto end_reset;
 	}
 
+	rc = SUCCESS;
+	if (!nents)
+		goto end_reset;
+
 	if (beiscsi_mgmt_invalidate_icds(phba, &inv_tbl->tbl[0], nents)) {
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_EH,
 			    "BM_%d : cid %u scmds invalidation failed\n",
-- 
2.25.1

