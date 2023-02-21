Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E812C61DA3
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Feb 2023 22:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjBUW7V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 17:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjBUW7T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 17:59:19 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F892BF32
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2023 14:59:18 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LMi4De003985;
        Tue, 21 Feb 2023 22:59:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=bBuNUAeMRgU30dG35+RYdrrQ/T4+Zh/jGGXbvlVJZGY=;
 b=tugLPKKCOV8slwa+lCji7vJf9KtVw9cM47abALtGOORua5de1BXR91Cc10qRkztrrzBM
 VrEcvDIHd2jFeN6irqoRO1A+aIb7ghqvPD/0zvJmLWJUFRFw77TWNXhPWEoQzBdLpoec
 orSdExPBzlI54vFoVnHkGS5fLrnFlvBdJNpZMXro4SHVzwGOYHyx0tUzhfYZjh/C4IWM
 vKrkR1o+E3FjB2Ipn/5ZzIPji4yZR31Hw0rVLb8qb9SJQYfCqHNnIMFtbEZn8ocVSMnK
 0pqafQnHMEjmkaRf4+uLkxU5mlo8h/QjfnMg6kRn65dGwp9455xYS1WQZuNlbvu+tgiS Bg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntp9tpkqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 22:59:16 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31LMCQTC040879;
        Tue, 21 Feb 2023 22:59:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn45t9u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 22:59:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fTrm1TFfN19wfB+8AEZNIV+fdOh/SVfR/VK4SAjkf1cF+QWMd0L91JKfqcPCjAtil2E1bMIrf0EdnUNnyGx22LoKBUuDo4sjiMGo6mqAfCtt1RgXoIMMv5w5i6/1wr4AHoHvG/XJiAbZWtiaaRCmQwKHGLijEhQrrDMh1gr8RGQDENN8JJGYh4JRYwWd5lL4x14hqfQp/W7sQnDFvpO0ZrdeKJ1mgVmhsjM7K4cFrnEp40VfizWH+F5LwfSACHKMMtONZ5cFxB2tsOvxurwzoja1O1kIIdJPtw8bv53Lqqp6D00JIctw9oYL/N94KNx90f9EkfKn9yAlh5R/kMmQhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bBuNUAeMRgU30dG35+RYdrrQ/T4+Zh/jGGXbvlVJZGY=;
 b=JGYOOr58cgs2vl1l4EXB6REYdB0MON6XGe0NGqVq0lKScRTWbE5dN7COwofB5KMKuTBNwq6gVBsXXUXKKAAXxmx90XysLe5BdRX8o/JUYCf5wF5tO024J93+iih4h4FlmASX4un4G539VX0JzQ7M60QBnv2NTy8edeoVR1jdne6JmikAYci4P+dnCS9TFsXrUHYRBvOetgI6HtrfZHIBr229XpiC496/aziDx+DWAxxSNExVO+GgQfsZ2GQEa4tZ1LIAQiltwgFLO8Y+TAG0LnOxxSoiXa7UL856bgyOPL2At/GLs7ZYrwuhk/Ci6Gp/xi1fagRv36RJTvk2DogEFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bBuNUAeMRgU30dG35+RYdrrQ/T4+Zh/jGGXbvlVJZGY=;
 b=WKizyAlF1WDckYkTXxDc6nGNXkJuvt0LSLK/xCncd/iRgtyyq4ZsNDz8Xz3nAitnY3O5h8wIDiIR0FofR5wNlZw5Ra5UK0JkeeZSLRoTnK4i5B/4S1ZyvUL4xtgzX6+EsdTEEvVS9spsRIqr5RpRBmoyxL88b2IXSSkMICwcjfk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB7122.namprd10.prod.outlook.com (2603:10b6:930:70::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.17; Tue, 21 Feb
 2023 22:59:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6134.017; Tue, 21 Feb 2023
 22:59:13 +0000
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     linux-scsi@vger.kernel.org, mikoxyzzz@gmail.com
Subject: Re: [PATCH v2 0/4] ses: prevent from out of bounds accesses
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mt56skb6.fsf@ca-mkp.ca.oracle.com>
References: <20230202162451.15346-1-thenzl@redhat.com>
Date:   Tue, 21 Feb 2023 17:59:10 -0500
In-Reply-To: <20230202162451.15346-1-thenzl@redhat.com> (Tomas Henzl's message
        of "Thu, 2 Feb 2023 17:24:47 +0100")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0350.namprd03.prod.outlook.com
 (2603:10b6:8:55::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB7122:EE_
X-MS-Office365-Filtering-Correlation-Id: 03c21a74-2f42-4ce4-99b0-08db145f3ffa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SlwyrU4iPdE2gxTVR5oUW16URuYmcIERqi2qUvJSP9UJmwDOQ5ePJaSdo3v9Q+kHpGVkP5ln366cP/4oZ+sj1LXh+Bn3cm0mgq5JFzgO4CDarkjRlC8L+d8oTtsFN+zdoAHC0eP1mj4Bm0M/1hf+WsqpBGaZ4uhHD/GdkzcCIqTKoFDRKZ3z1NHvXCwzJ9Khy8Duml9hGWXtCpp7VDPbmuLGzwpZG90yayyPo0TU6HH3vUoL936w31SOkEHpb4lMfvAp5QlTkVscga5z+DoN9ofhjrnMvxmCD+LUdt7TvZGpHdGDMIf4z4G1goimqbRcMuZz15gIRGTWGbOTVrfIOjAQVhjALnNCb0JrM4P75/EgS32YdT867TX39SDmXKgB3DH1WoLW5JGTQaSXKe501ZvtYE7qa/3IbXOcS2mPeTsqSUXYXRH4C2gnrK4GUc2WTAt1/o8Zd18HdaNqKLPQjFAbdOfBBTBMG23wyk2YvipBd5JyT90HEl3YAogHfoBPqtFpf4NKtVIgerE9qe+Q+u+kC6wQAQXHA66zk4ZanUp77PFuSXkIDdLoQ/PrepsEVlH4TWw3l7MDBqYChQIhGxaml65HbVJiWrnK2/uGY8hbdZk9YW6V7Ce7IXZ0LuR6ndhU4w1pSaxuSIYIhXxeBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199018)(83380400001)(38100700002)(86362001)(2906002)(8936002)(41300700001)(5660300002)(4744005)(316002)(186003)(26005)(6512007)(6506007)(4326008)(6916009)(66556008)(66476007)(36916002)(478600001)(6486002)(8676002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oHNOEuahhxXCDHrtuoPS3VkGDyJJTFnZeS5SswuLTFgYuyKU/wNxqlQMHNvc?=
 =?us-ascii?Q?28x4rmDwj9b+s0FDeyLnZhbbv+HIKnJxI15Am30OkpIwmSEC/fPv3K8xJluB?=
 =?us-ascii?Q?+xdIlDtrjKJctgLhRvZH5sGd79rBYBLOC1MQRTkbYBmEulpcJhO2ZFWfQWKa?=
 =?us-ascii?Q?wQZYS6O2E9HhEeYo+Sg3PnEreYKSjBsqUVKnaEPTC3xHZdMjoTwKb6+uJX2J?=
 =?us-ascii?Q?BiFQG6aAVc3KX9jbktAkLiQM3d9CUnpd2xOQcLKWGofLzxwFKqVXqLd6FOIE?=
 =?us-ascii?Q?Gov2O6Vx1JiyfKw8z8uMe9zyWUgTL8k4Xa2scAk9/oyNEungNfAsxYDoSbyT?=
 =?us-ascii?Q?cymRBBdI2o9PL3bWWYN7Q1wXqXFb7sY9bYyl58hGPo/D5HR7hCNjqmej7sTb?=
 =?us-ascii?Q?gqOFQ6TxZ1v7DhMa/5eBVzaAv5lKG6HWV3A+OikFE8eMWuxTc4tHGrbFvAbA?=
 =?us-ascii?Q?b5f4ZRCbA5ev/xGAkbCj1ZZaL3DCRj8UAqA2zOKI9VddAKmutQpcbHtl/k1D?=
 =?us-ascii?Q?+QBlKmwXtDiuXVGsuXsSKQppOjhUr42doESxKczRKCk3kYQSCLecu7iwpeuR?=
 =?us-ascii?Q?srzjvkzaQ1PcUW8WkuIJHA3R+3Zwu8ZRdEYagx6Q1YUfW3mpJp153h4efSvb?=
 =?us-ascii?Q?KBvJjVEsF/Itx/jBDtmfcQE+6pfg9AkyjiKieefS0Ipvsu3GNWN5vXIYZyua?=
 =?us-ascii?Q?rS73dnxfvegNl0f209CipPk+QHY/eDh60zscSz3+hutqP6aBMsPKvqGnpaaL?=
 =?us-ascii?Q?RrLt3sUzoMZwqxfTpzLV+yRmOLISiJWynhdTMrrdRl5k6IOrmThxE0b2FqVJ?=
 =?us-ascii?Q?XxGdU4rgexEEnpLB6HUqc/j4ke5P5f5VbY/a4oONgrnITiP/g+HljMteSH+Z?=
 =?us-ascii?Q?UiXmfP51G5ZxVhvnFnkkoT1sS6rUyt24rp56Gp4175S7tUWELTyxAsn/ylLa?=
 =?us-ascii?Q?OwZoo4GiVEQtp7x5zNPVdJe8ZSpciAy4LdDmY7Tl1YsZ9N0ho58hKqdb/87X?=
 =?us-ascii?Q?xZiaarYIBVwV6ghU6q58jqfibPyNhI1gkFfVGCabgGveGlo3r536JYATNwfe?=
 =?us-ascii?Q?aKdCFc44yp2r7BDP08xqykqzSQ1f7b4W3HDcv2h7xUtUICkW8ynwnHC4iUxw?=
 =?us-ascii?Q?r2BUwNvw4F2pDOhj33QvNufokoh7uIDV2KNP/sUfN5wjbz3xOFDJcTqq4JFf?=
 =?us-ascii?Q?BumzMfF7394hAluWt702tIDdFeg2aQP75Ld3SYdp1kAcZZFA4KUyN7FHs95u?=
 =?us-ascii?Q?YqGa3l8zCdr0ijxdmlnSIvMtUwDYWYS826rpH2BaoYmkG5Cg5ak08GClp6gL?=
 =?us-ascii?Q?I8bb3IuV8CleKzpOerxF2EwDe51e827F8i4sS6FsMkCyNHpuEmKsQd/CDZ4q?=
 =?us-ascii?Q?0ry0YmW+bUADxLW299uEHMcMypEBut8tU+GqNirBhB58irOHv2tU8XTDGizW?=
 =?us-ascii?Q?RFpxkTt+cSAK/3YmlFo71A9i8jZRTvZpfBokJslbkf+O7xKlvKYa8l0ARbvL?=
 =?us-ascii?Q?+rkmBIdMbozEiXt3WIPrdZ9IXtHJfuzBdlQ9ih4Q9yckd7cHLj4rG4LEgw1S?=
 =?us-ascii?Q?8lgtqEODk6+G3z53776dtpTOzGE7FbxrPTDzImJKCEziO0Z6e3czDY5LjsNd?=
 =?us-ascii?Q?ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: MSva1ksbZViDUUEUEkv3Et96Sh4hiVmoRnz1Vw8ONBdKy62T4l+TfvdKpvLrzTBLVt7n7L6PbD0jkartydv8Ytw6OeOZfeCBTAQVEiZoW+SOhAicEYdzPksS2qKJ1/KkpTh709il1+YNB20ok/g/6+DhfTbjTMXUBUNRyrf+qWuZajkGLgwrRT6ELK8SGtJ90t/WwjbsPeEusCLTQjpeOmMwAMGu8kGTUPM6m9MMdPOhpARbm2aNMvbD6j1hfprUS3rrtC5dLeV0XBkd3eJscLkCtYOY7NRuPXJwuXaSYHQlj/DpsVpkp6nB7HuoIAfVhLZs97Mb7mi4Ra2sS57KEoDMioiKnQA5xQqSrBTjC/Pi8XdyqDcKRwkcCIotOWl984OLeP9Hlb19j8jNtBMWHdXJ1PadXuRDAherYmndBPRvbz1Nzmd0okKUVY/WdGjNRVvJy+cU//tY8bw25axE8krFfR7taLOnoSwKY/qMmNKPcK6SbG5trxTB6PVErj+7hs5ziaxfTOqGWhnjPt5MBpH7Lpon8rySyP7kOyEVu4IM6biTykAFj5JL7Vk6YwJ2FljPlbvtBROxkioN2t16INMFBFCuSeTD5Jh2Z1kGdkWGf2++FrJ9pVNiOgcYhqvDl4jLQZn6H1VZmuKbw+ce2aXHkXj2k/KCDigLiwkRtEY6vT/MwtdZWxn/GvrEeQeixe0eZIAEo2AEw7l3ponKfKp+VUvJxIY+4B4+D/9tiEoVZNbktgTfynLzjNUrWUb0zh18ATn6jHUe2vhR7AERBQmTQY/G/vwqDVx1h5DaXldhVR/mi+aY5yQ7uy7pQgfB
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03c21a74-2f42-4ce4-99b0-08db145f3ffa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 22:59:13.2924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: smSj4iuvkllkOoRWUP2C4cPxfzo9pGN0qiukwbyPwZouYS8PCTiwnX69zf/UazbRAOD+Qg9HRYRPLNQ+XedXg7qbMKrjvNEJrZld4jZsg8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7122
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_12,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=639 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302210198
X-Proofpoint-GUID: qjhjBaNtrk83A3KH_W_s0dEGIJeTTjYD
X-Proofpoint-ORIG-GUID: qjhjBaNtrk83A3KH_W_s0dEGIJeTTjYD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tomas,

> First patch fixes a KASAN reported problem Second patch fixes other
> possible places in ses_enclosure_data_process where the max_desc_len
> might access memory out of bounds.  3/4 does the same for desc_ptr in
> ses_enclosure_data_process.  The last patch fixes another KASAN report
> in ses_intf_remove.

Thanks for working on this! With your series applied, in combination
with a straggling patch from James, I can finally boot my SAS test setup
without any KASAN warnings.

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
