Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E08B8C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 08:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE0DC20899
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 08:21:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FM83Gzkl";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Z+/w8KBX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgGBIVn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 04:21:43 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:37108 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgGBIVm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2020 04:21:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593678124; x=1625214124;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=zqgwkwgShlGQ+ot/Ag1HVC9NqX/4OYk/6S5bJuIzSgY=;
  b=FM83GzklDTJmqQdIPIXnZqD2hg8VstWjwU2YXt/9gErx25imZNYAF5xP
   TbBuKBeuQKS0fXdiqeQo4Km7fOS9NSnAMkEoZahsqcBj0S2iYcL5yTQJP
   r+lerBzcTOU3fciTooTRTY9KyFPEz0tBCuQSWLM2x4mX3mg3A69moSoNZ
   89zCSV7h4W9O5sfLJPJR9/GEp1+WA5JrVV//qO3mfeSHoVD5FVrXke7cN
   c/UaY35lttjL+LkcT1Iid4Fn60RJjVHa8jam7cdbg7ndD1qAn9IfjaBAK
   Q7pGlBMixdr/5U+Rtc+qCu7w0NlNo4VakteYFHtZWH42QYMQp+rkVQ5Af
   g==;
IronPort-SDR: oPqvowlujENYUV7kgakcojk7HFlHV952cL4dLr5tgDwkWNflEDAWfTE+HRTfkGbt2BsYeSdfUl
 aGC88WHHVZlfhaO1FIgSMdt7w84l4bNtr4tbuQn+ATYMmcmFMPhzDVc5eR+Py0qVbcAsotfSPY
 LgN6sFzxR5+Xb9O9sZmfEt8dRPU5xCiQceSAwY2fFtJu67LRAeOYJI9Z5drWGOcN/go1Yvx2Py
 S/FRHZcGkWeODTXLpFZi4IwfIxekV4hyuXXpl0LkoJgBbaE0ss/2JcEigxBLf7Eu0G0FoF0nSW
 NR4=
X-IronPort-AV: E=Sophos;i="5.75,303,1589212800"; 
   d="scan'208";a="244482874"
Received: from mail-co1nam11lp2172.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.172])
  by ob1.hgst.iphmx.com with ESMTP; 02 Jul 2020 16:22:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NDYqHoOgF27us7aevMhCuh8p/l9PjPaZukVWPENdPJJIy3Nwu57jYrfIX71sPYs4wHZvHlobku1k0+ch/TnqgOvBPzL/AdagsIyjIjyfnUjEVuskmw/ztWbh+CoAPH7EQcqkWLFcKvBdmMngD+dbAmPOZfURmeXbgCByln25kKSXy87BEVP5zPPp6MWrBLvHBqS4WqoDdlI/NxfCUe2v5N4DrIUGnHrvYRdGloqyqbZFGnOI7bGvpIaBGuKhTxBOLxkCmLza4qlkusiwzDGqA0qeEvFYOwDpNJYS93ztedyqVmk+p2TzV55OWJFNKNZSPBYYtof2n2gsoELSTKXlaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9XPXStfRPVRf+Ip1WNFjc7cxEjg4dsTWmjBRqz/I2Bk=;
 b=PgEoPVAh5Eilp4jZ0gOTjVX7yoHBXFqJYiBwgueqwzUI+QYHkWnFc8jFALGhCgEmHLoQ6/FNIx3yz2gBg0uvb7AW2erkTuhAj9b/iJDUZgfQPXYBmob3n1EQFaNhYyiRztXsNDnt9M9ze6JXXnJiPRlO5gpQqWqauz3P85gHzaToGdzl6UHfsEJLaWazRW8Wn0q3Z1SmJ7/iT+W7rRY6iMgNJ1CxeNWvzgaFjxkaVSOjTOcvWerGK/TsLrzPaIK9WUwbxUZMevjQZp5AwhJZNj5U37fij1vp102e1dyqb7T1Q/SbaXLE3VdDz3iv37hhSizl/+aWtevAuYkqB2kMJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9XPXStfRPVRf+Ip1WNFjc7cxEjg4dsTWmjBRqz/I2Bk=;
 b=Z+/w8KBX2QuhYnTRdEtYNcCa4GBPKXYqKaBmqcS5RdeNfCkaECmWVw0J8GpV0UCxjqH2L21DApMxfBb+jmbbwZYSv/vRCKFc7KvZXYZNzJ28ChdEdRJu6B3QbHpILtL7yN9xS8Cc+gANXuxvCt3nxWgRXtRQ8qvRScri5XmNWNE=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN2PR04MB2141.namprd04.prod.outlook.com
 (2603:10b6:804:10::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Thu, 2 Jul
 2020 08:21:40 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3131.028; Thu, 2 Jul 2020
 08:21:40 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 03/22] scsi: add scsi_{get,put}_internal_cmd() helper
