Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D8BC4707A
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75F96610A6
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhEWSAJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 14:00:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52004 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbhEWR7w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHvTA7182428;
        Sun, 23 May 2021 17:58:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=75cFGpSkp4kTZYhKnpulbxl+qmSwsO7M25rHfB3ci1I=;
 b=QBGvSZ0ImJIguhmS2fZ89dCx2YZkWRFdgi/aedqanQC3WOCAdLzqm3+aGXuyXnSNcirD
 i9Ja38j5qLtXIdwdLp6WbmcgWIRALBRgurOJBonlwGyhmAPj0U7+zjs7Ia/ckBqmIz49
 rwSbALeKAnYNwSRd8EAPS85s+UtwrHrnrarn2x493zB0UpzYAGGXx/wIuTglSf78wXtK
 K8XgSek0F/TTELZh9Ptw+PUisr0233LlIVam3sc2O6pCZVl0BAEJqWSADV1RSiZGyES8
 Bre1mmo+fH/saAGpqmKA3tHqUKZvi9/wyFHiQgogALYBUnq9am+EddfDBKBNrD8gU3Ok gQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38q3q8ryya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHubDs161766;
        Sun, 23 May 2021 17:58:17 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by aserp3020.oracle.com with ESMTP id 38pss3qbsp-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YE3TrVF/q6E77I7cTQc6PDiEOica4oIsUGP1MijvUDnOUbhce/638YyCrO9XM1jqqViV+McoASB1qKHavDNDJrd8vTkBEQhMb7Gp816/XS5jFQ9h6dZU0IgUozeCLHaZ4lUX1MoMX0QrSEPPOg8XvSX4oBAHQC10YedwGE8xA9J/YfF+O8BB5HnJN81qxTWKfOBCXr1NVwMGWlQjqWTgEmY25b1TiSpsYyftgWxtSTpwV6hJi9vqvZXFUmLQHSJaMYuq1wM6KB1BZXulCbow0XHxLiq77fwOMxcNctC8mkcMJP0QmZmv4N8I3YEhrXJmUkYTevCXbLFlsJs1R20JBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75cFGpSkp4kTZYhKnpulbxl+qmSwsO7M25rHfB3ci1I=;
 b=W/KUMIkVIGy3tuMz4FhAWcYHgJwiTvPy+Il1DqdjQxAYd7wB4sBN7+bKjMgv+JHwt9sUUwIeh/GkD/7GnYRA/RLgNutEZgnPKzxe22CJmP0TGZ7an7dsfDvP5EQLKCIyxjoRTmejvGpTXCX1Vc9ZeJQFVJg3OGGxrYtgCHHeIN+pYUd0R+tuL4n0tXp148HIFbIUJe4gPMV9OZ/nrvmB/G2rGf4T1ldcpW/6I8K5v2FbXrp8q1+e29VUBUpEt4bnB+d/8JA10S/6UT8/qlyi25NwNaSSFfFcGXNd0dS7LPZQAAxnxBqPrPL5FY5aOThVStiE3TwYDPiLoYwyhfB0qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75cFGpSkp4kTZYhKnpulbxl+qmSwsO7M25rHfB3ci1I=;
 b=mXiG3Ux5lqvoMaJl4/jY9h1WlbmaqYfyQgVBQuy3NibYnr0ZOw9I1QYKdzSavp8ORs9jZxzW8MihKsZXpBdjWkJh2X9nmW5mPqO4l/RyeYW55ElXdDiLIAiph6iP9+OuFMmCGFgaXWUa2feJy/dcaZVyFoaPOSDcs+9gxgkC4ME=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3239.namprd10.prod.outlook.com (2603:10b6:a03:156::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Sun, 23 May
 2021 17:58:15 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:58:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 24/28] scsi: qedi: Fix TMF session block/unblock use
