Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0570BC4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE49661154
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242133AbhHEPVv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 11:21:51 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:34550 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242077AbhHEPVi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 11:21:38 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175FCg4K020111;
        Thu, 5 Aug 2021 15:21:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=eFq3XyCUpng6GepwAUoPK65d5MBlDqzMmA+yoyJjT1A=;
 b=hWwwZKbEODv8bVPRd/YsVvOWhcTCFt1abI7rQpnowLhjjQTFPtuFcfERgLh79FA3iVp5
 8i3htUDyYrsc3QwwVr/zeM70DqLxmC98JrxU+viXrMhFqWBKo/s+akKcPl1NWq9IUk5+
 VZUx3b+DfW0enBWlbH7ukuUUSBYq8gthRFDeCj5aClWQL/z+4hCFgoSxZ/Zf35brRi0y
 Q7q4xlM/IIbj1rID11EOB2vrGiu15M/OfM3J7cMmc9gP3l3L40U63W/FPQQldn7gt2TP
 rvMhkmouph2Wux0P+SsE/HyY87R4VBoNpp1zQRXhWTolntrposzDvr6IW0wOeofqvT5f 9A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=eFq3XyCUpng6GepwAUoPK65d5MBlDqzMmA+yoyJjT1A=;
 b=yAno0740kLL1c1+GM2dHkxkTyMvqacawPiNbEXHz8XKIs9ps6JK62kRVhWUp8OWE0IWH
 9YLaDf3bsIB1O8T1oehWmlVvj1+ahnJtL+acA7NBNYoZDEtAJCa1QFxm+Fj6FRlMe+2Y
 xe7stIj3Kmfep6hoK1tS0tkLMNy0G+GL/NNxWoUF70E2rBmxluBKrVwLgtCYWVbv541Z
 Yt0VC8e0whYpvBH5j/HLRyzOYsdhDhLxJB2GPdm1TfVNWPVKMeL0P22XOs6LyDNBgwh8
 HRHmnEyfc9tM8sTDbVm3rUz6WxUNGngD7LBWhAeNO29yiYi9pzdN5+srbdGRzSe/Bi9a PA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7wquan8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:21:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 175FG5YN186621;
        Thu, 5 Aug 2021 15:21:21 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2177.outbound.protection.outlook.com [104.47.73.177])
        by aserp3020.oracle.com with ESMTP id 3a7r49wxgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:21:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjhkTrHRsBYkZpQFy82LCXxKt0JHViabLombIP9qtfz5JEAAUDewI1QE4kWLFSpUp5OtC5bWklRqkI8m86qLYa2OohWGm2utEf9LIC60JDN1MOVXJBTyLu4+qX3lOKpDq5+VeyA5QpWza+vJ0JWtVvahsOhWBCb8/3+o6Incm+Pf9rej91UqAOiDS7y1aQ1wifn9h9tzIrMi3hZ2nuwuPdsQz4HRFKyNm/Fjy6ATeWxvMs+9VCB+uQcoUEoA/V2UZtHmwVddsNWKOjISQygE4+MbYuy0hhJErZHUIeN33klTiTe95FBat1f46tCLmFp19PYPgxXRAAHIQo2LIZcCiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eFq3XyCUpng6GepwAUoPK65d5MBlDqzMmA+yoyJjT1A=;
 b=StRupB+7r4RcavDKXpdIjTPV7xFECanE5DqffQZ2cucZABX7qkBnz+gBa+tDuau0XNHE51mTNemBrJS1kcapISXKeA0+ePVNTa0KZSLzjt+mRYhjZenl4ZvlYialTYJx9MYux+g4JfILzsTw3h2meeWNdkzBoPMxdVzpC4ivddHauwG2IvwWliEb8xKi8atqEvgbl/x62daq8HzYTfjMMeA3AJEWoi7Ho327l7wYYAewTlcUId0ys7IbQXp8YeUTqQLDAuWAOP1KRAch3/HUSV/7LLcEH4ihyPP6TCGnJfa7wH/ygbfGUHIUX+BS9P3ATIyuonmW/KKM5dKsACS05Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eFq3XyCUpng6GepwAUoPK65d5MBlDqzMmA+yoyJjT1A=;
 b=pjVHbKRE7tg0GLBTcBGbZMvPmt1PJF0dX7XH6zTh1Ikvr/LBgEWSiRp9+DFYbRrg+ev4H6Xrr0XuDOIX31JmtX20wRPCMnNO8MAdIT4o02Dct6eO9XRmhHB9VQywL4kSr+pH0AJN7lMT0KUFYpXrTOZP9axvfOkjg/V8IywsmSA=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4553.namprd10.prod.outlook.com (2603:10b6:806:11a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Thu, 5 Aug
 2021 15:21:19 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43%5]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 15:21:19 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 03/14] qla2xxx: adjust request/response queue size for
 28xx
