Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D55C4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4CD760FA0
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236860AbhHQDVF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:21:05 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:45070 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234014AbhHQDVC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 23:21:02 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H3Bul9024620;
        Tue, 17 Aug 2021 03:20:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Q9lERc0OMj/WVL8cFUGkbES3/q1IvSsAZpBMxrSLH5Y=;
 b=qu0t4Z6FYRkYLW0tDvj593uwcYMkOhmFXzgJzQ+NVxybBkgI+5MPg0ahAM7fAWAenXPC
 V+SprzDrrsQUvNdphpIoovCddGjVGk57aeSdUFDD8vLMB9tycQ3i3hbJgXEv9w+zLbGb
 rBAz3/ovtExgr1+NttjKBhAOM8HPV0HhL629eSF8+p9ZwhRn62i3wyxnZDUlLAjigmOd
 bSVLIrOwPbePG7g8zNf79lvjvjpc5xTOcarwjQwMCmX6Nnj8Eo4Iijde9Ljez7w1PI1R
 /69fzRhIFUD05b6GTaznF/rV5Zu1KSkfdOqrUV2pQhR69Ywjgxh5JBUOjWWsyCuql8Ba gg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Q9lERc0OMj/WVL8cFUGkbES3/q1IvSsAZpBMxrSLH5Y=;
 b=cL1vwDua/NRiUKwYsyUe6G5XyIYgT3ZQfi+Lbosn12cIsVo+Homek0t1FBt70w88rhh0
 sq0vnlHbmxl9MbhQXeaDqR6btOLs4/gtwPoGzCNTiXwd/mOMNi6Y6x8r0XzJJdjVpg/d
 HHFsYKgceGzg165mC7OVT7zQjO49i44kt0lhGQpnfbJRGEiIOib9zAZlzkeJrtf9h1mn
 kat2kNScAUjGfsPbD9qOl6vf48/+mvPy/Grsx2muYlscFRbKCJ/lR49AqzVomFxDzLTT
 GLGSgJnHmiI8iCj+NPzheyNOZEn2cuYHeOaz3gDjcnY+ThiyQnvsOMV9PNxHy2YxRxqq IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afdbd2y6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:20:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H3AxEP092022;
        Tue, 17 Aug 2021 03:20:26 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by userp3030.oracle.com with ESMTP id 3ae2xyaaa6-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:20:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0WK78cF067NFv9bJlP8Lj4Ul8WcpTMu2yvV/jXdlTTOvhgluVQd/TIBB1PYLECGPlhV0b5epjru/mDQip1/+RoaX6hPlKyetddQCP+6eI19293WnHEk5sRF/yGJUZDcZHy/igfZVsvNOQpK9jyPcUwTjVhv6hth5PMNC0kKSfELK0O6bGBPTb/WOP/NVVBoW4yLjUmiWhDn2mP6pcvFL4nKmcDbQIFlq8NjDBaNGvjZXhm2Gjf6AN+88Di+mXT8fGFuSsU80qORnvrVh8mqVPhJq5i+yY+BxxWHRu7HvaPXf6mWbzO8NuBdNVr5Y8j9/PaUj/XKdhHCCDWZOXW70g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q9lERc0OMj/WVL8cFUGkbES3/q1IvSsAZpBMxrSLH5Y=;
 b=hHa0jweITWP34QVb25RJGSpIwgODXZTGHIIeJq0n1t5hYO1yCJrUAAxPIpSz5tXUA/Gey54ni01k7uVf93N65ZYCpV+fyjd5hQLfufP0Mp46vJrWqWWChdc5wKmsplsGlm4tGWn1LySSkaZEyA53pDAI5fFqegugr6AhXr6R/W1o7eww/9RXYXER/TGGWQLZ1Ko1STViNw0ARUoZgHqEiYP4qMkrYd1p+ooWKbP3aqeSye38rHnJweLUXOzz7D6E/cW3xIRdfrldXHC7XGEmkmz5OAFbsZbpjY3zWAxoulrVo6j05A/Jh/JSOKQJsD+tz74NTuaUq/PQT5BUvqLmtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q9lERc0OMj/WVL8cFUGkbES3/q1IvSsAZpBMxrSLH5Y=;
 b=fpmm/EV3WFgf67KdWyE+0kaaX43rA5PjpiGdHyxhIjEGgbCtRGFfriBzjuB+E/DSPakWEsl6o5CzSBL+nGYwZhFb+RvVGaoVnTscwboCMgvioDNVP6ZxuR2LsncA31h8KxNW65lIMRUDCRkjpN0CI0t6noznHK4rKJrwrU0U83A=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 03:20:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 03:20:24 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sreekanth.reddy@broadcom.com, Sathya.Prakash@broadcom.com
