Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC559C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5719613D3
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244128AbhI2EWd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 00:22:33 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:31510 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243938AbhI2EWV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 00:22:21 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T2ECav013612;
        Wed, 29 Sep 2021 04:20:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+aJCJ2gRwnwIvTJnORKQsQ7DJiLVqsHFLpQ8ncXm9eA=;
 b=qNMNcbF2C0TrNwm68JNs9AUKQO7ARJeStKK5WxDPRf/2ZnE+P4m4pgg4KvLOPRi+N4LO
 sJxKoVan+fiaKcMP0rQ3Id8zplu4LyjTv1GOAFNUBvVbqFuZsf1oEoWqZaPX6dT4FTbk
 dvuhMCsEGfsyWj7JEQN74UbrPLXCYaFmEhKZZbAc7KSx3b2huibwFpXF0mYucvhkbH+r
 kIA6pJFiBg0X51gxF0sgrDuKZIvjUI0IbwUXyWGZVCiYHfUX6lJf9i8kH1jVYYiCZNI3
 f5Z++Qj8B3Ane1flQBu/QmSNkwCV+bFHjVmVSbm/i0DWsCSO0n/TgMLvnBH/wjWqgSDS cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcf6crd72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:20:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T4AUV7030883;
        Wed, 29 Sep 2021 04:20:21 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by userp3030.oracle.com with ESMTP id 3bc3bjb7h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:20:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q9oqbLOoxq5dVczbVFPtq9Nb0h4pW14Ys+7vxrTQedMeNen27lvFzK0pE/CQXXAVsD+XPlCtzwENdxpHkLHZTQlabZq7ZeASN88mn8590x3EZP9oxDInwc4m8mvI6n5XBsmutAN3Zv1/D7d6egHRst+ojfa8q96HDibub7BYBdzZ6+yNxhFQ9YWdoHldNY1IERYWneFIZkbk69PhTDo1qgoWTL6szhim5nUP2kysoZFB4/gAUXGUTMG+xQH9szvvMgpViynoXNd/Mah4pt3c/arL9tDlSvyaPQu4uoIx0gq1d2DfRtFRtpg6LOeMnKrReuCK1OVerOqB8h7qrddTBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+aJCJ2gRwnwIvTJnORKQsQ7DJiLVqsHFLpQ8ncXm9eA=;
 b=YhcAKXbXgfa6doPHJCHAGELDHd58Bnw2ImJKlBa0qQQKjJqhRUo7pXsAyAFyNQHjCJMGIuPj6JzW9JTEnhJJpmzorVqwaNz18dw2JbmNt43YAMUNzb1zuCqJMzXbGIIjyjkkkfJdDhM9MHbHprVKszIdSR6EeTNUmX38Yc+J01LjPaLLRUDGbHtD9qxFDuCfzxkevAoeQOm9ujSQDMYW1o3bJrClcNM5Nv8lE0Kvlf4p0rDlRKKMnsSrVpbRzMln+TalXYsXjzLWVOcQ+ZUek/P/0cGAerj5tY2KEKbSficbHVCCm85AZiOkuzEEI+NCcdlWsHoHdJNbOgV7b+JewQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+aJCJ2gRwnwIvTJnORKQsQ7DJiLVqsHFLpQ8ncXm9eA=;
 b=XOla08+onD7l1ARNh4UYM9qGgT98VxzXRyt/iPHSveEw7mk2e1J2aj8clqvmUfOhHj9t/l4aKrOF5hvxAbpV8gkUh8vl8hzI50j1ZLTFZ73KMrCPIsofhEOT604coKMp+qOOpEYYl6Os5W6WhzI2IaS9Ar15IWrWtcTLCguP804=
Authentication-Results: linux.vnet.ibm.com; dkim=none (message not signed)
 header.d=none;linux.vnet.ibm.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4551.namprd10.prod.outlook.com (2603:10b6:510:38::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 04:20:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 04:20:18 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Avri Altman <avri.altman@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v7 0/2] Add temperature notification support
