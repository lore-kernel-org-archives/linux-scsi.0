Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00996E9270D
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Oct 2023 14:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239182AbjJEOnS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237727AbjJEOjb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2023 10:39:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DC3884E
        for <linux-scsi@vger.kernel.org>; Thu,  5 Oct 2023 07:10:02 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3950Pf4J024095;
        Thu, 5 Oct 2023 11:54:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=d/Vqxufczj5BXKh3cs0Iw+sW7sTqaf8eCqhL4PMLR1A=;
 b=wC/E5C+eqR1nfvz5Y9pTWuc0T81SPcFCU/S78oLF7j5ByYCYhruQp94XU7h1dRIkanDo
 3jXDIew+4bVtyjPgk8BC5bGhdgvHcfkGSlukVXHOjhylkc6eexWpGIj0AUJ3eKOvgry+
 4psk+ZdXP0C5lC3M4dqoFz1TYeM84jNeNyGnDCKOhauLxTgty5cMhGXTI0Q+PyA8QRRV
 g8C5KMwf65o5XHJz9U+Ak/LdAU9kgkBfoQOCMIwH4dex4Q0V4Dy9ibcftB1qqGDYaPbT
 XseC59IWVKYhBAVKMuLej6ANhJYfYDetEWxrwVW3G0pbQgxltPN6/YFW+IQGxCiSRwm/ oQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3teaf49bda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Oct 2023 11:54:29 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 395BW1V2008802;
        Thu, 5 Oct 2023 11:54:29 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tea49g38f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Oct 2023 11:54:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iLj2xmR1OrQgVqrwZbAG2s3rcQIh1/SCHoQ2wTyMxO7FjWIOWLue4U3w4v2kJ3cp/bFUNGUq2kH/O2XoCFjtJPU0QhFgdoF1HcdRAhg2RSW9/IXGPUTyI0faE6sI1c4fJuwXvb9vTa3kTClK2Sby6dvaF/a2zGjh7ZOC/H9DjWOyplOTgNxAiK4/DyEKP5D1iB1gAaBPoPcWC8aLaIqcqWtlCS/VX0Y0VIzvXV8HYxQ3yNnAKcB/49V0Fa947o2m7pfY6ko2oRtOoEbX4QyBd30mTywdrIJ163iXdyThUdzPatIdvV2eUCti89ACGNHMUxcj2PY8lgC40MPmBUUywA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d/Vqxufczj5BXKh3cs0Iw+sW7sTqaf8eCqhL4PMLR1A=;
 b=SwOx+U3H5c1DdjsQB5Cm8hBvCaf5NenDsjmK7gmeYz4iNqvfYUaUHrwCtkSuKj+JomQSXEtLPVY4HvzvgUF48BeYosqJnxtXdfiI3ZkJTMAZ5iLk/FqqsRNDCcb1nmCP20hwqxhvNapXgl+Czc0wMlCBgIWwziFBPBA3AtVC3EAjk4KN679W0mdWiu+bBnxR2xMfKXEAkjeevFGOtUbPEmDXkga4vt5++8agMyW+tLtvlceDEuPjZgVhyKcCwAD0kc0bDs8BD3pAIy6Wnlz5oWQbS4o3I2nwMoDdAOTYz7tuTpRZc4Iovv9bA5BBwV29/JPgbinW2tjPYJr+rOgi1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d/Vqxufczj5BXKh3cs0Iw+sW7sTqaf8eCqhL4PMLR1A=;
 b=tIR4n6G4xRbVCqrfG0u6QcV+TePvkWGS5GwA768qYhFDq753ON1JluG+69g+6/iJQH0ASLUWoWan3r/j1tOTfSXL96SQDNczcvhSr2bO3xU1GJ+wMsdb+Dw2kE0KZe1aOihR8oaDZb+8mclyZ5D4Yeg+LSqtyCUVAORNQ9fuYgo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6440.namprd10.prod.outlook.com (2603:10b6:303:218::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.31; Thu, 5 Oct
 2023 11:54:25 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6838.033; Thu, 5 Oct 2023
 11:54:25 +0000
Message-ID: <b2182011-258c-cdda-2998-4e98fa510bba@oracle.com>
Date:   Thu, 5 Oct 2023 12:54:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 2/7] scsi: Use Scsi_Host and channel number as argument
 for eh_bus_reset_handler()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20231002155915.109359-1-hare@suse.de>
 <20231002155915.109359-3-hare@suse.de>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20231002155915.109359-3-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0010.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6440:EE_
