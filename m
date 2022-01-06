Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA10C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jan 2022 03:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiAFDRh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jan 2022 22:17:37 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:54028 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229456AbiAFDRg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2022 22:17:36 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205N50pw026087;
        Thu, 6 Jan 2022 03:17:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=9jvQUL/9hlj2icqlmoCYHhpMZhg9tBAcCuVcVva/w0w=;
 b=U+uTX+JAd7AxYA52LrEcXfMxQmCWTJ7kGjyjaPAvuHPL2gy9Db2njOlX6lAD0GEii2q2
 9VW8aHeDqnszLrByKvGM0dr9yMQF0hVohSDbbggzlQmufAz//oG4+Wi9vgQv0UDGHNav
 Sk9b+z4r080AItfurYQkv5hOEOl2AR+hCG5r5qU59o1AfP26HGTlG2LEInMimppNh4w/
 luYktPO+zYr8HPHirtdAjIN2ywg4+UcH3Iwu4OQtv51/ZU9rmdm8DLI/z+OPjWkYk5WH
 wSSNQlASwLOZ9x98b5nDTAUiH17Wvki+YRn12xZLYsXwSuOwWTksuLbimpJb18L+Mpw0 lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpmg9xq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 03:17:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2063Bmkl090450;
        Thu, 6 Jan 2022 03:17:26 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by userp3030.oracle.com with ESMTP id 3ddmqc1r49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 03:17:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WPKwdId4wzWrit2Zu1b/k07IGCtPYj2EHQh90roL1VIMy+Boe1EQlafWSz021smsb0Uu9SOL4E6c+N7QS0YdSEzEud1qE5tJMOaVHmrGI2mnEURqO/6OVogxYSBYxCfRKQGgDkvw/4ylFy44LztEiLKJx7QehI8oCCU8nh//Vs5wyQu27B6O8qwMqrFs5KsZV3Fqb9M6VtFL+l/so0rXrfQgsicJ454YrflWx7ICI/rKFlpLHJPGaZNRDtEomjQ3ai6peCE9jzmZyGYVlbWn6+7+03BZ2s9mAiiR1gYUB/ckXGWi8Ql+yVLwZzST4VwRqQJGWuPXHf2WEV+/E6PmTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9jvQUL/9hlj2icqlmoCYHhpMZhg9tBAcCuVcVva/w0w=;
 b=R9s6PWknx6/DdyOtD1MXJaFQ2bi+mtxVkioozOdxDgdwwdAwwv1FQia9h2nO+JP5d09WVd6FVSI3An+euZj9+6WfJgBwzAChwDjaHReJXBFDyq5ouzYudUqDmPIm1xa747XXQEP4ObufgH7vZGk6I6I7028ql6WdoEyJMx9N6KLtqcV7OnxHUDUsdSjScAfCIQyh+V9YGnbwTSMqFG4Uc2T9r/OV3rNXY2XMsEb6VqUvvKEsnWlWMLhtZcHksnTlR1xY7YHTS1TALJWau8UZ7SCgj+yETFVglKonJIH3OXn+7m4w8G+P+tduM1HSBo/yceOKDv6hJSnxyIWO1ql7Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jvQUL/9hlj2icqlmoCYHhpMZhg9tBAcCuVcVva/w0w=;
 b=LUQGYe7/uLhKI14NcUKE2uTFPbq/5WBIUvJoefB7MUuWfD/in6dNb1ULHTMI6dR7J/as+MV5MV06sbDmctE6yQ8Wd4GkPHMsqqBSdZIgYWegP9dcsVpbZ9yTHc3xBtUVhJNkacdR1I9Lp4yS50F4DwN/ByIcfGXnl66vszUFKp0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4440.namprd10.prod.outlook.com (2603:10b6:510:35::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 03:17:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166%5]) with mapi id 15.20.4844.017; Thu, 6 Jan 2022
 03:17:18 +0000
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Martin Wilck <martin.wilck@suse.com>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "suganath-prabu.subramani@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "hare@suse.de" <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: mpt3sas fails to allocate budget_map and detects no devices
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r19ly2xh.fsf@ca-mkp.ca.oracle.com>
References: <be78dc2cfeecaafd171060fbebda2d268d2a94e5.camel@suse.com>
        <YdZcABq/pxMMh3X0@T590>
