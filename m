Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2CD6C74A44
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 22:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbjCIWeK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 17:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbjCIWds (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 17:33:48 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE7AF2C0B;
        Thu,  9 Mar 2023 14:33:46 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329LwvhV008493;
        Thu, 9 Mar 2023 22:33:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=0DIVFmFQcz1zt0nKytRT6G1MXFF41tAj35//gDW2lbY=;
 b=bpZBMzNERrXNn64SXmZNyDWpZcyBrYC+K8RfQRABn6aJBp0NGTKN1SgCo5FJhRYFtbUk
 owm/TZPcONJb57EnMo05tsLXHA856lhfrrv/SNS5EB0cuNRDArY3xaT+2ZmRdE806Ziv
 yELaER8wLrcRbJUk7e+yAGcypFRkb2GmPTy+ulC5W0qHWe5wTIfc7lfYW/sJf4W0RMkC
 Zji4h6hMa31e5UkIVjk4Xb84TLiMMcmm+LadOmaaZIAWGF1O2mtTgDRJowBGz7wswjpe
 fs380fEObU4xA/3bwVwDzHK5eXpBDS1gB40ZxFqyNpOuZiTHrVJHjp7PqzXIisBOA+fG iw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p417ckyqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329LG3c9021722;
        Thu, 9 Mar 2023 22:33:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fraxmf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhYB5QdcCqdSeqJXypCujwke3rxIQLtNadbBaY9vupS1Lf1ALVj27N4HJBK1JtkyeeCeczWteKtOa5d7jK7rddVPNbmJ5cDL1K7LM+5fN2o+kmoB0s9hVbVUTkSwaVgE/odASx1znih5SDFndN9SHOwv86LJMaSRe65mUsv56TwpFaHxy6VHNNjh/O+f7dIu5i83HwdA6nK6v9qB2UK/pmM54fuS+Ki33b4jP2/4JjkFMgzC7xotZioSwa0rfP4PswqAdrCQvPfkYILIGAooJ8eeJs2TF/s7TB3PSKXX4YBdN5JDvJA6sVYKa+hV6aNdehmfr38L/DdkoCoGr5+71w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0DIVFmFQcz1zt0nKytRT6G1MXFF41tAj35//gDW2lbY=;
 b=AzzuwhqEWKg5TrGjy7pCfDrF4kfRshl91DlMMCUKrfrWoJmNHzxFNIc7a6Kz2eMriYpVvAyXdK+6Zpbm0wkwjnGFZMspafD3ZD26eRHr+BH+h/vNlj6eIJow3UzyMHvHpigT9MAZvBbGdbHwPb2n8zIP2+Hh2giIO6he8i2e3KSfgqpWl5AMOllmoBVUNu+5suFUJiHWVWt61c1NVoSt7KNx2XfFuL8FYXN2C2/op5USbLVhJSgDjmQLMIbW1pU5zEUShx+o8bML10TfkYkoRWNShFUKS8nxzfje2wOVDVG2crER101ycVqbV1iW1V34quQZG3f3qc7yhnDmw5u6xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0DIVFmFQcz1zt0nKytRT6G1MXFF41tAj35//gDW2lbY=;
 b=JP3gJH4BnIBorT7qoZUWaK/7RpSZOwE8n6+QKiE758O3BI9Z4mNkFAU69TlZMS1E4O2G98PchsFJ0fJ3xWXtYAyebqMiXH9BxDaLxRWcV6RobzGG6S1w/uKFVIzgEfYnKPTY6v2IcQhPrjTA0g5ZiRjxBk0g9e4wRlbjux0CV+o=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6479.namprd10.prod.outlook.com (2603:10b6:510:22d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 22:33:35 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 22:33:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 14/18] scsi: target: Don't set CMD_T_FABRIC_STOP for aborted tasks
Date:   Thu,  9 Mar 2023 16:33:08 -0600
Message-Id: <20230309223312.94595-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230309223312.94595-1-michael.christie@oracle.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:5:40::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: 07583769-e02a-4274-b426-08db20ee51e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2mWey6G3i23wprwc7ryrP16ubRSlgkJYs4iBEM6drAmnxplgyqalUV7ZuO/kUtGjGLT0naiZ/vu4OpDGsEA8wc5q2kROuU0MMfwB+Zlg14oKfEXheUcKcVennregNA4mAJgOAqj2pL2qbz+a9iJpVgMs2+FKWdUFQ0xQvz4blfGeu7BaUbsJMW+QbeST57PaixCP+/0G4rQvXlfmaDIGx5DiMtjWdU9ueXwMWwOz/YU9tIs1SZ0XSvlIuEcwcqaWuYqNRJdMNGWybveJy0V/RXL7eqRXO+BnbK3QkamHVUnEaBG9anzNhtLplHfD6FAGnLY/kzo2h7EYT08SglHJ+Zaax2qIwm45Cs008rePw2noDTcxqIhxxwmmMnQuR+HApp6K/FjloaCiC5AuYqyDa559OhOum9No7yvHSBo0jp3PMFW10W3uQtqDYkwQ/ZtEgR1Rdg8tQ1xg6lCaHDKNMLzSCtpKsBkikgMjRuitrSl9/LRXeqtDPQvUuwG44VXgDhFLaJmYphQEZK3x8dEPnJXkq0dvHIBJY9LXBCce+/4TdQYSuZKVgs0xypRmPzkn+mP6c005iYEgkHfb2OWebuv9tEZ3N+CeRLJoepY+nYgGQ7KcLKL8LT15pyRi5xt5fITsngI7/3C8OReUkuJzdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199018)(2906002)(5660300002)(36756003)(66476007)(26005)(8936002)(4326008)(66556008)(41300700001)(1076003)(8676002)(316002)(86362001)(478600001)(6486002)(66946007)(6666004)(6512007)(107886003)(6506007)(38100700002)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6ofxCaPHS8Dai3nQfgyOkt9HYqs+HXbywaWSr7zQ8gR7VC8nSCpXP3yHVnKL?=
 =?us-ascii?Q?dpL8x1fuIy1Pfyf4n52jHZgkZgajtRHK1ABeGv/PtJkTSEflmE1mmaQ/vp+t?=
 =?us-ascii?Q?opCghPGF9rkzC7FJXvIdGxBvw95ryZ+dtewUUKI79ssnxXRiUNeAokf0q+M1?=
 =?us-ascii?Q?qlS34zxQp3282pLgz5Cw6KPeLD+WYGRxphwZouvxLVioFy/N7okzmBffnehr?=
 =?us-ascii?Q?1b2OApJ5VbulKJBMqOuIctxF/pz30ZPvv7e3p268tz/RsDHNDdWXtPqOdDoJ?=
 =?us-ascii?Q?eyzYz7DRQ8n8HousQPg4HVmj5u1q93yhcavZrOTAgrp/lmopHlz5jGDJlSmd?=
 =?us-ascii?Q?jKwrb0uvpO/zUbtoITU8vithKNV9RlJRjw0yKypOThcJao834BhESWX6ZbOy?=
 =?us-ascii?Q?/nqPqUPcNbQ+kpr4jtQJM8za79mfu+qZVWj0PZbUfry9yQa7uK2pQjURfnpQ?=
 =?us-ascii?Q?+AwaPJmwSu35R8k8lfM7GwhjaClfVMeh9ni7VNMokDai+kCmY99Tgn1sfpaQ?=
 =?us-ascii?Q?f2l5dSQ92tSP5bqkmv7AsxQbBNbVz9fnW9itFTaHnh2tYeyTb5+PKnMSMBZC?=
 =?us-ascii?Q?R2mDkZkzWiz5jnxnRrBcFIKCkiKnYJg6zBLKPTKdJOEnAz3HEeRdjUrhwy71?=
 =?us-ascii?Q?LOwLp6uK270AqckJ2asuZl14rQHOTj2VdyWDTctiJkyqxubTZr9zD4rXwfZd?=
 =?us-ascii?Q?U8DFmcXLpDBFvpW0ZzbTBAYWZNlWIPGeQXHvhbhPyuHzzJGYg9RFocEaIkgg?=
 =?us-ascii?Q?qG3xapSG2VEjGGFmC8aRsrt5ClPG8TFUxaKoKEcdcEPfoSxaEIZTITDApDUj?=
 =?us-ascii?Q?No8mWzCwVCSVU/XU0gsxI2tS+XqcInypfsTTcQxYbL63Q0wAtI3p3/NxVaig?=
 =?us-ascii?Q?8+/6/Qky9ECxQJqR+D269/QJ4p90rub69PGKlege7BX0K7/i93bpM03jOFFb?=
 =?us-ascii?Q?AXkbsuIEJ48X+4XEz9pGFg/LnUFUGIDqH6ELxrR9ISjx3viQ8sjWRYivhwLM?=
 =?us-ascii?Q?txJD991LiHjKtvBoy1RHxirlziJLNSFgeJIa1ahsCEhkTFEMor6qk5gUFtVr?=
 =?us-ascii?Q?Whd6b1nS/ZmFTzpGagWmExk3M+Da3jv+W9soQBwVTo11Do0vsDWLaIgwzqOB?=
 =?us-ascii?Q?Agu6NAAAv0y3YKP4yISNedjEOfPMptmfuZfyMrNTyXUd0ejF8GU1ZNCEN5sc?=
 =?us-ascii?Q?9hQjGS5qmtzuFc6SjNurt95tlPMavhHF8MlqVs/eiI6RPt6BBEnEdaGMwIRl?=
 =?us-ascii?Q?xlEzYl+UUcm5l6cKsv7Kh46F+u1kluhm64DKQinC3R+oA/so6ISsgCkG/wWk?=
 =?us-ascii?Q?rw3kAzxNagBAqGjZcRmw0SER3Xu3FDvVjfyPuY9jSayTqUlKM+ERGSTIshGs?=
 =?us-ascii?Q?u9JCNjWaKIUIHOxCbaSkTaPqK1qb6Y617JcKSHVYiMqhAUTEvZNU0JzowxJT?=
 =?us-ascii?Q?FoSEcAyOPT3SgqSLiMCyfrkdULM4VTbXM72+LXe9kWzPsyiJ0UNP45zxrsy2?=
 =?us-ascii?Q?UyfYc9db2FoDWRFblzLH2a9JNRC3rf67t7rCCo4WFtYB7WkfM3/bbZ2SB1/J?=
 =?us-ascii?Q?AcvC3nnmZD3zTyD5fzgqQO1jZtUh0w4Buqu1BvvbdRCvmhDmy8NatOYqPuwJ?=
 =?us-ascii?Q?Zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: DnMDkb7XOzJEDTOTNXFJY6HH4vEVJibcD0/pXLQ4hfXVxSdmOyVE8Fo047mMbbS+B4DErnBrJC8/E4CSdgTUNKLgAM2arkNxfUSzdBB0VZlcWhhg71T+CrRSulFkSqjh4ZTvU3ZaMMGz89GOnD8DKJ24YUTRcTYyiQhZfHCeRQ6QzAnOBJFEc21OCGWm2K3vpAW4Z9FUndzix/wNBOpRlU/mlW1jmeAR1sB/kQUjCDt/9XZ680sq2Pm0ezRhWbQ2WzbF/OTfrYDzG5lSoi9ggDx98oOUZT6nt4kf3Gl7bjSYnFo8VN7nn6x4MuQmvYblpyf4wDadmETF3cPXMc0sGVtU7tcwyReaO2xle0Rol59c/dBMQXM0Ur/gIP/H8znlCP1ZOoJQptNk3g1xg87OFuuc7mWnDQULD7uSZCSDTQp2cv2aptvYRXIemTKxg7ngaWAROTU0gZQT3fbbioV+YoxTowm6CScOZiYtnXHZJ+Z0Azi3Laj60hKsXM1ZaffMyOhwJTRDb0FDr+kJW1qgQQquvxmlPaMXo04LSW2W+HiGy9RRB5EEUJjJ65lanahfcJZRSfux5vZI0ik5P7mjeMWTtIFyAKjkhuxdZrsw026H7oBAv4TgdzybfFRdmVjsoV6PQ6c4XNhksl+odqHCGhXJiaZKWiRhnkYX5uFPierQUczs8E4VDGceKaeMW0FkQaV564nj0Ym8rJRR3/elwM3snFFMVl52Zz0nQ0gPh1EMdduXZOuQd4xGZGcoMZYMVWQRGSPIw4FXd0xbk7scpaV1rmefCVhVyIK5l53JiJt8lRbWfc6B5fmavXOFYuequIQ1VEpAbLo+UOKm84q82dGZ72DBgAtOnE/MScxwIuZf4ELgN0Cw9RsFPXxSXauJ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07583769-e02a-4274-b426-08db20ee51e1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:33:35.2358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zhu2UDVJssNCAq1WiyiTGdg9WYpNACgZgWs9YHu1tPkN36u3wY9T3OY2ifHmqDagZHuyQsOqMEIIDMzzqdf/4WlllUMBgDrKzgovasGNKc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090180