X-MS-Office365-Filtering-Correlation-Id: d99cfab2-d69c-4fc1-7ce1-08dbc599d29f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cHGFWwR7iuBjCRbwmwhOoNV6kgGcdeXk487SUrQqcjAKNXnyWiKqIFcevqcSBqLDHryGy+rcGXMKV98hoBnA+/mj3BL/dOhIJUyyaU3y03SQvxP9980UzaXHL8fN6wQPYlVDfpmNm1c6MIRa6LiIxrsmCfRGa5xS6gya/UxmC7xoWLx+WFEnKhSFj/sjASJ6hD7MXlblcWW9kdE7DV5J4VU4U7l4EtCDydsL3ILYebRvyi+GoE3HXo/5peSUFbvZhqlJtMCWHlDRjyvk9piCoZ5XlETT28uhcH/E+vgeBacVnv6hZC6NV28h3yyHyBO29U9aAvOZ5vafjChzQvMoC7nmjD/z9lAQDJse8i8HGCARqLPA48sub1N2BNeiuw64fFQQjZndbGys4XSL1VvjhPv8f25pZVCg2S5IXH0cRZOnEREQKNe2hAX2ua+YIXniu85jWZu0G2J/vWR1Q9fyyi5ATnJ8wZDYUJ2DsOSyfVzDqWYCxzOSXrCeUbNFWD0rZenRbGdOS4RaXw3246xZ+EEwWclmXo9mpJHWKJKafLRJoXNxDm2QHrgz4nm1YZtrMQr2U+bQYnbla8WRrDmeYNwf/gv/Ynto7AdgfPHsHWQhkJV4mnd+AfFjudBEoSLFMbCs2kBiLFYpuN0GjzX5mQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39860400002)(346002)(396003)(366004)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(6512007)(6486002)(6506007)(6666004)(36916002)(478600001)(26005)(83380400001)(2616005)(2906002)(6636002)(316002)(54906003)(110136005)(66476007)(66556008)(66946007)(8676002)(8936002)(5660300002)(4326008)(41300700001)(36756003)(38100700002)(86362001)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkV0RXN6QUhuR3YwVFhnUm95a3VuZkFwaXBCcld3ZXhFazFCN1BsbEtzK3NI?=
 =?utf-8?B?UVJRMmExWWZjdVFhQzg4and2dld6eEdJbjZVNWUyeEhnK0FZMENPc2ZLVC9M?=
 =?utf-8?B?TWRmSFZwT0JvOWd0YlVnNkoxY1dpVVp1YitvT1ZEUlBnRHNQWnd0M0ZjMThn?=
 =?utf-8?B?NU5ocXA4V05MaEIzbEViNjdHd1hmVmlkY3ducHVPc0Qxck1mOVZQaUlNdng2?=
 =?utf-8?B?TnZwZjJsc244WmFveDZ5My9BSzR3cStKRHNkYUVqSjRySklTWHZSblNheXQ2?=
 =?utf-8?B?OVNvazROd0d2Vzg0UVJzYWVaVXJ1VmNWMDRrMk9RM3ZSZmhQeTdpd0J0Nlp5?=
 =?utf-8?B?Q3g0Nk4wa1hFQmtOcER4ejhQMFdsSk0yaStFNGpxeU42WVdYU2I3YnRZSkNz?=
 =?utf-8?B?eVMrMDNxSFg4YUNtU29GR0xlWUQxZ2loRkhaa2dSYlVsc2pFcU82VXV1dmFT?=
 =?utf-8?B?RHhOZjdweXFFTjBranRJMVcxYlRKVlpPRFp3QkFOeFc3ZVd0aWppRkZteGFO?=
 =?utf-8?B?UG9MWTFQRndUVFNCeGp4NVpaZ3Y2T01LTEJ6U1lnNHBXMUV4cWZRSE80YmNo?=
 =?utf-8?B?dUY5WTB5OHFkUEJXZ1lzUW0wSUoreTBvSmk3ck02TTZNYXEzWnRwcUlCYlVY?=
 =?utf-8?B?NXVnK0N6R0FhbDcxTURJOFpFbHNiRVpqQnYxOUpVbDUwNnI4bERTQ3Jab2VJ?=
 =?utf-8?B?MW5UR0F0QWlXemJJTDJYMlZ4clJaaXlOdjhEMDhmR2FoN1NZMWVjTkZBTURV?=
 =?utf-8?B?UjFLM2VIMW1tdngyZWw5Q0pPYlZFLzRsK2F4M1pVcnQ5ZExkcUVtSlpobyt0?=
 =?utf-8?B?VklUZ3ZHbHdxN21CNVYweW9YdkJYM0hYaDIrTVBxQUdlNXIzMmFEMXRFVG5T?=
 =?utf-8?B?L0tJM21NZkxxRDg4RXVzMTZqdnM0OVJrS2UreW50T1YwVjhzSWc3SU5YUFpJ?=
 =?utf-8?B?c29waEF2amNueE14c09BVTFray82enpQZGFmU29ZVnNzZFlRNzI3akcrZXJo?=
 =?utf-8?B?ek4zR2JLVWZSVWRFdERmNlo4Wm5JdzFiNm9Cd1lDZUp4VXpOVlJTcVlyNk5Z?=
 =?utf-8?B?UlJMTG1jdXo3OVlnSGJXVkdrZk1wR3BMNUxzcnJJTEQ5TFlUOHdvemNYYUxj?=
 =?utf-8?B?cURxWE5Od0xNbGdRc2s2eUxYaHFwRERHWjFWTlJIdTFrUEFKanhXNkdCU2pm?=
 =?utf-8?B?eXhjejFCa3RrVGdZU0dTQjI2Q0llMzcyK0hvVWlrN1dvK0xxdi90ZkZHWmFK?=
 =?utf-8?B?Y3F4Y1NhcGYyQUI3Tmg5S0Z2WFFYK2RFVUVmdmF2b2lYVk5TZnQrWERiZU0w?=
 =?utf-8?B?OXVhNHZWYnJrSnAvNHhEVkZDRmRodVNObHlCQXlJVjdseVBBeVlMc0N5c3dk?=
 =?utf-8?B?YVI4MUFjbnB1WjhsV25SQkFnUzZUTmFva0lpbjVFbXB4blpDTlNjTGtZUmRS?=
 =?utf-8?B?K2MyU3hYNzh1VUloeTM5dHJKd2FQMEFFM25DZEJ2Qnk0Uzdwdkk0ekMySzA0?=
 =?utf-8?B?NnRsTDFCTDlHYUhWZElIa2x3QzVrdFd6OFZyNWYzUGZmM0NSRkg5eWMzRjBF?=
 =?utf-8?B?UlVxNUJlRzNPdHhsaWxQajdzVVYrZUduMXNLYVNPWGh2QlVPckN6UkdaMi85?=
 =?utf-8?B?dWdRMjhlWFNNZVRPazRmM0hhWnFQUGVNMnlaSDQrRTVCL0JNK25xcmo2bWUy?=
 =?utf-8?B?cllFb01GbWJ5eWR0L0pTMjlYcHJUTDhWVy9ydkUxSU5wWjNjNGJaQXAwOUll?=
 =?utf-8?B?bHN2Y0k1L1p3UFcrVFQzN21QV0RubS93MkMyOFZYaG9IdXl5UWlJOXJjSDRs?=
 =?utf-8?B?dFZvK1d1NWZWZHdtUnNqNFZucTlBM3AxWmh5TGFUNGQ5bUNLYjBRVTFsUDdz?=
 =?utf-8?B?WDBuMFFYTktBWEQxdk9rMWpXVGttRk9rTTMrcVdUbUtxQTdRVDVxOG9MdmpP?=
 =?utf-8?B?U2d2TFB5NHI4TzRXMFRMMzJRT1RjMjdTVkxNdjVVUVZsKzhKeXdVdUUrLzBL?=
 =?utf-8?B?cU9DNm9MenVwaGZzWndTNjNpUmRtT2tVWFZ5azFTVXdidXNGZFcyU1k3MFJm?=
 =?utf-8?B?TDhUNWtodm1wK2VXaWkxUGJ3QUpmYVpMaEdWRG5jZzJIc1Jkc2lYRkZkOFIy?=
 =?utf-8?Q?jr1/sF/FIEwYF0nek7W/WSFHk?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: AYY32MBIth7lMw/8B6iKoiRQHIqUXI/sdY6L2sGQHd+Y+j1Fah9jBT3Rh/RRuI7krFemSVW1eBpGauP6L9I46wFDYeyh4b5/ex+RHT5Nwxv7LyPn1r2HoN6iLupLRiwHz+EZIHuCiBzNaMEHqZasFbuvcmrEgg3lHZaawRDNMrf17+T4y/23fiMnB/4zySLJjBgGORIksFFCkPjOLjqVEvQu0QgxOJ5gdKK/cS8U5Dzud6AOk5bMDkam+LIyHa+ifvWpOQDyoG5BOJJt+98kdIwFns/c2BQWGCC40zHOfu0AU6jztXrMwVndw5uSJxngtA9u9dvaylDYMfTRrjNyyBQdCkR0N6ow3LBppP9hDWx2Xr1R3hTrXD/tOg0P8O4Ink20uUkzHqhxMrTVWOaiFKE/QJYolh+Tlmk6cy1lAW59/+syGuN7gO+hGTBWf7ZC2L8Yh24IJkckwtGtPJ/YkWoOi+HjpOlSr51ToM12YnbNEOd2x6NgphWkQlkwBIt6MPQNotkFx9n6aw1N3utbEangxV7gZkCnY5MrMEZONpqgMkdW6MwlpOya9A+vCamMP2rE2Q2qHkV+Cj+WgeUX4SwQ+ik5JqEqrjW59Ezs18DUGR2G8LEbnl+i45OOswCMSx2RtxO5m00f7gjB+YFHeB0UYKmJ9dawgidA1ge7ClHTe+/an/Nk1NOEQu8YGdSVloWOe46rdENks6d7qjZWe1uk/wEOi+i/EcyblygBec0wEPKOOquR3m08bJAWhJocoRB/N2RSj6qfDXhZSJOaHetRtVo8wSmCJ7QuVehSrFB1hFm6pOxXX7+FQ2n6N67v4e0XCrxOQ4CEAsfchbea45GKaLj+4XwfL5LJEtvodNk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d99cfab2-d69c-4fc1-7ce1-08dbc599d29f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2023 11:54:25.8479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dgrWUndUWOwGpDZkhXDvHbWY9UiQuwGNplWt9deuDWgpqRngmvaRLXkvetDvEJkRVVuGCrFOo2YQ7v+odovuwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6440
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-05_08,2023-10-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310050093
X-Proofpoint-GUID: 5h_8p0x7zooVmuI6-T6fAkky4x9K086f
X-Proofpoint-ORIG-GUID: 5h_8p0x7zooVmuI6-T6fAkky4x9K086f
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> diff --git a/Documentation/scsi/scsi_eh.rst b/Documentation/scsi/scsi_eh.rst
> index da95971b4f44..dbbfd754a928 100644
> --- a/Documentation/scsi/scsi_eh.rst
> +++ b/Documentation/scsi/scsi_eh.rst
> @@ -216,7 +216,7 @@ considered to fail always.
>   
>       int (* eh_abort_handler)(struct scsi_cmnd *);
>       int (* eh_device_reset_handler)(struct scsi_cmnd *);
> -    int (* eh_bus_reset_handler)(struct scsi_cmnd *);
> +    int (* eh_bus_reset_handler)(struct Scsi_Host *, int);

