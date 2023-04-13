Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F45AC77B61
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Apr 2023 07:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjDMHfn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Apr 2023 03:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjDMHfj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Apr 2023 03:35:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177C68A60
        for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2023 00:35:25 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33D6XpLo007869;
        Thu, 13 Apr 2023 07:35:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=NZsI/3EwZcUdmClUAYS3poEXzeu78h7sB6pZy56kCe4=;
 b=nmoMq7xJFkFRX5e9CUt5NXB+C3q/Sz2BPuTO6XDd/M5Gb9AnntjAmXhbQmlwEubC0qhx
 rVbecR/8c/8ftMyI6oQtPA7GUaJnR4ZNm+k83ajUsZSJmMruaYXuGIi09tBAT8MIww8Q
 e9pCTn/aWxIt+GPHEvj4D02JdTV0DWuDc1PSrkkFQDoOFmN53sFEdnfttGdZGWg4BzDv
 NeU0jAHASF378o5zRrDSBY0YTyDcJxKn0Ch+VEVHZCqMwgml4nTvU1XxMD5IKvJT1OSf
 1NaaNE0D4lYfoRBcPiDDg68q8YFX6HX8XMA7tW9Rho/ltWRaxXWzGcvU/EuIdNkGqzPu gA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0b327ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Apr 2023 07:35:22 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33D7FIpc025106;
        Thu, 13 Apr 2023 07:35:21 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwds2vqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Apr 2023 07:35:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJla+G3Ws6haeC9Wi0LQIVsijCpdeeuZrhKyX7FrWjU8kFxOT3GnANHcg8+VZkF4KUNYagSRWBiFdcNiQCok2soWaP1fnenIdMfpd68kPYNVWMTJFjgLXTZb8IQNMNGAXwHWoW+wvvqpMAuXOoSAk+JFVlRc0jwaD3kq3h/vugtLKBnV95WgKWug3gkoEva8I4q6c6zsYVMJb+d3MUiqEKfpQN75gc3mGCoNEbEgg6oHqp8l0L+fJHPLTv5P3GkRwX20FwCxYtx/mkwt5iJqigrQOILyKNdcR+d6sKplNiqEq8edoJ30EsSOPv8EyIapX/qmoSLxqXoSWuBRga5whw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NZsI/3EwZcUdmClUAYS3poEXzeu78h7sB6pZy56kCe4=;
 b=IUc707CPplvJong5Q8ia7qAVnBBIxFl+QTsXdNHmKpfUGwdmReWIsPlKyw/LCoue2zS7nWeM0BXj2ozXOIE+Z6092XrZJ7ZQbv4WMKDBdp0lfuXNo9asRzgWr5i9LFrPpwgkswDCCNPkhfp7MtQVkN/XHIoHnLTY+qfrRhiLLvXyGw7lZ6hE6lp6rw8xgVyFgSrFfPpErfqJf9pj3dSe/6IfNSyM8yXe/fqJgZ3p3E197Hnu2NR5rREZ0cUELSNjRcisxGp3YCOyEZjf3EP0HonOXBcVt9mYfqiYM+3roeVpds2YGHD60RsAx+IQah6LwTcA07CU+u/M2cjdam22iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZsI/3EwZcUdmClUAYS3poEXzeu78h7sB6pZy56kCe4=;
 b=lw5pkuxvJ2OLk+azi1OJduJ95KBcbO91wUNDZ+Bgpm3yiFmoJVZw2iKmgdHgfMGH+3omf0IUrDXJYOE6t7pL9NowvBVIiH6XOZX56+me9Z543x3ovaDMwnWoZxEnlD229WPINA5LQBiB23/JDZbihJG+/hoIBWhGGLt5MT20eLo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB6887.namprd10.prod.outlook.com (2603:10b6:8:101::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Thu, 13 Apr
 2023 07:35:19 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8456:ba59:80ec:d804]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8456:ba59:80ec:d804%6]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 07:35:13 +0000
