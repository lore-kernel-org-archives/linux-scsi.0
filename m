Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E692EB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 08:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjGTINO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Jul 2023 04:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjGTINN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jul 2023 04:13:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD8F2686;
        Thu, 20 Jul 2023 01:13:10 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36K3Nwl7001212;
        Thu, 20 Jul 2023 08:13:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=YwtyGtINd9mdoXTb1ed1tedGFjIWmflHj51uj4U8/D4=;
 b=d6mTAjkzQ6ZzOp0FQ0AV1DZg2MgiHS93kuLLVmtvhX376GD6iEKUi3aRL1m709TgnDBJ
 r0R2ojqKhHf2r88iwRcNlBg+rcCiowauxGOs8CYDd3f504GsbsncuKu/emKFRCZgcjQ4
 +RFjHO2nCjdi7pbxNZRX54l9JtF3B4adgqbbWcjzyTs/6SAuKpuHi1xNXZUsyHHHXIKV
 wJdei/W0qfLotmq1ogk+sASZu5bwnaEnD/ANbRfCI1HJfVhjcIBeiQSpjtLGoVHk3KQw
 g4b0mVgmoydD1CKZC7bIsqQJzd4yzIIW3cBi8lXwEk+m6vaKV18akAptZ+uxbwRh8/B3 0g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run88s9we-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jul 2023 08:13:01 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36K6UvpS023907;
        Thu, 20 Jul 2023 08:13:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw8hmd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jul 2023 08:13:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLItY2crk+77yLQLRfvEebxvm1euvVWNUIgpwTO6CN0P/BD+kwXzmVvS+brtaTmGcmOhsIRzwdrejP4yAu0u+SAZmuenbw791nqgCXb7Ij/Tuu9ym4wyxRcJ4O+I5TQq/nY5tvr6Z60TmXEdaXUG2D+YrjUqHVggNvS4tjKRAGk3OD1TKexx8rEjTklyIQWPxFUlxFga77oz4VzWteM5vWA9h2LMI669+7T3+vnYRmrEph0bgATMrNU+p1Ta+cUhzwyOm1Abv8ZYPHieJxgQp5nW/RKVe0LOaG0u40rDBzn9eafK+d7a+T+bUuMeTenJKS8UojF5KLnfNDCKJLrCJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YwtyGtINd9mdoXTb1ed1tedGFjIWmflHj51uj4U8/D4=;
 b=bjmZd0uN8c+8RW8stX6p1LrO3k2X7STo2HsgQ8mNejfFXfr99z3Z6AvC5qNZbPsuJAuivuovcPza4jYh/9EPbKvbiURqY+ONmW8uv5qVsaag0sZ6eVps1wU/YXExtjJ24tUN3d7gwqtcE5Ur8pnjtXjMWbO0veG9/3ScljJM8TOgpQcEKeES3gzpNOWNv3cSrk/ecs+UJqOkHtHIMI366hHTzlhNhmqOrQ3XlC8RyvJhyzEUhFf69xBAJaHtIaWLQw+1qNfZXUrMoKgTYniNmBBk9MDnzIk51nF33SwQsnNrdJl2QonEBVINAB2ZXHaxGcOZpDiscX+7NBsKuy9kow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwtyGtINd9mdoXTb1ed1tedGFjIWmflHj51uj4U8/D4=;
 b=AlUfnKoYupWgzB4w8GbPJX5gPLkUfrdC6MwWec4nRxwR05PrOsb5HlJL6Xl//G1OinhqZY3ktnFcAwKejzDUce+ktT02zYY+K3M1AvkMgYBBsAqrwiUHgXcwaWJptV19b6mCZMjL4mewdqMEsiZckURjPHmrnXXnCklxZaItMg0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB5017.namprd10.prod.outlook.com (2603:10b6:610:c3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.25; Thu, 20 Jul
 2023 08:12:58 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb%7]) with mapi id 15.20.6588.031; Thu, 20 Jul 2023
 08:12:58 +0000
Message-ID: <cd3a32fd-379e-a9ba-222c-f263eaf9c582@oracle.com>
Date:   Thu, 20 Jul 2023 09:12:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 8/8] ata: remove ata_bus_probe()
Content-Language: en-US
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
References: <20230720004257.307031-1-nks@flawful.org>
 <20230720004257.307031-9-nks@flawful.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230720004257.307031-9-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0142.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB5017:EE_
