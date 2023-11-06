Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E073AC4167B
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Nov 2023 11:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbjKFLI7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Nov 2023 06:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbjKFLI6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2023 06:08:58 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E36BB
        for <linux-scsi@vger.kernel.org>; Mon,  6 Nov 2023 03:08:54 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6B8ZSI028806;
        Mon, 6 Nov 2023 11:08:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=E2TrJGSKHppWn6rhrzs7Fq5tEe7p60ZtQMUcbqp32VE=;
 b=qekCXy0yqJfEedHPBi6UFgAfisNV4a8BFQybtqQ9QsTnTbslRpIUrZgt3KaRJ4zbVLl/
 x5f6B/kfjuthPAQ3wTe0j5eHtA8PcsqAo7AXR9l3pMrQ2oHSrFQp9HhuZmouypxcbZTL
 NOMBbCoNvQh7MEfnwpDXZ6VAS8+vrMB9o84nfwr9eCcnVaOcigMvGtR1YuW0Go3QXRi2
 tIrKNhiWjVnalnviSoyyBv3PbId4OhQjjdI1kBnHFti7P6zIBWPamP5k7ay9OF2Qm7to
 gh9jq0V2iHhp6RpPhCHd99WCu7uvow9feINKprihQK/kitUKX5HcBtNYmACJMuzWUvqc nw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5ccdtp9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 11:08:35 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6A02ZO020761;
        Mon, 6 Nov 2023 11:08:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdb48n6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 11:08:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jIVoxdBLZqoqikVpCeboEa54vJ6iVDl4srVVnoLGJI00VZo29kgzUg/TWyOs6X/0ioC6753uUkTidLi50bn13B198arprSNxoGnFmadI7T6HVYOHfhy+yQlZIVDKomgNIWOIzW0Xse4bxTpUYO0KCIoI41CmWTczhboanw3giBmNTwgmkfjfmbEZs7v+4G8SGvQCBXIKYNCwGlZjOUDlzONoGJTX/Mnly1SN6q7KK7geHoR09mAwxcOjqjJvbpCC5d8YNF4GKyvCFRtf+ArsnENMrKCzvfIuGbI3voGsM3+WpMmfdCayks7q78oKmez+i4dxknf2tAMQzL6Zr2BeVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E2TrJGSKHppWn6rhrzs7Fq5tEe7p60ZtQMUcbqp32VE=;
 b=JoF68Kx+qd4r6sfBNdchZroYF5OioqmzBN3GAmcWPlq4lZIbnxjhOfDwpPePV1FT01eLGnZUY8YLqzbdoGjk2D9EIyxEybro/2jqKdml8o+AWyhwc4RxpDyU/+bAqXs2oCsrEKQekCtzDEJHzZ8MdKgnNGqTHfXRF9dKAkye28NXtcQEz2saDrVbXagHmpUXtGo94jksE+JQdm/IhqB5ckkQr8ZYFCgJXNRTvvGF8RrKUzELmjijKbY2KpjlZQJuEEUjG+6t/4nJs2qG2NFDePH4dAbtzpDhbBLG/T+aufXXYiH/ErsQpW9S+DjHuMTSQisNjhtcn/LJs6nFg2hg/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2TrJGSKHppWn6rhrzs7Fq5tEe7p60ZtQMUcbqp32VE=;
 b=LSvsTOXaaRKJTOxnDNw5VQQ3EZz9dU2+4Unwrm41u6jagyMdahGA+wyo+nvpoi6lb4M3Q140gaSbGNKm/ybJ+kZjGZzG5b30ipp7E+Hz/BCNwyOegfxqkwcPWXV6rSF9yjQAJIAZlGko9gWivYiy/joSRZGLpSZ67vTUlJ2gNvU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4591.namprd10.prod.outlook.com (2603:10b6:a03:2af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 11:08:16 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::2c06:9358:c246:b366]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::2c06:9358:c246:b366%2]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 11:08:16 +0000
