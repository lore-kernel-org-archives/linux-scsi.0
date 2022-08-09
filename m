Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA21C00140
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 00:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244639AbiHIAFR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244543AbiHIAEw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 20:04:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052261928E;
        Mon,  8 Aug 2022 17:04:52 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278Nwkdr007763;
        Tue, 9 Aug 2022 00:04:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=h4VGkKSyzO+7O3osA7Y6GdwZMt/t/DX00GD1dBVf+b4=;
 b=KmR8yIrY6+L6X55F44n1Z9wQLy9RUVT9vOmjvAxmU9BORCALwSn2UVXwtoWmlJGCarD/
 Jz6xAmuRNlr+p6DsNQh0I7OJAcJC0OjraaFUG5lfmZIPtJ1JKn32aBwzf4MN3ZS4zuxK
 6xMTefZqAMAp43kpffsZa7SSTA61YqZW14K/p2ILQmSrJdfzIUavL6JSLdwQKyGRdOqS
 e4az60IwA7oJG015/twXWFTDFrqE+I5u1SNxX16AfY6NiVa+ikR7uU8sZRJ39L1Z/5h0
 HPqqym9ISJm80BvJg552TxRUk/Mql3/v1kGUcuoeSmgWes6LdJCItIV3ihVgllL9agd8 VA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsg69n1de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:32 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0hoB038112;
        Tue, 9 Aug 2022 00:04:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hu0n32vj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sxv9DGyhqr/kEC4WJlyO/324D5Va/yxEXIiNfda0W5edXr8BiUN9qdsy5FXcxv9l5dNPzF+d6C3y2om2o1VsI2/iCWOKmwVDsuzYnad9bGzIjVpLeBIclgiAroIeRXSlaYk/WoPD45oWC2FrRfZir8ZuqhnEh/nr4wGH+sf4af3X9WBECzHB+RrZIvb6D9okEtePiHoDUtTkCxaeNusnkp0Wj8qbX3j9CgO8dJVcKG7RbDxZ177ghdAlqki3XQdOhYxMZo6OSvS3U2LM35NRqErVlIexvq2FLl8Z2NxQX1uZGKC68Jh+F8cfb8KeteDEl7JOw05WdtkadALttrv5dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h4VGkKSyzO+7O3osA7Y6GdwZMt/t/DX00GD1dBVf+b4=;
 b=bYaO1VrMS/WGpjNJS+ziAOzyn/H9/yT6Vw5wpzaqg6EhLWzMeq+dYhVkpOJ8p5tySUDGkG8Br2YCs3RY6qApiyPf3PP131kbY72S9BCtLFayH2t3gwB8BedLpryUZ7osXKjyyFVYW0ArQuaypQOmMy/HG1z1Bh9in1Cp9a9549PFVDgh31Sl8IC7dkLQnERK+xAnuNBg+0ossvrHRut5Pdz6C9oonqFF/m6EtyABf+cP2OaFXtrsiK3cOKxJjmQpDbhepMaK0rBUMoxCQ+N8kaoOJz/nFuCPPHW0UUC7h7+Tib61rtryqkwIsDzJ+H7JXCztUUoLYgLMfBIytX9pmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4VGkKSyzO+7O3osA7Y6GdwZMt/t/DX00GD1dBVf+b4=;
 b=W7dzvsvzFIfH4IhUxpZc1KMI3QGf94sc/EcfZb5Gv5SAoQyXIerTDfHdH4WCA6CDDvwq+QuaHuTob3CP6EmJqz235wX3/OGgKCkKoOYC9oggdtg9TDqhf5dHbwhlhcilrfYEdN2schqoEsjb0KWS99oHRSKPUj4jrsdD5PEk1vI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB2590.namprd10.prod.outlook.com (2603:10b6:805:45::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 05/20] dm: Add support for block PR read keys/reservation.
