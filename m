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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36185C2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D09D61408
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhEYSUd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:33 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44154 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbhEYSUZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:25 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEmsW124454;
        Tue, 25 May 2021 18:18:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=jqXMwz/Q380XUGpVf4dqhdhRJ/FpqtEtMgs0TJaPBSo=;
 b=WjK9x1VxMz8gYFxqDpei6Hp2RZuGyvuvUk1DI2GoIphn+KP0rGsiaTQwiDeKCFEze63F
 WMzBYvi377SmcKpoGGOlfbm7Sw1mx65Hh15K9pGy2sceWn6+WGHZ/F5D2hVT+PMTXHcy
 mwWK+V9lMQ6fikDB8JBYkdupVb7s1/tSPBxnFzezekjn9BmduPqB0nxPWki8pX4YMRW4
 Tv65HmgXkOtBFKF54U/h8Ni1HsMYHdS0qo4Det/5ZGJjx7h5dgMvERewwdzxcH4xEhBn
 6K0D3PDYo3C3joCLKFSUeS6kaudvCwWSuS2u/n6Z6Lg1W8tbTRqcfOcTMrcPKsf3J7S7 XA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38pqfceyrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIGDX6010869;
        Tue, 25 May 2021 18:18:47 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by userp3020.oracle.com with ESMTP id 38qbqsgh0g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E8OzhWVXvHQD8boBQw0HM8yUmKbqHvgkZRMzcRO3EfF5zlICJnbcBmHQ27PwKkIEXaKEE2+RiLNnZURBtcKyEu7rpBIYmcSON/c69bqGoWtYGhfi8tFFuH2yaOtlNkhi3qGfgpeZuWFYLa2/IsIMIsytwmAJqjBRwo1jhigyDQyeTM+wtd+F5F8vAjHYHiU+kNgMmGpWhjhzYlib8UCKEk85yXbZ5o0aSK6WDyNqVcwpkBU8/1r2XYwoVuggWkN4w4gXKFPwbV7KphImyAp+j70VHchTXMlGGRPgjeXUGwU2FspAiTXF4WAYJguuoX3YWGpop1gMxOMd4s645PG4jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqXMwz/Q380XUGpVf4dqhdhRJ/FpqtEtMgs0TJaPBSo=;
 b=e4En0JoV2tR+dvVZh2GzUbo5wMq91JQgxn0KD84RtbORKAFrfIUzPE9kuARpm15kt5uUaJvkjEbx5EMBY762h8nCkqiKtxdYPzcQ8v9ijfW8QklCHWsd3Uq9mMaPFeYs+MV/KQRdAh4FkDpwTTPI59dO6M97jqhv8dTQsNstGWge8M290dPn9fsaEH1iJ1TOvwnJLAQPCrsOvjZFDnIMorxfJOk+TYpGyBvsP9s5i2WLufN7RBnPXQ8YXoZXCUpHqdZY09an3Yi5pHdLh5dV5G1TVb+2Q/WLhJu9/qjKCe5oBhUse8iEGSYasMMfJKnInRXkrPoXrIMNK2rIK39ITA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqXMwz/Q380XUGpVf4dqhdhRJ/FpqtEtMgs0TJaPBSo=;
 b=mOQDhvP9rWD5/TNg3iGHfM9AOYs/sFUn2rmoZa9cz4PLxwwREzgj+Aq1/xGsbb8ljI5aog11StZ2Y9jo1xMMVb+BWnO5gR1331npuzPGfdN9qmQu/EnuzTXAyOH29v1jwndGsWFAUcisogmbcMGQIUzrtPL9Ewg1/t+OpqYi5UQ=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3891.namprd10.prod.outlook.com (2603:10b6:a03:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:45 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:45 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 15/28] scsi: iscsi: Fix completion check during abort races
