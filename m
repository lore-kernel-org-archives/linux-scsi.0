Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39011C64ED6
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Feb 2023 00:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbjBWAUO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Feb 2023 19:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbjBWAUK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2023 19:20:10 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E274241090;
        Wed, 22 Feb 2023 16:20:09 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31MNiMoN007598;
        Thu, 23 Feb 2023 00:20:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=sTo17Bubdke+YOcOvG8UaJoxskwSobyL8YwVTD6ooNU=;
 b=IiJ+gVZuC1r9XQ6v+lNj2K9lwIvdN9PmTZkEib+q04Dx4ZV39iFtQ/0Ck4iU6ek+ZUfy
 qB6W6gxEQuPI/0Uc2RfwpKRNgUJne6ODih2NAxUL26VOkoSjuhtz8OXz4CQ1XkXGmZ2a
 AkFUggz8JbllI5SiQSggVgdS2eFXKEj3wYXep5mte9bhAW+/R8y7un74Xx/lYORqRd97
 o49tjby0zGxZy+H7vksfyvye1cSMb6zySvG8b/2HGnUGqSh0KQnZ+opZkfa3O2+PrMe0
 NolQI/MT/LQfTrjXFiMo16XDv7weXXYv70NYiCRyyVgCIHhdPTlubvhAzufoX5CUIvI/ Dw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntp9tsdqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 00:20:06 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31MMkhC3031500;
        Thu, 23 Feb 2023 00:20:05 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn479u23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 00:20:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fium69raqNq15kXAQeSA8VbJLkMLAwKr7EAkJkVAZyW3L6SOt7Pqan7wvpa3tMRWTsjUm3kbXk8QdyTIpnOoBS2ztDkm5uezb2/92YMLx4OiR2auDWhVvpnsc3V5mFErDvEZWqjLsu29xOa/oE5uXUeVPdOdmliAl+g331kK/Qn33YFR2YZZ6Yd95jXcXZl+hAAJxfrZcGWaccPLOjTbHVq8EL989Ba9/S40G9fbTMCYA3aJYaKlyJclnDpR69Vg6Fl1cdLjBS2E/avWfLyt8ZHelPIn+NFpSuwNF+MpY+ktl6iycJ8sYib0WgXR13S2recZVuUP4Ygamdfd26GInw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sTo17Bubdke+YOcOvG8UaJoxskwSobyL8YwVTD6ooNU=;
 b=j9wbgvYk5xLLQtIZcvmm9RIJ4Wop6azXl/I3lkhttJWtnKvzWpcZA6oTY7ZrfuQ842fHOz5UkkPAA+Mm5R2ij8l3aCMqnmRb07o+AWpUPjNK7Od5sQ5/on0fxzUQXRCiMq1Bhd2Okn96Nng1MJDBCISMHCYGijVy8JYaewIkfrvjlnjd3NgRensS3hWpSPNQXCxlUeSz5qOuK8NjcDVKwM2OtZlzUv/9ujRjJiQjPbv3BbLBkM6lSMjkfJKiGccLrE2i42S8KXp3YfJDrS4RXewMHKqKBBtTMtj4EXJd5JpMPMXfqmqzEZOy8s39fGAIim6Aox5DUiinzgggN0Agdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sTo17Bubdke+YOcOvG8UaJoxskwSobyL8YwVTD6ooNU=;
 b=tDFYdjqEoaGQzBzjAWEfWCxixJHNkp+LHOpqCDgYxzLCHnl2HZUQgNY3vyRxNThoLz2ME2xKYgR03bsnKu1S7Jtfd/pVMREXCDkVzTLb0WJ22FZZeZ2TRPpbiFFN89V+dxp2HNb3pSNlo3vGaZJVv16Nmo8rnwP2ikDp2tKJVEE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5286.namprd10.prod.outlook.com (2603:10b6:408:127::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.6; Thu, 23 Feb
 2023 00:20:02 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 00:20:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/5] vhost-scsi: Drop vhost_scsi_flush during endpoint clearing
