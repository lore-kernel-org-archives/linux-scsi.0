Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9693AC4320A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 09:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 797EF61078
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 09:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbhHIJH6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 05:07:58 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:30822 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234173AbhHIJH5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 05:07:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628500055; x=1660036055;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=hyis1sukLlLUbD4p/aFfBVo/VeoYEhzbpsXlnc8SIVs=;
  b=eX/41GFyuBTMyvoScZLx+ESgZ1N7VQN+ROHQnMZlLFqzjiIeYrNZwSdI
   tvP+fgsaXw9bIh+LHpHEQpdxIxDmXDidapIirh34Fo16dNJhg26/OeUqi
   P8bWMTECZSzpfpzu1rdv1DUFi+wmAw3PHdF5aSsjw6Y8oWnJ3NWCdxaBw
   RUVikg0Q57ioUnG4slL3Qbi0qwdFmKzV0wteiuxJds4l6zxHwPolg67SS
   ZWVdGP9qN2dDsRJQGP95UxmFRhAjCSG6koVXh6M44ObdOYomXK70gmc0s
   ab35Mn4YN/V38S8hRTGjGzNYsHhJuEt0RfBTRbHP37YwRRcg6Jd5WzFEH
   A==;
X-IronPort-AV: E=Sophos;i="5.84,307,1620662400"; 
   d="scan'208";a="176670382"
Received: from mail-bn8nam11lp2173.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.173])
  by ob1.hgst.iphmx.com with ESMTP; 09 Aug 2021 17:07:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSFdu+x9xqzrLw5iGltoKaZHsz62nvtTv4aZLEiX8f36cWgwmg8Ug1PBxixPi36+YaXLmDk5LwX3gSYyJM0Vr4mk8Qf3N2fpea4lJW1mRm3ZiSdNKENJRTR9gFau10PvuI7r3pZtRwXSP9PZ6V46j+DaAoIDTX2CXecL+i77WFXQ4FDljr0QwYcWF5pRUcnC2ZJs9K+tHh9LBZrPccPhJew8nN77dyZ1AjSntF6aSml2+egDoJhwdnC3yR0EHGVpmfIA90c5sOcjexFd59TSYhybgE3wfBmN90Lfa38X6UvfwoMVMj2YJAEE/p8pXPzBdyho/TTsngwTeP3CifvG2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cNt+xBEgdMUy+vJetUPw+tWuMS7m2ezCTD+jK3IYyOs=;
 b=JZNsDDJSfY61yJewFcgw2h24ZbBwAo0/Tht6v+pXlL0VZZkOH3ej9XOl5I+SQQ7ecxieJuQ0vNX4JBhgw6uj7GMlOMi8jfOqnsI8moSSouF9jTJl1FlMbuIpUCYQbZOpibaH8/VMtjurA8nRQ+5r5RoEVR22Lay6wmgJwxYHbBPzLoR0WmbW3xELPlbNCHl40ZFFVgdSfGdfBwrlB9yfGppd+LcLPr76bgxCHEd6Vh/tFGYCEnkuGPoldVWRsF8mpYPQQSP6CkjTksQTtPk6ppRpR6nAJBQ4dS3n9QGIuv/WM1Ms9EpERJo9ASzgMei/4/rcSa7YR0RJ8WgeuQH2dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cNt+xBEgdMUy+vJetUPw+tWuMS7m2ezCTD+jK3IYyOs=;
 b=DZaVOzu9LZYE6szAz+ZaMKV1WLsCUEoGA7XSqzFLqA9e47t64sCD/GrPR6JzGZqz3q4sLpc6IUfG9k6+7nIvdxpiz9v8BvGQ1nGHSN7zTjEW34IH1h3d7RX0IyMPoJKfj2vHxvtXcczoo3LLGPI6BsFxz4bxi9p2wsclGd08Y8s=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6074.namprd04.prod.outlook.com (2603:10b6:5:128::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Mon, 9 Aug
 2021 09:07:32 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%7]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 09:07:32 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH v4 01/10] libata: fix ata_host_alloc_pinfo()
Thread-Topic: [PATCH v4 01/10] libata: fix ata_host_alloc_pinfo()
Thread-Index: AQHXi0NhChjUwGsJhEqM9tvhoR4WhA==
Date:   Mon, 9 Aug 2021 09:07:32 +0000
Message-ID: <DM6PR04MB7081EDB783FDBD8282A309AFE7F69@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210807041859.579409-1-damien.lemoal@wdc.com>
 <20210807041859.579409-2-damien.lemoal@wdc.com>
 <8b4177d7-b23b-e152-1bcc-35d39118e26b@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9eb1fba-90ad-4233-cacc-08d95b151f5d
