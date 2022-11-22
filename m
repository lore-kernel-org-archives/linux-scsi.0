Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 820ECC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 16:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbiKVQQQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Nov 2022 11:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbiKVQP7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2022 11:15:59 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3595356575
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 08:13:45 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AMFpDEv000559;
        Tue, 22 Nov 2022 16:13:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=EFSvlFB6T4F7B7LYfbYMWW+PYtNZ9Z6lPDLjB8RcRrY=;
 b=aoef2b+533lhl/pOwFub27aPeMu4kV+Lx5S61P0+5B98gmByu40P1xJvpHYJkWUEGrEH
 hKe+wDoHbT+NUXO/CQbZ5Aa85qRwT87MCXjBsK+qQhlporNFIsc5RQb6TpWHtITHLz1x
 RDbRls68JBKIL+e9U1yn6tM2Z2HUiEpWYWXtA3tZiCjGDrTXO8v+psJRnJqA6erWow5/
 WJo4acmIJCNZ8mfl2/iTd7n9P38DBl/I4W7vbaYubvmJSXs4ptMp721ckeNq80NOxfJZ
 QAibWz2FLGBL9yoTL58ppDIOW1ThgxuCgNx86ssWr4DyxFHzKZwVQGy8plgLEuu0Ebd3 Og== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0gas2wnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 16:13:35 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AMGCvsa028941;
        Tue, 22 Nov 2022 16:13:33 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkbd1qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 16:13:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RoR2RqeZfLViHJdnP0cxf+2XOgHHxXKCpLlWiOdqg09mmxw1+Ti2+gAFiGRyxckO2dN+ihhDBiqlG8wzWhNiXXVsQ14yH+v1UWnqRKXu2yU/YZKjHK4ceXfwdv/0w/aBex3hDmMK/v+kzRJ09jmPozy+teIDYlu3LnFGhQqdctI0Ye+mswWcc2xzpKta1nzUPfh1E4K9dncAGlN+7SWyvc0py/a3xfA2T+16pk2M/7wFboB3uWwxi5Yd9Km7bZ5M3VCfIO4uKSFTu9LIQM2SaLpJ5cQCZk6e4wf+io7kScrlHFOCqQAUStpBLtbKvtKPpGtKjlmr2ng91YTn7U4A9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EFSvlFB6T4F7B7LYfbYMWW+PYtNZ9Z6lPDLjB8RcRrY=;
 b=mLTI3zDonrIbVxDdQcaZimDV/UGAeY0a4giagG870vdtDbK6MXVDBc2ikc0VCg9EN+CsGUEiZc+hz1Vic91dM71BVB6yGxZaXl4ZPqm/IYR3rTJD3J/IVo8KQAbhi0uPLXCC1P1IgAHt8YvXgOm0m7kGoeNW2JLYwU3i1pxLJW31Ofx2PRFFiK/la6P0yO0mjJhResBg7MMoUYqkKgfmVyK6gr2zSamCfLdreTTANRqd3YXEO4vRI9vpwrhpCykpqeO4bJ1y71iYaaluygLRqOl2AyPPTv7MkUqItNRPFlS1ZUCGFSk1/wHZskRv/37Se5o07wj1jjhH8cg/S/3WZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFSvlFB6T4F7B7LYfbYMWW+PYtNZ9Z6lPDLjB8RcRrY=;
 b=T///fkPk8quJJWIMvrmOcgWXdSlFhX8k527Hg8E3/8V4qTgYhLqHLNrv7f5ugnTTAKUmjjtb+vjFQIj9pdWPchKH4vgREvWZ2P3dvPhZUrRfgVYUsJoyqaWl5EPJ5Cf5P+qMxxMwhqFse9bxPUfDPOYp1yJeIK8cNHVMdvKvNdE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5014.namprd10.prod.outlook.com (2603:10b6:408:115::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 16:13:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 16:13:31 +0000
