Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51F018E20
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2025 12:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744634884; cv=fail; b=PEKIXbiykb+5ANaGDLjFuOF22ZL+yxampkzGz3J56IFam6RNZULA81kHvaZdrPyNm61xSHOyTRMAAMHxqnm4ee35mYpCdCCGcKPTF6zJm+IYC3mZvCxRbqUDzNXshEHLxTJ+8eQ+vXyeJJ/Itb9BgSXW1nv6DcWxD5aLuMGysFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744634884; c=relaxed/simple;
	bh=LkxgM6tVmewzNOTio0jcWngtKpqbGAMcoWa8LYJVW/I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gq6y8NwFeU7lyHpnk2mabKzG/utXKnsIuQn1b6tCJ5MlsnGLR7371SUa6K1DEmrboyW3wFt+4ItfI8GQv9L1Jkx84RYrdZBWeD2BbOtPJJuEZvwgZRta3xMohii581Deo90NMnHg0iIUKqvpsRxTvBqTxQi9FehPxikp5IXA0RM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=EVGuZOl/; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ij1vs63w; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EVGuZOl/";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ij1vs63w"
X-UUID: b182720c192e11f0aae1fd9735fae912-20250414
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=LkxgM6tVmewzNOTio0jcWngtKpqbGAMcoWa8LYJVW/I=;
	b=EVGuZOl/f/BEPXTR4vn5r3awkSBtHVmMNVQpNMYvs7DE7F2GmOOh3Sh7/i8td/4lkIZbyT7eKoiR7Tu1mROPtRE/clZEnb9ulP96dXfXGBG1KBDmw2PH7R1tIIEJJyzmHUg6hZ5gc3LH2t8iIXO52NY9PLE8KQ1/6eIidyTXdD4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:e2ca7651-abd9-4bd0-9082-9b100d86ed64,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:01ac3a8b-0afe-4897-949e-8174746b1932,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: b182720c192e11f0aae1fd9735fae912-20250414
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1541117906; Mon, 14 Apr 2025 20:47:58 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 14 Apr 2025 20:47:57 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 14 Apr 2025 20:47:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wa4HBhP5LEwKNJTk8nM71e4mPiDiAectKw9jHN1mxcnh34F+83cv4wUD6q/MTAJ6Y85WHeSBv//MogOSuMs6VrXp2h89ktbB9ES1qxBcfDfQOrCyx9WqpP3RqV3Cz8XXeFKGRCQPQLb1wfqPVzuVfMRx7iF+uPtGkLV8MKsna6dpPgvKrGwvoldNhRuLUkde63g4y8CYG6lsWsgbvF2VTUatcLvGwXfK6bwOkhsJwHZUddfpJzdf2tkBYZN0INToyG+7zeHH6Wct7i+4ng8Ix8pAFXqceyTWw5e0mkSXfvdKTeqcrW1PABJN7g0v/rkT1OdrXaUgUwTOt2Aqd7IzIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LkxgM6tVmewzNOTio0jcWngtKpqbGAMcoWa8LYJVW/I=;
 b=y41FIrI+ma/Nk3Z/V/EyXYomQqYSOjssAyfWD/k+vlrdatuGB1zHGLOo7JmjoFJiGS3uamhaR3Jh1qXfgCACXN40PIdBEU6hwLP3ypivPxiGGjxxPytxYLNpsolyacPRauTWy6noyJNNAASigp4hNdnCrrlJLamhxJ9bqiyYLk49sIBtdgPDidqWPXpkl7OS/Xa2jGvBtqSUa4kGep4kDt1bhZipw6LdStYIvUyalnHTFTBaMW5En6ViyvOSn4YchNw9+NhWXgcQ0j8sr2PASxOyR3tRkfnZMqoT/F8pflMHvrJggVw78Lq7iZtZj7NKj9f57A9qHgJRIfdpR+DpWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkxgM6tVmewzNOTio0jcWngtKpqbGAMcoWa8LYJVW/I=;
 b=ij1vs63wnYh1OtlTlMJqVu2UrWLWO3JV9o6wbEFD+c2wrB9dF4u9UGv2B4hnPTVhUheQxWnlYJb33l0J5G+OhlCCMXayh7qUmuPF+uX/C6Ne49cVqyLZNbl4gRdxP4GS9OYY7a4er4racL5NyvhanB8LTTdFGoQ4CCiqQFwFTV8=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8000.apcprd03.prod.outlook.com (2603:1096:101:181::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Mon, 14 Apr
 2025 12:47:55 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 12:47:55 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH 08/24] scsi: ufs: core: Change the type of one
 ufshcd_add_command_trace() argument
