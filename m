Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C098E936E8
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 21:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244001AbjJDVC4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 17:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243974AbjJDVCx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 17:02:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5ABF5
        for <linux-scsi@vger.kernel.org>; Wed,  4 Oct 2023 14:02:44 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 394FJ9vS016140;
        Wed, 4 Oct 2023 21:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=myIXlPUUs+aWF4FaahpIwHu04bdlMeLC/y41ApmW+iE=;
 b=UNYxxC0K3eMhQiA1JHItTYnkgyNyhT92K+TrCQK6qNc7duzNoAsWbT9lLPxnVAU6hXPL
 1Oc6xxTjW+k32AEI3FeZsCX2Z9WEpB9IZlwTdAQ578hin+exc+feCmqvqWtzRXpE7WFB
 jI9UvVZXoeFt5E7KQQk4BA+6GaGwexqP2hoVgSuF360tKtvgPIGnXkMN2SdsCfmi2pQG
 6GdqpZ1vMGY64navWJji8cwHmxF6+zBslx6ft+pW0ILMKxSWOPjneL/5ims1BHYADlPo
 cKkDLlB4SS7tKSVB1qMnm1M5WVkCXkLP5au58jqC8559P4ZsB14V+Qi3Zr+iWAxYGvtf RA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3teakcg4rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 394JbqWv010357;
        Wed, 4 Oct 2023 21:00:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3thcx5y4cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aFzRYQPUTe7U9Y17SvFXi/wcWnP3D/io8Ohhq/8aTRhhubOZ2MsBnEq6PYpXxema4nBnIENw9A53PHgjCuXdrY43roO9hOoinHI5s/DVvMyISUoYmim45sxZIAXeJJYX8+EaGQkY5uq26e2wGE8xy9q+qsSMiQu03fqJmYDbCmlacwzDDsFiVaJLFd3u/rBPVHeYiWWjPO52jhM17S5dnnQFSgUP93RtWQN7hzC3Lm/eFpfJRjU9y1AnfxFVcfokYEOxBRDQwn7OWHTp+RbR/GeelPQAcIyeXztfBelEsVRiM/gVkSimptkzsCO07WHUUfl2x1xtPETt7+MvwAq3EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=myIXlPUUs+aWF4FaahpIwHu04bdlMeLC/y41ApmW+iE=;
 b=ZGLY01ptBhjo2NgELdYEL59Hbkg/Nek1gMgEq1JCDANh6xgeRy3dNWQSWjE5dVQovElnxuIbvBFEenVbATBfICo5OOD/x95ffntqj4CqLoc2aQ5C0M9SjA/frpLsW+lCOe4UrE1jtdURgPsK8vakmkf0YUnRtTYOpVDW2HLge+gm0wOcyjl0D9G6or/tZrafdN522p6jh2WwOXnsk2wdGfdHSdlsgB5JsaoV8dO7K0t0l8FcJu6fPbrt0acjRxWIyW8A7TtLxllhNffVRdsgmswVD5j/ZH9lTuRDngp7S4oFRhlkCY1gRifP6ya6nWrHewoxer+3FjDAn+PBJczxvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=myIXlPUUs+aWF4FaahpIwHu04bdlMeLC/y41ApmW+iE=;
 b=cxwMd3gMw23Jyoor7MlQTKSxtt3omYLxynE4/4gOQlVWgVnTkGXS6w0Vxas+Bx7aLpgXce4if7Z4IMuUjCrMLqPKbxV0x8zDsF2BoP7tRogUzcUpD79rZ5Q1hYrAT4DM9DR2QVE2K8VdNcMtAh1DWF6O5XTSJqn5RJiDexR+N4o=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SJ0PR10MB5567.namprd10.prod.outlook.com (2603:10b6:a03:3dd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.31; Wed, 4 Oct
 2023 21:00:34 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Wed, 4 Oct 2023
 21:00:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 09/12] scsi: Fix sshdr use in scsi_test_unit_ready
Date:   Wed,  4 Oct 2023 16:00:10 -0500
Message-Id: <20231004210013.5601-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231004210013.5601-1-michael.christie@oracle.com>
References: <20231004210013.5601-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS0PR17CA0021.namprd17.prod.outlook.com
 (2603:10b6:8:191::16) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SJ0PR10MB5567:EE_
