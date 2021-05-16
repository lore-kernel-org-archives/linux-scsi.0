Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BDFC433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 16 May 2021 18:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 583BE6117A
	for <linux-scsi@archiver.kernel.org>; Sun, 16 May 2021 18:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhEPSPy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 May 2021 14:15:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36210 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhEPSPv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 May 2021 14:15:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14GIBqVP170160;
        Sun, 16 May 2021 18:14:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ngl6c4mvgZ9Qseof42wPfpr/3pihNE7dQCRI7vkDdo0=;
 b=WWxIG/2VvPzGWpDs4thiLpDV6EZLre2+ZVyOmHWxf6Ib1Dw9HEf8DSkBDo9Dr0ea2sUS
 X2sp9/BjO5m6eFp42eoWmL2SM62DK4DCH5LpJvecDKsVAmqNJml+2JpjqAaSja4MBZ0M
 VnAsZX9Nc115+u26zRMkXoeHBe5eJ4VCsa/U4yuryCulUvq9gdG4SZdOKlUoAG5rLGDs
 CWpeACQ7zqEkz4hlSc+ZyL8/DV3B0iE8TzC6uUL7CT53Q6xmf8caeIO5111TSEo0RucD
 4XZLkohYJQtbpJaGKhiZsg2/lB4TF1KCqh19bwsOV+C4+F8wj/gRtDgnSPvWzuDJR3OJ tQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38j68m9jd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 May 2021 18:14:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14GIAIa7065111;
        Sun, 16 May 2021 18:14:23 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3020.oracle.com with ESMTP id 38jr2qjkr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 May 2021 18:14:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oM+cQZOmP2bHYAEWWeDksOf3EgZpfjQx03lfLg+ZB6++7bF2av+PuMPQX3DCVEIBbDOHu8BJAFYpjKcGMAC5AJSUMDbWblQLOVQSspLaVKoiVusgz73eHO+rwjgJJhXteOzHqJJu3n8pfifECgdiROlzCfhbhFAlXZOEeXctj8YlwQIL46v7pYLs5CjWqb8Zr4FCtwhmWPRgtYpyfS++g0I/6oGx4h7K9+ylBOAuz/rSNvx9yEUN8kwai1jc2mvIJX0wjVFohE4Wp6uhxxmOPIG8nUMPqnjCnjKv7nRm0ymlrgG0OJY0oQAVTPt0APxaSoi2OhWZJdVySeUT20GSsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngl6c4mvgZ9Qseof42wPfpr/3pihNE7dQCRI7vkDdo0=;
 b=iKvH8ox5j70TQOrPcbdjXTJBdvBYLZzgZI89qGVY8VZ6Ql107i9o/5+z6s2RuZnsnetnvUh/KjFo6Xvgp4H3io/3KUXYEgjhbw3j6NCEwYjAjGYifvG8Pc2moUvacOjqRWkkVK0fQpPHBCSlFf0JUh9wjMesfX1iYb2CwYChE98YrLSO6YwFqToD5ibeI3uIGkqudxwWgcbI+ISEzEw46/62fmO6d7zkCI7FcuhHGKZudu2XtSZm+1zMxLu9YqqXVyGuXxHjYg6W9IVfD0fMV2C5xPtPSCS8IKdJY0n5MFnzgH8OObuadQ+bBEN8cDqSRU1rc5ouUGUb8kSoSeWHnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngl6c4mvgZ9Qseof42wPfpr/3pihNE7dQCRI7vkDdo0=;
 b=MR16VUVt0REN9Abvbzb3gYXEAjtSRg9wvLOBAaqHQxnCnkO3irMyQlc8+ydqNGhGniIz4QfjE9uSvfKFi8ASXEPDmRcevM53qDlWxhT8obwLBsBJWTGyCtjQqUA5qs50T/cokjty+cDmEQTX96fmpVuRDCQvYJYhq5rFHw+qsxc=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4711.namprd10.prod.outlook.com (2603:10b6:510:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Sun, 16 May
 2021 18:14:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.031; Sun, 16 May 2021
 18:14:21 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        "'James E . J . Bottomley'" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, 'Christoph Hellwig' <hch@lst.de>,
        'Kiwoong Kim' <kwmad.kim@samsung.com>
Subject: Re: [PATCH] ufs-exynos: Move definitions from .h to .c
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6ou8s2h.fsf@ca-mkp.ca.oracle.com>
References: <CGME20210509213827epcas5p173b48dab49036c8d85eadfc8bda9efd8@epcas5p1.samsung.com>
        <20210509213817.4348-1-bvanassche@acm.org>
        <21f801d749f8$efd9e2b0$cf8da810$@samsung.com>
        <af3e9b57-70b4-9a84-eff7-3a3eda1d50db@acm.org>
Date:   Sun, 16 May 2021 14:14:18 -0400
In-Reply-To: <af3e9b57-70b4-9a84-eff7-3a3eda1d50db@acm.org> (Bart Van Assche's
        message of "Sun, 16 May 2021 11:10:57 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA0PR11CA0068.namprd11.prod.outlook.com
 (2603:10b6:806:d2::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0068.namprd11.prod.outlook.com (2603:10b6:806:d2::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Sun, 16 May 2021 18:14:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8966962-0dbd-4b31-e3c6-08d918966db4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4711C0CD66D640127B6CDB4A8E2E9@PH0PR10MB4711.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: syKqWg76fgB4mZ5jqmR09zbZRr2OHV+eahSBtTdJ1EXdhUCSiag+fF6KmozSZ4GKEJX77AuD7Lzs5xYl1oEEbGU8HkXwJ4XZ6VOreLNLSpyO3Tx7sLVadYdhtjVAa4jTm3f/YZWUZCwfEhkvI+IMeb0kopQG2xnbxHhJvT2DMq9dvq60+3nD7k3jR9PJBq+2YKJGsH7+CMtPhYA49H+1SCiC29YdUta28TXM3YdOnJhW0kFRW+fuJDmWTSIZcXMdPzov8SREf9Xg3bd00w42gxbFoy0qGS2aiVzpPS5ZPzrL4cTK2PULqhv0wYBIAJy2Gw5L6KXYqQI6TIxmVBvoipwvP1/1uTC3opA+mXCZfwWk4hjZbOU02GHZh0NGJntVLiFPqhe2U40lnbEBmRRRbK6uzojwTwxmVkzbKhInAKF8+Qo1/7kISATqbeoa4qUue4Dp4IOC63rXrNWHDBOPgbD6KUa7xFpB5EcY6gFkfAU4z3YTgpw3aV4wXn6hQQlRAAz8911M/hteug53WbcwZBMOnz6x3/gVpZ7FyIGWpRua/hcwjeNUtm2UkfQNyG1WZE+1yVQuRrmuTzmJYN2QTh9ExcdfA99bwU/nAsZhvHZ4/zCWqreZQmHDP9W8rT0IkwYOw/c5ENR2C/jrhNcy3XuJgIIEqU+ZErSSDy9Ap2Z4jPnotQHSel++VHO6sC38
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(136003)(39860400002)(396003)(956004)(8936002)(66556008)(66476007)(8676002)(54906003)(558084003)(66946007)(6916009)(36916002)(316002)(52116002)(26005)(86362001)(55016002)(38350700002)(38100700002)(2906002)(5660300002)(4326008)(186003)(16526019)(7696005)(478600001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TxTbnnkCgWl3shrlacKIQiJDMczFcDSMsSyLRTMuPOJJ38qJ98RPNBdC1v6Q?=
 =?us-ascii?Q?ZUu24aF55nIkh/DT2X0YJm6okUBL81V0kPFo3ZqE6QRpUegg0FRsNMsX/Z7B?=
 =?us-ascii?Q?xE8bZ0ES+e8/PdUBHaweTePEtlhXrR5GUkR4E57Kzf19lynC7ZGBNmc6ACkT?=
 =?us-ascii?Q?wS+MqLM754h6CACwEJBu86DrUawIVET0izBr4MqLHS2n0EHjvx5zweRJys9j?=
 =?us-ascii?Q?OiqwDSn07jWmatQ/TOeHdB+FXDyZxfNI5HpQLJoZf98xquVc2YrtF99etfcj?=
 =?us-ascii?Q?s2j3xY/3k/YYhAxapxDuzOf9XdsC0MmokKGpkv3jBdoqUjVfG9jErrDJzNd4?=
 =?us-ascii?Q?UymbONC2eJqnTQiyqmF+lfQ8uGzqNE2H5i+OPjSZ9JE7g35OcX63DEH8t8C6?=
 =?us-ascii?Q?P0DL7A2Mw8Uuup77d4y4fq0I6/uLAHiyDifKk03NCJhSbGNZD4o01Kq5YU6F?=
 =?us-ascii?Q?riuU2EWfg8COQExwEJ1lntAOiTeDcHcLkDBD1G+8ic9gfMgwkBpa/ERDe5bY?=
 =?us-ascii?Q?85WZ2V7C/ZQLkTgED2YfA39wUXPuItiWgbFYjswfiDqlitN/dm7u6HgVxSMw?=
 =?us-ascii?Q?sES6QLBmIizwPOuJzDKUbtwYlzXUS6+wUDngEe3LMw01peZmcD+VNH2iG2/k?=
 =?us-ascii?Q?ftlmlB0W81iitlNPBlPDiXlPUa4pN3UXe6wndly4sHCp2o7Es1NGrizJhu5T?=
 =?us-ascii?Q?GpHaFsiK7UtHkdhHFKJbKwwsSMumv1Lqg4eb8LtastFZ9yjDX8mtFKSnzZAT?=
 =?us-ascii?Q?t02ivGzDLqZjaHon2Axok11VvggaL3HhHTUj9eAFcNVix2/1MkJOHpOSC9NQ?=
 =?us-ascii?Q?E078ABF778CtZiIvJqG2ZbD9M2B0ULQGU4jbN6elov5enaj+Da7/qx+RS4Cs?=
 =?us-ascii?Q?s/HTJhW492I7y5Xmza92m0cCbEw2wjtJA/CzeRid/dc4djr1M42jeOR/riue?=
 =?us-ascii?Q?YKMfRO0q7m/NsDhl4HPiMLYXmSpDc0M+TYt/4+9I0bX3eEi4hyBBNuXeonXb?=
 =?us-ascii?Q?hCajpt7t5vowztHm4uyfkiTfYP7Qs0TTlJil5okAAVCBm9O+xihnZa1aTNIe?=
 =?us-ascii?Q?soX1k0+pqLzy48yfU9lZahQnNim/IYnM3xsgwhxrLF9MVIoGyw5qofj+aoMj?=
 =?us-ascii?Q?61PP85QqMKALogSrJPyv0avyzvw7tpiZCkUCAXHadPtypgUQaCCQRBWWcYpx?=
 =?us-ascii?Q?579sr5Ah0NPSHmb+HSw/pWS8GRpYcFz/3gmtxsSVvA2CLYBWrWFFaHYNHBHx?=
 =?us-ascii?Q?t/1LQSKTbXVzR2wR0lNgZ3PnSEHhXPDGv19W3XEb3i2C/zOvxsd+FZFIUapP?=
 =?us-ascii?Q?fc/QnZJbVdVfYeNUGTi0dQ6r?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8966962-0dbd-4b31-e3c6-08d918966db4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2021 18:14:21.5722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1qqIMzSSSnJUUUrNwrRpzGQRIcd0tfxx7O04JZQOreui2O9wLG474BoNr4rYKd8yubkI/O5mWrkpsaRHmcrfT8mJYL8AAlpeN8bIy3NpZsQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9986 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=949 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105160143
X-Proofpoint-ORIG-GUID: rWvlR0Sr1TFqw9rhQcXFuzQZuJH_igEA
X-Proofpoint-GUID: rWvlR0Sr1TFqw9rhQcXFuzQZuJH_igEA
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9986 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1011
 adultscore=0 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105160143
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Martin Petersen, the SCSI maintainer will add the "scsi: " prefix to the
> subject before applying this patch. So you want me to change the subject
> prefix from "ufs-exynos: " into "ufs: ufs-exynos: "?

Don't worry about it, I'll fix that up.

-- 
Martin K. Petersen	Oracle Linux Engineering
