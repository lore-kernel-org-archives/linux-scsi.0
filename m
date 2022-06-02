Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDEBC43334
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 02:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbiFBCXx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jun 2022 22:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233207AbiFBCXw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2022 22:23:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375686D391
        for <linux-scsi@vger.kernel.org>; Wed,  1 Jun 2022 19:23:51 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251NXpMh001846;
        Thu, 2 Jun 2022 02:23:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=llKkSAcXy1LB4pRFBdyhrt/GigMfa7TqMXyeF0A8BfQ=;
 b=Fni+EajINbDVPW0z4gfaM2SsabEqjnDmOq8x+uw4jRQbPzNkYZckDxDh4ZWBO8n1F09E
 5eg1ShQrtk8qjJ5bL9Wkv6axvafLmfqlDw1KZEHlNiAd7Ec5JkkXJVRTB+dfU18bGBMl
 cwJ9k54eCPCA7TBIKyJR9sPttxjDnzTJY6Au5IX7YU5rs9lSu1TtapXfGJaqWi2B4pgW
 27tK4GaJ4xufjlKmBrAUhP5rFaAe5/0VS6c8YQ9X0xAeMerPWw79g6457dU35xnxs3Ak
 BT8paGlCGDL8I0Q83Ne6+rdSyYzHPONBIi/BtVFZY5v/iXMbrRzNubNi2ploBMO5z7kl ow== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbcahs8xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 02:23:49 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2522GNs6026622;
        Thu, 2 Jun 2022 02:23:49 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8hxqyah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 02:23:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aot1xWjHayb36tB6580svGfDrBbMqU27RQuPfnh5/3DvVU3TCMJXJFVMnn7LAWJ1hEAeNWF7BE6tGAlWxBBn59WnZEBbbcsl8jGpbzduMSKU4IdDI6JIAveTIqi8v6PGXHzrlPTOXTCIAuj3mpesCJsYuekDWxe4ZA01XW1C4+8VVyZun+1PioScnGd2ab95nzoN3XSo8FuFpkr8RauEptEleKpom7+DDNEi4xkwWKYuYLwpL+egB6AcqqU4Yo9q/yT/zWUIdB/t5hFyMcq08gfGSCOhgeDu8xEqs0LFb5bgMTyUwD1O/7EH60H1Nq2R6iFpbzXheAfSLHMv034S9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=llKkSAcXy1LB4pRFBdyhrt/GigMfa7TqMXyeF0A8BfQ=;
 b=nw1XVR3dq/XOQyOuJSPuTq3Ia90LbN/6cqXM7j+Qm3NXzHgMNJylhTMsUnurXkjLYgz4AuIojRqXhIs/4eSIpXxWJx15rmgPjtSin1wcgKLdPeom6zYoQQefKOam+ejv4DfLy5IU8kqmUb4QwKuT6ERgObgMdOy8++z/OKHKhAqGoAtGm8EV/kyYhv7MNRKQ1QyBc1L8XWJBuw5TPo9dwb8iQR9KXJCmgJLik1RNH/pRoq4DjdqIsO08hP3t9/pUH8n1jwEzZ28B4GMoL/katnWGPyq8qpiZ3Re1oTTYMBZMXz7hqiqNMcz/NHfGFpT0RALfMRRzIZSO6vi1UDnrSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=llKkSAcXy1LB4pRFBdyhrt/GigMfa7TqMXyeF0A8BfQ=;
 b=sEQxQVOfIGgzXOUfte2BFY7Z2tVTXWqsIca7amVpPIHbN+ImPZWz/eKgSyM96o/cck/+3P/MpHKGDdrHpRodc7lzpiYwXLNzOb7a4roRWUCgMJI6ovh/Einw0D8KPW2Q0FtxFeCK23DuWBzirhD73QxKl+pGfu918luJZIBW+y0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Thu, 2 Jun
 2022 02:23:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 02:23:47 +0000
