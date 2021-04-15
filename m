Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F40C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 23:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC24E610FA
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 23:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236421AbhDOXcP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 19:32:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52872 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235216AbhDOXcP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 19:32:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13FNU6Yd073464;
        Thu, 15 Apr 2021 23:31:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=2j0t+o9I3k6+c0ENa1GNH9YL2gtN4Ya+RR5qnp9gueQ=;
 b=Vm5gPG8rlZtZN47n9rZQa8FbDX0WcLDH7E8SmHIlYnfs3+aUbvqSenl7KLNpTdpKw8ul
 mBH7Oxgc9EGSiQCGCIN3KNZogCwMGz6HMd8fD6SMSZpGNRUtdo1eJ4cGrJa8BFBaw9Lr
 8vWgZNE2ljm+3bfLRflGxYOiheFjiP5IHtP0SffDOwS+YSMvnPu3ELYy+O3on1I1V3Lj
 n6UC6SWevYJb16Jg7QroCLnTbtSjaHbucAaEHpiT/ntmcolyNPqzKtjD5xtwpg8HQi4D
 n4E8/Zj2hnWbKspsy2sKHNyt7Yfx3EY4Z51Bcn4NWuQTaOF8deMEL7g6oHqK6aAX5CGe ZQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37u3erqh6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 23:31:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13FNUcv7141844;
        Thu, 15 Apr 2021 23:31:40 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2050.outbound.protection.outlook.com [104.47.36.50])
        by aserp3030.oracle.com with ESMTP id 37unktavrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 23:31:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=es7kXTeMt/aRSqNY9UJAeI62P7IuhVty6XMCPcRklWMetK5dg7+Iy39DOH83qleSFZUa40c9CHvm8Zb82lqfahlg3YrrUwzhjqPAZa4yZtrsWqwf53rxNaJAtdaWa32pRfjX2S1OtLtvaJFCZO8xaBL/Cf58NCzGbA+w67dUt82oeat+OPfCLBW+/74Q4xSOEyx3rlA26S+y+oRSgZaykqmzvwCPjkQKF+lpHwmIDHbseYyzRhDPmKaQxiF8fjMS4fKT5n3GE5WIQs6bY10Y/B3wXc9Q7iIZKlDTWAsvIOKR+jpdEK8X/QSrWbVmktzrtPD+Ddt0yxi0R8SsgXuiRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2j0t+o9I3k6+c0ENa1GNH9YL2gtN4Ya+RR5qnp9gueQ=;
 b=JzwIB6MfegisOY/BbH9XFv2KiADkJ2EIYP/ormA5FORVngR4RgTCb5sOsyzD+07yAArglyHWa5j+KzwoP2CaWjkDI80TE/zGOY5pG5wYerXaX0YZ/ddUbwCOs0Fe2Hh28nUVmZWV3goYf0cUyPkKbIp77YClvmoe14DZSvborGcwgYqZN7PxHfQma9eG55rOexR//V5JmnH2IicaB8JGZzd1skzT6Vy+J91qcpMlie0nBrSIIuAHJUy3zoHsuBRJwZqN74beLFcNFnzMXig5IPpwf8f49olSKc3Op4hIYwVUsVG4pxwKXlzaqH0QpJ1DmeuVho9STuU9DxYHe6guLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2j0t+o9I3k6+c0ENa1GNH9YL2gtN4Ya+RR5qnp9gueQ=;
 b=ChxCbkWJZuo6a0gl/0wrhfv+in0VmyPVZfSZLI5LZto1W1Fy+c6xuO9dTl+ZbXhQly2Z+vmjBNTb/FZDYRXNJ4lllffc/zQb30pFxRYzpiJHa+2BDq/W04jVY6JkD+C5T8JAYAB8A7pMGVaD5Knb9QIG/KvLttveReqDiXaM5Cc=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3578.namprd10.prod.outlook.com (2603:10b6:5:179::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Thu, 15 Apr
 2021 23:31:39 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5dea:9ca5:fde6:537f]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5dea:9ca5:fde6:537f%3]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 23:31:39 +0000
Subject: Re: [PATCH v2 18/20] target: Fix two format specifiers
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20210415220826.29438-1-bvanassche@acm.org>
 <20210415220826.29438-19-bvanassche@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <6e2f2761-968d-b423-432e-76834121bdd2@oracle.com>
