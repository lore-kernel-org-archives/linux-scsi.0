Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35081C001DE
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 15:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbjGZPnT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 11:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjGZPnQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 11:43:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E4DE4D;
        Wed, 26 Jul 2023 08:43:15 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36Q8Ykna025720;
        Wed, 26 Jul 2023 15:42:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=YNczz0QF825NHIXMF1pH7rWvwU6iNST9qHPnDp3+SN8=;
 b=R7Ivb3TNE42RzdYyt2rmCZlj6s08GaiTu4sXgV9v6iIVUc+x+QUFGANpH7crQ+NXIVGb
 qhpxL2bVGpEbqCJAPgn1Pw5QkS7cYnK5nonfrDIxqMLud9/SK1zAXm5/RZbTruTMJH4f
 Gkd12rvO4wgHaLY/Mq5fNB/qK3kWNUoiydDCflpC6Rpb3Ll0nzI8+lZ7kDM2X0bqMK7G
 79pYcKYDQf/KbAX2KlHTaW099f53+oLEU2uTARR4dQN8ouVR2KQwfMEMVHJBvuEdcnzc
 C7ut3UM5A55Br4CuV8CQLULBE2/sjHQCmboyg3sg9cCipo9nWhz+AHSNSFyB9KhkMSGJ 4w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s075d7va7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 15:42:51 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36QFPHIm029536;
        Wed, 26 Jul 2023 15:42:50 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j6cqbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 15:42:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CyHy17Pf4NGF2T74WepZY/tJ9Bvw9NO6ogkqEPSYTOH1VHBhTvetQ+C2SEkE+XvV71rqHoxCpU9a2953eHBlVCq4g2ItVLzs5Ir0Z3I4hjZT5dk1tWgGbeJrdJkGd83AkpWRpwYl9RpONpgIrSHdA/TRsXCDVzAqBfM9sURO+j9J7qHqoXwsdtFnsmf9MG8e+uCxmlAIbYbFa1UBnMGC+esC9QHT0pw7sKqCjm1HfIo2Le/BgIoGUu0eBRRILUga0imtYhmeHZJTZ0hslCjmrcH34OZ5iRnPwKcULQEVSoGSjH9yAHISY/7a3JbAzI4ZuZg0M5mQ7o4x7JiTjXxKNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YNczz0QF825NHIXMF1pH7rWvwU6iNST9qHPnDp3+SN8=;
 b=AOWapmJ4+KG6kuIvJgETjvGWVsnN0Szj/lII7ObSx3N8FbjUl2Zqu5E1S42A9J4onK/Sh+ynmlgom9hwQdayiaDtkbeFupSDhliAPKMkVyuImahQWEXObCkEsgIWp9byc6QfO1JslDo34Znq2pa3tOqZTrWYZIPoGtcM/FChmF21zUqT/pLLVSLWuaw2Or/KbNmdIg/F3ittNeJVfM7qOZdoLwk60RVosE2mTY7yulAslzCHcieBgymdB54it3z3mJtlfoAGdCZi3EqQOxS06l/HuH7tA/IuE6xuwLmDzW9rhibSncF74mxhBSoY/Ksrev0fyRvmDdkTjeEwR8q0DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNczz0QF825NHIXMF1pH7rWvwU6iNST9qHPnDp3+SN8=;
 b=t9yXiUyueSMq7IFKIu/PU/NIcKWG3W/r2qBWsAY0TftZNjJt4i/wu2wOzIrQGe1mzYxe+Mh5Q8Mc0KQLKrc2/mHvCudcaOTbGISN+gPLfdg4kKVKAVTwgqHK4t/k7wOXUtPE6JUw6O48Ybk5Si9Oj2ulDGlmqKvvRAP9aXBuRY0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BL3PR10MB6259.namprd10.prod.outlook.com (2603:10b6:208:38e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Wed, 26 Jul
 2023 15:42:47 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Wed, 26 Jul 2023
 15:42:47 +0000
Message-ID: <07f84570-5307-df3c-99ab-a996bfcbf83a@oracle.com>
Date:   Wed, 26 Jul 2023 16:42:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH V2 5/9] scsi: hisi: take blk_mq_max_nr_hw_queues() into
 account for calculating io vectors
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
References: <20230726094027.535126-1-ming.lei@redhat.com>
 <20230726094027.535126-6-ming.lei@redhat.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230726094027.535126-6-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0026.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BL3PR10MB6259:EE_
