Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D08D3C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 18:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245628AbiFMSkF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 14:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245601AbiFMSjn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 14:39:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DB133891
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 08:34:30 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25DFGwci030196;
        Mon, 13 Jun 2022 15:34:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=5AkvTGH1vISLeuXvv2lupzAaqMqFHU51Snuk8tfD1IY=;
 b=utAoRauEU6EDgWuIZNczcsUYlFSm10j4BhSrtJFZFR9q5wyYZMdh8LG6+SmCLlLYVtf5
 BSy0Y9pbmEUOu/JyA1/1AY42+oz+wX22VUgx/INxG4IF0Km+03HDedTOhMNkoBJOsLiW
 q15+G2Syg9pXPzixpfBAOAaaNujqGkGegbqFrAnWZczk55G+j6jy0I9fgT7cNJPDW8nm
 1gnvzQxB8d0rvAdedvkbvsT1BIJ6H0adRU1dZ1GXAbL6dBeqBZL2xj/anvIVwWQeRNww
 FnWEskZyJg+YrIaVg8a47h2Um1+3RNi7vMtK23nPgXoY+uFCjmYLwImj9/gdF8hLeJUu 7g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmkktbf21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jun 2022 15:34:21 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25DFFX7j020513;
        Mon, 13 Jun 2022 15:34:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gp7k3121g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jun 2022 15:34:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=edcnQOFJrwo+X/RMFy6MAjG0e6DbNqANUg/jbO4hwBTve0iRsOH8uqpdJbXqBQcuhRSNp60Lt1tW/LEXp0YcDg1b1K1NEXOEdp6+XsvEIHIsMZ6Rzj3Q0X1F9331et5wW8wOEx8wNHfjCAtEkEPfc5apUEi4Y+nk6NciUG3cRuxPKhgPd+oUMxlTJfQU75C9ZWw/j4wTcQQwHUasSf/fLnTcs+VeOJ+7Fz0933xib+VFR8NAvmBaZDmrbEJHLoYOvHQNSDHe6HddYUQDQOq1C9Gnx3WsWY/X3iPcLVeFBv2vkrc7O2l5wW0hC3d0loFZYdIOWN+fViiNib1z8lmnlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5AkvTGH1vISLeuXvv2lupzAaqMqFHU51Snuk8tfD1IY=;
 b=Dvp3VrxlY/Fe3jHlV5RMfD3dW51ZgCKnEqKBLiuz4wNIJjSWnMwdMsGePWEZ3e0M6ywTKneNK6YFCxLa8nHTG9BLLfMyB036Yt/hlHRl1wjyu41TRhebhtFv6N1FsA2hfviLksiXJW6m99rdnB5FF9bO5f8JNwYVMg3POjqUnJlO5PU4SCdIrl4DfkOb1NjJV+hdXCR+i6kbJ906CY84PbACbwBMV3mNapAxHh0PEblj0NXTvI8ozayCvnmlZcp+ZMfZNlzo7QkJOfyD9+d3IHH/pheNh2x3YuO+4dHDjIVmSRZ4gtVB7afaI8sAfmHg/gjLB40hBthjjnfwe/JlbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5AkvTGH1vISLeuXvv2lupzAaqMqFHU51Snuk8tfD1IY=;
 b=S6NAVxDKn6T4Rg1AH8Ey2c1t/mL/QRKab6e1yU6GJ+VZT+B8gLyj7qZJF6foFLuxY9DL1E9oIhu2ERRi02veI+uaETiwJv1GklJd/voaB4eAweCzzHxIcQdcGcXivhsY3fygogMGpbtNe5DR8a2hXkj0FzDKuPsIPvXokWdSQN8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN6PR1001MB2338.namprd10.prod.outlook.com (2603:10b6:405:2b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Mon, 13 Jun
 2022 15:34:13 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Mon, 13 Jun 2022
 15:34:12 +0000
Message-ID: <74585a48-3984-e9c7-1791-fa8c376baab3@oracle.com>
Date:   Mon, 13 Jun 2022 10:34:10 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH] scsi: iscsi: start endpoint ID allocation from 1
Content-Language: en-US
From:   michael.christie@oracle.com
To:     Varun Prakash <varun@chelsio.com>, martin.petersen@oracle.com,
        Nilesh Javali <njavali@marvell.com>
