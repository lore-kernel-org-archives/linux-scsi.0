Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B225C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Jan 2021 07:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BDFF64E25
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Jan 2021 07:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhAaHSy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 Jan 2021 02:18:54 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:47888 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbhAaHSw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jan 2021 02:18:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612077531; x=1643613531;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kVeLRiqpRTJwdzw8PHp/2trgTg+VKifYwhprFXSqZmE=;
  b=pnoT+04YkjcBKrhSY57/B4/d0gdaEtaXG5KbQXC5Q93TMEyPDqkOBtKW
   N/Kp8YjPk6QN8tzcqAGpDLYFDM40qk/7Kjad3hzUVBm+53MQonkix0uw7
   RTEggjL2DWeaEvSfobgt8ERyGpwHaHlzyg40lfFQ8iQuC1wE22tJYBllX
   pXrumpYRfIjkWUTKP3gJFSAwOPa9TFdIAApPYs2Wxcq/CnAt2Xpee89qo
   9GJreXl0WKKswqNN6T++R9iLFe2p4qUWb4Ldf3gQJhbC7cPEIboaGLJiU
   FrFtzPqh57Z8biLTlYF8xAo9/8apVldwWyGww0y4gTstucLk7ael/bkjv
   A==;
IronPort-SDR: DRbJGk0FLzKR/3hPOLFdVkPowsBSZpCNMFJfRwpm3XNkL3QjQGtZhs2CY47XxuSB48BmjgRfAj
 4RdgJGhX3W4n/pJCV72L6gtd1pi6C3m2kzG+IMPoUnBmyCVJLSHLrM6luWVkxeh2XZ+31EJWKD
 KXQWHpgbJIO/T7UvZcKVNqycp/vCSVLtH1EvbDjyiVmRgjMAW9YiGSUoIctPvmE/P9EJjO7NUA
 E/9bXaKifq3NB41gK6EDCiLMUMubt5LWT2d/AvlNjfOSX/Sen1qNLXOFLzGRL4YApIUxO+MHWA
 85U=
X-IronPort-AV: E=Sophos;i="5.79,389,1602518400"; 
   d="scan'208";a="158727567"
Received: from mail-mw2nam12lp2040.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.40])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2021 15:17:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=doD8TdVCnqiPvQ9101cm+brvASuEveTZ25JgwLxsmWl0G8XqeTIA8xShoOnQFw4yEAX1SRTfLNldgps+dxh+x9qhmRPrKERtP/CV/T175ZSx2dnMcnH+LGSOb4ynX+D+YJHj0gc7ZQmWCdpQMcJuugIpnsUZpXF4xW9wlFQn1+w9mRMrKGC0Bo3or6BR09mYTCqwbrUq22fejeKijrcQxTAEoTllAlUbFN7NOuW73gFRMwd3m2RLXUunneaL/pcq+MbkoHLWQ7XM0eAXgdQN6yYQmSmYksdIXkneBpnu8HfIJ9IgzzC/sftAyQmrtbfDpRIUN8ggbkXv9b0sW7kfdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qmi1hX2RX9A9QC/z0oCh1YoOZPRpk5Q8aoxpJ2hHxFM=;
 b=JGAVdU8Gc9N1H8bDC9/x7lEcXoNE1vLrv0eTHeYHGpmwru1Y6fyTBuQBDEUWnNVgnKnNWb1Ut/YG1mrEeRtwg3uJTJepGMJil8i9ADxLa1PropT3cy3LvEjcj16NsegDmeYAfW3qi4O/vV4I9Pid3yyhA7SkMNLTpulYu37LxgPjMYHNPM7s/OEGHbITphEanYIKcwaimlTiq/4JoBx6NP2Wqw9ta7ainCBzrdaS8dLBN/UEttSfIePGKskmzJqIU1X3XTURs+ESOqn5dIXbm/iaBJQCMUdQeP/5ksyCqEyfDoT3s9sQiGhi0toxq/z7Vvckb2T910V0eki2VI+owQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qmi1hX2RX9A9QC/z0oCh1YoOZPRpk5Q8aoxpJ2hHxFM=;
 b=woXcrb+QkLc4U1EwymIGN6afcHjMYL0EkzFy2guZld+jp+zaPbCcjvLsy9+yHTqHCKJA54ecRgKsTpXBl6YxXNKPBNiJiCNKVeZ6dYu9F28cmY/Xa5gyeGDs1gTamT92yNDUIPnyWmLU8dQyxctg5utV95ZvXG8k594Ovr/XdWk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0268.namprd04.prod.outlook.com (2603:10b6:3:6d::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.17; Sun, 31 Jan 2021 07:17:14 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.023; Sun, 31 Jan 2021
 07:17:14 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH 1/8] scsi: ufshpb: Cache HPB Control mode on init
