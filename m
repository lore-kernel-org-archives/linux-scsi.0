Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B3B13C80B
	for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2024 11:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713352671; cv=fail; b=IqI1ublUNRgFYv0ad5jgv8zN5k9fl9ZSLBrd+JQZB+x4o6y8P0c89Hfkx5uw4HbYueaBYlTeJmQ00TBnsygZHAGNc+CR23NS3XOLXU3IiLcJN4yZw3ywDKLs/mz9ehBjL+a3IdFtvfTOWKwaNKwOm+mZX4Sj1uoY9lUaZp/YR0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713352671; c=relaxed/simple;
	bh=TH3wwn5e5ZRi9CciTf+tJlZgoSqr60FgMYi2klIoJZQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ne7wE4enOvVgn0qDug+ADCOjf7v/GbzOFgg0DWZ2PBtqtC7Q58OvPFhWH7WUT+GTPPe6CKhG8/jG/KCfM9OPv6n/cuu83zue6kbEKcgW4/jSwarC0KF0xxZvMI1C0xUVIG5l3Wu4N1D7+ug9Gj/UtJ8x9AtUM5VSd2PHDJNq22s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jpCfebsx; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=vyRWuhqL; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jpCfebsx";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vyRWuhqL"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1713352670; x=1744888670;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TH3wwn5e5ZRi9CciTf+tJlZgoSqr60FgMYi2klIoJZQ=;
  b=jpCfebsxNcVLlVdqhLFBI0lATO01k+scziArzib7M338+HkumI3Mu2tI
   6C+ghO34J5GtrnOhvdLP0jFitR+xpbjt14zaain8+YVQYXtt7NqUvzvjC
   9+dHO+ccG4dNMpBtFggDDyCOmL2o1ZiLcMgrefz2i/F1T5csUFqChEKrg
   nw1fjuYlETbBuPjvmX5NPeSI9Crg4PALehN5/yLLqM7+2uEzFk43Zmvlt
   iGpniKaAtGeVPjo5tx3Iddt/rKJC+A3GYk01AsmIXZ2w/UEtCMsXQHNAt
   nWGlOZ5/XhGiT4WUIKh+y6qNp3ovIIzi7Lc/x6/r+WKF6KIaJOicnxWKp
   g==;
