Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D980D5477E
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 01:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775180264; cv=fail; b=ecAO98oxgtYTwUMU5uPZ7w0zet9Yz3zS5OOa/jItnYSp4+wHAGbRZ1QaIO/iK1oE3rRH7Y2CIsy/Br5a20bmddcdZBjAVZ/lZy/G2n9ZzcicMGT52IjtqFCXmOOe1CG1cB//Xa6/ILR0Bc1qfEAYEz5xFQb028tYngz+ofgQa6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775180264; c=relaxed/simple;
	bh=nB2wWnxSlwIq6KTQ5IOPValctjFkA8rR5GRTivl3Gbs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=QhRVPt3yOyWj7TljyXuX+QOSGmgCmu/hLyk5nQxQdoU82febDs5jrb3lpQOArLMODbqJAgpQ4nhOp5aN2l/Gb/74PLxQt4VZGCDwbBB4TXfscqpZh9GUz8K/EX7h52mEjy8WwJXI/OZzqcg06DE4h5vSDwZNHixzXNtqwGpiV84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DI3DL5Ow; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=g1J8sVFk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DI3DL5Ow";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="g1J8sVFk"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632Nfku53751116;
	Fri, 3 Apr 2026 01:37:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qcYB5EJ29d38vneLMx
	yuuyBQCFQvqeFt7kAzzYadSP0=; b=DI3DL5Owvus7N4J7LJJRJjvKe/6phszWYD
	u6ZnS3xEVEkdquGByNKWjFMIm3L5vXv4S5qimtZh+KjB3aGmpqODHPchRIopULak
	FsxPfjenjjvJostV6Bjt2cCafVjTyPiXxiAq/VJ4MibqBn+K+PpK7NtCJgkhAph1
	/DC947MRfoNKic8L1NQArYoO6f7H9OqQbhT13XDs9fWGYIzbjntPZqerukItj8MZ
	EGulXOVyglXH2ufBVYg6qpyho51btXKvGTYynWfxaa9B2Zx/KivPFlsetDgPoLmY
	Hx8u2JpP+UFlV8hBNv2VXImEevwuIyQ+UjYYF5qOa9tjlVEuJ+JQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d65s11fv2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:37:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 63314kCU029039;
	Fri, 3 Apr 2026 01:37:39 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010020.outbound.protection.outlook.com [40.93.198.20])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65edd72a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:37:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DPbpNUG+nRkYueHbLY76Q9jloYbsgxM8cdsNuSAxbDWH+stFHQwQ2fziKOWpKgpmEr6mzZhIvIW5BjCDTuiH8WlmoyjMf8SLVNyR5RrS53mJk+2f53opCpx11Q1OYZumIPkrBDuIGk9DSjl/moPBq9l+GEJTXOuvz0+u1IbKw1+BvtaccAX6ujete8sSut0YO1bfF+BwY49kBF3tkIMlcgfqMhs2s38PWYqeElFluwuZODK3IysvFOb4QwHKYsXonTsLVSt8lEFhkQ2nvp/lAMv6zB/Bh1nN/VLiVXebmjdApjViD1aK34D9jZ7VsHl9yWYURFU6efSi/ttabIvalg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qcYB5EJ29d38vneLMxyuuyBQCFQvqeFt7kAzzYadSP0=;
 b=rot4wq+b6xRs+hVaDG4/tS0d/NffnlPe9KM1Fzk37qKb7vDhFMcc7ayeO9L9TUOWIZcJvFe1BSBPyAw/M0AQGIJF21MHIBqvHTxYH88oByEgAENfnL0q+CAkfcjzlyOI38NztLASGWpop6yvgwjbiPKnY2sZ9g5aU/YRHytFgo++nG2p2009M+eD9ijix6QEYa+cvSL7MmSfWSVdJUy6iOOTgOddBquSIX1a7mvAsx7ugfFIM4bgKeOweGfeor2P/9y2e9NwKk4L6CiRoS4XPSbXXBQ2EGFET+ruYwJW52aGJY/cWkxTE4hbuuuIbSRe131QN6SaMKUuGSkKVk9w1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qcYB5EJ29d38vneLMxyuuyBQCFQvqeFt7kAzzYadSP0=;
 b=g1J8sVFkGlkQ48UVSKgLA9wmVGbF1yoIsCmRA0Cd/2yx28ql7J5CmP71xwUw06bNxK1vhSklMRMnMBS8ldWFDpxLktQJT9eEb7O8L2EOhd4ttLleFwW8ULVPq6gP0Q0yCJTBB00K7OT0PJLdLZWDa0LaJANCu2GOL7LacjcO70A=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY5PR10MB6093.namprd10.prod.outlook.com (2603:10b6:930:3a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Fri, 3 Apr
 2026 01:37:37 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9769.018; Fri, 3 Apr 2026
 01:37:36 +0000
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart833426@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 00/10] Update lpfc to revision 15.0.0.0
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260331205928.119833-1-justintee8345@gmail.com> (Justin Tee's
	message of "Tue, 31 Mar 2026 13:59:18 -0700")
