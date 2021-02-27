Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E158FC4332D
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B988D64EAF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhB0RQD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:16:03 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47876 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhB0REG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:04:06 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RH0OMB034225;
        Sat, 27 Feb 2021 17:00:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=nmNPczwdrWFQufUfS26xsht2CcTvVrMqQOEoCGgZw3A=;
 b=fOqthph4KKZ5cIHcPZTJ4RfQw+HF4IQa60LlnKzkXWcBy7KGi5Guc/CnPYpPphiWrqNi
 q7K1bKvWSPxTCXfmz9dmEeUaY1KZaEGdDAg85bZ48QykJINj2YA7HQp7d1huTjCSzV8N
 gXrOlm2up2/23/VEN+SJH/WDP+V1YDe6z6IFmynqzauji5FHgYK2PAcpyvtMo9sT7MHk
 iw1fFB8ceEFVDgrJ8VjZFoo+8aIjus/+xYu0Qq6XFasXPwcbI1lBn/2tSwLk7LKF+XdH
 UUWPPl3R/gL+DiAxmom+mVHy8Xpj+Gq6Nh+sg58T9E01uenGMjagAAPft6JmL8/hDqdI Rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36ybkb0v3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGslmc115709;
        Sat, 27 Feb 2021 17:00:24 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by aserp3030.oracle.com with ESMTP id 36yc4a7jaw-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FdLVr/ZzDMnS/0fZy9v63LCAHOVuh8VCdV+CIcCiNOott9BbwuasoPbBZgd57FeH+xdHOg0NY2Ex/qRNnnpDmnDCNhS1bJ2DkL+gsIdcsEPdR2AeswaLnfZCEAN78MpTYcCkm55J1FY5imJBVJBQDZ4hh66rC1/musmAKw8sh/LW+ps5onL+deZQWTopfeG9RcOIAvEx87nYZDOWrE8pAfDNMH9fVZsSm1a31Xj4UlOJdZIF21MB5flNScTSOdrEWpR5zr8S/Z0ZcoKw5/vir9RqZExa6pyyaip/F4env+si7cjoB0+sggaauFuGtdxkCIQui6rbW4bxkCJZyPnjcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nmNPczwdrWFQufUfS26xsht2CcTvVrMqQOEoCGgZw3A=;
 b=lYEvgdjm3dzadQeR3k9VmTRKH0CXBJbQ6zWRAby/xDhjsVcOFaIWn3aa6aQ+mkaNcP6d55RJdzfZ+ngho2ru/ec9KUWAsmQbiB7WZdd3E5btr5qte6gD0NzYCs00vjhCw6/AFUMhThS5NsOYedHYuH9iVZO3hgpLdluw8FpP0i81ZE+9zkPFAwpbSAYALATr4JvfMzzCyYE6N12Vh2SNTmw+veTiMzEo/fF4f2bKS2di74VM34RPHl9VUG72eaaDCDSIocgMW/kstP6VUPY8WMuVDkNmA6fCWG4BuqtHwkBGnEqJbMvIS8YTJ2ofnpE1L5/xaoZ48oFI7mczsVPmgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nmNPczwdrWFQufUfS26xsht2CcTvVrMqQOEoCGgZw3A=;
 b=HHcd6GKGzo0fJcpbu/6qDP7ETTtf9rkK8hRRMNmWwlzR6f0zDNvxVBBzzoWQ/dCo1cULWMrLWA1cNDczg4AggHDVvJ4eNlNVtFVFesfDAacc+E7LwZBV4gFzjP6YFT4bEyi7dAzwe747DeH2BWi1wHZfneVMZA5BRsqNFO14nx0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3499.namprd10.prod.outlook.com (2603:10b6:5:178::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.22; Sat, 27 Feb
 2021 17:00:21 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:21 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Michael Cyr <mikecyr@linux.ibm.com>
Subject: [PATCH 06/25] ibmvscsi_tgt: Convert to new submission API
Date:   Sat, 27 Feb 2021 10:59:47 -0600
Message-Id: <20210227170006.5077-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210227170006.5077-1-michael.christie@oracle.com>
References: <20210227170006.5077-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:610:b1::32) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 300dc3d6-8d33-4bab-fa8a-08d8db412a8e
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB34991BAB9EB219DDCD7F38C5F19C9@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E5+8LcJQWAc/R+cBI+l40PX+NFsPorgQzcx2ZxnAMoswZgsebCvMGcxztAsPq7zCedRiAu1DkbljfrxgFCTVsp2jK70HPOPkohxw2wihFzs1bl7i1zfDdeUI8MJc5eeNMDMW0R7N9Ub011+fg2DRQb2E9j+PVRYxsOYICok6XEdmZMYyazviSX31xFRdzRgJCwg/bkutN95d6Kc6dNBuigDbMYWHy/lkYE1d85A4xyyiGUF+EiAPo/X8X8w2S4z9tG51shkfDXmzExlyZkTih2uPm54n5MABVR+x88qDrRswO1vv7JyyHi1kBj/L14zXJaD4YNuhPu4HzRlfiDVqnqG58OzJfXLuXtgb32ADT/NJpDLtPbw6xpdtX/4GBz20irntz6wjaflsd6ruz5/o3I67H8t8K1plClXOuM1yfSyQOlSaRe4bFmYUtQcEGxdubhLpROM5Sf9yJYyoJhu5628MTfqE4cFSTJIgKl7Tr695OsatfGavecSUSIjGStZAJq/9NKJmEko/Q46gEB3urvX1+dxeS6407cDuo4ryoykEmWXq8YtCbnrjvKwgZxmD2QA4Wem6OWksEOFZ+CCD9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(6666004)(956004)(36756003)(316002)(6512007)(86362001)(69590400012)(6506007)(1076003)(8936002)(83380400001)(2616005)(478600001)(2906002)(4326008)(186003)(16526019)(66556008)(5660300002)(66946007)(6486002)(66476007)(54906003)(8676002)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?K85nY+YXrO9szeD6AwYEbmUkdrYhiN2EoyDoX0XQH8O5EGL9/+hreChI7kXK?=
 =?us-ascii?Q?bW5BEQhoMq0BpJRC6De773ovSDSziVG5B0hPfen5Js4QVZX9bjpJqSXga0zM?=
 =?us-ascii?Q?71hyfiIlOwGSILTkf0vdMjEnhcSSzvrecTrPJYIxC2u4Ut7SWT3OKE7781nC?=
 =?us-ascii?Q?vrEQSE/N/wVUmiNv1bIvRcGyRobEhTRYNtPCaGNFzlKev/A+IDHEme0/Pzal?=
 =?us-ascii?Q?GWlZdqQMAHPP8y1Ma/k1ATP4Vr7vnCEe+ZdQwI3la9n6p3jEpEJJtg9z/gdO?=
 =?us-ascii?Q?vZejhlScvqd42TpoGUnKL/O8jRHh6Gl5QTSZBD7PkDbWV5bwDACQ/lifavHD?=
 =?us-ascii?Q?1bfzT4JZD44obpTemNmfnnV3qm0BvW7ACmQOwlaHEM+T8OMzEPixZnkzmHsf?=
 =?us-ascii?Q?y2hMHewF3CFqLCt+ON322ojod700lGp3kGtxDNKhpdfwJP0Ljw2P2xRMz0DW?=
 =?us-ascii?Q?ahtt8T1UW12FqiWvzU8SOsj/6/jEJScI6McapI/d6UOXp7nKGudRiSJEH93h?=
 =?us-ascii?Q?sQJD0Be9Dyr2KuPdSRl0O1ORPWSXVH/8UTwEZOFOs48ITrcdOa+lc81+vbJM?=
 =?us-ascii?Q?eCSp8G0BATmpsnL0GJALGfnhLsWBdlk1iG73SJTqLCB42b7ecUbm1TpSO0FR?=
 =?us-ascii?Q?VOJFXjbehz6Fijg8SExZCe3/3KbOiNhRSgWhkL0Hr3e0FmRTpdZ8Nft6MuKy?=
 =?us-ascii?Q?uFKjZldYYOvZUI3my3X+qx+TYNyVKie6jlLzu3oFGbnRVH2YiQwq4P4D3fA1?=
 =?us-ascii?Q?VtNsskRCCY3aJm1CQTwvKAtDaTEA7WiQGpr3KHhiTR0rf6/79ZfpqR90eV/1?=
 =?us-ascii?Q?rn0UNGTP7TQilUyo48OmktdIMpNzXcLmCiWEczpdR1V1nNU7ajhUzX0TjqJM?=
 =?us-ascii?Q?wjcYSOhUBvTAFkON0T875deP9bNmdCiJhg1x6/zHpLWi5zzVa4M6z6loir2S?=
 =?us-ascii?Q?u0KOqO92iF2boi2YP64SXteYXsKyypdw+dE7rF+ijnDIacXfaRp1Gc73iPmp?=
 =?us-ascii?Q?U97SipWWQzQ9Z5VnXWAb4tSGLHGLre4UPAN0q93qzzQX0KK3xoOQV8pZTelC?=
 =?us-ascii?Q?bjUnretH0EXnRF3o8URxQNmzn8Ba3BB9PEGQzI0Q2bLEvKtLViLixIwCy/yC?=
 =?us-ascii?Q?OxHWXKbZE7QGrV2rPgLEvR/7Xw1dz7lRe4PAFEIAUar7yrTV2BVL8+tt299X?=
 =?us-ascii?Q?wvr94VmTJUBTiCAhsBdAYAZLAqyaq5G9GdGM+F5bOi/SKnugnq/t7KLV9VDl?=
 =?us-ascii?Q?Kp1giiD9G0ImQK5J9IvtFUBXvYTlp3tyPN5qJefCadTgKMRXO6Ga3xI9WUlO?=
 =?us-ascii?Q?RX4zr2bOexPVeCVjimHl1vdw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 300dc3d6-8d33-4bab-fa8a-08d8db412a8e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:20.8014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7OpLl8b/3MyUcvyUqZHDbdalGOlfKpzr0eHNiFJV5lbvuZZ0X51KPmY0AEJb0UEumFK3WSyGI10Ljq9Cp48GLizANU+QtJmJ96jZurIQjYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270145
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd is now only for simple drivers that do their
own sync during shutdown and do not use target_stop_session. It
will never return a failure, so we can remove that code from
the driver.

