Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10727C00144
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 03:41:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbiHDDll (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 23:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237097AbiHDDlT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 23:41:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04703E767
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 20:41:18 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2741i3AV019750;
        Thu, 4 Aug 2022 03:41:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=l9zpzpNPOkEh3Z29cHblRapCCJYjaFZP9pMHb9T3qtM=;
 b=OCcW78yO8IWBa+upDO/qM+wZE7g5lJL1yejnfY1yVa17XvsPBqSQFGTVGMfOklCEDCeh
 /iWnw8FLi++gL6vjsDuu6ekg0LC34h/sXBsjn0jCvymtpnGW7szcEs1+rnehB+eI8dqq
 TRzttOD5kq7uvqSUVkOOF046eG0CgAN2A8EoFTAk+vSRoy2ZOhOqt02EmNpQ7XZ11Ume
 Po+WTBOtJb4qV11AvxesjA8Q1cak3Fnz9Cy0PLdpSMbGjc6pls50myAP58x6ULQ+2rnb
 4dOlRc1Sjq2ualsj0P87NrsNGvN43W82DODiu8im1/4i+aaIzOrHC0NrDmnsQaMevI/n fw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmue2uu5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:10 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 273NSOvP010841;
        Thu, 4 Aug 2022 03:41:09 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu33u06d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1Mrt4/y37xKpEVwdMX1JJ1SzAwV/OZlgtc4ft4NGwezKmCbpLzgq6jLJ/FeVLPKQDqOYvK2KTNSiaPEnHO1eQMF7CnMdxsfQKxHXLxs7FJ7OvIy+IYxWySfpYtJFdPu/owTsoGYzdOCafmemjt+tnnPZvoiNrwbVnCha4HFTS8dc+aW5NXk5M4NyXitFcm93UQfPGYtAWJCEdkIU7dw3RLuNQtD7nrsf4I4F6do45D1dyltFO2c2FLvMUkI1HqO8TU0zpNWVc2eVp6RzRbpLAtA7s/eStErfhkcM6GE5UcBhJ2AXpw/0zKbdPehVWKNZSGgjLwMJdi867Um67klpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9zpzpNPOkEh3Z29cHblRapCCJYjaFZP9pMHb9T3qtM=;
 b=Jj58oqehY1yu4Ih0PuRXnZ21xop2P/Xevkfvb2+tyKbEstgX3XfPWggK30Jf7JT7tlxMXJ+qecF51pnjhCmq9k7jriPfFyIJFDpIMD/SzWbjbKS38iPHyyPysf5oWNi2M96pMbMMU2sTmA9lY2fG64jD3JUAD39BnFtp5jyGxXc+GXc7IVWb7x6HDNCXzDFzewQMIKaEbMTSYfsM8+iQtjw9ScoJApsmIGWp1Fa1XaA7mnmkQY2D+EtLsegPnSkFUMd0f3ftvm4d0G6OR+IxceT9kiWEGm5PABBFhGULSq8/yeXZtS85i0Btjq0dN23orqxyS/97uOoersr6xq+Wxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9zpzpNPOkEh3Z29cHblRapCCJYjaFZP9pMHb9T3qtM=;
 b=nivxQuwjZz3euFgfCDEYqQv1kIJcKAr8atDfeJ4uJ+UFRzmt+J1KyJXVaTCFhjZqj41eFdnozKqhdmjcH77iB/CgdGlOGZslh/bAQFLCQg0CjXZNA45nbrk4em7VcGfIRj/fPel9bRV5+r1gJXQdR16R3drObiYBTlvq0qDcN8o=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM4PR10MB6037.namprd10.prod.outlook.com (2603:10b6:8:bb::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Thu, 4 Aug 2022 03:41:07 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 03:41:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, manoj@linux.ibm.com, mrochs@linux.ibm.com,
        ukrishn@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 03/10] scsi: uas: Drop DID_TARGET_FAILURE use.
Date:   Wed,  3 Aug 2022 22:40:53 -0500
Message-Id: <20220804034100.121125-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804034100.121125-1-michael.christie@oracle.com>
References: <20220804034100.121125-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0067.namprd04.prod.outlook.com
 (2603:10b6:610:74::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e19ef80-7756-4eb4-2c77-08da75cb2a32
X-MS-TrafficTypeDiagnostic: DM4PR10MB6037:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cV+mFJIi4qtgrc1QpuNPtq1y+97zf38+BDeKCm/YjPTSb+SReZZECb1pb6REK1X5m/l2/aOzGtUIWW8TpOZ05ulGxLqX+1hHN38r1JGDyl9SDm/e8VL+gZx1JyFW4k9MXCtlQwW34RqZlaKyxF8uDvLdndpybrNTXTG0KmI+USsg83W4f8bvG1OuYfhQD3hMWdat5T3OI27B6bd7IeVDZwN2LIDyB6cFpmlUJ2VNEsMTFQL2HlFB/YTSlW5/sRru5/eECIb8k2Ii6ppsVjTvoOsP+axqDfJXUJYzhrXTWfKGSQJ2vDwOjykWP3c8SFWuxkC+00u6I4OE9b3bS7Lw6PGENh9HkUwX4kT7wVTBXIt33NguwTWmat8srVJCefSK0SZJPTZnUkDdqehEHQTLTaxEw6M/CXhmeoONj3G+4Yq5sfg5eN+zGZzjc3CfW8E11uf9gCkk4nH4ZKTPK5LBTly/5Jk931OulL9Zk2QQh6zqC7ZjdLm29BzF9wvcGb4JPXXPisYU3VlPmFNBOO7XYfoumQY6VMtwrG/7SlMnDCvkfToz1pwhSeisCNzgHZmm75AcmeLy1xGr+BwqBH3YUPeBtHLISCcx9Olq/8sCf4v/DHg5IVw2jkIh6PaP37akJFSIZwJ1A0tpMG8QrOGzKSs2ZbM04OVOzNF/etPC/B9wrW9lXspZXY9s3+yQtzR51nCaO3l0BaTqANBRUPM2Mo4h1zaz1Q5DkuDnjemef6sSIfP77X/jD3kjE/EVavBzRk8A5kHlUMDDej2JKpFPWy2kWwvqb4QO4M/GFfeKCTo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(346002)(366004)(396003)(136003)(1076003)(107886003)(186003)(2616005)(41300700001)(6666004)(6506007)(7416002)(36756003)(2906002)(5660300002)(478600001)(6486002)(4326008)(66946007)(8676002)(86362001)(66476007)(8936002)(38100700002)(66556008)(921005)(83380400001)(6512007)(316002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IdQ71Qd5rvVu1joErav84SRLMkWfioccNZzXbzEpavWpTP2Oc2yhYNiXgcnx?=
 =?us-ascii?Q?itOpLVFJ81cELt/4c4ulHfaiNKZq4QsjZ+Qwij023ACqm1ujsEyawqH94We4?=
 =?us-ascii?Q?FFcMmhldgM4+PzkeNkfAk9v2HcaotCwtoQmUyFhfWy024d7jZC3nw2PNf/p1?=
 =?us-ascii?Q?kUt3j8O+CU3J9j1sGIZVd03lNnSttCoIUBtz84pmBmJPbQMO4zWF6q63J9f7?=
 =?us-ascii?Q?cW+5qXX9hLpqZUzjySkK43/y9cmsVLv87I17FyHfzGwFnM+ZWGpY6603o4GA?=
 =?us-ascii?Q?NF93kG9wJrc5pdKqkaWG//RuGsfkETxZdyGSskjnrXkMZrSKANOTqezue/Rr?=
 =?us-ascii?Q?qPFnJTjOaIp3Kqe13Pds38cI3yC/PwgA5tq2SdWxTCdfqSslZY88fMr4idGZ?=
 =?us-ascii?Q?we83zviIMcHeQghwoXEDsYSko+ZW3fvIc5ly6Fcz/tqirM0CIVSwavuFk6SB?=
 =?us-ascii?Q?zQ3n6ymSM2E2KLFn+PjqNm1RjD5Qt87pruIn/3PxHvK3AKOQBf9ZRxJX3nd4?=
 =?us-ascii?Q?U/5s86e0wDREktMg1hCORIBNn51CM0p5yM/GgkFeTJ+PvDkj1R4JRLqenE1m?=
 =?us-ascii?Q?NbDzSg7GVtRNpLbaKmshPXVzQj4QySYezbc5zvchbg8opAO4Xoy9A68q7MH7?=
 =?us-ascii?Q?uHl5Dqwmhf9Np+Kx1ZH/OZm6wDfJp7slKDT9VIdhDB12eqkrt7SNAQEuyACM?=
 =?us-ascii?Q?3AHybgzWPEuIgWyl+WwHHAHXKMZ56O8AbjlKYnTzBgoL6T1DSH8lXu9PjIpk?=
 =?us-ascii?Q?MfRiC/p8qVRxdJB1VCELTSSWfPZXYojMmXUId7CjaILpE8+mdsSVyHBlVivK?=
 =?us-ascii?Q?r+xUX2UUJEhtAKIk48qn5RxpKTaXeDNGURCP9eupCpp8XGZeLf1VcBS1S/s9?=
 =?us-ascii?Q?a1uEYNvKMKSGnehPwczH0BpHUFXxou02Yv2DwA4rgrIF4x/zC2BQzIVMXITb?=
 =?us-ascii?Q?V9URWW6XAvtYsxYqc50ntmiVGneO5FgwT/QEJGqx2pGmrtpuRGgIE1I8uq4P?=
 =?us-ascii?Q?Kg4u8te+o23yQwU7MiS844wfdNmA1JIs0pwKzkt6rtQZx6CDgaoVZnmetobP?=
 =?us-ascii?Q?wfgrIKqFYelAQGHvtHrkuYK3f1R+4ZoEOyp9FU5/aRIQPYxG7q/Pb/RNk1Iu?=
 =?us-ascii?Q?FDZXMDb4ARevhqZVQq6NkArv6VyiLOEKI6xvBkU33o11Ld1zxy1FiOwNEBWd?=
 =?us-ascii?Q?PY4gwW4eQu9ttge2LuqjhSegwS/TuqrB0I3SqixjvMW0zeYIsByNFww3E3ZH?=
 =?us-ascii?Q?YGpwtlgrbwr3q2vJgjtFVnvYDQ7Jb6gwG58WzLA9gI+JXM+/448rsC0QJOoH?=
 =?us-ascii?Q?vUujH68Bdfq8a4kqxa0Uf27MJZ4GYYJ4nT3976It+IOYBV3IyfLwpukywqFS?=
 =?us-ascii?Q?1YHJeDNtrwfscEo0VjEon2e8v47yy3GROSf5qmS0RXj/3IfBIobO85B7bWx1?=
 =?us-ascii?Q?H9+SiWpIl2+djpRxfNWkE/LZoqFPZV+U1uQfge9gpdUXSrovLUtAhuSMmEEu?=
 =?us-ascii?Q?1EqeMoF3xQyQ2pYsYxeZIXeoV8AHLNMng5lDo6+pn2MD33Vo5O1hA9VdMk+u?=
 =?us-ascii?Q?N5G9eZf0HBNFZKGqMosbTy/epw0NkvfCqzsh41SQUWLHfl52axVQQM28v2Tg?=
 =?us-ascii?Q?lw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e19ef80-7756-4eb4-2c77-08da75cb2a32
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 03:41:07.4182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LVDyhBE9yOWOPEMzy4RXGOYFzOidtjSefu0JbA4lIhgXw7AFFhMQahgzq3n316ifQEnHc9ZPQ1l6QquAUJLLwZO9htSF8qC3EB0r9bB8ezg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6037
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_07,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208040015
X-Proofpoint-ORIG-GUID: zmYo0WayZl5ghblvrCjqpl0gIVgYQEek
X-Proofpoint-GUID: zmYo0WayZl5ghblvrCjqpl0gIVgYQEek
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DID_TARGET_FAILURE is internal to the SCSI layer. Drivers must not use it
because:

1. It's not propagated upwards, so SG IO/passthrough users will not see an
error and think a command was successful.

2. There is no handling for them in scsi_decide_disposition so it results
in the scsi eh running.

It looks like the driver wanted a hard failure so this swaps it with
DID_BAD_TARGET which gives us that behavior and the error looks like it's
for a case where the target did not support a TMF we wanted to use (maybe
not a bad target but disappointing so close enough).

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/usb/storage/uas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 84dc270f6f73..de3836412bf3 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -283,7 +283,7 @@ static bool uas_evaluate_response_iu(struct response_iu *riu, struct scsi_cmnd *
 		set_host_byte(cmnd, DID_OK);
 		break;
 	case RC_TMF_NOT_SUPPORTED:
-		set_host_byte(cmnd, DID_TARGET_FAILURE);
+		set_host_byte(cmnd, DID_BAD_TARGET);
 		break;
 	default:
 		uas_log_cmd_state(cmnd, "response iu", response_code);
-- 
2.25.1

