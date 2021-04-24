Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54529C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D6FE61362
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhDXWHM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:07:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57292 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232384AbhDXWHJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:07:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6NDE151677;
        Sat, 24 Apr 2021 22:06:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=0hXH9G4tqcyHGzsvPJ2wfsuvn78NDrL2rLSHOdyBjFY=;
 b=Y+H7ke43nvm+EZweji6xkmizI0Egx/V/HmuRgalY8wSDeMeGozZjz5Ta+MWGqiwSldTF
 u89v/prUQdlHMKkxPT8PoKVU+3T7vu9YDTnS8L8j2a5h62PZZavLh1Wig2tW5RUIvm4p
 M4BEM0yCNaoceBbDh4WmU389s1EbB4p2ipAnYYe5qxO9D3mBlLfh7pHnio8K3dKewfn9
 FGZpc0nF/8+O3VsVjxC7DqPLgkIZiL6QVN0iryoLiG9rU5Esc7kZJ0hUJjQVSh9ivjWV
 gQuC4gtVTmpdPc56Uimtl6d8vX3v/rnrHhAF7M+4NNNKuuhDqXi2m51wQHYC8RBYYzu9 iw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 384ars0t11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM66YV182267;
        Sat, 24 Apr 2021 22:06:22 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by aserp3030.oracle.com with ESMTP id 3849cakfth-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5aBk3iKwuru3bHjxJ01gLBsM6IyQ1XuDUUB4dbjcUttFxuEvs8ZRUOpI0Es3zcgl5cUgSr0O6VdcjB44aCg8J61+UZJnvP8K7gZRbuX7R6olc/x/YNZnW28QGn1fxNmENTdEmAqeZJ1/07U4GapiXQ7ggAf1PZGFvOskaXxpxOxo4TIiILOJH+ekhTt9qUPBzvQrs3AKnSbOhpcsXuQJfMNFdLOuxq+lvrbs1EIIxHqk6gqcqHLZaAvGwBJgWh6pMuhQNBbDYAM/6YzLcadiZ9gBDKLcSk8HknJSt/JvoGSL6a49vzP5x8cm1DkqgVsBgWKweMROBkQBpyPct/Hyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hXH9G4tqcyHGzsvPJ2wfsuvn78NDrL2rLSHOdyBjFY=;
 b=CQKjJ3Xm5Eb2yNDw5Helkp0Lx5mSLPicemdotCrGvl2Gj2PGk4r3LgM2YGUg5NF0ACdmAudmGbKjHGEEaU9AqtNne4oBaDd59NKoojazFTDPEdDxBjH1005ib8xXXtI+8YgLAJpuLsV/lAFEU7Mv8givqTAhOglNvBmjTy843YnzP5+kDjPk2xmiWZzVhKrGnnby0qeIsvgd9u84afQDAJX6VaLKEqSc3w22DL7DnTKKdt5K0H9Yi3AscSBYqn4T84HBG7H/SvxtIYYkSkD4s386rNZgzfebBcUxLx9kOyp9t4oa56WpTM2DTYypNXP5oBoa2y7THh/B5seNwKMJpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hXH9G4tqcyHGzsvPJ2wfsuvn78NDrL2rLSHOdyBjFY=;
 b=zgO6cDJqauUKIOBd/k17WxO7WfS2S7QqIgr1NJp+EkD/TRrGzWcuzkKP2CLXd9ZxEoSH/dlnW072nK1re0IIumDkuLuEsGVJ5pNIOXJRbGwmNuNzBW/TVogsF6RgjDA3TUo9zpPQGr/M5Beai9QzAoUzX/OD/e8oiCX/t0otRMU=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3317.namprd10.prod.outlook.com (2603:10b6:a03:158::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:06:21 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:06:21 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 08/17] scsi: qedi: fix null ref during abort handling
