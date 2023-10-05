Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9D6E92709
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Oct 2023 14:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbjJEOaQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbjJEO2x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2023 10:28:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22D22813B
        for <linux-scsi@vger.kernel.org>; Thu,  5 Oct 2023 06:46:34 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 395CCwns026772;
        Thu, 5 Oct 2023 12:33:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=bYvSpsB/2TCAj6dxaHA8k+MyPHSTUcww/q9Rr5J0dII=;
 b=BnUdsVYRhGNBVpVYKp7xh5KBV79Ag6jCF/c1wQAebfRNX6Jdy+n6R/Ecyq8fbjE03INh
 KE6BODZMBj+OZ1icdhBzwLE9waUV0+d8gWi1BjsQUB3YFMvQZ2i9Urn1WnTrpu9g1dC3
 3l1s6CBABlPP5bqkKoEtk4DkgyAA9ONpXT11Z9Z0G/ynalAWAZyloGww+LxL1Wl+x6ee
 3G7hj5u1g4LtUfwBUv+X3y5hUnr8YmpqqvtMQVbfmgP3lfuH9eqBUcAY5o8nO7oPb4y8
 TqjyhIzUnwHnobxjD/hgrZPpTzDrJQ9TBk/UStLrUboUGPwQK8QFekyof6SZHxSmRJxy Pg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tea3ehc5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Oct 2023 12:33:51 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 395BSDxg005863;
        Thu, 5 Oct 2023 12:33:50 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2045.outbound.protection.outlook.com [104.47.73.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tea492me3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Oct 2023 12:33:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G4S2UCe88mh7x7YKivC1+GqT1ndn3/gTCdtdp5N6kUzVFjM6orIKUh0/oFId8H4wM+Aj+P3srNwke0R1QUZvxm+m5rLuWnBHb4ChJOwyTDWl6SooiNCybPtsVo0aBRaq5ju1G/4FN8tsI3e50bSwTj+mIbVXqulGYLGANNwIO5K8YKoVDSrlOKAsQo2jTwTdTq36ywYB5btehjBPHY8Akir6ov7xycOp5HuUtS4m7bp9eUeIZzK7ewx/DeeAXz/55pyV9eOWUfHtRXYDvoNXmtor7uVHIxY/NKt6guJIYpt8siqk1i1uDDVX5X0QU7Tq9KsUFDFRbTLY0NoBZUuk5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bYvSpsB/2TCAj6dxaHA8k+MyPHSTUcww/q9Rr5J0dII=;
 b=joKBeTAkhfRVJGO4YgzK20Ag3NAvo5B0+DfffuUSmIBqXBsfZUi1t8ap7sz2DeZNYP0BqmzECvAfJPzCoJiMPUSIo4dalIp77uCpFqoPoXWi34eshPlZXUJxN0CSbUInxUCVwq9NQWqaG4j9APlLzJLeZ+CxnMxNfGJ+F1uNNhWlx19jdFpZ6yOx6qTAanUdR9Xu//ecJ+Jb4G38Tv4L0mHVg2oIT9wXZ+d/C7IalvyF1Sg0wl7tltcgQozRWY7Q7KfRVSyqjex/4QM1wn5Wp2D+oj2QgwKxxa0+Opv/Qd3kpbBt4OmqV6twC96SOgjaFH6mxlxPK4mMXzOVpRsxNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bYvSpsB/2TCAj6dxaHA8k+MyPHSTUcww/q9Rr5J0dII=;
 b=njpvoiknYn/xhMQ1oJGiX/S41aQ1AJco0QD1JQEQqCUidsNgxgeyPjQUWmNXNLmUDTO2hRO6ACBGlXTJNJ6lybQbyAKTmlUX57u7sYrRvA/EJDFTw9+pgzouc/CdSMXW5mCWPhtUnZW049rRwIQexSAGJAUr4GCy8FKuJukNHZI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4168.namprd10.prod.outlook.com (2603:10b6:610:79::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.35; Thu, 5 Oct
 2023 12:33:37 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6838.033; Thu, 5 Oct 2023
 12:33:37 +0000
Message-ID: <4a97a426-9793-f5ea-6c9f-63178e117eab@oracle.com>
Date:   Thu, 5 Oct 2023 13:33:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 3/7] scsi: Use scsi_target as argument for
 eh_target_reset_handler()
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20231002155915.109359-1-hare@suse.de>
 <20231002155915.109359-4-hare@suse.de>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20231002155915.109359-4-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0065.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::29) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4168:EE_
