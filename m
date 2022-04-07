Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8434C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 02:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiDGCHq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 22:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiDGCHn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 22:07:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A1513D0C
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 19:05:39 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 236LepVm005378;
        Thu, 7 Apr 2022 02:05:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=2EM1CU6G4AGszZXEf/VbeETdt6U0gBwpcbOJURrVh1M=;
 b=id7tDZ2spvoXTvl8SiQBx2C1iL6Rsy1VZglxCCNzSIB50aEHI/FhxynL9l99aKE9I4lS
 vi+bGSjqzIAK31Xw2kpAzP/BnDzJbzIrjZhQ9Jw4JkASFWIZNBnYCN82qabnyM8/QHdp
 NPZ05WoyHXEJfojtJuID5MBQJ/8PbwB74gglENZgdrCH5K++zeVwa/YAti5oqRjZkpGD
 u9C/35yFWdKephEPF6h4KEr1zdlRQszNuvZ+erPznTvYtGBQA0J/POPwnHR3nm4ktFet
 PqeArkGrp/fzGKTQ3IAzDOrsnksYfQjXjKMj1Oz3X195vps6sDHwNqXPK/CRgr2cwMOR TQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d932j75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 02:05:34 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23720f0w025302;
        Thu, 7 Apr 2022 02:05:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97y716fd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 02:05:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N27+gZp7nWpUbPiHtTG7ab1xa83dZlIoyU2gBHYDq9jQHOmpfdk7v7eQvI4eUoloJQEQcFLV7hCuwp3Swy3ebZcBGziq/t2WdFEIq9mINHW+VKaP2q8OTnFmbawf2k+LY2x1/0xSKsmfADpZRspA6esMP6/BjkhzykzOYhZAkGH7YJ6VtZ9xbpZ4KOgDcOiBYUl5XBI59ETpJHX7LVqLdCCIRjOy2+nq4XZsMfJxDn32jbasZzbjOlUovKeowp5wY9zq1KGhI2kFCw5rmeipgLilq3jWCtQs+pGevDRDJ3lIkwv7tdL5wo6lbKsDYPW8lBE3ACF7ev9ej/l0a4sSPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2EM1CU6G4AGszZXEf/VbeETdt6U0gBwpcbOJURrVh1M=;
 b=ii8E6ex07MPtA4I/KJu1z8O9GgjnNOyEs+M2yeUNVHoSewOzb0Bf8zaLlOIBE0LSq27R2/SG3UJUinT3fL6GBPiAZ9ESDKrhFu1s51iJOrRdkcDCuh8eU7PtUMdMaVVAyGCfviJjEo/4/jV0GYqXuhBS0RfcYgSl+zDUqGSJvnhGB+AHEH4A9Ee2rtvDMZ6qWYJOI/aisejWQKrAnvYFUFhDmLeSRJxUgL9NVrmasOeM1Iyx+/v5Yi65cd9lu5XZ+/SfaP8bDyKharyuugGEWavN1cQklkEEVLU4IvCODcMkRNJJIzPKo2QMnbeNc8NCPyR6zaIBTVTMQqpEdoH7Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2EM1CU6G4AGszZXEf/VbeETdt6U0gBwpcbOJURrVh1M=;
 b=a9sg7BxxhGZ2AXQa+V5KLoxsQaazoB98dlLg2UTf+drwi9mZlmMACOSF6zLT+57zGRAuu2iTfRgoWTVF74S3pf+i50gIh+QPfUWtFdJhqhqngjl7Py8auK5mW1wYXQVJ6xTWqbvXhcp+OsV09mELE0qe5q9iu0IMOivPkwFW+20=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH2PR10MB4392.namprd10.prod.outlook.com (2603:10b6:610:79::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 02:05:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 02:05:31 +0000
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: scsi_debug: Fix sdebug_blk_mq_poll() in_use_bm
 bitmap use
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11qy9mywt.fsf@ca-mkp.ca.oracle.com>
References: <20220404045547.579887-1-damien.lemoal@opensource.wdc.com>
Date:   Wed, 06 Apr 2022 22:05:27 -0400
In-Reply-To: <20220404045547.579887-1-damien.lemoal@opensource.wdc.com>
        (Damien Le Moal's message of "Mon, 4 Apr 2022 13:55:47 +0900")
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:610:59::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 782b81f2-0963-4803-95e3-08da183b1858
X-MS-TrafficTypeDiagnostic: CH2PR10MB4392:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB439213823F07DCE30C3DAAAB8EE69@CH2PR10MB4392.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T5ftXcukw4tKG3bhG32MZg2380U08k3+nUlsEEQX+itr3ycGoEFcY0/N2RxD3LVolUtb+HqqbAVZo2yS05HSDYEz2a/EKzfL2kwvIAueBGLVWpc67C+Eo4ny8zXkvPRPa7dWHkYmc0DCppxesVXUpjOu4KXdeLfLkT+LvATKbg4IMDiJS7B2DM6O6GX4ZXJ14f3HS1GVx+ZRazOcJLmP2FkpwoEDtRJh/JxgdxQf+B6h7+Ye+wuev4/ZmlmZl3Mc6wIxjbIFxguFuzSNTOWcCuA8y0PCgzLekFlCqrUk1bS09MbMSCPE46SGzmHMOVuJDfrf0CwOZES39Venobzon5h+YKd0pQKzlZPS9F4aZjwynZnlOguswQcQ3hXjDs2t/KCoqd7m3D3VwEXOREjXk8P6D6HYBDs7KuEgx7gF0lT49ZhfXFa4XkdzhKC9+qVZ9jF3hUs1wzvZqEYk0jNBQq4TR86HAwH6nvfH8mk0RlUcTCWOaXsMxGcmU9DJbGfpv/ZGxHfglTmYpweBWsaUGMYS8DgQhumDEv8Kk7IJ2zUzS468C+Y9NM5VpCu3MmyegBkWg2qYLzhHvG15iqk7/nLNGbB1we3WBdYXVmbUGEqNFn5EE75cOe43CCrYghJ7Ot3VOyCWCyLy9gXkmdBvabb5S34QvoORK0v0AaotF4TpT9XhFQxQPKCjdouuzg46uK8HbdPUui0+0ci5qDt2dg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(54906003)(86362001)(186003)(26005)(6916009)(4744005)(316002)(8936002)(508600001)(38100700002)(38350700002)(4326008)(8676002)(66556008)(66476007)(66946007)(2906002)(52116002)(6512007)(6666004)(6486002)(6506007)(83380400001)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?geHkdxaJgni97+8LZuVgO+TdgqWyj2IcE94yZzTX3Eud/VHiLCPncXcjbUOY?=
 =?us-ascii?Q?tlfZocDC7oLCujlyY2mkboq5lwfmQ1lCrbTO65S0Y5x7JXECAQuI8lvhL+8H?=
 =?us-ascii?Q?tiVuEgnQlHZVZfnU6CBCE5FW+IQTzGr0FheGyn3m+/BXLonjZt9xUdN38RHp?=
 =?us-ascii?Q?lU4XrEICLkkzKK+5TvwsjDiQh9mbRMr5CO9e2tohQFeJVy8N5pAvXypGFwLA?=
 =?us-ascii?Q?dKF7BEU4eCyF7xG81+0l4EBZ0+fTyGfHteQ8gqiO1GLPwrmdUYr/8Ru2qw6S?=
 =?us-ascii?Q?3z3hM3Lt6x1HkPd3SutcYd3BdW6eBrmnTltb2r3wcDPyna//0lTvqZG3LH09?=
 =?us-ascii?Q?OgfGToA1Y6CE/lbXXdGJJzxoBjizewmEp6lSKqEwIEWcC51gf96zlHsN5zoc?=
 =?us-ascii?Q?MXx1i/MPQuTofeWBODBOhGxD2POwf7IaZUyX0TGA68gFmSMwIKR5sEQnVsBf?=
 =?us-ascii?Q?aMC+pk3iZSommBbongb/IuPGgPUkBUK8R1Yv7GhdgmLp47HzmYkC9kb4mEhi?=
 =?us-ascii?Q?FUZtSTqekbKXFLQDKmh5JbnUT0Xv8MiV7bDAdeF/rIvrduKOx9cMYpwd7h08?=
 =?us-ascii?Q?TnPxRbFhIpEndqxKCSzcl1EVMH1H1I8pELbEv80tECVfpOmU2XwVAPMeHzrz?=
 =?us-ascii?Q?TLVDtbajsefKb6YQ5c/axxq/mGS56Ma19CmhEJoxCGUXLuShMNsqTyaGAb8H?=
 =?us-ascii?Q?jPWH+1X8xmGSSl3fOt/+HGK4IxxYMrBAPS/voePHinbONqlbjZ+IcG0c81df?=
 =?us-ascii?Q?5kKlYw4lp7HpzdJtfWyvsg6nMLgO+PWKY06WS5tATXGi1ydAegswTYsFWoSe?=
 =?us-ascii?Q?Sv/50xPZB8zGSI2g3D6DuYxVrHLOM0X8efBkzYJkTcpYHl62KCbOJnB+gu6g?=
 =?us-ascii?Q?T4+AhSO72E7WjCEDRVP4j/xvXZhGrqfpoNg0acFfG0F+zE12tWuLzK4Is7Lj?=
 =?us-ascii?Q?VyoFG2Ufn9PfwOt5qiPgUR7xdkT1NJBmvzvsjPLI7RTBBh4OS2Trdv0yvTrs?=
 =?us-ascii?Q?WdWkBKloRJKX+If12+2Lbx+REI+nXU0K015zJqmkRESVowtxTBFx2jf9tVtq?=
 =?us-ascii?Q?EDVyoWfCYc/DLQAmQsBVQxnkrt7b6gBZGXnaR85hQ4DzZE0v2VEdbVFDDH2i?=
 =?us-ascii?Q?Sl2DFcUNaxstxDJG7Sb8PMkGeHkclG7iUqmz55ZsU/8cb+JJjO7X/JNHqpWv?=
 =?us-ascii?Q?1BYrAKVHRTGGsyOk6V+w7Lf3d/td+S157qHjFKVopHf/wE+lTp3Tf4K4aS7/?=
 =?us-ascii?Q?Z4XDugQJwUsvqyaAJXT8H8KpU6XISbq1P1A0pwjD/+rSOI9cZcRopJU8ZKkd?=
 =?us-ascii?Q?5esj++IUzR0sRDNGzDsFqOfSr2Ed5N1IyBWDyrujZuwFnYlJhNC6Y7Yofuio?=
 =?us-ascii?Q?lr/osTQRPb41lVz/IBc5ZnD4YW8oB9C8dDtu2phlJ0eOxJsFTH1S6sn5Z3c1?=
 =?us-ascii?Q?KQManfEBXxaPSYag2MlnMHLuQEmGq80aj1ISiLqXlGFR+dAk2L7VF+URCkal?=
 =?us-ascii?Q?a7hWd9eTdY8sjx9D7aqR0vomekxXjZknxwUVex8xz4lfrF44AQ7glRjEZ7e1?=
 =?us-ascii?Q?WsHcFpw3bLFKbAArgWgq8pT5jqJqPemXjPcwPdEgvqy1Sm3M8izmpZNFqADi?=
 =?us-ascii?Q?uQWmLceprRVfiZrZGRK+Jp4BbaTjnLCggspS5pGqITeDuMAD82VBG+HTvFgi?=
 =?us-ascii?Q?FtDmGv2GJFxZlkXZo5kkhuukGR9s4nH6kguDaGWrNVo2/CfmUEYOUjrmcgxy?=
 =?us-ascii?Q?pTrRR6z9lIYASyBssjdY4Ap7QMcsQRM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 782b81f2-0963-4803-95e3-08da183b1858
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 02:05:31.7879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8pW1u9AnmWDobN7v2pq4MMQi6ItJsm1V/64hq8asaG0yiPPgs+PghfE8ZnN3LHh2KiyAtQ5aODSdzts08Mdt1O/u7rd5zFj1Ezkt3P7+4qw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4392
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_13:2022-04-06,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=748 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204070009
X-Proofpoint-ORIG-GUID: QqgJRE36_TezX2i-8nu3OhP_Ni0IjimW
X-Proofpoint-GUID: QqgJRE36_TezX2i-8nu3OhP_Ni0IjimW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> The in_use_bm bitmap of struct sdebug_queue should be accessed under
> protection of the qc_lock spinlock. Make sure that this lock is taken
> before calling find_first_bit() at the beginning of the function
> sdebug_blk_mq_poll().

Applied to 5.18/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
