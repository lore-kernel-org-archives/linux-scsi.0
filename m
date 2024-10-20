Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F5528EB
	for <linux-scsi@vger.kernel.org>; Sun, 20 Oct 2024 06:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729406272; cv=fail; b=YIEl/LMO5nRMUnTpgpO1MKwO6LicMqb3Ams2hvyM+mHGLb1SJVMkU+nYEKTyBHB76z9OZTf03T7PT2ZhyhBjTS8oH35sgCSfnQYvwr9HdC1r+SN8SP+b4Kje4yu6blFjLFjVaJPij4hLN7664URpI/E8dzkOWZva176eHH4pGaw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729406272; c=relaxed/simple;
	bh=GM3yCAiyAq0R8pKXYmqAmhyOqPw47CsMCQ3NVKIzIr8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dq2Okms2i6wCKi8TCgL8SWBWnW/2NgxTCqSBitPhNf6tQ/xQTm09SccdTjYfwXQ2xFq1f/l4iCWvJmlNa2OWP8ifR8T/iBkUifHWPsWMswK8VJL1AjuQ8QRml9OTJRESGQyTfrlHl9ppL3WWu0HreSbrvD4fDWRQkbTHkKwtEaQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Xp4rVJeH; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=OplM0ryj; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Xp4rVJeH";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="OplM0ryj"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729406270; x=1760942270;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GM3yCAiyAq0R8pKXYmqAmhyOqPw47CsMCQ3NVKIzIr8=;
  b=Xp4rVJeHd7nWDNDT4Rghjxe2+e/eKe9o0OiQp5jmnKwkzIW0yQrtBjRk
   BbvDRLopUhKCKBRwhvkW5jdx/LnYAoKnj2Dw9M7qOz6biWKQgO8pcICtZ
   p7HTIRdMhx/UMyC6sRQ97wRAqRMtyJUo+FJUV5O1pYwgmjyUepJg2isVz
   +hhP9t1spfeluP6seDTtTEKEqSAuBxEeOQq1bS0KgCY04C2dW8EDdZE/M
   YH5ca24P3xSsEbF9j7IzAk6hPxUb8OIHi0LtceA5ZTLU59amgL+ceLRby
   XxW31OnsMDakRjBDkgqsvgfNktAQg4HylXP6B+GLNqcOWmuL0vCV+KiOR
   Q==;
X-CSE-ConnectionGUID: smOBtbb3Qxq51VRwt2yp4Q==
X-CSE-MsgGUID: bliCqh5mRBSZssnxIpUjkg==
X-IronPort-AV: E=Sophos;i="6.11,218,1725292800"; 
   d="scan'208";a="30378544"
