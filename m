Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0FFDC54EED
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Jan 2023 23:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbjA2XpW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Jan 2023 18:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235112AbjA2XpM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jan 2023 18:45:12 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22F51D934;
        Sun, 29 Jan 2023 15:45:10 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30T5NTeo017122;
        Sun, 29 Jan 2023 23:44:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=kB9mEZNwxh58CQvvF48mDe3zuRREcqGmFrb6cvb3Jtk=;
 b=BvSNqEaMwmuNSdkBydOu0T0pOOun71fXIZGWN7Rl1+QWFUnbP4lnum+Rx1C3chyOORBk
 JpCJADBS4bP2dKXwv6vdTL+gm92YY9PfEcHitnEe5s8iZbW84nAZNCyjQDqiRnK7BKIg
 6pib/Khcy6eHyoN77UcU1ZZzseYdq7553fBz5jNbe0M2mbihnMAIkrYxDPua01cdSao4
 Nh/0P2j7gT9WUMsAjmk6FqmGBKgC4nnqGhfZywKTGnB/ygcVGQC+2IzfGtk8RbuEOtVi
 8Jhc2HCOlRmw74Da00NNLOg17LIzJMdRGHerh7oY9oURaPcueKxgHEIPTlWvHNOawW1i xQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvqwss65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:44:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30TJ5qYF000798;
        Sun, 29 Jan 2023 23:44:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct53dr1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:44:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+BDf+Slapjp+vO3mhA2Eapdzg7PG9EmQRfHSynWiivJmZ664s2c9KwT8dr0dydfgfplBKlvW/8QIqHHNr54qs0ChCEvJcaHUmKRzelktWti8vH0R4xqb8gKjoU/nKyspQEoIItMRJVmnu+qiDR9d0et0LTXLN+2n7wl+OGr1QiBGtAh7jGem2i3enlQSNA2Vop7gOK9ubxOGvZ55VwrlkemQsP6GH9NVbXmyHj3vp2SS6ocO7TIPLF8bj9hb9ZseX7eoq1vLhk03TGkyYE8HZurH9HsoFg72M62hAd9xcItYCRW31WAkRh3waGGbB7Apab3ufSlvvJCyQmruZuTdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kB9mEZNwxh58CQvvF48mDe3zuRREcqGmFrb6cvb3Jtk=;
 b=b8UmAIWF+XCaNxJ/FJDgNB9xdOXmSdDRtg3Pk+ComcY6lxHC5F8vJixgHbTFiGuS31yLN5aR+k/so+OsLnJrfrjfckBdZRUar9rwGEb2CQ/zqYyxj2LaUy41R9H4ffbUrpoz1bEMtPzTGJelYfObyij+y4p247PgRxzBBgIOPpyef0I7jgHjjofu+6JNkUWIk+QA4ybuBmpGXRcb7quZ02tq1sV9dREqV9nrk6PZy8/wetzqEHIz2OSNuvI2cVz8rwIrdZhMIQx5E5LamSStKj8HqnYHaDUiTzRaiTPdPBTcE0F0EMWQdbhe4yF831dUykhCSJVNYP4+qQryqkUN6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kB9mEZNwxh58CQvvF48mDe3zuRREcqGmFrb6cvb3Jtk=;
 b=OtjqBfWd7hHTAD8G9+7k2svQTL6mmPv/N1odTUslFbLy1Eoq2YYROQlMEi+27FFZgB429dAB85A4m1+LD2ljY+Qo1Ijmzz24Scrz+iZKUfBRLJ8tNyTsqnQHRGPCUh7bnKg4i1TESjkHcp+IvN5mJZH1SZHXIwBSSM11h5f9Rx4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4649.namprd10.prod.outlook.com (2603:10b6:806:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Sun, 29 Jan
 2023 23:44:48 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 23:44:48 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 02/14] scsi: target: Move cmd counter allocation
