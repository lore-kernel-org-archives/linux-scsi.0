Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BAD1C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E9CC64E84
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhB0ROo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:14:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60512 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbhB0REm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:04:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RH09AK005209;
        Sat, 27 Feb 2021 17:00:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=OwyHFp1kW2CgIqRPRzsgm1iyAz4lHmZp9HU4HYM1yQA=;
 b=A5zjLwTMUzCSQIqQu+QooGIWWWjQevTHwoFGWqRQI6NpHaW0wD5A3FhZTPJS2wy+C9Zk
 HciNBajgw/6pZJNoOiQwDNdK5dcvlrLBQ1V3Kt6Ng6VyJ1Ov76Lrq99E07gsU8LfIqMM
 BxVWxYlh1SaxZnQVPMm6sCW/Q+KRg0on7DteGS9WOVN0E6jxC80Z5YQCIrGV7zj16dsD
 i28QsIt1rDQ1wpVPrVhwz3XhMIZGq5+dulxTKWaqXHsdY4++eGUkpNLPEgHjObMz8N3J
 YCMGxRUtvl38K08bYeAtOLvu8v/OnKpZXe5Vqd6gOCj4MCbD+O2D0NoAHG5orIreNTJh mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36ye1m0qpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RH0Mbm173209;
        Sat, 27 Feb 2021 17:00:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3020.oracle.com with ESMTP id 36yddhy8te-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xwnu+flGp2SNdfLqw9m31e2h/dQXFXYNxPPSAx+sWD+9u+mf2L8uYmirckzKAmdNFBtzZF0lIe2pAO1uaU3400ru73a+atIkBVqHywy4Ei++eWRHS6uA3u3rN//6k+vbmzSR3fmLbYNM5XYLiYNKnSjoj5Hd7vBj8/sPJtDfUvuR6GTqW8Yzuv8e7oaUbGRfwW5eUkB0cMFMjaC2uGKXpXEDsAADzUj/XdrHhlEaSZwCCIdaKfZLVqxk+E5w/Hag19jjQgyL2VzueINKNf+7OkiIAf0CodEbiqKfRw0Lwhg59rmoYrxxCh8F2bFcSBUxbMWy8a5W31oWTkpZilj3DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwyHFp1kW2CgIqRPRzsgm1iyAz4lHmZp9HU4HYM1yQA=;
 b=Be92DOXV50gbJEtAhAnP0cZq2QCy5thcWK/tjZDnnBHYKKS1dcFpNpVsuTJxWIPwcn9Xw1Tl5WJqD48vedC8tt2S6diGmSPk29iseClE1j2Ox1Ke6Xz/wscCRbS+ER10lndVR2CUlK1ZXPkATnOxxWVMyMSRdHWiGsl7VoLjAGJ3YayqZzAPbpc2QMcL7bPAXGf2iRxUz3tmo3CMeX70aO+U85gKuLmG6ZVirXUCh16gIW1Ari8hZfv5eaQdB5YKd9N/GyRjur9cvMNl7B3yL9A52bjLEIpz11cImFMCgEnL0zzN+TDKCSv9hUBUCsmiV4nst3mVOGd6aPlaSsrvcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwyHFp1kW2CgIqRPRzsgm1iyAz4lHmZp9HU4HYM1yQA=;
 b=Df9pbLO5R126eTIwODuq/rV63HKeyD3s5WTWGJsMPTArR9cLiDgMBsIBTL4lUmGbTRof3KU2G9PeG0EYnesl4DFxVfAtF616WCfMBDSzVqPnQIAtV2dfLXYEeyW80iqeyBJuInzyjZLTHMHdWr7lgaq4CArjKMgRkx8gyIRpO5w=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB2538.namprd10.prod.outlook.com (2603:10b6:5:b3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Sat, 27 Feb
 2021 17:00:36 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 24/25] target: flush submission work during TMR processing
