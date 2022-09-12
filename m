Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B52A0C6FA82
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Sep 2022 17:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiILRuX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Sep 2022 13:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiILRuW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Sep 2022 13:50:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB6918E3B;
        Mon, 12 Sep 2022 10:50:21 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CHYRua031043;
        Mon, 12 Sep 2022 17:50:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=6IYxCSipw+GE9pw96Gk3oVa0mumphu6XWY/JRtWrIB0=;
 b=Cp86DNOQNmyNwqM2JSwHLzTvQLEMxRlw7gn3/y1brjn7fCtDOETkhf4b6UOFblm/cXu+
 Rgg+XoRiZGRjIOqUqlnEqLk4U4bqZaNbLtQpFPDP+M6Ra2qovzWZtP47338+Eji4HBuK
 kCo/c7wYyJAOkAf7CVC2aWr+4WbBi1fEUd6XLWWVI8mj7gjUill3t1DMKWuViBQRcL7c
 n5aLFX/e2flBqHto9iswJfQXlN5YbRiDEukNdF1pjgXdZXerG5L1ZVHB/kG8NPEnllKW
 YZaY+wMM8M5zknpUGbnoxARHFfGoyEVPgso1tfE8FRTw0jL52i7paIZKZcarhj2Y1HPg jQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgh61mc17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 17:50:16 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CH5JTD010228;
        Mon, 12 Sep 2022 17:50:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jgh193nvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 17:50:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LetBWwVnWXntNw4DOoyZnxmhIlSZbQZ+mxFzxpZmmlxYYaKNVtdybyvMB3q4hiMa1eAWidVP5T+XiKj4WQbVeer+vbt3oo0POinC7Kw1ZTfLxSt04/5KuEu6IKI6v4zdffbywIyOuLuSXBTdB0ZeCgNZlNWoSQBEhj0AGx/HsnEq3t3quhRdP4fo8pUeWcq7uOzog+CCSSb59w8uyxKpgybvK3HlJ58BXazhvOJb3ifNf37bB+cPMyu9BtlPEiKim00kMuEQs3LE/WljY7KJPLddjRFsNo+cCh3lqeVimuWwGyi4XnwhwxvQxrS9YiyETHAZ+fqxHiWoBz7TzXSOJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6IYxCSipw+GE9pw96Gk3oVa0mumphu6XWY/JRtWrIB0=;
 b=bndQBih1P0ummigtQ+jOi+5LYwJ+tFWnaJGaNAqmVQUd/UenrgbuEAKG/P7gwbOdu/X0ANib4z/JEIf302N7D2SA+/UXk1J8tZf02DgbDtBTyF+xIj3bR8DAQMRnRBXB2wNHaIUZT1LILYQFCK6OPbDJITK/K0U0nv9XQFhnUbiSxCk+u6V4uN5aaxDbIeaJpolpDF8lS/vaNWPZeQ9nS7SU8YjlBXzCmjJIthET6TQ3olChdKDBlqBtkaCiXid7dG/wQuypeUAgW6qaWTd+6mcnmVzv0GOkxed37/Zwz1m6FZGJKmAaNSBWdUpQjOJ3+OuYwBbYQ2neu5LrS3YpIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6IYxCSipw+GE9pw96Gk3oVa0mumphu6XWY/JRtWrIB0=;
 b=R5rOyYBzVgGKMzFdaiIve6s7mBH132UlNtDB29CEJAsEBKEihFrYRvxWSn7SKzXqapowXUfQKRKYNOheQ/nWV1hj15Ae9P1us6l9tfNHL0D+rco1b7WGoQ11b5ImJkBzOXlWLqcEe6XaEQIvJkAMS17jYvviGWjFJQujugfcBJU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW5PR10MB5665.namprd10.prod.outlook.com (2603:10b6:303:19a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Mon, 12 Sep
 2022 17:50:12 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 17:50:12 +0000
Message-ID: <3f410ddf-cb91-80e9-0e40-76b5fc63c92d@oracle.com>
Date:   Mon, 12 Sep 2022 12:50:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2] scsi: target: core: Set MULTIP bit for se_device with
 multiple ports
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>
References: <20220912125457.22573-1-d.bogdanov@yadro.com>
 <20220912125457.22573-2-d.bogdanov@yadro.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220912125457.22573-2-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P223CA0021.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::9) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MW5PR10MB5665:EE_
