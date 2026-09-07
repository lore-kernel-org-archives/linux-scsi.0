Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA89392828;
	Mon,  7 Sep 2026 14:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788790944; cv=fail; b=orZjzj5N+nKHOaCROG/jKzQJ0dPrhCpJAJWYFmH8sKNuBC1tN9fV1dYJ17t62mjqK2HxpZ8+E0MBUQqkxPZ/6GdJ6LRrA3PFicn7VZek04/gnFUH8lQhaBmqat/sGaPe2M6zbObJEhcDS6x1hAgTNI8WLeypRN9eleEVMXJ3yWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788790944; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lArrcrBCc5+2MeK2VMxrW38dNe+J7/WP10I9Wg4p28kt6zvJPheQ7ILpFVxNe+vVN9ADOgyKkjKgA/TFU7znl+iy6kzlzh6HLVC+wM7gtAdtBljGQXhJLrcIoWA7yZI0EeNqJ7Z79PZ5N4Jpt9zVp2RiRxg1jMR8L/jVlOzxDpU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Egr6NQZw; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Cj9i7P5l; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Egr6NQZw";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Cj9i7P5l"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788790943; x=1820326943;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=Egr6NQZwzbIk8FiUj1NyETN2lZrOX2lSEhp4bIGTvNVq/rka3PhFkALJ
   ZN+eHSo9fGtaGBB1aqNhL2H3SnAOvARpMDhOcRZT1M89Jq4UkmxJF4Gjt
   +yni6JD/GDxaR9lzD9InxH+bgRGPaOmTSqClsG9yd5JnBI6ZiPu2Ew2HG
   IuJd/CXTavFuLx5HJBbNkuYzphAWHP25f4OVtVdv4dy5E/fniEEFu+8z4
   MYSFXjD8CZZyP9rWpXEIApf+8Akgi+bCAINXRstDcnr44ZpZEYZl9EbGG
   1iMw9MAVwILERDsNlPyYCoVaXIFNSeDm8quWVwapYh/e10/UZOmjgzxE5
   A==;