X-MS-Office365-Filtering-Correlation-Id: 35cb4f57-8e0e-4a06-511a-08db8deef618
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YOesCf9HQO8C/3pemvejafpM92C1p0FwyJndIQE8WGARzsNUnc66JXgpliiPKfapGJWxnLCvbDfHQ0lGXoGmvX5hqppwTiSBYQk064n31tyny6y3gghvCapwgW3U9Z80UQVSi3VoXy+DL+MtojU+WlZts6Fp+en3aHPFAoACuzIETSGDyWrjgEDwsX7deTsdA+jK/gyLB7/xm34F7O0O77iQ0l5G8Dotm+KDedRa6by9r0ssK0wB4W4zH0pvf3PJrGZXY7XcwfEwuCEMRpiIgFcvBLDe8NO0air+n5NlAHz8bbebMHPAzslV86W00mIf8CSe/7/RQ5Ff2zfTCta1YY6VLOCfUY5xklzo9uTLCcj74tVPUmRIk+K6MY3GKvAUhLi4+IvmK+qTytDXg8j5ECgnqLBNwFxoAfvYP8EDbLNj+SmrBo7YpyPPz6HC52fA/4TnlMDZzEVnoYihyyGeJFfYG9uOWl0HOz5Pf680RAVi50HK6HyP/JhK+QdxrQG/Law4wyBN1RoG09hUyPfUW2ZQXHDgmynm4Yt9LprgkFmScHD2Nm835JkiahJvDZA9G2Jj2Vp6F/0/P7e7/moopKfwcXC5dCdXiQ664N2t0H2wbvsDkSGggTfK14istJ4kEGaCn/UZA4cdFG3m4/1uCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(346002)(136003)(366004)(451199021)(478600001)(110136005)(31696002)(54906003)(38100700002)(86362001)(4326008)(316002)(66476007)(66556008)(66946007)(6506007)(186003)(6666004)(6512007)(6486002)(26005)(36916002)(53546011)(5660300002)(8676002)(8936002)(41300700001)(2906002)(2616005)(36756003)(15650500001)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTdQRXlxNFFxcTJTbGxrOEpra1p4dnBoVnNXc08zN1ZoUm9xUWRVYTBUd25O?=
 =?utf-8?B?MW83cW5GbmVoK0EzUG51Vi9BdE1ucElwbFl5NDBEUXJTYS9tbnJNQUZoSzBJ?=
 =?utf-8?B?T0U0cWJXMGdOcGJZQk9nQzc1SlIreEZxWUZ3cGc5Wk1kY1o1Njg1cUhEdXhZ?=
 =?utf-8?B?U0FaVFNoZCt5Qkt2dDEzRXNhSVh4TjFiRmg3SW81bFBDSFJ2alZrWU51cEtR?=
 =?utf-8?B?N2cxUDFhekZ5NzM3K0Y4TEVKbTgralZ6RjRmMXdzY2o5TEt3WjR4SEpCVVhK?=
 =?utf-8?B?UUtUZDBKOEpLcWp3eGl1blAya3ZtT0lybWU5bTZndGNLSjJ2aWU2byszcXhT?=
 =?utf-8?B?ZDc3VTlhQzBMb1dGZTZwbFVDemFqVUQzTUhMbXp0aERYMzY4TlFBOG9lRUcr?=
 =?utf-8?B?NDRXemdleUJWWFZybHpScllLVGx4cEFsTGIvUXZFTG5Fb0FaVVU4T21zY242?=
 =?utf-8?B?aktabjFqaUJ5YjR6ZWxvVlQ2MkRURXhqaGhxT2ppY2JYSGswN3pEdXl4THFG?=
 =?utf-8?B?S3g5L1hEZEZXcWNUYlNna3JyTUtyejRhSVkvaTQrR09MeTFtdU0xUFREeVRL?=
 =?utf-8?B?Rjl6U3FWMFhIZmtldWppUTVzdWNkVWdpbDF2dE1EMGpWSmNhL3IyQ1BUSnNW?=
 =?utf-8?B?bHA0TllSZjlTZE9Jbm1la2hEWlYzcWx5S2U3aEhDM1Y1WUg2bUhJV2V4ZDNN?=
 =?utf-8?B?enlkbjkwYWtqOXhKNStSYXBYQ0FRakUzbHdKM0J4K01DVzhvYW1SVEhLUmti?=
 =?utf-8?B?MkovenVHa0NiN3dabjRtQW1ReTBGTGlSN25FRHBXdTYzd21vVVF1UkhGc0tK?=
 =?utf-8?B?bDhkdXBZR0NiTmNEUmpqODFWMkRFM0M1aUFkVVZFa1Awa3U4K1NxaFd1Vzhh?=
 =?utf-8?B?dzFuWjdEZnZNd0hqenJHN1pGaXA1MWdHd21BRlpvMGZOTWRyd1o1aWFpc2Q3?=
 =?utf-8?B?djc3dVB4MzEvTlZvZVZ2U0twRDVNSlZuTUNvbzFvb3hOS2Y5TnA0aFNSU2hR?=
 =?utf-8?B?ZzFkQmRodXBXOXM2UW00dkIwZFpmS1N4ZS9JcHBXbnRETFdiR0dDVGNuZlJw?=
 =?utf-8?B?RzNlaE56Zi93bHNyR1JNbzA3b0l6Q2t3K3QrYnN2ZnIwOFoxRzJyMDYwMTRG?=
 =?utf-8?B?RC9rZ3dCTnNpc1Z0dkJxRUZKaitiYXRrYXAwZURLZlh5U2RXc01pbS9ubFdX?=
 =?utf-8?B?ajRGWlVZSEszOE9SNDhvV3ZLZVhTUUxhbjhFVVhQTzc0Q1NUaWlEUTNRRmJ4?=
 =?utf-8?B?NGxTMXB5OGs5TWNCc0FQS3NsTjN5MHNCSVhlWklPc0FIZzFnUUJaZC8yOFdV?=
 =?utf-8?B?aW9QMlVXQ21ZZ3VobU80ZWp5YnBhaGJTekFaR3M2eHYxa2tTVXUyZzdaVWl5?=
 =?utf-8?B?WkRtbTZCVEg1UnZOaHJZYnVuZHJFZXEvWWcrWU8xdHJNNFkrTkxoZVdhZWlX?=
 =?utf-8?B?UDE0bzdEQVlNNzE0K05wc1E1bThBK3lJYmpibHdYUENTRENHNGVIOFd2cHdt?=
 =?utf-8?B?RVR1WVBLVCt2SGhKYUR1bUx1bkdpNXB1S3NLbW81ZlIxalFhM3MrT3A2UVRs?=
 =?utf-8?B?L0pNYUljTXg1L1k0ZFVjcmp4MVREK1ZHblJPbm9jRmNRWEtxeUhYMTJUMkpi?=
 =?utf-8?B?eHFrS3F6Nm9lQmRRS21UOEhiYWhsdHVXZVBoWXZwU2EzQTE4emphbGk0emJK?=
 =?utf-8?B?MWVoYnhsME41YkZLeVFTbTFJU0ExSkNvWDh2M1F5RURZcjZ4ZjZXaks4Z2hF?=
 =?utf-8?B?OXJUTzFPTkZKVy9Dd0VWaDBRdHlEY0ZiTTRsL1EreW9ud2RXTnlQZ1QrS2dB?=
 =?utf-8?B?M2tLbTRQanpxUE9sRkdBMVVTZGhEMXBEai8rWXlEZzVPSG41VmcreWJSRnRv?=
 =?utf-8?B?bVJMV3g4KzZ5cjluTm5hTndhU1hSL0xQamxVRTZCNFBjVUdualJ3ZHN2WkRa?=
 =?utf-8?B?VE1UTVdVNjhheTBrcm52WkVwZmY3REJ4RnppdXFXRFVQUnFFQ0x3a3RlcnQ0?=
 =?utf-8?B?K1NCQjR0c21JQ1RHeDAveXduYkZxLzFKbnVpQzNDcENxbldod0dzdHZEb25N?=
 =?utf-8?B?UXVtYlllaU5FTEUrTWVDZk1adGUrMVJNR0FRTTVsTmVZS0Fuc1I3WFNKMGt2?=
 =?utf-8?Q?xzDjO2mQmkujlERuzFGYPY34F?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?dnhDMnE4TTVVU2VjRUhXd1Y2TkZLR3ZRSElYclAwZGJCNGwydDI2cmQ4WFJI?=
 =?utf-8?B?RHZsdkZ3MHZnUHE4RGU1RC8xd3N5NWtHYWRiQWo0S0NpQm52MkFrUU9aUmRI?=
 =?utf-8?B?NnkwSXdJZVhCY1FocFdiUmEzbkVMYVB6SHpheTdGcTBuQ1M3WjdhSjVMWXdm?=
 =?utf-8?B?clVhcDdpWHBReHlhcEFTNEJ5ZTc1NjFIb2xSeVVwaTAwK1phMUxIN0FZTmRJ?=
 =?utf-8?B?aFVPTTFQV1FPL21hOE5pS2lEZ29RVFZvcmFJbFZUbDNDNExtemNPS24xbGRU?=
 =?utf-8?B?RGZHb01hdG9OdkdYbWxPVDhIakFMbEx0Yk9aenU4aHYvRlFNMWtBOFdBUFY4?=
 =?utf-8?B?WlFObUNHWnE2bUh3LzB4anB0bWlPTUxYV2VxMlZBRG52aEh6c1JjRHBlUjhR?=
 =?utf-8?B?Yk9JMFJrYTd0SkJoRitNMWZPK1VaWGU2T3g5b2xLL3lyR1BhYlRjY2w1MjhI?=
 =?utf-8?B?UWpIeVlPUFEzcTRmQThyM0NvUmpkZmtEdXcvSG9zdVFxcUxHVEF2V0p1L2Jp?=
 =?utf-8?B?bXZFcGRCaUU4MkN1YUp3QmYwajF6ZjhZbXBtT0VlUjdLYVoyMUtBaEVta251?=
 =?utf-8?B?eHY0WWdWTFFsTStwa2t2clJ0WHVhVjZITTMxbVR4alVVU2RLaXFjOUxBbkh5?=
 =?utf-8?B?OWdrU3pseGd6NGJaSHBlTW1CNkowRTZoSThHWTkzRFFmV20yUFZGUzNDazJk?=
 =?utf-8?B?ak9wQ0FJU3kxUjVQUFZqTmhwbzFlTFdtbGdDeFhWQ1FqZGxldm5ZK2tqdWVy?=
 =?utf-8?B?bFVFQmlad0NJN0w1bjVuc0JhL2Nhb0RSdXh3NHIyZHBkUDhOaFFmUHU1VVB3?=
 =?utf-8?B?NUZSQVUvSjJaYlRES1RuUENCdmtoY2JBUExVUnZveFVsUGNnc2F3RDlicUZF?=
 =?utf-8?B?SEFWNEVERUlxTElCdjRjaW81YW5wMUtkQ3UvUnRZU2NVMlp0TVgrNVFXS2Jr?=
 =?utf-8?B?aDR6d1RETm9XNTM1Q21Cc0QrMzZFZWVzc0hENjhFZG5YWTlqRzM0Wkk2Tm1k?=
 =?utf-8?B?MWozYXN1WGlCMkZ2NTNXWXpFNjlTU2JIdXgwOEN2a1NkcDVIUXpIL2kyTUN6?=
 =?utf-8?B?N1VCdUJ3MjRjOTIvQm52c1pBT1dORWs1WFFVakRNd2pUNURNYUg4RXZGb1pT?=
 =?utf-8?B?aTlvNTByTVJhb2JGOUV3NnRFcG1BbEJVT3NaUUVDMTdMV2dab0lJYS9kTWFZ?=
 =?utf-8?B?cm1SZGt3TVJEVGk4STNiNWVybEtCdHRQbWMvUWxWSEJqMmJQUld2MFVZdFU2?=
 =?utf-8?B?SEsrL0FnUUQ1WndRRCszaUVMOXRhVyt4dEhINW1RaTdmTXh1N3U3dEdrUitR?=
 =?utf-8?Q?MFtqiMy01I31E=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35cb4f57-8e0e-4a06-511a-08db8deef618
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2023 15:42:47.6304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vRmiVZG0ZbegI2KBdRe1QsI/+bE7k2RY94ERvPHD2GJIYgRj0lIOfDstx6k8qXZiaJFbHtEcKdIoxfDrPOb8/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6259
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-26_06,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307260140
X-Proofpoint-ORIG-GUID: gAdbPhmIgOkm_fr1454ocl2MkTmfH_8Q
X-Proofpoint-GUID: gAdbPhmIgOkm_fr1454ocl2MkTmfH_8Q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/07/2023 10:40, Ming Lei wrote:
> Take blk-mq's knowledge into account for calculating io queues.
> 
> Fix wrong queue mapping in case of kdump kernel.
> 
> On arm and ppc64, 'maxcpus=1' is passed to kdump kernel command line,
> see `Documentation/admin-guide/kdump/kdump.rst`, so num_possible_cpus()
> still returns all CPUs because 'maxcpus=1' just bring up one single
> cpu core during booting.
> 
> blk-mq sees single queue in kdump kernel, and in driver's viewpoint
> there are still multiple queues, this inconsistency causes driver to apply
> wrong queue mapping for handling IO, and IO timeout is triggered.
> 
> Meantime, single queue makes much less resource utilization, and reduce
> risk of kernel failure.
> 
> Cc: Xiang Chen <chenxiang66@hisilicon.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index 20e1607c6282..60d2301e7f9d 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -2550,6 +2550,9 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
>   
>   
>   	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW - hisi_hba->iopoll_q_cnt;
> +	if (hisi_hba->cq_nvecs > scsi_max_nr_hw_queues())
> +		hisi_hba->cq_nvecs = scsi_max_nr_hw_queues();
> +
>   	shost->nr_hw_queues = hisi_hba->cq_nvecs + hisi_hba->iopoll_q_cnt;

For other drivers you limit the max MSI vectors which we try to allocate 
according to scsi_max_nr_hw_queues(), but here you continue to alloc the 
same max vectors but then limit the driver's completion queue count. Why 
not limit the max MSI vectors also here?

Thanks,
John

>   
>   	return devm_add_action(&pdev->dev, hisi_sas_v3_free_vectors, pdev);