Organization: Oracle Corporation
Message-ID: <yq1qzow3ju0.fsf@ca-mkp.ca.oracle.com>
References: <20260331205928.119833-1-justintee8345@gmail.com>
Date: Thu, 02 Apr 2026 21:37:34 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0202.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY5PR10MB6093:EE_
X-MS-Office365-Filtering-Correlation-Id: 00499e72-ece2-4647-80e1-08de912195ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vkT7MiaipoXICU8cApyfD9hyyrYIo497EDtfMknfH35IeGITrR7IExTUW+oBe0f26N/NjNgeuGKz0tX9Igk5ysxwwsqxRvfHVTTeuICw5SPY3P36AS7fsNN3AotwNBGadohMIviTQw2Of5vAwOEXPwdbCnRe1Bg/uab8/5O4+iuvNq+RsMuRX/rLZCBNliB3o3pnmsKCRjrA3Dv2yBIREsAH307sbY/SC2RhKN1SNw9yjeU9hLCe9Ayv+ajdVDsHYlmsNStdoRWpBzhoz/bB1fz9p7lan2v3xXIAbHtzIZSOOC0JAmoGa8sLxg3lfbNaxsDAKZZd3iRoA+CtSnjoGzTCQ8uL3hHgIvTXSUA+L1UJ/nrDD7/qu12Dg/UbDQ0IZhBIjh7Q20l2PX9yGyA1D4e5/E+lZz9ZRzQ4w067GVKOLGzDXPZrNV9RNB0c6MfU9YXVYRwS52NYU7L5dPYqrlz3KiI9Nwq3gTRF569TsJKz7LktEDUHaWAV+C7sjvOqbYnuDRPHMeMVrt+xqpWNgLVy2BPpZcXa3PhWwL7DjHbuELwtmjGqLwpVMYitBFMMJPNEovp0mg6uHx+T6nSTSDK/DFJEgLJR9hE/6rQYqIwnE7Geq1oSAnon4GbmseOYZrgiEO7ni8+MCiemPApKQ9fObEZXKWRWZiyG9Hnk/Wt48glYPwJUIQw7R6my6goQ0xaexAnVXqwqY9Fqmsu2Oc6kNNzWLB/trSFUw5H5nGg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h7ZScpsCdljY5vatz4VjsmX7RoPVLcKnU3JN+hw/mnIGtqustxqGVUfTpF5n?=
 =?us-ascii?Q?P6ir8fhjh2Q7uEe6M6fd6s6nUCByNs3NVk99Of3FQUaig0B5fQbZ//QSyuIf?=
 =?us-ascii?Q?WHcjD/zbozM6LImyoMG92GAsAdBJK5X91oYoo2pF8DDkUhoCW93amy/jbdqR?=
 =?us-ascii?Q?RWVtvAv5TzeU+YkVs0AuvfVN5I6EKWkadUI6YBOSFbtFb90J7SOG4iyPnG6y?=
 =?us-ascii?Q?OWowvQwsdr2FWuRlgc4lXrtB1t13W9KQ2T+uQBGWVlW3mEl7LwF98Pf+LYRz?=
 =?us-ascii?Q?enYjpuUM4CoSGMbxwug/YWTImw9zARTKwG9DMmnR7Dr1jGuBYq+/7DFNRutV?=
 =?us-ascii?Q?pipFJgCI5Bm+kspErE2yVujaghxmyZ3NPd7QhCWIM8J1YwZqVK/WIuUMpLqx?=
 =?us-ascii?Q?VcMwpVl0d21A5hn5s4pH1eM9cx7NP8PQ6TM8BLBxL+9vx+KP97NYxIdzmcM2?=
 =?us-ascii?Q?02rw71vJYsCIFDdXFnfJ2QdLtOj3DmIH68VAXcf/hZYkLg60sad49itUJ+pK?=
 =?us-ascii?Q?XgGDfsBaD2R7oF00wffavApJA4F1r+upVFVhyrfbC7fAFZGvNYYqN5Ay8QVu?=
 =?us-ascii?Q?DpowfDnjt232qcgWH/7JEt2TuniuGRKFn/qksYcwWFohhvRSnYNw3Rm086PB?=
 =?us-ascii?Q?K9MdqLDQnkENpU7XLAz1Y1VaOqzfDPoSgTvpN2TNQewoZemEdzAOLmWtwu3E?=
 =?us-ascii?Q?eYp91iSSPJvKc7yM8oWtkjkRHwfgS/1WX6DkzN0990wfpsrsZWSNTkiVkkZi?=
 =?us-ascii?Q?gVG5XrhVwdn++uL1oq1VZGYeFkzJO+y/MUQXkmyGg7AbhoQfisW0VTw7OqzX?=
 =?us-ascii?Q?giRIt6Kh1KSOHUeBqoZpwY1miVc99EP1qJ1pHyRep6Fwsnhe7Twj9fWmfzUg?=
 =?us-ascii?Q?uriFWZgKoEeiRZI8j7PAWmUXd1RBjwtT2S2RyPB6X+bWMgMVRMqLpv/GqKcG?=
 =?us-ascii?Q?en53b/3mN2Zb0TcZmiQf35vzcgrh5NBagNWHXajSnmJOPN444M+iMKl35G/e?=
 =?us-ascii?Q?aQm6nQXEUZOhgyYJCdRMgmpraCDZXbMgC6aOQri9Fc1/dOGfc/TApyuCznOc?=
 =?us-ascii?Q?ubosoERk6gxpe87qHhU0Nz3J+gk/QWnQ0Zrbp/sitz7AFFBcwT0bUQtid1dF?=
 =?us-ascii?Q?s1NFCKqJ2joa0Tam+nUX3Ipxu0FgE7HJ2ZmbhaOfyLJOKVJl5Rxn1mJGElo7?=
 =?us-ascii?Q?sjQXClfYmRWMzOIU4jcD1Db2rCjM7LrmKFnVdzRBQUPE8+Io/ZiCB++LZA2J?=
 =?us-ascii?Q?LlsxYctUkA+8uaL727+i2zsfcafKaQyEFHbHebvyD9G/gT5ZCd2C9naPL4nF?=
 =?us-ascii?Q?HyB/sXg4wTZ3WGOuj+yQJ56Ahu3kpGgQyVrCK3Y23lCRYw4hLBxmrGnOtKIy?=
 =?us-ascii?Q?L+H+rKa3B6WN1LcYdGM5Ok8hOTiNxlDSoZ//zONePYoJzqvM5UQBPQBFYxwx?=
 =?us-ascii?Q?UXIdtVj7k22lHfgqUgF8HNlJK+3BdJkCENMcyvgmetIoP5ajYkSXW3q+6aeu?=
 =?us-ascii?Q?jyPknoF5w7rq8DEW3KKwcgAsHtCtU6aKjOs1LJe4u52ny+B6G//sDNOodDVz?=
 =?us-ascii?Q?7/a7Eaawvdksj8rqTLY3216Nsl0pBxp+iZDPqEZFCZZRbKC7xU/YCaOhAB9i?=
 =?us-ascii?Q?caa85WsjKlFT+en1cWOwhRuX2JiVHEsfAhow8Y/YMSOElcTZEJlW2dt5bzFs?=
 =?us-ascii?Q?Q8m3p2xU+tDQy0uHoloQ+hYIIQa0h+DTxOt8UKueBOAYfLQZxxS6hFDmaH7p?=
 =?us-ascii?Q?hgrWRrUqF5sWDfAtgsDMl9eEnOTwSKc=3D?=
