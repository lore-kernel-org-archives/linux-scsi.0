Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B9DC19F21
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 18:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbiHDS7j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 14:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbiHDS7h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 14:59:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21755175B9
        for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2022 11:59:37 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HbgXI018623;
        Thu, 4 Aug 2022 18:59:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=11WgKtqpjk0BVkXwtDJSxNO8RjFTJhpyZikeS5CX4Vw=;
 b=BelReYlrwNjJdfS3N0zWkttyx4ye8ptYjCqByfOoJB6pbrHuZM5LNOb1XjQrCV+xnx51
 uVFXKEAnT+dUnSIIeVwA9FhZWgGDpq6ROj8VQ2VEEcUDklFOF6aOfscurBjWxdqIyD79
 4ydE0kR1nB4BZs3vlSz/YOYO9Tyvh4ztORC6sfjZYTN/jCOXUyCxG9cqtBoWnHhPRiJS
 m9OT63irHZEnNan/bb24XfW+nZj/vOluatrqfbIQG1qAH40UhjXPrCsd5IjT0oUlQmZj
 arF9Aebjxnc6pcr5DgMKOzA8/oW3Uu/NuQT5WS7AKpkxusiCYwbTyadJ9ehwQzV8o/rf 3w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmvh9whk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 18:59:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274HViBx014202;
        Thu, 4 Aug 2022 18:59:22 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34n9nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 18:59:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7n2uUsY5Tx4UQDtehZdFX/gGZZVy4ZZThGRcfIeMdYE4KEwX97BDhKgrZgVqY7GtGxZR6V7tWwbb4+tsZQXBkynP3pK54EjCUP/lU2VUpSVLPLQ4R83AlMidu/SYS+Q+F923TG65hPq4Q3GrE+JOqoH/IklaoyZuFklkhuYG93jCTKl+XTdI8kTc2My+yNyOKDg6rM5jZNNxK263kspEb7Ao9uVXf55CbrGs+T++puWWFEaBRaeKFl1pLtnOa8r4lUwzhin2Wa9jUWcJL8kN15+R6VJUd8IXl9Xa4yvhavnjbXmA2bEQvjAdhHduUTwQgRiGTUw8yuBv3FKOs08WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=11WgKtqpjk0BVkXwtDJSxNO8RjFTJhpyZikeS5CX4Vw=;
 b=kRToCZexN6DOhjyLHchQICVRXp4fG8nvVO3mdxHhQnFfUFC6596Vl1P3zFyYmcBXZezSisQKy7WVAO1nj8zIlA4GxWergkzCgEYOEJ2UrTxJQffWGkUVn2aKn77PDtJ4exKb85avMiPVOdpMpxlp0fTNGMrn5ebh2K/vOKFbnjT+bTa7yex4uRcMZpUKA/8p0+C1plXhLxN6snv5yFyfYNnmJ3Xuo3XbjmnsD1D298SPsKHYUv+j53umeT7shVmDxne/nB1jozUMME3NU/Ba8j9Fjw+uvbWRYmLmFC6LiB8+Tik2AFKxlSFmnAQcPKi4rOhsB44R+0Cam8EjklGNJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=11WgKtqpjk0BVkXwtDJSxNO8RjFTJhpyZikeS5CX4Vw=;
 b=Ea0qrnkcQ5WNMuCB97ssN4bLisOqCyjiwDRWRN7NbZWV5dE3Ox695v0b/CN7BL68peJ/nXx4APT0jv59dItim5R0a7izXyfl7PgRcbikI6chGnSHfR4eAheWyplodG0c79hWAh6z+JMJaXKFfyxw6bbYjwVnErWgdGAcSz1lwvE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5858.namprd10.prod.outlook.com (2603:10b6:a03:421::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Thu, 4 Aug
 2022 18:59:20 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 18:59:19 +0000
Message-ID: <51baa06b-ed8a-5de8-93da-6de97077173d@oracle.com>
Date:   Thu, 4 Aug 2022 13:59:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH 03/10] scsi: uas: Drop DID_TARGET_FAILURE use.
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, manoj@linux.ibm.com, mrochs@linux.ibm.com,
        ukrishn@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        hdegoede@redhat.com, kraxel@redhat.com
