Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A90917BCD;
	Mon, 22 Jul 2024 23:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721692570; cv=fail; b=aaCV/tIGePV6qCT7m8LvE29VjSwoKVoQfn5xNs4TtaN555IvfmxDZqmU0RqRrLHq44cx4YwMtA7rMlmbYGeqhnr/Ya6kCnNCXyueOGLY+W2fnfXw+buS1cUe8a/xAHxDO7sevyejSo1A8cUXc7rpSIwKbxMvwNR6H/y2pCD5F0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721692570; c=relaxed/simple;
	bh=0qe9xSgCIZ26zY6QaCsRwf52IudjAdi/mpfgSIZVcTY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=aiZRPrrD2RdIj9OGS6oWLbpVSOtOPhBPYdZVGMQqxWGVuccTT1SAA0Cxh4Qu9rnCF50cQo5b7QQz/HgpMZrqEDiAF1KIIFTZRAZ8Om6XwT8ZCaQvQTYqk6MS7YMr2QtDlW7Xv2aX5UcCx+FPhPEu29zv8HYYiq4a5U69aTkLIGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LPO27y6x; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kRW7SZgg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LPO27y6x";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kRW7SZgg"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46MKtXww011153;
	Mon, 22 Jul 2024 23:55:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=8ETxDmt3Noqanh
	Ss7LEUeRCBLZixLum1QSwb5GRPjeY=; b=LPO27y6xhStopsUcNs9Cu83h4C3mD4
	mGl+fLrYGE3aCGA9rY5ztn7m4XrUSIB3KKOJIhQOoEEF0cJ/TBCVfe85VMslgI0o
	64ptQNglCN87jDnEQfQcGqRtqkXmslAJJfNmLrhPJE1bg+bRlitCdASin024huby
	VAYMBTGFzuIcAnPfebCryfizhAYJfehIAmRUoDEFVmiD48hHzDPCefcSYgYV/VUK
	PBJhX574w3q9NknsD6jRcDRCYqmoM8NZKb24KYUiRtSmLNhOYTOiNv4ni7cMFJEa
	wLiQU9i00pfDOjz/XIMtsZQv3ggZtcvKifjPzGXknWBzBHno5cDdmiJA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hgkt41uc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Jul 2024 23:55:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46MNXUeT024620;
	Mon, 22 Jul 2024 23:55:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40h2a0ph42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Jul 2024 23:55:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HzMbTpNzC/QMe2Xp0rR69Txg1LHN8Jz6U0KZFLFj2ac7V559PtGvfcTiwQB57RlTgzYsS62fYdORpQUHwlR2F0u0vwmRblAjRXNcaqeh9EyUYEXs86GjM2C+BRmYfdcxDnDU/lY4CPdb8SvwtO86eKhuII0LEr2rEFG419uFb59VY/iZ0lETs4MXylc6PjRdiyd+72oeEzLE16OBFhfy0qMgBtkUZOgIklh3k78tGmZgqkwH9P9NUzLydWNdzqZYmTcfxBRLRkAwrPO/6b75EGZ222aEXaV5J0kMVApB+wRFwHeZMdQfX4lhxqyK85UBp92998PoVYUjOK2Dwo7/Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ETxDmt3NoqanhSs7LEUeRCBLZixLum1QSwb5GRPjeY=;
 b=sm8uDs4etnNmMKpoIQ8njfQ7wyLNSjf7OmFC1gNr50q2byyuzSoynUNA6SZuztsK2PmqR0M3dLxzIJy3ZOk4gaUJZpT2DsO+GDWgfVFFlp5knWvCpMwo0A+dooAxnl99OB0Z1eCAsvPQYEfWJrZ0i99t82kjJMwnkHY3SYKSpdnr3wl6maGrJrrDGQc6UbnA0AH20RaTlgXEUhNhniv6kVXwdkLToBZ+EtiDTInCLguJLUCN7ukU5XoJAX7TiEQfPdmzHz8/Mdu55xDTnA6mRq38jhtF2swMsosgWVZ3bCITPfVuLv3i3deWC+z+p5GxmkgWs3BJi2zMnh4SuwZ2iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ETxDmt3NoqanhSs7LEUeRCBLZixLum1QSwb5GRPjeY=;
 b=kRW7SZggjjU3Kvdx7m0OGkTZck5hCaBgvtg2CbBd7wSXArNDwpPauCUXqkZD684I8rVHLSOnZR4qSgbyVtYJSGmR+T2gjk5S77LjITWuEk7HA5/iiVep3hPNurYMXHE+3aCX4d/3/mqR8WOmjloVY9fzPw4McfFeq8hUVbqljVA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CO6PR10MB5554.namprd10.prod.outlook.com (2603:10b6:303:141::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17; Mon, 22 Jul
 2024 23:55:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7784.017; Mon, 22 Jul 2024
 23:55:53 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Li Feng <fengli@smartx.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        open list
 <linux-kernel@vger.kernel.org>,
        "open list:SCSI SUBSYSTEM"
 <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v3 0/2] scsi discard fix
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <c1b47037-4754-459f-9e8f-ae4debd3fcf2@kernel.dk> (Jens Axboe's
	message of "Mon, 22 Jul 2024 16:22:25 -0600")
