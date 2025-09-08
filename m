Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849B812B73
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 15:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757344365; cv=fail; b=feiYegoOY6k80tiCVo+9D6D/VyIooc/aJ5/poEKmRdQVn0W8XNlZLjab9b3rfZwV6mDP6ITktJ7xL8zhXwuiy4JHQn92x3fMr6NrWB6V1vQrzy3MJS0pkwEISJUl0DHvby47+gYgejFeVRozI/MElo5zXuEDtjZEvI1htB72Stc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757344365; c=relaxed/simple;
	bh=vgM6sGDT0BoU6PrSRIIqd4yH9clVGrmEgP/h3plOUPw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=JMsdQ5Lh1qt556cyDtZPeqBsd98/cbkVMVn6b35FtXr5RSkLOEmfS0ibq6cM6/xlZT8MiGSVvTbouVeIRe8eBqoUksxXzn5/Ou/gKe8X5chq2Eqz5OgGYIKR7/cFh2n2mVAyOWVK7cCWKrrFFzuBO4l7Y6GLQu0ZLCy/JPrsw04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HrCD5sfZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pF/iZvV6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HrCD5sfZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pF/iZvV6"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588ExTX8029206;
	Mon, 8 Sep 2025 15:12:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=W1onO3UHvRsh41+q
	sr6gjcVl3f1UF9rZSajh2aXFiNc=; b=HrCD5sfZTlMnp0QLYgLfZiXP9FpJH2r/
	lI2qHxZtHLPq+uwx0DXx0Y4xC1jET9h00sgjQXQZghqac1oULbemd/dc6DdImcAM
	JFqbExdihGKDAjMwDuyKCkyTytLav22ZISkwVhf14jMouyGF3gFvA/Jm2/R6H7dS
	hUecy5ixyozXN3AvCULOjX6Cw/V1DIOgeUx1Ff2SCKT1Ts3BcEiza7ywbDF3YkvE
	I1wwTVgcr59DW6xLsT3M6EtQkkjtdf3GXrcG6DFQlcrw2X2iaDqQhanoGf3MT6Et
	O0d9dgor63hiILOAZ76hRJVvAIlF22SxQ0zg/tt3Lugdh/+fQmqR/g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921cyr1ft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 15:12:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588Epv7B002888;
	Mon, 8 Sep 2025 15:12:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdeuqxq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 15:12:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eb5l/6PVkZMwSY9AoRtya+xO5fO5rOaaCSjI9ALX5a9sdPKSu2nfdyRpSu+0o6kAoHvw/cT98eqVTiTXZok1x5PwvXgpjL7rrU09yDoKxHONjxZgehcw5mxzJpHJ9VKgwhYzzrFhjqAUXo1l4WVaMx9bwU7+XsTqP3E/+k1IGpCuqZu6TuyoA/6M4+1UNchoOpUR8fGbTlq00YuGrel/etWNXfG1YCY4e1jOFP4wqn4uMENgBY4HoZl8u+TLx4PNyHxVHdCNINTFz2/2n37Uo0VjBnBLS+xScoifiXAlPRxD43Hl5MVD3fY2nZoLg6ylBExA03C9T3hXbP9CZXX5iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W1onO3UHvRsh41+qsr6gjcVl3f1UF9rZSajh2aXFiNc=;
 b=WCRim7OpI7xx0nRDtKc21k7vM+G5Ur5LjAcGJ6oNA+5DNpUcYrBqQTT8lIsPj9uz5YsGYjMQFFDxks2YIUInI4BfYkSyR71RIPaBkU1Sev/fBeIb0gytfTPCI1/94j4jRb6lXKyRQwJ72OODMkVqceeqLKtCMyjLm8e4SrARICMcoQ1T5WUl/YeSSJ3ocZD7EQdPVobvGlhAAtJwze21gEOLVXHP/7WKkeFhP6lBaVnGW5p7hRY9xuws2r/pVuBtzx7qhF7TxZk0y/3RjTRCq545XQgWiK7HUnVFq7h8GWM4Dy+njB/T53B8DHm59FsTzs9v3K5MoM+FUSOv85U+QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1onO3UHvRsh41+qsr6gjcVl3f1UF9rZSajh2aXFiNc=;
 b=pF/iZvV6cEZe8K/06fUtPJzwfuPhkeESqdePoHmkd2wSCeMlnD6XkjHrsvj6SbdYzH6GwTbwVbSBZ8vlxqSFObqh0p5oHVPcwDJzQXw79b6ugfw/MHopE8Y5Sfbcav04ynx959FpJiCodI0xjC1KAtraKdsumK+cv5/FHxTZzpY=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ0PR10MB6327.namprd10.prod.outlook.com (2603:10b6:a03:44d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 15:12:30 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 15:12:29 +0000
From: John Garry <john.g.garry@oracle.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, ming.lei@redhat.com, bvanassche@acm.org,
        hare@suse.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC] scsi: ensure sdev queue_depth does not exceed that of cmd_per_lun