X-MS-Office365-Filtering-Correlation-Id: 208666fa-d195-4395-9b95-08da94e73ddc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h2dBkFugx+njISmok3axTsVl8qPTS172uLDiKxAPv/64RZjheIbzpf8wiaB4U04AXO4Hl/lLybZQZigCFxbmbZRZ4gJAgS+8P9m+Dzc95J0ln9TMzoWX5UwZ5DAftcn0oCFWFelPUw2LYmTRGA5z2qjUdnQH4e9keqf42DXq8n4QHwaoehT2SCDjFuRvRBeXPHrEENbJgduW1PAWMGsqPi9Df8Ecv4xXs1sTACwd1iYfgr0/JZXPELEZmgr46tXAZl6hEEm4A7IlHD6Sk3BhbHGr1DZV6Sj/l0uNFuZs0xE56ee36681I5eTc0N/AMC+welCFgy9j4bNgkGimtJp+KovVkPZWfIr3ao1AJVzF57QoZoslVMXn+tAscKiHAT2Eg9EPZCfXVauANOt8u6jkpqXwefMvOOkiq0HpB/jyExZrAiR25b2oDraXInnMZFmYYT0+eJo1o37wqq2oNe6B9noz97Lh666F9IElWsQjsuy355yEuPXYNTd0lOKNjSFEkRHwKdmlwjZJsxS+UWo549OlGlRHdRTaY/PlkK+uj3dzpE8w3TgH7dxFHvBxA8tliRHwaeS7+2q8bbEZ3aSPTzhfaGY6SZglPQ7QwDxZuqi08TPOvEbgACHYf7zYG7hBeFpl1m5nD0v5HyXDZ0eEabyuTK9/aL5e3lBjCNJNywprGS9vfPq+FoF8gg0C5dwokUX5aGq/6lw9vrmd+6R1eWJcPmHJ66ywDaKqVLURfNFgiGP/+XlTq/Sqtcn5VxP52sRATj+2yjs5JuXphi8qoQ2SGYQUqREATwMLJcpv2I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(396003)(366004)(346002)(136003)(451199015)(26005)(66946007)(8676002)(53546011)(6506007)(54906003)(478600001)(2906002)(6486002)(31696002)(31686004)(86362001)(66556008)(6512007)(2616005)(41300700001)(316002)(110136005)(66476007)(4326008)(4744005)(36756003)(5660300002)(186003)(38100700002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wjkwd2RocDdXTGRLZU9nc3QrLzVHV09Hbnk3Z2JWSUZ6K21zbXY3d2JxTkhj?=
 =?utf-8?B?ZDMxd1RSMkpOVmFmVnlUZzQ0TVFGd2J1VnliN1dxN3JidmpPY0xQSXg4T0Ru?=
 =?utf-8?B?YXpQQzgwL1BvS3FWaW1NUkJSME0yZENWNlFvZ21Sczk0czRDd2thSXNsU1N5?=
 =?utf-8?B?dk1OSGx0d3hENlRnNXFiOE5reEhWVUlVeVM1WG9IUXpuR3VPWG1zZEZJcVdl?=
 =?utf-8?B?ZWx0L2JjZWdvaHNxQ05Hd20xYlQrVXMwTVJPRTdrSlVjcWF3MTRBRVEvYmUw?=
 =?utf-8?B?NXkvNmpqcVdRRXo4d1BwNUVHemt3Wk9rS09Ba1UrWnZhaWwyMEJPOTNTc25P?=
 =?utf-8?B?TTlJekUzem1pcU9xeG4zaFJTZ2VoVmFvckl6VUExQ0VGalBVdHp3c21vYm1R?=
 =?utf-8?B?WmF2Q3BVdFV3SFNuVSsxZC9zcXlONEF1Q2lvZTExKzl0a3lQay82N2diWUM2?=
 =?utf-8?B?aks2azBrN2xxaGVWdnI4T1lFV2ZzTU5FUjlQd0VkdE5QVWRZRHV4Qk53Nk9M?=
 =?utf-8?B?SHpENnpPRWpHR01xUzVWeHlIelBENWxsOHM2ZEpTSHhONXQwUVA4ZDRJaS9h?=
 =?utf-8?B?d0xZY0VrbWJ4MzZWbHN0ejRSeFNmclc0dU9yT1Y4R3VZdnJXK0pxTmZIdWQr?=
 =?utf-8?B?VDAxOXhpVk1PcXJuWFVZR0xGTkRCVjltLzJKbmcvQ1ZHK2lqUDhjdFIybGs4?=
 =?utf-8?B?cCs2RjNoeml0NDhaQXIxS25Pa0tGdXBoaEJRNWhxemN3M3hIYktHVXZBTmlw?=
 =?utf-8?B?UU9ZbE9BNjgwTWFIZitHOTQ0WnV6M2hwaHZyNWp6VzU3TndBanVSOThBTS8y?=
 =?utf-8?B?ZTZJWmw1blJLcXJxd0R2VC9qMHAvUy9XS1lhNENkVUh3cGJaTjl4R2hqSkt6?=
 =?utf-8?B?a1JNRm5ORHR2SGY3SEVUY1kyZGFOZktJbjJobXZueE0yNWtGdk5YQmJkNE8y?=
 =?utf-8?B?MnJYcmcvS3A3K3FYM1JLOUJKVVpaelhsbmtkemZLWnRoWDNuTHI1N2wyNVo3?=
 =?utf-8?B?Nk1sYXhDcHpNcG96Sm1qSHJwTVhLTFZwOTg0SVlFNGNiSUlTRmY4THZWMHBy?=
 =?utf-8?B?NmJ6M05WRnhkQnZYRm5JdHVtTXBnUWp6UjdoWlBOdEFOQmpXVkNEbmYxdTNO?=
 =?utf-8?B?T3FiQjVSNms4QkpKWUlPb0ZteVVZOTlVRTlESGwrRjR2SVJzUDVKTEJJdGJN?=
 =?utf-8?B?NEhQZ2tjdklkcFhtM2pwL0R2bmRDZEJHcU0xVzM4T0ZscjYxZTJSK2tKS1Bq?=
 =?utf-8?B?UlpDL1lzemtRWGlQOCtDcUs5clZNLzA0a3pmK1R3ZUdFSE5sK2ZSd1hoSW9P?=
 =?utf-8?B?WlRpQWlNbjBTZERwQUxGS1gvMmJJQ1JlZUNUYVZ0MU9QWitjUDczTngwbHVR?=
 =?utf-8?B?UTZ3OHVhYnA0b21EcDdnUkd0a0hmbXNwZzNzRTNmaUJxSFFZU3hxRjdSdFgr?=
 =?utf-8?B?ZllMSnZpQ0k4MEtKcDBXT1ZyQTA4d3VsSVlDTXJ1OEdHZEZORUpDWXkxUzB0?=
 =?utf-8?B?OW8vK3J0bmdLSVhGcGNNWTZVRFJVM3VpTWNjZ012TCtBbUliOXhaNmI0dXBM?=
 =?utf-8?B?bDV5QjZpaGZxN0p6MXZhODErUEJFODNKc20zZUtyNnlSOVRnTGVTWitzMkFO?=
 =?utf-8?B?QXBJMkM2MTR5RWx4NHRaRktFSHdWTEtRZzhQeCtTNkFMUWZ4TERwQ3ovcnBv?=
 =?utf-8?B?d1RyUWVCWU5iLzdlOHF6L3lKdm55emZqb2JiRmcwUlBwdm0yN2lJNWZzWUtu?=
 =?utf-8?B?bkdNK1FUZHUvZFFXcE4xbS96UVNtVEkwbjhNWVlsVU5nYVZLUmpRNERRWFJO?=
 =?utf-8?B?VVZDcHNyeExLVkhNQkhGV2dPNkVsVzRoUFZjWU1UamNJcXlQd1NZZkZObjRq?=
 =?utf-8?B?cURNVTc2L1VpekJBaVNnTFVhK1k1c3Q1WFRJOUFGalYyL09PdWxINjVSd2hZ?=
 =?utf-8?B?L0F5eCtxR3o3OHI2RGpaSCtyT2NXSWNpakhXMWg3NElJbUdiQ2Fqc1BINDNi?=
 =?utf-8?B?UklVUU1XeGJRRHdXbFFpcU9rd21RVVBkc0Q2cXcxWU13UVZaeExmVTd4ZGRu?=
 =?utf-8?B?SjdnSnJjeEd5MHlDVGZYa3Y0d2g3Yzh5YnVtY0lHeXo3blA4bmZVN2h4K2ZM?=
 =?utf-8?B?QzZRN2NGdHBjNFBOdDNWQWlmczdUeGJWcmFNSWtNWS9kYVNnOXJrcVU3bVls?=
 =?utf-8?B?QVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 208666fa-d195-4395-9b95-08da94e73ddc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 17:50:12.3508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lo4MqdQCZ9Nw4olhKrEonPjcdHX9GKMMO0SkX8HrWRjOn84iQTwXitEiQdQb9BWMz6+5OHzM7E8MCTRpUNkvBpJd5VsyemHA1AbMhF3QOIY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5665
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_12,2022-09-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120061
X-Proofpoint-ORIG-GUID: ZNooyLZ7smilcj66xKTxSimlOz2Vhd_j
X-Proofpoint-GUID: ZNooyLZ7smilcj66xKTxSimlOz2Vhd_j
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/12/22 7:54 AM, Dmitry Bogdanov wrote:
> SAM-5 4.8.3 (SCSI target device with multiple SCSI ports structure)
> obligates to set MULTIP bit when there's multiple SCSI target ports:
> 
>> Each device server shall indicate the presence of multiple SCSI target
>> ports by setting the MULTIP bit to one in its standard INQUIRY data
>> (see SPC-4).
> 
> The change sets MULTIP bit automatically to indicate the presence of
> multiple SCSI target ports within standard inquiry response data if
> there are multiple target ports in all target port groups of the
> se_device.
> 
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>

Reviewed-by: Mike Christie <michael.christie@oracle.com>

