Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB25C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BEC9610A6
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbhDJSlL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 14:41:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41992 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbhDJSlG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 14:41:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIeZ6L011118;
        Sat, 10 Apr 2021 18:40:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=gXKAqDNj1/Q/oSjnWR2QLiuI/lOj1MQgXENTK5Edmu4=;
 b=dih2oZ+fLRgMTouQL3O30FmaKDlbxBOLO6nDrfWYeCM4++uI0oOKW84EnkYw2Botfi7z
 crTzypruBbzliKJcxjORHKJmuL5pYVc9p1/nuznVGMqn1jjcHJ3aq3HIqOcZzoAz+BON
 Uz+GvZ/k7AqnbSHVOyep+2kqPuRUTYpmZF4iMtWbiv/f4Ff7fD/BOsK84V/Ht0OvIDLQ
 pg4zBzrw+s+0pGV27SJ5e05mLjdXlapvpWcd9J4tXuKFdzjg8DbH8+k8qG76YJ6UCSt2
 Dft0NUxKzL21R0rZ+jw3G+rRCtkBJvZAinXlxfiLUhnWiCkqTk5hkqATNXlMP18i+Ny1 tw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nn8r87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIThic176766;
        Sat, 10 Apr 2021 18:40:34 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by aserp3020.oracle.com with ESMTP id 37u3u1q4dr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNPgaCtPrai6CEWIhJGTcR68nKujyZh9JkaarnmkonM7Bnve5AyBAC8tI8SLMfH20mn0+3w5CZ4mssTPFhCXAFWmtn8X+5jZr4QK2+vazRd3L1mrmYTBWdX+DOIio5BfAoYKNfUcAsQnS14zKIV8FSpUjVTUqC+qFr7PF816qhkFxXBgtMp/WGe74IvbYQFaD6CuQ2sbZr5QxMvN/Z/fJx7YjGIUN3O37x7akc2qN8JqsiQUo1yyX5bq4+f+bHoNUcrybmjUSBzizNUn+qV2Wf8erxtuxDxL/DXYDOFZ94wek151bDJlrywAgIul5I+ULLfP9mdQyd+0txipqoaL2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gXKAqDNj1/Q/oSjnWR2QLiuI/lOj1MQgXENTK5Edmu4=;
 b=dnJFT+lRCU10XrNFwL4/j52XaBBeNXZ5Q7EmvdvgBCS6PCJ1B4f+IgzHNIoxaULo8rx4qNJiRr6MYd0J1eFjyNRlOBE+LTyHMyMHVr4szVheXEo6TcfVggxuIYUUj0LdWLvUUKHWOpiesKRSdB3a+bOLTaPBzBGN2QJUFrjK/eb0NJPWShD3fpyNl+cUV+ENukYrxWTytJdUa9Y9pmAwedMs+lJft8RFyOifyGRk/Jt2YmRxYUeh0LPDP+3qGuVthbHMn9zcjoCRXNXZ67SuQ7TEimWr7x9w347V3donIFEKKIWbHqBwkGQPZtUtOxzG5gWgiorGWcRGwwDIQJdNHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gXKAqDNj1/Q/oSjnWR2QLiuI/lOj1MQgXENTK5Edmu4=;
 b=fdeQe7tyejzY7tsp+DH6HQRcQ88YT5WFYuDQCVhzVShzjFppAXGNyM7cLqXljw8WT5lCyN0NGvhZDzYouKuDYnRRtP4YRfUa/4P/NUs72F4tIgx3jmYgVx2js1g03vs3aT/wwR4Ll0FDDAjtVqMk2VgwjC2Td2dFz/u8W3+NdGg=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4324.namprd10.prod.outlook.com (2603:10b6:a03:205::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Sat, 10 Apr
 2021 18:40:33 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sat, 10 Apr 2021
 18:40:33 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 07/13] scsi: qedi: use GFP_NOIO for tmf allocation
