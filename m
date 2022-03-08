Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54DA7C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 03:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242524AbiCHDdC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 22:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbiCHDdA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 22:33:00 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492642DA9F;
        Mon,  7 Mar 2022 19:32:05 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2282F17e009301;
        Tue, 8 Mar 2022 03:32:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=97Q1w8aHDmQf4LZDCx5TKjtjuaXzaefTxzCEhdw8gmc=;
 b=s3O8Z4jPvIJgt6xHl0enQ4vhAE3OUHvYFV/isTK0YFrKA9pcArSwGVlQeEHkWvXySk+2
 EFi2LP104GWEXbsQrNTsFQqQqypMnkTKQclxG9zehRileuIhollG9lQX16H81wDxRe3b
 s9YBXOlUkOZ3a/wenxMvbu3k/aqC6CshBUC155olf4O6S3Cen1HL6ZTJoGV1QFgXU9CB
 YByl4vOuXiGI0VDukdp9StA0uW5Fz4lCHstbGDrL29xtdgUGInyHC0qauZTLBSK1pKUe
 M9TstD8pCYN6a/uqDBq7cb2LeSyvmt4hqtYQJFjTwxiGye6rQ6qQNRnrB9rMzk3RJ8Ai 7A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9cdp7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 03:32:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2283VEkO003333;
        Tue, 8 Mar 2022 03:31:59 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by aserp3020.oracle.com with ESMTP id 3ekyp1qm5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 03:31:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SH89I1/pwUTf2KbwcmforGfAPMnFy7AGfZceLJ8l7eFIbkancMWlllYhz45XhbBaI0H+SkvuiHz/GmKoTeHPgfc1I7ciMx8X+CH7xxKTRHGih+kV0PYs50ZVymArWa3HQMheUWtbCOhUlOHWhrpfIW9kKrUdme0ySust+9XlfrpaduMYEFXtpp4sgEmi5XoPT0oBYo0ia/OW5XWMkgfh55dmJv7aJFVKafiS2lnSPLqi4U2pxcJh+0nVVEY/yn2otBDvT8nvI1j9cXR2BFK6wIBJFZbLia37/GOx7RIKVk0jMrOQr6udmR8sUEME+fRXljG2iQaEY4klN89igmkknA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=97Q1w8aHDmQf4LZDCx5TKjtjuaXzaefTxzCEhdw8gmc=;
 b=GEWeVs5Z1Wp+7Ofb2vPL7JVc14jAi9hBZjzDJ/xjoS11WOAP7pH4OPdyJZxDW2IBoBwTKmpYMBrar967Q1Ug0SVOpuk6PvXAGP+vctcjHpUgrBXu/mmtmmzNIWo2syWhcdBOlTwWSgrHOLCTn3xB0x5vY+3f1dVWkueJoBjY2HnA54VUumeNWU4xohQZQ/5k3+QqW65IfH2FfJ3HXNaZne/m8dM2SSlveyo5Ojpqn82xvootjJTu5JiobcwrEjcz60YUrjLTEPX/w7bAfGDTT455gATmfOkSQLf4dmjsTD1Kxem2mvjGDSPQTPNTLvvBycW74qyLiqpujFaCOsMWJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=97Q1w8aHDmQf4LZDCx5TKjtjuaXzaefTxzCEhdw8gmc=;
 b=s9SoBvpBuIEc8Vz20Jr/2zUWxlSdAu1fygHu5KGgvbBJORJxgETuphhkhCu09MwiKYp6gZ2+kpFfjlztS1ona1vPRtGY3xRXpDyGkZwo9bVWAtH5taKTyBupNhc/ntRX4F+dLVJnYydevtducPG+67t92LrQ93gOlUtrLJ44Hyk=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by SA1PR10MB5758.namprd10.prod.outlook.com (2603:10b6:806:23f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Tue, 8 Mar
 2022 03:31:58 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d%3]) with mapi id 15.20.5038.026; Tue, 8 Mar 2022
 03:31:58 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 08/14] sr: implement ->free_disk
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6e1p1b6.fsf@ca-mkp.ca.oracle.com>
References: <20220304160331.399757-1-hch@lst.de>
        <20220304160331.399757-9-hch@lst.de>
