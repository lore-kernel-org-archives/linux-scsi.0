Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2DBC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 01:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiJRBd3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiJRBd2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2022 21:33:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A068AE026
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2022 18:33:27 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29HNYTiv006471;
        Tue, 18 Oct 2022 01:33:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=nLWz7S9UwkJD8seNywMNLYVXY97ApKha8kq50ZATUYU=;
 b=u2AYFiOHmucoLJIHTIiVRUlBRr51iCU39ugkhxaKjEMHteeuomUn1LfPky9nahA54zOd
 rZXUYa+Jd1DLcbpeXRWyzS4pvFowZtol/SFQABPl6dR7c6WB6D58QOWANhwGhjrWbPu+
 zv9yJe6N0InwcO7ptYiSv5BgSmrE1Q/C2WINL1PNJB/65/w8BXi54Ihq2/Ja1miW6Oa9
 qaCA0I8m8+HHur8Zt95Bn4Uk14a46bANnBRmacBN7mG87dkMzrv4FlvwiAHO6MIFqmzP
 JvCbF3lBPrlUKIPixn2RkTp7OLJECOoLejkTJpVsTSMrBaWhIfdF/vJqYmH+IjFGhaoe IA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k9aww11ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Oct 2022 01:33:20 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29I13K5A017267;
        Tue, 18 Oct 2022 01:33:19 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hu6mtq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Oct 2022 01:33:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MCGdUEu753mwrrqTsrg4Vx5ALUKVqM41HhHX2vIsneUbFWJKISNJ3p2/jkC7XHOXSoqepUgyQpRV0PzomJWOd7nFrIq6cZg3tgYZ+Z1DMIZHKk9mMPDPVX8EGiQHHp4NcOW1KjkocKgKO6qesBzKv3rkd/9A1bfFY5oVuAgcgBzQiKsMflamCX8DVAVprUAZJhr0d9QQLoWY4QrVdrlRS46qz7EbpAxbXQAGZ4M46Es76+r76ubwQhcPkH0kWqYBVcPxb+PCsR80Re+Hc9gKtySeRZwOwS1TaHUU3k0rzHrWini4yX+EHFmpYP2rLffIJRFCgF45B0dOv90Zxt968Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nLWz7S9UwkJD8seNywMNLYVXY97ApKha8kq50ZATUYU=;
 b=Q4xiPkJW7LFjdiyXR+3HkTY9jUHUDKTVKhdk4/Zd+E+NJyeH50JsiDaAmerFpkvPc8jDnyzgaIZHRH/fmnZhRXfVPhzJQYDlJ9ZGoUYYp+XFt3FTbYptCwP+pvl0wh/MGIz+8KQdvNp5eO0yer0S+a0iFuGCrz+j5fRrV0ZdBikkS2xPYmzn98KIMD7B9h9oUDTtu+Jm2HzaSqXOFF8arX95Ta3CVX3zL6A2ZO1pLVp4Vy+AwlLX/xXQIsfGinFw77cwH9NTGPZhnfCTAbS7uZs5j2D0QnNdmyVnzT+LdOrPeCvWQzaa+AdjZpB3gEuQt4/5AEbJ2y3JpUtGtzOFKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nLWz7S9UwkJD8seNywMNLYVXY97ApKha8kq50ZATUYU=;
 b=mvGYetlqYmvyDvUz185/91AkwJu3bevaSk9dnY8VA+Q0mKvBzRANenxECZ26vp48lS52Ivq6fQO/cuf9in4iCN3lOHSjzSwnHtZQwK9ZBXrN7mVhsCfNBqV44Ty+SmY+sMU2cBr63qeQeENNYcMozqBdRsk7NGWxD9aPvHK4Cec=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN7PR10MB6500.namprd10.prod.outlook.com (2603:10b6:806:2a7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Tue, 18 Oct
 2022 01:33:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351%6]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 01:33:16 +0000
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     John Garry <john.garry@huawei.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/4] scsi: libsas: make use of ata_port_is_frozen() helper
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ilkh29x8.fsf@ca-mkp.ca.oracle.com>
References: <20221007132342.1590367-1-niklas.cassel@wdc.com>
        <20221007132342.1590367-4-niklas.cassel@wdc.com>
        <cfb9e10a-5d42-4c76-952d-dd1f871dab64@huawei.com>
        <dfe6eea2-ff1d-efd2-7508-cbeb5f7abeb7@opensource.wdc.com>
