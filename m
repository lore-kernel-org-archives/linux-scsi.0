Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A87EC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D907C6103D
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhJLUhk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 16:37:40 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46682 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229771AbhJLUhh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 16:37:37 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CJjn9L016788;
        Tue, 12 Oct 2021 20:35:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=PZJ8p4zd4LlLGbtWFOtySXJqC6AgUS+TX2renGbBDpQ=;
 b=jmKDfamxvHrr89Dsu71Us6x2b2lzjBkUGjc992n1/rd221483/Dru2oettIiAcvwihpP
 Hl5f0iFVRn5mGv8CM9nwdWRFweKE4c69MXxoPIl/9GNDl+zmKkT+8C7JPXEgZ450tEEc
 /MnFOJTFSeeCtiVjILAmd0mxX37+TdyjLOz9ws3ZEsv9KWIzX/a3ls1k2hcKxyrQ++q2
 91q00X+1A37txr63APGemWN4IszT2KpBbr/JV4p36GjWEZu7akTSt/WUFgNZZA3Tux+D
 QLmSNXohZU6DTQc0fuoBWuD4wYibl83TZocY+S5yNpHxAVIPYv41qC9dNKEFoR/BrfVI Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmtmk9gmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CKZ78d009550;
        Tue, 12 Oct 2021 20:35:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3030.oracle.com with ESMTP id 3bkyv9jpxv-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QmBsU8hlcUSLtPd2h7XuWrHXqYRSNpMbOIVoNZwLRj2T9k4AlGXAuPn0yvoOvT9B+7VveL6KDd/zaYaAlsI/uEgOz2WcDd2pQAbmThhATaQIrdnSXtdI0iXVRvt1RTTazy3OnhFNnt6r333Mu+hRjYd4UdmLSdHccAeacAbGtUTJnTPSspdnq+L12kkL+wsk7HWN/owK9nu9aiqtZ0Bf2cfWyo9SCSZ6HUHBaYooxIVLBt/0Nymm4vauQm7fI2GApYohhpUSKO2bEZlm4ZBwNSEuXE49cJviBht9LdURC2CPPn+X20/uidl4t0c/4Nhiy0EO95S72iC3iicmeWG78A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PZJ8p4zd4LlLGbtWFOtySXJqC6AgUS+TX2renGbBDpQ=;
 b=dJA/L+hZBEuQcN7QlSprgVEkWpkY5wphFjmmrmjc16dCO8ZHekPf2hyh/DGqtsAyV0GPREMesY8nMdvYlMLp7qK4ZqTx9da7B4el2jXsA623nag8u52NbO7mjIiruCxpwsPISNoxaYjviT2r80QYdM4mYgxM3XaJEtXYEs5wHYkIBDCE5ox8prE0wSRDSAwFI8xLcPveewRMH9YnotHZUWQFahAU2uff36ZqRSYbzIUo4ivoLgmN79jhqO1ElAesi7z3F5UpHljA/tmFFVuVWjxqf3ebcin7Wb4RAIaEcjA9C79Ofka++XCoZawWLzfbnpx9kitt5vzps7Ijizfaww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZJ8p4zd4LlLGbtWFOtySXJqC6AgUS+TX2renGbBDpQ=;
 b=gwVDQt75b/tmU2dPvifSwdbA5J7hb+OLB7XUh5U5qbZ1qF0EbYW/qOP0YJ6vWVSgp2Famh5DRgYYzjyx0BCZ4jxuRbbXu0ofcDyJ37342uj1joSxdJSE1rxcfSv5/j8XTD4q0pdSAb9ptfgXY5N+I680AVapCRgVPM9CpHLZEDg=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5514.namprd10.prod.outlook.com (2603:10b6:510:106::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 20:35:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 20:35:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH] scsi: mpi3mr: clean up mpi3mr_print_ioc_info()
