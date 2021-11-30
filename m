Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9915FC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 03:39:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhK3DnB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 22:43:01 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:29232 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229769AbhK3Dm6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Nov 2021 22:42:58 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AU1R5bS026596;
        Tue, 30 Nov 2021 03:39:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Gjr1Tf5jCzz+pxJYD4oonWOLDkWQPXLP+QHdcY/dNZw=;
 b=D5sQKJjSCZF6m+btF53/s4pbywoYLdjNabcy+dAqFdsgHINXbt7gsElhXtr17MAfBBvB
 mLbQn+QHcC3GUnRAqXxI8CtmqxLM/pT4AwUxx5n/MK5F8CEkITvLqOBxP64wWZFdma2B
 BuoxfW+xWUvU9jzR9+x1XVOuReVYlB8m3HqxsGtfZMCkPyMxSS4LSGCdKXtlzzC9ZcF8
 tmbUBqzaX4tOxyQWVIhnb7kU8qNi+HZGvXF68i3KhiA+a27j5NmakPiODbGi9Zae9Wwe
 FnKcr7Xzh190QNHZgTLpufn8gtj8GWlwub9ryyK7GtN6FvC68RnRmLgYefhzPAWnFLEh Xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cmt8c6355-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 03:39:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AU3Zaso152645;
        Tue, 30 Nov 2021 03:39:19 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2045.outbound.protection.outlook.com [104.47.74.45])
        by aserp3030.oracle.com with ESMTP id 3ckaqdxxs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 03:39:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KsjFuE7d6IcC1Wfv69IDHesUo3RG+q3cnjIziE/NUsFoI4IWaxH4HDnn+gCvtlpOmStfhLPrKeZ2NC7GEPEpJMqH3wIhHT+0Ds0Bp/zDpOVqbKopMjDexnWDJeyLa3YC9XIWnIb8+b1dPtdEReDPnq/i1+VD4tvkVnDo/Mmo6j5x+NQbyCF+puDZEZ2JJaM5XAXDRKT76R6VjBqcqUVrqyGdH3BWwAuLn/qbSk/1EnXv1uC+g8ar0wMyGfRHhr9YsgieU5u36EnUMkIgSsUFPciUiaOKt7zsnv1Ji+WTMiXdGd1ke8clYvSnhEVyF1bASMeRg13ENDqji020aK2QmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gjr1Tf5jCzz+pxJYD4oonWOLDkWQPXLP+QHdcY/dNZw=;
 b=KrzOPQgHy/S77HlTgSZuTgvqBnRP4b1H/4T7Zky2PR+57xA9GfZ55NcUZI7igV3P3WKZVKcvC9/9dCFupDMpEdM3Oth9s1Z1mHcmL5QIp0/CzeDeUF2CRwn6+9yeg9tHFHJNv5z9pHhF9U1pJFup/eM8pHZLMyDXGC6SuqCA+8vm11rUjX8BtolL5C4fzKl1KDrD5dfaFtStl3LD+Rx9e1PCWiAbk9KxQkX79/gXw8Zr/ap0hI3MoAmQ0t4GwJJvTbWU4Gsqc/21xpvknXdbWTfmdjNXVUAWshFX8sEgRHUsXExNyEAi0UiqVnc7cvgoT0CZZmQxwG2Mfwnjei2I9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gjr1Tf5jCzz+pxJYD4oonWOLDkWQPXLP+QHdcY/dNZw=;
 b=fS8t8uyeUlsCeVSm2gKanFvWP4a+o7yVyrV4z4aR44eQ8Vjx6S8OEjwfwSQLPwnVEXISahTdgEf+J4bou7O7q9MMQ+tg79cAYzHPLTzfOqe0AjwwU0aErEMTunrGbijpb89U2ZkXwnvfefACmLINknqG1LV96JYSkPam4Ivbv04=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4776.namprd10.prod.outlook.com (2603:10b6:510:3f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Tue, 30 Nov
 2021 03:39:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 03:39:16 +0000
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V8 1/1] scsi: ufs: Let devices remain runtime suspended
 during system suspend
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfvez50u.fsf@ca-mkp.ca.oracle.com>
References: <20211027130614.406985-1-adrian.hunter@intel.com>
        <20211027130614.406985-2-adrian.hunter@intel.com>
        <9fae5b29-72d2-046c-204b-b12629fa6e09@intel.com>
        <3f530afd-89c3-30d2-d44a-586e488f343c@intel.com>