Date:   Wed, 05 Jan 2022 22:17:15 -0500
In-Reply-To: <YdZcABq/pxMMh3X0@T590> (Ming Lei's message of "Thu, 6 Jan 2022
        11:03:28 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:806:21::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f64c9bc6-8509-4042-7e56-08d9d0c30bc0
X-MS-TrafficTypeDiagnostic: PH0PR10MB4440:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB44409CC471352DBBD95533E58E4C9@PH0PR10MB4440.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HSZenZ41X0Di0QEq7JyvbvS1SXtY6byFd4zYhNENOrgwTiWiQTeitZJWkSk5EyXARwwOqJ1wON+YsDpW5Bic52TMJYuxU6OTfHLzhbIRQkrNvxS9AOHURQ2AE1+88bTCEnwsla00td9hYrTB+4aYnVGdTlcgh9U6kqJSMs32D3tYh8LFKjcYbG3amYO4eEMYwvHRy647DUCrGONs2VHa99nYGLQPbmNz1Eft4Ij/e5/YbrVQaTxZZBxxqcZsazZbjZAUpqNg6px070NpKq4WV3kEmy0cdr6iAkBxe5OcUoL3LGGJ+u+vCBsOeDWF/5uvlj8h9Zt/FPEuy4nX7oInbC0FA5NmS9K0VgngK8VlSyNr8h1T7dKy+Jr9rZ2oiGogButn8Huye9jwTrPPMmEHiSt1KEtVnyPaK5U4txsPGL6fb3B5Ka7n7TQxrIz2hjJFlyJbzwBknJSONWQ2AaY/5RO3ttykjlwW3IIYi2fmzAZ1G2+1WImEuoKmExSTkWu0sEWrVwmIp4gp7jLdhqnjFl+sZtDhH0JU3CC5TPqP8iaO65TfPmIYf3ZL1CH9PgK8+a/8wtMGs/8ZaME4sU7eNDNbq5sKNKfnTj1ll/ehD3ajy5h9z+RDLu7qMcZ4Fn68SF6dhR5V2FSeKg4H24XlfiNPvrnOEWzbNw4+tNzeM3yoTC2Q3ARkUvtN3z6rOGWN2DmGoRo7RD68gFc2xUna1tmYoRot6JbxM5cPf8RLwpT+61BW8t/lzf3CqCPuqIB+4O1Vyq07i9ZWXx9GuGL9Mx6363Y8r6YPiCee7LL96nnZPQm9HbyGx9xew0ztbiT2xkmoviPB10OY/QKchGQ40o4VoR49agBzt8v/MuKOPJc5GMGveNhFyotsVcOsHUVM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(54906003)(966005)(36916002)(6916009)(186003)(2906002)(107886003)(4326008)(38350700002)(52116002)(316002)(8936002)(26005)(38100700002)(8676002)(6486002)(66946007)(66476007)(86362001)(6666004)(6512007)(6506007)(5660300002)(4744005)(508600001)(42413004)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7pyxh8id5EdrMI8NIkxFlb3iwkktJVpPrewvjnqR0do64B8VLRIvh2Zz8DS9?=
 =?us-ascii?Q?wrcKrWmRNZA9TAevAfnezHK73oDdSg+gK4x4Zphxi60OZ17EWj7cJrYpyCMy?=
 =?us-ascii?Q?JTAcU5/FvShKcSQHCLI4dIVEb737zphKE7voiTic53rZj1P9nmy/XNkNwrLs?=
 =?us-ascii?Q?KMJyU8RfS7rH5F7+W9ox49TzyyTK2WbkUi784+2j6vQTQUCs7H8xngEMqTD9?=
 =?us-ascii?Q?gO0PbU+M9upb4qbFhX4JpV2pz/Dkpe57dTMn9c0YHxX2jM7w85rVTM9afoXo?=
 =?us-ascii?Q?SWY4j0sByE2jDybojnZd23u2DBb9jOPAO2fZAa0PS9zZZyR82FiDL8F9Aa8d?=
 =?us-ascii?Q?ZvKRv41RwsyT3LmdEfPZOWkxZr8tX23Pp3KpiUiefC9+2Wo5ieV72vKrHKQC?=
 =?us-ascii?Q?sHI7bF5rQyCK5D1KtxLx+lXDmlT49ST8JvLfucYA4XmY0WYC7bTFglsWX0Rh?=
 =?us-ascii?Q?3bIln98yR5pmyiLVADNqJQaICN4L0RA2jIsTtWkhVeaOB/B/IYVBlNN+L3ZG?=
 =?us-ascii?Q?HmA4KQKe07qzzZX6//vgH91ICUG1zHfc3kJYggX6yjpwU9D10EjVi0QW7h0m?=
 =?us-ascii?Q?nWLom66z92VccdL3Jljvi2po6Qbsv/nC9k51I9qZUkN1Jbrv/WI2urJVxsok?=
 =?us-ascii?Q?gDpajpsOJ/YvyQfeIxOoEjpQm+/BBKptYLyPSs6WKGb/3TSMDmzBfWEI2wwF?=
 =?us-ascii?Q?dYQfJqbfUckAJkLwOVhVI9+cSPgGI6ereNZvvZFI922S1w0eavgTonGR3PQS?=
 =?us-ascii?Q?w1UBU9Lr9df8cNVe93FLv6NNpA+GedVTtmLWhprzGez9Ox8pOTOSPVEhpqR8?=
 =?us-ascii?Q?vepj6A6d06rFow3u3aRIDBh8zL08VJPbLfsF6HA0xf1sqPHjFrjxEwEf07zy?=
 =?us-ascii?Q?Sur8enqbBsNzgdtw+ZfKuxHvQ1dFUbugbz9jEnNXbZQIHbRHxZMWWqhHjzcL?=
 =?us-ascii?Q?rp9f8o7roNVjEgiPeIj7+blrwoRskvrlh2J2elH3RJh4SZ3WaAEJ6QMCY5CL?=
 =?us-ascii?Q?7KMLC1u/FORYfI5r+usX4g0QLj08XaxtaLuwnx0uOHnDWLDOtOrNUBdSYJHs?=
 =?us-ascii?Q?JwnnheJSDYNA/x+Yghx+L4jooDMARjPkxzl7Dza/ybMJa5uMoAjHgcMfftgd?=
 =?us-ascii?Q?Yybjk1Ofxd0N75LhakIlsmv1REZSOxYar+Ewra17L5/JYJ29E4e7bu3EsTPC?=
 =?us-ascii?Q?ngL16L+eEGHaSk/4s6x/eOkyk7ssbhPX1cMkt9jMP9IJWC/6mKCE3VKkgspj?=
 =?us-ascii?Q?tZ0Tu97vsAslOor+O5QlfGmn2RUzRVc+u1ska14xgKHixPev0CouwqF6E24n?=
 =?us-ascii?Q?fe6t2tYLUeOfFZMlWreadYdy60LL4R10HvZ4mvpM5GXRa/7mJ7t7uuQs3JU/?=
 =?us-ascii?Q?oHeFEQJjHVqJtOCegwk5P+1HF5p4/iWER4wLxi1xfYRl9lZN2NmVF0+Ukjlj?=
 =?us-ascii?Q?E2r8hEVuvwcD5KNY3lY464AUA3LxIYmFc40cVZyEzNVnoWhNHdHAXik6EO0+?=
 =?us-ascii?Q?95OYu/vpgD8aDXcg/aTXEqtN4vngCUasBvaTiK0t7+0huIvVOCSyrdOIW8aM?=
 =?us-ascii?Q?K1OcJg/3mbdxAodlRFXPwSIuVMrzELO3+Db2kCJcr6g34yb3P0FZnuEAAn0C?=
 =?us-ascii?Q?BBGOpVj2vngVO6FL9vxQ2yKG/6xuzqHAMXTFW4yvgA/h+wbb+ypcgTqQ8QLr?=
 =?us-ascii?Q?e5yByQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f64c9bc6-8509-4042-7e56-08d9d0c30bc0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 03:17:18.5249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vSbVpBsGCE5jYZx7U05a/yExF2K21ENBWTjJ7JI6dWXMC+d5xOzbI6a3+DmVB4WO9zaK8uu2oYA6vb3RZeZ7f5IiERi0Df/4dvBObk1waEY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4440
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=887 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060017
X-Proofpoint-GUID: ni0jPlQVO2097ILze_NYh8NvZwoLcZqg
X-Proofpoint-ORIG-GUID: ni0jPlQVO2097ILze_NYh8NvZwoLcZqg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ming,

> Bart has posted one patch for fixing the issue:
>
> https://lore.kernel.org/linux-scsi/20211203231950.193369-2-bvanassche@acm.org/
>
> but it isn't merged yet.
>
> Martin, can we merge the above patch for fixing this issue?

Already merged:

https://git.kernel.org/mkp/scsi/c/4bc3bffc1a88

Since it was part of the UFS series it went into the 5.17 queue,
though. It would probably have been more appropriate as a separate patch
for 5.16/scsi-fixes.

Anyway. It'll go to Linus once the merge window opens.

-- 
Martin K. Petersen	Oracle Linux Engineering
