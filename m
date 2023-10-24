Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED73FC25B47
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 05:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbjJXFgs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 01:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbjJXFgr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 01:36:47 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263B4120;
        Mon, 23 Oct 2023 22:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1698125805; x=1729661805;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eTf3w89XqUYLhxslAdyxOixuIyu/kjJrf92WybUxBlY=;
  b=DsuYbOrUTdZNtP6bvI9MOc6j1JAn2oV8kyzhz9xan2Lil978zo9gux+f
   v+nid2mx7fiokJ7VPM76HJ/Mqt6vOV/UqfCdh0U0o8W/ih13ITx6D+RuF
   D2p50lfQM90cJ3H35ayIcQ2FUVpmkJVcCjXFftKnJpwEVR3E5rmMBTsTD
   SWU+CCWHnl8lPCRDV8t7H9lJDfADRHwbAaonqBLVrO7qT+T5+FFbw9vsf
   evVYZhYYaCDimT3Tr3Ufcoun1gsmR+gCh0V8Mpf/sFxG0RsO356lW+TYj
   oM7C2kJqVV2Hgj+KY7a908qf83E0oOQD4w2ZIdi98+Sxdyje2oWk5SfkR
   A==;
X-CSE-ConnectionGUID: q/a3jyw7Snerf7jKmwLlrw==
X-CSE-MsgGUID: 9L4ZPWvJR56992N/HjEzsw==
X-IronPort-AV: E=Sophos;i="6.03,246,1694707200"; 
   d="scan'208";a="439009"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 24 Oct 2023 13:36:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4Iz+provyD5BpBS4U7lAXr23WPrlA1NBmdNGK4HLjw9R7ZUgVqbPKAjy4Z3uF1RUFErS+8qOcs/owO4OfMO86oy6dcngAXiCGx2rNJsnuzFIVkJ3B+U6i9hryZ326Xj2R+MLhFaZDClA7KYwxYxeTdJaJfP4nVMBLBO9nWQa4M7H40bwi314pzjJnvCYwbTrjZK+L85UtTWl9aVRvmH3xUhVhOfLGk5KRlKCXoxV2mU3Eqt1/wRFiYVhPusxjsAcDo0imbZdjqZ0xR/o6+k3Y5/wqD4fSnaJDV6AK4k45/gA+ITJaOTADDTRyJzXASUBQmm9p3Sem3XivPka7Ne2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5GHMP14u2WIgBscLik2SBu+L8OFMiKk5ulvpyK9I2e0=;
 b=BZzbps2rgeU2rNWbTyEevPoCxMQ/StQAAJi0jo+VGymwdLZDEKMYHvNn8NHGs3m17wpzZmRJJDsXYqUsR+M1SgjsUHJ+9XDB8BXzCSZO06UeRBoYiEvq4SSo12prmTQuSA1f67MuIUcV/3gKggpPZiluPG7ULGxsvI51df+x4cwPlG5UP1kWtNjR6OzJjQ1vFZSH5J3l6KrDyaimxKUsBrBC34yrUAXV6rUcJTIbFUClXkQu2HuKjEQBs546MuRnb+grAGy9u5gxH5MvugMXhbi2guzGQKrvpJ66J2N1L35UYjGmi2iv0p5HI0yyXYryTYzXqBeN0z9Wwb9oAm4X9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GHMP14u2WIgBscLik2SBu+L8OFMiKk5ulvpyK9I2e0=;
 b=TcUto9JDlmUtwpDxhq5dUTHqLuE331lQuq+2CFQXXIQgHd8sW2h/EPAWB4R7fbxdFvJZHVDGZ3WdeH4AcgWDa8Vr3ThEy3qHF70P48rII5Evzhl6bqUsH5h5NYZSLLrI9D7M9R4EiXJfveRoRU/PW9rBEghNkj4WV0gk2++aW1M=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6364.namprd04.prod.outlook.com (2603:10b6:5:1e5::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.33; Tue, 24 Oct 2023 05:36:41 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::83bc:d5e1:c29:88dd]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::83bc:d5e1:c29:88dd%4]) with mapi id 15.20.6907.032; Tue, 24 Oct 2023
 05:36:41 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Yu Kuai <yukuai1@huaweicloud.com>,
        Ed Tsai <ed.tsai@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: RE: [PATCH v4 3/3] scsi: ufs: Disable fair tag sharing
