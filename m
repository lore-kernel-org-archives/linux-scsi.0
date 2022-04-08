Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06DFBC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 18:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbiDHSrK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 14:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239005AbiDHSrA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 14:47:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CF41C60C4
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 11:44:32 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 238I0wn4004957;
        Fri, 8 Apr 2022 18:43:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=4fU6Sddf1XQBd3n4Z0odyMT2RYTxvrUyo+pmaKvE3yE=;
 b=YYvQ9r5qO+ayYTFRTMjQCxpvBv2Nc2n4mDPM18hl9PEIuB0TsuQ0lEzwKjgsASv7Y/9p
 I+lrrfL07OqoQR3+FKQWFSnEGSnzIrrehC1zcudAjUgs7e5NQbh0RSutgvenVNqoqDea
 5DIfBFBW0hIzBL0ZvNOcu/kZNEwe0PrsBvTWXY69bvI71W3DhvujrJYppixHw3FFqRJm
 xFEBv07ojlTJsR8qDrSun7kZ4CwXBRSVdZmVxQlxNR8OYl079LnVzNsyNSuQYeqq42xL
 6XaRpexrFyhm4ZRyzxHIH2LwTw1Hp8+4hEo+W4p9xMZiLFZaI9S20YlBoExFpVW78Og7 Kg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d937y7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 18:43:44 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 238Iesls028812;
        Fri, 8 Apr 2022 18:43:44 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97y96bsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 18:43:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cvhxYv/eBImkQDEZSeeuQwFxgS+qwPSB2rY8X0gu4TTuQIUV48Qs2pe8M9o+M3dTx/A1mTRz8lWG4CAPYDfyVEWuBev3bRrNpzjAlRztoXwPxP1bQNTbcVhNxrCXyKoiliI8HS8dJomXxkADMDZZqdQqn/ck0WuIDsP2hssaFgkYI2g+oHoK5vIs8ZsQW8XAplDmOTWsj47o16FULjte4xsXftvZ9PsxnkQz+qPB2JJaRnyZrOQMgqxEHgCUZzCselOOq4ZOUI73+MAYUdyXQX40ZIzCxoSqtlTh8rdpQGW8t6vffuxhBDJ4I9HKCS3V0nlqsRU+h2Cq2jxRHeFL2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4fU6Sddf1XQBd3n4Z0odyMT2RYTxvrUyo+pmaKvE3yE=;
 b=fPgElio6H8dUpNO2f0nle14XsKGg+AxVVh3339qXVZAwz7IOCjrnlhuEWjo7vauL4mUCsKnV0vmn9/ghgaeuQtX0ozGFBJb7TmKkt4PaTKGgXlkHFnNGvp1Gq7JqiiDnqfM2biaBdkxRlhV7BST+n4GMwxAh/n6yLU58fnuwUWly4/UBo70r67dgV0bEuvOe2KpjnvMn5RYa2/y2j0hMOVgrlhyZejIHVgqd9c8JbyKXW0elWOAPs2E0D2duJFi8lHSy9iPuD6yXmXXNiR1FMrQHhChi0/Z60lYMvW3r3skIaQKfkQZ8lP+t1mPaxZqQrNpjm+nm9SMDiYNFq0nGkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fU6Sddf1XQBd3n4Z0odyMT2RYTxvrUyo+pmaKvE3yE=;
 b=GugymyJgDT2VGiYYiTHv428/mFhuiJtXixWv5wfDh+l5pvMlge4vqpcWeTkHHLF8wtZO6LA894LZ+caUj/+7CcNEue8EP31/izIxtfowi+hJbhxi6UAOMcv8iGQr8hVO4KL5jFOmPnqvy6uCNeTe+zbI/aoDHCx58tsi6OajqWo=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BL0PR10MB2818.namprd10.prod.outlook.com (2603:10b6:208:72::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 18:43:41 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::59ee:c799:39cb:c54b]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::59ee:c799:39cb:c54b%6]) with mapi id 15.20.5144.022; Fri, 8 Apr 2022
 18:43:41 +0000
