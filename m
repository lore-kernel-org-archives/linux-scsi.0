Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E68AC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 18:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbiKJS1G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 13:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbiKJS0u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 13:26:50 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E43B1F5
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 10:26:49 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAIHVlR013460;
        Thu, 10 Nov 2022 18:26:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=dA6x9tBworEFlSFGvtT2YaNUqyVcZjkz95qmqgAOsZ4=;
 b=bTNh7H7c+p6vzo9c+ry75PPThQgMWaMv/KLVn98te2rqUJAdo/cgUK5JZHeX9BcLgGkI
 YV4S8QuQVbMRfIICiIHnicjtSKHVmIoyJ6p4lNMoa9xUIMJg/8lCuox8yKFAs1fKMjE5
 Vhe33yOYPRX+C0r2zlf3pOfNqk6Gwxug4QBOrwx50TtCJewVqdB3KbJUsxPQpkQP8SfN
 +TM/k5Yvr7Yp3Ds3qti6EtMGzF6ekNEWs5bsfCZPFJADlDa22OQQYrKkJVhuSt8UMjwc
 Albi5fhvfvRf+5fmQVrmQ0wH9GEqDaUt3+lFoYxGuW1n4KEu3vz50DiRxdxVS75xpfox +g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks5pur5sa-59
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 18:26:36 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAHZvX5004127;
        Thu, 10 Nov 2022 18:09:38 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctps8tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 18:09:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LPUAnXpQXhJqqRz3wcFXzM5Yx+urWLiyIdnjDetx1UQIn5fgHA+8czwjpeCIEbCd9dlY9jeiM9Px46MzH5sy1tHYw4L4OLytBLy3dk5uf1DvNWx2ljrRZwl+i8lJ/XAD6Ky7kBR0/syWbBi13xGbf+fw2kkF7FfFnhhqFpfCyE45MqzL+SOK1NLpq/0e672l86xI4hG9Id7+Ori0xg57L+epwqbDke6Xj3pZWDGQaHNtTYuIiukKGzR2HwsF72R1DRmpM6tpppoPWDtfN4hbKuvpQFh44alTFqaqeEXEM7UUwhOxw0LzWQFsVgtHxk27ILumtQcg1VKnTdbDEq5X8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dA6x9tBworEFlSFGvtT2YaNUqyVcZjkz95qmqgAOsZ4=;
 b=YYBsRyTNw3uVFcVzwMqpd6uIiOrv2NfpPOrk2TE7lxlYYzHR4cF0KIyfTxVdCa+ejvIdgfhdN8yUlR5RpRctZ2cV1dVBVSpLKVuS66CBGhSlQ0oofaaGRoFK9WV3uwLvCLanO+sDvbuSdq9vGETAkccBfIxg7YJW83zC7uA97iNR4vJy62XQmdKjJRG1GEzwbHSPjCwy1ZuPqtOgKgujCSTZz87ZQO+w3dSkKcJlnsZ1m4lvkd7jXuRn7Cu8ofN/g9Y5nW6mHHgrl9Urf3zpsvq5npJFViMRtkT6GhohfR3xcHdpoFJ0s8Ymbg0MvLMmN3H3gHA2wF8OG1k3k3rlhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dA6x9tBworEFlSFGvtT2YaNUqyVcZjkz95qmqgAOsZ4=;
 b=BgB3Ac6rEEv4W+cuqk1CsJ5WxMNg6yzJl3Bj4BzsVJaj/6FTjdQiJvV0202ef4BSvz+mXkMS/2OMSo3g1X/XsfvyBIZ6iakstD+DaU780d3kcq+SiVkcsMquKex8pxRxKO2CdYK6oawTgvwqdxjhbUV2hV+ro4JYk5DOCLwAxes=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4278.namprd10.prod.outlook.com (2603:10b6:610:7f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 18:09:36 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::d0c4:8da4:2702:8b3b]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::d0c4:8da4:2702:8b3b%5]) with mapi id 15.20.5813.012; Thu, 10 Nov 2022
 18:09:36 +0000