X-MS-Office365-Filtering-Correlation-Id: acd24918-8135-4277-7d37-08db88f920a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9pOKAPyF2LU9cSY/xrm/Qx/W16Xf6P5GM1ZW/X1ztehWmYEfl//EEFkg44Ls+0PWFnUwZnsbXJV764H1xnrmIIlfkQkuMzId5DgOZlbDVvddwP0o801mADULXS6PP124H4MyZXPUk7JHHz8SDAN6r4btQySMHePhWIF8qhtVGrOO87KWH818HVcH2Uen0KIvDMAYl85hOehR2MhzIxFc4nmUw5dsZvHiB/d8zf+fHHqbUeprkftjNCLZK5go4vm3ZFEF8VW6gmEOYt8Au7CxhKtllhbRrVRVNxvySZ3hPPrDqM28dhLY7JYfivfMHuc0lVuVHc2978RQvQA2CTROZNE+xls9BkWSZCCFcPk1rOXmQfvi0RYf0s26OMjUK4t9YoRmUyS6JQ4Sv+UMWxRwha5ZbtSLMhS9u0z5/Jb14BUGJxlrTH5tHYg/WkOZE9gDOjo5llbP9Dmztb0jTAbygxOtEaOagmx3UKN1arxPz0amq18mF6k7RBNfRNbNkWUcIHmkf+ihYus7F4s8PBeSPbpdGBS5lMnOzZAzA5tDBZMqKYJYvFVAfFlwb7s8yIzeTY7hgXO2faShntz+anOjdAClERQECovQsSn4Rt442E8APyzIE0K2jUmHr8F6qL5nD6yiL4moYeSYLYfOfV+37g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199021)(66899021)(31686004)(186003)(316002)(2616005)(36756003)(8676002)(8936002)(5660300002)(110136005)(54906003)(6486002)(6506007)(26005)(4326008)(53546011)(41300700001)(83380400001)(66946007)(6666004)(478600001)(86362001)(2906002)(31696002)(38100700002)(66476007)(6512007)(36916002)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ujd0bDB1eXFhbzV1SnJsRnI2MWVzMEdkallUZjVhdWw3b1ZuVFZKSXFJMUIy?=
 =?utf-8?B?NEpLNVhmVGdGSVAwUUZ2T0V4d2Y0T2MweXkwSk5PdEhFTVpCdlpwVnp0U3hU?=
 =?utf-8?B?Z2FkcDkxRVhNQmprOTBvdXREaVJCWEdITjM2R3VKY01YbWRIRUR2QnJ1WWV6?=
 =?utf-8?B?K1JyV2IwU0JpVjA5VGlNS2VZZW1WUnpyWTNDM2c0ODA5dkpBYWRqWTJoY3F4?=
 =?utf-8?B?RTIwTjFvdWJwZ1NDTUhKOHljMG9oNCt0WUhpZ25JMTFQQVlKS0RldG41cm1r?=
 =?utf-8?B?U3Y5WkN2WGFqV2pabUNmWlF2NnpxeFFETFZ3YmFaRUMrYkNyb1FuOTJhSFYz?=
 =?utf-8?B?TmwvVlZwOWpjcUZlVUJFL2NxYWcrYW93Z1Bnc2RkZ2FRNDMvMEJYZU9Bdm5T?=
 =?utf-8?B?eWdnMi9ZSjRwRFZIMVcxcUFleG5nK2lrcVFjK1JqekhBY1Z3by9SdCt1Sys4?=
 =?utf-8?B?amZJQjZ6U1JGMUR5T0x4ZzRnTG5tNFVoRWxVWmMrd002eERQZnFEOExLZ2Iy?=
 =?utf-8?B?cWp0SXlXV0RodC9EMm13WkZMblFQSlZNNXA3R3ZZNlhZV0F3b3FEWTYxRnJV?=
 =?utf-8?B?RW5HNnV5MFRGL2xUYTlyTDEvN2hhblF0bUJib0UxaWpaWTljbGFBUC9BTmdo?=
 =?utf-8?B?NTI2UFhaaDZRZ3FDU0FlQis1bENxYXpYK0dQN3kvNzVYNlZ4OWhHRmZ6aldM?=
 =?utf-8?B?WFZmQkVRTlRXVy9aNEk1MldWRDBHNHRTUytNMURVdjB2aENkSk16ZzBIYmo2?=
 =?utf-8?B?S0JBR0k5bitNMUFXa2ROOGlZNnQvMSsrNDFKOHF6R0ZKaWZabjl1QzVQVUk0?=
 =?utf-8?B?cVZQVG1sTzg1b3N4TS9lYXI0OEp6RW9od3AzWmxXZ3ZjcGI0RmRrbUZHWFFW?=
 =?utf-8?B?K2ZDOVdpS0JBMlZiM2JiWEYybUo4QlBJTzdZNmhDUmFqWS9qQTU2SnVOaWYw?=
 =?utf-8?B?ZEl0WWVscUR5WE9MVHNDOWlVVUlpZWpJWWZmNnZDdjhHUERTbCtjb2hMWXoy?=
 =?utf-8?B?cHhtTnE2RExEWEJxai93RXdvR0prVmtnYjBZU2NzZlN5TmlJVzRWTnpaM00z?=
 =?utf-8?B?Ymo5MDk3UlR2WTJSb3BiUE95c2lKOU5BeHR1Q3A0NE9wOFRrZUNTYU5GSGgw?=
 =?utf-8?B?RlBYL1dYZEZ5d3cwWG8wRVNORmoxT1VSYzVYTXNLZkdScENNam14KzFqWXVP?=
 =?utf-8?B?NXRkQWxFbW1KbHpNcVpSVGZGM09NcmE3NklyaDNMQzQyU2ZDUXU1VVcwcWZ0?=
 =?utf-8?B?c2dRK3VMUGt1Y0wxZ05ia0FldjYrUWdzV00rU2ZIMTg4ZmdOQ3hFa3NwbHJu?=
 =?utf-8?B?cHRoSmtmVEtjWGdxWUZhSmh2OHgwQmUyMXVMOVYyUG1HYmhwZDBtZHJvS09X?=
 =?utf-8?B?STliVFB6Z2g4MkN2ZnUyUVJvMlp5Sll1NEQ2NitoN2JWZlBXb1dsaDYrVWcv?=
 =?utf-8?B?Z3hPZFNjd1FuSkZDOG85U1pkckxqWDQ1REpoYXlOd3NqR1ZybGdxNVNweXpz?=
 =?utf-8?B?VnlueW94NWsyT0MyNytsWUxUT3dhejFKaE5Tb1pvb29HQ2RiSDNWRmZTU3BN?=
 =?utf-8?B?b0t2K2NWRHhFaTlGdFE0eU0xd21NTjVZa3kzcTI5enl3ZU5HcmVoQXpVZUpt?=
 =?utf-8?B?V1R3cXBVcUg3S3JUMTc5R2lGQ1NlZUFGSWJvOHN3Wng1ZnBUYlZKQm5XenpF?=
 =?utf-8?B?akNtSmFkMUtSbTdkMGV0anhwRk9HanZlZGQrelJQdkFHaWJmaXBnMGlXSG9G?=
 =?utf-8?B?WWZCNnBpcHVyQWdKREhQQ2did3dZNEdpa2JQLzMrc2hRdHZ2WU8xUThKaHlM?=
 =?utf-8?B?N0NHVWdpeUhkc3BhNzdMeFlPRHJ4RElia0U2WDRoU1pVUkNFaGp3SzJhcjUv?=
 =?utf-8?B?dklmOWdrcmU2R3BDS3JqbWg1VUpHV1hjNllNVStqc2lMZ2ZVTm1wcTAyTVJ0?=
 =?utf-8?B?aWpqNitGQWJHdEY5SHFVZ2Ztb1dOOFZ0VlVPMERpNXFDNGw5SlZiai84RFk0?=
 =?utf-8?B?bVRPQ2ZmODhlQkhVWkZIb04rZllkQjlGK285QWJhWXJROXV5VEluNTBsWVRI?=
 =?utf-8?B?SmtsREthcENaeEM3anZFTTNFckFabGFjV3FmQWFCVEZFOGFJNjd4MklrQ1BI?=
 =?utf-8?Q?6HBOelnKM0bJaunS6plaj9fYY?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: d5F+x6DAi5AHX+zwcCy8oIhe+7/RmV9sqUhBTsOokKz/cWfwqzOL95K6SZ+0Jdt1UC4AWcH5+hWILnbGmTc3ahukZBjOVMmSS6xZaSWrMBF2uqT4f1mRUMtQZGfckTC/IDLdD9Fnma4flmYO/KtEzOQovHQejvFfh7L0SsQ5VVLQWZdUWyHyTc01rOOKsMwjep/Myn5JHGb9azK+oB+KdN3zRo5bHJatmBTqn1LI7mkJtIJSde+B6P5oU+sq8kuB4J2qQKHRkGHT+37xrsBHcbKyZ6qVGAFsnA8hEHWHnvNmQihGMfQ6oZ8nlNU6OVOIaxX4kARMuDabssHe7rU8VDpKiMhx3GkNwt2ifBx5Fh0j1SQvHShEGnkyQqdwXiRYWawhaSW6gCzZ2+Ol4xlLLIBA6eHvWLHfOsjOClifBG7Ld9NGlaQVaMr8JMd2fIz9upa7srP5PMmM2IYPnat5gzFJ5Xw2OQ1FEwBY18kYy8cEOYGNYg9A0xZQkqyMYHJ/7ouqzwIUNkXD6IDBkiHq+IHyrlQ09NCH0zXT5elxRTGviV4uMIXrattHztADXHRZNdIfsBOAuxvFX181Y5MojruLKHHjaSPcAIFgDOzX7grz/W+4HOj/0gLovwalFNQAg07n7Yv6rsAvrHXcKS8PYQKE8l3Gsm7+pCmO16CiLrTgg6G+2nueydVOO6Ev1En2y0SlSdT3pz24tizXVi++U6TW8KtVmGeDFq0Z0qKq5An34ZxCyxV77wwCP2Ifg7kxiLYKRvBK2aG52P3DRcsSJ4rXA5HyAO4wa3zii3xj6/26QdYgCKcIlPFeiABK7j/JAdt9xhLKwMuycRI7HEUepfi+HmGrAWIMqfDh2KGKu+v5V3ZDQbV3PUwBlx0XyQjs
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acd24918-8135-4277-7d37-08db88f920a7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2023 08:12:58.2838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yaXbFQrRZEwr+FfU1Q8mXIyVMOppJ1/n6EE7zXQWDx6nmmxaa4z3XoxtulMLS1x4AtM9a1qT5fiKXnhbGgTO/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5017
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-20_02,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307200066
X-Proofpoint-GUID: rzkKsudR3cWJauLlpJ4T9lKVc8nsY006
X-Proofpoint-ORIG-GUID: rzkKsudR3cWJauLlpJ4T9lKVc8nsY006
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/07/2023 01:42, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Remove ata_bus_probe() as it is unused.

