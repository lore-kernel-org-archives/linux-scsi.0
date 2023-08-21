Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01691EE49A6
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 20:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbjHUUsk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbjHUUsj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 16:48:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784D291
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 13:48:38 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37LFxJpZ031476;
        Mon, 21 Aug 2023 20:48:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=dDylHDkyi+AaAOEkTQLL4eigFBqvN4FRzHs7kRRlsYI=;
 b=VoU++6+gzHTcYSi80J0lMYyp0MSHCw5YBtLQX3r801ePviB1hrtuURSyS23OxBGi4GPw
 L1rYi+rHKK9CcU30n8344LpwEyxKgM00RNV5p6whZf74lp+3aRr2w4kq1KD1DB2VotMW
 TTpHIyUew/ZWOh6ONVq7cfg21l2woeF+nf581t673pXI2J/7CutYJpUckqN38u2kI/Dq
 OGQAJVisqnZn5rp+NDIxeAePDrUOSrH3TTeiT8zjiR0Z0bLhZbrc1Q9iEgdT/TY0ntJw
 AIS2WHzRsKEJj8b8Qu0O3czIk0E0iRIGE073P4a9GYt+tgsN1i5pLAtIfjLASopP7NCd Tg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjnscbw0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 20:48:27 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37LK5adG017562;
        Mon, 21 Aug 2023 20:48:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm6af2de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 20:48:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J5KCgnrqVSq+/Df4NY7uAw1EEbHrV5c8IVn9oPhb7JrNbKENRKdguPwSyOQ7BTDeGNY4xG2EhgYSAr3XHIm9+2I1zU36OkPuzVocjpWcBUHd/bjHbBzKAEVxRjmHWnUqUsNouZNG3tiZ3caMJF5HwHFYIHDTLl4nN4HfhzgloXgfYR99LmHcJWcRVIrtYxsqWoWY+MG4Sx9C5jnNjMp1xwFih8m8eUGnzTMm9sROwMT37AKSflbl9NdZrR1MYBo4Wyo0w8O9dZ65k7R85hbgwD37UG8EJtgbc4nwIJvl8ToFXp5fGM+gXOS6bgPpJl21wXK7rO5ojdEc0sKtd8LqEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dDylHDkyi+AaAOEkTQLL4eigFBqvN4FRzHs7kRRlsYI=;
 b=egUoKuoqOnB7FdmvUaiBIaBhI0t6946p9cUQ0AgFoDGoq1ebobA6kqHYn6VK3EL54U2lskI7ga1DQt0fOV/UAKaViF33YFz+7GhUg1DWfsrSiTj5P6ShUBnEKV87xIn1f6C0Jj8/Q3WpLarTHsLmWRBhTNQdWXDbTLPuQDv/Jmj99iyjchKdwKAm8QrDuCnlP1NSdA81v4KKvLX67dxFlS2iu/uv3vuP9Xtmh/S8TywcwxH9lbdChAlMIo4CS3g8qbxVEK5quNDjApDG1xinS66WKe2JTeZt5E4QGfEi0FWETYyhZvULYqGpX2Jqdf22tpveLxD6Ey93vsmBAt+cVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDylHDkyi+AaAOEkTQLL4eigFBqvN4FRzHs7kRRlsYI=;
 b=qqHwZl/llq55VdICSbWc4+e1h/cMPugVYovba0vPpGvjF7OqlebjyUohTMGFUOcbRIx3J20uoz2KmPRzRXmPMCM3vn+bK76cDFpj/N+lRDax4G66hYB+dMzhuFttmyM42dCxW8IkbB0WUMkqEMsH7RZsjEXAgYd0Mdvg9vdpFxg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB5973.namprd10.prod.outlook.com (2603:10b6:8:9f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Mon, 21 Aug
 2023 20:48:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.022; Mon, 21 Aug 2023
 20:48:25 +0000
To:     Jialin Zhang <zhangjialin11@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-scsi@vger.kernel.org>, <megaraidlinux.pdl@broadcom.com>,
        <liwei391@huawei.com>, <wangxiongfeng2@huawei.com>
Subject: Re: [PATCH 0/3] scsi: Use pci_dev_id() to simplify the code
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14jks86mg.fsf@ca-mkp.ca.oracle.com>
References: <20230815025419.3523236-1-zhangjialin11@huawei.com>
Date:   Mon, 21 Aug 2023 16:48:22 -0400
In-Reply-To: <20230815025419.3523236-1-zhangjialin11@huawei.com> (Jialin
        Zhang's message of "Tue, 15 Aug 2023 10:54:16 +0800")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0054.namprd02.prod.outlook.com
 (2603:10b6:a03:54::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB5973:EE_
X-MS-Office365-Filtering-Correlation-Id: 7447dc6b-67cd-4687-8cc0-08dba287f6fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6eeRg9u8Q2uPryCfAyUmTwNUuQ/mgfnsIGgOhfAqCxf8GvcJRA6ZOII+CPLAWm2rAmCvqPRnMxAhW906MYIU7IpMhnwXie6G3HV/6sGQNJX4uU2T6mgykcNL6Aygw2ByGeH+uPsVdCmRmVwSpzcoUEnq1x7LL8XAYv7U1/XxxTNQyGPmXOxTRNFidMm6rf8jqzxhwkfo0YGm/r4eyI9iHkxfWA+jKWjM1svzLP9B7J0E9p94nWmLLw8Sv2TGUYnufbmOASS5KKIMIlFBGn5saWbfxw1qgkZZFuKDNLq+M9FsUK55Ui1mSlwze+jmGvepw8Wlbp+LMSs3xCbN9mcxu2UmPjCfmVAgb55qwDD2EMeHLPlA4dkhZq9LYOw27u/ff6kKGFy7q+GaF5F+DY5Y1/3FlBCItNy27YL497Quob2CRA4SNxD5DS3e2iVtQZOns2vtu9JSlWv90JG2PAG+kD1K+3KbYZZC9ydQFpfjv/nVUyU9Zw1uVG71rPJVzw7yj1SL8U5cE8QsYlvIAQIKiep3aY2qpcbLFvP7e2QFjp0rhl4fp5jUc2+zLoVWx4DI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(346002)(39860400002)(366004)(186009)(1800799009)(451199024)(54906003)(6916009)(66476007)(66556008)(316002)(66946007)(6512007)(8676002)(8936002)(4326008)(41300700001)(478600001)(6666004)(38100700002)(36916002)(6506007)(6486002)(558084003)(2906002)(86362001)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z6IYWxIhl807eXvs0ECbjL9NXt9OZtS2hVYtSXQkUmJowgAKPRHe1Uvf+jun?=
 =?us-ascii?Q?cyUVhG3JkofIALpYeA0Dv9RhfnpXx+aI9YtzbjGE+VUk6ijPGc1e2Ti2Rw94?=
 =?us-ascii?Q?K3atisk1ySbmCdiRIPWd+KmccWCkDdbXAJ948cNz+xF/j6J6UEqewqST2k3r?=
 =?us-ascii?Q?euuoP5owJATyJKa9xC4G+NPc1bz2hsLf0kid/nJbaZzDwo6Hl7IbKc8a+bvw?=
 =?us-ascii?Q?SCoZc9eNcgEeZs73NSGiX4hdngPQ6BBr47MfU0uDvWuNJFXkucGPSMbUwm7q?=
 =?us-ascii?Q?uPwc0n3iYo5QnTzu3WTCFVNxpqy1AAwei4J1Xj8qc8TPchXsy78raQE5o4Co?=
 =?us-ascii?Q?fI4z/7gfpOIAo+YiyciiA+DMVCMERWiNgeYuwLCjKAtLZreA/KjpxOjGmqz4?=
 =?us-ascii?Q?40i5v6B+J8rQNHousCPVlVazEu/7Mice8B26c5S1MWT24TI2A7C2866PPYJw?=
 =?us-ascii?Q?QdURheUkv76HuMrFlKjeLw8W953B0roe+XzEfY6do9AxDYh0GsGfVCoYlVTj?=
 =?us-ascii?Q?QKR7xlIj0SPbgGBftTLm4PXseddYBS/r1idbwmk7BaDPVE+QeH9GNMuEx0bQ?=
 =?us-ascii?Q?+lgOrFdIz6359FHoywpMrgDUyQR5KjtzIX1DYVDUpYVjR5Qtznli3Ozvn1k2?=
 =?us-ascii?Q?r76d/nyBn8Jvyybvxxcd9sQCMdfz60vaqKhqzrMxfu3wEb0fEBxpqDLWbw4Q?=
 =?us-ascii?Q?LpBWLswWsEvonw1kKCL+Zj5RD1nqMPDUmH2K3B0CePIklrmssPPIb1UVknkV?=
 =?us-ascii?Q?07Rtw8mWAleqcqLwwxQR7aw/K5l1zEODsNlCj2OjBk+d/MpvUP4GSrEf+HP8?=
 =?us-ascii?Q?EMSxwrXACohsFvboXSx9zVsXV4G+ZGVk1wdlmYv2yGgYaTokDslZvkMd/gF4?=
 =?us-ascii?Q?JoFqSR3ngnWCQyT7AxHLnsN+HgsZYQxmJ8DfPAH1BvYZ7XGQ3rqyukKHUqLP?=
 =?us-ascii?Q?nTvdIwJXy9nwPxF1CutCf3IJmxUTEl5JTBNIJDQgbqb3V0Jzp9DGwT8ZABRQ?=
 =?us-ascii?Q?xmoHHAZVJfuPFGa3IhYRgFbCNcYCdHAkl8EPrzcsjvcnACEk0wM+wIEvNjKY?=
 =?us-ascii?Q?s3h03hdrBx1U7l2k4biFNU4LW2pyAqkhPRTQEYb7/xw0GX6sC9MuDU/FoT0U?=
 =?us-ascii?Q?tHvca7KY7nGZaHAX2Ojx+n1W/lmTyJktAohogJsjlwdGxdw0GblYm5GF5DW7?=
 =?us-ascii?Q?M3rCguDuPS1KYE/GmYx8YP8bDQeN3VD4N4sbEZMZF58SSg6Go447T9r4u4Pb?=
 =?us-ascii?Q?fwPDMjsLe4M4eaC/6DiiAPsw0uCJ8PgP7IW9veSuC4lI2bUt/Q/Ilv4GmShY?=
 =?us-ascii?Q?MDEe/AHjlxYuzvgFzPHjfPnbF61fmLTqsGbjoE5eg+VckhVyVq9AkXYkdI60?=
 =?us-ascii?Q?4LsaAcdAGxsHwtt/TJ1M4yUDfeRHY6QiVypqTbngbl61XB2+nKEWnZaIVHHY?=
 =?us-ascii?Q?NZM1zgr6sMP3X3jLpkAbxty+YvLfY7TMQ9KCoxmF4KzPUHYl0CW4R2SjldWF?=
 =?us-ascii?Q?bXIObiT4fDsVo0memVm4sOLXRwfLKIkE1J/3UIRB/Vm0ZjEN6xJDbkDqb085?=
 =?us-ascii?Q?jbWc1ASSAr5a4xq8D9x3RkcplplvJ5T0SRkQkca56SIngGGHpuIgQ+/mUU9k?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NmbSPaFmikLaQhussn+3oHSS/sK+iFgwMN9lXhVw9tB/ExBdeBwvKzA/eHOw0u9ESQBnb8XRoicPqi/W0szwWnZENbbGUtY2thQoa+lzwwqSGmCJgTHB3epdywvQDQlbaRBP3YlNia0jfE75Qh/SLfijXmCACnLX8skAwH1WO0/y+EIxsT1cbwwd5qxHPpTK/LmIN1my+L+I1vrxgD+av3cU41IbvubZi3PrmXXpDaCW8a+8/msqXizUCXFUhGwoPE9G/i5ChPbM7w4k6CR6djT+ROJlMWKS2hulGgiONrkdVZ/GaZcWUXDJsx4XqqkVaa535OGWnibMCXSGKbeMJvF5mu06V2MaW/ctfgYxzgv9eQgsvDBLpNs/ynB+anNMT3y3CHN1sGXcaBWDnKTxsnfh1UPGSWpq4vp5F+rJA3dz6+lDHRKKnmuubioPWtoaSxxH4J7rU8Rr0U0Su59V+/7k5mgoRL5ih6aVsehqP3CHOMQhzawsnyUweTw6oXqXh67rt+PgET8cPtFbwSyWyTfbNR73bqOgValnEhDK/YjlPGYdBd4v0Gsjs3D8GEqO0MEW36E31ztDiUoFCLaP8wqu2U3FSi/ybzZHrTVdIONDXAVlt1E+TZ5WFnha5rz/NX4p6LKol/EEjTISgL/rKS/t8znPqipjhN/KSueEA9HSMusCPx91O3TDWSLDZ7Skbe5pJ4l9vtqFYMlGDwC0zNrHzHoArQ0BYuK9dFvbWt/z4lZrn3eIGwAck/IoBJPVKzfeNAsnI+HHXnEQ0c+a4w6Wou9TKDD5iWxll8MRB7sG6PjLVSVESwFaROBgCKvuvBCZswFIr5B0XHoounahO6+LiDBrENUuC8PmkC0ekfc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7447dc6b-67cd-4687-8cc0-08dba287f6fc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 20:48:25.2289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H2VVXJ7Ulmkcl2EVgnjSrqDBbyY8FkiB4AZwxwi99AjLLFDUg6qjmyi0chxTXqkKRPjKK20MUuZrLn9U+4xZ2pSyOsASVsxlcXkaGcRCoE8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5973
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-21_10,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=690 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308210193
X-Proofpoint-GUID: U2rqeOrOavRix-p9IlfGfd5oPMTRQeVF
X-Proofpoint-ORIG-GUID: U2rqeOrOavRix-p9IlfGfd5oPMTRQeVF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jialin,

> PCI core API pci_dev_id() can be used to get the BDF number for a pci
> device. Use the API to simplify the code.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
