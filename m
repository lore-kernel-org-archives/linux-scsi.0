Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 374E3E7D0D1
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 06:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjIVGdp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 02:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjIVGdn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 02:33:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6030783;
        Thu, 21 Sep 2023 23:33:37 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LIsMXq011448;
        Fri, 22 Sep 2023 06:33:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=fTZtHObdvKnKFWj375zV8AVQTFBNZaNnbN7h0N0wWd0=;
 b=ARcPMg5leF1sK4lMKMWm804Gk6aCzWDfO/8vAerHbxdSR+tp0GZBzCK1E0lh3TwpXOgv
 oJ8/i5PZGmlB0MEdLii0BhgUQlgW0W/SaAwTuEoXsoAWl+vLuAXm5Jjn+V6/ZMAc0rCX
 9wAmd76u9JTFqWgDuBtnNf0PA8myleq9P88+hALiudBhuWaROmY/Cgw2baajwRLujsWc
 0muTf5t+gvEqGVgZKsUhM4wBpU7Gj/zLKRPB7UmXVhekfYsNyED0qqVDL9e516RFnN95
 9043s2Z2ioaPZcF8pGyHuhm4jdAXs1KjQ1pwS9WH8N2qlUCl6/hZB5EwcxDWLVbY0e0g BQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tsvs01v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 06:33:21 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38M55je2039525;
        Fri, 22 Sep 2023 06:33:20 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t8ty23y2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 06:33:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvOlzaq01wmb9EACITAaTIbxuxCwudkD4r1QQU/XKxearYBQ7dr7RmxAWR72iwaoI0rJ6qBJca1SbjbsNpwJmb4lSlZpB8j7m9k/nMJTcDdmBUATNixLQ++D18jfgd9X4tfPR4NpCI0fC/dre47tt+uxaS3ZTJ3Zdi3Sid0uEuVclnF7zrumqw9fBTor3TGJ88JeP/hy9yg5aK38bfrwJ8+dKWUXsivIMlZ0P+X3+Mm1Nx6TACF274/TyosBJOUFbNb7MEIKt98CmVoHM8srwc4nkoYiNfJEsLBsPEr1fgGNjrAVdMa8hcHlH1JxF6ao5XQ0yElyZL5bhWRRdDNsAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fTZtHObdvKnKFWj375zV8AVQTFBNZaNnbN7h0N0wWd0=;
 b=XLVpWmrc1CrZyXG4rU88Aoi8Oby3Joa46jPlQaS9JpoaywN44YmnDdNiSI0oogKUO+jk2F3RUuiB6aMPlxZFH64NN2JPmb1iMwhm3F0ip2hp5/iJtgH8IBs0ER6KIonXGmBnZQJgLl+th42rDv5SbjB9N+gP9cSDqnz+aDdaaR1l2CEENDFPc/H2O1t8otRNL+RDYvICfG/a3jfFO3h6VB++5zalPil4CeUp4Jjw5fNpmrzqyX6vtaBXDJfJx4HJ/mViw1b7dcnUnX2IjniOt5NIVhWywgYzRE8QhqpCYV+1/FXM4Ttcc2FmDi3vCCmon+WhMwW3EFtKAmfAxxU+kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTZtHObdvKnKFWj375zV8AVQTFBNZaNnbN7h0N0wWd0=;
 b=XplwSdslzvgaLwxq1dFhgFIaWTlfouLBhkO37u74xnkdrNiBbl14hmEWd5Tvwz5II7COSxI2FoTOLJhkgb/J7me6bxm38glFbdcPetqj+CBEgFk9FzEl8bObOEyrUefozLPtuawLvkFvzWQmNlp5oq1LqhQvl/UC9ZBL8Y6JjSI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB7184.namprd10.prod.outlook.com (2603:10b6:208:409::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Fri, 22 Sep
 2023 06:33:18 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 06:33:17 +0000
Message-ID: <8542623a-f994-a06d-4bbe-a253dc9fe925@oracle.com>
Date:   Fri, 22 Sep 2023 07:33:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 03/23] ata: libata-scsi: link ata port and scsi device
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230921180758.955317-1-dlemoal@kernel.org>
 <20230921180758.955317-4-dlemoal@kernel.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230921180758.955317-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0069.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB7184:EE_
