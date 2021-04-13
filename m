Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB38C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11E28613AB
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344317AbhDMFtJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 01:49:09 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56954 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344733AbhDMFsx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 01:48:53 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5juII010088;
        Tue, 13 Apr 2021 05:48:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=KRycY4PBSLj8E81Yem7axmeXejE+u8wfp6H+6x/OiC0=;
 b=QPtGX6zFXz42b/Z0I7zGRB670o8icKshQDl0slFw8d93ZxWcwTgfzGszR+trlHB8F95O
 CzaNV8p34SfY+8mYPLR5e/iIBj2SZ+AwalsAycI7lhQNIFYX9qfTO7jyG7I6DHqQTGTC
 C6q0RqV9QWz2DcDRUB/Yucn54SuD2TpC3DuETxh751vjKVTMPbTFZCZKqdvLgaQylEon
 PmY1subjqrTdEnOzxWQgSdTAEW8SxehHqnBqJp2m1abrIVgz37ilW5KD+0cVQLH38J8I
 QN0IwLX3W5DU/VjQ2msexAUaXvTGzdenZTHnqbKEvlGTowX0e+RtLYA7VVwBlsOA8HBS Tg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37u1hbdxh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5kRN9137234;
        Tue, 13 Apr 2021 05:48:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by aserp3030.oracle.com with ESMTP id 37unkp3mdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0nESmRknDvawMiNlegTWiUls6lkQTen4v9GJ0nn8bJNpQthv9Uq/MDp3shs4hUh0hFZIA4qLVyA+812g6LXohiBTIs/fTXeZ58FcEiK4dYGiqJQnakxtLZpjyi1ggCeIGq71iaw7LEMScKr10fVZObcHd3EfZh1my20StY2I6c/5xOaO74rHuDfj8tPYj9NVJd1BaPhWbPoXz+cpsU3lHvJffEEIpfWuDklf3vaRAA3ZY64ZDGugRhUkazsIHyV5KuO11lHYaSsQPzMiSgXJYbekUgGM+y0uC362ldSR5CNNR20JzZWNU2USX8KeQljXPbR01oo8DuH09WiPcdHSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KRycY4PBSLj8E81Yem7axmeXejE+u8wfp6H+6x/OiC0=;
 b=YgLn36FtGSRNb9qsSHAAyrP7uVOmO0On16Eo0iRhkfkh6zNUyyjVWZrkmjlt3CUMLPZmM/3FbGhkqk3T9VWzblqoUw4aqR+Q0Cj9MyFFCK+o0+TQIwUALAQ2/n6z8hTMruYd0fDmHJSNXG/vEh0FLzRom4D6zfRZDEsmsNxzai13TIDg9AUeIKyxQyy2gv7zYyizolhdx77DNx7yu7fFc/uwP0AdoTGzP5X497BKu8mIokyphKUcqWkv8+cXv+Cnc6IydXOz9qOYfh2k+x/mBFmx+UkRyXKGO0dWq03FsiC3Ag0/s476K6OylU5+vGYmhQp7nwaMWDlQPXeCc7mq7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KRycY4PBSLj8E81Yem7axmeXejE+u8wfp6H+6x/OiC0=;
 b=D6q6VDbA3lFWapAuIDOIM0BK01K+cFBWp8kwg8t0pxtxYDY0LiqxO4brXaIl7SmqX2+vYpoXVs6w29PQJa3b/awzZ31jqW3pWS+uX5ynPTljYzkb4rVb8uelzGixx3Bs4l7J5Kak3GRgX/T4qRfSNlP5agpFxqqUh50bSIXcRKY=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 05:48:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 05:48:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com
