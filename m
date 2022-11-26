Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D84E7C4321E
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 02:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiKZCd2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 21:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiKZCd1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 21:33:27 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610703F04F
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 18:33:26 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AQ2AMEB016792;
        Sat, 26 Nov 2022 02:33:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=07dfmU07OP529PBYRhnB6ZIs10LJiLRPC0axfBMWtmo=;
 b=J3CKZiks6/v4gA0sCk3/oTWszT8SoJUe1jpty1y0dDjdchWh5FExNxWbktsXAzWAX4G2
 2A/3YPgnlPYT1gnr6b4fdQ7+t/7c/Tnp2NXrAI/qXKkl64TrVW7itshFIkDZL8HmGkJ6
 40bahMcIxK3PoYySUoifQlOUDuf3pM3qQjwUIhSM58UeVIBgcNa7CA2lTyUTR7nKBGoL
 MKKdtnZJUjkY/4DCInNyLd0mflvffgQ+ZWaIPmdSTjeRhwK8kK07MShgGg6eB2gso5xr
 dhWbpRVxKYvJNcT0MaCgxYglm46dQVDoZDDLno5j0ZhHy3IUYQlXAmrOt0gRUWl3RmS7 aw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m39dfr0w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 02:33:18 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AQ1Xax5007423;
        Sat, 26 Nov 2022 02:33:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m39889j97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 02:33:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QloCLW/aHFZrgd7KzYXbC6e+13eKC6RTLAxlzKmkWSKbhKrdgFLauDkQtHFvtKtUDiQ+UTyfVDbRxBelc8gRURxnsVy/MRXWvCwj1XWIhGtZWSiuBoNZloK1hwLiCyhzw2FBLd09blZLbpbaCuMNsFRd0zXcsu0vcpp9/a+7aKGd97QgVi314YzDE23ovcbBIowBlOhn/ylkOm8M59h6dCsiySXtAVnAw3VGahi4ODSyUCyVRmx3z3w9YfQpTx9nPv7aKjHmBkQpQUTszA5EMBqIhS/5SpoWQeDg+BTMvltsEP5ypbmj1BGZgwZ6I6e/oChLnLaJHAXK8AcjodM0dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=07dfmU07OP529PBYRhnB6ZIs10LJiLRPC0axfBMWtmo=;
 b=FlxCq5Ok3ZSyF850wJyFhXJBXih64Hk+QETl17S9mGIyhTiebH9JVjfbZ+5qq0crhSUKhX6LVW2I+KtUeniFhl0Y9fqyU+XYIcbLIt3JbTcGy1YnKqk+WKN3fSoIuiJS78fFYcGCESidyLI+ngWmLoGTChM/9xuE80p/xbN8M/efbhSauEDpGrEdvfRRw6e5QvqflIooZ3Or4YN5JX7YjfKMtuNPIu/F7OCnf8TBNGEHtt4eidBk/opbOa8ACwbPM2RkdEBcdh5oCxSyqrlkJr/50ol5CZ+JgEc7+9y2MXSs/xBOpi42S89iReTLpNzxDh1EadmSXD+v1pXhNQYkGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07dfmU07OP529PBYRhnB6ZIs10LJiLRPC0axfBMWtmo=;
 b=XxgMZHjwMAbqNw45ObWw/xzB1LNgMabg5q5p5A2ZAdxOIXskfySlGkqlYRliFixwrbylEVBe/kdyiYtGMQ/A9N+gr2q6ENi72+H9j+4FGP/2sGFCS2IJv6oq6RqnN702zUP3bgceJSkoxIVypV9UV9L+O+tseELJA0xzMd8x1RU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA0PR10MB6426.namprd10.prod.outlook.com (2603:10b6:806:2c0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Sat, 26 Nov
 2022 02:33:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5857.020; Sat, 26 Nov 2022
 02:33:14 +0000
To:     Chanwoo Lee <cw9316.lee@samsung.com>
Cc:     stanley.chu@mediatek.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, matthias.bgg@gmail.com,
        linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: Remove unnecessary return code
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15yf2o36n.fsf@ca-mkp.ca.oracle.com>
References: <CGME20221121003431epcas1p1429429bf4bc1670c7b82b3889c017049@epcas1p1.samsung.com>
        <20221121003338.11034-1-cw9316.lee@samsung.com>
Date:   Fri, 25 Nov 2022 21:33:11 -0500
In-Reply-To: <20221121003338.11034-1-cw9316.lee@samsung.com> (Chanwoo Lee's
        message of "Mon, 21 Nov 2022 09:33:38 +0900")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0126.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA0PR10MB6426:EE_
X-MS-Office365-Filtering-Correlation-Id: c60665f4-55af-4625-92d0-08dacf56917f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9/03pqvETgZcr34JOIU9VMSGokHhLcEQj56RvzIdOIs7gZOEqOzByojejNqNAXlefp1OFZeKjEJrRFtA0kak2/g53GH83bK0M3tPCGu8CBu8KtAiaS81bdbwWSokyuJZKbALBAINsPS3kSDjIVcMqRTaCkEI42vWxq4E1eyeIP4XrTZ85aUuWxGgYNxkMiSibzPgzBf87yD60IMJIbLY+37ZTpTmQbOThpTWQ9K8oE/65F1qokQTcvRx5nQ9D8zz/eREVQk8GF8yNXLQCuUy6qRhB3HA5pFqsU0yuP7dy/Ihg9qB82+81FLxPoxwrUy6DOENShaLiRWmXeUvyTo0OMVfzKG5A6JaVy8yCSGYTte0D2mxl+kdV2ooa8F0v5Do2FGYEoMSh+8pR+IP1/wo4OilNDbOcBENKon0/aGkErpNU5KHj2iVi88VaNQWgIOa9vIv6Ww0YghGwnilYb0kI5tYLDJDKoEUohq8/ilAUoNjVJ5LyC4hE71OkGZvSIsuOB/f8Yr0lTWZ9QkkRXsX8yeNe6gyagJGWszAuyDRfGLIxs1Sn+HyeErsmNpk5bL1MCgiyDF0DLDPV56w1ciRpnvY+6ZI/p6QjNP97VYeDXIqyDrn6+m+Y1gXkQObwjYQViMPxfgpK/Md8TsUz5Kehg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199015)(6486002)(478600001)(6666004)(6506007)(36916002)(26005)(558084003)(38100700002)(2906002)(186003)(6512007)(5660300002)(66476007)(66556008)(8676002)(86362001)(4326008)(66946007)(316002)(8936002)(6916009)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KHTtcL46G8P5g7tAg4bjkjLEqTv8PY9QigDAXamsoCmIWbVSBlxtR+QCTgEE?=
 =?us-ascii?Q?uIh2MOpDcP/Dle3zoqNDqpmMjaUAOjTtDV7NjvxXBCE/PMEaa6TjqUqWdqYL?=
 =?us-ascii?Q?KtOmxLZNVhX+HbTp/TT0li3eHM4NmTQLpsjUf48MxzTv4eRrlxLf+QMx2ZQq?=
 =?us-ascii?Q?ipyvq7ONMW5HxeVnYtxrCtmklcOhlrTwOB3GcnReq/+jj3DiiC/TmDIY9eiQ?=
 =?us-ascii?Q?fspVLTXLQ4sUCsqIdtboe8aEUgWoiccfphvirw3LY+aGYVii/1mk6y54Aavf?=
 =?us-ascii?Q?FL7gs3K0Yhaty0TXfFJ9G4SR9ZB1s0nR0K5hGgBCM3sxofxCeabhvzYHvPC2?=
 =?us-ascii?Q?pf1rC5sBbBJ6m+EENgMCOGch1Hasx9Wn7hAfC9Plo4Tq6D6QSTOPPMsaKjR5?=
 =?us-ascii?Q?ZJzV1yTouQO9Jl1FmCQ52pyvk8egvbQDTLh8BLcWOeU7DXWrxUhDnxrbTYnH?=
 =?us-ascii?Q?2H+YxiR3SyOaJ5oCczyhqmd5+toAJUMgMiQzTbHkn/uMyGbYeVng4nfuXLqA?=
 =?us-ascii?Q?/J7tCIpnpqu2wbLWVwP0jXHFz9c7Ed4O+bGufyZ+pcjPamhbXUAf4Weyf/SG?=
 =?us-ascii?Q?sCXTu+Hp/l4R69RVua4Wk5sRboi/WypeW3ya7d04f9+IL0adhXI0WXKXgRV/?=
 =?us-ascii?Q?pfkGk66tK7wg37kZArbGGdyjp9Ik2cdYKql5WhGGE8ua3xRqH3KX7T7iwbr3?=
 =?us-ascii?Q?4n87HumnPdTlPDw02/ecajWpQcNPpCNfQ4mr/c0wu0lCBXPd4L3MF8hZKNkj?=
 =?us-ascii?Q?f9EQC/0CsYeAneYWwG0XJZCckSGG/uU8DtJO+F7DlJNmOAbDTHQCXOxMFfkY?=
 =?us-ascii?Q?nkX86F/xuit7xTrtBgQFs/nzs4WqpzEJkZw4O3yJT8WQfatZLL0x4L8ha2Rt?=
 =?us-ascii?Q?A3+/M/W2S8rgdMIs1qTOzKRsnRWVo1liUhQTc4bgG7OtRIwSDQaInWDuh6qw?=
 =?us-ascii?Q?LhHRn3m7eTtvRMd5DzMNmzrK4DL+xcsY/ZGresfZ4I/USPAVnIhh5bbZtuVC?=
 =?us-ascii?Q?ZmKr6oKZG0R0k0HuRkXrOgPul0+GBL06cAKoTwLzHzryN3w7fkqTv17CTCFL?=
 =?us-ascii?Q?RqpP9ZSYbRTeOMjavJFlqTXgxvx1u6a5ZhmDHMRbvTEb2WYbn1rzamI0OvuK?=
 =?us-ascii?Q?z0Nl+7VIxBPrvwkpnf8qgCYitDM4hpQZRGaIZK8SqRxqxnJIQvmOhTyMNrsC?=
 =?us-ascii?Q?zBT2rvsIzAs88ldz2qufBWpKo4zC4a9zJpMacNZb28vXKEYEu0mDaSda69PM?=
 =?us-ascii?Q?rxw+cLDgUtcFgaLyF5OX02LnlacBzwbU6UeVzkljQJKbGizTKZSdZajE66W8?=
 =?us-ascii?Q?xSjGURzabPFPprnl1WKITyH7CpqKvJSvaKbsx5bXz/Wx9KKZilZd/TIvL5W8?=
 =?us-ascii?Q?ZOo99f7k6pk0izY2m+ESmL5NQJJAAeEYv2DkvOydbzqYo7mCOg3mfDxNpLBc?=
 =?us-ascii?Q?luDbqs7eg5JCyM5aMSvXTj9tyEVKUZdSclSgkK3VyqbdQwSM04u8IZomhHgp?=
 =?us-ascii?Q?cFHXWhf/dbywZORA3M6i26OrGpZA1cpjwaPtZzLXl9DBoUNqmrbmnMqwqQFP?=
 =?us-ascii?Q?/64CZutzgm9JjSahThjvtf7pQEb6BL2SMGL8g5BlSeARJvIhcrTpImOd2gtK?=
 =?us-ascii?Q?HA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?zwWmeeCbzapbkdgjINBUtIpwL48DhKiogth0qxHhXsnjMxmG7gcH9awN3/g9?=
 =?us-ascii?Q?OyVoUAjmBbyDt6uG0m1JoLNcWHuit3/yjyoCktWFlBPjNX1zTpof0TL+MpbU?=
 =?us-ascii?Q?rVD6cmutgSUvjwGWGYORqY2rpuUsxOt7yuYCA3q0ZQSP0NFNbP/uTgEtu24B?=
 =?us-ascii?Q?kMiraSe0D+S/r2UKb6fbKEfHXbFIfMHU8pOZRwlVvRZs9LVw87Wz8SoxQm2e?=
 =?us-ascii?Q?B3MTHghZJpIknJ0Lk1uqJYUa5DQfzpi8QAdqPym5UMZASBiFLG2k2Wb61+dK?=
 =?us-ascii?Q?B+vHiDDDGxVvXkRjFAAfrY9eSy4jQcEU8nfexJHcd6LNhZ1sr99fqENUuE4x?=
 =?us-ascii?Q?4MOgYqu1kFmSi1WwdYFsn80cwkd932enEfuGca4oZ+2RCFeloYJKnO6Erep5?=
 =?us-ascii?Q?hluaQhzgKwbJ328XZS1UmJwp3590MUWsu97miANfER+leUV64lxVVzhh1HkD?=
 =?us-ascii?Q?rvplzXlXAsiezp3xV1uLq1ViU+ZceOdZhVDIDJj7gI3CcTw+eOtdhG4cIJ5o?=
 =?us-ascii?Q?PUHmKMg/SWwhGFsoisq5Ae4Bfjyy+nUqJJ01mAWUpiPSNfwoajVDpe1Bw08R?=
 =?us-ascii?Q?jqdgkzSCamVc+tXNebvIftZm9iQL/K3y731bMOiJ4ZF6muTgVcBYMdYPDvTT?=
 =?us-ascii?Q?m9Xx3FganC+PG33eRIjWGvVgG5DCHu4pbBY0PMe9hUxqr3aGBadZgTiFdrGj?=
 =?us-ascii?Q?g8ZGebXBKMMQ5pCIH9w2HJR/EZJW4H5ldtMxnfQQli3GagbrSohf1OkpMhy+?=
 =?us-ascii?Q?1XWC6Mwa0ggm4cwDN56Ewg55OqoLUVwbSyUNcOCL8yE904dArURXOjCSWcur?=
 =?us-ascii?Q?gV1pKJhhk6GxJG/alylFsxTu/FBuN6R83aIhsgcFb+ZYog15OG1qLb4as0uS?=
 =?us-ascii?Q?C8QsnL1f5e2P1hI7x21eaIfbjIsCm5jloWKVRNHC6NNSF+MyvuDVEWfrvzMX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c60665f4-55af-4625-92d0-08dacf56917f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2022 02:33:14.5602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Dp43ygjjNoOwyq3UH+divVz2/HeSO6ytW6V4RNDM5on3vZSk6lGICNMwPy4ysD1jZb/jGbD5HzMbYmOkhLhEE76ALdcJF1Pl8bBuCdDwnY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR10MB6426
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-26_02,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211260017
X-Proofpoint-ORIG-GUID: C4tGAzOm3bFWz4Y3Shxxm24IiBGrg_3m
X-Proofpoint-GUID: C4tGAzOm3bFWz4Y3Shxxm24IiBGrg_3m
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Chanwoo,

> Modify to remove unnecessary 'return 0' code.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