X-CSE-ConnectionGUID: MUMpLVzJS9C7N2Tz7NxA+w==
X-CSE-MsgGUID: ktVASlQoSFevdi2ucAMBSg==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="154165483"
Received: from mail-westus2azon11012007.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.7])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2026 22:21:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rV7UB/L9lvOFVRUQH8jsfH8AvZXzD8lyr4B8c4yi7ehj4fXmRtitROaGxShdwuv/iKXpqe4albeSJOwl8QKGiyniricLgZPZrTYQtiSqKhLUbx1YNMkkkvlRM9QrTdPiSw5HGaA8hZU++fZPlx/bQOkib/w4Vuh8oqOjtK1FMo7GlxPVzsm7toGb2WXnVZTNYnGVpBG9I3hKYMWddFuZhO2BTq4nFdx0nYfrsLzKHn6wGLCmePh9kEvsWaKkQian4yPI7bsWkZN3cQULKbrUj3SMUze11BWZO8k5JFbEtou3hwsmkuOxBmEiEN6sUVENQvGBFNlCv9d//+0hsHE5Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=SFUUEmUaVEqqOsEIbyRoW/peFFx/QdHUTVxy8kLyou9TSa2feJLb8NuC7RuSqLBaOs+ncYG7GJ3AMtWDxqHmxHByzapYglSSB0kNpX6mRKSOENrXDwnaFBrEbEdq34kFhmrnl9GcCQwjOLnW+47hAA5eFwIHVGiF6OM96Ezftufz51v8RJqKkRbR1kXNYhvOdfYcLpVu2kMsyyq1aIxbF5LTczi62YvSAagzDCJAFHASnrj/K1OojflcyoOVKwWB0Ro6bG3IYkbrJ44bMl1IcrSxkehJYSQItw6yA23CSvVjAM+ArxpkursXXNHEl5X/sgxYYiScd0ieWUUA5jtRig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=Cj9i7P5lqQGAIsoOKExv2FrmgAb9J1dZFiYq1ui+Qikm28JZS6EBj75NQfsSRAmYRDOilpc3mDZI7gFldUHqc7wIZ156Fwt5h3SGgZCSgA/sk+VPy02icUUtS3sfr++eFM5ILbsAjloK1/iljQv4G+S/vGe1izO/Wnp9rk6K1II=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SJ0PR04MB7534.namprd04.prod.outlook.com (2603:10b6:a03:326::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 14:21:11 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 14:21:11 +0000
Message-ID: <795b847a-9998-46a8-bd4f-762c57d8aacf@wdc.com>
Date: Mon, 7 Sep 2026 16:21:05 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 16/40] scsi: device_handlers: alua: use 16-bits defined
 sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-17-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-17-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0158.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::11) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SJ0PR04MB7534:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bfa4817-3aec-4fd1-9e28-08df0ceb4442
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|19092799006|23010399003|1800799024|921020|10067099003|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ZVr41dLmtyxQgnppaVUELfv9NlQPRDCpvjEhBwDO1xCLZQ6igqXVH8RIH7MimA14HjHRyFoR0z+cXqETIUed90fWFXx91P3PYwLSWanzwukIAWnMNz+zmTKR/1dwW0+Xh4iUdqSU2nLIePMOoRrCIAD2bckoihjanM1dulPFbVhTpYeyf2JKV2Pt4Sjt7gN62CF9Twbb6IXkrJnexbemqS7A00/2/QPDh8i0V3uXrYLF8y/yWe6GTi0CKWIUA/MX53iWXqcLAlwp5EswJHo32LSuglwKJ6/CVmAqRQ/55IR7wQxzqq1PfnUgU7efwqAPpUzI96TwgofCkwZ3y3Prim4LUJ2+B26zIO0APy45lHzRLRJnZDGGbXPo1mcm+cnb6xnrqqPLo53yDaQw8evDHF7bX71PlQzBh9GmYh63AHzdcU6UDuC7OLhx6jcG7fC7QgTggL03ZPjyJ0NrdyOy8EyqA4CrOSvcIo5qMXyTscauw7H+sxE8Bbg/v/CE+722muP7Np3BOMsO8h4OoeUWkdvwnCa1jmplVhIEZEhLT3RLRZhhqBR6HXs9RM5YDpoDwHeJthgadAESIXoL8eMkghiGBy5X8ywBwkvzdPzT5T75aCmB5YAUci7jvEhmBlmHbfZ5mFjk07Ah8bsiIlzFqXPr4M49ATr0iSjmiwvCb/YLZhaSjM4frhBTy15x4jdlglsaYwBSch1WVO8dLs0H7A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(19092799006)(23010399003)(1800799024)(921020)(10067099003)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QVJEMDJmNGlIUW9oVEwvWGVCZ1NYMUozWklLdm5EL1g1STgxcVZiZzhNVTZk?=
 =?utf-8?B?cm9MNHArd2JOR3BKZTROQTFrT1lFeklmNWU3bW9Oc2dBaC9PS0ROR001SkpY?=
 =?utf-8?B?ZEFrbWgyUFJXN0gwVW9IM3VLQ2hGQUh1SWNNNVJnMWtoVTU5RW9MekZPZm4r?=
 =?utf-8?B?bUZaMm00aldXRVJTZzlYNXFSWk1LUDBuZzRyN0x6cmJQd1VyRitPRm52NjR5?=
 =?utf-8?B?eDdiSUVOMG5KYUFIaUZ2bnhreDhMR0JmWVF0Q3FIYUFqTzRLdFBtNXM3V01k?=
 =?utf-8?B?SlNCNmdiMGl6bHdaUk1kUjU5U1dGZUZodkppQ1d6R3dpOXI3R1Q3WUN5cjNq?=
 =?utf-8?B?N1RQTFNEalJvTlhBMG5Ka1dKczhSUlZRbmlRbU12MGpicWdlT21xRmMrZGo2?=
 =?utf-8?B?UXlMYlcvQjRmZ2NOUEoycXZUU0NZSEpWOGlLT210K1hzejQ0Zm1CYmw3MkIr?=
 =?utf-8?B?c01VRFJJWjFpcUZLT3piVlZFKzhjbHZXUC9tODducUQvcTJnOGRMYU5tdjN0?=
 =?utf-8?B?b1RuUEpVS0VuU3dUTmhjVytMcmcraFdRSVk0YVlPQm5FUmp4VmRPZmFsYUV0?=
 =?utf-8?B?VHNpeXczdWVJdFh2SnYzKzVQWFQ5ZEJWN2poL0p3aVF0bG4rNlR6TmpuS29t?=
 =?utf-8?B?WVMxNG84bkRlZCtNZDIwTmdJb1FzaWVkSWVtOVhVR2M2ODNKRUtCOEhGNmRF?=
 =?utf-8?B?SUY5TnFISCt5V3NSbkpXL0FCTndyNHQxYm44ZW95K1VkNlNuMndrRFlNdnVJ?=
 =?utf-8?B?MXI2SFR2VXQwQWdTcmQ1MHZ4TlJUdlZZb0c0Y2xrcU1jU3NiUlJWc2NoYnFI?=
 =?utf-8?B?eW5IdTRLSkxpNFNKSDRPMUs0VytlMGFFa0ZwMjNTdlFoWGR2KzFtd01PNDlW?=
 =?utf-8?B?SmkwVTJTRW10SnpTN0FpazVlYlZTQ2VsR0ZDRGZGRm5zcHJQK2hweDRheUdi?=
 =?utf-8?B?YjNWTkp2NnVXbEVXaW90LzdnQUdWUVRXMW9TcmJaWk1YZ1ZWUmc4cldZS0xQ?=
 =?utf-8?B?eGNKdE4wdmF4cms5aGFpMjhKUzNjSVRtbk1wZExFenZTVUtaRzk3ekFCYjZp?=
 =?utf-8?B?Q1g4emFBR1JpMm9WQnpNbG1lK08weG5wTFVnNTQ2ZHg1c2dPbUM1SEhpdXRq?=
 =?utf-8?B?RlZFNFV0TzJlak8rSTg5N3hpay9URmwvRHo0NkdKTDV1L2hKZlE2YzNjcEND?=
 =?utf-8?B?c211SWpobDZwQUh6K2lLUWFCWlRGS3liNWlKcGdXenJIVjBvaHdyYTFPMm9U?=
 =?utf-8?B?SVBHN3ZPbnRTbTV4RUUydWlCZUZmR1BZV1FtdXlqR0o0Mlc0LzU5YkNzTGpt?=
 =?utf-8?B?Vk81R1FvVCtHaGhlNUNIVEd1ZVYrNGdsaTZXcVMvdHhTNlQ3SnRWNnlEQ2wz?=
 =?utf-8?B?VStBQ2NFUk5wWUhZMnVlVmI1amlKMTcvRlpFTHk2a0taYXBDQ2FjVGo1RDdy?=
 =?utf-8?B?d2llUzJhbHgweUhMdHlnbVovaXNNM1dONTlBUVVuYmovNTlXTWdLMEVTNzRQ?=
 =?utf-8?B?a1prcEEvNDJGb0pJM2NWeVdJdThncDRPZWJ4am9YU2FIS0ZXc3UxNkpZSS9k?=
 =?utf-8?B?clZRY1JJTC9xUmpDUDhFZkRmMjZObEJ3TE5lWGJzUitVN2IxWmdVcTBSbjcy?=
 =?utf-8?B?anlSTHdoOFNiRWhhTzd1SkdzbVkrYldHM3NsR1dmK0tFK1lZSW85K3k4VTJ3?=
 =?utf-8?B?OWhtekNTUDNDUDhUREZJUHJqNE81YjF2cTNQNTFDYTUrSndkSVY5ZExCZWIy?=
 =?utf-8?B?T0hTd0hGRHBnQ3k5SE9mMmFmUko4L1diaFNJTDF4ZDRRcXMvaW84eGY3KzRr?=
 =?utf-8?B?NSsxVzc1SFB3T1RuZXhXTFFaaTZIS3Jic1BVbzUwVUFYT1REenJyMStqamFp?=
 =?utf-8?B?RHF3VmxOYmJuZUhBT21yNEFWNXNRT3hYZjYxRjFBaGM4YXAwdkxjcXhvNWpy?=
 =?utf-8?B?SlI2SjZVOGszN0xTSThpV3BBckJiWVZPUHZNeXZ2WjdHazBKREdkT1gyTGZZ?=
 =?utf-8?B?RDlZQ1Q2MXVWQ3pIUnZteXlRNFhvcmVtNHdvZ1BJOHIxVFAydjNQNldrN1Q1?=
 =?utf-8?B?WENFZkkvRmtWaEx6ZFlZNm55QXkyYlFvUXQ2bGFkdzdoR2s4UndVcExTYkJP?=
 =?utf-8?B?TzUrWmNGSGYwem9lNVh0RkJ1WUo5djBwNmwxaDhialk1WjBuM2NuMVRGT3h5?=
 =?utf-8?B?enB4QnFmRnBQalBtY3JjZ3BsNjhCeGMyM3lmQk1XRjR2ek9mUWRXZlpKRXNV?=
 =?utf-8?B?MnAvMEpGU2ZyUW9rV2h4N2hvZnFtVUJMalRFay9SQStmRDlhS2ltMm5Oc2ly?=
 =?utf-8?B?RElxRmlqMDhZUnBFaVNNaTN5ckE1V0dtN0lybkJEaHE0WjNod2JoTVBWNGtQ?=
 =?utf-8?Q?K7uf/hwbXqH8GPXk=3D?=
