Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45524C001B0
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 14:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbjHIORa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 10:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjHIORa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 10:17:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAF51FCC
        for <linux-scsi@vger.kernel.org>; Wed,  9 Aug 2023 07:17:29 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 379CxRFf021774;
        Wed, 9 Aug 2023 14:17:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=h+Sfu36yWclBU8Z/7iI8unGbKTHkbb6mZpOFHSND3DQ=;
 b=EwsV3hsH30j83kPQLWFxzvGpRTGs0HvD1kHmjCuEqTJTBYYhrB4xZD4it/+PPEs9nBNH
 qJHMcL+yOtu1T2y5BzpFbTPvk/KWcBuWmlvCNDShy/6yqb6RBzA/crGnb/HBqrLoeU91
 N0mXBcTPlyIl5hytojhmA4nkp3HUAq/H6etPHKHzyqy/8dXuJ3LKVR79qhZfsUt6LfVP
 cvXVyROl4fQYI0LRTi2SWd3WUOOtIObNGUWX9HbqLP2/ZLpwNCoSpCTs5BN9TbdYgwDq
 bpVJXO4yOOJzqCEkoGJneqGf906m3m5I1p95lYj1C9HJE8OUI5dq+fLI2tSOer9s2VIV tA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9d73gtej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 14:17:20 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 379Cvgk1006234;
        Wed, 9 Aug 2023 14:17:19 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cve3352-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 14:17:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uzorv+vfe8AzEsSK5p7+mSR2xiPBzFkfi+drM+1uXpL5IhxihoPyrqyIkaogLvATqgpP2FJO4uLD5Pg+mFA57AVZ+zeGzQK2mcofN2ymXk+tANV6OJ+KkKvDp/c63LFsvTxvWPAOOr/RKBURwy3jtctMC1nmwbJWeyh4R7Yt0vkl1h1+7M6Oi7TU/GKkRxDej5KIoHpm14AoakP+piLz84ZS0an49OUOjq3G8GSlDfTMBFn8AnP0K2oOO3mNBKahdAcjkA2KCrFforMbrRjFS7nVfM7c0TedwLo55AQdNJ0IG7dpDZ5hlkHMrcKXeU0UY3y//TQ8wR3376lklA146A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+Sfu36yWclBU8Z/7iI8unGbKTHkbb6mZpOFHSND3DQ=;
 b=jwnw1YUpzkyeUHvObYZ6kn/y4CBhELKvHCsjICFylPj20k9lnds/ucctR8lT4plRsueDR0ASNw1PgBy8OmkjOau0kRtx1WszmT8ipCiCezgw+bxXsxiDnpiiqgVtJmp16NtFbx3SAj5qIfYGkU2dohXzmliVtABrig64LR9zIrIRLFQ1CJVIRxr0H7GE+H6Dm0ylX3BspK5RqSeWAlLqjlaqBmz8vv4HKcNgGIgpAePXRAnJRnNKnPld1p3Z7YIM750+ukohBL0t0Vlx+7rtvJ1CgkvAcnkw6VbTXaEoB47318xLuCUCjb77n6WpZr7m7oosWO4OLJLbGre7C8ojlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+Sfu36yWclBU8Z/7iI8unGbKTHkbb6mZpOFHSND3DQ=;
 b=zBEANpq/KJD4IZ9UPTo0Q4W7xBhXjtj7HAdiz/SGqNaLBozBExusvVtmmFW2kKCXzWX8+Ff8u2HRkYwz1UA+zmoqp2YXj0FlDdmERx2r0Dek6GoH83kro8YvnHZwr3TiCodWFeapfhUnpTx64ru4uclShVhWbLHTZJthu+wf3zU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BY5PR10MB4164.namprd10.prod.outlook.com (2603:10b6:a03:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.28; Wed, 9 Aug
 2023 14:17:17 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%6]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 14:17:17 +0000
