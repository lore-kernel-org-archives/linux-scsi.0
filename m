Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD6BC63797
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 03:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbjALDIw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 22:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbjALDIu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 22:08:50 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91DF49147;
        Wed, 11 Jan 2023 19:08:49 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C2upe1022836;
        Thu, 12 Jan 2023 03:08:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=IgzHmvphR39o3PjSXKQRjVIpDY4S0MEkoRf/Ej+4fuY=;
 b=uvRiuDenbiykOrONpet8Uxe6NdpJp1Ov9E3BmHAEnehC5o3c/lGd4BX1LK9ohstWVgkx
 llBql/5+ejmp/uGO86BYh6bBZGiA3XLAhXWqcG0dpMFdCd6UAj5IX12oHLH0Mrx2JcIN
 3AlQ2ULkMiT6nC1vHEoecw6afKm6VZAuU/81xw3Lp5B5+iQLsorQ9QGpEkjxFmjdTIyG
 ko4Xf/whdCCcVu6sPcW1WKfYtuTtkAsTcD3kPATU8rR45LXHeC/sGEWkAjvRyvKIxqio
 AwKKZ7HpzGjG45tZLynLVOlawTsZZGes9+O1Og2BESuEEYNqa4UKwmNnySAV2xrSaH4V iQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n28ja82my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C26qDI007539;
        Thu, 12 Jan 2023 03:08:40 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4bkwc6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OMf7eo6CA54EljbVmvMZWthjLCaJwyr/RAH6LIWMHcykFYwZB7Mt6F298vyF9LUIYfXDvLGJnyiKKEe6rJqAdBmslY5ujga/EL1zGUgHTDAsPjEbIvMa5jIjQoRLSXLUI7wpS5EUNiWCOF+kPluh00dQIN04E5+FiYbzfcQcrwDgfk/l+e3pKZvB9XnYep6cxTV2D7WqgaOXAjQ0BsZ4PAuU8C3ZkAuLbDIDiz+3bHyCDjASchhj9QM1+80tLBs/q22s0+ZkAHin3f/bKz57S8V7chhuZK2EvbIJQ+kfz96x+HoPv94plKu+0DBlWbkZZTHUpSqb7klfgAETcivuPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IgzHmvphR39o3PjSXKQRjVIpDY4S0MEkoRf/Ej+4fuY=;
 b=HrExJQE+nl4qJoG7ZnBPzPAm2OovqcFJ/2QlryNxElh5wCPj7O5UcBLJd50H+zPfnrVlfIEa1r6WPR6gip7tBF3YqcKYtTFmPN13XmQUiMdX8tkexdAB7DVPR0dI0cmni9prAnPA3181uGYo7qjV6W/FFXuCkcFMbsjr3/SRJ8yQFy7pI3yrfHLfpaHktCyY23bX4hw1fyWsyzGZbEqGx/585pCEX8fTM4GpdmXWM3IG70/YffDnF6ESYo+ZnpO7zUZy/VWjPWZQffSl5uNV6bVpy8y/ohcLWcdQZmRxXptfjp1bnEmZ1Kxf1kTmFOB4BmzB0Ts8h5VgPoRctk3G8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IgzHmvphR39o3PjSXKQRjVIpDY4S0MEkoRf/Ej+4fuY=;
 b=GwOF87sFLHWxuhjFu9A3CU1IJ9a0pFa0JWqnc90ht60fSIF2CZWoAMYSFWyFerdTIcIn4tUnt3EFrRTph5y868qIvsj5x+rSnr4zPyqxk/k4fIvMwp7HsusvBtAMNmxi23rEv6DcOa8hPt/9iw0fM8XFQTVpXi07tMXbQ50i2nU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN7PR10MB6595.namprd10.prod.outlook.com (2603:10b6:806:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 03:08:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Thu, 12 Jan 2023
 03:08:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 02/13] scsi: target: Move cmd counter allocation
Date:   Wed, 11 Jan 2023 21:08:21 -0600
Message-Id: <20230112030832.110143-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112030832.110143-1-michael.christie@oracle.com>
References: <20230112030832.110143-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0379.namprd03.prod.outlook.com
 (2603:10b6:610:119::6) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN7PR10MB6595:EE_
