Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41E52A1CA
	for <linux-scsi@vger.kernel.org>; Tue, 13 May 2025 02:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747103560; cv=fail; b=EegApgblGT8TPePTTfN14CwvOf9LY20c09zuCzTY/6ROamgnF6j5Wn34FOY3tky2cE8X30+37nU88rJGZC9qJHHTZl5VK6vrmt6FhwJ1N3HMhJErpcCFuF6eP4HmaT3p2edh1f9klsSQT5dXfuaZHVDsGecW2tIEtdc6/giB4Io=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747103560; c=relaxed/simple;
	bh=Bx+b0mqy+nOYhC1Vt4lyONVrXCu2C2dbiOdDo2Cu720=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=GCtL2mfHzSvDH78XmJVdSNYKPXD8hptoRK64eZny0WHiwWo0HyAqI28e2TD4XjPpS3zQ+wZhZPwGPKqDN8404ysZVVIHQzg7oeWJA+3mS08r5LVsbrHQu8PPFiHXDD81zPSc3vhKx98MWh7qqwLEKIubkqFIkTt8X/PytSJ5DMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZSikwYc4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xR8F1Nsd; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZSikwYc4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xR8F1Nsd"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54D1BqA4030076;
	Tue, 13 May 2025 02:32:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WIYd47+WUtkNWoS0WT
	kXG11Zj+HuHuX844y0/LxTgl8=; b=ZSikwYc4Q8cASZaGpJmlDOrPHEn8hxVVIG
	XhIFxRUBxF1fXi6bbiY+msz8KbjGROIeKltfo2XW3/gQVoHzukgryfqO2TVt+UFP
	i1sCgz8dpSEXY7NSr3y/SN6ywjoBi4Au6L6Cty41OlHbVbHtelaV1RPOaXlM8RDe
	JYUmtCDCuiFXO0rZkAZynZzGB50Pgoh5Gu6wMvdGOyi7jxQmQofA169x2jLnWSSg
	QXRhjlaBjkpSP1zTee50N9WRhZVuhqwgODjmWQ3fgvUzBGg5M4LJ+8yFROPOAlQP
	nONxUlW8TSTcLl7DZ+WvMzWT6hgxKUBvwAt361WLNXqqr6PjSj4g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46j1d2bqfb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:32:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54D005Lc002436;
	Tue, 13 May 2025 02:32:19 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazlp17011027.outbound.protection.outlook.com [40.93.13.27])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46jwx3rt2n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:32:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CscNwZYbpR5jE7lE2Ny4vwfe3OkOV6wGd4BCWur2ZB39etvuqIbfrU600tTp+IzbSCRfd1QRyK3ftiXlt9V8G1knIHjgKkVUzzO1nToY41NzLFa2/RTFVUN9Pyc4ePFewZc2FLN4q2WZ4a24qb1f0DALgXZo+OUrDcY19BtUVf4IHIACb/w0sCAYrDadJycGouGUYKFlLvmWwHrJ/NF9flFTb1KFFHXh45hj6rS8B8AwDhBx4C/hWPXiULZtdToyymqxazfZ6AKNhvGGu6EOs+MX0PqMVaSJIDn/OoMG+iM1/BgcyuuZBQz7IQ0kFUT9kOi6a8VcL7eQhlONOPFEeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WIYd47+WUtkNWoS0WTkXG11Zj+HuHuX844y0/LxTgl8=;
 b=hmQy68CER7PbcKMnJUs2CGXteY6kTD7GRtmhmhMAG5dPG/DxVIjhakcD5q91z9DouPriL6diloWdqFtGAyMDDfmgZ+Jey54nVAK3nmgxNTxcEv5z38XyTv+Glf39ghzuJFDj3WAZpI6feScd+s3C9jXAjyJSj9JqDctb88FOtGjpGgQJkd7Y6t7L2WTbybQX0aT2iD7QuaDLLJcf82EzmNCjGByj+bCFK3FcJuAtqJ/2wnNm+z/8gwa6MoC9I/LeWXXekjCUuikSeETbUrsqe75ChKKLfgBKrVm4YcCNvEuc150xdxXWZ3L36OvtJP5JZL0zCqL88u2FeniP0QwQvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIYd47+WUtkNWoS0WTkXG11Zj+HuHuX844y0/LxTgl8=;
 b=xR8F1NsdnzEcC/2APqPRepRi2ff7Nz2FpRiBcVwFJIOXOsMWq5bKmmyOzpXMl8c0qgWE8qNZdOb3YfBJWXZ5ZPiJLt5NtJesu2LIMKrn3HjzwX0ChgcYYshBOYqkTvUfdKISlmZBVbJ/FW0RNMKc5LCQUVm8r1CxUviJlShfYqM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM3PPF5816B0BC4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Tue, 13 May
 2025 02:32:16 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 02:32:16 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Peter Wang
 <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Manivannan
 Sadhasivam <manivannan.sadhasivam@linaro.org>,
        "Bao D. Nguyen"
 <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH] scsi: ufs: core: Increase the UIC command timeout further
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250508165411.3755300-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Thu, 8 May 2025 09:54:03 -0700")
Organization: Oracle Corporation
Message-ID: <yq1msbhqlzz.fsf@ca-mkp.ca.oracle.com>
References: <20250508165411.3755300-1-bvanassche@acm.org>
Date: Mon, 12 May 2025 22:32:14 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR11CA0021.namprd11.prod.outlook.com
 (2603:10b6:208:23b::26) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM3PPF5816B0BC4:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e5ac344-88d9-4bdd-d8a8-08dd91c66066
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qJd+n0U7RHbNgC0yADMfFvxwWkVfZFXWLk0d/aRBQoQuPaMhbaVDy5STwok5?=
 =?us-ascii?Q?tKsZCf9NnXpBe0y6YFPNGF6tt1briYdweZE3Iu7DqpzS2ATua4fo8qr3CAmd?=
 =?us-ascii?Q?yl6hON/Xmn2RNUFpBxYof61DqGBfcsSqax8Lz8iCpVhO/siPAd+YmDpSseJM?=
 =?us-ascii?Q?Ape35GWp4Kn6N3UpRFTWi5/Ph7E1YHl+9m2KxUbWMeCHHJ1pODmnlCCft/dc?=
 =?us-ascii?Q?E2gqeXlKeUKQpKd9NoWpPn29L0YzlZ9vEAsRXriybraJzm0DcVt9TX0nFhBZ?=
 =?us-ascii?Q?DU3vObo27KUAfk0mY5KaT0iRnU72ejRgiJsHGil2caoBag2jC0JQQNmxBEow?=
 =?us-ascii?Q?daO9f1AKuxr+dwNSiZuPepqquwY+3tNigP7WziTBOogrR2HkpxBLWj6X/8Zg?=
 =?us-ascii?Q?0Xh0NOJWMwSNqF1ipO70drk00o/VIQjmSAF6xMb2BjlG9NJAk26kpjkhM+GN?=
 =?us-ascii?Q?B/RLGr2IFt/3PhBMEHgsiy9w60XZr1JR0H5TKMT0Qo72UYvSxYepdwOYEAPy?=
 =?us-ascii?Q?IG4lGMTh6+1VS2ttQ07cfWJ+DqK6bpjBgdh9QbTM6XnqzIi82fTjLBf4y3+L?=
 =?us-ascii?Q?9eOwWRL4X0KiKxLydWJiwariQqMJFbNoA4HRilMQRonrfrHvgYHyfJetFNdx?=
 =?us-ascii?Q?W3EGF5spRNEyxjGgcotJJo158cdX3+N0ZLAcb6xJ9PrvOLzcg/ijBloo5+T5?=
 =?us-ascii?Q?bP2o7Z6X8YvFimBVmWcTz7U+5Un+WmZVYbPBnkMrbHR/7xWakoeJJ4pqk0WB?=
 =?us-ascii?Q?jY6wJNsh4fyBPxqg9QJMl88nDTbOutyAJZ7RrbNcDl0Q5XRgoMOt1jrovp+Z?=
 =?us-ascii?Q?qMzTnMzZOy74dtuhP5ofeu41Z1jXsFCtEd3gTWbOHmVhlQOYJ5MEmgcSLsEX?=
 =?us-ascii?Q?LoLY+EqxHhCTevCRYz7QdjK/xEWVSopDfr6F1MUuRE73M7Lg5Nc9EEAN8utg?=
 =?us-ascii?Q?lB/vwxPKh9X4gzmtUuaEFJ2gLxpmuV56Ed1W1ZEWQqfkdneKbuNewyvh6sge?=
 =?us-ascii?Q?OQvQLlZwHH+qoIPxbsN+EXy3+Q5FnFBZR8PSvK/gjlWRD8briOlQIIO+cJsa?=
 =?us-ascii?Q?/HraWsO2YCK5WguAdfbO02GVkZD0W4leqsvms/LUCfHljXBKyTf084WYpVRh?=
 =?us-ascii?Q?exOolQSjtrkV0qopYkHnJQPpkOsEgBOLjY8x2YBepixYbvAHknI1Z7zk/N3k?=
 =?us-ascii?Q?alqSaSa8xBZctjErfeEX2+F+K7DXodl/7QQssxKSIJR7Hwwl3Mu8s1mC8ELf?=
 =?us-ascii?Q?6zrkw3xUblLaH6MnHlWPp1ri6h8YOV6rfvdEiBEwyH6+P6ifUtQrZXmLw16F?=
 =?us-ascii?Q?Ci2qB9s7XKsjEWcodfLURwMZRP+Klzl7B61ofB9KEsd1mYCvGaKE+VIOH3rL?=
 =?us-ascii?Q?1Q90xb8NYtVXRMZfxeEO3HKZmmYXoLC4TilUafLfnFoZapJTiQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hVvdVCPP0JTQ3BsSDLP7sxPmSI7X0tZxXrvCECn2EEzPLD27NVT55edPOqtb?=
 =?us-ascii?Q?SPbRAgDbHyJ9QafuAxxv6Z4/mowwAGJ9fVAxN7FJrL7OTsUB/2SLp1/T67KZ?=
 =?us-ascii?Q?qs7XrK4PF9fCiL7FsjxTL15TtdjTH8wYBGg2RM1HNFKQ0wiNPYv0DbDuCnrO?=
 =?us-ascii?Q?siz8lo6bXEXUDPgJrZgIMyQHX3LqUfxzJwMU1zP8gp5HHuB369THIj2LHSe8?=
 =?us-ascii?Q?rmbencqyocRPIfpqG4P7L7SFG+fq4MK8f3MPu058Lz+IYT8nRN94u+iCTR3d?=
 =?us-ascii?Q?w4KTblAG29JdTxvplW3Pk3J1G5ONjf3XklKJ4HHb4viXdsoblSHRZS4wMz2I?=
 =?us-ascii?Q?UiLKnVPUS7ublKuohIn0ehdHTD576yR+DfRS6S1ftuBa7X+Ux9iAdedEQ3Bu?=
 =?us-ascii?Q?6/vjMnZ/hFJW7DnBJBpl+RhJQ0Cg6LwqVumj6e/pcCSVFYlY/WKiQgaBwyMK?=
 =?us-ascii?Q?vd8IBXmNy3wLuNhqKUtdTKIKRK/l4f/PM19rxurwHZ1IIB85rwPxX9O46soS?=
 =?us-ascii?Q?NTtf4frJC2Nq4tFyKiOcUXONM86lGEHsDZW82JCmJ8+896OITbOnlbPfMnzW?=
 =?us-ascii?Q?6PSnL5JJ1Xzmh+omAqcOzxTqXsv2GWpyv/j9Bb6mLAWXl3rhslym685CPnH6?=
 =?us-ascii?Q?fJ7ajfUaSvIPDCAxejvliBuyIPnd030wkqLiwYzxz1G6LQOUZlgFscUrfKx+?=
 =?us-ascii?Q?gy/ETqP9kv7hh/OrBkiiAmRhlDu8Y21BIZBWBhEzRcjT7dUV3k+nNn144HY4?=
 =?us-ascii?Q?i90KnZVsn3RuX3HbhrvAo9au3p9bo0382bms+JMwZ+gJIpJxyQXzJDqI0wg2?=
 =?us-ascii?Q?cFovMp99TEiFB2IXXkU7rng2l5OH69pZEicFAe6jrqUW15jmUGknKe/lM5qO?=
 =?us-ascii?Q?GB2IlyGlRtOjTjM140dtavYRoqzpoGMrVAUpgY5adx7JZF0K7Po9xWRutv4+?=
 =?us-ascii?Q?TXwV35oNkdodHhsYyT7iHD4fIcYV5Uu03p0/LG3rszDn71/iolPcvgZHz04W?=
 =?us-ascii?Q?bqxKJPRZPJUs5fj7t8ttYPcurEFh6qmaF7UFeg5Mt9qjVtAzqnMESE6AvQYi?=
 =?us-ascii?Q?eS9RfJzSqcsduoKOxLLx1QWU/b0/MR0G1s6TlSCItgWhADvguUa5g92ArJr4?=
 =?us-ascii?Q?HI/geXRJdGJH6P8D84sBqMRmx6rUP4siC4PDBB3s1+X6eExQOTXxDFzmhmzq?=
 =?us-ascii?Q?he224UyOYrUKGIO5HIBmlcUT8wbCUJigRSJqLlPWzJ7EuftswhGOnvCRx7Ab?=
 =?us-ascii?Q?NK5TrJ4M/++3Eqc1MQ+GussfR7ZkABsCz6AQBLDe5h6k1LURVrag90ID7P+h?=
 =?us-ascii?Q?vQ3mgh61bkeBYkNsEDwJbJkbATf1Mx6NI5wI1SM2w7oMCZ5p+7byY9OYXlwl?=
 =?us-ascii?Q?UpJ0i4/tEp5C6MAiFrayS4gVCYVxLyYkivD3sUhlB/2555qtkUtfd33G/e6G?=
 =?us-ascii?Q?ODjlwR6UzsoQvZDGSJXQiL17W3hssROmuStPlPmY3vKIZHRTDBdvEPBCcVUq?=
 =?us-ascii?Q?eqc8gmz3u4ngEaXX3gVzyuEo6KvvWJRAv8NclNW2EdtN0jw6DSyp/2nUSFk3?=
 =?us-ascii?Q?aakooDClIdzFnNuRDddQ5EPEMDUloS5OTq1k98Yn7WbXeo2OO9eCq3qr6+Up?=
 =?us-ascii?Q?xw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PpiUQa7HOpTxSlfNQ/u6i/r/PVBgqvyn1RTbSdJOK75VQ7WjIP331/JwoNYlhtxD9BLUU38PWhDeE8sMPTOpebdsVjWqOv28Sknk1UKXAfOExstZCdTdUvcPTPcP5+BZ7foqZrGHHu+898sdRlqtILtbjkToiK/sokSy2zBwDikYybTeGP+lmRU9wS934nEqNTdk1D09M+f7vKbmWBEKREIqSsjcbd/1WsvbOOYM83N0QjuKEhjj4mdvLMX6MKtHZJN1/mVwXcHOQuq0fjheyQHW/aioE+ip/vO41HYztPDJWAn4Cvw+qAtutbqUcyMiDqUM2yDMwlheZJ5U8vxHwapXvI9noP2hYVN2cxQkaxStgp2Zh34wvye6u+Wgb6A2bVVel29RW+IMEOlUY6Q744qKtAN28ri54bU7Gf/l7GrNnffMuREd+V+crBviLihoRZDWBLgmO30D2MmoEZzlazZ5pNPbdajVd5Y/BchXae1Bmc2xRRfUWB/PdgCpZizgNelIrpfjgFul9sPuZDFni2jP1BXH0MaZzuJXcjmYdDwpkOcIDuQRNbWppQsbXjN/dEJgjhl0RVmU1PB7edhhGk+LK2NRA9qcuvYgdGGudy8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e5ac344-88d9-4bdd-d8a8-08dd91c66066
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2025 02:32:16.4861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U/3TjhK4weLIPkerggECJQ7whza/lFmZMaJ0AWHgZLzbRQLgPdeLgzoLaJeEJBkBebnFyDriKWdOjs84Eh8w1vgxIyBK9Yp3iryRvpUkHQY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF5816B0BC4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505130021
X-Proofpoint-ORIG-GUID: oQUujG2n7g-_Sk3ZAvM98tEqX5RwxTZx
X-Proofpoint-GUID: oQUujG2n7g-_Sk3ZAvM98tEqX5RwxTZx
X-Authority-Analysis: v=2.4 cv=XNcwSRhE c=1 sm=1 tr=0 ts=6822af34 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAyMiBTYWx0ZWRfX6GtNyIdTJBIG 7FLMHn8nEMJfNkzKjdwrqrVNsrOd+3Jn0UsS9mvA2KJ8ZAiER+VQUz88KZsz1EHDpMlofZU4RAZ fe8zpkdb0URkEvOW4dKzaaNbOw5Fk+V/5HXLDhbCUC++H+42BIiDolK8vxjv41aGecc2Mn8y9a7
 mQkHRsRV05AkBLfrC+3Ilrio+rTGyBq/QmUbkqEeCmB5HxEKLzH5+Iy2GPFYBk7tpxQ7UFsa0b3 xnbEudLEwAu/v0CGaEmaN9vS4uE24lbGkcD1JJOFBhOEv97tnUD77BJkKV/bktXggwDM7/JOZlH Gb8ENWUHsZ5WjWSKEjmK8Jxt+FskapZfQOZCc1ow0Hs2Wnv14RvRXhT3VIwZmcnO34heNGtNv/r
 PrP/kFpHgV5uve6lA4L3BOX1E5Xl/doNFQk5vC8xSH7iGnEuLGy2s9shBEU4keTQkhKVf26v


Bart,

> On my development board I observed that it can take a little longer than
> two seconds before UIC completions are processed if the UART is enabled.
> Hence this patch that increases the UIC command timeout upper limit
> further.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
