Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2321CD37AD
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 22:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjIOWHp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 18:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236475AbjIOWHX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 18:07:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B627B1FDE
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 15:07:18 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38FLxYgO007900;
        Fri, 15 Sep 2023 22:07:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=33L/senSxbMPEn0G4nlIzTqdJqM/xlv6ZEwOrdGJjQA=;
 b=Qr/4PCP7Z7vMza9+uQcuivg4Uo7JRrOhTJ4TAgLdvzjVVyxXwhGJDlbznPBVW0BfUK9u
 pvyXxSfptPhtBskIWPdWBa6o3lFROkP/yJ5BshKKzPlnSZlphYfkktEhNny2qCnQAQcI
 zSGOGtpFh5mIX5Iw1U1wcF8g+su8RNmwoLMb60DzQ9XNbU96Oj3O3mR2V02I6fpLWSBB
 onJ82O1jHGU2bz8QCA1le/6tVdpVL1DgcIwDVjVefLS+F+ml0Fzlp4HkL4tCQysPoDip
 J7IDb2bUv+s1x9M5PB8L5TlcB2eZr/qKHyWC4wK4h/HHdDqX86UJ0uupNQXzDPC9l8dg 9Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t2y7hgsmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Sep 2023 22:07:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38FJZmpB007464;
        Fri, 15 Sep 2023 22:07:09 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f5bcy2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Sep 2023 22:07:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hyaNF8gwAwoTC7u1M9RgLZ/crPK+sBXy38Hg+KaxYJwc6jlA1iT0ymZMj9EDXKjyMXUk3OpvL9/JUijFsmEYuCoJClGwzSYXIH9FJ4Om854XUD2LgHbG4HBjSRGREJtodMuOKmO+WyYGahLuIlSHaP9qmHHLVPWcdO00LmFBdyL7jb2gM0jRQeutaqguZ7EynXydXGEUT7spP2PZfqx5XuYZa1obSN+FeCSKBqzkSSByvlx9vlVJs10x6MwOX7eT0gKiC/GBI65Z3Ctqloy8L/dDPiocp3pmrNnKOUb9RtKdl7HmujK+zKnVGybvidUIbHd59LqSsrZvICdIQxUOQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=33L/senSxbMPEn0G4nlIzTqdJqM/xlv6ZEwOrdGJjQA=;
 b=iy5xcbq+tcVtnU6yhJ8wsgujah6k0QgzsNQwdQCzSf8Z5RwyFx6eB1wtAiGedamtkn5iX1DqemCPec2qHpQt6/OAAuBFwbCVgxhCXkiinx/3fs/6txcxCbFFs3XuJpFXIuWocv5cp0GXy7N3JMarPkmvvzFIRkoAzJVud/flrYxJSkkgEDICDIPmaDg49z6JTL+EMd6xWs98MZRHtEGjO4sDrW5neidI7ib7OxnDJ6I1Zg+GlD9RzuitX3d5NIaUIsPZzgHqlRyARuBpMde4EklmOL12Nn1X7TtoChGlTl4pzIOFn4dXrgT8eYfnCvGLTu+U7ALIr7mNd1wA1OmzdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33L/senSxbMPEn0G4nlIzTqdJqM/xlv6ZEwOrdGJjQA=;
 b=EbpIajT50kCcvc0qcBZcZBOZC7Vk02LgFS71JNjVaHzltNK5ycR7ikAG5C05fRwqX/5r8CMjJykcvJEefb3n86JB4thQJ6ActorKHEk/jqABtQrUKyiO6sFhHE1Mj48yjjr2FLaatTp2pB2uN96OXUmYMdwtkMnIfqw9BU/FR1U=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DS7PR10MB7130.namprd10.prod.outlook.com (2603:10b6:8:e2::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6768.39; Fri, 15 Sep 2023 22:07:07 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6768.029; Fri, 15 Sep 2023
 22:07:07 +0000
Message-ID: <7308cc3d-82ba-4091-9bee-a1bee840ff68@oracle.com>
Date:   Fri, 15 Sep 2023 17:07:05 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 34/34] scsi: Add kunit tests for
 scsi_check_passthrough
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>, john.g.garry@oracle.com,
        bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230905231547.83945-1-michael.christie@oracle.com>
 <20230905231547.83945-35-michael.christie@oracle.com>
 <ad9c20dbf6f0b0de9ca5e6821dde2c5a41d81d58.camel@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <ad9c20dbf6f0b0de9ca5e6821dde2c5a41d81d58.camel@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR11CA0004.namprd11.prod.outlook.com
 (2603:10b6:5:190::17) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DS7PR10MB7130:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b088594-3304-4e4a-388b-08dbb63819b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rwpj01mpc6jGpSs0sHhd7I1bZro7usc02JS5qr/oOKcAaxUfsxmJ5rl4esqn4VUPp14wj/6WpYUn6A9SmU9SlowkR+R4nRMjfMZk7AMfx5GgwmsA4c6QdAK7/x8fofm9ahL4xI43Ki+Z0LeuCLWzROOmOcgKpPHQJYimqcKgT2Ygj3KWaLX7TGk3GWMakLdYqf6uzum+NW6tAbxraqqJ60Zu1nF8rb9/WcHr0WVZ1Ae6LQgjpuh1IkjubWQ+k0cY1rT2l4yS1EuMtFgcUoHWqohv3xugYz7GMVk21oZddq14tTmoz6Ka9HpdoaCrBdX4Up5vS71kqteiHBOZAOU9sxC5hn708q3dUXeFohQLxjc2jDEvug0tBaeCBtKi4kNrzCvw5PsElha34l2IXi+t/l2pe3I1ZVk30rHwBNCEO/yJFvqNwoK1MehMkMuhfFPnKPgTRzznzwaxOR0zS3u24PWmNBwCfjSBzFZwa1L7hIbCSZTgb08KfxdmP1uLRA7VNqZAzFxTJdZJMs6+anTFGQ/FjxtioZQScXIXHm7oMD6sEMb0fflC66hx94dXxav1TkXcGfhm7C8IDFkJGmK167dUBHm2xILh2SeZ+8AzDtqYE20agybbX00xwp+W9LvxPTG9JwTbT9oNT2yt9Hs8lw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(376002)(39860400002)(366004)(396003)(1800799009)(186009)(451199024)(6506007)(6486002)(53546011)(478600001)(83380400001)(2616005)(41300700001)(26005)(316002)(66476007)(66946007)(4744005)(31696002)(5660300002)(8676002)(8936002)(66556008)(36756003)(38100700002)(86362001)(2906002)(6512007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnZiNHhLcHg0eGMxNmFmdmF3bGlWQWtydlN4OHljcFhMcnNFbEt6MThpTUli?=
 =?utf-8?B?SDl0SFlMdmZBY1FMZTZrTFJkT3h2OVZiaytpcjBNU0JMRUpxem90ME8xSzFG?=
 =?utf-8?B?UVJtYWZIaFZrMnppaElubW1DUFRSbUNIT1dFcy8rdnc4Q0M2SFJKMllGYlBp?=
 =?utf-8?B?eVlTdVoyMzNmNFVGK0dzRlhVTm04andENUxtb0xKbjJVQkV6YnQ3RDN5TkJj?=
 =?utf-8?B?RGtxbHkwYVBtQWs0Qm9XN2p3dVB2a3FQM0pseEZJZVk1NEtTaHlQcnZ2RUJR?=
 =?utf-8?B?RXhIRHM2MHVLUjdtc0wxd050N3BCVlkxNDd5d2tJNEVOZGNpWk5PMVQ4RExJ?=
 =?utf-8?B?SEJ5bVkzR3FjbXd1dTF6bXkrRSt0NzVqQUd4TkdHU3JqZ3RaOWgxWldlcENJ?=
 =?utf-8?B?b3AyQnZ0RmpBVW1YK1YxYVUvTUZoTlNoZm0wcFk2aERNUXJVNnduWFVRdjI3?=
 =?utf-8?B?QkRaMC9PQmhjVWpNUjlPd3F2dFVnWXpodnJFcTRNQUdVYW1YQ0E3NFZrVy9a?=
 =?utf-8?B?V1FxMHcyZVdCSGhxOTduZStlOWdtNEJETm8rWmUzQUxPL0IwbDJKQjEvQVZq?=
 =?utf-8?B?U2x4eTlUVnpibEZWbkt1djJQZHFKalZYdjNhVnJIQWx0YlU1TFArQys0K29a?=
 =?utf-8?B?dHJBUXVSRDRIVjNkc0EvRTlBeUpYQnJqTHZleHdWWURCNEQ4SGFWMjNpanRE?=
 =?utf-8?B?VDhxYk9MYi9CeTk2VnE0Z09NWDNTdTlzN01EMWtzcGg4Sldud28wRDhXQkVl?=
 =?utf-8?B?SXg5OTBhZ0Y2WWtZMDdFck5nM2c0VHVoUDNwbWpuTDh1eEtNam5iZUY4OGhK?=
 =?utf-8?B?bG8wSjFKR1QyWVNiYXdKelQyeVhQdnBnWmtIVURISHFaS1RMVjFVOTQ1Tks0?=
 =?utf-8?B?cHRwemRQdjBjTE9MaGZBUGY4WGswRndmbkQyZU00TkNzOVB0K1hvSVZWMkhs?=
 =?utf-8?B?bERCNTl5a2MxVTVrYk5hSDVoSDdPc21tdENibXlUTVRJUysyb1RpRjhyRVBx?=
 =?utf-8?B?T1lsUGlzb0dMM3ZRK2EzVWJLUWtmSXRIeHRURjNNaFFCSFlWRjZ3WkVYNExr?=
 =?utf-8?B?UlpqNXBTSmdkUnF5amNPQkl4bWIrOE1IbWdhVUxjUlhMbU05djcwSW1pM2xy?=
 =?utf-8?B?M1MzaE14aUhYTVNKOHI5bHV0eVAxUWRWVHBsOEhQbkhNWmVPempVTlZyRVFW?=
 =?utf-8?B?blNaRVJOdGpoTEJ3eDB0MHZaVDhyZ2xGbjJjNUJhdjYyTEpRSWhscWhTTFVz?=
 =?utf-8?B?U0xvbWtYN1RQS3R3elRYaTB6ZlJNdU5CVy9NTi90Q0d2aENaN1FZb1hJUGVS?=
 =?utf-8?B?N0Z4cE4wUTcrNnU0eXdJNS9YTXNobFpUZWFZUm12dDRSUU9sdGlCNFpzWVYy?=
 =?utf-8?B?R1ZXNTlIdHc4QXpGOEFLVk9NcHpSN01TTThtMVBMRUpmV1lJS2xQUmtLMTVs?=
 =?utf-8?B?bEdTMThNUEhyblNDamlSVHJKTXVmYkdIV3dISmYwNXlHc0FHbXJUb3hTQmUz?=
 =?utf-8?B?ekltTkUxamhKWkcxZ2ZXTmxGaFRFNUYvOEk0bVpVWjdUZHRFU0VtM3BSNXFj?=
 =?utf-8?B?RUVoUjlFdzVMOGMxTjNjZmV2MG11MlVhYzJzSW04T0h1bDM5M0UycUo2enRI?=
 =?utf-8?B?Lzhodk5OSk91YzlsR1djcWxWOHpRSndpTnRocStQOFQwYXdJUGZsR0xTOUNa?=
 =?utf-8?B?SHNmcmxVL09UTElGZlgzZTc3WjdwVXBZandRSnd3SHA0QW5ZaVpsTlMrTDB1?=
 =?utf-8?B?WmdpSmNjSXNlQkthWDhLRUJmNGFXM1NhN1BCUk1CSk04Q2NNRWZDRE56V2F0?=
 =?utf-8?B?OUFyTWN4cGhTMDlha3VXUUVud1lyUXB5UFFqR1c0TWQwSGJzbkIybVFUOFo4?=
 =?utf-8?B?R1lEVTVYcE5xSzFNMXNzNHNtRnJtWHF3SnRjbXR0QjdxMXVxR1B5Sjk1K3Nh?=
 =?utf-8?B?cDU0b3ozUVZ0QkgrWitKUXQxb1ljT2s3ZnZNM29lWCs4VWdMdW40bHg4RTQ1?=
 =?utf-8?B?VlBsa0JaWWN6L3lBZUczRVg3QXVENFJIQjJsSTBqNUxBWXRUNlVpREluUitu?=
 =?utf-8?B?TUxURlo2MmI5SUsyQS9KR3JwWkRMTUI1c1VNU2IwU2dHL2pYR1prSVZjYUVM?=
 =?utf-8?B?MWNVODQwbDhIOVNMS2hYV0tVdWxiVWJYZWV3ZnAxZkFvOEpNdDNJWVd3WVRs?=
 =?utf-8?B?K2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gvTesT1ixZcsAIkwCuMwcFfwJbBrGUm4xweTmpnpFxc/CVCviqVfmQqeYNvDQXiAlU/QeZVNZ6p0Qvad6UXiVqveLL3RYqCwMvXymPKSuokiFXpBjHtKjXBxVd67VtdrXPwVqSjI9gjMH+y3/S5X+IA/+ppoR07r8saltD6AS1+LnTWR4SNxUNE4UUYmb7KZSOLhfWh89QlU5gGm2qfacse7+odpGl3gGPnTwte0tiVNed7/YkmK/n0qIc2nXEh1rjkT1YROMG6LDm8MN3CtLEaXJb3czZgCdgBJ169mHbPfgUJyYyE7QieUJxyWZCQXugldOHqreEvV67xqpsHE7ojwQmaaTrL78qBjSHZ3lwauAquIpuM7Vtb0ydN6cr/dqbQyl9AsCIzeSZce/ENTNcKC8jAE3g4W93zQt1kZzO2LowNcQgxU5GTpzgGyHMDlec/H4xYP+RowRVi4mkDYyCsfQI7bFmPqQMsh8d395vtzD60MNoZuy0lhQSdqm6HO7RgTWK6WlfT0Ag+EzkFHHSjpyEXab8vkER1nP6Ecmoo7Zn9xdR8QtyZGbcPaVbeAP5v2KJe4WzPrRqJX5Nd+FS5mNk+oBexG2F1vgqAeGYFv/uBvT099s+buYCXpSYBztFLWanG/Bj6GDkfQ7GAdMkHXLAH8MOyD1EnG5Yo80b2f1sUlPJ1MAnWEGZZBneXlnVTDrkbIH98RSqiwW9uqMwEMhUK0ZUWCaKbyHgGgJRaBCfQVnpIfbp4RFxPfF2YX/UFyrx9ZKAAWms/8yOoxtwH21c/ViJMdEDmTpvJFqStYxjb6o+HBBzE/7loa8Rh4Ph7aPsWdpZp62K7IpPl6qPG56rU9Iuxn8G2dgSqJXU8NO3CCAso0zFHjZTAcHONl
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b088594-3304-4e4a-388b-08dbb63819b7
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 22:07:07.0538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IjRbIZrfLLvi5blHKDumbplLF1b9M99LV0bkNfF2f4xEYv79ex7juwe+ErZMmdGFQqL9byvn2wiptGSVZwg+5w/qAxmL1zNjEN8paCCGJSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7130
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-15_19,2023-09-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309150198
X-Proofpoint-ORIG-GUID: rMOmO7w7ygssir4WWHGyoobD3FLBbeQJ
X-Proofpoint-GUID: rMOmO7w7ygssir4WWHGyoobD3FLBbeQJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/15/23 4:52 PM, Martin Wilck wrote:
>> +       /* Match using SCMD_FAILURE_ASCQ_ANY */
> This comment looks wrong to me. Are you missing an ABORTED_COMMAND,
> 0x11 case here?

Both are wrong :)

I'm actually testing that we don't match (get SCSI_RETURN_NOT_HANDLED)
even though the caller set SCMD_FAILURE_ASCQ_ANY. So the comment is wrong.

But yeah, I also wanted to test that SCMD_FAILURE_ASCQ_ANY works so I
need to add a test for that. I had tested this but then changed the test
for the above case while testing, but didn't go back and edit the tests
again to have them both.

> 
>> +       scsi_build_sense(&sc, 0, ABORTED_COMMAND, 0x22, 0x22);
>> +       KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
>> +                       scsi_check_passthrough(&sc));

