Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F77BC04E69
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 11:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbjGYLNs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 07:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbjGYLNB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 07:13:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F471BFF;
        Tue, 25 Jul 2023 04:12:38 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36P7oa6K017234;
        Tue, 25 Jul 2023 11:12:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=0xxhGkqmVsVssPfvcuLRUasIrK25fLx32y0i3LwEhcs=;
 b=WelWepFlf8d8UhA9eQUWf4Qg596nfj7mR8WIAtKnhZFJkbGHNRTyT71Iud+zMJg3vce6
 V0aSR8nz+Ue/5Ed2THhSM8jUfANhs1S3ix29frKXhhDC8UMHnN3vj4FY6spD53uIS/to
 ScWWgQ3l8GwARy/Lq5FUWyuIT3M339kNfh/JNWFiWpWvolUdB3oTEICToSxFqvmkKSpC
 UyaMdWWzs0P+E3L1tMzRyUNZXfBZoNGIvctpF1/ph/GsNgURSXjOad7tiV7Ub8nNq/RY
 AyewJ64HOvZDakYz6gxgo5qwq1K8VCbNRvl+TNRaLEh7GFS+DsYbd/egH1CaNRDDn+cc cQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s061c4v2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 11:12:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36PA91u3032680;
        Tue, 25 Jul 2023 11:12:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j4uuja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 11:12:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fKe5h8HJ2YnnhIqo0uPPaGn6jygGx3z1q/J/mRZlO1Eq1bAJVeRu5Rxt58xK+UMtTwcVeI3vrIGr8mE20MHqoLrNJbsQX1r4Ub2u26EgR6wwECJMkPZWuXsbmtGoo+fXiEcMF0Ymq1+jFz1P6Manh64e+SMDrIx9fy/Dn/huRF87jzHWIUrms4OCwvV99BLOIW7uL96iPvaE4M7FBzNjAuq/JC1HAqxJHAj20cea1b+4ffShI1F8Zlu6IBAHYPZs+qyX/JeW05wddp5vPIAm2b0HBjDqW6aUYRQq6nEu+Vs7uvfuXC/Mc+d8h/fWRsXPr31ixnvSMb+rGJI4BnOuvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0xxhGkqmVsVssPfvcuLRUasIrK25fLx32y0i3LwEhcs=;
 b=mIbdBQvM79UUEII4hi4m4NaJAAiz3x7+CAmm6fhzErFQNzTN7n7+m2m5dE8b1d9y5OC36zq3i+mOOka5Basw4o65luqqQPFnbX8RQkgBaF8fq+6YJrH0UJCXVHcOK2XiHz9rV+bBgw1AYu6fUrI1u2uk0TcLXKP8ZqeSdEvyRGd2CY281JOJstQfC0kM4ottb9iUMqIF2+ARfxIDwuKgv2RUBmuFadusLPxFfMeX3/PlQq0jrKhttiB04kym84ModR1H9YbZVkF1WCh2bLnxU8WIcWiIBHm4WdreZpSbOHXCO12b3fSBpc6DI5APcNq964HjhRAUp4A0Op2Y2VDd0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0xxhGkqmVsVssPfvcuLRUasIrK25fLx32y0i3LwEhcs=;
 b=IO07Rr+pQFqilxlG/Tbgz7T94fqmDoTxuO5c8u2dylgYPaSXIh9TW4eWAfQ8nq5wms+mXX0I1eQyA1BurF8lciyCMBsQ6SKDnltmSvSUNTcGBq2o9KjbPF7jB7lv2oV5iEgSlZbeSSixn6RP6qjZ+Fq93rhHbmecBCmRaHdwVjo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB7348.namprd10.prod.outlook.com (2603:10b6:8:eb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 11:12:20 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Tue, 25 Jul 2023
 11:12:20 +0000
Message-ID: <e234310d-11dd-ad4b-2905-757a45c93782@oracle.com>
Date:   Tue, 25 Jul 2023 12:12:15 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 4/9] ata: remove ata_sas_sync_probe()
Content-Language: en-US
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20230721163229.399676-1-nks@flawful.org>
 <20230721163229.399676-5-nks@flawful.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230721163229.399676-5-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0336.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::36) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB7348:EE_
