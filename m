Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10276C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 13:54:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0C0F60E73
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 13:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhKDN5Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 09:57:16 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:48026 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229869AbhKDN5P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 09:57:15 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4C4ePk030915;
        Thu, 4 Nov 2021 13:54:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8xTfw3nQa8U2Bg4iWgA36ChoIYxT53OjvYoF6DhW0Go=;
 b=kk8CkUfmhXY1Cbbrk0JPK10xmStsA3e/zawOBttTZwTFRKfRI//SsQjVwpIpnoy3eCYn
 OEEZ0WqmobA3nlG0nixPhy+mTD/6phyiDJEIjii+OjRjBzV2YZB1ctCs7haZDlLubdew
 k1L8tkKnvOJrrA/xYLsSJYuRYLoFWJK8f1Fud6+cIacXHifF/en+7KVxmymPkoXe8nKB
 KmBQVJlG/h1qgnGv5cjI27BklHRlpU6V+3C2W+/tKkfz7HWAF4/1BwufhhryplSP09ts
 Z9NDS8m3df8TCxBGfzO7EFIiR+EEswEyKXPncW5vjtxxJzZsCy1YSKELax1KQ3peTrKW pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3q1nfj60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 13:54:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4DUOjl031898;
        Thu, 4 Nov 2021 13:54:29 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by userp3020.oracle.com with ESMTP id 3c1khx85ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 13:54:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvXEuzvHwo95DqdsS7Rdtis038j7FnOr4vy/WDZeZeizxC4xyBoP7xOgHU0npNQwGpXBltGupe2TtLXaZyeiHPdETPqjQ6zCT3kuVf6ia/ww8h/pjcKwMepTT/3/l5RezgDOxURa8q+LY1vnHupYlpCH1OLk88da7sxQtbP5sM5ssTs5rcM8+ozdXRumnH9QsfOjrHSUvk29+ETMrFuFtkz9VHPZoFgJwcPO2G8ASKOYe0Xw/AkhO9zs5tVdfqvLyRCKb/TgSQ3quawF9+fzjY7D6rI+lZNiA7KnVNXOUmAywD5DhTaqKXjYCj4d6e252GlCWEeDhFntt6tJKVO53g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8xTfw3nQa8U2Bg4iWgA36ChoIYxT53OjvYoF6DhW0Go=;
 b=BMfGUCfYkp0vecG1PX6X6gRBy9LLyd+gJJ5k+92AFjzwz8dHhNMx0foIzno1hcOANdAn3KD2M8EW4nmlP5dnBQ+0+N8xmi9Yq1uYVFXYZBHaTZzLtgiN0Zl8IPsqRzZpepNdzApwRDzOu4GWlD70Jz0ZfPNdLw1LYpx6J21ggZ0vfis9Jl3OPiH/SIcq6JvZvaV0OG9n/CPbf48NffYzwjvYU2h8mUcsjGRKB62HyaK2dSoRge5BhjbXxa5cLxOpJjMozbSaQ18160vxbdBKa3JG3/R5WCnMZ6ik3cUlPsSXQCuWd+iZOHj95GdMhNmyokWpge5IwLlsRdwDhKzqng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xTfw3nQa8U2Bg4iWgA36ChoIYxT53OjvYoF6DhW0Go=;
 b=nmYSqOXxmSQkwxqu38kwyIN15OPlQrH5KJo4Ppc0oD9vfAn/mNLTpBsPBkTfg8piphy58ukwApqyKXhOVOWDRL1offZsfxeBG2HcwPXtj9YkyF1o7f+F++U9DwjrhWKvBiHpPS66vCPHuH6VFyF6t3BLyGH1KJTaNSSBcl/rqDk=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN6PR10MB1235.namprd10.prod.outlook.com (2603:10b6:405:e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Thu, 4 Nov
 2021 13:54:27 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::8823:3dbf:b88f:2c0e%5]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 13:54:26 +0000
Message-ID: <70683ce5-cc77-ebc1-b534-7c2d3a92d715@oracle.com>
Date:   Thu, 4 Nov 2021 09:54:22 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v2] scsi: scsi_debug: fix type in min_t to avoid stack OOB
Content-Language: en-CA
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
References: <1635861997-987-1-git-send-email-george.kennedy@oracle.com>
 <yq11r3wr8ck.fsf@ca-mkp.ca.oracle.com>
From:   George Kennedy <george.kennedy@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <yq11r3wr8ck.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0083.namprd12.prod.outlook.com
 (2603:10b6:802:21::18) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
