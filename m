Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E97C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 18:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbiKJSWM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 13:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbiKJSV6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 13:21:58 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4235F51C09
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 10:21:58 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAIK7PS000943;
        Thu, 10 Nov 2022 18:21:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=XJNs61XVQvR6NBEmbl79PPa3VuQNux3xXfzBHbmo+3U=;
 b=c1uDzRzMXqJfQcfjwTSSYUOhFzbZr18NPjMAWq/6RZ0LX9RjLmAwKPVK5Z9kyUGgq9ka
 +B/ul7jxWeqwq8v/MhspIThzUtLc9yh9Vh0Zfo3P8vj0CEEisHcOt43HYbs9s7MGvX1n
 0AGWIk+IDUSW0fUpIrz4i3YXAKhA9Vi+E/p479dA4gunqyG2F4+IMqMSB8YakhTfgS6x
 wIi0K5UAv+Ao3mLP14WYI7s0uDpy0FP2bUtusGOZVQyGBpBgazuI2BZqAlmFaAeHn1Uj
 Bh6jnCiJEjBtO66T/8gGeyKxtJaPmgGQ2JkaYAs9DeoCqXekYGD/V+RFYCmXd99S73By Rg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks6fw8016-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 18:21:42 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAHS4fW038080;
        Thu, 10 Nov 2022 18:21:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsgwhmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 18:21:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcAadRSgomCOXreFTmsk+E5yZaVz7DONNAN62IRYS7cMvoy9l4xuP8a6Ibf1vKUkmADBBytlTi5bQi8ePp5Z6FbXTYDQ+vBFEdOM4KDqKWh+LTMaG09yCtR76dnuAFH4nDbZzn5txyOPlTCmqyp7nlGbONcRmEs2jfjQaVDJ02eEoIhYNAN4sHkBMqRP2LLEZJSXjmDoNnRBJcI2x9pkuKblB+2CQcGN+5+uEZHC8GZtnp3p2v0dvY9sY62hpVgvudZfLrzDx2i3BVLm5qF6iEXlT3jVRieEd0YwecQ+qtMiDGRDbfF/3QUxZ4pR228OVtMBYvcgDwCUCOch97AvXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XJNs61XVQvR6NBEmbl79PPa3VuQNux3xXfzBHbmo+3U=;
 b=jfX3x4lPRzIi4YK3p2CfHxKc4UBy8fUxbykZIpVbATIHKsd7kuK/82IcYAYUgNiMUGWRQ1aqPGkZWQY8xTAWevt7R+PpDmaa+45eu8TYckPJXE121uZ5Awznts6KWzdrWibw6gjQypoduGqQGjgh3gfkWH1vT16absn2EokRvxMks8XPTs43n/5Qe/5s6rJf3FqcgX6/Bjl71Gvs+8QxbxMPhtyZdR2WONpn2mMkCW3Q2Nd+Kl5faRzVEAZrqrJ5LVxFPZ4XfcMrQ9A3BbhpSW6i4yQ3WRvc98mdWsmXUZPGxFMx2S/PmKY65edFgG4SmHYNWwAut+Q9vxU+g4AA5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJNs61XVQvR6NBEmbl79PPa3VuQNux3xXfzBHbmo+3U=;
 b=xYutadegk05EfDkpc1MgSaC8Q31rFgI/QJjYv9W1zLw1UhyFJxALqBhgxVre59Ybrv7vF5OfSoZD57g+IMskH9PIdeowfMhVekNfL6HEtCDdIe3yXBPKrWiLIPIxqk+FXDUTB1t4x7CMnc4tQTi3BcgA51la8px1QOczbArcQK8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5791.namprd10.prod.outlook.com (2603:10b6:303:14c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 18:21:39 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 18:21:39 +0000
Message-ID: <63eba080-7d43-58ef-5c84-c93ac0ffb845@oracle.com>
Date:   Thu, 10 Nov 2022 12:21:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v6 03/35] scsi: Add struct for args to execution functions
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221104231927.9613-1-michael.christie@oracle.com>
 <20221104231927.9613-4-michael.christie@oracle.com>
 <1bd9df90-fda6-270e-e437-e1039a0a8b76@oracle.com>
 <13010fb2-13df-ed0f-031f-d65fdc4738f7@acm.org>
 <8a525f2c-c892-e1fc-a0ec-aff6de746855@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <8a525f2c-c892-e1fc-a0ec-aff6de746855@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0291.namprd03.prod.outlook.com
 (2603:10b6:610:e6::26) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5791:EE_
