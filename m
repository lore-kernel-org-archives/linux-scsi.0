Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4944C25B06
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 01:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbiHLBAr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 21:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236128AbiHLBAo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 21:00:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5590D6DF96
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 18:00:43 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN5WPH004252;
        Fri, 12 Aug 2022 01:00:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=cjWFWY9MFeTAjy9Kg9l9TRC6zeTI5JhBszcFFojiKIw=;
 b=EqIX9iplUslvKC5VsfsJt6OoLFvcOMMoO9dqomQ7MCUUoePpb8mPDhWRP+2LCjCaH29N
 INbyVjVhkpaZTJmfk1sPVoihXsOpaWQwO/TUbOcmqqGiobGgrWrGd24n3ZgpDCIb5w+8
 gJpzvDphrd13Q72V+GGWmU57XEM97Og0HPPqF4uMY1K1REYtfO2a8KiuIEaQBBgT2U/p
 5tmKH7ddsdW/r7uQMj14xgcWJF7z5psW2wNzet0nJeEaTgOQ1OU7pebTk1aTp+O5INV1
 bEQ+/S80XBWf19bZ82v/Tm4vL0VZetepSBjPLJSsgd43GIZ9bmvxa1pioGEOV+fNYEhm 0w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwq96bm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:33 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27BNeHNf040773;
        Fri, 12 Aug 2022 01:00:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqhd9qq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZXSb4VlZvhXIVnz23awy8/GTBQg7y1LH12blGewtb+OaRi1XoSGXHgsbdxzxkF9LE/aEMRzWsvEfbFWy+LvLa0BS+ZJCEg5/y6DmzxNuoL0IsU6Vdp8h8Dg681rcnUTdmTiD5Vp8EAYbGoQyFuMvdp7lLdUojKy946IQ5cz+LnJraTWkJFks7GyfNRG6ESy3fcD+eJ22N52LjLRmEMISke0XQXuOvv1f+gG8+M7oh9xSKSrN4wPlFuNBARiuEFK0zmsY27Qrp6hOdd5arQT7hoxuJqSBiKnzqTqd0dxMe/+YqgP3uImHEvNjMM0STC1gN1ME/gL+gPAFWYgjn+2LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cjWFWY9MFeTAjy9Kg9l9TRC6zeTI5JhBszcFFojiKIw=;
 b=aHa/71c3FqfSUdfDxmeARZCIP+U6XallPGhNzvQuFEgdL/+L46fBq9MxBGZa9nxmW+hYmPK/ZQkul2zgV/4rp9CX7ib0aRNv+Ev7HuG/bVQUaKVf0Y2c+RQBnHN0Jp6oqmLIdMo17Yu0anUX+KV3AJmcjxxm5wEwJNcV/Ine7xVixucAx9AO02p4NlDqRqSWOYwSdnbUPPklW+ZiUBDkwv4ku9xyQfcujLm6QVIU3hZcUKdpIB9UqxRJf1mjEBbHSLf/y/PYyZkrE1FJOkBQlPHEvVPtn18JLPa3KiPhRt3Zyk945cTxCuPdLdPvH4B7BJvtHR7621wRgDlWpClvEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cjWFWY9MFeTAjy9Kg9l9TRC6zeTI5JhBszcFFojiKIw=;
 b=PlB7Ri6UJdQMMtoNrlUB2e2yA0XWIm4gAF3Yf1WJ5SbwhaAVDpJDNihZIp31vBRCQn2f+8FtZzxfukobk341ZcfdkVdbDc4tY7dHANWX2yQslIPZ/qAImiKBFQTDMFF7G8XkWRYo9vSXCp2e4Ti4jybcLoXvNuYiHaAdScBBTAU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5386.namprd10.prod.outlook.com (2603:10b6:610:dd::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Fri, 12 Aug 2022 01:00:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.024; Fri, 12 Aug 2022
 01:00:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 01/10] scsi: xen: Drop use of internal host codes
Date:   Thu, 11 Aug 2022 20:00:18 -0500
Message-Id: <20220812010027.8251-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220812010027.8251-1-michael.christie@oracle.com>
References: <20220812010027.8251-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0078.namprd03.prod.outlook.com
 (2603:10b6:610:cc::23) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7762310-dcb5-43c0-005d-08da7bfe0da4
