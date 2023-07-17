Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AFC5C0015E
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jul 2023 15:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbjGQPpZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jul 2023 11:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbjGQPpY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jul 2023 11:45:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7CCEC
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jul 2023 08:45:21 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36HF0WX0029456;
        Mon, 17 Jul 2023 15:45:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=RtXoPmqqCNL/TVCjEGXo7bZvtClbb/XkLgABugssW1Y=;
 b=SNmUt/TBBL8+hIfeZuNKfOKQItSStiVnyf+gRYm0tNkokn9y66VGhg3/KBW9/Z6MeLuv
 twVIucjQID9rH88ms+soyNcJrd5L5TWMFzvS6dwXg1l5TyS6v8jjy96YVV4YR6gfjiDs
 /Xulgwwwefb4j7jxxiepfdENkI01kslZz/ge85tcSKioM6ZXJoySBtCRHz3cXI2o7jpw
 Qj9N/vNb2xHjbIlB+OeNLC7smtQkVhjrx3Q2sgDgSHWnb/i12unLB/itsdFhBzNK6Jfs
 mHGQ9w8kmR4tsj9OSMH+nasWjS8xnYWzvwaIweNWNa5rHCf8lL9hWIbaGBzcRujk+mv/ gQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run89u1ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jul 2023 15:45:13 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36HEIquc038207;
        Mon, 17 Jul 2023 15:45:12 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw3u1dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jul 2023 15:45:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+/NsKsfcN/Vh70ofuMHxBQ2X5519B0JkvUS63Ox/NyjxgFNYrakvsT3jd1uT9C3Mz8Wp64I2Dl/SHhD2jSB3yihB3pwchcbG16H9pC5QCC0/65JY3B7kRH/Xr2V8iPyTjCGYclFA3HDiKgfwR7FuOPnWSypPlidrLjv3f6DPF4D/yj4uOOcLK+M+nWYGZQc8RP/X5ENOb8G1Nfb4T5zFnRaiNcm83XAWyyASt4HLJPDYqYxtqwanNikgRqE8lx3cpFqROlkMUgvarls/FgOx5kYeNdYIOurg0AVxSD/ZPhrCdXOMInV8NIAqHGDcya2CuDdoH/MXR/8up+TvvgLIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RtXoPmqqCNL/TVCjEGXo7bZvtClbb/XkLgABugssW1Y=;
 b=c2bX/qb48u02ZLxHlt/akTz3fAPGmSY4G6MzHra6b/GNOrcVpzMGv5F4kl+qtH0YTnWXMzQ31QlvG8SF3VS7pwqsa+xpFF0FMPnoFScYYn8PPKQYg3KGADzU+SyOI/hS/nWHfvbtIaD8HVoseP/B0MyhsnLUmuoz/UpqETmQmVrQOfxAeKhZHDT4j8H2gbu9CmXGvZhwOLS6tuQbcabqlGZeNHJskyjsUP0QxoUBYDZTH6JQDr9PI9Hpji2T6P5id18i4tcsiiaT/4FDbgKsANK8XvEEGI7XYWVA0qQuKo8V5EstCo8lnvqmSdlkY25ViXgD1mc2XODbBF0aHTsZAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RtXoPmqqCNL/TVCjEGXo7bZvtClbb/XkLgABugssW1Y=;
 b=jFRk+Ub3S6AKpBWH+voVeCy1So4RAmGPm9Qr78siymkgbHZWeLzSYwjJYCbKOttGHQ5uAZwUmemNKc7hxZCtdmpfg6SMW9pAIhuS3fgMKaURvGqeSxGynRV2Frw0ghgm6fSqlqVWIjPQF/A27qScZPK0NkRZReG4zunaW+RvCNc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB7209.namprd10.prod.outlook.com (2603:10b6:610:123::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33; Mon, 17 Jul
 2023 15:45:10 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb%7]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 15:45:10 +0000
