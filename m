Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5542DD5EF
	for <linux-scsi@vger.kernel.org>; Wed,  4 Feb 2026 03:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770174544; cv=fail; b=slQIadNVsNamy6J0DFXrGvG5Hz/mSy15+qHy5aELjCf10KCGCejIYq/WxDA51cEVR9lbcYf5dqhjqYqjGoBlbRf28vk1PIKAeVJVEz7QfEjdlvX09gIFnYu5jfzhYcrWT6CCVFyxyXAXoPn0bLIy/g6/zOasjcdzw4+Fa+tgcZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770174544; c=relaxed/simple;
	bh=7IiVYKTFd+8yRb/7J80QvIYt/+k29cJIMydW6YpDb/0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=HkM0eCdSgHgZTOkxht9qCyRXkS9r0tQ5KXq59T1Zr5HuowG9XPT2lRujeLZ8YaACbzePsX8wACBcPVCkNs22Pq3Il74/OCwpk+0HTTJ8C7gGDqFE6PUnNw3Nl/LkzK4KYf9rstqLqrrjv67KY9osfd584/JLeFAhPWx7O4WiHAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qwAVLAYM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aiuMDc3s; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qwAVLAYM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aiuMDc3s"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 613IuDFM467997;
	Wed, 4 Feb 2026 03:08:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wllrCtH4XGLRMZqrcw
	ustGMUKkVnAoLz7Ff9fekMfyU=; b=qwAVLAYMOv13/1Z14dLJZNcWrv/li2019Z
	kuuU3UfCG8bWWCj9zuXl9VUyWz+yxf5RK1Q6xayhpZddh6avPcIKmNMIOU74qiXU
	HUr6vNX2GTLD1KAIkcGBPd4FV8szazRHFO9U1j8/WbuBtdumT0qzRGRq+P0ngU2F
	rpKnX6CWMTwEa3DpqprjLh7MDXPs95zTHNCf3Sr0c2flkTBNawSYZ7Tv1cehATLr
	S8H6qpWlZgjjSTVFTPGoqZfjKhWUuovHYndJM6YnI3gXIKGS9v6w7VFw3Jj5zF7u
	DTmFUbdNHMZ87lrRFV4QuawbMgCjmmjwZFdR1kTw83vV0DXSoxpQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jm4s419-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:08:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61410CFp018651;
	Wed, 4 Feb 2026 03:08:47 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013064.outbound.protection.outlook.com [40.93.196.64])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186nbujx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:08:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ErT2h7rc5tjf/pYgIIZ2+cGGNpXbikuXxrhAf+MviWJUOIsvIx9VYzdNQxYB78Rt6HcjBCFr7IOVn5y9yAofEaJ7lTOKG3VrU+eBp+6Eo8jWZ2NIlmy81Bl1hQyuCS0VKDlsGAzc+RxzcY45gCW1Kn3eFJQkY8LzXB201UlFDYi36RsONaf8XvhUnnDi6j42ppWQ8kQxoMzYCh3pCUqdKTvrIXKW96gudF5p7Xt0oiuMZiiQm550o7w3wpauPtdPU8t4/xnm3r74tyZD813qOvZdkRIzpIeJIaARwXM9zeJAlVkkNx9GzdW/X6gt4kLlyEVPCzLNd+3rc3TCjUdtAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wllrCtH4XGLRMZqrcwustGMUKkVnAoLz7Ff9fekMfyU=;
 b=sdhisZPSumSJKu3c3TDO9CRAi/iz2Yy3aDLoon0wEPoQ3KMAttlIOdl0oz0m+nxgZFhuLTRWocmhBCiMnjfA/P6/yOnkN5tfuK2wanS9dywNy+x9HqAGkC0+pACIS0Aw0yWPOuUEiSFDAdCRWZDdnpHGiwZymviNKBTIvItLErG+M3pUPPYbf+v5c66SsjtNlwr0pgWPUhBZNZb5bJ39jW2vGWKZPBzENiA2TgDnqlpHoufqI/FDEakiUc89P0yE5baErPCuHGWG1sO0cHGTFeQV3N2VLbgUV2LH0rjjEZrX7vDGe95v7vz2vDbaCHuwHqmQh4R5UknDIc6+Pg2x0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wllrCtH4XGLRMZqrcwustGMUKkVnAoLz7Ff9fekMfyU=;
 b=aiuMDc3s4/wcJWNjmVYMS3zHWkIztBZ9nWQzcF/YYvo3K7f4zmw8AlqC4YONb3m0q6u/tqtQnC0AXurFcL4ZZRvtyrsqBG1KIGIrXQnXZFVf78T/3kgHpiGqjl1MY8zcApXmO25FDNj5VTsoLPipbijZNJ8Ue7iZSUfT+6MTIyw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7139.namprd10.prod.outlook.com (2603:10b6:610:127::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Wed, 4 Feb
 2026 03:08:44 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9564.016; Wed, 4 Feb 2026
 03:08:44 +0000
To: Ewan Milne <emilne@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Doug Gilbert
 <dgilbert@interlog.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        James Bottomley
 <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: sg: Add warning message in source code about
 non-idempotent SG_IO
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <CAGtn9rk2TFYEdRh8q7LCZNiCcotU-f+xZLv=N_XbZtzcWgx+9Q@mail.gmail.com>
	(Ewan Milne's message of "Wed, 28 Jan 2026 10:36:30 -0500")
Organization: Oracle Corporation
Message-ID: <yq11pj1p5pc.fsf@ca-mkp.ca.oracle.com>
References: <20260127180427.471487-1-emilne@redhat.com>
	<aXmyqfCzBBeV8Jj2@infradead.org>
	<CAGtn9rk2TFYEdRh8q7LCZNiCcotU-f+xZLv=N_XbZtzcWgx+9Q@mail.gmail.com>
Date: Tue, 03 Feb 2026 22:08:43 -0500
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0016.namprd07.prod.outlook.com
 (2603:10b6:610:20::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7139:EE_
X-MS-Office365-Filtering-Correlation-Id: 02955052-76fa-4384-0d23-08de639ab4f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BUulRPI6PqAVXb9HiGOd+VCDquvr9ZYw9fWrzrNdx3b5ViSlaXBAIWOLlVC4?=
 =?us-ascii?Q?L+JoT+RK0xlTTAE0YOJAZ/6LgwPBaLrvZb4Wj3IZ1lizZPjQDLIRGOpeh/hI?=
 =?us-ascii?Q?rytkd/ZNwPzDXyT+QYolZBzKGYeFnEvfkFBsnCLHkVW/oqB6Y9qxxHYnEpLU?=
 =?us-ascii?Q?w75exTXGW64ipYrxTkq6K1LGW3+JdRoq31DcNAxJg56mY8XmyFUqK0GcxvQ6?=
 =?us-ascii?Q?CsMbKJPs6ppArIm8FChHwzgTs++xuamDQmq+dREjnUvsaKz3L7HE5IIhZu4q?=
 =?us-ascii?Q?Qpy1meKxrrlAWeYAr2n54dTtCjhhpCQjLu7UeLUfotF/iKlIWU+UBL2PwtQh?=
 =?us-ascii?Q?kjj+7HVnM+Dpi/M2O7Kav8+1etfp/lu0EOWuWEJ0AgL35jPnhiJ0+fd1z1Yj?=
 =?us-ascii?Q?YtgrEeScmfJ2gXiRiodNZKuKXEwWgeS9nH/qgwctKG8TmB6ujEebvwc9qJey?=
 =?us-ascii?Q?9jP9p4qFY9dpFRlyVGn/FYKiiQKKCeEre4bi3n1reaHhjhzqfClTOFNVoeW7?=
 =?us-ascii?Q?uDzK/eL50MkhYetrD91SkC+iMrZEmNExIdZ00TudVhbmCbIR+1/dtTl20vUv?=
 =?us-ascii?Q?tvMWan2OYberw/JCX0em2kWxrf4arG2bElvhzMfti+uMR3l3hNEZSsFW+Zsd?=
 =?us-ascii?Q?R2CxvIlDujO1WpwqG7oF+6IOcq1Km8/WDpyT6DXrwpmQS03ufI9RBDb2ptic?=
 =?us-ascii?Q?1Lap1FsJ3xicNq4r75u9wE4i0WxKdkvNca37Y6BROuYhRbjeLZqEN/okNoJS?=
 =?us-ascii?Q?az+H4udKJAyUzorGZFE88kjCwz+d/yKD35wHshBzVXxNjKT06QjVbdrYXYPr?=
 =?us-ascii?Q?vm5BTl04T+H9cpjDPY16U8+a0stm2sWMP7CMbNDHxGHaxPl7DK0RB53q2jLK?=
 =?us-ascii?Q?WZNvADA2bUxbFxwLOI0RpIs6UoLN3aGObzYytWdyx2uOeUZixuM5N45892vf?=
 =?us-ascii?Q?YFVbljggmIELm1mxIiX/hFB0G8T1+HQNYqwborY0MMfuE873lWSxvM+DMnVK?=
 =?us-ascii?Q?/q+IMqgRns+G1Zjwyg651uJ/iHFR9yHCU7Ohhi/XSv0YfMqJ0hoC5bBQEhSt?=
 =?us-ascii?Q?SEeEhcBeQk+ILq0iL5dpdEmvcRyVd6Br25CetfZx31JWqot0XBe35aYmcGHw?=
 =?us-ascii?Q?NzImUWWtQpr7sT4o7ttW87wzY534EUmiTv22LyyCDyRFBDJYR3e7DAE0bUoP?=
 =?us-ascii?Q?Y7NAkp6s8iQd3safITinBTAtQ8RS62MtjCIhnqVwFtjhhIFRaz8UNezNBSqZ?=
 =?us-ascii?Q?rAyjORPd3FlQFa7NjcnLMh49a3OS7jnZQa1zwPw2WOflEacnIYAIzuUQhYfu?=
 =?us-ascii?Q?rAxQSGI8m80UXpvIXrIdIvY4s7GXjMmahdt8+1wkCbWfVF9IiU3ip24aefaE?=
 =?us-ascii?Q?Fn8ja5Klmmlomdb8cIE3BpDySkXE654aQOD6lYmQTmCjkU5V5hEduWxrH70b?=
 =?us-ascii?Q?ojhw3GIOGERsOpqkB7/N8x2Gd8anS9pqxv6B8EDjeBzritYDV4fvLinKK5IG?=
 =?us-ascii?Q?gRbcpoqmrS1uENZFMt0fMtu5jvXKlh1oHwUO67kCxIfnx5xYIs0fFeVMBArm?=
 =?us-ascii?Q?ndIoHHH/NbRF/j9QaCA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fjUK28lSms4JrgN/gGix3ma6QC2MbiiUENIvjCMm3s/qHbrG6K7fxKkDiGvD?=
 =?us-ascii?Q?3DG8wws3/d0ngyNNUq75Sw6ThrOcf5Po25AJODmiGf+H2i5ovVLsFnP9kXLX?=
 =?us-ascii?Q?dTT9oEZslMG0jLrieDAV7OVfWJzKiV6DSRBzdyHyJgx9FDJMopq1+WzXsa0A?=
 =?us-ascii?Q?uXk5swnmvHKDc9YUChZGta2To2fMjkm/neVex+/Q9+LbkWE1stcTwWujrCj3?=
 =?us-ascii?Q?a3QyZhA66dinZqo7K97ZOP/erwXNrkub0MJrJD/WsgNMiul50Kz/FilO9CBf?=
 =?us-ascii?Q?6YaqxzektKdv6bd+nfuYor3cDkEofnntxrg0/tVDOHAT1ic8psNFRPZ7vbar?=
 =?us-ascii?Q?cVUc3rf6eCubV21+/E0usXDZ0W+hBAOKDfOYU9sI7BoDqnuXgC/NjR4X2ncZ?=
 =?us-ascii?Q?yFbFN7lI5pEt4xRKP6gkg3v6yHFGYFi5KiVVn+rlZdz4rEZTKzBJ6ikUdylE?=
 =?us-ascii?Q?5Qqry/Bx+9x0bcXBrnClG2SDddgMaShn43Ig16jelqxvm6mpbI6MIqp6Kc4V?=
 =?us-ascii?Q?5axM2B0K5etRf8phHFtGFPHCqXgAMhXmYTu1qqx+dVY5YauSXY4xx49rR/Ho?=
 =?us-ascii?Q?VeWwX5/Kqw/gsOfkIizZx3FAYKsgi4QLZmVDVKlKr9k/ioAPt9otzJvVi8dp?=
 =?us-ascii?Q?iaWfQuq5x0bALE4gvUvbKEMqGDQPg5xH7vbMyoSHGCSUqPDPZLIurJjm1Gef?=
 =?us-ascii?Q?vsj3J69Uu5PMF5mBkCmCqdQMQPiHJIwqByp4MIMXTF0QPbSQtJKlbxrFP1Ht?=
 =?us-ascii?Q?qmLenkYcRvYqHkb7Ckb2M7pVfD85H/enU/lDosb8feeozP6KIKjQGbiCD9Tw?=
 =?us-ascii?Q?CkDfT3rKvFG9lZp4UH5YeveV1XL7zUyIyDzhXs1jHlgVFO5lZ+Tv/H010kzz?=
 =?us-ascii?Q?fbMH8+fwbmPJlm/qGbLBLX5bZaKPQPj22IwL06edyBN7hmjuNL3BLpG5/arO?=
 =?us-ascii?Q?r6Jcc4sTvcMA03GmvRNauiQfjgcki+CUhYh0wGJQy9IjvclYP1gQeMa5c42e?=
 =?us-ascii?Q?e+E7BCKPB7jGhZbxNd7ejiCwjhe8Cl+78hhdF4y7/XPx1gCK4J4pxFM/EiZV?=
 =?us-ascii?Q?sqd/pyOalYg7acsBwGjj6To71vJi1n7yU5BShBQuprw6e/StWmjJ+9ZgXUSM?=
 =?us-ascii?Q?9KU5+sJ0f+Jpd1TxEOgBdeXSCwjgGWv+RrqlKeNkrKuUvmj++Fr28ApzZffT?=
 =?us-ascii?Q?NfPxgzBsQ14SMJohnk0t+AC3CWh6qbkLZ8ySG6b4qRQYvHky89Jq+E9AgwPV?=
 =?us-ascii?Q?hXStpM00a6rYgylgEADtVPuVqPXOc0ArNpjoBuWoIsRnXg9deUQMjg7B9Czy?=
 =?us-ascii?Q?2GyR0HvmC8tRj8mG6s2HEb4q6MnNh1ybruVJDC1BPLPoY2IcntzxWIo0I+PC?=
 =?us-ascii?Q?5WYqiqipwJsEwO3jxJhmbMOSiygGxNkIPkEGyvNXRCfX/ge/+lbmW6QW8kcR?=
 =?us-ascii?Q?SW+g/asC4rvHLcas7e3IRtaFBGX3IjTO8O8tclFv7IeWTopZAPH/t1RKeV5c?=
 =?us-ascii?Q?8hbejx/hO+pqgP+OelHjCmzXkh1y5MQNSlA02Zxn59mIOqtqFRBnX6+ZkGsL?=
 =?us-ascii?Q?fjCz5k1+4GOrQCJzHIR6ms+HMfbHPYidw12BY6WcggHMtd5VK54KSHoOPUVW?=
 =?us-ascii?Q?owmvuo5BxwYlvVeVHQjFMTK4Fqb8B6z/33lbxvTXIh81rHLzCxrACIxjONxo?=
 =?us-ascii?Q?0LOpaa/RaAgocAWnaGEIrbnCsvPuPYUptCcO5ydp/PVYnlyU7+xfvkY7QqJO?=
 =?us-ascii?Q?rtYeJcVBu9nabxlxrK4T3IXNmTfePjs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QQP6gCadp5i2OZLIQn5kAhva2soZ8fYA6GjJ3gSwJ35K1C4FO+xZrW+apV7cbuIP/R3N1wdLhkcUFjqQ9UM4FDtybmNR9wvACGApEzEzJuWXeg1GhptAYHKbSKh2cfSkW0ojjVBbtIJNxH/X+jup0u65GJ8ajWju2LSpZXYrBPdTk9aXIsO+Zym7wz4SXj7tzuAie6Rm4Yd6y68rpdZizm3AW+lIBkme2I787zuqrxDOjOKofUZ+p8lflo0x7y3Ll3L5WA316JxOUNJBPwYwai4EpTNN6HIecDM+yVjvAqEAZWE9/75HcxFaTHwgL9NuRJZJ5K6CUchhaEqrj+vBGrmP5cqX8DdEye3sREqEaZwu7KUo1ajwL96e6MG2SWCNahqZmvr8cguUCfKJIalNsbkfgY4cAUI3SLgeUEzvPylsqB4wo3PVAu4mweJFgijwmrIdM6sE4CnpzomqwGvwxkkdXsqz7EUfTM2jNceiPt6OX30m/B+pvZxXq7F/xeybKlCO6N8HscMWA5u0FipYYbkG3Pxg6vMJ7h0oQnq8sb2jd7Bz2W7N4t2Ff+nZsgrRTwSvDTy7gAH8UxgzZBR7zzDzQqTiJ3KVu7mX3MLsryM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02955052-76fa-4384-0d23-08de639ab4f7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 03:08:44.6344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ya8HIudHu82ef+xM1m6lY3L91f8wk8KCYtnhmCbLz3zrUArNjSRVJuANDaM38KXeicPJj+757OWgLOo8P6m5BpVsSA6q8DQTJtXHAiWfwe0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_07,2026-02-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=692 adultscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602040019
X-Authority-Analysis: v=2.4 cv=OuJCCi/t c=1 sm=1 tr=0 ts=6982b840 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=HCWMuhJGKrNBK54Z:21 a=xqWC_Br6kY4A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Qtfbb487KZeGFM_DvkoA:9 cc=ntf awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDAxOSBTYWx0ZWRfXxSgHRcYns3xd
 +PjbimMjWPPxckocqG8SB1RQIXRJzmx8gge5RChqOhynH3UOJBPp46YALgb0Hnk7g6NDUQ9TX/x
 /CRGQ6ECWL3ZtA/BuMInYOjt30fO7ZrVeVnMoXMX2vKwe8Xsr6gDWCNyhRJMlze9B4KiSK/dQfP
 e/qCthlqV1N01JAQUk84ysrs1auQOnI+NCPspwVacEOFzWU0f4KVVjC26uyBlZAVhvxjY90M1Zt
 MZvSA3q3MlxYzkI73xMy6iBavgYZ7ayJKUQxnSRrG9p6Vwz76Ctkc4eCjB35OrVaiVxEKX+P/Aq
 B77cm1AtT8Ed9aF4CAhcwrA5mMfBgrFhRuPl6Cz5X+X8oZojf+kMxaArRhjtZZ2uiH+0oUipeDQ
 qobnnWVTsb3eXR0SA5prQsIDLAJzeZXOg6LQQdakNFgv6pkvkOj05CbmilU61EPKD8Fd2QFn9Li
 WTQzAtvfzJt71fFIFi546TKEP4NTsWXaNQLrbcz0=
X-Proofpoint-GUID: NlHFh18RV4bPA0uvIB3MdAqTcHuHVQeu
X-Proofpoint-ORIG-GUID: NlHFh18RV4bPA0uvIB3MdAqTcHuHVQeu


Ewan,

>> Maybe we need a proper man page for this ioctl or some other kind of
>> official user facing documentation?

A man page would be appreciated.

-- 
Martin K. Petersen
