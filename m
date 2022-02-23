Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96989C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 02:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237694AbiBWCjW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 21:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238112AbiBWCir (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 21:38:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B7A66C8E
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 18:33:42 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21MMnHn3000629;
        Wed, 23 Feb 2022 02:33:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=928X5qu4c5udo7OM6pcz2AQMstj7Hjvjoy1iKX0R6hs=;
 b=rdQKcRUGkvQzmdoPNQpwwcoqfRaG5wHRFvX6X65+3HUWX2uxRiFUO9gBYdRjL7cjn5no
 CELOYrPlKviejyIm2zQFyS0j1uKB9KKac6qzvALb7ifoTNF+6U11NWv1NcSmNDKzLd0C
 liw73FHm36RS8Fq4ZjJ9CeiL975W/gvfbQIRs+UTTxDisU2lnXdkpHb53TN/Og+JBaAK
 FooukeXFTXC/ZJSGu2uyEPErrp/mluU7iNi4mMUKX1cnLD545UlFlqyIRqgNvS1Mkgt0
 5GB/WlteiGacUYJvU9+YluUeT3g+gfhBmFwdff0ovRybF6Y1U5qGv+YuiKRKjaZWABs8 sQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecxfat5yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 02:33:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21N2GmFc022186;
        Wed, 23 Feb 2022 02:33:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by userp3020.oracle.com with ESMTP id 3eat0ntsw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 02:33:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYRE5JJ2oT0ND28/iG+QWarVp7t/sd6Ev9DUb3/78IYpae7wMD+z22jbnzpCQtZ698rLahjiWisa6fbkTcbQMY3ULPx8j54vSzRcXL/EfUpxQUJyD7rFRld/Mq7rS6wgbZUlPr8uSjuAI/hRCnfzuCHASspwu8GehVjwc0WKMLoOMgrK4spN3F0E+UvKAG5+VtmF4CVwm67TOpzANUInh+Fqad4v04/+GvzciQDYegKjrBcjwlMxgCQZa7B+YaPnHNaMxaUhNdQitWQNubcOeSkZraJ8RwObVaJWDFFvTgX0IwADv1WYKLpX8ZBESjsd1Fha+yIZBLhe7LWWSa7NQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=928X5qu4c5udo7OM6pcz2AQMstj7Hjvjoy1iKX0R6hs=;
 b=oBiSQmVXoUt8cB3uLN0XCFt4ZRl+tkjf3W619S71VB0007UTyPNci2IM4L+ROilPVXOPnpp8A4ih4SuYTwmQepeSp5FqeO8gpJTJcVLeuug6HpLbf2cI199uCHCy8HuFiwVA8VoZS3n24d+5EwnidA62lCRHOseuquEkXvqf66GOhpa+vDXFM7DgAE+ZdHo9I2VGT92h4zsVZNcEsUtizMnUPjeG8dRaJ3IgdS7oC9Uv26w4u5T6vF4It7/Wt11WnFGnedvwgTAfGgKnLB7DMKCY7tuWbK4Wq43117fbJgX+qwqxsV+fxQznh7M9H39dNc/aQdoRPu4aIBynpu0MOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=928X5qu4c5udo7OM6pcz2AQMstj7Hjvjoy1iKX0R6hs=;
 b=X8RlUD1z/wGjxPNh5+30MrP9F31/HyvmIASCfOeqtZnUkQ95tm2wqkJX7inXPjvoJg5jVBGXhG93Zp5n77Ly1rOyGA3NG/akHTJA/FUBnOV2rSV19TRflXqBb01Wr8yaCDQu410Agskn0JkLy+rfLmNaySKNPlKB19DOdAuwzqs=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM5PR10MB1243.namprd10.prod.outlook.com (2603:10b6:4:f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.19; Wed, 23 Feb 2022 02:33:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593%5]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 02:33:16 +0000
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: Re: [PATCH v6 00/31] libsas and pm8001 fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18ru2cnxe.fsf@ca-mkp.ca.oracle.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
Date:   Tue, 22 Feb 2022 21:33:14 -0500
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
        (Damien Le Moal's message of "Sun, 20 Feb 2022 12:17:39 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0101.namprd13.prod.outlook.com
 (2603:10b6:806:24::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13beea1e-460a-49d9-53c3-08d9f674d896
X-MS-TrafficTypeDiagnostic: DM5PR10MB1243:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1243152AEC63E159185F0FB18E3C9@DM5PR10MB1243.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zBUL2nOa7tzh7QwJntoXiQI8KSNA70dKxIdfF09Eh6QIGCEbxCMxLSKE9eAB1yaLrTRAybVEL6Y8QUPg8jOCCm683LfTvbkxWntBnNQD8tkxmy81q3bom2e8dVEWb75OUsK/jlbJ933YbH5j5zJDAGPR/y8H6nUB52Pjz2BNDC8qAdkCS8MDuXCRTRmBn3ouedaZ+0M05M2kSaP4Yu7yr8sVdiTcufzWi93AUhPfOejsvYv0fKNzWWg7ZqE1UYif0F9ZPwUfauhl0xJoQ1fySiiLLe/fvUJFPalI9kjrzSBbw30+/bb2FSDEUZlYDL8DY7GIXYbf+54e0MWMRVpWmLmJ+6X4fKZDrZiAGwC2hkbopM+jiY63OGtOChjh/JhdNcrNWh/5biYQxcvruVLGSf5to/MAzUViiB1E3OpFNB496T/5iJ56YWSD0YfQ4lZ+qtoqLSKNkQrI2nhZibmgWMLE8E187pTjoFVJULhKDwS0ILLGz08ToYbmyih6g2G4i2rTIlRcBUEYeqYCK3kM3CNzBUy9LYoUK16+cREmvF4OOSC6eLJZ7e7GK2j88qIgGbxUnjmudQo6Pk4sOn4kkx+bakA1zS65EFlBeKZypYtPdLteFVVBquApjceeBnlq3+jVH3srmRjGrT4HpzPGgCwtEyfWKvNM8Fm47hE0L0fWX0dPsBaXsQEPt9PLTyC5GtV9yvaQEe0Gebi96GJ2uQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(6486002)(316002)(6916009)(508600001)(83380400001)(54906003)(4744005)(5660300002)(8936002)(6512007)(186003)(8676002)(26005)(66476007)(66556008)(66946007)(4326008)(52116002)(86362001)(36916002)(38100700002)(38350700002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LcHpb1oGSU5Pe51dci2WSNfstqKT0v8sjrXwJKl7XLYfDLS1z4EBC0r4EHK8?=
 =?us-ascii?Q?wxr08y82EFhKJVYJoiTQikYr56iP0J0gyaZwWRkA4PVuKle5ZqG2WJ6H4zC7?=
 =?us-ascii?Q?GqB8rMiArxF1kb/58o5zcl7iPC5WsqmmrocJOlrjVgw1KZlFMhAevu2LQG1n?=
 =?us-ascii?Q?BINwrJz7kpLivq+JOlvLxUScxwAh+4gTiMwU9GXqnnb/y5wgAY/G3EPAv2m7?=
 =?us-ascii?Q?89pQVHRAfpheJUPUdCOrlnL1d9w5GYWOY7MqI/0zL4ewsyq8SuWH8qmfMXvV?=
 =?us-ascii?Q?jL6ng1W4VhPEG4r8S/y8ontPb4GvJJ8bXVUIxLdUVyEj5WGf13F24mmGhCgY?=
 =?us-ascii?Q?ZvRGACTxw66tVtDWSoOElLzDD00/08d1av2FEdrUiVnSzXrAj2PVxCRKt0Vn?=
 =?us-ascii?Q?4gQ2W9rYWPz853PRkPH/6nWC1xksdtbHFyIxcbgmQW6Ml+0h39k4NS6SYvwK?=
 =?us-ascii?Q?IBUfWyyc4zg78YNQ1Poxyk3zaya5ZRxz1+Q0DNMXsP2mlgA9XXul5z6TtjJC?=
 =?us-ascii?Q?YR5Y0gvchhsnOfyWI+mVH7wU19K2zsWFgkcdijoS4nemqJK8aAZaDAEMqx0a?=
 =?us-ascii?Q?2neV3VnQNNbHBPPq8OE9MzopcO0Umfy7G1CH0+4ThHPbbui0+z2DhBpCpP34?=
 =?us-ascii?Q?HOmV1kKAwiospddNWPinLcACta7DW61qmzQqXUdntDfZ7cjYWiLSaiFESImb?=
 =?us-ascii?Q?wCxvCwgGG4eKPj9d3GDm+vN1Iu1Mmj9I+VPTf/Hix36lmkNVDbtRwwNsmhtP?=
 =?us-ascii?Q?JRNwwJFIATAoTSWaAcrAhcOV1WepcZqmKQG6mnAi9TpIzRbfp4T28EHmzLFz?=
 =?us-ascii?Q?DFVx/RvmnOrXIXu8xFKeL9QTO9mLvMprrvxmOer9KCFxxGQufHlMtaeilxof?=
 =?us-ascii?Q?kqcGTKsrR1RafU/Mu22PzVP0Ye2SF6a8Xeaqav0+gMDEfJLRJsFcLHf5MFpA?=
 =?us-ascii?Q?jZ46lWSwV8Qd3oqNMeQEON75Daj+YKpfE94Mq8LZB32oIQMDazXrI3GJph2B?=
 =?us-ascii?Q?o1ONKAOkA+O61qaU2DjCyu6euKJdG5f3aF4J/fcLJVRYjI6C7RTIN3IVLdnS?=
 =?us-ascii?Q?ppr1x1uxARZDoeJ/lZVpmUR0X9Dfh3ZAUwrI8C9eodQhZ7AcTX8jNOV8+4mi?=
 =?us-ascii?Q?TtKUiA4TY1FDmJXO/kiOIbtbLyTxTbqBSXd1ocIJuQuIbLZoFvb0IDrQzvaz?=
 =?us-ascii?Q?pvqJyk6k2nU1bLCbjN9tuvmuZKYjseuoP73xy5VQ8k2S+KNz4hnGMly2yNol?=
 =?us-ascii?Q?jgWYOPuDZmKPfq5X4O5kWTemSZmEUn4Biv+O8CczU9J+ncwpxHke0GIc1NVW?=
 =?us-ascii?Q?q1ql5vLFjeaz68AV4MuygSPnTgIDYI9QRd0fZET8fUY+BDFF9m+N/SDAr/Zm?=
 =?us-ascii?Q?MpiEwXl5FLwKynwAvdRXv2fRTu071fiQAB9E7meJDXbkrtMUJp31dpQMv2ui?=
 =?us-ascii?Q?lW8yfU/CKZh7hpOHnESwccPtxj2Sic5VW6gwFiCUaPMKghEivngLbfrJHUME?=
 =?us-ascii?Q?Vuf4SyKsXOYMlM7DF4G/jMsZzfTMibyJ46Yzu4QYq26AHRCAT5iwZDP0WorD?=
 =?us-ascii?Q?PNYAVhqkN256c/hqJSrHpNy9ZHMdoIiqNNN4u4pX23JxV3N/WOh5IQ/0xfKr?=
 =?us-ascii?Q?tqYPu4p4k/srVqOItkMxlZST8sYXJUeqXDSrYrzCHFAyShyqx9aFq+VkK+ef?=
 =?us-ascii?Q?/LWx4kwvUl8XS7ybcH+YfKcZX3o=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13beea1e-460a-49d9-53c3-08d9f674d896
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 02:33:16.1099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jtdvkYPE80NQaLZdAQpLrPnFhLj+vByrsZdu5h6DgoRIowLHxJVv/XbKG6/lhoMBS8yK6P5nFpzqQYEL2/SGXsdWuKFQGXqfzd58oLxZeVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1243
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10266 signatures=677939
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=460 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202230010
X-Proofpoint-GUID: tCiV3bkIOrMO9Hhm99N3h5rYqgp3DAYa
X-Proofpoint-ORIG-GUID: tCiV3bkIOrMO9Hhm99N3h5rYqgp3DAYa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> This first part of this series (patches 1 to 24) fixes handling of NCQ
> NON DATA commands in libsas and many bugs in the pm8001 driver.
>
> The fixes for the pm8001 driver include:
> * Suppression of all sparse warnings, fixing along the way many le32
>   handling bugs for big-endian architectures
> * Fix handling of NCQ NON DATA commands
> * Fix of tag values handling (0 *is* a valid tag value)
> * Fix many tag iand memory leaks in error path
> * Fix NCQ error recovery (abort all task execution) that was causing a
>   crash
>
> The second part of the series (patches 24 to 31) add a small cleanup of
> libsas code and many simplifications and iomprovements of the pm8001
> driver code.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