X-MS-Office365-Filtering-Correlation-Id: f35803d4-47f3-4b6d-c915-08daf44a4d30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gOamh+Ms3jMOjn0vbGT+HP03GLFHpFHA66r6Dq9So4jDuQBZBuyGXTti5NMfl7TIpfTww7E1rbX4+oqZ7c+L5i/YOS9jv3+//5kHNXnA2cq5N0bX+H4+czsiZuWkWTwzy9blK49uP24BVPgXqj9OVFBzn4ReWlzEMjCzXiOu0CjH5rxREadpvw1RO/y8/ay5/vDJM0+wSCOCSpRdIM+mCxv2Wse8FZGilDNfWTomNzoCv/3FP8n8TWbmgNLAfhj2zJNvc9fGkdayNDuYQhhqEC/VXTZeL9OM9fH47zAlJQHCs4wuphK1OwOO8crfFPwPzCqSIAq2KM18sOhyGPSzCRIgSngRG4j8eLAxZHSYTUuC4yA9cMRdxz5m1w8wSSWiLjgvnzvBaO0jz2KyUXoYaUAdmFoJuYZ196xK2+15WkLxgKUtv9vwXEUeNGZzFDgGJJZ/Ej1RQSTuo0C6o0Sr/i0CR3w7mheeudjIVBZ3JYHtc/C5sAzztZUXpIqlm7J9gFzhBzXI/lpKIUEvDeAuGhfxE1xMwQ/aJZqSS77wtBHasC8HCJPEI/eAZEGQxRHaa8ndRImo5UGsfkXP3Ma2Nmk0Ab+6Zh+NK+C4aEk0ao+72uERd8qQao3UDoEKfzRpgUpcO/qpi9tW/HS5or3GAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(39860400002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(36756003)(2616005)(1076003)(6486002)(316002)(478600001)(107886003)(6506007)(6666004)(26005)(186003)(5660300002)(8936002)(6512007)(2906002)(8676002)(4326008)(41300700001)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kgemKBI0cYJssbBK00/mZsC9M8MZJIrcN1EhL6aFiBCr/qNzx07y56i6u7dx?=
 =?us-ascii?Q?hQWGkkL0VG54+9Qfed+CCtHCec2gRPROU1CXcUFJ+2S20K+uL85AClO4/PS7?=
 =?us-ascii?Q?w4wXajNOn62KUe0zvZEVOydSFM/2GtwdF5wF2eG5kyhM0nFfvTw9cd6dIefJ?=
 =?us-ascii?Q?c1sSOgPDgMvDXbESnBOf7zlmRxEv4HKZLyMds6byIsdlvLKqL3seB4B3bPQq?=
 =?us-ascii?Q?kHYEREBkkM2kVCFy9JXcUE2vWeBrwBJaKmHeNFbMYWjCDs0wzUsiWlfT+WQW?=
 =?us-ascii?Q?vRrvAvE+Ms8nnO7AcfaXIKHdSedNrnYM4OM6PuG4hG8LkOnXllY35pW13GJ1?=
 =?us-ascii?Q?WFr3ZLVwct0lrMTuOjBjKmQAgYTDkE21H9YgA+VgI0EjYRemf5LkUHDKUuCE?=
 =?us-ascii?Q?XQRnF/9X+BBcvhqAniTyCPR8b2nDqbGPKoksZsURHEXOXb4d9/FhRhCwfzye?=
 =?us-ascii?Q?Zl0vFXApkVTmDvCWi1/jsWmCyiX82C2kAk2JP/m3kEnESrMQ3IldQ5PqV27c?=
 =?us-ascii?Q?VBBVm5SRAyMnzXJmZAL2W4VYQTjjEWFLkCsmj42PT3O6WW9dtgFkQeqCnJPw?=
 =?us-ascii?Q?AIeIaIGnk+PnbY0ZOl8kAT3Y8qpmV8YfIfCGT5C4OWZ7I68lCz4Sed52LIdb?=
 =?us-ascii?Q?SHYkE/SAMdyGOmxffnkTjAG3dEjjJVUzd0eJ/YuA8AE155CLxYeAOygBr983?=
 =?us-ascii?Q?kHZ3qHaI+V6qve05pTAlAjqEAkC+gKJ40821aJ7pFF80IZ9n4Grd0LgtLMwl?=
 =?us-ascii?Q?voq1fMY1DxCND6NEmoStM3bNPyneTJPSYLd8snez8icjmIyEEG9xk14fnjm0?=
 =?us-ascii?Q?3SaU0NQVgmoUv2vrc/lGSC30G+l6Yw6dmb5lEjBdJMM3sFphYdNohr7XSILU?=
 =?us-ascii?Q?Pbe74BkiLWT3DBLMXSaXiZqL4otn+Ztxdy+kjF5c9Y6BgWIU0lOLIV7G49Fz?=
 =?us-ascii?Q?Bu2kfJ5KiMFjNs2g+A8DRwbSmsQmtFRkNiZ31kSZfGJU6lzkb51Mf/8BBMXb?=
 =?us-ascii?Q?+tDyUJdcjeL97MoDFOvgW9gquTVF4J+UI91UBLnH1evJjD7+eTdOE8uyZrF6?=
 =?us-ascii?Q?IG4mkG9hBNtspYbdSowI+iX/4kXcgVwjGd3gS6H2l9qWZRP1vHBDo7k/ZRvM?=
 =?us-ascii?Q?zQHy5iMC6qS2REcIpfyBPVEOk6EPYGa53bbcX3J1Vj+fCzkuUG8ft1OJqXf1?=
 =?us-ascii?Q?hJpzBJEZs0WvUr13d2kQukD2gokdx1he6ta/7OA33djEMB99fGBrGn6OBj0p?=
 =?us-ascii?Q?Pbv3UaKvBbdv5T09SIGflPvxWwd6zN7sKBhkxApesAMT7thWyXvnH23SKGoT?=
 =?us-ascii?Q?909P3G4IhxY0cX5g7bK6qmQv/CPrV//xHcMKRQ9M0dm4SK6RDE9ZTqqZ6x/f?=
 =?us-ascii?Q?LQTXnN2OzE5AuuE4FCDrQDCzbQKtpF2zXLWq0IHI/x2GJR/smamfH0cIIeFJ?=
 =?us-ascii?Q?TrLQByjcGVwTclyu6AR4EHIXoxyYFx+Y0fd3ew2beIwQB/E6hFCpsxAOV8SQ?=
 =?us-ascii?Q?OLv8lFMwq7Nu8KumYJWJYousL0P3u78MFEGWlOeG9yEzrpDflq13IpIRvy/r?=
 =?us-ascii?Q?GoOjr6/kzZTdBWlQ9S0YT0hsGMZ/J9y2sPozu0Exjv4r3I/9cf7uyFIMT1zF?=
 =?us-ascii?Q?hA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: f7vfAHWpLdsCS91N/49wt4XKUTvsw9eIv0gl5ogornb+nm0uqYBnjmZMryS+TIFCnLgv8FypDjddhd0F/MEZr8XKu8AdZ3+aDejFiIf+d/vmd8y3pluaedWbKkQka1/5zJ9AvWW8olHch94RQm8T1Z1+LG1uCatavkDUacB1mYR0X0JBc3MEWfr9gGLKeE06ZLDOTBFlXdAaVpQG8o7yjOXiOL0gbjRJ2D0Az3uQfhChrOBpNpmlk9AugSr9yqum3G0oTbCOTWte3tNKaS/np6Yy2xvl+wa3f4KG6FoQYMSewCpJX7XssRon+mAEcgLymv9mTqOdNr0UKkny6ecTJgMTfk0S2MTq+K+sPAzbdlcCIFCArfX55rI3PkB63nE3GbJdYFTeJyWzoQbw7jl5Aw7KQMoJ962DJqTxMHjfoT9uaSlV/Z8t7Qpd7XMwPiH8uVwwmoSWOuTe7ZP1umSdjykQ8F3lreGuYjTbzd1SdAXTJCKwGM5OFN0tPouwe4ORoxzR3VgGMqdWg7bLSL/FQS7AJdi+hZB1rJPRqOAqx1rhKf9HI4pqcgVf5el0ixouRz/LwM/voLttyWAU0WLe8XObR+BjApPi3iE1ghI+SAztwpsJ9qLzhI1fcFmmtACFu6XnYn8+Q19lv/ATEKwVrF/vo8j2zZt77tAiuodwSwxCMHCF/19CeveIctX9xA2ggV80eUbfknS9CVJzBMhqHdrlZV7ZXRi8eyseod/rZ+8Aiyg97e+HQ8Na14jmkbna1CFPpwOVPKI9PYYeF2+Xdp08wpw3dWwnlGSWFjf+r+2LctD4lGccgxcrLC9kaXVaUtCDQ+V8/Rz9VkJgvOL+N+lDg/CgDlZYRpFxE/6CktlZbrzD4l0ANe/4nGCCjUQR
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f35803d4-47f3-4b6d-c915-08daf44a4d30
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 03:08:38.7865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jn4w1hBQt4IInhrO4fbhfcot8IVQikVIM6p19YP+AznSjiD1cPGoPG1oQC1iDqYhiMrNWtyivLixhoNf3dK6uSZtIsdUyLR8Czugn6dEH/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6595
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_10,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301120019
X-Proofpoint-ORIG-GUID: Tx2VMfpBdcSEbFuMV2FCynH58rCQ6p98
X-Proofpoint-GUID: Tx2VMfpBdcSEbFuMV2FCynH58rCQ6p98
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iSCSI needs to allocate its cmd counter per connection for MCS support
where we need to stop and wait on commands running on a connection instead
of per session. This moves the cmd counter allocation to
target_setup_session which is used by drivers that need the stop+wait
behavior per session.

