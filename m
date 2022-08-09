Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E048C25B07
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 18:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344068AbiHIS2u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 14:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245483AbiHISYz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 14:24:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25240326DB;
        Tue,  9 Aug 2022 11:08:57 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 279GdULn022309;
        Tue, 9 Aug 2022 18:08:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=15ryCkxxzMTeLAcE2GkFb7RZGUka35TwTqEk0IOqkj4=;
 b=KiD8ayJsZbxlOAwYNz/GyHs6GA/4vWMxzLfvsvTOFv5NJkhFXCwrqxtr4Zd01SwXeun4
 dBlvaGwi/N8zEn6+PaQe29v1uZJ2NWaupnPIodfV0DpylfXzeaWw0omZs2MWNJSXXQFw
 36v3Tj4D602+gbUUwiwp7XbMOJKvz4QlsoFqa/u1ZUO4P+xDJh+9PBJ7Js97tjeuu3po
 j4beGKY6nzc/TEsHU2xPKbbHa6lQaGKvX7tTcESXVb2aot40GOEwZXA7licMqm/77gON
 6Quvv5oTAlYSVEGOrKE5i3pnH/TpF4eCUfLCpzvbh7xM21YtlKFG01saudA1pCRA7Px4 5g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsfwsq9d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 18:08:17 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 279GPB4I038112;
        Tue, 9 Aug 2022 18:08:16 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hu0n3stft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 18:08:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFb/gQxXwfKs58Kotvd87m5XBu90Zduq0goWa9YoyfQf5VWFn2Xa73/2PjP4hnE5jUJsw8hlwmK4Sk8jrcd3Z9QmHvDXVCSUPC+Xvs7qtmWnezvSNAtUxYq3UYtyrxIRBYQ3tgkuXoOW/Cpvrxm25Ibg8N8tvKSMHNF6i3ISHU0mkRPtgwp6mHJQhekkPQjHfpO7WqudQTb62+D4pl8P0oM02y+WTIkvz9unWWwiPnBcvydnBIPPzQrKg2uFtGcwnv1JcWA4VYp/XjvTE1ttz5QU5igP4DLZK98dUZjzfNd+9gMZ9+WiIJeDiCggXgLgXaRNV0qzbve4TT0BHSlnFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=15ryCkxxzMTeLAcE2GkFb7RZGUka35TwTqEk0IOqkj4=;
 b=WQWQKBlh0wo27BfQoW6kgXUUaps+bCo/8SyAgjU2k4d10/GykuwwF4KRck7e7vr2ygfJIcHk9VTwj3bZXjXOcojbZiXo2SAOW9ZpLia/AnBGoWdqWbOSWn2Q+CAPP8fanT5SXevVb30ONIo+nam1zLz70r+GYf+BUmJZcb/CTLNBnc0zgyHUnPE9d+ArpVBL5mGpABK02GRtBgD2ws6mKUncWdHpmVPRZurXwheHZ5IgcIiNePsDrUOVGrgoJB6Lh8ecvUkY7nyZoBpiiLmBeVT520LY8SVUzSaZYelkuYM+AHE9OaOb5yEz6mBLoOt8xLELv7K56thbt5YkX/gylw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=15ryCkxxzMTeLAcE2GkFb7RZGUka35TwTqEk0IOqkj4=;
 b=cQWknaMBD+BFztnKfLKVgpXj5cjc+XxRt+4OHB2XKD7z9n5ENyLUKpy7oNoyMPlRJgecARaQCJ4bDHTj3HI7hQu7wXgNG+EO6y72I1vWWlqo0pOh6S5zKbaARH9jXM5nRERdJ5cIZ/wsLpnqG6+z4VEhD51ijvm3gT9WFx0FkdU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BYAPR10MB2758.namprd10.prod.outlook.com (2603:10b6:a02:ba::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.17; Tue, 9 Aug 2022 18:08:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 18:08:11 +0000
Message-ID: <4af2a4d3-04d1-966a-5fd5-5e443b593c8b@oracle.com>
Date:   Tue, 9 Aug 2022 13:08:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH v2 12/20] block,nvme,scsi,dm: Add blk_status to pr_ops
 callouts.
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-13-michael.christie@oracle.com>
 <20220809072155.GF11161@lst.de>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220809072155.GF11161@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:610:54::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbd4379d-fa16-46ed-50c0-08da7a321eaa
