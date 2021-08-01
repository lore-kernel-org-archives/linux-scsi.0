Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 863C7C432BE
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Aug 2021 18:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CE37610A1
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Aug 2021 18:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhHASth (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Aug 2021 14:49:37 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:43634 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229497AbhHAStg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Aug 2021 14:49:36 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 171Ignbb016789;
        Sun, 1 Aug 2021 18:49:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=tphdLTPJvZMvx+E+OLwejscmXCNnjC95go1jpJSMD40=;
 b=XK/ip/4l4p9JU3K3KA/Gum6xY9Z9MI3MGE4Gl0lerL2tdWMosyDmhIpcn99fh47ws79g
 yudrVu0jzW4CfOesQKX1ZMpLoTNJaT6PNIEI2McbRuvliKsxNqcXabESTRklzrxJlXWo
 CuPcAsrXFIgogXv3voumMmlzah5uQ+eYDx0H9l/dKEzPV5cvMfENNGaTrvgtWdffQK96
 r7GCkBzaEf/pTYuyUM9XcVA1orsM3og2w3IDTo3jMTbLaaOTB6+G0NbwE+irhjlBEEzq
 /2e3i/FSCtC6qtl4BoTV0kCox6rZ7NeWbYluwdQpB12azwREUWGGl4Zi+cZza7juqept PA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=tphdLTPJvZMvx+E+OLwejscmXCNnjC95go1jpJSMD40=;
 b=Zh4cuXV20c+OVEVq4Ojul2HeutGb2eorTB84NHJZAh2VchSCcfzqjlfNv1ntAF50N+Fi
 wfs8o5bYq4tOzlrOQxSdK/m1dNQqLSGvGXwJEW21a99CJJd9Bxa4PQOERJR6YUc7gkQe
 Hr9DvVic5iUaGJ1tEiDtaOzxKaSwW0sBCy2JGq5AvqqT5RPwk77cpSQFSqFgsReCJzLj
 ElJZwCHuyfZN63Q3ywDgF3td4o6pQO2vcZMzsiA6mTrCXmZD7gHvbjBGBaUy8yK9WnYi
 IrmqtmDCyaRLqd3DeCKQOyIe3d5VfjfRDk56kE+mJOwIhZBJrV006vSwgQU5yQG9wsd+ Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a4xdahpwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Aug 2021 18:49:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 171If8SN019793;
        Sun, 1 Aug 2021 18:49:25 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3020.oracle.com with ESMTP id 3a5g9ru1u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Aug 2021 18:49:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dk4PZM/r9U3PhQyv6PTTqJUepiae8KyJsNkQT1E8Sch4SxxH8vG41V9qEdepTh8Js27hsLMSNHlBuT1u2uEtE9snpTqfe79tXJExZC8d2tck4oymdyztRPsHbRFW6Q6M1evZZaE94idZuPLEYdJwu60Bg3AS6pB4KRigPjps4ancaDwR2cWpBFOybf/oH2wIrElZbLpCibRz7mC36+SznypKnoohOzZaRbrClX+2qDC98MwZh0S5v/G31CIUlHIDs55cTGzRm5/siA10f1sOvMv0ocDxje0To5eP+HAprYQyLXbtC2wq+Glpr0XYfGukHnDgd+kEThrgBb+1hdHB4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tphdLTPJvZMvx+E+OLwejscmXCNnjC95go1jpJSMD40=;
 b=kMIlcQasci7JCbWPjrl2KTkv6aSdmqI3/ZWhTuzGvA70zR2zkQL6C6VcsY5NM94b9Jf0v/1Af3XeP8dIDvB7gE3VMh6QEQmnapyALr1drFzq+CnOi/FAPxXuQEucQOhulQjMnMfnu1DKCFdwy8+far8UlNXyidGjMWYMD81GTLgdqbqp4sy3Sl8BclJKKk29DuGGj7mFQ3irptp2Ra5gFBgqvLBITv/a+9gUIb3iUCKaEvztWc1N7W01nMm7uzX4BiL97lP7xeDdWgK4kqA8V4D1mlv6+RawJ7u4gSFf1hbPyBHP2x8I0EfitTv3Bubbev5jfmyX6Kyr38g6D+D9+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tphdLTPJvZMvx+E+OLwejscmXCNnjC95go1jpJSMD40=;
 b=nzBhXLJIfqEla0yh5NYz9e4wLhCmYRHPAOPbTD4Dz4lcTM1L/7dp35XgaaTOWv1JUfwFkn6dskmbuM1TY7HZZEaKMAtszgVvuMoSIWg9cJlWdBVt5z7xCsrWpNRByh/vbvxAS/cgoi//+YSxh6Y/GJl6pfrnK8SeezSHUiO1w5Y=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3128.namprd10.prod.outlook.com (2603:10b6:a03:14e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Sun, 1 Aug
 2021 18:49:22 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5cdf:33ab:8d17:9708]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5cdf:33ab:8d17:9708%7]) with mapi id 15.20.4373.026; Sun, 1 Aug 2021
 18:49:22 +0000
