Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08197C25B0D
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Aug 2022 03:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiHJDmY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 23:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbiHJDmQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 23:42:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF85D72ED1
        for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2022 20:42:15 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0E0iP020982;
        Wed, 10 Aug 2022 03:42:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=/Xf8/cKA6vArGcZuHUkek+fKsIFfm0tHR2Eh0qreAng=;
 b=beB0CIYcPNRD0/Pj54eTAcCH9Db8yxv+qvHM91KNTXYI80fZXFI2RwNN15TdrF57Mbcw
 lXehPszFd/s8YDId3tHLTgSJqKLX9kzZ9RHCETVW6BzKywjCdE8416U1SArRTdRzPxxt
 5o3cKcSyKu1nYSG2PAT/KIRRRDyuXpFGgu0BMkE2FoubDtKH98WfyD1ChauxzilAU68K
 xOQWz6lxTCXC/L9Mjf6OmfnsriqpdX2/K1t8tcJd4INC+tvQ8XDBtke5aZ26OTiLlSqp
 xxBbRYOG0sfw4mE69sHS5KX97X2OduLAHKSXM9VmnHEZA2oT4kA+ClQhAn7KCrfI5sQ9 mA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwq9gq2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:42:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 279NkcOg038712;
        Wed, 10 Aug 2022 03:42:03 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqh90df-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:42:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJl7esUz0eaO19PCZYxVyPJiPCyKEBTnjeBzTyaBV8iYGGm/sQNWxXaTWuxTPUWCNbj2e9avEB3EDsZj2tDa7NCUhbNgf1MBxgkF+LULvbBLtvONNNnkRqXKgqfcvhaOnU1s0ACNdY/9BZxi34NVcMeNYVjOUQGrGCeGqpTX4rBVGEJ7DFW/EF0AxbXUuZbFpppsrmcjYJUDL3oSNhSZKLoTZHiZPuMsUEPmOd1KmtSEX2pZXQ8/jY20suODQf432eYwY3rgalkL0mVD130+ylm7nrmnbirE4h2gZYbT0KQLPQsPp1Ecgul7xOJ48bFTmFpOi3pm9+CPgevrYZ+ZZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Xf8/cKA6vArGcZuHUkek+fKsIFfm0tHR2Eh0qreAng=;
 b=ToMTVOghpY0PduukgsJzpaP8nHOZtqB2t+WtJjNXC2smg3vWU1e482/TqaerQrwfLi5sgVFOn6pxMgPGgiVO00jqr0Urt2YLh/0uLtSb1eK+2VSBHFmf1JwlWY8bScUTYTNupkvN2zUZ6t+u9K2tI8mE99ouask1hUrhEnhgoL9gqwOAD/uzEIS8ueuVxRTvxLgjjQuhC+wfZDCbtlOG//qt7QB9Y8x3wrEBUckALjLFF6sFDo2/crDIV0bNfu9ip3o6fJuYt+ispcK1AdGMR6Gdeo8LrwOGPLyCVgNnwG4plbYBqi9FXt9l1E73uoVBtKiDL32l1gBCPcUjXT1uag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Xf8/cKA6vArGcZuHUkek+fKsIFfm0tHR2Eh0qreAng=;
 b=k5fZkpljw/3IJIwaYu3tXCgxtwxTXBzo3wHJ4Q3gX2JT9xqoaz+PilhYcz2YzNYLLB4kU12t3HSGmFjV13p2tLEmFwwbUCOvpEfit7q4MmG8aaCYAVF1yZaoERT5qoCiNktOZRYfDDg5TTp8e2/R4ySF0qklJFBOOY2BVAGP4eM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB6302.namprd10.prod.outlook.com (2603:10b6:a03:44e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 10 Aug
 2022 03:42:02 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:42:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 3/4] scsi: Internally retry scsi_execute commands
