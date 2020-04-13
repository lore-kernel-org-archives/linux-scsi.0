Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A97FC2BA2B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 23:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 306FB20692
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 23:06:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="qRwL0oGW";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="L935PjfO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389941AbgDMXGY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 19:06:24 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:39811 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389929AbgDMXGY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 19:06:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1586819184; x=1618355184;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=lQ9oorcnEVfi3ltxs5xh9sT7lkqbIJYKq4dvCS1e03A=;
  b=qRwL0oGWwtLCtmmQAOC4JkDkhcyLySJlyfGq5Fj2kw/GtRITBGcbA5Z1
   ofTCUOHCIPFhxfLfoM/cz4q+HZn+ITfMnlqJE2PmgVasKFhe7fJEN5Khp
   lsECqiQBbQDUcGVYmRvIJVT/mTfFybtx3p/8tp8N8nhm1U3oRTZrb8rOU
   V7eWD44HF2wg4vNzPRQtNk0APEGjHVmUDKirTY5o0R4GinoBOl9AYgM5R
   M0htcTAqU3EU6tv5jRRKDFDrLZh3Ts2paKFLDkk62fLDmV3wThbYb8LV+
   Oh0/ea+jQWp6wwwXEvH05uc5Uak9JjLf0lsahjOqjN3/0H+PgBsvrtjX8
   g==;
IronPort-SDR: 6XFzuQdvqNSPfDFPU4k3FWGe75KDSOX2wAegUxRwVZmf1050N8nonvPaaUxj5yDiFMbJE+eHqL
 hj8Vbe7o1QlcHjRwUWYFWs9uX++G8nnMceir+degdRkiYDROj6wE4k8CIFyyVHmyk5Oe1Gn24d
 fToQxTBlPDvLlZuvE+AyJzljWUDEMQX64iIJrp5gXa0gYVgRbIWULXWwJHPkyR/WMvVoPreuPp
 3jlkSa4jFNJphCc9MDdpeRQRUn9y+uVqTdf4ne8ODi58US27Ikw9jAOnjq56E03skgoMNTiZ8Z
 kyE=
X-IronPort-AV: E=Sophos;i="5.72,380,1580745600"; 
   d="scan'208";a="243905292"
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
  by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2020 07:06:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IsWDXmdDiATId907ZEQSJ0lsH7/UOD9c8WmGQgewliL2iwbbu4KNKKd9EuPD0G3EVL+TNecg8zWKZPYiq2B5tAyMqOGCzIJNOm5H/G9tpHr2M6zlesk1ySnNaydIqpPkVPYaNCJZwhVrN9WyyGFyuw7dyI8Lcd3q355/xgVMq60HDJXFkFk6Nz1tfjt81VZGPWtb80Hzo78NjFhkO8wrid+9GKae+PlwmZIYV21taljJTP19M3VXFIDKdXPenNignUgGx6dolyqH3Q6vGemFCg79BzW48DflIfcr7VHqmNTxDaixCZWLg9ZNi5oCkI/uruSdf4WrFoFpVp26NMiYOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQ9oorcnEVfi3ltxs5xh9sT7lkqbIJYKq4dvCS1e03A=;
 b=C8iCj10+1CJBMgfXqHMCqcmW8oQ6R0ibTOdQrylNqltSJ6jK1flx26ysUkhAZCtPPCmKkEZVWinr/DsXhDExYuF91zvcGo+3IE3GHrKkI15sS+yoV/229ilaC4bTZRxX1N44SOhzM6nusd10CxwI/+v682fUri+GwPMM4ZW/XOtGpHQuNx38OQQkDoEJP2qiRGZpLwWcBlHZzZ1S8bGieVXJrGwUGHCnxhWXiWfEiWlafMf9wjcKEXs2BGbtCQTEOAq6EZ/oi5jaX4PCcDv09r5kCO8V/4t6gr1xbHRM9OWrxJ3KT91Xve3MHPXACoOrEiV1ewuC/OcHVukddf6g9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQ9oorcnEVfi3ltxs5xh9sT7lkqbIJYKq4dvCS1e03A=;
 b=L935PjfOO1hIplXW+YLWAUZ0jwvjfmofAq77aNji/cChQQ/VSNLDdk/ONwmcl7cgGT7GDLaFZXdGS00SihC4iFB6fRxdZIh4das93cw3hIaHDLL8a+IS5l0ItiTuM8CJWL/WMG9NVJOWAWAB33mx79YGUMBCCr6zoXAMg+VDKtc=
