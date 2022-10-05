Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A6CC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Oct 2022 16:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiJEQSs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Oct 2022 12:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiJEQSq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Oct 2022 12:18:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CCD7E003
        for <linux-scsi@vger.kernel.org>; Wed,  5 Oct 2022 09:18:44 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 295EdjAW021590;
        Wed, 5 Oct 2022 16:18:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=rz+kd78uvLzgcf3Um5imaKtO82RN725qaPcMLJeiOj8=;
 b=u17ocEnIM7guGAykCvRlxyaq8ytTzA8vWBJj90SOvcVk3yJHlV562d9qb8XA8NMgDG2p
 TT0UGpdh6TXCLKMmye4Vu6a1hYDIjp2VxhA4VihKpHoErFhQWcWzStC6dfbO5tOB92Gi
 IE3px6mjoNuUzRmW/AX3kCA+mIfPI7/inmPA6GRSGssv06J/yYDiTRcfHnrt0Se7jVXo
 S3UxH+MkjRPhsGRrlaDhL8xT2tIVFmXtn8edFbXAEntXh/PmI3opVhQj+b3vAjpallgc
 oRbXY89XsFqLHVh/IDjukIEi1EFX2xNCJa4lcpKVfxDHAeNTEjYe0XdEfHQO/WPoMIwy Bw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxc521y7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 16:18:28 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 295EYIlc029564;
        Wed, 5 Oct 2022 16:18:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc05qy42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 16:18:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ef475y+wL3hOTqM8kHlp886EyBvGdaTeXs2dOwVw4Bv34qjAxBJr8Mi0pHcL3GYR/+c0HwGLcirF7mlkcTJ9wAo0tJmzuw+v5HmFRY2IniLrcv92stZJyRdiN622ubZuwp4vTl3Rx6O0dNqVbNyydMb0CvCQz5KZlH3hQCEDAJIb/HaUEatdkaoMDg++zLtvFA+tviDyPmGPK6plHPRyC2o06Gk6D3r/BWDJ9aPr1IkPx/m0b04Hxmta8VEwz3ERxPSvh10NmhQabl28PUAjS1LC4opDyUpNa+8fKLgHey1ZCzDNPIPpjDxJ69vlCrba6L6shNgsndXcmy5msZLQ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rz+kd78uvLzgcf3Um5imaKtO82RN725qaPcMLJeiOj8=;
 b=HC0M7kTYPlHhQjBx9YYBp+i3c2r9Y6XHntpICRQjQI9smwD9eiHDd6JIYaIHJgtdYgQPt1YCUX4p6nC+u0NnadrQ6YAo2JOIOyoUjKrthYfNjHMDkjYM6LCDpVI44R2Hf2F61mnwH2iR8R+reBwst/nTsuYFSr1wXLb1lSsBxF7cWU/nZOwUEBvRDSKvdUO8RyszDlwk7AOrij/iTNMELFd8Ft203B/hMznbWtZOJF2Dn0HyKujOB+EQ0RKOjqWjDnNCey2xA+AMn0+Q3JjQJhRb43XKGUmygNbb7w06os/aOlvwzbZqw5YeucEQ65usKsitvjlhO5SyRrStLNt5ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rz+kd78uvLzgcf3Um5imaKtO82RN725qaPcMLJeiOj8=;
 b=cMz0fVNtB5TjW2Ka1dlmjO0+PrQzbz9I0uSXjvlYMCfnEfjniKTIkjVBxe99biKH/OSFbKYfYfTJE9rjX3Lnh5atMxk3cYjH81Mz6Q1mx7SpKq2yZqu+tpbg54sa3b5sYqRABA+twh8Ff9nRrVkEHTCUD91PH9H7tArnUHFikow=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5103.namprd10.prod.outlook.com (2603:10b6:5:3a8::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.28; Wed, 5 Oct 2022 16:18:25 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.034; Wed, 5 Oct 2022
 16:18:25 +0000
Message-ID: <48692e04-71a2-0b95-5713-8c25a0fee227@oracle.com>
Date:   Wed, 5 Oct 2022 11:18:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v3 02/35] scsi: Allow passthrough to override what errors
 to retry