Date:   Tue,  9 Aug 2022 22:41:54 -0500
Message-Id: <20220810034155.20744-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220810034155.20744-1-michael.christie@oracle.com>
References: <20220810034155.20744-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0005.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::8) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da3df589-e0a8-4b9a-5b91-08da7a82495a
X-MS-TrafficTypeDiagnostic: SJ0PR10MB6302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9lBOAdY5yAiZlPORyDw6ImCJ3tJqXxrEBwS1uuDRP6KlMksR1VaKRD0QA2uWQX2Ye09MEvV4X3VnvtzW3w1m8mbqW+5u7kgMg9hEnUBkhTqtDsftUKOez/mWLZ4BiXcIF0WMzITrh6O+uNhupw7+70Q6PDbAjlACejx0SV3py88oG2b0wNg61ARdZsLYrp2zPntSrgn7FyMMv/Pz3bX3507Z2XDW5HZ/IY3tqlaeqWxhl1z8JmcZosNTqCbYxqm3MxQDQTMmKd0EInVyoKQhgklKtgEQZigZUBe06Hq87YO5CSAZPdtsuCY/2euTyRDfX19DmmG0PB+jeRiH5JZGtQL8l+3ayNGI2Qg9vIPgvz6yr8jufAP1tvCZ8iMNKwS96L05dUqJWlrGiDM8Ey9RITuEawd4SyoNhZkHj378xJ2H+Ccfyglk++i7zNUL7g1xtIPFqkK35QG0ZEWwiEV9P/jgvrqO9O5OGmNgIzpQwsenaPuZunZTpgbhCL+3i2aosKk1b5dOwyY4W8lLzpX28ob/WbR3ki1C8Vo8m8fFGxfF7RNBMdaaXobPSjiwM8AuY5liLiwZVS5uQoPq0qJcoMbjpDq3RZ6m3g+27blriWmQFQ3GddB+xnurRAIPpjzvE69gfbVRMZp6D/2/dqJEh/iB+ZppbPgCeazxQj7Gbx43jmWY+Rilmtvl1OzE0YWZunAHHiOBEqGXnBaOZBTGA8c6d/2kSHAllPKwqkoMbGWFgHDR1NVKPG0YjGpXtlDZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(39860400002)(366004)(396003)(2906002)(6506007)(107886003)(316002)(41300700001)(38100700002)(6666004)(86362001)(2616005)(66556008)(6512007)(186003)(1076003)(5660300002)(66476007)(8936002)(83380400001)(66946007)(36756003)(6486002)(4326008)(478600001)(26005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VznOYMHGywt+8o2WvG3qQlanNXuH++zBikLBC0x/RmTdoXMTvbCEPkkuZG7G?=
 =?us-ascii?Q?u3DFbM9etD1m1hNv/0IykxwvFj/YlqW+lv2UKTOdh4Q+aLUyksYjp0hxyPJW?=
 =?us-ascii?Q?OIvF5KYbIR0VgFfOXVXbO37fRZ0qm5h2mNTPgdpytudb/GD0rJ1ywxbX6qVP?=
 =?us-ascii?Q?RkzrF3AW16Hq6PODor4a3Gsjvzi7Vlxtr+QPhSOkFywRvZDNjU1vtqLNU6cE?=
 =?us-ascii?Q?CxCMTaRbQ/0xiUAFNVffdMHjrWwsKKDxLMCQEoOTaWdkFr8ssBdDcpBfFAe2?=
 =?us-ascii?Q?60YTtRhJMzmticfZIP0O2KO/q4sJTPXm48vKwbeDbB2uyPztl9b9vTYk+JIs?=
 =?us-ascii?Q?H7rh22HfXsdnuaI8N18rqkjqlsoboKdpwJMANBdz3yJjZP1w1yYwGK7LgQdy?=
 =?us-ascii?Q?SU/kPjAJlYXfL1JgQbg/bHtccdhQdmBGWrV+HMWCvgIsJORKI156w10pMkPe?=
 =?us-ascii?Q?V4FxzrBW/F3M0B9OB/JgRoo7G/67BbylfawCfuvAAcb55VhuSOJvj//U8dT7?=
 =?us-ascii?Q?pjdDTeJadqYEAKJAdhwn+/S/aYOAC5/cPvduhh/Wtf9POyuWaa/DuHKfriJL?=
 =?us-ascii?Q?IRxQkg6NNMrlrE/TxqFikjMNjQ4MN0SrN7bpjg0QG9NFD4dO5w2xvPHF1H4S?=
 =?us-ascii?Q?oXIK1lsayJVQikTRXLXnrZLmE+ZjFYuUQxAaPPl6vZYzNr4e9K22QJE423rl?=
 =?us-ascii?Q?PggdaeVN0LSUENenYgMnXxDfcg4Vex+kr4hl+WBGz/JEssltbQokPTtV2X7F?=
 =?us-ascii?Q?fNNJjcsL7RtAb6UiFu90uhcNQTExAuy6A5rtT9tSvTaZ9bnqxZkcZRIZhZyO?=
 =?us-ascii?Q?3SVLmwUO/8tLHauzrIYwNf1dEK1QldcXjDGfq8pm+sj/pGXciCMywtDuPLWC?=
 =?us-ascii?Q?GugSvjx9Z7lORsdYBWB4IPdsGhjW8ngN0tcnOjN+QEe7pF99dFjCkv70bodN?=
 =?us-ascii?Q?fqq8A9vBWOWZ97lO1HY9trCNKiicS2BS9Tgv4NrydNCFPYKFp3ML3npqC8hI?=
 =?us-ascii?Q?zKlHVYN1g1SfG9w6SeKMrZ9Dp65QxHhn03HJ41A46PybpZTzfVR4yDIHbUxf?=
 =?us-ascii?Q?F3Wp0UymH70WfxowDcAzKHDifFZkm7F13i2h4EAOTsgDAmwle/3UEau05ueC?=
 =?us-ascii?Q?yeL26HLijyDks5eVMdZg4Fht8H7obDBBicuMmvBN3LIHTJhotKtrNlACEUw6?=
 =?us-ascii?Q?xa3G4QiDtARkAJWB44wJ1sCMBFcwPj1vWGziN5p4T5KQRhh1rHcpX2CFAIM6?=
 =?us-ascii?Q?KHm+DPQl1vpKjn2uXYwRb8Pwv/986X03Yy4FNsVAbxISlEdZXrtSa93Kpmor?=
 =?us-ascii?Q?nhF/SpjdsotpIo/iA10myj/O1o580n8yjPurpuZCrHxZpb2A/ApBwCcr2gJV?=
 =?us-ascii?Q?eWBapzupxccWnn0U951KMvqJyVA/fP/vQWO7NJCjRz1XBYaN16oaaUAuTWIV?=
 =?us-ascii?Q?79VhxAEgS/aKuHshCZj55qdMtluV5bNyMfgvkPnziV6yVCuyHWJQqJD2pcKh?=
 =?us-ascii?Q?FvrwBpPURGPL1c2rus3vSAk/jSwYBZVm+gc5FP6oJ2siKfeyatPWvBAND3d+?=
 =?us-ascii?Q?I+yK1WAC90ojbr3pWYu9sZeBm3IDHeDzWJtp9V61KXUiIReNiEpyzsc4NIat?=
 =?us-ascii?Q?eg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da3df589-e0a8-4b9a-5b91-08da7a82495a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:42:02.2591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G5iBw4a1VL24Jo/cv45xHKmsrEqfWQX5JI1YWlVnT9LV58CzM2e4y01eXZxfxPWeOReLHH7XBsOwchI1mIrWTdKO9JqVw6RtdjaYFbDqQDQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6302
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100009
X-Proofpoint-ORIG-GUID: uTq65bXTH3u1P3XJrP-UMEtwEuskR4gs
X-Proofpoint-GUID: uTq65bXTH3u1P3XJrP-UMEtwEuskR4gs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In several places like LU setup and pr_ops we will hit the noretry code
path because we do not retry any passthrough commands that hit device
errors even though scsi-ml thinks the command is retryable.

This has us only fast fail commands that hit device errors that have been
submitted through the block layer directly and not via scsi_execute. This
allows SG IO and other users to continue to get fast failures and all
device errors returned to them, and scsi_execute users will get their
retries they had requested.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_error.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ac4471e33a9c..573d926220c4 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1806,7 +1806,8 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	 * assume caller has checked sense and determined
 	 * the check condition was retryable.
 	 */
-	if (req->cmd_flags & REQ_FAILFAST_DEV || blk_rq_is_passthrough(req))
+	if (req->cmd_flags & REQ_FAILFAST_DEV ||
+	    scmd->submitter == SUBMITTED_BY_BLOCK_PT)
 		return true;
 
 	return false;
-- 
2.18.2

