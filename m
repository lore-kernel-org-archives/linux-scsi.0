Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 139F9C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5356613AF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhDMF2x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 01:28:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37714 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhDMF2w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 01:28:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5Jk3k110359;
        Tue, 13 Apr 2021 05:28:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=LXDIZmEWyNpNfnOj9c9CdGkfuyqzVclVsYt07+l+r70=;
 b=yikGzjdFlHLsbVoZTep7vgr8oF5c+kC+y69hkHTDEcP/s/t82qf3HbH9WcvvTnRnsOgD
 01ZxR3zCUt0jVarc3SbpJjY7HLSINh7O2KIdjr1g2TFLpxJ0QaUOoOZ8Qzqo6nPm8NSC
 ewomtQsdYnw2YnnHSeaTxo6KqjFeTyIOcOkD6tzjh2ubHxTB4G2aIV1noa7FD/9nrNRF
 +wTWrjvERciJcn/PK1I72iLbRrF+qFZD7z/gM+b7r/CZe3JeSb0fQ/TsffD59i8qh0Pt
 VjiwrtUtwv7E+a5tdGqcB8xJuywuOg8UQ2VtRRGOJUA6yNMRrew/nDmKdrL5ZAloOuJB dQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nnds3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:28:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5PcNt077599;
        Tue, 13 Apr 2021 05:28:16 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3020.oracle.com with ESMTP id 37unwybgyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:28:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ErN0lXCFtqq/vVcPDZL4jljbnn2l+rlaE6IUtIoh9O+DcaaXko/uhNdFyljCKzUIxfajUjdN/ycKWqiGnMGZcAztA2klPO9SEOAdfT2aigmN1W2STUhOz7PejPtZqFdkwfgHjb4U7sCgljxceVTMOXwBoCpfzCzmBb5Mhq/ypCgdiT4fF4hX19VnzFTnE1UzrX6ZKjcDnInbhR3bgeaggGcjPKyrHPVWJmFDDZ+BBpExQ93xl6RHeN8lw+xVjvgQFyqnaFE6gCVufCF70EpaX+gm7BqLw2yS8T9zYbt+ZqQQOzUaTHDwG9yNY4eh1sKOKpozz2XzeW+oexCmyeCymQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXDIZmEWyNpNfnOj9c9CdGkfuyqzVclVsYt07+l+r70=;
 b=DjjdfkYE7fncT58SibPDQyE1gwgvjuLpTrSoXTheG4OgSnX2zuxxd4Ch5IuT0rfj58OPbka6HXzUDSJNLNbfeKM/TMHDy42CKosdM/OCrVSG9BOG8UXCO6oX9Esxukc0s/Z6cwf7PRtCInsv5R/gQW3LLfw8WRNbW0qbfrlgcA1dFJgsXXbCCHLvbh+D+khhlSPlGxOmLao8W+pHDzeINy6+n4j7dLDL5dbEgPel86ffDLL79IPphcHeb9MSr01eHZT3AIgDjQqi4cLEnisr9W2IDB9hxqj0NFYINgyQNSDIHQjAVARYABJbfuOQRYuUpvEzzfaDj/4l8fwxqEm8SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXDIZmEWyNpNfnOj9c9CdGkfuyqzVclVsYt07+l+r70=;
 b=KuYugrmvvruKdpIHFwBwK6tSgLAK/DUJ+cjzZzdNZK+eqGlOxIDnoVrXY6aVkUyFuJ7nNfQCAGnuelPjS9ydaAK/jxXh7Y61DFolcXE2QBdBwAVRHnyq32zWFOPwrileaDyjW3GXNeaS+qqB1VHreHK+DGLopKLWi4Nsr0fRwJU=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4534.namprd10.prod.outlook.com (2603:10b6:510:30::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 05:28:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 05:28:13 +0000
To:     Tyrel Datwyler <tyreld@linux.ibm.com>
Cc:     james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvfc: Fix invalid state machine BUG_ON
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zgy269et.fsf@ca-mkp.ca.oracle.com>
References: <20210413001009.902400-1-tyreld@linux.ibm.com>
Date:   Tue, 13 Apr 2021 01:28:11 -0400
In-Reply-To: <20210413001009.902400-1-tyreld@linux.ibm.com> (Tyrel Datwyler's
        message of "Mon, 12 Apr 2021 18:10:09 -0600")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR02CA0050.namprd02.prod.outlook.com
 (2603:10b6:a03:54::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR02CA0050.namprd02.prod.outlook.com (2603:10b6:a03:54::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 05:28:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 336e2af8-6a05-4cf8-c33c-08d8fe3cef22
X-MS-TrafficTypeDiagnostic: PH0PR10MB4534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4534B6EA0754AC6EF311CACE8E4F9@PH0PR10MB4534.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e31oY4v8dq9Qy6N6eZkp6MfvoGyRE3wtV+CZXV2ay0wNvuz6F7TzRp8QqiJEsLfWkBCg5vhzvhi+/E3uemjm1crMMYjqpiJUtPUAohPNGLAp7U3EL1B2/t5d3PfgrzAYTIT6DyMoS46MrtZ2yT+Nt0h4ZcBTLUYecc4Dm350adjzx0/x5jdLk1YIagVCxTms9j1TkYlpatZad63RnjvrYSzkvjmGjRINFgqyvKMx0Jgchv6ZtsuyBWvbcSbG1D3BDIoDIA/Fqb4Fc8bWjouXAvsEZTn0i1ccxzqA9CkaMl802+TPwNZivh9qGAIqpus82u4t8caDoAD6Rp53Z6GYpvkfcDj8CetgxC/5Tbx/wb/zCm/Ek8v3iKz4YRw59ofz2g+noiMdeOD9TGpmEqsmpBGbZOJEtdSh14U775ren2pr1deU5Yx9LV3xjIaCmHSqlkdM/SqbGSmeWqEz0BOuap3ZBjQV6brDJWTBzdpZF/KWHbTW3C1sqM1jy8Hg2u9vs24UkTN/qDa6d92bIJSd0dMKcu/Bl0dPDMzDrsomImORRMKEsksPYXPIkeJK8DMxSp28/HuTZK7Cdc5cJcwu+1tFtaV/eW5MBu/ROmSuaK6W4PsfbL0PyXyWE5sDcylO1vo5kIG+muIhprPyw6qVyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(346002)(366004)(376002)(38100700002)(478600001)(2906002)(66946007)(66476007)(956004)(83380400001)(6916009)(66556008)(8936002)(4326008)(8676002)(7696005)(4744005)(55016002)(26005)(16526019)(186003)(52116002)(316002)(5660300002)(38350700002)(36916002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?p1Y+B/f3MLYFbT7nWVnil5YOMje2QbbTdsyHZbFaoy0wxDxnI6Bdv4PQUbgg?=
 =?us-ascii?Q?//rL/Do9d+cA4FexrXCF4oYY5TGVZOLTy1OHCt74Fh4QfRMNmkpuWiStvbSm?=
 =?us-ascii?Q?I3yuyQlvh6wKRZUCXjklSsZMDW9Ql6rYqc+NcBuAyJF/LxGkNbGT1Yc+/XtB?=
 =?us-ascii?Q?07KCsSdg/hVq843XW75ReimuGwv2AGN04W1x2Prpve0ZGAWpIoz4k9M1u5Xq?=
 =?us-ascii?Q?VvOkOiPyGDYzSFC/LUlEYx6MnrSV+f8Kk7u3/cojvEgaprdtJS6p4bYLiqGa?=
 =?us-ascii?Q?fmCFJeIns+4QimUzNkP5uEy0BM0N/I27UJ76BO3scPRmVljSHqyZ+8n2UG62?=
 =?us-ascii?Q?r573oEsIrpm1dXxLJXdv/bIDaVeOyqJfANoJR8vCY3e/AHHHiYfWHoxul0SE?=
 =?us-ascii?Q?Kqzs6ATgibKCBEDISSWWS6pHvMFpTMmcdNIvGCERx9qfqjB7BxwA3CnnjjKo?=
 =?us-ascii?Q?w/ZkeZS3fGG+KvgBxUv6hcZMSuiClLUmN/X/LD0i2HltN6bYeG69GTifbzt+?=
 =?us-ascii?Q?lvZbTPLnMu8TYekJU2v7s489wzlj4hyHwHuB4M2n3vP6HSLgT28o5F5ef/qP?=
 =?us-ascii?Q?3fuihs+gcnttJK/QBETpuZZXGpo7n08Vdj9JjcrRf2awb3JxET0DlrpDNtbe?=
 =?us-ascii?Q?OCmZLb6I+8LZ716Gt/2EsRK+SyC99+EP9my4mXsd7TCOYAMRrCKqxH0Pwd4Y?=
 =?us-ascii?Q?WJTJOX71xbLqsPAtm4rtiNLhF6Vz3UOZxNkmTWpZJQkm0zX+JilJyhK8jXJ8?=
 =?us-ascii?Q?WP37+YjjBrp4VG8rSnBxDh+kwPCoNXK7Wpi62gLP11e91vReUgvZmlVOsNx9?=
 =?us-ascii?Q?nSKwOw5dJAdy8j4xr8PT5BWeWJd3Si8IMd/g+XJlEDFoRyNMYfg4edmaTF8T?=
 =?us-ascii?Q?GNJvJsdmDn7dvalxVkncK8uwjAlmMo6Cfa3law2rj70tuH5/Z808cWXnfZri?=
 =?us-ascii?Q?ZqriUgtIblpTtOxyi/GC0Xm5LGGTEWXw2EZX3Mu+sALNvsKup8B3nxdlLywo?=
 =?us-ascii?Q?OiWBerJve8YgKhdhpVyixN4/xl12WjURymFbxvgBFqVaaBmz+vSlax8+ouKB?=
 =?us-ascii?Q?gjS7tZbQDfhskkZccbWfsyIdW7Tu3MEAh8wRZz2o44UPlgNRiHcdIL1wrIyE?=
 =?us-ascii?Q?wmhqLIzgq6gaGXa1rVCKH8K2j6w5gAKR9Nb/el4VOfu0ZNgxh6hUBdwUN0rY?=
 =?us-ascii?Q?cobDkCTAqleOkaz5Sgbywxg9n2zNL7QP0eOyBjkxCfz3iGYQtsDyN0cM8+F1?=
 =?us-ascii?Q?W2DCmu9UEu6vaDxQwPfT7gfDdwYzw2Xb9DFGVTX7y4dr1nZ3PNeeNJRJ1C3Q?=
 =?us-ascii?Q?3i7WbVl0uw5VTUguUz5SOt2O?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 336e2af8-6a05-4cf8-c33c-08d8fe3cef22
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 05:28:13.7346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OaXft/+raF062cRS+yP7QmZMV6CdQ+eqBOoi4sPuAgWdJZr5mVg6Nt4POyZsOdHmDi2rNT4SWvqNP0J9Zp4GaBPdEq/gIjZwnqQ+xEiKFQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4534
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130036
X-Proofpoint-ORIG-GUID: scI7d0yktyPKp1opTyTg_sB2CLuK2pwh
X-Proofpoint-GUID: scI7d0yktyPKp1opTyTg_sB2CLuK2pwh
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130035
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tyrel,

> This fixes an issue hitting the BUG_ON in ibmvfc_do_work. When going
> through a host action of IBMVFC_HOST_ACTION_RESET, we change the
> action to IBMVFC_HOST_ACTION_TGT_DEL, then drop the host lock, and
> reset the CRQ, which changes the host state to IBMVFC_NO_CRQ.

[...]

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
