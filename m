Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFE4304BBD
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 03:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768186963; cv=fail; b=d3FcXAXxkVMWxebZCR7vFtqrU6g8l+rslIXbnihoQIWn6b/kSpTMqy7OTkIWVM6ljBxsLhEdOf6kyjg5V/OZgTfqhvMmZ2WqP5u9pWKegA/hodcrL1jF5+KN4TY51ebsYD1cH8G10n/FysxGem18Us6IR51RTpa5AJTyItqwkWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768186963; c=relaxed/simple;
	bh=C2nn3wdxqSVPmo4lf93MrZZOyeHTx82aUw+YBUgk3TA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=o1NuqzmrTcSieX4EKpIzUcOsz23uS3RCoWJF5SA2nkiEHoRutSO+srowp+CdK5WfM2bDMlo6mp5gQRjd6rMVxvD3IZtpJCoQehqs2JnzfbiczK6hPwv+RivXhKKV07SBc7/XvEJfExn44LFwKNZDIbRwmv4/iv2VFQq9oImQUy8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TdA+Ew2b; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xoVGQqw6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TdA+Ew2b";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xoVGQqw6"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60C10k7g310019;
	Mon, 12 Jan 2026 03:02:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Xb5Hzl8Z+IGgavONFS
	W9cSCYDZw6DV1rzrLGZq3g0LA=; b=TdA+Ew2boUt6BaRiIWYTpCdzeIdkTAXNPV
	PdxR3X7Ubcncur2DZHXwGfQVZMu6A1BK3d4NsyH3IcqUpBkt9Z238skBCkpFSE6n
	/0V7RCfNiMWi4PvuYb2KK9mzCHUx6/MHaLAe4Pw759PMbfi3iL+d2iejBqZS/+de
	0XY9EgqyJb9KhHijqTKh5Q4ZnB8LnOZ4w8TVDMqTPF3VrEC2Qh2oA3HRIuyzwZBm
	IpApdASwVoE83O7ei2LZYeuov+1mWsc/IXA4arS05BXqq5xAhLvf3h1ZGjGGxqs0
	uzKSNiYOxPSWN28Zp2dM0Axxw2WnpQX/vZ/R8xVvG4v/wzr4s5vQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkpwggyv7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 03:02:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60BNk7CD001833;
	Mon, 12 Jan 2026 03:02:33 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011012.outbound.protection.outlook.com [40.93.194.12])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd76wa4e-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 03:02:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r0xRGJa874YTk1XjMDrRaBefe4Lap/zntOc7SF5FoEpD86PERgbYROyCJzeLqQpzFkM5yB15MsyGyx2T7crl+3uCPK7E0+bm/kfts3+Cq4tACc/HueOZTK3oxOY7QIR3bfW9bZGjU4vZhF81F1oz2kChu9rsKWnM0b/wzYmVCboNy3rWkeQakWjvWHrqIoVTi2m7mzQbdAaEjpVa93hrivF8Yz5IxSMUzj/D3GYKHD21dhhDXW6P3By3XLuC4OQYMTDYhx+LmHdrN1eO4SkK1fZYrI7z1ScPaKFL741LpSkiy7xmmRrUab3WKBIIVgMF5YhZqaQ/1jBsWUzernbSGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xb5Hzl8Z+IGgavONFSW9cSCYDZw6DV1rzrLGZq3g0LA=;
 b=HQD+dmuy/m8iHMiPZKrwDAN1/9HDmvEwIH25tXsQLPLYFtyJjgVXt+WPj85o0kKtlO/qzIQHs/N7o7LHcbaOSMP+/Zkaqas3kfIbBe+wnjoH+335XNvQySSVOFia1hDy3UQtG7GFAzMnUbclNEr88VA/tIkcI5TuDvz+JTdYh5jCOoxqgwZ9Eiv+Cd+nNUsyFkzgjhCKV4yNquRlBUCw3o1WjqWggm7DSWUiP0OUUZAXQFYnQdVoadlLPV1Xt7AP4hx0JSFPAUW2KZACvK2ctmC4PUJZElgNfr1oeL+HsITJ96h7ZlIsjq9s7GB3HQd2I3Zye2ed3sB5vLZC8A1nNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xb5Hzl8Z+IGgavONFSW9cSCYDZw6DV1rzrLGZq3g0LA=;
 b=xoVGQqw6Zkkcz4JyUM4XMnacZ2PIckY+HDQE+k0TY1Zv0/PGPgq7bSZlTyp0wHc6zc44CIgW/5uPK4UOlW+Bwd2hAlS5HcEMOCj8hh4aXIDXnRXnunGAjj+dGLq0uqROzCDRA6Jz32sPc6oFFFqsqiUtgxOJJPn8H8Cv2ICV/XQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN4PR10MB5558.namprd10.prod.outlook.com (2603:10b6:806:201::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 03:02:30 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 03:02:30 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Chandrakanth Patil
 <chandrakanth.patil@broadcom.com>,
        Sathya Prakash Veerichetty
 <sathya.prakash@broadcom.com>,
        Kashyap Desai
 <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: mpi3mr: Simplify the workqueue allocation code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260106185723.2526901-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Tue, 6 Jan 2026 11:57:22 -0700")
Organization: Oracle Corporation
Message-ID: <yq1y0m34jq2.fsf@ca-mkp.ca.oracle.com>
References: <20260106185723.2526901-1-bvanassche@acm.org>
Date: Sun, 11 Jan 2026 22:02:28 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0183.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::27) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN4PR10MB5558:EE_
X-MS-Office365-Filtering-Correlation-Id: b980f2f1-8079-4683-d3dc-08de5187069e
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?HvvbAVcC4cRYfUorr49gbDQVqUkMq/PTPHLQmi5SYwgy8b4UQxbckL07smZt?=
 =?us-ascii?Q?+dKRvo66VLBa4FghufFTHUDj+nwtuoWl6AZ4TFI6k1O2QUxLBxp/wleQibgv?=
 =?us-ascii?Q?lywJuHwonvyVS1EIDwxoo75UgiIRcW0x/ewqULlV4RkhqvT/SkyGV7eINQJY?=
 =?us-ascii?Q?olxhFVjmcgmUeP4HLf1uao6h1aI7ND4NG6z0mz8sDwgK9LOs7bC9q+hZyLCz?=
 =?us-ascii?Q?342512xFx/z8ZRYGX4bOWOU1MlsPCE0z/BFswD2GY/6AzjBFiK3/CC3sLJfy?=
 =?us-ascii?Q?QqF3G3vcZswfraMj2oppgI8KrGXPnOg0HxznISirkrokZsoe6RulQUBcyvGL?=
 =?us-ascii?Q?8ORpWAlra8rvFxNfq3px8BC2gF3MinMrUlNQmUqw99/E5Mt02F5VZCFyX25k?=
 =?us-ascii?Q?g8N+vBnBOVtmT8NG9+hQs48cXZI/MsgoEpIpIcw3sIeBTVAVfuctG3bTMzuI?=
 =?us-ascii?Q?dkMEWXjOrRZ/vDGhsmr8+bq3eONmyZni1U3i0y879lXY4lIasefdMzGaKwwn?=
 =?us-ascii?Q?+B9+KChjnLs4GMFZWaTfZGAeONSfcA3P4pqUqn2HYcoDgMFcnAXHk4UvfQS+?=
 =?us-ascii?Q?bNTh6MWyAWs63Awvf9/rodjsVFM3AaxtuE5IQr96KCvQ73O6LG5JUO7XEp9q?=
 =?us-ascii?Q?D0ZnE0iaj8GGchTt29mJXzbCHDk0E90plaUnqkP/oEW28yvCWxX7flVW1gSC?=
 =?us-ascii?Q?83IAzuv7vosY0DTvBZagNNmGLHIfO+P3DCZIwk14nNJ0ib5c60dAQDe8M1Mk?=
 =?us-ascii?Q?2qK92mlV7SC69nn8teXknur1mW3UEjmL1eMycmAj7QRNJwgbqbLVfrVvskHd?=
 =?us-ascii?Q?F0scbXyYi79hWpfslZTTNtZ6znrfXsPLmghHCxQBy3VnX3KM0yj4J3vm7Mjs?=
 =?us-ascii?Q?bd2ytOumFTC/xevwGQPSxuuJ0VYfcrOAfhYbe7T5HOeccsX629Wz5QiHnUbK?=
 =?us-ascii?Q?N6vXJFL3SeLa4Xb+Fr8Nnyf/osEHVaKgBzfA7+HofF/sMNAuzSZ4Qelp/EQI?=
 =?us-ascii?Q?nd4DXe/gNWGIqVyQ52pYcr1gub3WQ7tNdS8iBXK41dMSuPeVLgNKkW7H054T?=
 =?us-ascii?Q?72h2tAtJCh/XIzjQ50rio7bV2Zoa8mEDtKgsikrvlxI/fRqmZuhFpbdbbblv?=
 =?us-ascii?Q?y+r+ifCEp12Srm7HKGMVvMza4u66ymGkcfjrjpNaJSLZQmYhzP0/yUbxFoSD?=
 =?us-ascii?Q?UEwEDsuBKYIA9VJT5KCEQ091+PrZmnlQviiJDniF1yd1J9D+qEO1K2YZusdb?=
 =?us-ascii?Q?JcepQLAamL1u+Z/w+rWZ+xLRp/aRgt7rj+bVBXnSlbyoSazN/gk5LanK1fxe?=
 =?us-ascii?Q?1M+VhhxlgTgkdkJbFeheiW8vfK9dpu3MhIDR98puIWZY5OSgtcSFodtK1VUa?=
 =?us-ascii?Q?LtWkN1rG0ZCNCGQV6oXNUTmxoPe1QpPiYXyHYRV1xt13ILfG/GLY38yTq66Z?=
 =?us-ascii?Q?30nxNQNqcPpcOkWaeL6QmVS6eMBaX5i9?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?pR2eYV2fl0DQdjTH8LWgaBGvyxzQINf/SkXMtKDUm8J+CxcEzaC3cc+ECKNP?=
 =?us-ascii?Q?TKKGkTFzBtVg9GFDadYotzubsB1ibP6V1xuGBg+5H1TDAHQOdrQaxPzwZcf2?=
 =?us-ascii?Q?aDYCaaAfQKeGuxmnOflUGYocmOvhWXYpSfroFDwIjBRt0m8vUP9mYKDXrMdj?=
 =?us-ascii?Q?Ay4airXJi5k9ChedBd3TaMXmQTGy4cTIcMYTY/kQSs5MZ1vYRdXz1B8wf923?=
 =?us-ascii?Q?jMxbj++aprqohnpS+BkPMYOTlq4uCyL7deKASV0lfTsvb9/NMXWQjBoscKYj?=
 =?us-ascii?Q?bQCRfGkLeY9pjiRYIsf2xq9AQyNQPMa1CIi/46okF7gmly1a9SiJ3+M298Fv?=
 =?us-ascii?Q?0ZEyusWsnJzThcQIKim0tIdDRd313JHdSyra8ipJ9CFGDpo+OwFxBflcvPn3?=
 =?us-ascii?Q?sUnSaAhnjrWme/UgKTNYeF+PlZCuBsHv60wBEobOLhrYAQklLdWvnOm6zqFV?=
 =?us-ascii?Q?p6MvO35BbsM/jAV5AYtQ3xAparLNM/iLLPV7YOz7j3t1sL/mN5hFKaT9OUTn?=
 =?us-ascii?Q?TmxLZatJ7QqshWPDTQWYL4TgkuaV0mbYUcC8SJFM/iEdhDNbKL+H9Kev+Ctw?=
 =?us-ascii?Q?GU96IwwnisUPA9ZsRW+EOdaSDybp9mOSl8cZAmNboM7mfNpBqsl3g2igtcZa?=
 =?us-ascii?Q?98JHBNaXwHBWMEK59cvAiSLTJ+o2XpXE/Xnn8QPsnJLf4UzD4bkmv+Ulkfmn?=
 =?us-ascii?Q?/BbCQcaCWqrd7ZxxyeLqqjgxMPpL+0q6ZQYS/ERsOhB2oXKWkDWHo6/bypq9?=
 =?us-ascii?Q?5rAfvJ89dS3KRgV57F6zPRHImc5gixwBuKksypotF+5Ii80oH8F0d4df7LWA?=
 =?us-ascii?Q?KCKPfdi67PJPdeAxzLYjuqCsotAuBIiGLK7pLqAjpr864tnhIpP0RwDdkDPv?=
 =?us-ascii?Q?kVqXTFtyoJclf8W5q84hnSYIftZPWrCeyw9G8rjY0WSn3DQwZPRx+kwzWNub?=
 =?us-ascii?Q?bm5kAFWql5v8AyPo0HND75JWjpDj7gU0a/PJh9sDdxPdmc4AWimXGFfnzjad?=
 =?us-ascii?Q?xp1URSe+5RBe17TudZQ5dmHwFiJTa1c/RruCE8H6i6pqbGWT1NDq6YLury0c?=
 =?us-ascii?Q?QpFNceJH9BTtMJF2qwIuHpilfIbGnXDx85PaPclXsaaEPyiFoUzGHwmyvmu4?=
 =?us-ascii?Q?5RwTIF8B/LmNcFpFbTbN2aWrWyoeLct7mMUA1/LStp1DEQy/RnasJ6XxBWr3?=
 =?us-ascii?Q?g0om4y4Q1CSxwpTprieIoI///Ej1urPlaxyctA9WY9hCXFHrxZYoc0L0Q0KN?=
 =?us-ascii?Q?iCNXh+Thm2qzwTAU+ckcLdw31eYQFGer+IRH30c2m9hjAA36qZebQ9aiMLT+?=
 =?us-ascii?Q?SbKYm687eS+e6WnpVj3nynj63iIbaYgZPRhErS8tkGsiN+Ip/5I1P1sdDBHs?=
 =?us-ascii?Q?w2AIpCSN/0NHxCs72RkPVjz9biRCr1+PyJEericwBdn8V+pfOudoUtBQ1+Gk?=
 =?us-ascii?Q?cY8hW+0sSeNN3hMcgLMTDM4XzHpBf8kYVgVrDQOnCeheBMzfKrpGmgJIs1rx?=
 =?us-ascii?Q?fLDXlliAJyF7jNJdcrom7zMXT7iaVrF+tSrw7SDBndXYlQdyeOZn9FLSjbfn?=
 =?us-ascii?Q?Y/4YhD2rzHkVFAXdqvpX+q7jARv9iiPOsHiTHFz0wq3ppOTHwrLpkK2RI3FA?=
 =?us-ascii?Q?o5vXItaPXJjvZH3lqUe5mSsz9HFtbnl1EFHxO82kfLDQsKWkB4YutT9n9vsD?=
 =?us-ascii?Q?bMgX9hmaw2q11z0KoefNDNF3PoAp2og5ADtjTFK7Ii0vRasxaoRaMzkEB4fe?=
 =?us-ascii?Q?O5W9+nBxdpI5zvnlDKjbpS1mIQ4mcCA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aU8VZs0swkC11rvu13vK8yooPEtlURyIY9s0L/Y0ly2NZaj2jYhpma8eOrM5Le9nVkKY3hjU+TPD85XWgdu7mz+3NQyRCIoa2JN96G/vzFpnpAoZSF2numA0z7nLI27g5eMcy+yKUiXx0PMJg5YCk2Pty0ySdlRfT9LPeW48DPnPDTpDJn186ZWjJSUTCnOX6oYE4Rbzjy9dGG++zJHBzJn8gcPf8jb/PbMX1M1c7GUZbN1KIxtJMO+XzSOSeZs5LjsDGKAtYbSPXLz/ZRlIXHBOhQIz1WrUszJdP7Ck/9UoJEA3o5P1IU7+XkyvUImly9ZInHpd9QSi2gq7r9fg+vkQv3fAnKyqkHZy38xbyTThzpNhY6O1qtrtAKo/HAf/85F3hrx6v8lm5V0VXkOZ+eqBAqHDuXg1rjzmoKCaVAzHB6YLr+UXEAxOGsSE99zjyPMYZuzEMDmfY4CjZS4Pbaot3gyRXYl4Iv882rFF+oDS3UAALa36lzwdi2DKkPCyenfUtR1g38H91vGIc6y4ViHQ466z2WAx+DTUOQJNDFxaEya5Bz+HKLu1j9KMQh+8yVimOgJ8ZkCFzZ7ay2+/iACaggIN4RZ6qYUZj7VcMb0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b980f2f1-8079-4683-d3dc-08de5187069e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 03:02:30.7797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jPXX+VLH0UswppFYpq+WYVfYANRnyQ7ZIwQIyU61add2drLjO7yaYTzj6hkl76ge7euq5TBT11l0eNwYeIrBEJRmPxl88WRwMU8CoFSlUaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5558
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-11_09,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=914 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601120024
X-Proofpoint-GUID: yJUFEsthjCYl654gT9WBv3BOcCnpnnr7
X-Proofpoint-ORIG-GUID: yJUFEsthjCYl654gT9WBv3BOcCnpnnr7
X-Authority-Analysis: v=2.4 cv=ZtLg6t7G c=1 sm=1 tr=0 ts=6964644a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=4UmxapGgOvRovlyjj6YA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDAyNCBTYWx0ZWRfX+JhxauaZ00+Q
 3A9qjwUOUkf1rfdd7biSAVQWbp3QfitaqlpNfeh1T0vHcD7kk/DAhmKO8p4Clnmjh1VULY7h6Vk
 G8hk35GMcKNlJf8zWR/5iYNa/Eb8Ues+QXWV5F7+T4mqTFOkIqV913igdHf2MwvtxkV2ohxgyeo
 Y/33GBG46uakZakt28Jsq3bCX1wIIjemq0teVVVz4gN5uEJJSkA4tv771W1Zav86fpB5cLHrEjQ
 uEaQZyfbHqbKx8D29R7qzeIS4LUPyvfThqszc7mp4OmtLlJKd5m38i07M+P8s5K7gKr+lBNe2Ok
 TwuXlSS5WGfYrT/BYvPA/uyFl7iuA3NQpVxYaU3VPYGGEzsngVgyjYZI/oWntlDl2Q2VHgngADr
 aLdN+nPQonXl0t6pHYk1zS0gSMjH/UFMEI+VF2LT55Yn5oEdtfNXpJJKKOBaisF8GbR73xtCjFT
 DO+eDu9TvDc4FIaqknw==


Bart,

> Let alloc_ordered_workqueue() format the workqueue name instead of
> calling scnprintf() explicitly. Compile-tested only.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