scsi_device.channel and scsi_target.channel are both unsigned int, so 
could this also be unsigned int?

>       int (* eh_host_reset_handler)(struct Scsi_Host *);
>   
>   Higher-severity actions are taken only when lower-severity actions
> diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
> index 85b1384ba4fd..88bb3b7578ba 100644
> --- a/Documentation/scsi/scsi_mid_low_api.rst
> +++ b/Documentation/scsi/scsi_mid_low_api.rst
> @@ -741,7 +741,8 @@ Details::

...

>   
>   	/* If we can't locate our host adapter structure, return FAILED status.
>   	 */
> -	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
> +	if ((hd = shost_priv(shost)) == NULL){
>   		printk(KERN_ERR MYNAM ": bus reset: "
> -		   "Can't locate host! (sc=%p)\n", SCpnt);
> +		   "Can't locate host!\n");
>   		return FAILED;
>   	}
>   
>   	ioc = hd->ioc;
> -	printk(MYIOC_s_INFO_FMT "attempting bus reset! (sc=%p)\n",
> -	       ioc->name, SCpnt);
> -	scsi_print_command(SCpnt);
> +	printk(MYIOC_s_INFO_FMT "attempting bus reset!\n",

maybe printing the channel number may be helpful

> +	       ioc->name);
>   
>   	if (ioc->timeouts < -1)
>   		ioc->timeouts++;
>   
> -	vdevice = SCpnt->device->hostdata;
> -	if (!vdevice || !vdevice->vtarget)
> -		return SUCCESS;
>   	retval = mptscsih_IssueTaskMgmt(hd,
>   					MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
> -					vdevice->vtarget->channel, 0, 0, 0,
> +					channel, 0, 0, 0,
>   					mptscsih_get_tm_timeout(ioc));
>   
> -	printk(MYIOC_s_INFO_FMT "bus reset: %s (sc=%p)\n",
> -	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
> +	printk(MYIOC_s_INFO_FMT "bus reset: %s\n",
> +	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ));

