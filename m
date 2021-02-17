Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF23DC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 656D664E68
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235038AbhBQU3Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:29:24 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52938 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234055AbhBQU3P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:29:15 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKONtg017798;
        Wed, 17 Feb 2021 20:28:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=HfnTdvYNAhZ/V14HKCFNOmSmkSA2UO5nPhFpVFbegJ8=;
 b=ESoXIMF84FBr72YkXdEXuLUMHtbxZBMY/DK+SNW4RNLSds0YPjZq/Z/3sYthPPkb9w1U
 4NirfAeUboWRTQJFpdNVdAfBZ6CL/QYvtmULJlCr+8vfaPFi1W11BMiOZbL816NVWA/Z
 arZGWMeNvb88REp2sTf8aun0B7xDgm9DWyPWQojSHpKkl5ktZVQgbJheeTjB7qjJu8v5
 mOCAoYuR8X8AmraHcYRn7ndPHPPDRJzyBed3Li6AXgExChxQOb2ZgBe5GNhMA380dm8s
 eH4I45VbKufvv61q0FEZ1sz1vNgtzh0DDQePf6wGIp5WqcgNG74c9rZU24EmrFji23aU Mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36p49bbwwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQOlM004067;
        Wed, 17 Feb 2021 20:28:28 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 36prbpwwtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WoSRoGXVnLj9+gC3mbVq+GLqHJDIpIilU6f47xak8aiw0cE1r8ziSS2Ub7y6PAcYP1/359C+vOsb7AZy/3Jz5Q/YOq5BEsX8nRD26DOQO71JP8m/GfhEw2CpyqhqbchErXtaXaadx+iiqSGoqEvjvEMCTkewhXnblD8Sv8lCHJ1x+qjUGe6aVkS5EaybBHC1ob3j9LdnZ5Hiqlro9EzLIHp1gFbNoIf3t53IMOIRVYWZwWgIEPNclvFJElCzVZppyFwiT60NCIDfDmID1fup74xa0GfDamflQnNqKxQDq2arRMd/2jbrSPQNXmKpCteu2nRqOvRzEnCyan60lZulWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HfnTdvYNAhZ/V14HKCFNOmSmkSA2UO5nPhFpVFbegJ8=;
 b=FkVdPw72i1SXwj+3oP8Coi9W8J4iK9WZT4Cxbs6oJHKb011PhKhSgKVbirnc2O55lNfTXuajhUZU/hO0ZcIJ+aJutm6ogQ7dpjp+OFsnwtpDNtAgSiX7OCVEUxE+V0mQPrSBXcoKq0wa7NAoH6mmeNjQk/ZFr6avlRQBjdeneNl+wuhLuAcDkajtTYgK1KCTPPDK8vlHdHGKNDDFZyVVDF3Xu5duYBuiCLMFFL2L/rI1ltZ4icq67dKnBZXe42gPWgd5dpS479JigZFknA6k8LwfAgPs8Ht5zVjulThet+0rWM4oBvWzn7cqd8mVE390BoMNm7W8By8lI5/f+6vyTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HfnTdvYNAhZ/V14HKCFNOmSmkSA2UO5nPhFpVFbegJ8=;
 b=nbLalXOnXqn3dUrNZtd9YWGebpeA1M7/MPwz79X7Srjw/0T0zyFrpJWSbxzbw+oz255flhsd//r0be+4IKcnoAnXoRkK8WlYC+HRnupdO7guCJxptM1gdd30rd7zHV7CwEq6bVmtk2BQW747nfyk1s8JS/TcfCJ6spQRitLYGYs=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB4101.namprd10.prod.outlook.com (2603:10b6:a03:120::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Wed, 17 Feb
 2021 20:28:26 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 02/25] target: drop kref_get_unless_zero in target_get_sess_cmd
