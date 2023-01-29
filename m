Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3730C61D97
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Jan 2023 23:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235082AbjA2XpK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Jan 2023 18:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbjA2XpI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jan 2023 18:45:08 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B58F18B13;
        Sun, 29 Jan 2023 15:45:07 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30TMgwgE031612;
        Sun, 29 Jan 2023 23:44:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=QRa3dZC51XS/Vx0CVtCSGweRxmgtzP9jpjq3Ph4dULY=;
 b=VOdCwjML+yomrmX2B+qs+bcJjFYviMtxVrViII2v+fwrm/cQ1hWPmXsNO3lwkFvvGi8K
 929ELDNOKVOf3Pu7QCwm9SerFp9DlAWGAkKO5wZOhosnfYk8Xkj0OhmoUOHb7xR2i1tU
 n7f6TD06s5U/qDetj1cImXTVU06CUt1OTlH1KStQoS9i4Bg/1HwVHudwuQQG57rGxSO3
 ccogQjO+fzbBfaJFwqWP0gZziyx3pjRdAaq9to6O/4eN3wAsXtsUVcGFJlPKJuY+9gCa
 7XJt6KEutnZe+cRTNsYwls4HenW0+aOnNIuWshf1/C6kIj3v0D+VI9s9DFpOtxxQS/eu Ow== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvm11sbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:44:58 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30TIZL1Q019074;
        Sun, 29 Jan 2023 23:44:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct53n3c9-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:44:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PHcc+fAajyqH1JOpx3dB0kyLEnUh995AbXAIiZNFviRvGBkIQ7EzhzfyF7mBbXkvrbkH2I4HQeKl6nLnNVQ3HwJJq5cmk+yGqp6UrBpIzBx0iEY3E6zN+8viuce22RP2GLMnHuUsp1WHaRkesAgF4QPFoQKK1csKpG3I5z8oY1BErbPX3UQeBXzAfrws8+1Ieipe0lvtFQW4MrKRA+VtRTQj/U1x0COE40aAkwYUHyQuX4ASVXrElrarZGR7PECMKFu6/bTSQbm+CadnAyzfsi2GM5Z9L33syheowsgzoW3vfEKb5S0nX5YbCStc5YvpsOzwTqlLPchcNgb1As1bAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QRa3dZC51XS/Vx0CVtCSGweRxmgtzP9jpjq3Ph4dULY=;
 b=Z3PYECp6tXT0dkwTDHltNTexjjSp1wVIGTor+HMDhgC7S5vswgHLgRfFYam6Ij4i6jw0O8PlD2o0Vf7xRoZS+l28FV/qi/Nj9YpxcuziLRIyu1f2sHjo3rJp5Ej2sQk9I7vA2HcMOQwvSwsPXKeuSkP6JMOAsG0l+c92TdsUxJbUGXz+GCtv0XK7xT5JayqsvbYYJnaZ3Rbtnj+6l3exZ1WBIQvQio3jocYDQoLAhcoy7/8ouBcM/XVtd040bk7pdqezGSuEmsVjv7DCYdxHOw8NDWf3CWuMOy9/KTx9fSnIS0TKwzAsGJKqoNY/raLiFXqawPr+6OHqMTE0ViiUxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRa3dZC51XS/Vx0CVtCSGweRxmgtzP9jpjq3Ph4dULY=;
 b=os1wBk6Vln6OZcbRplaEmdVgrjwasZwq3Domdb1dwmuzY5+ZIHN5BvL/eAFwG9QyYgX4I1eoV8S3F45bSzOP1363Ltho8eLHRn8BF6d6cYKi8v4Kw4mB3jLM23KLEoeJtXjqUDL3O5ww9QfQbaBRvWTwYlcI07w4hkjOpHMDr7s=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4649.namprd10.prod.outlook.com (2603:10b6:806:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Sun, 29 Jan
 2023 23:44:51 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 23:44:51 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 05/14] scsi: target: iscsit: stop/wait on cmds during conn close
