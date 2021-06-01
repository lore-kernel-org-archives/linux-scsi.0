Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67DA8C4708F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 15:46:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4720A61042
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 15:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbhFAPsc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 11:48:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55408 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhFAPsb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 11:48:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 151FdmJe135923;
        Tue, 1 Jun 2021 15:46:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=W1lseJSvceoQ0lNwJ/WMOCVLasmt5cHIVgiSUlhITWo=;
 b=ssOST7Pzj/pDp4+FZDaaE9sDZL9LMPeoCLWRnSfQ4mgfRrSOWIRSaTeJalO+is33IChm
 2AbohMqsadrV6l45y27tvW0aIqtQ6gkJR6CUmzFUp+WsDr3J5W2wbm+6EmfLbmRQ98T3
 EXhgjPZqI5T1dWedg+Vk3ZQABcyF3MhIBTq10PhoJ1HQLVdDU+hUPnB5kXrYmgs3OElw
 2TOHLjSwV1kQhShzBPmGuYhCErxUYSZY6ZgDghsr1EzJUMvdT//3UzqLObPTO2F2ng56
 qXBTlXxiMrle8ABPZqwVf5C0Ry5xC4LAJkAz0l2FqDpO8LLeTJxHl5cdeOmJv9dxi/n8 pQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 38udjmnyyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 15:46:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 151Fdsqu122144;
        Tue, 1 Jun 2021 15:46:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by userp3030.oracle.com with ESMTP id 38uaqwdxpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 15:46:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIK5SV4z9xdUjlLh2lctI/a1kThtC2C892CybwO1YrrERnIqrzcufAMFFEaTw17OZ5mSsvfdb7t2X6WhYHCjm+vcGql3wS1D8Wh55qN3QAZuMz8/JN9sONtnHMDlOjnR5EO9o7J3uaH+ifcG9Kjof16Ujg1v6ZRibMRCMDYNUlkN6RfxEgpr7a3zZG8oOhI8KqJC6Wkwjm1DUF7kbI6Zr05S5Tki2oWvtgRBTL0cZv3Fq3mxRn0dyAGIIdyKlYmDMrJTjaZMIAv9Mvb/bAmpO549GlP2Oev3Ozm8zmqhKHIevZCTRk4pAxYHsZNwV1V8+3GJUxNGXMAjUxSUbpGnpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1lseJSvceoQ0lNwJ/WMOCVLasmt5cHIVgiSUlhITWo=;
 b=k6QirRqwD6N5/QSZhnPvpIPluV/5blbUHenZ2HSFUfQPvTaS3Ake32E2u8Ss4ep7WWE7fvBb2c6DyrKo5UzX6cPlan4uKwnbdnyGTDGLMQ+4C01Kk+NAO9zcxjzQPoVwRRJjzlFkGAD5JsGG9+YopmgtjTsFeXJrAIcOlDUonkoxbpQoQHFsNYfNemNNHPuQ4vrTl/HoDv3BG5/liAycBRoHklFHQdODhtW8ert+lm/y68TutKl00uk/HHP1ihhced78xrZY3zC1egZlvcRM9V3V+WSPlIOT50hoNLGqRYSddHc1iiepsrLnsR6jAjDFLOuatDptAn8gtOsDoj855g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1lseJSvceoQ0lNwJ/WMOCVLasmt5cHIVgiSUlhITWo=;
 b=sCMDkYrWBF8m2Bz3PXlQ4smppTBZPHmh2bvxA2MN+qtSgU0TY1CXMoZ2HCCbFKKeGDWG/UcDBt+pQchGzTy17nBpyBOQtV6QZfUKwVAeDkyigHwgJDkE4lCUjoyc9kfgkFe6zOu4mnIVntZoclB6n63P+Y6I+jmaVGJmAoVjCNY=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4506.namprd10.prod.outlook.com (2603:10b6:806:111::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 1 Jun
 2021 15:46:41 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 15:46:41 +0000
Subject: Re: [PATCH] qla2xxx: Log PCI address in
 qla_nvme_unregister_remote_port()
To:     Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>
References: <20210531122444.116655-1-dwagner@suse.de>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <fd338153-1736-07c5-688c-7d2a1703579c@oracle.com>
Date:   Tue, 1 Jun 2021 10:46:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210531122444.116655-1-dwagner@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN6PR08CA0035.namprd08.prod.outlook.com
 (2603:10b6:805:66::48) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SN6PR08CA0035.namprd08.prod.outlook.com (2603:10b6:805:66::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 15:46:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c32af0b-bb7b-44ac-629c-08d92514736c
X-MS-TrafficTypeDiagnostic: SA2PR10MB4506:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4506BD4DA415093BD52C7B45E63E9@SA2PR10MB4506.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L05Q3nmJVS+zLsMOJ75NvU5mLkAXcayt2D5dqkzGZk0VIbvRPvF6NcaLbmobQmzdLqZ5svWJVgz7MbbuxcSxYh7Vj0cFQS/MerdZhIQw7lllEMSYfsW7bzN5BTcPR1KMdAJ7aNtogBFg8Y6lqnyvxnn/ebsUeK2eyY7S/CO0omU52cUV0ge5wv9ex6E/HYqVAraT3WtJ+jcMyUpa33C3JL2n9vBIZ4kb8oKMYnJEJ75mqNN6fcnnQpXi2BP0sbhOsjpLYeDLfp+ObYsHKLa7ao7UT65nQI5IKmOR9d76z+ZXmwdtncbSkxwS10nDqWoD+OjcjZwxaG/TqNe1h5UaUs6LquukLs5DdUkaD5Z4G7ygqfFaqfj7JvnKlXhCyqkpfqbV5nVLz+wq7P4/KUh5drLWu7WE6lTwlA4Y09xP8AT2vh0vrJ52kWZ8UcD10/WKeSkdPq/cMe9w7VvIwEsE1ck7gLIpkUekmTOUb0n2KcgDMU/5sBcgNaDJSuqdRqS5k8RHTCyfSo5dh8bnAkR77dQylBikaVCjYRLppGChDYXuvW7zd1s9kDgM/IYPUJHwtAfWsggZNJ07l7VPrN4xeZrxAlCDfMN+fHn2QqHjpGRKfcBVFA4SyA8CmeR6qtKynGZvIBYgTpfTRzx3+Yoxs2PC2kfSpJLCQt+liPEjprGvztgMK186SoG/bnToVBak
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(396003)(136003)(346002)(8936002)(66476007)(66946007)(86362001)(8676002)(36756003)(956004)(2616005)(16576012)(5660300002)(53546011)(6486002)(38100700002)(83380400001)(31686004)(186003)(16526019)(4326008)(44832011)(478600001)(66556008)(2906002)(31696002)(26005)(36916002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TmZXMzgvWDhLeEpTSWgreE1od0kzS3ZPZWJ0aDBYTUlaMTVaNjcvS096UEVQ?=
 =?utf-8?B?UXpnYmZoUzlzYmtVeG5qQUFKNnFaTTgwYjFReGtSaDJtZ1FYdFhXWXZqOTVZ?=
 =?utf-8?B?djloNDBLV1dLRDg5ZjdmeVlxMWVtMTFXS0d3aDdjRmJDTWV2YUxGWUtsTXhK?=
 =?utf-8?B?ZmJzN2UzcXhQSzlodmw4eWRaSFRGR1VUZUJxSUFSS0llQzVreGcrZjVESjlz?=
 =?utf-8?B?a3hvU2VkZmhRMS9objNzMjlwMmozRVQwUjRaUDhWaDNvbXZvYVJMcFBYUnVw?=
 =?utf-8?B?RVFUSkFuMlJXMmZLNDZ4UlFoZGVLVkFCd2FYbXVScHdiUCtEbVRzdUVzNEJT?=
 =?utf-8?B?NHNtQ0pFUVRpQmljQ0RER013OFNnckVxclg1Wk1FZ1haamhtbGRTWWxmanhp?=
 =?utf-8?B?d3U5Wk1WSVhXRm1tMHBqSWVGN3FDYnUwaEdZdDh6VXo5aHB3aXgzK2IvSW03?=
 =?utf-8?B?azh6QjdTSzVjeGVtY3c5THdPVVhiMTVENGZNbm4rd0Ixc2FWN3BmMSszUHI5?=
 =?utf-8?B?YzhqUW9LamdMQTB6cFFLV21FaUJBUWtrZU9BcFRNYlJNem55QS9OMEtmRWll?=
 =?utf-8?B?cFoxdVpvbC83RllEVHpJQ0xDTzBSVTdTdGprWjVsV0ZNNFBLckU5Z3htY3A4?=
 =?utf-8?B?ZXN3ZGw4eGhNYTl3bFJXN0xHRlEwZUYwOUxlMjk1NE83YjdXQ080eU1raWFs?=
 =?utf-8?B?U3g5Umh5VlpwSVNjeDVPOGc2dSt6dXF6WG9TUThGWW1uL1FZR1B2c2pQRWNX?=
 =?utf-8?B?aUdEMC82WUl1RUxQZFA4eXVwL2t5VjBUdnplUm1aVlR2QjRNdkl5OGt1TFZU?=
 =?utf-8?B?cUsrMlR5a2pHVjVIRUFkSkZ4SGViSWRRUDdkbzR2K29VMmIxMm5sY3pDZHNM?=
 =?utf-8?B?QUFIY3o4dklEbXY2OFdRdFNFTXNVWSs5dkcrSHJUQ1FFTzB0VE5KRUVkM3Y1?=
 =?utf-8?B?ZEZpV3hwK1ZyejdlK3c1WDFNQmpqREJhTUtPaXlLWE5WS2s3cHdLOE85Ynp6?=
 =?utf-8?B?Mk5CYThxOFlqUm5qbllUbkl2Q1pESzBRZDdmSVlpTExXZDluUDJ3MGVyN0RW?=
 =?utf-8?B?REpyRC9GUTJJTHE2NUNLRXlzY1pGNk5iZFFONXhMT05yeHp6dG14ck9jaHlk?=
 =?utf-8?B?dlR0UW1jVU82ZUxPL2xKY0RENEVTNkJHaUJXTzhLV1cvZjdJdXNiSmxyeGF3?=
 =?utf-8?B?UTlwYkpCaVFFU09jcjFkYnE1SWdSMUxtdEErUWtXY1NNMUdOUDc4ZlBXTEcv?=
 =?utf-8?B?WGRWNVlwU09jZGNsai9VS0Z0Vm1CalV4WWxiTGl3UzcvaXAvYzFacG1sQ1Rj?=
 =?utf-8?B?NldhOVVZZzgxUWI1NWRnYVZMU3JKU2krbHhvWWNuaXI1Y0daKy9icFRUaEph?=
 =?utf-8?B?U2dWU2xOK1lGa0NXN3FxL3NYN3F3b0pLMElrNjFZNzVmcmkyUVRabU9Pd1da?=
 =?utf-8?B?cmg4UmZDeGszUkZENi9xZnJxVW1PaVFKemlmdzNVbnhQQjM0VTl2SVJCNzlv?=
 =?utf-8?B?UkpGT1pyejg2Q3RqQ3VCZ0NmbTIyUC8vR2hOOTF3djhZbTI2N21EdDgveWN0?=
 =?utf-8?B?RFBtL1A5R1Z6Q1dleHdBQ21vM0hwYVNUem9icWc1dkdoSG54bnROT0dyelA5?=
 =?utf-8?B?Nm1qWERiUllMSXJxYzBBTVlLZ3VXZy96WndxLzZEek1sUXlEMy9pbHFpNEJn?=
 =?utf-8?B?WHFGN0VoS1JJa0ZnWnAzam56Y2ZHdlFPRnVXZUdHM1RRRzBHQUNtTjRQMVl4?=
 =?utf-8?Q?U94rWv08vigSMBoJNtemcsZcJ6yHiCHtJTzbNsk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c32af0b-bb7b-44ac-629c-08d92514736c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 15:46:41.6641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 51/PoT2Czl4OZlmR9t1e87Yvz6vcftRaPFV0FKv9hRZ6cJwTuCXbC0SGoFPlRJSCC4uCYoA9J8QLbIX9Lj96ax6kTHRXvwJu6Tz4VBABKi4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4506
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106010106
X-Proofpoint-GUID: O_DN2Jo4Gu8pVDMB8hVxILm4CSKFlXCO
X-Proofpoint-ORIG-GUID: O_DN2Jo4Gu8pVDMB8hVxILm4CSKFlXCO
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106010106
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/31/21 7:24 AM, Daniel Wagner wrote:
> Pass in fcport->vha to ql_log() in order to add the PCI address to the
> log.
> 
> Currently NULL is passed in which gives this confusing log entry:
> 
>> qla2xxx [0000:00:00.0]-2112: : qla_nvme_unregister_remote_port: unregister remoteport on 0000000009d6a2e9 50000973981648c7
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>   drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
> index 0cacb667a88b..e119f8b24e33 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -671,7 +671,7 @@ void qla_nvme_unregister_remote_port(struct fc_port *fcport)
>   	if (!IS_ENABLED(CONFIG_NVME_FC))
>   		return;
>   
> -	ql_log(ql_log_warn, NULL, 0x2112,
> +	ql_log(ql_log_warn, fcport->vha, 0x2112,
>   	    "%s: unregister remoteport on %p %8phN\n",
>   	    __func__, fcport, fcport->port_name);
>   
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
