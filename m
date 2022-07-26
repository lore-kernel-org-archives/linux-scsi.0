Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E39B5C3F6B0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jul 2022 21:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239425AbiGZVk0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 17:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238906AbiGZVkY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 17:40:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7B2624E;
        Tue, 26 Jul 2022 14:40:23 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QKnSAL009198;
        Tue, 26 Jul 2022 21:40:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=jwD0nkYlq/hhnohRq65R1ju52rwbAW8DxYaItBPt0as=;
 b=O//THBQC+wAnXWR05n5LPiDEbLLpY1sRhvCMDFI19OwH6zlwLl52DaJHzI8WQdqWLlNy
 de6aBU0HLmFlalAv9DdXglu0rjOUn+XtqPpJAxBfO9LTgKKtMfYIYMhDm7nWFpwEVW+f
 WpG+dbe2kIaQFoafr0njqTJFNfheY51DrpGic/NpDf6yKryaoP58bq4R3B2UdJ/CBZmZ
 596bCX70K4nN3CkvxhvF2JZdtajItNnJKyy1xTquXXXooGSJ0tThIZRmTKxhQ8nR6c6J
 BUlsrlyb9+U7FLwjy2cTmFOb0+ToaG8EPkwbLdMbgoNhLz3MKnMn64T/2kCAOn1xQndr FA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9anydp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jul 2022 21:40:22 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26QJS6tf019901;
        Tue, 26 Jul 2022 21:40:21 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hh638d4bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jul 2022 21:40:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZN+UhmtCl7msBhkNtPZJ5ij/iJ6ylx6+1YyB+Qx0joFlr9tm55sY/PLGWSx8TEebYxj2ChCkgwL5BWlG9tS/hauK4EfsvEAfSvmgC86plqiV50c7ZAHudgptwsPO6YLZwwrZ5UiJ2ygFjy0e/UJfGjVumi/W5YmwRI2Lgwz3SeOlPYPJhdYMk+s+7RK8STMWZdpDncdRsNdBcFfHVo7MuAipD3dCf/X59DrlOUlvSVo76yeF0JhQFiHG56DnOTfhAIeUklfOSqriRDuj3u0joAfShee1Zlo2+9OqE1CTBPEj6uoheL3aeulyL4WTm6HTz0fIMv1odv0g6e8fTB7TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jwD0nkYlq/hhnohRq65R1ju52rwbAW8DxYaItBPt0as=;
 b=nXRUfo3Vw3kyIbKw7tDuNXhk5eOmYGIBeAuO+2asaVEWorbofUqcCr5SjfGBVx8TekL56hoCxBP6vCIL5tRlavdGYGS85YaDW0BNQQQOCvI+e5XeHpyhy4loT3yIYjijLAzKKu9jFR91p+4j9+T1mxfiSOblrgRHBq3Eo8YgXyg4veoA7J8gtvRWh8XXeiAIM4fe5GMVCISoacdmri7qCAVozBhZV0rNfJpON3LgVZCUQxFYANbRNbETWvLQnnSKy+MfS7/62KDbrftYLcJd8lpDUzT9lAI7kAhKxI1JMyUfHcf8XO/IKLeLd5bGaiWvyDnCTvw+11w942jCbI66FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwD0nkYlq/hhnohRq65R1ju52rwbAW8DxYaItBPt0as=;
 b=zzO70u6aFROfdskNySAwOY2uediIe9hMjDBefQfoZ3xjD+9Amo/QCmzt2EkgehkVpWidfZ2Gt+4yIPuSVKpzTMgYFf3HNNh74YkfIhd30usXOt2AaJYlNLhOm1A1Q5DSiGz4cAErBfN0g53mV85dOOT6pT7abltV87cOF2rTCgI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5683.namprd10.prod.outlook.com (2603:10b6:510:148::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.13; Tue, 26 Jul
 2022 21:40:19 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 21:40:18 +0000
Message-ID: <e82ed8ab-8d9d-c815-e134-26929e3350aa@oracle.com>
Date:   Tue, 26 Jul 2022 16:40:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH 1/2] target: core: fix race during ACL removal
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com
References: <20220720112852.11440-1-d.bogdanov@yadro.com>
 <20220720112852.11440-2-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220720112852.11440-2-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0082.namprd03.prod.outlook.com
 (2603:10b6:610:cc::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5218b780-fcb7-4d00-1474-08da6f4f6f53
X-MS-TrafficTypeDiagnostic: PH0PR10MB5683:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5TdhxaD5ZxK0ojftOm4LBfePSz5CV531zps4Gs/oza2TYpD8RtdXKvoBFFOPtcbW2i4h85HW7sxQ9kCSCMuI5NlOjEqKgWwjGXd41JG1h3IrvqeITSK01Hph86N/FdtamXESLecGxPpm+KA74wQV/B/ddgnNIPQZyvYw3Saaa0gDjfvce93MPCawMIDyCidzcmsqxKLUqiLVqbJl2XIjNRNofPRtP/XvY/dKvk2GdpobjqXEK4/ENcclxIhCgs7fqdPf0T3Y1TSer+tqONCA5gTq6ikNP8q1Ocjbii1ByQXszz2Q+nw7mrpB5aeHk1GPTf2qf4xQTbEh2wPKmZADZs+eXxVyR7vmJJ1L1Cc8pwbk7KS1jf0LphvabfhqqFyW1A4K3z+YPewn1lEvrTPnQTBOsjsErq+E0v8ZADbE5ivsHYattmIjsCZgHN9MGyMw1ngWhhMTmipwgpTub5aImgv05ZKGjmjVqrYSoocRuOXpVvS6YSC9y3ksqZYuJiio1lpi1wOh79EgWHl5KBDMp0gAgIuh7cBZdCp2Px5lmv60iiLwczhx31SOOlvYwM6e0BL/bNmeMlCxE1CYMpq9Loh7h3HoQyMR1CH757sAy5MLEHl2VZs97cVvYWQWhFtmh7YVO05rzYGFpwT0tKaHl8JNQbUdhOGUBuZn/yeOKQEd3FTtGNeZ5HNelaJf83+77nj2WMdwEOKEmTOwe2KSSAcZCYjFP4DVBL//oihcStxml16+NJVh83WaaVzuK1iOStDtJDYdILgflO5Qli0egPwsDZWcV52Ds9GB5GR0ARQjHRWYknoD3KWTaoVpvl8Cs4ZX/5qxO0P5Ov1mGQSfbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(346002)(39860400002)(366004)(136003)(478600001)(6512007)(31696002)(6486002)(86362001)(41300700001)(53546011)(2906002)(5660300002)(38100700002)(6506007)(26005)(4326008)(66476007)(66946007)(186003)(8676002)(66556008)(8936002)(36756003)(31686004)(110136005)(316002)(83380400001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L09vTzgxZVpXQmszV05sWkcrMHp6aDIzT2w0NXN1c3krcFU4czBEUzNiVkxs?=
 =?utf-8?B?L0hBYmVEQkZQQjhLdk5QNk93RWg3aEhJSC9STDVzeWtvcEZNdk1ZQ01xTXl0?=
 =?utf-8?B?dzhRMUN3TGhRcVFzbWkySElXVWcvaUdvKzhHU0ZpSG53ZWd0aDcyTTJSMzBY?=
 =?utf-8?B?RkJ4YnN0LzIxd296c3B1aWovQnlObWJOWC9hSmVDTWV1c2dRWENGVWRINUti?=
 =?utf-8?B?Y2FGVVplaHhJb1NtanB1eXZhMTcxbE1XbEJzaGhvdVFhc3N2aTFyam5meDZO?=
 =?utf-8?B?dFVjMHhqZVZhN1ZXV2JXRU9STHRzRGFWajk4ZERGTUtHa1dOaVJrU1U2TDJ5?=
 =?utf-8?B?Y09rUDhBSU9iMDdvRyt5Y2FlcUk1QkNtaWZGWkY0VXR6QnlrWHNsMWQ2eXdX?=
 =?utf-8?B?VjlGWjkvcVFSSHRqQXR4Q213eW5rZjhURk1XdGttMGIzTnNVeDczMEprNEhl?=
 =?utf-8?B?ZURsUVk2UmJzRFR5T2s2OWJkU1FicjRVNGJEMndHMHZoNTkyY29YaWRqZjIx?=
 =?utf-8?B?aFB6dWZGVnE4YzhXL1p1T2lVQ01vN0d3VVRMOFh5QUlWVHdMM2JXNWIyaXVO?=
 =?utf-8?B?L1VmUVFkdi9FbmQ1SThTYS96dHhBaEQ1M2dOM0oxNTFwT0xSTlg4dGQ3UHhp?=
 =?utf-8?B?K21iSmhtdFhIbDFLMmgrcmpVdnY3WFRST0ZQT1RXcFVORjZTdnVuTTJiaTd3?=
 =?utf-8?B?V1R0R25wRGhtQk5Ba3MydUdIbUNhTVgxMjVEYmhVd2ZwZk91czJXZXBRNkdX?=
 =?utf-8?B?SnErV1VRcE4vWTJ4dDV5b0VmUnBrektwcW1iWGVQNkxrWEJvWFJlbzhGbVB0?=
 =?utf-8?B?S2h1aTZmMVprZTRjVy9ZS3lJRE9jays4dktXbWVBSVZoZDhrbCthUjVqVVVS?=
 =?utf-8?B?WUx5c0Q4eWVIVlN4VUxwdWpvT0tnWmU0QlpzaVhuNGNQMDlpUnBybmJzYkpV?=
 =?utf-8?B?TzN6bW94aWJEN01acEx3d0pJQW9LOThUWVUwNTNjQWY4ZUYxNHJQWDFIdTdH?=
 =?utf-8?B?TSthRGhJT053eDNCY25nWWk5S2NtMjJLMzBYN3laSjJib1BPUHFaUk1jQ0dy?=
 =?utf-8?B?UGlEZ2F6WHpzdzEwNFg4TFVQQ0g1WFVCbEYwbW4zYmNBUW55Zm5jT1IwM0xz?=
 =?utf-8?B?ckkvS08xd0pFemZxdzBrTTdIUHYwWUZXejI2cFBvNEVtckkvQ1N5UGpsd1BV?=
 =?utf-8?B?RTNlQ0VHZUVCRHVIZDdFZVRHZy9iWllFdjFxaElER05wMThIUFFUNVV4Rldw?=
 =?utf-8?B?RnJvSU9BU0lEL1FLWEg3bmNpNW9PSnRCQkF0LzR4S0VmSkRTclYzckYycUwy?=
 =?utf-8?B?SFFzNFRVU2I1RDFFTDg1ZWhRN1c4OFM0S0NHOXFnRHR4amk5Z1Vld1IrMmVu?=
 =?utf-8?B?Nm5GMm9XZzROR296QzY2VWFCOXVCNzNQcmhML3hBamYzdExyUEVLaVVZOUEz?=
 =?utf-8?B?V0ZISkFoU0ZzU1NyQ1kzZ1MxeGtMMy8xd2J5NmRmUTZhaHBwZmFITVdYYzlP?=
 =?utf-8?B?c3A2QndFVzhYWUw1aEVZb1hzL1krd0l6VVdiRXduRmFQczRVTlVwZHNZbzRz?=
 =?utf-8?B?RTk3M0lkNzYrZmJneksyd2xCUG1PeGZyYXpmRWZKV3ZMbmtwNWpMVFN3RTNG?=
 =?utf-8?B?ZDAzQkRHUU9Db2JxZStCQ2R4UllmOTJ4SUxYb3Z4M0V3dk9XRDBXWFR4TTRU?=
 =?utf-8?B?YjM4Sm9OeXY3c1B5OEhqQWltSEFGUmpDcjBFR203SjJvbkd1UnJWeGwzTWJz?=
 =?utf-8?B?ajJ4TmdaMGs2Rm1MZThEU1d5L0JaSXhhT1ByT2VFUStvRCtTSUZMaTlMaVhK?=
 =?utf-8?B?Y2NrMTE3SGVONWh4ZGZJbm5wWFI0N2xDbXVqSkgycDFKQnJST0xtbTNJQVF5?=
 =?utf-8?B?NldBU3ZpRkVPdW5wS1pYNnhhUC9XaVFKUm1xY2pRdzdEZkc2R1FBMWhUaVFF?=
 =?utf-8?B?RnBqWEdDNjFvUTZxOWQ2UVpiUWYvUE9DN1ZqdkI3SXA4bFhoWVp6c1NIY3lU?=
 =?utf-8?B?d2t0ZnNxR0hDSTNWY3ZKc1RPK3lDUEhSbzBBQ0F2QUQ2SmZBMnhmcFRPNDdu?=
 =?utf-8?B?YlVSZTMwZCtkdDMwdkJ0T2FLc1d5WHFQSzlIK3ZHc0FHUC9GaVZldXRnM2pM?=
 =?utf-8?B?MVJUVlQxMEtQUitaU2FWN1dWclNxTVpjQzBHQzF1U0Q2TFkxOEppZHNVUTV4?=
 =?utf-8?B?a0E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5218b780-fcb7-4d00-1474-08da6f4f6f53
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 21:40:18.9036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FcsBf6PET87JaDzKD9bqC/vdevHWgdK2EVNIQC1bbOzzNUr+FGx8h6HtuL94uGjf+i2F002nFmMpKezScRrexE9t+SogyAzsy0kJvDY0qjg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5683
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207260083
X-Proofpoint-ORIG-GUID: 1sfD1yESiDcPt25fyswTDRLJYHwpkgAi
X-Proofpoint-GUID: 1sfD1yESiDcPt25fyswTDRLJYHwpkgAi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/20/22 6:28 AM, Dmitry Bogdanov wrote:
> Under huge load there is a possibility of race condition in updating
> se_dev_entry object in ACL removal procedure.
> 
>  NIP [c0080000154093d0] transport_lookup_cmd_lun+0x1f8/0x3d0 [target_core_mod]
>  LR [c00800001542ab34] target_submit_cmd_map_sgls+0x11c/0x300 [target_core_mod]
>  Call Trace:
>    target_submit_cmd_map_sgls+0x11c/0x300 [target_core_mod]
>    target_submit_cmd+0x44/0x60 [target_core_mod]
>    tcm_qla2xxx_handle_cmd+0x88/0xe0 [tcm_qla2xxx]
>    qlt_do_work+0x2e4/0x3d0 [qla2xxx]
>    process_one_work+0x298/0x5c
> 
> Despite usage of RCU primitives with deve->se_lun pointer, it has not
> became dereference-safe. Because deve->se_lun is updated not
> synchronized with a reader. That change might be in a release function
> called by synchronize_rcu(). But, in fact, there is no sence to NULL that
> pointer for deleting deve. So a better solution is to remove that NULLing.
> 
Hey,

For the line above about there being no reason to NULL the pointer are you
saying:


We should have had a NULL check like:

transport_lookup_cmd_lun:

.....

se_lun = rcu_dereference(deve->se_lun);
if (!se_lun) {
	rcu_read_unlock();
	return TCM_NON_EXISTENT_LUN;
}

and it would have prevented the crash.

But we don't need that or the se_lun RCU use, because the hlist_del_rcu and
kfree_rcu calls in core_disable_device_list_for_node will make sure that
transport_lookup_cmd_lun either finds a se_dev_entry and while in use will
never be freed from under us, or transport_lookup_cmd_lun will never see a
se_dev_entry.


If that's what you meant then I agree.



> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>  drivers/target/target_core_device.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 25f33eb25337..335f8cbfe633 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -434,9 +434,6 @@ void core_disable_device_list_for_node(
>  	kref_put(&orig->pr_kref, target_pr_kref_release);
>  	wait_for_completion(&orig->pr_comp);
>  
> -	rcu_assign_pointer(orig->se_lun, NULL);
> -	rcu_assign_pointer(orig->se_lun_acl, NULL);
> -
>  	kfree_rcu(orig, rcu_head);
>  
>  	core_scsi3_free_pr_reg_from_nacl(dev, nacl);