Date:   Wed, 22 Feb 2023 18:19:46 -0600
Message-Id: <20230223001949.2884-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230223001949.2884-1-michael.christie@oracle.com>
References: <20230223001949.2884-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::8) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5286:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b12422f-d0f1-4802-3083-08db1533b4cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fwlXWItwcC+9sDDCFQBlD6UrAONaRC24u2s1t1qsTRGRKANiwfpscxaZ+QmkbYKjntmm7XPeUQY4sGszE0Qv+RxK/Qx/kcvFS+zGIdZeghe7jwNvD28I+6k5n9BseSM/Gy2yi67jo2UV/0YY7rb2KwhPIX93fQaeQxfrlYYIdfmqmJaKVI8YMA9M6vQ14HQSxIJ4j6MgAYIGKJSkAzirBeC+pslJRBhvo46dMGWWCTc6tpVeBKHBZ0kjdt72zbdoJNu+U/Ppdg8tZahlK7ghfUXqzz3vmA9CcCb/YvsJGJObqVDDAWXrLAJJZdYlQL9usv295ssvcCCWXYasdpEQ+Vrz9hopjCGDIPRIq5A73C73N3xpyTFo8yI3rj7ZDWR3KF/oDrWdGt/A0M5VZktvrGOvCwPjiddURpfZom+SfZZMs+6UyZrQocfgjNqN9q4xK/vOEODUrxhnR9D+dI/j11EUXAwl/9Ct5nG683UUvfGwx8UI56ADneeQVAfJYRYrAzXjHG2kD0zWpEgb18l7IT+hg63XhBAwVIW//fJb1LwKt4opbX0EcXGuWmODDRM+ha1ZHwnu4ebDLLZhpCxLXaQsLfdsEkOsp7L+qFE4kC3fX2Nd37aXBEklVdZzgpoFGPa2Yxb6Fex2NdePZy2tbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(39860400002)(376002)(136003)(366004)(451199018)(5660300002)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(41300700001)(8936002)(2616005)(26005)(186003)(1076003)(6506007)(6666004)(6512007)(4744005)(2906002)(83380400001)(478600001)(36756003)(6486002)(107886003)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LJweNAkpKAfF3bWHzhaBrX7BZ+juoqoWrckaitb3Qe4a1fkfc7y4t4dwaBpx?=
 =?us-ascii?Q?GWJagDox8LpshFjFTZo5ZZ/yo9yBzXC/p+OhQNfca1AP5K8s/pwgCTm3/OWl?=
 =?us-ascii?Q?A+qvMCXDaQd/7xC1045JD4zDPwpug9abo5nw4Fo6IvMCpmMQl5BGFJ3kfVpS?=
 =?us-ascii?Q?tFQgG0GTIIalhLnhJ8crYW5nk/zpgEj5u6IFgzsC2SkU4rX8/XCN1BpV2KnS?=
 =?us-ascii?Q?rPtb7TIo+93Wql4R/pQYRKgMnSZb6PiHiBMiuInq3xWjdPLyVKXE23HXdDjp?=
 =?us-ascii?Q?X3vfZqxfy2HpupaBpibyeUA3qqin4tPLLK9f2A5l3fjruIRGzNhz1qL+8YiH?=
 =?us-ascii?Q?Ou1iKeYHYSMLBrFketIRSObc6jZGYbQszu28Xt5G9ZGrBDdmqY9Ah9GOhQGW?=
 =?us-ascii?Q?2n6xvYpc9fTEnbLsSSK27bycWTHpTwGtJHsRfl68n/pI70YhPR6Tz5bjjfbx?=
 =?us-ascii?Q?ThqdwEpFytVQIKXT/c8eX2eLgP6mSGp0tHb8WQdatlb8FhkJQhxLwKOH5KLF?=
 =?us-ascii?Q?6Ic5fys3gg9FrthU4G0Q+VHRc7eLZgB3O48nc+v4XoCxfriOClWr46b7tUbP?=
 =?us-ascii?Q?CO5GdXrjLzXmyCYJJx4nFA7Ub0/M5RHjtD7MOUWHMAPP7ZMvr0rjdMzvSsbP?=
 =?us-ascii?Q?AEGpApXEYsNI/YpdgVOhda1N/zyIkcprK4IvIn1lT0yJzzttXWt1EHmu/g3/?=
 =?us-ascii?Q?uEWeUgPwcKcEg+tEVgV663Dh73YEFFD9nYjaByg58JxQ2g1efJag/jTdxnCt?=
 =?us-ascii?Q?6rqZVPyGGYba1tT+OJ2RwxFhIWerT8HTg8Q+6ObDxo1mHK8ZsjUoxUkBMwsG?=
 =?us-ascii?Q?wgZdDgVxtRQhnPBL5vxFlJ5rA7iTsZW3S2MGPbDTqldiEqjCk87bqPmGwKMw?=
 =?us-ascii?Q?kAifJ/DmYmmfZth5gOAOizJraJ+d5vDfOA8r8XC/IK877b63A99/g7B5osfl?=
 =?us-ascii?Q?o6Txo1MuWZXbfaByBkdlOTUjHIEIy/BQeHlm+KOFbP7+XCIjFp+y17xQZGIN?=
 =?us-ascii?Q?XRBrKgzERh0CXmZmefJbB1jr6aipOiGnGSQgXyFpN9NMDyVK+2Fd0XOpx2VN?=
 =?us-ascii?Q?wQRuTbBDmUyWYWKVecaKX0ldjp0jJsHADhJUxHfGBVWAP2lZN9DgBBPDw4FL?=
 =?us-ascii?Q?CwNI/7IvmQY2GV26I32jLCmHiJoo83eF5vRtyEkWSrNRvJ8O+qkOORiVT3M6?=
 =?us-ascii?Q?PhLXxLia6iLl5jQFvXpIuYMjnEDbdiJ5zdRpOAViQpyW7mnSQAKLEjrihNzc?=
 =?us-ascii?Q?OZCdhkiHPuXJ2fHp45JIEPkucIdi4JjqltfuoS+GpZt5G3dW1msVZIvrES3+?=
 =?us-ascii?Q?JNrI5UAN/iy+TdiFof7qC/CFGkwdDap5oZhvIfUeOe8OdzNqyKuynpQZVfL7?=
 =?us-ascii?Q?w1AZN0vj7aBdTR08L9cQLu6+czTzFCJstNiA1FO0gsO3p2BPmtXQ5vB3fPMQ?=
 =?us-ascii?Q?vEj7415pBpce7s2FjO3p5l9CDNtNQsuYTVSomIUzezSVEynqC3wzF/YtLlJS?=
 =?us-ascii?Q?B9bwc0cHyqYlNbTNvf0oxnJwitnygDbENqdpKIKKPkNSHRzfLQUvIKhYKqln?=
 =?us-ascii?Q?7NmLbNXZNshVsYZzxS/J968OV+1CfsGsFj2rEWyb+HSFG7wkD0tdA9zYvEjF?=
 =?us-ascii?Q?DQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jckHwivaM+kPt54N1/jDRzF2NkFC/nk+WAv2bjVn2rakr2lo4jwzkUFHueOotf87IjYECpaBfy4nusqO6Q3wPF5N+pv/d203Vb9yvO/QJnjlSnyEk4EOonpRR57rcc+xgPV2h3xLUxUh611c4Fner1TXngYM9WN4Vl07UxlxwG6oIOmdsPsoEr+7XtUgITjxINqcGSCqDW8pzXyZahWMKoxjYe9cFTImkJisBI18vbjfhqsbhERRlXxqO0D/7vvoCI0z/CoCqj7MmnrLMvkwBQcD52g/67UuStaO1c+6M6TMINbiF2CDuYa6YnOD4EjVyZTF/Tcex/ZR/IYi/J3V4KriZD5Ei1eMBRkfobaaaZGUjU0JVDfWuNgqcqH/K98uaIzNeWdOtUZZeRhHR3WqQcp+/8nr0LwqtzoMzQcG2bGMqY+MgnQkE1x1lRQeWbxM6WFDV/AAQxhqQ/r0BB7c3k0wKwNmIPXFiLFrlLmxmgAJA3wiujQkpoc3tFmPj338nrEGnp+Z4xLNVCAq9Hha9ySYKi8hu0RXbfFxc8iZCAwkcbH1qlc/wUz+WIxE8gHRXtxIi9bhuBlbnjb73SXxVcKps3a2KAmHM/XyT9/RdwRhaSF902+j18r5WMmNpqWkGZRSyzCLD+pk72C35VXTMkAE1WwPqkhA2JtjRWcjTB8vnfFtLZ+1PzsZ3Q9dcBHFSn8tAdFdROTa73rxvAfkGz5JEFE+4SxF8kIDhyOZSQSaW6BrJDbciZ0Trn86kYIdTN7nDO74Ghj0tvPqAVliyvGcgVRKNzbhoezPzlTpQl0021bEOOqCMiGzG52MPDYebyFxbZrpnUgzmWg1PPUcWIeh4dnXtIDx1jrflC3Lulk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b12422f-d0f1-4802-3083-08db1533b4cf
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 00:20:02.5455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bhKOPrn34hUTQUf4VF/6DExueO8DBjCazXSOaZQ0AJk7r8aUjR/qQyJyTFimRlWIirlvem3XHmZqIu5tdh/WK/X3ts6f9EqoHAo2SWJ0Y+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5286
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_11,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302230001
X-Proofpoint-GUID: p-9oqMy-G7bTaGoz2O0zstj2hs9eiqSg
X-Proofpoint-ORIG-GUID: p-9oqMy-G7bTaGoz2O0zstj2hs9eiqSg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We don't need to run vhost_scsi_flush at the end of
vhost_scsi_clear_endpoint, because a couple lines before this code
if there are any tpgs in vs_tpg we take every vq mutex and clear the vq
backend so know there will be no new IOs accessing the vs_tpg. And after
we clear the backend we run vhost_scsi_flush already so we know there are
no running cmds accessing the vs_tpg.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index c31659aa5466..502d64b53d9c 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1746,11 +1746,7 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 			vhost_scsi_destroy_vq_cmds(vq);
 		}
 	}
-	/*
-	 * Act as synchronize_rcu to make sure access to
-	 * old vs->vs_tpg is finished.
-	 */
-	vhost_scsi_flush(vs);
+
 	kfree(vs->vs_tpg);
 	vs->vs_tpg = NULL;
 	WARN_ON(vs->vs_events_nr);
-- 
2.25.1