Date:   Sat, 27 Feb 2021 11:00:05 -0600
Message-Id: <20210227170006.5077-25-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1992eae0-7692-4df8-aa62-08d8db4133ff
X-MS-TrafficTypeDiagnostic: DM6PR10MB2538:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB25384715009AE2FF240167C1F19C9@DM6PR10MB2538.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZL5tpgl/My8MGOHEH7wA+wGaEaL55ujOzvUP//9jXq4NGj4wH5gHhTCVzeFdLF8atE+kN9dan29Kq9OYqQGfrALxPBwgFdCzqusOsoMIjE80k+p7J/cMW0qyMyxxAuPYR5I9X2ICWUmlTjM8CtPG1VNfBspgrmWX6Ot75vjzrbHCVD/0vklTkxZ3d4uIlJrmVza5GeZ0uYg3dpGB6F5M7/ldRU2WdtBrzGuMYnuGCxc15vBQcEBc3VI0UDINcX9ul/nyliySsennRdoxDVDosD7ofD6FFaXLvexOAeGeBBhg23GgtPqXJh5tyG1iC8JIuXus67JNebgFav9j3xWvEQM0RletFktyZwPQwhlM/DkSwfrDMaVHzWzxiAl9+k+hwyz5UNSaKmLEZqAIFw1kd3KmiTZkdxx4QRXwXWUEfSv1Y4l7fRgLZvA9LpFkf+lry7X3Xkrv75hBjIY5CccqKBW1tB4sbghynsQXdV3Ms479hIAO9vpy7aFbYLWFh+Sn5u0eOuxJZTIbErC5powH+o3K5jsKyPg9OFzbD+ilu9VYxnuhCFMIial2WShmsNzisCBtlldJAmDWL+u+8LK8UQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(39860400002)(136003)(69590400012)(478600001)(36756003)(6506007)(5660300002)(4326008)(107886003)(83380400001)(316002)(52116002)(6486002)(956004)(2906002)(2616005)(66946007)(6512007)(8676002)(66556008)(66476007)(6666004)(8936002)(16526019)(186003)(86362001)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6ym3fpc9jw9Zf2f1GM+zRBUYOliz1pjnlX42Eieg9ln5WfznzaiT+1OHSmv3?=
 =?us-ascii?Q?gnVbUbHtzNDHZchvfkVoQaqQcAnm0SmoYlulVkaFLpPcWL6tPsVG2IQCeK/b?=
 =?us-ascii?Q?EUrazn3EytBa5PUVtIwGMxhSdGYC1+Rg1qkYXHYw0B0VEahE450FMKs3Lt/d?=
 =?us-ascii?Q?grMOkFfoi1kSRvzbjBAIK/qRKcuG8HbQL+r16sy4R+iuHia6+TUReWEd2GnQ?=
 =?us-ascii?Q?9ZP18Xd0pfVrdLCBPT/u5+xVCLU6LKJ6b3Ltm+96sm7bOiDhD/QMekpgLsp9?=
 =?us-ascii?Q?kH5/FtevsbL28H3y8+Udxp0Dip6ZK485Nd1uqmjhJSnKIWt5yCcdP7IbC7qH?=
 =?us-ascii?Q?4YhQafM72x5n0kxdaEwHGTyjZ7KdQ5B21tLZGGXvao9nqtNVBK9m8StaeDN7?=
 =?us-ascii?Q?iLphcxjI7L3zkkL5janNAz8AJ6w12pduloO9HdKvhmturfIyu79vEYFlc+t0?=
 =?us-ascii?Q?GKYMRuhQQFfqDbaf6xqpurwqpn/q0ipsmH9ymXtZgVK2ulwS2wQycwdXUDX+?=
 =?us-ascii?Q?4fpB626wn57znKLwunCQEoswXcNHhPTzmsvwK8Dyd1KwpjTvGaGWVeNUdDbT?=
 =?us-ascii?Q?SZ8a2SSRQxV03HfPLJF6e9qhozshikae4URfcc6HBc0NLMFWn4zabKPbj6y9?=
 =?us-ascii?Q?kLpH2X9OYFalJ+s/ef1gBT+miJy8qBKhapyUZCXMump8SsDNe7+VPWpzCH8x?=
 =?us-ascii?Q?LBWb59IJmCTc8qyBXiwkKk75hkOrpsGiDarxKz0JYF85CykijS4/qBNhLSBs?=
 =?us-ascii?Q?EihQQ2Tlnwe9cs4aP4XFGPC8Pq5akw4OYXY0UUicSpj6IYqRXGAH/PLrY/7/?=
 =?us-ascii?Q?6Hx7GaCeabXLIRWsubGYhEzsrhy1xWbtulspFkfUCmPTzuOmuJqnPOAVOKAq?=
 =?us-ascii?Q?02qiE3tvXLtdvOsfzvH+S/Q19sfBt2VcM791040lnhcNHTtnhenwLOmBqAWF?=
 =?us-ascii?Q?KuJvCsv30eoUvVwIkFOOd8EKJhSgBjqGTi4C28Cvg/WhvhVbnK28LaRRemBD?=
 =?us-ascii?Q?OtMHitmFLn7r1GJh+UKdeC+zAFaSpZz5EEYuzdpUDxKl3OJtjqyfL9wom7Lw?=
 =?us-ascii?Q?beKtEyi3gYKhdazlUBAs3dPiu9a2LSuVgypHsoFa73NNI/CTdBj4i+RNjD2F?=
 =?us-ascii?Q?5t0O61cMbi7hqhkJHbOHvrP4eHa9uMMS/9I94HWUCEsnNMdFWyevxDoTQZcu?=
 =?us-ascii?Q?N3zuwzYmOb12mHuFucHKql5YMfmUbu+GbOLYOByqNmxSXyUbAw1UnyWjs05T?=
 =?us-ascii?Q?tpdr9Zfs7MmX0yQ7jDcvt6EG0zB/XyVNlFFzbV+ldx76pE2E2n9UhOpzvw9Q?=
 =?us-ascii?Q?cj08jMro9T5qBnIG+iT61qg/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1992eae0-7692-4df8-aa62-08d8db4133ff
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:36.6444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g+Fkbdo2uJVBylfeCRXfsty0uqId45RfLfS/n5pfhsHPC9jhYzSBSRSZdoeO9wqrcqn8I5zeZhbS5ygg+hpHWoiOl9Lh/Nh0UD8ToX3L34Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2538
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0
 mlxscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a cmd is on the submission workqueue then the TMR code will
miss it, and end up returning task not found or success for
lun resets. The fabric driver might then tell the initiator that
the running cmds have been handled when they are about to run.

This adds a flush when we are processing TMRs to make sure queued
cmds do not run after returning the TMR response.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bodo Stroesser <bostroesser@gmail.com> 
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/target/target_core_tmr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 7347285471fa..e7fcbc09f9db 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -124,6 +124,8 @@ void core_tmr_abort_task(
 	int i;
 
 	for (i = 0; i < dev->queue_cnt; i++) {
+		flush_work(&dev->queues[i].sq.work);
+
 		spin_lock_irqsave(&dev->queues[i].lock, flags);
 		list_for_each_entry_safe(se_cmd, next, &dev->queues[i].state_list,
 					 state_list) {
@@ -302,6 +304,8 @@ static void core_tmr_drain_state_list(
 	 * in the Control Mode Page.
 	 */
 	for (i = 0; i < dev->queue_cnt; i++) {
+		flush_work(&dev->queues[i].sq.work);
+
 		spin_lock_irqsave(&dev->queues[i].lock, flags);
 		list_for_each_entry_safe(cmd, next, &dev->queues[i].state_list,
 					 state_list) {
-- 
2.25.1

