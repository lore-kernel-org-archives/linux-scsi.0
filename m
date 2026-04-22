Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B25C2A1AA;
	Wed, 22 Apr 2026 00:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776818916; cv=fail; b=SvtrT4/Ry2ZIxtXX3xHCJWMfswfpRQBeHTCU4goXBfZUz3kWiwEBovuwr2I9IaV+K71WUprNW5IpyPH7OChN+A/hGM8NNlrWjot6FNZ3X/G3XO/qWPtqdc3R48h6S7RRYFkXPIekStu2EBwg6GcR9PpJrfQysH+ltPCYyEYhz0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776818916; c=relaxed/simple;
	bh=UWJkxQjqo49wVpaQKrH38bzs14CBvaBm7C44SymGd5E=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Ln1JOmTd7XdiJhpa81bY/zPmjWF7rBikYkCK2JOq/TPtQzP1r79FxW9EqfPWSqm1+eDhVhQvq8fgthXh8ZEO4dmwzUONuDODxnv/ciLWluPdI9oDwgOOEpLOJJxFQxpn92HwEsKKNVR6bMjSDrDEunHIXLYJ48Rhmo8sA0WRhrk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fiai4yK8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GyCUWENx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fiai4yK8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GyCUWENx"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LIam8S055567;
	Wed, 22 Apr 2026 00:48:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=YcztP/JpN9IX17QZHP
	ifa64Y9ZoFQV+sQduMyPyiT1A=; b=fiai4yK8OcF/HtGtuu1kxi7oy3+nu9kHnQ
	nagPORtLDlkWRixbZYHIr0Mpcj84CP3SKQbofeidB0/SYskauvQ5PG2y0HoxCntX
	A9EIh5gIBfU/zovMdJbO4Li/HAajiRfZAubV+k0+l7s/ynuEamjUq30eG7y7RshG
	woBmFf+DRDXoz9k8/pxxgAIzM1u80w4bosO2e1Zf68sDHRWQ0taAllGU16UEbFOw
	cY5eha2Umxwo/4wm9TZmH7vrE/L/T7PLDWcZPLtpHUMnrzBR37TUYME9czdY6rvi
	ysXU9ENPlfxQlgPATMCwuay2hssLZSKk45b0/rbvvFVzMuizQGuA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dpenm0eav-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 00:48:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63M0kOfZ003469;
	Wed, 22 Apr 2026 00:48:28 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010032.outbound.protection.outlook.com [40.93.198.32])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dpjjnjmam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 00:48:28 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QRAD+8puZ7zRcA5hN8pa18Awq8R2NEc5KWIGGcKwZtRubRhW4sK+AZbzjwzcz/LG6pE9T/ik0upzxrelrABoqV5AQTt9HU/2j9oWz/njuqqNB0CJFRe2XcwVQfSqHxLyynR36ZuG283eJ82W3r/yBr3gPwHuDzlcFG/+QQgzCTqMACaNUuNZwp8hBpH7Pr5906w91JcFUUfN6eFs1oJbvlgWfGiCagmnE/dhJL35YbfOWgvLbWpm19oWU+4xpkZh6XfkScZTFXhTQ5GpyBYGsuhbyRjn6YB+8hB29P1Ji2TygiMOcAUbPMk0e6APFJzD47/C32tcYgWhY1iwROnU3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YcztP/JpN9IX17QZHPifa64Y9ZoFQV+sQduMyPyiT1A=;
 b=E6HrCuiRWD4c3fkWanhdhaZjFuFdPPVFBO/17G/Bz/H5tmPyq0sXAXSlKQ30/Ples0xXF6AVdPzrqmekfVh7jYsQ8PMdNsKkKrQxDhxwsF7mAcJIq7WCIW7PrqbqSkW/+DZUC39qgNfkf/SxaEeA6RM+Ab42M+UN1C3G2Tg13QoP5iBIE/e/e2o8TWpT0o/0UiOvrZsyX4Nu7eQI3fzZcnqFnCPRjy+UnJYafSVXsZ5pkxtrwMsigI+rElizez7gjXeh1vHo8b4qgytzTGoqmczIVZinoYr6TcwDC6b1zDoclay3IZvCSr/XQl9xpRlXsBLI7retI3WJVvIDnP8ZAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YcztP/JpN9IX17QZHPifa64Y9ZoFQV+sQduMyPyiT1A=;
 b=GyCUWENxu4LaLQJ2g+RNSfsRXY/oBzvIrCBpWfDpEHGbZjfsxKgFYziPXOuh23qYAmmNOe33q27P25H47j6gb53pjCFJIeBJOJ8Sf6QTcFGWkaLjEEV5LaOH8w7GR4/hIpJpc0UatIgFCG0YtsjnxolYt9xzbRkL422xugTNxZw=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 SA1PR10MB7709.namprd10.prod.outlook.com (2603:10b6:806:3a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Wed, 22 Apr
 2026 00:48:23 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee%6]) with mapi id 15.20.9846.016; Wed, 22 Apr 2026
 00:48:23 +0000
