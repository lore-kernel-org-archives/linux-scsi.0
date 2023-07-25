Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6567EC0015E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 10:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbjGYKaw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 06:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbjGYKau (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 06:30:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E441B3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 03:30:49 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36P7oc7p017262;
        Tue, 25 Jul 2023 10:30:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=hiiiQTyDKTWhe4i2FJyYvMx2njIEfuwfv4k7tOJTajM=;
 b=jIi8aJhisi2TT576cSP+qUG44GwzfXbxwc9jFiDPDonsHctA7C05JIQ6sQFWPg957MD5
 gAzAu9uJflwNZ+g6itKsI3x8o09aykfZLaiNAk40gBqmCf3vOUBZqd5jNXUkwRatgfeo
 nl/i4HUKP3u4Z7wrOPKrB+BuJFj7KFngOdD3ASSvL4ddMwkBb74ME6S6CWNNrERGFunu
 0HG8G+fv4ZqN23/6lwGaQ903hdZYD/qZX1whbqVg67CjhAL/IJt6Tf3M8rNUq/PozuBl
 O26m7pfB64bUKgTk6U7vLxxkKtQkHkKhQheSZBm00ekjRpxtVyiAeZ1Ww9cp3zcwMfgM ow== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s061c4t7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 10:30:42 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36PA90aP008594;
        Tue, 25 Jul 2023 10:30:42 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j4juun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 10:30:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xe5XMGjQDV4tcFDaxTXpNhLK1TL38gjUtGyOIIsnXvbQIAXKn1n1NlK2a8iiT/6KIXIrB69MxZeqzxVeLIAf7x0Gc1edDZSNlG0fQ0kpRyA62YZ6/Z3Io3a7dTwDWQ5vLfIQ8MGYfyjaz0qjQsvTsV1cbdafBn8QPAhpZownHXMd/u1XnuAOiuwxaM2uEmQsr9XbfP44VCrCfpbPocxlLEo5YDjaGNHSwI+CGr065Z3iBnu0Xsp+XM8GwmK3WFq3sKY+P8bBG0Dxwrb5RxjoOEtrCjlNE3ON4urw+VAu61nvltQCT5v52sAr95MruAkuQYKTiMOXXHiGFKj176DjAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hiiiQTyDKTWhe4i2FJyYvMx2njIEfuwfv4k7tOJTajM=;
 b=c89jWr+46Uy+zsW08UF3E1m/ShoPbw1RBpwGuyopFdO3CIRztLEmZv5RnOezU17MuUVYwSR0On4FUtd6gmtNq09eHp7ro2Nw37iEoOZ7bILhoAj86qtckPnjL4118qzhOG6YqlYip9hnfvxS7hjvQ+vvuy+kj6tmNwTFy2e9czbOkV2Q+M5GgSX0pyVmSxkBPxaEwDGZS3UI82aQ7Vro5N+tLF11AAnVUHjDZC12VVia8dRmNydpZC5Zyt0psM+H+yL1ti7eH2Cwn/dnjf+l6+sjc1T0N4552THHUi7YMbCjCDRAu9evaqLTOn4nDoMzTMoOXVyCnBRZ4VrMU9Fw6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiiiQTyDKTWhe4i2FJyYvMx2njIEfuwfv4k7tOJTajM=;
 b=I3OV8WBKQrdbnKP44ZCABNtIMCqJH5s/rKx44xJsH3m+t4IVfkkv5vHvstzQF9QPlR7iEEX6L1vWoXH9dC5cXTRcTRJNz24GkwZwX3Eu3yghL/SfEs9bj5DnZPADocmmjAnOS3iow/ePCnKkOot6uBpMOUiFMw+tc3sH9vREY0o=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB7643.namprd10.prod.outlook.com (2603:10b6:208:48a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Tue, 25 Jul
 2023 10:30:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Tue, 25 Jul 2023
 10:30:39 +0000
Message-ID: <c3091788-252a-8852-17d6-ac7122ac853e@oracle.com>
Date:   Tue, 25 Jul 2023 11:30:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 19/33] scsi: ch: Remove unit_attention
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-20-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-20-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0268.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB7643:EE_
X-MS-Office365-Filtering-Correlation-Id: 5313de9f-59ff-4daf-02cb-08db8cfa30f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m8xjsXHBBpgk3RrorU1bKxqlbCV71cvpkAZHuQ9dtbHxZ5m34iiIdg6l7kg3UfLGomCe3L6EeIN6Lc5chB+tyIBgz9nTQE47NKiIXrLD3GFdcTJRerYsSJvEfZJAYRClnMSuLQEYv+2xwjJnF6s/Jpwha2e9Y1cHJIdPDaQqvOi42Mpz6Y5nA4tCG1iVrBztwZsWs7XIGSi5dOsQX+aaTd8+bLdqWiEYp1xjuduJLlyJ7Q+2oxk4rY3gYjz1U9/sDvNVKmK23uG2/a76of27i6S17pE6fZQSlb+lEicc0394+j4V1FOtMJvAmbHIarITMvZ/AXXugMvIsanRP1HOOfRLtVKc7Ge1O9ond4RheBmV/D+aD/AENTPf07DLEKBnVMIW9kcvPNVVTAG9JjaGuvWWLk31XBO1n1+1KlcXFPdjVwzzpqGXHGcEH0/c7WIouIkufXOVQj3H8B22VhSEQoFSPT5g5yPGhVOutaEeMp+wLXoNj1+6JAp8cblm8oDuomj51NpklJJc2JhCv4N5LgujtTIMMLRMK/yTjoTD4uFk+GLhOKVEZ+sQT6dh+gwVjDEFb3eoYZi30XDCcB7OdqvoaTbK1pZNYySzJYsqVwAOMdNZ6TWdviIsoIXUSWUi6m3Eadr9heL8K+5wXGJN5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(366004)(136003)(376002)(39860400002)(451199021)(6512007)(38100700002)(53546011)(2616005)(186003)(26005)(8676002)(558084003)(5660300002)(41300700001)(8936002)(2906002)(6506007)(6486002)(66556008)(36756003)(36916002)(66946007)(66476007)(31696002)(478600001)(86362001)(316002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2F6UWpYOGxjR0F1MHVRNHZWWlhpQW5QTHRHOFZHTXBwbS9IMDdFUktUY3Fy?=
 =?utf-8?B?QWhheFFSdlN6Y2h5anlFc05tSHlMWlBhUkxydW9kTDVXTWdYb24xeStyeS82?=
 =?utf-8?B?ajN3R1lhZGdlZHpyTHd6NG5OSGRxazRRY1BLZHBic29NOTRHK2tvN25nUXJu?=
 =?utf-8?B?ay83bnoraFJZOEJTanVBRUdsNlgzVlhwcXNUT1p2dVdjYUNXWllTUUxwZ2Zk?=
 =?utf-8?B?dnhpcTNkKzBRMDl1YjdGcnZKd04wYytFK2JEZXRPWktlblVBa3lJUFJwUjRN?=
 =?utf-8?B?SlR3SVJDeFNtRmt0R0c1aDFsVE9YYmRjQnB6cDhSOUtKSE1wRys1RXkrbFpv?=
 =?utf-8?B?Q1U1cWdXY0dmc2xyVTZCTGtVYngyNFU1Z0g0L2lvZDBNOXZ1Qlc4ZmJsRzZN?=
 =?utf-8?B?bncwWUF1K2FEZ3ZPTFZFWHNFNUtuZ2RmWFNVeGNGMG1ndFRnSUJuT25zVVpN?=
 =?utf-8?B?VDdPWXphWFl1L0lHUVE3Rm8yYm4vaTJsMXo4eXdQWjdYU3NwejVvdG1wbmJx?=
 =?utf-8?B?VnhCVGZDMUFFUGxZSnEycDM3LzlYbzc4Skt0VWlpR2dra0sxU0FBWUk5TStm?=
 =?utf-8?B?VWFUd0p3bW5wMXRSQ2lHRGwwRjl3c2RmV080aGhlbkpISU1UNE10VUdvM0lJ?=
 =?utf-8?B?cyttTjNNMkxUWEllNlp1UFBhUzNSRXk5ci81MFhoK2w0LzFleTJYTEkvVUJu?=
 =?utf-8?B?bzhkdVU5Vk0ySU82VW00V0U4VXF6elA1d3VnZWNyc1VReExaMm1Da0VwV1V6?=
 =?utf-8?B?eWlXR04zUmZCWHl2bkR4RlFBOGI3RWlrTGo2dUpSYlNnMnhhV0xjUDRGR0U4?=
 =?utf-8?B?TldqeXpRMklTaURRY21UbDRqUTY1dlRiaEYrWWMyRnhKR1hVb3dLdldNUHBY?=
 =?utf-8?B?dU5tcHpuUm5FZ0VsdHpOV1pGQ0crTExpQWE1cjVuU2VseFBWdWNpYUtYclhh?=
 =?utf-8?B?bkg4V2EzczI1cHcxODc3OWlYdHZzZXZlWUFiL2FFMGxlcU4zR1Y4VTJVQ2Jr?=
 =?utf-8?B?USttZzczN0I1R0VoS2Q3blZ6RmZFQjBjcGNDbElNYlJkT1VzYnBCTjJxMUx3?=
 =?utf-8?B?L2RGQWQwWVVRd1g5RFd3UTBuNmR1NVlheTBpVVdmTWtldTY3aUNvUG9kUGZa?=
 =?utf-8?B?TFpZZjJXMndneXJWWkRveGdKUWkvNGRKV3hyWHZ6NmZwUUJDRUtUSUJEODVD?=
 =?utf-8?B?MmVZeDFBTi8vNi8xN1JmVTVGSlg0U1JJWk1FdWxyNTFXZkFDK0NmbmxIMnVl?=
 =?utf-8?B?TENMRXpNNFVNbnNselcyUjArQ1k5dE9BNnc3OGZZT1VvcG9UZ1lmSmtuUkln?=
 =?utf-8?B?QVN1R0VDeC9ibWFqRHdydXhERlJJS3lGZHRDelF4bTlsakNmaWpMSmg3QTQw?=
 =?utf-8?B?N1ZQRmdVWS9aOUVKWGRKRDVHQVEyaXJObDNYd20zRHhmditKVXlSV0JTdC9a?=
 =?utf-8?B?cjR4aVpxQ3RXK0pwVkR4N2R1RVlja1FlRHVqVEVrZlAva2FRRkZRbVFueWI1?=
 =?utf-8?B?QjMyZml2YnIzMlhXU3E0SGU3ZU5uRlY4MDJFQnV2SVJhWklRemFoM3RNb2lp?=
 =?utf-8?B?Z2hxQ01VamFmNHI5UW5TWlk3OWJvS2c2c1N0K0s5eUF0M01LT3BSMEs5TU94?=
 =?utf-8?B?WWU0SkdvcktBZEZVS0xKVWhBcTJmMjFra2NmQ0dkdGNyTVJZMHVidVBSdERl?=
 =?utf-8?B?c29keER2bmYwQlBZcEJET2JCUm1Ldk51VHRkeVluTEpTUXJaMmhlQ2tVYzhI?=
 =?utf-8?B?Q0cyRXRPTi9IM3VVemN2cHAydzdGN0Y4MGZMV0htcTRwdFlHZjZNbmFWVWFh?=
 =?utf-8?B?ZDJSamo3MGczVFA5TUtrdE1Db1JqNzhqRVBjd3Vndno1eTZJQUxSWTZZTzNp?=
 =?utf-8?B?dEpxRWh4WGs5NGJQY0pHZ1BINEtiOGg2TEJWNGxMRm1HM3BQcXh6MFdxQ1l5?=
 =?utf-8?B?NkJtZk1pZ1N0U2o2TGJRYUl1NHIrMXhZSEFhN0FWZzZ0Mjg2VXRyWWRFY3BR?=
 =?utf-8?B?WXlyWGp5QVg2NXNZZVVnV2xXVis4alcvVGorWkNlVnlaKy9TdVIxUFNMV0dW?=
 =?utf-8?B?S2tGbVB0dy9VTFBqYUJkM0kxbzh5dVY2UGVBck80YWJET2h6RTh0QUdvbGh5?=
 =?utf-8?B?MENEZ1RQWHQvMWI2bTVoMGNzMnc3NjAydTEyWDVLUEE4UnAvbVh2MG1sS1I1?=
 =?utf-8?B?a1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: JPfn7Sp+DxKawRDWMH2R6YQRHIXpeUK1FDetmkaU5ce1PRrdhAU+/OrkThEfwESxlurV+izCOw7KknLLVbzjtga9516iv9lNXR0Wlc8Sn6D5cB/7KG1GSmTrGUN1BMrQbPcdPv7yUYyjsshcjlyw8bGoViPG6xeW8s+aC0TasljDQ34E5EAe0frz6LJLeRflhOQS/oaY7iXQ0uRzDCDn+xoxTBwBFYo+ZtmEkJq43thta20eeaTx+vz+CaP0uisiklbirV5fC5F77InOr81x/Bo6aS6CMc4oPZZp4gaDlRG2bU5tFWvixJsvle+8odTCFTQUy8qpAZ+OkWmmlmgOy74g6bKVbPQYMtFgHsCCvXFvsAWyAVTGPa/NA+j92XnwpPTnigecT2o98481o/OW+U9rXAkEBOy/4UG10KHb2RbjOBKgqyoEGu3tJkOwrkMCO3jSUAEHgVzf8UH1Fm6h0MEYPzgpGL7lSJrOwuWOfHrd1+oUsPwJm0Oxskwbi71GC01wvrTc9A1YquL2nWXljpeCatOny4XNiWIibieaAKaFmy0HeT85prSeioC/mINrxmVVmJiYD26RBcFHcVtoB6vjjCo3tlPnuVF6lOoxe4GxYk8C3bsvOxTdRs0NGVszmT2o3LVYsm5YvIFR+1fI4+WlaPjvwyUN+5UzEeKSV1KUidpz5sr4STtpdT9Mqdr7t6CUU/zCWt9hpJrEue8EHZhFYs95kjCq+te5PVFSE0dcAkbzYEzZP0MosVwwjpanSspzC8Fv5NOu3CLd27cQ953zv7Bfq0aSWKEHKZ/BH3cLCbQdc9s8BhIFhVojy6dTxfOyqo9XLjqzDkuemIqRuX0FbiXCvXXUS+BY6oSrM8lbDdjK6L+YSmmAu6dtjtSg
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5313de9f-59ff-4daf-02cb-08db8cfa30f4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 10:30:39.6605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C2B12+w+9RGT4bAupeKVu4Np7l1zKRgefuVol7QZjTOsYs67/uTtASjFgVEI1soeU1kvnmWF/UXy52Hv+heX0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7643
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_05,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307250091
X-Proofpoint-ORIG-GUID: gkR-ct3TQo0M7-XI3NScolNo_nKCcRyZ
X-Proofpoint-GUID: gkR-ct3TQo0M7-XI3NScolNo_nKCcRyZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2023 22:34, Mike Christie wrote:
> unit_attention is not used so remove it.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig<hch@lst.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>
