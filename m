Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE19C05027
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Feb 2023 23:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjBHXcZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Feb 2023 18:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjBHXcY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2023 18:32:24 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C5E1631A;
        Wed,  8 Feb 2023 15:32:23 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 318KwtWp010913;
        Wed, 8 Feb 2023 23:32:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=VtuImLU9s5ZjojFs76j2LZQv33URf9eO0kfRjR18occ=;
 b=mR7gMhfTRbkySTkfTLAoilRsCRp92/uQltEfjnYnw5ksB8HpQkGJOGRyh5ItdwVtmQiu
 x/RB7jQm4BzBFICF+6Robs98Obry2blO2QR+w5N7RenVXp02+fAPw0jSKznRVJBuICgM
 Flevao4meGNO413CewSRbUi+RvAmROja1mBxkHL0lr5l+IEzZ8dHKJghFEspxKgcDRWG
 rfWCTnl9DfFpiK+G0HBBpnlz7QsYDzD23PcX/G0iuvMqz2SCBmoCo5PcDVBD2pQgDS+n
 C4BWyzldi2xk1jlwZBdTPLGbHTo6JL8o3rKBTzO/zZdncZPBqnHg1dO8Gr0vmgIUhI8o CA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdsdsj4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Feb 2023 23:32:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 318NIG0W021299;
        Wed, 8 Feb 2023 23:32:17 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt7xcxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Feb 2023 23:32:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqN9Msp8425SCMYTTCA9d91+fPTX0wolR3bEDnk7IoqL43snx4XPlF7mFTP492YfQ9DMbEQspG78Z11Ey6m0y/8ESdp0/X5Ec6texc37MuS5ahVtO7KkiOAtihlv48x1e7a4pUVqCIQ6E985PobCd9RhZS3akoK76AUTciZ5lQQ/nVUyqmOOIKvrwq35SJO5ZNwlhPiUusZhw/9F+kYb6p6FyBjzeV6Ij8TIhSnu8EeZG5uO32yMeQ/sg+itwymPKlUfQ2GHKJzKStk0pJcN/6sAGUHNqjPTiyauqyiAdwnIWQUgxpp38xVG8E7No6CUQd4I03l8qrmngXGnEVlsug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VtuImLU9s5ZjojFs76j2LZQv33URf9eO0kfRjR18occ=;
 b=kpCrN6JS49xrl3ZYCEiVEtow2eQbYOSDRujNe534ojMz7uL77ebmiKjMkQLd7L2Pff79QvwtxpWx0qn/8qjo55R5PzgAjzYo0X5KvNB4hOFrc803/trnJgGLgss1LjmpShMAq5TY3dY0o8Sq8Jr2gocttWLux3kVxyGi3T0YFxH4Le4IDQQL25vPt/PVav4Tj5V/dAQM6t90CdgvZZEzQ1902ESyhD+/cJIMRpfUlT+VBH9qERvP60qDHenQc2JE/MFv3x/r3mmX/gnZOZ2+hF6oHtE7/T2xHUcX0IESOOEVQM82W3CY7I8yfVbPBGyFI5iafJ33Ba/Br07Q6v2ajw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VtuImLU9s5ZjojFs76j2LZQv33URf9eO0kfRjR18occ=;
 b=I/BfM3+OnBiu35eKyByBci2rp5gtzPz6f6Gw5ZJMov1EZjUtUmzPRZqwpQOu4KwCmWO28eZBsvnWlxdBFrOESGA40qbntN+CAyENcu4qA/aQ9V9NMQM/uF7tO/iv5wZCW3MQ7FQl8GwZHTf3IGfIpcA3TTHHbwA7nUR26QTPqDw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4567.namprd10.prod.outlook.com (2603:10b6:510:33::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 23:32:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%4]) with mapi id 15.20.6086.018; Wed, 8 Feb 2023
 23:32:15 +0000
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/9] Documentation: correct lots of spelling errors
 (series 2)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h6vvzqrw.fsf@ca-mkp.ca.oracle.com>