Thread-Topic: [PATCH 03/14] qla2xxx: adjust request/response queue size for
 28xx
Thread-Index: AQHXieO1NSKSPEyVpkKPx9mB5kM9H6tlB0sA
Date:   Thu, 5 Aug 2021 15:21:19 +0000
Message-ID: <3D9FF9C2-734A-49E0-AEBB-4B17B32823B5@oracle.com>
References: <20210805102005.20183-1-njavali@marvell.com>
 <20210805102005.20183-4-njavali@marvell.com>
In-Reply-To: <20210805102005.20183-4-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69d72da6-c38c-4cf5-5f8d-08d95824ad00
x-ms-traffictypediagnostic: SA2PR10MB4553:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB45538A9C902922929B684493E6F29@SA2PR10MB4553.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:813;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3wDjCWgaoGxemMqu9DWdSMdc5CUs9x9HTm8fiFd5Vdg/3/+CV55tjMpJ6veUcV96nDFdRdl2PMJ7vfxNt5Wm4SsVy0BZJCP6d8KitjB1DM/OVKqgMeMh+vAD4l8KakmybiWTCpfzRVF/jU34QtmAkk871IFBy0K8+A9imN9kESBRL+Stl/xP44eDvHHYcJ2g1xbLLkjnhfyVuJenZBu2HZbXebUgzYKrexW52yvbXdrXOSXUhOQh4v7EFoZjAuipuE8NcgStZs2MDNAKHXkJhDuE8AQwVapHg8Zb7xnpzUejJ6DN8rIvWy046qOCud8t8VavyC2vIwdl6ZQKZ+Ej4OUKE7Q+weCp0hdck9D24f70XCTdemdwa9fCxspJnNNCjzE+gbTzh5Mz+nP5wMOZKMaBOjlOlbLw/B+RyJBU/ENzjEW2CH1ry0l2TV7dfxW/rLDysWZtbKsIxyn/H2ElbQEgf6kfcIaKqOxE5apc3fjBsHIZDB1DcOWWhU9Z7nY6xUiS1uMCslyP7RBR2xF/y3OlnEownf/oN0jU8oeHhkV7UinMYfbNvnPxjzLYr3BlZeYVsXdnDYWUYjuJSg1RcyiHHlXbGl9P5KaeJvTAgvYoT6cJ9vR6kY5JqvV6g9g828iW7FWmoTZoffHB90Mu9tXtGVj3sCWZiYkj4oOtmBA76ME0RcP2+tpXdsIqDwCcR2aY9rYcbfq7IvaP2a7NGxv1lipv28M9bq8yTf1Toto=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(346002)(136003)(39860400002)(186003)(8936002)(2906002)(36756003)(53546011)(6512007)(38070700005)(8676002)(122000001)(2616005)(38100700002)(6916009)(478600001)(44832011)(83380400001)(54906003)(66446008)(76116006)(66946007)(71200400001)(64756008)(66556008)(33656002)(5660300002)(316002)(26005)(6486002)(4326008)(66476007)(86362001)(6506007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QqK0Qd62i+xSmKbjgi7km0GYYi7iLn95AXMGAiZxHyBpgoN5+RHF69f9fSIC?=
 =?us-ascii?Q?gqxkuIkLTviEJr/oqxc9H64jpV6rskC4bRRNbEZjZWsl6BeYnoS6qq5PyBvR?=
 =?us-ascii?Q?8nj4jbHGaSFMRk+N+ZTBf5JHwo8+0/judbLZURSv7AL1O093EwiCPZ1EG08j?=
 =?us-ascii?Q?ue7faRZTI1GOBb9i6hVanyNcvw9IHkXUAwzYvVMlUlHfCCkBCIXJFk6sv0o2?=
 =?us-ascii?Q?9WBpUiYR4ZlRT0sJ4OSMCSqp3fcCmZxuaDfFdmqpe76HxRbPU6nv2L4aHMeF?=
 =?us-ascii?Q?t5i5AyNaJUtoz6w4V2BxGlxYO9Hp/JG+buGvOhpCEdQ5OLKBOjJPjauQySFm?=
 =?us-ascii?Q?IZHdDBh8bMvHMZ2RwD/LgLRSge9HBbJj5aKQYrKdMHIf1e2iUKj8F80tPzQr?=
 =?us-ascii?Q?QPSfoNKb0/YEXCDrrQFxwq3R3/0eStJRL8gzhjYtVANGNXCsUMgXC4AkQ5S9?=
 =?us-ascii?Q?VLYd2TNkTx4xHzg2FTaopqe8wQoJwr/NDA90oaoZZ6h4PnBmBqlrCwehODgf?=
 =?us-ascii?Q?epPS91KXyJMWKS5Q/GMkiy+uiqxrU5P9hIsago6L95rxMvy1IW0FYydLeJKS?=
 =?us-ascii?Q?gS8kPuyeGYUgyKweQENXs4VpNhtLdS19XKMMK2A/FbKKneeGoKvYdnQo8d5K?=
 =?us-ascii?Q?N7x6kPj2JesDvHRYC2vnzJzrmdLKBaoyp3xWEPbRs56Kkn5A0P7G8/TQTtfD?=
 =?us-ascii?Q?NJXgY8hg0d4oNad6M7hLL1MHMByrAvY44vMZeFEUzwGqz1Ct+iPFctMGS0QE?=
 =?us-ascii?Q?9EadG3lh9jqGudoGqY3kPXXF235hUWViuJwsty4vD/y687D9TlXyu871yeKH?=
 =?us-ascii?Q?JcYeCeYXIwey3XMS3UkfYRU45cGyYQc9zSG8BjzGQHgXDctES2ux36UXT5nO?=
 =?us-ascii?Q?B0HZQjuNveJWzdBW3MoRb2YIMa5dzvvEJnceHnYDuUehuLkar4D0/pTIVjfx?=
 =?us-ascii?Q?lhl0xJXKuGiQeTIrmCT/rclRimf37hrulSNfHCnbwaz56D/4lmyzlQVTi0Uv?=
 =?us-ascii?Q?1MRxUxeO3vwTeStS7/WLU4q/BgUqmYmBLNyRXxncUi9YJVg3ghiB47eNIg0R?=
 =?us-ascii?Q?U3mDTqXQVmpeuoJbxlguP/p+8XSNjdteqBuhmGa04K1Uu9SXWbGRVcX+ebqb?=
 =?us-ascii?Q?wRd8o0+6obAuJa/o+qT4/fsfSTouRt9xTL0pyIdcSItFH3TzQKRTzCpIK9TP?=
 =?us-ascii?Q?/CAo8+oS0bufsYmKMcVO223hDYjLlXE01yCPet2RpJW3p9RLCeS6cRAqbGdV?=
 =?us-ascii?Q?lfCLnrtk4b/umcz5sDvonA2pvtnVwgCG8cmvHhMk4V1njYuIfLdNAzf9/RaO?=
 =?us-ascii?Q?qz41uDAwv10gymV0dpnBOoCS?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C3C54BE050B1C743820DE6597E5FC621@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69d72da6-c38c-4cf5-5f8d-08d95824ad00
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 15:21:19.3246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rgr2gAq9opGH5yxH8sxJXpMpymtFMlkdyfmvA9920mtKwa/1AhQWaITvvkQw8KEV6OZK1ZqVWpgm/mRwFwRbKIeIpGn78tb0KR8X3i8isDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4553
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108050093
X-Proofpoint-GUID: CFsIFvXYfxVIzqziryLrvsavXBw8K282
X-Proofpoint-ORIG-GUID: CFsIFvXYfxVIzqziryLrvsavXBw8K282
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 5, 2021, at 5:19 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> adjust request/respond queue size for 28xx to match 27xx adapter.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 53e9eea031bd..921bd4d127f4 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3065,8 +3065,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struc=
t pci_device_id *id)
> 		ha->portnum =3D PCI_FUNC(ha->pdev->devfn);
> 		ha->max_fibre_devices =3D MAX_FIBRE_DEVICES_2400;
> 		ha->mbx_count =3D MAILBOX_REGISTER_COUNT;
> -		req_length =3D REQUEST_ENTRY_CNT_24XX;
> -		rsp_length =3D RESPONSE_ENTRY_CNT_2300;
> +		req_length =3D REQUEST_ENTRY_CNT_83XX;
> +		rsp_length =3D RESPONSE_ENTRY_CNT_83XX;
> 		ha->tgt.atio_q_length =3D ATIO_ENTRY_CNT_24XX;
> 		ha->max_loop_id =3D SNS_LAST_LOOP_ID_2300;
> 		ha->init_cb_size =3D sizeof(struct mid_init_cb_81xx);
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