X-MS-Office365-Filtering-Correlation-Id: d60c06e5-ade2-4a72-9c69-08dbc51cf3dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7YwWTWIoV0MTA5SPy5EEw5oEo1j90Q8od/nfLgNoEvkREqr0Al7Z+V+AqXis+Z04t/sikJlyMFWNvlDicuTF9DGLbMRgj5UAekXjTisGX3RtCcBrnBpjgnpgqSDw/hfz5HsEfTPTFwBxbmhHJ3Yi7yI68kYULb4f9qvW8pt4t1GpOQg1YRFm2Fyyo8LUzkG6+6yinxOABguTXLtw1wTjcrPfmySv3TklHKpkk3wwxbDghyeMw64qDgoE64dkHU2jlPaDcztcHv//ml9qo/jvgLfRzzoPRXJ2C2h/YHPFIeJ3FZG9wqlC4y35VgyfW6N79obxhmQkan9v9Zcrfx4wslSEmE5ZJX6GRdBR0HOsx6ighJBEh2UWvtGdiFNAdpZ/Z/iwcd0/BSHJSDW9OW9srFq9Efi78rhPuuIWIUL2PGQYaGbyYVHoxk2PYu7go4We7i3OgVASibw2IpUMK5S6Gs2TPF90K0aTcb0EmW4DdzMda1RUsoxqR9TnXhHHmsjcqUHwjefj0yQv5ftu3Mk1QD6zF1gUFA/NFa3x71isg4e92Hs31l66cS19v/OOYB+R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(346002)(376002)(136003)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(6666004)(38100700002)(6506007)(6512007)(2616005)(86362001)(36756003)(1076003)(26005)(2906002)(83380400001)(5660300002)(478600001)(6486002)(41300700001)(66556008)(4326008)(316002)(8936002)(107886003)(8676002)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0kWt68S9b99GeSq6EfNDEKDPFlEqJs3/Lip/HBl1SFa+y4C4WQQyesLfon4G?=
 =?us-ascii?Q?KNT7+XwfzZGXyHzE2FdFdaIktXZewjZHBAUSwzEMZ71FtgGFP0XouCq40bXT?=
 =?us-ascii?Q?7/Jp3h9fpO9rRmMFPBWU2xkTYhFDZU8rnYs+cU60Xqp2ro51fr12eyasakNC?=
 =?us-ascii?Q?USQle3qBtrgk5Ajpg6wwDzjZQ4FYiSCcqIcGaWvzne8LKdX7OOww4MbiYVNG?=
 =?us-ascii?Q?5NQV/d2Tqzr/ygnv70aZ1B+/quuk/BQHhwr3YAzCVi6cMHuQo8vDqKYotUUu?=
 =?us-ascii?Q?USbhACC5ucxB6Ei2U2pXpGR3vUfzYuMizeq2/eSSfWs6p9to02gbJf4FuhXL?=
 =?us-ascii?Q?KyWBMtosrTH8i9cS1U5MB2i6eNBLA9eyV55BX9xN4wPm7leSevSw7nUxB3fx?=
 =?us-ascii?Q?AW/Uhu9qdlph2y3+zGqN0rm6AyyJz2atHTcSzXK7eGe2oZtZCKWb/yp/qAOi?=
 =?us-ascii?Q?DmqJTsCnYJSPvJldDwv1511NGROKbSYlmu0rlfmziP87a9pMEqte6tQK8AKA?=
 =?us-ascii?Q?H2XBMGS7ndokakq9BvbN5v8hxYNSXT08WjIeed5+YUPiEih+rGw1iKn2rsJR?=
 =?us-ascii?Q?a4kuNw/8Qd451cg7ITjmT/MCFq6oHGrb3YkXSvIpSu1RkpkYljeX4seTDulm?=
 =?us-ascii?Q?reEe5EVP6DG7uPLm8DzVLzycGESUYK3tUo1YdyXbj6+BjG82pn7k0urssj5s?=
 =?us-ascii?Q?bZ3laa0q8tIkQDz/wC14FH8JZbigzT/3/kZMj1ogmob28kAIgxKiQGw82qnO?=
 =?us-ascii?Q?Uw4s2LnQc+QkkK4+MWUaq0K9YHvOkLZkYPYpxPOb402v8DckEC+ulE5wQxuM?=
 =?us-ascii?Q?Sab/f0oKlYPgJLOHz5GChwd0sbRu1v7UyLj974dAxitr5/6n2Pk45kBVdslZ?=
 =?us-ascii?Q?l5hS+gxwUg7ZgE23mxU9SH0qrCPAWSN5V9tnUR1Yteau+ugUkYQIkcxDNfRM?=
 =?us-ascii?Q?8ORHL3qKILH2Ak4qDMkVLxf3y8umaxpu9kH8s21fFYYIxk3GRl+gYnEh3uQk?=
 =?us-ascii?Q?bsZ4xt6rV56e0aZ57NiNqbn4SuUnB6yUGAKKYiHQhKqxcVa1rPWIKpcR+ZcG?=
 =?us-ascii?Q?UtZDLDwMdUGvR29PrEPC8a7HPWip/XmLoiU7d6rMEhulds7eLLwAKtxWJnuZ?=
 =?us-ascii?Q?pXJNBM11rerFpVCO9xKRwS1zxbwpPYw9AUL2F23B4QtBlVhwso86zAzi+RVr?=
 =?us-ascii?Q?FQ4R/m/AryZj2gIbTUEl9MNQCj1KnaU2zC50uddfLJnOJTv8VJ1XPmpDplGH?=
 =?us-ascii?Q?tnjhSSG2zOirVswHJ0Le65y2SmaYzap6c/2M/KujCcnVzhohqcWP5txF9vP2?=
 =?us-ascii?Q?cs1dkfo1FBSYt6ps7dRQ0++EiYrav7fyNIgXHU/dd8qaXsyQnKir3toZG5zp?=
 =?us-ascii?Q?Et5a/B7sLxF1nCS97sYndVe/IwxQNz7UCeoWUfDfv9RL/YQ1YebgnpI2Ek9w?=
 =?us-ascii?Q?KHFtwE+7aMWNsjxqBE5+JWvfk+QVkJzpvOd5tVN7bzvMjHcwQsANmi6h59wI?=
 =?us-ascii?Q?6wfR+wy+wMmPSSuvtpzPTqGAJ+JY7Vlp6wpiMwYOkNSQuzqUY65MprcZuaBA?=
 =?us-ascii?Q?dM8yGijs84YQpj4pp83M5WOYagFvIiuO0xcfLq9eg4/u1UMGyieuQB5e8ZPJ?=
 =?us-ascii?Q?gQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: roH7oajrZiXwns4zpW3fMbBX2xq11OeLH3H8MYUnOUMjzP042JOtXksQyxL/+w/kVEaNnSRJbT5wVHipknyr0iC2fQ+JR0rJGxYb5gqh/bPGvbkySvsF0OkJH5gycOATPGfuyDsy/lo1QcEGa6NjWfskoNwjJNIcZfi8AXnCZo4C6HuawYN6+YR0qcYVXibLz21y2A7TGvHdqbwWh1MX2Fs+Y9DXJTraisxjaYYUDGB6A1Ve0d1kgrHN0EhldXjQPOF5c0VtwyHEt5sJ4nVeU3CrVg/Rox5SiDBGyBCdtY8G/YXOrbKAhEQUtzA2RjhNglo+HejCN/2/yt0fAV9pIu2uEwgS7AtmLlYk0o466Nru+NQaKym7+f7fE6qsnAjKJv7zuXuZcm+feD0CvzYz9U7T5Zmd0uMlj2zax8tbPpt5at1OB6P9GxRJ0rrL4Frxai88Au0aDlx0qGOnemteBZY7FoySXFj+VBz5oiYDU7P09YAT1WW65xmLeNs61DyMrcNPKtDb0EEcN2EdKc8Ge93y3RzWL03AOyF2G3eXD3sKDbX9gMwgSU8imgsLTgF+SGR1FkYA5znYCS5h2kZGHsMo65tiIldxzi2CMwfDfZJbWpz9fxsRvPIT7WKOhu8LOvdNbm1bM4PyM6XKtj2Y4SR4J2xO8UDOwp+TQjyXfyFiGsh/HGodz9NmUytzEX0a48cC/dgzwlVvtH0D9tvJ7BIX0yx+VCqg68eB+fQWskOjtjrw9RuPN7zN59iDCXh1rKcYLlehUtb1mDyx9vbbU3sUPKsQ241NgodH5OMXN9D/VOaPPUcbEmn0Aex+mRnXNeYw+PfrCZXFk8Rp0YC4krqTkZBUf2x8DYZNYEE69xATfsmnQ/VYPgq2qj19bgND
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d60c06e5-ade2-4a72-9c69-08dbc51cf3dd
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 21:00:34.5369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j8t3pBoJAQL9J9ZT76w4KLruPuFR7ZZjuhKsiS+bf5C5QJENnEV+CVHMEoUrkHfVznUOYRan3SOQceQ10iqEYBqOIJFNKKcsaN9ymfXGL1c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5567
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-04_11,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310040155
X-Proofpoint-GUID: g9_ws0_13IzmxAHlE5FOPsLED8-_9cqU
X-Proofpoint-ORIG-GUID: g9_ws0_13IzmxAHlE5FOPsLED8-_9cqU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when we get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c2f647a7c1b0..195ca80667d0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2299,10 +2299,10 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 	do {
 		result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, NULL, 0,
 					  timeout, 1, &exec_args);
-		if (sdev->removable && scsi_sense_valid(sshdr) &&
+		if (sdev->removable && result > 0 && scsi_sense_valid(sshdr) &&
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
-	} while (scsi_sense_valid(sshdr) &&
+	} while (result > 0 && scsi_sense_valid(sshdr) &&
 		 sshdr->sense_key == UNIT_ATTENTION && --retries);
 
 	return result;
-- 
2.34.1

