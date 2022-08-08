Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F1AC00140
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Aug 2022 22:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236480AbiHHWLr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 18:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232384AbiHHWLp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 18:11:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC37A193F2
        for <linux-scsi@vger.kernel.org>; Mon,  8 Aug 2022 15:11:43 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278M3lB2008434;
        Mon, 8 Aug 2022 22:11:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=D21RskTCwVc898IhVp6FXUsbgS5e7ItPWiBcBgpnfkI=;
 b=L2zVG7t3f/LDTWm9HYNzte2EXfo/C0+1+ZLGi/nkw1KPqg4Q+Z7JBThxiolrFEzBwOT+
 zF1f2XYmyXEvuS8H+qYwtfZVrLwe2y4/i1HNucrlbMb1koyX6CBOKtnE3H4nNh4xXj6U
 sUPv27jJPB2bEtD+GA2PqdQ7bZQMb4W50RIkERvwCtpBt2wBnM01pvWFxMuVC4RLb1Vj
 fTgm+rxgqRkrmhLF63zclmHfvMAJxJ5hOyl0nGgm6BgGDcRTSoSnRJxZcTaVrDJ08grL
 mPfOfIcWhBt75OKOdRzVQLo5Fns427ZFuKm3wQsbdvyCEiDmKJQDDNuLF9KIXRqfgBqa dw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsfwsmwx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Aug 2022 22:11:32 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0hxE038058;
        Mon, 8 Aug 2022 22:11:31 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hu0n31217-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Aug 2022 22:11:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X7KmKJ/IH3gxSKoK7p2b1WoOfDwi+5BWMkfAUUCdJXCVqpDbM3uAt3O9CX+i8yfIJvSW4lsABsIWQrklOK3bQZvkPFCorGBIpF5yUnSm02Ba6ujg+K9RISZXp8DMzbFy28cArBIztYM5tclnpAm1maEvNkA+vrRcgpBp8yNI8pX7xyuOSMI1LaxlhIHP+F1n217O3Cr23KWfPnvMhVm4MOSUrvgwDnTRS1pfMrEPPW6r3fy73exr3fbkuxVf+bdiG25BHGxNsaGnkxoB9gsFluxRGutdzEC9PDM8u4n9qzq8kyIi7sSZIG9IKlPks6QmyK5KszCPX1a2kec6B8Augw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D21RskTCwVc898IhVp6FXUsbgS5e7ItPWiBcBgpnfkI=;
 b=jlzskj0bRsYpOxiZpm3pfLbTV38ALUE54WyXSfzgvjVphiEOH3dM7V/badE/ERgtcV8MJdFql+X4SUb3r12mkv3Jr+J43uiVArBA2B513a7/7AZQ8JdwsTrY5168shufanq3XGlMacCln/6awhve+efSZ4O4RQDruc0vMCIaRiOpMYd2luno/53Y5kXTfT5PP973LsmClmfff6ezxKH9qwLMog3b2MFA0LOFWMYQGV1xzH7Bssgwr/wnyhLsaae68phftHVp2t3ErIgX6+4xWmt4nSAqollMDVThjTLRRM3U1gjC9gQtdKG8jH5aR3QFwJu6uoWIXfdl3r9gTQ5tNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D21RskTCwVc898IhVp6FXUsbgS5e7ItPWiBcBgpnfkI=;
 b=LS/cHGs5A85fqMUC7G7asKTbfLdTuguxBlyytWfFfZD8jtPwXEw9tsTqI45reremgswX8mckGX0jU9JojQnTSgnaaDpvGCxNl7s0asSOpSZ8RLLDmd8wdz8frXoMIbzfxVH493w1zw/jWmkOdxVsBX3HkZm196aA4wP3wcsk5jM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB4557.namprd10.prod.outlook.com (2603:10b6:a03:2d4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Mon, 8 Aug
 2022 22:11:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Mon, 8 Aug 2022
 22:11:28 +0000
Message-ID: <251c6042-5778-5d82-64e3-a2de5e1e2d36@oracle.com>
Date:   Mon, 8 Aug 2022 17:11:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH RESEND] scsi: scan: retry INQUIRY after timeout
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Dave Prizer <dave.prizer@hpe.com>
References: <20220808202018.22224-1-mwilck@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220808202018.22224-1-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0449.namprd03.prod.outlook.com
 (2603:10b6:610:10e::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7b41735-5f6a-4c73-0eaf-08da798af142
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4557:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ll0XCsqeEDbbIzRmFIfO+qydW1k/Gd0gxSRSAcSLMWwjwb0aniflczxgNQ7EvjxeJj1aRTSPR02mU0e1EIxzpOtKcfjNKuLrfLjFO449WDePpMWkb/FktM30MTw77e/RKAw1C+6HcAmRwB/4xYbY2hXMSfAoWB4fvATi2UTUbNytZiTEVOwQfyja9iqmC8tx/fb+WsQF4PB0aaVezJQTwPyeOx3TxOZRmg9KFlbz470AaYsIzYAKVLAZSuEuLZo/mMmZsN6Lpd+240Qtk/EH6Sk8ucobOkKFPz2S5aiN5LqxcBZXZgovFgedn73IM+ONYAy3QNTbqaGq5PZPPK+lqZi4lzAaSuo/ymoC/GH1+OAOFkXvLUYgk3LOSjbmJFLKWrd+pUyBBMugZe/UJ7ugMcUMdeBmPqjrhA1G/UehNtSB6bJT7chBviJpbJel6G1Z3bcpZur8lVspWjw66NhTr4Pr1ga4gnhcHz4etQrfu6XKrq9JCq1bTuhcTON8VhnekU43GA1Ip0D2e/vB+Urgp6SwVx5hfmy7ISXErdtGH3V/Dg46MDTdhSAY31nv4oEPxsN5K+7WdZWInKSmDDs7v/dbKi+sHL6XYXrhNmSnSV6lQppJrMBiGjW5JGVfeZ1MSyYdQPDL2iYGIaQrkUF39dVrnj/rzpW0EdTuiM+uMl19OkoGA7yQrdYAIf6zCwtbnJlF/JROqHb82UuwoiFVgQOGLm6nLvBgf2BESEkN3jpkzpGG3ec/L2Zv0uM93reY+dbvxvN054xHZKPheKgaoCCy36pZRoS5VxmVEIS/dfFkoDPyIJaQGgKs2WEUrE8kCg2ZFV2a/72leA026ORZWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(376002)(39860400002)(396003)(346002)(38100700002)(36756003)(66556008)(6636002)(54906003)(37006003)(66476007)(31686004)(66946007)(4326008)(8676002)(5660300002)(86362001)(31696002)(6486002)(8936002)(478600001)(316002)(6862004)(83380400001)(41300700001)(53546011)(6506007)(2906002)(26005)(2616005)(6512007)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OGRqd3FoTlI2bUJkTStjT2t2eEM0TDJ6emdhUmhaUUxZL3hJR1lNUlprUWI0?=
 =?utf-8?B?YWNralN6ZFZZbEM5d04vSWlpc1NXTmVOTHVSQ2VtQUpHMUhaeXgvZXNiQmlh?=
 =?utf-8?B?YW5mQk9KQ0E5MFU5VzRwWEU3cEp6NHM0U1VZdmRuci96aVhjK2lGVm4vMTds?=
 =?utf-8?B?Q2VMVU9Vbk9ybjZSaEY1Q3E3WmN2UUZUWGtSUUtYVTFVbU94OUR6UzB1MU5F?=
 =?utf-8?B?b2RWS2JsdmpkcmhtZk9seE9zYzZ0WXA5N1FQZll4Sy82WWNMUHc2Z1ozRUhy?=
 =?utf-8?B?L2NubDNTZVUrMjd1cExiY2xOTDhKK2FLd1c5YzVCeUdYUzBxNzdEUyswZVN5?=
 =?utf-8?B?M21VeEo0TUZ4M0dLemdWeThjUWdYK1Z1aDJMTWRVTWwwa3c2N0o3VzlQb0s5?=
 =?utf-8?B?NWZ0YldJS2ZzS2gxV1F0NVloL2xGR1BBODcxVjFSOGVocDdUWEErMmtpTnZ5?=
 =?utf-8?B?bklEdnhtNGxlWW5mMkFBbjZ1d0VWS1hsekh6TEZvWS90K1ZCbFlHTitHZkJm?=
 =?utf-8?B?MHByZ2paYmRVQlhrUE0ybUpZNW54UTQzVHlwdjJHSk1XWDd2aGcxYlhLQzFT?=
 =?utf-8?B?RzhvaTNXMjR2K080aE9yQkR5KzYwVDVUZ3ZhOFd3Y2wxV0pHcnhieTNuamdr?=
 =?utf-8?B?NGUyeVEwQmxKaGlwajZqMjNEaVh5cjdzQUVkb0dRN1ppMXNOYkprSGk2dmx2?=
 =?utf-8?B?UWdhL0thT1lwa09aS1ZYdW9UT1dkVUhWZ0JKSnROVFBIYzlzTXNuc0YzemhT?=
 =?utf-8?B?cWNNNHZEVlZ4RDVZS2dlaHVsd0dNL1JYazdJOTN4UnhEOUo3WlhZV2dvNlZi?=
 =?utf-8?B?S2V3YjgzUkFNam5CdmdtdEhXZkNJMUJ5c3NHWjFMV1VVL052RkNNZFErR2hK?=
 =?utf-8?B?dDhYVEhnNmVLcUhmTHEzMjNzcE84RkU1bmIrUzBkRVF4aVNyS0cvWTJ5NjBk?=
 =?utf-8?B?MTFkZjFDVkFyZ2xKK1E4ZkYxb20yWVFFWU45YjkwaEhDK0F1MTFEc1lCQWVK?=
 =?utf-8?B?c3hvQXNxK1ZoRDBQbzdQVXRxQ0VZUnU2NjdNeXptT2MxRXA2OS9NTTl2Q3M2?=
 =?utf-8?B?TGdDVVNlaWFTYjlzK3J1MXBrcHUvUk9GczZzcU9kYjdsY2hiSWtrN2ZoQjZI?=
 =?utf-8?B?eEZ4eHUvQ1hRNUFiekN6NnJxbFBSQU1ZWHRZYmlTb0hTYTl2NisvRVdzYnRP?=
 =?utf-8?B?YW5tK1doZnJSdzZxNXgrU0FsczdMWkNuT2lXRVFxeGd3RUV6Q2w2enNDMDU4?=
 =?utf-8?B?TkljMjY0VzFodWsrQjhmQitlUXpxWVhsTVAyQnZUdUpDbU9ySXFwV0NGR3V5?=
 =?utf-8?B?dnRsbVRiZGNwODRuZkVSaGJaWlVDbmM5ckVyVk5jbEMxRjlFOWlIUjBPK2NK?=
 =?utf-8?B?WUE4NXlGMXNmV0Z5R216VTV3TmZVVmZsUUNRUGVrUTNUMzJEeHdjdlYwUlFH?=
 =?utf-8?B?QzlRNTREY3AwTjhTL0RQWHVBRWZmVWdHL0FCYUhaVUI4b0lDT1lBcnBwSkpK?=
 =?utf-8?B?TXpaT1k5d3k1aUdZNmkxcGpqSVV0bTBhSVJWM3VXQUUveEs0dUZUcXJUK3Bj?=
 =?utf-8?B?SEF6bDEyVlN4Q1lJVG9YU1JKMk5Sbk1ObEtFbmdxRVhkaXhwWDE1ZU42SVl4?=
 =?utf-8?B?djFPMm95S2VmeWRneHhHZzVsM2huc3Y4MjlkWk5KeDlDL1h6OFlnWFRoQUFk?=
 =?utf-8?B?dXBlMkhHa3RYZk4yWGJySlJNeG1qYlltYUkzTnlkK0hpZGF0Z0hKeklldDJR?=
 =?utf-8?B?VUhJVk5JWjhpeWF5N1hoY0tJem5YRG5MbmpqdWZwZ2g4VmE4VUJGeXVIWUpF?=
 =?utf-8?B?eEttcWJCVFYzbUJDTTFDSk40ekFEajl0aXAwcnVqZnU4QkxPbzd6RXdTZUJM?=
 =?utf-8?B?Uzd0RDhTaXNUSUd5YjJZN1ZsWUdnZEp4ZTIrY21ndWl5Rkc5bGgxcjRHSEE0?=
 =?utf-8?B?N25wU3ZXZkxCeXpHdmNTa1NNQVpiY3JjOVloelNGTjdzZVhIaU9jVlB6cEts?=
 =?utf-8?B?SEM2UGkrM3AxWnhTWDJCVExObGxDazhoUC9yMjBQckNNUm9ya2lGS2pqK0R6?=
 =?utf-8?B?Z0JwR0Q5a0hyZWZLK2ZKNTJDRXhQczN4Qkk3b29UcVZFL04ySmdIQ2M1eno1?=
 =?utf-8?B?QkVrNFlsUXEvcG16RGJYRU12YVUrR2ZNUmtuaXRWSkw0OE05WDRWUStmMU04?=
 =?utf-8?B?RVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7b41735-5f6a-4c73-0eaf-08da798af142
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2022 22:11:28.8619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tUiO9asMz6QmQMfUDplGhqUpMegbXjCthyqulx3nehjRvNfWFhbHpallylP+YVLWXyQAHtUL5LlVHmwQQ0owmloMjX/Qo9IhEgBcIi8t+pI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4557
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_13,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080095
X-Proofpoint-ORIG-GUID: -GMXb-ipiOp85Gc1spWeaz7uPjnLcSMc
X-Proofpoint-GUID: -GMXb-ipiOp85Gc1spWeaz7uPjnLcSMc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/8/22 3:20 PM, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The SCSI mid layer doesn't retry commands after DID_TIME_OUT (see
> scsi_noretry_cmd()). Packet loss in the fabric can cause spurious timeouts
> during SCSI device probing, causing device probing to fail. This has been
> observed in FCoE uplink failover tests, for example.

