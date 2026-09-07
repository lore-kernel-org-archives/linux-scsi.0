Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A18E5111B4;
	Mon,  7 Sep 2026 16:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788800250; cv=fail; b=BvZFxGE1wQCl5W0t12rvmnuuMxk42cqbdZ5aG8Jcfz8aowdVnP64jxC2aAEwfRICl+HCtIr5LJnZvjbBoIDYoBi3ASjQ8cFcq1Wr+iqEHk/Uo2xK6WWzhPucd07R92VgbtgfV96iuBsB2O7CukVvw2Jg5janQSMC5YwVT6wN7lU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788800250; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BR+hGGshDED731CANtJFzVbIO7nnwHV6XhmGlbqUEHX6Oc2/nM2D7+rP9FLJlK1QvOyLEL8skJi4a1kpb892xMA3Tzd+3pB53lwEUm6aGVTQ5OTT5BPdgQEb8FLIt0QfVx+D1rZe8WVXihfXUajn0e17bYxs0pY1HwgVpk0CNfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Bct4fDmL; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=atwNrY8d; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Bct4fDmL";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="atwNrY8d"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788800248; x=1820336248;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=Bct4fDmLSTqx1HrZKwX5SKOH+BM/MNlT2Vt/ttN9QSo1B/td1I04Qk4z
   CHtRV+govr0jiqJW1SkC7nUzuHUP/eBHtMVYEi9C4ExJxG/A3Q3O7kJ6I
   bm37x9EUNq3nApDAMGDOjq8JDwn7Qbuq/xnGBo96+pjEJtvy2LC/ioCFy
   7l4CQbJZVeawgkJcGss2l3fguTKMAK+Ik6Y9cIAH2v+fxNgVLP0Rw7LJj
   nsk491o9BKYHwDuUSpe5E/lL8WdtNPyegy1Wx60SW4SqobjCu84MmpWdX
   7VO/ioFeyxoa5YKl38GeTDOD5htAetja1dk1CAE3Q51+MwK+d8LExEK5O
   g==;
