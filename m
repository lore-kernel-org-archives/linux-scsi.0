Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C45A22B8A9
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 13:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763041036; cv=fail; b=MNAOmI+7wj8YD8rbRgzAc7s05ukeQz836y5ntuJCwGkrEgYvuz/7pA48o7gjgacZ9ACWU5s3hOlqIt+kF3hi8CMBenaNS4xBNJ6nIqaEMI/vWtZCLShI7wU1p/gOmahmY1tDmUNhVhjI20YWICJyDoS35y9YwV803QAHGVVYhfI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763041036; c=relaxed/simple;
	bh=MCo6bWw7hehdE2teplEj3g4BVQAcT2lQBXfP69DVcUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sMFb4cNULYWJ37bctzgYhWcOz/ZxSiVXJnppx3DndehrFoDhAMDCkdXlzQfKfCpjr6L0LEql7ITk5MGTeHK7mXHWuPWPUUE5tmjHhhQ7arNLjr6LOyR6+EBs7/pm7NTQ3SbHCePJ9cZ8NJzqC+gYWcazItLm9ec6ssKl0/7GjMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I9oHgsON; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wn9DpTtc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I9oHgsON";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wn9DpTtc"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADCiOod004002;
	Thu, 13 Nov 2025 13:37:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yJbRUOPM3ZA64wOxSnNfAX75y/0ivz9K9mXqqY5rFkQ=; b=
	I9oHgsONTw2FQT8LM7SnFbGTacERAcT1n0iXSrkQBXrQ5pH29mpYzeS8zjK/GISu
	xXlNHK76Qm53eTPvTQL/82GNvFFDMUIfs03kHYKWhujHE+hDlLTRKdl01FalG/dz
	GkZGDssMyRFzXYsUvKZ1J3dmqebgslnf+9/89cYR0puPIdQDmmlfubmHgO7BwIDh
	nTXsAxlz8H65ELJmSsrxhwrFL22FXpzVaZZCN+/YarKfwVVtGA5M63hCiOf9G72w
	iFFnKulCgvweD4O95c2/EvfrifnFoAkp/FFXGiScvUNIY9PAFIOolfL9mDom60xG
	59XNVfVh5op+9ZN2SWMg4Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acxwq1t2w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:37:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADButWU010789;
	Thu, 13 Nov 2025 13:36:59 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012008.outbound.protection.outlook.com [52.101.48.8])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vanwac2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:36:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jbPyskh1/VtKMPTQmCurgjk90+wjJG7ImI9p1Bbhu+m2Z6dUK79XZYFYLfJ8ve2wXRzN5a1Q5JaqaAf5IpmQ7GY0UlfDtR73FXiuOXLfNqOgruVFwwRf402vyuNgE1dtWdoHSjd1ynq7Q7yZIT4Yjw/feo8x8Lc7PX6utxk3XOShdMsHjIimnhJylINY9ATy5bSvANiQm86hfke8nsrsAymmEOpdv2IrLhljdw0Cm8LjML+dKJxDedrNa5/ZznDbpm5uQlP70vkrZUTcKQJLv5YdsA49j0S+NK4kCE2BHx0Ng9hjqkqyCJlOYFk1gjEVJLJ0uetCYM4J3ygIbc/ViQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJbRUOPM3ZA64wOxSnNfAX75y/0ivz9K9mXqqY5rFkQ=;
 b=pz45kUdl3rVZEKxBpYfvf1Ku3tjoyAgTUtzi//C4uHPqJ1DKcm6JR63MNI1tX1fkdtwRMs8KogqnsRgppo2FTHoLfelxjBo1kGIGilw9C7vhMwpswiyNr/MUiCRX7VIB1umZn9IALuEgIH5fs46SaU1u6yhZxw1qCSjIo3nJakHOjNpCX/N0tRGa3bwPfyogVHyrJpczWLrDG5SUwA9i4ut/NFoyDlDGTLklz+Ep1EjuyGFSDKE8M7i8ciu0SIQyh/mqtKbHq/VTOpCM7zBTf2NffrCa88vDlAraMWSUzQATiU+9SA+i06jGXfV15Am87VXL7iie//M9j1EiuOMOpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJbRUOPM3ZA64wOxSnNfAX75y/0ivz9K9mXqqY5rFkQ=;
 b=wn9DpTtcBxRasNyqjq66yEviIz2/U3rLmQWQRnSfjZYcA7tBn8UykmncH68OnQFPWbXVCrxAY9pm4IgVBC3eDFfyv6SeQgmrKf5bMwAmQacsVCrwGdK+Se64kPxINte7Wma930hlWUck7mM+Y3nKUWB8V3clHhlqog9LoBmolJo=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by BLAPR10MB4948.namprd10.prod.outlook.com (2603:10b6:208:307::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 13:36:55 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.015; Thu, 13 Nov 2025
 13:36:55 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org, jiangjianjun3@huawei.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 1/6] scsi: scsi_debug: Stop printing extra function name in debug logs
