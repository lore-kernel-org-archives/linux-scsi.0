Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0658AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 04:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345914AbiASECa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Jan 2022 23:02:30 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:44502 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344750AbiASEC1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Jan 2022 23:02:27 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20INx8f6002474;
        Wed, 19 Jan 2022 04:02:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=LU6DYS8Vyt2BVqGUAJEdGlTGeby/xlb6OXjSJF5HpXg=;
 b=tBeRNEKuDJH5SfVTElJAtw7mFo03WzeMBxSbIEu1rCYhv410WFwKl3dtRUWFoyKvyKqg
 M097G2Aawy7zwFAAByNtNk4wwvSTnfxkWfkoUuDXrikK2/YTEv0L2v6JZmoawMjUlCLX
 Qd9VVMw+TpU2qvXULwcM1WMEb6oPiA1ZF2mVF3dYpmW2FacR/NFv54xBm1zJRgGBmL5u
 wMCBMO8eZPBiUG3FkL96NxZbds0oho3cdpdD715DITMHS4slqFtGPeTXkG8/atXJcAxZ
 t9Y/XlWg0zk6z8cX2eQPSbHCtMHI+xvTnGojz2ShKwgxS39NgEVNGeiDdmcE8v2OFFJh +Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc5f3tam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 04:02:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20J40PXA155261;
        Wed, 19 Jan 2022 04:02:24 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by aserp3020.oracle.com with ESMTP id 3dkp3593ft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 04:02:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTa5ITcuI858mWWBVfFCRYnwW7Yi+1e/X/XzH1r5ZWybqgxnzibFJG/WXGdNJrYG4iKldzy9TIU4ZGZjvLhkLT80cqZ+LYcEk4T+k7vS6TE/STOxA61XABQa8u/EC/I4LqmTPiONlVT706N7MRirwgaz4Cr6XxR7abxvyk+DNZ7VP5yVeLhgqCB6a+SWlM4ve+JsrWlCA+YKSQAXltpWvk79FZJEK2wafDKSyjFZknerzgK7urO4SpYyNVFgMzAXyzdaidPHUkTMdTRQInHs6SEHVUqUtabMeTdzA2DWJxsC2KAibTCwwkyuscrsNJ3M4c12COrRPC8SKv2tNMARsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LU6DYS8Vyt2BVqGUAJEdGlTGeby/xlb6OXjSJF5HpXg=;
 b=grKyOxUTKOaOr5swF5D7yeJNcnPcMaht9SPPlMmndh63FONl57+wq8wgK0mvJ+0/Ln6tQNrnmRipTC34ClEK3bqblpctd/+6YNskrSzk864ClKTYpAsg5BmLiG4RoT7xVvvV2iim7AL68y8qX0KI9cNFcCX8Ni3kSpdV42ik6y0R58KkWwwuDsLuZn6SEucAmz9GfCVwnNCiZF/wo6b9lps5cC7/LJy7tvCYYGb4tJ9fFI6v6VO/bDTcMPGyHP3OXpAaGcqlsFr0DULX7RQp3RgBHxJVMQSGKWeIqvr81L66J29jH/fqDntYLpx9NbdcSJhxWvwNfJ5mZMSCtg3A5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LU6DYS8Vyt2BVqGUAJEdGlTGeby/xlb6OXjSJF5HpXg=;
 b=MFBUGspeUBFXRvkd4qG4l8xcAeGDjGZyhDFh+Nwt5dqRjUtLLhHNeYHL84j0cccqE1NFTW9P6o7ze5XTPRHrBJl7bLeveiWju+sjHbo2mcXkotSQWCQlu/v/PTkL95cjkhte8VZQA3poqK6spNi6hRdprvIUtKt8zdfgV5nEoCY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN6PR10MB1410.namprd10.prod.outlook.com (2603:10b6:404:46::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Wed, 19 Jan
 2022 04:02:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166%7]) with mapi id 15.20.4888.014; Wed, 19 Jan 2022
 04:02:22 +0000
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [Bug 215447] sr_mod scsi_mode_sense() failure -> "scsi-1 drive"
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135lkl6j6.fsf@ca-mkp.ca.oracle.com>
References: <bug-215447-11613@https.bugzilla.kernel.org/>
        <bug-215447-11613-ADkPpujB9c@https.bugzilla.kernel.org/>
