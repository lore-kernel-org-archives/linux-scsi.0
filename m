Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF3345BFF
	for <linux-scsi@vger.kernel.org>; Fri, 22 Mar 2024 12:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711110954; cv=fail; b=OSjXdue6NwBoT4/J/yii1+3sodHp4T5OHFETW9My3iE+eNx2T+6wT5ZO4ppbTix566mjjjER7HX4p7/rAr4fuy/Xq1YgUzyDzSWmNPo7xgeH0tznVcTYFlkLocKmuN5jP8dmzEA/gIbpf7mWG+5Fo8Wh+uiRDyZkx4e37+HTJRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711110954; c=relaxed/simple;
	bh=E//5u36zu4/GhApfaT6Lu5s5E89QCrOVfUL/ybk1lMI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hs0YtNJrEcmCKU95lNotTsJKxL4eWSvRr+/zJsC1CJqOdqypp8aknJ1NbwboCPTJUac+hKb4susUulxyokTOaZO2Iwtzt85WRo4mLPu3zRZB802Mu3w+OTLSi30QQpm8VZbiENaVi6zqov+lUS6QsvM8GdQENLA14AdF8JLmX1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=i1cplIFS; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=sb4gVaeU; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="i1cplIFS";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="sb4gVaeU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1711110952; x=1742646952;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=E//5u36zu4/GhApfaT6Lu5s5E89QCrOVfUL/ybk1lMI=;
  b=i1cplIFShL4r9VB99/ujdnotA1sxZEWijEGwpam5n+cxF2EJMJMpUdpq
   lkqtpW4cqOQpS8qLuKOoQOwwwGF4g72gEZgDYz6BLeoivI7ua97j9Tnjz
   K9/oj53+rnp1DqE2f0319nvu17FTCJwgAYmtRycy1IW6JHiC9BLBQBBoN
   mEPsMtLebF8pX07P8pKvS8hIsro4ZRXTucZGI+uwOzVKBIHdkyOPGwzIf
   v3eX+QXg1FCfdGiJPftHl+nnbFFTqhlnWmNCXBvFInKHdzp7ThhlJR+8F
   URlcHycr0kbCb4O97SDireSsftpPh8fZX/jWjsfJjUSXH2K+PYl0jZD5u
   A==;
X-CSE-ConnectionGUID: nhB+zL4BQPeeNpyC0hz9xQ==
X-CSE-MsgGUID: op0chVijTxKXw98I1CKYaw==
X-IronPort-AV: E=Sophos;i="6.07,146,1708358400"; 
   d="scan'208";a="12871766"
Received: from mail-eastus2azlp17012016.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([40.93.12.16])
  by ob1.hgst.iphmx.com with ESMTP; 22 Mar 2024 20:35:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Duwc/3mIVos/pG6U8+srddr1rzPmjH1GamdwNT863pvNy9OM2McnsD7vlyb/0vejCBpWiZmstx4xZN4Z159GAPueAvbAew/4HvHDzNgWvrGwE5qiOURoZ3uvC7vCX2tZXr+bWMTHGtfby4YAxQ3B3zlZfSIh+ctPmQOsnvRMyoXDWw3+S/kM0kXFfO0Hdv0dhq21I0QVtRB9KKVupYV3KR0a+C0mdYwG9p53DEVYlOkSnVc/xyu3A2RTG0HAI6TCZpDS6mpV8WIkzuOAp2+C98ejA1demP1EP78PI5h+wlt2VdzOH7cJ6yD0MeIbYvnwK/d24OPb7KhePS9upgTNPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E//5u36zu4/GhApfaT6Lu5s5E89QCrOVfUL/ybk1lMI=;
 b=ixkUZD2WeE+v4xdZkaf/f9DQiFexY/atZv6tCSGjUPBdOaiWgwBCUgXmO66fy6LnVKapDaWjV+cifFmyvQrmfA0SO0PvSoDoUUu3xkpx15d/RWqGTXVv5CCNDjgIGKK9K6HtJm7Esk+ubybke6I193t1MdTRkl3Dac40UDwUlVn+dF5p293yhacMce+m5WAR4JRcbUV3PhWSRmVVNeAT4+HazG5TIsnQ+6a+2xfkH7ULQWE2UBJ/fP2hIXDgzyHjmy2wlOT3AVqCfwWmZWPgqm+oTl2UuQGPYZY/AiLb00CZntz8lrtpqepYtn+lB+tvvXVcJbRD+cr9X7HHflojkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E//5u36zu4/GhApfaT6Lu5s5E89QCrOVfUL/ybk1lMI=;
 b=sb4gVaeUqvVF4g5tg6B1M5hy12Za8aui0Rsj9TJAG1MLRyAFgTOntoUGiaUnFwsYQH/1ktAa1aH0yKchFowlfXItT8b0P0+Ww0jHM/L0NHVcBaeQHjUr8SJ7MJ1kUH04M0YvSumYB2T/qUix0+DmW1kPgHAVXtNCzchWG9AJq5A=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 PH7PR04MB8556.namprd04.prod.outlook.com (2603:10b6:510:2b7::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.37; Fri, 22 Mar 2024 12:35:43 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::c75d:c682:da15:14f]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::c75d:c682:da15:14f%2]) with mapi id 15.20.7409.023; Fri, 22 Mar 2024
 12:35:43 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