Message-ID: <6f36e52c-e77c-0695-ff33-c4f737430c13@oracle.com>
Date:   Mon, 6 Nov 2023 11:08:12 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] scsi: mvsas: Try to enable MSI
To:     Marek Vasut <marex@denx.de>, linux-scsi@vger.kernel.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>
References: <20231105183712.26520-1-marex@denx.de>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20231105183712.26520-1-marex@denx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR09CA0005.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4591:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d4fd0ea-3224-45f1-e785-08dbdeb8acc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eDUBsBhkBfEO14flQzw4B5CUUvGUm/dfw7FP9g++6nSwehvFycogZqZFYsH4L65zM3/J96YbqKpdVf1xRrQvBp+XOYmZyQCiU6xjQK4oWLMnz0/xDW2PXyE874takECkdzVWyLUs4NlORFxZvEfT2d9aykMS0MJhgXjT+XiRHf1Tn+WgBAcalEVWo/CDx9QtQ9VnJ5rJU8aV09MrO4xWKa7FRBXfs8AV0Dqrg0tu2df8uZEBlUqtI7RFglsyaYx0kxIoy7NkNzIYGs9B/G8/clCyyQJ26NgKEwPxeNW8ORgfwx6N6OUCmPbFOeW+Fv6Sz0FkE6WjfkYRKlDikiR8YkUrEoBD8bsjJLopSvyQ6MashFA5TYkUKuOviBimRDHHO5av4OGbf6PhgBjIVgfhw/Ypf85fm798LcSGqzdTg8eFzVKidZSCDyog6PfWx6GxwWugzYHaAb9B+i+xw8IHh1/NlsZHzqUSn+xVcyvqfXnyjTCMOOOgSmoaXcPG27EdpdyhI6v0pooK6pBz+7MPT5AWkBMr1r64CfsTzMr9yrTKiAqJ3xTBDpUydpr2PUx6JWQk60FTYJ6soywbP9/MWJQ3L3t7Jq4EoOSPneTPZ9jJ+5qBidRhh7pmLUuezEXVItgJvzGEpfx7dR2uM/zXWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(366004)(136003)(376002)(346002)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(478600001)(41300700001)(6506007)(36916002)(2616005)(6486002)(6512007)(6666004)(316002)(83380400001)(8676002)(8936002)(4326008)(5660300002)(26005)(66476007)(54906003)(66556008)(66946007)(38100700002)(2906002)(31686004)(86362001)(31696002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFdNWlEzdENsQ2ZhalRlWHd2MVdCYk5HUU10MmE2dGRsNUhXSGdtWkRkNW5D?=
 =?utf-8?B?Z0E2QVZOOHBXaXVTNHpVUE9LU3RPTjZtNFhTMGUrdVY4OWIxK3psa0hMY29K?=
 =?utf-8?B?Y2dXVVVMRTJ1SW1NZmpoWEJxcVNhWmEzWEtuT3JpYW1IZm43R3luc29sWHo3?=
 =?utf-8?B?RURiOEV6WFpKUmhPbWdNWmplK1VYS2tWVFROSWV3VlRDbzltTjFicG9PTDBW?=
 =?utf-8?B?bGJoakVxOGZkZDdLYWRUeWg3R3F2ZzRUQUFXWlI0cDNueDBUTFZ6ZnpTRllj?=
 =?utf-8?B?ajRsUWxJM1VDZ3drd0tkQ2MwZnhoTDB1Q2hKa3pwcU4yUFhQR1hDczdpb3NV?=
 =?utf-8?B?Ni9jNTl4MmFiR2hJdGQvTldMdWs0ZmtOTE5JR1hlUFpFNVg2NG95NjFUMkJv?=
 =?utf-8?B?a1NQaXpHTThxVGdXdDRaOU02Ukw3RDFoMElYdVF5amoyL0orVk5tZUlkdFNk?=
 =?utf-8?B?c3FHSGlJTGJDd0dhNnUrVEd2dHVPZHdBVS80blcwRzN6N2V1YmdXYWk1OWk4?=
 =?utf-8?B?Ump1Y3M5TnYxdm1uMWlFK0J1TUUvanpBczBzU2UvSDJyVzl3dFZrZ1cyVXRB?=
 =?utf-8?B?TEk2RGlOUmJIU09qUFBLckJjRnMzSHdob3BYelVUM2lnL1NWV0dYVG4yTWlq?=
 =?utf-8?B?MEJYOThvTUR0WE0yaDgzRXVXVTNwZlpURk5iUUpLUjk0QllpYjlHRGdDZkoy?=
 =?utf-8?B?TElpVWE0a2xzdU1oWDlQeVdHZ2pmUFk5SWZCRDRtQ0loZllTdHFHeVlTaGtv?=
 =?utf-8?B?b05FMURYVHVVSXNUUmVjM1VqeTRFdU5xaFFCemJlMUlHUzVtWWdXMjFGVHcv?=
 =?utf-8?B?VHk0MUh6Zmg5ZU43N3p1d0NrVFdlK2p4dS9vc3FHRDg0NXgyRDBIUjZsMHIv?=
 =?utf-8?B?dktibkRmWDRuc2xDcDI4dkh5QkF6ZVR0V3JTZlYzckE4bjVGK0N0MHUrajRx?=
 =?utf-8?B?bk1wZ2ZIK3BOdXNmWjQrUlRBTnk3UVpqLzdmc0hYTXh5UDRVOHlkdmRIeWhY?=
 =?utf-8?B?OERiTlR6SzNKb0Izb0RFOVd1Qzd5TVBmUmNGMEhtRUNNOXZwcmMvazFqTnlT?=
 =?utf-8?B?d29zZitrZTk3blhrRjZiMXpyaU9qRGRjWnVWODI2QzVHeHFON05kaFUycDNC?=
 =?utf-8?B?SjgxekI1azFvc0RVd3dwUEtIQnJnQXFIRk5nbkhFaElVYXFLQ1BFTWNXdHEw?=
 =?utf-8?B?UmQ2WjdsQ3NISVBIK1lya1NIZXkzb01sYVFxRzB6cGhyQ2FKL01kLzE0aXBn?=
 =?utf-8?B?bVg3T1M1b1Z0TnpmUnJ1YzF5dUJLSzN0RlJHT2kvQ0MwbFROS3J0eDY1YmRE?=
 =?utf-8?B?bmZoODk2Wkl2bVMwdXlQcUFlbjdOaTVmR0FRcllWUHF6dkJJT2dsVFp0SG53?=
 =?utf-8?B?RVI1SGNnRjNoWGxJeFIvQWFtd0JKWC9HOEdSTVJjSEI1UE1TRXV3eDg5T3J5?=
 =?utf-8?B?dGxMNzRuY1A5MFJpZkgxelQraTY4S3lzcktsOURrU2dLNnY4UENGMlFxaFhE?=
 =?utf-8?B?Z0h6UElScWxXaURLUU9QMVExdXB4MjlIOFlWd0tFZkg5UFBwYTZRTXFZbzdn?=
 =?utf-8?B?OHg5NGM2TXBKRzQvZUVNSWNYMFpzVGFSL1c5L0RSbU5OanlaOXFsOWNoaXQ4?=
 =?utf-8?B?TVE0UDFpNDRNZkZjNE8rbXFBbWQvcXdDL3Bna2VtTXJNcTJmSEFVaWxHY3l3?=
 =?utf-8?B?L3ZGeUNWSXd1Yk9TeGhXQ2Nad0JadFJVZTIwZWFiN1d2YW1kNHRTYWhESFE1?=
 =?utf-8?B?aGlkSUJPeW1MNXZ3VmlHS0JDQ3BOT01KMkVCZjBUY0xSUGlOenF4NEdUV2Fp?=
 =?utf-8?B?Q1htckpYTFE0cDhya3NpR1hrZHJDcGM4Y2xIOHVwb1IveUhMK2JDYWh6eGRY?=
 =?utf-8?B?L1NQM0hVYzJsUlJ5Q05PS0gwSDdVMVRRTTArME9NdkF1WTdJZ0RsN2hNZEFi?=
 =?utf-8?B?WFRVQVJXbVhKMnlEYkM4ZEh5Tm9ldkEvUVRFS0lqM3c5Q0tIYzlDTmNTcXA1?=
 =?utf-8?B?WGp5ZWhpcU5JMGFiOUtjUlp5dTVuV3c2UGk1R1RlcUJoNVp3ZWxadlhQbXdJ?=
 =?utf-8?B?SXRoWjZ2ZzVXNjRHWkNDM0hydE0vcUJCOEdjbktRZ25yQ1l2d2FZZmk4MEl4?=
 =?utf-8?Q?KsB8i6Ll8zMfAx4kfmkgmLp1u?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: N8EWSLxK81OtyyD8BTyMAJvuz5bW9GkmIMakpPnc12uZ8IdkDfOUe1F4dx+RMoAhmZ9gweobg6AMiXylSnYFL9Vh4m/yusKt7jUs2XfzMlYfDDvKK+oPJqaDKSzobNjZbXHpA87cdgGAnWGXW5QHholndDZV01m0gABHDehn2rNGw6TDs9eVNH8LwNnOiKFUugGN/IH9X9+LYwvzt9ztTjzrIfkq609J6NkODkXCXMEWSTlhm3bdPFWXsDu+7T1Du8mxmzH1KWD/buC9pJHBBSCByYSSZ7kaDidPODCfoaWvMDudBVPf8Aow/rzAx/Ieh9mgVTvlkC2l2DK5wzbudG2w4dCJ0DBrcSkiAL1j6ik7L78m3j1vvf7eVGG6Htulb5TEZJgr1EcO5Wvorvuf5nJZjVVyJZBNYOFWLFiI4h7bat8z5EzXg/RFevik5nmyJF6ilAuRt3t9C7+kmGY6u1BUtg2KV/P44lI4BvNtlkk22iy4GXD3jcxtXPQ7qfT3Zi4Aax+7N4pcF6zJjG5hyb2F5T9zBPlclRoVkhLGo6IP3OIb7h0irxzSUxq6rVP0jFSnNyiihG1lQpkN9hhLoabUSZ5wbpTkA+GYwSbMlbsneoXnPq5wSYni3CPRqZsS2sHY7KnEnEc4MaB8j+t6uGGUrrg0s+QFUZ0fcIWJT4ww9XMSsrn8T6+9OVooXxoyElBFFGDKbetBqBpwfs4O1xG1PN+9FpGLCt1XOyMmTrb+flIKPZ/QsUXP2xnH4XDiNnig+X1wk3GMAgFyxsilNHRht4NDjm2qOUJMGazlMkaPIZ3BOfpuxpGa/vMr17oDSMeXdXA+3wPNvR2YieIEiHxrH6GSO3Mzf7UpNJYQ8piIk4spIKtliAH6vt8UjjVmqF+EinYEZVFfQr2shPMqZA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d4fd0ea-3224-45f1-e785-08dbdeb8acc9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 11:08:15.9326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CM9xUmwkNn0Iyo7VCkbqu7nBOG6y/R5xEzankL4aqoL+CubHffOFZnLjlgHXW5MiOAKJAlfKIWz1lUDzRrLTHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4591
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_09,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060093
X-Proofpoint-ORIG-GUID: C3_nO2NweIkiYUMuuPSb4kth57geKInO
X-Proofpoint-GUID: C3_nO2NweIkiYUMuuPSb4kth57geKInO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> ---
> Note that the "PCI-E x0, Bandwidth Usage: UnKnown Gbps" is due to QEMU
>       vfio-pci VT-d passthrough, for some reason this is what it reports.
>       The issue with PCI MSI happens on real hardware too, this vfio/VT-d
>       is just debugging convenience.
> Note that this would be nice to have in stable series, but I'm reluctant
>       to ask for that in order to avoid breaking other peoples' machines.
>       Maybe a default-off kernel parameter for the mvsas module would be
>       acceptable for stable?
> ---
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Jason Yan <yanaijie@huawei.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> ---
> V2: - Limit the MSI enablement to OCZ devices only
> ---
>   drivers/scsi/mvsas/mv_init.c | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
> 
> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
> index 43ebb331e2167..d3b1cee6b3252 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -571,6 +571,17 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
>   	if (rc)
>   		goto err_out_shost;
> +
> +	/* Try to enable MSI, this is needed at least on OCZ RevoDrive 3 X2 */
> +	if (pdev->vendor == PCI_VENDOR_ID_OCZ) {

PCI_VENDOR_ID_OCZ means 9485. So how about enable MSI for all PCI device 
IDs which use that, which is all OCZ and MARVELL_EXT? I could not get my 
hands on a datasheet for that SoC (could you?), but since all previous 
generations supported MSI, I think that it's a safe bet.

Then, if we do that, instead of repeating this same vendor check, how 
about add a new member to mvs_chip_info to flag whether we need to try 
MSI? For example, it could be mvs_chip_info.use_msi .

> +		rc = pci_enable_msi(mvi->pdev);
> +		if (rc) {
> +			dev_err(&mvi->pdev->dev,
> +				"mvsas: Failed to enable MSI for OCZ device, attached drives may not be detected. rc=%d\n",
> +				rc);

We should fail to load the driver in this case.

> +		}
> +	}
> +
>   	rc = request_irq(pdev->irq, irq_handler, IRQF_SHARED,
>   		DRV_NAME, SHOST_TO_SAS_HA(shost));
>   	if (rc)
> @@ -583,6 +594,9 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	return 0;
>   
>   err_not_sas:
> +	if (pdev->vendor == PCI_VENDOR_ID_OCZ)
> +		pci_disable_msi(mvi->pdev);
> +
>   	sas_unregister_ha(SHOST_TO_SAS_HA(shost));
>   err_out_shost:
>   	scsi_remove_host(mvi->shost);
> @@ -607,6 +621,9 @@ static void mvs_pci_remove(struct pci_dev *pdev)
>   	tasklet_kill(&((struct mvs_prv_info *)sha->lldd_ha)->mv_tasklet);
>   #endif
>   
> +	if (pdev->vendor == PCI_VENDOR_ID_OCZ)
> +		pci_disable_msi(mvi->pdev);
> +
>   	sas_unregister_ha(sha);
>   	sas_remove_host(mvi->shost);
>   

