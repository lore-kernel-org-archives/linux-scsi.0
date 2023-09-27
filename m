Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACDDE82CCD
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 19:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjI0TxP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 15:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjI0TxO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 15:53:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19809CC;
        Wed, 27 Sep 2023 12:53:14 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38RIxSr7000419;
        Wed, 27 Sep 2023 19:52:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=hG+IH4Hb1gkKBU3iLpXx6kzmQp01ar5kFr8HcIX9J8c=;
 b=w2FO0KVxvs4HwfdVcKpc5WgKvOYN6D+33p/5bi1+5qH1G1HAWsqH3uV4H5kYgwOdAleQ
 9bV/bAWWXsFzXq4OEq5vr76x3iN01+gyfpzoZ8TqAkA23hml828f2view2SAC2JlPV/v
 xDMUv2fFOKYp0B/uGECuMzhGJwiFHg3MjKZeKpwQnDiwqw4KpUP7kW8BLt31+zQueGtY
 gDxIoCcRLbh6iXxLYZjFhibjytkKclAeVmG6UuZxXBOBYqMDxIG+oQgpI4zI3qGks77I
 wiFYqNqu08sutWIITXsnedlyIfGh7dFYFERBPGKb48pPXG3guY5QRKZWg05arosXPEIB lg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9qwbjejj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 19:52:59 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38RJjP6k039560;
        Wed, 27 Sep 2023 19:52:58 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pfejx6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 19:52:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ORK35zjfoYdpVJw21MJUynaeeEMYu+1cs1WT2ooSwQkUOacPFdecVQ6WCBU5hyMZCF5xsOJ0ddD93mAjchHYserkvK92CW3mt5TpQlLzg5DWyzMXMs/z025yw+gnBat+E/ibxe1KTamkA8zKpmTRLLpwHFhHJhBg8rAfCf0Vw/EXJLjvy0K79fYZSA5WlQulF7YED2C8b3nUfWn39byJRAYADmokrKZpH6FwzJjmUHK3B4dAxdflo/yzUoqIovM+TMcRlWCTLDgckWa0v+h9upTTC1iMq86c66DybCC8JtL6aLjuW/sN5br0MX1Zx2yRE59K7nZq6GAJ7xQoB6oOHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hG+IH4Hb1gkKBU3iLpXx6kzmQp01ar5kFr8HcIX9J8c=;
 b=FZfGKvceNYXLBwBEnUcjJIcumoyLkY6LFDIGeL3kJQNvNmj7XXyfGDIkWt8vZOoZ+EAMrjBI0Zbi3ky3rLT7JWB8x0zdag+m6gP6wpBFjCFouln/uTW/hhBTK9llVEvUEYiDqX1BH4oVWqJxttdJYPEDYu/eMZ01wHfJp6XHvLOrOgxKjEAy3jJvm+f5v+I63qbZxj2MlaGTmaihic/yaT+BvO5XX3VQJUKMovtXksM6RZN0+qW+Ak0ZtsZPneZth8/u5pB1TAFEv//b12qh/jIVCe2YS+9iNHo/bKqj2bwxk9rIOPjLRXUIth+1TOIdXYKdJqTc4wwhfnk3xtrSSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hG+IH4Hb1gkKBU3iLpXx6kzmQp01ar5kFr8HcIX9J8c=;
 b=ccgmu4S+IJxSjz1JUyB3KcbC3+JT9tAi9lmanVJtYJpRyo68cAbQwWpDzyxMcsJzYL09suoJAY5rHAAX4vaweFH+mCcZRCsXM3BOn/ipiYFfAqkn7nwrlb8jgHxO7XX/0ElS0GkP2CvZipafNO5X4WmieAjBlBQRpnkTgNDsDu0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4377.namprd10.prod.outlook.com (2603:10b6:5:21a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Wed, 27 Sep
 2023 19:52:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6813.017; Wed, 27 Sep 2023
 19:52:55 +0000
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: Re: [PATCH v8 12/23] scsi: Remove scsi device no_start_on_resume flag
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11qejz94t.fsf@ca-mkp.ca.oracle.com>
References: <20230927141828.90288-1-dlemoal@kernel.org>
        <20230927141828.90288-13-dlemoal@kernel.org>
Date:   Wed, 27 Sep 2023 15:52:53 -0400
In-Reply-To: <20230927141828.90288-13-dlemoal@kernel.org> (Damien Le Moal's
        message of "Wed, 27 Sep 2023 23:18:17 +0900")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0092.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4377:EE_
X-MS-Office365-Filtering-Correlation-Id: fb1f24d8-946d-4e6d-93a0-08dbbf9357a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vhI7yFhjCUCLooe2u8VgxyqhVdPLOCzWenuz+cBdpxSziLxSD9gbXi5czQvNktz3gzh2Z2V5XgMQn88wR4nnN6Mse8zeYI6YvS34R0E6ND/xR9vQjW1qBY16hDRdd7cRNa4Pxr8iw2cegW1Rrf314em3ilsyXSU/oTwyCxQHLOlprhGgndTlywPYZiVX3cB6whCYOgf2Gjs8/t9qhTnnMekL7HiwqMh9H3IDM/nWMmuYl1AHoPvDQMcf+WQQxVB/qCWhDz9yor1GnDirqR//3Qoudf2keL8DrjQtA9hpMS7WKsYwx6UFYY5Rd+HMYVuuSUziqLyvlj0MzAs1T4nGr+gcQtPnaEISYdbKPyoPk8fyz8PxgIO0Uz6Lag+1/53ujEvKqgivcvYYAIzqHXnU0Hl9Sy5CtEh/Bjj+iTRLvGW5CSP2D6HNunILOHZSRxfNqQIJ4gUNK6PeYPlzzYIOOSj2etSG4Eofaazan1oMXV73wuxD0CdIXg3vrzpEtbC7s3KPdtRGJ68TK5aj/iAIvrzTkvABKKHHtSM5hEBRgZJRn/+CNcP/1zO6KkjKKLhR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(346002)(39860400002)(366004)(396003)(230922051799003)(1800799009)(186009)(451199024)(6506007)(36916002)(26005)(66556008)(66476007)(86362001)(6512007)(6486002)(478600001)(38100700002)(2906002)(8676002)(54906003)(5660300002)(4744005)(316002)(6916009)(8936002)(66946007)(4326008)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ckzL9u87uEQ+9N1k4G7bryVml4Oc/TvhM6e7DkU01/qtjt9gFaCq9DK9kBeA?=
 =?us-ascii?Q?1vq/DKVqP4RLKCKbBeZxehx1KuH7JWPBAz+Y0OVRLtAlt6JBOk8m4i0/7Q4X?=
 =?us-ascii?Q?0HUEyampK3C/NGjAZwJ3VY4RkWTQUGWUvoztKhIJqtBhg2MMjW4IhDwlgbVW?=
 =?us-ascii?Q?Zci3bQbLygUPaEMd6ZbV50tJz3g3JeFNI/TeXMREATPak0bVvMuHx6TBTrTB?=
 =?us-ascii?Q?1txjWyl115LHNJb7JEU4CxXHphRwFuBAM0yuMxYk5jJkO4UzmpwaqfaB9osM?=
 =?us-ascii?Q?GvXhm4/NAZ9zPEJlBFBrAg8/YklF5w+nAojXIeqMNuf89mqPId4Uq6F/jie2?=
 =?us-ascii?Q?JYSXldD1NlMHTfyb9ATs6AdDksvuQOol7BI0NMK2cO650nwvTElv0BJ6s4dd?=
 =?us-ascii?Q?DP5qPMv9ScEhaOb9KMuy4rgVviG4Z+ZxlyiDMGEtyPtrtAVIeslGBuTYIbdB?=
 =?us-ascii?Q?/rYmalUIZ1CAXu9JFDRQZ1kqU+n2D3RUsQWALvgYwOVrK1Q+YF6NtbFILJzu?=
 =?us-ascii?Q?8RsubDH3HNFgNVjM7J0p15h9gR644cJXFr1ojHTqGO6DdRbQBbf57oGgjbbe?=
 =?us-ascii?Q?Siqt5GebyqzOqPP+a4uOnf7hpj8wDLIQ59C1HL8eePNIAv2AXYpY24EjFPHL?=
 =?us-ascii?Q?udKRir2DxKFyah7chGEQDtYQz3ttmZmv5HlyEt0Pn+7USmDbBo30pUUOCfp1?=
 =?us-ascii?Q?/fb7phgDGIj88HqMORueMQ94IzBtuYAKOVM5qiW0GJAjUCOUtFrghVYmqgtE?=
 =?us-ascii?Q?dJ6whygUXfoQ/06gJ7M9Q05I+LiRM4z3UL2W/44bwu9pMzFNN9yWQvW+WMBt?=
 =?us-ascii?Q?38q7vPgg7ahGkXoJjfMbjn5WUDDW6tc3ooEuoz+ZMeLqxPzDlhRFEOc9blbc?=
 =?us-ascii?Q?LxsBKchbz3x2eVNm9H0keAwYeQQZWQ11XwS1dYWSOc/HqQG0dTcRFeJr2Mz9?=
 =?us-ascii?Q?v7dnnH41kgX519ytXiPqkMGdyC+9WqZVxvHahjq8l4ZanbzCiuqb49lIjXjn?=
 =?us-ascii?Q?jE+KBR6pBUo4w1S3e4m7U0uyb+Ov8FHtegdS7B8ZHPwNBiLBPt7o7+fZoZSj?=
 =?us-ascii?Q?ON60iYbsmiMBnlxbRW9uYWAl3htBDN3gvyPPDnrmJFTz7UNTKe/r9bDIA4vK?=
 =?us-ascii?Q?2edU9dd2CZTiCHHZqoPEOKLU/bV7o51iuyf8Sm2KHEmq8J3eT/ONCf4M22RQ?=
 =?us-ascii?Q?/XGQSTPdDHmtPCpPd1nYTO7Wc1fo29u0380uIpRx2BKBVJ9f+iqaxNoGVIHx?=
 =?us-ascii?Q?lQBCNAEIaTBcK2C2VfUNt8sQnaEtnBdu97E/zpX62+IOIH06XmZVnePbAXO4?=
 =?us-ascii?Q?Sr0T4WVZVbnT2GjZwHVIypO/L93mbsADpyWOetTjmZKV1fNoAAuQEjRfz7ld?=
 =?us-ascii?Q?tJr9FCJrLabIYLiQy7YAJppfPx8Rn1R4hj1sz5w3u0XhZYtHj8jRQSaErZgS?=
 =?us-ascii?Q?vPdzOmNEJJdZPUBvIlwGjYxV0nTI132Ar0SsN6bM5cOosEFF/m6bgUfnPaAg?=
 =?us-ascii?Q?2sabtinn2sKGaJfiTQIcaVIKgMnu1rHDzEzrwTJM9trmlGWro7kMl/7izikm?=
 =?us-ascii?Q?/HuPU7mLpJYqOyL7quMuu4kg3RZmBGlWTJ8bkcSrIwvE6L5G0sKQHVp4T1vH?=
 =?us-ascii?Q?Gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?ME6kmsN59ysg26neNe5LuKNT/xso3ES26u0uUuYseOA4e0zX6KtmVq5v69Qr?=
 =?us-ascii?Q?SdjzVXWm/wY4vGGuRcuW7Df4T3g1J2/8NaD2kASCQNvxpb2Um333xy5hfSjw?=
 =?us-ascii?Q?UL/74AFdDyzlM+nCmtsJTlz+kR0AzpvSuGPpAlT8JfvLuMnFg1TekrPuAwAu?=
 =?us-ascii?Q?QB1Hslf12E+j1+kwQOM6y22vg5XebsyJmMllZFMZ/3u0b/jypt4aya8Xo5F6?=
 =?us-ascii?Q?WeRs3rydHvP++EHBMjyyzT7HOYhEvJtjX4QUeRaZYWGl6C41Pq04n1FTlYSp?=
 =?us-ascii?Q?OSS3scMQCiiJZO26zb+7ULS4+l0n897GRxbABsOJ/UQsjq19kRdrxlnGtiJl?=
 =?us-ascii?Q?LBW8u8ey95aYRx59t3aFUXl00xAr2iFL2kW3doeS8RXz8Pxirz9JUCWstbyn?=
 =?us-ascii?Q?5/f8Y+1o0IyXO257JI5rdNt9A8ZCZKSET4vJU6XYc2ipvJ2BrdB7kCw+gd71?=
 =?us-ascii?Q?crevai3f2du6kB99qDk0oNZSrK5XVR4gR5hCEpqi0uCZDTrbW6/nL8z01j5G?=
 =?us-ascii?Q?BRnJ4V35rAgjbQESExLrfZwgCn4oo0Gpnrfch9LHYrQW2qUh4YrdEtYgxnO8?=
 =?us-ascii?Q?n3Ha1u6+qO/93LpDPprzIY+hz/8EnpqbEmlm5zPdO2lt0Lr0bYWH18OvF9aM?=
 =?us-ascii?Q?dUHKSe0pGLHRPTX5Mn0/xriIGxlWwQbxnuwyG1yqz6t8mT4/nFPs4CitlsT0?=
 =?us-ascii?Q?vpM/8rYuLIcHtWcIwwDL57DzXlh38YGty08zUiEhxCz0/OZ6v5RB1ZtOpR+G?=
 =?us-ascii?Q?Ackr28n6de2yj0MyRC6MPVY1Lf8bxUksctA/X86plTV5etXcbJ1j4/pcc0+s?=
 =?us-ascii?Q?SGCSMq35GO3l2nnC/KBHMkfYmv4iJbPsKKDPO6ygmEp6VcXm4txxXq3DkBxu?=
 =?us-ascii?Q?8bWq8Qd1HbbRVfUPiLyF/+PjBFhQlQVYxhxr2zCFS43+wxo7TfZd88Ul3vqP?=
 =?us-ascii?Q?jcklH5qNR9acHylz9WryBw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb1f24d8-946d-4e6d-93a0-08dbbf9357a0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 19:52:55.5425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lmGN+OY/b582l/D5wbGU8CWSEu4v3pHJAhHCCO+eYPSjP98pf8OhXl7b6+f2W/3GSo35/XNXzUPXoHnEwhjsRaZw9pqxQfpRi4ka5rR44rw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4377
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-27_12,2023-09-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309270168
X-Proofpoint-GUID: -UHeAcI2MrAbUa-QzQn7g6b-_F0pT_1R
X-Proofpoint-ORIG-GUID: -UHeAcI2MrAbUa-QzQn7g6b-_F0pT_1R
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> The scsi device flag no_start_on_resume is not set by any scsi low
> level driver. Remove it. This reverts the changes introduced by commit
> 0a8589055936 ("ata,scsi: do not issue START STOP UNIT on resume").

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
