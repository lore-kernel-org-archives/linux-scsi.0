Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D242F2915
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 08:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762937636; cv=fail; b=sKlIUGg9WvSvdNygSREbwAdUvhLYH8ZRLeMiKIIDZzjx2d5IHugt/ZPtyqQIaB5s5sAjwdvlrByIRMX/Ui+419PjSdFN/UCgiX/XTm0t+xtrnjX7Q+auNjtqYurj/rOSxtw2K7MeiohCbAXaJxS6uuMwiU6B5gqQ5YlXiihsgFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762937636; c=relaxed/simple;
	bh=gXn46WzyKh9sYFEdTOhRfplobsN4XRN5ChJ5MVojIaA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MVaPvOucFyw0PrcCU6OsC7muY3jjKVXy7asPRtsG4nQ2KsXwLexBgRfeTiFTKPYOua6Nx6Z3dpR+G+hNXu52wUeHt7cUKtc/nCwmAVXVcM8nXdKfvsE45L7d0hMLFjc43db5CqLIAR04zm9+PBQQLs46gTbB9eyzSgb45LeR3KQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Zd0O/uVB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pGYiH/8r; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Zd0O/uVB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pGYiH/8r"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AC8j1Q3000331;
	Wed, 12 Nov 2025 08:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/6vQ4SmuG2DSyjQlilpg/4WWabWZYiLC0wjggtBUV2A=; b=
	Zd0O/uVBPnerq422did55O5aAKo074yZx1FBR/sKc8j4iKoamU1vLgNXIjG3huRs
	3n5Bav5GjPkb2Q0WREo9TD2aQJPhDvHTw4PmB56Kg2ZpjH1niMTkZusHf/JtiHnn
	CqeLqDeLYmoXToethBQT8P9VkL/c9KHgM0X16zrocLdJ4fwx1Znvc3bxB1UV79bl
	G9o4YQ7PrOaRmKspFegEEhAL8QjabIAcXSM4umjMwM4WDQiR3qQ9NSKRpDWPcdQ4
	hpN4ZZxdVkUg3n8gEsdxIlZUxjX35jPBdR2UpXqg5VcsLILSyp8nJccn7QUXbg4d
	LJzfJGl7cX3ZgXgJjDLwOQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acq0jg0u5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 08:53:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AC8kGZ3012621;
	Wed, 12 Nov 2025 08:53:38 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013066.outbound.protection.outlook.com [40.107.201.66])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vady99t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 08:53:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iHhVhhFHyxHLMeS3U3MZOaibIheWqu1zb387Y8nFVPU05ZlCTI449G1g+0R1NzafzQxo+/1Duq4v6OXGlLF/pfQtKTy1OfsdGLo3rjQPuIhzyomTFlayMTdlrEUwjZ+wr8XrwJuDqBFdU9Q0bWJGdRqc10r8JZJ5TEgWRu4HyjcIajoALChwjNwxbySAvKJBI1zsKLuqs2RamLszkACEs+ItHgf/XnFUK5hoMt6yQr/MH/d9Hc5f9ORzCCgRTwYnJycg18pOA13YepfwsPcyNA5gxRvszGgm2Szu7+0CXoQv5h+Jr0yUVQEQ+FgzkFrwMzaY8KUFKJdNHea6EQJzrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/6vQ4SmuG2DSyjQlilpg/4WWabWZYiLC0wjggtBUV2A=;
 b=WTiN8fmAJQFpxk0HiwcvUsHF8ZOr9SawN0VEVT5eKZMSRvtIWm4tTmc9mz68CYQRhInX4TgwdgqqBLa3nVZV3a+W3GoOpe2FihMyUeZofZfk9l7XmvD6KA4UDLbA0PFnD7v6OAdU11Mpx/lhn1COmjb7x4gVaXQwIG4CgtAaZK/wkksSktsKliE44IR9mOHS6TDQfO6q7oBCQzvogtI++PAxqPMm+aYNyPEDGb3EVTH+RWRlNEfXQFffj/sujrm4o59yR7SL5y2I8OFMRgPQ0wMEniKavnhAG/vt67H3flrnmpGV9W6kajW86MdIerUzLb/Xndqv6BqHwRIxDJuMgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6vQ4SmuG2DSyjQlilpg/4WWabWZYiLC0wjggtBUV2A=;
 b=pGYiH/8rje8STF/YWV0ILFNldETi/CpC7+K99PGnEo90ckDmWLs9sc9zLArfooBqUCgykguD/JyTSbKNaRdIN2+Wa+yY6c17GNrG3QScfal7sgWDJAlhueJyXV4QM5GuWvP+uXjeer4rrlNFZZClSQg9kJDyoq+lu/hCNTJHlIc=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DM3PPF97BE3526C.namprd10.prod.outlook.com (2603:10b6:f:fc00::c38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 08:53:32 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.015; Wed, 12 Nov 2025
 08:53:32 +0000
Message-ID: <be49d9df-2738-4864-839d-99f24d77a058@oracle.com>
Date: Wed, 12 Nov 2025 08:53:29 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: scsi: scsi_debug: make timeout faults by set delay to maximum
 value
To: JiangJianJun <jiangjianjun3@huawei.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org, hewenliang4@huawei.com, yangyun50@huawei.com,
        wuyifeng10@huawei.com
References: <da25e95c-8895-4a0b-ad7d-9f88f58a91e0@oracle.com>
 <20251111105902.277-1-jiangjianjun3@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251111105902.277-1-jiangjianjun3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0514.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::21) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DM3PPF97BE3526C:EE_
