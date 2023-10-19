Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FFF0CDB465
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Oct 2023 20:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346036AbjJSUal (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Oct 2023 16:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjJSUak (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2023 16:30:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6AA116
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2023 13:30:34 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39JKT74j024693;
        Thu, 19 Oct 2023 20:30:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Pf/sVm2mRHMCJN/57DKblFFT+vBDMWTpdKqo7cmes9A=;
 b=EuMA646/VR+FwiwjR/e/fn6O0iO6+la+QLHRhQ+36rf8BHT15/QM4s6s5TI2oiO4Ve3I
 i3OcBbIt+5zKVs+MzoBR0mMYdPmo8t+bl7edDbAJ7C3o3W4NEE+5pDhfvGi1wbNjUFBb
 h2UhksAgZDirQGdipap4mkPGzJGjdTRAa738W2NtHeHk6+St/5cuXvDxC+rNzSyBfBOk
 7QpnnpwsIU+tNB1unCAno6pew7XYFOT075rxZS77EZa1AvIXgUHu2apmOonoRybAC/9N
 EhndBxlTJ7rjOiX9VJTxjUn9ayehTeW/UrKQ9gvWfOlAID+u9s/6ZgbV5R3fRiaygBtz Kg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1ckuyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 20:30:25 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39JKPhVm009794;
        Thu, 19 Oct 2023 20:30:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0r6ygv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 20:30:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWtQQ2BgznUewZMu0Uinvxvx2WtjrbYmgRF5mYhh7bZ4A7g5dHvdQJxfwMxPjDrykGafuECkpQatcf4MwRAeTjOfKUAkLzeJDk9Hf26QgjPoAri9dwmKfRbXEcCamyZDAop6XMYcLaqz1IpFmSL8g5gVH1Feo+L6U5LU+30Y6yzNIhWDrm/Uo2AyWdumZUPmzGdXImkL6nNk+QlEWjtNiblV0i8JLFrkqVt5U+u+uFTmTUF1AsWWgzhHmivEdwI/md9P+KR5DSlzlU4spGgW0S9mEgoJoEHScJEk8nsx7ChOhQOBPP+aeD7OyDnfuxY1DNsgqXJxuWu7aktB2f0S7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pf/sVm2mRHMCJN/57DKblFFT+vBDMWTpdKqo7cmes9A=;
 b=mhKf8meulZp2Sa5fWIdwgEg/XuNRtDLcC1v1yRcwD8rGwJqgoiBlLV05+6ZZCGTWLBS3FLOys/Qvr9eL8PPCHoAGgXm+EUxkiG+AKuOmj5yfeVOujm8dIDGQRVf//0JHu/AtANd0dmg2MA9B+5vUgMn3ppUXStDWq2TJ+kdfwqqaNQ46MQ/maPv2VvzgRYXuepAyuOUi3hW9zAzW4QSuDBwfxyLSHuGaj+y8MMqpQlj+O47nrEs1SJEEtTOPWnKtiFGqnKLidzMs4eQ9TVy+CFi1n7tg5G9yZ5IODvU598gDcqMmaXa+GJKuegm/v8+XFN2BNTp4Hm5Kka0dat81Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pf/sVm2mRHMCJN/57DKblFFT+vBDMWTpdKqo7cmes9A=;
 b=tcGWgkwzByAM02ycMWJ+oYzA+M5mF0QMoUxoLDA/SWY3PEz7dSO+7EimGoFWgi9DX2du2qQaWx7FCwYgGbUQUoqatrULnW1m7V+/ApiLtOqTF28kAmY3D3reC98XUI8vwjvjhfshHxK8Z0RbEZdW1biaJGBkeVpvSoKG9WpzZJg=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4188.namprd10.prod.outlook.com (2603:10b6:5:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Thu, 19 Oct
 2023 20:30:23 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6907.022; Thu, 19 Oct 2023
 20:30:23 +0000
Message-ID: <df55e6b2-8da1-4c20-8881-9792775ff392@oracle.com>
Date:   Thu, 19 Oct 2023 15:30:21 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] scsi: set host byte after EH completed
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20231016121542.111501-1-hare@suse.de>
 <20231016121542.111501-6-hare@suse.de>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20231016121542.111501-6-hare@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR05CA0064.namprd05.prod.outlook.com
 (2603:10b6:5:335::33) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: 59e90d9b-cff9-4da5-b4d4-08dbd0e2387f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KzC977a597lSufq0GPEAFusxSHY6VH4M0GGoQP9o95tk+3MfCWukNvJbyShZSUJYt1TDVFWIpW6CGfZCRwWIqVv1td1OU3y+N9yUk8mJFe9XIWQJtz0iAL6vqkbuFUP/5EMmDXjg6hhGECsbg7UCOsSpeeVSqDqd14Ku1Lk9FUPm6CA2RmpjdQ7/TRkP0l/CF6W4FwC/6u/OyRfCX1IA6/Tn6ZRZ1g7Ekx4AKPPT8hzENC8slw8Wq81b6J9DePAP/LDQ4ArezjdFjseQersel0zUFhxPIMUNoQnrBvdomlL+6sX7/AwXfOOG/XM3j+RvYqsFOQRGW0nlhrA3XzslaUQYpBCL0sBODDdhL+YJp3tcGICI9ZKcByGfBVCnkpXa+1zKNiBYWUN45ALPj2LOyu3uyaDfsbNeAQqKvYlCXe1gvIUotnS4oqptJe4m6Y24/nTIj72ahfpFi+4qj7Sa4fvifr0UDZeU+UYBMG7aa0qV7m8T1Z4nqZUAL1kZw7y/EuQecVLbaiQoU2cORJ9bQJsUViLL0hlSOq0+SocyMw86z0wI129oPSS7A/VRW/O+SHWz3B6mkbf6mnHzyDaf+44BmPxweCY2+oQuByORcBt5QJ6hZ4tPYju8VzeEdFP3n8HM8Wx2g7PDbv2rz+ddWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(376002)(366004)(136003)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(41300700001)(5660300002)(2616005)(53546011)(54906003)(8676002)(38100700002)(4326008)(6512007)(6486002)(110136005)(66476007)(6506007)(66946007)(6636002)(86362001)(26005)(66556008)(31696002)(36756003)(8936002)(478600001)(316002)(31686004)(83380400001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tng0dXV3T21DY0dFMG56dEtnbTV5RCtuQ3NtTU92UDlqWlJ2NmsvN3M4Szli?=
 =?utf-8?B?WklSQjFRdEJUWFhpQjdUYmRZYUUzMFVzUkRKM1Ixb0pWVVY3MUFKSGtpV09u?=
 =?utf-8?B?NERwWjhEL0pEZ0tORmwzSUQ4VXlOVi9WU2hjUmxsMktCcUxHMFlUNFBEUitV?=
 =?utf-8?B?U2xTNzhJSTExOGdKMXJyd2RraHpBc01lcGlWZ2R3MExEVDhoUXRqWkw3Qzc5?=
 =?utf-8?B?TlJrTlR3QmliUnd6dE02bDhkTFQxc1o3dklJRHJISFk0MFFCL1BRWkNtUzJn?=
 =?utf-8?B?WWR3a2FtV09Lam5PbngwOVloZCtuWnl0SE0zbGQvd2lNRlcvVkZKcmxWNVlS?=
 =?utf-8?B?Z1dVaU4zekhMU210SStEZFcwemZtQzJNVDIra0VvV3RYN1kxelg4TGRlbmpW?=
 =?utf-8?B?MmR1VDQ0TndNaDA3b1JZMUFOb0szYzhQNXdIakRoZlU2WTJ4SjkvZVJ6SWRF?=
 =?utf-8?B?Vzh2MnVFd3R0RDFYTEJtdUorb2pURVhyUndwd29ZZ0pSSThsMnhyN0x0YVFx?=
 =?utf-8?B?Y2tpM3A4ajNOK3I3SzMxVTZXblUwK1dJVE1vb0Z5aTgzUkM0L2hod3JBbjJi?=
 =?utf-8?B?TlJyR1FOazNWSmJKSXUzK3A2Z0ZBbjU0TW5LVExZNzRmSXVyQ3Q0dm1Db1pB?=
 =?utf-8?B?OUhRQTdmS1F2Z1FYVU5BQ29GVmVkTGt2REczandFSnZmb0hscVQ5MUVSdm12?=
 =?utf-8?B?ZEdtS2crZm1EeVl0cHZmUEpxMHRmUmVyMkFhNnQxZU1yUThrZEFCd3ZuZ1E2?=
 =?utf-8?B?K0MvUVFTTjYxTFJsVkNzNkREYStvZThyV2dhb3ZRN1V5REJ5a0tJcjNWMXVU?=
 =?utf-8?B?VWVNQjcrdU9HUGFWWXhWSmFvdzJna1RpV0RPVTZ3R1BFOS96dUNxVHRwNUVm?=
 =?utf-8?B?d3QwZk9sZ3ZsbnZNVFhUYkVOeTB3MC9sYmQyY3pON1hISU0vREhTQUxPaFF6?=
 =?utf-8?B?QkZqSGpHeThydHBSam1mRVFBUVl2Vzg4bFoyblhlR29OUmVJZk8yN1F2ZlJS?=
 =?utf-8?B?Wm0ycWVRc0ZncUV0WEdWa3dLRGNZSWRTN0kvZmUvNHBYNGllVnNvM2tIMjQw?=
 =?utf-8?B?K0I1MFR5M1p5V0xsZnQvbXhjdTNsWTdKTDZLYWQvMDNxRkxYSVR5Q0FUTGVo?=
 =?utf-8?B?TG5BckVQVHI2RHhtdjU3Z2NNb2pMVWIwY2Q4ZTIzd1ZuaTNmUFhQN29VMHNJ?=
 =?utf-8?B?Z3M2dGdwelZ6ZmgxdVVUTlE1aTZkM0NKZWhrMzJyc25LdDNOQ2R3K2NrMjY5?=
 =?utf-8?B?ZU1uNzg0U2F0c0YwUC9IRHVzMnVZaEJheTg4NUV2WlpoZXV2dXRkN1I3RlJ6?=
 =?utf-8?B?YVQrY0ZRYmY1RSswUTM3V3ZrOUxLVnNMb3lGbTN6QXIyU2FGMkYyM21NNCtN?=
 =?utf-8?B?aTVIYWZkUzNDbWJ5dmNzL29RVzZ3TUFHdlF5Mzc4amlka0Z3SGRzNFo2aElI?=
 =?utf-8?B?NVZLTUY5c0YyNFFQdWpCVGFTV1BUVVFGanFIMzM0a3NoYklUSGRGM3hEelJG?=
 =?utf-8?B?SURXYTJKMWhhSXoveTVQQ0lkckxBUllOQXJtR0NjLzJxSnRjT3BoU2IzYjZK?=
 =?utf-8?B?Q0NDRkpLQ2hZN0Z1ZkQ2Q1pjYjV4dEg2dkJvZXh0Q3lkNkkwdWtSQjZHM3Bw?=
 =?utf-8?B?TzVaT00rVVcvdU8rRE9lTmNCZnVTaE92UnRHdEpDSjdBTEVobDE3N3hxdm9w?=
 =?utf-8?B?dUVybWFRNExKQ0krRmVVWWtRZ3BuelVXMklKWWUvMVFsdzF5ZDRMajB2MUpw?=
 =?utf-8?B?dS9kcHE2dGdBREFtdTRqdVlLRzZlNCsvN21PN2tLTlBZS2wxcC80UWJEMVAy?=
 =?utf-8?B?T1JLYmJuWHpxMm9QZjBFZUhQbXQzUXUzdTdQTlNHWDI2K1BwYURHdWR0d0NX?=
 =?utf-8?B?ejdONDRVOGJ1UDYvc2RiVW00blByTmdpODVOYjdMdG9XQzBORVNKTmhDUTFH?=
 =?utf-8?B?NDBTYUtJWUZJV3M4WGppaVhQQ2VrdWZoL2pmVGxzSCswTU9YaTFqMDlQRjlR?=
 =?utf-8?B?Y29oVkJIbmJwa0R3ZzdpRFRuck5KYmgvdWdpeENKMVRHdXVGeHJYSDZTc3l0?=
 =?utf-8?B?Mld6SVkyR2Fid0NBR2tLUEsyQUR1bGJQOE5TcW43MTY5YWVFelF6UVVmWGFo?=
 =?utf-8?B?UElWdkJFM29USkZ4SVh4eWx2MGV2M0Q4SkRmVHJCdmtCNXVnT0p0cld6UGcw?=
 =?utf-8?B?TEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 13+YlM7odG+QZHVuqJ/ppeLSbTYnYcJ2H6Bu3dDRRnWU9D1CFYSGZb+l0B4D5R5/Zs2f0DSmfLGpnesn4ZfnuaTwJf7sdrQJ+KG8gkegiHMMTKLvhVblnRAGZaeGqZPbbfLGvQpNxdoqf6bI4E2glWN26YkIODWHhprnSoBbilgE4BQvvzcTBRZHFGBnMD2gnmf1X5Tjuc8cqhN+PI0/1GlRsIppuTnxeW54BdspBgU72vcVJu89SZV3ijEdTVcpVvx6sV94xk1O+RN588pyzbTndRtGEtF4kaC3YiKO3os2Q08dz0jRMQmsMajarOZ7RNInyyJL5nN4H/srfN1ThQeoByz4/yAN6HbpTTlv2TGLesW6QBMWpjTKNTM/aLoNuwqK58B5lF+/Q7B+Qh2x/0Ykmyp5TxrfyHasJdt6rYLRbxatZEC6sqTbHXsUt+NFt8MQUR7Dlpf1lKWzTDGTGcqRVum5FZH3GKfi+sgVxZBf7KV1agcYASV9juR6vmKyjQPB2FBH1dnz/cw3EXy8t1xbLR2klyZYBbPLIWUevp8sA11gtNB5V6LC5Hp/l8/kbySfajeOVxyK0yLGUdfJ3yaJ2MdfaQNfoSG9/NWyfmPqx6mMUvd6s4ZXOpSm4uIrKSxqaP5DKcJUuyTb+61POut94XNIHayNpQrvchsFHGufISQ8JWFugPE6Kf2ma48g+dJZDSnXv7roVRSIe0e2/HgUmWcs5VsG5lxlYdZY7HGIkEhFBXXiSpyro8bWogjEolcooddlGpbWpZ5TtDpWVBJ+BmGBgOAw8/QhnZvHZqRKGg7+Yagc6n9fztZQoKNkD9pg6DT3eAbzoMglxjYTv2Rm2UZmC59+QgqRcfh1SvE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59e90d9b-cff9-4da5-b4d4-08dbd0e2387f
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 20:30:23.3174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NK830R/jRZioP4WaPk+T8ZuY+xLTaJBnwoF4btChhZ/A99ys/8+g73qKmnRGJyJxLcz+BTnktEdpAwHYPZF7xtHzAxlJyCtq3qQCaPvrU7w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-19_20,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310190175
X-Proofpoint-ORIG-GUID: m3jm0SsrEnZtCYjoBXmBstvE9AFh1393
X-Proofpoint-GUID: m3jm0SsrEnZtCYjoBXmBstvE9AFh1393
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/16/23 7:15 AM, Hannes Reinecke wrote:
> @@ -1671,7 +1682,8 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
>  			if (rtn == SUCCESS)
>  				list_move_tail(&scmd->eh_entry, &check_list);
>  			else if (rtn == FAST_IO_FAIL)
> -				scsi_eh_finish_cmd(scmd, done_q);
> +				__scsi_eh_finish_cmd(scmd, done_q,
> +						     DID_TRANSPORT_DISRUPTED);
>  			else
>  				/* push back on work queue for further processing */
>  				list_move(&scmd->eh_entry, work_q);
> @@ -1736,8 +1748,9 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
>  			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
>  				if (channel == scmd_channel(scmd)) {
>  					if (rtn == FAST_IO_FAIL)
> -						scsi_eh_finish_cmd(scmd,
> -								   done_q);
> +						__scsi_eh_finish_cmd(scmd,
> +								     done_q,
> +								     DID_TRANSPORT_DISRUPTED);
>  					else
>  						list_move_tail(&scmd->eh_entry,
>  							       &check_list);
> @@ -1780,9 +1793,9 @@ static int scsi_eh_host_reset(struct Scsi_Host *shost,
>  		if (rtn == SUCCESS) {
>  			list_splice_init(work_q, &check_list);
>  		} else if (rtn == FAST_IO_FAIL) {
> -			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
> -					scsi_eh_finish_cmd(scmd, done_q);
> -			}
> +			list_for_each_entry_safe(scmd, next, work_q, eh_entry)
> +				__scsi_eh_finish_cmd(scmd, done_q,
> +						     DID_TRANSPORT_DISRUPTED);
>  		} else {
>  			SCSI_LOG_ERROR_RECOVERY(3,
>  				shost_printk(KERN_INFO, shost,

For FAST_IO_FAIL I think you want to use DID_TRANSPORT_FAILFAST  because when
drivers return that, they normally have hit their fast io fail timer or have
hit a hard transport issue like the port is offline. For example for FC drivers
they do:

err = fc_block_rport(rport);
if (err)
	return err;
 
where fc_block_rport does:

if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
	return FAST_IO_FAIL;

and then for fc_remote_port_chkready we return DID_TRANSPORT_FAILFAST
when FC_RPORT_FAST_FAIL_TIMEDOUT is set.

So using DID_TRANSPORT_FAILFAST would align the return values for that
state.

One question I had is why you added those checks for target and host
reset but not scsi_eh_bus_device_reset because drivers will do something
similar to above where they call fc_block_rport for that callout as
well.


