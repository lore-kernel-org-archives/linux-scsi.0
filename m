Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDFE7EB64D8
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 00:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236982AbjFOAiB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 20:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjFOAh7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 20:37:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D929010A
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 17:37:58 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35EKEbeB011686;
        Thu, 15 Jun 2023 00:37:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=9yafHEf7ssQPLW5akOnmw384ZMam1xnb4aZNQUsSgsY=;
 b=qDlnw4kpRaibOovmxBfnz3b4TQekKpVmU143iNTCUqMLBF504ovPBb+a8GpzRz6bVEpF
 5V6X37Zugj6keA+Yq5MTqC0IrOBrkcqjJfHqmaR1IbjXv309FarsaduPBg7CayFo7yeK
 6BPS9utBjUUgt7zQbbIf1WOvKT2R0CHbNNDZqYfqSKJMnkoJfJo0meB3oS/KCywnoow9
 nrkmOM23PNoprbAaPtnA5jpjRIabOhjAKZEMxYu9GjNaR2K/ykdG9GZtkhYJ+IQx/8b+
 QZBywM5a4uMMgKpi/yU2DE5ZMBS39qLWBG1mYcW5MlqY/4vXNH5/ZnvFDWw/GP/1a+Zj Yg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4gsu0qx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 00:37:56 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35EMo78I017723;
        Thu, 15 Jun 2023 00:37:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm60gsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 00:37:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFFUBYhyhy8p7WqmdjoVqMecfOAViR64EbaFTKt0mAiko6pO3ZLsDiNvpmpjWUsyh6n12BWgKcXe/Gr7aKHKNe7ce+gjJ3qzIGcql3rOFfQeAWrH2Cbc/P1TTuT1phmrfsAtgVHjMVRs6G+yw6Sl73LRhjW+OE0IgWWFk1nk9OHP7z5ZBiBMqcg6gM0Ww6Gk85UZUrLSdyhi9cyhiZ96BbEG1PgRgrOdWgQ88/Ik+rqikz3QyYFHk3WVq9Jja71Dn+n4YdT1pcbbybxygboSDl2GbKoWSuWWSU/RRy+1GpGZ6qxzXnnrn6yXdZ0LyrGhH2WpyPGL3MQS0Z+A16H17Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9yafHEf7ssQPLW5akOnmw384ZMam1xnb4aZNQUsSgsY=;
 b=Pv0Tn3tbPhUGl4uPorRHbTa689BfyYzPhgu2BXJKTndRUdwV9SFCLXcStsUHNOhN3vELYoQLgAujmogJaAGGFArfFpqBPC8Gm1NhvfmGeOkO3s6r+fuYPSmuekgvFKtpYWv30QHvpaEWxxUGDf0nqwN1Ry/MfCZl8Iun+jufFw+y2XgFG+w3sDITn7h8C7GFUyoIuuShvgJ7E4zg95zC4gLhd/btFFpq/3imPmqzYD99ayro5GTR66t1nT8+WgUCTO8gDYVms8XO3uxnOBdckd86sz/dJZ2/XbM628xHKyBzd7WXczPg6xcFC85TCLVOISDY1qKk0gT2A5Nk9AghQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9yafHEf7ssQPLW5akOnmw384ZMam1xnb4aZNQUsSgsY=;
 b=rR4Ov8BgSLRkUAsO5TBzGaYKP663diR8uV66LnQE4iY4hEyzXGpJlHx+E9MJ6eaW5ZxlubIRm2VDgt6cMGW/wqxdv0wyoD+KjbSrG4W88YTNmvhbCOw5BptuiDQ8LqmMl1tmzLMkKfSAmBM8Mx91edjhBMY2y4jFe/cgvoXjVqA=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MN0PR10MB5912.namprd10.prod.outlook.com (2603:10b6:208:3cc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Thu, 15 Jun
 2023 00:37:53 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::d634:f050:9501:46dd]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::d634:f050:9501:46dd%3]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 00:37:53 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH v2 6/8] qla2xxx: klocwork - pointer may be dereferenced
Thread-Topic: [PATCH v2 6/8] qla2xxx: klocwork - pointer may be dereferenced
Thread-Index: AQHZmTSwMIHdfGRwQ0i2WRBhbjMdsK+LEMYA
Date:   Thu, 15 Jun 2023 00:37:53 +0000
Message-ID: <4924B8BE-55A5-439F-AD9C-F0B5709AC829@oracle.com>
References: <20230607113843.37185-1-njavali@marvell.com>
 <20230607113843.37185-7-njavali@marvell.com>
