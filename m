Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4588CC04FDE
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 09:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiLIJ6V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 04:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiLIJ6H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 04:58:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CD1379D8
        for <linux-scsi@vger.kernel.org>; Fri,  9 Dec 2022 01:58:01 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B97nmAV008442;
        Fri, 9 Dec 2022 09:57:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=xp8xBHYlQFj68Ds1g6hCIvC+sYOhMIpT9HtufHRLGGw=;
 b=OPZXqrGN2Xnrk6AC7bHztIpD/wcixVJYMnS7y13VCoP26nfECQy3hQhUYehqMonKUD93
 KMcmkAto7+V3RH5tmW4AC3beN/uWta/+3Yx0fKwr483nzTaG+jMR9kxzTtALW+OITBlh
 5F4abiVpLKNC6Q770THuR61Nnew0M7YFH02t7RoNPFA8U9j0baEnGV6T3RA3KS57z1Q4
 yKhV6IXXfHPMMaFiTszLYcgUMk+mQL4IvuGuf1LRilDDWaFtHQLW3rb2pWHsfEzIdk+v
 AkpJcK4SQFR1nTORtjpuoisUG42VZnJyd3FqyvEQL8/d1vrd6rperujtijCKFP2+yaet Hw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maudkcwjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 09:57:54 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B99l5Ya008445;
        Fri, 9 Dec 2022 09:57:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa626str-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 09:57:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYaatzjS3/wrj8WTjYzeFdFWwnbykeOtqnfl3LVX+wu+r/1/kBUvJTVpqo8iJ+RPmI0l3mCfnz3YK0nAKlt2+EMowaiOw840dW53ePk4VLKxBdRYLQeMDTCp53oxNT4kdv7tGY/zFnhyaNZPW1+QFT5U0RkdksesPR6Gxi5RG2yRdj7Fk1lEPghx8IaI1n6uCFci0hcUvsvdpN4lOi1SMiUKp6b/oUMp0OrB8cn051kwdF3/ujEwIasOZmw8DQd7Eoctzjee96A59FkvBP+lq+jRc2w/W0CouQ54yq9SDR1Kn8+Or2zjbcsncC6q/v7g0sKlqiuKqgE8iU/kZup7Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xp8xBHYlQFj68Ds1g6hCIvC+sYOhMIpT9HtufHRLGGw=;
 b=AcbEYPbLuWOfBda4JsiUJ+iGvLdocJNeiE8hYhbDPFJBfbnigsX5CpVK+FafhZN2t58KqkduBDtHjZd9FIzTExuy6SaesgTYX1jvFcH8nRfyZWk0Pcd7idcGtVBq1uBQDG9Rysuc65Uelp9Tppq2K66iw5BSrYivQCY/ZmWEVyljJ3Ek4u1oLgoaO18L0sMpIjiL3KAHireUemLc7xcPLpsYE/xeuovl6yGqPUMYyCdmNX29iPj3mCSt0U92wyapftdd6YIhAXLF95TPj8ZjezcSSbGUJR9Ph59SyqQq3tWas6UJkGb8RkPQS7niPwyxg5+Ipl8R0d7s8SO0BjmYrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xp8xBHYlQFj68Ds1g6hCIvC+sYOhMIpT9HtufHRLGGw=;
 b=txByY9b9tVWy56q7hFfU7lVubt4JnJ1KsMMDV341bveGgWDynn/LYIQm/DHVCrXlg+8wkLe/uhbagfjBJKItaVSIwcolVEkvS8jXPw2OhpsUIywACTxbOq4c4bJ4S/6cjUjGkMx43lx+ES4InVkGkLKuxuuoOaICNSGTRjhlwOw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB6772.namprd10.prod.outlook.com (2603:10b6:208:43b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 09:57:50 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 09:57:50 +0000
Message-ID: <457c58fa-e0f6-8001-6926-bc6c7d2ba1b8@oracle.com>
Date:   Fri, 9 Dec 2022 09:57:44 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 04/15] scsi: ch: Convert to scsi_execute_args
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-5-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221209061325.705999-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0249.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:350::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB6772:EE_
X-MS-Office365-Filtering-Correlation-Id: c7f6f363-ac3e-4315-a973-08dad9cbd4d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YYYyi07+Eue33uURMd5OCprlm0kmayw/AD0TKymZ8+mSO0/KLC8OB3wimKYNhuSGncktypQ21LWRDi1Ueo++rvSPimK0Ba/vhFyE/sNrtGQPZvc6mWV4LP/A7upV8hFcMDDgyqS7xcmmwAsKww7TDXqLsPKzF/yp964wP/cu1xHxLsNRQAyCwe6Acuv+FxrCx8NubWRCeap+MjhYw6AZlmQKFlyD2bIhCPT/sBZiJo/KijiYaRQJOaj7QIXDZBkrcfGBXtWE8kDeZVkYHloS965xf31IMFDoyRakfRK+zyBrW+TO8+LVmEHfD3JLNee4xlx+WkF92yDwIDx+nB8b97UzfqvhJ0HcBm4KDghrrQB9MHtfEzRvpgmkaDYgdVwYY588g2n3e11xxUiKGDYXBrawnIvwF3eU02OXtkCRHetBPwmz+1CXgKvaRaN/tQeCP+RXsQrwafcqYhe5QclnUfLyU+s8xuXk7ekTfQbIyMmvYd/6T8cAPsskh7BHpZbfStSD8Mi4PbdhrMgwDZkqO5CThAlGRnAOG2KmDhWLeR5CP19OiALMciZJOB1whJtku2dsXyUdA4M6HiBwhmnv7pT1OK1vgtkYu9iy9zekp0aIXF2Sxlp2PRcy22ZHdm4pfQpiWCK6rSP0X2FiKRk3C0xKtQBMlt+/Y/YIkNIxHQrRIS9k4sAMVUevyGrfnLl05iHWBOypwmy0V/aGNoEBV8PGK4nfOK+vJWyxPynrhrlg/NZd4D6bY+zunbvbTUhUS+3aofl1pZs3xd7BufMmmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(136003)(39860400002)(376002)(451199015)(6512007)(26005)(31696002)(86362001)(2906002)(66476007)(8676002)(31686004)(2616005)(66946007)(66556008)(36916002)(186003)(6486002)(558084003)(53546011)(316002)(41300700001)(6506007)(6666004)(38100700002)(478600001)(8936002)(36756003)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2xzUm00YStVYUtIRFdOU0l6R2ZxelJJN3U1MVlGNVlTWlRzSmt0MDk4c0RQ?=
 =?utf-8?B?RS9kTWF1RmRUdFBsYlB4R0hpeWlvaXdaYkFTZnVDcjByUG15alZ4T2VpS1ZX?=
 =?utf-8?B?L2ltRXJjU2RUYTIyMmZrTlpLaDR2NFFaOGt6OURnamZwcHBrVXArNzJuYko1?=
 =?utf-8?B?YThpdDZFUUduVTdPbEdsUmp2NjYrYk0ybWYyaWZIVGFKVU43eVBlMUxGeUdK?=
 =?utf-8?B?L0FSVVloY2xyTTlDN2h4MzFrV1FISEdla3UxYkF6SmtPdEJPNnFPWmlJQzFv?=
 =?utf-8?B?Z1VXQVVFTTljV0hEY0lVZFRHZEtLUU9jK1NwNTFWazBOdDV6czN2R0xuZElh?=
 =?utf-8?B?ZVBNZjZYbVZ5RVVoWHhveXVTNlpaK3ZhMnJlUHFZYzc2ZEduNUtxUXYxZjcr?=
 =?utf-8?B?QS9mNTE0SVpBOWdWRFpGbXRmUUlIdU1TUXI2eUVDdnc1T0UrVGdkUkZ4b25P?=
 =?utf-8?B?MUpXQ0x4V1JCNlFQVGdxMFFXQ2R3b3h5dlJ6eUdXOHVlN0JuYmZFUkttVDM2?=
 =?utf-8?B?TElGNHp0NnJMTjdEakM4dTJ3cUc1OC9LbGFaT3JLS3lvSEhNVFBvQ2lQS1V0?=
 =?utf-8?B?VkQwTWltS2dnckdPUzVRQlBlbTZTTFIvenZVSVlVdkFlV0EzN0JmdEdETVBr?=
 =?utf-8?B?ZW1yOGI4aUNGdTh1amh4SThCelRDQ041bU1XZXoyNzEwdWpwc3VySEpSSWxv?=
 =?utf-8?B?R0hsbnM4UmFheUpvZTRJRGR0dEU2U2JCaWhDV3JhSzNHZFFBTlk2di9IK2F0?=
 =?utf-8?B?RHl5QWJ2MmFUWmgwNUExakZxWVFkREhDZGZVaU5lZUZFQkRwaVlYL1RVSm10?=
 =?utf-8?B?OGpzTDREc1Q3U3RmVXA4RzAxNG52cVh6RmtJUjBqR0FyZ3NPNjlWdFE2cHpw?=
 =?utf-8?B?TU4xV29Qcjh6TXBZaG5CNHB2ZFdJdi9rc2FETW9KdGdqZXNYYWgvaEM4bkNG?=
 =?utf-8?B?WmdHNDljY25CZ1ptVldLL3VwV1dOTzY4aU5xTk5CTFpDbndReUFqL1h1RkV4?=
 =?utf-8?B?THZXTXdPZ2VLWFBKRjM5cVJja083OGlaWHZvRm9KdHRGMDhTYzFvdC9ySGNl?=
 =?utf-8?B?MHo5bHljVW1TQ0p5ZXlDZHRzOC9JcXhYU2JsYWZVamttZ0lTeGM0YUxhMmk1?=
 =?utf-8?B?YnFjNGxiTldxWXFIVktqOXdSY0RnUjc0S0p1dVE5eTgrUTlpRnF5MFZ2WEJO?=
 =?utf-8?B?VzgzMDVRSzMrVkJURityaHFXb3Y2WkdheEtINWkybDdmSTY1RFJuQWQveWVU?=
 =?utf-8?B?b2JnZUtNeENJbE0vTjZMK3RHVTdPcmIrQ3pCWTZBSlErQnlZYXlwSzVWanVV?=
 =?utf-8?B?aDIzbS8zTHhWT1RLeTdBK045K3o2emw3UTcvVkVDWDQ2aGd6d3BxeVQwQ1Fn?=
 =?utf-8?B?R0lsZ1hvUnlxc1J4OUk3cFhVTlUvYTdFeHZEREN4Z0VpdklGMUlyeDdROERR?=
 =?utf-8?B?a0paV0NSa0N5THcwendTVGpyVit1WVNrMWl0YTdlUXg0eWpaOVJ2T215eWdj?=
 =?utf-8?B?dWdXSytQdFNsblY4TjB5bUJINmlaWENIZFpGWEh3RHUvcDBoV3AvNlUybUNE?=
 =?utf-8?B?cElBaE5tTGx3Q0RJR3cwcEpVNW5rUnI4d05jNWFiaFBveU5qMDh4NTdyQ1Fx?=
 =?utf-8?B?N29SampXY0F2MWVZd2F5S1kxR2U1enRib1BMNllzbGtzdWp4cmd2bzg2V1V0?=
 =?utf-8?B?YjdXRFQzeVo2WEg2S0g3YW8xczNSV1FqdjdndVZPSTYxaW5BcURNVGo1SHlt?=
 =?utf-8?B?d2QwVngzRU9KRlJoc0FEQU9tNmxkY2J4NFlBcmJyN2RueU1iYUFnbDZkYU1I?=
 =?utf-8?B?Y0cwb2hLRC9TeVZWeWFTaWNnV1BhbWFaY1dyZkt3SGtSbkQ1SzY0YWtQQTl6?=
 =?utf-8?B?dXlOR2hKVEgrTmFuallaVVoxT1M3dUwzZ25BTVg5WFI5aEx3bEs4ZWZOQTha?=
 =?utf-8?B?MWFKdkNGYVBnZEF6SWtFOFVidVkvZXdQQjhuV1plSlZ2cFBHU0NYNzdJMFFh?=
 =?utf-8?B?VzlZd0hkRi9YRjMveGUwdXJJbXAyWk5QOVFWSHoxS0dlSHEyRUpIS3dlOGpy?=
 =?utf-8?B?RzRQQjFhN2gwcVExUUpwV3RvUjZRTUtwd2Rjcm5VV2FDRVNDbEpXRDZVU2Jz?=
 =?utf-8?B?Mk02NWtuSFlDUkVlRTh0WmtNM0JURXlaclB6MWZjdGVuMUxpVzdOd1NqVjlM?=
 =?utf-8?B?Nmc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7f6f363-ac3e-4315-a973-08dad9cbd4d6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 09:57:50.1272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: toHVYwHLxcMdz+v1Y/DKqdjP4hQg2A2XmyJWY1ODEjzhsfqM0UCXJPUaoEm4Gewy9IOzK6CDRdLt1IExohbuhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6772
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_04,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090066
X-Proofpoint-GUID: JMav20YKX2BSVols1Qhsrl6f2o9fd7Cl
X-Proofpoint-ORIG-GUID: JMav20YKX2BSVols1Qhsrl6f2o9fd7Cl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/12/2022 06:13, Mike Christie wrote:
> scsi_execute_req is going to be removed. Convert ch to scsi_execute_args.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>

FWIW,

Reviewed-by: John Garry <john.g.garry@oracle.com>
