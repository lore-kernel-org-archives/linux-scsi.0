Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3E8C00528
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 20:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbjHBUPn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 16:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjHBUPl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 16:15:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60D72690
        for <linux-scsi@vger.kernel.org>; Wed,  2 Aug 2023 13:15:40 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 372HJSw9003832;
        Wed, 2 Aug 2023 20:15:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=9MvFpiDkAkb9crQOP41WPADMFIZm1FzTfTF+/QJ+Gec=;
 b=i0e2LT+7+2NAH/brzlBTOdvzNbv4DACZgto3Do3aVuTNZVSmZLC0rZK25AHsslfCtc/j
 anqPS9EyP4VTRrMcibV/qSPYJI+u6jBqrjTfOWNWm5kjgrpajdR1JQNI05TW3A2mKJHu
 wZq1IP3ox5PDCMSF7bJIWBE/zTZrLPpZj5DKwrEkmAXED3CX+HMi5JlWzGdDpkm5k+Yt
 CVH2+ft8hjZj/idNDjRXZK25wtTOufaqnicElxkSF8nFceI3iajN/kg3CTR673tPNV1d
 wFA1Mpb+wsAeDV9fa86oZxljWa0zqER8FJjd0c/ZS77fRAs8K46TYuTZFRPF5fZC167h wg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4uav05vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 20:15:39 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 372IdSZG015823;
        Wed, 2 Aug 2023 20:15:39 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s78nby4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 20:15:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fhBD5nqanQSkOpIgaawrpx5LBTj6ij+Z7xBuzObvKeIiIDQK/S3e7JGYjnafDZOujL6kR0cYvSC5RnFEEJQpxesipUMEffBKKPE/A1qZzKsJWfJTkfCNlDLLtV6/pXowEVXVwjP9deA+9gKOxG4qyJeTA8iaVTltVPQszM4OwS0td7wI+BofHSiHuVROT5QPAxZmsVdx67tKH2+7nE1AxDDbOHJitDqVuPkmJfOGLMWVrnk7ZGYhQJ4oCcCH04S0d1g9TyewTk+d5Nj6D5rCyTLJZGk/0ccbaUtIIaVtgumvyitfvg3gRRDDAXbeMY4MqOdPikslLiwdsduIU/Es4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9MvFpiDkAkb9crQOP41WPADMFIZm1FzTfTF+/QJ+Gec=;
 b=GeM6u6NLdEYWX3xfOxWWKEF7FA38U+TuBSP/mhbOa1W+3Nwg1zCYN2hPf5WcL6hCDoeqg/nntMI6GH0RhWC3M6tRHeEcPW/Wq1q9hD5jwUEAHxL9lXcYTNrgf9HSqmV+ztWFJtv7N3ISSfQUAQwPbAk4KEpfGIaQpNvPXmSukm5g3B6PLb3RSbwsU/Gl+pHl+5h7y2ibykCDtX9gMKHuKBH2PpjZEIP6hxsPqvOkcVdFmDL5CjQjvQc2pyBdFT73KWXHpah9QWxSwPh3aKNRhMvZJnh+sbiyaPrljLq5PQ16+nqWt6EVTf2bLL9m2GqMEtfPv7YoV+abT2jrnyLxnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9MvFpiDkAkb9crQOP41WPADMFIZm1FzTfTF+/QJ+Gec=;
 b=dOJBbxTpr6B9fTv4GjAKZ6s6tX7V/nBvzgPv3AVPm0t4t9PXzxUqNZm7UNHZunU2//OINSVzJZr+b6yJEt+oQm/yjEDXIcZ/Wmak+cvW1NDo4caLkqR5YVyfbfQreaYrHARk71C7V6k6aFuarlvCvo6w3VY3b5YnNnxS4g9VBKk=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SJ2PR10MB7708.namprd10.prod.outlook.com (2603:10b6:a03:574::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.19; Wed, 2 Aug
 2023 20:15:36 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f%7]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 20:15:36 +0000
