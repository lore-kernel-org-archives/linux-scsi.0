Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F7AC00144
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 03:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238429AbiHDDmF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 23:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237474AbiHDDll (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 23:41:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7C85F112
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 20:41:28 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2741i7aF011138;
        Thu, 4 Aug 2022 03:41:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=XwH/z9y0DJ/bp3xDmx80YWRCfZLLK859YJh/LMBeSy4=;
 b=02ZXpFTPOFgh8KPXEDTnUx7wLJKC1QVNKiSBw5wfSNwaYjXRDToXs2ZEmw2U9LUcFSO4
 Y4+y9QnnaTOjLxthtUzaxCDMlNyGZJIYV55X1OZUyY/XTgwK71/qJl7QFv+OlNNDai+V
 Otg2hKnV1KdRdqP2Zyxm/XKC0kKJBSGyy+INhqd+PWYPnD8Do67hcnQQVfYrI1TlqUr1
 v2/PQvh7K9zvaMiLYNYBtX5Pd3zugXPACIepGLzsm65qiKZSSmKkUeTSFxZRYiRBt+qI
 XqKAc9eBnIvZdOIxXluwoA6oqLsKLTTGOzBh1QO+nj7xciUICjpH46D6Bkl1mowjNVTK HA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmw6tkpwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:20 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2740aWIH000954;
        Thu, 4 Aug 2022 03:41:19 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hp57srtby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MTHfWHDKE9Hloai75abUpljzDk5l+1UxygByyS+LTBVyEUe2zOHV5Z1nuyVSlwE9omAnvQEyh7vRYnHEGhxGqWgt7YhOsYfeA9glBA+qgghW+GexuFK9R97puvQnx+zImNUV8JqIpPw0qI0mts4QA+MxUGzm4zhRpwxb4miZdHgZUiJ0sTX6ZMU9CRBEloL7f50tO/1F4j3ypGG8UoCCzXgrsGmEQiLYD+VbXwysDR7+5AhLK5arwmCb35dg/NBnfsiYKgiEpWdUxvzTzFiyjGBLrrC6qZ7i8SMUxWuC4NbdWkq+cefCA/TQlLfrqaGpWwXbnCriN06NbltSPEi4Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XwH/z9y0DJ/bp3xDmx80YWRCfZLLK859YJh/LMBeSy4=;
 b=mcVRAjuZ+2gKBDbRr4kuxEWX6i3ob0Utn42yZi1Yht0KEiLUX9/3X9EgCSFoGpRubS2Ae+su6VyJ72Elo6IUjsf5eqQenHNGNNXMrYPsULIVBcvDrjRgY0vbhAbr4TbaCOSws+6TnR2LYRYDkS/dzdakjjdQeicid3k4mGc1MNpApDholuO73i2xGudsvhsUXmawcBzl4j6XWUEZ9opmzvYe7eVGONugdmhPYauSYx8e3d/JLMExBopKz1gjRzJCt7AMSUQUfZt7qXszxnCmplzvyZe7dS7017n7p/S/v8H5c1jD5nIemSP7XGb8AN+CaHoYJoReOiFgztA4AT7X2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XwH/z9y0DJ/bp3xDmx80YWRCfZLLK859YJh/LMBeSy4=;
 b=PWgmV9RMmhOL2iJHPjn0i0pva0HZhRIdLbuu3KX330qZ+npt+tPbCc5ngSlAIWvwUQiBfIsQ4VT1OxGQ9zAQ1dth9D9HpVUqSLnz3JRLu8RqJQ3VI+MJbVr7DliQrG/e4zYFjPxR3UpKh3YibljPt8OM9+QdiDVxgFgAlwksVGQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM4PR10MB6037.namprd10.prod.outlook.com (2603:10b6:8:bb::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Thu, 4 Aug 2022 03:41:17 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 03:41:17 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, manoj@linux.ibm.com, mrochs@linux.ibm.com,
        ukrishn@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 10/10] scsi: Remove useless host error codes.
Date:   Wed,  3 Aug 2022 22:41:00 -0500
Message-Id: <20220804034100.121125-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804034100.121125-1-michael.christie@oracle.com>
References: <20220804034100.121125-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0118.namprd03.prod.outlook.com
 (2603:10b6:610:cd::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30deb507-782f-441a-c70e-08da75cb3020
X-MS-TrafficTypeDiagnostic: DM4PR10MB6037:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AAc/Z0S5wL0zjuJyn7AtW/NyZa9yAUO77AYhay90plF8FJrPWtjv/n09lLCPm0ZN/xs1U9an7dULrxfuvE6z8MAwWH+59I6QohNELCTRhEwi4fguEMoNp64xWL7SrWjFlYGxJ9wZYX4I2PgeXKy99Ewq8aqYbylwYbG1UrWfUfznJ96fUSyeJBZPz+pI+LCUKOmXIPqQkbpiuLACurbLd+D+gwV9FuZzjobVI7UYumHmlCt3Hqgynz4ZlB98xJUmAI9oQ8c5H3K9W3n5M6P4M0gB00ZZYfObq26XNJHMq+6WZ5WnfN+uCyH9zixBo1/LUA0TYCNrxpeRcIQ32rIrxLuIymwnLDJUROgk9hwU8txCDxJ+kKMvKrw0dnwC5LAivsRV8jG6HU7E67NLYnMoAwOCwF1iFON5ptgpm/CNLjX+Qpk3GJU/rhhjiKD1ZxL6eHAgeZA83E1/n5ETCfA7GP/FJwW6qjSaUXbXSpA0MQUKpdDQi8gp009iASUVhQeFvhJYLNBswjIvdwyc7Vden/JCWZE8OgJuTkIYL/6RXbPg3uSO3JFi6NlSk6Vy8F6d6rm9kmzFA+snZZCCAcou4qE3o3uejA0TcCEBwXOvZSq5AVAX7hQfXlxB2CPJjB09vRE3X0dBK/9bGZ1fiOXA99JDJ14tsLIDamw4iZS8fmy0f1DQgFdDybkxAOY4XoweLSZ4lsPm7iN6mUgVfpTtkaR0+KcfwqWcgGfHcBJ7Ow8TJe/N3XeJJXg3ZI8qaAmj4v1Wh9zmVtGzeUeAuuNICw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(346002)(366004)(396003)(136003)(1076003)(107886003)(186003)(2616005)(41300700001)(6666004)(6506007)(7416002)(36756003)(2906002)(5660300002)(478600001)(6486002)(4326008)(66946007)(8676002)(86362001)(66476007)(8936002)(38100700002)(66556008)(921005)(83380400001)(6512007)(316002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f0US8RGFqoVIvl2HOVvORCVIzng9oWkrbDHUroWslBNLB88Qo5h6IH0MczBG?=
 =?us-ascii?Q?wHeGUv+x/eqIXuiqDlyHmHO+zRSl9V7oMoblsNzrDYAlCMUNYsFiZ1qj5Vn6?=
 =?us-ascii?Q?Wz5EuDyFIp6YHKezP1aASeIXwG5+OtmMZ/SjRdwhZJAcD9IGYH5Yby5/g65N?=
 =?us-ascii?Q?qtqRIVTcn7J6DpX69peOcLP1SdYteH6z+QA1YdUzqVFsCSDfE+1x/r9bocGa?=
 =?us-ascii?Q?az1ccOTKM/WiErh6Wk6k1a7Aw42/1Gw5ej8zkPNf6op29Psb+wiRnvmi5yI+?=
 =?us-ascii?Q?KiYvDdzJuKcjO1rhT/RmfkeYtVRERdlLpWaPbaNWqfGnMeMtGOQuq0zSgfFA?=
 =?us-ascii?Q?TLFRE9RbdARL82a3qYz8TJnqpGje3IppfqaKObPIh2OIN6K+vZ9MA3sSoaSZ?=
 =?us-ascii?Q?NUvlhWSm2KfFntbdbHq3PUV36l79o+jwLR7rDosEsoR9hNJA5vzySCnA4Aox?=
 =?us-ascii?Q?ExIQSdHSdW04Sa6BHDk4qPw8XhYRmwfD1bbolFSC/7mhW7sf3hGD3OG6c+n/?=
 =?us-ascii?Q?S5ZjxVQwZDgICRLLqsKNVdqlRnntQ6AW+YkHvtBYuMpJowRk8adqM32o6jI+?=
 =?us-ascii?Q?1yzi7/Z12gqZHSMCc3PVFxMTYMkhKnINpXr61OUhqLqqSZ+FkK1wGPc51F77?=
 =?us-ascii?Q?vMeGxturvtc/Yspbw133s2jLLJVVRUw0g089VVR00mggIVSIQatWLhxhdI7Q?=
 =?us-ascii?Q?QF/yp/vZSVWncSUqTKfviea8hcm5iHIl0yDsbc6qj2YFV4Fjqifj5El17Xce?=
 =?us-ascii?Q?WOhxT5bKgDXmfGUwpc2gkgr07LTeYBh+ABfV71CFEB1si6xE9EfJTPrVjpLw?=
 =?us-ascii?Q?MnAB2pBVG3bQYwBNWmCEdbSaV0CUYxS/vt0PsABuBgqSK3VUkc/cw60bsj9Y?=
 =?us-ascii?Q?w/tSMOfLpmy5vhzbAU6yN2+X0JrQErDw9XPPo+CpvN2SlVPXVSRT1pSdBwoJ?=
 =?us-ascii?Q?85P7Ow/r2k4Sy/jWWYEY8SLfm0lBIlI7kXcy9V8OsV1Trv0t0iOWoBhjj0jI?=
 =?us-ascii?Q?xVXPM7TuaUr1S2BVtjAh1Hn1M6HwoKpbwMo7vyicfvB/8mvlfyl172tCylxx?=
 =?us-ascii?Q?WMOD2jLS3eO2PAf7XYEkx818vONZGFBZdUo1S+grJNbkSmrow+k6PjmIrfs8?=
 =?us-ascii?Q?uCokZQGr6EEEiocKRKBJMSbM/CwhPj7upcJIjRJeERPD23g/benGvuZOawU+?=
 =?us-ascii?Q?qXC2WtZy8wsMa/hQe1H4LjkQJh9TC0B3hPS6BmuKSXqRKcHQW6VS3U+XS+3D?=
 =?us-ascii?Q?QzxhuOKBJXGtH/C1isUVJQV91Mgy+CqstBdC9EAaKgTDq9yGGQ8Lr8POulX7?=
 =?us-ascii?Q?MJBMLbrmw+vulxjA/QCezEDnBqOV59qv0h3jo6ohzn9zTh1KURv5Fvqz9Kp1?=
 =?us-ascii?Q?ZyRBqCmRl7WAa70xnbz3FnaCHXlEQ9h/4+Qbt097iteRaB6I+CRpPxAFfEei?=
 =?us-ascii?Q?lMVHrRjpvXkeCrZm4bTOG/zeiliYRzvfmPKBzUqFifqRcK8TPuhyZZcO+x5Q?=
 =?us-ascii?Q?jOXMBjplQjXBM3QFO5Jg3qZvbKbNP+uXumY+0xuJFh3Q+n9A4Rhtiwi81btz?=
 =?us-ascii?Q?TjMhARwqTGLnKpSqdz+vVuktqN5z1lzg1jzd8HlbtaYzqMgaypZTyUVI1RK8?=
 =?us-ascii?Q?jg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30deb507-782f-441a-c70e-08da75cb3020
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 03:41:17.3393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1UmJYoUh7VVINEu3yp7hgivYCtxHJzvJ3WcDiRkTKCGpd7OkJIMy1hHGwZWXpuAhGVZ5iEIf7u2YBcheY0EyQA+r2I7ZamDpE94KB37vP0U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6037
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_07,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208040015
X-Proofpoint-GUID: vEEqYEy8lgPehMNmZl_QYsu50a6A28n2
X-Proofpoint-ORIG-GUID: vEEqYEy8lgPehMNmZl_QYsu50a6A28n2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The host codes that were supposed to only be used for internal use are
now not used, so remove them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/scsi/scsi_status.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/scsi/scsi_status.h b/include/scsi/scsi_status.h
index 31d30cee1869..9cb85262de64 100644
--- a/include/scsi/scsi_status.h
+++ b/include/scsi/scsi_status.h
@@ -62,12 +62,12 @@ enum scsi_host_status {
 					 * recover the link. Transport class will
 					 * retry or fail IO */
 	DID_TRANSPORT_FAILFAST = 0x0f, /* Transport class fastfailed the io */
-	DID_TARGET_FAILURE = 0x10, /* Permanent target failure, do not retry on
-				    * other paths */
-	DID_NEXUS_FAILURE = 0x11,  /* Permanent nexus failure, retry on other
-				    * paths might yield different results */
-	DID_ALLOC_FAILURE = 0x12,  /* Space allocation on the device failed */
-	DID_MEDIUM_ERROR = 0x13,  /* Medium error */
+	/*
+	 * We used to have DID_TARGET_FAILURE, DID_NEXUS_FAILURE,
+	 * DID_ALLOC_FAILURE and DID_MEDIUM_ERROR at 0x10 - 0x13. For compat
+	 * with userspace apps that parse the host byte for SG IO, we leave
+	 * that block of codes unused and start at 0x14 below.
+	 */
 	DID_TRANSPORT_MARGINAL = 0x14, /* Transport marginal errors */
 };
 
-- 
2.25.1

