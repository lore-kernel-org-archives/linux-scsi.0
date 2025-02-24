Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99E02571A0
	for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2025 11:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740398174; cv=fail; b=iebYQ+o+U98SGTawVNyc/ZxQ3aQSPPI6CcUPOfZHaSD69XeC4STn1tYUo/ao/WD/337dN0KiRqEODHI/ykGzlvyrr3fFwGGjFS4x/SsR2iwcWODgVkQF0p8FT5p7Kub9l2p/Zvi1g3vjrPHvfXlfQ/0fouljBWkdie0c+d9ERtU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740398174; c=relaxed/simple;
	bh=iExKoeEHTNLUOPWbcrdiv9MVVUg1RyAjP7oB+J5+WtY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sETIxLv0goP8b3x5qKqP1H+l9RkMVDhSDQZ3QOv5z7Xi8ycYZsJrLuxjNrLet4lj85Ihf1stHvqvvrywia4EhsdWGzQ0Xcz38eu4wzx8IGrhAxC36rtDhmlE8GVGnXSfwmc153HttUJ4Qr5fUh0h/4ckhCIzLH8AKm3Vsqo1F/s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BtvtOFvV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LdaIRGi/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BtvtOFvV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LdaIRGi/"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OBMkJ2010111;
	Mon, 24 Feb 2025 11:55:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=AAA7bO5gH9ikPkQXJ1dLfrdm4Lat2pkNuKtFCygQfSY=; b=
	BtvtOFvVsBPjMn5Ptl+In2VjDd9bPlHTFkZWqWDyHtL/CpK/UqQwLQRJ+iK/57tG
	aQGBhDooAqPeONEYvyJqQqP+IsavL0uY5+HrbfiXEbxwrxoHrIA2B/1UTL4z8Dsp
	n5skUevfuN+aYxfzaPvuEPdwmgEnHgd2y3+nP9p1XZwhcBp8eqZT52OfCloeiGBv
	vTzZRaqSFHrwr4y6LFxYxeVQzQbwKYsj8yw2tnPW5AO5pMURqBnRE+c/GqEwCOyS
	eCMImkyxwtgYAMUTfD9TEN/M8e9KeU5INTKKVvzTOP7vYnILLDI9qllwitLWcD9S
	/QR/kOBWUGaSNih3p4xB7w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y6mbjdd3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 11:55:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51OB1bjM012641;
	Mon, 24 Feb 2025 11:55:42 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44y518tapp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 11:55:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u7fWatjy2RM9SnZhhfBfh4Jd5W8tdDvlfUUqX+VG++RaOCay/MA0fFHVtFea8TutpYjToVAYhA4/r4ECswIRgjS/jDWIhP6M+oafzLJEBHYyUFcqX4Otcg2T+FdNViQznD9AfZ7cTwLWRNTupOsyBNVD9eyWaDnHodjbYKHoHdOmH65wsLpqbb4UhiGfDOZ75rZP5cI0T+O5exkEMRorAg+aKY+AzslZKbeH3+adYwNQHaFKApex0xQaAcDqAAHuIqzSJs4lmFFGL+E2VEHnojQoB1hGceUglAw4TGCH01j9SvYvGDIJ8ixE+XPNSIjQCfEF+o0RVGI+Faf/B2zScw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AAA7bO5gH9ikPkQXJ1dLfrdm4Lat2pkNuKtFCygQfSY=;
 b=ZI/ga1UHOlq9OrxdeiM895UxclRqxNELBJHv1A56GQVt3Gh8LXMKtKsghbDr5oP9Ttadcr9C0ep8JZKgZy+HdYMTP13p5U2dE1GtpdgKZX/tq6Lq1ftXOvY3p+OyspG9AiOtHirBbKxBnG8kDQ7cbsq6Sll/mZ0fPjV/tMydo3fyT9Tpgs+hiTGTurr7v70V6B/RLevSGpE/zEo8NY1U71AtduUBNJmTbEFq/rtyWaTOJptlp9fD768OePrmxjheNKPnyr64lZx5bgF9VtW6XFi9SFz405Z3PJACHFB38aFq/4v73xUsex69HAUFq1hPO/mlFTS1QZwZD0/Gk2z8TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AAA7bO5gH9ikPkQXJ1dLfrdm4Lat2pkNuKtFCygQfSY=;
 b=LdaIRGi/6u/Tyhwtk17n5dQzKHdDdn8qQeKxGTSmvo2WzFW/HL1p5/xtSZBYS/2k9pSlPU+R6+YD43X8aw3lbjNQtgxZ2H/JlRva/1vSp6OTWg1Xhr+dFt7modjeos99D4VNgVsMgCWXKkkuT13TDLjDO2IxplgKIFSxMiwL0Ss=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB7218.namprd10.prod.outlook.com (2603:10b6:930:76::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 11:55:30 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8466.020; Mon, 24 Feb 2025
 11:55:30 +0000
From: John Garry <john.g.garry@oracle.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 3/4] scsi: scsi_debug: Simplify command handling
Date: Mon, 24 Feb 2025 11:55:16 +0000
Message-Id: <20250224115517.495899-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250224115517.495899-1-john.g.garry@oracle.com>
References: <20250224115517.495899-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0096.namprd04.prod.outlook.com
 (2603:10b6:408:ec::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB7218:EE_
X-MS-Office365-Filtering-Correlation-Id: 470d23ac-b9d6-4818-45af-08dd54ca22f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/UrPSLo/0lshJSlBq+wuP07LcF/tibWUss5MxhK9QEDVBrZf4jgsI87KHxQ0?=
 =?us-ascii?Q?yN9ibENHIA0Ft/6e9gyasDgfbH38b+G8UrPRm6bzp8OIg5Stds47lX9fpQfa?=
 =?us-ascii?Q?duhirJpPIx99hTrhRCD03XpCoMNbmJxUrZbwuAzALW6r0lywO0GGssHGbMBB?=
 =?us-ascii?Q?xmkurTwFYM7/FZYHJBCbfqEV/zBae0iV5kCdZreWMrhogBtvgREPNtfPB5JS?=
 =?us-ascii?Q?lnRoaM2oV3YeIr6da0JXfNehRFPiihVpmgKHxiqpfRuOx6qpfZV+KGFihzmk?=
 =?us-ascii?Q?hKSTVue4TddUEcoXh4RlkQAANKPaDeGK9p8BncM/R8c5b3dxSeCTfjlqx1ML?=
 =?us-ascii?Q?Fk1xdDtQCKeukofLWJhGFMuL0g7r4xxj/+1qOZqhs7TPwN+zMouvUJ/QJzLs?=
 =?us-ascii?Q?GdxoabGZ5FXYtK3yNESpJL0tt3TWwa7r8kZWj9QV2fzWdzq/LuwQvfI0BECs?=
 =?us-ascii?Q?JYsrKpzrn36i3XiXNVuC/qwHcyO2rpDjWGGcaxt/MGQ/PhtEcLLnnuEUcbIQ?=
 =?us-ascii?Q?WhXTuB1h8kXqQ/5iiq9C9QHyvX4NqPWkMGcurwtDNNCD3jZSkaO7JR2qS4xr?=
 =?us-ascii?Q?/PtdpjBXmQ2yCf6HzR2PamfDmauNYAObj0TZhIpVLW9t/5bReI9msPoVKlh8?=
 =?us-ascii?Q?aFw/dzX0t7xesrKQfPjnBFfMH2yR6ELA8RJ2bnICoAU+9uSdPHPUSthanzpr?=
 =?us-ascii?Q?Y68wiXyBQa5hL/o+qTAuqf1DcBfvoKAm4Tckg5kVbfCTgBJKVNMc0P86jFNq?=
 =?us-ascii?Q?U4iT9fzccJxdxUnH+2jXNb5InhVFuQQZZ0rHatD+5WBgQ9wU8gVwAA2iXdpc?=
 =?us-ascii?Q?TUxCE2xbRcx8QIz27Qe/q3YMsEwRdoI/qpBVIzHLjubyMLbJTwkSX90iIGc8?=
 =?us-ascii?Q?WqchkpzZNgX545ikuXf5W+40/G/IY9OtlH3jFF1YPfqjA05N12vXjt6UGrXe?=
 =?us-ascii?Q?uH77PTmn5ZYhYrZ9diNBLC1S8JLBrYeEvN66IcMvvEfJEX2xBjZoO7SXiNUj?=
 =?us-ascii?Q?PtTYC4OkzQ7fN0RSe9BvOW7nGoVWJOl0uZgOxRS1Lz4eR7EVckIHaXKV7liG?=
 =?us-ascii?Q?3FHQ7WPhtsIEJ9PcCepeIy4j0mJbuWtufBE1/YDiziTucrEfWzg77Gw+ho6g?=
 =?us-ascii?Q?KBAZ/jfNc+etbE/Joa9q/oHxuFEcB7XTiIyh7Y1d0ger31lkRagmTsS7xdRC?=
 =?us-ascii?Q?qKbjsyLyYSe+GMh9pVACtzlOUELpTNMA9tI3V9pxuGUN/vK6XPlOWV6ueFD+?=
 =?us-ascii?Q?MfNiM4s5l1zjFVrwF8+0zALC5hpba/+ZC7LeYcm1Fwrr5vg0gNBGR5P57/3a?=
 =?us-ascii?Q?/h+We0krIA33/tWJswAf0jRWT/Lr+YHBmQ93T+5Oe0UU7iCMJfGrST6B9xTR?=
 =?us-ascii?Q?qb5DGsW/cy9NbA0IhXa9GFwSelFb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pbkkTlk8NdAnANqLiZiefnfvTrJ3URdLmyOnpQyYok6YJkT216JzecmWNFuv?=
 =?us-ascii?Q?eRjYTC1S0v5cckl/E1mf8h13dlhuSlVM5PUwxYyU7xmYnRNk+StpTczc+IPG?=
 =?us-ascii?Q?ABH8UcNXnflcj6QOdwWW9DJ0mH4GJykhbJqSAp1IWGPeEpdxcpcMvXDA5tPK?=
 =?us-ascii?Q?UoQ/cOIXG7zpOBxbwmjs5rM7dI1q6BQ06Q7ciDxKKFK53mwEO7mimY/tAcNy?=
 =?us-ascii?Q?zXudaYkJW6lBPjnz4rZJyoVGPX1GiUMj1W2Z6LlnhbFRUN56h4QE65wzpZcF?=
 =?us-ascii?Q?363vnTf7vVtkaoT53uef7JAInHTJD0LocPJmAK8i4K3HV8rspzzBdxHXkUiO?=
 =?us-ascii?Q?cJ0yVuTex1iNkEe+vKSv6C9Erap8mV81DBOU1qMkCADg4jKauwiuX3T6JFez?=
 =?us-ascii?Q?grI/Z5AgOh4v11hptJm66uykkgUKnQTMw0Gue7sbpZboYzSfRobQ+6S5v97b?=
 =?us-ascii?Q?XwJax2AZdPxXxEW2PZDfuRN0hwt2N5+Bjhxv6gVqgPhEGwF2tJoAG/jFhPPm?=
 =?us-ascii?Q?H3IxE7pRbS2wFxwu4PhXXS+t/fFVVq5r7NEFq3/8yUnXWzIrdmtyG5ZZr6xC?=
 =?us-ascii?Q?u23W49zb0rQd+w80vh+Fo+bWcHhBhF8mbY85r5ADaAEyBRaZc0IVfJ40TDbM?=
 =?us-ascii?Q?P+bDRxnJSojVHB/lrfnRlExBZaPzn+fXjKHyU9CVQrMqysUFZThTQtsNOqKz?=
 =?us-ascii?Q?GZeqnzByZdGG7JDIQOdKKrD8Y3jjJgvZHhoXf4fw/Wfyc6kjYXIq1EHbzPHe?=
 =?us-ascii?Q?jSTVwMmUYrlvjCVtHsKYrDrMkLVmyOi1jpz77s6dlVt/Cev33nClBefJQ2bB?=
 =?us-ascii?Q?qO46R0AeqDW7RZBOln+kQzARTKTDAucBqqZwpoK4hgMZXgZiEXWrWstA0fxQ?=
 =?us-ascii?Q?2bRbqCeX/Onxl3aqUHk0y66NPfJkOUNHTiufQ0dMQmwP1DXO28OwXeqEc52J?=
 =?us-ascii?Q?wDBMzpep06121xkkwjwOYD6LB8u9WKohLRXX1Wb3Y8yNeKeKwkNXyk6DsUh+?=
 =?us-ascii?Q?LStcX4ZkEJB3FxNQyd7mps4oaNFawGJRrD/LxMotw5veCihc1vEXu/uo9INh?=
 =?us-ascii?Q?hJ+MF4hcq5uipJdrAAozp0r7+MPspDpbVT93kIuHkDZT+BvaGli+caBep7dJ?=
 =?us-ascii?Q?mgzUBR6VsE4Hh0AyabtyEF43j/krEcvbJJ4GOKa0HXXAGsv8mJvptG8eIs9h?=
 =?us-ascii?Q?AYxCftdNuxsPKOULvIoFxZJGBzw0dGMk4n6u+Vbg8dexYzuuVgAXfB0nRqur?=
 =?us-ascii?Q?VLbZUN7NG6cCfDzf0wtS4XAueLCJuonBfhQMaw+Sbj3dCb/bR9VDWmJlA7IN?=
 =?us-ascii?Q?kmeAO98cbGwrjfyJFlNglajbiLJSx2l8jKQJZVyjQkupHb+4k/0TspnXo1vM?=
 =?us-ascii?Q?jHbdaZWeR/g0QsntJZ2CU5w4EYg8y/PgPGUfKVuslqGwtOdTL7VA8apD6olu?=
 =?us-ascii?Q?8AQoHGPmVd1fjIxinV0DgfPTrQH+wBAD/SYiYbJymFT/7Ks+s004znKIbY1h?=
 =?us-ascii?Q?c5425x6rV5zjSZKLmHHOoqsHfbsJvv1/HK+iRSEywwj5UUudUUfgm8EoScu+?=
 =?us-ascii?Q?VJdVtSsPVuMUHl28Q38yD3LDmT0JCWl8OUC98BJRhro5FsFGmeLzhI47BPSf?=
 =?us-ascii?Q?Sw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qjC2TMq9TkIeQ5t6aVBSNGwHQsNy/aGgnXO9Sk5Gep9TZ1u7HEONVMnBcYgNL7bBBLopsMRS+JCNSlqQl/mRibkCy4iftNo8O301WlIGiDS5Ldkqzc0ZOsAUunc/VGM4q/UZOaBA0GUBAOE4RV9fmX/umxhqyF3rXAja5bu98+Q81ROrE9lfHtImIKCYlJprhiqPotXOkoB5k1nw7mdSfNOEb6MeUfwY7E6X43jNHjnqU1rMzn1HHlVC+/F7e0SYoHmB6xUx6v1ufBywnTaWV7LoaLnhDaXD3xdtkYcrMhqYw9InD6DKXziByCkuQSMkKbKO68yoC3H3UMzD7kdEgeEFs7+kxRRwS5W1hQ9OhXO/3dlt//x6elmhzsn7FcdbXxdqyuDH5wBrSOxQ4H4uPFE5KSb8mmGJNU2b3e1rdhzeg+E5xxIIr+XAmR6rV76FA2RNycWpUCmDxGQgku7P5XX9ywqYyn9Ylfe6zfRjvxugGIyIa7Be+janUs1m6SYY4iKBqKjfkpNCEFObC1U2JoeTJKKnOnGlkgZ1xdBnY6UxjW39f898U+d+l154Lfxog6CQJSiPoDlXFBu+mBy2pMhl/BDHPuM0mUTWQFvYpLk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 470d23ac-b9d6-4818-45af-08dd54ca22f9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 11:55:30.5079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ecTeOoVDSZtEUenHYz6ldIYEVteopuQr8XrVgS9fthTfEoJIsLvJPRyOHtY9U+TVQU5Hdf+DIl3PKhd7nqUpvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7218
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_05,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 mlxscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502240087
X-Proofpoint-ORIG-GUID: xxfL34XJiS5S8U1uC2K5FkDCdvP5m9nh
X-Proofpoint-GUID: xxfL34XJiS5S8U1uC2K5FkDCdvP5m9nh

From: Bart Van Assche <bvanassche@acm.org>

Simplify command handling by moving struct sdebug_defer into the
private SCSI command data instead of allocating it separately. The only
functional change is that aborting a SCSI command now fails and is
retried at a later time if the completion handler can't be cancelled.

See also commit 1107c7b24ee3 ("scsi: scsi_debug: Dynamically allocate
sdebug_queued_cmd"; v6.4).

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_debug.c | 130 ++++++--------------------------------
 1 file changed, 20 insertions(+), 110 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 7631c2c46594..c1a217b5aac2 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -300,11 +300,6 @@ struct tape_block {
 
 #define SDEB_XA_NOT_IN_USE XA_MARK_1
 
-static struct kmem_cache *queued_cmd_cache;
-
-#define TO_QUEUED_CMD(scmd)  ((void *)(scmd)->host_scribble)
-#define ASSIGN_QUEUED_CMD(scmnd, qc) { (scmnd)->host_scribble = (void *) qc; }
-
 /* Zone types (zbcr05 table 25) */
 enum sdebug_z_type {
 	ZBC_ZTYPE_CNV	= 0x1,
@@ -460,17 +455,9 @@ struct sdebug_defer {
 	enum sdeb_defer_type defer_t;
 };
 
-
-struct sdebug_queued_cmd {
-	/* corresponding bit set in in_use_bm[] in owning struct sdebug_queue
-	 * instance indicates this slot is in use.
-	 */
-	struct sdebug_defer sd_dp;
-	struct scsi_cmnd *scmd;
-};
-
 struct sdebug_scsi_cmd {
 	spinlock_t   lock;
+	struct sdebug_defer sd_dp;
 };
 
 static atomic_t sdebug_cmnd_count;   /* number of incoming commands */
@@ -636,8 +623,6 @@ static int sdebug_add_store(void);
 static void sdebug_erase_store(int idx, struct sdeb_store_info *sip);
 static void sdebug_erase_all_stores(bool apart_from_first);
 
-static void sdebug_free_queued_cmd(struct sdebug_queued_cmd *sqcp);
-
 /*
  * The following are overflow arrays for cdbs that "hit" the same index in
  * the opcode_info_arr array. The most time sensitive (or commonly used) cdb
@@ -6333,10 +6318,10 @@ static u32 get_tag(struct scsi_cmnd *cmnd)
 /* Queued (deferred) command completions converge here. */
 static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 {
-	struct sdebug_queued_cmd *sqcp = container_of(sd_dp, struct sdebug_queued_cmd, sd_dp);
+	struct sdebug_scsi_cmd *sdsc = container_of(sd_dp,
+					typeof(*sdsc), sd_dp);
+	struct scsi_cmnd *scp = (struct scsi_cmnd *)sdsc - 1;
 	unsigned long flags;
-	struct scsi_cmnd *scp = sqcp->scmd;
-	struct sdebug_scsi_cmd *sdsc;
 	bool aborted;
 
 	if (sdebug_statistics) {
@@ -6347,27 +6332,23 @@ static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 
 	if (!scp) {
 		pr_err("scmd=NULL\n");
-		goto out;
+		return;
 	}
 
-	sdsc = scsi_cmd_priv(scp);
 	spin_lock_irqsave(&sdsc->lock, flags);
 	aborted = sd_dp->aborted;
 	if (unlikely(aborted))
 		sd_dp->aborted = false;
-	ASSIGN_QUEUED_CMD(scp, NULL);
 
 	spin_unlock_irqrestore(&sdsc->lock, flags);
 
 	if (aborted) {
 		pr_info("bypassing scsi_done() due to aborted cmd, kicking-off EH\n");
 		blk_abort_request(scsi_cmd_to_rq(scp));
-		goto out;
+		return;
 	}
 
 	scsi_done(scp); /* callback to mid level */
-out:
-	sdebug_free_queued_cmd(sqcp);
 }
 
 /* When high resolution timer goes off this function is called. */
@@ -6674,10 +6655,15 @@ static void scsi_debug_sdev_destroy(struct scsi_device *sdp)
 	sdp->hostdata = NULL;
 }
 
-/* Returns true if we require the queued memory to be freed by the caller. */
-static bool stop_qc_helper(struct sdebug_defer *sd_dp,
-			   enum sdeb_defer_type defer_t)
+/* Returns true if it is safe to complete @cmnd. */
+static bool scsi_debug_stop_cmnd(struct scsi_cmnd *cmnd)
 {
+	struct sdebug_scsi_cmd *sdsc = scsi_cmd_priv(cmnd);
+	struct sdebug_defer *sd_dp = &sdsc->sd_dp;
+	enum sdeb_defer_type defer_t = READ_ONCE(sd_dp->defer_t);
+
+	lockdep_assert_held(&sdsc->lock);
+
 	if (defer_t == SDEB_DEFER_HRT) {
 		int res = hrtimer_try_to_cancel(&sd_dp->hrt);
 
@@ -6702,28 +6688,6 @@ static bool stop_qc_helper(struct sdebug_defer *sd_dp,
 	return false;
 }
 
-
-static bool scsi_debug_stop_cmnd(struct scsi_cmnd *cmnd)
-{
-	enum sdeb_defer_type l_defer_t;
-	struct sdebug_defer *sd_dp;
-	struct sdebug_scsi_cmd *sdsc = scsi_cmd_priv(cmnd);
-	struct sdebug_queued_cmd *sqcp = TO_QUEUED_CMD(cmnd);
-
-	lockdep_assert_held(&sdsc->lock);
-
-	if (!sqcp)
-		return false;
-	sd_dp = &sqcp->sd_dp;
-	l_defer_t = READ_ONCE(sd_dp->defer_t);
-	ASSIGN_QUEUED_CMD(cmnd, NULL);
-
-	if (stop_qc_helper(sd_dp, l_defer_t))
-		sdebug_free_queued_cmd(sqcp);
-
-	return true;
-}
-
 /*
  * Called from scsi_debug_abort() only, which is for timed-out cmd.
  */
@@ -7106,33 +7070,6 @@ static bool inject_on_this_cmd(void)
 
 #define INCLUSIVE_TIMING_MAX_NS 1000000		/* 1 millisecond */
 
-
-void sdebug_free_queued_cmd(struct sdebug_queued_cmd *sqcp)
-{
-	if (sqcp)
-		kmem_cache_free(queued_cmd_cache, sqcp);
-}
-
-static struct sdebug_queued_cmd *sdebug_alloc_queued_cmd(struct scsi_cmnd *scmd)
-{
-	struct sdebug_queued_cmd *sqcp;
-	struct sdebug_defer *sd_dp;
-
-	sqcp = kmem_cache_zalloc(queued_cmd_cache, GFP_ATOMIC);
-	if (!sqcp)
-		return NULL;
-
-	sd_dp = &sqcp->sd_dp;
-
-	hrtimer_init(&sd_dp->hrt, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
-	sd_dp->hrt.function = sdebug_q_cmd_hrt_complete;
-	INIT_WORK(&sd_dp->ew.work, sdebug_q_cmd_wq_complete);
-
-	sqcp->scmd = scmd;
-
-	return sqcp;
-}
-
 /* Complete the processing of the thread that queued a SCSI command to this
  * driver. It either completes the command by calling cmnd_done() or
  * schedules a hr timer or work queue then returns 0. Returns
@@ -7149,7 +7086,6 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	struct sdebug_scsi_cmd *sdsc = scsi_cmd_priv(cmnd);
 	unsigned long flags;
 	u64 ns_from_boot = 0;
-	struct sdebug_queued_cmd *sqcp;
 	struct scsi_device *sdp;
 	struct sdebug_defer *sd_dp;
 
@@ -7181,12 +7117,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		}
 	}
 
-	sqcp = sdebug_alloc_queued_cmd(cmnd);
-	if (!sqcp) {
-		pr_err("%s no alloc\n", __func__);
-		return SCSI_MLQUEUE_HOST_BUSY;
-	}
-	sd_dp = &sqcp->sd_dp;
+	sd_dp = &sdsc->sd_dp;
 
 	if (polled || (ndelay > 0 && ndelay < INCLUSIVE_TIMING_MAX_NS))
 		ns_from_boot = ktime_get_boottime_ns();
@@ -7234,7 +7165,6 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 
 				if (kt <= d) {	/* elapsed duration >= kt */
 					/* call scsi_done() from this thread */
-					sdebug_free_queued_cmd(sqcp);
 					scsi_done(cmnd);
 					return 0;
 				}
@@ -7247,13 +7177,11 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		if (polled) {
 			spin_lock_irqsave(&sdsc->lock, flags);
 			sd_dp->cmpl_ts = ktime_add(ns_to_ktime(ns_from_boot), kt);
-			ASSIGN_QUEUED_CMD(cmnd, sqcp);
 			WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_POLL);
 			spin_unlock_irqrestore(&sdsc->lock, flags);
 		} else {
 			/* schedule the invocation of scsi_done() for a later time */
 			spin_lock_irqsave(&sdsc->lock, flags);
-			ASSIGN_QUEUED_CMD(cmnd, sqcp);
 			WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_HRT);
 			hrtimer_start(&sd_dp->hrt, kt, HRTIMER_MODE_REL_PINNED);
 			/*
@@ -7277,13 +7205,11 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 			sd_dp->issuing_cpu = raw_smp_processor_id();
 		if (polled) {
 			spin_lock_irqsave(&sdsc->lock, flags);
-			ASSIGN_QUEUED_CMD(cmnd, sqcp);
 			sd_dp->cmpl_ts = ns_to_ktime(ns_from_boot);
 			WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_POLL);
 			spin_unlock_irqrestore(&sdsc->lock, flags);
 		} else {
 			spin_lock_irqsave(&sdsc->lock, flags);
-			ASSIGN_QUEUED_CMD(cmnd, sqcp);
 			WRITE_ONCE(sd_dp->defer_t, SDEB_DEFER_WQ);
 			schedule_work(&sd_dp->ew.work);
 			spin_unlock_irqrestore(&sdsc->lock, flags);
@@ -8650,12 +8576,6 @@ static int __init scsi_debug_init(void)
 	hosts_to_add = sdebug_add_host;
 	sdebug_add_host = 0;
 
-	queued_cmd_cache = KMEM_CACHE(sdebug_queued_cmd, SLAB_HWCACHE_ALIGN);
-	if (!queued_cmd_cache) {
-		ret = -ENOMEM;
-		goto driver_unreg;
-	}
-
 	sdebug_debugfs_root = debugfs_create_dir("scsi_debug", NULL);
 	if (IS_ERR_OR_NULL(sdebug_debugfs_root))
 		pr_info("%s: failed to create initial debugfs directory\n", __func__);
@@ -8682,8 +8602,6 @@ static int __init scsi_debug_init(void)
 
 	return 0;
 
-driver_unreg:
-	driver_unregister(&sdebug_driverfs_driver);
 bus_unreg:
 	bus_unregister(&pseudo_lld_bus);
 dev_unreg:
@@ -8699,7 +8617,6 @@ static void __exit scsi_debug_exit(void)
 
 	for (; k; k--)
 		sdebug_do_remove_host(true);
-	kmem_cache_destroy(queued_cmd_cache);
 	driver_unregister(&sdebug_driverfs_driver);
 	bus_unregister(&pseudo_lld_bus);
 	root_device_unregister(pseudo_primary);
@@ -9083,7 +9000,6 @@ static bool sdebug_blk_mq_poll_iter(struct request *rq, void *opaque)
 	struct sdebug_defer *sd_dp;
 	u32 unique_tag = blk_mq_unique_tag(rq);
 	u16 hwq = blk_mq_unique_tag_to_hwq(unique_tag);
-	struct sdebug_queued_cmd *sqcp;
 	unsigned long flags;
 	int queue_num = data->queue_num;
 	ktime_t time;
@@ -9099,13 +9015,7 @@ static bool sdebug_blk_mq_poll_iter(struct request *rq, void *opaque)
 	time = ktime_get_boottime();
 
 	spin_lock_irqsave(&sdsc->lock, flags);
-	sqcp = TO_QUEUED_CMD(cmd);
-	if (!sqcp) {
-		spin_unlock_irqrestore(&sdsc->lock, flags);
-		return true;
-	}
-
-	sd_dp = &sqcp->sd_dp;
+	sd_dp = &sdsc->sd_dp;
 	if (READ_ONCE(sd_dp->defer_t) != SDEB_DEFER_POLL) {
 		spin_unlock_irqrestore(&sdsc->lock, flags);
 		return true;
@@ -9115,8 +9025,6 @@ static bool sdebug_blk_mq_poll_iter(struct request *rq, void *opaque)
 		spin_unlock_irqrestore(&sdsc->lock, flags);
 		return true;
 	}
-
-	ASSIGN_QUEUED_CMD(cmd, NULL);
 	spin_unlock_irqrestore(&sdsc->lock, flags);
 
 	if (sdebug_statistics) {
@@ -9125,8 +9033,6 @@ static bool sdebug_blk_mq_poll_iter(struct request *rq, void *opaque)
 			atomic_inc(&sdebug_miss_cpus);
 	}
 
-	sdebug_free_queued_cmd(sqcp);
-
 	scsi_done(cmd); /* callback to mid level */
 	(*data->num_entries)++;
 	return true;
@@ -9441,8 +9347,12 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 static int sdebug_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 {
 	struct sdebug_scsi_cmd *sdsc = scsi_cmd_priv(cmd);
+	struct sdebug_defer *sd_dp = &sdsc->sd_dp;
 
 	spin_lock_init(&sdsc->lock);
+	hrtimer_init(&sd_dp->hrt, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
+	sd_dp->hrt.function = sdebug_q_cmd_hrt_complete;
+	INIT_WORK(&sd_dp->ew.work, sdebug_q_cmd_wq_complete);
 
 	return 0;
 }
-- 
2.31.1

