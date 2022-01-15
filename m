Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21442C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Jan 2022 13:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiAONIz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 Jan 2022 08:08:55 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:32096 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229455AbiAONIy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 15 Jan 2022 08:08:54 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20F3CDZu001646;
        Sat, 15 Jan 2022 13:08:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=UOSFfT/mX7dUPF8AHQkzBtUqONE2Zfu1bQUw7k5gxXU=;
 b=xjgIPPT+lsZmdfU8RbgzU0o8iiTUOd3ZjJHIDd+ANs5G3gpmBH333gYplvHbbaO7piyb
 y5cRwaDihdE/wisq4PIAcJvTL7W3zLvra8/2eb2H3xIhDtYAZe8nXr3VsThm+7BhSeHT
 9rMUvZtWEMvn2qQYmn502vFttNr3yRBMCcA/3gVDkhh6M0UsdwTVoFe+uSMpBycIu3vj
 o0UvhqqjB3/99vhnF0YCf5icP49/5+C9P7iHCqd8X6SiPfjx71VZ131WOe0wO6vpR2rx
 AWfpk5rwkFBR3t369ZULo05ctQLnlMXEfoQlPPR+iJEsKa9I0mgTZeLKwtnZnrjKqGfU PA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dkp5agfr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 Jan 2022 13:08:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20FD6CXR085846;
        Sat, 15 Jan 2022 13:08:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by aserp3020.oracle.com with ESMTP id 3dkp313dnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 Jan 2022 13:08:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kexrRPthbeEZbxxSlNkSUpUh1jTnvUlXiaVMK94ynRTd7zUHb/Sis88ecYSVkfvDiHEdBGNg0UTM4zbjqly5hIvIjZqsx0q1C5wJSJgBvpopyzrOAq6oEJycq1xpjS/NxV73Ljx5pxV7ITMT3Q6NJZa4a5sqsAnaLFGZWz2A+LBikY6jyRxTK6HchB3MhLzrEpydGkgAQgp40pYHiUFLXmirWa/hKv5N/xQVyhMiRJtAGtYADi8dLiZZ2sa0qf2aokhslHZZuk9HosVV5OIAlaEa46ItmvZuTA4cUmJWrRt2OEDqWp6Dijo0j+GH+nUjzNmTW58HI70yhduJs2Zqtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UOSFfT/mX7dUPF8AHQkzBtUqONE2Zfu1bQUw7k5gxXU=;
 b=f82623TP3zpdChqK9V3ydHnGTbnkaHW3TOlFKkCHFNc7E6ObBwpsMFu6pPYSpbZlRHy+AZ9owVAj+SoOEbttRFYHu+BMq4DAsb1VMkjHPSzPmzrdB/rLgxpBQxt43O/D4tjuIaAvdlVlpo7YiXDD93gDIWQBKUU9bXrrXSt7x8gxIGAamr9FIX4D5ItaIxMiDq8CiFCaF8xNXDvGuqmuflkc9FFMhYqGU+f6PxXblJg6np0g9aJteTTgwGXF+rVgpuch0+MaHY9VmVVo+9Eg22zsy0ZRqipw7ONdDCUj8wA9cEpCRQ5/ldMbaw+DWg58mbrDj7Tu/ZUwdUlPq85jRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UOSFfT/mX7dUPF8AHQkzBtUqONE2Zfu1bQUw7k5gxXU=;
 b=CwZtRtaJY5EEAKu8NKwNwZCAt5h/ph1UEeDlBlfSgtzJETifmZCyFL7Af1fTutrkRNLMc6sJOVUyHSlcci6cbaCYKm6dQhJVSLBfYXYz3h13vJYLiDfIhyatHuRpt15AjWvBZ09NMCss71+mLAsjmD/FlHr9484X/UAjfO2Mync=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY4PR10MB1816.namprd10.prod.outlook.com (2603:10b6:903:123::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Sat, 15 Jan
 2022 13:08:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166%7]) with mapi id 15.20.4888.012; Sat, 15 Jan 2022
 13:08:43 +0000
To:     Christopher Horler <cshorler@googlemail.com>
Cc:     bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [Bug 215447] sr_mod scsi_mode_sense() failure -> "scsi-1 drive"
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r199npy8.fsf@ca-mkp.ca.oracle.com>
References: <bug-215447-11613@https.bugzilla.kernel.org/>
        <bug-215447-11613-0W09B9Q7hY@https.bugzilla.kernel.org/>
        <CAAeT8m85f_WMV-Ozp9zNcP-BM8NHENpaKemjZUaOmcj6c7WEOQ@mail.gmail.com>
