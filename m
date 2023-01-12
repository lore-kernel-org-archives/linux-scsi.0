Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC945C5479D
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 03:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbjALDJF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 22:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235845AbjALDIz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 22:08:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BE249147;
        Wed, 11 Jan 2023 19:08:54 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C2kfqx021032;
        Thu, 12 Jan 2023 03:08:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Mi/E4IPBhZwDJoQpXvV+wqOhSfUD0AN3ezPYwIXFuIE=;
 b=RoruOjNMJFTmF54a1bN9FLwO+KCLMLINBsm0Ov8kH2DUIkg1qZ99pHegMOGTc2nAl/il
 7zj6rRmX+ddaqluGdJZGLYpwUVKBR8OsyUzhbqn6ZSriiIGkjDe7cSMPuqgJHkIELJ6G
 +67+9YCQOaYs9Pq13eVCJHLbf7FZ/1gPBKY33kOFqQlawQJxSYvgNV2eEhnm/fAMY/sN
 H7YQYf4ch17rAryVkD3By47LanID27lduUni3pt5B3ET8+8qw9uMCSEJ4MmrcV0Jk3+R
 p+8igLfq4V6R0LqRwxl2wtjSzNZynzBf7m+OSM+K33VHCyFu/VptoUZhREgnhzgdf8GS pQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n27nr84h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:49 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C0f0YC034176;
        Thu, 12 Jan 2023 03:08:49 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4fuxp5-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5mke02PFiefnYKkG/d9enjliWuGLbF9jm2MI0DHkxozrgmCKgpw/ZUHKacI9qvnkCEOQhLE1UbD/CIm7cgIWOVcm3Oaf9DKRQQ6SsUmdDB+i8t8UZl+ZT6rpXQ6e++o2t9+6KbuEAsPeJmgw9rQ0pyg4C75mwPQQtV9SBHvNDKULynntCXkDfH4JMjkT76u5ahaTXBpdNwxjBWlpXzXGCRYE1WyoDALjXk1F9VQh8J4zNEicCAWzznwlQZKePhvL3Kvl2bHngl9LY8Zl/CXe9zNkCc7Eu4vyPI/sDBq2B72Z0W+JZxLbWKSmPXGXa5Y2+kcCHyHAMJgT5KHuRVbfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mi/E4IPBhZwDJoQpXvV+wqOhSfUD0AN3ezPYwIXFuIE=;
 b=k8sCQIzqlb27S3EIUUxCBhR8fv/EihLpc+lyuPGVGCF5WQ9N2OPPawbJe45EOavS1Jebs3LGro8AZWacKYojj6NzDLXgE9AkLa2RIXxYMOBa5ADnRheF+59r5xVjrng5rB8XyvV2c6ujl0pm61pDokMb4U2u5hPLCcWb8YBjV8b9sJY4xAzYEAdpQuucMntxwpTxCXHljdIfsR5Wocda4APuyr2xsjUL0nTwDCIiks7mspGm81wD8Asj7LdFqBSas5SY9oN1xlqzW+m7tEycgKmgSAZqQjmFvvk/WK/fwNUaeBTGlLzZRwm5p/gzMNtFDT1wjxFBberztfu61jrwSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mi/E4IPBhZwDJoQpXvV+wqOhSfUD0AN3ezPYwIXFuIE=;
 b=YuLW5pLwSjpNwbx4a6ymCoEc8R2M9miDUZ3lePIPLRoOQ0oO44W1pLg63ZEjgyCPHAl5jvagtcXHH6pb8jgTetUHjPKr82HRG63u3bWU//vJNzmlSAtVSbinpKhMGP4bCV7P7nm1z6WBc2EfGYPChEqiIjHeDa1lsWmLawLn/OA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN7PR10MB6595.namprd10.prod.outlook.com (2603:10b6:806:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 03:08:43 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Thu, 12 Jan 2023
 03:08:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 05/13] scsi: target: iscsit: stop/wait on cmds during conn close