X-MS-Office365-Filtering-Correlation-Id: 9aae3074-9e32-4659-8bdf-08dac34868f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LqRU5ILAMCfjyEsl7stoMRtEbw3W+fbqgeG2ZM1XHLqNp43IzfRBcdubteKr2ImlFBXvS+9snvsrMWIa8O7SG+hjOUSByxVv4XnOto9Zbn7+Ona3oFCrTsy/hv+tax1ILcT3+Ex2YB/sG0hgI5XM95MKvWLdQ2TIB8yrCVSMuyS/huOCdNJyJy77eSgqwwwb6sZfe5bej3kRmk0SM9M4DYqFAdt5kBtBmjPFVVUwXVPGNQH5VsL4Xb1r1dGFxZdajem7z9HxNY9FpP6uFVcDyDqcmrh3AUuGd8jjNraDQkuJVqJuMCsiqg7/lXtg4ZurRZljHLwB7vYTtFDf0O0F0wQ6JkrezNLxiuU8pbXCwmiacbmOPH3MonoqsyOconoAINJR9JcgvgJ54mLA8TjGB+5+YG3X3h/js70lFp5wpv5o7Z147TKrDlbdheHTNitaqH1rzb9qYVURe6/UIY88GZaYpX/ieRg38RPKxQivYRjF8FiAA16HuM63OMDmoiczE2a3xwceN0Hf/yhxB6sglIsON6IOF19Qf5f4LlAKDJO9NzLRHNlAYzhvgbmzaHvy7HMzseTRs2EsZSlmxxu91DEptGDazwEZoOMA4G/JWJR70P/sMeK+fn2vr/sQiFcRlwn70vxU43lAOuIO0bx9mDokr9Gn05eYFr17WiI8PyMPMx5HSxnKqV+AbA1sqz4zvp+uQFEnYYrVOmZyxvhFTjZxFIdsbqz8qzEK/Qszpv7Hobh9fpDry3110+JCEh8HS0XkdlkQtd4c89vMwPMm2IyVQy3c6PrIFA/E19hYh6o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199015)(86362001)(31696002)(38100700002)(478600001)(41300700001)(8936002)(66476007)(6486002)(8676002)(66946007)(110136005)(5660300002)(316002)(186003)(66556008)(2616005)(53546011)(6506007)(2906002)(26005)(4744005)(6512007)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGpIOElTNzQwMTZBYk9oU1d5Mm5ONU5VN1QwUmNMWjZxMnhhSnpPVGJKSDFO?=
 =?utf-8?B?eXd4NzkxMWhNY0svZThrTkdsbVBrelBPejRZZUN4WDhSQUpmNWZXOXNJNEw4?=
 =?utf-8?B?Qmtyd1IrVWI4M1Zic2tLSDYrYzk5R1V2Rm1mNFFlaDQ4SWlGL1R2bGRJa2du?=
 =?utf-8?B?U2cxZmVvRzZ0NVk1UnYyT01DajRES012bnpaaVI4SXFGMlRRWG5pNGJkeXdM?=
 =?utf-8?B?Sy9oMHZhTmV0b3F0UkRtMVdIVFluQTVobmFVVUFoSmtmeVFqMjhuOU1YRGk4?=
 =?utf-8?B?UktDRWQzcGVPOC9jWEkvdGRvY1NsTXFtdzlMdFdpY2pFeVJEY2FlNXdVSEZQ?=
 =?utf-8?B?MGNyUjZqMTZiR2FGcTBtek9qSnJERC9LYmxrWGNEbUVrNE9QNjN3UFN3djJR?=
 =?utf-8?B?a2ZySkRlbVptWXlsK2JVSndjV3Vwb3NHQlF0cFRaQVJWNFF6bTlZd2xtUmlL?=
 =?utf-8?B?ZnNnY1F0L3NUaTRrL3JQK2V1TGtiQ05uZ1U1ZmFFcXNOSmRpc0U2UXZFdDB5?=
 =?utf-8?B?S0lDUkp3QlIyNVpGQjZ1VFczNTJON3FJMXVyL0YrYlNYc2xMZVY4aEhzZHFi?=
 =?utf-8?B?K0h0bFE2cnNsYkpwVlZON0o1T2JqeHprWWRxYUc0N1VhRHlIdDlLbEs5QWl6?=
 =?utf-8?B?UDliVjhkdnB4dkVGR1cyQnJVT2JhU2pTZDJZS0JHVUg0UVBnQlFvWklieDQz?=
 =?utf-8?B?eDFqeDhubjRpcVN1NkF3Ui9ZeXo2c1BwUVRoRHBndUdSMVA2QkE5ZUE2ZG5U?=
 =?utf-8?B?UGVDcGl2eld1MURSOVMwczNhVnB3VXZLZnI5Qm5QbkZ6aDMwWS9nc0EvRVRu?=
 =?utf-8?B?dFhFbjdqa0srNUtHYlVsQ3ltTks4aW1FUE50c3lPRmZKQXp6WURyYlVCVWdm?=
 =?utf-8?B?YXlVeUZtdW5oRzlVTUhwTWtWdEQzN2FRTCtsSUd0TFNrMW43YmxEaEdPMGdz?=
 =?utf-8?B?OEVhWU9aT29USHg4VlhiYWE5ZVBrRTVoVG5PWjA4SzFqRnBheHc3N3pNYWRk?=
 =?utf-8?B?VHFlY3JFcWdpNitxS1FDMlZ3WlRQMTFSTkpYcllvaHVUemNWWEN0SFZXeVpi?=
 =?utf-8?B?bmNLdWkvNTlKeHFWM3FNcFJ5L1NFdzRTZVFxYzM3NkFyeGx6TUd6S25OVG1Y?=
 =?utf-8?B?dzhSM1hsU2xsN3QrcnFlbEJuS09IcmRaS3pldnhZeGVha01YaXRoVVV1eTdl?=
 =?utf-8?B?bWh2d21UMEFwTnAvMkVmeXZvNitKZXFoR2J1MTVSOVRleE5mOTN5WHM1bVRW?=
 =?utf-8?B?SFBORjMyaDYrMi9Ock1McDZ1TmZuYnRZM0UvdGtMRDdMQWR2dlhsWitmYzZF?=
 =?utf-8?B?WVArTkh6blA3NnhtTElSSzR1WEs0aEJNdmRKV1JJTVZENysrWSthUEg2RjJl?=
 =?utf-8?B?cmNWQlJVRGM5SURBOS9wSURHcTU1Q0VGc1hUZzJML2IxcTlUQ1h3NGd5QjRp?=
 =?utf-8?B?a1N4TC9tVlM1bmNHZ3BRQko3OU90WDBLMjVjOU5QYmFWRktOR3lXN0p3QWs5?=
 =?utf-8?B?UDlyS01sWHhPRWNSYXpLVzE3WXM2VTBXS1pzM00zTHVQaW4zd1E0em51Z1di?=
 =?utf-8?B?ZDhzZGdRRXRDVTgyT1FBZlZtMElNRzVSUUVlbGxKUGh5NVF6dWREUkxZSFhD?=
 =?utf-8?B?S25WV1JZWXFQQ1AzTDE4ZHZBb0ZkWmJIakxWUjJYbXhKOW1qR0ZaZU1qc2ls?=
 =?utf-8?B?ekFtWnM4SHNPWjdnV3h0dm9Nd0l5Umxrb1k0RG81R2ttNm1BNnVqWTBxNFlq?=
 =?utf-8?B?bGdlQmptcTdKOUZKYlZpQmtsbVJrajJBVkx2YUdHS1EzV2NlSUE1WVlBUGU4?=
 =?utf-8?B?U2EwR2dORCs5MW5ZOURCSlNKaUFFRlNWL3IyQzhTbkZlMncyNTYrSVdLZEhI?=
 =?utf-8?B?WFIwZjhGang1bi91Y3BKeG1oTkpnK043aGk4REp1WU00SHJiM0RIdEtTODlT?=
 =?utf-8?B?TnYrVG5GN1ZINUxzbTN1d0QyRGdnZkoxVXlvUEwvdHBxam0wMFk2YTBZWkQ1?=
 =?utf-8?B?NVNSZHhTRkZBcjZNMkNpSnYxWmExVWtsNW8rY0lMMVByNGNLYnF5dVVvMEpt?=
 =?utf-8?B?Y2k3Z29VSTJtVis4d3I5OEJLaHpHa09lWHZnNktrTVhnTWkxZ21jaWJDVUxm?=
 =?utf-8?B?Y2JZaUJaa0xkdk1xYWp2RlFneWVPeFNzUmhKcXFTbjBzMUloNHl1OWRXWTd0?=
 =?utf-8?B?N1E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aae3074-9e32-4659-8bdf-08dac34868f0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 18:21:39.2940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z2CDyEXhEzhNrTA+Mlal+wbIvFDjhVQWO38f/leKI7EGC3cH2PDix/dh+Ur8ouIYz0Aiydssilo16y5U7b4XyoT8WCmafcmpJrrCcNxiMdo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5791
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_12,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100128
X-Proofpoint-GUID: Nt2v7X6qjNytZeYy2moqSBMrK-YkoQrG
X-Proofpoint-ORIG-GUID: Nt2v7X6qjNytZeYy2moqSBMrK-YkoQrG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/22 12:09 PM, John Garry wrote:
> On 10/11/2022 17:26, Bart Van Assche wrote:
>> n 11/10/22 03:15, John Garry wrote:
>>> Current method means a store (in scsi_exec_args struct), a load, a comparison, and a mov value to register whose value depends on comparison. That's most relevant on performance being a concern.
>>
>> Hi John,
>>
>> Is there any code that calls scsi_execute() from a code path in which performance matters?
> 
> Eh, I don't know. Does performance matter for the touched ioctls or probe lun code?

No.
