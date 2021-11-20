Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2AAEC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Nov 2021 16:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237747AbhKTQwc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Nov 2021 11:52:32 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:43490 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230507AbhKTQwc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 20 Nov 2021 11:52:32 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AKDugIg014980;
        Sat, 20 Nov 2021 16:49:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=X6/XJUliUJjbhHkWocS4/0I+iAu2q5/FN94Cs1leBAs=;
 b=bwUN5XMKjyG5bEButHbX2V/O3GpIskCdeQpy2fVXP/CzztqTEoYIOAvIggylpRDRCZAq
 NuFvrIkWhf5/herlUYJPbp+VX9Xl9WReX8ftIXNnqYrUk4q8Jhm4gXxnBixeWDngjBAG
 /NA+ctZlXNFALQvi9FNO3WFcTw0BzdOWUUXtugVp09/Rhh8OgEe6IMD03oar8y/MmRtG
 UwYVTcgH55CJBLyGE1pUDVONRKzV/AFippNXjUukfUuCk2RJQiANeiUhKs006vYLfJzL
 BM0SrW+qXHCPAsCw/SWwd2YQ4HwhbpheqRIn0nsz5SD1r3Udzh2ROqAxAuVw7PGBStpe YQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ceqt21vy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Nov 2021 16:49:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AKGebPm119001;
        Sat, 20 Nov 2021 16:49:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by aserp3030.oracle.com with ESMTP id 3ceq2auept-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Nov 2021 16:49:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WOLNHMHchlmhYcaHHTKJ5wUp/Dw161qqFIez02UvbG8/EctN3p6OXe83ndtgaTRn75kcgctAudBlqjnphh/CfbGv3o+6NrxpDzcpFICgIrM/V2pKoVaZEEFfYuQ5hM+Hs2wmegAtd13VOeq9SxN3eIFHX+Qb2ws+Uy8U1JMH8i4/+QU0ibSjuxoNANXxqhzRCax7NhJ2np+ku9wK6/Rf8laW7gaZRQm/dlc1cTFWxrM6pE1MGyWLNLIgkyHI9/Z/xBoAudtjPHSeF6UqMXgs8KaAuBPcya0LcW5qrFF/faGAEvocIRD1RHuuPUfUmo4R44edEZMT4GLx3QS6KJk/uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X6/XJUliUJjbhHkWocS4/0I+iAu2q5/FN94Cs1leBAs=;
 b=De4AFyNgK3eNDJLG67kcoGSg/sY42PrWTyTNB/VL4nBBs3URyVOqaYboXoblBZFadok8j1/BNPyWOYfx7uDfKlAsk3eKBUEV+hjcuP4hvSU7xOaA+Kn0+LCZi5/NPETK2RmEZYZrg8i9Fn/SGTVoI7r9qq+2N4f/egX4qShwvS9IUSmjHUMozAx6qH31md/3UWQUzteiY8ARgf23nitOFrQv+z7H3DtPug8bnKYufGFUMk4y8WLmLDlyqYDU7m/JfLdfjNWXMm2S2cuXRcGDSL2aZPlOlT32GA6xbfap5fGyYbZ6bMayLk7u7mFGBxU0x/gP9WWZb50JcO/ZXgIyqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6/XJUliUJjbhHkWocS4/0I+iAu2q5/FN94Cs1leBAs=;
 b=gQd+iFwV2rzaSS/52xSMb0yrMJ4JZnOLadAbkLLlLxslak9WV1POScyYarq/7YycttPXI/fe8OZ2z04kAsvm8C3mvpUKpxD5UA9ElzqaZakW8nsxV9n5/CB6iGS8ZsAIa/8v1Ih35uLVl7oXsLrnkvDLA+Hv2L+qaESgUhLOZGA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2748.namprd10.prod.outlook.com (2603:10b6:5:b1::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4713.22; Sat, 20 Nov 2021 16:49:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4713.024; Sat, 20 Nov
 2021 16:49:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] scsi: Fix setting device state to running
