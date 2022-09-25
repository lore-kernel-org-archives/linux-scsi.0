Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D099C04A95
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Sep 2022 17:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbiIYRwM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Sep 2022 13:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiIYRwL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Sep 2022 13:52:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C517D1F2DD
        for <linux-scsi@vger.kernel.org>; Sun, 25 Sep 2022 10:52:09 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28P9R1Ik011480;
        Sun, 25 Sep 2022 17:52:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=u4qZYhv+3BsOR6umfHZ4S7ZLcULSJFmsSLCFn0DBUs4=;
 b=qEdTf/ZcxixOX8K9renMzR5PtAmOL6+03y+kV5wUxA5fA1zFPyKmgpbzMwbAQkFCesiT
 uUQ3VRfFPN57R8oQhypyBQVvuLTk+IAOqoJ4Sp8pTL/3fmBtV/7S/VUDY7U6ol4avVma
 GOA4tQ8RDiI6bUOTwXOkiBBFTBM9aeRYbNYF5oYIW2KyFreBuCr3Gr6qSERc2dayem6f
 4c4Ebz1DLNMiMP4vv9KJpwRSZByVqT/zYc+gz30GByPPPLNY2bwNFWIU5GsgVLWWdNmb
 0C2TRzieAsOopSbt88EPOwNFmnVZoshuiks2CwB5nWS2yS3a4p4nX4Q9nwVNRdtWdeqE NQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jsstphyvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Sep 2022 17:52:08 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28PCGOBh019907;
        Sun, 25 Sep 2022 17:52:07 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpu83wkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Sep 2022 17:52:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wbv6SXnnwrDFyMv/58ukm0B51BVXs2wNbFCVdk2/Q9+fo2wF+gJzMXcaKb47nRycsX0NTYjVP3G+/neyQa1DRkGJmTuywGRbstEb5TthO2+AxKad6O8kciabvLBTFhq9Bw7s2dQRpcab/Pq3+6va4RxnqnpPuK1vMMGbJv1WNGOonMa56vORUiy0BvH3yM/le9ggfDmEfGjx9jC/OuNhQ72VI2X9IVuoTG0Auh62lNf+ekWPwxJZvjv3gJKNV0DWWtlkKbbp83pEwuVPTYcT7eoIIJVE+5mDAfs3OFAp8lowYBAz5z2zYda4RBFglfE+m23prG78gCmWG7js0vijjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4qZYhv+3BsOR6umfHZ4S7ZLcULSJFmsSLCFn0DBUs4=;
 b=CiEhyrf7QGbfx1w/Q3AaCgLTdGmZNPgf+oLxGlis5i0L7JxY5XUS63yTGZfu5bWdRHlYaj9BF/A3sI0MdDF4TlV+0lVw9QAhLL7G0LOosRq+GvA4teGrrz52txzV4vx7nJyoClAl72XMbtZhR2vK/PauVUCX+DkhB2chdPuJHaBVvm35D3Tc4djvqkZhGM/zMRjofLUUkc9Ki5DHRRALpDzxAjIC2z8NfTj4VekK/qM/ChIJyRR9hV/mEAIFJk+nQhPYb3MfvUorkihbjtyCuV+C619Q2zmaBtqDe9FYWQcegR3EGQt5hvQ8bk+8id7vNUTVzzSBy5TATZcMfnOHiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4qZYhv+3BsOR6umfHZ4S7ZLcULSJFmsSLCFn0DBUs4=;
 b=cGDckNN/G0+QKv+1cP9/zU1ztWLN8vqX4L21po2VP2wLDxeSldRI2b/HA5goqX0ybWHO6bpq1KdfKnRLsfTxpvN68uY3bohz8NQJslWPAPw3ZHRoListbxmhG3NlIoRAuTI2B7dn9wtCyDebA/gWNl4q2A6uEXWT0N8WZpMveIU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB6336.namprd10.prod.outlook.com (2603:10b6:510:1b3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Sun, 25 Sep
 2022 17:52:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351%5]) with mapi id 15.20.5654.020; Sun, 25 Sep 2022
 17:52:05 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH v2 0/9] mpi3mr: Few Enhancements and minor fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k05rpcjp.fsf@ca-mkp.ca.oracle.com>
