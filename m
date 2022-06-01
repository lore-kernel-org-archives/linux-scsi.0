Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3088C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jun 2022 07:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350240AbiFAHQ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jun 2022 03:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350659AbiFAHPi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2022 03:15:38 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902B5A007E;
        Wed,  1 Jun 2022 00:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654067722; x=1685603722;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Vet9z6DGvO1FwMZxk0iOkyO10fFvSfdI7m0de4s3PHY=;
  b=Gxt4AnM5MJylgEGBmvPoBJJUsBhhJJxB7CO32hXMYK6vSEpac+r/vZJX
   /ThZiPLlN8tvBWZ9IPWLvY8Qq0QMNnmuLZeErEvbrKs7BzlMeN+QLUo7P
   OZ/IQINXXnfYby6CZhTD8GvWMucbFICN2bFRejoq6IeeBtaEmJf3D5wE8
   /Muzp88d8MyyEiAlm3qdufLfDyaYMvx6P8h6UHoHo0DHtScIWazTwIwSu
   YF9eL0wne5nYv0QOpx+WpK4Rpvzc+NkeM8jESb4OmG3+aFpt/dSWZVTJQ
   DezyNJFsKcMxM31Wsa17gwUYNVHy/jSMnmnKjqwOnvUN4DE/SdzTdij57
   g==;
X-IronPort-AV: E=Sophos;i="5.91,266,1647273600"; 
   d="scan'208";a="202767320"
Received: from mail-bn1nam07lp2045.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.45])
  by ob1.hgst.iphmx.com with ESMTP; 01 Jun 2022 15:14:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AenVSmqfwYWHOYirPcY31mDvvhP/1BezWyXsV4H1+vg1FOfkTUXPJHGzfOYK3Z59EvzB0QuXx+RPRqlHZaoIrZwPbR+rxiITjPY/ENwjiUePociPmAQv7dgTSt8OvrQ1iqXzMtyyYLqwPb36j+gxR4nZ5a0fUpVnM9fm70aztzNXRF3StmLrUpptkgW/U1aVETK4b00ff+7jiPGwvd/ORP6OPGlpDj8ywqWcNFNWcNKHq426QWgHek2y5oKr9IPe5Dt/e9jnhU48zLIiLVzpe493y+CZNA0oghbcbjZs5Z56gO9y6k4Hv3nw9ZUqzsQ14uS0jAIo5bYy7CDFXxOz9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yIPestiu4W6y205ZPRCLHAbNaXSG+pA/3+Dpo59fkIg=;
 b=EfJO1kJ/6VR2IqW0eGp6SQiceebTYpY8SH7uoV56GGRiTVgJcPFzfDf+ptCvlyq/M+qnfaHoCIe/PmOtdILv3InTEO1fU4oHqK9xYo8/9t9Z1puJ0Ox90ORe91IXgcEApmlyysufq7SQsI7dbBcELJOLHoFqzH9rnH2/0d4alNexn5BUhxMROe7ny048EmsxAyHn5/GhzVo7S3mh+aQ1wAPCuEZarzyxWaOCRID8oXQXQ5gmaze6ra9+V1AlSBlE/caj0afzhPOWHC2JMCy/4s/tiaFUmgND3+PyzLSMf5woI33bvwSp559UKNQ3eoU8PVlKJ7CfH6PF2wPdE2nRuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yIPestiu4W6y205ZPRCLHAbNaXSG+pA/3+Dpo59fkIg=;
 b=nSqy4E/Mmfx4o3yXAR6cyoy7b3CpTrw7XUgWFV45TLcYJ2Q0oJsdp2DOqHSgibFdrPD+5DUhVm++3+JVHZ+5fmZU2u4mb2izPbSwa/2w76oRLNJSp952CmvzMJ6CUXt9IwyW97pWj4+Vc77N271lWF62sksFYvah13FIULyPv6g=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MN2PR04MB6223.namprd04.prod.outlook.com (2603:10b6:208:db::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.18; Wed, 1 Jun 2022 07:14:43 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::cc4e:5a1e:e4a:e3fb]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::cc4e:5a1e:e4a:e3fb%3]) with mapi id 15.20.5293.019; Wed, 1 Jun 2022
 07:14:43 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: clean up ufshpb_check_hpb_reset_query()
Thread-Topic: [PATCH] scsi: ufs: clean up ufshpb_check_hpb_reset_query()
Thread-Index: AQHYdMBDNTBKeyL5CkK0kxxNxHcot606FaFQgAAN9YCAAAEokA==
Date:   Wed, 1 Jun 2022 07:14:43 +0000
Message-ID: <DM6PR04MB65753C340472FAAE5D2E81A7FCDF9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <YpXD4nLc4iCxpw91@kili>
 <DM6PR04MB65755C66140BDDF550DCE75AFCDF9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <20220601070933.GA2168@kadam>
