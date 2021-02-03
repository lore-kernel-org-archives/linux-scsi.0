Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 347DFC4332B
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 03:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EABFB64F84
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 03:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhBCD3K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 22:29:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40612 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbhBCD3H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 22:29:07 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131XeOG175736;
        Wed, 3 Feb 2021 01:34:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=eLvjdxoSH/zTAbl4x6JLodnVmaUEkNxPVYI0EocdgXY=;
 b=x501WBk9W5xKgWFFzzZk+DnrHXM4t5aCHN2G0bM9UZsqLlVvnRA97WTRMdpfPURt5wTD
 eiPWrGvU0HfscQ4eL3QjKpNUDPRjh6Ht/bp25MWcQMQKinBmZjsAhEPW40W0lmasM00B
 1STpF4GGKa35ASXttyLuA7asw54RMHRtVHYBJsAoHpAGvQFu6hpFUZfxJHBR/9Vyz8Gl
 ffwJOSwWHKMzL8DiEVlFxSs3v+gwZP5u8ONLM+62I2aWCBLcPaboqhF0jURFD3hvy+s6
 nYSiYAFxyESquy8nJz6AZk80AsU45I7jvYPZKU7khAZJNJMP+8s+91poDfTXdeQdDso0 eA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36dn4wkgg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:34:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131OxjL139717;
        Wed, 3 Feb 2021 01:34:10 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2058.outbound.protection.outlook.com [104.47.44.58])
        by aserp3020.oracle.com with ESMTP id 36dhc05qfv-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:34:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ms361j9QYeURrkcPB6jiZEbJj06AgDGcv8gPpgeNewjSkVuJUhMEkxRILL8spXndru6AWU+voAGFSIGb8V020mo4BW5k2mR+kGDRniP8UYGZwf9eScLl1sjC7O45ZOpBa27mjvdA9KZBiGl828cWZmPq/MKBPBL9JjSR6DKGqC1sUOsjbPGOYDiXMa7SO6OjpwOpVuSFvWTWNswagqg9/W26ceM98IATt2x5Ir+iZChE/puru6bj6dkVHFiRCDUi3CwFu6ZsuSxHm4aZsZLSogx5vADmKkWcH8BLSvq6lE6bypbbqTwFxiEtEmXNXz27cjAD6quEdnnwE6jkpfaXrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLvjdxoSH/zTAbl4x6JLodnVmaUEkNxPVYI0EocdgXY=;
 b=c3v70tw3F5Wz4gf49P5V9/eKXpBFzQiNlGZigNlPEs2+EQp+sBxUXNRdOfo6EE+Q7/Kej9bD+LJFjs0kUhxn1kaNIOCxpwJEiZVq+L6QWPZS1v8T2x+h9F68eKkjIyRWgO4OANUiM00VlCVO9QKd/bKQWPA0IeHY+nCvZEQvKPh5Ap3UjcYJqwlPmM3M0lbCStOQV16g0K4ZuZ6nwaPxIL+CGLJKLk9lj4xNZt7QckjpQ9vk79bEzn6+Hqof6jJCGLT764zKpDSzNksOZlw2+cONmbMmruyoLWDLBNqilGo6oaxmIhjSnNsD5S9Ew8DZv09ofg4wSKRXHwk6XLsB2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLvjdxoSH/zTAbl4x6JLodnVmaUEkNxPVYI0EocdgXY=;
 b=lUikVHehDRzxIp3ptVNN2tpV6+KuxbwAm1QaN34jouziME3u93p7I3trnoONQIP24i65taj1vBFEUkmP+/GgOnuAfD290DcsM00QrMoJme8IQFyumiLm9tI6TudqS56A5IwmYlqYx9cZwI3akq+exgDI45KjtKuX3dQmA+CBxB0=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21)
 by BN0PR10MB5320.namprd10.prod.outlook.com (2603:10b6:408:12a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Wed, 3 Feb
 2021 01:34:09 +0000
Received: from BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86]) by BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86%4]) with mapi id 15.20.3805.028; Wed, 3 Feb 2021
 01:34:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 4/9] libiscsi: fix iscsi host workq destruction
