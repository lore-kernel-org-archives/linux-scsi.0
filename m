Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FD11865
	for <linux-scsi@vger.kernel.org>; Sat, 13 Apr 2024 11:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713008930; cv=fail; b=UUFg8bYow1ZKKkjTA+z4/wpJZQ2NCRFKYUZTprvOwSPqw5vcAjlkzrpZQ4XTvuWmgeBe7gwAzS2bDjz0fuJf1zqRyjLTEL9cTd2tgyOcqOy5IzoR3X495Puy5b/rsiC0g0TvP4vRh5bg8W+ZfWgFR5zKIlGG53ImIodvENYJjQ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713008930; c=relaxed/simple;
	bh=qPl8VVXEOY3ff7h5d/1GVoVUvXSIwuanoPZASPeoFAE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V19UoGbMpGeeZrpoT5b6mCXRJ/AZYcxYO5lo74xiydpKQXf3kn7VuOhLbNKEyyVDwjQnlHJVBfqGvnd1eOuMhNLOHHV468ne+OmpvzNYfwe5bjylG8m3rENrqqKMU+arZCCwXizfwM3omi1WwaJ+VfbQIXVJeqvksIWur93+OxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=QoJpgeDn; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=LKukuw+d; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QoJpgeDn";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LKukuw+d"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1713008927; x=1744544927;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qPl8VVXEOY3ff7h5d/1GVoVUvXSIwuanoPZASPeoFAE=;
  b=QoJpgeDn03Z9yjnhnu8ozHvtO4HWvr8pIpgxZgHRrPS5ov3jYFeCzHde
   sPg8pqUwF4bWZwk7ocSukJVMCWEDQAzoWzoroxz9YOEMhCz99f2Fxh95q
   bKxykNk1iAs42VPybfAR1Ub/1Y+siDOxu/d1OYtVAxrjIwOxs8UDnzLIY
   ARAJNec7FciLezI1lp9y+QY60hG0EEF7Cz+t4424tf1Wu83BRrm5a8DGE
   Jn/2Rosd1LfQQdlfqJSOwCwXc+V9/kX/WriEIuMVykkEZzXAg/a1kXoWw
   m1baSAlWQe7S3ah0LXV+wjhq397Ew9BZALSCBvoFEu1mRKBeSVfkxSlM1
   A==;
X-CSE-ConnectionGUID: PshaFEyFRKuEiff+o264dQ==
X-CSE-MsgGUID: iMHGNuqmRyupR5sAxTuw/A==
X-IronPort-AV: E=Sophos;i="6.07,199,1708358400"; 
   d="scan'208";a="14617542"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 13 Apr 2024 19:48:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOL/HXqd9vhqhRuZJvFdE8BK2tE2FY/Uzwi/mG7YSvK8IC+VEhQ9D9mBk/HjuUJljd5BUtlU7zKAQfy5PmqpLDdestUhgwWWYwg9xmNU6FSNlJk+Djc1OFvnLJEhRG5oz4c96DL2NEyBWDWPIVA9UVeYDbWwkzZ7GeeEbfBrWt7FJJPUwtMsLNlz7Gi+NRT+/Unp0o++fewAKlh5YFd6DUM44/mVXRMQ/QAYBahe1+PcOwwvm1wviCWafDXJHOM/M8dxJASml7ljsS3yjPqGJO2I8viuqKPNNl4E0hElOi5x7TYVuMd4RgwteewLCbSrJPaoECaPVvnjiAXLRVDxjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HOxD2b3CKM6KyM5DYfrx6Z4oZLCkxJ06BecaioGBNFE=;
 b=fMTVT0u9WFxexZHhVT55cLFQz8e7EprYY93LYRKgs5lBV8QTCRY3l9bVoSHTu9jYGJFaURCqfeSLj1PyG+AEAMtLSXWcELjrLQtCE4IFT9Jc49u6BCM5xYM/NrUfaKH7y4a+JiP6jGIuZ2R+TlTvEcBfVK0irSYvBuBEcD3nQxBj9YlP9ylVjQFQh71i36H8kYbPtpfq6wrTxlcHlHwhtQIdGqBq/I4btRGcHPjkzplul99kG+3PzSZ9GTVu5esukiOXQx5yPCOPMAtrqsiE93OmpY6krjBZGrDpkAXX4n1TWkuMAzelJAHkmim6YubQLU/6qlsFQOla2pcVOvAHCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HOxD2b3CKM6KyM5DYfrx6Z4oZLCkxJ06BecaioGBNFE=;
 b=LKukuw+dhZh/z6Q+grl11j6nsz8AElekmY08VpZJmF0lQ1Lhb1DvQDreNJTn3gqaS454SNXOpN4Hdmjph6s99I9OTeTeXlHah/ZlK0zgRrlujF/k0J40bbdZHv8mCcHjCkpGoKNuMLPwz00naYjrCO9NGhm23ZXb69UJBnZncyU=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CH2PR04MB6918.namprd04.prod.outlook.com (2603:10b6:610:95::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.55; Sat, 13 Apr 2024 11:48:35 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605%3]) with mapi id 15.20.7409.053; Sat, 13 Apr 2024
 11:48:35 +0000
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
Thread-Index: AQHajQDPRxAWKkGN4UqXCGFpQHxBSLFmFdaw
Date: Sat, 13 Apr 2024 11:48:34 +0000
Message-ID:
 <DM6PR04MB657567B296717C428115D487FC0B2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240412174158.3050361-1-bvanassche@acm.org>
