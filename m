Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78563C77B73
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Apr 2023 12:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjDTM7h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Apr 2023 08:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjDTM7f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2023 08:59:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02C840C6;
        Thu, 20 Apr 2023 05:59:31 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33K80QB3015326;
        Thu, 20 Apr 2023 12:59:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Vx4q5JrTm6D29S9mxJmmUp1bAed4WbCgkexd4O/00WQ=;
 b=AvjbxBhaA4REs60iYi1UxFRWMvr94Q/h7fLtmomA7jGohOd7zBRMSUMLAvwBar3G2NZS
 4zAU+5doYHnp1L/1RaKKFsGagh57lthBzTVZvOiWGhkJit6aNja7JK14nNfmbvRCS56g
 Z8XCQ+59P9Swy59GlTgFkkNDo7Jyx7gKBsAfqm/LeDT0boydSITuB7othnC7o5Nd/ctl
 nK3KiXQaB4dgO23m6WdE42U9Y7TMG9pfWXK5T/jSRouAvdU91i459znCoq5wTI4EBpzM
 2vY62CMEBcakjVwK9H/aOyh+Gy4xon7m/TvTzWVcIPmsNCu68zDJj7ZXjfLeR0mPkroJ 0w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q07691r87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Apr 2023 12:59:24 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33KCd5mY015632;
        Thu, 20 Apr 2023 12:59:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjce8uyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Apr 2023 12:59:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frb4mbaEo2s8akVWP226ltOugvn+JZncjvsw2jpqAHlBAtr4H50nLr49msSdVbO0bUrwfdsdRAkDRm4Z9TCBngWrRq2oAGKg2iN6iuQcFS90rFX1ki5jHv3LdMSD8TNpzH7HNi/isyKiUa41BLD58Ijul8uF1UMvWi9AJ1v/jyOFb5vBH1lOLw4novPWjXiLxI3n72OByNg4DeyFHm3O10f1N7UZvuUqfngKYEjdYgQU+ajJ5tsCarBmPiUcQfIyqjY1LXK5J7qWeHHR3vmtUMgeK7XiVCdeAknc5S+Fg/EM/P4x6zrzRAbvBYoT8P5LYRt1vlYtELve34UGvnULQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vx4q5JrTm6D29S9mxJmmUp1bAed4WbCgkexd4O/00WQ=;
 b=aYIZUjk73wYC8PkgTItIicfLOmHOg5LotFe+wvpFgBW7rJ5Wdm7QDgZzJ3ZQbgFpxfzwuge0Jhycgoqv9zfK2/CBiMKRx2YiUKvHzfzWgqHdzwKLHv7ja/TSi/7M65jbwjOFgzXZnlk7xERbgknCTfZRwpgxjaChMvQk9Z/6ZEKh1tJbSdTUrZGD9z3rCigHnfzVkfJNChJZS2bqpImyH1I1lMznX0rWCoHHbDGHiIftig/1ljdWs0NiFZJTN+/9GWOqw9XHMY2ABRi6QR8lJb2xgoUcdVtx9rEHXTufiO+g6kUNCuclv7eClCzujREaU7Faz06CDDCi6dgO/C/WeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vx4q5JrTm6D29S9mxJmmUp1bAed4WbCgkexd4O/00WQ=;
 b=zKlxr5364/uhaHK2Egd0wUBW73K/7QGG5gFw6XVxF4tO698ytlEcjNfgptPhC0fQ5xcmrlvrE3gyL6WDRWq4x0nWGaXGE6UKxnLveIS4Yx1bRnnoZi2AsJcxoulJxgiGljZTKgCr2gbsRkjFsQsbqca3g7ExVK1vJABK0FukXWE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB5006.namprd10.prod.outlook.com (2603:10b6:5:3a0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 12:59:20 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8456:ba59:80ec:d804]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8456:ba59:80ec:d804%7]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 12:59:20 +0000
