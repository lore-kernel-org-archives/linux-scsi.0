Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D59C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:25:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E741061584
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhEKD0x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 23:26:53 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36142 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhEKD0w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 23:26:52 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3E0iO179599;
        Tue, 11 May 2021 03:25:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=uH0NWyLxk1m5lFgTTGLHL30zGh3CnTMCpuCwv1EvFz8=;
 b=GyWMfNLDJuXJd0EKyfqX4qTe4SZQxaJxZOPueD01wxA7UXDcLXUzAifMB1sTDm97FPGa
 iE16RJF+zSgfpfQBJbqpyrZ/pcLec1slZf1DoyizoZa18EJZs3WA+c9NUQCCu/LxFSnH
 5JGy3NtFaML0Zk2nRUUv4PHI2oZfgM2jvVkZNXcO/7BQBbkFF6FGxQT0D88QO4sots2e
 W6C8MxQi/BPBeNQVuOMwb0MphJkncHT5JB2RGJjXQVaPMFaKRkEEU8V8Uno8aaJV6GqH
 GAl8h/cjvgiNYcyJnfhpEdakXNUFAQMEpwCRfgujqnlUwP7qaHNOcV7zOuntLlNKPZnY CQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38dg5bdbt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3Gd1M153264;
        Tue, 11 May 2021 03:25:42 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by aserp3020.oracle.com with ESMTP id 38djf87ky6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OrEQHnNKXU7ccXRwghsCdcQW+kOpYAAgPfKWp8W6bU5PWTjvJvKUdMooX86VJfNj/Dw13f6dOMK3xOOlX/7sCgOG4RIxoSyi5XOwIj5q2wUArxDCRBf/4XPqH5opkxnM0u8f3a24DgAOOZTFa4RbPUbZ/z6zsxp4mgCWAoYexfI6BRHViMZTpNj0ss67rBClYX77OzJAjirMkCY+U9SPzMjlbG3ATkAfm1Wdw+tfKGGoy1kqd5xwpVrdRz9PB1LbkLjT7CkBgMpeEKLC7mgvr3KeyAfJcSEX0CMJRZATaJKoBsw5q4BxPAcCxK4LCQZ4MTE3XtqLkhyTBC5+S8DVuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uH0NWyLxk1m5lFgTTGLHL30zGh3CnTMCpuCwv1EvFz8=;
 b=BxdGiTxD+Pvb/Hf7RA/awAMY21r1tniozHn0OBIMFmhMsc4whMYE++lcM7hkD2Y5g+zCchXKAcNl8cz4Ho0bRXJn5FXtk0vA78X9KYLQ6Rzcp93b2BRYPdj+f7AwlIXf1rXUV5Wwa8aOIdpbxIjhvwNV0eR/EeKA8Mm3wuBbUDhmI+UX/WXL0u5tWZmmW3/7z8Z7wFqfyTUDtpSq7Tvru0XdGJYBJcmmR92lXTJW1juRP7pECN9B1PBDZkcz1P2mte5oQZlxJYsSmmx+jLj8DgVVgCxbQLjnQcv0PpuxXOTJjQ1ZyO8d/8lx4mNjc8Q9aIsVJe+UJFmbC64xe4UeHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uH0NWyLxk1m5lFgTTGLHL30zGh3CnTMCpuCwv1EvFz8=;
 b=BY7GGSPmpvx8avaYVkd2V2k5xg4IFvrHeprI+3Ma0nfvv6hPnh0HReIpQfJf4BXGWXpwAVH1PO6WAIbwEWSHEJXia697Iml6Iop9TtAA2HIFHxHneucVo07lwZ4BB+U4n8zr1l9cGi23d8eAAg8Gi8CmFxarkWpH0P+FGcsZSdQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Tue, 11 May
 2021 03:25:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 03:25:41 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Adam Radford <aradford@gmail.com>,
        Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: 3w-9xxx: Move * operator to clean up code style warning
