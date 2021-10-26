Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB47BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 04:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C333360EDF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 04:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhJZEQ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 00:16:28 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:44572 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229487AbhJZEQ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 00:16:27 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19Q3b3Gt013759;
        Tue, 26 Oct 2021 04:13:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=0VZknSKbUcRPjPBvdXebGCuV2NTImUONk3hmqJIYbtU=;
 b=OxnqaSMqdsHR5HnVzvOp3wXwunLFPsVxd4sswVQOWlUZITzh6PoW/ONlu4xqr7YYMzZF
 /1PprOEVIOvnQhb8/yLQUsJ9N8jx+N1LWAxtGZHF2YVcf8EO5JWa3xJGlyWUnfylVn9C
 xRiHBsQIm9IUBRnxHIPOo/sNoFVOGhol01kFGz1N6mLxuVow6txABWb34Wbg2g/bxilW
 uhgPgmXiDDRbHBDPDE0LFhN8AAtdv+oBHkAZjvOb/R2Ln/jsrn/ckEph801R4EqTWW62
 0Za+BcTvVVkLzlit2ShK2CGJqk6gaG1o2Qks3yw390vco7pwLu8aTss82eL/Qrv2F90w Tw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fhs1qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Oct 2021 04:13:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19Q4Bb4V129903;
        Tue, 26 Oct 2021 04:13:57 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by aserp3020.oracle.com with ESMTP id 3bx4gacavm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Oct 2021 04:13:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y3TBiZbCDx79M2JJUZneJbpVsVJ5PQ+eAg9XuY2aaNAq6QvBsYc/ClxtqfLHm+CXOAP5l1FXe/6DJFWNYkTRZtOLTc5twsb7l0PzKH2/eu2EfrDzUK9fG0enWY5MnenW57XkEJUSQV/ad3hKgggbaYAfcy1ZG+2+YYGLnQDvujdG2nB0+D8+lov16obibX1uMYvV0OzYtq6/alFLBQ57k4ZlxN6mrbfmfggM1uYjkvX4tdiJDbV0PHUkqOizBOj5OUYrxbo8tYuDdK6n8NiVfyUSYPIwDtlO14eJKFF4sSUDtoGHrS6PdStHcIseU3c5ICsYslotIJXaLD/Z+YP+Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0VZknSKbUcRPjPBvdXebGCuV2NTImUONk3hmqJIYbtU=;
 b=f6u53wj+NNLyJ9b2C0kYmcNsBI27VTBzOTvXe0hXBWiqi9d09wrrzfGnDg2pFeQLZ6h9IcloWERtEof/QxawXllGmnolUOlWba13jKKHoxCuID2O5u5CL+L1mwyI8iHLc2rOpDeKLRsIqCXvZhRfTzK+WKZphTC1ixRgaxSEr/e5+1votT8wBCGmA5b69E2IS07+j5LGVDZ/CeuYOKMc5Wnkl5ejYFeCoeWan/F/PPSiEuk9dUg2dVJc/alNFXy8nlXM4PqCsdR0VyZA3i4gWfKNN1BHnUoSbWpUcBnWxnw+JwoxTXr8oV4uOSU6O5NdbdWp4Fo0h+0Dc4fyn+o91A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0VZknSKbUcRPjPBvdXebGCuV2NTImUONk3hmqJIYbtU=;
 b=xKlrR+l6HzUpO+vYKByuQoteLkIA1a7X/GEUgew3pX9pKi7MlSFrwtd+ub9PmTgc54eQOnXgODn069R0uBCADqauNFvbgUEUv8F9wpfjMBmDjkJFQao6vPytuI3y1UIqtrf+oX0puxBiTW9Xyr+eoMtrQJ+up0IwdwOQ/zZzBO8=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4517.namprd10.prod.outlook.com (2603:10b6:510:36::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 04:13:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 04:13:55 +0000
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com,
        axboe@kernel.dk, alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: revert HPB support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmrs2zln.fsf@ca-mkp.ca.oracle.com>
References: <20211022062011.1262184-1-hch@lst.de>
        <4199e780-32e5-a1ce-65ba-85e0b7a3eda5@acm.org>
        <YXb2uO55W33/6ZFq@kroah.com>
Date:   Tue, 26 Oct 2021 00:13:46 -0400
In-Reply-To: <YXb2uO55W33/6ZFq@kroah.com> (Greg Kroah-Hartman's message of
        "Mon, 25 Oct 2021 20:26:00 +0200")
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0036.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:10a::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.47) by TYBP286CA0036.JPNP286.PROD.OUTLOOK.COM (2603:1096:404:10a::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Tue, 26 Oct 2021 04:13:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1280eeca-f9b3-485d-2e26-08d9983706eb
X-MS-TrafficTypeDiagnostic: PH0PR10MB4517:
X-Microsoft-Antispam-PRVS: <PH0PR10MB4517F62A50CF51714CDB7D1B8E849@PH0PR10MB4517.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sUGQzZVz9PWOevnpX5PZWlh1SQAl8ZHaKcectB/rKLJwmAHAp6TA8RVed2YGeP6mnSBrCOdjVUwrIv1gZNUAMJrASEnbfNs48QYKf4JQ9v693AWzy2IOr4XClhX99cPGyZNaMv7GFtqP4xVgBJqo5450TPLB0wBlF3+TDJSjTIkpxZQqyKiMKW7H+5pufqs6eOqOOiEYnfmIYk4tsKYAA0i1+KXieFrBbg8yVR8qYRFQd5aRVo/VV8ANPh5CAZw8e4vhhcjFXp0s4JR4I41+MEU1wxctzQv3GLgalE6S4kPs92ATFkT4SSmr015kGAaM9VeWZCEZSWJs4gLQajf1inUvbmYvKtbTA/y6dQ/BBHU9RzQe3+dEcniVXouz1Je+pXsl92iM9N1TAcMJz56XtbtEZH3zXqZrqqbe76jGlgOkzel1aztL29UaNk493xQIxRlARIzvMCk8ws2i7GUEdv28r0lml0yHHdnFBy/a1hcwbpdiJYJiNMD8fZUIz1/ooGei2vd+6+KOYlkzSvCiZ1ruZmWsUC2Sb5pI7yrvXpZyTcBASmkZ1q5gLn3sI1hkrDUMLg2DmDGhykEhaIOFMpB78+xoaX39oRMTdooQOrNt1GMJz1XzDp64PFBE7jdN/AtRstZYypY/lu3Ty8uuXLKN59/YVXDd88dhIMR0RY/oqYg3etVNxMYeU1O0304mUeSm9IRk8MTu4fLxU2gQkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(66476007)(66556008)(38350700002)(36916002)(316002)(7696005)(38100700002)(86362001)(2906002)(54906003)(4326008)(66946007)(8936002)(26005)(6916009)(508600001)(6666004)(956004)(186003)(5660300002)(8676002)(55016002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/ZaHGRItC3Kn0k7hofGovXEN6tABAINHksrQ5SYtmTxRk7bCLBJ+bM7LGr+8?=
 =?us-ascii?Q?SuB3YcErlbyETi2zzKai5o4MlDWczIUszV4y2wci0hu34LzlcofdYazYP8wD?=
 =?us-ascii?Q?fedFuxKKqxGjbamKDO1e2vNNzEFq9AO5P+GcSqOOYnXkHKDsrmKsONBjTasg?=
 =?us-ascii?Q?PHc7smasH54BV304P16eMQIe8A8OPFLR+xOoFzAEN9fJqCbVto/c45WiNrUz?=
 =?us-ascii?Q?PtBIdBhuFLn8XOS+MTpKzZIjLxDene+Z5aJAko6popxR9OZ7SjzyLfzzmEvp?=
 =?us-ascii?Q?BtZFP2CTskV7IZQgBdDNKVmabBionDmpruPci784EvT9omrdfDYutYj3QR5y?=
 =?us-ascii?Q?6mvvJpYN+IyJf2V8R5YiwVWesk1yL/Hlh6rlRBUfIE9ncFML4z3TvizZopMo?=
 =?us-ascii?Q?sVHuWBq1pYQEoW9RVglaeuquNO45/L4TDYaBcyaCeiDhgT5UJmM+dApuOwiS?=
 =?us-ascii?Q?fpeWftPqMkIEISDlyN3YTIiQuiKEXDShnqjK2tTz4lh4Ek82lc8VqiMpqbk5?=
 =?us-ascii?Q?FHfIAnAIC2Sn9YyczxWcBxmimMIX6rtUyZr7SIAS0JU24KUn5ePzsr7adcKy?=
 =?us-ascii?Q?dalj+OZrOWpiMABAv9Oql7C1ysyubFBRJBBtrHUC56O34oo8l0RheORDUaVE?=
 =?us-ascii?Q?w7clY0ZHzS0croP6dH1zQB/W3I91PGv5wvk3B5D6xgV+gTNSE4Lu4bYR1Uec?=
 =?us-ascii?Q?Vpg/beZHce5qljI7a+NuU0C0io3dlJkwKXFEeJSFBbHwHLu7tTmT9ZMg6Bmj?=
 =?us-ascii?Q?l0E4ZM6c/Z2m1tAoRi9bFFTQHzeqbEdt4Ih3DHNhIwMsQiV17e11aHdMd6CP?=
 =?us-ascii?Q?iT7lynp695wqYmixGSgF7OxVnId2R+vJXFncrizxrsTTkoQeEoVIgQUv+uGX?=
 =?us-ascii?Q?bQcd+yj6s/4jhXr8FGWauthhf6M6x+Y56YDN4xuRgLvihaAyrv9IweYRj/SM?=
 =?us-ascii?Q?b212T3Xh0jAyZ3KyPkRuwkW08PA3So4/VZYo0WPHCcyRq6N7BIQFbGxzPO8J?=
 =?us-ascii?Q?VhJIzCm2L9WsiXKT4KxQokNOMllpe1YJEwoglrQ96fAs3jZiouh4OieWfxrI?=
 =?us-ascii?Q?3s4DH3JJYB4vhCkJ/L2GHq4akp5TunWphSsTIWIs+3NejLQg/u9zar+H5wcX?=
 =?us-ascii?Q?8+vs0bPKwvnDtlruSTWsLEccQ336Nb9j3Ozf0IVrbzlKAcFe/sapaLgHehGx?=
 =?us-ascii?Q?kE+mjqIwAEYVN5qToEr9FgEVRynoQ9ZFlm7OgkM1K27eY3Jxh42/VXTUQ+2Z?=
 =?us-ascii?Q?1ZEy0CgJ3bGKr4Qdotkz9jXXYM+7hyezio2B31AnxTUJGCjJ1S8VemHd1UER?=
 =?us-ascii?Q?X8PzS1sTOzE8bzQYydlW1M8MpnCjer5ZsN66VxACcH4x74lE62FppsBAwgwp?=
 =?us-ascii?Q?h4+8IrbWze3QAyeQGl/uxsUnDB7WT1T16LLgEbVkUyuDLteAREC6d1n6RaEo?=
 =?us-ascii?Q?ybGbzODpR04sqw8fNMarTeQpgajXhYeuoVJHobfDZFTcKIhUs7ljHcnGqEoy?=
 =?us-ascii?Q?ZCN3Vq+ofKvF6mWo9nTAuVc/vkta+w5bf3n0QPJ2/wvwYW8U+0kuhR0lBxsO?=
 =?us-ascii?Q?NNdTg4i+j5QVgiCw+YoIFqHeJ/c8ugbkhV8XC9xj1Bm9NREFEYHquq1WQz2j?=
 =?us-ascii?Q?ic/riNXxdhmTfYZWDFZt6FoiLrSAnANM72FEX4ZsSSIE8XiDAzlwfdG1Eqnb?=
 =?us-ascii?Q?eUjAUg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1280eeca-f9b3-485d-2e26-08d9983706eb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 04:13:55.8196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WTuUzkaokxbukQ7DHe7peatZ14u96OtyMKwfYIYFd19CaLv9Sx/JuYD8fQRTjX2vxL91XVm28z+KNJEJ8O1YlLXnTr8p+1q74eiJqYU0RRc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4517
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10148 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=993
 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110260021
X-Proofpoint-GUID: TfJ6FTyi-OAJYBRrhVgipjyosTEuS90d
X-Proofpoint-ORIG-GUID: TfJ6FTyi-OAJYBRrhVgipjyosTEuS90d
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Greg,

> Under this line of reasoning, why would upstream take the code at all?
>
> {sigh}

Sigh indeed.

> Is there a link to where the HPB developer said they would look into
> this?  Perhaps until that happens this should be marked as BROKEN?

I say we just mark it broken for now.

-- 
Martin K. Petersen	Oracle Linux Engineering