Date:   Sun, 29 Jan 2023 17:44:32 -0600
Message-Id: <20230129234441.116310-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230129234441.116310-1-michael.christie@oracle.com>
References: <20230129234441.116310-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0073.namprd05.prod.outlook.com
 (2603:10b6:8:57::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4649:EE_
X-MS-Office365-Filtering-Correlation-Id: 196e78f0-e309-4b33-4cae-08db0252d0a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: syKOSax5vcwtCTvYbt06KVsB99vDsWj4StjVq6M61um2A5bfKWsblINFB8+dcTGZR0b7K68peiGNPbwWYFJS/L03IhHJmxK7wimsMPzFJXureDYUNFBPEq5Ix6a0rsyyYxZUVuJLCHPMxUerSv0xb0NB3efksy+QPmceOsG/QVSMOueNo3kwABIm0rL4jnzLEBKcb/KXYJUJ29fqmiN3s9MjZYmLt/MECZmXvRG0zKVVwMNSlq4TGvdEOeC0Y+vKa06l+I1603LbM9FqBYRyRRzbzdELvqW3py7w1EzoK2MwBRIZpJWsLh4MxrkjifbKckpARU80uFE5utvI5cygHhp2FHHmI3q7qGTw0SV4v9os2rsMwomuaz276iP/tWLef/kg6VEwgSn+Gv0DlSMGQN9JvB9beiDJJlry7Okc8M78/fHTsgaKpeiCp1gtnAlPPKfFwr1hoAZi2eAfBnzJZpdSFM1RdIrx1puaBmWYlc7uGJllVuDZuwzJbz39mksnUUNaWGM7LLMH2eklzJ3EE0l1xJ4Z3q/iwORLmLf8KAxd1SvaEZb6XWMMm2NzlNEABbu1ndknecO1Ue2JrLLG2tQI2xj4RgCL9+WyV6Jzo6T1pXpMdcE6WvvgC6HU/1JwKxmD7v6WQIefo87B3xmLnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199018)(316002)(5660300002)(8936002)(41300700001)(66476007)(8676002)(66946007)(66556008)(4326008)(2906002)(6486002)(478600001)(26005)(186003)(1076003)(6666004)(6506007)(107886003)(6512007)(2616005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FMr0XOdyawbpmks1bql4QTHmY6Qj+vf+DaBbDpWkcDx9ie5jcIVByLiBHq52?=
 =?us-ascii?Q?ioM0W4D8ixtoP6KDTQq8sAUQ+AoF370aWPnwR0o+meWpLxqet1NJhAgwyKAA?=
 =?us-ascii?Q?dP+N16JLjHXwhiPZy7Gbi1WR4GJNFkkqT5c6lBZPGANigPnFEwgd2ZHTnPqF?=
 =?us-ascii?Q?x0f5fm9M5vhq7fuhEhVzyDtSzYndGM8oFdKPz+H5XbZU6BrFpZbHqf1mXcFQ?=
 =?us-ascii?Q?5PuZn6EXkhX1njdEu63F49wWUTrKI9LUY/sk9VNR82Qm5EIngFCZYIpxeH74?=
 =?us-ascii?Q?nO6ibzSHmLIuxef2isJQrz0rsZedqfql2Jq81daNbj8KvfIbWHLXopGiUfMW?=
 =?us-ascii?Q?/CGGqTuVl8jDE/NrRCI2HJEuWGMIA2q4BgkaoioFddhIJrW+ywRLODOgm40f?=
 =?us-ascii?Q?uDJghAHmZJSOVVaD9e5CTulMOQX3m7F1EmKnCqfU/toobWivZl3IjA7j2gpA?=
 =?us-ascii?Q?rBGJ6Plf/WoN9uxzmE6dbYFPKXaoNbkGD5iFw8AlacsvwcnuN4+OjnyRzVYs?=
 =?us-ascii?Q?EqBKKtASH50Fgy/5dVUP7GwY3sMawMqkByLjsdUn9zHKWX/VE7XuzGC9zxv1?=
 =?us-ascii?Q?+w4hn1MDygRNiInE77cfejznOFWwuqp7F0Si7xyejXwNGDog98PKM1UUIVkK?=
 =?us-ascii?Q?LjbAlwUgKtRiqhMcHusDKgytjB5dfKYlFN1nUDM4cqF+vTy3Cx025lE3t6+k?=
 =?us-ascii?Q?bgkhukTHGVGvPsKPWmcT4YQpOXP5Qh5jFH8ac32M5w9BWT+dtmUTiBdHYdgH?=
 =?us-ascii?Q?S5/aAnEogBPdfrrYcB/rDP0+C4iRqij2h+0scRmJHaZZ0BO53eW1adOTOK8f?=
 =?us-ascii?Q?DnTYpKbtEjZ9ESvFWO2bqvdQL9dG+EIsRkjNVP/GBw935qSE8J4nOtidEBOt?=
 =?us-ascii?Q?iqoKya+6bwHVSDLQBDq4FG+mI+sQexGK4QEi86JclhYCmK9hRpcPW6aGWsI4?=
 =?us-ascii?Q?s6r5NS1DQbfadFHFGHq2ksOkZsX3ITPhOJADb9SDR+9wnRqxm+5jAs/GEeV7?=
 =?us-ascii?Q?7jFhO1EtzsujC/oG7kYRBgVwnujeUfIehXWrekTWmJnpC6wk1TnPfXwG96++?=
 =?us-ascii?Q?8ccPSymA+yHVu7/TjSniysZ6EMZTntezHEKFcvvinGrICpuWEzJ7jtaKg/ug?=
 =?us-ascii?Q?8LEcoxUIUb97Ot8ubHvI7vaefjhM1L07l8z4BrwS7a56OgCnlEk/9ZCH+3aa?=
 =?us-ascii?Q?olDnhbN4H+AfZmEgpmOFkX7IXPcsQB17/2LnI9+Jlrgx57DbRf12uCXKjSyl?=
 =?us-ascii?Q?5oKG1jbQiY2egqlzG6315aeL8GJCteTOWMvoKHH0PAXXPKTHugt0wL4iludR?=
 =?us-ascii?Q?Qsz0eKNKd71+2MVqVRgk98JuaWUc0BjMCeOYCz6zyR8ck/FLTakKt5KpnKDY?=
 =?us-ascii?Q?rkD2QysoO+Qa76YD6Dw0uoDx5N5vxWlfjlCIrlGegDDPLYRLrVBsqskPBTvT?=
 =?us-ascii?Q?/oH1bg7E7QfSxyu9HAKZh9kepI3OuUhuNDSpu8SmVVsj8AuAxQoAilbMy5lZ?=
 =?us-ascii?Q?nU7d+ueqi2eo/NtYVEdW1WQH/syTi7OVoCWV9gHvBU2ZDtoIu8a9ootMukGU?=
 =?us-ascii?Q?en/05Dh3d3E2bkEBMrB7dVWrwwo07v9pUzq3O2rtTshYX+H/QGoW5EVTEQmq?=
 =?us-ascii?Q?pA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: VXOXcyBQYt1ku0JtIu+6vvNSpbwLtfwuzdTi4vhjo6lLP3/qXR/Fexv6BYY0De1rLbtn9KvIdxlKhOjnsTzGe9ZaTm6nmpibgubgPVLRiWbbaCHlBQnLwOn3A1SXYLmBJHTY6+TS4BVJPy2awnsZ0+KfgAxw/H4v5yDrQMjmqNvfOMp57WmTWeqXb+anvtIIdHMCbzAz6uey1he/1Td5rgiLaMG7kZh/gtyC+7PlAqBX3CDh0oTH0wVq3zKOAbzVcBE/jY/tptwDB6VXjnG+LLq7q1AJ4LO9g6K27IgSj2xVXSNUZd3JsshJ7N0jAS0g1z4srw8SQU/zSAbthdo0L5DPwDTu1UoeNjcgpx6TdQ3FDrLC2oJW3cysIql20UtMCScSbMtlNkYeW0nhGg/8jGtMuiTaacR0gaDGCfYlWdNInZkFZXvRyAY4a6b/jGdRybG/E6cJFTZc872T8ri8qFgsqoLV9YnNwmr5FA4sskHKtpo4ktzKwMq5WX6H+iGqqvN5w2eUWRnpkgEDYgMqcvEbGWPDNjAcLPDwAZD1/3Dk3dE4vYDWuN0Qoyl5/89mLYDC9HksYLzP7PqzRqrw9liBcZfJV/j1Z3y5vgpBW5ig7wRpnEC3ETdRYYuxztiQ9uGPWQdqkxasmcwNpYlw4jQ8fIrHsN6DnaeGU8PO4ew/LFN0DmmqoJaBM5SZaig/N5y33LiO6HafDlhLF1FHxy9gV0kx+nJpaUX9qlikewnQ9TUL1Th9yE8SNrHM8gOEhMreB2my7U8kmrQ72j6/vD3FgkwYwDgXk8m5e9O4fben6lrOjTPJpuEorxEQkZbnkbY7ZeFWfNWwY4tpfMo8MQ41Hbug8ubWFcOqSTDOOTwxXsdj7OtvJDZHNo6rJj3v
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 196e78f0-e309-4b33-4cae-08db0252d0a8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 23:44:51.5727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2rIle4gUoBFv/wA0fcYE5Lq9LuOs0rWbvKQXyH8do0OHQbm8lid29U6kiqL9D+fWxjJHmzUPuWYVf9HjyH69DML5uXH9tA+h+dvcEbgR87o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-29_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301290235
X-Proofpoint-GUID: mLH3WYgWERV-z2DzA7rWubUJEm7lorO2
X-Proofpoint-ORIG-GUID: mLH3WYgWERV-z2DzA7rWubUJEm7lorO2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes a bug added in:

commit f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop
race")

If we have multiple sessions to the same se_device we can hit a race where
a LUN_RESET on one session cleans up the se_cmds from under another
session which is being closed. This results in the closing session freeing
its conn/session structs while they are still in use.

The bug is:

1. Session1 has IO se_cmd1.
2. Session2 can also have se_cmds for IO and optionally TMRs for ABORTS
but then gets a LUN_RESET.
3. The LUN_RESET on session2 sees the se_cmds on session1 and during
the drain stages marks them all with CMD_T_ABORTED.
4. session1 is now closed so iscsit_release_commands_from_conn only sees
se_cmds with the CMD_T_ABORTED bit set and returns immediately even
though we have outstanding commands.
5. session1's connection and session are freed.
6. The backend request for se_cmd1 completes and it accesses the freed
connection/session.

This hooks the iscsit layer into the cmd counter code, so we can wait for
all outstanding se_cmds before freeing the connection.

Fixes: f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop race")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 11115c207844..83b007141229 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4245,6 +4245,16 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 		iscsit_free_cmd(cmd, true);
 
 	}
+
+	/*
+	 * Wait on commands that were cleaned up via the aborted_task path.
+	 * LLDs that implement iscsit_wait_conn will already have waited for
+	 * commands.
+	 */
+	if (!conn->conn_transport->iscsit_wait_conn) {
+		target_stop_cmd_counter(conn->cmd_cnt);
+		target_wait_for_cmds(conn->cmd_cnt);
+	}
 }
 
 static void iscsit_stop_timers_for_cmds(
-- 
2.25.1

