Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD108C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96A546159A
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbhJEEhY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:37:24 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:14738 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231682AbhJEEhW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 00:37:22 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1952sD3B024351;
        Tue, 5 Oct 2021 04:34:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=OA7EQgxgw3KDFYEjbBN+0yC6PYdFGjNRgD2yJhIQAjo=;
 b=FVLZx8myEL9FsplCc3OggYXp2KrZZZ/QoKuHi8KD/h5jxoBdPAld9HaVppQQG2d3rKWo
 Ur0tQj+GDe0SIC2R/WnZkJw5o9J868fGyLYTVn9D3zrMK323LXrAwru/m2wTfGJGuVs2
 mx0ydRqqR1oK3AbIsE4B5OFmC/Kf8bwJW2A+d2c+XuYfOJNUDOzDaAzZNwJYo+ETXecK
 pSE/8SXOOs9wFUmpSoyinaqi9ywnM7pkt1haIyF78qkWir9PFlcOFG4Eu4z3dPF6svls
 lDwJQ4i8vhIOQmbX+1z552Y+po1Ip+39m/VS4VQOcb6mn0qYuyGcwjVA8yt7XV5lwopd bQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg454chm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1954UJMX054346;
        Tue, 5 Oct 2021 04:34:48 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by aserp3020.oracle.com with ESMTP id 3bev8w4hvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLbomwCUs5TiINXygdTFsAT+oJ1rHhWZfM7DmkhceHzsdFyUJOdsqb2fLV2p2gmt3gxrkrhn0iqVkRd99FKK8nAoP8LuQo1cRgNCMNyLsQOZEz7/Qr7mNlotrhYR9Nczno0pbLtRx+hcEtqTvHMnkQYIVBfh6mJsYqQslnpSzGOe9uDA8/Dl99YAoNOi78aqPRPwbn/YPhPphNtdtZ2QmHTr8qB9dlZaXUKPh33jiyJiHyRgH2tfkwEBcIKuSoKpqTXIxKhP82W5ngwxw0vqLvzStc0Ne5rHrsa9VSlJM3S2NbdUYQmIFFAh9GQi27+moyRyzjt2xSv4GMAuIZqflg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OA7EQgxgw3KDFYEjbBN+0yC6PYdFGjNRgD2yJhIQAjo=;
 b=hIHPZHCT11+mZXsw9xnT3SEi/wMkT3PnkPeZNk5+zTtvUcePBJChVLISGSrQM6J7OYdNbPFA31y9wyqqKOnpwUHj49kJhJ0EseGMgKoM+LqKTkPUq0z94R4y0F0mlteyn0w6t3Awinu7gCpAsNnZXllvvo5t21b6cbXkgZ6NTFXZaQlhB7WZkYHxNwbgXSpmJUoqOaB895whYWIYqReYoS8daqw37+i+eJRszdOr5VfTBWNchReTseTrLHbxRSLEjKlapBIOxwQt49TKqSIBhsLE0tBSJ9riBMYyE0lMoAiitNq98Q34AtikuPGaYtS5u5P+3a3MDFV0KKSs5Qub0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OA7EQgxgw3KDFYEjbBN+0yC6PYdFGjNRgD2yJhIQAjo=;
 b=pCJGnUeFa7eLz3qtr7UXpMcihoqiNi24tHgbC/CaTJCqS+r4GWM/h1be/4mCY7WRs96DNE5rfMDRYvnMLbhe7xojbQ2Pc5ARX+hLxMKejo6lgEtEPgO5fR1Agxnl/cod9Ve5MSxsSxS736FwIpnmryV9EN3KCTEyk0W3EdDXtAs=