Message-ID: <33b7d1ca-4421-2f90-071b-0661f3893865@oracle.com>
Date:   Tue, 22 Nov 2022 10:13:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 06/15] scsi: core: Convert to scsi_execute_cmd
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     bvanassche@acm.org, mwilck@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221122033934.33797-1-michael.christie@oracle.com>
 <20221122033934.33797-7-michael.christie@oracle.com>
 <20221122063836.GB14514@lst.de>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221122063836.GB14514@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR16CA0019.namprd16.prod.outlook.com
 (2603:10b6:610:50::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5014:EE_
X-MS-Office365-Filtering-Correlation-Id: f04a70a1-401d-4377-4c1d-08dacca47f83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iVNPSxttWUXv6LRRAEdq92anURYC0zkyg0/OmayRpX2MwlgrSX/A477AZlvpyYyJ7y8F3opYqd6ecrkQQDvkjlIpRghgeJ0Fp4PJjZY3zYqeEnFuby7vZ7aizQ05XHrLivIwkXEKNpkYxg+iASHjwiiUI/PGtFu2SYx6VIHRVHT/Z64rnF4EuXnrCj3ALYjv/hVVMaUJuL1tSoPzcmhfuz7yOZJyuuPiL3xlKWhUyYyZr6E1LVpax9Hrhv2u2gVaZdQMiAup8HkQvH7xxBJnNh458tZbZ99by5umZuhtDc0qxt04UlW1qzOJJY/oUTR31ShBb1NX5AoQBfyWQ3OJ7KqTBYbSWOlN9nw7ni8h2iJrVFJS7XOvXDWBT1IGf1xSqeazK/CbWQMkZZRvOIuUFvUYWp0xi4g1KVXa0uutbajvHl7RNEOkekW5BsNcCAvX7dZdGe9eotp2Atgu8GTTqsQmI6KdspL3WEABrdV3iunyxodsTmxSoAnk/ofOpErYUhQwJ65tfjeZm4TbB2lydJzmmQdbG9ow79cYCHR19bKu5dChG9sbEjCCH2z2iqzlv0v3TvO3kwWdskOyROmozt8RJp93r1B9r5E1CnyQR/eccR0Kzgd8ECdCAGG6V/MZ+h3KslSF5S8XOwp19yQPF6S4frYNtxBJiNFLmG8jBDSua9Xa5TET3mlc7sgyDJ0UschqWzsspxE7uUmZXF7Pa/sqFD6GMzdLeWakzMB1VXY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(366004)(136003)(346002)(451199015)(31686004)(478600001)(6506007)(6512007)(26005)(53546011)(6486002)(6916009)(316002)(83380400001)(86362001)(31696002)(38100700002)(8936002)(36756003)(2616005)(186003)(5660300002)(41300700001)(4744005)(2906002)(4326008)(66476007)(66946007)(8676002)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXEzU3RDMlR0OGFLVjJnRmdabE4vMUtlMkRVM0hwTVpqZGRHczg4R0NWS1Fk?=
 =?utf-8?B?R2V6T0ZwQUFVenV1V2FWTzJodTNFZ1hxejhaY20rcERtbGZsYW14QXVjS0VU?=
 =?utf-8?B?MEt1L24wUGNEc1ZaOCtaYnZWZ0FuRFRUS2JaVUpUR0JYY1FIZUVDVE5HVDFT?=
 =?utf-8?B?WS91U2RpaW96MWphWkxmeXR6L0V4SGxlczRLQ2p1MHJiSDA5djJRNUdIczRy?=
 =?utf-8?B?ME9XMStIWUdudjJRQ3F2eW1lcUxBZFNQTVYveWMzWkNiQk1MMGtjQUpsdlB3?=
 =?utf-8?B?amJCRHh2TUU4TE9VdmpFZmxVeDFqR1QrZDlvdmhWdy9hWHZMM1pXYnFjWjJN?=
 =?utf-8?B?TG9NWmZrR0twcWN4Yi8wWTFiMXRIMEJHSC81blRSU0tGM1JESEUxVC85djk5?=
 =?utf-8?B?enpBdzRwQW9rZXZPWE1seEoxZWh6ZnVzUHhOdHh4L21SMDJLU1lKVXdHWlkx?=
 =?utf-8?B?SDVsSFdNMVhVaXlYV0E2UnVpWTg0UkZ3a2NVRmI4bzhtUXdlRVYvV1NkVW1J?=
 =?utf-8?B?anBxY2N6TkpVK2pCZnhuUDd0OTBmSzN1Y1BrMWM4cW9WOXFjWXhRSXlrQ1Z5?=
 =?utf-8?B?UDdBT0hreDJabUVVV3BxaEl0OTJkaWNKcVVJRHBMQjhTMDM0b09lMUJRZXNu?=
 =?utf-8?B?M29XbU5xblQ2WmJWS0RwVGNhZW9ZY0l2d2VFNmJpMXlvbEpLTWNpN08vejUz?=
 =?utf-8?B?RVYrZzB0V1g2dmh3YmVMTVFVUi9rUldBSU5WQllPOUNodG9VUTVSSjE2SHUr?=
 =?utf-8?B?akRtdlRUWUROUHRZb0ZvVU5tK0g4ZitodkdJWExIbEZ5aE5yZWc0OXp4K09N?=
 =?utf-8?B?bWRZTDd3aENhekJSMDJyZWZaWmpPM3Z2TWI1MllHNmVESko1N1JBQ3hKUEh2?=
 =?utf-8?B?TGd2WG80S2FiYUJOM2hYREJmUUs5eWcrZU4vWnNCTE5hYS9nNmIwSk5wTURw?=
 =?utf-8?B?ZG5weDBuUVhBamdlWkYzb1hEeHZ4bnF1VG9CRmtLSjJRMUxDY3ZFWG9Nbi9E?=
 =?utf-8?B?YVRpUkRQb3h3czZLcHhXUDJNTmJHZGJxbzRUL2NIZkhaRkVRZGNHQkhKald5?=
 =?utf-8?B?eHloVCtNWTgwK1JxYzEzZTlKY2RmNUVIVWFRNGN5R3JYMVFHaXlPWEN0ZGtW?=
 =?utf-8?B?OGx6dVRxNEo2cWtmN3djWkY1UUpwQ2l5dVhMbS8reWN3VFVjbldzNGxIT0tX?=
 =?utf-8?B?RUJONmpITnVKZU9oTmNIU284eDZQeWhzM2Q4M0VxQzdPNDV4K0MrYmo4T1Rm?=
 =?utf-8?B?bCt5cGxoZkJnUXZhWEREaFBPOWNZdng3dlpFS2p3TUo3cE9tSllWeVdSK3cx?=
 =?utf-8?B?bVh3YVEySjFYOHhMOUcwWVRGbmp2VXR1SlRwWHprSDdSRWNWbFdnTjg3aERL?=
 =?utf-8?B?UzczU0MwT2RCTXpTNjN4NHFoQU9ieDM1RGJDSis3UEZSVUo3ajM1Qkd6T2hl?=
 =?utf-8?B?WmR3bVMxNk9Td29QU1FVQWtHaWUrdnpTdXRkVUpNZzRZSXJtZVNDS3h0UHpm?=
 =?utf-8?B?K3NkbTcwMkh2bUtyb3dsQjYvd3Faem1VNXlrdGwwRFBheGpUVjk0NXlQb2Vt?=
 =?utf-8?B?N2x3ZTNTUm5zWUl2S2ZXVFRvSjdZcXVUNE5rd3J3U3pITTFSZUVHdlJid2dz?=
 =?utf-8?B?c05pZkVhNTV6K3Z6M0xXeG1zQ1M3UVFhQ3VIcnBDa0xKVkhRYjRFUEl2d25a?=
 =?utf-8?B?V0VSMW1wcWJneHdKdmF6V1labEVETmxOUWUzczZiWDhxbUloMHJtU2RXdnBs?=
 =?utf-8?B?VUk0cEVxaVZBL0V0YWMzUlRtQUJ4bjJYdFpYVFpHSU1lQnFDY29WQnI1NG5o?=
 =?utf-8?B?NUdNLy9hS09jWEZ6ZTNUZE1mQVBJb1g4SC9zK1RuQXczWi9hTVY2MmxSR1VM?=
 =?utf-8?B?Y0R6TW4xNTFiQnJ2OU9nV1pSamZtN1A2SytFZ2kvK1I1SFV4SVh1SUY3NlFl?=
 =?utf-8?B?M3dMaWx1d0UyY1dqem9iSmpqMkF3RE1FTWJPMEpOTkowSTc4bEwyUjJUWTMz?=
 =?utf-8?B?Zm1IdGpvUmFodUdITm9HcEJqb2gyRlI5OXVmQm83MkluNjNMU3lMVVBwdDRy?=
 =?utf-8?B?WWEyYWJFSGtKU3N0MHU1QUdkeEoxeFVMS3hJcWlFcjRoMTBaaWpROFRDOVZH?=
 =?utf-8?B?OEgzRVkrTktJZDdjTjlkNDczZVZkcGVQTU5BTDA4ZFpseCtNdTNCNTVxdlNo?=
 =?utf-8?B?WVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: BW0KBt451J+ezWHBi0AWewUOxb4TG8aoL+Sp5jwhDlhypwaY2dtsOpQAOklx3uX8XgvvOUrOqWQQqyXsDYg/U0AL3SvwaWkE9K6LGlokWc6jKBQieGU16QNnYCVprdVb37VuWVM4QA1OrZw0FsJlVVaQXk8EZPMItbNgLQSKHrWM/RjNnn8QV5/dNfr/eLGFdGaJpGLeEf4OU5D7aVN4hvMi8OFPz6PFXcd7AqPyHeSNrJiJnVRUKY3qD4LeMJToK+3DdzecYjXAoWv5ii2eAW7mv0f2EZ4DeEXr7VHt81WZV1G203ElZtLmRrBnA1jQT+P8iRrfQjIYoPcGf4FKqpjwDCykOaPr8aZpYAc2FOYqTGvaJZhYo+PTC79P1rn0SaqQZec1IyC5dgIsX2qDGSnwDBf3eQ8XUvT1jUii2U0OUGKx60tqzDgaejGf/P7FOIzNOw+1dUcqTTTPa3YXumgwRiGC/qmQxycAaObq+kVOAU7HyYrSii3tJrci6ATlujOH7qGlu/pfe2SBf/w9CFP0Nu0PxCEbfB8m9GdpniOfsQrgR3e9y9yArV0E2yMisLcfpskDz0u01a5Ix3tODxtb1tSFaW6NO5kfm6Sno9CPaiTQTSVnFpP9L8ntTcnn5UcUmj1YZ4+aOqwfM/mhSh4DWCBEpppgWfV+rbCRxMTZeGV4ulikKT/MuYd/dByK/i2ByGmsGTCqNPiTB5VjTMicCo5bR3gndYIKEDWvzE5MxnUxPAc0uuclQRxyemEqCBFn55fSEHEuxWJz+uHYgD1ntv9ZwrJPcx//lIdGj8KZLXKn68YX7TDDY3k3qas7vttSNdjoxvm6NfAHXFsKbyLdGVjjcBTC3bBB/rJhW4fvsDcRM74X3r5Tre9KIRcz
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f04a70a1-401d-4377-4c1d-08dacca47f83
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 16:13:31.8766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5UgHUvdKSLndHPRKrijhPV3ZIxi1UxUiyS8njZnuCUcY78IRkDMlIPRA7b8AcQTT13HUunkKA+kLSSymJ2x+0f6wAZKQ52oLTdR1MUOkHes=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5014
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_10,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220123
X-Proofpoint-GUID: t5CxRrM9NO8-Rbr3TUGGSlxmViZfSdLW
X-Proofpoint-ORIG-GUID: t5CxRrM9NO8-Rbr3TUGGSlxmViZfSdLW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/22/22 12:38 AM, Christoph Hellwig wrote:
> On Mon, Nov 21, 2022 at 09:39:25PM -0600, Mike Christie wrote:
>> +	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buffer,
>> +				  request_len, 30 * HZ, 3,
>> +				  ((struct scsi_exec_args) { .sshdr = &sshdr }));
> 
> Maybe it's me, but I hate the syntax to declare structs inside argument

I'll change it to setup the scsi_exec_args struct like normal. I've got this
comment several times now.

With the current design we know all the args when we declare the variables so
I can do it then like normal.

> list.  But even when we go with it, splitting it into multiple lines
> would be a lot more readable:
> 				  ((struct scsi_exec_args) {
> 				  	.sshdr = &sshdr,
> 				  }));
> 