X-MS-Office365-Filtering-Correlation-Id: 15ce4e05-cd5b-4945-7e8c-08dbbb35ce8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1t0S89E3582p5r6WGUzFtJj57pmU4VIORrn9oRLJsgciV0HnMn+W56q+O6rK4U2WdJiHN6nxYE/yaf382I/s71JpFLSiRlwJIWQw3IsgGbo4/d4Ixx61HCACxCuc7sU7FgryququXgyI3Qs/3mpDi92TvmxPI5IQdTU/pgAlLLkTzhMW6bUMZZH/PjEzaUUFq23KI61XusB/lfw5pkH0fCavo9x8LJWFN4br5zbz5TrDE6EjwOQOwAdVS3zEvszF2cTfRs2y9csYgmYFPAbKe1r0ZNsykUFWlbWlm3ZW0bVea2L3LB9Ma5r1IRmeZt9c7XNdLM0LPwS8D/EtaY0JrCLtiIwTVJcRtTYyfeiLF+d5LDRMmv5yvd2pt3iY8s1+Ll3VBsENCMSZd6NZo5mnwdrwpaEpZZ7bMgOjKPkgUjC/PjKtb2PmZLeBA2TPHJFMmWi/mVudBlNySOgB87PA5VPQoIOu+2xRrIYlDbcVydQpfR8WNV8/LNBjSpPeUciRSqZnxDaf5phV6ZRbMHdubkjm8X+rHsmCXW2n2fC0NJjn2S3gS1cIFpjaMDaFmx7LPqTi9EOgQ9x9tBPKVb3dJEcn3/nwHCX3zsSs88jtKFwBOgPjBH0EE1y2qB3ZFG435Klq61oZVvex6FoZxkTV6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(376002)(136003)(366004)(1800799009)(451199024)(186009)(26005)(53546011)(6512007)(2616005)(6666004)(6486002)(6506007)(36916002)(36756003)(41300700001)(316002)(54906003)(66946007)(66556008)(66476007)(2906002)(86362001)(31696002)(31686004)(8936002)(8676002)(4326008)(5660300002)(478600001)(38100700002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0UrOW1qNUZrQmVXZFgzQUtwLzloaFo4MlpwWW1BSGdidVd3M1J5RU5wQVVE?=
 =?utf-8?B?Q3l5MzVuQWUvNEJKN0hEOFpkS2tlckhjN2FyQmRGUGZLdno2Y2EzbU9DbWVL?=
 =?utf-8?B?QUxOZGFJS2JGTnV5b2g4RGFiWEowZDdOcWNIb1F5TWFrOTdZZk1WRzZBclFI?=
 =?utf-8?B?TGtwMG5tN3Ezd1UrQktTQlBKTzVWaHVpR1FSWHJwMy9GVVR2Skc2VlpEZlRm?=
 =?utf-8?B?cEsvMkxHM29uS0xkanpFSDk2cXlzWkxMcEJnc0hqeWVtRE02NjVCMGdDWlkr?=
 =?utf-8?B?T2JQSkVIcGcwWVVtdkRxRysvSWgzMitQWW1PWjNoaHhhZEMrc3FNTE9QWFJt?=
 =?utf-8?B?bktPKzFnNDFLRGs1Q0tzRGkvWXIvZzVyVnk1STdpNmNPKzROTWNNOWpKZllE?=
 =?utf-8?B?ZHBZek1HOER5STB6aGV6K2VCVzkreWhpczg0dFJZdnJhNzNOaHhHVExSMzZC?=
 =?utf-8?B?ZHZFNWQyMEFFTXVDZUtMNnBvbGdXNFNXOVhTcmZEY005bUdNQUJkdnFvL1NS?=
 =?utf-8?B?ZEdUK091NHN2VzVoY3RXaEd0SnhPcWxOYmFzcWp0UnQzV2NhSDFoQksyblZD?=
 =?utf-8?B?VXJ0Wnd3UEhYNTdJVDU0RzB4UXk4cGVXUlZJYVJTRklJZStMRFlSMmU1Nml6?=
 =?utf-8?B?cFcwZEJlLzdidDdSbWV3aFc4Y3JwNlV3WTUxOUZGR2RQYnpIcnMrWDhDNjVw?=
 =?utf-8?B?MENtVDNsL3VIMmhSR0Z6Qms5RWFZNDF1b2tieFZ4QjVRblFwOTJkUks3WjZX?=
 =?utf-8?B?UWNqN2YvRzNZOURoWmdObTZqa3IwVnhzUFNEMEREbUlqZXhHVXhMRmM3UFhC?=
 =?utf-8?B?bGJaTi9oV2dIVmZsMVdSbUV4QWdJcFZIaEg1QmhZenZEWnVEZUFTcytITnJT?=
 =?utf-8?B?OGJGVUl2ZE01T0E2QzB1eHJlSzIyOUQveUhmS0dlN0dFSGhsaUlkcnZCbG5O?=
 =?utf-8?B?dzBOK09Yc01welFuc2w3dTdVTnAxMlZmYXdsekF6cjVuOGdiaHRscUQ2bTA3?=
 =?utf-8?B?RE5PUGViUVFybDZUblVZUHpXZWVvQ3F5VksvRXJTN0ZUenRVVVlVK2VPbW1P?=
 =?utf-8?B?TXZWNE5ENXVXTG9raXVvZXRNcnBDd3FqUEg5aUdLT3F2TGxlT3BjaEVLNjdq?=
 =?utf-8?B?Q3U0T1NYVWRQbTNpMTE2VEphS09GU3M5UTdWeUZRYjJ2aXJJb2QvVTFURlNt?=
 =?utf-8?B?SWdaSjJhcER0cEI4N1dPaGNtMEJIcmMwZ1o2UnNLRkdTL05NR3Vva3dlOTdo?=
 =?utf-8?B?RDQzM1hySHdyWFg2c1lsWFg5WHAxZ2duU09WMWhrdXZjSWtLdEp5T0llZ1NQ?=
 =?utf-8?B?ZCs4ZzdpendISXFHWldqRjNtc09xaU1pQzhuZk1xL0RqUHE4dlZ3QWg2VytX?=
 =?utf-8?B?bWI1VDhnVVpTbEJmT1ZsSTl4ajluNTZYYWxjZ3RIVDA3MnZUTTRLejJ6cjJJ?=
 =?utf-8?B?VVhUT0RYM3hMcklmRGhROXlDR3pPY3ZBbVhpQmxJZ3ByalBBdW9zUUN6bldj?=
 =?utf-8?B?aVZFZlNCVHVldksyOEcreHNZRVBDNDhqZW9zNEVYQmJ1RHBCTzQ3MUVvZTRJ?=
 =?utf-8?B?c3BLNWhqSVZwUU15amNRdnJuYThuTjk0TytoVXljWFJBdUE5TE5DY2Rtei9V?=
 =?utf-8?B?cVB4cis5ZXNPMUY1ZHFIS2hpaWNlVldid1IyeTF1L2NhRjFyN1JtNXE5cTNu?=
 =?utf-8?B?SEhyazdTb2pHK2tNeG1rNE54L2l0M0c3bjR6QWkrL3pNSkNFcHJyNTFEdkhv?=
 =?utf-8?B?YlpyUSsxdjJRZkx6NlpiWEdKSmp2Wk4yMkFDdWEzUEUxYzR1aUE1aVhBZTlJ?=
 =?utf-8?B?d3JGSHEyUzYyc05nOWd5b05hWVM2eTBpQnZrTHJjYnF3UDFVbjQrY0RSZWdE?=
 =?utf-8?B?VTFodlFsZFl6MzVaQkRmSS90MlA2WDJ5RjBtRVdwWVJEUFVIcy9OZ2Jqd1hj?=
 =?utf-8?B?MzkvTTRIY2wvczJlWTZjRTl2Z014QW91dG9mRXRnQ2h4ZGxJT3VQTVh5OUNm?=
 =?utf-8?B?Umx0N0d5VEh3SWNZYVlKbmZGV2NvR29RaTcveUpXc2NYNko3RGt0c0pUbW91?=
 =?utf-8?B?Y2hxZUhEMTFUR3doKzh2MmQ5eFBacWJaeWk0aHhjekFDc1BNMDRIci90Tk9w?=
 =?utf-8?Q?44Mqw1ba4j3ALQpEaRIG4/kG/?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bGxYbjlpRDhKckpWYm4zLzB5cWxvNXFXV2Nuc1NzMzVIMjRoT0VYSTlGb291?=
 =?utf-8?B?NHVJWlYrZnZ6Ry9XTG5vL0JJZHN4a3UveWk2OWNFaXlrOFpIRUFDVC9MK2Zy?=
 =?utf-8?B?MVJXcVljbUZFcTMyZW41bHE2WFVZZk1JSXdnY2hNOUxQb09qNXAzZmZOaHNX?=
 =?utf-8?B?WnQrTTVicVBrYnUzdzMvN1ZFQytMSzVvQnJjWVBUclR1SjVncE52NFVySStp?=
 =?utf-8?B?WE80b2EzQXVzSGJpYlRuNENuM01CN3Q4SWtlZnVyLyszdmlFZzd0R1Z2Mys3?=
 =?utf-8?B?Vi9HTG5IcGcvYjFZMHlEQmRoSWlWOW0rd0pZRjhjVUlGTzJlVnNnMms3UGRP?=
 =?utf-8?B?NUpqMkZDTzBJcDU5Z3E2TkZmTjBlSkNUbDZaR2xuS0d0T0UwOTlHbXdqaEJr?=
 =?utf-8?B?MkJManB0cWl4NmV2VzJJTDR1Vm05eXVYejhsbTdhUSt4MzJ3a2ZUTzlTMUJj?=
 =?utf-8?B?SVpXMllXNUVmcktJU0VYejFaMkRJSkxFT21WZ3JXRnUybHlObExBSGd4QUpj?=
 =?utf-8?B?QlplQjMvc1R0TGtMby9pU0pVOUIxRFRpcUdMQllhaEJIUlpGc1VOS3RjMmNX?=
 =?utf-8?B?QzEyY21oZFNlYXhnTkNlL3U3c1lYQjBRbVhyUmlCVlo3dnlvRi9zYlZadUtj?=
 =?utf-8?B?WVlqbXVYM1hYb0xCeFFXYVZpYXNvV1ZFNFNPbzlNYWRxaG13SnphNUp6N1pF?=
 =?utf-8?B?akZyOXZhSzUvQnBoTkdzMlYzSXZxdkF4cFZtVEVSSElDQVBCam1jZHJUUWZT?=
 =?utf-8?B?NVhIUWYyOFEvQ2liNGNtTFlER05jQzJmTm1LdVM0T0V4Z3lFdVgxc1BzdmpO?=
 =?utf-8?B?MnZabWFpQmlsRitpbko1bEN0NXM4aW95Ni9SSTBTZG10cnpZL1BET2JjOWo4?=
 =?utf-8?B?SjZYcnZtSTc0aklmZkpJVC9zZlJSa29BT1I1Qm5aTlh2cjYwbVRjWDlGM2M4?=
 =?utf-8?B?TkEzdHJKSHdVZ1BBay9nV2dBWHNiSHo0RDNaYWxFVzM1TlEzbWRJdTN3V1Qz?=
 =?utf-8?B?aWZoWFhGV2NEOHBYeXhxRVA1SGpKRUNNWUtwb0NpNG5jUldnOXNUSHcyTHhq?=
 =?utf-8?B?MVIzd2o4UEFpMWhwTGFJVUp5ZjlERlBGSlpYSTlkZ3l1TmU1ZnBqQjNLdmZN?=
 =?utf-8?B?azRvSnZxRG12TzJwYmk1cVFOUXEzYjF6U0FIN1VyeUtsOUxxS1hkRFZKQ3d0?=
 =?utf-8?B?cytUdTRtM3prUG5VRjZ0SHdrWnBZVlpyeDdKZjc1Y3p6WGszNEtBNk1FMkYv?=
 =?utf-8?B?dDJRSW8xSStGaEt0SlNLTUhCdEErcjQzNkVNZkdIV05KUWNkQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ce4e05-cd5b-4945-7e8c-08dbbb35ce8a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 06:33:17.7789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ceNysyjxxzTRaJEnQKFaH0RvcXAvJ/nmsRkSwtZY2a3WpENPQbu1+xim8Dszu9TKfcucSoLUXIMZAg1ObWnRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_04,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309220054
X-Proofpoint-GUID: kYCrndr8vPgouTvkYHZgtJmPSzUDaTxp
X-Proofpoint-ORIG-GUID: kYCrndr8vPgouTvkYHZgtJmPSzUDaTxp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/09/2023 19:07, Damien Le Moal wrote:
> There is no direct device ancestry defined between an ata_device and
> its scsi device which prevents the power management code from correctly
> ordering suspend and resume operations. Create such ancestry with the
> ata device as the parent to ensure that the scsi device (child) is
> suspended before the ata device and that resume handles the ata device
> before the scsi device.
> 
> The parent-child (supplier-consumer) relationship is established between
> the ata_port (parent) and the scsi device (child) with the function
> device_add_link(). The parent used is not the ata_device as the PM
> operations are defined per port and the status of all devices connected
> through that port is controlled from the port operations.
> 
> The device link is established with the new function
> ata_scsi_slave_alloc(), and this function is used to define the
> ->slave_alloc callback of the scsi host template of all ata drivers.
> 
> Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
> Cc:stable@vger.kernel.org
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke<hare@suse.de>
> Reviewed-by: Niklas Cassel<niklas.cassel@wdc.com>
> Tested-by: Geert Uytterhoeven<geert+renesas@glider.be>

Feel free to add:
Reviewed-by: John Garry <john.g.garry@oracle.com>