Date:   Sat, 10 Apr 2021 13:40:10 -0500
Message-Id: <20210410184016.21603-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210410184016.21603-1-michael.christie@oracle.com>
References: <20210410184016.21603-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR15CA0036.namprd15.prod.outlook.com
 (2603:10b6:4:4b::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR15CA0036.namprd15.prod.outlook.com (2603:10b6:4:4b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Sat, 10 Apr 2021 18:40:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28253338-a4a3-4fb0-7a3a-08d8fc501f89
X-MS-TrafficTypeDiagnostic: BY5PR10MB4324:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4324EBB691F74AECE17FE092F1729@BY5PR10MB4324.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:404;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yamycy+ag8mxiigSicbgQsTqv+/te8RTaDRoESawfHJPByhQ7u12B+CqkUje46Ga+Gtsr37Ggm3xk7LzvC6Bd+c4QXvjMSQj2in/TsRGVhAi42ZsQPyBo4iJ/DlCvT8hIcTzwN5E8tzCMaE1/wUgNLW5+GuCkPqCLuVEZg9R5Z97Z560eoDxnARraJK0vocUKatr3mZUTZnf4vqoaiFm/7W3ifwD6HR2MxLjn9rU5aQZRb7a+KTH5SXhqDBk12z8VWHRwW9dWdZ9oAyqjFbGXr3mCkL+4oGzPd3AQAvmdEWcV0GjQg+Nw/Yq+I89F57C0BSbnyvl5tZqAjNAfp8EKLB1+ONy+kMYr3bFRjxGwgEdSLiKRVEn6LoCFuNJQQ2o9N9zBiUQWzoohU5EY0eC8LGS8fQ+5htJ+iQxePPcZ722Yw8DAgnYkfN+yyc6AT+mBcyEB4LEZKn8hcZCDsF1VQ5OHT3Ja+8DL5tYbTju2od4MoTktFhzB6TR3MSMTLChPWRevH1KBmKK4YB9lLAEH7NUZizp4bFQCIrxz4xl7kwQ0oJWtJTNjCUYDmQjp/BRtcREgP6Xm2b6whjG8cZ52p0atUWbL6D6390UcFoFIurWv/r6PRigDRNoftcceJbmcAmvwlaPyRDWjDW11xpvHbM80HX+c/RzOJD45tka+lMtQZj9dqvjnDyivycUCOGK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(346002)(136003)(66946007)(66556008)(66476007)(69590400012)(6486002)(83380400001)(2616005)(8676002)(8936002)(16526019)(186003)(956004)(38100700002)(38350700002)(316002)(6512007)(1076003)(478600001)(52116002)(107886003)(4744005)(26005)(4326008)(6666004)(86362001)(6506007)(5660300002)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NHTfYGIc1KGnLlwWRsCJg9nYinycj7RDywYr0PbeWJmY3tk7VGTmLlVCV4BK?=
 =?us-ascii?Q?5h9lqs8QQn0Ccr+WnMViWbDyBOom+2watStEHMK78WZBsP3bBEjIqwjUExHW?=
 =?us-ascii?Q?zW6gG2ArJhGMppHUiKFbMsS+8GFRSVCp2qsRkJe4+9kf4SZesdfdk9cLQEqn?=
 =?us-ascii?Q?pkExlkKkf7nK5pWTTsK6eFPUkyyZ4k1PAceDxxNuNV2hSa1Abc2Yj2f+XIk4?=
 =?us-ascii?Q?oV6DmBmP0279ctdd8ib1afxS0LJofpNmrtDDoMQowfjNU+qtTyapvHGtZuA7?=
 =?us-ascii?Q?jnazmDXxx92Nl9kotgM4Uui/IvL5JDw0HDapkEKF8PYpGpTAk2m+YWLxENmj?=
 =?us-ascii?Q?NtaEr6abFji8PfeaMJu+sIcI+vBgGAUwY6o6UPet54JH2V1oBLOHi9HwTyca?=
 =?us-ascii?Q?ZEdpmzquSXbaOpGBjz8hYEUIlffM6X2J9ojH97iOoBmYJ9r7Bhc1iJ0Qwr31?=
 =?us-ascii?Q?AkEDN1rNE4V1ji220Uf+/1FXZZPW3h6ja/rb0uqUnoZwNshHB01cwxJfZGVN?=
 =?us-ascii?Q?J41x7wMF+68FbnEt38bnCU4SInfTDrPnHwahqHWAXVNDm1DTrbpZeQvXAS4u?=
 =?us-ascii?Q?8SHdPNSrkvKH4venXYnYVO06xAkO92L9FwsbP5/nkIiw3hrgn2dL0rtXfTT8?=
 =?us-ascii?Q?gSj8faauYlECs2KLDHwg+AbQ9pr0EKGjJGvhsRmbUa05pe2/nAfbkGa3FcNy?=
 =?us-ascii?Q?4IIfyFWiAvjVCdW9dO57+xGJKWWa2dXRWyQwD1GqqvcrU+5EjHAmmuVbJ4lo?=
 =?us-ascii?Q?CwlDlE7xUS3xG6ez0CMJqlgaVudAAUrqMpqKMxJWlp/n2K5+Un6T8Z0RPY6V?=
 =?us-ascii?Q?va/jqRzVtMnNuR3twnrK2cHXtOU/RRlCz4hrdnpEVQ3LnYh9Bp0a/DNWybf8?=
 =?us-ascii?Q?MBPf2qRWSdiSDXL10cQ9xjXBv/Dj8ySY68JDzbt2SrxQGDDiYOrlgOxWsy+c?=
 =?us-ascii?Q?EoJuNRWyEK6CWNi4mhZW/bUT71d7fuOeo8dXxfj3DOJ/q1j0c0s/5wbn0U2t?=
 =?us-ascii?Q?By/q2n6B3BhzJpRwzbIL8WoQzGCUmmeghZELjVTcEQ0xLbVHIlmvVjCHVb6N?=
 =?us-ascii?Q?XMDA/k9bJZv8ap1Yj/sR8Vltafv9JeNg73ju4FuxMLNIMmaan2q2ijX82lI7?=
 =?us-ascii?Q?Tdw/82iFU3d/3LrK3JJHVwjBDwuyNzk32pPcsihLO92WsZ7wL0qmH2t6NhRv?=
 =?us-ascii?Q?dPXZbuqCaQ/zektqdL/i8/LD4oFLIRHKZqYeCZMmm1JRKW8xfqsHcLGeiBpl?=
 =?us-ascii?Q?R1GgDkEIEozCQEvryEZ2+ZoEC/1Nfx7rEBYgRexoZshOG2iGJbI94jJO/VeL?=
 =?us-ascii?Q?BpXtFxnuME+huqv5xd/fOfQ3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28253338-a4a3-4fb0-7a3a-08d8fc501f89
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2021 18:40:33.1730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GWDOwgaDfudOnFVgDs7eJxSY20CXrXSzke8NwzfyGuXogzihEk2yIxaAf/dcUd2waTmxx+BDVsPyw8orFdXEusNS45/oda6UHp7Cggte0Bc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4324
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100140
X-Proofpoint-ORIG-GUID: GMTEIup_K2v2oiX5mEmDARs4gDneYdwH
X-Proofpoint-GUID: GMTEIup_K2v2oiX5mEmDARs4gDneYdwH
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104100140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We run from a workqueue with no locks held so use GFP_NOIO.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 542255c94d96..84402e827d42 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1396,7 +1396,7 @@ static void qedi_abort_work(struct work_struct *work)
 		goto put_task;
 	}
 
-	list_work = kzalloc(sizeof(*list_work), GFP_ATOMIC);
+	list_work = kzalloc(sizeof(*list_work), GFP_NOIO);
 	if (!list_work) {
 		QEDI_ERR(&qedi->dbg_ctx, "Memory allocation failed\n");
 		goto put_task;
-- 
2.25.1

