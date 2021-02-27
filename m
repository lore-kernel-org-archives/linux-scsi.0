Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94E9C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A40464E86
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhB0RJp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:09:45 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59208 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbhB0RCI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:02:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RH0LKa005402;
        Sat, 27 Feb 2021 17:00:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=HfnTdvYNAhZ/V14HKCFNOmSmkSA2UO5nPhFpVFbegJ8=;
 b=CgChQ2w9ycWhrerq6t/BoNp/stG7dPTckQWubjhJz1G9rvA1nz9ECbolLF1/NBc7Wz4N
 wDh9Q5Y6yaGT8B/qtk//bQj9Xum00q2K/J522VE2LipmE8FQBROSgkA5DGM4iyBVrXWU
 iEk+LzQKMGYy6264ono3VF49UURdc9FS7Zm9NDZqwkmTzrV/4Z2UlVavmbQDkXUktil7
 PlUc+gq6VV6q2GXooHt7pJC001fl3D83g4ZOpJpalWg2I4NgWnLTtWm1Rc/HerBWADl5
 0Onnn8X1AQHJp1W8+Vc4K3nera4sLhw+4CURWoUTs3deMxN3y/qQE5cVsCpY+ZwlXxNu tA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36ye1m0qp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGslmX115709;
        Sat, 27 Feb 2021 17:00:21 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by aserp3030.oracle.com with ESMTP id 36yc4a7jaw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tiyav7sP3YeOi9t8oXUUpsthDhXqJ5ItKQFzS1xrgZ+doU7ENUlbS/7PMR1/xyn5L/E0ZGgsZrMQLndFfPC5qc5pP8qSuuRxglHfQo+LIiMS31eIm5jZ2IU8B7BGZI/KzMQ8pPxF1zsUTqrS6fakWZc1MN2kIpKLwjyKzsG1ZDAmW601Iv+5q8Wuj7bgZW52Pf3ZHoN9vcoHyEWaCDwTOsq5jEUuV2G3Y3y046BcPqIE3fUpxLqx2jCvt4ZAThuX5GM4E6J+7q8iOvnWRFVhU2CcLXBzSwnYuBPYZfLGX/NSitoFq63Q1NK63C5iQ0azqyP+iTYGXkvkn2b+gTunwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HfnTdvYNAhZ/V14HKCFNOmSmkSA2UO5nPhFpVFbegJ8=;
 b=S0yJn9ccSSxmDAwXGGYCoAOwE7Xo7rn9/Oa2vP1/q4jxYd7ysjuW43Eh8IrASyQMeXK83jdC/vYlJu4Q+iE28jgPsmbMKMi1P66SJsxhansm8Tj8L2nTKmRLPmVrd6IsvGf4Mj6Pq2NqLT7ClY/urbAeE+Pw9PDmlGYLMzXdrgXyVu1z4IWywwemlPNzlBf6nHJIEmoTal4EHv+RDjFc9Z7MH1aM5/VVXOgODeFL89yPCF5GNByc6dIFMqhHJbnVbOcr1E6kRF2MpXaTgU1gCj11fmL3GDhkJGKAmXN5oki0rgc1LSsPynNk0sMTmcly2iDwItbvgP8UTFWPG6dyXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HfnTdvYNAhZ/V14HKCFNOmSmkSA2UO5nPhFpVFbegJ8=;
 b=z+tOgOO0dHR2ta92Lqwsn9LkgyRhzRFdc+O5RB6zc0Q4pegr0skI/0nojlMko/MAMGqr6wvVS0EcGPNpQW3n4TI3ald8phmVNGOmK/gpNmqUEvkpHzm955CPyPT3QrW1na5j6l/W6yUBknbpmAUJjiik/lL/um3pc2MvmRq3g/o=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3499.namprd10.prod.outlook.com (2603:10b6:5:178::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.22; Sat, 27 Feb
 2021 17:00:16 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 02/25] target: drop kref_get_unless_zero in target_get_sess_cmd
