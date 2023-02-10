Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 910AAC636CD
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Feb 2023 09:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbjBJJnC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Feb 2023 04:43:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbjBJJnA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2023 04:43:00 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDFC3028E
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 01:42:58 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31A7Nejp020729;
        Fri, 10 Feb 2023 09:42:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ozEOfgkvicY+zcE36S/InA1MRZx4nkuOAkiGRF0AhFQ=;
 b=Ma/sMH2EAsax4eZd8HfSAhhT1yThjLLlmzNfOeuzuBDdZAEyMP8myPkOPffe7kY1hD/t
 LP7zqBNOgE4ica+dMrhJalFFK4EaLneEewd42Rqq/qySFYv8hEi3fN928OZdewObvmpo
 iC/x9l8V65Rol6x/wN2n5QLQm7jn2Ei3eiNFBo7hhmuNlWj9/fUoD3jAzrWkx4vvFuZW
 r2Hgq6i5Dhld4c5iMmnTm27eky/9c98nYP9lpjO+gjG2uPxSyFokYT5vtOvmY5bWKin4
 dOD1GVNWbiKJ9qrdpeuG3CKgZg19bDZlhxxkt5s0QA7sY0pYhCXyAr6xpRVylF5NpNpi 0A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfdcmx2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 09:42:43 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31A8uhuY015178;
        Fri, 10 Feb 2023 09:42:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3njrbek16q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 09:42:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KVPiQescdpZYRdBLGc40PO6fnfuzStJpDZkIP6Wsu0zyHcPO7LvlHi7TitNAcBoHth9/TuC3LAwzBTBi8GzZyCcFzvwwuj2bdPY97pHENn3AqMJrsNS6IT+TWBaX831xl+guZVTGPYjDeRFeLbRkKYXnZClzJ/GKOVb0GF9ePQxL0h2uAJ13IJYusWm6T0e7NbCx9+hI1TjuqYYqreg0U6GLkpLRWa/cXHm2R7JICuG/wGWjEa627+5gtrkZSiaj+BTX8ERi4j6kgXCTRrTnHdaMAWYikeHeqEnNSULxTVdTTvvNdkrugI1A3S1NI5+LVystpEGmoKO4WwTxnJYkTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ozEOfgkvicY+zcE36S/InA1MRZx4nkuOAkiGRF0AhFQ=;
 b=E3rjeO8+JmYuPdQCqJLDfEyFehwPbvjrx7aL15R2cycdhE10PoPWti1XHT27hQ/Tg+GWqSIAijynDKjkY2mhe720iHEULAHD4PgpYUhEjERHAaNbcfFu1TNR1I9FyDp+9dgj6pSQLRYB1BWlcQrLdJW+1MppAg2Y1RlhDNba+0E1whilHGgiACJ+T9MB2+SzzTk4Km05pSAF6TrydEiByr5GdeXpz8H58ses7xS35g+fhR0m5L61Jr1gLl/IrFijmTmMK3c0M7DIZh3tv0v0b1gyIeNfrYDqJGD0RvGgT+qC00iIBuyCfeH+VV6cPluweWuZRlGoJjjOcs8OGYn83w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozEOfgkvicY+zcE36S/InA1MRZx4nkuOAkiGRF0AhFQ=;
 b=vaTXHgU41JFVF4Yv9HUXDDn7j53W8hfImAuVwEee/Kvx8BsqTNZ5qrvgBemK54wWReL0IwY09vCC6IrYop7uHQijini7CQPspCFHUFk6BTJRXr0SwPntizEmisSYFwYIDJvIklOreHWq95pcuwZ71IGXLnjhaSDkZwJEJLi8FCs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4654.namprd10.prod.outlook.com (2603:10b6:a03:2d2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Fri, 10 Feb
 2023 09:42:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb%4]) with mapi id 15.20.6086.018; Fri, 10 Feb 2023
 09:42:39 +0000
