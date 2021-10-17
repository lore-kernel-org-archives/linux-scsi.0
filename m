Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C4DBC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 376CF6101E
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244828AbhJQCac (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Oct 2021 22:30:32 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55092 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231467AbhJQCac (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Oct 2021 22:30:32 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19GNc57f003979;
        Sun, 17 Oct 2021 02:28:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=6x+3GL2j3PXCcTepsLxTH7sPMBF1WbctiG9HCoakZ0Y=;
 b=uCIMlgZ7WdW9RmL/P2wsrY9u7m3NgaaOYDx93yEU7T5/skdLZKn8UJb1oX70JHd4Mexy
 YGWYeS+UmlMkDGaYRqX4vs/AZg+VC8rcUwvedeHBbD57Sf7vYH9F3RHwqX00q9bCecFW
 arBVGdsuay5zn4fGsUzqaegQnUDZqHq6E868dz3SixHVXXAg0/pcxV5hDqI/eV+3kUco
 izmsSF9VKrw466rKZrEBFmSzmK3PcervgdNZhhenv29QTejJw8mv/ZSZSoGW0kAls/QG
 dNMHw8Qi7QIiq+ZCKQvod9uANCWJG63tHBeNc/bMCZLN/eLOc4xS2iJ8j9Q1vazf1kts 7w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bqqj6sqm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:28:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19H2PS0j027699;
        Sun, 17 Oct 2021 02:28:17 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3030.oracle.com with ESMTP id 3bqkutrgee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:28:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5aTCqdv7sH6dGQzg3nW4yefWnbFifUcF4nLBxbTUoT5kyNbzEAfOmTCYf9tx9WtE6p91ZgOUyJGsS0tvtxjyMkDCt43ohHwP049qMjuxeUbtv0zqyDXQEWpUh3cdMXdqbwaSpqKm+Xl4DLugEgOhPRpcuWRxF+CUVqmfH/CLoz3awMmDmyQ8CtsbFdiD0YAGfkg2uJ0Di9A6I1S3n7+uLYW5r68TTwtRPSflwelyzS0qsoTiAHo+57holLyZnQ9+MvdBTIiy2K6CLenKqZdJDgP8Zl1sMcUTulYbGooJhZa3GMIls9R8GsfLGavD4ib/EWA5n9oF30pwxt17o/5/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6x+3GL2j3PXCcTepsLxTH7sPMBF1WbctiG9HCoakZ0Y=;
 b=XGvYuV/zyRIgO22hwo7l3qHeQZU2CVjq0DNov1DpjcqPnpP3jgxiqsHOGb0egPZQka3h+H4H7T0d0gttrTLbw9vguGHICwA5q1y2xi27fwJkDRFfmyMagNX4rPmSXxAsmBnS75uc0acsq2wja5Zv6cCKdMqVmNqFPP2UtEk/kEbWPaVCjFDIg7WOBDQ7n73kg8HTfXOvmGllgwa2lUQ4rW76qcE3b+C8PNOlQSnUqn6q2MczUBYfaX88D1EFfOFLTTdiiEmwcLN45gyswn434nhgqx51HtXObZwEY8VgzXizyi3jvTikZCCgcFtFj8xFaqkkjywujcGFqQX9TLLaGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6x+3GL2j3PXCcTepsLxTH7sPMBF1WbctiG9HCoakZ0Y=;
 b=PnNF8lUdwJtM6Y1JLz/3Xkv8hwNLy50NvuuVA5Y4tFjkFACWjX+/ieol/5I06IBqMRMFRUG3odnuT8SOvj+eDyL0tXfbD5Axst32Tfh5Fy8CIOQxsA324ADkQpbfQMAJQLtl6Z6yUgiteEeMXXSTmAlyauuHPRNF4uKp2lhk4jU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5529.namprd10.prod.outlook.com (2603:10b6:510:106::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Sun, 17 Oct
 2021 02:28:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Sun, 17 Oct 2021
 02:28:14 +0000
To:     MichelleJin <shjy180909@gmail.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com, hare@suse.de,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH net-next] scsi: fcoe: use netif_is_bond_master() instead
 of open code
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bl3ogzbq.fsf@ca-mkp.ca.oracle.com>
References: <20211015142006.540773-1-shjy180909@gmail.com>
Date:   Sat, 16 Oct 2021 22:28:12 -0400
In-Reply-To: <20211015142006.540773-1-shjy180909@gmail.com> (MichelleJin's
        message of "Fri, 15 Oct 2021 14:20:06 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0183.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by SA0PR11CA0183.namprd11.prod.outlook.com (2603:10b6:806:1bc::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Sun, 17 Oct 2021 02:28:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b52c8a2e-d9b1-4f84-2076-08d99115c5bd
X-MS-TrafficTypeDiagnostic: PH0PR10MB5529:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5529AA09409AD83DC44A77A28EBB9@PH0PR10MB5529.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uGXNoJj/EdNw+sPVg0ueD3dURtvb7a44hjDXoXKj1TPnq/R/9XQYiqnrHPFrByWwTJK4oBgD/izk0ktixT2oXIUvlEMxNlZ3C2RXrC+YBf3BxGtVX0GIXaefCyHsXW8WJHhTDvi/A8hcZHx7CmcLCmPmT7KhcK/zgqDihXrXs7K+8D5dfv/igZoS51sLFn3oc8OQZDsbIifkpxHAGBSeKCkc1dU2AVmYNPDrsU2vKwYzUqBFBUzLF9Icr35lcKR2hYQ/xN3oHeD8x7yVdBjN7ksj498ebLNma5ZbUDIjWtmwB4QMcIJkz4zLipP0pLvgUhH5EbaseA2nMKGOI+NLdAWSiJwMBsPhK3HwtZVlRgcPC06t1rmkBfGy4mIOmXXMhrhkI3aFJ8Z85a74Av1EekTj1tHh/E3jX9bYHuBh2+XgiQNaxJmu049RgO7QwFQUYbeWQuZ/8ldtWBDkX/ZzgxaY5QAPCp2d53oK/Z5hpeIFT8RmUaxv8wFcyJy/cQlK6MX/zBKUfojY/P1EfePAm07nGjXqdibFH27ImBnlVwQ/nAl+H9igo+yodq4ukgESr3kxu8sIvjalebqOc8BkWgJ6t0/VM3XXbz2rdcOIvyHt3Bak2fgFxY5Dml+60CCnnIDa7k+X2X79zr1DXA7JpnxsZc4b14aCiHUtFVg7mPMgUuwUhfUk8W/XHvirT8SKbyJcmak3u9EMnLBQtVqlwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(86362001)(55016002)(956004)(5660300002)(8936002)(8676002)(36916002)(316002)(26005)(7696005)(6916009)(38100700002)(38350700002)(508600001)(52116002)(2906002)(558084003)(186003)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ElXhy5jO6TawvyuH1Z0pEkj3GWUNxGCtWmeDewHcgckgE/PElLxvr2vIGv1+?=
 =?us-ascii?Q?b09npy2SKg9FJ+DmuYdA6Y5TAcODlUwZBN/8+IyoDt74KAI1og9nMZ1mlKoz?=
 =?us-ascii?Q?Uyl+LgvTuzbYeP+t2FAQ4T52qz2zso+jG7/OzBGz1vs5Z1hdOJEFsZQQcPLA?=
 =?us-ascii?Q?1Iy3g3vgyhvpBRNqkajg/ZPqFcSd15rb2U3RxmLzBl6IEKbjVPRG8WSnQsW/?=
 =?us-ascii?Q?aik6DDI7rMu0AnaOLZFaWom92AWKYPoIP0V2oCSLNaBFHctFIRuqUHKb89Hm?=
 =?us-ascii?Q?cMnn639Ey/dHtZoO73Y5XW1ZNZuvJSukawyfyLxhXkNMY3d3sn7cajRAiIuW?=
 =?us-ascii?Q?yjzKjycVumhGez45l94qK8qXbqSxfU2kKlKJp0JLsSaEyKgXNMs2FsgIxXCH?=
 =?us-ascii?Q?jRGQh2Onz81pTGwjr1Qv9VCR5mQfDk9jVpHG3vC2W9s0Yi78qow7ydbH5jqd?=
 =?us-ascii?Q?/LZj9kUEASa7yTXxrXV2/FhFAxzJFdtY2Dj7DGRNUHv9PXfagc8bq9p0Ui4u?=
 =?us-ascii?Q?PSCLLb2U3+TAYVrlPNejISag0lcQvJbMi2vC1MwDtmTTtHLB0jQo1BQIVhIr?=
 =?us-ascii?Q?j/SrCCUkRMvKmwOz6+YY4jaHeLP/Gv411YvjEixpR+3TOcIZ2t6hTQypgnPi?=
 =?us-ascii?Q?yq4wgXbQml2w6FKh8gSdv2uT4S225oAfjt0vmqeMcL2fy/TFTz8ndOlHIrID?=
 =?us-ascii?Q?e9o0H2c+xm8+cVn3YQryw3muAiZddrs6U5/wG605NOHj+Bj6WHWV/jxwCMNk?=
 =?us-ascii?Q?VB2TplPvk68jBcsWLWRTQ+jVmhgvSeJnHkjOgJxe+9USbCH+OJrHUxc111Mw?=
 =?us-ascii?Q?vd4vrEnV9pbv+RSa2hTwMmfxYaVrqPPnLPEMxT5Z29u9zvngkkNokZE+PNi+?=
 =?us-ascii?Q?c2jWV0nPqJxWed5+1lPNEeeIYztlJatGz3OPybo4uzO5cEM6T1rb8rp+s6Wl?=
 =?us-ascii?Q?najaTTlUxUgR3aoqD20mbgnOMdf2YupHFAn2qE0Ow3vH0qCT7OTQWIRDZXJU?=
 =?us-ascii?Q?RycWe4AJPYMyMcnJuFNZw4K0NfZwEKefyJFeTytS658rbfHEQAWhdOLdikyl?=
 =?us-ascii?Q?BKdsxpBn+vMW+mamud4SypeoFK/DSA+mizfjVW43whO1Gi8DTLSwScRGhZeX?=
 =?us-ascii?Q?0G3D0zN4MA4IUFnm+Z3X4Xa+nndPb9vUSpWVf52EVWSThRB9iSUC9KsjkoQ/?=
 =?us-ascii?Q?V0XMbmL4sYM5CiyM64J+zoN03bxn03lSOV2r2ln3O6Fa1HFTzaaHeRJq25k5?=
 =?us-ascii?Q?lR9ihyjJa2/4LXI69sslGWHK+mGWOOWh+WW891YhmXnOYf/MS9BkiqKpH+I1?=
 =?us-ascii?Q?wWoHIERdgVOZqZDkg3flJhmw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b52c8a2e-d9b1-4f84-2076-08d99115c5bd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 02:28:14.8448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IBnmaDeM0f7nztyYYD5Cxu8dArAgc/bvByqyGYMGnXm6D7IzKAnRWpG1datQ2JL0/TXLbRrbTYnBs0CLsVlcc4ScSNOM8l8e1WL6/5cv9n8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5529
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10139 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110170015
X-Proofpoint-GUID: OsVpe3sOkfotzgWJze9v1Z3w2M_Ez2pr
X-Proofpoint-ORIG-GUID: OsVpe3sOkfotzgWJze9v1Z3w2M_Ez2pr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> 'netdev->priv_flags & IFF_BONDING && netdev->flags & IFF_MASTER' is
> defined as netif_is_bond_master() in netdevice.h.  So, replace it with
> netif_is_bond_master() for cleaning code.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
