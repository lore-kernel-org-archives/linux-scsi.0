Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49AF6CDB465
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Oct 2023 20:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346367AbjJSUCr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Oct 2023 16:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjJSUCp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2023 16:02:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14F99F
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2023 13:02:43 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39JJSo8P016641;
        Thu, 19 Oct 2023 20:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=gZgBHIlnj9rU5cFY/jK9IThvN+NzI6U9QOnyeaNMysA=;
 b=SzeZaMuIL9MVSJFC41saf7ISYDyl+w04AdZfd1pBZaY6tok6pR18Yw19rqGQO35yb3FV
 W0VAiCYkIxzgWh94Rc4Ay0pyuLSBUQqyEahiFpM64yyqEWzZhNe1ERjVmuDZcbAAjsTA
 ev2ha8cYZBMBVsxfblIwoUvICcEAk4PMqUCfNv4C9iaJwyUhvz46YcmkumqsXR3rm136
 prohmkr6EFool/AEQ3UmPG/lpAbeIqmXeVNn34vXRMMzZ83ameQv6dXRq6uQP4m9KWR4
 QvVKQSqoytxyqiimEos0eBOMOgCWB6nd2X4RPe42b+I9WELkPnEqJHTXNSdgc1homuE2 2g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1buf4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 20:02:36 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39JJOole026887;
        Thu, 19 Oct 2023 20:02:35 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg576sjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 20:02:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XR+gooBnzVDicX36Nf0qN3CmtkLoCcZc3SWi4z+4mu0QIsbpPwuukedr2pztJM2g2/zW6zIFI5pBnCOyLcF+nzOqEHJV6IjNPZMjhboEpFiSl5BdxUWywzf2AWQC+7aA+FP/ioPfh7hB/jTSBwEvtptr88eH5KGwYwNgVPl7GeEbclbWtJfWWGvUuNDuF+a44w0TiXLqrywyBOdvlZ4EMpaEk2WZ3ShtjijNFcu2+4RjTJtbibeuDlt/xmUOg/wDJxEGgLoOC3A5B4AVjunkJ38xv/wlLXK81QUqSEPB5grVi+mMCkpJTB4x5rBssOHtgl2vo0rDTUAciECMgLGV+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gZgBHIlnj9rU5cFY/jK9IThvN+NzI6U9QOnyeaNMysA=;
 b=mmStaC6pM/25K41IJWJMwYP9lLSLTgdjY4suuU5LtX9OPA+YudPb84ggYvE58umm6TA4XO4HvmFpmGhLKhGwXWcykb8JkdUazXLX2RauzsRkn9XCqV7I7ct4N+9QZfNNIu2mdg7d3axS+XRVK7Kwldb4ivDOz62JW99Wi1QVmliG10QsZdRZBrqMob6FMo7Fg8G7HueA2VSROlYkoVAsOnSWI4dW25NOc/ze8pUGlp9LG0Ppv6Gqc8ofc0KgE9ZfrGW/8fI4oyAijjy6NULvJpOB3bxnXz95JO5lm4oQS1fY3bW3RHjDEFoYMUPFfqPRV0r1ujlRAtfdsaMJyJ5JRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZgBHIlnj9rU5cFY/jK9IThvN+NzI6U9QOnyeaNMysA=;
 b=wWgDdSb5hRlTsEcFiaY4XbzGe6gHDFI3+0VaVB1/LiGYNWCHNLfIozzJPeJOn+Ix3bZLL5kd2r1VJIx6zWeY/ZtYwCUESzSSkSBkdKzEjAX+G6os1tAQdhz0FVZgh7wqvAuTpyQ2mbULe2iGUsF3PUdq8cM06XWR7E58X/d+jZk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA1PR10MB6519.namprd10.prod.outlook.com (2603:10b6:806:2b1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Thu, 19 Oct
 2023 20:02:32 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6907.022; Thu, 19 Oct 2023
 20:02:32 +0000
Message-ID: <00f10f98-46bc-4af2-a3f1-a1523c9f4e1f@oracle.com>
Date:   Thu, 19 Oct 2023 15:02:31 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/17] libiscsi: use cls_session as argument for target
 and session reset
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20231016092430.55557-1-hare@suse.de>
 <20231016092430.55557-10-hare@suse.de>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20231016092430.55557-10-hare@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0145.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::30) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA1PR10MB6519:EE_
