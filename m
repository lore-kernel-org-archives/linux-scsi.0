Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F190C07E95
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74ACE61374
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237311AbhGNBY6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:24:58 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50746 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237244AbhGNBY6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Jul 2021 21:24:58 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E1GuhA016962;
        Wed, 14 Jul 2021 01:21:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=mkn2wN7Z5+9fyCbrBsRUCwANfY6ujrGH/GHRBU5AOaI=;
 b=cyUuOa4yBzYUdRPiFk3ZovbwA0/zFVeu5HeMWscit/0ogDsG+9RgtjB/uWUz4hXoE7ex
 uXSt/hPBW4A9LGLCjfDM4vJS/H1pcwSTZ/IJtuI1rnf9zJ6+hO+I4Hf8uOaxUjjk3Sjz
 FFtZh/3yqdeSv+RPBvY5yroBJ9a3FYr/lc0dUPwSbJ0PvKAL3dkLnvR+HBZZZPT1LhvY
 hVXKGaaL1PxaJO4DndTQmbS9prUbB4WL96D9QODJ2ZiOjcYWmZH3hdZEpW2kOzIpMfwN
 jKwNXlElamI4yIsot3ur7XteolmyrGjqsrd9V4pOyJgbRKsgBNhDt1clCtkxeQBjoeqz 3A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rpd8uvbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:21:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16E1FBmu001269;
        Wed, 14 Jul 2021 01:21:53 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2049.outbound.protection.outlook.com [104.47.74.49])
        by aserp3030.oracle.com with ESMTP id 39qycxthsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:21:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFz78D4FqOnja4uFH2VowrZMDboktKoPNjYUvqior22E+ovHMU0hd8P9xrAd5qERRI0xrabYiOTxqAYklo+qBHTIbgxrVMakljFLzYOiPvUO1rTY3fjV2kwas2c/m7Z8zDF46e4VQocJ02Lj//lJ+ahF08ZGEP5P3lNI7remAsyQNxSQ2rjLvkq+XuUNcbxk31314N3/cl4DQqLoMWWaSZUCrvQ3n0EfEwSl0KI/k5uKsQaUhGXzBvVCjw55tVrDDUjBw8UjHw2QuhBdet56bgrXj89Ximte5d29dpnvuPzSpxpY9lauNxngMrJD9/hu7WglxGm/Vu7qcxQfbHcD/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkn2wN7Z5+9fyCbrBsRUCwANfY6ujrGH/GHRBU5AOaI=;
 b=DEj2yfOOxA2VJVXEpA94ej+DQKC7il2LRMfAmB/mHbT8LwnRZKMaIO6defEzb2jfTSjobCPTYxPwvsOSdLrwDMl2C24LyqX6Nnjobc+JPO1CfSXNuXAJKaaO3TcGjp9uKF6qCQA51+hm9nrJWokkTtA+vuzO49rkBBDLn5uQrV+w+I4lgEPhiIjig3tsucBkVWUyu5KSyeTCnlxgp3G1mGVlz+wetT0VeEcNZ2R/TdEOHjxNvid6cbIsSeLzRmJPQmkMCR3hQQo/B98qeJJo8zn83d8OPkcHzai+KA8zyOe+inSGHVb5huJ2MU3lCmZpso3D3bBphGCsIylvCkzaZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkn2wN7Z5+9fyCbrBsRUCwANfY6ujrGH/GHRBU5AOaI=;
 b=oZxtphsoM8D8MHgR7Km2eMZ9mKiaBlQfJ2rreQiQPT4bzHrqFyWMBXRotF8j5Id6LXvHkOgu/MCNuYdSr2P4pLu6R18F4KjTAktVlBdzNIpmiylQMX5tY8knMqRIUp1sQD265kecTqUU69aMXgwsgeZEq8IyaHR5jnbi8358JAU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by MWHPR1001MB2349.namprd10.prod.outlook.com (2603:10b6:301:30::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.26; Wed, 14 Jul
 2021 01:21:47 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f%3]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 01:21:47 +0000
Subject: Re: [smartpqi updates V2 PATCH 6/9] smartpqi: add PCI-ID for new
 ntcom controller
To:     Don Brace <don.brace@microchip.com>, hch@infradead.org,
        martin.peterson@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Cc:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        balsundar.p@microchip.com, joseph.szczypek@hpe.com,
        jeff@canonical.com, POSWALD@suse.com, mwilck@suse.com,
        pmenzel@molgen.mpg.de, linux-kernel@vger.kernel.org
References: <20210713210243.40594-1-don.brace@microchip.com>
 <20210713210243.40594-7-don.brace@microchip.com>
