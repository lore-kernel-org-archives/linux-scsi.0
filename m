Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D6A1EB40
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 22:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720650040; cv=fail; b=tN+aBunXcnwhdHAvEa5TYbDT+nNr2xcmUg2aUTRV/WYk1ga1Pom7JUtc25zM2wqFc1opxObQu8WTim5/QsdSba3NAhqHfDmN93HbJQaLiTWrwUbBvCeqXCsN8GJyzYhUsklxdTuwUhFRK1DvaQqjBZwcnsNf3kqvhFRDB9i3cGQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720650040; c=relaxed/simple;
	bh=MC4QHliJdpwCfoUW8ZP3ojRR/oGJ1CdwWdwyxP69V18=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ogxS4vexUhiqK4xJPTCm2MPtIFc7raTU/sNbIHqxIgmGi7h/Mq9oNgRsFMOLz3YrXegyPrOVEPGbmu9cmtJTNZU7L8vZ6QJfBpYDtQhNqk9qUGNO07qIE403is8aKDJp7QmSfuC5sl8BXa4bijCWubZIphQt4jO0M7Q3DaXDVVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QWrucoT7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=j2WxHAOe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QWrucoT7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="j2WxHAOe"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46AFxYFt012110;
	Wed, 10 Jul 2024 22:20:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=84WwuBvb10PeFW3/kTKjcqjSv2K0W073VR9o0gteaI4=; b=
	QWrucoT7w+DWJR0shwUGCM4i3pYISCC2YYHcHRDnor0TxQP9mJ+atXqXIC3SpaUX
	4KNKxr2FclBa78Z4QRDMR0ata1rTts3qCEVouOn6gGn3WW1JwnMECuYq3xAO9FD0
	X3H035YxyGAmNOHVFBLNyLIZoGsc7jcJdnowc9frkwsjbGAW5cSOVscTUmcnmhZM
	L9UOugK1JZrO8tkcsNOoMD2R3u3jcSoOgnXAKv05lXIiv5Z8pV7oIsaP+394Ql8T
	n/SImLU+QHyiZ9m5qsHPEZTdwLdFQkeFPDm25keEuUM8PajdF51feD80CdB9zVra
	R9nvof2H7ngi4ZPiXBW8Mw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 407emsyq7b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 22:20:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46AKRC4p029213;
	Wed, 10 Jul 2024 22:20:35 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2044.outbound.protection.outlook.com [104.47.55.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 409vv47a4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 22:20:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gH0vv+dgPEomlfv4nqf0AMlzfw3g3andIcuSWFXFOKaUY7SGqtWhFjmR7xigJfOuwV+lNMg2GpuwY7A1K3WzKLZPgWAGSNJOrHgGVluywcS1ploFrZzrAPljt+358NEhWJVfiZeJpoFb/j8Lj4JFyUktGqupYZ5m6kYq4OtKwoVnfd9tUVGQLsD7rXs626ZCk3zRJRiSvP9ZLA31uOyT2H4BQpIvsI2CCzu5U3oj3WHkNikHL/enAi9wqy/TBDZUYHdUJzeWbc7NSICVL9VmH7w9R/nqNN0BOt3L1Q9mabymcmWusvng4Q1BzU5ZZdhLZvrgMsuaDnS7FyrahhpdrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=84WwuBvb10PeFW3/kTKjcqjSv2K0W073VR9o0gteaI4=;
 b=RWz1qhUr6/LGOCMr/H7EINTdrFb7XJ3t4dCjCXVjvHSm/EHthrPjWm2QjXCQnDL3ko3hyLf7rP8ZKI74gA2aWkq9uK+xH7AQIIgi1mLXbk1uTD/763NVdDBtx4/Bv3Uhbe+Xzg3/1N3xrqn0XpaNlgTK97Ejkn5hEEVB7F+hBlmg3GV0Ctt47wBJw3SKWaavZjypUUmGPuer4Q1ye4scGkXAH1Z979RNT0wBe91ljpiUZpdnGnvEjSqmmDbGommbN3pP1po67fVbi7MDRr/am7wutpfIx2M8hWCTEnKNfcfwRcvX+atJi43b+ri9oesxuNeFAJSyibEDihnYibBokA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=84WwuBvb10PeFW3/kTKjcqjSv2K0W073VR9o0gteaI4=;
 b=j2WxHAOeG5jpy8PbUHLo3CMkchQ2jM8R8LfQO5jkUs7Xq8VO0j5UXOQfY/Cmk79az2Fog6M0oLxvMNzaPTeZ1vGwZmJjvTzr+iv4RTiU5afcP13zFjcj3F2iie2PHW+FX2by7sz+D0Tbot1eKLyv48SsKHnLiQBpZts30G6J/eQ=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by PH0PR10MB5730.namprd10.prod.outlook.com (2603:10b6:510:148::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Wed, 10 Jul
 2024 22:20:32 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%3]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 22:20:31 +0000
Message-ID: <5debf0a8-b3b8-496c-896e-85f0051c8c11@oracle.com>
Date: Wed, 10 Jul 2024 15:20:24 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/11] qla2xxx: Use QP lock to search for bsg
Content-Language: en-US
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com, emilne@redhat.com,
        jmeneghi@redhat.com