Date:   Mon, 29 Nov 2021 22:39:13 -0500
In-Reply-To: <3f530afd-89c3-30d2-d44a-586e488f343c@intel.com> (Adrian Hunter's
        message of "Tue, 23 Nov 2021 08:34:04 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0089.namprd12.prod.outlook.com
 (2603:10b6:802:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.10) by SN1PR12CA0089.namprd12.prod.outlook.com (2603:10b6:802:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Tue, 30 Nov 2021 03:39:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47f81d0c-1c82-44a4-0bfb-08d9b3b2fc36
X-MS-TrafficTypeDiagnostic: PH0PR10MB4776:
X-Microsoft-Antispam-PRVS: <PH0PR10MB4776B5DEA54730F1EAEB9E678E679@PH0PR10MB4776.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1RPcXUqLIgXzOF4uX5vFyA6uNk0r+m9G9is6ibqPJAJknp/YS4gKRvjzeEQplmCnWImLLyOhSD9/IwQzv3uZ2iNc2MAPODSPvyOhsQZu2IGYThMf62FgLZrZXgtPJ90255g/3z1oKuNCZWZwWyXk1jR9kOYBtd2YQZPWmlr9vfLpP+RpuDi7BPvuWMM60NmI2AQlEmp/sw49Ge8Fxi1JDV0teS4xBoT0cB/R1u2LGeQnG7rP8OYWWsUSRZNeiUEp9XAjJNuUSpIbDDNFgb2j8GmuhwzV5RAwEfEpjmOFTmfi58JmSfLY98gKpPMaYJejbHK+shUvKRcMMWy+nkwyKDUyb9OevB9sTRZF5/Y0u6RZ8i7FoVUqF/yM7fHTpRaH0Lmcmwh8ZZnzw+We9eS0Tl0KxJYEVirtBLc3+xqem2Azj68Z4AovBXYaCw9UmJepgduxY0Z6hHs4Q8wwEGe2iPA6Yr0zcVjeXh321EhGbwqdailAFAWlJeLWdcehd0HLMxSbSAy5/cJFXYXP/ogN0ksCTajQnBBgV/Re1jfv+UIbnhlu2ACLcqIX+6qHyUSpvQiW37SvOkP/yFUecbm9dpm/OzUMZnvMDEuIawA/lzUEbGJ0stXfgRY8N41eo3JdZiPkg+8ah9nF9J4+FMHzobZpzG7BOei+GsuI6KIfLZuCTrEUwd2k4pqutXUfNEjI6hODmTttg8IPu8wIU6Abng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(7416002)(54906003)(38100700002)(186003)(66556008)(66476007)(6666004)(6916009)(316002)(508600001)(52116002)(5660300002)(26005)(55016003)(2906002)(8936002)(66946007)(86362001)(36916002)(956004)(558084003)(4326008)(7696005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7diaBcAm63skuEmh/XWPz0QcqQP/BGbNxmApixEbO6EPcTlSgdVW1innqT0n?=
 =?us-ascii?Q?T8tEMYtyAvG7lOSCT3DyRZTgRG/YSpbr2qSEnmTqGoaKrgL+GMfGdUgBJJ7N?=
 =?us-ascii?Q?4Lrp9BOzpp74KNAM8LhYSO4lB0P0H+AB5kLe+rOe6W84zVN9I6KLjiYwgNZl?=
 =?us-ascii?Q?/UgN+dLc75N0ngYGWVJtVywCpFEtIP9Awte0KSxmc/YPO2OKwEvifgjFWEpf?=
 =?us-ascii?Q?WX8eT+U17DTgrn0f11YJ4gErWfk89a1UfyS7puphpoXrKevsqc+qTp68n3X2?=
 =?us-ascii?Q?+opTEkSR5njmJqX0srVux3jtoAfkBMGEKir5zFfD2wu0c1HnmJbOEY9QIPJQ?=
 =?us-ascii?Q?Hjnu4x4GTj5uDvnod4rMEf3p1sFNHiYbelfh9KUDR6MEH/7NOY7ozchhItqH?=
 =?us-ascii?Q?3b+7uWlY1wB6pbCX09uBtlkm/AqyeGnqbDtMQIZ6Re7liHfdaDf3Xsw5sXbC?=
 =?us-ascii?Q?ZyymgALHFc+WSSQCrq/os1Fjb4nfOdV5lqtt908XC/yz7S8SVGZGan9ypT0T?=
 =?us-ascii?Q?qYxxRjEmWG8CBQgujX4vdbGq8sNnP4LX5moKIy+f5PZE6EkXspnWUcI3hDph?=
 =?us-ascii?Q?j4KiuIgcvcNERCk1ji4/koUxwnZph+3DxYyJ16lRN1OascnEgUUGlj4FMMBU?=
 =?us-ascii?Q?h+ZEgdeRHrE2pmcKvIDv73RFu9L7kVPTVjrmcenARw+acXvhOqhEF1zyn1N2?=
 =?us-ascii?Q?S5Na5GGknvefNr4exsWF7k/Ztnj55jyaIAIf9NoDq08BsUGWhPhExCo8DL2y?=
 =?us-ascii?Q?4W/tr+3ksiVcoo1J+jfnFuBaKcBhJ0ivYZnRJ37WUshZhURCC3s3vsczyPVQ?=
 =?us-ascii?Q?2iN/5NhLCBVzay/EXCkjMhdSEr6XmNhfQrF7L9wn+x1HtqO9gazoAEkwK3pw?=
 =?us-ascii?Q?pbRczKyuqIODTnjrgMbwuofx6XWrO48vN/hOTg7ykHkb9mbxhbe+QJAmSBq3?=
 =?us-ascii?Q?m5+oktOo9sf+3vIEa9R2QbxTVgzqC/24l5h9DFaOGhem7Uivy49f7gTE/z4q?=
 =?us-ascii?Q?XQBnfSTgqdM21tzKjUYNEw7uDjo3vNS58GJEoWL2cAqMbi01IGo1qGSk4Exl?=
 =?us-ascii?Q?IcMQ8pc5Vop8I151Hdl4qGAVIR4qNuse1OzClj5WcwcbQdfR4bPjX3ZvIHsD?=
 =?us-ascii?Q?LwrsRjSsHhxXXx0A+vKU8rWAj3HKKZU9+mYLCaLYT8xCLWrLZRFB2ZtAGOMT?=
 =?us-ascii?Q?qr4k3pVtjgIFKttrsUd6U65SmXMVsSx0srz55K4S5pmENiXaNzgJ7ob0ls0+?=
 =?us-ascii?Q?9J2L4VI6L+/G0W2RwCdfOVUgg0vOQod29ofQFmdhp+PuNLKheqWA1oyzbM9k?=
 =?us-ascii?Q?DfOro2fQopqI2nU4DYm2nBBMrM5WbKnvFitamrtA91LqNqkE8GmI1N2DuVe5?=
 =?us-ascii?Q?2fScO6LqAeM0+/cICl7xwbxXiEO/bVc8Yt0ROz1wXQwAuWCtu7sRTXoSDDZC?=
 =?us-ascii?Q?scrVM49HAmD66heAbZy99MgHMQ5m73tawDZoGiDMSEN50NMf8NDIYi5XgI4q?=
 =?us-ascii?Q?XkHzIViM6aNnA9+RF1Eox4Tb9BRN4R22UVuH43I2vDbnYrlJF/dxtMIKUO3z?=
 =?us-ascii?Q?zS5+TJ+O8WmpjDsjQkAJ2ABKxieS3K2FVt7+b67KDSEooWi1YfXa3Q7Dwwwt?=
 =?us-ascii?Q?nrVTLJgQQ96bGPT4HDeqsn1+vonVMgLeP4KCgdm5t3k7ufkqpstO9EMjxmUW?=
 =?us-ascii?Q?WiMK0Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47f81d0c-1c82-44a4-0bfb-08d9b3b2fc36
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 03:39:16.7612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: clZa6FoNUOwDtqkFQRX/jMmyR+MmAalvOCQEElC1uJp05cDw+k7Ch0DLUxPrQn98VSwE5GD+K3qo6tS/iNp89CzSHTxm2TpaMR91oSyg2aY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4776
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10183 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=899 spamscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111300020
X-Proofpoint-ORIG-GUID: dROG4QjyfHQgx98e-g6zzrVq03PK5YeD
X-Proofpoint-GUID: dROG4QjyfHQgx98e-g6zzrVq03PK5YeD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrian,

> Seems like there are no objections, so can this be applied for 5.17 ?

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
