Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F079C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 07:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2B1B20760
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 07:22:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KOJQugDP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="EhRnCjyY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgFHHWU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 03:22:20 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:39803 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727977AbgFHHWU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 03:22:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591600940; x=1623136940;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=KOJQugDPgZjNzqqPAgO0OHX88PDV7s6Qu59NZYdF0AJVKVSGtJwJfUND
   +Jba9v3Ksi43cKtzSo7iyMcpIEkMK2508l3TpGJrjBETeaMuJ62siO46j
   ONHUMRrO3lDq4ctINmEMCcq3a+YYgkODmU4c8JKaSxcb331zIdBeGex+5
   OwKeCo9pJhA/s4LELWnLYicxaA6YDiiCMBm58TsmReHqYxTW6yKO2X4q+
   msTixxl28Y2h0b7XxbsitV7BZQqvW+UCxYPW6HRrkvFdmw6uVncv3ZV2y
   G8YoCZBRg9BL3aOzfkCeQRAJ7wBbxw9l+2eO38nohFA7wt9J9+hGnbk7E
   Q==;
IronPort-SDR: gOTav8qhNVEEX1vtRbHyR+MZ6MGNsZBn+5clOan+vmoLd0rbMVkagzmyRBgJYKEokrb4vcEIDh
 Muh3faEPNbzAazQP7H74w/bfY0yHf7Ib7I1uNGqCkmFGAVRvwGnZzyVCQftkyK3/CViXBJajuP
 c9SGBam3wPeBvYYtAFlnEQ1V9gE6uJp9Obs62DVzhS/mfKQIHNipCvC4xxyn+/OMcvb8I2wJFH
 hfaliJ0i8CCI+HGv4tyPSn036zqQbH1Hdy114GaY+gdRU6Y3uA+tQfQNiXnei3hXP/NfQih9YL
 AeU=
X-IronPort-AV: E=Sophos;i="5.73,487,1583164800"; 
   d="scan'208";a="139733362"