Message-ID: <83c78f47-7b24-bbdd-45ac-f4fbcd5be39c@oracle.com>
Date:   Wed, 9 Aug 2023 15:17:02 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH -next] scsi: libsas: Remove unused declarations
To:     Yue Haibing <yuehaibing@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
References: <20230809132249.37948-1-yuehaibing@huawei.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230809132249.37948-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P189CA0023.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BY5PR10MB4164:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fc396e0-c535-4090-fa5e-08db98e35616
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A8oKWP/zBmk6uDuCN1q+VGvlCnywtgQhYveBKhm0QEIkPvpgPygtQjXRHW8dRk+c50h43Z3EQRHgOxMy/hez1Ak+PQdSGBssYghKDovwcjc3UlmWmzjIdSmqeu8dVL4nxSHSoUdmlZh+ROeQM8D+yWKOtbBThyODQfS2G3bOeCz6/X5R1RE3YVNNGrtrQovxisCaQHmKAYTHSzLVgvygzmJzMV4C6XDIhbExbRc87gK/DKr1bjxCDXrOVv8mhslc6CX34Bfx/sWzvMXJQDzGr6k3eIPuSukwK90VZ50v7xnfq04mNnTZM/bdo5wJ+IK3u/sOUpdXhw4n5f+e1rd779b1DWPiIN//KBTiPPk8xWG9/C6c3+wRmaLOFRF8sTtIr8NBDE74iWRO/BAoAEFmj8j/SDFeNOTECQonuitoodqpsjWTxftbvp1E0D1Vq/R4Ra29THONpEEk17oc/g57NpWpi9WFXerClcNmE9N5ePpyjbT9zcDg8g8JxHJ+zwTrKx8yjsc4K55BDfUbo1RwVZP50gUn7SHiTpT9LBAWk1i0AcupkLMue77SY1aGQCuxusq79/BncQI/6TJIizWXHo3MJr3hFgww17WG99f+vg8wsEV1pAitEcN56woCW9nLK7dCWDS6cKTlDezAImahng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(136003)(376002)(396003)(1800799006)(451199021)(186006)(41300700001)(4744005)(6512007)(316002)(31696002)(4326008)(86362001)(6636002)(2616005)(478600001)(6486002)(38100700002)(36916002)(6666004)(36756003)(2906002)(66946007)(66476007)(66556008)(8936002)(8676002)(5660300002)(6506007)(31686004)(53546011)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekN3eHBvWDlCeEhDMkJnZi8wK3o4bDFqRFdjVFVPd2ZXRlEvRDZtMUtZSlB6?=
 =?utf-8?B?ak1GbzhQanM3ZHRrbVZGTGluMUxTenZ0S3A2cGM4dVhDS1JuZkNsWG5XQUtW?=
 =?utf-8?B?VlBENzhKdktxbmdndHYxT1lFUGxxN3JOS3E2dnU3ZEtCckhESkxSNGhrd0pB?=
 =?utf-8?B?ZDYvSzBRQ2F5NDhTZ0NhZkEzek8yNkNiUGp5QWE4WU9RV2tBa3haejJhL1pj?=
 =?utf-8?B?alY3TFZzVlZsWU5Hekh1RU51NTZROVJFMlFja2g3ckM4eU1PVnBxS2pac1A2?=
 =?utf-8?B?a3V4WGVMMXdncVFNMnlwRUZ2RUZOYmwrQktsYlN4Uzd1R0lPSDlXdWZESTVB?=
 =?utf-8?B?K0pJVzRJRE4wNFFQTWpXM1FhbFhwalNOdkU2UlY1VWhXeDFpUXo0U2pjR0Mw?=
 =?utf-8?B?dUJMcTFULzJ1QzBtYUtwSWhYOG4rUFltMHN4emJFQjZXOUp6TzMrQTdPejAy?=
 =?utf-8?B?eGFSL1pTT3YrOGdXV2ZGd0hzY1hCTFdVOVRGQnR6OHNia1VYbmZTRHZ1RkFk?=
 =?utf-8?B?d0dMRWdwTC8yQmFBQXVJTE1Va0NMbm53YXcwYm1LY1hpd1lQMWJGMUlJQnRW?=
 =?utf-8?B?TCtMQUxjMytjVWdjelpwdHB6djNiZHFlN0hMNTA5NjhZZjYxdmc2eU5hcE9L?=
 =?utf-8?B?d2k0MUdqdHVoNS9HSUVRbTRxaTdBYkljOHN1ZmpNdkJFOWpqK1pkbGQwNk5H?=
 =?utf-8?B?OXhXbGx3QW1GbzUvL1Vwd0FiaE1QaFZLKzVCcTVHZHZld0VuS1g3ZmI3azdP?=
 =?utf-8?B?clN4N0c4cVBaTXQySTExSnN6ZnRCYmhkRWl2aWhQQTMvMmMzOUg4SThvKzdY?=
 =?utf-8?B?a2QzdDQ2dGpJeFZjNXYrd1lXVzh0Tk1HZ0NmUDZvNnFQTEZ5Yld6Z2xJelQ5?=
 =?utf-8?B?UGRhL0h6SlFaVFFXQWVWUCtVRXlrZUJGa211cDhibVYwQWc4eEN5L0hzN05Z?=
 =?utf-8?B?eHNuMXVYcUs0ZjZlSk02Z01HdzdjSEVValdMNnhmeEp6a1YwV21QU2RpdGRa?=
 =?utf-8?B?UFpoazIzcG1EMWdRKzJ3bmY0YUVSWFNFOS9NMDlrRTZjWnBLdTh0diszeHBw?=
 =?utf-8?B?d0s2S2psa3dJc3RUQ0dVRFBWdTNlRktPTmNrZEVGb3FEUTdBN1lGb3dsYkY0?=
 =?utf-8?B?VlRIMFdIbTAvR2gxTjlPekRhNGoxUGpJbzQ3eGNoNjAzaUYwQzVsTytUWXdn?=
 =?utf-8?B?Wm1IdmxpZFFjNUxBUlRxTmdybmhscEhUbmtNdWJGN0t2NGRsNURDeTdlYXI3?=
 =?utf-8?B?WkY0K091SjBxZVROeGhRdWhjRmNFUWF4S1NDN0ZWNHR4VEhuZ2E0ZEdQb3I2?=
 =?utf-8?B?ZU8weDlwSERkaFIvYWVRTWw1Nlo5UGVNUU5kdmNxTDd0Tk1taEJwa1gyTGR2?=
 =?utf-8?B?b2FXL1VDaXh6UUtqRy8xbjEvVkNYQmp1TVAzYzhlRjR0ckR5b1hOcmtyQ3lp?=
 =?utf-8?B?WUlmaWhtMXYyTjZSbVRZWXRTaGZkamFESk9pZ3VHRVpNTW9QaGlNMFFLT3l1?=
 =?utf-8?B?d2g3Sm16OEQ1WDVkdVBDMExhVmxzaFNnUUZ1QXdGMjF6OUwwUXBlVzFibG5X?=
 =?utf-8?B?OERNKzhjbVFWa0E2YWNDdDk1dCtuNEU2RWNNV3U1c2cyUWVBbjZuTVFYcmFt?=
 =?utf-8?B?eXF3bW4vWjI3TGFPVjRyRGt3bWdBazRXdU5mOHZkNmVWQkZDMVJ5UDFFU25s?=
 =?utf-8?B?ck5ZK1dXR2lydXhzWTlXT1ZlZkxOcXRoSDRXcVpLWGYwLzVwbjUzaUhhWlNB?=
 =?utf-8?B?RUZ6Z2x3NW4rMjVqWkxkOWxuV3pzbWJUbzcrenJVaDRjcGk1K2diSVRab3RI?=
 =?utf-8?B?YTBtV0V6U1MzOTB6dElzMDNhaXZYaXhnQlgyb3FGZXJ0U1VtUzBPRjBXQXRa?=
 =?utf-8?B?RmllR3Q1eVpzdnRYNTBOLzZ5R1VmQTk5NWhQWTFyWDhBdlhhTDVEdWY4U1FQ?=
 =?utf-8?B?OW1LeXQ0MncwUTJlRTBHL3M5Mm9RNVRHZmNJSlVyNzY1YWgzQWZJSmZtWFRy?=
 =?utf-8?B?cmRHNnJVMlFuQU8zNFZ1Y3VNaGFsQUpQd1JuUGxtTG5wTTdrd1d1aGtYbnd3?=
 =?utf-8?B?V3pUSXlJeC9hQnBVRVN5dGhkZ2YzNFRBYy9vbW5aN3hiaTBCdnB1YS9ERzA2?=
 =?utf-8?B?SXlhYWxLaTFJSDg1NWM2ZmdGaFN4a1crcWlzeG5Vck9OR1EzYTNFVjFsQklk?=
 =?utf-8?B?SEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tvao9CaXHBm1cz1IITNkSXoNPc23fFqJ8UevVusfHBPVpF/Lgag615MVXHk8rU2qFmUjMGVgpnY/nI1YcapVhQNthZ2lXa6TGEbgGrIQabl80Ed7VjVsnPcaMA/O6RiseDXDixxJNa+exJ7wmVFA1DkrQ0ibkah8oHmXrt/ciHCwx2DVFAcWAxT1FvHyThksV+7r2JjcmTpAFvp665Y3vvgeLeD6aUwSLFOoie5jmO+/zCYfYeUxdnwRHGzfCPTCBl+98ogM9C78469LmrIAENPr8aCjBjRCo+WnX5+HT19xBHxLQXY7hO03sMNgRtx4QZu9y9Jz279LyQxQFX0MAIBpDIFwSkubWHScQv52ZZYf2Ij1CdJEufcrckYUAPq/BvTXDvjcM5DpJ2xymxswVt/JnH6Fv2fDDv4G21X81GgjAwtb5DrJEg5usS+gAEh1A1LJ7HFBn/2rPp3biM6iDsOmiQH8BN9X8ij8UCJew3fJ2Pd9BBmKqL2iuOat76GfjKfFJIeAQaWeZPAIS6UwXKBID817GusH35Caz0IKa86RRrz9SH7oxo+z2tjbf/jpHMR4jSdpnZulIJdBzcdZA/zSjSdqefH0fmmntVEYgNjs7+tv58xMqVZSWn3VqK6SJugwQb5kTeptwlgcIMqtG/UcnyOm8jyRCzvQHJJq69/JnURHdmQ8O8YMZgpyhYjiBRBaGVCSgTN6uq8+qBQYXU+5HbLjj+sf5+lu7DB/62XWG8Vd3ZMdyujkIu+3/RsoB5RFtkHZ+opDQ4XjkAfJEePs/aRfhMY99tQo6TMm8zOlv2lzteSuV0PCRoi24CTm2gN5EepX71pRVz08b0USbQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fc396e0-c535-4090-fa5e-08db98e35616
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 14:17:17.5002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ur+MDwTc+Am/EJEOCLFwGopM9qMLXzRYfVkcCst/AX85x4+KjgZYRbtX0DCjG+lOQwgJYA3hfqRUC+Z5K1zzOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-09_10,2023-08-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308090125
X-Proofpoint-GUID: x3x92JivbhlG55ouDQAaMv4czISf2a4Y
X-Proofpoint-ORIG-GUID: x3x92JivbhlG55ouDQAaMv4czISf2a4Y
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/08/2023 14:22, Yue Haibing wrote:
> Commit 042ebd293b86 ("scsi: libsas: kill useless ha_event and do some cleanup")
> removed sas_hae_reset() but not its declaration.
> Commit 2908d778ab3e ("[SCSI] aic94xx: new driver") declared but never implemented
> other functions.
> 
> Signed-off-by: Yue Haibing<yuehaibing@huawei.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
