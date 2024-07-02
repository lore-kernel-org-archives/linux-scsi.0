Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF1D2AD17
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 06:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901783; cv=fail; b=gDsNVDjf9tvK/VJGP7Aztq8wjNA+oqyu74plOmOfYfZ6FTJ2qFrpQy0hTiKItKX2rPlI2FlLdcYXKGz3hInUOvDgYc6sjDFfi0jlUIf4aHdwkMelMLFcfon75SB6qv+RQ1YP6vQCZGF+k8Gwn/eQD1aRsDvQgJMaq17wV3KT8mM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901783; c=relaxed/simple;
	bh=g4nhv2GxtME6Mdl2wUjMOkDy4CK/HESg3EisV0wiOFM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c1Fqg5MnRGvB0v5vcrD/0/miIsndIxiGoZjrePomYOWdx/0vXjSO2k/IIRZRmbwc8JJe3QikdqqIacGgpHVlLijZYjTkYF1AA3vZdXvlzfuH/PhrcwYIwBTlmRyc1WDGfo0W8EnVd7JCJbx0po/RYdK0918gg/lcPT58ARQJz2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=si3YEiat; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=DJbCU/c7; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="si3YEiat";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="DJbCU/c7"
X-UUID: 73097eb8383c11ef99dc3f8fac2c3230-20240702
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=g4nhv2GxtME6Mdl2wUjMOkDy4CK/HESg3EisV0wiOFM=;
	b=si3YEiat4IX9pWQp6+cFHHqYTF/z17IWq5kS7JcawLMO2Qk9BqmEVKIXI0DNa2spRercZOBxKx2gAlQA/upXtTYQ/ijoVuOYIuCN4vjbh7xPFD/LbxiuWdmx80HleKzre/PGuZrtDczvOCJqRTeMkWEvigzHbEotV9NxEMN8Zs8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:c7816bd2-a5e0-4eca-9229-ff61c7b058b1,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:945dd9d4-0d68-4615-a20f-01d7bd41f0bb,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 73097eb8383c11ef99dc3f8fac2c3230-20240702
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1176023063; Tue, 02 Jul 2024 14:29:35 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 2 Jul 2024 14:29:34 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 2 Jul 2024 14:29:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NHJStaswsym1aCC+cJlBkwDLmq5dU+P4g8dczOUW2w2ENsQioV04xCIvzm1SuoCbPOV0YjPJz35mJWI3SDSnApkd8ye2WSBKXnPrmPBIfS0VO5/xPXhJf61SO4UTlKnd3/9VQWQBJkVfHrgXOGAvI7sb/W7ntbEhIZhix7vQwIbGaed6XAg8laE/X/NbjV6l+r66AhI5cV7XwHVdfsj8ytaTm4z4oIBQgdNOJrLGdB1pS946rqs7Vx3IfK80e/JvdmsCAvXi3gxmrncAaqAMUlpRN8eUAq986vTa58BDDrGexL6ZClF7jrO/W945jSNjMN38T1tPCkv9K5P1s0/WDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g4nhv2GxtME6Mdl2wUjMOkDy4CK/HESg3EisV0wiOFM=;
 b=Jmn4Ay0zdEU9Tz9aasRVSSG8Qw5SlUgBthSYqiBjhJ1XUMC+PKgtwro4dVOfR6LX/CTVLF8Kn5YIS3/PZnMz9UgeTbalhHIdu+tC11aQ2XfneBsYPrlX19H9m/Dv8PBaUVyeYy16+b7gihL+TOZZR75LsiN2mEMpVlWVZ0yr3NPloz5RIv0ccNlxduLKC0AR/lfPYxHBWPpscGdMVK2xrj1i5peXPPjF62j1WW/UzHuUBWlvOi24S0+L09tzVd4q4DzAFsW7AG0UdcvA8IWLPrQnNnvTdwCieB/4QzqQ9NFuK6V6zAhvZTNgNeh+Ll/tBqnmyXKIEsV4yWJ2G1tp2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g4nhv2GxtME6Mdl2wUjMOkDy4CK/HESg3EisV0wiOFM=;
 b=DJbCU/c7DQ/KO/rtyEqbcPKIdz2ojuE7jiSjUxcgDZ3KpHOWWFZ213kd/iqEJVNn1DxFtNoE3a4h9SgdVkbsLrZrhZ1yxycCd4AWagiDSRTeToZVIONcusovmJdG1OFrN3UGQLO5Fd5JxI1SrG09jshNCj3A9+Bs0KumLS27VwQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB6957.apcprd03.prod.outlook.com (2603:1096:101:a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.29; Tue, 2 Jul
 2024 06:29:32 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7719.029; Tue, 2 Jul 2024
 06:29:32 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
	"akinobu.mita@gmail.com" <akinobu.mita@gmail.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"cw9316.lee@samsung.com" <cw9316.lee@samsung.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"minwoo.im@samsung.com" <minwoo.im@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "daejun7.park@samsung.com"
	<daejun7.park@samsung.com>, "yang.lee@linux.alibaba.com"
	<yang.lee@linux.alibaba.com>
Subject: Re: [PATCH v3 7/7] scsi: ufs: Make .get_hba_mac() optional
Thread-Topic: [PATCH v3 7/7] scsi: ufs: Make .get_hba_mac() optional
Thread-Index: AQHay+FdSzs5kWYjwEuWnAVK7NEzubHi+qGA
Date: Tue, 2 Jul 2024 06:29:32 +0000
Message-ID: <0b1a9acb836a5ce5467ec5e2327b750ace51ad82.camel@mediatek.com>
References: <20240701180419.1028844-1-bvanassche@acm.org>
	 <20240701180419.1028844-8-bvanassche@acm.org>
In-Reply-To: <20240701180419.1028844-8-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB6957:EE_
x-ms-office365-filtering-correlation-id: eda240ba-6b5a-45df-788c-08dc9a60559d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cWJqcVZhZzlVY0U1cFlEWVd0SzRVdjVJeGF6UWgycjBKU3pGWFhJdU9ad0lL?=
 =?utf-8?B?YXpiM1FFcEVETE1leVoreVhraUtwSVB2NExkK0NPanJ6SE9ZOTRrNS9ESDRI?=
 =?utf-8?B?VWNiVzN2dExZVVJxUktSWEUzK0Jxa0N2SnM3VDNBcFZvbXFxNUplVnp2V0ho?=
 =?utf-8?B?NFkrQ2w0N3dNMWwvVy9Uckx0VkhYMlRBSXJhMEJlRXR3QVhEL01HRXFRcVFI?=
 =?utf-8?B?NWxtQnJFTTZkbTJqaGg5cjI0aWFFVytvRUtGeDJySW9HdlBJdDFsN29IbGxR?=
 =?utf-8?B?aHZmUDhVZmwxcW1ZejJvQkxXZ3Zub1k5ZkdNMkF6bUIrRkJ0TmJzOGhRQUx0?=
 =?utf-8?B?bDdpOWZwZjdsOXVWdmt5YmNybVQvU0t1VkU3K0RCZS92dlN2WjRPT1FJTGx3?=
 =?utf-8?B?cWxWbTdReVJjZHpVcmMxSWdPZm1NVjhWYVdZTjdOZllFbk9uYmJEMXlMUkxF?=
 =?utf-8?B?WE9UMnVUbVBac0h1aGN3L0lCeVhDSTVWSkM5cStZUlZCSEFnOTEwOFgyUzVU?=
 =?utf-8?B?ZjZIWkRTQkp4dVFGMXhWU3VlN2xGWmRYWlBqaVBpZTBiNmlSOGJlQitFWEtq?=
 =?utf-8?B?S1p6OUF0Nk8zVWoxdEhnT0hjdDBpMUZwZkp5Vzl1bHNVU3MySjZ5bFhRRWtL?=
 =?utf-8?B?ZFNXMzV3MDZjTjE4bXFHWXEvbnU3ZXRlQnZFOGEzRnB2cHRBSHBDcE8xUmZr?=
 =?utf-8?B?M1JhSVR1L0M1cDdET0VjZjltZ1oramNzZWhSbFpUUEZrUXd0WWowQTFyV0s2?=
 =?utf-8?B?YVV2NGZheG45Y094V3FGOWFYcE5Oa2c2UmtLdUl6SDU3S3VoUnFqTUJnalRL?=
 =?utf-8?B?aE44ZlZwVUV4NzlZRUtXVWZ0SmJWNTlSOUNIK2dGdUR4N25rSU1vOE9HNU92?=
 =?utf-8?B?SGNrUTNjWXkrL1BGejQ1aG1sYmVWNmxvNWFNYzVDTUlXcnlMWVVSSm13a2c0?=
 =?utf-8?B?eFBOc1liVDdCY0prd0ZEMXA5SUp2SEc2MkpoVHBEU2plNUhIRU55a0tnanJk?=
 =?utf-8?B?YXZvcFpBcFVXMHQzdGVwNnZRSUkrakptZk1zM2M3WDlFaXV6RzNuSVJhc01C?=
 =?utf-8?B?bVZKWVR1cDR2N3JVaitLMlNTQnhKWUI0Zzk3dUErdEducWRRR0Exc1FDYVEy?=
 =?utf-8?B?Q2ZTVFFqK2N1NGtRcUZJT01YR1c1Q0hSVEFRVWMrWXJoN1YxTWEzTFgxbEN1?=
 =?utf-8?B?TDh5QUtFR2R4RzAyU3k4eE8xMVd0SjcrUjFhOHBNZmVBbWpOL1ovYmlNWHFU?=
 =?utf-8?B?ejMxUlNKYkFXRXlzbk1UWDdMZFFWaVo5MDN1NG5rZVBEcXFqcUlxMmFEVW0r?=
 =?utf-8?B?NzBaUlQwZ0xrNkRVWVh5d1lIQW80WXZJb0pJMDFqZWZxNlFlTkk2S0E5Y1Uv?=
 =?utf-8?B?TUhiTi9SdW5hNmtxWHFsUExRVUN5alNFZVNjc0tCL3U3RGxMbnNiY3ZxNDM0?=
 =?utf-8?B?Zk1WSEFpUG1RNWpKTlNPRlJMRG42RThwWVRDL1lvWktoS2pyMS9sd2FwRGxw?=
 =?utf-8?B?NGdBWWNwNGhtZFgrenZkSTltaGFKQk1leFdIZW15b1NTck9CbDViUlJVYkQ4?=
 =?utf-8?B?UGtwMHdPUlRCaUJlb3d2SXo0V1AyYU85Ui85OWRQcWszWWUwSHlZZ3BNaFJO?=
 =?utf-8?B?OWE4L2NCQnVFa2pFMWdpbER2TXNKdFVmR2x5VmNsaThtOW50NGVmdTRaWUh2?=
 =?utf-8?B?R21nS2N0MFlicWRZRTNsREhWdVFkYmJORTgwTHBVaXJobE1weGZ2T3J1SENy?=
 =?utf-8?B?YVFsemdiNEdDdVBTQkVtTGdCQ3hSWkxwNVZ6SUl2U3RobDN2YnBndVRMQVV5?=
 =?utf-8?B?VmFzOGgya0VLL3ZCZXhabHpnK2M3OHVBd2s3RVpFWHpmQlE3QWlUN3dscFJG?=
 =?utf-8?B?RTd3Nm1FWmYveUpZNXZMVUhSQjRIajFsdkcyOHVhWDhYZ2c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a2NpVlVBOW56RFYxaW9JUFMreWlFSi9hSDh1SmhqN2QzS0lrdGhGSTdaV2c5?=
 =?utf-8?B?ZjNVeklSQ29HV3NMNklSTkVkYXp2aW1EV1hKYU1nRDN4dDlBMlZyaWdZWjJO?=
 =?utf-8?B?QlN2SFozejZZc0JGclpTSStSbElDeWFocGgvYmdaOHZMR2VPL2NiSEFwUlB6?=
 =?utf-8?B?Z0xOelE3V1BkT3NKQTZOTkN0UVJGQVNTaXJvbmt4Wkp5VG9mUnNESWZuc25V?=
 =?utf-8?B?Z2s2eGRaaWtNeHI0eW1EbUFZMzFkSVBGLzBnN2o0ekFrT0lhMzBVdm5NZ2Zu?=
 =?utf-8?B?aWJJSnhLMjAwWDFqcldnVEx4YllpYnQ5TDRwb3R1d0JPbXdwcGVORjRmc1dB?=
 =?utf-8?B?RkQwSzJYYkRVU2lNYVNWQjBHRXhNNTBQb1FOQUVuNHM5cXRCd2pIYWhha1l1?=
 =?utf-8?B?cXZ3R0lvT1FGVXU0Q0E1azZhdlZWNmk2Tm5SZUNaaXVPbXh5SjJEVE1namwv?=
 =?utf-8?B?QjB2eTI1bHNMV1h2ZkVTVTVJNzhydmNJSU1pV1RzcldJUHVZeWxKNGo2RTNl?=
 =?utf-8?B?TXVUT3BwNUFmMUNVdHc4RmRETlJvUkNzNmNyM1hmeUIrZDVYR2ZHREthZmRj?=
 =?utf-8?B?R0JqUzdDMUxIWkVRa2h5VTZCaHF4dHdIVTFBdEJ2SjBid0pzZ3hidDdnTU5h?=
 =?utf-8?B?TVlPZTFIejYzNys5RU5SWTF1RGZTSXRYd0lPVFdDYUtBRm0yZ0lOK0ZqTytx?=
 =?utf-8?B?ako5RXNKOGQ5WjRBcmhYK1FSTFVFOXNydFBXVHMzWFRXMGd3T3FHUktIa3ZH?=
 =?utf-8?B?aFRWejcvTkdaclovQk03eUMvV1RRQnZMdTVhVENrQW00eGxoamNKN1hxaFpS?=
 =?utf-8?B?NVNCZG5QZ3B1Y1RPQWI0NWI3cGxyYWlxZXptNFc4NzdHNDJZejJBUndNdjM2?=
 =?utf-8?B?QkF0VjAyeVBhTHlEV2psY3RETmVDVHA0QitIODRETGJOcmRJWmJVcHF6SlFm?=
 =?utf-8?B?eDZMV1gwb2lLMWRJM3ZPQ2k1eUxWRXhnSmtsTEdjaE8zTHZVSmd2Ykt3anJV?=
 =?utf-8?B?SGIva0FTYVhpMjFrQzR0ZmpFTXhoeGNtdzBJd0pQMnVKN3gzYXVFOTZ0UW9W?=
 =?utf-8?B?bW1tMGVtZFpLS2Jja1I4OWFrY0tCM0djaFJnblFwc1JRcjc5Tmora1Nnckhn?=
 =?utf-8?B?ZTlQdXg3U2pHNHBhOTg1VzFxZElSVzZHVkVzNHBReTFoVXEzYlNqUTRHa3Nl?=
 =?utf-8?B?blJ6eldhY0E4bzI3NXZLMzdqWEFSblFyOU11Vnp1Q2ZRYnVIVStlbVFiYzBo?=
 =?utf-8?B?T1I2T0hBWFppY3FySXlBQ0pxRCtYd0RTWEt6NlV3NVRuSjYzTndTYWV3TEFR?=
 =?utf-8?B?dXBjZXd4OGl5dnlKRHZxQjdTNSt6RmRyalllTTBWOWZDdzAxcEp3RmNJK2c4?=
 =?utf-8?B?K0o3T2NnRjQxUFE2dnBqQVdYaXErY2Z0OG5ES3RteEdVemxqaHZzMksxOUdR?=
 =?utf-8?B?U2tJQlFkcUFpV0JrWW9zRmNJL252SFJFMlo3U2ttTERpZ2pBclJjZHVpOUdS?=
 =?utf-8?B?dEJVS1BGb2lFWDJiTTVsVnh5MG51WmxFSXB4eUZ2b0diZWJSYXVaRFI4K0lt?=
 =?utf-8?B?K1lFckFndUxvRldNV2JrK2cwbGM5RC9HOEErTGhFemhhRm05TmpPbUs0S1pK?=
 =?utf-8?B?akRLMVJia0IyRm8xV1Q5OUV4R2ZTNmF4SGZxckVDd3JvMVFBUnhYU0hPUENG?=
 =?utf-8?B?YmFQczBLU3dZQWloalFvSXErejUxT3gzWHN3Z2NJV3MvV2llRVBzNVhSYUk5?=
 =?utf-8?B?ZjQ3L0x0ZlYrN2lWTUg2L0tJVmNmV0gvb2thRmlDb2RoTFhHNHJSQzIzQ3Rs?=
 =?utf-8?B?dTlRL3poT2NZQUZxeVYwM1JZQXlOTkhRdzdQMjRCTW42NnRTZ1REbXBTNVYr?=
 =?utf-8?B?aS85dlEvaXVOcDUrcWZFaFdIU2ZUeUlWL3k1Tkl4TTFRU3pUSWVMTHhXTUtz?=
 =?utf-8?B?STRaYVlnQWR0SzRtWnRmL09YeUZQWFh6L0VGakY5UC9zUlRBLzRLcER3WENn?=
 =?utf-8?B?bURSQjNxV2hPUVl3ckFyT2NRNXRxZnVHWS92SS9vUXJxMVZDZTcvR2RmSHhu?=
 =?utf-8?B?NUJaam9JbXVvVXVKVGlRcTVrYzVXSkpqS212aDQ0SHRobUZOQXQ5OHZIaFhr?=
 =?utf-8?B?QWNzNHptVlUxM3NjTW5UbUFUbmVCSlJmM0xQd0NvWE56Qk5tTFdYYlRQeUgv?=
 =?utf-8?B?Tnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3DA6155284EEC541B81E504305D12538@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eda240ba-6b5a-45df-788c-08dc9a60559d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2024 06:29:32.3235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0BDRShPnHjlV1Mh5fIEN+5GpegEjiY6f2dFM/Jev5QkKUfmsA0fO+bhS38XrZIv9aaEYT53TAIUvdpNOjjyzEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB6957
X-MTK: N

T24gTW9uLCAyMDI0LTA3LTAxIGF0IDExOjAzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgVUZTSENJIGNvbnRyb2xsZXJzIHRoYXQgYXJlIGNvbXBsaWFudCB3
aXRoIHRoZSBVRlNIQ0kgNC4wIHN0YW5kYXJkDQo+IHJlcG9ydA0KPiB0aGUgbWF4aW11bSBudW1i
ZXIgb2Ygc3VwcG9ydGVkIGNvbW1hbmRzIGluIHRoZSBjb250cm9sbGVyDQo+IGNhcGFiaWxpdGll
cw0KPiByZWdpc3Rlci4gVXNlIHRoYXQgdmFsdWUgaWYgLmdldF9oYmFfbWFjID09IE5VTEwuDQo+
IA0KPiBSZXZpZXdlZC1ieTogRGFlanVuIFBhcmsgPGRhZWp1bjcucGFya0BzYW1zdW5nLmNvbT4N
Cj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+
IC0tLQ0KPiAgZHJpdmVycy91ZnMvY29yZS91ZnMtbWNxLmMgfCAxNSArKysrKysrKystLS0tLS0N
Cj4gIGluY2x1ZGUvdWZzL3Vmc2hjZC5oICAgICAgIHwgIDQgKysrLQ0KPiAgaW5jbHVkZS91ZnMv
dWZzaGNpLmggICAgICAgfCAgMSArDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDEzIGluc2VydGlvbnMo
KyksIDcgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91
ZnMtbWNxLmMgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy1tY3EuYw0KPiBpbmRleCAwNDgyYzdhMWU0
MTkuLmY0Y2M0YjA2NzZmNyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnMtbWNx
LmMNCj4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnMtbWNxLmMNCj4gQEAgLTEzOCwxOCArMTM4
LDIxIEBAIEVYUE9SVF9TWU1CT0xfR1BMKHVmc2hjZF9tY3FfcXVldWVfY2ZnX2FkZHIpOw0KPiAg
ICoNCj4gICAqIE1BQyAtIE1heC4gQWN0aXZlIENvbW1hbmQgb2YgdGhlIEhvc3QgQ29udHJvbGxl
ciAoSEMpDQo+ICAgKiBIQyB3b3VsZG4ndCBzZW5kIG1vcmUgdGhhbiB0aGlzIGNvbW1hbmRzIHRv
IHRoZSBkZXZpY2UuDQo+IC0gKiBJdCBpcyBtYW5kYXRvcnkgdG8gaW1wbGVtZW50IGdldF9oYmFf
bWFjKCkgdG8gZW5hYmxlIE1DUSBtb2RlLg0KPiAgICogQ2FsY3VsYXRlcyBhbmQgYWRqdXN0cyB0
aGUgcXVldWUgZGVwdGggYmFzZWQgb24gdGhlIGRlcHRoDQo+ICAgKiBzdXBwb3J0ZWQgYnkgdGhl
IEhDIGFuZCB1ZnMgZGV2aWNlLg0KPiAgICovDQo+ICBpbnQgdWZzaGNkX21jcV9kZWNpZGVfcXVl
dWVfZGVwdGgoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gIHsNCj4gLQlpbnQgbWFjID0gLUVPUE5P
VFNVUFA7DQo+ICsJaW50IG1hYzsNCj4gIA0KPiAtCWlmICghaGJhLT52b3BzIHx8ICFoYmEtPnZv
cHMtPmdldF9oYmFfbWFjKQ0KPiAtCQlnb3RvIGVycjsNCj4gLQ0KPiAtCW1hYyA9IGhiYS0+dm9w
cy0+Z2V0X2hiYV9tYWMoaGJhKTsNCj4gKwlpZiAoIWhiYS0+dm9wcyB8fCAhaGJhLT52b3BzLT5n
ZXRfaGJhX21hYykgew0KPiArCQloYmEtPmNhcGFiaWxpdGllcyA9DQo+ICsJCQl1ZnNoY2RfcmVh
ZGwoaGJhLCBSRUdfQ09OVFJPTExFUl9DQVBBQklMSVRJRVMpOw0KPiArCQltYWMgPSBoYmEtPmNh
cGFiaWxpdGllcyAmDQo+IE1BU0tfVFJBTlNGRVJfUkVRVUVTVFNfU0xPVFNfTUNROw0KPiANCg0K
SGkgQmFydCwNCg0KQmVmb3JlIHVmc2hjZF9tY3FfZW5hYmxlLA0KaGVyZSByZWFkIFJFR19DT05U
Uk9MTEVSX0NBUEFCSUxJVElFUyBzaG91bGQgYmUgU0RCIHZhbHVlLg0KQmVhY3VzZSBNQ1EgaXMg
bm90IGVuYWJsZS4NCg0KDQpUaGFua3MuDQpQZXRlcg0KDQoNCg0KPiArCQltYWMrKzsNCj4gKwl9
IGVsc2Ugew0KPiArCQltYWMgPSBoYmEtPnZvcHMtPmdldF9oYmFfbWFjKGhiYSk7DQo+ICsJfQ0K
PiAgCWlmIChtYWMgPCAwKQ0KPiAgCQlnb3RvIGVycjsNCj4gIA0KPiBkaWZmIC0tZ2l0IGEvaW5j
bHVkZS91ZnMvdWZzaGNkLmggYi9pbmNsdWRlL3Vmcy91ZnNoY2QuaA0KPiBpbmRleCBkNGQ2MzUw
N2QwOTAuLmQzMjYzN2QyNjdmMyAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS91ZnMvdWZzaGNkLmgN
Cj4gKysrIGIvaW5jbHVkZS91ZnMvdWZzaGNkLmgNCj4gQEAgLTMyNSw3ICszMjUsOSBAQCBzdHJ1
Y3QgdWZzX3B3cl9tb2RlX2luZm8gew0KPiAgICogQGV2ZW50X25vdGlmeTogY2FsbGVkIHRvIG5v
dGlmeSBpbXBvcnRhbnQgZXZlbnRzDQo+ICAgKiBAcmVpbml0X25vdGlmeTogY2FsbGVkIHRvIG5v
dGlmeSByZWluaXQgb2YgVUZTSENEIGR1cmluZyBtYXggZ2Vhcg0KPiBzd2l0Y2gNCj4gICAqIEBt
Y3FfY29uZmlnX3Jlc291cmNlOiBjYWxsZWQgdG8gY29uZmlndXJlIE1DUSBwbGF0Zm9ybSByZXNv
dXJjZXMNCj4gLSAqIEBnZXRfaGJhX21hYzogY2FsbGVkIHRvIGdldCB2ZW5kb3Igc3BlY2lmaWMg
bWFjIHZhbHVlLCBtYW5kYXRvcnkNCj4gZm9yIG1jcSBtb2RlDQo+ICsgKiBAZ2V0X2hiYV9tYWM6
IHJlcG9ydHMgbWF4aW11bSBudW1iZXIgb2Ygb3V0c3RhbmRpbmcgY29tbWFuZHMNCj4gc3VwcG9y
dGVkIGJ5DQo+ICsgKgl0aGUgY29udHJvbGxlci4gU2hvdWxkIGJlIGltcGxlbWVudGVkIGZvciBV
RlNIQ0kgNC4wIG9yIGxhdGVyDQo+ICsgKgljb250cm9sbGVycyB0aGF0IGFyZSBub3QgY29tcGxp
YW50IHdpdGggdGhlIFVGU0hDSSA0LjANCj4gc3BlY2lmaWNhdGlvbi4NCj4gICAqIEBvcF9ydW50
aW1lX2NvbmZpZzogY2FsbGVkIHRvIGNvbmZpZyBPcGVyYXRpb24gYW5kIHJ1bnRpbWUgcmVncw0K
PiBQb2ludGVycw0KPiAgICogQGdldF9vdXRzdGFuZGluZ19jcXM6IGNhbGxlZCB0byBnZXQgb3V0
c3RhbmRpbmcgY29tcGxldGlvbiBxdWV1ZXMNCj4gICAqIEBjb25maWdfZXNpOiBjYWxsZWQgdG8g
Y29uZmlnIEV2ZW50IFNwZWNpZmljIEludGVycnVwdA0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91
ZnMvdWZzaGNpLmggYi9pbmNsdWRlL3Vmcy91ZnNoY2kuaA0KPiBpbmRleCA4ZDBjYzczNTM3YzYu
LjM4ZmU5Nzk3MWE2NSAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS91ZnMvdWZzaGNpLmgNCj4gKysr
IGIvaW5jbHVkZS91ZnMvdWZzaGNpLmgNCj4gQEAgLTY4LDYgKzY4LDcgQEAgZW51bSB7DQo+ICAv
KiBDb250cm9sbGVyIGNhcGFiaWxpdHkgbWFza3MgKi8NCj4gIGVudW0gew0KPiAgCU1BU0tfVFJB
TlNGRVJfUkVRVUVTVFNfU0xPVFNfU0RCCT0gMHgwMDAwMDAxRiwNCj4gKwlNQVNLX1RSQU5TRkVS
X1JFUVVFU1RTX1NMT1RTX01DUQk9IDB4MDAwMDAwRkYsDQo+ICAJTUFTS19OVU1CRVJfT1VUU1RB
TkRJTkdfUlRUCQk9IDB4MDAwMEZGMDAsDQo+ICAJTUFTS19UQVNLX01BTkFHRU1FTlRfUkVRVUVT
VF9TTE9UUwk9IDB4MDAwNzAwMDAsDQo+ICAJTUFTS19FSFNMVVRSRF9TVVBQT1JURUQJCQk9IDB4
MDA0MDAwMDAsDQo=