Date:   Mon,  8 Aug 2022 19:04:04 -0500
Message-Id: <20220809000419.10674-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:610:38::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e9dbac0-1d8f-49ff-4af3-08da799abaa8
X-MS-TrafficTypeDiagnostic: SN6PR10MB2590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B5G5EfQlhiqwsnpOkUCsIdSsm4LRB2zQsBrAFHJmyZsxQIVtdgmvm05aTdk3ndXwvIrnfWkiD2lHI3bkXg0UWivAXHqZ+wq7VCrpu+ctjrGoAYhWxCQ+Y8wsStT3WRZzZfTMDR79467syqSqYO5k2gNvzKCLlUOHrakStLmrXrdztCPSi2oTW/LjW/Ow6BbdAU+ykk8/Th1wiRnX/96cHzKSKF40ul39m/OKG+1M7QtS/QN9+3mGSgPpmniyxP/gowmyL6cQEyJMTRKTnHVA5mFS+6K3up+rFHG9WvzR/2ueGa+yKvadlb7HCR8JkMSRUBHU18VIygJLvP9xaR8ZKvTWPVzQJDqj2Q5toG70Cn3wBZc3Ip3Pf6ERJ5mDzAHoIm0oEjGwugc5g0f/kJDVQMiv49NkRPVMLkYxloP5TOm0zMuCBDtkfF9n3LtDyU72dsoYdGYIL/WWX7Pthw66fIqQCC/b3S65WPXTHVCUxEspJqLtgiy869vj0kdLIo6NynifZjyAldz24iCfsdQOl6SEeoxfsmiIXaCdILq9IYQ83O39O83ICLvIgfmN5mn+NEy1aFz95SNAy/F1osFELDmhNnDIvHrHZuTBA8sWSfjgosQb2OOexRbAPPdmvBr+VsTWEplsuzYLGwNFMyZEM1apE4gL4OWmB+5Akuaoo2gUDeuCyt196NFJZyt5xOtL0rhGf6VoTUZu6ynW/NeWYUFY9oOWOhU/l97kGQCarUj+XVrwuyWVBsyzF5t841Tfl93JaSXeqQlZO+Ocan9qwTsGrOsM72RwkGtmJJYe5gM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(39860400002)(366004)(136003)(376002)(2906002)(83380400001)(6512007)(26005)(6506007)(186003)(1076003)(2616005)(36756003)(107886003)(38100700002)(86362001)(921005)(66476007)(6486002)(316002)(4326008)(6666004)(8936002)(66556008)(66946007)(8676002)(478600001)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6Ao6nZjBfSfXcZYIxJ5ahtNt6qNGYkecdjr0KAZZsLVEPRfM+i5/zXE30/Hv?=
 =?us-ascii?Q?XVuRhW48auQECvyBJrUscwDkx45gCSSsw6KSuVPZqdSO+h9vEgJ9MofNWYIT?=
 =?us-ascii?Q?fhhA6HomAG/T5NxvuN13nk7Y6c4Ru/8BrTfby04PGe7UQ2RS0NO81zBaS/r5?=
 =?us-ascii?Q?p8FvjO2XrVoYvHtYPVEwd8yCX8rtn1Da71wDmo+pW34PD0qUM6lUIdLtYDmE?=
 =?us-ascii?Q?ljZg0YBNHbT8AQ44XOpShpKYdKcgiEZjJqkhJwfYaQwhzcPxD1k+OvKKn7E0?=
 =?us-ascii?Q?AbdNtqfTJZCXsibBViirZ090ZbJz4GEll2v89Q0+KgjdKX1ZF00L6hfCaxiC?=
 =?us-ascii?Q?FUXUs75yE4gXSxDTMO5TKJ0zgqJ61/UN5LD9ZldS0hF0R/q9PHg0VoSqqSY3?=
 =?us-ascii?Q?JyogyxD4nYHt/6WcwMcJ08l1OB1tqzHzFv0a7Jdh7dNSDlhW/HFmWtSJR3sP?=
 =?us-ascii?Q?V9FAyCpsqrWuw+CL7GWIkN8Px1C2ECe7cvEzU62UO8rnKq2byE+g8/gdH9fp?=
 =?us-ascii?Q?lq69nAXJTGfE1g8fB764OCXb53lHYNCci8NBgQ6RKmPX1O/qGib2CWeLH92J?=
 =?us-ascii?Q?8JfeG1zH2pboEiDZg4zcmVrb4QXoSlDtbFCjR9H71nJy5KYGYsOwzOqL4rS5?=
 =?us-ascii?Q?toE9wNkRPrr6syiE5LcVXLBOzgiu9wcm15KMzxm0pO167bW+wQ4BLD6bLnSD?=
 =?us-ascii?Q?l4IivPQF+KPnh7Te+NxzE+QwlVDk4RPhiqByRU2pLi1sk217AKUr397lLY5o?=
 =?us-ascii?Q?2c+ZeBG8Bw6agkref0/bt+gLtE94q9PBH9+Jig1yIIoNr/pat4pE6ZDGVJat?=
 =?us-ascii?Q?akWrtVwv+xxZtlnWqNYHoI32HxytSQROttmNTajDGi3PXSNW5CebmfsEL7XG?=
 =?us-ascii?Q?M0BI+yGiuRWJUpQ3AFCDjH1p6sSGSYZZLeOyHsa5Weaxrt26njdyAyc3MqzU?=
 =?us-ascii?Q?bIRWAsa5MS397SBi3XEdPRFcrg+bGr/5YJPw4TKzDNPymIdpYP7dkB+w2NvF?=
 =?us-ascii?Q?y8wHQzj3Y0/KTk3JRjMmbo3Dz4oyKKH+I+hw4wMDmC/+ijhmlvocIVOzmyDq?=
 =?us-ascii?Q?0K4VZw/nhU4CxCiaixCXQSf36yvE7SqpFNOVO/rvG9OohR+89/s/eKijGvDU?=
 =?us-ascii?Q?vzUjigpmsVU1HEMZACt5IAZO0KddH5Io7xsygrXwbgmTnyj6t6W16/ZCq4lZ?=
 =?us-ascii?Q?Da2yLxYjfsQ+7Vhlo0YVk5RGvW7h1bG5wDj5gy89Stu68rkYWJ6egFTsvHhN?=
 =?us-ascii?Q?Xo/IBiAZJHngJJd2tXxc34dTwrGON3iMEErYAwKsyj5nrYnVoF/UUO4y9phb?=
 =?us-ascii?Q?X+5LIEWY6Z1/sZ1E2gNzjTWMv96wutq9rNkoOY6KuRYJxCel2vDAE8dpaIwG?=
 =?us-ascii?Q?lT8a4FszNS3CTx2D48k7nIAnJiYZwZu4sFCTW8Ka8AnoItwVmDAB8raVEQZF?=
 =?us-ascii?Q?AAtvgoRgM3ntokLdvzKRXvIRxmebkjbVW6vB73ULc0mHUPdKLrj3MbsTsGdj?=
 =?us-ascii?Q?mbuhQzzQKD+9KNe+Gwf2icspXiJuB9e0CPPaFB4GCRY1mZuqzvpXVL4oiaV3?=
 =?us-ascii?Q?/r2JTetcCmSvvzNWxTMhQqMvoLhPZVRXk54e6PdFdRaHkR+TkVpTETNnzjV8?=
 =?us-ascii?Q?Pg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e9dbac0-1d8f-49ff-4af3-08da799abaa8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:29.1424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2YyYQgz4U5r+TQrWnjRg+9E96YSGN0p1r/F/PCGd8bELUnojezpl7u48wpuhSTolD++bfvWlSCMVjtWCwcAkpuM+wLFFBdYIU4cN6lUl4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: gI-7VgP1RgYsg1kSWbDMQiHzUxnkSrLY
