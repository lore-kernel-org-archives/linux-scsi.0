Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E7ECA0EC3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 07:43:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbjILHnm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 03:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbjILHnl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 03:43:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F1F10CA;
        Tue, 12 Sep 2023 00:43:35 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38C7EQPE011531;
        Tue, 12 Sep 2023 07:43:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=cfAf6lt4dz0Sw4bbdy4WiEcWj+0NWm8pE5u1rJ7bVzA=;
 b=bORnUjTLMN8XgY0Pm9V0XkhdLdC61uUbXeqgN6w4aYRhu5VWOWLFV08sSCbsxT2hUTj5
 WT5ICOYTdPUhLt1W63hrDsl/mMUxtXDqXFFPzeKU6rMHkoV1idJclQxn7lfCKmrmrnY5
 PqSwk3ES/MqAXHAlPL5weYXznb5CpscWKZTXyBaWjOk14l4kyygAORHVNVV4pZ4kuOcO
 4wXAVUdgW5e87A+Vs/d3I/XGB7ScF4bFNeUruXFh/AAfP/V6U1RSDa8cNUFwnnfbLEoO
 yq5Y/6S1lzLg1i8z9eypUXBCJR2cwB5uvfB61pqkXkOjRDEA3shul6JP6H1cjXwadWpJ SQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t1jhqbbg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Sep 2023 07:43:15 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38C6gf5H015075;
        Tue, 12 Sep 2023 07:43:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f5bmxjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Sep 2023 07:43:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mV+KUDL3z1G2/loGBfAVTdEUOeiY7WoUrtnsY4wS1ciOK7RQ3BpZ8eDkTOwweQFRNiRaqT1o5d8yA05ZMg4edKSWoDuWqc4EoN3RP897xvqEagqnTegAer+KXYSrzc+m5zcSpWVdgDHfBp99lnnoVs0gfOWz3EQ3ycOrwLFJZda1UrviCVV80iT9atjKDtIlEIfeV7mJ25URYR5hJ4uvPmo6lulL65l3GcQzvnlqEL/or+wqwgcW1p9SE2uTiIdnF1irfGD6sTLrnjvWAGJ9rBobG9A1jGWVgCFoAjZssQRgWTYj+aNgXEUM9wukOf37V17YI5dvLRfFjSSXSht+fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cfAf6lt4dz0Sw4bbdy4WiEcWj+0NWm8pE5u1rJ7bVzA=;
 b=T0AOuqzidk+btoyziXQVjlxGrcDsAz7aVRPls+otTLmseW1vwgfzbPMV+JaKA/v68seaXeocYJOBesk/qjBx95TEj/wG4wbVYdCvhIPpsDonxhldbRZQjyg6lQbeDOmMvoH34BqdQ3wWBu1WX0D9/z+QE0xVv30KppUFXWbItL5+1Di0mRA57H8ng/uYBkRgAc3l0d80IwZicArRDtXsOJE8J3PK0tdpNj5sXDzQpyZMPMLW1rPp9iWN1YYzTs1tgWAc7OUTKx1t0skojdNKVorfwgtx8tL5dwdxLwLdYYvNvKFhEkG1pbTGqfnftDHoT1og3nzCeZ4h/LTr7zU5TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfAf6lt4dz0Sw4bbdy4WiEcWj+0NWm8pE5u1rJ7bVzA=;
 b=aXZEDcy6IVr5h5y0V7BvjlUnM85bnXL9owJ0dQ06QlDNZGIbz0oqHIBqd+vyNfcHC1MzQAWeT1TmffIBZES12G672XzIilLoBi9oHogePr1ntACgtCi0HB266A8dnsjrF7PPYu/wwUmDPeGA9NW1DskmPaBUXHw++iX6+jHb+vE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB4828.namprd10.prod.outlook.com (2603:10b6:610:c8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.37; Tue, 12 Sep
 2023 07:43:11 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6768.036; Tue, 12 Sep 2023
 07:43:11 +0000
Message-ID: <6b137561-a5f0-4dc2-c4ff-1c31cb1a0c7e@oracle.com>
Date:   Tue, 12 Sep 2023 08:43:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v2 18/21] ata: libata-sata: Improve
 ata_sas_slave_configure()
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230912005655.368075-1-dlemoal@kernel.org>
 <20230912005655.368075-19-dlemoal@kernel.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230912005655.368075-19-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR10CA0012.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB4828:EE_
