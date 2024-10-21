Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCA51E25E2
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2024 08:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729501020; cv=fail; b=LNa3eY6hRBxx4iztzIW7hU/iMlUlemr93+ywahBiZBepyTfoNZ9mqEmrN/9xp+quoHZyj4tBOM+TzKLRjI9Y8xH2wTU+2CUFiGRhu5d+gP1ynsWGzQMEbCujtGngEuT2QnvSszGImSMuWlaL+3EqKovXjyLbD9iRXkUupLhK0DE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729501020; c=relaxed/simple;
	bh=7zf5y6JpMxG/OJUj3XXeRyOoqGkZWC2n+35EIK6NqQ4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ufuZiRxU0nCuDSAsuUYfWgjSdTNoD+FjGOPCFZTzTvXIMeWxqjp+IxXyZoTMLqr9+dkRTQWVLMEyFzpx4mN7ZiGWmjMfkvIsRYbv4R59N1D63z60qQ0XB4MhRrY+xWok8Bj7S+YBmQOyFtmJb7y0CdmQHZD8nKEk6cnBNEN4+0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=HzGgExVV; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=GZxda7SV; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="HzGgExVV";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="GZxda7SV"
X-UUID: 6999d0088f8a11efbd192953cf12861f-20241021
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=7zf5y6JpMxG/OJUj3XXeRyOoqGkZWC2n+35EIK6NqQ4=;
	b=HzGgExVV0R321ycYQvsvnIt9SxbUG3qV0w0eSwiH1vutsPtyA5i7nJOLlYqnJjVDSBtAVAg5U5rb+ZoTx0VohBJbO03E0Cib06wuvguFzg2Tqk9aRHZDlwfRdyT7NpQ5ue+0UisLCpKY/ysh/oX49Wy1Ap2yghQfKpeUqWE0tFE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.42,REQID:76be5d7f-6f2e-49ae-acd1-cd795584aa32,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0fcdc3,CLOUDID:f8136525-9cd9-4037-af6e-f4241b90f84d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 6999d0088f8a11efbd192953cf12861f-20241021
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1403126824; Mon, 21 Oct 2024 16:56:51 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 21 Oct 2024 01:56:50 -0700
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 21 Oct 2024 16:56:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=npyK/1x8cOc7DVWESu/qA1iDV5w1S28uS4h0axmqGpWKOX0ESKytiu2zYLMxoyr1LdYGLSRVqAoKZ1WUnpFIq3jwb7PAShz5JbMOZ0aYPVQ1pwPN96sPBhxedNrdpZq77XWDNficpiMPrkrOsIvUM+eL3TtiKII9MVNuiemGsrbG2X6cILo6rOWAw6+wijGIDDhJm+hKw/dcCB8HjGXleWkh6kaZWoe4OlEcIvOuNZvclSdZuZEsfuhumzWuWm6LDJHczsLH4SK6gyYQqMgxw9yXzbDlJEiWOWdhw3LtrMU86CN13pjPKJO3AyKBh4ViUebnrwGQJ66lAFtYtPwl0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7zf5y6JpMxG/OJUj3XXeRyOoqGkZWC2n+35EIK6NqQ4=;
 b=dgL0L/QbllbAd3DkC4Iis1s4za7xpJVE2B13scLB8ZsWq/W6CM3oru3OLAoxzdS2+/lrnkA6JMGcFHaOx8e8Wf6e/jrNDQGp7UPOkkdm2dTlF7Zm1LDu5s/5hASp9nlXAxvERMKSZjsUihwhqdJmj7IzNIr/TIw/AXlGi9JX8XI1QdILBZbf4zft9PcGTZB8RPBRXsl1Cq1y1lbdikSsPNHKJTWigmp/lSOY5sgZEen76iyHRbJ6UtQnjBdpQRgWMEHAqkre+T/5gD72IgfZo63TUXZIVePNZRX1FYegU1OofonYJFVftIu+aac/HSRIwPv13m77vnz+wR2mh1hxSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7zf5y6JpMxG/OJUj3XXeRyOoqGkZWC2n+35EIK6NqQ4=;
 b=GZxda7SVOfnG7eNbrtxN4QbAjagdMQeubbUaH7jnhTYJoR1UoMIizTWTjgVlXXWtUepUuC7dMAG6p+WMVc1F6u7Iq8Holw4hd9Ic9I2FkZ0a8scMda69Nkuf0XkzPHgEgQmB2MUajuanDKrZN2JrWt+KM1wVllQwuS/s29t25Pg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6768.apcprd03.prod.outlook.com (2603:1096:400:200::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.27; Mon, 21 Oct
 2024 08:56:48 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%3]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 08:56:48 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "ahalaney@redhat.com" <ahalaney@redhat.com>,
	"quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>
