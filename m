Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B19C25B06
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 01:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbiHLBA6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 21:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbiHLBAv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 21:00:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769487FE5F
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 18:00:48 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN5Wai004258;
        Fri, 12 Aug 2022 01:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=6ELxXuo9fXh2p88IjvMMNYMDFgBH3sEDgouflvGTb2A=;
 b=EktpQXnkpCWB+I4COhJBMRlTZhDjg0+wlOJ6Vq/rWThDzujdWqTTJiBU6RxdXVX+PAxp
 EWIw3+qV8YT/mLzJjYlAqzV+3AbtKx29H/24pN3jqV6pg/y/WG3c7Q7UycsDMLJEQ1+y
 gZG29UGgJPEL1A+jQ8oWZGbZU0g6ptOmiT1D0WQjBbPX93u4G2ZMR0hROZBEdbtvA/Cf
 PwqVWipn4/zPmYLtEq/U++ftsEnj01+DFd2GWJ69MSl8cquKgxf7o8/h/z7QvAyekE1y
 bjLNbsvwHJtQzzRxyB0oWNyrMP+pn5JUncSbLw2ftN41WI228DMS//Y8t8DcnwkWmNQP Yw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwq96bm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:38 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27C0L3aZ004961;
        Fri, 12 Aug 2022 01:00:37 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqk6c68-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmsR5OAUZ37aTE1bOuiAXk1Rw2w+zAWCh37J3fqoqLjJ7oHD/AhlslOHx7ZrYbtodrfS5luXgaycZ34lWX/uQ5PImLvpT4GRI3IUy2qdtBEr7h0qzwjsOt9IlbvGx6GPPbkdgHFWIJIIzm7H3FsoV0U2mOJaVhZX6CfLIEW6lA8DUpOLmC1CRyexYhyxuMreQAYA7BZhDhkvdknqQh3HLLz1JJYSYkuBl57qAUCtm0k9RJOAPcplNOLkP1KB0ZIz0otORRSOFcyDIgWIwsyZ/slMEovE0bespe60UjaMhP8KzShvr0TeVlgVkNPLLA0BUIEGKWOynmG6rbNfpek2DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ELxXuo9fXh2p88IjvMMNYMDFgBH3sEDgouflvGTb2A=;
 b=IDWTN9eGZdKP5A/mNLZBsEwO8QMXlQf8d1ceL/ZVkd9aiTAQ0UrxI0RKJGT5+issngNbfeqsV/h2/tyQW8NBBZajfhRZXcRmT2QhtvriTa89KdRF5dVDpiga9I+aWCcb8To+9GlrH0HFUi+uIugOoTUXB67FHfG50CvHpwNGOgSKbB+8S8NEHqOxQYDmu4uzBPk4jLdcVSo2NF/fl1ySHFF1TI9mmZAgN3t9Q4hCrvRUeYVVIX1B1wCQ5yaomK4XPiBRWj6lffhd5IFhrPpwtVf2DjpBHyJC9ifmK6IH8+Ub9p9wTF5g3TGm6dy6xzWe7JhXx8BrU+AZ10LIj9WUnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ELxXuo9fXh2p88IjvMMNYMDFgBH3sEDgouflvGTb2A=;
 b=WfnOEFxSRI8IIAAz5ePKqyYu/LqUCilj2u10oxqIRvy/W2NB1pLtrh8V2m6DC7k+Mr6ztrDA/RdmcieJ/souPzWEOGRgUB0k5UQnk4o85fBkYHzwgZUmrPO/GCqn8bsCY8cHUw+JcSwOBq/CYhv8wP2ky5Ldcq2ODsYhgSEjljE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5386.namprd10.prod.outlook.com (2603:10b6:610:dd::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Fri, 12 Aug 2022 01:00:36 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.024; Fri, 12 Aug 2022
 01:00:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 05/10] scsi: virtio_scsi: Drop DID_NEXUS_FAILURE use