Thread-Topic: [PATCH 03/22] scsi: add scsi_{get,put}_internal_cmd() helper
Thread-Index: AQHWTkv8lyxSgwcML0K8o4Y2uWShzg==
Date:   Thu, 2 Jul 2020 08:21:40 +0000
Message-ID: <SN4PR0401MB359872DFD1AFEC0797D34D479B6D0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200629072021.9864-1-hare@suse.de>
 <20200629072021.9864-4-hare@suse.de>
 <e211779a-d95c-de3a-5beb-6bf0311733fe@huawei.com>
 <a0ae1522-856d-f47a-c8c1-f67e38ad4f3c@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1515:bd01:1941:c6e7:22b1:48aa]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7368821e-6f3d-4de7-28f8-08d81e60f25e
x-ms-traffictypediagnostic: SN2PR04MB2141:
x-microsoft-antispam-prvs: <SN2PR04MB214168992D04979B9104F8EE9B6D0@SN2PR04MB2141.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0452022BE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7BHCHnquA7lcuw4En+rcQl/EHWP3P7l/4wkTJ7GkIvVL4DHkX+6eAh6fNGqDXjohojS6lfoaOyBzwWfIi02PtDFdbvzqjm5jp9AnOc4sa0yqVIo0XzOQwDnbgDZbvbeOZqeQ2T/j8k/urGBh2j6OMHyNtCsxcvRBA6yinOe8phbKUpCrnuqQx1kjAn3CSZbFm2f3M4+Fn2+tqimXifGmdWxA9eqIgom898kdfo3LPuixNYCZBymBynIx6h5kF51TaEFQ9YP+fncuq42fxFKdJ4Yqopq9+gQEm8PHiLKZbz0UgNQOR3Ua/MCQdQd/E+lAsmZcdhZAptnqb0UU3oJK44c6znpLMVKUfVahVAQKZokZVb51a6lhM4WG2/EBnKmY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(71200400001)(110136005)(86362001)(66946007)(66446008)(64756008)(66556008)(66476007)(5660300002)(83380400001)(2906002)(55016002)(7696005)(4744005)(9686003)(4326008)(54906003)(52536014)(6506007)(316002)(53546011)(186003)(478600001)(91956017)(76116006)(33656002)(8936002)(8676002)(142933001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 4Lp/542wWtQoi9VUBy51Yok8xPkTg326+I2cBiKp3mvOxK7iYrmFYJXxgzg+jKaIFLNJzHiw5pxXDn2vAY3DInNYOPHZBtLk3QO0TFAid2YGSxnSJn7QLLbRyTTQWVr3010U2NA/8szr2V9QQzUvSFnVz9R1oFSUauSHE73nG6xbfoho3wZNUIr+5YLjI+0bHR01NZulVHNoMpzkbntKGngc7Fa4G23h9FkZe+YUeizbX6uULrFevZ2VC+oZrkL8rMieNFLuRbBBaG1uIAtDdrgt4BNs09Hr0QvVSWdQ9zH70x03qcNJfnhEaNaPOmtJ2Vv23BGNBJhvg+V4G/B3BJgWAuGyb3VQyFgdB+zBo3+sNmXOjvPrqN5ZI2/itrEagKnwPIwP9cZDyc9AyNbKW4KMvktvxYLKNWZBggHfKeorcJEfvy8OjOz436ZtEiDLmfjtTfj15IV54ndjF9Ptk43bhwPnC6pGpWXBQVqezFXzwRo3L25cjvXTSfbIWKRDFnE062AfppWS2PdmlJ9ZppeNEbLVO90llffSztpRtF8EMSSwBUXN32X8L4BaoLnJ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7368821e-6f3d-4de7-28f8-08d81e60f25e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2020 08:21:40.3496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ewnGcpvqtLsXZBt/tmcF02yhMgo3pAboBeeUKJM1ai8+nNq3TU74dR5YIdMVFHJDQEydDPDbTetA2qYJ/Ca3jfcqbcfH1MPNRa4GLvH0A6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2141
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 02/07/2020 09:59, Hannes Reinecke wrote:=0A=
> That's one of the best-kept secrets in the block layer:=0A=
> =0A=
> op_is_write()=0A=
> =0A=
> The assumption is that every request with a REQ_OP which has the lowest =
=0A=
> bit set is a write.=0A=
> And quite a lot of accounting the the block layer revolves around that.=
=0A=
> So we'll need to keep it.=0A=
> =0A=
> ... and we probably should document it somewhere.=0A=
=0A=
I personally find this very obvious:=0A=
=0A=
static inline bool op_is_write(unsigned int op)=0A=
{=0A=
	return (op & 1);=0A=
}=0A=
=0A=