Message-ID: <a4f2f204-d14f-ddd4-eeb9-9d132e090de6@oracle.com>
Date:   Thu, 13 Apr 2023 08:35:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] ipr: Remove SATA support
To:     Brian King <brking@linux.vnet.ibm.com>, martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        damien.lemoal@opensource.wdc.com, wenxiong@linux.ibm.com
References: <20230412174015.114764-1-brking@linux.vnet.ibm.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230412174015.114764-1-brking@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P190CA0020.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB6887:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fd29383-bfd8-45e2-b826-08db3bf19e27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4imZrqPs56lJCx2hNAIXCnRpKhSmiDztSEWWdlKo/vu7gnA6Oe5yWdFVtA+hb44z/lOuyl54QV20kyJyZTQGtvK3E+xhcR8cozfFJXQ4LnEfDyo6ZTa11jk53Qc2szW18dQm9+4kF5gH01bz9OAGy1IV4MjEhQz7ONIIDbTk3+bMTnT12N5Opv2xX/HhYKrS/3+VUJ0OucHXpFTSOW9Ck5yRmtZT2foZIv1iG3Lio8vaLnxTtU6aqFb04g34A69NbC77d8t5DU2hlgxSYaLfYyuayZlWVLnbVprcRr2r2Ce/mUp5+YebvT3H5k25oSa2hreSPLVMaYL6H7kL+Y3h0iS8EBSz6KLaHgHNCwL/Q02B04yTaR1qyOBWmf9Ek9zsI0EEz4JLO1oNFoNSUvjXp4kX7O99EqxkfXspLsT1PYmtoM0w86RYO+pLqUoxyuJ+kIs8dCUXvV4Gw2eHvbCd6Bewr79Fsw9invFycKb/waybf3qwx2T8/0d/g3X8KMUzv+N3qq3DUxCdNz9oBLbPCUFCjbYjddfburXPXVIPnPRoPnw9RbniN+jjRBHSpghgqG4Cw7l8pvEBuzveO2Lf2SsvQEbaK1GV6YJodw58A0s6hblCyfInibexxO+S8OL24NtCHv1ldI3zQnmEPw5uqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(136003)(396003)(376002)(366004)(451199021)(31696002)(6666004)(36916002)(478600001)(6506007)(186003)(53546011)(6512007)(26005)(6636002)(6486002)(66476007)(4744005)(2906002)(66946007)(66556008)(41300700001)(5660300002)(8936002)(316002)(8676002)(4326008)(38100700002)(36756003)(83380400001)(2616005)(86362001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T09kT0J0NjB2c3VEbzlIaExoMlpNempRMnQxKzZ2ZTNVUEFvQTl6c2NmRHlr?=
 =?utf-8?B?dWpITSsxNGx3ZDMwMm9DTHpPVDdteGtaWHVCcDhMdnVxLzNJdTJ0dXQxbFBC?=
 =?utf-8?B?dDE3c1lzcEN0MnRsR1krckdoNUFIaS9zODZScVdPWXZCN3BOS3ZkZEFJVWww?=
 =?utf-8?B?Z2ZsWTI1SnZsWXRmeFZQa3JXRzRWcSsxVFhzdWhFVVJHMm1jQlVXZWE4UnEy?=
 =?utf-8?B?Q3l3YmorSzVCNmNrSStlazNYdXkrMEpBZTh0cXQ1WGV3V1ZweC9qSGZBMlhy?=
 =?utf-8?B?eTVDbEdXSC9SUXlFNzBDQy9RSmd5RDZwQmg4ZlgwV2hOV3pEbzFrS2FLcmNm?=
 =?utf-8?B?S1F3Z0RQVWczU3p3c1VWSUdaRkozeTZyZnBpQ2lhV09yZVJpcjR3UUdOcDdZ?=
 =?utf-8?B?RDAzODBlb0RSeFJwbFhDVFl2UDNiQXE0TzdnakU5OWtQeVAybTZRRjJoVmd4?=
 =?utf-8?B?SC93KzdrZjlMMXU2bll0VWczZmpTUE16WUc1MU53R05RUDlaNVpkTm9WZTZZ?=
 =?utf-8?B?TkR4QTJ0WUpwUjB0UFBBUU5wYVlJdDhQOXpzdWJUdysxdCsrbVY0WTNBdndZ?=
 =?utf-8?B?aU9GNzlRb2NjT0NkQS9QU092a2ZFajZ5U2J3M280YzJkcXZrY3R1bEVLTGZr?=
 =?utf-8?B?YzN3dzViaHVtZHpxRHRXOXdNM1lNbmZkVFAza2NOWXhVTjNLWk9EMHpRazcv?=
 =?utf-8?B?YUFSYWN5dHdnZklKa1pVV0dxdFpjRUlzVmFHVjdrRTB3bWtMMHByaFUvVjMv?=
 =?utf-8?B?UStIM1FpNko3Vjd1azhJdFVxZXZSdjdtU3NmbUsrcStEME4zMFZwZWJ5dk96?=
 =?utf-8?B?TVdHcW41cy9CNHF6WmNvOTZPenRYa1dMRGVsbU8wWlpzQ1VQNzdGcitrbGRI?=
 =?utf-8?B?MUgxVnZEZ05QZ3VxMUk2K2hCeWRTeVUzWTBYVU52Y1JGRytFQ0k0R0dQSE81?=
 =?utf-8?B?aS8xaTEzcFVFTEwzMDd6eHhwTzlZUU5OSG9qaTdQUVVqZm11UUxLZk1vWTMy?=
 =?utf-8?B?YmlTOFY1ZXZsc01vVjdKeFBBTTNsd2VMMDh3QzA4V0RBSUh4eG1GQkdXVWNh?=
 =?utf-8?B?ODFQTGdESzdldDJxd081cVFRZktpdlBjQnVvakhRbFNFZm1pdXc1dHh2WkFK?=
 =?utf-8?B?SXhlbzlhenJ0K2I0MlJncjhhN0NOSXdLVW9PbFhzOUhZRngxamU1VG5Td2ZC?=
 =?utf-8?B?a1VLakdGWEQ3TG1ZOXhQcCtyZEFmSjUwcFZCYnhLcVJqZ3BxbktVUDFKeC80?=
 =?utf-8?B?WWlJeEVJRUpMVXE0WFRwRWUreUR0Wno4K1o3ek5aWmtyYUxhWWM0NlR4VUlH?=
 =?utf-8?B?K1VmVkdOMFBMbEV1MVhCbFhseG9Jb1dCVjI4YS9ldVJGd01oK2V0TVVoMDJk?=
 =?utf-8?B?bTZpRmdQVjRmWjBNZFJPWWZJQ1ZNUWFzSGQ2eWtxUnlCSmh3YThTcC83dm81?=
 =?utf-8?B?U2V6STIxWUIyMnR1QkM4ZG04YmdGc0lEZDRWNkV2NHJGNnZ1YkdVRG1iSkVy?=
 =?utf-8?B?bVQ5eXlCOS9OUE4rbDBWajA1dklLd1B1cS9IWjVYQXJmR2N0aURBYjBPZUV0?=
 =?utf-8?B?c1pmZFk4WTN4eDgySG5GTUU1ckpYYzM2N0h2ZW1QY3ZGSzY5eGdzK1ptTzl0?=
 =?utf-8?B?cFBvK1JhbXhTY1hUUElzVDhoVnU2QXNKMWVvRmlFTlJCcDFyLzFDY3hrSy80?=
 =?utf-8?B?QWs5ZkR5Rjg2QU55eEhTQms2cTZnM2RqakFHOEU2bXArc2FOU1ZHc05XcmlE?=
 =?utf-8?B?bGpmWnJielhGRkxzaEN5NWJKTTNaTSt6ZThNQ21IVTVjQ2xIOElhSjVyT05v?=
 =?utf-8?B?UzI0VGhNblBNSXEzaWRmaEs3V0tMT2k3MVJ4ZFpBTEswWlllMTF6Q0JteWFR?=
 =?utf-8?B?alpEWk5EWlE1WXlXSFVoNUFOcUZOOGJDc0p5SkMzN3FNeDBJdGc3U25RQkVr?=
 =?utf-8?B?eENyQlREWHNvdzEyRHIyZmlZZnZBdWtOU1Z6NnJYMjNOc3F5TjZ0YkZ3TllQ?=
 =?utf-8?B?WnU1Qm5CNC9UcDdhS3NMd2k4bk1GYlN2alJOTkpsc1pzY0UwRktRNzlmcC83?=
 =?utf-8?B?dmljd0dYVGRHcGZMN1BxMjQ5cmZYTTYyL2kzazQwUzR1U2NGM1cvWDNPVmdS?=
 =?utf-8?Q?DEqDDJwhPqf81vUOsgOu8Acut?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: I7WOxA5gGPkVPgIzwGUoBEtjn2lJXd+Nbz6mF34qtob516+yQbaXZ0b3+VfZN11cFUZPnOjS4ZPQRtHWdHEj+Qa1PNdFIvM6Zp6L1Eca3T/S67j6Q9etR5cbuSAqcy3Co9pDNMBTK4SRAAyQrROocXB/SGPXx3wjdC3+VLbhdDCJQzNeArCcmch/+hbQTra4qPyLyNMeLlC2itMVbI2Sztb5ALDX0GUoZ10eniid3QeLGsoOOojsVuyVJYQ0sgNWqkM/7Kn0/lP2YOfXWObnj5xXLytzwbzvqqXIl5pCKoa6Or4M3Nq3OcR2DD6v7yICHJ+sBv5BtyADp8KA5FAuVrqx/WNJpUkP5vpHBwHmxnZorxkHgRLczs39Dgxuq/+4YW+c0N3Xl2azWKBw1ymfH9Kdo6qLzDr6O8Hks3JZgwTCXGnz5KFvcKFcCwxC2Bsz/1PlzMxF5DYqx49bi1ZpWeHSPiLNVe40wq5DKdhBt3NDh4CNwbtGLuscE1M2Q1XnQj3/dGcp87VL6FY1h3iTkjKzKASRWmCjhDR+DowZBRlG91H9ncVvA1C2adfS9Mpr0Ebv49Lw3xvFp3GY1gb7HNZ2w1hJWm4Tcp7gMO5kW1EzlTNT3YQTB8/Q4DMQN6B+zwDNPo5eDg3XiP4L4jfE2mQOeQiMNpBw6gxBpSuDsyXAXyr+tHdVB990p+iqoJUyaaT9BAQUKueOFelK0P8PRK/XIHDmYt13P7L1ncwB3cmPAg8TOscYT6ovFXu3MxBY48IjE1ZqjPYHDXlOJmrRHaTsSKkeUqCO9CVCsYskcTlUJ/GOKxDhsViWrVxVafhAFtUrBHLa6Vt4Vsgdo23HMzJRYjVTeF0rDczvwukH5YLZBfXqDICwVaBCqI3aONijMIuPOPHkea4YinHgZkKlMA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fd29383-bfd8-45e2-b826-08db3bf19e27
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 07:35:13.3102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S0Ev9fvHSosx0g9ncxHisgyhCFzvlwwehTYbZjm0Uq4JC/3a+6AO5TDCJidOwHf64qcMc0Pn1NPEsGgncXEEMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6887
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-13_04,2023-04-12_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304130068
X-Proofpoint-GUID: d4nydVFU3FSlAGgAkVjy154-Zou27w9-
X-Proofpoint-ORIG-GUID: d4nydVFU3FSlAGgAkVjy154-Zou27w9-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/04/2023 18:40, Brian King wrote:
> Linux SATA support in ipr has always been limited to SATA DVDs. The last
> systems that had the option of including a SATA DVD was Power 8,
> which have been withdrawn for sometime now, so this support can
> be removed.
> 
> Signed-off-by: Brian King<brking@linux.vnet.ibm.com>
> ---

Thanks,

Reviewed-by: John Garry <john.g.garry@oracle.com>

> -#endif
>   	.queuecommand = ipr_queuecommand,
> -	.dma_need_drain = ata_scsi_dma_need_drain,

This would only be used by libsas now - maybe we should relocate it 
there (from libata), but prob better not.


