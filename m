Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8879CC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 16:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiKOQyS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 11:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbiKOQyR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 11:54:17 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCCA6165;
        Tue, 15 Nov 2022 08:54:16 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AFFRijj005432;
        Tue, 15 Nov 2022 16:54:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=qR69+zb55Ija3IRKRWuwazo92ySd4a4nWEBwleUggkQ=;
 b=ldx0NT4J0dz14ZlnfVfIZpEF6EzMdvHivig5xBwd3uL5ZRKqg+A7n+vyUleEP6coY5Sy
 znkK2wTXQwdzBYWHJYE4RMut6bWH5zWjmslg52u5mj4xiV0rIIvGbTosDawlASvcIjHR
 6viuHBdrt4XzRF0i3HRFXuk6lfmmCzOKbPtyDJR1Az5xnwcj9YhZYBClLbs+9uxgcOvO
 WGLK+hFZqMvcVO0CtBZri4L2g07TDUF3SfE+3WAo4zviGhY3cNu0JlBqIIWPEm2rAU7S
 rknJbPhTNB6G02SQywmm+wu15aBawtqZWbADtuy9hQ0NwWsJOzTyQHMDMcMexcuZBP9Z 5Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kv3htt3xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 16:54:07 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AFFuZj8010281;
        Tue, 15 Nov 2022 16:54:06 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1xcaudv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 16:54:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7kEODNv0cj3tSCHFujk1N2MO3naVH+VYuLAfr4TZmIsJFxBGBmE1r3cOKWLpVWc4eUho1Fes1r7b3MEa4Qxr+IBLXeOKCmloqpbkcl/BHG1tfUMsyziYKbj9gExLmISykiyocHlos8pjfSx+HjHsBdzvFvIAyWDPh4jellN4+kR/kXOvYEKDg97tU0V/ZV21dJakQ1ikwp26DMVTIdLQuPZXMR+uOhmsXSZjwvG7ViF/pquyGnBsSU02IhnK7jmxn/L0MgEjZ0NPnSJDSxoVsSrCWSgXb/Fxy2M8JiUuSG2IYaZg/xLFI4w5eoaS80Yt6u0Jg5xIOr/PJsVzcyoLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qR69+zb55Ija3IRKRWuwazo92ySd4a4nWEBwleUggkQ=;
 b=aHKvxo0njrClYc28ZAoTDaml0yKBJorigoDnuxbt9wz+ImLI7hx3RgrsrelYApWj0o8Y1TAQVn1YxcQnj7Y0nT1NYTp8x10YVOKgB7eq0GCVBnbxgeq4L8K6QlW1egY/LEWloJuchvifajahtY2FDtAtBB52sLrywtoNRkpIcF19ZVOrVuBt85WL34ClIoKWij7tPh4XUCPuUYXnBvTFoweTSR7gPvUPE65xrbe6wiyyDIDX+LS6Dmy4aIeMJzpC/M8BoEbUZCAXtSc/9dfEfQcO92DAliYCf2f92N5UZnWyuACttzGi0PkA2h9crNn3+7lZApXpi1NtUAAfY17m9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qR69+zb55Ija3IRKRWuwazo92ySd4a4nWEBwleUggkQ=;
 b=QcMDXs8HL60AZkrgNsRVG8lgHf4W4j7c+TNGlPaKF5nFiLs4MEptqFN+FZiaha2p1vptbi7i7hJry5ZSCSTPYXyC9y5L/qoSjGRUFDZTdRz6rRtGKJLb7bO2c6osYx8oTSxyK62jlQyVf6XDaC1OyhuKLmKecNNQDjCS+Eeuc5w=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB5138.namprd10.prod.outlook.com (2603:10b6:208:322::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.17; Tue, 15 Nov 2022 16:54:04 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 16:54:04 +0000
Message-ID: <977c2c20-af32-2f40-0e5b-90506817e821@oracle.com>
Date:   Tue, 15 Nov 2022 10:54:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2] scsi: target: tcm_loop: fix possible name leak in
 tcm_loop_setup_hba_bus()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, hch@lst.de
