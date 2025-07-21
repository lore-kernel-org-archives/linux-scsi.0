Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFB12D3A8A
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 11:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753098161; cv=fail; b=S9XlrX0bTa6kNK1OuX9J/B9n0VEqfJZ067YrK/j3vuPcnBqBNeBHwb1Vu2rnqpbtYokH3MnW8eUdWuM9SiTfAHKIoiVGWEEE81eTTAJo6GN7BFyKwuNyihtw7U4p+QOMUikCaAyG2wa+PumY8VSSMwvYYt9hxMN+5x1/U7mmYXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753098161; c=relaxed/simple;
	bh=YSIaclDw6ex+bUr1GciWGaHEPBjqm/FODHwSWwb5SWk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WxxLFK/YHK8GNi6LfIyAPTGG4GlviDVsdK7M2wY24Qn+sUUPq1bhIgQpDdrQR0DpKaW43PBy/pHx7umuhkzbvZax6/69uzaGzfgI0rfg8sbelHNnNiq/vkusmQHtBtxtD/YpAGL2PfsxzWKArZMxq9jTsUd2q8fPedoIlhEZ65Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=K+ws8ehY; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=IZtD6pms; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="K+ws8ehY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="IZtD6pms"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1753098160; x=1784634160;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YSIaclDw6ex+bUr1GciWGaHEPBjqm/FODHwSWwb5SWk=;
  b=K+ws8ehYySGkLMEXmRjvtU/ottqvZ5RQQogFlc5KKcyYJcenaVXuaRAh
   9KIyouyBEywFya9XVknZZ9i0klVFK3mGjvVwCYp1NmSOdT2asF9SJecn7
   Dt9IxWwyym7CHCF7KUq7f4rIKptZMG97sY27xjr4z51i2vgiuMNrmEZxb
   QSFoh2ToyPbUHoNr5iZJFhRxZTIIbzt8sZw6KOi/94YzxATUEb5WXEctc
   xEdhEjOmqsgE3mJNNhDwc3+G1484j5e5aGjkPwDyms2YqbTEkjCcnNgBd
   I/Ap1A8NtCuHjoXsd29XHGcdX6BXXhve2LEczBD+rlcASijY/fk3kGEuR
   Q==;
X-CSE-ConnectionGUID: hud2k71ORBS+XV0d1vE6QA==
X-CSE-MsgGUID: iOghUbxzQ1ON65tYpVeE5g==
X-IronPort-AV: E=Sophos;i="6.16,328,1744041600"; 
   d="scan'208";a="94537232"
Received: from mail-bn8nam04on2049.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([40.107.100.49])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2025 19:42:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MwLXsyVaeUyrPE/83z3idEPMTB0vNgp4fz0sKjJACt+mx8LPoOHY6JYeQtVVWlzOllR79WQqjVuuUazn7s5C3STmInuhIKcTRgY3wPB8raUnNcCPtSjH9vDTwd/1q6ma1KTmfnubRNqQkn3CEpmhW107e5ZnVwhGWXGTf1An2uxtYOWv6aWCkqIor8T8vppvpraL2n/IikO7dE4AL1XxwkR9TfRKoTC3t97oCGlUIgWv75JQiuq3RmL8zW/MQN+/R8VCx8YI1QmnyOGa9b/jsYAUoEW4BPfwH9f4a57gHzg1WegsiypxjbZ9th6L/kyiDEOKR3fh+EtJ+R5jQ1+cTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YSIaclDw6ex+bUr1GciWGaHEPBjqm/FODHwSWwb5SWk=;
 b=OL4cI9cjK2UsnSv2LPKb9aEQ8GFL2/9w5kIWkP24lchB29tOdWeHaT/LClL06XFiSpYX6uOqz6gbnygnvfJYgTDTpUb6bpNYLipVhGMnIV5If14kBr3SJDzMgVnNcvCRFfAGSx5HWX4EgGOrF67/Oeumrx/gOz+WcnztHyw9k2qrtUFuj8LTkgCZoJiFD419zBZUiLEKgW/c5okfhC0hiVLM2Bk53hBTF2pW8g7sH4/Gk4ru1eTZt20x0K83RMeKYgbvKWDauBU3cF5yGcmgp1q4MLjvCcECi7WSsfiPzzIBnt4R5+uTpZKFs5l/QGLV6v9JaTMeqBjERVvrjy2u1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSIaclDw6ex+bUr1GciWGaHEPBjqm/FODHwSWwb5SWk=;
 b=IZtD6pmsnPH8Pr+DQ6rce/B0oGzdGZXAkFOtmtYFvagQB6I4xCYoj0inTnt2wIP06tMBD6r23UVbKj2wgKpd1J2VheAnAtAUL6Mu6bh8exq13DKrj1QvhnrlPzalGcdIuUofeqUQtux8MzNu020QJIfbowBtVOzZbxBfCKtj+gc=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CH2PR04MB6632.namprd04.prod.outlook.com (2603:10b6:610:9e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 11:42:30 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%4]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 11:42:30 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v1] mpt3sas: Set DMA_BIDIRECTIONAL for additional SCSI
 commands
