Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98EE5C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 662F061004
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348740AbhDMXHb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 19:07:31 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47166 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347896AbhDMXH1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 19:07:27 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMjeSp168910;
        Tue, 13 Apr 2021 23:07:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=5Jtu+FbIYasPRbIky/mRTjBkwO8yZmSp8avNWEv58y8=;
 b=kyiShbTZVIrJKFGlmYReRKxaHB/vgimdlHmTitg5piu2tR1ZtjnIsVeS0acdMgSCbK/R
 4PlXEiMjRVR1q/vDVIthngxrOf8XJQCf33RhLvd031CwziyDzloplfMRDnQuPifF/YNk
 ILW56HQk69p86GWIFFCnNap8V/+AceudLjEAmn3bgdJlZVaEsro/posTBrHnMeHGyG1s
 lycywsKv12wP91/9rzyD9DnssKr25JZouQCSlTcg2zVV0N9RxRgRdMfHEh/02MoHbuu0
 LwJibEHQN/Ybby37ed5gLSmN7HGex9n3V7ogtdQi8aaGNzi0xmMBot2MKK9QICvQw34c 1Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37u1hbgsw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMjTQv105371;
        Tue, 13 Apr 2021 23:07:00 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3020.oracle.com with ESMTP id 37unst1tvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/SPLcEUQ5v7C9M+YzVyYcwiQ8oZISZ9b0dLC1jCykn1XFs6Ur9h7lwpAsGcNUtKIydVOySazndxWbaVdRb06b/S43T5NqFk38xC7qU/0QJuy+SH3AQVmGEdUnC9vto8WYELhLLv+jWYLj1P4CW0n57qHY/bhldkEtz6UMgxu1QLgKi0fcPE48zZGrSLTkoYiuPMCLworL/yihjRtK8S7HHe4ltagM03xG5pCEncM/23HCiOorFk2DbOkNbzzC4LqJ2mmomuvuwg0iQ6IHcBytD8I8mlylX5WAAXTi8lBN0lQwFhIwx4kh2MlbkOTJUI9szp2ckTHDccr1r5kQQSMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Jtu+FbIYasPRbIky/mRTjBkwO8yZmSp8avNWEv58y8=;
 b=P21Y3t6xhscznZzPLhswOpBvNA3LQBsjw+ZwN458y+v7ozh6Ha84w+080wxj1LpjBE5QHv9OanSPU7cDD+wbe1YV66+B6uWtXuZjxbTupUCUHQWvzVO2QBlM1qYQru+pSP/OqvmJ1FS4eM0eETVH/e3mUTipoaYF2hLL9NOyeSIWaB3+0ZWaGtLo1WHRv3fa+qiVNQwG7LYBKzhDu3W41G0qOhYNER3rikDcfUzeVtONqVRyvQK5L9Bala0h19T9hQe4ehqfwb9kmbaRYrVgrIeJpl7355r1s0wWtQryYRHTa2MzU25whlHmGlTRYN6aTIvlmvKbJZ1KlGIQmBx4Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Jtu+FbIYasPRbIky/mRTjBkwO8yZmSp8avNWEv58y8=;
 b=l2xP4+6lnk3xiP0FFkgX3hwLSv9brUEU85lXvklb/3ZlpGocj2/4HPNY09xNe8GlRDx8fFMRIWoPYxdY+ojx07WEJjqREgFvv8cpKNq/3DbPsUbBbtWlqT4yR1AEByKfiH9ikBFd83gmIcbPhMYUhU3mDeiJwLFnxL8pi7GdhiM=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2469.namprd10.prod.outlook.com (2603:10b6:a02:b0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 23:06:58 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 23:06:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 01/13] scsi: iscsi: add task completion helper