Date:   Wed, 17 Feb 2021 14:27:48 -0600
Message-Id: <20210217202811.5575-3-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 804c48ec-d067-43bc-9c73-08d8d3829415
X-MS-TrafficTypeDiagnostic: BYAPR10MB4101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB4101B4BDAA2026B2F172607FF1869@BYAPR10MB4101.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6L3L2O4TFBUcUqW8oUIV91ePO33xuWGRnkO0oM+zrJvQkcsOdPZ0vbtzD6vc9ftXubV29Op5DQCn/zYX+dLhX6tx0Yd6LInXkTT+JF60dv2HiULTMzRrk+NLDNiLR5bzxhkylL0Y6a4yjIuK8leJYRFPC7iJwwXkf+V1mqlAdMi5Phi9nxc9AD5eQp0KsCx5DtiNfsqIVVOQl6zlIHh0akqWEADKrUmMpqyZFtlJpYTve5yjEFoCsGquOZ2bhhD+tyBNEfaUMbUx5p7JdAZnF/Lh6epmOup5r+EbANbTiLIgdq0j/X8/vuebxQGHSx1TnlE3Z3IT2PJKAHbxTzfsuMkjph/nwzWgEjvWR7N39A0iT2Hxj/9Uwils30NY2MG/7Wpv/yAAr087uQjjXliBzC31nb47bbX/Q8TUxd6VJQgOZcKP0Jm0dTs3gRpezbK+czuR32L4WDjhT+SKf2EQEpdewcE2w9lcosYwX78HcBtY92MEPS6kPUBEYmNVHiWD0TJ0Gx7wtzGvFWmXkbWybvMDjRvZHq7mTacQrP3DYbBmCT3dcB8VsQ1+C3+U/OTbASrTiML3gdp46OCWiROF9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(1076003)(107886003)(6486002)(26005)(316002)(54906003)(478600001)(2906002)(186003)(86362001)(6666004)(2616005)(6506007)(52116002)(956004)(36756003)(66946007)(8936002)(6512007)(8676002)(4326008)(66556008)(66476007)(69590400012)(5660300002)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?WNKt/fB3wxXpVXoV7KD7xGOw5JwQhMfZqD6NM2eVZIsifx+d1boIBgZ2Bjpj?=
 =?us-ascii?Q?D0emqpiuX6c0e3U9SfGGzNEjrXAsEz4GL+fUNoIYYVoLfrYLOtdjWgyEZX8J?=
 =?us-ascii?Q?z8pDIjaAgJR1BQ1YG/loJr6DWgGkpzAA2/5OoDZtrwZjp1wkzpqFeX4kTbSH?=
 =?us-ascii?Q?zBfWhNm+GhYCM5hlHhqD+VyZuwKMEs2Zfi/nO45A23q7gjfgwpL+mNcIg337?=
 =?us-ascii?Q?A9r/B2V5MPQlgNGyazH8zJqzTy0X5eX9ChqN9h2R/CQReVNmJELXhX9Yydq4?=
 =?us-ascii?Q?Kweafm1pAAdLex05Oxcc6jrENT41sG9n9DLG8Pus9a32nYFLHuTBY4x1uM6D?=
 =?us-ascii?Q?WTKTzGSb0p7w3yAM8cygd+wlGwRTzW1OTJdLkfTKwGC+TFLN6kcmdRQ3iM3n?=
 =?us-ascii?Q?MNL1G4qCm+AglGemNRyD3Myjtze4a9wBXQ5zocIZrJ8FQ1QU+yoqv1VC2NpR?=
 =?us-ascii?Q?aCjra8WnnnZECpJmETeQo5uV7AK++iKrE4f1lgbeVX6H9SyNC4tmGgZrEeRe?=
 =?us-ascii?Q?TKB5AWBFoBKi8QZU/LaCQdAg20XCXnNcyyQWO06lesqmEonnFqYI8Q7KEtew?=
 =?us-ascii?Q?bnxVeGpqkMsC2HypK/4VGMBXTm9KmP9FI/HGIreu2xq9QdGg/k9xntZ51YeF?=
 =?us-ascii?Q?ZCUpiWe6wfaIiuxBkwZEhVg2G21g3bhT8Z4JVG/MDHjggz1n0iP9U/Yd1bgX?=
 =?us-ascii?Q?hPSPpmjJC+02BM7dY0Tl7sB7ReWEljlRP/jNiveTadkjD85kpHOkw/3pjruH?=
 =?us-ascii?Q?6nZiYePSgrIvCiXBIMIeMj/L/N/iP5F8n7eWql9ptFPP0PY57WAyYCPxUx85?=
 =?us-ascii?Q?nqD51n7f4IAUPe3rHZFWiMOqfDC+w+nCDV9uH73En1JnqzoSeEQs2wiimM9P?=
 =?us-ascii?Q?XDAMEHVsnYuUQjuQ22GfFl9pxMn2IKjvRDAkKn5xdntohpbsUzNq95ocE66m?=
 =?us-ascii?Q?XHmkfgEaBFsCHk/wd0TBpj5Pyl/zUo+TpF3sQQt2i7eTiR0XQI9e99HsSrhq?=
 =?us-ascii?Q?6PFqegT+MNL8opeLTYw1yn99JUEV3cjMLJOTP5mXXwUXbGT7nNIsXPb+rmCw?=
 =?us-ascii?Q?iLsKSavfPyWwv8UkziTRY1ir8UUgJPmatp6ZGUi3NVWFGFstlBgPSiVXmaNe?=
 =?us-ascii?Q?23gINR+J8iEPMNVFWpGpyaOkHxS55J2WSPgOrET06DQvYq9Lk1xLVYOLZ1PZ?=
 =?us-ascii?Q?Gj/1EJTKCDhoun+Bl+ONwfjU7aAj4BjJq6PLkYkfsAHSmfLMmuLndIePyKgp?=
 =?us-ascii?Q?7MRP97qFZug9e7AyCpGzW6wfyP2UFOUI0ztffB2kHyFchQcLhCP8rg9afh/9?=
 =?us-ascii?Q?njlfzZuvoO0N8ifcl8o7otWH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 804c48ec-d067-43bc-9c73-08d8d3829415
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:25.9027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cv1IsqVtI7cIy24pzyu4YICJelbEohcr5sqHxq52TSgBI0VaJip59FdmbNDt1XgG8CirRcGoiShaYz4RZu42IiCcjcI0q60wjEbnUimbBok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4101
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The kref_get_unless_zero use in target_get_sess_cmd was added
in:

commit 1b4c59b7a1d0 ("target: fix potential race window in
target_sess_cmd_list_waiting()")'

but it does not seem to do anything.

I think the original patch might have thought we could have added the
cmd to the sess_wait_list and then target_wait_for_sess_cmds could
do a put before target_get_sess_cmd did it's get. That wouldn't
happen because we do the get first then grab the sess lock and put
it on the list.

It's also not needed now, because the sess_cmd_list does not exist
anymore and we instead wait on the session cmd_count.

The other problem with the patch is that several
target_submit_cmd_map_sgls/ target_submit_cmd callers do not handle the
error case properly if it were to ever happen. These drivers think
they have their normal refcount on the cmd and in many cases do a
transport_generic_free_cmd plus target_put_sess_cmd so they would
have fired off the refcount WARN/BUGs.

So this patch just changes the kref_get_unless_zero to kref_get.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/target/target_core_transport.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5c4adde96d5e..b5427e26187b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2775,9 +2775,7 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 	 * invocations before se_cmd descriptor release.
 	 */
 	if (ack_kref) {
-		if (!kref_get_unless_zero(&se_cmd->cmd_kref))
-			return -EINVAL;
-
+		kref_get(&se_cmd->cmd_kref);
 		se_cmd->se_cmd_flags |= SCF_ACK_KREF;
 	}
 
-- 
2.25.1

