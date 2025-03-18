Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B16D14AD0D
	for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2025 01:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742262249; cv=fail; b=Tyfl2I1Svkb0edBRLRHa1VqWBfg++hpZsZAoyzMGiJjd8HTGOXde6GoYhTR2J9/ySKhqYesJ251ZxU7gmG3KKJJl6TPqXNoa5J1leLVO2nVvxGYyhVrfvaWN443LPshanHLYkC9cZhm3VlWGh4ol0x3LSpI2vpkI7l/lKQOvNTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742262249; c=relaxed/simple;
	bh=hjYpNmxifQbXd9gxJVDeKJac8Ods3973fK9Uoeykh4E=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=B+tgYRF8q5NjdOJjMGwhviwP349u4v2vrFzmLfhwDydRfc2RiWujsKNGRq7CkPi1GEGGB8OTnGWe02yDGJQpf45OQkhozfwVadaaVj7qVvfBPBwFVCkIjvfCRBb/ZQuA1dMZTLWY8ZINkuly7FmDvOeT41XUxuOYxsPNa9mYYBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=k66cI5Vf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Qs+tpzNe; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k66cI5Vf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Qs+tpzNe"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLtu5k014925;
	Tue, 18 Mar 2025 01:44:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=HD4VrBI19DBg8UbVf6
	tMOyMGHv6ZEkbsWrrb8tSXxTE=; b=k66cI5VfazrN3vnF3Dzlql7RuPYI4dWYX0
	17xG9bjhZyqO2FOb8KBPS1sSMdEd8+XLpy8xsh7zVYUX5JivxtYJMVTEE3+11Y0U
	rmMTTuOHurKTIYKn7GgEPso2zQW76w+4Xhbg+gInwqrNQAIqrCcVxaKHdOanhZqW
	GmMoTtLH/6rBrHNCtge+X0HM2g8uhzloqwY1+sVq/3RXgnH+Ng6OLnnr7DoNqwud
	aHKR98rwPHN26ps79cdEGCy22ClfxevxqRAxVBymzth3fvDgSIvzRmXQJwF6QnaC
	YT5zbVRiWsq8Wq8GaNgiBjPXuankM0MiU5qfeZPj3aD9rc575Z9Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1k9v700-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 01:43:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52I0L67O027927;
	Tue, 18 Mar 2025 01:43:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45dxdcq3ey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 01:43:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pukXNBIy3CONN+AiXHrbWWf70tUZ0Ep6ASs1egX+IBWT8LfPj1e1xefxN1MJj3tEvBxW01v2F0YaXawcznxJtfPMGGmX/PPu+nJzBPP3h07RSGuy0KSKfTpmQ5CbXAsOtjCob6sg+E7Sdc6zJbvEz2ASrK/n/eeLJX2pXL9GzFFruvg0bYSm0ZOEzJqW+Cc0bLz847swfFGD7Owu+xPJ6F2uZJThT5POA2ew0kEMUQ+ClJcRsGXky6PRNuZE9TPxPc5HdMOeZ0XLomiJ7W7s54xKvWiAWVRucd4Axia9nCaqlNt5zdfHOCMhsuFXzl7dxbmYvebjtjUCDlB8pjEUaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HD4VrBI19DBg8UbVf6tMOyMGHv6ZEkbsWrrb8tSXxTE=;
 b=vQyE+90/iUKA6aNTqq1uqPBEM93YklRl+6iS0jO0OgCPxkU1Aqmn3YI7T0+q/DtV4FbXRmpnh8VIV953MazSHhWfM5JhfVSH6FqvlDF4soTg9oQ9/ObKTYz+qmMCk+gcwYh5iwYMB4mjvC1VOdHOjhx1YbAFyvdLrsG5wOotQdLj4PD3Gk4nQd6Fi++QbFU1fpWnwpQVy27mKRSpbaqV2gNd3BgO3Ib20ptUN184MIZD1Aap8jC16QFh++aFoSjTrGTmmb4vwgHDWzRwKGIIzWZNsZMWWMJkLpjnZ7Iu0CCeTis+JVlAHgolh9yAT94DO58RRYnDRK8KL/o+T/LVXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HD4VrBI19DBg8UbVf6tMOyMGHv6ZEkbsWrrb8tSXxTE=;
 b=Qs+tpzNePC69D3fRIGQNobHnkJlv19R8njroGKKgb+e5Vnyu3I7LIyns6GD8u1Px8319+d2DtP2+k9YSaKAmqh7xbDTgfr3Eb21W79ViFhIkavjtEdj0WVQGqg1TFkp5mGezDbPJGGvdq8ldSrdwfGesc8iEKkZ7TEMSjdyoXcM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB5197.namprd10.prod.outlook.com (2603:10b6:5:3ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 01:43:51 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 01:43:51 +0000
To: Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        James.Bottomley@HansenPartnership.com, jmeneghi@redhat.com
Subject: Re: [PATCH 0/3] scsi: st: Small fixes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250311112516.5548-1-Kai.Makisara@kolumbus.fi> ("Kai
	=?utf-8?Q?M=C3=A4kisara=22's?= message of "Tue, 11 Mar 2025 13:25:13
 +0200")
Organization: Oracle Corporation
Message-ID: <yq1tt7rcdvf.fsf@ca-mkp.ca.oracle.com>
References: <20250311112516.5548-1-Kai.Makisara@kolumbus.fi>
Date: Mon, 17 Mar 2025 21:43:49 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0046.namprd16.prod.outlook.com
 (2603:10b6:208:234::15) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB5197:EE_
X-MS-Office365-Filtering-Correlation-Id: e68b77b3-d0f1-490a-1170-08dd65be55dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?o3pLobZmIsfBwlK9xqvETZoeHGQGwFYS9XjWyTiDAJl5ZOr9pdx1Z79kfgQr?=
 =?us-ascii?Q?crLgDBZth8t8KfEjCPqV/8ZV75ZdSGpOBnmQfAtOnWTwtHcKaIH2uEpA0VBF?=
 =?us-ascii?Q?Tb8lEG4z3zR4St/tcJfzqvgE6yTh/TEhuqA8t+f+uDMwLXD1Jyph8n0X0VTm?=
 =?us-ascii?Q?n1ZojoS43L6sVw8PxvKiUbJZFSV2CiouX5Je4gFj4rh4Jh4vhvoIi3uOnc+4?=
 =?us-ascii?Q?tP3BT2FQMSjLIGFjw91BngX4Z7mw435o+BAehFE2JpQSJ7P4MWjaOlHWCzmj?=
 =?us-ascii?Q?yfIDTz1zbokxY7lFkD4odVGaliopEYzUVBoor5tYWQ5jsMAZX7w5RlZgOWih?=
 =?us-ascii?Q?yQh/j+AtUgzFO3JHiAvzW5E2R/XMRZyaIWqFCHLrKdyCtGw6arQI3p7GtPps?=
 =?us-ascii?Q?PwzdZEjmRBP5USCdRirNMjHiSjW8d+fLui4UQqnOT3wBP+u/J8ARmCMYKQ8Q?=
 =?us-ascii?Q?FwhRUxQ/ZerCHGPRzK1klFmTQkK9Bo+/vhF5jooC3kUNxSDIAXMiOLgVtWja?=
 =?us-ascii?Q?XZnQHRvBGUmdz3KKEfcIGPdKWU4QEskv0JA52qS5PmpJ3XlIFc8TLmjUpw2u?=
 =?us-ascii?Q?tupnFac1EEiRmjy5qNynk9rUYfLfY4x323JA2b8lrhLdt9+mbvgwjY08Zod6?=
 =?us-ascii?Q?J41DjTL5xA1mDBaeyi4fTf3KSWkU0LjA/W2dI9tkGliX8ES+kQTxBi8OvAAD?=
 =?us-ascii?Q?3EkGsoRJmGgNvqc36SLrJxfElLDdzbZQQUgwsQRyfoOOhDkT808pdFkoITDC?=
 =?us-ascii?Q?7ui/Fftt614xVTcscEGct0bFdOwTCkEW/CdWQ6eHIixNTnjltVgOmxHE0WFG?=
 =?us-ascii?Q?P/ag7dsDT5OkKzIMbshrBPIxdFTg2owbi5nUedcOk3lUD9GSaBht5TmUjLD2?=
 =?us-ascii?Q?e69jXXyUByn2tIWA7VzMlq95OTOlcsud06RquObs3rmS8y7SvhUKnL5NMyCi?=
 =?us-ascii?Q?5RXmtIyZF5P1jgvZ8u8Q0QRpObS4vSJrMJWRGs23XCgLcSaVN6W5t0VxHIym?=
 =?us-ascii?Q?w9C8vF99zGu8RUmV7xfxOAa0OWTCDXQDCQmgfT7pcxqwZ8bALXFdZqb3Nahi?=
 =?us-ascii?Q?X4hmw2fxzeGM/FG9qmW98Sou3ubHfefqZlosTxvuoMAIZhpWqTKQuiDNMEIk?=
 =?us-ascii?Q?10IQQXVnIJIXxUDs5qzDog2VsJ0lBqYFpth4TjIBco9x6hn2Wyg/MKt3zyr1?=
 =?us-ascii?Q?7DAhFffevzSE06YMl7m9cgqFEfkqp5LwUwwMRH1S+gG7K/AeDn3C/ZOpTAjl?=
 =?us-ascii?Q?qYkTgvSJMdNKLPUMWQmD9jk/kUN5vAJf7yMdT6v8UYF420ByYSQToLMvroDt?=
 =?us-ascii?Q?SOeKIl90Zt1Ogsq8Cgn2lwiK+penm9oJzKShz2DFGHJo29Jb6qARz2vT7otl?=
 =?us-ascii?Q?pugWgHilFrC4BFSB64IwMe6lHY76?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qcj+13LJzjvBCaQnZ3eRgXqvZRYUVqMR7DUqlrUD/JO9VhI6YEzFCZRF5X99?=
 =?us-ascii?Q?pha99++c1Cc2Es90ARcL8cIMMTAw2/+r0BjLxtZuTVBds41VbyDNzhS42DL8?=
 =?us-ascii?Q?CpQrHckv3JUkk9YIEy03/u7DSXXd3BNe0UVIRb0+t7P+MmU4G3W+K7M0u0Yw?=
 =?us-ascii?Q?sM+SDRG52TxzpXOHwVQqVWis7sqEsQGt56+//meQko9nHDZgAedNYy6zb5ZC?=
 =?us-ascii?Q?z5bmy184uZ+1BvKxeFya4kVHJp1M2IokkB0M2uimoI+En8kZj54l6wVUOXdx?=
 =?us-ascii?Q?IKWtM2T6tN+J3+cn7K6k/7sdBDRq9r7iSPKOREQPQIMnmuq86vi8pAi+3QzA?=
 =?us-ascii?Q?K+IHcEKSD7MJqcBC8OmGghQBgIQW/x4VrTw4nehUY15yyz2M4L7Z5d6dOwxr?=
 =?us-ascii?Q?8eakyR1W9veAApRUbzNLk8C3L/1SGqr2IMYCNyuTFFqP52Tr25FdJ7UN3/WJ?=
 =?us-ascii?Q?hLN1fRt9CascIWh1owjCMqU9/pNlck/7fLTM81LvRlsE+E5qhY1YTsGyCOHt?=
 =?us-ascii?Q?J4ufFTL3ErWhyTuOdPKCvkQWHGgupT4wPgsXBu1s1nRCp/mqZfkjThohOpsm?=
 =?us-ascii?Q?H9KW/olf/PbjTrV9tlhHXxeXKrxyTjgPDPRi2NQ7I3lTJdFJRO7MbC6Uu9QP?=
 =?us-ascii?Q?6KUKGqyZUDQh9Lns5o0oMSzLtpqiNJNW6sFif/xGbiMVj96hQ0yHwMCOAPEW?=
 =?us-ascii?Q?FlWrGnByiWEkc9uxhze3fIC9J8+sQDWFe4E8QHCU+6ZT1bfAfu9BA1bR1bWb?=
 =?us-ascii?Q?+os2OiABR0HG5YtHXtTaB1zAfKKVDqVbwGi4fWuRqOkk5sY4gafs/58g96n6?=
 =?us-ascii?Q?5ewxP2wOdds4fVexMQHhv1l54M2LFuxlAPEWl8W3BMK5qYTE1P2NhnqLrIQE?=
 =?us-ascii?Q?n2cLlNQuharUBzdkyv5tOiqzJxw8tcsRsW/LN33bsJW2at60nFfDF5MOBtI+?=
 =?us-ascii?Q?Za4RwLtEPc4BMkz5sD8hIzjtTRDG9i7AdkFx1LZL/OIF2w4o7zDz10hn1hMj?=
 =?us-ascii?Q?cV5YUT9JJgoRVEw9ylE+3WgMks7p1TVGWkTxJP96viIl96MPTDyH6pbt8WWz?=
 =?us-ascii?Q?avWUkPUu1JZmgJBTIYszrOaAgPYTopHU3rh5IahFy/O6enDtu+3V2uLzgs69?=
 =?us-ascii?Q?iWQwABMLju7ZnAjocvxyIs4Qq/bzQX9M3mqxBknFS7pmHPY89l5yYnoJO9tV?=
 =?us-ascii?Q?qHPkHxnDwBTm6VOjFJR5gPqBFg/CnXQq301NtSbYNfkZPA4LuDX17zyVb3Zv?=
 =?us-ascii?Q?oacOgR6YTcMGplBfQC+7mGs9cHj4WT0eCdxM4Gi6C/CM7Upodwnjci9Ho56m?=
 =?us-ascii?Q?p5nnLpiOdUDXumPixwrvhWVUmtAZeo9r7sk/5+aT3Ib9ZqVYlL5Zxi5VEyB9?=
 =?us-ascii?Q?QqhwwlRoEnwxlQVE/CxnKC9K+kJVSGKDeLPR2Hozy/gICaY3L0phjrK7PDTr?=
 =?us-ascii?Q?mOAj1NVS5G4h258dxLa93K4JrtTZBbdI5hvlW+I3RgiUg5BKxs2Dh9XAOJ4V?=
 =?us-ascii?Q?2MGjPP2PodwkpUK+eaUolN5Y9eVd2E94QDXhZaf/oXpTU/6j2FXmzot2gO7E?=
 =?us-ascii?Q?PAwUiGmbh63631gvSQ1tGTnHv6VycVskE4vRa1G8Rl7tBRRybDHAceAEX1p0?=
 =?us-ascii?Q?/Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t9NHgPA3bVhiKtbOTtKvIYsDPq9Di0LaLoIcXI++hKUV+3f5lW0n6xAkcFqbNPNmMlfnZN9gy8trLivh/f1WViwCNKZvEBLJNp7R+PZGzQFnt20GmSHyAvXklSej9M0LKKjA3ky8QSaoX6Vn3X5krdw25vF9yz3MjdqgbOTyTRDe0zh/qFmAlfKAszUDKoMZOZuakwW3Tw7VVqWCh86gexITvthWvYLZl3lnJlF2XoSL5HZTpLi89uJXqJfSXaosoc+kE0XLSC5wPvV+ip4yatrMhQ6t686EqHDhfP/7k2MQImuXLZFhqr6dKwfahrJHBB7jCAr82aLn/7S0UbKfKRbXGyJBFwGNAac8MaGgDUEdke6gXwVDXV1Up+UEheAbb8WH5zwVceyJSDq1EJdIYPgJLAKiPBfvwETF4fRQQwAIxAQeaS6hDwxxTfB4RYOjIrygs8wV+v/DhfS6d9cXd3CCGblKycsOTXRqRc6Kom4V7svwM9sz/e6iBN5j9wI2gTjMBk90P6BgVqfCjYtcgpCTsQTW4jKdgdyBg5nhJ/xBRzeiZvAvwRqyU+U4vrZ78r4Fsc0I1FPYVaekTX3lzWQHwluHJ6V6B3WfISARYww=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e68b77b3-d0f1-490a-1170-08dd65be55dd
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 01:43:51.6399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yXq8f7HHCOIsjWn5q88HrcenizQSenIqclhkHhBqxqHLvbdfs2TDA5C1GE+Ij4bEUeWOx8F3b+IvvEkvOj31Ge0enplYvK2JzyJ1cneKrkY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5197
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-18_01,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=787
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503180011
X-Proofpoint-GUID: lEKNvb-eFVhJTeWSH697YLFF-QW3rPu6
X-Proofpoint-ORIG-GUID: lEKNvb-eFVhJTeWSH697YLFF-QW3rPu6


Kai,

> Fix some small things in the st driver.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