X-CSE-ConnectionGUID: ofr3tPW8RLqx/gjXqPbxDw==
X-CSE-MsgGUID: XDdYb9aQRuiLbnFjmkUNPg==
X-IronPort-AV: E=Sophos;i="6.07,209,1708358400"; 
   d="scan'208";a="14008929"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by ob1.hgst.iphmx.com with ESMTP; 17 Apr 2024 19:17:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9DjnZVZI2kPZeJv0Vzru/czkPWVL6xp8rWCRLRJ8909x25BYN24EoH96zlcRLYHyXYOAX1rqTrEAHRvtbbTSLn/Jhz3NPu2G6O0BEgkZRVHLZl30deCGcl0qZASKcGHE/wcnB/dKXmtahUrRYhZKZSBHHdvMuMB/+6DaU6K0f7GaaTkHAYs738tBZyQyyt86g1omhJ/wIXZU+nWSlkRUoTAci5WWwaI4KuwUFLUEtEEYJg7zLtQF8GX0iqv5JgAqpXe7kffaVrkkxHu712BEp/Hk3JDUbmzskO3lro6EvtvjfSHOz2Vd1h8H8uODUMHlZwrwWDNcnMj1IKS1R7p7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TH3wwn5e5ZRi9CciTf+tJlZgoSqr60FgMYi2klIoJZQ=;
 b=jpx+JFTNqNxkyuykwzyBcYWNVl1k653hRwaHpIxNjt9XOgzYkKi1k0HGegzyon2MK6Xji+4I/iq+42Z5foX3VkzWH9pg1YXXudRjXLCLxGkRmXDSqZS5UQNhXtRds7acbwr2lScOJ+5JbEUSsRCz6n83cnNG6cciTydBQ2PSNeXvkYMMwOr287O5kcTEQq4kBSLC9uiBUCSr+2YdMAOZg7csLie2qtLYOP1+odjEnkd2ntcImCDdSiOUkJgxhRUOq+O4CW7J6SqWEWiOwb1RvcjjYcPP8NsEu8+MWtLNNQhF7q2n+uyOKi4Qj7sMT/OFe+MLvIzLfw+iDwaKOVN1cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TH3wwn5e5ZRi9CciTf+tJlZgoSqr60FgMYi2klIoJZQ=;
 b=vyRWuhqL+rP5s4vsayVNBxQxdN0XuRS4cmpfPoqGBMusOxrV0aKMnIUF++8ocOvQC5r0TcLtwahLlCnSi+xS8/Q6dr0fxH99C4Bu6ETlIJI0yUTGhcL+jC9+CCIhJh+VCbWe1krLdMbST9Ww9rqMnjcA8CkwRhYmp+z3VJxkj+c=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BY5PR04MB6597.namprd04.prod.outlook.com (2603:10b6:a03:1c5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Wed, 17 Apr
 2024 11:17:40 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605%3]) with mapi id 15.20.7452.049; Wed, 17 Apr 2024
 11:17:40 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <jejb@linux.ibm.com>, Peter Wang <peter.wang@mediatek.com>, Bjorn
 Andersson <andersson@kernel.org>, Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Matthias Brugger
	<matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, Stanley Jhu
	<chu.stanley@gmail.com>, Can Guo <quic_cang@quicinc.com>, "Bao D. Nguyen"
	<quic_nguyenb@quicinc.com>, Po-Wen Kao <powen.kao@mediatek.com>, ChanWoo Lee
	<cw9316.lee@samsung.com>, Yang Li <yang.lee@linux.alibaba.com>, Keoseong Park
	<keosung.park@samsung.com>, zhanghui <zhanghui31@xiaomi.com>, Bean Huo
	<beanhuo@micron.com>, Maramaina Naresh <quic_mnaresh@quicinc.com>, Akinobu
 Mita <akinobu.mita@gmail.com>
Subject: RE: [PATCH] scsi: ufs: Remove .get_hba_mac()
Thread-Topic: [PATCH] scsi: ufs: Remove .get_hba_mac()
Thread-Index: AQHajQDPRxAWKkGN4UqXCGFpQHxBSLFmFdawgAAqe4CAAEjFkIAFzluQ
Date: Wed, 17 Apr 2024 11:17:39 +0000
Message-ID:
 <DM6PR04MB65753A070CFEDE98468E982BFC0F2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240412174158.3050361-1-bvanassche@acm.org>
 <DM6PR04MB657567B296717C428115D487FC0B2@DM6PR04MB6575.namprd04.prod.outlook.com>
 <cc6ee1c4-8ce3-4016-a085-6bae84754690@acm.org>
 <DM6PR04MB65756DF9F19CA664768333E9FC0B2@DM6PR04MB6575.namprd04.prod.outlook.com>
In-Reply-To:
 <DM6PR04MB65756DF9F19CA664768333E9FC0B2@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BY5PR04MB6597:EE_