Date:   Mon, 17 Oct 2022 21:33:14 -0400
In-Reply-To: <dfe6eea2-ff1d-efd2-7508-cbeb5f7abeb7@opensource.wdc.com> (Damien
        Le Moal's message of "Mon, 17 Oct 2022 12:08:50 +0900")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0105.namprd05.prod.outlook.com
 (2603:10b6:8:56::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SN7PR10MB6500:EE_
X-MS-Office365-Filtering-Correlation-Id: 320a78e8-c831-43ca-6466-08dab0a8bb1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TiJ9uhctpMru1Z8q4+lzgR3Orb5jks6uSf/YDVfXewDFPvjx8jVk+TpihEDWaF9yt+OxXreuLYeRdFoJiWDiRD9UN2C8jMTJLJ13RitdGgZJLxvkrVqitIRbHJMbA9K7H58B0HM17PnAHiS0FPGxhEQd+RoLKOfNn+3OJ287JgvXyRWphsdPy3nQlJk6zLs+/hARAg545UUIaPYJOxpzvt3l3gzybTUOnJdvGpGIDAvOKPWgIcRtlZgkm8k22aX5D7QQXDYYx44gb9z0BnJxeV8SXFQyipLcpIMwYhKDhyzChMqDLUgI54AIw7x5zJMzlc6g2/AagzGCsNBmXrenQ/+mcaUZpXSHSTEV2uISGmX6jAJs4v/Wwh7i5nV5bqMr+BGVvQbUAPW7b03CMZcGl5PUPLq0gpOcMqC6NzXvtu0U6rmAHgfRUgWxBSwrbmJUJr0Z5+C1mLCyNx1n1SfDOAQLkkgpZMujioU6aFvwVvh1Vv/PIM7Sabh3a/bsFTa1wXeRIjw/hh83r92Q9LDJB7ovxHSn6ZPYqnThOTULyHCV5AVjj+RUSGgwO3NeduWo5KASdKE0f1B3bJ2kI339IMgNfMavwx9nJvMXtta1CPLbVe5FMHO6clP3qpxUDj/B6/CDPXjR4T/DGGINWktFzTYJdFjOb/XAS3LrG1VByc+DF9U4acY4a3qgmZaoplPA1an/Vh239yILyNN+OqjcFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199015)(54906003)(6916009)(8676002)(66556008)(316002)(478600001)(6512007)(36916002)(4326008)(6506007)(26005)(41300700001)(186003)(2906002)(5660300002)(6486002)(8936002)(66476007)(38100700002)(66946007)(558084003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hV3HOZ4VWl1ZEnxGowMTvsdS9q+Oi/hyKLEPNr+P56L4vSXxxyScvJ8oEfxk?=
 =?us-ascii?Q?XQLqywv+mHU1xYKOJqykQZfwhRkmdQ32Eh2DLSJ5GZiDRPpwnPu3brth7j0y?=
 =?us-ascii?Q?1YYitbpoKLAFVaIOq8Aj5SmvXFid78q8JJNzjZchfbbWV7HSdNuj47wRDvgk?=
 =?us-ascii?Q?F72hnC0PNmzhFm5G1zCQilxl6KbwDeZNvu/ZCzTsxk971UaAV2WmBw3AGULP?=
 =?us-ascii?Q?qktlbXOoDccSccpHDrnGKm+l5lcNHhzzOeSQYo3jCm7C7XMblW3J/sECg9bo?=
 =?us-ascii?Q?GSVn3d/WiOeIrFJknR/3yM2LGcOLxEy6+Ws8Q1g7lBhSQKBJ+635vjejlMct?=
 =?us-ascii?Q?lBqIzDv56O7h3/NqoNPAd1HSGGRB4s7x8ynJLOnFYn2+lWtwY8r58/yVXbp4?=
 =?us-ascii?Q?jKlzy/HJNkYMXdX4Z964rWYxq3RgmtJee4ZDN+eB5uZSLN2eHDlLT37tuaSM?=
 =?us-ascii?Q?g3psipigH1ebEr0oqnBbLr6/9i8uaSJMLfsAcx54cpRYmPZfXrfJktrw8tau?=
 =?us-ascii?Q?ivYNm/ceXbJySeAQQoJ+7zrtzU8daojZsKjjaSlCerjMIgNMn4VfWNEvjY7R?=
 =?us-ascii?Q?sjeLn8QP7Bn1bif1IxoMPb5jLgaF3J4tEOWLAse9lvLHkyTyjRrRZKk8jDWA?=
 =?us-ascii?Q?dcru1g/k6GG3vUk5IH/ChMVkrED9Vybf7hqpOf+D0atx99xYkPo9iS8zrxo8?=
 =?us-ascii?Q?bWGI1v+wayr9OidRxrXbZzYY0kBGWVv8ocoBdsbP1WQf6gu0qqyyC5tVsUDC?=
 =?us-ascii?Q?zQSb2wrUM0EV5iLnOjAM48B0VkVTSkyWVQ61cGMXm6w2MmxOGRi89Irr50Vq?=
 =?us-ascii?Q?cV4I7gDi9JSs1/GcVTrheInCU4736o00/Vp3XBxbX9LKzmfbAP7Vl2ZRDl/y?=
 =?us-ascii?Q?yV5uSJ7b9Q3IqXJ0+HLyy4zenbxz859piBK6KxOeFHi7khuASWfT8S6Wg7sj?=
 =?us-ascii?Q?q7j+dpuVnq5iDd4XNplW/g2nF/wEwsIbF5p/sDDSmG2AJj4Fp7hFU9k5gye7?=
 =?us-ascii?Q?JGbmdW65aw7LAe5ewENX4+kuhyz9cLJsUxyQ5jUAsxXp+US2j1EkdegbNFmm?=
 =?us-ascii?Q?JU7iNii/e5hY0MDm8m0WsniLtui02ZtJIw5aUC+fAkZxaLphee6CHLeUPqPr?=
 =?us-ascii?Q?o0Fd0WFjaL06QhzFqccXg6k68spkYke5X1Sihpi5t6vGMMf3Yyvka6cD9b9s?=
 =?us-ascii?Q?0doY68GTw5/bCu67iENSgk3SaZz4LCuLfESMnLYBSGzA1aaO0lfuA/cWMkSf?=
 =?us-ascii?Q?qpcmeF8nDtLJ9IF9nJKycrNqDQzclNgpqWYYMMu6sPydMxGoafne+ax+MQ7p?=
 =?us-ascii?Q?m7IfWEDuz9I46LH1PVpAjbC2gP279w88884Kl8+XxRbhlf8OkwRyyDTw9a41?=
 =?us-ascii?Q?cFgU83dy7ldOHpdy1K47KdnXuFc106zh0HKQwjmYD5XNcCOTYDe5yIHrKby8?=
 =?us-ascii?Q?2WN1ZUXK8qlwFE7hMbzMfAiAYaQj95H3bXgvQVbTydRJLtRPePCHE5VmGyo7?=
 =?us-ascii?Q?xsJ0SYyVjNpo4u9okJAf74qnF+oD9MHF3oOwECmP29QfdHhxvK23cWBTHH8R?=
 =?us-ascii?Q?NlYIxp9ZjdXoJdRzExZCf9ErkLkKmOskBZB6NZjVmOgfCq3NTkB90swSBXHF?=
 =?us-ascii?Q?Dg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 320a78e8-c831-43ca-6466-08dab0a8bb1b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 01:33:16.8362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tgBSQdHWVrH4ZbwDudZ33xKIa36xj/nOregoBzCVHUJJqGbWBTCs1pvxKg7bC7tY+qTtnwfUUT+I3xDI0tDMsRMcFse3mXJIpj0GKJxzltA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6500
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_13,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210180007
X-Proofpoint-GUID: VsCHIrm_tsixY2_NLy71zhfoVgz5fBOr
X-Proofpoint-ORIG-GUID: VsCHIrm_tsixY2_NLy71zhfoVgz5fBOr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> I can take this one through the libata tree as that would avoid test
> build errors. If you agree, can you send your ack please ?

Yes, that's fine.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