Date:   Tue,  2 Feb 2021 19:33:51 -0600
Message-Id: <20210203013356.11177-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203013356.11177-1-michael.christie@oracle.com>
References: <20210203013356.11177-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:610:4e::22) To BN6PR10MB1236.namprd10.prod.outlook.com
 (2603:10b6:405:11::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR02CA0012.namprd02.prod.outlook.com (2603:10b6:610:4e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 01:34:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb30fda4-5077-41a7-f58d-08d8c7e3cd76
X-MS-TrafficTypeDiagnostic: BN0PR10MB5320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5320C2074CD9FF13653E43FDF1B49@BN0PR10MB5320.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lBDQqNibluZty6iAZ98Fp57G1KxKPJUFh8sqdngwZadkX0oJSYIkYe2hwtLDplvD9dgAsTI3bgzLlKkWkTtuHXtLwpcyJ+0Rttg6eBK6oPBJ5tQxKgYm40EBh8F/DHc7k1baV/AVPST8/K7MaL1vXMdd58NRpK0Zsp7kAgWvpjzEQCrVDGB37p0aT4LIr9Mib0ELFw3WlMwvOBxFEcT7NazAB3Pf7t8UbvjNLLpnfzXGsG+6FM35g6rSZhbg5xD5q5aaKVe4U2lfJGZCR84CuegU2vd63PMMq7vzzpOwZV0e98gQ8yviaeLqnPKvDqsnJEHnd6J7hbyk6qHEkFNAsC2ydkqn97C8wY/Y7/56DSEY5JqdfnAqv0glibYS61Wavsrj3V9NrNKkfMwZAGJNG05CeK+ditnuNLAPAVud0xAiKtPNDImEqm/oQHsxL6zuZV4CQouu0t/0tlAOKYuN5Aj//LlkSz1PeBs8ajgG5esJnoXF6HrssKIxEGUPt7NxEri7gVkEuSTlA1Id0MHLlAyYHcOSD5il2jYSFKVm9KP8l/LNdEjPIiX6vF6wqJce5eTNFDmrQQDoL76t6wCyIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR10MB1236.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(136003)(376002)(346002)(52116002)(316002)(6666004)(69590400007)(956004)(2616005)(2906002)(478600001)(86362001)(107886003)(4326008)(66476007)(66556008)(66946007)(36756003)(6486002)(6506007)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JHEADjSIcMHoHJD0jByvRvd6xheZHOjmRo9oIqCJmsfk7uZpMKoUp7LSrDMg?=
 =?us-ascii?Q?ZiVCKmDzxZECY08urR7c62jfRaJIJeAwyBPjho3zjL7z1paatWIDPG9gJdK2?=
 =?us-ascii?Q?XYxKQZklzibOXwhEAmo41zfPNuqBv5HLmnPWDGdIcV3+uOoVoBnSKSLSvJTy?=
 =?us-ascii?Q?MLLBu1tGiCobo6uBS99yRDUl+qEdhPgeeWeXUTDjJ4lmdPmMJCtOOSW2LEeR?=
 =?us-ascii?Q?u6khn9m/BVZbdFHZqKizy/QYYeO5lnzX8ILzcGiVvfb8NnT6WmGB+02Mr6+d?=
 =?us-ascii?Q?0cHFQWmKBB0uiNhVGFjhKqyuXLGtrbvsW1FdWEgy2b9KzwEQSo9wMzy/QhY8?=
 =?us-ascii?Q?FPUmvQto6gjiM/ypBvltFeCGwaNpDpszHCDAWmmxkHmEUte6VOH0df2TdgYs?=
 =?us-ascii?Q?ZC8oCLXVFqG4VIfsCzm4zIQxcNEhZlM2bX/P4noRy7PT0jS+m1VrVRzatjCy?=
 =?us-ascii?Q?qyGmeZPqYXBE8HOOOzxlNYLGtMm1VbXloJUDZZd/o7HsrSFYjRzKMUJMxgDx?=
 =?us-ascii?Q?x7/xUBugpX3o4atXBJhSRZdmp50R3IgGEh1ArU17hY4ZRwhBKLDHBWibL8jQ?=
 =?us-ascii?Q?9t9AeDopeOUSI2SwqT7cuIF4nPxdP0qfRsK8XdRcDnfDkkK9eRWt2AE6ERmY?=
 =?us-ascii?Q?lR1N3dxoS6f7QE7th0oQa88cxzknxfiCU4ak4EZ4IqutntRnVOZbvctu3gfr?=
 =?us-ascii?Q?2i7s53EIE3LrwIPRKRALZEna38yZrJ3ZU4p+1Au2TuE+vjLj9F4tyfnfCBLR?=
 =?us-ascii?Q?a83hZwN7ifqiyz8PQQOsaFVd5VnAlb2b+y/ue5seBkgkTmC+gGbPeH4ktNvT?=
 =?us-ascii?Q?Ev1X0x5+tgRGHPbCp245IqGnEUKIldJD9QTozbelfKjr9FDsj4yIdMJmk1RK?=
 =?us-ascii?Q?aDQC25jurRrEAyHAEZcEcInD6JdFQ36CJx0I1bupPrfj5koyIBA60UvMq/Dp?=
 =?us-ascii?Q?X/tcYE6ICox5RAAoH1c3WavLhrYLaO5JpeAtE2MSQ4Sp/fwrL+StZYsItCQx?=
 =?us-ascii?Q?wm0BODVsENGxNblJHoFzn4gNKkWKRN+iSLJyTP29S4oGzpyFicDJqaZgB8i7?=
 =?us-ascii?Q?c05al/KN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb30fda4-5077-41a7-f58d-08d8c7e3cd76
X-MS-Exchange-CrossTenant-AuthSource: BN6PR10MB1236.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 01:34:09.3423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KNpx+joEPmNaBiqV6OK1T+VPoW2kocOPaTg9dEFcx4mSa8gWHhpnYUkME19O+RCgQkGhzaP8tEH6QfpldpUZGbpmnmvDHX6OSwrBpjW2/cw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5320
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030005
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We allocate the iscsi host workq in iscsi_host_alloc so iscsi_host_free
should do the destruction. Drivers can then do their error/goto handling
and call iscsi_host_free to clean up what has been allocated in
iscsi_host_alloc.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/libiscsi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ec159bcb7460..b271d3accd2a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2738,8 +2738,6 @@ void iscsi_host_remove(struct Scsi_Host *shost)
 		flush_signals(current);
 
 	scsi_remove_host(shost);
-	if (ihost->workq)
-		destroy_workqueue(ihost->workq);
 }
 EXPORT_SYMBOL_GPL(iscsi_host_remove);
 
@@ -2747,6 +2745,9 @@ void iscsi_host_free(struct Scsi_Host *shost)
 {
 	struct iscsi_host *ihost = shost_priv(shost);
 
+	if (ihost->workq)
+		destroy_workqueue(ihost->workq);
+
 	kfree(ihost->netdev);
 	kfree(ihost->hwaddress);
 	kfree(ihost->initiatorname);
-- 
2.25.1