Date:   Wed, 29 Sep 2021 00:20:12 -0400
Message-Id: <163288294652.9370.14887543862077752154.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210915060407.40-1-avri.altman@wdc.com>
References: <20210915060407.40-1-avri.altman@wdc.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN1PR12CA0056.namprd12.prod.outlook.com
 (2603:10b6:802:20::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN1PR12CA0056.namprd12.prod.outlook.com (2603:10b6:802:20::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 04:20:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f71d1a19-0006-4350-7133-08d983007219
X-MS-TrafficTypeDiagnostic: PH0PR10MB4551:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45512762E7989BC71BC81A038EA99@PH0PR10MB4551.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D6mBRrcM1MKbnsd3iOBzACc8Mmm36iuMaKmBCNXY9Cn7YLte2cAsX+V7XsaHCyuDMTzJ68ouGhaDjReNmUtYuOT6h4WhEQzPx7Vb0ocqrzuDYVPT3Q4NJ+oJ0IMPjk0Ni3QL5p0kV+lkGJCxUlDlT91FQi8fqmT5AAvD42lGQ4ktlGVqcJf/xPPCgZ6ocfAPSwcb93QpunSRhX+kzHkdFa+KhnC8eTTbrDvRrsYryk56CZlIShVP7Vl/i90a8wFhC9Rrvnyhg8g7TTaSdewxpeLYbB2HagMwpjL1TwfIVTn16qmGo196Pezk6Ig9W9f3xmaij3fW6uFDE9cmELlZG0SHhBrWXGp1pHArq7/AehqXYPNih8WnYg0SAd6ZGup5opq6EFRbnttaNI8Dw+4ItROdke9TF/nHG+wEk2MIYGp74h3dEEToLgCIFHqF15a0HFve+09GT4a8dTkaYMiOlR6Q+s1J9SEjqjG4WtJPiJ1vxBrRsJTW9ZSPOV62XeDm1GvTGTvAGSZzguwm3qju3DJCKCb1hwPC/g419q0psV0y/NrpzwCo/n13dyjJVBO223l8589to8Yr+6w0Kz+a1E4pZJpDWIiM90hJB1Xhr2dyXSJPYbu3qFBkfe6ff2fyLRBh+RZ3pIPQ6naAAqRqNwxhLtGz27tdJHFk9OCETi9j3HmNnySZRIPRfcjmCJko+Uy544u3iLerIB0OUb/j4VO8ypw0YnSYXxReUBfg02j4EXLclXc00PBZXznL1KJCZ1xJ8R0HBA+EqBsNNBdPaIIBU8Hx5AwqHqiLg1kQ2j2DozD0nmfpR2avB1mlv3KOcvc1SAXJMkNBZAciHwNGsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(4744005)(966005)(6486002)(110136005)(36756003)(103116003)(956004)(316002)(5660300002)(8936002)(38350700002)(38100700002)(2906002)(26005)(508600001)(54906003)(66556008)(66476007)(83380400001)(15650500001)(186003)(66946007)(8676002)(4326008)(7696005)(2616005)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2s0WU1BcTcvYTBiYTQ5WjFyZGZMR2cxRDBRV0RPS2FTejJaMlB3KzNRTUFt?=
 =?utf-8?B?YTkzVjIzOUdsUURtOCtIc0djYk5teE9BUmMrYUdzUFZaYlVDWjk0ZEE2QUlj?=
 =?utf-8?B?N1IzUmNaU0Z3YkVUbGxsSUxZdHlWQjgrcFo2TWVERG9TSzVGdHhSV0J0MHJS?=
 =?utf-8?B?MENoVGRHRHpEaEJRTGJHc2RNZGJGek9ScFArcUtvajJtS1IvVUgxbW1VTkls?=
 =?utf-8?B?OVVjcXBVWGlsODBMeUpoODk0TFFHWHpWWjBlT1IybFFRU3VhL2VUcnR0R2ll?=
 =?utf-8?B?U25LZTR6Y3A2aEZLdXViNlZaOFJ5eUZiU1NyRVNObnhibm1jejQ2czhZaENi?=
 =?utf-8?B?TXRyckJubnFwMFlDcGpPeHV1Z0d4SEJYSzJQdFpSc2d5Y21sTTdTOEFCWGdS?=
 =?utf-8?B?eDdUendvTSsrci8vVmNJUXBvZnNHLzVOaitkQ1ZzeXZ6RFVHSG5KM2NmSkhy?=
 =?utf-8?B?Z3Jnc1pER1RBZHo2V3ZWM2ovVFhhNWpVUVMrZVN2aUExeFJpaGordmhkZVdR?=
 =?utf-8?B?M3ZHcmJIVkJNdEpWZy9SWU9pSHFMQlMzMUljRE9iamllZU5ZRENjZVdUdmk1?=
 =?utf-8?B?L1JJOHJ2SFNZVW5VR3lPNnpFenZJRytHZG53VWt5YWJPVnpFZXgrZ1pEbnlx?=
 =?utf-8?B?WG9qdXYzQ2orYm1pM2JXWTBYZGRabEQrZzh2NDl1cTF6cU5MTlBOZXFNbFdM?=
 =?utf-8?B?QTRLM1ZPamFTeTBEUXBlVDZ6cThrdmY0enVqemVBa3J6SlhUVFYxd1Z2eExq?=
 =?utf-8?B?dmVNVGhvUytEUXRxOHVBTTJMMkFaUzIvL20wVS83ZmVpaCthalBxYTRSMTVD?=
 =?utf-8?B?bXNPZkVnTGJyS0pjTjBibklNTG1jMG9ZeVZibGV5MEhMYWZxSkRkcHZQY2U0?=
 =?utf-8?B?NC92a09iU01jb1U5STQzV1NvajN0NVlvUWQxV2pKZURhTkRMa0RIdm8rWGFN?=
 =?utf-8?B?RWhiZFRwMFV2dTF6aUZkTFRkS2t5ZGV2NkNoc1A1bDlwWk1zWFZzWGtTSE1Z?=
 =?utf-8?B?TUxmL3UxczNmRzNzZnNPZWdBMXJqV0t0WDRpazMzc2ZHL1dQRXZBbHJyUG1B?=
 =?utf-8?B?RGxvem93cDQ3OTZ3WTFMZlZMdDdEY29IR0d3Mi91eGJpTG02YzBuMkR6d3Yz?=
 =?utf-8?B?MG9vb0dKckFmVU5mRTFwOEpYZTIyV1NFcFl6QkxiZ3hYM2JMbWxEeU4zYnk0?=
 =?utf-8?B?SGlVcDkvL2FzWU41RUlSVG1mNnUzVW9YaHE0dGltc3NXWVM0bzR5Vi9qZENG?=
 =?utf-8?B?bVM2ZDFOYWNRcmZYRmJKS1JpanJRaFB3eDhXNlU2c1F3RnMvcVB1dzhaRUFH?=
 =?utf-8?B?dnZ3WGxxUFFkYkwvWXorODMvY0o3bmpvNytzNFgvUy9oMkpPMkhxZWNidWg1?=
 =?utf-8?B?R2IrYXYxR1ozdWNMdzdOcjNhRXF4UXY1K0lzR3B0SWZWUDl1NW9pWHlzZWZY?=
 =?utf-8?B?eU1pTGJkeHZJZE5wT1dKUEdWYk1tcnhEUnVkbTd1NWJMS0NxT0VNTVJXQUgz?=
 =?utf-8?B?WUU2RlBiYS9GOVgwR2xTY2N6ckFTb0lQQkpESFk1YjRFdDZ1S2RPU1pkY3hH?=
 =?utf-8?B?UEplTXl5N3ptbXBNcm9KT2VUa0R5cHpvcTlNMDRaSHRtYjVoRFlpWVlZbWdu?=
 =?utf-8?B?SFJUUU9CWlpvdmZ3c2tqTEZxSTNHemVtbklVTVgzV0xSS280aXhjWE5IbnRv?=
 =?utf-8?B?aDROVzIyaitVWFFUUXh0YU5EZEpuWlFidlV2ZG5LZXVGT0NDOTRvMmNuZGVW?=
 =?utf-8?Q?BwmmpKkuooUHCUQGOaTK90F6PpbUNQSTBJnS/aD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f71d1a19-0006-4350-7133-08d983007219
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 04:20:18.9255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rF9U2H1CAzE6Og2hx6fw4PFZWMdke9mT1E2fbgfQNRBo9pR4A/PlhmUIf2nqE5LtSgb9j+Q0s2p8ii+Qa1llAuHTIunvQunPjU4a8jVLx+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4551
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=615 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290025
X-Proofpoint-GUID: 6KWAO-k-7t9bzhvHAWW6SYFdz0Ak0ydD
X-Proofpoint-ORIG-GUID: 6KWAO-k-7t9bzhvHAWW6SYFdz0Ak0ydD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 15 Sep 2021 09:04:05 +0300, Avri Altman wrote:

> v6 -> v7:
>  - some more useless initializations
> 
> v5 -> v6:
>  - remove useless initializations
> 
> v4 - > v5:
>  - Fix improper return error values
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/2] scsi: ufs: Probe for temperature notification support
      https://git.kernel.org/mkp/scsi/c/e88e2d32200a
[2/2] scsi: ufs: Add temperature notification exception handling
      https://git.kernel.org/mkp/scsi/c/322c4b29ee1f

-- 
Martin K. Petersen	Oracle Linux Engineering
