Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2552EC001DF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 10:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbjGYKAE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 06:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbjGYJ75 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 05:59:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D360C1BD7
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 02:59:55 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36P7odJe026951;
        Tue, 25 Jul 2023 09:59:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=LpfN/17wZu7OxMLJL9TELial/NLAUgdru0n4bxYTJ9g=;
 b=XgYn56jzR5uK09Hfx16Ui+PV3FaguxwZ1uFo8J7H8ppzM3+qYwDqjru0FDPj/mPXOK1u
 VE82ioYwf9XgWJHJIElY3BngZ8ngP7SDlkAQWRFBG53KUXIFTlsouoyLF8GRZVk+ZeH9
 mxQFo1Bq74kBSufSPh7p1AJCNjWDCvt0dOluaJN9bamW52CNvbHgwJzmw3A5yIdWxL/h
 6KndugkWYaoswOswXEPlIJ4L8es5J2/Nx4JTqTxz9WzrUPaIdYuRIwJqAW7evT35bwTT
 XVrwdsfRxCX0bTz9XyZDf/2JnOhS91YR4l/Q/XGcz1SACCiTqcG3nofqheDDq5ILtxrk 9w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s070avpgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 09:59:47 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36P8QjiP003802;
        Tue, 25 Jul 2023 09:59:47 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j4hf4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 09:59:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+AoUbykqvSvmu0duMu/J9TcoegGYDUg+0rnGJJP5OmvbCk725TgUXA2wfZd7X8jq0rk6cThezrIXdxLZJfzR+NZRze81nc2qqwGDjnO4ByJw4kAmcwb6aE/YQ98qMQA6equzviidxfeORC516vbVPo4rPhumfvjuVJ5O5nEaO6jsU+KJg5IPvGGD9/JmlHEnNR/1UjTHw+cFQWudqwR4hs61oIqYkyORf0qLpd17Y3LMt5k4KJ2LA5SYwIOog8LRjsK+5wOETt/6+wu5c8hTYwxPpLEticjTSxRO2ecG/him7YA8fjmcBuSaKZTo5M+nBXycA+XDuH0C212yYFXvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LpfN/17wZu7OxMLJL9TELial/NLAUgdru0n4bxYTJ9g=;
 b=GdfMUKdbjaSVn4lanWsSXvo/8C1Q20NcD1T0+sYDI6mOn11xfileC5WxnL225YxJsz00w7y/qCVKXGD+P04SlhTiVD3oRidG6hZFNZXq3Tvh/RA6fA5vOD5KwNUWMAdGRZCQBXc5H5Z+/I/EOMBwhxc/tEw3BmYL5aDfKypgHUf6+Hu+LHgJbQib0eedkF2wUPrF0yKQLagLy/gfO9hVc0CSIU0KOxEQWakzsN6gZMDfu7I1OFxcvESyYrKgQ/20W4rbW/ePBSMnKBFG9AvD1gHlc1fkXUIx4+7C5kfplUHMk+tXylHLmai2BVSUNN62kpvLeaz3cflZ8SKIdYqrsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpfN/17wZu7OxMLJL9TELial/NLAUgdru0n4bxYTJ9g=;
 b=Ggx6WOyCKa+HtdMYrzp+Rxwg7Ryxmk9iCqYMyzbgjS/S0tYHVnmtf0kJmBHmQl3OQx2jShiGVJlqTW3KbVLO18E7Xs9V3VgJ+/dJE95N1ieJ/DPnv85q8+8YZ5JjGWhNzRgOs6zQxumTj4idfYhyJAfPtn222Q+3lmdgHwwxqBQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB7347.namprd10.prod.outlook.com (2603:10b6:8:eb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 09:59:45 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Tue, 25 Jul 2023
 09:59:45 +0000
Message-ID: <98183a63-81e0-7d8b-59f5-31b6bacc6554@oracle.com>
Date:   Tue, 25 Jul 2023 10:59:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 17/33] scsi: sd: Fix sshdr use in sd_suspend_common
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-18-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-18-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0133.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: de494c96-001d-441d-8a29-08db8cf5df81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o0lXRE+2IhihuLAskdoc0cql/EynrcK5cMH0n790Lo7uilz2Wvmhcl6/jF1yo1anpisteeJrvhPXPv4gwf6GRTqqAuwm5WhUTFk8la5kyObdIEfPvjSgKsJgVU1DiS6wnUs2v9FiqF+auO7xWgjJQ6nD1uftsREW9YcIlkuL6SdzyCFN2ryA37/VQG7ZXOqTCCION9S84FKNX+OfnY/fQQK3ukhVznnkWfN2wsOVSNHEMdRFZfl9saNRhRGcc/EejYFryDdb/wKPAdX/SuKhxcdbYo08Y50xpbha1X1eB+GM6zDFRnjfc6VEG/CaIgox8zDxCAw20vlj0Dw2RFc+GTYSvRkKCK2si8oH5gQDroCIB9GClms1PvigbDSPqy06ImVeEGGzuJvIIafJXLtwjQ57PKonsQXCILtiB5IpnEJ4Iw59gVuZ1N1QVfWrEutzRcpGEJ7kcdbIscYSGRxI5OhX4p1ahEIxirhK6ikjVKmln4poYNl3pS4cAyOKoN86PA+cCJhnD0q6k7ncdwsxyRVjM3ktTCboGnZC0Jt2/V151UOVKGmJx6b1sNvVPVDNHxdVGYFsEVtRKCZ+23T8ZUcCDfFq2Q8QsV/5hPdNK1TWqgaz6ulmopaSzAdcdEugodSrN2I9JmaHbPHjJ4CRzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199021)(6486002)(36916002)(6512007)(478600001)(6666004)(186003)(2616005)(6506007)(26005)(2906002)(66946007)(66556008)(41300700001)(316002)(8676002)(5660300002)(8936002)(66476007)(38100700002)(31696002)(86362001)(83380400001)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1Y0Q2RtMEZlSlhiZnFnVUxLUVZGd3QrV002ZkwvYkVsdklSSWtJUFJvbUtp?=
 =?utf-8?B?ZXVUbHIwMEVMSjZvWkhOSDBtNkNDb01tK21Sd2c4bGlueU8zcVZZckJRdml5?=
 =?utf-8?B?dWVQRGFTN0ZxNVdnaWRnUkMxWmhta1h5U2VVdEVPUExia2o2ZDR0MlBzQmc3?=
 =?utf-8?B?UndseEYrRVFtcXlnNUk1ZW5zZFZ0Yk5sQWJKUW5hSHV0TUtHak50aFRaZHB5?=
 =?utf-8?B?T3o4NTlmcGF0anFRUEk4UDM2K1psaVVzdks1M2ZnbzNuTndrZnp1WFdCWmV2?=
 =?utf-8?B?QXlKem00WHNZb1h1amwrekYvZmNqVlBQc242TURKYVB2NHVZaWp3RFpocVk5?=
 =?utf-8?B?RERZTzFXNUY0dDNzRzNLWlVpb3FzM3U0SWxYZS9GQkxLcGJhdGFlc1hhUGs5?=
 =?utf-8?B?TFBEazkwa1ptbFBGMGIzZktEYVRUMG9KWDhNUkRMdFlPOWZucFN0V1FKamhR?=
 =?utf-8?B?UENySGI4SDZIVkxmaTZrQW9kZ0FUMzZ2ZUFseUZOYk5zdU0xUzBQWjVBWTNC?=
 =?utf-8?B?QzAzZ0JvcVd6ckFSYWliZHJFUWkyOElnMXRRTWxwaVJjVURGTlVwQ2psdUdP?=
 =?utf-8?B?NjJDMmRlZk5RT095UURVYTlHR1NQaUFBbUtjeEI2YW1oYzF2OTg0ZGJyVnZS?=
 =?utf-8?B?K3k5bmt1TmlsOHkzb2FYcUs0aitDekFpYXNhN1g3c2NzVlVxcTBXWFdUaWdY?=
 =?utf-8?B?dE82NXRMUG95UDZ6QlRNUW9DdDVPMlZHbUZrNHd5UXJMOTRyM3QzZnF0MDho?=
 =?utf-8?B?TStMNXFBQ1NkekltM3AyV2lnNkQ2ZlYvdFFwQktMMHhOY01qem5XL2lQWWly?=
 =?utf-8?B?ck5nUkdwSVg0VnhkRGV5dHlHMVVFYU50MkQ3M1FTLzZOWmJNWmdYTUVKRmRm?=
 =?utf-8?B?MEZEVy9LSldob2lBdFhVMldsMTZXRGpWMGczWTFvdWx0NGJ3WTYxR21EdVl6?=
 =?utf-8?B?RlM4WEEvTEwydFRaWFc0U2VIaFlMSzdwWWFMVkFuV1FLTllMY1RNZFQwTFlk?=
 =?utf-8?B?Z3JVdk9QelU2cEZYaGRlTGswdEp4Z3BwMTQ5djd2Y3dmSUgvTGRPU2dTamgv?=
 =?utf-8?B?S3JDdVBTdVRia0tPR2xSSERRUWtvMEdEQzNXWlRNVk5hZndiNStqMFVRS3BO?=
 =?utf-8?B?SldPYVY1bU5JT0E2dTUxZWtwWG5TZ1czYStlbVF5YVNaOThOSHZEY0J2ZDFw?=
 =?utf-8?B?b096QmJTclErd3pUWmR0OUV3bktmZWt4SnlOZWUwTFlvc3FiOGkvVkJWVnMw?=
 =?utf-8?B?cklwTjR0Z2FMUDBrTXo2STFHeW9QdmdOM09PSkpDOVp1SVRlUUZNaUgzWTdE?=
 =?utf-8?B?d1lsTDdObGZhK01mWHJYNk5mdmkrNUUweEtnTXBJa21NY1FYNmREMGEvWTJL?=
 =?utf-8?B?OVdCZloxOEhUUmVrc1B1WnprM2Vvb1M0L21XY0Z3SXRCZVdOS0gyMjRPN2xW?=
 =?utf-8?B?WnlxckJmV1BJaXJIdGIydUJ1TFoydnJPMGFldHpoZVZxNk93bjNRU1JuVkw4?=
 =?utf-8?B?dVA1TlVOR0R6RzRzRlNZOHRGaTlTMXlOZTM3QjdRdEtDUnNyNzBFQXhqdmR2?=
 =?utf-8?B?SU9NcGkraS9NZzNtK0RMb2NiRlNrNFI0d3Z1R3RadGtQUENCRmJFaDRNUzdo?=
 =?utf-8?B?TlRESm1tSGNZSERZQTZiZTBDS003VS8ramU3RlFJU29JRkxXV3lRY0htcUt2?=
 =?utf-8?B?Y0d4Y2ZyYXBnWFYxUmJoeFNuZ3ZkWnBKT3QyMVBFUTJ3UVNNaUNnZHpHUFM1?=
 =?utf-8?B?VVRZRXY3NmR6bWxIdzZoNllvek9VcjlLbTdTVkdEV0t3UlJBbldsY2Ric2ZE?=
 =?utf-8?B?b05MTnlWTzJISmprdnUvWU4vK3lTanBJY2laUjdpd0NtYWUrUmhBamNOMEpN?=
 =?utf-8?B?NjI5cHV6djhyK1BpVUJKeVlYZXJ5eTFNK3gzQVZsNlFNWmlNTzZrNE1kWHRa?=
 =?utf-8?B?L0tuRE5TeHo2ckdGTXd4dUFzVGkzN3QwOTBDTlR2ZGx3ZDZUZmpZbk8yZWor?=
 =?utf-8?B?VnRuWVBxbFVBT2pFN1M2cXRKY2hVWVFoZnZoVFRrTm5mQVd5NEtJMGFjaG5o?=
 =?utf-8?B?YWZ4K1Arbk9FRUJ4c3RkamZZMi94OVhhNWxzWUpXMWdNRG9LVS9wcEJsSkQy?=
 =?utf-8?B?dUVleVBFYzRnZ1dsdTludjNHb2dGa2ZESEppbXhYcWFMTmZvS3k3K01yR0RJ?=
 =?utf-8?B?Rnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: l/XG9HhhVuMMVJ2xQfxxCwLuLYGSVmswWj0CcB7Vru5cNlr7PPQNxhxcY0/bg8yBRLVAMFjrGy8EghZBgMt4S/TA3608YMXKADoAFNXPgvqTDFqJS2nFRxVuQdAYT69i7KmlR7aAhrPCCftwnuIepMhQiYd5OLPJq6swuxhSequghHDO8rgTLTkuFwFQN/FM6WAnlYgntAv8yfiygZ29Mt6PT7SxykIF4Zho41sHnoPMdD8lHweU8E9LQld8CcqFgqNRmLMqwMON5Wp7twgwgPR2dn3HbaPTpeTgGZmUis06BINtuvUSngJDreOjwN1klXj9o6KgZE3EX63Ed4xyY7DDY6l0G1edap/cyDPDNrNE4iz4Z5sBVRODgBzKYvJoPIwXWRehpEbgoDnp8u+ABqQiXDT9ENC9IvDBCTxx5eW1Q5Lfhcn5EDAOkTatnve3X+RgYQ/X0UfGr10f10FSHwhPVDY1jfwwsg9d8in8oy0Bg67kFgUhOOnuo5kLkKf+ZYagQbTTBsV96bUnse4ot3mFT7lNzsE75Tyu/FxnEcHUhjFQbVjdcw1ZWtZ0DA/yFzTbFM1baT2vXZfXJkdJnegFBYSHc1DcoAG7npTvkBrovYniJlet6JQYDiLLqALCgDiUTecphWumrPTFF+QahQ9Z3tG5fHcI5Jyt8AyGD/DDZMH50+bz9B+GUVl8VLpDZqvqAneoeFvmGrcrVeeHWAtAVUEpYzTM9WgNzJn63h7FjGeu9f7gAtFQ2+AKHcbhN9km/tZ5B7SS5ytMhLSOpN9wt9dN4Nq94NVeSPqqXSoUigxC0QibMGFYvMnCYhKp0ByWPf6ORkuu1NAGRfrAQGYYf+jqCXVPAY9yuQrOJfKQaKEy9XT2y5z5eWMbEx+C
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de494c96-001d-441d-8a29-08db8cf5df81
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 09:59:45.0249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ra+ejgP5BHyiko5zWHL4v31xn+kk4kzi5bWwbYQ/ODeXYLKFXY+cqEDM6VoxjJ2gpiZNM6WWCCKkwiioM2iLpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7347
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_05,2023-07-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307250086
X-Proofpoint-GUID: IoTg2BtVf_lDIuorYaqzHgRgZHuxvU5h
X-Proofpoint-ORIG-GUID: IoTg2BtVf_lDIuorYaqzHgRgZHuxvU5h
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> -
>   	for (retries = 3; retries > 0; --retries) {
>   		unsigned char cmd[16] = { 0 };
>   
> @@ -1645,15 +1642,19 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
>   			return res;
>   
>   		if (scsi_status_is_check_condition(res) &&
> -		    scsi_sense_valid(sshdr)) {
> -			sd_print_sense_hdr(sdkp, sshdr);
> +		    scsi_sense_valid(&sshdr)) {
> +			sd_print_sense_hdr(sdkp, &sshdr);
>   
>   			/* we need to evaluate the error return  */
> -			if (sshdr->asc == 0x3a ||	/* medium not present */
> -			    sshdr->asc == 0x20 ||	/* invalid command */
> -			    (sshdr->asc == 0x74 && sshdr->ascq == 0x71))	/* drive is password locked */
> +			if (sshdr.asc == 0x3a ||	/* medium not present */
> +			    sshdr.asc == 0x20 ||	/* invalid command */
> +			    (sshdr.asc == 0x74 && sshdr.ascq == 0x71))	/* drive is password locked */
>   				/* this is no error here */
>   				return 0;
> +
> +			/* This drive doesn't support sync. */
> +			if (sshdr.sense_key == ILLEGAL_REQUEST)
> +				return -EOPNOTSUPP;

Only sd_suspend_common() interprets this, right? And in that case, it 
treats as if no error, so could you just return 0 here (and drop the 
-EOPNOTSUPP check in sd_suspend_common())?

Thanks,
John

>   		}
>   
>   		switch (host_byte(res)) {
> @@ -3848,7 +3849,7 @@ static void sd_shutdown(struct device *dev)
>   
>   	if (sdkp->WCE && sdkp->media_present) {
>   		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
> -		sd_sync_cache(sdkp, NULL);
> +		sd_sync_cache(sdkp);
>   	}
>   
>   	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
> @@ -3860,7 +3861,6 @@ static void sd_shutdown(struct device *dev)
>   static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
>   {
>   	struct scsi_disk *sdkp = dev_get_drvdata(dev);
> -	struct scsi_sense_hdr sshdr;
>   	int ret = 0;
>   
>   	if (!sdkp)	/* E.g.: runtime suspend following sd_remove() */
> @@ -3869,21 +3869,18 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
>   	if (sdkp->WCE && sdkp->media_present) {
>   		if (!sdkp->device->silence_suspend)
>   			sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
> -		ret = sd_sync_cache(sdkp, &sshdr);
> +		ret = sd_sync_cache(sdkp);
>   
>   		if (ret) {
>   			/* ignore OFFLINE device */
>   			if (ret == -ENODEV)
>   				return 0;
>   
> -			if (!scsi_sense_valid(&sshdr) ||
> -			    sshdr.sense_key != ILLEGAL_REQUEST)
> +			if (ret != -EOPNOTSUPP)
>   				return ret;
> -
>   			/*
> -			 * sshdr.sense_key == ILLEGAL_REQUEST means this drive
> -			 * doesn't support sync. There's not much to do and
> -			 * suspend shouldn't fail.
> +			 * The drive doesn't support sync. There's not much to
> +			 * do and suspend shouldn't fail.
>   			 */
>   			ret = 0;
>   		}

