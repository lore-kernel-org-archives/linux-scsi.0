Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 747BCCD37AC
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 21:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237661AbjIOVBY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 17:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237740AbjIOVAy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 17:00:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F5E2120
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 13:58:38 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38FIehJ9022880;
        Fri, 15 Sep 2023 20:58:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=yozejzhDDtumHtfQjMwl6jG5RQEVfEvA3EJV+fxhtR8=;
 b=r3jH4dhO57o1NTmuzdzmEqZc05AmY5th5aHgtnDgR8oEvkPefxkk4F2UrPOEE3E987I9
 5GmQdjeQHhml4sPUK5Yfjru5IxhvmAER+up2FwTlXU1G1bRz0C63/qHVDUQPgzpkjDZQ
 7/knz4r5GWZG86g0DSM/67ok6eHQ9PxLUmPcZpFpgurecXmp9zQaMeuLiUoE5Ho+gagS
 hOqAMnnH6Bs+a0devAZu7WEGjj2EpBmPlXcVwb9iuz0RdM8Km02ce7eQUaxkyfmsG5Ma
 Y6gA/pHkRJOIz0KnxXoAmWWnOp/gYxGpyj94wZX7LFzLfKLL8sYqGX9cq3Ft3wPBeETJ ug== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t2y7krkpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Sep 2023 20:58:30 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38FIvWVe028301;
        Fri, 15 Sep 2023 20:58:29 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f5gwacg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Sep 2023 20:58:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mDgfqKMmIRsUwBZkmM8H+1rH6GgM/t9f0A+sxZXo/5zBjAFStEVurDjkDv6sQa7gcBE/5WwlSdbs2w+yTZaAVSXrfmEpa5Gf93djTXiByhFaqvI6OisbikLER/2b4ZxMQHq8A9zBROuvJiVgrlJjhS4TZgHX2aYGnnGaoVix27CPX4eRpY/mGnlfyeg8Mz4K7BL6I3ke6Yo/qmUPGCwo7hjBCJvgJUUVatrJOFIaLNlvqOF7rcmBDyqunsRf/FzuiMuGy4g6Rokj4FRfzn4zN+pIiF1YJ2Vy+t9fJedqJSribFEZoU4Q6qEQoC7xK6Vfil0E2trKALfCCerFDh4Ebw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yozejzhDDtumHtfQjMwl6jG5RQEVfEvA3EJV+fxhtR8=;
 b=alWu7Oh+yMbhTF9h2wnUe+HUQkaEV1b9NXjwK0/N+pY6TBdWA6Fr8Kcdp3Lkv/tcK3QN2HR2EP5+B2scaI9bpHjS0OjbqkGBN8Buo2A9rJZT5I+c7E7dB9ZeWl1rnjjGQC/m92EOXV1xYZGg0peV1D8TDMSkKJ/LnjAgOp2XbrcSo7cMKPXlnNjSa3HjwpjtSIziSE8zInDObYOB+SpVEXkabSI8ijdTkzh94OKCoM776EdAai4VKRnqixEBZ/NC520F/KA6XiSkVu9DalJuPAag7uauZ+kVOFy3C4M7EGOHHZ0bGQhEOCwM4PiCnU7TbMS8KT9ayGLHM0sptEO4kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yozejzhDDtumHtfQjMwl6jG5RQEVfEvA3EJV+fxhtR8=;
 b=Bb1L6Sua0uzOb4OYqbwWARMT/2CoFYZnsJQo7k86s5eofrJzDMZPCVpXBUryqg9jQiqYNDhv8oNX9dNV+o5f4Chdtw8N4Wy+ccYU5JSuJtoRdUzjJ1Bu47hMCLeyd0ZnKSwoSSZku+PTNxB1uUXaT9d11hKDNQqE3vPigHjKvpI=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by LV8PR10MB7845.namprd10.prod.outlook.com (2603:10b6:408:1e5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Fri, 15 Sep
 2023 20:58:21 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6768.029; Fri, 15 Sep 2023
 20:58:21 +0000
Message-ID: <8c979a19-7005-421a-a321-4a6014a6f342@oracle.com>
Date:   Fri, 15 Sep 2023 15:58:18 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 10/34] scsi: Have scsi-ml retry sd_spinup_disk errors
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>, john.g.garry@oracle.com,
        bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230905231547.83945-1-michael.christie@oracle.com>
 <20230905231547.83945-11-michael.christie@oracle.com>
 <c83a61021ecc165d20bfd0fee47ca83233e3078f.camel@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <c83a61021ecc165d20bfd0fee47ca83233e3078f.camel@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR03CA0238.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::33) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|LV8PR10MB7845:EE_