Message-ID: <15edb8ec-704c-cf0c-00a9-014391ba15f9@oracle.com>
Date:   Thu, 20 Apr 2023 13:59:15 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: blktests scsi/007 failure
To:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, dgilbert@interlog.com
References: <725nkvuvvbf4qwiylarw5r56tjt3r6nrvy5sijk6affzqv2s3e@6xapeviellsp>
 <5ebd61e0-0835-94cd-b55b-942a9c72b5b5@oracle.com>
 <3xwglpdpmit2obtf5p475gojdoqe42rmteki5hvoavzwle6kqr@bl7xginwaeli>
 <yqe6sjp6ukfoafaoetwacddkpo2y5mk4hsnxgw377iwholxo52@psw2zzelcmig>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <yqe6sjp6ukfoafaoetwacddkpo2y5mk4hsnxgw377iwholxo52@psw2zzelcmig>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO0P123CA0013.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB5006:EE_
X-MS-Office365-Filtering-Correlation-Id: b6b87467-3e1e-4b78-e010-08db419f0e58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ML24loUQOHAI0Vv3vMc7dCff0aoLJ6jiZ+AtQvBzApHXKW+4ybnmRYQgx0ydlmPvN33FZtRoSxv2WaunVMqlAnLA59umAZPuIOzLyyQ5zZRWhHY91U2/I36XqA9GiT07rwCw8FLH4ECzw2SJVeB0LWf19e4ssmgyEGXBaqx4gMna0GMKtrdP1lQwvT8rJnBxPuZfcDu6GirnZqgRlQlStUoe4FyCG58TDFSsfWAcDM24Zu+cEkNgbXCsQvc6rgVmXXvdzlE+E+e8QglBGyhb/H+ynqK03CjwIJgmMIE1UbHri679UjBzX+IF6zyOEY1eElL7bdRB9VhwC7nxPxpxChne1VJskCD8bRXiv34miVAE9OC/h9zYfL+xrRSPu8F+37V+F7ldcPtoJyQeywIHoRyutQzgWUULa7XiKwklXIDR4OcmK+eSyefTInT2ezJeQulIHl2kCiip4BBhw4eNzYGaVsjCV/bRHaRB/8abC5lV+Qqjf2me581uhgf3WsfAPbuDLtHJJUVYRpTcM7JEnfIekyCLVHIvsFi8rc0oicAnI5CpIDHNDUGxHqXDFXSAalQHsPB2+22kiGqXlEPWkbtPjT3z/VJlvQRTLJnpHDaxw7VW/CiuT1Pxnxdh6hfoZqb+b1B9c7C9E5fTa7ii8csYwQ0uwKw/ez096ohmxDLIlYkhKamkE7kAsl+PYxL2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199021)(186003)(6506007)(6512007)(53546011)(26005)(36916002)(6486002)(6666004)(5660300002)(316002)(2616005)(4326008)(41300700001)(66556008)(6916009)(66476007)(66946007)(8936002)(8676002)(478600001)(38100700002)(2906002)(86362001)(31696002)(36756003)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3hYMUxDS0tySFNlUnlqQ21hNWJuYzlIVGhtWXBJWXdjUDFtUzR4VUFRaHRa?=
 =?utf-8?B?RFlCR2gxZlFDbW9WMCtOR045YnpOOTBPYXY4NGlOcVpTOHpyN2VRdWkzYmky?=
 =?utf-8?B?UnBrblNPb1RKclMwMzZmcmxtQVRtMlVmRm5IY3ZNQmZsUURDTEgvNmhEVkZy?=
 =?utf-8?B?cXdVdTlJQ2dtZk8zck9jQnFUWjlyVlM1aTcvbms5VVRXczZ6TFpqelNvMjdY?=
 =?utf-8?B?NlMyZzBKV3hTU0xQVnJ3MGM2bHdTbWErMFl4eWNHYUdGZ0JRc3UyNkEzcGkv?=
 =?utf-8?B?ZEh2bEhtRVc0Z0dyOVltUTVRRm5CQ25RUGkrOG1iSE5RSnNBTmQzWWJKUnoy?=
 =?utf-8?B?SWVpcmpXT3VCTEJUYTZlL3UzK0ZJK2greDJvZ3g5TXhaUzBZbHhnLzkzN3Ba?=
 =?utf-8?B?bzQ3U3RQMlFLWUVjTHRqbHhQRDFjVUszSFQzc3IvWldGYUF4VTB4cWJTdUx0?=
 =?utf-8?B?aElOenNvbGkrL3o1cWhMOHRIb0x1aXhLR0JhM2Q5Sjg5ZC94Wm1vQXlnMng0?=
 =?utf-8?B?dENXVm9UczN1dkZadG5DRXM2emtUcDlUMFlFZjl2a3ZxWnErQitxQkpBWHcx?=
 =?utf-8?B?QzNKc2VPSHAvNWc5akdZbzM1MkhHdWJZMTQ0OC91Ly9IRm52QXg5UU1SaHRq?=
 =?utf-8?B?MDkxTXVPZS9mT2k5OWNhbW41a0dSRDBoRDVONk5uTGhsSmNHVnB1aTRCbGhH?=
 =?utf-8?B?QXRJMzV6aGozczdOMjY1M0pOa2s3WmdPS0JjbWRNenZjakwyU3hmbmFyZUlZ?=
 =?utf-8?B?VVVyaWVlQ3dEN3FacHhDbzFEN0pZMlgvVzdHU2wralhJTCt0eC9jZDZSTGl2?=
 =?utf-8?B?OUpNYllVN2FRV1AvYXpNeExTMXYxVXlzY2MxQTJmOGVyTnNRbmM1QW5Oc3FS?=
 =?utf-8?B?T0oxeVRkN2c3M3E3R0krYm1qN0cwei9hVEFUREFmd2hFSUhzbkNicmFRVitS?=
 =?utf-8?B?YU1VVDhBazA3eWJna0s2ZEFlRGI2Z3FJKzdoeHVrcTVHaWxqNUVpdnlKRVhN?=
 =?utf-8?B?V1BMbjBSM0pPLzVaTDExTm4yQ2pDYUZmZ2xRQk5HeGhCbUZYQnVBcUxSeFlD?=
 =?utf-8?B?V0hhb3o1eUpuTkpudFZVbUl3dGFVeW82bGpYSEMvMFI2bC8yZVJEUm5laGIy?=
 =?utf-8?B?WUsybmNXUFJYZ2VnOUZCc2ZLbWZSRGEyV2ZqU1AzQVZlSWhJa2I4WUtzL0xM?=
 =?utf-8?B?Y3U3WHJJaFZPUDVQQkVXekVMWEx0cFJJd3o1ZVFubnA3d2czRG5FSkYzVzA1?=
 =?utf-8?B?Wm5nZ0F5ZjZka0RDcE9NWnNYM0xTQU1WOEY4VW1QdWR5bUprMXAxQUJ5VHBv?=
 =?utf-8?B?dnNJbWhFOFBZV09zOFcwWStaNzA5QmFqbEZQQUo3TUsyOGs3d1l1bnZGNlJl?=
 =?utf-8?B?NVRNSk1ZNkthRXdaN0pudDBLS0dIQTVKRmRhLy9seXE4WXYwbVJhd1VJZmZU?=
 =?utf-8?B?cDJPNWNUQUFxeXgzMGRMMmR4YUllaVBsckdEQzM3YVZjZFdqckpCWjNwTktO?=
 =?utf-8?B?TzEwQkhhbVY0Vis5TDdKSjMrSU1JUDJWaXJEMTdWWWdxU3orV2VadEZHNGpn?=
 =?utf-8?B?d3I0WnlXcHhONkFwMHQvNGJQU2tjWVIwV283MGx6bUdmbUJwK2E4U2JVb2pI?=
 =?utf-8?B?OG1QRnJ3WUd2dnNJVTBMYUgzZkRhcmh1aGhrWGtCK1l5WlNzblRGWlVPV1RO?=
 =?utf-8?B?aEZPWDhFQS9wSExqNElHVTdqQzc1eTFPK0hXbEl0Mitqcit1ZURIeGt5QXBi?=
 =?utf-8?B?a1pCeGFkMTlqT0F2OHhxNTdhZ3U3N29OT2VxT2hTeU1obmp4V2M3bXp3eVZZ?=
 =?utf-8?B?SEd5Y2hFN0VXVFd0dXh0MWFhVTc1R2RFTzRLejkwKzNBY2FvSThQZzZYVjM2?=
 =?utf-8?B?NEp5VEMvMUwvQktOTkpnbVdCaENvQmRUNWM1Y1poZ3h2c3NjUDg5THdIOFln?=
 =?utf-8?B?MGV0QXFhd1BWOXpFRTc4bENaNnBvVENBSUs5UW1PYllFckJyTVZVd0FuNEsz?=
 =?utf-8?B?MXMyTHZ2VnBtQWRrMERLS1l1MFdKWlZGYTVJUEVvaXhsTmpuUlhGZmpIYmc1?=
 =?utf-8?B?dU1vY2poMmdDbTdMVytJT0xCTlIxcVhodGxobWVqTFZzdWtVdHlJSjFMSnl4?=
 =?utf-8?Q?oX6ssLH1J4WBw2ilkYWZsayXS?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: EtYj8oo8iBzJyg2ZDUVNqJ+HilG7rLDPKvZ396bDAxjuhhLZJ8GQryyHuwm9REwZummLq/U5v/DvZcd8/XOMcPVrTBnTHlr5ofEglI6kR9B0bUDQoSPmKsbSrAVWwMoSGSbSYFZ8Bf3xNRlYEkqafAWlkSfLFm3CfXOML1gPaQ3o2B7PDO2pLSVRt0Fhfjture2ULJmiHyZXyoLNs3sjn2o/gGncklTSEiffxvdg50FohbsK5eK9l1uPMfFyW1V3lMh9Ju0/I1KYCGZxGm3nbUf9nh+p0IhtD1ELVkLhd2wUTZOrYFVN3qSv28w4QAMB9R9kiYTeVXgLF89qSqr7YZ62m56r1ORJNTYml9zylCJs+vm4SNkE07I70/sTI48tER+x75YYZv8IpHhC/1FX9vvt8zxp17Xric4/WGSSqtHMXEZmxDKei3cRFCsBgs34Ns/tHesaG8/E4a0lgxDxkmSo7A95Nren1YW5MjI3XXVQF9qg2anU2OvBzBO7bIz4sO5+5FMzA7CHCMQWzoMth0Ij/qGA3QhpSQwYX6Xbw2jvMmP11PPFAjJstyMvuWBJFsqwOpLo9fyJyq0RoVn4E9XqYZVbOOxLLH98bLF5/3KWJH+JPpkWOsp2mNn5DNSELmGSdxLpiWYZuZmUTE2RDNQgXG4KVcwbTWOH1l1QXjg1RaAe+K8hWcWRj4u0+p+Nrg42PfwlGj7kVTEvZU3yTazMBCyVcS08Z+qULYSDvY6birsmlvvig9vONYfi7mmiS2U1uop/o+pXzQnExdfcFdxCiCY7MJBUyoQ+dQyr1kDXglLL3OdQ/+d+biAyyTiKoW8FgLo7BOuw/7VO4mw77lqUeHnGo+PCBXAbIqi13x0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b87467-3e1e-4b78-e010-08db419f0e58
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 12:59:20.1915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LQeFXneL9SHKq3FZ+7L7GFLuSDwMlTSs6orsvkey5oMUyycg+MoYx8YDx/pZJHIjyWRWSwTzZ+7tIzeklw4LCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5006
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_08,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304200105
X-Proofpoint-ORIG-GUID: r4xF8DIzrbgAcMYtsX0qwicdaW1uUPCY
X-Proofpoint-GUID: r4xF8DIzrbgAcMYtsX0qwicdaW1uUPCY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/04/2023 13:26, Shin'ichiro Kawasaki wrote:
>> Thanks for the notice. I think your changes were applied to 6.4/scsi-queue,
>> which I've not yet tried. Then it should not be related to your changes.
> I took a closer look in your changes for kernel v6.4, and noticed that it might
> affect the scsi/007 failure I observed with kernel v6.3-rcX. I did some trials
> and found these:
> 
> - On kernel v6.3-rc7 without your changes, the test case scsi/007 fails with
>    unexpected read command success (The failure I found and reported).
> - On kernel v6.3-rc7 with your changes until "scsi: scsi_debug: Dynamically
>    allocate sdebug_queued_cmd" [1], scsi/007 fails and causes system hang.
>    Kernel reported "BUG sdebug_queued_cmd". When I reverte [1] from the kernel,
>    the failure symptom is same as v6.3-rc7 (no hang, no BUG).
> - On kernel v6.3-rc7 with your changes including [1] and "scsi: scsi_debug:
>    Abort commands from scsi_debug_device_reset()" [2], scsi/007 passes.
> 
> [1]https://urldefense.com/v3/__https://lore.kernel.org/lkml/20230327074310.1862889-7-john.g.garry@oracle.com/__;!!ACWV5N9M2RV99hQ!LO2F4s8nfVkzWonRz3dAAjnNVnWR9BxaU3O5S0eyOQ2LfEvDoYKqox5_uN2SctlIhs5Dzq762TQTlB5jHTJX_WPW$  
> [2]https://urldefense.com/v3/__https://lore.kernel.org/linux-scsi/20230416175654.159163-1-john.g.garry@oracle.com/__;!!ACWV5N9M2RV99hQ!LO2F4s8nfVkzWonRz3dAAjnNVnWR9BxaU3O5S0eyOQ2LfEvDoYKqox5_uN2SctlIhs5Dzq762TQTlB5jHa0ytu5Y$  
> 
> Your fix [2] intended to fix the BUG that [1] caused, but it also fixed the
> scsi/007 failure I found 😄

