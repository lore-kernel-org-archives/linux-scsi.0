Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86538EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243462AbjFNHXe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243328AbjFNHWp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:22:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90734211D
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:21:06 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6kCOH026738;
        Wed, 14 Jun 2023 07:18:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=qGzPE80A/pbly1s2+Z3bS/c7JyAzYtwjTGARwD/R/zU=;
 b=WKNn3NKbj8g90jsVtKz6HgXDS93r2zy1EUv7qAcKQgjGxLaepXMFLgWCg1zV/KrUolRB
 xA3dVjLB78p35X8qVQlQrmzhgottsbPaciPK28l7x2Hp8goV1k3ZEjhjpH13M76ppnlW
 INiFz+jpna1s7YC4LdbAZgJ1oVavh4cuIzUUbUdAWYl2hCdzbBkpBMpOC+pC3em7aHw9
 VfZ9ttTxpsPywNW29Q5m21ZqWmyvDjra54GcgLG6RbxPuJFjP1GRCouSyMTipvbWsIDd
 HsCtxyZJfPTj10wk8SPslTCRCXpyfW7Z+JH4X7zt3ufD7JS0cT3FaOlYde/uS2EdsXCf jQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4g3bpyv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:37 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E5bIXe021593;
        Wed, 14 Jun 2023 07:18:37 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm56cnn-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPSxOftvSGE5tsoFv1YNUvIig2d2O/TZTyTDDD+KNY7wC9rXfrSB+BIFmnGtyrsZTm+J7s1sowIMb6uMXRZxNhXPPbOWol8cILasfoyxYYpY1QW+oaJDS2fgcU+sIWNmTwtsGSVO3xxsUB0X/Z7RL+GYF6bv6SeE3TXCP6ayWhk/X6ZZqFbhO14eVrOqY9X5Y7Xr4BbthVFn7S7rV76GjP7snvz74KAp/cvp/FErY72/LVPyYy/opQcr04Mg6v8B3Q1M4Y/RIwM488DzsOXok3eLOmjmiCMcp6kjJBF+YSeawIXB/n/syLJg86dQXVl1JaiXWRyaf3Wtfji3Ix2ltA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qGzPE80A/pbly1s2+Z3bS/c7JyAzYtwjTGARwD/R/zU=;
 b=Vjp2iDnFztwhAwtVnVBCg0BoFrz0L0/6qq0pVBL/Q4vT9nfgSNn9i9xcS+f4LFhlc+BJb/+a0/gvE1VVccV3mHCU96cV0zN9HqAjvnETEvw/ZrXJ0nhZYBecZlpG0G5Ad2T50kS02mFOFf5DHDRN5DzHYun1xNAuRlkshtw0CRCvQ0U/586vSY5+WRfhNreSMX2cLknvkEHbCtrkiaN3CZQI2hRrv3S/rKnuqYhF+6AIEXS3QXKHtT0HdfTcteXbF/aS9Dvc5iol7yFbSU64F5ZsBvjs4xAmq3HCIzrF+0qrpDZG8ppbiLb39dNWkndrMwb2z5BygMANBg0LGYFqAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGzPE80A/pbly1s2+Z3bS/c7JyAzYtwjTGARwD/R/zU=;
 b=pT/ayDyxoKzsNTLuldpL4+Y0mpuRwEr03oVb+BGGGGTOSC0wak+ABD/pUASMNpufUI4HEH/UueIUIihanseoWzq3qLHJGxcX1Lkp+eR5FC+/K+ActC9Vdl5c0sLWwx/xugtt6tBYC4Pxd79ydru5+RrXV/j8CH+w/hjMVfjYA9U=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4188.namprd10.prod.outlook.com (2603:10b6:5:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:18:15 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:18:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 31/33] scsi: sd: Fix sshdr use in cache_type_store
