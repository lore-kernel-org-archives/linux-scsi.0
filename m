Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFF6C25B06
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 01:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236266AbiHLBBI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 21:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235962AbiHLBAv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 21:00:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCE685A88
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 18:00:50 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN6hDq023129;
        Fri, 12 Aug 2022 01:00:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=r0oH9dSMyw9lTP50j50+DLxE1tHciWEogscZwRJzrP0=;
 b=adWZaAn2x9hblt9Q36XPB8VSJr2WhmUTh+bJH0ovAsk3j1H319wZ8gTjgzH+QJ0Hfxsz
 aACjHfpB2fsryg+0TNdlYKqlZxzWHeCFPXEbzw8bhAQ9zL6Y8K2Yhd5w44QJTS1K99e9
 nCJh7C/g1HAh0nBfAQZwhTtRT1g1fKudy2m5tx3UtPcHpYtV6nRO9HgSQuf9wpZq4BL1
 h4+DrnEDlEFKmWUYRgxmGbIr/daZzLvoGvbECD/9idO27ihQx1S6iCW8/GGgLx73nnWG
 lY6tWg8HCJtW7v7/Xp8WWIDn50VcZ6cE3+XoPg1LO6bAef+4b8HK9z61Pa5KFei3d/5N Rw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqj65ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:41 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27C0EMO8020384;
        Fri, 12 Aug 2022 01:00:40 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2047.outbound.protection.outlook.com [104.47.56.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqk6bha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3rLfJfNUWq+cD8SHPpmBo9kVY1R3SZ2S7QZpofss/nl4LAVyRYYVz72pZeBB0ifk4aDSnWC9vGo1xjk0fOnXvM6SOcEBFrvUAVMVRsq+ugGU5pQ8+0dUYprqm69HqMOYKqUxLfyJyH5WaWs5wQJRP8rSuzqI5i07Lwf2NyMwMnbSm5X8AMp2kBmZUnvQY1Xoa3cmgg6Lvn+FNXELYZcnw7kCFnl8jU6NuhsLAozkaZMb8I6xxXiwfMEjCuCCRDZAUxmWhb2u8qj6NmdTJga7hpZG6DIlQGDqxMtijL1FqSd+Mccw1Odo0uXAW+yr+uLt0v8yWeCy0jpjPD7G617KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r0oH9dSMyw9lTP50j50+DLxE1tHciWEogscZwRJzrP0=;
 b=OBN1CYfIr6+AXrB0CNuFaJdEFbQO8fwo0LkHsnlmNFxM2wuf8I6jn3h3yn/fsQnwfE7RO/w9rbZQMtYa/KClKfIdTFJjPmnFtNraVYYcyFLjMJmSHspY01egtFLMgXfX2fnpwwoT9gXdQJvuVNxAgAb27raEFBIIk4H95kxnXcm9j5k95JKzbOJIztYZoyOo8R5iWOpCLFxuTcJ3zhfeIFNaiOTGGIqZJaoUKfk8i3awAkq83eUENfg/Ua/nR3LIcZr9iicX+NYAY6MsT5AR+AUUoSd+5qZWEb6NbgAuQ5zwKUXVx+j554Bh3Cg8Uo0D3k8LpRENT9kNHCgQ8eXxGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r0oH9dSMyw9lTP50j50+DLxE1tHciWEogscZwRJzrP0=;
 b=opkU1hBLok9OV5y0Aj38Ol/7KHV+yoYIx1zHxpcIwS/qgbeRpLN44j/P2SELUiW/R0tuq2A6lWJsmrhDTVm4iwv3C/hh47GXDAsw1S7ItnpNraZxgpPrIGLKLLa2VMXI45iidl4lqzPG9tjLyOdRFO4Df6U4ll3TL8qcZkWwSmw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5386.namprd10.prod.outlook.com (2603:10b6:610:dd::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Fri, 12 Aug 2022 01:00:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.024; Fri, 12 Aug 2022
 01:00:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 06/10] scsi: qla2xxx: Drop DID_TARGET_FAILURE use
Date:   Thu, 11 Aug 2022 20:00:23 -0500
Message-Id: <20220812010027.8251-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220812010027.8251-1-michael.christie@oracle.com>
References: <20220812010027.8251-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0034.namprd05.prod.outlook.com (2603:10b6:610::47)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6069e7df-7744-4628-7c9c-08da7bfe11e5
X-MS-TrafficTypeDiagnostic: CH0PR10MB5386:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KT4FPFjl+hIhWxQC5RUAdpzfiPRYuhi0caSY6YaL0q3sLQpnoAaPEp7p5H8tk7gz3IdBVeAxht7n4aGCQyt6Fok2lQ0xpdqFsE4OMVvU2fltF9Z4C0xYLu6INMtNCkf1iwbm2lZ/k/Jb49vG7PMA5T/VhUenG8uoG53QnBaTJDLY43uugiCzlh8xy02vcFDPDwjHfZmiIdQJUHsAG96AokVyyB5j1ATVuug/g1IE2X6oieQBNli8FYwp0rBZTVDpRmpqJevRn3DziIiWktXkNCVIDeis4jav32AnxRd6nXaCsfj4xChpJMvVz0QOwMXdmjHdozzPRBkTsgqncxt1PKemwxAg9+JAdVS+aH2ty4B2p5VUSLrxHnKu8T79wNntV9w1dr2IUNySPVy2svCQi7Ggd/Fmjol5q4ECeUNSvIPuK8/11B99Ei9TRzUTI6mxvHqSiwCakKMBtROCdXwdToMyd9KNT2MGdeld6V0oH9/FFDQVKc9yMSOVuidaDPMiZeMJsiwwHEGntmGsKtkSiOGJ+DgIJdAXtbXyEMhAdbr21oaFcHBCmoUvY7HvTO4LvJVzrQ29MSXz6hhWYLGfa7yqzdBgPJmjOVveRk3u7WOtGq/pieUjj3UXbr9jfT5UpwOTcu8VvnrUOCeODCPZ3m0//a9BWcMvCoBjXxXHpMQfl1sbyCroHz2yOX04/fN9JZUeLWE3MT4haMUJpHdAeiDlhirQroh/0G7rclbvp5GpAFlJPm981DKw4ksasFuXEJeT+BoYox2tXwfSnxzslq0mgJ87CEk/UZcGYZNwAlU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(346002)(376002)(396003)(366004)(921005)(2906002)(38100700002)(83380400001)(316002)(4326008)(8936002)(8676002)(1076003)(66556008)(6512007)(7416002)(107886003)(186003)(6486002)(2616005)(478600001)(41300700001)(86362001)(6506007)(36756003)(6666004)(66946007)(26005)(5660300002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sNozBusD45CHumIe5zOLw4hmB58MO97MX37yjJlRTveaU7v3dYkcA4v+DpK/?=
 =?us-ascii?Q?HycAybp/YaMzFE7OivUyhl4riMqNFMwZrFQmkTtuVLuRMGr5MDTiuWG93Pxg?=
 =?us-ascii?Q?Fslg/usuHWLXVKXMa+D0keYROX93s2/XWkD3NrZuaIJICFQ8Y/s+oSXGXw/L?=
 =?us-ascii?Q?MPX45uQP+hR7arBr0XvVX0bTCvrA4JZydv5GCi2u5HUwXcI6xLw0Pu1XbG0y?=
 =?us-ascii?Q?Lj/4euYxIqwaNZJYcn6gKp1wtyCBuY71k24noFPHLCLt7IMDIPRlv5xKbsu4?=
 =?us-ascii?Q?j7PDftaGwp9RazuYq1aYbujxQ8c/EBzMlGoW4JK7IJO6mgZIthRrLRCWoao6?=
 =?us-ascii?Q?lMnGGXzt5AWh0BrH9n036Lse7zsydsbt2QwEnkiuuM8cbUlg6Bi5zdLq709n?=
 =?us-ascii?Q?i/mi77wWRWDNveDlsepE8ULZKfIWruVDGCuQU7YDgO43ZPnAMHeA3afRS66t?=
 =?us-ascii?Q?e87iyFGI5qKd0V0i3pzrupMmO5dEXVCqou4lw/+aA0okkKS4FVvbGfleHDHM?=
 =?us-ascii?Q?kot4luskeBTS66BdjMU0604/BxLVGbrVLVc/HuzwhIVGbfzYSxnCmkIAgPy2?=
 =?us-ascii?Q?Shf4F00SO4oVAX3f2IG4OVp1HbxGUXMNx+V43K3W7JzaYokFainw3yVA1vb1?=
 =?us-ascii?Q?7ZLZtr8Tsn9d1hRyDaEpMQ77u9bxoucF+3hX6Z5jY9Zgq/aqK2t3Zdhy6eox?=
 =?us-ascii?Q?PnOLZvnBKDigWY2Kzfo9VRS1BRNpbPzhON7dgAqbwGU6xQNVqzE452txdzHJ?=
 =?us-ascii?Q?DbdV2pParvi9myqkamqi3lQopvHTfEezTkHuUawQFyFulQn8Z5Ma0f1rtUTz?=
 =?us-ascii?Q?vhjD1JE9pmL4WjqWx0+sY7pjhdNqkWD+JWJKV0LfhtZ7rptLJy9ssFXLaSL7?=
 =?us-ascii?Q?gmj+VQlms5VmXc4swIoLGSmC0WF8nAhURbiMye32bAmz7VLNCJtX+8V3/Qsz?=
 =?us-ascii?Q?BjlLddBdoZV2j4K7ymf4IzFJfFNuDG08QW+UK33zP1KbUntn2cbqsNhKQUrp?=
 =?us-ascii?Q?5z2D5ZdxqEEh5WVJ0j1XmAckraHXIb4BD/7mgKluRkRnQrsJ0deT+DgGCNNE?=
 =?us-ascii?Q?BIYvuiNEu6n7fZPJubKhcFyozRbb5MYzD7zfEYkRmlkIKaed7HWu7ahweDHX?=
 =?us-ascii?Q?u9LA79jWaOUbT9hIl2jDJ9Aw1+4iZ42/0rVe3OazA7sdFj8jZ8kfxqVGqVdz?=
 =?us-ascii?Q?yUR/3YR3jf8K1dTcoVyH/4oUB/Y3Taz8Z7E16ya3yCPzFDrp+t6PkKMVmCi1?=
 =?us-ascii?Q?UiBNxpS6QOJzPGy6l4Mcp+y/2XR/vQrOp+BB+VNsQWNqm/hzJYcAQYXljqxR?=
 =?us-ascii?Q?9rgqXMWVoO2j421vLZ8XR3lDfgTPUyopTglKA8t1njVXY97cdCxv2q9C4S9t?=
 =?us-ascii?Q?PDXxtjR7tJovt0+QmDJXdEoQoukOJQQN1WKExcSDpHj+18ThCCklNnNlZBhL?=
 =?us-ascii?Q?1VsveEJt159VKjoC6bNdmCaan5UBKl+Ppzjwjf77uqS1//UEW0WkcTeyBHyf?=
 =?us-ascii?Q?QWcuakMftVQO1EZwzbMKdry82NgiUkeTWbgdn9iYxl5i5f5CqbuIE54CqVTv?=
 =?us-ascii?Q?Xv9l4kuBFm/XDIVsHvbx/tknEwwZOfW8T0UM+o4Qnu5ebRiDb7k4u/Twgrwd?=
 =?us-ascii?Q?hQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6069e7df-7744-4628-7c9c-08da7bfe11e5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 01:00:37.9758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dY2Q1YBYp4R1K+2DcBCen17qgz72RnLXQVlzwqkUWBNHidNkcPI+5YkiA4UyqR8FwqnVsyxpHA/NrwbmC40w4CA5I57R35ePk85qEOIqBOk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5386
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_14,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120000
X-Proofpoint-ORIG-GUID: xRPmje_4orvnKAtGmuJuQ-B_f4cHHCKn
X-Proofpoint-GUID: xRPmje_4orvnKAtGmuJuQ-B_f4cHHCKn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DID_TARGET_FAILURE is internal to the SCSI layer. Drivers must not use it
because:

1. It's not propagated upwards, so SG IO/passthrough users will not see an
error and think a command was successful.

2. There is no handling for them in scsi_decide_disposition so it results
in the scsi eh running.

This has qla2xxx use DID_NO_CONNECT because it looks like we hit this
error when we can't find a port. It will give us the same hard error
behavior and it seems to match the error where we can't find the
endpoint.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 400a8b6f3982..00ccc41cef14 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -1551,7 +1551,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 		ql_dbg(ql_dbg_edif, vha, 0x70a3, "Failed to find port= %06x\n",
 		    sa_frame.port_id.b24);
 		rval = -EINVAL;
-		SET_DID_STATUS(bsg_reply->result, DID_TARGET_FAILURE);
+		SET_DID_STATUS(bsg_reply->result, DID_NO_CONNECT);
 		goto done;
 	}
 
-- 
2.18.2

