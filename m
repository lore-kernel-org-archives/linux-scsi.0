Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 068AFC433FC
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE40261990
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhC3Dz7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:55:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43658 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbhC3Dzh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3ilYO110498;
        Tue, 30 Mar 2021 03:55:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=kNLqrT8xiISUO9jmIPf1KVGPsQFwNSeHFLxpVd3FTXA=;
 b=HEp6VMcM2BcznLCwCJynodgjL5ZIRn61NFBtU46hPhk7MKAvuh1ZLX1/rMAHilhD44bT
 Er1pRkQgUTFJk8vEuofv+V8EkxHczUbXA6AlywpP0WQILh/w4mWjvdfYzEBBSbAHAx3Z
 ApcF/ZIki3E4Bsg7Q6MTCtpGnN5I4xszlGt71unYi8l5qcaMD0pGTUOGKZd8BcrwgpFg
 1XNDRw0ZzIPCuKKjPNUbzhqb4G6grKM5LUr+qqhE4MkGAhSIILGeb3DLRncNOVMmvAjJ
 spV8uocdltKSnRtYFUcz5w2/sJNehGaXEl+R5ej5+Za6sPRNeD3jJaI0AN1MS9EzaRiL yg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37hvnm5kbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3iXDi039498;
        Tue, 30 Mar 2021 03:55:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3020.oracle.com with ESMTP id 37jefrktqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+IVr1wI8Y/iVOREJHhg7tnDxxtReo9CQvo5r5sRFTyc9eDhpNfclCaU6KrXqVsiu8e9rwiOd+/CNTzeIrLOdTkAXuubST27Dkg60pMZgmJU1Pt2Gy2TpDfBWSjunDo6d8mvDqnVZSntLOX24kURMrq2KX7JRLglknaBkA6/Nb6iHZBaSl+JOiw868lr/Nf+UpkX0xfwuPuq2dk1+/yaaS/8yKny70vs0PXAxgfMCCSdD1OnRrL1nGA8qZIpS+iM60C7giTP1Xizt0+Xq1RR5OSC94hjRs5XTWI8tFWDAhpbVTd85V6l2/2ck1usC3uBRABmi9XpkuR83vERI8RljQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kNLqrT8xiISUO9jmIPf1KVGPsQFwNSeHFLxpVd3FTXA=;
 b=giSyDbAYb4RF1mr4imtTDe3hy2cXGZZBOAyuOXz2gniCY7bulg+VDMUsPUJc3AJ+G23u7PVCv22zbULcCLfKcefOue07c2lALYaw0zvEV85yqoeV0V4oI/x/EygkcjL5/zY7b6tpXi2Qh+Jk3ItI74EblXpl6RImfzzlH7RXZsKaaUYjJY4UfGH4e0yrRMe+hlk3o/XVX+bPxBjF+blGryjC7aHKIQWHPzdpRgk1AJbnngH20mxeJVbBwhYW/W/9qB9lNgfODlK72I7mctvJg+YAsXkh8RWljbKWbA6dD36WCmLhpJHVZlmvf1n0zB7qhonApmbEYzqldc5wSHUK4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kNLqrT8xiISUO9jmIPf1KVGPsQFwNSeHFLxpVd3FTXA=;
 b=UWZO16zD+2OKfSUeHIQixCAAUkQznwg9dxNv1m6ZZvvcgVcH0fwBBy/Z7HnxrNlkBDZkWiULgekDfQTap4cNk5p9k+rDYYxNRIaZSWx8TtvwoKbeIQbo1ZzDoILMqEeVuKuJymHPQ9lxxLl9gSllp0l/8xX2DKQzkNHVm5D5p90=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4760.namprd10.prod.outlook.com (2603:10b6:510:3b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:55:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:55:24 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        Yue Hu <zbestahu@gmail.com>, kwmad.kim@samsung.com,
        krzk@kernel.org, linux-samsung-soc@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        zhangwen@yulong.com, huyue2@yulong.com, linux-scsi@vger.kernel.org,
        zbestahu@163.com
Subject: Re: [PATCH] scsi: ufs: ufs-exynos: Remove pwr_max from parameters list of exynos_ufs_post_pwr_mode()
Date:   Mon, 29 Mar 2021 23:54:51 -0400
Message-Id: <161707636879.29267.4234728175019289817.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210311042833.1381-1-zbestahu@gmail.com>
References: <20210311042833.1381-1-zbestahu@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:55:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5ca1351-c0de-4b20-e140-08d8f32fa582
X-MS-TrafficTypeDiagnostic: PH0PR10MB4760:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4760501335A67E74A93E9B828E7D9@PH0PR10MB4760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xtYjB0KbrT9hwkHkoVTAworZyaVp5+GXPf8CKxm3ynpLAo4Naji9pwKSgzQN4begWTPYy+fMlk9aI9LnyJ+AUjGLtYQsDo45a2yMTp5xa6fD2CH6z2umDQaOaV/RqP9xPQ9+3TdwC46IvBq6tB4VwTb4GK/nZ8C0iy1d73rsJ/Ij+NNUlGZAi49ZAGVWWLcM0DXhdEeWntM+FkVmueMvUrJ2YLTbJ6GbmxGIDMLx97vLMyd2mhJjMK9RC+NIsU9ai2jyKZz0Xv8un1znTKskitXBJCrzYrsNDjw3Ro2Q0m4TIHPf0oQkjI1GeaSyJ0a9jnjGs6fyaiScdvhTfvXRTnBvLI3FlvG+CqhfAr6Ee86l57h1ytSoG5PpP8mryUs+ieq6WS0zNWIKjKV6B+holoH8K2fY9VfJqov8R9GGhAxWnm9hBeBspo8wrtokha+MdplXm1gpPgHj4RtafmzEtdzKhoK0+7FTzB9EJoYRPHWRAtKKD7gf8r4lQQ0KETYZRLBRK7NwHde+COcPgI9qlgartC0aHET1YCgacmGUIIv27/+Ky22Aon2vfqWXHfHNbJ9kUmsYH6CGJGtX/5z1WwcYPfAxGR1plXouP+bEOB1pMh7XQOa5ljRoqgnj9DWbHzYRGpcb4fqAvNyJhJs8ZzQNION2wRyYDFLdvFOfaowbUvIwYRlDtzojGG3Kq54/oW9/6fY2nMy83ZM0pz/HcO1VSTdCruEZlcWTmxr80zo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(346002)(376002)(66476007)(52116002)(86362001)(4744005)(66946007)(66556008)(6486002)(26005)(8676002)(478600001)(7696005)(186003)(36756003)(956004)(316002)(966005)(103116003)(16526019)(2906002)(5660300002)(6666004)(2616005)(7416002)(38100700001)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d2d1NkVuUDQ3djM3dWE3S0FSbTlLOWpPS1poU0RDaUZwVGdFVExoakNhVmJS?=
 =?utf-8?B?ZmlYVVVuOThlc0xROXhzbHVibWpBa1cwU3NNc3dUNFROUnFBWTBkV3Zjb2FU?=
 =?utf-8?B?NGdCeXdQRmRGdVlaSExFRXA3SnhTdThXdnYyY05oaGYyUml6OHNyMU80R2pT?=
 =?utf-8?B?ZzlDa3JXY2pLWjhqMkt2ZTl3WXlyQjVuMExKSGpwMEJFOHlwMXBsSVZsZFVJ?=
 =?utf-8?B?YXRkQ1RPOE9oMFVHSnZMUzR0ZlF5aEM0WDUwbHJQUDlNSHVJWTMzU0FPdXRy?=
 =?utf-8?B?dU1iS3Q2WVJjUkZQL3BrZWh4N3JTZCt1SDhxMERWUFN1cjJnU2RTZjQvTjZ0?=
 =?utf-8?B?TjNZZ3RoOUdYWS9PeVIvbFlPTkNCeTdQZHBHa1l3MmZCYWFWc2krTXV6L2N4?=
 =?utf-8?B?ZmZLaEdwdTg2NWdCU0pVZzdKc1EwNGVFakZqRytnK3NGbitUYjNMaFUvQWY2?=
 =?utf-8?B?Q3VNZ0pEcEx2VTlUaktFa2tFUUMvMEQvUFZRMTBjZmFEdW1FOXp1R1N3L2Ji?=
 =?utf-8?B?THFRUlR4UWxOQzhERWJLcjd3L1lOLzNGRVdqUDRHblljR3dOOHlSWjg0b01H?=
 =?utf-8?B?UnpDOW5VblE0NGQrdzZ1Y0RBOWFCczFkZXBaelRmMURGS2RRNkljMDRWVWEy?=
 =?utf-8?B?Y2RUcmhCc2xiOHZYbEZsbFFvUFpsYnRCY1VETnhOMms1bTUzb3FjYndjMDZp?=
 =?utf-8?B?M0VFZG1zcFF6U0NsNjZacEVCYUpJRVFreTRQYWNTNkIwL0FrZnFUSTdZVkdn?=
 =?utf-8?B?QURIZHhUWXpZdUc3U28rVGZ2RjRjMmtCR09CVzJIWXRkbVd1NnBDNFpxWWJP?=
 =?utf-8?B?K1lsV1lrZUZCVGdHVjN6NVFHcndnOFgyOCtKdFUrU2xCNllqUFBDaytVeGRj?=
 =?utf-8?B?YlhCTWU3Z0Fxamx4Z1UrTklHVXZGUEphZUgzeXQvZTRwYTJWZXFUSHBSZEJW?=
 =?utf-8?B?NjhYK3lrdlRWc0pJR0g0eWsvRExIV0JaM1JjZk1OK05aU0tWK3JON05RSVhT?=
 =?utf-8?B?ZnJRMmVYazVJWUhZNlJ1WFEwUDMzbGUzbTRpNU9sUUt1eGVGc2NwZTYzZGMr?=
 =?utf-8?B?YkdQcUhzR3ZqWW1tZS9TR2hnL0tPakZCazFHK2FsMTNiTGVaaTh0OTFHa2tH?=
 =?utf-8?B?WlhQaURBQkpkakdEcTBUek9XZnpQbzRHU3U3YjB2UlZmWjFMdmFWVUdXYWJt?=
 =?utf-8?B?UWdlQ0Iwb0FpZjdHVk1ScFo4Zk9RZWlobHhoS1BIbUwyM25KZnJoaEhhRkVo?=
 =?utf-8?B?ditrVTRRSkJwU3FsbXR6eG01VEFvbGVpZkZPdUhZMFV5dnpBZTEzK3dTSkR5?=
 =?utf-8?B?Kzh4dFV6dXkxeXJOSUs1ekpFVDFnVWJBZ29qaFRrVXhnbXZRUTZUa2xDWDZY?=
 =?utf-8?B?dGFadEVQSklFNTFacFJHUzRXSWRkdzBJazBUbHBwVXdlYTZUbk1pUlZFcHdX?=
 =?utf-8?B?VHd5RElkbTFyV245dEh5ZkVEbm4vNExRRnJhUzlxOHRpTnB0aEJqVUhwekNL?=
 =?utf-8?B?a2RtK2pIZG9UdXRpV0JSNUFMRDRQL3JsSUZTc2lQMW5UMkZTa0NtdldzVGhw?=
 =?utf-8?B?d1p0VGxKYlJjbUtITTlMNjdFanhPekc2WGppTTMyUm9lTWZVZnJBMlk2VmUv?=
 =?utf-8?B?bFBCWGhWaDBnaHplK2pPWnVjeEo2ZG9Hd3JoRVp6RFJXSVF6YkRuOUM1MWw5?=
 =?utf-8?B?ejN1SnFCYm93QzdicVB5Znh2S2lqM2MwZjNvZzk0bmdBNVIzVnlPcjlDN3My?=
 =?utf-8?Q?c63+kv1tgyCW1KPXXXt6lPTVWSibnHvF+YXatTc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5ca1351-c0de-4b20-e140-08d8f32fa582
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:55:24.1742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Weha1ZC0i/Oh8rGTm+f7jj2pN+khVXxfqFL26n12JP2EH/twt4Gs47/2Gl+G3A+EYczNZ5Im0Tf049wUDITIFzCShyPcQxG5SolMgYHUTE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300023
X-Proofpoint-GUID: b18TTSWxOWmNWaDBn_VJCxN63YYP7MqY
X-Proofpoint-ORIG-GUID: b18TTSWxOWmNWaDBn_VJCxN63YYP7MqY
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 phishscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 11 Mar 2021 12:28:33 +0800, Yue Hu wrote:

> We don't care pwr_max for post change of power mode.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: ufs: ufs-exynos: Remove pwr_max from parameters list of exynos_ufs_post_pwr_mode()
      https://git.kernel.org/mkp/scsi/c/dfd35e1d5934

-- 
Martin K. Petersen	Oracle Linux Engineering