X-Exchange-RoutingPolicyChecked:
	LttnCEjGnEhlLW/Z0N5zhS0DwfqoIndn+4A43FkCwgzvopt05Rlf4WjpaniVhRF8YTVOCnODipUwXoDbaKGhwGuUuY9qmA/c4GrSq4QmxAEI3wvA+rnvuDDq0HwEAS/Jo25Qq3NlwY/jM/HYsV8CiHLOuray73oXfTQhG7h7Eb2tHqecaez2hH+B+mtVj8/3Kb0TYbl1UggzVvSXHb8wK+9BIlzw1uDV4AQmHUuMkz67wGM4z/D0HrHWRtMi/jbtv2euQIqE25fDKZg5qij0QIFDJk2AI/FwnErlYL3Pf2mD1UCx7kf7h03LstWERB/rZK8TP1j5K5E3xjXGJCT8FA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G5KTBw6hlReKFe/HwM9TtJy8fWSw7n5h4SK/FDqHZQZCcqN0IVKk0hB5DTqA1qpRIGRZEp0LHvvcfNFoWE4acwYUSXSvHePVnV6ZtY/FesBC5G5YyGtNdkIpEFWTgAaALadJbgQk7BpqJX90M4BZhIbc2cTQISKH/sPI2NqMrWyDKO4hE78Ln4ts4oKDjJBcEyO4K6W/GU3+7+lTa3Bkebpyd+qgc4B9GNnzBzO1PjkXbzqCzOo/UqJyILrEgcMGcwKp3wwtvi4Izxgglsft+cpLpwT8ufvtIpCXpVSJY/D7ZxPvMZ4EvwWsMXw+DpUbzpgsCp0Skr39kZHSKsxGFPbK5omgi6ivEKb8B20SPGe9hO4A0YyWgdfh9xK5W9Bvu63qYtNui+CzJzzV6YeXYPr5vk+M6AnNAHOLvmv+KiKS9JIeZz7+ExstRvrs1SrXFR6E/YazHhvmHtA9ahxW+xeXCMvn/Fysggxn6NXStYiMkPbI1j7KZF7QbEw48TggPzYHY+snkbEIDf+wIM2vZs/xl+M+BN+Lw8NklQzos937bWr0y33LS+rwH8OXxf8/b1wzy8paFdLdQ5FuL/ZXeAXP5v/7JFWmj+wlpX8QSsM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00499e72-ece2-4647-80e1-08de912195ba
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 01:37:36.7604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3pihMPGk4hSJtDxZdeICsUiiUlyE0D1C1nvyO34GZ4Tdkuwipg0anDWtheyHWsLox2S7RXSUngQxW8NodruuF79BUKVv8lqlOYbHvwWNAT8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6093
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxlogscore=642 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604030012
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDAxMiBTYWx0ZWRfX8YOVDUkTtmzX
 rQ7DmYOs6hRVSOLdeWpLarxzRMVB3IeRyPDO0m1FQUtZyEgEHb587FZK2f4pFYkPuIm8nHTPIIC
 6LgKKdx1MUBwkV1pWJVgmQ4oHm7fAQW0ptWAbKKIykLjOTugMA4N7NcdxG8LSpO/8vayEuqofcZ
 3QySjema8+ey32Chdpv2BO4IjkkYlZqvvQGmHLPLsHZLJiaAIXLpl0F+3wPoTfYRV1kl3H2ZhVp
 jsrx8zQVancMMcWBcl2lBUxMQcgmkYl7vuoWSbxElPntqNAWBOk43gfHlTu6BbnhZY0SjY9LAw5
 BwTuJWZTs6U1cmuaAQoLJq4qqCBUC37V0UgPgfqCab6ccyvgmoxEfs9sP0YWmAuZ3tBsFCb9a3B
 2eTluy9hqlTdJUvhBRwe55IsK9aSK7sqyU+0D32FT1lQzP1yHJ4j5EQ3wqCRR4nIvjPsqkkWpgb
 5TpnRG6YeomBT5kFw0A==
X-Proofpoint-ORIG-GUID: qcsStdkeCKFiVLcO-38Z1ypVlECDtZVu
X-Authority-Analysis: v=2.4 cv=BvOQAIX5 c=1 sm=1 tr=0 ts=69cf19e4 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=t6in9Jhh_0YvQ-sgEoIA:9 a=DVKqRkKJf1IA:10
X-Proofpoint-GUID: qcsStdkeCKFiVLcO-38Z1ypVlECDtZVu


Justin,

> Update lpfc to revision 15.0.0.0

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
