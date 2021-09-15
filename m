Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E823C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 15:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E61860C51
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 15:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237972AbhIOPnU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 11:43:20 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:43124 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234294AbhIOPnT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Sep 2021 11:43:19 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18FEjrcE017542;
        Wed, 15 Sep 2021 15:41:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=UV1M/hdvRjno2lKFFPyAF9ZYDe0BrcGtklL//4MCbO0=;
 b=LyHAYY7OucVx4nZciWcNCXx1Fq9uzXKCRn7oTQ4FyOc8Xxz0QQWlWzzzkzNKxrpf/8qY
 XOxLZV24JmcFaO3nih88+NFyANIsMxiteh10ZraxMipkCTUSi9IT4PcU90o9izTHmdLt
 7aWjwy+IW2mRbLHHqy2Moo9p/R6ms0cQmYIlgPROak+Dj7x4UvPmW5wY1wluq26daHmh
 Yed3SqdUHzhc7tSsaShATRgP7CB5sByhigut1Xm0I+kXmCeKPvc1CAjHa0FbSAX53ec/
 LUnDk54RxZc9DSU5n32+56/tgwpS6baNH0IQw+GTvrgWlNi3ClWZ46DUH+0Y276dnGVG 0A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=UV1M/hdvRjno2lKFFPyAF9ZYDe0BrcGtklL//4MCbO0=;
 b=f19QkGyFxxNWYyKZxPtxyaHWnJqNCYC4FkqJFEe4CklJ9K+PdZoT7xijrwrdyBEAViLt
 uYGtF5HlUrDAADika4ru/BAu0Tix9dwVqc7rUumK7MHNPiQcSVfVpla4IIn+LaXoWYRv
 rKPBb73sTux0I+jkXejDzCJf24iaU7C3g7kQEFleaVW99xb7J9OQWvPVabDWbnsdriY6
 wje6PUb5Wzn3Ym0enij7QcSzQPn9wsNjXmQEqCdRI1XXTKBCn+OKfV1iu9J3Cz4elxWw
 KmpHM8fVkIk8gP6qWNqkM5Qju1g+fZBdLS3arcGVE0S+nbUumZfchnQuRSsz1b6lo604 Bw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2p8tdeqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 15:41:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18FFaZPK056577;
        Wed, 15 Sep 2021 15:41:58 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by aserp3030.oracle.com with ESMTP id 3b0jgetrmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 15:41:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkeMfA9eKOs5X7qbGShtoj28MmqroOPoxjER3ct7hAk9cX4mV62RDxCS2OvUUOd3Md7Gmp2gxrQjCuMKukEk8ZSutTuUaihZAQxCo48CHRXoQIPGJD58QxA9NI9ot92FCB26l0Ut5t2nJAsJtxv+tCHGxVkWQm61T2zYl1e9f6liK/NGt/6wg7AxopP6LF3gRbdnl5eRUeRwPbPCYOAvRlzqlwVtzV2y5lWG0kOhav4peSi/TuJK/Qw+6mCIMsOms596Yz+UN1+MC1coGe0DoJx2kj21HtvkNv1TUnaY7tpXsOnJzwqCiZtMGX5HtZ/O/naV7Muvw1bNoDFxijRvOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=UV1M/hdvRjno2lKFFPyAF9ZYDe0BrcGtklL//4MCbO0=;
 b=cUI95RIzSjE7iaLtUM9uqLKSSoqshPx2I7DMDsAQn2hYylug/NpHq0Nyz/MFISSem/YLC8SliReV3LIWTvh73ErV6RLKwRo2ewcHUO8xlCmGYKAoLaSQSkXzXNkxZqMJiSO0K58hDYZ5UoKu2DmFtJp5uU4EzfuyRFc1PXsXTP+T3ObaLvj2PAL+gtA2M6P8nIY1qQJPa+Hcu7lXFCcXFCedDSoGn2rgj8D+HMMOUL//OPANA9bwxpF5fXry1NIjIROMRab+RuG4lRhG3lbJHD7WYZDZcBUfYM9i5JVtFfONTMHsd3vstm/CDz/Ybv1FBdTiIPudSngUV9IiBj+0hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UV1M/hdvRjno2lKFFPyAF9ZYDe0BrcGtklL//4MCbO0=;
 b=iiV0xt0L21jyPKsphcGvLpLFVZOyZfKWbeEu8s6zsxtBQKmFOBgRL6A99n2OwcGZCWou3I0Z7q5F74pqcVEy5IyYWHoVhvgrIFBnGBj1ci4eJb0lOYknaMkbVpMZDl6v3s2OpUevOJ+Jbahv4AQiQwd9GBGTjQ/ia9asrFf6X/0=
