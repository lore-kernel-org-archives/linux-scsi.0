Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8525C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 07:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3DF22073E
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 07:48:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RtDb5HKf";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="UQgkz9CF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgGFHsX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 03:48:23 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:10900 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728711AbgGFHsW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 03:48:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594021701; x=1625557701;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=RtDb5HKf1/n9aQQFcP++TkSK+7zbni9Gv5TXGEFXY3z1UrfViu08Gqi8
   k3khh30Sd5YajzuYF/57oxTere0maO5bWL+j5pEo5iUyXG3xWoKKsS5Ts
   D8GOuCS6X8eAPZSxL9/R+XCxmis/SWAKIenldh5nwuQWTF5X0Cj7eRaXh
   1KNg/Tu9oXRXkluvqHgzPxSqd8oOkfmJn7O2NfBA8OXK/EVGqke56pKaN
   Ck6IfTt0SpzNJk6lSS4w4cePiZ35dL7dpEB7X+enPdhJ8m857sqaD5x6D
   zJmboV+yAJhEqSvzp7dx8wYdRDLOcxI/hVTZeTDM7RDM1RMpkPx6tVu+k
   g==;
IronPort-SDR: aRApXULcoVpOkPBnzcEQQ1p1GR0KaFrTGuCbjsSYvaN2RwPfACdf/On9EDZwIQNPXhyLE91zVS
 ETA+Smh3KUZ0OZWihZVU5L202x+eGdMi92clYb0HI+paX+/DRp3+QUERPBQdgu2Wxj0d1EiFRZ
 gY4Ad83M1SnbfuMYaAYZYZExh1XlpKstrTE3b5n4F2Z26p3Lv2GF3q3Eu3IGScaF9dJL4RjrcO
 xzrRygyX+30oDio7jAftheZ9V3cIOGu9X9c/J4cMw0FEzjk6uEIu8u7OWJ1Ce0KTSuqLySkp5m
 aYo=
X-IronPort-AV: E=Sophos;i="5.75,318,1589212800"; 
   d="scan'208";a="141716434"
