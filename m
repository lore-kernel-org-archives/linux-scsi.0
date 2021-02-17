Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E4BC433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A99464E68
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234310AbhBQU3r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:29:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43848 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234953AbhBQU3U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:29:20 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKOHWc190368;
        Wed, 17 Feb 2021 20:28:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=YifcLh0il3TAoAtiSTT8Q8kHskbGL/+3duj92Vi8qB4=;
 b=lJJ4E+mV11Q92pff3rFoVbH6t+ltjIQ0gZzyJloSJsoUiDbKGr64qU/nP2NURdovENA/
 2S6aAPSqFvEI/tY5ctXjI7NPryTLnzf8QNczazJ/VabAS4ILyyVTVzEn2BIPSp46nXrJ
 YIjy0LtAA+X+hiMlNPgfD5GCDGbs0O2DFaOr6RmNwSKxABTcc3WnDSaO4DGznE+CB/c/
 1XJWRSKa4ERK0hcxF5ATrjUD7MaGImpyFPmq6TFOQQZ74mf/Fkv4jTOxIqRJcvRfEAY5
 9UsYd4bCC5wF1kVW9Ne/iatIW8IezMkczEW+EggU8cTRjOupEtlo8vtuNSxE6BuaiTBG Rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36pd9ab8gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQDug191708;
        Wed, 17 Feb 2021 20:28:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by aserp3020.oracle.com with ESMTP id 36prp0p656-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5+kHW2wVjPKPpSYgsRw99FOg9jDR3ogHuDX7qAYhoKEHjxXxmO+Q5b1WUArzwRpbeIfB1q5N0HWQdGCr2EviNqNdszIoNyFnw4iSdp9FFXpaDhjL7Y9ToBzqZXtf5kdErZuVpWq+v4yWR5ekfvZ/QjDQgymhS0KlF6aPGxp4/VCK8yYmxUkBzHX/G3JjWZRTJKb2EbTapEn7ybQ53ZeDicbY1NAexQa0Ra95KQ/lRLULTH8J5ia3FQ67q1YClJpkNXkgqIfX6B1+QtEZm3AMySopZG+vuQVJJaUoFXKxsYoliahNRrzqT69BHDG1sF7JX88afQXksZgoiW2U5lY8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YifcLh0il3TAoAtiSTT8Q8kHskbGL/+3duj92Vi8qB4=;
 b=gKFnJxcuscD8i7Sse9pqx0nTOKfEDN7sXT8+Km7Lbmp83bV/ZoxidgLMrupyqIJQrxp+CjPI95JdT5iAJ1CUWbr73rP+Or7jRob1bMrA55XxrhLNEs6AH2IZFRrlGGb/tt9Tk//YV/AxpjH4nDU2k5gK0jvncYjI4zbjdU46PqbfPgIYsioO3ja5/KJhvGjoJ01xh/mESWDS/WlfhfB7ditd4E9KF2M1OZrJOwFDljPi++DFvxSV35caR2YsjRxXNtwRqUFFBnn0kZARBRMAFc9ukp1At03dUTsebV6PMPr0EqAXnTHgrGCwF1tYvSln3/I4fvVFTeTSwCSb2GwMpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YifcLh0il3TAoAtiSTT8Q8kHskbGL/+3duj92Vi8qB4=;
 b=dMTuGJi13hmAHHGWHNmP2EKmXzAEH0AaWgXq71mtkuaSPZ5JmVC3KU8wAT6XHYexJ7REb+ZeJqzb4KMJBv4TzXi9XRSubCyWmSWrlfQoCjkldMku6/NhwNvyiiQpi/kHCQenl35Uy37hMZp22iqDt5v/r7kt2RryxdoE4RDjPOs=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2677.namprd10.prod.outlook.com (2603:10b6:a02:b7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Wed, 17 Feb
 2021 20:28:23 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:23 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 01/25] target: move t_task_cdb initialization
Date:   Wed, 17 Feb 2021 14:27:47 -0600
Message-Id: <20210217202811.5575-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217202811.5575-1-michael.christie@oracle.com>
References: <20210217202811.5575-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR15CA0001.namprd15.prod.outlook.com
 (2603:10b6:610:51::11) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1179c2db-ba2c-45f0-9b49-08d8d38292a7
