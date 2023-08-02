Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C226EC04A94
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 19:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbjHBTzj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 15:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbjHBTzf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 15:55:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF3C30CF
        for <linux-scsi@vger.kernel.org>; Wed,  2 Aug 2023 12:55:25 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 372HJGgh009407;
        Wed, 2 Aug 2023 19:55:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=fVyin2TlIzqJY3XtsAkwUvngaoYC0wvtN4/Ukqgl40U=;
 b=X19kiwckpcZ4Ic6V+sYTTZWrroDboNwFtqVCbNa7F/UvsGr8eg9+xqM3WGWnNvf8/d6A
 Awg5Ry20lJ/S5I4cMUGG3CBjt3iavpsLFZlTKf73yT/Hl3dTozMBejFzBbz4NajWrbwW
 Cd1tHwtEp/Op0rmj4BeuJ6vf1yh3yk+1G+a5aKi+5qKtCe9W+IQQDBbCkZbmb3/iAFzl
 8snAfZyXwRfna14xyUtp/CZqebL34lu4/c6+GXlZoyYFl9k7oAxo4my7L73XRlNbMic6
 4TSKC9bgkED07GrMwHP/Bx06WNc8MLMg1Je6t1efC4TeJcFlEhpDi4RYGoz0V5Eqtbye Lw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4spc876e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 19:55:02 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 372Id348006655;
        Wed, 2 Aug 2023 19:55:01 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s7ewjk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 19:55:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bGqPDdChX35jzk7Mm9Q1aGteJhxlcCqoZ5B4xa0YbIOwlmeZehP+M0eQLp9pw3Rv/BBw79e/3s74s8hQ6nv0FJYgoK7UOZUfcyWQlyG7PuIqHri65i4cu640wzYw+P9tBzi7z8NCrxVX2XYNfC7DEvfXCrqfUIqPYWpjlfM6MDkLFhs3DOB5iSAHvBF6mJQYBXkCpjldC3GfT3CqPps0XQAUZShqhdsFuCEAhiKonJoixlmp6cHXgrl8WGPee+qPfJvO4TtczisktE5x/Rf7Sgo5XcLj1qhMEJuFccFApw2QYOemxOVraiAvkOtJgRM54Sq9LvgpjmfY36dU2lizdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fVyin2TlIzqJY3XtsAkwUvngaoYC0wvtN4/Ukqgl40U=;
 b=aorJ0KK7/1lSK8/6sP+T43T+1Mk/OS23VoDptYeuF5K9ymd1xMm3hltaMs0LUkinIb73ja73HT0bdH9RDEPUzF3P+xbw5WiOR8xezXVFYFmBjVMclw8J/uhYMYxaJDmFXYV67koX8bycu99PEaiLJtfOYpChTapQWhwkBlttKOn3s3iU9INIIWGD2Vkifnk9r+bxpQ2vEIMyg+hA5mfUmcaY4s2F4/5ihbU0SZ0rJiytyLz+CgwiPgkSXtOhrT2EJhjLlx0f38xI4lP4BjaCBzx9NnIIKx9TU0LWD3AmuXsW4PDJhT+oJ0G/w0DJ+RXJOKGfzNN+2dXrbDP34NJ6BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVyin2TlIzqJY3XtsAkwUvngaoYC0wvtN4/Ukqgl40U=;
 b=a1fw7MKVl143/XDRzader+hApVmCUl27UcG8FPUVf8hVU8PGwHZR/Zr1/SXc93KwvgF89Wbf0o43NwKKVNeimJKpDhEqCHGBXgrGEwGU/rukTabjZOIPY2Euu6zHIvQf8e75b4p0NJNe6rUuzv7eTtrbO+2gBD8mhjLyWwVyNNw=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DS7PR10MB7131.namprd10.prod.outlook.com (2603:10b6:8:e4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Wed, 2 Aug
 2023 19:54:58 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f%7]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 19:54:58 +0000
