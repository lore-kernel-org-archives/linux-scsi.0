Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE05C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E6F4610A6
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234928AbhDJSlC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 14:41:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47596 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234903AbhDJSlB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 14:41:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIeTcH066784;
        Sat, 10 Apr 2021 18:40:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=v1jLrcZyeDZK/Caaq8C1jQgHu7GV9NQ5XyRZwNBf6i4=;
 b=R+Qv2fu2rALtDWFt7OuOluqekIltIZQCGIR5o26MK+aHNK0dj8Wz1yYMo71nsjFS7R2r
 7sLJ2D35XfriYsUV0UHlf9jRg5Ucxcy1wufZSThpCy/FlRSHpIh7lB2eo4FVXXmk4WJY
 MDVRhN4i5ul1zNxeOoeXHbKziOu3ZtYOVTr9p46IuoVBUk29IpHt1e1MQEAyWYgj24vx
 3VGCNtrePtBmaWl9jirmOEj37N2+p3H5XnHyhPqo1alZLfOT16aUc/dBXXBnxFtRB5/q
 Mmv+oIJZnTviEVxDktguQvlXgbGTDpHjuEm/cE2sJdDrVhnQpbJl54R3CxEDZrgrXt5W Hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37u3er8stk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIThCS176756;
        Sat, 10 Apr 2021 18:40:28 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3020.oracle.com with ESMTP id 37u3u1q4cu-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K83MP8iO6qpTX1OX5hj5HhL9ia5OV66toLHMInM3xMH2lasG3/IBcmxHI6Da1FH1ddS35Ea1tN6/9dDW5EL2Fhnb/oeU0KmTgnQQeJB1Il8lRQ4IgbnlnUMXpv89PBSPl2K9gIJuvQj82zGcmGvS7GqrjU25Ty/vLU6rjZh+4+kTK6eZHKnmtoVuIxWwCxu3cFX9Qe55E2wWPtKSL/g8dh4jjXrZpJdTxpfoRr4gDSnsHkrmUDvTdnU6ru9t7s3gSaJr9aB9zPlSgPEOUcMYxZI33KwP5zCE/qVCa8ZH9CVteu0ukZunvE6EnKuPmLQ41WQq6KiMpBYI2rzKFa5E3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v1jLrcZyeDZK/Caaq8C1jQgHu7GV9NQ5XyRZwNBf6i4=;
 b=RzsRlPcDBhg65dAqULyvqOkdq06f2T1TENoKloxRlzzg5oK8v/O/WsOtUFDjJb+kZ3+zkfdw++Wggfyc5lqepKvbF6UWVGejN/fPEVYLvNHXK0WhaSY3oCWCYeIwDCYpm4KdmuUiodjvjNCLshuRZHR4jbC06L2LRZB/hXUzwXYunBGO292TaQ/y/wBwiCZkA7OhfeGvmzCwZNYAyEQG1JwchdjeIgrjWYl2+1aD9cuOj45q1SB4H4Na6xaUCugEk7Rb3sahIlk3N27N3haJ5MMlpu2whUrg++OF0TT1wx0L/l8IDPTqr4CY5+/9vtz9sBheh5/NmlG2WIbJ6Zlx9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v1jLrcZyeDZK/Caaq8C1jQgHu7GV9NQ5XyRZwNBf6i4=;
 b=xzuBQrvEfwAnrCzl9YnAibj7BwKfU150Zn5OcQW9HlY8811/X+wEK27kTCFK+XfbWQO2RbLFOMUGiH/QyKCRcVdITAWN0phG73oq8dLpc/S9w5azZrp4fTrONT1v2WgZkJ/DhGMuLZbLbKs6ZsJqLAVEr1bKbLBPZahi5E+Wn68=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4324.namprd10.prod.outlook.com (2603:10b6:a03:205::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Sat, 10 Apr
 2021 18:40:27 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sat, 10 Apr 2021
 18:40:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 02/13] scsi: qedi: fix null ref during abort handling