X-MS-TrafficTypeDiagnostic: BYAPR10MB2758:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZhGLHpLhDb95d9VIAtfJCH0D9Nup3Jk6aFswV8WR2MPkxhph2vhXpEbnh2KQtecUGk7qHpsS50MZI9zns0RxMiDXRFOrZgwlE5PSyRZjMyp2oqKJc3GagLp7JgHSGWxzp0vBsl21Q+4I+hzkFILak61ANMQkChOddrKPofhTGbvYDEqpLWdRNj95xknF5COT3XW3ezk1bLnX2DRKy+QqTmDlTYXejKouWnnfu/ycH2rvKK7QfJhSyo0mXolPnqqpTxbT6MU7UQKEOQu7GxOy20wlVCC2RI0uo94JQunnwKh5XHsfqg+45xEDAIy8EGfKS9ambsMT7jf8JScXoJ/+ULoGQiqo5UKvecZVPN7oaiiouRB96hClnoeZQLosds8y0zuiqBoJm6/vP6EWUi2m9JWar+MDDWUicBDjRkaQiZ9p8XNCdZb9PgFhevZlSdP20vquSQ+PDda2HB4MghtzC2GahM2uy26CJlNnAJokoB/BGkUATqlFmEW6UFDJkqjxcihZApBcF0Taw+GzS3HXWSggbgbX2cMm7b/2SIl5D/XWnoAOHkVR35UieXg8nYTiap1m5kQeWp+ET+4diFzJrjxhM2mpjw5b3q0xHjgq07Kd0Vh9yjFrfupCmVsNY21LY2hnl0ZM7VQV5uZHO447uZ+JXEoKZWXf53wVEEhH3kN0xvLW0W3FfahCkoKi5dNJlTaTObspLoYqYTudDVp5C778Up10qC07szb1BUMRv6jYK1m6w8Dm14aCsk6cn06uOxRHB4JzlEIvLinD8it4tjjOBCi/G+ujxomXHTHCfNIQdWbqdjSRcPyP65/pDKUdmm/mkGcfkG+WGcOOj3BynA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(366004)(346002)(396003)(136003)(4326008)(31686004)(66946007)(66556008)(66476007)(478600001)(6916009)(36756003)(316002)(6486002)(8676002)(5660300002)(2906002)(8936002)(6506007)(6512007)(53546011)(41300700001)(6666004)(31696002)(26005)(186003)(83380400001)(86362001)(2616005)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TU91QnJ3N0xldS9DZGtzOWhyaUZBSlNHTnd6TFFjK0xLWis1RmY2Mzcvb2px?=
 =?utf-8?B?cytBekxBUmUxWjFFZlFLSGdhOCtleGt4cXg3MnQ5TzdTMzdHTFNTeUVjbmxx?=
 =?utf-8?B?OTRWVGRvdEg0aWtRWmowUE44WnBmRVczLzlydlBFN016VGRyWVhRWVI5RFdu?=
 =?utf-8?B?ak1zWjZKNnE2cGJqOWQyNnprOEhXb2VDalRrNlhqb1dRVVltSWE4UnpTQ1g0?=
 =?utf-8?B?bHlFSmlUOHdheUxJVlpjOUlIaThnUldQUit5bm5LVStyQ2NjbitKc0ZXTXVL?=
 =?utf-8?B?N2c3THl1SWo5dEUwNHlaL256WlJCekhKSExsUVVSRzh3RUU5NktET0NoR1Vk?=
 =?utf-8?B?ZjNxcXo5OEY4U3NxMThqaEtiNUdUQkVlMnA4dVkwR0c3UXZxZkhaZ3FHVWpQ?=
 =?utf-8?B?RUJvNTFPcGRhWVAvK1F0cmd3Rkd4OFYyNnh0Z3RrM0wzUnNqd0JhL2V3eHQ1?=
 =?utf-8?B?QWxod242TStURzBGTDBoU1JnOEprTlFRamsxQ1UzWUtkQnNmZVJHSS9jbmpD?=
 =?utf-8?B?amR4SGQ5UTluSDh0aTJ4RlBvSENLbWxkcEFKdkFwcHlkN3JuQmdFMytoNmpw?=
 =?utf-8?B?Nit5M3RnUVpFTkJVOEZyTVkwUmtlc09SWVRPS2FScTkydTlwOWtZOHZMdmhJ?=
 =?utf-8?B?WDY5RjM0NXZ4SEVxNnVvTTk4cXV6Zmc2U3VIYmRyMXQ0Nk1OcVJObEJoN0Zi?=
 =?utf-8?B?cVo1bmZRNWQ4OFlET2VNalJzb3Y5SVZWYkU0TC9OeXF6UzRBWUI0Q0NlR0tM?=
 =?utf-8?B?bGRVNGRmKzBxeHlod3B2enNaOGxyOHJSem5IN1o4OG5mVGpTOEZLMEw0Uk1m?=
 =?utf-8?B?NEhPZWkwazNZdEJMRnF1ZVpCY2JMZC9td0ppckRUM0x0NXZJNWNMODdpaVBp?=
 =?utf-8?B?NTJGanY4UVVBQWkzVUhpZThWelpaaUtUb3EzdkJqWjk5Qko1RlJFdFRSNzJy?=
 =?utf-8?B?L04yT2h3b3cwZnhJWTZKY1YvTkt5TlVmN0lvVGVlNFdURG93Y3c0ZVdoVEVP?=
 =?utf-8?B?ZnhsVXJ3bmt3aWlKUzRjK1IyY2RXNlFUZ1BjbjRkbTlFa0lDOWRTb2V4TWFz?=
 =?utf-8?B?L0Q2YWw0em9xZlJMZG12aDFGYkk0SlpIb08vTlNNT2VTalBPTFNLdmdUWG52?=
 =?utf-8?B?Y0xMbjlGdmNmQ2w4ZVNaSzE4R0d0dll6QWVqZUxpTlFLU1FFQ3lSM3RkcjVk?=
 =?utf-8?B?YTVhT2dPNHY1NEllMkFRUndGNjJQelRidWZ1enFTMDVmVGptblJ4SVl3bFZ1?=
 =?utf-8?B?VmZHRHFwM0JZSVVNOXliNGxpMStzVnZrbnBQMUxia2paWllEZ1dOdGhzQUNr?=
 =?utf-8?B?eEpGaGZkZDBTN0ZDV25mZE5MQ3FmdXcwUW5IRHpLamFSYUdMSWRGZFRGbTJM?=
 =?utf-8?B?NUN4ZzRNaVEwa0RtZEtCTVQwRjN3eTNGUUZyN0pveUFGTTJmaU4xUkxlRTh1?=
 =?utf-8?B?aWRqZVRVM1FnYlVPZG9nTnM3R1VISHhLQ0J5TFRWR0kxZFRtdzdPUTRWTFVR?=
 =?utf-8?B?OHJNankrVExjL3MyL0ZpWU9GZGp3aWo3WUMzZFNtVzdqWnBIcHVPbXo1dU9X?=
 =?utf-8?B?Vk4rRUVTOGJ3SXIrWVZyOW02aDM1a25NREw2b2QvMWtBNktpcU96SkJnTnpT?=
 =?utf-8?B?YllZT2U0SjV6aU5HODVINmhDeDEwellGcUpGWGkzTmxXaWVsTnBsbzduNXY4?=
 =?utf-8?B?eDRTYWc0ZWl0cm81Vk4ybVExNmNnek02TUwrUGIySElvQld3VHBGakY2ZFN2?=
 =?utf-8?B?akZ4d3RuMlJ5T21zSVQ1R2E2T3FqVkp3cjBoMWs0ZVEzT3ZneFlGS0NGYjh1?=
 =?utf-8?B?MFRrT0dUUW4xMU9FL3Z0ZUlKUUJlNDRCTGFlUUVtNkhJaFhkb1lCZExuMTZM?=
 =?utf-8?B?N1NZcjNEbkZ5WkJBZHZPQSt2WFhybkJYN2N5ekJZbkRCU0E4ZEZ6V2kyVERj?=
 =?utf-8?B?YXpvYkllc3h1dDhhdzk5VjJpQkpheGhaS2VjellXd0VQNFBBazAxV2F6TEpq?=
 =?utf-8?B?dDVlNlppeGFjczFjMkxkS0JpRERBSmp0ZHZIYklObUJpTmowN29DUHF4enFj?=
 =?utf-8?B?cDFVRGZIR1pPeFR3V3FySzQwZ283U0RGUXV3dmE5Ylk2WHB5MTBHK2xPL3VZ?=
 =?utf-8?B?NDRrdTdwT0JwajNTdGdrNzVEUk4xRThDT2g1ZVpFQjVYdG1nR1dLUkVEdzdk?=
 =?utf-8?B?bGc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbd4379d-fa16-46ed-50c0-08da7a321eaa
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 18:08:10.9184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sHUH5UKO6mfkGp47udnvzgUQxR5d/+vtZI427eOQJ/a2JnWIfPu8cA9sMg+i/hNPedJG9Cbj3VdXouCgfYIhq8N4QxPjOTNL7UKx46+H8XM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2758
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-09_05,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=891
 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208090070