x-ms-traffictypediagnostic: DM6PR04MB6074:
x-microsoft-antispam-prvs: <DM6PR04MB607419E0E6CD8749C3A85BC6E7F69@DM6PR04MB6074.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TLfYzHXru0c/C+VXb1fGOuogJf4LNcAQITx8USsI0nxaXMl7jo9b+U8+vvHihJf2tgcoC4PUv5lH0djeG0jK32zSE+xvjwFzcQOv+ydTu99TVhnbNQavVTlUUBR847SaipAYXOgEgAfUxdjjEbdp/6UEJM5vVB6V7jjBrQ9016gtuWTcrfNgmyVbuKuiCGiaX+DmPoA1KrL/YaJg36GaPr9FJcFk4d1zfnzipxsKV/aMNhbe3YcbcBQTsGT5etxE/MOTo5fb+HP66/zAshvfgTVyHVTXntnzt3U+mnj05hCPyG+BjWOn3pndTC/1vAOHY5i1qGBMV/HNTK2j/RFry38/RDqnxgxsRs9OriZiXWSubGigO8DNL/jKYIZBQQU1efvt3JJZRz+pOcePT30ZTmTPC2G8KmR6AMv3gzO1MOfodIM2v8iKPunlhm7IwLSGBZeY8koiHfdwzxfhC9rO7GxYdnjR5/2q5zlkZwOkYkPRFe9HjEeQt7kIunSJNBrlA8zWbIXoWxDcAJmfUeEtwtUAFb7S954b0/Rsq8Za786pO84Nd8ROjR419rvMpD9dZAPye9qYkrFMVDCyUcdoJFHC2MUxqPQhZTpN0PcH9c6DsETYjgVo/7VOnWHRzjQ1p1HhYGWq704AKIlPFfrNVzG1ADCBJSCfAHVIDBl5ZEE4aVQ+0iiqYs/qAxR3y0A27ZC+adBDXuk2gi8z1W2mNg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(33656002)(38070700005)(4326008)(110136005)(54906003)(9686003)(71200400001)(316002)(122000001)(86362001)(186003)(8936002)(55016002)(38100700002)(5660300002)(83380400001)(7696005)(8676002)(66556008)(66446008)(2906002)(64756008)(52536014)(76116006)(91956017)(53546011)(478600001)(66476007)(66946007)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OZ0+FwCwZ/Xbt5GBU0Gi0XaiNlPE6VQtLblxKHkHkJgD+Z3bGJW/SpMj/VYb?=
 =?us-ascii?Q?njJeYBem9BH7qecanXpci9fHIBD6Qbx1/ru5fO8HZtniTBfQNOXkzhWM/uKc?=
 =?us-ascii?Q?78XRnFsgsEHEaWOAAP7ul900kM8jAzEZrWmFYtBUP9fh4zWzCzzqM/Idp6Lp?=
 =?us-ascii?Q?FTKC7xnevzgDCevFLvA5oMXro9KW1QAcVobDy84hnKLmeBRbqaFOGumbIp00?=
 =?us-ascii?Q?tdTvFsmR7AIHSnddOUqqkbrzEa7GCCZNjfFsu/eKv2RE9WX0oAu4kkHaw/ql?=
 =?us-ascii?Q?wEypKzix0EsyelNrQ7OrFfoPRgLyh0tbYuTCD+bVSTDu+9APocDIcPCO2PXb?=
 =?us-ascii?Q?tHRB9DgommQlfZFhHE9Z6EKo+bu+wOSYs1ZRzSNzarkFDF2tbtzYJ1K+eIAf?=
 =?us-ascii?Q?0vsmvCIe5ewBjdWC4hGOPqEH2OlYvB4pMOm7/T5IcJC5hW/wew1gz4l7Ho8/?=
 =?us-ascii?Q?qxLKz40Ehc8jxFD9PDRELfAnd6Wh7GgbTNvoZDP5yGmfCItXn4WW8pnCLl+D?=
 =?us-ascii?Q?oEhCrpwa/ItJaCHk3+XSyKX4ZRdPLpRMGqc0f3NW9WH55EPPdi8vWfUpXjkV?=
 =?us-ascii?Q?VNXRsFxV7b3EruzzvCd9StvRfi2iL+zq/G4BHsz8o05sBDj1U/SmGdG+EVcg?=
 =?us-ascii?Q?1YYgVg3HVtBJbsWtC3k810Ej81z/rcWxWStnERpISjF1cTnEyeVF7lC7ovR+?=
 =?us-ascii?Q?3JvsY8hqps57kdXdKMdeYfgAx5aRqLCqn/s7IH0N0Y5IfikAdLtnxrVgKKZK?=
 =?us-ascii?Q?e2KJXgyz9G/X0skLrqvgXUtNcysFTx0OAGrHYVX1BE1r7X1Cz/CfjSYgRrV4?=
 =?us-ascii?Q?xsZ5GNy9QWTCIyhRTH4CT8L66agc2f2SdsKu4yo1EyorxeY+Y5dEICU8mW/R?=
 =?us-ascii?Q?e97SITGp+t+Z+idlPa4MvYyAKq4L8hOHkX+eQ6AfGSVAd/b0x0movfhUF2Je?=
 =?us-ascii?Q?TDTeUQlJs9Sma0o2vs0A7PHCn+BDFiufhtemBgpmIMg0N0kkJCSuaAWOxh7C?=
 =?us-ascii?Q?HmMD+iQfXOCtN+idYwMnfOQL2Gs6rymlKE4YG+TUrJbynZkTh5nGF0AFDqUe?=
 =?us-ascii?Q?waILwHW3pfxKThCsZhuLW6nbNLCYABEaUDidO6X3gzoQybRmhaGJ/CpkZZbP?=
 =?us-ascii?Q?c0lPEYTKQ9Sa7JIN7b9bjLqsZtved/tPrBO11OsV3BkPQtEEzJBqnGcOxqSO?=
 =?us-ascii?Q?LF/1c43WU9gx1uJNPXBCLbBIeQaGOiQEdx77VG4ET6sKpF10QoNKJYf0gg5k?=
 =?us-ascii?Q?XSsVQomX6n2+fK3INJFK6SeiNhzzpIO8ozS0sIIlPxyJFzTnsq9y9x9egL0R?=
 =?us-ascii?Q?BEuBwviJ/1xE7EH8Iz3yEUrF49zD1D2PdHCG5H/17cR0mmcmBpRFDPyPm7ac?=
 =?us-ascii?Q?7xzXdLWgxEcp/1dsOLTY/1SgVa9oZhy3M1G60v+es3AuNdvLjw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9eb1fba-90ad-4233-cacc-08d95b151f5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2021 09:07:32.7361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P2eAMEhTHio2zj3ZOiS8w09nm1LHyZZF6WrW+ryGq+KPSB9gb5aIFfjLagQ8mC5y/YzhDVNRPgagBJqUz6Zzxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6074
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/09 15:09, Hannes Reinecke wrote:=0A=
> On 8/7/21 6:18 AM, Damien Le Moal wrote:=0A=
>> Avoid static checkers warnings about a potential NULL pointer=0A=
>> dereference for the port info variable pi. To do so, test that at least=
=0A=
>> one port info is available on entry to ata_host_alloc_pinfo() and start=
=0A=
>> the ata port initialization for loop with pi initialized to a non-NULL=
=0A=
>> pointer. Within the for loop, get the next port info (if it is not NULL)=
=0A=
>> after initializing the ata port using the previous port info.=0A=
>>=0A=
>> Reported-by: kernel test robot <lkp@intel.com>=0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> ---=0A=
>>   drivers/ata/libata-core.c | 16 +++++++++++-----=0A=
>>   1 file changed, 11 insertions(+), 5 deletions(-)=0A=
>>=0A=
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c=0A=
>> index 61c762961ca8..b17e161c07e2 100644=0A=
>> --- a/drivers/ata/libata-core.c=0A=
>> +++ b/drivers/ata/libata-core.c=0A=
>> @@ -5441,16 +5441,17 @@ struct ata_host *ata_host_alloc_pinfo(struct dev=
ice *dev,=0A=
>>   	struct ata_host *host;=0A=
>>   	int i, j;=0A=
>>   =0A=
>> +	/* We must have at least one port info */=0A=
>> +	if (!ppi[0])=0A=
>> +		return NULL;=0A=
>> +=0A=
>>   	host =3D ata_host_alloc(dev, n_ports);=0A=
>>   	if (!host)=0A=
>>   		return NULL;=0A=
>>   =0A=
>> -	for (i =3D 0, j =3D 0, pi =3D NULL; i < host->n_ports; i++) {=0A=
>> +	for (i =3D 0, j =3D 0, pi =3D ppi[0]; i < host->n_ports; i++) {=0A=
>>   		struct ata_port *ap =3D host->ports[i];=0A=
>>   =0A=
>> -		if (ppi[j])=0A=
>> -			pi =3D ppi[j++];=0A=
>> -=0A=
>>   		ap->pio_mask =3D pi->pio_mask;=0A=
>>   		ap->mwdma_mask =3D pi->mwdma_mask;=0A=
>>   		ap->udma_mask =3D pi->udma_mask;=0A=
>> @@ -5458,8 +5459,13 @@ struct ata_host *ata_host_alloc_pinfo(struct devi=
ce *dev,=0A=
>>   		ap->link.flags |=3D pi->link_flags;=0A=
>>   		ap->ops =3D pi->port_ops;=0A=
>>   =0A=
>> -		if (!host->ops && (pi->port_ops !=3D &ata_dummy_port_ops))=0A=
>> +		if (!host->ops && pi->port_ops !=3D &ata_dummy_port_ops)=0A=
>>   			host->ops =3D pi->port_ops;=0A=
>> +=0A=
>> +		if (ppi[j + 1]) {=0A=
>> +			j++;=0A=
>> +			pi =3D ppi[j];=0A=
>> +		}=0A=
>>   	}=0A=
>>   =0A=
>>   	return host;=0A=
>>=0A=
> This requires a comment as to why this is necessary.=0A=
=0A=
You lost me... About what exactly ? If it is about how ppi must be used to=
=0A=
initialize pi, the function kdoc comment does explain it.=0A=
=0A=
Note that the last hunk is wrong: there is a potential out of bound array=
=0A=
reference. The condition should be:=0A=
=0A=
		if (j < nr_ports - 1 && ppi[j + 1]) {=0A=
=0A=
Will send an update with that.=0A=
=0A=
> =0A=
> Cheers,=0A=
> =0A=
> Hannes=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
