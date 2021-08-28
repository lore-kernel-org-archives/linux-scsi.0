Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3530EC4320E
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 138B760F44
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbhH1Cd1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 22:33:27 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40358 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233176AbhH1CdV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Aug 2021 22:33:21 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RNO4ib001893;
        Sat, 28 Aug 2021 02:32:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=7RykHyQnAhTduspCDOfq128ozhhyArQ5BbqV9tQAgh8=;
 b=EuEGj04cFlpZEGNEZk+zcTynGG27dIIVH/mp6WG2eYOqN3qOvinQ0nTVXhDxJ8D4XZ+8
 skOP0ylG9mI+yIpGF4qQ8WqyZ2KMhPzLgqDBH4HxoT7/la9VZ4w8aEXBL4LBVOEuyEYa
 1zneCRfY/oK9ma9rEZF77CIF38h4pORCtYx4z5q1T1AQJDOPvGdvWbqxkBudJu/r+K2G
 Q/SZUlp0Bx3/vnIK3aqLGJmugHtmIiEfmg5GDdGu7YEaHdCgpyHBrvn9ioJ9sApikTLf
 6Rgy8HTf6xPfUjk0PalGb0VgNqYAobBIzW5kB4luEKFmKUEq1MYCvTaYNEsBvWuXqTB1 iA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7RykHyQnAhTduspCDOfq128ozhhyArQ5BbqV9tQAgh8=;
 b=wJRpYnhNohnycNrGRm0FyXYEi/PHMcO5Tq+duhTqEajgvjx3VxdRNMB8cpwXyw0AMfpI
 jcz5L3oh/HRo/+UUCiXZ+NZDnRtlRoArPhiCaSRU8dzDnya16k0a4ZtugsGiYT2NJoTi
 MbpbBsA/bU01ZZI0XMmqSNJ4KfwoVEJUsOLA7DNO48vGvTaWTO6kwtFmnRljN68EodhE
 yu/XtHQyIJE3ZCa5ZWdfQOCcPQvgILJUh1VotkvYbb8WSOp31sH04E2mOyDVyov7iEwx
 5b0bGBfDhc/O8fZ/+O5ScMbd/ipho1ZfeZlgTMPsqGB2O/JrRhRG967mbfAXxW1BMgST pQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aq9pmr433-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17S2FccJ147242;
        Sat, 28 Aug 2021 02:32:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by userp3020.oracle.com with ESMTP id 3akb935rf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LcTol6nsUoIpLcpG+eJxKA4tL5FtleLZV/yjmGWGLe7km/j5XhHIwqCOgyojWS66XLUem017iRm/DtSbth5Dq+SMYspmJZSKp7/JBGTD7zN6tX/n3aFeasBd0sc2djRh2rtASBgXbcq4O02ZbMJdMSQa8gPvFHMjoOXjjEiNC6dlWXzh5xC/Xxg2qHAGeWVgfqlVAaXDqD/DuuAuk7+1k42o89egbdjc9hh29cknzkV7r2oyTS8mb3eSaHXo2y5MkjHgZJFto4FgrpzLR/FlBA8RrQPslkZ7+QN8DW/r4eQieblqqnGdL3mFVBsMy/cXXFLAELrQn2MRMkq9iYzM9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RykHyQnAhTduspCDOfq128ozhhyArQ5BbqV9tQAgh8=;
 b=EvM4ggfhwUtpjhpCefHbtYKmwVW2zHNgYWYCTL/b1cNbdlBIbNHo/1Dx0NSSi63YtN8T11PfI8t/fPAceMcDIaCiDwnFtea3Fftw2+bivqZrDBstoxn/puSiwg1WCKA5mwbBRgcCCq8/ktNPPiOppRi5aQz4FYyo3J6grhGhngVgD7XSXMZsTDYHp854pfdnBcx5fVJuwhQ0yXDr7DV9EqTBQJsub9muNcsQ3H9bVX/wL2t+77QyM/2iKcH8dGFiokFetdoXxS9wLsbjqZTPqXRDO+2ST0eA0l1DVfCOztPj27pQYxl67K4vvgy7St2kW+NWKghCO2TGlcAE+bWc/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RykHyQnAhTduspCDOfq128ozhhyArQ5BbqV9tQAgh8=;
 b=BLBkvTCBMPf1FCGV3o+I+YoOO+ICz+VjOH0tNuXLKdBC8rPkajKloAxaDJOsbGfAVt2CEgV+3iNczYHefM7Cy4pg5zfDdDPSVDtcEp7bZSYzn8x7/nlVex8yZZpLmP8yIiXG8KLHbum2lPkU5hmyvKXArdbrJyJZf/VmIhwj/qE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sat, 28 Aug
 2021 02:32:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.027; Sat, 28 Aug 2021
 02:32:24 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        jejb@linux.ibm.com, thenzl@redhat.com