Great

> 
> 
> To understand the failure deeper, I added debug prints in scsi_debug, using
> kernel v6.3-rc7 with your changes just before [1]. This kernel does not have the
> fix [2], then it does not abort commands at device reset. When scsi error
> handler does BDR, bus device reset, scsi_debug does not cancel the hrtimer for
> the commands issued to the scsi_debug. This hrtimer is alive across the reset.
> When that hrtimer expires, scsi_debug completes the command that issued_after_
> BDR. The hrtimer for the command before BDR completes the command after BDR
> since those two commands use the same scsi_cmnd and rq objects reused. Then the
> command issued after BDR completes earlier than expected, and results in the
> unexpected read command success and scsi/007 failure.
> 
> After applying the fix [2], scsi_debug cancels hrtimers at reset. Then, the
> hrtimers started before reset do not affect the commands issued after reset.
> 
> These findings mean that the scsi/007 failure I found with kernel v6.3-rc7
> indicated the bug in scsi_debug, and the commit [2] fixed it. Now I don't think
> blktests side fix for scsi/007 is required. Good 😄

Do you know why you specifically were seeing this issue for v6.3-rc7? Is 
it just timing related? I seem to remember you mentioning debug configs 
earlier.

It would be nice to see this issue fixed for 6.3 and earlier, but, 
considering the circumstances, it doesn't look straightforward.

Thanks for the info,
John