In-Reply-To: <20240412174158.3050361-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CH2PR04MB6918:EE_
x-ms-office365-filtering-correlation-id: 0b91e550-bfec-4e6a-8a17-08dc5bafa679
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 gmUsO60wUFUGpnRa+6yBEkfGnRM6O261F1rfYLP+wxK0eTHP5B24Dzto7VxgmTWDGYegbZhUOg3kqf9ubuayTRFxxy9nm5aXHJBiH56DAR5MfG/mX+Qq5227dPNA2i84PvQflnaq/hJSdEVs2VjQjAxoHuqgFdzPf5Y8rnHT4BLIN9uZMxbDG8j45bCrsppx+VO+0tLE+5soByPljXurX+RpVbtHpvaYtqGs9QxCMuBSNvqUovRICQ2bSTAFRiDCMutEnRGXRfuftGsPh/W32twB9Ho5i/yf1J1N5QhYvy/eQIqgqn7xuNcR+j04KOFK7zoa0YiaEpEpbCPrxGuXLaH8AVQ7fCK5KpsWqni5Wdhtq0N6FfGqwZkSQ74Ke7t5S30/X5OpkAnzH5/XW4treIQlmta1InJziFd9e+Aokm/1La/LfPce2V74TeSElTZNeQxNgBhWT03FdjJ7U6yB1h4fSirsMCO+/tm1u4E7Lkl1eaY+8kH9mY3aNgvpXhdtbo6XVzosXyyJaqS9DeqSBEtcRIRY/hQybi/WZw3w1DWYjYV1zZeFlnsGcM8NQ9QDR1jXdbNCny6nnfZgtPI+/um/lKDMnzLhMYhX2zAhmhETgr1+Set9jokRISRFSr3p+Hz/AdwcJYmtlpQo4gGEqEAf11Bsu9jL2MxAFhkn8rGR/31a5IQJeVGCAdgFPA/eRR4O6cRKxEJc+/4iIK5BnJkoR2Zf52vNyJRe7VNNJ2w=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?FydR4qz+bNT64cX8Cid+pHa25Z5MkaGAC21a+OTPoYDghgQNqTxHMUYLr5uG?=
 =?us-ascii?Q?cZckY5Ix6nvZFrMrKGLQla0/RE41H3CJXChh8tithhn0tAKDDNSQnYrP/T+L?=
 =?us-ascii?Q?xY095V18BxM0myDGC5e3BX+Hr/1cyvtIQg+eKctXE17ijcK4DcdwS539oX5E?=
 =?us-ascii?Q?BZ9SZSn+YQ4eroY4xPKF1vQ9iliX2RSLMzHV0B9Gp2OurEjDz20MV1Kiz26K?=
 =?us-ascii?Q?ySvADoJlSV4F8sc+zlzXBT2kAI5QYunhMKi2VhYgq6/ErsI3uWhzquNW8IGE?=
 =?us-ascii?Q?syuH58r5XPAURFjc1MKezxiExeOytQ8tpozMhf2Os4Ntod9d6/b0lvy37XOJ?=
 =?us-ascii?Q?TLk0Rpba0McuBP+1m8rEjPGHD10/G8BF8p6BP19x8ajkA6junhVJGxybbv9O?=
 =?us-ascii?Q?IpxPzDaueNV5hZHYAGb4CJnK80yzEo8IJ9oIZZAldTksQa3wX8WnGpWHxJtj?=
 =?us-ascii?Q?alFjvYignHQEAkfi3L4lC2A9XrA51tRcZj+7fKx4yZKOOALuLiD9mwsiTz0S?=
 =?us-ascii?Q?x5AQ38h+0DKITp4KHiBaVimfiCIDbHVhvdxvkbO7TfM44/drUca5wIKhf70P?=
 =?us-ascii?Q?Kf+BDkkohBfe9mIlopE1JA4B+fGYJajE2vdrK2FYR0Y3oardIY0py3ZGkseP?=
 =?us-ascii?Q?eYnDYeTpTTQEgO1Cmm6TZrXBwV2QrW5wECw09uaKfN7VQuhIC7g9iTjHHUsx?=
 =?us-ascii?Q?AAvXtJnSOlRAUCq9BH0fFVOFgXMyrzb/UjjTnQE/Efl8rxcH7PPutrHQh7rU?=
 =?us-ascii?Q?Lvs8pHxGJuNomUv/aW5oRJ9D+HWsBpopv9MhBbAha+sWyttwihlJVqWAJetL?=
 =?us-ascii?Q?+Q9AYzD0eK9mX7KI/WlsbEbA5QeoRC1w1/+Jf1c4jeU9xi+30xRQRoXIQlVK?=
 =?us-ascii?Q?FZ7LjEDrr/8QLt6KziPm+rqoKy+m8hg0kEnIdRDwx0X+rtA6icWwt5CoTnKG?=
 =?us-ascii?Q?e3V1/dLr8ldVnlgebiVVnF8/td1edXcBjUDWINUG+b2QYACHsIgjGQ2Nrth/?=
 =?us-ascii?Q?h/PhfyBquKqxGMaFpCmHxsKMZU/i6q7eNpDPVbW/IN8xJqMbFmVCLYMXcIV2?=
 =?us-ascii?Q?MnwNKCkWPSbNwZjd/jskMnCkForXmEzsK7W52omdSqdrTyv5xlb/+iKsBO/w?=
 =?us-ascii?Q?Are9pqT5/jf3HbOCbQegRR6oJdYPAKzbykwNOWXr6wDBuDCAIpEdsjRE1cYc?=
 =?us-ascii?Q?tJQD3yKLo7/ctcJSEdzkpV2ODu9kWR/R6n2HryB/EjWtcjNGrD2NoWUfEOgV?=
 =?us-ascii?Q?PoAWXbXcIP2z4bT9gaUOgVKYA/GvSbdgrZJSjg4EwW39ga6PyesDv8yYqVUM?=
 =?us-ascii?Q?/PaTnTymZaXXCvoKzWCl2fpC6xbngRNfllNHGjUGzhVo5gLOYuMqTPV+FcZE?=
 =?us-ascii?Q?OU6pWmaP6z9ukFOHOMUCFFyLltMvCiijTureJLwGvJQGLuehLURbmzSBCG62?=
 =?us-ascii?Q?A00PE3UyyjyoQnY4pvVMUhcmRI5yzp4Okd/lfyDBzUYVDxLjR/WL2HvSsPTl?=
 =?us-ascii?Q?SYJx2JhX48AtMPhN/24W5irewvYC4lE9Edwu3YKy7OD4zejlhvRaEJ4kvpS/?=
 =?us-ascii?Q?pQpJJT92P8WF4Ls4YO+uOAegibbKQNgDk+OmpINw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sqXSF1Q3+rZKe2jRz181eFHa73UBHU/n7MKpwKe3izwqG+NTByfGA5OlqCM7WemFcQHJyrhJIkC29lUcg/y4SdTxSqmLJOu6VcGXQ7H5Chq0gmSaqrkIxjb7Xjua3afaqZO84+EwSYkonYPIvDqBXtXqYmecEeQUvoK3cAadgLAWq/+LXqQBUFt5FOEJrVzANedzayKKx9oTKozMsXHBj9oWhXSH2YW61I2d3KIW9JEkTdoQOVCSE3osj7hLFioyrorM6zqEGykWSjY0F35W5e9gPgQCf0WAIMoZNYBt9Aw6iN/LhLQQgv7z7ABohxO9WF6ENxwbnI+xfv/AYgq7/Jwjvk8fG/sMry5jVs3Iz4NSjHXiNKyjLkcOFO3kaG4fN++xCMISSTsveMe6FcvbtG+b2cmGq/xkFP+iakAl97rJOPY7IEA8alydQa6fnsm5oB4rlbUYgQedklZbzS9KQVPWKPsz3ROxkXXFwsdcks7jvuuW96sVctLIeiFvApExirwOvm2j/iiEw/Jjf7NUASJL+OXrzWSfgPMCUcnbzuJWyyndn3PKgnLhrUsCD0fsYGtqFhRbfCwIIu69cQN5ItVdaO+G9TJ/PAE67EUTNpXTAzc6lcHo62TN2JX6ArFU
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b91e550-bfec-4e6a-8a17-08dc5bafa679
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2024 11:48:34.9878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c9hOGZPNWnRA+cf+RlC8Nz+KniJpjF+x+ZPxI0yWdbJucAMIkw8azx9zGf+H0DDw3WiFHPxVhAYz6WoAWpkbKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6918