References: <20221115015042.3652261-1-yangyingliang@huawei.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221115015042.3652261-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0053.namprd04.prod.outlook.com
 (2603:10b6:610:77::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BLAPR10MB5138:EE_
X-MS-Office365-Filtering-Correlation-Id: 970429f5-cb53-4e9f-a404-08dac72a0105
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MjvSqoC7sx9lcYnuwqN1KqZ/966vH6Tza5divBJjH5IfWGAbA1EGeC5QouTb3iJfhmP+VhEyNVbTRfSs64Fa+KD0F2iUd+3tRDB0NAWclP+0ET+rhLizHu7aYYykE/t2EtpbGEAQzH+W5UycU+eIFsypWvtx3O79d21LBYdLcHONiY9e9Ew4cFDAQtDVGehLc2zsxfCv9VlRIqftNzhq8+UKZ2udVenB7LDpY4SjETP8sz5P6se777WHieoalg34C3mjd9CFPCgUfhiATrLvnl3qHn5Zp+B4Uh/L1eUORFu0LRC5bz3zQiaQ6h5v+1XZYMfrwrbBLNs28rGjTw10euILgYpUbinTAcaKwscL37UZhTvFIGv+ml4t1w6pG7W8/eNSpWTJBOFUkUECtOqlfk1mwFBH1FbO+MkVYgE4DO7y6GgZRpLTftRW7UYl7NFtoTig4s4/YKlZUp74gMFeO6+a6u2OHen2CoLlr3GMw9wti+CanNL4Dfcalfy4g1DA4dFPsSbL+iI3TmaR2rLgnWABgOHi0ec2YFzyg5slsRYHG9QKyAnvotcvfcrXqVoybeVpyAxyq8fPwc9srHGasSHPf3LQcjEKcrs5meNTBWQVKt5dcWXbLOvE/EkE+UYdCGP4F+98WGmllynGhemWHHwk/CbugLpjc3o0+kXz/Rqeu83HgGIFMR65ZZAn/qjQoxsQUtTnYKL1Ib0P4IUlmYSIz8Q0V69AmnMOihKu02dzJ/VUjOebIS9BnOciUJChCr5yxQpkneDW5PNSKv6FIpwBifwlnkwbhkmilyNCvBU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(376002)(39860400002)(346002)(451199015)(6512007)(316002)(66476007)(66946007)(8676002)(26005)(66556008)(38100700002)(53546011)(4326008)(86362001)(6506007)(31696002)(4744005)(5660300002)(186003)(2906002)(36756003)(2616005)(8936002)(41300700001)(31686004)(478600001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mk1GdUhOVitYTDNwYzVxOHJ5cEdkdmhyWEhpOFROTWs1OXBlL2pnb0ZlWk5v?=
 =?utf-8?B?Y2JTcDdqcml1YXdCbytpczE3WnUyTXNnZ0N6TWNvUlVjbkNOLzBNU1NTOFZY?=
 =?utf-8?B?d215ZU9sN3pXWEtNQnlhZFhMRVlHY1FtVFA1bU9sc3R5c0h4ZVhSdzlPa3ZE?=
 =?utf-8?B?Uk5EbVNqbjY3MEt2OEZmSEJ1ZWUzWlFkK1ZJdFM0Q3h3cGt3ZEpuNU1IU0NS?=
 =?utf-8?B?cnlvbHRnejkvMjl2dW5adUxRMko5WWkyNEg1b3JjTE5jSzRKS1V0L25uV3F0?=
 =?utf-8?B?dDJ0MmxZMU9LZmpHY0RCWFVYZ2FTVVVoQUdTNWhRQ1RMRGFMaHVCTSt0Q3Fl?=
 =?utf-8?B?Mm9pb01yRmN6NDJqaE4wd2p3MGdiNkZIRUxMSHlpOEI1RnU3TStpNzhIYXp2?=
 =?utf-8?B?bGNBTXp4RFFFVWU0WXpNR3lOdGFyazFxUVZWTDBxclVHNXdvRVJNa2wvRU1p?=
 =?utf-8?B?UldTb1ZDZThBbmVTUk5LN3hvOXI0QldGa2o5ZENjeVVybndNQUJmRUlBbDRF?=
 =?utf-8?B?U3I0dW5ZbWpqRkRTYjN0TktMa2hLQ0MzVDM4ZXBPT2c4bUgrWXJ4QStSU2po?=
 =?utf-8?B?ZmR6eUpjdWFld082Y0xDWWJFenB2K3JKNFhrUlhWTW11ZCs1MHppL0ZaM1Ny?=
 =?utf-8?B?bExhMFNLUG0rem1CVlZMbXVlWnFxbkhrM05wa2h3eHlYYWpWY1hRWnB4WXVN?=
 =?utf-8?B?TjZtakJ5MFRFL1V5YVB3UFhkT0pISGJmTU5ra3kvSFY0RFVoSVpRSjFZcmN2?=
 =?utf-8?B?UmV4YWJpUDBJMER4QkFLWWJxSy8wUTU4cmpyMGpON1MrYnFzc2NCY0FkQ2FK?=
 =?utf-8?B?dkNGb2dJdHdjdEFaSHgrY3ZiZlQyR0MvMUNxZ3FVRm1GL2lTWnFDWHovUVJp?=
 =?utf-8?B?Ly96b2lNTWkwcENKSlovOGNXME5sTW54eVZsNkFvOFpFOGNFUVVabDFxdnc1?=
 =?utf-8?B?d3RCK1N3WU1BaU4zRWtwY0Zxb2pkSWNpNmVXQlUrdEIwUExjL1hXa0o1Y1hy?=
 =?utf-8?B?NWdNdWZHU3BGcC9qby8wVWVGVi9mK3JQVVFHcFk2VWwxU04rWXBQTWxtV2Vx?=
 =?utf-8?B?a3ZtbC8wSkdYMEJUeDBHaTQycGU2ZDh6djRzTFZrMXBNMStGMjhYNGhJc1hq?=
 =?utf-8?B?dzZNazNOL3Fac3JYUEdPL1lGcFZsTVo2QVdTTVpzQ2JWZk5WdEFuS0ZkUkNJ?=
 =?utf-8?B?SENWeDdIWXkwaUNtYkdxMmxyNFkrYys4TDRGVlhuTkdIVTZnTGoxVWFuTVU5?=
 =?utf-8?B?QTFEU0FoWmQxdUEzNzROdTBpNHVqZEozZHNjNkNtb1lwcXZBRFhVeXVPRERv?=
 =?utf-8?B?TSt6K09LYzlSTmNOMGYydldFYlc1eVI5Y3FISC94UEhRb0NNb1lVdm91UUN0?=
 =?utf-8?B?ZnBqWitKUFpUUGJMME9GdGlsT2JCeC9SUEtmWE5UMXhsYW0xdmYxTGlLWklv?=
 =?utf-8?B?Ty9ZVjJlZ2VTZGYxNGZoMXh6ZEtTc0JiaWoxTER4VEZQekhBQ2VKK0YxWFBF?=
 =?utf-8?B?UFpzODBEM2Y4RzdCckZxWGc3NU9Fd3VXbXNZUE5HNHE3QVIvZllmLzlzeEd6?=
 =?utf-8?B?dW5WcWgyUmJFajlCOTB6UTE5b2JDcjN1NkJXdmcwSWcybkI0dGdVaHBiN2NT?=
 =?utf-8?B?b1FKNnZPUEJMZm8ycThBL0VLcVEraEEwdUxJcHhHWUo0OW1QVXBxS1RxOTc5?=
 =?utf-8?B?Sm9ESDFuakt0aTlUekZqalA0amlrdTFNTlAxZGswRk5Od3dzN1dFaDM2ejQz?=
 =?utf-8?B?VEd3VURHZVBPZDc4YTR0RUVoVXFRYjhwQit4bGEvK2FNaUpLYlIxeGxubkh1?=
 =?utf-8?B?QkxucXhSN3k4RU5QaG1XUW9DS3AxTy9aRmNDalNqS3AzNGthNzFJMmhLMjhL?=
 =?utf-8?B?UEgzTEovL3pvVVVMYXRjTXVJeXcxSThwZUVRMGlnNjZoS3RXZ1p2R3oyVnFD?=
 =?utf-8?B?RTNoeWI4UTdqRGltOGw0blJ1bUk5NHJLSkZDcGZRS0NjUEJGdEhpZ2ttb2pK?=
 =?utf-8?B?NHQvYzk3T2RLcFdzRDRSSy9Cc2ZjY1luZHQ3OXRwMUFnODVhWWE0dlV4ckMz?=
 =?utf-8?B?c3FHR05jT3NwOVJ0N1BMalQ4bFhORW5USVpMU1FRa2VjamFUSEVNWE5vWHo2?=
 =?utf-8?B?QUk0UFE1NTdGWWtsSk5PT0lpWWNNUm5nL2N2b3llaFY5UlM2VTd0UGNUNndn?=
 =?utf-8?B?a3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NCFDxOFU/WiHJofclAUxMqh4ajfBQ8jc26bvPYNvMyTcRyNnEehFiYLKwdLyZaxuu3CsGUYMeuBbKf8ud2ve07QTMBVv2aEUZH492X6yusw6ijGVEsI8vA2xxBKZd3Hs4pSqxhWbj3D2iRVZAVuTeYihVXLPfc0zhodyULvhR8SL35tvRNnjMzIA+i8C4Zp7cpc7cWyoT2tnf7SnKjRTJ+5i1HJLiVZH5UClIN9jj9X2D7M1imj5VFNH5O+EQ4gMv2HnXhu+Slt0PmoufHF0PyoiJ+qgNrYwuilGIgcE7+EqP9vXmnjpD7AZ5IXngHs0uMDj6IJASQMO0nxzEO5K8tFo7j18J+RX21klCLhTlZKj+H0kHRrxnLmUcMrqRndr4wtkSjQR+wlMY1TxQqCOkghr9wrTMcKApTN111KZd7p6Lkb7jOfT9MY2NjdQgsaAaZ6rRwjzAUErey74EmjB8g1yPU1hHHiJujaS2MJBouWLCgzxGThGQmA72QwoZW5YPLOEw5d1EjzEr6AepevC/rhoRI0BsqxRDHYvAUn9kTH29/86cAN5cF2svtahnYDPx0nYgIXeql+i1oGyO8odnZp2saC1DsMW5JHYdXsN+bJ8u3XEQ7+WXEDS71z7nLysl/o4Wf9l+r+5saE54XKuJM6XwsmGomWNf4EO5OT8blLOpgaJf4bff0GjIaeeNIzdkWaeKKYkcW6c4RPlgMJ1vYXtdeCRHqmmzObOqQ8GGkQM1E2vybbULS0TO3UcRXY2q9pDhoQe+8jg/gCvJhJr70z8LtAMBV7EVh/Kt7lzPHD0coeaqyPK75fGB9AfGaUpbnZ/GpToTSXH7MpxaEmUhJyKG/ckhrOKy4RHbr0weIM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 970429f5-cb53-4e9f-a404-08dac72a0105
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 16:54:04.7297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nHdmmriP3cer81nDCTKJpyeWeAgYVl8jkrZLUneQA9THpYP6z81ty96MLXdIq33ViH0qazEJQAfHq6noS+mS58mGmwQdkk3IpGlm8mPz2LA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_08,2022-11-15_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211150114
X-Proofpoint-GUID: 5ysh9XVBs-nldgTSi1IZzfoz-l5r3BuS
X-Proofpoint-ORIG-GUID: 5ysh9XVBs-nldgTSi1IZzfoz-l5r3BuS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/14/22 7:50 PM, Yang Yingliang wrote:
> If device_register() fails in tcm_loop_setup_hba_bus(), the name allocated
> by dev_set_name() need be freed. As comment of device_register() says, it
> should use put_device() to give up the reference in the error path. So fix
> this by calling put_device(), then the name can be freed in kobject_cleanup().
> The 'tl_hba' will be freed in tcm_loop_release_adapter(), so it don't need
> goto error label in this case.
> 
> Fixes: 3703b2c5d041 ("[SCSI] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric module")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v1 -> v2:
>   Move put_device() in tcm_loop_setup_hba_bus().
> ---

Reviewed-by: Mike Christie <michael.chritie@oracle.com>

