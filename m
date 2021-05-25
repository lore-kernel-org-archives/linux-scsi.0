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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C0EC47084
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A632C61404
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhEYSUl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:41 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44274 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbhEYSUg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:36 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEtld124461;
        Tue, 25 May 2021 18:19:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=6TT9MKGyAYjEnfdOdUJ/rY8NH+1aB2ZDLGKA4BgqzpU=;
 b=oitjl34B9NrYx83qBwBgXJSCF6H7lpQVABqy/6ssG6PEbfHiWKBeqczGUGc/rt98FdR1
 Rdx0v7SzJV2XEYQlUnC1gOgTK2g+VX+AU9562VXAGb9Y49/xlla48NFjYTTcUBA7e0ik
 bR2TTESuSYX90Foe8NOuhsF6d5/uSUcHXWO+BX2bwnTSmtj5MTmNxxSRXDNVWzUT6HhS
 1xnUDeEofakKTjUDpWNBWTJyRNpNIOel+57TgnTRV0U/zhN+YHT9qFMvnS15+08OX6U3
 M2HIFvfMDbPOmFZMM9LIA5jgbmNs2QjEd8+gEWWGrj3dEBWKCts6+T1Snh8KPlrXrh8B WQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38pqfceysb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEulo166263;
        Tue, 25 May 2021 18:18:59 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by aserp3020.oracle.com with ESMTP id 38rehaq64q-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Spj7XtOVr5yw3VjwP/GZVHumpMO7M7FcNF1aBJABa3JjKT7J0UBZ87Qz58BGJTJi398KWZLfxGYiwEsLxfDkUacg5F1nVVQQmSRfr6b4kV2CNrnqnflsvKm4K71UEQsEDpwCAnwovjmY34anIOBefIzOppnUMpKvcwcKzKnR19utNC061f0OMi2uF1k1xgAQ3yLZUESNDZojwiU4dQ7wl3naYLnjdz3UGTjPhnGX8kANJtnsQevDgH/W1fe2M25+F/u1BmkBL9jWafUbTw4+vRWQSQtue2OjjfagShLGw+Hz/l5wJuaSAw5h1wGnNlWELfelGEGAWEKGUgF0X6Wp5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TT9MKGyAYjEnfdOdUJ/rY8NH+1aB2ZDLGKA4BgqzpU=;
 b=HUlE1eGFR2yTBAsb3/aV4NvvgNwi0Bx8TbKD6PrL1Y/3Nt9E4OZjljOtG9qsd6vgv51N3+m1nJEpMRRQU3tFlrcGFK4aYcnTS9jh1Bf4Q+i3ZQYhOcvyagl94PEtOL3qQD5LYntAz/oQOtQBTP1of5mwSG0GMUcHbzRip7PRW5aXl/77qjFM8jzQxk99jXWibZD2veEre22subJUTapNQNt5LPTc0eLdYpF3TdAqVrHczESpqEndkOAVW4Z6iIbbE5X6e/uXmWzdZehMl4+I8vDqlOwx3vfhFjOb+OVtpC+9EOCUDNJdotPl39106Vsnivfls8WoOHJh36YNHOQJqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TT9MKGyAYjEnfdOdUJ/rY8NH+1aB2ZDLGKA4BgqzpU=;
 b=OpZPk1OWeM+3tKzmS5JG9Ib6YGQqfwZRXYTlxU3WXa8nS4NleebaGa2YR7esQWNsXNS9LvKZFnk90X5+c8/SaL4hPnwQPG8QVWUZIh06R8QQfCH2M0x+KExl3JctGn6i6hBlBs8m8+IVIZ4XDB6AZXm/XTCG+lpRPeBVzBG/L0k=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3891.namprd10.prod.outlook.com (2603:10b6:a03:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:54 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 23/28] scsi: qedi: Use GFP_NOIO for TMF allocation
