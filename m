Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0301C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A71860FA0
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbhHQDSe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:18:34 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47428 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236836AbhHQDS3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 23:18:29 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H3BtpK025387;
        Tue, 17 Aug 2021 03:17:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=NO1vMNS5eNP/0x4Y640BkmTNHyBBAcoHRHVGuXN6sXE=;
 b=w9del2CBRpTUIErG4J26aqMeSfkEsmDlk1cIBrXRsaIzLejWOcMopjpOvT274O1n88uW
 Q85F+59bjOksXjLyKDhy8el5MNlPUlti48H1efa7h4MKv5m1jaguouLvjZfQY39OfcmB
 b4lDIxJ1byPDo4PMGskADKyDYh/ORbEm/TM9xcK4KUxsUXbKyMv4BD0N1cf4NrDlz/b0
 IMZJz7BC+ZDqUl3xh/RDzeGYfF+HDs9jk0Ho7vTa/eY3zlocGGYaQeSFb5nQikeihOys
 A7CeVsaN7EVv1QeSa1r7XQmJve1e3kbLHbf6L/aDub9HnfGp7ZJMGo4h/iMCt3Htz1DR dQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=NO1vMNS5eNP/0x4Y640BkmTNHyBBAcoHRHVGuXN6sXE=;
 b=VtReT6ikpsL9G/MNRDi4mGZQHhPLmLt0ApP1aBCZRrKdh1s6WQO8PMdN/YlrejVi1xMS
 obix28O7aY3yjfdvO72iBRPsj+nTCJIA11rhzr7B3TrDxolOTKkdolJ6nhyPsSjtzcbz
 0dFl8ho8NH6kTrFTUcShzbFlIKYOy5rN95i0jfgYUcAzQAKbCxIKDwOCcPWk7PeFug3U
 u1Hw0OlfWaIIYwFN5qdloYTMh/lwM5/anLlf4vPjNhydM04/H595eEAUph+JwfFEFyAv
 dHQtXT36TWb219hM/0pVnK4WwBtsWGkLWgtykWuuuvPXkthxftPy1MLpi/l0kWd3YuS8 RA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afgpgjn36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H3AlON195395;
        Tue, 17 Aug 2021 03:17:52 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by aserp3020.oracle.com with ESMTP id 3ae5n6rgde-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FVWbzQ4F4ZlWRKfl6osJ3MKmjtuLMywuY0wRu5tgDLEd4jCeSbGmPCt5m1rulkqwS9v+kQnahk0+Ar1LI0pwRZ5bYj4vu1cwBxNWWacNPINBl8ev3j2M41drPLqZMB/rAsKEm92eNrc6i10avXspc/pzFPbJuIoguS1tklKC2NnTTq57u1fywojrBKwczjqEjKeyf917Ys0/qNKhCTGTDipyfiBWLwCxtqXIIrS/yk5C2H6qgyDyh9aPnlHyKlDToFIhAh44mR/+0jG5zxU7+JS5MqEr3qz47VjMYQYP3UwxPM3F3s4Wq43WWc70heauyYQW7tMH193kljT4OaUpXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NO1vMNS5eNP/0x4Y640BkmTNHyBBAcoHRHVGuXN6sXE=;
 b=MXMIQVzzbV90z3pM4Q7hFjArka2vuo+KepTi+PMPLoX5Qr7Pfh4intEtNuxTieEb7cvquGHyz96d8sanlJ+cYLLwQqTLQwALkPtqdjoHFfzNNdTmBTcvRqu+IfuQxh85hO0jHUQUBu5OLLsCx7dYuw3vy8zIrGSj0m1zs8dbWUx7TVtXS3XRCGzX/9SjnACzvomm9NCuemfu4+baMtp03L+eynweLvqsjAI6qnF0e3MworQiWlp6qpIcoFtfcUO8RAGmrBvSgDcd+2f3CfIBsUrWTxifBCbwHCUst10gfMX5uVtAJdRq5WblxL2lVHgrWETBMQ9UZaEZwKBZG8rN1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NO1vMNS5eNP/0x4Y640BkmTNHyBBAcoHRHVGuXN6sXE=;
 b=jN9Y0g87mL2I7/w1eIXNYR+HcAXNexpR0u1qlisla+KLDgfLd1F05hu84U6dMK+Yt3cdCP3igcnV+TvVXmXw+ksBAhk3cjsq96pEqCh3gbhyjVmvd1AhwDnkr3+9DqgktBR3+nOEI0nwGOoYK60ATKwskJX66gQuWKlytSkwikw=