>=20
> Simplify the UFSHCI core and also the UFSHCI host drivers by removing
> the .get_hba_mac() callback and by reading the NUTRS register field
> instead.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufs-mcq.c      | 14 +++++---------
>  drivers/ufs/core/ufshcd-priv.h  |  8 --------
>  drivers/ufs/host/ufs-mediatek.c | 13 -------------
>  drivers/ufs/host/ufs-qcom.c     |  7 -------
>  drivers/ufs/host/ufs-qcom.h     |  1 -
>  include/ufs/ufshcd.h            |  2 --
>  include/ufs/ufshci.h            |  2 +-
>  7 files changed, 6 insertions(+), 41 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 768bf87cd80d..228975caf68e 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -125,20 +125,16 @@ struct ufs_hw_queue
> *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
>   *
>   * MAC - Max. Active Command of the Host Controller (HC)
>   * HC wouldn't send more than this commands to the device.
> - * It is mandatory to implement get_hba_mac() to enable MCQ mode.
>   * Calculates and adjusts the queue depth based on the depth
>   * supported by the HC and ufs device.
>   */
>  int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba)
>  {
> -       int mac;
> +       int nutrs;
>=20
> -       /* Mandatory to implement get_hba_mac() */
> -       mac =3D ufshcd_mcq_vops_get_hba_mac(hba);
> -       if (mac < 0) {
> -               dev_err(hba->dev, "Failed to get mac, err=3D%d\n", mac);
> -               return mac;
> -       }
> +       WARN_ON_ONCE(!hba->mcq_enabled);
> +       nutrs =3D (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
Isn't this already hba->nutrs?

> +       WARN_ONCE(nutrs < 32, "nutrs: %d < 32\n", nutrs);
redundant

Thanks,
Avri
>=20
>         WARN_ON_ONCE(!hba->dev_info.bqueuedepth);
>         /*
> @@ -146,7 +142,7 @@ int ufshcd_mcq_decide_queue_depth(struct ufs_hba
> *hba)
>          * It is mandatory for UFS device to define bQueueDepth if
>          * shared queuing architecture is enabled.
>          */
> -       return min_t(int, mac, hba->dev_info.bqueuedepth);
> +       return min_t(int, nutrs, hba->dev_info.bqueuedepth);
>  }
>=20
>  static int ufshcd_mcq_config_nr_queues(struct ufs_hba *hba)
> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
> index f42d99ce5bf1..a1add22205db 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -255,14 +255,6 @@ static inline int
> ufshcd_vops_mcq_config_resource(struct ufs_hba *hba)
>         return -EOPNOTSUPP;
>  }
>=20
> -static inline int ufshcd_mcq_vops_get_hba_mac(struct ufs_hba *hba)
> -{
> -       if (hba->vops && hba->vops->get_hba_mac)
> -               return hba->vops->get_hba_mac(hba);
> -
> -       return -EOPNOTSUPP;
> -}
> -
>  static inline int ufshcd_mcq_vops_op_runtime_config(struct ufs_hba *hba)
>  {
>         if (hba->vops && hba->vops->op_runtime_config)
> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index c4f997196c57..0a52917e7fe6 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -34,7 +34,6 @@ static int  ufs_mtk_config_mcq(struct ufs_hba *hba, boo=
l
> irq);
>  #include "ufs-mediatek-trace.h"
>  #undef CREATE_TRACE_POINTS
>=20
> -#define MAX_SUPP_MAC 64
>  #define MCQ_QUEUE_OFFSET(c) ((((c) >> 16) & 0xFF) * 0x200)
>=20
>  static const struct ufs_dev_quirk ufs_mtk_dev_fixups[] =3D {
> @@ -1656,17 +1655,6 @@ static int ufs_mtk_clk_scale_notify(struct ufs_hba
> *hba, bool scale_up,
>         return 0;
>  }
>=20
> -static int ufs_mtk_get_hba_mac(struct ufs_hba *hba)
> -{
> -       struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
> -
> -       /* MCQ operation not permitted */
> -       if (host->caps & UFS_MTK_CAP_DISABLE_MCQ)
> -               return -EPERM;
> -
> -       return MAX_SUPP_MAC;
> -}
> -
>  static int ufs_mtk_op_runtime_config(struct ufs_hba *hba)
>  {
>         struct ufshcd_mcq_opr_info_t *opr;
> @@ -1801,7 +1789,6 @@ static const struct ufs_hba_variant_ops
> ufs_hba_mtk_vops =3D {
>         .config_scaling_param =3D ufs_mtk_config_scaling_param,
>         .clk_scale_notify    =3D ufs_mtk_clk_scale_notify,
>         /* mcq vops */
> -       .get_hba_mac         =3D ufs_mtk_get_hba_mac,
>         .op_runtime_config   =3D ufs_mtk_op_runtime_config,
>         .mcq_config_resource =3D ufs_mtk_mcq_config_resource,
>         .config_esi          =3D ufs_mtk_config_esi,
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 0b02e697ea5b..100f5f0b9da6 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -1673,12 +1673,6 @@ static int ufs_qcom_op_runtime_config(struct
> ufs_hba *hba)
>         return 0;
>  }
>=20
> -static int ufs_qcom_get_hba_mac(struct ufs_hba *hba)
> -{
> -       /* Qualcomm HC supports up to 64 */
> -       return MAX_SUPP_MAC;
> -}
> -
>  static int ufs_qcom_get_outstanding_cqs(struct ufs_hba *hba,
>                                         unsigned long *ocqs)
>  {
> @@ -1798,7 +1792,6 @@ static const struct ufs_hba_variant_ops
> ufs_hba_qcom_vops =3D {
>         .program_key            =3D ufs_qcom_ice_program_key,
>         .reinit_notify          =3D ufs_qcom_reinit_notify,
>         .mcq_config_resource    =3D ufs_qcom_mcq_config_resource,
> -       .get_hba_mac            =3D ufs_qcom_get_hba_mac,
>         .op_runtime_config      =3D ufs_qcom_op_runtime_config,
>         .get_outstanding_cqs    =3D ufs_qcom_get_outstanding_cqs,
>         .config_esi             =3D ufs_qcom_config_esi,
> diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
> index b9de170983c9..7951421b9921 100644
> --- a/drivers/ufs/host/ufs-qcom.h
> +++ b/drivers/ufs/host/ufs-qcom.h
> @@ -14,7 +14,6 @@
>  #define TX_FSM_HIBERN8          0x1
>  #define HBRN8_POLL_TOUT_MS      100
>  #define DEFAULT_CLK_RATE_HZ     1000000
> -#define MAX_SUPP_MAC           64
>  #define MAX_ESI_VEC            32
>=20
>  #define UFS_HW_VER_MAJOR_MASK  GENMASK(31, 28)
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index bad88bd91995..3f50621b8564 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -324,7 +324,6 @@ struct ufs_pwr_mode_info {
>   * @event_notify: called to notify important events
>   * @reinit_notify: called to notify reinit of UFSHCD during max gear swi=
tch
>   * @mcq_config_resource: called to configure MCQ platform resources
> - * @get_hba_mac: called to get vendor specific mac value, mandatory for =
mcq
> mode
>   * @op_runtime_config: called to config Operation and runtime regs Point=
ers
>   * @get_outstanding_cqs: called to get outstanding completion queues
>   * @config_esi: called to config Event Specific Interrupt
> @@ -369,7 +368,6 @@ struct ufs_hba_variant_ops {
>                                 enum ufs_event_type evt, void *data);
>         void    (*reinit_notify)(struct ufs_hba *);
>         int     (*mcq_config_resource)(struct ufs_hba *hba);
> -       int     (*get_hba_mac)(struct ufs_hba *hba);
>         int     (*op_runtime_config)(struct ufs_hba *hba);
>         int     (*get_outstanding_cqs)(struct ufs_hba *hba,
>                                        unsigned long *ocqs);
> diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
> index 385e1c6b8d60..6c28177113e1 100644
> --- a/include/ufs/ufshci.h
> +++ b/include/ufs/ufshci.h
> @@ -67,7 +67,7 @@ enum {
>=20
>  /* Controller capability masks */
>  enum {
> -       MASK_TRANSFER_REQUESTS_SLOTS            =3D 0x0000001F,
> +       MASK_TRANSFER_REQUESTS_SLOTS            =3D 0x000000FF,
>         MASK_TASK_MANAGEMENT_REQUEST_SLOTS      =3D 0x00070000,
>         MASK_EHSLUTRD_SUPPORTED                 =3D 0x00400000,
>         MASK_AUTO_HIBERN8_SUPPORT               =3D 0x00800000,
