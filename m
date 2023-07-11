Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1AC5EB64DD
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbjGKVrL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbjGKVrE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:47:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B2A170C
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:47:03 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BID2G4000841;
        Tue, 11 Jul 2023 21:46:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=OGDOzxotRQrQtlmfpOl5xsft5tbEQR0IyjIeqYnTkzg=;
 b=R621jomz/xLjjJexBIDcQSJaZ/RxUB2ulb4xv4tXpRVg8qca8zqzLIYYT+jU+8Y7jjEz
 b+FIbnHQy3/gUlKaEzGi+OGuxf6oQhp1NzDjgwpG4byaYozns2WYs78KDIvXIsbLp9U0
 Y/AZJm1kpaRrHncgEoKmQgYGVkh2vbmptaBExKJLJ2d1wjE5f4yiyqHTfxfeyotuxHYx
 BYI8LmZwvB+31WXdQEmpDWudsSaq786bVoW8n8G5IIfb5jBF43V8FsfQ+Ge51DxKaAha
 tte7dIuDkmHq5fP98h3YNfkYRwBwOngIkic1uyD1dAziwIN035wDwl4sK/5kDoxK0xwN uA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpyud6480-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:55 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BLjb5A004275;
        Tue, 11 Jul 2023 21:46:54 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx8bt2ad-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mumla4CMNixL6R2qjN/ylXy0grG7AkPP1u4KjtRZgwk9/+mNJPy/2fVla5TCkgACwpncOedtWjT1yj27qeaYtHdG9SYHp3eSfq63od2/m1sg69+KJnlqxO1mEXGqBNrzhwBAXVeQHuKo0bDLLr+CNk9Vf9efSlzxF8APUPZJbv4s/MMoqepR39L14u/48qc8hBA6CcEAbVNZR1uIECUEZdz9DReIU1gZxP+gez80mRJrrsYBU9NmDrxXSR7x0yo9y8hFCzuOJO6K+mBdieSifBnZW9MNw+jwiignDBRtsS8NwfYXtwyFGPQ6iRB67e4/fFm5lOd88ziwbCazIBF/2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OGDOzxotRQrQtlmfpOl5xsft5tbEQR0IyjIeqYnTkzg=;
 b=UqUBa14VMxcQ4LNT7Md6mr4E5Hv8ODfyyq4qylBMqy4tlhvFZJHgHgnvIquwuWV651c8RUo0Gy1rF3mU9JPeZU+jkdtG018l0n6IyQ6WZe6K4MIT+wGA616ZVtIAHnKEi/gt+rE2yyGF3fiCrOl7D7rQbJ/Rnf0yb+OxsvZ4iS0CG4UINQlv54WjLy4Zb5ntJ2/9pUl8+Hpx1pfMn3NCRtR5i5pV/N8kl9aW3sTTMZLa8c/zPpdK4t/9ogEg/lgpJIRia7dryGFFn/wDgy9u2fUW6sKiiagXj8H5MPiyK4uyUZY2q+igBr030kgQjzdGwARcTxXW+I280GShEghbfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OGDOzxotRQrQtlmfpOl5xsft5tbEQR0IyjIeqYnTkzg=;
 b=alkGjj1Xzsx/2aFDrgrDBagbBobn5c8/uVEFkU24L9jxxYv+N7FMZH2adSF6Qx5IkykbEF206ZurxkUSyWnEU+pLhak7dOZblI9qHSQqig5JScc/xb5kW4QoPytNJny+HvJhzwSBoE6zMxyu+DWbhYnIx1+mG2LewuE+CkgQ8S4=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CO1PR10MB4450.namprd10.prod.outlook.com (2603:10b6:303:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Tue, 11 Jul
 2023 21:46:52 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:46:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 13/33] scsi: rdac: Fix sshdr use
Date:   Tue, 11 Jul 2023 16:46:00 -0500
Message-Id: <20230711214620.87232-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0054.namprd06.prod.outlook.com
 (2603:10b6:5:54::31) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CO1PR10MB4450:EE_
