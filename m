Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD535C4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Nov 2023 14:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjKFOM7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Nov 2023 09:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjKFOM6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2023 09:12:58 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE39D57
        for <linux-scsi@vger.kernel.org>; Mon,  6 Nov 2023 06:12:54 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6E4fYk008986;
        Mon, 6 Nov 2023 14:12:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=MbIc3eH3H7ElEDUwPUPh7N7z5wUsDY5mIIW9ZTRtCF4=;
 b=sc3cQ0I0oBoZf9l0wwi+REuscKBNmcaJps6LqkvMftLBXZG2RjM9bokrqahkcfOSHAd0
 x8woYxG0Wvd1C93h6x4+iaIRlsBLR8KPGFP0O416L9r2Qv2pmLIck/Uq6LM9buH1E5pE
 AQCA9V1VpbiYq2iyuol9o/p/Hh7xzVceCA9OaFtJBnvXYb7Bgjao06IFV7dsRczB+DHC
 a0SglNh3SMtafHDrlhV2ZUtrA5Xl8zxkJ5Bc71Cqsqem69gkm8AeO9S2wNT4DaReXMvh
 IKByeq8CjT8BQ/j5MKsi4w3SZgXHHZ3cuG4XuLcEmyacES3oFKi20G60CTOqoC8w985F Ng== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5dub34en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 14:12:12 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D1twN020827;
        Mon, 6 Nov 2023 14:12:10 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdbdf2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 14:12:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdFmnKU8OB6iZryq9NLmgBjf+Xe4oT+R0YkGcMAS2NHkvON0HgIFnwoLtUqE1t6j6MntAqOe/KdP1C8wdTO/zXysEbSJyJjgmiqPjz5MpHJcif8gq+fDMyWqSAogoXXPQYnF3qczKKGd13t/zisIScehfnu6+j5KSul2Ne5xP7NoeyoYUjrNTOXpPekm71rIsCSR8bVD5iiRmpS5XBm5oR2jdxoo7eikb9qjs4FFRwlBVDiLQ8kOgpHBFhFE2v7B4OnJIBQW9xaT4xkvRXqwshteTqunWNhuoBRDjrmrnDXQKyNxc5jqfA+MRF/xhK4PdBAQKugfmUqtx0uU5fKL7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MbIc3eH3H7ElEDUwPUPh7N7z5wUsDY5mIIW9ZTRtCF4=;
 b=dAJXaZ4aqMLArHO7M9y1i7d/w/fDdnPYBOKrqrDU2e7gc8VloeFTFmsXSdCQYePi+9O7567KJb4M0Up7sw2F+kA07+1B1WcaeAF5/juXXoZpuTx5tw+feOmv1fkAM9HgHBr4xr4TvjzAC+oMcwHyYWEf2/AMaIL3rvCsE/i0qb9JweaWefLaQiKSlYipW7IPQmY2O8gXWDVKPIpCNmeQfALLLr7zwK+L0/xBTNvC0JafgVXcL19nrH1PUsEoVN7CNykUUYe3xPhLxgExigx2O3Uofv/z0Dq3Vg/Y0w+9M7Kg5x+w4CSKoJgFC8BILEuhpHlZPmmM5C7bw0+ltv/EFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MbIc3eH3H7ElEDUwPUPh7N7z5wUsDY5mIIW9ZTRtCF4=;
 b=QibHZ75CMibIuJVd2eMe8cI8/Wuu2mNKKf88xpupjDMfW46J5sc5rDe8SCFg3LyzUJBs2FBEo+H/hLtEkFhfNCA7qQtb5IFQuo21+uYzxWjI/Vh24ZrV2AqrQW+hbnjj0ZuTJhh44AVYUGXO5L4XdmZOy/0Kb3khENaYOLRH9lc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA2PR10MB4651.namprd10.prod.outlook.com (2603:10b6:806:11e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.21; Mon, 6 Nov
 2023 14:12:08 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::2c06:9358:c246:b366]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::2c06:9358:c246:b366%2]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 14:12:08 +0000
Message-ID: <c69856fa-8ff9-b35f-b644-319c0593de71@oracle.com>
Date:   Mon, 6 Nov 2023 14:12:05 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] scsi: mvsas: Try to enable MSI
To:     Marek Vasut <marex@denx.de>, linux-scsi@vger.kernel.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>
References: <20231105183712.26520-1-marex@denx.de>
 <6f36e52c-e77c-0695-ff33-c4f737430c13@oracle.com>
 <9565b53d-68b4-464d-bbd6-290ec1fe66eb@denx.de>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <9565b53d-68b4-464d-bbd6-290ec1fe66eb@denx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0304.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA2PR10MB4651:EE_
