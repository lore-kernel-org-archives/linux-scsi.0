Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 781C7C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C1AA64EBD
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235280AbhCANAh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:00:37 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:48626 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235247AbhCANAb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 08:00:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603630; x=1646139630;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=ECEvDZIx3sqHJHM9onW008bE/u3x3HDUlLjqCamSI4qULBCTDEB6NmGG
   5U7jwFTBSr/rITDNQt1b1JnWOshZfgE/MRhy2gJ6ep9qdezTvPGuGmp7p
   NRlrAsCW69ULEWPsrEDvm6Gt7xZy2sl3zaDaRNBmwm7iNzwXP36gt8K9R
   8ey+f9MXaFOL9e6vakqLEjr4kuWmASDSfAf+w7lYDMy88qYCQPdi7+wAA
   YBUJ94WcTtlAp8LuVGeIsIqNJcMSCUCzv1KjLVCd6dqrS7/7R2fGyy5GQ
   Ko5dGudCLxP8Zeu53vFSdD6KwhW/L/l2/hm514hP62XDZCWven22kD6Ns
   w==;
IronPort-SDR: YSzbTA5FUvpZGCX9gcD3HQ/4J765WlCYKUA3lWfVyFXEF7T0xvBY6oAR3Nco4djj0c7q/YexV7
 AvxZvn02UJlFyYKuwXDQbt6HZS6ZVPweP8YkA88guPDt2346IlgHaoi3Ne3AmQd3Mj5lC+hinM
 Ly9AMBJ1Y5ugA14M+On8hrjHfR0zuSNbXitRfQYaJaR0l7m/gPd39AuHgBufx1H4ZaPBJsRBXu
 9B5YoHaTq40fL2BaV5tBKyNA71U9r9RjmGLNFaQ7cOwE78C5OW+ErzPXk9S6fuuUCJeiTIr5Nw
 qGU=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="161052645"