Subject: Re: [PATCH RESEND] mpi3mr: setup irqs in resume path
Date:   Fri, 27 Aug 2021 22:32:05 -0400
Message-Id: <163011776502.12104.8461093134308241187.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210818081755.1274470-1-kashyap.desai@broadcom.com>
References: <20210818081755.1274470-1-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0025.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR17CA0025.namprd17.prod.outlook.com (2603:10b6:a03:1b8::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Sat, 28 Aug 2021 02:32:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da2d149c-c155-41bf-9072-08d969cc11a7
X-MS-TrafficTypeDiagnostic: PH0PR10MB5515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB551587DEF9ADBA3EEE69C4848EC99@PH0PR10MB5515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z9MjmQyWtMYwkLus85Bv3ZDhM+8Jht3lzdUT9lsyaEJf5IG5agmN/eLosxOvzIOYSlpZ1SV4gh48u9wj8GFflLnQ8mm7jP3nAXKi2ySF72zFbaBoJJQzphfgcbaZd6Sdd6mz4xzXHikoZjuXsiLOjjTEzQdsugGINUDIQ/sNC03c5eGhAb8ZaEqhd/3k30ak9KfGcmDM4ZlfT1Hjcre4rHkfh2wQ2auFHbxspvPd7nVSsmSOl+xw7orfsvjq3PfPMfD+NA30rmwht27He4pX8cnuEkdEv5TzoTa2KV+UOvT8SjbXdH+Nr+Dn3Qt18DLKtBQ12Z1oNWwKDPoh1mIzcLBMIToRDpmgBxUjINCHGlXdpNPRETR6mkmOwLx3j7FT5azifHQt+SnmN/188DFyws/G1nF2WQwtSgRf3I+u3oiHZJAQfFPr2QnX65jYPn8Es9qi5PJ2jedjfz+Rz4pjhmpZ8bpqk4PVZyvkXwRt53qhXojZdpqfWwqE5T+sDlj2OqCIKsKhLCF8ZNDXNHovS1L6gjUYqGWJz/PUsdRYXgC4Wk//LzTAHLcTWoJL4wJqwkCj3EayYQqxkLIwf+h+M8lBZQW4HVVzX0tmeFmtKW8mmlZd2y/uypULqgz14+yutUcWSb362sX5HRylahMXZ6LllEHldkmDRcGAuJzC/0/MBMD0QeVfbBMRGLRHbJeDgse2hDRB7W6mv5BrxRXdK/tbCSwQ0ZV9Fi5HabvmKQK708sGZPPx7i85ZMhEpte3qyFVaNrmtmDl2PtOaB/RgwwfqSZylLrAVvqUqQCtpcCEe1+pCbVYC5FNSOnAhL4X
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(966005)(5660300002)(2906002)(508600001)(52116002)(38350700002)(38100700002)(4326008)(7696005)(316002)(36756003)(186003)(956004)(2616005)(6486002)(26005)(8936002)(66556008)(4744005)(6916009)(103116003)(66476007)(66946007)(8676002)(86362001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGdPNzR4eTVlRUdMeVU2UnFVMnhrNElYZkhzd3dqc0l6WDFPcExscXN4dEps?=
 =?utf-8?B?NFVXbVBRVHVtdHRUNDF5bGNLWWFyYWZtS3llUkROaGZudGZiRWdMWFBLT29a?=
 =?utf-8?B?eDhrRXFOdm8wVEdCSHNmczRoMTZHVmpzYTV3NHNBakF4MW5BRmU0Rzd4RHZR?=
 =?utf-8?B?T3lacE5hN0s0MzNFSGx2YjFOVmdENU9lQWRQZ2tKOUJBWklGUVlsY2U3NDJU?=
 =?utf-8?B?bkFzQ015ZC8wZGpNZEpsYUxRL2xzNGhPdU4wYngxUVBuSWNHOTd6c1JPSFVJ?=
 =?utf-8?B?R0pYeU5RamlMb3YzNGpYbW1OVGtyeUl3OVc1T012RldMQnM0N2JoRTNQSEY3?=
 =?utf-8?B?NzFUWmdUS1ZmMTljWjl0TVlDZEpBVEJGZUE1azdrWHFDcllwYXBNWWZ4Witn?=
 =?utf-8?B?N3dHcGcxQXZrZ2JDekN3TnA2Q2VNcm9sNkMxOGJ5Wm1id21EWFo5WVh5b3Fs?=
 =?utf-8?B?MzVpRlZ5K05lSEJIV0RPZklZTitYbWZQTVFsbll1L213YUlVQlB0aWJjSlFl?=
 =?utf-8?B?Z2doTy9WZDNEYlI0aG5kWVBDUVJKSWhvd2lSWHArVUszNnhhckRucUVMTHJH?=
 =?utf-8?B?WVpaWElTMEdIU1FQdEUrTTMvVVRJMkErZGtjL29LREluSGlrN0Npa2tpekEr?=
 =?utf-8?B?ek9NSjZLcFhUUVFEYnVmQlFxYzdDRHlvVlJ2WjZ3aFZHMEREYk9UeS8weU9E?=
 =?utf-8?B?M2ZQVEg0ZXBFcnhzY2dLaU0zbEhvSFZES2hIUUJZcGkyN3Rhck50NmZuYTB5?=
 =?utf-8?B?cDNjUTllbFNYVTRNMGJGQ0hsYTliRm1RSzFMTTU4TU9FZFFrZDNEUmJYNi95?=
 =?utf-8?B?SG9WZFRCclp1VnAxN0hwVHpCdlRhcjUxcFBCZ0FQbitzUm9FcFVZaWN2enNq?=
 =?utf-8?B?L2QwYmR1alRsekNxNHgwSVNNYnY2S1RrdlJ2dDdLeWwrWVdiSU16YVNwc1FC?=
 =?utf-8?B?UFk0bllUcWZEMkRWRXV5UUtvdTBhR0dnK0d4SjhwNTJvb3Ryc1Babjk3Yzh1?=
 =?utf-8?B?UE1Lb2J6dGU1Q2NKRFFuYkoyOVhUSEVER0tsckJ1Y085cnhVaHczd0ZCdlFi?=
 =?utf-8?B?V3VWTGlxOGZjRzF4THJmM3dFN0pOYWx1NWNkSGxTV3U3blhSUmE5dlV3Q0pi?=
 =?utf-8?B?c3JwdmxSNTF1R2dKNnJQRGZpOURCblBZY0dMNFJZV3FSSFd4eE1JL1J4RGor?=
 =?utf-8?B?SUZJVmk1VEFpd0VLS1RMejhPZ0R0cW5pVllBRTJvYThpV3ZUb01wRVFnaTJq?=
 =?utf-8?B?czdqVEN1Z25sdzd2bU11Vmk4WEs4L2UxNHVTbE9xdVFLZWZiMHJMQ2plUllO?=
 =?utf-8?B?OWcvcU1DMWlOb3FmYjZ6VG1FcDZwT2pwT1NRVGNXWm9IRzBwcEI3S04rbVNZ?=
 =?utf-8?B?NTFDWWNPTjVmWTQ4d0JLT0RITkVaUE5CQ2FsSXF4UWZEdmpaU2t2Q3hFQW10?=
 =?utf-8?B?eCtoOUg5RkI3Ykd0WHZQYnYvaG1RR0kyTFN1aFA5QzM2Ykx0ZDhMOVp5Wmpr?=
 =?utf-8?B?dlYxUHpaUDFjMHJtN3NvMDAwWlRVRXZPL2loU1ZZUWY2WWRsb1k0dS9ZRFc2?=
 =?utf-8?B?LzYzN3E3cW9NaENmeHlYTDJUUDVlTDR1ak5ZNkhORmJIME1ZelFjWU5BeFFC?=
 =?utf-8?B?RzBaWXhWMDBLMFlJd1Q1MW44V3VTYzF6SDMvelIvTmdldW1nUGNVSnBJVmNE?=
 =?utf-8?B?THhQSzhDSTZ4UHcwQ1lhLzduMEhjQ1FUVWhkckpTYWh0ZlNuVEw3Wlh1SDc3?=
 =?utf-8?Q?MYEYZrsKs7cXE1WzwKiQNntMUtF1O0k1jwvr8p+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da2d149c-c155-41bf-9072-08d969cc11a7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2021 02:32:24.4445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JvD5XVuHaEL0oG+QERzlAaocSRR7atz/gFLkKPz+RpLrzvwl8fD4ynhX47lmWzVc5BgK+wfsdtORt3/fXAzPKkWHKuVWAzDKNbgdUrN8nuU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5515
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=936 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108280012
X-Proofpoint-GUID: dJMbDk2VlQhaVcp6YWhcLm2wswg7qajV
X-Proofpoint-ORIG-GUID: dJMbDk2VlQhaVcp6YWhcLm2wswg7qajV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 18 Aug 2021 13:47:55 +0530, Kashyap Desai wrote:

> Issue description - Driver is not setting up irqs in resume path.
> Eventually, hibernation path is broken and controller will not be
> operational after system is resumed from hibernation.
> 
> Fix - Driver should setup irqs in case of probe and hibernation.
> 
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] mpi3mr: setup irqs in resume path
      https://git.kernel.org/mkp/scsi/c/0da66348c26f

-- 
Martin K. Petersen	Oracle Linux Engineering
