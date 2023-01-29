Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26300C05027
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Jan 2023 23:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbjA2Xpp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Jan 2023 18:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235183AbjA2Xpm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jan 2023 18:45:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C001DBA9;
        Sun, 29 Jan 2023 15:45:35 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30TMfCvf012753;
        Sun, 29 Jan 2023 23:45:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=dN5rUiI2Jyg2D+WUbI2gb+szxiEqyKQf20sYbe9oGA0=;
 b=KxbO3SvIjdfuKNRGEvbq/5t1hXwVpwGJomJkOlUZmrzMh1UdT1nyzX0ed7/dt9Pbw1uq
 S2TznbSCc9+BEDko6M4vJ8Rt2KuP/1qLwsPwvkyYBMYabxhrjUE1YDgHdctzss6+jRHA
 rwbYYEQ9LewFJhVBpfhULKqVcJ9jTqC3dBKIAY88s1O7m1ZImN2cHf/1SfbnGtXeAgaG
 Du1YNiN3T2TSnEGrb5ToVTS/jmgABDxLcM56uG8NuwEtIEuFp04O0cu7jZPiWU/NqBWV
 bqp7842/Ez1TLcwz1YHT6w/vpLcK2jbqPAHXzl9BezboisiJ99J547SkAV2Fl+IikKFW lQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvr8hryb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:45:29 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30TJ5KKf037694;
        Sun, 29 Jan 2023 23:45:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nct5a5pb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:45:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RvRVA3JP8Y/rIx0b5X0JUv8+Hh8yj4iCoLBBf6LgOqSPKStEIqreTol8J6sLlvXKdHVEZ0KwUm5zzmvtJul2GJ9K5OMjlmmHhbFiv8vhs0YsrvkWIz6rIPfe7/N2Sbt0Vtn97QzG8pLfVHgMTsDd5x7omXIBICTKH/fteDPXAitXpV/ez+t5G9rPk1t7Wt5NZ0yEBnaW7D8g9790fKExh132jDoPp5LnS6qlVnJZZT62azqsNEfIa5ZqCPLNWOoWoddjHULWVSG5ZW8g12O+vFvGHN0DOf2VTUd8csPwHULQnsU4M9Z8AbsI6AQ5JVQpf+DdFGNjA4y/091GnM55TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dN5rUiI2Jyg2D+WUbI2gb+szxiEqyKQf20sYbe9oGA0=;
 b=hBNYDfsktfVgN28mx5mMkDHCkCSTFaXnYCq8K47zwPEP6NttA71VBFkNS8EiKQXT3FXRQ4Hki56O/tNLHc3Jo0mpYLcRgd7jlRzSDpClZirIXuh6oalYiGf/gg3zO/UCuf/ykcW+7vegOqysythbe4JCumYN+LIG1DZd3nPoUi/kzW0ufkp+DGDkCrsPd7xUzv6F+egdN4FqtIJhWxVkQ7m2z3MxfKICsml5cac/81RUD40z+B19kPYLjWYWLB4VbnY+iF9Ar6onRcBE3P4is67sX7013WbcfjxRk4aj5hvDn+sOM+Pr+O00+fJP/NDLL4O3c6gpos9uAvAIZOlLiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dN5rUiI2Jyg2D+WUbI2gb+szxiEqyKQf20sYbe9oGA0=;
 b=H0C+rJMKR9k/O/6TxnMqBr3J64KvpkH3G0oEQJ7QDM3W7+CzVtk9YJkt6ygIr+TuPmGf0pnHW417ym0Q7p+aRGL115A8DwxUUV+MMh6cQhe1m7+1PlD+6fFzm2X16NYZzP6PUspyJAiuicSZi8fM106zgYlkENFTmKizGPeP+Tc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4649.namprd10.prod.outlook.com (2603:10b6:806:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Sun, 29 Jan
 2023 23:45:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 23:45:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 10/14] scsi: target: iscsit: Add helper to check when cmd has failed