X-MS-Office365-Filtering-Correlation-Id: fe44b541-7db0-46df-a024-08de21c8f4be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SldOUzRIQVgvalZ2c1dad2k3QVU0QkNYOXlJajhyYUV2L0JtV1R0RE9FRzlu?=
 =?utf-8?B?RWYvaWNid1pyWSt6Zm9tRUxlcU9YUE9vS0I0eXBHS2NqanJud3FneUphNHkr?=
 =?utf-8?B?eGU4UkVjRFdIYUxUMVF0YXBFUFQ5Z0wwWVBZdFlSSXJoT2I2d29yeklzQnFZ?=
 =?utf-8?B?M3JNZVJqam8zZjR4cEp0Sm5qSGU1a3lVZkp4Nm9QQ2JzZG1lVzNMUFRJeUdG?=
 =?utf-8?B?RFIyMk5mdjM0cEdDR2JFZ0xDQnlpZFRMdmU1RVh3MUtva3A3dmZRYjhPeFNp?=
 =?utf-8?B?Tmd2UktNMTgrZy9sVlh2TDVKZnp5dy80SnZMMmNoZkxlRGxYNW1DeWxZaXF1?=
 =?utf-8?B?cmF1RXU3cldzOHVKb1VOaXMvd1F5L0VMSFNublZiYnc4Y0tHVmdPcWttNzM0?=
 =?utf-8?B?bnR2WHdoUlNhaWRpY1BkRzJYNGVjaDlNTW5meGMvV0tlSHU2d0RXYXhYUmdF?=
 =?utf-8?B?MWNaQ0FsT00xQzBQS1hyKzhOV1l2Q0RZYUVLSXlCTEVXbXJSaWpVbThwd3px?=
 =?utf-8?B?OGxBNnhTbnpXdW1TWTlpSjhobnFRZnBtbjNVdVBjeUQwRm5SR0llVVd1UUFz?=
 =?utf-8?B?aDdXck5OcGpucFZsb04wN2VxK2xiVVJEN3RwUnU2aU1Lb0FBUDVFRjI4REdE?=
 =?utf-8?B?aU9PSlJaWkc1SE5nUTNxeURaWkV0TTFzblNjVHJ6Ty9sbVNUNEFOSlJqRDBI?=
 =?utf-8?B?QUJMUTNXRWYxNlF3cnNoYXk1cHFydWtPZzg5dDM0TTFGRG5TSGJJWXZuN2c3?=
 =?utf-8?B?UWlZajZIaVdSaEFjeHJYZW91TmMrN0JuSG84ajV1bTAzUGJDdmV2UzBoME9J?=
 =?utf-8?B?RU1ER1JOME9MbHZoQ3YvbkxzRE1ZYy9pQ3ZycmxhYnBUUDYraWFEWHdCdlJa?=
 =?utf-8?B?TldWTlNYWE1BSU83ejhudHFZOUI1aDM4WWl4YTQ5YW4xcTZGUjFrWURSSlRW?=
 =?utf-8?B?SWk5dTJRTVlhSFJuUVduVGlld2xycGJtOXh1QUg4TDRrY0IvQUs3RUlma2tX?=
 =?utf-8?B?ckd2TU5mV3NjN0xSbTdDdzJMVGtURFRJempiL0g1Q0l1MVhGM2ZzL3cyalQr?=
 =?utf-8?B?L2gxSUJ2UjVBVnd6SHhiTGJkU0Y2dFQ5S1lEdHpCVmFkZWNJQURUZEJpdVJG?=
 =?utf-8?B?TWFpM0FTVFFjTTFTbXRiTnZyZjdmelNENFVtVWlncnNEVExOSmsvZCtuZk8v?=
 =?utf-8?B?VHBEM3NGbFMwbWtUN0NnTlBlWkJVTHdzZEhsSngvaVVLSTBYNmJxUUJWNFlu?=
 =?utf-8?B?ODE4OXFrait1dUR0Y3YxNHhYUytlNVJPcnZRaCsxZUtmOGErYnU2a2xTK3Vw?=
 =?utf-8?B?cmROenBlNFJVbXhTYmErUVhuQnZ0KzJhRVJCVmp4YkZmdzFkUHAvWGRTL2pI?=
 =?utf-8?B?ZWlRR1hTaTc1MXpyclJYdit0M0lrMTZhbG9FalUvRlRIT0ZEZGZzczhNR1U2?=
 =?utf-8?B?UlE4cGthQkw5TDRtTFhxYlI1OWdlZnJrc3RFV1RXUk5KcWhjMm9KVWczZjNZ?=
 =?utf-8?B?V3dZWXpSRzM1S01YMHUrRjdhc3g4RFhpWU5kbnhNZkUwbER4LzZWbEs1d1o4?=
 =?utf-8?B?RzluVzVyY0VkSmdnVDBBYkYzUHpkZVg5ajJWcnBocjB6bEF3ZkFuNEhLYXBs?=
 =?utf-8?B?eUNrL1BjTGd2cEZ1TXgwRkpub2ZGclpBZ05vTW4rRHpIVjV5cmtITHU2NnNI?=
 =?utf-8?B?a1hUSnM1RFBWSW9EZldXN2FWRGlTWXRKK0p2dUxsT1p0ek13YW91NG45QnRV?=
 =?utf-8?B?R3pVS2xPL2l6MysyOXBxTTZMald4MDd5RlJkdlZGWUN5UTFEN3ZJSHRtWGhL?=
 =?utf-8?B?Q0VZVDFQZ3B6K21vWDdnMkc1dzB4ckpkNWF6S0tOYWpZWGdoZWJvWDlzNkZN?=
 =?utf-8?B?SUdxaFlabHZZT2s5UDR4K2xYemc3aUlWVG5zeWd4Skd0V1FiK0s3WVUvZzFk?=
 =?utf-8?Q?ybYlUP/AgFo9EDwCEAerMB3//cdNmWoF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WDZoZWIxbjRHKy9HOXVlRmhuUXg3NCtYTyswUDd1WVUrSmc2cmhzekdXclZz?=
 =?utf-8?B?dE5TdW8zQjQ2TDk4SEhQWFZlWXJNaWxzbUdGN3BJYXhzVHhNSCtaSDRYd2Z5?=
 =?utf-8?B?Zkk3TU5qaWNwWU1yUDV1Y3V1eTZpUXRNOW9ya3ZJcWtOTkpzYzYwSWhOWTA0?=
 =?utf-8?B?RzVyWUVRL1dhUkwvcUtydjBnSnJQVjZxYTNON1cwNnlUdXVsS2x6enZmbVM5?=
 =?utf-8?B?enpSaUNTWUJCWElBV1NtS3pIRy9WRjZLMmlHRlM1Ykw1b3I4MEpYZUxZS2Vn?=
 =?utf-8?B?ZHpBcHlIcVRkS2NuWnVhZGQyK1QrQzI5VWFvdXdBSWpjQVJISEVmK0RmUjAr?=
 =?utf-8?B?SW5yN2ltUC9saG1zNUxxWmExR29oNlE0U1lBbC9MMjlvUnAveUN1UFI0L0Qw?=
 =?utf-8?B?dXJraDRBWGdVbUxuWGZkajJ2cC9zdWl3Ryt2VXZlZGdybG95a0tDRk5RRXJB?=
 =?utf-8?B?Qk9RaE1ORW5EWHVGaGdUYUZlNGFWOWtFQ0FVK3Y3enM1SkRVQ2c4ZE1RM2lx?=
 =?utf-8?B?NWl3TXcyZWFHQ2J5ZTRST0FaTWdycHFFQ1IzdGNIb1c2ZzdZbVNOMDJ1M3pk?=
 =?utf-8?B?dm5kUkprMUxyb05QKzIyM21FZVlSTERZNUUzV1RnUkI2Z1VrUHhIUForN25Q?=
 =?utf-8?B?UVNkTnE4WVBMVzhDL0krU1dGeU04VEZZeTY5eWsvL09tem1uZkxxRzdmMjdC?=
 =?utf-8?B?TFU1N3oxNS8rNkE0R1hGbFV2T2RndE9LeDdyVkN1YkRyVTdiNHV6Z0RvNDZr?=
 =?utf-8?B?cHdtTWlRejlrQWcvQXhUN3VMS082V1dJanJUNFB4WmV5amdmc1dMd21QMzRw?=
 =?utf-8?B?eHBxTnVLRWplYWZNK3FZcTgvemRsNWhmYktCVXZFaU9IV2JydldpVkVTbUVq?=
 =?utf-8?B?YUxvellML01RTjZFamFkY0VjRCs2Uk9nd3FuS1FEU3l4SFlkTGtLMXRRZjJX?=
 =?utf-8?B?bDdmSDNTRTFoZWZ0am05UURBZVpTSWprYW9pYWdWVDlHdTVraVU1UENPY0Ix?=
 =?utf-8?B?Zy9MNXJ1M2pwZmh6Skx6Z0NVeXF2TW8yTVBpVG9qK1A0SjVuM0hHcFNRWENm?=
 =?utf-8?B?S0EvOE5kTmxVSW14VXcyUzhvcTIxSlBqTE9zZjJTc0N4VWk4Umk1Q012YlFu?=
 =?utf-8?B?Q0FjL0V0OVpkdGFXUTJEMjdncXRycHZxZ0ZGZ08wb0Yzd0tLL21mcDdYYWZn?=
 =?utf-8?B?ei9CM25oZ0JHTEpDK3hUMURGYzNIcGszdHZxR2doMk16c0F0UklyUzlIUmxY?=
 =?utf-8?B?L0cyUHpkSkJmRHVpdkFkOHlndGVFVnZVOEc1djhNREt5Y09Qa1lmRkFVTGpZ?=
 =?utf-8?B?WC9uUDRrU3hud2lxOEZVYURmSjYwZVhtUEQ0Y3J1Uk1aT096RWpvQnRmdUJo?=
 =?utf-8?B?Q0lTMmhWeEhNb25xTWNzUVVZbDBaQWpPcjIwbUw1bVZCeTRlL3RLU1NYSHU3?=
 =?utf-8?B?WTluOTBYcWZkQ0JLVUIvL3JuVHV0YUU5MVozSE0wVFh1ZHorWlhhWG1vaTht?=
 =?utf-8?B?Mld6bVN2eitkUXNScUMyOVlHUjJNNG5CdTdUVzl5VnZabytQS051RjNLc3RM?=
 =?utf-8?B?enYza1g2RmZoRGQ3bVRnc3NFUmRWNEFYUmpQczZsWnU1Z1cvTFVmRkZHY29n?=
 =?utf-8?B?dzhYb3NwUHlyRkNUaTBYMDB4dzhQVEZIUEg5U0ZBRWRJSWJKUHhrU3FVRGtH?=
 =?utf-8?B?WEtacHI0VkpTam50Tk5LaVF2aWRWa3MvM3VxWTZYWGdEYkM2cHJscitEKy9U?=
 =?utf-8?B?SzRFbElkZi8ydTh2akRYNUNucWY1U1FXUXBQRjVva0hIcmFQUXBreFh2Zjkw?=
 =?utf-8?B?ZHhIV21hQlJPWklsZDh4RjZ3VklyRVV4cjQ2YnNRRmt1YnU0cmFCbDdIN3k5?=
 =?utf-8?B?bTNJL2M1RW4xQWRoZWZpSUl3SmJ6L2JzbjVxQ0NYWnd5UkJjM0V0LzBOYTVM?=
 =?utf-8?B?Um4rYjBHT1F1TDQ5S1hUb0UwQmIwdm53eDhnQllTYUc0RmZadFJ6ZDNzU1Fi?=
 =?utf-8?B?bnlOVFJhU05ibHJuaS9vWktvT0ViMmo4SEVMZFZ3YWtkdHJ2MForWFRibjlZ?=
 =?utf-8?B?UGd0UytIbUpEWHFFc09PSjhHV3NOcXpLekc2TFZQT25jcUcxdFdtd0I1d2kx?=
 =?utf-8?Q?qvEYgC+OavKpBwoB0XaWFZa30?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a1Yh+5iZa6duMk7/Je4ERtenBEqBuBGpN0PCK2cGS72WiqhVDdJUKdb3mbZj3jCRZttLQpuERAzfo0qZUhGwOhUTXjjhniUYZWL73//dqUayx0NtUyqTECHlQ2kW5gkr7yhWxPh3tTybqz7o3wXROTg8k4BXiY0U/rlPFax1egLiMcEtINFWidx/ei/utKN6//zNdFLB6yzfJ/FshIToWBFOOfg59O9xOypITYBJRULtnrJTJC+6MIRCB7ljmgHMpDaofv4WtXYkaebniSZT+oCHReWdElxu0ZTToii+9tPPAL5+8QVrD+ZDnxN7E2PvM/b8UC0hjU8xxsWWq2/eA55fewfR8xlMO9Y/kvHeW7xX0mLTjvQ1/3HnDmWlWWPsDgYkzz98lmfYc1Zc1A6Et4IoTP9NKkai+ODjMtKf+bgOtFy1jOGAAaHRcVMA33kX/ukWLc59V26Dp/ANpCZIt5hr3s/sc8Qg0u1SnvLiy0aOPmBAAz/blOdv/GLGsw7OMpQ3RsCZDV8Ym2yty40YB2UEtisTDVGfKqWbk0FRwz2V/ejwWk0ehguDJTV1uxQSAqVT29dK9AAZwG04swPgkLaO32IPay0GY17v1ChVrYk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe44b541-7db0-46df-a024-08de21c8f4be
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 08:53:32.0218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A89RPxsvaovYbNDJRzmwrr1ev02GLZ6KktK01Bflc2zfQwYSvNLqJjB3iKofXEdtDBhtxR0isYb3SjT2xLqH3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF97BE3526C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_02,2025-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=800 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511120069
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDA2OSBTYWx0ZWRfXyKB050pbYxJx
 MiSVcGiCDtWwA3P4+51XJi+oiRh07TMi+ChuiV4u5YFLH4iJz/zROFkbtgBMFOqy9wFWH362OtF
 TmFPucYJUy0fcghys450FfVG1YvyL/b5FmqM7oOOuClfKGnVSwHX3mhra5Mqw3ItTlJxvcXH87K
 EpwjUtKe/Hp6R7OOm2gYWPb9XyR+LrETMofDnqxEQdpe0qmcloZfzknVIY9sdj35LP5j5Cj0nCv
 0Q7XMNH/r8qoX1T4qStn/TYpVhiTUcqjfeuUXlGItxro6UJ4KKOUWSg70WUMYbPdhpliTZxvuwA
 edoJdrBd4xTBespsLYePBa2lRBqw2MeQF1xRnTJOqZ5PSARQArSkJVx8W+24EJ0TYBP1p+kmY5J
 RvwPmsF+gsPtOuIQ+Jm2iDpGHhSMZQgjey1Eo6k3050WaEt7/H0=