Authentication-Results: cloud.ionos.com; dkim=none (message not signed)
 header.d=none;cloud.ionos.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4566.namprd10.prod.outlook.com (2603:10b6:510:36::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Tue, 17 Aug
 2021 03:17:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 03:17:51 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: pm8001: Remove redundant initialization of variable rv
Date:   Mon, 16 Aug 2021 23:17:36 -0400
Message-Id: <162916990043.4875.15527065721409531130.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210804143319.115340-1-colin.king@canonical.com>
References: <20210804143319.115340-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0178.namprd04.prod.outlook.com
 (2603:10b6:806:125::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0178.namprd04.prod.outlook.com (2603:10b6:806:125::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Tue, 17 Aug 2021 03:17:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e8e476a-47d5-4077-da06-08d9612d986a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4566BD6E0C3C1C38DFE714008EFE9@PH0PR10MB4566.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7QAqdqRgxgyNJvk1ACieCigoCKbbJz/9S2m+RFb+RNNmb/s+kNi5auR6Z/qQDUFrx1A6QNQl+5abubYBls+r6VAsQpHHKxkypTp1cDVede83aSYPwGjTRVa0/KpC3RQYJ/Ui25MWkkBKZigxJQ5+Nq6KVECI5zXrwawDiI5FCxTU4CjaJkikASVLoQCoSbl4bIot3yZwKdlHGDRDpdaS9ElU9gZOWG7ET5NC4cChhsPYUokfBLA0C7Z/1o5XGjCSIJt2NmIC5Fa1QitAig1wNqD34E/Y5QXGVikOrmnBkeerp9Se+7yFrvGgtWJS9zOGprSCZ0JbwhK2dtqI+oEf0ukVaLZNQZqtJKDi2cJ4Xc1QsNzqwOL3WjepBMDnPFkHWn/TSppegg4U8lGI64NUtXx8jiM01h9CVOIrI1U1gkC/Vz7soH0xQtJzwLP0Ch8KdE5MKgbfZ4LVolISeTeV2oiWREE3NZg5J7OiH26Zq3ppJgd4vmlce0GeDWwkbFzDgpAb8BvqAytcaDIey83qf/IjKl81Jq08+5FVhL2oinDZYzlHVVbRzPTY/y2BBJ+lVl/blhQVJGLiGNgY3m3NtYXyYNXlhbnoQz+GU9jmTCQalpn8tw9PpXEJB6mVHy6dyTLKSURRhk/Tkij72LFR5GcaYA/vVaQjSkGAmO+VahM21/+Zd9LHTYQLKYYS5E7zhL2JOHOP3eYF+SHrjqPWiUEyJf39VFa7Yt0MmBrPFV/0408l9PDladwfPjdMEb9v0M9cIwQ3SX2pYtDmoHxrI3WW0bItQwjZDu7fbERapCo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(366004)(396003)(376002)(6486002)(52116002)(7696005)(4326008)(66556008)(66476007)(66946007)(6666004)(5660300002)(2906002)(83380400001)(86362001)(186003)(38350700002)(8676002)(4744005)(26005)(36756003)(2616005)(316002)(956004)(38100700002)(110136005)(103116003)(966005)(8936002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1lkWStCN0dqYnR0d2NJQ2VHd2tHSnZlc3YxZEhQUGFFV2FVSTZ6Y2JiWk03?=
 =?utf-8?B?TFBKc09zRHFldlZWOE12d2h4WmZtT2FxVGtobHFlV0lZSmVlc0t2L3dDKzdB?=
 =?utf-8?B?L2UrUUIzSi9HR2UxRjlOZWlFOUdRMVdqYTRzbjNPQU51VkdleEYzNXhabTJP?=
 =?utf-8?B?bEc3dkNVS1ByelFjRzdZWUJHMThTanNLMkhJY1REck9udWlmREdMV1JuVDJ0?=
 =?utf-8?B?N0FHVHFSKzJKcjgrVEhHbzBURVBibUU5MUF4T29aZlBZWUtxUW1Gem55WDNo?=
 =?utf-8?B?a3NZRFZJenpaaE54ckpiTmJ2S0xGWUtDN3dLYzhHL0w1SVpHSVBWckxLV2l5?=
 =?utf-8?B?YjdZaEs1NEEwYlVrTUdsU1M3ZmhzS2NEMUIySklNd3JtVG82VU5nWi8rZ21E?=
 =?utf-8?B?WGxzdlJ0TkNLdVRTN20rWGl6N3JtanFlOHdYSWdZNDhqbmxIKy9Cc3hVYlJi?=
 =?utf-8?B?OU1lNmkrbmVxUFRBS1BQSTJWTStDNE43WmFLZ1ZZVmwvdXBrZG5NNzdUVTZj?=
 =?utf-8?B?eVdlWTdaQzRGdnJQR2RBc1k5bnVNOUNaWmRuWlNjVFhXZGVHdm44Qmc5bTNi?=
 =?utf-8?B?V1o2aXRGd0FTeVBBb1U2TElibHZSMWwwU05GMFdlOWM0N2x1WnFwdVVSdHo2?=
 =?utf-8?B?V05mM3RjcEE0bVZDWmE3Mk53Si9wd1pwbGdyTFA2RUVNcGJEYmFreU85bk10?=
 =?utf-8?B?OXR3NG1WbVU2cWErY25wc2loSjQrMFFFYTYwRnZ2RWYvWWNMYzdBVkQ4MDRY?=
 =?utf-8?B?SENmMExqeXZ6NENUOFRTNEkzeHRCNThrQ2NqMGpzLzh0ckw5ZTM2dnh1QVdH?=
 =?utf-8?B?c2lnbnQ3VVBPUHJZNnJsbVIxS3hlSVI2c0JNdTUyNnhsUmRGcmFYV3VtbGRi?=
 =?utf-8?B?K0loM0ljQTNVME1xWEp5MUZMMTB1TW1vN2tCV2h4OWNxL3VuYzhTcUM5M1h0?=
 =?utf-8?B?dUk2bU8ybUhHTUphSGIwNDE1T2NHUjI1b1NCaENDVzR3bHROemc0UjV4azBP?=
 =?utf-8?B?bzFOeDZFUTFoSEJaVkIySVRqenA3NzczRUs2KzI0UVZtWXdXUS9BemV0WnBC?=
 =?utf-8?B?VlpBd25rQWdtaS9uc0RrUVdUS251NTU5d3N6b1JDcmlReEJoKzl1cTYySTlv?=
 =?utf-8?B?aTVYcnhabExFd0dvaHg4Z3lHRU9xNnJBQlZVTjRHdEtieEtxazlvT1NXOVE0?=
 =?utf-8?B?Vi9mUVdIN3ZHSUNjUXlHQ1hWdkpKMzBVQ2MrSVNQVzRNSHd1ZDhZRVVRN0k0?=
 =?utf-8?B?cU1HY25NWGxXcXIxZWxWdkJYT2VqZ2pXTURwM0hOVVB5eW9vTnF6Vis2U0Iw?=
 =?utf-8?B?Z1ZpZVY3bHBJc1JhRkQxZzVOdFJYS2VUVUJ1dUNRUnZmS0tDYTZxS2lhM0JC?=
 =?utf-8?B?eHE3ZkFpVWNWMTdxaS83TG9aNjhFNzVOL2diTzlPdmlZVDFweDZnOTRoZ21T?=
 =?utf-8?B?QWJoMkJ4VEloRy95d1ZCOHlxU2hHbEV0clNRV2p5cWNOcWxnYzlhWisrcVE0?=
 =?utf-8?B?bzZFVStwdGxCNkRpWHZqMGlMeDU0MHppSGRqYm00ZjBudjhtWC82RVA4TUdZ?=
 =?utf-8?B?WDVQMVVGVklvMGZMeENMV0s3MStEdGY5WXpxVmkyT0ZYbFdReHVCZUQvKy96?=
 =?utf-8?B?dVN3Z3ZQUlQxeGN4ZVE3eXFWaS9oNCtGYjNVRndjUXNrTWJBTDhraDZWUmp4?=
 =?utf-8?B?MWwvTmkzYU5TL2NVQUg2WURkQTRKWDQ1VllOY01YR1ZKUjh5VUhlMEdIeDJF?=
 =?utf-8?Q?0eLB+RFFjsFZdXXpObHtBfyU4TS4Sb1NLRqXZu4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e8e476a-47d5-4077-da06-08d9612d986a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 03:17:51.0169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rNKtQfhE3APVQIq4aavpIJGIMBrnVE+h4f3qmYYJV/xDfwYoFN4vB8XN0rg8j5dMkCe6mlYRP17xKRW89u+J7WhSA6t5O+y6jrVRFzPPQik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4566
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170019
X-Proofpoint-GUID: thoJX-qiEOFLZvE77cgjYJi9sgo4Y2No
X-Proofpoint-ORIG-GUID: thoJX-qiEOFLZvE77cgjYJi9sgo4Y2No
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 4 Aug 2021 15:33:19 +0100, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable rv is being initialized with a value that is never
> read, it is being updated later on. The assignment is redundant and
> can be removed.
> 
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: pm8001: Remove redundant initialization of variable rv
      https://git.kernel.org/mkp/scsi/c/83da6ad6f97e

-- 
Martin K. Petersen	Oracle Linux Engineering