Date: Mon,  8 Sep 2025 15:12:22 +0000
Message-ID: <20250908151222.964621-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0004.namprd07.prod.outlook.com
 (2603:10b6:510:5::9) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ0PR10MB6327:EE_
X-MS-Office365-Filtering-Correlation-Id: d8f7d7e0-ba31-43ed-0415-08ddeeea2094
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ViTPdveeVkyUiEhMLnQFzDbvZd8bYbV/EhKvnYPLAf7OlyImnRCnt625Ar4V?=
 =?us-ascii?Q?0fY0s6SURZUiMDmUCb6dWhSH+wbb1b/PTnHoN0AxU5MVGHTLZQt0wlKC0ceA?=
 =?us-ascii?Q?0TwYF6EtWLczTU8LGIkwQvXz+mf6aHT+XrGO8MvYe+JsKNpolBnQsjg0f4Ha?=
 =?us-ascii?Q?R93z08ZMGm43Tp3frSXbL9XGpfUVl9LlFy6M8dxMDST5liM44zndeK3+byw6?=
 =?us-ascii?Q?hMFdS5knQlC8jEYCw7SCNAbmGd9lWj8ab7cr4WFI8Q01dBwgDeM6PhWJjxAE?=
 =?us-ascii?Q?ia6XLDkaFnb5QIuM9wef+oJmSXz9kUNqgIFtg0jqDQLKcI+bGH6crrcVxhF1?=
 =?us-ascii?Q?80NhGQkrSXUOoCGlkHotPj/61T5igkpN8Wcuyud+rIV9tUQE744vK16uaK7R?=
 =?us-ascii?Q?UHXbOnJbPSIF5wx82YEv5tUGS3otHu/Cc+LaTpdUXHEqUpXKYq9yW14BAz5K?=
 =?us-ascii?Q?3Zr60i8sDVbx2UNlcvszynVoCPGBmgo/wo8WXYKhCN5EKiStNyYSWL+S93n7?=
 =?us-ascii?Q?eDAf+m2nEPzzqK4pGplUZAM7u5mlUREXohh1Cs91N2LJCwShlZ9/JE6bygfm?=
 =?us-ascii?Q?yr/0NmbLJqA41A35eWgy0wqiUz5tmwTRkaZB6U+1cXWdV4QXs61J66Kp5dCd?=
 =?us-ascii?Q?e3M+AQZeIo61FJGAWVhALRhm9xy2FLnZIwCgd40RZSTUaZG949PurcteOc5v?=
 =?us-ascii?Q?T/pTb2OVi+AAuwxXh8CgTlCcCMOgeSt68LxuwlFpaUCzguZ4F4goWAzJJyc2?=
 =?us-ascii?Q?BB0/AEZN+e/1fEgmVTZK6ZImFOsTyEVYdiQEwpBFiQ8bUyDBFqTXlPKksOdi?=
 =?us-ascii?Q?D01Tddl9b/eGae3z3VDmgscaIckz6pN4lhPqVLeAG9BM3oI3u5VC0guUj6W7?=
 =?us-ascii?Q?79ML8jQe4I5KnQZJfnFSqB9pCr6A4es93j6LTRhbmXXck2+DcIFR49axvoYJ?=
 =?us-ascii?Q?qQNFJau2TZWedqIXyXxDgt+MXtJJJ2obPtBllzIpetM0yJqbUsJZnkFiXfZb?=
 =?us-ascii?Q?gHBnCVMiGAKi4XSelMG6nXr3gqPduA2By0idlMjaSagVjraxa39ifw4WjWZa?=
 =?us-ascii?Q?gy09MvlAf20exP7YFESbNklSTScKXzO22IVJmQsXRy0j7n2HlCKpLEGO6jjm?=
 =?us-ascii?Q?yZND6C7reOFcXRW3jxt+NHrDYQ6I+K8uHH5+Fx1YBzBO8MCFWRrt1YjyKDbu?=
 =?us-ascii?Q?J4SVLlwGToDZgN07UI9JLVp/MCmqufBfqSoJN6KZt6cwBQRYUpI0Fuw4ztDg?=
 =?us-ascii?Q?oURKv/eVQ3bGtqmSAnYAgt2sN2tpKdRKCMITaxg4BWNa1hwm4TU6eIpzrmJe?=
 =?us-ascii?Q?KFazcG5TVbPQ3tD3jWjM1gIQlUH03P5JyWOuHgCIwo8BDrrWGqa4mdUWAjoa?=
 =?us-ascii?Q?LcCXEJUoDkE4Oxh019Gu138CxvjXVuTZRXuTjUGYp9LTMHowyb/Q5GZnc/cl?=
 =?us-ascii?Q?7ul7Vf82zKo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I+0utfzDLozqyKOm/Zh58VlzSRTrd7rwTpDSPUmTO8KJ4/qhmpBGF9q33TvX?=
 =?us-ascii?Q?ftNToHbwZnfafqEcSodW0LpGTdVQ6pIXVmjcl2X4O288Y+TC6gb58r/aLS1G?=
 =?us-ascii?Q?wkFASz4+J3/30lLMkkuSUb36Qsot4cU6o94J8mmDopFAGSpO+8vS1Iog70Pq?=
 =?us-ascii?Q?T7j0w2iHrrUb5UuKs8c3wChzj9e15bP/W1VTEUZOsol75vDD77AF64yOs9CB?=
 =?us-ascii?Q?AltxIaIDC/i7ZDO628TJOGHopZPmUtOsoADL50Y43W7/mmBjonneamghwbFz?=
 =?us-ascii?Q?04TFspHHJRyE5QsO/Jta8Pm4J1e1pH/xPq6lwhKIY0lTnVwvWE8/xm2Wn0oW?=
 =?us-ascii?Q?d5sKowonjw75HdWUIcRIee/Wa8WwkTbAMmsNEIaCunaJbUfbvJF0Ysa6zuZU?=
 =?us-ascii?Q?FN5DJ0Q+lvOh+H9daQuNZbWZfsx1xicZFmUkZjXjpHJGiRbIjk6yuexE/JSh?=
 =?us-ascii?Q?OvNa+hRIHUXbqj0mc+kYCeR8LCV5t2K5M9O+SjL3V7b7NxzTFL3v2D7jmVsX?=
 =?us-ascii?Q?cJxCfMHebmwd54m4w3n7flx8fmfg2UpS/Wlnl/0Ymj8+Wcz65aJstzy52xcg?=
 =?us-ascii?Q?3r25dYBsh4gdMPlC3ubZZF4Wb8IAs4sqeaduVYGnNKARqbnInDZ5r1W9deO6?=
 =?us-ascii?Q?sfF/nZ3xZ9i4WSspX+iSsvILZKAUHooEKGdlq5WS6imJi8j49w54wyNDfiVM?=
 =?us-ascii?Q?oN4HLSQV7ehkfDm52XOYtbcaoaQD6ZRkJOziFVXXqSCheQufIynWVnmJ9BeX?=
 =?us-ascii?Q?fWpfDFzYgeXCw4sxyVd0R0Voomi7GxpcMCGiCiJpFCFkRD7XzORqe6llRAmr?=
 =?us-ascii?Q?U0kQFUKg+voEkiVmodCkazaBUN+2oPybmEVt/EcdoIWlcKfaU8Y1zoqBWssn?=
 =?us-ascii?Q?7R4E4JGeSsfcaS3ZldBE6Z/Z2WGv03dlzuLJygJeIGjeuP1kvO2kdYnKThe3?=
 =?us-ascii?Q?u4CibJWSn+U7caacby75e4PsN6Nm64T2URxiZE3jGUfqVolp2fTwaYh/+1tf?=
 =?us-ascii?Q?bOLFfpz1c8C5rwfYtVH00l4vvmMsrI8ERhdqLSQ3cjfREAOj0IM5BdONT7B1?=
 =?us-ascii?Q?NXN0urlTkE9/KpnE1nf4yHIlnNtpdWCbfkIKDGOnHaHJD6E51QXS91MGgRh5?=
 =?us-ascii?Q?yTyTCnLfitVpvCZdYtd5QiJHgZyxS2BFLeM7tEyDHIRvkVOKlH73JQLicOQn?=
 =?us-ascii?Q?LHmOOVi25DhJank1iuFcauu8Pp5xcbIH7IIb9ik/nDJU2wJhu3NMOKdUSDpb?=
 =?us-ascii?Q?GkaJywMGmLTqOy3nTiUjohOe0BT0g/24u+f5fglpGLh/nCZOWA2IgOe94n/h?=
 =?us-ascii?Q?vWNC++nzYj1SYBzDUtCVzuwoNGr1jDmeHXNFfv7QkATTJu9aoe7INgGiy54f?=
 =?us-ascii?Q?frpa7eTm5ZsFcjqnLYo32JiurWLpKDe6bFjsrfB2vns+6rVASkPw53+FX0/+?=
 =?us-ascii?Q?2xde7R/iBrJCfj4tgyfpmd+HFhV/t/u8wRIzU5FDpeR3PIJ/eZRePsSFOQO4?=
 =?us-ascii?Q?jIKRpiN7FlhdXKYfQq7f9TIBvyIedbGhriZwQL+QIyVAyCEbZu//SzqLQqop?=
 =?us-ascii?Q?quz4iNzceMwgbPQmWruy5DnZ1bJULTmrtQ0xI8LhBQoCjYV2x1/V0w3BX6yg?=
 =?us-ascii?Q?6Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J+6SsIvvVbpx7CT0mcLadVnoBiRxpEJg6lWRpjHDLCgbzGbu54BGxkbn+ew15Y6THTXFss8gqVmlJDah/d7UFLJvmChHwU2w7h+KUV/sTTvrLUiZ3gTKURiRRk7BEtGOCRGqP24wY+4aW7BIStEP8DekZXi0kn4CnGTKNwLsPRQJtoGszgqPm9QHERZmfLs5GYLrmEQMEKR9AYegEk4+v8+OifQWho+2XFUdUV3WP33Tsdr4M0sKeojajr3Au8iQ3hvjUU2YBf88hpxS+8OA2EaQHvWiwK1xmNiKjEGYmh0fR33Qz6I1blfEYSc4p6EGYomGrBAxBFDfP288ZY/HbVBBH3WUWdF27pvywHTPYw/OP83rx/Ok2lz0UtcTdZxuTmzZV8cVw7cD1ACjg2aAKNWQHDlScqXqQTw+SShiRLBt2HJyF8Tg8utPQ9WJhe6u/xouhqlJ/6dzrOB7l2tDp0gNH5DcbuV0m+qvMbKkwIkaIcOOh7r5CXN+EenTx9pUeWK5BGGuIntQE49EDmFxNYaCOKaujYJLb4jY7GiXIVIc8uNEheIg3i3Yb6L6YBQx5EdZm+xiMm21hR7N7YKP4AZK1xvPz6G8TaV89vtOXRA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8f7d7e0-ba31-43ed-0415-08ddeeea2094
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 15:12:29.4471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IKnem4iM9GSU+Fo+F1/ty4xZl9jDgVYPhE59ELnv7msKmYkZDz1bcNuWgIqXsNDpX9A26Ycs74hxqmYfW1sR6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6327
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_05,2025-09-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509080152
X-Proofpoint-GUID: CL3ONr_d-hyYpVYSphwz5crJQfG0jYWc
X-Authority-Analysis: v=2.4 cv=BvmdwZX5 c=1 sm=1 tr=0 ts=68bef262 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=GeWqdH6bTUks2XsLHo8A:9 cc=ntf
 awl=host:12069
