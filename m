Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E441C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 20:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiF1UMS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbiF1ULx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 16:11:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FE53B004;
        Tue, 28 Jun 2022 13:02:56 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SJBcSV006374;
        Tue, 28 Jun 2022 20:02:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=kFbTvsAWX4HwQghk2vUrSsLuau40KP0ZwpgQ10Xvtuk=;
 b=qz64AYyige3Lz2n3oFX59vId1XWOmTjSByKzz7/p8OW7oqcPSgffEdpeKnbDbaBAsreK
 85FVvPVBGArVM/Zt4AeZijKxZK+5NLHen3V7Ng/dh6lnIMyv2Dx4qZ6+8+HudEzKsmH7
 mzgg5KYye3SPlz9dQDTUPV2y4MGqdTGydDROAM1XMJOCI8476M1uJYLWM4pnKwzCPSus
 b1GXU+4KUlkHbO7ohAGmb8+zFFLnlvPrOR0gX/faibvl2gKRnTnwqMfOBpHge3RHurpi
 8juhI5Xob8nVs8Wzcy2udgk2gjga2NqZ/ofI93sWynH1fibbDRlbKHGRDtiBPYjQtDUk Pw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gws52f6mn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 20:02:50 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25SJt6Cb033237;
        Tue, 28 Jun 2022 20:02:50 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt88ax2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 20:02:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9+xMLohGAqCFtCnHSDj4KhSTtUIy/knYzcCLNZkHQVLT0zSziWetkGHGDB229QVo9z/xtJe4iHrdjeVlcSCIuR4sbIZDc00d7LI8IiNI+tkvXrIyxS07uUokqA3WflbpJ+HtC/IgehmaqIDTa5EvY2rx9+EjWZg6GYde+kl4edNTfgEMRxbgiomb/uW08tWFokioKdpVeb8AHr92csUwMvxDsH0EYDqDcPUevo+H0ncM9jQm9iCts/nsZY0WXnszi7Hzn0bn1oR8T+r6eNe4GfQs8B19/IyoJAKgCeDTsL3AcUHRdHzAn/kFYTSe0VImXGLR7qObn3bdkKkLs/00A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kFbTvsAWX4HwQghk2vUrSsLuau40KP0ZwpgQ10Xvtuk=;
 b=Huh6RFj9wZJFN9MoapcIMtVNxuw/7Zj63kHR1IefsfGG+MhdcKWEAuuzDl8hQSb2bfX5oXr0QOL7PYbF6j9iUgjd/tUwPAzJSYLyva2GezgTgdR6S/Cuhn3y59UGviUBNuObSj+pkJMK4SFlzKz5i4HxcRzwqna/wE99rpwYBus9FfbFdMClSJfu2WzjxOntjQ0w+4Hbg3TD2A00PKqonECia16bHGHhnjihNSdN4oi15tGocW7soIemPyYMmkJTBHPWAlvrRjSF+y1mTFrVCJrhRK5piC9WEIBbugxcH+iZLm4qm/BzAH8/AOXvoaScVGTVV00QqPWLr8jG07U3Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kFbTvsAWX4HwQghk2vUrSsLuau40KP0ZwpgQ10Xvtuk=;
 b=ds3nJbQO0NpoDcbV0rSE7F7dqO0kQbpDQVWYjsgnfFen/0+WLchNmmo34JA8b5f9Mfr5jOTtbBZFh1EB34FfkTGF3E8yYe/nlPLS7RmxcJ9Xol0xObK+qgxaei2F9Svmvpzy2wcMOZXMdeIW4V17DeFxoGW60BEJUEjtBsQMYAI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY4PR1001MB2376.namprd10.prod.outlook.com (2603:10b6:910:48::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 20:02:46 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 20:02:46 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@infradead.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 2/5] scsi: target: Add callout to configure unmap settings