Date:   Mon, 07 Mar 2022 22:31:55 -0500
In-Reply-To: <20220304160331.399757-9-hch@lst.de> (Christoph Hellwig's message
        of "Fri, 4 Mar 2022 17:03:25 +0100")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:a03:254::33) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: afff9123-cfe2-4668-33ec-08da00b4333e
X-MS-TrafficTypeDiagnostic: SA1PR10MB5758:EE_
X-Microsoft-Antispam-PRVS: <SA1PR10MB5758930D74D275E84241D4A68E099@SA1PR10MB5758.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d52jLLOkyV1J/wWi83bfUjTlKua19QcUucNRnuKCJl6xiXqGMa08y2nRsIPYoULvgbSEoge7pwybmZxAWRWg6XiebGwRhuGZs+pu00D1IBRjmlN57/Qm/1UjXw3wh5uCSlgJe0p0uvlKgIOQF5i9VfTAyp4LQA4pyNypIdvdKyOcJ6sAYg3vblbqGSOtEtBgYwhLk0eviUQOVkUsXzc0p0FY4+jPK5bD+EzPbjTtr4vHzu+gxsgot9dgcFpvvWq6z58S+76cfxidRERuMQxxwyRO3lQUWmnXWolqzt8JjKLT6zn3lqSbL201PBbf7UcGw48AAYqFX4q17fdICTxomcWnmEkWpW2VvD/nbvx0FMJbfs86pmWT1ug09wwsRR0yetjZB7OdtvJfCkeJDUEWoLkLz3OCKTW5BMJ8iGlNmg8xdIlHLfNhymSCYKXdVanj5icheE3SR+4/6MKU6vCG/wHb6ajoSaB3/bci1KrVgIDhbfBRjwY/4bbdd27BzH9eTaRY41FA1kI8iPNxXfmd+qiiYkW1emF6OgtX4I9CD8b11/NZdpUvIyFTzytdbXD9QCcbh2+eCybzRk//w/grR9ExBba4+p+vGr36DBR29jeAHTvr3Fq7NF5KUUl1eZ24iFLVP0eMvPmagvJPuxo6/fDCXaboKH8W8pms/U+iSs0eanKwJiC6jESSOr7f4dbO2vkXnZXO59h5tVxBrPRpxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(86362001)(54906003)(6666004)(8676002)(6512007)(6486002)(186003)(26005)(508600001)(36916002)(66946007)(2906002)(4326008)(66556008)(558084003)(52116002)(8936002)(38350700002)(38100700002)(5660300002)(316002)(66476007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?duMpSWwtWS3qKZ0/IHENf9fcPLU6oMLB9eTrlPEK2dqcKkG99B6ChSpq/B9D?=
 =?us-ascii?Q?Qzu7YXappblwjLYX1pVXbFEYjpdvJ5cla9NXejNjx5RwbsWnnevggqnZXzen?=
 =?us-ascii?Q?7Wf9QQrhx18GsoOe26v5QoMo4DffWISfN1ZALWXQ8EZkKinzpMTKk3xHfPlQ?=
 =?us-ascii?Q?aPefPfyQByZEJDv7u7TwtszxMF1scNcwP/kqzcIJK8uWOZ7WtmOwUtlirGUx?=
 =?us-ascii?Q?pORCxrR82Vl7PdksH+2cJRmYjcYwgnYUslgsjs3OyUdtCNgvWf6ib90H6nlQ?=
 =?us-ascii?Q?cWDIrtfR5vLhyndF53YJ/4zuRYeJIVaW0SAzItJ2E5G/4vvNjEDJPYv7AdNM?=
 =?us-ascii?Q?GfsemJxDXXzbwGVcUhTpMbWwSmGXwov01ST5m5oNyGSAHsKx6iJW9k19u11I?=
 =?us-ascii?Q?c79eoH2OyzzLxnZMKJBEwECx5faDmE++UIfaJWln8ocXJt26fBwPnplw8ZQq?=
 =?us-ascii?Q?JW2++c8x780qUy4QyCnjF5pYThhvQeae9LkeP9EjJqkMTfz3IB9Q8DNTkL0a?=
 =?us-ascii?Q?z7Vs6Xvge72rvZlaAX7nKR0cl8MWIoXGVHMxEj2CwdRGBQ3JcsebHk/TyPU8?=
 =?us-ascii?Q?BJdXXggXIRhx2yXqknzWq96r6BUIeVNbOb9JbKIx3hkjeRQ7sfj3VkNDu42c?=
 =?us-ascii?Q?EvGHKnC3cxSi8hbbF0/18G+7J4eYZzrjrF1wlck4TvAUJd/sxV9g8ImHYxLj?=
 =?us-ascii?Q?AOMCLfiGu7bdV5ls4gkzr6lzJvgSFR4Uw8466h9l4wVNDmlimjrLENYbwzEa?=
 =?us-ascii?Q?wfY5oKYKLfdaWPZI86Nm9ktv7nh1JwMGNA8PbLu3aMph4AKg1RiFM3ldvd85?=
 =?us-ascii?Q?1xpzHaHlik80JqbAfTI0eePJzd+Bgz2rg++j1z0b0tFE5dozNRzb7B22Z64c?=
 =?us-ascii?Q?ICTac+P8EJJV/rRUWN3W0OzmxrXorJhfrV3ws0Wqn+9EYFp4SO+/BpjvYAL8?=
 =?us-ascii?Q?hVBEjdVHkIcFGnAl7i3IXN5zXZFEQefWjGikM0AqNzZaMjVaneEEhADC0PRJ?=
 =?us-ascii?Q?g3LUKoooXwZ2CE0SVuDIHEhJZ0oiCs/CRwfCvMG6SSVOyH3yOKmx24KLUyBD?=
 =?us-ascii?Q?yLqBFWcLh3rSYNK5GdWGvczBf4a8xy7qigvWGvnJv1eewrRTAzCCG9lBnMlq?=
 =?us-ascii?Q?gsnGhgC0Kstxvp/ceGO1JXg1vxjp/axKoxsrpFGZaQbDxbqgyX6E95mYH4uI?=
 =?us-ascii?Q?CfkqSASIExn1A3qHAEaLClQjBKlQys+9FomlkValUIXOJdGM1dUkPV2YNnqC?=
 =?us-ascii?Q?+f37VHD6fbDz0gFkA6WqZHcm7/yd9Bmp7T6unSeC3oNjuRlE+qkuuoEHFI1l?=
 =?us-ascii?Q?TimxeD1/IJJXFMcj+feZrtdeV4WYnfr/pclRkTeNFekihcP/3npxDPuJsOfH?=
 =?us-ascii?Q?sJvoyLZKSs/0VKE0jPYX2lmlF1SVVRBJKoj9/6LvRr6byyhiR7WhWIc5aUXy?=
 =?us-ascii?Q?JQggVU4Ocv1CaHpA3fGb+reZml8Ywzpsn4OK6aAMxF7NxLeQrXHqMldHjdv8?=
 =?us-ascii?Q?OlPHy8X88pclDPxVZ6uT6f81rwRiPaJJSipG3ty0DkxKtu0ZaYYDjr+Rsf+6?=
 =?us-ascii?Q?fi3XX9JXa9NPJzq57AgUp54uwPRy5NEbl6Vblx4qG+usK2mlCXEe2wPVjA+9?=
 =?us-ascii?Q?OWEPx4O00LVnEj2qSDzj0J53xZp8hLTK04R0ckPzGzYstIsqrbV0XUAgZCX0?=
 =?us-ascii?Q?08vIcvZhIFQMQbhS8EQdQStgT2w=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afff9123-cfe2-4668-33ec-08da00b4333e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 03:31:58.1892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ai4EVe/KhaPs1uctuY/NQIJqW+NnGUUDAwikUvS4hoBBUY4HX1DyXfceSWW2QAcbo/67/KT6EVdTrMW2XPZlq6X7t0tQk0OZ34KE6y2gIQI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5758
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=771 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203080009
X-Proofpoint-ORIG-GUID: RikAaFavxTpdrI8PDoDCbghAyjpvcRGb
X-Proofpoint-GUID: RikAaFavxTpdrI8PDoDCbghAyjpvcRGb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> Simplify the refcounting and remove the need to clear
> disk->private_data by implementing the ->free_disk method.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
