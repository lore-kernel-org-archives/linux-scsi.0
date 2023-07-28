Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F03C001DE
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jul 2023 13:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbjG1NkK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jul 2023 09:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236538AbjG1NkH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jul 2023 09:40:07 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A29F2D6A
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2023 06:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1690551606; x=1722087606;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+JAIyeDGF26vgQwgyXwxmPZEKPAC0zEHrkKKcw44Phw=;
  b=fiyrz5fHDqXrBK5SGwFqi288pPCy3V3Uamg8u/z+Esj1Ij3VtpPYKnBu
   ruFMLkbttHaPgptRlaWVhw4+Bb7wp79RcuSW3UXYxpfZ6TGRCb1viZNj3
   e5gLHzbv0xtR+c1xkDvl8Ky6VkdJx0fboB1fLU+Vn+nU9HE0s3BFFcK41
   /gzozBwLpboeZvg7t5h938GfmhBUss/Zde00T5ANyrryX5FFkRgEGjQwa
   mBWNuXKvXVs5bkoBw2yJS92YYmg6p9mRbT3Rn/LnBMP3E5yNZVhxyGkVL
   sCwf0l0oCE3UrVRFDHy91TM0o6pa9dSrc/9ALY/fdbfLcj4672GVVwbqs
   g==;
X-IronPort-AV: E=Sophos;i="6.01,237,1684771200"; 
   d="scan'208";a="244014511"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jul 2023 21:40:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XRtIFpS0WTq6BTdTLSBP+TWM84qSHElmD8P8RfusnLv8vJed53tnDfg/WsNr6hQrNw6qAw6TRNPTMpj8KrkTHD+PNV90lQiDRR6QJ9akucC+m4LZKZt4JRy9rwNSQ5UCwOGxifWbhjI2qzfwbefKJnRqwLA9/rJptvZ3Ab8XYx3BmepdneN2AlVHzAj36QefQCDs8ZMYnxnl9wjl1ULMXqnbiRiXa7FsM5AdKoldXHXaAhT5jNOU8eyecWWdhnvsFPm2S1IEMUqRjNcSUlikODgjaZxOkeAcSiMCnjXGuWTWdqUSigDnZVOykq9yVFflVRDhB3mr/bUyEIXz3/engg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+JAIyeDGF26vgQwgyXwxmPZEKPAC0zEHrkKKcw44Phw=;
 b=BFRXOWuLrkGKiN6gViUVavfLKrCFAtdnGNCBb5is2BBgYIMrHthQD09vp/RPeMhHh6+0QSlFhrwBtJvKeqUIJ2dOxQL8zgv73kOQNpdtZKJw9ZXw/SMs9+viZBUPzRIYHG/EMttZ9rMay7yLQ5t7LZgv617Z5PBh7SEgfP5xDSeGACKvMLW+FzIYaobK2J4iPLw91Frip4BBmct/USqG53iufQ9dyx7evYAlKN8WzVrbWjvrWpGoneRvY2nxFrWHpOdw5CfQSZUag2qvyai3JygTtCY3p+dU5Qb1d2/QhUDvgIzPp0eL+Tgy1hxeRCVGqFwV+Zt2bY8THFOjcKOT/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+JAIyeDGF26vgQwgyXwxmPZEKPAC0zEHrkKKcw44Phw=;
 b=rNXB7YS6ngVcIYcZw1J8qllDSb8OQhMNNk+JyXL/HoUxWH7x4k3FFA1N4vJ6tzgirfLAB4fu79tSGtam2wvoSo0+lg3Qvky+o/0sii9vtxXXaVe15Or1GEm8SoSCt0ZdXrfN3c2BqS5Z/ijZaRVMqe3nAwwxginq60baufq0E3I=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BL3PR04MB8188.namprd04.prod.outlook.com (2603:10b6:208:34b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Fri, 28 Jul
 2023 13:40:02 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::4781:1e0e:9df8:940b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::4781:1e0e:9df8:940b%7]) with mapi id 15.20.6631.026; Fri, 28 Jul 2023
 13:40:02 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        Eric Biggers <ebiggers@google.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH v2 11/12] scsi: ufs: Simplify transfer request header
 initialization