Date:   Tue, 25 May 2021 13:18:08 -0500
Message-Id: <20210525181821.7617-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525181821.7617-1-michael.christie@oracle.com>
References: <20210525181821.7617-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 289b98d8-5cea-4ae3-9247-08d91fa98886
X-MS-TrafficTypeDiagnostic: BY5PR10MB3891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3891D0F1EDA27925B48234D6F1259@BY5PR10MB3891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LSnWPxExjpRC5lsaXh1ffewDdxDJDb7COdH6tgMg7E29f3mIdPRWnqO7VtBvLmxwGDtBXT46nx4/w/u3z6NAlW8PgIFLYqgN9QOLDmzZpOpAiNsUlf+1tmC2Xevb1w1gT+LzYZeQdmPDGOuZ89ghy/u9bbb0HG2I8IIM/6Uo/tcBBUS+LrntgM0cw6ngkjRD/gRncPljby2N+QL+j5PIcsq/IsXppc8LZ9QRe40ozHuFmY9hryfH6FxIXuS0rjpcGu3OpAmVX5Ivsidp9CogXYifoDq6vz2jGNTxtajcf9sXeqUfWQClJBzH4BgvLNC0LDSHm5FTKtpX09vG155kYA5SFAEuT6ehVFKQtOoYCS05p6iK1jKz6soIhH4W+Pi+5kX/00oKI7ItagZpmi7YUdKuBTfmRFdof53RCkIyW5pfPpxO44f557U5EhSRC7GbBPDogcPiRXz5WMFBul8qPboJnvLl6+KVI2roev2eD8wlPD8za5POs9qTwYzuR0oPv8TgrGqJZdqWTCzCesmf0Nu1gwmpMJP+tNgFoKiPbHcWmWpDnCnoXDPql0cZrK6ILgb7wWjRPN0Z6x3T1suI97bPSZCtzdD9Tsi8tDJn8vgnuWafkd5WNdV1Vw07avEGa6Xdtk9I655Vlu6nGx9st6uRD08+GwzfAJbYFFqSCRaARrhYkTDaCJy27mWPI2OM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(36756003)(83380400001)(6506007)(66556008)(186003)(16526019)(6666004)(52116002)(8676002)(66946007)(8936002)(4326008)(26005)(66476007)(478600001)(38100700002)(5660300002)(1076003)(4744005)(956004)(86362001)(6486002)(2616005)(316002)(107886003)(38350700002)(2906002)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9r7D+f4K76WoSdRsSAi38CTC1xFAEnJOSEqpKNyO7cPqOdHqW9RJsFqzQ1gL?=
 =?us-ascii?Q?zzQeEv8tMp4vGeyhrDF7OUkbnF9a0biPNrCSphmrvh6xec2CueWX/s+tj8kf?=
 =?us-ascii?Q?OQsJrnlhTWWBAf9gFCVMQO9ytHIub5m9WGpfwZqQjCOOwOgZZa7RmaUkSB9V?=
 =?us-ascii?Q?/FodYBdafG2E7yFpct1N/GR2CK+gM2jpBoeJ1L7aBQqzDgdu618EY6LAwJVR?=
 =?us-ascii?Q?7UjEOhKDtIIFQ9Z+ICYFPObJc3dvRM+ans3t2wqdspq3sy6Hc+bFCqZaD8Ji?=
 =?us-ascii?Q?+TPNbFU/kO5YSzTkBiNIN2mB9nqxdFdzMFJ9EGGlhb01pDBeh0kNSIn/QFAu?=
 =?us-ascii?Q?e6Ga1NLn7uTeFcDJdpTBfLu09HjOXuGhaxmpcSMI5XItjJupTGs9a9/BC5o4?=
 =?us-ascii?Q?ws4oonFS2URYrMg88cnNgF5wNz11xkED9McQ9W3MsZSGOHznOyXKRkhHEWt2?=
 =?us-ascii?Q?PNfMbjmnEgyliyYgAedCUxoilaReHrtbhNo3tkV2lRdIioESRZhDXHOD/TOg?=
 =?us-ascii?Q?UInYAqYCOfsolgL5NDkyLv8L/d5iUVIlFBZbLIyh5GAwIXZXqMhQVKdka/nK?=
 =?us-ascii?Q?bofg6lr0N6zZ5g4CDZ8Nh2GtekelzwJdayeDy9Dm/Weywm3HqPalzTzHPtE/?=
 =?us-ascii?Q?FclqWnXhZN5G/vRU9Kz4E/zwJLcEC+aeSGyWtYvFYy9jGyIiSbk0Pyku/4gp?=
 =?us-ascii?Q?IakPFUYIE+1v6AL+Z0KJR7v1WAPJwqfqBL3C4Wktukx/voDdoiwZ77IW3uD0?=
 =?us-ascii?Q?EcK8O0fk/3wcagVZMSKELlZrZX16SWKnEHd/pdeLj0eo5NtB5E4VpNS/w8qQ?=
 =?us-ascii?Q?V6Dq7WZMVmId7SdWLbiD34Ohvp14WWNQxcuVB9agJ6xoLXjzqpHywrTPwm8C?=
 =?us-ascii?Q?uOzbbj9UOcuHAcCv7DcD4EWVv8hWTOyaxCaT444okxR0etx5fq7MZauSbS1n?=
 =?us-ascii?Q?UIFfkX1PuC7LdVQbt5ORNsiQdYiCZvXpQcbfvU5830g5G7CIZcnXz73pmFHD?=
 =?us-ascii?Q?tmVCrqO/zGi7zc1SW2VHQ9nzAJNZtGgu+UAgTfYPxYNonFJ7PNSSfQJj69CO?=
 =?us-ascii?Q?cAUN++KXcuLCKLNIqju/03A32id1wualXlvxgdBBur0LAfrwUUIQ4oiVA7lx?=
 =?us-ascii?Q?EVFGHSPBlzhM+38smxtiDkcN3GCg+krYJLYFuswESyD+w7/ItIUbJLZH9MJZ?=
 =?us-ascii?Q?GkFGDQgzKYRhjAXf+UZJmwarCxCWJNG0/HErENqeg7bxyBRjLQ7nQ/Ox9hJi?=
 =?us-ascii?Q?LOfdIGqgyu0oKGWySaStg+OC01zz4TQA2aCBOLlo+d8sCkoEveHf/MFRPXLV?=
 =?us-ascii?Q?+YCDQBdmovBQ28JtW8c8/t0x?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 289b98d8-5cea-4ae3-9247-08d91fa98886
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:45.1899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yh9e0b2D3fRIBWNJVUox83Ae+Qon7HLlAjCh3UwYr0XDPTwgN9Op0nsEe2QondjkpCwxDoSf/QHJYbapoZ2xcggJpe1Kt2ZvzFtUTggPUko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3891
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-ORIG-GUID: Qb_uzDDqxOqEdPuitwgvEWRm6pVh3dm8
X-Proofpoint-GUID: Qb_uzDDqxOqEdPuitwgvEWRm6pVh3dm8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have a ref to the task being aborted, so SCp.ptr will never be NULL. We
need to use iscsi_task_is_completed to check for the completed state.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 94abb093098d..8222db4f8fef 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2338,7 +2338,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 		goto failed_unlocked;
 	case TMF_NOT_FOUND:
-		if (!sc->SCp.ptr) {
+		if (iscsi_task_is_completed(task)) {
 			session->tmf_state = TMF_INITIAL;
 			memset(hdr, 0, sizeof(*hdr));
 			/* task completed before tmf abort response */
-- 
2.25.1