In-Reply-To: <20230607113843.37185-7-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|MN0PR10MB5912:EE_
x-ms-office365-filtering-correlation-id: fde60aa9-2ac5-455d-93a3-08db6d38c14d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7LqbKZ6fw/Nj1yTopictuC1ZkICKx7PFnAkGaMCHHc2j56OkjzojD8evysMQT042csAHAaZz6f9Tm0iDJ2bqpcr6U4rdAF/Ql0B8aOXUV7qT0AX/CQrqCyjLWsuS23N1LrPb0SgG8NeJOG9c1u8AJ0+9SlJlCwcxZ78UIVjigJ/cYmZ3nFPO2ZQ0ETgqfNJJD6Uc6Q+YkDLtQPqhm4x6DMYff3pUSG/wdRguMUbCwheB6IuenF8rFbXGGj1IzAqjY5Jkyxf5goeSDIvrJIsbYUVLCka/6B8+NQImzjcg2Zbi2/j57ODhwIvDRNXBUY29jAYm/oQRRpGXB5lS4NmEcudfKZrQ1Doho0tli/hqOaGD4lUY0dh1gSxjdWs2TkIv7rKOFpcc4Y7VJMTA2GHu2KSbdgERXQnZFUsN6kWs6doTqwbNbsQ24sd9krzRbs4tlGQZD4WzBhfYOMjU/yHQypTf4j77ogMYwO8KKIxeTlRfNnFfo1hqHQ1Wh0Z68HwG9qcdz21YPYNc/lH4IRK7nHu2xREYp22hotkqrh/kOXTnQrVy2LNe+sHYig/Bo8JgDHTGfwGXYnAW6XrvrB+hUV+1gMkMrkc1meOZwPN1LWcD9lgGKd5bl5TVuHKC7YeA8ZQ38u4OddNM/cKYpsWKEw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199021)(54906003)(6916009)(4326008)(66946007)(66446008)(36756003)(66476007)(76116006)(64756008)(66556008)(186003)(478600001)(2616005)(4744005)(2906002)(316002)(8676002)(38070700005)(41300700001)(86362001)(6486002)(6506007)(53546011)(33656002)(44832011)(8936002)(71200400001)(122000001)(5660300002)(26005)(83380400001)(38100700002)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pAIlIyVHVLPaRmrpBPKsiEhfw8ZO0qXEo+kK7gyBUYoIvc2mLYqND/xKiD6j?=
 =?us-ascii?Q?XcLdHABJA1Y8DOfqHrH9WwOvcxD7SC8niPr4dy/56tq/ve6IeukTJ7DDT8os?=
 =?us-ascii?Q?jt0LRfoAc2Mx6VcnxynYHXBOAhuTddJwTYT/LHIG6MQgvD/N+7nV7wAWbZWD?=
 =?us-ascii?Q?keab7pIs79jIfRMXY2RYh0AVXcpCcF8hB1bKhoL5G7jGukMYAFAgCf407skT?=
 =?us-ascii?Q?SHwHdFMgt945kz1DS9htPy2HRMnT+RlQa/ygrcAOBBsljMnHXJ1s0I8Nzyf9?=
 =?us-ascii?Q?oHF+n4G9M2s68Lz9Z9ZbQHR0wBElr00cOiHoXptZgXtPMkeS7ZKky/2w2b9F?=
 =?us-ascii?Q?VhSJEL2TEKVvAXwlHQyN3Ok9y5x7P8TQIjvDjb+M5z95H6BtdSm2b6Jro7+7?=
 =?us-ascii?Q?VxWB7/17HqubtcY/w622NZ+qRrocWXmFaisGR0ELzTlGGfOBJPhI/cF13ALU?=
 =?us-ascii?Q?wYVmSHqANsYNyfFSsd8xE3q0sga6fK6wjP8CHJ5LUQp4SWKgBc/QPRZ5hTOq?=
 =?us-ascii?Q?uTV/qhKWCJCN8r3jdWKz3pMMOaXuzd8EaP6rpGmUvm4ZyZ5si65W6P/AKmVX?=
 =?us-ascii?Q?/+SqLWyihxr15i0TPhx8UHrn2Mh6LqwpO6pxs16J8/FNoGZi9MDOD8lM5mjY?=
 =?us-ascii?Q?mjlB6H4v6/Aag6oYBRG9fBLIcWX2v+uILFR1EJF8/cIY0wV4154bo6vEVpOJ?=
 =?us-ascii?Q?RAygu6AwFGPg3fLeV0bDXfjNIXCsy6UwmHtewHk9M2UeSPDCzlcdKpqetdac?=
 =?us-ascii?Q?eb6Uq8D1+9X7WWXLeypHisTqkRjxCkmzGkrBV+7lyhGKFg9xQemIBl4Sy7Td?=
 =?us-ascii?Q?Erc4QuiSSIaCcvziL0uh5sXP8S3LMAYnzhOiDdmtgf0bETl8P9O2WlISJWg9?=
 =?us-ascii?Q?ZgOmF1a2mXKVkVDEJeuYxcrTxQyBbdob5BwUeTj7tcJNNrmcFcK6CKUo/1PS?=
 =?us-ascii?Q?IxGO4CRUiW8NkmRcsddh4MgNLcHLcG3T7bybZq3/w+bpnF8v0wPi+vBLpqGy?=
 =?us-ascii?Q?wx5wTJpj0/haXsnClBBqu+3X/EJ7vmyYEtKoTM8bIhGpwhWtWZJJpEA8EED6?=
 =?us-ascii?Q?NW2gE77lmw6BkF3b5/BKmKcA6yUWkSch2NeTTzr+hFkp8hkJjDQ/EmrvhLAq?=
 =?us-ascii?Q?76cBxU931lXGtJQg4b8vZLC3MPzn4Ea2UJMfrR+8/oWrsmlZQoGR4q55U2Fz?=
 =?us-ascii?Q?fewK2WDySh8niEh0822s0XSkMw3DsH1ltBTGo12o1kDUOvvTaHdU00L5GG5K?=
 =?us-ascii?Q?tlFKlnkWvGB2lxWBMuSONOKmnAnzQXpU8GfnKoDp65kSKDXG1U/q5iVsLn3g?=
 =?us-ascii?Q?6+/0YrUXM/ucP+sZwB8r4BZyPIh0Kl78Fokcv3URKDU4vPk3hI/xCHwDjPFc?=
 =?us-ascii?Q?68eEDD2PUYkQwNhDNFemAN4pvqZwQvPTiZii3Wk3e0g39HX87XLe73j7YLyl?=
 =?us-ascii?Q?MW77lJKtBNoZm6KrbKSQMJwsOrU0LrqsQPVSUZDIZXcAeP4yXQQrI/9OLgS7?=
 =?us-ascii?Q?b4p1Zp2gR4AqBAf3MghK7HKJlSVbhXUAxjxKWHFc3/zTpQuyhTX72sKfShkI?=
 =?us-ascii?Q?+1xy54j1hGv9jYiNiGgCHdhEcYEyADJxilIba06OmEABK42FlNkOMMlMHgnR?=
 =?us-ascii?Q?+w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <615B6097CAEB4443850EE5A2B45C297F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: JANEdUyiRnIAVpiKtyFytN/UEDGjcFAbDRGpkvDm0t9ckGwBt7lxgNR4esG5+0qxv4wbvFDwvewjzGNwYKvi7nHsl6BsZgMznnFCwsGanl9RBFH0Z7MaBiuwrXnQIQaXm5ArHVspjjq0aF1ZdOjT1MXgccfs6WjS/r1aXoN1NyCMbHD0LRP4Y9Obk8qtEMIg3QY9HPT0LvEdYN3GopiyrxeyVzlCSGnUvocd+iev+dBH+I/ddaDBVE4Ezh+SWdCEY6sndfBl2d20kMOQC/4Izi5SKp3LvDoUIHlDv9LNB37TTOtsv1lPU+kfKGNM1VqQWkMTjP03PiyXgEyK4oAjc5AnGUniivIQXaD+OKqy4ZSL5p+cPJELVbI0qsRxcC9NvZ2z4BvuZF2FaMKmv88RN9BFTPiKR8+mdRifQjTqyEF6nmAScMKTJtvYRhMGHhOMc13HB38+BmZmwix0f1NJbN+hsLyA3phrhUupOeMDvnmosA6XSXGz1qPC7aLsjxRHlqkZ5YmG2Wz3sPc5D7A6QmZlMNrieWbN5fwqtVSzPr5SKcaCO5YByvLYC08GHVg5dD8LuCoWn+hwZM/n+GDUaXAawkza15ArNFW1gnzCzlU56Fc+X7QiIcFOuWymIJKK82HzXTABLs2e3/tSBCi24X30ZAcpnXwWH3J9hdZ85jFU8EC4sHJDC/5nqoB6GTKdb19KypXd92IHQKQpx3E/ywQxK7jjQrmysYVsVgXwVXbTlaW7+enOCKtgGsIEowq9X8YGxTKNlD3GoB76s0duOOHyuFOw+2bYjUo5aHzs2Q0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fde60aa9-2ac5-455d-93a3-08db6d38c14d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 00:37:53.1490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /n+77rKIS6hKALjceobNnJvnfab2xhErsqiIznwtnyIhnWERGug0b3ZDdjYBQ5SWV1RYSat7TW6wu4dTeEGkDsQ6f0cbvNtOvN/Wza8sxQk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_14,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306150002
X-Proofpoint-GUID: 3jqhZ7cagtKGceryU7yEzkmx9a2PVnHb
X-Proofpoint-ORIG-GUID: 3jqhZ7cagtKGceryU7yEzkmx9a2PVnHb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jun 7, 2023, at 4:38 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Shreyas Deodhar <sdeodhar@marvell.com>
>=20
> Klocwork tool reported pointer 'rport' returned
> from call to function 'fc_bsg_to_rport' may be
> NULL and will be dereferenced.
>=20
> Add a fix to validate rport before dereferencing.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_bsg.c | 2 ++
> 1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index c928b27061a9..19bb64bdd88b 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2996,6 +2996,8 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
>=20
> if (bsg_request->msgcode =3D=3D FC_BSG_RPT_ELS) {
> rport =3D fc_bsg_to_rport(bsg_job);
> + if (!rport)
> + return ret;
> host =3D rport_to_shost(rport);
> vha =3D shost_priv(host);
> } else {
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

