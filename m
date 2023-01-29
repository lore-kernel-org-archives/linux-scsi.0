Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E653C61DA4
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Jan 2023 23:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbjA2XpX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Jan 2023 18:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbjA2XpS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jan 2023 18:45:18 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435441DB8C;
        Sun, 29 Jan 2023 15:45:17 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30TKxIXT010697;
        Sun, 29 Jan 2023 23:44:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=IHmSFhWT26lGahQ6EeIg0QpHBXD3wY2GF4yhxmDprnk=;
 b=A36UQ+B68iT1pUezj0zpa2sQN4qpr/v7yrjSlSkuY1Csk6sg20IXsRYtp4AMYxmg8HAf
 pgBg7jZYlPdYdIqyJ9wvCwA6HvoGB5lK/xdX/MQqac+1G9CVSp4PzcpSUjAJkviA5t5O
 hbKCUn7L195sYURmXKV9mLqkzTJ0utUwquv+nQWHjekMJFkJXHloV8BdyfKp3HJ0yH4x
 BvKke8g8jXco/Lp8XDhnxE0oVjst646V/aOlXST9IbuVilk4FLkeexlUBzMa9YtCH9ai
 JAhpH93Kh1H5VHDFc24z3rAiBgfp2rH/Lq7X7QYNEkA/Nv3vYFDW27r8fsh2xDK6+VPP 6w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvn9srpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:44:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30TJ5qYG000798;
        Sun, 29 Jan 2023 23:44:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct53dr1t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:44:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hj0feAN4XhEqjxM6eBWt9nwwWymp5bgLe55NNqGTvOp5TmcdXIf5j08gCJXvmhdmV86LSSTlfjC/y5iveBESCNRBv0pJ4wI3M4fxQySD/S5ETM4pT8ZTsL9+eaL74tl9uFghU/O9+b2zSO0E7OgogRSuqQogBWQ2x1oXuYiZq4uMRyd6ZZ2jxzFV946wC2bdvzPgsqggx8VUI1x8Ze5dBuIth7yPApkBeUDY16snCDO7dmmH61i48Jhv6pVVuZ6WQZgyyHhGoOhqn4ksC9saEYkpOAYKREDM6u5ea/74zOyBtZLeGMji24dumMKQjjCsvuKoRWC0qSN258jyLKYgTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IHmSFhWT26lGahQ6EeIg0QpHBXD3wY2GF4yhxmDprnk=;
 b=A+vDNWxHawUt2y9v/efnvWsaNffOz14Fs2ALG7fzv7Qq76uWOrVOTwSl/hg/2NSR3JqyEqIPiTvyIpBLlqSCUB6t81JHbBO9zGj+GP3jQ2hil3JpW6NJZ8h8VJpgZB9jElywdnXmuwPl9AD7EBGn26v6q8Ozu+L4fUED7IadCoLOC3ToNneef0FHDJYqzAVDecoARNDs1IUHhwC0y7LzG8BzItJBd0kBF8Ydj+rDb94L1I0vFQsaO2SFZZobp7Wk2w/+zuVy43WVxxwKo3qf1HPYP5wDDPPe8R9gakslGhJ9nuMb228q+2TZHiAQgTiQ+tNkIlcy080ZLJmnbAHgig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHmSFhWT26lGahQ6EeIg0QpHBXD3wY2GF4yhxmDprnk=;
 b=kwm9HzghIpIFTrfLRnNeVtmkawtMfWwK8ancDOBTwwj4ARIIu7J19o7/8kXBDsL+5vrtPeZqHaepf9nQXoovxAfNxkEM1ZyRGC/GmSYaJLt8jcHQIHHkq431Nmp8eJecPZimbZq+pB4oQ2xERsbHwjN09Jo6i5RMAOe50vwW1Jc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4649.namprd10.prod.outlook.com (2603:10b6:806:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Sun, 29 Jan
 2023 23:44:53 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 23:44:53 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 06/14] scsi: target: iscsit: Fix TAS handling during conn cleanup
