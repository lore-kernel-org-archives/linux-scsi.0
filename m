Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4E0C197A0
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 09:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjKPJpp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Nov 2023 04:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235663AbjKPJpn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2023 04:45:43 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD2C1A3
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2023 01:45:40 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AG9JAp2009809;
        Thu, 16 Nov 2023 09:45:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=KG+7qeGiur3nPZ60mDJHYZCAW7DotMuZz+4Sqdm6JCg=;
 b=eNeicvOQYkYUaqNW1ieKz8PjIslzy81+FNb1O4Dnr6kCReLr1XsrooxgtEh2JxeHAP1R
 4agZSw4wcwm2A0cGsl0e/5STuWcVB+ZhBwU8Q+gCSsGs7l0QvUEUqWuAcbzOaZH1ZH98
 bQ6S6IaHjK5rxdjxKVZYg3SNelBEa64TvcUL8ZQ5GbS36meLXhoKoGKYSIz9UfQWjwD4
 NI1r7FVkYhvVqET6zXmQRZcpSscvtz3j1YVeQnuX6S+lxFHBg3l33AD+EK9vIRlF7lYV
 VFlgplg8lGlkUd6yTMzoSEpu29jcDMVjJFFgTbZmoHIkwSi9Jq3mpHHXAb6RvnGDz7qu Pg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2qdahx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 09:45:26 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AG9bZqn006440;
        Thu, 16 Nov 2023 09:45:25 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxh4k8tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 09:45:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTg/EoTQgBuSHoFtq5qnPVwP9m66yLvGbtpp7AnGXx89SJTW+g4MuE/4U3H8Ns8PTAx5+SmudlbxQfVfx4kj6kpUPHOsEa3qUfPrcWnQvHlrpLkfdgpjkzpbO/PQ22uZPlV+aW3KcnuOilogXUoVeVS2l9sy6+TaioGTjbTGMmHEB+fkWtMYEF+TgboQXXkLuljlWD9PeJeSINpk3gr8Qlswnkm/RMOTjjieIvAKc+AfjcZMOEtR4eq7xy4v61OHHMjxR/HcwR+09nca8NSwZ6lUSFlIwtgxL6DmnQVxEUiKU5WhQ+yBT7yhWGjCyvH9+PmQLrOx/bVXr0WegpAwOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KG+7qeGiur3nPZ60mDJHYZCAW7DotMuZz+4Sqdm6JCg=;
 b=i9Aj/mygRa/VrtbhysXJq/Qfd77Fsqq4QMRbIOy9vOkhkUnYJ+HTFQL0fvLkf4qjqvIlFcVSkbk9sFLlapauFEVNkLxPBMFWCEKymnwEYcMy7+xXBS7rdG7u3QuheOvIToDDgbxrhn3EBBMFOKTi4WsTWWB8i/BDUhr18gvp27v5At7UInDTRq+xRXTDcRpt2uYpsZDo2itI0wVY6/I0ufVOCJm19ax8iJGHA22J7UcidVxFPJBdqSawUZe6yN9BDsZgOBYli2uzWEJZ1TxPB/rom8O2USCQy3DTKjmkbxJLUKG+u+JeTe67RKaiP5smT0Nmiv661Vov+qB5BBuR0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KG+7qeGiur3nPZ60mDJHYZCAW7DotMuZz+4Sqdm6JCg=;
 b=nSJiarp4Lx4nQl4fazjnNdHtXjAaryP77BNYiqPwJ+s+HVA3vrfzmjOyJ4Dg6OeanrA7C+MZ5Ldh6tbWTqwmCoKabMycpfKVZsZYhDzEM5jOqZS93GPXOLfTuAu+dVWuwl+OThqo6bJm94B0r+ttHHTjczErqzqu6lYg/pJKkkE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB5333.namprd10.prod.outlook.com (2603:10b6:408:115::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.21; Thu, 16 Nov
 2023 09:45:23 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::102a:f31:30c6:3187]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::102a:f31:30c6:3187%4]) with mapi id 15.20.7002.021; Thu, 16 Nov 2023
 09:45:23 +0000