Date:   Wed, 14 Jun 2023 02:17:17 -0500
Message-Id: <20230614071719.6372-32-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0152.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::7) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ebedb45-2355-4346-e779-08db6ca7854d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KEICzqpln3f8V9T61MFO5ONbrwQSJDYSSBFpb8EtAFRswaeEYFALyPLcfIeSH/4FMVDcife/lsvVSy/ziYdL8OpTDXGykpeonKyiEfSET+JUPOrCQqyvHby/qxHs+Vr3NizyUdOAPrsHKW9HEgCyT1ocz2nLoPbKRK+BnHLgQ8jgnwDtqRSmhdqzcZNuRH4DK8rduJ7FihKPyDvjx1qngpCks/zA/awZJz04dMSHsUMOyvTp+A0B7S0lXf3MhaFffbDuv9RJEdE0pKowe9oUuYViXXVioiErUBVMLyV3dMnyJcwHzCAsQomNMSi6vWc2Sc8CF2DwcjaMqqzwI+AkH14/CGRvJq9te0AogKTfncH+Kw9jzS3zvAsKgG9GM1uL20oguQHdMozcPydCe9aR5OShwfPmLa8hYfqw4uayjydcwxYta36BYorAEqBSO1a7JoEdYjN1/0+uvNF/jEhPDHLmDQFLKyGD5IXO3kPgmsNZ6Lf2Gdk8J043pkARMFaCX6UAhLdnhTULl7y67Rzbb7+s7SGujPgG61AJgHQ4aH4BD8o/A5W1R9IJv1R7T35m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(2616005)(83380400001)(86362001)(36756003)(38100700002)(478600001)(6486002)(8936002)(8676002)(2906002)(4326008)(5660300002)(66946007)(66476007)(66556008)(316002)(186003)(41300700001)(107886003)(6512007)(26005)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MidZS0sdYnn+G1+zkyM+teL3b8Oq91GKFaMUP6Dc2jsiXwsa9k7/2ctYoZK4?=
 =?us-ascii?Q?HVocRMatU5I15UnatV7mwlC7lZs1GSHTGlesrYjE+0pePb7OUNwA5e1M/dDx?=
 =?us-ascii?Q?kLIziphvB8lXFBn++LN0DPDLj1/l5djjgYPI/JtZ3NjLj5p+0Jaxj6/KFyOR?=
 =?us-ascii?Q?BDinoj3WuNz0OhmCk+X4Yfl+YCC4wd64LXhSbShKF9B8+RM91Kn75Y8cFCIa?=
 =?us-ascii?Q?GUb3X1Xwi/k5Conm4Ag8pCCNTJl6AcE6a8Gb96YOcV+Ngv9ALD5FFckZ/7U4?=
 =?us-ascii?Q?aU/0s6/J5y1fqJgxT7ufQQu5NpiPTTuEWMVqbOmMyXXmdRiQA3kGg0EOsNGj?=
 =?us-ascii?Q?IYPbVbNRK6TJcpSX8/yv31Ynm7ByD43TQ3tSQ8S4dkyw9GVPMsukE6EI8NGU?=
 =?us-ascii?Q?LKBYrUbSj9E0leF7sowlI+N38fipPeCXgQ+AqJqJQVjmRLxW0yN959ICw6zg?=
 =?us-ascii?Q?CWw5oq5vpq8rq6hYfB+nyg3YLfPzaBJwOXu7zVR3yKVydSbFy7BhG91VSyWI?=
 =?us-ascii?Q?bZJJGU+lFBlXKYU8Riv6V9m+xa3QJaMplo7HjV50gWuOKNthgOGS/I5Y9J3y?=
 =?us-ascii?Q?RW2Odj6co65/vJ72+KmE9jLsMueQOZpCVpxseZIWYoc4G2D7bqQHFVg30AvJ?=
 =?us-ascii?Q?DqFLz+blOU7DIY0ywenrS00KC4caGVClqlkc99DMyyhRNvlG4JWyTsu673fz?=
 =?us-ascii?Q?lzTyGMSzkKnrf9ZWpXq3ZnuUIcI4/Q/j5J0YwvKg8QuZ86GKjj6g/i5Q3zjP?=
 =?us-ascii?Q?JAsJGwlOD0RWaGDOGSFXpyD3F/a8RMcsjjKfKKhJagJ5/UksxslSNCG7Xx8p?=
 =?us-ascii?Q?+V16GyzxEBbbmj3Es00nx3KulnFCPvpcdG8iu4kBYYIXuX76RKq2BzGsR/Qq?=
 =?us-ascii?Q?uflgapwS6hkuF0Mrg6kbZMuWNKW40+ua+HiIfqmM6Sk16f6/ABuh29dWTOuO?=
 =?us-ascii?Q?klCAxtopJ6yK4YyC9iMdbmHHMRdjMm2GTDMRxd/voGHwdcNaRaJ6i5+Z2YVe?=
 =?us-ascii?Q?MtSFckSULWT9xnLZyKtS4yQGTqM7pbgt+YimKWnQ0GnUB1La0RzwXad0LKmY?=
 =?us-ascii?Q?63aJ88RWxlFS1SMWpqlGC1Rqbhrfj/irdgPa3jXDgRcmkdwiKbBfb164msFu?=
 =?us-ascii?Q?ts+WSdCQ1Fq8Jqi1r+R/Gp11SzPpf1y8GThUnreRso9aPWv8sGZoc8vIsKhu?=
 =?us-ascii?Q?h6YndicZR7ll5SJzvdAUxXVP3BnFAv+m6Vpk5GS5ef+Jz5V2lECimUjWGvbo?=
 =?us-ascii?Q?cr+C3ZKaLAMqJwyAV7n+LyY8FoLsMbCvY2U2YO3wlb6dJnnGullOagUlyjE3?=
 =?us-ascii?Q?2CwkxwXdXTf+HE3P9inD1qgiX82LoqAE29saPBf3VN2myuUh2ukyFlY2UbLN?=
 =?us-ascii?Q?+mVZ5MxkxlnA4zaKetoiR3O5MBlL35/tCdBJy98CWpUh6X/7M0unZLfuN+xB?=
 =?us-ascii?Q?T6Y8aacMILQv+uUqwGdz+JJFNkplyzDVzoftjTX1pyoHGeTIJyQfTnLtI/A7?=
 =?us-ascii?Q?W4JdBzGW683vt94Mavw87qUhvKekjgiHq/XYaNEGekzhgzuYtF8ic2ev/MMx?=
 =?us-ascii?Q?2lzWSdkyDcrCBhNxI9nK50G3bxiVLbbUQ4iJFj1doHwkhoz0dHL4XX4RaHl3?=
 =?us-ascii?Q?yQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: GyafrSvkSn19065HkZ+QyE/Y28B6DZ+AfMYGpcek86507Yh3+x4z2F9SmT1d6vrN6RGR5QMyBMLwSn0xWUQbt0ZfCfVUmVUigyhhWDWg+39/9xGwCBP3Ved+1KnYIZr1KeOwk94WkwixaYY/5fq7d3gQyPTyfSbs4fZUU4GPlZ3dLn2ypaWyCXU3tj47yZsHQdGqcGada1R4Rc9bWgLBb1l5DwS6Twz0bfLi+jcquUMGJxvk4AmbNJEp2RDiPGZMA7e+FfGLnn8hZl8+PnBdzNlw2lgVntIOXWPFJRyj6BMQ2vbNBNnpVLHRer5ii8KbPd3flj4HPzXKQMh0ytnJ5n7DmCV+htCLbxUyFlLOjHGXeRyYh0OsHykflNSKfNXPWBwPCkPMIgrA+84xjp0aPJCH4TvIojNrd5vYFrHnaD9bTNfR5oQMRi3HSNLlqkEE8ykjYmPnh7xfoFJb5fnRneBI5D6Cp7UO+tsw8nTLLnEDKj0SCbTEF/m/rzyNzJtxJCKFYgna9CbJlW+G9uRE67Lbxyxfx3uh4gx6VtB2RGZa+Gfzplt7nAznuDdLYNa72ipeR7M3uz9ji3eSeLOHZeGY+oMkP8Y98EFsgR0jeMM27x29MmhQuMNxkrYGARMHVqfiye1lXXA/Su2fnuIPTdLQROcRIbuWHQw0/98YNEB/2FOnx/rHjCN4BtwGXk4yVjDc7GcsqyKDxAFyFO+5Y/VyCIKoAP6UoLSl/rAZGsJZV5Xj8gb+gZ/p0lWVltkVFbtPyBx3l0OfJ6Kkir7v/bgx1uly/fapMcVkoE/P2F27NwyDLeNAu/ThyYnzjLoTWh5Hwxsbih7bYr4SqaD3MRhdqdwEWK7oDGM4qGkHU5uy2x7CehCyE8T8MTwptblg
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ebedb45-2355-4346-e779-08db6ca7854d
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:18:15.6111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hLMiax/+/qPQ6sp1//ovuR3158YJH4VqTfYYZtUxHIxRKrkrFO0TAqbq04HWjNfZ3svZ0qAOFuQr0mytWX6HedpdDtGL2hDMNrg0rQjeS1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140063
X-Proofpoint-ORIG-GUID: ec6vd4kLVG7HnrCgL9gQI59i-kvPwaVy
X-Proofpoint-GUID: ec6vd4kLVG7HnrCgL9gQI59i-kvPwaVy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0 it will not have set the sshdr, so we
can't access it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f6f0e483cb13..3f3b7dc818fc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -155,7 +155,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
 	static const char temp[] = "temporary ";
-	int len;
+	int len, ret;
 
 	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		/* no cache control on RBC devices; theoretically they
@@ -202,9 +202,10 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	 */
 	data.device_specific = 0;
 
-	if (scsi_mode_select(sdp, 1, sp, buffer_data, len, SD_TIMEOUT,
-			     sdkp->max_retries, &data, &sshdr)) {
-		if (scsi_sense_valid(&sshdr))
+	ret = scsi_mode_select(sdp, 1, sp, buffer_data, len, SD_TIMEOUT,
+			       sdkp->max_retries, &data, &sshdr);
+	if (ret) {
+		if (ret > 0 && scsi_sense_valid(&sshdr))
 			sd_print_sense_hdr(sdkp, &sshdr);
 		return -EINVAL;
 	}
-- 
2.25.1

