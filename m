Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C23AC433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 17:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2294561165
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 17:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234310AbhDIRer (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Apr 2021 13:34:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44756 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234293AbhDIReq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2021 13:34:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 139HStj9132288;
        Fri, 9 Apr 2021 17:34:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=NfMOvN5w7ENMWjaqSVJB9Pds9X2WTVIegIbTMJXJRnE=;
 b=o9hpcZdnfmVunhEr4Sajz3h5kqMvlfSh1/Xw5z7vbL0jDoOVOSX/Z0hlevPI6/WmOvta
 uW27HM0DwDtAOUyJtKM4TOwWkLWXyi4iYnwtig9rjMIe+uOiN/1JKPNiBigVYVT93Pmr
 gvXxNCEOKji+7UrtdZ2eAervr0pz45RvxHVwr4cWtkxn8rwZSt2YQXKbEonfJ8axcU9u
 XpfGAbKJkO/v5HtsAXt7Wf339PQoLE1Mre2BHJaUrH4PbfmwGeS1Lo9aP7OLbtj2BHeL
 oAhs1obM6tC7iHjbQsrtogOpLPbae4UBT4tBOEj1UllsjrDnfyaFMu3nvJ5U5ZT8P9Nn nQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37rvasa63e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Apr 2021 17:34:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 139HVQR4100443;
        Fri, 9 Apr 2021 17:34:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by aserp3020.oracle.com with ESMTP id 37rvb6ux0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Apr 2021 17:34:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYgvBoJoQosXHVqJqMycN6vX+Go/d82EZ73LUptyz0AaPq5MivRk3LE7cRxEm0OumLj9WyZcE9AY1UjKXua31ygKatlVY3NGYUUQca+zcix4r+7Z49VhO/iwdRUDfwVSvjGuNQuarBlvMnm5krbmjV8hx6qDSnuu+lbhV9SOc4ysvkg3QlVEIeztrnxQkYFJO4HkJjfJzMAhqbybiKtq74NDP90z4Oc2mTnkdthg1XYKL5jNRvkhf3WnjA6O3MBsCsjVUmqD0ezO1eWB+QK40PTP1T4uvhWg4vYfpIfM/Rxh6m5WKNGU5EIHYt3xlArxYOhsori4K/gHc3sSY0kH1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfMOvN5w7ENMWjaqSVJB9Pds9X2WTVIegIbTMJXJRnE=;
 b=IIzkEudlrlqjWGR8Sycod7AfWg2nl7MajDNaZNbYYwxLvquE0ITWJHuVcWOYYyCSvHO5U5ew42WwKLDhmVBpkKUt7ZcBqNECeYnf1YCmteDgsnz8iiKwhEOEQJMv51vP4R7yCbCpwCAmU++BwjhaahA+kPBbOOXyg28aMcrDPtZwYNghXe9lYQuK4CnII6IX1a5PvxTfxkZZw9CKlp8LGR3ayXqFb0UVUWAT5H08qqPLicsK+GJSUckQPtO/F0NP7bB1hum9qvV3bcOGB9XniA7b9ATOALH4TJQSb3WtoWAchdwubGSwtUJcAISOiuQYpZuansiao6cUlOcIKS42FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfMOvN5w7ENMWjaqSVJB9Pds9X2WTVIegIbTMJXJRnE=;
 b=HUV/Dn2F1d9+4xVobwPY6gIaaqpSL4MNyHT43T8RwCBiL3SPtzsW02/2JeRuippWEKLcl2J4VuovygDvJek4S2k5tC9mECPag14Ky05nV/nYUiNxJxAIB/DBbs8MUToZQ5CC3cV91nHV2w8TjxyYUz6JDr0hN4nQH3vl81d2WBo=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3128.namprd10.prod.outlook.com (2603:10b6:a03:14e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Fri, 9 Apr
 2021 17:34:28 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Fri, 9 Apr 2021
 17:34:28 +0000
Subject: Re: [PATCH] target: core: remove from tmr_list at lun unlink
From:   Mike Christie <michael.christie@oracle.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20210407142140.29947-1-d.bogdanov@yadro.com>
 <f8182d4d-449a-eb00-7564-a230a1daee8a@oracle.com>
Message-ID: <0cf306d4-5a4b-e4c3-f14e-7165cd4a1503@oracle.com>
Date:   Fri, 9 Apr 2021 12:34:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <f8182d4d-449a-eb00-7564-a230a1daee8a@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR19CA0029.namprd19.prod.outlook.com
 (2603:10b6:3:9a::15) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM5PR19CA0029.namprd19.prod.outlook.com (2603:10b6:3:9a::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 17:34:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a04a548-4c68-4f23-de42-08d8fb7dba38
X-MS-TrafficTypeDiagnostic: BYAPR10MB3128:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB312801DB8DA38FD1BBA851BBF1739@BYAPR10MB3128.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CI+Eai98UbfqOM2wdks7KLyi1IdmGjd1No/DuC57hceXQMginwQkVA+ZJA4jkME/vK3cjtDJoOakxxNHgVKafKurpPLcMZ9D2Km8MU72OUiuyW+SSVi5GD5JYNT3AnzJ/im8g1++Ou/IC7ecNEytk2j8JQveZGCS0K17bbVRhz9ri00URZPNUy8eZGCx1e9+Up9z7zQm0UzASg4jM1xo324GZUxU/3sekKKpzRCtcFw7o08Zjew2vMt5QbjDW8JqQ+pHDrxAbAv+H27XU/Dq99r6NuNfHA+hkkbtRESl6NCy1KcBunq0IpXCwFPScnLrOXTm7POU4vcki4aXo7bEXPj4KtmHIjnav9f+HB5g0VorS1aWcda9ruInfCQ7N48hUiy/RKnKuwcXctPojK3yU3v3NX8GcKtK++bJ3Lqvs40PWbmNNVIWS167R97V5W5ulxv7cZGyFHLQnjwh6NeyPXE1f6Zx+OH/vyUw/0JUWL2GBqIsWBMzjiFTykpXpbRhfK+gE/QW29IDhvyxi+3xH+cTEY6yjzjbOOeKXWodM3GRyPL6kg3FMMpRsxMuw51ibr+o9SzQxPBiyoRXOxKN7XjXNW5ZYcC849VRraYoACqMlkaEkZLQ4aWwmKVk7KYVGTSdhADd5V+a28Np2ZtzXvyxraCQM/FyhB55qVGFTcbzwLPT3C6oVnjNlo32OXy9kwsMHEdMIXfrBY1yK7bo5eoYTiBvzj03FK3+ES2EYOV/kvhq5l63m8oa4l9kz5rcgWROodBRUR2iWybBxV38WZjlOXTERiIlRq703zQigaF+PynEBJ9dKQu+PuYn1m8tNP+Sdg+b2lgphjTDu5ZtLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(136003)(39860400002)(66556008)(966005)(478600001)(66946007)(16526019)(8936002)(6706004)(66476007)(5660300002)(8676002)(53546011)(6486002)(110136005)(38100700001)(16576012)(4326008)(956004)(316002)(31696002)(31686004)(2906002)(86362001)(83380400001)(186003)(26005)(2616005)(36756003)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?a3JKMy9GdHNvdGg5ayszNm9xOGFwYTdGTnFjdmNYYXVCZ2ViZFNCdmt1dEVT?=
 =?utf-8?B?ckRCVXFLR3M3eVA1a21NSittTitNRVpGeTVwbTJIR1lUQUkxbDhBbTBSeUF4?=
 =?utf-8?B?MGNIRkorWHA4dXpwTUwvWnk1TDUxaDRPWjB4ZklzNk9EbnM3QklQWG14MEhm?=
 =?utf-8?B?T2M0MXRjVTZNbGlLVGlBQjJmU2pCR0RmZHpTaHVMNlgvT2xtK1N2aFVjZmxk?=
 =?utf-8?B?RkM3bEFJdSsvWDhFRDlKYUtOclNWMFBwUDk5ZTJwZUFnUTlENlVDN0xabXhP?=
 =?utf-8?B?czRDOHU5Z1NiVld6SGtiODRoaURSdURLL0Qyd2dIaTBoaEkzOXBaek5jTFM4?=
 =?utf-8?B?TmhsU3BTZUtwdmRLaHc5UGFLeDdqaUlPNWloWFBrUUQ2OVRScHRSVDdsRTJj?=
 =?utf-8?B?WUI0VjcrdUxVRnhMYUp1QTVRY3dmdGNIaWJGQ01PMUVDQmtqQ0RjbUwvM3FI?=
 =?utf-8?B?V1BBdmxzU01SYWt4NGpTY2E5VkVOcHBGTjdQWCtNblI4TTd0N2piMWJiYUJS?=
 =?utf-8?B?NXF5bUFRdC9rY2tMMUZCS0UyRytDdWsxcEVGY2tCeUVINjlhWlcyOW9oNU9W?=
 =?utf-8?B?UU5CcXhCK1hFMjRLTkFkZVhwNzhWMy8wVExqM2NhbVQzc0RWREFNTUp6T1ZB?=
 =?utf-8?B?R1NEWUdmN1QwVHVELzFNcy91eEtUK0REclR0d1RQU1p4MzVhV0M2cDRjcWNB?=
 =?utf-8?B?K0RTNmswUDV1RnRQR0Jyc3lpTUFVeE9DS21pR1BzcUNYVXlSc0NnV0V2NkhZ?=
 =?utf-8?B?NVA0KytidEJZODBwcEllM0tWc0hQUXBIYm9ORVNwSXFZK2NNdVEreVFMOHVK?=
 =?utf-8?B?OVdqNm1OZnYzOENyTDFiaTFLZWlpRThMOCs4WU50R1BtcVU0aEZSL3BlcHJ2?=
 =?utf-8?B?a2Z6WjVjVmsrellrL3kvak9acmRaUThuY1YvbXBsSzJ1YnVwV3Myb201MU9s?=
 =?utf-8?B?VVA0Z2dpZjU3Y2dIc3BhZnBwQVlWTEFqcUFJWG5VT1FHM0M3NG1KVFlKLzIw?=
 =?utf-8?B?L05NTTl4ZW5pMSt4WWVGWTNXY0V0WTRHRUY0Ry9nRjA1amREWjc3M0lIREZs?=
 =?utf-8?B?VlFLMDJnTTdNejZ5U3Ywc3lBVlN4Sms0amZMUWZoTnhTZms1VEJkcDl3VGtv?=
 =?utf-8?B?N05ocVhoeEw5Tkp6eGFDNUdxek16NEZlamgrbmZCQ3R1cXMwQkN3eUpoaGJI?=
 =?utf-8?B?ZHBYRm1rZU8zNU45S05wT2JIMXZhYXJaamdFdjF3ME9iRzdTMHdaM0w4RHJX?=
 =?utf-8?B?NFZ2N2FxSUZHODR5WGxjVDdPVVIrWEVEWTBPck84Q3J2Rm14aWJ4eTFucXBy?=
 =?utf-8?B?QlVoejZvdXd2SkVmRGdrN0k1SzZ2Z1BTUVhXVVNrWFVCQldvSit1Z3d3alU0?=
 =?utf-8?B?MHU0NjBjekdkZGcvQVBIMzRMaDNTa2xseWs5Q0RBUUhkNExacnRPMWRNaDJD?=
 =?utf-8?B?YURCUmtHZFlDTzVEbkVOVkNQdXlVR2djck8xTkRHRG9HRlB1bGlOWXhjRHlz?=
 =?utf-8?B?R1FsdWVpdHZScDI4cjQydW9odFBGdFpEWmFFN2puUEhuMEZRMk9pSXNCL0pW?=
 =?utf-8?B?Nlo5VStXbFovdlA4SEZjclAyelJlQTROK0V4bWVhN1ltaW5acUg1MThZNVll?=
 =?utf-8?B?U3dHVnFkZll2cW5CaHZ3S0dYNHJKZ3BIbEQvYUQxM0RDWkg2SGpLbTRRZlcz?=
 =?utf-8?B?OGNjMS9CSGlCSTNBOFFBV3RLN0ZRRG11cFBpNG0xTzJqU01sQlYrVTlQTW0r?=
 =?utf-8?Q?I1BiwUxnBDkmN9lL9NoaXCwO3FVruxEPhwsDpnr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a04a548-4c68-4f23-de42-08d8fb7dba38
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 17:34:28.8327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EGrDh5zUl2wNfPfp3ZF/Iwx7oyrocs9fbmWqfOg6hn95KvG0g0OBJWN3F4dnnuhUujBTLoiJzQOOmQ55+NQ5DjptZy+btWs8dcgbe11d81Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3128
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9949 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104090126
X-Proofpoint-GUID: BOigerKsh0k-Can5-xjkydwgH_X7XGdF
X-Proofpoint-ORIG-GUID: BOigerKsh0k-Can5-xjkydwgH_X7XGdF
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9949 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104090126
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/9/21 12:18 PM, Mike Christie wrote:
> On 4/7/21 9:21 AM, Dmitry Bogdanov wrote:
>> Currently TMF commands are removed from de_device.dev_tmf_list at
>> the very end of se_cmd lifecycle. But se_lun unlinks from se_cmd
>> up on a command status (response) is queued in transport layer.
>> It means that LUN and backend device can be deleted meantime and at
>> the moment of repsonse completion a panic is occured:
>>
>> target_tmr_work()
>> 	cmd->se_tfo->queue_tm_rsp(cmd); // send abort_rsp to a wire
>> 	transport_lun_remove_cmd(cmd) // unlink se_cmd from se_lun
>> — // — // — // —
>> <<<--- lun remove
>> <<<--- core backend device remove
>> — // — // — // —
>> qlt_handle_abts_completion()
>>   tfo->free_mcmd()
>>     transport_generic_free_cmd()
>>       target_put_sess_cmd()
>>         core_tmr_release_req() {
>>           if (dev) { // backend device, can not be null
>>             spin_lock_irqsave(&dev->se_tmr_lock, flags); //<<<--- CRASH
>>
>> Call Trace:
>> NIP [c000000000e1683c] _raw_spin_lock_irqsave+0x2c/0xc0
>> LR [c00800000e433338] core_tmr_release_req+0x40/0xa0 [target_core_mod]
>> Call Trace:
>> (unreliable)
>> 0x0
>> target_put_sess_cmd+0x2a0/0x370 [target_core_mod]
>> transport_generic_free_cmd+0x6c/0x1b0 [target_core_mod]
>> tcm_qla2xxx_complete_mcmd+0x28/0x50 [tcm_qla2xxx]
>> process_one_work+0x2c4/0x5c0
>> worker_thread+0x88/0x690
>>
>> For FC protocol it is a race condition, but for iSCSI protocol it is
>> easyly reproduced by manual sending iSCSI commands:
>> - Send some SCSI sommand
>> - Send Abort of that command over iSCSI
>> - Remove LUN on target
>> - Send next iSCSI command to acknowledge the Abort_Response
>> - target panics
>>
>> There is no sense to keep the command in tmr_list until response
>> completion, so move the removal from tmr_list from the response
>> completion to the response queueing when lun is unlinked.
>> Move the removal from state list too as it is a subject to the same
>> race condition.
>>
>> Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
>> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
>> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
>>
>> ---
>> The issue exists from the very begining.
>> I uploaded a script that helps to reproduce the issue at
>> https://urldefense.com/v3/__https://gist.github.com/logost/cb93df41dd2432454324449b390403c4__;!!GqivPVa7Brio!KN-N7Ult7Itn2AzY6LdP2vm0D81UIjpbCyOAH3uf2OoLGUykpGP3dJTQlLm9m71MjsxY$ 
>> ---
>>  drivers/target/target_core_tmr.c       |  9 ---------
>>  drivers/target/target_core_transport.c | 19 +++++++++++++++++--
>>  2 files changed, 17 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
>> index 7347285471fa..323a173010c1 100644
>> --- a/drivers/target/target_core_tmr.c
>> +++ b/drivers/target/target_core_tmr.c
>> @@ -50,15 +50,6 @@ EXPORT_SYMBOL(core_tmr_alloc_req);
>>  
>>  void core_tmr_release_req(struct se_tmr_req *tmr)
>>  {
>> -	struct se_device *dev = tmr->tmr_dev;
>> -	unsigned long flags;
>> -
>> -	if (dev) {
>> -		spin_lock_irqsave(&dev->se_tmr_lock, flags);
>> -		list_del_init(&tmr->tmr_list);
>> -		spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
>> -	}
>> -
>>  	kfree(tmr);
>>  }
>>  
>> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
>> index 5ecb9f18a53d..4d9968f43cf1 100644
>> --- a/drivers/target/target_core_transport.c
>> +++ b/drivers/target/target_core_transport.c
>> @@ -667,6 +667,20 @@ static void target_remove_from_state_list(struct se_cmd *cmd)
>>  	spin_unlock_irqrestore(&dev->queues[cmd->cpuid].lock, flags);
>>  }
>>  
>> +static void target_remove_from_tmr_list(struct se_cmd *cmd)
>> +{
>> +	struct se_device *dev = NULL;
>> +	unsigned long flags;
>> +
> 
> This is just a nit. Maybe just do:
> 
> struct se_device *dev = NULL;
> unsigned long flags;
> 
> if (!(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
> 	return;
> 
> dev = cmd->se_tmr_req->tmr_dev;
> spin_lock_irqsave(&dev->se_tmr_lock, flags);
> list_del_init(&cmd->se_tmr_req->tmr_list);
> spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
> 

This might be wrong. I thought when you moved the deletion to
transport_cmd_check_stop_to_fabric, we would always have a dev set.
But in core_tmr_abort_task there is that transport_lookup_tmr_lun
check. If that is a valid check in there and it could be NULL in
the path:

transport_generic_handle_tmr -> target_handle_abort -> 
ransport_cmd_check_stop_to_fabric

then we would hit a NULL pointer. I'm not sure how we would get a NULL
dev there though. The driver would have to not use the standard
target_submit_tmr or be iscsi and not call transport_lookup_tmr_lun.


One issue with the patch though is if iscsit_tmr_abort_task fails then we don't
call transport_cmd_check_stop_to_fabric, so the tmr will be stuck on the list.