Subject: Re: [PATCH 2/7] scsi: ufs: core: Remove goto statements from
 ufshcd_try_to_abort_task()
Thread-Topic: [PATCH 2/7] scsi: ufs: core: Remove goto statements from
 ufshcd_try_to_abort_task()
Thread-Index: AQHbIBAuYmdsowHrvU2vtz7pEMLqg7KQ7jGA
Date: Mon, 21 Oct 2024 08:56:47 +0000
Message-ID: <cc59dab95bd9fdbe5b3478e48400a08d4887e4e8.camel@mediatek.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
	 <20241016211154.2425403-3-bvanassche@acm.org>
In-Reply-To: <20241016211154.2425403-3-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6768:EE_
x-ms-office365-filtering-correlation-id: fa9dfcad-a56f-4a34-9fac-08dcf1ae4be6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MTM2M3lWenVINkF6aHhMTWlKYXVzSWRST0k4KzNGaFc1SzgvTy91K3RIWmJw?=
 =?utf-8?B?cUNIK1JTYU0rZnhGaSt3UGhDYkhYSTlpQWZuY08vSFVtZVF6dEJMZTlPL0pX?=
 =?utf-8?B?SUZrcWVWS29uVjJzQ2ZGRkpkQnNvT0NMN2UrY1VKcTcxdi8vQ2gzQTljK1pj?=
 =?utf-8?B?eUJwU1ZuOS9OWnFrUVVPUmNKMjdRbXJ5aHJXclFuN09YbFo1c2NCb1FMaHNw?=
 =?utf-8?B?dldLM1YyM2ZGc0VxS2NXc3BGU0VvbW1ZR0ZjWTh2ZmJVdlhVR2JzUjBTUU1y?=
 =?utf-8?B?YUx4dlZPcEZlWi9PRTduQVpSVVdsZllNMTVjam03TlRPZ1QvYzE5cm8zZE9F?=
 =?utf-8?B?V3lwZnB2Sy9hNTc0MVh4OHY3RTRaUkYza21HTlN6eEloMnVUdVRBWEVQM3M0?=
 =?utf-8?B?eS9BQTJFN0VZbHFkd1F3MURVU3hnNGU1MVZrZGdoblpQR2ZQVURYa2VsYnF5?=
 =?utf-8?B?RUI5Rjd2dk4zZ3hMTnFiVnk1N1JETlJCY1EwdmsrQWxKZVl5SUtJaHFoVllT?=
 =?utf-8?B?OUNJYkEzVjNtcUFmU1NTU2dFVkRPMW9GQk9WTDBDWGJDQTAwZWo4eExvSzBw?=
 =?utf-8?B?OFVuTEJPZjRndnYvM0tkeG0yMWJXalozaXJpdi9vS3grdTh0SE1HSlpuWGFz?=
 =?utf-8?B?LzBPcmx6VGM0TjFyYUc5bjE4ZTlmWjh0L25hQ3JDWnZlbkZlVG9aVG8waSt3?=
 =?utf-8?B?VEtWMnJXNVVUYlNjWndiNGVyVFQxMGw3N1BHUStYOGtJVWEwMUZKVE9NZVp1?=
 =?utf-8?B?emhGclVwSFJpaDB5ME84V1czdXlTM0VwdUVJRmwyZC9KbkVRcElFWmdqVFhx?=
 =?utf-8?B?dEI1WVF2WFVXUUdsbWFtbkxoam83MHdIemJvdElNL01EWVVXSU8xOXRnR21D?=
 =?utf-8?B?S2ZyQkJWOFE1bVg0TVdXQXc3NzF4Nk1WRE0xRHZqSkY0Y0lsRTQ4dm4xMlhO?=
 =?utf-8?B?bXh4djFWT0ZrcWxmMHFjeWZiL1Nua2k1andRTEFmMnFoTHhZNHZzNDgrdVdM?=
 =?utf-8?B?NW96ZE41OFNHSTlEYnRDc3JKdnZSSWJBTUlnNUZzZjRYeE9FaGhRSUVXV2t1?=
 =?utf-8?B?ak01NWJZd0l4TzZtZk51Qnc2SzRWeEs0a3NNaGNsVHF4OXJYZ2pyNkJ2eUpJ?=
 =?utf-8?B?VkQvUVI4UjJzM1lXT2tLM1dMKzFkcFBvcHppdVY2M2NYbHU5Zk1laTFPa0FJ?=
 =?utf-8?B?MW9uS2RZMEIvOUpYMHlwUUVGQ24wTGZyanVZSU9IUTdLWnRZMnUxcERYNHBW?=
 =?utf-8?B?dlRBOWVVdEtoQ21OeVVWdGpZcXo1ZDcyMGpySExoYlB0dXZYdHpac3VlbGw2?=
 =?utf-8?B?bThCd1gzRXZYUjRKRnowR2xZZ1YrblQ3eTE0dXllVzY1RHkzNXR1aW5lNWx5?=
 =?utf-8?B?ZytBanFlVk1GcTBEZ2FIVkNXK3hTaFVrUUhDeFd1b2JsaVhmcldLWGlYdkpn?=
 =?utf-8?B?ak5KbGNsa25EM2ZBZldBSkJjOG5TSzlIR1ZiQ0Q3QVEyVC9jalY4QTAxd0tw?=
 =?utf-8?B?bnYySElMVWs3WDVVQlMraWhCOHE1VnJJNnBHdGVJMUE1eVNOOVA1MHFEb0xI?=
 =?utf-8?B?RkFoeE5wUFZrVndpMFJkTG5Da1V2ZFIxK0E5aGVxVHJqT3M3dVQ2elUzK2Uv?=
 =?utf-8?B?NnhJb1BHYUZZaW1ZcGdYcnJyWDJrWFgzSENDU25Id1hFMU1mUmRMZWk2UlVw?=
 =?utf-8?B?VkJUdERPOU5jQlV2TnpXbE1aMGpUN1pYd2xtSmRtWnJIV2VoUkxTazlDbnVV?=
 =?utf-8?B?Z2NvTUlNYmdIblExUEZLa09GM2VCZHBsT0N3SkpFbFhXTXBoNXpITFc4eDk4?=
 =?utf-8?Q?ag7mSzX9yDvNGENzAehac22Wama3JWxiOtHTY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dUkvMGc4WlhoREx1R1FqOFZnREdoZm9JMXVmbTd0VUFUWjk2Q0htanlibmMv?=
 =?utf-8?B?YzA2OWV3RXRnYUpmOVNTMHJGeDFUelgxQ3JreUhlWlEyOU83S1dJQUh2U2hF?=
 =?utf-8?B?eXFaNWVlZmFPRVhEdU5odnFPM2xDU01oSjhlbXZlSGFVSndubEpvbDZTUjZY?=
 =?utf-8?B?cU5MYjAyYXRHZnJoQVpNQWVEQnF2WkQ0dzBPMFg0Y0dIUDRvYlU5NFV3Mnpn?=
 =?utf-8?B?OVRBWFZzU0ZEM09LOGFUc1l6Z0pXWkgxNXk5bWlKdmhhMjNTNHJ6N1o1MjFJ?=
 =?utf-8?B?c3lkTFc2MGY0VDBpTFVlWDNOYUkxMXc4YlRhWnE5ZXc3MldIVHpxMGVEWGdq?=
 =?utf-8?B?emdDR2Y4V0l6NlRSdDB1K2tBQXFmZVU4eWJYRGpFWmhmRVZiMTRET1hQVjdK?=
 =?utf-8?B?Q0taR3hVZXdBdzI5Ymc0akxVa2hQNXh0MXR1QnVTTEFTLzNUcklWNEhMRmcr?=
 =?utf-8?B?L1NIUE9TRFNUd0REeUtNVy9reXozKzg0WFVUcVNTUUJKY2lUckdmN3VMTU50?=
 =?utf-8?B?NGdMazlNdmdnZTF4aG1uSVluZVJYWnptWHgwSU9pYmhVQVppdnlXaUhjelg3?=
 =?utf-8?B?STFjSmZpSkJKYmFQQ0c2MHlyaG1UUXFnT0pRbE5qM2ZWcFpTUXBOdjZPb2wy?=
 =?utf-8?B?cHBMRGxpVkY3eU1VemhQemxpWktmMytZMnowN3Jsb3VOd2V6V1FpL2JCekF2?=
 =?utf-8?B?ZU1MRXNjZUJoMHBHWXNpRGRhYVJGdnc0ckxRbnh0dU9NOFQvS2lYNXlIQ3Mz?=
 =?utf-8?B?ZlNNeVIyQXkwSmE4UTZ4Yy85aFlrNlE4VGpvU1c4TUtiL2pWODNldjMyYTg3?=
 =?utf-8?B?ang2cVFwd09PTzBzdFNyQ24ydnQzbEozSkJ2aG9vZ2xOTEhWQ2VCZVJhczFk?=
 =?utf-8?B?YitzSDltSHFjaWY4UXRCVUM5dWJ0dnJOR0dYSG14ZE9MOTAvbG1zbVlvM1hQ?=
 =?utf-8?B?WjRYMG0vckpSNW5rMnJHNERtc0dEUFpuK1ZMT2NJMFAxVGhaSnhHZ2lDdmxZ?=
 =?utf-8?B?TDRuU0N0WEMxMkhsQVZSL0NlY3YycmhvT2xUdzdxTU9vUjJlVlBMRE9nVEZF?=
 =?utf-8?B?bGh5VUh6MndVc0Z4eTZWUnJGeC92U2xHelZ4d2JMRzhwbGF1TjRheFJZL0lE?=
 =?utf-8?B?NklCZG5KaG13bEsvMWNadjNwdUY3QTZxOWM0MzVGSGFoWUxjWVprNzRKNFRL?=
 =?utf-8?B?cVZ3V2ovNy9nc29XNDNUTUpKeWN0ZXYxTnc3d25NQktoZDhDbEVzYUVzYXIy?=
 =?utf-8?B?MnJrOEppUkhReVk5eTdRdGE5MTNZWElINFFRR2x1YXlYbkhnY1ZpbDJnbytP?=
 =?utf-8?B?WUx5cDBYSmFKMDhBbDlxR1JJK09HN3d5U01mMVF0YllsVjQyTWdvTVRweXVN?=
 =?utf-8?B?M3Z0WmpJVkRFRjdON04wYmpCL2tpRG1CQ2xPSlNZSUJyaXdUcWRmbWc2OEFL?=
 =?utf-8?B?WlhzZXpTOFNHM0dKWkFuejE5dStMQS9vSG5yaUp4S1ZPR3NFVWtPSDBNUkVu?=
 =?utf-8?B?S0lVbjdMSlZ6MDBCaENVNTNMSERnb1Vuekl4d1BKY1VOTTlvQzZWbGsrTjZo?=
 =?utf-8?B?TGRIU0lkMElTUDE0bzRSU2dtRlc0STZkckpGajdNUEhVUWFXRzQxMnArdlo3?=
 =?utf-8?B?ZERUUjV3dC84ejF0bVZVbjBPcFRTUmlvaWtobXl1OEZMWitBd0pJK2FWeTky?=
 =?utf-8?B?L2hPakFSYkpNUkttL3JKTXlSL3BRT3hISm1GcTV0YVpFUnFTOFlId3VtdHR0?=
 =?utf-8?B?cFplbTNOZHVhNW1Ec21SbVA3N0pZaFExZHFWK2hxTVd3WWZzdW9TOEdnZHc0?=
 =?utf-8?B?RldMbUxIcXJ0eXh1SzRKMklDZDNJMXZuSzlheENiRVQ5aVBHRkZrK080c3Vw?=
 =?utf-8?B?YUdmcDZ6eWlqajdLZU1BQk9TbFNISzJlbDJiUjE0RWxuWURXSkxJNG5maElE?=
 =?utf-8?B?c09BTFYrelVCa0ltQXdBbjFwSnMwVjB4cHYydTNyVXE1bXg1TEdOa0Jad0RU?=
 =?utf-8?B?ZVZuT3Ryd1pPOFRudU5jR05jMmhCT3NwY0ZBQmJBNWQ0R3lYTFFwWDlWZ0RN?=
 =?utf-8?B?Vy9Sb1B1eEdzQllYWHNlUEhPZisyQW5zZG0ySHR0TzVLSFRLekN1RkVpL0RR?=
 =?utf-8?B?bkI4RFE1ZG5MQllPVnJDZlQvUGVlZlNtM3pDUHRRL3pPZk5hVWd6WlFZNFpk?=
 =?utf-8?B?b3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <62689255ADA0DC408108794519057765@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa9dfcad-a56f-4a34-9fac-08dcf1ae4be6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2024 08:56:47.9693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +yI8GxFmKyKGlydKm/m5hh9ubA126ZHJt/ohBAeb7LRbUmfwwtA0QwbdSEsZ7oKcfNuMdqTYtN1qZjMCgNMw4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6768
X-MTK: N

T24gV2VkLCAyMDI0LTEwLTE2IGF0IDE0OjExIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgVGhlIG9ubHkgc3RhdGVtZW50IHRoYXQgZm9sbG93cyB0aGUgJ291
dDonIGxhYmVsIGluDQo+IHVmc2hjZF90cnlfdG9fYWJvcnRfdGFzaygpIGlzIGEgcmV0dXJuLXN0
YXRlbWVudC4gU2ltcGxpZnkgdGhpcw0KPiBmdW5jdGlvbg0KPiBieSBjaGFuZ2luZyAnZ290byBv
dXQnIHN0YXRlbWVudHMgaW50byByZXR1cm4gc3RhdGVtZW50cy4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiAtLS0NCj4gIGRyaXZl
cnMvdWZzL2NvcmUvdWZzaGNkLmMgfCAxOSArKysrKysrLS0tLS0tLS0tLS0tDQo+ICAxIGZpbGUg
Y2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkNCj4gDQoNClJldmlld2Vk
LWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg0K