xcopy doesn't need stop+wait at all, so we will be ok moving the cmd
counter allocation outside of transport_init_session.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target_login.c | 10 +++++
 drivers/target/target_core_internal.h     |  1 -
 drivers/target/target_core_transport.c    | 55 +++++++++++------------
 drivers/target/target_core_xcopy.c        | 15 +------
 include/target/target_core_fabric.h       |  4 +-
 5 files changed, 42 insertions(+), 43 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 27e448c2d066..8ab6c0107d89 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -324,8 +324,18 @@ static int iscsi_login_zero_tsih_s1(
 		goto free_ops;
 	}
 
+	/*
+	 * This is temp for iser. It will be moved to per conn in later
+	 * patches for iscsi.
+	 */
+	sess->se_sess->cmd_cnt = target_alloc_cmd_counter();
+	if (!sess->se_sess->cmd_cnt)
+		goto free_se_sess;
+
 	return 0;
 
+free_se_sess:
+	transport_free_session(sess->se_sess);
 free_ops:
 	kfree(sess->sess_ops);
 free_id:
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 38a6d08f75b3..85e35cf582e5 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -138,7 +138,6 @@ int	init_se_kmem_caches(void);
 void	release_se_kmem_caches(void);
 u32	scsi_get_new_index(scsi_index_t);
 void	transport_subsystem_check_init(void);