Received: from BYAPR10MB2934.namprd10.prod.outlook.com (20.177.224.214) by
 BYAPR10MB2533.namprd10.prod.outlook.com (52.135.218.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4523.14; Wed, 15 Sep 2021 15:41:54 +0000
Received: from BYAPR10MB2934.namprd10.prod.outlook.com
 ([fe80::d477:c047:7008:7696]) by BYAPR10MB2934.namprd10.prod.outlook.com
 ([fe80::d477:c047:7008:7696%7]) with mapi id 15.20.4500.019; Wed, 15 Sep 2021
 15:41:54 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "open list:SCSI TARGET SUBSYSTEM" <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH] scsi: qla2xxx: restore initiator in dual mode
Thread-Topic: [PATCH] scsi: qla2xxx: restore initiator in dual mode
Thread-Index: AQHXqkb2La1kuwDULU2j1s8LPSkj06ulO9uA
Date:   Wed, 15 Sep 2021 15:41:54 +0000
Message-ID: <059EE994-4578-4815-AFFE-CDBE27B095D3@oracle.com>
References: <20210915153239.8035-1-d.bogdanov@yadro.com>
In-Reply-To: <20210915153239.8035-1-d.bogdanov@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eeab6743-e00d-40f1-8d90-08d9785f580f
x-ms-traffictypediagnostic: BYAPR10MB2533:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR10MB2533272A045B588B9654D86EE6DB9@BYAPR10MB2533.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cSILn6+8Sxk57yFBXZCDDsu0Ht7D4ma4EA398LvofQzcah4SKygR186oq/RuusT/We/eGpxDF7CJviTWkUN6twkuo+iaS65g1EOH4cgr6cRB3P/9WLDZ5UACul8dxJAC5YrvN5UGQ1kcNgeTSzVoSiQzHDKOnQzQC8c+UZ8PncJS3cNInxE95HhpbE1FVpIJL5V2xWQ+wqKlMeIDhUDMlgo+2Bk8ccd809a7TbSuVC0OiNZ+QQO47V3Hc2mefsK/T6WS6yyF4OpDQNX+4h7TF3tRtfpMJvFE+UdJEUp4CHntjS++4v7zo+yVpjY2Om8OmE52ZAgb37ghX6pAe19YxMTsOPOPGb/cQZO/iyV+CyuOA+AZ0pKJwY6ZVMyxVANO283x/icQBTJ3IJEfwkLt+bMrWhFfZLebvPH6asHKFiv9mbjLLIdzE0tlxfzc6RzRFyq/iPSlPMZfZCDQEWHvpyjNs4eQA28KkPcV52S4AfOMmpZs2nIWDj0gSsqo9v5N79zbYVUHLi/HT/9kQZ1m9h/yUVxkbNxNQtBqaxd8YPmIeVWTl0mF1PLBojIeCSEslz+He3jXn+LFTaxhN4w0XvTbGV7vo/GLWb1IIxB7xGBvp/zg8LdDJJASzKGKqpFw4MKjfxr/y+6aMPS6uwOHz+AaCCvevdrJI0Lxef74scyAK3/aNVgSMe4oMYh0INdKfSzvvkkGHszOsAL2Uu8mm6fHKiv8GnEJjcR5VlHGz8KGUc3ZyedVAi6k63RS5w2K
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2934.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(136003)(366004)(376002)(83380400001)(6512007)(2616005)(33656002)(66476007)(478600001)(53546011)(91956017)(26005)(76116006)(64756008)(66556008)(71200400001)(6506007)(2906002)(6916009)(66946007)(66446008)(38100700002)(8676002)(6486002)(316002)(186003)(8936002)(54906003)(38070700005)(122000001)(5660300002)(86362001)(36756003)(4326008)(44832011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O2BLcoMl3BKECAJlyYkngxYwoHimRqYTF8dekR8q1l+NBv58gJg+rkCgiKAr?=
 =?us-ascii?Q?ElbWl3f6sU1YrOq130i6Xv1Ggz0/q0FKVkM+PfLeESf3egiWxn4lsanv7vl+?=
 =?us-ascii?Q?AhUOCkSOT4OOPw6NxC7U67+9nN6ZUr/YiYxvLTlHChxHQMTMF1GCdZRtSP+r?=
 =?us-ascii?Q?zBwIalB3qFLCDYNXPV/RyyMmvCUv+3dbaWbWFMu8oS4x/tX9wH2v/g9emWv9?=
 =?us-ascii?Q?X/b/3AzzQtOvJFtM/VuNwbQ8lBXc/V0jqX4coAZKk11O4SqHZpXuw0C6FdSP?=
 =?us-ascii?Q?o5h0GqJrpEyGj8SZ686ngR9l/0RCPO2X6yihuK8bAbcnDAuxUTIWdgm6jwS9?=
 =?us-ascii?Q?1zMR25XHsK9PSkT16iq2d2KQ7CrekSjFT0x/TURKhJl3TEdcF97Bdw+yvLBs?=
 =?us-ascii?Q?67DN9smCIbhq1/AXiHFTbx5SxiluKZ84Pm/GC0Nbq8RtdQWRWmzhsnZosA23?=
 =?us-ascii?Q?ZGHrf3TIey/1908EoHtgswtVjKp+fiEfgzOChrR9+UGFYfvRpQejk9ieTHvr?=
 =?us-ascii?Q?ynmkc/cMil9hesQVqKSOC/2eTVFw18uuihgvZylhcD5n8DymoMfCIrGK6fCe?=
 =?us-ascii?Q?H2FidiT5EZbOXbZoZI8zuzlKLi3EcAyDw72SMwfzDCRHcPMqny6VjFMga/Dm?=
 =?us-ascii?Q?VQbdnOegbCBoBIqSxlK+Hdh7EXvUVeLNzGMyazOaF/O4lTlaOuaF3nGKRIv+?=
 =?us-ascii?Q?MMO/2+zc1bq6rgfqkEl1uJg1S74q0vx69sBuE8iEnGfn3XgaXmE0CXAu3O6Z?=
 =?us-ascii?Q?yxUHMC6vS+1K1bwEPOGdcZqNUkVDy5bEWeXpycs+2+EaKPlnw1bvHcucju2f?=
 =?us-ascii?Q?d/X9vNmM88rNOMNGDlo/3LtohAKqx/p3lDbi7OLMUfl2LkjbBnV3KKQ7sthT?=
 =?us-ascii?Q?cOZpcs16Nk63VrDCY8zTvswH28ah0R32mv2Q79RJoXi9ZvaeXlrzzPEoqoQZ?=
 =?us-ascii?Q?qmnG9tW1dA2tqiwqOXrL7mTbLTFiKm4qS6RryrLJQxdxGVxVm9QIN+YmCmQb?=
 =?us-ascii?Q?CGPJhV51AWTkkbR897vH9QcvxxR5RYCpBls0pE1UMICQS/RvFWB+vPM/Ypas?=
 =?us-ascii?Q?68M6+6PjIQ944dLrIFCw8le7KooB1L+H/wmNVeF9ORtyriAetXvP7G0BLCHj?=
 =?us-ascii?Q?3It41yVUh7jjujSZMgISnQwbBgrgSAe5t9r9DwJyrwWAo+Jc+BHiCR9MbLCR?=
 =?us-ascii?Q?giYAm6aFOllMWOQnQ8WIQDkzPNQB1uRWW/3HeM04V0/nX4VRt4JdtmtjsKhj?=
 =?us-ascii?Q?GynyI2z9j9KpMj8+cKJhLqZZJRZIIKkoHrFa3pht6umJG9ShuXzifGBRL83N?=
 =?us-ascii?Q?hdqUmZhxSEHJUu7N8YDgTsY2fMhSrNd6DRu1aAMIb+Obmw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F65E0B2E2AFD79438263D22D7D3976A2@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2934.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeab6743-e00d-40f1-8d90-08d9785f580f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2021 15:41:54.2437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2H/li06ZJz93WwUZ0FVE6zFeMC9egm9a/92V+aZiwdyRv40lHQm9V512Lv0IpWhKJ6VMDWh4dUKS1/CetdxHmqJTAMhhgO6kS5JNHRdgafw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2533
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109150097
X-Proofpoint-GUID: dkn5ZG0lDdUoAFsgLwdytJFpypih2ZvB
X-Proofpoint-ORIG-GUID: dkn5ZG0lDdUoAFsgLwdytJFpypih2ZvB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 15, 2021, at 10:32 AM, Dmitry Bogdanov <d.bogdanov@yadro.com> wrot=
e:
>=20
> In dual mode in case of disabling the target, the whole port goes offline
> and Initiator is turned off too.
>=20
> This patch fixes restoring Initiator mode after disabling Target in dual =
mode.
>=20
> Fixes: 0645cb8350cd ("scsi: qla2xxx: Add mode control for each physical p=
ort")
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
> This patchset is intended for scsi-fix.
> ---
> drivers/scsi/qla2xxx/qla_init.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 1e4e3e83b5c7..5fc7697f0af4 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -7169,7 +7169,8 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
> 				return 0;
> 			break;
> 		case QLA2XXX_INI_MODE_DUAL:
> -			if (!qla_dual_mode_enabled(vha))
> +			if (!qla_dual_mode_enabled(vha) &&
> +			    !qla_ini_mode_enabled(vha))
> 				return 0;
> 			break;
> 		case QLA2XXX_INI_MODE_ENABLED:
> --=20
> 2.25.1
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

