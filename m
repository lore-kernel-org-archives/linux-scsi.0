Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16AFFECAAD1
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 04:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiIAEcP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Sep 2022 00:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiIAEbx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2022 00:31:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB03112E
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 21:31:27 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VNnRrp017139;
        Thu, 1 Sep 2022 04:31:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=6B1C/Niio0xLpwxmdSZZTdNqK8emEhGCYw0EHImWKIs=;
 b=EyWVdHJP5soPuwwWVkbNldlx7AJd4QHQT8uZq7PTC3FgfbU57tGrRl5G/phjTHn3LVmL
 /tOkmnoCAgAjrGPPWVMnJn15J4vrfkHa6lDY7Qwb3PtmxvlKiURd6dRCxC9YYRlrVUAl
 I7+H/CHyXqYfjtuYH9U04LBG5CtBk0fHb5qwszh7dIpMqbehcHExlP0H5BOD5n8Nrgl9
 3dDdd/9SNIAeKAG5xFLQW2+KKc0XhhG5K48InatudXlu2dKQcLNlvk35JKhY9K/NbhzF
 4YCce3cY4N7bGbYS/pHzikIXqLEMDb9dw6mdkhg+jkir8IKJ7lTKqbzUtqZZanWPctsE 2w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7bttaxsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 04:31:25 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28132eXu022068;
        Thu, 1 Sep 2022 04:31:25 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q5s4eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 04:31:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gjy/UznkkgbH4YM6Gz6Su3ZedO1HEoQDSIf7/WjzyWAjP4MRskUzVE99nJm9afKGMRSAWAe+i933aph50PksH/YjqfMFwcFc80Sad4cF2GDUunf/m6zNSiRQMSGjUJj6IMbAAmoZzsYkubgrPboXhP6xdnI/xRKXGVlr1ox1mvHPBC2SrSUrmDUdlQwt5JZ7NgkpjviESVDteqmNFHK0d4sRN95OKqOWgjjuySiUVi7ofj5Elv5rY9v6LBRpNsZc8Lsk+6pyJp32bJXDhlx8DUAZwAQx74PQs+BLJSD/H2kQU+TJAclk5XLLoqL+mDYKEOshaziYxqIfJXbQYPaJOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6B1C/Niio0xLpwxmdSZZTdNqK8emEhGCYw0EHImWKIs=;
 b=jmfxrdVlwwsxeb1o+rzDo20udyvu0y2o6Ki1JFN+DstaeOlz0avXtu9+fSd/kSMPRvAOIXzLnpiI7eIE3OBKWHjsO/Lldnj7lCvavj01zDlGIJOZGNlMcx2wEs1KcaJ00AaXmC6Euap95fW9cpt/OObFSokptA4xkA6R//N9RyryAMbsxHs873Z3L9yRWFnamlFAeMmDvEIGkjyhr6zjIexo5W3TzramxtCDY0LmInodAxws13yMPN3REMQfBokDDrMs5Abj3tKc0p+p4rrcIbTAQNSW0b05WaP9igrVRAH01BlYFRGms+JTmK+8v/ngl13IEQH7eAFU1rOFyBRSrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6B1C/Niio0xLpwxmdSZZTdNqK8emEhGCYw0EHImWKIs=;
 b=XaRQyIsE6yK73sarDVawAoOvKh5AgUQme8AW9R29U0PkTwyTFZnWiV2/llLut5Jv4ZIorb3MMEAoDptiLHwlwZC65wdjDZ9CfQmKbq5LFQ8PShDMUHdy6XM2yFsK7LOLwvmD0YK5/YvJdJE1zCaUp0QOAQKLJu5X0I16ajpl6/k=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CO1PR10MB4563.namprd10.prod.outlook.com (2603:10b6:303:92::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Thu, 1 Sep
 2022 04:31:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75%3]) with mapi id 15.20.5566.021; Thu, 1 Sep 2022
 04:31:22 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: Re: [PATCH v2 0/7] qla2xxx driver features
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135dbn2b7.fsf@ca-mkp.ca.oracle.com>
References: <20220826102559.17474-1-njavali@marvell.com>
Date:   Thu, 01 Sep 2022 00:31:20 -0400
In-Reply-To: <20220826102559.17474-1-njavali@marvell.com> (Nilesh Javali's
        message of "Fri, 26 Aug 2022 03:25:52 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7581bca9-9aa5-450f-3b42-08da8bd2d2ed
X-MS-TrafficTypeDiagnostic: CO1PR10MB4563:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pzw7rVM7i0dGR3QTeb5LdRrSnem9FHt3AHLiKsnSsCor7za7kWJQzmVeLuo9niHQnn5IOmo/23mBEDnJwgPwoiS06i9Ts3X8yGO31rsRk155F99pKBqi2eM+pnAoASQoQEAq5Skv+mMH2CPsTHlv23pLsiuNcKkHBYFZjDsRLfXeHPu/fPm64TQ6gqfKwIjdukSWud58yZ3ux9EGG9/rqLwOh4nMefpwTJRrkK/MFZdOIfLpQ1V9ZsQVFYL7sGkb+ITAJ6xmhTzscU79mHVxQK7X8p1KE13Lyo7WzJf+spmV0bbuVITl4I9eRHJ+sbDbjvdi2ElXfipmvVUdenPHXDwxLyEbAZDJzxnvET1frhxdNYcIMAKiMhMk2u2kDplqs1nhpoLc4pDleX6OiYmmwaC25wcs6bhQwW/1LnDSWnUzvgo2Q5X/c3/rm6bf/3e/yb6GA+AI39rPaUbZ0WNLQOTCmaYecnk5mpsmm8U5h23SyrN/rQqqlUNFG+sykJhckqSDjiYudOnCWNx49cl2XrvL/lnKtEa6ExgSE2J6v/2K9JEnbyT6XsgX0cwOym3uKmn2w266Nldr46YjtNl74s2AMPxE9GWAZhzn/TaHyWM4innJ7nDOOpDs+HsqTxmrS00RRboaa5LTYgyW9ZiAmF+/YehQDB2lwV9USwLO7TKV2NK+BvsVnGTNMVwrHIp8nfN2T2NaXJNSsRZorjz3oK9kBtVRUOs5Uf7oVQuyJXf+rMZDby5wEOKM/SG5JBjzXQEHp1uGz0oyTpYk/xYhcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(376002)(396003)(366004)(136003)(186003)(6506007)(41300700001)(558084003)(36916002)(86362001)(52116002)(26005)(6512007)(38100700002)(38350700002)(8936002)(5660300002)(4326008)(66946007)(66556008)(66476007)(8676002)(2906002)(6486002)(478600001)(54906003)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j6dqQITIZsTz4wPYwgkS23MTxvXyvAQE1UoLpZp6QhyVQdzlm6pUVnDG2mXa?=
 =?us-ascii?Q?SfLFQ2XU9TUCklEgnaZkXmzyX1fH6/J8HPq447T8C4svShhjPDDsH8teBSRE?=
 =?us-ascii?Q?Q3NWl1XnhDyFgfKPwSeiFnURsc0QXXdp1vc9sYiqyl2bSsntf8Cd8IU815dX?=
 =?us-ascii?Q?sjz2t5lItn1Cljm7nBnPslCyJWYAW29bKKwLxEOwGndeLJtQ9HIKgc/mCAI5?=
 =?us-ascii?Q?3Xs4J62d0Y8iFkA2lhKKvSxozKs8GOTCtOiTUiW0fWASQyMTi90+ca+EB3Jr?=
 =?us-ascii?Q?INcZTyuctdqCD4mRE1xMAHtS4X1dtfvAL7AhxVp/XOV94abOhQRjEfLtjdbk?=
 =?us-ascii?Q?I0hRUGISPWKWUIixqoxV89BMAs1AR5Eh7lkam6BLIygQGKsT+B6nxFtafexL?=
 =?us-ascii?Q?lvF+ZNI598bptj5EtgSWJhYjTDA80EJNCMcK0lH1MOkg5MHDqUhENSJkozsS?=
 =?us-ascii?Q?FDhwm551OzHHwLH/SaUxsdNSXypY5Ww4BmFrh+hu/w80HwxCkDuuM+jqjls9?=
 =?us-ascii?Q?CReYgPlBxzpjLXn9F+sb+vda03Lp79M1KIRLnGtLSCMaA9axPfk3WFebpY0u?=
 =?us-ascii?Q?ZfWrUz+xxoRZvkqPWhgcxzVO3UJhpfHcgAFIwTzNiobTAzqjREgfCt5cRmfh?=
 =?us-ascii?Q?YP/I4vqHGRmtqtdOeYsVQHo9eV7BqWoQ7nXsPchvSh7ocRtNrTRWz1RaexCh?=
 =?us-ascii?Q?WKZnyL/5BvtB1MPB82TfcyLA02AdsIcTO5O9ySEj2pEqcw1lFRkJblZXa43O?=
 =?us-ascii?Q?9ldNrcFh/wahsk73x4cOn6Q13t1hXUa5sKlMQph3hl02ZJ8aZZc0ElhxO8qP?=
 =?us-ascii?Q?UmMitk8SnObqPuhRD6TL56LCe3jz5+5ddc8SXCN6TAbmeZ14/MB19t1Lv/UF?=
 =?us-ascii?Q?oBTRvKZQ1+ixO7grzQxrSHa5QulB+BZkFU1JiOoT2R8o/Oi96hSfKCT7dMb5?=
 =?us-ascii?Q?6Uf4Sg0Gw4HoBXLhVY2B5c4sqWZcuonAg8suTCLQ97jnrIcBVIIcjKGwFArz?=
 =?us-ascii?Q?zUZOEfpU+V8etzQ5os6Nbt3jPSG62LqDJslI40QVvSV5V/Fk8tBmn7TRbGPH?=
 =?us-ascii?Q?wYH/b7H0pcCk2fr0ET4dqp/HTM7QUuXijQQs1k7i3VyEwnlLgzN16fLs3eyo?=
 =?us-ascii?Q?+Xkxr1ITY7QoYZYnXdQVnbLtbhFu/qGczN3wU2Y7ac/HyZseVfMKqSbqdjH1?=
 =?us-ascii?Q?z5VycvF1HXWHNfoZ4vWRrrfF6fklg5B6nOWdif091p1DRkfxnBfKj4OK0PUf?=
 =?us-ascii?Q?9zLvQNyVc6i2vppCmGhjL4a5t841i7XTt9xcgURinpJtBjAwyCL0uljrZzHf?=
 =?us-ascii?Q?YQ6YyCcuV+/2MmifAc+EztT4E6HN9SAubBdKK/po8ZR+zfFf9I2xe7UWjWOi?=
 =?us-ascii?Q?B170jW05LlQLfsRV9LOUa83AD/13QNTPbnvrBmhxj3oNa90UD6Jhff00WTeC?=
 =?us-ascii?Q?kn2vvENI1MMUg3DUiJS1mpMhuvFGvyWXQJwRauu9d0ZEGNtIPeatpPSmWyHZ?=
 =?us-ascii?Q?HH9N/uc/tDDEVVKAOjILnwGiY7EAwx6viRdpnTADJ3ULSxrGnKLgm/MxH4ii?=
 =?us-ascii?Q?KKB2z24K8IYF4fFl/yB1Bj/FO2Rt/wTT27I+Gusg88CT2EIAtwmlp0N1w7sC?=
 =?us-ascii?Q?aQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7581bca9-9aa5-450f-3b42-08da8bd2d2ed
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 04:31:22.8082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 47Q/sI9ffdAAaHLbFpBqqf7K8ALkqWxe1je1UmtIUf8gwdkqBFGgJQS4gVvOTH8u3gdI8sWd/Zjx7blhqLd/amJdFpYD0nxvlkhgagOScQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4563
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_02,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=758 adultscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010020
X-Proofpoint-ORIG-GUID: kme3btB9XA-WBBOCnUnQEoXTsY6f46Ky
X-Proofpoint-GUID: kme3btB9XA-WBBOCnUnQEoXTsY6f46Ky
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the qla2xxx driver features to the scsi tree at your
> earliest convenience.

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