Date:   Sat, 10 Apr 2021 13:40:05 -0500
Message-Id: <20210410184016.21603-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210410184016.21603-1-michael.christie@oracle.com>
References: <20210410184016.21603-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR15CA0036.namprd15.prod.outlook.com
 (2603:10b6:4:4b::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR15CA0036.namprd15.prod.outlook.com (2603:10b6:4:4b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Sat, 10 Apr 2021 18:40:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71c32172-cbd9-416c-a18f-08d8fc501c06
X-MS-TrafficTypeDiagnostic: BY5PR10MB4324:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB43249174B6723779C5F7AB09F1729@BY5PR10MB4324.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P5DYMh7kzCaAfK/Ntj2IlvgX8rHdn9gkIOtdI+v+miABiBGBgZ+ob6IdkLSMceESruWn3H7zdXr36B3Q/suFtK6yhBQYWlSkUO56wOLTUdhUV7RFmwhXFEy0VYMpTwioRbWb6DWlmFReok3qbs3qbDj6Numnqe20kN8VKLAnSzEFJhmjiT4hYkC1nudhQXsIVhb49N06TKk7Qv22eB8HTsDJUiwaNpU0uUG5+0VmlH7nJbFF37rsriAL+9UQt3jSTUvs/tQXwLplmk+FtJ9u/oGKKVW6QEDZef39B62yRskxMMRBnn37hcFKtSjRr6rPesV04Vi8lw7LRLhKZIls0t/iz7+2Qmpko+f6wLeg0v0HaekIriS576AkWxFn0+7THcoKlDaE/kGc+hTRiaqjGT4c69g0CIZb8RD1uFO+5FpybsWHTAn7bIkEFMpiSuVxntsSixjMS1DQ5tl6SwSeqDzC6w84JqUKZen9y04CgYI+yRXxE27/jrndJzqfDaZ0XNPQh+Mxg4J5fvqfqpSvcMyoCEU97wNcJ8wlvJcwHGMGdHcptlKUeB/e1zHJ0s2mdfOACulbzq3fNFI32hwAO5/BVyYNdKpvzBpr2epTqtzqdXXStjsX7JYR18lECXjux9hUSkAKuxCGZP24Is59tkxjiAGoABmtio90LONgcqcRyl0s0fKSRKUeIJJ7Y/P5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(346002)(136003)(66946007)(66556008)(66476007)(69590400012)(6486002)(83380400001)(2616005)(8676002)(8936002)(16526019)(186003)(956004)(38100700002)(38350700002)(316002)(6512007)(1076003)(478600001)(52116002)(107886003)(4744005)(26005)(4326008)(6666004)(86362001)(6506007)(5660300002)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3ZmL22l3VJWuvJxOwmfSq/Ie0V1txUVZzLE4fsrAybp/UbVzyPeE+3qT23Vf?=
 =?us-ascii?Q?W+zPiXrl2ukJg/2i9HzL6ytQGihE1B/uxutB+VPH1sRrIecPchzL2iipYOax?=
 =?us-ascii?Q?VfafjHikNQgr9erzpqJCuonAfo1IqUDUzRr4e5sBn2h1VlAt1fMiBZDKRbvi?=
 =?us-ascii?Q?m24W3l7UTlTcWx7RPPF7ghEzfeAeOfIRFB/NBYKDoQAcESNFxGXZcJBKXAsr?=
 =?us-ascii?Q?Vdg6AKZFlLrsC1Q22u4/6zumnqo3qMex4Bc4Iqh/KznabKgUUQlw3GwiXATW?=
 =?us-ascii?Q?pvW2PFR3KSiGdqC8RGcH+7pf5RKTbIuxewsAdR3EsRdMYJBfHqTvlhFLrYTe?=
 =?us-ascii?Q?Ym9wbzhUbE7HMBPSUoq+cdyInOktotLyPiCiJRlzSmqZqpidnhMnONXF3WKX?=
 =?us-ascii?Q?cqXUvvI4OgIeHagjNj7Xd8asKtY1U1afnF4y7xLvJZrKOet2KEx+RaoQudpR?=
 =?us-ascii?Q?VTfqbLiy+xMaqH0M8Xsb+T7rPTovDlGwXhaz/fGe5bHWfzRpZCtfSvkTN5iq?=
 =?us-ascii?Q?nCOWnRDkgXvuxAUkRcW80ELIspb2vque10vnbuN8jpGAolnFOjqmIFm7vwIl?=
 =?us-ascii?Q?iXuzz5qLeWuBBvvQGddu5et+J4FrGfGxZ9ZuOZH0jLezbQyKOOx7MZM65VCy?=
 =?us-ascii?Q?EJFcLFwM1DTlIzOnulf5hKsY97py/TvTOfhnLFR2ChTQOABCgo/PR4GfUC75?=
 =?us-ascii?Q?cSBMZItzLmodLddwWVjPsY6suiVXIu31+O5jU1+VrdS9KRn5rNbbX0e02+PJ?=
 =?us-ascii?Q?6JUKmwwNuS3cUC3kD3cbNMxipguNk7HMDebQ/oVwnOiLGWBNFgFDHjRKmit1?=
 =?us-ascii?Q?bylCgcklvHvktsvFgoFCppP7JWrW2iX2APMJCaCiTNMLxYjijTuJpL6hfYfz?=
 =?us-ascii?Q?aAzB1UR9p1v4I5NC8OmHKCfukhCGP6soen2Q3CeXv7GfEij10OQEifUTAEVL?=
 =?us-ascii?Q?9vf1tM6gKhGoOwtcdMeTABL6pnQpEvVuLPpjAkhaNia3KP+OUKulVKALEZww?=
 =?us-ascii?Q?RtBo4JVpuTD2qXKYwiOpi047S0kW/8a1h/5Or2pGkZh768v7TmlpvkG8RNTc?=
 =?us-ascii?Q?rbSG2sTc2rKRbJEaOsp4knWOLJRcW6GNJyLdZLiN4e/pHK6iVsdaZhnOjlMT?=
 =?us-ascii?Q?vOxG6+ZQ898TuQcmgSxZPq7+SIzAdRYDAX8cfEfOD2Lmkp4jFu0giUjL5zPw?=
 =?us-ascii?Q?nSTw44zPbSJqDqqmvWqnk0b0paQY+lyfHS4vwSfjRq39TK2G5wKWqO6mFhxM?=
 =?us-ascii?Q?nqW/IZWT8fjxAWGxQmZNUTDd3OLurhobdgK/B7yp6JmE28jA7jp8ncxxCaoM?=
 =?us-ascii?Q?lUcdrUY2P3fI+cBSo4L8iuIZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71c32172-cbd9-416c-a18f-08d8fc501c06
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2021 18:40:27.2643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fH7qumOeA1CO1viw6/S4cdqGonhFYjbwdT/H1zvQR0ksJZZ4MxfNNJV797hQqzb3FxyvHPj0EWx05/tRuz8rJfx/lImyVHsypvAxFAWpJF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4324
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100140
X-Proofpoint-ORIG-GUID: FT6npkWuq5n70-o4TncaXYZdzZp0G9tP
X-Proofpoint-GUID: FT6npkWuq5n70-o4TncaXYZdzZp0G9tP
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If qedi_process_cmd_cleanup_resp finds the cmd it frees the work and sets
list_tmf_work to NULL, so qedi_tmf_work should check if list_tmf_work is
non-NULL when it wants to force cleanup.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 440ddd2309f1..cf57b4e49700 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1453,7 +1453,7 @@ static void qedi_tmf_work(struct work_struct *work)
 
 ldel_exit:
 	spin_lock_bh(&qedi_conn->tmf_work_lock);
-	if (!qedi_cmd->list_tmf_work) {
+	if (qedi_cmd->list_tmf_work) {
 		list_del_init(&list_work->list);
 		qedi_cmd->list_tmf_work = NULL;
 		kfree(list_work);
-- 
2.25.1