From:   John Donnelly <john.p.donnelly@oracle.com>
Message-ID: <ce1ed33b-f374-5ace-48ff-3824ef8df94f@oracle.com>
Date:   Tue, 13 Jul 2021 20:21:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210713210243.40594-7-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::11) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.106] (47.220.66.60) by DS7PR05CA0006.namprd05.prod.outlook.com (2603:10b6:5:3b9::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.11 via Frontend Transport; Wed, 14 Jul 2021 01:21:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29b84595-5cc6-4797-e60f-08d94665bfbd
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2349:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB234990FFE250C610DE61AAAEC7139@MWHPR1001MB2349.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hekqsjvkCNiwBRFlGebMsQLZweCj80+2b30MeetvFkvha1P/qHLfdhTOgzcnp3vhwbB84o8+/Lqdkd7mcfidINPw4SrK9fR1QVgpvSaEHx3R6YQbIFke121HiaiZA9IY8iUn3C1GeYsTnwUs3+J6TcpJkN5LwdZ3egqc4tL3y33G2wtonLq1Jb/24auDnkKp3FIb+UIKk9WH6k4i/CM7Dc1TrZOfT3q2Ly9wbBfcEv6mwvJBZBvb7o+nWQW/qNw6zkYkIjtul14fb3WT1+24SWwylCXqpv3sBBBnuSP7SdHcC4xASQXG9HJqOoB71J/9WoSi7mZUdSBWA/9PdWf3I9m86dtzSAjOdpBCqnalEVPWusLHhg+jQ8th1kzqaznv6iy4yn8n/tRSF9xFktq2FmGybPS6b9r9eAMP8g9UZOjJLLg7HM6LSb0udMcpBppbIXgE0yepdkPPDtrLvCQHTLfZyzZexYH/uG973TXbm0z/wLabTnDcoEB1d3JAft+P53f3GSMp8ZyQ1gT2gOpMF0R7nIlmqOTXapSJIQOq9vEm4D119WmrnWbPD6lodLEyXjScteRZrnvOU/zx3ZoFMM7DibanP8xBesRPNJsvpIJkO3lMXpIUvmX9gRzOAalQst5VX/P6Zfk8KHyYyNX0UDpaIutRHmO7JUMWxffANyqY110ITHdk1+bW14ZjBy11Sv1yhL4n3D4Brt6loVRoc5O59K1mpm+6TbvWni4AYfw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(39860400002)(346002)(4326008)(478600001)(86362001)(186003)(31686004)(5660300002)(316002)(16576012)(6486002)(26005)(38100700002)(7416002)(2616005)(66556008)(956004)(2906002)(66476007)(66946007)(53546011)(8676002)(36756003)(8936002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ek04TmhVMkJLNUt5Qi9OZzA4R0NpRlNwNXZhVVlqWTNIZEZyTGkrdFdXaldY?=
 =?utf-8?B?WE5IRzN0NFc2SVFqZkZyZTFWRUFib3hjQjBNQ1IvUlNpZ2htemFmVnR1eVhr?=
 =?utf-8?B?Mk1FT3F6Vk9QVWxPWFJmLzU5NUUzT2puRE9PYXRtVTVVVmo1WUVpSzlrMHov?=
 =?utf-8?B?OS8wTVJGbXBZUlFrZkYrOTVTUjgzTlNUV0x2Q0NyWFVVbnpQWHFCeGJRc2Fo?=
 =?utf-8?B?dERYekIzKzZUREFVaVZ5Q0Jmc2ZyRXY3Qi9iOTVnZFJGNXpPZHFKcCt2Uk9x?=
 =?utf-8?B?UTJQTlI2azVjekVDNUc4TEVvWXdBbE9qZjBFZXZGOVdiclAvY0xOTG9iaklL?=
 =?utf-8?B?OE9YYTJLM0ZkSHJ4K3BEYnpLajRKZHg2RE9wY0tXVDdaaW1PUXpwV0NLaHBh?=
 =?utf-8?B?bll3NHN2NUFHZGFQU1lMTGQ2L2JYcDBGODNOZzdXS3FDTFJSQW51ZWorTk9W?=
 =?utf-8?B?RzVEVG43bWUyd2dYelh0Zmtsbk1YVUJEMlBlMWhjeGtLTldFUnJRczhsYnVC?=
 =?utf-8?B?ZVpaRGtqcWVadHpya1hOTXBTNFhNM2dwMlBhR2s3dGVZalc4SXpNT2RRalJn?=
 =?utf-8?B?STJzS1pvYXpQYStTTWpZQ2xpQVJneENMdXMrS3RRSEYrS2sya1Vzbms1cWEz?=
 =?utf-8?B?dXcrd2NSNXFNVnNDOEd5elpGUXlmZk5KUGh0SUpGNTdpenJUKzFVZnhoQ3JN?=
 =?utf-8?B?SnU2eW1lcjUyaWRoNEk3S1VXVVZaTk93cmtCN2E0Rm1YcWh6a2ZSZGtHRGh0?=
 =?utf-8?B?MFBwTkg1d0ErVysyZFFuODArOCtZVkdWbGRjY2lsREhnOUpXcmIyS2ZoaVEr?=
 =?utf-8?B?dzlabE1DRWxYbjBkZlppdXZUS1NkRjNZcHROR0Z2TUNUbDI3c014MXBGZUZo?=
 =?utf-8?B?a1VFZ1AxWkJ6TUY3QXFZSGdaQlltbHNNRTI4aCtEN1ZzeHBqN1k3NWJmN0lu?=
 =?utf-8?B?QXNVbjFXUWxpSEV2bFo2Z0tId2RkR0cyQUVOQyttZzZtai9FK2hFc1JURFUw?=
 =?utf-8?B?cDZjY2tINjJibTdNMktZWEpHVzVFN2FocGZ6TEFwMThPMGw5a01KTjFSN3F0?=
 =?utf-8?B?RFA4c3BENG4yY0xqNmhST1p3WWgzRWdodU9hQ3dxb0U5bnZUMTZzb1VjS3dM?=
 =?utf-8?B?dGRiQitneGtHQ3EvUVlrNFpvTVRCSWpHRnpFRnlWMmhSeGxNUHZidnZlS1Av?=
 =?utf-8?B?cTR1QW1OWnZJSHNydXAwWGUzaS9URDc1UkF3Q0k4TlhCVE5uTUxkRkhmUks1?=
 =?utf-8?B?YWZ0ckdKQVluZGVzMm1oRjhQWnZjUnhQdDJ4b2hHWG5USDQ0SWFKcDBaYUNr?=
 =?utf-8?B?d0lGbldodzBjRHhPTXN3Nm5sZ2ErUkpMV2c5ME9wN090a2hXdm1DQVdMYVN1?=
 =?utf-8?B?MjVPWWR6ZmwvNEk3cjN0M1FnSEkwbVB3bllsQjJkbldVY0JjamFxR1o4Q0tV?=
 =?utf-8?B?emh5YUE2NVBLS0h3Vkt0R1FXQzRLL0lyS01CQ1RVUCtWeUE1WG42UmZMMjdj?=
 =?utf-8?B?bG0rVEh5Qkhrbm41V0lpY3B2SW5UY1JwK1NBbG4xTWsvVjRxZmN4MWJBTkxh?=
 =?utf-8?B?eFVKRDJYcnU0VSs5NDZrbVVCN3FLMzlLc2FIZmFBQ1J1VlV3RFRUL2pYd0hk?=
 =?utf-8?B?S1hBdW1ZQ0Q3bThtN2lpakZoVVlIT2hRWS9PTG9OY1pMdXJ5dDJtRG5DQ3Fn?=
 =?utf-8?B?dmp6UjZzT1c4L0loTlVENllUeUtESWViYjUxZUtMT3FFWVpXbW4zdHRoOWl6?=
 =?utf-8?Q?UGIvge/K2YjQvqciDOA5oZt7YiMV+sQhHwTfSH1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29b84595-5cc6-4797-e60f-08d94665bfbd
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 01:21:47.4181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KaFZwyGWxsP/6my4VitvLu2oxv3U9lvEXuLd2QE1V2E+4/JXRsgW2eFcPNU8fyzbBhWrRIJu5PLFjX1fWH3qNWGonQjXuLVOnOm9VyhtPzw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2349
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140004
X-Proofpoint-GUID: cvrR3FPRSYwQi-YyCLA2n5PqNeDfb3mj
X-Proofpoint-ORIG-GUID: cvrR3FPRSYwQi-YyCLA2n5PqNeDfb3mj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/21 4:02 PM, Don Brace wrote:
> From: Mike McGowen <mike.mcgowen@microchip.com>
> 
> Add support for Norsi ntcom Raid-24i controller
> VID_0x9005, DID_0x028f, SVID_0x1dfc, SDID_0x3161
> 
> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>


Acked-by:  John Donnelly <john.p.donnelly@oracle.com>


> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index ffc7ca221e27..c0b181ba795c 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -9181,6 +9181,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
>   		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
>   			       PCI_VENDOR_ID_GIGABYTE, 0x1000)
>   	},
> +	{
> +		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
> +			       0x1dfc, 0x3161)
> +	},
>   	{
>   		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
>   			       PCI_ANY_ID, PCI_ANY_ID)
> 

