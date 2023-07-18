Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A457EB64DA
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Jul 2023 15:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbjGRPcQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Jul 2023 11:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbjGRPcM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jul 2023 11:32:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3330F1984
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2023 08:32:05 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36ID7jtE010277;
        Tue, 18 Jul 2023 15:31:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=E+vKvu3zc+DgVnr5D3B1gd6PuPYogA5LSOnv+9JqqNY=;
 b=kzmZXGoNwZkuD6qazmiLzF0bKGWJBwsZWN3RcMrCDWopoZVDYHMEsquPvDLVdTl4hZAC
 uf/iw2IfK+FoFA3TA5AMs2dOfIRL6+pe924JVdf4wipzVcqCXauhNtROCrOQ857ypW/l
 /xkZYU0GdBRiWvgYATXNulH743xOLGpVe4z9SvHtFtOqZpKeiynZ3faqxYAZVECnRyfy
 AkVV/lM1pzrRLp8lK4Lf3JeUvUqW/Sd33gb636ZCcwio8Y/Aaxe+wTJrYouJC3us6db0
 CGuyN+pKhhsH9g7nZKkY5xQXxFVAktMOL8T+nrLP3J0erQ9wM3+0yhfZdfU8VnH8QNbc uQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run77wd0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 15:31:57 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36IFUE47000815;
        Tue, 18 Jul 2023 15:31:56 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw5989u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 15:31:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jf9qYFKINCPihBa5NtS6yDJ4I+VTcUBm6Jt8SYiRbGTTQsBwBn4R/NMVxhhDGXdCcZnG51iSNl/UdStRuXGgSzL89yrzRrmPpHf7D9nNtSP/fxfpB8VEItA+NmdsrHf+Zc2pbWuDSgZdpsVaSHMLu+i5nxnR/mC37IdRd4J79dR1AI0K71OLVRzYTcKZSE2HRCb5BBC9QZKfR9rzLgOMYJWJnviH+bDlgD+O94N8aAV95dGT1CguEdF9BEDms0ILr9ud+sTsLOHgTSv+zQv9eEa6vyHyse9+7md8hw6slpCK/FSN8MWNfEzyWXrfiKLcle+oEEhYPCtQcJ7CNrohHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+vKvu3zc+DgVnr5D3B1gd6PuPYogA5LSOnv+9JqqNY=;
 b=EFagWZQWrfs6YVvV5vxmX73ou5nOiwdadFCfIOBgAyXjJgVxQ1ocrbT9Vef2/YGA//fw/IB97UA12N2c3GzeWs3NNi8qvc7SR5fvZZbRR0r2h+Qd29i0Jhmg+XheCQTkZGZy+n+XKHtycCRn4Y83exsEF54wUoaKm0rtIr1mpL10VmCAfmqPfyuNMdnPYUALTr0rUUE+9/eIJ5rE/XRVkGG4PhIh4R8cnt6sCI81GHz1R9eyG/6QH4R82km4toYgbss34MRDPPKDd/cO8lRPnR/DQm8IInEA2n3SrUlVzyeb+B2sYA937Hi5tGq9dzgBaj1UoASTq8UrP+r+ncZAaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+vKvu3zc+DgVnr5D3B1gd6PuPYogA5LSOnv+9JqqNY=;
 b=UN6bF8c08dhRv+o7iwm9oK/ixKrgX3bRHmeP8GCSc6tonCGHGbMQzT35SXUXQ+rqXYGY8mgQ9TOMnu3z/vC8iKS8dLCwgF9Ar2R5e35gAaYEeahlndinOD9l05U7X1zdi358nCo9YHcx/Lgz28ImTXsACq0o+dMfxMaoZJKOdsQ=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB6498.namprd10.prod.outlook.com (2603:10b6:806:2a5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Tue, 18 Jul
 2023 15:31:54 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 15:31:53 +0000
Message-ID: <aef4186b-fde1-cf3f-c491-f2747f08f426@oracle.com>
Date:   Tue, 18 Jul 2023 10:31:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 13/33] scsi: rdac: Fix sshdr use
To:     John Garry <john.g.garry@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-14-michael.christie@oracle.com>
 <f0822be9-c4be-5e3a-c260-2a97999a0e3d@oracle.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <f0822be9-c4be-5e3a-c260-2a97999a0e3d@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR10CA0001.namprd10.prod.outlook.com
 (2603:10b6:5:60::14) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB6498:EE_