Date:   Sun, 29 Jan 2023 17:44:29 -0600
Message-Id: <20230129234441.116310-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230129234441.116310-1-michael.christie@oracle.com>
References: <20230129234441.116310-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR06CA0004.namprd06.prod.outlook.com
 (2603:10b6:8:2a::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4649:EE_
X-MS-Office365-Filtering-Correlation-Id: 452f7033-18fd-4b8e-b3f8-08db0252ce18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: glKzpfT+ZJxetlJtQ7V+GOomoDn4QZVUt768LPBpz6YN697y4EVXKRKVAh0gzaNF+QBqGFKM4n/mCTgfE4PgKLwrOiX8h6Xq0jdUoT3a322+AbE2ZPX5DwmDkiy286VPJhq5SdAbDjHeDFCgt1ZPPXZrk7EKXnXXdYJ4JvdbKRVUl9SG2v/SGlOtv+260ExgRBZ80hhjMS30S+F4VHjH7W1dFXlPq7OfdVf/KxFxBo/5G7JjhNRKzgwAiGQN4cOrjS1yuj262lK8UoARM0TawDfrM6VBqvh+xK04g37HZEp8xK9wJCVHJF4/C1ZeQv9osj+N4LU94g9Mg6Gj/x1eNxw7yVtnfCsFwNGyrXhhVVIUWSWd+5t+l3+PF8mrCJCRh3ffTxHLMrpgyabOS6b0JIHiLSzeScsa77j+Tk+BEt4FvH3BH0Wknz5LnekTd12wNQa/AXnRBpn4EA6V5kcHTEqB5Pnf3MYzXt2JbRNliso3RZKu+aeykfzIP8Z/3IKa/n6qgokIOXC+F346xJoJ5e7/8N0rLduqQEQBRkFbfqkyCqHaqNcf2C2SPTDEDCW+VSvNmglN3saA1cGJSjM6TIvod83YTpGNf5Dndx+VdLZVBNNQ2LJZ8ixHm7rCPQIWQ2MFTJtm4wrYl07EiGWSdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199018)(316002)(5660300002)(8936002)(41300700001)(66476007)(8676002)(66946007)(66556008)(4326008)(2906002)(6486002)(478600001)(26005)(186003)(1076003)(6666004)(6506007)(107886003)(6512007)(2616005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LqyScY6dhgehh1OXGf4IX6UcROKtb/SnTtX2fd49V+Xow5F9iFrLK3n6XO+l?=
 =?us-ascii?Q?1NUeVBciycT7pqT9h8uKnf2HX3nCiv/IGaX9YtxM45ZY6jk5mADgpk2Us/Ow?=
 =?us-ascii?Q?XFJND+qMmQ/nFYa3y2DuzyHT8tR2Ssv0Oy+cIFq6/nM5CFcWhjmf3hsWsrC3?=
 =?us-ascii?Q?kSSVxvo8LG322R9DiWvxMqsUoWq6xKnUgisXx15wAoEma62GIuP4UZHSBM19?=
 =?us-ascii?Q?XN31hbdkgvm9wvCKchbI0a2DkJMYUByf8Ks0m3KAhFcHQVtu/96hDYWuyWYW?=
 =?us-ascii?Q?/eht5TE8m6VU+mddTyNszRLUsdOKqHSUZ8QbsUk0s/Xc5BuZ+WqTZHdK97xV?=
 =?us-ascii?Q?KFanWJlDBgGhdDfvAjf08oIyqyOPi1MI2Qo2uBi39YLIRua0sIx98/jvUK6w?=
 =?us-ascii?Q?swWemL1CcvQvBELkc/7kxEOKU3uuE1LRtI3z9SAySBSKGxQr7X2C2QnfjGoy?=
 =?us-ascii?Q?dbkmydrMBlN/6bDM9EGXJVs0ezWXQ3p/8S9C84S5O2DIjtgrwpIjX8zM3q14?=
 =?us-ascii?Q?UXvtu01aDwLy/Z7pGgvNtbEIZObOpht3WAYmY4fj1qTa+5qdeUWlBcxazvwd?=
 =?us-ascii?Q?GVy1ldzEDgTPbRFiTVKoFX7Zg65iEc1CW6Gjl1H9JWnEqWAb39t/WumLD3Ea?=
 =?us-ascii?Q?KfyCxQhTzc7byWQuOLlcjlRO574+kFuzVHYpMqFdAJu0Qjn2Sx/H0kDvYlzt?=
 =?us-ascii?Q?KmxRtiSkpEvVzUJglE7tUI34LKbdL4lZb8MCsW7/4YUVDzZwNlqCJkqm+EQn?=
 =?us-ascii?Q?kKNooKooSTMRXwSycUTLl/ED3nwTkKj1nU7kVUV8bg4AytBOAcIq2SQ2sNmt?=
 =?us-ascii?Q?htq/sJIlLVd4ct0KPDT43h5D6A18x9BfZdvnLQ9jFTq4VD2iUkA+qGnh9hji?=
 =?us-ascii?Q?QkaVJkjXWYEnIyrNcpl91iK7ckHZtEh/3ldqF9HDowuXzxvrmUeZaDUSYcm5?=
 =?us-ascii?Q?yvgiNnzSoZ7EBD44zbvO3izMgeyFM1xgMrDxRRm4QJbvPfN6DajLEECSuxHw?=
 =?us-ascii?Q?FT2s2nVgwj1LKEgRvucmGI5QcaTmieCOmND9kw39H1qcWcMXWnJq9b5HbnGb?=
 =?us-ascii?Q?/v+k5xdiGG8Ja1Fut9+947NNK0KWiOKJxIr6m2myQ/eF8Zb1rtobdD6nTe03?=
 =?us-ascii?Q?Caee5GQ6LHXpfhO4Eg+VRCNVKXklNkMpR7a14eU+I33ZyrNQz5LUGC4n7UP7?=
 =?us-ascii?Q?G/2m6MxxzZRPoqeYjt5UcRK9LA45cC4q9aS/q0eqT7WrHfjpmBzMxTl4XWt8?=
 =?us-ascii?Q?Qq7sfv+UUG4iGSJ5XDyJm17OuSzuQsoEwgY+JCi9PHzxIS0xSPzVddN+OB+j?=
 =?us-ascii?Q?/0s63XsiT6ffrak9JqGg9f+VzV9Krp0UpZyXGDmC+h2EEk/94i+LYgLNL8Zu?=
 =?us-ascii?Q?eDKKLSAvidWff92Gq9wJ7AN3e41GEWzu7U5NWN65R2doCrPXCcG4/+nGveq6?=
 =?us-ascii?Q?YzCQYrmW38CyCHiXNGibzcPX14IihFEquCAjU0ZWDDFbl1UnVPptMzCnC612?=
 =?us-ascii?Q?23PGB9jQuj1mZcL7ymwXG1tCSGNVMp2/nynfJ0pKpcTKZzuUTXoeY+FfYcSc?=
 =?us-ascii?Q?MXguov6CPTdovxByBRirGSCgyP0hT4EAmeNVCSqvLyYiSvYxeZwmgbnfG7VY?=
 =?us-ascii?Q?3A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: zidpI6Gu4geSVhmConxUFsVRdVyoF0QwgZUbHbu1AwRqcyOZwq1nCcM85P8wPpVmcP7gZORx33iBpfJd6svayuUJbvz3gS6IWQ+c4ZmrAjqwIBriBdXmfDri50P2qz4XTaJOHHsRuGx9vHcTWs3JchFjFSeScbTjcrqx3Pj0GirqbWO2bp07/5WjuwUOEmoAac1Qz3yWjJ0Fm49gO6O1R7qLK2O6gM4kM9L6EgcpEc0afv5NSFzAve/pacZfoFWbN74a7CezeN5rCblCACfafpRlinIU/26ecc1vOPQFmaXv0CbquRZmRvdiwAP+bs5lc0XkpagzR0cFzQSMUxZKKPvt+KAL+EVrjtolOx43eSHzZ+SMwHZZefz1MnVBUF7grDQaJZ4GChhhNsXzuva3dvZpzren/Id9BPkfIzCPP5IrdsesE4gOSAG2INylgXY44qMt6OthBnwzFNTQwUK1XDubXGomz5qOGN//UUW9Wifoo/yRxFBaKdfnIu9dKetNdgUWZZamCWJDJkJkPJQFMJNqbihg6Ixbo3D7vzPPJXLMSQps3g/bUn51kmJP0Jl8N4e13XqfBhvXHeu2TCap20xpyffGOYZDzh6z3/d5VRd7fk+RgIHgmAVs4H0AgI8q4oVKF0X6waWjvG9M75Hpy1FGqrmw7AeObI3UyfXJsjq+7dqVFDDSaQBnfw/ks3W9k81NZlmMn2nddoBCR2XNgJ69HsgdutfrhOZzzuIZAOHDDDsURsJmlzJo1crK3YqyhXJPiumirtuqYQPWu8Pq3VDNJln5VqA7DlEWCoCSOUpO5H4WJAiJwY78zHYvw0JiROfwEhrhtlJNwcoMcyivyhkYXapG5zLNPkkkmsvDoqozl1G0o+Npm5STTcLlTpKC
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 452f7033-18fd-4b8e-b3f8-08db0252ce18
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 23:44:47.2762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QIzp3EY8egtYvPJQweJBeXHtPyp30+Ix9zcHIF0u201NY0g+iR9N1cC0W7VgFbIFjD6Yaoe3QmREJUYmnAy18tGKGYGZZgXTnYaC5qZq5Gg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-29_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301290235
X-Proofpoint-ORIG-GUID: uI76MPv2laormRwIfKce5PdSj_ijZ6RB
X-Proofpoint-GUID: uI76MPv2laormRwIfKce5PdSj_ijZ6RB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iSCSI needs to allocate its cmd counter per connection for MCS support
where we need to stop and wait on commands running on a connection instead
of per session. This moves the cmd counter allocation to
target_setup_session which is used by drivers that need the stop+wait
behavior per session.

xcopy doesn't need stop+wait at all, so we will be ok moving the cmd
counter allocation outside of transport_init_session.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target_login.c | 10 +++++
 drivers/target/target_core_internal.h     |  1 -
 drivers/target/target_core_transport.c    | 55 +++++++++++------------
 drivers/target/target_core_xcopy.c        | 15 +------
 include/target/target_core_fabric.h       |  4 +-
 5 files changed, 42 insertions(+), 43 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 27e448c2d066..8ab6c0107d89 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -324,8 +324,18 @@ static int iscsi_login_zero_tsih_s1(
 		goto free_ops;
 	}
 
+	/*
+	 * This is temp for iser. It will be moved to per conn in later
+	 * patches for iscsi.
+	 */
+	sess->se_sess->cmd_cnt = target_alloc_cmd_counter();
+	if (!sess->se_sess->cmd_cnt)
+		goto free_se_sess;
+
 	return 0;
 
+free_se_sess:
+	transport_free_session(sess->se_sess);
 free_ops:
 	kfree(sess->sess_ops);
 free_id:
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 38a6d08f75b3..85e35cf582e5 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -138,7 +138,6 @@ int	init_se_kmem_caches(void);
 void	release_se_kmem_caches(void);
 u32	scsi_get_new_index(scsi_index_t);
 void	transport_subsystem_check_init(void);
-void	transport_uninit_session(struct se_session *);
 unsigned char *transport_dump_cmd_direction(struct se_cmd *);
 void	transport_dump_dev_state(struct se_device *, char *, int *);
 void	transport_dump_dev_info(struct se_device *, struct se_lun *,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3d6034f00dcd..60647a49a1d3 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -228,7 +228,7 @@ static void target_release_cmd_refcnt(struct percpu_ref *ref)
 	wake_up(&cmd_cnt->refcnt_wq);
 }
 
-static struct target_cmd_counter *target_alloc_cmd_counter(void)
+struct target_cmd_counter *target_alloc_cmd_counter(void)
 {
 	struct target_cmd_counter *cmd_cnt;
 	int rc;
@@ -252,6 +252,7 @@ static struct target_cmd_counter *target_alloc_cmd_counter(void)
 	kfree(cmd_cnt);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(target_alloc_cmd_counter);
 
 static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
 {
@@ -271,24 +272,14 @@ static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
  *
  * The caller must have zero-initialized @se_sess before calling this function.
  */
-int transport_init_session(struct se_session *se_sess)
+void transport_init_session(struct se_session *se_sess)
 {
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
-	se_sess->cmd_cnt = target_alloc_cmd_counter();
-	if (!se_sess->cmd_cnt)
-		return -ENOMEM;
-
-	return  0;
 }
 EXPORT_SYMBOL(transport_init_session);
 
-void transport_uninit_session(struct se_session *se_sess)
-{
-	target_free_cmd_counter(se_sess->cmd_cnt);
-}
-
 /**
  * transport_alloc_session - allocate a session object and initialize it
  * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
@@ -296,7 +287,6 @@ void transport_uninit_session(struct se_session *se_sess)
 struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 {
 	struct se_session *se_sess;
-	int ret;
 
 	se_sess = kmem_cache_zalloc(se_sess_cache, GFP_KERNEL);
 	if (!se_sess) {
@@ -304,11 +294,7 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	ret = transport_init_session(se_sess);
-	if (ret < 0) {
-		kmem_cache_free(se_sess_cache, se_sess);
-		return ERR_PTR(ret);
-	}
+	transport_init_session(se_sess);
 	se_sess->sup_prot_ops = sup_prot_ops;
 
 	return se_sess;
@@ -474,8 +460,13 @@ target_setup_session(struct se_portal_group *tpg,
 		     int (*callback)(struct se_portal_group *,
 				     struct se_session *, void *))
 {
+	struct target_cmd_counter *cmd_cnt;
 	struct se_session *sess;
+	int rc;
 
+	cmd_cnt = target_alloc_cmd_counter();
+	if (!cmd_cnt)
+		return ERR_PTR(-ENOMEM);
 	/*
 	 * If the fabric driver is using percpu-ida based pre allocation
 	 * of I/O descriptor tags, go ahead and perform that setup now..
@@ -485,29 +476,36 @@ target_setup_session(struct se_portal_group *tpg,
 	else
 		sess = transport_alloc_session(prot_op);
 
-	if (IS_ERR(sess))
-		return sess;
+	if (IS_ERR(sess)) {
+		rc = PTR_ERR(sess);
+		goto free_cnt;
+	}
+	sess->cmd_cnt = cmd_cnt;
 
 	sess->se_node_acl = core_tpg_check_initiator_node_acl(tpg,
 					(unsigned char *)initiatorname);
 	if (!sess->se_node_acl) {
-		transport_free_session(sess);
-		return ERR_PTR(-EACCES);
+		rc = -EACCES;
+		goto free_sess;
 	}
 	/*
 	 * Go ahead and perform any remaining fabric setup that is
 	 * required before transport_register_session().
 	 */
 	if (callback != NULL) {
-		int rc = callback(tpg, sess, private);
-		if (rc) {
-			transport_free_session(sess);
-			return ERR_PTR(rc);
-		}
+		rc = callback(tpg, sess, private);
+		if (rc)
+			goto free_sess;
 	}
 
 	transport_register_session(tpg, sess->se_node_acl, sess, private);
 	return sess;
+
+free_sess:
+	transport_free_session(sess);
+free_cnt:
+	target_free_cmd_counter(cmd_cnt);
+	return ERR_PTR(rc);
 }
 EXPORT_SYMBOL(target_setup_session);
 
@@ -632,7 +630,8 @@ void transport_free_session(struct se_session *se_sess)
 		sbitmap_queue_free(&se_sess->sess_tag_pool);
 		kvfree(se_sess->sess_cmd_map);
 	}
-	transport_uninit_session(se_sess);
+	if (se_sess->cmd_cnt)
+		target_free_cmd_counter(se_sess->cmd_cnt);
 	kmem_cache_free(se_sess_cache, se_sess);
 }
 EXPORT_SYMBOL(transport_free_session);
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 49eaee022ef1..49a83500c8b7 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -461,8 +461,6 @@ static const struct target_core_fabric_ops xcopy_pt_tfo = {
 
 int target_xcopy_setup_pt(void)
 {
-	int ret;
-
 	xcopy_wq = alloc_workqueue("xcopy_wq", WQ_MEM_RECLAIM, 0);
 	if (!xcopy_wq) {
 		pr_err("Unable to allocate xcopy_wq\n");
@@ -479,9 +477,7 @@ int target_xcopy_setup_pt(void)
 	INIT_LIST_HEAD(&xcopy_pt_nacl.acl_list);
 	INIT_LIST_HEAD(&xcopy_pt_nacl.acl_sess_list);
 	memset(&xcopy_pt_sess, 0, sizeof(struct se_session));
-	ret = transport_init_session(&xcopy_pt_sess);
-	if (ret < 0)
-		goto destroy_wq;
+	transport_init_session(&xcopy_pt_sess);
 
 	xcopy_pt_nacl.se_tpg = &xcopy_pt_tpg;
 	xcopy_pt_nacl.nacl_sess = &xcopy_pt_sess;
@@ -490,19 +486,12 @@ int target_xcopy_setup_pt(void)
 	xcopy_pt_sess.se_node_acl = &xcopy_pt_nacl;
 
 	return 0;
-
-destroy_wq:
-	destroy_workqueue(xcopy_wq);
-	xcopy_wq = NULL;
-	return ret;
 }
 
 void target_xcopy_release_pt(void)
 {
-	if (xcopy_wq) {
+	if (xcopy_wq)
 		destroy_workqueue(xcopy_wq);
-		transport_uninit_session(&xcopy_pt_sess);
-	}
 }
 
 /*
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 38f0662476d1..65527174b8bc 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -133,7 +133,9 @@ struct se_session *target_setup_session(struct se_portal_group *,
 				struct se_session *, void *));
 void target_remove_session(struct se_session *);
 
-int transport_init_session(struct se_session *se_sess);
+struct target_cmd_counter *target_alloc_cmd_counter(void);
+
+void transport_init_session(struct se_session *se_sess);
 struct se_session *transport_alloc_session(enum target_prot_op);
 int transport_alloc_session_tags(struct se_session *, unsigned int,
 		unsigned int);
-- 
2.25.1