Thread-Topic: [PATCH v4 3/3] scsi: ufs: Disable fair tag sharing
Thread-Index: AQHaBfC0TCRKNEtetE+FxhzEDqRdsLBYbAoQ
Date:   Tue, 24 Oct 2023 05:36:41 +0000
Message-ID: <DM6PR04MB6575F2512F651A0212A14895FCDFA@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20231023203643.3209592-1-bvanassche@acm.org>
 <20231023203643.3209592-4-bvanassche@acm.org>
In-Reply-To: <20231023203643.3209592-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|DM6PR04MB6364:EE_
x-ms-office365-filtering-correlation-id: 709e1402-74f0-4cdf-2d3d-08dbd453336a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D5Fr/AWpVDvAczikrQ5sFwPk7ZU4vA4CyNLtunJNBQMAgE8dCb8LfDrhM0dMbpit4EJ7aJdKhO5xpjWXJK461cRkCNyqARLnkFJd6PyVgilplXpGdL+oridJmWTKMUlc+xvm0NZ3fwDayANphh5W13y9veDYyEyInep5vdgEAyceELC1dAv5cIlf84cBqWrBa69pRAbp1+XH3ScIyW5b6No/H5cydXAIJOY22euTwQ8SCNGm1mecmjzhrpZ6OxW47rLYVK/bU3CugMUtdUG0VSZBmFhDu1YCGWItas9Ed2WBHdbsnZtxzkCOMm8I9MVUOJBVHC/59kFqR+bij2DQ4s/dltKvxiccGxAWVMaHz2FJq61qBY5SGNQ6PvLIm6ij69Pzp+1hoPmNnqlpePdFZsxMjbF89ruVoNVAg3Jsgbpf4uhXrIWVrZHSscmpaSFu6MfJf7upA9MuTo3MbsQ9wevQ5P1Sb3fgnReRFEbuJNaozQxYonypxWAzOGJRIdbH7qUzp8pENfgTNfjmsTmzyAwq2VPnY2K62YNRV5W2sw9ZJxSQQeX077fHxEraq7PHDZL7/dwF00axE53RgCyVLyatUqPTTJMTXReYNbwYKKjBuDNs3t4i2G6DOP2/cYVW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(39860400002)(136003)(366004)(346002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(122000001)(38100700002)(6506007)(9686003)(7696005)(478600001)(83380400001)(55016003)(8936002)(41300700001)(4744005)(26005)(71200400001)(2906002)(7416002)(54906003)(66946007)(66556008)(110136005)(316002)(64756008)(66446008)(66476007)(76116006)(5660300002)(4326008)(8676002)(52536014)(86362001)(33656002)(82960400001)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jfORiTa9cTqadrgm0uWuXgP/GMnYtUXkyZRPWC0CkfYvdesKyjkvTZGZH+LQ?=
 =?us-ascii?Q?365bkMO51jPTFczaXA63Qau2Spaf/ZSGcc5KqUMs3LnZtdJmDNvCcpiz3s6m?=
 =?us-ascii?Q?LZLltbxHKFEeK3V/jPkRIP5kPEUo2PRJoR6MC0T4a0BTep6e3T+qMYcpyes6?=
 =?us-ascii?Q?Mm3muRYOkoRoRqt3LiSIjPEdg6PVy/WzhC3zwBqRzz1laYBNseMp5/tIJiVR?=
 =?us-ascii?Q?58z9uL97i34NG72xKHbcC/1N1Xov8sH8NBHTfE3WK0sWzSRdBcKvP9F8nOPz?=
 =?us-ascii?Q?XUSCRAfHQOzQ9D2sakAyDp5p35LfWgj2xTC7xbFDYwlj0lsiWtnyEgkSIliA?=
 =?us-ascii?Q?p8vM/IKhZfm4JLquYtBeAM+5cvz/uxOz9IxzzUejqJitun5uPfOZ4XI/OlwW?=
 =?us-ascii?Q?XpfK+Vc97OqH6QgzYAs+yXUbzGhMuOqVvHvDg1sWoAqiOMGr9tjpAVTqBIjT?=
 =?us-ascii?Q?EF06oo5eZkNAGww5MOR0eAUw995mZnd2yzfXXKgpWZ1RxHpDh3WZ8wmx0DqR?=
 =?us-ascii?Q?pn+lNRsOHJVwO3qJxrmBd/9Y7JQ8Zy0zsRJ8/OELMBH0xmV6m/BuMU8W399P?=
 =?us-ascii?Q?OAsP8gJRqeTY+B0UqLWFgpY4jYlYXXoDPI5FsCyoUP+JZbLPd6nKcqRk1fb/?=
 =?us-ascii?Q?nhP4Y664YzWrTYnhWIfSagurFDpFMqcMYeSJPbvKq6b+5xUOxGyO9vSBDCIN?=
 =?us-ascii?Q?HEqPPuyLO0RAat3iTa7Br7Aui6PlOhIcI/kVN4zvnUzyeKSkR216oO8Y9J4e?=
 =?us-ascii?Q?aBWm1fVnuC/UTJtmoKme47AAu7xUr3h+d1ymqILVYp0upYOATYwdbVzJeNJ1?=
 =?us-ascii?Q?aB3k5/vYvUC5K1eVf0aUNcGciRauxkwp/qJro7NBaT5lgP55TkKO/+7+Qwvo?=
 =?us-ascii?Q?jmW9D8XcRhw+4+ek5uhf6uOPzn7dUdz3Zmt2p8EhkmySPgl6/7pvgsfGzEPB?=
 =?us-ascii?Q?4oXUFfOGKIde/7wzVuhDNZBFuADoW8RGdJO8jrVqtkIBwivXvx93cDHRIT85?=
 =?us-ascii?Q?WLYA/nU7hAEOzDY9z7+TjGMOMYn8iHEB7BTSRBfo4UoawfzQ/iivERdpFg7n?=
 =?us-ascii?Q?U66uUJbvsfpLtQutFrumjXeaS3GUNx0Eu6l9+Dm6ZJ3NOx3XHhi0sAdm4X98?=
 =?us-ascii?Q?epQ1q6r7cg1vvYHYhIBEYlXTnqF1rNWk04cC7LUbRexVZ3/y+SpTCWlM3kB1?=
 =?us-ascii?Q?cx46+E5CT/vJP1cvsiB2+6wdUaBcqVLc+xOoPUc549E9v6a9Bh5BUMTrsIed?=
 =?us-ascii?Q?dWNcrmYTyCdUTPEOErfjAPfUc5CYajVaXCNJpv8j07e5eY6dZgpU1IfAhbOY?=
 =?us-ascii?Q?48f9allJ9PuCixBJzBVr0yJW0YFTt0Vx23vN2tGl2IsZ1dJgsO1lo3Lr3a1+?=
 =?us-ascii?Q?21bM/uiWJfTIU4hDmcen6yQQONRvVWGh+4Hb0JbjsN1iM+B03H2a0BWrDyXH?=
 =?us-ascii?Q?0JC2oe3U2xml3jYxyJg1FsShMKBbCpPuqfrrlaRUT4FN0LHEmbsKgEzIRnOF?=
 =?us-ascii?Q?dVV+APtE73EekhGeAeMKOGQo5Et39loQiIwcBYj/+gJORdrLGts7wdWHfsHj?=
 =?us-ascii?Q?vMT7jE3WXLDlWfaXl90vmLBWiq9gSbeYqFIxUh/Q?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?741BIVH7YUQYWsY3EAsheqV2ohlICmoXamUGD8KD8uPK4oF0a0lVo9rltTCx?=
 =?us-ascii?Q?tQdzP3GwVVWjEWCAiRmaaaEAJGFRKgHuMbMWGQC94tOCo+Y8Ff0ZMec+6lXs?=
 =?us-ascii?Q?GCcLDFl4aB0RCPwKLljyBEgrsXYvuI0e/jvHiNMzkA4Q+83KDKGNsDBbhfQW?=
 =?us-ascii?Q?AXa1Q0iBCrCbxoLSrnZuqhkwjkGhlTmcZFCX+VIf7MQcYNWPOzg8/K1EG2XI?=
 =?us-ascii?Q?TVz8Fw6W/NaD6/gyK3w0OiOKwIryQpryaPt8ubqBKXPojCKrFt5v6Bmo7l5D?=
 =?us-ascii?Q?94atKzImwkSFXxX8vAuBT6Ts5PvkCHPa5iaNvHv0JXAZGUx3nHI06Ro1Vkp6?=
 =?us-ascii?Q?BvSkCqSwhZ7aBSJBXZ77Eor9IUss5CFVycurygkvlwSWtcvXVVPMWclJ2vqo?=
 =?us-ascii?Q?lVdgbdJQM8cZ5Z16DupG/FIxoOOCtwjPp6kIk5jHPuPbJhDTcvJz5DGy7sKC?=
 =?us-ascii?Q?mZggW5WPAxNQ6KA5MIEs5yH/mn+4Ygcs1t+YmaxIyQQbrRmMR6w2gS80ss/u?=
 =?us-ascii?Q?ExEpfH/G5vdsSFXfqAgGEURR/XdH1zF3ZwmM0MGZDRzmtUI4xEpc8SrboBQE?=
 =?us-ascii?Q?4xOaqi5MaGa6ONZBH5of/S57QOJioh90reX616yViqVV0H8vEkfkjxomO2Ss?=
 =?us-ascii?Q?oAPXSlPLfPIIywG5RRt4dUjkRt60fQo5Z6DbHbnHmkJqO6d6W3SkHGQ+a8FP?=
 =?us-ascii?Q?h/yernrUDXRTUvAQ2wtHX96JPfFg9MLUQIIwATrZaRmVkBL1ge/Kx2HEyi45?=
 =?us-ascii?Q?HWTIcBbS8JZKArt5V0WbjvLO1d5QvrG8fQFVgjhIPARsI5eGSLG9VMTUJd6Z?=
 =?us-ascii?Q?xy7Ib32NwCy3yb2yx30Bx5wy3ZHUYwf4dmF17gGoKfijhZsivA6WYFfueIVK?=
 =?us-ascii?Q?gyBSHct4PJD9q0EBQStU6oaBJw0VHHDla6qkhRkxEivn2bsMM7qsR83qkx2h?=
 =?us-ascii?Q?StdMaZo1MMpiCpEoPMcRjC3tn02xWM2TUuwJO30TeAwnVYTlO6SCxvzdd7gM?=
 =?us-ascii?Q?LHcAivnBj+q0x/BtP0U7M38jnWK1SfWKcOsZEAgHi8RndC02ayEqx6y8D/Lu?=
 =?us-ascii?Q?nID+Nw8/QDErcCBq3SoO4mb9gK5VJn8wCLPBpC4FTiMv9GRFkmJ0MuBr9Y+3?=
 =?us-ascii?Q?xAdbwHQ94Opl?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 709e1402-74f0-4cdf-2d3d-08dbd453336a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2023 05:36:41.2511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +U8D8s5kLc2iuIFHxCrDv7pJzpLh5+9uylOdBkzVJ0linHeYrpbH464eGmWdTzBohLueis1xMH+HXUuucLCWPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6364
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Disable the block layer fair tag sharing algorithm because it
> significantly reduces performance of UFS devices with a maximum queue
> depth of 32.
>=20
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Keith Busch <kbusch@kernel.org>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Yu Kuai <yukuai1@huaweicloud.com>
> Cc: Ed Tsai <ed.tsai@mediatek.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/ufs/core/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index c2df07545f96..ed04d1263e02 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8866,6 +8866,7 @@ static const struct scsi_host_template
> ufshcd_driver_template =3D {
>         .max_host_blocked       =3D 1,
>         .track_queue_depth      =3D 1,
>         .skip_settle_delay      =3D 1,
> +       .disable_fair_tag_sharing =3D 1,
>         .sdev_groups            =3D ufshcd_driver_groups,
>         .rpm_autosuspend_delay  =3D RPM_AUTOSUSPEND_DELAY_MS,
>  };