Message-ID: <a9790854-13a5-0db5-f8a0-6564a5b1104d@oracle.com>
Date:   Wed, 2 Aug 2023 13:15:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 08/10] qla2xxx: fix smatch warn for qla_init_iocb_limit
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
References: <20230801114057.27039-1-njavali@marvell.com>
 <20230801114057.27039-9-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20230801114057.27039-9-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0049.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::24) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2943:EE_|SJ2PR10MB7708:EE_
X-MS-Office365-Filtering-Correlation-Id: f430283a-2f8c-4958-5d96-08db93953bc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A2TIaDlOeRGEAOvW2HqrPh+kehmrBt30dg5RUUSI9uVd8KfEodJCkaoggVtjINuVe+V+c+E6H0PPKalJCptYd6EExsYaktRmtqoN20otIVaawsLEf21gmT90UOvbK3qIjKVE6h08XYXfZqEi8pCrzW+Mfaw3aJwCa/sb56duwN5ZG4tuDnQIm2qwu/K4XF7n0i5BeTZo4Rteb0Rgdzk2HmVk1iDBZQ6FqOKmT2nbj/u0bxdy32a7RqnY3mxVtXwn+mHGnglz4b7DmIwVRHBzmHumYKNRpyYbHsy059xt7Zexmae4AV12W51MwtTRojetTmmnFNMTFSyRgpEO0dyVT4wfOMkuzyIuIAuNB/eWF3RD1cZRyX8nxr8LmsV8PClrlf69+To7BtkskiwZIcNUB45sbDvPJIbsYZGyR99v+UkxwcwMiMR+FP9OhRfxAK+CpqE5Ygl1sW8MsaC3VVQan50nMzngtNgF3okxUi+ZtQzYYYSQ55QSYwC8Hnq+2c5of7U+pomzR+oxiLdxj872q4buymIYDvUQdyZ4qyDW3qp+fh/3FnQRL8hikRClWGCbpIn0zVgDRCIEYVSN5QYWWcbywok22TbLMaCNkCJgo3j5OP+7wArxmqIia+72V+yYVbGjz20T6XJEUqkO/cAlgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199021)(36756003)(86362001)(31696002)(478600001)(6666004)(6512007)(36916002)(6486002)(8676002)(8936002)(41300700001)(316002)(31686004)(5660300002)(6636002)(44832011)(4326008)(66476007)(66556008)(83380400001)(38100700002)(66946007)(2616005)(186003)(6506007)(2906002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVpIdGVET3NOQW1qODNsc3I5Qjc1TWtiRi91MzVmY1AzTlB0SEZaWUREeTMr?=
 =?utf-8?B?YzJQcmNCS1BWSVl1NFFSNEZTVkxKdVlTdUlTS0pVZFFGaEx6S2xDWkNsb0Y3?=
 =?utf-8?B?ZkxvdmdwdjlpNkE5TDBRN2txc1g1VFcrUXJ2b25DS2xYQWw0UCtGMm92R0ZR?=
 =?utf-8?B?R290TjdjT2RwY3lyejJLcm8vS3FaU3RYUDNxREp1NlRqK3BKM2thNWw1Nldm?=
 =?utf-8?B?Q1A5YVczMStQVnUzbXZ0a0tUOUc5Vm9udjhxa3pKN2dxbnVZZW4vZi95U2l1?=
 =?utf-8?B?TXNTSklseFVNOW5LaUJwSGRLOXZkRlpuQXFaS2RtTCtOUVByaWZ0RnVWbDdu?=
 =?utf-8?B?WkR2M2U2aGpVbXlZVVlBakpBWkZ3d0REMWt0c3N1WVFuWDVEUUVRNmFKcWUx?=
 =?utf-8?B?RWU0Y0g3Umo2WkNLOWs3UzBVZll4dHU3VllrdERkbUpSeUt0bEQ5M3pRdTFU?=
 =?utf-8?B?WHRpeFM3VHAvMWtjd0w1aVpmUC9xZUNEa1puUnQ1UmVvL2c0eVAwNVQ2UFVj?=
 =?utf-8?B?VnVuVCtsaVF3QXhrY1dhZ256Unh3VjRrVlM4RjR4Y2VpT1I4MFJadkh5WFN1?=
 =?utf-8?B?TVFCY2ZIZ2JlTVBkS25LQkdhQmxCeDgyOFg3SVlGZXZROTNuYWoySzJyWTBk?=
 =?utf-8?B?YzJHemkwTUxUWVJLMWkzY01haVJiUjVLZDV4NU5vTnB5OGFXdUREVkU5VUFQ?=
 =?utf-8?B?MEFodWdaeDg2VE90Z2xwRERaTUlEYmxObjQrT1ZWcnpPcWRSWTdHcDdIMUM1?=
 =?utf-8?B?VWRuMEZIN3pxMzZBbSs2OFNJbUhtbFVRdWRJWU1FT3BrVU1CdnNSSmlKK2I1?=
 =?utf-8?B?dENtODcwZkg3eFlOVVh1SlE3ZXN2VzN5eVMyK2lPMmJjNEM5NWVuTzJMZUZJ?=
 =?utf-8?B?MzNwNHpuUWhqUWdOUU9wUXdZL3VobXgzdTA3UXBPY2FBNjZ1bVgyVTl0K2tM?=
 =?utf-8?B?SlhYTUYzZ3VSVmdlaStXbnQ1dHZUWlNUc2NjT0orMGFKTjRmN0tNamlIVXVN?=
 =?utf-8?B?amZNcDd3U2NBUUcvUGNIdXhqT1pyZ0ZtVzlwVkM0SitkVENQaTBFUzkra0Yy?=
 =?utf-8?B?Ykt4ZCtLM3h6cExTQkc4WW51WW5CcFFMbTNSMHBWR3VGd1RVSmxXaTVZeXVV?=
 =?utf-8?B?K1hRZUFpTURPU3lVaytWQ3lTQncxWm9QSlNmU0puZXJ4UzVBZkNJSk5XSUVu?=
 =?utf-8?B?ODF3NEc5V2Y3RlhvV3NwM25Qcm1rMEg4UlFuN21LVk5JSUpUaFlUQ2kyclVE?=
 =?utf-8?B?U0twRlYyak5HWGRHWFpHOThmU05qR0hJWVpUVUJnZGVzbDB3TkFBK1NIL0xh?=
 =?utf-8?B?NDhLQ0FZOCtoSDZ4Q2pBWHljS21wS2VhZ0pxeSt1NDJ1WURLRklNQlFGMmFR?=
 =?utf-8?B?cHdSZ29IY280MVN2ZjFBU210QWlVWGxXazNkUUhJWEJPdUdjeVZyZStKQkxS?=
 =?utf-8?B?YlNmTjBiTGlTTkVKeDEzbHpvTzFDNU5NZDNmY3hyK3BGd1cvRlFzeWM4elFp?=
 =?utf-8?B?Witablh3WFBVNm04MHBqZXlNajBqSjNleDNYdGhEaFJSNisxbFdWWVQ3NVNq?=
 =?utf-8?B?Ujc4SitkVDRObi9TYm81QTJGNm01bFg3ZjJ4aEZaZndyOW16L3Z3bDFmTDZt?=
 =?utf-8?B?czRYYmRJemdQZ01CMlBkSFVxYnhKaG9uNjZPNkF5b1FIZ25iU0dZcmwvKzF4?=
 =?utf-8?B?M0tXZ2VWQkVaWHZUSXhkWVBtb25xSnBoMUIydDhoVDNjMndjS3pKY29rY3Q5?=
 =?utf-8?B?bEZVTTl6WmVOL1o1bk5JMy9BaFZXa0J1eHpjSEl5UVJ1ay9uNDU2NkJ3YkM1?=
 =?utf-8?B?QnZ2VUZKeEp3cjdSRkNvNk1NelhBVysyUUVWeDhZcm1mb2NGQmlvVHJKbTNZ?=
 =?utf-8?B?OFhVUjQxT3c0bFh4RXo1UDJYeEs4SWFsTFpkYXVldmpQSER1bE8vd1IyaXRw?=
 =?utf-8?B?ZjE2ZlFpMUdQdzh6OGt2Y3dFYkp4N25rLzVoK0c4SllKUnVoZE8rUEhObVRT?=
 =?utf-8?B?RG84Q2s4bU8wSHRXb1YwdGhqUVRPS3JYZytwTTVlUE5SeWtFRTdjeFRLdm10?=
 =?utf-8?B?TVdTUVZ0Y2x1OTRvTUtPbC9BRllMSUFSbTBsZE4vczlCNDhyUTgyY0JRcnc0?=
 =?utf-8?B?WjJ2NmZTMVcveFhKWkRjTU1ZVVFSbjU3ajhkY1NIeW16QXZjcmRhNXJ2RDhE?=
 =?utf-8?Q?UQtOnNTxep+o1aUzWgyEcpE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: m+ucvvKmlx9f/1PfK5/ozfdeF2o26jo9CpqU/2YDbZi1IIrPa1neNOmUinSGpPaRs91r7OXeNQp+zFfq+q+yHDRpAPf2hCkvgAfP9egLy6Ijc4BS+dQ2+6rFDA8axdeRToanCNhKUu3UVWLqyl70WaosM7eIdmGXv05XQBp4A9Uy5eD32yj1VPwJ3O0HSR/u4H+9ZyLyIf4uwgbhSGJMadUhMOS2h4gPehmueVFd9rlNcSN9yK3YF9lByk215qVnQv876j3FKAcFSb3/vwWwL8Z7xaoO0jOFaI7uRaRmbWOuHuuJhbPn1HQ3pyeEVNbuudRQ4yuxC4HkHq2fyzl90f9ZB2K+6DDNMkkuUQJx0QqFgX63zeFrFJW0gj8AH4kiPsRtJxeWAVzbcYPP/rB6t/0hw04yzcQFepTE7Seyjm64PZpS7OtHypym/A3cMxBI1kruGOCl/wrY+qV9/S+GxCaBOsCTneailVNxxs7JAvxYJRxHidgJV/1NVwHx0zf3dWO1y4febQufby4lqKuv49eT2i4bbrzNn47CLyZMENfPZ4HOecN8lzNvLCiBydO8XeRvUUYyR9DS6HVminKCNgvTZ0OPxFahaJIun1SBnnz8jdnLjTBkIK2HNjKBcPqO2N08TYmT22RNQMRLOUw6DawHSocSNRqdWzrS9kJ+/SaRLCTWZIQjkqSa8ohcBAhBVQJyZG1xTza6UXMp4CkqJHrngC+qaX0WTtGrGlSL81EijJbeEkQpGjgJpYuQo1+y6Im3bUw1CcN/dZsBwVc1Yloqzlak7S+JtEx73iE4yyA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f430283a-2f8c-4958-5d96-08db93953bc1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 20:15:36.8038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RpVi7bjJr3WeVTWw6vAEYwb96jjavwZ8Z5EGD+6kJZZPuRGVswL3fX48+gEtoPHK8gcTXI8d6N6Fgz8Pvs1rl2dkr7S+OZ9F0XsNazFKF1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7708
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-02_17,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308020177
X-Proofpoint-ORIG-GUID: xod1bvoih_WdRjMRBiYJL9IkaVm9ovNc
X-Proofpoint-GUID: xod1bvoih_WdRjMRBiYJL9IkaVm9ovNc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/23 04:40, Nilesh Javali wrote:
> Fix indentation for warning reported by smatch,
> drivers/scsi/qla2xxx/qla_init.c:4199 qla_init_iocb_limit() warn: inconsistent indenting
> 
> Cc: stable@vger.kernel.org
> Fixes: efa74a62aaa2 ("scsi: qla2xxx: Adjust IOCB resource on qpair create")
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_init.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 3ab90c159034..62087ce51b3f 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -4205,7 +4205,7 @@ void qla_init_iocb_limit(scsi_qla_host_t *vha)
>   	u8 i;
>   	struct qla_hw_data *ha = vha->hw;
>   
> -	 __qla_adjust_iocb_limit(ha->base_qpair);
> +	__qla_adjust_iocb_limit(ha->base_qpair);
>   	ha->base_qpair->fwres.iocbs_used = 0;
>   	ha->base_qpair->fwres.exch_used  = 0;
>   

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

