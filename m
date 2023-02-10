Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B288C636CD
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Feb 2023 16:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbjBJQlT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Feb 2023 11:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbjBJQks (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2023 11:40:48 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0FB75371
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 08:40:47 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AFMrIm001422;
        Fri, 10 Feb 2023 16:40:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=HRPOxZUo31ge6HKZN34NCqfSaFxWaQAh0BuzWyV9fd0=;
 b=Bj5lgvr/GGTLy6GN4Uz2+Dm2HUIlFnvg1I4zouYIIKL9PWnlNPpL4VL97CjnIn4T68CT
 jbvnc9QxEqFZl46b61ICktcRfN7V+BytmS1WsYC+mTeRDW0n0hacth7VwkBcYDDQtp2T
 zy/98m+hcOWesBbpSOaK+aT+xJW5sBePBnjicP76dDKbq93Wo7pGg2uX/4w099Gmkp5M
 FSFMUj2loSXM3HmbfRIz+cWDgI6+TX/9fro5iWZd1plotaB5qqyEjWe/4GAT7uwUOhls
 CsTDwgzYe2vJ6cbhaU4FIreY1JOvUp5DMjXp3N25EcvHkVHYjmWXgyLMS1XMKr4lNDRW KQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy1dtef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 16:40:40 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AFmjR7013674;
        Fri, 10 Feb 2023 16:40:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtafd7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 16:40:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ifH3x0GZPL+skifLAq89YCnowQzifqDT+KcY67JGIBHsdL92b31FcFQj3XtTlBY5WM/rAT4ryJjZNNrIveQi2Wj4d46ML8jagx68EvZQPQXNIP27lCiGkuJpGrs62ZzkH9QjlNyRuYTnHPB6NhNspU89kiTpp8ojB3dGDktToE4E1Ev6Vdxp0eYQyMQ3cm9N3kuyIB/2q3WNxlad4Z7KeWzblOQVwGLpWvgk9/TR97OOFIFQ6HC+vloMRwxUadMeqgjEejFyozkVWh7D2gEKwSkS0BI0cQI47gacKW3ST3Lkquw9mAzjm/vPI/Wojbf+RvOmVMhU3QLc8yTNenzm6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRPOxZUo31ge6HKZN34NCqfSaFxWaQAh0BuzWyV9fd0=;
 b=QJWiqT6zOLbyuHgBrptjA+3Vva6aUyXOszZ9TNVbFPdYUpTaN5Xk0BMR+KRiC3k1qKb92wJmzKfCt/TRGwTlDhIGPLytwS/pXKVS78ykuz3CftgaxLX+j65VuVHzO3b7ewIz4tbQa8DRL8bHijCi1lo0ReV38CWScvh1q7WNRN2k1jz5A6jmCwUa02FWCHE081emd0Ix7w7qxtXzJpQduTg7JxEl2r94hJldx7VeSKTo7aONw2p8jKYpI+tDMtK1Bq4VIrSFrMkmaod8Y4nw7lCerWUDyDuI6L5fVzNmwrXQVfsA0SEl9a98qY8ufDCDMI7rU1AQ/cnSD/XNQixlcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRPOxZUo31ge6HKZN34NCqfSaFxWaQAh0BuzWyV9fd0=;
 b=y5p+ybuiqnqV2PI8qeeafghtu0Mr5u/44Vf2UnlRsTzevfDbkeH9p5YnIZeP53bqJ/hnjeo1XMk62FoI1ZR6B+RNKzF+CCo363ZXI9wkfbncj3G5kbOYeKoFORDbJEqrBv4eS59aYzw6UkhtbeOioxx92K6TKHw52TBnV3mcxLc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CO1PR10MB4786.namprd10.prod.outlook.com (2603:10b6:303:6d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 16:40:36 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb%4]) with mapi id 15.20.6086.018; Fri, 10 Feb 2023
 16:40:36 +0000
Message-ID: <7663c0bb-661d-11bf-19c7-09702b7f827f@oracle.com>
Date:   Fri, 10 Feb 2023 16:40:32 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 1/3] scsi: core: Extend struct scsi_exec_args
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230209185328.2762796-1-bvanassche@acm.org>
 <20230209185328.2762796-2-bvanassche@acm.org>
 <8c9fcd15-09d9-337a-d999-3441f74ffce5@oracle.com>
 <b8f0d08a-4086-c4a9-e5a1-e8cae638f403@acm.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <b8f0d08a-4086-c4a9-e5a1-e8cae638f403@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0262.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CO1PR10MB4786:EE_
