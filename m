Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D90234A773
	for <linux-scsi@vger.kernel.org>; Thu,  2 Apr 2026 07:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775114981; cv=fail; b=Skz42ai49tQXU+B7d04yIWkDqNBVQZH0IGGgYnsg5Y15qL6ifrE0aPaia8QrnkPpwDq+GmET6ZGTD3jejtgCPm/9t7Zb+2XnxVRGc3Om/rHsCW3TvhEoowVYkvX1FtJDQ97s1Kxxloh5AaNdH/zLlq9fPZITNCHEJE41y7RUZN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775114981; c=relaxed/simple;
	bh=6JOOWahcCnHzIL9PPwOOpZrXWRRY2943oFpXCjjhvaM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uhWVWds2j9HujFw1+X3K8M0j+ONq2TA1+H3qv+59qh9ajlV1L/bPsFbcfnjsXEhSKIRKrJwKiEdJZmDN92WxatwVarNCylPXakzGiiF5ZSZi2THsfAVY2CTjgTMspz7UXaSXoY/30nyjjjdA0P9tWPcvlNHze8n70q0evBv0lu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=uZzqbw55; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=r5a+m3Oe; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="uZzqbw55";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="r5a+m3Oe"
X-UUID: b356c2702e6511f1ae70033691e9ac7d-20260402
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=6JOOWahcCnHzIL9PPwOOpZrXWRRY2943oFpXCjjhvaM=;
	b=uZzqbw55ZpMe8BZrCPTo3udrhoBsx7m0dJ4NRJXMAFM5MVrCw06RjEtkjFQANgaye5W4NZ46/EjmNQPvTi7Bmhw8mBvFiDJrj/aPwFja1ZT/Ds97fLFZCkJzyYQYNjyk3NkQwHI4lQvIUwPaUpTmrcZYbu+qjiRq+ufMpOzxeoc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:a401e7f2-963b-4f2c-ae38-daa7fdcb3e21,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:29316cd5-060f-4ecc-9ee0-121eeeb4a682,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b356c2702e6511f1ae70033691e9ac7d-20260402
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1891583637; Thu, 02 Apr 2026 15:29:36 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 2 Apr 2026 15:29:34 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 2 Apr 2026 15:29:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NDlfBu2HyJYtawWrOExbmX7IEMtXrlOi/+sauD7Obt2AbRUzIRXP1vOZOSVhd1bTrLvr1CjSDeWD1P0wosj71vtXQwNZvfwDMuTgGg1OcBt8zIEw3yR+0AbRAzReEhMiVBpia1Cem+nN906sD2BLIs9z6BgOGcV1/mW+Nq2WveIp4Rer56XSMA/TZltkVL89CI1S9j5xNBTMUhAYxblNPcR2qeIvDMsEejh1RfoS6PeVHpVUBJP6472/zCXfta0gBEcQp2c0K9vzr/GffOWb3YaJLL8ieH2eK98nz3wJ93OzCmW+Vax80bEURjvMn9gUlgb3SkLKbKeOno2KfOkx4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6JOOWahcCnHzIL9PPwOOpZrXWRRY2943oFpXCjjhvaM=;
 b=Dz8YURU4RLNVf1nJ8vOhmZYYm2rml5eOsXi1dJvjX2P2NZabM8mDRJSgx4EJLbr9VR4d8kSzARiWeBMfMhF/+nWvVYCDGfaqdlPBpy/sGwuB6VUxjCAs8eUGufFmHqs122Rd26pZGO1kIfnG+XGdvoVmU+olXfdhJS1ncRyElCXs53L/U81KEYNNzKYcHN/fe3hoNe13uN/EYhK/ZckILnWPh8cYDljSuS15EY+svloa3TF7BhUPEt9bF8BOO8mEEzZdrTjKjZAGqOFOJEERg6tPP25jNXJTwlDMuu3by47bdi9BFA/BXA7fxGekOys6J4yHyls2x+aPiNvUvsFmrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JOOWahcCnHzIL9PPwOOpZrXWRRY2943oFpXCjjhvaM=;
 b=r5a+m3OeEFHn2q/QG8CBXD4jRZZ2QjLKk9vx04EO46oA+g4YcfNdKk+BwULzcWUXgUcVUoX7j9WUMXAF1b0AiEg8vOsIymmoQbFLhZhUPIblag5dJXiQ0bINZQP11u7EK0bZ83V0KvCoSpl3aMmIGU9earnrKvav80DlmeJ44Mw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SE3PR03MB9379.apcprd03.prod.outlook.com (2603:1096:101:2e5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.19; Thu, 2 Apr
 2026 07:29:31 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9769.016; Thu, 2 Apr 2026
 07:29:31 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"vamshigajjela@google.com" <vamshigajjela@google.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "chenyuan0y@gmail.com"
	<chenyuan0y@gmail.com>, "ping.gao@samsung.com" <ping.gao@samsung.com>
Subject: Re: [PATCH 1/3] ufs: core: Add a comment block above
 ufshcd_mcq_compl_all_cqes_lock()
Thread-Topic: [PATCH 1/3] ufs: core: Add a comment block above
 ufshcd_mcq_compl_all_cqes_lock()
Thread-Index: AQHcwhW/RJE7lXi86UmwG5J9BKZlv7XLYLcA
Date: Thu, 2 Apr 2026 07:29:31 +0000
Message-ID: <3c0bbf1873a18afb89b344aaed62674d91157a7f.camel@mediatek.com>
References: <20260401202506.1445324-1-bvanassche@acm.org>
	 <20260401202506.1445324-2-bvanassche@acm.org>
In-Reply-To: <20260401202506.1445324-2-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SE3PR03MB9379:EE_
x-ms-office365-filtering-correlation-id: da49565c-1abb-46eb-04e0-08de908994cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info: H8vVQL5gQN3YPoO9Lph+EtbwH9ZOBABZIK8xPvscd4s/l21ekdGd/8Ds7UD6vzVj0lpNDIgcNz/XUAqjm2uVjCjA5yvqL9Dhywwj0riMiI+mHJCWeH+X+zesk1EsydOsLui8NHMdiWyIhNNbWJsWyqVNnOt+Sp1dkeTV+DcXkDPFlRBGM28/GCGntyM/W7ub/AwGYzIagAQgL29CJOPqcUEJJmq7I5dhkxw7PPS7E2nAWOvl7wEED6E9CiXYYvVQAITIFxwSPzzXQkzNMD/WDO9CHQvNOVP2XvhZ8c8v5bknCys2Ve/6jz2OQ0d1WmOuTWeAROIT1hsvWmIInsZyHziC9Ec4M0X5sAVlh3+FHqtgDVGawynYTQsKYjfkqTWgUwGoTfgY2dTaSHZHXZKZx+fpfKromX466ub692Bq08SjDj2QtN3+/jBYSAdxNw3sZkqgUX2L+PLLfH1dKMT8H1Lf/+KNNINe2TnNxcycWeoYgfYFCN/kzpJv3KNmI/KHYw9VE2klSJhGIgKM7TY96eP3UYSfnc2jU+YgilTZre8knlwLox+sjjRTurLJsOltbii2nBKh6GcAY/yVhsd0DR8x3HDace+rCFVRuOuAbmeG8mDrOXflsStf6S5XWW+etYRGprkbgltt6c49Rna6RoVfVTTqY6KPgYTTo2/pC4E6svx0FovtK318gcVE/ZFC1q7nHLNXljhsNjUaUDQN38FhY8nO5yqQVzmulM8CGTTh19xy8EposOA+tO9ctpCCiCG7FA4UlOJ5PQXk/sr9LRm0FhVoJKE2NkvrMmrVNVI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dlpEN0hyZzFBWGxBOGw0MDlrek5WcVVHL1dVUjJNN2I3Vk1nOWZGQ0lWNUZw?=
 =?utf-8?B?eS9pbnNWSHBEV1B1bC9CTkVhVGtvKzVna2dwWFRldStqZnV2dWpIRUJRQTFB?=
 =?utf-8?B?MU96WCs5ZTVnR2htUzZCVnpybkVKenJ6Sk4vQ2xDUVVXdTBmc1ZCamtvOHJM?=
 =?utf-8?B?VjBiWU1oTjh1a0ZPWEprakl1emV1M0NvbmlxWkdEOFlPRE1KbFpRdWpwRDRV?=
 =?utf-8?B?UnpnSVIxbXNjKzJoN0xIbjl3cGlKdFRyaHRZd1lqUUxIeVFKZUtqME5iZFp2?=
 =?utf-8?B?MVlqVjdidGRHMTcwR0hsRlMwbXlWOUhZSmF3ZkRNUUd1QU5TOU03eFJWOWlN?=
 =?utf-8?B?T05BeVgxektrKzZNclFjYUorM0RDUWVvQjBWU2tNMlc4SFF5UHRJQ2cvVFdm?=
 =?utf-8?B?K3UxYkNBRDY5MUhlZS9hcllWSmpVYTFqeXdQYTB6bUpxVXpCOU02eVdaU2ZI?=
 =?utf-8?B?Rmt0Sk5uNU9Wc0Y5RzJwcWd3c0MyZmtZN3ozRnJSNlArS2tqcXQwS3ROYlcv?=
 =?utf-8?B?VjUwaUE2Q21aZzZ3R2IwR082V1NyczVKd2lFTzkxS2c4ZXJHckFFNUJIVFVT?=
 =?utf-8?B?SGJ6VGVBanJ5TGhWRUVTVXZjWVpITHlMM2xhK05vcWovZmRvaHNtVStXc2lB?=
 =?utf-8?B?a3lleDhGVzFhYnFLaURSblVyOWllSDlMQWFwaGdiUDQwNkNkNnR5ZGNvZ0Rl?=
 =?utf-8?B?aWptSG4xd0wvd0RTcGhhcnRLV3pRUVQzUWxzOTdxQlo3Qzcrb2MzTk1MQVUr?=
 =?utf-8?B?ODRYSlpKNnF2TjQwS2lmUVBzVmZsOEFOTzRnVG4rb3lBeGNrWXE5M1puSEtC?=
 =?utf-8?B?SGRDbUFSdkw1dXA1MHNhMHdoRUdVZFRITmFoRkFSL3Z6ZTd3NGxqZm5wZHRQ?=
 =?utf-8?B?ZGk1YjFGTFZMMVM1VDNZa3UvTUlJU2c5SUFBMUx1VStEb3ZvVzFSSGhja2wz?=
 =?utf-8?B?dTJ3MXhjL0syL0J1NzBjaU1OVExSeWxCSlVSMWM5NzVSK2ttK0loaFQrUWxV?=
 =?utf-8?B?a1h2bytJOTVTOHEvc2xkSUdyNzBVcFJ1eS8rTG5kWXg5bE5oY1FRMzdVZGx5?=
 =?utf-8?B?KzltL2RKb0VCQzMvRW80eGVWV0VLTTFjMTRIVTgvakVpMHRMdVBxSU5LM2FV?=
 =?utf-8?B?UDV6aUg1dVJnOWg3RE9jeThpY0hiVkhYSVJUQmgxZjNIMitEQjhjQ3MxaXl1?=
 =?utf-8?B?Ly83QklUMGpzK00yYkhLNTBsTzBTQm5VTVphZEt5WENvcEJQVWpUME9LaG5X?=
 =?utf-8?B?c3BiZERRUUJKMDRWUGJXbnFTelZTd0lHQzU3ZHZGUU9rV2hTMFlCNlFOeXlB?=
 =?utf-8?B?N3pKRGIrQ0pITGV6d2F1NGxKRUFZVDBTbGRPbVdIYmhVNzVIL096SkJlWWRN?=
 =?utf-8?B?enk2VUZKdGFId001RFNVQVo2Syt5V280ZWRLZWFzcDRIbVlHdHZMeHJLK3o4?=
 =?utf-8?B?Sm9MdE5rTmlLTjlra2M0QmlsVU5PMHQxbUsxT2F6RlpnWG54bVRLNkdMN2Zq?=
 =?utf-8?B?WU0yRUZvYXBpYTMwd0kweW5WemczSUtsWVBtT3NvdisxQlFaeXRtdHRKOUJx?=
 =?utf-8?B?ai94bEZtSmFsQUxBa0RyRkZBc1Z6YlN6MnY2M3pJcSt6YTFQVXNEOTdvSkli?=
 =?utf-8?B?Sy82MEFpdzI4MjRUZzJ2SHFXdEJwbzR3UFpSUmFqWEt2SkxxR0NGdGR3dXF5?=
 =?utf-8?B?TS9vdmVkYUlaUXNBSVBKbUp3OXFtRWxHeDdOMDAyRGlGSk5aZUNlbHViNVdW?=
 =?utf-8?B?eGVVbU5jQkk4bXJmcTM4VzYzelo1WXplSmIwM2pNRm5KSHRuVk1lZnNIdExF?=
 =?utf-8?B?UWFZaUpLTUNwc2N0aisvVkU5QnFXUEkvczR2SDBoSlErakZ6TXNNbzcxU0VS?=
 =?utf-8?B?R2d6UXVWd2g2cC9wUHhoQUZlYlZkMi9hN3hQZlBQOExvdm9RL0VCNlN5ZkpX?=
 =?utf-8?B?NEJKRDViWDdqVDZka2FPUVE1Y29Od00xcUpPbURzSk9KYyt6WEFldWh4ZWZE?=
 =?utf-8?B?bGlOMUZ6UFdlTnB5TDBObjAyTU95eS9xZkhFOW1MYklBQU1OR2crckpsUkF2?=
 =?utf-8?B?L2tMU2pxVTV0Q3l0TEpHVk5iSnBLYTRmSUQ0aVN0dVNFdTFGUGY5OS9BUGs1?=
 =?utf-8?B?THNWR3VDRGZ5ODEyTDg0L2dGYmVRRllNcSthbTZjM1dSY0xQUXRCUEZvK2pV?=
 =?utf-8?B?Z3VOZUV3bThkdWVZQmdtNVpFVWVpSkhJM0gyRnFQclBPYUJScTdPRXcvcUJQ?=
 =?utf-8?B?M1pzWW0rOWFSSGRkUlliK1JRRDNWMFpqZ0M3ZGEvbEE0aU54OEk5M0hMUVJo?=
 =?utf-8?B?UG43LzdEWjNvaGJRZitJQ2dxZURybnpkS2ZMT0RPS010NUxHL1VvYVNUckdB?=
 =?utf-8?Q?uX9oiyDLE2YVnuJc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3FE821EB3CBADA46A189B23956E5FF1F@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: sW8FWL6/c+aMuAB904j28/khsQTqpwOpL95mRsrdj0y4hFnF4UKkuG0ZxcPWhj1A8qa8+9jCwroGvsBJ0q9GZevtUJeol3jebVq1LHCwh1cuWyWcKKBJk5YU5FhlK/OBv9xwxowwct00/fmjLkyf26woDcFCSH8CVYMvnbJKiNOacSeuN+JOO0IL3nZXanzsnB7gNjETnurTNcHsDoSBQ/rV9l44vlIGTnLy7jl84y5aXTgYgO1pC9rxgtgwGVIk9moIIQUjp27zxqei+jGXVL36LmL34a/iPPpjiecacZahZ1sZPxnmIiiuc00UBGFh9aocqiaIApqrXcIqRVx29g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da49565c-1abb-46eb-04e0-08de908994cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2026 07:29:31.4465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ipq38M6yErXNzZohOd2aUSbkAI8xNrJZ+dfcOeAWFlz7OlFjz0KyYa+8C8xpKtZ/AiL9gCvgaXzoi/JOFbowXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE3PR03MB9379
X-MTK: N

T24gV2VkLCAyMDI2LTA0LTAxIGF0IDEzOjI0IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IERvY3VtZW50IHRoZSBhc3BlY3RzIG9mIHVmc2hjZF9tY3FfY29tcGxfYWxsX2NxZXNfbG9j
aygpIHRoYXQgYXJlDQo+IG5vbnRyaXZpYWwgaW4gYSBjb21tZW50IGJsb2NrIGFib3ZlIHRoaXMg
ZnVuY3Rpb24uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3Nj
aGVAYWNtLm9yZz4NCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0
ZWsuY29tPg0K