Subject: Re: [PATCH 0/2] mpt3sas: Use Firmware Recommended Queue Depth.
Date:   Mon, 16 Aug 2021 23:20:20 -0400
Message-Id: <162917038628.25399.2240387256139371060.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809072639.21228-1-suganath-prabu.subramani@broadcom.com>
References: <20210809072639.21228-1-suganath-prabu.subramani@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0201CA0015.namprd02.prod.outlook.com
 (2603:10b6:803:2b::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0201CA0015.namprd02.prod.outlook.com (2603:10b6:803:2b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Tue, 17 Aug 2021 03:20:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 262a8ad3-255a-4e28-eec0-08d9612df401
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4597D71CB20FB943A4D362678EFE9@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vvsjdigol2oj4MDrJzbn75HJltPYOrEHsOfleOazjQ+/Vx4DNq+2AiW5YLQoXhF1j4bcljYQ+uzDHiq+obcbmUiWrkahaBJnWgJYTEj7JvJDB4YISSXnd3n9f3oOs8Y/csKbzI1YP/2KGoDfQ4RsuYNlPxwmnK7AyqKfyTxqksANkXNdrayfR76T3xMTg36Q8EADHvMEov1/jL3xaFV9KwBTOpE+s9VIpthxf55jSkX78CMVp1TRayUtNZIxExLRHF62sNMkAs+viNHv/BLIzQjoZtNRVAvMNGvRaeO9teWWC5lUeFpAOJ15zVbLRJxBbwDyNcpOXgaS4/yT8A2eIh3V1jd8cXbYQ78g7E1REBZw31DzbuDCMJeMppp2SkMEQdrrH5UcRKDjVzIYiLomVAwh3ykJGua0xkdfxjZxwFPbyUqalwZFPfPv/CKBJ6DGDpvY33dOfEE7r5ZY6ObrI8/YjnyyxWBQ576ngwkSchC4KXJCTVJVMkR90SX/CGeVWvBmocgHbex+DjnxwHLB3CfsrGOAuab3nk+mcgPf9sjntKC3VaZq3cmB7fOWKOV2lz03ELnH42qGfH0NycuIDl6GHo2KIrxOfSPNtU5IEZ002iHZ7JUSoPLg2gDgmaxdaY/EVLMR+xS2RpysJYDhqus9d4oYzL87IM2GhcctbBkTGYDPC5ujWd/wetFhndRyIGzEsmZnuBcTrCuxXEQclU/w49m36jB0triGJ1nL81ZuS0sSTUUNIGVmHGTUjGzeiVUyf71yAFCPrApq2KJPKj8w+iEp92Jg1BJHu8razDmiXa/THwK7jxyE6rjDiSoQRTQG3jS1LTBkZsL4utvusZdALaIfejysla9zHvif2tM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(38350700002)(38100700002)(66476007)(2616005)(316002)(66946007)(8676002)(956004)(26005)(6666004)(86362001)(6486002)(83380400001)(66556008)(508600001)(4326008)(5660300002)(2906002)(103116003)(966005)(52116002)(186003)(7696005)(8936002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z1J6Zm15bWY5RmZ6V1RUZVFrMVFrd3BmQnczL1hRN0RaVVo2enJWdHQrcTZ6?=
 =?utf-8?B?ZGFqMytVNFNaMTFkMEtZdE5paDE4VnAvaEFYWCtKbm9sM2RNcERjZEFVRWF2?=
 =?utf-8?B?OFdzQ3NmbWFGWEpDZGJjMmNreTIvVFY4bjlxeWpXcjFWVGJsUEZVV0RRd0Ey?=
 =?utf-8?B?RnAwVFgvSGREbVcwNkZoRUJ5SG9yK2VpQW5lQ21idVNkS1YxRkZocWpJbUJX?=
 =?utf-8?B?K2U3RUJ3SytHTndqcnpVTzZIcEo5QnFselQ1V2Q0VEROL0lGY1JPRFRzUEox?=
 =?utf-8?B?Nlprd1VrOTJEbGJ3MXRUREl5bEdwcG8wUFlheDRXZElXc3ZmYk5mdk16U2t5?=
 =?utf-8?B?dllKajEzNTU1dWhqSElnemI2UDNRS0hBYUpKOWFhblBqV0FvY1BQaXdmaTQ5?=
 =?utf-8?B?WDBlbW5mWk14UWdoNS9scmNsWU9wWlk5WmU4TjZ4QlJxVTh2MG1jYTM3TUZN?=
 =?utf-8?B?UTdaTzZBR1Fpdjd1UnE4V0hZbEcyUUhJU0tEVURUOVk0ZFp6b01EdzlZcGFP?=
 =?utf-8?B?WGs4MjA2bFE1ekpEdXVVQXI4MEorSzRXWTZyL0drUDJFbFJYOWZHM05id0FF?=
 =?utf-8?B?Znk4ZzV0M3k4aEdQN2I4MTFtNHhtRXRyTzBjVDhQaEVaMFJ0VXNtSjEvemNW?=
 =?utf-8?B?S0ZjU2NIbTJpZ2dORVBVeDZDeE83K251YUltcmdoVVpweFJJdlQ1VExKNlVY?=
 =?utf-8?B?NzhnbzFoSDdFRTB0ejlnRXd5cExWQ2wwSWdaWC9MeFZuL2VyQkwwcXNtenJl?=
 =?utf-8?B?RklQNGxMWVdGUWR5VXZhamgzdmF3all6ZStNM0JMU3o4SmxIQ2wyQTZocEJR?=
 =?utf-8?B?K3AzNHJjN1J6ZzZYOElYa1I1T1Z2S25LakEzTnl0c1ZpUjd2WWZ3dUNLTUNB?=
 =?utf-8?B?YXdhcS9YUnJKWU5tYnY3N08vRGFLSGdRbFZSd0pxc3FYSkpQQzgyOVBzd3FL?=
 =?utf-8?B?MUVTcS96QnhZM0dINFRGUm8zbnZlZFJEenhGZTAyeHVYa3BvY0poREVGTFBn?=
 =?utf-8?B?UENaY2dncnpFVjZNelJaa1pQWk9OcWQranA3b0RXWTB3Mk8yZzlnWXRMbWlZ?=
 =?utf-8?B?SGdhcW1acThLWmpqa1h2c1hGdjFSalhZdFZwZHRsUWt2YVRHWXBSYm5acnZI?=
 =?utf-8?B?aGgyTzhiMTgrYlZ2S0l1UUFTM09wbnhKK3pGb0hnaTBvbmExWGJDcGZxMlpq?=
 =?utf-8?B?NUtycjdEQXFUUHQ5bmhPdndtMnd4WGIyNE1QaWltVDdxZUt1Sy90TktvT0V1?=
 =?utf-8?B?SFNJcDhNbjZJRUpYTnpqbWtMZHV2QnAwdnhkbXpLL1ZoV1JoQi9OcVhlVzhY?=
 =?utf-8?B?SlZGTFN0U0JyN1RTVitsRkpNRzNYY2JhZm5tNU0xdDRQKzJqclYxQzd0RktT?=
 =?utf-8?B?N2lRbUd3NGxDN3E2WjR3MlM5OWhQSk4wcVVvaSttQ2kwRDVxdTF1V1dPUWgz?=
 =?utf-8?B?eXEwZFRnMk9SVmxCZEJPS0k0QUVJR1pqV08zU2tNVDViQjUrK3BkaG80Z2c5?=
 =?utf-8?B?MEp6UkViaGdKMWdQUkZHQzhkRkNhdktrcEVZa1YxdFE3SFVPSHI3TVRNTkJC?=
 =?utf-8?B?S1lzeFFReGNaamdiTHRjMzliNHBHSHlDM3crdHlpMThGd1pzckxHcTA4ZW14?=
 =?utf-8?B?NDlSSTlLSVBqQU1CT2g0V0ttMDhsZEkwQ3F0dWlzWWFDSGFNeVROMDF4TlY5?=
 =?utf-8?B?OXc1eUQ1WHV6MjhEZUZNbFpXZFNGbjRGZEJkRExPeTh2R25Fa2FzUk1PRWhR?=
 =?utf-8?Q?sWPQa4Z0IIGZXtVoJfeNHnm3gv1DWtQLqPfjjUH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 262a8ad3-255a-4e28-eec0-08d9612df401
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 03:20:24.6717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YFh/Ha1j3zcKHalaPA3kHVqOYWbnZ+wcVVDh7XmMwY/ZeZATdEKQI9bsJ4Hq1djeaT0LiB8kmG7vO9cXcP3ZsHEiAE0iwbaqAmI8a+0LukY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=828 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170019
X-Proofpoint-ORIG-GUID: R-fMqIeTGhxNSa_aP5JgbB1JU1GPB0PQ
X-Proofpoint-GUID: R-fMqIeTGhxNSa_aP5JgbB1JU1GPB0PQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 9 Aug 2021 12:56:37 +0530, Suganath Prabu S wrote:

> Currently mpt3sas driver sets below predefined queue depth for the
> SAS/SATA/NVMe drives.
> SAS	-  254
> SATA	-  32
> NVME	-  128
> IOC Firmware provides the queue depth for each device types through SAS
> IO Unit Page1 for SAS/SATA and PCIe IO Unit Page1 for NVMe devices. If
> the host sets the queue depth greater than the firmware recommended
> queue depth, then IOC places the IO’s above the recommended queue depth
> in an internal pending queue (consuming outstanding
> host-credit/resources and thereby leading to potential starvation to
> other devices) and sends them to the device once IO count drops below
> the recommended queue depth. So, it is better for the driver to set
> the device queue depth provided by the IOC firmware.
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/2] mpt3sas: Use FW recommended device QD
      https://git.kernel.org/mkp/scsi/c/787f2448c236
[2/2] mpt3sas: Update driver version to 39.100.00.00
      https://git.kernel.org/mkp/scsi/c/cdc1767698a2

-- 
Martin K. Petersen	Oracle Linux Engineering