X-Proofpoint-GUID: gI-7VgP1RgYsg1kSWbDMQiHzUxnkSrLY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds support in dm for the block PR read keys and read reservation
callouts.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/md/dm.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 60549b65c799..1b15295bdf24 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3313,12 +3313,56 @@ static int dm_pr_clear(struct block_device *bdev, u64 key)
 	return r;
 }
 
+static int dm_pr_read_keys(struct block_device *bdev, struct pr_keys *keys,
+			   u32 keys_len)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	const struct pr_ops *ops;
+	int r, srcu_idx;
+
+	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
+	if (r < 0)
+		goto out;
+
+	ops = bdev->bd_disk->fops->pr_ops;
+	if (ops && ops->pr_read_keys)
+		r = ops->pr_read_keys(bdev, keys, keys_len);
+	else
+		r = -EOPNOTSUPP;
+out:
+	dm_unprepare_ioctl(md, srcu_idx);
+	return r;
+}
+
+static int dm_pr_read_reservation(struct block_device *bdev,
+				  struct pr_held_reservation *rsv)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	const struct pr_ops *ops;
+	int r, srcu_idx;
+
+	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
+	if (r < 0)
+		goto out;
+
+	ops = bdev->bd_disk->fops->pr_ops;
+	if (ops && ops->pr_read_reservation)
+		r = ops->pr_read_reservation(bdev, rsv);
+	else
+		r = -EOPNOTSUPP;
+out:
+	dm_unprepare_ioctl(md, srcu_idx);
+	return r;
+}
+
 static const struct pr_ops dm_pr_ops = {
 	.pr_register	= dm_pr_register,
 	.pr_reserve	= dm_pr_reserve,
 	.pr_release	= dm_pr_release,
 	.pr_preempt	= dm_pr_preempt,
 	.pr_clear	= dm_pr_clear,
+	.pr_read_keys	= dm_pr_read_keys,
+	.pr_read_reservation = dm_pr_read_reservation,
 };
 
 static const struct block_device_operations dm_blk_dops = {
-- 
2.18.2

