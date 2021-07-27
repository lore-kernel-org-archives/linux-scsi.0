Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2062DC4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 03:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E91E36100A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 03:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbhG0CZP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 22:25:15 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24676 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234410AbhG0CZP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jul 2021 22:25:15 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R321BV019988;
        Tue, 27 Jul 2021 03:05:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=PxC9j280BR2KwRur7e6Gi8az/Kq3CbCYcxQMC07Zrbs=;
 b=lUqbNud3J2hevtgHxnbLEjJAL3TiWIjAX1qpT4IV3r5MctN3OKrmEQf7wx9ZF3K6uDvJ
 g7Z38xPYyK0tYsWsQsFPfqFd0Z90Xrt2JD1zCen7wKn+gIAniProGMVB0EXTawwXva5a
 UxE72dphatdwNnLLPUEEdDEQkBgWSuYw2HlN7Y8RjDMmtlN3Eas7+WGZLG+YW5uCNSCB
 c/fo4ndaW1loliIewd80UNsF2DS3E8LtoHcQzQRK5T8QCsZTAVnzOcA5pOVsT6yHaceq
 OMV+mduMW2/cuG+zPkFe5im34XwvAiJaUIojAhrNSs1U4p12tdQU4K188ZaB232fsd4X Pg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=PxC9j280BR2KwRur7e6Gi8az/Kq3CbCYcxQMC07Zrbs=;
 b=hOJH+eLvkv2M6C00eO3lEZJDsR6CWb9sJfUkEWFdTofT3NE8tKBx0Rm32/VSV/iHMTIi
 T9FJhg2ImJe6FAyW+NTZL6B04VHvUAn4AmFCIBOja3asFh4I3kDlqhD4tD8g3Cw/UyOG
 doCz8tZ6lqCeaAcvNqIQgifPcJcquHgR3+o8JmFdIjFZALmq9faIhWVjNp4nK4acRKPn
 rtbIy7GqoapGvwe3ZxtQBF0+QOAr0Zw2UrtWtNFisZVRAnVCao+wrSxdHPPit6Fu8l9U
 /6tY9jUlkHmJCm/77C1Rh7xMIwypFwlxo46QCOcuyPo59d8vZdDnM1DjRSCSFTUbUjuG tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a235drkvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 03:05:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R30hPT110362;
        Tue, 27 Jul 2021 03:05:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3a234um2wy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 03:05:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HM1Rdx5GPM9OaNou84ECRIBMQ7J2v+dADvns6OILI/yQc+6CNkI0SBNHZMgbs/mHzSWrBxGBbkhvCpJhWFgxJ5NV1rKcd3tGzj3uLpFkGtgiIaId2IZOirRycujC21KPE+PA+gWEJnYi56huGtanho7TGLC1+h0YheP5hrDu4iNABSEIofw4KjaHzFAqk2xMY203tORjvAJwEDBnYjjfUz3Vj/V6qaGpvbxJUcxfoOn523lInl4sydG695MG74tqzR6cwKqqH3fpAD/GnC0TVTbumsmKOG7wuGZhsIzbwwSoc0CuI9OxglbrtXSwNCyUTED6313XfgSKjT/hWjQciw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PxC9j280BR2KwRur7e6Gi8az/Kq3CbCYcxQMC07Zrbs=;
 b=gHAEze6RX7i7AxGtinsMFrfuZXX7fV5LJpSqj8u3vSELNHvgcKtxzg/8fKNNOszSRRtGkAMzKck/OaAzu89SlrW3sPlNPezJkdV5+UyXgDDE8bfGR4IG0K9vxQpV3BACma1XOGxBohYtDtF+OiMRctDex7HNjbP6TFKKfPdaC7p57yGWYxC4R6JX+iA4ZQ/j1dwr+cNRL3WryizLjZt3bpyj8hzgEDdxzU1MwMsAYkVAgB2yrhuXwsWI98CggvVTfuS6Vv0Zewsbhxx+xViul73reZoKHfV9M8zx2bi/+0BhuAiqHUauPMUavf5qVM4hnxVGJTQfAqqvdQKIMMA7ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PxC9j280BR2KwRur7e6Gi8az/Kq3CbCYcxQMC07Zrbs=;
 b=GuUDF79oNZ1ukQ+xJSwqBobvsZfZkBqiExwOMBoubO9d3S4UD0xdRm5gBNASM9AqrNydYJsBh34HpP9AHEJ6izqzDK/qEUKkVgjgj0c++VlvDzs0QgbRczXNmm9RluXBzt9EKrvR2FBhxq8J5EK+uUb9sz3uMlS295M4a5oit6w=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4565.namprd10.prod.outlook.com (2603:10b6:510:31::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Tue, 27 Jul
 2021 03:05:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 03:05:35 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: remove redundant assignment to pointer pcmd
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dhcsbgu.fsf@ca-mkp.ca.oracle.com>
References: <20210721095350.41564-1-colin.king@canonical.com>
Date:   Mon, 26 Jul 2021 23:05:31 -0400
In-Reply-To: <20210721095350.41564-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 21 Jul 2021 10:53:50 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0701CA0032.namprd07.prod.outlook.com
 (2603:10b6:803:2d::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0701CA0032.namprd07.prod.outlook.com (2603:10b6:803:2d::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Tue, 27 Jul 2021 03:05:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99a15c42-2d7f-4375-836f-08d950ab6719
X-MS-TrafficTypeDiagnostic: PH0PR10MB4565:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4565CAD23F7DF0C9E7DD5D998EE99@PH0PR10MB4565.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YAJt4joWQHwrvlnadju1laegIHF9zW1e5gUPfVQExEUPHJC3XwBj0TPe0EuE2nFuJEJEWTVgqLUhYkC0SQ8+srj2HGVSQMoEQHacxNuLQM0qZw6POcNxrgInXaE0FjbQZ2ZBysl4gdbJD2LRivRO0cuJZBW1Sw9Nu/IrpRMKKOxkLCGL4dWul9C8ERkZEUbAFnqB+v2TGQLHgj68VHvKcz/gGR48PyF76GwyrMRqQ2oNxmGfd8GPIR6ljR1phZDLk93bkEWG702vtONc958yRrfT/Nb8Ct7wGXUdbY8ytBXyixX4GaIKy3ggJEQ7I4kzdzC6wD08x1OVYQGKb4762Qvaj6PGtfxU4FMLqk/HUhGDBp1LYJ/p6ufywOuD9VrRRhcn3dadquPkrgC5Fly/uZDH5S/HUaKCI2AlFbvPeNhWrn+BvRmUNgDfriFCZHislqUcgQ0HtKuM9kO2fFxRsMnk7e/DjMGA+c8F2Vsysf3+n3kiyJUCQrmD2EHUb8InKOKQmQo7tUbPywiIwh1kXzYMAHQ8KGV16Z5TYkLKd7tcOLAoA25OWQA4+xcwtGLch/tW6qR390hqcAzr74gDrG/wVrOdd5Ers7D0a6KJfG3aphSh3hoeZgSHcJbl0VRIHKflQbxk+h4a0KBi+sdQVY/D2x2t0FAX8mEkHZy8m3NBDMF5KlUrOoBWT9xcyBR8+ACNJ+aY2WYfCWfStZ1fKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(396003)(366004)(136003)(55016002)(66946007)(52116002)(8936002)(7696005)(186003)(478600001)(36916002)(8676002)(2906002)(316002)(26005)(558084003)(86362001)(6666004)(54906003)(6916009)(38100700002)(5660300002)(4326008)(38350700002)(956004)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mbx4ZSBcZimbaFBlvZoAdsbNNDochma7fQQ6DWLgSoADxnYAXWzFHra7dKqJ?=
 =?us-ascii?Q?iN58k5HttAMKZBdQRCv8dHmNZ6OnwPAQu7dUqrGvzHeiLiXyD8qoQJcmCUVE?=
 =?us-ascii?Q?azM1fDeJgotureh1PK8vYo+Na9bsZ/LqXJCNkSrvsI6N7FO8T4vVZ7VPBk8j?=
 =?us-ascii?Q?D2KcN0wpAqS3nx8AKDpSupDiQDDCvKzwFxC+f9mINWpGgaTsOoi99yMBYz0R?=
 =?us-ascii?Q?SYbvyC0geIFLkHSzEQ2JTFYmOlsUAkT5EteMsnSANIeXkE/yC6q9cXV0jOj1?=
 =?us-ascii?Q?/Ydb2zgsnZIhjZ2MEM8lMZzaASoqEYeS3jzxYMzABjj1EN17nL/qUvf8McRK?=
 =?us-ascii?Q?5j3fLkZEdLvZzXrCKtOmZTKkPB7u9BYaS+ZXJVG2nE9O5v/ioQXAurY8daf7?=
 =?us-ascii?Q?nCUg6PHHTK7LhRLQsByDBOJzH1TuTgEUTM3Ft1oAQyqpOP67mDXGJtu1+UcG?=
 =?us-ascii?Q?d0ZMQyBQGBr0Y+FuToDVOmtXKgbuPBKVPJRLebIlvDmTUKtebZLCWWWTVa91?=
 =?us-ascii?Q?I3tZSs9+p4jdBRjO/+kWLTuOA2DyAE1FDvZ4VLWyweMjK0TG/5U6YxWgTpMb?=
 =?us-ascii?Q?4dY+tKeu7D/rMkyzzvF7e/t16syoUwNruaLB3uecfxRH7cBFchVDCitP3E3f?=
 =?us-ascii?Q?ktqGjLHMlU/knI0t14/n6nPABPkcNDHuvsdzMDwlvIe2oWb6g7E9omhIY/6L?=
 =?us-ascii?Q?5p/mmOmbJcY0NIl0popxvXjmUVD203UOmDfKE8Guny4CVJtN2TCA4PeB/xJT?=
 =?us-ascii?Q?1evZ+6+r4C0OnBWPkYHCML0Jr2xlYz4DE4HcHvEzToJ6Ub32qGOMHyAmIzrT?=
 =?us-ascii?Q?HrgABUyJh7tgLx2+Sr+JoJTBDth33ZCoCc807o3HXeBSi/iP2LOdhCiFCmXZ?=
 =?us-ascii?Q?UfR0YUysOoSgY9Yu3sAPFa2TRnGpcMYgpLBoMsZX+o69oiQpn+zfAwEgU6ms?=
 =?us-ascii?Q?BppDt6cs8feilebDX/54PSMBWJE0SnsL9XqIpkdlUCeujxx9b+aL7Pz74/hB?=
 =?us-ascii?Q?X6GrdDQphEm2BUtNzZ0yXR9McTdQcn9E7SfiTOTn1/6y8hrMtMOhiIR/Oa5B?=
 =?us-ascii?Q?cZlae36rGDuribS8nHo4g1leru/z/K+/lM5zYwUDkAk3APeNGJD1Zn764+jy?=
 =?us-ascii?Q?sffL+n5c80hntwVvxL9AMrTcGnfBoSCeLJuw2WZZXesRca4xhDLDpH56QPxC?=
 =?us-ascii?Q?Pt5zPFV5qh7ndI53XVF4sHmjnTbKl2Xe6cb5D2Ao+wI0hPQkZGg67BC74qPL?=
 =?us-ascii?Q?453Ei0aTJIl1cUSeJk8jN3ssEY53Jgcc6VUawZIT/AIYJ1Nt85kJjWArCxip?=
 =?us-ascii?Q?6LFnrzqBsd1PpBITwncv977A?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a15c42-2d7f-4375-836f-08d950ab6719
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 03:05:35.1101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UDVLiZ1vlHS7gMNg7f4WvXsbQoBjphOqiRu9eF9aepbSH2xR1vmgOcw9kPGcczeLqtwvbpbKke7okPw4kJsbZ4o3O0FH5HzZcapeUP7vSqw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4565
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270016
X-Proofpoint-GUID: 3HSL3FOXogspQY0DEg1xX0ghJh3wFf8g
X-Proofpoint-ORIG-GUID: 3HSL3FOXogspQY0DEg1xX0ghJh3wFf8g
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> The pointer pcmd is being initialized with a value that is never read,
> the assignment is redundant and can be removed.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