Date:   Sun, 29 Jan 2023 17:44:33 -0600
Message-Id: <20230129234441.116310-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230129234441.116310-1-michael.christie@oracle.com>
References: <20230129234441.116310-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0068.namprd05.prod.outlook.com
 (2603:10b6:8:57::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4649:EE_
X-MS-Office365-Filtering-Correlation-Id: df9a8f2b-62a6-4108-b4dd-08db0252d177
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SE0Kp836EefNhYlgf7phCTaOytjGAZAJwIlOFG+ngEb4bPd15GW0fJRtvEqn9YrCd7Dza7Ly7APGiqWksAUIwrhhUokD6RaGNuFyaatFqcKX9y+a3nIdhx2uIokKPXVSy19qKXtCvAssTml8ruX8WemHXVZn8+Wb4HashTn0BB6mE5ORHaWJqD2KWWusPtJillKxFrjrzqsNMYpJ43HogAHDtAMgc1Cdi8rIF4Fl/KYmDt5NmBo0BoBKgxMQ6/xZNLoO7RgieAeBZrN+8/TI8EDY88fA/x+j16NBmI54NXplVudDFtdztu/6mUT6vsqt8F31CfdiEmMRdrS2xi2CqutvuysEyZQF/To+lcGc4/Q+iaa33/daBHJ0zVok7yg0/PJk88JJJR1NJw+Sf2SwvlS/zqQuFDR8JpJeXU8jTxmgTMTB3P35cw9m9wJWQkWP/o7F5TKTGDJEe61QxY1rETBAFNrp9U2Q6+Z6+JXdIBUlpYgbEYE9Jr8+L98hmtx49sAR4pN4mLImJAWSVwQAUhvrj8dleJgPKUhag/52hlljlyr6ImhcvaFjmUSArbYsbZ8UMugpjHPT3tSMndGskf0RHsbPeAfZ1iUt4tjGtJU5MOfViNbmHqtfBRiFUPNCRgI+gS7/uzIyuDzYUG1D4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199018)(316002)(5660300002)(8936002)(41300700001)(66476007)(8676002)(66946007)(66556008)(4326008)(2906002)(6486002)(478600001)(26005)(186003)(1076003)(6666004)(6506007)(107886003)(6512007)(2616005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?STOuZ9CXbadC88BFXWVlv+rVi+B8kc/vRh4URUwpImbPbink5wbsu5+AodxA?=
 =?us-ascii?Q?v/7WkevKV6BeHV1a54L3CQImRH4yLeBRplm++2JN0UhVRNk1ziyqTsOuY5VB?=
 =?us-ascii?Q?jNQt9UQfbBgpasxNB7vVhs0oZy3b+7BEnsr51ghinN1+pXTGrT1aMVIKQ/xa?=
 =?us-ascii?Q?Rn7g4GvVOO4fUFhP62/Ac6+wTC8jVboKBAcNC0Mt92DQYEH39sL1/Nd+nJN7?=
 =?us-ascii?Q?1+vElTVQx3X/56DSWAKGuXRRQ7gyD2e+WMdHJvvUakWeDe0x7UO/c4149MKD?=
 =?us-ascii?Q?k8spM+GMS00yq7SRpyiNi3FdbMjPFlRibS6sXzbOQgA276cXwc70hGXYWRc2?=
 =?us-ascii?Q?w8ZWM5xwrVUDZtzewMRgi1cdduxA1XmZdMGb3TojgYseYpoDlDI2BAuHC7j9?=
 =?us-ascii?Q?SjyfZfKvCbC5tWv1ceeAxfeVu2ZcZAs2CbI7+UL2A7S4P59YLtJgjwxunl4i?=
 =?us-ascii?Q?3JwNmP+D3NkiOuJOEHwZz+2Q0tVXC2B5LSDuQ7hVCDYTGzTozq3PWFN3XFEZ?=
 =?us-ascii?Q?7GUu9qTO8/fQAqgJ/YS+5bz8LjNLZyvDwCH1eukVryu2ceWHh1qdqqXD6WOg?=
 =?us-ascii?Q?p2HBBUvKZebDfF2UFffkbsY1EXFVPNVOztrKuNZU0FScIArXNCA0F2mSMlmu?=
 =?us-ascii?Q?dO5vHuE+cM00eDoyvzDZomt+mhVVzQQDcIioCAkOFrjqT/4rHvb5latbKc/q?=
 =?us-ascii?Q?gWNbfweb9S/jTE+tmzxuuAx458hBIBXekwfoSAM3eE6/5D9RO5l8gi3YepZb?=
 =?us-ascii?Q?bRT/znCT3Ct6h++UzXMSfSFgPsGPmuOJ4wCZGLF2vzbQavvzrWIITwiAvLtm?=
 =?us-ascii?Q?9epG9+to8i05rg/5iX9zLcemtTKxlU1Le67GrBLk12JJxHBIQxEcHytltJ+N?=
 =?us-ascii?Q?6hAUbQFTOw6zE9M5BuOx+BRgfEljQvkXI3yGT5yObkCXne76poIonFqXih4j?=
 =?us-ascii?Q?OppGeH9Wm4Ma5u2zFGvqMihRNhys0OdBphStosiMOUkqjWf3pyul5epObADl?=
 =?us-ascii?Q?rtSiXAXq6mU8GWhCSNscyt5ztRqUKOHZ4K1fo/qsHQ7ObdtJxRRGs/Yymzpa?=
 =?us-ascii?Q?jK1cdNOAH9C5wge3l0netKcWP2bX4XTRdha3RVjzXnbgY712ZVQBfDhKGpvV?=
 =?us-ascii?Q?a0FeQ0+KZQYyyM5HhuiaHLrAy91eY7vW8sl9kxckJWgrxSgIVjTQpKEcM9Ft?=
 =?us-ascii?Q?tm+Ob9t44Q9t4TAlv20juRkiPdpTfuyMUYDev/hCNAbjAInzYKNfaHBdkcik?=
 =?us-ascii?Q?m1N3DFbsT4oCS0oAHmG0y6t7DsyMb1XDkfIqpQCwTbqnjfW9TFlO/LSw6SJg?=
 =?us-ascii?Q?QVMqFsmJ8NtcfOGUBL34V1isj+NZ5xqlkR32i715JeWnafXekdA7JMyIDSPA?=
 =?us-ascii?Q?hL1qYO5EgcRKJlAK0n+QCUbvaVnWwhLuMeAUzpljQuPR4c89L75GjXhqkfwi?=
 =?us-ascii?Q?xt2ouItGfaj0eDsg/IcdMA/Tr0+T6K55R+mPb4+tSO5SPo47oWJBaaA1YlNp?=
 =?us-ascii?Q?WfootQTBUqUFy0odVPy39PbD1MSfNpeaJ/ocgnpvWKWre1lxojDGHUdFhQ0C?=
 =?us-ascii?Q?coOtSn5DH5aY0M60T2ulgjtK2r+Abib9EX6Xtz6h7ypjSPa3Dd1VqjyRUIZD?=
 =?us-ascii?Q?yQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bbx2LwaawxSUVmXOYD2CSiuR+qM56oz/aTdhyHVj5DNJAc7UOB4MQtZOSWlInRFYt+CqHdyrdYaq7RdcD0ms7WU0IwJrNzC87J3uoUU7ra+VpBwwsygM10nTPXOnx7/QZhGAFxHisufXfW7qXgRjaiMORJ2I7v+kuoSGXDCUdS6V2zsqw4ELBSLJUJLvCKMUwUdTZ/qoPF2uCn2qGtIwVz9w0EFNmmTu+BKJBW1SH1U7BvKbjZ545yhIlico7nZZXUq/XDfcvYQ1UatRHHCTAm13LvtNYcJant/Dgsrx2FVpsQ+Kbm+rleOkyvLc5OKyuysQehNFxsnU1O6kBshR6mgGbQS6ZzNRi5t2eWk8o4QKGj9dJzCoekkd47J2hJ+h+4kzIbahVMPE52kIQww2th6zYTKZ25gRXOqkOgZ/CV9mEFzaylrCfb2ym7wUEoAXnPXdDpRzGWM3QXktIFAPZS9K0Vt4wLpDGpSxS3OSMOFh4BM6B2/XgA/f+yiggM/1BX/End2EaIlhAM4xTwArogbmyHwQneIBre5Sulf7Q9Hc8uJmZwd5J0fEH9HRF7r6hyZm3XL5hq3LIiH5paCUE5/t3SUkqvgFVlKnz8NCN9CB5YDx6F2UfaKFGoTWZ8rRMlDB0Nf+fFy2nmncuYE1nXCJ+y2pnEAMGubfi3YmgZTFb5yDWbSGN3s2fZ0pxQh8xyT0fw7VcFkkGblB4+0QHT/RTLbAp814U/07iMfSwxFww5Okqpr3eEKZ02b1NH7L81c8k8ZJEv8yFZLGLcmHtXprUdC62jugttsvLJTeqjMdQf7lFOgN8ywGtb2O+HN1PfjNNTx+NGcE2m3oJzwPmORp95386lxVfzdRfvVQ0WRa+fbjgBotuUkF/kx//W5J
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df9a8f2b-62a6-4108-b4dd-08db0252d177
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 23:44:52.9320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mmS6wDNq87qV1E1r8eFAZ67Y58sEdYKNoTuysAUfyiIstaGLGitNeOsseP6xN63M7pM2A4dtJD9sRuLv5JzkcYRvrZBajJ+K/WoU8FqO/b8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-29_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301290235
X-Proofpoint-GUID: 2TZAFASSOTbenvut17pbfHtJibWmCXVW
X-Proofpoint-ORIG-GUID: 2TZAFASSOTbenvut17pbfHtJibWmCXVW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes a bug added in:

commit f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop
race")

If CMD_T_TAS is set on the se_cmd we must call iscsit_free_cmd to do the
last put on the cmd and free it, because the connection is down and we
will not up sending the response and doing the put from the normal IO
path. This patch adds a check for CMD_T_TAS in
iscsit_release_commands_from_conn so we now detect this case.

Fixes: f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop race")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 83b007141229..2a011afa6dff 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4222,7 +4222,8 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 
 		if (se_cmd->se_tfo != NULL) {
 			spin_lock_irq(&se_cmd->t_state_lock);
-			if (se_cmd->transport_state & CMD_T_ABORTED) {
+			if (se_cmd->transport_state & CMD_T_ABORTED &&
+			    !(se_cmd->transport_state & CMD_T_TAS)) {
 				/*
 				 * LIO's abort path owns the cleanup for this,
 				 * so put it back on the list and let
-- 
2.25.1

