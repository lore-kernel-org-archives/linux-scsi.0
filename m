Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39321EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjGNViB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjGNVhy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:37:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3748235AD
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:37:51 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4AgO004653;
        Fri, 14 Jul 2023 21:35:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=RYup95xBobh23N98jIJ7ZY9ys72fqnmhj5Qepf31Stw=;
 b=DLOcUzQPpN2EZIwqlpRvZIu1/tcjcSrGFEs19XoJQ8yN20teSwG/CqQu4LEywCKqHjII
 otf9RqdLIEDWdF6pR5CpBcUYrmypCkfzMiFCFRwUOEtqwtx8HxJY4B9Z4cwjJRF3Oa4W
 YmT5Hykc+RsOqai+ZzkPg3pTqqRfi0gkd79MuodOZdkZRl9+KW4uwDeAZ4h6r6xNTbgC
 q4ubq3BVUZuCmESmVfpbEqNwI8LpEqf679JHRNTzZIB4PpzAqEOa9etTeJtRrJhRlHt0
 kCDDQ+101X2Q7wj6Vkn8+wqRtkFCZeuFBfWWfwStdkhrALSz6nV68Nydm884kl/QhfYT 0Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtptn2d4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:45 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK0JIl007621;
        Fri, 14 Jul 2023 21:35:44 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvsrwye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jG6vjlpwVtyF46F03rKtMvV9F7vugtnuqWCz/c1qTHmJA5iGXkb/+7pELNM1ctbQ1v5yyvUh8uFjTk3zGMiBQA0NxjGzMVf/UKlBIwkw95WK7d/swohqS8keREQlT4+62q/lcOf4Kqv+WfD9MiVRVDFAabXSvnrYsltO+D82XK8SfaMAQWjRg/GiJmifF/H2COMw+VsjoWFs9SpH5Vw+PqFC8ulMsqX0eLGKS1PaBQOV9qq/o32HrcE6zfy8dfHBO6cd5XtWEex7owjNo3/IflcTJnsu4/Oi2HIcEdc1l/BasEekqnCEVZ6I2wU8CZAYx32yiOTufpjdgbIA0IwJuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RYup95xBobh23N98jIJ7ZY9ys72fqnmhj5Qepf31Stw=;
 b=KchwxMfwJQxjmItHRvFOurH26qJrp4iTgd/5wMvb9tLawy85cQP0SrmwqNIJzZRe6pBkV1Mn3O+SqGIMc8TkmujKMCJZRYTmn+VuMvXmZPCMUn7YLbt/WNv2tbsw9DCj0eilqr8TuaANNsR1Tnwm9Bw40FuI7MWrCCEct9F7Y7wqF6U+GuWuXcFCnK94lwN/kuEODeMSlGkspvNRoJwbqFv9sl8RykdVTSu5PQH1gSyfyUA5ocaApZWw1nGx0n5hrP7S3jM5Ig1hBoZJ0uq2Y/xkPg8fFPA9pcFZvRXF6oNTE1tyALYPMvsLxqMjGJQZ9yUFFHoAHVvEpupGtCyHbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYup95xBobh23N98jIJ7ZY9ys72fqnmhj5Qepf31Stw=;
 b=S2V8RPMpg+ivvovhs85Ldc9wETveXGnWc9Q5SP48Qjrg2EXOVstfF+gFUNk3oFt8mrGu4hggbiPhsGBWQSmubOribX7gsfpt9J7kMKQztjBorJWkHzMvDFeQ4F2iSFKhwf3simfAUXhg8g3kmZyVz8WyPYSl63FhEPwmYnO592A=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4377.namprd10.prod.outlook.com (2603:10b6:5:21a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:35:42 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:35:42 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 30/33] scsi: Fix sshdr use in scsi_cdl_enable
Date:   Fri, 14 Jul 2023 16:34:16 -0500
Message-Id: <20230714213419.95492-31-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR06CA0023.namprd06.prod.outlook.com
 (2603:10b6:8:2a::14) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4377:EE_