X-CSE-ConnectionGUID: OX2ZLjGPRIimjwK+uQZKhA==
X-CSE-MsgGUID: nTROp6vfT0SK86EKMB2QfQ==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="156054581"
Received: from mail-westus3azon11010050.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.50])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Sep 2026 00:57:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K3Uw3rTWNZreYiBo4jDNzg/Ur4lYStMSzoRmtb154Dys6nSPWPMrVpkUj8/eLOooLJ+ZKCu9d2XewlWT0xscKvnjnic7O8IRY99WJ97wC/wCf+CTonWEV65dMyzhtHq8b9y2wMJEJfm4AQHs55TRPiQ4LX8HfyAWbcmM+P4cm6iEWMkl7P6jyMhfaEXxB+wj3FEPRO1kA75kIcDBU9gnHq2PFVXUBtStYSFQH83FeTa1EYP0i+4PGzz6PImJSeRTVR/P5UjiWAGfORG+W5CE9ahVl8EpUCmw30O+pEYtxG0yYFhftp2tV27t/chkhsXxGVwtOpWXeGrntkFO0bEmeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=blGlGorKG8j9UnlXm+FIeyinM3gmz5IAifA2nE/ll9TfKce2+7IH/se5EvSBjYBMjs5UNGzynB2g2XOW93IiB+j3weX/Sy7RBs6d3Qlg6+DfchcjzS+Zbb6YI+ywix1q/SF1RVKMIRyrQzv6iiUFACvb+ViQySOPXuas86TAHJvKMb3W1+Cf3iqLS/jotWc9cMaxKJreUVUJipaLwhDeJEaHKLb+hXHOJCRQZaWAzOW6/vOIwNfgq5tAzdEWbemPBPgo+Un10NhRu2UYzXbhICKJkYYmbBJWJlCh13KnTz1t0jjxy1V7Vbcl/DwnYy7A5aeUtSgNp9UX7x0qT//qFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=atwNrY8dDRW+RwsqsoorD9hsbzb6TtajCP6581ZnLKlgdZ/DpYMGiRbV7q978v1glJUE6OHQkDkS5dMjTg0NLGwYMYDUoxcjdLYEn42ZeQsWzjZdoMBFHmSLLHFKwhEWE5bxBBSPP7f01qqRm9obKxcgFKFwvy35jsREvriG3OQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB7022.namprd04.prod.outlook.com (2603:10b6:208:1eb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 16:57:25 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 16:57:25 +0000
Message-ID: <4bce6a49-bcc5-48cc-9daa-fa38ccb5e152@wdc.com>
Date: Mon, 7 Sep 2026 18:57:20 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 40/40] scsi: remove scsi_build_sense() and
 scsi_build_sense_buffer()
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-41-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-41-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0165.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::20) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB7022:EE_
X-MS-Office365-Filtering-Correlation-Id: 763cd603-b8bf-4ecf-1c1c-08df0d011779
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|19092799006|921020|10067099003|4143699003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	8Xk3FXvN/0u+0NOEYh+B4OlVz+t2oGeXY96e0Dk8FRGqYo3gEnL3zE2FVmm0QuKD9Mr9v8t+tS+CcDxaqjkUR17RrjpRMFCBXuGHQadGuUhqcFjlObVgyMh9YCzRYSNuCRtouZvjig3De8etzzkfe1lcCHuozAe/lLcHa5eB9INGs8pN+tcjJOD9+KpLwyXf+jb/9uErxZB8sxX0Jzp3dmPnZVbb9+nDpUmupoe8D5SvNMObfOy/Zpqd69fagxxmNolptmO/6jRAcmo4B78XVclJRJrUnFYXXXZD0avyAOO7O5BZSpet9SGp9TGTXqjYYI6R61FuoIuXqy3vu41Z74QXema7Hfk7QUCyUfbi5KD9hZirNHy47FBCQlroqGMgoSvWtxUzUgDjTQNNgEmifv3MtT7AW9lKI2xqyMdJu651unLZNMCjhkwdqxdalSpA7uZ9k9jjLwEkG8QUcgd24R9GBajPXB+fJKeULWGdI0OiHllVtK3tpPPB+xVDzB979BiNVlEZ5510eT8GkFAsXKnnGdlVY4AP25rc8y7we8/xj0JAFv+FK4cWt9SB5Rl9ICbARTjo34KLpdpDlU/wvpt1LCyOZy+lGGFzl5tPP+IkaCbxWhsYoBur5AGAG25bRO9erL/jaeRThchiGY6uEWE1/TjKIhOa9ljX0ugwfcIZAty/L/bV2GHtwX24vaSUS4dZTOkvuk62Pyr9k3GkBA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(19092799006)(921020)(10067099003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c01YMDhBL2M0QXVCbUNNa25YQmVud3Q3N2ljV3dsU0tsRUttOWF2YS9ycUNI?=
 =?utf-8?B?cHdPNGpPa2lWeHBjamtNV1RBMElUbkdRcExHU2FwWGg3b005UzBZTlFKQmJu?=
 =?utf-8?B?YXVqL2tFNU9QMGl0andaVXZnTzVnQnJEbUFNY0hKYm9oamVPd2VtT1dsc0oy?=
 =?utf-8?B?UE9ERHl0c0pQU1lZUVNyWFlyWDdGbXMzMlMzR3k2dkV4LzgwdFpIT0xBbFlW?=
 =?utf-8?B?WXlGRmYrUkhpNHBCUEZRWHZUSHA5NkExeUEyMzdkd0VYWEptWGo2Y1hJRzNk?=
 =?utf-8?B?dTZKRHc4cjdrZWdGZ1lJTXdPWkFVODlaaDVyTDFxZEVZNmpOdUhvaDQ0NTlq?=
 =?utf-8?B?Uk14dmxoeHR5NGtZd05BZFZZdEp0TGE3d25FVmI3eTNLUnpiR3J6M3FjcDRk?=
 =?utf-8?B?YU8xR2cxZktYeFJyOXo0SHREaWdBSXptSzlFZElISEt1TkxPdmVFRjM3SE1Z?=
 =?utf-8?B?YWFMM21MZkw2ZzkwRkV2Ky9abS9kWlRWVldhWGZOQjVkTVZjbTIzcGJOc3VN?=
 =?utf-8?B?enI3NytqZ200NkF5bEp4OVAwOEdNcWNOZWVDdFpSQTIvZDlRNTExNlMzU3dt?=
 =?utf-8?B?ZE5IdEdUeWZBYTlWa1psTStLRys4WFpteGNQM0pxMFBjUnp2a1cxRkFMSXN5?=
 =?utf-8?B?YVhEZXlNNjNSMnNHemlQcUx3TUJSOW9vSC9KdkpYSWJickh5MGZBaDZ5UW4w?=
 =?utf-8?B?VWhET240Uzg3L2p1WkRrb2J3WHU1T0ZOamJLTzFrUW9hTHF1dy9mSjNoa2NR?=
 =?utf-8?B?TVdVck9HYTltTTgxQTFFaXJnck1rQmxaT1RZcmQ4ejRKMkhiL2hGMllWWW44?=
 =?utf-8?B?VFZqVk1ySEdXd1R6bnpLRm43RWdRWlp4cEkyNG9FRG9jeUJaZE9QM2hoazF6?=
 =?utf-8?B?VzhqeXc0SzJCc2kwcGY4TzJqS3JSeGk3S1Q0Z1RuSEdUanIvU0tEUXJScmdY?=
 =?utf-8?B?Z2l3S2l1MHgzdUpTZ3ZWVTRFWVdvZFBraEpPQUhkUURBTm5YMUZCdWlYK21B?=
 =?utf-8?B?WU41Z2cyakg5ZlByM0E5ZE1hREFCQkZ1QWNSb1ZNY2U3UDlsWmF3TC9WQmNP?=
 =?utf-8?B?SHBOV3FoNTYwSHRpTnIxV01Bd285ZFprSGl4ajJyNjBMM0ZBZnkzdDMwM2lH?=
 =?utf-8?B?bEZDT0hLUFFPek5QZXlpSTlweVdWbGxXKzNxTUZyYWhyNW5uNHFyVmFxWkJw?=
 =?utf-8?B?aEswcXA3MnAzNWYxWGp1dmlRelhvMkY4d210SW0vSnhyMHRFcUlmWjFONy9r?=
 =?utf-8?B?eU5MUlhnWGE2NHpmaUFXZUpJbzlnd1dyc3MxdENEYzFxZkQ2ZkVZaXdHdmQx?=
 =?utf-8?B?R2RDZFlIbFhXQ25vdEhqUzFYRUN4cWxBM0hPNHRtbEV0a2JuZFpveWp5eTlZ?=
 =?utf-8?B?cklWN1hCSkF4czBaOWRvSjVEeXlyVUpyOUFaL2Qzazc4WjFYeW9BVC9ST2p2?=
 =?utf-8?B?aXFKTUlWWFVuSW9wMGpCSHdEci9wU2VUbzdxS0N1a2diN0F5cGUvU1pRSXNK?=
 =?utf-8?B?dFg0UFJiMTZDNUtHUXBuV2Z4d0ZnS2t6M2ZGWlZ3VENKdkdsWHgxcllZQVhL?=
 =?utf-8?B?Q3ZOQTRIQlh0L2dpQU1jTlFXbURXY3JpRlVXUHo4aFdsTlBMckVIVDRnVUdU?=
 =?utf-8?B?SmxkQWM3aStPdEU3QXJlOTVmb250MVhFb2hOcTFoOTFFTG1RWksxVXh1RTFI?=
 =?utf-8?B?bitjZWRROWpyaUdzS1NXZmVaV2k5c2x6Tis4SVpNSGpzL1htYU5GQm9pa0hl?=
 =?utf-8?B?ZFgvN0ZzcDZSM1ZWUUFtTWJSWFlCYmprM3dHNklKRDJJYzdEblljNVlkWHV3?=
 =?utf-8?B?M3pRSzZkZ0NUQk9vaXFQTkxrT0NRSUtWUytnTG9jR1dKa1pqWmU4M3RnSUV4?=
 =?utf-8?B?MmU4TFpmdnBIYmtIbDFqNmU3WXUrTGR6dkZFbWhOcDhyaE5vRTRyUEJJbjdQ?=
 =?utf-8?B?bURGMHpoa1ladTZ6V0V2Uk82eWRtZDRWVmh6MmJKdmJLbTRJWEhDa1cwaS9O?=
 =?utf-8?B?OUNXOURQNGo4RlRiYW1YdzhQVGEvOGR2UEwwbGpXTTJ3T0hGY2haTkxCTFJF?=
 =?utf-8?B?emdxeDVibmxTUldMR2h0RXdtQ2xLdmZuTG9jMHBDREZkcWwzN1licW42Zmxq?=
 =?utf-8?B?K3BST0RDMnd1TVF2bzZwbExkaDNwNGJVY2t0Tjh5eWFvT1RJYTUyK3NLS2E4?=
 =?utf-8?B?UTZQdzFqWlRuL3FJSkZaNFg0dWp3UVNCK1l4RnNYOVk5bjdIRFdNWjFvbVNv?=
 =?utf-8?B?QldrQkRHYjBqRW83L2NlUFhKcDlHaU5QTmx5L1lBVFlGUGpvSm5KeVV0cnJE?=
 =?utf-8?B?UFZFOHM1YjNuZ202bFF6OUFEUGIzNkVaRE42L3VmL3pRWjBvZjM1WUdVdGNy?=
 =?utf-8?Q?sx/QRkJLaC9p9eyk=3D?=
X-Exchange-RoutingPolicyChecked:
	EpNIiFln0SjviRMG6YOm6dU3lFN4iB/DavQXWojIq1gO4KAY7i7Q7MlfCdpBFh1K9WVwqvCoRNhX0Ng2tTQz2+TPoPHkvGnOEKRL4eLtjQC5ywmUO0eiSvXLMG/0BoMmZmOa+2cOBUXntwmZcYdXKAaG/0SCdihqvy1Qw8yoSkt2by4dULNfn8MTSt6SniucLC0opViBD2stX+AUufZ3Zb55jEdAqtHje1+rVX+0knb2fHbFvpbMBg/JD6/yyTN4v3OOD8Q/qz3Q3tR9rdhsYVQPb32MSyppun69yi2sahA8S/MwUpJDylCVYHSSim0WzHQ1ikXSx1gF0Ss9XrR/2A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wJlJoviSuWVWrLc15ZzFLrPeW6KuXGi5s5V3XOAM38oVrFpx4lOvokc0PAUPIqkF2ksUx64IOM69pyXe5+AId1sWU33Bcl3pLXx6Ic+6cIPLCgcKbL8yNsEsBbptQvSLiNT291oVohMj8NNxDOFbrtmLfWctCKjrc0HCDFez4iQ0FlrKX728/Y+BIFYQ++6p8sJ6d9N38I4Ivv2lqAKZT67wLGqqI7D2w1hwjyDso7MbXO0sHLK3di3XnWxShdY8WPxdmClu8hWtwD80enC3OcrWHhY2cdVRCBd4UI+ZLEDWm5Q8wUp/n9myXcWRl94DW0xHb+9OGZqdOy50pmZ3zDzkblfMypdkXF5l/kbkR4G58hEzWTAO25uiz89NTkdtP+E6ZIEidFcyFFUqMz1LpDYwD0fMdUtcdHH3pqzqKEJCFi6M4flQX60UGAq0GPwqHKWgqU6HGnFhcMz6+4E24O3AAzCa93+xCw+UxN56cdrGfR+diCCfbsB8GA35acfUYLWs6+DBqcUE44O3+nY1jpTEGhu0VJIS2fOlf20KtWo6K0o8XzDh9vye5CveLz/ku3eZkct5Bg6nKE8nwqwIeFRnz2pFR7hgNekgqYQg0P+wvfMQIZ1eHiHHlZN3PgpL
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 763cd603-b8bf-4ecf-1c1c-08df0d011779
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 16:57:25.0495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ONcMSlXHrRiXB8QoCVTJpFNa9gZ5XCi/b9/rgQMNfymhVwn2QUSBRqXuigSnCkiIKX2IjiM21HOw5dZLMwkOF+L8YgkFQTgmjiQOJWvx0eg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7022

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