Date:   Sat, 20 Nov 2021 10:49:17 -0600
Message-Id: <20211120164917.4924-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0054.namprd03.prod.outlook.com
 (2603:10b6:610:b3::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by CH0PR03CA0054.namprd03.prod.outlook.com (2603:10b6:610:b3::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Sat, 20 Nov 2021 16:49:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77622352-2779-4a47-1114-08d9ac45b537
X-MS-TrafficTypeDiagnostic: DM6PR10MB2748:
X-Microsoft-Antispam-PRVS: <DM6PR10MB274865BF52A4C45541F2E8F8F19D9@DM6PR10MB2748.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OCDZEu6u+yZa6t6vDDt6BO9o+7zv2Dxz1D7IyPhrqwouOpHoPwtXkrX4Zmup5Iuz8RNtGfkg+NwqC8zaHSoG7+B1+FoZNXYO5L1d5l5FvnesOBYUQyUr/lXq1OhKRipC2P4gpVJutm0J6NlD7SeZebciyMf7MGfW/MeN60zjEg+gIuOr5vBuD4CCnkAcZJCqChYthDI0iZPOSmc6uSVp+/XDZECbjcPWkiOrvptO0XPy6SRoKdYdfno29v0RE+eRGiKal9rLZJEMe/S2P69hyvxa9mI+3QFeArG/9ZtJ1pQqW0dahr9wCf62PLYQRV7jq1eWn1VhDYr+/rWo7oRYT+N0MtcQpbm01rsnxM5ws40GrIYb4QPGWRfOJ+ZJC05BsTedPKxIQFf3rZcCai+EbyQyMmKB5m2ZrjQ86oHOGcc7Dv0K//PamE6/8USynXwlhaPzmgk93n1N84yHOrOFFuAWHc3P3m+/D1JmK49GIF9WumVYPhcjS93yXAKLY8tglM6GJDn6/K+wrIfGCVlHt/lreMVO5B+XKVlQoc3C934uDCBgB0e6ywiL+9qlhc/lMP1Hol9PRkRbPM2ggT4u41siJeMA4z205xVM4kzD5AHzh4pl/xuAws8Zj8a3O/+gbOx3nebA42Oz2P1wMfQksUF6h6rbZoZ3C3QtJ9gUIJ8xGioe/OjYphMsJgIRfAAFWL4PPIA4+sR5WBuK/RYXaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(107886003)(2616005)(26005)(316002)(5660300002)(956004)(36756003)(6512007)(86362001)(83380400001)(66476007)(6506007)(508600001)(66556008)(38100700002)(38350700002)(66946007)(4326008)(1076003)(8936002)(186003)(52116002)(2906002)(8676002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2iIcseX4k3tPSJ/hVsw/iy0Yjte3EtMw5q4Zt1rgldqwqQlQ5sW9FGlW7pRE?=
 =?us-ascii?Q?wAQuGG03nR5CNOz6+2wJ5TmKCBO/tzu9UNg02gXKe7H+eNmURO3x7Xdmeous?=
 =?us-ascii?Q?5WyF5sPAe3Os3ygsULTCZ+ISxS6+fRHVumzUrIUkksTCNaZ7EGSzQ1eGelY7?=
 =?us-ascii?Q?aLMo3ncRgwiwASkS2QF5MMrx1m6/nHWBl/3oqSBQTijZinSSqrPGHZLL5VsM?=
 =?us-ascii?Q?OfW7NlwTAF0GoxcPUuwGOzGNbnEpnApPWkbszFyECGngBLx0+llhiFFSSCwx?=
 =?us-ascii?Q?VNiqadVzJEqlJWUjD7dfjCG3A8t9QgTXm67gtuNQOz5tNB+6ntcuUdYjOElA?=
 =?us-ascii?Q?KltfaJQ/cwN92EwK8yYN0CWS4BJkuqHP0gcYrZACGid4gImn0gIM19CQf9Nr?=
 =?us-ascii?Q?QCYF5MpxosiJeII6Wr85rcH3o1Nu4Isve+e7nzX8ihDHZG193NEW77q4sHw6?=
 =?us-ascii?Q?TPc4mh0tsmtHJsTcE77XER+kHXKl7JAY/6viLi5N2LXSDikV8NjmVDkKs/AZ?=
 =?us-ascii?Q?TR+nWlT6U8UHz8HBC8uHW3IJAeXMaen96MjAxCGRp+SVaADXTFiH6txfcsfG?=
 =?us-ascii?Q?Vk/DgpIu23MmvIInGpdbWXvZP0bwfYi6frOC9t4TW8IpZx55dRU6qaW/fQAO?=
 =?us-ascii?Q?bX5lkdwqmF8j1Hb9YFL2uWBGeTozjrxEOGn9PxGTGp85+PxaAZQ9PjWxUX5S?=
 =?us-ascii?Q?wyqSPL4dVAwT9gEBaqcsb1BY6RC846M7CH8htfapz16Ijr7gSgS9pxFh2z3V?=
 =?us-ascii?Q?rfPGslm0DddfURtspVhDCKnU6P+46afYiDdW6rkqrsLtuf47WFqW0QSqdbtF?=
 =?us-ascii?Q?AQl1U3iYalWHiSmWTLsBF4l/u6s9xqnCsYgYZgIffn03KUgm7ku8oBWwnFNw?=
 =?us-ascii?Q?TCYc+Y6P+tD2G/aCL8pUK8vYI8GbWjFn/xra+QlQBKCkuh79JezhNa5oWhM8?=
 =?us-ascii?Q?kD6SmK5RKBIl8u8H7ZI4m9n9vvhDILzku17mD7/zx6YxEkJWttcwC2jRfBm7?=
 =?us-ascii?Q?yuAhf50j8h/6qNVPC2omYD2JX4e45FPcRH2/TComOG0FoGgYFo/mj0d874NW?=
 =?us-ascii?Q?GieYJ42TXwvAoyTZV+VvOjFjPDsNFHz+gBDCgpQBh7bxDh9F3PSFtSk1Ik31?=
 =?us-ascii?Q?IgG9fp6GxLJcnmHoxyEvDJaGDjSDvOrly6+Vh3oEwQcS0WkidIokzgnUGvl1?=
 =?us-ascii?Q?9HJF0qGXTbs599dNE7R60czlpX1I5WZbUQhPfXwaiYRe/qxc9NosSGZD/2D4?=
 =?us-ascii?Q?z2EHn2be+LGkhwNEc0WrMiv4tm7NDXu+73nrwKvXvnHBZQegmsWTZJqCOrbC?=
 =?us-ascii?Q?JoEZP1CsLWBxqqqdUDOP1SbEtlzjZiXE67sbOnytwCQ+x03sE8ofuvzhpyh5?=
 =?us-ascii?Q?S5SDe8WQq/wB9N7RYXfV/6E7dAPAnPUVR/ZRs3l6Rp6LynEQNVQwY/6l5Fc5?=
 =?us-ascii?Q?C3rcvC0Vz6wsfpB2hIQBcB7O44Jp5tDDCLezjT/BJChCQ1+lu33w7vD8FjFr?=
 =?us-ascii?Q?BS+t3N+mO6/fhk+FL0+CtkIvR8shpMPUMhIJf1OM4BIP0WS6TAEMCegovw09?=
 =?us-ascii?Q?4zcE7LM5WsM05c/AZPrK7YUjZcFF00ttIhCKqVXjdltClsCVcriVvsWqDpAL?=
 =?us-ascii?Q?EfYqbw2INTqQeW9H4SM1Ay5ltNbqpS/uCYSBgyCfgU6KkbdNH11XANNlnZce?=
 =?us-ascii?Q?8AcJ5w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77622352-2779-4a47-1114-08d9ac45b537
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2021 16:49:24.4410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8wNUgpUdqrYi441H1NGUgsZcseS1arVu2DVOnnbcNSztdcHMmL37W7YFaxTPjy6L/OBwAC1XHTEJHMNgD5zDoPrXTqRM4UX6zHKTOTqK+Wk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2748
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10174 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111200107
X-Proofpoint-GUID: K-k_I1QNfbbjIKgh4DJHLJV_knJD52dw
X-Proofpoint-ORIG-GUID: K-k_I1QNfbbjIKgh4DJHLJV_knJD52dw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes an issue added in:

commit 4edd8cd4e86d ("scsi: core: sysfs: Fix hang when device state is set
via sysfs")

where if userspace is requesting to set the device state to SDEV_RUNNING
when the state is already SDEV_RUNNING, we return -EINVAL instead of
count. The commmit above set ret to count for this case, when it should
have set it to 0.

Fixes: 4edd8cd4e86d ("scsi: core: sysfs: Fix hang when device state is set
via sysfs")
Signed-off-by: Mike Christie <michael.christie@oracle.com>

---
 drivers/scsi/scsi_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 7afcec250f9b..d4edce930a4a 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -812,7 +812,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&sdev->state_mutex);
 	if (sdev->sdev_state == SDEV_RUNNING && state == SDEV_RUNNING) {
-		ret = count;
+		ret = 0;
 	} else {
 		ret = scsi_device_set_state(sdev, state);
 		if (ret == 0 && state == SDEV_RUNNING)
-- 
2.25.1

