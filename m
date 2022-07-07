Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE5C3C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 21:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236476AbiGGVej (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 17:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236442AbiGGVeh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 17:34:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B8557211;
        Thu,  7 Jul 2022 14:34:35 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCYgK015405;
        Thu, 7 Jul 2022 21:34:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DMZDWiJXQWS53AyfXete/BveMunF3xH3dTHNxGHEJkA=;
 b=OU6opLAUSeEq8igr6jkoD6yDB3QJAUzPtEZ3wLb/jddO/tHmLxrYk5Sl6WuQGaEHzcMm
 uvulmz0Ttp/Y8ASTyO6fMcHy1jYYpuxxk/dB1NME4CwAZNHREIKTEhqoJdIye6XOwkMo
 GJJEkEARIvrRa0p89u6jg/3toUREXCtywWFjCMECmj5DC2uDyrsfzn6kFmdm0KLe89v9
 +kJTfN4NQ1i3ty8uuxxTVIxp9Q6M59WXrcEhhUUsOlVhNwhlknVC4lcsXTQfbQP713Z9
 sH4ACsPdrzY1jgOzvc4rO89WIwvfKf3bounD7T0dSztfxIgyJBXnQQfe5BPxDKBjqPhY eg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubyxaxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:34:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267LBNqk031251;
        Thu, 7 Jul 2022 21:34:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h4ud71u7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:34:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OC+yC4xJ9K/31fEs0+f2Tbtmi0OXvGgKxqqUzbOu1n2wfkq4NdRe68ZynjBdVw6y+V/ZXdQAGhlOfKyJ+31+6qilAb8oW3JgQP3WlEoIbwR5vGPux1oJgnsO7WCKn7q3WoJFTNxh66gnrU2fqbTDW8UGRGOqEc4MniLxk3ZVlyekEWd7/C8wF6O/fYEM3fVxmVwCCGizdw4mQg30hjFkgWxSb6n9R7wsqONA03K8LTOKZ8JddQJ44E6+w4afXC/io9r9ksnKp1T3GpVAnpkfTwpNt6tD+02trlPgLat80w31rh23O4+uY/aFaWt6eC7mVrFdaJbw5yOZZiCbiVPhAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DMZDWiJXQWS53AyfXete/BveMunF3xH3dTHNxGHEJkA=;
 b=mT2+Nhv2eOTzbY6wTIGXbI0SIQI3GAvWeuImH/UEgDenHWya5Uh8JdAlWMHBSd5cKGj8XrFx+ZTT92M3vjT50wePh0fD/OzEW8XmdiPNUGREcKV0MplzthEjZQKBz0P5WGUmmLKB+JTqaTzHZZeAjFqkdBDPUQ3INjRNf08sj6nmgiaVGW4A8xaVxotCG0iHrFutjP00XPbab0ZrDzZF/QpjidKwjiFoYJfjgcnbGmhK9jbYc6BcZkNcPTa8I9hKqq2RMOCRUx4pEZkO6nOfmXY6AZ30ibwRRcKLQpLKrqA6+M8nKBMpuIy2HIsHQx/d/N7qRdNAQBWE3m92yrfjWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DMZDWiJXQWS53AyfXete/BveMunF3xH3dTHNxGHEJkA=;
 b=EnlGCI8Jht4rQIiRDregjogKhDCF7w6VD3gQzwsgrnxy7T67WX+dQ8G266rI9q3vOoe/ySYEouzy1QDr/xU36duk7e0dxhQMpoj4skpek+awvbhWlJxMtnVlwTpOStBVo6Ye5/QyVHlQ7I+I4nKVTEQ2S6vJWFe8eQODDYDBArE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3133.namprd10.prod.outlook.com (2603:10b6:208:131::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Thu, 7 Jul
 2022 21:34:33 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5395.020; Thu, 7 Jul 2022
 21:34:32 +0000
Message-ID: <bf167e56-fcac-f528-3e12-a185cce4ed01@oracle.com>
Date:   Thu, 7 Jul 2022 16:34:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.1
Subject: Re: [PATCH 1/3] target: core: Send mtl in blocks
Content-Language: en-US
To:     Anastasia Kovaleva <a.kovaleva@yadro.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com
References: <20220630122241.1658-1-a.kovaleva@yadro.com>
 <20220630122241.1658-2-a.kovaleva@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220630122241.1658-2-a.kovaleva@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0104.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::45) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb0a5091-7e5c-4abb-2784-08da60607b37
X-MS-TrafficTypeDiagnostic: MN2PR10MB3133:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: enI4iE7lIl1KPmcqiRY4daCu1m3aqaCjf5+XPpV8CfD5sEcs9wVnAlbY6mOvimYtSsZQjILNaN6oI5tkrw7hGus294FJLdD6lvq3yHtFxCNavX7COEUCgARMddv2noz0VmSB5nAupKZlWHI8LAI2/PbM7zR9Su+nB7/oGro5AIz2NsPT/vmdgMzGk7+RfTa3LwqAAx0/hpkCYWqj6YE0GlbcwBT2Y2471FfbA0GiFD0efLv5CKW5xpIVYboQL6NPkjyPIv9/djzlU7oZOCsJERMvjvYWedht9BPCN7TzArs4Xo3zbt3rfanjhpp0AkgbLbSx6FO6IKI1QfuPzMpckqaRIGJA6fHr3/uROigjfPTow8WqHBBSovfUqVVa656sev2hwEe9nb0eqqqBgjZbmuCyXfc9auG6xfTyFTVipfzuGWa6MZMGOmDJ4rbzDl0fG67gXmXqe3av19oow5Gh1PjDEQwB7/0mqPIXmXVC7QWXBZFoJqlw8oGeFEh4k60vYjKNhs0V/J3xutARlXLvNHzp/Oi3KHU4Lvz9iXjunI6fofR/6yE06Izlp20Fvn7vgnsRWiYg0inA1rOScdSZ6dTbj+/KvkaODz2i9MyeTgEKuPwXQJEbxPsv/fG7CIytOnRbWRevPLI5FMkwFTSe7QCNPkHu+9MhjKFD15kem3pOQG9UIIq8oqkUpEFesPJTeipWrcfG8mVwT/kzuCP9o3tJW4Z2iuqMEh+JzQzk0Ib3QB10edRsiZcRv6gV/8lFqHS+ICmbevrX/qGv8DhLkdgEPhFseFeq2iEjepj8GbgBik00oBCIfwGMnvzlUJ17gzmyNJ5U0FKgyWyOx8bI6bW5LnIZmdW0x3GsddmEB9XcnjUtqgHju7QE0T7M3ToU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(396003)(136003)(39860400002)(346002)(8936002)(66556008)(86362001)(31696002)(2906002)(8676002)(6512007)(66946007)(6486002)(5660300002)(66476007)(2616005)(53546011)(4326008)(26005)(186003)(478600001)(38100700002)(31686004)(316002)(6506007)(83380400001)(36756003)(41300700001)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZXh1R3IwUnBjYXJRaEFwemtZTG9oVXlZaUs1bGFNa01oaEZNOXUvNDFpUVA3?=
 =?utf-8?B?RzMzRW52ZmJraGdwT05KaGg4R1ErOVptc2VUYklUSjBGWGQzVTQraXczcnlF?=
 =?utf-8?B?cVpRamp0N3Y0Q1U4L0xqUXJHeUM2Z2krU0x5eXRQVmdNNEZMKzZRblJzL2xV?=
 =?utf-8?B?UGxIT1FpSXVZRnVtQUd6R1k1Vi9Bb3dVMUZvekJkMCtzbHRhZm14amtncVpE?=
 =?utf-8?B?bDZDSVhXT2RneTBSbGs3cGFXNXpocnJJUEpkdElzYzlKbHBiVTFBTk92RGVP?=
 =?utf-8?B?S2g3a2c1cXNPV05WVUFGcVhQcW1zK0JYSlAzQm5kZGVhU2crcWFJOXlJdkxI?=
 =?utf-8?B?cUdNNjlGOVNVU3RtbXoxazBOK2hRUmFHUXVrS0x4S1RQTXdOczhOaVdNckpU?=
 =?utf-8?B?MHNucUcyeGJiQTJxcmRsSWFOSjZyUWRzSW1DS05kT1JseHdlWTFrTnZDMVpL?=
 =?utf-8?B?NWRDM3Q2czQrTjg1OWd6RGwyZEYvU2t6N0ljOHl1MGk0dVRhb09NODBEQjFi?=
 =?utf-8?B?T2J6b1lnd09WZ1EyZnlxVGlDSC9hL0pvaVBjUW5HTFI0aVpxdm5jSk54Rk5I?=
 =?utf-8?B?ei9mS0tFSnN6eUQ4NFRUMlRmTytFdGJVSm1DTTN2SDNoSWV6Q0ExbHI0MEpN?=
 =?utf-8?B?a2hxdU1jMjFTcnV0YzZPN0lTbmRzQzBaZ1RLVkFwaktQa1MwREhLdUpUWWlH?=
 =?utf-8?B?ZStjNmpWTlhVcFJiY1pmTDNRaFM5VzJPK1ZQZ25CMko1Q3BpYWtGQmVXSVg2?=
 =?utf-8?B?dzliRER2dVVaNUxqYXVUTW5POEMwOTRGR09hOXV1S3c2M0lVd3Zta2lBM3Zr?=
 =?utf-8?B?bWxoY3gvMWVoYm8rZHNQeDNlUGNEOGRMRlVKUVozcmlDQUVud3dzbStSSFpR?=
 =?utf-8?B?ekJOREtQNk5DemlIbVc5R1FjY0JjakY3eE00cVBUVmU2cW14UFJNTkZ6K1Nm?=
 =?utf-8?B?VWt2VnZMUDlNTGhPNzNWQUttTW1wVXdKenBBV0NnS1ZFdGZYVmtERjBCVjlY?=
 =?utf-8?B?dDhxSEU1eEVUb1BLUkNUckV0TVlPaFM1R2pvZHFoS1FzZnQ1VE1DeVc2dUk3?=
 =?utf-8?B?QjVNOWFIV3NzcE5ZOHFoU3pMSWFpNEtsbGFjeHcybHl2N1hoSlVQQjBxd3FM?=
 =?utf-8?B?T05SS2xyYzhjMmM3ZTJyM3gvUDlESGxnbjczRFNobUlhMjhiR29TTlhYNnFW?=
 =?utf-8?B?NG1BWW9lMFF4M0VlTzZhWVBxVHlYYzFMWEE5R285TVpPYTE3c2NwSXZoa3F1?=
 =?utf-8?B?RHdEbS94bFRnckoyb2NQMk4vaUdodmFQb1JsbVBXK0xCUEhTQ3BvUVY3ZzNB?=
 =?utf-8?B?a1hsYTN3QjV6NkRRcVljZ0g2czB2U2pQc0E4MFVrRTFHeVNBUFhYWVR2NE92?=
 =?utf-8?B?RmdZenZYRmlIbmxYVjFTa1RkbVF2Ym8rbE9wMXgwc2oyUkJpMU1ISGo5QnVh?=
 =?utf-8?B?Qk82L3NVdjRoZ0hYcWZqMTVvZU5IYjJOUDF6dldsTVgyNmpac3I1cTk1OS9O?=
 =?utf-8?B?MTV0WEphNzFXRnhIUUdVMDJRYk1zVVVIUCtjaVRuWFcrdTl5R2RaS2g2ZEg2?=
 =?utf-8?B?UUNSMHZwVVQrZlJMTzR4cC9BZzVJR2FHUkFOaEN4eWRNcjAwRmhwc0Eyam0z?=
 =?utf-8?B?TnpSOUZUOE9vMlQyVHI2WWhGQWFycjluN2xreWRGcHhtWG1LQldkZUF5TXF4?=
 =?utf-8?B?SWxqZGFPUDVOZHJuNGxQbkZ6ZGhBSTY2NW1TZHlxS0thV2E4TmxudEQzVlRS?=
 =?utf-8?B?cjk2Q05tRTRBcXBOd2lQYjUySzBMQjdRekROTjRPM0VtNktXR2svN2plN1lh?=
 =?utf-8?B?aXVnVmpGMFd0QWNsa0dxZG94Z3B1TGU3bkVwOW1Zd05BSHA1NXAwUU43eHhy?=
 =?utf-8?B?VGc3NTBYNUtEOW56bUhubVU1TDhMc2VvdldRWDQyVnByL3lrLzVGNkx0QXVN?=
 =?utf-8?B?dytmR1N3eFVUS05iYlQrdk5xeWk3NHNGeEREWktIRjVPWjEyUktUa1c3dm1p?=
 =?utf-8?B?VzdQYlgyYWQzdFh3QW9yVlVZY2I3SkJOaGd2YUJYU2dQVTRLclhLY2Jpd3ZH?=
 =?utf-8?B?LzUxTlZpV3pybWZiYnY3L29weTFLNmFlU2kwd0ZTMCtna2cvR2lBT2x4Tlla?=
 =?utf-8?B?VG5RQnBSQjdoa2dXczVkUjJBelEybjRkYm1rRm1FeTlyYUFWSVp3SjdHdTRX?=
 =?utf-8?B?a1E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb0a5091-7e5c-4abb-2784-08da60607b37
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 21:34:32.8091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E4HNqI0HtjPCyRj4IfZjkgIaDoMcrt3adZJSlhCpzEVryuJ0Xou/Zj50T1gdr3UouOEuhsvzYUx4GDa/ZH8gLHKpgMdiCL+btUIQL2Ou3iw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3133
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-07_17:2022-06-28,2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070084
X-Proofpoint-ORIG-GUID: 2oieW-fl7zpm_TWtD3Fb7NTLehsmvajV
X-Proofpoint-GUID: 2oieW-fl7zpm_TWtD3Fb7NTLehsmvajV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/30/22 7:22 AM, Anastasia Kovaleva wrote:
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c
> @@ -513,6 +513,7 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
>  	struct se_device *dev = cmd->se_dev;
>  	u32 mtl = 0;
>  	int have_tp = 0, opt, min;
> +	u32 io_max_blocks;
>  
>  	/*
>  	 * Following spc3r22 section 6.5.3 Block Limits VPD page, when
> @@ -547,11 +548,15 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
>  	 * XXX: Currently assumes single PAGE_SIZE per scatterlist for fabrics
>  	 * enforcing maximum HW scatter-gather-list entry limit
>  	 */
> +	io_max_blocks = mult_frac(
> +			dev->dev_attrib.hw_max_sectors,
> +			dev->dev_attrib.hw_block_size,
> +			dev->dev_attrib.block_size);
Just some trivial comments.

This chunk might be better after the max_data_sg_nents chunk below because
the comment above is for the max_data_sg_nents chunk.

Also, fix up the tabbing/coding style like:

	io_max_blocks = mult_frac(dev->dev_attrib.hw_max_sectors,
				  dev->dev_attrib.hw_block_size,
				  dev->dev_attrib.block_size);



>  	if (cmd->se_tfo->max_data_sg_nents) {
>  		mtl = (cmd->se_tfo->max_data_sg_nents * PAGE_SIZE) /
>  		       dev->dev_attrib.block_size;
>  	}
> -	put_unaligned_be32(min_not_zero(mtl, dev->dev_attrib.hw_max_sectors), &buf[8]);
> +	put_unaligned_be32(min_not_zero(mtl, io_max_blocks), &buf[8]);
>  
