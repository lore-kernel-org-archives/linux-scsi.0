Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD745B1E8
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2024 08:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712912148; cv=fail; b=HTEy38k7yY7jAeOxEA49Y+WDHGsSyGL6YottoEoVQLk4hnEQGayaWf+VPcl8p1FEaVxGKFTT9j/VggmjOLwwaqWqlKKzwi/d77nA1rqbXgxU93AyuEMPzqIzgJGxxco5A7VEmrNgdap7b2xcbUgWjSX4QnneYu8VurXFOiXjU9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712912148; c=relaxed/simple;
	bh=VgxK+v/IhDL9iG5M18zEYfeniaCrbNxWYJgf7wsCfTU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cMOD0WYlDOWIOOo5RJoa4GYm0ZmQty9rAfK4FSYafVxqIHhAZrBUZYi2ktbGKI6g+R1K218P1X/rUQnlkFXIpit/zPLdfgAM3qDo8w4IQGZs+p6LinHu0dbcQuxFmSfddjzzYelEYwaqXNKXohnwX62c5O+oKIPSlRcEsF2Iqu0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=DsQkfncM; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=lTvEayuQ; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DsQkfncM";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="lTvEayuQ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712912146; x=1744448146;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VgxK+v/IhDL9iG5M18zEYfeniaCrbNxWYJgf7wsCfTU=;
  b=DsQkfncMbLSF0uDORyqm+pe35nc2N/0/p9ymA8xQxPWMoG0DJy/R7LUx
   fuDdKP+2I7Zb1dkk2KsMD9AMJA9qumwhwAXIEYrET3LP7WmwvmdzfXxIW
   vSFIxcw41ON9C3RpX1C86IZ3uu16fZySBLz/yQ6khMct71tut1S4w/Vvg
   zDHtOusAb81paGwTEp/nOnR4OnaFpuHZ8XsJARBpj2BqoyPfMEOnzqFXY
   oJRpgjvDnmtQHKWrKuliNRIaoDOT+F1yq3V20O9oDG1kXaef8E49YbxIJ
   0HsE0dSF8RAA7RUpNIevfczcuU33XmNx+9SP4TLmy9CP0XBIkJ8Us7xua
   g==;
X-CSE-ConnectionGUID: s4iw5xHBTYSSHNrinZ4u1A==
X-CSE-MsgGUID: LJAvyHeURgajEavzdBWOIg==
X-IronPort-AV: E=Sophos;i="6.07,195,1708358400"; 
   d="scan'208";a="13843058"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 12 Apr 2024 16:55:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jmpiGR3EhUWFBGSZS90ey0LWaX1Rc5eoBdCZ4RnzUbugO6mbePlrRBQFmAL8TFZBCljAz630VBLwEXMwalxjEuUdb/Sov7rHQbTImtnjqIxPv2e49TreBO9lzOZ/OLMlzP0LeChDvD/Am77pNQ+ojFISeMeid0etcHfXLmfQPhxVpmYanwqAOwNKSS8FsrhIRAKOdE3rxGZpo7O9KqGE34ozX4I+InmqJCLI4jdc77PTCKMe1oXO6n7Uvp6bNh+2WuM9p74bQT7t9PhJyzl0PgnatzkKJjmyjeAhKBuj9+wopY/w7786jG5WdOmH2L9btQgT7Fz0EhZzqbYeaUXjDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ENJwII8GVbUlHYkdiEB4CnvJvm/NKqxm5Gninv2uVNE=;
 b=O+ptHwk5bvSvjUTu8xywb09+tvRFxvtJ5wTSc0tjNdi3e7wGfv0wbcXkOYkdz3uJVpjCnGfK7k1mNquMrdCKgmAIhDTsITbqezthr8IF+QZwpN25oynfFLYenD2q6WX1pRos5KI96vCS0PfS9g3VR6B/xD+c8gq2mgatByUnsJ8KFPFo7WkQBqrabZc5wyoI/UmWPIGtPh//aWVVshDKMVc1ZhiYtS26PrgZj32nHG1dTPN07a4kNOUmPHohvizbGnVGzD4kIPS4+iNurIVI/sMDuf+e8vbi/9cTOeYWoi1it3m9ydcz4YFmx4jhKVKrbD2eve6H7CwoPP5buoAJog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ENJwII8GVbUlHYkdiEB4CnvJvm/NKqxm5Gninv2uVNE=;
 b=lTvEayuQ4dyrnhzdcWyUHkQbS3evnu74m77LVkT/ixYCFJHqPqPXse7bhnoYH33Pz1tbUD1eXMV1pGGB3e9p9dhhKtY6wEjW2OTf09WaRI2AjNrQRteY6lJT6isPuSfYSaSdP4EimMYRPvekmUgk67r63MbJ6SOnJskFiTDq86E=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6623.namprd04.prod.outlook.com (2603:10b6:5:1bc::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.46; Fri, 12 Apr 2024 08:55:42 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5395:f1:f080:8605%3]) with mapi id 15.20.7409.053; Fri, 12 Apr 2024
 08:55:42 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <jejb@linux.ibm.com>, Stanley Jhu <chu.stanley@gmail.com>, Can Guo
	<quic_cang@quicinc.com>, Peter Wang <peter.wang@mediatek.com>, "Bao D.
 Nguyen" <quic_nguyenb@quicinc.com>, Bean Huo <beanhuo@micron.com>, Manivannan
 Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: RE: [PATCH 2/4] scsi: ufs: Make ufshcd_poll() complain about
 unsupported arguments