Organization: Oracle Corporation
Message-ID: <yq1o76pdltx.fsf@ca-mkp.ca.oracle.com>
References: <20240718080751.313102-1-fengli@smartx.com>
	<c1b47037-4754-459f-9e8f-ae4debd3fcf2@kernel.dk>
Date: Mon, 22 Jul 2024 19:55:50 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0023.prod.exchangelabs.com (2603:10b6:a02:80::36)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CO6PR10MB5554:EE_
X-MS-Office365-Filtering-Correlation-Id: e270f33d-b1d7-44fe-ebf2-08dcaaa9d242
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZBAN14xiLCuw/VXlMoKjCB5vXs+TWfebz4dokRRLEV6HdlZ523cxvppBY+mE?=
 =?us-ascii?Q?z/8wuseh03lcZa9cLSvqtLU3w5jWl8flvUFVvgY4EDvc4OdAbsHPfUNuUH/J?=
 =?us-ascii?Q?Nw1djDhPotBRTY+8wZ9jKJy5an90vtOXxq5V0NUEzWmWkKtTB0p7nntPuvah?=
 =?us-ascii?Q?oB0yzincJ90RA/CuuSsRvu3Kl92ymdSLTuFyu6KeJB60vQGUWjns4k/LYl+Q?=
 =?us-ascii?Q?bXA7P9swXQpaeJBkgFofO3XIQhRyZGpUTxR9cBBrv2aIw9PCLrF8bqaAD5XU?=
 =?us-ascii?Q?+F+sD6ZIXE2AwRzndi1vcI04FrkpDz0guLCbRtkwCzQBz2GDAcgFGdrlH9fc?=
 =?us-ascii?Q?Oz3Ux14MlYuX8o2Se/87xRzW2aUw7o1O16dH6SgctR54wMlPAs37hlU03FJ5?=
 =?us-ascii?Q?AzPqJ89WH7RM6dYPqL4JMbRX7YzQJNm08uBhEapopiY0IWQmubL1Iuushhxb?=
 =?us-ascii?Q?M84L43HmpO4lS+8uzoH63TwkSz/AHYh1gVFTligiN8LHcr13R4HuVXPBLMf1?=
 =?us-ascii?Q?i3OW8MQeTD0r1nRvTCRf4Xw8nJw2sICpFxeYTcs/GbsnWM9RCxPH+DXZ/UyR?=
 =?us-ascii?Q?ZsE5A7nPZam57exYJD4aor88jfBAFYDyPHKRerMAmxLCdqVe2eGz0+wXEbfB?=
 =?us-ascii?Q?xS+D0PaZXv5pmZkFM/n73jkNmgPQGIN6aG5Dj+gIXKd+x/lWyWUQGuru4Tyf?=
 =?us-ascii?Q?8IP/8tf6mvnMOU61mrRc5Gk72aikjkfqI5YZLBZ2aUzhXfmyAhP9t7k+JVCK?=
 =?us-ascii?Q?0BpYRsMX4ZUKoAvQ3HoZFMy7cCTfFxmhGXySdOqKpqAFaoMmlTwXpimg6wDI?=
 =?us-ascii?Q?Bo/7rvbkDSo8LetAkxfYzY13CFi+cga7rU7Dd9NOTBxT0msISfh0g/+AZB4B?=
 =?us-ascii?Q?DfO4UwAU0AJaHX/MNJaDVmJ+IWBnEldQPyoOkCDiJ6+JgC2N/3jiP9fyFvjo?=
 =?us-ascii?Q?obeFRnfo7v3ut4Yu2Y7tfbAUujkzL4WWChdJ8P11LUORkOtOrIzELfShb9yG?=
 =?us-ascii?Q?zTn1+dshm3wKN4YW7eszdKWYrDEcMeO5hrh6U6CBBu25dIegPoo2A2nUlsGO?=
 =?us-ascii?Q?jSHfslpy2qKnHGeK6A1GRvYfS/BX2jMp7xasOCPBj9MTM7ncQSVa6P6vKXxh?=
 =?us-ascii?Q?Sx+3v0wfvfsIBzBJDDJDVuJXotpLJ8h3+pYcmhIRMYnCj54thQ+mEjAHusM3?=
 =?us-ascii?Q?DMgJ7TbPHSuXn/JZHrxJ+Kyut1gnpBNOhhMWdscYJ/R20bwJAuRCNSs7biYO?=
 =?us-ascii?Q?kdCGcGsOmtJn9XZqJqadHfLcEcINKIBXSyDJ3zdHN0MVGhUGTSDkljv6XLpB?=
 =?us-ascii?Q?euPr902Mo44phazay9GLRqMPEfVVNQ2MqSS1ltDB+TUEAA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8NN8kqa7d72tx5NZbOK1xwiAB+aKG7MHtU4sJHQj9M4SE9NK1lpwctKWWkbm?=
 =?us-ascii?Q?8VTDKWurbYOm3Z0pVPcarUUEk53nv9e+Gxs9BFrN3X0tM/iKxt/oHHHKzx1j?=
 =?us-ascii?Q?/19f9Hm35os7k1UTNwk4Am3T2aJdnr1thgC0J/XsF/dBX7mMeQg3pLnFVpAW?=
 =?us-ascii?Q?XkDtcbXkT+fFB8TNHA0n2uGBT/8LIdAunPrBD5Akk+Nc8MW45MJNp2UNxpnr?=
 =?us-ascii?Q?TShkMhxEq7lA4jMCKw1ZLrovImLCX94PjCyK43pNLQqCGf6U0ObqQ33yErc7?=
 =?us-ascii?Q?Vc2MrBx6IEJ4NpXH+ClK9NvWRc5/WVQu9PDuGn9WcmN57HCZs+CljAl50uSh?=
 =?us-ascii?Q?wKutj/+TzMou6zOsYBxUvsZEbtHd4ZpXJZc/9rwqjnkIa2AJWaDz4VPkJr6V?=
 =?us-ascii?Q?GWpSG6NzsaK1zMe9eFtFKU/F4mqBnINuZQdU9mPgoRqCIh7xgYhKiMPppWy7?=
 =?us-ascii?Q?IpxQ3rUh05yoFBj+pVrN3DY1EoK+hhdj5bwtDIYjIVo+UsPKEfF4dnlH+6CR?=
 =?us-ascii?Q?T6pJSvRYqV9bDstVXt9j/bx2GzfJxUGFpVrKLlcLGt77zqj2NevVhnuv8xGm?=
 =?us-ascii?Q?UhFHnWSTC0DWzvKOQ0Cy7lIg3i+C7m01zbRO9ABRHh/1qtI6wsICBwUlmoNe?=
 =?us-ascii?Q?ZVmy/rslZcibjCjhFbVCwB30fGP2qI1tmGNFfbN+GI32qIJt6N+3XkKq3sw7?=
 =?us-ascii?Q?2KF+FeM4KEpcRw1eoTyZR5YDwkoefEwgHoj1CBoQ8wO5HjgEyZ7/S9038AT4?=
 =?us-ascii?Q?qzIRl1Y/Ol0oKFPrEOVJJp/mdue0bAjmz7By+fFIjHHMVyQv0XuP+cadcBto?=
 =?us-ascii?Q?aRNFYfVC7vgKWrEpE852kD3Up6fqxOzkMDPj0JAuVoIo0ab7v6QWwA65XMTL?=
 =?us-ascii?Q?IUlksqccFiNv6uJee+e7eaopkKQSYo3z/9IlR+3unhSGLTjLeNpHxVstvZVA?=
 =?us-ascii?Q?HEbYQDHGMHfCo5EzbQm02azVo2oHWsqKxuoP5PxhHIdRqMIKR1QyTVspFjXr?=
 =?us-ascii?Q?tA+Rm7nKzC6JvmTk5ALPOoueIX5LfAoQBAwW34ishkM4ZaJ4SHbnQDyoYQ6j?=
 =?us-ascii?Q?O7sEB+cyLiLHTg19sLT9nidlXXpVLMFF22AoEUC0vMEBXnyvmgjsk5+fkiLQ?=
 =?us-ascii?Q?hH0yHxh+4vy1msdhGWR17oMqOESnebtWQSDt6qZ1I2c0X1s1Uobr7WLsuSk7?=
 =?us-ascii?Q?mNkB11QvrOOvTND1sWEUDvTuNFsO1ue5/NXOKkWCwYjB34H7I71427aNIQs2?=
 =?us-ascii?Q?pAua8n759jU+II73qZjZNzVQFqNUI098Qq2wguKESvs1u7AQ8/iDzMl2R/G2?=
 =?us-ascii?Q?YxIU6cVoM8M20JIkAdX/0XRrDwvj7xnYThs7fRJr29PUK+LNS8tByayweid2?=
 =?us-ascii?Q?/PYXIZiIedvoMTDWG5Qyup9z3xZ9ahRWIum+E5FqbGYuYZ+unSlFr/0+8DWb?=
 =?us-ascii?Q?8gXOv/rFrd+flfbhtVDjQE4m/qnAY3RijgxePTgXD6/QcUckwwPYFLQ0jT4y?=
 =?us-ascii?Q?iossjO5eQ2FVoRw+eqsp53oHFZev/KqdIqfCwatis7s7ZQSg3TswxMd62bFg?=
 =?us-ascii?Q?SfI69MFMokBBI2jlshJKx6LIHHEci28hwJPt7UfOh6HKa9aDI77XqPO+d2lb?=
 =?us-ascii?Q?MQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IY/k8os6QuksqXkTX0RZiIrqH+Ep9drNiGLLHj4zdzyAgLoWQ5gjk/1Uf1ltu3NuohWwJzWYdZTIFGL/HNICOEOjHuYYvgO3UzPTLs9NVXuQTiEoIAbkSdHguiF5FQO2kN97A6XG/XaYWQkhfqdFLcfs4iHxlqBE93vDrjChqhPcW7q7y5dvAD90mJS1EYlW4plOELwK8slnPr0sE/LgDenYRuErJZqj+fZMEiJfusnHfNBQ/6wcEYWNVekXajhx9TkIIpFMBXnB9VUk1eyI4IT8z3w6+aOGFfppeAIF7ZUuKN6TZnCcsJ4EvfBMo/EWQL+JK3We3qmbkDSJOpPUOI242Dap6jBXI1+2nzkQjbxKXfyfRwta+DP6S2OC/HIlHDl4mOFP/etBMrbgyrhchg033wYKfGXzbN8fB5h99o3NuWdSGYQYTGG56XzxxTLOHSRU2s9T4U0mgNSdY6If43E0OWyGXI5R8b6xNe/SAGBVor6qFxoEZAlVmWV8XqgtltC3dTwYWs40eTwrwwTOJo/Cjufn09Wt+lojnxYQRlzQ0CuyZLR7/l4ioCFa9sYnGEldMwhf+DJm1kMw0UrvglHqlmsCMl9nXOvHSV3vID0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e270f33d-b1d7-44fe-ebf2-08dcaaa9d242
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2024 23:55:53.5004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gwaXSDeGFT2q9o0APSEAQTMqxVggvcSx+OYMWYkpTga9Uer425+nK3M9yxzgOqAbkXMt0rA9Fa9OjHwNA97k3e3oo44bLjY5KaYxI/3rxpk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5554
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-22_17,2024-07-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=574 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407220178
X-Proofpoint-GUID: s6-Lm-yq1ajIhfGSO1tST7q5qkXJL-LA
X-Proofpoint-ORIG-GUID: s6-Lm-yq1ajIhfGSO1tST7q5qkXJL-LA


Jens,

> They can, but is there some dependency that means they should go
> through the block tree? Would seem more logical that Martin picked
> them up.

I'll get to them. Busy with a couple of hardware-related regressions
right now.

-- 
Martin K. Petersen	Oracle Linux Engineering
