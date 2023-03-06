Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CFCEC6FD1A
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 18:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjCFSVD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 13:21:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjCFSVB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 13:21:01 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC56D1BAEB
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 10:20:36 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326GwrZx015352;
        Mon, 6 Mar 2023 17:20:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=3ZkhHlg9Awutja+bOmDksKqNJqV4oW018xNj+jOxqwk=;
 b=zUYD4SlSZcohFNnRSDu3CqaJRIeoWFAfauvk6wfnz0KGJkaAK7lKkYU0aUgvNM0u77Ja
 99HAFdXhR8LSgjGMjAdH/ZcxLxMJwgd/C+o/ZxO+NDJPsB/ZMog8Cg7h9wxZSgHZAcBP
 U84QwvYBnt2Dm4fE/z1srV4ZDTVWHSuXqjEZIV0vZyyC6rFtTL3RkDzqGTV1RPI8tEx8
 HQhicblgop1dbBJhg1+zbqfFN48cKRJzgGAF8LUVa6tZ59oQnv2LqX7lNEnGduXbPJBf
 sNhH6sPo8B/ZjjPK0IZJG98bczfLSdnCu68v+h98ijV+Snmf85q7M+Dqs5UQkEFb6ydB qw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p41563fj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Mar 2023 17:20:20 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 326H1llA019218;
        Mon, 6 Mar 2023 17:20:19 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p4tuq288x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Mar 2023 17:20:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KP5jL/BwmJqIisrI+Tza1i8VkAke9GUDulHrca3Cn8oPU9Y2Y9vN6x+KJA/s089p0m+kPPl8dQlbQ0oV3ih8AVdHm1CG1IB5Lro2CoCp22uYTMtVqhO5Z/DBfFOru8ME4Z3Odb3MVh3iFjjDxUkRLJ30k624TF0kL4Gdy+OX0PCDITx1bBM2KJm9l1GPAQlv6sRzyt8aC8hp8DlsAWv1R9mNCJNqW48jhv9chD/ioBghAMb+UTc3KazIx+oQymURBYGz8+LzrMGSH2RMm3OMhIIiUVRPZ+MDhoKfvZXP8BZ4+HGGrt0gmLkiyTFV9PaeeJfOPO6ni8laXyNFMq+LyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ZkhHlg9Awutja+bOmDksKqNJqV4oW018xNj+jOxqwk=;
 b=YiQN18xhoE0QNQEw/+RqWTksdFQ9bAPmLRFuzjXOV9SiuiYBv8UeHaVRzpYce5J7B04z0G5pKyMqC4Fkjx9Mu/gRC9F0Be5gnTEJcmYuqof8s3lU/0UFNqoIi9ylxGFSgc+v85qNdoT6lhkHE4zs/GjuRnSdzJ/YjrUS9o82TEoYHb8UptskbZTirRCUln+NWsqR+rxoO7m2irLqCjHv2X5/6YvpXriLyinC9aUv0BEKiKROHwvxleTfCRJUW8Eundlt6dPiF4Oqo330R2qOBWUqBYfBK6oXDYQEGACvLg7AKukAJ4N6dMbJX4RbryYsXdTvJ0oER6XJZ7/P2MF2rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ZkhHlg9Awutja+bOmDksKqNJqV4oW018xNj+jOxqwk=;
 b=RaTtP7RfA4uXhTwK2Ew02tspL2U/td1qX9ffjs955Fx4TD+jDQQ9fwLgTHvZQDHGvDbq5bDV9XUE1DG5n4zTEwDW+X8rRcmlMaItBtaomVFZhhiB3bbgxcIJ4GTTDihAexdqM/BjmpQ26h/eSr+DmpdHDXvFXsnw/gyvkPm8BKA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY8PR10MB6489.namprd10.prod.outlook.com (2603:10b6:930:5f::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.22; Mon, 6 Mar 2023 17:20:17 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 17:20:17 +0000
Message-ID: <b89d5cfb-9c24-23e7-2ac5-0176c5a7b16f@oracle.com>
Date:   Mon, 6 Mar 2023 11:20:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 48/81] scsi: iscsi: Declare SCSI host template const
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Varun Prakash <varun@chelsio.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Jesper Juhl <jesperjuhl76@gmail.com>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-49-bvanassche@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230304003103.2572793-49-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR07CA0051.namprd07.prod.outlook.com
 (2603:10b6:4:ad::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CY8PR10MB6489:EE_
X-MS-Office365-Filtering-Correlation-Id: 0890300a-ba5d-4edc-0dd5-08db1e670e09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ChoAK1fLtwf+DomLo87mKCXt2yx3TybF6PutvAG4Pzxjf4qiOdN9z12Eg76FMAquQxOKXmOqr1kSYy4vSqw28NmHCy8wiYain3kNgodPx4NnayLIrPAr84dpoVvjHCCD0ep3fhEQR+UeU9cb8JP/Zz7jjIvinGY3ZrCygZc2WLxkt6TFHPJOMTeBU9eQwvv/KSLpwg+DJ0PzPm1vewov8bV/fmir7TeDcUafj/fgcO6qxWxNN2SvipPXzLMsvMRG7zicJA2pA3d7mQl3/DFnvblK1cKy1prxSG8boBX/kKtOsANwAMQ7u33qLJFMWs7dQb7KvI9eel3Ui/6roPVIUVtDoIqO3oC6w5Jp7sVWt4kLsv0+KMu5VoSro3N8xw312nhFvgMoAEpgskjph2bHELZf64/GRPxAfud/pO6aIER0eJkj8lLLLDe9wtzRVm2DOouNOxS/QdfNTHoZOu+7pAwjYEnFlhvlUhc89h4T9Y/mPea3bbaW1iHtWPq9gHEtDd5gaVVoUhgnqC68EFohmUSZAMoWGHSNc1txZZ5WqaZir9B+UXoYtInGyv9BLEz3anOOIaxesYVwNacAYAXlf1brr6LhWZntdQnATxnpInE9tEdVY4v4H9kqSuF+NF5fryMhosyKnAQsQpN56DxFdq/FzNZKxXfwhlXJ7sK81uoElORYJ2w4EkeMbHpo/+Rre72VYAFZ/cJR44FJDPDO++C5q5hemzsNoF/KhFyZ6A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(376002)(396003)(366004)(451199018)(2616005)(7416002)(6636002)(110136005)(5660300002)(54906003)(4744005)(8936002)(38100700002)(316002)(8676002)(4326008)(31696002)(2906002)(41300700001)(66946007)(36756003)(66476007)(31686004)(66556008)(86362001)(186003)(6512007)(26005)(53546011)(6506007)(6486002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0NMRlZic1hmbVVJb2R3TTU4bmNBWlUrVFBVZnNCYUxmYkhLYlBFS2NnNkll?=
 =?utf-8?B?SmFra0lGMlJ1SlB0SzVKNzE4YUh2aklnVHFWZWpabkp5ZnBpWGlrTGswM0J3?=
 =?utf-8?B?azhCa0Z1NENsa21vNHd4MUxTK2YzUGRGbU9La1dHdEt5L0ZVWTRBVmk1cndJ?=
 =?utf-8?B?MkhiMG9SQXFZaktmVkp6aTdDazB0ZzA5NE5tRHkwRXRDS1V3UWVJTmxSdlRM?=
 =?utf-8?B?Vm1nZms0MVQwOE9GV09qallvT3g1SEhRdURoU3ltQVhlell0WVJrVmkvZVNZ?=
 =?utf-8?B?QkhtNTNzYzBKUkU5Ym5XR01zOGFMZU5ZZHZjSzBmZ3FwTWlXZm00L1RhYTNB?=
 =?utf-8?B?TDdTV05aREN5Z05aQllaV3AyMUt6R3lScmZ4U1NhOG1JN0E0UzFTa0FJSmd6?=
 =?utf-8?B?bUtGRVhGYXNnSW1WMzhhOTd5blVwU3VKcmFqNE9tbUJMYU5VMmU0VTNkWStU?=
 =?utf-8?B?OWtDSC96MFNsZEJjZHo3ZTlBdkFCZFZYek0wMDQxdVVmSkNlNTFuOWphUjE5?=
 =?utf-8?B?MjNPbzJUbFRKcVVkOHAySW5mL3RPQlRXb0hnSVlacHAzdkorMXROTlJEei9J?=
 =?utf-8?B?MmNUVzF4YlFieG1odGhHWHZSWEsralA3K1Fna1EwaVBjUFhNNVpXREtJeGpu?=
 =?utf-8?B?WExTMitzdktidHREU05iWTJwVEhrcmZTSmVJUkx4S3RkdXhSUkZMd0hVNDZk?=
 =?utf-8?B?NGNyM0hOS2tmaktFeFV4TTlRamIrTC9VRDNTUG40YkR1ejBMcDEzSHBtZTZT?=
 =?utf-8?B?T0w0dEs0Z2hUbVlxZmhoU25NOW9Id1VpY1ZzUWRMeWNocUpCdDZXbVlvVlJs?=
 =?utf-8?B?UmlUcUdER2FGOWt0ZmU4bFY2VkpGQWZTMWFrNkkxL0kxVU9OWXhWMFlrd3Ez?=
 =?utf-8?B?L1Y0dTRsMVpKT0Mzbmp3MHFGQnVWNXFVVldqTU5Rb1dVNjIra1N4NTAyRnNR?=
 =?utf-8?B?NFEzWm9Uc3dOZlphMU9CdDNhckxkUlUvaFJpNzdXTlcrc3ZNZkNhd0hodU4x?=
 =?utf-8?B?VE13WnV5RGs3Y2EvU2s3MENiNndDSVh1azVaR01WbSswQXE2b3BDV251TjBz?=
 =?utf-8?B?bGMwdlZJUVJKMXBMYjhvSHBCWnJXRVBSUVg5ck95K1FtdGxsMDM1eFY4NlFR?=
 =?utf-8?B?Uy9FZlJydHQ2VlJMZlNROWRKL2J2Q3pGTmsxVXRoUWpZd0xrcDd4ZmJ1dmFO?=
 =?utf-8?B?cFlIRGh0Ym1aVXJtV0Vrb3FCUlg3S3lsRU8zMTJyRlp3bzJPQjdtMGYwQjNV?=
 =?utf-8?B?dUNuaWo1NGVTeFBvVms1cnZMWUpadlZnVWxFMm9FdFg4ME5XZXV5VGFWWkRN?=
 =?utf-8?B?M0RNMUFrWUNPa2N2VlU0V21GNktRNStoSEFZMFhqU0p3NWJKbngvQW5nNHB4?=
 =?utf-8?B?T2hiVnBXSkI0QVpaVXE4WmxoWlVYWTE4THdHMUV4cm5MVnNlcjlDYWIxLzdD?=
 =?utf-8?B?TGs2cGg4czJRVjM1b3lhZWVZMHZMSHk4SDZZMjkwSVJuZ0hNdGtZQ0FXc1M4?=
 =?utf-8?B?OW52Z3RJemR1akg4cWl0ekIzZjZYa0g4Ukx5VHRESWY1dm9rN2l2SVI1NnFl?=
 =?utf-8?B?MUZ4TU1kdDViWDNWcENsNGpBaTROd2g5VjZJYlFwRzFXZ2V1M0c2cG9pRkhi?=
 =?utf-8?B?Q2hqeUw3dFRmRW5iYXdjTlBoWk8vNC9taXc5azhSc0dnTkZhZ1ViOXZZMmR2?=
 =?utf-8?B?ZVJodzVGL3poSUZMWE4rdjRIeXhPMHZwRldhZlZMcmtXODZTOTFQclNNVjR5?=
 =?utf-8?B?UDN6eVBvV0p5UGxtN1hpVzI5dG8vSmNWZC96QkNRU2RMbGt4QnBUZXFIVUhv?=
 =?utf-8?B?VVQvTmcvb1N0MGN4YzkwL0VoRUpsZkpUTVRoS3Y3YVFBbkpvUnVlcW90dUdu?=
 =?utf-8?B?aENkWmIxdUY4eE16NW9Yd1B5MzhYZHhyc3hOeTNJcDhJYmtEZm13bHZIeWkw?=
 =?utf-8?B?aXV3QmRLTG9haDdta0crSStYWmdtWXRiNmVMd2RlTlJUYkNXSjVqalB0NU1W?=
 =?utf-8?B?TFNSY3NFVStIdkZyRVI1OW5jeGxQYUR5OGQ2SFJWb3pCYWtvbi9Ec0l5V2d4?=
 =?utf-8?B?MjNmT1gyOGJncnpTbFRnWGpvWGZUa0l3eDNMRVRkQm1hT1ZVK2MzTnIrVUFm?=
 =?utf-8?B?TjIzNjJXTWsvNXF2WkJKYldhYmVQL0tlQUZDK2Y3Z25ucERpUlgyNVQyZjND?=
 =?utf-8?B?NlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cDA3ZGRjeGpQUitaZWtoMFQwTjM0R05JdjVQSVFYV3BJenlldk82TENxY25z?=
 =?utf-8?B?OVNiNEJ5MlpxV3p4aDdlaFlDMFFyb1JtMTVCcENIckRXcDJoUXlTcERKSGs4?=
 =?utf-8?B?QWMwQ0Y0Y3BqMFJ2Z1VDUUpiVitpc3dJbGY2QUFDc0hucFZsdWNPVE02N0Fw?=
 =?utf-8?B?TXNVa1FKZnVqTVQycDU4akZsQ0o1RUpyN0lBZFZkYkJYQlpKYU5EVDMxbDZu?=
 =?utf-8?B?LzRaU0FHWVVtNTdFWWt4Y0RxZDZJT0ZNbFJmUzF1ZC9MeUNpSyszNlE5eStF?=
 =?utf-8?B?YVIzcGp0akFaa2ZnRnlFallpakZqcGtWRDVvTjhoOTZoWW8wQk5GSlVNSUxw?=
 =?utf-8?B?QWZIc1NCcHdwQ3Z5S0p6QWlscjVFQW5YYkQ4dWlpYzg3dUdvNVFrYy96Z3cw?=
 =?utf-8?B?ZTczTmNQWnN3cWxtSjN1TXNRMU1YM2VUOGxrMmdubGRjZzd5cDI1bVlNNGdy?=
 =?utf-8?B?VjluYTNCd3A2RWozK1JQSkNyVENBWHNLWU1VT2FWTEhkUmNGNjlQRW1aRzFN?=
 =?utf-8?B?UWhzVUNZeHpxSGJsNUhsS2JVSDlHSU9vVFdjai9iR2xtNmpVcWVhSHNITDJE?=
 =?utf-8?B?WjRZWDc3UlAzWkpTb2t3RjZ1VGZndmdMRWZLeHhaTElZT29QaFBHaEpsZGhV?=
 =?utf-8?B?S1FtVjAwREw1VTl1T1ppaDJLOUdZdloxc1l5RFEyNDVTV1Y1RzlsT1NhOFNo?=
 =?utf-8?B?dG02ZWZya0E3UytyZktDTFZ4bk5JNklXbENpaXorTlJDYmZISG9KTHFEWlFu?=
 =?utf-8?B?dGtCRFRtc1l5c0hUaXFxVHduWE44WUhtcGVob29Sdy9UeUZ5NVJtN3ZWLy9p?=
 =?utf-8?B?TysxMHVKSnBGa0NzNUZFb1pyMFh0eXRyOFVvM256VTB2Qk0ycGdITjByMnlz?=
 =?utf-8?B?d0QzdU1USlFOeUsrK0hvRHRRZkpXVXRLQVhSaTRPY08wRWl1R0xlRG5Pbitm?=
 =?utf-8?B?RURmbVI2aHV2bko5L3cyNnVOZTBiQmJXVTNWNlp4K3Fyc2VhMjc3eGgvVVFm?=
 =?utf-8?B?M1F0bml3OXV4Mm8vb1dvRUZTcUlObFZPR0Z3VzFNTW1KOVY0bDVDN1M1dFJm?=
 =?utf-8?B?d0R2ME1rbll2VmRXTFNKazNXYXltdXpJTmxwblM2b1FIa0ltVk4yYzNzUEgy?=
 =?utf-8?B?WTJBMXBJT1BjRlliTlZzSmpaUUxYMFUyYXUvRmN1NlBWNUFBbFEwSzJlYUZ6?=
 =?utf-8?B?N01DajAyNFRpN0NVSEpRYjhIa05WZHRzV3lWYytyaHZtK0F6dXNaeXRuZ2ZP?=
 =?utf-8?B?dUNET09RSHNjZFB2L1lRWVhqSDd2Zi9icVZKWVYwSFVvUlFDay9MZk4xWjB3?=
 =?utf-8?B?ZEVMdDczdEpxUnI0OUtqNDZ6RFVISDF2WVplSmhYNTBhVFVZQnpudHRxcW94?=
 =?utf-8?B?QkFsRGZJTjB1Qk5lMllyMVV2QUdjbi85c1h5YWZrd1Y0NzV5WTVTYUdoSndi?=
 =?utf-8?B?RFgraUppVnlsY21EUFg1SzZFVHZQOTRURERObFJYRVg1RmtlSmxkMHhGTkQv?=
 =?utf-8?Q?R7l9O2Li+RH/nKFdlyA7/h04tpm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0890300a-ba5d-4edc-0dd5-08db1e670e09
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 17:20:17.0714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wMsZShp5jT5HHmtXYt1mYoCkGirHsxAiEFUmIpGrVLApKp0jAeyRynAqwj+2hJzt+OjjiUas9T9QEE2h3l6CeStuYyv/O3GvbCARMYzwjVM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6489
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_10,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303060153
X-Proofpoint-GUID: cjgMc_LPR4RX82zO38-gnGBqWcliQF5c
X-Proofpoint-ORIG-GUID: cjgMc_LPR4RX82zO38-gnGBqWcliQF5c
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/3/23 6:30 PM, Bart Van Assche wrote:
> Make it explicit that the SCSI host template is not modified.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/infiniband/ulp/iser/iscsi_iser.c | 4 ++--
>  drivers/scsi/be2iscsi/be_main.c          | 2 +-
>  drivers/scsi/bnx2i/bnx2i_iscsi.c         | 4 ++--
>  drivers/scsi/cxgbi/cxgb3i/cxgb3i.c       | 2 +-
>  drivers/scsi/cxgbi/libcxgbi.c            | 2 +-
>  drivers/scsi/cxgbi/libcxgbi.h            | 2 +-
>  drivers/scsi/isci/init.c                 | 2 +-
>  drivers/scsi/iscsi_tcp.c                 | 4 ++--
>  drivers/scsi/libiscsi.c                  | 2 +-
>  drivers/scsi/qedi/qedi_gbl.h             | 2 +-
>  drivers/scsi/qedi/qedi_iscsi.c           | 2 +-
>  include/scsi/libiscsi.h                  | 2 +-

iscsi parts look ok. The isci driver is actually sas and it also looked ok.

Reviewed-by: Mike Christie <michael.christie@oracle.com>

