Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C581DC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BD5C6115B
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238039AbhDPCFc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:05:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48278 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237997AbhDPCF2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:05:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G24mWR098868;
        Fri, 16 Apr 2021 02:04:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ET3Y+rkHr5jOITkQlSZIiaYf3eoI25gY8sotZz6U/R8=;
 b=ytvGPurvJnAgzJ1RpqHUaQKVzbi4qesRQ2h5bCtyRvQTzXGsdFTzLlOOfxWJkoem0zkw
 tb5AswYn8k3IV/uoeVlBZVPbVrqLowxtzMqKbJkEQrmr5NLI2Bz7r1wRS+Rx7dDFJh7Y
 ABBiYKF1MVbjRElMsv823jOa7kwmb0Qfa+g92X0Qwje7M4AVEPfdbLiBmZ5J6qSFParV
 gf09rzWtcy/VXpHC1xIyQyNIZmGPrHTmwAwqeaClsZMqYaC8nQkt3YHK+gXfWjMQ2Rbb
 nnnOqChjc8JkM1O05lGvRyDRrg6KArJXypjkn0UlDWJKLxCSEhxnjfrt96ugzz/B4Z4y eA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37u3erqpdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:04:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G1xoqx008605;
        Fri, 16 Apr 2021 02:04:56 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by aserp3020.oracle.com with ESMTP id 37unx3snxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:04:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmQHndt/FMH98OD4Kk6hGEcns6ntYVLrmy5f+DSpgc949bg0pAKLgRz/XWwWx3WIwsOd6wFMThbHOab173Nlr87QAA7piTuG+xeilSsbLF3p0tNnT10v9kJ0fZeV39+scHpXF3K77XsjpGkAmGb5VRaRN/0bdWOP9Q0f6EjvicUvTY3cWncVQh1diTOK0i2y/QdQN4O2YHcrFhwvivwjzThggunhZ1W1eLu6+KcCLmi5jO7jZKr515BtsZMZDcZ9EImUb9TmcIhxf7LXBLdFpR6FxgnaC58u0j8RvlRos94IXomAK2igBxHIHgowwNFsMfqiCCoNEgAfgYmM223glQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ET3Y+rkHr5jOITkQlSZIiaYf3eoI25gY8sotZz6U/R8=;
 b=EDoJj0IWRoOpiAYjU5XdyeyQ10zHzyioUDYQ40hcnOhEdqDiJI0W/Xa4d0R7DCrB5Fg2LiErH5YSnp1ldQjhLqzf767dT0e9lrUCCLlw8HFHCsHjbeVBZwl2mKxyWD91HVzePH7gVDqT37UW7Z3JNR7VmbXp6BsvoRtHL2njl7mY/rGW97kMlskzC7M6vltWX8aD54Fam9TVOM9L049VIViq1/XK4l67dJXwrc9VZIiGtK8RmV1PX/+2lHM3RQiQMMomFOekVHfODLJd2ZWrf38XLVrvbZ0lbG+iT/GyeM1+t8LwP58Z7V6zHJHS4JyPHiucxveAJFEICfnd5hJjPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ET3Y+rkHr5jOITkQlSZIiaYf3eoI25gY8sotZz6U/R8=;
 b=I7dr1/ID1e7CbXEoi9XW79RX9mqvDe2uNC370ZdsjIjW4yX7WiBABuxvZEh0tqNill9+tW3uIqRGi9KLX9oYB6tmm0d8mY31NvO0bdlv3YBBtK9nlMDZBYD+KoJa2FtRQfL5rgG5isrPnrRBlJzy2B5JJT51e6FeZRCVgXsUhN4=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2421.namprd10.prod.outlook.com (2603:10b6:a02:b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Fri, 16 Apr
 2021 02:04:54 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 02:04:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 05/17] scsi: iscsi: wait on cmds before freeing conn