To:     Bart Van Assche <bvanassche@acm.org>, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-3-michael.christie@oracle.com>
 <1c610cd3-505a-df66-dc05-1f7eb3e460af@acm.org>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <1c610cd3-505a-df66-dc05-1f7eb3e460af@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR04CA0113.namprd04.prod.outlook.com
 (2603:10b6:610:75::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5103:EE_
X-MS-Office365-Filtering-Correlation-Id: e93b072b-83d9-47a6-eeb7-08daa6ed3b2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VCWB3q8T1dyPe4bg3W9I2F5AfZHEScBHZLJxHZ7AVWdRvt97Olb/78btVvsXiD1FAiwHHO+mJYG/P/KhSNEgkE09AdepLPfG7zm82DNn8JY9VLex6fd6k0NduqNZTml9CYcUkp0WWAnNXuuEaWikOEcMqRT7neZ/fwBlupsTsxnrwPz0qdCFIjJbp2Hhtg2Jd9msHRYLCn27vqn0ncAGcswNK9pP5+RIb3SL6aQ41+Jz88hRpqiiOD7ZDEMNLb4zKXkYczJgl+qaG6elwq3rprgDZNdkmJSjfXYUb/QdorUEQiEs4Ek2x+YXuC82kYKbW4rj6TSKFMPWmx1hbhq/G7GOoEbFAs2QvcOtUPw+kK8uV+APEYfcvX0PvUsf4MFYs1Z9MV3tCZm+OXIdZyJcdGYKZhXXiIcrfz4gH7Ma3JU/Jsel2efxAbyKTUtUkWfhpnG2VBQVNTj1Mvt+/NG8kGyOMoLoSn3TDfFi15TilVjxvQTm6XF7Cg4XqWa8MfU6g4dFAK+IZoQi704cOBP/buqa2Jfh7fREN1FmBmNOpmF8Aavg9CFcfxJkVOAmRJ/fNCNsBx6Bl9ATmExUUA9LA/moqdCGdk0/H1tNo2u2e4NDBKz1F8eLlOC4jSJm5Rzd8RlMOFtbJZsiCkm1DCSvpn7uk9tI3Qs6Ta2I92QVbDpO78tsVavOejFcsd8MTXkNotcWuazZxhQA7NASihCC4bbMWRWZDqVxDVL0wDfTkURoRSKc0eVRLpeAcRMEgdmwPxHNxtT4t8aVcEnfyFMm/9IcRrfxD+MLx4eftNBf4XM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(376002)(136003)(39860400002)(396003)(451199015)(6512007)(38100700002)(2616005)(8676002)(66946007)(66556008)(66476007)(53546011)(26005)(6506007)(86362001)(36756003)(83380400001)(31696002)(478600001)(186003)(6486002)(316002)(31686004)(8936002)(5660300002)(2906002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnhuK0ZrRHNFTFpRcHp4L2ZGU05uNWpuY0J3QnAwNU1Hei93RHdEdUd4eFN4?=
 =?utf-8?B?NFZ0V01HLzRwQkFsVk0rM0tlT3Q5QkRRZDFReUdUa2hla2hhN1p4MXlLbndI?=
 =?utf-8?B?YjloWllGZHdiUW1EYmpBaklLY2U2Nzg0Mmc2SWRpdUl4S2U2T0t1UnFaTGVM?=
 =?utf-8?B?dFEzMmxKMVNuNlU4VmdubGRzVlVJcWU4N1o4WTlGNm1MVkxhazJKaFJPZEF1?=
 =?utf-8?B?Y29VTjNrdkowYjJ1bW9JZGlUcHp3MUhrWW1zSDJ3cUxPMlNWcmtQbEw2UWY1?=
 =?utf-8?B?bUNlSE9TQW9kWjgveWhFM1pkcmloWXJsblZiSXZUbkx4dUl3QmkzS2xOM2Vz?=
 =?utf-8?B?Z1UwczYyTEN6NnVPOUg5WVZsZmYvSFpyTnpTN3Y5cnF2SGwrelNYRXFpU1FV?=
 =?utf-8?B?dEZWaS84ZC9Xa252NzZDMW5WUVdEWktzVHNWRTJBbjFMRGFxanFveGxEWUph?=
 =?utf-8?B?L3hWbm5zT3h5RmMydFB4ekxWczVaSk9wUEZzUDdUK3BXbFdka1dmaGdnenpl?=
 =?utf-8?B?cTZCTTdBZ2ttalZ3eFJNM2hIeHpDSlFVSEp5M0pLcEtjOStvZy9JOXMxRlRt?=
 =?utf-8?B?SlNJR0djSWdDMUFpR0NyMlNZL2pDdkZleFljeVNZcFd4cU0rOGpsb2locnh3?=
 =?utf-8?B?eDRNNEVlTGV4djRGbEs2eDU3YlZwVHU1bzR5T24xUDUrakdKMDRaQ1hsc2pF?=
 =?utf-8?B?TEVkU1o0REhkTWl4eXBEb0ZZSzV1VVVzVGxJTGwxUHp3aDlIUFR3OWticTc3?=
 =?utf-8?B?MFJNTnpRVE9jcWZYam94bndDQTVZMWYrNEVPdk84K1FubmpkUitqVzI4K1Ey?=
 =?utf-8?B?d2dOd2x5eHo4R0IrVXFyWmFSS1JIam9GTEpHRUhuOVVDRWJiQlZPd1dqM1RM?=
 =?utf-8?B?NTBvVmJLamtDQW9xVVhNUFJyS3ROVlh5cGJiSDZmZ2QzQ0Z1Wm5xSlgrdnla?=
 =?utf-8?B?b2swTnA4RllncW9oVTkzNmNDTWhKbTVHVmZHZCthSUorM3FyVm04WVVSNCts?=
 =?utf-8?B?Wm4yaStmc1RNcmVyS3VtVUlWRW1yNjlXUERTUU9FeHRKNGE1MTFGRlZoWi9J?=
 =?utf-8?B?UEZCbUN5bjVrMExFeGsvYjBUUitLZDg3cnZCUmRWN01EelhkWFFvRVBrK2xi?=
 =?utf-8?B?cWVFSitHZFVhMndQMG1Qb0ZPbE9SMjUwSVNGSzNEcGw1Rm5lQU5HcEl1bm54?=
 =?utf-8?B?N3BlblpzTXQ5dkFKTlF5UXlSNTdITXhTN0xDUGZ2TjlkU09pU294bC9Gci8w?=
 =?utf-8?B?YnpBamREUVE0akk4Ym9CS3ZlK0RkSVVwMTUrRlp5MEdVcHBobUlCUXRaODZy?=
 =?utf-8?B?V1lUeFNUUHNpbnh6d1BqSk5vZW5GZEFxclVMN1dneXFLVUpPYVE1QVErTndk?=
 =?utf-8?B?SEFBRlFFTEJPUHhUeDRZTE5ERWt4ZUpQb2JkLzFjS2hMbmsyTkQyVkJJQmdm?=
 =?utf-8?B?VTdQYjIwd25aMmRBZlJWd1ZxZ0RtcVB1elBnb3Y0YTNXOGl0WU1OSGcxZHZS?=
 =?utf-8?B?TkNPZ0Zsa1Q5NmRmRnI0aEF5ajlZQWRLWmxQZWxwWnBkclNzbzI1U3F1RnZ1?=
 =?utf-8?B?UVIvQlRFdHRSNU5XazFLZEVuQ1p5QUtQdGRvc2tpaWpXakNzTjRFeGZBNHBD?=
 =?utf-8?B?K1dOVFVtSHNMOFVzOUNSakhlMEtOWkJ1SzVBTGNXZXpRZnBrdGsrd2QycnQw?=
 =?utf-8?B?QlliTU1QdGhzZmhoSHY4OVNhSk9ZU3FmdjdYaC94NEtHVUJTRG9kSlVNbmhM?=
 =?utf-8?B?VFZWTWVXazdJUFMwcHpaaEd2b1FydnB2S3JTL0hzWXFzMDhNdlFxS2ZzYzJh?=
 =?utf-8?B?ZDhhT2djSGFZK003d1p6RjFnSDd0Zm5TNmtkaGZucFVXUHUvbnN6UE1TVHl6?=
 =?utf-8?B?NTJ5NFozRnhSWXZQS1FuVE5EMmUxc0tmTDRhSGEwQWRWN3F2VExpQ0pCWXRK?=
 =?utf-8?B?VngwQlZzYlhlYS9YS01DUzdnR3U1emE5c0pqTnoyd2pxVW1rejgwc3BDekFm?=
 =?utf-8?B?Y0dJaXJPa2hnTnFGSzEyRkZDN2xsTE1zUEhXUmZUWjh2NS8yS1JTdW0yN1pB?=
 =?utf-8?B?ak5PN3pHdk83N2xtZTFQWG9JU2dJYWhJbUVPUmF5ejZYb2VOMlNkditlYlpq?=
 =?utf-8?B?dVpDeHNBdDhFSk9DRDdBcHBtNVdlUDZXVDRKbVhZc29TQ3dGZTRHUnRIOXN0?=
 =?utf-8?B?UVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: EY/OiT5MZ3ZBqyJq/aFi+zCTzbYj50bAwt96cPPXYpV/xUzI0AlPpQgdxLhVX7PEQtj2XxNKO6H5e+0IDsxgLz0rZJdizjxhL5wdcbExbYRrrIOenVsWcSMXRndCKKHHnIVqLryC0xSmlaf7LJ2lt694/ML7V2sZRBqUA6vOAi2AGtf1Sb6WFbXmS8Fxo1vAXt3PDIAyMMjGHcxrzbZLy1YCq1pjI/s1JlO4OQPKdvyhKtQ2NJpxBwI5IBw4rXIzNrQnnJ6opH7rOIm5DUb2SF5NPhKxEh9V/iVMAbRPTaeynOEdZ3OeCjbbFvriBBZ+rPg9BIo0dGecU1zXljX2Rq5SnN4AFgGicg1AmJHKm2Z6vNxkDA/Wcd/RT2cJq6qpsOfrslmzB5hUxe/SIHuLjIhDZUuIZ2wR+AP8Dk1ud1XOw4mOhe0UbGyg2/b60QNVWLauczvYwspXJWm1PPAL5VlGIkkIlwOYsdeoQPzH6btNqTW3CHfV0dXX4g1EkR6wntMzDTU70S5m8ljepwiq5YGXNa5znLPL343DZjukcv4UlW+4iOufwMFnH+fbOx2QIy3zdKa6vqgqE97P3Mnr/BKLj/PbE4rLc+CNs2TCtroV2rHZWQyXMGlmYap38z22BLClmLAkihtcExKoUWDR1gvjOu1EgJXWh9Bl7ZyIexKm8TzSqJBEtSpvzSuzoyG6HgfpdUUyj1lVerGSZSdWCp+friWNMHJs3FOTAPam+np71A81u+ySO1RLMxe7VlhGw6vHZvtPjoZ6Imp3v6knK6nzphdeYeL9TvINvrkJPodWU7PBRMiJVBQAg7NGDgN6iqjI0WY8teeryeht4xS1Y905SOurFsVIckQm4xvN8y7eDPKwqGAL3DEk3ZJCm5md
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e93b072b-83d9-47a6-eeb7-08daa6ed3b2f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 16:18:25.8365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QNfxVhNdQmUOoic/XvzMQl9o5R2kBkgmft1IO8VFUbOcfIPSsAqY425MvCA1df8HJ4F8VRyZPnOKFFA8B+Ky+o7ghFHk3ih1nO7Y61kfbzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5103
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_03,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210050101
X-Proofpoint-GUID: SIpJZaBAfj7eep7mEHmjErsbWfOcIxZb
X-Proofpoint-ORIG-GUID: SIpJZaBAfj7eep7mEHmjErsbWfOcIxZb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/4/22 5:27 PM, Bart Van Assche wrote:

Agree and will handle the other review comments.
 
>> @@ -1608,6 +1608,7 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
>>         /* Usually overridden by the ULP */
>>       cmd->allowed = 0;
>> +    cmd->failures = NULL;
>>       memset(cmd->cmnd, 0, sizeof(cmd->cmnd));
>>       return scsi_cmd_to_driver(cmd)->init_command(cmd);
>>   }
> 
> Shouldn't the cmd->failures assignment be moved into scsi_initialize_rq()
> rather than keeping it in scsi_prepare_cmd() such that the value set by
> scsi_execute() is preserved?

There is that check:

       /*
         * Special handling for passthrough commands, which don't go to the ULP
         * at all:
         */
        if (blk_rq_is_passthrough(req))
                return scsi_setup_scsi_cmnd(sdev, req);

above this code so we only hit the failures = NULL code for non-passthrough. So
the value set by scsi_execute is preserved like is done for allowed and passthrough
commands.

I agree it should be moved though. It makes more sense to be in scsi_initialize_rq
since it's only called for non passthrough right now.



> 
>> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
>> index bac55decf900..9ab97e48c5c2 100644
>> --- a/include/scsi/scsi_cmnd.h
>> +++ b/include/scsi/scsi_cmnd.h
>> @@ -65,6 +65,24 @@ enum scsi_cmnd_submitter {
>>       SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
>>   } __packed;
>>   +#define SCMD_FAILURE_NONE    0
>> +#define SCMD_FAILURE_ANY    -1
> 
> This is the same value as -EPERM. Would something like 0x7fffffff be a better
> choice for SCMD_FAILURE_ANY?

I didn't get that. All of this is used for the scsi_cmnd->result evaluation
and retries (host, status, internal bytes) which are all positive and where
we don't use -Exyx errors.


> 
>> +struct scsi_failure {
>> +    int result;
>> +    u8 sense;
>> +    u8 asc;
>> +    u8 ascq;
>> +
>> +    s8 allowed;
>> +    s8 retries;
>> +};
> 
> Why has 'retries' type s8 instead of u8?
> 

There is a:

#define SCMD_FAILURE_NO_LIMIT   -1

in the defines that got cut off when you replied which is used for some
users that had no limit on retries.