X-MS-Office365-Filtering-Correlation-Id: 215ddb81-b0de-4780-3dc6-08dbc59f4c10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QBCeEFstu/DUhVd3PRldR7VfoRzQADMYunya6N/ju958eLZDtgWYOct6bC4h1Nvhl1H9CD5u3aYUY9RM7GeJMjtXUC6JJ/8xpe1NpGNqV74m4S+jErFETK+70jxspBeRLDJpwTKMxj7pk/ut7yM4d1HKZ1hpF+ICLv1xr4Xk1m2bOcvUtEDsS1zhgKKWfiTaoIcyJeB82teqg41xtY3pCO9yVjOnjw7eTNZuVEDs58/Hr+9dz42CSmvU/cvSpWOlJZyCo4rbNLpDdlCxWPu/qWY7oa0FOhBGR6Kv/bwtsMxTXeIKc0wvIT9heK2+QroFjHflzECs8bExH8xrHL6O1Botye5aj/ZD6nEr03ceggKTtdOFc1zcErFYk7QOkdiMSi0H6aJMT9m9oTg3Ghu/ApKqKJhmWroLCVeQqfc6f3paiEsvlxPnpiLqTuoUDj6Hd0hvLKucY/NsjE9lL+If8C//B+gw/qCbGeT+O0fyV4xlNyN27uPC4L3f2cK85yy1s37HHg/2w4vCIZHLMZVuH8oLXUW3uEoPQMz5wJ8VvLc8mIhsN0lHb/nIWeADPfSfATfhrbkmu5vzK2+b1KiSW9+okN6pDZSahZrN3e3ZesgjcSe+qImkyFwZS0xELM5XJixHRUr+Lbp0T4Mx9dtBBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(396003)(136003)(376002)(39860400002)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(6512007)(6506007)(36916002)(6486002)(26005)(2616005)(4326008)(5660300002)(8676002)(8936002)(31696002)(86362001)(2906002)(36756003)(316002)(54906003)(41300700001)(6636002)(66476007)(66556008)(66946007)(110136005)(38100700002)(6666004)(478600001)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1VsZEI5Wnk1VXB1Qy9FdHljUU9NTkNtaHpqeks0VW8zWDdZN1RUcXB6R2hI?=
 =?utf-8?B?WkxZeGNRTUhCR0VjZDJtYldGVWk1V01mQkpNVWNQL3JUQmJaTXRpeFVBT3ph?=
 =?utf-8?B?RWRFb1BDVEdjQjVJdy84Y0F3clZUczR5Y2diUEFYTXJNMTc4MmtUQzdtZ3BJ?=
 =?utf-8?B?VDV3NEVPWTM4Ym1oWFY0UGZVdnFyU08zRnZNVnNraHNKbXRSa0Q0N3ZKdHpo?=
 =?utf-8?B?MVp4d2ZGYlltdTcrTUJLRXZsbGxoM2ZSTk5DMkIvZUFhbEFTaklnT09WVGVw?=
 =?utf-8?B?YWRvbVJQQmtFN3BnSHluVzNrN2RveG95aDFNeVJjSUQzYUMwdFE3UjZNenly?=
 =?utf-8?B?czVWUzJLd3JMWmwyQUdXNjg0NXRkd2haanJxeFh4UG5DcWFXcURJQTFUNHRs?=
 =?utf-8?B?QW14cGtRR04zdTBNK0NvNFRINjdjays1RDRjc2gwYW5VcnlBVllEZ284Z2Nl?=
 =?utf-8?B?c1lscXRFU1U2UVFva2VEZE9BU1AwRjRJMzhpcXlGcm9ydUtWSjBlMUZKMUxX?=
 =?utf-8?B?OHpTSXVnZ1hjTk1DRXpIMGRhU05CWk53QXRWaHNMVkhreHQ0SWs4Mzlldytu?=
 =?utf-8?B?OXJoRTlHRjRVMmNPMllwUFI2NFY0ZFdkbXlRUEJ0UFQ1QUN6cWRCT0F1Yjhv?=
 =?utf-8?B?UzNPVmlWakRxVHZBeWhTNTA3TXJUcWJNVDZSckpHWktjMVZqcUFhR2t4UGsr?=
 =?utf-8?B?U0pONHFhbW9TM0VHMnYvQ1VPWU4yRjJpV2lub29vcjNVMVV4cTB2RGZhMm9O?=
 =?utf-8?B?Q25EN3FtMDZBcEhJaTMzRFp4T2NIcVNzQWoxWSszMFBCSnRoZG9aT01QTTg1?=
 =?utf-8?B?SENzcmovRXoydkJ2dlJOT1QwVS9VdnBSb05QaEFhTUxYdWpGV3NXL1NLajFv?=
 =?utf-8?B?TS9aeXAyOEcrK3ovajNsaWk4YlROWjJib1NFV3JNWU01OURUbXVxOXpOaVR2?=
 =?utf-8?B?VklXeHRvT3BlSHhSQVhBN2MvaDZzTGJ0L2FQa0daK3l6OFhjaThScW1RLy8z?=
 =?utf-8?B?ODJjaDhBQ3dEa1ErcUpINUlnaGU1MjJReGJjVzBKTDdmZmZmRmhhcW0xUzhR?=
 =?utf-8?B?TnVZSU1TVWY2MXFKeXZhaTZPc3l0VmpvdnhTbnpmZXNCZFB4b3ptZkpYeDZt?=
 =?utf-8?B?TTg1dVkxOU9BcytyeTljeGk3NGFGcXN3aFFaeDZlbFNHSkluZGY2bklyMFlt?=
 =?utf-8?B?WTJHd0Z4YnMvRFB0ZjYwdTJjTTdPK3JzbEt0dGowMTFYaHB1VU45amlhd1Jk?=
 =?utf-8?B?cmMxM2YwN2J1Yk03aHZDSndxTUtVV1YxVTVCYkxCM2hvL0MzdjBKV0h0WDZo?=
 =?utf-8?B?K0JGTVhwc0VlSlhBWUZVaVRiVWlaNEJ5QlhLcXhqcHFYZWFRNDRPbTJaS0VQ?=
 =?utf-8?B?cDdNQ0hMZS90V0hMQmJqYVd6aUsxU2NIbjJFNkttelZ0QUE5SzlURWR3UFZj?=
 =?utf-8?B?V21HT2Q1U2h4eUtFTGpIUkM3akdsTEFsbDVwQnRtOE1LaHEzZncwdCs0WFJo?=
 =?utf-8?B?SlI5UVFJbjYzQjNRNjJ1Z0tkNmFUdklwY0xneHlwZ0dYSUxQeUJCeHJPTFlV?=
 =?utf-8?B?dXZHVnRRYW5Ea0VIdGE5OVk4cFF1cEhHdzJHenE0dGpOcitFRC85NTc0Qi85?=
 =?utf-8?B?ZWd4UzhsYUFJcU8wdTNJOGUrVXZWRXJjUCsrN1lsaThPMlRqckZQTU9sRjBm?=
 =?utf-8?B?VUNqbk83SnI1eE1oVW1rNjdSdklLb2gzUUI4aFJYQlVwWEtvNm1yWG5Va1Iy?=
 =?utf-8?B?S3ZvMUloaHB0SktJR1N0bFhCNWZzb3RJMDBVaDRJWGdIRkRSbEx4d29TMjl4?=
 =?utf-8?B?OURrNGhocFZaQXVhZHVPbUJlbWRCV3g3TDZQNy9WWVhxemNtcXFiQVhZTWFt?=
 =?utf-8?B?RUM2ZjlHVHZTTloxYkxQMndiT0k2cEdKeElWamY1WXlQam1MNlNmMDlJQ3lS?=
 =?utf-8?B?LzJzaGlYL0N6Z1IzYU1mQmN5QkN4UXhuYUVCanpDcGhwaDl2b0xzZXRPelRE?=
 =?utf-8?B?SUhBTG5xQmZOTGZpYW9yNmpTeHFoTXB1MjlPei9INUpEeEZYUHBJb2NDYVZR?=
 =?utf-8?B?ai9SUFA5NlVsb0o3MmtkYnowSjFnMm5rbEJFYmRsMUJQaXNhWXY1QVBzcnBH?=
 =?utf-8?Q?XWriFhwvEc0ARSy/kLVVy3RTn?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Q80qbSrMBASxo9eKAtCJuVFeTJyjRbnyl1QxSLZLOdhCoJ3QDeLmOV2OcilM28pPfM/RzywCDyq47/I4AJcDfI5nY/FgG2szVKIux0Kt65tl+qu1iAnEx36zmO+q+ZQ4Y0iU5NlhY3KEoKMl7MnK6Hv5tD2y0dmyNFIE4kBIfKNYW/gqXdGJeQ+U0Nath+bjFBxLCnuXQ0oJ3HO64rJETCLmedWvG1UWf6yt2W5STdpmiouVF9lbY9Tg2/uoE9O2z1pOiIsY1q8eAdSe9SfddmmV1mbmUpOYZ0q/OQfTwiIOhRNb3XBl2x8pdvcAS0XbgJwVQUMt7zgL9wd2nUzIM9lKMYx4L8lH7Q8YpOhl6HNV8uFoKFREypOT9QvrwAhqGw7mPden4fZSWWdllO5XUxy7lp7t25/IvpjMkVfc2ZAygvywtG42Eywf3jy6hA2uuzWNLl6Vne5joa/4JnqPhDCKZZE6IsAEy3c/6WuoTWQ8VbDCuIstpYjBcwJP6JkblaH4ogPdt18pu1wq/GeWVzImlwZZnMXD/6icguXyokA7TSpeji35mSP533xUX8ZNiqB8Ff8PwxsrMjpP7ETHDklopPV/uqIcO58TuZiF9YOcZRhWwZrH04036hcXvzzs816Hd7nA3WgYL3HweFrOqBhLnbQQiQPRX5DOMv5dBRZgN5doNO6Q69fZO5sseHfhrddk2epNKGSv5ylC5PCGSTb2YGd8o9eB9677nP/F8155LjHcaUKqnbhOtLGQeuUWdeTVqT/k2JrXyXvsrvs90dYXH7w3PhrjK/4FTD3OmxBkkADRzz5H4nlFe3NjBKSPTo2bRnWz3ZNOImO9UExohwNbAB5ERPhOU3FMiR43lvI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 215ddb81-b0de-4780-3dc6-08dbc59f4c10
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2023 12:33:37.1613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P4rgK6zypvdMRYH5XnSCa2XUltTSphuvb1o6wgqSvaZxxpi38apy4sSzaMsPOASe4m1dFrVDLA2IQ1tYXFrjHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4168
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-05_08,2023-10-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310050098
X-Proofpoint-ORIG-GUID: pBi_xaSeTK-EZ3aemzYavqdevBo2fH7G
X-Proofpoint-GUID: pBi_xaSeTK-EZ3aemzYavqdevBo2fH7G
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>       /**
>       *      eh_device_reset_handler - issue SCSI device reset
>       *      @scp: identifies SCSI device to be reset
> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
> index 86f16f3ea478..61a060dc7a17 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -1997,7 +1997,15 @@ static enum scsi_timeout_action mptsas_eh_timed_out(struct scsi_cmnd *sc)
>   }
>   
>   
> -static const struct scsi_host_template mptsas_driver_template = {
> +static int mptsas_eh_target_reset(struct scsi_target *starget)
> +{
> +	struct sas_rphy *rphy = dev_to_rphy(starget->dev.parent);
> +	MPT_ADAPTER *ioc = rphy_to_ioc(rphy);
> +
> +	return mptscsih_target_reset(ioc->sh, starget);
> +}
> +
> +static struct scsi_host_template mptsas_driver_template = {

was dropping the const intentional?

>   	.module				= THIS_MODULE,
>   	.proc_name			= "mptsas",
>   	.show_info			= mptscsih_show_info,
> @@ -2012,7 +2020,7 @@ static const struct scsi_host_template mptsas_driver_template = {
>   	.change_queue_depth 		= mptscsih_change_queue_depth,
>   	.eh_timed_out			= mptsas_eh_timed_out,
>   	.eh_abort_handler		= mptscsih_abort,
> -	.eh_device_reset_handler	= mptscsih_dev_reset,
> +	.eh_target_reset_handler	= mptsas_eh_target_reset,
>   	.eh_host_reset_handler		= mptscsih_host_reset,
>   	.bios_param			= mptscsih_bios_param,
>   	.can_queue			= MPT_SAS_CAN_QUEUE,
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> index 591b2858f823..b31d74ea9cc8 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -1853,48 +1853,43 @@ mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
>    *	Returns SUCCESS or FAILED.
>    **/
>   int
> -mptscsih_target_reset(struct scsi_cmnd * SCpnt)
> +mptscsih_target_reset(struct Scsi_Host *shost, struct scsi_target * starget)
>   {
>   	MPT_SCSI_HOST	*hd;
>   	int		 retval;
> -	VirtDevice	 *vdevice;
> +	VirtTarget	 *vtarget;
>   	MPT_ADAPTER	*ioc;
>   
>   	/* If we can't locate our host adapter structure, return FAILED status.
>   	 */
> -	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
> -		printk(KERN_ERR MYNAM ": target reset: "
> -		   "Can't locate host! (sc=%p)\n", SCpnt);
> +	if ((hd = shost_priv(shost)) == NULL){

Is shost_priv(shost) == NULL even possible?

Doesn't shost_priv() just return the address to the driver shost priv 
data, which is at a fixed offset to shost pointer

...

>   }
>   
> -static const struct scsi_host_template mptspi_driver_template = {
> +static int mptspi_eh_target_reset(struct scsi_target *starget)
> +{
> +	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
> +	return mptscsih_target_reset(shost, starget);
> +}
> +
> +static struct scsi_host_template mptspi_driver_template = {
>   	.module				= THIS_MODULE,
>   	.proc_name			= "mptspi",
>   	.show_info			= mptscsih_show_info,
> @@ -834,7 +840,7 @@ static const struct scsi_host_template mptspi_driver_template = {
>   	.slave_destroy			= mptspi_slave_destroy,
>   	.change_queue_depth 		= mptscsih_change_queue_depth,
>   	.eh_abort_handler		= mptscsih_abort,
> -	.eh_device_reset_handler	= mptscsih_dev_reset,
> +	.eh_target_reset_handler	= mptspi_eh_target_reset,
>   	.eh_bus_reset_handler		= mptscsih_bus_reset,
>   	.eh_host_reset_handler		= mptscsih_host_reset,
>   	.bios_param			= mptscsih_bios_param,
> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index 60ef1e2ab3cd..6bd07f704391 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -340,9 +340,12 @@ static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
>   	return zfcp_scsi_task_mgmt_function(sdev, FCP_TMF_LUN_RESET);
>   }

...

>   
> -int sas_eh_target_reset_handler(struct scsi_cmnd *cmd)
> +int sas_eh_target_reset_handler(struct scsi_target *starget)
>   {
>   	int res;
> -	struct Scsi_Host *host = cmd->device->host;
> -	struct domain_device *dev = cmd_to_domain_dev(cmd);
> +	struct domain_device *dev = starget_to_domain_dev(starget);
> +	struct sas_rphy *rphy = dev->rphy;
> +	struct Scsi_Host *host = dev_to_shost(rphy->dev.parent);
>   	struct sas_internal *i = to_sas_internal(host->transportt);
>   
>   	if (current != host->ehandler)
> @@ -515,7 +516,7 @@ static int try_to_reset_cmd_device(struct scsi_cmnd *cmd)
>   
>   try_target_reset:
>   	if (shost->hostt->eh_target_reset_handler)
> -		return shost->hostt->eh_target_reset_handler(cmd);
> +		return shost->hostt->eh_target_reset_handler(scsi_target(cmd->device));

this line looks too long

>   
>   	return FAILED;
>   }

...

>   
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 8a83f3fc2b86..0ad6be041298 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -4801,21 +4801,25 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
>   
>   /*
>    * megasas_reset_target_fusion : target reset function for fusion adapters
> - * scmd: SCSI command pointer
> + * shost: SCSI host pointer
> + * starget: SCSI target pointer
>    *
>    * Returns SUCCESS if all commands associated with target aborted else FAILED
>    */
>   
> -int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
> +int megasas_reset_target_fusion(struct Scsi_Host *shost,
> +				struct scsi_target *starget)
>   {
>   
>   	struct megasas_instance *instance;
> +	struct scsi_device *sdev;
>   	int ret = FAILED;
> -	u16 devhandle;
> -	struct MR_PRIV_DEVICE *mr_device_priv_data;
> -	mr_device_priv_data = scmd->device->hostdata;
> +	u16 devhandle = USHRT_MAX;
> +	struct MR_PRIV_DEVICE *mr_device_priv_data = NULL;
>   
> -	instance = (struct megasas_instance *)scmd->device->host->hostdata;
> +	instance = (struct megasas_instance *)shost->hostdata;
> +	starget_printk(KERN_INFO, starget,
> +		    "target reset called\n");
>   
>   	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) {
>   		dev_err(&instance->pdev->dev, "Controller is not OPERATIONAL,"
> @@ -4824,10 +4828,21 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
>   		return ret;
>   	}
>   
> +	shost_for_each_device(sdev, shost) {
> +		if (!sdev->hostdata)
> +			continue;
> +		if (sdev->sdev_target != starget)
> +			continue;
> +		mr_device_priv_data = sdev->hostdata;
> +		if (mr_device_priv_data->is_tm_capable) {
> +			devhandle = megasas_get_tm_devhandle(sdev);
> +			break;
> +		}
> +	}

Do you require scsi_device_put(sdev)?

> +
>   	if (!mr_device_priv_data) {
> -		sdev_printk(KERN_INFO, scmd->device,
> -			    "device been deleted! scmd: (0x%p)\n", scmd);
> -		scmd->result = DID_NO_CONNECT << 16;
> +		starget_printk(KERN_INFO, starget,
> +			    "all devices have been deleted\n");
>   		ret = SUCCESS;
>   		goto out;

...

>   
> -	stgt_priv_data = sdev_priv_data->tgt_priv_data;
> +	stgt_priv_data = (struct mpi3mr_stgt_priv_data *)
> +		starget->hostdata;

starget->hostdata is a void *, so no need for casting
...
>   

> -static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
> +static int pmcraid_eh_target_reset_handler(struct scsi_target *starget)
>   {
> -	struct Scsi_Host *shost = scmd->device->host;
> +	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
>   	struct scsi_device *scsi_dev = NULL, *tmp;
>   
>   	shost_for_each_device(tmp, shost) {
> -		if ((tmp->channel == scmd->device->channel) &&
> -		    (tmp->id == scmd->device->id)) {
> +		if ((tmp->channel == starget->channel) &&
> +		    (tmp->id == starget->id)) {
>   			scsi_dev = tmp;
>   			break;
>   		}
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> index 413a5a0da433..f6876307c304 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -856,9 +856,8 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
>   	return rc;
>   }
>   
> -static int qedf_eh_target_reset(struct scsi_cmnd *sc_cmd)
> +static int qedf_eh_target_reset(struct scsi_target *starget)
>   {
> -	struct scsi_target *starget = scsi_target(sc_cmd->device);
>   	struct fc_rport *rport = starget_to_rport(starget);
>   
>   	QEDF_ERR(NULL, "TARGET RESET Issued...");
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index a9d9d0a9abd7..53bb73e07c3a 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1514,10 +1514,9 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
>   }
>   
>   static int
> -qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
> +qla2xxx_eh_target_reset(struct scsi_target *starget)
>   {
> -	struct scsi_device *sdev = cmd->device;
> -	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
> +	struct fc_rport *rport = starget_to_rport(starget);
>   	scsi_qla_host_t *vha = shost_priv(rport_to_shost(rport));
>   	struct qla_hw_data *ha = vha->hw;
>   	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
> @@ -1542,40 +1541,39 @@ qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
>   		return FAILED;
>   
>   	ql_log(ql_log_info, vha, 0x8009,
> -	    "TARGET RESET ISSUED nexus=%ld:%d cmd=%p.\n", vha->host_no,
> -	    sdev->id, cmd);
> +	    "TARGET RESET ISSUED nexus=%ld:%d.\n", vha->host_no,
> +	    starget->id);
>   
>   	err = 0;
>   	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
>   		ql_log(ql_log_warn, vha, 0x800a,
> -		    "Wait for hba online failed for cmd=%p.\n", cmd);
> +		    "Wait for hba online failed.\n");

sidenote: maybe the maintainer for this driver would like a different 
log message, but they are not even cc'ed

...