Date:   Sat, 24 Apr 2021 17:05:54 -0500
Message-Id: <20210424220603.123703-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424220603.123703-1-michael.christie@oracle.com>
References: <20210424220603.123703-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:4:15::30) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR16CA0044.namprd16.prod.outlook.com (2603:10b6:4:15::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 22:06:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9f63aa7-79e7-4d18-ce13-08d9076d3171
X-MS-TrafficTypeDiagnostic: BYAPR10MB3317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3317FFC31A23C6480DB0CEB2F1449@BYAPR10MB3317.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mr4nec3sevGUxf5oMdF/sUBCj2e31DpOXmLounQ98W3kpwFpIXx4XOggTCOJ1mhs5L4BKZl9ju7S1lBheQbhuuXOf/meyNp1EjORoc9nP5LjSEvMG/MDI/F0iB+V7hg7HqIhFGHWXS7nFrlVEaimXRLYQYLsOQIh4gFZmiuqewkSRzQxxyTkG7CUWwO1MbuI89rL43yCZYn3EGYDbBXPixgg/PrO5amS3xB3teiA6A9HxoCdmsm/VYJFfzVMRdDaVp1VMMpLSRdTyiCmQolNujbMcz5p/OpYtqNVEmcdYRywGMAzfxzAM1X9oYj7Mn6VPvPipZ3TtQSDSXr740VqzHTRU6TAsmvJTnI/1zTPH5Dtm5DTOOKhcdHD7dSvAcNMLufcpmEorQ3viYUbHPphQLJIdjQXXDm60P0wqIreqZO3++skjPJRhynDlcSD7uZ/hd4GytuWcvIhSQFFTVkUv5+DkwEZW4Ya19gFsf0N7oHOsug9g/DRQ9yL8Z0mhvsMFqGYQlDkavFb6Z7/dUhwxK6MNdiZCEYV6TJrJlOac9NzHYWACB2Y7ETWO1vVU3YQMVxZ5aU3cHRjcTNVPHn++sGIavpfslKBp5hW++ZgFVXQn9/ehmjskxcnc1hRXRIzEnZLXmFtqhX8T4BnqGF6mOEVudHo7acpG0SdliYVcfm6RwM3o5lz/IECg0kzS7NQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(376002)(39860400002)(4326008)(6666004)(1076003)(36756003)(86362001)(52116002)(478600001)(83380400001)(38350700002)(38100700002)(8936002)(5660300002)(26005)(16526019)(316002)(6512007)(8676002)(956004)(4744005)(186003)(2616005)(66476007)(2906002)(66946007)(66556008)(6486002)(107886003)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1tOMfRL0HJ4ZpVLM1ziiYC8zQv6Izv6CqexgT5Wc52ZYWppBHaz82Q89Voug?=
 =?us-ascii?Q?yBv1RCsWE6U2CHFKMtDC8a/a2ksyDgTpXqInvEzJdI6UYrOW3YwNTiFDYShZ?=
 =?us-ascii?Q?U7elgG0ceXvfd/64GWnt0xGANAiXYpbrc7Q3ox/u1vPacPpN2t8MUwcp7wYV?=
 =?us-ascii?Q?E236+MqHkOiucljL7pwGY/qVZL7qp58/3MRZNwwZTSDAMARPhyqsfBJXtoWi?=
 =?us-ascii?Q?kbL57Gi1qnKONJM8ROyweRRLPumVmF8ep75DJ9slZt6M/W1Oc9IRwb5cNut2?=
 =?us-ascii?Q?mzyNDFJ9/ooynR+X9rvNtG7owZQ6jssQuw1k5I8tWG5jmI1QmeWKQeH9f9IG?=
 =?us-ascii?Q?VnC+b3/tQxyzV03AFW19TcyEJ8NLn3x//gssFS4EuODOMOj7loVRY0qS1DTU?=
 =?us-ascii?Q?mw1o5fgllcQ2SkPEmHm0VZn5n/dDgnN3AI/3IfxNOZzMmiU7BzrdoZba5Vbs?=
 =?us-ascii?Q?uhdkaezUhbaf1NVYu1xEEfY+ocP2ua4ueSjzJASUc7puVUpOEMnozDDGWZlE?=
 =?us-ascii?Q?x//6Qv+7vyRJ797n6HczNiimesyaFUJAzfH/NhppI9hM6gnheNRcvd/u1Fvm?=
 =?us-ascii?Q?90k+THRn3jFOSVwMaJeoYLqa8KEniZnVewePzF0l/GDF51HJAVHuMEZdJcqc?=
 =?us-ascii?Q?7zsoAocYG5EMIP5Y0XTihZcszG2IXfTalO+1iAsKT86ld0GGHa68EBRZhpVd?=
 =?us-ascii?Q?f1eL5POcGHIASUdxR7hTARnbQladsgcTkdwatKqOCNz1hI0lRJY62DW84xHK?=
 =?us-ascii?Q?u6zSsa6sQe6xTVwKjakoymhSive8ke1vBPriunJ3u5qDQEbNAmtveUgUnOc/?=
 =?us-ascii?Q?C2rg/PX4tt30KaeS0FYOrEoEWJyv6OSWpYDFwfF9Gnmjhf9llExPozVbE8Fe?=
 =?us-ascii?Q?Eur+u7mnkVCE3zBJO0jqrBec08iKjFkbwev8UXi2N3KL5qYh72NniVGD9cGx?=
 =?us-ascii?Q?9VMGL00Wb6Xk5XssTNtkgANjgNKWqDazZ2FjKrjL5g/Pq4tWvP399OqB/5+y?=
 =?us-ascii?Q?yQ2kp4zdc9InbYHrAskjo2iCIqWlvPTUxF3qvMc57t+hF6xpCUDkrYZEmnlC?=
 =?us-ascii?Q?1Hqq7S6ehdLgTe86taDnBLYd/xetZg5zfJ88RKnjpuI1rDXU1x7/vtWKjSi1?=
 =?us-ascii?Q?Keqi9+jWg3tdeFW9DcfzhawCdU08VuYWIXQMb0Bbez7aGHpm/y4ITsqmMT04?=
 =?us-ascii?Q?dgwzKxoYYxEC7jZoKy9RRPY9K7VYhCNcakZ3LDi5yYP0YPuyIPvFgdz67jgD?=
 =?us-ascii?Q?+k4r1LZ/NRPn4DN4zmgH2vltYsPexQd3KgvUEmCAlLbZpuA+Avxn9thr3C0B?=
 =?us-ascii?Q?8GMhpmiUaRld7Ax3T33T2++O?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9f63aa7-79e7-4d18-ce13-08d9076d3171
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:06:21.4426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nj+L7gzWHNA5aXZqPixHgKVfXzC6L179TPm/0P7QoA6wOdC1G2A/GTjhurlYT4cLXAG044jRQVMiRYr8y8ycQfBlUqlJJTB+1De2DVLBFZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3317
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
X-Proofpoint-ORIG-GUID: 9Pz7viH-VMfpByqUXP6jj1D6RR73e-h8
X-Proofpoint-GUID: 9Pz7viH-VMfpByqUXP6jj1D6RR73e-h8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
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