Received: from mail-dm6nam11lp2171.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.171])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2020 15:48:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZzWxSTP1APpmXpY+Z5JJLfAJiTlW104tB7CdovVSAe3GEOYlLoIr55SxbtlyxVfjAjVHpSf/TYPiV+b8MbXvKBv/ke21uM8CGJE0tBqkxul8gZu7sbVL+m7rkQGUCErBoW49rQ7IWJz4SQXpiV2hZ5nInVCzbiqUro5/db29jDtfT6IC/DLvsG8fPcEB1sCL3UGHRmdzElwiYbPvIBrF5pk5tWv0l365PtwS72HM/lXEVOssYCvGwcFlBUbpq29R0tIHRbRPddVs8ot6k9H1X6IS7cCM+IOyflO3RwREP7rr0Zna5+asFrNne/7HwvnNPaRUbVlBGLVFuVyuZNK9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=GppD7KqRAu8X0ufjI4XJjTfuuuoxGJJKNQ0MOmP/AWPIjZ2IGHJkZ+dvfpDiwh+S7jU//JshETk9NGss8BpCRN41yJxyWlne4DekO3p7VAtsggRVPXDGyNaZHxb6iaT90jZ09p6k1F40d+CmCMthX0B7uOHjXRkDgPbmPinBvL4qbNrxeWGJP5ioSRRWtuBpVIRpBjTyW2vDEf+0jMYmOZGTPYKeXJGnRPzfZUHr0EFNQdzcpBSkB5ZJ6LetnFaSsbHb5K/6UXiTqUbk+E2iFSgiiP5PFCW9C1LB0ec5BWho48b3VnFZYmvsHe4Q3YHx35OTA9yMOvyna6JxXttxoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=UQgkz9CF6Rfk2aAyFuRSo6hXc3jcqBK9FV+AbAiHlDNWeiHMLJMiKZH7tC+2dhNkFJBKDzfYFX0T4Rtf9P8Y8PtPztu0PItRFsZx2wp6QC1o0+sd58Bgf1mmPpNqct2EOByrup2FBirt1SfIrwsLQ9s4fr5RdL0js8HayYFZ5II=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB5167.namprd04.prod.outlook.com
 (2603:10b6:805:90::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.29; Mon, 6 Jul
 2020 07:48:19 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3153.029; Mon, 6 Jul 2020
 07:48:19 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mpt3sas: Fix compilation warning
Thread-Topic: [PATCH] scsi: mpt3sas: Fix compilation warning
Thread-Index: AQHWUykWYGfOuNgevkubiG9oxqOyyw==
Date:   Mon, 6 Jul 2020 07:48:19 +0000
Message-ID: <SN4PR0401MB3598E80837DBD8A78B8637949B690@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200706000450.358443-1-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [62.216.205.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b65f7595-d84c-4bfb-0604-08d82180f37e
x-ms-traffictypediagnostic: SN6PR04MB5167:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB5167091F1BDDCD32790ECE239B690@SN6PR04MB5167.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 04569283F9
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h7iyMpNgEyY4aMcaFaR29ypzCU0105sMczlAFYkmXDg5ac2Pw04eDnIj+Z3VVtS/9sbetZlCWWwDYk81tJjOQnqurv1xLS9DzoFwHIul0BlmSpPY5XFi0ljFb0nW0pFmQuRQsaveacc/b/sDo6L+98n21NvQCqs3XhYNORZXceaPyF0LVHeUyZekScpCrIIIY/0iDIV2tHR5q3OVGPZIwAXqsYcGaO9iwATKi1Oc0EKDjhCvkiqGHim0A+xOXhgIar6z2lcH9HLE/HY6W7SJGnXidxyxI2JEjNTSKIZcVnELBIYAShcdUumU/AYnyM6XM4wmzv3DtlWYikD1nXUb1LlbOtphbv25vs0NCXTMH4+JiOFB3JWww7KLa1eRYoVt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(19618925003)(55016002)(26005)(9686003)(110136005)(4270600006)(8936002)(558084003)(2906002)(316002)(86362001)(8676002)(5660300002)(66446008)(66946007)(186003)(478600001)(91956017)(33656002)(76116006)(52536014)(6506007)(64756008)(66476007)(66556008)(7696005)(71200400001)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: pn5M1o5KTSSXnp1wpHVlLBsKky39MwvA3IBiwAPdnT1DEWdjtfKNl8wOQviN2AIiRNz3hHn5+n92Sm6hxf2QgQj2f9AsnQE68IXxyKia0febnYq9dEftIrKjEdConWDvfBa6Kwc78BKIlL3oTiynqx0eUp9Snhb4MoHc//kvnEHdYz9PTK2oAznLEdS98SVIJob+bxcW7calkiUXLr6Jj378KAcUz49/BmhoS3sEIlLMaQNXZFEJR5qcThMMtraWmpsfyYJE6WLTGqSjciFDkfS+XC7DLW6xyktrxKc+LYIppKL08QKm9FTa4Qki1P6UrDNHBFoAdVr6LVjIP0z4M+WLA/bmUbGyQ7nKjNNyvxA77JhDmh8vtGO+aKYoFe6lJ4A5QQyF6s36pOBtHWD+G4INCZhqeoFqqzkCWpzOI0LY+UJB8408Hl+JljkVwTxwevmz6CE3EsTgreWULY68NRpFxuhTs/4Tial5c6kPOJ3+THq6URns2AXBs3+xGA9E
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b65f7595-d84c-4bfb-0604-08d82180f37e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2020 07:48:19.6739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YbPUC/lJAg6Q8L4/3v7gyqGHqfIptwcpZ9G1VCxHNGP6Lngt0pw8Z5NwBLdOjFQpkhFvvASSjx9e/KWffRcS8ts1bzCtJmFqeXj29kPMZ68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5167
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
