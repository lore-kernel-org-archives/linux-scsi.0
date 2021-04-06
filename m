Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C9BCC43460
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11454613B8
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243689AbhDFExz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 00:53:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44256 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243680AbhDFExz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 00:53:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364oKt7161733;
        Tue, 6 Apr 2021 04:53:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=RKKSrED3K2jBYzuqteygB9kKW/thCmmOxdDgxl28gug=;
 b=FaF3tUqfTZd+hFPubpFGI0AjOvnHtAMj4ZMn00dByNPZf7/A2xzuuM2RcIjrfzFPmQNL
 Rv1i0S6DEedsPqE/xdQcXORKEo6BbsHxAnJbNgzv8+oiUgZ3xM1ABEO/GZTeh4voAGym
 3PBaumKhjf3HZSi0X5U4G8OxzZ9LPwI4J4I2PHELPyn0sZoIlCsf8fwx57MycOk4M0at
 8GqpYCbT5UetyO713FCtn2BysQ4atdoXVxdQIiZP0/wM/pHcxMU4DWM77hzAG6givRZK
 p1Nk4lLteClA3JSSUv5fbFLkbPo0k3xD8ZkpV1xyimx2we4BUf24Y8zO66118UxmD3Hy 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37q3bwm198-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:53:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364ox0X070460;
        Tue, 6 Apr 2021 04:53:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 37q2ptrhk3-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:53:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YjiR6fiJDgialeoLERH+AW8S5DjgjrR667QfZ44XAa/kmYBAnMQNsQyb21r30mktA7a2fEoR0mm1/r33ytz4vLz/WziR0mADuUegh2AlC4PJNa+jUKSDiH4ItdKLmAlyPdA99DAXnpLxnT46qvyNQFgB7tFNnfynbOfx4iLKEWGy3KETIIExB5PToZf9t8DW+ex1G00nACTvKo8oqSoTJ5qnFQxqqYeVBPBbcneNyR9+PKceF4Ve8w8+e+MOhr3o5M2jqiXwg2qqjOg7cxgss+7r5jkxKSKtxgLQ0xfu+n4sguUfpSbD+2I084pFL0P+aEqJ5YY1NuZjLcssoFEu5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKKSrED3K2jBYzuqteygB9kKW/thCmmOxdDgxl28gug=;
 b=GpMsz0AVr6oYUthuaJf8SOx1MuhCDMhYv3dESacCLG7kEFPY+cTJAmNWea6Iafd/ZYnaUJFmDYB9NO+l4ZNd0gx6/CygMb8B2539z6MHbWJxM0LkUemkqI4Qr7+RHWv8dra6zVfUVEaImzyZkaIuLNvjWGYhrXUUlrpCYuz/klcb1G1Rv1ohgCCes7fxWf5PGNGy0WQrish5XmJpaO/rMh7s6o3UP4AiCDFFBxXdXARhi796KaExWhfot0t6qiRcJ9bNAXFs6v8pDALTa0FgTanHTMcO4olW9AzrS+y6BcgF0n6zf8KwBIfBPi06nJJNZyK3CdQUjSIC5hfNXHltCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKKSrED3K2jBYzuqteygB9kKW/thCmmOxdDgxl28gug=;
 b=wSpo2fwPr71UQyUaVInDuvaQEXK5tjM4vfZNRG5+sf0Bt1PY53W4oppJyfPJB7awnyOglbVu1Fgm02enCthVSJ8nqrACkN5iw12KTiKpLi70Y57JeQhbFR932AvJPL0OyhMJeeniGIOey8fkHzpu61oNdhBtbn3bVBqva0dHeK0=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4407.namprd10.prod.outlook.com (2603:10b6:510:31::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 04:53:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 04:53:30 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Robert Love <robert.w.love@intel.com>,
        Arnd Bergmann <arnd@kernel.org>, Vasu Dev <vasu.dev@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: fcoe: fix mismatched fcoe_wwn_from_mac declaration
Date:   Tue,  6 Apr 2021 00:53:20 -0400
Message-Id: <161768454092.32082.5587252008016665095.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322164702.957810-1-arnd@kernel.org>
References: <20210322164702.957810-1-arnd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0193.namprd04.prod.outlook.com
 (2603:10b6:806:126::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0193.namprd04.prod.outlook.com (2603:10b6:806:126::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Tue, 6 Apr 2021 04:53:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4978888a-38ee-4c75-44ac-08d8f8b7ec33
X-MS-TrafficTypeDiagnostic: PH0PR10MB4407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44073D04B3F7ACA3AACA24888E769@PH0PR10MB4407.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r6+Q1Qjjul98QIfDTvrGGMjeRJ5MtAkfhnXpSD9DlexgIPVZ67seZXwN+KaHDkXHX22AacvLNWSZqaAaeFQcrBoqAWGMP0+Nb1iueP3abtc2bCMZWm1HySc5YqvnnnWsPtJTQT+xL4r9h3NDJTzTnX7a/1HgFPCmd0JjIfwaw6/9zzm0BwXMC/MPRbPjARm5VNzJGA2OyexNXJhigA6b5x/PAz/uPhHte0HrFowuNhqu3WcdmBk5WfgOqgeefOBdMlqG/yAFeWTFwpoUaNyal5lQ36nduyUinRg/1DVUQoPmP3znpDQmiM7ycDFufqqFq7Pme6G9eq4H2zQB58kIXHappO5GZ5cUYAlDPF2uxmDnlFEkiA+1rrOe2ZRGb3Go9sAaDYy8SZgHd+Re08cJyIaZP9fEnneBkSw4ip2+U0IRSxV8kz8n14OxGXQgy+4WDxXiVkFNMSm9a7vkhWBZloD3orrwPQ3JdBX5S90FhEI/1qC1wY++HeNhwUuiA0LN3k3gLOXCZS8PhTkBJoFbtqEVWezSXFU1G0OWKYYGBhi67mh0VNKdOQJA4f2JB43mbBrlM+v7YeaicQwzxGS6grCdb3fJ459V33J35oZ0vTWnC6L8cF3ZBev0Fs9fxNDmHOLedBN6nWSU3fcxXW61YSVKt3Rs3BrhQt5EOi6uRVgMRWvPnjFJPoDrmlIoSDc6liCeKnNKG68HdRxJaZFO11bOlGPIq0y7pH3HYaBDbf0C6joQhhBBrweAFgRfbCMSsz/yDSxOL3OI5pyTQO+yOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(396003)(136003)(52116002)(8936002)(6486002)(7696005)(66946007)(66476007)(186003)(478600001)(86362001)(966005)(8676002)(4326008)(66556008)(956004)(2616005)(6666004)(26005)(16526019)(4744005)(36756003)(110136005)(316002)(2906002)(38100700001)(103116003)(54906003)(5660300002)(38350700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bUNRRWltQjNWNXl2bUJhTkh5a0F0YUJ5UGJKM21GNElHTDJwWFR3T1MzMU9L?=
 =?utf-8?B?dkZIQmxTZVN0VG12ek5md2lmRXQ0N1lqSE53TnJPZURrUjl0UCtTY1RuSHp2?=
 =?utf-8?B?UHNEMndQWUFnT283cW85eENoOWpSNU1pU3NUN3VjL0VXSzdjN3dHQ0xrYk10?=
 =?utf-8?B?bGhYK0dJVUlsamhSei9WYnprNkV1MWlEaXNnNzZNVnVkbDErOHcwSVVwNDRj?=
 =?utf-8?B?QjJUcUlydFlUVExYUGd0aXVNYTRYR0ZEc1JlR1JpNnh4dUdpSGVyZExiL3Fx?=
 =?utf-8?B?NGRkWE5SblVEL1pka1VmU2liQ0s0eklMdDZSdEtxMVlGYzhEQm1TU2JCL2t0?=
 =?utf-8?B?WnJScklBbFY0aVd1L216M1JtSE5Yd1g4L01naUllRjJrNTAvMFQ3a1FBc3pl?=
 =?utf-8?B?a2JXbU42cVZiRFg0bzByTnJIM0Mxc1BDMnJNazMxK3hvNGVZNStNWU1NSkNi?=
 =?utf-8?B?WjhqdUVWSHBqYjQ3SHFOcFpRMDYzYk1aVWlRUHRpd2hxYnVsT2IrdXpvNHFP?=
 =?utf-8?B?RGV1THYrdm1adU5JazZMOUdKOXFveWNLd05wUWk3TFNGa05nNXpPb2ZsUzFN?=
 =?utf-8?B?c2lDaTVObTRsR2N1WStyRmQ0WlorMXZ1Skx6b2VSbVkxQU5iZkNlVGFUd1Nk?=
 =?utf-8?B?UDA0WlE4R29LK2hNQXVEY0NxcHZuN2N3RVZXeGdOQnRlZXVPRllGWTdqQUw1?=
 =?utf-8?B?NXlkWHArUWt5QUh4MHRaeFZrSFhVSXlMWGZXSlYvNWVTRUxvVkkvYm5HNGJs?=
 =?utf-8?B?WGp5WVRjV2ZiUFdEeStqaFhYK2IvQ1JEOXNrVGc1dWhOS1kzaVZvaS93czVk?=
 =?utf-8?B?aWZzOUhLS1dKN3AzajhaaGZFRDBEOFR6Q3cyQm1uN1B3VmdQOE00SmE1eW1v?=
 =?utf-8?B?V0t3cGxubXJxRndjQ1F5UHJTeTBMdjBqWjlGZ1VlaGcrNzBhWC9reUlrVExS?=
 =?utf-8?B?UXhvZTFSS2F2bzJRbDlkM2ZUWVBEb2FlSkNaQU1PZmpFTThCNnpJakpvMVBO?=
 =?utf-8?B?bmxnM0N2aWVBNWd5QTFCMnJVM2x5ellJSktJb0hjalR4K0tjdDdCRlZLbnBh?=
 =?utf-8?B?ZStocEFCdUVVNm1WUmtUalRNaHlrYWgrQXVkd3V6eUhpbm9USDlJZ2E3dlUy?=
 =?utf-8?B?aU9nYjJYSU00NVI4RFBKK0xsN2F0d3NJVlhCQTFkc0pEVVJZUkxIQWhMRjh2?=
 =?utf-8?B?NnRCWUZYNDcwY2QyZWZCVjNjWVA0dnExNmd4NmJBcVNTZ1ZodTkvK2tTMktj?=
 =?utf-8?B?eDFGL0NhVk5TSk5CWHpBRWZVeUVrUk9reVc2cm10M255d3lSRmRxM3U4U3Bj?=
 =?utf-8?B?bmZ4V0IrOG5RQXZBMy8wL1VXRXkxb28yaFRmTmJkUzJBUmlHdGVjejNLclRp?=
 =?utf-8?B?c2wvemtVRnlLR3ZibklsNWJLN2Q3QThrbVV3cXNpTytnb3pWVzVTcXRYRVZ3?=
 =?utf-8?B?NFhucmVDVXVIVTFEUWo2c29UTTNrSk1DMWNodnIzTEpxSHdNZTZiVkxSMHFU?=
 =?utf-8?B?U3MwTmdYaThCQ25lZnBtSmhyRkdacGs0anpoV2RCeGZIS0RLWjg3dmxwd2dT?=
 =?utf-8?B?VnVDVVkrenhTRHZnNjljOGthcVpWOTBBWThUZHU4MERmVXRTQjQ1REIvZXZT?=
 =?utf-8?B?cHJaZTdIaUJIMEd4WDdBWkxrQzVBWWhFV0t4bUg3WEpMeWpsZk0vVXlramJ4?=
 =?utf-8?B?V3VTY1lsVy8rYjJKbk5vQi8zendiOXp4clFSditNRjU2a1VPdUtVRU02THBI?=
 =?utf-8?Q?LT6H4ygiDZhcnjDwMmeXlOusB1SEg9ZlPXVBjLR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4978888a-38ee-4c75-44ac-08d8f8b7ec33
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 04:53:30.0084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VgcoQV3DClUebWoYgUQvXUDTaekek4ukdfVva+ae5/oOug+q5JWg5oBbsnflPaTJAQzSLE7wvx1sYUnRJQsXRIt3TwFYB3BpuFhK1ojpWMU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4407
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060030
X-Proofpoint-GUID: 8GG9ltboIYiQKv5XLlvJzgqdX9ypIBMo
X-Proofpoint-ORIG-GUID: 8GG9ltboIYiQKv5XLlvJzgqdX9ypIBMo
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 clxscore=1011 impostorscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 22 Mar 2021 17:46:59 +0100, Arnd Bergmann wrote:

> An old cleanup changed the array size from MAX_ADDR_LEN to
> unspecified in the declaration, but now gcc-11 warns about this:
> 
> drivers/scsi/fcoe/fcoe_ctlr.c:1972:37: error: argument 1 of type ‘unsigned char[32]’ with mismatched bound [-Werror=array-parameter=]
>  1972 | u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN],
>       |                       ~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~
> In file included from /git/arm-soc/drivers/scsi/fcoe/fcoe_ctlr.c:33:
> include/scsi/libfcoe.h:252:37: note: previously declared as ‘unsigned char[]’
>   252 | u64 fcoe_wwn_from_mac(unsigned char mac[], unsigned int, unsigned int);
>       |                       ~~~~~~~~~~~~~~^~~~~
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: fcoe: fix mismatched fcoe_wwn_from_mac declaration
      https://git.kernel.org/mkp/scsi/c/5b11c9d80bde

-- 
Martin K. Petersen	Oracle Linux Engineering
