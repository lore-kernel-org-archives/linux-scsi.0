Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF8127F4CE
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 07:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758870874; cv=fail; b=CtX4pwIPAItzLb38NYjf33W55FnANUafEheFx4kGB6OwWKxVLEtWg+nEBmC8z/vneUBOBNHlOgFBYd+9SgWdu07soQCLAgzY5XkBZWJ08HmHBmIMhr1ZyWgLpkoXoexODk9u/ByxuK2HdiXpwhheb4vTmXeTHQ42fL5mIVClvTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758870874; c=relaxed/simple;
	bh=d6uhB/Kj0zU0OCM2q2lSk3hFnOjxJXBsAix3CzEH5oc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nJG4IUIfttSPuWnjhTP/JcB8EZXwetsp9Hl0sykrZp+2tsirxbK+dT+0UWoldTD0DXwgtAcxKbpdK+wkj7t9veNAB7zkjO6YJKKrN+J4Wkh+JymDJT64oqaVp+yF8mISxgcoms5jMiDBjCslHmQ9cE/dTPzPYTKEuEFn6fnNN2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Xdqlp/we; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AKSAu5+s; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xdqlp/we";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AKSAu5+s"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58Q7AKl4028691;
	Fri, 26 Sep 2025 07:14:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=t2k9+TxopjC5kN4/evr9Q67gAXktDYFGikOrCtQSE6Q=; b=
	Xdqlp/wep681XNzFQ2TMa3XWuUzqnxtQAXp8impkFttjZIOd8GGe31bfT+xSeaMU
	4fR7D8rA0zFt69ImEmCi4JQf6iehktH5g9ZziSwG9DX56dOTCRXoOZ12iK3IFIqg
	nC1Tb2wzrz4ykS0v1g+dqZeIALCUbDFg82mmuG6pnJFzTLyG3c9S2HGZpHCV9vyL
	VIg43+pqcnreprKk+oBCq9ikVMuEUivnaVp/uVqR35shr42gqpt1uKCI7cSuC7xh
	qHHcEXawBUjzYDg83y0GoKnDZ9iKWIjwzldSBwWeuYOwZ04s9gP0p/uRgt7vKqvW
	Vc/ea/SlySp2IeONn1D68w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49dp6nr08e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Sep 2025 07:14:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58Q6Rdgx021521;
	Fri, 26 Sep 2025 07:14:21 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012053.outbound.protection.outlook.com [52.101.43.53])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49dd9cpuhd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Sep 2025 07:14:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H0ylyYxy7zn00dwzREMhgw7v7CRq4NWuZlcnBCX9JrRheC9P7mqpQfWhJBzVsfpr+uyq4uv6OdaOcvEYI5LUzjTtlXylKjuVwNskk+Zc1P6wISVdX99qrN0r3DouWdVgV1bD1+JvgYzidMupUpXZ/kemg6kJy2e+RqWtxJdMOVvdSV02R5abQSks4GWvJkIyzVvJGeGVyghKDpzNH+HWjimsfF0gSzBb4mXdfkDPxpQ3Tnfn4XR3tma6MvlH/fg9saQoUsX4m/QgoF5vmRadpR2co3GgDiQJUP/ulWrxTMuhWAo0SFsqoysd5INvAEIfaG3vhNaf4mvNBlCNlCvlLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t2k9+TxopjC5kN4/evr9Q67gAXktDYFGikOrCtQSE6Q=;
 b=y4gaYAgkzYc0/+5fOStrJfTMAG+eY8eNT3qKRne8GSHNn3Nl3YvDMt1Kdn14To0+Kc3upBvaHKxJj1JX8smXA2/x2dscTbLK8+anKFx0WkhPeyM7/Lx4Ws16GR5pSuFMNYqm3YnUcEGtAmoUhwy3RQD6HRHA2L1BWuF6SFx0CIPE3u/NW0UrOz3jV2mDdtWimV1WkN4NACEfLoBr4KCLCsD4Y5AzIYD0SIn6S8fQz+pFqNebaMy9R5QvRoxUGEhw4d4kumEkWZtCpQE9BHvQUXoBpq7vP84+PWdG+U1LyrxwZXWxZ7dXiZiYaruQ6rTKx1mkmh605CNw8QykY3MsvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t2k9+TxopjC5kN4/evr9Q67gAXktDYFGikOrCtQSE6Q=;
 b=AKSAu5+sIbZaELDP+BfObt1cSJEaiMQZLvspC5w5HyuW9x1KWiAoalsLgB0e1f0N5rK9ljWm2Q9ZlOv7+RZ3q8jXs0HToHsz4+T5Leti+aFq+Gw+dx3NSXIfb6vxIZlEDD6d+sc2/8cojEvERI3gSBdH7FQnX+kLOeu4hLq5kAk=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by LV8PR10MB7725.namprd10.prod.outlook.com (2603:10b6:408:1e6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Fri, 26 Sep
 2025 07:14:18 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9137.012; Fri, 26 Sep 2025
 07:14:18 +0000
Message-ID: <bf28fcc4-4a5a-4a14-bfd3-8d72015b9b0a@oracle.com>
Date: Fri, 26 Sep 2025 08:14:16 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/28] scsi: core: Support allocating a pseudo SCSI
 device
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250924203142.4073403-1-bvanassche@acm.org>
 <20250924203142.4073403-5-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250924203142.4073403-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0492.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::11) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|LV8PR10MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 0521c2a2-5f68-4940-4406-08ddfccc4f01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?KzQ5Z2ttLzhzdnFNVk9LVkZkRVZoSGdWeTA3WXdqeXQ1QTQ5NmxsMENvcXdG?=
 =?utf-8?B?T0N2dnJOYnZqNGFzQW5TempNeGJubm5EcXo1M3d2NGdoei9nMkhCb1JRQk5o?=
 =?utf-8?B?U25iSWdEb0k5bnp6Zk1UbVFvbVhHZGw4R3dQbG1wamh6R1lXdjdIVURxRWE0?=
 =?utf-8?B?QVk5NGxVN0hvQ2w4a0NCaStMcURRY3ZCcndFVGFXQVlhZ0JFdkdlVCtmSTF1?=
 =?utf-8?B?bWlaOTJ0aXZZdEowdkV1UkVtTnJaTExPcDdsMWI5eDQ5Tm9QN2RIRDBGaHJO?=
 =?utf-8?B?SjRJa09OWXJOTkFjSzVZOHUxTmJjTEZpOFdLbkQxYmJkNDRGZXBKQkZ5aHI1?=
 =?utf-8?B?THNXM2RZa0dENGIzbVlpK1d6aUJhcFRTR0pRdmk2Vjg4OXI0OFQwcVBvdGU5?=
 =?utf-8?B?ZmxPclB1UEJUMGwyVmFwRFh6L1ZiWjN1YWFuU1loYjAwWlpwNTV2TjJlMlU4?=
 =?utf-8?B?RzNqQjBnMUlPTUtoSTVSdTVLalRieFhPUkt6bkpDM3VIMWw1aVNzRk5uTm95?=
 =?utf-8?B?cVE3OU9ha1BDYmJ0YjFEWDZiLzZ1ck01N1NuVXhlUFVRbUFYRmFoMnl4REc5?=
 =?utf-8?B?TU5sRW0wTmwwQjZmbTJrZVdHcGVySEpzS3hpdXhFNEhkbXppdFJtSyt0aXBt?=
 =?utf-8?B?cXAxV3BIRkxscm5nR3lKZml1dk1tWHZrZU9vZ1lYWXFuUEQrVFR1OHU3em9J?=
 =?utf-8?B?K3lVT3pRSWdCTXJlTU1udThZOHRmeUszV2FzcTB4T0ZCV3JvQ0xvS3pmaGFo?=
 =?utf-8?B?eEpyMFBYMUUySk5UMmVYQkVDelJtK2ZIRlZ6ZnNKbmRpdDQxM1lhL05aQ3F2?=
 =?utf-8?B?ZjhaWm5NRTQ4eVBUeVdqN1RuQWlCTlNicisxSlpiTDRpNmZJQWVOS2xGWmNP?=
 =?utf-8?B?QjlTNHoyR2VudHlLejVqdWtDcEpZM2JLS1hTS3QzVzhTZ3Z2cndUQ0JGK25w?=
 =?utf-8?B?QWowRGdqUDl0NWtOeStrRGdxcHRkMEhCdVJBcmluWm1oNTR4RkNpd09PNlJL?=
 =?utf-8?B?QWlQK203VUk2U0EzYTlUQjh2cHNJczc2RC9ReHhFWll4ZEJKR3Vwb25oeGph?=
 =?utf-8?B?VmFZbFl1VngrNUpVRnRGMFQ1RmJNMWc4NGh4NGNFSVdwd2dodzE5WHdRK3pn?=
 =?utf-8?B?eGYrdnBxaHc4VDI1d200Zi91UGNJT2tDQURhL2hIWjYvcnIyT1RINitIWVI0?=
 =?utf-8?B?MVBYbzd5ek5weGhiV0lsKzV2RjhoSTJRT09FaS9JZXhMSk1od3JCVTVaL1V4?=
 =?utf-8?B?cjlJSTI3Qm1NS1QwbURSS1IvVXFlalBadDBrQjlHRndENlVHa01SUUR5cERY?=
 =?utf-8?B?WmVET0xvSi9obENLQUkrSlBUQm95NEdOUUdxRHBzYW1nWVYrQmc3RkhMWU5E?=
 =?utf-8?B?eUZqZXJiSDAxNWt2b1o2aWJsejlubEhXM2U3R0F3aHZtUmhPYkJWdVpvUExn?=
 =?utf-8?B?V0ZqVURkQWJ0VEVmVWpSem13OGVCTENWK3M0MVRuVHpESGs0NTBqVGdVellL?=
 =?utf-8?B?dU9vdlI1RTlxU1VVWFJMUk9URHJPaUIrVElKeFlEMG52NVByZVJDbW4xclhU?=
 =?utf-8?B?SUx0TUpMaFZQRzRxOEFMTXZCQWlpVk9tQXVwT3kyK3Ria2lRZlpvNTh5RVpK?=
 =?utf-8?B?Tzl5d0J1NzBvRzFsck9WSjJRbTVOK0hVRDZnRUlPUjJVaFpsSnZhR0hZTm1z?=
 =?utf-8?B?Y1VpeWM1ci83ekZvVUc1ejJ6SkszbnRURlY5Z3oyWHFBeWJiN2ZRckJNVUZF?=
 =?utf-8?B?TFZnSWxKZVA0WHFGOGVZYUpxMytWTkU3QXczMEYvMUpCbDhPUFhHbGtoaWJC?=
 =?utf-8?B?QnZBWEhhRmdoV29ZQmVVZnVNNks3ZHd2MDRDVXlJSHJkTlRQRFIyTHhVR2FZ?=
 =?utf-8?B?b2RkVFg0SE1mMEdWdVR2YmdkUW9ZTmdVa0ZsYktDYTd0R3M1dEk3bExmcEpJ?=
 =?utf-8?Q?yDc7F4HMKvZwu2IhhzKACgjVm4RpfuCi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MitrOVllUG8rNnZsaDlzTmtEejlKUzh3OXF0bVVWVWtlV0ZUKzZIQWNCcTlX?=
 =?utf-8?B?MVRtVG5NMHlJRU5nM1BDdEk1QjdWOGEzOVNHY2FqS1pmMjlseDRFcGJiZllC?=
 =?utf-8?B?UURodHltWVNDS0J5SnR5b2hVM1FCSUZNNkp3eHBEQUREMzVxQU9RQk9sM2g5?=
 =?utf-8?B?dnFJMTROY1ZJSVdWVzNWYUFCSDhmNlRZeVdyYVJRNEFDM1dtUzFpK2pKamhq?=
 =?utf-8?B?VUJjVDVTY0dGQ2ljUFRQV3FFd0ltQmdNRW1pOVNVNXNIM29RUXdWaXQzQmJC?=
 =?utf-8?B?R0c0WmpPYkZYNlB5bnNMV0gyckdJSloxWDBiTTFjc0VxdUVsbDNaeGR6MnhC?=
 =?utf-8?B?bXByTkdMbFhrN0tqU3FPMzNLVVV6Q01Ja01peUNkaVJJM2tJNWxMeTZUV3Br?=
 =?utf-8?B?d09JdmY5VU9DRS9BN1A4VC96ZFBua2ppeFdXanBKQ2IrYi94eElQcWUxTG80?=
 =?utf-8?B?emFiZi9xRGxiMTBBUlJqM2dlbmxGQVpEN1NuUlV6S0RXNGRNcEpxQkZPZ0p2?=
 =?utf-8?B?Y1ZMaTdLTElwMEdmQzNzOFFBTWsxdFBYbXNmL0U4QW5ZTlRMdUV3YldhYmZ3?=
 =?utf-8?B?SEJkbVdSRTZJdWtqaGRDOEhEdWM1WWxMdVg3UTUxalNjZHVneS8wcVV1c0Zo?=
 =?utf-8?B?K2ZCZUVJY3BqL0lldmJFWVdVdGl1eHd2bXhjU2xvTjJHSTJScUV1THUyd0dQ?=
 =?utf-8?B?aXNDbHI4UytJYlRvb3BRVnF1Z25xRTk3VlBsTytTNWE1UDNkWDAvZUJGSXEx?=
 =?utf-8?B?dksyZlkwei9SeDZydzRma0ZnL0x1N0FlY0VBajYrU0pXZXczM241YS9Kc0xz?=
 =?utf-8?B?QmxBVExsd0haTGVjOS8zVkFBOTM4TEQ2OUg0S2pBRUE5OEZYeC9KeTkzVG5v?=
 =?utf-8?B?VUd0dWFFRFo5NDVVTmYwd0dnRUJlYWpJMkVPR3FaYk1tV3JFYTdUNmJnS2dY?=
 =?utf-8?B?MkE2MWFIWEZiUEZyMGNEK2grL3FNbFRscjBnK0haVXk5S2h2QitrbGRhS28v?=
 =?utf-8?B?NHJhZlBWU3hVbFBCZ3krcEJNaGFxaThxU1ZGdnFkSllmMVhaTFU1T1V3YVhU?=
 =?utf-8?B?cTBPdEhjY3hCODFlRVNITS9LdFlySVFoME1SWGNRR0c0OFVIQ1VUSGNWWm84?=
 =?utf-8?B?WUJabnh6cHBYdEE5RlVlNTZBOEM3R3QwZVhid0RvYitXeU4yWmlNNDZWSzRM?=
 =?utf-8?B?V2Y2NUZXNkhTRUZOOEJ3dVFrU2V4QzVnd0UrUHZxbVNCZUdTY1gwSVU2a2hp?=
 =?utf-8?B?dWlOTU1wMk9idlBDMEFZWUFhZmIzcDRDcmhzeTQ3c3JOYndBaDBhUE1TUE9n?=
 =?utf-8?B?MDdYbG5Qd2lJWmNSSytmTEF2UUI0aXd0elJISDdjN28vWWIwQXpjQTVBdERv?=
 =?utf-8?B?MmtGTEh3TGFrMTBjcjhOeDFJZE0weHg5ZG1sNURqTkNvdFdtTU4reXZ2eDBa?=
 =?utf-8?B?M0pXclMwdklrTEpTSnpsaDc0azhxeXFYNTZGMjhUUlFmdDI0cVhUTnp1Qk5P?=
 =?utf-8?B?L2tKanUxcysrU3JIRFc0WldpRnFtMitBVHlIWVVscjhORXllbG94ejJiSlIr?=
 =?utf-8?B?TnlpV3pleHJJTFRKdUZUaHFaS2J6OWNVcFI5ZlBFMjdXQlJsNVFOT3o5a3A3?=
 =?utf-8?B?OTZTcVVodUpNWjhJRVloTnFQbHV3RWhiNFRDdGJQUFViZFlrZ0xacEVVSkdB?=
 =?utf-8?B?L1FGQnBqakdVWXNuWUxCc250WXVoRFlyMWtlMlNQcTZtcjJBdXN5NGtxaGZJ?=
 =?utf-8?B?V2dDeENtelhWVzNtcUg2dXRnb0tpWFcweWhTMDBWa2M5a1N0Vmx0d3BXQkIw?=
 =?utf-8?B?RmplYURYSFBRL1RjSDFEamIzcUl3QzFlalNVVDJSVHprNXpEZzFuUWtGdlpk?=
 =?utf-8?B?a1ZPV3dkWmNxdmdvb0ljY3cxVG4vTitXcktzRTFnTUxkclYvNG0zRStoRVlJ?=
 =?utf-8?B?TUREZUtlblNpV2tQMmV0SVBBWU5yc0xnM3pXZkJWMHdDSlBkT0tSNjNZa20v?=
 =?utf-8?B?M0FkNDlsc0dnNFpJNHp2SjcxVkZvczU5S091RnJ2WHROZm9nTWhKaCtzRWoy?=
 =?utf-8?B?RjBRMmVDTlhxVjhDN0tLZmhyVW1ncE9ZdjFEU3lKcW81UFRiWEJwNmY2RXR0?=
 =?utf-8?Q?pVjszQFcZgRNW9lwiyU4WEGif?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	b8NWWgHbGbfDkEYaxbat0C7hwhJOaTV30qOyQ0BJEcdh7nviocQfsmf4LyG2r6i3Bpu9HtHPk3rBt5LB2VntKC8ZZJgkbc1LhnUXSuar/zJ9FNCZtLoxnHcjSkeY4sK12U8K7HNnweV6cRI6MU59PBW8xcoDkcPIL07qM06DFoffMJLnPzyDGm9ZW1WpxdPqU0+wXU0qKD3r2v41TXqwpyJFg4qFA69NxNkajNfCvQvQ0CNQVRedG2E0R1KCY+WNSv6T1P5Cthx4Jg/3uJAR6o6n5Mo7loVBYWeBGW5Fd/08Q2V2jEQbMfbHqUFdAtq4nsorDd+K8G1dYlSY50KZIflDT/2vdHViQleonrM1mkQJkJkESNHJ8a6kJDb53pKzly0lkZyrtNTod/RQKtx8Sg4cacbrpQV84gKM/zn65GBnQRb6JGsw6XWDi1gvJT77Owc+Rb4Ga2ZqriTW9tWzT/l8hLDneF7N00DJdgA3izLxxz09hZV0zxyXHREYFJEx4HY4D+I7Zc1Vwq9XmguBQJI5lffCNX5sjq1U6l3YJSSOc4OqVGxW5h+4uq1UgyuhTR8I7N6szQMD3xsFGr5xx1XulHP3msJvBrPRcY6OTRA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0521c2a2-5f68-4940-4406-08ddfccc4f01
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2025 07:14:18.7813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8CljkanbwKQrvpfya94WDS9oKZzMqSZvq0zYUYOGxghgivrtQzwq1voO22bL1McyDLrXSc8pcHxcr6Z/LWorTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7725
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-26_02,2025-09-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509260066
X-Proofpoint-ORIG-GUID: 9fJ72pthCYrjo60aRmTmawUi49gd097v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI2MDA2NSBTYWx0ZWRfX1kgEfVGMRO+9
 LWgtwJeXDYB5NKvfRLuQ9Ur9YMCds5Q9BbDx9Xka9q0k/0R+d2xh3xsClkZYp1/twR458UKZFQb
 l5+Vd05PWgK/VXPE11ija8BjzkrL7nexv/87k4LAYSOeOEUaJHHdROax/R+nIkpIMSenukv5+8n
 KvO3+ms48KRktlVw3JWMwtDMmqUya0pO0NOGSkDTbBSsC2wm/pGkZiG7E3fvioYJyqSFVH1Ocxi
 6XXgkFPIioTg2RYOR0rlfgN47mYF75VEEFwcH4uPV9dewWjoZsSqIZRR2ecFvuu8s603GEPd/pD
 xKa41nvajQdZ2/tu9Hs2QEJNOjieyzLA9tR8loJJw7jsheVy1CDWooSaBGIk+Go/CONt3OEsKwL
 1GWeT2jomDdyWuQCWsK0iqYxOG/bYF+UsR5voM7xI74NEedtiG0=
X-Authority-Analysis: v=2.4 cv=ZuTg6t7G c=1 sm=1 tr=0 ts=68d63d4f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=i15umPWeWrep_rJKmwAA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12089
X-Proofpoint-GUID: 9fJ72pthCYrjo60aRmTmawUi49gd097v


>   		next = NULL;
>   		list = list->next;
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 5b2b19f5e8ec..da3bc87ac5a6 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -135,6 +135,8 @@ extern int scsi_complete_async_scans(void);
>   extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
>   				   unsigned int, u64, enum scsi_scan_mode);
>   extern void scsi_forget_host(struct Scsi_Host *);
> +struct scsi_device *scsi_get_pseudo_dev(struct Scsi_Host *);
> +bool scsi_device_is_pseudo_dev(struct scsi_device *sdev);


this is defined in scsi_device.h - why also have a prototype here?

generally looks ok apart from that


