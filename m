Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E81C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 16:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiKOQ5H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 11:57:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238500AbiKOQ4y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 11:56:54 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769DA29345;
        Tue, 15 Nov 2022 08:56:52 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AFFv0ZC008985;
        Tue, 15 Nov 2022 16:56:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ZTETUm9k2SjpjKP8ES1Wr2YJB9qn/ow92T9cr0uVBOM=;
 b=hfQGvZrRiYy/gYQkGOGQNJsoK/hT83nY/Fkjld8ZtxFLZiNin+xy3V07OvkrL1Jq9/lb
 z04XCEVR3DmS+bh+nbU158S74ZVl0y04j2pcXJ9ZYIDqIaoPSbhzFG1C243Gf03LMZ/i
 gPCzEdOIXNxGgD6FCMy3VHLEmb39JDf9QadGmeoNxFNKlePG/nIRXZkD84uGiJE4eMH6
 /fLOXc+WZpLLyKOs8/wQrw9MJzm6gJsp+thAHUvoZdSkw6NDR3m5fJs8vhKMosAYkAw0
 pbRnmtO1HoeTV5ziyvP2PA78L7OLZ+SBm8uWFR5s7kM6p1c6qyxO8mOYZpf+s/MDyTzn dg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kv3jsj22s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 16:56:25 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AFFh9Hr031897;
        Tue, 15 Nov 2022 16:56:24 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1xc3bv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 16:56:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bEUG5jK9cA20eRn0HuMtS4P6g7Qx6EfInbsVhLn+D5r0LbQwrkYUhv4Wzasfq9vQrwdnFe/1dsZCdl10TZpLZPrVILh7qlvZKg6rzuQ7n8YTd12y5eEAd+ColYKuCU4DknB+BdDZV4/u24aQ/bH3ZytyXs68hW2YZ5mi8Bv+l5liOuucBUiqCs+5Ev6LR2Iyr3FfZ7NOH4VqA7R8KGaqNTUe0B8D6szEFhoGBnvQAdHtfsol8E6qwz79IY6RW5nr7OojZb4ZRpFwkISJ9+nAfRKJ9YSEGWn7ZSZKE3a3td9xaawNyhvPEJ6V21O+ZqCrr/1dPZP1ranylJCR2xeEZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZTETUm9k2SjpjKP8ES1Wr2YJB9qn/ow92T9cr0uVBOM=;
 b=LmGn3Jbeqiabzs0Mm6N6URdcBoKAQWuci6yaICmyw7cEkw14QiEuutLYz8ORzBOMVYjyFbWAR1Q2P06bzHUpVgUu5LpUkc/JNcW1pZHSeA2ojV7rx+B3dxseEwTRQlgHjAytwiM9u9pAXLkF2U+3cvG9DQeDuPTQktrrTlbf4f0bw63zodqm4cvKWUCt0PkczqltfFDFAHb665W64xNSsiByLrsWiqVpqEQkXlpGedU7gb/kFxcehRP/mh7sXVAMn2vjUU6JVVv7fjJDfOg809qZIkb1A8pSfbPhApOQR4V12TdS9WkNIaeqrNEjFpmk5bDb+2wVgLSmY7hymTMjOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTETUm9k2SjpjKP8ES1Wr2YJB9qn/ow92T9cr0uVBOM=;
 b=UjQaH/5y6kPqsPMG+36lXVDXWtzP/74Z/eL0Yk9jlcmQuXgvO5O63LI1E2niKzI24jZhzz4GuGxKlP4GlJCUqHKlGsNpxmL5uIp7YDcQ9Fd1pChRLQVA+h+N1BbA4Jf2hn3BJuxJMj/qu11EQ/WcQ+beHxVKRiCp9Jh32mJZuYI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6669.namprd10.prod.outlook.com (2603:10b6:510:221::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 16:56:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 16:56:21 +0000
Message-ID: <88d5cc68-cfad-881e-891b-baeb3dbc04de@oracle.com>
Date:   Tue, 15 Nov 2022 10:56:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 3/3] nvme: Convert NVMe errors to PT_STS errors
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     kbusch@kernel.org, axboe@fb.com, sagi@grimberg.me,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
References: <20221109031106.201324-1-michael.christie@oracle.com>
 <20221109031106.201324-4-michael.christie@oracle.com>
 <20221109065338.GC11097@lst.de>
 <8adcb890-ec08-cc75-6e1a-2b8dabdcd640@oracle.com>
 <20221115091403.GA22594@lst.de>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221115091403.GA22594@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:610:b0::10) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6669:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ac1cc62-2717-4bca-4d7a-08dac72a52c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M2R6afGEQhaOip59eH+/nf4Y/OQIhBlgiS8ILMW6Ff9N8583ZslMLQL0an6eVVecvr57voWKhUaWGfOwcrh+YL7z/7osFOhZMkaFvtdatI1qr1Bb0qUtoTLLr3ED+sLaxlXaaVddoe6hmzCH/dvuFX8vOoWeTLILisMkkZufNWsaJNuYhdTZLcFPooY5/X3pEcihWEcfV5VZJFLswe8u2yQjmANmshGuybwhO89IYKPg1TNTBGQSz5Nj48SSRUvO3yniedjebM9it27ypTW4hsYKfynCWYS1sq1EFmHqbGZTMNsOOSsKASuErnJVHjIVMQS4cbqJ51s6eb6//27gReo8QEKa4vlzqhIUwnXBMe6TJo3vxklHAyr3xDRKmMDOCMv55CoYWxiBSGSXmHKMltX7wbJ+yVABkeM1bb9DlKDBpqo+82tcW7ih41r7eKuJbcSXKMh3a+y8WNY49+2l15y6FCbYHAhREL+WBApFHJCMrmGSYp5Jo1hqXwnCz/29HYidb2wvjCEeNjp5z+JzA3fskX0iVaCbhwC6yT5VNjvNDqPLO3iiuJ2dgG8I7hsJLwE6TRXydkTOIMfytPPyYTWSYaCLme5oskuQVwa1wzHITqFkExVw387DdWL3fTCVDBaUzgroI0+pWNlP6w+jaB4+fFsCnjxW5YLHL59VCYWK7b005744+Il/uqhDP0oHHtoBu9h7+c9CSRLBjDWgP0yyCifFsxRd1DSPBYo1JR/ZLbmc/ZrJNwRQdCnYw37FQASYjTezFC+1RBX2LTOGdtEsj+x/U1Pp8eU9+GRnIF8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(346002)(39860400002)(366004)(451199015)(2906002)(41300700001)(31696002)(6512007)(86362001)(478600001)(4744005)(186003)(36756003)(38100700002)(6486002)(8936002)(26005)(6506007)(316002)(5660300002)(53546011)(31686004)(2616005)(6916009)(8676002)(66476007)(66556008)(66946007)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REU4V1VqWkxUQnBQbTVSS1I1UGVKTFg3bHNVL2FYbVBBbUc3LzBUNDQyK0gx?=
 =?utf-8?B?ZlZDa2JveXFwQmllN3BiOFgvaEpLMGp1UmdTcStzaWUrOEtnK2kybXU4R0xR?=
 =?utf-8?B?ZDlTTHNsZWk4L1JjOEIrbHR1NTc1K2RPSFdoZkJleXhUNlE3alhuQWxTRXpB?=
 =?utf-8?B?ZzlEOURlTm9vL0hNcVh6eVdrNTBHc3FrWHlpUG1YV2ZFMDQxMTl4dGxsNXcy?=
 =?utf-8?B?MnYrcFpXN3VGVHhUelRadSsxc2hUZGFZTGZwNHNPMTZZb1d6QVB1VmZOaXhY?=
 =?utf-8?B?MmtlM2pVSUd3SlNSbTJYbXdCSEVDY3VFVXpGRDVESXVObFlZSmtBNU90TEY2?=
 =?utf-8?B?a2k3RVFNNjNQYmIybjh5YU90NmltZk9xWVgwMDZDZEY5eFVRV3NxSytLRWxs?=
 =?utf-8?B?Uzh5R2RuVVpKMnhmQ29QNFQwblNCYkp5allQeThwMDlLT3BSVHhNeUdLNXNq?=
 =?utf-8?B?TnU0SHcrM3hzMVpPZ04xWXArdGxKU2RPamxBdmNjNHhOaFlENGdlT1lYUkh4?=
 =?utf-8?B?TWtab2lKNGZYTjQrWktBZ000b0xpWG5UNXA3U0VDcVZiRTB4alZUQWZPR2dh?=
 =?utf-8?B?S0pvVUhJa01GUkxoOGtFalppQVAwaGg4aThmZXVud2c5TCtIYzVUN1FVSXlu?=
 =?utf-8?B?amJBTzNxU0JpTFpwYkJkOHUxb1ZZdGFFMmxSZUk5QUdpQWQ1cHpJNnlxQzJw?=
 =?utf-8?B?c1JVRExBS2dwbjFaYnQ2VUhOUEViQU4yUnptdFdsZUZtZUI4TW5MUmxCd2ZT?=
 =?utf-8?B?YkFYT0FwMWVXbnp4ZU9zZkhBRGRocExORjBRdElhOWpMbWtNU0JkSGpTMHNu?=
 =?utf-8?B?Rm1uNmNQa2FNWmVaS2lYMVFqUlBhVlZETHYzZ3BnTHNvLy9sMFZBZjNwSFdn?=
 =?utf-8?B?TkE3UzZQb3NzaDZkRG5USzB4SUxuWHdDS2FxSWhJd3hMdEV4NDNyY0doTHlZ?=
 =?utf-8?B?QUZrc3hTWVNSNnNxdk9qYmxlR1BNazN3WlN5Mys1Mm55Z000Q0kxU1ZjYjND?=
 =?utf-8?B?ZmJrVWFnazhXZXVoVXdoK3U2VzJvQ2d1S1BUdExlTndmZlZkMkxVeTNmYUg0?=
 =?utf-8?B?ZW1oTkZIeTV1Q1pobGdjN0hqWWpFSmlxVVVxZUxHRndtcXl0MzRNTE54dlZW?=
 =?utf-8?B?WmVjZ0xOdGdqT2RBZmJvUktNOGZWV1ZiNm9JUk5nK0FwZE52Ky9SbTdrWHJh?=
 =?utf-8?B?WkhUZXJKRVBkVGthbnkxYlNHdnlWSFJqd1NORDEySlhUSGNSSVpOLzZ4U3Fy?=
 =?utf-8?B?VGNnUlBJUW5XWGFaSUFONVNydGVET0pSLzBlKzBvVWRiM3BmL1JGSmJ5Y2tl?=
 =?utf-8?B?c2pFYVllbzN0cUdFbGhhd2tvTmZPdVlJNkl2WU9kem00R1NNSitCcHJFdTRt?=
 =?utf-8?B?MGsycTV2SkJqakU1TEpoVStXNlpSTDl6d0hhZ3c5TjdTdFg1UnhZRFlDSXRQ?=
 =?utf-8?B?QWw0SDlET01KeGVaWDhLVnhWVU1jRUpSdzJ6aTg1VVEyb3V6RlVvTmpQYjZJ?=
 =?utf-8?B?akVObTAvWUdPTVp1MWxrek80bE1nN2FYQ0FpNmFGb3dkTU93Ni84aWRSK1p5?=
 =?utf-8?B?OW8xazNqa0xGdHprVms0ZlNMZU5PTlNleHp0S2dKeGNBa1p6b0V6Q1B0TVBo?=
 =?utf-8?B?WkhPUm5nd1hnUTV6WVorczRxR2lHdXpQZ1FIL2dpMDU3OFJMSUpmL3IwTDF5?=
 =?utf-8?B?YXV2UkxMbSttMFhqVEZzR1VaRWh6U3FoeHlQK0lsUkVneDJ3Qzk4UlRBUjlu?=
 =?utf-8?B?WElYK0NrYzljS2wzQVRTdHFhSVpteHdLR1JtYTlxSkplcHNoR0hYS3UyaDll?=
 =?utf-8?B?V0tTQ2J5ZW9BNVVFaTRwRUJ5NXNsM2lpUjEvK1dLM3RoOWpWckExSEhkUm40?=
 =?utf-8?B?SU96UGNCL1dKbzV3M2pVR1dESFZZUVZ3b1czWUpXNEhCV01YTVh0Q3ZieHFp?=
 =?utf-8?B?dEIyYWx0aUMxOFFsMU5WZlBRUmFrdmMzc2lvMFpjZkhmaDVMTThuNXN1aEtN?=
 =?utf-8?B?Q04rNTdtWk1JY2sxbHJ3a2hpcERlT2dseW9Dd3FXZnVVcDFWS2Jmb08xZ2Q2?=
 =?utf-8?B?eXJKTlNtSVMwajBzTlpHVzhpZ0lGRGZCb01iY3hwSUtQNEJENW5qL25TbUJo?=
 =?utf-8?B?MGliaU9EeTFyRXNFTC9Fa2tYeVVPeGlnUDlWcUE2clpCWlgwY2d5a0xlQXJ3?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?OXEzOTR4NVo2bXJyRzB4Zno3WDhKVDNQRHlvdE9EVWo1aklPT2kvQi83TEN2?=
 =?utf-8?B?WWZWN29hbHZPcVZUdmMyS2VRb3hUVWwzNHNtL1lJb0crVzZwdWp6M21kR3ph?=
 =?utf-8?B?d0NxZm0zcDFUSTByMFVrUDFUNVo2cm5vWG1oN2Q5SVl1VVMyeFYwYkx2eVNU?=
 =?utf-8?B?SWVZZzhWTDFzanBMWElLYUR3cFp3bEVOZnhqR21vYWpBdGUwYlhnWktTSC9k?=
 =?utf-8?B?NU1WdThZQ2k3bkxVczh3ZkxLWVhJTTBEYmdCMDVRNVpwcWxURGlReVd2N3Az?=
 =?utf-8?B?MHllMVpnQ3E1VWRwMWZSNmIzTDI0NHFPcWFGdjByS2F2MlJQRWZlWnlHUmQ4?=
 =?utf-8?B?R3MxOHZTbUdVekhaQWdIOG9iMnJ3Qld0Y3UrK0JkbzVLZUlDYURTQmtQVHJv?=
 =?utf-8?B?d25vNy9yWkFCdnY5V2lZUUNMZjFqS0F3a0ppQ0ROcThXZzM1R3VlTEpwRjkz?=
 =?utf-8?B?UmRMb1dyNFdnNDVELzk2VGFwSmE2ck0ydWZxcWdsbUZzbFNkZStON0VKQ0Zn?=
 =?utf-8?B?VTVDdE5rbmxEZU92dEJvTUhYRWlkZ01sVG1TWEN4L2o5eVM0N2JWRkJhVzAz?=
 =?utf-8?B?U1RwajNiVTVHR2NyMVl5Z1ZLdlNqSlQrcTRHTG5ucmJ5cUYvbWxYWXFDTmZV?=
 =?utf-8?B?cUIxR29VQ1FHZjhaa2xmTEpRY01rREY3NXFwOVBFMzZQRWhwbmtuSWpTRjh0?=
 =?utf-8?B?U2V0VWVidWxrSXFxSExsK2FSOGhVTFJJdmpzZzNseDVVeXFWZ1g5a2wzSmtS?=
 =?utf-8?B?MEVpc3ZIQlZPWlQvRjBIa1ZYczZLck9rM2ZUUkhzTDg2dHNSeXFKV2MzaGJY?=
 =?utf-8?B?VTBoMTIzUTg3dUwyenZGQkRLR3dzK0NjSkVLZ2x6eG9LdXZJZVRhbzlFNWpt?=
 =?utf-8?B?Sy9adG03RUdBNGdsNktFcytFUFFTbkRBQllSUThwV0VuOHJzSll6aTJidGZx?=
 =?utf-8?B?NkpwS0N5ZTBybitBQUtjRXJFb0NzTFVnZzJQOG1HcG1BN2VNQW9XSHQ4SW9h?=
 =?utf-8?B?MHZRb1AxVlR4bGhEcmtFY3k1MWFla3lJQ0krQnZpc1ZHTnUyTCtKM0M4QTBD?=
 =?utf-8?B?VEFibVk4WnpoNmZzL0JzSXV0cFB3VjQ2Z0l3dXYxK2tMc1ZSanA3NG1sdTh6?=
 =?utf-8?B?bnhMeUhEdWIrZ1BENndFNWNZK1B1S3dYYWtnd0R0OFF5NVd6WFAwdGJCZnlU?=
 =?utf-8?B?R0x5bjczM09XVGpFV29ZbjI0cnc4QnJjMllNdDZYZ0xyYUQ2RFY5ekFOaVg5?=
 =?utf-8?B?NjlPekFDbFMyV1lWclp5YXdtTXJkazBydHBMTmFvVldCbnpOUDF0eFFXdTJn?=
 =?utf-8?Q?U282UhJ5c9p8VEgdq5Y1H8wdgoFLifY/Tj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ac1cc62-2717-4bca-4d7a-08dac72a52c4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 16:56:21.8903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9+wMV0vIIiYheJxSvtPID0eu9fO7LLr0Lw3BS1OS2y0HKhgTfg2D4kRDGdFGmMNuX9u6Xt3G2FMN7+dk/WfdSAKF/OnYI/F+/LItPc+/+wc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6669
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_08,2022-11-15_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211150114
X-Proofpoint-ORIG-GUID: cb-aifT3K9mP2BEiaci8UWDwCcPYIAb0
X-Proofpoint-GUID: cb-aifT3K9mP2BEiaci8UWDwCcPYIAb0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/15/22 3:14 AM, Christoph Hellwig wrote:
> On Wed, Nov 09, 2022 at 11:20:07AM -0600, Mike Christie wrote:
>>>> +	case NVME_SC_BAD_ATTRIBUTES:
>>>> +	case NVME_SC_INVALID_OPCODE:
>>>> +	case NVME_SC_INVALID_FIELD:
>>>> +	case NVME_SC_INVALID_NS:
>>>> +		sts = PR_STS_OP_INVALID;
>>>> +		break;
>>>
>>> Second thoughts on these: shouldn't we just return negative Linux
>>> errnos here?
>>
>> I wasn't sure. I might have over thought it.
>>
>> I added the PR_STS error codes for those cases so a user could
>> distinguish if the command was sent to the device and it
>> reported it didn't support the command or the device determined it
>> had an invalid field set.
> 
> But does it matter if the device or the kernel doesn't support
> them?  The result for the users is very much the same.

Yeah, makes sense.