Message-ID: <2d13c5c5-61c8-cdde-7f06-4f9848bdb751@oracle.com>
Date:   Fri, 10 Feb 2023 09:42:34 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 3/3] scsi: ufs: Simplify ufshcd_execute_start_stop()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20230209185328.2762796-1-bvanassche@acm.org>
 <20230209185328.2762796-4-bvanassche@acm.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230209185328.2762796-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0015.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4654:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bd82168-3178-41ca-8a8e-08db0b4b261a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FjPhBLEJc404wACaILdSPnwFEUmX82JN9CeXpv8AZ2cdVr1eAU7Bap0s35PadTbBABY2u/2c4cpFE79I78z1ywvTtGwuIhnDab7fCF/4S3ulasu3AuP3DUubM0IgfqO+bzikI7NdWVNC1yPMS+iTBmhgCketbx5plkdkqotmyQKbLOj8G6839mCkg6b8PkVtixfKjNDAXG8W+yZ997uuSJj+269P0eqMX+utPYmnyqbn0vmpAjNCp8J5ziztOP+s1oGQbIuO2k+G9+RjpF0GhXfK5s25XERpmYxyjWhow0zK7AH8syVP23gH0zSt7nTkxcdYTsCeVBrAVzKUjG4SaizjUbbub9txjIfCgKNLctQTbKG/uMNCywa5I4aX97xsfIxywt+PgWb0cVnQo79wPNaIefmL0ayk2vJKNt/ohytgr72EYyKMaLxE/uF6D55vfrV8/Wxh9UmZTd5gruCUMfDu3EaDJeNlVUYUKFK5LMulYXYz9VbR5SVS57yxtkMD25scLDn+K8xHPkulSeo3R9g9aJMPV1h8mwVtWCcPQna3MP6bjf9wCUabz/42UPXKV9Gw0RTVkrAKDIURVCXiA7tvxFgUUN934s0+46vGC+LA8XyW24ek3YxtOi1ZXfTo79a7fTOsCMzcxQNa9vUzKEtYUpHWHQyVxqiwlfyttnt/rY+UZOHNIwWC/njPW43hRv46XCBF3RiaukSbpfl2b0g/EZrJFGw8yghum2XIkRU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(376002)(396003)(346002)(39860400002)(451199018)(478600001)(6486002)(54906003)(6636002)(110136005)(316002)(2906002)(4326008)(66476007)(66556008)(66946007)(8676002)(41300700001)(6666004)(31686004)(36916002)(6506007)(8936002)(6512007)(7416002)(186003)(5660300002)(26005)(53546011)(4744005)(38100700002)(2616005)(36756003)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VkR5VzlZS0oxNlp0c2Qxalp0M3BvWWJHV21zNDRtbGJTdlJGblhOTGNGaUNT?=
 =?utf-8?B?ZCt4aWFyOTMySTlmaGhjRW0yazZjMzRQTjZBY0FQVjJYRzNUYTZGZkJKdjdD?=
 =?utf-8?B?VXNybEwvUkJ2QTdLMUh1ZGVrUW9tM0NNSDE1YWVrS2kycFV3TEF5ZE9rUG9q?=
 =?utf-8?B?Z1RYNVczR2RzRVZ0MTZxYzhrQzZJTEo2MzhTelQ3ZDF5K0tFV2lEbm45Snli?=
 =?utf-8?B?a3YxdGNEMjZBMjhEdTNmb0haTmpkR1I4NHJHNzRmeHpKenduRTVobUlvWXdL?=
 =?utf-8?B?YTJzUFJtUEQ1cU02bHF6UWl4Vm8vcVk2dHhRY1hLOCtBczFEc1gyWjN2QWdu?=
 =?utf-8?B?RGNzUUlFSzl4S0pMSWozYXY4UUlTaFhDRzJxWlRCWU5uaFk5Nmo4ek5NRFRR?=
 =?utf-8?B?c09UMkFxUGR1b3dGT1NZVWV6V2JpSjdzVWJuWkkzY3NyczZpc1FkMWVRR21T?=
 =?utf-8?B?aEp4SkhZMytadG1nTE1kSis5TGgvZ21DL09iMDc1eWRCNlJmaytTelJhY1lY?=
 =?utf-8?B?Wk1aL1djaHErbmZsa3hmUHkxNGVCeGxXM3FBQkxXOUpIRDdSTlIxSXpLWW1S?=
 =?utf-8?B?cW10Q0dTVkNGRmxpWTlqQnUxYXhTdUJWdmFSTFB1MHFnaUtUdC9BcWRZNU9R?=
 =?utf-8?B?UlFXaGkyTVRNZEJGU0FDRllOTStub3BPbTlqWUEzc0hEcDFQR0txSm8xRW1k?=
 =?utf-8?B?aDF2VXZaUVJEeEl4Rmc1ODRPUjV4R1QzY04yaUlIcmExcE1DYUJGbGh2OXNH?=
 =?utf-8?B?dU4wWmNvRG9LekNtbEc3RFczRWI5ZFRCcUR6TllKQm1VaWxQVGIwL2VhSVVw?=
 =?utf-8?B?UnJwTlkxSHhmbVFNUkIvbndJTUQ4OFB2eVhUSzFCZnBwc3VIMGlQTEp6eldC?=
 =?utf-8?B?YW4zYjFqNjhxeDI4TEtGTHBrVDNaSUFEL0x3cnJFZzBlanBYTU9ZczZKWFNw?=
 =?utf-8?B?OVRjM1Y0Wlpqc0JiZlN6ekxUVDYyR0lkWjVlcXdiSG56cHFZYldsanRTTWZH?=
 =?utf-8?B?TFNDRmFEaTdCUC9BQ1lxNDg4KzVMd1M2Zythc3hZT2pkTFA1OTdHRlV0N2Y4?=
 =?utf-8?B?L003YXcyTlRCODZZWlptRGMzdzh1c1Z6L250T0hPTXVEeDczcUQvdnVZUDZP?=
 =?utf-8?B?NHgxMm1URUVHVUFIMGFlR1dvenRya3BJZXF0bVhYNllPUmJ4VHF5K2ZqQ3dL?=
 =?utf-8?B?VWlQUTQ0ay9pb2pnSUc2cjBWTUJFd3E1MEgxOGNqckZBVERGQWZLdUFzSFdY?=
 =?utf-8?B?ekNDSmh4eUVVR0xDeXRhRGFSZlZXNTBjUDdma0dtUDczWm9wOVhNU3BzRERI?=
 =?utf-8?B?Z3lzMlJMT1kxWGJmRjhVYW9JVEFMS1FYQ2plSnNTeUNaR1pFcHBUS2ZoQ2dz?=
 =?utf-8?B?OGQya1l4QkRuTjlla01RVGpiVE1rTjZtS2ZQeXh0M0pia0xxU0tEOUs5eHdJ?=
 =?utf-8?B?eHdYKzN5bm9zQzZBbmFWMm1LaHQyR2FFeEVIcUhTVU90ejFvL1k5dXZvV1hz?=
 =?utf-8?B?Y3U4M0t6ZTVjRmZubVdqV2R4QmxLNXZjRnpaVGhsSFcwN203SnBPUlBRNVhX?=
 =?utf-8?B?VmIvNmJTaWR3bUg4YURZeVNidVFqTkx0UjVZQ2g1LzlSRWJLWGlnaVJjOXJV?=
 =?utf-8?B?a1RXbUp6WHkxSjZQSzczV3NCVHlIeEZUQThtaUtTTjR4bHhLd2tTeHB2dHJm?=
 =?utf-8?B?aERFZTNuSDhtRTd6dnJHVlZVZVN3bms0M2lseHJmUmd6WGpaVExRcFBNNng2?=
 =?utf-8?B?eFNWNEp3cW5wQm5UanQ1aHhRYi8yTXZibk5iSzhEbHQ1Rkg5dzY1cG54SVpG?=
 =?utf-8?B?aWVpb2hWdDRWaEVrYkNqUkJyWHVDd2xDbWRNOEU2bkRPT21ES01GWFBoY0pH?=
 =?utf-8?B?eG80MjV4TU0ybmsyYS9pOVJhQk8xSmVjbjNzeG92b0p1cXJJRzlBKzdGelRw?=
 =?utf-8?B?aHZoUWFOaDBGL0dNS3JObktyVTFWbzQ2QzBpbFRQemVDMjlNYWJlTnNaVmtK?=
 =?utf-8?B?QmdIdFB1clQxaTJ2cGxpb1d0Y3JQVzJwTXhXZkd5UXZJZWtsdkJXa1p4d3dO?=
 =?utf-8?B?OU1QdFNyeDhDY2JaQVFFRVk4S1JWRUwvSEhxaVFwdkpIbFlOclB1VFd0UFdU?=
 =?utf-8?B?VE5yT09mNWhHR3hTb0lnaXI4UlZublgvd2NFVUhUNFZVcm9uTnNidUZiY01V?=
 =?utf-8?B?akE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?T3BzV0pCQTlrck1GNkxseDdIWm5RaG1YUmpXR1MvckRyWDFOcWE2bzBRSC8w?=
 =?utf-8?B?S2xqY1pobExSK2dlWEFFVGRqSW1ERFVVdDZSNWtKUnNjMXlxNDl2bzgrV2l5?=
 =?utf-8?B?ZG5jSVlpT2pYRmZwVDl5Q05keE91UDh4RFdVc2tIMXJUYllhQUphejFVVVRm?=
 =?utf-8?B?WFR4RW4wU2s1NWc5YURjT0NNK3E2VFl5a041THllSVpiRml1MUJ4ZG9wYmpH?=
 =?utf-8?B?WlNOa2F0TE5JUmVtbkFOMVg4KzhGenAxNDQ4bGhZclBxTFRqY0VuNzljbG5R?=
 =?utf-8?B?OFpITjhPRy9rWW5WWU94NUoyL2dQRGJlVmdIeTlmRHpRMUdZZjMvOW4zS3l0?=
 =?utf-8?B?bDhyV0V1ekNLRG11eWtSRkZjNWFyT3luQ2psSEZRczRyREFMWVQ4WFJvbkxq?=
 =?utf-8?B?ck0yL0tiWkxweUtmSHBJOTJDcUkvallTaHpxU2huM294azgydVV3YlRvMENz?=
 =?utf-8?B?emNKZzVrRE5aVVNJbkJWNURIb0xMdjR2c1g0TjdrN0RJOGtMdmFEdjh6UXJU?=
 =?utf-8?B?Nk9tUkphV0MzSHArUU9xUGNYbU02Q1J0aHI3NjZ2VjE0MDdvVFVnNk50WFJo?=
 =?utf-8?B?NGhoTTdlVjdFL1J3aERLZlNvSG53SnFUYmQ3a2JhTzBwdkt1UDVwb1RiZC80?=
 =?utf-8?B?dnpRcmU3WEdJZ0dLNTJTTkNIOGxMU3BQMys0ejFhN2M3WldvQ3E0NTVNY2hQ?=
 =?utf-8?B?dkVUTExJUTFOM2FJOXRyMDFYK2lpMjZsMjNFTnppa1lTT2RpVHpHcm1qREJr?=
 =?utf-8?B?RHYyNGpBVGRjUDczWnZycXMxcUFZaGZrZDFXNVdyQlNoWms4TkFDZmhKdGJn?=
 =?utf-8?B?ajVXV1g1b0xzRVlia3Y4ZlBXQ0k4RjQxZVU1dEc4dGxLZUp4SGJRUk1Za01o?=
 =?utf-8?B?NllxcmtXQWZTZGF0VGJkZDJGZWI5cjYyUjFqUzBXSmJoYkFtSnFVakNyb3di?=
 =?utf-8?B?WWEvR2NrclZXSWJBcDBjODd2YWozQVZLSU41anRNa2dWRHJZa3NMazZvQ1ZI?=
 =?utf-8?B?MzFhNkFHc3VYQVlLZ2Q1QzB3d3pXYStyaFR4MGQ1QUlLNmRxZTRHNFNMVnhh?=
 =?utf-8?B?VVBlUlBpbDZmTkkyQk1yWkxiQzB0OHlJT29Xbm5lL2hOU003a2phMmlKTmkw?=
 =?utf-8?B?WmdNQURLYjIyYkFQUzRmYXNrVWhNTWp3eGJpUm9qQnQ1QitVckF6bkFRbHZ2?=
 =?utf-8?B?dFNxMnhOMjhxeXZjcWFwUXI3UmtpZGYyNEdPUHE2Yjkvd3BpL1NRWkZjRlZx?=
 =?utf-8?B?TEhCWXo4NTdjTittS0ZoTTR6V0JFRUJqTVZzN3lTbnVXVFZlN2JIR243c01h?=
 =?utf-8?B?Y0NHYXZRWWJwTCtRWXlEcTkwL3FmR1dVTTV6V3JmUVhybStOdzg3cmxaZ3Yx?=
 =?utf-8?B?N1NUVXB2VFJEQnc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd82168-3178-41ca-8a8e-08db0b4b261a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 09:42:39.4814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bYVIELbL2M21j+fn4k9oIjnoQMibh0lYkVRm+JgjHLad2ApECAxqhqW36GCLqNfRl4AMIAISHh2lIs31bg9fFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4654
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_05,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302100082
X-Proofpoint-GUID: HWjdF3JaGI-G9elzMOgzL0Ko7X-KJd-2
X-Proofpoint-ORIG-GUID: HWjdF3JaGI-G9elzMOgzL0Ko7X-KJd-2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/02/2023 18:53, Bart Van Assche wrote:
> Use scsi_execute_cmd() instead of open-coding it.
> 
> Cc: Mike Christie<michael.christie@oracle.com>
> Cc: John Garry<john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

Looks ok, so feel free to add:
Reviewed-by: John Garry <john.g.garry@oracle.com>