Thread-Topic: [PATCH 2/4] scsi: ufs: Make ufshcd_poll() complain about
 unsupported arguments
Thread-Index: AQHajGzQ/wpGC7t1yEyCmRQi/1u20bFkUj0A
Date: Fri, 12 Apr 2024 08:55:42 +0000
Message-ID:
 <DM6PR04MB65752B7F3564227D7E750A90FC042@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240412000246.1167600-1-bvanassche@acm.org>
 <20240412000246.1167600-3-bvanassche@acm.org>
In-Reply-To: <20240412000246.1167600-3-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|DM6PR04MB6623:EE_
x-ms-office365-filtering-correlation-id: d6e65444-29a4-4585-12b4-08dc5ace55a0
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 3qbDQWPFMcR0ld/kfAyXOq65S6yuLy+twsZKL3XwEantsKcX91lyIPfs2fOMhWksXGawT8duGLW/JHZHN/aPzxhXb8saSEAP6I8BhJHtVBIgiB02YgKAoLXLDArXq8znAfdJCLBIEs4tFNI12VMM+ImI35fx839MJMYLboE829pz6zCAL17ihPh4Bp1jyNfCLYqoIyQSPKot/eKAKRZpH5I1k1+iqOhROvkKhQnRC//9dojPk6t8gVzvGGQwW+YsKjxhcwOvKaWrLz3ZNAZ4Ak8dTMnfODvupmBr672irV2qhEHlKNS3g0OmlkuHQo1yqSECr98smji7Bunoxa7Lb5FH7vDWml31TPvDJLojWfwDwBXx6yiA5RXkY3qWUTXwBKntaYnq+7I78YNp1b5oZ5FluTOBKB6YieBa+wlNW1I4Xwldiu3J+Hc4f3Wyy9FPskADKxy2SGQrI6xwhbGixYvodL4yYdTmiFH85eYHOvdnjUJJYEyZ69C2W6HnOBaEM+1U4NIlFmbIOo0nYR2+PeflnZm3A5klJRsOHuZmK3xOa2VvAIGB0n6HXpEnkQM1EAQ5X0hKX53583xh729MOH+FW7OdZvVBvmlPK5zBxM7N/ozPK6aCNf7YwEKpXgwbwTj8pwG+TleZV639cCTJyAE9szTVje7y9ok3ZxNDNZZUi0mh4l3RvqRUYseiCy71oiyNP+GrzSs8t43CoqBd3g==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?j59qxC0t1K2ZXRAMqR25D3TZbYur80LcP+cTFoyJvGnemvNmyiINN1cCQ6lz?=
 =?us-ascii?Q?fFl8acP0Hr/2qVk7vlpqAvANJN3Sju5mv/faAyRCY2fUK4Uxo/2eyHt24uCX?=
 =?us-ascii?Q?FenZOAa/ony42cbVfHIkfRNcAyVcIvcsMjfCu6nna4aqN/VOTA4TI1tYjx7p?=
 =?us-ascii?Q?ALSgMQsCtB1GBe+DnuXqOWmpgesiEj/KM1L1uJgX/icj4jWbRmnhRXThsBif?=
 =?us-ascii?Q?RrCbW43SMKUOEg/9eck1CoTCU4WvhlQIysJAViKZrI9liZ7gVc3qwKwVWfsJ?=
 =?us-ascii?Q?PVo9kqMUkOuRWeBYMqWp42G28F38RApiwGIcep9H/NnqDX5Y76db3mxGwIz4?=
 =?us-ascii?Q?gPuYJ1u8A7ElmC/96QkTH6li7u7bnV7wwzwOYO7zcv9u0UoO8Z1PxswtROzz?=
 =?us-ascii?Q?ifQZKUZsn9UUQWZUES/mxUtH1BlcnVHomtlbHMT0ZYfr1E3SdA6IZYBX6zR7?=
 =?us-ascii?Q?MVSA2pxpp1RnvhHKEVQsLpSxi+CoAZLc9ZQdC97TiIHHb0AFjK405+WStkM3?=
 =?us-ascii?Q?lfwp8BFfMFbBsV8JPD+9q5QmVEDBnXiddNnAXx5JmKiiBeTgv31QZTpYDLU6?=
 =?us-ascii?Q?tWurn/ITUSHPaQ81jZi09dhcQXItoRi/cpm+K4W/2EbW9NXmrGUpJIuQBmRx?=
 =?us-ascii?Q?iZUZCKQ3S3fOM2Nl8QFBodE2s3i0lbMvuG9WyKXhOLHdKezXYoADoTFsbxpR?=
 =?us-ascii?Q?UAw0ut36RFwSPKo53BGrheyRC0gp3zgnky0i0yh7qw9/Eo1JtmWHx2Prl1LN?=
 =?us-ascii?Q?L6wOmhjkblQ35IYkpHOiWq6IuSP3xrVJeRaNKMrFjbpO33OX3tXNT6MXX/7Z?=
 =?us-ascii?Q?2YOd/eFaGD6Vd2HjRSr5rpNF6ohno8Pkm6Rnb59+plL3B+OsoeqjyqRzmQJr?=
 =?us-ascii?Q?BWBQo2Ot57R4ZhRyfF5X851ldLU1NopyI/OPE64noNVsZgedLn/OAnnx9iKp?=
 =?us-ascii?Q?Hgny7XRx+VMElBGQOI2EWSxN25k2sajn8h423zUE0MGK4oLZ4X53Lo3AtutB?=
 =?us-ascii?Q?1N8nFbZ59SisecOtByYwQGPihWaMVrVgjPhLpqvS2hqma0K0qArEQefjBtSV?=
 =?us-ascii?Q?k/PxFe6U/zq+czcoq3r2o+ky+S/gbabNDHdn3ungxFyHJhtpNisoXjlfgt6+?=
 =?us-ascii?Q?0IsfoZMkAOijy2aId/KWCyJgwDgI7r+H+82Vwn4SABbNN3yHX/ABPxDyE0o9?=
 =?us-ascii?Q?OC9YAQ7ufunYt4hFaDly3bZhLPx9Yxg8gEjUrI+dEE5Xy0H8w1DNEzKYFeJM?=
 =?us-ascii?Q?+/5Jpph4FfMB9/QsI02QlW3i8Cm0BZZfpun1d3D2V91siHRp2Smi2eKSY7Xy?=
 =?us-ascii?Q?QAKTq9idPiKV12yCcFRtXrH+XUW3yVSpTqrddtvJ4y4pUzN1pptO+f/aLaV5?=
 =?us-ascii?Q?RYvnWjhXe/yU73QnUqAJU0/xIObTBzrAlCljGdJBHpc8SFR7B3ANRFfLlwiU?=
 =?us-ascii?Q?6shZ15NaVA4wyfmuLRqe7Lc4YVmPpZdnj4BgvhcyrcSb8ttGquFw9nA3V8yT?=
 =?us-ascii?Q?A2f04vOVRSkcQeU9eSCW9xceYgC2seaXLgdqs1RIm/2UjhWoRNNApdIdSgKJ?=
 =?us-ascii?Q?4LwvtnsP1z7gwXDlZbNTaWGUrc17mN3NYo5X9YIO?=
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
	V9fL2aJuYJgGBtc+gxAxS22DWN7sDlxngTnCj/X/ipbjBVxJyJqOsxNVc1dExtfKoWVXQ78qz7fNolIXXtqc5LJmsqrs2M4ku+tjW4SFWBu6c+ciHOzEA+aonV4c8tnJ9tEBQ7ToI7Ph1z4NFD61T4rKqBMxZGonChldkCH0Xlw5NDbPZ2xOuu0RTbRx9Dq580yNSDoNrlzMDSb/i4qJEojJ2DlCjQL4zVT/GuvBT1J9Hw8n/tMz22wUsM+DdXq30ck0QfDwGuIcd6K+U7m6jq24cr8qNwSVlkVVMEHDeCieJ0L1r9JIRrUzK+nWWUaUgcx3Lf0h373AcX9GxfrdX9mGhk/GvZ7TTPtNAW0l37gY2IAheDa+/pJZNUKtWGRevR/sMvdf+Ewayj02CmwIePB2P1O23QomLReHxP4sdcFaTrmjwYqbCkXb4h9eraOmOgW9MhPkaKlH1jU/ArxEuN7ckNOfHxX0SZytWT6ou20mX1vvcjwDrxGOi60F2EAep96uVNUe+JgJFnnoMHAXPPMaPKjJ/qk3ZC7UVWmnNGO3lCMRSr4jy3Jv07r1M/l8ckdJG/cU6G+Xw6S9s6fbKZjPL7Ef2AHGJ9+df935rja6KXpn7DLRJZYJB/+DAYAW
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6e65444-29a4-4585-12b4-08dc5ace55a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2024 08:55:42.5929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zcSdb3bIGuFa7tUaHNg2bLLp9fDFiT7/bKBn/37PnhvkxeFGKpT+Wcy5K5QHEcGGm7J0Fetvx7zO3S+Q2wCTcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6623

> The ufshcd_poll() implementation does not support queue_num =3D=3D
> UFSHCD_POLL_FROM_INTERRUPT_CONTEXT in MCQ mode. Hence complain
> if queue_num =3D=3D UFSHCD_POLL_FROM_INTERRUPT_CONTEXT in MCQ mode.
>=20

Fixes tag - is it ed975065c31c ?

Thanks,
Avri

> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 62c8575f2c67..66198eee51b0 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5617,6 +5617,7 @@ static int ufshcd_poll(struct Scsi_Host *shost,
> unsigned int queue_num)
>         struct ufs_hw_queue *hwq;
>=20
>         if (is_mcq_enabled(hba)) {
> +               WARN_ON_ONCE(queue_num =3D=3D
> UFSHCD_POLL_FROM_INTERRUPT_CONTEXT);
>                 hwq =3D &hba->uhq[queue_num];
>=20
>                 return ufshcd_mcq_poll_cqe_lock(hba, hwq);