Date:   Tue, 18 Jan 2022 23:02:20 -0500
In-Reply-To: <bug-215447-11613-ADkPpujB9c@https.bugzilla.kernel.org/>
        (bugzilla-daemon@bugzilla.kernel.org's message of "Sat, 15 Jan 2022
        14:04:33 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0026.namprd11.prod.outlook.com
 (2603:10b6:806:d3::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef574c44-54a9-41fa-69eb-08d9db007e91
X-MS-TrafficTypeDiagnostic: BN6PR10MB1410:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1410B98339B56D6AE614FD528E599@BN6PR10MB1410.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CWAAmLac/oVu5hkAnYQv+pb3ExWmvF2csujv0aCRf7XTltBu64EwkCWrizrUvRctHbAloaBi5AKbaFAqKE/fpFfa85/YehO6NG74wxdUXLRx24W2etZPmwJ4l1PiCgKI/N52jx8fPye0/6lfvldOOJQjVyuwkjgOnPRGlTnQu+k9Bw/maLqnyhG2ApaCQdDWxmKyOuJmvziHQS8RsRWFjQvgIjjZ19yUFnLP8d02wLbeJm+z9x3dl9difa8y+CLTscflqcLAbwDKSFPHVrTX7Z9T8KqAquNNHijcE56IBDmxuj37Lorq8HRQV8CB2ebuXqwGYW/6silVjfQrvEY+UJhYYcskXH1Har9B7LpMANZmYgIDwZ+LKwIX5WpBVzfHPxmYcSEtUOkWZzH+dOkC7976VGCbXMpuP+urJHQWE8+AvdmgR9FRmxmnvKMMulMwD1GQdI+1wq9nnfaSdYCadk1j3OMgMgIrBhX3XPtAWg+NYq8VJrHK4IH3UQwidRH+ZkUF0ZQPBDvv95G4TfyGpRUiygZEzmv+nMyplWjc6kYuCCtG/d0RYmZumGEDC3cEuIThjN3SUlHxO0Dex41ZaOrdgO/af0uets5ADqzu5+52dtCxDGjFhiZpEd6xT268dazt9oth5nHtmMI9qPyN+8OM5e30c4np8xpI7DChe9CzDftgW0RgZmDAqKpzu0soz1TZ4irKlOK3Y+K2pIDeXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(508600001)(36916002)(316002)(2906002)(4744005)(4326008)(6512007)(66946007)(8936002)(52116002)(66476007)(66556008)(6506007)(6916009)(5660300002)(86362001)(38100700002)(186003)(6486002)(8676002)(83380400001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3m62SxPDg3cf9lQ7IL35x4atO8Ii36MmN0IT23GF9EqUXRRGDf14fSnmIy/J?=
 =?us-ascii?Q?NOFnNGiwC7jAA+WZtlzSQGwhY6I5cZm+cfn6ngAOh0kIw7SKgPN/+tbQePuM?=
 =?us-ascii?Q?6isTyeKWrJMasoZ0g02TcoqyoW0anxdILwjkiodz9hVdPh8DbmswsIA/f4Y9?=
 =?us-ascii?Q?v0XaVIYwyweU57bK60JM/mKwBdkXmnnDb9z3TILPHlybCy+OkqMDGbWbwcTB?=
 =?us-ascii?Q?CvIpPApw3LU/fu0MfOSfzx4JNJt3RA8ytHyOsCGwhCM2JpUJFV+gZXkm3ZyB?=
 =?us-ascii?Q?+4tCGc8kVtvLWrX2fyJvNKPzqaes3uK8SQC/0+Q15Bd7FJIqiQldT8pvSsSg?=
 =?us-ascii?Q?wyiNILnsHnmD2z5V7oRvPFFBrOTNCy//KEsRwyQh8iwafj/P9jEr+ni8EndG?=
 =?us-ascii?Q?0SVf1sIvPZDvF6kgbCGRJLq1ymH/ckN6ojnDdaw4knrnVFIV6NxVw3P5PeAw?=
 =?us-ascii?Q?WbMJsQfTgtPRcxn0l6SOk4luQniVHLpOuK3iftVgjYNaduLA/5fOGNGK15vm?=
 =?us-ascii?Q?DxM477oPbLQruuoc93ChqPOSM+AUfQnLrb38j9V3fNoe7egsZhNa7jxk80rQ?=
 =?us-ascii?Q?34NX9R9rSoJXjFJGmyGvKgCzqjhfppN5g0aNxLdziWTEO5TgUzV6dJSSKdJf?=
 =?us-ascii?Q?1WC6VW7MpYGLsbLeQKQmHDMP2yzBtigq3SUMhkXe3NmOdEbh3xo4LUJUztCx?=
 =?us-ascii?Q?ofKu5WSRlycuYViJfawKpDlbJFfa+s7Oj3cmn95c+fTNrZEw2yYPkYbWOTAg?=
 =?us-ascii?Q?/tlDJU6TcKjBvTOBT/hw5u2g3U1KFlvZMic5F/vXxlpkKIh0w3Ix35SR+KHZ?=
 =?us-ascii?Q?vFEk7r1llIVTBzfleC45Aq2ebtI6vCKOKX/RwGJ8bqiYcrHLsdIvH5pDbowc?=
 =?us-ascii?Q?r8bJVtkxtrJC+n9BrY+ClDXyDhduwxi6549n5KWSYiNUsbQRV4V9yzlXd0jI?=
 =?us-ascii?Q?fRF+T6oViYuNvblJCV4nlxqbKKmdLq9DXA6VsUHlGuEBflipFF2ubyEsbfKa?=
 =?us-ascii?Q?p2ZBZgJ3jPto7jh3V12TmHM3o3wFMHk6DG3r7aWEY9HxmwMWr1Dcdeypc+fj?=
 =?us-ascii?Q?eRJyHv8XDSIVyhJVQrUd9hML9zKGz+Z/9Mnf6eHoOldSEQ2PHoEX3aykJvGw?=
 =?us-ascii?Q?XbDb5V6bzgyYGeEJ9e/KByjPXFweNmPoc0JZGEanrNAWcOUYg+GZJjog9DjH?=
 =?us-ascii?Q?58KjyVkMDJQH8uYxJiy6kARFaQQ9gBdrWu9lam99YomkrTjYuZd/DofnY7sE?=
 =?us-ascii?Q?sO6wgWqk94k0N+xowTXYBAyc1Tapa2SCx1wvr3+0uo370ZIV9r3464iOlMGi?=
 =?us-ascii?Q?62bSrasgSMUGOpArW7YwdgZKPNet7iIoXmX1ZA4nskGCQp/Y5TrAXDv2kB56?=
 =?us-ascii?Q?+cqRY4m10RIhtnh5lxLm3Y3RLspKrnZdwla2/6BRIK4DWsFnFqhLnLc4cQnL?=
 =?us-ascii?Q?XY093HtLKI9JAidToowQyyHiznDkvb+DnqZjMRyxvi5y6NFIPCgW4uNcNU/v?=
 =?us-ascii?Q?V6jdxMCGUF5FRi8FzSK/blDbwd+ezAwmJLC9CA5O+du2Rw+INvI4dlEPrWuJ?=
 =?us-ascii?Q?RCCHLp5pVnDdNdFhVlhNpunjR+eGUaqrMjgtqIOEnNJsxNi3GcYAYEbfCj9y?=
 =?us-ascii?Q?i1CNhIIEejifk80M0eGO7J8wonoYun7x4w55sz2lTWPfkADfbzGVIlRiglLO?=
 =?us-ascii?Q?pMKe7Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef574c44-54a9-41fa-69eb-08d9db007e91
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 04:02:22.0514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IhEmqE+A8y83NVMcq0V/wi5gwecCjlsNrnHwuyWvYvXSrVPLbPjb45cQYlGs+b1DgEXrzg98cOgL5cZSQAghjnBqxtsK6mStl+WRjA8nCzU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1410
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190019
X-Proofpoint-GUID: hax7LTjmWquNh1grYiXjZzuDuRp-RilR
X-Proofpoint-ORIG-GUID: hax7LTjmWquNh1grYiXjZzuDuRp-RilR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> is it risky to implement the fallback mechanism in both directions? is
> there a chance of forever retry? (fail 6, fail 10, fail 6, fail 10...)

Just a heads-up that I am still working on a reasonable way to go about
this. It is not entirely trivial to perform the transition from MODE
SENSE(6) to (10) given how the SCSI disk driver works.

-- 
Martin K. Petersen	Oracle Linux Engineering
