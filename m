Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C6B2C71133
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 03:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbjHYDWe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 23:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241467AbjHYDWJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 23:22:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E172729
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 20:21:52 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37P2S74b004583;
        Fri, 25 Aug 2023 02:35:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=UOW9CQZJVAvffpfvZUQ1lqBx0q0HbUTVCrv6dN9XmEg=;
 b=Zx/muuwLyzKw7XBlbTHcttRC+fBiHQj0qS8siy8DhTswuXtOiYz8eejINZKwHQx2NHgI
 r9IC0mxqA5TdDPCQMrGCGrrTGh3dPdbL5wbLJSidyWbV0hJFq0D6SgA8HKWbqiMB8cPK
 rWFj+uisd3fQOiUQsuBDAZn4LCO3UFlzsi1YNNM/7wydZCiHi7SdPBg4tB4C2JdUo0CQ
 Nl50S50eCILHXsL0yJSkNzNaM+Lwc1cMj0xbd62/mNgG3NMG4Llkp8TEgoPPHy26P1VS
 WMod9D+tSh6lkRsq47s1p+Ysh92BHA9gRFn8hqGJBgOo9WX4lUO6u4xAJ3PQ/7qKyqAy OQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn20cnejk-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 02:35:13 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37P2F6OM033247;
        Fri, 25 Aug 2023 02:17:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1yx9g5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 02:17:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mk6n4jWDag0+rZb/aCLB5QKrSY1BUSqel7F1QwisqI4XbA3zN4yqYbyEt7VU9NJI8N86CPLH4SuJiPMTQaBpVV2IJSkT0ttTrlumKu5yFBBRZEw/LbYnxouKiD+4XstxmHeh9+jNpTtICEzmUNmGkjZbgq7/NezCMcq0WhyX+CuNiVToesMeFZfqW4o3U8za/KYqhxXHGxLnEj+E+Oweo3x2kOwH8+mL4049GnpDVPgJ7N3oVhSLAwXqs4nrrnlDljy4umJUl21fF4pKoGSg3bAqSYzrIetl9UYKGiZqX8hkjim7bMqebpVaw0BQzzh5RLgs9J/UHjRrXp9W6zCMfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UOW9CQZJVAvffpfvZUQ1lqBx0q0HbUTVCrv6dN9XmEg=;
 b=eLljNrdl5SASx52m8iwDbTVojyx3HpS6twoJA7CMsqED69Yo8mOTJc/KXPRAOHPWRIex5CKV96jkZAW5EmXKIcJpynJkl8vQ9o2edLHbIhHy8aleLJtKGiia45qS86m+ViGeGtJgz8WwALZINZutziabeK+JyaId8qykIbzPYyC50/GwDJ5qDzKA0oy+0eFZlJq133ZPfjR/3ukMG/91vd8DevfCik/JW4foBoeBzHiiNPW9gk3uPRU44AVqzyLHAcBJThQLfotHtJ4/RGrRjwYbmSndVRFsqnsxStycrzVkC4C7/BXdgX8rCtqqWYASLpiKxZhP0wnW3Av0ZvbmWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UOW9CQZJVAvffpfvZUQ1lqBx0q0HbUTVCrv6dN9XmEg=;
 b=ZNi/NaqrSlplP8AQvWVd04v3RCRsIzXZfa21ReeGbw1FMX9RSt5vdqWLJzwJFDuuwMrybidNxIJreCM2V4J7lwztM6f+GrlKdMoAhuxkDRVMBeSBQ2HNKUAEyOcQu11Z350kZV7lGLLKN6jxINuMDBilTSH5tGSBWG4aAqgJ4oQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN2PR10MB4381.namprd10.prod.outlook.com (2603:10b6:208:1d3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Fri, 25 Aug
 2023 02:17:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.027; Fri, 25 Aug 2023
 02:17:12 +0000
To:     John Meneghini <jmeneghi@redhat.com>
Cc:     linux-scsi@vger.kernel.org, Kai.Makisara@kolumbus.fi,
        loberman@redhat.com, jhutz@cmu.edu
Subject: Re: [PATCH 1/2] scsi: tape: add third party poweron reset handling
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11qfr3lyf.fsf@ca-mkp.ca.oracle.com>
References: <20230822181413.1210647-1-jmeneghi@redhat.com>
Date:   Thu, 24 Aug 2023 22:17:06 -0400
In-Reply-To: <20230822181413.1210647-1-jmeneghi@redhat.com> (John Meneghini's
        message of "Tue, 22 Aug 2023 14:14:12 -0400")
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0267.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN2PR10MB4381:EE_
X-MS-Office365-Filtering-Correlation-Id: cc2c1dca-1b1a-435c-167e-08dba511646b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8oWGVl6tM3kwnNybcpENYrYonpKiTYLu8B0DbVU6++QzH4+7QaAqoRCgqcF6z24YTv9fLM9NCDAQt+Yi0eY8s8TJMrecaHQVHxAhArba4l+ISghmu1yFzCoDTqoJ0nLSDMQi2SXxmopXcNT+AtPsMyHg6KLZAntcOZlZtRzU8Yc+nHIahFIWh5SaDBFNilVGmA7dNw7k7+CSDIOMWpNyNmbxglPLT8ocwVMwoAkx0CsoguVs4oRAliHcYfey4WCeeu2IbCy6mdQKjMR5Dj6E+/yjfujbdvPiI61SjfFAdGmYVbp+FEBjviNsL4sxsY/aD//r2txPRlnwwQYG5z/Z4GBwvTbAabm9DPOLmgH6bRC4AaTR0BMfa4nx0Idq/XJS0lF1mh+cwlEuy4ZQIMO3Aw/o/e+zlSOU/UBP1ZGuKPj0ygVzH0l84ayESlJIMtp8PVRmuAy9vQzF2bpKxekkfdsynojaKGPl6WBHSaBGzHBUBJA0AwlL87iyfvr4l2Hm/G4BXAe8/ON1aL8XSM13485YVw0SRJyM3VzkguKYQyEsGxiGyDhFZS9Nw5T60Hdc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(346002)(366004)(136003)(186009)(1800799009)(451199024)(5660300002)(8676002)(8936002)(4326008)(4744005)(83380400001)(26005)(38100700002)(6666004)(66556008)(66946007)(6916009)(66476007)(316002)(478600001)(41300700001)(6506007)(6512007)(2906002)(86362001)(36916002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N1zy/dJDaSZX0jIE1e3aVkTPGv9IAnjK0jo5/m+nYWTukWfc2hReO+t+AIDb?=
 =?us-ascii?Q?IiC3l2CaVHrU97jHCXHoi3ULHUqjT54t/r2Icu3DGds+M/FI2Rm2Hb+/jPqo?=
 =?us-ascii?Q?a6bKjtDIOb14J3ADJDaomSpeT6jGpGMm/werHFXvNh6dDf63tBjGp5JsZSlP?=
 =?us-ascii?Q?vt99BBA0j+C17DF13Gjffeoz3l3i5hY+NoWTcxz6UzztiRNVgkrBVVrpHip/?=
 =?us-ascii?Q?L+EDDmh8zrIg0Gir3agQPhNfdqr6jXLDM0AG0w30vWZmaOMysk2X4nNdXQhQ?=
 =?us-ascii?Q?52Mqpq1G8M+Fl1fmIAgUjh8vAnketo3n/h9BKD6dbNGTnAeqgtLchxuXfS0U?=
 =?us-ascii?Q?c6laJdZr/szR8liYr31HB3R2jNlfFnthDJqNUGT2hFo384t27FbZme4Unw1F?=
 =?us-ascii?Q?NdkM2vwAxnnJLe1Tj4zqiP66R6XQLIsXyY76uj3b+LwYK/9JbS4WVuvsCxqa?=
 =?us-ascii?Q?xyqsgditj4KUiKMUYPDF3cOBjMx1uLDAoxiYY0dYwh1Y+wsa/AoZK2e/I34h?=
 =?us-ascii?Q?7+ufnuC3tXAU0kwLuYvtA/7G0fP+e/OFQP0SWF6cN5IZVCt4Exhcy8hX7UOP?=
 =?us-ascii?Q?L8MkNWtIruEJk7JZXeHlcrxs92iliYqKfh0XZ+AnZoVcTS7o/NdivHSFjzBG?=
 =?us-ascii?Q?nTz0dZIlq/H0XIXzyq5Jrp1R9mj2AToJLGWTEycybPnD9XR3eKox/2IBBFDG?=
 =?us-ascii?Q?HGTs3pu3/Cq7HyI0eWfRxU3p4FEs7a3+/v54P+NqFVgrlwPsmj9bCY6iFFTv?=
 =?us-ascii?Q?GWLKk7FV2icFvjIX9+lNh40H0jFlMRSzD+4F9XYD13sPEDWo+ikRjGVejyof?=
 =?us-ascii?Q?cASTgHPd5LCpIdQ5k7rU6vfCkbXan2WZba0LfhN5Mw+k4g9gc6SQyzkjgY/c?=
 =?us-ascii?Q?IDup07sN3a5Y9NIMexXt7m+6UaTIDyTxIE32P1F+wRC/knJtZKwTtz54Ijhm?=
 =?us-ascii?Q?tE/qA8gN+4AslLiOuLh5BJFx2SigzJGGGcXaNtfilSN/GAEDoB4/Mp/ntiii?=
 =?us-ascii?Q?46FErYscdOxDGOGKocKtlsC/ITms1Y7C2sFrjDDO60Ak+ebZSHkwknnRgaB1?=
 =?us-ascii?Q?cG5UA+EPMLYpHflIq+7JmFWDwpMypSxkkKPGjeOD8KlFffYMfaG+WYmYqjQV?=
 =?us-ascii?Q?/GOZlrxNGwz0MVGtuWsDS3YvEd/LPZ9ukpCfBmnd1PD+TGHdaLAQQeeTU8cI?=
 =?us-ascii?Q?ef6NsA30i9RiEKU6FxdERInHrjsYh/hfsg52eGf6r/aetOYgGG+/12Ddanq7?=
 =?us-ascii?Q?FnymAVsesMtnnmLvoZV+PqCJpHmnXuQAhfbofgdRGIkDlb0qtHfd0SNgPw9C?=
 =?us-ascii?Q?m17t4IbbQxfM/yWThTycABjG1JufF7ZjcnapRzhY36HLQVeFLcvK1jdgkM8p?=
 =?us-ascii?Q?Sd4pEqfZurNdg4CjA6iGr43r5HRgdNj3kt0TR2BDg+lmTCLm4BrzkXTGckLC?=
 =?us-ascii?Q?/TuX9Sj4xaWTev2F9rCEfWAloiJs8u3rHMn0qb1z6mn6f2J+VaCR+8IPU1Ou?=
 =?us-ascii?Q?O2em+LvrB4MIfL+d8oH7pyNc8eIPoTR0j0WgjQPlNHMnIensvmIL3VyikRnk?=
 =?us-ascii?Q?6xwAwy/8ZH6DWYfzmcWgxfxZgIYWEy328YvheskqBsI9Hd88nVxT8P00YLiJ?=
 =?us-ascii?Q?Kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: F/wRBEnAO7glIQ8dtZvxYjnuTSXcpoRf11hAnenX8nLlIWGcBh6aELFobgW5RmW+rGdBm1XcpgNo1SZB2uUuC9ZSe9jPbliTl2HJ9qEFYESvuOgfrYYP3Ye7C3fSYqdLKraIczZqX/vCUcUpyC/wh9uX7EADuetHqAkZf0MAmdiEgC7vpYvzf4PDpmxMR9h6vydHYOCwNMDqqctomGWk0QatkA9D9Xsm1mWwhGiwShyF5GEAee8SyF8eDJMCwtgfv+QZTM5DjEcWlokA9jTaJa5YkgFsjTFH+PEJjFAH1x36d/CT2XA9WPGLp9NeB5FBm8H+MYWLvwUQL5lJDzUbWcj7cwHXwIuIfdUxOs/WjdV+xBVwLK4sRnjLxTQjUu/MxwruPVsWnr5Ja3/wSea5qPEvkbaC8PIoei5nm8ISlmik6QWJydi7p9EAyTWFdV/MVZ9b49wV77rbdD+hr4uHv7FyoocG+r67BF2DgNlUJiACyNi2IU+DeyyPjf1U7C+j+2l7gz7BrBqH1V9avXu9c4Ug0n9XfSAFiJaOsKTn7U9RG1OleFYuaWZzoMhR8GhgJVLRVH5cfRuGo3ntU8kqOLzo7lUXdbwA1J4NKJprWGT9B1CbeWuLLB3H8KRM5gMZX+V6y9nSz8oyfW5MFCwjUigLIo+/FJPmhnMelfxkfpFFQB5GgCYJPiNoAk46nbEcqI9402BGelOU6z6NRXgOJUDwTEr+VIRV7Kn6Yal5wswA1rQdfxKPl2EbnRKwEAhUQgK+jeMH8wXaT0Pkju0MLm+Wztm3tsTuYyPfVR7jnzceF8NRSxm5SNpKzs5bo8eTvDsMc+5a2Mbka/u8GEjvhQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc2c1dca-1b1a-435c-167e-08dba511646b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2023 02:17:12.2082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /dpg6kVFyswhh2rWSxaK5289x1F9WzxdkJEYt5zDvgnC7VUmaUkOH+52fl+gpRStwxLIV1L4bspVn/GhE7JxE2X14nT93skNbSiHI6CLDS4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4381
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_01,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=770 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308250016
X-Proofpoint-ORIG-GUID: _7Ab8r87ljaBb9E3HqPljTsNtOvbJOYn
X-Proofpoint-GUID: _7Ab8r87ljaBb9E3HqPljTsNtOvbJOYn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> Many tape devices will automatically rewind following a poweron/reset.
> This can result in data loss as other operations in the driver can
> write to the tape when the position is unknown. E.g. MTEOM can write a
> filemark at the beginning of the tape. This patch adds code to detect
> poweron/reset unit attentions and prevents the driver from writing to
> the tape when the position could be unknown.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
