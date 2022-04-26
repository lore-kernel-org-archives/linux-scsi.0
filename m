Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5C38C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Apr 2022 02:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238697AbiDZC7h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Apr 2022 22:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234389AbiDZC7g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2022 22:59:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2006C344F7
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 19:56:29 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23Q0MJ9Y023432;
        Tue, 26 Apr 2022 02:56:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=8tCoHv0B/Q4aLyTJJSxCr+ibm9AuUnSZB8MrAXD+mJU=;
 b=I6aUsRSljOUmPwfjn9tdowXJ/RNk518ghP88IaDpB1U13UU5Rou2ZrOtFmJ+ZP8PUA+E
 lEsb/F2AVDGj2NmXjhuXvl7TuZClSUxPapaqJdbstAVl2WJuVb4D3wSFzhjY4daReuyI
 0pvkpzydJ7wldoGVtQC2vmNUcfcgBZxQFByvltDr9HvbFJ0oyIpM3w06Q+2RhM8Gg61E
 5rgXskZ6sWev4hj3X+qQOmHtbycD5JVXK8o9rzhsFqBbA3ftzg5jIsTVmd6NqM7aFFUb
 TK0bcmXS3vAlKPqR6hCVo3wvaynHdXhIvBkUORsw08txr4Mxn/kvOM8X3QN3dNmbiv75 gg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb0yvp67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 02:56:10 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23Q2kPJe001969;
        Tue, 26 Apr 2022 02:56:08 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5yj2ry5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 02:56:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFxmrWuwptSA12cHAxbUgBx7kKb6DCQ5kVL4UqHt4ydqe4uDwSZbwlv2nVyhu7fX8hgiBaqDUwECKf5IehA3bo+/SGdpcNDbMFmuo4ViR4kyIXKjsqfGRQSkzCqO5U/nck5piIzRWSIKNUWq2emU6SNweEDuVPdhVj3n3ODnBxWQK1hR5H+noXx/hw1YdhDE615u9AyohuRtfibIsFt8klu1qnaGfNeRim/BgvIS4ICstTTv/UNQ/vZ7fdw4rtZ4EgX4iCikybyi0P/AQC144lJQjQRqsG5W/27vqnj/RmeEWl/rlL8HrQIKUmH7TiRr/sVuAuilN5SKOS94NztNqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8tCoHv0B/Q4aLyTJJSxCr+ibm9AuUnSZB8MrAXD+mJU=;
 b=eSFhQf9OG/ryKrvd8wb0cWqXtL4shSk26TtSLxBcnOApT5VWEdtGLeQVOgJ8j3mP+SftL03uOPaCFJMX9jGt4g1iytYhEUkeb1JP4YTE5gle6D+X5nSeiLhSfq/mAyGeLTa9ydRbLW9EZBLtnt6uvXwfsWymg+wvxBArAz9jjo6qkgn368pMTyr79PF4WxIwiHpYlCz+9F2GTUb0VWNNfH6Ti7PDtOVK1TLu+05anwtAaFLigER/E45zKY9WEPEI+KrylZeSUqOmHGHfV8uAd4L2gXbGTsgV0rLv9B2jg1brzD5PDsvMOaCa+hw8A/o6ih0wyQ67Rv73d+WQ8o49Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8tCoHv0B/Q4aLyTJJSxCr+ibm9AuUnSZB8MrAXD+mJU=;
 b=Vjdv8hjuqwb8XwEsTULO14vlIGHjFXybSTN87gAlf668QwjkULmEj3hqxasj45t/jgHAZTKaehTH6y3501Q3m/IvY6C/oD5GEw9pX+iWbBnm+X6/N+QpyFWiOfeNOi1+ED4l/c7owZoRO7Ns/ZfVB39SAHrWL+BlgAuttEBehKM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4169.namprd10.prod.outlook.com (2603:10b6:5:21b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Tue, 26 Apr
 2022 02:56:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 02:56:07 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Support zoned devices with gap zones
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsm0wo23.fsf@ca-mkp.ca.oracle.com>
References: <20220421183023.3462291-1-bvanassche@acm.org>
Date:   Mon, 25 Apr 2022 22:56:05 -0400
In-Reply-To: <20220421183023.3462291-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 21 Apr 2022 11:30:14 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0072.namprd07.prod.outlook.com
 (2603:10b6:a03:60::49) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 852bf82e-f134-4050-24e5-08da27304f72
X-MS-TrafficTypeDiagnostic: DM6PR10MB4169:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB41695350DB51520D6468067E8EFB9@DM6PR10MB4169.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nM2pM2ZHlSXki1LJwQQwa0d+xLIrvCspnI+bgiVvw3Jkl1uzFDQATwXk+3iLGrFuQG7zQP71RRDzlamlIzF+fP3HL/igdO51BjzzviPPK5HlPD5vxTWhgGRsq0JA2V0lXV8+icKP8c11hvO6B5t3XOlS1Htxv9Fa35cqQuN0QmMUcyHjKNpfisdX+WKwXuUZ6gjvxka4NBH6YkGVXPq9E11ERMgeCP3/sjTKuLQ+OHGRZgU+xClTSPkuaR8vbvcedOkCi7IdHLTwVpQY9kjYEsIapg234uejntswLBZ2gT6AC9o+GOUL9twdB/JykycVPvnKDJitBX4KYuziUrPISFCijlQJdJXY+CkLuwf5hN53549S7vwx8PZxDOm3477M2D+vjzvZs9l6RVhZPCRvgkRktRl5gCBNeJEeP5dOg0BP25eF4tEZC7hbT2aN1V4okDlUk/FTEn8l/Xghni/oJNS7F86qnkhadsH2Y8MUz7mCH4zGCb+hfhQymZX3MTqFu5A00vdlIHfe0s4Mj6cQptl4Etd6R6Pb+u5R+RgKivzn8yoZN1I27qdFDsRO8u0WTLP8PG4lAA9vyBu0HXLvHaIWdEstjjZieeMhs3ScyWdZrb469P/r7qEpOD1LsBuS0XoYrKCetuTLxYLgmmtBbP3DiedOuwOBWMkb6kjW+IV8xD8ILBddUOTJpOGj3+dHsVJQWkD9iMc+6WbMGc49OQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(86362001)(52116002)(6916009)(5660300002)(186003)(6506007)(66946007)(2906002)(54906003)(8676002)(66476007)(4326008)(66556008)(36916002)(508600001)(316002)(6512007)(6486002)(38350700002)(38100700002)(4744005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6LLSl8KTJ28Bz2X4gM85/JMydkKSJm65ITjo4n0GKXGZhyFBSeUgafgihYSs?=
 =?us-ascii?Q?HwafPTfAq+E3CAHNboOpB1cRruryFbRkTp5RFoDqVcsiGF+RPWFCiPI4ThFh?=
 =?us-ascii?Q?JN8cqAOlnhDsHkx98aCsxRtXpeV6EWz+HHgvmMhHhSPUigf9sFzz9o9aWT7+?=
 =?us-ascii?Q?jTNKp8Cy+r0T84B2uAxqNNVFxxFHDbxYZUz7EjF+35Y+qGn29jrN+o4eWzLv?=
 =?us-ascii?Q?CpVSUtl8HeX8q1S/qUzqW2OCwZAzFPZKlZnS3xETmEj7nU+f4DxYItj8My5b?=
 =?us-ascii?Q?Auc/Pve3GnE4x3/ZMJ9J1c0KMbYsVyCU69F9It/Jx8MFTNayrlb5Fz//4Cc8?=
 =?us-ascii?Q?KHY0aBolH2QzzQy+HBN7A/9iC2Edyvu6mULKBIBoRKzdAO4gcyfBj6GhETvi?=
 =?us-ascii?Q?OlmmzJq1qONnHAiRTlE5vpCw4mNjF0sCbDVbOrBW9NGFNuI1UB1IOZPTO4ox?=
 =?us-ascii?Q?kZu9LXYnLH5AXqV+5TpVIN13IpyQ6AStGJTe1fc+PqBDG3hQ6BrCgMMhRogt?=
 =?us-ascii?Q?WTWgMcLCukyPL+Mpg+oNObCsEsj5Dd1t15Xx2QmF1w2I3/ymbjaxGR6K5UzN?=
 =?us-ascii?Q?cd0RDQxqo4HmRDMO4WHBGlMCHPoQmOoP3esquA4z8xVGlif7EoTbsTZ4rF7L?=
 =?us-ascii?Q?jk6+2+ch+j4V663UfYnPBFrgF7Dxfq2Ehbd0H693dcrXgj8tIzmDXe2tuMBx?=
 =?us-ascii?Q?FjvGBUynebINkyNgeYbxU+bi3ExqC03TfriY+S8OoZkuAPZlZmfI1ocp1FHF?=
 =?us-ascii?Q?9q4QIXdT/SfioAXsImi6Qwqv6CQ9XPwFV+7SPxop1VSIqlXO28wgQ4ZpJzGc?=
 =?us-ascii?Q?p6SPlCMbtGHK5rujFN6juByd9Wmwo2fdkkpGDvNbs9LTMqHzjw8IPymb4r2/?=
 =?us-ascii?Q?GB7ITs3x91vD1KgP2qlHYbO8bKY7Pyn6SCIfXBIlcbVw9OdsYsY4c2D0blxm?=
 =?us-ascii?Q?l1IHONRaFcI5HvY6P+ugRLR4QSGyh43LahxCBna5MCK+Fc0wYpQNZp7f/T48?=
 =?us-ascii?Q?mXCGPGr4hWmXq0IHacWqXEJTmupomTPA27fXdEYhtxLp8PgOwxvxtb6j5o/s?=
 =?us-ascii?Q?oWzN03ZgC1h+igCU18m3brSoHHC+YajU3klGTSMQ9GohCmtMf4KYYPj8BQk2?=
 =?us-ascii?Q?hWwTQuT16VKij4paoZ73Gugnw6EmrXm1jeAKva4tmssAkFtFdLpU0Uf6qYie?=
 =?us-ascii?Q?HyZiFfD/Jc/Z9EYJxAD+WknSYon0RYB/tlwrVkNEcoL0m4wWXsEBZUQ55xM7?=
 =?us-ascii?Q?1kvJMbPpU6rIu37f9Fa28MjJXSpSBTSIh4i9zpv54emuZtoaTyL0c29nB5kG?=
 =?us-ascii?Q?MQrcNwSwAr7Czp5aYYehlwWz0jrUrsupqK/in1OChDnDNzdO7U15shvnAfpV?=
 =?us-ascii?Q?kAXyKvJZBCAKmTfIPKo1qb+7Q6Cct4yt74XzgVRxUi0UtDNCKeivKnuFIhYs?=
 =?us-ascii?Q?22z+78o/dYaGM4WFsfscwKEPmgA2eKo+7vjfyYsFAGBSWL9dfdPRlJkfAnKX?=
 =?us-ascii?Q?jompPuLl9IK2tXgRdh9swSRw4zYdGrvXl++IYWJoLy+mJBkyhFoL5UW144rd?=
 =?us-ascii?Q?oSm16VM3cLUwags8BFaBs+dm5yNGZ7jzummnY1HBCFsk4V81+8agOLh/xIEa?=
 =?us-ascii?Q?SKI+NKcGRgMx0RqghzYzydZUmgNjJ9bTbMl9wiczRCMrUKBq1RIl9XKFZSYU?=
 =?us-ascii?Q?3ly/zK+q8A1YdVMNM5/htdW1vB4064PqXfgCKO69DTyrWcq9azn4lFBgdfVc?=
 =?us-ascii?Q?/zx4G3HilGn5xBtS9XgpZaNQBFBd5tQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 852bf82e-f134-4050-24e5-08da27304f72
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 02:56:07.2546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QGyMU9K7XMZAlrzgbxGY7g6IDFYHgZ3Do1tW0HxH6iNNRCLFF1kmcD8sgRD7y9O515E6oF2WS9/UBO3Kkhm+RmiZAIbMsfO//B+GnIc1pQE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4169
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-25_08:2022-04-25,2022-04-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=657 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204260016
X-Proofpoint-ORIG-GUID: cOVecsk6wU6omz5S68fNVrBq5UMV_2rz
X-Proofpoint-GUID: cOVecsk6wU6omz5S68fNVrBq5UMV_2rz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> In ZBC-2 support has been improved for zones with a size that is not a
> power of two by allowing host-managed devices to report gap
> zones. This patch adds support for zoned devices for which data zones
> and gap zones alternate if the distance between zone start LBAs is a
> power of two.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