X-Proofpoint-ORIG-GUID: -hCwF4KXrn6BT7SXtB80Sqr0V2nPGsdR
X-Proofpoint-GUID: -hCwF4KXrn6BT7SXtB80Sqr0V2nPGsdR
X-Authority-Analysis: v=2.4 cv=LKBrgZW9 c=1 sm=1 tr=0 ts=69144b13 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=3yYrPqfE61uaPKPKPi0A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12099

On 11/11/2025 10:59, JiangJianJun wrote:
>> I don't think that you can always expect successful aborting.
> 
> If scsi_debug has been load, and scsi device id is "3:0:0:0", then we can
> 
> inject io-timeout:
> 
>      echo '0 -1 0x2a' > /sys/kernel/debug/scsi_debug/3:0:0:0/error

uh, I never thought that this thing actually was accepted

> 
> First dispatched WRITE-command will be timeout, after timeout scsi middle
> 
> layer will abort this command. This abort-operation will success.
> 
> IF we want make it fail, we can inject abort-fail:
> 
>      echo '3 -1 0x2a' > /sys/kernel/debug/scsi_debug/3:0:0:0/error
> 
> So we can control the result of abort-opation.
> 
>> Which modifications are you specifically referring to?
> 
> This feature was able to achieve the expected results before you made any
> 
> changes.

Again I will ask - which of my changes are you referring to? Provide 
commit ids, please.

> Additionally, I didn't change your logic; I was just restoring this
> 
> feature.
> 
> 
> 
> 