X-MS-Office365-Filtering-Correlation-Id: a743f6f7-8a73-4af3-04da-08dbb62e7e4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +6yWFqxIekZkKtUJNV9hALxZbPQiCaJ4ux1/dbUwqKjsnTi9ot/jPVyFBo9hmo3Oxq/O+njiOuLCjf5jhJjnzGSYdVCfbDkjvCj1Z1JYizr9yEsHdbRLuf5YlezutrC3VjTDcFu7I4MlNA61yzRcGxBvdHPFV6geEJgpKE6cFMKYSs5aI/BC7k/cG3+OZ5wfzSp6CSjoCZBWtn/bd2/Dx1696Nn68LdYM2oS/jxZQYb3oWi6xgLNG8WkFlriPWGytPCG2V1yWGJ3qIJ/vtc02yqiV35YLqZ0fB2t45WQ/rdnGILLNrshtE4bBXsgXO53mo7j8Xjwsq2FM4xMttscipx5U1VsEaJ2eeVbU5uW2zdfsEQRVYZJBLWpBRiV1Ybn3s8t/OSWmIZC3EV0sfnPlGrf/BwMHPb2C+u0MKeWQio7HtL9KREiJmq/WYg/w1eARUG3aNNh0vr+5QD0N3jTjqy5CdIYz54F/YwkI6gxSc0dvnbCdx1hXTymni4HTohLtd6scD+hoWlNWrBvxam810AMKFVUW0F7Pv465/MIn3IVHbn5yFylEnNRbVnpFAAZ8Q5rYzCqEZdHWAPKT8n10JoOh2zEOK0r9fEfHD1wwvlz1hb06VDaNn5SHmrxnFF9eapVLmhl+5RR7rt+t1DZNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(346002)(396003)(366004)(136003)(186009)(451199024)(1800799009)(38100700002)(86362001)(31696002)(36756003)(4744005)(2906002)(6506007)(53546011)(478600001)(6666004)(8936002)(41300700001)(66476007)(31686004)(5660300002)(66946007)(316002)(6486002)(66556008)(8676002)(6512007)(26005)(2616005)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXdwRms0RmJnYTd2RHlTYXJoWjRuV0FUY25jWHZDa09SVWJHVXU2UXloSHVJ?=
 =?utf-8?B?a1dEOFNNeHkrZGZGendmbUp4Mms0OEpUcXVKdVptY1lDdU1XRnJIUUhJQ3dO?=
 =?utf-8?B?RzhXVVNmaWZURjUxaFV1Nnc5c2FrbGRNTndSRVpMNUx4Tkxydk1sYzNwTHdZ?=
 =?utf-8?B?cklBdmUwaDgvQ2NSK08zTGkrUkZkZ0VYQ0hldDE2ZHExOUxyb0hBcVl4dFR2?=
 =?utf-8?B?aklQTmpuZUtWRFpRQ0pZMlMyaGlRMWlkTkNYMTRMM2ZuNEV2ZDZJYU9qNzFV?=
 =?utf-8?B?Yk9LdmViemdqWUVBcDg2c3R2U2dJaVJvd09mcHVWUCtZL1IvSHpPZUk3WUJC?=
 =?utf-8?B?bWs2OVQ1bjViV1BrbjZjM1lvQk9VeWkyZ3gxSEtTb0JSTkdLam80bUtnODBt?=
 =?utf-8?B?SXpvT1ppLzJML1RZbUc0K0hYTjJzQVV3OExxeDFVV2RxYVIvbXp2MEVTMmpu?=
 =?utf-8?B?RzVZQTJDdkZIeHpWaFlqb3RnbFh0VHNmZnpVWktnTTZPSkFnbWpMWE9Sdkwx?=
 =?utf-8?B?elJGUUZPSVVEU3d3TzdMTFM4WGF5Ty80YlIvVG91ZStZcU9ET081UW9wOUNm?=
 =?utf-8?B?MGMyUWVjdFR0SHZHVWRxY1VTYUlzNy9hMGduNzdwNjR0S2pvTU51UmZYaEZM?=
 =?utf-8?B?NkVscVpSRjE5RTVVNGpuUjZjNjlFK2ZvaXJNcGx0MXZKUTRJVFFGbkZjTE9U?=
 =?utf-8?B?WVJicURJWDRnYzdsQ3lpenZpbGpUYzFQaVM0b1pCZUFseEFCSFcwZHdlUXU2?=
 =?utf-8?B?eGxsRjVkeUVCa0ZBbEQrdzJTc29QenNqazRXcFpHQjY5VlowNnZFcXREd0RJ?=
 =?utf-8?B?cHUxcUtlWDg2a1VXVTVHbzhzNGljMUs2S1B4LzUrN0lqUXpVbmdmK052ajJ1?=
 =?utf-8?B?WDFDcUJLQzIzdktJZE5RQkVSNkUrcWZLU1JLdS9qOU5ac0oxaXE4Ry9DSzFk?=
 =?utf-8?B?YzVRdnRTaFZHZGIvcjA5NmUzd1h1NG9xU2gxaGkvdzhUK0w2N0NtVzE5VzFK?=
 =?utf-8?B?Zng1MWwxc1FRbXVSM2dQa2dTTkVON3ExWG9kM2d0aG5ldW9mbmxGdk5yblNy?=
 =?utf-8?B?Ry9ETmNLcTFCMDRyNldmdk5mU25tMmhpZ0MvYWN6VHlEUVdqT1RSRVhTQzBu?=
 =?utf-8?B?TEY0Z2xtUTdSNUtYQnB1WHRERVpkZ25kdWFCMldJeENUcTlFYkM1WjdUeXBt?=
 =?utf-8?B?N2FyWWwzTUdtMG5JU2hlRE9uVjY2KzN2R0ZlWDNvMDN1V0k4Y0ptN0hKc21x?=
 =?utf-8?B?clRWV0NhUVpweXIwQlNHZUh1M0NBWDgxV1JzSHhESnJjR216Q3BqLzlkNm9p?=
 =?utf-8?B?T0h2Y0F5MVdJVjdDaVdGMVAreTlpT25vWmFxbWgwT2RFSGVsa1oyajRYeXcz?=
 =?utf-8?B?ZHpFZDhic2k5M0xCV0hERnBTZFV0OWZLamdsUEFJVlZMejZiQ25CMjhncHNW?=
 =?utf-8?B?Y0N2bWw1eFRBZllNR2lCVytjUmNTRHpHZzllZ3JNKytmc3lQV3BJTy8rL3B1?=
 =?utf-8?B?K01qbC9iS2dHQlMySlhHZWpzdVFCVGNCbUk4SDdvWGhhTlNxMjk5ZHJmWm9D?=
 =?utf-8?B?S2tBL0pOTW1QaXFUYzRsazNoamZWdUNMVHcrWHZuNWZHWjNHKzQwOVRvMHhj?=
 =?utf-8?B?bzlZSXl5eXo5UkFZM0JYaHJ3Tlp6MzJGc0dwK2R4TGxldDMvNTFSaDNkVVlT?=
 =?utf-8?B?cGRHVEQvRzBMV0dtQlFwSGd5RWxkbWlDd0ZWQkJDeitjWlVZaUNncWVWdmxD?=
 =?utf-8?B?MGJEZzVqNmcyVnA4M3MwTjd1SWk1bG9FalJxTVVyWElCaGxIai9iMC9RZ0dO?=
 =?utf-8?B?ZU9sVmZRamFpTmlkNllVajdndCt2VStmelFCN1RJQjBKMU8rVVhIZXRhMGR1?=
 =?utf-8?B?elY5NDlnSlhmc0VRSXNiSkZrcGRYUUZhMDV5b1gxZzJTVFFza0hVMmN2bHdE?=
 =?utf-8?B?VmUyVk12NVhUeno5YkEwTzErV2g4SUNmVy9yTVBLQjB2c3pBMW5MTE9rRDFz?=
 =?utf-8?B?eVplYlpGVzZNWUsvVEo0M3E5b0dOdFFKR2VVWGZBaDRDL2dLdTVrWUEwSWZk?=
 =?utf-8?B?NXp5WVlFbXpEN0FXQndhUHNiZDdZTE9sT3BsemwreTNwTXNsV24ydkhMT3l1?=
 =?utf-8?B?Mk5tVGs5bnA1SnI5SWJpL05TTGtMc3V4V2RKdU41VWx4UDRjS2RqbXBoV3VW?=
 =?utf-8?B?Z2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xUBjPIa60i99xcLN3ualnmyvwAMsSFs+EQg8GuJ7AtOmikBemxdPWN0VJcnu7VexSjd92Y0XhvnTkU9NW3YARi2Skljk7DUYK++UWuqnwa+93JzAy4wIVX+7C2o8lWnIbGpvD2tpYFLUREwamZNHnIfsvbU2zXgVweI6Sv0b7Reg35AKaogyVNhiTZtKlY3bM+u6cMgCBfyW6NwC/wjVCq0nTEc0/YKvhX/WdJ22Q16pQnx0s9TZRPL1nj5wPapD5h2ge6KUNeRoGNLzKl9LDPlSTVuRoMqYUsByQ6CqE3rHU0+EYR5sBgjlTMRR2Wc96MfK8DNCBRKkveh8iNtN3lrt5HN9uQs6+L1Z923fvZmnMVtNpYyIUph8VRnwrSX/qXGcx4bgIuq9wa8nbXg4/qk8A9qXef9sT43p9TJp67+roVGMVK3lRGG1MtTgqv9ekziSchhkeO29M1FAZ6bveKmJBCXB299IBF781MpATWM4cVMxh8Smji+VC4kxfygd6JPiKbnoP+YmJjQFwnyOMY9bqWwsxcrWg0hlqiDx3YzV5hu6O5+Sjlg7gx+xC3FJOUkYoc5S34OTTuOVW7gIv+6xZJvpDlOLnQTcQJHXUY4YxEZIybVOShV0BkSu3oyGN1iqxKpUObFxMzDhbjeJfSTlyVYitTrqINU/ms35wvV1vbtQLoxi7TQFkEuol1as/UugmjcpSFdnlsFNsTFUE3JWgdRqPOhzJvj4FpAHSnV0J0Nhfzf4oZqNsKbP6MMjM6d4PpfqGLoEvPQAXzQ8Gpvtu9xIYS7d+15SxbBuoRXABk2aMqJ1V9SljY7nrmer4ack6DW6B7D+8IcxZGvntnjlJGCZuVq0kYlH3IcKnlmtVDpqboU89h9nszknVsW+
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a743f6f7-8a73-4af3-04da-08dbb62e7e4e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 20:58:20.7756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LFXaQ+foPUy/TLv2WiA10IrvPIIm0zYstU7RYz7wRyylD3X2jRiRT1oE1zR3oOovBrInkXTikxTZjXpI9KF6+oquO6ffq1Qpvo0WsxKHUvA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7845
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-15_17,2023-09-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309150188
X-Proofpoint-GUID: 6PYhqriRw1ADHZ6DZhuwi2a4vNxjaWnd
X-Proofpoint-ORIG-GUID: 6PYhqriRw1ADHZ6DZhuwi2a4vNxjaWnd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/15/23 3:46 PM, Martin Wilck wrote:
>>  sd_spinup_disk(struct scsi_disk *sdkp)
>>  {
>> -       unsigned char cmd[10];
>> +       static const u8 cmd[10] = { TEST_UNIT_READY };
>>         unsigned long spintime_expire = 0;
>> -       int retries, spintime;
>> +       int spintime, sense_valid = 0;
>>         unsigned int the_result;
>>         struct scsi_sense_hdr sshdr;
>> +       struct scsi_failure failures[] = {
>> +               /* Fail immediately for Medium Not Present */
>> +               {
>> +                       .sense = UNIT_ATTENTION,
>> +                       .asc = 0x3A,
> Shouldn't you set .ascq = SCMD_FAILURE_ASCQ_ANY here, and below as
> well?

You're right. Will fix all those cases.
