Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB96BEB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Jul 2023 16:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbjGRQyz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Jul 2023 12:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjGRQyX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jul 2023 12:54:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFCD199
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2023 09:54:22 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36IGiCSe024138;
        Tue, 18 Jul 2023 16:54:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Ikqvjucf0883/SyiT/hrdnZc1jRxkbJ22kKk7QSIM0A=;
 b=ExdwxvDEaVLn2mppskvsEQKmRMZkjg5kFkI8J+WmrWgKOyJkghMiaAjUuxC+MQF1o6NF
 0cMqzor5I157HkjneYaIRCWTSV20AhU/cCegbo+F/tL1C007kiOE3f1FrtF7ccpvahVd
 xjD8lHnmeKcERboeetDecfQcWCPvdw1DC1JGFrqjulmrMCZzC5itGPK2jMacTR3D99KP
 7cwkX8pmn+9b3R7JctS65J+uOviVBBXEY3oJOA6Eswgf8T3ELFIC09xIBOAJIuGc+62B
 YfmWxwmiOYkYlRMZu98Ityjy77v26ojgwk6/d1yfhMKMtcSZ6HkE4tKMtva5EZO/Z1Ml Hg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run8a5mhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 16:53:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36IGdPob007756;
        Tue, 18 Jul 2023 16:53:58 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw55eh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 16:53:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4Bv8onvybPEWBZyMB1fGbj6CModxA9QQZ/8XPO3QlneesWdk/LDoV6RrAFoG1TdIpK5/ej/gXFrH6nH1Km6uV+uAWylYeL/okbN4mQNjS5scsnizXsRvn/lLyO6dxHj9RBLjMjCj+dVkSmu70MnoaHOAO3UcO8eP/ZtZBjgN11LmvXcfcNcb9xsvBpxw5T6Fso9/rD1LtmFrHYNAMCGKpzi1WSa9DpieujJtQzqo25js0Mk+yfCl3N9gGtKjtv2RFGSOR7VCfMtBPwnZkI6GM+8Gki3kkn0PLbFTuC0+dCiLcNMDBnWRyJi4sdwaAg05AhzMqqWHLhFU5LPXd4Trg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ikqvjucf0883/SyiT/hrdnZc1jRxkbJ22kKk7QSIM0A=;
 b=DsWMRTkr9mEQorgUWFF09bVNDHGQIHjG5YAhB0/aXTY11CnNfhF/2gSoJ9gUsADVLP327ZHNq6UjZBhBeYZ23HJGEKbUkCm+/znm2BGI15Z/mF+YbZkIgMQWHMyzbC6Kcex6E8AGHRzE99yQwIm0ovmNTBVBd04mBMw5nW48FXk3qU5fYKCFqovUGuFcHNBkts3lQc0XBFSoHa9Qp03Gw7RBJOuyQ9ZZ5yFByeuUWaq0MhZmx6rskE/FBwdpkBY5haNs1GaZCCx1L0qHyNDJSYDI12lsO6jVUbUNwK5qfN7NGd8EhrsdUtNzj8DBUCxTEWshmkKlknaywOXSx7Tv0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ikqvjucf0883/SyiT/hrdnZc1jRxkbJ22kKk7QSIM0A=;
 b=m/XL5wbgmGTI4Ba94dezTf5XPZZRG09u/GTK3Kik2JXwkGJ3YCp+0xf5QnykEoIhPVzh+1sNL2GjGw+2PvaldUxJpulKXdzgqdH2/FlpE1E57n1y/0HGZUCh4LMye6QgAUyO4+m03oP1ItTl7r65IZIZoJQj2Zfu5nQXNu/jSeo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MN2PR10MB4190.namprd10.prod.outlook.com (2603:10b6:208:19a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33; Tue, 18 Jul
 2023 16:53:56 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb%7]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 16:53:56 +0000