X-Proofpoint-ORIG-GUID: CL3ONr_d-hyYpVYSphwz5crJQfG0jYWc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MCBTYWx0ZWRfX7LkKr8xcx/t5
 TasaoQrBIgWcJ8KCZhDindbhWAkgKbUNlr6FHtNj0jolOavzdj9CP/H5xqAQAhykghtFlA1b4QM
 v4He+qtS436YDT1UklNCES2GLBvoA/73gEF+t7wyUbvkcaQl8s/BR/1lk9seZ/AJkP/YwDI/NsO
 zYtR271J+xVHK0S392ACoLFL7/I0WMn4v4NChC2ENpDd5yehjLGw/YjNIcqB4Je/lLuDVGrza5u
 WdbnkDX3Aok2nOOjoGgVeNeL5YzLexWTMUCgJ3Jigm2/7+M3mg+CQI4RSgXMSP85VdIwfMSbIi8
 YEDVolQl7rVlSeb/8utk7EZXvZaY0Ik6b1mEgPmgEYlBsSg7h0QRq4ShqlxyxgJ+FvP0l46jH25
 NI4pQ12CoZw8sd6+rZW/xLpFAWnJOQ==

Currently it is possible to increase the queue depth of a sdev to
exceed shost->cmd_per_lun, as we only check against shost->can_queue in
sdev_store_queue_depth() and scsi_change_queue_depth() ->
scsi_device_max_queue_depth() [and shost->cmd_per_lun may not equal
shost->can_queue].

