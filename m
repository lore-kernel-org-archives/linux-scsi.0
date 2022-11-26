Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C35AC4321E
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 02:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiKZCLY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 21:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiKZCLW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 21:11:22 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B595984F
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 18:11:22 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AQ1rFYS027320;
        Sat, 26 Nov 2022 02:11:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=defAIkHx1uuGjm2rryVyJrxlFxTg3prR5rgzrE1XCkE=;
 b=DeiJI8ouoWwEJnexLFEBToEtJ4E5Rgm195GnvYg5LE0Yh9De2HOYkFUMwFlIEM9wbYQI
 0jS7jG1OuHBdcOlo8YFjB5OrqdS028Qiu8fu3Fum8Jc8VGpwsOcP8W9w/Y7x1iUquccN
 85Hb2gFIXlZUKzOwBtWqpQxvLKvAvCPT8fOXwFUlDTg9aLpOKclOxwPJZUevnjP0htN9
 RKGybZ8UguI0tbvFUrFStNuvcZq1sZvDN/YhQwei1EqvVQVq0tDND1btnKSelmvbbWUy
 OE6RKbQFD5lG877LndiiOzwLgFKo7En/R2oRQBkoAuRWIti6Xt5DjMD9XZEFxm86HmN4 5A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m33qk8b6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 02:11:11 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AQ1X5Sb005517;
        Sat, 26 Nov 2022 02:11:10 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m39820yjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 02:11:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AEPNpY1R7a8Jd6kGaKdy5oUFinyDNhj039qHyGBYYTM856rr7xmOUhFn/wnJH+5gloGfb4zz4nuQo2Kv7WBlvUwHMy2hq6jwLBv/EcanF9BZWHFkU8FGJX2lPjVDuV1nvJ8GUc1wwrMuf9j/Gjf42sOstc7meDPPRYf6baNcan/ylp0hZTTVJZN6qZsgTAi8h6t9PXUlyMj37Vg1UoDvpizRAts5PBhgyAQgtAGiy8yVKa3rgZP2yAAoa37WKC4fnIW4qYi3kBzy1L/m22rsTBFryHCvHly4F73Pzji0BCXk9D0G2LC7K3oP5qtUckXHI3GB9/AV/76fKAe28575jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=defAIkHx1uuGjm2rryVyJrxlFxTg3prR5rgzrE1XCkE=;
 b=V6v0n7PB54RRjsXx3a8WOAyy8gpgBzj7pIHSm1O4bWMtaij9N59Y7WNi05g2w5fRF6Uxe7EqbViC12cdxe6cvU18AAZlyoB/GWge/nmSAQGxTiGgGvIid3OSIykPLe0h5+Nq9UvJ7Kv5KHYyiv/wL1W/4JHPY5xZJjIOaTw5ARlH0ffXSL9xJL5d7tyJKcPfR9I1kHFaEcWBC4WeGl06OVAuDLQyBl2esC1z408bunegYWBbiYRpih1nN1d+gIh5e7YL8dVH6H6BmznwtwucdH6Ujpdy5bgC9aMCXqIEzmob1p6tj0g9GvT2uGc+FhfNE1KAjuIIir1Rh521/0Tfuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=defAIkHx1uuGjm2rryVyJrxlFxTg3prR5rgzrE1XCkE=;
 b=G/70jkMWbm5oOPO1URPzCW235JNrW9IWKLeEbzLHMcidFranVGtVcFWngg63U/r1gcd1UmHhiwV+W9ybED5vM4+3MyPVKWuZ/2GQaUZ4MQC13ryawLEw9lJfMedeE8Szhn/WH5pqz/chXNLuQtrCZe0pTB3KNt8D15t7C9YPn4E=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB4544.namprd10.prod.outlook.com (2603:10b6:a03:2ad::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.21; Sat, 26 Nov
 2022 02:11:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5857.020; Sat, 26 Nov 2022
 02:11:07 +0000
To:     Chanwoo Lee <cw9316.lee@samsung.com>
Cc:     stanley.chu@mediatek.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, matthias.bgg@gmail.com,
        linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: Remove unneeded code
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfi6o47k.fsf@ca-mkp.ca.oracle.com>
References: <CGME20221118044223epcas1p12eab9a6fb08ec382625b3fb43f401e07@epcas1p1.samsung.com>
        <20221118044136.921-1-cw9316.lee@samsung.com>
Date:   Fri, 25 Nov 2022 21:11:03 -0500
In-Reply-To: <20221118044136.921-1-cw9316.lee@samsung.com> (Chanwoo Lee's
        message of "Fri, 18 Nov 2022 13:41:36 +0900")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:a03:217::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB4544:EE_
X-MS-Office365-Filtering-Correlation-Id: 276127b7-329f-4ef5-6e36-08dacf5379dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uH8P6zph7mZdNX9sM6efsU+77Z6pqIQz3CIgTTCx+3B1UppVoovq6T9UhCy/KckqxIS1v8tiQupvk+Ssrd+PinlqvHYuBdsGkKbxo01U9jtyx65AeKpF36oCQKqgnWvhMmTL24AdHTg0RqpVNT+FJbT3YMSSYH5VPNgRAZGetm9wnfB2Zs4vpg5eUFtvCbBA4w4Snp2078w4WfySNpy4H9uqPwGUIekw0CLHNQMKpBsixYu9ZEZc4sbXSnOKw7IJkm/FonjrMJWK359B6uo1hCh4M1ZZPmoGKgHaI9sTmnmBDT6VrRQ/mcjhDnEeaVHgdyUOnAxSnixCQ+XdjFuHQud6Is63KqX0HZ9eHPWMvVIkzgU8wpthsaZ3LrDv4KvVGc1i96kPr0cA8M6mSRoFs/iC7QmLUoHmmNr/RP7vNHLrRBezipkWTNUMuOtTRwJjumxFFrTpOMSRH1PxX0tGehkIUFgMnLc5rJ0fvXQUuAjY2CGZYD5qiJl4pnwd5cQ+dCg4SIRwhEXO7yD0mx48I6HmiAPWUpZiaxNUV97Cw0jv0AFoDlCs5YU3o5gdQ+pJfDopfqDmdj3z2fjzrTdvFKBFp4+tRPqhfW323L5kj1oP2qhhaC/C4C+QUNbPEoebMSW90mpBWBDHaElkTti55g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(39860400002)(376002)(346002)(451199015)(6916009)(36916002)(558084003)(4326008)(8676002)(8936002)(5660300002)(41300700001)(316002)(66476007)(66556008)(66946007)(38100700002)(6666004)(478600001)(6486002)(86362001)(6512007)(26005)(186003)(6506007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lvtWro0tb7CbO3fjbSm6s+RgFJBVXIfz9AkHB33YX1RAW6yMDNm/S93hc7EA?=
 =?us-ascii?Q?lbXJ9Wg7jzlGOW+DBkaQZhlkw3oHU94yr8IWOPtnhKMc2SwA1A1HmzOqmLqY?=
 =?us-ascii?Q?wOnS3ZKvcjyrnJOLjepKjNpyvfZY75aTHekCUPA5igpZO5eav+roYGxgQ7nJ?=
 =?us-ascii?Q?2Vtj6FHGjOnWCRiiL3O8Kceu3Nl4l3CKxfm8D5hA2Fxu05tI+6tPIJpPsTU7?=
 =?us-ascii?Q?0ZyPBkbIL4EmAqX+JunAk9xGTv1wD3aItFrlapBn8IQnq4b9FRgl9pdG0Ctr?=
 =?us-ascii?Q?sfoq3+k8qtrBkYvHMr2MLdfgd+qmthxlTLSzDMhMky/HsQVB0droIMcaZo8+?=
 =?us-ascii?Q?jt8iQn/cim4IGCGfak9u55S0Px5KyCwqATxCNUY9eJkH8BvwX39YbWJVsKfk?=
 =?us-ascii?Q?loevBIErxnfJK7MoxouiA333pG1XRxYBP0FvabipkVy4AdB8RuwbSxBezECj?=
 =?us-ascii?Q?dN90hsf0UQNyniB/4CjUyY01XeZHXLM0qDIb1r/fAlm0R5ltuTJxNJlu1ocz?=
 =?us-ascii?Q?2L3qpollIFzVzP6gXhEMFvrT8fyJN//y86uqGpfjj6dQXFesHMKN6NGYQXWG?=
 =?us-ascii?Q?j2zXTWNC+B/ii3dIsTYSSlveJm9TKeS9HYPOgchw195tjatsjXhJ7oE36D0r?=
 =?us-ascii?Q?XWUCIFI9f86i69pzQcfvXBikEn5wq06mBM8fszsEu9FS4ti+dxqvnxtmtY9m?=
 =?us-ascii?Q?hxFQ6h6iU5QX/MVPvo9GiTFu6jkRMvGVNBEH5DcvFvLRE/WsyTLDZWj0kPZ3?=
 =?us-ascii?Q?ZoL6Uzi316bT7a1/CerLOmffRnOqh8hQKTUNT52yn/Y2DEcUKJIJ8z/A8qiX?=
 =?us-ascii?Q?C+EtJlz7n2tHnuMMXJ5cOiQOokpOL4zF559+UmyEiUJSFncCp8XXjl9MnGVW?=
 =?us-ascii?Q?mIiBcWmq+Ato97tLSrULqEidJ5lp3v1tDTxIxc7Nae31vbcvHY/RHchBr9tq?=
 =?us-ascii?Q?Kh0mMPe8eLDBCTMh4dbx8LFUx5ch57aEFNaDGvWXhmddUPm1sI3FQSK60izf?=
 =?us-ascii?Q?LUs6hqrEz+5LKEjaBu/kKMPiDq9dh7FfqygTYOsiIwpjsxcDemv/s9Y9wgnp?=
 =?us-ascii?Q?DOqk9Ein66IQ4b19bn2igeoyEklL+rnmQnwD75vPalxUu7vzY/7cD3uPZriI?=
 =?us-ascii?Q?XjRkflUyJbXg0TS+0yczafWKepnQtrQpFpKGDKlXO+H0M5W5fLNGKZPalwD5?=
 =?us-ascii?Q?YGhyqDqIq/WZ9v1XUNoHrI3epnORWq24sc/awbt4gpVPzX6Vq1Z+O7iVWMc0?=
 =?us-ascii?Q?f6fsR+PoPx3Lhgko5dgsmnLHlEzbcXeBrzJsGehakSnSn2pcUpfuRD0/sUre?=
 =?us-ascii?Q?NU3xJJm7X7yxipObBD+gk2ej7uez8R08PUIv3Acfgd8iCav5zeLnLqKH7nlA?=
 =?us-ascii?Q?5vqiddqawE9SkK8QT3S2mTyeVX3Acoyu6GTZYXGCH5pVOJO8hDWGRiDbGOPM?=
 =?us-ascii?Q?oTcSj7FFqDXbNUNqbvKPelYFjmO5lmCviWs2A9zRDCEzjwnYsHCCdskD51IO?=
 =?us-ascii?Q?JMEgzWwNJwWgNILlrDIEv06aoEOKEdwmTbnC5VgMjiVkd1dtm5/9ZSSpX/48?=
 =?us-ascii?Q?Fdp1v9cJ05ofiS+FGhP7ouNfa5oxshLvjhCZJd+NpvJErCXiMhf4BvFRAzbq?=
 =?us-ascii?Q?hw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?Kwp0EVGIWWTigfeLYKYQWVLhjHx95dpud2njWNzApqW30ER63yr0LAiYqu3m?=
 =?us-ascii?Q?9jy6r9Ee9f4NF7n0DB+Z7frtgdzchu+zA5cepxb+vtpXa6d+14bcszNRzlk/?=
 =?us-ascii?Q?koGH8Fs2aXOjigGnDtZywT37q4HNzz+ecbHiTMIT+ztQhCJ6oj+jzEdowt1J?=
 =?us-ascii?Q?rCbdxEZHgr8s5ob4IzoiEnSBhO0JMD8Kv77yTktOxJPq3N9VWTY/CODU73Eb?=
 =?us-ascii?Q?VQpl8XssyONefZrU8S0V7zXjFfTung0qGR43n8kZMORu9PuelRn2f72QeXvB?=
 =?us-ascii?Q?baGhhcZGOXalLaRcyQLDu3qCWlLVoQ30fZhun3T0zG9IKOyP51f5fERNKM0Z?=
 =?us-ascii?Q?glAsTL940vALS8WKdo+IsVLGcSaoMnkDDFlTJbkdN/PIX1omZD51mEsBgLPH?=
 =?us-ascii?Q?ll0UZrez5o6kdBqhk/9fYOluKfK2mfBSzg4lq/WN20ZsM+TKKZdpOufMfVxT?=
 =?us-ascii?Q?ZbjkYW3gRwHug/BnYXj7sO6ED4KhL+gqX3xZpaTj00jegHXkQgCyHghhuscf?=
 =?us-ascii?Q?P4vvx2XbD6u44FNNrB/cRSicEkW+ebJalRpG7L9Ws5rz0pHrrhzvEqa3aFyp?=
 =?us-ascii?Q?LYDn5Xjb7RlNMSRlcLJbykVkfrdPpVoNVjP9oE1pLbvVcEmhhYhlvlvlt/MF?=
 =?us-ascii?Q?5v/aUxrGt6JEHKCjh6A6ZMTsgHp0djjMZCqZJ5dbcLTH0KVNom9QAbD82CSd?=
 =?us-ascii?Q?ozMrSlYBwkz+tKzfgFwXmblaPUA+IRzZi1sVNpa62D7I1XBrD0JF6TpNVpl4?=
 =?us-ascii?Q?U7kLKdHnfaeI4TVLSfOEjwOGFB0+EUKpG/HBa1Ak0KBshYI7A3CKE5Zn/DV7?=
 =?us-ascii?Q?/CWV8SY5FwCoDWg2iQi7eBXSt03JOoK+Kvwg0CfE7ZUkMLAJ8fmBJHc0d170?=
 =?us-ascii?Q?uhgAeqmEmRQCGap3tK+ouagiWEgW43kgwAgQfQ0d7urVHK1CWivvfC+XpawS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 276127b7-329f-4ef5-6e36-08dacf5379dc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2022 02:11:07.5080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: isKzV9KMNJH357uMDPzi51dZj6oGdsFggu5ayU1ACYxJGBENIhfLDJfpRh9RCxh8DegKnQyE2UEr/cJjkwyCyqp46OP4NaNHXkujiBVqeGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4544
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-26_02,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=918
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211260014
X-Proofpoint-GUID: I0y9jo0cLQHMTBmFcpzPNm8AVjfZcEjk
X-Proofpoint-ORIG-GUID: I0y9jo0cLQHMTBmFcpzPNm8AVjfZcEjk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Chanwoo,

> Remove unnecessary if/goto code.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
