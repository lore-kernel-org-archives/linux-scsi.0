Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69180C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39AE96507E
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbhCPDPr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:15:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38912 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234783AbhCPDPT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:15:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G3AsqP075873;
        Tue, 16 Mar 2021 03:15:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=RXXt0MFJqHYrFSV1huIPLjP6UrVQ7+uvLnL6F/nphvI=;
 b=Ttf5nghcGNUC41CTAkY7NeC2Cag2GV92SopVH4vlv71lUtjnWXg9Bx/Sna4vJqFGR6o7
 TWUPItjggLvDK/SOEOlBoIXsbCJ3qnBtF+d1DFYToXxEJy/zSGQQ4I3u2aD9H8UvfjOn
 eZGgRPDU64Xdn3FVnhMOBtOmdPY9D3q2EKkAfQHBDTOeygZunnLR9Eg9+GDvfD/ZLGXA
 OSYXWcFcSmDpcOPztU3jNrRMXp0xCJEz8F4vXjgriGVZG+CnuXCpvAb4tIcKpnr3n/Sf
 CZpMQEgjeYBBVpWSDWSmUdBnBcVkFyBJFO3moJY7zrtFO3RLu58LxP4XKhxDwUwv9e3g oQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37a4ekk39r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:15:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G3BC3c139313;
        Tue, 16 Mar 2021 03:15:14 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by userp3020.oracle.com with ESMTP id 37a4esbqkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:15:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JwVC+4wDT6qWiOLXtchVv2OCSvE7/ynWkIojP2rD9F0jqtiZNygUV73uEwBrnb/cEvP0Ui6wSgpBn/lEnj4qwZtIQOUEzEndPjTEV3Z4sMoPGpm2D9cpVERA3cJp/SGaYnb1Ql6ZjgoAcDMAskRHuEumCan9x35xZZ5a3TGF1bsb0C28t4y9BJzlaYU43M0HhGiIDPzItITYD81d1TeOJvDg3bee3lLfND/HbeqlJPlfBy6asgB61z6pVDfpkCqpC/AmzWRrIl8jVN+2kUC6V82qNlp/sCEjw73VNnYGS85ys0ZSzbMfrP0UMnWiXI/pOzmT13clpbEnLuOR4e+lgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXXt0MFJqHYrFSV1huIPLjP6UrVQ7+uvLnL6F/nphvI=;
 b=mr8dGBI7zganxo7wdd2p1iU7oqyy7azkCIpoa8EPSWuqAVOKr1dTOxXXiUG87ZJrCCSCHWCPN/jOmK24EJbGfq90UZMBf7iBvPXDPF7hNlsy7ISceOxDQ8Qhvcn0LVYVRS9gZh17Edkch6wz6lCTLv2VXJucsR9358bJr2jUICUGWRpRMzOQsoVFtx2+K/GIOiqWCt8RlRG4TWsVgerF+3Pnj0bEXrbkoz0gpr+SVggStbHkYQPiu+d8nlMNv4kDEqL1W/dsGryzBoqVB3PwRu5hb06SU80k6P8wJWlZjCw+qYQufmVSPG76CayJ4I/qa4aMDBIzlNLKa0kwOlUe0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXXt0MFJqHYrFSV1huIPLjP6UrVQ7+uvLnL6F/nphvI=;
 b=BFALNeanu18VPJenYbnD8CJ/ikrt6208oOYxyY2lD/uuhsDuY5G5gCmKKA7qKbYrO3dqQ7kmBbZa6pFN6gmS1vDNSTQvca5tOahLjsGxrW+zkbPwIVRlQCiQO64BbUiewu3Kb6Eyy1Zg6PhXG6i6yRF/8nZTwNBmbQUOj97XRoI=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4709.namprd10.prod.outlook.com (2603:10b6:510:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 03:15:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 03:15:12 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Igor Pylypiv <ipylypiv@google.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Akshat Jain <akshatzen@google.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jolly Shah <jollys@google.com>
Subject: Re: [PATCH] scsi: pm80xx: Replace magic numbers with device state defines
Date:   Mon, 15 Mar 2021 23:14:56 -0400
Message-Id: <161586054343.25014.8148699334313075066.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210305060908.2476850-1-ipylypiv@google.com>
References: <20210305060908.2476850-1-ipylypiv@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: CY4PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:903:18::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by CY4PR02CA0012.namprd02.prod.outlook.com (2603:10b6:903:18::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Tue, 16 Mar 2021 03:15:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da503959-3748-4382-a0ca-08d8e829b649
X-MS-TrafficTypeDiagnostic: PH0PR10MB4709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB470911BBBA272C3B8619D54A8E6B9@PH0PR10MB4709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ZnL40tfC5AZcU0M+sIgnACg5Hp/Gz2sL4Cl9N0vZT5UkQRqKJQCWaCdwg53kyNFowPTivIFHFjiB6M49HtQ88n4mBha1XDgEvfEWOecUjtwkXt9/8by0OUlUrPjkKrucOQMsTt5JamBGGcQnuXYTni08HX955UCyYacL+ncFzA1P2zRRsF/NOujEW0YBJVNUtPp2IiN2vTwUXgPTNEOUeQPc84YEPZ40GKolHUX7P3NEL+FX9LOhEia2pv9k1Jw/MG3u4AtJ31VnRLnecGgV5vDH3VGE9cEIgwGq/O9swJX1WjniUrVxxCPGy//QC+aN5zwr42AJcVimrZmGXkUr1/6puSW6/qUEwwcbJfPx9wjodlXTtYfqZIEAvqMKrVHUiogMc91gsEAcPaDGdIU7nykFr8phkWbVRxnDj+DBOwsBiT0K27btXbW4EHWsEblkNc2qKLg6OKNPwcX3nPnEa6oR42mq3MOmzEfjoj1ECjR9QtUfKJgRBHZfH5zAyJLApV739Z/t787uhuuorFDHzUFb1px+N7M8eJxRTdPj9pEVkWceU/n48KgSG+hbCTh2qklwnMV4VuWjt5kv4r70xES6J0md3u+z2FJCZnbRD+OKzba2OAE84cS263Qj3is
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(558084003)(2616005)(26005)(478600001)(956004)(4326008)(6486002)(186003)(66946007)(103116003)(316002)(110136005)(5660300002)(966005)(8936002)(86362001)(8676002)(16526019)(6666004)(2906002)(36756003)(7696005)(52116002)(54906003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dGpSYjVxYS9lNjZpdjUxYzZOT2Y2elFYVVV6ZnhSZm93eXd4c3pLdTlId0FP?=
 =?utf-8?B?QjJNQldma2FTQmJ5SE1tVmlQN1UyMXdiM0hqaHFrWmZCcUk3MVU2clkxazNI?=
 =?utf-8?B?TDlFcDFDRVNyRkdtYUFaSlh6aVcrOUZUdGxvVng1OHpCY0NHQVFsTElmRFd1?=
 =?utf-8?B?d1gvUE92Zys0aDVHdFZROEtQWVFVUWhleExDWlIzdjF6cmIvdWtHeTVLSFg0?=
 =?utf-8?B?QmRuaUM5elJIYnlXdElJaU8rQ2lNUDhsTFNLazN0NlFaMG04UWNKN1RRbzNn?=
 =?utf-8?B?RG9hUjZuUXVQTzU4N0xsenFvczByTlZ0K3EzUHhPdmRhZlh3S0NLdUtQemw5?=
 =?utf-8?B?NGxHeTI3c0RqUkh1MGpNYzF0REtNUGgwNWFaNWFUUGpEVmNGa0ZFZ0l2eWl2?=
 =?utf-8?B?eXozOWx6dHBoZUxQNExkclJqckdualFUM3lSd2xoZ203THo3ckcvT05LWHNL?=
 =?utf-8?B?cHFkN3pVcHI5UWQxcVpwQk1ROTZoNklNN3dpZmQvUDgwOENKbk0rS2xuRGpp?=
 =?utf-8?B?MUg0R01GckFzL2p4ZVVaVHJBelI5YXJGOHN1MDViY3FQZ3M0ZzROcGpINC9Q?=
 =?utf-8?B?WUtqUzAydkhVbnBLQlNwSEFwaDU2MWFubEtaMzh4elpCYTBhZ3pmckNTUmhP?=
 =?utf-8?B?TDhNZmFqTmhnUWFtemdKMnd4Znlja2J0NW1yK1FaazEwckxza29OZWo2QWh5?=
 =?utf-8?B?OHQvNHlrZUJPc0JNS2t3dnYrVXk3OG90R0lvNGh4b05SdHl4UHZDZTZkZDVl?=
 =?utf-8?B?ZzhJWFVMLzJZbTIwZnNrbGhjd3BuYjJCZktTaVZVQTJ2NnJvbEd3dVZoNEsw?=
 =?utf-8?B?R3AzbkhFZlpESEN3c0ZyVlNuQ2xFNkZDTVh2UnNOeUJRN1c4WjJXQXBiZ1NQ?=
 =?utf-8?B?eGVmeG1WcEp5SXRLTzBhRFc4KzZNSlRKbnBZTjRyNnRoWlNGQkdDa0w0bjNC?=
 =?utf-8?B?Z2NnbHFsNTJjK3Axb2ZUeTZtd041WWg2TkxuYkZvbmJxVkhlY3ZsVU9kQWFX?=
 =?utf-8?B?c0l6cUlqeVdsTVJYdkN5R1VQakwyK3EwbFdrYXA3bldveHFSeG1DWDVCK2dt?=
 =?utf-8?B?NVR2anQrMjRGUmxQMlZnUG1maFRUaERWcjRnSlcyZGRvNkdUWFBTTWlqWldj?=
 =?utf-8?B?dWxSZHRzRFVwZWR4SXZ1RStZTkF2QWRJUVhjemNINEZUZE1kdHZtZFVWMDZ0?=
 =?utf-8?B?WFJpRTVteDQxUEd1MDdYNmNtcHVUNnNwUHFNSzVRTDlJaEVDdVAybCt3OHBE?=
 =?utf-8?B?UlRLQktleTRPZk8zM0wvTCtvQmFYejgyRWd2UmZBaHlkYk9raHpaSC9WMzNi?=
 =?utf-8?B?NkNUUTByRWNaeVhhYkFsdUhsdlByVnhJQnZMQmxUdGZmNVI5MVk2TmxwRkNU?=
 =?utf-8?B?a1hhN2xnRHhFcVhJUi9oM3FoM21EY1hSeVl2a0ZGaVZ5YkRiUVhqWklnNlpZ?=
 =?utf-8?B?Sk9UbWZSZzQzZm5pT2dJNjg1WnNmNWpNNlprWVhpRzVvbmpqdU95cGFGblRU?=
 =?utf-8?B?VTlKMmM0cEp3VFJyWURuTDdYVEVFcTVKOHlDNzNZbGF6V1d4T0pWL3hZU2JL?=
 =?utf-8?B?MXZ2TnNlRXRTRGw0b1VzTytMOVpIeXFCT0dmOHZ6SW1IbGcrQjcydm5Ub2NC?=
 =?utf-8?B?bzU2U05mR1ZhcnBkeWp6OVZRbVZQWHB3KzVTYzlOVDhTYVNMQTVQZGFnYVVN?=
 =?utf-8?B?QkNnVkswQWQxOWxJeTFGRkJhTmVwTjNJV05Yd21pMjJCeGxLc3l6TEUvQWY2?=
 =?utf-8?Q?2VUA9FqSyqWGCona/r1UKCtGPog53JLHMz9x4b5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da503959-3748-4382-a0ca-08d8e829b649
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 03:15:12.4717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6oAhrw/Ea9NLp5gux7FxQXTuvwd9Zb8WqGGWsvO9YcCYr1216nA3f8CN+qtVfQYNzZW3yQrbLekjDjad3FIHxxouusOujbuYshHeoMq7v60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=875
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160021
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 4 Mar 2021 22:09:08 -0800, Igor Pylypiv wrote:

> This improves the code readability.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: pm80xx: Replace magic numbers with device state defines
      https://git.kernel.org/mkp/scsi/c/9ec3d4c10565

-- 
Martin K. Petersen	Oracle Linux Engineering