Cc: Michael Cyr <mikecyr@linux.ibm.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index cc3908c2d2f9..cfc54532402c 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -2670,7 +2670,6 @@ static void ibmvscsis_parse_cmd(struct scsi_info *vscsi,
 	u64 data_len = 0;
 	enum dma_data_direction dir;
 	int attr = 0;
-	int rc = 0;
 
 	nexus = vscsi->tport.ibmv_nexus;
 	/*
@@ -2725,17 +2724,9 @@ static void ibmvscsis_parse_cmd(struct scsi_info *vscsi,
 
 	srp->lun.scsi_lun[0] &= 0x3f;
 
-	rc = target_submit_cmd(&cmd->se_cmd, nexus->se_sess, srp->cdb,
-			       cmd->sense_buf, scsilun_to_int(&srp->lun),
-			       data_len, attr, dir, 0);
-	if (rc) {
-		dev_err(&vscsi->dev, "target_submit_cmd failed, rc %d\n", rc);
-		spin_lock_bh(&vscsi->intr_lock);
-		list_del(&cmd->list);
-		ibmvscsis_free_cmd_resources(vscsi, cmd);
-		spin_unlock_bh(&vscsi->intr_lock);
-		goto fail;
-	}
+	target_submit_cmd(&cmd->se_cmd, nexus->se_sess, srp->cdb,
+			  cmd->sense_buf, scsilun_to_int(&srp->lun),
+			  data_len, attr, dir, 0);
 	return;
 
 fail:
-- 
2.25.1