To: Phil Pemberton <philpem@philpem.me.uk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke
 <hare@suse.de>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] ata: libata-scsi: multi-LUN ATAPI device support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260420122321.4161027-1-philpem@philpem.me.uk> (Phil
	Pemberton's message of "Mon, 20 Apr 2026 13:23:16 +0100")
Organization: Oracle Corporation
Message-ID: <yq15x5jn7nx.fsf@ca-mkp.ca.oracle.com>
References: <20260420122321.4161027-1-philpem@philpem.me.uk>
Date: Tue, 21 Apr 2026 20:48:20 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0323.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|SA1PR10MB7709:EE_
X-MS-Office365-Filtering-Correlation-Id: 44a137ad-09b4-40fd-5c71-08dea008dad4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	PoVbh0U4LIJ3iTk8dOiLNg4Thmvs7qjPoNP84LZmLuP8/Jqmz8iBYUq7dWiZcOTbmwU+ZeL4LdBnMhCj8bdKR46NkpMXaC6OzM/gsh/zOInjsPxFVhpDgYvVNeU6aIPQ0b5KPOth49ud196la8pPiGsYE6fZzg6LR5/RI4aDMIH6yy8Kr9cAXU962XWThMQqJhOP74CK/VibyzzZBH4bxr/H4cG/P9ERTF2i2lsmt1J1qEcnb08UO4rN+MrSe6J+EYUc+O1YB/8fbm3fcMCB/I2tW7luD5DI+aa4y/cGuWF+vYokxmb6pxErHP+PisF3Db70Xff10pbujiG9WnoICI/oUXYWsxqROz3/jK0yJDiKX1MM0dmHoEXEQRu4yl+BZYKXnacveDWNYQNal8kNwr7T68hAP0AEeFMbR45eaqF+7fR8cvV+g9Ov60SNI5VMxXLFJnnBC4kAY6mOIiQ7PeqOj+vW2C8tt9xYZsKuhNecNioOq3GTXJXOCezSQbFpH99cF7V1W8aF0rvgZH36LrqtEbVpbMh4nsgwmj4/9ZTZL131udYvBsTTJvRU00ia3KxImQJQwMOQoAyxmiUlHetw/wKPh4Qe34o9/vKRgEmx95HLB0S71QUPecoLuu6bwXAuE3fZFNu7W4P3XWjbKdVUlKxfs1nOzFdxtVufnxRUUyL6sd/SXXpxqAUNv7vPvdzBZ0aWzn0fg9g/a4I/ng+vCF1IJRxxjFcOh1FleLg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Gn9yRnS/qyb5vzYsxn0738sq1HLz160UuEzcWFx83X2nWbW+eLSl/KzUxJwm?=
 =?us-ascii?Q?MK8Mrk+yZW3ZvE3OUhLxz0gR42QurmUwodNHARA5hzG8b/zln3ej/f+dx7jG?=
 =?us-ascii?Q?SChQfg8y5DRA1YImbZD3fnkrh5ZgOkEZ1IUkEp5z1uQ2iROFKKuXYb2QrgDC?=
 =?us-ascii?Q?hkD97XEDaXn2lPm3hOmod2mFuC6v8jqFS5aiI0623SpTEvDFkdGxFFF/1Uia?=
 =?us-ascii?Q?s2RtlijnHYErSpux0yswtINJ/7zty0oTdpKt65JWGAAB9hIzX/38f2C3bdo5?=
 =?us-ascii?Q?utb8/NafKBKWvP+muUpUOaUiW0cvnsig413PHmuwVms8kfroX4nsSpGimux+?=
 =?us-ascii?Q?gkHVudDLQqJgXHD3w8No5KzpRMizcAlvk4EpQTRlH6bU7QLfPzVOinEr0ME2?=
 =?us-ascii?Q?vnXXo7SDfOPjxQWM0hZEEgqq2o6ePmGjsEqnd+WSgeK2E9RW40l243FOTEuA?=
 =?us-ascii?Q?pNi9AY9MIYN/8jKX+piR+hbnOYt1CNXYl2/vvmz98GALCosPQjLmuak25b0G?=
 =?us-ascii?Q?OBhl7ee5D85c9TZ3IOEJRCNw/1ZlWlToVymV6VeZSt9R1fggwoXv+9FvoUVa?=
 =?us-ascii?Q?UbBjvzfvzlLCRF9gEcaxbQZdzrpwsoPvGjOVdWgncItdnfxBlZVeXLHVIe6L?=
 =?us-ascii?Q?VodpF5FmQBJyNl6IIHUb3bwlOQYc5GN/7enZZd9EG3WELxkl+yVFMLJAdvWw?=
 =?us-ascii?Q?hR2C8vnXpjTrZHmFfXm19YSDeFyAwo+i+hk9cXaaVkj8YEEWeJysRvTDk0hC?=
 =?us-ascii?Q?yph57bqdSbvU0jUaMIRVq7bT8furwkmB90vOkwlKoTMiSE4pwUUaAKIEtSSI?=
 =?us-ascii?Q?Afw+CD2cwSUvzXFe2puD4pphUSpRrSPG7sEZMaGjmQ7mc7aHucvo4yd2Z5GI?=
 =?us-ascii?Q?YhcwS7xZQDQ7vCUxB/RTYHp6zuSATWUsy/MGnY3331Uc+skwk+udgFZvbAZ6?=
 =?us-ascii?Q?Z4hdYm6kZ91KxPFJ2B7jlzqjqEgYFBFLq818Q5RTXw91bWeg3E649HVmU4VN?=
 =?us-ascii?Q?vo67fY695O6Fk86vxpwiCiI7/zsOZheTu43mpN+vUgXsLm50TLcPfeuzR8cR?=
 =?us-ascii?Q?Y5UuUwq/jx1G1+mVOREMRu7ntxxItXSWQhKjMQ/dxkYn+/KSWHiOO5wxX+a8?=
 =?us-ascii?Q?1i668ELqNr3H/3q89U6Y7xnk5lC6hsYUo7qSFjRR42TAGjHQ2AYt625R/rOL?=
 =?us-ascii?Q?Ds2H9Tih/4UY+mH0TI29JlEV1n30GdXwO9tbloY7kfcwRfPmArZN6sHfSnVw?=
 =?us-ascii?Q?WivIR6W8w36sPUL38LGib1wJ9Y0QpUTlHrYfsTw9SUhhDh3rRmi7p3w0kxk6?=
 =?us-ascii?Q?87afud/DhSd0pFiN8d9oobZzUpzPdioWNdZxRNn1JJ6QLV5cDNsQpGAQeZta?=
 =?us-ascii?Q?1tzAaOR2EP9H09wz+hlwE3mC9i41fogpaDZfb1cExbE0IZH7Q4FJ1gFaC7oR?=
 =?us-ascii?Q?ZPgUB10tm+nO0N5mwVNTc2ylUFsHUjlLlAW/JPD4sGGxmlZ0n2T4NTkqnRKL?=
 =?us-ascii?Q?joOjLp/t7qyFLLLch8rYRKou/bbxEzD+fc6creLEJmXWpYffqt379yhIGlW2?=
 =?us-ascii?Q?rML36UWKHXeD7SF0j/d4Tbt1TAoTsWSI0d1srFr1CfWACgqyuG9wU+ypnL7N?=
 =?us-ascii?Q?abdRVvMTmKQyco9AObf2dlkQBYsgWE8KwIaGOAHIsF5OOYdv+P3f/8mgVHJe?=
 =?us-ascii?Q?lxJed/4QEDaCD/GOykg3o82oMNLjRJHBf+2M28WPTmbFunflJ88icoszWpmE?=
 =?us-ascii?Q?lHJ8sbRTHC6gdW+xvhbTkK+5r9QYLy8=3D?=
X-Exchange-RoutingPolicyChecked:
	Z0a/ThBmfOUEoDRqP69MqRE6cqxSLJ2fIz+Z7FmCmYzDY01p5PvfBxyvbNA9IvyWnC1YptNBodRrBfjDakGh7LnBH5UL8gJZ7YafMUwzEb9D7P0k8Yz+xYhoRQ+YGKjTslkdlgKYfd6TFb+dRa5Bty7RnWhcBwfmOuZl5e1rfInHU0WK+1nug6AIgVdc5ZNnww5QQZmCGGq094BnFxeLcbOzkpuNhAHI5lSMTAFUj4CLaHDPV5Tp19t9UqSM03M3z2RLk5b3bP34ekIXOhz3P9GebqsW7NxyKRZxTdLXqlcs70Nzvg9NyxKfO79Qj6BFPL//65cmbGIQRwnP6GKCMg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	neRrKzhmYNXZw9idZGhMZZrZgGmRqrLpTituS5vBE8KXwTdYjztqh4GyGOCdllAuoSYQFQDWqMhJOViqeerDLh7/4B4wviqUaGS4msHmW/9tDeD1clfkf5bDGeYXLOSrYM8n8VAz4DHJ8DOB4p1oTv4XW2G/T26LEoI2NlUu03v6XM6LO3V2RB3vU0T8tqqnRvmNQbhJkL7zRO/5mpDNljhXd9hT0pJGwVfcAHcYwNnbRzznqYdenynweAbRm9Xmv1gYcLHq1kCjwG/mj4NltrCuEMA+eosnehGSdBX5JlZR7c610a7wiJG9mz0qplOsLC+AMvsGaNhIm0BIgmN5PVjWNwwqfy8XlQOfRoFbQDiIHpIOEgBmEkekIkTTkNDzqxNQyib6+l1BrbSUFph0Ef6e2XorHi5X+56QztWxFxXiAvfD/MZZmxL71iKQTs+C2kcI0vz0zpw92quj4aVys+kByhdRdTE9FtfgOj4YdVmqgBXRN0VoU72bXSVGs4NE0of4KZa7DnlZvTimdmR7e8kUQj3aX3tN1pKbHzvcgvvFK8atA3LXSzBjCM7bUEe6X8och4s0z2r/36TLah/zsIxli52Jt4urBICOxwjQJwQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44a137ad-09b4-40fd-5c71-08dea008dad4
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 00:48:23.0777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y3yIRVK2TgPbA7qNgqxYlg3DiiKZjXWl1nXHvVubmQoT0fgiSjpKTdwT/sdt9yADKdqhceaAQiwrKwvb3wTAWSvIjtzU73HfHb7HVYcAx34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7709
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxlogscore=960 malwarescore=0 phishscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2604200000
 definitions=main-2604220006
X-Authority-Analysis: v=2.4 cv=FNUrAeos c=1 sm=1 tr=0 ts=69e81adc b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=WGmGCLtV1ihz7zY2cJAA:9 cc=ntf
 awl=host:12292
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDAwNSBTYWx0ZWRfXwI/C0CNwJ+gV
 f8vVXuBgaIJn/z58dbCZESTI9YXEtdE23xlR5wqeJvNdfPZcav5bFqWTuLI10Vx9zykSfR9YJaw
 +AQo0j8/fUFBDr2u0XpHtaiwsNaNBfWnoK+7Yj9wC4oe8TF3qP49Srq2V8odI6uKkg1D+qDVfap
 C0KeS3Y1gT9Nalb3VAZEm9CuycYSXMpQNxsjknX+MdhdxDmcHXRYtTMuBJKlgWIII33pqAT8hyH
 pEHwbfUU7+XpOjXg+bDNpW4uFmKnUsnq7BRRPFrtfdk1A4CvMQ71b05T8VxZFCNQOpbvzm0cwM2
 ZFCVsqQq9MqZvLCN0O+zCsUzJ1fMiLjR0thIBsWkqbArV4ERznB1xU29uqlwgLo++nQIci0VwzC
 ZIqKilB5XPL5xviQvGQhc1yUzynO5CEVPrzynYq5jwnjAN5hXoJGonOtiPGaTCt8Sxl7lZHQj87
 TpopVZ5a4MHTrCzu/6x3ibQJXYzqgkQFdqGzK2Do=
X-Proofpoint-GUID: lVOEBulIv4k4h6TDT2GYJ0s8CgQE3iJg
X-Proofpoint-ORIG-GUID: lVOEBulIv4k4h6TDT2GYJ0s8CgQE3iJg


Phil,

> This series gives libata support for ATAPI devices with multiple LUNs,
> such as the Panasonic PD-1 PD/CD combo drive. This exposes both the
> CD-ROM and rewritable PD optical interfaces: CD-ROM as LUN 0 and PD
> as LUN 1.

Looks reasonable to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