Date:   Sun, 29 Jan 2023 17:44:37 -0600
Message-Id: <20230129234441.116310-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230129234441.116310-1-michael.christie@oracle.com>
References: <20230129234441.116310-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0056.namprd07.prod.outlook.com
 (2603:10b6:4:ad::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4649:EE_
X-MS-Office365-Filtering-Correlation-Id: 8399e17f-2674-4b66-fb8e-08db0252e54f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W+9yQED7zo1IZUyVp00lWGk2w/90NEoXIQw957awYntgRKRieIvSfHevkw+Tieku2b2m3iCLmjTQtljjXGegyiTG0BRo85B8FnYZeL7lJfSHkDNeKqP273XYTDIYFwQ7TSlk5INVJnbAxaVYHrQdDfiueILVgKUmQYcn9zQ953pEjoQhtDehhB+WoPnCsY6o+5psNmwJvSKfiXaqVBr0mV4rBJapFEv8EHWRPkdG6LvONj1QtRHvafNiRyQBCtIUymhHAN357lHpRUSu4e+dm3A6Dus5mOo1A3HdMRGghJXg8uzcO4N5hMdPwm55j4yJh61nMJUiZ0TPqAU2tEsa5O1Jm6uxBRSQLXEWSiDP7D6nIoG4Y9UIMAAKSLI8pDRzuYbFUvu1yTvI+wsNK9ocnZ/P82dP7ieWq5txanYEVlUTMPH6xLHroSONCifh+h48PjeHxqAP0dFSROqSn9b+RKOe88vhyqyDATdfqtwg+qnbxvUzDLdYz0YkR55tApYcRl9PgNngi7e+D0wtFMEacAmfyo98ffZ7RxuhClFkNAHM4ivRLT1t3nj9QdaLQ6YyC2au8s5RDhU9WPpWBBtPikvJ2UO6wFlw2wUIxhT/BtDAfa0eYrgH5DfVkn0AlqbC1lw9MkDeajT9q2/f4X2V6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199018)(316002)(5660300002)(8936002)(41300700001)(66476007)(8676002)(66946007)(66556008)(4326008)(2906002)(6486002)(478600001)(26005)(186003)(1076003)(6666004)(6506007)(107886003)(6512007)(2616005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YoPkS/Pd05afbdv0DMFfV8mbh7QCWLN/8NfwhiAKpcYzAV2XLlpzn8nPKBhM?=
 =?us-ascii?Q?Zh8is2I7tvHJ4sM0tNiWBWqJAMWA/uyt4GzpmESmFU5TgbXxV7eQzjwYRbwG?=
 =?us-ascii?Q?uemWSa1Dy/+OB23ETQ/OKtY5TAxStFup37jTdjyn7QYnRfrqczhZNkrbXqBI?=
 =?us-ascii?Q?Ni2xLSSgEtnToouerrb4ABg2SnFKkwNCatCcORBKEWVjHDujQhD7ZBAopH/p?=
 =?us-ascii?Q?HmHzFaSl7rLc6dwbkhAo8e7CLGE9U8s5V1iE09qsbnmCTq/bXf0gjGwavScs?=
 =?us-ascii?Q?KJ3UM9DLnpAeDIkYzFbAS5YmhCxQRrv8QwVkGDwUi0RoWw6NjgNDEQkycQ43?=
 =?us-ascii?Q?9n0mjfm8IdN5/QAWF7k3Bw9aQvW+7dttoUIYFkv1wYEYd47wdjeQRzcYvOsL?=
 =?us-ascii?Q?yPgyms1sAHL0zvWboqSRkkzxw8RjafYjlx/b7I3bHActdlFsjI6ecOibP6fG?=
 =?us-ascii?Q?lWrJbD4dBXl4sfhIDfUhTX4S9W66BlFN21BqkIQeznINuC6hwd+gJsUK1eeu?=
 =?us-ascii?Q?PDwiHrWtZsiKf+jp6e0kehugdTvFLJ8O2t2t9Bc2pecuhaoCZOEnNCmAtCc9?=
 =?us-ascii?Q?x422K2iaEBn7TOfLgF0O5RdV7OBR7PZHcVWA1tnX5FqD+GPgU/shRIuCh/w1?=
 =?us-ascii?Q?/yXS0aUgyG2Bx+IehpTd1xHe9Gr/BAaIB7KFmJYILIW3/ziNAQZn/tXKDQok?=
 =?us-ascii?Q?0zE+tR/z7JoFl7MDZeVveHdWXUUt5WRyUuvTaKW1p/eSdKE5E7BwQ3vC0ReB?=
 =?us-ascii?Q?sEiZBBXT6SPDoqFo9TidI21Ix/SWb2LYefCG0A0Pmvnaohu54dM4GYHkrEEH?=
 =?us-ascii?Q?GS9saOCXF5xnGdhqdzRc4b6QmNgv3hni+p6o38jmYjAzZwTLPYS3ZO8I40cQ?=
 =?us-ascii?Q?PH0A66zVeJCCrS5M/oduT7u9RH60sTYSg4/GgZ/Vopaiqj4qin1rXE/Hg2Lt?=
 =?us-ascii?Q?jhvlU+7wMmoYPnxUAHcARlp7UGaGEyFeS+ZfoUGbedO3rvkFOi5qsnSgAmrF?=
 =?us-ascii?Q?pI0eRj5/2bK5b39kcmC3aNohVUDdaZW23LIB0wBJ46eQXpn5do44OP9uFDoB?=
 =?us-ascii?Q?lFEV2FyJhcNg3pp8oBGN1Gsjn/62DYWhrYQr6xKLrMTbBWE/fm8nfkUUTx8X?=
 =?us-ascii?Q?p8TrQsINWyHhTcE4eMEpF5iUgRQwV48Q1/NDQSCObetI4gusVd6HUMGtXWuU?=
 =?us-ascii?Q?LKIfN5GuXX8oijFzF5gWd8CSlWdZFyXTii5n1wvD5qgoRmi6OZcHEfB7y5km?=
 =?us-ascii?Q?ZXYCSMsLlgXtn2BxNDazfbLjYpbDoqitad2TpEbyZ+z5I8135bUIyIWzghgv?=
 =?us-ascii?Q?1X0cSrcvnRy891fT+LENsN8FcSgIPXEgVXuXcIwXM3m/V8jv0pgre11sGTnw?=
 =?us-ascii?Q?LHdR4drK9gVRkndCgn8pY61w6wn0SqpKSae4SakziWR56xyfUOJLDWe6FQJJ?=
 =?us-ascii?Q?GDAK9Iq1Wb23WA58osxqFArsVBXoKMVEY/cdt6g20GB/Pq0hCbZQUmCkYfmo?=
 =?us-ascii?Q?2oJsFRpvj5O5sxXkyLP1wGK42Sl1c9uoBJ26dmBfbJXY49H4yUNrDDH2o4Ht?=
 =?us-ascii?Q?KHGXGnEw4oKuYNGRkR96b/jHnV29RyV0zn3ttcTDgGEAJYVzNrtZ++xyeuRr?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Oe5tnetO0xhJ4+RGJbcMZmYhtD1oX1r30+TCh/KL+LXQwctNSnAjW8iZTXR6YvP0u/dho077rP8lQ+j4/T2jJDxL79e9iMgusDFYl92gNW7DJOKnaMB+ae33uRCa/qAOx2im4UbNCvceg8X7dyp8TG6dqmhgiOB14BeXiM3C+/4ePk21oh2CZ3Umm3h9B258tRC2VCM1aLtn81fKK8/nAgQZ9taonr8S+T/0ipSMBgFLS09xro/PVhSqOj7CuyrexqQhTfhP1HjkzkMMBSD0kDC1ajkqnQzMI+b0yrTZ5uIRPi5NS3pZ1aVAS+PkYXlvNEWD4rIjmucQAONyJ1M/qtJ5p1Yvtb1M8ufzbHZocBjvq3rxh/tfooL0Ksl6/8d/szRFh/FI/Ei9JEdv2DYndHFCrVqNq6Egxo8atCfB2Iqd8XCkI1mhHIMspRfe7mqJkFY++q1wd8dwuUFLTMWQQHji7F/+Zfa455UbnY+FXjkxfS+ZC5YHJ+tKADNMvTQ88pV0lqXtQubzci+9HI/3A+NVnl+iV0+Hrj/8rIFaTiSGyqQuKloHCTcrLNbCNHowV6uMzXqCP5eupP4YEwiI4AQZiQQeZHlTPy2S/VUv4in/gEWo2ie7VvPUgX9aG5YW79UVeyCe2UlYt8gTTDF5LxCGIW+NgXdJo6nqoARHHSWDo2Q2rJUsxObPn9Xi5CN8t3q6W0iep82cVqjZKmzirC8j87U5yIveI1+D2jJEIOkWnfWMWel1Uk9taP81r/6cbI0K49eogbjYDm8nBUjwnG58Poa+xUGMWqyJVFOjEVMl3s/A+OmN0YheYC07xqXx1Lb4rozjLjCliojK6je36GSkxZNB1Ff+2tnHfOMXlzZpkItLb+SHL9nZ1wbRTAFR
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8399e17f-2674-4b66-fb8e-08db0252e54f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 23:45:26.1948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nSINoc55aMHwOpPgV7orPNTUwpK/cmNlGdqaZSlcjCS3smALAVUr1U1M8YDfQkRpW2mTHgC4giEiCcwWZMjzUrfdU+Geivvd6Ic7HC9E3Is=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-29_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301290235
X-Proofpoint-GUID: E9EPn2ksmtFHyfTjNGLkZbQ4qnJtL4wG
X-Proofpoint-ORIG-GUID: E9EPn2ksmtFHyfTjNGLkZbQ4qnJtL4wG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This moves the check in lio_queue_status to new helper so other code can
use it to check for commands that were failed by lio core or iscsit.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 3 +--
 include/target/iscsi/iscsi_target_core.h     | 5 +++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 5d0f51822414..82c1d335c369 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1411,9 +1411,8 @@ static int lio_queue_status(struct se_cmd *se_cmd)
 
 	cmd->i_state = ISTATE_SEND_STATUS;
 
-	if (cmd->se_cmd.scsi_status || cmd->sense_reason) {
+	if (iscsit_cmd_failed(cmd))
 		return iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
-	}
 	return conn->conn_transport->iscsit_queue_status(conn, cmd);
 }
 
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 229118156a1f..938dee8b7a51 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -913,6 +913,11 @@ static inline u32 session_get_next_ttt(struct iscsit_session *session)
 	return ttt;
 }
 
+static inline bool iscsit_cmd_failed(struct iscsit_cmd *cmd)
+{
+	return cmd->se_cmd.scsi_status || cmd->sense_reason;
+}
+
 extern struct iscsit_cmd *iscsit_find_cmd_from_itt(struct iscsit_conn *, itt_t);
 
 extern void iscsit_thread_check_cpumask(struct iscsit_conn *conn,
-- 
2.25.1