Date:   Thu, 11 Aug 2022 20:00:22 -0500
Message-Id: <20220812010027.8251-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220812010027.8251-1-michael.christie@oracle.com>
References: <20220812010027.8251-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0013.namprd05.prod.outlook.com (2603:10b6:610::26)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9a80081-2d80-4a4c-1442-08da7bfe1116
X-MS-TrafficTypeDiagnostic: CH0PR10MB5386:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mscyRuUSkHXz0Q9wA6fRE5mkxQQmpPw8Tdy+8PKNMBXZC36no9LpUpM45q6KeWAllI3KQMOwTm+wtFtw+nm5TMcFUkbUIgMZKGPn5NhvXoqgY7cT8/9EVY1zsZJa8sjPDxCrzok8d0C8E5Ka5Wow2V7KS3Lk5ha4ESCNLA4Rx4uxCxnekUijIVilNHvb0tWS3RIlGf3wbCN9JAmB0hEIsBA19XE5Eiej8Jvwi1vdHohSbkluRPWsqwmp/gNp38HTR5Z6S8sgC/sCZkrpYIeG19o7b7puli4qIqVlbTFl8Efz67wK2qskJ5Ta/+7Y/Ug5BqeMQ2peGTXZZq4XKnWS9OD6EcK/OQe8HVeMO9jGEkF8QfkGLnFHNhGqBC1n5fPMqGV4w2zwdPCyN54dGqpkfZ+FdlOu8RrApX16Nzy6pMLoTy4S3LW38RntnSP2nSgXtPpxeJ42Px6qIYEUxBR8BnU+puqmN/CX097i9sgG7aJ9P2sZROvl+akeKuK4jVgMMwyWaDOR7fHPijmj6xrrA0lMN8YPgZ3i9K7Ofu7ruKQ/vInaGI1iG3f0LjyRiJikegZqLKrlh/tfq2WKw9ML6HuksbLBF/VXBRjruuOEEzqVgKRDFG7Dw1eLIxUFChf6v+HBNKBxqxLi2PY8nlg4FuCFNTfLPL2w+w7/IBGHkuO4WvnirVLV77GGhC3JV2hOx3Br6e2HWr6eLcGUKBmkwW4EXf3MAFn6QByBk9Grp/xDcjzz7M6ZfqsbS/Oi3kncK96Ds+t7yGm4YJLb2X9F/J9tvVPYaOGTWAwzulx3+xY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(346002)(376002)(396003)(366004)(921005)(2906002)(38100700002)(83380400001)(316002)(4326008)(8936002)(8676002)(1076003)(66556008)(6512007)(7416002)(107886003)(186003)(6486002)(2616005)(478600001)(41300700001)(86362001)(6506007)(36756003)(6666004)(66946007)(26005)(5660300002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yN0ibnI80OD0t3ZCljoUXthdYp+7uRnNtpsnSWEc1cUZ5aDce285p9gGvqkN?=
 =?us-ascii?Q?oeX+FpLJABVSAUeuuKhJMKD3jnwcmpOTvo0EJm8UM9bA6AAIa0AleY6Q55H3?=
 =?us-ascii?Q?TEiVAAmK8CWLwGGyo4E361wg/6d9DXreTA7KVTG6d8nv7Idp4RyMQiPOsYua?=
 =?us-ascii?Q?EqWbQDpIY3aXVpBZsTLNWTUMIYrPudFDvFxcyAXSqSwYKf350PJRTjlnYy5T?=
 =?us-ascii?Q?bCDGutACUOEuHI+rEoJRAZMovwxelvM/vVxnPZqxdMISnk1mIQlMB6KS3VJb?=
 =?us-ascii?Q?pIG+HI3TKPMeBtmggQjtptGRqpFNJhKVNch12k6ZHvMjjN9QmsdFaQTeZAT8?=
 =?us-ascii?Q?VgaBRe3ayaeNVmF6rupaMtdHDvm23QaeIkK48HWQnEVVUxD/2MEI6C/gAiGh?=
 =?us-ascii?Q?weEhmoobIh+kbGwpwYrmXGNxGMOIom7Rbyetkb/LVzRORWSnlLqq+0L5Cp1U?=
 =?us-ascii?Q?NiACQsUhx3Ij3zpL2aVGTqtW1jC6Q+5d7JnxSlkab7rNNAcP8V2+J9UI2qKr?=
 =?us-ascii?Q?x3CR9ZOn1GYudZrZQ+QZPFBTkUJNN8AFLaHSM7v4UDpWL++0FxiRu4bHLJIy?=
 =?us-ascii?Q?C2YBvFs1Dtnidu50RHITBjPHKP+bDOT3F2FGKA9XuWdRqs8iYSDejYzZ1dIK?=
 =?us-ascii?Q?igxdAkvZaanukf8Se+s7INZ86HSBE6yQ2T1Seupr08Pqd3TncuwDkEY2Klxa?=
 =?us-ascii?Q?HRfyDDa+NJghrIHGqyJfW8UGF4UIrd2uuu+NLro1/VBEU+metJ+5QYj2BFSR?=
 =?us-ascii?Q?hw+/uP+OnAYPaogx3AZjTFASHzVHpU/qceIuGwMr2FzqH7IryzBusjOCh9cS?=
 =?us-ascii?Q?qx/VjL8qKhssvbwxJXEzrqOOdHjMD7V4TuLQjMgBR/gSPSlcLeuLXyKST0Y8?=
 =?us-ascii?Q?Mqvnw1Z0b5iji5Kw5GHdmMCIxFlvY2nVCYo9v++kKPZmOSYTmSQGqIcv/H6k?=
 =?us-ascii?Q?9xeTv5j8bLRO3n+7udAXLp8EZ36SAzE//NDPmWFtykcYwfpgYj3Rm3aoBfhQ?=
 =?us-ascii?Q?xYjY9GscFWNvx0f5FtXLbw8hph2tzrQFY/Abj/ZqUw5C7DON+dRK+5DtDg0K?=
 =?us-ascii?Q?2qSdSF+yP3hbQZcxVsTlAdEKC9LjH85tCJCuQ6o2NW9aq9aj/3l3Rc88O5Zs?=
 =?us-ascii?Q?c2jb4IYw2MiONZzw3GZYOHrWjPIOU+OnUXrXDfzZMU003UdXMnRMphwE8+dZ?=
 =?us-ascii?Q?6/4KRO/dcQnSWWy/rWK11VZN4YoYzm82N8OMUptZ9IPbE0MJLdE85xO8SjrS?=
 =?us-ascii?Q?A23vfadeN+8Yc8ZHKImu1ZJj0qIzzACigkLxPkDuQx2WBpaRj2TLyMeT4lxf?=
 =?us-ascii?Q?V71ZSCwhSUhW1zLORQdH0R2zA5sVXontZuRD4nRLrXSRQ64RWuazoFGpbwbu?=
 =?us-ascii?Q?Uvvm5g3GCSNQtLqP4YNrLyizfWzVcj+ULnO8MZYifydDQcleztz7v3uTtLc9?=
 =?us-ascii?Q?kCeK1YPAv9YXSdrQxciUdcmd1nQRZajIGSRjT13eDXWumb96+MhoZBqdJDJ1?=
 =?us-ascii?Q?Ctxn1ML/Ut0+7M7vEZrx8OHWfiaJVRDlIYVv16CTkfQlX8s//KsHbqjNNUEK?=
 =?us-ascii?Q?OpwCFxeZTQD354JuoudZF+3E1oQqZt3MAFWKaI/HmLoIcpn1AAurJ3taH5wo?=
 =?us-ascii?Q?3A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9a80081-2d80-4a4c-1442-08da7bfe1116
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 01:00:36.6478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ohxpJTz7sOjfgpTwfw6NaUMzaM+gqCNHjv6UR1dLNDimWQxcbj28DiPWIVcyleHMzBqdd+rgLZhKcqhNu3gjYj7riLp0EFUorkvTUhgTaI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5386
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_14,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120000
X-Proofpoint-GUID: MyEu_YNVFfUFMltduWt-a5IooH-zDimz
X-Proofpoint-ORIG-GUID: MyEu_YNVFfUFMltduWt-a5IooH-zDimz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DID_NEXUS_FAILURE is internal to the SCSI layer. Drivers must not use it
because:

1. It's not propagated upwards, so SG IO/passthrough users will not see an
error and think a command was successful.

2. There is no handling for them in scsi_decide_disposition so it results
in the scsi eh running.

It looks like virtio_scsi gets this when something like qemu returns
VIRTIO_SCSI_S_NEXUS_FAILURE. It looks like qemu returns that error code
if host OS returns DID_NEXUS_FAILURE (qemu's internal
SCSI_HOST_RESERVATION_ERROR maps to DID_NEXUS_FAILURE). This shouldn't
happen for linux since we don't propagate that error code to userspace.

This has us convert VIRTIO_SCSI_S_NEXUS_FAILURE to a
SAM_STAT_RESERVATION_CONFLICT in case some other virt layer is returning
it. In that case we will still get the reservation confict failure we
expect.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/virtio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 112d8c3962b0..00cf6743db8c 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -144,7 +144,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 		set_host_byte(sc, DID_BAD_TARGET);
 		break;
 	case VIRTIO_SCSI_S_NEXUS_FAILURE:
-		set_host_byte(sc, DID_NEXUS_FAILURE);
+		set_status_byte(sc, SAM_STAT_RESERVATION_CONFLICT);
 		break;
 	default:
 		scmd_printk(KERN_WARNING, sc, "Unknown response %d",
-- 
2.18.2

