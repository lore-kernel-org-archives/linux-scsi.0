Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80845C0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 15:50:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbjGMPus (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 11:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235051AbjGMPuq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 11:50:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D422D26B2;
        Thu, 13 Jul 2023 08:50:45 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DEJ1Q3020129;
        Thu, 13 Jul 2023 15:50:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=xoeiCFtsQ4WSk2rPmCBBFv5vslS4+1nbeWLKhu3ISNQ=;
 b=lfb0VWIW1u3UOsoN5PVCJvTwuV/Izl5ny4OZ6XluFTZgaGEdNIFEaFaAHvNyH6Fpd660
 7t8wzdc84xbXv8C8jEJOthJ7UcmQiLD11kn3fQx/35OK8kTlPBxuLPpgAwZxOfLmFfIR
 GX+3VV37sbNLB7V9Y1OnZFkAwurg9WRFldEJi8nHhYKq8eoQKKEIYXZkSAazZmieYumZ
 w96ImkOu7oKb31m3Y8eG1M7SK9THJ20ycFYWfEe4UA5DhFCKofMrmX73bruFHKmbOIEa
 HWsvBaOGWpiJ5JTrBWeh4SgAvbd3LWk3CuxxWlyyTF65iEzU5N27p7+73ynpail0Dmij qg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpydu1utm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 15:50:44 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36DEskeB026899;
        Thu, 13 Jul 2023 15:50:43 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx88jbst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 15:50:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/AoQZVE0DylaCMOFz+aRAnQ3VNVAKCANY/QCdtW0y93GCClA3LP/1b/J7Pu91mopOx6MsQ5bWK6CfsCf1ma8vP40Jp2fV3Cvo3xqdeOtng/Er+2CCkdpHR8/OtODFsOmqoMoZjQaSsktnUmUg47q48dKvULo2gHaa8KTsF7GLfBNYkHIMX7xa3hGi0jsVFPkB52LB41HMDceX/Sv3Zc5Dq0xjK8Kju6Mo910gt7AgytHHqMHT5Xq1oltAwMfNDQDdJfDOrjRJZUwPe35qiniS+166Y1TZpKHYTa8y0hIp7Cj261WA0EkLx+oMDfurBTfiLFH9kCjSc3v7TU+rGcBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xoeiCFtsQ4WSk2rPmCBBFv5vslS4+1nbeWLKhu3ISNQ=;
 b=Hkx2PjSq2fRnhbxYo+LhIj7neQvvdp8Wsae6ZxPPRbqRtJ7rPMHHvT5S9ogJlWTWj+3IH560viYiU902M5itNB7Tw+YitjA+HHcoIj2uuqYTVcZaYIrc/uX152o30gpjr8jJ5zhCA/V/MEnIWe1pGJwbqv8go89ppnfrKv7RodOnKVphrdV5i6Bl5C0rod+V4f+FARO5dJv2fu49v+FZJNYgq/0JAFWRlZxszGrWJbxjdsk0rVDbjK3raZ7c/IDLgfdVMTCk/8xl6sZH53TVj8ddNGzuwAFJrH3T6wEkPn9nJ5GHTpYRifqI2LmFh+Qs+fpdNEMbT5b6nPmkzy2JjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xoeiCFtsQ4WSk2rPmCBBFv5vslS4+1nbeWLKhu3ISNQ=;
 b=POT+J94fHJe5tM1LJzvQJqdPT1cRmCHDpYpQQvt4p4YM40gcLHbBCBR1S+ZvX+vIAMZD3AAT+K3Y+9smJ0j9TydSHGLzzNBb4th/2TM2FjoysNFNmc+pD0J+fRHS0az5oLoxK7lOMwv4JN6d1dDMioXrGGRYaxkj54yXlf6y0zA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA1PR10MB5995.namprd10.prod.outlook.com (2603:10b6:208:3ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.22; Thu, 13 Jul
 2023 15:50:41 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 15:50:41 +0000
Message-ID: <0f30e660-1b2d-40ba-fcef-48cb209d65e3@oracle.com>
Date:   Thu, 13 Jul 2023 10:50:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5/5] scsi: target: Export fabric driver direct submit
 settings
Content-Language: en-US
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20230710214442.6718-1-michael.christie@oracle.com>
 <20230710214442.6718-6-michael.christie@oracle.com>
 <ZK_25KIJw-CudIXw@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <ZK_25KIJw-CudIXw@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR07CA0112.namprd07.prod.outlook.com
 (2603:10b6:4:ae::41) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA1PR10MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d2d0447-3313-4fcb-a671-08db83b8e8f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KNojOeLLBh4qKHk2pJCXzb2BrwPiahuTFzFhNHJ1yrY2ej8REQRBcBSZ+EuSwZU/IFivsOKHleMXkM+g3xK3seUSlbthDEdcRpjZQdkBp81o2ouGZib/jSD6Chi3v2Y07zb5z2PNG/KfnzlxSmvDjtY+lLjxUTx90R3jqh0SjKpIYT/Gpp4G72YBqZnOplW2e7ulXwYhKNdwkXmyR9ZC1ER6MB2v5YbbSAtLVv12+DnOz8+tbbsC0NVZMQt4Z2lanffOffKS5R9t9ZnDLvrwcSxw7+n0Tl5NuEhs3BzA+stxwTPWekEqkjgF8oUxLyhnB+F8KmI3AlBeDRGlEeCrtsMw1d7YkFr3Bx76SGpbdQTzeJEQXjA30B80v4xEFjajkuIugVC7zjZN+qa9I6Rk24EsOn4fE6LFPKXxV7JV3qEE4UyoWB5Yr6SDoHPBO/Njvn2by2zsBTo1v3hw72T0a/J77sKZ5DZ6MBMwoR2Nw6GEh19F+cQP1FxMdPhFr9fk9/7BxctrZqpBvFN39Jmc+KK5U7fPBPj1IjdRcX/vFcUlGcRK4BF9koYyig/C+vOa8ycjfpwxOd+b01p5Ujz50ZsholT7w1eRWPdv4J57V3CMe7BmGx/F1Ww54lgGENdyqG/f2+M9YtGYWjoQQO2vEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(376002)(346002)(39860400002)(396003)(451199021)(478600001)(6486002)(6506007)(186003)(26005)(53546011)(6512007)(2906002)(41300700001)(66946007)(66476007)(6916009)(8936002)(316002)(5660300002)(4326008)(66556008)(38100700002)(8676002)(4744005)(31696002)(86362001)(36756003)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3p6RWpEYXd1bXNxUXVNZHQwb0JsWE1LV3hoK3ZrTnpYV2FvUDRWcnhXNzBW?=
 =?utf-8?B?UlZsLy92S1lPTzdOb1h2U3BjM2VPZ1lPQnRiZ1ZQcmRGeHBTMnFXaHBjMzlx?=
 =?utf-8?B?blRzRUNIRTYwUFFzZ2lRTEFDZzlrLzJhbGdQNjRibW5rRVJTZE5aWXNTRkRD?=
 =?utf-8?B?M1FhcWNTMlBNQmwvYkwzL3RacmlBMWhaY3FjNkZ0QlR4VHljWDNvRmlnTG1M?=
 =?utf-8?B?QjRYZUduSnZuVkxHeC9DbFhMSzdsYmNlczhQSTJiVEd0WG92MzIyZDZGZy9F?=
 =?utf-8?B?QjRzam5YWkVtQmRoT1pYNmU5QmpJY2JRUGxCOVRLU3NzTmpoLytRcmM3T2FM?=
 =?utf-8?B?blByYS9uTXpOdkxZbGpSdEpHcUFObTBidkJNclZVNkJaVXpaV2xQUUw5RXRn?=
 =?utf-8?B?TktZaFJHaWpDankvNWxPN0VQcU1Fdi84dVplY3BmUGIvM3ZJRGw3VU1oSnlX?=
 =?utf-8?B?a1RWekVDRkhRakV2ay9TUkZKbXBGYktNMnBIbHhwK203NytYM3p4VGFzRnZZ?=
 =?utf-8?B?V1hWa3VKSTRrV2lCUjM2MmJnNjVaYXJNdHlhYlVWc2dPNENDMGN6RTIxbWVB?=
 =?utf-8?B?bGkwVi9sZWMxQTBvaGJpVmZGYURZdDVIbDZYdDdwWW9vSDE1Y2ZJcjY3OEhx?=
 =?utf-8?B?SjVFMytwWUVvVFpXSTNPWFQ1aUxXM1JhWnU3SEROc1hobkkvQUh4MjZFcGNT?=
 =?utf-8?B?bUxlOC9Wd1JXRXEzZG5makxTb3FJWkJLcDdlWWQxOEdYa0cva3AwT2crMzFD?=
 =?utf-8?B?S1grR1p2YjRzNnpwM2wzQVNqQzFaaEFhZnhmaFRhcHFjYzZjQmNPVWcwTmZs?=
 =?utf-8?B?bzBIbXBjZzRlaDlna0x0OWRTay9KWmMzWjVGMUlVckNJTjVJb2RtZDg5akdn?=
 =?utf-8?B?NDFKdXIySkJhL0swT2xSTllBaUZsdlU4NHlZSTNLMmllS1Z5RHBOaFo5V2VN?=
 =?utf-8?B?dDFFcFhKTjVxZzVkVDlUQWNueDU0QTZLbGgwdmt3enY2K2VFUEJ2ajhVWUNK?=
 =?utf-8?B?bUFscWgreHZOV3pGSXdrZXFYTmpzMC9iTnBudHJWREtLMksxVFllcnQ5WVBV?=
 =?utf-8?B?WmZSN2hBeCtmc0dFdEdiaG8yWk5WUGJiZDNqbmlSQThZNzhqOWpsWHBBaWFD?=
 =?utf-8?B?TTJwbkltSXBSRWowc2pDT3RSNG94d0hkU3RWNTYwSjM3c2RRelJTdldVUnlU?=
 =?utf-8?B?OFZ0ZERIMjhmVFVseVp5OC9ETk96MkI0UzVGUEM0M3JURFhGQ1FDeEFDWFJy?=
 =?utf-8?B?V09mY2lMR2M5b1JUeUJicENLbWJvbHUxQmVzbzM4RFVPeUhiN3pCM0EwTTFm?=
 =?utf-8?B?OHJPcjFLQmZPTWExZldINFRPbmFzdjdHWHhqZUFTUGNPU3RzSlYzT0VpaERl?=
 =?utf-8?B?SnR1b0tidFY3bFhTd1N1b2JsbkcrTDNrRVNUQmNRYTYzV2xlUUl2VGF0Q3Y4?=
 =?utf-8?B?WnJtRGVuTXl6QXBjZU91YWlseDlqTU01UUI3QnRJQmlzQWtSaGFLOWY5NEZP?=
 =?utf-8?B?dXp1SUp2KzNhd0ZNYkhVQlZ1cmE3WHZjZ2F6ZkxUVXhONmYrdzZsQjh4aUE0?=
 =?utf-8?B?aUs4MGU2SVJRbHliQzJGV2ZkeHVkMStpTnhrU0NmbkNHdnV2U2dtbWlESHBs?=
 =?utf-8?B?d2JKdzgyU0cySk81QnBFQWtQM0k5bERURzRURXBBdmhoR3p3cTlsSDJWTHlD?=
 =?utf-8?B?MHpNMkVGNHU3REU3UlVDMVNHdEdGR3M3NkgzUHV0UE9oWWpKak5zalFmeVRr?=
 =?utf-8?B?YUh5OHJSWnNaNllEd0VpSmdRL2pWNmNvZkROM0JZMm5KMVpUZjBWQVkyK1VO?=
 =?utf-8?B?cCtvaTBUb21kZHBUTXNxVVhWS1lXRktYZHF0SU0rNWdOdG5YdEs1elpUR1RT?=
 =?utf-8?B?aVNyQkpZVWNMaFVvMTltVm04dGRpM2R2a3I3QnJ6QzU0OXgvS0ZQRS83Mk96?=
 =?utf-8?B?Z1h4TWVLUkF4aXU3R0NpQlowaWZLOGw2WFFZMXJodXpsUnZOenhTcW44djJq?=
 =?utf-8?B?S3JMcCs3RWNsUTk5TWNzaDV4ZWJOanNWbHNRc2krMjczaTJmeXl5RHgrc1FT?=
 =?utf-8?B?c2pROTF0VVNuaTBla2o3UlFrOUJjQWE1bHl0cmJzQWlMYkRDRGVOTkdZZlNB?=
 =?utf-8?B?Y0VPSEQ0SzBUZnk4MEdnZmx0bGJXM1RTNUNkTmtrb0ZjeTBXM3RXWVhlTzk0?=
 =?utf-8?B?QkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 2XEcUVsw6Jm6MiiVJXIRzjtTYNA/myxQLQucGxcaA+37I4/SXovDYXcy4cAiVVLN025/W3qy/1L/PEU8kvLjrZj9hxmCVKRwZfJYxACijcIEVw4RQggrECu1R6mTd7Z8uX8dmi+0TuejZFTvEFVtjPGZkhCHOpL9rJTJLRZkRSmLd1JMg/XZV7H5Rd997XSGl1shXEvyupEoTYfIu52XDXynVcrK1D6vFuO1FIQMBWW8aFlo2z9Wty9J4lIiLwPhxgGE2tJbaEU5wPtLWxIPOYV4RpgLDr/KGV7yIykJuzVVuovcvOBseDN7J8ooMjQnny+lWUfnZsXrWri3Aj1XVFKPuutyz0p9alU8guiZG2zS+NCnQo65/oSnLyWNwZMkd8V8Xtpxdnt/+TF6AA/8hDUIzCPrKmSldvtFpYtJY2cDwCKIE9J0WQzlP7jEXMGqL5jspKjJiRZ1JiHs3iEYCaDEbLoZ6Ib0O8pEmUrbVkguRvs8+naD3U6kUKnOhbnUH/iSGNzE48NcGZu1nT5JkNnUPh8Cb9HC/RUMTxyhNweIn3TlI90I3z37ewzhZKrGyyZcUFTYnbRti1zMLHKOUi/iK94dNdQi567b781pOYM83etdLDLmrJqT4j9yVQO5VP9uEXJ5meh13in10MAxmKYWZtfJyLBB+Zh0MqCIbidaFyqUEJTCljLkGj+hF19Fh/z5Nh8qCNB9Dpe+lItu+/x1eFcI3BKbL4eYjsKSw+3oX+AnP9jWXm9/VChiBVFIFQcaZjlTu4WuOnRijhZpFkoH5BOvqauOGRQcP+YZuk0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d2d0447-3313-4fcb-a671-08db83b8e8f6
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2023 15:50:40.9972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5QStv0EMiBlh5rfBI9MIqkPtaLrO/6VvXaCpy7gpck8vSj3+6i+dbqRUORZ4AmuSm7DTcKiKx3fQlpgrn4kOWdwiusgwV5I8jZ0zNm9MhCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_06,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307130140
X-Proofpoint-GUID: UjZRrw4TT8vrII0VTlLZieZas7WasQbM
X-Proofpoint-ORIG-GUID: UjZRrw4TT8vrII0VTlLZieZas7WasQbM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/23 8:06 AM, Konstantin Shelekhin wrote:
> On Mon, Jul 10, 2023 at 04:44:42PM -0500, Mike Christie wrote:
>> +static ssize_t
>> +target_fabric_wwn_default_to_direct_submit_show(struct config_item *item,
>> +                                               char *page)
>> +{
>> +       struct se_wwn *wwn = container_of(to_config_group(item), struct se_wwn,
>> +                                         param_group);
>> +       return sprintf(page, "%u\n", wwn->wwn_tf->tf_ops->default_direct_submit);
> 
> I belive we should do the right thing and use sysfs_emit() here. We
> already have a bunch of issues with bad sprintf() usage and I think it
> would be wise to promote safer interfaces.

You're right. Forgot about that function. Will fix. Thanks.

> 
>> +static ssize_t
>> +target_fabric_wwn_direct_submit_supported_show(struct config_item *item,
>> +                                              char *page)
>> +{
>> +       struct se_wwn *wwn = container_of(to_config_group(item), struct se_wwn,
>> +                                         param_group);
>> +       return sprintf(page, "%u\n", wwn->wwn_tf->tf_ops->direct_submit_supp);
> 
> Same.

