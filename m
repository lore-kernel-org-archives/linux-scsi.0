Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C32C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C099B604D1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239492AbhINDqJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:46:09 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1248 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239225AbhINDpq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:45:46 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DNXuqp008698;
        Tue, 14 Sep 2021 03:44:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=jhYKxbPF5g0wmaVqyZ44t/713jg4r/kJDlkkj85XfEc=;
 b=lJf6pLS55dDxx9Wx/Rn3S2Rj19jIR3FT0WdHVLBekXNHqh8karNyVzn8uU+do9NVn+7O
 vAwWtQilR+/7te1H1ix/6n12ri+n515UNOdVj0oJx6bfcBWpkkTHcBex9QPaIKOSJX2t
 q6U0OxIXOLosa0dekLx5J0Upn8uxNYoIpqeEjeV1wSyjdfvpin8epCuJfHR1CdEHuBFM
 5j3z0scJxT0kqPhA8NdXDsXPnNp75G6EJepTVWM0ldvc5OJFHpmLcnTxtLxRdkdNOE8O
 NAgiyZXAwIbUBTwNRw5Q+DZXipE1j99X3OcxNI1o2+Hwg07ktNYTBsW40BiSkyw+fpwE EQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=jhYKxbPF5g0wmaVqyZ44t/713jg4r/kJDlkkj85XfEc=;
 b=mGjm7x5TAsXiq7Ro9hrTdMOWMeUMmc+3BNzMqSG0OV+l2D+sVHH1mkQ1jnIgAUFV1tJF
 8ghELmtyDgIPAq7OU2bhSFm8+c1CmWMqV3FCDQ1i0HkvlqcD594Y6kTJFItbai6Shkwl
 wdRk3tT5TSusi45PqpI8AJb/dMdzr/Ug3T3MnjEifvwPYeCj0jw+ud4awsBcMxBHBbdG
 wWozGc4ungikoxyWFAKALkUS513Ws54f6h/b2Aq79fcmS0ScNCNWOJOKG/LRHV0G4ZFF
 BrElZe8aAmkxV/LrrNMRUWcIDRDucWtojc9G0dd/b/HZBLr2umIyFxGMp097Owmq78Bt hA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k1sd48s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3fQqx109415;
        Tue, 14 Sep 2021 03:44:13 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3020.oracle.com with ESMTP id 3b167rd618-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SW8SotW69uOXYv4TJbG6Gw4LXA5xcwvDnJ0DUVgublhb7uSAo+K1SMM8wctNMgP7KT7FE5x/T81ZGGWYnn4SkNSMfsrmWim7KQNGPqU35Erh2eyOwiUge6lRdpA9JbaItW4kYGkzwu9ZahQ8XDia6IrsGRBXsb78lwGRl48iCBb5JPAKR7GeN3lTkWgy7+0fftWdgiYHUDE9Mid+dfcWWV4D0Mog/2zHs6ZbQmi1sriQNJHWfLHWjHlUdqRzztjaEIIEMS0cWfDCfp6OFg15fwaO7uhcq5kkyth1FC09C2HT1ohlJHFMzetbPlU9lMZt3/nLsz/qDbe7GPMOJkMa4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jhYKxbPF5g0wmaVqyZ44t/713jg4r/kJDlkkj85XfEc=;
 b=OYM+w4oYIz+sTbAL8Xs2S3cXGx6UGrEqNf2KD3BvjqbkTyIZoep35DVC+6czy1F78ZbbU/7qJaM7nUxgbRbHDrD24D8l7rV6J+HB3mZplXsq7hGcRqgTRljs5/5GE39gbzSTldp/hhoSkGnBcQfzY86rcl27petWCIW5+sTnUq6AFh/dXSKJ4cBJtD9uS+cast1HZCUWMP96OFapq0CbXdVC1bHGHNP6paT7MQDyv/2Sbjuv6QAGZqW9n2ElKlq/lITYYRFLizvOHTKrCsYQw1joLZ64rCSCGmyBgWKjhGn81k/Cv1vrBN9ONqZhew4gQF9k/vDgQoAclGKNwiluNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhYKxbPF5g0wmaVqyZ44t/713jg4r/kJDlkkj85XfEc=;
 b=OZexyBdOI/u+p9kKo8QMSBOqtQd2YUOQw352zG+Vt+gdr7eDp8vwT6Hm+1bMNWjiXAizmIUzJDI/1KwybLu0YpPR4PNA1d2RNpaknSirsziQFcPdhEdfHESfNcf0N12p74C+ii86Nq8h1jiWNB/U9Z1P1/awVVvkhB4ItewYsyA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 03:44:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:44:11 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Helge Deller <deller@gmx.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>, linux-parisc@vger.kernel.org
