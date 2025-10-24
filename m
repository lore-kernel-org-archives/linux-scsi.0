Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F11329A2
	for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2025 03:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761274894; cv=fail; b=mlHXs0pMrOzyQaabbT5TfSrLOSmqi2AaOTiGpIcEv0NHOfFdi7girYNpkvOG7QuK/3mqWndZhkYnQ6uUPQi6QbZPemm8eBq7YZ4H8X3p0Dko4o2KzQvLHCKf0A9qwPkp92py43aUaUuHA394MmcOFKbUWl/Yfr7HyVvyhoXaWPg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761274894; c=relaxed/simple;
	bh=TaQzzqncvXFWGj8X1N/MysYwuJCn7cenJ0b9WfVbONo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=RyOnKXYjEWVl4Vn8gz5r2d7oNlXfdIu3nithRj8TncnufRIWWhubHftWk/IO5mu/OKvPlEjCu/931Vyu8iXhQcbDY+o47yyg26GHTP9OegO9vDN3/uC17rZx2iXkdNxHipRfa3UqRGNjlN7ITEMllARPrgD3FUWPYnYHGQnGn0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AGPBMZDx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vnQl7/79; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AGPBMZDx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vnQl7/79"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59NLNQxm011932;
	Fri, 24 Oct 2025 03:01:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=pLbktRf0ijukj8RoYy
	seM2380cK/PT+wiQl5Ao9f8Gg=; b=AGPBMZDxkwK/aGy/CN9boQ414/qsnRMYry
	3vfPT20UpD2b7HnBVqV4tixDdkD/fuNKgL62iYq1ysDkCzCfKiQZvuStWGdCnoS5
	CQMR1xWDBpKlsk722mGcG58xE546B6zUcHFCuZ1XKKYHjUjEDTpJh65theapn5O5
	GN4VfjB8dpsHHLWpa6onKjt/J22ESoibcw9vapXEgCo4d16ugfLoWDTVWFBOXHAG
	EUxGGB3SR6sGESo+BLwf2THvwnkrcNFk/ddUGOJLrGV/rKbZSdfVEElj/EQQdgBM
	HWTHUW8FJ2LO4vakdm/kgl+c2l7828jN66CWsQmFxKK4spB0LD7Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xstym4ag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 03:01:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59O0J4Ce035520;
	Fri, 24 Oct 2025 03:01:23 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010041.outbound.protection.outlook.com [52.101.201.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bgctuk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 03:01:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XdhMjQYn2+zADGIrznx3gqLIWNcSJPnagR5Y1dcJeRBnloPShqFFwf4rRdp6Qur3jsRdpF2+3BsAjN4I8XqwzFrohyZVVgbxnPewStK3ptuGjJUeU8iDcxwtJYYZGCHugkRDazuWpgPcryagLrTGwDQx68RT2m59qrFLvfiIj/ooh/QgES5RQ/Dc3cso3OEhOuFzgMujLYC9xruJ2xkP/J4uSklnjKo/yOYdsz+GL/iaeGVZYYtTTZrgIxU+aPhejX+M3rwFLKP+bZ8SSRLyrTBD2DuBx0wasKhMeUTOJQ6qHc6LWYXZkI2F+Ajo2ZE1fsgtEmH8o7Nf9DdgfjwaBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pLbktRf0ijukj8RoYyseM2380cK/PT+wiQl5Ao9f8Gg=;
 b=Z239lT0IoISB8DKTbl05LhKPEcmW0iKPmy58/iIR7IonXT4+Xrme0itImPYW5pY1+QCaXNndyHO+Xyq/3IoKApv89txJEg8CsdHhCunRSS+LALnXVqtvSzK2j1kNpdegvAyfKSWXpzt2W0MeWmlwJNswoIQEMTGtGdYpxpwsomHMO0rpts4sWUjJZFpUclhVuf2Hy6iNrLKc7enUL2noZ5g2jP4B1IfPEHBrGtMch7qIrGDd5mgFGx5tCNzVhPP8Bf1ZB4EPMOfFIAqhXjA3QlufZu/8riQkd69f7XggS7mVTahWiqtriDAVxdmQr0vtE0Fu2GMgSdaZbdbZ0c5U7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLbktRf0ijukj8RoYyseM2380cK/PT+wiQl5Ao9f8Gg=;
 b=vnQl7/79HKPNT45DbIWtAxC/7tB6OVR9cHY6gqqCIAKWYEvHmX+X2Q6y9Oa5YYxiCX2ppcc0VMBAL0R7tuUllPBrZ53TGvQ3rYtT42vn+O6TbNrQKh+SqgJT8rJWSFDO7kAyw5gbQEbkqAd2CuDP119GIXP/I8jB35uFY34MfGg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB7512.namprd10.prod.outlook.com (2603:10b6:8:165::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 03:01:20 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 03:01:20 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Gilbert Wu <gilbert.wu@microchip.com>,
        Sagar Biradar <Sagar.Biradar@microchip.com>,
        John Garry
 <john.g.garry@oracle.com>,
        Adaptec OEM Raid Solutions
 <aacraid@microsemi.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: aacraid: Improve code readability
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251021201743.3539900-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Tue, 21 Oct 2025 13:17:43 -0700")
Organization: Oracle Corporation
Message-ID: <yq11pmtxatn.fsf@ca-mkp.ca.oracle.com>
References: <20251021201743.3539900-1-bvanassche@acm.org>
Date: Thu, 23 Oct 2025 23:01:17 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0016.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::24)
 To CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB7512:EE_
X-MS-Office365-Filtering-Correlation-Id: 20d13054-0c9c-428f-e74a-08de12a99ba1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oNUzhFXHT6p+pVTyVIXOwrjLgoaF5luQtbLQfZfy9Zuoplc/ukFShxWPaLzD?=
 =?us-ascii?Q?lSc0YUMM1exp6qEIgVRbWHcFhd9ujat74gSohPm5Eix9X87BKBAXG+lhOmi6?=
 =?us-ascii?Q?apMRbrUlMKR6BNQOCWVfFuW4WX9kmfg+paAwws/+QZb8nIgtUBknRavUcZJI?=
 =?us-ascii?Q?W1x+7ow2KWVbuvtG4bhTsMw6HWl9Kn5slF31JcTZX5SsJf3M9W6UHqLxFe4o?=
 =?us-ascii?Q?EwEVntb5xjz/gAQg6Urdgx3Mhd7pvnTd1pkENDEQ5UnjTD+PMgas279aYZiA?=
 =?us-ascii?Q?fdon9WiUP7BpphhRC+0DKhlQ/6FpQ6/pdsGfcgZCBOgYzL5MJN9ZDdDkzdrg?=
 =?us-ascii?Q?E0kYCNEZ7LcgnSyWGSLPQnl+NNOQZrwL6fgIshATWtT4lxH6K7bKavscuOgQ?=
 =?us-ascii?Q?qgjovBHXtSndbIsTjAEiyO521k1OFdSlV/Ka0CJ/J+iCKszZKoHASbJvzZ+G?=
 =?us-ascii?Q?kpt/7hhIkxkHD+as4m7j1nrRywHxysoXP9hnJcCqCXx18KPuQdxp0B3qV5NV?=
 =?us-ascii?Q?yIFU3DIwc2AC72/o8gGDwoHmPr46Rza4fbnkYUxL1jiWc0o6xRSpyaCc3ISv?=
 =?us-ascii?Q?Ieg9iIxrYkKqGMzlW8/UlViC4WFTkBhgOGdZrFb3Mt453WAfGf62DbExLyOx?=
 =?us-ascii?Q?uihd8uvoD46Lz46qd944AA4jIo0Dw5rzTQtB/W5vWFMp6bHnw3n67JS+ap+e?=
 =?us-ascii?Q?b2fOP8PQLBKhfmbOfVayGTx/y5zz1/la5l1Xi/kjP51wXABj0wniOLN2CQN6?=
 =?us-ascii?Q?dp+zkyE/Pw0E903+mjK6EcNxVz8GFOjj9RWP6jK8yDi9vNOuJ8ygZJ/B8hFc?=
 =?us-ascii?Q?w9x/GvkdrCdITPHgjTbCpq+HRiB9KiAuROYl0yEg2IAdUbFVPO5ayFfF1il0?=
 =?us-ascii?Q?50eGl2t8fBU8hkZsfvYCZz8C9d2+SJ28lLPd71lUFyla0OymJETNv0k4eWjq?=
 =?us-ascii?Q?/gsHddRkWShDjgQmvCJk5mwVeXaO9DL7+SQl+lfvLdpU5t/UllCpEMh+VL5Y?=
 =?us-ascii?Q?ilGVcRm0O/hNvf7zEIzOP+t2xDbsQ/lMoRmfCUUaCy6CUTwi7MtWODYH0Tdx?=
 =?us-ascii?Q?EywIuLdn90cWzp3Enz0kxT11dMtgDFp3vUI41OqweAxwWUeVidqECtK/H2LG?=
 =?us-ascii?Q?2og/zaXj5KAk/x1uw2sC/RTGHmQWYuvJUyD70lKls9gzZ0GA1Ht6oAbEyQ27?=
 =?us-ascii?Q?BJUTo67sn4MwPM01UjD8dnv3nLdEr7p9z5yJyVk8qzyse/2uOjGPHXyn4+j3?=
 =?us-ascii?Q?t3zoMjEeh7026/RgbajP/7EP59y8ftpkJYf/8SYdJGHfw+Le8HazBe74zclF?=
 =?us-ascii?Q?1OCx+3lD3KdlH2emze/p17OzVukNl2anVMJc2aW8stwSZrzqqFyuHv76WX1U?=
 =?us-ascii?Q?J4MAOkorswOPPaZKPM9FgsRvLb0kX3fdA2CFZw04FSZe6jXZme1djHaf8NwZ?=
 =?us-ascii?Q?+kz+A7puQej8zNlNZVhbPye8xvaDarxQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uhwJH3xPc5WSecm2eszGXWXpn6MVAcscxfTb12trGC0akZWtTB6/LL/Fdk9Z?=
 =?us-ascii?Q?7e/pNJ8zAweM0CV8mWcBDfFdZPT4kAEyiGEKvA1khX5BEEaFsXBEt9aIpzBL?=
 =?us-ascii?Q?0olvPQFicamxZWMvAVsxAcgkx19HCMS558v1S8PMhKYwriTvawqLPcSbEE+2?=
 =?us-ascii?Q?gufNhAZyRyLkPUvsidGS/HYhslEPBzzwYuipCbhYr2mhwTcsRg+Zd8ErtVBK?=
 =?us-ascii?Q?HvwXB+395DNFf+vvzVEKFwp7HDKwz0OydogkTpojSoJycxQAjdBYFD7WyHgm?=
 =?us-ascii?Q?PCEhU64GpLVGKSYlWTwHcZSU0FPDnrBBvPcctCD4/v/0Va5mbYyUNnuPIs4X?=
 =?us-ascii?Q?U3699sspevhmOA5dVza3i/3Q4Wq1b9O+La4vUI/sw27ZZMDaX6bBytUzW7/X?=
 =?us-ascii?Q?oZxn8WAq7IuPTbnHhdoEB80hEtSal9bzJpF/Fl4dcrq2PPTSrX1kg/EhpVpQ?=
 =?us-ascii?Q?vl2JfoQbVNgk/jLcXlMwBdUBvfcs3UmaHXDtTSq/eDTFKRCf8aS5s9jFHzRX?=
 =?us-ascii?Q?8sGvMDjsDwA0eyZfWnWnpc/PgJdPyShgfUl+4i98Peu/S7B6dBvTwBacW0yB?=
 =?us-ascii?Q?04SN+SNvMuoEYQ96R3OQcpUA04y6o+/W9HCPGjn/lJEAtWGSBRuRaoFW5SYg?=
 =?us-ascii?Q?nsadm7y15ngpm22VUwQnLuptdpnFEfT+Taljm1jdbLwvz3FGdNoaVylR2hNf?=
 =?us-ascii?Q?NjK2ywptcTJz4KyIs/FZLaoX4tt8JelpqTDksQjNLI+f10S05APBaMdOyGCs?=
 =?us-ascii?Q?DdtFLjHdUdwS77RO5KxwBFyvZy3/+To0xBLwl/hwP/nsPPW0ZtZxHK4lJWRU?=
 =?us-ascii?Q?676zAcI+D88nwhKh3RD0I8H0n2NyGl3J1STMx1FBZEdUA8yCCcEBu3LnpPa9?=
 =?us-ascii?Q?+9c5X5aLJLHnnO8t1cCxfvKypdWPCAY2Zf1wsF5x6+8WcgUaOX7xpxS1jPJx?=
 =?us-ascii?Q?glgIjuDD7axpTSVE28kSGY4s5Nzd+7olyKPZLO+3nfo4nU4n05JpNXurYB+H?=
 =?us-ascii?Q?9vFPnMdWGPGtFvLigIl4Qc3Q9A4l9aIOgYQ+WLHCd1K0BgIA5GplZBBd1wnj?=
 =?us-ascii?Q?2wZoO0oFa7kPXLFN4DXUl9Jw2n04sGqdFFFNPcX0i77kahwdjfFcX8SgxOOa?=
 =?us-ascii?Q?9SSD8C+UEan0Sifn+MTzssHVYMqwIjhY8tfEt150PcCnm3DuTxFCJF4R/ATx?=
 =?us-ascii?Q?UxFyiLLuXSrxKf8ZYO8l/fdWPEX8E8KvP7D1cExZdw1BWzft+9+BIOeYinGT?=
 =?us-ascii?Q?lJ0O38FdIxcqFQB8dB9MGCtsp/5yDKoMmOTr+0jyno2XUlkxashAvUpjIupS?=
 =?us-ascii?Q?HBqu2RvdHhcndcCTnhottoxTIW7BHSkWk0q6rnaphMuixeJVQ9uPAjN4xXgo?=
 =?us-ascii?Q?X3OOqGM6m1zNrTAGMcxYdNHmM/XHZ0zJMRsSwAScdQfd1zPVmyQ5eJbRwRs+?=
 =?us-ascii?Q?n7I9F9CIR/lyrVv0REEYMi1bYVQpuTrVMlYoqLLHtdAokykfjoVKN/dd8gDR?=
 =?us-ascii?Q?75BlyZyqQFlFDoeY1OKda1RTW/Dlyf0UYzXe9IiAuXuHcH0YCxqOahYMAEC+?=
 =?us-ascii?Q?hoHnaRjd1ZUL7vz+TwN1T7+JxTdPN8AhBWD3w8CN7CfTk/SCy4UxqI8k7D3q?=
 =?us-ascii?Q?rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GVNC4ZTuy0/IT1VX3sUqrUXNCOpb5/Wod0i/hIpN2F69IXEwCaeOJJG8PrnA8ghkxFRJIINndvXsMIW4eSEwbc1QnchMJT59IUNho1/H4t2Dt7AE/pFsMNiHuoAj/r6IlTR7iCGautXs7pvqwio4d6jytXv+MyxBy4plnuY6WiNmxPT+4eVuueyq+6iJRrC1xtsfSrAydRQZHbzZjVIzTQgfwCqJ8XJgfbz4enIEUF44aOSkpDkJybDHjHM6SbFYbA/HAbmBNRBbQelfl10uf+tULoI2Z5jjkx2j+sc6Tc4DMTHQyA3MTOT/mXAgaLAPpepgB+49UR85jDFNsru+puJNk5LCjah1nh57vFJBVlEZCFVV7Wn13/VUCsMaAKWkmIw8Kowb5EPV5KDTvszrzjIaR5eAXD1STE9N+/umjNLuWivm8Pi3spZZqPJ1TuLfruoa6r3qpJPDtrSzCwrPl2+UaLDypiqhrgNJ2kytooBZhqJBUQbLwO61Fs5iJlF5erLVGD9PsoE9vcOn8VXEH7Di6wR+inpHJf919wunzzj8QZWVQrO/KCF6BtwtjM6tRY9RGPjQUmjFCzFnEF7dUK7B2AiKlgNd7jz3RdKNAHk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20d13054-0c9c-428f-e74a-08de12a99ba1
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 03:01:20.4065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 72eWKWE41CjromlMKCAA7TVA6lAqp/ar8iAGSxFN+pE62LaX9MceoUmVM71EacBNVy7JBVUFxolAbPJrHpV6ntkYF8QGSF3BHt5gwLLQCTE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7512
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-23_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=761 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510240026
X-Proofpoint-GUID: 1O0_eNwHEx6yja1zfmMKCZV5tlt81iSU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA1MCBTYWx0ZWRfX7ZKsB39dGEjO
 cOl6JET5H0h2z+acqTg1TkN+HXkvBoKfBfRK26+Gd2P5CekYBXA5RJ2eDoF0MfinjdDBeV+LKVc
 wG4EWArjTJ4ip2oCqd07heg1Nz/I4Am8ufjAHs86WmcxSvRoQWjbjSXjNQN40DKaw5DSm3M6TnB
 7g0/lDJFeHdEAPydIro39QLyxnb1x+in0/0hmEtddsPnw5ODvY3IxnuzUxJ7TtlNTQj/qaqAdbd
 ot6G3cN+R/Ys8FgV3nyy2UrVhBLHpe3h9i+L31xrjr57Hru4DdcYb4xPwVKlkT6WWX64g9cQuBg
 xccJooeHS0PmGubValourC5pf/lUOk4n6qnB43PmdAzsU7TsU3vYDvNuodT/XjYP8Ld6Rsp/XHm
 2ftIiiHCMrgg8hTKSCFQrGgS54+NsUyynFcAlsYdgXnDQFiG3FM=
X-Authority-Analysis: v=2.4 cv=OdeVzxTY c=1 sm=1 tr=0 ts=68faec05 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=ZqE8iiNBColObR7-44oA:9 cc=ntf
 awl=host:12091
X-Proofpoint-ORIG-GUID: 1O0_eNwHEx6yja1zfmMKCZV5tlt81iSU


Bart,

> aac_queuecommand() is a scsi_host_template.queuecommand()
> implementation. Any value returned by this function other than one of
> the following values is translated into SCSI_MLQUEUE_HOST_BUSY:

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
