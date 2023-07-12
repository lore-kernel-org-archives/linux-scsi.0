Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1CAEB64DD
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 11:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbjGLLS0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 07:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbjGLLSI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 07:18:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BFA1BDB
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 04:17:55 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36C6mjrE015124;
        Wed, 12 Jul 2023 11:17:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=9pkbTXCiaho/+19FOoSYS16lAv5jzlh5k+oBqf3bfl8=;
 b=qh08Ov+DM+jJVZFiCmeW96vza1WTzWyDstnl6hcZ4LR6TuFqm2tXXU43FksIOIca/5rx
 89ZhnHmU/nq8saLNB9F1+qb8lnZhBjc34rME6Z4SAHgytKtxYpKvSqKb5gf9ke/AQhAw
 o5xaSzae1eKl4JHBqNOcfMj2SyVTzQtyYU2ToFZ9b0tkj9DmP/7S75BPE4efXSdrADOj
 dmFOhwGKcPEhHmvpgISoYUk07kfnRsxViYLtXhzdC3pT5wzoyTagrWmePd9D4Sy2olLq
 C4j605pCdS2G+tD3xnOsrRxJ5u47m3gAH4vtHWJjpVsHnCO9rR9J6Pv78OVhq5JShwtS Nw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrea2w0ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 11:17:45 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36C9jbfk033293;
        Wed, 12 Jul 2023 11:17:44 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx86vsvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 11:17:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DO4atV0Q41AOYyj10FVoJlpygCELwtIvG5XBtVna0sQPItT8ln8wmbRjBfXhmsOvTfuoSJA5qSwTtDAD7MQJbfLAUzvTxzAG/htIjEUHbx+y1f7vsTB4V0fsCph84ohjmQ739n3zps6hcUeYy/IgfC+GgPdQr14UltttiUlBXX114IyncdAZtnK0NvY1E6J2mrF2qi2yAZtrKaxUff49VOacYe+hAoDJV4GM1qG85mvZga+5RgxWETRZBz/B+qnLOGIJ8elVpvbd6tytGrpGpj24A5aSE6sWm7YPJagRbVxFrdZ+qsR0gMJBXNjmS8jog+0m+ZA6DDSPm2Ezz9kF/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9pkbTXCiaho/+19FOoSYS16lAv5jzlh5k+oBqf3bfl8=;
 b=CUzspL+WsitROZDbwIT6IsYcsiOh42boAs+ArYNWGyuj860BqX6BA+dkMiFRXsgeeTBe/v/wrNj4KwcDg2rVBvyXq2AQRV7DTgAbISZ1RSvqVbLYQ23WLHhYCP7SZZWqNNo01rd8z/idKxKw4Gut7k/zFwseC1iV/pJvJleo/sNckkuZaS75XvtNF3O3wfO2UlDp3bUEA2Q4SaY85R+z/WCjGEDiMdU2mifBWs8mkllnUWn/uuKrAR8wZAhx/bjLPHIWNcAhKiQDU3b38MI0NIG9BDD1Vd1RXIQz+05fLIFLtSSCVGgrbJ6Cx2mtm8QkqrtEq/jPqKv2vEPzqcuwMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9pkbTXCiaho/+19FOoSYS16lAv5jzlh5k+oBqf3bfl8=;
 b=Tszv8CXYG/vu9On1pcvG/p0+oU80Ez80ess46CU+nOnY4m5BKJE/lrL9C/PB00kQmdksqsMuopr7qLuRUxozyNHSS3LcWfxx/DvCiwwJOU1qUjQzzA5pr3DIKCBUha6AftHxDdHiZeL75Ozqazdk1DhEj6R84houZ/tQr9H+RD4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB6033.namprd10.prod.outlook.com (2603:10b6:510:1ff::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Wed, 12 Jul
 2023 11:17:42 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb%7]) with mapi id 15.20.6565.028; Wed, 12 Jul 2023
 11:17:42 +0000
Message-ID: <1a86601b-4cdb-7bd4-fb67-326b39670eda@oracle.com>
Date:   Wed, 12 Jul 2023 12:17:36 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v9 04/33] scsi: Have scsi-ml retry scsi_probe_lun errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230711214620.87232-1-michael.christie@oracle.com>
 <20230711214620.87232-5-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230711214620.87232-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P265CA0011.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB6033:EE_
