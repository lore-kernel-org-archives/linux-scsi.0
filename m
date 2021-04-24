Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD392C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B543B61462
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhDXWS7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:18:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37412 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbhDXWS5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:18:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OMFgC0020795;
        Sat, 24 Apr 2021 22:18:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=UEf71SpZ9KBLYTX4Ep6+i6fQMU3igzidcPyDnBOVGtk=;
 b=i5UD5PYD3A6ps93s75gvwGTS5ZIONRIqIfuzbqS3D16Z8A0MN8FDpMiQEBAxxF6CP5hS
 ZnQWgK9aFRgSv4RTp/EXkfNJ9XRDaHOEZSgidOAxE+7j9BDueByM5l9f3j4vRaFxM6sx
 Z2ZuDJphMeMlo/DT/oPs0Rb2YP/tEjm3bpf06q8BNn4ECX0MHbYR2KfXlwaia79b12Np
 sAu/SpO4BeSAtT1PIcOAhiLCNsrXoTtYnTOwD+zH7ZTA377TgZV6jjsI8inNakqb6y3B
 tSXqwSpj48XbaQ1vgBsm2zCTfildoyzfKcZnY39/uWK6gOlsbPYZkhEWahfrjTaGyfx+ Qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 384byp0rr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:18:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OMAPi8148236;
        Sat, 24 Apr 2021 22:18:08 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by userp3030.oracle.com with ESMTP id 3848et2ejm-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:18:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AhQK7CKTf0QqvUNY0774bUgr34bH2sFeMtmSOzNiQE9RnytnLsQrZyfuV2ovVZ4UQZcprJyvMB2k5VHHicEHPGE45luBZzlLWGKmQJKT5mFiaex5cK2O4+9iE4Ecf99VFK5HXvH9sLJ4rRSRQ/qgUlvbL5owBRAJqO1Ch8oyrG15yYTOvCrFnE0PtC4Vj5Mqo2w3eHnuzje4wWJdotmwMiXkS0I+US4TuASMdScAUSadxlM0nDPQvJSHVf1U71PeO9XVMwPGk5eHaKe4mLiFx/8hhyN9uXRKx7iaj4ARdf8S3AYrRrMlkZ76xGtuW6BKv00nwUYcJjwJTIa73iPqHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UEf71SpZ9KBLYTX4Ep6+i6fQMU3igzidcPyDnBOVGtk=;
 b=ElAzXwCfZjXfk7laPNfKp/swufwMGA9+7rRDMn0E+Mc30RgXDPSDa+FA5ziJTTX+JrxBl5Gm8Q+xqYYp/Hg/rVzDdqvjC2Gj5EqHS1t/wqCrEfHd2nL6ow0tgZQuT3uy8DcG4usfrTyxlq7er/wQAVVmKyEOlG3RrRSD42nKRSdNB4SEFv+aKcbj+PXLA9dM5gSaxAytslu4adeywv0ZR05eqPZaTrGuRdp5/4EeNIS5syROv+PfIPz6xkDiYwpxTN7om/3KAkP455gVHP21AGgOXnFrHJz3CBrJrCBng9m2tqTUjSbDzlEuSPk37MFI6e+cLACJ65MKNSrUpfeKVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UEf71SpZ9KBLYTX4Ep6+i6fQMU3igzidcPyDnBOVGtk=;
 b=fVAhLUhEk2PUEWVFQLLv7LaeFbG6ZpzE1Qdjy5LrAsor3e6zpROdAVy45gKUzXzHP3NXyAq/S/bluln82xneV2vpzwT3/uoS7MXll+DwUBWMrOagt7U27LrBsbBzHC1UebuN1nWMADfUMzpHgnhOp4GBV1+pNlCksN9/rn4KKkw=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2885.namprd10.prod.outlook.com (2603:10b6:a03:82::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:18:05 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:18:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     khazhy@google.com, lduncan@suse.com, martin.petersen@oracle.com,
        rbharath@google.com, krisman@collabora.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 2/6] scsi: iscsi: use system_unbound_wq for destroy_work