Message-ID: <23e26659-5758-4c5c-a1d4-639edd29d496@oracle.com>
Date:   Thu, 16 Nov 2023 09:45:20 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Add a precondition check in
 scsi_eh_scmd_add()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20231115193343.2262013-1-bvanassche@acm.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20231115193343.2262013-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0021.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB5333:EE_
X-MS-Office365-Filtering-Correlation-Id: f225c9c1-7409-46e6-7f38-08dbe688c12e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6gwkNQELZlPB3N4W3gPMxhYpBzC80cgSYiyQ6NO8DW0nNuAGOK4zIpKW3m2p744sa7Q234/wRxeyBlLiXvP2MI5apyicC65rJwlDmPMydYw4aoAhVr9JnuxVJFHXb+Cj5qXeUSPXAkXK3QYAYy37D36B1I/GtK6BiiS/aaGTsEbL0RKryKcBJB9dYQPCNNkhFNy9cyqDBBbs8qVmjJ/4UZylgyNDzDRxoFVznswqHVG3NdBYPENl/uQFuGu43sxwy+lwslN41k4O4GyXDPYG6dYe5oe2urOU1DbPRyqE1B9HB8RA70SrHWpx9VGgRI5ExZIL6i471KYPI+G1cBxcJloQplkHrzB7jMrdkhxTyJ1Cno7cZR5x7RvrBTOiZIWpRuq+iXUxUso5+esfvmukn5XaRYhYhVefKmIFs0tlVF6vtmeQRaWkzFKFkR5EX0RuooyOneCHQSCTLk8tq+QX/lHjW4RTiD6O5RcSpSJ3GA57V1ecf/JVuWoSxF9iy1sfD/vjszTuU7Ye3b0i6ETM6zSX9JhyEjM72PFqZolPN7oZSK4zJPRfbIQgV1OmyUAbPRoe93iRQB7r3H6uhCiwMaM/JMqn8SGe14Y1DvUTaYJgo2/2rt2hcETSS078n6DPxXF1qYjfWiBsFA07aaAgjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(136003)(366004)(39860400002)(346002)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(2906002)(5660300002)(4326008)(8676002)(41300700001)(8936002)(316002)(54906003)(66476007)(66556008)(66946007)(6636002)(110136005)(478600001)(6486002)(36916002)(6512007)(6506007)(53546011)(31686004)(2616005)(83380400001)(26005)(38100700002)(86362001)(36756003)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1pVRzRxKytudnhFQnlHMWQ3SjZuMDJYaERlNHJYTkxLVjh1cHJEa0Iwak9G?=
 =?utf-8?B?NWZ4WmoycXZwQkVSVUNSMm1MRng2eVJvZWhmcUp3S2lTQTNseGhpTFNUMnlj?=
 =?utf-8?B?NDVtQkhrdFJtdUhoZGlOWGtsMmZRRUhUeDZhOGZHazl4NUpyQWRjVDh4bjZs?=
 =?utf-8?B?T2lYaG9YOTZrbHplRktrQkRyVHlFTGROYXdDQmJ0WkZUcnNkT2wydm9rc1kv?=
 =?utf-8?B?NGZEYXVPdHROalBFdmJwMWZBQlZiMGRYcVByZG1KdU5JQVVCTDlvU3VodnJP?=
 =?utf-8?B?YVJBTklGcUU3akgySSs4a3dNbDZrZ1owNDd6cE1NdWZEMmZFQnhETWJHQ2dj?=
 =?utf-8?B?OTNOMmpwaUtwNS9pR3A4S0pWWHBtUkZETW9jNTFVaXRCdDdNYTY3aEVZdWFa?=
 =?utf-8?B?cGtraFlSK21PYjhTQTFQSjFSQ1M0cHdaUHhBcjh4eEZ0UThMK1RRaW1UQVN3?=
 =?utf-8?B?S0RXTTQrYzhIN2hyc2NiNk5oN01rRWRCRWxub2lIZ3VpRS9iUXZyMmpBR240?=
 =?utf-8?B?a2VRd0hwbzlPQjREMUtuTEJ5VnBpcG10YmZpR0lOQ1FOK2VFajcrdVV3Znpn?=
 =?utf-8?B?QVBGd2xYSlBJYzR3OWJUa3MzSWdRUHlHU2FYSmU5RlhhV1h4bEY1NzRnRW5L?=
 =?utf-8?B?NVZBUm5WQWN6dmgzQ0QwWHNRLzdCcGU4bkVTbG9uNXVlUThOWENXLzhmaTRl?=
 =?utf-8?B?VU9UazFVSVkzMlN5TUxoRmZCaVBiNUVUdDd6RWxvU0xxQmtqR1N2NXJQVUJ0?=
 =?utf-8?B?TFl2QlNqOUl2LzNheW9LM011OHN6TmFpcDA1T2lobUFNOVAvelZMMzcwQ0w2?=
 =?utf-8?B?bmpIaWxiK3BsR0x5RnN1dDErYStTQ2ViT28vMzIzU2UxNjRmaS9VWEY1SjM5?=
 =?utf-8?B?dWN2aDZDMlZlcEJqQkFxVUhBN1hQck1WYWJMTWNIaFlReUxZbkxWRXZjcVpI?=
 =?utf-8?B?UEx0YkhZekZhS0FKZlpGUU9tMmVqYVhLb2xOUEdFMURWTXBWa29pS1QvVElT?=
 =?utf-8?B?eWcvNlJvTU1mbDROaG40aUJzUTlpNDdldVhNUEh2bXFUb3FQYkhlU2hnSjdz?=
 =?utf-8?B?ZUpTRkQyRUttU0hBL0tLV3E2cVI3bFZNWDJZc05GK002ODZPZjR4QkRvaGJT?=
 =?utf-8?B?L1NmNFdoU1ZMQVdJcENtaU1SejIvSE9qa3JCQWNBYlhiU1Rsb0FsamlGakFq?=
 =?utf-8?B?RU51UjA2b3pWSFpicldGLzdOZ0UxMGlNNWVSM3orUnRlaE9sOGJybG5VY2FV?=
 =?utf-8?B?clFtRUs2aTVBQWE4UXh1cjdqSFdLTTc2aE41UUtNM2tIRHV6TEZYVTdXK2o4?=
 =?utf-8?B?akFZeCtCVUhjRWl6aU9iOGdPWTJ5NGtoZW1ReThDMmlHZUNyTm4vQ0ZXdzMy?=
 =?utf-8?B?VzE4YVlFNWZ0OW9tOHV3eXJ0NENTNWF2SlJFUGJQYWZza1ZSTUF2SXdES1Av?=
 =?utf-8?B?TXZpa3hYUSt4UElDN0ZyWEFMOTkxcXpEbm54VFErZWFacTFEWXg3bHZiWFhP?=
 =?utf-8?B?cEljZFIxYnZMUUZGaHcwa1JvVlRJZ0EwZVVHK1ZES0JoaXh0MVJ4NDA2Wnc0?=
 =?utf-8?B?TWpTenYycE1wcFRhTEVuN0dUd0FySG5BSlZ1QUM1TnE4ZFo5S2JkbDdhZWxa?=
 =?utf-8?B?QXVYbDQwaU5mQlNWNnd3Q200WHdpRVlWcXNPdTFOdmlPY1pMb3BoMW5rcnYz?=
 =?utf-8?B?Rjh4VURTL3VTM2prUFVtYUo5eElnRVB1dHA3eWVwV3JmYjIxUnRyU2xEcCsr?=
 =?utf-8?B?SnFCU0ZtTHZRRGZMalN5R3VWUG1ycEkrUTIzeUJzbXM3SFhnKys4ZVJDTlkr?=
 =?utf-8?B?V3RSUUxackpIZFgvbWlJOG4wWWV3aEVSQUtwNGhadGRYb3pYQS9ibVp1VkZa?=
 =?utf-8?B?MkZCdXZnQ1RUUUFaaDMyUXJwQ0xRRUVpTWo5UWtyTUVmQm5CTTVmbmdPakZv?=
 =?utf-8?B?M0llR2tTclZGQ21sYzRYUE5TcEtjUWRTc0toblBXSTA4NUs4Q3NxalZvMTVG?=
 =?utf-8?B?UzNQZWVYTXpHdTBuc0NhYVFlbmhnQi9XV2g4Um5aWkkvVDJOWTFqaFM3bSt4?=
 =?utf-8?B?MkJVa0dmM2E0emJNMnMrTm9uZ1IxVG1aQll2anRCK1FiWDdHNGxsM1o1QmMx?=
 =?utf-8?Q?kne4kXrtM3QrxZVCFnVYhbHAG?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: r0ind/fzdhXY3qk6+537i71B71KOp3LLK6qp7eScBFS2eSL4ZB14BL/qyDelmWDgrH1TwSMMb4OSsdBqVCAdumNjO/lvlKdfOTR40MDglh3CA5fzbc+V4xo94lUH1b6XDTdqKa9q96k9SVCZaFaW5KQan/hVgo7cFiWVOtpYgnm1IEHdRPwQAsd7vbjfo7YErdvh1pIZu6koXG4Uw31McaHy+hffGmUHT4812/6p8g6m4f65ULC3jy1eO3n55lCyycPs8UEkaODcwoFQVPY2qc1y2evX0dUI8vRnwlltIMVPlpF58wI7eM3x1oEZEIF7CT/FmwoqzhCkn4cj17ZPBbBfmIkwv0ESmDzBBhReURPmqvYYlhFBxN6JXdCAvyYMe+K6abkJY9nWz8nu+o1cLPyyh5KJUc75/PawnqjnYwijiYeutEC2dUM9ZS1z0A9ylBAkJt29NsDhegZm0+QI5bnQ2hxKFOmFPdK/iH70I3WTLrdDhz0pEj5hg9rJ7biHb1YVasaERUkxF4AWoRV1G3J1e5Ks2TowZXZm7YfFgKHBNBsR6qMJsLdXspEQKkP76uzoX1jAcNAGyyOv4A/snx38QyKQlvK3dRhsebnNhGN+5XdeR+xqEFiyFydABd0ZuV908z7633whXMc4685C7MbwQ+HppkIDJZU6NhIGAqg7DvGdZFcT9yOGPUZlACy48v+p7FOnWQGrUGLc/zCjQf8K/rWantiOShZtxQzc4oAlXsQPzb9knC+W3c4xCiOp0nAQZsm0r22uRl9MO2gkPZ7LRhgJdlHrBWoD/f1P9r6nUZ356/p8Ol4xinC8i0vbZugXZv9JjoaCvNrR4Tepa1b8ZxQXsathCThvo1oUvmPBi/SsDagwUlXp/Q8YV4QDACCIuyyco2jYm10ZXltxvQoJGBpSK++RxKasIjcONlg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f225c9c1-7409-46e6-7f38-08dbe688c12e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2023 09:45:23.6267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N8heDxw+K5ToSLjzO+/164dCxHIHYMh/81e2R97EP1W1KhoXdHPU1RCPpUtDCHfTCmwbezAczBU0vD4EHTLhAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5333
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_07,2023-11-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311160077
X-Proofpoint-ORIG-GUID: nF8T6oPckH3viFmA5jrXKmypA8QCZIGi
X-Proofpoint-GUID: nF8T6oPckH3viFmA5jrXKmypA8QCZIGi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 15/11/2023 19:33, Bart Van Assche wrote:
> Calling scsi_eh_scmd_add() may cause the error handler never to be woken
> up because this may result in shost->host_failed to become larger than
> scsi_host_busy(shost). 

This is oddly worded. I think that you need to mention how calling 
scsi_eh_scmd_add() may lead to this scenario occurring.

> Hence complain if scsi_eh_scmd_add() is called
> after SCMD_STATE_INFLIGHT has been cleared.

Now you hint that this mentioned scenario may occur if 
SCMD_STATE_INFLIGHT was cleared.

Can you provide some info on when scsi_eh_scmd_add() could be called for 
SCMD_STATE_INFLIGHT cleared? Or is it that you don't know how (it may 
occur), but it is fatal if it does and we should guard against or warn 
about it.

> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_error.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index d7f2d90719fd..0734b3f30ef5 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -290,6 +290,7 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
>   	int ret;
>   
>   	WARN_ON_ONCE(!shost->ehandler);
> +	WARN_ON_ONCE(!test_bit(SCMD_STATE_INFLIGHT, &scmd->state));

What about if SCMD_STATE_COMPLETE is set - should we also warn about that?

>   
>   	spin_lock_irqsave(shost->host_lock, flags);
>   	if (scsi_host_set_state(shost, SHOST_RECOVERY)) {


Thanks,
John

