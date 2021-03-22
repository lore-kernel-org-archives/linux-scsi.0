Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F48C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 17:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D62BC6197F
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 17:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhCVRnt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 13:43:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36610 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbhCVRnk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 13:43:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MHYuF3145059;
        Mon, 22 Mar 2021 17:43:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=mNv6IQn1+DzRQF7TCF9uSa4mFo0Xdcv5upe4sygfy+E=;
 b=kkgGA0ED/n/E5IvsPVT/S1DH9vtMfcJBHsM6AOBb7upaD0u5K2yUbkewP+mGbPjrDWKp
 o5nnK0S/8fZUYpYSxysbwPdKJF7FX8WwaKsu9JoRUaLfr2br5tGFd2xCnq3KSe7aAEPk
 AIITYqKb9BXWp3BT5QD91FlVBRIvlo2zJchZCzR5GnEusEYs2b8UXHeOP5h+3SZAZxl9
 wDOVSFikCKYhQhS+CxvNX/ACbLusotd/OFsEfv7Zd14kR4pBkYTMXEdC8bRllinK/Z/z
 SH5x77y416wYguvRuMqWnD4rxe8q8XAFQTnaRr428NOcp3R+kPH3dqtEtEuHcGv3UEYK Zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37d8fr4anv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 17:43:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MHa50N060347;
        Mon, 22 Mar 2021 17:43:31 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by userp3020.oracle.com with ESMTP id 37dttqvjf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 17:43:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZFzwHsBWcTnd2Y1lHzCCSwq1XMkCcT6PTrjpA/fLDao3nQi2z9MvB7YpXki96jz6k2OnV4bio+Rmg33wG+9F51Rf9Kt+saUyIyCJx1/QDmxyrLpiim3JdQ+nzSBvS3afe6kRfxzve0QsKh6q8xriaDy1dZQsKUxbtRr/NRqDQ/buZr8KXG+nFGw3o7Ugg+AnCSW4WuO6n+m+NAXcSV44YZFTa72p6MWfBsVKQpWZvt9qu380JQDYlxVIrYBQvUKSBUPxAoQnvBwQacgyugRP9n4FGRjbwRBVxCteoRB6KrcpFX0fRBwhYbdXSULh5OB7S4sMLLQktTC/KZAm1+9kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNv6IQn1+DzRQF7TCF9uSa4mFo0Xdcv5upe4sygfy+E=;
 b=Zk7f6EOZgHkkWh7HFOE470UNzl4MSOXib0R+amyBH7jpv/ngUmxehAuX9XRv5qEjTyIBP6mp6wdYSIJY5sr3sesZpWaK55c8Ob368adcnkXTMQlZMdW0kJJ0VPBaizMv+3wUUUGJmM4Pj+N3EEJJsGbs8P4IDeMG+3PD/XgZcm0PHIRPRcES88p85ZVskzDkDoccRGaZm+apVrl6HDlRsTc0K2jNfKZKh3MK/Jg/qUYHJSAruyxsqkeMt+vI1g3tlmQCBkGmTMfmsKOcYe6CHDYQZ1bAoQFf0jlQcVpfc3aWhMvQzxMEgiNjrgO09nwbip6abDGPJjOZcB/s9ZEIiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNv6IQn1+DzRQF7TCF9uSa4mFo0Xdcv5upe4sygfy+E=;
 b=Os9JoT2TSzWuw0wcm8y2irgJW/Xz+TiPzvXbEy2B7qnGM5qQB9ZGT7t+Vi0vrUjROL3ykuH23F0DHp83MTPiBeFQxSzPU/zJle0PrNxOpnWAFVmt8yg9a7PnyV5OZ+CR4zGT5n1G27fPnGb3h6dIaKe4Lx8Mja5OkPXiwKd41Ec=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4767.namprd10.prod.outlook.com (2603:10b6:a03:2d1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 17:43:29 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 17:43:28 +0000
Subject: Re: [PATCH v2 2/7] target: iscsi: replace enable attr to ops.enable
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Bart Van Assche <bvanassche@acm.org>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20210322080554.7611-1-d.bogdanov@yadro.com>
 <20210322080554.7611-3-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <bf10a78b-e95f-8c3d-7af0-7d3802152eda@oracle.com>
Date:   Mon, 22 Mar 2021 12:43:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210322080554.7611-3-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0009.namprd21.prod.outlook.com
 (2603:10b6:3:ac::19) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM5PR21CA0009.namprd21.prod.outlook.com (2603:10b6:3:ac::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.1 via Frontend Transport; Mon, 22 Mar 2021 17:43:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bdc1fac7-0862-433d-4a3e-08d8ed5a0092
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB476719692A0E45A0B5875BC9F1659@SJ0PR10MB4767.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MsodNRnHC4Geoix7PNM4hsA4zdETwnQ0H7ABRIwItIzGenXjIVpkJ+be4ToG/8Z5nuBaMo2BFgoKjrhC7A8IaFaVQSh30TR6A2prBjpvY1N6KC3KhoVfKfURXBx60ounjIabTiBUtXe7fNlxPl1+0vwm7SrXzS748TXcV5AExTxtN7o3t/HoGQM6AJy/+7ymshUqGhVeZD9RCKF981fQRMizaUws+Dy5CRdNBv53JPOy7Gt76fx+fob6Lg5++W3oK8MkIf66cIa7tZPny3hV0dU/slw/kR4Ul/ZCQlRriZXGLiP47TWqW06HuhU7R0yFK6V2mo0F82cRbdjighBhu/yC1SGwfpR/O6qm3c8tXUjudMIlmwegXbhgDBR99oM+oi7By4kQc/Q9Zf3ZlsYFqQBZk/f+XV5eTQBpDN9ruLuX0ocrITkYESWExZw9+CX9kfoyuqRyAN36drENz8UWobcildagkzgRtdJfke5DG4hqPEi5iiLRObVHUb8ZFXQp/pVTuaDZXG7ipo1JRmSNK8zESj+s3O1fYMdRzincY3Z1v5zH3VSFt4p6FKph2yrHgXlZhvHmW+9AUrzJB0id8DkEpGud5uakvvXCvLcIaSClGghYCfsYHNkY6gt5iSIHq6S5v+bcaK0LNf/S1K7Gz3eLkS7YsJtF9suS955/EKioP2ewH2w2FFnGnSv50cTXxfDjcceiJqN4MUFtj7J6cp42Y4AKbrpT4JQTVBnLxWvUk+LLhhcB5azU2Yu7eRCo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(39860400002)(366004)(136003)(6706004)(4326008)(478600001)(83380400001)(5660300002)(8936002)(53546011)(66556008)(31686004)(86362001)(66946007)(7416002)(31696002)(8676002)(66476007)(38100700001)(558084003)(54906003)(110136005)(36756003)(16576012)(316002)(2906002)(16526019)(186003)(26005)(6486002)(2616005)(956004)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OTNTUWs2eTR5T0NldXJDUVdnRkR6cTkxV3hucVR6NklvblQ4N3Npb2UzZllx?=
 =?utf-8?B?QTk3V2VRQzQ4Sk0xbjZ0amp6eFk1cWdERlF6TUtSMHhyUU1rSXcyMEhFbUJz?=
 =?utf-8?B?aHVxQVJwNGtCbk0wSVUrZWRkKysrRCtxYmV3aHFCOVUwUXBzNlgxYmwxcnhl?=
 =?utf-8?B?R2Zsd1RoQnEzY05xaG54ZDByUE1YeWZnaGxRMElHb0t2amlaKzMySUM0MDFU?=
 =?utf-8?B?Tmo4L3VaMVk2VUsvWnlyK1U1blF0VnRzUTY0cEUzT1UrbUNwbE9OMWpUWHUw?=
 =?utf-8?B?b3lFZzBBZFo0ZTBGZ0Jja0NUMnozbDhjcVAvME1QVE1md0RsNkFTVkFReEJ6?=
 =?utf-8?B?QmFkbWxPUE9kUCtaZ0NYYkJtYTh0bCtmT0RpU09WR1Q3WFpOZEdDMDd4NEU5?=
 =?utf-8?B?dGpFRGJxT0loWWVQTk83L1Zydk9vQkhWZ0oyWE9rRnZHUnV1VTAwU09zcTZF?=
 =?utf-8?B?VmgvM2NPYi9admFwUXJnNCswSXEybnhxRjQ5RkxWZitTL1pGRW52d0x4UUxI?=
 =?utf-8?B?UEZ1cUtzbS8xQnVNSEJmOUQ1RHd3SXZWVm42d3VoNHluZS9NZk5OdGYvNjFD?=
 =?utf-8?B?eWJDRXQrSHRaNVBBem9wbDN3RHVFVklzT1B5dXZUSHYzL1cvelk5VVNJTlRZ?=
 =?utf-8?B?VUZoeFg0bGsvYXI2eEZ5Y2tzczAyamc2SDU4SWlCV1hiLzFoWjFIQmc3ZXNW?=
 =?utf-8?B?R05TWkRheWJxKzgyNUpLakRGdEVwdy9vcTN0c1Z6czdveFRvOVp3SjhCWktP?=
 =?utf-8?B?c0JPZHY4N05tYnFxMDhrSTZnbmZmTnJsWmJ6MEljeW82MS9NZ0prM1gyZ1lM?=
 =?utf-8?B?TkF4SFFkdzNEMUpyVGdMUDk4RVlBSmQ4bXlHL2FKaHNoYjRCQlRCeDl3VGp0?=
 =?utf-8?B?QlJRZFNqOEZJNjdBWjZlT3lmYVBjSmlTbVVBVXBkZGlwY1R6VmprYW1PSSs1?=
 =?utf-8?B?NnNMRHI4QXVRSVV0RTFYaGFxTTJxcis3bnRZSDJrdW01dUhBVFFTb2tjdEtY?=
 =?utf-8?B?dmdyNFNZYnpBNmJOalpvQTUvLzA1OU5WMVYwckFTSFcvUDV3cjhmaXB3TkNv?=
 =?utf-8?B?OXBOK3ppa0UvMm1TNFgyOWV5NlErY3NpVE00aE5zQlJSWEVRaDRkUDZ3MEpM?=
 =?utf-8?B?elZ3Q01sWFd2cGJvancvQ0FPa1Q5S2dCZXpNN214OWxqUkViWGZyUFR0SklP?=
 =?utf-8?B?Q0d5VEVwVXc3RmRCYkF6VnBjSnpkRnRzdUdwU1dRNEtMQUN0RHM2L1Y4ZDM5?=
 =?utf-8?B?QldFZ0xXR01UYWR1QkFLTmtpZUxYSHZpSEhnZjdYRDdFcU13ODd6c2JJL1Vs?=
 =?utf-8?B?WCtENXB6NENUUG9JbTFmOGdDT0ZQRUNPK2piVFdTZjhIcmxrUU54dDRDRjRh?=
 =?utf-8?B?RThwV1BWUGpQcFhydUNGcXVtM2J3OEV2ei84eFM4YTZEeEFwOEJKTmhLM1JC?=
 =?utf-8?B?UVdtckVVM1hjZEc0QXlpYnhvQTJhdUs2Wk5nZzFMUzNMK3FwQ1FmVFMrVzEy?=
 =?utf-8?B?WjgxbU00NDc4WjFLNEh2RE1TNGVXY0dwdDV2VXdteWx6UTFBQ1NmQ2NXZDR4?=
 =?utf-8?B?NEh3MllUeUVuQ2VidVN4bklEU0srY0RpN1ZWUnhnYSs2NDZEVmJlVGZvV1g1?=
 =?utf-8?B?dlBtREY5cFgyb3YyU3ExNVhXdXpUNmYwYURKbVgyOW82bHkvVE9vZXM3VDBv?=
 =?utf-8?B?MEVkRE5OdjFiSTJ5TjY1MWFSbE9yYmZyeTl6TERJWjlaVWpYY21XbjI3ZmN3?=
 =?utf-8?Q?rMobAPZn53X3vH/LjqkmnGwA1IsACIqYUffgu64?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdc1fac7-0862-433d-4a3e-08d8ed5a0092
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 17:43:28.7620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UZ9oO8FlPXbmIdESlY0grCr9XaGyeepVdBNTrhPI0uU27UFkMekNOmogFgrVlJ0/fRyROjt1lonvqe5hswdg4nVrTI+Ts6hqyMjL7S7JMdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4767
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220128
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220128
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/22/21 3:05 AM, Dmitry Bogdanov wrote:
>  
> +static int lio_target_tiqn_enabletpg(struct se_portal_group *se_tpg,
> +					 bool enable)
> +{
This driver uses 2 or 3 coding styles for this, but the above is a new one.
Could you tab over then use spaces to line with with "(" so we limit the
styles?