Outer () can be removed

>   
>   	if (retval == 0)
>   		return SUCCESS;
> diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h

...

>   	struct AdapterCtlBlk *acb =
> -		(struct AdapterCtlBlk *)cmd->device->host->hostdata;
> +		(struct AdapterCtlBlk *)shost->hostdata;
>   	dprintkl(KERN_INFO,
> -		"eh_bus_reset: (0%p) target=<%02i-%i> cmd=%p\n",
> -		cmd, cmd->device->id, (u8)cmd->device->lun, cmd);
> +		 "eh_bus_reset: bus=<%02i>\n", channel);
>   
>   	if (timer_pending(&acb->waiting_timer))
>   		del_timer(&acb->waiting_timer);
>   
>   	/*
> -	 * disable interrupt
> +	 * disable interrupt

what changed here?

>   	 */
>   	DC395x_write8(acb, TRM_S1040_DMA_INTEN, 0x00);
>   	DC395x_write8(acb, TRM_S1040_SCSI_INTEN, 0x00);
> @@ -1172,7 +1171,7 @@ static int __dc395x_eh_bus_reset(struct scsi_cmnd *cmd)
>   	    HZ * acb->eeprom.delay_time;
>   
>   	/*
> -	 * re-enable interrupt
> +	 * re-enable interrupt
>   	 */

