Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A6C185955
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2025 02:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765939780; cv=fail; b=ncbJBDGbi1qMySs7emlkkeHoNtdlZDuTZcFF/GDmj6oVt4Lu7wxTw99bGtIM+484Mr78TAhHC3w2Vb0U+9IcgCXUv62ciJKjNPzFoHYQdElaEiYzPvfXIMTt6ExwXEJdFfwr+98parsVzxsxsVEJBGNe8VgQRAEiobpWwpIL93k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765939780; c=relaxed/simple;
	bh=tjf9D93u7QpzUsnSfV+O60UewqDsRvc9FG/5nsPAXtk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=cIc6PvC41Qr1+kEbVJmb+sd0pfSnrJeR5fJ3/bykdlFZXC5FlfvCYb/BIs2o8BWtLCI6Nwk22PIp9H/2AgkbOYUWhCXI39nDFtp4m910tm7M8V9krsBJ35N0o2zTdzdUVTEEWi09JOONaaZQKSYAWwHF+Uq4jY3j+3D7w3Y+6uE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=q+UHw+Ab; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=g9WbIIBi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q+UHw+Ab";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="g9WbIIBi"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH0uJha1556617;
	Wed, 17 Dec 2025 02:48:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=NYO/PP28A/RpnQ3ZS6
	STKtK/naShS6PM/VWKsIwmYEo=; b=q+UHw+Abl2TBvsJCbBrWI9FyydvkTMrOdu
	etZ2pM+KeR4oBm4cBPdGd4uHwBB2MclFiOb1G6zkumfZluY8u1QBCKZGNAksht4M
	de0b0hh2CT/NIupjsRAqlshTSi3i94I4MkL6ritip4CO1HZ9Ll904a66oY8DMpYQ
	oUiVqnbdeK6Jr9ImtF48DPq/TxpncuenKhkxRQlt2albupoqfTbAV5ZW1JdEjv8j
	/VZIpYEgQmDPdqEh0HZHn1S2m0MupP1o+JwMv3N6zzc6rXalobJH8s8FxBxvJGWo
	wGTiGmI0zVd09BRy3+BhwFPn5XYocOU4kmmuD1KRdc1ZfbVCJ1ng==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xja543w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 02:48:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BH1VG8s025208;
	Wed, 17 Dec 2025 02:48:58 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010007.outbound.protection.outlook.com [52.101.56.7])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkb892k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 02:48:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vxkBrNC11m7b7lbV7zSxZflvra+E1WyuW+EpagNzVfaWDy7QfRZZpe8GzC42fMH23UNCoxCoFOPdAmT0PiYPOrtohb4nOmCnwbX1ecsSqOYme87MNvtmp7K4i6k+E7dMX7+jaORvWv3p3SVTpjY7RywKiW48tAnPkjsW6gvc0UIaLQkrmYKqHapjWo0XiOIJS4TDmNadCHS7wLvuNOkK/u2a+/eDaG3BECNHkPmWp9Yzb5juKQAS8EZPqn0FQ6icvpxRoi8lxzL5xnKM+VJuFsif1LlK/eoKTxAUCm0vH9CpnTwlyUgThL69qI+UV0dprGHfp3Pk9FsWAvUpg8EDvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NYO/PP28A/RpnQ3ZS6STKtK/naShS6PM/VWKsIwmYEo=;
 b=RdmBq/4eUqcrHA796VtF0xib6uTwTnkO5wKBgv5bNi7BY+N/B7Bzseu8DJSWFFjDQowOOW8FbwJZujFPNpK0SUuM+jgKBqxK2sF5pq3hQ9h0uHfw/U4dynKK0ykZYCUk2UGjWtxnH7AOFm6KS0YyoibuBc1GsNllj6Wv2GY1f//sF4eXmUS4/YOZIGoesTCGAq0svQRavdyo8x7J91SzlbBITiazkkvtmWNjeq5GkgRylcTKIof8DlccY9Um39hWqM3NqB3/QoF3kC0XsSrltizBQkjjyyhWJhFwCjtGrteVz/t/ojBQbXyq0+OOZjPMxAflVpEXmVSzMSvqJGihcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYO/PP28A/RpnQ3ZS6STKtK/naShS6PM/VWKsIwmYEo=;
 b=g9WbIIBiDuoQ8AMyuyTKjSc5Hh5qvmWbDeYA6/F21Sqtx6Zow6MdSHt7wyOODcROB7nzQMbO7HB02VRictXFuDlf8qg3dZuG4UUZ7KqYB4Vu9UsA+xPAsU3MMrMp3YvHQoAz9ov7TEiYlD2CBnu2Ilc7uI5JtEFAkTyuBkzM1P8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM4PR10MB6864.namprd10.prod.outlook.com (2603:10b6:8:103::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 02:48:55 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 02:48:55 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, bvanassche@acm.org,
        jiangjianjun3@huawei.com
Subject: Re: [PATCH RFT 0/6] scsi_debug: fake timeout handling improvements
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <28ec2d8d-0da4-4ca9-9a8b-3c2c42d6de9c@oracle.com> (John Garry's
	message of "Mon, 1 Dec 2025 15:32:46 +0000")
Organization: Oracle Corporation
Message-ID: <yq1h5tp6cxu.fsf@ca-mkp.ca.oracle.com>
References: <20251113133645.2898748-1-john.g.garry@oracle.com>
	<28ec2d8d-0da4-4ca9-9a8b-3c2c42d6de9c@oracle.com>
Date: Tue, 16 Dec 2025 21:48:53 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0137.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM4PR10MB6864:EE_
X-MS-Office365-Filtering-Correlation-Id: 77bfcb8e-d26c-4909-9cea-08de3d16d1c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?20V3MfS9OAFZr0YuCf9UNb4kBwQuz/zqi1DxKhu54RnOijNaN0VCtw5v9BqF?=
 =?us-ascii?Q?7ErRqQmBes4KqlsLhBheig6YStnTtMGanDzHojWaG1LxxvdejrzJnMHRK5R0?=
 =?us-ascii?Q?2Pxq3HQwxrEDwcRw3npJFMKlQD6AqyedwZABeyaL41pzVCOrbPXDiqJN/HRH?=
 =?us-ascii?Q?F6TN5bi5l2JAjUAd4IMopVpvjY70UKDyx7Dh4RJhuCix5y8HdPjdZ0jUKAip?=
 =?us-ascii?Q?Zwt8ChY+CH8vg9mGv47oApcrM9OKj9x0XNVu/J3zvP9SS0LDHUG4N27lbWPs?=
 =?us-ascii?Q?hGcy9ZGj4biV6LfP5+/DANQEndyAsVoOPsrWOgsjHbb4oEl1bjUznEaiyJ6v?=
 =?us-ascii?Q?dzgDQyQoTs0sWrzF1al/oOfEb/4wb32b+32k/Ojf9qmJeLUh/7GgUDrvmKgo?=
 =?us-ascii?Q?Q9Bq5b3HLn8gvlzRXSXiwm9KAAy1cAzz6sBk55m97cGP2aSxRecLoqDtGnoj?=
 =?us-ascii?Q?7zleh7+z7lHOCLEjp/UeBu3P+rplxREgUaK4cfXF66oH14ZqhEd7brZz3hD+?=
 =?us-ascii?Q?U5USUaJ1CCa4VplyYae9ihP0OjVIfY2VSBgxlJNK1omuy2lwuTFlME40xmhU?=
 =?us-ascii?Q?xxEeM+zqDKvH+bdf4calZH1izaF4+sgJm150P5ekYZFIiMYo2j+qLVODO90s?=
 =?us-ascii?Q?IcyzcWlV9us9A70lOl2i9NfH1HE+93cCupwmpdz24a7Vg6z/93XDIwcivz02?=
 =?us-ascii?Q?/0GK8r5WaTqA8T4Ed7XoCoF9tbdb+x1G0ENkRlBOvJzLMby9fVZEnvMAMnZL?=
 =?us-ascii?Q?Yvk6e1sEAAKyRB80+LC4tPXXrcupoPw6A40ZyDA0nMltpS8DEJSR9mFhRR4N?=
 =?us-ascii?Q?BVPcvnKEtTh6t9sW2dJuGo37UHnV35RuPflS50M3813WeI46wHtwleiOMM5G?=
 =?us-ascii?Q?H4b1yhNuqPv/kFkBD4P70PdpGg6SSXziL7MffW44nFXq+sRj/05B22mRYi6h?=
 =?us-ascii?Q?XZGxUYnfI/kopbCuFe69KnSNpHbpMCBik2qTFV88Rtn/Er/axg81zmgtHdsY?=
 =?us-ascii?Q?Jo1h4YTgv3KOhBdGMP5HRPyYTp+GNgA968W83G5ZVX98TBwfOQ1Hem0KBV9I?=
 =?us-ascii?Q?NJqfnKw+df7T2Iu2/THsxgyCp/7qklB9rT1ETIpgvi4WbZpUlVkb3XCTPcg8?=
 =?us-ascii?Q?ZjI5+NQRvluxrP0pJqUj4z6L5JkeE9zOsMKtR4u0ZqtsvwDTE2HvnbOFNqQF?=
 =?us-ascii?Q?wk5x9gOnyokbUgeu4QXTaHpgpMpJmZEWe4f3CRo9xkqFiyCNUBhSHbL1RbKf?=
 =?us-ascii?Q?UZ3JR/HOYxnT1EQ6MP2BWu/7mm1R5vXrc8WBguQkvD50w/4n4s5XPl9P1/P1?=
 =?us-ascii?Q?0+76H9d0020wCcGERuEauVCqX0N86SeQFcMmUInWOLnd7hzOhK2WUIGHeAGk?=
 =?us-ascii?Q?Pbb4RBxOD+N4pX5EUQhK+vx1WM/H1/9Rp4U/tRRseNir1pzUfn/CDfM0Pc/7?=
 =?us-ascii?Q?v96oCyLPubmWznvh3INdWn67l33I8x8I?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E9Pzcf/ethUKnEjka0BeFVv2KTERrMlw8DktJcdV/X7jzNxteM5pvy4cR8b2?=
 =?us-ascii?Q?VXOt0l0Kvjsx6NXMaBvhKr36C+8EBy50boUPh3DNI4TYymNgU/SvH2kFRwze?=
 =?us-ascii?Q?pddets7SmHas1DLeppkfuL8nPXp4DH4QKIiRZonto7OmXbZF2FGd+eMw8KkM?=
 =?us-ascii?Q?2uE59A5T9R+yo3KSy54MSvYEMmCDhVhUFtkV20HiPoJk7F/1hj6AlrrANd4s?=
 =?us-ascii?Q?Vwdikytqb035fwXcoBZs00q4l8hW3L0kiXMSP39moVRt8MO7OjEk8XTrFnvU?=
 =?us-ascii?Q?RN58W0bV8oIt344PI7boT9ZkfTxsQUP+rvEdvDQ5igtSoAJPKBB6qE0GquO3?=
 =?us-ascii?Q?aqrfw+byDDs+Llg8kH6NCBSjN88TrZ1ye4TY+RiXC8vYUo73h0gijSOyhcWH?=
 =?us-ascii?Q?OZQtetrdKmf77WAlJMflkZpKphBO9x+h/bDf17cmEGe4ktrBL2B72QcAV01b?=
 =?us-ascii?Q?sixPOGf+lpRPr4NYUh60b/snoV97pbZwkEKwKzbnbRJmgV4dBOBMLKoC5F/X?=
 =?us-ascii?Q?CeWB6c2k9URx0+f7aBBd/x5wqBHoaJnHvgsnz5eX9dFfELvGGNb1x1K0V6to?=
 =?us-ascii?Q?ll0z8dV2IFeBOgyJaF+oxtIbLlUNvEihnGOATyAkATKEqzG90NIaNGQ5Qmzq?=
 =?us-ascii?Q?JyfaGjLV3myTprRSFRVp1DW+7U2skWdhjytRddzvqwifHmoa91BtVpoJoHSH?=
 =?us-ascii?Q?CS7KSFrFxt4Z8QQ9QKqxoMbiqglJMv2gxmLQBNooUTmpB4iSPwse1smYFBgb?=
 =?us-ascii?Q?l1YKj2vlJfRZS2pWE/BMA9RGDnTV7CV45Fz8m3/i5J0QD2LvKgZu0NhbKBBu?=
 =?us-ascii?Q?0FUQrQi4Vy+VIqnLOfZMk0TUBHUvrcqxLljEwg2R7ZRAMNOR2zelBa0dJZCH?=
 =?us-ascii?Q?hRAFXd5B46jLHUpn6mNfJaweuSl5G97FGh42HXQH1YhYuZIURLzKHspMCGFr?=
 =?us-ascii?Q?Id7/bYRhQFjGVgoUlzkXsGJt/I5OkrFkGoU5FA3VQ0z2/wvzuNBZq7E6Lmkq?=
 =?us-ascii?Q?3dIXJPwthIr4BlZck6RIue6Fxd5kEirNPkgfG+BhFXZthESKag/LxrnuUyhK?=
 =?us-ascii?Q?q8aCGLeSJU7WLhC1q1Tha5/kZG4XhMiyh4gkQT6tBQ3MegXxrp0tdlhndyS2?=
 =?us-ascii?Q?cwTWyJCUyi9HSE2/JNC/eMYiFXjeeRN1uAx74zKCxUOpHC/o5p8DwDibhgwD?=
 =?us-ascii?Q?W8kpleUSujWoachGQtyZn/wIxaUQkQLwOSQ5JcdIGasf6cyxmaGbu5sd79Ox?=
 =?us-ascii?Q?i8M0ggJAHj0cXFYHePsQzUItPmluStko2k2T8PkwTHXy7RgbRNMeWdHsi8C0?=
 =?us-ascii?Q?E6Zjbbqp9iUym82kUGEZndmUlm0m4TCwZNzkGrSclPIYGDgRQDXFRY3sDY0U?=
 =?us-ascii?Q?BqeC3shXYof4/DF6Ninu52zWdtyEUBn1RWxNolq4vGh1MkhE4LrmbFK/1awT?=
 =?us-ascii?Q?8NYQPaYkYCkukTBhQeG6k2pMoguRAFJH5mTemfiMLEAGzac1XW90b1Jl2/6M?=
 =?us-ascii?Q?YsO5tgI6qp5ccfFRa03kpLl30CvVZyyOvNFZnGCLZ7XKkRY9HYAGfGDSPtsf?=
 =?us-ascii?Q?9AFY0xkeXFG3/s482egH2kYZqk2bhvmmPwz8HXLUfj2CtNCfLTf/zRKvhaSa?=
 =?us-ascii?Q?Qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	S3wJgseoZGPZ7CVkkybD/GRrhhVCQkCmPGUDdHdo/RZa3Cfym9vmCDNJ+xnTk6knh4M/SPktJAYIXny9BFuCgOillF/lTGxW+2L8u/2q2CAOMquNC5JLFuawfgMFXaJdhCAgr/9tDOrSsUsWhzFemFVnqthaGyzKivLLFDFFL/WJB8sjbAAAyYjskVDTrlwACY8vuxbzxdyLL0/ioNDLtbWZ5sbk4cCkEjmzBzgojmXOYJsdsftWqnBdd8maz+2KlkP2LQ5NEFCRgFO692Qr4X4OL4ydH2FSDtkfJOh9A9bm7O6g4MZMynW54Qa2zUYvniq4h0IujZWZlbd4s7cbHce54l4so7AfFWukhXBnLvmiHsiXCccgvn9L+8LI8wgwV3vLoQoR863f4LqsTZ/MmXBCOTOV0sChQiHDGMQndvNiwn611IvTAD+0+lu5+SrhfFgNGcFDvr7V2NUhBxb1WW9wATLvNIixu6+K/zewo+So2ZWpjQ5KvTOPTLaDdneFBAAcozFEAyK3gkuADD3MCIxR0O5HDrCzbWEnnYcGO2fZvsG9xNFfKVamC9MDHxF/jh65KoQ7DLTHfdiPgxVGvaftEPhqqpUZ492ObNY2SVY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77bfcb8e-d26c-4909-9cea-08de3d16d1c6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 02:48:55.3140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: peBYJ4IMzD2hbD3nbowoWltR/xiUYp/yZnvj/cE8bKhUtqIVd1AVKMswibMtDwCTXJ/htFlGmnPamm0SgcnXgCLwyHtAcIS/bbyHCL5pB4A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6864
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_03,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=934 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170021
X-Authority-Analysis: v=2.4 cv=TbWbdBQh c=1 sm=1 tr=0 ts=69421a1b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=O9B65gHhmx45TnNocXYA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDAyMSBTYWx0ZWRfX8D1YhFy1Peuw
 Hxit3WO6ExUU6kfwylHzpKalz7VH8FTKaP1CCJni1WI7XKRzVukA+htqYiOijZBgx9kfm1dXcC3
 FtuoMptLVx3YK1oU9uj5Ahqrp/PCo7eH80bdCfgqVpmPAKcEes4dhN0PRVgQYinKu185JhDKePO
 VFoLm+idhEBONomtbScgC8tqplvvhrqrK2yLq1Bb6jfR1Fg/EfbWnJG2KBNhC9Evt8eMGvcuKKp
 lEH7PcWnBezVq6xbRL6UVz1sDzh2I1OdXIx8V8SIOKihUw/hDdrgcEPjq/u7gE4024laB4kASVX
 de0aZIaqPjDGLrxRyBSFuxnJ/drzr3RqpZKKPrrdYJyPnY+p6uB1j8VGRhAmaeNQKAe7rfx+NeO
 boicfLBTenW1pKpgWvvQ8Cf0gJ6wKg==
X-Proofpoint-ORIG-GUID: ErDzPv9RtcxIh6X6O8-wZ-5tFvg4MK-Z
X-Proofpoint-GUID: ErDzPv9RtcxIh6X6O8-wZ-5tFvg4MK-Z


John,

> Can you please consider picking up the first 3 patches in this series?

Patches 1-3 applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