-void	transport_uninit_session(struct se_session *);
 unsigned char *transport_dump_cmd_direction(struct se_cmd *);
 void	transport_dump_dev_state(struct se_device *, char *, int *);
 void	transport_dump_dev_info(struct se_device *, struct se_lun *,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3d6034f00dcd..60647a49a1d3 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -228,7 +228,7 @@ static void target_release_cmd_refcnt(struct percpu_ref *ref)
 	wake_up(&cmd_cnt->refcnt_wq);
 }
 
-static struct target_cmd_counter *target_alloc_cmd_counter(void)
+struct target_cmd_counter *target_alloc_cmd_counter(void)
 {
 	struct target_cmd_counter *cmd_cnt;
 	int rc;
@@ -252,6 +252,7 @@ static struct target_cmd_counter *target_alloc_cmd_counter(void)
 	kfree(cmd_cnt);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(target_alloc_cmd_counter);
 
 static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
 {
@@ -271,24 +272,14 @@ static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
  *
  * The caller must have zero-initialized @se_sess before calling this function.
  */
-int transport_init_session(struct se_session *se_sess)
+void transport_init_session(struct se_session *se_sess)
 {
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
-	se_sess->cmd_cnt = target_alloc_cmd_counter();
-	if (!se_sess->cmd_cnt)
-		return -ENOMEM;
-
-	return  0;
 }
 EXPORT_SYMBOL(transport_init_session);
 
-void transport_uninit_session(struct se_session *se_sess)
-{
-	target_free_cmd_counter(se_sess->cmd_cnt);
-}
-
 /**
  * transport_alloc_session - allocate a session object and initialize it
  * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
@@ -296,7 +287,6 @@ void transport_uninit_session(struct se_session *se_sess)
 struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 {
 	struct se_session *se_sess;
-	int ret;
 
 	se_sess = kmem_cache_zalloc(se_sess_cache, GFP_KERNEL);
 	if (!se_sess) {
@@ -304,11 +294,7 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	ret = transport_init_session(se_sess);
-	if (ret < 0) {
-		kmem_cache_free(se_sess_cache, se_sess);
-		return ERR_PTR(ret);
-	}
+	transport_init_session(se_sess);
 	se_sess->sup_prot_ops = sup_prot_ops;
 
 	return se_sess;
@@ -474,8 +460,13 @@ target_setup_session(struct se_portal_group *tpg,
 		     int (*callback)(struct se_portal_group *,
 				     struct se_session *, void *))
 {
+	struct target_cmd_counter *cmd_cnt;
 	struct se_session *sess;
+	int rc;
 
+	cmd_cnt = target_alloc_cmd_counter();
+	if (!cmd_cnt)
+		return ERR_PTR(-ENOMEM);
 	/*
 	 * If the fabric driver is using percpu-ida based pre allocation
 	 * of I/O descriptor tags, go ahead and perform that setup now..
@@ -485,29 +476,36 @@ target_setup_session(struct se_portal_group *tpg,
 	else
 		sess = transport_alloc_session(prot_op);
 
-	if (IS_ERR(sess))
-		return sess;
+	if (IS_ERR(sess)) {
+		rc = PTR_ERR(sess);
+		goto free_cnt;
+	}
+	sess->cmd_cnt = cmd_cnt;
 
 	sess->se_node_acl = core_tpg_check_initiator_node_acl(tpg,
 					(unsigned char *)initiatorname);
 	if (!sess->se_node_acl) {
-		transport_free_session(sess);
-		return ERR_PTR(-EACCES);
+		rc = -EACCES;
+		goto free_sess;
 	}
 	/*
 	 * Go ahead and perform any remaining fabric setup that is
 	 * required before transport_register_session().
 	 */
 	if (callback != NULL) {
-		int rc = callback(tpg, sess, private);
-		if (rc) {
-			transport_free_session(sess);
-			return ERR_PTR(rc);
-		}
+		rc = callback(tpg, sess, private);
+		if (rc)
+			goto free_sess;
 	}
 
 	transport_register_session(tpg, sess->se_node_acl, sess, private);
 	return sess;
+
+free_sess:
+	transport_free_session(sess);
+free_cnt:
+	target_free_cmd_counter(cmd_cnt);
+	return ERR_PTR(rc);
 }
 EXPORT_SYMBOL(target_setup_session);
 
@@ -632,7 +630,8 @@ void transport_free_session(struct se_session *se_sess)
 		sbitmap_queue_free(&se_sess->sess_tag_pool);
 		kvfree(se_sess->sess_cmd_map);
 	}