Date:   Tue, 13 Apr 2021 18:06:36 -0500
Message-Id: <20210413230648.5593-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413230648.5593-1-michael.christie@oracle.com>
References: <20210413230648.5593-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0212.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::7) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0212.namprd03.prod.outlook.com (2603:10b6:5:3ba::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 23:06:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84c3bbf0-088b-4846-ce6a-08d8fed0d6b3
X-MS-TrafficTypeDiagnostic: BYAPR10MB2469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2469C51F139B8BE3F45DB35FF14F9@BYAPR10MB2469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EdL4KtBxqRsxjgW77FwFWm5uyNyVhjE/9pHwNBHxS3y24CDXlmZUW3fxYMbn48OnvhnIraI0Gx0pOxq4VSHoFmAv14fKfdOxTfaRq6Yp2gqTIXMgieYJh0dQ0Ino/mEA/crUaDTab3aIe6iWEcoLzAz5r3LW805W+IrqjrJ2D1O0izhgH4/jwnPDG71HcrDzpfA/caMl40j+Q2UR0TnyYEHjnhZ9GUK48FX89ETIh63TAnh9cFN6I37i7tdCif5fGiJSd7qlxZNoVb6Lbdiqu41OK17LduleQeNB0ZbNJlGd4rIM3jRwVCtopao030Equ3yXMRHCfaC/eLnkLx6oOvkXiY/qZAsiFxs9YvUS3FvkYEQ8pabB2W7rftmMzrHMqmA6uYbKKEV70770hH8Rww51EbIsGRcfuCA1zjxKuh7qUaExjZvLlUqzM/Xx1z8neIlF/R/k12X+LFl9T8dd8WejGX2TEajZ1EBIx/lCP4imNNp22i0qDbYh1Apo3L2HMv0YYrE5aAQG9TuETqoba6td8U7oi/9LFphZKtpa+nN5U+MwYX1ZOYZYLuJRzggVwppvLcaHJ7esqKLE1aX/95dIxtuXoNOgBy5QOJphV9CNKwlaRgDNIuePwW/ji+bnrDxQsVy1MSOfkw4mpyXuj4RizcmXv7omLfXas7oV6rVzxeo89/n4FX2NUGvANg/T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39860400002)(346002)(376002)(52116002)(6512007)(478600001)(16526019)(186003)(2616005)(8676002)(66476007)(956004)(69590400012)(4326008)(6506007)(66556008)(86362001)(8936002)(6486002)(83380400001)(107886003)(316002)(36756003)(38100700002)(6666004)(2906002)(66946007)(5660300002)(26005)(4744005)(38350700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?U74+XwdQCIK8HZMCDda9DjFqq5tIy8Ium43MGKxqX4kJDsMQXHFq6+dA7Yt3?=
 =?us-ascii?Q?Kqf8SG7UBh0pwTFo58E97MpeBUrW7hsu3xhsrwcSkBO24w/NrbgNNFiQAoKy?=
 =?us-ascii?Q?gPPnz4BrvMvtaR3/v64JD/Gu2apG21rFerddJQ12Xc3WTesxfKJQY2wBxhvY?=
 =?us-ascii?Q?ebmYHWvD3cdR50wTpWbqwaX6x4Mb1sAA2y9L2Va9tyLRKBeoqloCsVEk9CPx?=
 =?us-ascii?Q?kOnpZ7H96zAkLIIs/xqR2oPINxI+xu+N/Mwx+Gsm2ALy7PSLtezxqNsgo01Y?=
 =?us-ascii?Q?kHoSRCLALigp+HcXjwUAnWUiryTFPaUYKV2RfxgKupR/VPH89i1t1xeMn/oI?=
 =?us-ascii?Q?PypZgestDACngW4Evf/BiQGXjUYKFMsCpsCUNJpV0DJ/XqLIUKB9faB+w9A7?=
 =?us-ascii?Q?7riv9LJ7qonalVHp46gPYuMksmL9MJjDle5mRF9BSqTy1inkEB9IdeWa9ors?=
 =?us-ascii?Q?X639r0bGnokcsDkXFgXASbo0Cm+QmdOw7Ec/u6YJZq8V4xgmqEahTkfYQizK?=
 =?us-ascii?Q?eiXk7HwVk8RT3hlNwYdVuD40WT2EV0iOViss6rj9ZWKkvY3+yV9UDAOoRH4X?=
 =?us-ascii?Q?6ffSL2Yv70FY68Wlbk9PzDb8XfDjiUUQn2lRN74++6tUIm1vfhAoAH7n0bmB?=
 =?us-ascii?Q?RMImlJAluUyqktenExx0Y5EqkZqCQB5FdI0x093oVjazB4g0SK+QGJEZnjCl?=
 =?us-ascii?Q?2LxMjAdsQ8uS+9I0b5cJciswYZGllzwIUGqZhXplJAa4Vdwof/LdOUP7Cg+F?=
 =?us-ascii?Q?aM9pwG6F+qIOAPJWvYIv+ggHFFa5c4tTdnhfnAXwud22FJxDBtacThaTZMSC?=
 =?us-ascii?Q?v3TJ5oUGqi9HmZwMgDWafJ3iiqfNyqNi2RC3os2H4IdPJEdskSdsHcnt/AKS?=
 =?us-ascii?Q?tPgMMxybhItAuZeMVsjntXKCcRra2MBZ5svdtItN7wCPCZmhR039ioj8QmCm?=
 =?us-ascii?Q?IjINcceOqhGJGYWNgATc5GrAWqvbrtpnH/O1O9bBmidwczo6fJUMLqt06tOj?=
 =?us-ascii?Q?0sWHlMlRZ/zsN3oWP/w/97ed5e3cWDyU3zsrX05o+mxZkWeAH/5yvCIHzWmS?=
 =?us-ascii?Q?r1hKloKRNHEnwKJIfqUroexE4onPP5RKpylnFKqmaokNmEyby5bBGjtgzECm?=
 =?us-ascii?Q?ATFiLounDsnku2mr5lLyy2P9wRlvzhWHOG9M95JgnFE7mzQLrIj+M5ehhUlG?=
 =?us-ascii?Q?xfKkIf2K9xZhvWmytnDV0ZHp5lgKsPi2+2t7niORFFybqEjwcxfQNeU98nqG?=
 =?us-ascii?Q?mtuBuNvpvqVAKEf0hymqSudc4IQyqJorC8ADUClnnzRHEaATXHxuBy03gIU2?=
 =?us-ascii?Q?u+WkCbG6vXHUrVT8HOfGr8nb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84c3bbf0-088b-4846-ce6a-08d8fed0d6b3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 23:06:58.4764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aC/dGDsHxklkkSFhCoJcVdbEKerqA8YwXCYQh0YfX9iL4n0RMXCDXOlPpl4ETJF+3W0bf7z6ytDRw3vDCp0YolpmeQ2YB7yWQh/9tUB3/Ho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130148
X-Proofpoint-GUID: P6q3tiupuIVVebIMNA1YUiCjrM-f7E8G
X-Proofpoint-ORIG-GUID: P6q3tiupuIVVebIMNA1YUiCjrM-f7E8G
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds a helper to detect if a cmd has completed but not yet
freed.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/scsi/libiscsi.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 02f966e9358f..8c6d358a8abc 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -145,6 +145,13 @@ static inline void* iscsi_next_hdr(struct iscsi_task *task)
 	return (void*)task->hdr + task->hdr_len;
 }
 
+static inline bool iscsi_task_is_completed(struct iscsi_task *task)
+{
+	return task->state == ISCSI_TASK_COMPLETED ||
+	       task->state == ISCSI_TASK_ABRT_TMF ||
+	       task->state == ISCSI_TASK_ABRT_SESS_RECOV;
+}
+
 /* Connection's states */
 enum {
 	ISCSI_CONN_INITIAL_STAGE,
-- 
2.25.1