Thread-Topic: [PATCH 08/24] scsi: ufs: core: Change the type of one
 ufshcd_add_command_trace() argument
Thread-Index: AQHbpN51K/R0WuzNi0Sn8+hY8oP2+bOjLSQA
Date: Mon, 14 Apr 2025 12:47:55 +0000
Message-ID: <ca521013215c4c521eebe97d641f290d950dfc74.camel@mediatek.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
	 <20250403211937.2225615-9-bvanassche@acm.org>
In-Reply-To: <20250403211937.2225615-9-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8000:EE_
x-ms-office365-filtering-correlation-id: cf8cbe5e-e451-4397-8780-08dd7b5293c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?emR2T25TdmphbWJSL1lHYm5HQzZOc2NIakRpRTI4TUFRdng0OUJQeHJjNHdM?=
 =?utf-8?B?Y1REdS9BRWJqSzRLWm9HdFIrcGgzSGdqWVBFeG45aUVqVWFsZ2JNai9ZZXM3?=
 =?utf-8?B?b2s3M1dTMU4wMFJTTVhlUlQrYUxqUzVFVEd5VmpySTdNdkw2cnZiNHhIQktn?=
 =?utf-8?B?dTUzZmg0L0hoRjhmSEtNeitZZjJ6RCt2OHZyNWVhVWFuaEpOOXAwUXdDV0VY?=
 =?utf-8?B?LzBFSVh4cVBFU2cyNytGMHU3ejJydFI3WjJFMVJycUIrZVhCZkgzRUdHZytC?=
 =?utf-8?B?cnVPQ3EvM0xYbVdibndaY0RUQUNRbkV4UVdhNWNJVmJaTklEMDhXd05WNE5W?=
 =?utf-8?B?Q0FFNDlJMW1IdzZzL2o1RXpPbzJNYnU4WW0xMDdIZmxBcWFIK2cxRGtEdDNn?=
 =?utf-8?B?a1E4RlFMMHdIb2NzOFV0UDdoWlljOEZ6MmltMjZ4cTJoYmMwN21DeTZUTUJt?=
 =?utf-8?B?VGUzRktDNzgzVjVkekNFbmNKRDhUeUlnMXZCYXI3eCtSM21zTzVpdWtWSjI4?=
 =?utf-8?B?dVZqa2dVcGN5QWFqUWhlVGl0SDNTeW5WR25FeHpUN0VvbGlnYzd6eEFlRDdi?=
 =?utf-8?B?S3NxSmNTOFI5Y2xIZjV3NHpidUFoTXRKeWVWNzRFSE5ZMlZoSUhZNmdtNWpC?=
 =?utf-8?B?eDdDMWNwOFlrZHl6RmVZQjlNdUVrWEtEQjlhU1RkbGdRSjUzenFLWkY2cGZH?=
 =?utf-8?B?dkpWWnhHd29oWWRtclBXOUx5d2d4VE9Qd1ZTSUNRaVhjZ25zOTNSSlNjTWNH?=
 =?utf-8?B?V1hXOFhMUmhqNUc3Z0xwMFVWSG4zS1BEa0pFY3pwVmNYR1grMHF0a0RwTGVu?=
 =?utf-8?B?ZVl1akxjUzhjM1hPd0xYYmhMbkNyWXJ5WHgrZDlEQTRXcmozSUFMZ2UvMG95?=
 =?utf-8?B?NzFMa0xwRUx4VjBucUNJTS9qRytXdDNVclNPTEhYZFdIZTJ5RGJWbVJoeGgv?=
 =?utf-8?B?QVpXVjliMjk4OXBsQXdSNnpkYnN3UG5pQTBoTlZBeUhGU0xJSU1VakZRV0F2?=
 =?utf-8?B?dE9xdUFTWG50VzZhUTdjMjk2bDBteDFSS2pGZC8rbllWakZkdUpPMXJHTGc2?=
 =?utf-8?B?YlozSFl1SklNQ0MzMEdISlBmRFVuSyt4MTJFSlljcUgydXR1SjB4a3EycTAr?=
 =?utf-8?B?TGFIK3YyVnI4ck5Vd2NnbldzRVdTRGR0NWNlWHVnVjBUTU10cFBsajErZ1Jm?=
 =?utf-8?B?M2cyNXlZZzE4dno0OGpWdkV2UGV1NVdyLzR6MUtYNWxJNzQ2d1JKLzQ4dDRy?=
 =?utf-8?B?ZHNrTlkzSi95bVNuUjFwdUMvSzlDaDVHNHUxQkZxL2Evc2ZQTFFzMTh5bFRp?=
 =?utf-8?B?bUprb1B2ZDY2UWdxR29pM20xVlBlK0tGZU9EMmNJaU82OW9KeTZ4SEpTZmJa?=
 =?utf-8?B?a21zTlhaM2U0cThxQ3cxRlhRTGpvZnNMWVJLSnE2eVVQUGk0SFJpTWFsbGNv?=
 =?utf-8?B?Nll5VC9ORktaWjluZ0h5OEVQR2s0amhiYm9DQ0E4OFVvQUhwM2dBVXRwSnpi?=
 =?utf-8?B?NXU1b01VRy9pZmRFRWFMUkRxb3BlWktPR2dWRW5TSkJ3dStGL0JFK1R3byty?=
 =?utf-8?B?ZUxpcEhBRzlyVHlOMlQ5cGxOeHF1ZmhwUmpxTGo2a2JZS1Zqa2VyWjlTcTR5?=
 =?utf-8?B?NG1JZlgyWmtlZmkwYlJlSXQxUmhjMjhsTjRTMmtsOXpwV21VbzRRWDlaZUFC?=
 =?utf-8?B?Nnl3QTNzWUNFYjVuMmtoSHlDc05jZEQ0bU8rNzJmcDc4Rkc5Z1BtaGFZM1pB?=
 =?utf-8?B?ZkJPckRPcTB4ZXppMmxlR3NMWFdCbmg1YXV3MldFcXhHQ2lxMWpXcTlIZ1Bk?=
 =?utf-8?B?Nlo0RnhsbGpTaXZPYk5UUmg2ZG1GcUozMG1ybUpFNERSTWFrNUY2aytLS3Jm?=
 =?utf-8?B?QmFJQ3Z6dW5teFlLTGQ5T0FhTDdubkdQcGpqOGVudlVLTnNCVHRKOWdUbVgr?=
 =?utf-8?B?bjRnSGxMMUgxR2lWd0NBNUVENWlZc2lmaDh6R24rRUEyMnZQWmg2WU5ENnNr?=
 =?utf-8?B?YVQxYjNpaGJnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVdNaXJ1MklqRUd1NzN6VndqZjhNeCtiWllGdm55QnZha04xVFN4a1ZaVWpr?=
 =?utf-8?B?SzhkSXYrVW9LYnFCWnpETmVqZHJjZTdxRENEQnFNczlMRXpiSFBKMHFUbFh1?=
 =?utf-8?B?RnNlTndjZ2dFUTRSREU3bzN1Sm5YRUtFVTZiRXdjcTU3VVNnZ0hTMURvN3JS?=
 =?utf-8?B?QWVIVHk1R0l3ZDZKYXYwM3ptQnBUdzkzUC9Nc0xQeGh0UHp4NXZuTC94cUJs?=
 =?utf-8?B?SzdibGtVNzEydUkzUWJtVUdHN1o5NGdJSjVwZ0xoSHdnajZmaE9KOFlkVWEx?=
 =?utf-8?B?am4xT2gvWVdRcTRYV3RmanBBRWJvcG1SVDd4RDFkRXVoTUozRUJKb3YxKzIr?=
 =?utf-8?B?TkFsc1ptUHY1NnNXNXlqaGdQL3FJOThoUWIrMVA4eGhjSmtVaFBQZWI1MmFS?=
 =?utf-8?B?YWdZTXBLNkhQdURoa0NLMGI3VjhEZ3drRngrenlibGUwZXlyMW1GSEtHdUM5?=
 =?utf-8?B?SkpteTNWVWQxemNuN2luazRDUUw4R1ZyUGdCY3RqUE5vRVZvbEVzRnVKdXIy?=
 =?utf-8?B?Q0ZTTGlmVGJwREY1Vm14WXhZTkc3ODcvRzBVdU8ybnlOVm8zYlU4NjFjUjdO?=
 =?utf-8?B?UG9JSWFlaTdBV1I4aHZ1K0RWcExoY1hjTk5HVWtjLzhOUnQ3VEFKWnFEUWlY?=
 =?utf-8?B?cENrTkk4Y2FOYkxVc1B3SjAxZXNmNkVDOFhJWWVWVWdnZDVjREh0aU5oY0FO?=
 =?utf-8?B?TE9yY2t0QTV3eS82RkZ5NVJ2SWtydFc3VVpoL2JYWThsd3pVQ01haHAyWHpB?=
 =?utf-8?B?VW9FVEMySWZROTE1Qkh5MmgvaXNocGNFMGdpYU84K3EwNnNFcExKWGs1QTFV?=
 =?utf-8?B?TFNIdEZEb3FPdHkyckhHOUE2TkhTTzR5Nk5WREZxSXozVDdoSHk4OVhjM1gv?=
 =?utf-8?B?WTQrWTJ0cEhMQjRtUFNRb1ZmN0doa2JxSGgvcEt6NTlkN0tLVFJpeHE5aUF0?=
 =?utf-8?B?dmZXSzVOc1pGS05ZWEd1dXN4ZEdOaDF2cFMrdVhwaGZCbWF1K2hFUVF3L3V6?=
 =?utf-8?B?RXFhTTNkLzRHcmgrVXd3ekdTT0tXSnA5blgwOTB4dCtyVFRBL085WHBkQjRJ?=
 =?utf-8?B?OU9ma2tQVWE3aFNMQ3NMc3pEMDF6L1BUQnZSTCtOQmswUEgxZSt5L2gyZElo?=
 =?utf-8?B?Ym9zSVhSd2g2S3I0U0JkRlc1YnpGSTZFbGRyWHpqL3JrVjYwUjJ1NTJzMUwr?=
 =?utf-8?B?cUZlNUJ6a1hHdFZicGMzTU95bDhTbCt3RkpyRHl5WG9aRkFIRGxiVkNTYm8x?=
 =?utf-8?B?QWRLQXNYemhkZEFCR3RCYmxHelJDOHkyRmZoVjNYcnBLa0pHYzl0eWRFcDFT?=
 =?utf-8?B?cGlGcHAzMEdlYlkwQ2xpdVRsdHpMQitVWjRwK2tDVG1TK0NkN09lclBEMmpQ?=
 =?utf-8?B?Sm1tb2dpd2ZzK2JwTks1YkZreXVGNmVvK0wrdldNTnVWYWV1OU5vUTdndXd3?=
 =?utf-8?B?STFZRmh2OTEwdjVMQ0xHUzhHTThZSExkUjVLajM5SjczZnQzS1JidURrNHNw?=
 =?utf-8?B?b2JVcG14TTRoMDM4WVhQblhKekx4RTBqTENLcUVTa3Q4azRCam5Oc0JGVzNV?=
 =?utf-8?B?Vlphc1VSOGxnWldac2lHZUZZeTR5T245M2poeXVoMVJhZ3BEbmdKdVk4Mkxj?=
 =?utf-8?B?cUZjR3BwZGdTTndnUnB1OXJPQjk1SHMydUM0VjdUa2xrUnNiaklxVHlVOW10?=
 =?utf-8?B?WlNweHllRVFkRGtBL2hYQS9ZNTJuajBsM1gvSXJSclk1M1lMTWZiUkI5Nm0r?=
 =?utf-8?B?K3J0Q1NLcVZ0SjdzNGtlak1TQ0gxZFRiZHltejNVYnpLSnVpaXVMNkJrZVl1?=
 =?utf-8?B?TU15S0cycmRuMFFUZjc0MjFQN0h3NnMxdG9GUzFUTUxMSTBscENBUmhmV09m?=
 =?utf-8?B?WHVJRndUWkloZC9qZUV0aVA4eUxRVEwzeG0wUDlUZmpsRXA1R2dwWGZmYzFt?=
 =?utf-8?B?aUxjRTFkUFNSVWhIWHJ2a0VBMFNwR0E0R1QwMlR5b1FzNkh4MSt1R3Q5QzZj?=
 =?utf-8?B?cEpxSWFLSTBJTFRjRWVVdWt2RDBkN0djV0M4ekowNE1tamMybGJIQnNBT2M0?=
 =?utf-8?B?b2UvK0YzSWxEZExnb0oxbG5Qd3RmcFhnNUZaWDkxZmsrWE1VYXQ5MERsdCsx?=
 =?utf-8?B?dTk3WXp6aytqTFRKSjZ2ZnErb280TU1KME80Y1JzQlFHS2JHcFY3R0hYb25U?=
 =?utf-8?B?eXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <47E75537B8A9D84CB1B7A6D360F2F3F0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf8cbe5e-e451-4397-8780-08dd7b5293c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2025 12:47:55.2891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DlQpdb49UwQe1AKiFy0DE0UwqnyaC3j7G3R1oSMSSOgKEdLf2U2P7GVMmfwIiTrgBeave5cxMeXa6ndG2tGGZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8000

T24gVGh1LCAyMDI1LTA0LTAzIGF0IDE0OjE3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IENoYW5nZSB0aGUgJ3RhZycgYXJndW1lbnQgaW50byBhIFND
U0kgY29tbWFuZCBwb2ludGVyLiBUaGlzIHBhdGNoDQo+IHByZXBhcmVzDQo+IGZvciB0aGUgcmVt
b3ZhbCBvZiB0aGUgaGJhLT5scmJbXSBhcnJheS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEJhcnQg
VmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2Fu
ZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQoNCg==