Authentication-Results: baidu.com; dkim=none (message not signed)
 header.d=none;baidu.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1950.namprd10.prod.outlook.com (2603:10b6:300:10d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.20; Tue, 5 Oct
 2021 04:34:45 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 04:34:45 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: aic7xxx: Fix a function name in comments
Date:   Tue,  5 Oct 2021 00:34:30 -0400
Message-Id: <163340840529.12126.15832602419143165623.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210925124645.356-1-caihuoqing@baidu.com>
References: <20210925124645.356-1-caihuoqing@baidu.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:806:6e::6) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0001.namprd11.prod.outlook.com (2603:10b6:806:6e::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Tue, 5 Oct 2021 04:34:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97d044bb-b01f-42f6-e43f-08d987b974cc
X-MS-TrafficTypeDiagnostic: MWHPR10MB1950:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1950C180FAC22714933060218EAF9@MWHPR10MB1950.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YtVGIhw3g03TS4zGgoAWtYnE8KKyj05zgHUd3wruYKXxycpmkM8akGDS98oNIWtv61dboD8iXJ04hvR46H5l8xcuHzLWWVcwQPrwiFP8AeBxzOpXtR5m9s4P+IAgVpwhjKnSBbiHKvuaOZyv857+RDpu32AieJh+4q1RkczF28Z//sOINZGI/M5vPRzFq5j6VLMxTzVrAZRRLO7sG7dc2qiHtSEfbWaYLPdvo7SgtpmCKPkFPv5SRCC45afrRX8kM/W/Od61SRFNg7no0jR9jQJKU4CnZxyvtQvoCdpejrDBxKk//vv4W6xkfvCd416kHp+Vj6a4nVT5e4kPHhJ3VwFPJEpOmM+JP+KCVqbsLhoBer36lXOMS4ebxGGIkBPOU+Q5QhrzeJiFSTpVzJRYjFPEgxCv7kRx4+HkAD84C+sSFQlhqmzvgF1XbZ+bCS58k8cEXsyzO5N8RbT5rViwAqXF0KUrXHThyKJeeiwBILoek7HXAPOLyYYw+81VmvyFCG956U9kUT3fkx8g3Y7ZsP3zOSW57IVQiUMo795PjF7JhgNFyKggneqzyAlnVnms0BZmY8PR3xshukNfFk5sNeP0AP+LPZjCrx1djfUvBZovbOA27qJc7p9r69chqENPjEREUqxGFuECZeXTcHrtLEABvl6FRohjNEMeDlrlf+As6izkPsBQYHBYhYS7f6WRzoLMbNB6tx84QeqYF1tXcTM+ZC8B9uj9C7ar0iBSHj2op5vtxIbzPVn8qaRY322BqdTFIoVtzDb7g7/R9yE9UKy+yx0+p7rn3kbJWNu2l4E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(38100700002)(6666004)(956004)(5660300002)(6486002)(36756003)(4744005)(38350700002)(186003)(26005)(8936002)(8676002)(66556008)(66476007)(103116003)(316002)(54906003)(7696005)(86362001)(4326008)(2906002)(966005)(508600001)(6916009)(66946007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Uk02RWliR0tobWdWUzBmeGFrZXlPeGd2ZUk0TTkyK21INmdXbDRVdmF2Qkx0?=
 =?utf-8?B?cmdFZllRODZnTmw0TUQ3OTl4RHBqbkQvZDFWRVp6V0h4NUt3WGNyZWZWS2Jh?=
 =?utf-8?B?bGlMS1phVUM1eFVyN1lORjMzbjcveG1Ndkk2SG9pR2lWYzIybmtKV0d1MkJR?=
 =?utf-8?B?K1JlVXZUQ01oZnNOMnRPMnBQb2wwc0pxVkhMK2lXTGhKVWEyVlZLSDlNNWd0?=
 =?utf-8?B?eG1ubXVaMmJqUFdUbjV1L09JVzZId1czamhrVEMrT1FvZGdZZ0VvZFpjRXl3?=
 =?utf-8?B?WEF4RTdSbE5nRHhPcXVqQ2g0VkpxTnFtbzAvcEhQOGhpYzhzOFJqWXV0NEh1?=
 =?utf-8?B?NCswSzIwSm1Hd0dWVnYwRE8rT2hNSFRDKzZLNTBhMVFkdytjVEk4ODh5K3h6?=
 =?utf-8?B?aVoxc2ZEamVjV0huWi93Zk40RVF2SXdXTjB6dmp2R0V3UE9pZlAwSzlDanR2?=
 =?utf-8?B?WDU3RGU4OGU2WkwwK1RjN2ZVOXpLL2RxL293WFRaWHBaSWJEQVlYblpCK25D?=
 =?utf-8?B?RmZmV1lNSUpGWkpSVm9Eb1RNYzFjdTJtZ3pwcWNtM2pld2REUUhxVXdIZStS?=
 =?utf-8?B?UTVmZnJVY0ZoSTRVcWRMZU5zbi9WU3pVYU51YVh5OHNaQ1pnUHNzL3RKOS9h?=
 =?utf-8?B?N0pFTUl4b3VSWFozMjJLb1dFRVJqb2tJVEhLZS9KUVZTb3gyWTJpanRiYXlu?=
 =?utf-8?B?Nnc2eEdVVWVCZVdrb2dCVzRUKzJySXhvU0wrY1hTYnhEblJnMU15aUJNMXlK?=
 =?utf-8?B?VXdiVDFrV01KWTdQYzk3VVhROGhiOVpsRXNieFBrS2Z0MEJtODZiVnd6eHk1?=
 =?utf-8?B?dWNiOERocEk0VXByWnlkaXR4cWU3bGZrRlYybDV6aFRjTnU0bTR6UzI5YWxH?=
 =?utf-8?B?NjVGVThwR0cwOUlGWnZUa3N2YnA4QzBLV0RqRFl2NTUzZ0hmNFlYNWhEODQ3?=
 =?utf-8?B?UjFySHk1SUEwSExISSs1alFaV0ROOVlUTWdseXRtUFdBV2U5ZzcrUkdMb2Jt?=
 =?utf-8?B?Ukx6SnVabFkzREVHV3ZDazFuMXRxUHdTY0JrOWg0RkIwaWxYZUJhcm1qTW9u?=
 =?utf-8?B?YlhYc3ZDY01pRC9FUUpQRk95emIxUnRPeUF2T1RQWkxMNDNHbU5SSFBCU2JJ?=
 =?utf-8?B?MGZJV00rSkVScjA3UDdQSTZvaFY0My9iR25NaDVMbnhvRDQyRk11MnRGbDJV?=
 =?utf-8?B?RWwzcEowWnFPTGRBODljMVFIUExjYzhwdVV1QVQ1bHBpeEtxOWJHRXBFZlo0?=
 =?utf-8?B?NU80Rjlia2lKRTQvYlVEOEtFUEh6UjJtMUFRSlBDbjY3Zk9mWGJiTDBNQzRK?=
 =?utf-8?B?U0dYbUFIUE8zZFYzMTh5Y0JRMkwrT0toZEJ3bXJWcXN4c1ZvUU9yUlZwNGRE?=
 =?utf-8?B?SWQ5aFZBU0tyQ2R6OE1XVG40QUNENWRKQ2s5N21tNitZaHBTNVNQcUVFaElp?=
 =?utf-8?B?UlBBOXlIWmIzK3dkNk1VTDJpUzFZUlltTUdiazM3SWd4dDgvR1FBeTFlVjBk?=
 =?utf-8?B?UnkxTVNLOUY5NVA0N3lWQkVMSzZkd0cvRWxYS0hPazJ2UzcycHh6UWt0MGZo?=
 =?utf-8?B?eStFMUtObjM4TVFKaHBmYVV2MkkrUWx3aW5pYXgwZVo5TytuMStCMmVRMjM5?=
 =?utf-8?B?dlRyVlN2ZGd6QWZnYkluUmc0ZmNXZFArek9zalN1NEwxclBoQkFsdUlpaDlC?=
 =?utf-8?B?eEtRMTNVbG52VWVjNVNtRExYbXVVeDZLWDdjWlN5bG0vZlVHS3Y4emplNWFG?=
 =?utf-8?Q?YdKFY6yV5z87DXXydXcKYsTd0yZQcjD0+sSOvpG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97d044bb-b01f-42f6-e43f-08d987b974cc
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 04:34:45.1225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V1+jJhIFA9Zbx6yOkTxDa/mmnnrF2u6ZQTLDuqgrqkXWdIGg3RiWX7E8yQaj/+JPoI71kyC/Zy+35Elvd2YiVUK7VIn2uzYcnYbq/1MpJ3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1950
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=956 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050025
X-Proofpoint-GUID: p8GzotvKSQ6d3XVMm1L5VEaBwtcnVEc0
X-Proofpoint-ORIG-GUID: p8GzotvKSQ6d3XVMm1L5VEaBwtcnVEc0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 25 Sep 2021 20:46:44 +0800, Cai Huoqing wrote:

> Use dma_alloc_coherent() instead of pci_alloc_consistent(),
> because only dma_alloc_coherent() is called here.
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: aic7xxx: Fix a function name in comments
      https://git.kernel.org/mkp/scsi/c/9f80eca441a9

-- 
Martin K. Petersen	Oracle Linux Engineering