Thread-Topic: [PATCH v2 11/12] scsi: ufs: Simplify transfer request header
 initialization
Thread-Index: AQHZwMNhFAM2Jym0kUi9PzL1CbglH6/PMEQg
Date:   Fri, 28 Jul 2023 13:40:02 +0000
Message-ID: <DM6PR04MB6575125AC2D77D4E05D09DEFFC06A@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230727194457.3152309-1-bvanassche@acm.org>
 <20230727194457.3152309-12-bvanassche@acm.org>
In-Reply-To: <20230727194457.3152309-12-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BL3PR04MB8188:EE_
x-ms-office365-filtering-correlation-id: 6106f60b-da11-4fb9-7875-08db8f70253f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hf02YD4Jr32GtJ72O6lHGOTJ0FnAmn/XJfA8B1obLaCl1jVVJ05MMsWZ0RnYRdI+kkpGMX1XC0RqftrXhdNt7U/42PhJRjUfD1ZT+v4LkWLXW2xJvvwekmSOWVHdJoQ1ijt8AOWEu/Y8C5qWl1v1Q21vNj/o5WvwmxYl7yMlSRmbARlFt8rdzrSZVGz1cQ5cRQwGi3eTU64rki25LcNZ1sYAxcsAB+B4glMjmQv9iFUSHDa0zTLkiT7L7T/hz43ZrMz5VwyxAWlwEtEneFZnAJtMhvj/3JwLk6i+7aGpFjI5/1CZ+sxPsGGAkL0ZK4FtB+H3dWuR/PCLDPX56s3klhYwP0XCa6SSvfFJ855gqHJiWTa7Akbm9z3IXcirpBY2089obvgG+veKeVaoc6LGEjydIUhQgI4hObNBfU0/zfaNHFGdRyLzGJKQbPwM4gUnDlfa7L4e/DAYafk+t4KhMcT95VMsSjqRCaUFursI8f6HwWI4MiWNbHTflgaBxQIQWu/rXt5c/GgTsnHkxUjBaZE3Ri9Q3mlR8SxPn9GpQiUGlN4bVSMZn2uROv/PCAbKGoP/9zTfGioau12/8ukaK2VspabwBiOZxAInvUPxloAYwv1J0hGLisWX7ODoRff0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199021)(5660300002)(8676002)(83380400001)(52536014)(186003)(558084003)(33656002)(26005)(6506007)(86362001)(7416002)(8936002)(478600001)(71200400001)(4326008)(316002)(7696005)(64756008)(41300700001)(66946007)(66556008)(66446008)(9686003)(38070700005)(66476007)(122000001)(82960400001)(76116006)(54906003)(110136005)(38100700002)(2906002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nhwAy+dTsaDTMyxZKK4d7F06o4PJxBbl177swTtn2kp9uyYLSpr3ZdeFeGYN?=
 =?us-ascii?Q?pbyVoLnaiEYgLySMfxMzEH8f1K9tNsj68H62HNgQARoi7DUYt+HtDLMn4PZI?=
 =?us-ascii?Q?vUHszDpPffzYYlxEcpdo0FFfzRdGTwFxjysRJbm2eP1wm3et4B2aOOY/keSc?=
 =?us-ascii?Q?E1I2zpsQKswrD7x26rd76AP/T2GlIiYQRwa3Rjv5AksF4OlYpHU5dC9tOCxl?=
 =?us-ascii?Q?9QPQ9ngKZZCmkr27XVFfw1sinOBsLenJ04sKdEZdtBs6qTeWm/VZ5uw1iJHO?=
 =?us-ascii?Q?UI+HsY88czDH/8wcUwtPyyLhu+vlCQmU2OZquDCtWuWQSwr9fHwfs+i+Xuq3?=
 =?us-ascii?Q?YWm4gMkHffaRdFjh6tajm0tVqQsCHm0omBuGzN4P052fk/q5ALwPiuFqNFno?=
 =?us-ascii?Q?6bM7BiuBkMT3nT4jC7C9/5yAsQumtCmPvBnw49WMKJhgx4I9EtlPDmeqZxhu?=
 =?us-ascii?Q?2+CeYK69cRNFTOFotPE3vIkP/ckEiwj4/QqXkaAHUq/8E+jvXDqteV9tDYRq?=
 =?us-ascii?Q?t31goUwfqTyQIAQ5CGRvWNv36iuhdowHAd8DgS83CGFcg5L6ZRztgWzQThMB?=
 =?us-ascii?Q?SM8JaAsKB6EFk9ft1DLPJ1dH3sMNXGnRjEmZwVkyqJlliwZ6XbPJCpoYM2dS?=
 =?us-ascii?Q?NmwjSXTj/nx4U0GhMW9eDafna+yfha/X6ICrAYAIrq/RvlsG1TyCjDloETo+?=
 =?us-ascii?Q?VOR+/ov+lZb6K1cnbvFnI/epoGBGoJI+XDSZuBjsfNBZvhCU5M7kh0Gs3ZHc?=
 =?us-ascii?Q?mK6BvuNRcnmEpbkJu6XyDYD9QPLYWedINox43ipGPivyfSGpoL0fVrlyBMtv?=
 =?us-ascii?Q?dfEd4eJyQzpSQ02rbUyF4zkFc5f+iU4XHDj8Wuc1kmh5x+nwh2PAJ0R0flwi?=
 =?us-ascii?Q?Kc+lUjImM4HXiaPYraVm8We1tZn1XkK+D5EOqIXnEf9AoWxmqd5GFAd1EXOP?=
 =?us-ascii?Q?l6O1wcfqnILZDaG/UjKPq2HvB2K9w8Z2RwkNYDTT42mQs2RvkXom1/9AAWCY?=
 =?us-ascii?Q?A7mHp3f1IZzT2usHiZy/UTebFdPTO+SlSWSLyGRIKXADoYzBGtGIAHa1JC9q?=
 =?us-ascii?Q?YEyQMhjt3aMJBQeKYgyGYg+RGQ4m3KJqs7tt6b0w+WBvxFB7aOxqHTLQBj4Z?=
 =?us-ascii?Q?H6Y/cXY//Pk/B5Ts/NC0CTgBtXse1Pg3s5L+1o5alxZDk0knjiOYiinaDMKQ?=
 =?us-ascii?Q?6chRKCy5qO485O0TanVVHIufbtOfFgJ5aQ0upjKEdUfMcSVWEBt5kz4C3wzV?=
 =?us-ascii?Q?qqnEfI/EqKcZ6wRscOU8AdVBHZSCiikQCKS/wbVUBvPEF6If4eFYmlV5WbxD?=
 =?us-ascii?Q?qOigOkmB93AWqDX6wqsuh8jwgm6eqDjnx7nOm/JYlJ8fhJJUF/602Ejmdega?=
 =?us-ascii?Q?3COdOq5PKhIFbmBNHxEKcscHxDq5pDyJTVGYCSLGNtZ2DI2ZkbkRWYpcY3vL?=
 =?us-ascii?Q?TkaN4kkVqbKUkYXcS65TBB1FMMJAHfIR5qQA7aDarK+ZJaPIUBbg915bgNoC?=
 =?us-ascii?Q?p82cw2RqZzldkV+w0XHwfc77bhNL1VnL43PCc/vV9JQhsnZlgJWKst+Q54Xo?=
 =?us-ascii?Q?VwkdOcd1OUds5rIYbK3RRNTlDTT4VToQYE350iXb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?lRPFWCIVGb6ADUSxRdk9knT69GE0qjUd9qyqZSdwtf56I2VjroLVeXxmU+rz?=
 =?us-ascii?Q?x/HP2nXZWEDTozH4u6B8YzBAGBJOm6XnUJmRwpB3fq5r+jnQU5m354R21x5u?=
 =?us-ascii?Q?I2a7PitX8oT42hupz9Pz8hulAixClz/envSA8RLC9zHUK51bo4+/4OCnU+Dx?=
 =?us-ascii?Q?+1+IlfJH7eNMHex31UUOqqGqPzZA+q4fs2UtXI3ds7d0K3WXSUPK1jpzAr/2?=
 =?us-ascii?Q?0NdYSJ8fzLYFRAO+vQXa6EON2EORsYtzrgFDvAd2ZcsaTtf7E3vbXhi8OPmp?=
 =?us-ascii?Q?BdnsYFxwYgYoUXoq0ymM661leU400VrxzltH1ZYcFb0VR6MjIg+5uVGmHe7F?=
 =?us-ascii?Q?Y9qo0yCXy9XVskVj1UoFnuOFyorloyxzOVNucmEnyKm0HtUkX3QBdaYOZvjv?=
 =?us-ascii?Q?VvEqY1N2vSB1SnVKLvaYqnydalQ8CUBLlSyjVTXost/qRZ/+JZe3VWNdm1HH?=
 =?us-ascii?Q?93OnBgapgVs9NfnIiwUU/0copxqaUDYUID2+EBkuBRNkYJxap6MtIOCO8IjO?=
 =?us-ascii?Q?I8kYfi2UcNT2Mp8u1j3YgzqUQ+tteqQg1DrSYuXoNNrG+hCpmJ+KX62e0q37?=
 =?us-ascii?Q?z/H+w3Im4dyeYydTDVTRcWNbcNnnHnHcsNfmCoIVQmkTkCGJDDtIfmRdsgdw?=
 =?us-ascii?Q?pMrV5TWkRDLYJirnnlfyN7LFQ5YmHfl6tg1BtOhwHR7QBQJ+ZCAzJXSIiUiI?=
 =?us-ascii?Q?TZsVVYndh+dQVM3fblCcXmS5OXYyIvzwYS8KiZNfUjyo/vRWaKN5yMyYf7Nr?=
 =?us-ascii?Q?bblQOqcHG7flsKUnUimrmhTwWgvucOuL/r6Ak0ejHCbFwBeNnyLY6x6NmVcE?=
 =?us-ascii?Q?JuPOOKvSBia9dd5xQg4NmIh2j+j7PTpz+mHIIaW3KGx64TIH6qznjlPgz7NY?=
 =?us-ascii?Q?WQqBmnIpehFdAqdcSw6U/FuO2W6dr43BVQxho6pucJuNn+qJ9s5sH4/NoCHR?=
 =?us-ascii?Q?1NSg/0Hswv3SUUUXsBOeVw7wVA1zuPrmpGOVHsdEFK34Hi8LEuQTro9fKM8l?=
 =?us-ascii?Q?atAgCU3KFCqzDeJcsZ8wP0K8bSMvi/AfNyUbuBHVQQPBFRY2uJZM8a8FpmDC?=
 =?us-ascii?Q?oXPEJi4W3P4TplUDtCDL4IAPo0czfuJcsauRAZIG9b0a8N8MtPNOAC6P7QXh?=
 =?us-ascii?Q?CjSI69UPDH3+?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6106f60b-da11-4fb9-7875-08db8f70253f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2023 13:40:02.6614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 87P31PhcrbVeGBGK+pGc3tHz3m3ugbT8xAxJwQlnpXw0awHEOZ886dartmw9/GTmp44LK7SBRPPaNzy5DJYW8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB8188
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Make the code that initializes UTP transfer request headers easier to rea=
d by
> using bitfields instead of __le32 where appropriate.
>=20
> Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