X-MS-Office365-Filtering-Correlation-Id: c79e8d61-a7b3-4bc1-541a-08dbd0de54c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GTbiTBgwA/3NiJq20kw3QZRBCdjWnWo03hPaoPtxR0OmXJeSjX4T9Wgd7CvKtLQ0TfihW3uZUw+4RC+LSQhe5m7NUdTyCDNaSGeJdMad1yd4MEzMT9sjk1DdOQggmKbqDUaKBwqvDGjMlK/sAR3JZnEhCMR/0SkaglCwMQJrd2S0eVc3xaxzG3x2Mz6kPiodx8Ysg2Rt5IqO74eABOtouijqDC7jiYjUn4be49yPelIZDQnzOh8/1UqhZZxbCARYddw4zHHsMKbcamk9s2PKCdW7jGky0QCVsnvdYj1ZQsckSkijDG1aE80PZTynwMk6n7H7wfGIjVFQNMKZoCCf5kNdxmQbRAhylE18Tdyj+zmVRCzO2hi/eI/BnCwXxdw1ImCaR/6iv7kU+R5iQQjb9+2ZieODHYyqw3QiJbQM+rvCXGVkYxL3kY2TeWZojARL7wabReORni3QiKfXsZtLH38CxmOJLJH0b21fjncHuUh1YxLN/MYBCXJ0RAs4+HKPcUQkN98bv56/E2mLdUI7pndrmrdXqlx4RaHHoo77XcOBF33auQuvMGwqhkZ2wOdT6kx6zmwWBMFw611fDdxqVBR8TZAah0yZ7ey+n7cl/jHx9jngFKKQNJSt0IQaj9DDAPkhFdURASpAORuScsV/Wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(346002)(366004)(376002)(136003)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(5660300002)(66556008)(478600001)(54906003)(6486002)(66476007)(66946007)(110136005)(53546011)(41300700001)(36756003)(6506007)(6512007)(31696002)(8676002)(8936002)(4326008)(2906002)(316002)(86362001)(38100700002)(83380400001)(2616005)(26005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVVYd2lEUGpDT1dHNi9hL0ZhbjVEM0VvanhtK1ZPQkM4L2QxcStTVHRramJI?=
 =?utf-8?B?L0d5OHM2clRHQ1l1anVhbmRkaEdIVnNpbHBjOU0zVXVGaFl3WEgwT0FYNHJ3?=
 =?utf-8?B?NUxPTGdkaTRnZ2FjdnBRZUUrWmlQMXM0NWVHOHE3Ti9NVVlnaFduTkNoQ0pU?=
 =?utf-8?B?dHhYZGhScXI3Zm1mQ01QSFVrMVc5ZW1XNThtRi9DY21wa2NPdUVUdEZHcXg4?=
 =?utf-8?B?UG51TGZTUy8xbzQ1RlpkZEpaM1Z0SXVZRHNuREcrSDhjMU94K0ZYOGJMdWxp?=
 =?utf-8?B?QUxYRVQyVXdsdDFFdHYvM29BNnNWL0p5TkxUa2hOakluNGRtRlV1dTk0OU5B?=
 =?utf-8?B?aUFOLzdicnhUS1VjTk1ZendJMFhWOWxkVHV5UUx0WHNQSWcyd3ZtTDVETkRI?=
 =?utf-8?B?bkNTTitaZkhSK2F4QXI2NldIbXIwdGwvTndMNTBrSzF6L1l4UWg2bGZnSG5R?=
 =?utf-8?B?YWY4UGUzNlA0R3A4Skd1Q3dWVjZZcFptN0VMOUhhL1VyNTlIK0gxaU9BalAy?=
 =?utf-8?B?RitsOGNCTW5wRWlBVHozSXNPaWVmTkdUOU5zVDFEUXgyeC85SSs3N2RVZE12?=
 =?utf-8?B?clJqVFVrRVM1K2dQWlBRVEkwQ3lLenJmZWUydy8vQlV2aEwvdDl3emJnODBT?=
 =?utf-8?B?S0RvSTk0M3NBMi9DZVF1clJiR3BybldQOEhieUpYMEZkN0ZXWm1SOWVxZEdS?=
 =?utf-8?B?dDhHUHdlWllJKzRYeGYrS1A1dU5QeG9RTFVFYlE2dkNkeW1HWk00TDhpRVA1?=
 =?utf-8?B?cjNjUHBHWndRWXFubzZpZWxhL21tWXFSOFZXK1krVC9uU1FsU0lmcXR3eWVR?=
 =?utf-8?B?c21WRzFndEFGQjFaRHdpL01nYlcranV5TGtIeWFIR1d2MjhGekVSa1Y1SFlN?=
 =?utf-8?B?ZEhxN1p5QzUvUUlUSkdtY3ByTnFxN0preFdrTFhHczZFdVJnQ1FNZytHcnFB?=
 =?utf-8?B?Q2xKb1c4MDN6TmNReUlqOTVnSXZ4NmFNZEp6TlZCa0s3eUV0MzBMcXpvSVd2?=
 =?utf-8?B?RDJiZmcxajlZWFB2c2RZNjNQbmRDaVFOZzZaV3ZnQUo2QkJiWUl6Tmd3Vjhy?=
 =?utf-8?B?TTRuVDF4WlZyejY0NTFPWS9hVEJ1UFpGYkVucTB5Ly9qcE9pV3lWcy9XdVFq?=
 =?utf-8?B?eFNJa013YjVDTVMxZW41R016ZUVoZGRBclRlRFVYZTNqaWZhRTIzTmw5elYz?=
 =?utf-8?B?QXJRTkF6NUF1QWlnUHdMVUpRRXVQNjRtWkU5aXdPblhjYmZBelF1VGloRGg1?=
 =?utf-8?B?bGM4aU5oUDh0TFpkRkFaMmVRcFN1Zy9FVkZjUjVaY2JvMGtRcDZyMStSUkFr?=
 =?utf-8?B?Ny9ycklvM2s4YVI5Umo0YS85WVB5c29jVGJXcC9sL2szRTA0dTVVN1FBRUNI?=
 =?utf-8?B?OFpSM3FmWklncm1EMjlacVhFcmVCdXR2RCsyRDBNcVVZNW1rWDJNSTN4UnNV?=
 =?utf-8?B?WkJKRnhTK0p2UnRKS1M1ZGJjK2RkRnV0SXlXdm9McG1lQlFTN0x3ck1TQ1ZN?=
 =?utf-8?B?MWVyajVpN3kwTmxGZVZEYlpkVVo0S1ljclBPcWZ2cWFKVUZXUFFCUmhDMWNT?=
 =?utf-8?B?UUVDYitJUGtNVzE2NW9WMURGcDQzR0RKV0pUd2hWOVZSWGdvZjI4eE9pazdV?=
 =?utf-8?B?TkRKNk5hckNPNnZ0RWlpNjZwOCs5OURiZXZNK3R0MGN1VzJPamYrRDUzQnM5?=
 =?utf-8?B?QndDLzZGeU1hWHlmRVd1VExObTZBNDBMUWN5MUF2WlZTcW9xY3VXT1dlbHUz?=
 =?utf-8?B?RnlIcy9OREhmWE9IQWF2RGpYbzV2V0xWVDJKNjZtZTN5cERSUlBnYks1eDd6?=
 =?utf-8?B?QUdTdGtVeDZlaWFjUWVlL2EyOWVRVk43TUtpa3VwM2ZZTFZDdGFuN0txamtJ?=
 =?utf-8?B?cHlNbGVOSFo1a0pUZUREWGpwY0tvYXdtd3BVa0dkSW43dkRldUF2eC9mOHRl?=
 =?utf-8?B?TkhvQlM5Z3lSaXFlUmxxT0tNcHNTY3NXeWdpWGFqZWQwREZMdnRUdGFEeDFZ?=
 =?utf-8?B?SXpBMXdBYVd4NTBZUmt4dkJPYStSSWExdW5yVC9PQkFES1I0YjMrdFllOXow?=
 =?utf-8?B?Z2tjZnowa2tIdmoxRzNySzV4Y0RCRit5eWxPK0gwT3dYU1NwbGRyTUQ5cjBL?=
 =?utf-8?B?MThpb3hUMmJ0SmhaeDdIRXZoVDludGhHNGk2dVFpK3dWL1dYVDhhQ3g0UzZu?=
 =?utf-8?B?NVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: sNOtgL+9g3Zs899JzCBywLCePOesGQUlnxzGL3HYhAe1Tdyxof7JgCpJ+Q11WabRSO83f4l1d+0XO+oioMte0bM+x1MViM3Engk+4eOD+g4PL51/56HEi9vPNm14XqFAy39+57T/IpM7uWXx01jbsRe7J+45Bi3b3re6mIg5LWJHM6KcxptoTOnqTK1bFNnGYubNsn9I0/ZkF77FThLQGHnxKA90bW3Zzgj/TcnIu8kkEmrIJuwww74WWlaA7c1/7WVKlqiy9N6IkCPX8eoBSl8pyU1qRBO69aABUCK/LZ5qn0ba5teCggNMaG+5td21kTvwSfi/7v5/NAdhEkkpC0hss7A9iUUz84qAMsZKvzdMgj2/yPE88d+oXTmGdwfXPtbli3PF+iIAzALmxbFTwZHmbh0SjB6sPehwhFLbYIsBiACUv4Vmg4kaPiYk6HUEvVYkuMxVyRMrIy9ZshepgU+xp68a699YzE4CFlrvgwFDyrpxIULdm5RX5gEY3+pePu9eNJh46PLu4gV2J7QUQFLGMaNtupvS0GV7cJLiX2L811VCxiHpdU7x8PrXJMDkwNYZME12AwlpN10IKI9paKILR8juAzLjAVU2e6to3GcjQGOx0hK1U611Xq9Tm3RoeJe7kcGkQWdlpDhnSFHXrabOGfi6FS5DlTnstu8RYYjKqRe9b0QF5Bk5sfzG5+Y453zfgtucyBQQ5K4I4Zegpn2svTeHZ89X1ZZrs4Migrq93VyW4Ymvs5ID1nqrrfXCZMC2JpWptklOw14DQOlA7GDPHVZZqGt30DOLqZwQ4hXUTepb6GSH2JkJkWOt/MN0rA8pcvHKa86T2CFCF6pUYOFVelmx/rOnJAupnHm3mEo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c79e8d61-a7b3-4bc1-541a-08dbd0de54c2
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 20:02:32.7962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PpMe+rZWTjj+LHfWwyN0siiS9llImA1MqnF/ZJ+ddUJhQNAptqC1xWn1NNL714ONHQRez0fCd36mdma7SaSs5p3Uf9GbKLtpsaaqmCRBHcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6519
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-19_19,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310190170
X-Proofpoint-GUID: M7RHMKkUy9Pykn2CM8NIGso3ryWEk7s8
X-Proofpoint-ORIG-GUID: M7RHMKkUy9Pykn2CM8NIGso3ryWEk7s8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/16/23 4:24 AM, Hannes Reinecke wrote:
> iscsi_eh_target_reset() and iscsi_eh_session_reset() only depend
> on the cls_session, so use that as an argument.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 10 +++++++++-
>  drivers/scsi/libiscsi.c         | 21 +++++++++------------
>  include/scsi/libiscsi.h         |  2 +-
>  3 files changed, 19 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index e48f14ad6dfd..441ad2ebc5d5 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -385,6 +385,14 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
>  	return rc;
>  }
>  
> +static int beiscsi_eh_session_reset(struct scsi_cmnd *sc)
> +{
> +	struct iscsi_cls_session *cls_session;
> +
> +	cls_session = starget_to_session(scsi_target(sc->device));
> +	return iscsi_eh_session_reset(cls_session);
> +}
> +
>  /*------------------- PCI Driver operations and data ----------------- */
>  static const struct pci_device_id beiscsi_pci_id_table[] = {
>  	{ PCI_DEVICE(BE_VENDOR_ID, BE_DEVICE_ID1) },
> @@ -408,7 +416,7 @@ static const struct scsi_host_template beiscsi_sht = {
>  	.eh_timed_out = iscsi_eh_cmd_timed_out,
>  	.eh_abort_handler = beiscsi_eh_abort,
>  	.eh_device_reset_handler = beiscsi_eh_device_reset,
> -	.eh_target_reset_handler = iscsi_eh_session_reset,
> +	.eh_target_reset_handler = beiscsi_eh_session_reset,
>  	.shost_groups = beiscsi_groups,
>  	.sg_tablesize = BEISCSI_SGLIST_ELEMENTS,
>  	.can_queue = BE2_IO_DEPTH,
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 0fda8905eabd..a561eefabb50 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2600,13 +2600,11 @@ EXPORT_SYMBOL_GPL(iscsi_session_recovery_timedout);
>   * This function will wait for a relogin, session termination from
>   * userspace, or a recovery/replacement timeout.
>   */
> -int iscsi_eh_session_reset(struct scsi_cmnd *sc)
> +int iscsi_eh_session_reset(struct iscsi_cls_session *cls_session)
>  {

Patch looks ok to me.

Reviewed-by: Mike Christie <michael.christie@oracle.com>

As an alternative to this approach though it might be easier to have
this function take a scsi_target. You won't need beiscsi_eh_session_reset
and for iscsi_eh_recover_target you can pass the scsi_target to
iscsi_eh_recover_target/iscsi_eh_session_reset.

Either way is ok to me though since we have to convert from scsi_target
to cls_session somewhere.

> -	struct iscsi_cls_session *cls_session;
>  	struct iscsi_session *session;
>  	struct iscsi_conn *conn;
>  
> -	cls_session = starget_to_session(scsi_target(sc->device));
>  	session = cls_session->dd_data;
>  
>  	mutex_lock(&session->eh_mutex);
> @@ -2653,7 +2651,7 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
>  }
>  EXPORT_SYMBOL_GPL(iscsi_eh_session_reset);
>  
> -static void iscsi_prep_tgt_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
> +static void iscsi_prep_tgt_reset_pdu(struct iscsi_tm *hdr)
>  {
>  	memset(hdr, 0, sizeof(*hdr));
>  	hdr->opcode = ISCSI_OP_SCSI_TMFUNC | ISCSI_OP_IMMEDIATE;
> @@ -2668,19 +2666,16 @@ static void iscsi_prep_tgt_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
>   *
>   * This will attempt to send a warm target reset.
>   */
> -static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
> +static int iscsi_eh_target_reset(struct iscsi_cls_session *cls_session)
>  {
> -	struct iscsi_cls_session *cls_session;
>  	struct iscsi_session *session;
>  	struct iscsi_conn *conn;
>  	struct iscsi_tm *hdr;
>  	int rc = FAILED;
>  
> -	cls_session = starget_to_session(scsi_target(sc->device));
>  	session = cls_session->dd_data;
>  
> -	ISCSI_DBG_EH(session, "tgt Reset [sc %p tgt %s]\n", sc,
> -		     session->targetname);
> +	ISCSI_DBG_EH(session, "tgt Reset [tgt %s]\n", session->targetname);
>  
>  	mutex_lock(&session->eh_mutex);
>  	spin_lock_bh(&session->frwd_lock);
> @@ -2698,7 +2693,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
>  	session->tmf_state = TMF_QUEUED;
>  
>  	hdr = &session->tmhdr;
> -	iscsi_prep_tgt_reset_pdu(sc, hdr);
> +	iscsi_prep_tgt_reset_pdu(hdr);
>  
>  	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
>  				    session->tgt_reset_timeout)) {
> @@ -2750,11 +2745,13 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
>   */
>  int iscsi_eh_recover_target(struct scsi_cmnd *sc)
>  {
> +	struct iscsi_cls_session *cls_session;
>  	int rc;
>  
> -	rc = iscsi_eh_target_reset(sc);
> +	cls_session = starget_to_session(scsi_target(sc->device));
> +	rc = iscsi_eh_target_reset(cls_session);
>  	if (rc == FAILED)
> -		rc = iscsi_eh_session_reset(sc);
> +		rc = iscsi_eh_session_reset(cls_session);
>  	return rc;
>  }
>  EXPORT_SYMBOL_GPL(iscsi_eh_recover_target);
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 7282555adfd5..7dddf785edd0 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -390,7 +390,7 @@ struct iscsi_host {
>   */
>  extern int iscsi_eh_abort(struct scsi_cmnd *sc);
>  extern int iscsi_eh_recover_target(struct scsi_cmnd *sc);
> -extern int iscsi_eh_session_reset(struct scsi_cmnd *sc);
> +extern int iscsi_eh_session_reset(struct iscsi_cls_session *cls_session);
>  extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
>  extern int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc);
>  extern enum scsi_timeout_action iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc);

