Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF44CA1003
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 16:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjIEQFr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354158AbjIEJ7H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 05:59:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB74F18C
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 02:59:04 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3853OSj6018295;
        Tue, 5 Sep 2023 09:59:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=nHthuUnoyu+hoIYydtlnNmKY36w8Y29ivBYeLCZAuEM=;
 b=lOC9Bp9PMykKGvYCav9CxSUv7nqdSps4kucpYhd/jKeDRg8ck89E+QcEZp6JarcmeSjj
 YTUpJEeZn3m+kV3vzrJXd1jfCi1U1JFf7vgmAXRCWXGUmBJWHc3GXS5eys+8dEsGT2wf
 BPMemffAgYdlFtVGPwCjrp3f+MloCd0dG3wiJqmnPI9txLWYLSb61DJcxkS3+29zhZbX
 kudNcVdNC56Ma0mmS1CyiOfGQWnix3VfFVe8oO0lc1p01sCx8ZTAtgLzT2K71qQTg+rG
 uTFApV43OY0aaPLY60qjXRRKjRT9TDgTBevd5CuNh1mtJ2SGlXBaET9n0O00s89q88Nr ww== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3suun1n083-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 09:59:03 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38590RZs010418;
        Tue, 5 Sep 2023 09:59:02 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2046.outbound.protection.outlook.com [104.47.73.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suugasjqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 09:59:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fjo70w/OlmBXStjhci6S+fxzh+h8j0GhBREtdJv6HIOjXBNSwS9j5T5txc1DVknoEO/wGLrui+yKdITef3L3W9NLR/8qzTt+nFIzCyVX/9pJViIpS520ptq8G4DiPJ0YLvHJUQQn8ykqnAp9lnUD+x/Hmbc4zuJuuem5ZbT/W8SD7CmMRnigpj+zZE+uUUG8SDS8VeDoqbVFt2zE547X5419qRMIEM1VsSzsTRTDuq3KWA1d6lHHW6MkcI9QDkQnl5jXYo/nAYuET6CxFQxGvXtUF06Aw+scFCDBhkxCcgIKpIPLgDaGHLUS54nzxC01mxt2VKdbh9c2wEQQSLEiuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nHthuUnoyu+hoIYydtlnNmKY36w8Y29ivBYeLCZAuEM=;
 b=YeGQqjbBZHJjhCnVGy8h5nhLqF6hHVOhZ2DBquCqpCnXFNUYJ6eJ04JfXTKcAV4vQux1z4VLHCbvFtWs+1CORq/cOdUjV189vApHBP21sLISWx2rhf8lJa8IJpgff4NnidET0R3/ssFmQacqgOfeXf9/H+prl62Bb7v9zsRwpOW+1PaKQsahqqct7rYZ971d5Z70GX3KwS6AxcPny7QC/1knqWzqvmGMcu/kNuJbAbIkwzoSGEHvmAt8K8+mFBpVRp7Cthw8Q3emLFWM990vgtrbWryEyTn5tf1aM3xLQqZ1VZcW8tcLqhhMB9AhZYwseup1nIe7A9m+BrXaexycPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nHthuUnoyu+hoIYydtlnNmKY36w8Y29ivBYeLCZAuEM=;
 b=PhI/COlOEvgP2tJV6Z6H88uJw/wPkncjOPDiDErdk/HknWV/rbwsnk9O/+lSCygZIXBbpQ0cCar/zaISv1tuw1g8mx/CIx7W520Rdnvn2GLFJZskcWtjtulyLFb2jSbyAWS7KaXjuK6yt2Fg20oumYcVLqT/cysbC9NcAmJfOgM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB7359.namprd10.prod.outlook.com (2603:10b6:208:3fc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 09:58:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 09:58:37 +0000
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <njavali@marvell.com>
Subject: Re: [PATCH] qedf: Added the synchronization between IO completions
 and abort.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11qfdkkm4.fsf@ca-mkp.ca.oracle.com>
References: <20230901060646.27885-1-skashyap@marvell.com>
Date:   Tue, 05 Sep 2023 05:58:34 -0400
In-Reply-To: <20230901060646.27885-1-skashyap@marvell.com> (Saurav Kashyap's
        message of "Fri, 1 Sep 2023 11:36:46 +0530")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB7359:EE_
X-MS-Office365-Filtering-Correlation-Id: 96d99b4b-cb25-4230-637e-08dbadf6ac69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: psIWiYppM8/Kb7v+bTxcPNyg8Jj0nJzX3N+afQ3F9r1nnIO1LE+8SLmV6aarJHRCn2kUOEDRknoVzA5fug2urTUFSK4a7gu7H/zQiEXgbeCx84WB/auopDQwSEymWeia0U2GJyE6JURK1ZD/Tc0vLoUS45iev4fraxs2AU8liQ4fBwjSvNjvWPfvLuuc3crOWwB4H4FL5JehWojDZOslg4ZXdYhlN6A88G/yNpcMcjTOXHVZrH3cAb2uBdrwxLVUQ9BJUoVtD6bafZsm8nuJAd6kPvWLfNnVS+oz4h1XNHM0fIksRfNST51mgC25k/Z1+ZlV/pienhHqYaYTRowKW0ytNbvyCxIacnwhSQRyhgHlYMA42f6K7PA9AYofv+YUEw7gfOgomRjlgVGlLQNMgcgH3TdLaI3WRZ6iE7pQ9YLhqQOhMni4KgzEZJPMngJN/LH7ErKJVw7BgTkwf7B7WLqBENaNxx4JcKXU1C2kw/VreCu6WtM9CVYd2ri5BRJWJOdM7guM42dyhkqKINP1Kz8W7CdyxNptjDcgLzpboR2TjvY7VlZm3Q6xt1geqeTK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(376002)(346002)(39860400002)(396003)(186009)(1800799009)(451199024)(26005)(2906002)(558084003)(83380400001)(8676002)(8936002)(6512007)(6486002)(6506007)(36916002)(86362001)(478600001)(5660300002)(38100700002)(6666004)(4326008)(6916009)(316002)(66556008)(66476007)(66946007)(54906003)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wbYvzm1ajKWFzMj9QgqMx928pqUeDtRQ/ZdiK9QUMP4nNLsEdC9n7SR4iRNe?=
 =?us-ascii?Q?KkA+joY1avJug3d3d5vmjdZv66mjWODRhl/eRUYb8DWPbglnI8K2Od1eLr8Q?=
 =?us-ascii?Q?xe0g9sS3ccSiknZYzyD60xNeFxWJC2aAmy4a6dchCIH4eiMsC1kFO4us1MvH?=
 =?us-ascii?Q?2A22RWyE5wHh8C7t6X1DxMOeF3yheY0YacGKYSZQgQ7bD+rRYstmQBlAZaom?=
 =?us-ascii?Q?1kFUCqPjROhcnTjX+fEkCBGLilLcPqhD8iJjXLYVl72oxWQV5K6nYOkWfNuD?=
 =?us-ascii?Q?/7kaJ+himkdySe71CstZ6kJSnfIgIAC5MY4fG2yUVvSLyQcpJLlWRgfF0A9p?=
 =?us-ascii?Q?ksv/P4fkVTLrTnvgmaXESSv2rHpI0BcLELF4lr7OP0nD0TLg+XI7mzdXJIIA?=
 =?us-ascii?Q?ooeMNDtlzzWpNPB+5VcbHaP5f5GT49VCr8tyPN/1i+fGDhLYmAJ2sK9Xeyf0?=
 =?us-ascii?Q?A8qw2Ga6dS+cPAzz6sSV5sSwvAQQUUQv+VEw07Hbx/YBPFyvawnGCk/sNPwN?=
 =?us-ascii?Q?cps6JUJPkRANsyv4qqDcdWQZX+FaldKbSTcrYFHsI4k/pzUup76eFWBmX1Fb?=
 =?us-ascii?Q?nYpEQRkaRF/56/CzfZ5oAjDJdx5tDyB90p/wbbu/B/xSMigTkg9Aslro/uNR?=
 =?us-ascii?Q?0c/pMJqYYg/Dx4sqnNnZyVlL5CfW/Wpt1PkjTWiyPq24XTLTTPYATAVRw4DM?=
 =?us-ascii?Q?Z5zRjjCO1r+5drSyMR112sK+QWDQVVTm1dpkDxWz4/y8jnpJkI0lJL51bEMf?=
 =?us-ascii?Q?Jy619Jkxa2LjittBY7e06+wm/Or4IovKDWh7RcO+yghQj/n4O9/etZai+RBS?=
 =?us-ascii?Q?0u+9FTV1ltTcCJ7uaYpH4bsxyjc8ZQFyuWOMqgQW6SzgO8w4sSwl+ugX/YDW?=
 =?us-ascii?Q?iWHO990QZPHvtP2P5Toj5TMajd01ZkuT6/vXL8k/Y6XXeDRQ7wkQ083JST1M?=
 =?us-ascii?Q?1CifQHiMI/lx6N0YXJOnupWb/CwOa4Q/3voc4lhMGEwnnW1W/nYYGb4dYi0/?=
 =?us-ascii?Q?X4VdWbsvL/gkb/X0Iw+TmZmkfWd7+Aj2OzpuGykK447UCg6vsgjXyOqlqWQR?=
 =?us-ascii?Q?pReY84yTE+D/wnjhbMYaaVzHwwjbdgEvYNgv5K9eRuSgt5qxSbPVHcftQPNF?=
 =?us-ascii?Q?i67WXz6rnWW6fJpGDDM1U05P0hzn+X8JoTyEJkO+u6NBWPuqn6DYCFtT+pvC?=
 =?us-ascii?Q?RKQDgg9uoQjDhahQEFkiobbuF0IlC1/PiosKfVxoHQPI2fiyfbLvliKN4hRY?=
 =?us-ascii?Q?yTe3yde8xRFVR/uQI1R5EopQInuijX8jGG0GcRx5RUlgkgImRWRGOseFdoN7?=
 =?us-ascii?Q?oq3ZJxawm/J70NENN7XmQx9+Z+TdvsPaFevuOOIvRAV3PcCYFrXOSRSKru3N?=
 =?us-ascii?Q?cDpgl1NNf64dQBZwowD7bmlwzRIlRos4nlk16sqRDmF7CNKhAlD4cUHrAmYT?=
 =?us-ascii?Q?v/Qb4jIFP4z93zWDdZjf2+ZKX+mdarisq3Ssb3RxehzwuSj2g7qGSgigS3H2?=
 =?us-ascii?Q?ifbBRQBt0TqOP+f03l6Qyf3xg7dLqZB+csbHzmi5ibABG5WMMYWOll+TY/ek?=
 =?us-ascii?Q?/krXRV/FtLgwQjlbOZO2h9laQC+7l6duQ2m4bY+FQGafFGxh7Zlpf+W0hwb1?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bb7vzboAkhNc7hQCUxcs380y16YqbtpnBcQhnXZQPF70pEBYqXvMWMP2nmMm07M0ydYaSHWHQ6msfhhSCB7hGiqqaJLisxL8wH+ua6AR5pXtNHOX4QL2DWWmEvgqDY5dYoSXSARCdWWZwpL4AbNbBaR/nscOA/2M/7q7rCMpbjTNfhpdD7hkKBh4suhjBtF2k7bZCWoLzJEx7SSjCPtxs9wefNnqrrSN1T/QQ+y5ZJUdk03BAl1B9C9wQoO6ITgassmNRprQLmUr4Pm7+3xsRQUMc7MuZQNdHcl50QyupWOjpoHXU3X4jKhUbm6THU4Q3Nzvg2lTdzrtKxd0rLhHRXlnVoWRQbJQazfOoi/XMN8aV0FI3bwmZ+LLGpw6W5rHstN+n6bCj4DUopiBY8U6pbN/oS9N+0ViYq4Y4WgChQJvxsOs9FzO3Lrz3RTNyszKZw88BAzFGq28UDwYRxHJbwjtcYTt+K9TLRJDMER9+IaVZiZL8DHy7nEkm5Zx/FS503D1XokBqmDDIop/1wvP8GWhsoo1KMG4KnW1c6unWHUtTE3tbsIbzcb6XCHsoOfQ13cpfFQLPyn052I19v9NMSYxh/GhnEH6oUbwY7rZm1x6HuaZh5Rr2t7lstaxONNxkSuoCgo8gUpZ6cv1UjVn4gKnmbykbhnvYKUMbK8nW9yf8+zgIHETzSKUvtuuB7q6v79Ser4+wgvTlHHKw52ZAeiHkBLlct1TzpBSfTrgDxUJPZK8Hkqr9tMoTWrpfC5yjPWvHNoAYWPczOAOPH1ojaJWt5Mh7MiRSk8jBeVD6DU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96d99b4b-cb25-4230-637e-08dbadf6ac69
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 09:58:37.0285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8t8YoeV9TE8EatzUlz2yeLVl+VvlhRLTKrPgsGmBaPazd7vRRfY1Ghw4VfVctbwyqkOZjzs+6J4gC+pa9E0TrfiTYq0C6Bvy+qMoQcop9Mk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7359
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_07,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=551 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050089
X-Proofpoint-ORIG-GUID: HAiizrX82A6lyp8SN_WRL_C8BWhcOzst
X-Proofpoint-GUID: HAiizrX82A6lyp8SN_WRL_C8BWhcOzst
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Saurav,

> This fix is added to avoid the race condition between IO completion
> and abort process by protecting the cmd_type with the lock.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