X-MS-Office365-Filtering-Correlation-Id: be885a5a-1511-4424-665b-08db84b23447
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QL6KzPQ9B7nWI6MiH8awt5gtneP1DObaI5AhOCiHLEPRBcPP6YU3xH7Rmn+0qavIrFWZUClU6Ta0xxOaIj1hs3FZvTePMtl/TgbaxJnPseoPFsbRJ4Y/fRkRzLU1bfxXRUu+TryyjTjLEkOiJga3Z8Y3WPCXKd+sISlr6H3WqDma8GMGMVKZJrzQDl4LG4stHxoRf1t7PP1jiob6XNB3qiGmilONVzSJ9PAdHuxVw9qmKbw4i7Nx7tE2akbBDI1ArMViitZMNw8KGI5TcqmxeUpgx5tbd+1fbFbi9ZWrFzDY6ZGDTK/iQvu6RPQUf9IP8FlkUOm0oEF5WZUL859GLn4VJM/NIJCUEyE9NyeYG3ar5isEQ4Kd/J6SQOrHGrfq46ALrzgDNZ23VcTHiw3mKL9+q0bPerO0TxINreiwQLCN73auwi0fz6kZOTvbWsBKaTJi4YxEWtNb/HwHCdzr+If/NBSFhgfUe89HmuGt0Xxz6CDNMl+ErFvPmM9R7WmUmXx4LPS0dZCcccp92D26xWdaeGckCWQ3Z8dL7MJWkALChzpeMukKqNQU02Nq31+X
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(39860400002)(396003)(376002)(451199021)(8676002)(5660300002)(8936002)(316002)(41300700001)(4326008)(4744005)(2906002)(478600001)(6666004)(6512007)(6486002)(107886003)(26005)(6506007)(1076003)(186003)(66946007)(66556008)(66476007)(83380400001)(2616005)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YyCOgYjG9WXPpVhFz2uUbKxvjxHXI7Kapeu7JejYSn/W29thGoETcS3XgQe0?=
 =?us-ascii?Q?M9LgYT6ps0lZAWhy0AQl1LX1o571qb0v6ybnUcYpe/N3qJZvgli7QruKDA2k?=
 =?us-ascii?Q?+TAmWCeXGbTmaxObGZkQ8Qgz1XyulUj2+2SYQMJgWlnhQQfsQ0fTEOlFxFTx?=
 =?us-ascii?Q?ZNuOWxoYKVlAvEi9+MrJNyRjt/msnhSQR1fFzjKbUKV+iQvWNKK034oODxlF?=
 =?us-ascii?Q?19aCvCkkeK9RcJY2yFKdikUXc3Pywf1ibEz/xRTqlJXaKWQ+iJIMU2eX4kXT?=
 =?us-ascii?Q?B93s7me5cmTsQB9mnjpBUsNv2jLhK817jrgiifhhuwYEdAno9BZOYkFML0Vo?=
 =?us-ascii?Q?qcn7CWg/RADWazhMJekK5mJvL+abgfCHXgMVFFNpWy4rE0RQJXY5f4GQsd3w?=
 =?us-ascii?Q?8tgdd1+YYh5Ri0QSOdWpY+zYXgn/hA5DPC2Pm1L16BtmAYPJJvlGkEXDyA0v?=
 =?us-ascii?Q?9vS0ESJRVwsXMNv6PnKmMjUtDFwv1fZ86rchN5EuHrOW0rweJaL07mHCTDgw?=
 =?us-ascii?Q?ij8OembnDG5o37jTNwbe2qi8wZBfkoWqDmVGTHSzPJEepk9jbgu9oVcr+WwZ?=
 =?us-ascii?Q?L8LoVQAGVr53QCKpunlAZzSRfFp1UoATcbI2rHyQzk9YKvTbxJQK4AqLT5up?=
 =?us-ascii?Q?JxW7MqbwAlQA5MuSisA6mTpMnjRsZcjARPJsTMskikNWMsn9sGIiO321kZ08?=
 =?us-ascii?Q?lmNZ6xY0rb76rGzOJHNJ2fX6UcndQTi9iYaxQdZiqdFudToQufuLHE+BqBTC?=
 =?us-ascii?Q?BMD+CJRshVz7PYUe35DU7hKzjTpUUhDFo/UIi297V7aBYsMFxYzcNlRBQAme?=
 =?us-ascii?Q?Gv/g9MUMPFU38Tu+smlQdFxHZd1ngQzaSZ/w22+aYO22Psbo1G5QwnhmfA0G?=
 =?us-ascii?Q?orSbxRO59zrNSjoV60W/KN+tyktWSTUi31e48OnvyFRFtwhnWkVqrlZoFoUo?=
 =?us-ascii?Q?xzUAjBTO6afVjxfMkHFP+mB0T8EoyBy5aluGQfN+P+QPvjmukNN9GZfunAmd?=
 =?us-ascii?Q?vJC4HIJwRNNU5QXupdO+7KibtMo31U+FmePIrA/71vuyeaJ79TvwpP0MxpCt?=
 =?us-ascii?Q?qpWv7K3VPjrI0Ks1WsJvF2RJQk8x9HffJd3r04WTRQQklgsbEpsNcs9KSGIa?=
 =?us-ascii?Q?92FN8KxUm1k7egXZBAipKizH+joc4t+KbueTsjFchsZaHMaS5rjsIYZyaL26?=
 =?us-ascii?Q?qsV6htTDgbWU07I2vcOd4Z+G3tkaKcNjdLDHGHbcp8E8/ufZ5lihIvTJoRi4?=
 =?us-ascii?Q?tJnwoDKjt1thBgS21RFiWqWoybItxlOUrArZMEL+Z7fhRKAiQePWZbE25NLW?=
 =?us-ascii?Q?7+p1Uf/zEO7NPxt8fxm/zMiudmFkAvt0llOMvyqXrVYwMJfrduLRdGNP3eSw?=
 =?us-ascii?Q?721MV3rIjvDZvxm+RHPCBOSSQYGfuuClfh2yrcq/jinlLndc5qLnDMDmOUtv?=
 =?us-ascii?Q?femuwY2O9t1UInI7sY4B+wITLXlZJVbDqLPyWnpliiqU2K6EzDu3zxGboGqO?=
 =?us-ascii?Q?Ghnzuudp6jLUW8bDYyEL4/ResQ+32Ou5U9Fy3K9IoEUVotpFsmtyTeONLpdO?=
 =?us-ascii?Q?G2PoyqXzPvTjMqJs/cKAwRtBcf5fOSNLhxFExecm0zfs5UbuCfuwcSbJluki?=
 =?us-ascii?Q?gQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 9RADWwSnCi9eC+EuN4cTdnML68UyV+tuwbN0ZJSMCp7cYik4InGqhwe35nE3TNjnM9qVzIHw1dgmVUJKfrjbPUur+vHFgigdr4CRpzGmlNoKbkK+XYRJwIal3lxDSfXKcUJyTUkeo96gthZdNTU1/wmj9Ss8890ipUDkJEs6UCf3PQMVxgqIvK+UWSGOdIUs3Q2PFA6HPx/ofA1uaOc/zlocjalao+YAU8wPMmB5GDXhYp8cn7eJvUT8SP81UpoQZ4d/dQhTpUFrFul2N0mjVScinGxnbOP2O/YQcKgqS9witB9kHgZxAKx7ZquUkiMcEq4DCpJIxJYVdc1pz1RBUWs1CE74psjiAQ4QY72dX5UQpwsWktkdY7Yy+GsAjvsB+yjZ8h/zuAYMwe1PKjUJFWTLP0KYafbhfYYxwhs48CeWxE5fDfuewjWxujGHF5zBkjX8TLfd54m9BcqAjsSOk38toS7PrCB5MEJa8p5y0WTIKVl2Q3nx9EdKo51k3XY0TAhL9sqrFjoik8H7dO1X7CbTSkjyBVgEXbHUgIGSSHA4UmHnirAX4WxwXWEM7B4LpD3x1YMwF3pFXMLUv2X7VjPD69g9Urw/RHH5IN7OaY1aE9tlUvlbcLVkpmCVLKeCipSeS37x2cDBjmHDJTiDGd9RrI4AEpPnI6fwQrXkzKiBE+iqYbpdDYpeDvPRd/iEgGkoNm7i4dygG+3soNwuyjCXD5peDzXLqNq5RcQCRdvHN8osqJcm/L2mrTjfSTUAtdTDfTHv1yraVPAYvFpB18U7l5SLFwys4bUm0BVsYBhW+wvxEHmFJb9RLs+cQRV7zV6Pee3a4qs0CbcpYUMVybRWvMzbgxm28EaThCLAHeubUk4BykxVOJt+Yl+MEAjq
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be885a5a-1511-4424-665b-08db84b23447
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:35:12.0445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dsV0W0jRrrby3ErHgE+76bXMSLef6lDgc9xr2I9X8M2kCDusgZCeaXvm7A6P+8/uL7ivSnB52rwPC205nBlt7w6p3Im+AJ7q0I1jgASbRdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4377
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: 3cPFdro7wQg8GUwL06FsrrN53U1lJzt4
X-Proofpoint-GUID: 3cPFdro7wQg8GUwL06FsrrN53U1lJzt4
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
 drivers/scsi/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d0911bc28663..d1c0ba3ef1f5 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -692,7 +692,7 @@ int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
 		ret = scsi_mode_select(sdev, 1, 0, buf_data, len, 5 * HZ, 3,
 				       &data, &sshdr);
 		if (ret) {
-			if (scsi_sense_valid(&sshdr))
+			if (ret > 0 && scsi_sense_valid(&sshdr))
 				scsi_print_sense_hdr(sdev,
 					dev_name(&sdev->sdev_gendev), &sshdr);
 			return ret;
-- 
2.34.1