x-ms-office365-filtering-correlation-id: d44fa0bb-3e6f-4b48-01cd-08dc5ecffe79
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 LLdm3xhs+HcEs/RyWWVWeyvkXbn+WNkPvY/tGyLREJKmQTLl1O85ozXZIkxd/0SsbWItdWWAsFamNfEVXkodOJOTZYZqlzOqsXcEzY0CVebwdAUFrwU3HYewqR5k4OXqLuLoO1jo9ficeKdyPUSeyGQBgij4TyeiZWTRduMbOQuP0Q9qL+NMAj0zo9yo8qNZAn2crKEEm6m2AbM/c/nwz0Nydc6AgMU3uPUbQlxIPJXcDq0hSYjkUc6IHkFWk30numCngWW2n2Jnakta/XlaNbIykCKnqafRFgJRuudyxMg3sELSHyOG71ugiYflkKljTwL5tZoRb5hzvvO6d532EFXW46YMoetql4MyRqTZVsoQQxA9/ogEI3NcgzxJWDHAb1KI7kbUAtUtzij974a+hBVILnHx6eYaggL7yYrSW1IaKZ39ioM8maW5dKSKL0/Hrs8y6V8xLgJLgMQY3KOviGDf/gUs0s1teHSyL7yso/Li+2PvLhxO9bAkjBqE0xKIQFuPamAEbPvSb8luJrXaZ52LuCBR1RCgd2+G2kKtAvHk2O0pRtMByH+EN7PlssPD8LIv/3gw3LMKfFOGA4F/Fxm+QBfpGY6uKKmViDogNJTjb1w3n+ahAe1vbj8vifZatP1RrzAA7dyih61KRoGIz1F9MpfS3HaIe5CLWT+OTTzXxz3FImsRiaaILk2GgQ3yoMvzuFgM79F23LRKnyE1pxMIJfLiWobOMP8cgDfypP4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TVp2Q1IvUVZ1Q2wzSWJ2KzRQSlltL0hjUW1rdjFoYkp5eEVOcFJGSUVFempj?=
 =?utf-8?B?Q3E4WkxjbzlpNW1LTWp0aHdtK0s3R2tWRkJLZHJDczNkMFJvMWtTZUJSYXFM?=
 =?utf-8?B?bkhDN3o1K2diR29nNTZsT0NDQ0oyamZoTU1ZQUxFWmdDRzR0VzZ1ZE8rd1Vm?=
 =?utf-8?B?ZmtZdWwvclZLVHBlQVdjaVRaM3drZGp3c1haMEEyd0pIcVp0dHlqUkFGWUdI?=
 =?utf-8?B?RkJFR0YweElWcTBMRDNCK2tycjFxNDVsTWtpNUZUR2d0ZlJXR1lmdytOVStS?=
 =?utf-8?B?WmVLSGVHZXRvallxU0F4MzVMaG55Nm13SVAyRmFUWHpHeXc4eGViOXlHM2pU?=
 =?utf-8?B?aklzNm5uMVZXNXhjL2ZGbWpKUGlsMkZVNGYyd1BXcFlucGZNdDFwdlhDeVo1?=
 =?utf-8?B?b2NDNFptblpablY0cGRnU3JITWdTYzlCb2hVRmhSV0dUUCt1Z0JTdGgxZU5v?=
 =?utf-8?B?emN2VWNkZ2h5dlgySnFWU1p2NzNDUmZjaFYyL3hIZlgyUFowY1JIRE52Vjd6?=
 =?utf-8?B?TkZ5a0ZvQ3RyRzhDM09Zbnc5TnFxQnRIYzFhd3JnaGh6L2ppeXNrU09LbkVD?=
 =?utf-8?B?bDVKRmFIQ2syODdNcVljN0U3b1krWVN6bDNkSUJiSVdaTjJaV3p4eXkwc2ky?=
 =?utf-8?B?WjZ2UFJaRGNqTytXRkVYQWtoR2VpS2EvZEl5ektTTW92TnpLdExEditZU1h1?=
 =?utf-8?B?Z2I3Y1dnVEcwTHd4MVhadkxRQ2ZEOVp1SGpvWHVkNnVGMjh5OGJMWGdOQXNG?=
 =?utf-8?B?VC83Y211K21UaFRxaWFyUVVZSUduclo4QXhLTnpKNnE5aWVhdU5CM3hYSENl?=
 =?utf-8?B?QlBYNHJPa0xESjN3VmNFN25wemlVZW4vN2p0NUNaVWc2UXFIZExhZ1YrU2g5?=
 =?utf-8?B?eWJTUVo2dE0waXN6MzhBRTFpNkZoZEpzcDIxS055NHRxWU5VSmxSSEoyTUpH?=
 =?utf-8?B?aUFQaGJlQ1BZNnJ3NEtiSWEzMEZzMkhQRjZGRmFkZG5ua1prdEhsZDdFblRS?=
 =?utf-8?B?RnVjRnF5YlJ0ZjU5UEVpSzNwd3RFcC9lQ0RHa2tYNnVORmdDWTQweHZIS2po?=
 =?utf-8?B?YWVTRkV4QWhNOTFENnlxRWVCYmIxZzY1UzNrakF6bElSL1NCc2hYcEZlSHFs?=
 =?utf-8?B?cGRGSVozcjJvbitqWTdTQTQyT3NHbm1ENTRPKzIxRVZibXgrSHBwMVVKNlVE?=
 =?utf-8?B?Y1VJSlF6aVNZYzV6SEs1U28yTEhBTm9wR1gzWC8xbUZmQXVwY1pPeDE2ZUNM?=
 =?utf-8?B?WFdxbU9yaVd5UEhOSGRuRjM0OThOQTd2SkkvNWhXYUhsTnptbzVsMGNEYmRx?=
 =?utf-8?B?K2l6L1BpYmFlZGVHRXBqYzZOU0VSb2o4czlheGpPQjJEUCtVVDVkKys0a2tY?=
 =?utf-8?B?blNwVGt6Y2dGVG1JOUczMmlyTm04d2pUaGE2MnJkdzU5SlA4eTQxLzF3Mzkv?=
 =?utf-8?B?c3U2MU9zWDMzdFd4S1ppS0UxTG1ycWRRV0d1cThqOWV3VktQRzBVTHpvbDhy?=
 =?utf-8?B?eWdpeWZFbkhGcTJzMUViYmMzRmRtSDNHb1I1amI1SWlOMVZsdjNyZ1UwYnRK?=
 =?utf-8?B?Vk1KZHZndHEyaXg2czJxR2xtcnpBd2sxV2pNSWR5UFkvRUtDVCtHRm4vbWhD?=
 =?utf-8?B?amU2UUR6WjQ4aWlVM2QvRjhySjQwdDBDc2hORDRIWmdMUnppZE11TkFPTnVj?=
 =?utf-8?B?YjNOVDE3clByNUliLzNabnlQS25SbytWVURvdHAzRWgra0MxeGpKeHJaeWJK?=
 =?utf-8?B?SWkyL2hVNUR5eEE2L0liUUs5VXM4cXY0WTdyZkVPeVZoSzBCbnplM3pLTk9o?=
 =?utf-8?B?ejd2dnZkczhwZlQwbkhkK3MwMjhjSFNjTHZBSHl0b0ttWUZXRVN4STZmWGVO?=
 =?utf-8?B?WXFON0ZYOC9PVTB4S0dUcnBLV0dnWkh3MzliL1dzcXYvaWNlNjBOWW4rTWlT?=
 =?utf-8?B?ZXYxUC9zeHJzT1dMOUN5a2lzV3RaSktxWjEwTEJSTjAwa0NjQm1jS3ZBMkxT?=
 =?utf-8?B?T0FsTldzTXZLeFAxT1d5Q1hTZDhZaWsvNXBFazJIQVRpbHVpa0h2bkFERjFC?=
 =?utf-8?B?cUFwS3orUlAwYmJVVkRnN1hGbDFVUkdCUnhSNFhSYWlFS2dGeWpSeU9ZMmtQ?=
 =?utf-8?Q?c8keZ2v4FiXMdvbmqPQkYVrmX?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nGm1A+IY+QkqOfa1GWHJy/Hu0Tw/Y+jVvZrM0pocKMIbxh9zUlcQgvX+tZXUvNWduKvykK+xzgztCYzt0uZBn6PNXm7ObPkbbQB3DM8zusxZBQ65rQsQmz7VGGH1g4DLx8wUrHQB0JQ8jn8MHF3W6Cai4vLMS8dwO97K80FEuudfP6lQMNVJJLnydc124M76hsdmO7HxgWkNNtof0M4oma4jM2fmzifugYWs9z1pnJ39mwfnX3EFKCfnUTrrAHb5zVjgxpCiPx5gBv+BGFZI7PsCIwYykDxp2aaVgZE7R1RyJj2NvzPlf/cls3xqT6bcwu5RedwUSsQvAPEXrDZcE17T6i2tC2NkxtsvtzWsSWhIyomfd6Qfgj9jRnaL/DJLP2Cljnn2UwZtIiDyeDOy50fztIcP5pyRpFTIg9S+Wnah7UMKIxTEoN9xgn9S1fQsLgGD6tcM5G56vcd4Y56C6OOqfWBb3RfAGoCv9zTSvW2rZ+SLyPc5XGvaZHlRVdRzoiFXr7Gxqh6EAN7utMgFjxwQNZFYeg+MKyBxzMWMUyJOccymEc9wzb27XAH1Dk5yYsGOjeIuMeyatRluFBfIzrd2Gu8y/vynDQdpt2UO64IoCSyOjApYoEZD4rYrLbRG
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d44fa0bb-3e6f-4b48-01cd-08dc5ecffe79
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2024 11:17:40.0250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6OWwptfG3OgAzCTkThJKKs5oa9uWltYsjgUsP2JOVCwQ11eifOk5LFLx3j169YTqIng7Vp5mFVrsi6s53N28+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6597

