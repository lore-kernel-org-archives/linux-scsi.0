Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D26B35C6B7;
	Fri,  4 Sep 2026 03:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788492107; cv=fail; b=FtsOYfqsgjIaxAD/6y2AkCeRm8KKYbKpuRrllF3qBlXEY6SgTFxC96NbzBkfL349IgmmSfGbfB+9a2D8GqESqLhmtBpFnJ6anLpVLDcuPhscjJQDuwA6FWoU+8L85owuHgZ6iIeJNZvxjkJsF5YjMcNmO+hWw+8wIQs5csSLzrQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788492107; c=relaxed/simple;
	bh=wWm9Aatnq9oGKm7lj59JhJSkwowdg2DpfyNNKcqclB8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DK3nCWE/lY5WB2wHq9w2/DqU8c7QFR2ixqxQV8vWiwWlTP3w5uiSgoFbtkwzc+sfTtQdmvZcTT5/B6hLOHEsS/YTVspR3OfHeSjy4Kkc58n5fC/Jnbay0n3ivfzWUhV7ALqCkwwg6tZJnCVbLWxQsarWg7iT+iSpke5X5K4A6pU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=lOpblpho; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=EQwft3/w; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lOpblpho";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="EQwft3/w"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788492106; x=1820028106;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wWm9Aatnq9oGKm7lj59JhJSkwowdg2DpfyNNKcqclB8=;
  b=lOpblphoJko7Nv8j2cMfY2d3zVevpDct4UUwbEMMY2OURM65EAgIbOUK
   +JH704cDlwgYONiRVnfTJTleZKrbTpVDQMNlYlXDKBJCUb/k+EwI+C2ld
   jkkJlB/lnqmusZP30kYq9dXx2ffvhlJIwEvGg3zi5MLd3RbEdanEByKrL
   7c9N7RLkcU+S78cpdN2njLN8cuX0msAy11v4GCPqqoD2qvcHO5+IA+e8V
   60Gc+Rf3GSWWJYZ2PPIFEw01H2HBt9XQtwlwQtMx5u4IfjpjJuLJ2cZp9
   Gi8Fd4479GExOcZ6UEuC8bMX42uAp771dtCN+HxiG0FUNlQY6izeKAbOZ
   A==;
X-CSE-ConnectionGUID: BldUFbv6TISKPtYV2/dtwQ==
X-CSE-MsgGUID: 3WKKApMvRp+NB/7nM543gA==
X-IronPort-AV: E=Sophos;i="6.25,260,1779120000"; 
   d="scan'208";a="153348528"
Received: from mail-southcentralusazon11013028.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.28])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Sep 2026 11:21:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cMyHkBPYzGyGKJqjCyOTIohe1k1ETsUhLxkEqyYVVMZO3uKQNgNU/LEcBFTNqWPASN6CaULFkVJPlYwH4tRrd6nVVGr9IhNTuWZ/iMZ8/g903tL47cTrjif9eg/802MRMVb8x+tTTla4JacfmxWoEXUNGwCab+ghvRvCqnZtHs7y2501VuSz9r6EyZ1DEL5BorqR6NbakRkKMNAGC+DxQBQliJDEvPIWu6980fKiyLBb2LvfXIzxra3D+63fo2q/5wi5/XMuO3NznMIzo2Q2WIbqr3jgq51WtyEVTBlqmYURA3yAgTc1sLilgafe5K/qMu20f2oSNHf6BSg2YMu0QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wWm9Aatnq9oGKm7lj59JhJSkwowdg2DpfyNNKcqclB8=;
 b=MEj+9Qpn+VHs781IqGgr2ll2VE5/Hi4boNo0QLL5LqP53hI+n/ZxbGyIlQxCyKa+EIVx+V7MNPFsIiJLknCZC1lK3h7djy/S3wy2kw0uT7IM2NQ5utS1Zv3A9a08lq4T5VIXCviQK1z9fN4huiZIJMk8cs6Twv8AC6T/nC+SshFMxyLVqZIqj2xFqgVNNffoSCGs8urgQW03ns+MAOKmh0q+9dKrNmhBweRrPMXUSm46YHKnV9YfFCfkSNOMKUiTMJdRcA33ec+DACr0Pu2P6g+uRbCQN0eOJjsZmBI+E5tPjG9K7nlDhz8drPLCuBNE6UKmfLnuW5ytasyUWy9aAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWm9Aatnq9oGKm7lj59JhJSkwowdg2DpfyNNKcqclB8=;
 b=EQwft3/wfBsuL/iCa26bC1rnI2MRfgl+IialsiTrn9kezVyinQ8fuehrvmDzinJvR3PMVeGc3MkUWftRQGFeTl97auNdkpXpU4YKxRCRsYfTm7aZZ/chmrQbtS2063iFaPGz77/pPbDIeUsO92iSDr+8OBtlLmMuVaw1WfgfRQg=
