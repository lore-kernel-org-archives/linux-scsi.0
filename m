Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3647E5464D
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2025 02:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765940358; cv=fail; b=LvyKRjqjpRxXwyJDor6ZzpFoHW7wEgPSNUGaZB390Ojqz1r9Ljjx6uABdPTkTGQlm/VuEh0jtvfrY35GJ3xK0d5gi02P4wY4yqrnKLiSmXz+J/JJB+btOqsjjfrIWuelDDWL9ydBjanIve3Sy+jrVa3b5SNjZbdmiYkBej+8uF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765940358; c=relaxed/simple;
	bh=HhOYY2iztCfBNxeWhvc9TQLUBPjHsBFivBU5WDCf6vw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=VSMKGivgbIZWHaqwt/7aYMebgqdAZsXmwJxxNY0IyyxjCjf39UQASB3UCwgWvZdE29Xs8q+mS/GqtSr6HIJAtmdpWMyjTRgcvBLpmsC9G1JwfHkyZobIs3kJvNQGsFlzlo/tUbZSj5iBGHlJVZ+KUW9J0k9rg7d8Hfk8EeXxNwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fQ2UtPQR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=w64SFoTo; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fQ2UtPQR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="w64SFoTo"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH0uhJT1589068;
	Wed, 17 Dec 2025 02:59:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=gkDRyekNh/4WwL7pFH
	NKdwUPsaWHiPU3mW29U1OqPFs=; b=fQ2UtPQRoNhjy9k5KcpRPUne9ssg7AciVh
	PV1KAK3Da/l6eSK9M+4Rh/dlSH6PS3GwBGIx+8L+869EaTVHBBFvCD/UqD/JLNXJ
	0QabsSbU0+/rZ0rMSLRYeAG9SDaNaG3CX/qwAeZpTFrgYYT2TdKJa1oRXGnuzAwY
	eGMO4LB7nBcO+cbFf3EDGneQxfxzElmI8kddxW0LQTpA1xA7sJvwjwe4VOiWoSNj
	UgoZH/n3hKRZa4ODIOvmS9xqYCXmrgCcyw6tvHgW7qe71Pl4hUdBp2CdlZjHA6ma
	zc5Qa2vpZ0o5JK9G3036C0aQUyEWwCkANBjbf7AgXI9t7vgswRng==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xx2d3j9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 02:59:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BH1bplq025167;
	Wed, 17 Dec 2025 02:59:14 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012068.outbound.protection.outlook.com [52.101.48.68])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkb8ejn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 02:59:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i/UePXXbFthlThci3vS7XS/z0safnLv3iDohnmzHaDyqzQApr49VeT5ERTXtygjh0L5PM66pliHcovfCmRiNbLzjMbvJ1zTobgo3ooarQfeYiQHrb8o6PAxrA0FoOLvtPKvx/oHvI20GIYoP1f164IrMmrSclNAcrArEReOKk7hEU+YAstUsRtBENvOEm99yCXdiG3aHdZZmt0f6cxOjhmJzp8fuag1uo+0OKuEUdCJa1ThM1On2JnjBu48Qd7AU87C8soW8pA+SOTTD8ScEpBkUe95g/gCIJTcNXaJNB+aAkYJoabvEEx30cHKkSiygSFkMGyinUSgBIE35GYma8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gkDRyekNh/4WwL7pFHNKdwUPsaWHiPU3mW29U1OqPFs=;
 b=NqZ2KMF+Qu2Z9JowTX412bh0thbGko7Q1qDR2SOOMheuoZ2W3086uh6QbLUR4bJ8Ws5evOxgybsftIY89BM7OFkoooIHcjs0fXWuN85+I7PiOTPmIM06jLd9vu0nu+s7t7SIiU7W6TAGBAxpECpraBlugjWpwTErAkE70zz/UL6uMWELcBNMHync8hA9JVaajNqTvf79LJ8MARmxvVRmo/1OUNGOan1SdVrGd3CGdsPtPp4X9vL4sN4ZDouVr4k9wDaIetjv5GgaGcwN8pAgiHvNOOyF+0j3W0UFVH+oYA6XsYtLD6B9KQT4Bsc0/dSsZSVAL8/SHp8+xQVNEncJOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkDRyekNh/4WwL7pFHNKdwUPsaWHiPU3mW29U1OqPFs=;
 b=w64SFoTo26eQQWidjeqA6FwrbNWJr5kugJGmVO8eFmrtsrVbi44NrK8WvfYO2Zyb9H53iPgbAA/45kpYW8JxTqladcZviovK5cDwLPVzhuORyy0sIYn+oCltwXdI+0N42AbvEFRDntK9lGEXE5L8Gn/HBZYm4PIdXUCxgFKIfAY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7763.namprd10.prod.outlook.com (2603:10b6:610:1bd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 02:59:11 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 02:59:11 +0000
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH 0/3] Update lpfc to revision 14.4.0.13
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251211001659.138635-1-justintee8345@gmail.com> (Justin Tee's
	message of "Wed, 10 Dec 2025 16:16:56 -0800")