X-Exchange-RoutingPolicyChecked:
	X8Z/UPacJvKqeRoEKfcQHxl0f9JoF23tqm3Uh/Tw18dj8XXVql/PhYhzB5GoThn25QFarb+wzXq3shVv/HuSJqudZwevBBfNBFBLywlLUf0lxq7/fRrXirvz/Nbl0Z7fTK1ugnYpBCOZDNcqg9FFRAqruqIXLKWDYf5+yGgsJprrqaH2mbFh9O3kcxGUDuWYgEdOc6dBd983OCiLhsRbpMiKGOtJgrGUzzwFonQ5FmqgydxOQXKfgZbJFkSKBr2whCxRk4lEQiEYhkFevbw1UTOMBzfjxCpOeP++1u5zotVSYFlkf/O627nhjr+R9I4bjAzHW9pTnvPLbx+YS9bufQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MIgTX+lyCNrbxdyazhezVf5DMCHVh3vqsBYt3obVpNiqmxqYXIlZZz5XZe4aoAMOO8dFSxis25zhcPCXm2sDX1zOd1D0EFcHtUcifSXQGxyAS7s7fERojd9eqG2cTXivATi2bd5YohAG2SonyBjzG4DRW1Q/mHwtwaF5ZvyLLD6nrDTlvRGSuH/T1S22haRUhQYwh7v6Kvi9OKz2yf3ALJ0A7G8urbjA0QHzg+HTFyglybMux8oeeU/8bWj8KkAlX4Z2cXzCULy5J4GO5q8YHF84eUI/kE8X/B0IGAGFVBrss8OA4Zgidsi8OcfrhSQy124+UBRee9YCNie2o1RDHlHOninag6Y63GfyTn0nbLIptJmkzLACufMzMp/W8npYt3pyfftEY3zhMhqMcInbsl1sfsYpSR8fMbAycziC4qhPHl2r+CC9Oq+RT02TSgGs6dmO7L/QJzMkP0etwMXm/c+gJ7Y5HLKC8dViO5pTOJGvvzTtmi/g9dK3CBUC9uKMndywltGJANNfTx6V+ppg7LoiT2i3moeU53vA5VORXDKja0jqisdv2mhiAvIpbaFVoh0zSwtZaox1VnCOYg5vGwCGzvdL1+H3eh9T97B0BfeCFihueiyBVUahsvmPxSJx
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bfa4817-3aec-4fd1-9e28-08df0ceb4442
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 14:21:11.4055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yC8xkHNjrXcLrNNsDsdQGqbYSY35Jv4cE8JT3RP90/26YgF10w45lVW8my01lFDXXYgq3/8Oh1zozafgfd73gxtCiqCn3Dt93ZdENemlCaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7534

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