X-Proofpoint-ORIG-GUID: lvecxgrGdZr22FKwcXfg2UX9SwzlxX2z
X-Proofpoint-GUID: lvecxgrGdZr22FKwcXfg2UX9SwzlxX2z
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/9/22 2:21 AM, Christoph Hellwig wrote:
> On Mon, Aug 08, 2022 at 07:04:11PM -0500, Mike Christie wrote:
>> To handle both cases, this patch adds a blk_status_t arg to the pr_ops
>> callouts. The lower levels will convert their device specific error to
>> the blk_status_t then the upper levels can easily check that code
>> without knowing the device type. It also allows us to keep userspace
>> compat where it expects a negative -Exyz error code if the command fails
>> before it's sent to the device or a device/tranport specific value if the
>> error is > 0.
> 
> Why do we need two return values here?

I know the 2 return values are gross :) I can do it in one, but I wasn't sure
what's worse. See below for the other possible solutions. I think they are all
bad.


0. Convert device specific conflict error to -EBADE then back:

sd_pr_command()

.....

/* would add similar check for NVME_SC_RESERVATION_CONFLICT in nvme */
if (result == SAM_STAT_CHECK_CONDITION)
	return -EBADE;
else
	return result;


LIO then just checks for -EBADE but when going to userspace we have to
convert:


