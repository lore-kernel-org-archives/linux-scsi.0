Return-Path: <SRS0=0D1w=7E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E77CCC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 08:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9E6020757
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 08:37:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="M8yy+r3f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbgEVIhA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 May 2020 04:37:00 -0400
Received: from mail-co1nam11on2046.outbound.protection.outlook.com ([40.107.220.46]:32602
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728959AbgEVIg6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 May 2020 04:36:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZKoAWZ+rX7eY2R77WD+hCJV38abdLAnjxoRswKaIhTwMNjLOnoDOfvP9F7jCvQjYXXa6jy4fbhh76HNNA7DYRU5l4eeYxX18GVVC4xj+NjIGyvv4bsL2e4WVqWeHvG32Eciin5SuL8g/pK6Lfj1frmObyaPpSKM+FTId+k0YmvKAgyGdGxOg21pGvdTBHqmGAsfXzZt0NacD9iFbIbhezM6ROR5x2YwQ42MMhxOCecCmFaPrRIBJrQyepFOZMdyuxvFTZhCo7wRA1Qr/0+6FMQaV/wFUS3RYRzgWPNKML7ZEj4YPcjt4jDcSF4JVbORnKlDMXKwndny775N9xzFqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Lby/dmjQ5F8asMRZ69wH+huKDwLA2+unC7J/ZCQKmE=;
 b=GQCrueShdQEXHATlvpL8sxzPY0cvtZDrj6cTczDAAGyUjl4Y1roIu16SWupLbXjreazD07kt8XywymhyXeS2JIX873ajoHFUebTfDBUdyJBFEe5rxdAcuc3BsE6mYhPbIGLAUnyn/2ccgDpALTOTkP6H5TCBweYEFtH8X+hDS+dGMz7g/43gGjRmEpICvBe8KZiNO/qnzVEoFdh8EseCvtx9Q2+7mBcNntHTEzPLrhxhUyFK8aRXIcPwCnFkl+1Qan2lffg6vhLrYt2Z7lohCHG8ZGlg8svreskEsGk/7Nj54ygRphZ5/EqXLXM0SD8H9ybCS7U06o/3vnGFtLQVSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Lby/dmjQ5F8asMRZ69wH+huKDwLA2+unC7J/ZCQKmE=;
 b=M8yy+r3f+Pq9/SsP9imJ+KJUJj89sYBHr4NDkVdVn4Q0aOMFvvPHxBs/ow6hkdLmHugZmUNAXrkXGlRtawcBDYbwxrgIIZglWR1tyK/eHXpoYWqLM/vFL51Y4smwuATxOQJgUeXi7YVOfdC9KuULg3He+919ydvdKFMoicI00b0=
Received: from SN6PR08MB5693.namprd08.prod.outlook.com (2603:10b6:805:f8::33)
 by SN6PR08MB4975.namprd08.prod.outlook.com (2603:10b6:805:69::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Fri, 22 May
 2020 08:36:56 +0000
Received: from SN6PR08MB5693.namprd08.prod.outlook.com
 ([fe80::d5fe:2ead:9b9a:c340]) by SN6PR08MB5693.namprd08.prod.outlook.com
 ([fe80::d5fe:2ead:9b9a:c340%4]) with mapi id 15.20.3021.020; Fri, 22 May 2020
 08:36:56 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>, "kjlu@umn.edu" <kjlu@umn.edu>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] scsi: ufs-bsg: Fix runtime PM imbalance on error
Thread-Topic: [EXT] [PATCH] scsi: ufs-bsg: Fix runtime PM imbalance on error
Thread-Index: AQHWL/XSkL9YvKr2Y0+njmc4MiuIK6izvNjg
Date:   Fri, 22 May 2020 08:36:56 +0000
Message-ID: <SN6PR08MB56932A6D579AFB4E28AFD001DBB40@SN6PR08MB5693.namprd08.prod.outlook.com>
References: <20200522045932.31795-1-dinghao.liu@zju.edu.cn>
In-Reply-To: <20200522045932.31795-1-dinghao.liu@zju.edu.cn>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: zju.edu.cn; dkim=none (message not signed)
 header.d=none;zju.edu.cn; dmarc=none action=none header.from=micron.com;
x-originating-ip: [165.225.81.96]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18a5f352-f520-49e3-a0c9-08d7fe2b4970
x-ms-traffictypediagnostic: SN6PR08MB4975:
x-microsoft-antispam-prvs: <SN6PR08MB497523C465EF90A6AEB3785BDBB40@SN6PR08MB4975.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 04111BAC64
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PzxztHiZIwPeNhqkHmXcgubspMxfgMxjjwlN1uAjefTz8/nfaMKYrcGr8S18KmvS2qgpQ6RiutiiZEVZ78qJzjIsX2vqg+ER9GHOCSBo9NpwQNN9o4PFrP8l4TN2VOv6IgQE6A/JG5nmgoghC78RaMr0E4q3PBGApxn0eT862uhhI/08c5zoXyNlub+yA5Ba2b4FMbGaruLuPvBDYfB/5az5bFs7cqshFEG8tvc+Q+bImD752BlzSyy0j81mlQ1/lmyqnrMJaVi7fsDyH9MK99PQpIF6qYFsF8ILgVrGdGGRhVqM7Hluz7jS/Ul1iCpdzno4EH4PCkkedxhvmepmeg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR08MB5693.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(39860400002)(136003)(396003)(346002)(26005)(4326008)(110136005)(54906003)(6506007)(52536014)(2906002)(86362001)(7696005)(55236004)(316002)(186003)(66556008)(7416002)(66446008)(64756008)(9686003)(4744005)(66946007)(76116006)(8936002)(71200400001)(66476007)(8676002)(5660300002)(33656002)(478600001)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: bHf3EwSvtduAMZ8H0psKukVT/9JxmYkslHf1q4NwiptAu5Kik0AmN/2byO9V5iWBmOgzYjWhLb+Yha+MkZLqhVur8OWxlaXT/ETUefDoxHOV4SAMmEBpMJh0ScCdIvsYG5emR780xWTrTvY8nPI4+XI6uxnNauWnbmliwIs1IC4k6CBHA+Yuw3hpbWGCDCy8tJFBzkwDjPwpQkBHnfOrhGwOU1yEgDDAFOqXVTKsCY9T4TH74z5e7ujvE+43FsqI5sBSTREGGQChBn4Lk4VkTueQMvVn10dwj7cn69v/jpq0XzwlSG80Bf4MWCOtiv8oByyORh13p4lD/kJLSC8Mu3V+92n5uMsl/ilOlLRw7zyUlfpPZCxMURl+GxffidiJLToyEa387Dr9hmvy/TPP0OVbMlqbm8YzbObTH/9ItgVqIyXcSzaPB/Z6u4U6VZcl1s/oAcCb7xeDOLnggJJsTbM1oqgIeomRQ92YwWSqcDE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18a5f352-f520-49e3-a0c9-08d7fe2b4970
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2020 08:36:56.3749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3a0OfCmGB5F3jrCieJV32FSK3Fun0D/ihBpxaXdHd4JJWOla50gDj+Du/PDTd82DLacOD/cPlJhxcpixnUbAqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR08MB4975
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>  1 file changed, 3 insertions(+), 1 deletion(-)
Hi, Dinghao
>=20
> diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c inde=
x
> 53dd87628cbe..516a7f573942 100644
> --- a/drivers/scsi/ufs/ufs_bsg.c
> +++ b/drivers/scsi/ufs/ufs_bsg.c
> @@ -106,8 +106,10 @@ static int ufs_bsg_request(struct bsg_job *job)
>  		desc_op =3D bsg_request->upiu_req.qr.opcode;
>  		ret =3D ufs_bsg_alloc_desc_buffer(hba, job, &desc_buff,
>  						&desc_len, desc_op);
> -		if (ret)
> +		if (ret) {
> +			pm_runtime_put_sync(hba->dev);

No  need to add pm_runtime_put_sync() here, you can change "goto out" to "b=
reak",
Or move original pm_runtime_put_sync() to after goto label.

>  			goto out;
> +		}
>=20
>  		/* fall through */
>  	case UPIU_TRANSACTION_NOP_OUT:
> --
> 2.17.1