-	transport_uninit_session(se_sess);
+	if (se_sess->cmd_cnt)
+		target_free_cmd_counter(se_sess->cmd_cnt);
 	kmem_cache_free(se_sess_cache, se_sess);
 }
 EXPORT_SYMBOL(transport_free_session);
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 49eaee022ef1..49a83500c8b7 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -461,8 +461,6 @@ static const struct target_core_fabric_ops xcopy_pt_tfo = {
 
 int target_xcopy_setup_pt(void)
 {
-	int ret;
-
 	xcopy_wq = alloc_workqueue("xcopy_wq", WQ_MEM_RECLAIM, 0);
 	if (!xcopy_wq) {
 		pr_err("Unable to allocate xcopy_wq\n");
@@ -479,9 +477,7 @@ int target_xcopy_setup_pt(void)
 	INIT_LIST_HEAD(&xcopy_pt_nacl.acl_list);
 	INIT_LIST_HEAD(&xcopy_pt_nacl.acl_sess_list);
 	memset(&xcopy_pt_sess, 0, sizeof(struct se_session));
-	ret = transport_init_session(&xcopy_pt_sess);
-	if (ret < 0)
-		goto destroy_wq;
+	transport_init_session(&xcopy_pt_sess);
 
 	xcopy_pt_nacl.se_tpg = &xcopy_pt_tpg;
 	xcopy_pt_nacl.nacl_sess = &xcopy_pt_sess;
@@ -490,19 +486,12 @@ int target_xcopy_setup_pt(void)
 	xcopy_pt_sess.se_node_acl = &xcopy_pt_nacl;
 
 	return 0;
-
-destroy_wq:
-	destroy_workqueue(xcopy_wq);
-	xcopy_wq = NULL;
-	return ret;
 }
 
 void target_xcopy_release_pt(void)
 {
-	if (xcopy_wq) {
+	if (xcopy_wq)
 		destroy_workqueue(xcopy_wq);
-		transport_uninit_session(&xcopy_pt_sess);
-	}
 }
 
 /*
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 38f0662476d1..65527174b8bc 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -133,7 +133,9 @@ struct se_session *target_setup_session(struct se_portal_group *,
 				struct se_session *, void *));
 void target_remove_session(struct se_session *);
 
-int transport_init_session(struct se_session *se_sess);
+struct target_cmd_counter *target_alloc_cmd_counter(void);
+
+void transport_init_session(struct se_session *se_sess);
 struct se_session *transport_alloc_session(enum target_prot_op);
 int transport_alloc_session_tags(struct se_session *, unsigned int,
 		unsigned int);
-- 
2.31.1

