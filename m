Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D861A1F91E3
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 13:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763041035; cv=fail; b=C1hb9diYT2Zq5C50BehEyqYhjHZCiruB2enHgx2rhtGLjRGpuKJqk0Q+sI/qsW+uk1MLJU1AnqtdywyEaXiHwWKCOSxdlBq1nQy1xAbWdDqQ97OgW6kMdhhVpyg6b0XlJps/1p9iIRaUJFHkVAYI0aAXEQBxxXx+d+16O6Rk3tw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763041035; c=relaxed/simple;
	bh=DxoWY8CuY2GQ5dcnjhB9uHhGPKd8xXYl1VCPxbU+IfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Mtu1wG3riY2gdvfGu53OSF5J2/92bWyhh0JkKvlOqyIyQwKrnkYLnbbZgPx+48mf+o9Yy8wTm1gOccQM19dy3rXGcvOHvaMZ9nibNHTorsqc6PfaX8dcLtvT3zBETZL6KWRX16uMzQV0HAP8C9y+LyF4V1ZYwsrzoycEgzlWB2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SS0hn8iH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NKNAqFZi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SS0hn8iH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NKNAqFZi"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADCt5PA022715;
	Thu, 13 Nov 2025 13:37:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hzCjP+zKuoZhBIY8aBZvzwJ4T0oB3IWNa63z9NbDc7A=; b=
	SS0hn8iHyilqu1VEyD+rxPYow61cWYiUikV7d9tRljv1+dNIXYRvLMsDaVWsPK1y
	KRr+UkpYafUchm+ovPN3CApGWFL2+C6J9OL3ULOxD/KkGqK6gsBmamp7iQCBL86R
	g561F43THxWzXkbY6HrJhm+RsHidj3CW5Wdmmt/TGgTQEUpgh0cjSSML78IXK4e/
	i580D/OBbNEAYlJeJ3ARjfZh5Ksm68VSkd6tt7N/AH8y+M/UiLEcMYEMEugM90BX
	x0+We2H0xtuqkZUT+AGnquny9n4qC6jX+aSnR2yryl1CdRzDGkFWiXWiHexo/2RO
	ZwG98bdc/zStrA8SOWIgcw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acxpnhvp0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:37:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADBsLhO039422;
	Thu, 13 Nov 2025 13:37:01 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012070.outbound.protection.outlook.com [52.101.43.70])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vac40u3-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:37:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MSvUk2vxkGnvsCcNZVxA8cRlDJIe/5j5I/8lNqLQhEZswMAe7MSf06MbbyNVBTy24SFAWF0dvZWHDJNdOX+FiryD4Co1rM60zCavAsuX78aVuUG8cG0GTrPGaUq896XqaSoyy45UFYYitrwmxecOwjqz2Tk670DXLtes/YTLui8DS/ln9MM4t73rbxtDXPS2IjEER8tlPeD3QtlrWgM3XzLeFsbasLQ7xkRxFYN7WeACVU4uYrdp/MtHm41++7aWM9PJSAKQLDbDaHkSku9wU4LCIBCb++IfQf2Ec2J0AFQeeoCw20FW3t5IvoBwT6FoTgkpVlg/j5pfi/KDJvAg6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hzCjP+zKuoZhBIY8aBZvzwJ4T0oB3IWNa63z9NbDc7A=;
 b=k8cVKkQ1rFqmeF7TDF86frq7YY5V5Xelq3NY1PcEoGCLt9/Hd7WG4ovMC2GQb0DaoR1TqTcua13IfEqCup7XWWX1UmM2H7Z0Eo4NV7qt4mOjVjtN+X7gFdyWP5xDzOpnsSrt5HyouzLHFwWrNeV0hTOqkiFyANiI75QoALmcavn2xsh7snJL8iPXPxkw5L3rrA4Wx55z3uShUpF64QOIiQ+cTNisAi3L6ZlzZGuoeNi9zZBgdNZMLpwhszjASmtz+gGBuuPLa0j5yz7jeUhXGOlKcdsoECcL3K/3YhRlrP2Od/Hq0w4RAb264rzODOYuIdPjChv2D9v4oI6T3Xr6jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hzCjP+zKuoZhBIY8aBZvzwJ4T0oB3IWNa63z9NbDc7A=;
 b=NKNAqFZiJqmYaqITT+83nThP7zhN8M1w5vJTiXC4M7+qFFXFY9VsMMzEZjOZonbjrMXuY1yC8qOoEwgnaqUowOCeG0UlLzKZQ2x1fXdoVGTU88z65tc5BIUYl8/Mvh2CCGY2NZoQzFn3W6SHE88DfuXNXaTfuXGog56NhjCxm3s=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH7PR10MB6252.namprd10.prod.outlook.com (2603:10b6:510:210::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 13:36:59 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.015; Thu, 13 Nov 2025
 13:36:59 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org, jiangjianjun3@huawei.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 3/6] scsi: scsi_debug: Drop NULL scsi_cmnd check in sdebug_q_cmd_complete()
