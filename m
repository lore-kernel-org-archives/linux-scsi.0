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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FDD7C47080
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7712A610A6
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbhEWR7w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35866 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbhEWR7r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHvGs1121347;
        Sun, 23 May 2021 17:58:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=0hXH9G4tqcyHGzsvPJ2wfsuvn78NDrL2rLSHOdyBjFY=;
 b=BCQSR6Yf7VDDFiXhBzbaiItGYpgAWnbifXH2XwIKX6Vl6YYL1hvswYfnJgLC3z82HNfk
 Du6QOEvpR9XaNhGTf2qZ7WUFVnIeDiUWU4vWIIEMova2Aaf9JLBSLEEbg2JFABwg4soQ
 QtLza5ou86vfyX8yKJwEyZGeDU1tqkQWXE+pIZ/GXik/G+aaPSJRkXbP6f1tQB1Sytlj
 XqiBIjv/LEjBQS9Edtr7IMUEWvEsLn91bkG8P9Ye6Y/Meti6i/wrHy/fvKN/57iOPiYI
 mRFKOVTM6gtCH2Odcixtl11ff4+LJk5DC3665CYFid59XdR6A6XSiZCNRHDGtvlYoGQZ kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38ptkp1es1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHucu0161854;
        Sun, 23 May 2021 17:58:11 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by aserp3020.oracle.com with ESMTP id 38pss3qbn6-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGBqtn6oN5DhfU8ELcIzyfuS6bBHWwlBSLHz5APSdgk8PS+HkrR+Ao+CjznO51gPmUQ1w9lL5ynw9GKAU9rdKvvqTwf5xZLMiCFaiQXw5Yj3DAJmEd3utPjD9mIiNLpSaox+htvuE1HYjJRK8Ma/sU55V8P8JQrlg0ob19LrJ5bjwDtcAjA3IPW5NDJeVoxuGrWNPFJiesltxjKkwqKcxNuHrwFKPZu6BzwonHc6nfg3fj2C5cPOCyUZoluzkVjp9Zez7B6L2pBmvq1SO/HqpTyr6sGh/uHpAMjgs9uX7zmmfCHDlk46dBuW2SlbJezNifoBKywJ4S+hI2x2qayLMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hXH9G4tqcyHGzsvPJ2wfsuvn78NDrL2rLSHOdyBjFY=;
 b=lgcjq/k9yETAnYfopjIeu77nFMQ6UNjFT6fPddt5G2EaUPuB4VGF6YDQAAGBWcENE8qzmR9CO6rJHy9dVmcbJfhYAt705PE+1KgyoJeewAGPA1pvYlF/GOeq7t7qeFcJhjkJ8W/UkyfUh4PUci7uqweFuFvefmcbD89gIXE0LPZbpn9HUge7j/+ycxpUzw2Z++gWOqod2zbayNI6YSyGqpWt4wBtK831Q3kCH3rgi81f/wSDssEJ4kmtD1//N4XRsge66IlyhV66qa30MgK0mHwq3+fO4AxINlVZjdcy9PyfH2iDNZtQv7N9nvqbRqoGmwCuVFh1a4zofMSPuy1mrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hXH9G4tqcyHGzsvPJ2wfsuvn78NDrL2rLSHOdyBjFY=;
 b=PtStPNhuho4yjklgld3tC0PIwCfqk/3mgmvlMdbksEbSl65xwh6/mpJuj7uBgR3LZZg7qu6XpsKGSkcWrMa5jcz9J7JZZ8FkC4hmT5J2xenBMZ0Urnx84o10eSaV43JNlpEOf8XBmpeS5wnFJW3Pq9iPfLr3HQ/+iT6sZiaWRjQ=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 17:58:09 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:58:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 19/28] scsi: qedi: Fix null ref during abort handling
