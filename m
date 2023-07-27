Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D4D0C001E0
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 07:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbjG0HyJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 03:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjG0Hxu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 03:53:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4332C30DF
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 00:48:46 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36R0sgx9007693;
        Thu, 27 Jul 2023 07:48:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=aB58mNnpaPw/2sSd6jkJ4BvhKN8jiN8UP4zShag9xos=;
 b=kbIpFTgiFBKvMWMX3RMpFWf9tQGHGV6IakH9Krlwh0KoYn2xvW6M1Yk9y14Fkcn4rSbd
 d7u6qvT+UFY8ZylzhVLIH+KyHSrD5H3sdFxq3AwmCxcbnC1LRXxwd0FwinXvOVtHZkvL
 s2pI5JQyqOc9PyWbhdFoxC77/ES7BOshLkWvdwCamOlIjDjfBWxZzL4abVzXKm7onynn
 sMNItKrLn3nSOz0PQNP3JhifpXlBctQPjH2hm2+HVhEc6P73pl3o1nsPqnD9WRiTUE7r
 RaisjROen40+KollaGiplYwVS00CLKK54grqeMBYe8IyGIs5VWWRk+z5hSNysBmxKxCy BQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05q215vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 07:48:38 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36R76fEE025372;
        Thu, 27 Jul 2023 07:48:37 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j7skwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 07:48:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CHb5wM5loLaShJyV8VC/c9VCa22YKGZcs+TK34bAzbP8qmvIzzGuChkVgNXD71j1KnzxjLvtrXvBK4cHXpwbjQsXCLa0+fkyf3PKVz0YnxtN5hTcphIBbfVc2X2TkQpgB6Od+uKKVkjv4SaySv3Y3gVptQK078wRlIhE/6ZzF/0ky8mGmQvLV1mkvCsBuoD92zbn8OF+C9F9qo3kgiebAzRuutH7/6XtvxWn9x84HKRng/2Krs0N6H/riqxW07VfBxpHRSQIIC+GFMyRy2AGn+aO8/+pRe8OLuvwvWeH5yigP5dzrOTby3+YzcVylDcEDvNMzNrF9Be56R/gq0OGCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aB58mNnpaPw/2sSd6jkJ4BvhKN8jiN8UP4zShag9xos=;
 b=JaK7eXcrtrzZRumlW0nzULwLTuCUAfcQUU6OGBn39G7ORVHj+4jXoBKP1UX8kHUiXATUKYYtsOtxJgAlaAHWuw1PrRKymFVg7aP7lm93pYBNyZFwnZyS0NwbTE5Q4hm/EwSiNDK/nNcVIvuX0kqWW12SMmvZBmFMkbWHMup2cA7qZuZN77R+dwwZWb82U/abgIVcY28AajwtlkBKbW5QmwC1Z+B47DjTEiSFpyHOjqc8ul9sF9UU/kE2pzuv9esom8Js/7pP7F1LSeEp0Z0IIl0XvDMKT15TPKXEmFEpUYyUm+tHMbta0kjLg0WNTReE27Mh62mm8Es1MeHVOUxuCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aB58mNnpaPw/2sSd6jkJ4BvhKN8jiN8UP4zShag9xos=;
 b=hForjeHGjYsxUw6GeSTcGskAT0qwb6GFuuUN0IxlKls3QyLKInVq899JrfsKm6pBQAHMrWMSLWFpzuSMCZXtlAvgvyUHdGUTXtxrXUlg05bZSeupFfTqy34CgEAqxo00rQL3/x4f9nY3OHY7iMtVyrb1D/UThiBs13TgBmkxy14=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6437.namprd10.prod.outlook.com (2603:10b6:303:218::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Thu, 27 Jul
 2023 07:48:26 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Thu, 27 Jul 2023
 07:48:26 +0000
Message-ID: <07cec4d7-47b9-03b6-1bb0-4b750fbfc05e@oracle.com>
Date:   Thu, 27 Jul 2023 08:48:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 21/33] scsi: Have scsi-ml retry scsi_mode_sense UAs
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-22-michael.christie@oracle.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-22-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0414.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6437:EE_
X-MS-Office365-Filtering-Correlation-Id: 18fbb47a-7922-417c-bcc1-08db8e75dc78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5HWVEl/94NDVTQtnre8/YU+FCmxhPesPmqKYpNnXHKmcTKqpuj4VrwWMHVAjmqZNxH4LLcI7h8zf9zV6AV5M6cg4ntdwgKapqgmP8v3GrNmzdq9wVN6EgbyCo7wS+UpHJ02VUUb6e5sIj5Zg0O8r+PC/H3EsPGXLBHkuU0Oiwx53iQEnnqknkf9b+WpBq3S7N2WCux1qO+VNigv527s7WTJp6BCLF/vd47+UeXFUTDa9Bjx/M2UQSbJLmNa1YdizOaoSsFIh5LKxL2P5b88bWLo4OEjkVKHbCRZygVz8VlyItAGOSw9O66iXet4BP2J5wSzwuHRhYBBxJxJi91WUbym/KsjJ2HnwWr1TSgaqAq8/XwzAM6oKetlw2tfLK5N5WTX5509Hv4yDy/o4eoaNMvjqmb2TqCMlSNO+JIflKQhX41tpiMFRZXJtRfCxUM1wWEqK/F66C31/fEe7n4KJQJB/mQDTHPaGunf250+WRrMQf6QxkxHLO+dOL3BBGoKw2GNPlE/mY+O5SB0DjR06hz5HkD4lZuHz3QaQk+kYsL0uGXx3hghe0Fa9NwVONWd8f0E76hwSIM3HDUmmyoJVerBomdLEuZhskeTBuXrPnimo51y6b0fuTuaKLTdytwgM1weYdkkX9H48IZqlPjvrAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(136003)(346002)(366004)(451199021)(41300700001)(26005)(53546011)(38100700002)(478600001)(86362001)(6512007)(36756003)(8936002)(8676002)(31696002)(186003)(316002)(31686004)(66556008)(66946007)(66476007)(6506007)(5660300002)(2906002)(2616005)(6486002)(6666004)(558084003)(36916002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGt1Um53K3ExNUs0Z01TazNZT3UxcEpTbnRvM0V6b2laeGdRU0cwQ2VpQ056?=
 =?utf-8?B?RHVjUkxWYmxENjFOWWdhRmk2Y1VUVURVMnB6WElQUXdtellBRERnZ3AybHd5?=
 =?utf-8?B?SUxCYUlHQ1AzNzhSbW9kNjdKZkRWTENGbTZNakpDTlFCeTdZN0g0dVRpVFNy?=
 =?utf-8?B?S0QybXpGSmRZM2w5ampqZ0JEMmNMdUtLT3BwSkxtemdPZ2RXb2FLNmwza1FG?=
 =?utf-8?B?VytoYUZUZ2h0SU95MXh2Q3owMFhjT3BWdm9WaExUZWs4ZEwzNzJMRGhOckR6?=
 =?utf-8?B?a285Y0s5WGZzTmk5YUtYcnBpNk1hcVl1WlVVT21QT0pYSDVyaWN3TDB3UjI5?=
 =?utf-8?B?dVpLR21UMlJLRlowQk9ZcFRjdzIyNWYxOUhUQkV1UkpqZTN3WVZjcGxjQ1Mx?=
 =?utf-8?B?MFFzZXZRNi9TN3lRTjdScEVNWTZrWFhOYUU4M3lMdkEzZ0w4UEFmU1ZubmF1?=
 =?utf-8?B?b0hCaEVaYWljK3E2WlNGNWtFL2QydTdJb21NQ1EwdUVCMjdhdE1VdnkyNm83?=
 =?utf-8?B?bnRlOXhBb0xqeGM0TmdZRnF5UkpWRG9TMisrbng1ZlljSW5VVkVXckQ4bnlU?=
 =?utf-8?B?QUtGbVc5M05tZ3liSXE2R1ZBMWhHQnZBZTdJdTM3RUgrZGJWNHR6SW5rUDJw?=
 =?utf-8?B?M2tsTmRUTDdwR1UxekJlWi95bXBhR0ltTDVMMmJYYWYxa2RjUzVIa3N2bkZH?=
 =?utf-8?B?Y1lNL3Qvb2FmOGtlT0s1L1RmdXdEb244KzBjc2k5ZFJtcjRCNWR6SWxMU0lq?=
 =?utf-8?B?QUlvRHU4SnRnSlhCUW51bVUreTZpaDBmUVZSWnBZZnl3VitLVjZ6MnRqWk9M?=
 =?utf-8?B?MkNiOHk2azJyWDRmZWlKbmltSC9DdWJFNGdOLzljODZZdnZnT3hzWG4yZ0dL?=
 =?utf-8?B?c2tZL0puZk1HVGJpdHhWa3NwbVJ0OFNibkdTYXJBU3JjcVR2K3FaQ1dod2Rh?=
 =?utf-8?B?UDdyV0MvbnNJa2xES3FEKyswVEN2U3J0ckl0ZmFMczJaTWx2MitXRStKMlJI?=
 =?utf-8?B?UFlLb3pFVElVU05ldXNHaTF4YlVkOVlQanV3S2N2NlRHSlFVWGxLeVRvVTFL?=
 =?utf-8?B?MlpOL3owRE92dUE0ZDZBWnMxcm5iYUt1cEZQbFVzUnRGZ2hUZkdqcXR3MjJh?=
 =?utf-8?B?Ty9tRzZHRDJFZ3llaCtYbGNDb1FhdlpGOVY2RThNWmhIdkkzUnZ3U2hVKzNQ?=
 =?utf-8?B?SVRCSjM0aTNzMzVLaVYydWtYTVZxK1FiY21iV0kzTitTakZpcVRyaGUvcTRs?=
 =?utf-8?B?Qk9HNUNjRTRMbVR6QXpTc1pMcUhML2RtRm4yc1BTM0VwM3J0UVM1QnpCNGd5?=
 =?utf-8?B?UEJRdHE0L2tUcFBtaWM5eVdweXBvUGx6YkxaS2t4YUhEZzd6bGx3MG9YRmo1?=
 =?utf-8?B?U05Xeko2Nktxem1MaEo0amJXOWx4SURlY2tDZmwrZjROVUxEbnU0RVNxOUJa?=
 =?utf-8?B?SzFKeGJoQU15OTI3NTNLRCtLUFRhVTlQWC83VXRFSFpOSWhOYjFGbG1QSDI0?=
 =?utf-8?B?NWExcGRSUFBGQXlSNHp5b21qbTJMQ2FxUndXZDJRR2VwaUZqOGFkcGZ2aWFs?=
 =?utf-8?B?TjJGZ01GZHU1aStidWZ4L0lHUGFrTmhCMGg5bGJ2ZlVvcEk4LzBqWmRFK0xH?=
 =?utf-8?B?aWtrVituWTlYR2ZzZmZPUkZXcFhwZ1FCMFVuQlJMN1RDalFIZW5GaFNDS2Zt?=
 =?utf-8?B?RFpJczE1YTNFdmF6djhYOHRJbXEvdjVXQWVwbit3Vm1XQkdmUlFmSW9BZ1JT?=
 =?utf-8?B?WEZXakhwL2pEOU5iY21md21tSEJXOEhrNEM4UmFyWlIrdmswWXNZalVHSXhn?=
 =?utf-8?B?NUs3Qm16azRieWhKclNJTExpM1dDQnBEdDRzTUtIdjNBZEZqU1hUMlRrUE94?=
 =?utf-8?B?OFlQa3ZkemtNamZTUEdzKzFkaGdYTkRQUXhHVVNjc1BhNkY1N3hQY3JOcnNq?=
 =?utf-8?B?ME5heXVxbC9XTFhOeGpFdHJjYkVTSWozaTZPNXRsckJtVDJzTE1yMGcvdXBH?=
 =?utf-8?B?NWNCaFR6UWdyWkRZQWpDdEx4T1UwY0VkZHVTZi9TMW5uSkVQYTBHaXdHR1Zt?=
 =?utf-8?B?S3hObVJ3L2V3eTFSZzVFSEVrc3VVdTlqWFE1Z2FGYVRFT1lRYTgvd3BlejNS?=
 =?utf-8?B?Mk5Mc3cwK2R2Q1U2dm42TC8rcDMyeXFWSGRsUGYrUy9yQ0RkR2wycnhHU1JK?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: oe0GJeK8HYjVASRxc1Hxx3Dh1RWYHKtAfchcoAVjrLc48hwrgDLnmo8iILMKfAclFkgil3lvOltVQLAuxtyZDzKVYLX2boRJGkfXNJugV8vQXTOcpQy2w4Sw9Ra+AnvuX1g8KN2JUjfC2T5EE8ejkgJbAcXVjEENAucEDfVRcmZfjimqsNHaEUIctOyyD+bKWtrnXelSyX5Msx8Yw/Jni5k839b7tjyovC3MTICTYSxlAKQKDXINkYlYbmLclr61IRjMAWf3kUaNGFEEhNxfAwPJ0/4LW7Dl9DR+4Wxa6GnYEoudRuUdTlwlZDEJPPy0WrTNlomSdwYTMjXBQV0ktnmKliaWuCYCvmSW0E1L7DHLx9PHtLmmWe6/xtZNlJUFeYC684ezxpnf2I2het6St8Kh5wGZaitoiMx+aZNy346i8/wMvnO0XTS9ZhMKP+J6j0WqLZmxlRx1iBwbZdb/Ko6ZybIqffhgR3Lcqg/pV977iKVCHiZ5evg5HOOWt8uMwzpaLTpojbJkWxur+oF15Rw2my3WM0IWUx90YogR4LEPd/9lJUivLSSJC7nd0cv85364KGrt4krCnQjbsOOmKXwSge2Cn3mPfukxs2GoHJ3U+eGm7kQnI69ycmy5bUNRh+g3LW1NMh48fUVMbSXY067zn6RDUg6q/6Sr64P0hfhJWwnoUp/OLdxf5zpVtEYSBOyHAhuccDJkEh0xuDHg4Ako6BL5Z4CC9KdNu6eaqA0F1a7HPczztTARprMHWef+9CNjH2neqbWL67hRw55Hs25K+lFORRKmb5BrTT29VW2Fa+GtlrCRgJB/W6ZMzQgtKYiBaiau0o8lynROK5n/TJrtcqyqoktGHJhdTH6nM1i8R9IsJk6pSOTXJWqqY2fT
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18fbb47a-7922-417c-bcc1-08db8e75dc78
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 07:48:26.6805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bGBpWUw2xMZrbuO+Tn0XGIO5Z/8M9meVqFw8GiFyOiacWpWbm+4npCg8LCzYCpCHrvQfOwwVQSk1+XZSeUM1cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6437
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-26_08,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307270068
X-Proofpoint-GUID: nAX1xchtXK2W55aRO0-UD9pvUgFGFL-4
X-Proofpoint-ORIG-GUID: nAX1xchtXK2W55aRO0-UD9pvUgFGFL-4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2023 22:34, Mike Christie wrote:
> This has scsi_mode_sense have scsi-ml retry UAs instead of driving them
> itself.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig<hch@lst.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>