References: <20240710171057.35066-1-njavali@marvell.com>
 <20240710171057.35066-11-njavali@marvell.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240710171057.35066-11-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0293.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::11) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|PH0PR10MB5730:EE_
X-MS-Office365-Filtering-Correlation-Id: 10bb9b8e-3f00-4036-b0e3-08dca12e82d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?VW1vQ1JQd0JTcDRkSFphazU0ZC83bDhqSm9qVUo1V3lxaWhQeE1KUlp4ZlUw?=
 =?utf-8?B?QTBPTVMvZjZWbm5EazBJdTF1alJGTWNCQlc2T0RFWTFkZnIvaXV3Ump2ZU1L?=
 =?utf-8?B?STJQT0VSRVpZcnl6d3hjNVZXaW9BM1lFbWNSQ2xBd2FwZ21NeUVQM05nKzlJ?=
 =?utf-8?B?RVJ4cUh5eEJhcmlOL21vVE1LZTFDbTgxbWFQZ09sYW9qSmRCVUwxWGt6VGhh?=
 =?utf-8?B?SXJtNHlHK0YvU0xDYlVOdVFBeEgyZDVIUC9nMmJzNjFZeTlFQkhMVHNlaStG?=
 =?utf-8?B?dlpMZXhPK2VVeEhwVllIL0xTSWFmWFd4dGpibGVXVUtyL0tFenV0L2U5eDg3?=
 =?utf-8?B?ZE1rZ3M2RFdrQmlNQkcwOXRiZFVrejNWMC9aVHlTOE55VTBhM3lYbGh1SVdD?=
 =?utf-8?B?TzhkTENWZ2xOcjJPQ1BjWmFWN3ExLzlSUHN3ZHQwSFVZNW1uOXRLbDN1c1Ev?=
 =?utf-8?B?NndlNXBQQTZHVG9PU21Zc281eXZkV2tpd3VKcTVvZDBLME12Y3RUMldYREcx?=
 =?utf-8?B?UFR0enRUTDFTbWZhUklySWdsQ1pGajJOYS9LWWpxQjZWZXVIaG8ycTNJbkFD?=
 =?utf-8?B?djJueTVtUVZqMEFEeUdxbGwxb211V3NGTThYdm45ejBNcDZwckRMM1BpVzVi?=
 =?utf-8?B?czZ3enliTVZ5dGdlclZhZUVUZkg1N3RrNW0xSGJBRFpsRnJDWklEMFpQNXdT?=
 =?utf-8?B?b21IWTAyV05VSVVmNTF2Zmx6QktUTkhOeFR2NEp5c3RPcFpOR2NQRWlqZXJu?=
 =?utf-8?B?ZW1mMk4xRkZLMEU3TVRYcUlaNm1jUEZvU1pORElSMTQyYUNNdTV6K3FtK05H?=
 =?utf-8?B?ZitiWkZFQm52b05idlBKMEZzTWM0bzNCVVJaanViYllUSXppazF0WUJ1VEo4?=
 =?utf-8?B?ZFo4MERNNEJBMFM1UnJIMVJjZXIvbFUwL3FEc20zZU9yb0FCckNyc2RtMU9N?=
 =?utf-8?B?UzJEOHlYdy9hdG1xK1BVNDhnQ0ZJZllMUlA4RVdmK2lENG9PV0ZlcnU5UTlr?=
 =?utf-8?B?aXI2OU5mT2FkVU1DOVo1Z2wxMWMxVzBEUGRCZXZBb3M1TVVzSTc4NFNya3pj?=
 =?utf-8?B?QjJMeVpuVHBzbnJIWndKM1hlOGNsWjRZeFFBRkoxeURTdEpaUXlGbndodjl5?=
 =?utf-8?B?RDF6OSsxRjZHekM0Z0JHWGRTNUpLRFMyK2ZMWWYrM0dVenpqL2ZQdzRUS0xC?=
 =?utf-8?B?WVp0Z3JHSnBSMDYwZnByTkVneS9DTVpqc1p6WitjSEszc1k0U3QzSldMaWVj?=
 =?utf-8?B?cndZVzhDZ1dUYWpSYjF0eE5FcFpQNGpwRXZPQTYzTE9icUNmb3BCZFJJMWZU?=
 =?utf-8?B?OHpIajBHVDgzTktYZTgzcEZ6NGd5cXhaN1U2VFlrb3NNWDdVVkxlbDRWZjZm?=
 =?utf-8?B?ZC9TR1NORmpENTBqcEhwbTFORjhBdEIwUG5iNmpodVEwQkNrODk5OWhjYUJW?=
 =?utf-8?B?NGRDUFpJNDdiTjN5czZlcWpBT3lVWCttTFdOT2tkU056aXF1bDdSVi9ObVBD?=
 =?utf-8?B?VS8wVmlMYllyL0pSS1grdzBwVW5ZNTRQa1BkOXpUQmprM3JJajJLZmlhOEUw?=
 =?utf-8?B?Z3NvcG1IYWkvNE1XNHFYbkR2Z21LZFo0dlJqWXNmTjNOV2ZTK1dXSGtXZEVJ?=
 =?utf-8?B?M3lBRlYyYStzZlJSbFB6ODFQYU9HWjJTcFRqRmR1ZS9aQldJZ0I5SWJ5ckFG?=
 =?utf-8?B?cUExR3VFc1JoOTl5di82b1l6ZER4czR6aGpqL0JGYy9sOHk5M00rWi9DQVdQ?=
 =?utf-8?B?aUEvMXd4eDQwNFVORDJGUFNoWTlCTDFYeVV5VTJtSThvL3ArajhoRGhYOVZ3?=
 =?utf-8?B?SVF5ckdXUHpFa08weThkUT09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?THBraXRNRTg2Wm5WTmh3ellwS2RtbGhrS3lTcHBjZ3AzYXNvL1lPWDlDTUxh?=
 =?utf-8?B?SGhWNlVGbWZmam5qc1dTRldhWHpucS9zaTlkdEp5R0JGeWdIdGJWUmRBdG1L?=
 =?utf-8?B?TkpZOS9odG1BaVY0WHZUdGR4c1diNnMvWmhKR0hRQ2tVWmdoWHg0c2tpdUpq?=
 =?utf-8?B?enFIbUI2dnBMY2FKMEJZNGw5czQ1bDRWS1ZuSUNoeEtBMmkxMEFkVHE5amE1?=
 =?utf-8?B?M3Z1R045SnRFZUlpbzJCREtTdEhiMncxRjMvOEtrM1ZUZ0M0M0V6Y3BXQnlM?=
 =?utf-8?B?Z3dzNmltU3ZDVkJod2dqNWQweGxKZlcwMnBKVnZ1OFM0aG5oaUdPWG5qMS9i?=
 =?utf-8?B?TzdTcDZaaFBqbEgwcVEzYWU3OWNxQy9ISFBBVWNXQys2TkhmYjczTE9uckkr?=
 =?utf-8?B?TlkzTUxpM0ZrYldtTWtwMU8rYkVOZFdWTXJzL2hyWFI0azRIV1BBSmpzM1NJ?=
 =?utf-8?B?b2ZHYlg4ZFJ6K1p3K1RQUVdPSkxLMXdZRmJOUVVwQlBmZHIzZHlmeXdDNTJX?=
 =?utf-8?B?QktYVFQ1bndnbUlGYTRWb1Z4Q25wOGtkUVdGcWdMUGtjQ09oUHVmVVE1WjhV?=
 =?utf-8?B?WVFxMytoTnVrWHBkRU8rZnpXOTRIUGMyZXVIUUpBQ2RFeHZvSkVteVBzekx2?=
 =?utf-8?B?UXY5WEg0NTlKeWtUZmdzUnhZcjJjeGMrak1UY1hZemFDMU5OYmljVXRYOG9a?=
 =?utf-8?B?SmNqeml5c28zWFIwaUhhNEpTK1hkS05ZZFVhUTkrZTAyRWJ2Tytnc0NXQmhX?=
 =?utf-8?B?dXNQcXd6UTdXamVrOWJtNDVSb2lvdXF3RjAzV2xMdzhiUk5DblVIRkd3ZTBo?=
 =?utf-8?B?a2ZEMyt4T3lTRnRHQ1hkUUlTTlVpL1pwLy9tc1ZLancvTDNOWUNzME8wcDk4?=
 =?utf-8?B?NktjeVZLSDhJMVN6Skc1ZWp5WlY3TnRBajJYVHhNQSt4UWpSaUtJTDIzZHRr?=
 =?utf-8?B?ZWZxU1lhaDFnajhrTXpRM0RRY2VOcWQ1QXRVaHNQZzQyY28zVnNsQ21kL0R5?=
 =?utf-8?B?RVp4bjJuanVPMU1qTDlTdDE0cXg2RmNkajV2aXArbDF6QXJ4a0NkbVE0dEVv?=
 =?utf-8?B?ME4xR3RNUDJZb0hjZTU2N3dxZGRraHFhVnNETlIrdVVFMGRHV0Y4QWQvOXc2?=
 =?utf-8?B?WjBmT3NhRzQ5MGRHREczZCtrb3lEYnNZQ2xVUVMvcUdzRDZaQWFQQlhlamQv?=
 =?utf-8?B?RzU1L1FvdUZjaGI4N3ZnTms2UGJFZVh3RXc3ZHhXNG9Ya0VGaTgxby9vNk9u?=
 =?utf-8?B?Vzc4Z0NYcXo2ZWVOZnhVa05ZRXBiYzlEMlgvbFpRYXV5UTk4VFRodUhnK3ps?=
 =?utf-8?B?Tm1Od1B6ZVpsSDhsYVY0a0FwOEhqNTIvR1JmTkdob0l5YTZ2dFJpeXJ3c2Rj?=
 =?utf-8?B?NzlFVndTQkNPclN3aEJOSW5MMzZzRDFmQlZsMGtESEwrdnc3T0R2TFprTFRY?=
 =?utf-8?B?QWJmUHJDbmg5eHdFdUx5OGVlK0d5M3FSTkswNlhvVDlKOEF4UkxyY2xQcytY?=
 =?utf-8?B?RWIvTkhlSUdQL1hNT1hLRUFMMlJCZmlYRHJZcXBEb3dYejJSd2ZnVWJtOVE0?=
 =?utf-8?B?alpFUE5QZldNUlV5OTkyTDJNa3E0YlJVbEQ4anhBYURaUzl5TXNQcFFzTzdr?=
 =?utf-8?B?WFJhVWtidW1TN3ZNdzNxYnQwTXRyUzFiUEpTeXMwdTNnb0dKeTRNMkF0dUVi?=
 =?utf-8?B?YmRJNmwwV3Y0VGxaUVpoSTNpNnpDNVVqd0s2YURianNtaXpWNlYxQzNhNzkv?=
 =?utf-8?B?WWRnQ0xSV2JhMTdTanpxZHJhTzdPbjliUGJEQ2pIbnhZM2o0N1JYeE1FMm5S?=
 =?utf-8?B?ZWVaaHNISW5pOStWNW9KV3NIb3ExL2NCWjR6aFg0dmEzd3QxMVdhNXZGQ3pt?=
 =?utf-8?B?KzYzbHJ5YUdqWk5CZUVINWV1RFFvWks4ZHNsVmVnZGl0VW52S3VkamRqbUsv?=
 =?utf-8?B?anFmblpYL1ZjNmpCOVUvVHJpSUlhUTMzbDY3ZFJib0RaWU5CeFRZSU93ZGdW?=
 =?utf-8?B?VHZpeHZzTTFTTXRhU010RWY3OGRsQ0RFNzdmQk0yVWlKTzVCSTQxQ290b1Yv?=
 =?utf-8?B?MWhBU0xLOGJ2aEkyNmNpWkdlakYwZWsveUM0b1JDWm5xRU96d0tmYVpuU1o1?=
 =?utf-8?B?Z1RTYkZWL0dDUmtTTDgrYUZDZkZ4YnhzYUNNYVRKd2l3c3BZSkFsdWNjM0FH?=
 =?utf-8?Q?TzkBx6zk6CahiCDcAo0TXrQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Lp1QvoQTowWCYV2Ray3Hi234enJWg3opgv/70kZFQ8gSkBduXFJNJgt1r4YNplaNYrWICFBuhrBl+fPhZ4XRIKZ8WbkCfONxw6BPwQjb6OCBWNRnjxvIh4/NnJyGneCsZUVP5IPbTxn9IFQeAgVib0pbog+2c6SQz3jcDpBJQiORON6+y4V4otHlY4B2ac58uY8okI20xbd9gKXQES2ygGl3d1uMpR7NPx0Eha+FzHqXCNM0wMjHtWYVID/Y9xrvmsi8Cy/U5ulUqmQ5s7k7wnly71w4Z0zU4VrlO/a16ZRIqstY51m1/U7cGCpfrH1OJAKCJPaxqg2LGWHcdTdCfVM1jPH0FvILMheW+sBzChwudSFsX7zSDLZL6FMo43cntz890r1OmMshLIC9a6fI6JoN7v3dCzpc3g4TkeUGyUkDzc4Bl/LovjH92XfbPeW51oHgqBGfCjJkukNC7T9H1z+8bsa5bctgnBCpHoIkUww9yUVzxxwpqEsDDCXPXIDE8NZWDNy+xyAfD6CZi4Ru3irnDE7gRVZz9CDhKszAuu8AMNcWP40zsSArUThza0l9QuuKBT0APH4ryA8z02GLbsAjWV6CD4VMo7e4yzkca1Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10bb9b8e-3f00-4036-b0e3-08dca12e82d7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 22:20:31.7890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kQYCDjw70+dMnz9cNWVtqacOMgyS47zP1+oL0Qy4Ryy6/HoZXW8FlDm59yG0h9OU/RO4oVmah9XoJp3tEitpXYbJFgFUYyfhcbBgJGXbAXc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5730
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_15,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407100160
X-Proofpoint-GUID: VFVB6mNnMx06A6MLtMmLBKrXbe0nrEki
X-Proofpoint-ORIG-GUID: VFVB6mNnMx06A6MLtMmLBKrXbe0nrEki