Date:   Thu, 15 Apr 2021 18:31:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210415220826.29438-19-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR11CA0005.namprd11.prod.outlook.com
 (2603:10b6:3:115::15) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM5PR11CA0005.namprd11.prod.outlook.com (2603:10b6:3:115::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 23:31:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33625e55-5b58-4d0f-8e39-08d900669e26
X-MS-TrafficTypeDiagnostic: DM6PR10MB3578:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3578BA5204230C9B986441F8F14D9@DM6PR10MB3578.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:431;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y+0gkJn/CQLEy28liHT3nmCbTq3f2oL33YYV/U5UOCtNa+dAvpUl5VqHYALmCRP2geyr2quuHIYLiFOKBZIcBK0mopcA8Qxd1BpXIaj8H/zmFk1tpel+fCEsEhwBmkPutAD4m3mNgEkFHiGEyq7nSV7WZ+8RUldGrii+52HCY8HJjithaAONFHj63Pb2fLaW9MzVNOl3bUKNyOKzybYxfM2IPuFdHfzbMmFqGsIiJ2VbpzJTjbSnjRoE911MsP/niXnXRX8g9oqKg18fOCQY5aaRUItSrSxxCeQ2p8l9bRu6XTNYbMIKn+b9rlg3sRmEyVs9Dns23rRYNwNdJ8inZPLAqGRGbqhfGXAF0lHXzSe70xnyAFlqXVZYDzm63gjUnxdxcR6Iw/Lr+++9zq0ai1v28F/dKta7nlUWdijeHMxSgNUoolhgVMts3/ZaKeLzd1JNvElY4rWa4lQTs3+eCw7FlklwbEKb9mHSprQUJv19akYCh6b4FBTbWKTtrBWCefmYeOfNFZaE1P5nQCPr3wQO+l2919n2eE2026L7ZIbNoX8A524pRCARdQa2JiuVlJN80fZS3pfQUFA/r0zxdG9N6mc+VNJJQ8k7uFukoNjQBN5JfI6EpirLKyyHNhiarOBXLcPOD1ThDFHa2YvTbqsXXc20gyzxawb5Wwjpr4xdEX2uUQr6zSM++F943MownHLUfzwOjkgec+gJkAlgeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31686004)(66946007)(6486002)(8676002)(558084003)(38100700002)(8936002)(53546011)(66476007)(66556008)(86362001)(5660300002)(110136005)(6706004)(31696002)(4326008)(36756003)(956004)(16526019)(16576012)(186003)(2616005)(2906002)(498600001)(26005)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RHBNOURkOStOZHo1SU5IVjhuTkY3d0cwUENBZThuRVNJaXovc2UycVBKaGgv?=
 =?utf-8?B?V0ZERXZrNmJyWEZ3UG5sV0VMdkZxSE40V1kyZTU2Qm5zQm5vWGFWRTNpbW9Z?=
 =?utf-8?B?QUFqZTBLdHZseEllUGF1YjJUcHFhejhKMFFDV25GOHRaK2ZDRzE2T1JqODVO?=
 =?utf-8?B?SWp3ZlpQSXNQMWVNdmtRNHNvY0pieUdwbVNPODVUcUt2bzNWU1JSSkpHRDdt?=
 =?utf-8?B?NnJGYXZieE1zTWVMY0NYWS9uRG9KUEg2WVJPMENwVkFHcW9DeGNWbjE5dnEy?=
 =?utf-8?B?K0ljYWVYalp0ZnpDYlExR3laK2RwVkxMN2pXaXAxanJSeUYwOXZKTGxtZjNI?=
 =?utf-8?B?SE5RN1lZMURXbHRJVmxFdlFtNll4bmFDSTZCQ3RCekV3bmZKdDBPTEdFaFhx?=
 =?utf-8?B?NDVNazZOQ3dRT2NyczFQd0RvV2hyWEdzN1RrQzZIdGUxbTl0Z29oL0lEazBp?=
 =?utf-8?B?OStWaGV2eFp2T0ZmQ3dpUnFjQWEvQTcvTDc5ZGx4bVNYMjd4aXpUeTg1dkVr?=
 =?utf-8?B?bXJObExrUTEvRjNuVHR2Y2ZDNmYySnNDbkdzek5wcHNSMUx6TFVqMWVRM3FV?=
 =?utf-8?B?MDZITHUzNFNXaVBVV05qbEJxRVVpQitvaUhmTWNFOFRCMzhTOVlIQ3BrdWpW?=
 =?utf-8?B?djBzVldiNXlDSXdZdGN0SGpQeFdJM0phdS85dXB3U1JKaXplWlovVHZKekox?=
 =?utf-8?B?VEdBY1E1MHFkL1FMWExRaVZnUUVNbDQ0TU0yTWpIMlpxY3pCcGZ0bjhaWmJv?=
 =?utf-8?B?aytiN3UxbEpPOWJyNjJsaTZVaUZrYzR2WG9ZY1dOWnp1bE5GQzFxc1RQZk5B?=
 =?utf-8?B?bHAxZEIvTGxEai96M2xDZ1Z2L2JOdlhEVlBOTGtWK281WXlaK1B6UTN5bVZ4?=
 =?utf-8?B?aFhyM0lUVDlRa2ltRElFdEZGaC9NQm43UmhYcWlGTnRTbWpmYnh2VFFiNkxQ?=
 =?utf-8?B?d05BVDRwZFJsZFNVbVp2a1VzVFhRZW1la1dicFdHRWFZcDRyeUVLYUVtL1Zm?=
 =?utf-8?B?RERFdFhieDIyeXRyVStOK1FHVEh3akFDRmdod2REa2lpKzdmL25PSUw0Vks1?=
 =?utf-8?B?N24yNGE4S2FRb21ySjJWYjYyb0hObjBCcW1oYStwWnlKSDJ0QzdLUmFoNkJq?=
 =?utf-8?B?djFzOThCa3FadGx2L01FcUxmdDJMMTUvcW0zZEYzL3FrcnliYWNtclBVbDgr?=
 =?utf-8?B?Q1grTHVzZ3graHZSOHg2Ty9tRlhBYjgrREhueEh0SzVWUFBtODRLZVVpWnRk?=
 =?utf-8?B?NUFudFVTQ3NnVi90UkRVN2tkSVpZcVJMenQvd05NWWdSK3JGL0tZdU9vbE0y?=
 =?utf-8?B?ckNxWVNSQzBsRVRQeENOWE9QSFhXMkNrMUNCRkVQSUVncDNMdElyU3ZHUnJm?=
 =?utf-8?B?TWpONE9Bd1U5c1ZGSUJLd3YzVXhWV2lQT0w3SmJJOTl4ZmFKUHJUTzdZMk9i?=
 =?utf-8?B?NkFpdWVQYlF4clFzWWcvc1lMOWNzWTlGTXRKT3QxdlVFbUtWeGVqZzlERHpL?=
 =?utf-8?B?VWNITlFoVm13MUNvc3JGc3RKNGtUbjdyRjVMU2JpWnVMYXJhRkJhcHVLbXhL?=
 =?utf-8?B?Yk5SK0NIZ0w0NXlTRW5EckpibUhPQlVhQ2RVYitCckRibUM1SXN2UzIxTzdS?=
 =?utf-8?B?alQ3VGFoSkQxeUsrZmRqNTJDMWFCZ0hycVBRQmtXQmlqR0RnOVNYWnNFVE9n?=
 =?utf-8?B?YkNJYjlKamFSbEpnS1FzbmJQNjJnemF1YWZZODVjekpXdlluZU5SeTBULzBU?=
 =?utf-8?Q?Rc5ot5gTH0X6ylrOZYkfeRvdM/x+ftlo8zvsaDe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33625e55-5b58-4d0f-8e39-08d900669e26
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 23:31:39.0876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HokZzTJCCh7eLSQ4S5OAqgAG9PKyADYaH4Ycgkt6g9GfNr2/RXktxP6Kisk0tWkS+G7bR5NpVaUVVooMWMCygMxCA8cPIHmBytCN0h+wFIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3578
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104150146
X-Proofpoint-ORIG-GUID: YunjFHvVUEWG_kacPWQxumneVeCWq9UB
X-Proofpoint-GUID: YunjFHvVUEWG_kacPWQxumneVeCWq9UB
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104150146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/21 5:08 PM, Bart Van Assche wrote:
> Use format specifier '%u' to format the u32 data type instead of '%hu'.
> 
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>

Looks ok to me.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