Received: from mail-dm6nam11lp2176.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.176])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 20:59:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UDiQHq8qVzYbtrGbHP7b9GnAzYlYvSTYce6mbhvlx38/+yWyFHDnDgxKPwHG/5eHhXz2tEq4Pbj6gocmr2rG3RWfzjt/WK6+bTeHbTjFsLH/k7kq7GVq+I2scHtV5EDlRyGqMdRuGNwW6k3bYbK4edKAZhCsxkPIk8924sLVAHDDgmMfqm+22C5I1OpRLGmn4zifOvlL10+dGpAmXtF5jUUhDMmL3mn1zkLP9Dh7w6JNFikDYvz8ugFyZgmIML7pfqXPf1f3YhKoVJWkWhIoztumFuyc7K9nI5WjwxNwjzZ2/qNSNMmlxydR4863+dwoEtr3stvTMl9yHUulaX6d+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=WFmSK446ohzrWzLtAuia9cfEOyliOLXMqk2lQBqtALnh7DhTfZq6RkVf3sv7WjnW6IO3q8lWtTreAYb1TGSdUxsYtBXGnQ1lS3JqluWpcrhgtOojZqXV15NOpLayh6PnZ2tOQH8GDwo1rlcpsPM/8+vwmULBRUXhTXjJ3qBv38Z8HY9aaxr2oWWbRpJaTcefIBuxpDrJM9gU26ZUQQAmwa1UCL3NrE2IjaIeExB2tvj2qh/51em0SiQXSDWjYX/XLKWFY03YA86HMXuvbebcrEj5OBQkg2Rvj4hcoTQk9JWy3McNNIcnq0SINEehgXBMv1uHiwqICfS5wqbabXmhUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=BBR2kr12LKY91XUpLGKtBz8SZtVNhSlaAc+a6WcM1IfKNGAXRgvb01u+O5iFmA6b73WM1/0l8wNyMLJF1MRaAdJ4m/F6tFQnonOoil0Y7khUI/4I8jR+9/3rcs7XsY6tpz1wy/XaOJpqsxNAgUMO79f3YnKlKUUOjShCe6FM7UE=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7237.namprd04.prod.outlook.com (2603:10b6:510:a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Mon, 1 Mar
 2021 12:59:36 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 12:59:36 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hare@suse.de" <hare@suse.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "houpu@bytedance.com" <houpu@bytedance.com>
Subject: Re: [PATCH 13/23] target/configfs: remove the memset with
 declare-init
Thread-Topic: [PATCH 13/23] target/configfs: remove the memset with
 declare-init
Thread-Index: AQHXDZcJncGrna9zskWnu+nxkUmRqg==
Date:   Mon, 1 Mar 2021 12:59:36 +0000
Message-ID: <PH0PR04MB74162CA2FFE30A5C031CEFD59B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-14-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 70010501-081f-43c0-7568-08d8dcb1de12
x-ms-traffictypediagnostic: PH0PR04MB7237:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7237FC4C02BAA35425BAEFB99B9A9@PH0PR04MB7237.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OK/xiHp75g0ec7c8vL5l5eb0jgL9exZbeVxiet9BpVaQ4ox12dwvxgYLe8CFoipLlubceVvDthf3Fpg/wJEA/fkXpZ+cJ0a5Q5DyxfEA83sQ9hhCEyySiHv2iV4rLu94lCqSHFjJX7Uma91YPTT71gcM2FUAqBLtIlOwViqdH08NqUKLotDnCatcP8aAhlwjAElNkxlqE3Y6ftF3KAcF/6Bzts7QZp5+oKla5gpvseXlYlz4UJ7LUt5tZHQRnMJiAHSJx9EbBUaJvH3c6oep+8hbQLm/gIa4E6Zbv0DKnUpMMQYhGR65hU9jLBBHdF+FQcXiwb9KWXaRx+0baCn1kBCm07xdPRyHTzHg5Aa8wv/zosvit32UDp5NJDWkdjJojmRU6l4vOtzEojF4WUc3VCE404xIcuWAJx++VwpnqQlu1H7ezSAnB7yANWTXuCyk5KELHsMmyh1X5PU7+HRoVk5JEp4j+QIVhCKaRtWhMIdm5RrECdMOE3A0vZgMusnqS5D3zKHU3LciMx0ksX7pRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(4270600006)(71200400001)(7696005)(54906003)(478600001)(26005)(558084003)(186003)(316002)(110136005)(19618925003)(4326008)(52536014)(33656002)(5660300002)(66476007)(66556008)(76116006)(66446008)(8676002)(8936002)(66946007)(55016002)(86362001)(91956017)(9686003)(6506007)(2906002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?IiLLHf1EDnro+F0zgoFeCcVIemNdo4FFcaOriwqxYQChs257zxEkHkfFZUSs?=
 =?us-ascii?Q?KgJN8APHiat8lIsK6DzAuSOhg0EQXJFJ9RV/7xyuL2pfd8OeHjtcuw3DbmSG?=
 =?us-ascii?Q?JoqVEj2rGX3CQc2sx6bmQJ/LcRzoMNhYxWBYBS3D4xjeCdoSVt4T4Hg4z/Xh?=
 =?us-ascii?Q?oi+/nawIOAJhxDBmG/XMxTpiXJRU99teF3YYdjjACvLOYeWyYqlG4r01cwag?=
 =?us-ascii?Q?6hqPm3IGfBF+pKnurmVe+OJep22+EIXIlZpShiTdu0hIDbkgycRjxgfM4dJF?=
 =?us-ascii?Q?0Ro8sTsJozTpb29C+tY/GxyS8mzp20j0tH9lobPvqNrlMlOi/ES2rozzrM3n?=
 =?us-ascii?Q?8SO1m4/jkIW3U41UDmrqRbNtvzra6HvjAFq6kh74XBevrSm6widcMKcQPL1f?=
 =?us-ascii?Q?GmVWAwKYlEWAityPM48vDNwfTXsT9W36El30eokQcngWoxt43mBGbCCGigF5?=
 =?us-ascii?Q?5lA+/d3g3ppLITfxpgSLzR5tbXLOtD3xVzRTBIqiIyoYoxXcVA8DG6+CoNUd?=
 =?us-ascii?Q?ZKS6ec2ow1M1tbPWxfXryll18w9NmrPqm9ucXApHpdbY6Fulv/Cjth/0Fu7C?=
 =?us-ascii?Q?Aidz9T7OB3gHvJMqylUJQt26hnuscqCC/+FWPqZygcFMhkF8tIuqzPmYyM4E?=
 =?us-ascii?Q?HgWHMvGeDihy95BeeaNTwUFPE2OdqUHZ381yycgDA+3yp6+JMan9xRHHOXhQ?=
 =?us-ascii?Q?WoAVvMpynrRo7jpl2dyz0ScZHbJN9xuqQLfJURSkcDGMWlCxUS0M25OW8yPJ?=
 =?us-ascii?Q?BfHkNANZ+UbvYSvVnuy7uWZ3SgZNeKEqPGC+F7d6Wq+QAPrFFWuyyXwY635Q?=
 =?us-ascii?Q?leTmatQMrs1xwwAOHMFRMGOHxcXr5ajWlPTNRbOJpOQiQ9NthjQcrAKSAN6y?=
 =?us-ascii?Q?PMGZHT6P1F7xZD/ufNux1I8flSidSNIPkZibvgcDgC998AKlwDq12I8w2Z/h?=
 =?us-ascii?Q?/YaY2IbL9JHwdjR665lyRw4RRgKoJxhyTFJtTDS4aNtJLZsnDdtnzmMBCmEg?=
 =?us-ascii?Q?9G1NWUxK48acq33HFgl3vvq+0tY5UuOE+EaZbJvCO2GDNvuRiePBMErTlY+g?=
 =?us-ascii?Q?F9A3nv3mitJb4HfsJtXo0VsnU0cUzDCQ54RwlAHQFeJzOxF6lztjRSDmsWHN?=
 =?us-ascii?Q?/bq9T5AllIBO9iQrFZSs9LGbBopYjW6WhUyNcEJ85PL1Fuwxq7p7bI59PxML?=
 =?us-ascii?Q?hlB1an1or4JpAe1NF3XDFSTinwx1UeDmuJ5RovpdVUAFTQHTwf5VTL8BtEHm?=
 =?us-ascii?Q?epumk57oX9rz9YKlIUmY99M+wCTlOrhNEKAhgutbb+9cz+WzBqe/YyfaXU5D?=
 =?us-ascii?Q?GRhECp0WmDsIpOpIy53fwIDEd46o/ZgfKnTDGR7zItE+Gw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70010501-081f-43c0-7568-08d8dcb1de12
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 12:59:36.5063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xHSOF3VYGJB9/53acqEy5sNMCFmF+0l8GP/b317bvrQEw8N1pCJP2HeBmevgH+2OJ+h8fVwF7+xhw+WxFMSY3tN1AsPKfPPM7ELOPgyt3Hk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7237
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