Organization: Oracle Corporation
Message-ID: <yq15xa56cga.fsf@ca-mkp.ca.oracle.com>
References: <20251211001659.138635-1-justintee8345@gmail.com>
Date: Tue, 16 Dec 2025 21:59:09 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0047.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7763:EE_
X-MS-Office365-Filtering-Correlation-Id: f21efe1f-674c-46d9-ada7-08de3d1840c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PZuD+NC9Sz4qJ3EosDM1xCVr7Y/o+UoUODcEYjKDPSU6YN2bbwZBmfo+aOh6?=
 =?us-ascii?Q?8JImKnK+qA+2JCU0YN0ujTTYH4grrdnvEICzUNW4wDM6nAAypkGJz9ZJbwv6?=
 =?us-ascii?Q?9UOjtNvs1lWS9zJlcVd8rkw7d9EciX6GbLXEEaPwd2IvWCBpY22cxQ0utW3t?=
 =?us-ascii?Q?CzxoLtFOavu+XaYnIJ+9/+oHhPFv47clV6DbhLClPBorG3KXx7fcyUojvHJ1?=
 =?us-ascii?Q?po6nh2AwkZHKUlWa9BAVgaDwcwLCxD5qUHJPBotmyHpYDM6VuaXkS1ITlYn1?=
 =?us-ascii?Q?zAhrRMfhFMm1z2QDRX8IsfR45CzawUA/yileCMyjogPR6EvF5xQMmvMns62l?=
 =?us-ascii?Q?BiPpSElInprCI0DB69VPmaRLFefee8yE3qvxVp7J8h1pMxAZdk8bv8xbA9TJ?=
 =?us-ascii?Q?+1Jnfu40tTz6kFTfIh3RuVTLqM5h3cenIIJ04qrvWnzMRWJIPQwnpQOY/jbI?=
 =?us-ascii?Q?82pdmg0N3ZjgtyI2moacl2wrhgN3RtHWVwDwlTM9OpMZu/S0eXEczdh+j8bm?=
 =?us-ascii?Q?IOSaIVk2VaOYmNeybEvTotUBDgYPvX6BmmWT0zF7TVMOJ4uxvERZI8XdcqIF?=
 =?us-ascii?Q?PwhWDoL328y+83JUp70h/TnGwsDKMQArPS5GWnH6LTDjd9NGj+0npwoMy139?=
 =?us-ascii?Q?ldfRSyUlDYLDc83YAP5euDkOj3wWS5cENjSdYHsY+ieeOVPGwRi6xB+nhDSc?=
 =?us-ascii?Q?5ZZf07PExZJQ21ZCKTI/YVrSTLHwVlNjs6AfeIQ/5rGZkuZp/voQH5dmHdYm?=
 =?us-ascii?Q?WaTUccewFBYVAP8dg6Umfn6H9Aus4+mT5ZriTMTwLGNqqjDMBLMIry00GfR4?=
 =?us-ascii?Q?BrMzNDVslRzm9oO8x08Nrnm4Drl+ENP5+o3vmEQeP0DIeNziPbHINbzr01O6?=
 =?us-ascii?Q?8Q+lEy+eNG0KMkgs8KuXL09ksn+sXRcPZrtifo8XVb2aMCpLW9XUPhM85/TI?=
 =?us-ascii?Q?bfJZVb90RYGDmUQ/rv3aQqpjq8oJ/NUdhBGNAr761lqXFmaI+1v+qQJeHfzu?=
 =?us-ascii?Q?R1RM2ihZsngaTzumLLNJarOWWOBvaNcupLeqcH+Q+IqQOkV/6iQfH7XLutf2?=
 =?us-ascii?Q?5ZjNP8v3U3geX6x1241TRjvQ4DsVjXd9fhOa+YJGE5LrmmoNXiY0+wseEjGP?=
 =?us-ascii?Q?jvg3rnIQIX5CF3yJhWNV9EqZuKzFkWJYi2+dzYwVVGuzArcu6vRkWcJrX2n+?=
 =?us-ascii?Q?wEgS4ye78pVtwY3QlH8F7XLGdEMCJOOqByFs996RWMHiWhl4zKqjuu7Q1Ki2?=
 =?us-ascii?Q?wO03hbO/046dMZHrvCEt5mjkIbLuQKkxTF2uNwlqQySxoe6ngenqSWHH9Lu1?=
 =?us-ascii?Q?YVspTMxbkwSb//eWceioMUeuotT7/VgU8VURjD64PM13SKXPaY3VAlk8K2PG?=
 =?us-ascii?Q?TfbUypFVGI+rgwMKqQvhWkWOOWJ082Y6HRVPspSc5OYAZgz1XXCmNf5kza2l?=
 =?us-ascii?Q?LyW+GTAPHWCS3bXWCT+ohhX1sjY1QVx9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HxvpDE4MMgOAhVzHrDhRVl0/2XqCfwZNPdr0uG4UNAaEeUDf0Zad0M4Urd4Q?=
 =?us-ascii?Q?ZQ/hSsFWQyd6zPBH8mrzKzqIt2O4AmRgMrXqqILljnFTJ5OsR4f2ZPOqph8H?=
 =?us-ascii?Q?O5MtSprcwP4eo3YiSulyo7oapsnN88UwPLRCNlbKCdDgBRErL89ofiN+5oer?=
 =?us-ascii?Q?pk2L3mKK22O4Hir7113KgP7pZlQFw39A2IiB5Shov0EPv11BwL7qw+rBWtH2?=
 =?us-ascii?Q?W4rzK7l2BMlF5An1ZQsfaPRB7C4Lkjv0igeSV61vabO7dLpnzE8+zdv63FH0?=
 =?us-ascii?Q?ycHFm7MMpkBZ+GsSoecHfukjTZQPRG4r1M1dbAGmRWnxtotfzM+xgr6lVURq?=
 =?us-ascii?Q?pX+82N9ZfTcyt5naQl9C/gMWYeqPVvk9lK1Tp1QTHx0D5hX+mh3CcRaqyTuj?=
 =?us-ascii?Q?GUvko62aQvXDBaOiNiiO6sU9gAXKCx3msMjzbczwYYlwroZ6MhHT6tXYiz+2?=
 =?us-ascii?Q?2Jh0Ov0fw/VO7cdIFRwrCIJirl+9NsxFENT07lrDd6S9AQez2j3SjAfHK5kX?=
 =?us-ascii?Q?Rop6/sa0zQ1jH4HRx0sM3zd0zgPB3lCkM8QK5tjQxC9CLhHG9kIuiKqvHzsv?=
 =?us-ascii?Q?2m2BJCYXiViWdS4cnzdNexPkt44vwHoFXIC57c6KnhACVhvLWkVP2ItyKj2S?=
 =?us-ascii?Q?xEULU9Zb2OIbeQWuP+QU/oYvSLDkyM3XaBTITqBAydwsF/iA8hJQnbnko3yT?=
 =?us-ascii?Q?V8zhmjg2JMaCmrI9vvZW8dgijkNyOSHoOeqzFwCRH15gmc8yEfwh7hL712pY?=
 =?us-ascii?Q?S6r0eCCehCql3pmxlxDd1k4UHEcY1SH7C+uR6n8B25osGjRWEbQt6LE5kdVO?=
 =?us-ascii?Q?BY78KYjdy4ipJBYXIS9JLKHhLA3v8HBo609VIVrCWzOqyrA/Ekk+9+NxCj/A?=
 =?us-ascii?Q?kl4Cwj5+Mu7qvAfFy99OpU/+gQ+bnwH8OSZDesbJgaHAB07webhnFUzad/Me?=
 =?us-ascii?Q?+KE7l6YANHCh2ukx6zzCrR7x3CQrh+7u3fFdmeZmBcGKZyUqbdyQ50ZGiXqt?=
 =?us-ascii?Q?0Obl8+pdZTdffVVuFIQGgmUS+k4ech0hW3xZS2MyTOu6W1gJKCfty+5BlxjM?=
 =?us-ascii?Q?tcfatC47vjSRXu65gvH7LaFe/kLnExqAb4vMglEJBcUDIr1mJgbz94ULTIj/?=
 =?us-ascii?Q?o/ENPI/ZOOAwQ1BMhG5OY1bm5OnKOkMEPv2f4WnEfswItGtTR0kboUGnZlVf?=
 =?us-ascii?Q?9iPbXYVK0gBO/ngqkk13lvLInEbPXLcu/ig6cSwyoIsFw1pp6RzUiGFqEOZK?=
 =?us-ascii?Q?4baeFEVJr7WC5bhUQkGpL2PG2yRYSWJGUm6kYPdvYrWo8RUw7O8AF89DKonM?=
 =?us-ascii?Q?RhrwN7sN4Yn9wFlDFtiylO2+admweCWrC8qd+OQIcAV2bBaj+tPyMdtFF6Oj?=
 =?us-ascii?Q?qu5iM/YuLotpPOU/3gFVm8GYJShOCFHKmvRlZmwGcR1dDvNvQlp22KahLTKd?=
 =?us-ascii?Q?gLrd5uKwISV3f2MertATJlbrhAzjL37nNKhspH/WSQacc5VtvRbrBm9jmJhz?=
 =?us-ascii?Q?Bs5F22eTz+gzIwPgS8VE6CSU3eeRFLOjzet9infp9a+vaoPBk6/X+RbGnj0p?=
 =?us-ascii?Q?vTIKdnsCIvYksWPvkiXvax/VIo2m2T8E1BrxzgCEJx3s3JCtgCXM8iKRIpf5?=
 =?us-ascii?Q?Yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FwaeJYFC/lcSJhRwvs6CqA+382WaaLpVgxYrtwXG1G75Mt88KRJIjJRw5Rr2VaGoXPc1h5DwHccTZKEuSim2u4zYt8bs0ty/xgV4C7Emo2gTjaot0oGOERN6fUy/2aiLcjd0I7ltUhEck/dL5AxCJN89+IVJdBk1YqFFlPweOtVkO7zT1XuAAJEO7XZWQL0Qm5d9ZhVQduPXtM+wm/SQ7Ll8XU5uHTLXSDOL7yzn3rWJdtS1R6Za48Ie9BzvuGZr4cIYS+HdmtuR4i+aMzA2ds1WpB5Er+XAplhRLuGXjiiSnDxX/MEO5muvkPBlrSpFym2Sy8o1rlQZU8Svh/qPXYaMR2jRH92Qw8E6KkcD2J0cbn448p1fq0v4iNPMXAKvzxJt9csZ5yxeLUf8KdAWn1m1TkGcom4PTMDOMsieT/NOpjEXEECbIqqcdpeCYhHuxPkgC3ZM05U8UcQRU9PeV0El8oHZ9Ji+l7Tw/xjFtY817gDwrmScntWeNPc+0rQqIEfW8gxgpHI9x7QuPBfyA0o8y649CSlIo6LHl7Ld8XTOhUAf2+hv3KRo8UDt+mcPavXzYhEi6NIXJqMs4wTzGWbUnH0dAQxWYOyzORM+r+k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f21efe1f-674c-46d9-ada7-08de3d1840c7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 02:59:11.0008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s4bzoohmgCXBzCPGy//mYnP8lFjO6Kqn23vy/MeHU2HTlWx24y3ePf3jr7AYALI+YXThYXjWwEz5x9AkmjoOv4wWU+TdkFj7mVU3KcRdZCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7763
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_03,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=616 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170022
X-Authority-Analysis: v=2.4 cv=B8W0EetM c=1 sm=1 tr=0 ts=69421c83 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=a_29xZmAIwD62g0Cm8QA:9
 a=DVKqRkKJf1IA:10