Thread-Topic: [PATCH v1] mpt3sas: Set DMA_BIDIRECTIONAL for additional SCSI
 commands
Thread-Index: AQHb+jAwdnjUHr/RDUKDj60EJ/hUqbQ8dLMA
Date: Mon, 21 Jul 2025 11:42:30 +0000
Message-ID: <c1c892bd-adb9-4125-a3e9-d2dd268cee91@wdc.com>
References: <20250721110546.100355-1-ranjan.kumar@broadcom.com>
In-Reply-To: <20250721110546.100355-1-ranjan.kumar@broadcom.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|CH2PR04MB6632:EE_
x-ms-office365-filtering-correlation-id: 1214032a-ecf1-4309-6400-08ddc84bacd3
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|19092799006|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SHp2ZndselBxdk1uZzkwbEJjOEdoM1hWSVFSaFJZV2o5b0Y2L3RYTnZ4ZW9y?=
 =?utf-8?B?SFV1WG9STllHUlNjeElBNVRWU2szdnpYeURVQUtXMjRkNUJSOHhVMU55TVYx?=
 =?utf-8?B?cU1OQjVCK2w0dXEyUVFtR0p0N0tjU1h3TW1kbUVrM0RONmdaZWxvOUdFc0hI?=
 =?utf-8?B?RmVZTkg1cTU4TzZPSHQxTmliSUYrUXBPNk9JUVJlZk9CZVRtYUUyeHpJQmgx?=
 =?utf-8?B?UElCQmMyR3JhZVdmU3FDbEJYaUpscUY1RWJiamJnT1hVcmw5aTRLeHFBazV5?=
 =?utf-8?B?bWNicnQ5VzlQaXB2WElTcm0xdHBLSlNaVVJTMHJZWmVnVGRxcW00ZmwvTDVY?=
 =?utf-8?B?SCt3elBSSTQ5WGJFVjQ2amJxUlBtaVlYM0JkanpMUHI5b2hJMkw4VVhuY2dT?=
 =?utf-8?B?OVZtVjg1K3ptU0RPVWZrd3FENGFnb1R5QzVsZi8wWS9FYU9vUmNIYnZBYW54?=
 =?utf-8?B?VHlBMUVHWHlKTG9sdnJyYU1vcGw5YlZ6blYxVG9hZmlCME00RTAxbEVKaWtu?=
 =?utf-8?B?Y0p6UDN6R1JFR0tFTmNvRkVHM1BhYnRaZEwwYTVLQmRJQkh2UnN6dDEzcjJm?=
 =?utf-8?B?bnpwMkdycjBzdnhPL3BzQ3Y1S1RxdXo1ZjR3N2RCZXd4T2drSVJZUElsL3Zi?=
 =?utf-8?B?aVVKVHN5MUtLeVBwVldES01BWnNjeGZLYnRlbmxtYVdkdm1tMXBSVDV1SGFV?=
 =?utf-8?B?R0RUbVZ4S1hjb2FSbWpWSmIrU2Z2eFpKMXlKTUtVMTQwSWErRUlTTnQzckZn?=
 =?utf-8?B?WHRFVkFOVU0xMndFMHJJVDY4OHNSMWFnTTFJZEdyM25GYWZka3FuNHZRWXFE?=
 =?utf-8?B?TGFKaTVTMUhFYXBnVnZtZDMwSEhCcWhBZE8xazBKRzhGbTdnZS9tLzB3SW4r?=
 =?utf-8?B?UldXeWFuQkRrWHY2ckNXVTlQcnFSSXNqRXdEK3Jnd1Qrb3poTnNKSXlTMG80?=
 =?utf-8?B?NGJZcDB1WVFKOEJEY2dQNktTd1I2Uzc0VFA2N3lPTTdDNlpCbWdZMHdYdkV3?=
 =?utf-8?B?amV0TnRLc2RIZXJ1UEc1djNGREdQOU5PazV1Ny83Wk9iOVZTeEx1VE92bGV2?=
 =?utf-8?B?V3ZMQ3l5ZzRnZzN5emhJZ05QemowQURBeUF4U3F0bmo1bTRaaFZsTDBvZEgy?=
 =?utf-8?B?Qm9lUTJWTDBQSXBYODZHUkNZNXROMkp0WGFvamJnL2s0UTRYZXdMejN2VmZS?=
 =?utf-8?B?a3owSnp3UnY2MmRzN2JkSFJTZnhQQWdsMWl3c0lyVHBVYlBCalNlaWF2M0k5?=
 =?utf-8?B?bFZESHU3NW9Mc2RLOXVRQTRybHZwSXdxL1dNZ0diZG94ODRpN0trTVRqZlNT?=
 =?utf-8?B?UEdzV3l6YjB6S3U1UENjUklvdmVrTkdDdklpTklGdk1CTThacVhmS2dYSnNs?=
 =?utf-8?B?bVNnV0VRTmtMS2txUVNOekNHU1JKNEIwWWFHb3BkaDcwYnhpMHQ0YW9NZmtZ?=
 =?utf-8?B?alZkYWl3VnJLeE1QdG03bGN5dUVrTDllemNjclFhUGlRaWxaSGFCZjFlNHkx?=
 =?utf-8?B?alV6VDVkUmRpMGdQZjNrZFVLTDRVY1YwRlk2ZnQvSzhHN0YxWW1nKzBIU3Y2?=
 =?utf-8?B?M0lTQ0ljVlZnYWc0b0lCZldQdzNpUjdObzVzcmdkcEphQTZ6UWttRXM1ZUd3?=
 =?utf-8?B?RlQ3YThyb0pMM2JuOTVWNGlra2tWT0xCTXdzWVJON3Job3p1TGdRVUVuMnZS?=
 =?utf-8?B?a0VKaFYyNjhNQWxlS3dIWHlLbjJ6Rmw2UEt2VjV1U2Rzd3E1SSsxNDRTWjls?=
 =?utf-8?B?ZGl0R3FqMWxHZnJSbGJBTStlMFRLenhKQnlVcTlzREVYelNFVGVLSEltZlBY?=
 =?utf-8?B?N29hTTluNFBIaWs1U2IvaDZqVjRpOGJzcjlJSzM2NkpQb2dRdnZnWDZudGYz?=
 =?utf-8?B?NTJ0Ukx4L21LbXNSYWZaSE92M3plb00xWEVqQmYzZ1RSamo5UmdCczJyWDhj?=
 =?utf-8?B?RmRKQ3MyUXI0OU4rVkhKcThRVURoemF5WTR6UXVXSFNpakdwQW1nSUJqRmsr?=
 =?utf-8?B?c1MvZVgrQjl3PT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?d3hxZlVxOTJwZU02aFZLYnFLdVVVbUVWNnY4UXZoVmpwck1DeFg2Z0F2UTRP?=
 =?utf-8?B?dGhoSFlSK2MxbFpMQ283dzZPVHkxQ3pRUEMvU0FnT2tPUW5HTzJjaEFhQzUv?=
 =?utf-8?B?OFVVNUZBYkFjdTExbmlXTENNK2l4Mko5cHdPVktoQkVaNTFlblBmNzJjaGxQ?=
 =?utf-8?B?bmZCcEdQSEJVaG9lVGx5ZGhSbUloaW53Q1hqdlVDZERHWFpwclREdFZycFBP?=
 =?utf-8?B?VmFSMjJ4aVE3N1VPbXFUc0Z0d2dvZzRvSzFDUmtKbjIrOVNOTk1FMjROVnVY?=
 =?utf-8?B?ZkhnNTRTc2Fzb05WcndxQUJrRnlmNXZGTEZ0OG1za1VHekFnbXpvdWV4L3ds?=
 =?utf-8?B?T094cWc5SnZ5UE5TbHQyZ2puTjAxNmJubTYrNnZrVEtPMHAybmxXOHVkM2Zo?=
 =?utf-8?B?ODN4aFBtaWVCVW5jNklEOFZnQ3pQK3dsRUpRMERQV2RtSVZnYWMwa3IwSVpz?=
 =?utf-8?B?VWxiSGFXSDkvVG9DWjBubDlmL2dDSkFmcndRVjRRYnRDWkkwT3lOREpqbDNt?=
 =?utf-8?B?OTNKUVJxWTlaY0dFd1JSR09ITzIvVnJzVDhKQTNmY0VBOTU0WHVkblMvRHlO?=
 =?utf-8?B?dTZaeUFCNW9CWWxvOWhqaTZqdHhOcTEwNThmMitTZENnU1E0aVRKN1l0MEFV?=
 =?utf-8?B?a0dYaGlTZnhFQ25VSVBmUE0wSms5UFJCd0Mzczg0Y1JlU0FHL1oxMHRPQm41?=
 =?utf-8?B?ckFTTFpleHFJTEpheVF0d0JCZnJBZkcyQjBQMC9vYzJ0MEVoanErSkd5dTlZ?=
 =?utf-8?B?RVBSTkxmSG5kSG8yYktCUDhDVS9iZWNIM1pXOWNhQkdqZXdYanlzT0E2L0cw?=
 =?utf-8?B?MmMxWk5HeXVSYzNYNXFKVFNqYkpCcDM3MjUyKzhKY2taeUdmck5kaDRRT05L?=
 =?utf-8?B?YXhaL0pOTVdzc3l6enZnZi84VllCb045VlVtbEpVOWdjWCtLZ3ZxZkVidzAy?=
 =?utf-8?B?YnhDOHQ0MW12RWtVWG1MRy9ZYnJGS0lFZFRYcWdyalBxTTZDNC9reUlJeVJF?=
 =?utf-8?B?Y0o1QkVSbUc2OXBkbndiTHhBbXpkVHZWMzUwVUthcVlud2VJOW9rOW8vVDY5?=
 =?utf-8?B?eGg0TWRwUHBDb2FXOUJFZmMxVnI1OWJQMWh5eGZOTUV0cjVnZm5uT2FvN09y?=
 =?utf-8?B?ZVJNV2d4MDV2Yk5oWGR4L0huSlJVbitaUktLdEZHbE53NElhN05Yb1dyUVBR?=
 =?utf-8?B?b1BVZ3RkOTdoU1UxOFA2SzFDUXNsMWtrVHVFL3lvcGd4SG04dWxSM3BsMldB?=
 =?utf-8?B?Q2o5OWFFam5FQW5DdW9ZSVVvQWp6ZXhoMk1aaUdRbmwzeFNGVURjY0hMWVh3?=
 =?utf-8?B?bWZNTTVPODZuNjhKVXNWVis2UlNSS2NIcmlyUmRQQTBsQW1PM2dneVdpeHVC?=
 =?utf-8?B?c2lMRThGNFVLUk5vcTR4azZ1SFBMcDVkWGtUNk9TaGY3K0ZRZVFsbk01dmFS?=
 =?utf-8?B?TkhYSmQ0bjM1aHVoNlFsVVhpaDQ3Z1ZoQUY5RXliUWpSbXlmSkoxcy9xVGtQ?=
 =?utf-8?B?WE5OY3I4VmpYT2ZQOUdRSlBQZ3dpTjhseU5wSUdZK2l4MnVTSnUzekZxa3JM?=
 =?utf-8?B?bEFtOENFclRReGdUa0lnZzFQaWxGdHo4NThoT21YZ0ZWblNTSHRYSDM4VStQ?=
 =?utf-8?B?VUNTRjJjS2JIZG1oWkFWTXp6UHdPNnE4WHpSZHhLay9RS3h4clhpMXFLSGRn?=
 =?utf-8?B?eFdPUklnRkxzVUcya2Q3RGhIYWEybWNGSVFrNjBPYm9TUk9vRHBJc1IrNCtW?=
 =?utf-8?B?Q25hcWRGYlEvdVE0YXZBTXFEd253OHlQUEM1VDg1K1hZRlQxU1Z5Zm5oZGZn?=
 =?utf-8?B?WXZxVXdiVG9QNVRXLytJbHkwV2pHWmY1bFlRcHFYWGtZVW1saUIyTWpyb1My?=
 =?utf-8?B?bjVZOGFETFZFcWlrSjk0V2wzWXUzOG5adGsxMzNQNm9BWSthN05EcUFhd0lj?=
 =?utf-8?B?SEhOMjdrallzOHM2cDU2OVQzUC80T25OK2xZanpDYnRBczk2YVZCa2lHQ3pa?=
 =?utf-8?B?RE5UNmZEV3lVUXdDTDdBeE9zdEdYeGxXUlFveDU0ZlJ2N01EUGg2MVNmOWE5?=
 =?utf-8?B?SEcra1kzR3pndGNYdGQrV0Znc3Naa1Q1QWI0cDM1ajNsWExQMjhpLzkvbzFU?=
 =?utf-8?B?L0JDQVVZV241SkN2K3RzTk12MDFvdHZ0TDJDWG1TVlFrdllucmhXYmlXcStY?=
 =?utf-8?B?anc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6080A27D980B2646B2B61E334414844C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2EHN/mAyWqQLwOZ9g30JpL0FO3cCczp2ebPdoPk97Q+0ePjAf6wxZ8tZFr17hACh8ETFhhornuL83PTg+W5mZRwm9bvB29Na0ult01u9C3S6rxQnJkFAS5khGsjlevDjLmRBr1XbuY4f/ayOqTPOhBdbl9tnvgOp22OMCl3C2mWZB4JF/JkWyFVImuKGVVVwPbp7a7CCqGRhI323GG0IX5iEE77WYlfndh4VODB/cSbSAl4zWV94M/sbeDiN0hCq3Vnx+NRHLV+zuwRq2O1ql0s9g54RKmYTLvcqaftB1tPLbjypIMv6w6757ecx11M9O69NpBuiOab/w5n9QLuMNm5ywFt/OZvmOMuPQxKbY/jg2DSDwNcO5+KqSszKBDKZDu6hBh3TqDjIubDwwcW0d4FaH5oxfWdmqvkeSueGlzQk3XbrmWYriEct5GWhRW3r0I/kr7j8kFb2vdpoWJxiTvPSVtLMFK3o6FQZXrqWgx2hU+8oCQAMEZKYKeG3B2XNcti+sMytuXdKobmDGQaJcdAeCMmbfKGSPyGUlV0dcYa3kBt2V6tEDEdoHt00xJu8mHH6Gl1pFgigyQn2C4Uu3BZdU4XkYTPvvYwspNJZwPNXcENZ3vBNeKHrAivZ0yfe
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1214032a-ecf1-4309-6400-08ddc84bacd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2025 11:42:30.3541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nnnucB88hVeZGzVx3dmONMKSy/uTfeLuVDmcoP+WAs/scOEmLhfsO+Hc6Etvdwrhic9d4um+Lvgoug1leY5jeSpnZFJn5lVPDB8TOTRgbmA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6632

