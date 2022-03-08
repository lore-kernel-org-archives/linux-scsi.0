Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A467C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 16:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236666AbiCHQCJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 11:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348220AbiCHQBO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 11:01:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C6350E0E
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 07:59:17 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228Ej4kW028422;
        Tue, 8 Mar 2022 15:58:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=5PCCqK4nwTmpMmZydnM4vJAlL112x5uUfxfgahUc64Q=;
 b=wR+n0b4Jcm+5Er69MN/49iXaa3SS/bYpTIqy5fPKi+vvsQ7kcdOe80l5QHNCEqd8D0ov
 nK283+ulECGJ3Z+m3R0OYihiB4cCAikTMSNRDQ+8R1VL2Wosd5Hnq58pwxLKF2Z8dMYs
 Na9mrbSx+FJ/uiaQm4TrbWc+17Ijaua9gcfuz2M4l4tpZWFTunK/7xPqupYeMcNFvkiU
 wTBUX/JFb908RRteAUC7oeZrqqfccjzER3hgTVXgY1Qjp9NECAtJEv5rR+qqga/QQTSi
 j6lo6pnbmIG8mhCKN8Z/pTd6jZJrzSfALBhbDfVkMLGR5ABgS3FLCtPrDZXyTTPJiylG nA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyraq4us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 15:58:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 228FpNbU000743;
        Tue, 8 Mar 2022 15:58:54 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by aserp3020.oracle.com with ESMTP id 3ekyp2ayu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 15:58:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UpgvN3p4Kt52Ppw1mdUTSrBDy00lzlG1+YZoiBP3nj2UcKtwtxLK21w9JOQ6s15M/oz1CFDCCC+XUSWQ8ue45hyiCfRp6nS0WH5q5S/df9cBDxYTvl8xsW9X3fD+wYH/PP0eONiKAcwxqw/MfZyImFCqv0Gd0I6Via6+9e57IXRrxlpwPFnEdKvL2CD9h1iBbVl1Tq0B4ijfCHRXlknIjgsdvtba+s13zPCaU0U0RtSdCsaIiRtmeS1XhfWQav0dPzT3H21A+v6tOAXbKRqmExDE+IVnr/rl+FxP0C/AUMt1TA9YXMkVcJ+itAH60Ab0QF8bVhZmU4JH/1aciI44zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5PCCqK4nwTmpMmZydnM4vJAlL112x5uUfxfgahUc64Q=;
 b=f5Q5/YwZ4mEKvguHSy7L12i1JfMUIURLLeUF5u433CrS7NIyD0R5f6lQnPxGZdxKQNWliNrF4NUQ6x5MsnYfuGuT2205pMBnV1GkUH+JjZoMLsHxrgrqK9zA5+9tCNpoVtSL9VCY1Rnl30bnK7xa2sK2eJLf15hrYpyflJQSk1pjUWY9U4aTm2Idjwdng9N1EDRhMopuff7GT6hyPqfmOXRbQGrfylubmjhibyXlLb8wWpzeae2xBNE09Nr1iegKrmJWby8miZ0TuYOaq7+SpJ7o4TJLt/Ql0sosnLzxEG9ilX5vemYyHZlZryVbwStTH3Sx7v+gMNWJUXuHac7Fqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PCCqK4nwTmpMmZydnM4vJAlL112x5uUfxfgahUc64Q=;
 b=e7/OZYSvMnUf3Vv7Nzt28FZBpGPyVYwUUeVXQyW+3cBDtmoFB8dC/mQzbGpI+GupOzCpw+3n3XDos9GM0MBwFcBu2HNS5nVKUMGc0vjn+13dHrfsCebr3oPz5Ciha5ywoRG/vD7oxagnvsODEZxLWct/qmW2p4SpGnrYEYeI/6M=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW5PR10MB5715.namprd10.prod.outlook.com (2603:10b6:303:19c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Tue, 8 Mar
 2022 15:58:52 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 15:58:52 +0000
Message-ID: <57fb1256-1ee0-52aa-eb57-4899f33b97c5@oracle.com>
Date:   Tue, 8 Mar 2022 09:58:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [RFC PATCH 2/4] scsi: iscsi: Tell drivers when we must not block
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, lduncan@suse.com,
        cleech@redhat.com, ming.lei@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20220308003957.123312-1-michael.christie@oracle.com>
 <20220308003957.123312-3-michael.christie@oracle.com>
 <21b6ff27-84ec-5a54-ef1d-80c6614e22bb@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <21b6ff27-84ec-5a54-ef1d-80c6614e22bb@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR06CA0048.namprd06.prod.outlook.com
 (2603:10b6:3:5d::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: defef58a-fe4d-46a1-e831-08da011c8a80
X-MS-TrafficTypeDiagnostic: MW5PR10MB5715:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB5715CA43138BBC71DC54E5C6F1099@MW5PR10MB5715.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KuNvf/GpPeqjIokQMD8JMIrIUIAcNqWl+SuhdKn7H8s0ZChw9+0ZE5lgdt3s9kiOXtUxWYXfZbG4NpY+mXqv2OEUvuI5cMe10MDRhpPusP01xB+bKwUioby1NjYsjWS+r1rK4WXqMKEDEeDpH9O5NEkGN+w11ttSpcXNGvqDwzhaFFbyvp0Adei2k2EUOdO2xrrIAIfzdQr1RurlQXfwT4Y1F0l9Af1Vpfz8z0oAuoI5Yn07aImhKj0H7m7CFsB/vSbkUHdU9lWVn1/uNikUh7E8+BXE5qQYquAoMHrAF2a8OEEkGAg26v2hBusWMNA6n7m2hy4Psm7ZogAvjjFJfU2vMjfCXQq2F6tTO26BHzP0zeYOBkDR9/2mvUcuq+pGY3+Zx1Wu5oVPnlb4H3GohCmow1NPaEjGbL+48zsWy3VN/e/ZDyrRn+5TSNDdIGc1+KvUZZpo9F3ZEcr5rfwa3qWpJUMGwkXuvVUe7lXAAE2glOJ3LdHez47WWP16vE+zTRz072a607Bxv2RHY41cpkPnJxIwNx/H/0nFhw3p4VDm7gpxfvTB1YWf4bgRXXiHyd2IuyDvLsscMybpzG+9CxR2sUz2mCh4EHZKz7dWG4G15i7B2sTE8jhcr0PhxNY1tCCtUcv+ZqQleqqs3trDwYgfzVgy24Moz1p7QDNm0uJedq4O7pKqhHVyBTdJD7PgHSA+BFDwK+dBNkJ7+cEVkysRf0CXGgovcDp/9Zywmas=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(66556008)(66476007)(316002)(5660300002)(31686004)(83380400001)(8676002)(6486002)(186003)(26005)(31696002)(86362001)(2616005)(8936002)(38100700002)(4744005)(53546011)(36756003)(508600001)(6512007)(6506007)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RnE1eEwvYmEwN1B3VjMxdEF5czJScHVraS9sR0N1NlZVd0RuOTYrbEwzNS8w?=
 =?utf-8?B?SkMzTjlQSjFsMlYxUm9KTGZ2d0ZCdWdha3pGV0ZQeEIveHhHa0FBTUR2L3hI?=
 =?utf-8?B?MEFyWUJYbE5NRVZDaVdHeWxrZk9pNi9GZlZhcmQwSXhOVHJtL3d6Nkg1eHdT?=
 =?utf-8?B?SzJJU3BwTEVNNWE4UWE2UXptZGtjaG93b2UxcDgwWmp6L3dvQ0dod05acHVK?=
 =?utf-8?B?MFJ6bjdYRnl3OGdxbldPS0h5MzhYbjlObmo3dFlkbXQ0UTdrNFRWVzNRYnYw?=
 =?utf-8?B?M2lscURVWnhwSmpYMTBBaWZuWThFYVFwZ1dCSjg1NXJXbWxwYUY1dUVQOTFP?=
 =?utf-8?B?anU2U1VmdXJ2SFFUUmQ5RGtUMy80WFMzYjBPYkF2REZ3ay9nZ1c3K01hRG8z?=
 =?utf-8?B?M0RpTVI5Qmd6RDBVV2k0NzM3R0xlTU1HYlRMSDFmQ0QwV2FRdk9NaG5mNlp0?=
 =?utf-8?B?SFdTVUZtVDhFeTZnUXEvQmlPd1c4UVNtTjlDUUFyRlVyc3hJOFJFR2cyV2da?=
 =?utf-8?B?ZUd4YVE5MnJ2NXJJc1UrQVBVWjRPNENnZm5SdVY4L0s5U1ZXb1hhUTkxY0Ra?=
 =?utf-8?B?VmwxWi9xWXZSbkg4OEJvOWs0WEN4SnhLckNhem43bnNvQm11ZmhPbFNBWEhy?=
 =?utf-8?B?L05LRTlNU21zc2NYYllMc3doK0t4NWJQYjJUODV3S3JqVmVmV01VSStydFdF?=
 =?utf-8?B?MDBaM3lDY0RoZ01FTms3dzJzS1prdG1QdWtxNzMvUHNoL0N5SVBDR0x0Umhn?=
 =?utf-8?B?VWNvOHJrMyt4dXBBSUg0UjlwM29ZQ0xKYjJoV2o4dGZCYS8vZE50QWh1cmZD?=
 =?utf-8?B?cHp0VlhNWXVXZCt1SUxqN24rU0FlYlNmd1I1MFBsYmFtY1liYnFnOWxubnk0?=
 =?utf-8?B?ejhmWjFkQjdabWtDQTZjY09seHAvSmN1K3VJRFZPSWhtbTJvdklsUkdGY2Vl?=
 =?utf-8?B?NEg3UFE0NXhIcTcyby9RaXh5UE50RlBtYkh4QWtlSEdCR2ZhQ0JsNFp3YkJs?=
 =?utf-8?B?ZWwzY3R3NzMvTVVNS1drWWdYUDN2dWltTXdPSEtqSmpobE5OblQ4RUVmQWNX?=
 =?utf-8?B?MWoxQ3BsYlVFZlVpM3ZUSWo4K3o5bGl5MVJ4YnlYd0EwSE9IL3VOdmNiRktp?=
 =?utf-8?B?Uy91UTJyR0pJcTBwNVpuVWc0VTVaQlRlSmlPT0hwMFdXZitZVEloVExmZ0Vy?=
 =?utf-8?B?NXFEL1dJQ0tzMSs2WTNTTHlkdTYxMmdVTnhnN2U0Mk9GNlorZEVHVldRTlRi?=
 =?utf-8?B?UnN4Mk1sQUNML1NPVm95alRMMWdZRnpkeVVlVjlUbkRndWZtTXB5dGFOM2pR?=
 =?utf-8?B?c1ZKcy9yYk9iLzg0azFqZjhwWWJUb3IyNjR5Z2lTaGtDdUVGVFhoZm1RK2lU?=
 =?utf-8?B?ZmJSM2hVRVhhZmgrVjhVYU9LSW96NzlSZFQ3MUdTS1JhNEdjY1lNVFJ0dEZ5?=
 =?utf-8?B?ZUNNTEg5a3p2d1hUajEvSVhzUk4zTEVjM1pFcTZNa3VQVHhxbHlVMEVDaDdC?=
 =?utf-8?B?WjVYWjVQYW5JRjBtMTVMNlQ5SG1KVzMvOHRBQmwxQW5xWlFWWTFIS2oyeDdU?=
 =?utf-8?B?NWh0Y2dYanZzT05hQzVrRUdGYXUrL3ZveDMwckNXcnBOaSs3OUlocHM2U2pi?=
 =?utf-8?B?VjRJamtLS0NpcmZ1VGhjZkM0QW5QSVVQeGhDcTkxeTN5bkF3RFNjOUx1QVJp?=
 =?utf-8?B?d2dDakVITnEydEZpcmN0U2VvZlFtVUpVdngzOWhITFU0K0cxN0dzenBGMk9V?=
 =?utf-8?B?YWZNMFpNR3RXOERGU0VhaDVUSWgzN3g3TkJjeWQyejBLb0JyTWZoYjBpdjB3?=
 =?utf-8?B?U2hScXQxUDRKUGtUc2dldjUvZmxqSldkb2YwQ0dmSWFSNjJ5c3M0K3BrUnVz?=
 =?utf-8?B?dEZJNXVIWFpEU0VFSTZ0b2w4T1ZmeWd2THZkVUdQdVVJQUhFMnkxUjUvY3Ro?=
 =?utf-8?B?L0RiRFpWMWF3V2FiUEE1emJvK08weXU3QmlDbDVwbC9HTGFUNGVrQVpaMEQ5?=
 =?utf-8?B?V2M2a1BjS1VuVUxNZDc1cWZ6c3Z4dVF5U2RPTGN2OXQ2eHBkV210TmxOejlJ?=
 =?utf-8?B?R25DdjZISzRINEhxeVhnTW9KZTNNMW9YYndzVnhsc3ZXeFBZSmphSktOVERH?=
 =?utf-8?B?dEFCRTlkaU1la2RuSkFnTjNqdDBkSm1wWldteDlVQjQ1OU9FTVZNbUIraVpH?=
 =?utf-8?B?TGdrdDNwZ0tGQmFIVG1wS1ZhZjRRc0NNWEoyRGEyRWtGUDVWcFBTeU9WUUs3?=
 =?utf-8?B?aXg5TFluZDNsa002WlBtMmhSOTBRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: defef58a-fe4d-46a1-e831-08da011c8a80
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 15:58:52.2168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o403bKCWzufZCzBr2pIJP4fxpOOb/rSGuWWbETr/5drT6pFsWAYti4Dmur3r523OhSRd+jOHiUX35J/js+B+Kg7gwqmb0UKKpdBARjB+bpM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5715
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10280 signatures=690848
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203080085
X-Proofpoint-GUID: unQDE3XYcSOcn1Ef7OiB61yi4CARW5Mz
X-Proofpoint-ORIG-GUID: unQDE3XYcSOcn1Ef7OiB61yi4CARW5Mz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 10:59 PM, Bart Van Assche wrote:
> On 3/7/22 16:39, Mike Christie wrote:
>> -static int iscsi_iser_task_xmit(struct iscsi_task *task)
>> +static int iscsi_iser_task_xmit(struct iscsi_task *task, bool dontwait)
> 
> Arguments with "not" in their name easily lead to double negations. Has it been considered to change "bool dontwait" into "bool may_sleep" and to inverse the argument passed to this and similar functions?

Yeah, I'm not tied to any naming. I just copied the name from the
network layer's MSG_DONTWAIT flag.

I was going to suggest something with "block" in the name but I
I saw in your other comment you might like something with sleep.

may_sleep is fine with me. For the queuecommand related field,
I'll do a sleep variant too.
