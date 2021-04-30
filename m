Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 745B1C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 15:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 482BC61462
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 15:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhD3PlV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Apr 2021 11:41:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59226 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbhD3PlU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2021 11:41:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UFUd41169422;
        Fri, 30 Apr 2021 15:40:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=H1DjXO2CAB7f+P8JHbs9n9SzjFd2ygnHXP+oSYxmlok=;
 b=mvBBZePxdf996pjykfFoqfxEOZItBnru41gqhQntxGC5IJrW66vwbsv+WnJepooax3/u
 rXDotZtMtxPzv2zLvf2OMo6kaJ4rVllPnE7i0Im1WuTtRe/tG8v7TIGHB2nmLtyCGW5/
 rXGcsnHtWgLmkwG3qo2MMSGC3mBOweOjuNpE189QQi2xTA9cmHti/t2In+s4k9VsYX+V
 7O7YLhoeZLj/s9OQDL2ivZxffKP8c+qvntJ2PymvZ7Mc9JVJE1kNZimIpYk58WaO0iKV
 VseYfhPGkTZ6xRIg+fOfftcVr1+tmLPr8p30UPNjBpq05uL1N03D5/yJDZvXqID2cPe3 MA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 385ahc03w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 15:40:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UFV5WR103788;
        Fri, 30 Apr 2021 15:40:25 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by userp3030.oracle.com with ESMTP id 3848f2nse9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 15:40:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nk/LnDI2GUPAgEP+rvkI2qE7WMjs0HRE7nQ96qDajvk5igvXEjHToF4XNoH7Xta5LA5plaCZcywNyRIo3hzmOr1+lCZa+zdjDoUoKD6xKBjgaS1sJhhIPTzAcOhNtTlHAkBKAzqqELG7IZLAz7nSz/B3FUvrMvpirW2dfK2LWX/LI9cUtDYqCYes1HYPMuO8DOsjZVTR1pwjIxvqzm9sb8i6IX3nHdnOxwc/JnUIl0bq8Y6tdLGBjhuzEwuh6GX2WcKheZyEXPrY4mMpX6HksL7ajchmzD50gM+RiQvMsr8KK8caSdacv5uTLpiHylpKGLleh+Vj9XiyonzzNX5a8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1DjXO2CAB7f+P8JHbs9n9SzjFd2ygnHXP+oSYxmlok=;
 b=CtrdUONfgBZpQCxHz+SuZtypmEUSH8/DJ5PT0GPJd3tQABSwsC5ogBlqRt2FghFzYOj5+882NpxF8eh/uUzW93XVGUpJan9DnkOf4/0W92jgm3oCH/AysLn5htAtSYTPynf196qaRGNs8VOEIvstdzznDEFzgScp2H8cNgncRt1mZjVThTGcoeza4mdSH16omRIzyA/Z2ymvj6T/955huHF9jdCHOEENb96XsGYtTwudRuvp15SOi0Q8YQesysOTjDwAB7dPS3d13dzdH7MT8k6XxVOEu8khOnao8m7NtLUyCt6ykA7wk3iD9lSx30tu8MILQOb0lD+fIfwxdP0lIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1DjXO2CAB7f+P8JHbs9n9SzjFd2ygnHXP+oSYxmlok=;
 b=D0RmcJOV16ui84AyLrN/b2aycV6Oq65+t+pGj1nU3wYFSgMde2NQk78anBJOxmG6YWhTmZoROVGSYyhY0prsLaSbDSQ3xCBF0lTc+Lg2BWJpAvAdX1iEhqWNdOXHeMO3MOijhP38VuMjLsg5cOtixmj2tp2wdXCj7sjC6XFk00U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2581.namprd10.prod.outlook.com (2603:10b6:a02:b9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 30 Apr
 2021 15:40:23 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4087.035; Fri, 30 Apr 2021
 15:40:23 +0000
Subject: Re: [PATCH] scsi: target: configfs: Remove redundant assignment to
 ret
To:     Bodo Stroesser <bostroesser@gmail.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1619774627-118766-1-git-send-email-jiapeng.chong@linux.alibaba.com>
 <69ef77bd-4ef8-6446-8192-6d8569516f33@gmail.com>
From:   michael.christie@oracle.com
Message-ID: <90e67d9f-e524-62b4-df04-2ea2ea28559c@oracle.com>
Date:   Fri, 30 Apr 2021 10:40:20 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <69ef77bd-4ef8-6446-8192-6d8569516f33@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR13CA0055.namprd13.prod.outlook.com
 (2603:10b6:3:117::17) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.5] (73.88.28.6) by DM5PR13CA0055.namprd13.prod.outlook.com (2603:10b6:3:117::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 15:40:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9b5c4ef-e62d-4c4b-ded0-08d90bee44a4
X-MS-TrafficTypeDiagnostic: BYAPR10MB2581:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB25810B68FADB22E52C778C4EF15E9@BYAPR10MB2581.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SahnC4AyaO8N/o3Fj1IGoeCHKp/+al6GRrkHGYAii0ClWMHLRDyuoNmbVAcQc9I0aNAWPwMAWMYy4c0yuHAo2cTiZv0cD53g/xZE+CXHjK4UOycaplb9exL8HGDxcOsQw72cmBK1lyhdADlGumxTzGhcTsGdVqKwRGNf0AsrZ6lyoZ6/Ha2MCgcAhUyyiosEVL+7tpgfXDCaYj+2cy0aVgnPlt9PslexzGEiDzQ6Hhs+Tq3ke3UOzDvKlcxwh9JQtULu5jaoHCviN9E88FRXrJVTZl7FqhPsimHkV9PM19XsW3DfHkXJExIBfY60lUi1vMTNxDD2RlKc/1NDAjETON2qjitiHhTs7TOprFIwynRQHTMZPoQg4t292Ztgy9dsYyK5N4uYZmYa1eJ4hXtOsyZviFrgQiloFcc1g1aShMNKfZTP3DH/bDbVwIXZNRoKy+rdd4JmDDDszdZniY7Ykkw65ZGBSgyZfA2djDDgv0RIB6dbynmI4hlgYifW/Auv4kwq7cxLp5867Irx2eO310AR/dUmWbTncWz5kvdg9xVatmh/BVZOECM9JbSfWxB7HivPqG7V2VYeQMIDN1FwSQC+7DSppMEnBflEfJp9Xw5Yq9gJliXnbXv5i1li3cidN6hXi5tbwLuJEKegN1Cci5UVMCEIw+L6IszAi8YLUzWlITxrEsF9MTQftzJjoPj4opLeM8YVp/PyHdCZvQJUXayPbz3ZpNUpfO/XZxJzom7unlD39sX4cLd1p5MF5tv2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(396003)(136003)(376002)(366004)(6486002)(66476007)(86362001)(110136005)(186003)(16526019)(2616005)(53546011)(26005)(316002)(31686004)(16576012)(31696002)(36756003)(8936002)(6706004)(38100700002)(956004)(4744005)(9686003)(4326008)(66946007)(966005)(478600001)(8676002)(5660300002)(2906002)(66556008)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RU13NE81Ukl6ajdiZVhWRS9rMXp6YzhDQ0t6VytmLzZZMk5RRlZQclF5ZFBj?=
 =?utf-8?B?VXVUQ2RHUTIxeE14NCtiWEZsZjdJRUxWNUlYdEx0S0NzQXRTa01rRDhtOUZW?=
 =?utf-8?B?M0dKVHA2c1NCNkNUNVdVcXUzL01ZUWt1YmprSEk0Y280Wm9KbVVyMm13WWND?=
 =?utf-8?B?MHBJQ3RFY1QvK0NVWU5TSk02ZWRtcGNWR1k5ZzZ0cGQxcmlnbC84MC93aXJm?=
 =?utf-8?B?L1FqVUJBNmZPMUE4dEFHaWlBbGVGZnVmUnJ0aEJWTHRMcHEyd05ZTkNuT1BQ?=
 =?utf-8?B?Z1VJS2N2bURXcUJEcCtGM2FzUHU0MWpvcGU1ZG9Da29QSFY1cU5ab2NGTEJo?=
 =?utf-8?B?QzJWa1JZREUydktmSjRtT1RNQzB3eGFOMG9IMkpFNVl5ZmtZY3I2akdIdVBs?=
 =?utf-8?B?REluc3M0UDNNZ0VyYmZpSThSSUJMRnA0akJrR0o1Z2E5SFN1UUFnTng4dTJN?=
 =?utf-8?B?K1RXc3pYOEpSYmk5VitXekU1akpEbFhEYmFPQ3FzWTFkQjd2Mi85ZWZ4Mmcx?=
 =?utf-8?B?aVRLaEZZSWVPRnlReW56RDZCWXV2Wjc2OVlJUVpkRnIzc1hLNC8vdkxQSmtM?=
 =?utf-8?B?RmI3elhveEJSMDNTMjhyRnI1TWIxSytJK1dFa2NicHh1UExQcmFNelU2VTVQ?=
 =?utf-8?B?R0pGZ3lna3ppb2hHMTFpMlFOTjREdSt3aGJEdXVJVzUyZDJwUjZLcjkyckdi?=
 =?utf-8?B?ZXFNeGwyRzhDdGVGMXBaMCtEVzJ1Q0ZvUXI2Y1hzYStPVUY4ZXM4LzBOcnRP?=
 =?utf-8?B?YXJmTTB5cHQ0M2xkQk1CZEw3VU1pdlQrUlRVZ3V4NjVZZzFrZ1pwQU1NVTU3?=
 =?utf-8?B?cHEwYmxvQ1hZMXlhY29nOFZvREc2eW5DZ1dGdEhEWFF1OVZIR3dKUFlCV0FN?=
 =?utf-8?B?cExjcFNEMG14blh0cC80NnZWWXg1NEsyU2JNTWdYOW9wd0RjUndjMXdnRjhv?=
 =?utf-8?B?dzRSOFZKQ0NzZ0RTNUU3N2J2SE9hMHgzY0NwK2lYTkg4ZDRhdWpoaTk2L0lW?=
 =?utf-8?B?MmswSGRuaUYyd2ZEYTR1aE51LzNwVy9CUkxXWEs5STNEdnFpNUwrblRGVFV3?=
 =?utf-8?B?VGs0K09nL0VQK3dMSDFqMDh4aEFIbzRLeGpoQXRFTHlsQnZIdXRrZkR0WXlG?=
 =?utf-8?B?R2M5RmRTdkxYZzZleVZaam1yRXMvUzBvUjRFWUR6ZTkwMW1JL1dPMGJOTm5R?=
 =?utf-8?B?R0FhL2NpTDVHTSs1WDVGaTFHdHhlSTZxdklrMjRtQmxrZHNmdVJxRG1kQWRI?=
 =?utf-8?B?WUFrTTlIUzhTMjBKTjJnZDZHYXlGREVXV0xpQjlMajVFVitiQUpqMHBFL0dr?=
 =?utf-8?B?TEM2UEk2cTZnZ3JMaFBxcHJaa1VIV1BVTEgxelVBN2o1MTZ5RVpURTIwV1JQ?=
 =?utf-8?B?d2g5Umc0R0Y0WXNLNG1nVEdOM3N5R29kcEpnMEZjSjA0dlBlbmwzdnJUWGFB?=
 =?utf-8?B?c2M1QXZibUJBbitkUGlJc0hRY29SeE10M1JmeTd6V1ZtOEpMRnhOb1dNSVZo?=
 =?utf-8?B?QVk5YVJ6bFU3QUs2OU1Od1FXb0dQQjhUZzFGMFNRUENZRjRsUzdTV2RXYjdK?=
 =?utf-8?B?cE1sV0tRZHFEQXczMGpnNWJWaHo5OUViZlVpR1FrcStCVXVjYmVDQWU4Ukdr?=
 =?utf-8?B?N2JKb3l6UVFhNzlRU052ZWg1b0xlYjAwQWFNeVdGL1JuN0tGL1Z3RDdpS1RH?=
 =?utf-8?B?U016RjFuTkVMYWtFNzhwY1c3Q0lBUVZEWFcybHhJeGNocHFXb2ZVdWI1Tjdl?=
 =?utf-8?Q?K3haJvkSOkPLU1gDtjMbnk6N4HZ/gY71T57ytkI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b5c4ef-e62d-4c4b-ded0-08d90bee44a4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 15:40:23.3412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tyle8dx+NTohxyw/xZI55kG8SfveN89f5YFi3UUmhFyPzlxsKHZ7ROfSdAK5fjyD8kUqQR2Gyh7jMPIP3Q8QvHBCraKs6+Xl91TIhdR3KTQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2581
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104300105
X-Proofpoint-GUID: JB_Ib7CDaUG2UsCpo6-3hFXfK0TQANvT
X-Proofpoint-ORIG-GUID: JB_Ib7CDaUG2UsCpo6-3hFXfK0TQANvT
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1011 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104300105
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/30/21 9:29 AM, Bodo Stroesser wrote:
> BTW: why is "initiator_sid" input handled as string?
> core_scsi3_alloc_aptpl_registration later calls get_unaligned_be64 for
> that string. I don't think this makes sense.

It's broken.

Remember the isid patches that you reviewed of mine trying to fix the
isid code in target_core_transport.c? I can't remember all the details but
I think it was that the aptpl code thinks the buffer is in the format that
sess_get_initiator_sid uses and is trying to do something similar as
target_core_transport.c.

I can't find the version of the patches you had looked at. This was the first
version of the patch:

https://patchwork.kernel.org/project/target-devel/patch/1531696591-8558-3-git-send-email-mchristi@redhat.com/
