Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B601922ED
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 03:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753154042; cv=fail; b=G/8O/TJcgtuk6/YIQ6jnCPPuACamonX6RQxxKQSEd8V6XJc7FQCg+zNHdJvJ6bKD9Vfupk26SjqIPz1uJ67+RcJ8OmPcjANJAnA/APnpQfyRaU9iMxBb9GTVwG/XMO6sBHRF3LBdDfwrx31fRoi7RCKmTUm8vXbkIWxMLvoHAcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753154042; c=relaxed/simple;
	bh=qjRaH9QfTb2fotw+SabNW37bNBohA6w2mFgUCluo7lY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=FmKWN/1FfaR5ryRkblzIr5wt46Q/PGPuZTDwSf6+t/mhPmWIeJmVz3tX8B1rceaakUQMedxB1+iXvrYBSXOxTVpPE/+aO4YVfFsnV4Qkn8s1b4R50slRfQA1B9PbyPsFo7+8otyQTO8f34GmSwq72TVCVBvu29SiGtY4c1W+ZHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pHExiOwN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MLpwFwTM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pHExiOwN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MLpwFwTM"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1C54T004795;
	Tue, 22 Jul 2025 03:13:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=gUbzcTocruyp+Yo11f
	sVFVXJLmbMO2D2t8JDi0Szblg=; b=pHExiOwNzioDNrQM+hKMx/7gaXmYqXRnGL
	TDnn/zJ1cZ9XXU8iJesnV2qpkw4i/Zb1DiU2FrSEd93rvYYOoWY+Kf2EnG11XNII
	Z5NPLZjppXvsmfw5S3NX3V0PQvagbSmAaSnDoS8fcN/3JYgKhzOSZZpOTIOe4y+P
	7MCAFD9fQJrTomMZofAGJkyPiYZNQP814msJNGZ9DSaw1zveeERnrFaqT27C72AH
	ULrLEAD2jp4x9974gqWPKtOo37VqSiuSKdIH6OmNRrlR/aQOMzMjA5ZZiqCc6eEX
	dVP3Qg1cVhfyWrAEwvEfUPjODwBjRyodaVNk3F6XQZRef9ptu7LA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e9m9pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:13:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56M0GGu5005769;
	Tue, 22 Jul 2025 03:13:50 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2073.outbound.protection.outlook.com [40.107.236.73])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801t8sgm0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:13:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GQIOqRRDhGyhZH1k+mqhgrnbCydvdReG/ZtxsgAt8HtRz2sCHwp3TThYYsLLOvV0UaMFWUlOY4INzUSN6z5zFoEvHmE2AZdRSMDcC3FIyrpLeGTPay8oZ8D22cY755MDD5W3z6srCn1fZJe1OQDP0xqd8hkI0uRrOiUk7yYZwiyYDQfjT7FYtLvPkcB2akNGYlCEc9VUr+mBsFwrzylybEWtupgmcdQkJiZ8tLc8wNKw5c+69neCv8wDo4TovwIJAaopHiu91g2kabDoWM91K3P2di4ZS2Kdxsu4jp80ux2yMbQ66lcOyqmc1HdOh3u6gzy5KcI79P6wbQfGsVgshA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gUbzcTocruyp+Yo11fsVFVXJLmbMO2D2t8JDi0Szblg=;
 b=y02QFuqpMpJYT9Pf/q0NEeOVU3ojq3rxHJbLie9dnL5qwkuxjf1btwnoV0YTpbjNB5JIOW+A5S8tAU3LoO6CAw+mGO0VakX6+0FQhns5TjoX6lWVqfnuRKUdBttxOrWHXrP3QOWDrCc1BLi4u9nvJiYVS0cJpgMt7PyOEzjrdESZ6Uzi33iWuFsQwwttgLUpPRgU2OXz8cvIGgnMFJS24dHLiHsoLrtH3oI89io7+LYvp9GUhsHE+q9mwOfmfbE6rZeN74LISU1+gqXqekQoT6jisI8xxHxXYOlyNaVOhLTwWtEGI7Hgrd9JU26Z9w2NaKf+/LbRWKU5MfV9yEFJ9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gUbzcTocruyp+Yo11fsVFVXJLmbMO2D2t8JDi0Szblg=;
 b=MLpwFwTMv+fWRMYbXH3sRJVAWAjCcpgCn+1Eg2ZZNbC921FoOVN3TufZejojKnYLD7mZujCAY0TPP6QxyiM9px0e8tSya2O6MHEb/scXTxTn4TQLhKB8cz7Qi54zl8O/W/1Trrt6VHjNMZkWuOdd1ztXMGmhrON/4MKrUFiCVZU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN4PR10MB5576.namprd10.prod.outlook.com (2603:10b6:806:207::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Tue, 22 Jul
 2025 03:13:47 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8943.028; Tue, 22 Jul 2025
 03:13:47 +0000
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_transport_fc: Add comments to describe added
 "rport" parameter to functions.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250721164652.335716-1-emilne@redhat.com> (Ewan D. Milne's
	message of "Mon, 21 Jul 2025 12:46:52 -0400")
Organization: Oracle Corporation
Message-ID: <yq14iv4yl26.fsf@ca-mkp.ca.oracle.com>
References: <20250721164652.335716-1-emilne@redhat.com>
Date: Mon, 21 Jul 2025 23:13:44 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0086.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32c::15) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN4PR10MB5576:EE_
X-MS-Office365-Filtering-Correlation-Id: 50b7242a-381b-4a41-2422-08ddc8cdc5f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NVRulIryLD8bAtlsM6DeqYGjXrsvqMOOuPMVkO1D8VMabw7pZLeqrP/0Vmv5?=
 =?us-ascii?Q?PwRB5sfAvMhzATM0qxPEA9kgcQSB4c0HePzRJk6it2oOMPcon6Sx61Jr6EyU?=
 =?us-ascii?Q?yo5CuXPvUVyssewtXJn4BLOT9/x/3VuglIdxcp9UPAhd/vaSw44e6MLWkQdU?=
 =?us-ascii?Q?NG/zTPc0LCeogBo+vNWMAys+Hzf/AdA3C3Ye8KxVhzLpM/wybMzkb9Lb2wZ/?=
 =?us-ascii?Q?t7qQSYOGzAWKRKfRUoV+DlaNSaATr18mrPlNMc917bPTJ6LldV8rqE8QSobd?=
 =?us-ascii?Q?ARvKCcrm3cUaOjo551ZvFeorHW1/RfvGB16wDtf+BgzJs8/9W7knhZ+w2JvC?=
 =?us-ascii?Q?e9X0iDobnAd1/TdtV6xiROc0DwJpk41VDape//kIYacKjnrRhyylE2KnELZY?=
 =?us-ascii?Q?ZJx98ur0xhJZdXtRWD8uuVKBxuNe3mpS5WOtSw7XnenGJokfsS+TVfOSM++o?=
 =?us-ascii?Q?dwNzNp9FSetg7s4cCsdwN3F3s2EQhUVtEw5C571LX+lp3JKeq6NVcPEk0tLH?=
 =?us-ascii?Q?UYyIu0JwrDAXAo8eeRZpcvMAA0mernk7aOFa3OeePWhjnMnorxEazNYbJngA?=
 =?us-ascii?Q?fS/WsNLTae9cnh5jRt+8oL1nlRNavRBWq5Y/4L6pagVHbpQ1NDkmc0+ezdIz?=
 =?us-ascii?Q?tV4C1zQbwgBD0IeG864A4kL9TLpCAJhxt3q27aX9nq/I8yhs7GMQR1UrvGPI?=
 =?us-ascii?Q?+43TIHw6wuV0BpDEhgdK+TGDTRoxk4LD3CrmjnNT2VUts9MpJaAGw1LNmbMc?=
 =?us-ascii?Q?4yz9aZKprzlL/QBv6n/3IuEAWYxXh5ID/pz8raAoZA393k4s+VIjT78eF4Dz?=
 =?us-ascii?Q?TIPb/fo/czsj1925BeP3ZXpSmaZUJ5EmvI8Nx6OK52e3I/tvKLtFd7ccv/F/?=
 =?us-ascii?Q?Tv+NFU6tO3cmmAeDPvy2djGbF3spaqG0xkwGk6Mnu4wQDEqmJCH87ikpMAMZ?=
 =?us-ascii?Q?vx7BLyzNM+u0xDn71Xn2vG6RBgWq3KiKKmW19lQs53SK8/NreVqPL+U6neB+?=
 =?us-ascii?Q?XtLf9x8wkgW6IlhmFe8eN6jsCFc2PLdFnMGiVyY+O69+XQBSSFZt4HTdXUZp?=
 =?us-ascii?Q?ioLenTJfV4KDqbWnXrYc0s49OFkSrg8Hl9Sfwn9iP1Xaeuu+sX6X0AcIbIGU?=
 =?us-ascii?Q?XzZos8HicAbX6U2u8jXXLjPfgbdiKvagsz10RmJE0R3nbwUapthvf+pfOBfP?=
 =?us-ascii?Q?ql8+w/7FJeSIhVddTNfRpnYkcG9h/6GSsZawwp5T4vlU7As2LL9U+a5GCiwy?=
 =?us-ascii?Q?0QnVyrGJT1DHcl1FQaiuUz3Zp2Oo1f7QikYmmi4KB/vqFgNmtw1vJSNazUnQ?=
 =?us-ascii?Q?rgnTIlE1yosflYaSFDF+8HPW0JDsgfglWxuCP2DKCqZHjx73D7/+KkuVRzLm?=
 =?us-ascii?Q?PQvcryAY23nDLuq7WCnkp4JuV3O7zoAhhBj+HTkv+W7EZpj0VPlhdqardBtk?=
 =?us-ascii?Q?WjSEw64Ohu0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XALHDaQC6TWOeNO/GYPC0ti/lUw6lIplx99t/w+H7iTk++PMx2UxYLMUHlmr?=
 =?us-ascii?Q?VmfioVstxX23I/r8W3+HNQFpryGshgvQ7Zi90aO9tSjJwVgqLCVTdvtTxweH?=
 =?us-ascii?Q?TFK+NBfeNiKyh2pJdxWJ9EZeVY8AT1NNzH4uFrBwoHXSqEqxiQb62PntyXX8?=
 =?us-ascii?Q?tZREP3pHlm03soXPt9ev9bqsQyirKh1srrwTCKnMxv89rYGAhRwHxGpqD+SS?=
 =?us-ascii?Q?Oj1XnTzANptsu7a3VZllYyE0cuezxphDXWoSt3sAU8Z+nsApaZwJOIT7rWb5?=
 =?us-ascii?Q?LWmlKZ4XDGeYcCIoii0vGua1XeA054QDIxQBr/LRH/S0xRQslQMLxPpoTb6T?=
 =?us-ascii?Q?c5tBqHuw6wx/KlQ1nrnSCh3TAKdyYFEj81xGZQvvph+BMciQPTslFnWXO+gJ?=
 =?us-ascii?Q?E6oq2ZyzWVsZ5G9aC9MHP7Ve4CFznl4vDBMODyRD2dmbgcMp00JIcwkhoi1t?=
 =?us-ascii?Q?OuCZi6es/sIaJZSs6G+GlSdQ5iw9cwa7in8fkX3y4lvYR/R2G+C2ahk4WQox?=
 =?us-ascii?Q?YITbXr7URx67q9esWA89WNXBfV8YDFPgEGoY+BM527y9XFxekOoOG+ffAS/s?=
 =?us-ascii?Q?fCBY3tauqjCEr7Q+ijmmcXyKvHoN8VBDVWjWKYNYQ5G/Moa55wMIBnQuPmdK?=
 =?us-ascii?Q?xCjFUifcOLHNQ/YKU9OYnb26HNRPC/ofDivm724mcutvoVUZcOXkZhBPXIM6?=
 =?us-ascii?Q?lzZITrhNpmdE9vLrLmJ38n2unc/Dm20B9n50MZDfVNoQVzlbS0E4iCxMmx2R?=
 =?us-ascii?Q?ggcpd1DZ9STZ2VqEVt9KtxsytA65mJbTrSktsWipiQdPkzAynjzes2quidPu?=
 =?us-ascii?Q?Nl4rHZAwb6Xt4cCjPdyN96qZ1TDTWUmugfT6jZA746Jm2rav6Er9dN9QBAea?=
 =?us-ascii?Q?pPCr1h+IxKWxYpuODfW96tDUppiaAXKPP5UPeIkxVw0NjZ6bq3LvjPrCwX0a?=
 =?us-ascii?Q?5oyhOKpzeahT82kbsjvhbYdxb/E9H+jnShNSKg95D/hVMwzh2q9BOdZx9pK/?=
 =?us-ascii?Q?rMNjVZX5tMz7e2jyNJEzLhg2Wjnq0fBonjBPdjy7eo7CYMWAddqOHQ6LF8th?=
 =?us-ascii?Q?+bbyIGfGEVh78UyO0sIvCJ+mIpiA8EKxgei2R+SkM0ho8rqJU3qhsg6ela5P?=
 =?us-ascii?Q?+yvdoC+BMGD2/YLJYmCXDCdKd8clqxdo+9g4Q9msA4sWaisVZowo1M4vuRyS?=
 =?us-ascii?Q?Igniq5NlP5eNw5gWfYyMtL3WE3bZk3fGjjYbTmGJcCgc6OdchjwdEXvt8tqN?=
 =?us-ascii?Q?7aETlIWDUdV+yedEDUlr1VhDHWUiroMUz1sXTp7ZTqjzNNKwGvn50AbPhLuK?=
 =?us-ascii?Q?fxNU5ivC+XyyT5lZoWmIe7qOYuZuPRR2KSRvSRiQm/CCJ2snZcwecTtegAew?=
 =?us-ascii?Q?TAjYUQ9H4vj7MYEjtYoqDzNuLM6NYqvDeIybhRHo3R5zvxgfQPG45r8mcxxo?=
 =?us-ascii?Q?aOChVrdrHahBF7w3jL6x37mhe8Phv8zxuunAKwxLdfiUmaGD/W6UE3UO9tz1?=
 =?us-ascii?Q?wwhBR99K6Szj1g9KFc0Qvgk9fRhQf+koz8Wa5CS7Vw3g7iw6N71E55pkZqKp?=
 =?us-ascii?Q?JH4PUMKpac7TjKCxCSXh/vBdegGldrvHXC020NwYtm/CxdzN9drRcElM5Dgz?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vGaUhSB54aVBVewI88FQFJhRBIImlipV6R+hXV7fr+vgULnpdhNHpLiH6J4W1NNnz24MUhCsOx9ieyWtR9MReQiv+KOIJ+H3ho9CZX8tkB3uFYH5UjnRZc1tKn1d3Uf/5rY5AMQLo8hrTABrk/fxotktAfWgrqQUOntXVb2xQGxZINl5E35McQdOrAdeM5sz/Nr6ymjwdbfGaMjxGSfnU8TFFGXlL6BJQfXjvw6PPQk3iDUXTM2T6kZXiksgt0P80Hh3RebBZXyMyWHGjiEUsTaRG3EmYZC0FGLo12xWHjky//jS6pcvJG7EPin66uo1aVEhezsJTJN6cq3pZf660C5zr1yK6jIBa8WdiMI7VZ4Dk1lLFQ+ZnyZ9OedeBoDSSmMQ20dBg4X8TK3TyrgnZiXpnaR3Tr3JB4bsV/+6V9ejEraoJKd+8La3ZughGxMtcCKhSTIB8wgwl+d9tkDaQarTnKVYFGZ+KFmubuLzBy2709M0svvBTDN4Def+jdCWxkaFjIJnRwWOopQQ2md0WbLcMKl2knPEB1hX7axttlPGD3o+1ABBpksOJtBebgb4qX0emagoURQ6MzWepnEhIGAS9AKWY9cjxSvITdoVagQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b7242a-381b-4a41-2422-08ddc8cdc5f6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 03:13:47.2959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5maL2yxYMCzFr0ek9T2Azbma9iLwXvayAdK12Lczl1mVOxDFreZja6lZPk0t6jWggIrj8b51D0a5W/AUBRjUyYPK+RMIo9xebomefCiuRFc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5576
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-21_05,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=922
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507220024
X-Authority-Analysis: v=2.4 cv=eqbfzppX c=1 sm=1 tr=0 ts=687f01ef cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=cewXuGIsSzsw8c2jRYwA:9
X-Proofpoint-GUID: IHkcqItzBzrhk07WWo72dnt_Rm81D4MK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDAyNCBTYWx0ZWRfX1e4gw6hPzcPg
 yznmgZiGPki5zsEmD7WEL6teR7CIeHoWxOKLd+t7imoeaorTvrlfS+17lkn6iFnfSWCzZgD/ZKz
 2trpsLnPG75Yv3ayBdJARMjaVzV7miIlI2KKg6P362noPjvAJc+1CYiPlc11LA9K+PoD+/IbAHv
 Bze5wYNuR4XwmpFnaMt5cokpf+RNWuTlGSYMaBPL0KiZf1hnzVvXWI0rIsJ6L0RWwD9dI9K1kdQ
 YqehKB5uAhmSIbSSNcUankZsm742bUthhKxAMtgTIo0ab8ObLQ1AbUprDo8JQNzNI8rV4FW/4ET
 VNUsreo+Z3fB9G045E1gzcFBo2dMGb1Z8eOQ2M5hyGf24cufpyewGbPapUaG+f0DbdRARyrfer2
 dZOkdZZfZK1bwP3RaiN3bu1u/ZAoSPFxkJF942xfCCtCpeNxeWNgQ9AGK98IdM9ROLhTZZNp
X-Proofpoint-ORIG-GUID: IHkcqItzBzrhk07WWo72dnt_Rm81D4MK


Ewan,

> Note that there is no executable code altered by this patch.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