X-MS-Office365-Filtering-Correlation-Id: 22e62720-230c-4fbe-6175-08dbb363ea24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jdYkRxOs3bGf5EnCiSXHP01On8Ms2pyc91oaoCRtEzu01BaYpgO2mVbLjQaNoiLvRmOnKAuK5xvfklbFjFcoh6n+qOuRYKNbgc8mP6va89M13QbxpRbwKhXa2hMauyiK/9yAIO3tta0y+bxLfefpTFZT0sItBn3W80lNcz5F4FYByDYjOR0FALTQDMwL4LhO01lGWNiHgmiMcCovd2/6Ic01NuvMHwGbHwmfrGQgicX6KdHiqWZn5sPk/N58PpzGcMZNQTA4gKvtpA5Mh30qQUJ33U6mR6lkxUI2oftoGKxToK1RMEj+c2mMvAdfCbMIOwXN039ErgGfq8gFumL2BMOzYbSaJ18FwH9a0JiJPE12DkiRqQfjCtGf9+mDEdEu5StM3QWk+QAZ57dHqmrxo46vqrMxz7cuL7VHPpvLshSEo3zQbvh9onyND+Gs1LVn63WlTbzFkG3YMDEwKWuV81dxv8lH7lMFnpukOucBr/1eLWgEzL+u/bI5x8rmo5PFZRS0PHiKUmQkgosO+YV9niL8BXgLYDp22ghHwHPyDqPj3EJjZdI2njryHb9VkKHCEQnHQKg4IrlnV8vaZMUX4W4By8ySi1T6vS3OuujuI+HSvwvZIdM7V0j3p6gblCpMATFM2ytoN02RWoprK0escQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(376002)(136003)(39860400002)(366004)(1800799009)(451199024)(186009)(86362001)(31686004)(31696002)(6666004)(478600001)(83380400001)(2616005)(26005)(6512007)(53546011)(6486002)(6506007)(36916002)(66556008)(316002)(54906003)(66476007)(4326008)(8936002)(41300700001)(36756003)(8676002)(5660300002)(66946007)(2906002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SkNkQ0NXMm9icnNaMnpxbklyRVNRZ2hVZ1RsYWFPdUJPNGJWWXpxSkdjVXds?=
 =?utf-8?B?WE5oMUljZ2lXWmh5ZHNFdVJiUnBvQlF5V3NIQmNRNjZrRFVDSDhCSmtpVUV6?=
 =?utf-8?B?UTZBenF3a3ZOZyt0RjlDMWROczlWalMxWEdscmtwL3BaUnZSYk14L1lpZU9v?=
 =?utf-8?B?UHF5S2E5VHJ2OG4rVnkvSGRvOHkreTdkdGpoTUJYMU10aDJwUXJyQWNrdDJ0?=
 =?utf-8?B?eTYzdm1IWXBsc3d4UHdsZEZVeEttais1RkpoQ0VvdmtXWXUxMmVYaHZILzJR?=
 =?utf-8?B?a1JIYkpzZkVZZUhuQnByNXA3cHZRVENWa2NBYjNDUEpoQy9XU05kWjAzeUcw?=
 =?utf-8?B?OE9MTEFLZlE5WmwwQmhSWFpBaCtBNUJPOEp1K2FBaUcyUURSMkdTc1Irb0lM?=
 =?utf-8?B?L1lnMlNUdlhZcHo4SVd6QTV1bWdhSTJvRFBSWHN6MVpqNUxWVUNYZitqQW9k?=
 =?utf-8?B?aGh0ZlFMRmJwZFAvTnBUTDdhVSsvOVlxM3lCUmJEdUhpcTZZYXZQOWNnQ0M5?=
 =?utf-8?B?SURZVnVXOHV4TytuNmt5L0MrUFo2UWdiWVhMRHFCbEcxQmVOdFdtUTVCdDRr?=
 =?utf-8?B?UVJITlRMRWxSQld5MUp4TDRSbXlPeHowS3FMWnByOU1IUEZBU2VyakRmM0xJ?=
 =?utf-8?B?SFZxWEdMR0lzMjdtNmRBUVNOREhsdHBWL0xUOUt4OC9wbzhHRDIyTklZbU9J?=
 =?utf-8?B?ajdjUy9XZFBiU0d0SEZmYnVrUzk0R2JLdnZtM0l1NzFlSTFSejg0TTMxYXpH?=
 =?utf-8?B?eGpVZlRwTzVjbHBrMkVHUjg2ZTAxT0JCaXlMNW53bGJqU2FlbDBpelZ0cWxD?=
 =?utf-8?B?Z0NKVHc0K245djViZjdiZHFrNXBVaENLUmFhU0FJZnpFY1IrTzlsL2hxM0o5?=
 =?utf-8?B?WWRFNVdRQnovNHBEWSsvdmV1a2JpcTJ5a2l6UUZpUnEvUFZ6cWRydTdXSEFF?=
 =?utf-8?B?Y3ZIekZndFF0SVk4VUpWZ3ZOQ0kwTjNKTUZCR1pZNEJPWTRjK0JEUUVVNUV5?=
 =?utf-8?B?RnJhb1g0d040L2FjRWxEYUpLOE1YREJsOUdqOFBEcGFGN1pmRkxGcENPczdX?=
 =?utf-8?B?NDhtTWdyTFhsczdRdWU2dHRjRVBObmhLN0YzWXMyWkZOd2tnanhrSkRJZytS?=
 =?utf-8?B?UG9maUFmWENtV0NUbmxacjZIN0VhZWpKdUNMSmp3T01HQzFXZDR6TmJndTVw?=
 =?utf-8?B?My92WmhNQjc0QTJBRnVFanBRY2Y1d0R5T2d3M29NT09NclUvYXNDdEFhY0No?=
 =?utf-8?B?UUN1RXVYRGozVW03bnRnbWlIaWdqUTZHWGN6aHMxRjI4QWlWd2FWd3dkeFNV?=
 =?utf-8?B?KzYzSnRTL2xoMm1wZzEranFlaERVZnBmSjYxQmM0d3pXVUJSRktZdS9adVd5?=
 =?utf-8?B?YVZHT0JVN3NSSTdrTUZuNFNZMDRGNGRmYnJSdzJzWjNnUW9ZVC9OT1FtWGUr?=
 =?utf-8?B?VVErN0ZNY3Z5bG9oZXJ6TDdiQXI1TEdabEsvZDRqTjJHelNKOWRaejlwQWNu?=
 =?utf-8?B?SXlqZkRidGJ6UDkvbVVvSnZKaEd1MFJiVVYyeUtZQUV2YnlNOEtqNG1iNGx0?=
 =?utf-8?B?dFBtZ3ZldWhLanRkMjEyT1NWUlJxUngzME1yc1FSblZSUEZjV3lBOGZJUEl2?=
 =?utf-8?B?d3NETEtmT3VHVnhmaXBES00rY29neGNQdHdJWUx4L3g0UmRTOWVoV2pNRTV0?=
 =?utf-8?B?djdlU3BNblE1NFpDOVpXcWV6VUc0SW1QWkRYZGYxLzFYTk51b3piN3BZalg5?=
 =?utf-8?B?WEt0b2hYdjlVbEVzZDYrcmNMZUp6elltQnA0L1RianpBN3kzNGVVRkFKNysx?=
 =?utf-8?B?YWFKNlBFVUlncHQyam1EajN1d0l2NnA0YkZweTdtelgzNkZhb0M2MEt3UnlC?=
 =?utf-8?B?Y3Z6ZzBKWVRFcXNVNXlEUWkvZnlHbkx0bHpHKzlCMDRvMWVBSEZTSUZQdE9R?=
 =?utf-8?B?bjYxN1JKbVhtR2pXbzhpOXpTMFFjc1U0QVY2UHdmZ0FlMS9sTHVLU2RRa3B2?=
 =?utf-8?B?WFhYS2ZYbFFaakpTL0MxU3RmTThLcGlDeTFrcHdIeHFHTWlySXN3UWhrM1la?=
 =?utf-8?B?T0pEcVdRVExLWk15NDVYb3h5Vnppc0JZZGtaVXVsY2FzeUZ3dzF3eDZnVlNq?=
 =?utf-8?B?ZlZmWXNoc0JEdTVRRm9GQTN4c3gxamRVOTdHWnBobnkva3dvNXRmc2hQejJk?=
 =?utf-8?B?VHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: dZ8C5TvTAOiFIJSCy/HNthatsxb822AcHN3M9Xgqj0+ZFu2kJgnfGYD5a8erutqtIlqz4L2/uIX0BByDfbMvh6l7AEeEpN5DbJnnNR90XjyN3cwLa2s7YGobeU1V2lXvM9hpM3vSVzdxUzVhO+Jrctynm4gQy7BiCOVSozZFsw/vOxFTciVVKHFxZgQI3t5+ez+NzRBMXLUFzG7Pdrz9Av+PGutg/I/dqyOdnCK0xsGtmesiqc7srAgknlOTyFoZ61h3FIkG4YPIkIKP6q0VYvzX45H4tA2CRR9zeyIkBwSP++v31pDbrkMSmRmGSXfzTCg0dntlA3n0Dw+t92LMsik2OINjGnP1zq7gcADbsj4W3TrX6xjUdhmARb1zM2iAX6mwxSuumhjx2reJIsdM/CzsJZb8H5Uf2bMKOUT9WDYrTdD6Ma4nzF0//8jsArvqv3QxWukyXQ71WK0wELLXvycS0VPa39HAm4Y/nmgZv+fu+fxf6IfDW2RUkQXFtCtE7owISedaKer3MD2/T6XyiEG6lyfaLrzYfbvACLGq2gtnaPNXcWF+G5/LIlQhaiS+ObeQTVt9a5KXzemSyQjkA3x+LieDhmBAYQxCPAQyuWLylSxTxhY7gto0vfcr0Yiuu+BKF7ZNPLBl8LyJiuxeukYs7WlMvPqD9YuUnF/RTZzLq075Izti20rpac1oxdGnb/nKwAtIl7Auch2tYGmzJ59FjhoPejIvGk1QnJeG6pxNW1q7FjDU6EFehJlxzZfDRv1OcFfa2ZL8jcg7MYbcXL3jYMw8VdJ6r2xpxu4qRJYsBbjKJJn+OrhWHWkzFR8OsR2DzZuKanXZGIcut4mPl0K8vxm2KNsWOxO+ptrRyCwpiZ3AtdJkVwYApQ0BGlgRGs+vBcQ4l1mtGaNbSspM3+TdAobb84+xIrrQmX2zuQg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22e62720-230c-4fbe-6175-08dbb363ea24
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 07:43:11.7788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5v+xfDvDZnTVqBJg3mkpL+/BSnqMT/sJcFW988YFAsQAK5ab1vUYyqHoRjvaqr6btjLNlv+pLiLGZSn+7Y0z3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4828
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-12_04,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309120065
X-Proofpoint-ORIG-GUID: 0h7j5m5u97L3_SStbOPi90k_EbPmxO2s
X-Proofpoint-GUID: 0h7j5m5u97L3_SStbOPi90k_EbPmxO2s
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/09/2023 01:56, Damien Le Moal wrote:
> Change ata_sas_slave_configure() to return the return value of
> ata_scsi_dev_config() to ensure that any error from that function is
> propagated to libsas.

This seems reasonable, but does libsas even check the return code? From 
a glance, I don't think that it does...

> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/ata/libata-sata.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index 5d31c08be013..0748e9ea4f5f 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -1169,8 +1169,8 @@ EXPORT_SYMBOL_GPL(ata_sas_tport_delete);
>   int ata_sas_slave_configure(struct scsi_device *sdev, struct ata_port *ap)
>   {
>   	ata_scsi_sdev_config(sdev);
> -	ata_scsi_dev_config(sdev, ap->link.device);
> -	return 0;
> +
> +	return ata_scsi_dev_config(sdev, ap->link.device);
>   }
>   EXPORT_SYMBOL_GPL(ata_sas_slave_configure);
>   

