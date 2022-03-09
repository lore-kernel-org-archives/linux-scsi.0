Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AEABC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 03:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbiCID5a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 22:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbiCID53 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 22:57:29 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E857B10C502
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 19:56:30 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228M9E4f010476;
        Wed, 9 Mar 2022 03:56:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=R+tX6kwa6kZ5qV1daebOb6CgByeJ5V2Xfmcrky9nIUs=;
 b=rANJy0EAxQlIdGqZnBxpliJtRaN26Y6AnFsaPbt+EQJlW0Ez4oVRrib3hHwkuVlFIwKI
 pBVh2IqHII/4qS/QxbW6hTGXItQVw5129F4nIe4pvtUSx8ZUcON+zddCh1o+OTqjiMpB
 MtpZidnKNOceny/r2SJUD839m2VrdzwVbCA9gJEuOyaIJHGGUemmYqOjWeHxf336FsLH
 jQiWZBBZvUrw1h/Lkg03F2wYH5xmP9sDl2pRHosLK3rb3nd6y73gsOEw313Y2E76CUdc
 OrM4+qKJbOHQQV4/EhQdiCg9SBn9yPHdS+hGw0Rkr3W2dXUKLvcG6C9fgD8O15WUvG6X 8g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0ru8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 03:56:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2293pNG3031440;
        Wed, 9 Mar 2022 03:56:28 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by userp3020.oracle.com with ESMTP id 3envvm4pch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 03:56:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aj7qSzAUIiiP9eioztd5DyGcOS+LglGkaJ+OcBw0nI7mYhVRXgOxevy6CDG8Es2nDrSeWXi6DyG1+MbvIA6e3ql9AaSafv2Kxaee5gOllizKCLF/c6N4ikY/dg4HueSwVXlj3aqTTzdlDsIDLVoW1LVBVIFJcbtDOf8qnTnak1A95v2jWnTIwGI/M3Fwf7qZykDWnYQwNsJgWNvEw5gNI2O34EORTSfgkPcolWkp6+D/Nd4+DVuBLEaj8JhPYKOpSE7hGhYYrC/X8tzipaqgNRGZiAS84LWr6ncPLyzYzINctP+lNOKCBeK+aznhVOMzgMonzvYex1U3t22K09GQfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R+tX6kwa6kZ5qV1daebOb6CgByeJ5V2Xfmcrky9nIUs=;
 b=PtVCyt0gn6m9d3YusYJqu62OGwyc+vfGpPmM33JbTCTAmutFWhhB1V62AWfsWjzQo1SjotUI0voNSY/xmLG8X2lHnVuIj6UlCV0I4/6hKc0mixdfRb2y7QiDdSq4t20ieCQJw5/axwIRvieBAwQzwsZG8Un+t5GyAY/SHbvcNQsWJgrY2Smb70NI92uWaoAWpEcNcBegpArhKihjLwjkXV19VfZCDB7rSOEDcjA4iDDNYrzyl/3U6gKkqIrDndszi/uvwegp8qyU+MK5mRof2SZQQZH079OlUqTeqLZm1SXGpb2MmaLtRou9iTakcGuVrauRNOJqEU3BjXVEujPAsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R+tX6kwa6kZ5qV1daebOb6CgByeJ5V2Xfmcrky9nIUs=;
 b=K+dnUZJsGmc9cWpHFB4u6Y+PFfA0AAcPeRPcVuHSQduCwPBZ1uNQx7pw7MEJv4SkjCL0SJcKh0r/D4KKaMvyd9PVxXLq9j+Xhd9sef9VvvqfgP+ov9WuzPO2ui9qW2Yv+z5o+8TchjfFeWjrXKMHMz6g1JbAVkTLZvyG2rZ9dHQ=