Received: from mail-mw2nam10lp2102.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.102])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jun 2020 15:22:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D360nOUWz10i2lebpE4yzJgzJ4okpSMHw1oAxuhe7r8bBU92ZLtsTZA5p23jcHbIzPOBGL7MUPCAX0TSuZn8tl5CGOqVe4jTSObDbsWx2Fq8yzFDSoQRnbRhWXU3V1B5Ej0qEIDy9awDVV/IpNXOoiHisHTLKaDXjBOCbW23aiHucq5NYAtUjvKG9OZVMiBcMqC2254VpCoo0KdZfHrdKdMZpbJtafs2zLcLj4KwcdHBucz3D+hBWbr++h7ifuF4ND4gEjgl09Pm2GouTgv6jz6tU1kTLs4qWpileUBjPxTZ7UNQAiy/YraBI0NWZR9zxkZOtEQ2bzEnkdOaqc5dkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=hAjMpQ6qTEgPCMxTnUs8BS5+J70wLZSc+BcB7yafuy8pgUG3dwlAmO0TyzosXWIArNwcmJQb/AknX72tHllzeyar58+GUEzcYe1S8riUWtJRjMYLLsZ6+q22V1Ar96CODJcgRodEbUyO2mDx7peSkLy1ssGosnYGzC/SBE6ul6aLPeXwY7CtNdpI95f+aicCrj+bxeWqjw1JNQkqrYlAdS8VwM9h8RD6W72y3jWptQFhd83zlf3XDfXcLRbH5nli2IZTnoLWKbgtJiD7P0i1ZcpeE/5uQBHfSNM+NybBo57dRIAsMI8gWFt9zn6lAl6kAm3eUeJ/hlh/gxMc9vHlqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=EhRnCjyYZxAgwkDMxN1vj6NQmyb+8MK2cayBowsryjLbbJLo2Th2rrQDd8BHp41bHv0utKsAnVQJM+cw3ChLlGlxrslsoCvpn4Zdd4MEujkCP3t3qVjSBIVpAXzxmhSwGTctpsbUw8e0Pyqa/If7LF9nFrigdNlbhn1HDdYdcw8=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3534.namprd04.prod.outlook.com
 (2603:10b6:803:46::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Mon, 8 Jun
 2020 07:22:16 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3066.023; Mon, 8 Jun 2020
 07:22:16 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: Use sd_first_printk() where possible
Thread-Topic: [PATCH] scsi: sd: Use sd_first_printk() where possible
Thread-Index: AQHWPVF0zfth1LNTpkaD5dCnGZPIVA==
Date:   Mon, 8 Jun 2020 07:22:16 +0000
Message-ID: <SN4PR0401MB35982048436A275034980ADE9B850@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200608045746.1275523-1-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 691cb59e-e97f-4b59-4bc9-08d80b7cac46
x-ms-traffictypediagnostic: SN4PR0401MB3534:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN4PR0401MB3534B1ED71C5B2204CFC230A9B850@SN4PR0401MB3534.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 042857DBB5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MJr1ke036igjCCD6YNI71mexEZb1rSJVWbZRp6nxQkn02qSImO6Nwrj/+rTLaqXSQgKUy2fjgBVRXNF+PJtKE4C1id+qzVIxfHG2HdyuhRZavK8ltS1teDyCOTFC06qBDyhfEHbM/uqie2O+Qp5SAI0w5nzpgmIaiSrIgKkYBnCpfa8YLlhwyut1Pgo7wlEKhGJcPyPaKm0ZyX+oV4LNjsGEHEItJ792+lghLTmmwBM1FE1XZd9kO7WJCC0HJc0tURGHIGlWuBQg8XbXlbPiu7w0qV+zqiL1DSZdrQcRUHtH4sTbyexKro10vIUTSGYkHOymY1lHukll6iaC46khdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(136003)(376002)(396003)(366004)(8936002)(6506007)(558084003)(52536014)(86362001)(8676002)(5660300002)(26005)(2906002)(186003)(71200400001)(478600001)(9686003)(19618925003)(76116006)(66476007)(91956017)(66446008)(110136005)(33656002)(64756008)(7696005)(66946007)(4270600006)(316002)(66556008)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vkamyb4V/KMbokDHUurAbx+dc5Io6w/bd+yUzdg3Pq5TRelQnqw8wiNW6ARIajTdH96aDpXpGMXygXYcUYg3HWoEDwU+3G+zEpk9OIbwPqsOWVptycUXNWtHFs8yAbxLsQZhEDi9Usd7yS7GA0Pb6ag1CnEi15KxWcaT34Ql8JRjjKHDZCxYGW0riirFmkptgnDfYcoV4ai5RKbkipvdxFq484cDLKq7ePqKt4v9a6EAD7BCw8ovxkqOG97Nye4Mbi2sEkEmTB+lIiHNFCEbUtcYj+QmUHkNLq8bDjG/Zwp+/My3pBRAAvtTqEqI5JzsQcPcVlQBS7fazsEew1GP4chNL0HolEjtKlJED3CGhcVXDhHItg/DL9vVx8K991voVFIFUfY8gRLVC+VxebPzbC8Iss1eLGW76s/kZ+shm9elL3vQHyrV1JePo8SmUSoLr+2wBRD+qGGbnsZPpaoVKY3b+Cff5oakBv7T//XHV14gq/3LcaptHaOBYY/IujGV
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 691cb59e-e97f-4b59-4bc9-08d80b7cac46
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2020 07:22:16.5854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9MS2TYj47keuvhtF8mhIulC9O0AMRRJ8GlSGfxfUrLFmR26mcg5vCgijRyxbaCRG8VYq7dHqJpR4Z26pGL9F+9iaX5wCUy0u/3w4yiJW04A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3534
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