X-MS-Office365-Filtering-Correlation-Id: 22615fa9-5ae9-4a74-1544-08db82c99bcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fMVDmC0GcQWSoSNG5m89ZeLb/irW/eS3pgRUTcNrH58XvWADy+lL2Kk4UMJ/Y/Ke/eEtf/Y36y2ZVLniugM5zfJSp5Vt3nJL+gcvjhD815TaVlrn+8ZdXel/C4hMOA2GZb8B++fe7DZRAe3mzRwmxYXy6spaA7Q/JI7ZBrwTFjzIHPjMN78YDPXim7WByyvQoqwG4ZqbC83XNRHGD9nmOUX29EG6r0QWesFmKceozBy+YTXi8E4mfYzmAevdZgTh5qHdDHzrjQrU87Rrhsf+E9AVTc+KlosXT7pnpKY/ixJa4JiE5W3wufoshAPBI+w7VEwPb6iHQrSKyueE9YwdkPvFglDAYCYIJ77E/Rb1yf+9qjldQy2xR+gcxELh+VFDYAiG0iYx69gi3dnEoBEzCk4jwkLmKw/OOJHXdZlDExSMbwoc9WOK33GEXAKYbQ4b8OcVjknoXOQfJOEijM1hko0gL7Z+vJWGC8S5ajwq+QAnBdhqiwTtyq8o1jUBo9Tv8xy4YOiYbX7FbJnHDDzFAcBzLwXJ6o9sl6VxhOdc/thIDJ6SmK3PQxWgeuYvwdzQOikgRNnzkgR2heBVgUPUlMmtZNXJP20vmPedmbwuPTatZnJwY8rml4CrtoM1mzIZjtZLkX/i0YUTGKtOu2sUvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(39860400002)(366004)(346002)(376002)(451199021)(31686004)(36916002)(6486002)(6666004)(478600001)(66476007)(36756003)(66556008)(41300700001)(316002)(66946007)(86362001)(6506007)(31696002)(26005)(83380400001)(2616005)(53546011)(186003)(6512007)(38100700002)(8936002)(2906002)(8676002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z20xbmc5VkRTN2RReW1IVEhYR3NQQWRHbHBJU1M2OUJ1Ty93eFNDclNwRWN3?=
 =?utf-8?B?QmE0RFM2SmdrQ1FZTHhicXlGL002WGdjUUo1bjZOUDRJdmRUaWJmSm9xbllQ?=
 =?utf-8?B?RVVadVNyWUxsQ0RnL3pVUk1ENkhteGEyNmlUem5QNEFGRWNDYWc3dEFGQzZF?=
 =?utf-8?B?Wi82eDVzR01sZlBhOHNOMFBKMVFtSTBHTldzNC84Z3lyWEJZSVRoVzc5SUVO?=
 =?utf-8?B?QklJVHJLRlJIaEE0UWJ4VUl6am4rWEdpTmFNc1M3UGh4Q0c4TGlxUHBZU1F1?=
 =?utf-8?B?bVNlYWM3akVQSlFCdDZUcEdaNkJJVmJ4Zzdmb09waXQ3elo5Ni9JRFV2Tkxi?=
 =?utf-8?B?c2RtdzdxRHZnZFZqakYxL09OL1hMc1VaMUl6Uzc5M2E5RlRRTTIwdjBabjhJ?=
 =?utf-8?B?MmFQcUhyYkVxS1E5cCtMN2IzL3hvTzduNGlaVTRnOUp5MDFsRFdHZ1RzWE9Q?=
 =?utf-8?B?enFHaHRpMk5wcm1zYVdwVVdSR1FBbVVsK3UwUmZjOURJVEdTKzF6b05YYTlV?=
 =?utf-8?B?QVBOemxSVVpHTHgyMWlkY2tvNU5iMkRWRlU2SFdmRjdESStlc0NWTXZZQmlT?=
 =?utf-8?B?dTdZVTRIV0lBTmtVSFhlamNIWUpkUC8vWmovM2lyU25ESlgxK0FvRTJ1ZFFW?=
 =?utf-8?B?UjVPMEtudk1KTm1EQlErNUJKZG1uVm1zOTExdDZzVmdvVGRZR1Q0ZFJqcEVD?=
 =?utf-8?B?eis3SGx0RFpwbmlsUVFHR3E3c2FRek40VHUvcVZmc25YSlQ3R0Q1aGhIbFZI?=
 =?utf-8?B?UVdnVFU1YWFyTnJDTWJXY2hEQUhIQ3JOT3hNWWYwRjZwRm40VkVoRUZxdy9V?=
 =?utf-8?B?czl6d0kwbmpqSHpDeHhubW5kSkRhNXZuTGh2aFZkdFlucy9GUnFRQkxXM21R?=
 =?utf-8?B?OTB4c1M0UDlHT3JVOTlBeW91bDRyZVQ4OE5zUXRRR2JIVjVDNzNwWmQ4S3ZI?=
 =?utf-8?B?Wlc4MVNzaWVmTkcvZjMwU0tSZmFWSG16U0kvakNnWEcybUloV2tCNWw4NmlT?=
 =?utf-8?B?b3JSS3IxNGVEQ2ZGSlc5QUY0eThzeW0xY2N4SGhKSUtudzJPMHhCNks1S2RP?=
 =?utf-8?B?NVZ3MnVQemh0Mkd1RXNGZ051TmlobE9VRThEbld5MW96cDhIdzQ0czdhd0VW?=
 =?utf-8?B?eDA3Ykg4a291SEsyTDB0WmpSWkxVRlA0YXlMWjFNRDMzNzU4Rks0S3phejF6?=
 =?utf-8?B?NmtHOFYrb2VXMUVnYk1YSmhoaDlVQzdxc2tlQUgrNytEbFp4TDN6OTF1UU1Q?=
 =?utf-8?B?aUJVN1VlZEFOUVpoMTE3MnF4QUF4VzNHbklFcWdQQktkaks4KzJYazJmNjI4?=
 =?utf-8?B?WUtvU1FHTE8vYmtVeXY0bXhTRGQ1eFVrQlA2R2E5Um93NkludmhmZ3htamx0?=
 =?utf-8?B?MW9zRE5pMUwwUlpROGhCUmszOHFaWCtsQVExemZWbkk2a1YzcklSU2kyU0JJ?=
 =?utf-8?B?NjhybXREVlBhUFh5V3hBU1NQREcrQTlhTW1HVGpBdDhpV0VEdVhkNm9KRWsy?=
 =?utf-8?B?ZmkyL2U4ZDR2VTgzL1BuMEgrZHZ2Rks4NjZRN3VPM3F1U0pWQ0d1Zm5VVVpX?=
 =?utf-8?B?Z0lvM0dMKyt3a21ocmdlQ0lqNUFWOGR2WEJQeDZOeVZpYjJQYm1BMmlMWkpI?=
 =?utf-8?B?QnAxMmNkRnFsR2tXemh0b0d2VmJiSlBxSm1aYUJOdGU0czN1ZXpoYUZWZnMy?=
 =?utf-8?B?dEpmaDVkdEdQcnl2eHhndys3N1VyRElzVFljUVdBampXeHptWWhOR0M1MGUz?=
 =?utf-8?B?SktIRCtMNElCOFU3VERxdDlUWlNuYVdTdm1Qa3M2aXJXc2FjendnbmlPa3pv?=
 =?utf-8?B?S05iMGlndzJaaUczeUFqa3dpK3BCR1h4eTlWN3RUai80OXpieWc0ZGU5TzVh?=
 =?utf-8?B?STVhVStUVDFBL2pUb2k2L0FrNTdwNWJqbkZ5VFRXMlBpNTJ4RjNWUWVtZUdI?=
 =?utf-8?B?NVFZeU00VG9xUkQ3NThiclQvUEowUFJvbkFiUmxCcDJXNEtHZ2J4RkVwbXFr?=
 =?utf-8?B?VDhPSEtkZnFBV3ViMlk4VjFUSmVkT01OMzFlaFk5RVUwREVRSEFlM2Y3bFdC?=
 =?utf-8?B?aU9qV0d2V2ZNN0U1R3YzeU5JaEZ5T01FMUFPTVp2VFJOaFBqL1VjZ05rZm1w?=
 =?utf-8?B?UDZocTl4V1lMdENLbXd5NW9qVFVGNmx0YW9tMWgrYkFZdWNJRDdycmFrc0Nu?=
 =?utf-8?B?eGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /cjxK+/LjbJI6B1wCwyunzzBudOzXWs5O6tW8W9XEMba4Ai+kZE9YBYXLrBV2kca1LHaPwzywV6m1b3EK8yAgdcxRNTNF8ALis4jut9mCPGHSAnPEow0OEsctLvn8UjkmPClLCSAc1MidXwkCT/On4s/zkPnb7lLGGmD7uhYbm9sPObcEkoNBxkbZl3yPwFpgE8yYPn9wa1Dwz7O8v4qre7hWh9RchGb+dHwIvLox1hFIVSWCm59qTU6v9cYC3oPaDA9Ruas11LgzL/W1S5OtSBXWxCyS4o+BeY+61yqOVsS2tDK3OpPK5b28YFd4Nq0VAZcJ+/JUbCnwksaAPAlCQgD78/eMeIkmY+v5QRYSZUOiNuMFRf6PUpYXRiDQOt3A3coDgNsjlkbcBtOXeHtIUzvVVXR6KZZJvBIO7CTjm/6bf3ivQUyITRknvM0uWcOC7XD53cU0Pc9X6yumc80M0W6rUrRJGKiJnSpcpiGKURCDHZ7sRsuxoRQMAm9BPDvEoNw3Ee7/OlyS1nf3P5belnlsju3KXoK0mGlJUcau1J5nQ3KWVa09soxhmD0TIja6pcSmL0Pj38j6Q5JhP5P7lCgji71K2qYeoQ8WEW2jw3qgVMAiU7v+3ZE6Wt5T+nJnk/iRKtSCcgjvBfIbLmWIsK+jrpOuQBuiExMBpveFAIwsNpFmVvNPK4T0DpIci8CFlX+Z4qoEaSDOmK/TaEv2ZnSWOZUgMNjCJND+5WeKjlkpeXhHCtoHL2PsP9VpI/mLJUbFrPpn5IsUrqPiDSL3svUCtE26lcBGGWPKovoS1sdW3vzb4xz464rPsh4g2PqR8ioaMuofDEmRa9ISKbRSVzrVmUsLxjn0jlVtKCWkQ54gGYPdlouA6LKgs4p4Rnp
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22615fa9-5ae9-4a74-1544-08db82c99bcb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2023 11:17:41.9150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rjge29WzUBgpQ8JV1YfIIklYcBdzMb2a0gy6NXY/otBmQO3ms2jj6R/C6Vw4WycBBlKn21FmGCi4VP6b731VZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6033
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_06,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307120100
X-Proofpoint-GUID: 8r_PveMSn54QzT5bPf-_81FWGoYxm8B8
X-Proofpoint-ORIG-GUID: 8r_PveMSn54QzT5bPf-_81FWGoYxm8B8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/07/2023 22:45, Mike Christie wrote:
> This has scsi_probe_lun ask scsi-ml to retry UAs instead of driving them
> itself.
> 
> There is one behavior change with this patch. We used to get a total of
> 3 retries for both UAs we were checking for. We now get 3 retries for
> each.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/scsi_scan.c | 42 +++++++++++++++++++++++-----------------
>   1 file changed, 24 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index aa13feb17c62..519755952254 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -647,10 +647,29 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
>   	int response_len = 0;
>   	int pass, count, result, resid;
> -	struct scsi_sense_hdr sshdr;
> +	/*
> +	 * not-ready to ready transition [asc/ascq=0x28/0x0] or power-on,
> +	 * reset [asc/ascq=0x29/0x0], continue. INQUIRY should not yield
> +	 * UNIT_ATTENTION but many buggy devices do so anyway.
> +	 */
> +	struct scsi_failure failures[] = {
> +		{
> +			.sense = UNIT_ATTENTION,
> +			.asc = 0x28,
> +			.allowed = 3,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		{
> +			.sense = UNIT_ATTENTION,
> +			.asc = 0x29,
> +			.allowed = 3,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		{},

nit: no need for ',' on a sentinel

> +	};
>   	const struct scsi_exec_args exec_args = {
> -		.sshdr = &sshdr,
>   		.resid = &resid,
> +		.failures = failures,
>   	};
>   
>   	*bflags = 0;
> @@ -668,6 +687,8 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   				pass, try_inquiry_len));
>   
>   	/* Each pass gets up to three chances to ignore Unit Attention */
> +	scsi_reset_failures(failures);
> +
>   	for (count = 0; count < 3; ++count) {
>   		memset(scsi_cmd, 0, 6);
>   		scsi_cmd[0] = INQUIRY;
> @@ -684,22 +705,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   				"scsi scan: INQUIRY %s with code 0x%x\n",
>   				result ? "failed" : "successful", result));
>   
> -		if (result > 0) {
> -			/*
> -			 * not-ready to ready transition [asc/ascq=0x28/0x0]
> -			 * or power-on, reset [asc/ascq=0x29/0x0], continue.
> -			 * INQUIRY should not yield UNIT_ATTENTION
> -			 * but many buggy devices do so anyway.
> -			 */
> -			if (scsi_status_is_check_condition(result) &&
> -			    scsi_sense_valid(&sshdr)) {
> -				if ((sshdr.sense_key == UNIT_ATTENTION) &&
> -				    ((sshdr.asc == 0x28) ||
> -				     (sshdr.asc == 0x29)) &&
> -				    (sshdr.ascq == 0))
> -					continue;
> -			}
> -		} else if (result == 0) {
> +		if (result == 0) {
>   			/*
>   			 * if nothing was transferred, we try
>   			 * again. It's a workaround for some USB