...

>   
>   /* Internal functions */
> diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
> index 168f01a34acc..ae647e2586d0 100644
> --- a/drivers/scsi/esas2r/esas2r_main.c
> +++ b/drivers/scsi/esas2r/esas2r_main.c
> @@ -1097,10 +1097,8 @@ int esas2r_host_reset(struct Scsi_Host *shost)
>   	return esas2r_host_bus_reset(shost, true);
>   }
>   
> -int esas2r_bus_reset(struct scsi_cmnd *cmd)
> +int esas2r_bus_reset(struct Scsi_Host *shost, int channel)
>   {
> -	struct Scsi_Host *shost = cmd->device->host;
> -
>   	esas2r_log(ESAS2R_LOG_INFO, "bus_reset (%p)", shost);

surely printing the channel would be better than the shost pointer

>   
>   	return esas2r_host_bus_reset(shost, false);
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index 355fec046220..c6a5721aef23 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -2604,9 +2604,9 @@ static int esp_eh_abort_handler(struct scsi_cmnd *cmd)
>   	return FAILED;
>   }
>   

...

>   
> -	sdev_printk(KERN_INFO, scmd->device,
> -		"Bus reset is %s for scmd(%p)\n",
> -		((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> +	shost_printk(KERN_INFO, shost,
> +		"Bus reset is %s\n",
> +		((retval == SUCCESS) ? "SUCCESS" : "FAILED"));

again, () can be removed

>   	return retval;
>   }
>   
> diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
> index 35869b4f9329..59efe064b304 100644
> --- a/drivers/scsi/ncr53c8xx.c
> +++ b/drivers/scsi/ncr53c8xx.c
> @@ -7936,9 +7936,9 @@ static void ncr53c8xx_timeout(struct timer_list *t)
>   		ncr_flush_done_cmds(done_list);
>   }
>   
> -static int ncr53c8xx_bus_reset(struct scsi_cmnd *cmd)
> +static int ncr53c8xx_bus_reset(struct Scsi_Host *host, int channel)
>   {
> -	struct ncb *np = ((struct host_data *) cmd->device->host->hostdata)->ncb;
> +	struct ncb *np = ((struct host_data *) host->hostdata)->ncb;
>   	int sts;
>   	unsigned long flags;
>   	struct scsi_cmnd *done_list;
> diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
> index 104647a6170e..c709bb955d05 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.c
> +++ b/drivers/scsi/pcmcia/nsp_cs.c
> @@ -1486,11 +1486,11 @@ static int nsp_bus_reset(nsp_hw_data *data)
>   	return SUCCESS;
>   }
>   
> -static int nsp_eh_bus_reset(struct scsi_cmnd *SCpnt)
> +static int nsp_eh_bus_reset(struct Scsi_Host *host, int channel)
>   {
> -	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
> +	nsp_hw_data *data = (nsp_hw_data *)host->hostdata;
>   
> -	nsp_dbg(NSP_DEBUG_BUSRESET, "SCpnt=0x%p", SCpnt);
> +	nsp_dbg(NSP_DEBUG_BUSRESET, "channel=0x%d", channel);

0x%x, and I am not sure that is even better than printing in decimal

>   
>   	return nsp_bus_reset(data);
>   }
> diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
> index f532adb5f166..8636f0053c02 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.h
> +++ b/drivers/scsi/pcmcia/nsp_cs.h
> @@ -299,7 +299,7 @@ static int nsp_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *SCpnt);