The value in shost->cmd_per_lun should be treated as a hard limit.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
Marked as RFC, as this does not seem to be completely the right thing to
do.

Checking fnic.c, it sets cmd_per_lun = 3 in the sht, but also changes
the sdev queue depth in fnic_sdev_init() ->
scsi_change_queue_depth(fnic_max_qdepth) to any value [fnic_max_qdepth
is not sanitized]. So, in this case, cmd_per_lun is meaningless when
fnic_max_depth modparam is set.

However, for be_main.c, it sets cmd_per_lun and does not configure the
sdev queue depth elsewhere. Since it also sets .change_queue_depth =
scsi_change_queue_depth, the sdev queue depth can be changed from sysfs
to a value larger than cmd_per_lun - this does not seem proper, since it
is it implied that the HW cannot support that. iscsi_tcp seems to be
another example of a driver which follows the pattern of be_main.c.

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index cc5d05dc395c4..b8cbc6cafa0cc 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -232,8 +232,11 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	}
 
 	/* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
-	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
-				   shost->can_queue);
+	if (!shost->cmd_per_lun)
+		shost->cmd_per_lun = shost->can_queue;
+	else
+		shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
+					   shost->can_queue);
 
 	error = scsi_init_sense_cache(shost);
 	if (error)
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 9a0f467264b35..26970a0ffe88c 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -204,7 +204,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
  */
 int scsi_device_max_queue_depth(struct scsi_device *sdev)
 {
-	return min_t(int, sdev->host->can_queue, 4096);
+	return min_t(int, sdev->host->cmd_per_lun, 4096);
 }
 
 /**
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 15ba493d21386..90c1321bfe22e 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1039,7 +1039,7 @@ sdev_store_queue_depth(struct device *dev, struct device_attribute *attr,
 
 	depth = simple_strtoul(buf, NULL, 0);
 
-	if (depth < 1 || depth > sdev->host->can_queue)
+	if (depth < 1 || depth > sdev->host->cmd_per_lun)
 		return -EINVAL;
 
 	retval = sht->change_queue_depth(sdev, depth);
-- 
2.43.5