Received: from [10.39.233.139] (138.3.201.11) by SN1PR12CA0083.namprd12.prod.outlook.com (2603:10b6:802:21::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Thu, 4 Nov 2021 13:54:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 935b5792-92b4-4936-8ae6-08d99f9a9d51
X-MS-TrafficTypeDiagnostic: BN6PR10MB1235:
X-Microsoft-Antispam-PRVS: <BN6PR10MB123525607695C713A57242AAE68D9@BN6PR10MB1235.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LulPkhiBC2MMBqE91euwp9IkeWeOBwRCjTv3SJUK7hulm/A547FfzWscDkp5DRCNk7hanzKTryzlx1XPe2AVZVSEJAPLh/tDZZAI1MfiOEnXZTnPhBhuwCmNS4q5H2wJVmpiIxiRMZp2eaZY5K5BOfP4eNdy1FGqIM0/f/JOOjIIq71BFCNlRad+b6CCRxG58bq36AHKE1xGo06OhKCpr/U5cU//nj2Q8N+yGNWKb/xFKjcxNHkXwNjLDQe4nMs9K4W7Qzu1bU9NQZrGi1WXmzFCPXJAEEoAOdi/UPQuzP+tC10mH9vF2tNupGHlv7kWaL07xhBOVbIZ3WWQmVnIkwY7I50CAFFOPQlnjbJG88qOvK3zn426KpsEGtIWXYVNq8HdVIQAr0v9ocpP2CPIHmeLwnS+OftB/g27GAX7ZAi3y02B/HWnDWLGYYF/lFElvLLJ6469nZW6NchbtS8Z6qTvq7z+tzdugRdmeGRsI5L1KWvJd6KwPJ1/FqffqLoKueZkGAXL+brn5Jx0vearlKC9sg1Wqe+BMPMopn+5wnBw7VuRVjlLUUzfU8G5gwYXLr9FFEArjdx1r8jbkR1RjUlcwD2b5ye6mFbjVGMyaRKH4y2RWg/jQW4TL+gSaJ5yUJIsuqjpEZnTqEcbWld07CezhflbiEl7P6rU21dOiXn/nYb7FAgEnYk62ODYrHdfs6DmBq7qI/PQOXsRLd8pTjcNDodyQnhhHZvk8lgvUYg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(86362001)(8936002)(66476007)(66556008)(4744005)(107886003)(36756003)(2616005)(956004)(38100700002)(316002)(53546011)(26005)(5660300002)(186003)(37006003)(16576012)(36916002)(4326008)(6486002)(31686004)(2906002)(8676002)(6862004)(508600001)(6666004)(44832011)(31696002)(6636002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzA1Q3Y0M2cwamp4VkRGZTNDL1BmNEhjSVNXdnNMSnZ1eXY2NTV5d21Vcjk5?=
 =?utf-8?B?dWxzeVlpNjhrVHcrcUpjK2dGNzJvYXlvbzhqNmtjK0FzNkJ0ZkFsUm1md2xN?=
 =?utf-8?B?VjA1V0dVQjNGblhVcXh5UndBL3kzdGpsRlpqaVJldXZrcE5KWU9jTzh3NW1F?=
 =?utf-8?B?bkgrWWhBVmVVVjZkNGYrdSt4YmdYdHBtaFZnNVYyeUNhYU1qODhXa2tTcXRj?=
 =?utf-8?B?SFlJUjM5VGlTMXNIWTFTZGtlWnJVU202bFRLL2k2SHhybitHRkoyZXord0pk?=
 =?utf-8?B?V0xPaWNKbGlxLzE0L0t0L2lBQ3JkUkN5RDJHR3dpMUlmd0gzT0NqRUhBajJR?=
 =?utf-8?B?bVYrL0FSYUd4V3BzWmlVY1FQM0luOWFFTjRheUtQbHp0V2tSczZjWXVBTUxZ?=
 =?utf-8?B?NlUwSEQydHByNURpbGdaOWFvVmhvcW5kSHhvMHZLbGUrd1Y3SFV2L1FFaFVO?=
 =?utf-8?B?UTY3c2NwTGVUNGJMdzgycytabnFXL3hFTnE5WnNJaytveTZhWDJManlrbCts?=
 =?utf-8?B?cXBNUHJOVXh0dFQvTEN5OEFUNDBhMEROVXZPWno3Z0ltUU90WkYyRExEKy90?=
 =?utf-8?B?MHNkRkI3SUw2Q0JndVFRSmsveVB4aGhXUWdaazZabjY1RmZCaWNkTkNBWlJW?=
 =?utf-8?B?ek1VTmUxZDJZVTA5N2REdnZDbUhtMG9wQ252TkMzMTQyTWZWczZKMUpGMHZw?=
 =?utf-8?B?VXVpeEhVTFh2SmhrVkllRDFuNFZRVUc1SlZSODJaM0FWQkJKd2Z4R3Q2T2Jq?=
 =?utf-8?B?QVhDREVDdThxd2VKV1BteXA5TUFrVkgybWZvL0twTVlEU0t3WFlrR3B5Mk1E?=
 =?utf-8?B?dklxc281eFRXUkhLejZNV1FrVGQ1ZUVnRXJtcldjQTN2K1ZkTGJYTjdlRzNu?=
 =?utf-8?B?YjN5SE1kQ1V6OWE5OU41c3ZoVWcvNjZoeGFOUWZJK25IUHhMWGMzZVlBajhZ?=
 =?utf-8?B?cCtiSGlLV1pITnlOcnJhbXNXaWE2VityaGZJZkh3RzB3VUlsYWtwSlNKM3lR?=
 =?utf-8?B?bVQ2aEYxR1drTGI4cmptNE9XYWZlSkZRS3ducHhWZjJUMmcwU3hFMDl2dVdN?=
 =?utf-8?B?MzVGTnc1elRMMjVsYmd1SkJGQWttZTlSajlRdkU0QnlpNFhpVHJTcEdaWndo?=
 =?utf-8?B?RXd2YUVPQnJIcE5vb2RENFA2OUhsQ0tMQjhOYmRNak5jdFRsSDBPWTFmY1NC?=
 =?utf-8?B?a0hXczdaSXlEMjl3RW9TSjVrTDRKQmlpdCt2clgvLy9Ebkh6VEZIYzVUNlF1?=
 =?utf-8?B?UnhhNkJweWNzVzBMajQ0S3hxTWQxdHdTZzNOV1N4ZjMwV2ZTTjYvOTdoYnRv?=
 =?utf-8?B?eDBXL0NEOVVneFFSVFdxMWxIdEpDWTArREZEWWgyQXZYeGFhMFVFSmxHT2Jm?=
 =?utf-8?B?cFJuNTJrU0lyTGhKRmNQOGVlbmZGb1I4N3RDRzRYdUxWU2tWckZmcGV5cDZ4?=
 =?utf-8?B?TlhZb281VXBybGtHQUtkbDhtMEw2YXlOQXhiWTZ3em5reDQ1UlMwajg4QnM0?=
 =?utf-8?B?VDQwZVRNWEgxMGFTTVdwN1o2Y0VvMXAvZXRYQXlVc08ySS9MM0RmYThDbDNy?=
 =?utf-8?B?U0dnUm9qUGFQVjhEazViM1Fycmx4MzhjNkxWdjd4Rk5ZZnBoUnB1Qm9IQzM5?=
 =?utf-8?B?eWM2ZEdWeEVNTGpVYVo3WFhoYTV4NmNlbEJBMHkreGpFZzk3WmhkK1FtK3ZT?=
 =?utf-8?B?REJkVzBZTFFmV1lkc3ZEYldIMmJpSnhxd2c4a0dCbzBKdmNSOWtqWkpGM1l5?=
 =?utf-8?B?bmFEM3hUQjlLSCtqQ2hlYlk5Rm1xNXBrbzNSS3Q5dDBjZmRTbE1vUjVlUVRu?=
 =?utf-8?B?REt1Vk1ENFlpU0V5aXVQdW1CbHVkUnZBUTNWY0RUeHR5MXg0bTE5TVcxZkNh?=
 =?utf-8?B?MStqZ1JScUxJYnBxYzVERjArbW5GTHpUTGpnb0lRSDdtcFZEaGpDWm5HY2NU?=
 =?utf-8?B?T09XSWhSbk11K2d5aWo5S0huQXIvY1VIcWwvZWJldWNWS0ZmVHpFRGZjV08r?=
 =?utf-8?B?SDhoT3dPUzlxbHZ2bGFzNFplRVQ4WTA5WnkyWjM2QjIyZ2VmVVFDUGxHWGJZ?=
 =?utf-8?B?NTVCdjlmeGliVkl6bU15VUZyZzlzVnpDc2sveEVuc2h3VjJHbks5NExaU3M2?=
 =?utf-8?B?YXRKekgwL3FTNllwUXBQdjY2MjRVY3VpL1JDWkd3aXRHcjZ3cEI4dXVObkJw?=
 =?utf-8?B?dEdzY3FtWWVueHdCdjJnUWFSQ3JkWlM1NEZnZXZMcWd1VWRIT1FCcHdQUUda?=
 =?utf-8?B?bW9oTnBIYWEzQ3ZRTlBhV29DZ2lBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 935b5792-92b4-4936-8ae6-08d99f9a9d51
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 13:54:26.7581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iuM2O5oWlNTVP0PdIhl5Fj/DabN8ZuNSQNYoLHu66NU2wad5aQpxE2xt81i0x0Ko77uE3ycy6CETf60tkTkyYPZxCtqN1GkJWXXIAbYNTaA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1235
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10157 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040058
X-Proofpoint-ORIG-GUID: ZBT767pokS_InucnYYoUXOII7di3R6fi
X-Proofpoint-GUID: ZBT767pokS_InucnYYoUXOII7di3R6fi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On 11/3/2021 9:59 PM, Martin K. Petersen wrote:
> George,
>
>> Change min_t() to use type "unsigned int" instead of type "int" to
>> avoid stack out of bounds. With min_t() type "int" the values get sign
>> extended and the larger value gets used causing stack out of bounds.
> This needs to be reconciled with the following commits:
>
> f347c26836c2 scsi: scsi_debug: Fix out-of-bound read in resp_report_tgtpgs()
> 4e3ace0051e7 scsi: scsi_debug: Fix out-of-bound read in resp_readcap16()

The proposed patch should supersede the above commits.

George
>
> Thanks!
>

