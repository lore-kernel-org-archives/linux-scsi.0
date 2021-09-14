Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C815C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65C60610A6
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239476AbhINDqF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:46:05 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:53720 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239327AbhINDpp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:45:45 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DNY3GN007062;
        Tue, 14 Sep 2021 03:44:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=7WXaFO/J7c73rDWzDNOn7IEcOYWmJxIHjSdkNx/duoI=;
 b=OyBtBqLN7HAmlbJkAXJ3SRnXGePup0Owo2y1VzjCQkCoNgZkqAD+6TSKMCSxrsyrJa2F
 B1D6jiuptH58D9LvPGjF8zFMicCNTqpk60MblT+eGaYGjKsRPa5aYT2j1Qw3hLCjR/Q4
 jMloYps0OhmRNJbDbkW8FPtWJJ9eoaRy9oW7+emLnCmnsXiHStZq8nDgmllTIwPaWuu7
 DWuuid81PqJtj5+KO3wiR8jxncfOJ2HlHggKML96GDXFcPulxUqJ+ZyN7BuX3iWZG3Ju
 +7yjG2yTz0uW8tboRLjHHcqJasE36fxqtZWVJ0aknSX0kNvtJfPTzq/TDm4c1PFvRg2V yw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7WXaFO/J7c73rDWzDNOn7IEcOYWmJxIHjSdkNx/duoI=;
 b=c8Hn7fDm9AJDw/+BaiVXsD/M/1iiJZJoOT8d6X/PLyAA5le6/qrr/77Q/qGQilKj93MY
 n0xm2op2CoL8pN8/J/QxHeidcxKgDubdZyifU7qianzg6r/K5ddYvV6ccl7NYhF0cnpo
 Y989nh50LLPZbvqlrpVwdyK2WbP+fd+UYoBHsz7oyX6Q2ShAmic0hs2bO2bRpUSX+3R7
 dz/JDb49bC8yldHHvOTwlQhRQi95JDYpB3hQYMr6GnrV4miT+oQzHoJKY9n1bmG6Ft19
 uLDhOb6CHphN6yaz9keTmF5Kd+xg1mDSTzvs/0beutnaMWK+nptskmVTxWinZUu97Fv8 UQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k8sd1gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3eLS4106552;
        Tue, 14 Sep 2021 03:44:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3020.oracle.com with ESMTP id 3b0m95n7p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FBT8Ma4z2GkZFpKiM6kfdtBS4Ph42J6ArkBlMvW3ydNAH/w+63yvdh50CutnFCP+IRM0TpK97WcmJW0yNaYvrnwFbAVTzgpXkzDUlD9ujJsDzT+dApDEL24zgyAdIoodZhnf+YErpKO6mfe89aESPKs4GzlmP7NGtfK+yziV+B7rIzYeQurWEu84mTy+L4OGJ7Eom3rDXn58HtBfkQafnWMQmjuUiUos2VIvaONlER8vBzdCWkE2pT8vaVsq/nSeQLrFp1erKYSF8PQst82v8VYnhYgfxjFMqgIz6lKaf2LTP8xd28XhxN5nEBwVDJBi9gLNQBtn70p4TSX9hhkerQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=7WXaFO/J7c73rDWzDNOn7IEcOYWmJxIHjSdkNx/duoI=;
 b=ZREhVJxDQNaka8Sd5bbDgbdWeuuAeJ+Btpy+Vpx1iEhTBJd+Jhs2bHdml1HlkG4GELLZMwSz7abKuKHS6Zx9MnIVhQq613z26JoH/cdyt9ggAXN82p6zYHoe0lVsCfcr4fIxVYyMktvpTvwE6eNtnJF0eTjPoPimfM+TDAfvm6KQR1U4rg465NeX8rmGQrWLnAaxX+GK3nRjiGCoimdMmY8ZIvI/9TCc1sODMyR5/+/BAU6VfezaTE2HDZuzEbHgRyqCi4BaTRo+h/znmM0N7eQZRBIs1GFbAYd9cCSI00UD9/X4RHgbv6cvoOJ7vLqxNcl3cu4zxuAi7/OOmfIjOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WXaFO/J7c73rDWzDNOn7IEcOYWmJxIHjSdkNx/duoI=;
 b=q+Eic8xj3vUFdVVW/agT5BQAZG6Svo4MX2ZL7Tm6taMbaBk+5di31yawrt7qqA61EqAXJQr72K91bm/iU5ptFrj7JGI6iffrrKEgDQeYVXeqLY7kLaxzZPD32ok7hPn4ASgUIcUzTLk4yaWmixN6Ck4tG0vboeuWZ0NUqVRPPvQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4725.namprd10.prod.outlook.com (2603:10b6:510:3e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Tue, 14 Sep
 2021 03:44:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:44:20 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        bvanassche@acm.org
Subject: Re: [PATCH] mpt3sas: Call cpu_relax() before calling udelay()
Date:   Mon, 13 Sep 2021 23:43:58 -0400
Message-Id: <163159094719.20733.2663564695931957716.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210901152542.27866-1-sreekanth.reddy@broadcom.com>
References: <20210901152542.27866-1-sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:44:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f41dee47-a690-49ff-bff5-08d97731ef74
X-MS-TrafficTypeDiagnostic: PH0PR10MB4725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB472544F4F5C75ECEAF1411138EDA9@PH0PR10MB4725.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nTL8Cc21kEJNecLtTHguj8iJmwtnASq4QEcbUocGVOoCpfYRrcFsYzuQA5DX5BkrBKGqJIYaGUcG3RvqRT5d7xktSex3qobq2+jJNlCwE3XznvkDjSDYqVv/AZUdDRfCL6g5tK/kZd+1hVKp3I5RCPI+pHVAXeM4rh+2GN+bRuqPpZWCr+ULBpGryKd4gwW6LPMPhAHfJKD+jx8ezN85uQ78eQqTm+Gd8oeMB5uOTt/+AYvimloVSe/tm6nFYkXYyvp89/o1i8WUwWPOtRYlLxT3nfXMi6gFHz88eFUe+TdSNFHsHcpMPycX2Y2bm9SNd8pePen7cCOpldyekzGSckJd0/z1AeAnIbBPIOqIC0xdaykUYdsrsXXSbi0bNXk+tKt6raB6+5tGFSLUaD53x10jIT2GFwNml8vNcH9XzwKqNKR3vZHb09rd9U4yuFVJ1HZdgUvksf/dB7vaoOLyraX9ehWOIK4qXOlWlKVasqOdeQM6pRNZgG4arQYrYbFfJ02ANoOeJxUvbHvIeb0unia+YmgK36TuUHBiAcMBaf1iPzxXfEpslACIyaEDUt6GXl4CAWVhYvZren4UZV7FUt0KP+vzrvvW3hnbaLD+/qEMPv0Wm+w6hW/UftwBO105E00ciWauFErpS6v/WOdk67/uwtLzGAdO0vQOLi9lQnRH41Llekb3m9Jwz4hc+l9XsDClPlVMc4ocmaUIeCIUnjbkUYisAY7WOyXDOy+In3uhoN5M5sG53Vd4FVWhtnQA7UHjo2Jmx0M6yJbZCWYVwbJ2KrSbnO8rSVkn0vuIw8yvYkctOlpAXXEXGg2WAQrL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(396003)(376002)(136003)(966005)(186003)(38100700002)(6916009)(38350700002)(66476007)(86362001)(26005)(66556008)(52116002)(6486002)(8936002)(66946007)(6666004)(8676002)(36756003)(4326008)(5660300002)(316002)(7696005)(2616005)(2906002)(956004)(4744005)(103116003)(478600001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzFheEJGZDZlaUxaeDVPaU9heHR3VGxMcXdSQ3hvYTYzVmhMMjZqZlBkWEVL?=
 =?utf-8?B?VVdNWkxxa29DQy9NVDZ0T1IrMDBoOE40dkRNaUpaUnJGUmtQVmFBUFpLdWFS?=
 =?utf-8?B?YmlJWnozV2hqYW1NRnBVTy9SRWpxVU9HUm92OGFmL2RXeXI1Q1gzaW9GdEpW?=
 =?utf-8?B?ODVtMmZVZ2NiNjhRTTNSQmlQU0tBbWhMUHhPYm1DTGNnUlI3eHRQTU4rQXNP?=
 =?utf-8?B?UkFTZ0ttVVFGOTBGOEh4Snh2aERoOUhLcGRxK1NIakNqRjdkZ1pBaGpLMHJT?=
 =?utf-8?B?TmR0bDJWSG5XVW8zdGV6Q3FDT0ZJUzc1OE1Dc05MNWhLdTU5WGwveTkweDhH?=
 =?utf-8?B?Wmx2QmM3elBDNXFHd0RUMXhmSS9IZUdpWXBQd08yWkRTR1oxQm9qWXRkQWNw?=
 =?utf-8?B?UHdWR2dYQlhiSmZKY2FtdFR4QzhCTXFrTmc1R0hSSFM1T1ZnWlhZVHZtanFz?=
 =?utf-8?B?VUJ1TFhkbkFscDlPL2dYQ1MzdWt5VkFicklxQXBScUp1M1JUSlJuUENYSWhm?=
 =?utf-8?B?UnZkc1BpNjQ2akRoVG9wc0RvRlZFcVdnVTFpVU1EMzA4dldmQ1BJa3M5RkVH?=
 =?utf-8?B?bkpGVyt0ZldRN3pJQXJqWmxSaUZxYzdLb1FFUWJDaDQzejVOeHFxSUp1WXJ4?=
 =?utf-8?B?OUF3NElDcENoSmFYd3EvTTJQZG1DNVpiemZab0hnaXpRT3diR2lIWG5ta042?=
 =?utf-8?B?bTVFajRERlVHT2VZN0VaNzE5V3M1K3MyeGg1dFdSOVNvMGx4bFhoVE9ydXlm?=
 =?utf-8?B?SmwrSnVhQzhjY0hFemxpVU44cmsyWjQ0Mkl3L3RPTGcyRU1LY21WaXExVGM4?=
 =?utf-8?B?V3ZnN0paUStaZ2MyV3hoMHlRc3NpQlhaRFBtQVREQm5CWEFlV3dCTnFJOXll?=
 =?utf-8?B?dWlDYzN3VWt1djBQN0EwMkdDOEpXemw1aWRvbG5ScjVVd0xjUFNqYlQ3VDEw?=
 =?utf-8?B?WkhXUWlOS0FOMHZRNEc4ZXBqUGFuVitYeXl5OE5JK2RqK2E3bno4cmZFaHYz?=
 =?utf-8?B?RzhQMDg1Q002WkJmNjJOdzVqc3AyaXVmRFBub2NYOTNnQ0RZKytvV3F6a0Vu?=
 =?utf-8?B?NTl5YlgvTmtjbjBJNDh4ZkpaSUNydHJiWG5qUzlsbkI1VTFWZkxpY2sva1lF?=
 =?utf-8?B?SXdwYzhzVnpuL2IvcjdJMUNiYmcvYXN1eU9pTkYvNTBlUEplYmZncEhhT1RH?=
 =?utf-8?B?SmZXelpmczBlZ0diM09jaTJDSTQreGdsVzdHZGFGY2t6SGNGbUtEZk8zU0RX?=
 =?utf-8?B?VzdSSTc4QStxN1g4MEw5WmZ5TGFqdkxUSUVoRCtjMDdSc0p6blRLU0taakJR?=
 =?utf-8?B?RVE0RmF0ay9sdEVOWW5vWHF6akhoMDhyc2hxZ1dJc0NhdnZzZlFoYWI4dVNB?=
 =?utf-8?B?UE1SbGxHQWo5dEdDdjhTM200cGoyWWRIamhDM1o4K0oxc2lvNVF4byt1L1cw?=
 =?utf-8?B?dzdabnZ0SUpaZjUySDhVMGs0REE3MzFlNlZZWmZYdk05b1lya2hTZXJTbzda?=
 =?utf-8?B?MEFTWngwSlphUmRNS2ZKNGI0SS9taDNJRVAvNzNRWnRBVlY4UnBONVAxY1Fx?=
 =?utf-8?B?RGtSUHl0WXhMQytoOTFONmJsYWUxWVhtVkdBamlqcjJYS01Gem82Zk9tWUF4?=
 =?utf-8?B?dWxMSmJDdXR3bDBHR0tUQWwzZG9GUVNrTGF1OTl6K2QxMmY5ZzlQT3N1UXdC?=
 =?utf-8?B?R1J3amVMMWFya3hqZStoYmFFQ3ZaY3pkSE12ckZJczNkcFV3K0lnenRONzBx?=
 =?utf-8?Q?P/DJAPocLtobFKYTy91rnW5WzZGzoOrII9BZWP2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f41dee47-a690-49ff-bff5-08d97731ef74
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:44:20.5906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ouNroV/BcBBCd2TAj8jZqPFUo03wYqBApZSd1rednUvu8KRN+iQLCZDJAXkxsvchWpyc/nOMHW7+/J5giWsB29TCC8wsa1Ta6ics1PRSMao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4725
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=855 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140019
X-Proofpoint-GUID: n2nOkgune6r0MGJSpfhX5XP0OrDp_fRL
X-Proofpoint-ORIG-GUID: n2nOkgune6r0MGJSpfhX5XP0OrDp_fRL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 1 Sep 2021 20:55:42 +0530, Sreekanth Reddy wrote:

> Call cpu_relax() API while waiting for the current blk-mq polling
> instance to complete.
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] mpt3sas: Call cpu_relax() before calling udelay()
      https://git.kernel.org/mkp/scsi/c/e4953a93104c

-- 
Martin K. Petersen	Oracle Linux Engineering