Subject: Re: [PATCH] scsi: ncr53c8xx: Remove unused retrieve_from_waiting_list() function
Date:   Mon, 13 Sep 2021 23:43:48 -0400
Message-Id: <163159094720.20733.9533146745077960952.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <YTfS/LH5vCN6afDW@ls3530>
References: <YTfS/LH5vCN6afDW@ls3530>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:44:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f11f1b34-396a-466e-18a4-08d97731ea0b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4502E77DD5BD8D85EA8558E08EDA9@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tm1oTua4RynxQKclbBmuwbre59+SphU5pmWjJPebOKFs6zTprGmKttJktHQFSSduiiTu0jLe4PfVbuYuRc1Mq93HBqIthfpoQhCEy6baLlmASWRbkQMYXvVeGC1/WfI6vN/jsh6y7ZIYqIEiVPxVmNLlzFy6m98CjpLcUyWd8jwu2Q1UNbZNY5qmDibR8b8w0tQCtBvkvgqOlHDFo8/+hvrD1VUmgQDKQ88OJexkAgj5daXigFpNioFB9Tdt8M/uoHXryhazYrovkPD55OEW2rP7MtkO/4cS41F4Jc2D7f7ZhUHig2ShycXPA+KCr0nISEGjsXkLPL+8iYXlx9WbbDl0AvM9Uyf5VSfgzRAXiqR3bEG7S0etjCRMAM2MAzUVldAq8C3BG+1Wv21OJ6UM/He/7jmmYIWS25M0KXkRKVjd6eQLzw5Vr21BiC0VPsZIPxA0fXFe6ChBuMRYPlQrwuiDWRiLP1LMZORGx3UqSN9g8qW3M4S2IvWKTF3LzyiOrvFT8ZDCk8kzsZOCpYtmYcMhaMGLgONjpOnhS7B2gBAyUTIhYeLDz7Ccq8GCyZBvfHV0LsiwMh5z4cvLb9UGc/OhwgPyRE42p6GcRPwuIcd4uJdhyIzUoEtQGxgkq5aYnW/5ukd2RGnhg7YThc5cUsjPBFf0fBzT4AQj1ufRd5TLqFG7AGDX/T+NTr5MjIo1k/dSB2Ks0TvkpAoPyuyw1v0uqi7YqXYXAnV0zQBiEb0PrI0RIFUGoENNjv3+na6nkCebUUUhCpS9lGp350krEtFe1wMbn1e/WI77+vBY0Ro=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(316002)(86362001)(110136005)(38100700002)(2906002)(956004)(8676002)(36756003)(54906003)(8936002)(66556008)(66476007)(478600001)(38350700002)(66946007)(6666004)(83380400001)(6486002)(2616005)(26005)(4744005)(4326008)(186003)(7696005)(52116002)(103116003)(5660300002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0MyOVZFSjhiUlZMWUdVR0oxWk9Hb2FFL1QzMnNNTVJMakNpSnAveVVjVlJ1?=
 =?utf-8?B?UWw5WVV5SmVCVXk4eXA3bXYyRHpZTjV5aCtid3Brc2tCVFZBdHN1U1lIMGY4?=
 =?utf-8?B?L0dKcGwwZCtXMnpnNk5EZmNKV3ByZklucVRwVmhmTUw2bnE5YUpvZjhVM051?=
 =?utf-8?B?WjVReWZuclNUbVgrVkNRWjkrZnRSSmRWMmlWbnB4RnZuYlBsN3dNU3FjOEFL?=
 =?utf-8?B?b1lhRElwd3c4WDZYWjJQa0IrWXhlR0Z4SVdVdERITnFHbXBpS1FBNGRaKzY0?=
 =?utf-8?B?T0NYc0FPcXlWYmp4MUpabGZEblJ6MWhrSjQ2SjZ4NEJESFMzMVFDWjBIelNk?=
 =?utf-8?B?SjRiLzFBZjhzejVqS1ZhekRmb09DVVh1a05DUXJOTm9QM2l2Z0hyZlFxTmNp?=
 =?utf-8?B?aVdCQ05ScUtoenVzRks5NW5BcXBBbGZmWm4rZy9aZjl5djNOUFBCVWNDYzU4?=
 =?utf-8?B?T1J1WlZ2Tk11WVNmVmxxeHNaS0FZdGpYTjg4THkySyt6QXIzaE9KRlFCYUVh?=
 =?utf-8?B?YmJVL3NacW9oNWF5OU42UWVvdElFSmo2aHF2Q1Bkc3pLc0x4WHVoQlRnTEJ1?=
 =?utf-8?B?NUszZFZoRzg2NHhtOUlRWkRaVnQweVlaWVR4MHQwQ3lWcDJjWERYNEtnbCtK?=
 =?utf-8?B?Y1RnamJ5TVVUMjk3eXE2cnEvRmEyRkNlQjdUNWVIUDE0NWxKRmVUN2szbEkr?=
 =?utf-8?B?ZDNKbHU2OVprQmwwVUFLUEtRYVhYMU1RVm9pSnFJSll2dDhReHY4cEtMYVlD?=
 =?utf-8?B?S0NoZyt1Ky9RY0pIZ1QrTmJzUjgrVjNBVEExbUwvYm5zVFJxYXo2eFBuQ0Za?=
 =?utf-8?B?SVB2cm9ZTFhkeGVMcjJ4VDZzSlg5TU1NWlFFNnplMktDN2tIc1AyRklHWGRB?=
 =?utf-8?B?dHZpNFJsZThPaVBTc1R5MTNoNzdxNnIyL2dCZkZNd0oybm1jdU02Ukk3NHJZ?=
 =?utf-8?B?Q1JBc3RLbEp0QUFPZlBleGhOZEFNaWJBTnJISytXd1NRSzJUWCtlK1lMQ0pL?=
 =?utf-8?B?RGkvUnFvQU5QNStZVE9yRHRLZkFZY2JJWk13aU82YmR0d0hEZ3R4NytTbTZE?=
 =?utf-8?B?YWtZOXJoVWd0SDg5d3VaTEFWc1hDamhXRXdHclJta0V2RUZ6Ly96emozazJF?=
 =?utf-8?B?UWdyNGJIZy82SEZSemhSRlV1UmdhWXp3UEx0dU9sYjBkMk83WXovWDNkYjJG?=
 =?utf-8?B?S1NzTGt3TXJvNGN1aXg4QSttOFU3Uk1KSDZCSmhwTnVKcUhXTEhpWEdmaXpJ?=
 =?utf-8?B?YlplVDF2VFM2OEVVb1Y0aFNTS20xNTM0d0FoRmQ3OTMzT1RFNVlGQ2VUVTMw?=
 =?utf-8?B?bXowWnNiL2VSenpoQ3IzVkVqditzNHNpR0dZcnVCczdZV29VbHVhem01RnpI?=
 =?utf-8?B?Qk12anpxcTVGeUVYSDVVTHgrNytXVG83UWticCtOcnRUcG9BVURqUkR3ZmJM?=
 =?utf-8?B?bENvZDQrQ0FBQnlpQ3JLNXdhbHlmMzBsdzFERVVXVzJYYWNwZkJsQ2wyc3VK?=
 =?utf-8?B?UHV0dWthLytsQnFuMnFkZDVzMTkrQW1lcm1kUmZVU2lCaUtNVDkza081djZn?=
 =?utf-8?B?N0FRTGFHWFNkRndpVWlJWm40Rkx4KzlRTVVVRnE5WlduaDJDTWtDWnRwUmh1?=
 =?utf-8?B?M1ZzTEVUelZsWEpkZUp4UHArdnJnblhpTGhMSGY0OENhSWRXU0pXU0x5b2tD?=
 =?utf-8?B?bS9wVE1wcGt4SnVPOWVCanFIbk9BbGw3N0RTMzNERGhiaXlKNUM3OXhNUmg0?=
 =?utf-8?Q?PdTPzPkV9rL3GFdgdtGcWYmx35tZ4+bqFuZ1kQ+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f11f1b34-396a-466e-18a4-08d97731ea0b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:44:11.5026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e49OOlCXUNiU8CTkHVC3Uly6+EzZxQtkVlZE6yfLUKHyGxlI9eQHsHohuFoOv6zvXrbo4B6VaVf+Cy9lkEluuX43QcVSwasvcaB7M5FVqQg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=632 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140019
X-Proofpoint-ORIG-GUID: -r0T_5A4bpMaBlRTbnSEooW_-uoLLP0o
X-Proofpoint-GUID: -r0T_5A4bpMaBlRTbnSEooW_-uoLLP0o
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 7 Sep 2021 23:00:44 +0200, Helge Deller wrote:

> Drop retrieve_from_waiting_list() to avoid this warning:
> drivers/scsi/ncr53c8xx.c:8000:26: warning: ‘retrieve_from_waiting_list’ defined but not used [-Wunused-function]
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: ncr53c8xx: Remove unused retrieve_from_waiting_list() function
      https://git.kernel.org/mkp/scsi/c/1f97c29beee7

-- 
Martin K. Petersen	Oracle Linux Engineering