References: <20230129231053.20863-1-rdunlap@infradead.org>
Date:   Wed, 08 Feb 2023 18:32:13 -0500
In-Reply-To: <20230129231053.20863-1-rdunlap@infradead.org> (Randy Dunlap's
        message of "Sun, 29 Jan 2023 15:10:44 -0800")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR12CA0023.namprd12.prod.outlook.com
 (2603:10b6:5:1c0::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB4567:EE_
X-MS-Office365-Filtering-Correlation-Id: 7321e335-fce1-4296-bc3b-08db0a2cb638
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DofLDtqUAOXcTRhoXB3qFKAjnu4BB7nzVFT5b73lXv0Y+nYnEHIWa+BM5jYu436XLUdgPytfmonFIHMAVtfddU8t4xsfGAqcggQpeJqcEALgRpqwJA9NaCNnk4vXyCDljwSVMh3OMjX5C6w1MLflZUG+ixN7uyU9g7dv30qPkGwxjXkbtzwlCgtRjnt9ti1jf1/rpu9MUPUDR/cwtO7MiYpBjiikaMbHuLIDQLZnfwEQhMraMu+uLjmPEhRYS3S1DHtxkOodhn/hgDWNpd3AfNZh2MdP1o4uPsvbyEznkjhi/QF7BqQZYAxjBArdl1ir6FWuvuGBgclhca1oF+ZsiQyFUwiQeJ2Co32MUyUZnJDTqKysDXOcWNyYONZiUmXBcdc+l0nDB/jtVcbZrNLwJCicNrwyRH9E+rpaQ3xDE5/g2QFODQk+d1KBmZK+EH6XNNWL8TnjSpdzUv+HvOoR5uxoY6wUoVb46+wEIg+h8MOI++2WQAR8rsJGK/p2xhUwDVuc30djrPXBjGirAmtdq14L4Uzl9Sqa/f4sFMColwj0jKAj1zCQw2Dd3lFKYmD0sF4zxacnus9k7F/8DLQFXhe28oGZ9jR+xjeB4gTZRUcG2ReJzztQxQMEA4MNvRdDMCnc6SIuNGuTA3yk+96nNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(136003)(366004)(346002)(39860400002)(451199018)(41300700001)(66556008)(66946007)(6916009)(4326008)(8676002)(66476007)(2906002)(558084003)(86362001)(38100700002)(5660300002)(8936002)(36916002)(6486002)(26005)(6512007)(186003)(478600001)(6506007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ufGLdB203EWWd+mvwdH8EWxDinqwyHgSfB7h7W7XdRRkd2pW4mwbXTFKFVII?=
 =?us-ascii?Q?olFF3QI8aGgjYz5r1uuHoXCE9RiiipoX+U48nActdkjkJkNbs2gCcBSoh8Jl?=
 =?us-ascii?Q?4Lpi1miCZCaGvvzpBZBdQAIiOG1vFEkOySrzfLH5Lm3BSOTEcL4M2f+wTXMW?=
 =?us-ascii?Q?G39nITeDnUaRiJSnpgl1NN57hPtw/EGGAwqHSEIRw3CJFj3qU36Bm5DnjnZf?=
 =?us-ascii?Q?hlOVKn+Gaybpas4xZpmEZj1SbGMaCZXyLsHTgoASTWIhZaLcxEvk3uQHiFhM?=
 =?us-ascii?Q?BnW2CPWrcsNGYjVDJP8oVbAXZ5JDSbtBkp2IzaHw7KQ9lzQA8XVkcL8OWLQP?=
 =?us-ascii?Q?MWFZ2zgaeKtYgmFwYuF1IHs4O+nCoitS6rVaDWDG8WCjFP5z94BrNAmgPUhb?=
 =?us-ascii?Q?X4sPvGaWsC28vrUzuw/mHR57RtoJ9228TnM0OYCYiAP/rMallp4NGDn+Qs/N?=
 =?us-ascii?Q?BXvS3/E4LKeBrPGQpJtXoKYpeYzn09wiSTa6noItXRO4p9Kakljb6iZsg4eV?=
 =?us-ascii?Q?f1xd4h50L62ecA5ebTOjtZOzBCbvIZCTZdnoUcuTJZ/K1JhvmxanLjSWbLnK?=
 =?us-ascii?Q?xR9YhVSWSk1rOOfu6/sef1P7SOpdhqkTFYoksV4JvL4r/BO4G69Kygx2nEEd?=
 =?us-ascii?Q?50FbFxsbU5wdtThECVH7paAv8HQ/AVaOxkgasYMwkdvI13P97pdZaY3QMU6p?=
 =?us-ascii?Q?hvF1wQHXhg66Repn46FDjuH3gtQ6506eDHADBBh+GWUUFL5LXVVXEEz8N7Eo?=
 =?us-ascii?Q?qzg9Gdho4grodn6JXDch+GVacInlvfdlYMGxs4ntgT6O/hr6BJQjr27Q2rGm?=
 =?us-ascii?Q?QD0W20A93HqTKcqxoLChZwAZodLsGILY/j+TS3P5FBKVhyvkNhJLYCMv+g6i?=
 =?us-ascii?Q?4f70wzTN8huS1WTNT9aF0nuigtFJDIG9OiYXHXNN/i1GoOCHixE2CeA/D5kU?=
 =?us-ascii?Q?ndle2ZJxNx1HiKc8ufY9I8P1fTR2yIUUNt6Ikq+VrTOAVh+/ciTB59dARQFM?=
 =?us-ascii?Q?NrYhJ2heQ+SCrIngks4ytQHQenU8593n1gHF+M8zjkimMLgAP2I4FW4r7NQr?=
 =?us-ascii?Q?IASzOf8emWB31c/5Y18nL6TtyhQe2kB+qXez+pGDuR6e4sBj+/LBp+as76ms?=
 =?us-ascii?Q?nWXsbF6Ctf6rCv9cg51AsZivm6sHjQtLe3IyMNgewo93o7thmuyg7Xo5GJxa?=
 =?us-ascii?Q?CgfM5OqKuNmV4/LNpLO5stia22JuzLyJgRv1IhbbiBTXH2antF/DF4IJLU9Q?=
 =?us-ascii?Q?RUUpVWiedZbOElle1c4QznBoyQvhWf4dc64J54DWZ/0sUwJn6hv/TtNGuH1k?=
 =?us-ascii?Q?HgEWU5mIWmn1P6EKiPD/t7J1dSLJ6sJ4+30jXG+F1ysFG9Sy6hJ+7QD8t5T0?=
 =?us-ascii?Q?xtkN6E6lZsmNC+YAQ9tTv4WmPPnSJr/x6Cesgp2HQUILI7YyVg6R0GOEoyHO?=
 =?us-ascii?Q?dB9uDY6c6twzhbRrb6LaK0Z5Q1ocaPVi9JOYbP/yBK9nMEko3+j5ZV5zeeIo?=
 =?us-ascii?Q?hPWWlHktEZmoLsF+YNXlhxRqof3NPwYbWV2qIp2HigKiaPhMTwptb/hjgifI?=
 =?us-ascii?Q?xpmYjiK3PeP3rvWXgV3pzNcWBErWXTHT5LpL6ukr0wlErciEd3MJKnG/3wbp?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: R1ABAPwro0nqnhOLCqz97dE+HhU6HeDC6GjIJIcEO77m58cWz+QuJg4YWAWGxrvhYJmMA1mkyjBlnlxnF8bC/iSzek3XUd8dDWF+GHA8r+AILqHizxRjAsMPk3W67uQiGQI+EwsICiHrzXlWFH/r9MQIw0f36JxlH1oeH4xgEJKZGrewCrd4Qw830AxihINx/oF6W4uV2IHUcAaSarVsZSrUKlQ1LRBDwgLvLhHjdZVA6PSOiTsvCV8Jijssh4syAZ6+4b0sIYXs7QjvNwiGxvvwHaSCwsbhI9KTKJEKAugzdXhZG2BE5iNZgsSJV+gzH9Q8/Kvhk0QSgql/+ISkCAYy+VXeV4SpTIWXlfD8CrUu2RZSH8HFFh7zcYDpTUyiIUrHkYldcdNCcDpedQ7ge32F80i0Dnx9h1rDjWdwO6ku0rmIgMEDvAd6GCpaomsmzrckuIHso6YTQZCgNzV2yePh07cUMQx3siOoDB+iFAb9Wh8vMCVU+M0pc40n3tSTfxAkHFOW4UDSvrB6CTpfGQdRTB3OxpW53HArwT4cTxV/igZLa/u834TkNin84jMbnQV2/pipWk76pPHNO6R97+ywdh32VWfQq42+Pqg/TWSD+q7WxINypSAB6r2OYmiXKRsKTE6B9eYy2EBwZB5s5U58v6O/NJREk9d1XFU92Y9emIiH5IA2neoQNt3+Ex2G6iK6Xf+5ok7h6YacnG2rKZrAJW0dhPWnr3uAo6sDYeAkwLlCpfa4Y2DNavV1342czhAHT2e3S9lPg0udk7WhqJrnJDO+06RnUTG1JIiUSIRO8CuVOQ5l775f90EGRoeN
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7321e335-fce1-4296-bc3b-08db0a2cb638
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 23:32:15.7539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bd4bxpgd2keEKicidhGO2yD8SrXm5zHG8bY1HRL2GE+Z+SaWbIXzrtZME+SfLCOf1cRnorrOwPmQSy/gIAtFGCey1iJ9wZU4RgO1rB5VT7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4567
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-08_09,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=988 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302080199
X-Proofpoint-ORIG-GUID: UNpYbdMZKXOtabfV4fhPQH-sWvrUkSg2
X-Proofpoint-GUID: UNpYbdMZKXOtabfV4fhPQH-sWvrUkSg2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Randy,

>  [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
>  [PATCH 7/9] Documentation: scsi: correct spelling

I was a bit hesitant wrt. changing historical relics like these but
ended up applying to 6.3/scsi-staging.

-- 
Martin K. Petersen	Oracle Linux Engineering