Date:   Sun, 23 May 2021 12:57:35 -0500
Message-Id: <20210523175739.360324-25-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523175739.360324-1-michael.christie@oracle.com>
References: <20210523175739.360324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:58:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51863cf7-a1ad-4eab-6eb0-08d91e145696
X-MS-TrafficTypeDiagnostic: BYAPR10MB3239:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB32392AB120127EA25A140E46F1279@BYAPR10MB3239.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 11l3fuTRPatlXpb+NN/4EBN1Eki1F5+HYsPbScAots7IUvjwhb5NETIk6pce6480U+Nq4aK436OLDtNWUU+KBbBsrBxXWup6kax2Ahza4bs+W0jKNT8OkSqD3mC6D3UgUHc1iFacCHhRfKAsOCUwspupdMlfrMl1ru9Yd7gJLUNEonT83TqzljiodaxRTcpCTcl4cGLTJxtjh5brRSol+nHM3QSf1M3nsspUwNQvGZ+6nBRrAzhxlNOyz407hnBteA6YxAZjJlyCgoYtbwGzlks/U+LLJ80m8mNX/QTrYomMRpM46Py/1oPbsugeAZHomtuFKv+WeafCxaOE5/f45YmDe/ZBqfFipMD2hYZMiJ00LQMtiq+zhoibbokepzBc73xKTj+P6blw2fULvkjWej3M+B3M1mwPCt0pBUsfI532ADK+FeAvbHF7a3LgyejEXWQtC4mWlLVmKn0hRX5tFo1po3j4sP0gupGgvDcWo8IxtpOE0pcIeQbQVeDynLLhazgnwNvJ9cGA2jHYroa2yno5iw4CzCw28PzLIaRSirmo+zDwsHvLezhXKyKsBXrVRDR02etvM5UD1edDSMnHzu3aNRIXIdejhUbE6RkWkM91Rbw1erRV6Lq00bq3zz8bCWJd9BJYCtR/xvlZBXqMIN43b+58EJUTR2eT4UalIwMaUB/lUsU8IctPfkwYme25
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(396003)(39860400002)(52116002)(26005)(86362001)(16526019)(6506007)(2906002)(66946007)(66476007)(186003)(478600001)(2616005)(66556008)(8676002)(6666004)(1076003)(38350700002)(38100700002)(83380400001)(36756003)(316002)(8936002)(6512007)(4326008)(956004)(5660300002)(107886003)(6486002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/SSufTnPMe5InmOIbqFERWsfpIH9Q7C04R6gdx/r+0GlaEHs4vSHfmhIpvOw?=
 =?us-ascii?Q?jxEQBrbI3IiUwlRPG7YdFXbvOg0pBH+kxVo+ZN0IW628tXjQysEYRmQIw0x7?=
 =?us-ascii?Q?wlitw4Uyt1SuM2RvaPMZSiWb9IDQH9GtHSMoAaLsJ+xlDbZd0bMTIOkRabhH?=
 =?us-ascii?Q?hEtR/7O5Wg81EvkuHwyxxya2DVhrAU/3Xe1chQrEtO3eEqvKMTZoVNYZfk6m?=
 =?us-ascii?Q?cUDOXKdkS6J3tFAp4TnD0E1+XVmdzZalmlhSu78uj6+lB0shlPbwcemJuwax?=
 =?us-ascii?Q?HUzjeu1msCZl6AY+34VWiaKPlT0VLrrThJXM4CPsvzZQ28EgtimLIKiqi/f3?=
 =?us-ascii?Q?wd5WKjHoo9Cgk+HasQkKppKDok+8Hnc5mZ0+cPTjrhuJvNEddvPQ50Vng7PB?=
 =?us-ascii?Q?JX2enkjprh7+g1WP71PoqWozVeh6iDwb7rbn9o8N/cgstDhfUjvDKWoN5nOt?=
 =?us-ascii?Q?qEuFxk5weob1m2eT4YkcMDYfO3SOrjn6haaA7O/0gpg2BebJpo8Q3MxUGv9l?=
 =?us-ascii?Q?0dbZXi7YORv6efFt81bvbYdYogeegnP1Zwpb67W6/u4PJQ6Ws41S6AvugbdB?=
 =?us-ascii?Q?DPu/aH/GH5cs27QR+Cah103B1WmO6jZewTk5oRfx0dBpDQw4sHDf0fJTF+OV?=
 =?us-ascii?Q?nN/LH1cl4Xo4u6CYcS2ET887N9ks+F6Hw/5O3/7L4G7ju1Hq3ANNNLdxMVnc?=
 =?us-ascii?Q?z9ULajqgBQSAYhXZo8e0bcCyfPXjvv0Eft9NdDiVhyQH3uVKQpFajrWW/rkY?=
 =?us-ascii?Q?+T5k6NcRNKHSI1mM+bMcxFJx0eRdkGlhUVp77QJPm7vBx9VzxgWjbZm+C290?=
 =?us-ascii?Q?yyRfA32w1fvk330T8CZkcuPH0ufbRizIL9vy8rUjF4ZrfYxachCJGBwDBUSM?=
 =?us-ascii?Q?bfHWdks4p8/t6m0wRL/ybUN59m2PCp6rOEgQSGNBdLY1+Xq+v04vBwM3jRxv?=
 =?us-ascii?Q?F5nGkXCPbrC7dwVPVHb443gptNMEheJlvCv6Tyb0Xt+x/mXb9s3AJ66LnLV/?=
 =?us-ascii?Q?PDk6m6Xx5aRenhLZN+l/+pTMHM75lkrXgyrstQowiYiDs4F2xS9uqcFqO3jy?=
 =?us-ascii?Q?qW7BJN2/Acpif9taVRsEolJlbraq/QHUEbvdm5mFyANk7uEc+/MJBy9Iwa56?=
 =?us-ascii?Q?i5sxz6fKeu9P1Uq5JZSHSJQz8qM7+8ORw7t+fRDXNNm4jE3PfnnmLSBc0tZJ?=
 =?us-ascii?Q?4oa90HtDRc6iWkHqVSKBrTd9bL/sqKE2rs/ztCPcsGUdV5cwxLSXvED3ZxvB?=
 =?us-ascii?Q?dbumoleDH74yAqgldobfNa6z6hw9i8v/n56ECb1pm0J3bMUptRX/fjp4z+5B?=
 =?us-ascii?Q?TFOvNPZTBAOPVWVqF84jrf/m?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51863cf7-a1ad-4eab-6eb0-08d91e145696
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:58:15.2323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o0T0S85RYpFqEaCBy1lsDE7TpT0oviFnmzj4A6C7ls8gLAjbg2vwXeYXBdadMbMOQiGImy7C9gQsVMEdOvWHiePywefLm9HKoQxU1D5QNYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3239
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
X-Proofpoint-GUID: 35P3jyqXIDFB-g55rQ9WDqGd3RaYaAkQ
X-Proofpoint-ORIG-GUID: 35P3jyqXIDFB-g55rQ9WDqGd3RaYaAkQ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers shouldn't be calling block/unblock session for tmf handling
because the functions can change the session state from under libiscsi.
iscsi_queuecommand's call to iscsi_prep_scsi_cmd_pdu->
iscsi_check_tmf_restrictions will prevent new cmds from being sent to qedi
after we've started handling a TMF. So we don't need to try and block it
in the driver, and we can remove these block calls.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index e82c68f660f8..f08fe967bcfe 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -159,14 +159,9 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 	resp_hdr_ptr =  (struct iscsi_tm_rsp *)qedi_cmd->tmf_resp_buf;
 
-	iscsi_block_session(session->cls_session);
 	rval = qedi_cleanup_all_io(qedi, qedi_conn, qedi_cmd->task, true);
-	if (rval) {
-		iscsi_unblock_session(session->cls_session);
+	if (rval)
 		goto exit_tmf_resp;
-	}
-
-	iscsi_unblock_session(session->cls_session);
 
 	spin_lock(&session->back_lock);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
-- 
2.25.1