Date:   Wed, 11 Jan 2023 21:08:24 -0600
Message-Id: <20230112030832.110143-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112030832.110143-1-michael.christie@oracle.com>
References: <20230112030832.110143-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:610:59::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN7PR10MB6595:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c6c6987-ddb0-4dec-7037-08daf44a5011
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: acxn/6MRCSyqNJyTsWsO+16YdBiZsiM09aeFXZlOIkmTlV0NYBJ4IiPzAvXp1ZxdfKnhQUQ0960pTGhXsCtswyW9pJhBB9Y//bugSZyPivyFlOw47E13N7ZFLeNj6SVGf5RKukU0D1ceDIX6jaUPEtTX85VLwhMC1b0lFPmi4EJGtNWh1NslyVklIw7bi8RjmDqBFplcM+3Uf9Hov4+xcHhpEviDc6/EVAVxeFj0mESAziPSTcop0qETQvyH3cNQIEHcP/aVYsqs9XFusTuRdaR8HReEdSOGky5xKFj3EInCIxqbcqyiYtTEL8aSN0GP5XpF/SaN1m2MhrW0RRJvvevZKLcT4jNwLIhLGusKZYVFC2VANk5zI0Aj7THXXocXVkB0qR1dr2SHx/Pl/zQ5G5lCY0H2Iuil00kOwPgvlarKMKFPrcIoHH0k1LFMt3Ie1b6wt0gZ73S+IO7l4k/hcy1MNkmbA5lVTyWxtPB1ZwalZhb52PMbRLs4LYLxF1U4Hf5m4C/jqlpfEvK7OjHnUB1HBTVWqVKXoETDzHlRHoKnLM94M09ovKqmf2Ujnl8NqXQEoh4vYDz7LPDrMG+Qf6P76Uq/YTIGTgfCpxabl4ZoeWkjFQDlvfUbE1+vNLRZr7Sv3MZ7+YlFBxHW0a9WTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(39860400002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(36756003)(2616005)(1076003)(6486002)(316002)(478600001)(107886003)(6506007)(6666004)(26005)(186003)(5660300002)(8936002)(6512007)(2906002)(8676002)(4326008)(41300700001)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sGt/EHh3heXtsdHaYDa0y6GfNgYZ1/el3dejgbxKygNSLo6mdcno84iF+vxb?=
 =?us-ascii?Q?6e7pRrjQtugMh9xrvOEhrSIaiocz4gHaRcJDruhG2pIvsYVc1BT6cro8eSAo?=
 =?us-ascii?Q?xfBvmQPhY64XB9lz0HoiZikqGHrw9JquZEUTUPuPWOVUL+y2tOq7Z2isdakL?=
 =?us-ascii?Q?XNwAchv5hSLViNRl+lRTkw8knyaPRBNHk3m/X9Djbg2DkInU7xzWCcTmjNMK?=
 =?us-ascii?Q?gtwuU7QChC1XeWVGT/ihisjYw8tJh5AnU2dWxL9kbsmtXaxEI1ObCwJfbYOi?=
 =?us-ascii?Q?Ig+Gw8F4/U/y2ZT1iACtacYh/4D4zUUtW1XSBootvkKubgA6csd4k5AK7DMM?=
 =?us-ascii?Q?ZnzRJfoCS6SRug4YnPPRL602P8tNUatrJ+YjOZperl1rJZpkWy1VFmPBJVwA?=
 =?us-ascii?Q?EgQZitUMV4v48xBUo3BeIIcUAmGmb6cCWCqWagEkpXx/EI/H9iNRQhJCoUtY?=
 =?us-ascii?Q?Ie+j3bAhkASLj6jbbOptt0+3kzC532cz7is8WlqFlGpanj9zq/mvSL75K70+?=
 =?us-ascii?Q?7K+R9Bq2wu4/R854/GW1w/uxkehGR2KUJ2GNGcq3Jg3F1BP75ab5yxhSrjyY?=
 =?us-ascii?Q?FC46MxVrwCKoMyYoQzCgxGKRrJlPtonanK06rdQRI9BKFwh1Vksy7llV7gS6?=
 =?us-ascii?Q?wzphfwTf3vH1i38rwYu1mfJ7hS3XF/1TFvJTAY2h6qb+NK44qhpSykfFfsPC?=
 =?us-ascii?Q?pS33ksI3T/M51GUxh1grGSmomgPABFjtsTpQVVe/v3mNkoItwGOKrIoE7Xhq?=
 =?us-ascii?Q?qjtEx+tXbB6wBGVkOW42YqANb0hTaJaSl+UKJCiDXdmXXtohooKiPtQYcr08?=
 =?us-ascii?Q?GC4WtOVUR3Jw5UMmyPbIATmST578T6k53CyEBJduMV68blrpOXKwNBka8u/H?=
 =?us-ascii?Q?qZ+kuHDuGiWsQ6NMdF12Kn7poazJ72rx0NNgs422UaAwr0kS7QwKck4k+A4G?=
 =?us-ascii?Q?9n27EZjB4+XDtayoF2M6zHJ9Pj6NBb54d8Yydj5mrgw/lprcCDi5bK2eiE+d?=
 =?us-ascii?Q?d/WC1/jUZuc0XDAIL0cse828YIif45x1el13hwNL42jfVZt4VqWX/HU5QdU6?=
 =?us-ascii?Q?2IAEMgLiYd2pP7hkKNmlAI1OaXvAR2UwC99r0taplUVEpx47NSLnq3nZRY+/?=
 =?us-ascii?Q?a1/twRSk/cnMvL5aMge5LDTGt1SoJ8Eg510jXg1FoTdRCGyaC7pTCyal/oCp?=
 =?us-ascii?Q?JmHw22zVhsVKWnhQs4LRd6LX10pO1uw6Kdj/ujWgVcXz55HbBQ3Co/RY8dG7?=
 =?us-ascii?Q?yqHHL9Rljs4Jo+FBuXfRXl3g6dv7bvGOclnb4JQ68by3oPz295FiaRc/nvOd?=
 =?us-ascii?Q?rGQk14aX0euIysfCAJJE6y7QgexoifZWXR5cbELA2cLYXLM83tDt3ZnKO+IR?=
 =?us-ascii?Q?pLEoJ5jHAmRw2zlgHSPYeOA4C6wQos318YttiWLKk00wyHgMg92Q9P0TvXPL?=
 =?us-ascii?Q?b/ReK7yX0soBh0unDtsz0ADjLC4s4+7iXHFoshQ70261MWm/ME+90W/djM46?=
 =?us-ascii?Q?zSubMiM9hv6ZjL9Lx7Bl45hfnA5sVXqlTqeUEVqLj0v/4GzoLdwHZFt1uDoe?=
 =?us-ascii?Q?ZyBywgMyJtEfThKv/kf4YsLoRbqpjsqsM+Bp1ZTqudvOUrWmItB8dgA2HLKT?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qzPi0bYg4S7kyGJ/xgukIt13UAoJ4yqX7Q3VrmWLnUCMDVWOkjYif3prf4wEF2OqDYQ3AhlGO+QTqP3O/gt51BjBKOxhDDljqKZuxRFyG3BlzImXAwWUQrTbhydsYrbvFupNANL/0m87o4F+SfGaVynQJU7KXC44AwaIAJVpGxCtIwCKfql/YeS7SbM8Rd0sSihHChD6/KLUgjJYsWrKYDFYmNmYyiBZYC6lGhi9lp9wy0+4+wcHgRgPaQ/ZJ5EcrX86Q/mJicPNQHZNoJojWPdnhqnGyiM8J4mD7zbXgeXzk1r9AZMJB5m8d5KLTSDxBFiCcBRCn2IPSFAXdAzB/qnVRhg0BMbXLaLFiA0Ap1TZLiPVPvVpgizGYnsz4gaJ9HL8ySWnTvZX4ITcdWZG0fzrI1pXVfuCHgSX65c1cUXkGM88AwEWd99O3dF+W7okzE1wwK+REGMPeyvYAh5QO/y1IodSMWenuaHTQd8UPp678/jyFVVYj1+7DTrifVUhBQgJOvHodDMB9y5Mx2vL7FH9V2W+Ge6nSOo6jLEqfbaoOV1fFnL8sqWD7o2WDN9CV+FCHhx1x5PumxtrVc94S+qYyf9fJS5WaJNRDrI5vyIivfn62PuDqq7CXJvP9JvIYtU/+0CKk+WuJ61YKD4Y1gzz5YPC3+Gu1Hldcxlsuts49y40Bjl37HTv7GoU0oqaGAfxqTTbdgQJoOICNfSynJSNCmOLNnCizMA6L9yG4qNDrcAUJycWjR9btP/+9wiSkiB77SEQiu1jPg9EH5Qr5eHBpeC3pffTyxI8/30+eWZ8n0TTZL7fXTYdRqiHv4LrxypeUmtbYFQe3rdouFOguBOSGPVFRri1ZtDnuLRyZGLgrPjHLRSFkhnYUYKAiPE6
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c6c6987-ddb0-4dec-7037-08daf44a5011
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 03:08:43.6298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dx9Pb4dsqNQZTjbijpNA4PbC6VCtFO9H8cuu+Dszfy54SEcN9xJbbhORX4BX2kI7JkJyhKi88d7LnV3Y2owH4NtWgWSfKYnBfiVV6/tycd4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6595
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_10,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120019
X-Proofpoint-GUID: DmkWl-pH7WpR8k0UjDgYRyUTTIfOxDF3
X-Proofpoint-ORIG-GUID: DmkWl-pH7WpR8k0UjDgYRyUTTIfOxDF3
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
2.31.1