Date:   Tue, 12 Oct 2021 16:35:08 -0400
Message-Id: <163407081305.28503.18198344074370197576.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210916132605.GF25094@kili>
References: <20210916132605.GF25094@kili>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0022.namprd08.prod.outlook.com
 (2603:10b6:803:29::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0801CA0022.namprd08.prod.outlook.com (2603:10b6:803:29::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Tue, 12 Oct 2021 20:35:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94a9ca61-a109-40fb-f132-08d98dbfd1e5
X-MS-TrafficTypeDiagnostic: PH0PR10MB5514:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5514A7AB32BB2CA998CA00878EB69@PH0PR10MB5514.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Td+hTp4C65gQ1KN94eiYnOHBDFmoF/W6c+0WCh0hk9nCiT19qspWU3EE9nsBO/bQnF+jkVS2vXPHlCxYDILSyX3kCDB/JCkNh+/r7QEcklusXFzeV8wLzj2hoh2O+bIU/gklkf7poC+P1tZjN7sQvO0EDT87JnRcrhrKYFRjv3V1gqi4/2ajXtOi3MsahU2ukieHOukPfeB+IV+nY1DLabQXFBzEMiiYiBnBZboKcUSu/xRPYfHUaOjN1Y3oEGSRp5ThlVVvHDVmwsqKQdcbUNnBjt3ym3+gHuaQjW1I7ecUidCI4FXQuQ6M/nkg9s/AKS5OxCOksKbN92kyxS9W76m8bFoK4OD7Qv3pJV6udtRWGTXhTt4N4Cq+nhb2cwJVG7CTT+iQuEL2uCjUk9YtknVr8sBfVH6MtRMWM3cHnZQDC55WIew2skCQ3ZB7aDur5EqD3fKEI85hYaC+yCqyWMh/5eG2nzrxiB5cn3WUpu55qJ3WhXpdQWoqJEHcA1UBqMMgq/J87JxgWBKhcjJ/GMFStETdvuu/Ead3Bepn7HoEiLP+47mvCB+ZzF1gbAaSXdl+Gpog7lh0K8W0bXo84nmTCocErbjc2l1ZEOPs6hysWsF9mrLM3tu8eNLph4GgN3VFGJClSgADDqFvxhrINMPbpBNqvFbzZlSOSUK84TTvgfojqwN1omu5GjZJU8c017vP9ZY4KBNUsCyS7CRBsbo0wIvzPN5rdSwc1aEnEgoSlh8gLzrHhORIgGkt8WUgPO7K072YtwaJG7bOoEI2+iP7RVOPk/qGuS7V/Ve7LSHmfN4sN/VyOWD51C7FnOR3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(5660300002)(6636002)(8676002)(2906002)(52116002)(66476007)(66556008)(7696005)(6666004)(956004)(66946007)(6486002)(110136005)(38100700002)(8936002)(54906003)(4326008)(36756003)(186003)(103116003)(4744005)(508600001)(26005)(2616005)(38350700002)(966005)(316002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z1BJWEp6RVh2U2ZESm9qMEgyWnMrKy9rOXlldVQwVmFwT2RjMmtHMWNiOW5z?=
 =?utf-8?B?Nm1JL3pmSFc0MGVqWkZYU2t6bHBHblpBbzVJcjFaVXI2YVkwclNZdWFTTUE3?=
 =?utf-8?B?RTEvRG1LZGljNVVrUERoUGFMcGx6SFl1NlIrOU0xYTFiUWlFYVdHckZZeFdl?=
 =?utf-8?B?NGlLaHY0V1hmM25GbWRPQlhaZFVUTW81UU9OampPRmhqSUcvQmxyVDZ5cFpY?=
 =?utf-8?B?SnhWZGkxSnJsYXZaaENZOVdySm05bk9RQ3M1Yy9uZEIxWFZmTEhhWC9rMHlv?=
 =?utf-8?B?cHR2UndNSFEwL1d6dFkramZSQkZEUGtSK3hEZUc1emkxNjJIQStRRnNucU5t?=
 =?utf-8?B?UjNKMlVpSUhLNkxla0VlNFZ6SkZQelNacTR4ZDJHZWU2NCswNDZtOGtRNHZy?=
 =?utf-8?B?Y2F4RFVZUmh4amw5ZHo3ZGhKejFuYlV5YTNYeGhrOVc2ZlJFaElUZTczaTZi?=
 =?utf-8?B?OW5xclVkblB5QllqRXBEQXhVclZzUXVpN0w1dnNUbktqei9Dd3RuRkVScC9O?=
 =?utf-8?B?d2hHUDFWQ2I1Zjg4OVNVaXJDTlBnaW9SS1VzL1YzY1dqYlg1cllnQjlqRlU1?=
 =?utf-8?B?Nyt5ZjJPOU9MT0RKZzMwY1M2dFVoY055UkxSbUp6T2d0d0hNZmo0bnBiTnk3?=
 =?utf-8?B?VTBMWWJiMnRSd1ZIVzVhUkxwNGFFZWdoVk04SU1WaHJFbnRYWlpWK1Zoa0JG?=
 =?utf-8?B?MWNkaHkzaTUrVU9XOXNGOTExTy9ndVE1aUZ5cUpoeFhkUzNJcnozUmp2bG1L?=
 =?utf-8?B?SkVLYXJJT1F0ZytwcXYxQjA3b282eFo4WW1tL3J4LzRHT1hmVjIzL1NZLzFX?=
 =?utf-8?B?QlpXVG81ZE90N2Uwbm5GVlJRMlJtbmp4WSt5OXIrTGNZUE9EdjJ4RnVPbERY?=
 =?utf-8?B?VmpzUEIxR1hFTHhxenFLa2w2NkdtWW4rZFRlaG5RSnJJbnBzZFdZN0RSajNy?=
 =?utf-8?B?RmZlSzlGWDJXZDBLc0RSbWkyNzB1WllKUGRDSlZsTGhRUkRvbTNYSUVLeWpq?=
 =?utf-8?B?YmNtRUR0VkJwQk14WHVUdklTbGtwc2FUakRaZHVRRjltVnM1U2JyUGlQcU41?=
 =?utf-8?B?OW9RM0djZnJaYm40UklmU2UwN2w2bzdWTVB3T3dOUDNEN1lUMkNIdVBXOHdG?=
 =?utf-8?B?NUM5aWkyWEtNUTg3TzJCeVRRZm00TXV1Vzlxa2pRYWlJWGkvQVpBMzg2S0Zp?=
 =?utf-8?B?eTRJQXJxNy9FQ0QwZ0ZNM1h0d0tDcjVzY2dnWmZtTHNLVU5ldkIyaW1kQkVu?=
 =?utf-8?B?b3QxR29URmJWT0EzUVZMWGRIeWVzMTZFZmNNOU91dW5uSGF0WFZoYkNCUlUv?=
 =?utf-8?B?RW5GR2c4c0NLejZvU3pwWldmWFhEUkVKL3FvZlhPdmVNN0dSNm9xaUg4L2sy?=
 =?utf-8?B?c05OTFZxZWNEYkd0Y0d4STBIRzg5U3FFU284Mm9ZV1NpQjg3dHp0M2NjcGVE?=
 =?utf-8?B?ZjFrTlp1ZCs2RS9aRi9BK2tvUDZtOGtmUlVPUXcrNitJYnFhQjJ0aGhxTlY2?=
 =?utf-8?B?QmxyTDlNOWZGb1BwMytReFd4bWxJTGFQcEsxd1ljM2lQRjR2aUJFQkl1QW9L?=
 =?utf-8?B?NllqR2M2WTRTckRQM2xLd09rOWNqQ1Z6U3hjN09hM050S08yOWJ2VE5jVXcz?=
 =?utf-8?B?aXFuZ3c3RXpNU0l2bG5BMDFqSElaN2tZNkpEdXQ0UDZ5ZzZNa2VGVU5SdmVE?=
 =?utf-8?B?SnZUM0VzREw3L2lJakthd0FnWU9hU3kreFVmMXJ3emZKMmthMFZBYXlmd3h3?=
 =?utf-8?Q?dagdHbWb4F27+M9F57eg8jXJoJ15BhcG41tLV0X?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94a9ca61-a109-40fb-f132-08d98dbfd1e5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 20:35:25.1275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gn+HSWHsswObKbrBG2KGQYIl1Uyw+SjaEQBh0KffKr+n/ZZ96esn5VwK3acJ4JnoHZmaAQzGrIavVygxNl79T4XpO9hRhFH2UO2ekg82w3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5514
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=757
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120109
X-Proofpoint-GUID: ttgg5KSH2IkI4QuRyySLL-8c_AbbC18f
X-Proofpoint-ORIG-GUID: ttgg5KSH2IkI4QuRyySLL-8c_AbbC18f
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 16 Sep 2021 16:26:05 +0300, Dan Carpenter wrote:

> This function is more complicated than necessary.
> 
> If we change from scnprintf() to snprintf() that let's us remove the
> if bytes_wrote < sizeof(protocol) checks.  Also we can use
> bytes_wrote ? "," : "" to print the comma and remove the separate
> if statement and the "is_string_nonempty" variable.
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: mpi3mr: clean up mpi3mr_print_ioc_info()
      https://git.kernel.org/mkp/scsi/c/76a4f7cc5973

-- 
Martin K. Petersen	Oracle Linux Engineering
