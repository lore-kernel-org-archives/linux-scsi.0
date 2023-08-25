Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A65C83F08
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 23:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjHYXDR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Aug 2023 19:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjHYXDD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2023 19:03:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDC010D7
        for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2023 16:03:01 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37PIEIv4010982;
        Fri, 25 Aug 2023 23:02:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=NBnB+V1sQqesXepajJmHCWyd9M1EnCXIlDRHTmTufpM=;
 b=Fdy7d7q/2GUVZ3oDjckX0FGXten8mr2vhXQTnhdRmtBCmqIlodS7AHWH5HSia/KICMXI
 F2scvYNYVS/sLVNoppLsIdpLkndYQ4fJ2H7extfx9iNlK564L53Uf3KbyEevl93dRB21
 wHWijvGe3/hJZ8PxcSWqw0dJfGGgvQ3gB0Q5ypO8x72S3CyNPb3Vyg68UGXYY1JVHLub
 Wd2ykrUACnGcYBYmeN438txIW3K0D7zcjy2k4tUC3mmTsVAzH7ZoLpfL38JbyJIcFycq
 WnY6ybDZXI1YyaBn/EyGq/j2sPJ8KF2ag2tbpYRpISKV/rpV0rR3IHYtCeiDrNBIm9C4 pQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn1yv7f6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 23:02:57 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37PLJa6w035695;
        Fri, 25 Aug 2023 23:02:56 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1yre5t1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 23:02:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dlCjaTd5yn3Qpm+K348w+R8x8glWVh/OJgrpyTw0qbKzxdNOUaiJOWe7OuMekD4bl3Yybf5k6sAUBqz+Fstfz2C7HZTMTxpDm+oz29EAjwMX9IE7oWp7VdxdXT6OahcUAgukavyqTKuyuEcsPVLBUApsjFSzlHgooB8F7uCdcb76fD6Kol5cGRjsWgcXTefunwHpjMJkD/M+8lr+y80oB8AkfrWKsvG+iayc0ckvio3pRWXyctyj3gzzWzj19+MSidx3U1yYCoSGLF+xccMfaUWLqZvpxRPz5LE56fAC4A1IjfSs38x3pHROJRJkJsL9pwKS/C6Zjxlc6yae/mcdDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NBnB+V1sQqesXepajJmHCWyd9M1EnCXIlDRHTmTufpM=;
 b=hdwbXZwOHIzwdgU4+tDdhsOMkIiz0KHV7bCgUZktZOtIGRpMsQapFlWtqJ+ibERXF/z9BIP9L4WPuygufQKPQkhuSSW1Kcr+IGnM8gsVMOQdOSkctd80y55dlZQin8ewMgfM3833rRn8j2wSvFqS1uNSToQnEwXU1Uj2MWlEawYDCpElOe56D+7xRzZsh+yHYJsZ3GPlPCzegN6Jyyv5BPzneVCbMrmlhH+G8FzUs4/LcIG0WAtC5iqlSvM6VlVu/vDMK27vo2J9YUolT+HssnerFc//aC6A98QB2O5CgosxuiH3xdD7HmPR8b/irTJrDyzvaY8D4hm/RN8qyS0tNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBnB+V1sQqesXepajJmHCWyd9M1EnCXIlDRHTmTufpM=;
 b=QsXLhsIUNuIew0xWMrU1XnPEd2oCmsytullpKylWFAr7glZgw90VQGC3xEqHMXsYzGdAukae2zGJfJtOVJcG6d27dU/fIDcVQtdiY0XimNgNftddqGWZKpPCSwl71O/ztNRr+4OCdLL2sXFWmRYzrC8AA9DtKtc/PVYfJ8Xs2Ro=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5878.namprd10.prod.outlook.com (2603:10b6:510:127::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Fri, 25 Aug
 2023 23:02:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.034; Fri, 25 Aug 2023
 23:02:54 +0000
To:     Daniel Hofmann <dan+33553920+linux-scsi+vger.kernel.org@latius.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: Optimal I/O size of 33553920 bytes should not appear.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15y52zrhr.fsf@ca-mkp.ca.oracle.com>
References: <15dec4ee-9b2c-66b3-35fe-333add83bdc4@latius.de>
Date:   Fri, 25 Aug 2023 19:02:52 -0400
In-Reply-To: <15dec4ee-9b2c-66b3-35fe-333add83bdc4@latius.de> (Daniel
        Hofmann's message of "Thu, 3 Aug 2023 11:30:45 +0200")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0001.namprd06.prod.outlook.com
 (2603:10b6:5:120::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB5878:EE_
X-MS-Office365-Filtering-Correlation-Id: 73cebb42-c2bf-416a-940f-08dba5bf6a48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9KIacMWkN09V2+4F0XFigFAMFj9oWZj3MZ3+Exx0LBXDjWk0ToHZT2v/W8qLRHvTJL5HG/JJTeBFgFjJ7uzAPyB7UjPdJQH5XIz+MFCDIDKm384Qy3PWtqMRhspe7H05PtZGvmJ1l5c+/Cx3XUxEPOeXdyCGI1GbZed0bKOK/qKZi5ung+DydGkG8RmU/oaQFJ0K7EQjTEj1nFTZ7aimEVjD4KJGTMspW7OZDnhlj0xffnUwNG2vLcRPt8KEIsZ8og/cOvZYk8xf+xjq69nmG+3Wb2/HjyPrs8EC3JfIK7Fz8F1cHzYHkLobzthYbl52WC3e7LzoAI4eVXCYWKZ1mOqUL5Ag3DT6T3QjgazJ81V6OmATnZ0LJFGEa/xIdRzfJGvFw7D0koVkcQPZojo/qIvGPpytY4AX6lHjcD4p2F1aUbT1DQ7ZmMSd5umEE3KyjrcaebZ0N9aK5l5L+rX0eDzFqyRoZmOmrGRVdurWjU6Gp4IZlIhT4GpYngmPOLAN2/mGNOobljQG23Tea9fJWRIz1O38B6fT82CpRC3ZmlI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(396003)(39860400002)(376002)(366004)(1800799009)(451199024)(186009)(86362001)(38100700002)(6506007)(6486002)(36916002)(966005)(8676002)(5660300002)(2906002)(316002)(4326008)(478600001)(66946007)(8936002)(6512007)(83380400001)(26005)(66476007)(66556008)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o2tn6wyGWfQ+ebmD36Ly95ANO3uLQT0ulKRCtOV/NAos5tUcRhxSDbh+ISwi?=
 =?us-ascii?Q?WvH6BuRok5P8cwcpG7ETNEyDx614wf56Ec12m4t8p0D918NPXDuWJU1bvytt?=
 =?us-ascii?Q?Y2WJyNX0omHCFRyw25vNcYChibYYS3RpAcDmgLdWdmKyhboQjKebigJPHo6j?=
 =?us-ascii?Q?FUm9BH5TskWH5hBOqQK0p2yYI47PpRKUoh+dDhU1EHYAGef8taeo1gt4EWA0?=
 =?us-ascii?Q?8DsX7cfTYZrUqfLCtXVO4t9j6eTBeh34zOP0jGlY3vw7czyVhqyJKp/dRudB?=
 =?us-ascii?Q?CHlk/jm/hX/170R5oiTN54UhCGz089sM+zusQl8JHfnimMqdhPv6T4jZ49Cq?=
 =?us-ascii?Q?Rt+lGQp5Y1eiHNCT0SO2gnqEF46Bq+zobqGIeiINvZQbvngmhsJcnjw8Zj05?=
 =?us-ascii?Q?F2SPCqbkirOVqiZOTANnC0NDyIOBV1FxmM5EA+SPChRJO4lx+N5LoyspsIIC?=
 =?us-ascii?Q?5ptvD9OY9AuMHDqEJgdmwcQc1tDZ137THWfjbEE9uDd3G/Peaw9C0RvSpyO7?=
 =?us-ascii?Q?xobDktZGdb8EcqDsqdRnp49uYa638yNZlnlwXhmjx6sFCTo/4q3Rcn1SBWX6?=
 =?us-ascii?Q?/haxcfkK+xveNPNe2hOXb9Vm7P5VHDLD3Nyf3VvUzDPH7jfRJtP4pOmZ+0Dq?=
 =?us-ascii?Q?RC5Au0bN6Gg7bo7g9vR8TC/27/LHJEreGpgWj6wgUT74KzMiBCeCfBiqG00L?=
 =?us-ascii?Q?EGdCeyFUQjeq8FwtVxhfpRi4kkgNrStSiJVYMv0gkQf8e52N+/Kw6JM2ENuo?=
 =?us-ascii?Q?7DRDsvqLFB3PfHPbTQcyyOGAseRlBFfBfdZVr2UyvapSa50+ZiuLfL5XqdUK?=
 =?us-ascii?Q?Wn9xQXNSd9GsYQN35S3y4f4Kqn6ojDf/glpJbN24pyL0KNbaYa+w5AvEdSog?=
 =?us-ascii?Q?Ffp0yNS4ocFYusahyJCKtzrFxPgebeUOU6MiU+FHjzUC/yyRZgoMZjEJ74qh?=
 =?us-ascii?Q?AKoyyZe2VANdZpiJuPu4f/NdAQoeWJ/rddFzJCpA/EDwDTweVqFjtUFq0ow9?=
 =?us-ascii?Q?7UCC5oNTPeL1eqA2Xeywxdw3qXPxwwJTaEuPxy5c20HPygBzXUSSCTSIom+E?=
 =?us-ascii?Q?HzWAgllPXpOANt/rT6iAEW0LRXiTv7pSEGNnT7V9AWl0AMRn/NrSym7cbGBf?=
 =?us-ascii?Q?2tTjTdgWSNCQw/O1OGDwXNHZDJlTBQ+zmMbxj4RHrJCjHAeVCzPJJZYc+Nqc?=
 =?us-ascii?Q?mQsueSV7pn2TZkMWbMljlb7xwsBVw8tlRayFccJ3Vti1EPPAcNQmuVTWinTI?=
 =?us-ascii?Q?Yl05Hx1JSXqe04SH+7E48EEDwBYQzP6TUFs3flzulKyuhoL5DvpLPbcYyTMu?=
 =?us-ascii?Q?qWrJVRlVBaMI+fBwrBp3M5Q9J4yonDLMI6Sw/vhtpZXl85ICFDj9IuBrZYW1?=
 =?us-ascii?Q?RDg0wqzZTgaeLgq4TQftS9YSPoZ0IabPkzAwkNStZs3rkql8RmKFKdLI4uBT?=
 =?us-ascii?Q?LjC+gVaSGQf6j0QEAoigaf+6HdZm2VL7ewbOWNmuz3cF4+zJJSUZoTERjRhV?=
 =?us-ascii?Q?JvAYq1fv7cFfgiJW/AXOe2tGbdPFT1jmYA+G3JKLzJRO+0w2okH1m6uQqUy5?=
 =?us-ascii?Q?U5v4N/I1Xz9M3C54gSxPi/i0HWiKpqPgqo1BQ5KkPtx2YcyegWSIF+sDJnuW?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: pJg6zgZhXywk1tNRLAV4U3RB7siCq5cJOSFFv3wS9fMz9pgVDTA4bSS8b1y0NlzwfmnogvXqAUG9ZNSqN8d+/IP5awGdsQ2SvCBK6g+5GkvamDlDrV/JIZZPYNALZMwxN3tBjGwQSYpbHrAl+tQBj7IlilJGuA3m7kWwsEEHlKogH5ZtHhAqc+/tNlRQlVYn2+p1Ma6JsPZEzg95RRmr7L/uviCfcB1SwZv0NbMSuiw7RaUspm6oXIwo7WOEz9WLPJKhDTh0JF0tsVTvsZyVsLVPVMJQRSmT9rcBI+mhGjqUu1u+RtMWyjL94KFvgeLjS47uqYFJ/9OdcUTVlxQQYsmsIQjH8In7weJX+o4khxWxCuxBDFA2WS1vZsQDxGQqQ2ZPapcDhc7AyvndzGY98YWwyTXR0k8YqY7kaZyLifeQx1e5vtiMBMXlsdjMmjKJ9kysJd4Vz4CAqlBEzvDL2AFb8LJLlFY07ZQINlXq/Q9a9v49A/rrj7+ob76ys60C74U4Wtpkp6VbDAmL57PUL2WuEl3ywmVyPfxix4iICmiQgXWoPw5XMmsTZPrI20ksO5S1/aEc1RT0+d7L2WuZsYVZ+IvG+K1zK3ffbKcoh+kl5cdHbuHH6kpAxJKWenD9ew+z6wVmwFEIHXoGUKKebMtfOLiS2iDcmWOLzp1C2OWUb+wNdnM5V9Q3It5D9ZNwhycQU5y6rE0l1GtvB2/kfrM2E38A0vDk4piapfXC0rRc5r7DxIefe7uyioq0s5zrL2xLAUfrXU1NoSDGeKDu+FgxFqIptKsm1S6209mHAi8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73cebb42-c2bf-416a-940f-08dba5bf6a48
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2023 23:02:54.4464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fmwj+XxRrCFK/r7S0eWoSNryoSjgE4kGDyoSHulBNqOPUUE8mKmetuBLN4sJY43RrroQorlDj+jWa2hhrmM5Z78SeW0yie5NeLOooa5Bq5U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5878
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_19,2023-08-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308250205
X-Proofpoint-GUID: KzL7cWf-MJNjftN9F9XZJg88veCqbWqo
X-Proofpoint-ORIG-GUID: KzL7cWf-MJNjftN9F9XZJg88veCqbWqo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hello Daniel,

Sorry about the delay!

> The reason is that there are devices in the wild which both report
> sdkp->min_xfer_blocks == 1 and sdkp->opt_xfer_blocks == 0xFFFF.

That's the first time I've seen that particular combination. Most
devices will report either a physical_block_size or a min_xfer_blocks of
4KB and the intent of the check was to validate opt_xfer_blocks against
those two granularities.

> It seems that sdkp->opt_xfer_blocks == 0xFFFF serves the same purpose
> as
> q->limits.io_opt = 0 in
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/tree/drivers/scsi/sd.c?h=6.5/scsi-fixes&id=06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5#n3453,
> namely: to be a dummy value, indicating that no specific information is
> available.

0 means the value is not reported, 0xFFFF means the device is explicitly
asking us to send I/O in multiples of 0xFFFF blocks. Which probably
doesn't make sense but, given that min_xfer_blocks is reported as 1 in
your case, could technically be valid.

I would have preferred to check that the reported opt_xfer_blocks was a
nice power of two. However, there are devices out there which use
internal allocation units which are not power of two. So that won't
work.

Alternatively we could make sure that opt_xfer_bytes is a multiple of
PAGE_SIZE. I'll mull over that a bit...

> (Additionally, it would be also possible to test whether the size of the
> device is divisible (without remainder) by the assumed "optimal I/O
> size". If it is not divisible by the assumed "optimal I/O size", it is
> quite likely that the "optimal I/O size" is not useful, at least for
> alignment of data onto that block device. In this case, the validation
> should also fail.)

Unfortunately that's not a reliable heuristic since many devices report
a specific capacity requested by their customers which may not reflect
the actual capacity of the device, nor whichever granularity is in use
internally.

-- 
Martin K. Petersen	Oracle Linux Engineering