...
>   	return rc;
>   }
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index bb0323d05640..a9d9d0a9abd7 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1588,7 +1588,7 @@ qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
>   *    commands.
>   *
>   * Input:
> -*    cmd = Linux SCSI command packet of the command that cause the
> +*    host = Linux SCSI command packet of the command that cause the
>   *          bus reset.

"Linux SCSI command packet " - really?

>   *
>   * Returns:
> @@ -1596,12 +1596,10 @@ qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
>   *
>   **************************************************************************/
...

>   
> -	scmd_printk(KERN_INFO, cmd, "SCSI Bus reset\n");
> +	shost_printk(KERN_INFO, host, "SCSI Bus reset\n");

how about this the channel #?

>   
>   	/*
>   	 * We don't want to queue new requests for this bus after
> diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
> index 42134f9510d5..bc48152e74b8 100644
> --- a/drivers/scsi/wd719x.c
> +++ b/drivers/scsi/wd719x.c
> @@ -484,11 +484,11 @@ static int wd719x_abort(struct scsi_cmnd *cmd)
>   	return SUCCESS;
>   }



>   /* Simulate a SCSI bus reset by resetting the device's USB port. */
> -static int bus_reset(struct scsi_cmnd *srb)
> +static int bus_reset(struct Scsi_Host *shost, int channel)
>   {
> -	struct us_data *us = host_to_us(srb->device->host);
> +	struct us_data *us = host_to_us(shost);

Incidentally host_to_us() seems a copy of shost_priv()

>   	int result;
>   
>   	usb_stor_dbg(us, "%s called\n", __func__);
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 9e3ec411cdc6..32ef595db028 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -152,7 +152,7 @@ struct scsi_host_template {
>   	int (* eh_abort_handler)(struct scsi_cmnd *);
>   	int (* eh_device_reset_handler)(struct scsi_cmnd *);
>   	int (* eh_target_reset_handler)(struct scsi_cmnd *);
> -	int (* eh_bus_reset_handler)(struct scsi_cmnd *);
> +	int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
>   	int (* eh_host_reset_handler)(struct Scsi_Host *);
>   
>   	/*