Message-ID: <84fb3fa5-3062-1c59-93bc-d89ee4104fc8@oracle.com>
Date:   Tue, 18 Jul 2023 17:53:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 15/33] scsi: spi: Fix sshdr use
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-16-michael.christie@oracle.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-16-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MN2PR10MB4190:EE_
X-MS-Office365-Filtering-Correlation-Id: 12bda8cf-6648-48a3-6cbd-08db87af92d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 35PUa26ejVq+Ucq5g8StYo1f5q5bJjs3gLrPP7rcYGHz/mvPjV4HsFaW9FS9hDaK8SZP/KdlE5eYNxNBHTS42h6BbbcI1yQ+Mbwg0SwXzyWhPLNFmUq0EW22BlCRB22/iz4oEWkcXdCMW5HzJiH7QP9Q3KDNYaDoyW4UjVpd/H8B35iHKUEKMYUANf4cZonN5JzoDj3H5oJAfRwQTD2igKceAuYke6MVluZsvvN4Nu71YnplAVq5cfmaVON2JTity17D6IyCpm6/0lMaYJr6ivOOMzMNB1iTCQZPc7UlGEwKt175CJbd0RP/vrENNNHBWVt06lWUUMcP4o1i4+m86R2dcDZiVysGFWT24Y7bHX++ptWK0ZZLQ0dFTk55+/YhLXg+LqP5YeeXvPkRwDBurlTUHLZVp4HK6dDm3qqJOJObDT0A99PeWC9XXcEty5OXt5SGueZzPq24ltFALgQJIUJsHSKUrTnh7iMLWlrYog9R+pLzhGYtaFK81mUdWfLMV+9U0JVE16cOAYZmFukcxIR2vemai9YnswJ1nG8eaJ+Z7E868el1dqBeNGZwgRgzj2L9C1GskohjUoCim6gL1oK3SnQZg/dpNEXRmfqKxxJOxY87q0ECSYz7+qQlLVZbN7x6XSGENesRoAjbIO4+fA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199021)(6486002)(36916002)(6666004)(478600001)(41300700001)(8676002)(8936002)(5660300002)(66476007)(66556008)(66946007)(6512007)(316002)(2616005)(83380400001)(186003)(53546011)(6506007)(26005)(38100700002)(86362001)(31696002)(36756003)(2906002)(4744005)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmhHMU5BWVlmM29FYUZ0bGMyQ3pTQTJlWUpKMVB2WTZxTHczcG9yT1VLQnNM?=
 =?utf-8?B?eXJwdnUvNVU5dTJWUXZlSVQvVkFyTTZ1WjZXN2FMUW93QXBUb2U1MnhOdExn?=
 =?utf-8?B?Wk1yNkJMUmZPUzhVYUk4dEw5Q0tFa0VIQTRPcjhnSnk2a2tQWG9XL2dmMVYz?=
 =?utf-8?B?azQ3NitFek9SeWcxY292Q0VjQ0dqaVZ4a1JoVGZrc0tUeisyR0NGZ2tYUFl1?=
 =?utf-8?B?eVBRQVhIeVVIeDdEcy9GeW44NGx6NEU0YlljRVdKMFYwRXRxdHUyblJFbnVU?=
 =?utf-8?B?NGhWZHNIQ1g3RXFld3l5bXNtQ3ZZWG1QNjVPcUlsOSszY2FHZUNVcFNlajN1?=
 =?utf-8?B?UFViWTVCanBSSVFRNjJHUzd0ZkVsYTJRdTJVSWM1SktZUzFaVy9rRithZkYv?=
 =?utf-8?B?RVhnRCs2bWU4Z0ViZTZTekxldkM5R3hDN0pkb1o5TGFzVWlqMjBDYWZHUlRS?=
 =?utf-8?B?OGw4cWF5VlVYS2Noc3F2SjBEdkQxZVNkcTdlT292WDl4MXZyeCsvRmhrd2dx?=
 =?utf-8?B?TWwzcitpME5GTUEyZzB1SVBoUURxVW9yMHFVUkNLNHFmWlhETExuRDNsbXJP?=
 =?utf-8?B?N0huU3FtQ2hXSzNxNndtOXFCT0F1cnAydEh0ZWNmNlN1MUxVR0tCREJxM2xL?=
 =?utf-8?B?QXF5Qm1qQk9oeDkxMWZFYnhUZjR1Zkk1eElUd1E0KzQwMUtUK3ZRRlJkLzNN?=
 =?utf-8?B?NldZZEtLVGRNL2ZOOG0zT0wvbzNPOG41dmxZcWNud1pmeDBlSXYyRWY5VDRy?=
 =?utf-8?B?RzczV0JQRlF2Yy9RMWVQRXZ6Y29ld2luSFZhb2EyNkVBa2Z3K25ld0JXbDB5?=
 =?utf-8?B?TTRFeXFTd1d5N1dZNUJRUWNSeWIyMkVzTndNZkQyVm9QaWpXOFE5MmthMEV0?=
 =?utf-8?B?anBhU25HMGNoTXlsdkxaNHhJSjFVRCt2am5pRDk2NE4xZUwxOWRwNFhOMmFa?=
 =?utf-8?B?WFovQU0vSE5Mc1FZcnhJempBQ0VBNXQ3bTB2NTlkMHJtQlhTc2tUU1owRVQ2?=
 =?utf-8?B?aHVVQnpYcXFmcDNpVDZsOFcwKzdidkwrTm1SUG1rOVIvTWppNjNoaUprdUNw?=
 =?utf-8?B?MUcwRXVjN0ErbkVPZ3U0UDNyVU1kenJBZ1JzTDUvSm5Ca1BYYTJqaUtyTFd1?=
 =?utf-8?B?MHdCNmJtei9wQmVEeVFkdnE3Uy8wTU41TlBJYmszR2IyaGdCN3k5YXVGNU5L?=
 =?utf-8?B?L3JNd2hyU25GVFQwaTR3WnZwZHY4S3NDZzNBSlJrWmNPU3ZyVkFJVjBGY3cx?=
 =?utf-8?B?Qld2WUszanRrc2JjZzRJVGlLOVRWR2NkWW1VT2NYc0VNRE1abU00QkZMbUNL?=
 =?utf-8?B?MXd3OGtscGw4MGZuQXdlZmYwYVZYNnE1dFRXRjBjdy95ZWU5bnRtRWJmdXB6?=
 =?utf-8?B?NkFKMmhhRkRReFZ2VHdqMXBuaHJTWTFxWlg5TUNKcVpCS3VDeXBTU015dWty?=
 =?utf-8?B?RktqelU2c1V3cFRROSs1Vkczd0hFUG01U002aElDUDVCOWdKcGZJd0c3eEU0?=
 =?utf-8?B?L3BWUFFDNGpKa2VTbDlDeGExMjBUbGlsUktTaEl2UU4wQ0pBNEpwRmNFSFhp?=
 =?utf-8?B?aDlWVitvaktkT1pmU09uV1lNVjFiTS9CV0k3dU1DendBOEh3VCswQS96TmZX?=
 =?utf-8?B?Z1ZzakI3dTg2Q3ZOYkdLYnlNc051RGk4NVYyR0JLNjY0TmRtTHk2YjZjL1Vz?=
 =?utf-8?B?eEZydmJCdUl5YyswK2w1cWE5bUZYTEJ3UlUrNWpMVlhjOEZkMnlUVTlMU1lj?=
 =?utf-8?B?SUNCTnVWams4VXA4aGVxdUtZRWpYL21oMTVsNy9sNGVOT05xOTJIR1R0VlJG?=
 =?utf-8?B?SGFTRGwrSFlXdk5NdVFrRkJ5VDlQM0Z1MzJpaHBvbFBRYWRjVTY4bzRKcVNM?=
 =?utf-8?B?Tko2QjBXTlJOeDZqV3N6WkxkcDRmRjJwRzZxUEpkdWJ2enNNMzhyMU9IdHFU?=
 =?utf-8?B?TWNQbGhMWlZFRU01TGJDcGhVWG5EaTFLYnp0cXFWSEZUenNYdUJXQWk4SzVM?=
 =?utf-8?B?Q3FVWkM3eElqR2RRN3VmaVJFY0V0NTF4QllHamRwL2o4MC9BNlN2bzBRUGI1?=
 =?utf-8?B?eHJpNG83ZGlMVDJGQ1JKeFcyVTgxQkpTMm9GMnNHaEh4WjNoVDhKOFdkUjRE?=
 =?utf-8?Q?1PB37R6kcERCnmyxS1MmrPPE4?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: dFuISsUYi1Wl5oQNlNbEzZvUlXdYpyywMoHLHS/MJTnxf2Fd8vTTpivZC4PzZZFzsKbOIQjIKAb62lYNGMRJkydbblmj2JNPEddCFtDyyXLgxgQFxeprG5Me20mo+Hpqoaq0Dsta6zgkpjylbcubU3jID35ORPF3Fl0XTz1e75ZHlOqzuexk05eid9+ZzO6A6gEKbcELmlLcakQIYEAnkrw7TsBqO4SYQui5nsnScPCvDqQu0gMsHhEMp4MQrCtRdNGwleY74twAT4gD4iCFc1FVVgeQIgNmC2VsZMSxQSpj51JURhiApkp41O0OJAMVyXzF0zYJKfLYUp2HNMm6iPySQHPbpVp/kWpxhoqDEn67YJTjo59iExbP9N9DhLJ2XGXnxlNJJv7h9Cfy4Wq73IUvcs/PAOCOrMkDKtiv1w/g8Ieh8fd0a31bp9CyBJaPA9TIzISWftVVJ64V88jD9NGOeXGbaxkZeEMBo1yo3p0EMOQrjnMbnbKRoAbzY4gdyBpfPS4uuClbeTAEjnKZVyKp+3QfOaiov7heHh5yVGhr/+hEm/a2cP/Ml1Fp9hqbmy78bS6g9NH3VXiheD+m3EOK652sqAuxrIBWXFLE6ligFu4fXbeSRD+/3PpubU0HBFHCivGvXOdF6+lEEoIZNbReBYK1h5CCBO8w9VZxaf/bXsjSotHpPdGcOkMhrvXwrbtfnbP8H1p+jltrDivnKs2UY2RkcQ/e8FWEk2mGsReglqjKdd2WX7BH6ih7FelU1KZroonDgyEEWVzFLIyiPgoXNy36IP5pMfh0AM+iYzztLVaTY7ur8ON5X1f1PFmt4GSAdh2rdyEzxGlrXMX2PjIX/UpHal1rKnhEsjMPLbQOGUpcwSWEqTXF/8m4uCpY
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12bda8cf-6648-48a3-6cbd-08db87af92d1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2023 16:53:55.9335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IuEEl4vEcsyu2d//O80ZxpmH3HI+0yul355atWRcQXrFgn9eXPvEWltbumUcAxHrDISKxwcVToWjrV+FtfzVKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4190
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-18_13,2023-07-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307180155
X-Proofpoint-ORIG-GUID: C0T8Aj5AjID9Ton_O2d53ylu5mOkjDZN
X-Proofpoint-GUID: C0T8Aj5AjID9Ton_O2d53ylu5mOkjDZN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2023 22:34, Mike Christie wrote:
> If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
> shouldn't access the sshdr. If it returns 0, then the cmd executed
> successfully, so there is no need to check the sshdr. This has us access
> the sshdr when get a return value > 0.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig<hch@lst.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>
