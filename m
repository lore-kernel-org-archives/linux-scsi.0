Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF43C636CD
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Feb 2023 09:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbjBJJlB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Feb 2023 04:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbjBJJk7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2023 04:40:59 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9283430C
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 01:40:59 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31A7Nmts020876;
        Fri, 10 Feb 2023 09:40:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=6d/YsHVboPCnq8UtD/0hDR0GqaJR1EmcvWEfTY15aQE=;
 b=bP38A/D8DDJrtZCmTWPQLiwmaIs1QPRV6qy/k9DH7XpZMJUutVgQrYudtUC6CvIIyu6J
 BjPL6cueRb7nLHrTs4EK+OQYW5bFh40peA9JV6MUzSksjRtFlfISEH+WjwU2ZnxT0z7/
 iUtnhaYxiRMUiDWGnxHmwEoF51kZG26ae54iRBbGPRf/4jBhsRY46+XmEYjv7ZWetfVt
 lXtImN/j6tea/ia8I1YJTj5O3AfWMJNUanyD+VTVc0JgslghS6n8qSGjM+OoVWumQaiT
 adx/BBtWTJ2DW1CqGzK6HTkXlTap8skKliz4hObcIH47q2a0Xfkiz2+mG8/CKxGgXXJm uQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfdcmwrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 09:40:51 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31A7sSeo002985;
        Fri, 10 Feb 2023 09:40:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtaj0nm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 09:40:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEDmI1NRUTJqGHabyvfmdaCgOexG4J/9fZfbcwTb0dpaIdrxtIUlkTSwo4Hd0t5ynK8ke3xOIP0wqJl5p45CG3BILc3/PCmn4yg/LfbhrN/d+9gNT8uzX7NC9efUSU3t/j693UVJeRo2EW4o2732w8i70KZuav492opIFfrDDMD1dwB4G70i1Uc5ZqHl5KBaT3kGyIvnkqghraAkwIbYrjw7+hRXzqrUZGWmRPQB/Iqhgv4ssn/LAjELO7UGTe5bIqanVhjn84jxfAOJwRY0BYUG1ZBvu0N3Pl3O9JsJx9u3U7pKdrYLW71IYujYxvlbUnjTfpg+j0xRNHkBeuZhEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6d/YsHVboPCnq8UtD/0hDR0GqaJR1EmcvWEfTY15aQE=;
 b=Mcce4QEzcjB76HAzqaw9z1tMMK7TgqRBE9znuuq6BbzZfrjjdHyC2CstekPSkOlsMhCLn1Bc/38MvXIaXZ/tze6miGkcrRos30kEmFGBxUSyRKRh6hsLDv6G7Q0L3wUJI9v8OL6B/fHYYtC48OfXcd05D99m7ltezHBZe4hiIu3SJ5TCoazmosMXOIe3qodYrxDSnbUVzb3UMr5yg9jbrokGHeh6ODSn28vFg0SHAb2TCY9+vc36hRAIWUTk/asYoOeo/rPDQST80jQnxY5kMzEKWYNUuZO2fFH39qHnNcOt/PCGw3c6GvEKApN77ZW5U3q0Bm28H+fDsn7DVSNqXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6d/YsHVboPCnq8UtD/0hDR0GqaJR1EmcvWEfTY15aQE=;
 b=jZuURWJ/7i+Q2MuCtACTvs5WawaarSbmd/4Vl/O9iovb0imT+3u1IyAjbRrYmJP+j/Zv2PEAtptVM7Htlxt2LHLUZas3M1uUc6gnMW1I7gzGnjOl2RQeGEjtR6heut65SCpsysEXNc4VP7oEBc+lNQbptfWDfRMQXl8f4JmzIWs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB6160.namprd10.prod.outlook.com (2603:10b6:8:bc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Fri, 10 Feb
 2023 09:40:48 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb%4]) with mapi id 15.20.6086.018; Fri, 10 Feb 2023
 09:40:48 +0000