Received: from mail-bn7nam10lp2043.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.43])
  by ob1.hgst.iphmx.com with ESMTP; 20 Oct 2024 14:37:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lRuuDW9oTDTKXM5lt21Eqi4WxUi2osA5jc0ZjP1iB8pT1RUJv+unyWK7CF42IUlLOVMICdZYToXWWV6c9zxL2/XAs8kkJKt1FssWHdkw3HJv0iSezzEV9k/EAyQnwZQ1hLk6v1Gn9r0QqEHl7lz0RZzDNnZz9JuYlEqxu5fEF6ijmNoOEL8UjultYqQHrwnN81vsWCCBGVnfJ4sLIrN8aPD157wMotFWn0g/qT6YihYxn9CifIY0yostAR/AbwOxDKxfKbIFAVh4PzUjsLnVvtCkDJXaFEx56BsZLGz9ZBbg0wHs31kGzZ+mIc/gDKcJFyBTdRyXAo7MZYnEnFim1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GM3yCAiyAq0R8pKXYmqAmhyOqPw47CsMCQ3NVKIzIr8=;
 b=jInePGjF3xupdj0DsTN/mBWypuZq9a3nYJQyLX31QqJI740r9GwZa25fcnBZ6yqAAvOM4r9/2aPXewhqyJUftdDyWNh3AxZM2ORoB6NGYIZefKe+/DFpnry1Mi5xlkvQatvpHhaDpoEhXJk2cETAmFxr83tHgynVvI52anOdv9m7BVk6VYErgVfboGnWjrRRjapqrJnqLzluaQ4ocOfjCl3gpYGlghZcIgTE8dkeGBJE57YmjwxMA2BSgAlUxsjdEAhJ1yXWa1Gm32iwbvEFDF7UC6fRfbwIhrOP2p458ZG1x62GgpGmcFh2LIk1/4/Hokaqb/fg02HDh0iJuBwUHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GM3yCAiyAq0R8pKXYmqAmhyOqPw47CsMCQ3NVKIzIr8=;
 b=OplM0ryjsgQmdYKAwPknql4bSXtWyBuyMC/8vMPV4XojjSmyaXsS31d76X+O3ojAgC91PrVBG+remXHcNkfO2mGLSpHXQFRlQu/oCZPK1ywrj7C6mo72EUvxbRvM5w8HGb3viZRZ1Ui0plYJHOdo1S6Z6JXxse27dHv9cVd4X9w=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MN6PR04MB9681.namprd04.prod.outlook.com (2603:10b6:208:4f1::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.28; Sun, 20 Oct 2024 06:37:40 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8069.024; Sun, 20 Oct 2024
 06:37:40 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>, Peter Wang <peter.wang@mediatek.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>, Maya Erez
	<quic_merez@quicinc.com>, Asutosh Das <quic_asutoshd@quicinc.com>, Can Guo
	<quic_cang@quicinc.com>
Subject: RE: [PATCH 4/7] scsi: ufs: core: Fix ufshcd_exception_event_handler()
Thread-Topic: [PATCH 4/7] scsi: ufs: core: Fix
 ufshcd_exception_event_handler()
Thread-Index:
 AQHbIBAk173eioiIKUyIP1nJDoSWfLKMAlIggAC8UACAAAYE4IAAJRYAgAC4a0CAAZKJUA==
Date: Sun, 20 Oct 2024 06:37:40 +0000
Message-ID:
 <DM6PR04MB6575AF4B57906EB393664A92FC422@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-5-bvanassche@acm.org>
 <DM6PR04MB6575DD9E354A70A9EA97E439FC402@DM6PR04MB6575.namprd04.prod.outlook.com>
 <608f86d5-0f27-4c88-a2b2-6504348f2f18@acm.org>
 <DM6PR04MB6575010F498BC3F480EA198AFC402@DM6PR04MB6575.namprd04.prod.outlook.com>
 <793f958f-353e-453a-b2eb-288853a38dc2@acm.org>
 <DM6PR04MB6575C9A03D96A1D4DD75D8CBFC412@DM6PR04MB6575.namprd04.prod.outlook.com>
In-Reply-To:
 <DM6PR04MB6575C9A03D96A1D4DD75D8CBFC412@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|MN6PR04MB9681:EE_
x-ms-office365-filtering-correlation-id: c8adfc95-7c3c-4f70-a4ed-08dcf0d1b1d6
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bHl2UG10cUI0MXBVaE14VFJnekg3VWkwM0RjRlpUTzlxQ0Z0Q21FLzQwRCtR?=
 =?utf-8?B?ZFBzbDBoR3RuZXdRSUxCdWJYVHY0UGl6N3FhajVRTlFHelVxZXM4U0o2ZlJ0?=
 =?utf-8?B?dm1QL3FKd3J5MWtDbVpSY1lZU0pyeDJ5NnBobnB1L252TDk2RzJXM2dUQ3dK?=
 =?utf-8?B?VDBKV3VDakZYNEtXOUc2ZVBERVFiRy9RZFJPWENTY2V0cm5zdVU1cDdUU1RX?=
 =?utf-8?B?Uy9XRVdzNjl4aVVvVmlpOXY2eWxCbEcxNHJObDE0WHJoUTIvWEdSZmxFVzlC?=
 =?utf-8?B?Mi9vNTU3alVBdVo1b1M2b0I2SFVQYURzd1RFZExMRktpWXNnSXo5d1VFZFV6?=
 =?utf-8?B?cElBOGpRUEduZGdzc0FEQ0xKc3R1RFZSZGhncWVOYnlCeFAySktqLzYvU3ph?=
 =?utf-8?B?Vzc1YVJFUFBqL2RZZ2VDVjA0MkhnQk9HTjRKYkF3aWlPWUZCb2JPSVdkVlJX?=
 =?utf-8?B?SVVzaHRRaFg3QnVNcFhOWWxrWTlDRklUQUlVVU1CZjR3M1c2bGVtalFVWk9p?=
 =?utf-8?B?MXZFWjR3MmkyNlJqRlcrbkhUSHY4amhSOW83UytZYlVFM1pBbFdKSEVnMm43?=
 =?utf-8?B?bHpFOFYvb3ZWQmFxaEdqeFFJY0NBdFhkVm5wZGtLYXJVNjZFSlZnVTVqR1VD?=
 =?utf-8?B?Q0NoeXJzUFdNNHBrV3dIT3ZxTTBkTC9CRE5SbEdpR3hOcGhTVlZXV3BOQURE?=
 =?utf-8?B?aktJbUdmL0hSMVdYYXc0c1YvY0VkVWVMUko3TlFFeFlPR0srRnF0T1lGWFhy?=
 =?utf-8?B?MVYySDJSaVBVNVROckcvNzFPTlozS21iZXhQTUxwYU9BRE1vL2RFS0kyZDBO?=
 =?utf-8?B?KzdXSHZmWUxOcFJwbm1rdHJYRFlqbURDaVRWaXo3MyttNVpiSEtWaUVKNGR2?=
 =?utf-8?B?NUM3MDkrdjFCck5QcmZLUjFlUUl2cElLOWEyWDF0QllIVmVQZHhyRDY4WVQx?=
 =?utf-8?B?TG1xRm8zQkxWdVNya2ttWDlTS3AxWDd2TDRSY1pnT3hBQTVKaXI1bmtDMjlj?=
 =?utf-8?B?bjJmcThhZG00cHIxTkEwOWxtVWxCTHBDcktMdWdnNzE1VjZCT096OFR0ZDV5?=
 =?utf-8?B?TFc5SFZCaXhVL3hUMGNLNjhsY0wrTTIxZTA4SDBLK3RROE0yTnF1OXhDclR5?=
 =?utf-8?B?bVdKSFI0N3NtK2Z6U3VyTXFER2RZSjVRbWZ0TDRwVlJHRW5ENUZIK2x3SWxx?=
 =?utf-8?B?dG1HNTkwdk5UcVFsb3ZkMVNKY3hVa0cwbEdJYVJON2laeUtLV0xSa2tkcUs2?=
 =?utf-8?B?WGV3ZEZ1WFZLNEZRY1ZjYUFtd0JORllMYjY1RmRlenlxN1NJK1ZjL2M0QTdZ?=
 =?utf-8?B?STkvMU1YT0Y2RTlEOWFKSXk5d0Z1SXBQSWdQc0NqR0N4Y1pkQllJODJjRlVV?=
 =?utf-8?B?REh0VmdjK3ozVkhaZEhSOWlvdjVlSXB2MUU1YXJFVnEzOGVleEV0T3dWZTJB?=
 =?utf-8?B?dTVBTUVGVUVaSkdvZ252NWcxRzdiajZCV2thU0YzTTBCc3BmN1dRZkNuRnpT?=
 =?utf-8?B?U01yQzhsNmpVTHlJTlQyODROVVE2cUh5cGZPT0dnOE02QjJOWnIweWQzZDl5?=
 =?utf-8?B?bVUwYVdoSWFkZFU3NEZSQUdRd0c1S0EyV2JzV2Z0RmJSVWNqMEsyeWxRT0pS?=
 =?utf-8?B?MXJCbVVBOW9uUGVLY1JVSGdDMGZ5b3c0eWlBVys0Tm90SmV0S09XbG9mSHdO?=
 =?utf-8?B?N2FmZnJ3YjdCN0FGZmphYUlkbHBINHNWV2VEaXRaMy9wc3c3aHhkclR5TGk5?=
 =?utf-8?B?dEd3U0tzSE5icHRSeUtGTDF1NHh4V255OEd3Tm1tRG1vMjdmaVFYenhRUnRK?=
 =?utf-8?Q?zMI1UB/ZZFxhTmAj/YLe9YoLGfmeRi7SdOmkA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VmwwM1BFV3V4WWdaZkl3MDBaTVZzQzlSdWtYY1VBVy9LVnlrS3hjVWpZV1NW?=
 =?utf-8?B?cXRYMVRhM3kzbnNjMU5NMkVUNUxFU2NucU02TktpMFhDbnFjU3VzVmRGeklk?=
 =?utf-8?B?SHlKZTVQMmhZaWdpUndDeHAxNit0ckZMdm1UREZmVkxvQ0V3dm1qbnVLNFBa?=
 =?utf-8?B?VHYxTlhycGFwR1Q1WGRwb1VXT0dOd3JZUFBDcS9SbSs3TDZhQzV0TW5XZDEx?=
 =?utf-8?B?WjZFN3ljT0VOdTNYOEgyNHVVSktHK01uZTVPWGUwVmdScHh0b3dwYnVRNjhL?=
 =?utf-8?B?cXJuT3V3ZmF4Ujd3Tzc5YVFxVnJ4d2haY2QzNGhKUTliVXkyWGUyNVBNK201?=
 =?utf-8?B?KzBpblduWDVQZEo4WExPZzRrT2tJWU8vMlc5aUpib0g3QVh6SkZ3eDhMWWVM?=
 =?utf-8?B?dkpFSSswVGJFMG04MU5iQXNXTVlOUlNmZzFrL3BxK3FSNi9hUDN2dXdmeDVq?=
 =?utf-8?B?Y0Z4U1g1bjBFR1N3cm9qNE02WGxxTDRzY3ZjVHlCNXFDNjRXVnVJcE4yY2gz?=
 =?utf-8?B?N2RDNEJ5MmVON1lXSUIrRG1nL0U0elM5N3JjRmZJTnBoZHV0VFQ0T0xvU0NB?=
 =?utf-8?B?NFk5aFREU1pnVStrMjVmYWZwVVoyUVBsRUhLUllOQkI2bzFjbDkxNmRYS1FB?=
 =?utf-8?B?dXFueTdtQkdBZzU4dSt1V1BxSXh4TGlTY1NPYXN3TUV6RzQyS2JxeHNVekVo?=
 =?utf-8?B?Q09ZTHVoNnYydlRQbmpGeVpYS1VzSkhXRkFOeTBnREdWRTlvbDlpUkVDZGhO?=
 =?utf-8?B?RjBVcDhBVmFYaUNTWWdCaldqYTQvY0FmSklOWWpZSFQwZ2N3ZERndTBva3d3?=
 =?utf-8?B?QXhXMEMxaEZJWDZyaWpQNjlMN0tJMFFyVEN3Z0VNTEFFNEhGKzNTbzN3U1M5?=
 =?utf-8?B?QjU1czNLUlFqZVJpTUpRNmtlbzQyZ1hYcnhvVzgzRW9rSmdJT09oUW5ueEJa?=
 =?utf-8?B?WllPZTB2WkZmWWpVQUZ2NDhHYXpEUU1ReVY5aS9DbGVxT1c4UGR1c2wxZzho?=
 =?utf-8?B?NG5mOEl6Q0tDbnE4bnZBN2I1VEV4THMzeW9GSXBUQ0N4d29JdG82aGFMZFo4?=
 =?utf-8?B?Z1RRdmNibTBZaGZZTjIzaXkzUFVoUjlpVTVSa1pOenR0YnA2SUo4eDNMVzI3?=
 =?utf-8?B?NVNXTDlidDc1b2RoMTBGVlU1QnBodUZ0aFZjWnpwYjNkeXdBMUlnWW9rdnhT?=
 =?utf-8?B?NlRvMkV3Z1lvaDRBWFBRUkZpTVBRUEM3ZUFmUThFb0Ria0Y1YXlaczR3YnJP?=
 =?utf-8?B?d1R1cCtQdkZXZnFmVFlrMGZjNXZFWEkyN041UDlqYU9uYkJhREVjZ0YrVyt3?=
 =?utf-8?B?UUtQaVdLdjMyUmRUbng3dTNaVXpBZFBkZ0NHanFLRjBJT1FDY3haclNCQ0Zs?=
 =?utf-8?B?K2sraGFDeElDYlJQSTNFRE5PWXZkbXRhNXJsRk5heG5xNzk3azgybGRMUVI0?=
 =?utf-8?B?ZnNselZiYnRrcFJ5OVZHcUJ6elluQVJ2Z29YVDAxak5ZL012akhRalZOOWVP?=
 =?utf-8?B?MU9BZkExOU9Ka1JNK3QzY3FQeC9tTitiZEtodUFNM3JQck9mVFlFT1V5QnF0?=
 =?utf-8?B?T0E2VWxNT1V4Yi83QnVyazQvR2M0R2lULyt1NlNPbHlCSVF0S3JPcUFsWFpm?=
 =?utf-8?B?Y1hjbFhVTDNSeE5WOGNqUU1jWWx6OC92bStDYkx4K1FjL29uR25rcXNBemF0?=
 =?utf-8?B?c3YvazZpbjI2SGVNeUN5K01RT3RRTWQ2SEN3d0MrNVRES0ZkQnRmOXk0a2pB?=
 =?utf-8?B?bHV2QlBrVGljMENJaVZRQlpzLzZjOEpiSWVxMmlySWRHTXlOL2F0cEhPeFhh?=
 =?utf-8?B?dER2ZnliZlVCRGo5dEhDaEs2QTAycUxhM0ZXRkM4V2crY2paOVJWNGtZWmk5?=
 =?utf-8?B?Ulh4TFZnZkVCNWIrSWVOclI0VHFDL0wvdVU3Z1RKVXFBZ3Z1LzYrUEpqODhm?=
 =?utf-8?B?QUNsS3dYelZvdVhxNXhrRDA1MlpreFp6MzJ0VEtwY1B0NGxTcGNOTVpKME54?=
 =?utf-8?B?SmdNbkdPTVQ1SFRKOGtFNjRSMkhqYnhLZzFUaWdnSHpOb3R2MUFlVWlQT0hG?=
 =?utf-8?B?d2tuVjVha0ttb1puMjFUYjlxZ3JUaEt6SVdqdnNTTzdnRkhIamM0MGJFc1dK?=
 =?utf-8?Q?lawhC2qbZkVI9qow/ndFRJ8+A?=
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
	bl89GoimTiWwF8FfDwHuSSlNShVcVIQMAAYZ2toSZfIM96KCd05rSHrpPCLAcW+F392G8D1kakhJkgb1607XL382t5f0QWXPjG9e/on1WaXhJKN+oXSm3exooIUiEwtty0aX4R/FbKkx3r4yPVl1nES02UMnHWV0kN6vlkFkoNGn+U0AV59g/0AEBAtrRSdQnsR5VrjQDJa/EDlikUe9t4lBvjSV/O+6UfOs1zEcsb5RgVX5JJS9DTh+817e/8mxIWw29UUsiY9BeI5OeN6EeHjt0q+CVxQMTQ1Fl2/dsDWycND2pYtIVy699x/QjwQXCnuyvpUKc+YhEIWbzS7t0Ji9KKXpUnw+0y/7Gw+A1Vz/Y+EEb6sCxE4rNHZwjqmNZVIDffAQHesRjyc4aDCScI4uQJhAaC16cofTtsco2JKvGonwY5DAWEIA1E+vzeaKCmLVt5aEArVE1EFAiD1XmhRnI7NRPJcLxnyNBvye15pUnvoMJIRCFVkDthS05JZoMAwUneyhcX1yTb4JNIV/KpgKXa0qwAY4TqouA7TOoHJyxxGv9zOPNQsbL4zAOAOMEgQWcf6rrjbiLKEdW8AYzbS3PiiZBbIQwmEyPFYEIDKNmynLCHPAMIpYFIHdccR6
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8adfc95-7c3c-4f70-a4ed-08dcf0d1b1d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2024 06:37:40.1801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E1bNN70OTbdAoNy34PJq5fw3BSxq0NpQgRb9ggYM6v8jLLj++aV4elQtACVSRBFpbOz0XDqU4PrPr4cF8zLQKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR04MB9681

PiA+IHNjc2k6IHVmczogY29yZTogU2ltcGxpZnkgdWZzaGNkX2V4Y2VwdGlvbl9ldmVudF9oYW5k
bGVyKCkNCj4gPg0KPiA+IFRoZSB1ZnNoY2Rfc2NzaV9ibG9ja19yZXF1ZXN0cygpIGFuZCB1ZnNo
Y2Rfc2NzaV91bmJsb2NrX3JlcXVlc3RzKCkNCj4gPiBjYWxscyB3ZXJlIGludHJvZHVjZWQgaW4g
dWZzaGNkX2V4Y2VwdGlvbl9ldmVudF9oYW5kbGVyKCkgdG8gcHJldmVudA0KPiA+IHRoYXQgcXVl
cnlpbmcgdGhlIGV4Y2VwdGlvbiBldmVudCBpbmZvcm1hdGlvbiB3b3VsZCB0aW1lIG91dC4gQ29t
bWl0DQo+ID4gMTBmZTU4ODhhNDBlICgic2NzaTogdWZzOiBpbmNyZWFzZSB0aGUgc2NzaSBxdWVy
eSByZXNwb25zZSB0aW1lb3V0IikNCj4gPiBpbmNyZWFzZWQgdGhlIHRpbWVvdXQgZm9yIHF1ZXJ5
aW5nIGV4Y2VwdGlvbiBpbmZvcm1hdGlvbiBmcm9tIDMwIG1zIHRvDQo+ID4gMS41IHMgYW5kIHRo
ZXJlYnkgZWxpbWluYXRlZCB0aGUgcmlzayB0aGF0IGEgdGltZW91dCB3b3VsZCBoYXBwZW4uDQo+
ID4gSGVuY2UsIHRoZSBjYWxscyB0byBibG9jayBhbmQgdW5ibG9jayBTQ1NJIHJlcXVlc3RzIGFy
ZSBzdXBlcmZsdW91cy4NCj4gPiBSZW1vdmUgdGhlc2UgY2FsbHMuDQo+ID4NCj4gPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNk
LmMNCj4gPiBpbmRleA0KPiA+IDc2ODg0ZGY1ODBjMy4uMmZkZTFiMGE2MDg2IDEwMDY0NA0KPiA+
IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiArKysgYi9kcml2ZXJzL3Vmcy9j
b3JlL3Vmc2hjZC5jDQo+ID4gQEAgLTYxOTUsMTIgKzYxOTUsMTEgQEAgc3RhdGljIHZvaWQNCj4g
PiB1ZnNoY2RfZXhjZXB0aW9uX2V2ZW50X2hhbmRsZXIoc3RydWN0IHdvcmtfc3RydWN0ICp3b3Jr
KQ0KPiA+ICAgICAgICAgdTMyIHN0YXR1cyA9IDA7DQo+ID4gICAgICAgICBoYmEgPSBjb250YWlu
ZXJfb2Yod29yaywgc3RydWN0IHVmc19oYmEsIGVlaF93b3JrKTsNCj4gPg0KPiA+IC0gICAgICAg
dWZzaGNkX3Njc2lfYmxvY2tfcmVxdWVzdHMoaGJhKTsNCj4gPiAgICAgICAgIGVyciA9IHVmc2hj
ZF9nZXRfZWVfc3RhdHVzKGhiYSwgJnN0YXR1cyk7DQo+ID4gICAgICAgICBpZiAoZXJyKSB7DQo+
ID4gICAgICAgICAgICAgICAgIGRldl9lcnIoaGJhLT5kZXYsICIlczogZmFpbGVkIHRvIGdldCBl
eGNlcHRpb24gc3RhdHVzICVkXG4iLA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgX19mdW5jX18sIGVycik7DQo+ID4gLSAgICAgICAgICAgICAgIGdvdG8gb3V0Ow0KPiA+ICsg
ICAgICAgICAgICAgICByZXR1cm47DQo+ID4gICAgICAgICB9DQo+ID4NCj4gPiAgICAgICAgIHRy
YWNlX3Vmc2hjZF9leGNlcHRpb25fZXZlbnQoZGV2X25hbWUoaGJhLT5kZXYpLCBzdGF0dXMpOyBA
QCAtDQo+ID4gNjIxMiw4ICs2MjExLDYgQEAgc3RhdGljIHZvaWQgdWZzaGNkX2V4Y2VwdGlvbl9l
dmVudF9oYW5kbGVyKHN0cnVjdA0KPiA+IHdvcmtfc3RydWN0ICp3b3JrKQ0KPiA+ICAgICAgICAg
ICAgICAgICB1ZnNoY2RfdGVtcF9leGNlcHRpb25fZXZlbnRfaGFuZGxlcihoYmEsIHN0YXR1cyk7
DQo+ID4NCj4gPiAgICAgICAgIHVmc19kZWJ1Z2ZzX2V4Y2VwdGlvbl9ldmVudChoYmEsIHN0YXR1
cyk7DQo+ID4gLW91dDoNCj4gPiAtICAgICAgIHVmc2hjZF9zY3NpX3VuYmxvY2tfcmVxdWVzdHMo
aGJhKTsNCj4gPiAgIH0NCj4gPg0KPiA+ICAgLyogQ29tcGxldGUgcmVxdWVzdHMgdGhhdCBoYXZl
IGRvb3ItYmVsbCBjbGVhcmVkICovDQpUZXN0ZWQtYnk6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1h
bkB3ZGMuY29tPg0K
