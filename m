Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43672C04FDE
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 10:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiLIKYM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 05:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLIKYL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 05:24:11 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9335761770
        for <linux-scsi@vger.kernel.org>; Fri,  9 Dec 2022 02:24:10 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B97nY74003546;
        Fri, 9 Dec 2022 10:24:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=c6J0ALieIXUItW/BHBcyPoqz/QHYkU8S0hnoLAty5Ao=;
 b=uJlCaZMspOSyBLypHWysEu30du6n4eeTdiOKaklRHiaKpJWFb3WyBKAAIIkZJkljVmhk
 nXm+78TO6wEOIKPbjvr3r99OX6kWjXf7nEL9xgIICUu1d09CXG2B6hu26cWjyX0t1b7N
 4T4Rf4rRbyCDaSXOk+TgMAW8oBEO89V9QFd/Q/fRTSkyON5n4oBzlrzObKGLxjmYa4mT
 JycN7vMmpAFPgT/81h/5NRTFiQg2Lz33HJNE63C8GvTeJqpL/GNorooSOQCjSbSyJvnT
 +TOeevBdDXNeB7QlD4oJLEl3GgAlzk1FCZgxXMzr1HKXqSlb+4dCYvqXrba7P4OGRTlh TQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mauf8mrj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:24:03 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B980oQJ033875;
        Fri, 9 Dec 2022 10:24:02 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa6ce3m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:24:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OfQEKePEAix/b79IhE+3CV6iafeLFV8LVB0+bxLFr7uLI/hCy/9EI4rCZEH87l+cW55mT/b7nTG9bhDk6jvlrqktvSqcCyXXdLbErnecg/lbtlngfCfapAXL1VrJgCEyKs9ibW8aDKefkD5poGCZ+gh1JgBeNuovzxovKYZV1cdQvYqw5SDb2r2iNLov4Xe9ZmDr4anBTQf5vrIDWeirD2Fx3n8qaJXbXKPi39Z5Z8STjKzQ3DA23L9e9Hqbdmwl5JAIc0YKL/XQz3R1JRIAJgGIWjc8J2QZHEFfGITOFq1Yp0T1p4ilx1Wni2sVKQ0WyuREOpw/8T42Wztn8M0Hzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c6J0ALieIXUItW/BHBcyPoqz/QHYkU8S0hnoLAty5Ao=;
 b=jxwPB52EMPHF14xNH44APEqx7oZL6SVh8UKXCJT22csTkta0pPXtOKngBmNhI+bxSHYvvomLalVmNG3vWLk0egl2ct6pwNdNOL9FAjnO0TPpsIOiRg6i+y78RW4e+c1z8vimoqtf/PUNNVc8tCh01p8O8XXknsMWSvavcd4xItMY62NXyeoJjgEb7zM82APrCnNSsQCqzU8V6/nrnbHSgKFGal6fDhn1k/IlL0kWV2vQCCcJNo+lYnEo14L2xKNC3dDm7/riXz4ujwjInT3UAe9poUDV+thDfSp1Mu5NFfjhmTv2iEK8PFoF61xDdfAOiiNsBYdhMV8ET076SFsvmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6J0ALieIXUItW/BHBcyPoqz/QHYkU8S0hnoLAty5Ao=;
 b=ZXFVfm15OJPcrHpeTC9o+68v9WYSEVG+V1Zz/5SMjIWIhaIlAz3ed0TeDWO0B8unrU6Ma9H8xLMW8q7bcucoCbcmyL6XGjRdzlaq+X6An2BCZ4WJrzPUwMpfj45KPfgjd25upaDlhHCBXWSmWjvcmZaDr2M6l1sjDj20WQGj7b4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BL3PR10MB6116.namprd10.prod.outlook.com (2603:10b6:208:3bb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 10:24:01 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 10:24:01 +0000
Message-ID: <ffc6dcbe-6b3b-6063-af8c-bbd021cf10f1@oracle.com>
Date:   Fri, 9 Dec 2022 10:23:56 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 15/15] scsi: Remove scsi_execute_req/scsi_execute
 functions
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-16-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221209061325.705999-16-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0049.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BL3PR10MB6116:EE_
X-MS-Office365-Filtering-Correlation-Id: 7da3010c-a6e2-46cf-aead-08dad9cf7d1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 30uzw7pLv+K0/AsjiNsKl33/DaqmbZj+DAVAebp/RBqZL9wdJkwiptHuZEy4/rMdPhEnYf2JRTliOdEio6MvR2G+8NEM5GLPHOYB7R/+Ax5EpJXGZz0Cec300tkREIO7EIp/kGSTJYPE0AeYDJtlpj8qqNUUyy9oEfShzOTWQ5/erkBOEXeJgflEWkf+LE4J3+ggnA/dL8Q4S+F3V9tLcSl3fjFNaJ92V2RFvo09DEWcFPcuMohUe6UPUjPKKMCNtWPa0vBxBp8peBRbVTGyPO9dF4JvewNfzhvtCskDRO2eJLNzZc6jOgx1/8BW/qcyqNu8gf59xWC4yyeCNm3cSa5pUryjQ0PlA4RG2GhaWaO9ZRDX3QuH2lcZtVLtkQckdx2rtAgHISnBDS1Az5CtepDFegbweIVFpkrPZkeqFmS+t5I/exQaRHvJduTK5qR1PYjTCTpAEyJ7ImcSQUOR2EAjtsbp/0Df4iHLlEGd0JtZCsyU7RYXhPp93cfChtdfdtUV0sOaReCx97eV2bMKfsR6d2tW6Gas+rWb015zyEbHuyJI0a2bBpF4JxJqEZuQv0AF4TNlRbbw/ijiLs36IO8nejl8zog02GIVtQlDY07xc7w++xa0gWgzSC02lMznEANrhVv5H5jGLceUzPmb4Bde8mVNDdeO+/Z8wcICHwvo6iKHGf+pjgy41loQbDAGnUlEzb0uQQCKyA9+/5GiPQAaMsexiVArE9218mu7Lk4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199015)(31686004)(478600001)(6666004)(6486002)(36916002)(5660300002)(6512007)(186003)(38100700002)(6506007)(8936002)(26005)(2906002)(558084003)(86362001)(31696002)(53546011)(8676002)(316002)(41300700001)(36756003)(66476007)(2616005)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0ZNcTFSV3EvR1ZURG5rUDBzU1JQT0JvS3hvQTBuSUViR1RjcXlnaFdXNmxR?=
 =?utf-8?B?YWQyeWtFTVF0VnJ1ZDRqUGRIK3UrSEtyOXZTdS9xcCs1QTljZytMbXUzQVF2?=
 =?utf-8?B?Um5HQUdTSUhFVitCSUpVZUd4TzlvSmZFSVVRZ3RVZmJIWEU4MEZBb1htMWRx?=
 =?utf-8?B?MFBGWFl5bTFsVjM4OWpmb3FTbXYxNU9BcTZ5c3gwWUYvZDBleWpMZDdxcE5H?=
 =?utf-8?B?RFZlU0xRVTNPN1Z1VDVwYWZYMDM3Qll3elNkTitLQWFLNENnMlptLy9JNEFP?=
 =?utf-8?B?SnJqYTRMeFZRREJhdmpyektMdG1UdXFBcXlSdDhXUEJscWpnOWhQMk5JczV6?=
 =?utf-8?B?YWJUbFU3cklLYTBXb09EZ2JtLzZmL2FBdDJ4M1loQ0lOdkxVeTBxRTkzcnZF?=
 =?utf-8?B?WjZVQ2dqVGVSTW8vWDFReXA5dGpEaCtCMGkyaHVMV3ZpTjg4R1phb3BCd2pL?=
 =?utf-8?B?OUh2UHJYSC9KWWU5dnpBRlYxUFJxSUo0dXEzc2xMK2N4Z3BqUHRlV0ZRSHA1?=
 =?utf-8?B?VWl6eFAreEh0NDZYN1Z3NDBFVUVWd2cyT3A0Tk9sOTEyRXBmWWR1c3EyRzlt?=
 =?utf-8?B?QlZBSzExMmRDWmdaRjNvcm1OREhXZml1aTFmdWlRZUF5TXB1VVNzZ1lCem01?=
 =?utf-8?B?elRPZUFyb0VlQU5ta2c2eXNyaEx1OUV5MmQ0MlBzUFA4Tm5iOFhNY0RiTDNv?=
 =?utf-8?B?YjRFWDh4WGZWNjZmS1MzbmNjbzZyZjlDVmVVSURZK0ZOYWNaYnQ1UnBybEgz?=
 =?utf-8?B?dVFKc3IyaVJxVXpEcDRONlVNRGlQNGpBNWlVMXVFNmtRTHY0M0VmdC83MGZ5?=
 =?utf-8?B?bGNpWGJ2dGx0YWZwWCsvMWdsNzFaUjUrKzVrcFJRWXpJVUI5d0x5czNaQmdz?=
 =?utf-8?B?bU5tRXBpdmFXWkZnaTNxVHZwUERJK0xqemh6dzJXRFhiMmUvVjV0RjNvWHJS?=
 =?utf-8?B?Y0E4UmVhYzJwcm5iYXQvODBkN20ralNHbWZpcGg3dlZDYTFHTlp1Y0pSMXQ5?=
 =?utf-8?B?Z0NHa0ZuMGhEMzhySjJ3UUoyYmZET0FBblpnbW5VTE5nNEVXcVUyL2I1UFFX?=
 =?utf-8?B?NU5OSDdQSFdoa1hWc0J5cHc2Z3Rkck1aOWlwRnZKcGdld2ozVk9YZndtc2pw?=
 =?utf-8?B?WmdjNzVUcDNLU3dOTWMwMko3YURXQ1JhbytRTWt3T0VyMHVRVWgrUDlTSDly?=
 =?utf-8?B?RjJJdzJhQ3pMek9oZ1daTHdiZ0pQSTVob1RyNHVnYmJmeDBXQnpIRGZ6ZFo0?=
 =?utf-8?B?V3dEcGlDTWxVTzV5K0FKejhQZkJGZGFEaTF0ZW5yYng1TmlOVEJhUXZKM1Np?=
 =?utf-8?B?T2FTOXRSSlFyZUdUMk9CTHBqSjVkdm9Yem5WaHFLc3FESFZNSU9tTGU2R0l6?=
 =?utf-8?B?Q3pmYWZ1dVY4OGgzTW05VDRSZnpZdlpPMENwTWJ6TnY5WlVJZjFLa05DWGpL?=
 =?utf-8?B?MnVVeDIwSWFsK0RwNEEwY3gxQmU4Yng1OFExWUxwUU04dXZOUnBCV0NrQlk2?=
 =?utf-8?B?WVpieWZoNmNZMnpoQ0FuKzEvZm05bThOOXltZEFTeTZPam82RklKdS91bUZ2?=
 =?utf-8?B?ZFZ2NXFMVTgvcXVhd1kvaUtJV29TYVp3aVZlbmNUY0l1ZmVLWHhQNlY2Tk1k?=
 =?utf-8?B?eUl5NWN5dzZ4cHdUWG9LaytqbE8wL1NQRkQvcldFT2dsU2FnVUtuV1JsQWxa?=
 =?utf-8?B?SEt6MkpHeFlybnJWWkZQZ0w2TEhML1U4Y1d3QUloV3d6UHhIcG9taklCVHFT?=
 =?utf-8?B?Uks4am8xdkJYbEFtSGxBOUI2UXhxMGdmcjNKQU1oU0l0bEhSL01sUEsvbUZy?=
 =?utf-8?B?YTRxUTBBbDBZMExvdVgwc1dWVnNqVDEyT1ovY3VVZlRIaVlKRWczaTJabDNH?=
 =?utf-8?B?RVJIYW8wbzNzSlFBMUpidXFBQzZSdTRmdHhuWDh0Tk1BOGdOUGZQMzRmNis0?=
 =?utf-8?B?Zmxyc1kraFZ1VnB3QUV1VURlY2hHbi9NeDRSdFd5Y05ubVFPa2pyS1ltbzh3?=
 =?utf-8?B?MkpsanAxckduQlUzcnlFK0MzZjNEaXRPRUpqUFpPbTJKRGdsNUJTMEdsVzVo?=
 =?utf-8?B?QkpHdEJlOFJkcVIvN0JKU2pTS1hOejdWMnZiTnJiS1BJSGxaY01HOE5ORXE1?=
 =?utf-8?B?UGdEczlidnZuZUVIeVBldStON1owenpMVlFSd2VOaTI2OWVSbDlYK3pNSTZj?=
 =?utf-8?B?NUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7da3010c-a6e2-46cf-aead-08dad9cf7d1a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 10:24:00.9673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BDp+bYxoMl+GKEI97PHqpd46isq7QApi/msvXMpO1CWooiLSNvgF/DcqKC8eeqw+ru9Ty9p+nS3uiTXhxdvR1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6116
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_04,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090066
X-Proofpoint-ORIG-GUID: A2k2bsZTHSwNMvhJcKpnxHz-k3mdICR0
X-Proofpoint-GUID: A2k2bsZTHSwNMvhJcKpnxHz-k3mdICR0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/12/2022 06:13, Mike Christie wrote:
> scsi_execute and scsi_execute_req are no longer used so remove them.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> ---

FWIW:

Reviewed-by: John Garry <john.g.garry@oracle.com>
