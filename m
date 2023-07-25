Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D5EC001E0
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 11:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbjGYLTy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 07:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbjGYLTw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 07:19:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D69C19F;
        Tue, 25 Jul 2023 04:19:51 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36P7oTSl008349;
        Tue, 25 Jul 2023 11:19:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=GHayUbFLrW0aRTKvkC+p4Ma3HTcXSnT3wI/DyhyjBuo=;
 b=FrH7mgFQm0l/S4fJ1VNpYC/NOpL+ftShj8YM0CiTT2GNN78U2ZAsKKcDI2vPdMEt3aqp
 OksRF0L4b4YGu7Bjlut0BYUm2Oagomqfocnwabr0ciWzGlHK9v5s1Olh7z3i7Bs/a6OM
 RzZLnDMiXALVmCnzwu/OE1ADv1Y7l92jz25+IhWkz9ijhAxBoUMZj3VYTm6paDoKcroF
 Wu0t3sl4upseHqVPHqnDP4MOvjwK4plDOXYSl9ozeShr1FtyPS+FYBV84AQCf7gRdmtz
 jdBCtVR10uAnSXQymxp2XOMnJ+6nM30PpjZ8vhNcnLyHigWfhoCinNvdBlxLcO9QlZb5 zw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s075d4u9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 11:19:43 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36PA90fP011239;
        Tue, 25 Jul 2023 11:19:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05javra3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 11:19:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIEN/eAostrE2JeVazo/Z4AP5FeEkc5YVT4vokAK5dy6gaPJwJvMtV1EIwLnOLXf7Nj88KqDNMbt4k6ZYfNRveRi1TfXomTyQAyUYYwWuXm2AvNIM8B3EoNMwo116+zv1efk3QtNp9Mpq0RC7zqRRCsg91PCTqJGJhJedLzXBBQZf+BSMFUya9cBYSeL/giRPIZuyzFtrmkEalOIRBJCPHQ2QrAdlrigJP09Xak+/KOhsMWM+pb6cjlSvapo+wO7F7oR9eLGSJRF7GaPe5sw7UySAtvxnpYbR7lfLBIGwUOvqd4laf4Hz/3ihUUeIKkhmqgGbAOBlKIe5lDgrhqjyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GHayUbFLrW0aRTKvkC+p4Ma3HTcXSnT3wI/DyhyjBuo=;
 b=NKssVsZr6PyiEbnY3/wximLvciISnvPpvjUQuwiDGM0OpAc6Nx0e0x7BaTBBQoLRYk9DzoB7F+WCyPzBaeAURFXweryWeTa4cXfvyKKIwHo8CHS6n5J19Ws1OQmXQKqOY8SECTKFvBk7mQlLh+tmGpZmgj+l4B6kTIQsglb+iMybzBC1UtXv1Odd23iafqyNFgYHT5HbM3R24XSvdh4WuSSxm6vw62NRg1pfyALE9q2cHzKOlnqCkkxHSA/RFF2yG966LfGdZ6gCeZOvDaAMcRZqkJfBVxoKSlyEINMgQaurwB5X6bdc9GlrSZsZe3R8nzdF1vAnjzKG5u3s9Rya1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GHayUbFLrW0aRTKvkC+p4Ma3HTcXSnT3wI/DyhyjBuo=;
 b=vqPQy9I5/YG5BeiroKOjHfkrWhDpb5TOkK6NZNGJXkxMCRjPPSYFE2kDLJo52scPZNZHHOtCcXTBzHzir50vMesJiVOjpj9XPjQzn6gkA9eZX5L6R9+rz0iaMcAzNrZJ804JmtvgfKAWWrd26Eu37PMyYAraQ4eFwJuY/N7GDKY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB7348.namprd10.prod.outlook.com (2603:10b6:8:eb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 11:19:41 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Tue, 25 Jul 2023
 11:19:41 +0000
Message-ID: <73bdaffe-3bc8-4ee0-3858-0d122d59babe@oracle.com>
Date:   Tue, 25 Jul 2023 12:19:36 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 8/9] ata: remove ata_bus_probe()
Content-Language: en-US
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        linux-doc@vger.kernel.org
References: <20230721163229.399676-1-nks@flawful.org>
 <20230721163229.399676-9-nks@flawful.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230721163229.399676-9-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0040.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB7348:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b0d58bc-4054-4c76-ae07-08db8d010a49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t72+hLBuXp+2SReRXyOjuTK2/z4sMXVjWL0e66Ycwa96HZ+HpjRLx1qcjsAekwAuNc2cWvlsLgnaPeIzMlZl2FJt3rFWVsET/udD/ZK+lHBm3XZ/7mg5rUvnp3cPw8VAvC4fuHt0UwAZx2AL8PzwgCRlEzMmuN3uFoP0kz8wnR4Oy+OV1wyUbQvhqS695bnVqaowIoZWThafrIRIAxV7DNnB5PbLHtgEvQHDAxjFPjVNk4/IFawJauzjr8ym2ahjtMER0q7rnnPAY5+hORcPPoZOS1fuSojQDa+gCsMQ9gUPvl5jan6baejmkatoj9/CK4/QEOpg5AzRpSNOSwWtPEmzawT5b+End7hrGSCvQcuqy94m7QOOcUMfWX48pX30XQKsh4zLCLNQD6fHb0n9bsqemi4LmYyDXp0Nk08oYNenmrMM1QwXjvXL+YmiERcuMNBOw4OutBiRQms8okLM5QPyW98u+mASwyx7rADEunvOPnOvSFevtkE6nXSLLp/ekpJzFpY5I4RPRWJeMEpe2omciNIuk8RfncEcBS5FbWdujgjDEETIl4O2kc9sRqe/IMZhgRnbDWwM9ZgZaD7F+69MvDmBKQgYqGWJburnekH2WHaOnvUNeq7U20l5NyQcwE/7TiwX5p+xl/ebFLVS/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199021)(31686004)(8676002)(8936002)(5660300002)(41300700001)(316002)(4326008)(54906003)(2906002)(66946007)(66556008)(66476007)(6486002)(36916002)(6666004)(186003)(26005)(53546011)(478600001)(110136005)(6512007)(4744005)(6506007)(31696002)(86362001)(36756003)(2616005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REVNMjRqM0FNNXhIY2VDQzhYVEJKMEdkN1V5WkM3VHdISkhVekU5d2NCMjFX?=
 =?utf-8?B?aHQvNHJUZ1dxNWd0TUtvMFIzcFdueUNzenpucVppMUF0dlQwS0NSSks5MklR?=
 =?utf-8?B?L3JONVA0VmM0dUtPUU43VXB1cTgvaGp0ZkNETTR3UXJzYktLUTg4MlQxQVFw?=
 =?utf-8?B?TmYvbW5tcU5STFdOK3BwQzgzQllnZnlBMmhPTG1XeURLaGN3amZ3VVMyR3hq?=
 =?utf-8?B?NFZkUEdvWENvVmIxSEdCSlB0VWRGc0NDbllnUUl3RjZxNExUemJkNlBXbUZM?=
 =?utf-8?B?Zm80a3ZOT0dMU0d6RFhjcUxBTVRscFJDYUNHelhZamhEQmV6NDMwek94cGpQ?=
 =?utf-8?B?Nzk3b2F4NkJBTlBzdnczODVlTDZ1MWZxNXhqMEhvVlZ2aXBOU0ZTdDdLRjZR?=
 =?utf-8?B?M1Vxb0k4N2dXbnpHOFNLTU8yWDlTQW81ZkpYVkVIb3BYSTdDWDBCZjhvR1Q3?=
 =?utf-8?B?bWRxaVU5ZGZFN2trTXJhYzhRSzJNTW1oa2xLZ0tLRFF6ems0SUgrYjBoSXgz?=
 =?utf-8?B?Z2dRcjA4OGRDWGRaZWVYVmFJZmdqYkFIa3NXb1ZnYTRKa1RjTTFGMSt6V3Mz?=
 =?utf-8?B?ZTdtMWtNSWFIQXh4VGNyRVRBYVBoTGxLZTFtVmdpbWhWNnFRa2JUS3VSZk5P?=
 =?utf-8?B?QmtOMFBMdkN4V0FlNWJhK25MMjVvTkdUTXZpb2U4cnlQMVBrb0k0NlkzSm5E?=
 =?utf-8?B?V3Uyb1VqeDVBL3dueXNhOFVVdDhNUmRBUWZKcUgrUnlJODBiZUsvNW9obmxs?=
 =?utf-8?B?SHlUcWhIZ21NVHhjNG8wc05BNG1LaGh2YUx2UVlYMDdVbUNaOWgyNXNJeGZt?=
 =?utf-8?B?SkU5U0hmcyt0ZnVDVDhMS3NhbHBNbE1oWUZSQjNNUGtia05qL1VINk00QW9N?=
 =?utf-8?B?WnVHbllCM3BvRUpmakdxRE56TzNGbHJuSE9Ga1o1clp1cC9VSlRWQnVZRFQr?=
 =?utf-8?B?YzIzY3pXcWowTmFvWXlmRlRucDhVR3FWZm1wcjdzMXJXeG5qVzdFRnlyQlRW?=
 =?utf-8?B?MzdmQXhGc2V6ZFdQWisxNWRkM3RsdkU5ZjFybmxNVlI2WG1MRkZzb2F0RlRJ?=
 =?utf-8?B?V0QxNmc3VE8xbFdMTk1tWGJQQkZ3eWxLVjBTZFFTWDBhcmY5cjl4VzlUYTNX?=
 =?utf-8?B?RkNzVFEvMXJIaks5OVNWOTYvaTY0OG1wb2loaE1jcHh4RUEyZC9DS01sMlg2?=
 =?utf-8?B?RUhTRDM3aXlLOTNRSGt2WmhhZTJOK3M0dyt5ZHBzeldRYkFsTWY1TFZvVGZ1?=
 =?utf-8?B?SEZtUk0rSUVZYW9QUmlCQ0JtemVSeUxkUkltRlFBZGpTanVwb3dSUkFYQXZo?=
 =?utf-8?B?S2xZVWpSZ0tDSWdUOUpaUGF5c2FKL2s5OXo1dUUyeWhxTnZwYUFRYXJOK0Jm?=
 =?utf-8?B?UGtkSDVWRkZjbDk3MDlETzQ0aXR0Uk53T05zSFlqQmRVanBKNEs1Nzc4bUJv?=
 =?utf-8?B?cWtxU2xhNExud2NVRGhjZ1l5azlMZFNCSy9RSlRwdytrVFdYNmt3MWdXdHFi?=
 =?utf-8?B?Snh1VGNsU25Fd1NYS2kzNW1MVVVVb3BJazhybHlwNGRZaStKbFlqY1owRFNC?=
 =?utf-8?B?ZmNTMjAwNkdsdzhGdHFJUkpyWVorbE1OLzVxZ0xCS0xjYm1OZWdOTjJ4YnJ0?=
 =?utf-8?B?cCtPSGtESGh3UUR3N1lSUXR3bWdrSVNRQlBXSEtPSjlPNVpzbjNqdHJ4dGFy?=
 =?utf-8?B?cmdRTWtTL3k1WjFSSkVIcEdvMElDN2lCdjBNVW5wZ1dzVU0wbnp4YjgwWWtC?=
 =?utf-8?B?ampCTDI5T3Q4WmNPbzBXWHpqWVIyZGlGVDFkRWdWUkxoTnA0S1QySWE5OHk0?=
 =?utf-8?B?bkkvSTlpMjVURWFkK1lDWVVIM0JTUkhiRWFkbUlqQ3h2eHEvTkdOdTh2eUpH?=
 =?utf-8?B?a3FFVHV0MERBYUhWMkxpUFg3LzJyTWJ6ZnMrTVJBS3dTNW5vZHVqcDI1WW13?=
 =?utf-8?B?ZkI3K1BHbFBLRXJOSUtTTTI5N0RxNzNRUDZZd21YSzBzN1Q1czNrbGk5Z0hV?=
 =?utf-8?B?YThOSy95R2xQODNRdjBqSjQySXJIYlkwS3Rra3N5NjZ1ekViSWxrd014L3A0?=
 =?utf-8?B?aU40c3pDN3VIVzFNL29OZ21Jb1FtZWxFWWFpY2t0WWRVdFpyYWoyZ2RtWFNs?=
 =?utf-8?B?MUxsdGxzTS9FZ01neUlVeFowZ0RyaGtwS01XZnhnUHFldkRONXUzSmJidWRU?=
 =?utf-8?B?UlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: zys3m4WRIs53oF3XyoL/ZNIPFm6MNn+wrmUTi6TKpBw6zw4T44LzR7L5X5zEDRNb8lkKBdcMWt5caevZ6SLJJLAKoSjWGoR5keC9C58g8ai4q7VgF7hefNzVuX1h8xnoAesM7/RZZMnDciEX4TeJrNOeT7sW1pMxSbT/uZlDb2nPzD3Fk9nXOx09dQvvGan/4BpRVTEXlUaqcYi+cXaEnG9iNflx957Y0NnoA7bm9TgIn94u16+u42do0RCK2sQAZAvImUcs25EL/3S5644heaDx/k+EcgBMxPxSB4XSyhkTrxhkkNaleRb2RyIsEyZ5MMj21gLOtmJVcJnOF/Gn5c4gZ0FtyLY+V7sF8Ts3Ua03uO/qws1EazwHDftX7suIEf1gy1xSbTJA2dlwFAIA+20pqYUm4hbmRv4mrJ2fbZEpLTrpjM48wsC0AnwQXjbOWNlI9FNKWEt3ziuRXlqU6JetHN1b5pdlECEDXZiLaULcve8ymfs3tX8JMRwRWEeorYM85j2p0Y+RNAOR2elUr5V8+cH3tHtxtRDh/hO+9PQvdK8+qGhNfsJL3eOl0QNOcqs+gq/n5RA3yxKg+r2/spUo7bg2LCrlfBdfBY14WqmebSx1RhlwQeA9IwR+EDADklNXL+25SfPKQb1Zd+mozqBMb+uQ99wfnQYF2EoNN5DhO/C91ytdv7MoinNJDfOMPnuUGNhO1oPEb64u7yJv9KHqwcPTD7vGFR35nfAr5N37FT//YBUaDa1uVmVv+QQtHAvnE6CiqOD3ClF7iOOFlCWlOa16M2MZ6hmTdDGBeXreQARPTZTr3b+FC1XGc5wwvmyLJ0xWmsUGh7xm2yRuua9/KkuYQCWmxBD3qs1Ri66t5OcY/sHU7BKMwgFs1Zicdc0UypXPazxC43I7SyKtEg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b0d58bc-4054-4c76-ae07-08db8d010a49
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 11:19:41.2608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c/HmYU/wnhFhCCtWuw9fUHuwjaINaUBJqq+w5bry74TJ9EC8ilK8cO9158WzGGSsY/f4aS2N+WsteubeLsCTqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7348
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_06,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307250098
X-Proofpoint-ORIG-GUID: dhIbcguHAZ_WzmGoa2WfdKoHsAXgS09C
X-Proofpoint-GUID: dhIbcguHAZ_WzmGoa2WfdKoHsAXgS09C
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/07/2023 17:32, Niklas Cassel wrote:
> From: Niklas Cassel<niklas.cassel@wdc.com>
> 
> Remove ata_bus_probe() as it is unused.
> 
> Also, remove references to ata_bus_probe and port_disable in
> Documentation/driver-api/libata.rst, as neither exist anymore.
> 
> Signed-off-by: Niklas Cassel<niklas.cassel@wdc.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