Date:   Sun, 23 May 2021 12:57:30 -0500
Message-Id: <20210523175739.360324-20-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:58:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20c877aa-5696-43c0-a36f-08d91e145353
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4004E83F27EB2BDB3BF41E1FF1279@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FKAQ6BmhfqTUlvQvS6ueVnGqTnc/bWwryzeFBKohypfPRii0fL/KaeluWz8VfSm/Ldxnd55mDp6omL8oEVQLFNuCc4a/FhloCO4nndqeN6b6j/FZVZHGwrfVvcBfb7jex+8+jTu7Zjgwk2+qAJIokpZdj3ZnEjT3SJ5ybc1FMzuDRkQXPihoCZJ9kJn/8ZTgHBbamOtYT6q6pUx1i8b1VQWqLR1uqCoyMVD4ItClt9J3PN7ioiiOb/2OP8rgCku6jyTqIlTzDb8/xez0Zl0i/lD5w+zX4ehTb+eUhi8gbkTRuqfjPIuJ2YTv6QUfhfOQCkrRUZOtFMy6mOWwkgfREDvWB+pG2axO70HhT4i6cHtxupqYN7ViJtpL7vf1QhCZQ1gIGDUqt2umruiUm19UWNwm1+gjEkVj6Hutba3osyb3VNzDOiR2VHCugPuT8xOcHE8edMiyIwnpe5Ws/hB7iAcIE0qdu+LDXaK6gwdjMe32g9GP4zLrJltJ4CAmZ9ZMK6185DzQCQE7ECjWxSG9mcOcV1NFZbnctfHlTPFMjwYQl8kBcS6l2sFJ5IZpRzWhprtAXhaGnoZ57EP4eTutsGFjr3eoARrjofc16n++0NfbkaDGZTnGke4ZequqxuUHh+UGj1aMFUbkVJdYyd+9/fzNyUSEME7C9vqh7eywUxYxjIy0+1mOfBRRhrqr6bk+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(66476007)(66556008)(4744005)(956004)(2616005)(66946007)(16526019)(478600001)(36756003)(2906002)(83380400001)(86362001)(5660300002)(186003)(6486002)(26005)(4326008)(1076003)(8676002)(6512007)(6666004)(8936002)(38100700002)(38350700002)(6506007)(107886003)(316002)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jEQeIy8RKSzPbutTj9ArKpWD5h0G7MfCmptsOKYCKGdoKxuSUmPePAzXyp0e?=
 =?us-ascii?Q?0ges2hgtSEC3hUcp9wmQYxl3PVfpZv7MgEPsHfu/0dH/BzYBgt/vkE8vrS0t?=
 =?us-ascii?Q?1Icwp6mQoycVmtnHmiNVeapWpDjIb70c1+50WH8YiiRlHggQZq6tg0YzYVqx?=
 =?us-ascii?Q?C2RzCiXe/CpOfjjAe1YLfm5gaZO/z7RdsgURnDUuTREsGzP3zz9YAkZQzXeD?=
 =?us-ascii?Q?lv/Ah6Ysi7RLuCHcjsk6so9BiY7c8rJoGO+comqy1jOKLjL+9u6nn8ohyGV3?=
 =?us-ascii?Q?UjLl2/DpXnNbuRAtsBWbgxqATMFuSv9OnU7aEYe7V0IPB1P6SDph7r/SxSRf?=
 =?us-ascii?Q?VxzBxmtQRQiMbAUACpGwqH7KgsRVX//9VzpCk7VZEMPH/QpFjTzNaNALevky?=
 =?us-ascii?Q?ZMSWOU0lrdPJGIusP/16BPgtwUB38ZeGO1x76KpaKKabBeE5d3bm4X6L7kmx?=
 =?us-ascii?Q?DJyyUAVnwN8A4x2vtAd8W5j3L12anFHgkdn449e+h8/AQbONVqT/B44DKqiW?=
 =?us-ascii?Q?EfMIqlnt7ubCrrUzeaDRrJbEg7qGIAK89tCNK7qxrzgDUtWuQyvgV7iBLZlL?=
 =?us-ascii?Q?qm9aHH0Wlrg/vE+4x4kC9unI6LvBcPaC0OCz8bNjzwirS9vIkZlbenflCeoN?=
 =?us-ascii?Q?+mlUOA94qhnmDud4cUVUVAI2kPhLHOBaIyDV3kDqZa9Mi5L6mNxHmYs2KDqp?=
 =?us-ascii?Q?3I9NjNB/XoMDcy7746gM0dUcU2Adtspedi+Fqi99gDwLq9Ts65+1kJLf1SjT?=
 =?us-ascii?Q?R3W4lS8t8VCmsuXe9PuFVyi9Y0c/lvSloYCgacS1OptUiarY60psikqBb5W0?=
 =?us-ascii?Q?AqlRnbEA0k5+EVRaf0Nd4FHMroS/1lhUY9yYrmhhr/razTF1XD7CuOd2vKy/?=
 =?us-ascii?Q?/QmYWERRndoLaTOuyizxdoykgq54V4fAj+f3IR8FWIMkreksyWMfVwiCtwLR?=
 =?us-ascii?Q?SRSdoPJCvIp088teBbHe7yMKh5U9PY01mY7gTGsXSzhugaoxPoyphWq/jFLq?=
 =?us-ascii?Q?axdRvtGdOO+56ivEClK2V9OfQLiXouBi5YRq6OpkSqAer1KYkHgkSnK+scbz?=
 =?us-ascii?Q?cSJeyQT4BBiQfqGAzuT2UIaL1KCRkV8yeVECZdwjx9pOLb4aAc+uC3MBvD+F?=
 =?us-ascii?Q?Cs0nwWzdwXLT7pHUXk5BkyiVb2k0e3viLQSmBrLPMD1KR26z21Rce4p/ZtMa?=
 =?us-ascii?Q?uqTFlVzPXhL5Wlu/s/GjAHp/do5NYAdNhI7MrQaLzf73VkAYsbv1xXTAqBRH?=
 =?us-ascii?Q?1ZJjSpbbhevHxWc10/lK4sDM7sLmy0Czz800grlOY1mY0APxq/000bC5QgXo?=
 =?us-ascii?Q?zSPBpsK7mjJL3NP16BaeSw/I?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20c877aa-5696-43c0-a36f-08d91e145353
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:58:09.7844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h7uKxn1MejCp+JGxrVSUmamFdUi1FVqHtz0fpGYdfPxU8M4v4bZ5h5X+XfnKajU0oc/WJtWwNlt0QgsyXePIZs8rXoQD2e+p2tTGZZMwsZ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
X-Proofpoint-GUID: U8iu52o7-9waGlEkk6ck-Pji4x95Yv5A
X-Proofpoint-ORIG-GUID: U8iu52o7-9waGlEkk6ck-Pji4x95Yv5A
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If qedi_process_cmd_cleanup_resp finds the cmd it frees the work and sets
list_tmf_work to NULL, so qedi_tmf_work should check if list_tmf_work is
non-NULL when it wants to force cleanup.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
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