X-Proofpoint-GUID: CRc_7INRIhhZrE0LOURN9LOgT9ClPjt1
X-Proofpoint-ORIG-GUID: CRc_7INRIhhZrE0LOURN9LOgT9ClPjt1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We don't want to set CMD_T_FABRIC_STOP on commands with CMD_T_ABORTED
set, because we can end up with hangs where:

1. __transport_wait_for_tasks sets CMD_T_FABRIC_STOP but because
CMD_T_ABORTED is set we hit the:

        if (fabric_stop && *aborted)
                return false;

and wait in transport_generic_free_cmd's aborted wait on the free_compl.

2. transport_cmd_check_stop_to_fabric sees CMD_T_FABRIC_STOP set and
does the complete_all call on the t_transport_stop_comp and returns.

3. We are now hung because we are waiting on the free_compl which won't
happen because transport_cmd_check_stop_to_fabric completed the
transport completion and didn't do the check_stop_free call which
normally drops the refcount which is needed for the free_compl to get
waken up.

This patch has us either set the CMD_T_FABRIC_STOP bit and wait on
t_transport_stop_comp, or set the CMD_T_ABORTED and wait on
free_compl completion.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3c732b1b5389..1e42fd3ac8a8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3245,11 +3245,14 @@ __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
 {
 	lockdep_assert_held(&cmd->t_state_lock);
 
-	if (fabric_stop)
-		cmd->transport_state |= CMD_T_FABRIC_STOP;
-
 	if (cmd->transport_state & CMD_T_ABORTED)
 		*aborted = true;
+	/*
+	 * We can be either CMD_T_FABRIC_STOP and wait below or CMD_T_ABORTED
+	 * and return early below and wait in transport_generic_free_cmd.
+	 */
+	if (fabric_stop && !*aborted)
+		cmd->transport_state |= CMD_T_FABRIC_STOP;
 
 	if (cmd->transport_state & CMD_T_TAS)
 		*tas = true;
-- 
2.31.1