Received: from SA2PR10MB4763.namprd10.prod.outlook.com (2603:10b6:806:117::19)
 by DM6PR10MB3003.namprd10.prod.outlook.com (2603:10b6:5:6c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 03:56:23 +0000
Received: from SA2PR10MB4763.namprd10.prod.outlook.com
 ([fe80::a045:e293:518:7604]) by SA2PR10MB4763.namprd10.prod.outlook.com
 ([fe80::a045:e293:518:7604%3]) with mapi id 15.20.5038.026; Wed, 9 Mar 2022
 03:56:23 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v3 0/5] Fix mpt3sas driver sparse warnings
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6dzkcgb.fsf@ca-mkp.ca.oracle.com>
References: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
Date:   Tue, 08 Mar 2022 22:56:20 -0500
In-Reply-To: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
        (Damien Le Moal's message of "Tue, 8 Mar 2022 08:48:49 +0900")
Content-Type: text/plain
X-ClientProxiedBy: DM5PR2201CA0004.namprd22.prod.outlook.com
 (2603:10b6:4:14::14) To SA2PR10MB4763.namprd10.prod.outlook.com
 (2603:10b6:806:117::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee5cc82f-9137-4318-3a76-08da0180c72a
X-MS-TrafficTypeDiagnostic: DM6PR10MB3003:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3003B1F9FC96F467172266168E0A9@DM6PR10MB3003.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xStsdFg8n8nn7a3nY494D6EEDUzoEVHHU/Hrrll1X8fA/IZ9EyfVbfb6B+6MFEdhn/GhFSJmsU02t1ZpbZ5UDLwjigFCDUGij1Cio+TfKi6zIVSPBLEYTkUBdgXd9D6aXEvE4szJ74W2Qxyhyz8sQakwghIlnJInDHVRyd1kyTj9wR+GTFUf4POrezEqbpxHrLcdcMwWgr1UpJOrzq4Bt7yXEspiugRN//cMmdKyDJ/cKLxiZ4zO28ss58bdaTJP/3um9vV2eluyE+CFa9XCiaHG1v7P9sw+aJsEStrWCuAS29aKJ9r+Iq0RNJRl436dsTXQ9An4mGRh7W/lE8/ExQtB08DL89CI+MLCnTqXXGmcGS1O7wsY1esbOC16SdTnTDKCWtCkkZpAVM6aewJINWb2+iKN5qAM5I8pQ98DD9Pqgg/B0qyyyc99cBC0+CjEe9lLrgkUkRUaAc+dMCpJ8fWFe0VEznvMBkmOZhFF+fFfeF8hSUq30xkyDIK9zey/ggdR/9U5Q40xxysvuar/zB9MuppfSC3Obei4RWPP4Iw94Ve6ESWR8WGECTz6iLKftN2hxIPqZKN19K66SwNqPGfkLV3sAg5vzVAB9VCD2Z/vO34zkEgJNwLVPEvl4ifavX9cb0hOa7HSGhikMP623JgsVyB9txm1GcHcyY9veICSXDpMM0h1oiIEBhZSbeqU+j8aJHky39ehuiKda+PMqPhG+Srhu+n5eko43yPGU8ZAy7VfRgwxf+OpiIl6GiwRQNJjLlLiMnfXe1KDIckuPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4763.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66556008)(4326008)(86362001)(6486002)(8936002)(5660300002)(66946007)(26005)(186003)(558084003)(8676002)(6506007)(2906002)(83380400001)(6512007)(52116002)(36916002)(38350700002)(38100700002)(54906003)(508600001)(6916009)(316002)(42413004)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6feqlsdL39p4O478yuIPDqG7UO7p5JfUA0sF8KcouAkDpt/IiyxbEZW3ukv6?=
 =?us-ascii?Q?zU2MLALDT8CvWgDI7ktVwvEb1a5Xyx782zi+oqAPzlqYCLjntnKdX89/qptF?=
 =?us-ascii?Q?ksu3f4rH/lZH3nnTq296D04SO1ml5Ip4zTKM9ARXJPHKvujBOTftebFij9is?=
 =?us-ascii?Q?OIEdK+C8y/T+Nlyen2hxoiMPOG7s8YefJSM3PfAJdMuBojyh2ih8eiMCRgup?=
 =?us-ascii?Q?KHEVlFgB0EyPyXxdILQCJ1YnO4ByvkB3gkgV+W4eTSb6LID2eIuiIXGqvagZ?=
 =?us-ascii?Q?ZayEx0C9P+JO7lLeOpZ8fthnVIiVrF4Arncisvr99sctpCbY24gILOXhTEOa?=
 =?us-ascii?Q?VrCouPl0kp9zTAuril4BuEiM7SPgypKOQoDFcf5YpOkOKcnpfIahGWEetk9y?=
 =?us-ascii?Q?udrR3D1rr3f1nxuiiKBPNm1Ja96eW74v83/qCTR9vjjzsGidfqO2QD5ccI3P?=
 =?us-ascii?Q?dVSff5KhsQpEUFrSFnRiHnADFD6SJ7Q21PzguVvOVBTqlwuuYdfQrp6rulqn?=
 =?us-ascii?Q?kvluJnGUahZVELfBMS9LMZCdT3Po7UDje9eIA/OhhCudKlBzP/ow5QvgDSox?=
 =?us-ascii?Q?FnXLizTrFzTN0u19lfIkftFwMBDtizZtLqg5Iy1NF6eRWBHJSCGsfsQHFpqe?=
 =?us-ascii?Q?X68Y5pTS8c6M4AK48//oAofYmToCEpAVhkV45Ag64hcM7dJZCwFPFD6aXE/C?=
 =?us-ascii?Q?Ai4nK6ihYs0XnJkWaSB9dQkU0vpR3Fmz2cYCsEC2R7cHn5mWBioT/idfNbr9?=
 =?us-ascii?Q?bAOaecpc/nrcd5bkEdAJEFs/+6ULPsWJ/Ol+igoIJYjdNv/olTbNy1w+HSzD?=
 =?us-ascii?Q?5AX1HofNLXcZRKbmAyKEc9+Vxbhv6w8JkNxgU+N00qe+K89z9Prry1X8mEYo?=
 =?us-ascii?Q?sAcMb/7/Jvzm9JLWiVXUmpEALDcLWZMEppBvbKyqNFXSQM84UrQw7mQhZ5j4?=
 =?us-ascii?Q?SaPzmGjky/cGKM6gtnC8taG0k3ctUz0xo4FeKXlFd1pu2i3fxr5nSpPGE9Dh?=
 =?us-ascii?Q?bGuMy9B+gRNF95tSywODCuVn8CibvmEBRxgyGOCVNoOmswlVXGXZsMj72OI0?=
 =?us-ascii?Q?vfwuO5ZZPQa9CXGcfmDvJ26xSaYANI56w5XmVZEgkNDy+OeKJ5DrzpQCwSCl?=
 =?us-ascii?Q?gPxff5X0AVZX4bdhhxBteQ6Wm0TMiYCuV0LyWw3vgZKRO1dGBUVNhp6x7j07?=
 =?us-ascii?Q?QWI218xQ4PfjSASuldf3Y7IeCSM9Bm3PI/A/v3tuYl2fdDMF7l03HT3OnDEw?=
 =?us-ascii?Q?6mc6ifXzJGDU+mITz29RUuL+ZFimSzZqxmvB2tyTQUL2FQ+Nzg1r1vkdPwTy?=
 =?us-ascii?Q?V/DG3rL8D1HiUV7dn1Unxasoov20Qt6GB08Z52NF4JfZvOO3qrvOGSdRc3/V?=
 =?us-ascii?Q?eBxkWEC0R4KS1qR6jsWVI8KB7bRTkhJ6v3p+c1QZ74JVjkCuy6Md44zXWt7x?=
 =?us-ascii?Q?3wFBVcVGYwlaKca6pVxw8mifOWMugjVwRUy4JjFrwRVPlkvUIMvATjm56Zd/?=
 =?us-ascii?Q?CPQ5wH18XwqydM6AiudGmo/bMt+Qh17tmEW8R5lFJfgvzKrWFs0QbwYfXgH4?=
 =?us-ascii?Q?0P2VaBrK8FwBAVFQ8hRUyQugI7P0i6ZuhDUvtF9CVTpm8QfW2B8XyZxjV7JV?=
 =?us-ascii?Q?WBmzccWciAhmhtXkmWlXWQlZsZbfW1Vl68VYX6TUQvOyNonBVq4VUXWhfv+t?=
 =?us-ascii?Q?7SB/op/P3w5UgJYWsNehQsJSHh8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee5cc82f-9137-4318-3a76-08da0180c72a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4763.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 03:56:23.6315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xbn3OOgOI5xTi5RNjciru+o+ZVtiVPILGTEdoMY3QT7avrS4VfJQlTrJM2bMVCZPi+mDMuaqFx9HlOqzPFukhUydqfYiy5wayZHguWMTxnk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3003
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10280 signatures=690848
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=758 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203090021
X-Proofpoint-ORIG-GUID: Db3mIMCf4LB3l5yCjoYJwWhk-DZ3Ygls
X-Proofpoint-GUID: Db3mIMCf4LB3l5yCjoYJwWhk-DZ3Ygls
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> This series fix (remove) all sparse warnings generated when compiling
> the mpt3sas driver. All warnings are related to __iomem access and
> endianness.

Please review this series and validate the patch 5 modification.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