Message-ID: <e040738e-2518-4780-50ef-eb80085ceea4@oracle.com>
Date:   Mon, 17 Jul 2023 16:45:05 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 08/33] scsi: Use separate buf for START_STOP in
 sd_spinup_disk
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-9-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-9-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR05CA0091.eurprd05.prod.outlook.com
 (2603:10a6:208:136::31) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB7209:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a91c156-fa92-48e8-a758-08db86dccd83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yq7ERCpzvRxJwYhwKrLNqtnpjhUqneXHCpnAoHQlSEvT7QPUn9xtrrJksGc9QZCGtU3uePTrE2LYOzjPEVBC7Aui3sRXJqllwEI4/ubTH0vKgUR5lnG+wIJQlE7bLXe1q5wpL8rGbmtdDFtTfL+XBdG5j4N9VH/BMb9OFRmsd+GZjig730lAJjikztMV5AZJEsDN1wtKnJH4iZVl8A0pIHy1fxXVCTUbGfkU/Lf1s7FX+tnPeEW6QdQ/NyDP1c32LfbCw0oJdBGTguT4+v/14Xp0YU5jq0e9VUk/3fGsmC5zPOu1WtBxD1ABjbuqOPrDjPdP4aTu7AHBxBv/GasMLOrsapoLpD27uvBoWiTuzS+uoLZicecCqtOq4f1+SxC7NhJVFgDpeJfBpOQUari3NK1QDdJZg5H3nrNoDBIl4jmE7m8TCVkVDwnavRvidQ7QbrDUSI+cCiyWqAJ6mcZB271/zY0bjkYiKARziL7YFfGknKEaR+QNT/MtuZun+7lQ0zvxIq/v9pK+Ww0rc4s7dOjsDWLPVHaeoeJs85+EcrU3MpMNJYVA3hg1pV/6M1OwDuf3mNUccqyRKCXv/jMRQzDMaCVxziIrF/m8OEMez40QhxE35/axc5IkIji8e5FJPbwRlqAPVRxjcfiM1AFPDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(366004)(396003)(346002)(451199021)(478600001)(36916002)(6666004)(6486002)(186003)(53546011)(26005)(6506007)(6512007)(2906002)(316002)(41300700001)(66556008)(66476007)(66946007)(5660300002)(8676002)(8936002)(38100700002)(31696002)(86362001)(36756003)(2616005)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0loT2k5V3lObUk5OTlpWEtocWx4OCsveklhQlJ3M3dYNHpLemhuWDVqVXNr?=
 =?utf-8?B?RjZzOGZJSmFhWURXNkZLMnkwVUpIeWFOVlIvOWlSY09YT2lndEdBYm9YQ2pS?=
 =?utf-8?B?b3RsM1JpNWJuRmdEcHNGbS9DWVZMT1dvSXNIUyt3ZUY2SmkvVFdKUWVLelZN?=
 =?utf-8?B?NGxXclFMYlRyNzQ3RVRsYUU5Ym1pLzNXQWhtMmw0OWtSOVhwUlRNS1Z6WDBp?=
 =?utf-8?B?NUcxcjVtd3JRcG05bzN3MFZHblBhS1hMU2lTTmkybjdTN1dvT3RuS2R6L3ps?=
 =?utf-8?B?L2ovbTI5SUh0WENJcm5EVy84VzBsR1k1NWtoeW1DVmt1YWpNb0tWeHJnNVBG?=
 =?utf-8?B?QVlKeG5zbUdPY1hqTXV0K1hzYWo5ZmU1UjNhNzZnd09HWkp1eUIwZEJiRVpI?=
 =?utf-8?B?VTdKZis3LytmRDFHUzIydWErenVXNllINURmaUNSempFc0NacUR0NzVhek8w?=
 =?utf-8?B?ek5SSERVc2h4c0pMTTBtOHJSOXFITnBuSWh2d1pVa2VzQmt3a2hjSHgrM1d0?=
 =?utf-8?B?YmFNMUZCeVc3RDZDWTg1ZjdubElUS2NwQ0xZVGhWdHdJNGVWNCtuM1l3RDNK?=
 =?utf-8?B?WWkrK3hpdjl0NGd0NFpMRUdrQjlhSTdjRFRkSXdhSHFqbkFUQ1J0OUxQSXZo?=
 =?utf-8?B?akVTZzh0dEtDdHduTXA3dFFlRU9XbEx0WXN3UUVTOTREQ2JBaS9wdnkvRnNV?=
 =?utf-8?B?aWRqRDd5cmVIbnRKR3BTN1RjaFJpcFVDSnRSNEJqMVcrZncwVUVYOUdhU1Vu?=
 =?utf-8?B?R2o0VmtzcEFjbEJ4bTBKdjFwVHhTSmlMa1NBNEpXQ04yYmRWOElYWGlCMmdj?=
 =?utf-8?B?OVNJTCtJb21peFM5YVhNc1JQeElWTFNzRnVLQkp4Q1pETnpSODFHRmo2SllK?=
 =?utf-8?B?YUVkQldZNUZkOG9hZ0ZvMFBsSWdQM0x5bHhFNU5TSUtLMnNmQmtmdkFjV0U3?=
 =?utf-8?B?R3JiWG1NV1NzcGdiTERucTJJSGxSL0JFOW9oTHNPWDlhTWV3cnFQQkF1eVNT?=
 =?utf-8?B?ejFFTmsvclJ0QVRRbG8wc2ZRb1ZCRHBYS0F4VWR6NEFIN0NwVWc3cXBkWFNz?=
 =?utf-8?B?a1dRdk4vdVlwa1B2N1VEbzFMREJWd0lObm1Rc2ZPK0I4RUo5ejJWVUdmMllS?=
 =?utf-8?B?V25MUkFyT05lMHpZNlhYY2l5ZkFQWk9aVTdjWjQ0VHZleHF6dTFqTjVzdGZo?=
 =?utf-8?B?dTkxOTd5OGtSNEVXSS9PK3ozTGlLak4xQ2xDb0JoWjZPUHlpQzF5ZnVHZ2RD?=
 =?utf-8?B?SGxIUkRvQTROc0xwZmhlQWVES3hOZXVwc0VscGd3REoveG1VN0pFcXNPd3pn?=
 =?utf-8?B?OElZZldGcm5aS1owb2lCblJncFViWmVsTDRkbzJmN2hhK3RJVWQ1YmtlTS9Q?=
 =?utf-8?B?U1diMDgrWWhtOTZZS0NGVlJTbGZDZkdZQVVDaW0zYmJ3c0s4aE0rcUZpb3Vo?=
 =?utf-8?B?Qm9MZHRYMUVXS1VURllBTHIweFF2WDV6bEV0d29GNEZPclBLSm1zQy9tZXkz?=
 =?utf-8?B?OVp3dzJzVEhmcU9DQ09MLzJ1NDFTTWdjNTAwSmNwMmwwVXBOZllOUy9qN3p1?=
 =?utf-8?B?UTB0SEVDNFBpdzcvVGtHalMvSGdGT1FYd0xnTEtBZnVJR284YUJPZzYyRGtO?=
 =?utf-8?B?WFFSdXFNMnNLNEZjVHJWYXNabXN1NW9ON3k5cERLMXR5b1AwT3pMajd2MllZ?=
 =?utf-8?B?NE4zSkV5SWRqQVMyY0gweGtXRzJ6V1RaVTc0ekE2cG9Lc2dNbVllVEtUQjFs?=
 =?utf-8?B?RmhHdklZMEZMUUJIMWJnbU1vSDZqLytpZzgwOUZFcEI5YlpMWHFpSFlDeFJu?=
 =?utf-8?B?ZFJneHkxSlhSd3ZHUUdlaXA1Q1YrWk1vcngxdlV2MzhVOXNsUE1JRHdzaktR?=
 =?utf-8?B?cy8raURpVmFaK2RnY2FMZlowR1orWEgvckMvVjlZN2VZbHNjSWxKMFRsZmZj?=
 =?utf-8?B?UUxud0NLYnhUVFAvWDFPVHVERDZBUy9sZ0htQ2VQWFRKQU5QMTNvMnZ5amV2?=
 =?utf-8?B?VWZrY25oeGpldWp2RnA2Rmk4clFnQkRXNjZkSEFTWjJWSFAxVVBSM2JNc1Vv?=
 =?utf-8?B?N20xOVkxcno4bDFvMlpyUWJKbDlyQ0dlcUZnTW54USsrMk1pZXNzdkN1N3lG?=
 =?utf-8?B?czNXZHpEK05oTldUVWM0b015TSthbWdodjB5cHhYdStCWk81NVpadHlBSnpp?=
 =?utf-8?B?WkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +mp+CMo8DqK7OEvnzyQ+GyvLOVdLZf/4S1aLpNJMMr1yB0RNVJYHamU3JTF1mcpg1WyAIsAtVEP+CR8Dx2JgXKRVtOwoWydSC87iF0OKWLD9JCbXoP+l9FYY3AudRMxrd4MadV064cdp/fxT+zQtaZddmswrmtSFhAtGXTftJayatKqAHmJOffddg5QVWDLiir4prVDQDqgy6qYPxZGj1EJ9u+f2jwBgehCjRXcHVqPP4ePaWBWoA5jOR2WL3In97kjCLxN65NjvDWXR7jgmDF32B6YVod5Dw75KRWHwoQEKISDKZI7cHp8r6A8ECQQhUHX4U6zSoFplfYbXZFYd6zPv2hqGZYT5KzavOg88AxM9yayhiRcFd29+Ik4sBs9bE7YrEJJ5l33OPLO0KcR+sQubocd4jsj0dX+RNd3tl9OXWGmr9OkdX3R2bE8Cs0yZmjqp6vdxrrVnKjKMmJ1EqpSK0pUnz2wdC3QXKCFESE0qErlwnj356yjHolN8VYj2WxNsTruPFrcKHIrr1XeV8vtniIKw+pCH+e5q2/I9lslI5+HrcYTexEdB12gAMAAoO0KOfGslVcn9Zy0W49LZB6khXUc8aOq6IdbV2xfe3nKu3LZJkye7oBed+7cOA2kX07bvZD2Wfnchzqsrevb3wouSwxUAA44M2Z2PjJXfVc8RgKh8FiqBcPwrwPxD3dCzZCngMxkOuTkobdZ306YfdtJVUYtKKqOX42OzoI0Qf1KJzXTDvfj1H2dAPACcGdPoSsCMmVdZltFHz7jORSHlFK/E3C55dlIX67bz1hl+je3sb3cVD+2HcJY7nTWgBfsIQBSpJevf2ByaggFLoh3x18H10UHA08QXfJRZ8D9EgMGZXTJwHNb462WLHkQ/43iT
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a91c156-fa92-48e8-a758-08db86dccd83
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 15:45:10.5509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ezcNq8p25we4nVfJ/paIsqxLcq5yjAc2pojYd/FP7h7EM8v5J14JvegNF1yFwaRpc5Y+r9gEt7/KiBH1e4lRxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7209
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-17_13,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307170144
X-Proofpoint-ORIG-GUID: 2imEBkuGyPgVPQvd-bfgW1LRarlC7UW7
X-Proofpoint-GUID: 2imEBkuGyPgVPQvd-bfgW1LRarlC7UW7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2023 22:33, Mike Christie wrote:
> We currently re-use the cmd buffer for the TUR and START_STOP commands
> which requires us to reset the buffer when retrying. This has us use
> separate buffers for the 2 commands so we can make them const and I think
> it makes it easier to handle for retries but does not add too much extra
> to the stack use.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/sd.c | 13 ++++++-------
>   1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 245419fe9358..f75e2d7a864c 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2267,14 +2267,13 @@ sd_spinup_disk(struct scsi_disk *sdkp)
>   			 * Issue command to spin up drive when not ready
>   			 */
>   			if (!spintime) {
> +				/* Return immediately and start spin cycle */
> +				const u8 start_cmd[10] = { START_STOP, 1, 0, 0,
> +					sdkp->device->start_stop_pwr_cond ?
> +					0x11 : 1 };

same comment as previous patch

> +
>   				sd_printk(KERN_NOTICE, sdkp, "Spinning up disk...");
> -				cmd[0] = START_STOP;
> -				cmd[1] = 1;	/* Return immediately */
> -				memset((void *) &cmd[2], 0, 8);
> -				cmd[4] = 1;	/* Start spin cycle */
> -				if (sdkp->device->start_stop_pwr_cond)
> -					cmd[4] |= 1 << 4;
> -				scsi_execute_cmd(sdkp->device, cmd,
> +				scsi_execute_cmd(sdkp->device, start_cmd,
>   						 REQ_OP_DRV_IN, NULL, 0,
>   						 SD_TIMEOUT, sdkp->max_retries,
>   						 &exec_args);