CC: "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kashyap Desai
	<kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mpi3mr: Avoid memcpy field-spanning write WARNING
Thread-Topic: [PATCH] scsi: mpi3mr: Avoid memcpy field-spanning write WARNING
Thread-Index: AQHacEescGLY6pTu1U2/BfjuNYxVirFAJMwAgAOljAA=
Date: Fri, 22 Mar 2024 12:35:43 +0000
Message-ID: <nwy7la2b72u4yw6pln4kgdomvsu4gisyarwf77cwoxai4bhtk5@xw7vjoq7saln>
References: <20240307042645.2827201-1-shinichiro.kawasaki@wdc.com>
 <CAFdVvOzU0L6OERfnVqGE0yY1HUUMOXrZ=60RPcCx54s6H5mrVg@mail.gmail.com>
In-Reply-To:
 <CAFdVvOzU0L6OERfnVqGE0yY1HUUMOXrZ=60RPcCx54s6H5mrVg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|PH7PR04MB8556:EE_
x-ms-office365-filtering-correlation-id: c9fcca8b-4621-43c4-2e59-08dc4a6c9725
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 4uRpRD+W2My12n8Io1UpZz/gOJSYPLuftBEHQYUol/1oap1TTDAf35V4OdUr+c7nv3MnV0dJ22YTOvqemlqKqkf3iJ4bC/YH12xJxnnWH/+eB7tsw1vFyXlpo9LUEJ+9l2zqUUBR4lVjDh24AmKV6cnGI0P2+pufzIvFTbI65ox1VJWVfIE3GfTBNmPZggqe3G12ueUysEsgedKbZeDIaUKbuZEswN8fLdIzpued374uhHvy3d27/3Pq55lmjyst9cSV7MJ+bwedEa0juhl93lar74iYKl96lMQFuHu2+NFKPUsI5WaiZdgIAxTXZ0M1OM+Jcu3/e7lGBTMpmGX3tW/Q3P4tYml/AK/PCJex/NuhM0MzjudDczn26iTRMAJC2fEbtBKglw7kwPM8dC9G08a7ma7x6R0bhgA1xwVrC0opIDw3nI+ImyiJiEYkndjM8f3sDP7vuVtp4ABIMMoRpkjS44/SQW1emryY0AwkrYI22VW+kxZa2MTqX4OVyzqyxwD0C+ET4HdZGlDdydlvl3ywAJ+6UnuOCbPktE+8bkw5r7Ep3FkXXESWtaKv7YoGpDa3hyXFiFTfOB5ckGbQy4xeLXqQwvluQpOnHC7hxV7YMJzow/XuAQR4WAM3jFRr64gAohLulEvVZlDCTXNZHVMQM92tELD5f20wAHfYiUShPXNTveSTbG+uKeExKeNxp4GS7rUiwvuW9TRECaIzBf51OY7d/b3pGzW6x97ZJp4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bExCcUl4VFRTZUo1SHdkSzVXYzhzNUdNV1J1WkQwUi9zZ3RMUmlZTGY4QkNi?=
 =?utf-8?B?b0tEanAvYmcyYUhUZ0svNUpnYXBJTUdmc3B0dDREUU1rd054TExLbWxtT1A0?=
 =?utf-8?B?UUQ4bER6bTQxNVFiNEVHMW9MK3NMNXkxTnBnVWVYdE1lMENoaG40SVYwMm42?=
 =?utf-8?B?UklSczRubFY0WDJ0SGhrK0ZpRWFSNkRwUllvTU1BWk5BTlQ1S0dlM2JVb3N3?=
 =?utf-8?B?WHV2WEtEUnp5OSs1d0NKUXlSUDYzcmhCSmR1aEN5bDdLeXBvVUhNc3FJRXpG?=
 =?utf-8?B?TGtta0V2K1FzK3NpT0VTMy9weUJ6ZFdzN1k0RWdObUxZNEx0R2pyUkp6UFdw?=
 =?utf-8?B?OWhqTTFEbWRSOGpPTk1nSnlWRVBtVU4yOGxadnpYSmJNTkxhcmdQTE1tREpS?=
 =?utf-8?B?SHdhOXFrcGJYNjhFTU9WSnhybi9kMG9DUTRYbnVuVXNCRXNOTnB3WDlxYjY5?=
 =?utf-8?B?bDFObDZuMmMzZlJzakxlMER3WERFV3hHNjAxTHJnVlBaK1hhUm1ETTNGN21B?=
 =?utf-8?B?VHBKaVVzclVjTzdnK29vVkl5RnBnblJ3NGh1enZGK0NVQ3I2OTkxQldiSlF4?=
 =?utf-8?B?OElGZVlya3lpa0h4T25adERxbXlyelJWUFBYQTByaW0zWVBTK0RYRDYvWkhq?=
 =?utf-8?B?YjVBU0V3TnhQK3J6TlJ5SGluelFQZVZYTnhPdHNqRFZ4VWdRcU5HZCtKYXlJ?=
 =?utf-8?B?VTRsZkRMVXJJdGR5TW1rRlAyeHJpaTBsV0FCNndFVVdDamRTNnptdDJEZFEv?=
 =?utf-8?B?WFFPUmVFL3BRc0pEZkUzb1RiYnJSNUs2TmR3L2UxYXFPelhuUmNiQmtWLzVs?=
 =?utf-8?B?QmJyRDk1NU5yWWw5RzJWVWhJVElyZjh5ZFZjeWh1L3pzZnNxRWhDaWI0Sy9N?=
 =?utf-8?B?S01QSGZkb3pSWElkc2ozNWVZTEtMRmhGVjkzRE9lQlgwZmVPNmg4T1FPcFdu?=
 =?utf-8?B?ekkzRWpKaWRaNlUrcDZFSGNNQUtTbERBcjdGVU5tZnliVmIreVlDQWVJajQw?=
 =?utf-8?B?S0hWaVJzUm12Z1djN0xiREVkU3RvZW5PWGpOS0NOM0dBdjRYZ1Q5dk5CWW4x?=
 =?utf-8?B?eTNaMUk4MzdLY2YyRlMzWm9jeGx1bE9VRmlURHFsZ0x6Z1hZNk0vS3VOdDA5?=
 =?utf-8?B?UC9NU1RzV25aZFg5UFVZY1VKL1RyQjBHYjBQL2I4WjIrTnFVbWdWM2ZPQUJz?=
 =?utf-8?B?NEdaOTFxcDNYbWlzQjB5TytRU21zbUxSbHpBTmp0dStUckY5QUJIZnBmaXBp?=
 =?utf-8?B?MkpQZThhelhhLzNObDFmdk9sMEY1SzhOajFvOEhJeEJuaXJzWUpVWTd2WUdw?=
 =?utf-8?B?Q0N6V0huekw3TVR3RUxwSi8zOGxXMWFMWDdHRG5FdFBsOGhidHRjOG9NdG9L?=
 =?utf-8?B?WElQeThaUHB0OTlaT1NhbmJnL1c3VVhVN2RpUXVLc0NLcjk0S0p6eU0wNkpE?=
 =?utf-8?B?WkUyNlduWVFvVHIxK0k2dXhzTlpSUERsUm1zLzBiSlZNL0I0U1pYYU1SdmdQ?=
 =?utf-8?B?cUNEc0hjRmpRRVM2S08zcVB4WnhnTVl6ZFRXSm03OFFqUENOMjRpcDBWTjlM?=
 =?utf-8?B?L0lxOWlMeVlqOUNFMmQzRFhzMjhNd2xnU3o2a00zQWpIVWdqYy9RZlI0Ym4v?=
 =?utf-8?B?NEU3Q3lQZi9WTVF6QnRGY2l2bm5ldTVXbXRmU0RITEhUR1V0UUxBM2xDenF2?=
 =?utf-8?B?T0QwRVVMckZGMEt0WkpTRkYzbGsvSU9MRG9WWXZWbWg0RDFBTi84ZEdMT25G?=
 =?utf-8?B?aXJsK1VaYW1FN1BGeXJzNWpLOG1kbkoxZDZiaHMwaDNPVkFzMStYbWpOUUQ2?=
 =?utf-8?B?bFduZlc2aTVLU24yYjBuY2xpbjc3QnpVRFhGbWhvNExNWTZqUkh0cVRwWTdL?=
 =?utf-8?B?a1paNlRCcmt3ckVXcFJENlgwVXZxTzNxc2JFNFdWUlNYYndFK1JKU3F0eUN6?=
 =?utf-8?B?MjlzSDhYSWVZQU9odi96K0x0ellVbWZQS0RYQ2ZXTmRSUDNvalF3czBHb1ZC?=
 =?utf-8?B?a3g5SERQNzllRmxObytnTGpidmFJb0Fic1BHSm5aNEF1bXg2Y3hXZnNUWjZp?=
 =?utf-8?B?WDJVZjRpcDV5T21uMElRbHFXMlZxZUZydzFDQXN0VW9CRHFhYzNrU2FWaUhY?=
 =?utf-8?B?ajBNTDl5MmFzSEdOVjcrOFJlL2pPNFJhNTN2YlExckl3RUd6YVpHYmJyN0ZH?=
 =?utf-8?Q?jNgkmQnhM3yb9fnqUNlNtRw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1719641F0D181E49999FEF3DDA6CB3E1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jqP0550ZtDjJpjR6+AZx9XYUo+l2Cx6lUNbXoH8xpEd17Gp60vjA/xC94eGm6MbAoobe30YCEExq4SwQ5TH7oBl+j1sV8tldjSyC3qikfRubAJowfc/g7AIAu8PoO0BsOTzrQy81SRpkyryp1Bi/nr4TIEH6cF3PYE4G5fnIGy/1Es1yAaJx2+tgMm5QQN4YeoDGR5NhkR67pEhhL2rcpRtj7iiEA5lc4DZ5WfUvtTNPR0401YTYXU0k0epueFnu9pazYJS3PxyRDCVwK8qEWCQePeQKX+77zrNVUDo0Rlhn6YMbGQWGc7ieTc6MHtlWqvnpL+4P/BjzrZYd7i7OJ78wTRWM8FYHZyUFLYcVTPNNqBVoyNDG976jjcudSuYWEcdIzQUt4NzVcFvWHXPx7mA3sXpLt+IQBBXWjs8ZNIu0cO+PHLfOwopkqoaTHHf54XWieJdnP5TxiDeAsFUO67bePMDRZ2dM6uVbrSrSK052ODRfq06VMgdttMlrNy9y9ESCE4zBuZ5WjE95x29N+b0L576KBdpJav7h+RjgU+fdl9QC5FQYVSKjboPk7Jv3dth0DGkYnZPi+bgfWg5qKjtJo4WZC4xVFSLIMr+w6De6jtZHTDzelOWKy/5DhgJO
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9fcca8b-4621-43c4-2e59-08dc4a6c9725
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2024 12:35:43.2422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bjbpk2oASM2G10BnHheqqGAsGtbQZhv9NcuyGXNLOfO/0U1Ett5eLrfV8EggpSpetLRCqifsI5SvnRGl5glSxl6rnJQP3IsBSZZa0YoCP8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8556