Is there still a reference to this in Documentation? There seems to be.

> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/ata/libata-core.c | 138 --------------------------------------
>   drivers/ata/libata.h      |   1 -
>   2 files changed, 139 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index dedae669c9da..0af88ef231d1 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -3057,144 +3057,6 @@ int ata_cable_sata(struct ata_port *ap)
>   }
>   EXPORT_SYMBOL_GPL(ata_cable_sata);
>   
> -/**
> - *	ata_bus_probe - Reset and probe ATA bus
> - *	@ap: Bus to probe
> - *
> - *	Master ATA bus probing function.  Initiates a hardware-dependent
> - *	bus reset, then attempts to identify any devices found on
> - *	the bus.
> - *
> - *	LOCKING:
> - *	PCI/etc. bus probe sem.
> - *
> - *	RETURNS:
> - *	Zero on success, negative errno otherwise.
> - */
> -
> -int ata_bus_probe(struct ata_port *ap)
> -{
> -	unsigned int classes[ATA_MAX_DEVICES];
> -	int tries[ATA_MAX_DEVICES];
> -	int rc;
> -	struct ata_device *dev;
> -
> -	ata_for_each_dev(dev, &ap->link, ALL)
> -		tries[dev->devno] = ATA_PROBE_MAX_TRIES;

ATA_PROBE_MAX_TRIES is no longer referenced, AFAICS

> -
> - retry:
> -	ata_for_each_dev(dev, &ap->link, ALL) {
> -		/* If we issue an SRST then an ATA drive (not ATAPI)
> -		 * may change configuration and be in PIO0 timing. If
> -		 * we do a hard reset (or are coming from power on)
> -		 * this is true for ATA or ATAPI. Until we've set a
> -		 * suitable controller mode we should not touch the
> -		 * bus as we may be talking too fast.
> -		 */
> -		dev->pio_mode = XFER_PIO_0;
> -		dev->dma_mode = 0xff;
> -
> -		/* If the controller has a pio mode setup function
> -		 * then use it to set the chipset to rights. Don't
> -		 * touch the DMA setup as that will be dealt with when
> -		 * configuring devices.
> -		 */
> -		if (ap->ops->set_piomode)
> -			ap->ops->set_piomode(ap, dev);
> -	}
> -
> -	/* reset and determine device classes */
> -	ap->ops->phy_reset(ap);

Does .phy_reset still have a user? If not, maybe all referenced symbols 
removed here can be checked for remaining references.

> -
> -	ata_for_each_dev(dev, &ap->link, ALL) {
> -		if (dev->class != ATA_DEV_UNKNOWN)
> -			classes[dev->devno] = dev->class;
> -		else
> -			classes[dev->devno] = ATA_DEV_NONE;
> -
> -		dev->class = ATA_DEV_UNKNOWN;
> -	}
> -
> -	/* read IDENTIFY page and configure devices. We have to do the identify
> -	   specific sequence bass-ackwards so that PDIAG- is released by
> -	   the slave device */
> -
> -	ata_for_each_dev(dev, &ap->link, ALL_REVERSE) {
> -		if (tries[dev->devno])
> -			dev->class = classes[dev->devno];
> -
> -		if (!ata_dev_enabled(dev))
> -			continue;
> -
> -		rc = ata_dev_read_id(dev, &dev->class, ATA_READID_POSTRESET,
> -				     dev->id);
> -		if (rc)
> -			goto fail;
> -	}
> -
> -	/* Now ask for the cable type as PDIAG- should have been released */
> -	if (ap->ops->cable_detect)
> -		ap->cbl = ap->ops->cable_detect(ap);
> -
> -	/* We may have SATA bridge glue hiding here irrespective of
> -	 * the reported cable types and sensed types.  When SATA
> -	 * drives indicate we have a bridge, we don't know which end
> -	 * of the link the bridge is which is a problem.
> -	 */
> -	ata_for_each_dev(dev, &ap->link, ENABLED)
> -		if (ata_id_is_sata(dev->id))
> -			ap->cbl = ATA_CBL_SATA;
> -
> -	/* After the identify sequence we can now set up the devices. We do
> -	   this in the normal order so that the user doesn't get confused */
> -
> -	ata_for_each_dev(dev, &ap->link, ENABLED) {
> -		ap->link.eh_context.i.flags |= ATA_EHI_PRINTINFO;
> -		rc = ata_dev_configure(dev);
> -		ap->link.eh_context.i.flags &= ~ATA_EHI_PRINTINFO;
> -		if (rc)
> -			goto fail;
> -	}
> -
> -	/* configure transfer mode */
> -	rc = ata_set_mode(&ap->link, &dev);
> -	if (rc)
> -		goto fail;
> -
> -	ata_for_each_dev(dev, &ap->link, ENABLED)
> -		return 0;
> -
> -	return -ENODEV;
> -
> - fail:
> -	tries[dev->devno]--;
> -
> -	switch (rc) {
> -	case -EINVAL:
> -		/* eeek, something went very wrong, give up */
> -		tries[dev->devno] = 0;
> -		break;
> -
> -	case -ENODEV:
> -		/* give it just one more chance */
> -		tries[dev->devno] = min(tries[dev->devno], 1);
> -		fallthrough;
> -	case -EIO:
> -		if (tries[dev->devno] == 1) {
> -			/* This is the last chance, better to slow
> -			 * down than lose it.
> -			 */
> -			sata_down_spd_limit(&ap->link, 0);
> -			ata_down_xfermask_limit(dev, ATA_DNXFER_PIO);
> -		}
> -	}
> -
> -	if (!tries[dev->devno])
> -		ata_dev_disable(dev);
> -
> -	goto retry;
> -}
> -
>   /**
>    *	sata_print_link_status - Print SATA link status
>    *	@link: SATA link to printk link status about
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index 1ec9b4427b84..6e7d352803bd 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -122,7 +122,6 @@ extern void ata_scsi_media_change_notify(struct ata_device *dev);
>   extern void ata_scsi_hotplug(struct work_struct *work);
>   extern void ata_schedule_scsi_eh(struct Scsi_Host *shost);
>   extern void ata_scsi_dev_rescan(struct work_struct *work);
> -extern int ata_bus_probe(struct ata_port *ap);
>   extern int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
>   			      unsigned int id, u64 lun);
>   void ata_scsi_sdev_config(struct scsi_device *sdev);