Date: Thu, 13 Nov 2025 13:36:42 +0000
Message-ID: <20251113133645.2898748-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251113133645.2898748-1-john.g.garry@oracle.com>
References: <20251113133645.2898748-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR22CA0002.namprd22.prod.outlook.com
 (2603:10b6:510:2d1::26) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH7PR10MB6252:EE_
X-MS-Office365-Filtering-Correlation-Id: 36825924-1883-4bd2-79f6-08de22b9b890
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5wmQzvL4eTWXmnkL6nNZFoNUpiDbRzPVTU8EAQWsyoDGHLzERugLmrBcQAg8?=
 =?us-ascii?Q?27QaoKvViP6hQARBDPlS/7rW0D3L3G+Q1hE+JHACjFRZEdUrbfmxg7gPjwGO?=
 =?us-ascii?Q?hM3jkcFbbjCdMBd/t3shUiduqIHtEql0vTXkPl8LpgPxhLCHNtMhSIL0P6xL?=
 =?us-ascii?Q?MG9ed1xHv8nTYAG2UggnQUqpG7WtLJ2Kax1G0XgiEA9mFxrIrR0u4f8DdHzI?=
 =?us-ascii?Q?atxDbbfIRirl5deZmpqc8pKmUTl3oX5YpRhAdaolm07s6PkYyH4HRSck7c4E?=
 =?us-ascii?Q?IWKjLVEgR+NnP9+IEq5vbUKuRX4NCqf9pyLgnKWKieCazl2xl1dHzmRYf1Sh?=
 =?us-ascii?Q?IN+LLdOh3qLpygpuepQF3SAEK94w9ZqMCtDTzg5AuF/B+ozsw/Vwi5z0uTZZ?=
 =?us-ascii?Q?cSy4esv1Gk5dOdx8ZEBqO4ZYRtqA0ivf+x3FAo18dKtymOEnwxhGNmdJYGh6?=
 =?us-ascii?Q?9EFUxkMo4gFy5893g4Eg7h+/oXMbqSxEpqXvil6Z1vOYLWM2KR2BS9/vNjWQ?=
 =?us-ascii?Q?Z8SXpfFxZtR/6bMB+8VEmToXvF/YWKU5VZhWx8Ym4OKZgfRQ2doZfL2zD3z0?=
 =?us-ascii?Q?yeq+WF7K76riJwlzdzRvyusPsll5zygmT89iG2wFhQQsKETB2a9IRrmtFSv6?=
 =?us-ascii?Q?50k1axpqCr6i8Y93tgk73ApDLwDB0XLpmKpNKfZHT+KVgkhd6YAxJOzUdQQ4?=
 =?us-ascii?Q?HACzBK+cE8PS1eu9CxflgMg87FGXdojIhrC7YanWGvuGUnGTLig7XoKq6MsE?=
 =?us-ascii?Q?IkoCT+AZPax73EK8EpxBJu4RxYLXFGllh6q+y58xUmIKbUy9a8kiERdeLDef?=
 =?us-ascii?Q?KBrPWbIjY8JdtXWXcVHmU1ATtOX0F/ZRU2hR18iba3pCvTRwH7kMykU35Ruu?=
 =?us-ascii?Q?TOhcD5Py+8PhMyTTFiLoCUeUzE2kJpji0Hnp080aovXA8wXV4XpirLIL5S2V?=
 =?us-ascii?Q?pnLcEqqtq9XKavxC1Fa9/r5umlHWmtHy8Ad0SDQd5ctW8YMbUH3gSidJN/NG?=
 =?us-ascii?Q?oge+4X/IZHTec0/e7cXfqxw0UFpJ7K6lrudiZOmmmSGBFFwe1FJlfLRLYXHf?=
 =?us-ascii?Q?WCARq5mboPpOEnUkN0//0SVsqWClmrXe6KeiAUHN6pb8nj6TZQU79z2P+dan?=
 =?us-ascii?Q?kRXQID4GhpLW2EzTQJF7mW5qB9AyTj4dlHL9oG+JobpouruNUxAO02FeflIe?=
 =?us-ascii?Q?FZtzOcXT5IsrZw48tVjlNiaTc6IointYxYv6iScScanw4yOfYD1zpSz9waPH?=
 =?us-ascii?Q?sDozqhSfbYIA+UJ1WF7FXhw8LawkIWDcVAN9iVTADwto3RcS7O+p04HCrxuq?=
 =?us-ascii?Q?0hqZ6W0NSCHdGJ3Vi+LUxY39nxXrhX0xjDOS3IKbvUKYwNZ7+zXips50epx5?=
 =?us-ascii?Q?p+EAAOTd4BuWU+3+5PgVmyFSeQ2ck3TYYo2vNmq7vo9sli5hsQOO0v8rwVxR?=
 =?us-ascii?Q?kCIaGFz9SFgEdCVsHeixaWnOeSc0SrDu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9kvBZZ4Mr7zclqXmw7TLn9WNByY6OaEMOYqyYNAYnoi1ymumMl0EZqVVOc8C?=
 =?us-ascii?Q?cls7PI96zhQ4Ivl28lelbIYZ66x0WtxWGoXREjB90EibVA7byNeeBh9ekvxj?=
 =?us-ascii?Q?WbdkQDr5w1K651taTjQ0S6t9Is0svo8yBJrspeM2kAS4s7TjzJECKgx5ctuZ?=
 =?us-ascii?Q?RW7rhtIANW83BRjjimzqPjS4OPbCqZQ0y43C9kF1Jf4IzFCu0uC6bSt79MeR?=
 =?us-ascii?Q?Ya5St4Jw+d6kACl6F6YCt161/2iWGfnQ9qX3JgzWydNDcHYjbkaVfIbwrxh7?=
 =?us-ascii?Q?UDISG5oPnJhw3ncMj7tsdPW7VQOz3FCNAj4q4VtaOys+N5ihgSH3UknqmHn0?=
 =?us-ascii?Q?zE5NvjSHN33uu9mgf0XqY8imLEtNsFyuaLwK/6FkSZb+ifasHxkK49r+YrXE?=
 =?us-ascii?Q?oTIrNx5/9Vg021UAhk4adZVL+LRY1EZxea+Psk21A22NUYcXYEJCStsOmuf3?=
 =?us-ascii?Q?Bddy0AULo5BvtK2YAK/Tf90y/LiqaxTUvW3fKZrO5EHGjpbkGyWg+Qg8Pb0y?=
 =?us-ascii?Q?9MnN9+wNOLmXMfNB5MDaPbP6SGIuOkXq9b11xyPC8afKNShImHH41i7GxuuY?=
 =?us-ascii?Q?vkc2CNsGs8wMdtcG+sq2lWIR4lhKgcWrm5LI5ilYIFQVrVdHdcxE7IVlghSh?=
 =?us-ascii?Q?l+uEwsLkOS1tto77scGPWtMR/eVEJeOwOPL3yyUQud0cQltcjEDQH95yJR6i?=
 =?us-ascii?Q?YCSQVEI9N4Suab9TelX+4e201RgBqJv19Ve7Aq7ey1w6S6eVq3w/VLuj6Hir?=
 =?us-ascii?Q?zOwHyY7fGU7CpwIr09LqSccYgnsJ9/U5Maj5d7W68Dbwmdk1rTGs4IEYU4pi?=
 =?us-ascii?Q?UinXiuM9iMx7o9s0fd1Mx6JiyoArxuRfapYcOCXSOth2BVc74RFCejCz1+XU?=
 =?us-ascii?Q?aaVWyOid2b+4Y6xtRAqa+GzxobBaecEMYyIQlQxyTvouvG0SxvPtK1RJAHWO?=
 =?us-ascii?Q?TOaBEoquhQUA8JOPuyJleOd3OdjpZ7IqshIFYTWs4Wr4DG0l+h3OfBZq25bX?=
 =?us-ascii?Q?XtBqhmsveOLYl16Kfh+AzeWKHosmyEHVJ1H11WftXt5u56xVOYWESfxpLcyp?=
 =?us-ascii?Q?i8i+QF4NLnU/RSwYOvUQ2Rt/CHj/RS3o6jPFVyErdh1Mv8UOd4rmWi36MIEH?=
 =?us-ascii?Q?djPygyg0exPtqlQ+soFQPNXm/p+qB09HVnxoALgxuCj3WF4yPcnOgQCgWQj9?=
 =?us-ascii?Q?IPPoY++2nWQhuEZXlItwoqoclz+ZuEaMlD5geVgRptlW9EkWQGXKzgBqEWLM?=
 =?us-ascii?Q?YtLlLgd/RWPmM9NVHBxyFsd/31pwxWTZ160N8efJ9y4j5erDqSB0erq9LTRh?=
 =?us-ascii?Q?InVtrSC/A4vPH6o81gWobrXVFSSb6+9uYjLEQp0jA5Qyp1IeC7VIhmSXDuvm?=
 =?us-ascii?Q?mTJbyzK0PxcYy3VF+M0U8UCu2DH7vGh62DYwuGh9EPHBqFmlr7Pzt5ujiY1m?=
 =?us-ascii?Q?Q6P+QEmRLHAG+M10kIMNMNrGP/m9HvSDg4tltK4kgvbMF030CYVUyqWtQqEi?=
 =?us-ascii?Q?qhs5gH0FhqsvMqtDCugITQsuCvCEb0nXMxXQqNgXb7AQn79HNtUicUVjFrnh?=
 =?us-ascii?Q?ZEQrPxd7PY4K6+QgIgrBH7k/me9UroWFfe6o8mbGAv6gy05oV3OFVjfXr3E1?=
 =?us-ascii?Q?2Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MBqAevy6/BXlm3IRjiPKSbHp/ptHyWrdXjbMNbA5Qi1GSOSDwh6FQjyK/jcEPkuCjHHRhPPnaEFIF7TlwusIEI5kvFu+ubi05OW+nDT/bLiTPmtzB38HJINZ1g4b5vM3W2JtYtk4I1KpJauxLZ77kQguFNc4wqSeqLWqDBSw6RhxMdMYtlvhT5ngxHecmvWF7GAQ/xWziZf12zb3egsI4kp8jKNAR3fUnq+rw38zwdzUfvK9820AfGHbriHvNiO+rSq3Xlic9suAXZq2N/QLiJs4qEj3SejWFdtAhnIS2pEBLtYeEO+QKz3kYB3ytCILfVd8R+cI+FCRxWpLZUnASwmkakhOOK//HZ7aJJ6lohVGZIab6qZsfIu/mzkLz6knW88NUxs62vZcrpibnNTvyh7UI/3q2Ckbl4oKvqJRdwbozBehlLprDiJIcbRsQ3kbj87PFaVzxn37T9Bn51jJc3qFUH/rM8Ad4awKm/JYu9wuBzDfSKY7QHwXfTVSgN1yCKUQb8U4683yBGSNB1IU8R6rJic+0hGs6lTWwQTflbJ0Aop3V0c/JRSi4Bv9yjR66BVewZUs8CexW15uKIQvL8ziWUItszN8DK/l1V3uzO8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36825924-1883-4bd2-79f6-08de22b9b890
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 13:36:59.5006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zzoLPv9PCOdc+HABftC/8gX2qFjPdiql2Tfx2/RV5M51kjXBP2Z07/sHCWb6UsTy0+lHJSjn4E+GMVfhuwybVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6252
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_02,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511130103
X-Authority-Analysis: v=2.4 cv=Criys34D c=1 sm=1 tr=0 ts=6915defe cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=I_Y-4W2MEeRJTncHAb4A:9
X-Proofpoint-GUID: vqBObZ8x61JKQBaMEVCpWPbgqovzX3Zz
X-Proofpoint-ORIG-GUID: vqBObZ8x61JKQBaMEVCpWPbgqovzX3Zz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0MSBTYWx0ZWRfX1HhLcuulXrRp
 V+nkUVxT/bKEcETLxJdJcTKe45cUWe3CT+udehkAMCwxDDNo/XAE2RYQ4ZwDk4JF4f170NCeUcJ
 Cvc4FGLtHSR3sa2osVJ3Abn6FYmAb/tpBXN4HxJ9ELuUDPZuP8xP4YiqARgt84OcaMtqAGYw18Q
 ylqIN2LCwAppzY1EOUsOlDVE31ycoW7R2xdxd4ZgpPunc2BFwgHp9yGFr2E4NzQ9FRh7tWVd6RV
 DzAKLlcMheRzF2Uhwqz48MjoJdeKDoo9F69nbBXDrKeX/w0Ow6GyMpeYjIrP2h2/j8UcDk6nYaR
 6tlpkrGgYIzECpiuUyucqzurWajuKxa6A4rBhgGQocAWbTUlpMavk9sDfv+MiHp7KYu97jHeUgp
 IA93EKcomuavfvYtOE5tMWdFYYTwtg==

The scp pointer cannot be NULL, as it is evaludated from container_of()
and pointer offsets (so remove the check in sdebug_q_cmd_complete()).

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_debug.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index e4994435ae514..25feb0fb898cf 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6386,11 +6386,6 @@ static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 			atomic_inc(&sdebug_miss_cpus);
 	}
 
-	if (!scp) {
-		pr_err("scmd=NULL\n");
-		return;
-	}
-
 	spin_lock_irqsave(&sdsc->lock, flags);
 	aborted = sd_dp->aborted;
 	if (unlikely(aborted))
-- 
2.43.5

