Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCE84A4851;
	Thu,  3 Sep 2026 12:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439050; cv=fail; b=gM5OWQq3Ha/G/TaZU89eMmMIhRE8Zr/Lw2q969YZTmK4oSdCvtudaTUHNiozLCRhBJwK2hLzRIEjS/59n2HQeeXKtePjQ2Tg3F/eFAfFWx6Ha4GlF/g1rRCzNxQNJzW49Xt+sUwAbgEiabnmJTY2ilL+OVp6+8sAIAAogCN07qk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439050; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nFKtt49O89a2amdEkuEuAV+Qxo8/r5jcMvyDT/mpBYGC9cNP3VZwh13smxastTtqAxU+ncNuQZ/QhcGB7YbZAgW8cUrzxSBZO+j70r51m4/9Czi2TlgZ4uotz5C8DGVczxHldHzV64JbZPh4ospltl3TgLJ/WDMTXhoz54grWJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Qd/4TSVy; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=fYB0WspZ; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Qd/4TSVy";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fYB0WspZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788439048; x=1819975048;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=Qd/4TSVyqPrW9EagbmivvZHWgKjxRCZ4g1fgMGCWtWdoEM9935jgs/Ix
   6zFvEKjLYZnUbCg9ApVB6lB5SYC7l90R5yM6kK3+u5QODoOSMEYXuGkCT
   zM9SJgRsJPAoQes7c7nMRqMw3n/I6tnndW0LRudKwP9XtBFSgbRmI0NkV
   TH1sG6Jr0+9nD44TvEzNhHLdqV6MKhprbYsmpgSBiNgGsHo00axqW3wIr
   tba8K21XDRf/n4Cwb+F0FKLwpY7yNexZBQsFfnjUJK6cJAuDNl9xIptem
   wKcCxkFl/lztkPJtLl4oga73XMng0xazWLUHVDQxsyfZhMHb30cJgDJqj
   A==;
X-CSE-ConnectionGUID: hNz0bmVBTtGrk8McfKqkjg==
X-CSE-MsgGUID: bMTBHtCMSCuk/99lOv+Pjg==
X-IronPort-AV: E=Sophos;i="6.25,260,1779120000"; 
   d="scan'208";a="150667739"