Message-ID: <cd716c63-b644-fdfb-f88f-60527f1e80af@oracle.com>
Date:   Fri, 8 Apr 2022 11:43:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 1/8] mpi3mr: add BSG device support
Content-Language: en-US
To:     Sumit Saxena <sumit.saxena@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, bvanassche@acm.org, hch@lst.de,
        sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
        chandrakanth.patil@broadcom.com, sreekanth.reddy@broadcom.com,
        prayas.patel@broadcom.com
References: <20220407192913.345411-1-sumit.saxena@broadcom.com>
 <20220407192913.345411-2-sumit.saxena@broadcom.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
In-Reply-To: <20220407192913.345411-2-sumit.saxena@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0005.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::18) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2559505-bd26-493c-e8d1-08da198fb380
X-MS-TrafficTypeDiagnostic: BL0PR10MB2818:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB2818F38DA49524938E1D6684E6E99@BL0PR10MB2818.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ag46L+/1jMQJ6yiuj1vcSe4wxiwhdBRmy1+GGhBepP4Mo7P6kw+mFrnomuZDMadW92YqysuRak4bTWHwU5mcZBMeBkRbTNc0vCjQN33faRF6z/bgcemhAp+97np4klwPN0qIbaUpwaPWfR7rgICwa15yNp3x6i33M7BuNXOA/R65qlXxG6sBvt/veAUmm3i2qVK68ddK09XKQUbK+DF77WqOl7/8Epv0u2+bvCd2ywCmF/+u9Yy3yueLxkkqbqyR/iSCnT/URIqj0YM/fRLxVZtwAUdvbHsCUAh2kJmS6e3n+roRb2/fc6xz2k/+8BEfWYGXQDf6ZcmiFwuy3jee5fhPtGtPS5XdpJ2L+FG75SWN2ZYPdgRFWRxwAdtbo8cjxsRu0byf2KP0kAQnbGjPsYc/LNrGVRlq+QfCbzigR1ix2bE6GATlEB/htGbYStQujpag5gOo/PxhRxYhUAnK81OfgzTSnuB78VqRt/vwDlcWQzR5b1nwBqeoyAHVia9YonDvVlwc0/XZThMb1cUFGxEYU7zXz3+QWmcU/6N0c5CG9lWbBj+fbiSnj8AiOfSwkhWegraiHARuqojG9WhiYxuTuBEye4y6bqvNTws3PrAZDhl8qlVrsorYdfEuYu2lMX4LvMYz+DkjBQRz/I5XLbT8Ki5FP0GR4+GPyOUeRI8bTuofQ/1uIJbvVTkYmJVPxI3CoI0z4FvmNcAPGnHxDEtczze65y4cqFwFZaOWPcGuSFc4bJvQeS4jz+zaZQYqMf2huTl5Jql1IV/RrMTRqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(186003)(508600001)(83380400001)(6666004)(8936002)(44832011)(31686004)(2616005)(6486002)(2906002)(36916002)(5660300002)(66556008)(38100700002)(4326008)(66946007)(8676002)(66476007)(316002)(6512007)(31696002)(53546011)(86362001)(6506007)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djVydFBRM3pKQ1lPeFBJVXNvYzVWbGJPajBLOEw2Q0dUcW5ZMlNnajBQSEph?=
 =?utf-8?B?VjNJbFFVaHVtb2hzeHdTL1BaSTdIZWVGYWhlYVQ0ZCtKaTNEdUZCd20zc0lV?=
 =?utf-8?B?c0xwMiszZkRQVlMrS2VrUFBnbzhXN0xsbXVpdHFrb0FQZlhHMFdtcmY0RVhi?=
 =?utf-8?B?bTRZWWhWVVdXeVdidjhkZlBreElSay8rOGJFZWhJSzhOdXRzMU5kM01YREhW?=
 =?utf-8?B?QklmeGJ2VEtGUW9VL2JTeWMvRyt5cXZnellKQUwyVGtaTEJZVGRmai8yclFl?=
 =?utf-8?B?bTk3am90MlRBM2dhTWNJSSttT3k0QmlzVllkOHpKazFvWURLOFNYR0Q5Mmhk?=
 =?utf-8?B?UWo4a0Ric0U2cTRDRkluRnNWT2dCWTVzNlZ1OTlrYlZaK3Q0UCtNMUpDekN3?=
 =?utf-8?B?VzZ4alIveVlMcTcyTTBJRUdQM25DS1ZaR1JxOGZDRWtuTmlhYTNpb3JHTHg0?=
 =?utf-8?B?bEs3aEtHL1hCcmFTVU5kRURwNFd0YTNMNXNTRk1NSGhReXEranVBVXNMcitm?=
 =?utf-8?B?bkR2ZHlhSVA1Q1VETnN3Mld1dFV3dFE5RWRGL2tiKzlsc0x3Mm9oaVc5OElq?=
 =?utf-8?B?WHA5YW90THlZMTl0Q084WjhpSGNnQzY2QmtiTE1nVUd3SzlwTVo1cklkTnpS?=
 =?utf-8?B?dExiQkY3TVEzYloxQVpGYzl2cy9Cbm9iOHVaMHBDTlZnNk1HUjRndlA1TExC?=
 =?utf-8?B?ZmZDU1pieHhqclpNVlNPaGlYaXptVXMyOHNGdXlJWDdGYzFEZWxGeElmRG9o?=
 =?utf-8?B?RUpKOVJxT1dDZ0phMzhDeFBhZHpBOTVBdnRRUWtwOXdnUHZKMzhVVU0wNFRH?=
 =?utf-8?B?OGpPRjlnRFkzUXdBeE5IOVdBK2dqZWpMb1BwSVNNcFl0NXE4T3pwcGZpeUg0?=
 =?utf-8?B?ZU1Wd2g1Unc5eWVTU1BqS0RUTU43Ulg3am9OWkNwdHB2Z3ByU0l5NWQwR0I3?=
 =?utf-8?B?eHI4VWFpM0F5bG9HYmlpUk4vRjFjQXlKcE1EVytUamF0UGdtbTNEMVd3RXpn?=
 =?utf-8?B?Q2RQdzlJdkZJcU5meEJVdzVRakVMYzVyQzZGdG1leE40SkJFUzdCcCtvUW1r?=
 =?utf-8?B?TS9FVzFuZ084RW44SkJDM2Fia0U4MDRxbGRuM3I1ak5MVFM1bUU1YmZ5TWtS?=
 =?utf-8?B?S3N2aksrSjdYREZqWTJYb2xEQWZ2d3lEV0tTaEJyVk81YnBiVzNpVitpckh1?=
 =?utf-8?B?MEh5WlV5MnpCTVFkNmpmMHM3S3g4QmR2VnJFNVFocmFRK2ppdjA1KzJYczhL?=
 =?utf-8?B?NTJ3dzlpM3I3QkNaNlNsLzBQSG1FQ21nUnBlK0dNV08yUTVmV2VQUVlJRUx5?=
 =?utf-8?B?QlViZGFZRUxFZTlxZEI0SWVwRXdCRExVeGJBYit1Z09EMXQrVXBuMzBZaVR5?=
 =?utf-8?B?cHRra3daaFVPQVE4a3RjVVVVSk1oRkJ3bDBkQ21ZQmJydkxpYnFlU29WeWdX?=
 =?utf-8?B?aVlBeFAwSnRSeElXYWJ2QTMwUTd5dElXR0dwSFU4VGFnNGV5NTN4Z2tJYVdX?=
 =?utf-8?B?cDhOVkRnNG5GQmEzak9JODFZOGQzZXBaTlNwUmlUbkd2V2dWZmNWOGVKaGVI?=
 =?utf-8?B?RFdEM2ZxZ3RYMVBJUWk5S25FSWNnVkN2bUwwUUoycXhEejk0NUx5cS9UcFNj?=
 =?utf-8?B?L1VKb1pTTGM2NTc5UmJ4VWdON1Vhc3ZWRWFsdzB4cnk4K3ZVZ3lxNXAvZGow?=
 =?utf-8?B?eTZQOTVsa3dlYjcwQ2xMaXJoZmdQUERpak1GZjRzbTVKTExEK282T3Z3ZHpi?=
 =?utf-8?B?eXU4YVA0TWFrajZ6L2NiM2tJc1dQL3FYVXc1N0QzcUYrc1RPWFZkQ0ZsTmdX?=
 =?utf-8?B?MEtkemJQQ241dVgxU1VnUWFXSktRZ1JwMUhrMFZJMkZLQjE3RVlyRVd4MlIv?=
 =?utf-8?B?WjZveEhULzhnT3oraWtmLzhGYVVSL0t6OW5wZUlYNDZkaFl6Z2M1ZWozcW1C?=
 =?utf-8?B?MWN5REo0RDZ6UG95VkJleXNGdUlydG5BaHNSSnBOQUREaHRWUzR0VXJVOWJl?=
 =?utf-8?B?M1ZkMFU4TkY4K0tpSk5DNUF1K0lpMjJlY2d6bW9iSWNGS3FuYStjREhOOE1D?=
 =?utf-8?B?elRYaWRVd2ZVOEljNXE1VS9TUVdKNC9KWGZPYXJuMHZnbFhia0xueEprcTVy?=
 =?utf-8?B?YnMrNmJGbGxZK3pUekhucHdFd2ViS1l6bHlQNHVNMWZNWWdYbTdYZkhtOG90?=
 =?utf-8?B?Z3k5WmJReDZZL1FEQmtLV0FFclZoZXBnaHdza21TaEQ1QWdTekJRN1VTSjlO?=
 =?utf-8?B?RTlMSFA4alRqRzFvWkFSMnJGUjY3dFZEdStWVGVISFdsRms5bWptRjdVem14?=
 =?utf-8?B?YnFZU1YvWTRudy9pR1g0RHJ3c3ZiV2ZLNmFmalkzSjlreE80aXk4Q0RiaERj?=
 =?utf-8?Q?cLLcpBIyuNhSmubzIenRmpojB+43OXNopPuDv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2559505-bd26-493c-e8d1-08da198fb380
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 18:43:41.2371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kr7pdecvQpeiXChTN87B+RTfXl2MQv5ST0D41XlGHh3eiyXIsu9pL0DC9sYnL8xYR2Y6PnevlT6gPhhTLIjKN7JhUcgetpj5PqOSjXkctEc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2818
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-08_07:2022-04-08,2022-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204080093
X-Proofpoint-ORIG-GUID: w1HmpP5Rn-MFVZ0UaMcwjyjmNfdN8DR7
X-Proofpoint-GUID: w1HmpP5Rn-MFVZ0UaMcwjyjmNfdN8DR7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 4/7/22 12:29, Sumit Saxena wrote:
> Create BSG device per controller for controller management purpose.
> BSG Device nodes will be named as /dev/bsg/mpi3mrctl0, /dev/bsg/mpi3mrctl1...
> 
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>   drivers/scsi/mpi3mr/Kconfig      |   1 +
>   drivers/scsi/mpi3mr/Makefile     |   1 +
>   drivers/scsi/mpi3mr/mpi3mr.h     |  20 ++++++
>   drivers/scsi/mpi3mr/mpi3mr_app.c | 105 +++++++++++++++++++++++++++++++
>   drivers/scsi/mpi3mr/mpi3mr_os.c  |   2 +
>   5 files changed, 129 insertions(+)
>   create mode 100644 drivers/scsi/mpi3mr/mpi3mr_app.c
> 
> diff --git a/drivers/scsi/mpi3mr/Kconfig b/drivers/scsi/mpi3mr/Kconfig
> index f7882375e74f..8997531940c2 100644
> --- a/drivers/scsi/mpi3mr/Kconfig
> +++ b/drivers/scsi/mpi3mr/Kconfig
> @@ -3,5 +3,6 @@
>   config SCSI_MPI3MR
>   	tristate "Broadcom MPI3 Storage Controller Device Driver"
>   	depends on PCI && SCSI
> +	select BLK_DEV_BSGLIB
>   	help
>   	MPI3 based Storage & RAID Controllers Driver.
> diff --git a/drivers/scsi/mpi3mr/Makefile b/drivers/scsi/mpi3mr/Makefile
> index 7c2063e04c81..f5cdbe48c150 100644
> --- a/drivers/scsi/mpi3mr/Makefile
> +++ b/drivers/scsi/mpi3mr/Makefile
> @@ -2,3 +2,4 @@
>   obj-m += mpi3mr.o
>   mpi3mr-y +=  mpi3mr_os.o     \
>   		mpi3mr_fw.o \
> +		mpi3mr_app.o \
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 6672d907d75d..f0515f929110 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -148,6 +148,7 @@ extern int prot_mask;
>   
>   #define MPI3MR_DEFAULT_MDTS	(128 * 1024)
>   #define MPI3MR_DEFAULT_PGSZEXP         (12)
> +
>   /* Command retry count definitions */
>   #define MPI3MR_DEV_RMHS_RETRY_COUNT 3
>   
> @@ -175,6 +176,18 @@ extern int prot_mask;
>   /* MSI Index from Reply Queue Index */
>   #define REPLY_QUEUE_IDX_TO_MSIX_IDX(qidx, offset)	(qidx + offset)
>   
> +/*
> + * Maximum data transfer size definitions for management
> + * application commands
> + */
> +#define MPI3MR_MAX_APP_XFER_SIZE	(1 * 1024 * 1024)
> +#define MPI3MR_MAX_APP_XFER_SEGMENTS	512
> +/*
> + * 2048 sectors are for data buffers and additional 512 sectors for
> + * other buffers
> + */
> +#define MPI3MR_MAX_APP_XFER_SECTORS	(2048 + 512)
> +
>   /* IOC State definitions */
>   enum mpi3mr_iocstate {
>   	MRIOC_STATE_READY = 1,
> @@ -714,6 +727,8 @@ struct scmd_priv {
>    * @default_qcount: Total Default queues
>    * @active_poll_qcount: Currently active poll queue count
>    * @requested_poll_qcount: User requested poll queue count
> + * @bsg_dev: BSG device structure
> + * @bsg_queue: Request queue for BSG device
>    */
>   struct mpi3mr_ioc {
>   	struct list_head list;
> @@ -854,6 +869,9 @@ struct mpi3mr_ioc {
>   	u16 default_qcount;
>   	u16 active_poll_qcount;
>   	u16 requested_poll_qcount;
> +
> +	struct device *bsg_dev;
> +	struct request_queue *bsg_queue;
>   };
>   
>   /**
> @@ -962,5 +980,7 @@ void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code);
>   int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
>   	struct op_reply_qinfo *op_reply_q);
>   int mpi3mr_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num);
> +void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc);
> +void mpi3mr_bsg_exit(struct mpi3mr_ioc *mrioc);
>   
>   #endif /*MPI3MR_H_INCLUDED*/
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
> new file mode 100644
> index 000000000000..9b6698525990
> --- /dev/null
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -0,0 +1,105 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Driver for Broadcom MPI3 Storage Controllers
> + *
> + * Copyright (C) 2017-2022 Broadcom Inc.
> + *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
> + *
> + */
> +
> +#include "mpi3mr.h"
> +#include <linux/bsg-lib.h>
> +
> +/**
> + * mpi3mr_bsg_request - bsg request entry point
> + * @job: BSG job reference
> + *
> + * This is driver's entry point for bsg requests
> + *
> + * Return: 0 on success and proper error codes on failure
> + */
> +int mpi3mr_bsg_request(struct bsg_job *job)
> +{
> +	return 0;
> +}
> +
> +/**
> + * mpi3mr_bsg_exit - de-registration from bsg layer
> + *
> + * This will be called during driver unload and all
> + * bsg resources allocated during load will be freed.
> + *
> + * Return:Nothing
> + */
> +void mpi3mr_bsg_exit(struct mpi3mr_ioc *mrioc)
> +{
> +	if (!mrioc->bsg_queue)
> +		return;
> +
> +	bsg_remove_queue(mrioc->bsg_queue);
> +	mrioc->bsg_queue = NULL;
> +
> +	device_del(mrioc->bsg_dev);
> +	put_device(mrioc->bsg_dev);
> +	kfree(mrioc->bsg_dev);
> +}
> +
> +/**
> + * mpi3mr_bsg_node_release -release bsg device node
> + * @dev: bsg device node
> + *
> + * decrements bsg dev reference count
> + *
> + * Return:Nothing
> + */
> +void mpi3mr_bsg_node_release(struct device *dev)
> +{
> +	put_device(dev);
> +}
> +
> +/**
> + * mpi3mr_bsg_init -  registration with bsg layer
> + *
> + * This will be called during driver load and it will
> + * register driver with bsg layer
> + *
> + * Return:Nothing
> + */
> +void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
> +{
> +	mrioc->bsg_dev = kzalloc(sizeof(struct device), GFP_KERNEL);
> +	if (!mrioc->bsg_dev) {
> +		ioc_err(mrioc, "bsg device mem allocation failed\n");
> +		return;
> +	}
> +
> +	device_initialize(mrioc->bsg_dev);
> +	dev_set_name(mrioc->bsg_dev, "mpi3mrctl%u", mrioc->id);
> +
> +	if (device_add(mrioc->bsg_dev)) {
> +		ioc_err(mrioc, "%s: bsg device add failed\n",
> +		    dev_name(mrioc->bsg_dev));
> +		goto err_device_add;
> +	}
> +
> +	mrioc->bsg_dev->release = mpi3mr_bsg_node_release;
> +
> +	mrioc->bsg_queue = bsg_setup_queue(mrioc->bsg_dev, dev_name(mrioc->bsg_dev),
> +			mpi3mr_bsg_request, NULL, 0);
> +	if (!mrioc->bsg_queue) {
> +		ioc_err(mrioc, "%s: bsg registration failed\n",
> +		    dev_name(mrioc->bsg_dev));
> +		goto err_setup_queue;
> +	}
> +
> +	blk_queue_max_segments(mrioc->bsg_queue, MPI3MR_MAX_APP_XFER_SEGMENTS);
> +	blk_queue_max_hw_sectors(mrioc->bsg_queue, MPI3MR_MAX_APP_XFER_SECTORS);
> +
> +	return;
> +
> +err_setup_queue:
> +	device_del(mrioc->bsg_dev);
> +	put_device(mrioc->bsg_dev);
> +err_device_add:
> +	kfree(mrioc->bsg_dev);
> +}
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index f7cd70a15ea6..faf14a5f9123 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -4345,6 +4345,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	}
>   
>   	scsi_scan_host(shost);
> +	mpi3mr_bsg_init(mrioc);
>   	return retval;
>   
>   addhost_failed:
> @@ -4389,6 +4390,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
>   	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
>   		ssleep(1);
>   
> +	mpi3mr_bsg_exit(mrioc);
>   	mrioc->stop_drv_processing = 1;
>   	mpi3mr_cleanup_fwevt_list(mrioc);
>   	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