Received: from BY1PR04MB9561.namprd04.prod.outlook.com (2603:10b6:a03:5b6::11)
 by DS6PR04MB715843.namprd04.prod.outlook.com (2603:10b6:8:412::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 03:21:42 +0000
Received: from BY1PR04MB9561.namprd04.prod.outlook.com
 ([fe80::3869:e494:2fa8:9888]) by BY1PR04MB9561.namprd04.prod.outlook.com
 ([fe80::3869:e494:2fa8:9888%5]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 03:21:42 +0000
From: Alistair Francis <Alistair.Francis@wdc.com>
To: "mst@redhat.com" <mst@redhat.com>, "alistair23@gmail.com"
	<alistair23@gmail.com>
CC: "jasowangio@gmail.com" <jasowangio@gmail.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"eperezma@redhat.com" <eperezma@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mkp@kernel.org" <mkp@kernel.org>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 1/2] virtio_pci: Add a quirk to force DMA Map API for
 certain legacy devices
Thread-Topic: [PATCH 1/2] virtio_pci: Add a quirk to force DMA Map API for
 certain legacy devices
Thread-Index: AQHdObPMZURx+Bsr6U+POQRQ5GRRNra5aHuAgARdHQA=
Date: Fri, 4 Sep 2026 03:21:42 +0000
Message-ID: <22cb4c64c9d7a2c5590bd0ea74a399169539d206.camel@wdc.com>
References: <20260901014650.2728658-1-alistair.francis@wdc.com>
	 <20260901014650.2728658-2-alistair.francis@wdc.com>
	 <20260901043810-mutt-send-email-mst@kernel.org>
In-Reply-To: <20260901043810-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.60.2 (by Flathub.org) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR04MB9561:EE_|DS6PR04MB715843:EE_
x-ms-office365-filtering-correlation-id: 6ef5942c-de27-41d3-a929-08df0a33a40d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|366016|23010399003|7416014|376014|10070799003|38070700021|5023799004|6133799003|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
x-microsoft-antispam-message-info:
 o6W1xMr6WqCABq20OWNjRSrxOLDv/0/wvB6QMfMdCl9Y35eJpT4dKnbSel6GIB/0Ve3MFn1QY3NsgYSrvPnW7qUOvWBmFr1RQcA++Qee22yFpq7byCLyGGa+77g/l8sdl1nufcqm1tRoy/38zP1njZNbGLtKaJOEtASv365zopZIVGVH0LFLawup+y+d5U5Ix542HnoF2ZdYBhm/TkXveEi8CWhah6ienligvH8F1JlFXIpGxH6Uy+0fYogI43xlOTFx79CFMeH1zGyTPdlwvVUuAJRCHuET561klN60/1eic39reP0Mi3yeXuSrucyQ+/cRazGc264BpaUBQ1dGSY1u/YB50PiBD1n3TxTYfYkPSfDvfo6m1knIJDeb8XOobVkh2l/0k+TW41aRMWCWAe5rn6wEoJoOuFGW0NP60V41wS6QDhIp3orzJL44YgPkHbCO4hH/KTnQBQJAJU/In/0DJLzk3xsMm6NXkUvK+TUf+mckbFv1DYonOXx7dg1usq/7tN7ZR/WVjiQEraRBEmXaSC+HnNy+03NGrSOQ75p/f1+kCxPONQWddKHhwwtRHT7ixMBbQI5YOMlzgqs/W+osfe1W7oFnW4ePS2lHgJHLPEkzZxsGsjnFMYhQAV21pR/liZzj/5nUj3GfhuESdEZXLL0m6SueRlbbihLCpV1v1hR8FBvPvl2OUCEwrFzQbVSj+34KqZRCJMQ7+C4dQmAI4/emScIIYIaxFJbKrSk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR04MB9561.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(366016)(23010399003)(7416014)(376014)(10070799003)(38070700021)(5023799004)(6133799003)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UFBkQm1PNU5BTzlFODdwNXFGSzhYc2E0bjh2QWZ1REdWajUxN1lKTytYNDZ5?=
 =?utf-8?B?VGk3Q0JpUjRXYzJYS21CREtxQmVMcWN4R2FjSVVCNVVVNlpROWhiRGhGRWM4?=
 =?utf-8?B?ZU1vZkpVUUtvSGZoOS9SNmY4Zk8wVlZpa0U5VDZqeXdORW9iQlVONzVrNE05?=
 =?utf-8?B?OVhzT1FGR1lXbGJkbGYzdGZyV2wyUU9peFN1bVZVRmlQRHQ3NXRpcEIvU0dQ?=
 =?utf-8?B?eDUyRER2Wmt2eFZ3d0k4UDZnOEplTkx3cDZROWVKd21tUjdVdUQwMnJQeTdC?=
 =?utf-8?B?OXBPVnZpYnhMNXRCeVBNQTZSQjJ2ZXBuc3FrQWJXSW1NVkFiY2VxMDA2dFRZ?=
 =?utf-8?B?YzJmRnF5bzNqQmFoVzc4SzRmTGdqU29yVDIvS0doUlVEMTNCYmpDQTNuT0Zm?=
 =?utf-8?B?cDFmTmFrSEZtbzhtSVhLd1dYVXZ1RjNyNFgwdFMzWm00Q3NUYStxV0dtZDNP?=
 =?utf-8?B?NTdGdVF1ZUVIaUc5VFdvalFaa1J0dE45SlREZzRSYm9qYkpWemdhZlFIU2ZC?=
 =?utf-8?B?by9ET0lGVlBPQTlUaDV5UVJWeFpWZ3ZaOFp5Z09pRHd5b3Bhc09ZYjYwTkhZ?=
 =?utf-8?B?Nm9KQ1RaWnY3ODBzdzNETUNnc1h4aXd2WGV5dkh4MUNUUlBxa0toaEtkRUdZ?=
 =?utf-8?B?ZDN5ZnZMNUZBTS82bnVOTmtFQXJrMzRLRkJPNkZLMFVwS3kvRFFFMERwT0hM?=
 =?utf-8?B?MVlaV0JRRHdock1JT0JVVFB6WWxOSnVBRHErSFVSamV6RG0ySkIrclVXRVoy?=
 =?utf-8?B?VnhyS0EraVFZSGFaSGRmZVM1dk83NVl5Ky8vYnhOWGhsM3YvM2x6TjhlK1JZ?=
 =?utf-8?B?VDRsS3BwWFhJc3E5TnF4VWt4eVQ5THN0ZWFhUm0yYk03SXUzUVRTODJyL2Uz?=
 =?utf-8?B?Q3ZWLzhLOG5HNkczUjhxZ0FQaytTNFVCZ3c0TjlGT1U0c0RFYkVKYXY0dnlL?=
 =?utf-8?B?bDI0U0czZHNhQ05kdlhubjFJS2RlTy9xOFhUTUF3eFRpbXNnWi9XWXByeDZx?=
 =?utf-8?B?Z3J0cUh1bTVPVndudGJxZXpveVozRzYxSWxqaVM2UnlBU054enBIbGVuaTdz?=
 =?utf-8?B?dldqNThOTmdTcW4vM2c1aDBOVWg5SUlBeGZWbC9YeFp2TFNlZ1VKWlJuZllT?=
 =?utf-8?B?ODBEbUR1SmdqZG0vSHBqMSthaS8xUmRNUGZCMEF6Mlk2L0ZCNU1pdmVaQWJz?=
 =?utf-8?B?aEljbisxczE2Z0o1ZnZoNDFySXlZWC9reHhXY3lWcjRGRWFOaG9jc0dBT2pV?=
 =?utf-8?B?MFpUbU8wcjVpZ3RYOUcxb25BSll4M2JycWRrb0xJVlJlbThRdzJORmNzRVFx?=
 =?utf-8?B?MmpOWjJhMFpXVVFpWmFvYkVIbkVvaXU4Qk5RTzBsRExyZlM0SjZZQkJhKzVF?=
 =?utf-8?B?R0RBRlFoN1Y1amhzQmkvVzFxSDFiNlZyZlVYMkt2SDJ5Rm82dnF1RFdPVEEy?=
 =?utf-8?B?RFNhYUFrSVY3UXF3RU9YVWkvZFgvdjluZnljcmxqaE8rdTBLUU1KbkJabUFP?=
 =?utf-8?B?THFadDJZeDhrcnkwMmpMczNhMjlhNTJSS0QzaGpvNm9weVUvQXpHNFJIN1ZL?=
 =?utf-8?B?NlNrRzJldVNKUWxWY1IwRXVGMUVQb3NaMnUzcXc5ZVE0d0hSclRmSkhHblNR?=
 =?utf-8?B?TVFIbnI4cWpEcHk3QktzTmdIdjllUmE1R29BbzdjYkhOUVFVNlZVUlVDZEF2?=
 =?utf-8?B?TlFDQzRyVTlNUjJmN0ZMaGNwc1Ivb3RiY290Ly9QQjlUKzFrUnFlYStWUEFw?=
 =?utf-8?B?c1paWFphMmtoWGttMTlxaVYyM0JObmJNcWt3RWp6YytJYUVxQ21uUXM1NlZZ?=
 =?utf-8?B?RzBpQ29wdm5ZUzNvTGs2Z0lLU0pIdFNROTI0RWZWdVY1ZGhnYmRSK1AzN0ZW?=
 =?utf-8?B?RThMbXAzSVcyeUY5blN2dXI2anpUMzNsQlRyM3c2N3hlZlk2NVZGQTlXSm1r?=
 =?utf-8?B?Mmo4b3g2aVN1a3dNQUtkQ1hrOVlpdFlqaksvNGdsejFTRFR4NlV4WjRQUGU4?=
 =?utf-8?B?RzhuaWk2TStQL01IcDFUNS9LN2E0MzNabXlqSTdJTW1rQ2FXTnNUaXJkYldL?=
 =?utf-8?B?TmtiNjVkNVlUbk43TVVhTGMzakJmc3I0bXNoVnpVSnNsNkJ2ODM5SUFWLzNa?=
 =?utf-8?B?TzlpSWNSMEF2ZGFZb3AxZGZ0MkcrVU1tTm01aTQ2N1l4Qm9ySUk3VVMyN3Bt?=
 =?utf-8?B?R3BmQzA0cnUvZ25OQnZjT09lWjV6QjExUUxqR1A3N1QwU01RR3BZY0liVFBV?=
 =?utf-8?B?amtCM0Q0VlRBbzhET2JCeGtjNWQ0SkdaY2V6NDFpbS92QVI3S1hubGxYUTdT?=
 =?utf-8?B?enJZdG1aZHRYbDJsZ2o2U3NDTmRCckpDbFVvbTV0cUpnb2pkN0NKdjFwTHdT?=
 =?utf-8?Q?XQLY2Nz0FNnirZyPwY/HpwE9kzUYjNXcm1csbIvUFPBhV?=
x-ms-exchange-antispam-messagedata-1: musCjd5TSJRdS6U3FDjRPbs+hWsRN8K5/4o=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E3C55F2F5CB424EAB48A15F562B2433@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	zh5P/lrGxyaVLuybDob3DD5nPAMRvTjra3YLo400ZFg43EvMNNjHJgzfQvgTiRKydDuX+nTaV3wmPoDZVokQwVq2so5AmJF5AS3A9StR6d+ZNhOMuVTBpFDCRmShC4ntOVP8Wf02C/XiwHfuUpdPIWNG97xy97I5jUXXW4/lyjRBqNvzMUVxyyhIlblSs3uPZiN7aZYn1HsLhgzn52tRjTwAKx8XJeKWdVnZpZl/qhQSq4IxuCCC868yYob36fJu+9Shu+mVL1/KRigoLRRKJ+rEsNawEsRwR0N/Eb3g1vORD6PLp1So3TPV9JPROG7FN2gDgV/7COdZGMd7ZUxzuA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jUah39s5MOBNgB7tlTAVXZPP64MltWxd/EQDN9H/8VDXzirh1kaNl8QqHwwkg5LKrUYpW1at/6pfYUgA6BTIzr8b/HxQ9xJ9153dN9PJn/aalqArg6XCAzzOlZJF2hTycNmDhCSmOplMmI2vwe64xZGknn5s0XaT757yqRVQD12Yh08yrWiz324Pz9LGKI2piPWXkHmxRA7cC/gZ1CdbaATrXwErEnDMQJXKDXoAQx+rS2cq22bj3L3zJZ8uo53KK/hZTat6uv4jYN2XyrKNvumvSxYJ5kzWVVWhONWlQVwAhXi18W7Rrx/ImjImI+6pjqs3/Ov14biNFM0g1gZ1s73T4MXxQy5ENOr9DmUWwRxRjGevF9xFoXBad+l1T3k8p0RRe2miKYx/hz0eD59dvEZpCrg5C5kRhvSCReFHn4AqCPOwtTmUMlLdbO1MKHuYhaIf4ROdaJ5kIvdia4IeHLs4dEBauC4gBgzUS5sOKQZccf/5Tpg/lWzuJWnLrtCQswOvD/M3n6dpqE1dV9YPPtSqrGSz+wqagD7lYkuyx41FgfJEXR1CbpIijkAHchRf6Kt+CJ9Qcgplf3RS1Pem3Ibo0fqLzGH3bg9+4F2+GGMxkn8c1KJFzv5RJJB+QU9N
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR04MB9561.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ef5942c-de27-41d3-a929-08df0a33a40d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2026 03:21:42.1501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Q8XSW9Em/mjvHmAiyAlZS+e8K7E6FQRYKHXZ/45MAWZ/YmS3VGG4VFNIk0WlNx07Pskkcd8hxIHD1Bsiz03Q8sixPwMJJsPRLPmLx0h3sY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR04MB715843

T24gVHVlLCAyMDI2LTA5LTAxIGF0IDA0OjQzIC0wNDAwLCBNaWNoYWVsIFMuIFRzaXJraW4gd3Jv
dGU6DQo+IE9uIFR1ZSwgU2VwIDAxLCAyMDI2IGF0IDExOjQ2OjQ5QU0gKzEwMDAsIGFsaXN0YWly
MjNAZ21haWwuY29twqB3cm90ZToNCj4gPiBGcm9tOiBBbGlzdGFpciBGcmFuY2lzIDxhbGlzdGFp
ci5mcmFuY2lzQHdkYy5jb20+DQo+ID4gDQo+ID4gTGVnYWN5IHZpcnRpbyBkZXZpY2VzIG9ubHkg
aGF2ZSAzMiBmZWF0dXJlIGJpdHMgYW5kIHRoZXJlZm9yZSBjYW4ndA0KPiA+IHNldCB0aGUgVklS
VElPX0ZfQUNDRVNTX1BMQVRGT1JNIChiaXQgMzMpIGZlYXR1cmUuIFRoaXMgbWVhbnMgdGhlDQo+
ID4gdnJpbmdfdXNlX21hcF9hcGkoKSBmdW5jdGlvbiB3aWxsIHJldHVybiBmYWxzZS4NCj4gPiAN
Cj4gPiBDdXJyZW50bHkgTGludXggZW5kcG9pbnQgZGV2aWNlcyB1c2UgdGhlIGxlZ2FjeSB2aXJ0
aW8gaW50ZXJmYWNlIGFzDQo+ID4gdGhleSBhcmVuJ3QgYWJsZSB0byBhZHZlcnRpc2UgdGhlIENv
bW1vbiBjb25maWd1cmF0aW9uIGNhcGFiaWxpdHkuDQo+ID4gQXMgbW9zdCBQQ0kgZW5kcG9pbnQg
Y2FwYWJsZSBQQ0llIGNvbnRyb2xsZXJzIGRvIG5vdCBhbGxvdw0KPiA+IG1vZGlmeWluZyB0aGUN
Cj4gPiBjYXBhYmlsaXR5IGxpc3QsIGFuZCB0aHVzIGFyZSB1bmFibGUgdG8gYWR2ZXJ0aXNlIHRo
ZSBDb21tb24NCj4gPiBjb25maWd1cmF0aW9uDQo+ID4gY2FwYWJpbGl0eS4gVGhpcyBtZWFucyB0
aGUgZGV2aWNlJ3MgaW5ib3VuZCBUTFBzIGZhdWx0IG9uIHRoZSBob3N0DQo+ID4gU01NVSBiZWNh
dXNlIHRoZSB2cmluZyBkZXNjcmlwdG9ycyBjYXJyeSByYXcgcGh5c2ljYWwgYWRkcmVzc2VzLg0K
PiA+IA0KPiA+IFRoaXMgcXVpcmsgZm9yY2VzIGEgc3Vic2V0IG9mIGxlZ2FjeSB2aXJ0aW8gZGV2
aWNlcyB0byB1c2UgdGhlDQo+ID4gRE1BIE1hcCBBUEkgKHZyaW5nX3VzZV9tYXBfYXBpKCkgd2ls
bCByZXR1cm4gdHJ1ZSksIHdoaWNoIGZpeGVzDQo+ID4gdGhpcw0KPiA+IGlzc3VlLg0KPiA+IA0K
PiA+IFRoaXMgZG9lc24ndCBhZmZlY3QgZXhpc3RpbmcgZGV2aWNlcyBhcyB3ZSBhcmUgY2hlY2tp
bmcgZm9yIGFuDQo+ID4gb3RoZXJ3aXNlIGludmFsaWQgdmVuZG9yIElELg0KPiA+IA0KPiA+IElk
ZWFsbHkgd2Ugd291bGQgdXBkYXRlIHRoZSBlbmRwb2ludCBkZXZpY2VzIChsaWtlIHNjc2ktcGNp
LWVwZikNCj4gPiB0byBub3QgdXNlIHRoZSBsZWdhY3kgdmlydGlvIGludGVyZmFjZSwgYnV0IGxv
dHMgb2YgZW5kcG9pbnQNCj4gPiBoYXJkd2FyZSAobGlrZSB0aGUgb25lIGluIHRoZSBSSzM1ODgp
IGRvZXNuJ3QgYWxsb3cgdXMgdG8gYWRkDQo+ID4gY3VzdG9tIGNhcGFiaWxpdGllcy4NCj4gPiAN
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBBbGlzdGFpciBGcmFuY2lzIDxhbGlzdGFpci5mcmFuY2lzQHdk
Yy5jb20+DQo+IA0KPiBJIGRvbid0IG11Y2ggbGlrZSBoYWNrcyBhcm91bmQgRE1BIEFQSSwgaXQg
aXMgdmVyeSBmcmFnaWxlIGFscmVhZHkuDQo+IA0KPiBTbywgaGVyZSdzIGFuIGlkZWE6DQo+IA0K
PiBwdXQgYWxsIHRoZSBjYXBhYmlsaXRpZXMgc2ltcGx5IGF0IGEgZml4ZWQgb2Zmc2V0IGluIGEg
bWVtb3J5IEJBUi4NCg0KU28ganVzdCBwaWNrIHNvbWUgaGFyZCBjb2RlZCBhZGRyZXNzPyBUaGVu
IHVwZGF0ZSB0aGUgaG9zdCB0byBjaGVjaw0KdGhhdCBhZGRyZXNzIGlmIHRoZXJlIGlzIG5vIENv
bW1vbiBjb25maWd1cmF0aW9uIGNhcGFiaWxpdHkgZm91bmQgaW4NCnRoZSBhY3R1YWwgY29uZmln
IHNwYWNlPw0KDQpTZWVtcyBkb2FibGUNCg0KPiANCj4gaXQncyBhIHNtYWxsIHNwZWMgZXh0ZW5z
aW9uLCBidXQgc2F2ZXMgYSBsb3Qgb2YgdHJvdWJsZSBJTUhPLg0KDQpIb3cgZG8gd2UgdXBkYXRl
IHRoZSBWaXJ0SU8gc3BlYyB0byBpbmNsdWRlIHRoYXQ/DQoNCj4gDQo+IEFuZCBpbiBmYWN0LCBw
ZW9wbGUgYWxyZWFkeSBjb21wbGFpbmVkIHRoYXQgbGVnYWN5IHBjaSBjb25maWcgc3BhY2UNCj4g
c2hvdWxkIGJlIGF2b2lkZWQuDQoNClllYWgsIEkgZGlkIGdldCB0aGF0IGltcHJlc3Npb24uIFRo
ZSBuYW1lICJsZWdhY3kiIGRvZXMgZ2l2ZSB0aGF0IGF3YXkNCjopDQoNCj4gDQo+IFdoYXQgZG8g
eW91IHNheT8NCg0KV29ya3MgZm9yIG1lLiBIb3cgd291bGQgSSB1cGRhdGUgdGhlIHNwZWMgdG8g
aW5jbHVkZSB0aGF0Pw0KDQpBbGlzdGFpcg0K