X-MS-Office365-Filtering-Correlation-Id: f37009e9-9413-43e4-02ee-08db87a41cfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: clIIHgSw27kz9ZqfT512NwY54JFQImZNWblz02GxZEFxv3FV5sqb3JXcs+dYOUavyETvA9RS6qB9ufyFitGSsXXK10FrT53FXj9bVMJulA0RpqNU8pxDd9TM86gMQlkAXS9xYSRqaM9g+TwOKC9Pv7bnTO2aXcBvI0Qs8FykFJDPxQF2LLyVvGzT/2h+UcWT8KoJf003UQHT0AKjeHKceLqutVfo4lq62I+lKI4/kMqRnWloJEF6rzrTuKK8JbrRPVpH1rBWXzPyHsLLwJ5GDUb1rax4j/5QprPxtg4BIe4aJDyDFkgmUQRj5SakQIwVQde1AduqnTI9OpDVjYBKZGnOOGL4mZFWF7UsbqzP/t1qcWD7vMiwdSKvEj6UeTkAPLbleFCX24NBxGZ6KMBxE7DcKbPAVlnXSJ2AZLXmCGkpYq5eww3Ae8Gy1vn/6uNU0S2L6Z/LgWRiI/l5wj181JsjznLnUk70OS4RyIK0KWzP2zrTI6l1ToztDDIp+U7I7tsq3IMSzaSAoysnIsXjwAModGFrfyIXe6DxH9rXEkkOWP1I74UV6d80I1FWCq+N0zuOl7gef/NM1r/XTjtY718ymSWGBU9HeX1lgrb8k/xIJGa3Hjz37m4Xs9Xt594FrrOqFRjYR92ri1lGGeIpLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(6512007)(66556008)(6486002)(38100700002)(66946007)(478600001)(66476007)(31686004)(53546011)(26005)(6506007)(2616005)(36756003)(83380400001)(31696002)(86362001)(8936002)(2906002)(8676002)(5660300002)(186003)(41300700001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTdUSkRnVktkTzdWVEtOUk95dWExc2lYUGdHY0V3cWt5TjI3YktHK01pdXRC?=
 =?utf-8?B?MkRKRDcxZkhMU2lUb21hZHRLcEdyUTdzbkJBWmxlTWhUQjdPMGpTWGxSOWRF?=
 =?utf-8?B?cjVWaDNwcFYzSHorQ1RLVnZZT05WMkgyUDVUb1hHbmFLclI0clZPRVdrWFFG?=
 =?utf-8?B?YncvNmtkc2hBK3h0Z2dZSlMxT0E5OGZyNDlOcm1RV1Ruci9aNHAwRDVMaktW?=
 =?utf-8?B?a2VSdE1WcHlnRW96OEo5UFF0YmVUQVU5K0NzcEdJSVVSeHdXOUtuV3MySWxD?=
 =?utf-8?B?STdDYm95ak1GNEhHWGRZYUp0eFR5NXk3bGhKNTk2a2Zrai9mbkJhS2RIVG1u?=
 =?utf-8?B?Y0x5WlcxaUxpMGR6VXVwVWRlYWQ2MnVBRmd0RjVQbFJmK3AwekhpeGJLS2JS?=
 =?utf-8?B?L0pTbjI5UEwxV3ZtMUppbGljTUZFOFpmK290RHluUHZRZTdVemp3WkxodFpj?=
 =?utf-8?B?a3ArcVRoemhjWURrYkxmdnhZdlowM1kvQXVTa2RlS1JJZVRvQ0tUTXp2NDZL?=
 =?utf-8?B?MEEvWjJETGY5TG00WFFKZGxidFNmcHVvc2l5ZEZrZ2c4UEFBU1dSWldlUlZW?=
 =?utf-8?B?SFdua3BrMGVGTDBQeXk3MEF6UlpiQ3NiOHVHby9tVmZCU1VqOHdESVVOclhY?=
 =?utf-8?B?TWU1RlFSQzI4T1dMWWwyVlRSVTc4bXYzb1pUREw3Wm9vLzUrSUhwbVBSZFc0?=
 =?utf-8?B?NkVZOThlc05WZzJSV2REVVh4blMyRGMyVmZQS081YU5jb3ZFQ2NNUmc3Z2FL?=
 =?utf-8?B?NXNjOXBJSEVTcnNvWnN2Q2Jrby9FR3l1cUhkbjU3Z1c3S04vWmZZSEpJTTdU?=
 =?utf-8?B?ZmY5c3E2VklGRStTUnBsWTI5Ny9yV1dwVjBYNDZRVlZYZllQOCt0VjlHTmNU?=
 =?utf-8?B?Z1ZuaWVqVGM2L0l3MUZhTFVhc3pUaUFqTVhoNVlXczR1VS9PZm5kZUIrRWtK?=
 =?utf-8?B?QU8zQVV2THZQaTYyaWZTUklqWTAzUWE3SkY3TExUdTBkSTEzY0gwSkVGMWNK?=
 =?utf-8?B?UjYvK1VOcGppMWhQWm5VcEJUOGxyY0RMQWYrbUlLSFR6YXp2TFZ3cHI0b3Fl?=
 =?utf-8?B?SjFUbWw2ZkZIU3VONGxVVEM0VklIdXJ5aGI3cE1RR0U2cVc1Mzl5dlV6N0JX?=
 =?utf-8?B?SVAxOHJ1eXNNODVCRTA3eWZFZldxWnhtVXB6ZUtlYnRrUk1RYVRLbGR3ekxC?=
 =?utf-8?B?OHhaN3MzckZMVExBSUpwNXZ4ZEVlUFYwZnVYRVNDUnJ4bjVQUzJLczV3WCth?=
 =?utf-8?B?eHhyOE9ZQVMzYkcrTnlmUW5JNVU0Mjgyd01ZRlJoa2grc1B5YkR3Qng4bDkx?=
 =?utf-8?B?NFFhaWppYXkraFhaNEc1ejBCQnh5Z0p5QkVqWDdoLzVGN2dLSXNxZkNkS0dD?=
 =?utf-8?B?N3Z4NkRnQzFKUjRaM0Q5eHEyc3ptQ0RySWVTdUh2RXY0ZkIyOUhnT1VBTDFu?=
 =?utf-8?B?bW5zcEs2TktEemZNTVdqSGJSQXNaVkQ2azRFM3FzZHBqWWRvUm1VbTcxdGFP?=
 =?utf-8?B?VTMxSTdQVkx3MEp1WVlUMDk0eFpNb01RdDgyaDQ1d3o3SkRHSkp2cTJ0aG51?=
 =?utf-8?B?S3ZsQ2VvelN1ZUNIV0dLMlUrc3F5TVk1MWMrdmp3MFppc1Y5ZC9vN2RRUWxh?=
 =?utf-8?B?RTRUMW9OS2xqVzRyTlA5L1JVYU05eEE3NjV0dElscGFQS0c1VzkybEQrOWhN?=
 =?utf-8?B?UHN3L0tjaUJOWFVvcWM3ME5BT0dMamphTjdvVjZBYlVJY2VMMC9ibWU5cktZ?=
 =?utf-8?B?N2NPcEpDRndFaTFTb2Vnbzk0SGN0aXYwNUJRT0J5cksrOHFVQU5Ba2lDMlZV?=
 =?utf-8?B?eXQ4aTBsSmlmK1RsSlFLajBhOVZ0NXptcUROT1Z2NUJuS3NhYUg1a3g4ZnRx?=
 =?utf-8?B?MzdoTGplQWIvTjdKTlIrOG9UYm9aLysyWjZocEZyRmJFSlNpSE5BVUdkVEtK?=
 =?utf-8?B?SGxTaWRRNkxLektHYzFHRjhRc083OWtxaDRDOFdpU1djcjhuRFpFTFcvR1FQ?=
 =?utf-8?B?ZXlBWFBVNE5nbjlqYVRFczVVc2FpMXRud3dGV3RqRXh5dW9naGk1YUMxRlQ5?=
 =?utf-8?B?cXFrMi9QbklhM2VMa1lBMHhVN3hkb3hscERrT2ZtdFlPNTJGeHJTQ3dRMjI0?=
 =?utf-8?B?VXhtMlJobDlXY21KZ3lGTHpLYm5rSytCQVJwTGdxaldlTWllSkd2dkRqUjAz?=
 =?utf-8?B?TUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: iSRSt5zZp9MTNy66D0tgp6ZDHk5hTeiMmocQd3IHX2BeBXQXT1cyveRew8mUJsLgXWd9s5nIBfd/P6jGp3eLCGP0vr7PJrenkIr4amsbeFo0uO1qaSSEC+5z4f3W+r4cxZqhAwWY7S5lDcm+/vK3ZO513w1aSc2wjmjHcAS/s2epmfrU5LGkPWU78WskdJNikU5LPL2hnrtg0FxAIYU9gxVwJSvmdSf4Ib1eMeGkIBfBul/jPhXGxLg3th7nvFYBVpIKI6JqT8jjiA5G2q0+eT0SXFdvs6COSgjreuVf1yej3mNe6EETKVwVIDgBTIMZZJaTgbYpMYAZ72fARzV2CUkVVzakBoTI1eCeWM5uMaokIY4DInvcYGrYA708SdxP3M2qo5rGv6A0Nwgf2VKc6KKHmjHKRpnFUgYXsL0AbVeE+CCL178m3heZENChK5jopQgV/ybHQ0w3dqkJkFVAull69/52Yl/cA5ZPWXgEBVvv6gKC0zhc0mag/bqOnx0TpNlA2ml3S/Ix8BOGp20nyhMQc7xPyO11WCjVxgr6JJZGIrwCe+Ag3h0YXoLaY/aidff3phBo0ejor7f4pRKnTJGdg62lCab5l0wlxcqJvUL9OnqKtny22J3I67k7Z0j8ldKABMxVlik1YhvF2HUTxBs+CQTEWpmjV8cesr2S64a8rAFoniO3nu6kHv7ZnbCKhpw+wQedu62AIkHANAEAbWw8/WsK2vD6fSl+LLFh9xilxUXiRxdWwTQBI8eiluxs7UAnB3hJQjoQSNNEs/4fYxBJTGCTDxuG72s0pB7YWG4vnoBY+Xzw7OH1IQlP5CDaCVX3hxCXD8H08Pl2geMRo1quQfeoRAzUF5GxyNbFEzpuxtiTs2qEvs2ZHlaIcUuV
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f37009e9-9413-43e4-02ee-08db87a41cfb
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2023 15:31:53.5277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9NqlGlrmxL30PFxJ/cOuiIrRF6xWFWy+h1L7pM4aK531N6EJFBrd4V7ZJaOuuQyQy+fNcncPr4f+7p+m2g7BH1UD47vdLrwg8uCV/2HwT4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6498
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-18_11,2023-07-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307180142
X-Proofpoint-GUID: TrvFiVSxpvhClgR1R9IrT7WThiUa47AB
X-Proofpoint-ORIG-GUID: TrvFiVSxpvhClgR1R9IrT7WThiUa47AB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/18/23 8:25 AM, John Garry wrote:
> On 14/07/2023 22:33, Mike Christie wrote:
>> If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
>> shouldn't access the sshdr. If it returns 0, then the cmd executed
>> successfully, so there is no need to check the sshdr. This has us access
>> the sshdr when get a return value > 0.
>>
>> Signed-off-by: Mike Christie<michael.christie@oracle.com>
>> Reviewed-by: Christoph Hellwig<hch@lst.de>
>> ---
>>   drivers/scsi/device_handler/scsi_dh_rdac.c | 9 +++++++--
>>   1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
>> index c5538645057a..cdefaa9f614e 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_rdac.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
>> @@ -541,6 +541,7 @@ static void send_mode_select(struct work_struct *work)
>>       const struct scsi_exec_args exec_args = {
>>           .sshdr = &sshdr,
>>       };
>> +    int rc;
>>         spin_lock(&ctlr->ms_lock);
>>       list_splice_init(&ctlr->ms_head, &list);
>> @@ -558,14 +559,18 @@ static void send_mode_select(struct work_struct *work)
>>           (char *) h->ctlr->array_name, h->ctlr->index,
>>           (retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
>>   -    if (scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
>> -                 RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args)) {
>> +    rc = scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
>> +                  RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args);
>> +    if (rc < 0) {
>> +        err = SCSI_DH_IO;
>> +    } else if (rc > 0) {
>>           err = mode_select_handle_sense(sdev, &sshdr);
>>           if (err == SCSI_DH_RETRY && retry_cnt--)
>>               goto retry;
>>           if (err == SCSI_DH_IMM_RETRY)
>>               goto retry;
>>       }
>> +
>>       if (err == SCSI_DH_OK) {
> As I see, err is initially set to SCSI_DH_OK when declared. Then if we need to retry and 2nd call to scsi_execute_cmd() passes, such that rc == 0, then err still holds the old value. This seems same as pre-existing behaviour - is this proper?

I guess this has been working by accident.

When that happens we end up returning one of the retryable error codes
to dm-multipath. It will then recall us, and before we re-run this
function we will run check_ownership and see that the last call worked.