In-Reply-To: <20220601070933.GA2168@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 64559600-f025-4239-cecd-08da439e66a4
x-ms-traffictypediagnostic: MN2PR04MB6223:EE_
x-microsoft-antispam-prvs: <MN2PR04MB62230E8ED98CF681E2ACE5FAFCDF9@MN2PR04MB6223.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qat0Z4o1GcNHUUZFSAxx+h6Ly8fK2HTYl3mBhA4+z7/3UQkeIxxBuOh0aG5YVggzJUpLqlw2kh+qbE23aDS+yMnW48uPMnEMWldx/r9C0/eSCyaLGDHLpCFMNaCYeyK01IoGSu8qCCBKU482GQoYhi/bEKhld5uvGtapYFYY9nBpFLsbnBxwMvPhSnyNsQxPPbh4RRca1j9l295VaksoEDQfTlB3APtSut9dBBjjd4mJZltwZfXFegD7yJOdK9mcnWPhqPsIk8qMqXWVed47mVCEPU1Hbo/UVgUgty5DfpseC/AeoPEpEqsZeNolfRhyzaJLFvBaRlDjjklhbnPY9kkJ1cA0SFw61fcrIJ4Chev5FEOQ8/hG5R8z71+YV01k5OOPub1AD9lgBJdxbK2wifVjC5e2gwFRRqvEoX6s4uwCFUwsnEF8ikwcr1eNEwJvMkQbg40ETDfQaJ4CBTnnQDKtxAbvOPUyNItzUln8YtqRYmSew79JsJNZVphlVuialbdD6DvHT69REoYQgw3QN7mluJxomAAtRk+hvEwjfpLL4o53xACT7QXukYOX/rNqfYxrMmp7ZapCpE3XtlefSPLDLGT/MP1k8MexAKYPov6ISQPr6/HpNmb6C9nnwl92zXvW/JT1Gp6DIfDuYKvmlbKuOEUTC/8P2czFnNohPXLQ/Pw8eDmD0H2aBOoY4PGBnwrh/agk8QzQERBWkdJB3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(9686003)(76116006)(8676002)(66446008)(86362001)(26005)(64756008)(66476007)(55016003)(186003)(82960400001)(316002)(122000001)(66946007)(66556008)(38070700005)(4326008)(2906002)(71200400001)(83380400001)(52536014)(508600001)(54906003)(6916009)(8936002)(5660300002)(33656002)(6506007)(7696005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HAlyGXrsub7evqLVbCtZtCZ+bwOFFECE9uJwhFZWlct750/1Evsljyp2V9T5?=
 =?us-ascii?Q?vjl2XlR1fVLZAh/3KLC/tt5o+IRCYQSHGBx2Cn7Qgum8uP+mtMXBTACedD0Y?=
 =?us-ascii?Q?kP+7kHK46IJn5sSgBX4kkSI9bMw7aW+2cUZmACjVjezzPd6vl+S+JSSiLFvU?=
 =?us-ascii?Q?GlLF45dfto2Eqq8Xdy4zxzal+6ZkS+K3bloOH6GIOI1BOSCiSGfToI3J9HDm?=
 =?us-ascii?Q?HSPpC8z9Rf1nEKmIxfSrUpJYSTWb+AqegdnVV1AMGviFnaARHoloYQ4BE1pU?=
 =?us-ascii?Q?QsrUxDJqPxYoDJcoLtDG/sWXmYkB6yagyQIKtkGRIAciHvF6A1YarKV9QUL1?=
 =?us-ascii?Q?J1OY6hdvd5ZCHvIVTu4kh2xeglWx+yWNarVYYJORSwQ6DoTCir2SeIxbjDeZ?=
 =?us-ascii?Q?SK63lb7yy/YzA+u0Pd1Di5qu4lhWu+Dcsl5EXkMVBGNP/mpoPl7zRmbioeFQ?=
 =?us-ascii?Q?b+D9YyUlYHPN8E2bBJLVrij+P7SIICNyPtzzFTCcCP6m+uSmV84p2vbHfT54?=
 =?us-ascii?Q?H1buUlOTSw/txWQKweTvMvbhEYva2w59WjLEykPmpEuVvktA4356Zq9zD+W3?=
 =?us-ascii?Q?0FAuMmcGxKSh5x/Rf41+rH5M2/0PGAtDPAeZ/gYLI1vqXNfRV5PKc69dQXCY?=
 =?us-ascii?Q?BjBeY6u4fNPpLAl/k2XSiI7U09zoKtdApx1L4harcvM4rvJezMyls2x8rVOW?=
 =?us-ascii?Q?gVl2BbucBExpj4obYkxdTTMxq1lIG2lWH+fdUrcHUODuLtzKc8dFEqoOPp4+?=
 =?us-ascii?Q?+hRllQh+48T6KU/W3nVrv+ahGgUTLTTiJJ17P21D8daP4EWs7grin8HpcZkH?=
 =?us-ascii?Q?fYZ63Mvw2sqBwsfs8IET3pngxdAxRs2eCZshWq51aBTVDxIuLLCa8JxC96H4?=
 =?us-ascii?Q?tVrnlq4ZRpld404Gjpb3ZkDhOM7g8KQbnaS1NYwYijoncx33dxLHG5Y/LWAK?=
 =?us-ascii?Q?hwJEZXL0npGf1jITk6pdRkz6/9tZaV2JmsR/KAkeojU6Wj+offKpH822YVQx?=
 =?us-ascii?Q?gL8rIFHhwX49PSlRTYNJ9sCZ468L5mJCOTEMmNxGaVvOuKWMCy83c0nJNgPy?=
 =?us-ascii?Q?wlxKx6Hhlv4ggIZSTnX0wkTLHTH1ZiZiy3gY56ptrpMbcKk/R17E61vjcN7a?=
 =?us-ascii?Q?lyY8Czq/oejgkqDSD9nJyOk56JTOem4WpJPPmBt23HfhTTl7jlnM2DaK63Xa?=
 =?us-ascii?Q?VPe4Nmnzi8QErnuV9ZCeMNirs6qYPhpE/Lsb/rmdeDKkiG41rZEWcZLfLvXG?=
 =?us-ascii?Q?T+xsKXCxRqg2/za+CIIQt2OfBt8f27xml0yM+ywC4XDs+hnZui3MY5IP95B6?=
 =?us-ascii?Q?8XI2aJTDVZYii2ZLkO2Fjpz++NDHTfJUYgO3DIH6FQJ371EbOIlCRMY6Z26h?=
 =?us-ascii?Q?7lN+ZCO9tC5zHVDqtR4QfI1tq8rksru79Xb9BFabR+lS1rrCX/wCmbB9PmWv?=
 =?us-ascii?Q?Vcp6JOwwPSp5yyN+6rksNNG7ZHd67gepuNCgCfMzaaXKGmCPNd1Dq736jfiy?=
 =?us-ascii?Q?dP6liRxaKqa7riwu6UEhvD85Ahm0BxyQID4zMGRwbL5EltpNuUsS2ul1AqzA?=
 =?us-ascii?Q?lvLULV6JpZOTNQi39zFrATCOwN2dp+Y/gDDJp4UiMrD6LTosmOKlfUKNi+ub?=
 =?us-ascii?Q?cJFkiOL2lBlWLyvpaR9ah+/oQoswIheYc2nu8BQgYPW2/AE6+RmEQQKvhfr0?=
 =?us-ascii?Q?lNti/JTaMJh+o7LUkWYS30wnql0x6cy8mlqSrZDGyg18hEqbdaDjUKaCRkNC?=
 =?us-ascii?Q?DIOxDvv9IA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64559600-f025-4239-cecd-08da439e66a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2022 07:14:43.1848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +6K79aPcPuU+oZj6qPTB35YsjpPEebPkYryow4TztjO3SjTq5lE2/8VWcFQmVtkl7MXYqheC9+KRwFGiOv+mIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6223
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On Wed, Jun 01, 2022 at 06:25:01AM +0000, Avri Altman wrote:
> > > Smatch complains that the if (flag_res) is not required:
> > >
> > >     drivers/ufs/core/ufshpb.c:2306 ufshpb_check_hpb_reset_query()
> > >     warn: duplicate check 'flag_res' (previous on line 2301)
> > >
> > > Re-write the "if (flag_res)" checking to be more clear.
> > >
> > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > In HPB Reset, the Host set this flag as '1' to inform the device that h=
ost
> reset its L2P data.
> > The Device resets flag as '0' when the device inactivated all region
> information.
> > 0h: HPB reset completed or not started yet.
> > 1h: HPB reset in progress.
> >
> > Would make sense to me to contain this logic within this function,
> > Instead of returning just the flag value.
> >
> > Thanks,
> > Avri
>=20
> I am not sure I understand.
>=20
> To be honest, this function is not beautiful at all.  With boolean functi=
ons, the
> name should tell you what the return means.  Examples
> are: if (!access_ok()), if (IS_ERR() etc.  In this case the return is not=
 clear from
> the name.
Right.

>=20
> The second thing is that I really don't like returning true for failure a=
nd
> returning false for success.  Returning zero and negatives is good but wi=
th
> true/false it should be true =3D=3D success.
Exactly.

>=20
> So, yes, I wasn't super happy with this function either.  But I just did =
a
> minimal clean up to make the returns more clear.  If you want to drop thi=
s
> patch and write a more extensive one then I would be really happy about
> that.
Yeah - I will.

Thanks,
Avri
>=20
> regards,
> dan carpenter