Date:   Tue, 28 Jun 2022 15:02:27 -0500
Message-Id: <20220628200230.15052-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628200230.15052-1-michael.christie@oracle.com>
References: <20220628200230.15052-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR21CA0019.namprd21.prod.outlook.com
 (2603:10b6:5:174::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7bd3255-1e5e-45ba-b02a-08da59412744
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2376:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j57NoiBvK23vjJ0gEoDwIEFpoVpjNnwbpDW67ObdkmXo2SVLy093e8/BSI1QLjwL+RzCWVZHKtXa1dIDLknfmOs6P0dZgqxhiX7hVYxkjmayV0xAQbjH1w+sLdLvi3oSGvxWZ5hnbhh6LIMHElhEiDAcwDz979pkfR2eAnfiBOHpB1E9afrmFyfKdsu9pinqw+71xUuAXJM6lL9SOE3B+enjJAmyuNxmbI/8AiB14VjvqCF1oWC25kwC+0OTrBqN716PSK4Obr9FxOK7OlRu8KMefsIcvEHn71YXwNoHKo1SLCFoBEiWkV2vYaCPgycK2kCSu68Pwk/VXxvSHvC8KXii92X+IbHtCfMNOFz9oLHGniU0nMWTmGj7xDnH4UwCL1HAk/K+uHKonGESisx4bQHaxuJjpz6ArQIrI6nkhdmZAafQZB/nYlDPEYxAGYtdtvtLEILg+mQDAN4WaY69eEDs7YkPzzPCYyuGFdQoR1jntEekojN1AZCh3JMEND5IHvpRJyR0xZLa05PILa9gte7rC1wqjmmSI1UiwsvukJ95gg3d3ZiPlZpb0X3dVH4av1lLRBUEUX6jFkQuSQGr4TYd58klylFQeNlla5zLk8Ksr1noaUN+XKFiGdQtzSn7+NdIKKrruA4UBLGD4sKnDDY8Vcc/LI2zb0kEK6pbAL90eBcPGreb9lRsvPViqBGsFP1SZfb4CsJqoBE/f2Z1GEe8/cz9OmaSUT7iMC3yqfPft+zt3A/orN0GTdmfAk1tqAoDICG+Gri0Au9OyOJg5Ms3qWMdOQVlkuYafYw5BJX27IvVOruOTb33NAvTKti7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(39860400002)(366004)(376002)(186003)(83380400001)(8676002)(6666004)(6506007)(2616005)(52116002)(1076003)(54906003)(26005)(41300700001)(6512007)(38350700002)(38100700002)(66946007)(36756003)(4326008)(2906002)(5660300002)(478600001)(86362001)(6486002)(8936002)(66476007)(66556008)(316002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zbEzBwYZVAHndiREfdRSyB9de/fnKnS/3VDg2vCj1D+Vhq9G3A74xUqWooDP?=
 =?us-ascii?Q?SSTe/Kd/IZGMhHzPyC+j60FHGna3CeyC67tQxG6u5vcCpTw7tzmiKqDurYsc?=
 =?us-ascii?Q?ulkYlxUt32q+X5z6jiaesMMZzlsnKyJcIsgi4ljEgwlqO0ouTTzoWMNHHPDE?=
 =?us-ascii?Q?mLQE42vRXBvW4p2A41H/Ncct0S/67Ddlb9k/ewgYEqkJ/i1JJ5cVwk5sZaBB?=
 =?us-ascii?Q?Re4jD61Vmi1yqYQ2LwYLugCnHZrUoKULUQM0FS+8v2Fxaqwzu5GpZbx0mZYB?=
 =?us-ascii?Q?RJy9XDqA8iqnMZ639XwDljKyZEDt2++ZLq3YAWbWBFzdLOGRypuYAZysb0KK?=
 =?us-ascii?Q?iBA7i4mXsFpxlL1Rip7XTKEQU1+l0SSDNR+c3U2RF693XpBq3bVY7HqwSfO5?=
 =?us-ascii?Q?oyGgCoEgeUxxLj59vVNOgjEd2qi5wA8FX7viJwe9Q4d+VfpxUd+ajx7yMDSu?=
 =?us-ascii?Q?a9Y2JMnQPvaiYyosDoyhO4wQkMyKdOiuK0znz9B36whpJaDzoXWIqEkBsbJO?=
 =?us-ascii?Q?giyzN95EWfflfCTEGdtj01C5qcpCmfOuol1pz6AkcDh+h2diMqMQN7M4ka5O?=
 =?us-ascii?Q?UAer5YwW/X5Vot8kPkU2+S7N6uu8Z+m0gPwupv91q7OipJ9Cqr5JgIm/8pfM?=
 =?us-ascii?Q?Fm+W+oWpJIVkKzCw5dQ1hsNrYRZnFYy9B7aeHsh69Dlyz8ohmjIRZYpATjZj?=
 =?us-ascii?Q?uArBQDsVlDpMRaXPTiobA09eNEMZHAXEGgs7c8lErBUgVuIP6H7fa4v5ZDdG?=
 =?us-ascii?Q?gCd4KsNcf7N2UEQ2Voa2f+WWjKMDTqODVnTRPeygkjRF/HUaCEo5TmHOocPY?=
 =?us-ascii?Q?bKXGQ7GCtEtMSDqSy96Rh5tWOoLDUqVYsL9DEo/quTTX9t/rDiFGg1ieckMl?=
 =?us-ascii?Q?csJ6xUsT6YCGPSD54QRNGQdh8wMPZXLOH+SqfcwL9pWQQQHPQIncjoa5jrrT?=
 =?us-ascii?Q?wfR2M483MO4UxyaPhFI4eGCGPZ/U5kN0/YkMjytT9/uK3v0bJndanh+F8Y6n?=
 =?us-ascii?Q?BsOzvYCkDPjsfarrsWqP0u3t7FscDtsmSxFGRTJ0XL1hWmUjcyuLDaZRGI7R?=
 =?us-ascii?Q?/3GUs4asbxz3VXn8e5pci/cx331x+9VymGsHr7hmMp0fbDFm0ccKlr5e/d0O?=
 =?us-ascii?Q?uOj5TX18t70nAnVeU+zn/DIDRZ9GzPwZCAbKYisXF9ceyO1YhW/XfB9dB2VR?=
 =?us-ascii?Q?6+Rd0Eucu5oOpGg0lYC4JLGrHACH0fCw8bBLnjL7Yg9wvL7gaX1Ga+QlYUvF?=
 =?us-ascii?Q?gauwek5BQhUTPNi2Q9enIq5JQztUvzxrDZpSp4/sEf91wnt9NNGMLDlHg7vr?=
 =?us-ascii?Q?lriCSA0t/oKE1hFkjL/9wKqXcnreMY5EIXXOPKaljTdG0EiivpYV7ESiJg4F?=
 =?us-ascii?Q?PRu9MCQgsatWfUdDlfoXflyOuTZDUy6DGcpdcQQAA/P4vNmdQ7QOJt/J+KHz?=
 =?us-ascii?Q?y/ZV7/WrJ/1Bgp3H1M01icDrShR0YdfPNDnkw/G+a9lpMbzJmnl2Y4tOiVjD?=
 =?us-ascii?Q?nhLmxrdTo7Rx/NpumKjOmo4wVNv7TbfBRhQekfM63PZYZ9sVyscXFZEo0Svj?=
 =?us-ascii?Q?eTUYtWkY0RptySfDA2kKkQoyznhaXR4bwMbQh+cOJ98FLwXoEhXAh/FSaPTC?=
 =?us-ascii?Q?ew=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7bd3255-1e5e-45ba-b02a-08da59412744
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 20:02:39.4624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XSraHa39ZgEi8unAaHnCjxJGeHlSjr1jx42YMjEihcSkUzQalWGLcK8JpRXIXV41QsvchU/tFIWWculbZZorYqfKrMpiKtb6VQzZeJ5kimQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2376
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-28_11:2022-06-28,2022-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280079
X-Proofpoint-ORIG-GUID: UaAt6L29US6lomP3OkN0erGjLdHM7mCT
X-Proofpoint-GUID: UaAt6L29US6lomP3OkN0erGjLdHM7mCT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds a callout to configure a backend's unmap settings. This
will be used in this patchset to allow userspace to setup unmap after
the initial device setup similar to how we can setup the other attrs
post device configuration.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_device.c  | 6 ++++++
 include/target/target_core_backend.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 25f33eb25337..086ac9c9343c 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -960,6 +960,12 @@ int target_configure_device(struct se_device *dev)
 	ret = dev->transport->configure_device(dev);
 	if (ret)
 		goto out_free_index;
+
+	if (dev->transport->configure_unmap &&
+	    dev->transport->configure_unmap(dev)) {
+		pr_debug("Discard support available, but disabled by default.\n");
+	}
+
 	/*
 	 * XXX: there is not much point to have two different values here..
 	 */
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 773963a1e0b5..a3c193df25b3 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -37,6 +37,7 @@ struct target_backend_ops {
 	struct se_dev_plug *(*plug_device)(struct se_device *se_dev);
 	void (*unplug_device)(struct se_dev_plug *se_plug);
 
+	bool (*configure_unmap)(struct se_device *se_dev);
 	ssize_t (*set_configfs_dev_params)(struct se_device *,
 					   const char *, ssize_t);
 	ssize_t (*show_configfs_dev_params)(struct se_device *, char *);
-- 
2.25.1

