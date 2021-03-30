Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EFD8C433EC
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 500846196C
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbhC3Dzw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:55:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60874 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbhC3DzV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3jGUC141768;
        Tue, 30 Mar 2021 03:55:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=04UqNeaGq4ivvD+5K5bMmzfkpg1mEf5ijDP7DPalwIs=;
 b=bb0U2Utrirsjt416Pb9t8pYTiUOSeEtSc0m/GbsOEi6PdSNjzbLirnHl685bD26IYbGy
 uV4R2vOBdRkgBdltzi67f3ySHHOSNBmXJTLimBlz+MeGh0FI+gTeWK7f2jBpS0I1N8J2
 zbZgTs2S/XXwrjAzWI18aKfO/eKjz1oN/CgHYNml337WJTp/AmLQx9khJUJSgS/BYPaf
 bVV9Q5FWscz4pfcPbtJyB2BIPRKYOZq2r7tSC+Tmf5WvobUXGXU3BBAhNkL+BkYcKK2Z
 FLK01F48Ab4AMce5iZB07cMTPr5aBg3jlZmovrjvHWCKIDwzAVsZI6N+eEJoX1oAs0te Iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37hv4r5k3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3iXVH039572;
        Tue, 30 Mar 2021 03:55:09 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by userp3020.oracle.com with ESMTP id 37jefrktad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLGh26sfgSOh/ZUzSl0xM/eHjyPVQBrrizesb/MBwx3PS9sX1y4JpVaAdjhmIwPxAsDejFqdieTWkRLOwI+JFHKqi5dqCko5CVtqCBHDY9TuDjliEjumzuxfx/Pk5ofpyxZMCmbyUTeHJ73LyF3htwBjCLdvlVmVbSLxpD//cQ8FADsE++6Vabf/TF0JNwYsBO/ozKMDlwtHzVVo95cKdh4JPSmYflAMgeMg/2UleBhXvDSfbzF6zscPggcI72adQ5YgcMe9k1URE7Ef2MYb9cOdtI62oyOQ45CcireHDvfwb1xwmJyNUKqi8z2X5bpAV7lYvL/8SBjHS1B2hocD2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04UqNeaGq4ivvD+5K5bMmzfkpg1mEf5ijDP7DPalwIs=;
 b=hFwKgcaFaM8wh3a3ImZwZ6hOxm9hKH5jGPOkST7K+AxfW399x9/SgvxQ+yse7EhAwkFrKbknf67OHwQJONnQY6SlBnQdSHAMewExbHrtLcR16HwXuHVutQIw69RKbxSJVqjPv09L/tJqnMRaMBFmksd09WcDqKQEJxffVpP5jXRbynQuYqhI71NC7JJB8UWtGlPNi/+Q2jbx2MC2Fs/1AF2P+jqg4NlKBrm/na0cLMPiAt1fVzuWrq+SwZetZ8PTsBZ9LwWrpe0pwAcD4f0olgeTi3B8wfJANBK5F5XajH6CfDn85WNJfP3dpiDZfSuopN2Diyr/+mNdWh9/0L6CYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04UqNeaGq4ivvD+5K5bMmzfkpg1mEf5ijDP7DPalwIs=;
 b=BDtGsmOnJMTu0jLC8ohllnNmNokUmS9ZKgTNu3jz8x7q0W9PMD8JbKZisDq3gewEUAN/85WYWJoYfnDfw5n1NMYIXPPhM2MP5glpzmyVQUdu/RWk3Bmj7st1+dDrkWaKiEuFY+k03gzKcA+FPgVCMOmaUPpdMTkqtr1iqVR9dUI=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4758.namprd10.prod.outlook.com (2603:10b6:510:3c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:55:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:55:07 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     GR-QLogic-Storage-Upstream@marvell.com, jhasan@marvell.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>, jejb@linux.ibm.com,
        skashyap@marvell.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        rdunlap@infradead.org
Subject: Re: [PATCH] scsi: bnx2fc: Fix a typo
Date:   Mon, 29 Mar 2021 23:54:40 -0400
Message-Id: <161707636882.29267.16188415854310481946.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322063530.3588282-1-unixbhaskar@gmail.com>
References: <20210322063530.3588282-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:55:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7daf93c0-f437-4bce-377c-08d8f32f9b75
X-MS-TrafficTypeDiagnostic: PH0PR10MB4758:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47588DAD06040C5C00A665088E7D9@PH0PR10MB4758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O4tE60aiLZH7VGh+L7u4PotGz+mGk/ccf90Y2uzWdFHsXTvaYrRSIOJsQjlvIFsv+or2iQi9loXbXLv1o1Xlw9qcVj57i1w7Rlzl1VAcmdoxo4YoEbxXTHH0eIIRKKEaRt6yz3uX3h7r1T4TYlC6x3iJz1NWZn9wWNqgk9hVkgMaYS5fZ6tX/b5pN55pN9djF1dFVP6T9w2VwAvcr66HFtErJU2JDq7iF6EopN75KEIK3khZzeiL4pSUAfpKeCqaykS2U6VCJs+/LH9nOHJ8/SeQcUg/Yrjl4M7OeLblIIlKqO8XDDgh1jgOw7hNkzz57yKHvuOUzQDGvvRlLlBFGzDxh4PdOlqrfYwlh7sV8BGAw891+kWr0oUeKNRrSEe8w+9+gfyWXadRjoTmsqfP/u1speApXILDcYIy9dutmyMjqNTkO3KkgWR3DBrMsF4D7aEh/Ijkg2ZpW296Iy2jdIvt2m7bXVZDDnRb7Dqi1zzBV1t5ZBEj6GDj0WObu7IQNXiJADwW1H1oO+ujfPDAimtTOv9tgCUCBzIyQTcfp3Sf082myOkRYGxQwx20YtKizXKeWdX6xv/OQ9QrTrfqvgD8g4W4Ents9X7nxb8NvOm3JcT8Ikog1kJs/qTpKuwYFXjBSbwONRWm1apz+493YNxBM3WHExmZHkQPq/Gcyl7n/wmn90tnwvog5msm5k9ghEDzDgd5o+vk0lc6bGnuaW08hQ4p7SjR9/elYbUrV2I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(136003)(39860400002)(2616005)(16526019)(8936002)(956004)(6486002)(8676002)(966005)(4326008)(66946007)(66476007)(36756003)(86362001)(2906002)(558084003)(103116003)(66556008)(52116002)(7696005)(186003)(26005)(478600001)(38100700001)(5660300002)(6666004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dnBCSnN1d3BlYjVPa3VFeW9NeDlORG1JYzlpUXBKQ1hCM01vT0VXOSt2aTVF?=
 =?utf-8?B?TC8rcTVDaTVPdGp0MzNZbjQ2OHRYZ3dmM2ZWQnVsOWhlcThRNkR2UmhXdUor?=
 =?utf-8?B?aks0QjQzQmkxdjdYbXgvWXlkNkV2a2oyeExqVEJPMVhSVGR4T29zaXdxaWxa?=
 =?utf-8?B?WTEzc2RHR2RtMllvUk1XWndiWis3NFpiQzNRZ2F4VUczU2EvazlUVTFSNHBU?=
 =?utf-8?B?YWNyeDhza2ZaN0RCUlMyQy9hRjJZb0U5d09yS0dGWEdEY3UwdmpMc3JkQXo0?=
 =?utf-8?B?R25aQnBqR25nM21yOCtOY2FybW1MYVp6akN3enRNYjVoRnpaRVIwRUp1b2dv?=
 =?utf-8?B?UGxNenJUQXB6KzhCUmIxbjFOcjQvNnFOclhHbnp1VnY4OXhrSm1FNGQ1K1VG?=
 =?utf-8?B?UStFK3lKcmJRK05OT1JJVi9mWjB3VGNjM1dvdS9ucSswb3ZuRXdSZUVXZHdt?=
 =?utf-8?B?SWxEU1RYMmxFamp2TG9LeXRvY21sd0VLM1cyWS9MeXNBNzhodWQwTVI5N0VK?=
 =?utf-8?B?a3l3MklFMHFTc0EwVmlkR3ZVNHdORnNVWUY5ZVJiTmpvYWRlSHlEU21Yai82?=
 =?utf-8?B?VlpKZ1hlak16OGI1WFBSWm9oNDB0UWhpM3YyRG1sYVJLUDRCY1JMNVhQaWYv?=
 =?utf-8?B?N2Fzbld1cVgwLzRFR0JvOWkzNVFPazhLZS9rRnlPZ0QvRUhzTzY1aWRFcm0y?=
 =?utf-8?B?MkRCMlhaYVZFZGR0di9pTW0yVERRTFB4TFhRTzdhUHVQbXg4bjZ6SGI5MVEr?=
 =?utf-8?B?ZUd2WUpOMkxPV0NmNWNMWEpoOTBabGNkN0Q5UVR5bldnSzEyZTNMZzdnVXNH?=
 =?utf-8?B?emx2MlJMYTFIaExIbVFBcVloVkFLWmNKYVJiMm1NSEpLNitBWU1OaEtDRFVW?=
 =?utf-8?B?K1RYM3oydCtEWmdJV2w4WUVBS0wzYzVLdk1pRk0zeXIwU2c5SGV5NExQMm1v?=
 =?utf-8?B?eXlWOWQyQ2ZqaVAydEowVFo5ZFJ2aE5yTm95a1BHYWxza0Zna0l1NmxOUisx?=
 =?utf-8?B?RVVsOXNxU0NtUVhxelVmSWxBYzdxRUVpd2FDajlyQ0QzOTkzcW9LRndncE0w?=
 =?utf-8?B?ekV5N2Nma3R4cEFwU2NwWUI0aUtYcW1tNnJKcXNWNjduczRRNndLWVlvLzh5?=
 =?utf-8?B?dTFyand3aWJqaEVBM1k5ZW52c0RaeXlDTmxZNjdrTDN3NTNrT3JrYzdhSnlm?=
 =?utf-8?B?ZjBvQklrblo5dmk2V21XMmYyOFhnYWs3TXRKZHFXY3gwSmhLQ2lCWEEwNUE4?=
 =?utf-8?B?SFBoT2p6bnFVMXZCV1dQSWY1RkNUQjd4TXVxa3NGYXdVbFBQRmhyYm4zWGRh?=
 =?utf-8?B?bldieFJlcWEyeXprcWJUY2ZYdVFyRGxLOFpjR1daUVcrakJFV24rU2pCMHFS?=
 =?utf-8?B?QUpRcFlXcS9lc0hVaXZrcUdLNFlxMDU2NkVlSjlMVTR4b2hQVTAxYkRVS25q?=
 =?utf-8?B?QXJmcmcxT0FqMkJyQWd4MGRoRG1jRnAxTDZFemVWY3lZVkQ0YzJYbTB3emdi?=
 =?utf-8?B?N09PV2U2a1dtWGF6KzFHUFVaVkZsc1Baa1pDMnoyYWsxc0ZvRHNjUzFObERC?=
 =?utf-8?B?OG5Bbk9sTEdIRllKVm0ybncyeU5zVHVsRVB5eVM0RlpLdmdtWE5mTnRsdDgz?=
 =?utf-8?B?Y1hnenp6eGN5Qmx3TWJ6elRtV3ZFR0ROeEc2VnFqRDk4by9MYXRhbU9LQUI0?=
 =?utf-8?B?VjB1SEZ6RHZRQXl4VllZUTZGalR3aHpGdWVyN1g5ZHI3VjE3Ym0wN3cvSXN4?=
 =?utf-8?Q?Lac7GeuRxaUUcM/1w5HZI4WqQKzsLPtpRG2u3lR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7daf93c0-f437-4bce-377c-08d8f32f9b75
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:55:07.2407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yhv3bcFH48hHH1170sCl8KWAR8tJ3XoeqZnsBQZzXdR8cR3x6I7pTnxNMmY6XsST6ajeV/FO/KowJuQQ8e80CQQkeVvx0UgiKgxkZoEiy1Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300023
X-Proofpoint-ORIG-GUID: NOvGGWRKAdr7-hUL6pdA4zzBofxcBcmS
X-Proofpoint-GUID: NOvGGWRKAdr7-hUL6pdA4zzBofxcBcmS
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 22 Mar 2021 12:05:30 +0530, Bhaskar Chowdhury wrote:

> s/struture/structure/

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: bnx2fc: Fix a typo
      https://git.kernel.org/mkp/scsi/c/5fae809faec6

-- 
Martin K. Petersen	Oracle Linux Engineering