Date:   Tue, 25 May 2021 13:18:16 -0500
Message-Id: <20210525181821.7617-24-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d40a1beb-4a2f-47af-e987-08d91fa98de6
X-MS-TrafficTypeDiagnostic: BY5PR10MB3891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB38919BF9B9FF152FB6B24210F1259@BY5PR10MB3891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:404;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a46k7o0sPdRLSY/O+FcjsQWzMC2YHXx383aHISZgT0Of/q5g8uSX5a1tzho3HgmN1D+xjpLwKR0LGdNseFdzZuCYGI6wvNzt1a5R0Pk6DOQDW/JKQz17ToSIcoBksSp4mk5b876m/+BISr0tdVRYnwN10FXmrAKvP9EI/CDwlAYrn0oRVGno73ZDc5f5QK7iRrOVgIvTbOPEgkPzod/2ebIQJ0YTuePqYGKPjNcYK8FRNX/E+LPzkzyB+Hg5EMQW5bieFo1BApOomG5dlxx+I7xi9QoCiiN3HdWk9DWO9PtQZq0ihFyFnUGCYkRVU9chht/cRoHrWH63snm7O5Q+dadIrPMd6PB8kqlO7jtDVhWfZm3mzSmAg55Cw9v3/eFCFiEzAZc7YGl9AoIu2EDduJFo8xRSUpv9iixcz/cAIuPvv/uHN4MOunmjpWrAc2iK/5ObldnwezyFSLF2XjvjCIsR/0T9Semm6fSbHeiooSdkpxjmvieqJtj2RklKbX/j9QT343hyzMB4oD2wT0715Jq8SlLwl01ty4AlqIYZuH02kC0OLT+O20pwacSKPTxedigPUaYbuT64xOnzQugdbOkOHJ9OUapOb2LWFlCjT9jp7IMVoh52YaGNXv4g0yA9rMxqXLShQMt37BC5exs1fPNZ8a/33cv3mEWaQwoAsaTVHIKJ3KX13APlFvkGeTyg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(36756003)(83380400001)(6506007)(66556008)(186003)(16526019)(6666004)(52116002)(8676002)(66946007)(8936002)(4326008)(26005)(66476007)(478600001)(38100700002)(5660300002)(1076003)(4744005)(956004)(86362001)(6486002)(2616005)(316002)(107886003)(38350700002)(2906002)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?B1g5s+jFp86WlQHEKTuixTuteZ39bevX6AUY+y7q5TM5VKN4MEnpBS6PAnP3?=
 =?us-ascii?Q?33RKxMVinWrsmuCzIR5MXe8Qs/nIaVWWBrM/geoSxve/fxesqcHiHvyxbwk0?=
 =?us-ascii?Q?fz9B5zZYw5N+99VpT3U6KnDjAEbiXozHw7Z8bunL0aB7JyordpF6NOJLBwLQ?=
 =?us-ascii?Q?KOj5L7XpzltEkkFXqOFYuYEG11hsFTWNltAfOXVJcGOUZZXFOY9qPbJ1Qnod?=
 =?us-ascii?Q?LzH261yeH8HE/1cv5uok8TzksLL0eUusS+1DXPLlMxs6xl5nssoV5S8sKgiF?=
 =?us-ascii?Q?+zG3oJ89ytvqyQTcWOPB+4NsVThHIifSrjhfJkvqUu16/DyT7aZLsWtYZCgX?=
 =?us-ascii?Q?ShthvXToKVPg8Bgwc1Dd0v9vjvlQZKJhjoK7QXwEs6hr8VVfs2cc2Ts/Mbon?=
 =?us-ascii?Q?XzMLO8A+KGO5DgopeWOS5IeHWmhQ2HuibNhDY9rL/o57P9VomR1HZkUt2V4n?=
 =?us-ascii?Q?UTKZHqexTgHTpZrhuioEnhOqvdyBpWUgdulNV8ANpmfZMVd92LKNLl+2d7ij?=
 =?us-ascii?Q?PJRWqzkkB0UqbFo52GD/UbIdhPdMIIRxykIW2lyLvECml9KzMSTXoeKrPD9A?=
 =?us-ascii?Q?7+H7IH5lubwQmTxu1gGVbpOHT/Y37KzD12iSl/+m7QMD0OoAnZAUC6LYCM7C?=
 =?us-ascii?Q?5zi6fUPOlAPeHkGvchyKkTFTX1Ut048FRsuFLWU03oK0nfcxAhHueJcob9Wl?=
 =?us-ascii?Q?EcQC+Qies7ObU4Y1z2fqvQYJDIb5sP4B2U2LaDPFuYvscBll6TZRHhMLgHT7?=
 =?us-ascii?Q?0KgWhuN40TaebqZgWsKOdIoz+dkDYE3DDwsN4zin9bV1pkDN+cYtfP6E6k0f?=
 =?us-ascii?Q?Oa8JivQ+pi3QzbWEyt0Y3gsMdsyryCdbF61zQn0VaKN1yTWieonFn4F3P7R8?=
 =?us-ascii?Q?lTqiJKFMTHMT33Aa9jQsRl9+3Kl8qzA7vCyNKomuMEHpbmE8jpkobV0Irp3w?=
 =?us-ascii?Q?HFgBKgNp9won0lQzKlvKEhtqEopi3QYFjQhulhTVNCvtpSjrN+h5GKSdCTuQ?=
 =?us-ascii?Q?A84ziqkG0HThSbe47otCTJBsi//mLJqfy973HabzDLzNRCx2FLtXI8Gq1Z+l?=
 =?us-ascii?Q?PfP4hHQpfyBy75Uvmjt84skFltwAVEMGkBZeN/E7h/GnptJSUkTPHXYOsyxA?=
 =?us-ascii?Q?uX515LZp89r4rYEaRYcfNgSLVBcvogon3EQFgFdGjuWCdLpV3WRxIcHYCQOv?=
 =?us-ascii?Q?9gnvyzdt5N9hqQjwHJatLhBozIhHs6aXu4VGGeOMXdCFWirgYkGk7Md738cS?=
 =?us-ascii?Q?kbh+LxGwerPC8XDdp9ysxn0vUXwnI5od3a2V2jun7XzSSwpJr+oQ6o3Istoh?=
 =?us-ascii?Q?DDF46YSCglhiIbrjIYq+1TpG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d40a1beb-4a2f-47af-e987-08d91fa98de6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:54.2539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: arWAgU08B9P4YucK4MhqXcuGbrN8PUzXbMtDC8s0cvzT294DEtMH7kIqe1QamG1MtVWlmAfHSGTp+trQdtxmybTUX7K9kAqEqEQ4wSWotr8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3891
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-ORIG-GUID: KG8AXo3hSB-cVde1RXANSjOpnDPSSWhz
X-Proofpoint-GUID: KG8AXo3hSB-cVde1RXANSjOpnDPSSWhz
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We run from a workqueue with no locks held so use GFP_NOIO.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 6812dc023def..e82c68f660f8 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1398,7 +1398,7 @@ static void qedi_abort_work(struct work_struct *work)
 		goto clear_cleanup;
 	}
 
-	list_work = kzalloc(sizeof(*list_work), GFP_ATOMIC);
+	list_work = kzalloc(sizeof(*list_work), GFP_NOIO);
 	if (!list_work) {
 		QEDI_ERR(&qedi->dbg_ctx, "Memory allocation failed\n");
 		goto clear_cleanup;
-- 
2.25.1

