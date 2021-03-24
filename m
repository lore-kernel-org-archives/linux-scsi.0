Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D188C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DAEE61A09
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235230AbhCXQWK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 12:22:10 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:54740 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235686AbhCXQWD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 12:22:03 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OGETuW103592;
        Wed, 24 Mar 2021 16:22:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=DNx5hLsV2ZrV6Ak46bUv+DKZP5Or4GSLU5VpAmTbdhg=;
 b=ChBCIM+A+hE6odpXf+YY5n/kOcq8Fk2VBdWp5sovugrSehb8Gz6tn/ysUX1NiwvvmJXo
 q5ZnUlKt+ZkmbikKplqP9iLk84mV8BWsvU1GyMh4bV0kveVJGQr7IuN5MbfjBidtqkcD
 LSSTMqrQ/bNu5eopaJ8CFRP5dbxjRpiEpGEy7G3n4DQHR4BcGcWbphMRoZEbBuohYuo0
 FpClXl/CcGzg9/b+UVoEwv+mDkQUnNb0VXxYXrMYwPulEXaCVO9Mq5okXKCl+B1Us+QI
 ok8dSPB59PvE5hlUWVyNQNBiynltU7EIh7BUDoiTvJykN6yuRSzg3Q0SXxZX6qmFGjfd GQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37d6jbkg47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 16:22:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OGGS2u195525;
        Wed, 24 Mar 2021 16:22:00 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by userp3020.oracle.com with ESMTP id 37dtttgy8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 16:21:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFnj7DxfUZ9kDQO2TqpCzBX2FsMmT9VVmCbnWhfKtAx8/MKzpVn9r2+WRPlHvq4f+XScvNFF16YjEoiuJSytPCDKSliyyIy2Fvo1If4wL2kkAyPPdPu0awbBwPivCAVBDbvkVXEFQn1HZqrJvGUqkdvW75blHM/bQ9izHxfSu6fFG4vOBHcaAb7r2XmJ0bsjIUkLj671LvnDk0oIxygDpRnd/h3rbacml34ZcPZkRVko8PH1dZnlgjp3Nlx6Pm2eroEvuqi7/eX5S7bMJpYngHPx617RozYHh0HEZFHFizXbWzyG5NLKOxp9/PXE0BO1dAKz13QHT/rLuZu8cGMzHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNx5hLsV2ZrV6Ak46bUv+DKZP5Or4GSLU5VpAmTbdhg=;
 b=MyQDH7KAaqBs3wjEETyszZpDFWF4CuaYfYDLjVQSabPxAxkj0W2HXyTu6/z0B24P4pOR2SFXC30e+7yBa15hPB3gy+u57m3pZoCtn+I2sYi9AB92RivOtkESAA1g6isEiElvOjoRc+UMk/ZLyn9i7MeKW6SxKJRTbQEO+3tVZnQX+vSOVFEvxvO8jyDj2gssr0msPtcTNGPpuysZrYXqpuwiry+wajY9TVLHVx+AfIe2j0E5YaVRNVsMQ7YxMcPsZFMv5yQ0jkwy3+0WdLnSOTOeqs7yM2XyS4HGk5AoeU8Td/zFJBi3pNO6MGrr1dyPrANAoquq6YpZyhHvWcO9Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNx5hLsV2ZrV6Ak46bUv+DKZP5Or4GSLU5VpAmTbdhg=;
 b=hUC2RD5KGjNZc89ETJktkiRXE4vpIZmNIA4IgeUIPuyZke4X4dVqWHtPG7Cib/H5TiO6tgiP9YE+eL0OsaGapdrwyz2O9dW1TfxnuaRTNUd67qIAk94ri7OmZts5McpjnoTUJzH4rSeI/UAiCgQafU3jNqiP3NrjINZC/9q6vJA=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2861.namprd10.prod.outlook.com (2603:10b6:805:cc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 16:21:57 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3977.024; Wed, 24 Mar 2021
 16:21:57 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 08/11] qla2xxx: fix crash in PCIe error handling
Thread-Topic: [PATCH 08/11] qla2xxx: fix crash in PCIe error handling
Thread-Index: AQHXH5+sEtnzyAcnzEeWLuFhZqV2hqqTVF+A
Date:   Wed, 24 Mar 2021 16:21:57 +0000
Message-ID: <CAC2960E-D40E-47DE-8423-3E45660F8728@oracle.com>
References: <20210323044257.26664-1-njavali@marvell.com>
 <20210323044257.26664-9-njavali@marvell.com>
