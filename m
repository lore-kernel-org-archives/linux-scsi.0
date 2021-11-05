Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 217AFC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 03:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8E9661139
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 03:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbhKEDp7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 23:45:59 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:24218 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231201AbhKEDp6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 23:45:58 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A52fbWl015460;
        Fri, 5 Nov 2021 03:42:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Eh5YCBET4i3L9zSluSi0onAJjs7unacMuJEOqViw3x0=;
 b=p9tdUMKPa8pQGFj3n+UHjolLZQgc+xCvnenayZKlNXwwwrNshxkJTnLvHyr4OGsorCGo
 CJKGaD/EMU0pX0f6FjD6WHJs/8o25dr4poPfGRi3u2zL44rwlLCYG4DxesUHAeF0CjnI
 HebStir5QtFatBh0N+tY401SOUHQws5VTMltIeUfytI9iSKwlpwrKlNMnMZcXgCjbdc4
 XO5wpSKtLG/G3Lmj8ELRVofGH5zbTnHR0+8LwDfgRLJUqi8WwjSkrOvriBUk98oOc2PA
 z1J0+3T2fYoemg/5OCcy8YKDIdv0Ca66VU0uXaM0OWL1VUxVUGIOQh+cUzMOQS278oNf rQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7k0k8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 03:42:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A53g0WU182037;
        Fri, 5 Nov 2021 03:42:53 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3020.oracle.com with ESMTP id 3c4t5rwbbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 03:42:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUSvgWZn2VJnzT8sP4yJa+jYxu6FXRGRnJXRDRQSbBBN8JaoFibLQfreEfrVx1gIvnvu32p+HCtWSCf7y6m7IKNqAITt4mFt8SDo5Z4vj4lHzpL9lVLGahdU0Jh6UPbDEDnvAW9yb1mIg/pdnkwAt6q1UHBFJSI2GpoOQaGugNj3q0FlpKERe2iLb172HIp3omo4gPeOlFzkTOK8vJRre20v8uma4a8xZeF4b4dsagKW7yaBbjn41dkNXPAq2NUWxqoCAV8aY/KOHJiJ8dHLPPkQOgu5F671xQwnRqzDxrdgmUZkZ09kGmiKc3n/isRMaD/4q7+BeQdD5Etb8D2LiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eh5YCBET4i3L9zSluSi0onAJjs7unacMuJEOqViw3x0=;
 b=l0MWMy+Jk9RKau+ATHVu1Gjf0+93rg7+J3NSW0DqOtWAfReGrMtz6WRQX140SXoUKP95ZyFFIcnNXox2UuVAjaZTsYQ4BjVt6b8AREoUQ/HsTXlBTj/i0jUeUgbuECKwN2rq/73Fpo+n/b5MBBJWKA+BEacJuAVNjvH37WCFBFAfqrd9jOFsyowvEGjHFv63LVxBs+bG89gfXOf2uap9Hrj1mmJurYLhbRFbF6mZuFemdGVAxNw0MzHC8hnmHJy9jyGQ59AZKsFgxwArLsN3e1X+iWAsc6JwEZOEZ2HnipOaJqbffg349kJrZAeEyYKAGAlDjaBq85FcyQKKOPyT/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eh5YCBET4i3L9zSluSi0onAJjs7unacMuJEOqViw3x0=;
 b=thOvtAqVlpDRJ2621YtrwjgOsluII1lCsBcBi6HNchz6T8RjybY3yTo6+u4gxymhUgGJeCJvsSjvUCzMlS25dj/xHF9g+f+PTyT2KbvuSzgvZa5t6H9Qwkf14Dn5KyMFhzfvstbumuVz2heofDdZb9gd7fHKLmtlnVTdNNW1Vr4=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5675.namprd10.prod.outlook.com (2603:10b6:510:127::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.19; Fri, 5 Nov
 2021 03:42:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 03:42:50 +0000
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        dgilbert@interlog.com, joe@perches.com
Subject: Re: [PATCH v2] scsi: scsi_debug: don't call kcalloc if size arg is
 zero
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v917nu8o.fsf@ca-mkp.ca.oracle.com>
References: <1636056397-13151-1-git-send-email-george.kennedy@oracle.com>
Date:   Thu, 04 Nov 2021 23:42:47 -0400
In-Reply-To: <1636056397-13151-1-git-send-email-george.kennedy@oracle.com>
        (George Kennedy's message of "Thu, 4 Nov 2021 15:06:37 -0500")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0801CA0021.namprd08.prod.outlook.com
 (2603:10b6:803:29::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.40) by SN4PR0801CA0021.namprd08.prod.outlook.com (2603:10b6:803:29::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13 via Frontend Transport; Fri, 5 Nov 2021 03:42:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c9d8d4a-3b0f-48c6-7077-08d9a00e5704
X-MS-TrafficTypeDiagnostic: PH7PR10MB5675:
X-Microsoft-Antispam-PRVS: <PH7PR10MB567592802656CDE0BE41D1DD8E8E9@PH7PR10MB5675.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rSj7ADshIpRHoDHZFyv+ii2E8EB0nd/sWxdvkWNxfNsKeLpO4cx1h8YrShHlrRZrbd9/GKubecuoP+y+gxrOKVhAwXgUY+Tg9crHaMficoY29vZch+t28wSByj+4SzGrfiVZFFICbWkp/ovOKZunRZNM0aFXPG98epQrFbN3y9Lh6Vsm5zOXUC4zuUvU9laeTzaTDP+Mb32/02Gu8CaE+/1aSeCP9Eh36STPkuV7KqEBubM9CCpNAHWrFHJnJqOCN1mSI349+ONGBjV5a8vJ0XkH3Dy3s2VhwLJL31okY7Vng87/oZ3jBAVnZyLoNfhIuqcCuckA4F8rEmSqtopKy6JGizl2ImNWPsgchDv6Evt0Kn9AI4Vv+u92GjN4BMA/qvEjNdagM+OVkMoh1I3qVk5tUIj74eIHUxCwvqeT+MrJJ9ZE5I0EkIdWWfuh8vEmvJVf0uGYu/UMWydstyvIFx7M4Use3H5L0SIs+0lKEuRy0ZSL6OnIXYt7B4pBMSG+5W8v83x2RZX/2/oOoCliCH5nKwc61YYLPM23Pv2zUT6vwAiTQqrZtN34uUKXcBOGbvoXtjDDQnq11+FyFv/VqRCHYWhbqrMkpUDhmocm+5JsSBQHOCKLfT50AG/u6APDJ5Fo2Z4zSZxmBlAjkJZdTo/xTrJOyPvLFZqeaajtaSr6YdZqKHGaEydP3kNRrbxbPoEG1GUAJCiCzPMfCi5BEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(508600001)(4744005)(956004)(38350700002)(55016002)(7696005)(316002)(38100700002)(8936002)(6636002)(4326008)(2906002)(52116002)(5660300002)(6862004)(36916002)(66556008)(66476007)(186003)(66946007)(26005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rIYT53umyK4sn0qagsAMSpR/PZ0ppnkf3WWh1aw4VrDNW0JkcDj4wUseIce5?=
 =?us-ascii?Q?E2cImxgWf2Pj8blJ7YwTRg7HU+mIcRl9mmMV3g3hM35N7MSFnYXSlGjXB4//?=
 =?us-ascii?Q?biDyCcK+Yn5cJsFRWXMwyVr8oG1QrTfWh5fmd3iyo0T0xDB8nnX0IcwB6xm7?=
 =?us-ascii?Q?LUKvVhDrY+3WkKze3vyTHxDOaJAraGsN9kNhFiCeJDV7hG7tLRY/amcHcHT6?=
 =?us-ascii?Q?SXMD5J7FPVcSMTpt98lP02UsZnKzRU4MtEwazHt/AFO0R+6xMPYZQSXzULqG?=
 =?us-ascii?Q?xFGqSCm7iNHarsz6d8PS5OtuteToS5msmS4kYg+9t2U5rnHsuUF9mKdMQcTX?=
 =?us-ascii?Q?69ojSjdDcCA93jD1Vzefc3k5rYsaws9wPAXX0Z1/f/8j4ZRr7veKjPWX7MlW?=
 =?us-ascii?Q?HPeSvyziCk8YMIbmlv2ShyLGbUNPAQ/ppFrVk/mUxfJmVZSu9ciRmq9C1/m2?=
 =?us-ascii?Q?/bjrzQJwa+TgJTEWqh2Cvz0CearuKP2zUFBOlqd1eaN257QZzvJwSILaQqS6?=
 =?us-ascii?Q?uAf1jFMgevWEGWvw1neqYHdwEWfERr7nS3L/GtWRnB8LZHx05YQ8OZKS0yhu?=
 =?us-ascii?Q?5/akVECKKSHQ0nbFIqe11xcmgzIPeZbMqux5kwwsXZww5p7NvdkadoP4adi8?=
 =?us-ascii?Q?WRsNINWgY9dqlTZIvZiexH/4UZyFUUzRxQe1FyVCPKsEe1LF0l+8+yIr2d1b?=
 =?us-ascii?Q?yN1+vaB/tvuXctcJrklUUeQjL1oxDXA/kdstBCVcgWHzLly8h6VlUsCeh+kP?=
 =?us-ascii?Q?fNgHUNt0Z5X5uVEPJvZ5pZdlLwK5o2T2Ny/AJt7zYbIj7XLYOfae7x4nZ0MM?=
 =?us-ascii?Q?6CIfl1Pqf5X1TFOc91u8emq7gnxP8TNZMQcaFMxbFCzHokp9eBXYFLpZS+d4?=
 =?us-ascii?Q?cCYNSSbe73c152iF8LgF2EYyWEXc3l/LSuy1TAtkgACcHxbMosCG6LL48273?=
 =?us-ascii?Q?hJw69DtWHAON0C683HuKXpk8ahM1HCRhTmo9LKLp3VuviE3Xg8DSmaOcPvOE?=
 =?us-ascii?Q?jFe7VxaY+Zn77NiFWmrQcQIapKrR82S1h/96ZAhGKI7kYmcgcOG6JuPanCbF?=
 =?us-ascii?Q?TwgUBeg9bPDKTxposay8yua64Q7Mt+sWlNPP5goqtLA862HLoSBDbJGoQjET?=
 =?us-ascii?Q?lxxwgIoprG5E0+ttwX9tlmeY5qoAWV12c1jJPFCGzOIRlMA7Mg0bi82EjXFo?=
 =?us-ascii?Q?IFr/3AGizDnU7jtmhOFyq3aUt+VKibRMunj1LHa24hqG8fVuovyliujSlGnh?=
 =?us-ascii?Q?ecmJiD3yNdN6P1NQjgI9yUv+8d1ZZ5zeJx1hzzGIszw4blK1enpY1kL2zUmZ?=
 =?us-ascii?Q?ajMvu9Ukf0ppVj/u0U4RpTYO0GIR76L8AOoB61ZQ5NRQRQP0J6u0u2+dkqQ0?=
 =?us-ascii?Q?Dc3442a2fwYSaMaZvVRziW6maV40/pBVOjhWDZE6rnWhIcqLnnFCSXhokPoW?=
 =?us-ascii?Q?h76M9K28W+v/rDIc2moqBzAFJ2DcLCBM09bLiXMwNkP7f3GnyCQ8uR0lfpq7?=
 =?us-ascii?Q?NgXdXuladzwq511gmoSgx2b9aoqzhVNTXi0w1G1txLErWHvlaf5ciq64VosE?=
 =?us-ascii?Q?dFdSYYL/wjLu7UnAhVu2Ao8lOyvZSzuO4w3lQ+aILork3QWRvxFFH0A0CH/H?=
 =?us-ascii?Q?TZQMM+y+/LWnvlbwvQRiQxMzLLmZot++iDQ+VK9DNLo/Jv88y4DNjaMCUTZF?=
 =?us-ascii?Q?xlMxHg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c9d8d4a-3b0f-48c6-7077-08d9a00e5704
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 03:42:50.0835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: syRO6SVda+62YuMSfMEKm0J08CJ/hd293s51RFfySSAEmDmhYb5PzvUC/QnSpZZxwOzbmXYlgq1lWrv1sxScYKHqe67JS/p/sN3fhHW48ic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5675
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=586 suspectscore=0
 bulkscore=0 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050018
X-Proofpoint-ORIG-GUID: TIv3ZWlyYkjtjcfljwrmdJREVenhacII
X-Proofpoint-GUID: TIv3ZWlyYkjtjcfljwrmdJREVenhacII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


George,

> If the size arg to kcalloc() is zero, it returns ZERO_SIZE_PTR.
> Because of that, for a following NULL pointer check to work on the
> returned pointer, kcalloc() must not be called with the size arg equal
> to zero. Return early without error before the kcalloc() call if size
> arg is zero.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
