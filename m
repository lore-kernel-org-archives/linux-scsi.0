Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 250D3C54EBC
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 03:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjALDNr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 22:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236337AbjALDNj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 22:13:39 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF5E4916D;
        Wed, 11 Jan 2023 19:13:38 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C33VFx006209;
        Thu, 12 Jan 2023 03:13:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=3cCtOCqgyKwo/hEhRw5zqyKTGfjNGO/qIHzIsEmLL9g=;
 b=ZRsr4PNpdOxoqLkwyMkshE73MKnewvchiSapZ965VybbBMkTbrZr8EF5rQ80uoGwK0no
 L1/MDTBI728MrvOyWtiWSjdFU5MgTBRlmk5QAQ6oLEIpkle50MakGSpq5c5zDBZQC7op
 NGCJE4GevLIMu7V1opnm/1JmBA9UhtJTYL00sTxTp3YMX79u2h5pLLTueXHALVSL2HLy
 wVT4slO7vVu/SO5W8fdfub766SjIjBPP/BY5i3/ZlukAjandxOtYJVlbQdgZIZR0GsRl
 f0tRVuGR7DZ8HQEWETlrh9WdvFRu2TA1pSB553c18Q5xE6ExN6sOkWXFZzfDJe37EuDY sg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n25k7gana-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:13:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C0gqu6007593;
        Thu, 12 Jan 2023 03:13:29 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4bm0dg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:13:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XERdnrmqhBTtNCqStJ4Tn1/haifsIXQnvlU3dzWnN9TbdCx7a3eRbIX5lZr0bbeyDt/gmKPdDt/NlEjuOFnxuKb+Fm7QIWkACfe/Fv+1fksQrBdBeA84yeZaGbMJiKpGLOj0d6t+XapniLi6kkcCNK1ju0kCk/hhNQvjNcBGqb6cNa1YRmfDulitpIOmuxYJeBwrziGkeUXWMTMafYkyTzkxMXT85kACwrOHyXXWvMbPTJ9b/cHI1BYKgHwjOLfGLeP7jwBWXeeFFGB5AXA5lgJw7mJ6FushgrsFniZ/kD9DSIXUMYa3qtjH8dUP0GrFsZGJx9FDqPoiJWoZ73FI8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3cCtOCqgyKwo/hEhRw5zqyKTGfjNGO/qIHzIsEmLL9g=;
 b=OEGAjav3nFdb8CkktqhEuATCAPRkuwPNxJbf0PDxeicb6rF70Pk9MAaziEl4lSm3RG05GEgiKyjVcTAyY69zu9uHy0MJIXdN09XFbiQPdK7f7wngWJ2CRWs57WwWu7peVAhGgn4TqUbC3PWNwlxB6fQwe01K57on7aPxWdx8Csz6hz5QrxqopyGZ6xISgXhQh1u1rOIu2n4nC19euyQelauZ2Vt9wE9ODcd1zfvZMVjeXUjSHZ2+7IxZ0qsPCbFakLeXDIYSgoUmFD8ZGFS9Yak0e13u7Wxt8zpHTRd9ithWq0kzMoHjQ6sFDxZvPPrg5bB3HBZYD0fYcIJIW9seRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3cCtOCqgyKwo/hEhRw5zqyKTGfjNGO/qIHzIsEmLL9g=;
 b=dXXUJSI5xqTRzcBBjhgxQuQhLBaAcpmYEd3pISBiQhs+JkYe0ywT9IO6WIqzoXOPQQZsKQAd01jqf9SbqfL+iSVA5jbu8VZeibxJeSj5VbWAiRrNbdkqwBsClf1Q1JsnA9KIjRVcRP5Oxd7KC7KRwd8uSUoHLzp3mM7KXaFRIkg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM4PR10MB6158.namprd10.prod.outlook.com (2603:10b6:8:b8::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.11; Thu, 12 Jan 2023 03:13:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Thu, 12 Jan 2023
 03:13:27 +0000
Message-ID: <c1a395a3-74e2-c77f-c8e6-1cade30dfac6@oracle.com>
Date:   Wed, 11 Jan 2023 21:13:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 00/13] target task management fixes
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20230112030832.110143-1-michael.christie@oracle.com>
In-Reply-To: <20230112030832.110143-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR07CA0043.namprd07.prod.outlook.com
 (2603:10b6:5:74::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DM4PR10MB6158:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f6b0af4-5a46-4716-d902-08daf44af8f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DLJ31rTWc90ErxqzCw587QSso6TvZEzgngT7o9bFWi9UHOhGsSKjPHxKBvYJd9cYcd/oqL9Exp472UIDwMUF/vghv46upj+O9zxVbhmduFMQCbpbcpef3uo1ciPQK759VAM0Os48nbk6+lwQH6X5dEnVgaoXz04fSj65zn7QGJ5qdhYPZkmYFdcAm/tyag9oSjNxOPlSrjlXoDlhrMcO/Pfv43WOnT+bBV3doBSe4CgTe1P3uIsTYClALzRC7c/7OkEp1OGF0i6aywlazwnkLVEcaLN+vhpl9+/uUl/MRWZYz+Lhrmsg1ppDTgvipyFDZOLDnIg9WxX6ipCswXSY7nEFqao2Jcn5MnH6B3qWWHXv4gci+ccy2UkctYBRaLrlBZxWjefSN1oG6OD4yA0scU9X/EgBhLLNf9JQR7AJ3ZdCwbMv83Cwxo4SCCdqhrrdVQOR/uHoKkeJkVODyu4Ci8KCIv0OVdikfFm6sun1rJSCYBjvrS2yZGplkuTnKDPmmB9p9AhGQYdaWhfcDZBWq6ZqO9aEX0vOrysWz+n+T6p/2Vxog+kA3e+HGvx1E4EcAbNwoXnEQd+LqfO4copMP5m++PSiTtcNZ3B75Ki/OnatN+q7cGoKYN7EUXWPQ9hHPhkYDeiFvidBfVO5oYmyfuBDqBXLCpZ4D6ktjDd88hIlggoGbQd2XQ+OsHB4XwsaEr6mnsr/Fpr13sVr6dMfnlkm0hz31UucT4viIOKgK38=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199015)(26005)(186003)(6486002)(31696002)(6512007)(478600001)(86362001)(36756003)(6506007)(53546011)(2906002)(31686004)(38100700002)(83380400001)(316002)(8936002)(2616005)(4744005)(66946007)(66476007)(8676002)(66556008)(41300700001)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTlOWFZ4Mk00VGdjYUtNSzRReGpKS1JhMDkxK09QUk5USnpna2UzeUkwV282?=
 =?utf-8?B?UzRyWUZlTTMwaVNQeFdBWVpiS2xBeUpCRElnbGZmRXVOVFdyeVlTRjlMRm11?=
 =?utf-8?B?Z3A0ZjVuT0N0alN2R0Z6aFROUWsyZzZkamVLMnVsL2YyTjZRWVBpNHpDSjNs?=
 =?utf-8?B?ekNia2xQazdOdVhmbU5peUN1OWV4V1V0UXk4STBJUEJIV1lMOWNUUFR5c0JY?=
 =?utf-8?B?TEpaTWViT2NzZFhZNUV5Z0tPRCtpd05NNzczSGF4K1BibUcrd0g2akZvQXcz?=
 =?utf-8?B?eTdyc1RTRjhEREdSS1VPbm1EMWd4bXZHZDhlUkxhTkVMY0c1THVUeUIwTTJ4?=
 =?utf-8?B?dkZzalZldG5vYk01OVdTMkE4QmpxY2Nva0ljZyt4TVlQWXhqSmJ0Um1MRFMr?=
 =?utf-8?B?TG5VRCt3eFBMMkhjNWZLUyttWXAxb3RyRS9Zd3I4MlppdlJmbkppWS9LcFNB?=
 =?utf-8?B?MmpTN0JkeGo0T0E2RjkwZEwwalFxUTEvR3g3MWl3UWFzV0VzTjdKZU9LQ20r?=
 =?utf-8?B?a1FFQjY4Zkh3VE5qcTNBTFdwTXdGUWVWNE9sbEJXR0tBQWg4bEtoU3JsaHRQ?=
 =?utf-8?B?TGc4UnQyTkFwdy9SYnZ5ZThiZFRtT09GWklTNFZpVlJNRkx3VnUrdnVHN0M0?=
 =?utf-8?B?VnFhTm5FNUxXUWlONTBSWUEyRDNsTmxUNnZKWk0xR3d2NjI5Mjh2ZkRqSE55?=
 =?utf-8?B?RURmbnZWaVhNeVk5ZDBvK09aQ0cxOWFOcWdsd3pLOXlHWjRUS3d4ejFPR21v?=
 =?utf-8?B?Z1FEbVpEbitOODBsNE9BNWdMYWw3cXdISDJ0ZHRpT0FobzU0UHVINWZyRWc3?=
 =?utf-8?B?cHpneC9iMkV4RjU5eWtORHF0T0xDODZPb1NpWGlVbnBvZ08yRkQrV2lsdnlO?=
 =?utf-8?B?K2hJSkRXM2N0elVaUGV6MSsvWXdLT0FleHRnRFJjVWJGRTB4YnFsUTlETmc3?=
 =?utf-8?B?bkEyRlRXLzdkeHNNZW5RcktFQ2d4ZFdER1BqNnhaNm9meHhnZkxIblkyOHBw?=
 =?utf-8?B?NkxlNXNwL0tvN0FUQnlvL09scTJLMDZmdktVVXhSYzRMYjNTYzZtQy9ob3Zt?=
 =?utf-8?B?Z1c0bFZ2aVJiVDNURE1wS28yaXJwSTdweTQ4QWpwOUE0VU41eWRWM2xsOUpS?=
 =?utf-8?B?dDRYK2lzVVoyME5GaWZXMXQ2UFRXSktNcXI0QmNQYU5HSjIzYmtmWWJraTJa?=
 =?utf-8?B?d2xQdXZwTklLL3h2TUN4MnI2cEYrRCswVmFLUTE1TDJGQ1BYMG5aTWJ4WC9Q?=
 =?utf-8?B?aE5tL0V3SzVkNmZaMTBDMnhFZk82bTFDL0lVUGFETjFWVnN2RFlLRE5YVE5a?=
 =?utf-8?B?SmZOei9pZGRzNktrSWM5SkJLKzlUUWhKVFJIditkelVGS0VJcXVoTVdnNXNF?=
 =?utf-8?B?Z1hraXZ5T1V6eEdadFQxRzdxb2I2VEFWa2JEcVZWWVA1ZmxHQmJQZjlwa1BF?=
 =?utf-8?B?c1o1STFxaGt4L1NKRXVCZTlhMk42RDVLcWJpYlJDOWgydm1mRmZyMWFqcHRD?=
 =?utf-8?B?TE91MzRoM0xIRDgrcmFBMGhBSFd6THdhOVNPTFRmQzJKWm15YTZwMlZnY1NB?=
 =?utf-8?B?OG8zN3RudGh6VlNjd0dSWlRhRTRFdyt0N005elB2N0d3b0MzQ0dsL2c4aHlx?=
 =?utf-8?B?OE82cUN3T1pBRldMZTN2MmpyL3FvT0dRU0pUcHdpeVFxYzZsTkVwdk9tQWF6?=
 =?utf-8?B?SVZCYk9kQ3docjFhTElKbTR1OHlreDNoSm9tSy9JMXhCQXE1MDBycVJPQkYv?=
 =?utf-8?B?MFRsbW9HdFhwdTNMVkxsdVc5dXBqQlpJazJZR1pDYmNjdlEydmgxL2laSVZt?=
 =?utf-8?B?Ymo3c0RJMU1hWWlKNmp3NzUyb2ZqbTIzZHBwODZvVkxoTHdsZk95NDZRbTE1?=
 =?utf-8?B?UkF0anhjMFZUdEQvMVhrWXpmUmZJdlFkL1VyQ0tqSlZFbVMwUW9YZVBhcDRw?=
 =?utf-8?B?K1pXTTRvVWlIeVRMUW0zY1ZTY0lYaEdSenVYUlQ2dDBHU1RXL09hcCtDUWVB?=
 =?utf-8?B?S1NreU5PdnUya0ZibnBKT1dCNStzaXNWVjBDRGdtYVBQVHlBZlNUdzd5YjRL?=
 =?utf-8?B?SGtqcjl1UlBWVjAzNFA0TXJFS01iSFpxa0xXNUtCNTdNWnQxeE1QcWdBbDZ6?=
 =?utf-8?B?Yk1DVmRYUERhNElkK0VnQ3VTZ2ErMGxCa25nZ1pPV2F2Tm5SUTBVWFFFOXZL?=
 =?utf-8?B?ZEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: KdyzJrMwZxMvBNlwPvKLiHf5nXniIapvWe1yNQZa7D1zSdGwNpW57CL/h5mdM6V9Va/XjDiWl+nG4IPx1NGQyzls6aLfHt4dx+RPdYyb78wBZYhiytpuqhx6GfGH6b1uYQLWIkRLMHBCGdqCGq+Til93OYiE7W99Z36Ill87ND7NNG2vOPAyxrr6K04R/+Z3NdTIdfuHyIU8GQbOnfRZmf15vUPpKJQLbxhkn5at6lE9BWLi+TW8H89/Nw4pOZj7daOiZjCrVVxwCifXHYq6T86lGTqZ5qN83xnwgkVERfYF4gfP4kBE72R1YPJlINiBlq4MtcnkWKp7FxBoRZOWi2a+QmnQmzEoRBMN5BXkG1TfazfvYj7zNn5DIhTUjkF+ju9VgmXSgfajUquUORlgoYnwO4lJl4v6YTGTcY3TUovkN/Y4B49qLmh9/t9logYC/Yj98eDV/EU+xHmHdN0tzXiUw3cgSlqvMdeYMkCFSN3NOw/Xhn8030SzG9/omzFx879RGfbs8q98n8h+j99+SWh/ijjYJprP/yyM9RnYQiMbKxPe7pIwr42vdjpDkbTJFJceXr5ADo13v72otCTdwWQ5J2Jjp/aiobRdojYFW6sXbBWrkHDvCrAiJoy8JNB2E6mjhGeOAnDvZCEvLzvmHglmksJBOGf5UxbW27nBPo5xXt/aqn5S8KUFmPb23vBFtKV+1Rk4HpTWayFJvtTA6gxa5J1Vkxea7Naf9TaotIcgC3J2zR+25qkHYW7jzDuqhUWalX3HZT3vk+vzshC2wUicUauXoh9tvtTYm1u2nm76Hv/p8FJrPDUKMR7KqN0+U4Z2zSJ7Rg3aSVMgxTuHlTbu+0o4Cd+30akeW0z+JNr+9Nybrf2q5v9cDQA4FUTp
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f6b0af4-5a46-4716-d902-08daf44af8f7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 03:13:26.9658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y9DEgf6ppfpVHH71gAg+R4CzfI83lfzD/1wZgeKw1h7A/GxNhrUWYBO2jUMRchZsOh1Awvo8Qr69ogdrunRNwA/j3jKYP7Mk+E0RqgFdODQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6158
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_10,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301120019
X-Proofpoint-GUID: m9iDxTg8nQxv20RvFXPU6DRuQp-RNk9_
X-Proofpoint-ORIG-GUID: m9iDxTg8nQxv20RvFXPU6DRuQp-RNk9_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/11/23 9:08 PM, Mike Christie wrote:
> The following patches apply over Martin's 6.2 and 6.3 branches or
> Linus's tree. They fix a couple regressions in iscsit that occur when
> there are multiple sessions accessing the same se_device and TMRs are
> executing and a connection is closed. And they fix some bugs in isert
> for the single session case when there are TMRs executing and the
> connection is closed.
>

Oh yeah Sagi and Max,

I didn't post the write_data_done fix. Let me know how you want it
fixed and I can post it.