blkdev_pr_register()

...
	result = ops->pr_register()
	if (result < 0) {
		/* For compat we must convert back to the nvme/scsi code */
		if (result == -EBADE) {
			/* need some helper for this that calls down the stack */
			if (bdev == SCSI)
				return SAM_STAT_RESERVATION_CONFLICT
			else
				return NVME_SC_RESERVATION_CONFLICT
		} else
			return blk_status_to_str(result)
	} else
		return result;


The conversion is kind of gross and I was thinking in the future it's going
to get worse. I'm going to want to have more advanced error handling in LIO
and dm-multipath. Like dm-multipath wants to know if an pr_op failed because
of a path failure, so it can retry another one, or a hard device/target error.
It would be nice for LIO if an PGR had bad/illegal values and the device
returned an error than I could detect that.


1. Drop the -Exyz error type and use blk_status_t in the kernel:

sd_pr_command()

.....
if (result < 0)
	return -errno_to_blk_status(result);
else if (result == SAM_STAT_CHECK_CONDITION)
	return -BLK_STS_NEXUS;
else
	return result;

blkdev_pr_register()

...
	result = ops->pr_register()
	if (result < 0) {
		/* For compat we must convert back to the nvme/scsi code */
		if (result == -BLK_STS_NEXUS) {
			/* need some helper for this that calls down the stack */
			if (bdev == SCSI)
				return SAM_STAT_RESERVATION_CONFLICT
			else
				return NVME_SC_RESERVATION_CONFLICT
		} else
			return blk_status_to_str(result)
	} else
		return result;

This has similar issues as #0 where we have to convert before returning to
userspace.


Note: In this case, if the block layer uses an -Exyz error code there's not
BLK_STS for then we would return -EIO to userspace now. I was thinking
that might not be ok but I could also just add a BLK_STS error code
for errors like EINVAL, EWOULDBLOCK, ENOMEM, etc so that doesn't happen.


2. We could do something like below where the low levels are not changed but the
caller converts:

sd_pr_command()
	/* no changes */

lio()
	result = ops->pr_register()
	if (result > 0) { 
		/* add some stacked helper again that goes through dm and
		 * to the low level device
		 */
		if (bdev == SCSI) {
			result = scsi_result_to_blk_status(result)
		else
			result = nvme_error_status(result)


This looks simple, but it felt wrong having upper layers having to
know the device type and calling conversion functions.