Date:   Sat, 27 Feb 2021 10:59:43 -0600
Message-Id: <20210227170006.5077-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210227170006.5077-1-michael.christie@oracle.com>
References: <20210227170006.5077-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:610:b1::32) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc3e12d4-4b25-4745-957c-08d8db41282d
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3499F359CF850988479B4B19F19C9@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gLXaIgBLrYLX6ztvSl6RefZ4vKGGhiPN1BzLGKxG+90MclJuNdTOSmJ5bUOo13V5DEJi/lB3NP/lmQC5Fb5rtWCsGAwBqy3K0i6MUPx0CXgjCCzg4qOHqD4MUnhGS9rc+ULSrBzWVD7y6MooEIYIT61X9PfOU40Q3H8TCvyh1/1fOwiYtzJCV99hMzSLxHbXT9d3AUOzdcKJ3ibo9xGpupZcOJH9QixNU/zqJbknRtNkNemdh2Z7l+rt7ZqwG+9OvOSBa1hCACTFnUfsDzRn12aH67GbKMCotQJa7ICbD4zgx0URqhNCryExr9sTGOvzyRjzw2BdphxPDPVgaeMoXNAZIUSK3287oXk8V7U6yYKgj2lBVjNq7V4UzKPsdV/T+rbAQ5s6sQQyknxpba/gA+PilyokV8GkjFcLvIl7BNrZ3GDczMDZpfca8dz8FVHJrC5PdpL3YKLJ5IZqRFHKKk8ulPwrSrbXvtT61Np3AGMbTWuGvZ5KDOtNBl7XFLqYC7EhhHk1vIuQA4hT15Sm73vimlK6MeYdVUBq5AL2gtDwEi/NMwSR9XoAKCUOdBFt3N2E7+obU9YsFblYsJIvtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(6666004)(956004)(36756003)(316002)(6512007)(86362001)(69590400012)(6506007)(1076003)(8936002)(83380400001)(2616005)(478600001)(2906002)(4326008)(186003)(16526019)(66556008)(5660300002)(66946007)(6486002)(66476007)(54906003)(8676002)(107886003)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3bCpelRz9CZNcIRymUI/y7p023FXGc6bjFqe0FSNAv6aNcMCt8E4AqiBHjhb?=
 =?us-ascii?Q?aJzykbtk+kpVU7mBD4Rn7zV02Fmv6Di0qm5S5Fge7dJh/JiyoMgXQqJPYEpy?=
 =?us-ascii?Q?R+kLO7EFsuRutpYFuQF8/cuen+XOVZIHCboqtLz2JcWCIEl+1eeQ/9XS54HW?=
 =?us-ascii?Q?VePnMHr7Epz6qT/FuNU2Cv+ZFoWZH1giCWMAPp2NZwm0zdNLf0A1KL8Plj9X?=
 =?us-ascii?Q?5KIB8f6pSjkAoxTVHO+GG7JpB7GCREBXs0w1CLWO2K+SJL/EJSJH/I7OlsMN?=
 =?us-ascii?Q?oBxEYfbaGCWRG1fAXdGaxti+jmAa2qgFkiMZvNeNUT2FA6iVuk/7jmJG55qb?=
 =?us-ascii?Q?8PNCYXx139kVL+M6ugDIcOCYAF2A39HhxrHu8iZWCQBeqrRrgem8T/gDy/d7?=
 =?us-ascii?Q?9ia7oNZ5pTfsvmuSV3Oqm83t2e+Yy6GNG0hzkiM5WNA19+zWhzsMuutVGZ/l?=
 =?us-ascii?Q?e7E63QfDSCPgYriDvhqMNOcLTH5e6FDnXnrRC/cyh7yRlvT92bAVRCfj8dKC?=
 =?us-ascii?Q?pacE9DhbXZzkh6JT3LbkXuOzL8foOXxEeFpmx0f+//rvBknLEwtH0iHZtFVB?=
 =?us-ascii?Q?MnELPzw0qRxxuvvlRVqymm0NERjIAkIYHz2vMb4VeCZruYv8L9AEqYsgaluX?=
 =?us-ascii?Q?AkxRJSst5w+1/foQT+WT9L0c+vBbry1fcOQkWw9/aOpWDlb4t7OfyR7dAjuH?=
 =?us-ascii?Q?9TEF+tHTU7ilnaZWXWRbP6ANRKf4Yn3NNGEJexkUwl2M+1uhpDj/8WRwATzq?=
 =?us-ascii?Q?ivw6GYRBzONdP6WkW6Yp18JH0cb0SQiHBhRwkgjsjtL4uklQq1fLbdmD4U0v?=
 =?us-ascii?Q?zD7nXbzn2YZoOL2S4OmM9ozEz6rbrVo17Q/E65ANJDS5m7H4c/4Dw7F+XAes?=
 =?us-ascii?Q?emyjkHfxzWJAm8mQP5RBUppLZC1QBzb7xYvXUpg9GQAsgk1o0bzL4joSU07E?=
 =?us-ascii?Q?EasjCNe6YwEzE0vWOhy9dD3E5BZzPz8IvGFaVR7sOBco/THZK2WsnshARPoP?=
 =?us-ascii?Q?5o6zBAifpdT2r7bX1rry8xbvcq6Br/lcF8iwcbO73wBS/aVssT0fd01r5L5J?=
 =?us-ascii?Q?SCJKVqWZlspErjDy/B6emnWEfn/h5icE1/y1CxfGiq8a7isFztM8qd2gmgPC?=
 =?us-ascii?Q?mqZ8rWhCI51F/hU3cMQ3JL36jOUJgowEfh5B9pxOW7k9n1TTSycvo1YkrHol?=
 =?us-ascii?Q?qxS6wSELGUnM2eJT7ZT/sTnbh4dGa2wOcmY1wAZOJvtmeviaUPhXcOChc+HK?=
 =?us-ascii?Q?nlvfXvF5AhjsC3GOb6vq92ba1hls+00tuIa6utda7GSIG1WTmC7lovI1VxkD?=
 =?us-ascii?Q?JMEPfi2QiXmCtnzLbFPUhq84?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc3e12d4-4b25-4745-957c-08d8db41282d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:16.8307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Da7CqfhcymR/CXz8yd86KvWYdBSJKYmLppwAVcvszkm7rN7pFxwEhx7jBxXEl8SF3K1GX6ewz1n9JeuDrFIc+BfDEysvtMVM07CkJO2OOU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270145
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0
 mlxscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270146
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

