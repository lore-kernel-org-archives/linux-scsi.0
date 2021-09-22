Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F8CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B2AF61166
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbhIVEri (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:47:38 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52150 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232033AbhIVErW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:47:22 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M1oG9b021885;
        Wed, 22 Sep 2021 04:45:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=D7I1fekBrVAm0K1++mYXnGEA7omHi9Be/cfQn0ClhFY=;
 b=CYeQljuKvXisHesiK1aMQVViZAOYMHhaeA+PiC++XBHkioAQU1E4t88WHP6jj57DxS5F
 XgfjOb3xW6s4GDq1f/pJC2lfpUp9il3XT2+aft8V6u7hytoEyRHyqkY4BE1kXXxvpGom
 ZxchueQez+Lh2OAFObRbeV135DeBY1rjfPAwcKpphV6dW+jI6JUwbppF42LlsEV0t12x
 GW3sYw+Z65G9DjcjXgRiG20IAX6jaCV1VxyHiifcpXY7Pfpp1TJv0VTJu1n6TTN14jhw
 il14GQcaz3GoWfyqGJNQETlCstqD+utjWbRVnpQxGn819ubUp42uJ/vRBwdRF1Zj7H8X xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4p1c1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4imt8117613;
        Wed, 22 Sep 2021 04:45:43 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3020.oracle.com with ESMTP id 3b7q5a3s0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFapkMAExPmlsTXjeYvQHjdlrL0Kr/DnIOVZmOY9u+OIknXPWssPJRt3/htoaG2hJWdWGOMYynMPw1qUmvc36r+OP2L5jRHFufXEG/NnHXP7B46OZh5F4phHhR/VBk2s+2I/d8DJ7h3Vuo0c3RMzfXT+E0vmDK8OyDufy9LLS83DR50VpXGHMAVq9aBeG49jLDUkQ2DI8qKCuUui939+s35bl7BnDaydrimoDPc3bej8PvVSJr5hbpfOj9WeA6xanz3tZ9/JsdHJHpwglggZGe0ceUEyeBuK6erQyMic2pXyodHRDi/IRR7uZkuPDa8fhkSaI2KppAShbOk4CIGpEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=D7I1fekBrVAm0K1++mYXnGEA7omHi9Be/cfQn0ClhFY=;
 b=Uv0gECvCmUunx7z1JI939ghRMs3JVHDNAIW5ZRdeJEFm7cVBIrp7IhHfObH5dYJrrCIjLddK6mbSjO7FvJ3y4g/g2DvpyGkI6fMy6J7ip23BFFCsM6uYNYsKsOnDAT35aXuCQLQY2j+DkegBF0ZS8N9ybW1+Wfhiu+eNFPB4ZQ1fqcH7xax3KK80acw/QZ+lVTy7Ic7rsjJHcKEyjugaqKKRQtjv60m2gLGtRmyB94cMaDczl7+fG/sIR2lC7fl5E+4SlT+sH6kKyloEBLQ5kZdxx6Jdei+n/COfnRnzpa5JjCd0xyKdGx+m0FX1paZ1pI9H9H0vFu1Sd6V3tQVkAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7I1fekBrVAm0K1++mYXnGEA7omHi9Be/cfQn0ClhFY=;
 b=ACkfYMZRc/hnj7uM+P1/ad+wOLi+ZEFa4k+RkYdkOchRDfvIvWD2f1PZs/6el0ceEIkA2nXMrtG37UftpO6W4o5Vy6bLeq5pBzjoMwvr7POHR+gNwP1n+xkRLIrRDpHQ34gazH4NpvyGyF7PBooXtXd3wvCitC+5QEh875zjNd8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 04:45:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:45:40 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, peter.wang@mediatek.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        stanley.chu@mediatek.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        alice.chao@mediatek.com, linux-mediatek@lists.infradead.org,
        jiajie.hao@mediatek.com, qilin.tan@mediatek.com,
        wsd_upstream@mediatek.com, powen.kao@mediatek.com,
        jonathan.hsu@mediatek.com, chun-hung.wu@mediatek.com,
        lin.gui@mediatek.com
Subject: Re: [PATCH v5] scsi: ufs: ufs-mediatek: Change dbg select by check IP version
Date:   Wed, 22 Sep 2021 00:45:24 -0400
Message-Id: <163228527480.25516.5319363433652701643.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1630918387-8333-1-git-send-email-peter.wang@mediatek.com>
References: <1630918387-8333-1-git-send-email-peter.wang@mediatek.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0154.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0154.namprd11.prod.outlook.com (2603:10b6:806:1bb::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 22 Sep 2021 04:45:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0f4b27b-026f-43cb-203c-08d97d83d465
X-MS-TrafficTypeDiagnostic: PH0PR10MB4456:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4456D555EAB6A3DBA5150BAC8EA29@PH0PR10MB4456.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6CYS5/mWbg0H+OsnGFGXWTQYfACc/oqaPDkvpbkFcgEbFqW7GKhADZphVsNRc8yuPGzUey2ParAkCJQlgcAJ3zeerrtod17ojPF1DBnU7CpQucbxaaHdWIxVhd0gSU+Zm+UmL5k/asJKCGB1CC24opBAuz2IElsLXcfA1k93ucPDIHCjTgh3tbbS2WMAJ0TGyTnbBucVYN4U5zjbAS1InGhTtUR1yt7zTVRIvLHkCbO6Suo2LMrdEwYPdLmG3mKclspAbDm7fYunkk/9ibv5O1xeQNy8HtwkeQx7neywFeTluDLgEIIvAlmVIycjBJu7ptvHFPkBrEpMOwY2qGuEoLgtyp299se5lD7W8hC2MsWiqmbsCbW1uTeNAU1CpUqZHCRQth7Cre0tqXuHZVRRJb3BoExSNei3VWUum7ZzB42Hx4yRgR3yT0P7ZiykvxXoZFUtbqMVv93HvYoDy9QLojWrmiUlE9jNdUlBQJjFTNY7IiCFqsauu4pN1ACrmO/Sea2HzuG8lYQjeJvllEuO2qN1VL9nI5UuipF5uGnjSmvWFWc9asgoYr0iYhHeYiuIMYxiXsgZ5aQ45MsABY4A9VT61qGNn/mT4Yk9wssIkqYTNArt1vs934IYKknLm51C4/giWGEy9iZ8TY/IuaRwMmtk13/qdTZ895Js1yIFSdKvPNIE6lqVR9f/Dy8IWVKWNwZUVQ9wfBNEFTARJeADu8JolxSRNX43UP5WAxxnt5JOuyAZB/yMoEKPaxi9fQao7HSlYfLgOXz1gpivIve5bdcdMtm9mXW6ANVLpCrKWpE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(966005)(36756003)(86362001)(2616005)(4326008)(508600001)(2906002)(8676002)(6666004)(66476007)(38100700002)(26005)(52116002)(103116003)(66556008)(5660300002)(66946007)(7416002)(7696005)(6486002)(4744005)(186003)(38350700002)(8936002)(316002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajVhMWdUeGNXUkxaMlRVb0dPOVdkcFlDRXlJRkErZ2ZvQ29rcThoUm5jNHl4?=
 =?utf-8?B?L2lmZDhEajlmS3ZyQ3JLZC9JNGlmcFVOcVJ3QzRSZHpEMXdNeHBDMGhjblpF?=
 =?utf-8?B?RldBQkM1Z1lIZmtJMENWdHlGd2ZiR0xTMlhKMUpQQzJGMmMvS0xvWk1ObXNr?=
 =?utf-8?B?K3F2SVJ1STU4OW9meURJY2krNEZiRHJDaWRSYzJzc0xvZnpnaXUvUytRR3VQ?=
 =?utf-8?B?akFZU2Ewd1Flcy9OTnVMTjYrYllndmNFakNySWlnK3hzdlkrWVN0RzExQUZS?=
 =?utf-8?B?WWwrWDFhUGVmRk93OW44RUUyc0RmNHlOYzhLV3kzTE9HK0xYUFo4SUlqM1BN?=
 =?utf-8?B?ZUN2ZkhEL0o1UmdHSkQ4YnZ5K2c4SkZrUk1RZ1hPaFROM2g5US9UVUdLRllW?=
 =?utf-8?B?a090MU5pdjBFYjROTkUyQWIzRmlaMnBaODlYV0R2bEhoelNPcjZFSzNQQ0wz?=
 =?utf-8?B?S0E0VGdxQU1tTStiUEJLUE5abFRaWUFWc003d3g2dFJHMHQvWXJVZEpHS3BU?=
 =?utf-8?B?bWJybjlGcUw1ZTJNVzRLczkyYUpPS0diQXJTeldzTzdTdzB2SnBLdU9obHZv?=
 =?utf-8?B?amVtTThvdzdYMlBObW5pWkZwWTJycHUxWWNRSkN6QW13ZHBLU1RvTzlkT2tP?=
 =?utf-8?B?c0dpOXhtdU82ZDVmeW0wUEVVWFJQb2xKWFVoemVGZW9OU2c2Rml6Nmp4bytq?=
 =?utf-8?B?N0JBYW5ndDZDSWRDNDk4Y2F3YUdNTTRBamUwTy96c1FMb0lVdFlVQ0FUZFBN?=
 =?utf-8?B?ekR0RVJnSzltV0NLNkxRODRlVXVRelBwcm1YaXNXNzAwQjJZZnFtNFJ6VkRo?=
 =?utf-8?B?RnoranNXNlQ5b0l2eW5pWmtzNXcwWWZFalIwNGUvQ2p6TmZIdThHb1pJMHpl?=
 =?utf-8?B?aWhPbmlNcjgvYUtRSDNQQSsrYkhmMGhwWlZ2aHg2TlRaSE93YW91RE9IZndt?=
 =?utf-8?B?R1FSL3ZBczRsdnN4V2hKOGVsQTJwdWl4b1o3WVUzV3hrVTZwNU5MbVRnWGhV?=
 =?utf-8?B?OC8xTjJMM3FaWGs1ek1EYU9rc09keDZlWUE1NEd1YXlqV0RRMk12WGxRbFoy?=
 =?utf-8?B?MXMxaFA3Y2pkbkw0UHhOOXZZVUtDVXNVUDBXQU1jQ1EwSEdyN3NtSS9FeGxL?=
 =?utf-8?B?NTNvTENIQU0zdExHbFJFdjRMYzNpM21CendIQmpaSFBlUnUvUVZsOXkwa2xl?=
 =?utf-8?B?RDlNbWZuUDczdTIramV0S0NlYXJTZWtvbnBhUDBSb0w5c2RMY3pwTTY4cDVP?=
 =?utf-8?B?YXNQSjEzRFZSKy9ncmNFY2pNVThaR2N0ZVVOUFozSWppMHN2RUFXWHE5QTRM?=
 =?utf-8?B?YzVGVU1nZ0pkWG5BUG9mL1Q4cjlsODBIbXJsejJ3Mk1pYmoxNk82YTYxU1BW?=
 =?utf-8?B?WjRWSFpldjJ4Ujk4K2Z4YXpIczJUVUhtUFRXbE01U0o3RUh4dUNiaVM4cGZn?=
 =?utf-8?B?U0dsQmloMHNFdnY1SUFEcENhdUtsbnNXa053bXJmcmo0TjB6MW1JbmNBVlNh?=
 =?utf-8?B?L0RiajZjQ0tKY0ROM3R3N2JSeWRoSVZDNUtOeWkxbWhMd3pRT3VuNkluWTVm?=
 =?utf-8?B?bG9KaXVlM2hWdWdBN1cxZ213b2Y4Rko2b0RmMHhsVVFQK3dhY1JHUTNOU2V1?=
 =?utf-8?B?dnNkNGx0MzVuZVloZWpTcUVxSzljRGd0NEhLYjZVemE3Qno3Wm82dmd0VW1L?=
 =?utf-8?B?UFA3TUh3aTBRQXl6a2kvSk9nRVl6RmducFJlTEk5N2lrY0xlY1B4MVgwRitw?=
 =?utf-8?Q?ndJDb6sdJE4+4rHJH+crSXUOm25M+bnPZG5FiW/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0f4b27b-026f-43cb-203c-08d97d83d465
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:45:40.9261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CZg86DzTUgukhoY4pY/cQ+DOgXwm6J9vZfZkQZAiCFwo8WcqsVdHlU7qCVZYNqTa5IxwrRAAGrFRsyy6sQKQ2kYenZGOoCMVg2okXon501w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220030
X-Proofpoint-GUID: UfIY8zOW6TG9P-J_P_Rc0AC-MNiXDZwd
X-Proofpoint-ORIG-GUID: UfIY8zOW6TG9P-J_P_Rc0AC-MNiXDZwd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 6 Sep 2021 16:53:07 +0800, peter.wang@mediatek.com wrote:

> From: Peter Wang <peter.wang@mediatek.com>
> 
> Mediatek UFS dbg select setting is changed in new IP version.
> This patch check the IP version before set dbg select.
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: ufs: ufs-mediatek: Change dbg select by check IP version
      https://git.kernel.org/mkp/scsi/c/aba3b0757b6c

-- 
Martin K. Petersen	Oracle Linux Engineering
