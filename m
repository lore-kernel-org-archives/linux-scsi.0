Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A302C07E9B
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 03:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7666761106
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 03:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhGUCmX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Jul 2021 22:42:23 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:24078 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231363AbhGUCmV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Jul 2021 22:42:21 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16L3GHmh011452;
        Wed, 21 Jul 2021 03:22:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=2o1nb+U1cxPnoUZTQd/JoNowHDvno7uP5StDRXDBTCQ=;
 b=aThSlfMYGPPGqcdelqspdvNZSTiucjiS9BIqtxBPl3+9c04bwHWIDlsBP0FLUOCfSbZ5
 pUD3byt6SGMBYrnV485sDqSlBCQFXGMPSf6GdetLl/6xf3SUtkn5KVF4BUZVrPTqCLox
 98gZmPNnoJuZxjABW31wORR3OvPLJg1nqALOCU75nJubUKurGdVZfGSqIkMr0+2XUdDJ
 eOfisOTDiQ9RCHt37F/WFplT7VuYfXE8nvZN/tbVHlfiBAfc7l4fXmiXNYWcgxkeLoyG
 jnP1nUm/PPCb14l/rPhj5Xos4HhYJqGE6TgZ7hyHXlVbP51Hm2i7yZPFTjG5RHkFCXVP lQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=2o1nb+U1cxPnoUZTQd/JoNowHDvno7uP5StDRXDBTCQ=;
 b=oir8+fapgGQ774f/jmeKu1RMv5+oIpG3JjclGSNTL3co3mZ7zxxZQ7ZNrYEdXtaijfw8
 9D56VJicwtuEJG/h4dDXOrr+yt0IchV0NleyrPEjD/IHfoD3HSScPe8TNHMLrk/O8uyU
 r+iXqDXL1VEq5c2i6ZagoUKZhWRsxGuitL8hNxtFAQ2qQO+ATBYIQBbtRK7i5Ek+tLR3
 bL16Vm5f0U9OBi8V071iW+EfyFNjkCgje5CsXFLPyAFMy90vzz7PEfUN5bpj1SgF3SxA
 +PIX1aDiURdFVjlfxucIB8sl608KNSLzczw3lXr1Zv3p+y9+RWmEV4G4WJbyW21JvjpL sQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39w9hfv5gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 03:22:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16L3GWU6041333;
        Wed, 21 Jul 2021 03:22:54 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3030.oracle.com with ESMTP id 39umb1rdnt-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 03:22:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DK3OTbTrBiG8No391FGUfY34AjHm7bU1nVAgn4VEyQe5aWGAzImq2E6q/aoQISPGFYXGhgcKaS5DwBJPuG/sKegrWzgWJxbq2sWD0GI8uqZJJm+hhFm6aJmUuf9Lu6ASofa4jZialVhqG+nW4HgSRR5MFxEj0c0Qli5QMSPTbcfhCcU+cN9zI6RJ7n0ZYq88cNT2IxcBMX1ri5PmjHeKORW9s814gdFJ7VlglQm3y8/+7trwOGEYbdsqH9wxnVEgSmcIdOe+20r3S1XtZFy9lIeDqfse/6Sbcr+/+TuhERcJN+yyN+HCylW7NtEPQE0NPDCt6yOhazTHJqzLUh44Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2o1nb+U1cxPnoUZTQd/JoNowHDvno7uP5StDRXDBTCQ=;
 b=JtUxwaxVxaH/oqjjo8F4baiB8dIeTHaALg4/Inqn8MhSGnniyIKjkZnv3HUCqBIT+GKwtPBzh/C1PsGN6HvYuC7x2UKZ3PF9OVuVHMV/OYdEH8Ffl+SRzxgcJcRyAPo9hbr6Va0J6PXr5zWWEMOfO5wG5ntZxWjyP7YfX7G1VzwBQNo1Zne361wEYvgSGVtHU9buLVLMs4kHzrO/Ibjwhv9vMIxVh02rZvmGHXU5VtXmRLwgWdW1u9U0x8WI4JGv15MFI5d2HvkAYSytYojSmjbQRuZdeTEGoT0RMi+gf/vXkvta/c8IV/H5OivJJPMkYAQ4KvIVwFsP44pllJzV5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2o1nb+U1cxPnoUZTQd/JoNowHDvno7uP5StDRXDBTCQ=;
 b=jlc/Lz5lW0jlSC0xEGC1it+emZATYXNoRv+N254qS0IhW6SVGHCg33XdmHQ/UdqnWwWmmARKCBW6iSyf5wclwWeP97CS+CZsbAIq5KLviaT+Fa4fypELBqzq29s9NZ6exO2Zg7E+xR3rVboM3ThP81uqxSwoIUoUObY4m5EmCtg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4680.namprd10.prod.outlook.com (2603:10b6:510:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Wed, 21 Jul
 2021 03:22:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 03:22:53 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        thenzl@redhat.com
Subject: Re: [PATCH] mpt3sas: Move IOC state to Ready state during shutdown
Date:   Tue, 20 Jul 2021 23:22:48 -0400
Message-Id: <162683773927.29160.3488679944475279250.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210705145951.32258-1-sreekanth.reddy@broadcom.com>
References: <20210705145951.32258-1-sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:806:130::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR13CA0008.namprd13.prod.outlook.com (2603:10b6:806:130::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.13 via Frontend Transport; Wed, 21 Jul 2021 03:22:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 915ef60c-00a3-4221-860a-08d94bf6d38e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4680:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4680B45277A2AEC847DAE9708EE39@PH0PR10MB4680.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xqxBp5IHK/LE9h+OAoj2ER14FG+wqz22KuuEOOFlPvRPbX1rhNtINWYA11QiTTjWKCsLDaaAhGmZoF40vK659ta6wljwjywyRD3sZgv3vytCxe6Vcom9t19+QOo2340aWfi5UB0yjgRAAazHPhgfegnijAwL8OcjMJqhWoy/4xykHyiK0Y6YCLcOvsSWWI0I5G2RFq143QIxOyhXkTrDwYy4NcB0TC/2A9lqlD5vnKdPqvZz10VPuyzQpICWiJiPXt9OwZKkAItitXijIQWcGY0szpvRvVoUNx96eRuoKqvAeSb/UDhKJXbeo5MTQsl0j3qHcyoK7EW9MoOTW3ClvxvsgZPyWF0b5kVVFFKXhq+CM6m36/1JbuGcha/GBd3ROGrLba7XfQ3m2kwyuNjiN5M/46Z0pQm6muqI3gPXq0vdDcZZzobZWLCVmaLek3UyyeyE3MbJvafSG9j2Ex3GjG3OHV2luP7r1loiZMmPYuhvjEZvk6DLVgiP4W0GuGRQnN9omdKXljqnaJaObONAsObt4bjxiDJHtlcoZjM6acm6MvzArGmp211dMTPPBvaEtluX4FPp5s1z3kr24mEuWNq/HazZpvq5nibAgtgR7yIoaGgohglPVJ+WpyPeoVsffP6A5Tn5dFjzSy5TENxVeKTC8VJHVCnX348UM1ZBmLEp/Efxyjw4RSmkyUt26VV/JOUuT+/YLb8BDbqo5I5dNCdUULMKR+Jk9Fdi3aL0HtcYQhgvpWC7xxBNsJOnPjwijL3mm3e1r2D2I8wTqaQQ08Cj63INH9zxz44r/LbET2v9V75B4vD+F1+gQ2RzEhil
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(376002)(366004)(136003)(66556008)(2616005)(66946007)(956004)(7696005)(38100700002)(103116003)(966005)(478600001)(66476007)(4326008)(6666004)(5660300002)(52116002)(86362001)(8936002)(316002)(186003)(26005)(2906002)(4744005)(8676002)(36756003)(38350700002)(6486002)(6916009)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REw3eWY3TVY0UHdmNXowT0xDZk04Ly9SUVhGM2VZUHdhaEpXY3lua2dJaS9D?=
 =?utf-8?B?NXpVZlBwN2t4TmZ4WEt1b2tlb2lYaHJnc3VTK0t3SUlHNG1VSFNJcURBNVZ3?=
 =?utf-8?B?bVVEMEIrR09UdW1qTlh6Wm1HZDc0a0FTSXIrNEJRQzJSV0FHV1M3NlJmSFlJ?=
 =?utf-8?B?S0ZQdDlPNXlBZmZzRHhrbXhkb2F5T2ZMQmtvZDYyaDQ5MW5HaEJTWGZCZWlz?=
 =?utf-8?B?MkF4UmxGQWRmbUQwd0dycmgxWVV0azNyNC9xUXRhQkZVb1RKR3A3cyt1YXNq?=
 =?utf-8?B?aGdNS2pPdm1PQVpBbnB6UStOcVZET0FLOEF1d0VRSXZLRXNuQ1NyRVpjSXYx?=
 =?utf-8?B?cEQ5VWVCNitPSjlNa1BNNnB2U21vQTg0UmtZRnZoa0oydXR3U1prTTZVemdu?=
 =?utf-8?B?WkNMVUc4ajhDK2xCNVplblo1Y2pPdWNEZWRYbGFGbG5UYkNOb20yUUFBYURE?=
 =?utf-8?B?b2d0UmQyQTZCNEtyY1pFamVwZkpYbEcwRkJSMGxTZDdNNFYrL0twcHVkSDBy?=
 =?utf-8?B?M0hNa2RaRG5ZdHE1eUJxZGtOc1ZIdlpONUxPYXlqc0VvQzJIYlN6RVIvYTMv?=
 =?utf-8?B?ZVZBUzVWREZGZTc0aENnbXpFaEc0bERmeS8rbm9YeEhQaVh2YzNHUC9SNzdr?=
 =?utf-8?B?a1ExK3VXd1pwOWZlZjJ6Z2FHM2JPMFFMUVZsR0gzckJndmEyZ0NLdUoxY0F0?=
 =?utf-8?B?QTJxa0lUQXhGa3NkVkNVVDcyUXVOb1NzeW1UVXZmVDZDS083SVUrbU1KYU9Z?=
 =?utf-8?B?Q3N1a2s0cmdGVW55MVBUeDh1Z2FDTXNFV1orNG9LMDdhNHdRT2F4c0ttSFcw?=
 =?utf-8?B?enF6UWI4cDVVYmFmd2ZMSVZiQmFpYWwyaVpnL0ZhWnBrYklzTHhlaHpwTmxy?=
 =?utf-8?B?VG9mNkJRV29FSXFpQVM0NFdyMDNEQ3dITGFPZkZSSmJLU24yLzhLUk43bDFG?=
 =?utf-8?B?RU9NZzR2VldrYUhDamtVQjVzVUFoTUZIak5TWDBpckJiZmpzS1U4NjgzUXdP?=
 =?utf-8?B?c1lXVFlmcXlHcGoyMzc5S0c4MmNrQ1A2eEdaS1VSRmdDZ0phaHZJdTRqRVdk?=
 =?utf-8?B?QWR0NExjTytVYnM0NFIyMmUyTFJXQnVidGdXRjV0V3JqWEN5aGpYbGg3TFp5?=
 =?utf-8?B?dDJ3VmR2RzBFelZxT0phOStReXlFM1BZWitsMzh5Yi9UakR0b3d5a1hCcUxm?=
 =?utf-8?B?ZUZXZlBSZGdFcUxRZ0pxWEhuSmZTYzJVUndzVGI0Nk9OTFRrSVIxQVZJMHNy?=
 =?utf-8?B?K1NBVGc1VWVwNm9ra2lzeGRra2NNMFZqZ0gzNk8wejUzajdmTENRVXQxMG5j?=
 =?utf-8?B?ZWhRem5IY1AyNTVJRUgrYkN0d2VFaStVY2hqWCtFdGZHTHdRanlCSW1xSnZn?=
 =?utf-8?B?aDd2Yjl4Z3Nnczk0ZVIyZlRTQnVqdVV0Q2cvZG5SQlo3cmxRU0hRZmVlR3Rp?=
 =?utf-8?B?ZUYxTVhwdGxVaDdDL0ZyTFczeVdoQXU2aXpZVktwQ0tTQTFWZ0xVL2Y5ZE13?=
 =?utf-8?B?ejJOY1VuMVhwcXExV3dENlBIN0FoblVMLy83QXBWQW9CY3hacGJYQStQYzE5?=
 =?utf-8?B?K08va0pJVkFab2FoOUFSR1QzVUZTczRUZzRWbUc0TXg0RWJUbk5OS1J1aTRV?=
 =?utf-8?B?NS9BeEJoaXB4L2ZpZCtuNU8wOVI5bDRLaXNZTDlDM1JGRmYxQlkzNkd6YmNU?=
 =?utf-8?B?V2RRYUh3cUgwdzF6Z1dpN0JjU0pqMWtwb3hmWXYza1cvRFN6OGhoVHYvVzRB?=
 =?utf-8?Q?6zmJCTclVFkAwXJUDSEYBeXxKw0c4bobGf9puae?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 915ef60c-00a3-4221-860a-08d94bf6d38e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 03:22:53.4928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1z6Akz/oesdG9m7DHlPrv36HnKi1qSp+6P8j+5pvZ/Xd3N3t5wo7nPnT0frdlXnDtHjR1nWHkombiavEG6JsOc8tjVorZDuJHwQ01/cEzn0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4680
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10051 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107210017
X-Proofpoint-GUID: ABC7BhkXCpsCfwFbiAJxgOjwaNgLFkvZ
X-Proofpoint-ORIG-GUID: ABC7BhkXCpsCfwFbiAJxgOjwaNgLFkvZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 5 Jul 2021 20:29:50 +0530, Sreekanth Reddy wrote:

> During shutdown just move the IOC state to Ready state
> by issuing MUR. No need to free any IOC memory pools.

Applied to 5.14/scsi-fixes, thanks!

[1/1] mpt3sas: Move IOC state to Ready state during shutdown
      https://git.kernel.org/mkp/scsi/c/fae21608c31c

-- 
Martin K. Petersen	Oracle Linux Engineering