Date:   Thu, 15 Apr 2021 21:04:28 -0500
Message-Id: <20210416020440.259271-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416020440.259271-1-michael.christie@oracle.com>
References: <20210416020440.259271-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR02CA0100.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::41) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:04:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a06224c-f2b0-4020-3dea-08d9007c0722
X-MS-TrafficTypeDiagnostic: BYAPR10MB2421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2421E0596F70EDBE4C203156F14C9@BYAPR10MB2421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D82x2tI+qItfrsR1J/lo6zOz6evGEipY0gTUrwLzoWddMbFPv9K+CQmT0r5+pcpZlgeJPafN1ntLjhr0PMrrsetWWqIq3DwA1II1wd+IC75qMqAbfPzQem6f3iOKkr7hD2AX06paTj23iQk6oTC3MUwBa8h0SrUIgpvg7VSrqXz70m6yEeFieE3QmMDG/JUauuLyaK/CnNzninx4H1ki2PDscAzjU/DTP4vPNtjvjAkLkUf1p+oIhZGK7LHZjVkBBwEvyQWCXYs3akxG5Du+B5utc9ABDX+RFJPa6k4pISTL/djTD8lROqZ+lJ9K80IbvEvuEpwDtBY/1LBKzn350cpvcIkDKMOf4hr0TzAUFTmSysTxkpxiAQR7cwjBpX660JlwI74r1qwoOGsdnOGPfkzhh5NqLocO+zwCUvf+wdqvpOXYcsdWGgOfecZ+xRB9xf5E7X8mdfQr+IhDuTSqsrfOM8m8BCwFhe3gjnw7Byn+vXyBbRqleAFlco2ogJ0p2lAMH95FXCy7RwkJdZgEUNTOKdxsYHtn3m+4aXtLhmsrRQ1qfsvPNpaciTdVyje/U8h8GpTn+Ql3Nkbh4pDtLVn3d4DfdMrHWR2LGmz3mJDC+JnfwjIdvkC5TYsDgJdlCPjdL73+HAcxGYwk9zErXOsam68EO/xHI7ECif+xfg8Z+24GZHiuFdZbMiKJ5hXZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(186003)(69590400012)(16526019)(5660300002)(1076003)(6666004)(36756003)(26005)(107886003)(83380400001)(4326008)(52116002)(2906002)(6486002)(2616005)(6512007)(956004)(8936002)(8676002)(316002)(478600001)(66556008)(38350700002)(66476007)(6506007)(38100700002)(86362001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?V8Qm78pYh2DlQ9F4whpirQ+Pj7C2prttIBDhba5P2QgmP9EdfTF1j7HMldwu?=
 =?us-ascii?Q?CeyunBXAwYfk/ekKGGVOWqKtL4/QduJD25g4JIyXnLgKZgewRsVBmptkqjEy?=
 =?us-ascii?Q?R9opXJcF1rso4WrFOO7M0gcnUd0WS3Az/Lg8h2P+5KF7Z062188hLmiimxCe?=
 =?us-ascii?Q?BD4PufCs22vwxpz1ju7uouPDiPEHAQQtXGwyh3LcZhlgExpNRZ1syqZa6rDk?=
 =?us-ascii?Q?NnBZBBiN4AHjy5g7yGqJxKpgSMyHNqCYd1qY/corPLLnRuLxMa5FgNN0Iu87?=
 =?us-ascii?Q?MqtBHYgbVaePeBaGgoLnTVO/msY9ebkKbGdd/ZKfKbi4R/xM3WMadTzlB7SN?=
 =?us-ascii?Q?pPiyWX6GVGIGjVRrxTpFX2vGcfXwHD46C4mD709bpJCeIAHdCo37t/B9IRMF?=
 =?us-ascii?Q?ClzPyXLx3644W144XFf4aEnBGcrdGe/83MVciRiU8FTNIKpSBb0EzbSYQJR7?=
 =?us-ascii?Q?QECDT+VAilCvCBcrs1CVQhKIuriH3KFWKM3zCihLdkQy1ru7p/4dT6jqQDZ2?=
 =?us-ascii?Q?dG1MyMXMO+T8e1H9not+JcOhvWWBooDkfeeUYEhC7mi2u9Jjxtp2u+4iqJhH?=
 =?us-ascii?Q?6owzCaP1rTTitQYjocCJGRqFPp8VFeR7S2aq94rg1FS+3I7aH76pp588bxub?=
 =?us-ascii?Q?dZ0kh6El6Hl5w4RWUErASg7G/NuiAKqNcNggKmanpcI26DbR3KhJ+NNl7Yf0?=
 =?us-ascii?Q?L3H0BATW+kBRgM2vlpEcygKR44Qs5O3LOiDz7OtJYnFqGAZB+sxDKzKH3ML4?=
 =?us-ascii?Q?gRnqnjWlBOeOa6T0qcwMb5nI/9y3u5CMamVevtz42e7cb9ZXw0+Yte6Lv6Uh?=
 =?us-ascii?Q?vAc2UBPEpnfNMLwmayZGQ6EraHZn8w0Pj0NRwXBOI1KOyxTonvoCY9+ix3NA?=
 =?us-ascii?Q?cIb6pXiy91mqvlFwUmmzsTIhCZCHMpWUJPIaBoh0XpM1/v7TBd7UXMH6QZJc?=
 =?us-ascii?Q?gkZWUhKzB0z9YjmPx+M/k7GcIw65HsOMIsCZ8HHRAmcV2oOKkoj/yKjKsNu/?=
 =?us-ascii?Q?9lkp+rrWCHZE4QWYHm4pAP6iJwTd/7oLzleaG0JgNJEAwH9TeXMgzjpe9+jU?=
 =?us-ascii?Q?pqLDLOVN8CrBnTvB8AOhUFiItliBGkFVlkcelJcvytEMisG0gxNPXiFCwXBP?=
 =?us-ascii?Q?zqUn6Tv9bw2d17KaxzUUwPFH94np4nr+l2WtF4lyCxQMAtUYy5SbtMbBQUIG?=
 =?us-ascii?Q?YOP6RWOqYR9QgyKqwrr1G6eKr03/+4cY0Sccn8Do+2mkLvm7kSWEmi98KRAO?=
 =?us-ascii?Q?XoCM5/u8P0Nj0JwkCo5RO8hM9HfWuTC4UdheTtGxNvqMoGBYD5YxDE8jMhAa?=
 =?us-ascii?Q?WxrHiVLJ0nW4/NaFhWZMcBuf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a06224c-f2b0-4020-3dea-08d9007c0722
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:04:54.7014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lj5Z9jyXVOC9XCwGwDtOXGymVDZ31riqDO1gfeHi2bktmXL+JhYqTAMVbJhyQYBI2mTW27pcFESMDdJqo7Y2wQAHiHEdX52QGnTRKhZ0y/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
X-Proofpoint-ORIG-GUID: C2wuM-WNUaaBgLTE-mG38smFkZWg28Gp
X-Proofpoint-GUID: C2wuM-WNUaaBgLTE-mG38smFkZWg28Gp
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we haven't done an unbind target call, we can race during conn
destruction where iscsi_conn_teardown wakes up the eh/abort thread and its
still accessing a task while iscsi_conn_teardown is freeing the conn. This
patch has us wait for all threads to drop their refs to outstanding tasks
during conn destruction.

There is also an issue where we could be accessing the conn directly via
fields like conn->ehwait in the eh callbacks. The next patch will fix
those.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ce3898fdb10f..ce6d04035c64 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3120,6 +3120,24 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_setup);
 
+static bool iscsi_session_has_tasks(struct iscsi_session *session)
+{
+	struct iscsi_task *task;
+	int i;
+
+	spin_lock_bh(&session->back_lock);
+	for (i = 0; i < session->cmds_max; i++) {
+		task = session->cmds[i];
+
+		if (task->sc) {
+			spin_unlock_bh(&session->back_lock);
+			return true;
+		}
+	}
+	spin_unlock_bh(&session->back_lock);
+	return false;
+}
+
 /**
  * iscsi_conn_teardown - teardown iscsi connection
  * @cls_conn: iscsi class connection
@@ -3144,7 +3162,17 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 		session->state = ISCSI_STATE_TERMINATE;
 		wake_up(&conn->ehwait);
 	}
+
 	spin_unlock_bh(&session->frwd_lock);
+	mutex_unlock(&session->eh_mutex);
+	/*
+	 * If the caller didn't do a target unbind we could be exiting a
+	 * scsi-ml entry point that had a task ref. Wait on them here.
+	 */
+	while (iscsi_session_has_tasks(session))
+		msleep(50);
+
+	mutex_lock(&session->eh_mutex);
 
 	/* flush queued up work because we free the connection below */
 	iscsi_suspend_tx(conn);
-- 
2.25.1

