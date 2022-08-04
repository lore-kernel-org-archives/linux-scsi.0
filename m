Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A3DAC19F2A
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 03:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237610AbiHDDln (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 23:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbiHDDlV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 23:41:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3721A40BD3
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 20:41:20 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2741hsFM030432;
        Thu, 4 Aug 2022 03:41:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=KP/N0PPw2rrHGFz83HkXJJPj6wXJBxnKrQzrD1MUNgo=;
 b=NlK9ajpbldlGSnrhWtJWM0xBtc4oJKEmYw23MCAeskjULF/BxTqDXygyCerJ80NOE13h
 KfWd7JaqdLSlfE6yYhoPC9HTyRS4Xv/zFAOJz8ENGoGlhEfhXPYz/hyjR+LzJFHF2DPP
 2JQi0oMR5y/yr4IQFRIP37/ZJ+LfdH+BicVHCj3J/e670oajHdF58QK+63dn3sVx01SQ
 K5YkE6U0uScqX3Mbtp2TJHwXVoxDGnPzsbEUCBnIdxkIai/Nss8911EXvhbnUphSk/l+
 XoAFWnq7nP/ZIwASapGPyeQx8LSYbNm9u9itd71QEYFLJZP+LzRK0qFPj7LXSPwsClWL kQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu2cbfke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:11 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 273NSOvQ010841;
        Thu, 4 Aug 2022 03:41:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu33u06d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iho8lriPHcnYIM398nxnfZGDp840bODrXTPPogsUJGBujccWzqDPkpvvvrZ4hth4JR+5QfrgnBhpUb8nbw9IxKdHJhzUfmMX2M/txBPCJ1Rzgu50US7WnQMGauPD8nmLMc+fj9fnTyPDnbclrc2MqCcJe+rAr+Tykk7TAt8iXYRLHNFhnymN4WaSFc0dLskWmp9x4G27lYo3jFwfZmZI4GcUSj7to95vuneB30Js5WiETcFEN4ivne7C2SvJocnNlQRWG5VD+9Q4e1xsTkJ60l0Kyum7LtTW+zgvK6X+lsmgu4rrJhh5VgNTjyIT87UGTk3xhrdMZt13dfsGrtQSJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KP/N0PPw2rrHGFz83HkXJJPj6wXJBxnKrQzrD1MUNgo=;
 b=ejWWhyYXg59iYCmZtXbU1G1oujK6NbxaXcqndHhirzYUNbWlDr1+msFvEmpx4Hj7xDgNXtx12tnVOAYq2pGQHcR3apDPK9GTIQHhna3xsmB1y53Mv7zjkSXjCjvzgnAVt+Ur1TCPSHEEiTAUdiLkQUxduM5CwhV3l0ki5WWc0R06NEnOHo21m/nQEOSJuxhEchjS2vcKcqi2wyMxQFZvkTQwySkSm24SRCLYWi3wdBx5RwHTRjWHkjeRyZoulj6gbUn7Z06L6bHWea47xMWueiuI+WjfKOpryI0b8EC/ianIDiH+JDlwrv94TrjMMvkgNqLKFhuy59QI3wh/k2dLRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KP/N0PPw2rrHGFz83HkXJJPj6wXJBxnKrQzrD1MUNgo=;
 b=Y8B8YtroFETU6cbd7k9NDPgvXq4WoB4sIlMY2m/LdzeCObYnFylVx0NvvsZC6+ytLEShcOEbEIxDu3D0xyLgAn3wOfAPYkvxY/t55CJrAs9PwA6Zwew88bYZlYxsYT8haMEGGx2rIZh5lixUeVB33gxmDIz9VhW/MM/9HXOHgKY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM4PR10MB6037.namprd10.prod.outlook.com (2603:10b6:8:bb::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Thu, 4 Aug 2022 03:41:08 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 03:41:08 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, manoj@linux.ibm.com, mrochs@linux.ibm.com,
        ukrishn@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 04/10] scsi: virtio_scsi: Drop DID_TARGET_FAILURE use.
Date:   Wed,  3 Aug 2022 22:40:54 -0500
Message-Id: <20220804034100.121125-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804034100.121125-1-michael.christie@oracle.com>
References: <20220804034100.121125-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0238.namprd03.prod.outlook.com
 (2603:10b6:610:e7::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7449c7ad-c424-4f35-8261-08da75cb2aee
X-MS-TrafficTypeDiagnostic: DM4PR10MB6037:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H5Tv7fKzbocr29fRA27nOjzQmE+8nonfzKM5V7vq4EFHCXSL95rgvW16Q8G2b983ZeLALo6dTe++LcByH2IEHkQSTDy7Sh+yMERBXDOvI8NwlFdTyVvrXH1HqSdnUXK0h2R91zjSb0wmfp79tKgEGPN5hReJiU+RktHU7Oqgapm6NJPKxJjyt8yK/kTxP8N7Tv+pqllQqJJLMmUdXsheozFM7ZLCGpHo742Kze98IDe/f816t4AfHwdSBE8ASHVpF5ICTEbLXFPJiT1J2+amZJhHQzOf3w+IhmNwOFQgamCUU+NVNq1U+nRD7d8cH+/fhFraQlbJUdWGtP5er80cI4KS2LBoKLY/MZZXyGrbAkh9R/Gmo+yLV6n5/S1H/v4Yq2KEIBP7wxkpaJUNTa48DJE1iH8YeeYTvI+gCDgroUNiSaTEG3Y/4pXrwA0geXcsZMUwMkLGWXvsm8Y0W7Eea5dbbEOCg/1O/+H4yty73/UOvgjiojqmZILhIMk2Qge5fWKvYSTpaUav/tgkyScxm+CA6aSAYQezysPdIaYRdPPxz2D9Febx1NMnqe8baYUXIW9gne/mUPqAZmhvqyRZeSi/f1aCff6nzG+Wz10jH/kpkU0GLndDuG2yUeBizQomYmYbL6j+41Sj0SgoGg1NkUbrflkQGrvMo48ETOn8HqfYcTtcD7CwwpY5RXXpb+Uu5/w7OxvivqGu/AzUdEbsLUz5yZcJ+HEi+kuvo1DdCHT1vdrGnX5kAHHKPI50zcINxYwtLiZokPAKlvoLbavKdGx5InXfHulvryNaE3e9UpA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(346002)(366004)(396003)(136003)(1076003)(107886003)(186003)(2616005)(41300700001)(6666004)(6506007)(7416002)(36756003)(2906002)(5660300002)(478600001)(6486002)(4326008)(66946007)(8676002)(86362001)(66476007)(8936002)(38100700002)(66556008)(921005)(83380400001)(6512007)(316002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TMZwkXUV+5ZTygwwo7D464fbE+uzs6T0ZbqkMTzgcuaetjLg8T7n1yLyPYzG?=
 =?us-ascii?Q?g/8PHh3miC3eWl1Wb5FkJij9eNwH3dEew1yPzl7BzWkjOKa2g7CkkicYseSW?=
 =?us-ascii?Q?Hoye0g08JokajMmJCZ3LaoYBCvdLeHF3IYeEVbhUzBM1/pnbgISY5v2iKR9J?=
 =?us-ascii?Q?dcB9mblrQWnuJThb6Z/BHo2V0CycLf3J6gvxsIQ9lD3Fwj3ZyhyZOecG8JRN?=
 =?us-ascii?Q?xGRDH44Z4a73mnsJbCyCGNDbaxepGDmwNYd5S5BgX5Lb8goLFx99yG5Nxjgi?=
 =?us-ascii?Q?0sS6Ho1Oa8Vz4KwFw+vrHLBUcdggH6O6raACobhwS6ep4r3HQXBwX1v8lwif?=
 =?us-ascii?Q?n7GS/js/MwqBsDFYpEzQTpCax+WgxK+JSYIa4FfMR9YZRwPK8+/K7ayMR4uW?=
 =?us-ascii?Q?7iAQ8ifbWViWw1kwCOchCqsEhwtUtsFNMCckrnia3PiS+nNQdorJMkrUDof3?=
 =?us-ascii?Q?DonhyIi0VGpeEHHdW3++iTvk6fy7chSqC8R5nb2nl8wCov6hEY9tUeCSeUup?=
 =?us-ascii?Q?07lFB5dKAQwfI/sZVRsfHi5Jk0eI7BByIaBcWKw8Hv3c0GL9UrgAIfcuHjhf?=
 =?us-ascii?Q?6qd970GzF3oCoVOcFWG9fkMU7WFx1Xg9GxlC5Qz70mTDAu79bmEVR9Iz8YKm?=
 =?us-ascii?Q?H/6hqGbVxztm0124OAh5ctuh95RuM1fXQ1Rv2XGVo0FVkFzM3aNL+t/TvFLG?=
 =?us-ascii?Q?EOdiDS5xCMhhkfGAP+HTidZaHIyrYE/sE5Z0kWXL2xl66ILZ+2UQx2bzkGb8?=
 =?us-ascii?Q?rroAM5pcPzDSb0E5xtlHWpdxx49PysBiq7CCkjHEf6L9IY/S9f+VK+IoDNUU?=
 =?us-ascii?Q?EzyAWj9F/Pd8H9LYzD5NelRHr5Liz389fU2NucedPaWFD1foRrE0JiesFV5K?=
 =?us-ascii?Q?e28a0hpLdSBTie8Hd/+yCeUKqKYVbuZ9kvXdAs8/+0rDLKbjbaBwAQD/HmJt?=
 =?us-ascii?Q?EfKFTM9oJMd339FcNuPSEErgnvDZs3CBzN99Py6qMfKrZiiT7M3Y0Pfb2yNq?=
 =?us-ascii?Q?9IU0lma9Vw7q2X2mZzygPCWLyMroy1C/FslkADhOCtsYHpSwIrj7gsPLvxwl?=
 =?us-ascii?Q?kwK8J8XtiVUsW6vQb6AhBoZrXRaiFx+75grB5Rwq42N0Ym5myhT5x1Uk2jl2?=
 =?us-ascii?Q?qjd/Eph1fT5ToyCDBCBrtDHWlrIzYb52Pj+Tfh4YqZgLu3N3O5+B2HXywsyV?=
 =?us-ascii?Q?WeMQFnrzIHG9GNqcQC8Y//LaVZQuyhv/R3CWBj5J4s/04Xr8b/WqYMyNVWfp?=
 =?us-ascii?Q?7sxh+9sRWp6qfbCL6vHCWqL13GQrIwHyLkWE5P9NVSN8D9UqqPv3ck7oFhLe?=
 =?us-ascii?Q?T/JkEVMUCpov5NH7RwnPa+u4VCfxMjQ5/Br1I2rwEFc7wnajp8L5y7TFqmy+?=
 =?us-ascii?Q?daxnJo+uxaciouo1DYJfTgxDIirEOV/M36Z/WWuEZv9kiKnT0Xx1g/Eohww6?=
 =?us-ascii?Q?TII62idzCS4OIASa8yiOfYHO2ElfkSRBGssLMEwIsXu+FoP9ElOTHCVEyN9t?=
 =?us-ascii?Q?8Jpy06dZfL+/a7ed58lH2feBC2DUUgj9aaYzKCJkhXvQAfdAZ8OqAltpu2QC?=
 =?us-ascii?Q?oBkY8qll/qMblcRd3eoH1DOyAc7jv38YtnT1/V1xC1A+7DMojOO+KeJ+5+/O?=
 =?us-ascii?Q?gg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7449c7ad-c424-4f35-8261-08da75cb2aee
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 03:41:08.6681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L1xiS0Z2NiaBRZYa+SGqyG2zdcCDQKNZnaRC/ctnZYaFqtcfbpjahUO1LOfhf4TRYmQusiIprvNMtHXFR3TJF3URJ++Sv3kutb6G5Fg6Nbw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6037
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_07,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208040015
X-Proofpoint-GUID: fEcIJn1L6Lt9psMwN4YR4F1Vp8sBqwI2
X-Proofpoint-ORIG-GUID: fEcIJn1L6Lt9psMwN4YR4F1Vp8sBqwI2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DID_TARGET_FAILURE is internal to the SCSI layer. Drivers must not use it
because:

1. It's not propagated upwards, so SG IO/passthrough users will not see an
error and think a command was successful.

2. There is no handling for them in scsi_decide_disposition so it results
in the scsi eh running.

It looks like virtio_scsi gets this when something like qemu returns
VIRTIO_SCSI_S_TARGET_FAILURE. It looks like qemu returns that error code
if a host OS returns it, but this shouldn't happen for linux since we
never propagate that error to userspace.

This has us use DID_BAD_TARGET in case some other virt layer is returning
it. In that case we will still get a hard error like before and it conveys
something unexpected happened.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/virtio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 578c4b6d0f7d..112d8c3962b0 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -141,7 +141,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 		set_host_byte(sc, DID_TRANSPORT_DISRUPTED);
 		break;
 	case VIRTIO_SCSI_S_TARGET_FAILURE:
-		set_host_byte(sc, DID_TARGET_FAILURE);
+		set_host_byte(sc, DID_BAD_TARGET);
 		break;
 	case VIRTIO_SCSI_S_NEXUS_FAILURE:
 		set_host_byte(sc, DID_NEXUS_FAILURE);
-- 
2.25.1