Subject: Re: [Resend PATCH v4] scsi: target: tcmu: Add new feature KEEP_BUF
To:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20210713175021.20103-1-bostroesser@gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <1ace896d-5a3f-4f20-5b79-1907805097d4@oracle.com>
Date:   Sun, 1 Aug 2021 13:49:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210713175021.20103-1-bostroesser@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR12CA0059.namprd12.prod.outlook.com
 (2603:10b6:3:103::21) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM5PR12CA0059.namprd12.prod.outlook.com (2603:10b6:3:103::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend Transport; Sun, 1 Aug 2021 18:49:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f0ae849-a1f5-460f-cd10-08d9551d13c9
X-MS-TrafficTypeDiagnostic: BYAPR10MB3128:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB312806C8A641E2EE738F9E84F1EE9@BYAPR10MB3128.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x67LIs2xotB1B0J4mYuLH7//vku+wIhfBW8LICu6NS+j4/uiN7cVNHDu7h1U2Y0iafX3LTgVqkHaxr/U3rbPbrUNnKRiOdcVe4I3qtNtFBGU96UVGXguf6gIW/igBPlXnUEGk1unzx+jVSxbPicGV774bBAEMTQKej3cB0eKXnZqw+Rk1cSC9X5QmD7pLgfuvroZ9KOEfh+vTD6E+azj/5ZHgZqelDwoIS0m8+d7JjYaBu078zQS0/73XhhXPToKnRM47JSjozM5zsfmnW5pZB3SRsudq7bIFGXYqePBeeu6sqXexc9qC1qz8lED4LLZef9HujI1izzppSZoTr1eCpKbsTRVUivH3fTbBhIoL70A8YsYX7pY7HfQJIVgmSW+SCplbHpH9pZQOtUAirVPvkwCy3qA3lc7jhC5VawGhohHdTG8cgVsW2ErZsqQOcj1ZR//g6Zm6F/nMptP7RsjDSVOPTz8Zqc4n5JyhQUuhFGFUS20cE9H7XSrtUjhf9CR570tDOtq57JuAu4j7qHTTkUj4Tu4djLIgWIfWikYulVtWzhpIRb4avOlzaXDqDgg8DvYA10cZ3uirSbEZG1oOtXh0zIAe/qyJQySM1XsbWe5wbFqaCkMzhQCz8LMmSME2fWq21CxIrQSmhF1OZduJRDa5sjp5yFzJVnkeOAa4EpBTujJyN+mlfvyG/UL02wcHmnQ003S4+LcjSNS8kPn4yOR9d32qyXRvBzqi/TUUiTNZSwT0PO4+fipfMSzy1My
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6706004)(956004)(83380400001)(2616005)(110136005)(6636002)(31696002)(4744005)(86362001)(5660300002)(38100700002)(186003)(26005)(316002)(31686004)(508600001)(53546011)(66476007)(66556008)(2906002)(16576012)(36756003)(8676002)(6486002)(66946007)(8936002)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGpHNU1HOHlmNTB0dHhIQUc1T05RUEpPNmMwZ1JWOHVVT25ZbW5nQVYwb2Jq?=
 =?utf-8?B?MEszU0YrQk5NTGpkMDZsSVlJOWRsZjlnLzFRZ3lwM0Uvb3QvQVpLcnVQNVc5?=
 =?utf-8?B?K3dqWVpmeEM4K0VoZ1FWTGlBZ1BScm1VVVE0WXZia2o3NUN5NCtlMkFzbXVs?=
 =?utf-8?B?RlhENVU3MTNLQjVTMVBnMzk1VmNHNjZwTktIQUJjVWJkdnVDamZiMVV0OVVk?=
 =?utf-8?B?cG02bTNzRlZ3alVqWU9adUNFOFEzM0FFYXNZL1JJZjErT3o3aG5mTklGdXNy?=
 =?utf-8?B?L2ZsTTlWWDNNWmlVditBTDRWTHFmVHFiTTRpTnhkN3ZhVU5Pck95SU10L3Vm?=
 =?utf-8?B?NmQ1bVlRdWh0dnhHeWNXeVlpL3RXNVhJZ2dZSU5OUlJJUnM2Q0pwV0RFc1Vi?=
 =?utf-8?B?cEVCOFhWWnJpa1dKSGRmR2d6TmJaRkVJbmZPYndYYVhObm8vOTBFQXJPSTgv?=
 =?utf-8?B?bE5weEhpRGVIMmQ5cnF6UWp4QmVkNnhnek1ucnRQTUFkVUcrUFhWQUcyNE1B?=
 =?utf-8?B?b3R3MWNwSW1EcExFbFJSWE1ibGpZaDlvOXZkenA4MS9ZN1Bjbis4ampOa1hT?=
 =?utf-8?B?RUpISXRCbEc4Y2tKZzVCZXIzR2ZhZ053ajJxemU3MDE0T0lCWTRHN0pMZGs3?=
 =?utf-8?B?SXdIcWoyWE01WExRYUpwczdkaFZpVzdpL2I2dUllV1RrR1B6bXJySlN0a1VM?=
 =?utf-8?B?d21NZVU0K1BVeDJ4eGRSUE5pTjRtYjhlNEg5a0g2aEFYZjVSWGN0blQ4QVk5?=
 =?utf-8?B?WldJZmt1U01qZ2laY0VoaEcycjRUOXVGWUlIRnZ3SWoxOUtaYUo1a3F3eGFr?=
 =?utf-8?B?cXlLZDNBa01YZ0ZYdmVHVWEwb01FYzVITGV1QmpnZ2p5VkE3d3BhT3pyT2Q1?=
 =?utf-8?B?emRCLzF1QlJUR3JhU1BUTEhGQWpsZXM3QXBQYXNKVmhrNFh6RUdBUmY4aE9V?=
 =?utf-8?B?THlORE1JaXVXOHpTdmZ2Zit2c0RFZGRwbGxKSXkyb3dFRVhIdzZFQ0VLOWxx?=
 =?utf-8?B?TUovS2IySWg1YUVTenJTVlh2d0Q2RHhOM0lSdGFUWjErSUEvc2dnZmE5bXla?=
 =?utf-8?B?Tm5pU21zbVk1TlA3OG9UbnE1U2hkKzI3WU5kSk1YOHV5alR1Q0w5UTFiR2Fm?=
 =?utf-8?B?TkE1ZXFqVnJUeDJKN01yQkJEVTBCamkrTEJsWkxBRlBXODdvelREN0tSUHZp?=
 =?utf-8?B?dWNFNDkxMmVhQ1llRVBlK1BKUWJKWjFJWE9JNEwxTEVralQ3TkdoSzhQbVlx?=
 =?utf-8?B?M08vUHRwM2pBTmdVc2NMOUVDT2NFQnU3aHJRbXIzdEgxSUFzRTRqaHdJMEdw?=
 =?utf-8?B?YjAxZ3NiNUdmSlZEbEhPTm5uVmErNUtEc2JFS1k1cUZ2azB0VXJtYWI3MlRZ?=
 =?utf-8?B?UytXVk9TVXVVQitIU2pZelhEV1o4ek5YQVF3VHBrUUNXcFl2Ym9TRFNrU3pR?=
 =?utf-8?B?aFZzdDl3Unc4SzBFT0VOUTVOYmw0aVEwZW56T2ZsQlpSbUY5MFdWVjNrelBy?=
 =?utf-8?B?Rk9lbXZTUHlnUEdsWEE5WHpPVWhTRkJNc3RTUHFTSkxUdU8xVTFWWnpTMm9t?=
 =?utf-8?B?WmhFVzV0WnB4NlMrdzNEZEx4bUpWVENWckNwb1B5NFh1QTE0dFBCdU15MXFE?=
 =?utf-8?B?Z3RLYUtxY2hOZTFidTVET3ZEbVUwNVNvTitrZHdWYmVEeFEzWE16YVhYcVgw?=
 =?utf-8?B?eEdFWFJoVnhuOXlHa1pJZXBHV0tFTVpaeTZWKzBkRTlBSUVUMHIwdE1OWVpB?=
 =?utf-8?Q?YXQUjiXzZRQwa8TiRQWamgiH78w7A+iDSapgvzd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f0ae849-a1f5-460f-cd10-08d9551d13c9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2021 18:49:22.6529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oo0tT51L8VbDo0QMI+qOtaPzpP/9mwtnq/ZSZhzqphAw6IwtdvwFvnYpwqxeh74uerS43K6hkvGB2NBat/7xO/h+cfsyMAt79y9WcrRnTuc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3128
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10062 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108010133
X-Proofpoint-GUID: IoTegBUehcmBDVcLv2s6GfZ_V3iywbsD
X-Proofpoint-ORIG-GUID: IoTegBUehcmBDVcLv2s6GfZ_V3iywbsD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/21 12:50 PM, Bodo Stroesser wrote:
> When running command pipelining for WRITE direction commands,
> (e.g. tape device write) userspace sends cmd completion to cmd
> ring before processing write data. In that case userspace has to
> copy data before sending completion, because cmd completion also
> implicitly releases the data buffer in data area.
> 
> The new feature KEEP_BUF allows userspace to optionally keep the
> buffer after completion by setting new bit TCMU_UFLAG_KEEP_BUF in
> tcmu_cmd_entry_hdr->uflags. In that case buffer has to be released
> explicitly by writing the cmd_id to new action item free_kept_buf.
> 
> All kept buffers are released during reset_ring and if userspace
> closes uio device (tcmu_release).
> 
> Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>

Reviewed-by: Mike Christie <michael.christie@oracle.com>