On 7/10/24 10:10 AM, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> On bsg timeout, hardware_lock is used as part of search for the srb.
> Instead, qpair lock should be used to iterate through different qpair.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_bsg.c | 96 ++++++++++++++++++++--------------
>   1 file changed, 57 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index 8d1e45b883cd..52dc9604f567 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -3059,17 +3059,61 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
>   	return ret;
>   }
>   
> -int
> -qla24xx_bsg_timeout(struct bsg_job *bsg_job)
> +static bool qla_bsg_found(struct qla_qpair *qpair, struct bsg_job *bsg_job)
>   {
> +	bool found = false;
>   	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
>   	scsi_qla_host_t *vha = shost_priv(fc_bsg_to_shost(bsg_job));
>   	struct qla_hw_data *ha = vha->hw;
> -	srb_t *sp;
> -	int cnt, que;
> +	srb_t *sp = NULL;
> +	int cnt;
>   	unsigned long flags;
>   	struct req_que *req;
>   
> +	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
> +	req = qpair->req;
> +
> +	for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
> +		sp = req->outstanding_cmds[cnt];
> +		if (sp &&
> +		    (sp->type == SRB_CT_CMD ||
> +		     sp->type == SRB_ELS_CMD_HST ||
> +		     sp->type == SRB_ELS_CMD_HST_NOLOGIN) &&
> +		    sp->u.bsg_job == bsg_job) {
> +			req->outstanding_cmds[cnt] = NULL;
> +			spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
> +
> +			if (!ha->flags.eeh_busy && ha->isp_ops->abort_command(sp)) {
> +				ql_log(ql_log_warn, vha, 0x7089,
> +						"mbx abort_command failed.\n");
> +				bsg_reply->result = -EIO;
> +			} else {
> +				ql_dbg(ql_dbg_user, vha, 0x708a,
> +						"mbx abort_command success.\n");
> +				bsg_reply->result = 0;
> +			}
> +			/* ref: INIT */
> +			kref_put(&sp->cmd_kref, qla2x00_sp_release);
> +
> +			found = true;
> +			goto done;
> +		}
> +	}
> +	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
> +
> +done:
> +	return found;
> +}
> +
> +int
> +qla24xx_bsg_timeout(struct bsg_job *bsg_job)
> +{
> +	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
> +	scsi_qla_host_t *vha = shost_priv(fc_bsg_to_shost(bsg_job));
> +	struct qla_hw_data *ha = vha->hw;
> +	int i;
> +	struct qla_qpair *qpair;
> +
>   	ql_log(ql_log_info, vha, 0x708b, "%s CMD timeout. bsg ptr %p.\n",
>   	    __func__, bsg_job);
>   
> @@ -3079,48 +3123,22 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
>   		qla_pci_set_eeh_busy(vha);
>   	}
>   
> +	if (qla_bsg_found(ha->base_qpair, bsg_job))
> +		goto done;
> +
>   	/* find the bsg job from the active list of commands */
> -	spin_lock_irqsave(&ha->hardware_lock, flags);
> -	for (que = 0; que < ha->max_req_queues; que++) {
> -		req = ha->req_q_map[que];
> -		if (!req)
> +	for (i = 0; i < ha->max_qpairs; i++) {
> +		qpair = vha->hw->queue_pair_map[i];
> +		if (!qpair)
>   			continue;
> -
> -		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
> -			sp = req->outstanding_cmds[cnt];
> -			if (sp &&
> -			    (sp->type == SRB_CT_CMD ||
> -			     sp->type == SRB_ELS_CMD_HST ||
> -			     sp->type == SRB_ELS_CMD_HST_NOLOGIN ||
> -			     sp->type == SRB_FXIOCB_BCMD) &&
> -			    sp->u.bsg_job == bsg_job) {
> -				req->outstanding_cmds[cnt] = NULL;
> -				spin_unlock_irqrestore(&ha->hardware_lock, flags);
> -
> -				if (!ha->flags.eeh_busy && ha->isp_ops->abort_command(sp)) {
> -					ql_log(ql_log_warn, vha, 0x7089,
> -					    "mbx abort_command failed.\n");
> -					bsg_reply->result = -EIO;
> -				} else {
> -					ql_dbg(ql_dbg_user, vha, 0x708a,
> -					    "mbx abort_command success.\n");
> -					bsg_reply->result = 0;
> -				}
> -				spin_lock_irqsave(&ha->hardware_lock, flags);
> -				goto done;
> -
> -			}
> -		}
> +		if (qla_bsg_found(qpair, bsg_job))
> +			goto done;
>   	}
> -	spin_unlock_irqrestore(&ha->hardware_lock, flags);
> +
>   	ql_log(ql_log_info, vha, 0x708b, "SRB not found to abort.\n");
>   	bsg_reply->result = -ENXIO;
> -	return 0;
>   
>   done:
> -	spin_unlock_irqrestore(&ha->hardware_lock, flags);
> -	/* ref: INIT */
> -	kref_put(&sp->cmd_kref, qla2x00_sp_release);
>   	return 0;
>   }
>  

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