Cc:     linux-scsi@vger.kernel.org, cleech@redhat.com, lduncan@suse.com,
        vinoth.r@chelsio.com
References: <20220612121901.6897-1-varun@chelsio.com>
 <63408769-5e2e-3768-008f-a7d41f8471bd@oracle.com>
In-Reply-To: <63408769-5e2e-3768-008f-a7d41f8471bd@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0071.namprd05.prod.outlook.com
 (2603:10b6:8:57::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a4c1692-a274-40a9-99cc-08da4d522aac
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2338:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1001MB23386E0E271571D8B1035BC4F1AB9@BN6PR1001MB2338.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XQEjtGa1ZxAdFyjy5H1Jr0hrTWrQW5ucTE4zk/dky0AIvs0/lHlE02HYyrg4rQAm0EmJ+rANhCRx+FfYxWX00ZCur+SPg7ecd5ARrDtSYudY0IN+bKQXfBgBnDg+eCex0q9Hu40I8NkByjXVEcndSwsTmHXKSNoJA7yynayKYVbIMeoDDqUQqL2+Wvi4j2Rx6RMYU/C+vj1v6jhh9E7ow1GhTjmY++4AWZ0Ol9GJ0hA/8+ZP2Es6dbR2MZDRioXaeUKaadiNUFwCtzrEnt3/gDPZj02ycEtoe+iuZhxwEZBAugrUUJg4CJy0gvDemS1PJQEbNAyUh2LGGDJXo2oM4rYqHgtAY27Jcazwc6rvKk7JmCJ6XhAHyfBwAafJrUUyC66S6EeF+SSQJ7lQjBwyT0XqfLc0UTYj7l01jqtsqbJV5Orf2N1ZF/VEQmJBpA119iyHaCXNHD4OjaNTqlWLR2/zKj/H377YBlsAijLyPpcFq2mAsmHkw2bG9KvW9iMlQl0YmozwGfbIY4JYwsaxIQsikAVMXiWV422fv3bRtouBfmkFLgrWcQzREx7PlBDC4qb2Xsn4ek1TRgeT2ifeAUpoqtX/IUHHjO+ZxSA6szghB7DFsTeZ3Fnnbpqrv83Uu0kl7Z8tqBH6xEhf2qxyK7KV50XNrF1E/YTek8q++6Yzw4qQB6O2pvavj0IlEALA2QFnpTiFsCsA+LETalIWtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6506007)(86362001)(4744005)(31696002)(508600001)(53546011)(8936002)(36756003)(5660300002)(2906002)(38100700002)(26005)(9686003)(6512007)(66946007)(31686004)(110136005)(83380400001)(316002)(8676002)(4326008)(6486002)(186003)(66556008)(66476007)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c055c08vWmJxUktJbDJHanlsWDVyakR1OUdrUHI1SWxnc2FTM3Via1JqVm5B?=
 =?utf-8?B?SElOU1BIdlFYN1FwdzlYR1I3ZGlTbGNZeCtLdkh1NWZ0bzVpUS9wVUU4MXNr?=
 =?utf-8?B?Uk0rRXdxa2RoOVh3WmxlVEVkaXNUYkZ6NmNOOU5vbTFTME1hWkVOUHd1L01N?=
 =?utf-8?B?dUdUVDQyRU9ibnNkVEl6cHp4bVZKTE1FOU1BUTlTeFVpQnJWcW5oMFgyeGJT?=
 =?utf-8?B?d1AvbXNvWXZCSWFpVnZtOCt2eTR5dVhTR2dCMGw4cHhKZXhkQ1NtRElZL1g0?=
 =?utf-8?B?WEZJL0wxQWpkMUdiNVc3eDJDZTdFQy83WjZ1blprZk84U3EvcTZuOVV6a2Jl?=
 =?utf-8?B?MVkzQ3dtMDRPSHdpMzYvQzM3NUVDV1lHdHduaGl0cW5OQWsyVzFHelhwUXBy?=
 =?utf-8?B?TGlYNlVPTEE0OFBKSVZDQ3BkYXVpRXBmbGxOUWpMQ0o4Mk03UlFBbjhqZWMw?=
 =?utf-8?B?NDQzdWsySlFpQnF2Y0FKeFo5Vk5ydUhPSnJQLzMwUm5vVllLY2VmK1VmZDJ1?=
 =?utf-8?B?UkpaTGg2djJrdm0va0RUT3RtVm51TjhtSUJURG1KQkJwc3B2eVorK0VyME52?=
 =?utf-8?B?akVKY0I2NWNTcUhSZHFLeGZaN3ZFaEY1aDdNL1lzQndEOER2dWFRSC9Dc25T?=
 =?utf-8?B?cVBoR1hmVk5IV3RjQS9xblBZU2loZEhwNFB5bVB6aWUydlVuQUNvS29qNHA2?=
 =?utf-8?B?NDB2K043ejF1ZENoZUlsamg2eHFka3BBV0hSYU8weGw4V3lhQjhqOEQwVXBB?=
 =?utf-8?B?bERSOWs0NWJMempkYXh5MFFRSzZuYnlrS3VId210L0w4WWs3OEVmTFA2bFRt?=
 =?utf-8?B?MjI2SGNoMXFGQXFXemc4SDJYOGFKNWlZeFRPTFZ1azY4VHRrNTN4bjl4bDd6?=
 =?utf-8?B?RC9aR1o3TFVOb3hjbXQ5Y0RWckhwOEVzVThLQWF2a01pTUFURVBWeG9WQWcr?=
 =?utf-8?B?TXlSdGdEMlFYL1grbjRMSFJWaTNvSlRQSVJTTXFnSGZOSHBTUk1ydHRvZjF3?=
 =?utf-8?B?VnE4S2hlaG5EcWluSnhDay9XU0RNY2ZuQzhLNVU5dmRaZWdmYW16TExvRlQr?=
 =?utf-8?B?U0UraEFRL3ZNRjFxYWVvdGxxa3NzOW1Ua1BhOEJzcWxtY2pRbiswdFdQMzFX?=
 =?utf-8?B?TEJid2QrMkI0ZWNVZWxLdEFKemZvK1B3alhtSlF3K2RjMUEwRG5TSVJZSUk0?=
 =?utf-8?B?UkZray9YZ1UraGVVMTJoL3Y5QVVDMmpibi9jbmVPNlhLZ0l5NHI4emF0bmJi?=
 =?utf-8?B?N3BDb1BkN2JzRitMV0txUUhLbU8zakxPL3R5bTlVSmh1dElRN3pPQ0pFZXIr?=
 =?utf-8?B?elFNZVJSTjZPV0lOa2NkYzRPRHo1R1BPRFlWMjdVdm9RRlNqWUs3dWFvWSt1?=
 =?utf-8?B?Z09WTXh1b2hKR1FuekRobXhCV2hvYlJWZzkyQ0lKQjV0c0VuejhzUXc4eEp0?=
 =?utf-8?B?aEUwbEtnTzRjWEVSOERHcTBwWkx0V3V2dHBMb1QvS0VFaFA1eGp4eVJGakhp?=
 =?utf-8?B?dktDT21OSCtUeTRLaVVxSnpGelJqcTlnN1BOWnNESGN1bi9FUFVqUmFyZ242?=
 =?utf-8?B?RVhwMDJJa0FGdHZoQ0NQUTlRaVdDTklTZVN6MVVrRi80WjFSUHM1c3VWdWds?=
 =?utf-8?B?amxDNm53UUZwZG90ajZnZitNVjU3cEN3d0pBb0dNL3YwdWthcnVBM2hMMlkx?=
 =?utf-8?B?TDFvYnh2NXZmODVBbjlOWFl2RkR0VUllK1p3QWxSRytKdVVHZVNQZEpaajZk?=
 =?utf-8?B?OW9hZ3I3OXprQXJhQ3hpWVo0cnVsS1dWY044aFVHTzdTZC9ob2pMT2Jmc2Vx?=
 =?utf-8?B?RjVEc0RGcHJBbWozb29Pekp2QTE1RHd2TTMxNE9tQnFnMHFTb1dZVmpnMk9x?=
 =?utf-8?B?SFFuWFNHWndxQ1AyS0ovY2d1dDhmenorVWZtZ0hPVHd3eHFRYXlmbFJSSHpS?=
 =?utf-8?B?L1poVW5aeGo5TElPVXhFV21kY1U1SW5Mbk0wVnNRSXZwQWtIamZSOGpyWTJJ?=
 =?utf-8?B?Y2xKbG9MaGlOSW8wSFJJWU13ZnB6OVdvTW5YSHJVaXRHQWxmdmtXMXE0S25E?=
 =?utf-8?B?Wk5SNmNhWWNtbnY5TXg5Z29IcVBkUjdNOXpJeEVieVlDY3hCQ01pNk92WHZQ?=
 =?utf-8?B?b3o1QzhLdCsxbklTQ3BNaFRuQnNDQUxjQ3ZVTEJLWVVhWmZzclZBMWZKYzV3?=
 =?utf-8?B?eHhKWko1cVBsbGx3dzZGSjR3cXMyZ3NpcjVkRjZ2SEFXbm5SSkZ3STJDakJB?=
 =?utf-8?B?dHFQcGFLU3ZDQks5WU1FUUlsRFlXL3BWUWl0MWpMbGJwMHdsVndMcHN5TGtD?=
 =?utf-8?B?WnozMHB6dXl5c0RIWVY3QjIxNjRHamRTQTN2aFQ0Y09lWlJ0NkJFVEtlalZU?=
 =?utf-8?Q?n6G95dc+/WI4RaSU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a4c1692-a274-40a9-99cc-08da4d522aac
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 15:34:12.6364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wapCqKB/xg41boT8M8Bbt0KIolgdrFA6Xddoe8vOtu0rKC0r3x6zG+jpH0oYnJhwrThSSnJA9T3j1ySdNQJB1QOBh4xB2JUkvjVdwSZoItg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2338
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-13_06:2022-06-13,2022-06-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206130069
X-Proofpoint-GUID: ikdFWDDd-89VAjk1KS1IdZrI9MpbloQy
X-Proofpoint-ORIG-GUID: ikdFWDDd-89VAjk1KS1IdZrI9MpbloQy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/22 12:04 PM, Mike Christie wrote:
> On 6/12/22 7:19 AM, Varun Prakash wrote:
>> ktransport_ep_connect() (defined in open-iscsi/usr/netlink.c)
>> returns -EIO if endpoint ID is 0.
>>
>> int
>> ktransport_ep_connect(iscsi_conn_t *conn, int non_blocking)
>> {
>> 	...
>> 	rc = __kipc_call(iov, 2);
>> 	if (rc < 0)
>> 		return rc;
>>
>> 	if (!ev->r.ep_connect_ret.handle)
>> 		return -EIO;
>>
>> 	conn->transport_ep_handle = ev->r.ep_connect_ret.handle;
>> 	...
>> }
>>
>> Fixes: 3c6ae371b8a1 ("scsi: iscsi: Release endpoint ID when its freed")
>> Signed-off-by: Varun Prakash <varun@chelsio.com>
> 
> Thanks.
> 
> Ccing Nilesh because qedi was hitting this. I had just sent him a patch for
> this with some other patches.
> 
> Reviewed-by: Mike Christie <michael.christie@oracle.com>

Martin, Ignore my review-by. We are going to go with Sergey's patch:

[PATCH] scsi: iscsi: Exclude zero from the endpoint ID range