References: <20220912135742.11764-1-sreekanth.reddy@broadcom.com>
Date:   Sun, 25 Sep 2022 13:52:03 -0400
In-Reply-To: <20220912135742.11764-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Mon, 12 Sep 2022 19:27:33 +0530")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0043.namprd05.prod.outlook.com
 (2603:10b6:a03:74::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: 07fef1c5-4119-47de-16c7-08da9f1ea890
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o36YFKDP1Z4+SQ3J4WFkF4JQH1uyRyiE6JsgHuVDNxzBcTAJlq3L7pwiZgl3oh1xcCGogsFnZXAZhr8n2Ash0xVKPRzCw/jol9whOEP32bvYAuBHTMmG0aDHUNx9nT4gnkfPZmq11oVuohPBZeAk4fnNHyvQYiYHPIVkEoWHe3a7gzpD3pfGvWduep3caTlF88/uxdeko8gzk331AEsdzuThKIkV2SkWeWaN4/iTYLVgQuBWyzITVYJ72FVT0UvEk2heZlc9PQUB3wiFyd7KLuILnWuycPDxjtOBLEGPyshMVozToKCU/E9iPvO8C/tBFCSDMnzPqvGGrI6XjpEAhNxCx5/QhMGBfW1SZFltES4kxhyFM1/V5nO6/c4BckpnyjcqDeRdZvqUOgbHlZHd+s2P1xTOhxfKXj/S0Tj5LQ6mwXieFr7T5X36Ff92DTgnsdlBQDVGvy0rYxwxp9QIWdH8gNxn3hWUxx4g6g23lsbfCUWF1OiFtUlA0MjlcsLxcCoxsxbEKsRDzRC6IXlgXXLn5LDpyw6FX9ZORTXmgZKiHfcNU9pg41VK9ik6lRuh2p9m9Rw/0948tignO7HD9EfPQ9Yat2IIGO7I+NEabB1tWz5c3W8UvD5WzPpQuiMhnFdFHarFqRpYQhmN4gra1BTipUIJsqYqaTde3xOU1yFCX2/lmvvBF7hctxnmIhIPTBh/wQx/6bKNYAUIro+9yez9J11RGexv42uP6ZF71eD0RcfBo6QdbFj8ewPYwyqr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(396003)(366004)(39860400002)(451199015)(66946007)(66556008)(66476007)(8936002)(5660300002)(558084003)(86362001)(38100700002)(2906002)(26005)(6512007)(6506007)(186003)(36916002)(6486002)(41300700001)(478600001)(107886003)(8676002)(4326008)(316002)(6916009)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nINSJchuz4lFOVCbB33X5N/AQpMhuOcpktmrHT9k4aVbC0DdoNfXUmjnyPPM?=
 =?us-ascii?Q?tQMWMfLHzmWGWIpzVGVRENjmPORSm3G2kJzgFDUTU9/3nW3oBsVrr61r3OLW?=
 =?us-ascii?Q?lXfmp9geR72R4VL69+bdqDlZBTan+3OyJ5zeNPnmBDKK66wDMcMP7vsocp37?=
 =?us-ascii?Q?zzKc3yL/+TSzbTPEF7InXhwvO5hY2yUJ5cCGB+vuEfcDtoYOhsGlgPmVmTLg?=
 =?us-ascii?Q?8jO1sDQwnYZUrIhLy1gUxx+Go13J7zzi0u985bIIokebP/QEzBdZF21cRSUk?=
 =?us-ascii?Q?oP2iNNZNodWB+9tFL/ifZ/RFh5CXrq6ibT/GylLUi/o5XCyaxzyun70HALcJ?=
 =?us-ascii?Q?//2Wn7L/6H2vCt5RJwF82za7JJpjUy5llGZI6wecksXgutoP9b/8pr6er0nt?=
 =?us-ascii?Q?QPu3jF0mUyAALC3fjJNrND6CcywDOg/LPmKyrayoNSLmkS4CBC3syQQ8RVml?=
 =?us-ascii?Q?QLd81e0JVxxSoiCwFvlMEnsictB35tsGSOgJh7Ox5bdyNr9raI/qrYL4Oq8C?=
 =?us-ascii?Q?Z7vRkVl+1Z32sgObdnyCbPQWxK/2uTiPFA0OlaLE3Y9dfJU0h4NVXv0dwhRi?=
 =?us-ascii?Q?GafkDEhcD3fbm8tOZ64LURffokWkgfTKNwSMZ6tTBF6Fq4UPs6d+9TEtsKH8?=
 =?us-ascii?Q?LAUkWiSeKhB+rohehp69dPbCRUek75NYO9haz+MiKG2OrQPGMni5yL2tHnDd?=
 =?us-ascii?Q?wL+syLNsAkvi3t1Pk4TtRQZ1O0wsBejnst8QQOQDhtJhoB2Ak+W5vY9RYUrt?=
 =?us-ascii?Q?pB8rwdb/ytAUqe+GsTA4Y0pRUdasd4e9yV9dL4bNMKeDj2nnEERTk88HInvF?=
 =?us-ascii?Q?pIjClY6/duefy1gxPZGI4SrRH1iwdip7avOjDd5hw4RdG7YO2gjKJ41ZTmy7?=
 =?us-ascii?Q?ArP42YzvYRFcoH6w5qW4h0jM24PoKdrKGDK1U3NIVCWA4BZk4OD9ydpsB1fX?=
 =?us-ascii?Q?S5BRMLHtfDh8zOgcxkTZuTYDTtx277vsS7M0uGsRgpJxGX12fBJSSB+Rn0Km?=
 =?us-ascii?Q?YDzDiBE2qcKcLGt2vAW12UJYv0SUHX9MTuGblHEYaS59VdyU6yY8MnML7nQR?=
 =?us-ascii?Q?LgUVQdpGwio99Z3X1GOTFsLvH/t/Du/tt4tW5zKuw71jDR4TnIvgLbgau/Sa?=
 =?us-ascii?Q?ophn10oxRZutIBqIqsFiMrF8yIGGXHhoKaxtR4OrEQmcVKgvsB5r2+Dml28C?=
 =?us-ascii?Q?RdydzqIGI5S4jqtEFGd5su9tvhoQbVInyo3otwwkkKMmD8gibhuPgIZRJ6HR?=
 =?us-ascii?Q?xcfEZsR6wzwO5uw/aQqahggqyIaviC4Lor+u7WDLy3HLSmXi5DboCdj0K2qN?=
 =?us-ascii?Q?fu0cXqqHoZn1Ng/jg3OWE/8cxTATeHcOArBFAlC5JZs4ns/W/+vFDmpQhQTV?=
 =?us-ascii?Q?ZCAnJQFkh1pp6Yg3EJthlwNBig/DcNskCdOKmFkIc1sQrFmb61AEH0P2wNXD?=
 =?us-ascii?Q?nyFLhbdkS+SBxPLlJe/RgWCLZGdeuyVgxvz+GFM2x0hanuGZqTXFzvuvHSc9?=
 =?us-ascii?Q?sPI1rQejvV5/EhI6LKTxRJBWv9xnFthm7hmfoK1lYJrSq8QCCblPkO+Z/d1D?=
 =?us-ascii?Q?R2ZI1zFJJx8THqSOPl8Lhm9W6F+PvXkzS8obOK63qqxX5kiGvgu8q344erdE?=
 =?us-ascii?Q?Uw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07fef1c5-4119-47de-16c7-08da9f1ea890
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2022 17:52:05.3759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B7u7i3UyxDWA7fSIU8UtlmjAnJqzV+9y9fWZ0xbzsBSXoFnsrTK1EJ7xDaW6nysmniSv1QDoxdVuRUPVPjYhAAbPhnQ8GhNcQ2w8G2IoK9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6336
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-25_01,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=855 phishscore=0 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209250130
X-Proofpoint-ORIG-GUID: gbX7jCVhgpFDtjdql2BHEXL9qkJ1rQXR
X-Proofpoint-GUID: gbX7jCVhgpFDtjdql2BHEXL9qkJ1rQXR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Few Enhancements and minor fixes of mpi3mr driver.

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