Thread-Topic: [PATCH 1/8] scsi: ufshpb: Cache HPB Control mode on init
Thread-Index: AQHW9L7nyZFYPn4n3Ei9SDx+7JRxj6o7liWAgAW9V4CAAAQJAIAAAHog
Date:   Sun, 31 Jan 2021 07:17:14 +0000
Message-ID: <DM6PR04MB6575FCFF50C07C2C37C612E1FCB79@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210127151217.24760-1-avri.altman@wdc.com>
 <20210127151217.24760-2-avri.altman@wdc.com> <YBGEh4cfPldXoQxI@kroah.com>
 <DM6PR04MB65756785F53B6D9FDE581013FCB79@DM6PR04MB6575.namprd04.prod.outlook.com>
 <YBZYfM/NjTo1lbGi@kroah.com>
In-Reply-To: <YBZYfM/NjTo1lbGi@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 14020a22-8d6b-4643-3d09-08d8c5b83bf4
x-ms-traffictypediagnostic: DM5PR04MB0268:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB02688C59463214F4F6EC5EC2FCB79@DM5PR04MB0268.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C6nwrmRFtsWx8gK4NpFQ70qGIzWKXXSku2hQ1dAfiyg3YUiEKJ4g+7Dz9CtgxSjc0If35bMq6w2tf1A/VvPlOEzLpkVWrII3Ris0n2RfKI+guGsGRnMvRMNU5pT1EVQNTaZMKFVTG+9mV83NfiT+Z9qlhr7j5eQVE9hlV8CX6BZS/Clozv2yf3ceOUBqfiohM/0WDAiVNbbkhhSPkQpw1G1YDnajy0ZU+ouDBFMoqPoY81lfH3kvdBdcFsO2ogB4Wq4y4ycHAWJCLn3aDzctvtobrzauy065k2ZyhxR+Nr6IJvf3Jq6W8WHtqBevHroeVN7tZGpZgxecgz2QjDpQ233SBt97zqiwJCGMtEltBPK1wFnyaP2ksK/5NHNw7s57qnNs7KWlwWv6WneNg8KhHlCXy2ChQyqpswYSTplArthPX/QxTzPKDpWEKKQUy4D/7Vi3NxdNMbP5zMlNep0wJR6BYKIDegHpbkoo423knN69t+Ek7qCp3jCZX0xgRx1q++QLJ4jvEPtTv2fm5Ps0sQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(376002)(366004)(346002)(136003)(7696005)(26005)(4744005)(52536014)(33656002)(8936002)(76116006)(186003)(66476007)(66946007)(8676002)(66556008)(66446008)(6506007)(64756008)(6916009)(7416002)(9686003)(55016002)(5660300002)(4326008)(86362001)(71200400001)(83380400001)(478600001)(54906003)(2906002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?VPc1p3fxoBivOTvYF2epSCIp8dcQw0aHugD8NYRu7h+2yGToedPxd+pliqvJ?=
 =?us-ascii?Q?LWIpdEvw8ZiJ0DtOT1i/iLVLBAQH77p9Sl2kxSC1pOAJdC1op3M9iLYxU78Z?=
 =?us-ascii?Q?eU1OmEU2fD2oXcEsDqxZc+3z19rbZ41JswYU2vwwTdPYVBpneimYx1/Dl5tW?=
 =?us-ascii?Q?Fp+CcgRmw6S9XClAbn5odUaEM/hf55mdjOKeQNRWmxu/N6zk7eVM7Wni9Wev?=
 =?us-ascii?Q?9Ce68YOya3yeEbxVQ6LVT+qQFYWI7kHQCuJQofmhHeQM8xhAi5gJBTKY83Ra?=
 =?us-ascii?Q?q+0GpNAdIwVNBuu+r5rreVAPhJg3RghxY5Co45g2UyjMajWznaEAzhJ57XJY?=
 =?us-ascii?Q?1qkIv6dSrX/kDf/pY38CAgXPQ60a/p2hURqPvFHZg/YjHQHCa5K67kvr+tnH?=
 =?us-ascii?Q?oPPAwkM1J6br3b22sZafMKr/JlXLOOOkqSfFQAPnn391dvuReXyu8ecg1MZ/?=
 =?us-ascii?Q?JeLAnxrv1uevtY5fCOj7QRHPtj2cqgddsmd3xK5yVNQb5qGKmFq82ybBokv8?=
 =?us-ascii?Q?VVoBxMH7qg4K39rxNdi3h42IDP6dG1t6qe9VndqrfL0RPtTszPzzBDo9njkC?=
 =?us-ascii?Q?+X9bJgvNYUhwLb1ddDRpc3DLWZStS2lOfbPab06XeZ+yqYQd1tfB4vLY+ep/?=
 =?us-ascii?Q?YAzyjR4vLvY3jj7uCHtTaCHyzEGyBqTRHRi47muOWLKPH8JGSCbVemPJsfeh?=
 =?us-ascii?Q?go3+Gd9hkfv18PYPYHKF3FL6nEDlpXBR+VMur8usXI9qgIlWWCSDQOESE14g?=
 =?us-ascii?Q?SJWYtANeXf0LuRiztKxrAY/Npte9RNtXHlAylrjjjdkDdWQbzNeBP1gVw2b/?=
 =?us-ascii?Q?DGilgvewdfZzB/s9iRWZUW6klb9DbPycCOpwjTcpkEzyB4IlzRo8gk+1Zkwa?=
 =?us-ascii?Q?YWfj7eGTlT7+A+sk9dUi5kiQzoHPrQrB95HA0Ajyp7dR2gtDKNxOsXZAG8pJ?=
 =?us-ascii?Q?+fjpwZK2lGbtiDqZ0dX0tE0D08rs+O5uJmnBJyiqBSrzY+4RJn2VhIVkAhJz?=
 =?us-ascii?Q?AJ9A52q2Z/XLste2WW1/B8cHjif5hfzfBneV8P4ryZz3Qk+cWbvhFqX+6PwP?=
 =?us-ascii?Q?eKV/Mgac?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14020a22-8d6b-4643-3d09-08d8c5b83bf4
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2021 07:17:14.2854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mvke/FbdbAU+Ll/bWrALqiwBMDADMULcwEzRr9m3UVGFQiW0HBZHE34LdfM2nkN72G+eMRPEIg+smLp97a0AuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0268
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On Sun, Jan 31, 2021 at 07:08:00AM +0000, Avri Altman wrote:
> > > >
> > > > +static enum UFSHPB_MODE ufshpb_mode;
> > >
> > > How are you allowed to have a single variable for a device-specific
> > > thing?  What happens when you have two controllers or disks or whatev=
er
> > > you are binding to here?  How does this work at all?
> > >
> > > This should be per-device, right?
> > Right. Done.
> >
> > Not being bickering,  AFAIK, there aren't, nor will be in the foreseen =
future,
> any multi-ufs-hosts designs.
>=20
> Why not?  What prevents someone from putting 2 PCI ufs host controllers
> in a system tomorrow?
>=20
> > There were some talks in the past about ufs cards, but this is official=
ly off
> the table.
>=20
> Never say never :)
>=20
> Seriously, how can you somehow ensure that a random manufacturer will
> not do this?
Better let the platform vendors answer this.

As for your comment - you are obviously right - I will fix this.

Thanks,
Avri
