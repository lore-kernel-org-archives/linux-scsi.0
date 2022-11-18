Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A93C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 09:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241890AbiKRJTb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241896AbiKRJTE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2022 04:19:04 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9599209E
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 01:18:54 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AI997vY005234;
        Fri, 18 Nov 2022 09:18:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=l4+DmIe+dTyKccLxt0lZOfchWn7FyMwI0gABe6fVWSU=;
 b=lIwe1ONFuQkrXInJkhQ1mFFcQD/NYdddhtfN6OxvjvDblvUZYyTkEIEgkTtFd0bcrW5Y
 eENkl/dBcRBgRIcjXZF/k7R9ebcT0gXtyLtMIDVOtgf1Zy5UIbnLSXjRlrvgMDWarrUq
 9y4kh48zYS7n9XxF5H9yMg7MQHXS48BJYCLZiuplAtqFx8s2ORq28tBEUivAi4poRZPs
 9h73NvVBJRB0+zQ288gmvtKJLKxx3mpNrSbm6aRdTN81KRbQZW4TqzxGpMP23Jc5cN0d
 34mBrxRncEwoj6xHRULIsEJduqyROrSWJqQHczQFvmhuUXW6GOSeCfnlvPTGA4LOWzkX 4w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kx70ur183-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Nov 2022 09:18:47 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AI6mV5h004277;
        Fri, 18 Nov 2022 09:18:47 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1xaa8eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Nov 2022 09:18:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L2i4z/CmvrcqTegG4Zk/tCHZrbVA12jCiWUW8b7v75keLcd3hJAI1L+SkEW1IumUlXem50SWnOVn9uFYgQhgx+WrF6/5cTlTExmD+ffVOdxii7gtqwjcdr/pp3k9Qs+4POHrb+3DsfUmEERsZEauMHBgkmjgMcCEOLKSNNgE4VZenJKa5pgNHxIjT6JSF0OtieeuX9d/c+T32q+LPSuy3rosvgd3Yn36pK403H1ifLO0Z8vNgzRK9eFvv2K8ockjnP9K2s6SkudvRtB8z5UjWm1PQ8uUpykEIw8BgOBKsmsLurt6kfnADJSTfs30U6L4dOA74a91R2sN7rlH5G5BFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l4+DmIe+dTyKccLxt0lZOfchWn7FyMwI0gABe6fVWSU=;
 b=htyDmXFNz7GpqfkyHyH+IPyQuWXlIqwaFHOEJ8fnz+ID6z1YAx++2WglrEO56Z6KmXpNgBLL48FKHI3a7mHrQgSehbTsj19V5YEezayO7OQBsZL0FGH5iMF6PoF1Z+qcYBOhKCX0vWdyCpnBGc6GSteXtDpcDwtrp6TkUm/8wdpeA2udsmkNRsAeK5yuRrkmtfHWtBklNQprJ2TRcaZ39rmbk3ZIGeg61mFuVBEr5MKbDLiv9BIajkEZ3XQHkf2o5qxLoni7ebLo/yVMERkx7hdK2i2sfF0DnRH2nK0wuvrZzdLEWAMvy+vRzwZL4B5uoRNK/7v6O22ck19JwoyYMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l4+DmIe+dTyKccLxt0lZOfchWn7FyMwI0gABe6fVWSU=;
 b=HHeIPrv7UX8+/CkDKLkGeUftpoVytw3LEVt8BlQO1jQA1/0c+6VO/pJmooF6kvLW9numxogSfaIrtaeMBg8oztv4xyCp36UAgpk2kQ7P1/wfZ5xHqbinwehhWTg71SRzJ1UNohHKkCs2LhiBj/bXbJ1ssxOwulRJ5cgkFVpYmL0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB5675.namprd10.prod.outlook.com (2603:10b6:510:127::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Fri, 18 Nov
 2022 09:18:45 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::d0c4:8da4:2702:8b3b]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::d0c4:8da4:2702:8b3b%4]) with mapi id 15.20.5813.019; Fri, 18 Nov 2022
 09:18:45 +0000
Message-ID: <9ff2a73c-bd45-c19e-3624-8816c5bac9ab@oracle.com>
Date:   Fri, 18 Nov 2022 09:18:40 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2] scsi: scsi_transport_sas: fix error handling in
 sas_rphy_add()