Date: Thu, 13 Nov 2025 13:36:40 +0000
Message-ID: <20251113133645.2898748-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251113133645.2898748-1-john.g.garry@oracle.com>
References: <20251113133645.2898748-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P221CA0028.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:2d8::28) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|BLAPR10MB4948:EE_
X-MS-Office365-Filtering-Correlation-Id: c7d27b63-a766-47aa-ed92-08de22b9b5da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cYiZf1gUaNQrqLCvDLV5UD8P/5LK+fhJoXxnLs7jpFT3CkepHFFZnENyz+LW?=
 =?us-ascii?Q?1jEC6SRZo2e7kV41SlI9JIfbSROj4rF0gcnvRe1YOA8kojpwwU56p/vALiSy?=
 =?us-ascii?Q?gYZpx5zu1NgvdtNSWydX7pdV/sclU5Qq1gU4hUxxz82VzuPJog2cFvF7p6hD?=
 =?us-ascii?Q?6ev/YsUQ3veSqt1SkHiKI2fHknum3dvYNhIbMgJ7IllowvCauv84MT6/sG+W?=
 =?us-ascii?Q?kCVmCTDPMMGEdOkHf7VYlXo8yQUkazrrFMBDBQg+tspEv5+9CRpKd0OcqxTK?=
 =?us-ascii?Q?ohnowsW2wpVodn3H6F7poS3xN4wtuinGBWcfkFFK+OkpCiiGJlgrNtcZZOQb?=
 =?us-ascii?Q?FxyD0E86RrheRri2mr+7IQ6HVXVFYTb08MnZJ/N5P4sGZg+2oW7IpwLweEaD?=
 =?us-ascii?Q?nEdGBnT8xfvzLFbH7UkXRogm23IRMQgErgbzK8okzKva+cCVl/L+Y6QJzDiQ?=
 =?us-ascii?Q?2ei1ZM+YGEre7YrsxGCWEU4SbVSXzwzbrQ3BEMvh4JgkuORLyjleBSH5HaJy?=
 =?us-ascii?Q?9f5TCB82pu7+RtWcrezcVGe7m8iuNBZIxsDAm/+NC/flXy1ZM0LH5tdMQx+U?=
 =?us-ascii?Q?h4RmrfbsiDpxi4CTCiLr1z5lJnA9ehBfZlIPYE+LAVXLinDaHKrFlop0eQoC?=
 =?us-ascii?Q?Jph4rYG1cHU3LlAe948R/wHCuDgtxVTyW9NovIEK+E96zyoI/mxZr+mJ7zgd?=
 =?us-ascii?Q?EvEyjX7zFBw+t4tn8mxaHmKzWP11fDzH2Kc7atHA/j9ZGPa6PkRK3Plnf9+s?=
 =?us-ascii?Q?SLWNuY8gxBW3zY4XOeRmtwkcTYytnPy+vDXB3ORgZ+HR+BKwhHAwKYPm3g0E?=
 =?us-ascii?Q?f18ddSkxd8gIGmxpjED/aQSCX6BwiR7LcEs7gPbzv4rrDxdZ/JRotsIQ2BIA?=
 =?us-ascii?Q?rEFJgvU/nLj+r1yvv3pI+QMZmmtpvE3slgGFkKkdAUkoc5HwW6ig+uab4Ynw?=
 =?us-ascii?Q?MMNyWLCfouYFiQKuWUukL5qLM4ZkccvMXkTGZiSzKtLvTzWbpYdv1Z816DYk?=
 =?us-ascii?Q?oNh94Bok5VzjaNvYssbZGbD90NLQ8GP8SBB6rnltpIUIZ+2XImq7ZmC1HKKW?=
 =?us-ascii?Q?VwAIC1V2H5TySyR7gJv/wdozwfIGbykfb+C46jFurcc0qDrtlW4m9DxqJE7y?=
 =?us-ascii?Q?PrN3e8ICSM6H1CHgTjddlFALaGhY8QA2a/c160Ny10kZ/LOb6LeCs3sX0YX6?=
 =?us-ascii?Q?VCHv+GbFz9LKzLoUt+YzWl2HzNzV/1JGnRQg15+/G1/VYwN2v7z7gkPVptvg?=
 =?us-ascii?Q?0hn7pz7T3S3opNnvlx8O9fUcYHSO23V5V+lPI9e1U37EQtLLAUw9wR8wyqzY?=
 =?us-ascii?Q?mQbzhLAc4Mzbi+kvbnxKShDkZA+9Rk6KyFZ1mza9+LfYJcct2SFcOflPH/gf?=
 =?us-ascii?Q?dgzwbGLhC0DPwkzbaFm/dWiruSS/jG49V7JsEDSW9cyUWGa3cDerHpOsl81u?=
 =?us-ascii?Q?X3dmkYlCroFanncTJq1pkExXPkHTk8sc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CkK0b2JNUEHoP+VG9WImT4KOC+O0uvoQ83DH5E6CLBgx0fXJN+Br1xiNXRYi?=
 =?us-ascii?Q?KE0yAh0jfBjOm9nz3VtAbG5PMpogCImjLzjgBfbBrZn/IKPzaRrhOUiSFfRp?=
 =?us-ascii?Q?xJXiSGFA3eCfxGfqW4NZtxrfNCYYxN9J0Zt2AZ99fi4vWQ/xDQaChJ6oXFLS?=
 =?us-ascii?Q?j+aqqU831k2EdzZ/u1J6J78SFAQKkbO5dPBtEgbIo3ykubKq9K3KliOPmvEr?=
 =?us-ascii?Q?1wuY+cyEDYFekMyA02Utt224fubYTkmOX85bqi1DQU3stRioyGqyWkMi7sU+?=
 =?us-ascii?Q?KjhWSmuK1QttVRwdTQGqHAIizSVPuI8o6myXnmC6pLVRkQEQzzu2bN6PCn8d?=
 =?us-ascii?Q?GNPhtGs+FKL4jv2WW6rliy/5KN77DOE+g3pwUuxitUdPeMkQPqNfY8+140d2?=
 =?us-ascii?Q?jQFrmWTKlFhSBqVo6gBHTH8S1TajILbhU3zn9kh/K308b1vvC/HOfAytofPy?=
 =?us-ascii?Q?olAGGziCs7gF50vaL2MGXzK7mBJzcxUTH1XPavbL2kb19oLa8e99wBi+5oi0?=
 =?us-ascii?Q?qNfH9NiKX0K+WNSrIXdZzFUX2G8fmojB4vt2/hJZd/tkyMaqi+3keU97Xso6?=
 =?us-ascii?Q?GQ4st4I09DJJbgGtAob8JBkt9sKDkm9uqpWcYAWlw+dtBFQHyouS3nhzIhax?=
 =?us-ascii?Q?haROsg4WNn13lcNZutFRQrDGq9eg+EXnXshVbo/oSeA3OeVT6aVJDWX+Tnyk?=
 =?us-ascii?Q?xyKCB1ke9QdVr16HrgI+5+fiJWjp4ORG04+d9NXvMZ4qAy21NDfLPG95WVHy?=
 =?us-ascii?Q?XvE8ojPNcsRmVum1wq1WS3U+XLp2rjFX4dawGUHUDHV/DUv4YMQB+/KC+6dM?=
 =?us-ascii?Q?XCld7Ws6Srsjd9sxPgyDIvmnFtgc//LSZTJxfpPbS27PoQG//nowU6qGtlru?=
 =?us-ascii?Q?vvo6kDOuVlUELolpQlUqcc6FQ+ZBgHhmAAELPtrOBNbTNFl7AOaASNtDN1Pa?=
 =?us-ascii?Q?AJQ+rJarv2keQ8WFvkEWLztmtYXtrdqU8yLmGzZ1Cyg+s9F97giqidsbjaW/?=
 =?us-ascii?Q?HRMlyXxhZvnSE0cUsBWOdSGGUwOasF4Z1jYRh29mA5KeD/oESK0RIvX23nEW?=
 =?us-ascii?Q?pu3l2FLiyfhkZExxNYeouSzgP9sLGitjaXbOKhDSn97u4S5i8RlrJ8kesDG3?=
 =?us-ascii?Q?zPQTpj7QplCD4kLqQY2neMpYlIJtjVMtz5m1q/je/5py+1PMblUJZlvAdDlu?=
 =?us-ascii?Q?Bn1dmr/6ax2DvNQOGxYb8rt0berOciDJ/JROgGwkxvKMPv/GeRts+nAkUWPC?=
 =?us-ascii?Q?b7cbZCXr4pcUWbJfYU+Q83jdB++gETL0T9MepA2dDCCppzhMQU7mnOcdXIw6?=
 =?us-ascii?Q?C6Dcs2gjlhZwO8HFGCFs2aU31Ad3LSe54MZvzsRRt1rG7zCUSQeUAkXrb9qJ?=
 =?us-ascii?Q?uwip5Tk5fyeKeqS3empb6sP5XTbpfn4Uu9QveysIAOkCDXrXo7eMljFwE4LR?=
 =?us-ascii?Q?G4j+6Ys14VNCFm08YMJ17eGN09aYmD2Xgt2zfOVx3pG36M2Rmc1fe7CgWYK5?=
 =?us-ascii?Q?9syFZ2+i8h3V+caDaYtNcWrm2qzLGWvKpAtdbdBYSpq3G8d/L7SBIakbNWyp?=
 =?us-ascii?Q?TOe4u4JxiOd47dhnlpkW/zop+LIbeKXoknL4KwMiouyUmyx8bOgxOba53OTG?=
 =?us-ascii?Q?qA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OLxXAuJYfqp3AyOBDtEhW0YDej21XrF4bA+/UxIynQXncj9H8h+HcpfPTAIeo+NBIhfOlpswC4lihjk2Jx3q89AZP4eiifO2A5vxdaOYlju55IzB2Lh36UGavmDY53JF2Dib42iGozM6RlQFQ1D4AtNJey0ErMRARFLQnlbo6K2KUlJwQR/0bQVe3Ds65b6FM1c1v89pCGurAXdEXCm7Uqrqykm4GnxeTy2F7zXfqcBt7vdXUF0qadWdMYVdL/FA22YGwTZjAo9mtc+5CT5/JWXFpSXobIV5pG5p6tN8/513kh6rUq5emGfzftvEIHAuilc/0SpLVvetQjA2dlbgfQXu/T0th15ZsiWSXkqe9hFfYatIBQNnCB8i3XBPRZnDIzNXqjoINrwtSNWeoxHzFebHir1lNvs0XSk24U6+68netlEo4aWZNw8nXVgRG6a1tBWZws/Rid9V1cR0LSMopAkWxGjOEQDATlA2L9gA6am6q3wk1pbZio9VtLrBcLhOGdsRcr5A5ICh7jXmGGt0E0pVKUCosdq8wmF4lQSsk8WKufzt2cT0l2PEX6RSK0RFfitDDfPZUNKisZMe8B5/hTI1y0jpTjn/4rGJ0whA0zg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7d27b63-a766-47aa-ed92-08de22b9b5da
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 13:36:55.0178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WnTr2O4dgZ+FpuZZKYrdRqli6u3pKdw0Npmkceqn5yqHxHodV1jubBJX+DmI3VetT8AIO7YBQSvd6jeuz+lVEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4948
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_02,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0MSBTYWx0ZWRfXyPMs4Kk4wNzN
 c3xP9kZpvs9MGebY7emElmovLvag2fculjKjJlslEPiphkimUoM+/vZye4GJZRQplRP7K/gZ/Su
 oQWMmrztH2OEYX9+9lrunvvF9MJUgb27/B6cP8GrxPfty1EF2iHvO/0vaRkT+Me8dFOhMc52mKO
 XxuSs4kWJR+TkiiIyyPVf7NN3XFlGNqg0I9E6CuDVqfOxH9+oq9l0PwfXL/oHcMVFEFprFsSS2E
 wdfKXmH3UmODgV+oAEa9gE8ws5Tlc67VRWPdAyq/l0nvBx1QKT1gJKz+dbcZALaYpMYzA7DRBAZ
 3fIadwJ/TLnePIZ3kgPzIgPPZwaoGn3SBMZc4/qnaaExmiCXZS4/uMBXsfCSddxWA/mmenwUlqU
 mbxzzNgDmxFHrKdRg9lPcRcQ8poRhc5ANuC7YJzksp1bsXyeHpg=