X-Proofpoint-ORIG-GUID: 1nQjwvevWCoMvqd5TN66L5t58UVkGUes
X-Proofpoint-GUID: 1nQjwvevWCoMvqd5TN66L5t58UVkGUes
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDAyMiBTYWx0ZWRfX9v8dh3JKu2EO
 YdrMbKxDzpJy8vNQZ1wjTaeMhBH09nqIZEoHzW4LXbgiBbZDHPVhsBMIt+EICO7CMlLBe5Khx5T
 i8u3EIxxInsT6mA7p/E4EkzxuEVixhhz6RV+3EMIt3JTGJy9UKAxB+VtaW2h8nB0ZGZ+DqbOhC6
 gVG/AFpXjPbRXX6aCKs93/UeQINxi9/Sb8sEwnC+pil6MHyQble968F2JQiy9TgZmWNpEhe/uRm
 NJBaoEMgAbmcqdfEGfDCrtgoy2KhgDA7+1VsbpSYVRLgirW9ELovZCVQaKfmvfPuVDo2stqK6EH
 sf2pZeFywZ5LfPnPK3S9EUxtJJQK8ws8dfn6c8hFwwqgbznnTPL+110WcdHRn6QsnsRnihitUjn
 UqDIElMTZhtm8ZkikD9SMpuRWvx7Hw==


Justin,

> Update lpfc to revision 14.4.0.13

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