Message-ID: <8c9fcd15-09d9-337a-d999-3441f74ffce5@oracle.com>
Date:   Fri, 10 Feb 2023 09:40:43 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 1/3] scsi: core: Extend struct scsi_exec_args
Content-Language: en-US
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
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230209185328.2762796-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0255.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB6160:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f0af43e-234d-4279-6b13-08db0b4ae3f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zfi868DQpWFxR/2SONqsqFfX0x/HolRT17yWKsQ1bhLQ09udldbqc9KSbz9t9STekn+6QSOfPtgIYMsgMigFgMw+GTZyM3VOjRrLL9jvKC5cKekZeMieQDJNVY3nMazAPpMi0Bshy5mMxlf15B74Ucm1NCZBSaZz+V4DEeiABc+0ljtc8lFFQQ2Z251k8diPfCdD0tzP8rXZesZEfHoum5lFz4VtX66UN++C/zZ+XYxXeKOc/JyDBZ89wWZz5Ax6MuHvGywEkZM+0WAwrILVtaukI6HTrm5srMEKDqgigmlSYeYuTw+oPz+7MRD4TYFtxlQAd7WNzwDdcnllzC3djdq5VNxP9uUvdjibbWKRprIZUnwWa63L3X0xatH2ZljoIKHOMlG3LOC1XCmAm0kEe0rI1VIrzHO/vDS/6A8eYqYtDfdcFMZ2Ex0RoDKLCf1g0DT2dTdrfP4rn1E+K4pawQ3etXmWz+Dopo0jJUmMDGed4DpZKpyFO1vQf79SbSSG1gumsGxDXPF4OQRQKXQIjWOx67ynC2FosRWDmErIBMte09ed5GqkZIZocUzUlPu0PAk4L8IH9kWOqIBk4pJBnJIwy6jqU8MXxitHnpyqjxgOLq4yfN2EiicmqbqRTFw3BvXR9apEkab4oiCzpTWQ8mrjvJtA12Xs38bWcW+EJemS2Ar0kqPCQK7gkALIhpqF8B8m7rWb0Btp/WWvrILh3UPNxZIU6ECApP9RnRw3EuU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(136003)(346002)(366004)(39860400002)(451199018)(36756003)(53546011)(38100700002)(2616005)(6666004)(6512007)(186003)(26005)(83380400001)(110136005)(66556008)(66946007)(36916002)(54906003)(4326008)(31696002)(5660300002)(41300700001)(6486002)(8676002)(6506007)(8936002)(86362001)(6636002)(478600001)(316002)(66476007)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UnNIVk9XbWJwL3FMSmIyN0hZc2NQSDJNREtVSXBIVHJUTlFmaGJUUnRsMUo0?=
 =?utf-8?B?cFlCWTNVQU9EcVg1ZThybVFSY3l5WnVmT2pJY2ovUGwxSktROENpQzk4TUpK?=
 =?utf-8?B?MVpVRzZMRE9yV3Awa0JGTFJrMU5LQVFrYnBCZFhrTHZ1ZGNJbW0rYmlCeDFW?=
 =?utf-8?B?QlB0blVrMktCd1BCcS9jM2V0YkNid2doZlZaNFUrMlJWY01ub2tLanpoRUgr?=
 =?utf-8?B?djFxaFdVOU1QTEg5cDBmdWxGL01sQTRralhEZGw5SlRHRkY3OGF4ZVZ6UXhG?=
 =?utf-8?B?S3FMVm1Pd29pOE5KQi9xb05DNWNjOGlkcm01ckd2cWZPb0xYRGROK0R5QlBL?=
 =?utf-8?B?V2hCd3RlSDNMVUhIOGMvT3haenhGS05pejVFNDU1UjRkUG94TXp4QXJ2UG1G?=
 =?utf-8?B?bDliM3NqdDZqOE95OVRNZ2NzSUVadlJ5MGFOZmJiNGMrTVQrM2s4UU8zdzBB?=
 =?utf-8?B?SlJweEc2RThZcnVIVTZuVytUM0RZd0ZTYVhxZXpaVFU5Ykg2TmFDTzloNE9P?=
 =?utf-8?B?THdMdlExWXZ0ZEp0a0pWNG9uV0tkdllqSUVRb2EwOEpFbzgvQzRjMlJFQWg0?=
 =?utf-8?B?TjFSQlFPeFJqbHpyRWcxelBZQXZYOHFacjZHa3N1anduTnZTOEY5K3hkUzRM?=
 =?utf-8?B?WG83WkpSTy91VHBGZXdEYkFZamo4U085WjB4bTBRZEw5aTlUcmZQWVNNQkdB?=
 =?utf-8?B?WDk3eWU5YjF0dHAzMWlBa3VNZkxRalZQbVdKYkUyU2hQdEZueGV1eVRNMkVQ?=
 =?utf-8?B?ZnBVL09EYVZYdXhOcjVwNzNDZUEvUmtDRHZ2eGVTR3FnMWg5SUFsdVdLN00w?=
 =?utf-8?B?SXRwKzdtdUlvdnNCeHcrbTN5MGlLYk1NNWVqcXBTWmY1MUxwUWZScEU5UktC?=
 =?utf-8?B?MVZHc2wrSTRibXNnRk5CblkvYXh1K3hnem1WbmJRbllQUmFxeFVsc2xpVnp2?=
 =?utf-8?B?UnF3N0s4cTlMa3RYeWhDWEpJYlJvRytQeWg0UXhsNEh6R0xMOTBNanN5UW5y?=
 =?utf-8?B?bjJVTEFGb0NoVkF0bHZ3dzYrL1Rpc2pwYWY5NEMzeTdYSDhlOEQyVUFwUHdh?=
 =?utf-8?B?Szl5UFd6YW1vUm45YzNVSUVpS3VzUXF6YmhIS0NNOWZSNE90a3JWRG1UdE1k?=
 =?utf-8?B?aUVHYzhHN3k2em1HWW5ySmdncGpCaS83TGR2Zm5KVS9QekduU2VjSUpTNWhC?=
 =?utf-8?B?eWo2N2dxTUQ0bm53L00wQjhrT2gwWmhSb3d2bWsrckpleHozRmV3Y1dPd1Vj?=
 =?utf-8?B?OHlUejZxYnZMTmZ3ZkNvUkg1TXdTUnZ4ejR6djh4T3FLaHEzUmZlK2dlb0Rn?=
 =?utf-8?B?SnBvZ3BuMGpjQ3p3MmgzVVVld1lndUpWQ1lkV0VFVHdDeVJWb2R6OE5SZ0Fq?=
 =?utf-8?B?MjNVeVRnMkg0alBYN2V4dnlJalBpVmQ4MytQZGxPdnJoRlFXakxncGxJRm1i?=
 =?utf-8?B?OHYrSXdTVWt3WjdmRGFiZ3VmYk9sdWpVZE5MYUlVUjBqdVpOelN2ek9KcnlV?=
 =?utf-8?B?QzJFSTBmNnRnWFFuT0Mrbm91andhVUJKNWlPdjB6V3F6YVgxYWhpTTZ2REJN?=
 =?utf-8?B?TGgrZkhYZHhGSnRyY08yUEx2Y1JoQnlJOHVwd05Id0ExR3hvcGdNUEtTbkdo?=
 =?utf-8?B?dllUUUJpbFBPdTNwMmhleUpuZ0hqRjlqMXpHbXRrWTRUT2NCRkt3cHUzVEQr?=
 =?utf-8?B?VHJWZGM5ZXFkcXVWUUJMVHk4UUN6b1kwWVpOdzNFOCtXcUYrNVVLV2RpUHAw?=
 =?utf-8?B?NTJKRVRONmd6c3hhalIxM0p4MThsWlRvMDZCTlRuQ21jZWM2ZG9SVE9zY2Fv?=
 =?utf-8?B?eFJSWDFQZU5rUHFzMkNXcHg1RW9UQjZ0YWIzSFVzNTFZRnNqSmgveXRJQUE3?=
 =?utf-8?B?VVZpUC8wNzBkVTg2N3cybUNmNjlEK09QZW5LM2t3bU5VdlhtWUFweCtnL2lE?=
 =?utf-8?B?NTBJdDAzVnJyNzFmVXROdnBjd09nd3NZSkVZUG9Cd2R4RWdkdHBoemJ2dEc0?=
 =?utf-8?B?bFZYcUE2U1NmWlpSYTlyQk05bWkzZ3MzbHpxUFFKeFAwRExoVHRaaXRLUStu?=
 =?utf-8?B?VEY1VWF2c09vYWNhUUpWazExSFVrZ0l0aFZ3cDlaTVh6REhjZk1ZVlpWclVj?=
 =?utf-8?B?K1N4QjFIMHBaYU5sbUtKNXZyT051a3VnTGxhczAvRkRBckZpLzQ4WWczUU1Q?=
 =?utf-8?B?dnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bpMD8PRLfD/ev8G70AleWMmkAsVGqagvvJcsC/4Yqd8CzRvEFvl08iZbrWRq3rmEctb3JnlX9CYu8s44ehQcGbZPaKtd1NdaOhzclo9FMfcZyqy7i/2NyswcJ8zHu2EXv31jOS/Q0yt3UF/oAKMPf30xCbFyJSsL2amvwpqO1bfIuaCBWu1ktGeuTICl1Ajzv12gJJ4LAQnqc5tyrQsAI21rkpHVbS71ECOvdnWQ5fUQdxfaO72YDdi74Lqp68sAdUU+vy/dBd3cY1MQD/zsJFy5aPIdOzi9h+8Eku0XUBcGWRYi9q7xvgNfO9vjM7p0Ey618nBIKOGEOO1kmZ/fZMtMPkmkLfq5M42/GSZDctkaXN/qOxBjUOCzq4Cal0GwR2FTR88QQWt3sG8cnYboE0z6E6OGuJO8eqmd6je3FriRfxA7TUS7u9hn4Q8BBgWaS5dK0811RB3zrAMHYRlESM82GXgau1qDV9RpuoaSs+/JqWmIabiwj0d6VAn9yTb4Jh3JBf69BEFClGCJYjwixBoWSiw2jJ88F2oVFjiwqSYKxeu8WjfyWJsSoiA9J2Iejk0j7/10oi1aZaZkdGlJ+f2llSVY8j2pO2IJhLRzSZ90vAOpDCsZXfZn36XbNdgwK9RzsJrsQ81EwKp2XY4QEUGYOFxgaPV7IoGP3ctaugSCgn8JP34jZ6QLtxqaE25c0YluSWkjCHNcSpRQ+593DpoV9vHpFcItn+/U+5fXaqgqJXhruVriKetIjUWD4vcDvnyYibI6zhTGKl/C6o3MI4RyzFa4HkjmlTdjTZ3r+E2aYs5IL0CSyPZCcWRmdJBigxaDQ0Cm9T0Gt/4f2lX44/2a3JX00qb/wb7EDY5EMGn0HYvnQR0R0i52qPjc5VcqbxVvs5se8RuKAhxyOSYofg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f0af43e-234d-4279-6b13-08db0b4ae3f9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 09:40:48.5660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UEgCQNercouv546sWyNO23140ExF5qKM9u9PM3/PrdPKD0sEkNbflBtbXo+48kIxYU9iPaTs9P3JtpD6V6NVWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6160
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_05,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100082
X-Proofpoint-GUID: vnd2CdferAbyjCakIBCGSuh2sofnPU5U
X-Proofpoint-ORIG-GUID: vnd2CdferAbyjCakIBCGSuh2sofnPU5U
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/02/2023 18:53, Bart Van Assche wrote:
> Allow SCSI LLDs to specify SCMD_* flags.
> 
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Just a couple of nits, below:
Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/scsi_lib.c    | 1 +
>   include/scsi/scsi_device.h | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index abe93ec8b7d0..b7c569a42aa4 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -229,6 +229,7 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
>   	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
>   	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
>   	scmd->allowed = retries;
> +	scmd->flags |= args->scmd_flags;

nit: we zero the scsi_cmnd payload in scsi_alloc_request() -> 
scsi_initialize_rq(), so don't really need the bitwise OR. However it 
may be better to keep for change of scsi_initialize_rq() changing in 
terms of init.

>   	req->timeout = timeout;
>   	req->rq_flags |= RQF_QUIET;
>   
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 7e95ec45138f..c7bfb1f5a8e7 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -462,6 +462,7 @@ struct scsi_exec_args {
>   	unsigned int sense_len;		/* sense buffer len */
>   	struct scsi_sense_hdr *sshdr;	/* decoded sense header */
>   	blk_mq_req_flags_t req_flags;	/* BLK_MQ_REQ flags */
> +	unsigned int scmd_flags;	/* SCMD flags */

nit: scsi_cmnd.flags is an int, so prob should keep the same type

>   	int *resid;			/* residual length */
>   };
>   