X-MS-Office365-Filtering-Correlation-Id: c82aff2e-32fd-44f4-eebc-08db82585635
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ah8oObpP+3byt1ipy/PioEFOu6+t2hGqB8983Wge6P8nqVlxdSvK5ewSXv1x252jwh2tdKnLLje8SDbpqpozrgVuwl3qXf6HFj01oYU2r3Mlk0S19lC5/gcSL4toXG3tFkR+QNfl/LePqSOkho3/rrAtZgJgL8R3p0duMjkLuZhNqM0FIHOlOF3OLeTW0eJfOOapWu5Xmrf/gl/sFzDmXQzqxU8huVNnGa24QVfYM6tD2BdIVynjI9q0b4PBYnEPMAiDaO25eaO/3ip2LMmWcRBJfpaTDZ7N/TwuZjYcUobAKyshSluEFNXpHCYrGfZFhdp9op0I8gdAcz9GnonFkehp5jja1eILHHkWMeWOY8SgDIhDAV1Vc9Fll2MnpcmMJ5JCfmeSdElghFZT8o1Hym7x5wAPHANnKj1QsoIfBKBDx41fIJ4/wiUepdZBZLRU7xn6VIDSsX3YCTORz3OqxRQsxPebYIC8dynN0SbajwnY6LMXhAxJXuijYpISsZUc7X1DcB3Sk+AcE87sVmUOOjVcyx9HP0utmBozac3Y38q/pXGHmg5byxuBmTIzmZ+f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(83380400001)(2616005)(38100700002)(36756003)(86362001)(478600001)(186003)(26005)(1076003)(6512007)(6486002)(6666004)(5660300002)(8936002)(66946007)(66556008)(66476007)(8676002)(2906002)(41300700001)(4326008)(316002)(107886003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?omVOMkVw+ubGphqwpm5juoWgLRKaWk8qYjqCnUJfcyHxwxS4I2TzKumeb1tj?=
 =?us-ascii?Q?UcNewaviY7qSDXDJlNUGjkTsV3YDglYsZ4M8QZL02VJIHbmnH2Y54OUuZiuL?=
 =?us-ascii?Q?S4Y+LOFIcbgjNoluP5hPYoAi55QDRESneYD4fPxg+g9wHZ7OoF9z08x8r/5l?=
 =?us-ascii?Q?ROsdTQw0Rjp8lnEhNzhwGexchHMWrjItM2pvm9ZsoaNPv41QiE9JwhBwPCZ/?=
 =?us-ascii?Q?It+nMied4szqSJIeh/CW2v86/nj937s/rVAwJxjztvpP8SpCF8rcZWud2oq3?=
 =?us-ascii?Q?Ogr8grBfX999Z0irBzkPiZ9ref9TiuknUtiGhlyguj3J72IbvsXmU1anUdQk?=
 =?us-ascii?Q?YkWdYUW76/318LaFXTqGBdTpJEu9vR6b/g20Tp3H1dbxLk2A/viRO2IUYH7P?=
 =?us-ascii?Q?S1tGTxUOPerUjYLbthOYtonkWkidHKwpu7vHdxCk+2n/WGu2fX2jr0FkiILR?=
 =?us-ascii?Q?55bOMc1+unD00BM+IKnf5EST5cer/OTQIYTa7Jq60yHvDEFKlYTZmHWaXsf/?=
 =?us-ascii?Q?k9lS9w0b/ehYnWZlF53rs9JDzZqYqDHLlJSkQICvS8rVHGEeN8vz6+07Ho4m?=
 =?us-ascii?Q?mcyl7l61D/oQpe2Seqr8SGwUagstnfgUGsH8DwyLexeaduohcyXQRAPL0oqs?=
 =?us-ascii?Q?7QJ4YmwkH20YdgxK+7reSiwGpGwdXGvWY+LQ4r6rw7WCGyjIioaCJVyXZiX8?=
 =?us-ascii?Q?xWuYc80IdI1lE6H6aiOO16oRk+XIR3RwSVoGj6Xwd7tXE2ET4yqnPX+XoLnR?=
 =?us-ascii?Q?i17jCqqt86bvKW8cqe7iYbmbBlbNmeJfPIYnA5I90JLfL8DTCQQuqvDFBZ7Q?=
 =?us-ascii?Q?BaKllXUGW2XE7rHyUMfveyyFcIkN1778OuKal/DCX+M05xb7CZOIpBEAmejI?=
 =?us-ascii?Q?p/21PZLLvUUWsi2mXJ1mTq0X5W96g5g1NXCftMnIgwSFCS5QafoKwV5J11GA?=
 =?us-ascii?Q?wqiYWFKSz6g6z8ZfT4SQPC4Y/heud7RETc1N68rs+qeR4rnfW5z/ojEBcbbA?=
 =?us-ascii?Q?wJuQ9L2lKqosTxsvENrJMpA5Og7m+qQlh79uHFwYKdjb06M05Hpj91un1C9x?=
 =?us-ascii?Q?sH/78g49fJv3AzRMPGz/A1Ms5/Bw9S3G23S1US+2KoGQzo/nwFvxmrwMIT5i?=
 =?us-ascii?Q?+yci2683UTf2ORXHLEWyZXqPvZBQnTloBQEOhLidfjT24iGPE9L/JH1V2hRK?=
 =?us-ascii?Q?O97toM07AQq6wWXzsoMnYEtCSRK5HVrbKDhGBEKHTXzSuxAKe0zg1FaEk2sH?=
 =?us-ascii?Q?4ZwftwGDRoUeaboRVsAb0GuE9I+Xdr/SpUrbo2Fc/1j35zZcSC0Fw419HiAI?=
 =?us-ascii?Q?RohoJFhUC2SO+8bx36pQ4Zgyv1fsJUEFIuruvWUoJPW0N97NV7Vs8XpCTlw4?=
 =?us-ascii?Q?ucFCaK32Yo5G3nkBYUn4hCzjrfJhFA2tebeGFmudlP5L6SekTtjsM3ayDeMi?=
 =?us-ascii?Q?zVV04vZt2UjIjBHxz7nKV/SygQE9fNBbYozB94B3kYAtSi9dNFs/W69IGhg4?=
 =?us-ascii?Q?ytBfdianv2qK5Qb0p9OPNTHenlYFkAqEwp8w+6+Cp/CBmtZ58fE04/ONfVvR?=
 =?us-ascii?Q?OqdQjE4aMIzppbqGQKf3ZN+KpeMYlyqmSXTbGVS8AqLF2FRbql/Ae0Jq14J3?=
 =?us-ascii?Q?0A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: sgsHqNYi8ies4gZx7EaJSbjNRB9zKEsxY+TXMEilkr3pKFYU/5KpjbRWaIl1w5tjcbYfDjWUvMcGiOd8WWMuNiWEqEKmXs69r24Szh2v4MBkh8z0OKqIj8xFvCPtBMuDvWeD72d3e2OuKCl4HsEQbl2DHBmzlhNxR7/mXNCa27K/OgBZiNFpSgb4igasSyTwoRn+zb2ZkpLb5HJe8weYL/RCvFYRuvddPM7ihV3SrKxISyCfekjfP1EgVvxtPuEqrUaHne7LVHMbQJkpq+EywZj9lnbvqf3rc6A+RsYWvRHlvqn3Vzd7pIJBr//0wzREUbami0/u0zR+oJVatR+9VPJr9b/7g7+SKQSbVu3RygJafmwr1VvwA09vrWCOQfdci2bUZQrjH1QmtnxZPXEz5HpgRvFZJemvQV+DzwuBpMUumOtpDl912emOlQ3upmJsknVpi8afRcazTmYF78dxc7lfhhLBRVx6WBQRVv/J8kZCxYE56j0IBBeqFUFuf77E3szjfNiBoQ95+VWmC0UkiWPZEXKPPHajjJxH1pQVPmKAEboXvbg6aedDwNvg3aOnnDkferWJd6oC/kDVyJyYHKQPbJJS7d5jq3jlFn/AJrUSu1RLch4UAjtjJX6RC3gp3Xg2sOC4uVan5Xbiul5f+sGEu+a78OGFv5cbT+aHwD+ruqiGrvasbddXGuBl5J/QDyJPPaWthjfsssJq1tme59au2z/sJz7pDMPZu/bvf3GF1sBQMKkyS2daE2CUhV6/vjROK3FkWof+yYMbij4eMGb55/VTgJMonWTyDofBwJSIsJQPLYGGpIcIELoEyUDT7/cGbhM5rN9INsLngLzvVwlYyZ1lGDdtxMtMChTF4Ih67bOeTV56o9tInYF8sYeU
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c82aff2e-32fd-44f4-eebc-08db82585635
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:46:52.0826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: btx/WB6AKsuFQG/YFvqEYKIltYOx50aYbxgkvW6QBf+NPIEiJ4YdcbNI1udWgUlKCgYNw3Bp13Cz4VuA6tKtuGe3D0q61fGxrDHV16/uJTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307110198
X-Proofpoint-ORIG-GUID: wCdWJqieixjn596n_4-ClyfUYR2CLVRF
X-Proofpoint-GUID: wCdWJqieixjn596n_4-ClyfUYR2CLVRF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index c5538645057a..cdefaa9f614e 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -541,6 +541,7 @@ static void send_mode_select(struct work_struct *work)
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
 	};
+	int rc;
 
 	spin_lock(&ctlr->ms_lock);
 	list_splice_init(&ctlr->ms_head, &list);
@@ -558,14 +559,18 @@ static void send_mode_select(struct work_struct *work)
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
-	if (scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
-			     RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args)) {
+	rc = scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
+			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args);
+	if (rc < 0) {
+		err = SCSI_DH_IO;
+	} else if (rc > 0) {
 		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
 		if (err == SCSI_DH_IMM_RETRY)
 			goto retry;
 	}
+
 	if (err == SCSI_DH_OK) {
 		h->state = RDAC_STATE_ACTIVE;
 		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-- 
2.34.1