References: <20220804034100.121125-1-michael.christie@oracle.com>
 <20220804034100.121125-4-michael.christie@oracle.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220804034100.121125-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0059.namprd04.prod.outlook.com
 (2603:10b6:610:77::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38586bab-7db1-43ea-0d42-08da764b6fc0
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5858:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KwvdBVcO2oIFf1eKLpM7eFrFI5aTJhKaEhMDsDZB5M9GD2N3QS/kYmFAM7BPKy6XSRg56wY9k0V/TKJj7A/YaVDIqBV3Fn7FhIreoqAOCDHPehCKJ2D8UKsxEZyBaiJi1u+lFpNP1pKCMMz5yWw9CAXnTCo7FqfQM0ZZq6DLrXYkvj3jfvDLytJkJpSnXhrIwoMulCRvdj/IX94/tttQWJ4eReXZ/wnXwN2PBX7saxZOcsYzST4f4EynR/3oZBkFm6sqUZJ551z2oabWWIWiXHVmpq7zqLWKATweRB3KfP2bt/oOYyx8uVqRl6e13sa2dnOE+A3W5St021R4r4MF5Meq6IltdnotD3zAbzOYxyIVJmq0FOhPvjkCLJSb5+kBsBfFtsdXCLPzj34Jr+evLhijlmGkGxiGoFPdcyLZxYCbt63lEVQxczeyuWBNEaM03bMXqutRo59eam+tDSMHguKVeCvafYRwOseK34sFID5TF741O9CvXMcd9SoByubkUTl9ZsziSFhO1a95VvGNi0cnI69uZdWTD4YuHhEBw+3dHQb87MWTqpRWVtlunEYnp6HNgD1HcFyiC1z9wkOSbQ4pbIcxj0yV1OzhFhVWuxyKUdbyXSOXCZm2vyoij8gmENT46K8id15d2ve0hfI3ThD9VJGpmeTIXJdtm5XBc8CamgKz4S2QIB8+y6FIG4JiZyOLT5RvEFG1ljuD2gjIzTzmXHTHefKagKpXYeZavr8Rb+TkOEI0f5BPbfV9/7++seF1GE2LfF35cF4dimtEzrdaLNxP1yazAzI4VY0EyOmiIYabmDlQ+g/HeDGmJ3327uE5G2PmsdLdZp+VNk61qtZU7pqEP5G0lgYya+Mo1E0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(346002)(39860400002)(396003)(366004)(66476007)(8936002)(66946007)(66556008)(478600001)(8676002)(7416002)(5660300002)(38100700002)(6486002)(186003)(921005)(316002)(31696002)(53546011)(86362001)(41300700001)(2906002)(83380400001)(31686004)(2616005)(6506007)(26005)(6512007)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXlTcjNWcnFyMDRmWmJ4V25qRWJQTGJhTGdsZ1ZyUXUxTk1lY0ZXT2RpNWVC?=
 =?utf-8?B?Q1FCOUp1YzJrclgrY1dDTkR5RGovWDlyeTZxeDNzZE0zTzhmZVQyK2FVUEtq?=
 =?utf-8?B?dkJLdTlzdDFLd3laQlZuMGx5M21Td1A0ZXNCZTRQL0FEaTFqNkVtbUtnbjU1?=
 =?utf-8?B?bklnRis0MnNIUnFYM0dNZUI2empmNHNDYUdON2c2dWpxZ2JsdHJYZ0w1UUc3?=
 =?utf-8?B?Nzh6cWVQZkJ5Ty9TVUNZMTlRODR1eExsVWNaRWZ3czBoMjF6SzdIVEtDR0dr?=
 =?utf-8?B?akhGUDZkYlVTU01HYUZUK25Va2JYZ2tEVUJTTlVub29paHp2WU5UakNENXQ2?=
 =?utf-8?B?NWpoK2tlUHhubFJXMU9BOS9mSDVscWhrOEpRTklCTWRndjNWNzFZaEN1clFv?=
 =?utf-8?B?dEVmUmtsUGIvS1lBeUdWUGY1Vy80SDNub0ZuWXFDSUIzdkZQb2tmWGlLcFBH?=
 =?utf-8?B?RmJ1R1ZtSlNITU9yZTEzUmVsL1JpUHZTam1VVUdiRCtPeTdodmR0Yk9KVGxX?=
 =?utf-8?B?eWFTbElOd1Ntc0kvREdITHVCNFowdWxHQ3FRNWl5ZVlOY05ZWmpubjREc1pM?=
 =?utf-8?B?b2l1TENuN3lkNS9OVmtMSE5iOG13Qlk1dlBqQ3ZmZEU0dWVNVm4reGpITGlt?=
 =?utf-8?B?NDdsdkR6N0xJRkwySGVvNE1TUXJldEtBOUFNaGs0R3BWVkJjTkJhTHNQZHB2?=
 =?utf-8?B?cnNRZzExdmJoYmY1dUF1TDk1aXd1b3FqdkdOLzVOUWJSS2wrTXRldCs4RGYx?=
 =?utf-8?B?d0ZFNDlZZnFUYWlVS3YxdERuUWJKbjdkaXE5R0VScis3Tmw1MmRBTU5xUTNq?=
 =?utf-8?B?SHNUVXN1dTZoc3BSYTlPTjNLM2svaEM1LzJhL2xEMEFadHNSU3ZVRGV2Y21U?=
 =?utf-8?B?ajU1eTRwVU9wamN1OE5BWU5YL2djRlkya3RjK1AxUXBuMUt6Y0dibHNWVGxm?=
 =?utf-8?B?S2hLUVArK1ZHc0ZROWZrVDR5U2w1aWs0dnVsNW5JV25NcStPdFBqbmhWQUkw?=
 =?utf-8?B?dGMremxCV3lKZHp0VDd6SThKWThSUXdIbnlCN0RCY1k5aFJNWUprbTJvLzQ0?=
 =?utf-8?B?RmI3VENaekNRUDhBVndobDZPd3ozV2VlRzMwY3VwZUJWSFkxOWE1MVMrR1hy?=
 =?utf-8?B?eHBGWEFIMk5MWjZOYXpKTm5ib1gxeDEzRXRsNFh1bWc3RGFoODlDb2FtandH?=
 =?utf-8?B?R3piK2dHZkpBZFFQeEhmRHlQcktoSGRMTnZxSjYwNVpKbGtPbmRVZ3V5Y0pt?=
 =?utf-8?B?TGlnb09KWDJZM0xqcHU2aDVFQTFHeUVjYnJQWnFJQzBvMGhRRk1TSjdnTWsr?=
 =?utf-8?B?Q3hnQ3BFbE1HS3lIUm5KT3Uyb2FaUW9XcmkwUjRJd1ZycjI4WFRBKzJXKzZN?=
 =?utf-8?B?eHN2UkYwZEVtVFhuZmJxd1dyVmtydHl5TzRxWko3QnVkN2ViRWZacElndkdr?=
 =?utf-8?B?eDREZ1pxcFpJV2NpNzJGMnR2b1FBQmJYUXFac3F1T2Fjek5QeGcwZG56WTVJ?=
 =?utf-8?B?bHhWK2h3L3NIS09wSy9xQ0l0d2htbmZ6QTRjV2lrWm5PWlR2R0hqOS9WZU0x?=
 =?utf-8?B?dXIxbER2L3N3b3hlREZyTE55UW9KUzEvOU5NemVjcWpBa3FKTGMxcGhoUmd4?=
 =?utf-8?B?b0ZoYndaV29iNER2VXEzcmozL1Y0SVB0OStaWCtpVjlUNU8yaGtRWWNNcVpu?=
 =?utf-8?B?OXdZY3hDOENzTzY1ZnZTcFRiUjBkcEJqbk5FYmlCOEdxNkhjOXF0UUFoNlA0?=
 =?utf-8?B?RnpLV2I3cmZrYzlhTjRjK1ZxaXdnNXlpaUFXK1p4M2pKRG9YQWh2VEpjQlBD?=
 =?utf-8?B?YzJtVTFxU3h3cmx4YnhuVlR0QWQzbGsxckR3NmZIYzFINXpYQWxJa2dQVmRN?=
 =?utf-8?B?WnY5NFZWQVl4R2dZbHpDbVpuQ1RzSmtnaHVWK0FwTVN0RGZCTktYMG40YlZK?=
 =?utf-8?B?RHFIUnpNYlNidDJxNHFWTXg3ZUR5WXZwdG1sa1JOSEU0anJlNktFR2RqQS9C?=
 =?utf-8?B?eVVEWHJkdCswS0ZZeUtwVnBHWlB2NXA2S2V1dW5ZdlF0KzBLSEVGRW92WEZY?=
 =?utf-8?B?ZXM3QWV6ajEyVzhFK3BIeGt6bnNPSFV2RW9DWWxQZVdLNEdwMit3MzRsQlJV?=
 =?utf-8?B?Uit3OVlpbzRtUkNWNjNZTlE5QXBJZlhCMWM5SStEaU9GblFTV0hLUGtwQkVv?=
 =?utf-8?B?ZVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38586bab-7db1-43ea-0d42-08da764b6fc0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 18:59:19.7547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FLP03mssdFpeaBWgjHWIhGnusiiN8Kh/7ZPuk1nyn/YxmwKfC72nMZvFryU3JGqdFIj+ADcCBW4Z9ExctCDG6xNLHb/lMieur86TE+Kg/Uk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5858
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040083
X-Proofpoint-ORIG-GUID: EjL6Rlxo6rph-IQQ4_3Zn2lj-dx2pNwl
X-Proofpoint-GUID: EjL6Rlxo6rph-IQQ4_3Zn2lj-dx2pNwl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Adding Hans and Gerd. Sorry, I messed up the cc originally.

On 8/3/22 10:40 PM, Mike Christie wrote:
> DID_TARGET_FAILURE is internal to the SCSI layer. Drivers must not use it
> because:
> 
> 1. It's not propagated upwards, so SG IO/passthrough users will not see an
> error and think a command was successful.
> 
> 2. There is no handling for them in scsi_decide_disposition so it results
> in the scsi eh running.
> 
> It looks like the driver wanted a hard failure so this swaps it with
> DID_BAD_TARGET which gives us that behavior and the error looks like it's
> for a case where the target did not support a TMF we wanted to use (maybe
> not a bad target but disappointing so close enough).
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/usb/storage/uas.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 84dc270f6f73..de3836412bf3 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -283,7 +283,7 @@ static bool uas_evaluate_response_iu(struct response_iu *riu, struct scsi_cmnd *
>  		set_host_byte(cmnd, DID_OK);
>  		break;
>  	case RC_TMF_NOT_SUPPORTED:
> -		set_host_byte(cmnd, DID_TARGET_FAILURE);
> +		set_host_byte(cmnd, DID_BAD_TARGET);
>  		break;
>  	default:
>  		uas_log_cmd_state(cmnd, "response iu", response_code);