Date:   Sat, 15 Jan 2022 08:08:41 -0500
In-Reply-To: <CAAeT8m85f_WMV-Ozp9zNcP-BM8NHENpaKemjZUaOmcj6c7WEOQ@mail.gmail.com>
        (Christopher Horler's message of "Sat, 15 Jan 2022 12:16:46 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0071.namprd03.prod.outlook.com
 (2603:10b6:a03:331::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a29e64f2-c0c5-40ac-8768-08d9d8282857
X-MS-TrafficTypeDiagnostic: CY4PR10MB1816:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1816C843D6F12FBB8AA3218C8E559@CY4PR10MB1816.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n1dwQCg/1cx36fmmcRH9F5aygHxGnkn8laYJ0BHtD9IooN6o2e3l01W2wcVeEt9ummAifditUBDBMxGRVCtqUGQTtBfDbaAgjQENfih9H5sYcBvwwmbMrkL0O1FVa5VA0Eh0sDYFx6V0fV9nefbz4MvP6kWVoB7kIIwXoQUMZod7c52POtJhhRIsYBmQ5kD3vaqk2JyZ/aUmoC4tUO2bxIX/yzdqJu4wn9XTkatbFikVShQnRVlrbRi02/Xn1KCv8ybszC+8XbqGW52kU2pV07Ma3myq9sdQzVRJGMpG/FMiqXY/LmxVznjRSHL2vcS98j5ZXMpJJQHRhzsEyyxCthGsgzrRxd/6NyxZ/UsNxh3Lar9CWCk0fC5dzbjnW/US9321hApZwIFB1CO/Qhc7XXz4EHLbOM23B3F16zQMHLIw4zlz/sLXFhjEGxcrWQyEfT3ewcPIPis8VdoYKrNtPBFwiSy5rMmAiGKJQ7n0f+Gz2XUb5rHG9SISAXF7UFpjJjOQtlY9MIx8PBn7FGNINYMSBWjP8U2CA5SlpKbAzwRJoKF4maCd60N/ZGaC1+7N8ywukyt3T1Bw05HT8jVuVd0V0Ng6j7+ohVGOaLi0TwCv/8tHx6Ntooq6726LsKCDZif3KL150ZqTwKocIAn3DFUnLxDVi/T49ZaFY3Z4DhSXrL6a9nyiOBttfY1RVCwa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(186003)(5660300002)(66476007)(6916009)(26005)(86362001)(4326008)(6506007)(316002)(8676002)(2906002)(8936002)(6512007)(508600001)(66556008)(6486002)(52116002)(36916002)(83380400001)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LJYJYaYX1RRz8MWoGjrCyVMo+SGNbMp1pvsmbFMd1KyPhoAtOiteRhr2uyOq?=
 =?us-ascii?Q?OfKS2JFytp6MJkkdS85cwUvo9DpoZ4feeqda5a/ZKwCkBifbfAkrktQp+QCd?=
 =?us-ascii?Q?TAERyd6BhcfRjytacAFKrwrsrXVpd8rZoaUqIkDpSXKV8OXHynhMSDaAa4rw?=
 =?us-ascii?Q?ourFs7AqrxUlKiQQtXooAxkkBjjm++bMYHBMNMzn+qReeV7enl/L+HJ0OFfo?=
 =?us-ascii?Q?7M/1BKiXKkDb3eiVEaBnvikR5fQcYrUQaGvze5szKQivXwN0mw1edZZAmrME?=
 =?us-ascii?Q?3MKImvzxWGhnqDhYErkw4BgbkWYkYwJEel+hWHxqWslnsQ3oxkGyRysEFuL4?=
 =?us-ascii?Q?1Z1FelNjV7rGuzAw3X4aN8cq7Ad4qOTytX/nOOWb6GjqZOr42/CWlteHuOSy?=
 =?us-ascii?Q?l97KAJwF6rd1+DgTAfxRa46ZIevttr2O1laAC4MkGD1lfavjPCY8UKVCnRQv?=
 =?us-ascii?Q?ciF1uykCk0CjYWfzay9pCvcEGfaQP1ayJIV1PTF/87ofJDGMZfSWZhRSrVnG?=
 =?us-ascii?Q?U2hHcneouvbAt0VNdJDgLzy4kdyP9D+6IeuKXyS2IoWZz4Yvpjj3zp6Vd4cP?=
 =?us-ascii?Q?Z1iBAvMdcsWqLJhwKSrI0X+NJhOOb3JcmJ/lsednGnE56qY0vmtv+Fi2MsQn?=
 =?us-ascii?Q?Zujtcpjw5WMt7RYbyV+oKf6vP5ZffK4OlziDVdteLt0a9LPmpEAlIAWocxFj?=
 =?us-ascii?Q?2CIKkWmmYV71II+q8yHRMYdCI2Ehua4tbqdgMce+2zOmwxd/wGKpDZqpJZGI?=
 =?us-ascii?Q?mrhRzJZ0Ho9umRfy1wHPotvBNqGyseLCG4U66BQAwtO/0pbciyUlYhtdg53I?=
 =?us-ascii?Q?ScKG769cIQRs9oDy+ZqMu26c2TiW5Iv6JX2F3Zh6mY1Q4/g+Lt0ifdMevemn?=
 =?us-ascii?Q?zK4aexrOUmwA1qrlVFEca/FlPeVoALNfeN4Bh5OXH0MOO6nZwZWAbGq4YTRk?=
 =?us-ascii?Q?q+dEa/TrowI46LtNvfcXy2lqeXC2uewqXZLG1MIrOUUNxOvb5ok1BUQ2ovjg?=
 =?us-ascii?Q?wB5kxcruirn2maCAZjw5OplG/W67n9TGapSPz/3xNEYI8y2f+CCz3GF2DZZ3?=
 =?us-ascii?Q?ZsxNQzbzzJz/8ZgtDNxYOq3m8JWEVDmOXv/BqoEM4zcK52VDT8nf3Jb/XOh4?=
 =?us-ascii?Q?RnhAulzMiGhYWMkxoSCT2vIug7U8VVSkQxrgVKzQGv+JFbSbWaCaIE8MDa1r?=
 =?us-ascii?Q?mW9gS4TTHOkwnBhlYcZaBaGaMjJY9LaRM1a+Su7Ll+SZQIheUYFCfmbu3xSt?=
 =?us-ascii?Q?+h9gjZKfcWlzc+A8AGUUXvygHeY2DhhPCzonKw4K6Q91hhwSEPEn4YOc3IXa?=
 =?us-ascii?Q?2pRBYq596dcQkbHupXSgvtW2IFdIL7kFYPzE2gr9pYqYkRnPmyIozlWNK699?=
 =?us-ascii?Q?gfMCCax3JxHSLjKE3mGIe/QF/bNL9uQ+//xU6HU4IZqsKeYFPMVLlMFuWoAn?=
 =?us-ascii?Q?j40qeP7XSTHclKGN2VIwejQBWGJKPVsy6DM+4ycvqHBBaryKp2T/kFb3VOYD?=
 =?us-ascii?Q?Es9x9RfFjT59JbdzBrVPVERK4NMgegavIm4ZEIXuj4zqcjfWMSCF3+oStyCK?=
 =?us-ascii?Q?dRCVW53NE1bbrRZjYWV+4JiQBQxp99kRgHFr5aEhUDooBailt1TckWOKA7c1?=
 =?us-ascii?Q?/BUjZ8MddvupLZxDFCPBS7rEwyFUWoq9Y/S+0mF9ukCPHtLtM4DrpF1LgYsR?=
 =?us-ascii?Q?/iWUSA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a29e64f2-c0c5-40ac-8768-08d9d8282857
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2022 13:08:43.8158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r3t5MbXZk1HU8C+NgpSZI7hrhaGXpeoNKkebE3xhuxI0VUUxN1SGihglGGXbLjMqYNhFzmmGrZtSl5QqxwqHJpJojbA4Bwtn3oHgPcBXqLQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1816
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10227 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201150082
X-Proofpoint-ORIG-GUID: Xgsa5LrLRMwnTBAtLn8rn51nYV3qk0a3
X-Proofpoint-GUID: Xgsa5LrLRMwnTBAtLn8rn51nYV3qk0a3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christopher,

> Is anyone able to comment on the sr_mod / cdrom / mptsas issue I'm
> experiencing (see details in bug)?  I fixed my issue with a one line
> patch, but I'd like to know if it's correct and what I should do to
> have it integrated upstream.

My concern is that switching to MODE SENSE(10) by default could break
things for other devices.

There are compelling arguments that we should use MODE SENSE(10). Most
ROM devices appear to favor it. The specs allow both but MMC3 (2001)
mentions MODE SENSE(10) as "shall implement" although it doesn't go as
far as marking it as mandatory in the SCSI command table.

In the current code we fall back to the MODE SENSE(6) command if a MODE
SENSE(10) fails. So if we change the default, unless a device hangs when
we send the 10-byte command, we should be OK.

Another option is to allow a fallback to the 10-byte command if the
6-byte command fails. We currently don't do that because MODE SENSE(6)
was required for so many years. This way we could accommodate devices
such as yours without the risk of changing the default.

The good news is that the "consumer" transports (ATA, FireWire, USB) all
use MODE SENSE(10) by default. So we are really only talking about
changing things for SPI-attached devices which typically are
well-behaved. So my hunch is that switching the default is probably OK,
although I would like the 6/10-byte fallback mechanism to work in both
directions as well.

-- 
Martin K. Petersen	Oracle Linux Engineering