What about the other scan/probe related commands and other transient transport
errors like this (so when we get to the point DID_TRANSPORT_DISRUPTED is returned)?
I think if you changed your test a little so the fc port state changed, we could
still hit the same end problem. We can hit similar errors with iscsi and plain old
FC.

For REPORT_LUNS it looks like we retry almost all errors 3 times. For the
probe/setup commands, at least for disks, it looks like we also are more
forgiving and will retry DID_TIME_OUT/DID_TRANSPORT_DISRUPTED 3 times for
commands like SAI_READ_CAPACITY_16 (I didn't check every sd operation and
other upper level drivers).

However, for the other probe/setup  operations that rely on scsi_attach_vpd
succeeding like sd_read_block_limits then we will hit issues where the device
is partially setup. Should scsi_vpd_inquiry be retrying 3 times as well?

An alternative to changing all the callers would be we could make scsi_noretry_cmd
detect when it's an internal passthrough command and just retry these types of
errors. For SG IO type of passthough we still want to fail right away.

> 
> This patch fixes the issue by retrying the INQUIRY up to 3 times (in practice,
> we never observed more than a single retry),
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Tested-by: Dave Prizer <dave.prizer@hpe.com>
> 
> ---
> This patch was previously part of the series "Fixes for device probing
> on flaky connections", submitted on 2022/06/15. The first patch of the
> series has been dropped as discussed in the review process. Testing
> verified that just this patch was sufficient to solve the observed
> issues.
> 
> ---
>  drivers/scsi/scsi_scan.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 91ac901a66826..e859a648033f9 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -697,6 +697,11 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  				    (sshdr.ascq == 0))
>  					continue;
>  			}
> +			if (host_byte(result) == DID_TIME_OUT) {
> +				SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
> +						"scsi scan: retry inquiry after timeout\n"));
> +				continue;
> +			}
>  		} else if (result == 0) {
>  			/*
>  			 * if nothing was transferred, we try

Should there 

