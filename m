Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B7CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 17:13:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EB3161A64
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 17:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbhKSRQj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 12:16:39 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:6088 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236357AbhKSRQj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Nov 2021 12:16:39 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJGGEYr027078;
        Fri, 19 Nov 2021 17:13:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=68MUCxCQ1wlZ7N7UYYQFoPrCapFZLrAbIetSwmF7bug=;
 b=GcFJEMSV/b2jqObeJnA6Nh7ekQ1mFD9B6El/DhJSjAlADjpJBS2hiZdjyGSWWUEGoZRf
 rcnMJqqyAarIMqacG46euuRWUWEEMtpX6No92KISID1NiPT17aeZvUDm1ZDMpBXFK+sY
 Zc1imDshVeBApWWf262jdXcoW58xRFrniXGmV9JRvbNghikC35hEq0QPOE4I67d3GKMR
 weE+kVeovR6ZHyt5XMaOb0SLXwJJnK3ihzdDWZxc6GJ4zpmN3HWkh4qNh2SQleJQY6KG
 F48L2uWTKxwrC9UGnOeZGoX6vOfKQHWpP98p+6i1PLoHdZbiniqw6noAzNEIdnYiBZSj pQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd4qyyb26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 17:13:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJGuo9r045749;
        Fri, 19 Nov 2021 17:13:15 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by aserp3020.oracle.com with ESMTP id 3ca56ahwjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 17:13:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nba0qQKKNHMCaZ/hshNO740TNMNKSJhWp+tGuch4GqthN8419AFhROdRbxT05Iq1nt+oVTxyxDKwQiftzJSOoXxAgPSGEu8peEfTvU1XBhlKOyYqYDxYSFjNYrdoa7S8hglmMz1ycBOTODfDJGSA0YUQ4f8dKYYlVtkrewEi9CSBTzW7+1cPZq8I1vOCqUk17p9YELvDe9YYeLPRdBsJ7NKISfWiVbUkz2Fa8zVxhPETbSKHdH+A5o++UryFXiSGvQrbMDtiMMJUH2auz/lBHoR09i2FH5x+/P1sKv4COrdJWPVJkVYXW5TlU7tPAY2eeDkko7qFIyz4ihQ7QedFDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=68MUCxCQ1wlZ7N7UYYQFoPrCapFZLrAbIetSwmF7bug=;
 b=kEbTWWFQCVWq+S2RZytJYdrZHPrIPW+T3uar4/2TN47Cbjm85ctyQbm+wh5zhvEg8R/6PGamDp77zFe4Gp+8bjHLNXtSUh//wI6D9DZtHMHs3aQ1tzn+DPUJGLJgIAKMAwpbDuEWdlg/KgU+fFIiri+RvdeJa4XrJUaT9XFEqf1fVFd4vaPJsVpGmhfi7xtRXeJHMI1+lyQ2tRSLMr12IfzqIEIts2lbNi0kKcnqa2+aLtT9xRTB+nYRSQKEOGuq0/pPJyi2eUS4YBl8gh2Y6IfanO5ZInYyHqnGJoXA9jrV0Tdsi1O7bhtHvjvR/VQS/odBTtmtVNOBF8CDuFiS1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68MUCxCQ1wlZ7N7UYYQFoPrCapFZLrAbIetSwmF7bug=;
 b=SZyMycU5hTXNNvzInB0gqvNk3AO5AtbYePn5nXE+VZzHLMZk1G37F+xPiN6KwIOOndbmxomewOu5ZeDCfzQwyiReoMNvaDt975J1q4wB4nz0kEoeWRyXukgAGanYAEg0gA9UT7BBIhmzTT4fyBIA3iGhFG1t9TKqTRhNC+xN7V0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2955.namprd10.prod.outlook.com (2603:10b6:5:66::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.27; Fri, 19 Nov 2021 17:13:13 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4690.029; Fri, 19 Nov
 2021 17:13:13 +0000
Message-ID: <85ff7a01-fd44-b036-b2c8-145f30790752@oracle.com>
Date:   Fri, 19 Nov 2021 11:13:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 2/2] scsi: Fix hang when device state is set via sysfs
Content-Language: en-US
To:     jejb@linux.ibm.com, lduncan@suse.com, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        lijinlin <lijinlin3@huawei.com>, Wu Bo <wubo40@huawei.com>
References: <20211105221048.6541-1-michael.christie@oracle.com>
 <20211105221048.6541-3-michael.christie@oracle.com>
 <b78c655594d3aa5c6ac5540dbf8fb931dce5a78b.camel@linux.ibm.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <b78c655594d3aa5c6ac5540dbf8fb931dce5a78b.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0205.namprd03.prod.outlook.com
 (2603:10b6:610:e4::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by CH0PR03CA0205.namprd03.prod.outlook.com (2603:10b6:610:e4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 17:13:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0ffbfa6-5a00-4f47-a820-08d9ab7fdeb7
X-MS-TrafficTypeDiagnostic: DM6PR10MB2955:
X-Microsoft-Antispam-PRVS: <DM6PR10MB295587622AEA0B7916A2345EF19C9@DM6PR10MB2955.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:151;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ZRREu1BSFHYcN8shKWSUqxSYIC1ay7/2ps4XXt3xsNq4JCh6cAzUjGxqWI/2fE/9E7Q5SPiCOjiLoCaz/SLyDMGLIqU7M5R06ILd6rojcj6cVLg/vyKslI3KQnuNV2wQz1Q7I9sKbpZG0vdJ5WnF8CcyVwbdCk1783GO5wjwLNnkerQEwObrykPwy/lux5kUdZqvap39LOnX7BohZKAaK5S8/SCzV7XFgrrpsdM77+eMWlby4g9ugCqC6MldI1xv86PkNXRLf9jwv9CCEI6QV9ZTAWkLzP6a9MIk2O8RTu073eN0AI2wXSLiEWKXOCQIEci+yRdbFtRpkwFn8Aojl0dARccq0D5eZmfHT/e2s0MLPSZeZDFlQyzevxGk8KLWiMueOOkmZNjsDJ04kL85mdMUJs5akLODjp5rZI8s0KINymuyAfnvR8r0lI0fDGy5jPFLdhDPSwzI0D1UZ95WioGlYNKjaO9oXIH4BOCMYrFmimikIbKitSwVLuso4JDxfXVXdZPUOLBOq4OVRyn5VPXjcn7z6GsPkRqtQtTmhMDtpDzRZqHUWFKswBH78Ua0p3b7nKYSPAGFZNNUnS3dFBk6g/R4N/L6m8RPNzHqzR3QRxlno9hyJZhkCIJ2XfYv+STDbRCnyMbmktBfiCbq9U0IExpDYLiV+aAxPSDoX/kZyDixQ82qawguyo1UGJOtEfkZUb9NJSzSeIdvfFAOTOLfPQt4ZXucJh9vgmV092u8B+DBYUieQ07teegEHaWZD5h2kaxiznw1VVvMlwqWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31686004)(316002)(16576012)(5660300002)(2906002)(53546011)(66476007)(36756003)(86362001)(66556008)(6706004)(186003)(6486002)(26005)(2616005)(4326008)(956004)(38100700002)(66946007)(8676002)(8936002)(508600001)(31696002)(83380400001)(54906003)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXMzZXA1R0pFWU1NTTd6emZuTGJJckxiQ1BFVWRHVUVXN3lTSjM3NGVUaHY2?=
 =?utf-8?B?MW5KTEc0VW0wTEt5OEplSTRZNDIwVUVFbUQzZUNEajhWdUhva1JHREVCSUNp?=
 =?utf-8?B?RjNRUWw0RGhFMm4wZmdoZ2ViZmI0c2lhYVBEYzB5UDBmTGM4bGRmOE5MMzdl?=
 =?utf-8?B?TG1rWFg2SWgzWWViSDJEU21SQVp5amgyU3RjanBRVVJUSU5qY1NPRi95L2xJ?=
 =?utf-8?B?eUhyUHkwaTdQVHNCdi9NR3hOK25jb0hpYWRUS2FRTnJ3elZnZXZ6S0QvcWlp?=
 =?utf-8?B?MHppTjJlWk90VGp6Zzd6elcvSVhYQ3IrS21DMS8rRDF1clFQV3NLckM5eWpi?=
 =?utf-8?B?RmdhTy9CUkRXWEtOL1FLTElqcGpMVDAyQWhvZC9lNE95SVJUU0NzNGlZU3Az?=
 =?utf-8?B?NkNJNjlBNFBOWHJBa2hrck1lTnVOMEc0dlFDTndOZXpXQUlKcmJRSlFKVlBx?=
 =?utf-8?B?YUFBWVJpTzMxeFU1azJ5YXF3SGE3QzlTREZyMFM5UFpkMXRXVFNjWWV1S1RX?=
 =?utf-8?B?a21MblVYNWh2SWhQbitMdFl5bHVyQnVpSjNCNTNaOUoxSEg5WjVBTEZ6N2p4?=
 =?utf-8?B?WkdDKzJRTXYvYnhIZTJZZFBuRDZ1Vk1rZEtaQklrYzJrNHc4OUJWb1hPL1l6?=
 =?utf-8?B?cVQ4bEg4NG9QSWxoTTdZSUphdmFTcmNLbGhOVHVQVTRkRjRpZkZLeldreGY2?=
 =?utf-8?B?a3UxSFYxdEp3RnpGMFcrYnFDTzcxOW5HMGN4dnd1Q1hpWTFLZUt3SklMMXlq?=
 =?utf-8?B?YmhDcmZlWDF4YlhRMi9GMXkvR0lrak1OV1pHZGZoNkxPaHg0c00xeGF6dlVm?=
 =?utf-8?B?dFJ4UzRIRVVFcGthcldRN3I0UHdpMWFzbzQ2RS80cy9TUjBGK0VRWVlaRHBL?=
 =?utf-8?B?azdST0ZiNnBweEx0dSsvWE9uZGh4MUJXZGx0a3p2aUtDT01XRjFVZy84NzRr?=
 =?utf-8?B?VUFxS0RwTGNlaTNYVm1mNGEybmVwT29pUXk4WjdWV3FZSFl5a3NwcUZBVEI0?=
 =?utf-8?B?WC9IeHY2VG81cmRGMzk0UStUc2RWNVVnMHUvZEFldm1uMWplb0VSM2sxWE1s?=
 =?utf-8?B?NjA3aVM2VjN2TjMyRXVXWnhON1pkZUpMdTl5WXpRUmhVb1NmWSs0cnhndFpD?=
 =?utf-8?B?cnkyTExDRUJOQVBWQkhFR29FWW9yR2Rhd0xMdkYybzhPWU5zNHFUNTJQN1Ur?=
 =?utf-8?B?L2t2WjhmenFiMENMaUpma2NrMnlNb1hUY0g5TGtGNnI2dFNnQytmUFBvR2Z1?=
 =?utf-8?B?dzlGTzI3OGs4Sm1NMmE2MzhGYndZWjZSdEIvSTluZ1ZFdU5Ka1BHdFpaQW5u?=
 =?utf-8?B?NFE4b0dBenAwVWhtMEo0NHJ1eTNVRU1tRzZ5VHEwZklaN0poZnNUbmttdzJw?=
 =?utf-8?B?YVZJZHBQeStkN2QrQTdEMHpSLzE5SlIvc1AxeWlZaWpLdEdVNWVXQjRSODhY?=
 =?utf-8?B?Ynp2Q1hyaFVUYjBtMmFyWk1XdEx6MVJkcW84c1cyWmIwdmllTTgzdzdkS0Yr?=
 =?utf-8?B?ckx1eC9aVW5uU3k5eVlBeGIzK2o1WStIc3o5Y0dSb3ZpNTBnWE9LcXVPdldB?=
 =?utf-8?B?QXpEOWpGN2VjMmlvdkJxcUthTDBBN0dMSzlvQnRiK09jYXhPK0xSVjZlQVdE?=
 =?utf-8?B?MWtxTmZkMDR4cXBPN2tmK29zSnVRRW9lZWRPd21CQSs4dVRRaWYrM0xYRS9B?=
 =?utf-8?B?aDNOaUo4MUk4amlRai9CdkRGME9xNjZNZks2OVY0bTR4Y2wxNkRTeVpjTERX?=
 =?utf-8?B?eVhjRGdta3pBOVkrWStDYXhJMTNsVzQ0cFdNazhMMjdrdGxLRHZKeEVrMG9W?=
 =?utf-8?B?OC9KbENOU2lpRUVzY3Q4K2hjejVmcHZrTVJ6SXFZWkFzaTJ4ZEJ5bGNaOVNn?=
 =?utf-8?B?WXNhY2gwZWpVSHh4QkdQTVFTdlhDYldTdWdMOXpnZ3QzejBNZDI3L2VlZUtY?=
 =?utf-8?B?d2lSUGtEM3BVMGxPbEpuYkJ4eHJvay91bkRqRDNhTHVMcStPUk9kVUhNS1Jy?=
 =?utf-8?B?MkhrU3FXN0pUb3lYNTBpdTZiZ2ZHTXBITStIVVpaNldlNnhCTG1vVDlHOGlB?=
 =?utf-8?B?VHFXSGVKWG5yYW1TSXZqL0RzRTBqOENxY2ZXK0ZOY2FMRCtMMHZkWnVrclhI?=
 =?utf-8?B?ZnNQbDgraEI4Ryt5MysxWUw1eFl4c3NWcHVkNUZPS2d0YlNQT28rbGRzaXNm?=
 =?utf-8?B?eng1OU44VDZCNHdROW5LOElTTkk0KzFvOUJPUEdpUTAwWFZKTHIveTNidVZ0?=
 =?utf-8?B?SWZBZzZZaU9LYjZkVUxtbWJQUThBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0ffbfa6-5a00-4f47-a820-08d9ab7fdeb7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 17:13:13.7069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QzxUO0AySp9AZivtqTIPRXW9XpmTAlfFjQDlUSPMzEr4cueiljhphp5wQhSmuNFQis/EgXAitrmkoMic3gyI7Lp1waSo3Ol/2pvSzWAEjkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2955
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10173 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111190094
X-Proofpoint-ORIG-GUID: ff93MhA31tY27mPTYlgGy8hs2rLYwB3v
X-Proofpoint-GUID: ff93MhA31tY27mPTYlgGy8hs2rLYwB3v
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/19/21 7:35 AM, James Bottomley wrote:
> On Fri, 2021-11-05 at 17:10 -0500, Mike Christie wrote:
>> This fixes a regression added with:
>>
>> commit f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
>> offlinining device")
>>
>> The problem is that after iSCSI recovery, iscsid will call into the
>> kernel
>> to set the dev's state to running, and with that patch we now call
>> scsi_rescan_device with the state_mutex held. If the scsi error
>> handler
>> thread is just starting to test the device in scsi_send_eh_cmnd then
>> it's
>> going to try to grab the state_mutex.
>>
>> We are then stuck, because when scsi_rescan_device tries to send its
>> IO
>> scsi_queue_rq calls -> scsi_host_queue_ready -> scsi_host_in_recovery
>> which will return true (the host state is still in recovery) and IO
>> will
>> just be requeued. scsi_send_eh_cmnd will then never be able to grab
>> the
>> state_mutex to finish error handling.
>>
>> To prevent the deadlock this moves the rescan related code to after
>> we
>> drop the state_mutex.
>>
>> This also adds a check for if we are already in the running state.
>> This
>> prevents extra scans and helps the iscsid case where if the transport
>> class has already onlined the device during it's recovery process
>> then we
>> don't need userspace to do it again plus possibly block that daemon.
>>
>> Fixes: f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
>> offlinining device")
>> Cc: Bart Van Assche <bvanassche@acm.org>
>> Cc: lijinlin <lijinlin3@huawei.com>
>> Cc: Wu Bo <wubo40@huawei.com>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>  drivers/scsi/scsi_sysfs.c | 30 +++++++++++++++++++-----------
>>  1 file changed, 19 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index a35841b34bfd..53e23a7bc0d3 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -797,6 +797,7 @@ store_state_field(struct device *dev, struct
>> device_attribute *attr,
>>  	int i, ret;
>>  	struct scsi_device *sdev = to_scsi_device(dev);
>>  	enum scsi_device_state state = 0;
>> +	bool rescan_dev = false;
>>  
>>  	for (i = 0; i < ARRAY_SIZE(sdev_states); i++) {
>>  		const int len = strlen(sdev_states[i].name);
>> @@ -815,20 +816,27 @@ store_state_field(struct device *dev, struct
>> device_attribute *attr,
>>  	}
>>  
>>  	mutex_lock(&sdev->state_mutex);
>> -	ret = scsi_device_set_state(sdev, state);
>> -	/*
>> -	 * If the device state changes to SDEV_RUNNING, we need to
>> -	 * run the queue to avoid I/O hang, and rescan the device
>> -	 * to revalidate it. Running the queue first is necessary
>> -	 * because another thread may be waiting inside
>> -	 * blk_mq_freeze_queue_wait() and because that call may be
>> -	 * waiting for pending I/O to finish.
>> -	 */
>> -	if (ret == 0 && state == SDEV_RUNNING) {
>> +	if (sdev->sdev_state == SDEV_RUNNING && state == SDEV_RUNNING)
>> {
>> +		ret = count;
> 
> This looks wrong because of this
> 
> [...]
>>  	return ret == 0 ? count : -EINVAL;
> 
> Don't we now return EINVAL on idempotent set state running because the
> count is always non-zero?
> 
> I think the first statement should be 'ret = 0;' instead to cause
> idempotent state setting to succeed as a nop.
> 

You're right.

I'll resend this patchset with James's comment handled.