Message-ID: <8a525f2c-c892-e1fc-a0ec-aff6de746855@oracle.com>
Date:   Thu, 10 Nov 2022 18:09:32 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v6 03/35] scsi: Add struct for args to execution functions
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221104231927.9613-1-michael.christie@oracle.com>
 <20221104231927.9613-4-michael.christie@oracle.com>
 <1bd9df90-fda6-270e-e437-e1039a0a8b76@oracle.com>
 <13010fb2-13df-ed0f-031f-d65fdc4738f7@acm.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <13010fb2-13df-ed0f-031f-d65fdc4738f7@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0053.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4278:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e540936-37f8-44cb-796a-08dac346ba06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ldIjpvDl4pFrs9JO5VwoLxqV1jvT0e/JXPCnoma8LHNPDZBtvWXuf8IZe7GqDZazpHi67/WtgMilyyLFXydXD5+Xzqs9r7soMJckH2BcZmsQxs2gwyne8F70NzbnaPe1rrW7PinrymwWtWciz4QAp8nz6Jj0JmjHUXLHZwdjW22n63aAi65YArIAyTh6ZraiehVPQufsmM/vE7h0lhEpks+VoUMfWJEFROO4LSQB0ZaAI6lD/Ed4IiD/f6+uaSsxDXZ/QO7h04ZJpM19QINFI0v2pRZRzFZOK99gSIe1m/STNM33ICi6WuakraB8+oVbFkFFaCFFjtjr+ZeekzvjkeHEQnrzdo0J9dymoH3XEopsWY0qs8LX8ROQ/gJwL2AX/+ubmNyoIcvDWtc3hiipOw/LayWsWFV0z8aqPlZSgUy4ZkzzpLGV6HK5k1+wjgU6s8sqRmT8FVhPUXaO3KWPhzaxK/4Zd1wlGdARDnr8+eFoPLYxFSxXrqAv8fUUJYu612aY+fZqU86NEMWfoJEV1Eo92mZV/4gWAlQN6L7Z9FpV+v/aA7V9K7TKrKd0ZEYxi6MvxYM3rh7kFi9GxNcuOAdoW9UAK/TnBhaYF+xKQR026j5ZeUkGtBS23yBZsmC00iHy/H0IAfGXYwP9XG+K4ojbFyCX4jRlBDKTyE7nkyzqqoew25mhJ1lm5UU8MNoVvnN2zkoaGA96UidGtdCBRHDmN74yj3FuAkLp0COVYynWFwbpv5l4fFqzwX8kTQ0fSg5Le3s7PYQufQmJEwjdGCxjCLOWaJ2ovDhTWgrfK4M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(136003)(376002)(39860400002)(451199015)(6512007)(186003)(31686004)(26005)(6486002)(2616005)(4744005)(478600001)(8936002)(41300700001)(5660300002)(2906002)(31696002)(86362001)(66556008)(66476007)(66946007)(8676002)(36756003)(38100700002)(36916002)(6506007)(53546011)(316002)(110136005)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M01HTi8zT3RqeE1NckRSS2NuTUZMSk9iQW5RaDNZck1ycXgyREpvVUFyZ1or?=
 =?utf-8?B?NEtyMTlnb2NCRFlqaGpGZ0F5eGI2UHpNS0lXUDdMZ01KaVE1aHJiMUhRZGw1?=
 =?utf-8?B?eHNrcFlEbUdTemN4ZG94aDQ5NEVrMzlrTjVjR0JobkZoZ2hXNHBvcWNYMWYw?=
 =?utf-8?B?RERzRHlmREw2Uk1nUVZZTFRvOTB6T2czSUlVcjVzdTJ5Tit5bldsekFDc2ww?=
 =?utf-8?B?OU9KNXpLWmViWENtRFNsVDgxaWllVnRKTkwxSjJNMnp6Z2dKZ1hwRytOWW1S?=
 =?utf-8?B?a1hwRVNFU0M4VkhQOFptQlg0bWNFT01mZmFPcTMxQVNZVFZoMVdoQWRqMStV?=
 =?utf-8?B?dFVqOHBETEpNUVdBL3IrRStmV0p2QnFKbk85U053bWljRHB3WnRYSXRROE9t?=
 =?utf-8?B?bFJPdDh1ZGJTa3U1eTdGS3RJWW5xclc5N3lyNkdCNzJKVmVqalRlVENtSml3?=
 =?utf-8?B?c2dsWXdkRjU0STBmWEpjUjZ2aTB0aFovTWdMenMyOHpVY2ZwbmxEWk1xS01K?=
 =?utf-8?B?bG5GNVh0L2RzODVJU1ZyWnV6YisvTlpid01xeURZK1lXMFE0K3FmMnR0Nmlm?=
 =?utf-8?B?c09lSllLZ1RqeUtlaDdnY09RY3Jqbjl3Q2tMTUR6OFA0TmhNV1l3bWVwbkdK?=
 =?utf-8?B?MVNvb0NKcEhUbnp2VVlEcHhGOVl4S2lvNHdIUkIxOENmODFDYXZPNVlHUUhk?=
 =?utf-8?B?OXNsenJPeWhNNUZETjN4bFBRWGFQU3dvRmVQNUVUK2pIYk9PeEI0YTY4cm1o?=
 =?utf-8?B?QWtjQUR2cjYydmhSMEovSldjNlFYTU9FR0lTekN4VUxLUWJaZWdWcUJibjhs?=
 =?utf-8?B?andPMGh4dTYyeHRyQU5xbldsNTJFM3dGMnlUMVJMcml1Uko3TndiN3B2dU5B?=
 =?utf-8?B?alBTd291YXREbUh4SzhmRzJTTFZjK0lvNE4yVlg2Y2Uxei9sZEdiaDhpMThM?=
 =?utf-8?B?WTVNZGRJc0lydnYrSGNBYURQV1Zrc1JhVjBTaVhQUUpjakl2VlorU1ZrRVRt?=
 =?utf-8?B?aTVxR0l4N2FGSGFCMEJYSExONFhRZCt0RWVxZ1NKeVQzc1A2L2VaMEpURE9i?=
 =?utf-8?B?SDJKaXRrUWI1TXBZRzViZVhHQUx6T05lNU1CcVlPRHZXOE56dE1TMGc1UUEv?=
 =?utf-8?B?VUhkNEVMMGlBbDBuVjRGOXJEZ0J0eXJocy9YaitPSzBTQ3FIeTZUd0VOQVVq?=
 =?utf-8?B?dXNtTGxjQkIvdEIzSVl0ZDRCZG5VUVB1K2dXZFJHSXFhRHlJZXczZUZoY2Mx?=
 =?utf-8?B?Ky82YWRXeHR1NXJ4Qm9VUmYzOE9BeVF1ZGJFTlZsZFAyNlFUK1R3SjhzNk5w?=
 =?utf-8?B?Z1JrY29PL05Edi9tQmZiUUlXdFZZTjNMRmJRd3pUbVpYNEhFQlQ5dVV6WEVJ?=
 =?utf-8?B?Z2lPOUVHRFZOOVk3OFNEZlZObjdVbHduKzVITS93TjlUeithWEdBUkJSclNE?=
 =?utf-8?B?Vnk4ZTZ1aHpyQzRnby9EUUhWelBQZUlkN1lsYTFJZlVsWDdlTUZkMGdWWEp1?=
 =?utf-8?B?WElJM2k5UXo5ZzB1V2RPSS8wZ2dTMm5QWHN6NDFuUis5QUQrZXBiTlAxa1hl?=
 =?utf-8?B?R2NXOGlSYk54dHhSRFBhckM1ZVJzWFI4WG5YSlMxQlN3SmY2RksrSmpkejBx?=
 =?utf-8?B?Vi96dWs5ZVY0OTRZQ3ZyMVZ1UmJMazRpYjZuNW0rWkc4VCt3ZCswNmw1dFpP?=
 =?utf-8?B?cmJvK09FL0R0M0Fka3VERU92QXlYTGRGQ1RhMUk2L1hXbjlqZmNqNEFuVmVu?=
 =?utf-8?B?akt3b3RqdDNkb2sraFlQdXQxUlE2TVRDdENIbzlSaHIyMGRkakJhZ0dYWjlx?=
 =?utf-8?B?aVVzbHNkbitVNk5kMmIxdHdQNW1qa0plK1pPdlF4MWt5YmY4cVYxUmp6Z3Yw?=
 =?utf-8?B?RWNaTmptWE9UMVhrcHV6UGNvR0N2ZW8rRDUrWTZCb1dkdTVUc0cxU3g5cWl3?=
 =?utf-8?B?bDBXYlFzTi83VGpFQzhDazltYUtCL3FERkJZUlZwVzlXY3JsQzdXNjBNKzJT?=
 =?utf-8?B?aGVXRGhxQndEMWpUN2pWNWtwT0pkWWJydkRzeUlZMDhlVnNhbmM0b1pCcjFV?=
 =?utf-8?B?bnV2eEpJRE9VYkZWVjdsYTZZbzlmZWJNUDFnMDhjQUptOE1LV3dEalNsNXBO?=
 =?utf-8?Q?0G0ZYd+s9DPlKP7MAnc6nJNjt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e540936-37f8-44cb-796a-08dac346ba06
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 18:09:36.4660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a53JsxXRYbHe9kDGZmxW+o8y0UrofZYFhETQ143ZRNyirGloC5mvm9KVUoP59bxsO28NAQwZD5EaimZUR5JL5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4278
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_12,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100127
X-Proofpoint-GUID: X9zb0OvghsmU1aCYRpYuiyTVNS0fERy4
X-Proofpoint-ORIG-GUID: X9zb0OvghsmU1aCYRpYuiyTVNS0fERy4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/11/2022 17:26, Bart Van Assche wrote:
> n 11/10/22 03:15, John Garry wrote:
>> Current method means a store (in scsi_exec_args struct), a load, a 
>> comparison, and a mov value to register whose value depends on 
>> comparison. That's most relevant on performance being a concern.
> 
> Hi John,
> 
> Is there any code that calls scsi_execute() from a code path in which 
> performance matters?

Eh, I don't know. Does performance matter for the touched ioctls or 
probe lun code?

Anyway, this code I mention is just the same as before. It just bugs me 
when I see code which accepts a hardcoded value (dma dir, in this case) 
and translates into another value, when the translated value could be 
just passed.

Thanks,
John
