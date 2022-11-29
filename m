Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A34C4167B
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Nov 2022 21:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236387AbiK2Vb5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237080AbiK2Vbz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2022 16:31:55 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28935655B;
        Tue, 29 Nov 2022 13:31:54 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATLNqBE024546;
        Tue, 29 Nov 2022 21:31:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=G8L4XelBQaba5AGo0rAmf8GQkBJ2scERBezMTtCtlZM=;
 b=i6fbRhiW31KRVoAOgA6GAJv/laAC8uzRLe/9CVMeT4fbzjpeLpVIHOsTTWwYVhACZRKl
 kT+jZ+a1CzlaXrCdL0GhdHthM++0j6ZF4gG8Qyxx2ZKUo7f2+0jvTY8gEHSx4OsmHf1b
 zT7FpzcRNyd+mx/Jil9EWyQihQt5xPlr9UnDlHMxYUI2CdCHlJu4yJ7/aDdEj3BRu2QT
 Gfm14lri5T4r1VP7w3F7rl/bsP1t5mJ0VDJT5YrYObD4NFW4Tt9+9AWU4+VEHhjn63/4
 rtHpQs3T2S2SXXCln85SgyKyFKF7Tzh/10eS1qKMbewggq806Ssv0W7ye84cyoEz1Fuj 0g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3adt8a2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 21:31:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATKuRhB027923;
        Tue, 29 Nov 2022 21:31:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m3987x645-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 21:31:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iH1glTIPUhs3YXO9foc4h8M/RKdd7w0S2T8AZyta9cnXpplj/yNoJgW1xcaXVCiFTfUZaLDKhmUV9jih249HIzGXXZlj91Vgm2Nw2BlU3TcC7vB6dcPyJjFNqAMF+EbbAmqOcFLeHT8PvZ+t5e+m++K3SZjdiol0y+sUpGZDkaVOnH6MMd04MyQVAs06ekMGjC8WttnWDFYTB7EoR0RYBdVMZ67IByQ5sgsqzU0IgC3xJnJS0eLonU4C6JMkRcBmZVCz2dOKm2A37iA82rk+b2p1svn8jSbqWqpCi8BaPlT36lkcLmTEBez7sy3thm+rt099LS1DI14sicS61fLTjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8L4XelBQaba5AGo0rAmf8GQkBJ2scERBezMTtCtlZM=;
 b=X3MEwvrztz9BEYQIK+dBVYD4zQzKAPoGoMITcyaaYDHEztGy2s41uVYkAJiGhvs3g9XjmwnMgrvOiIlxpcYP3LpvlaBz37Abzl46kWsUpoxreIz6xpM5C+t2CGtTDRfbT7aiGpyjiFYPwTabM0zWHAFnJ8gm+170AJnUCfTAki7q2t/GhWe4h5Wnb3TvrnQLw28KkKRs4UauDyMF29uIbC8koBcq0t9Oa7DtHacwSIaNrg00oYoXnOQ7mEQ/XXhExdQPjqzTBQBNtp6Fd/lpL/BKmgsOPoIUqJkkYGNWDsrn2VwUwcXdDJ7X7W/ZdDqkBGvBE8bR49fbrHz9WYdEQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8L4XelBQaba5AGo0rAmf8GQkBJ2scERBezMTtCtlZM=;
 b=PcXsv76u0F2DOB8WGwy3uQWRcvMUIFGFzK3u6ezFj+8QJ07OiRf3aqavY/aqI63GMFWhErA+6pwsTu0zRASxtqUaS5XpoobURxntVkMCkK/syFi5AMFy48E6R6xyc6kcIma7eRkge0FAD/tXa/+OqSz9gNjxPQIJWwMDRxmL3eE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH3PR10MB6834.namprd10.prod.outlook.com (2603:10b6:610:14a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:31:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:31:25 +0000
Message-ID: <b84bad4d-7129-c848-215a-a7cc519dc98a@oracle.com>
Date:   Tue, 29 Nov 2022 15:31:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3 0/4] block/scsi/nvme: Add error codes for PR ops
To:     Jens Axboe <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20221122032603.32766-1-michael.christie@oracle.com>
 <yq1o7sumo0c.fsf@ca-mkp.ca.oracle.com>
 <538bcade-c453-e6f8-4530-808a9bf2140a@nvidia.com>
 <20221129132805.GA13061@lst.de>
 <613117ce-56ce-10cb-1548-eac1741ceae5@kernel.dk>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <613117ce-56ce-10cb-1548-eac1741ceae5@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0037.namprd03.prod.outlook.com
 (2603:10b6:610:b3::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH3PR10MB6834:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b6240fe-e63a-45e8-1179-08dad2511141
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IyjTUb19gyZF/f4RfkRuruj7FxTkvZksnGXfyMrJGQAbZrmyBnGlNeL6okgYevK92P8M+UXBifKutkLkRdLJC7C3AdoOOIqW178lFciFC1rrwYazhsAhDGg5+DBAlggFmKs9quWIyo9aHJtZkCnm6f8LhD0iQSCOXsnxN9+slVZCuj98SkKvGjDNH0AsGmQuJ6m5YNfS1QwmbIBWdgTvOyW3MiK5qtKkDxTXvOkZaQGKPfCLETr1wp3dS17WgsN8WnNnWUaAMKMTm8fNtM6gs1JUjZqaroCJZOcy3cR9ghpJYPqvcd9yaqO6B4oPFVfdgcNyslpiNYp8DliTAq1gRXCnreTJcsBdyNaKpOQNOnjeBeUIFWilcVzkGAuWCQYA5Iv87X4nBgo42yX+HESSxfjsnMwdMEwYMVBwAF3Wt3aoC5FNbXwGI5UUiXrD5buJdcP86jsA2HcayWEHNUfMEXLzJCdCr6q0U6CE1ULjM3g7UZDH5IN8KYv5TXioS5GdXlh+0Ui3Au6mQyrw5HaQAKj3DRvNtkVKAnwAa63Tw4FVMXFpFPVtIZVJE4c2o+yPmg1J5YL7f1EvJkhNWmzSYWctsksRbqyzratw2+HPyNIq6ZiegWx87/zXSOlEmZb8Nfv5HqLwImEZnhQpOGahkQKZ/op1baN5IA56IStSj+tnpRBEdEShOjN66oGXb3jCMsp7/l5jjk7F97aj77812EQOYktoePqAByoQtEeJprY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(5660300002)(4744005)(7416002)(316002)(2616005)(26005)(6512007)(54906003)(110136005)(8936002)(41300700001)(66476007)(66556008)(8676002)(66946007)(4326008)(186003)(38100700002)(2906002)(36756003)(83380400001)(86362001)(31696002)(478600001)(6506007)(6486002)(31686004)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHdHREZWUDRPd1d2dlJBSzZSMG1rSHM4bWpYajlidzZCZDEvOU45cWFpWFVs?=
 =?utf-8?B?ZjhYTEZHa0Y3dXJKTkxYaVdlTTg2YlF3alVwc244eVo2Rm1RK2xaRzlYTHAz?=
 =?utf-8?B?YWJmcnNyR1JnYy9QNmxjN2FHcVRoL3A1Z0MzQVVRaEJUV3RsRHFMOVBKWDh0?=
 =?utf-8?B?enAzU2VSbmFrOXdZZm9YM2tRZWpLM3lWc3JNUkQ5TEoxZ2hLSUgzUFJwZnBD?=
 =?utf-8?B?T2xLMHZaRUpHOEV0RjZVbkZNVXY5Z2EwTFlpQmt6WnJCeFFSekg2NXQyK2Ni?=
 =?utf-8?B?a0dhRWJEc2dmbThVK1VBejNJR3J6SEpxQjdGTmc3Mlh5cHlPeUhoR3c1UEZI?=
 =?utf-8?B?RnE2U3ExVEZwM3lOV05iVlR2QlozNk9BZDU4UVlmSG5jUzRXQ2ZaNjU3U2lz?=
 =?utf-8?B?ZVV4Vkl4SHFTVENFQ0hjcGhxVEdYMXIzSU5vL2t3UU1QVTFxS0FTOXRDS0V3?=
 =?utf-8?B?VzlKRGlOQkJBb0c0RFVncm5TZTJtbndJZ3ZGcnY0dVRSamlKWnVRR0ZzWXZk?=
 =?utf-8?B?NEJEYjl6MVVTT2FOcG8vQjFIdjB5Y2VOU1BqM2taY3F4eUZYa2F2dXdrczlE?=
 =?utf-8?B?SXBaanRhQjJDbzhucUxZQjZvT0xmbEhTejVrWUJQT1VKZ1VDU0EvQnEyR3Az?=
 =?utf-8?B?S2hmV2h1MGh5a29vRjdZQ0l5b0xWdnJhOHdrNFlDdWswTHpPMjJQOVB6cVdF?=
 =?utf-8?B?cTlMU2IzRjU3Y01jZVBpUVhxNWtoWTM5R3IzaDF2TW9TY1ZGdE5kUTB2M1l0?=
 =?utf-8?B?K0hxZXBJSHhZV2VqRmpGdXNWa1V4QVdvdkZKQk5oNE43VEw4d0ZKc3JlcGtz?=
 =?utf-8?B?VEJVcEp5cXZjQkxXY08xa3poOEo5QUtBcVJESVQxNTE0Q1VRYTd4MEpwZUkv?=
 =?utf-8?B?empPamtGVEpnd0R2QXlVSzBXSDd4ZlpSYk1ZY0hOOHptOW5QWG96d3NMZXc4?=
 =?utf-8?B?dXd0T3V3TmJyNXRXTXI4cGtrLzN4TytYR2MzQU1Mc0VkaW1KakdiQjRUT0Y2?=
 =?utf-8?B?MlBQeUMrUXM4dGthb29XQlRBMittcnJHZTN1b3lLeTFPdy93T2JDdjJYRkF2?=
 =?utf-8?B?eUJKVzRWM2xRWStFand3MDJERXNTbGNGOGhhS0cycE9rNmhNVmRXanJqN3Na?=
 =?utf-8?B?Sng1aU1lR0FMQmIzVzZRNmljOGN1cnVmQ0NlR0RNanBtSzd5TXRGOUlPNnlB?=
 =?utf-8?B?V1R0VWpqd242Q0MzZlYxMVhKVkxwSFJITGZhN0NrVmxiUWUydlg2WFpuenFq?=
 =?utf-8?B?aFc2SXhnRFV5L2tya0ppTlg1UFRoVlhrdkxxRzVvSUdocVB2d3NWamVYb3FQ?=
 =?utf-8?B?NG9SNHMrRjIwdGZvMVhkMFZjNGk4ekwzcG5hUXd0Vk50U21XdlAvR3NMM3hH?=
 =?utf-8?B?aDBGaW9FbFJpRmoyMlcvbVdWZmF5TkxoeGNmMHl6Q0lHdHlZQjMzdWRORUc2?=
 =?utf-8?B?eERNNFBTNzhCZlA5OHBHczc5K0tYK2tXZHpmQyt6bFVVd3VmRFBJT1hsdzhj?=
 =?utf-8?B?R0hZTnpGOW90SndtaXhXVFg0ZS9KaUwyV1pFcVltb1Zha25IZ0dmMjVtV2Fv?=
 =?utf-8?B?ZDhiSE9TZUd6SlUxTU9Tem1ZcFh1cWlCNTJOZWJxQ0dqU3k2T0NyeDdJNkc5?=
 =?utf-8?B?aHNHcm9KOFFYY2M2M3pQYVhjellCODRjWVNmbUlPZGM4U3E5SVBNbjAyNldV?=
 =?utf-8?B?ZnNNdWt0MkF6Uktpd1VPUEp2RDc0ZGNCUVpoRDRra1EvU0NUT0s1eUhHd3Bx?=
 =?utf-8?B?aEM5MGNKYjdVZ2RpZklybmhFTWxma25PZEFQaEtEUGtWZ1Z4TnBzL1hWempq?=
 =?utf-8?B?Y0htQmZ3amtWMEVKSW11VjJFbkFYZGFqQWtlSW5kZDJrQStMWlA1cThzWFlC?=
 =?utf-8?B?YUZMNjAzUlRLNFpzQi9uNS92VXhJYTlKQVVwTk9LUERWeEdkSE8xTTd3Rml6?=
 =?utf-8?B?VmpycDdGWVpOcDIwcTdFK3FTaGxKVzBTWWEvYkV0OVFua3JVanVORnh2SjlO?=
 =?utf-8?B?QzhRTjZweUZyV3dwV0ZTeG4rV3ordzBtV0krUVpLT3hnQnlxVmUyNEIyd1F0?=
 =?utf-8?B?dGpjU01MaFlrOTJPYzN4cDd0bWpoUTYvZWl6REYwUjBWMU44Y1ZUQXRvOE1x?=
 =?utf-8?B?OGg3RlZ5S1FMUzM3d3VaREhySVd0Z053NVF1eVZDZkZGclAzN0ticWNUUmtn?=
 =?utf-8?B?QVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?aTlsYU1vMkR6QXVxVFZEQUIvbDNuY1Q3MS9jRkUyWTZRNzVEMnJMOVI3Z0w1?=
 =?utf-8?B?T1gzNUdUQ0VKZkhzVi9zY2M5diswUnBEM1ZESDVvUWVZdUkrK2p4bW1jcmQ3?=
 =?utf-8?B?VGpHVVFlZk5sYy9vdzNWRDF0Z2N4dW5PV0VWd3NlUEtuY21jQUoxaUE3dXl6?=
 =?utf-8?B?YWUwMU5Nb3lGUnBaS1htRXJVTzNCRXc5K21HQ3BJRFljRXB6Z3BuUEpobjBk?=
 =?utf-8?B?bUhGSS9LOUxtdlRUWmJPNXJSUU1HdHlkSG5hdHRhT0tBTVo3RitXUGZRbisz?=
 =?utf-8?B?dGRRTUg3RzFtaGpZb3BLRTR0VTJXRGJ2QjVlOXZvT28zZkJqRXFNYUtmcFNJ?=
 =?utf-8?B?OXFuMXFlZTJiL29VekRhOUk2bnlYTytWemRDRCsySE1RWnhsZTJTWWJnQmlD?=
 =?utf-8?B?aHBaTUlCTGVJTE1QNVdGLzNHbVRzNlRvUE1LTGhyazR4MEVjTEVmemZEeVQ0?=
 =?utf-8?B?TjMxenZ6RXVwaTRubEVycld0dHBsUjZsbkVIdGtxaHptS0NmbHVSMEFqT09U?=
 =?utf-8?B?dzFheU9QN1RDSXYzTkhJVks3c1pQeXVRNVUyVXZqTTR0SjJmVkJZOTdNK05I?=
 =?utf-8?B?OHhWNEtxZ3B3TWYzaTUyWGRYMktoemNyczBRZzRpdE1IaDMralVrNjBha3Rs?=
 =?utf-8?B?YlZNaGNJZHN2UHVQQUN6aFFHYXN6eDljVVR0azhzM0ZYYnYxQnc3dWIwRU5S?=
 =?utf-8?B?dUJzeXJwTFFvdjRPVDJtY01FUEcrR1poZlp2OVN4cFM4N05DaGhHM3gwUVpB?=
 =?utf-8?B?QjJwbjZnNm5hUCtRalNjOFkwb3lHUjM4WHcxQlNRbGVDbjI4ajNvUFVybVNR?=
 =?utf-8?B?WmFwOWhSQzBCaE8zVEZIK2RvNnJPN3dVeEhUbXN2Zzkxc2FFNVVaLzlIMHpZ?=
 =?utf-8?B?SkVCNUU1ZXNaMHpFV2ZGdzV4bDZvcVl4Ky9MbWNTL05yRlRsYUpCZUlnTTJk?=
 =?utf-8?B?QzJjT3k4dDBvLy9RcFZhTzNMZ1VLbHMzQmRSMU0rcHV3dnRmMCtKMFg3djBW?=
 =?utf-8?B?VEoxeHdGR2ZUblpEb3lHdG84c0NUWU5NeWlYakxEMnQwY05COXlrMDVSWXR4?=
 =?utf-8?B?UEI1Mm90RlVJeWRPTExZOHpGbEI5WE9WRldpV2I1VXk5QlAzelliLzRzNTdU?=
 =?utf-8?B?RUZDQW9McGtWV29BMS9rNmRodUsydFE5Vk5QbVNmdzVLTVFvbXpnSVp1UVR5?=
 =?utf-8?B?aHc4d1JlSnJvUnY4dzFpY25zTGtycGhBVWJWRUk4ZFB4ajFNODBvREhUUTdU?=
 =?utf-8?B?bG9DYThwTmQ1TEc4c1ZnWDd0WHYyQUpMN053b1RCaGlaN0lmMGFsTXNmRjZW?=
 =?utf-8?B?UTZucGdMNjhiRGYyMFNneEhFRXh1YS9QcFBRZXFwaERocXAvOFlSZm5KUW9Q?=
 =?utf-8?Q?tSuZPQt3wzKPKUG1q4CWz8tpwBqRGhfI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b6240fe-e63a-45e8-1179-08dad2511141
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:31:25.2507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 19P03kGKKgXSlIpuirHIhAF6mrJutmgrzuiRSgO6FAxAjTnEVz8GK745KDMrmehzhyrUoEDMH+rKghG0ntkhnoN8qzQHYli+RC3OmKYgU5Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290126
X-Proofpoint-ORIG-GUID: km6SGvHxf01NtwAVLtcn-g-joFFdySIb
X-Proofpoint-GUID: km6SGvHxf01NtwAVLtcn-g-joFFdySIb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/29/22 8:00 AM, Jens Axboe wrote:
> On 11/29/22 6:28 AM, hch@lst.de wrote:
>> On Tue, Nov 29, 2022 at 04:18:19AM +0000, Chaitanya Kulkarni wrote:
>>>> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
>>>>
>>>
>>> perhaps a block tree since it has block/scsi/nvme ?
>>
>> I think Mike has SCSI work that builds on top of this, and reservations
>> ar originally a SCSI feature.  But either block or scsi is fine with
>> me.
> 
> I'm fine with scsi or block, I'm assuming we won't have any
> conflicts from this on the block/nvme side?

This patchset has no conflicts with anyone's trees right now.

I have more patchsets that also touch the block, scsi and nvme
layers that build on this set. The future patches are more
heavy on the scsi side if that makes a difference.

> 
> If we're doing block just let me know and I can queue it up.
> 