X-MS-Office365-Filtering-Correlation-Id: 04566db7-6335-417c-c653-08db8d000381
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8KVa0eY2k41qqMEDW4zJGrfWXlNIlxC5dHFXUQStagB/PtyZBQGxJM9TS7KHOtiYLH9r6PSLYspD5EiHrIJ111g+U2mEm90YxkojF9cp8zrRS+jjOaX5/xJQMbpNtoEjfkJr8G+4k5AGinKYMx/Ji2tt1Ydi/3rxbAuQ+veuVA+cPdgBMr7vetgkfrvJ9B0VrOXilmNdlMenzcf4jSuF16yg7zZ1gLeD0INwKCfckiSGYzPWIcoWrsXEdhNjWX+MynPhoerQDZfQqYbvkMm52XvawR3sZ/6nxD/RHkJnA6tCZGbPzY+kpT0fOfkDIPstD5FAAsz71SFC2lnTSdA5hLJSvLv+uilsN0JTESlNBUdzLYZdLZU7Tc5T5FM7jQkZoicCo0NOCN9v/ikwQn1ZY2UGDVl+ecVR3U5WnGHzEziOYQKXL3AfKL4Tmepy//qb4TW1gQZP8ov27g5+xzr1eao48cpn9/b48deUPxwHpg0jtq5F6GTgouQtht9WNGAMAgV4EXBPoZ48wpVs0GEGqERR8HRWPdTDLj7cxFmg/1JO68KVX+j3gpPWsKGZDMet4JZVQ1YZYOuIlmK3T+UAzX7eyJJm/t3JCODEtdqILfId+y1JjDcRJ1MfgyRvN9qjOMDyNQmrz/qR5kbZQUXnMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199021)(31686004)(8676002)(8936002)(5660300002)(41300700001)(316002)(4326008)(558084003)(54906003)(2906002)(66946007)(66556008)(66476007)(6486002)(36916002)(6666004)(186003)(26005)(53546011)(478600001)(110136005)(6512007)(6506007)(31696002)(86362001)(36756003)(2616005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlNvaTZkSVRMZ1RQRW82T095SlhUdTN2Z0l0emp5RVo5bnYzQ1NjN1YxUUZ6?=
 =?utf-8?B?Qm95WTFacTNDRjZ0UDZ4L0RYSVlDQkg0UmdLRHhiem40SHRpU2RZRGF2czJm?=
 =?utf-8?B?NnpyQU5WaW13MWE1UUo0VmY1c0dRTm5reEhiQ3JZS3NuTFpmRHdiL1h1a0Vp?=
 =?utf-8?B?a1ByOER1UmVJVHhWS1Y3dkpUOUVZNk0xKys0MGg3bGVBQTJTSFBqS0krQ0Fk?=
 =?utf-8?B?NDFpUGpEQ3hkZ25HVHIxa0FQb3RmZEQ0dDJield5R2FhakdsUmtTTWNUR0tZ?=
 =?utf-8?B?OUhaYm8rM0xqWXpPeFZibmlJWm52VjlyREtVUXBzNktFcTRCUVd1OVIrNW9w?=
 =?utf-8?B?UmJlelM0UzZBaFZFYSs4ZXVVZ3lKdE12RG9uZjNBNlc3U3d3Zm9VbzhCQmdr?=
 =?utf-8?B?b0lKdmZQZWl1NkZaNnIxbGpMT0VEZ2gxRC9VMlh6Vi91bkNqNTh3RXRZQkxU?=
 =?utf-8?B?dmxkMTRHQi9IYnZhNllYWHdHTWJwVUNUMFJTSGR0MWRGcWFNU0taVFVqYUFv?=
 =?utf-8?B?U2NrdWkzN3NxYUx6TmFPbFJ6YVNLK0hEaGN0NjJmRkZYU0lTWjAvNkxiVDRE?=
 =?utf-8?B?ZHpmWDFhSUNQN0hMNlYycFJvNnEyU1BORE1CVG9uMldGNjRGbzRKQW1SOXZp?=
 =?utf-8?B?c25CNlZZV3U4WDViamhTczhTM3Y1V1QxeHNTaGQvaW0rVFBYbFN5bE5NVDdI?=
 =?utf-8?B?VjFwVmxLczBUYU5GbVdDMnBNNGhVQmFqTGR6SlNJVnNoRkg1bGVzVUVTY2tH?=
 =?utf-8?B?MUxrK2lvc2x6UHUzYk52dzZLZ1kwQU5DamNNMExYb09UT25oZTJCR1NJdUdH?=
 =?utf-8?B?a2ZLL2MrMkR6ck8xZE44bmx0dzFkYnYzSVBtM1JQajNqb0JNUk9xeWNHL3FZ?=
 =?utf-8?B?dVpobk4xMHpJWllJN2xOSGREYndhRkRCYnQxTi82NUpHQ2NUejFRVFpQcC91?=
 =?utf-8?B?YTRLbklRRGVwd1ZkQkJjd0l6VENOQkQxQlFQSFlWZk04Vkd1NTF2TURiZ0Vt?=
 =?utf-8?B?bzJNSGVlN0w5UUtyS2dLZXN2dGFsRnF2V0IwQlFWWHp1aFVla2E0dVFTRnkv?=
 =?utf-8?B?dTVtYmRCSFd2ang5VVVSV1BjUFd4SVJLYWhYd09mVWJCbkxSVk0xUnR4UWVP?=
 =?utf-8?B?L0VLb2dHQXBUWXhYdkVoSkhxbmRaYzI5M0I1ZkkzbnlvTFJJV09lM1hEU0lt?=
 =?utf-8?B?YThkbFNOOForME9jL2lTNWQ1ZExqT0I0dSs5aEJiQldPem00QnowWVZZdGZl?=
 =?utf-8?B?Y3Nqa1FseFR2YlNuRk5icWNSRnBaYXVSaStZUEs2QTFoaFVtcldqenVTUVlw?=
 =?utf-8?B?bkh5emZYcW1DbEViK1BGVkc3Ry84S0xhajRSam1XOTdncGdxSFhRSGZLUDB5?=
 =?utf-8?B?QXNHMzlUTU5HUnpRY1NlVXpSOG1DSk5vUUNTNjUwUGJiRTBuek9LdUtUdnJG?=
 =?utf-8?B?YWR1ZkozRElsbG5BRFByK3lHT0k0ODNmMGhyQlNFY2tBR2lIenVHc1pTbys0?=
 =?utf-8?B?eVRQSEtHTzd5cG9Qdm9JWWFFU05yejhlZVJiOHhpcStFMkVrTmRqMnBGam1n?=
 =?utf-8?B?N1NYT0pvSmMzejFEUG9wb0NDeEsyV3JySkJwMVI1R1BENlZXaWFkQWcvcmRL?=
 =?utf-8?B?U1lybnRTa0dITFRGTy9WQlpVS3JRVWZBQXdoVFNLcjBaeWZ6eVUwNE9pbTVr?=
 =?utf-8?B?Q0draE4vNW1YNkFWUlkrVDlsWUxHWDZnWEk1SWN5YklRR2t3enlHZUNCZDI5?=
 =?utf-8?B?WjUyTGIyUWhXL2hDdGV4V21GakxWZW9KbnNGazlsL3dIVmR6ejVyM0hVK3FR?=
 =?utf-8?B?cUppamhIQUFSNnV5QmRMV1pWWkdOK0dSbFhKTkJkVmYwc2k4a1ozUjFTaktS?=
 =?utf-8?B?NHAyckJ1T3hBeUtld2JDTm9Ua3RqSllHMWV3a1ZQN09mdTIzKy9XeFUra0NI?=
 =?utf-8?B?YXJNakYzUUQ3Yk1HQ0swZzVQdEhBZHFnYm5La0ZaT2dBRVc2VHNKWWhFdTk3?=
 =?utf-8?B?eXlOaFBWMVAxcGRVbWdaVGxOeE1uS0NYcjBSVFJxKy85L2RIMUdHNGg2S0ZC?=
 =?utf-8?B?UjQ4TVAvV2c2cDJaY3JubWF5azZLVCsxUVhvRWU3bFdSUHRrWExJUlRId0Iy?=
 =?utf-8?B?aEdUOS9mbEF2NEZCUFQrQVZBOFRUSTVEbXZrWkdwajNFSHEyU0VGNmxkSmc2?=
 =?utf-8?B?UFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: t0ZkjmMtfESYgbD2DKZs1FtSr2XJno2HFbEfbAkM/L6/6u965oCcVII3CFPpcSdKNf+JOIajvS9oKqmm8OtkhY7Co0aDEcfjpw5t2KEzSG1qOJXSojSHHeGJzpKTaPBlGpqtBAdmQrMDOpCtX18DlbNbAl7G9DmgKEPFT3O+J6DgmiQJtbF9un8y62xsiFgZHMGqb0DEIvmTEPkJeqY7g2kn1uw8t74fDSL8hPVJWw+CaSbcoqrgunD/AgO4iLZah/O5/j7f92B/QC/C18RAYkvwFm9ZaTi6gHOZmVbYxS5XxXm4MOzu7iZPg88sM6P7KjLdgNc4VRmsJG0xS/n8sfqXilhtnnS/cIZLVD8xYpYZTxN0Fht++GhTuGyqlfODken2F8s2+geNQ3HFCvLiczBMXPGCdA/sCHrbig+PIyoDNePuBdsBz1MTTSZqHSc+m52FRLhEJUm/pNlAhtd0Q94LFr7A9eG2nqjhrGiBv92Ulcnn7rlxCIqt3WELAl6IvaCScYKBbb+8cqB5Ex/zQTFnzNcbXRW+eNmPRvUddC5DaHrvLWBUkMMFINfO4oS6f44POlfhHhdYJzD7UXFhTnkYh6Sgymp5ScmP7qEnaZhalIXhpNf6kK4malsNJgB/nmQLSCH73gM7ULzUepYucjoQwfMfDZeMCBI94aoDY/KidlDSPDE7nQbI7GuPlgoOONal5N2AtiFACTCgJbXcPlZVwYo10tpMT5LS/mv+9hpmX47ubnMKv2Q9fq2hbHfs+G+ib3Km5XFWU4gF+QXh8pcXL8yCq+SwrT2OEQHYT79aZXoivQwoyS7MpHe4waUgQfLkiNlFyUj6spA397+5oG7ihnHeRuSTBfULqb6pwWbzolveDXed/DZDkLBt/SweTwDTc43IXRLv9bb9FLocjqSZSEuyjFuvIAqA2E0pSMI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04566db7-6335-417c-c653-08db8d000381
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 11:12:20.3875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: voTGh8rgpHFfXJe6lpysuf1WFKH+r4KDMz6vwvlMW9GWhDomxLXGH4laNhLBoGXspp0XicSI+aAkcDPXbu1Fsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7348
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_06,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307250097
X-Proofpoint-ORIG-GUID: tYmPgyvdtxmSy9GaQehyTmd9N3H42_k1
X-Proofpoint-GUID: tYmPgyvdtxmSy9GaQehyTmd9N3H42_k1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/07/2023 17:32, Niklas Cassel wrote:
> From: Hannes Reinecke<hare@suse.de>
> 
> Unused.
> 
> Signed-off-by: Hannes Reinecke<hare@suse.de>
> Signed-off-by: Niklas Cassel<niklas.cassel@wdc.com>
> Reviewed-by: Jason Yan<yanaijie@huawei.com>


Reviewed-by: John Garry <john.g.garry@oracle.com>