X-MS-TrafficTypeDiagnostic: CH0PR10MB5386:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: auE+tHH27eUelvX/PcG3FzEspt/S9IIQjrtjGzaOSpq6k2mKTBOTZM9jKpbjgfdR8VSN6UR1cLgAo5RtmcyXav811rKyv8TlntkD+IDGR2ThPxPlZNdYJsytgilgTXOPLmuLLkP56aYR24iDJ2A9Jgr9LHBEWeGi5WST/4gXux1QNWySVaw6yR4rcWhcoySKTQsz8UdN4u68ftrqJbekH7Wli3+Bx7GldeEvD4gNIigJg1DpDDuUn3fL6th2wusu5IkbMyIeZ+MqrNBzW7lxfdFAij5ySm7Nh8EOqYDstihiT/Ss/Pl/d4qbKMcYRFhsmbhbeaLcsggSZhVL1rtr8w+APVqcL9S4tzA/8lzt0r7DFcb0g+bFCj5DdaIZx4jExGEdfb+GQEPIAS4XWXUIWBPwWQy2m66ny/8ghVOQv6a3q0Q2ci7toApWLMTka4Ybxdd2aGz7pMh1DNrndtz0fesBNHiLzfzZVPbrq+L1adyOYrz8QUEu06X6z3e2+wW13QepD7cL5EvqiQgNDgbm6MAndv6z5gzwGfHx7LSZsQbUzWEG4FLGisry/xdsHjRb5W2bPdmmwuqSWWEDu5lbVNaZlt6ph7JXbJepaQOvRNXsl3fH1qhgHK8IAIfRIrj+H4hZwQudtwikMOTw8olxroZMKrgHpy8r7AoPYAifk6+LvrkluZCKV+xj97b0/88/35Dz+AQUX3nRJW/oEtUtJb3MaCLSpNEqkKTFCRXpFWlQjUnRBK/osd/P4TMk/7Wr3VZfbEfa5O4Tx2sw6f4HZDApMJ4byoW1i9Wari8JBRQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(346002)(376002)(396003)(366004)(921005)(2906002)(38100700002)(83380400001)(316002)(4326008)(8936002)(8676002)(1076003)(66556008)(6512007)(7416002)(107886003)(186003)(6486002)(2616005)(478600001)(41300700001)(86362001)(6506007)(36756003)(6666004)(66946007)(26005)(5660300002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aABv5KEaCXdY41itV0P9YWBPpiH8D8vTGIIsXULK8S/Uj3dxUmlbz44GblvS?=
 =?us-ascii?Q?lIuw0Rs0NX3ZFdqfad0dGYMH1c1LLCRKSkrrG5y1ORxgf9Pt1BRV/NPzDt8p?=
 =?us-ascii?Q?wB7Xm+CKAzwfwGxzrHo8he3tiEtuKUAZW0fT4HUMq/suVnYdYYNmSby1GOWm?=
 =?us-ascii?Q?8+fb4wyrqO3UDYZOmPtxPMUCHJV3TcdQf/zemAw7fiUVWmbvVQQsn+RKROuA?=
 =?us-ascii?Q?USjmP2zX8HZ/pIiBl15zYRkCWAb5/RX4ib7iNSZ4mK3AJAb4QkT8C1ZMqzEC?=
 =?us-ascii?Q?VAU5fEEsZ1ZeiehHFiKqJXmpSohAqcsOLUZuFzW5/dkrQ7DWInXsntrh3TYa?=
 =?us-ascii?Q?ttTuR/VVRdBM+v6lTsLyRoqM2J+qXTzUoC6Iteey+17VgnvKF9mBSmvIGlGT?=
 =?us-ascii?Q?/1Q6smvVNxpl6vAZtZ/H/ZmU/acnJrASCMpteqXIiY1etUeW7PZt6eDdZDVH?=
 =?us-ascii?Q?RPAHbGPyI97bQexR20VL1s1DW7iCOJA7uOrG9OCCQxfozIr0bpqturgjpS60?=
 =?us-ascii?Q?jjRxPmV8uOPM9afVd9JDXs/s9UpW92lbASDswBWxstMxaCOBuVyMfM9wazcO?=
 =?us-ascii?Q?xKnSYYI1/kwAWcXmvasPsoMB3AJVdgUMzRFqjbxMr4wrxXul4sbVAs5YUCB+?=
 =?us-ascii?Q?2kThnoQu9Yxv/OQL+PAQlBwevTXgTAAMIiNE1N5DneCHMCjVMw1WaqlZz1Bh?=
 =?us-ascii?Q?SnXlq4V9BeW5lTQMG0eRpDHr3LpPfHak3+e4asSPCGqC8+I9FzwvcN9MY9tR?=
 =?us-ascii?Q?vMt5cg9ya/nE2sqo8qJCJd0OQnb2NYaOSNz0TWDmkyqKTHrMk4S8msNFPJvF?=
 =?us-ascii?Q?u/1Nb5+4EoidSamsfm+OqjYrAxqEsDRg1D5jlSvJWh/25W4BOTc27ndcQnEp?=
 =?us-ascii?Q?UtMJ1HlrzLq4T8IVy/OXfOS0QzoZo3KTCCjQAPmzq62dmsT3dYoPejwbVFXf?=
 =?us-ascii?Q?thTJIdb/7yy1pPvYiRY2esU/Cmf/uepqj/fs+H1FkwNVKWCWQYgVZmMU6DNm?=
 =?us-ascii?Q?CXee3Fnwu7qCqs4XGQuBXl/lhpW+9i5s4EnmSd4GFa0ehl+doN4txplwQ57H?=
 =?us-ascii?Q?QLy7GlRi+NOvq9LjdpD/HrHg+J2CDRzjbvVtvc02Aobh9ZHa81J5ysxxzM4x?=
 =?us-ascii?Q?aU9VgF38M3yfhcBrxKU/JJXVOzHt4csjo0HLuu5D6Nma1P+HlokDzknUODn5?=
 =?us-ascii?Q?HKMwoidbK0xyl5waHjBwIeSyVMWH7zdNAHA3Q7VpuGG0ZYKMRqo8WCxGNjad?=
 =?us-ascii?Q?P6DiYjZF18cdEif6TP5lHuZxYrprjXTyGigo0LwuzA9sjfV4ZsiwJMnJBXCn?=
 =?us-ascii?Q?spzRZJ/ldg2GUdb9KqKn1d1SteeglWQokeLqBIcVeHhFMQoo3Kk7hcrtYqG2?=
 =?us-ascii?Q?AEhE6fZ2VkFsizsV5/FlmO/2wnPosSuYrlBp2LNoGktvjpR5NFMQLJTSU5pS?=
 =?us-ascii?Q?fHDCnIloZwEmJgwR2hiEph52Y1tln/5fC+/e3kb7zbMTuxgYCcVc2qGEO17t?=
 =?us-ascii?Q?85nZCNObgeWTN4pMhNgnkLTiLhpa8ADHDOYapEt2KQzx7dCbIXuUgUbMKA8Q?=
 =?us-ascii?Q?drpsQnPCcnnQxMIIHCUCKIUkRUiHlDADBVwpRQLlLPJCttqVi7oYH/IsAROy?=
 =?us-ascii?Q?xQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7762310-dcb5-43c0-005d-08da7bfe0da4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 01:00:30.8826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DpB+5wqDAO4I49XGgq7LfiqJGhxdUFOt+bdxNrhcKMR5EapTSeBTfFy8FMzMJpfygr0CoHv7OHuCOF+ZoaXHd1pgfMel+YkMjY0EAHTL5+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5386
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_14,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208120000
X-Proofpoint-GUID: kJudWStAqplPMiMFHpYSrO9l-UcRu-LQ
X-Proofpoint-ORIG-GUID: kJudWStAqplPMiMFHpYSrO9l-UcRu-LQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The error codes:

DID_TARGET_FAILURE
DID_NEXUS_FAILURE
DID_ALLOC_FAILURE
DID_MEDIUM_ERROR

are internal to the SCSI layer. Drivers must not use them because:

1. They are not propagated upwards, so SG IO/passthrough users will not
see an error and think a command was successful.

xen-scsiback will never see this error and should not try to send it.

2. There is no handling for them in scsi_decide_disposition so if
xen-scsifront were to return the error to scsi-ml then it kicks off the
error handler which is definitely not what we want.

This patch remove the use from xen-scsifront/back.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/xen-scsifront.c |  8 --------
 drivers/xen/xen-scsiback.c   | 12 ------------
 2 files changed, 20 deletions(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 51afc66e839d..66b316d173b0 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -289,14 +289,6 @@ static unsigned int scsifront_host_byte(int32_t rslt)
 		return DID_TRANSPORT_DISRUPTED;
 	case XEN_VSCSIIF_RSLT_HOST_TRANSPORT_FAILFAST:
 		return DID_TRANSPORT_FAILFAST;
-	case XEN_VSCSIIF_RSLT_HOST_TARGET_FAILURE:
-		return DID_TARGET_FAILURE;
-	case XEN_VSCSIIF_RSLT_HOST_NEXUS_FAILURE:
-		return DID_NEXUS_FAILURE;
-	case XEN_VSCSIIF_RSLT_HOST_ALLOC_FAILURE:
-		return DID_ALLOC_FAILURE;
-	case XEN_VSCSIIF_RSLT_HOST_MEDIUM_ERROR:
-		return DID_MEDIUM_ERROR;
 	case XEN_VSCSIIF_RSLT_HOST_TRANSPORT_MARGINAL:
 		return DID_TRANSPORT_MARGINAL;
 	default:
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 7a0c93acc2c5..e98c88a960d8 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -333,18 +333,6 @@ static int32_t scsiback_result(int32_t result)
 	case DID_TRANSPORT_FAILFAST:
 		host_status = XEN_VSCSIIF_RSLT_HOST_TRANSPORT_FAILFAST;
 		break;
-	case DID_TARGET_FAILURE:
-		host_status = XEN_VSCSIIF_RSLT_HOST_TARGET_FAILURE;
-		break;
-	case DID_NEXUS_FAILURE:
-		host_status = XEN_VSCSIIF_RSLT_HOST_NEXUS_FAILURE;
-		break;
-	case DID_ALLOC_FAILURE:
-		host_status = XEN_VSCSIIF_RSLT_HOST_ALLOC_FAILURE;
-		break;
-	case DID_MEDIUM_ERROR:
-		host_status = XEN_VSCSIIF_RSLT_HOST_MEDIUM_ERROR;
-		break;
 	case DID_TRANSPORT_MARGINAL:
 		host_status = XEN_VSCSIIF_RSLT_HOST_TRANSPORT_MARGINAL;
 		break;
-- 
2.18.2