T24gTWFyIDE5LCAyMDI0IC8gMjI6NTQsIFNhdGh5YSBQcmFrYXNoIFZlZXJpY2hldHR5IHdyb3Rl
Og0KPiBPbiBXZWQsIE1hciA2LCAyMDI0IGF0IDk6MjbigK9QTSBTaGluJ2ljaGlybyBLYXdhc2Fr
aQ0KLi4uDQo+IFRoZSBjaGFuZ2VzIGxvb2sgZ29vZCwgaG93ZXZlciwgVGhlIHVhcGkgc3RydWN0
dXJlcyBhcmUgbm90IHVzZWQgYnkNCj4gYW55IGJyb2FkY29tIGFwcGxpY2F0aW9ucyBzbyBmYXIg
YW5kIHRob3NlIHVzZSB0aGVpciBpbnRlcm5hbCBmaWxlcw0KPiBhbmQgQUZBSUsgdGhlcmUgaXMg
bm8gdGhpcmQgcGFydHkgZGV2ZWxvcGVkIGFwcGxpY2F0aW9ucyB1c2luZyB1YXBpDQo+IGhlYWRl
cnMsIHNvIGNhbiB3ZSBkZWNsYXJlIHRoaXMgYXMgYSBmbGV4aWJsZSBsZW5ndGggYXJyYXkgdG8g
YmUgbW9yZQ0KPiBjbGVhbj8NCg0KVGhhbmtzIGZvciB0aGUgY29tbWVudC4gSSB3YXMgbm90IHN1
cmUgaWYgdGhlIHN0cnVjdHVyZSBpcyB1c2VkIGJ5IGFwcGxpY2F0aW9ucw0Kb3Igbm90LiBTaW5j
ZSB0aGV5IGFyZSBub3QgdXNlZCwgSSBhZ3JlZSB0aGF0IHRoYXQgbW9kaWZpY2F0aW9uIGluIHRo
ZSBVQVBJDQpoZWFkZXIgd2lsbCBiZSBjbGVhbmVyLiBXaWxsIHNlbmQgdjIuDQo=