X-MS-Office365-Filtering-Correlation-Id: c57af459-ae52-46a3-c0db-08dbded25c83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cD92Kbg2+Qi+a+TPSAR+DwCnyeL2tzhAHMknO2t+RYhLGT6bgzV42sz6sGWnz9jooIXQQifp2a946ra8qPlCiFFlrU06HV4ZT/aJoL4mLawRhNXL/5SfD1jmiuWPCqcU0oH3k0OlSdQ90UF1LZgHYDzJB1PQYd9O6TrIzQe2j1KPkRuT8jCGhiosNxdo9AycCvhMwtonNb3p+UgYbcP78o+wTsULDDeNZ1Dhgs84jbrD6y7FhVZ3wbsWjbL10emR9TgIVXg37xdoORqbeRAjtMX8KgVSkjFAYNOWjxE6ruKOlgPggvNSyhviENYJNWQ5fVzmxNQstshedFfuaIWS5oGd6O6DUqAZaHNp6/H3qpRczwGCi0UbaZL+w+gsOjLKkJBVbulpeQ/OwmbfVP9EvryT9lAp47ktraasutWkAClosVLhuRbNHfGsvcFoD0HcX996wWh1uG18Mu8ei8MrzK/awz2JGAQc1EjWMjK2zVI9tFohmdMiAdhR21bdUY6bleN297mfjY8WZwaVoCxKoqlv7xyfIe/AGFoAkQByVq5IZj8jo7bnLERD28rKxNcKZguAng2EfyFQh/QRONtnkIVf+7tnHl96/ZJCleTuwgFfi/foEZ1oma4tjXrAV/kK8+6B436xZAVvCtUP2hxrKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(396003)(366004)(376002)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(2616005)(83380400001)(26005)(478600001)(86362001)(31696002)(31686004)(38100700002)(6512007)(6666004)(41300700001)(8936002)(8676002)(5660300002)(316002)(36756003)(6486002)(54906003)(66476007)(66556008)(66946007)(2906002)(4326008)(36916002)(6506007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aTd4RG50TDBoQ3NKUDNKaTk3T0NxVTl0cHBpQ1l3d05Ta2loYW82eWJHaDR5?=
 =?utf-8?B?ckI4UHFjZCtkOHFJMHV1TlB6WG13UTEreGdyem0xU1E4eEh5Zm1WUk1VMGhW?=
 =?utf-8?B?US9zMUozYmZJRDU5NkxiTUxueVQ3NVE4SWljL3hrWlM1Um1zcFI4d3Z0dWxS?=
 =?utf-8?B?MDRySnhzL0Q0WlFOUFpROTUzTVFGUEtKckw1M1BET0NiL1RaRmd0cGdZYWx3?=
 =?utf-8?B?RmgrRk1IVkJIcUt1Z1lzSWpsZjdLWUFaZ2FwdElGbW1WUEtkNFNpdGlybWhm?=
 =?utf-8?B?WmxMQythQWtlWVkzZG85NEFValptcVZ5dVhXa1Urckpnb1FpUm5QaGZjUWhZ?=
 =?utf-8?B?L0FGNUdJREo1SnFyUzZrUiswdTZtYXMyRVFUUlZ0aUpFTktSdGZmeXRzaXZa?=
 =?utf-8?B?MUlQc1hzYWQ5NURHZ2ljcjFwME9zUXpTN2tIMm1ZNzZzNk5pU2J1U3lteU5z?=
 =?utf-8?B?K0lyWExUODBBRTR2MXBIOENhbmgveDdZYjBsNTJTYXFMNEEvSUFYUnZQMWNY?=
 =?utf-8?B?SXE4NU9NSmRmZlYwVytZWklIdHA1V0NDOGg1WHV2VEd0Ny8zWE5MK1FnK0xz?=
 =?utf-8?B?S3JTVVFXM2lLRGdmRjJhZWVaOGNKWkdRV0tjbzd0cXJnV1Y1cVBnK3FrQ09V?=
 =?utf-8?B?Mkw4bzg4ZEtSMWF6aHFFeWtMUVJ3cURXeUNMS0kxeGcyK0tzK0FWanIrdUlm?=
 =?utf-8?B?VVdZNmlYV200ZnJtRTNIZWQrbVdrdVI1RkUrMm1ldmpZTjhJRG11WTVGZVdl?=
 =?utf-8?B?b3ZzS1p4V2ZkYkR6RGlXU0RyNmtwUzhkMHlhMHh0WnRtZis1ZjZ4QmtXb1JN?=
 =?utf-8?B?NTVqdytiY09rSzNBd3dRdDVTZEh6M05hWXN5aEdLSjYxN0FHYlprc3pWZ1Zn?=
 =?utf-8?B?NUJ1T2t0Vmp4TlZSd1pRTHNsSmdvbk5CbUtVVXc0L2p1ZmNTbnJNYXZETnNW?=
 =?utf-8?B?NEVRRGdZTHFVN2JFNnZ0QjJ1V3FqTkQ3T1JhNUdRemxPY0NUcmFzbGxWYlMy?=
 =?utf-8?B?UjFxMm91OUFwMFhnRWxzQW9JRTVPZkNjMzZ5cnFmOGdtS3c5M3kwZTBqTktY?=
 =?utf-8?B?Mlc0MWNjd3pZN3lnYVh3ZytzUUhPYnluaGM0bGtOOGJtZ3hYT3cwZlBJVnRP?=
 =?utf-8?B?MFVtVm5rQmtIOEkxNjJPNTBrcEw1T0xMWEVFbitYT0kySmkxclBBNVJrTEQ4?=
 =?utf-8?B?b3hKdDJ4OUNFUzFPMGljbG4rcmVTTzdYL1djSXpPSFRnaHNISVNDb2dqYWpw?=
 =?utf-8?B?QTlVZGZBTWtRTytDMnAzTGFwSEczSjZFNVJ6aDFzYTR0RlBYVUFVeFpEaTR3?=
 =?utf-8?B?Y0ZNQjhxWnkzRlJKeExlbkxQcmJ5a0d2QnlWbUx3ZGw2QXVreE5IVDZtL3d3?=
 =?utf-8?B?N25RUHN4RDFmR2hyNDNDbzQxR2ZLaFFEVCtheTE0WllXMmp5YmJNbkYrQ2Rh?=
 =?utf-8?B?SzdNSTlncU5HZG9HdWZIclkvQTNsUFlYRVdsb2wzK1VVeThoM08rL1hkY3NW?=
 =?utf-8?B?Qk5WWXc2Nm9meklTT1dpUkRWKzlmc3d5ZVZiQTRJNjlDN0xiVXBCR0JVcUZV?=
 =?utf-8?B?YlUraVRRYmhYb1EzNEdaYWkrZlB6SEJXb3BnWnkxRzBFa0hiVC9PSys0K2g0?=
 =?utf-8?B?c3VYRWUyNzdNbnZpYktlSVVWUkdobUdoWUJXWU96Q0FsUHF1NlNXSzlDN2RW?=
 =?utf-8?B?amlHaTRpclJ2alEzdG1VaGI3MURlUzJaYlVXRVhEdVd1SnFnc1VOUG4xREY2?=
 =?utf-8?B?N1MzSksyMGIweUpndGllRm83cnhJVHF2OHc2TnJQemlhQmxFTnA0K2xGaE9J?=
 =?utf-8?B?a3NNemdNTklHZHpKNitLT2QyTEw0Zk1nbXRKUHU3RDNtdmZiQTNrcDQ2eEpW?=
 =?utf-8?B?dGJZZ0FkMGo1czAzSHdhTVNObTRORFNMZiswQ1ZCdEMwQkN4WnJCK0RvVnpY?=
 =?utf-8?B?ZnFKRTJNTFNYaG5zckdmbXVpaTFCTE9Va2U1U0hzanI3a3VueDFPdGdheDhu?=
 =?utf-8?B?SkZhK3I3ZEgyTU5paW8zRFRDNUs0SnlWTHRlMnRhZ040UXlNK3luTjNQQWpr?=
 =?utf-8?B?QnFLOTNBYUdrYjVURFRINklWNnNYOVNrc0tNa2NERXFWL1BDaDJkSzZRb28w?=
 =?utf-8?Q?gTxfhKFUcaxzhBjKILDecJpDk?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: l2Gm3x8qtTjWB4IuBzrhytvPQv0wpcLIcKmNaoIFmch7UomiQvaTLFI2DTtxVnJrA4x76WfFs3phoagxQNS4AMhaWU+R2iouEnjLcWkbjr714osWkGoG94JImxjhSv2ULWJkRQnrjfVtQcrYKtA2tefEkFNPZpiZQq8F4GKsKTSCC6kM6KPWzkB+f65jsQ193KZpaqgwmp+v6Gydj1bv7b5BV0fZO7EepbyFXjcRu+6RsT0hkLn0e6HG9oq3eVz4ehSQ4Z3gME06ZsG9+Og6iAd4WgGwESwHX5piPeXJEBEW5+Tprb2/V/iSXSBLmhUa52MzsazyYh15WJJualM08tPgchn1pmi84F9uekEWP5/MORz7DJupts/Dx5KAqvmkF2s7TW+JHqYulomxSJ2tqv0/rMFF0oDSGiVVp3PNXd0OupAVROXejaHMKIn7LFYq6Us7PNxIODmFpq8IhrI/M6f9BIcKn+k9QcBXRDWMPciaC41JnzM+eK0n99x+aUiCN5lFo7odEKuvn7TRK2Ts+yHT085DLjOvRvutgEJEFQdoT6L6QdnUK0/k3Ws9iRXDmsTX0ZNr63ntiOXnWo5Ychaom9HLeVef2NWnEdbHswrOMvjI3HKxKDVnNykqgwfLhr0BCmsU7q6Jcu+XjE4a1XuP9PwpdDVVCKazSqSP8LkcgWwBIOFleJ3pzFI6vM0eZa8LW6uxBX3F1vbOIXNrxyJU2ane3fK8v7OIL3Dp2g1BObrQlGoULiZKn4RGsb18GCzgXbrvJv2FYhiuBEW6jiR3GPl43s53Z/fxEjt7Pan0SrMNtjiQmO3Xf3grMAQ5v70sKb4PIjdP7W5/gUDHjYnJxFSDCVnZKK+0LCLrAPtRA7D6vZZTZU8jQT2KZUAAyEGAeyb6JtAolUvVlURiFw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c57af459-ae52-46a3-c0db-08dbded25c83
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 14:12:08.1144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kh7WC2fEA4+UudnivJPqvpjlOiAE8wpESEchSjucqSAblKy8QjSRcHwhe0MTAMhN27RNNR+hpeDN6yEp1vtLpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4651
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060114
X-Proofpoint-GUID: LYChQJMX1UqMXn_KwxtoFdQ04MtexLE0
X-Proofpoint-ORIG-GUID: LYChQJMX1UqMXn_KwxtoFdQ04MtexLE0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/11/2023 12:59, Marek Vasut wrote:
>>> drivers/scsi/mvsas/mv_init.c | 17 +++++++++++++++++
>>>   1 file changed, 17 insertions(+)
>>>
>>> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
>>> index 43ebb331e2167..d3b1cee6b3252 100644
>>> --- a/drivers/scsi/mvsas/mv_init.c
>>> +++ b/drivers/scsi/mvsas/mv_init.c
>>> @@ -571,6 +571,17 @@ static int mvs_pci_init(struct pci_dev *pdev, 
>>> const struct pci_device_id *ent)
>>>       rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
>>>       if (rc)
>>>           goto err_out_shost;
>>> +
>>> +    /* Try to enable MSI, this is needed at least on OCZ RevoDrive 3 
>>> X2 */
>>> +    if (pdev->vendor == PCI_VENDOR_ID_OCZ) {
>>
>> PCI_VENDOR_ID_OCZ means 9485.

I meant chip_9485, not the PCI vendor ID. See how it is used as a lookup 
to chip-specific parameters for multiple OCZ and MARVELL SoCs in 
mvs_pci_table[] and mvs_chips[]

> 
> It does not, see:
> 
> $ git grep PCI_VENDOR_ID_OCZ include/
> include/linux/pci_ids.h:#define PCI_VENDOR_ID_OCZ               0x1b85
> 
>> So how about enable MSI for all PCI device IDs which use that, which 
>> is all OCZ and MARVELL_EXT? I could not get my hands on a datasheet 
>> for that SoC (could you?), but since all previous generations 
>> supported MSI, I think that it's a safe bet.
> 
> Nope. I only have the one device here.

Checking whether the PCI vendor is PCI_VENDOR_ID_OCZ actually covers 
many PCI devices, but they all use chip_9485

> 
>> Then, if we do that, instead of repeating this same vendor check, how 
>> about add a new member to mvs_chip_info to flag whether we need to try 
>> MSI? For example, it could be mvs_chip_info.use_msi .
>>
>>> +        rc = pci_enable_msi(mvi->pdev);
>>> +        if (rc) {
>>> +            dev_err(&mvi->pdev->dev,
>>> +                "mvsas: Failed to enable MSI for OCZ device, 
>>> attached drives may not be detected. rc=%d\n",
>>> +                rc);
>>
>> We should fail to load the driver in this case.
> 
> Wouldn't it be better to give the legacy IRQ a chance in any case, maybe 
> those do work on some of the other OCZ devices (or other versions of 
> firmware) ?

Then according to the change here, we would always call 
pci_disable_msi() in removal path for OCZ, regardless of whether the 
original pci_enable_msi() call was successful - is that safe and proper?

Thanks,
John