Subject: Re: [PATCH] mpt3sas: Fix ActiveCablePowerRequirement's endianness
Date:   Tue, 13 Apr 2021 01:48:16 -0400
Message-Id: <161828336217.27813.3680747478383510817.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330105106.20569-1-sreekanth.reddy@broadcom.com>
References: <20210330105106.20569-1-sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: BY5PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR03CA0008.namprd03.prod.outlook.com (2603:10b6:a03:1e0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 13 Apr 2021 05:48:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7edf137d-de5b-44c6-fbf4-08d8fe3fc4c5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4614:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4614AFCCB7E59A80DCA4568E8E4F9@PH0PR10MB4614.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tFy5GtX3CFbRM59029DafYJJGNarvue72oDhXqhdEnWcw5xCvSkxNLTHTo1WGoXILeDXlzlkOHMvRLBTmzvEf4GN5AklXbU1DQUBonEmVH90nHnd4XcRx8dtLYm1+8uADjDezmzvqHWU8Ra5WFXwKvzGm3+otNvlqPEUCEVaqVU3QTy8OGrHBUORjkacDmOCljIBXpUBUuIpi9ib1t1xG41gO6bR13cb38Ql8jD3i8qFEP8Uu7139DbWFMVzwEivA2RK+TAjjIkFlu5Tg0CWZT+9dfu+HW5OvKRssT+CBOzM85Ug9zJpsULDmgeUX4rfQoTx5tYiaZ61w7Xwpmr09/2yMND+QxWKktH1N1zOJwFmRoAE1ybz56r0gDliev804Qd0Igltv4KzVZL55pAYJyocCGDk/8Ejf9uEOiKLQ8mWDSaZuKmTtWgkiv5ipTGjqhsg7RAHNGpDSUV1Qo3PTs8sQMDoHQIs2H03QJUTOPjhfUgfmJ3KqN5AYZEpzdI/VQqov9b72w/o7jSFLXq6dhlN4vlWnT09kUS+KEbvFhsd1u1X77camUBF5kSsJcXQsz1VxB8V3AIjuV6jZtxDiO0v8wNoPLn10Pg3hhE9DQjb4JPEokjrbD6mBdSemcDhvi9dlWI1VbRVf1h0xtSWpz0xlOs9c+PC4FyiuBJOpLupmFw4QNDulHD8+wi66kClKM6aTOQGreXXSWrtGTB1XhLM7nzhnCImTBhtCVxTXEPBYHaTnFi8Loy/o6x1Ehvt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(396003)(39860400002)(966005)(2906002)(6916009)(4744005)(6486002)(4326008)(316002)(478600001)(66946007)(8936002)(38350700002)(66476007)(16526019)(38100700002)(186003)(5660300002)(6666004)(66556008)(26005)(7696005)(956004)(36756003)(86362001)(52116002)(2616005)(103116003)(8676002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b3JrQWRoVWNYOU1uQ1o3Zmp4NzlLem4zMHpBc1BKY0VvaExqQUczaFZzRFBy?=
 =?utf-8?B?YzdKQ2hXZG9paXJyeEtPZXRmS0R2azc3ZVdheW9pVkJLbWY2bWZWbzZoUUx3?=
 =?utf-8?B?MGl6cld3VjlqbGJWSmhlWmI0cGhKWXltWDBYVHE4OFo4L2YrbnJVWkhXN1gx?=
 =?utf-8?B?UlJTUE03K1FzVG9tbmZTc2JVN1E3VTV4ZFkvQlYzeHFOL2xnRVlReElubXlm?=
 =?utf-8?B?TExvclRGb3Z0emU0bUNuZGFXajV1VHV1WFltTnRmdnNNRGRLTlFFdFNBRnQz?=
 =?utf-8?B?cFhxQTFPdDM1ZU8zUmp1a0ZXQ2txMnpHblg0QXpKTGRGaVFoQzZxWGF3UURv?=
 =?utf-8?B?cHZuVkNxWUVSR3dMUjFHTFN2cjFvcTZwSC9jcDdEQll4MnVRcHowQmRTdzk1?=
 =?utf-8?B?c2tjTHJhOVh6ZUNaUGxMWVFTQkVpM092MnBKN0JoQlptdG5iWGw4TnJCbTlI?=
 =?utf-8?B?VGJURURERlp3UXVveG5mc1AzTW1JRUdwU0RmWEg4SUtlak1CeDRxRVdGRitI?=
 =?utf-8?B?bzA4MFFRKzlkZ3hJN2JGRVoyZFR1MEFlOS9Fak9UVkNVblBQT3RyTUZPbHZj?=
 =?utf-8?B?Mk1DRFp3bXFxZ3Z4ZHRqU2JCM1orUFRrK3BoUjlNTVNTcHFwb0xTSExwK29s?=
 =?utf-8?B?dWpkK2hNZ1QzQkVvMVBqN2dvYnhoSHY0L1NXZzhwQmdESVNoREw4U2lma1Rr?=
 =?utf-8?B?NmJIZ01sMkNuZzhYSGlKS0FGbHFaVFNMdjVYZ3p3cXh4TDJBbmRPTTBKK0Jj?=
 =?utf-8?B?dGVBUk1JWmNKcG5kTHJhQTZqUmdHdjZSR0FacjBtM0lUU3k2MDlwRmxhd0xw?=
 =?utf-8?B?YW9WMmJCNDE0alJGS3U4OXZtaE9ndVJHeUViZzR0UmtZL1d4UFZwblIreFZ3?=
 =?utf-8?B?TjhHYWc2MW1YdUR3QlV6S25JWnFRb2l3M0FsaFFrcWxwaUxTeXF5WWRoNXlT?=
 =?utf-8?B?Wjd1VEd6WTEwd2hVM1pWZ2JnSGUwTVNWbmxQRTVIU1JmYzlwT0E4UHVIU2Q4?=
 =?utf-8?B?a3phM2pnN3UvMkoxWXpadEtMK1owL2FGRG5uaVlCSUJQNmdISGNYQnhpUS8w?=
 =?utf-8?B?bmVCVDJoZWZMZTFOeHZzWUZhRVdSdFAyUnhtYkRWbG55V1RhU2gvQUgrSE9J?=
 =?utf-8?B?NUNRZ2ZLU0xMRWFPWWdRV0dISnEwbE91ZlNzblBTanpDNDB2TzhmcGErWlNw?=
 =?utf-8?B?UUpUQzlWd2tUTDhlY2x2c3V6N2Y2V3pOc2ZGRjlWS0pOSWVNY0xXSTdoQkRa?=
 =?utf-8?B?VytoUlk5UUdScTQ2bitobHNjZFVNR2V0eTZBYW5pWFBWRDV6RUxsMXp1WFAr?=
 =?utf-8?B?RVZQNnVSYWhsZTZ0TkRva2UyOEE3d2VqWmVpK3hrWTBkMXJURW8zYlBIdHV2?=
 =?utf-8?B?RFFsdU9hM3dNQm5LNUZhcEgycEUvVjZSSXV3L1lnbXorL0J5RXFrcUZYRWY2?=
 =?utf-8?B?azJSd1FKNlhuSS9nRmUrRXpjMzJESlVPVlRFalplWU1zSXkzcmczNG1TOWMw?=
 =?utf-8?B?MGNrZVRtd0RybjI3N1hQNS9QaDhFR3E0MFhsbW42ZGJhK3Q2RlB3U2psMWo3?=
 =?utf-8?B?MFdmVzZZenlDcTNlSVlnV3p1UFVQMVZzOVlaUlc5TmZOblZydWIvZlNDV2Rq?=
 =?utf-8?B?TWdTWks5Qk0xSllVYm5XQVlod3F2OUszWG4wMGFGNmtYb3FpY015b1Zqb0Vu?=
 =?utf-8?B?SmhNOS8xUTNma2xMUHY4N1dwODhUVWFBTk94R0pKK3JacWFXbmw4LzlhWVlD?=
 =?utf-8?Q?E5sbp17RKj0ajlg5muMAlmMxLTLg+CA6bjbgXbL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7edf137d-de5b-44c6-fbf4-08d8fe3fc4c5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 05:48:31.2491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BnceG0AHCaL2gAK2OV0SBfMTE7vh1uyAKNTCOXSq578FXf6T4Fs5T/2ZegnQdmGUQ/WpkBzCrXWPeju3wI279I9XfuKXZAzLy8w5dNIQZFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=972
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130039
X-Proofpoint-GUID: T3iv4fTzOFd3W1riTDoMvHbvOC4Ue4p7
X-Proofpoint-ORIG-GUID: T3iv4fTzOFd3W1riTDoMvHbvOC4Ue4p7
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130039
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 30 Mar 2021 16:21:06 +0530, Sreekanth Reddy wrote:

> Covert ActiveCablePowerRequirement's value to target CPU endian
> before displaying it.

Applied to 5.13/scsi-queue, thanks!

[1/1] mpt3sas: Fix ActiveCablePowerRequirement's endianness
      https://git.kernel.org/mkp/scsi/c/c0629d70ca55

-- 
Martin K. Petersen	Oracle Linux Engineering