X-MS-TrafficTypeDiagnostic: BYAPR10MB2677:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2677A9EF04B45470005FEC47F1869@BYAPR10MB2677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M/SoyNK1RpYIWZnQ1Ztk6gT/A5vb3+gVCV47yPnf83C3KBoxcVE/LlCUt4T9pNW5C3BTMUYN3kPlLgRYnhoe1thSvpx+y5J/yXwTxWIAoC4NVerwHCSt5P/qA8yvQbhJFFtlVzHJkJuesEDW0WiDhy8iN89Cdj6BMQU1OjhYiE+a9+zYfYwX8XCnLTP985roovQz0M/aIHedpmHHr1s+Hj36Q9D1xqVdsu6d/aK2+Rov2qmuVVcsiSZAmUgsNEpcV3xafh4bCjyDkOmTZFlAY6kjBhUOW2nSsEH09MnW8Pu23deQ9TWxyT6PS8fLaiSEHt4/Qh5GmYM5vs95TPsyLLXxUqjIsI/Q/6hWDTBhFQC/RxU45v3CHyKWi380mEBRiSpSIrQDyriD2Xt1ft9G+aclTWDfDDVtKICfInRynYX9gow/rlPVoa6CZeUKXnhz0KjWnhbFsiqAnQFhXgYxegzLCVWglUryM4Eu8ynnQMLWhBYxbtLY5Z9ye+w56cZ7CMVOC6r+7k2aw69oqMTOzfQdJ+HrOh5fYOv876Z+KShCtloOf7RacSeKpsvdA0mFdJ515/yw5yOOXRxOnupvdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(39860400002)(376002)(396003)(2616005)(8936002)(956004)(54906003)(6486002)(6506007)(6666004)(26005)(316002)(86362001)(107886003)(8676002)(16526019)(478600001)(1076003)(4326008)(52116002)(2906002)(6512007)(66556008)(186003)(83380400001)(36756003)(69590400012)(66476007)(66946007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?aweNYekFDXsYUgaD+d5qY6+jzJvrFZr7g0lgc1bM+gppFuj2faQqLBiuYGuI?=
 =?us-ascii?Q?CID4sDMiO4+S+SzRDJXcCchA8/3ECyYw8zGL5CuiNC3Yjs69lrdfmw4AYf4Z?=
 =?us-ascii?Q?aA4F50LnBHFKHcqMLAoVrZmGcQzt83Z8ukAqHtf43iZGmodilrOu/B7TtVl3?=
 =?us-ascii?Q?dW9gnZ8Dxly7vTvf+Ik+SE1PvAQP4DD2PEwANU5NAlBEZ+hcIoYCETmQj20M?=
 =?us-ascii?Q?Xji1hdh7kDKmIAkH9Nec6bL+larFFVGkzrJCyMdYWhMImYOSAyUVPiZG6x7c?=
 =?us-ascii?Q?6fW3dCyiwvHWG45FFWPBGyooUUtEOfcDSpF1usRQ66lk+2G55htW44DzSfom?=
 =?us-ascii?Q?sKXQf7uzbaTY8Rkt6LLCzuNrBcMQa9uhIYSDuJ4vdMIDI1MVBofpMVjVbEMl?=
 =?us-ascii?Q?1Yt5mq3ScuK7+9VEupHtDBPq4Y1ZcBPAS+/BAjgNcZA2VIp8j0a62lrpk+qp?=
 =?us-ascii?Q?I77+ZBi9jVeZHt7qxMSuRTFWYTLSchOEOwy0pyBjaS3Sg9i78wAX5GpST91W?=
 =?us-ascii?Q?rNymHE+2NVTGoOVwrHyskjKGRj5aIhPTudeU2yPaQJY5NzG9bsJpixZ1C2KE?=
 =?us-ascii?Q?aoxOo52qvEcLUEVwASG3eCRYpZ5IH6BXyj1vHls3FfcrTy4Wi/EE9PNu+b40?=
 =?us-ascii?Q?LGX0f7iRf0XdU2B0CX2DnSUY+OrGkEHWFx0zIyRaiILJFiBpk7/lhBMjKlG3?=
 =?us-ascii?Q?bad5NEvp97I1H0slksFoFqzg1EQLKBwF/DK7XMJkJPzzPp6JM+oXsbgchPhP?=
 =?us-ascii?Q?vkUBgU+yFD51meceL2xE9f50/ZbOc2OD0XSEJ/OEKuJ2P28DYgpzrbdhW2vm?=
 =?us-ascii?Q?vJLqPqMwceSDKcUOGlWYao+B5/aikueczXZ+nBeQA0adaDJ+cVkf0fe7jeb2?=
 =?us-ascii?Q?96s0zgfT2J++IpSs78IAUThRBa/CoSniFFLJGu1IPOqBXDwhAwwgtwNuGAUP?=
 =?us-ascii?Q?5yJ7t1XsRd7Wza6VRjIrnJNpcg+uCsKzitbMgPtvKMzcsG0JIbOfuUUk7AH1?=
 =?us-ascii?Q?6uqTwYc6Lm92Cr5ZFsZz4TcmNtCW2znjxFLjzhW7xkeDkRuWq6pMKr/uu++h?=
 =?us-ascii?Q?KtR4tWVjMVKGnEgNHzbZWH7zS6oCRf8e7fsEFUET/3nPnen9ndjAFbqa3z0R?=
 =?us-ascii?Q?mLkt2JtbNCCkqB2RA6mWMoXElD/2f24USpDKfanzL9HY2zuv2OrfENrvkR37?=
 =?us-ascii?Q?2FSMkblGB0W/q8Bz9WVOgMQubbdwGmZRNpDkNo9oLR0vg4qe9A+b7wbxu4eA?=
 =?us-ascii?Q?ReL7SQyllW75bhGbgnq5tujFJWFMSi6P500m+nGExPB1TfxWdikuOdh4jXMs?=
 =?us-ascii?Q?MLVzimpB/e4i8KF2H/0/PFYW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1179c2db-ba2c-45f0-9b49-08d8d38292a7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:23.5710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tyutCLX1AqSHL9T6IlVKl/eZtMsfSXVRcqqIYHOQINdd9m9X8pF+F7S2sxT1UxEqcdjhachTFD1OuMPS3gKUgeUP48/7CJJpl7fBsaizZaY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2677
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patch splits target_submit_cmd_map_sgls so the initialization
and submission part can be called at different times. If the init part
fails we can reference the t_task_cdb early in some of the logging
and tracing code. This moves it to transport_init_se_cmd so we don't
hit NULL pointer crashes.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d47bfd8b0f87..5c4adde96d5e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1389,6 +1389,7 @@ void transport_init_se_cmd(
 	INIT_WORK(&cmd->work, NULL);
 	kref_init(&cmd->cmd_kref);
 
+	cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 	cmd->se_tfo = tfo;
 	cmd->se_sess = se_sess;
 	cmd->data_length = data_length;
@@ -1430,7 +1431,6 @@ target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
 {
 	sense_reason_t ret;
 
-	cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 	/*
 	 * Ensure that the received CDB is less than the max (252 + 8) bytes
 	 * for VARIABLE_LENGTH_CMD
-- 
2.25.1