X-Proofpoint-ORIG-GUID: -9Tra-ypHks5Lbce2ayhe0N7uYTPmMH7
X-Authority-Analysis: v=2.4 cv=RrjI7SmK c=1 sm=1 tr=0 ts=6915defc b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=zER9bWPFUo9ToK3aH-gA:9 cc=ntf awl=host:12100
X-Proofpoint-GUID: -9Tra-ypHks5Lbce2ayhe0N7uYTPmMH7

The driver defines as follows pr_fmt:
 #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__

...meaning that we already get the function name added in any debug
statements.

Remove using of __func__ in debug logs to avoid the duplication.

For instances of where the function name was being printed, add some
verbose comment to avoid using "" (which would be a bit silly).

It would be nicer to stop using pr_fmt(), but that would mean rewriting
approx 100 debug statements to have a sensible and clear message.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_debug.c | 101 +++++++++++++++++---------------------
 1 file changed, 45 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 92b2af803d87e..243a440feacce 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1369,8 +1369,7 @@ static void mk_sense_invalid_fld(struct scsi_cmnd *scp,
 
 	sbuff = scp->sense_buffer;
 	if (!sbuff) {
-		sdev_printk(KERN_ERR, scp->device,
-			    "%s: sense_buffer is NULL\n", __func__);
+		sdev_printk(KERN_ERR, scp->device, "sense_buffer is NULL\n");
 		return;
 	}
 	asc = c_d ? INVALID_FIELD_IN_CDB : INVALID_FIELD_IN_PARAM_LIST;
@@ -1402,8 +1401,7 @@ static void mk_sense_invalid_fld(struct scsi_cmnd *scp,
 static void mk_sense_buffer(struct scsi_cmnd *scp, int key, int asc, int asq)
 {
 	if (!scp->sense_buffer) {
-		sdev_printk(KERN_ERR, scp->device,
-			    "%s: sense_buffer is NULL\n", __func__);
+		sdev_printk(KERN_ERR, scp->device, "sense_buffer is NULL\n");
 		return;
 	}
 	memset(scp->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
@@ -1421,8 +1419,7 @@ static void mk_sense_info_tape(struct scsi_cmnd *scp, int key, int asc, int asq,
 			unsigned int information, unsigned char tape_flags)
 {
 	if (!scp->sense_buffer) {
-		sdev_printk(KERN_ERR, scp->device,
-			    "%s: sense_buffer is NULL\n", __func__);
+		sdev_printk(KERN_ERR, scp->device, "sense_buffer is NULL\n");
 		return;
 	}
 	memset(scp->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
@@ -1450,15 +1447,12 @@ static int scsi_debug_ioctl(struct scsi_device *dev, unsigned int cmd,
 {
 	if (sdebug_verbose) {
 		if (0x1261 == cmd)
-			sdev_printk(KERN_INFO, dev,
-				    "%s: BLKFLSBUF [0x1261]\n", __func__);
+			sdev_printk(KERN_INFO, dev, "BLKFLSBUF [0x1261]\n");
 		else if (0x5331 == cmd)
 			sdev_printk(KERN_INFO, dev,
-				    "%s: CDROM_GET_CAPABILITY [0x5331]\n",
-				    __func__);
+				    "CDROM_GET_CAPABILITY [0x5331]\n");
 		else
-			sdev_printk(KERN_INFO, dev, "%s: cmd=0x%x\n",
-				    __func__, cmd);
+			sdev_printk(KERN_INFO, dev, "cmd=0x%x\n", cmd);
 	}
 	return -EINVAL;
 	/* return -ENOTTY; // correct return but upsets fdisk */
@@ -1662,8 +1656,8 @@ static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
 
 	act_len = sg_pcopy_from_buffer(sdb->table.sgl, sdb->table.nents,
 				       arr, arr_len, skip);
-	pr_debug("%s: off_dst=%u, scsi_bufflen=%u, act_len=%u, resid=%d\n",
-		 __func__, off_dst, scsi_bufflen(scp), act_len,
+	pr_debug("off_dst=%u, scsi_bufflen=%u, act_len=%u, resid=%d\n",
+		 off_dst, scsi_bufflen(scp), act_len,
 		 scsi_get_resid(scp));
 	n = scsi_bufflen(scp) - (off_dst + act_len);
 	scsi_set_resid(scp, min_t(u32, scsi_get_resid(scp), n));
@@ -3186,8 +3180,8 @@ static int resp_mode_select(struct scsi_cmnd *scp,
 		return DID_ERROR << 16;
 	else if (sdebug_verbose && (res < param_len))
 		sdev_printk(KERN_INFO, scp->device,
-			    "%s: cdb indicated=%d, IO sent=%d bytes\n",
-			    __func__, param_len, res);
+			    "cdb indicated=%d, IO sent=%d bytes\n",
+			    param_len, res);
 	md_len = mselect6 ? (arr[0] + 1) : (get_unaligned_be16(arr + 0) + 2);
 	bd_len = mselect6 ? arr[3] : get_unaligned_be16(arr + 6);
 	off = (mselect6 ? 4 : 8);
@@ -5123,8 +5117,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	if (lbdof == 0) {
 		if (sdebug_verbose)
 			sdev_printk(KERN_INFO, scp->device,
-				"%s: %s: LB Data Offset field bad\n",
-				my_name, __func__);
+				"%s: LB Data Offset field bad\n", my_name);
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
 		return illegal_condition_result;
 	}
@@ -5132,8 +5125,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	if ((lrd_size + (num_lrd * lrd_size)) > lbdof_blen) {
 		if (sdebug_verbose)
 			sdev_printk(KERN_INFO, scp->device,
-				"%s: %s: LBA range descriptors don't fit\n",
-				my_name, __func__);
+				"%s: LBA range descriptors don't fit\n", my_name);
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
 		return illegal_condition_result;
 	}
@@ -5142,8 +5134,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		return SCSI_MLQUEUE_HOST_BUSY;
 	if (sdebug_verbose)
 		sdev_printk(KERN_INFO, scp->device,
-			"%s: %s: Fetch header+scatter_list, lbdof_blen=%u\n",
-			my_name, __func__, lbdof_blen);
+			"%s: Fetch header+scatter_list, lbdof_blen=%u\n",
+			my_name, lbdof_blen);
 	res = fetch_to_dev_buffer(scp, lrdp, lbdof_blen);
 	if (res == -1) {
 		ret = DID_ERROR << 16;
@@ -5160,8 +5152,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		num = get_unaligned_be32(up + 8);
 		if (sdebug_verbose)
 			sdev_printk(KERN_INFO, scp->device,
-				"%s: %s: k=%d  LBA=0x%llx num=%u  sg_off=%u\n",
-				my_name, __func__, k, lba, num, sg_off);
+				"%s: k=%d  LBA=0x%llx num=%u  sg_off=%u\n",
+				my_name, k, lba, num, sg_off);
 		if (num == 0)
 			continue;
 		ret = check_device_access_params(scp, lba, num, true);
@@ -5173,8 +5165,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		if ((cum_lb + num) > bt_len) {
 			if (sdebug_verbose)
 				sdev_printk(KERN_INFO, scp->device,
-				    "%s: %s: sum of blocks > data provided\n",
-				    my_name, __func__);
+				    "%s: sum of blocks > data provided\n",
+				    my_name);
 			mk_sense_buffer(scp, ILLEGAL_REQUEST, WRITE_ERROR_ASC,
 					0);
 			ret = illegal_condition_result;
@@ -5866,8 +5858,8 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		goto cleanup;
 	} else if (sdebug_verbose && (ret < (a_num * lb_size))) {
 		sdev_printk(KERN_INFO, scp->device,
-			    "%s: %s: cdb indicated=%u, IO sent=%d bytes\n",
-			    my_name, __func__, a_num * lb_size, ret);
+			    "%s: cdb indicated=%u, IO sent=%d bytes\n",
+			    my_name, a_num * lb_size, ret);
 	}
 	if (is_bytchk3) {
 		for (j = 1, off = lb_size; j < vnum; ++j, off += lb_size)
@@ -6675,14 +6667,14 @@ static int scsi_debug_sdev_configure(struct scsi_device *sdp,
 	devip->debugfs_entry = debugfs_create_dir(dev_name(&sdp->sdev_dev),
 				sdebug_debugfs_root);
 	if (IS_ERR_OR_NULL(devip->debugfs_entry))
-		pr_info("%s: failed to create debugfs directory for device %s\n",
-			__func__, dev_name(&sdp->sdev_gendev));
+		pr_info("failed to create debugfs directory for device %s\n",
+			dev_name(&sdp->sdev_gendev));
 
 	dentry = debugfs_create_file("error", 0600, devip->debugfs_entry, sdp,
 				&sdebug_error_fops);
 	if (IS_ERR_OR_NULL(dentry))
-		pr_info("%s: failed to create error file for device %s\n",
-			__func__, dev_name(&sdp->sdev_gendev));
+		pr_info("failed to create error file for device %s\n",
+			dev_name(&sdp->sdev_gendev));
 
 	return 0;
 }
@@ -6870,7 +6862,7 @@ static int scsi_debug_abort(struct scsi_cmnd *SCpnt)
 
 	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
 		sdev_printk(KERN_INFO, SCpnt->device,
-			    "%s: command%s found\n", __func__,
+			    "command%s found\n",
 			    aborted ? "" : " not");
 
 
@@ -6958,7 +6950,7 @@ static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
 	++num_dev_resets;
 
 	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
-		sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
+		sdev_printk(KERN_INFO, sdp, "doing device reset");
 
 	scsi_debug_stop_all_queued(sdp);
 	if (devip) {
@@ -6998,7 +6990,7 @@ static int scsi_debug_target_reset(struct scsi_cmnd *SCpnt)
 
 	++num_target_resets;
 	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
-		sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
+		sdev_printk(KERN_INFO, sdp, "doing target reset\n");
 
 	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
 		if (devip->target == sdp->id) {
@@ -7011,7 +7003,7 @@ static int scsi_debug_target_reset(struct scsi_cmnd *SCpnt)
 
 	if (SDEBUG_OPT_RESET_NOISE & sdebug_opts)
 		sdev_printk(KERN_INFO, sdp,
-			    "%s: %d device(s) found in target\n", __func__, k);
+			    "%d device(s) found in target\n", k);
 
 	if (sdebug_fail_target_reset(SCpnt)) {
 		scmd_printk(KERN_INFO, SCpnt, "fail target reset 0x%x\n",
@@ -7032,7 +7024,7 @@ static int scsi_debug_bus_reset(struct scsi_cmnd *SCpnt)
 	++num_bus_resets;
 
 	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
-		sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
+		sdev_printk(KERN_INFO, sdp, "doing bus reset\n");
 
 	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
 		set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
@@ -7043,7 +7035,7 @@ static int scsi_debug_bus_reset(struct scsi_cmnd *SCpnt)
 
 	if (SDEBUG_OPT_RESET_NOISE & sdebug_opts)
 		sdev_printk(KERN_INFO, sdp,
-			    "%s: %d device(s) found in host\n", __func__, k);
+			    "%d device(s) found in host\n", k);
 	return SUCCESS;
 }
 
@@ -7055,7 +7047,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
 
 	++num_host_resets;
 	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
-		sdev_printk(KERN_INFO, SCpnt->device, "%s\n", __func__);
+		sdev_printk(KERN_INFO, SCpnt->device, "doing host reset\n");
 	mutex_lock(&sdebug_host_list_mutex);
 	list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
 		list_for_each_entry(devip, &sdbg_host->dev_info_list,
@@ -7070,7 +7062,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
 	stop_all_queued();
 	if (SDEBUG_OPT_RESET_NOISE & sdebug_opts)
 		sdev_printk(KERN_INFO, SCpnt->device,
-			    "%s: %d device(s) found\n", __func__, k);
+			"%d device(s) found\n", k);
 	return SUCCESS;
 }
 
@@ -7221,8 +7213,8 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 			scsi_result = device_qfull_result;
 
 			if (unlikely(SDEBUG_OPT_Q_NOISE & sdebug_opts))
-				sdev_printk(KERN_INFO, sdp, "%s: num_in_q=%d +1, <inject> status: TASK SET FULL\n",
-					    __func__, num_in_q);
+				sdev_printk(KERN_INFO, sdp, "num_in_q=%d +1, <inject> status: TASK SET FULL\n",
+					    num_in_q);
 		}
 	}
 
@@ -7248,8 +7240,8 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	}
 
 	if (unlikely(sdebug_verbose && cmnd->result))
-		sdev_printk(KERN_INFO, sdp, "%s: non-zero result=0x%x\n",
-			    __func__, cmnd->result);
+		sdev_printk(KERN_INFO, sdp, "non-zero result=0x%x\n",
+			    cmnd->result);
 
 	if (delta_jiff > 0 || ndelay > 0) {
 		ktime_t kt;
@@ -8687,7 +8679,7 @@ static int __init scsi_debug_init(void)
 
 	sdebug_debugfs_root = debugfs_create_dir("scsi_debug", NULL);
 	if (IS_ERR_OR_NULL(sdebug_debugfs_root))
-		pr_info("%s: failed to create initial debugfs directory\n", __func__);
+		pr_info("failed to create initial debugfs directory\n");
 
 	for (k = 0; k < hosts_to_add; k++) {
 		if (want_store && k == 0) {
@@ -8803,7 +8795,7 @@ static int sdebug_add_store(void)
 	if (unlikely(res < 0)) {
 		xa_unlock_irqrestore(per_store_ap, iflags);
 		kfree(sip);
-		pr_warn("%s: xa_alloc() errno=%d\n", __func__, -res);
+		pr_warn("xa_alloc() errno=%d\n", -res);
 		return res;
 	}
 	sdeb_most_recent_idx = n_idx;
@@ -8860,7 +8852,7 @@ static int sdebug_add_store(void)
 	return (int)n_idx;
 err:
 	sdebug_erase_store((int)n_idx, sip);
-	pr_warn("%s: failed, errno=%d\n", __func__, -res);
+	pr_warn("failed, errno=%d\n", -res);
 	return res;
 }
 
@@ -8919,7 +8911,7 @@ static int sdebug_add_host_helper(int per_host_idx)
 		put_device(&sdbg_host->dev);
 	else
 		kfree(sdbg_host);
-	pr_warn("%s: failed, errno=%d\n", __func__, -error);
+	pr_warn("failed, errno=%d\n", -error);
 	return error;
 }
 
@@ -8987,7 +8979,7 @@ static int sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
 
 	if (qdepth > SDEBUG_CANQUEUE) {
 		qdepth = SDEBUG_CANQUEUE;
-		pr_warn("%s: requested qdepth [%d] exceeds canqueue [%d], trim\n", __func__,
+		pr_warn("requested qdepth [%d] exceeds canqueue [%d], trim\n",
 			qdepth, SDEBUG_CANQUEUE);
 	}
 	if (qdepth < 1)
@@ -8999,7 +8991,7 @@ static int sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
 	mutex_unlock(&sdebug_host_list_mutex);
 
 	if (SDEBUG_OPT_Q_NOISE & sdebug_opts)
-		sdev_printk(KERN_INFO, sdev, "%s: qdepth=%d\n", __func__, qdepth);
+		sdev_printk(KERN_INFO, sdev, "qdepth=%d\n", qdepth);
 
 	return sdev->queue_depth;
 }
@@ -9272,8 +9264,7 @@ static void scsi_debug_abort_cmd(struct Scsi_Host *shost, struct scsi_cmnd *scp)
 	bool res = false;
 
 	if (!to_be_aborted_scmd) {
-		pr_err("%s: command with tag %#x not found\n", __func__,
-		       unique_tag);
+		pr_err("command with tag %#x not found\n", unique_tag);
 		return;
 	}
 
@@ -9281,11 +9272,9 @@ static void scsi_debug_abort_cmd(struct Scsi_Host *shost, struct scsi_cmnd *scp)
 		res = scsi_debug_stop_cmnd(to_be_aborted_scmd);
 
 	if (res)
-		pr_info("%s: aborted command with tag %#x\n",
-			__func__, unique_tag);
+		pr_info("aborted command with tag %#x\n", unique_tag);
 	else
-		pr_err("%s: failed to abort command with tag %#x\n",
-		       __func__, unique_tag);
+		pr_err("failed to abort command with tag %#x\n", unique_tag);
 
 	set_host_byte(scp, res ? DID_OK : DID_ERROR);
 }
-- 
2.43.5

