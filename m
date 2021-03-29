Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BADB2C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 14:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 844AA61927
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 14:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhC2ONw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 10:13:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51550 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbhC2ONo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 10:13:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12TE52oT053997;
        Mon, 29 Mar 2021 14:13:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=tRL+L3oezkMloo/BIiHAjmn6QQXyY5mawaqDOEtkm9c=;
 b=ADQN68SGhiCtkpYnH5nH8ZKKdlZUK2LdW2acV/GeV5LQJUD3Q5JWti4gzkPOrwAFqQFE
 GNEydwYgCuxNUkkPKZcF508UXqNI0lkM8FEANa6dCN9PhxlSZm3oX//5NGTOjKgJH7IJ
 +UzgZVJELbpADJWo0CneKrcRiNvIs3IszNkBPceCQeHwAXd2367zwtNyfJ4uv1D0OfpM
 5/cehxUaLPfefPFdtFRuqfTmlyPwWwGvLj9Xq2ona3uXMpLm/xY3gLcS8sRAz8AcUaZ9
 /KADEL4TN57cw4WsGER8UFEGnlOa1KuPJgOcjNJhNDU7VxVPKUkKADLg05oG6M4eBMXy Pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37hv4r3pc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 14:13:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12TEAcZ0153261;
        Mon, 29 Mar 2021 14:13:39 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by userp3020.oracle.com with ESMTP id 37jefqstaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 14:13:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etsH+V3DF5BeDD614El8Qn/z1VLlkUmgH6kd2s1as1ItZ1YkA7gpVXvr1JBpEA5aEn1Vq8HykiROzx7OUO4Tb9ApBJDoW7O0FutcUoSiktxsXxTHGexM+g620veJCn7OqCfH1Zy9edKlxW34T5ngRAVzqtmBHUeV+z+3TvFWF7DNkrpVpDCEvlXXqLBFOcKwbeSxF6YjT60di3Tgm1VRPjL/74L9eK/Sgl7P8bkzjwWlmhdv11tkIn6ACSpPfmrdfSe+kKVkR3j/Kk0BGgRxnl1QocHxYS4L+Wbj9xnYnA0Ez3YmfenNx8nQOft/Y/oUQ13653GxrtXMD2q6cBJzLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tRL+L3oezkMloo/BIiHAjmn6QQXyY5mawaqDOEtkm9c=;
 b=i305pg1f34Zzh8Ax5UtoiJEq6hKQvAInLtkoNF7fpG7rJm3zumrSjbNLVQACok7C3TjCvCryhIhuEouSse+XZ/b9TECbJnFYaQvm93ZI7IXwF+nhbLmQEunchkVqvc0I4uO05o3tIL6YddOPIIvo8am2n0rMS+v38EC7UzQ8TC/HhDT8EcBPRmopzJPxRcRXfN78LbXmjQ4x8neNOtusGcFIJuNkBjf3lUyP1LO04B8Yd0/uG2dIWc82o0Ktq+zZm6IVSof6uUP2l+PLd+nZuDaQSKqYkO1oksFz/UOV4w+Ngt8S/Zs1GZBnXlVcYdrB7HK7YH1OJ6B7Rm/MVbzBqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tRL+L3oezkMloo/BIiHAjmn6QQXyY5mawaqDOEtkm9c=;
 b=kXuLUJEyso7TAi7r6ZDFfFxwq7P/hZkMbE54y6a5V7ZZ9w9Oddbq6QHnt465DvHGK+NiKgL65YTS9eBZjX6AUkxVkZm/jC2EMEbge584HyxaL0EYOixN0byzuhsr0s8OJpnVLrNdw2MpUYAKTTdc0s4racjrEHJmd6RxWOkgGDo=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2574.namprd10.prod.outlook.com (2603:10b6:805:43::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Mon, 29 Mar
 2021 14:13:37 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 14:13:37 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "loberman@redhat.com" <loberman@redhat.com>
Subject: Re: [PATCH v2 11/12] qla2xxx: Do logout even if fabric scan retries
 got exhausted
Thread-Topic: [PATCH v2 11/12] qla2xxx: Do logout even if fabric scan retries
 got exhausted
Thread-Index: AQHXJHqewQtW4q9EdkGl8hFeUXXFIqqbAnaA
Date:   Mon, 29 Mar 2021 14:13:37 +0000
Message-ID: <672CFF3C-0104-4453-9DC4-7A1D4A2FE7B8@oracle.com>
References: <20210329085229.4367-1-njavali@marvell.com>
 <20210329085229.4367-12-njavali@marvell.com>
In-Reply-To: <20210329085229.4367-12-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c23fc03c-f7c7-4eef-fbd1-08d8f2bcd8dc
x-ms-traffictypediagnostic: SN6PR10MB2574:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB2574B85650F34C6AD04B0172E67E9@SN6PR10MB2574.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:586;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kiIPBOUqo4AG4+CT5iM1NoZvMDSuXe3pNgB5ymITl+czb92TNMfY2iNXQHWe6ph095gtKy+gi3zyvT11H/bSJaOQkbGi7XL/jmUWyHNOvMn5Z6mXCjX9OX4sm2UCGDUH4qySt8WUYNZ48NnGd2B49e+z2u/fAYAhygzy/lfekbsLw8WkOR4jkB5S0KAzd8uvqulOpUfRTly9z5pMoEL1vAt8Y2h4iTN72djZOzCM+ljzyfpJ5By/YMLDvWJiBuZrdI5s2Rx5kecPXv2dCH8DBn/lKK3OITDRRuAxG35ROw07Re1tjFLXI5REKyw5GKvKPWBk/XEWQkU6fv6bfVDePNEjsYtVnqdU3DyOVyt+WSWcNKE1GHk1VODivCbxABBi7DzZZSXMgwHQ+mbpIpf/kqkFWLqAmsMt05EupbYbUmsXXgA/GgXSpCICO1Dhar5p5QaHbxSp2E/EDyV4CDY7QB54MrvlMaV2nbW9Za/BRga16ktbh/vznSuUH9bU0Sfw4nml8VpvMAR8++3dCc0KrveAcQLWCXMLbrDbA6SHPV/OJhfMUWMjo8bTmg8xa03UnizBQlU4JtapmWrBLzKNQwUWFrqSu92rwh+oktU17f6VQ8CXJwgvr8GKH5wJkLzIvihHrp58KxUgaQvlGyivpQlLfH8Xmflpi7CDpw4dJkaZrMcMb5RW+1Ix6t6sC8A6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(376002)(39860400002)(396003)(66556008)(4326008)(64756008)(66476007)(66446008)(26005)(6512007)(83380400001)(66946007)(6506007)(2906002)(8676002)(478600001)(86362001)(316002)(54906003)(8936002)(186003)(33656002)(76116006)(53546011)(5660300002)(36756003)(38100700001)(6486002)(71200400001)(2616005)(44832011)(6916009)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Z2+dED7WKhbsDM0PX1FXcU96zkidtFtkLDY44f0AnipQd0AOkDpfu/SpYwzO?=
 =?us-ascii?Q?giyNXUY8I5O/mk9KGxux5US4B2VF1wiLdx9wz72NyiVQqfZrzHc2EmBt+jA6?=
 =?us-ascii?Q?P0I5Q8R1JfWCxza8eD1sFmRYGa/+02mrJ+ICw70p4+3NUBu9ibi1rkcjbKA+?=
 =?us-ascii?Q?SPbNSzAU/fI6tMxO1/YU5sB2tme/JpX6ECFjtjgESsJgu2bj0RUJ7P0YP7Oj?=
 =?us-ascii?Q?vuns/rZMOZmYfsN00uCpNoM+s/QYoF6LRJaH392C67bIl3d3KasbubTqxDD/?=
 =?us-ascii?Q?uDc0zx4JAP+O2s52d8N59yGH+a1Z+Wn4ucsI/rXHBmw48yTXD2/jZFKAXo7f?=
 =?us-ascii?Q?FqjvtBe9pSPEV0Gu+z/d482avGVK7hR6cP00cYbJt/lFDVocSIyHV0e0jidx?=
 =?us-ascii?Q?uy3s08gc5IH5rr8GoYhUOqlFwMkg90z2qzRHD8/ThfRn/SD51m6cXaZ91wqN?=
 =?us-ascii?Q?wYFmIDREI1+tkmyz/nxaT1sHoAjgBUDtZurzh/1mxBUq/dSHXTc9bY2CYyTG?=
 =?us-ascii?Q?sy2xYPRb/oKNl4K0WLd5XBNY5MkP3SeaYhBZMaXJBInWrVK7fbRQMCq1WL6Y?=
 =?us-ascii?Q?Bsgk9suxc72+Wi5fwRQ55H3phyqrXt5L6H+Ae86tt1h+4NCJr7cRMty7kaG+?=
 =?us-ascii?Q?/VtJFbsjPwirQK3RTAZWfMp5H3WpCY4H4FtQcntcXXnsqKquv2xuth2Ws8X2?=
 =?us-ascii?Q?pF42suj4/vltQFLv3ME360tfDL/yvGn0Fl4AOhKoRbUPA1UlI9/WN0PLAFWy?=
 =?us-ascii?Q?u8dSa9uxkuEd/yMzlg98RUMymfyF/aNJB3NbHbuAvn7XQGijMJyfx7Wyz+mv?=
 =?us-ascii?Q?M9n/2VyEuNsL4bgLcYjvJPO5mQLIeBYZo5EZbiwrjVD7mIw4qUDKuczwEQIT?=
 =?us-ascii?Q?+meh1CLgvnekKmACavDPqruJZIQfRVuzgzatgMLj6S0iV6OgqT/m81Uq47Nb?=
 =?us-ascii?Q?Whgm6iRxZbWoyIwXnJl+Dbg3/GeqQ/+e8lAsZhYM3PHdQtaET8EPo611gP6f?=
 =?us-ascii?Q?7ECa5vB/EAokBNXDYTvVPybQOV5yU/IbQG1/FtHnMelZAAUrU2xYJlTKw8ey?=
 =?us-ascii?Q?cG3UCMOvK6xh8x/ry7TYeXPZH6dz/yGBRjKdEAIw34ByXw9dSqSh9BJIzJw7?=
 =?us-ascii?Q?ZmdrQd8ho3G8H5WBFPNrPABhfRo1rnRvcbtWmSDCxa1XeMQzaGu7zY4UPtwD?=
 =?us-ascii?Q?wqSaScCoLXwf4RitgUEWSR7Y8PbPJbUpXQ8hWirjRFketDxpqGMSn1d3aH4h?=
 =?us-ascii?Q?7KGUPGLppBLBIy+7yMst0l9YWBnUgSWdwOmB1eIwdpOKGJ0H3NW89Szpapln?=
 =?us-ascii?Q?2yQf+wWqqLDLjhW4FIUda3BPXZid4IokRNPjCjzW9RXrrQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AD439503AB45FE47ACDF62E1C6C3B69D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c23fc03c-f7c7-4eef-fbd1-08d8f2bcd8dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2021 14:13:37.7460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jjOUtd2b+U2ExRpjb0wFYJIB3xo2YcTmyMIRy/yFD/b6n5N+hOnwsC/FuxyYzIuwaiaLuyEl20ot4TR5GtsNIO6q185wbs5zN68TSl3B1F8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2574
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103290109
X-Proofpoint-ORIG-GUID: sJfJ8dmkbRCUvFLrd8HJ0mEJ92F0DYYT
X-Proofpoint-GUID: sJfJ8dmkbRCUvFLrd8HJ0mEJ92F0DYYT
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1011 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103290108
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 29, 2021, at 3:52 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Perform logout of all remote ports so that all IOs with
> driver are requeued with mid-layer for retry.
>=20
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_gs.c | 4 ++++
> 1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.=
c
> index 517d358b0031..2a93d9c3c024 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -3443,6 +3443,10 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha=
, srb_t *sp)
> 			list_for_each_entry(fcport, &vha->vp_fcports, list) {
> 				if ((fcport->flags & FCF_FABRIC_DEVICE) !=3D 0) {
> 					fcport->scan_state =3D QLA_FCPORT_SCAN;
> +					if (fcport->loop_id =3D=3D FC_NO_LOOP_ID)
> +						fcport->logout_on_delete =3D 0;
> +					else
> +						fcport->logout_on_delete =3D 1;
> 				}
> 			}
> 			goto login_logout;
> --=20
> 2.19.0.rc0
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
--
Himanshu Madhani	 Oracle Linux Engineering