Date:   Sat, 24 Apr 2021 17:17:51 -0500
Message-Id: <20210424221755.124438-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424221755.124438-1-michael.christie@oracle.com>
References: <20210424221755.124438-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM3PR12CA0079.namprd12.prod.outlook.com
 (2603:10b6:0:57::23) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM3PR12CA0079.namprd12.prod.outlook.com (2603:10b6:0:57::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Sat, 24 Apr 2021 22:18:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffe7cf2b-bfc1-4879-944e-08d9076ed4fb
X-MS-TrafficTypeDiagnostic: BYAPR10MB2885:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB28853D2124730CD4441849BAF1449@BYAPR10MB2885.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OJHndCU17huYqvllXmFwmEAat8cRJ7NKh++zlzBWl1L0oRAoQFxC8wkwRFAVbfRmy8jyiQKp74ovSAvXQYxV4x3XqrGdA+MLeOp24sghhjsLsf06/pS6jHGSAq2z/lmJi2iId7O04hHAhfT14iHd6Lf5IU71YkOcx4mr6KX1OPay+kGN+lm70jaaqkPx9sx7w3Xp37L3ifQ16iTRMfw2ZU6kzbv/QJX+PpIj1DeFAwI4I/eQdhbGuzfVjBn7z34lo2JwWB5TBnmE3iZc3yE9Vgt7BQbo+DkAfbj5nMBGZwEhoJfIerZArdAgEoEnasEZbCDBHh99YgvmR4aoqAfs3IyPgeIM+diRvRcyu7k30GErvJaELFaH2OCgIMWKzT/Xjb6I1Rtqs9bkG4CZ34ICw5aM9GBjLdFnBncA3ushdpHetwcvmq/5hUtoA/4AZUFsvVH/Xu9c/mcjKSbAOLRrvodgwF33oonVYOnoTpsVDOfaJ9ZgV1+5s82nlhkVbUbPylcDjqSw2TjWzR4LSB0CODtde+A0JeOtwSydEm4KLUHNPQps8RljMDkYlM7lljLsaEuEPL8JqsWBDb7bZ1VajLE2xUh8+NnwHFSXoF6K0kOE8tO4jMwlb+oV+dtAce+Gukesv9yClI0XJ3kXdA+tap9AVffjQGoyQRXHSatu+xS0Vp2b9iUihwQtA49ohr2A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(376002)(396003)(366004)(83380400001)(6486002)(66946007)(66556008)(5660300002)(66476007)(38100700002)(6666004)(4326008)(6506007)(478600001)(6512007)(107886003)(2616005)(186003)(316002)(36756003)(52116002)(26005)(86362001)(2906002)(1076003)(956004)(8936002)(8676002)(16526019)(38350700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nUKTTGkmxRBkwsTj6MCRSBkUXhilhmbkmXVSn/BEJJjiqCqo6StuDMmt8A6X?=
 =?us-ascii?Q?PwtjN31TIFmxsrZOnFbZ2CX9sAJZ8V/Hh75m+CXSMUMXM9fuGgyUmkjoYyEo?=
 =?us-ascii?Q?5lLwkGdJhQAlugWxfsbnqhIuHkbV01T2gdku3eHJuIGdpuYg408Jym7Z9HAE?=
 =?us-ascii?Q?7VDLun/cqZl5hX/wvpBNSePqslUp/xKieIkAvIDQNTcr2YBirZBwbudxJC6V?=
 =?us-ascii?Q?6nRutj2oY6hzScyAKWs8T9OCi+6EL2lSojUabl9K28YC8ML4Q/Sa1k1IV06L?=
 =?us-ascii?Q?gnV2qsfZ76hpIgwBa9MSGzH+HLIumeEAs0WpC/HYJl9vAnKINQ5B7vQT4+rQ?=
 =?us-ascii?Q?DlwhYW4ytGBW7vFXY+HhYQxvSvLLrei4UseM9yZMoHu1TMOkXTKV1GvrDdLw?=
 =?us-ascii?Q?bZNvJOP0gV66mAJ/0+KAsIiqNZJdi/rzItsTV3F7M/Oz8iDVsou6SJ+X/2AU?=
 =?us-ascii?Q?oZrz4O7shgM2HCXePXgDvmnz9MdgOznWq3b4oEZhCd29qMynfdhcFBkqX+KJ?=
 =?us-ascii?Q?EghYhLpqn0uLZtItnJ+ZHCTmitPGfwp6Lt2zZQibgTYOW/BtGBLMzuDa/NVd?=
 =?us-ascii?Q?Qdj3JS5ZI3pP+QNB+XXdd6DiMLbGcKmwSj0CoRHtF3tm/vyQIHbhE7Kpl1KK?=
 =?us-ascii?Q?CScgojTz0gYDRzJX4ZiMYkmIdmkQjUBf8IIHSq28xHQWjHh34GuyfZHZ2PQZ?=
 =?us-ascii?Q?gGn04a2f4JV+4u0vG1CaqruIZVc4a/pUcN20IZdD4cB5LZG4PIxzp1GMRpq6?=
 =?us-ascii?Q?9JKC2lwL0C2iTkv726v0xSLwGPvxXzzkMMpo4fkq4crr36gQHYTKLnuDaEf6?=
 =?us-ascii?Q?NHIiuAVy4LDLLIssXyvnV3z3WZUMZnVJIlUtq+mqVtjPMaIJ+6RuyE9hTuEL?=
 =?us-ascii?Q?XrIRWHbm4alE2HsxKQtl1eSewrvVMS7/VBmaAvwM0k4UTvGzk5noopfNjElm?=
 =?us-ascii?Q?C5wtN1FUcjFa9eQc6XQCpwc/grku/oMxEYcWyKDT5Uluo5q4sziJcTd7nGss?=
 =?us-ascii?Q?ixwwnFq9rXTDRrQ0LRfJmjinqirBtR2XFQyV0bksn5uPA8g35ZBehyhRMs94?=
 =?us-ascii?Q?3hE1pmOo3vrn7et3WiLZzXprTGQGmZxI9jX1xApwBmNqgmRpmmYtvhBSzgYt?=
 =?us-ascii?Q?Rce3jjfAx1ETbmhMAwTNlULgbXuHhDayfcMCludaUslJPqbIKwiyqGQe+AKm?=
 =?us-ascii?Q?CawFbdjhsYPlrgQnsXrA7T/IU5H7/jLTwzz5BKf5gd4KfpIr4ilmVi3d7Rl+?=
 =?us-ascii?Q?vR9B4weCe4Slmq6t3rEg85t7rR3Y0j5jDxu7JuJeJZBjo21aKFNucl/kTZcf?=
 =?us-ascii?Q?yrsfymwV+tJajyAz6X3YBdED?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffe7cf2b-bfc1-4879-944e-08d9076ed4fb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:18:05.2129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KUPSpb8FHfKKVKQmZ89x3lDvk3bywjSfnztEpYlLJ5ejZU5ZUXYS74bGag+QLq5J1lcgGP+dLbr1oVAKeK9G1BiGHa6ml36Ettapl1oD1tU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2885
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240169
X-Proofpoint-ORIG-GUID: RfKTcVmDB0pqA5UNnDEHfsUKd3sfhAbx
X-Proofpoint-GUID: RfKTcVmDB0pqA5UNnDEHfsUKd3sfhAbx
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240169
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the system_unbound_wq for async session destruction. We don't need a
dedicated workqueue for async session destruction because:

1. perf does not seem to be an issue since we only allow 1 active work.
2. it does not have deps with other system works and we can run them
in parallel with each other.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0cd9f2090993..a23fcf871ffd 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -95,8 +95,6 @@ static DECLARE_WORK(stop_conn_work, stop_conn_work_fn);
 static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
 static struct workqueue_struct *iscsi_eh_timer_workq;
 
-static struct workqueue_struct *iscsi_destroy_workq;
-
 static DEFINE_IDA(iscsi_sess_ida);
 /*
  * list of registered transports and lock that must
@@ -3718,7 +3716,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 			list_del_init(&session->sess_list);
 			spin_unlock_irqrestore(&sesslock, flags);
 
-			queue_work(iscsi_destroy_workq, &session->destroy_work);
+			queue_work(system_unbound_wq, &session->destroy_work);
 		}
 		break;
 	case ISCSI_UEVENT_UNBIND_SESSION:
@@ -4814,18 +4812,8 @@ static __init int iscsi_transport_init(void)
 		goto release_nls;
 	}
 
-	iscsi_destroy_workq = alloc_workqueue("%s",
-			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
-			1, "iscsi_destroy");
-	if (!iscsi_destroy_workq) {
-		err = -ENOMEM;
-		goto destroy_wq;
-	}
-
 	return 0;
 
-destroy_wq:
-	destroy_workqueue(iscsi_eh_timer_workq);
 release_nls:
 	netlink_kernel_release(nls);
 unregister_flashnode_bus:
@@ -4847,7 +4835,6 @@ static __init int iscsi_transport_init(void)
 
 static void __exit iscsi_transport_exit(void)
 {
-	destroy_workqueue(iscsi_destroy_workq);
 	destroy_workqueue(iscsi_eh_timer_workq);
 	netlink_kernel_release(nls);
 	bus_unregister(&iscsi_flashnode_bus);
-- 
2.25.1

