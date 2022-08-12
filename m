Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35FA4C3F6B0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 01:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbiHLBBK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 21:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236162AbiHLBAz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 21:00:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEEB83BDF
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 18:00:53 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN6AMU002850;
        Fri, 12 Aug 2022 01:00:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=/9e3Xe/oF1uHgKppnqVP8AMEhWYjF/G1fUqKLaJ7YF8=;
 b=yOO/VbN+tXLw/FS+DSF7pAzk5qjWsuvc1id585BcqV1WEGXmPZLKV/iXv85AzU6dcTjQ
 O9jTeO/Nsu4Akm5ANMhvoQBQwSAv7HWmEyOXXrmsyTke7hz8C8lwSuk7WNlPnnaR+g3q
 pw21TrYlnWTkL8SRkaJhhLLJxQpJjKipwa1POuaru8DLQDifPSYnskCIFEJlWeiwMKsb
 u4TNWUaa5TJ6Jk1oVqZQp4s7UU6IdZItgmCZvWmaTkIoS3/zqjolGajWhk4xAmS+sjIL
 uvuVju3NU6JJX8VMXr3wqjNa/PZa1WZ7hNdSGMvJYh/LUwTGXHB7Wi1BOiZ7xM6Ss7xC KQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqdx97g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:42 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27C0EMOA020384;
        Fri, 12 Aug 2022 01:00:40 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2047.outbound.protection.outlook.com [104.47.56.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqk6bha-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5OhpYfFOlwBnYYA7ha4gYv8DcRkDKmvBvnlA69D4pvRtU0hRg4MEf/ZLZDJVOK5r1onaugucymaII7DHXoprW/4FTkH6PfADbquAqUIfkbxrvwsyWCnqAI89Aagona2ouaTbI9lSmFzIOIs/wgJlDIzgDJVGRQNpvA2cNjpbiawu/8AL31gDmQZqcrfjlEjxx8BmEAj3IyavYg6wmQAiusvZcZRZ+WepCuoHggWFqan4zE4E9S4FPuoyuodHU5Db1SkqOgRa6Dd48PhhBbCy5g9j+GxxbW+0qxonf1ePiCnq2/Qwpcwk5OjFz9h8JVaGIPLuw4ZTH4n4gE2GwBvHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/9e3Xe/oF1uHgKppnqVP8AMEhWYjF/G1fUqKLaJ7YF8=;
 b=GchI+IkR7eggwWRntLpwGj0uJQLRiWUWCJU9ixTADlHmPUPlNy44lT+pOaeU9pzZqgrK2QqsVcX7dJivLjaFZxDaEHfggH/0h0xHQw7TGZzzaCpfs6EJVrm+dtVJR2XaNc3tx7Ot1cFKdlsgVjqJRurJ7NZLHb9JDo1Tst455++IYGTcP0DZxn5VV8SNDqV8ps+duS8IAfWRH89PMpLnJl2cQwCTvfrC9JOAOzLzx1BV9EfTb261aI3GarM4g5NGJ1vYeQdrhgCdqXGZ1B6UDie0pOyH1wWsXzcBU3sh8V8tKEiCOfZmZH0M1jVFGVk8cxuVG4QpcfGjwx9k+VQsiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/9e3Xe/oF1uHgKppnqVP8AMEhWYjF/G1fUqKLaJ7YF8=;
 b=SaQTNV/0IWzv1o6DH1tVWd11WdR0AEKJ+aPWfqSKHPF5M7KyRCVid2RHWDDXMT4uoJgxSR8UOctDDk1sbL0nyBPX+C9FoCzwlTF2WKnIthJEZKch8yzDOE3Y+JbXtXTgyzHME90xKId45LZvrVfHTyH2CtqTNrSZY99mx5wcx2o=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5386.namprd10.prod.outlook.com (2603:10b6:610:dd::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Fri, 12 Aug 2022 01:00:39 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.024; Fri, 12 Aug 2022
 01:00:39 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 07/10] scsi: cxlflash: Drop DID_ALLOC_FAILURE use
Date:   Thu, 11 Aug 2022 20:00:24 -0500
Message-Id: <20220812010027.8251-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220812010027.8251-1-michael.christie@oracle.com>
References: <20220812010027.8251-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0007.namprd05.prod.outlook.com (2603:10b6:610::20)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 379f1e78-fc28-4297-5dbd-08da7bfe128c
X-MS-TrafficTypeDiagnostic: CH0PR10MB5386:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2D8z8wflJ/1yjshc0jDPof6crWEMuPyauC4ynW0ri7sCV6EIY5Y04iE1RtFww01ZaHWFwm0rYl4c38rrvg1RJcpzAtPqrcHf6D6dJSxHyGOzHctkpnQ7Ck/nnJlwfrwgUzx3VWmDFz3eqQ64X0NtXjUnvVaIcL1jlPkUFaaLcuwsKIGD6udO3v4BwVhxorZ/v8s2NKvM08QXvsLv3ofZFQTwHN0T0R78PW74Afd10bH1oCcp58kgVPN7CSEFEoNC/MTuLDF2NvN8zCA3kKqRygbgEs+62jJdumAXTIY5A41a3rqrfS0sdBUkgzSROhYqNLDwlODKzSfeP087AJrTnQF3NyCC7epy4bMGvkDDyY9zeKDXuoLFaFC+/c8DIT4+/VfgJd46/Z6V8XUCO+4hWlEZDHY82cih/R4JrYBUIRdsIBCn5TcjseVrRg/y/Jt0W/dOjyKL3pNi1YOaZsNl0rITg8cO28etjjxZb3w9RFKvjBsHggNpRjp34ScHZyIY0RvQsKtQ40LPoszRzd2wi3gBtI3jwyTLvW0nCEvyQB7AEGoGIOGiUUMtmsoGU573DQtGzdGKFAhCneq33So6ifnI0beSgWMvjkzq+2fOlpeOv9OCr47UAU30eoZay+9eesD0r89AA0V6ohFSukb9IE3BHaxk6SRRBKILyk/yIlNlgdyOXtWgvltweZhROpXc5LL2siGAkhHYeMcbHmS1UZNTwPUG+ceeQIgK1Ll98097oNeN0CE+P3Ue+az8MuwdPwOXK4DH6pzrqf3/kCc5q4pG7TmyjqTYDNTzvAfBSnk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(346002)(376002)(396003)(366004)(921005)(2906002)(38100700002)(83380400001)(316002)(4326008)(8936002)(8676002)(1076003)(66556008)(6512007)(7416002)(107886003)(186003)(6486002)(2616005)(478600001)(41300700001)(86362001)(6506007)(36756003)(6666004)(66946007)(26005)(5660300002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1tMp0baQQAk0dS5NqK0u7I05ANSTbnp8S3DKTQBBoPLWZX/6O9NqmhUtKxd4?=
 =?us-ascii?Q?+CVIyfZ/fVHr6QcJM7iDasQFokLo2RLFsliYTonMGhvMasdmOSxkdxLAWGH+?=
 =?us-ascii?Q?Kp7HRBs19+cqlvvWzOYWERZ/y+DTFmf5VwBYXT+17t9P9qWt7dQ+bniK2aWs?=
 =?us-ascii?Q?1TviIejqrjLSOPj1Rf56Y2OSZhTXlYcDA2vPr/E3eoqqjvFdFnR7/gH5+olR?=
 =?us-ascii?Q?+rCxxk0pJIT4T4CbweDq1totpiy8+GjsxZWcTK0unzFVRaMmshe4x04x97ci?=
 =?us-ascii?Q?Pfn6GWC/+MF9fTMg0w15w4i0jXsT64NEygVuuizEVtoIu7sRCi/s4N3gEz85?=
 =?us-ascii?Q?zi71bvgCFI/UIofaC+tQ6R3viO7OJagyv7f6c6VCVa6BQBXpu0KmwucRCBqQ?=
 =?us-ascii?Q?agPjmetgSgjI4KG9NU2fErMzhz0Tra5Wi0eyKIIAAYnqOL0Pyz7u32ibRj98?=
 =?us-ascii?Q?VLqAT6f3IZKjJgGjAr35bUcvZlvcC3sMEbsclM6EJ5kLW6ZzMN2bHdgSo+RW?=
 =?us-ascii?Q?eDpVkm5J7oY0M9gBONhQmtGMoHD6XK2PBQgOxYvVy0nU0GDWsspTTwl1nnMg?=
 =?us-ascii?Q?W6v8Q27TZdPVSOarK9W+DsRbb6nsMQh4c2YqMjnQeFFIPXls55pgnvRD0LX4?=
 =?us-ascii?Q?gnoP4yPgYhI2UUuumfQx/a9kbUqbBO8mldSTFP8iqrDMztLWB697hmBw11QG?=
 =?us-ascii?Q?nkv/1oFBOz6JSAd80HF7bDNAtWHs6vQSH7Vl4ZzCs0XQQkm+zpKRTYy8Rhwy?=
 =?us-ascii?Q?2c8J5A6xkuDQpQ69S2MHG7a3tFF17qxViAe5YTKB0gSwKPWUOxy+kf+k0mri?=
 =?us-ascii?Q?d85da5xijYsNJ+nxQ9/lMyAd96NAjmoj2hHurYLUSLoy938Mod2HlPXE7gtD?=
 =?us-ascii?Q?t/kMLG8Ma1Eg9JcMdVdu8NHvz34HLzSI3diCzMxh28hshIJm7VxCPxv0NTYt?=
 =?us-ascii?Q?OT7xqUskuTy+EhnxifV0UERZoGsK1/+cD1WEd+NkvKARPu5nnilDsniQ0rxk?=
 =?us-ascii?Q?EijBgK7h4N2DUo/LURUawrDsY7lftw4tzDWERqSZ2jLDYROYMgKoRyJOmKnN?=
 =?us-ascii?Q?63Vvqo09UN/Ofz34MLZ+lH8l0SCcRRQYAdNTvVrkHk68b/xX/oChSZm70CWf?=
 =?us-ascii?Q?NL5OBdTk8d3jm9khAbL08gJmpTffu+Y2Xr7w7hlZhjqtOUtz78AudGq3xYiI?=
 =?us-ascii?Q?3pdH1UzWLTf5Xnf7Qgq6gsysyFe4XGpcEn9T2gG6kv6w92zAd2h+5qsy/GDj?=
 =?us-ascii?Q?8NoA4Hv+Oh5Kp32aB38uF3PNuHuU8Z5Jx0CBmNJ+9qtdYaS9SWpfK38pAKyk?=
 =?us-ascii?Q?1qQ6+keenQ9oHqy6tEpCVVnMgWpnzbmxX1kPh1wkDCo5gJPnGhPWWL9SmnmF?=
 =?us-ascii?Q?1mQ4MUhpQ3Kw+LgO1iMU2RBokedHZlwt/DpL7OiTg+Cy+RHhAN1QugvozDVd?=
 =?us-ascii?Q?svIqFnn+ex6M2z3wl6xTMbxcQCoTIExLeMUU1cnRE/WM7drMuRdfPe083Ra+?=
 =?us-ascii?Q?w8e8VlLkF0nONDvbWf5+y7WPXYI1V9nlUyMaqjCGmMy4iqXwNr0abiZJMZ+i?=
 =?us-ascii?Q?dXxgcL3sqva7IGhUs76WuEwS/RcapLtsDHAWvBFwt0A90JlMboQBj66O6QBt?=
 =?us-ascii?Q?EQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 379f1e78-fc28-4297-5dbd-08da7bfe128c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 01:00:39.0538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BRHTaGgakXkZ2BZuidVbbQEZRUBb8VlqhT2jSd1zvGcBzqNGKc9lbwzprGicD3Oj1M3NdnQoiIpohnPUy+2opd6leCHqSPLfYtn/cZvA5aI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5386
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_14,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120000
X-Proofpoint-GUID: 3c3ryIKMWjUMQpvItux4fY45xTEeUCy8
X-Proofpoint-ORIG-GUID: 3c3ryIKMWjUMQpvItux4fY45xTEeUCy8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DID_ALLOC_FAILURE is internal to the SCSI layer. Drivers must not use it
because:

1. It's not propagated upwards, so SG IO/passthrough users will not see an
error and think a command was successful.

2. There is no handling for them in scsi_decide_disposition so it results
in the scsi eh running.

By the code comment, it looks like the driver wanted a retryable error
code, so this has it use DID_ERROR.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/cxlflash/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index e7be95ee7d64..cd1324ec742d 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -132,7 +132,7 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
 			break;
 		case SISL_AFU_RC_OUT_OF_DATA_BUFS:
 			/* Retry */
-			scp->result = (DID_ALLOC_FAILURE << 16);
+			scp->result = (DID_ERROR << 16);
 			break;
 		default:
 			scp->result = (DID_ERROR << 16);
-- 
2.18.2