Date:   Mon, 10 May 2021 23:25:25 -0400
Message-Id: <162070348783.27567.14365784965423659300.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210416094713.2033212-1-colin.king@canonical.com>
References: <20210416094713.2033212-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0501CA0144.namprd05.prod.outlook.com
 (2603:10b6:803:2c::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0144.namprd05.prod.outlook.com (2603:10b6:803:2c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.20 via Frontend Transport; Tue, 11 May 2021 03:25:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fac3b8b-bf1c-4205-6f2d-08d9142c7404
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44084D3E96B148E349EF01D28E539@PH0PR10MB4408.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7vsXGfUDY/vjGqDex8UKFHL3Au/YtvBx+Jl+ARtRMUdUrNu9hcqBz8ipZGERuaneoRfkY722nhxbcDroMgtU5Z6tTZGFeQffHEJ9DZUls1y2s6/ENRwfJ6zhSLEQ7lm+t6eL3umT7lKlfOYjDlI865Koh60kqjlp40iS+ywt1B2Qj0O+5t92ht/i34pclmfHhGW5XYo76t2A0Jg5LQcvUm6+pQrQQ3XXSPpisJUvy2ni12U+NCKFczliqUuZVC3d++bTh50J/xF06RJCvZ7vVCwuL35gB4NuAntV7kTZe46qQIJzB8E06md5zH5DUbkRbunyrX7ByFQBfV6pMyckjJXldAfIJU0U5D1Y9LcZAyGH+JhB+GDqx14BTENPB3AlN/BC8SItkyYB0pWVoeX+hxQyyzwK6LTN4tPZflcWLeoya2fsYExcQfLCw2/rVTFnkT/uHfWFazZ9APe5bS7/2UepdheFiMtEvRnc9Jj5cCTuGyGbHy5FfIOS2C7C9ShU4J1Cz/OOf7enth0PCDNdI0cOKoO94VfvJORveYyGsvcjT1GjtZ7Z0LQFBjG9TYvT7mGytv5sPqBahx6lqXSuTW7A21j8Gtq/LH5Y55kMc+HcJ8JJ/QWTHWSJltTKMbLFeiBl/XPJi2BteJSm4s/puzZhkePBNnhBmkZU8q3bQetPvc8hA9UWnJzEia50khQFqjVtgvgufGTZj4oeyq10qfy+SiaSVlGPbV2qA8Dp8QE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(346002)(366004)(39860400002)(66556008)(6486002)(5660300002)(66476007)(16526019)(110136005)(2616005)(38350700002)(38100700002)(6666004)(478600001)(186003)(66946007)(36756003)(2906002)(4744005)(83380400001)(956004)(103116003)(26005)(4326008)(316002)(966005)(8936002)(8676002)(86362001)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RTF4bjR3MXFYUDVhSUVCSi82aFFSWWhjZ1V2RWViWmdDOXRBR1ljQ1dJYTFE?=
 =?utf-8?B?RDJyWDZVelBKVGFWT3dudG9lQ0tDRjd5UzdPeEh5V3ZncjQweURielhTcDRO?=
 =?utf-8?B?bEJDNjRJcTk5TFR6RWM1UTd4aXlIZTZpVmRuTy9BYWNaUSswajFCS1diSVd1?=
 =?utf-8?B?T1ZkdzJRYkFJVmJaVzVYOWNGamFISGpzU3ZmcDFUc1N0ZkFGZXFVZWJtTWRU?=
 =?utf-8?B?bVJyanZMMlp6b213VW9SZjcyZS80aEVLaSthSDhaMUxHaWRtSndKalMyMEgr?=
 =?utf-8?B?VFQ3ZnhBMGF2bFgwWGJmT2FlVFVXQW5aaEl0dDJ6ZWYva3hIUFhLUDJ4MC9u?=
 =?utf-8?B?N0M5WWVmNE5QRC9EZmYzSUFSa2VQNVhKY3RCMGJDT1VNcDY2c2w4emZ2RnFs?=
 =?utf-8?B?UWsxQ1RFa1EvTXpoWU1QUDlTUG1seEEwUWpQT3JYYzNBbFVDeXVRRDhJQ2Vi?=
 =?utf-8?B?WnJtQnlSVVFmT1p4Ly9RV1c0ejRWYkxpVS80WVVaVXFZaHVaQWtnWTMzZ1Rj?=
 =?utf-8?B?SzU1azBwZmhtYk96eFFjM1J6dWlZMnZrRjhlVDVCNG9tOHJKeER2YkY2U0g0?=
 =?utf-8?B?Q3ZuYVlMdFRFTVViY3FkalYrY2s5V3VVV1ltVHVVMXJhckU2eGtBbDBnTElh?=
 =?utf-8?B?WXhZR2dOelVKN3hSWjVNWHpnQ0FXL2ZOQVkvTFlxU3JNL0hHdElmMk9kcDJR?=
 =?utf-8?B?bys1UnBEd3RtWForODM2d0xOWENqNlplQUxDczFSSk5pdG1vQnRGWmp2S2RK?=
 =?utf-8?B?YjRYSHM5ZU5ZM0VvOGtUTUVOMXVNMTRTWmdRRklESk1weDNTaWlQWnh6UzhB?=
 =?utf-8?B?eHpUaDk1VUNHUiswODZmNk05ZUJCOXNhRnNRK2FCOXVXSnN0cTRndTdhQTVJ?=
 =?utf-8?B?SzZuS2kxM0lQOTJBY2ZpNnUwemxOSXJBRHNtU05Ka2RnaENKUkJZK3d6Mng2?=
 =?utf-8?B?V3k5czVxYWZXeFBYa0htd3NKV2FCS0VkZTExUjBSeVZzdFdOMXY0U3JlZ3dt?=
 =?utf-8?B?VERub1FwY2h6eXRVSXdJZmhMa3Z1bElJVU1lTzg1MW1HUEUxbEpwcXdvQWs1?=
 =?utf-8?B?bC94TW9iRUhHZUNQTEhsa3k4eWloK1JXdmNPOUFVOHR4a2wzS1Z3SmdjeERE?=
 =?utf-8?B?akxlNVFPaGNWdzRHUnZQc0V6QzFLMGFUNUZOaHZNRkZVVWZmZlVXU2hDamhJ?=
 =?utf-8?B?QVlPTC9YcGlNdHRjQVhDZld4T1VRWSs1RFc3bnhYQ3lKWjlPM3ZkU3BCREpv?=
 =?utf-8?B?Q1VXRTBhN0dOTGJESHB2MkZBWWRrU2JZdCtRYk5na2hVVHQ1QzRyMy9iQmVs?=
 =?utf-8?B?NTV1MGNCRnovaldjZkZObzdzQXh5a1lUcWt3SFlaWHdCN2I1ZkhOTmIvMGhn?=
 =?utf-8?B?VlF6QkhZemVUV0F3U1hFdnlMQWJJWk10Y29lQUNRTlUxelpzZWVTbzNjV0RU?=
 =?utf-8?B?MktneXN1WDJqUEhERkhLRmRVd1ptZlBMeldiM1pNRDVKdnJPd242aFV4ME1p?=
 =?utf-8?B?SkpUQ0hRNUd3clZWb3pVNEtjNkhYaWdiZU9NYWhBT0RRK2M1MG8yRFJuZUt4?=
 =?utf-8?B?bXk0OTUzTFZFckJuS0NodEJBSlFTOEw0M01ZaXFFTVRFVFducDMxRXR4RXlO?=
 =?utf-8?B?UWZHNnUvenljY0lyMTNRTExQTGkyckdGUElhSW9wWUtWenBHSjNvSnVKbkxG?=
 =?utf-8?B?Q1QydXY2Rmk4NE9QZHZ6Y3kyOUI5UFZ2YnNOaHRsVm43cHlFSnN6OUtVcmw0?=
 =?utf-8?Q?cFQBah9kW/b7v4z+k9Hz8kti4SpqCKrLiSvgoKh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fac3b8b-bf1c-4205-6f2d-08d9142c7404
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 03:25:40.9121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cq7lvVnqGs5zslOqRQ+RDS8ddzL+GCyJXKT9x9OJwTdnfj48EtDjNlD/72JOsHXH0MmRTFyjuAKL+phi+cfIPQ/324vjxot7mk02OV0t/y8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
X-Proofpoint-GUID: yMVHfIaMS1mUfAEHqTLie0MqLVxUAa73
X-Proofpoint-ORIG-GUID: yMVHfIaMS1mUfAEHqTLie0MqLVxUAa73
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 16 Apr 2021 10:47:13 +0100, Colin King wrote:

> Checkpatch is warning that char* text sould be char *text to match
> the coding style. Fix this.

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: 3w-9xxx: Move * operator to clean up code style warning
      https://git.kernel.org/mkp/scsi/c/1b3babe20049

-- 
Martin K. Petersen	Oracle Linux Engineering