To:     Yang Yingliang <yangyingliang@huawei.com>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Cc:     martin.petersen@oracle.com
References: <20221111144433.2421680-1-yangyingliang@huawei.com>
 <4f1992b1a90aa9e5d143ac47eadae508a20b9f9c.camel@linux.ibm.com>
 <45fb08d9-ebda-4c8e-23cc-49f79e5ffde8@huawei.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <45fb08d9-ebda-4c8e-23cc-49f79e5ffde8@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0180.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::24) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB5675:EE_
X-MS-Office365-Filtering-Correlation-Id: cf8ebde2-6275-466a-a53d-08dac945e44c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vZO0dgtzKYcSrSUAFY0qftIEGGt/HLvoNoy87wI3HVnZaiBrrt7GDsJbGoIenxQTC5wD8lOVC3I22BpDWx0N1lXhp1IGAb0pd4hb6EtKrvY9pUU0s1wi3HYQqpU4vxOE3TQGvuHADXpkMd5/548ZrN5Mv55BETE6NeCBp4G5bZJRGhod24T8nJbTRClhu4s/aIUZlHH57Trkuf1V8XJf9E2Z6brxor0/ax4KCJnsq9/WHu2b1TQlY9OW7wvfq5vP0loQL9rjpeIhT28ACja43tmbAUL1ElcvNdICJQoGp57i/Ks51IPAEx2g8pmr20u9f+NJNLaFWzGtjGA65Bxv4ShYfIApVq416w00iqneffAeZ3V5XqSkR5OaWaUp5MNaaCMmsW8S/dNkRmMgq9elqxScoC4RIeuXXLRAjHjdsQxoZmPxGf96dNr+I2VzpE48q1i187quAzPU42Rv7AkyM3u1mwavLgbDxBHogY1huAuVggOorJxle1WPURwPbwp6W0SVlUAzPVO1H14yoc0/CI8YD8NtUGEXOJvNPcWFSnytgGLbMANJWnWttJPZkawyD0cDQ9xYIDwBLlXYPoWxpqGLK9S2ujndG6Jxi4x6Fl8ac0jWZz2a3OiD5bVP22sErHLlwky6Y2v/AfIAd5QKfcv0EmDiIzQ9oCvWDtQF8g618Q2NT+CBedsD7crTbmIMqgCveA1Y+RJs6NWLsTH49eSy9Q2aOYz6z4aLgwPXIGw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(136003)(366004)(396003)(346002)(451199015)(31696002)(66556008)(26005)(86362001)(66946007)(38100700002)(36756003)(36916002)(6486002)(6666004)(66476007)(83380400001)(110136005)(8936002)(2906002)(8676002)(5660300002)(4326008)(53546011)(107886003)(6506007)(316002)(41300700001)(2616005)(186003)(478600001)(6512007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGJSYlB1Tkw3aStseHplTjNHeis1ZnpZRHd1a09jc3NuQXR3cXVoVExKVDhm?=
 =?utf-8?B?WWxsR2dhT1ZCa1lYZTJjVzJsRkVmdmFQQWdidnZIV2V4TURQR2xQNldiQUZO?=
 =?utf-8?B?RnNFSEtQa1dVSjhGTXVWelBZMkt0VTd5dEg4Q0JXZCswakljeVVyZWxUMVc5?=
 =?utf-8?B?ZlVJUG5QUzFqT2hFN0NSWHZrb1J3LzAwdG1vek55dytVSXRsWmFWbFdyOFEr?=
 =?utf-8?B?bGRvVzRXMUtGS08xYklwMjFjekR0NkRGbUp5TDVMYWxmbzY1ZDdSRU5qb25n?=
 =?utf-8?B?MEsyK05KVnMzdTh3MVhUL3VBZDdaRk5FRkh4UHlCRXlSbVIzbDdEalNOblpI?=
 =?utf-8?B?MFhGUmlkZkptdXhMQStIaTdkSWVQdEFMLzJTcHFsbDhza3NRUEZ4aDRLeWpY?=
 =?utf-8?B?Y1FoUWljdE9HbDlnMjdMaXluNFhzeFhTOUd1ZWJLblhmN0ZBYVBJT0dsclBQ?=
 =?utf-8?B?Vm9tSFRPbDhRYWJJYk5naG9BaFBiOFFvNGNkTXFJTkxTWGtTRndGckptdi9m?=
 =?utf-8?B?QmdLN0x1ZG03WjVSNHd5NG41REtzTXhnRjN0MXpycEt0UWhoQXBNMjR6aVQy?=
 =?utf-8?B?SC8rbVdLeElVeHFSRmZZcW0xaXA2M0lZc2dnOUV6N0pDYVFHczZRNnVvM1gw?=
 =?utf-8?B?ZGVrOVdxTHV2cDhDUXRDR3VSellEdEg4cnM0Qk1UcWU1MlJ1eVJpaGF4NDF4?=
 =?utf-8?B?YzNpYXdscU5IT0dINW9UL2IvUHF6Rm1oUGtGcWZIZnUrVFMwWXZ5bnJwaVJW?=
 =?utf-8?B?RnNvVkYveXRBSks0YVcvd0ZFc0l4WEN2UDJ0cnBSVXFzOWFwQUF4M3JveEFV?=
 =?utf-8?B?ZzRoWWR5L0FaZSs5TnNpVHlXNVFuMmdVSCtDbXdzdU1qYVZSQWFNRGNIQ1hQ?=
 =?utf-8?B?aFJuSzU1UkNqcUdRbEdzRDc5N016VUlCS21XVytxdVFmc3Q5OTdNZlBtejVa?=
 =?utf-8?B?akFmSmtNT2d2THVsMllIZnlEZGkzOWdaMFB6YzZmMlNnTWJiUjRjT3ZZUkMy?=
 =?utf-8?B?ak96SVBXZDNBdXNzaVBUUlBFZkltT3ZyUUlZQUdnbFI2SlJFc01BS1ZPeUpL?=
 =?utf-8?B?MDZrUlQ1TGVJQ3lTQUJuZVBad3BLU3FXMVhlb3hQL0pYUFZUL3pWTGkrdVNv?=
 =?utf-8?B?ZDZVd0dleXRSb0d1NTl5enRtVFVxaXptcjh2eW41UXdUcWNzVnhpcXpGSWpT?=
 =?utf-8?B?RlpFVFN4WlFKQjVkK0tZcHBNVnlnYUszYWxFOHk5elZQOHBEcnArZHJpNjZQ?=
 =?utf-8?B?YmFibVE1anhoRzFLbHVtdnYrU0hSMkxIeW84NldUcGxIa0VBTnhTbzJGN0FI?=
 =?utf-8?B?ZC92Zk91OWpsSHcxNFB5ajVzcnJZblBaZmdvSkRwb0JpeFNXSCsyTlh0Yzlj?=
 =?utf-8?B?akNiMjh2MWhLaE1MTkJwQXdKWlBqdW04TXBkY0Z3cW56NFU1cTZHazZwSWts?=
 =?utf-8?B?ZnRWWVVwejFoY2NCZmhCMUxkM2MzSG4zSlMxRUI4VWtiRVI1b0l0Y1ltWUtY?=
 =?utf-8?B?aXJjWjduNlJTQjVTN0tFM1R2WWZWaU4yNUQ2OGwvbkF6R2ZtN1R6dTVGZVJq?=
 =?utf-8?B?K2x0bGNTdFM3UDNrSFZqYjBYM3JjcDZWcXBSWDN5MEhuWnVka1pLZUE3bHB3?=
 =?utf-8?B?VWJMMHdwcGg5WWJHNkhJZWpPd09WZWVGV1pDYXloMWZkNDF4aG1hRXJXNTE1?=
 =?utf-8?B?UzREZ2lOZkhsL1MwZVBzZG1lYkEyU2dHSEUrWkZZVklteWdsL3NYV2cwUnV1?=
 =?utf-8?B?UUQrSVlLS1c3OWZybGV2ZUkyY1NFeGRLcXhEMERTdG5KMTR0UmRmVkg5Mjk3?=
 =?utf-8?B?dncxZG1BRmFKZEhVakJWcVN2YjJCYUlVU2NSNnJpRktNcEFDN0kzOXhoeWR1?=
 =?utf-8?B?VHltVnl6USs2WUtKUGlCeHpIMDRPVTV4YTlpYTBSMmdoQkk2M21aTW83SHlo?=
 =?utf-8?B?Z1JjOUZ0RzNKdXdvWE9DdWJlZmJPalovYUNWZ0RVV2p6MU1qZk5jdGI4Zlk3?=
 =?utf-8?B?VVNhYVpFbGF4dE1OcUNaeXY4bGZiZy9vdjdlYWZBQzhEd3RXYWRhTkZ4Tldh?=
 =?utf-8?B?YzRnYU95TWVGOE00aDhzc1ZzS2JpZEtQeldZbTBYOGFLRkpDa0dYWXNzYzlw?=
 =?utf-8?B?OGtXTjZYaGMyRlNCM0dXSTdIRVZhOTBJbk56VlYxeTNSRFFOa0NSVHIzclVa?=
 =?utf-8?B?d0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: R/4bWTZ4+bpt/woP5bBDmakYGAIh6x+E2PD1QK4+6/06Qg7CdsPUmlDL8vR8kvtvPy2WiIFIkhZnEl6TyetLT8/a5tifr7BRKPY7mMql4RaLWH2FiLEBBNTu/ZlgMXrhutHIue8bo4rFB94L22dGsFUzCKWHTerOf+xu723GPC8ibPW63Y+/KrdfSBnI+dzAROTVCs0dTlZl/y9PbFMQ891FpHOQMTKNkWqbbAso2/mLqgZ08NJ11x3NtE/znvP1IPPBCuCEL32Qkx6SP5JjKCNScMSr9t7r0pvVGlnxFrignhxXIqn7FN2a/vilTXijmTml5roCyCUmYnUXGfDDRRdzoS8E5cqOn6PwcYVbZsY57ZK/ZkAMS/pV0o1BznjRiU1bl+3bZK3b8qftXcWJmNTeBmTVjR5IEPCd+R7Gr0rMcSWsvcCM/Z8my9VxYP96SPCYBucVAzUdWHV9MrvBnxhpfe6FTHHMvVo4VbPm95ZLY6Kj9w7iZofKVFuwbAbpF3cg9KTHNVtXHIozgmc1JO4FP0VI5ATVxFkrLKIq9KEGdhQn8w88RIuO6Ac5+ZCVf1DTOXfSAcaeGNZdZ8DIyoqDxQ+vvpA5ZTDQVfaCE02Kub1jiOPaYeuYP0MflogB4vEALZdYHQk5CtTahwSgF31E5uNCYJzkhau7TZeRHxw6wpkuYtKlmPyeoW1/iYy9xsPg3X7hQSTQuPER3iUSjE3aFrf0zZGwaCKE9wGeQNtsPIt1q76+4s2hovx7xi/U8WCDCSrHFiYwSrhb9DID+3arHSRp8RQxi071sb+6mUxkTc3wmgOC16uikz9VC6Lmabo2IlaOIIRvL1f6MZirkLfIlrKA0OIh6loHxJRbWWWWxeoXtcD/fst4t3hcPyNi
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf8ebde2-6275-466a-a53d-08dac945e44c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 09:18:44.8375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cMTG29wllg217se2/HfnFYydhfqGS+Vz4Eh1VWLM0l6bXbEluradvYcwqrnjMLeSxcmbt2wqjTQb9/kOGl0kKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5675
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211180056
X-Proofpoint-GUID: nmmPIbKzcxuzvuuyTVaU3adArjqyfXdf
X-Proofpoint-ORIG-GUID: nmmPIbKzcxuzvuuyTVaU3adArjqyfXdf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/11/2022 03:11, Yang Yingliang wrote:
>>>> );
>> There is a slight problem with doing this in that if
>> transport_device_add() ever fails it's likely because memory pressure
>> caused the allocation of the internal_container to fail. What that
>> means is that the visible sysfs attributes don't get added, but
>> otherwise the rphy is fully functional as far as the driver sees it, so
>> this condition doesn't have to be a fatal error which kills the device.
>>
>> There are two ways of handling this:
>>
>>     1. The above to move the condition from an ignored to a fatal error.
>>        It's so rare that we almost never see it in practice and if it
>>        ever happened, the machine is so low on memory that something
>>        else is bound to fail an allocation and kill the device anyway,
>>        so treating it as non-fatal likely serves no purpose.
>>     2. Simply to make the assumption that transport_remove_device() is
>>        idempotent true by adding a flag in the internal_class to signify
>>        removal is required. This would preserve current behaviour and
>>        have the bonus that it only requires a single patch, not one
>>        patch per transport class object that has this problem.
>>
>> I'd probably prefer 2. since it's way less work, but others might have
>> different opinions.
> Current some callers ignore the return value of transport_add_device(), 
> if it fails,
> it will cause null-ptr-deref in transport_remove_device().
> 
> James suggested that add some check in transport_remove_device(), so all 
> can
> be fix in one patch.
> 
> Do you have any suggestion for this ?

Personally I prefer 1. However did you develop a prototype patch for how 
2. would look? And how many changes are still required for 1.?

Thanks,
John