T24gMjEuMDcuMjUgMTM6MTEsIFJhbmphbiBLdW1hciB3cm90ZToNCj4gRXh0ZW5kIERNQSBkaXJl
Y3Rpb24gb3ZlcnJpZGUgdG8gaGFuZGxlIGFkZGl0aW9uYWwgU0NTSSBjb21tYW5kcw0KPiAoU0VD
VVJJVFlfUFJPVE9DT0xfSU4sIFNFUlZJQ0VfQUNUSU9OX0lOXzE2IHdpdGggUkVMRUFTRSkgdGhh
dA0KPiByZXF1aXJlIGJpZGlyZWN0aW9uYWwgRE1BIG1hcHBpbmcsIGluIGFkZGl0aW9uIHRvIFpC
QyBSRVBPUlRfWk9ORVMuDQo+IFRoaXMgYXZvaWRzIGlzc3VlcyBvbiBwbGF0Zm9ybXMgdGhhdCBw
ZXJmb3JtIHN0cmljdCBETUEgY2hlY2tzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogUmFuamFuIEt1
bWFyIDxyYW5qYW4ua3VtYXJAYnJvYWRjb20uY29tPg0KPiAtLS0NCj4gICBkcml2ZXJzL3Njc2kv
bXB0M3Nhcy9tcHQzc2FzX2Jhc2UuYyB8IDE4ICsrKysrKysrKysrKysrKystLQ0KPiAgIDEgZmls
ZSBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS9tcHQzc2FzL21wdDNzYXNfYmFzZS5jIGIvZHJpdmVycy9zY3Np
L21wdDNzYXMvbXB0M3Nhc19iYXNlLmMNCj4gaW5kZXggYmQzZWZhNWI0NmM3Li44YWVjNDc1ZmM3
YTQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9tcHQzc2FzL21wdDNzYXNfYmFzZS5jDQo+
ICsrKyBiL2RyaXZlcnMvc2NzaS9tcHQzc2FzL21wdDNzYXNfYmFzZS5jDQo+IEBAIC0yNjg2LDgg
KzI2ODYsMjIgQEAgc3RhdGljIGlubGluZSBpbnQgX2Jhc2Vfc2NzaV9kbWFfbWFwKHN0cnVjdCBz
Y3NpX2NtbmQgKmNtZCkNCj4gICAJICogKGUuZy4gQU1EIGhvc3RzKS4gQXZvaWQgc3VjaCBpc3N1
ZSBieSBtYWtpbmcgdGhlIHJlcG9ydCB6b25lcyBidWZmZXINCj4gICAJICogbWFwcGluZyBiaS1k
aXJlY3Rpb25hbC4NCj4gICAJICovDQo+IC0JaWYgKGNtZC0+Y21uZFswXSA9PSBaQkNfSU4gJiYg
Y21kLT5jbW5kWzFdID09IFpJX1JFUE9SVF9aT05FUykNCj4gLQkJY21kLT5zY19kYXRhX2RpcmVj
dGlvbiA9IERNQV9CSURJUkVDVElPTkFMOw0KPiArDQo+ICsJCXN3aXRjaCAoY21kLT5jbW5kWzBd
KSB7DQo+ICsJCWNhc2UgU0VDVVJJVFlfUFJPVE9DT0xfSU46DQo+ICsJCQljbWQtPnNjX2RhdGFf
ZGlyZWN0aW9uID0gRE1BX0JJRElSRUNUSU9OQUw7DQo+ICsJCQlicmVhazsNCj4gKwkJY2FzZSBa
QkNfSU46DQo+ICsJCQlpZiAgKGNtZC0+Y21uZFsxXSA9PSBaSV9SRVBPUlRfWk9ORVMpDQo+ICsJ
CQkJY21kLT5zY19kYXRhX2RpcmVjdGlvbiA9IERNQV9CSURJUkVDVElPTkFMOw0KPiArCQkJYnJl
YWs7DQo+ICsJCWNhc2UgU0VSVklDRV9BQ1RJT05fSU5fMTY6DQo+ICsJCQlpZiAoY21kLT5jbW5k
WzFdID09IDB4MTcpDQo+ICsJCQkJY21kLT5zY19kYXRhX2RpcmVjdGlvbiA9IERNQV9CSURJUkVD
VElPTkFMOw0KPiArCQkJYnJlYWs7DQo+ICsJCWRlZmF1bHQ6DQo+ICsJCQlicmVhazsNCj4gKwl9
DQoNCk1pZ2h0IGJlIG15IG1haWwgY2xpZW50LCBidXQgaW5kZW50YXRpb24gbG9va3MgYnJva2Vu
IGhlcmUuDQoNCg==