Received: from BY5PR04MB6900.namprd04.prod.outlook.com (2603:10b6:a03:229::20)
 by BY5PR04MB6643.namprd04.prod.outlook.com (2603:10b6:a03:22a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17; Mon, 13 Apr
 2020 23:06:20 +0000
Received: from BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606]) by BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606%5]) with mapi id 15.20.2900.028; Mon, 13 Apr 2020
 23:06:20 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "hare@suse.de" <hare@suse.de>
Subject: Re: [PATCH v4 07/14] scsi_debug: expand zbc support
Thread-Topic: [PATCH v4 07/14] scsi_debug: expand zbc support
Thread-Index: AQHV66Q0jOmaKf8utEaf1qVGuuBg3g==
Date:   Mon, 13 Apr 2020 23:06:20 +0000
Message-ID: <BY5PR04MB6900A558706F2ACBA6BDE602E7DD0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200225062351.21267-1-dgilbert@interlog.com>
 <20200225062351.21267-8-dgilbert@interlog.com> <yq1a73fvvmi.fsf@oracle.com>
 <BY5PR04MB6900CB37BE3A595454FA476BE7DD0@BY5PR04MB6900.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [60.117.181.124]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 05a0e725-123b-4ed7-c199-08d7dfff47b7
x-ms-traffictypediagnostic: BY5PR04MB6643:
x-microsoft-antispam-prvs: <BY5PR04MB66437F88A1DE5ED426AEAC5BE7DD0@BY5PR04MB6643.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 037291602B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6900.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(4326008)(4744005)(86362001)(110136005)(7696005)(26005)(54906003)(6506007)(76116006)(91956017)(33656002)(316002)(9686003)(186003)(53546011)(55016002)(66476007)(81156014)(8676002)(5660300002)(8936002)(66446008)(64756008)(66946007)(71200400001)(52536014)(478600001)(2906002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oSQqWwy2Rs3MbKFQ/SoH1hjUBYuzoMig6cd2v32Q9gSSFSzFDafj7NGfQjLf8hI/9iNA+pdXs4zTZzyhp0AwtELvTlml0gvWhsa+Bqss6aPLtrxqGDfSwXezsvpySUz14uE3niR2rZAlN+emPiA56vqNU7d7De/JUqbn5AX6VA17FdFEcFriQaekdjJmEVr0lgLzpI8Gq8xmHh56RXvSfv9taLaJ98yPK/PDkPKh7TRu0KUryxYyK874vEyxTu1MJiOBcedO9gxayag5dLpPS8hIYvcUws2JobimXtL1VON4OBOLxqa1lUGHP2Mk2VtWs8gKm3+wMr19OLm6laS42AkB0BYO89kB/AmTGAPbzeJeYEw2ZXlBvK592Zwf8kYU5tcfl4vyoaHdJGhMz+tvlJHyVGrrBCETeU3zDfqNb7XZbqYM2q48oxY5kczuZu+t
x-ms-exchange-antispam-messagedata: D7K2/CRxe+k2MRuKRy7DG7mulMO7G7nV1aki3f/dRthg6m8jo6FzerT+podyQmD/VoqGszSrfOfonGNjdXjvgC6k4UxnijmYA4trE2EISbdB5xaQ5aCuuedsfM/04122Ev8G0SeKW4T0tGmY8C+8/A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05a0e725-123b-4ed7-c199-08d7dfff47b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2020 23:06:20.8277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: trGL2tZw9PqdL2gyONwl95yZP6nFs8HZ2O35JZ180/PlFE+bjpJY8fNwXN2L1baVQ97i+PU6dJE5ZICt2n04cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6643
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/04/14 8:05, Damien Le Moal wrote:=0A=
> On 2020/04/14 8:03, Martin K. Petersen wrote:=0A=
>>=0A=
>> Doug,=0A=
>>=0A=
>>> The ZBC standard "piggy-backs" on many, but not all, of the facilities=
=0A=
>>> in SBC. Add those ZBC mode pages (plus mode parameter block=0A=
>>> descriptors (e.g. "WP")) and VPD pages in common with SBC. Add ZBC=0A=
>>> specific VPD page.=0A=
>>=0A=
>> Also OK. Would benefit from a Reviewed-by: from Damien.=0A=
>>=0A=
> Tested-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
Oops. Should have sent that in reply to the patch email... Should I resend =
?=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