Message-ID: <b1de5680-5eca-5619-e690-b1c3136db2c1@oracle.com>
Date:   Wed, 2 Aug 2023 12:54:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 07/10] qla2xxx: Observed call trace in smp_processor_id()
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
References: <20230801114057.27039-1-njavali@marvell.com>
 <20230801114057.27039-8-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20230801114057.27039-8-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0052.namprd11.prod.outlook.com
 (2603:10b6:a03:80::29) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2943:EE_|DS7PR10MB7131:EE_
X-MS-Office365-Filtering-Correlation-Id: 8669207e-078e-4edc-0131-08db939259f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tX2P0yRs8wn3P8frjrhsfrw22nvqGGnoIEYi85Pi0LHocq4XW4xBv+KGfCE67mYuF7f0UeXzfxTmqfkgtVOkhJLxIvNorlG1raS+Zb4RIgMlCzmygp7uFLxEiDRBY0hbhm+T/dQ1+eRL4Hd8ZrDzsxM03RvA1AZS7iuxJomLU5A6yfWBSKTYetpIzrRRcKLTopJtdQliS5hKSimagCLfmvCpj0V9dPRDYelc07vmXpuP08lxzWlPs4ujInQWH6DKurnV/NNnvM806XysfXt4uf/YtaY2KbCkKr9sprJQeJ4BZE1dbDRgEmDZFWZkLgXgKD94nI+UU3gl4HnEPKCZJKlDDBUVaHW6hSrjWFNh90MMy0593uKK/wLtPOjl7DUgOz3ZAasWwrSc2SkZOutKQWE6U2ZNQXmBXR/FhX2LHgN8v87axFqq8hF3UALEGGZUD3G1Gq432zY5ly3sMIxii2nDCTAM4PIJ8oRnoJQqazS9iWT6dnLo1qqgIR20Lv8zWByBksTL739xumwrqv39Xj4oSZIGTyEH/jGm/c4mXwPwu0w3xQ64zUIXVX456qgH8gcaFFj4ix12im1zFZPt5IGSdyt1wypXM/4Xwqe7qHP7WcJGCGXkJ+EJub5HnxZDuEIz8ZaH/yb9kEv/ri2Zqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(136003)(366004)(39860400002)(346002)(451199021)(8676002)(8936002)(31686004)(41300700001)(5660300002)(2906002)(44832011)(83380400001)(2616005)(186003)(86362001)(478600001)(66946007)(316002)(53546011)(6506007)(36916002)(38100700002)(66476007)(66556008)(31696002)(6486002)(4326008)(6636002)(6512007)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3BhS01WUlRYY1YyaEErRExEQTc1YWlpdTZiNDJPOUNzZ3V0aWNCcGJhNFdr?=
 =?utf-8?B?c0ZDK2srQlFPY2duQlFSQUZOR1g3bmJoNEpSR1NJYjg2QUNhSjNwcFhRc0Rr?=
 =?utf-8?B?WmczT3dZTGdsc3kxRSt2TVZHRkRFcVhyWFhlSGsvSWFRc25kTFhYeU9hT0Jw?=
 =?utf-8?B?UHF2ejhTeDkxSDZVMDR3S0paRWFlU0xmL0R5eGU4aUlUTHdhRHQ3MUVUbkJy?=
 =?utf-8?B?SkV6Qm1GbjlOS1VCVDZlUzNpK1BUVzFNanNVNklIUG5OU2FLZFhXWVBSOTFV?=
 =?utf-8?B?cDhTVTdJdktqbXNpUlJIbHJDNUY0djA2ZzdNeHlqaU04dVl0MEtrb2d5KzJM?=
 =?utf-8?B?amJYbVZvNHhOSVdlUXljcU5OaEsrdExHOU9WQzJnQWlqQVV5T1I0YVR4RzZ5?=
 =?utf-8?B?d0JpQmlwL3REdlpJemNaaWJVVHArb3ZhYXl6YmRHdW1TVmxoVkVJRG5ZVUJZ?=
 =?utf-8?B?ZUNKdzNJa1J5UG9obnVlSUR3bmpCVUFJY0JxOEw0YkNtY21scGltY3BWKzZu?=
 =?utf-8?B?MmhzLzBudWNFWDEvdnJwZHVmTitObHFnd1VBd2xPd01PODllKzVnNWhJRVMv?=
 =?utf-8?B?Njlqa0hIRWpIUko4WTM5RE1KTi9MS1cvMTZMTWxDSzAzaHJScFFxTEVQenA2?=
 =?utf-8?B?N3FVTndsR01HUUh3TWlHdnZKSzNBbmpqQWw2V1RYNEo5ZEd6QmNLR1lJdmZ0?=
 =?utf-8?B?bEhOTkJCWWcwczZhbWUwdlFEM2JwSTRZTnpjY0thOCtpTWpnUE5GQ3RqL3ZN?=
 =?utf-8?B?OFkrajB5aVpFV3k3UGdScGJuR2JrWmVOdW01N3QzdE1iWnphcTd5dGNLcHRY?=
 =?utf-8?B?NG43czlXeVNGdnltdEZUSXFyeVJxZ2FBVDR2R011SGZJYXNtVFRYTjZhelpj?=
 =?utf-8?B?MWJnTkxDYll1b1NCbWwzN3VGM0QzcjczbWR5U2RMMjVZQ3MyZ1AwWGZWT2xi?=
 =?utf-8?B?b21XaXBtVTFwNThMbW15QW9FK2Z6QXhBbDNiZys5U3N1bmFUeUQ3a2RlMGRX?=
 =?utf-8?B?NEU2bnlvbTVhWHNCclppL3hEUDJXVWtPaUpaZEVyb1dCTHdPUE4rRHlxUDlh?=
 =?utf-8?B?YnA2ZjQ2Y3Bhejc0RjNVYjlUL2xJUlRGSDJwSGV3LzRMLzhaNVBpMXkxa2Vp?=
 =?utf-8?B?VEg5b3ZkMktROGtFSlQ2bW5vd1hWdHp3d1d5bDM1Z0t2RENzQU9nQ3VBQ3Bw?=
 =?utf-8?B?a2g2TmwzZDVRdWJvekpkQm5vbk50SGhpWHNTWTRGdFdmOG1WU0N3UWFIOGha?=
 =?utf-8?B?bjJHc1RNWnNnY1lxMURnZjdHZURsbTFKblJNUzVmOUJuTXNOMVVJZHlJUHVy?=
 =?utf-8?B?NUZKOTZ3bVJIbkhSZFVGbVNxaTkvdERHbUJJeHEwODVvTk9ISUQ1M2xidkpE?=
 =?utf-8?B?ZSs4bmFpZ1oyeW5oOWdzMysrM0lGQ29oMWZGNWtUMmZzVVcrS3lBeGJFMjRU?=
 =?utf-8?B?VitsSmxuSXNlUGt6a3pkT1JITUFsd1pkY3J2YmQ1OTJudFFnTDRqeXZSN1Mx?=
 =?utf-8?B?WDBOYnViN213V0RheDJJTUtTbDFFTnJxU0JacklZc2g3ZVJ0SnRacVpwQWdD?=
 =?utf-8?B?MkN4T1Arb250WUdjR3pmaUlsZzZQTlRuZmJ0R1JzdXltRFhJUWk5YjMvNXhv?=
 =?utf-8?B?VGZ1aG5NeE9GMmp0OXd4a3dHUzV5S3doM2pxakdpUFI4ejl2K1RpTDZUVUhw?=
 =?utf-8?B?cDVES21wazd6cWZwMk03a1dISzNocE92Sjk0b21IaVRQSllYYTdNZVFzNlJK?=
 =?utf-8?B?T051Tytjd2c2UjJUTmh5Y2dMZkpnSUJmYitsd3IvV0h2dkYvMnlpTXlBM3k1?=
 =?utf-8?B?UlhMbW93TjFjQzlFcUZWL2Ezc1FJWWVmNUgrODlaSnhBTTBNellWREhCWEt6?=
 =?utf-8?B?N25JSENHY3IrZ3dmU3NZTjd5L0laaVJ2SVhMYUtyeU9hYTlia2kwdHNLNEdD?=
 =?utf-8?B?V0NXYWRPbWJsZTMrR0ZrRVBKMWkxWUxDcWNSMmppeVNmRHlMZWd0d2NYbDNU?=
 =?utf-8?B?enpscFlDN3d5Uk1kRXhSdDU5STIwaVZZK0JvY3hibXF3QnpHZDNEK1FmSlBY?=
 =?utf-8?B?NUhhL1FKZXk5eDJJZER0cnQ5WmJVengzU3RCelQ3Smt6RUR4dURvTEhpd0hl?=
 =?utf-8?B?OUpnclJ3cmprM3pxNlZ4cEpMWFV1eldLMXNYZHhrQzVjVDViN1V5bk43Nm9j?=
 =?utf-8?Q?17T1a+ABvfy2R7uWoK/AehY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bbZxQE79scmPM6kC5iFidL92TmsSWMv5nx70tJs2XRXcGH0WF18jPjAt7S6nJaEev4V6mhcobWzGxfuYzfN6fFiIS/cr61YSKZ+0rjgxYYcOrpxt8BE046jKIT5J1lcRx2TF9wzF/gdfjAzK8OJWcRLTuUMHucUdNy5ZFsJ8mgMC1Gy8TLYxqVAUmWYMapVzCgXcii2B/vJZKYyHMw0Ua1DL3Fuakos2dZZt5gjaU1WJCicjFSgjAzMIrPz1W65JyGKMY6k/Y6zad8bIqnBhhc36A2gEybmQjjDPXdd9pftl/8PRsc0cabgps90fL1AvL/tULOAhSI1WG0F0ngVK+9iHw/Mzi1eve9lWtYpW0pti2BXnGfnT8ZtZbV5ctK7TrLBehg3/m3C4NI5SfhJ2m+3kOEo1Rj/Sm0vN5odNWlMnMgFF6ubkav5v0MlxEcc7hWIaBlKER+XYPUEwVvuMlgmgPHPniR06Oooqiw14sdOqJ43ceG0rnlxTbjc2cXMvy7OoH6o2bcDE8G7eE/8Ds/PjxQdrVT1bLt2D5we3FHoy16l3Kz75lCwBn+KjBdZAz63VCLx3M2TVWMbaZjpkfUGwY3y0lejAwBWcP+3FSTdi1g+xSAok06E+kakjfSVbuPthQG9z1xd6jCyDkl7/jAbBpC0cyqNtN9WSrUmyR8Y+UMHU6Mw8fW02ZWe41oyh4NH35TVmpipKsnDNKsKQKzkxcufLWo0BYWUUcXlcW1TzIoxapErhHmDe2xhppUWz32WwZvXdyDNQ1rHtzdbzLU4XulkOTz6H0wJ5lrpeFFo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8669207e-078e-4edc-0131-08db939259f0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 19:54:58.8211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wr8c+NkAb8xJ43sbE5wTBf/BGHDNl2U7cWBJk9SRLPM16+ErqfkKIic4JIwx96OqbuAdP2byXy9TRgX9O4wU+hl359N9eVec2v2wHpB2Zzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7131
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-02_17,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308020175
X-Proofpoint-ORIG-GUID: It674r7f5Z624go--nwiGUAskXd-EacG
X-Proofpoint-GUID: It674r7f5Z624go--nwiGUAskXd-EacG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/23 04:40, Nilesh Javali wrote:
> From: Bikash Hazarika <bhazarika@marvell.com>
> 
> Following Call Trace was observed,
> 
> localhost kernel: nvme nvme0: NVME-FC{0}: controller connect complete
> localhost kernel: BUG: using smp_processor_id() in preemptible [00000000] code: kworker/u129:4/75092
> localhost kernel: nvme nvme0: NVME-FC{0}: new ctrl: NQN "nqn.1992-08.com.netapp:sn.b42d198afb4d11ecad6d00a098d6abfa:subsystem.PR_Channel2022_RH84_subsystem_291"
> localhost kernel: caller is qla_nvme_post_cmd+0x216/0x1380 [qla2xxx]
> localhost kernel: CPU: 6 PID: 75092 Comm: kworker/u129:4 Kdump: loaded Tainted: G    B   W  OE    --------- ---  5.14.0-70.22.1.el9_0.x86_64+debug #1
> localhost kernel: Hardware name: HPE ProLiant XL420 Gen10/ProLiant XL420 Gen10, BIOS U39 01/13/2022
> localhost kernel: Workqueue: nvme-wq nvme_async_event_work [nvme_core]
> localhost kernel: Call Trace:
> localhost kernel: dump_stack_lvl+0x57/0x7d
> localhost kernel: check_preemption_disabled+0xc8/0xd0
> localhost kernel: qla_nvme_post_cmd+0x216/0x1380 [qla2xxx]
> 
> Use raw_smp_processor_id api instead of smp_processor_id
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_inline.h  | 2 +-
>   drivers/scsi/qla2xxx/qla_isr.c     | 6 +++---
>   drivers/scsi/qla2xxx/qla_target.c  | 2 +-
>   drivers/scsi/qla2xxx/tcm_qla2xxx.c | 4 ++--
>   4 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
> index 0556969f6dc1..a4a56ab0ba74 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
> @@ -577,7 +577,7 @@ fcport_is_bigger(fc_port_t *fcport)
>   static inline struct qla_qpair *
>   qla_mapq_nvme_select_qpair(struct qla_hw_data *ha, struct qla_qpair *qpair)
>   {
> -	int cpuid = smp_processor_id();
> +	int cpuid = raw_smp_processor_id();
>   
>   	if (qpair->cpuid != cpuid &&
>   	    ha->qp_cpu_map[cpuid]) {
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index e98788191897..01fc300d640f 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3965,7 +3965,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
>   	if (!ha->flags.fw_started)
>   		return;
>   
> -	if (rsp->qpair->cpuid != smp_processor_id() || !rsp->qpair->rcv_intr) {
> +	if (rsp->qpair->cpuid != raw_smp_processor_id() || !rsp->qpair->rcv_intr) {
>   		rsp->qpair->rcv_intr = 1;
>   
>   		if (!rsp->qpair->cpu_mapped)
> @@ -4468,7 +4468,7 @@ qla2xxx_msix_rsp_q(int irq, void *dev_id)
>   	}
>   	ha = qpair->hw;
>   
> -	queue_work_on(smp_processor_id(), ha->wq, &qpair->q_work);
> +	queue_work_on(raw_smp_processor_id(), ha->wq, &qpair->q_work);
>   
>   	return IRQ_HANDLED;
>   }
> @@ -4494,7 +4494,7 @@ qla2xxx_msix_rsp_q_hs(int irq, void *dev_id)
>   	wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_INT);
>   	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>   
> -	queue_work_on(smp_processor_id(), ha->wq, &qpair->q_work);
> +	queue_work_on(raw_smp_processor_id(), ha->wq, &qpair->q_work);
>   
>   	return IRQ_HANDLED;
>   }
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 2b815a9928ea..9278713c3021 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -4425,7 +4425,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
>   		queue_work_on(cmd->se_cmd.cpuid, qla_tgt_wq, &cmd->work);
>   	} else if (ha->msix_count) {
>   		if (cmd->atio.u.isp24.fcp_cmnd.rddata)
> -			queue_work_on(smp_processor_id(), qla_tgt_wq,
> +			queue_work_on(raw_smp_processor_id(), qla_tgt_wq,
>   			    &cmd->work);
>   		else
>   			queue_work_on(cmd->se_cmd.cpuid, qla_tgt_wq,
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 3b5ba4b47b3b..9566f0384353 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -310,7 +310,7 @@ static void tcm_qla2xxx_free_cmd(struct qla_tgt_cmd *cmd)
>   	cmd->trc_flags |= TRC_CMD_DONE;
>   
>   	INIT_WORK(&cmd->work, tcm_qla2xxx_complete_free);
> -	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
> +	queue_work_on(raw_smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
>   }
>   
>   /*
> @@ -547,7 +547,7 @@ static void tcm_qla2xxx_handle_data(struct qla_tgt_cmd *cmd)
>   	cmd->trc_flags |= TRC_DATA_IN;
>   	cmd->cmd_in_wq = 1;
>   	INIT_WORK(&cmd->work, tcm_qla2xxx_handle_data_work);
> -	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
> +	queue_work_on(raw_smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
>   }
>   
>   static int tcm_qla2xxx_chk_dif_tags(uint32_t tag)

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