PiA+IE9uIDQvMTMvMjQgMDQ6NDgsIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+ID4+ICsgICAgICAg
bnV0cnMgPSAoaGJhLT5jYXBhYmlsaXRpZXMgJiBNQVNLX1RSQU5TRkVSX1JFUVVFU1RTX1NMT1RT
KSArIDE7DQo+ID4gPiBJc24ndCB0aGlzIGFscmVhZHkgaGJhLT5udXRycz8NCj4gPg0KPiA+IEVu
YWJsaW5nIE1DUSBjYXVzZXMgdGhlIHZhbHVlIG9mIE5VVFJTIHRvIGNoYW5nZS4NCj4gQnV0IG5v
dCBieSB0aGUgdGltZSB1ZnNoY2RfbWNxX2RlY2lkZV9xdWV1ZV9kZXB0aCBpcyBjYWxsZWQuDQo+
IHVmc2hjZF9tY3FfZGVjaWRlX3F1ZXVlX2RlcHRoIGlzIHdoZXJlIGhiYS0+bnV0cnMgbWF5IGNo
YW5nZS4NCj4gDQo+ID4NCj4gPiA+PiArICAgICAgIFdBUk5fT05DRShudXRycyA8IDMyLCAibnV0
cnM6ICVkIDwgMzJcbiIsIG51dHJzKTsNCj4gPiA+IHJlZHVuZGFudA0KPiA+DQo+ID4gV2h5IGlz
IHRoaXMgY29uc2lkZXJlZCByZWR1bmRhbnQ/DQo+IEkgc2VlIG5vIHBvaW50IGNoZWNraW5nIHRo
ZSBody4NCj4gQm90aCBJbiBsZWdhY3kgJiBNQ1EgaXQgaXMgYWxsb3dlZCB0byBiZSA8IDMyIC0g
d2h5IHRoZSBXQVJOPw0KSWYgYW55LCB0aGUgY2hlY2sgcHJvcG9zZWQgaGVyZSAtDQpodHRwczov
L2xvcmUua2VybmVsLm9yZy9sa21sL0RNNlBSMDRNQjY1NzU3MjAyMThEMDZDM0VGOTcyMUJGMkZD
NjM5QERNNlBSMDRNQjY1NzUubmFtcHJkMDQucHJvZC5vdXRsb29rLmNvbS8NCk1ha2VzIG1vcmUg
c2Vuc2UgdG8gbWUuDQoNClRoYW5rcywNCkF2cmkNCg0KPiANCj4gVGhhbmtzLA0KPiBBdnJpDQo+
ID4NCj4gPiBUaGFua3MsDQo+ID4NCj4gPiBCYXJ0Lg0KDQo=