X-MS-Office365-Filtering-Correlation-Id: d542826d-a049-4e29-8f58-08db0b858942
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yRtmASz8oZWabDK9k7RD8uwnkEx9rU4CSuI7v6dyAGLFev36qF7+0NyXB7/6Bz2aLtsmizmR8qWkElXoOYLHPS50xPc7uknLRvurdvgJlcbkliR7UYmtotyGSUda1FWPlYOOBiqM2qMnHioJ+f/iuttCpZhluan844iFUg3btMC0RjZ/Kx54YgCaHO3Y1hDiKP/v54slR3/3kGcJH3+6hS3iCv1NXnBYcYYtRa0GlJPhi3zNBUgKwhVWopvnL0pGxUDVjXv2uvPhJrnlv5P7GAX8/O0FnBih/WWk63mh1wnfDZyvzz9YFOustKRKROUYGJzBFtcXikHGGuzDdWH/VD31p2OBbQsuLJL4YITr9VUEmDk6j6GUV5cPvqzxYh9ceJ6FO0+Yz7UfrfVlQeyg5hKIQR3LSL803p4+TQdtLrxRODSZH6DuamVL92DXXKLWLmosXDCUv7k/B5TNs68i/EJR/pTuUHPGtJ8d6uiFJnicThJCGA1GP9dyPfli9DGUZzb0goIxBl0fKBhcLfEjviuo9yLyA8zrbuIEACWFUkvP88QR35B+3HYoGVKcxXpAgtKkGZPX+8r1ocMYGZsCo33Q9mINAKAhkdu5OC3GRTTONWrsHSB5AfLf3DAh9BTGVgAa3vrXmrgMTHgSM3Wh3MF2Q3fqIyBj1Tot9jcrZq9PhoHnAfi0V4N3Q0zxIPypxn8U60otGUEM3yrYgmQaj8p+aI6NU6kdAeJ1gy5Xzv0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(376002)(396003)(39860400002)(346002)(451199018)(31686004)(316002)(5660300002)(8936002)(31696002)(8676002)(41300700001)(2616005)(2906002)(36756003)(66556008)(66476007)(4326008)(66946007)(36916002)(110136005)(6636002)(54906003)(6512007)(26005)(186003)(6486002)(86362001)(53546011)(478600001)(6666004)(38100700002)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eldxcnlYc1pCMWdCU1JFWUh6VkVhMHRoaFlOa3pReWlHWC8xQklTL1dPT0NC?=
 =?utf-8?B?eElDaUNJVE5VQjR4UTBkdXl6U2w2c2dsdWZRUy9TZmZuTytjYStGemxsNDg2?=
 =?utf-8?B?TWlaSjc1M1ZoOUxyblB3ODVlYTErNVlMbTlvN1A5YVBKcXNJb25HUmVlZExp?=
 =?utf-8?B?QUp1SEIrWUFpOVYzMEp3bFNJWjlaMUlpZ04xODJXNm1JSncvZTFTQU5JUGU5?=
 =?utf-8?B?VjAwOFhKVHNuMkd1WW8zVFlFVDhyVUNSTmpEK2FiUGdMcmZxUXBJb2orekNs?=
 =?utf-8?B?Q1Q3a3UyczRHa3ZvKyt0ZkQzZnROZ2IwMG5NaHA3VlVIemV2UlpHV05COWl6?=
 =?utf-8?B?SXlkbnlsSkJBaUxDUk9DVXhVS21kaHJROFhmcjhrMnkwK21rWmdXRGRRMWlR?=
 =?utf-8?B?bGtSQWZLZlNmekF2SndFZFNXaDgzVUJoMG1FenEwcXVmMDhTQkhCejBnOS9K?=
 =?utf-8?B?VHNTSWE5M244akZGVk9PY0QxUUdWQWdzaFVPdkRxMDZlYkQ3UWZKcyt4ck5q?=
 =?utf-8?B?NE1zTUNCUVRVTm1sQjZDNkpSQUFCdjRxSWlnVkI1T1BLQ2JpU3F4Y3IzWWpw?=
 =?utf-8?B?Z0ExTzdlWG1hNDRaSmRNT1p3Ym8ySWFZL2Y3eXg1d25BaHRpbEJlMUk5QlFO?=
 =?utf-8?B?YzZodGtidy92TitmTjE4ZDFLdzkxQkVCSlZBVEpPSE5mVWpPNE1GdytCbWIv?=
 =?utf-8?B?dXhVallMd0pYeUFveXVFdUJNeStXdmcyazlNR0ZJQ1hkdlM2SFdhSXlPblBx?=
 =?utf-8?B?QmlLNHl5NVYwNzV0SXZmNXV4bHZmalB5bWUzZytHcFBBM1B6ckZaU0lVUi9w?=
 =?utf-8?B?RmIveVE4Q1cxcGMzVGMxVlYyNTdvZFNGdFpJZEV5eFVsNWtMVE5JWGtIcVdU?=
 =?utf-8?B?d2ZpZHBPbnZ2R0xWRFdCWXExM282Tnl1ODNIay9oNTJoS01iczM2eDhQZFJE?=
 =?utf-8?B?cTFRd1NKUnpCZUNpZnlTRnRRUlhlMHZKc1RTUnJyU0R1NlVHWDM5ZXFkelpl?=
 =?utf-8?B?N3Rrcml2ODFzYTJvZ1VHNEFLSy85VnZ5MkNxamk1Ri9BU1NreVVaTFhseEVK?=
 =?utf-8?B?Kzc5MXdVZmJNdGMvYmp6a0R4cFdxaGphZTFFRHg1N0Jnb0tFb0JTRmtDRTZn?=
 =?utf-8?B?WWQvTCtNVGpYUzZ1NmdxSUtZeDlvMlR1aHkyRlFQK0FNNTF3bG0wTURwWnRH?=
 =?utf-8?B?QUFZMlpuMGlGcnRsWmxyeTJqS2paeEU4RnU4bkp2aUlJOGhMMkMrY3RpSXd0?=
 =?utf-8?B?TTExQkdKNXNWYUVnUW92ZExROHFUMy9xdTZjOVV6T3lwcnp0aDJGWWZDQ2xu?=
 =?utf-8?B?aGdSeVA0SldNbHR0UDJGVURNdjZLY0J2eFlwSjMva1pSSGlmTWVRdVQyRCtj?=
 =?utf-8?B?R09MZGFZeVh4OWFYbk9saE5DeUZFc2c4Rzlqelh0TXkrVG5jL2FxQ3pTcndO?=
 =?utf-8?B?MStqam54UHdHTlloYkhMTm1DL1ovc0pGNU8yeSt2Zksvb2ROZXlyOE80VHky?=
 =?utf-8?B?UFdGL0pQMzhCZW14MlZEZ1dDLzlGNG1KcEJwQ0hJWjBTL05VL1NRSGZxRWpy?=
 =?utf-8?B?Mzl0aXBpWDRIbHpxckF1VzdUdGZrYjhIS3NVYUlRVDlHSkpaQ1dvOTdibkNk?=
 =?utf-8?B?cXJwWVZUeng1dmZwTWJLcmRXRG44bEt2VkVCenY5d0MzYWdxSEVMQU80MXdL?=
 =?utf-8?B?K2RqMTdXTll0dVdFTzkxZU56MGgvYTFuUzNGaWN6T1ZiMmIxTEc3WmpCZVcy?=
 =?utf-8?B?TnpKMHZCZEZtbElGc1JZQXdPd2xDNzBVdGlXRE50ZVQwVDZQQ29VZjNuSTgx?=
 =?utf-8?B?cEF4RmdWS0F2dHQ1c2hZNkFIZ3RzREtPa0piblYweVkrbGhLbXAzMzhrcUFa?=
 =?utf-8?B?S0c0cVR4bXIrRklBbEJLS3VvMi9nU3RqUmMyK0RvU24ybUQ0SFduZlBEZEtx?=
 =?utf-8?B?UUM2WnpWbU5RbHREeThTM3VyQlcrTmxQY0V6TmlPMmZaaEp0QzhBRHZ1WGtN?=
 =?utf-8?B?bkJ3czNNejd4WDVkTXROSGh6MHhmTTFPNC9rcWk3ZEhNdjNwWEtjL0p5UHB6?=
 =?utf-8?B?ZmFOUkxSZlNoeDg3T3dLUmtsczU4dkc0d2h3L2d3Mm5IVUNrK0x1YjdCOTZs?=
 =?utf-8?B?MU9QUkZuWlQvRVpKczFWbkF0R2p4MDBQd0JxZ1BFMHg1ZjNuaGVYVWtTYVhv?=
 =?utf-8?B?Mmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: QLwA/JC7VImINWCXwtfXiq5gi+rhiGcVmdyO55XwecSTWuhLP53kp2RdvX17QV28hjSmixi48RgBytzpu5rcOwW6NdavNp2cAnKEoDlT/SV6sGgSIIzBa/Ezzk8QPuR8aGQCMArQ32Y/ot/HeTMG0oDIL+VFpr9avWlGrhfS33DBLaf3hSIMBO5QvlYxJzkqFA8GxuujqvcEC3rWpvG8l904INslNTnhnTtdJvYuzSIg8rPl+rK3om61Kqp5Il/I2QhTifEXhxMg1YGk8YXnD+2dO111z8540FB6qwMnnFw67udEXwteIh0x9fRWLjwTaLdSVofSw2IzgHvYeIKTa5mM0lhhphOxerNh+mCujiQHx/dC54kj2p1P9s8xcF1JgiaOUMHtWU6RwVFyw5qEbZSXRaRvX7Oz+zw7ID462olkYirbIB4RLj07UfOLtUFoyCZFeLaBhQ1DqvJyG771+BpyCMrKlCHpRLneBO4BhV5Vhhsq1/D+aCxlKPDkdvLA95puOhF3E7vM57Rrh8nhiYZM7oYshUQjNNAZ+FH0b+AOb3hjmoEaeG/ZQ+ZPius0vR5a20jNK52yCkQ+kzDG8Q2ugkoEHCnX6zQ9LbYPXVw8Go2Dia11Gt9T/SvRCuoe6uTO9yteGFyg2p+TtOqI849houUstFZkTLPCYcpH7yHTo6q+3zsi+a42TCosbP0OQG/TkdCicglWBH3LZAXvGLnBedhgGkDuaiGfG943ReWtH6561Ra3JzKFXpHqIBTjdMEZlsCAf9yDLeTPRc8r6LaMhUQp8dLmuRjS82HLr+DgLe3GCdK5tEuyJ6JY1bH0rFv7HVGdzbnZVh37/TgmOjU9QzKWnRQPqAGUjb6Vwl6J8IspQLjnm1BUmSkZeap4Gr4Sj4bOiMkjIA8Zr40rrA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d542826d-a049-4e29-8f58-08db0b858942
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 16:40:36.6640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JFF2C2G6R36HT7jjTh4SCVxe2H3efBkFDUIL+ojJZZB6xLujQxf1i4Mf2oogtU4RQHhjdIziHrNiFcqO/UZrqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4786
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_11,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100138
X-Proofpoint-GUID: 2RFgZTjd9z3MW5zwqanIsVuFNf7maRAr
X-Proofpoint-ORIG-GUID: 2RFgZTjd9z3MW5zwqanIsVuFNf7maRAr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/02/2023 16:14, Bart Van Assche wrote:
> If scmd->flags would be initialized to a non-zero value in the future 
> then it would be non-trivial to remember that the above assignment would 
> have to be changed into a logical or. So I'd like to keep the logical or.

ok

> 
>>>       req->timeout = timeout;
>>>       req->rq_flags |= RQF_QUIET;
>>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>>> index 7e95ec45138f..c7bfb1f5a8e7 100644
>>> --- a/include/scsi/scsi_device.h
>>> +++ b/include/scsi/scsi_device.h
>>> @@ -462,6 +462,7 @@ struct scsi_exec_args {
>>>       unsigned int sense_len;        /* sense buffer len */
>>>       struct scsi_sense_hdr *sshdr;    /* decoded sense header */
>>>       blk_mq_req_flags_t req_flags;    /* BLK_MQ_REQ flags */
>>> +    unsigned int scmd_flags;    /* SCMD flags */
>>
>> nit: scsi_cmnd.flags is an int, so prob should keep the same type
> 
> How about changing the type of scsi_cmnd.flags from 'int' into 'unsigned 
> int'? I can't think of any reason to make a flags variable signed 
> instead of unsigned.

Yeah, it is odd to have a signed flags, but it's not the only one in 
scsi_cmnd. You suggest a reasonable change, however scsi core structures 
have many odd member types already.. so I'll leave it to you to decide 
on the proposed change.

Thanks,
John