To:     Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] mpi3mr: rework mrioc->bsg_device model to fix up smatch
 warnings
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k09z6bxm.fsf@ca-mkp.ca.oracle.com>
References: <20220526170157.58274-1-sumit.saxena@broadcom.com>
Date:   Wed, 01 Jun 2022 22:23:45 -0400
In-Reply-To: <20220526170157.58274-1-sumit.saxena@broadcom.com> (Sumit
        Saxena's message of "Thu, 26 May 2022 13:01:57 -0400")
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0099.namprd12.prod.outlook.com
 (2603:10b6:802:21::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2042b025-f425-4b9a-91c7-08da443eec40
X-MS-TrafficTypeDiagnostic: DS7PR10MB5150:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB5150FEAB605B43A2543FFDA08EDE9@DS7PR10MB5150.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vKz/SovE7heX1gJlldKF8WlKSaqz1DIruNb+a1Oc+l9YUqRydckfgl6ZYUQu8sFWbYBe0zfJZ49Hx4BgBP846JqByJ91KznuSk3WqCAhF/vl73t49FKiafWh8kSzaKNp1Yd5p4XOZSioojdd9CPIJqE0+D6LhhD4gQOaV/TzP80x4d9JlXG01yeGMoun5vPe8XgzUelUcj/IJiLCZiX2Kz8h68xjtaDo+o+la3L5rYRlu50W+Oa3RXCcMNmf83pqla5p+Ci8LOYNwytNNkQaed15HrB0Zv62OjMs2Hrwu52QCDntyxsFIpwuZLhHfcb5iFi8sm8LOxj+A7P5VZJrkkqBzRRT01ABeg2vcrlWAoE7We1TSOem0hIz1qdXN7zuf9vAS4ZAZ/pH/KzsXGurMTdHeEfGQCBtYtTVK8h9D9i03zw7oBp6zIKtI3EjJWT+Mh4T1Du9AyPFxLtGhET/MQuCI3UBkHBcm+gDSYa94XpB0nHaUTmPCr4osXcFncgpVdfZDSNX2YZibkKV7TU8MMggRHF5dMD1C6osrFycpknXBPZaOwMGo7i4KNW4TXj0a3wkwWg0wIpJGfa5D3V8kcm630QX0FwZC1f31TqiuSyNOy2aNKiPf7z/fYN9o956uJRhLbmuQlL8y30cf/iC+aIoxZJYJ6PTG/PX3GtuTDPsWbRB8dI6lyRqwLhvLHWWFaS//wJjcL6EjodPM7HmakfAoY7JJmi064llx6deKgU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36916002)(52116002)(86362001)(558084003)(107886003)(6486002)(6916009)(26005)(6512007)(2906002)(316002)(6506007)(186003)(8676002)(508600001)(5660300002)(66946007)(4326008)(8936002)(66556008)(66476007)(38100700002)(38350700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ExRlOO7IRDe1oUrudUTmQkBKMvWW3jtUeoq0wPZtvAgm3YqdqVPBF82ltZft?=
 =?us-ascii?Q?tMV6cuI5hQ6bxoQZu5W9+VR4+uI4aqmpujTuQAXbAQC3ow1auSB9FXkLZC9z?=
 =?us-ascii?Q?Ajgn+F7x7UBOoMyghjKR7lgorSo2qz1GjnFQLelPSCJ8GhVVCEyRYjV2/GE3?=
 =?us-ascii?Q?9DlMxlptfH+AV0y7b4X7mqn2wDWiZsL65eNuqW5FtCpFUf0uXOZ/N/zx805x?=
 =?us-ascii?Q?bvb6CiIMupe/kgN1UGAchCCjxc0ivo4J2KBbj55+9tUJp/U1q6J1usHq0kQD?=
 =?us-ascii?Q?5Og5oxR1j4cvhk4gfWefjXjjdpavFcSJB3Eq9MLYb5E437d+Ed5j3UjdY8xZ?=
 =?us-ascii?Q?ueJNx0BokZpw64BQuY9GSh8W/cWJfruF2nMLCb/RJZhU/DvTJ5nbLtdwrPqC?=
 =?us-ascii?Q?G4CqXnbfFjRuY1TQk/6HDkzm0l18wOpuuol4LlZqdmXEl9QOW1tR14Gghmk1?=
 =?us-ascii?Q?xkuA00Q5jJ9xrQ5Ue/T/ZPVE0B9ZM9pshgByqqmEUXB7njO2ZNDFGDMdcifN?=
 =?us-ascii?Q?vrAqLb+7WG5zOthm7VXGkio1A178imJd3zbss2rLMTPwhvCrw7/VbIDyvYu3?=
 =?us-ascii?Q?rh52WJ1e87kBFpdjDKqehe/EZmuaehwNN0Gtir+4CnacrX2v8EMwIGCMMdFd?=
 =?us-ascii?Q?8phZaYjHhUMXbTPLihIkXFqLd6zE++MPjH/bOPIi/yO4P+WU9dYCOJP7z7ln?=
 =?us-ascii?Q?dGZnnr3okYx/N687vDaEBJUo0D4cEw8aC1WGSIQPcJ95e/s+Mih3QySclu6O?=
 =?us-ascii?Q?wqiLs+gEJEkLqwdyNviFu7/PLHRMWy2xLb2xK9fbjTskuBbAYLedYt1Yqa73?=
 =?us-ascii?Q?S65A5jgTZKZTp68QZM5rrq4ZjZPMZeY4rKQYLpHrKTKVQJ/uLG5BUT55W6xg?=
 =?us-ascii?Q?JBYC40Dp7Gsk14l/GUkhk73NZ3/YEzlAyJG5Ex2uV6YbE1WzPgypWKPGHlGG?=
 =?us-ascii?Q?ueO9kDgo1SMAqgr2cW6IorH9TT3mgEtv6NHpMFuyXd4kbaEt9FgzJjhp4zNR?=
 =?us-ascii?Q?ygCB05OWhrqoG3Xzy3PoG1QIUR/HzxLP2v5OrFrR5FTvdOiQB7YDWIlnpXa4?=
 =?us-ascii?Q?TC98oBS5MsTvWy9V7i79pyq2vLOLPtDS3ruy7daIhGjapoFwyVLDDnrlEli+?=
 =?us-ascii?Q?M5TZFZbYbIxXF8OmRFFNIs811qryrqeGGWAeLKKChLz4EBhSt/C350BmkhPQ?=
 =?us-ascii?Q?rlWL2/5GRCnelOU/htg5h+T0DQ71pbA1IIIU3OFGis7eVB/zoCvGWaSXvDrW?=
 =?us-ascii?Q?RgSCKv/QcG9uhE8wTDmoxnOigjspdzzJ+bTD5V7vorTRF4cChIUAQMtM93PI?=
 =?us-ascii?Q?pMiIRoHkQF/5SpviYig5Vgu+AVYAeVbyEZ05AITRncqNqs0fXVjMVbVAVRmX?=
 =?us-ascii?Q?aYVBw4nJiKnn6nyTch4fNA/VkcxV5BKnaW33VRa1P/8vDq8YwLDSb2SVMDT5?=
 =?us-ascii?Q?FTjni1CsmOoqrk7ANOwJqlS8QXbco/cmOFW6Yfdv9YEMLO+7XM/YxMXhfqT6?=
 =?us-ascii?Q?QW36t+/oV98ZOtnj+ZBQKMWc/oJ1z/fW0dzu/YD8BChExug+kVD4ya0D/rJ+?=
 =?us-ascii?Q?VqK2E66yNMeA2LYFDQJEip6vozyLy894sUE6TAwtpQtYXXj9KleXHkQNOqj5?=
 =?us-ascii?Q?l0/6DOR4ddRGRchDkiH9Pra9Qn2hphm4rS62xh0kdsUMEISX3nviLyegHfvF?=
 =?us-ascii?Q?NrNc5MZjXkWDjr9QP3FGlULaZsSZSMa1APZyvYmcfMjq1y1chnTex0aWTGo5?=
 =?us-ascii?Q?KdoqxUUAdZL0AvVqi2c9tzV+dSXogF0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2042b025-f425-4b9a-91c7-08da443eec40
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 02:23:47.1318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lj9CrDlwKxIaYZS8Y6/tH/Kl9O7u2nZw7hjc/Mt2MN4slDyk0fnIEzs4sHG60qMZuabZxS6yLI0zRIxNvJLhXpg+mmaLQjvufcw7QP0r0rs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-01_09:2022-06-01,2022-06-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=770 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206020010
X-Proofpoint-ORIG-GUID: YzZ7_XgUtSGCS5H2DJI3AqGbw4eFXzCy
X-Proofpoint-GUID: YzZ7_XgUtSGCS5H2DJI3AqGbw4eFXzCy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sumit,

> During driver unload, "mrioc->bsg_device" reference count becomes
> negative.  Also, as reported in [1], driver's bsg_device model had few
> more bugs so reworked it to fix up them.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