Received: from mail-eastusazon11012053.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.53])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Sep 2026 20:37:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qnqthg156/X8svJkWbGkU82CCePJME007GnNYzBtqr1/GXSSOkc2caPdjXQ1KFg2f3pwex8eYo8bcj21x5l7fiFluUfRD/Qjy86HA8jgPBlN+MUsVodNQM71AqWVmZ4QccIAZ2Qi/PDyEfypN1l71xVXD1Ekf6wUk3JBdVdeBIC+68CefxR1KNd7b8puhQcOqtk2n0bDjvDj4cRmvA3YEvM3i1uIqEoUQgDIIuOXblAcFkIIJzahE4tIjyfbG4Hfp3oLMS9c4unPqI2G85Rt4OXwg4V8Sbg9cmc5muhQfWF04yvd+p1RbCXqoN6FPBkNOeusQ5Md8xPN6xXciL9Mmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=iFmrdQ1NQcrIKkWp1aegupiQ3EMfEs5qOMgtJbokUjLpMEmXD9xo1lDCFr3fvsG430fffna7zoLPjH4FrWzxOfJ5JeCF5OWBWFkTBgThfbAJXmit+IplKq6E3z3RmwbhvnHVD45zRT7de1pzvswX5RJjYBVVu0rvAgOTgtn5fwVL9Kf93KQd9xpfeeq6MrQsqNCjyamUWU0W2ZHj0nkKzu13HimHf4unrM2Sx/5CxaQWOdvKLmRAu+HaGmteatn4+Ph9mjphEP+HuGgst7GW6JF7Gcd53VUOO30pT6TZZreOaMl8whkIGNvQiNeo0UQPFNkBhzs/nBLuOPM75/7aTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=fYB0WspZrYdwILRcSyiylAHt1iCv6aW9QfYWcThgqYVy9V3kxSymv+DJrXwlKW9vkV4kJ0zoOXXMjFwxH16e7iQ5UdjlsbBm1ugLelBo0bqV8yDmmNNzh83NM4/3VR59ubrwpVGyWvZ53N1oZBb2oTrOvzdyWuFEimo+TyD0hX8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CO1PR04MB9534.namprd04.prod.outlook.com (2603:10b6:303:274::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 12:37:18 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.008; Thu, 3 Sep 2026
 12:37:17 +0000
Message-ID: <1c5a664b-b41f-4abd-98bd-d075fc68dfbe@wdc.com>
Date: Thu, 3 Sep 2026 14:37:13 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/40] scsi: constants: rename internal struct field
 names
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-4-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260903034201.112211-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0246.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:af::11) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CO1PR04MB9534:EE_
X-MS-Office365-Filtering-Correlation-Id: bfb4e127-178c-4968-9f4c-08df09b816e7
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|7416014|376014|23010399003|366016|19092799006|921020|4143699003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Q6HvMwmv/QpHl1wT4NDGfLhZ3CKl5hmq6AE8mYetmQUZ27fDWNceAn612l0igv3cPrkkSL0I838H0f7K61AHxEU7MvXu5xYRYJzt/OmQ0TxYIMZ7zf1uzpBOVBjspzmndtUKw7efMDYmvrR4EmyfqWhrHEztiKntMioYVm+STqA94FFsxsRCnFYYgsP3eVvomLJ90BH1wK4wdMA/u4zFdF5VeN/EKjwNVKkT8aioBkmokUOQgf6gdmf9WJr1FYeCNpm2ZDCURIo7aAC3qQSUavvcSFNHH/lKgK6eeElh+ZEB66DRLFF4kLstaS7Iq+mivNEc3IySnD11nrDa1vmUruXMrXLy6KgTnaXTUJYVlMvKkp2rQHK3mCf3m4RoEemuzQQRpEx0NMc4QAU9KH5wSznohLhyXRKVR6KVe6rMdfaTXutkLJz4aF5SEx6lUSW/BCIYWnFeEfzQoTykYiuZUyZdTIY4DV1SCCirq2LYfGcV/tuZKDYZvkOHTii6ExoMWH4ZJx4r2DTCqwtp9lydPcfNGoSi+L5redah5ReeNH/qKHwMsJLCj1uoc+WhZL7uD8QYc4xBRqPil/sR9Ezq/ual08ld7ENk4DCTuJUNZW4j7QTznJM/NC7GwJ0qV2ki2TvTZVcxwNHlVIb/7umeNqaTxCn8Xos5vwd3QzsV547mqmpX2tOIRUG8OtDflfp1VTKNmI9N/Bok9DAOxRFSnA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(7416014)(376014)(23010399003)(366016)(19092799006)(921020)(4143699003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZCtFMVNHR2pHc2pIbXB6V1FxQk9TSUl1aEtCcEhCaTVwRHpOdnBVMWoxWHZO?=
 =?utf-8?B?K0NKaC9uZFh4enRFSVJGRHZ1TnFXZWxDaXZ5a3V2NWZNcFJVOEZSczBCRSsr?=
 =?utf-8?B?Y2Z3Z3llL2lLTysxSEVXdWNTUDNiTy8zRHpRdDVZdEVhQUgrYVJxc3o0cXVv?=
 =?utf-8?B?NlRJdDlxbm9CVTVHY0xHTWRxYmNOVEZ1Z1lWaFdFRnI0cVBwenRXc0ZwbDlS?=
 =?utf-8?B?OC9VZnlvVytsVVFiUWtRS2pIT2hWa082UmpBdERJaDRVN2Vpb2U3L0J5WktL?=
 =?utf-8?B?VnF5N0NFVnNvanJ0c1lHWUdOdTB1Uml1Vms1akZFcmVFVEpDbEg3WWUrZVZx?=
 =?utf-8?B?djU4S1ZhUkdrUEtTVTI2SkM2N3Jxd0FZTldQMkJwOGp4Um1rTkh2UEc2eC9B?=
 =?utf-8?B?eU4weUdlNDVRRkFvVEF0cHBkOTU5TWM3UU5FeUdXNXNGTURYOUFCaUVWT0hY?=
 =?utf-8?B?QW8yZlRtWWMvYll3czhLbG5jckgybHV6c3pNaGZVNUFPbVdWQ3hvZ2M4dUFm?=
 =?utf-8?B?RllxU0xNeEtHWHptcXRJdGs3UWxrU1NObCtEZVhKVFB5SGFoWjFmUWpIcmI1?=
 =?utf-8?B?QitOMUVlMHBxOXNWaDUwWlEzVEZONGpKQ1BRZDJSUE9YRHVKcm9IUWxnOFo1?=
 =?utf-8?B?aU5zTXNIejJzd0l4eExxSWkvR2ZyZHlFaE9jQTRTUkY3NlJZOFQxS2dPdTZa?=
 =?utf-8?B?UmxZaStPZVBJRStORjNlYkQ0WkJoV2FJZUlaWWlVZ25Cd21PMVF2ZG15UUhl?=
 =?utf-8?B?M1JXR2prQURuRDlpbjM1RkFDaWxIU3dwYm0xaDd6TTZPZ1c5TGlDUzJTWXVY?=
 =?utf-8?B?SkEzMm1CT1RmbnlPdHpZa2JSNU9ZSkVuMkhlbUZFUWlkVW4zWWtXWlVMc1pz?=
 =?utf-8?B?VUl3L09Oem9iR2tRcEozc0NLNzAzSkp5MStvaE53L3dqaW5PeW5tbEcvQ3oz?=
 =?utf-8?B?ZlkxV0JmaWFjQUFrZitHSE9SVWJtLzBOeTVkZzVZeldxb21veUYwSHVpS0Nx?=
 =?utf-8?B?WklaK2prYW44VWtESk03Tm16bEVCVkU5RGt1cGNVaWlGU2pvNDlWUTNvbW9B?=
 =?utf-8?B?aDlKMy9sWXFvQ1Y4eDhrTDVOSDlqTC85K091NVNGVGdmZFM3T2Q4UUh6LzY0?=
 =?utf-8?B?TXExeU1DbWRHTit5WGdYOXRHYWNvelBac1Z6cTZ0ZGlsbjFhVFlRYkJRMmRX?=
 =?utf-8?B?blFIdFZoSVBXd0dmeFZyU0J0c0hnSW9HL2ZwOFJaZ01rVzN3SVNTME5UK0VG?=
 =?utf-8?B?ai9NRHRYcDNhSFBkZVhTbksyd0ZGNDlITk5ZSWVLcGttYmYxeTVBY3Z0VFQw?=
 =?utf-8?B?VVYrV2g1Q2FPMjg3aSszRlJFQ2pkeUIvTEVwUlo3UTJ6dkwzS3pGMzNZaUdO?=
 =?utf-8?B?VmJ6UE1NRHRWclhnUy9oYklxZ2VUZjc2R3Y4Y2NXU3pZTzdtSVZ0TmJBcCtC?=
 =?utf-8?B?a09OT1I4WThKSHBObFZ2OG1KejNhSTFBNWRxUk9EWHZkd04xTlJabmI0MitP?=
 =?utf-8?B?YzBucXZ6VXJidEFQWW8yRWgzT0RtSndKVmxBdnJLRldWRHlBUmJReGhJK3dq?=
 =?utf-8?B?UWVBK1lQMWY3RENTRlU5eGlsRkdzeHlXUEJPMnFEcDNhSVZzSTVnWmdraFNT?=
 =?utf-8?B?SE9nVVZHSk5JT1AvOFVHS0lUbW1lUkFBbWd2SUhpWG8yUUJMWS9UYkUwUUJR?=
 =?utf-8?B?NGtqQzQwTlZoWVNPRmgvK3dIRUJTVDJTQnJ3MUlFR1l2V0xmSDNFaGh1RkRP?=
 =?utf-8?B?WDV0Z1YrWWl3TFcvQVhkV0xpbzNXYmpxNHNIekF4dlpCalZIbkFuR3RheERT?=
 =?utf-8?B?eGoxd1cxS1dYTEkvQnBhdkxtYUs4REIraWh3MUl6ZVZFWFZQdkZDMkFPVTZs?=
 =?utf-8?B?bjNvR0twNWM0eE52QnBjUUtPV205bnBnNnBUVTJlR0lRR1FMK1RjQTdndUMr?=
 =?utf-8?B?NWhzM0RsUWF3TnN2cXJobnQrUVdxc0FNN0NUNUZlaWYwTDBTVElWL3hwR2Nw?=
 =?utf-8?B?eHVkR3hRN1JDWncvLzJqcUpIOTRWcDQxa3BKRmViV0RCeVovS0JYWklWbENW?=
 =?utf-8?B?eU9odGhNUlRLM1didXZLb0RvcGJwVGtRa0djSmwvb3VyVk54U3ZKM0srUTBm?=
 =?utf-8?B?WjlHUUdyRlJPcXlkbFVpdXdvNEIrZDdDbWJhNmFmaHM3ZTZSTVVmL1B0eEJP?=
 =?utf-8?B?dGxKQzJlMU9nL0pZRTJJcHRERkNtUUlPcU5tcHJPVSs1R2cvUTR5TDUzNitF?=
 =?utf-8?B?dm9JLzlIbldVUXhoZTE5OWRLTnBCVkFBSGl5aytoYWcyVlRTSXROUGJ3SjBN?=
 =?utf-8?B?YnZoSGFyUHJybUpFZTlmd1cvRUUrK2taVnNqMzBZeXhFMnlaTEU3Qnd3STQr?=
 =?utf-8?Q?2TuIRMqMjkuLVFwWj83/fGNWk4tYLdKw1lm8t66WCuXY4?=
X-MS-Exchange-AntiSpam-MessageData-1: L0eZM4wguWH7nvJuQVAvqXW8N9dY+1SIyl4=
X-Exchange-RoutingPolicyChecked:
	cXtX8Q/7Eveu89traV77juJIPx2coLOqyVOl1Khlqt/UM4uapUna9eJNBB8/et05WWUlILgmfeRfTYMSPluYVsE52337gePsloQUCupHisdUt8/bH/yG84p1/R7RtPaW/DCajynN5bKV1ZIkTOhC1mYH09cxzZlOAbhmuYXJaLHAy8AN06jkR6oqrAotH9r+966lBaW6ULcACZHlvUeG3xb1Gs4W16ws+MQWbCXk/3YY6+ULjYs/UqXOBPTYmZLCtizJVE0j50DWpr6Vyol4pNnhzhbl74NPJkl0OXwEpGHIYx+Pp6eLpNqusaTPo3Fe+iqr6gaijSeKR8fz0KbH3w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Zs7e4WYz26Bi47qilBh3Eylehevzq6ieulk5tK3txvOs1pJe7ATYFjSrj3ulFrDz4hONh3sxOwszOy6uzOM/5kU/tH/RtBGHz9v7gU6fi6OfyYmhRagNmlsmtRddnwtPMWpiDswGZEmvyqp+RTnRWC0y7bmA9FTkbaxd2pVNMyqVzc6tcw36VdKm4x7eqC1IdN5jYM3ytU/kZbA5kNg2RpNmKWmNH0864eTYi89bkK/1GlspHN+5iof9779XK3DosTG1V6hNfPystXDTgia1G7Ko/3Coi7E68KO/kOk4ZtiTTsxGlYmuB9YcGUcmuXtUuU65pmiwSf4e5g70f7iIkr+lht3zNo8nuMiVTWMLA6t3udjeodyvnBqcqq+A+XN8awj+Cm6ByRqhXFoFvgf5VoAIvdYiWn0wgmKWPCYmNFcTJQZHojsQBW/H5Yb5zohSWLmS9bRh1isFv0G/STKBFp7tGwn7qOvkXUYKFJ/vdbGSn15RTe4pd2Vs5p35U0QrUAoUDK2UzI5c8j5o2/lCVowEeuiWZWiBHmYjIfedVv5qlanlr4M6LBPFZOnSEvQRlmkxUd6Xwqixd7s/yikxgKLgbiV2MQ4OZsNsytD6OxAhyW7yhJgvUmDij+JkFct+
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfb4e127-178c-4968-9f4c-08df09b816e7
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 12:37:17.5007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yziMWt752/2/LiTJefwhuJpQRjgC5EFAhYTGhIcCA1RxV6DxfHpdYx7Hxf9YUWeGMcG/AljNqUYYTaKid0a/Ssmlswvtw4RnJjtB34yEFio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB9534

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