In-Reply-To: <20210323044257.26664-9-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [71.42.68.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 716045e8-113a-45f8-b6e2-08d8eee0f229
x-ms-traffictypediagnostic: SN6PR10MB2861:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB286126BB0552B20AEE779043E6639@SN6PR10MB2861.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KLqdMY89MNY6xDaWmHAaxqPLqo/TAVUk+JWkw+caW5ZxNyiR7cWzrrTjIbqn7WxBCS7PGZ5rWOG158XQsJzEaDcO8jxjRbw44fz6+WCQm0iNJ97Rn/oRfC7oqIzMBGQi0f82Jx7RTt9VeewK+jJScIYGjqZsxUBXXaPty0CsiugymibLTj8DwRCkE9onCVjufwjCjeunPJw32ofBLj/72YhrghIZdzfyHP5PZV/XSWNMeJfRjeMGVdsK+jtWUZM2/Je57JQByQ0tOrtT94uotYMXfUCeomHHuUJ7F5fDCL81tPNqQM8iNmh7YCTbvLZqoa3CDuSPRJA9K/VOVSNFFPwf6cXbr5iHhMUPbU65WlXggLO3tSXJdcjcO0Y58LFdpp9lZn22Fup8j0RnYtzLBE9waSmDYOkYZXR1sUWCpXsa2c1BHtJvw30mLVlRa72KGYnzAh6AfEHCyZH49ERZluaRSkw0yy0LHOMLjdDfWyQWYZY8mhmCl3nXTWv3IEvz0nEpOIITct4GJvDL0WFlPNo7eeujBtKzZnuERRMYSX2SMcIKBaPlL/KB6agnJOOmGIHVRBzt5bmwv/as3JShj2UWZfHy+ujQHz7aMOYjlUIUOdyqipusLrAmtZbCguITnEoD6J4yVsjm9Vi0488bMrbmM9Y/GScJhYtjivPVyq0QnFuKaraYWC2/zA36F9Wz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(39860400002)(366004)(71200400001)(2906002)(2616005)(6512007)(8676002)(38100700001)(30864003)(316002)(36756003)(8936002)(33656002)(478600001)(83380400001)(6916009)(86362001)(4326008)(44832011)(64756008)(66574015)(186003)(54906003)(66556008)(66946007)(66446008)(5660300002)(66476007)(6506007)(26005)(53546011)(76116006)(6486002)(45980500001)(559001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?MTU2oeU9lUh9quc9iCnGElmsm/s4TLXVcMrJkos94PwaKC8ydzKsGDv0ElaO?=
 =?us-ascii?Q?rAKh12bQvPfF5QeVfMJBm/iA1YO7ryP54D12gysuB3LMWhvPqIuC16QB2OBW?=
 =?us-ascii?Q?KCDEaCp7p3sNDiTc0gK8riz/0jHU/OZ4p+nP6aidFPTXwqjRT6XRdPtc/zSG?=
 =?us-ascii?Q?PeGCUn4CQALvnkMky1bG2qsfp7aGyY/ke7X1CDLH6sOacC6FyT8VizBjBjtB?=
 =?us-ascii?Q?Dv1DuII6ckNSAc3LLmOy1XO/HQ+VbkitViCu1D+DixkuFk+QMD1wUHdbC7kM?=
 =?us-ascii?Q?oomc42NZ9A1A6wUg79PV/IzHDh76eQddJFgWlBfmNI7NX3vPTkszUBguy7Zn?=
 =?us-ascii?Q?HnTQuZ3CCTS2LR5tnute7b88cuo/I3+5ZXGMbGMx6VY5oPQWCdCCMQWOSBLB?=
 =?us-ascii?Q?pqnkSmTLaQrBoYwurph3N0q3ulKyM3qHOHoDNN6br1nKBw8aXsfl/CYbe7GY?=
 =?us-ascii?Q?usB1FHYkMO4bVi8YDdBM6v82FB9V8yfyVsrLKA05sOqVPZB54Pa9z52pKyI0?=
 =?us-ascii?Q?g48Lyyi6vOr+c4GqmZ15k0uGJA956ZGnxig6cEzEpl6rStUpvETHN5bUICq1?=
 =?us-ascii?Q?+yKE+nHT7DVCQQ1y/NCtulCfb5VTHE6x1vBDs1HQAe6KX45eV0Qcw1H8RJ0f?=
 =?us-ascii?Q?k1+tBLfkuscNYxIfTw6bMcoFY4Sx1jYaKIsdZuKd06o0LnuUIDEgh25Vt+Wr?=
 =?us-ascii?Q?GrMsjuVCOSE078ImcRsuX24P+VTUdN53jYbECqq6DVujRy2GcCAxpVsQSUG6?=
 =?us-ascii?Q?n1SPUHnoLl4JGfTSSZDUjr7Nsl4X3aw2CHoaqKbJuKn1NOMmEcrbw1xMXoe+?=
 =?us-ascii?Q?0n8qicRAYHPNkyDE9XRqgBpOQJZK3Wlgjp8I+/x5w6DUSTt1i50z8okM/xHt?=
 =?us-ascii?Q?GuD6LBPSeCXhkkyLeAgNCNBkEi/maXF2j4da7abfSFZIIVOIqECgHjsjLzTX?=
 =?us-ascii?Q?ZW7LbB48O4uqmlta0YLVElLllZB4r5NieaOPkjftUIhJ8nMjGJxSXIqJ2Pyv?=
 =?us-ascii?Q?VpCwpmkfZhodxlBIPRELNr2T4faPVLmgzNyqgHZ2tI8OYPCef3GxgYMLguDj?=
 =?us-ascii?Q?XNrvX2GMF8LmXsLE35k1F9zfZrYQVZPJqHXiuwG1iQPlRurvoElqeHu2raOZ?=
 =?us-ascii?Q?9uQ8cFtpFsMYvE2v9LJuqQm/CiRjKHYwy+7RVLjC5LrfQII0XXVGAfVPXdt1?=
 =?us-ascii?Q?+vhwegtqzWqjy8UzKLjuaZnktb4O/569w6ArzkRmIEfe/2E/YHuy8/UYQhPZ?=
 =?us-ascii?Q?GmldyFgkqzl8xVEHFLXdAGCm5AhQ2EnUDNxoJvI2LHRIpI/sELYM8ZS1K6pT?=
 =?us-ascii?Q?UMIEgkJ/4VQOXsVszEDupusr?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <97E79CC8FE3CBD4AB8D36782FAD511C5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 716045e8-113a-45f8-b6e2-08d8eee0f229
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 16:21:57.4461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PscD8845mePq2qKSMdvsHj9B5wP11XpYO5Yqj8vSvDhVzCvhiUNSvNbsPBNo+yAQgCJtkcz7Mi13ahPDz8QCWWBnKOAbcASC0i0ASiAAhSk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2861
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240118
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103240118
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 22, 2021, at 11:42 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: qla2x00_abort_isp+0x21/0x6b0 [qla2xxx] PGD 0 P4D 0
> Oops: 0000 [#1] SMP PTI
> CPU: 0 PID: 1715 Comm: kworker/0:2
> Tainted: GOE 4.12.14-122.37-default #1 SLE12-SP5
> Hardware name: HPE Superdome Flex/Superdome Flex, BIOS
> Bundle:3.30.100 SFW:IP147.007.004.017.000.2009211957 09/21/2020
> Workqueue: events aer_recover_work_func
> task: ffff9e399c14ca80 task.stack: ffffc1c58e4ac000
> RIP: 0010:qla2x00_abort_isp+0x21/0x6b0 [qla2xxx]
> RSP: 0018:ffffc1c58e4afd50 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffff9e419cdef480 RCX: 0000000000000000
> RDX: ffff9e399c14ca80 RSI: 0000000000000246 RDI: ffff9e419bbc27b8
> RBP: ffff9e419bbc27b8 R08: 0000000000000004 R09: 00000000a0440000
> R10: 0000000000000000 R11: ffff9e399416d1a0 R12: ffff9e419cdef000
> R13: ffff9e3a7cfae800 R14: ffff9e3a7cfae800 R15: 00000000000000c0
> FS:  0000000000000000(0000) GS:ffff9e39a0000000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 00000006cd00a005 CR4: 00000000007606f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  qla2xxx_pci_slot_reset+0x141/0x160 [qla2xxx]
>  report_slot_reset+0x41/0x80
>  ? merge_result.part.4+0x30/0x30
>  pci_walk_bus+0x70/0x90
>  pcie_do_recovery+0x1db/0x2e0
>  aer_recover_work_func+0xc2/0xf0
>  process_one_work+0x14c/0x390
>=20
> Disable board_disable logic where driver resources are freed
> while OS is in the process of recovering the adapter.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_dbg.c    |  32 ++++++
> drivers/scsi/qla2xxx/qla_def.h    |  11 ++
> drivers/scsi/qla2xxx/qla_gbl.h    |   3 +
> drivers/scsi/qla2xxx/qla_init.c   |  40 ++++---
> drivers/scsi/qla2xxx/qla_inline.h |  29 +++++
> drivers/scsi/qla2xxx/qla_iocb.c   |  60 +++++++++--
> drivers/scsi/qla2xxx/qla_isr.c    |   9 +-
> drivers/scsi/qla2xxx/qla_mbx.c    |   3 +-
> drivers/scsi/qla2xxx/qla_nvme.c   |  10 +-
> drivers/scsi/qla2xxx/qla_os.c     | 171 ++++++++++++++++++------------
> 10 files changed, 264 insertions(+), 104 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_db=
g.c
> index 144a893e7335..059f6f9b8698 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -113,8 +113,18 @@ qla27xx_dump_mpi_ram(struct qla_hw_data *ha, uint32_=
t addr, uint32_t *ram,
> 	uint32_t stat;
> 	ulong i, j, timer =3D 6000000;
> 	int rval =3D QLA_FUNCTION_FAILED;
> +	scsi_qla_host_t *vha =3D pci_get_drvdata(ha->pdev);
>=20
> 	clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
> +
> +	stat =3D rd_reg_dword(&reg->host_status);
> +	if (stat =3D=3D 0xffffffff) {
> +		ql_log(ql_log_info, vha, 0x8041,
> +		       "dump mpi ram detect PCI disconnect, exiting.\n");
> +		qla_schedule_eeh_work(vha);
> +		return rval;
> +	}
> +

I see this block is repeated multiple times in code. Why not make a little =
helper to reduce code duplication.=20

> 	for (i =3D 0; i < ram_dwords; i +=3D dwords, addr +=3D dwords) {
> 		if (i + dwords > ram_dwords)
> 			dwords =3D ram_dwords - i;
> @@ -139,6 +149,13 @@ qla27xx_dump_mpi_ram(struct qla_hw_data *ha, uint32_=
t addr, uint32_t *ram,
> 			udelay(5);
>=20
> 			stat =3D rd_reg_dword(&reg->host_status);
> +			if (stat =3D=3D 0xffffffff) {
> +				ql_log(ql_log_info, vha, 0x8041,
> +				       "dump mpi ram detect PCI disconnect, exiting.\n");
> +				qla_schedule_eeh_work(vha);
> +				return rval;
> +			}
> +
> 			/* Check for pending interrupts. */
> 			if (!(stat & HSRX_RISC_INT))
> 				continue;
> @@ -192,9 +209,18 @@ qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t ad=
dr, __be32 *ram,
> 	uint32_t dwords =3D qla2x00_gid_list_size(ha) / 4;
> 	uint32_t stat;
> 	ulong i, j, timer =3D 6000000;
> +	scsi_qla_host_t *vha =3D pci_get_drvdata(ha->pdev);
>=20
> 	clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
>=20
> +	stat =3D rd_reg_dword(&reg->host_status);
> +	if (stat =3D=3D 0xffffffff) {
> +		ql_log(ql_log_info, vha, 0x8041,
> +		       "dump ram detect PCI disconnect, exiting.\n");
> +		qla_schedule_eeh_work(vha);
> +		return rval;
> +	}
> +
> 	for (i =3D 0; i < ram_dwords; i +=3D dwords, addr +=3D dwords) {
> 		if (i + dwords > ram_dwords)
> 			dwords =3D ram_dwords - i;
> @@ -217,6 +243,12 @@ qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t ad=
dr, __be32 *ram,
> 		while (timer--) {
> 			udelay(5);
> 			stat =3D rd_reg_dword(&reg->host_status);
> +			if (stat =3D=3D 0xffffffff) {
> +				ql_log(ql_log_info, vha, 0x8041,
> +				       "dump ram detect PCI disconnect, exiting.\n");
> +				qla_schedule_eeh_work(vha);
> +				return rval;
> +			}
>=20
> 			/* Check for pending interrupts. */
> 			if (!(stat & HSRX_RISC_INT))
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 3d09f31895e7..b6b4d4a5b2e8 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -396,6 +396,7 @@ typedef union {
> 	} b;
> } port_id_t;
> #define INVALID_PORT_ID	0xFFFFFF
> +#define ISP_REG16_DISCONNECT 0xFFFF
>=20
> static inline le_id_t be_id_to_le(be_id_t id)
> {
> @@ -3857,6 +3858,13 @@ struct qla_hw_data_stat {
> 	u32 num_mpi_reset;
> };
>=20
> +/* refer to pcie_do_recovery reference */
> +typedef enum {
> +	QLA_PCI_RESUME,
> +	QLA_PCI_ERR_DETECTED,
> +	QLA_PCI_MMIO_ENABLED,
> +	QLA_PCI_SLOT_RESET,
> +} pci_error_state_t;
> /*
>  * Qlogic host adapter specific data structure.
> */
> @@ -3928,6 +3936,7 @@ struct qla_hw_data {
> 		uint32_t	max_req_queue_warned:1;
> 		uint32_t	plogi_template_valid:1;
> 		uint32_t	port_isolated:1;
> +		uint32_t	eeh_work_pending:1;
> 	} flags;
>=20
> 	uint16_t max_exchg;
> @@ -4607,6 +4616,7 @@ struct qla_hw_data {
> #define DEFAULT_ZIO_THRESHOLD 5
>=20
> 	struct qla_hw_data_stat stat;
> +	pci_error_state_t pci_error_state;
> };
>=20
> struct active_regions {
> @@ -4727,6 +4737,7 @@ typedef struct scsi_qla_host {
> #define FX00_CRITEMP_RECOVERY	25
> #define FX00_HOST_INFO_RESEND	26
> #define QPAIR_ONLINE_CHECK_NEEDED	27
> +#define DO_EEH_RECOVERY		28
> #define DETECT_SFP_CHANGE	29
> #define N2N_LOGIN_NEEDED	30
> #define IOCB_WORK_ACTIVE	31
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gb=
l.h
> index 6486f97d649e..fae5cae6f0a8 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -224,6 +224,7 @@ extern int qla2x00_post_uevent_work(struct scsi_qla_h=
ost *, u32);
>=20
> extern int qla2x00_post_uevent_work(struct scsi_qla_host *, u32);
> extern void qla2x00_disable_board_on_pci_error(struct work_struct *);
> +extern void qla_eeh_work(struct work_struct *);
> extern void qla2x00_sp_compl(srb_t *sp, int);
> extern void qla2xxx_qpair_sp_free_dma(srb_t *sp);
> extern void qla2xxx_qpair_sp_compl(srb_t *sp, int);
> @@ -235,6 +236,8 @@ int qla24xx_post_relogin_work(struct scsi_qla_host *v=
ha);
> void qla2x00_wait_for_sess_deletion(scsi_qla_host_t *);
> void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
> 			       struct purex_item *pkt);
> +void qla_pci_set_eeh_busy(struct scsi_qla_host *);
> +void qla_schedule_eeh_work(struct scsi_qla_host *);
>=20
> /*
>  * Global Functions in qla_mid.c source file.
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 19681d3c5b7a..cd051eee8cd1 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -6932,22 +6932,18 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
> 	}
> 	spin_unlock_irqrestore(&ha->vport_slock, flags);
>=20
> -	if (!ha->flags.eeh_busy) {
> -		/* Make sure for ISP 82XX IO DMA is complete */
> -		if (IS_P3P_TYPE(ha)) {
> -			qla82xx_chip_reset_cleanup(vha);
> -			ql_log(ql_log_info, vha, 0x00b4,
> -			    "Done chip reset cleanup.\n");
> -
> -			/* Done waiting for pending commands.
> -			 * Reset the online flag.
> -			 */
> -			vha->flags.online =3D 0;
> -		}
> +	/* Make sure for ISP 82XX IO DMA is complete */
> +	if (IS_P3P_TYPE(ha)) {
> +		qla82xx_chip_reset_cleanup(vha);
> +		ql_log(ql_log_info, vha, 0x00b4,
> +		       "Done chip reset cleanup.\n");
>=20
> -		/* Requeue all commands in outstanding command list. */
> -		qla2x00_abort_all_cmds(vha, DID_RESET << 16);
> +		/* Done waiting for pending commands. Reset online flag */
> +		vha->flags.online =3D 0;
> 	}
> +
> +	/* Requeue all commands in outstanding command list. */
> +	qla2x00_abort_all_cmds(vha, DID_RESET << 16);
> 	/* memory barrier */
> 	wmb();
> }
> @@ -6978,6 +6974,12 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
> 		if (vha->hw->flags.port_isolated)
> 			return status;
>=20
> +		if (qla2x00_isp_reg_stat(ha)) {
> +			ql_log(ql_log_info, vha, 0x803f,
> +			       "PCI/Register disconnect 1, exiting.\n");
> +			return status;
> +		}
> +

I would like to see more meaningful disconnect message. Please elaborate lo=
g message, they are very crucial in debugging.=20

> 		if (test_and_clear_bit(ISP_ABORT_TO_ROM, &vha->dpc_flags)) {
> 			ha->flags.chip_reset_done =3D 1;
> 			vha->flags.online =3D 1;
> @@ -7017,8 +7019,18 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
>=20
> 		ha->isp_ops->get_flash_version(vha, req->ring);
>=20
> +		if (qla2x00_isp_reg_stat(ha)) {
> +			ql_log(ql_log_info, vha, 0x803f,
> +			       "PCI/Register disconnect 2, exiting.\n");
> +			return status;
> +		}

Same comment as earlier log (also use unique message id)

> 		ha->isp_ops->nvram_config(vha);
>=20
> +		if (qla2x00_isp_reg_stat(ha)) {
> +			ql_log(ql_log_info, vha, 0x803f,
> +			       "PCI/Register disconnect 3, exiting.\n");
> +			return status;
> +		}

Same here as previous comment. (Please use unique message id)

> 		if (!qla2x00_restart_isp(vha)) {
> 			clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla=
_inline.h
> index e80e41b6c9e1..12eb74ae1859 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
> @@ -432,3 +432,32 @@ qla_put_iocbs(struct qla_qpair *qp, struct iocb_reso=
urce *iores)
> 	}
> 	iores->res_type =3D RESOURCE_NONE;
> }
> +
> +#define ISP_REG_DISCONNECT 0xffffffffU
> +/***********************************************************************=
***
> + * qla2x00_isp_reg_stat
> + *
> + * Description:
> + *        Read the host status register of ISP before aborting the comma=
nd.
> + *
> + * Input:
> + *       ha =3D pointer to host adapter structure.
> + *
> + *
> + * Returns:
> + *       Either true or false.
> + *
> + * Note: Return true if there is register disconnect.
> + ***********************************************************************=
***/
> +static inline
> +uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
> +{
> +	struct device_reg_24xx __iomem *reg =3D &ha->iobase->isp24;
> +	struct device_reg_82xx __iomem *reg82 =3D &ha->iobase->isp82;
> +
> +	if (IS_P3P_TYPE(ha))
> +		return ((rd_reg_dword(&reg82->host_int)) =3D=3D ISP_REG_DISCONNECT);
> +	else
> +		return ((rd_reg_dword(&reg->host_status)) =3D=3D
> +			ISP_REG_DISCONNECT);
> +}
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index f26a7a14fce9..a86a856215c5 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -1645,8 +1645,14 @@ qla24xx_start_scsi(srb_t *sp)
> 		goto queuing_error;
>=20
> 	if (req->cnt < (req_cnt + 2)) {
> -		cnt =3D IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
> -		    rd_reg_dword_relaxed(req->req_q_out);
> +		if (IS_SHADOW_REG_CAPABLE(ha)) {
> +			cnt =3D *req->out_ptr;
> +		} else {
> +			cnt =3D rd_reg_dword_relaxed(req->req_q_out);
> +			if (qla2x00_check_reg16_for_disconnect(vha, cnt))
> +				goto queuing_error;
> +		}
> +
> 		if (req->ring_index < cnt)
> 			req->cnt =3D cnt - req->ring_index;
> 		else
> @@ -1842,8 +1848,13 @@ qla24xx_dif_start_scsi(srb_t *sp)
> 		goto queuing_error;
>=20
> 	if (req->cnt < (req_cnt + 2)) {
> -		cnt =3D IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
> -		    rd_reg_dword_relaxed(req->req_q_out);
> +		if (IS_SHADOW_REG_CAPABLE(ha)) {
> +			cnt =3D *req->out_ptr;
> +		} else {
> +			cnt =3D rd_reg_dword_relaxed(req->req_q_out);
> +			if (qla2x00_check_reg16_for_disconnect(vha, cnt))
> +				goto queuing_error;
> +		}
> 		if (req->ring_index < cnt)
> 			req->cnt =3D cnt - req->ring_index;
> 		else
> @@ -1922,6 +1933,7 @@ qla24xx_dif_start_scsi(srb_t *sp)
>=20
> 	qla_put_iocbs(sp->qpair, &sp->iores);
> 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
> +
> 	return QLA_FUNCTION_FAILED;
> }
>=20
> @@ -1991,8 +2003,14 @@ qla2xxx_start_scsi_mq(srb_t *sp)
> 		goto queuing_error;
>=20
> 	if (req->cnt < (req_cnt + 2)) {
> -		cnt =3D IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
> -		    rd_reg_dword_relaxed(req->req_q_out);
> +		if (IS_SHADOW_REG_CAPABLE(ha)) {
> +			cnt =3D *req->out_ptr;
> +		} else {
> +			cnt =3D rd_reg_dword_relaxed(req->req_q_out);
> +			if (qla2x00_check_reg16_for_disconnect(vha, cnt))
> +				goto queuing_error;
> +		}
> +
> 		if (req->ring_index < cnt)
> 			req->cnt =3D cnt - req->ring_index;
> 		else
> @@ -2203,8 +2221,14 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
> 		goto queuing_error;
>=20
> 	if (req->cnt < (req_cnt + 2)) {
> -		cnt =3D IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
> -		    rd_reg_dword_relaxed(req->req_q_out);
> +		if (IS_SHADOW_REG_CAPABLE(ha)) {
> +			cnt =3D *req->out_ptr;
> +		} else {
> +			cnt =3D rd_reg_dword_relaxed(req->req_q_out);
> +			if (qla2x00_check_reg16_for_disconnect(vha, cnt))
> +				goto queuing_error;
> +		}
> +
> 		if (req->ring_index < cnt)
> 			req->cnt =3D cnt - req->ring_index;
> 		else
> @@ -2281,6 +2305,7 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
>=20
> 	qla_put_iocbs(sp->qpair, &sp->iores);
> 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
> +
> 	return QLA_FUNCTION_FAILED;
> }
>=20
> @@ -2325,6 +2350,11 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb=
_t *sp)
> 			cnt =3D qla2x00_debounce_register(
> 			    ISP_REQ_Q_OUT(ha, &reg->isp));
>=20
> +		if (!qpair->use_shadow_reg && cnt =3D=3D ISP_REG16_DISCONNECT) {
> +			qla_schedule_eeh_work(vha);
> +			return NULL;
> +		}
> +
> 		if  (req->ring_index < cnt)
> 			req->cnt =3D cnt - req->ring_index;
> 		else
> @@ -3739,6 +3769,9 @@ qla2x00_start_sp(srb_t *sp)
> 	void *pkt;
> 	unsigned long flags;
>=20
> +	if (vha->hw->flags.eeh_busy)
> +		return -EIO;
> +
> 	spin_lock_irqsave(qp->qp_lock_ptr, flags);
> 	pkt =3D __qla2x00_alloc_iocbs(sp->qpair, sp);
> 	if (!pkt) {
> @@ -3956,8 +3989,14 @@ qla2x00_start_bidir(srb_t *sp, struct scsi_qla_hos=
t *vha, uint32_t tot_dsds)
>=20
> 	/* Check for room on request queue. */
> 	if (req->cnt < req_cnt + 2) {
> -		cnt =3D IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
> -		    rd_reg_dword_relaxed(req->req_q_out);
> +		if (IS_SHADOW_REG_CAPABLE(ha)) {
> +			cnt =3D *req->out_ptr;
> +		} else {
> +			cnt =3D rd_reg_dword_relaxed(req->req_q_out);
> +			if (qla2x00_check_reg16_for_disconnect(vha, cnt))
> +				goto queuing_error;
> +		}
> +
> 		if  (req->ring_index < cnt)
> 			req->cnt =3D cnt - req->ring_index;
> 		else
> @@ -3996,5 +4035,6 @@ qla2x00_start_bidir(srb_t *sp, struct scsi_qla_host=
 *vha, uint32_t tot_dsds)
> 	qla2x00_start_iocbs(vha, req);
> queuing_error:
> 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
> +
> 	return rval;
> }
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 5e188375c871..f21007c8ca51 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -270,12 +270,7 @@ qla2x00_check_reg32_for_disconnect(scsi_qla_host_t *=
vha, uint32_t reg)
> 		if (!test_and_set_bit(PFLG_DISCONNECTED, &vha->pci_flags) &&
> 		    !test_bit(PFLG_DRIVER_REMOVING, &vha->pci_flags) &&
> 		    !test_bit(PFLG_DRIVER_PROBING, &vha->pci_flags)) {
> -			/*
> -			 * Schedule this (only once) on the default system
> -			 * workqueue so that all the adapter workqueues and the
> -			 * DPC thread can be shutdown cleanly.
> -			 */
> -			schedule_work(&vha->hw->board_disable);
> +			qla_schedule_eeh_work(vha);
> 		}
> 		return true;
> 	} else
> @@ -1657,8 +1652,6 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rs=
p_que *rsp, uint16_t *mb)
> 	case MBA_TEMPERATURE_ALERT:
> 		ql_dbg(ql_dbg_async, vha, 0x505e,
> 		    "TEMPERATURE ALERT: %04x %04x %04x\n", mb[1], mb[2], mb[3]);
> -		if (mb[1] =3D=3D 0x12)
> -			schedule_work(&ha->board_disable);
> 		break;
>=20
> 	case MBA_TRANS_INSERT:
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 06c99963b2c9..0149f84cdd8e 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -161,7 +161,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd=
_t *mcp)
> 	/* check if ISP abort is active and return cmd with timeout */
> 	if ((test_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags) ||
> 	    test_bit(ISP_ABORT_RETRY, &base_vha->dpc_flags) ||
> -	    test_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags)) &&
> +	    test_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags) ||
> +	    ha->flags.eeh_busy) &&
> 	    !is_rom_cmd(mcp->mb[0])) {
> 		ql_log(ql_log_info, vha, 0x1005,
> 		    "Cmd 0x%x aborted with timeout since ISP Abort is pending\n",
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 0237588f48b0..0cacb667a88b 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -398,8 +398,13 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
> 	}
> 	req_cnt =3D qla24xx_calc_iocbs(vha, tot_dsds);
> 	if (req->cnt < (req_cnt + 2)) {
> -		cnt =3D IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
> -		    rd_reg_dword_relaxed(req->req_q_out);
> +		if (IS_SHADOW_REG_CAPABLE(ha)) {
> +			cnt =3D *req->out_ptr;
> +		} else {
> +			cnt =3D rd_reg_dword_relaxed(req->req_q_out);
> +			if (qla2x00_check_reg16_for_disconnect(vha, cnt))
> +				goto queuing_error;
> +		}
>=20
> 		if (req->ring_index < cnt)
> 			req->cnt =3D cnt - req->ring_index;
> @@ -536,6 +541,7 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
>=20
> queuing_error:
> 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
> +
> 	return rval;
> }
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 6a57399b515f..135cadecdaa4 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -971,6 +971,13 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct=
 scsi_cmnd *cmd,
> 		goto qc24_fail_command;
> 	}
>=20
> +	if (!qpair->online) {
> +		ql_dbg(ql_dbg_io, vha, 0x3077,
> +		       "qpair not online. eeh_busy=3D%d.\n", ha->flags.eeh_busy);
> +		cmd->result =3D DID_NO_CONNECT << 16;
> +		goto qc24_fail_command;
> +	}
> +
> 	if (!fcport || fcport->deleted) {
> 		cmd->result =3D DID_IMM_RETRY << 16;
> 		goto qc24_fail_command;
> @@ -1200,35 +1207,6 @@ qla2x00_wait_for_chip_reset(scsi_qla_host_t *vha)
> 	return return_status;
> }
>=20
> -#define ISP_REG_DISCONNECT 0xffffffffU
> -/***********************************************************************=
***
> -* qla2x00_isp_reg_stat
> -*
> -* Description:
> -*	Read the host status register of ISP before aborting the command.
> -*
> -* Input:
> -*	ha =3D pointer to host adapter structure.
> -*
> -*
> -* Returns:
> -*	Either true or false.
> -*
> -* Note:	Return true if there is register disconnect.
> -************************************************************************=
**/
> -static inline
> -uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
> -{
> -	struct device_reg_24xx __iomem *reg =3D &ha->iobase->isp24;
> -	struct device_reg_82xx __iomem *reg82 =3D &ha->iobase->isp82;
> -
> -	if (IS_P3P_TYPE(ha))
> -		return ((rd_reg_dword(&reg82->host_int)) =3D=3D ISP_REG_DISCONNECT);
> -	else
> -		return ((rd_reg_dword(&reg->host_status)) =3D=3D
> -			ISP_REG_DISCONNECT);
> -}
> -
> /************************************************************************=
**
> * qla2xxx_eh_abort
> *
> @@ -1262,6 +1240,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
> 	if (qla2x00_isp_reg_stat(ha)) {
> 		ql_log(ql_log_info, vha, 0x8042,
> 		    "PCI/Register disconnect, exiting.\n");
> +		qla_pci_set_eeh_busy(vha);
> 		return FAILED;
> 	}
>=20
> @@ -1455,6 +1434,7 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
> 	if (qla2x00_isp_reg_stat(ha)) {
> 		ql_log(ql_log_info, vha, 0x803e,
> 		    "PCI/Register disconnect, exiting.\n");
> +		qla_pci_set_eeh_busy(vha);
> 		return FAILED;
> 	}
>=20
> @@ -1471,6 +1451,7 @@ qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
> 	if (qla2x00_isp_reg_stat(ha)) {
> 		ql_log(ql_log_info, vha, 0x803f,
> 		    "PCI/Register disconnect, exiting.\n");
> +		qla_pci_set_eeh_busy(vha);
> 		return FAILED;
> 	}
>=20
> @@ -1506,6 +1487,7 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
> 	if (qla2x00_isp_reg_stat(ha)) {
> 		ql_log(ql_log_info, vha, 0x8040,
> 		    "PCI/Register disconnect, exiting.\n");
> +		qla_pci_set_eeh_busy(vha);
> 		return FAILED;
> 	}
>=20
> @@ -1583,7 +1565,7 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
> 	if (qla2x00_isp_reg_stat(ha)) {
> 		ql_log(ql_log_info, vha, 0x8041,
> 		    "PCI/Register disconnect, exiting.\n");
> -		schedule_work(&ha->board_disable);
> +		qla_pci_set_eeh_busy(vha);
> 		return SUCCESS;
> 	}
>=20
> @@ -6669,6 +6651,9 @@ qla2x00_do_dpc(void *data)
>=20
> 		schedule();
>=20
> +		if (test_and_clear_bit(DO_EEH_RECOVERY, &base_vha->dpc_flags))
> +			qla_pci_set_eeh_busy(base_vha);
> +
> 		if (!base_vha->flags.init_done || ha->flags.mbox_busy)
> 			goto end_loop;
>=20
> @@ -7385,6 +7370,8 @@ static void qla_pci_error_cleanup(scsi_qla_host_t *=
vha)
> 	int i;
> 	unsigned long flags;
>=20
> +	ql_dbg(ql_dbg_aer, vha, 0x9000,
> +	       "%s\n", __func__);
> 	ha->chip_reset++;
>=20
> 	ha->base_qpair->chip_reset =3D ha->chip_reset;
> @@ -7394,28 +7381,15 @@ static void qla_pci_error_cleanup(scsi_qla_host_t=
 *vha)
> 			    ha->base_qpair->chip_reset;
> 	}
>=20
> -	/* purge MBox commands */
> -	if (atomic_read(&ha->num_pend_mbx_stage3)) {
> -		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
> -		complete(&ha->mbx_intr_comp);
> -	}
> -
> -	i =3D 0;
> -
> -	while (atomic_read(&ha->num_pend_mbx_stage3) ||
> -	    atomic_read(&ha->num_pend_mbx_stage2) ||
> -	    atomic_read(&ha->num_pend_mbx_stage1)) {
> -		msleep(20);
> -		i++;
> -		if (i > 50)
> -			break;
> -	}
> -
> -	ha->flags.purge_mbox =3D 0;
> +	/* purge mailbox might take a while. Slot Reset/chip reset
> +	 * will take care of the purge
> +	 */
>=20

Please fix comment style for multi line comment.=20

> 	mutex_lock(&ha->mq_lock);
> +	ha->base_qpair->online =3D 0;
> 	list_for_each_entry(qpair, &base_vha->qp_list, qp_list_elem)
> 		qpair->online =3D 0;
> +	wmb();
> 	mutex_unlock(&ha->mq_lock);
>=20
> 	qla2x00_mark_all_devices_lost(vha);
> @@ -7452,14 +7426,17 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, =
pci_channel_state_t state)
> {
> 	scsi_qla_host_t *vha =3D pci_get_drvdata(pdev);
> 	struct qla_hw_data *ha =3D vha->hw;
> +	pci_ers_result_t ret =3D PCI_ERS_RESULT_NEED_RESET;
>=20
> -	ql_dbg(ql_dbg_aer, vha, 0x9000,
> -	    "PCI error detected, state %x.\n", state);
> +	ql_log(ql_log_warn, vha, 0x9000,
> +	       "PCI error detected, state %x.\n", state);
> +	ha->pci_error_state =3D QLA_PCI_ERR_DETECTED;
>=20
> 	if (!atomic_read(&pdev->enable_cnt)) {
> 		ql_log(ql_log_info, vha, 0xffff,
> 			"PCI device is disabled,state %x\n", state);
> -		return PCI_ERS_RESULT_NEED_RESET;
> +		ret =3D PCI_ERS_RESULT_NEED_RESET;
> +		goto out;
> 	}
>=20
> 	switch (state) {
> @@ -7469,11 +7446,12 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, =
pci_channel_state_t state)
> 			set_bit(QPAIR_ONLINE_CHECK_NEEDED, &vha->dpc_flags);
> 			qla2xxx_wake_dpc(vha);
> 		}
> -		return PCI_ERS_RESULT_CAN_RECOVER;
> +		ret =3D PCI_ERS_RESULT_CAN_RECOVER;
> +		break;
> 	case pci_channel_io_frozen:
> -		ha->flags.eeh_busy =3D 1;
> -		qla_pci_error_cleanup(vha);
> -		return PCI_ERS_RESULT_NEED_RESET;
> +		qla_pci_set_eeh_busy(vha);
> +		ret =3D PCI_ERS_RESULT_NEED_RESET;
> +		break;
> 	case pci_channel_io_perm_failure:
> 		ha->flags.pci_channel_io_perm_failure =3D 1;
> 		qla2x00_abort_all_cmds(vha, DID_NO_CONNECT << 16);
> @@ -7481,9 +7459,12 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, p=
ci_channel_state_t state)
> 			set_bit(QPAIR_ONLINE_CHECK_NEEDED, &vha->dpc_flags);
> 			qla2xxx_wake_dpc(vha);
> 		}
> -		return PCI_ERS_RESULT_DISCONNECT;
> +		ret =3D PCI_ERS_RESULT_DISCONNECT;
> 	}
> -	return PCI_ERS_RESULT_NEED_RESET;
> +out:
> +	ql_dbg(ql_dbg_aer, vha, 0x600d,
> +	       "PCI error detected returning [%x].\n", ret);
> +	return ret;
> }
>=20
> static pci_ers_result_t
> @@ -7497,6 +7478,10 @@ qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
> 	struct device_reg_2xxx __iomem *reg =3D &ha->iobase->isp;
> 	struct device_reg_24xx __iomem *reg24 =3D &ha->iobase->isp24;
>=20
> +	ql_log(ql_log_warn, base_vha, 0x9000,
> +	       "mmio enabled\n");
> +
> +	ha->pci_error_state =3D QLA_PCI_MMIO_ENABLED;
> 	if (IS_QLA82XX(ha))
> 		return PCI_ERS_RESULT_RECOVERED;
>=20
> @@ -7520,10 +7505,11 @@ qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
> 		ql_log(ql_log_info, base_vha, 0x9003,
> 		    "RISC paused -- mmio_enabled, Dumping firmware.\n");
> 		qla2xxx_dump_fw(base_vha);
> -
> -		return PCI_ERS_RESULT_NEED_RESET;
> -	} else
> -		return PCI_ERS_RESULT_RECOVERED;
> +	}
> +	/* set PCI_ERS_RESULT_NEED_RESET to trigger call to qla2xxx_pci_slot_re=
set */
> +	ql_dbg(ql_dbg_aer, base_vha, 0x600d,
> +	       "mmio enabled returning.\n");
> +	return PCI_ERS_RESULT_NEED_RESET;
> }
>=20
> static pci_ers_result_t
> @@ -7535,9 +7521,10 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
> 	int rc;
> 	struct qla_qpair *qpair =3D NULL;
>=20
> -	ql_dbg(ql_dbg_aer, base_vha, 0x9004,
> -	    "Slot Reset.\n");
> +	ql_log(ql_log_warn, base_vha, 0x9004,
> +	       "Slot Reset.\n");
>=20
> +	ha->pci_error_state =3D QLA_PCI_SLOT_RESET;
> 	/* Workaround: qla2xxx driver which access hardware earlier
> 	 * needs error state to be pci_channel_io_online.
> 	 * Otherwise mailbox command timesout.
> @@ -7571,16 +7558,24 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
> 		qpair->online =3D 1;
> 	mutex_unlock(&ha->mq_lock);
>=20
> +	ha->flags.eeh_busy =3D 0;
> 	base_vha->flags.online =3D 1;
> 	set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
> -	if (ha->isp_ops->abort_isp(base_vha) =3D=3D QLA_SUCCESS)
> -		ret =3D  PCI_ERS_RESULT_RECOVERED;
> +	ha->isp_ops->abort_isp(base_vha);
> 	clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
>=20
> +	if (qla2x00_isp_reg_stat(ha)) {
> +		ha->flags.eeh_busy =3D 1;
> +		qla_pci_error_cleanup(base_vha);
> +		ql_log(ql_log_warn, base_vha, 0x9005,
> +		       "Device unable to recover from PCI error.\n");
> +	} else {
> +		ret =3D  PCI_ERS_RESULT_RECOVERED;
> +	}
>=20
> exit_slot_reset:
> 	ql_dbg(ql_dbg_aer, base_vha, 0x900e,
> -	    "slot_reset return %x.\n", ret);
> +	    "Slot Reset returning %x.\n", ret);
>=20
> 	return ret;
> }
> @@ -7592,16 +7587,54 @@ qla2xxx_pci_resume(struct pci_dev *pdev)
> 	struct qla_hw_data *ha =3D base_vha->hw;
> 	int ret;
>=20
> -	ql_dbg(ql_dbg_aer, base_vha, 0x900f,
> -	    "pci_resume.\n");
> +	ql_log(ql_log_warn, base_vha, 0x900f,
> +	       "Pci Resume.\n");
>=20
> -	ha->flags.eeh_busy =3D 0;
>=20
> 	ret =3D qla2x00_wait_for_hba_online(base_vha);
> 	if (ret !=3D QLA_SUCCESS) {
> 		ql_log(ql_log_fatal, base_vha, 0x9002,
> 		    "The device failed to resume I/O from slot/link_reset.\n");
> 	}
> +	ha->pci_error_state =3D QLA_PCI_RESUME;
> +	ql_dbg(ql_dbg_aer, base_vha, 0x600d,
> +	       "Pci Resume returning.\n");
> +}
> +
> +void qla_pci_set_eeh_busy(struct scsi_qla_host *vha)
> +{
> +	struct qla_hw_data *ha =3D vha->hw;
> +	struct scsi_qla_host *base_vha =3D pci_get_drvdata(ha->pdev);
> +	bool do_cleanup =3D false;
> +	unsigned long flags;
> +
> +	if (ha->flags.eeh_busy)
> +		return;
> +
> +	spin_lock_irqsave(&base_vha->work_lock, flags);
> +	if (!ha->flags.eeh_busy) {
> +		ha->flags.eeh_busy =3D 1;
> +		do_cleanup =3D true;
> +	}
> +	spin_unlock_irqrestore(&base_vha->work_lock, flags);
> +
> +	if (do_cleanup)
> +		qla_pci_error_cleanup(base_vha);
> +}
> +
> +/* this routine will schedule a task to pause IO from interrupt context
> + * if caller sees a PCIE error event (register read =3D 0xf's)
> + */

Please fix comment formatting for multiple line.

> +void qla_schedule_eeh_work(struct scsi_qla_host *vha)
> +{
> +	struct qla_hw_data *ha =3D vha->hw;
> +	struct scsi_qla_host *base_vha =3D pci_get_drvdata(ha->pdev);
> +
> +	if (ha->flags.eeh_busy)
> +		return;
> +
> +	set_bit(DO_EEH_RECOVERY, &base_vha->dpc_flags);
> +	qla2xxx_wake_dpc(base_vha);
> }
>=20
> static void
> --=20
> 2.19.0.rc0
>=20

--
Himanshu Madhani	 Oracle Linux Engineering

