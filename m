Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FC72D877B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Feb 2026 02:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770173861; cv=fail; b=qbzc+UCaNGGoaSOFqFf0G/c7GpqZbwd36wQMc0UdARJzVwkoh5GuSb/g3vJ7N6x3LQrfbfgeRnhWFhBPYnxFdHZ98ZSw896bmytHbSZtLOUfhz2yUzwDw14S8qMyBA6yyIsYyva2K+tCvaqgCIjGuXJutBrvplWJVMO/Lj55eE8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770173861; c=relaxed/simple;
	bh=buqTU2xkXndMzhfd3pMwbmDI4OfWei3FWTEl4K//g2I=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Od+c5Cky3dmgMnNqcRBv/cXwNxPsSnIgk1qFjX2muSl7fiKUuHjLcHvXknjeUtsSrDSY2SIT2/olh3shVMQPUIwySarEEuYw20ySV/p8q8t8tgGajHf1ZD+Q+7F7sOBolotQ/MMB/eiFASYCOs98+sjoejmYum6W4jzxYiOZbjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IxivpZjs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tSPE8P9F; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IxivpZjs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tSPE8P9F"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 613IuMMC157444;
	Wed, 4 Feb 2026 02:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=y9rk4HlkJRvDk8fWlv
	waEq69dITF9POwSzz7wvdWAbg=; b=IxivpZjsRvFFcFoRqFGHb3DUmnOzHICC6j
	3sE8W01Qcik7irXMT4+9cvSa8wVczmgUvfe9CwGgLtTPySFZ/1mbsxHKNzsOEgJX
	yLee5w+d1Jx+Awt2Dz+B6WMaWsiEBgjpRu5VsJMxsnxF1MDap59ioMt/McqEloKu
	pjbQyXXhJRQRjKSd/vKkLl77l/649+mUrIMtnFKXXTDD1tkflkhFqeAVR6QjrYWu
	/MQyFqD7Z+TMA7UyX8/ZfCI5A12xqjKJUM58tTCPiDbjr8CzbSx2uLxLuj13xfzd
	luOM/1Mixt53xd935GWvwl5HluBlgd3/cHDahNqed/M3mkvToOTw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1arkw7u3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 02:57:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61410fNQ025719;
	Wed, 4 Feb 2026 02:57:23 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013053.outbound.protection.outlook.com [40.107.201.53])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c2579dwqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 02:57:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FbbEKiWc4hzkx0tpKiv5blKxT6suXkRNBxoLvoLjwbwiZF7mTHMTdlFWGDHzxoKYOmwKFMWD/9mVhhi6gwfm0TCos/k8pJbc/sc5E7cMyJjSqhxmIxPr7QEciqgJ/dyKRdZxvvRttzlXhJFPtBygU7Bvgflm0f9GHSIMtOy+l1nF1dU6odh+mypNwMKyVRAoZgEaBLZS29NgbZhu8s+2JR97fnab9W8tBDlxtYJA5JyYvHls5nhVM/GvbcNSPTcqhcSZW6Fx0Vb52go/gQYM/CSGbvrU5GzJoirCDIybZTBm2/HwrlLCrp/Qq9XyFnT9dvadAhGYgamVpZeFxQ1E9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9rk4HlkJRvDk8fWlvwaEq69dITF9POwSzz7wvdWAbg=;
 b=YDDlqdwNhq9eexHl9dznSSbDO5GptqdeR4CWOw+ups2ljPhoOAhgxuKQwY7MclIVnDekwrNsh6mCz1+zOrEhKbI5RNmePo4brnA3Y97VolldU4Cv/iepJa6F60QiuJz7ae30NaDztSkchxOwtJOqo58Pf2W0GpIJKa/X3cZOSLElyuDxRNlE6QYedC5eRhkdxDXVGe5mkzwgvXzUe9mVoeAcauQmMjAC7IfFTmdskBeK8oGrJi84qrshIqqlC4PMhaELj6KlsZ0i7lpZmFiunyOg6PHWAE4X5f4+zHL/QBqgN2QyWRYNtwRI77ZpFZiSiu65jKrEm9AFpZTshvv1eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9rk4HlkJRvDk8fWlvwaEq69dITF9POwSzz7wvdWAbg=;
 b=tSPE8P9FUW0zzZy7Ji58HJ+rN1FwSYbY7vHQ80618oQ6WAQnySCpk0v/2VQc2lCES27rBxUWPgSq0KViMXnQGmz+NbqUhaT0QpIm7fTxBMBasoTdk+6iRs/k7q2wTVdnSUAXmrq9zds+TUVsUqjd0INLOrrHzL2KzITHtF5qijs=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY5PR10MB6237.namprd10.prod.outlook.com (2603:10b6:930:43::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Wed, 4 Feb
 2026 02:57:19 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9564.016; Wed, 4 Feb 2026
 02:57:19 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Peter Wang
 <peter.wang@mediatek.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alok
 Tiwari <alok.a.tiwari@oracle.com>,
        Chenyuan Yang <chenyuan0y@gmail.com>,
        vamshi gajjela <vamshigajjela@google.com>,
        "ping.gao"
 <ping.gao@samsung.com>, Bean Huo <beanhuo@micron.com>,
        Can Guo
 <quic_cang@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Adrian Hunter
 <adrian.hunter@intel.com>
Subject: Re: [PATCH] ufs: core: Use a host-wide tagset in SDB mode
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260116180800.3085233-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Fri, 16 Jan 2026 10:07:51 -0800")
Organization: Oracle Corporation
Message-ID: <yq1ikcdp663.fsf@ca-mkp.ca.oracle.com>
References: <20260116180800.3085233-1-bvanassche@acm.org>
Date: Tue, 03 Feb 2026 21:57:18 -0500
Content-Type: text/plain
X-ClientProxiedBy: CH0PR07CA0007.namprd07.prod.outlook.com
 (2603:10b6:610:32::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY5PR10MB6237:EE_
X-MS-Office365-Filtering-Correlation-Id: e3b7f169-9455-4a04-45c4-08de63991c51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ExQSvsxVJFkTM3WR/39wPtJHpcNrNSSwQ1H2SXIwEy2wZf3AdRG/xts5ODkC?=
 =?us-ascii?Q?mhZKTwpaPVxJAHV+RhdoclA/KgAXYGQ5Lw7jkpuWKeQkfM1RuoAvj9hxxflj?=
 =?us-ascii?Q?dy1IsiD69HzvgtbyFtwE2ZmOqFhCC5iZwJpRubOYQFEF8K3QHoDNSfuxxEiC?=
 =?us-ascii?Q?UX7HeyKPlW0zmOQpkKh3wsmY/0eShPT9Mjf7SBPE9v/dad/8s1x+Obi7A2NE?=
 =?us-ascii?Q?vgjN0EyjNPl/UlikucjG+SWZrG6O58YK9HCi+87R45LfGaH2zZBu2Ra/M4Mq?=
 =?us-ascii?Q?x//xu3bFxtA8vfuBpoIUjz3A/mNHCAIKLTCmPbSaOusJjg5ROiNCKUOb2EdO?=
 =?us-ascii?Q?MJOghZSAGl00uawwu9q5XebyTgR31QXY4a2UuwzgMbPqINYDh6e3w0fPxeYl?=
 =?us-ascii?Q?1/MDf9lusM7pDDkxUJIqeAOs9+vz20xPNBDgXiKmnOR6UPFspS4o71nNSjBB?=
 =?us-ascii?Q?22i8cQtuOmLohJaWHVXHUEFj0vHwjnthWwEDQRtOjrwONeyOlMZ/Fh0qPkl1?=
 =?us-ascii?Q?nMGjFZqpp0jeLm9pCB8qazGClBkfXyzmKqEW5QpvmZK1r4WDF3OpT0xuZ7bR?=
 =?us-ascii?Q?QO2c0dRtICESQLOh4jNevXFaOtF9YOPxuob9qTS1IvhRO+6y2CdgzFXaTvJG?=
 =?us-ascii?Q?xspSg/wkDNuH4XsL+89bbBpXUODG9peMT9tKLMeyR3tl0DsAzEP1XXGn+5nn?=
 =?us-ascii?Q?MY6urANO2dsrcMIRkEhsEXsqLuEvIKEGvlkfF80apb3uSahhl6+4p71eM6K5?=
 =?us-ascii?Q?8zTjKWNEsIKgNzWYzuig8XbiODUeEQkXsqcxpMswR2WOTBrNPY6H0VfHVMKF?=
 =?us-ascii?Q?fXy+mdBwZJ+V7i3pnOD9DnPZvk2SzFOJs4A9ko8q67j4ej4ZMpnFddZ1mno0?=
 =?us-ascii?Q?6rbbxntMNlP+oE7iX6r+iQ/AgMqNPmX9m2FJBgWtzbXqq+qRrlcgyvSRQzhu?=
 =?us-ascii?Q?gh0z1yn71SiU/UodbzaXorYuv+0SKcim3OZT9ETBb/aRItzPxw6/B0Xe83d7?=
 =?us-ascii?Q?8IUEu9x95/wWQPsAJMryUhJ6o9XxD/Rg0tme1CgpYj/8MbzWM67TJMG8Vxdq?=
 =?us-ascii?Q?7O7d5E56ZMdo7fw/9EusFHREf2qiMjlBPdBRvRH+NVtppxC62yEYeKigjsT7?=
 =?us-ascii?Q?dVsW0BaLLGchyXgkuOoat+4Y9SvYTta1L1pwer7iMo6buQkFJd8GrhBCLYAT?=
 =?us-ascii?Q?6MOzIFKW2Dvs2bfMaWi6j4u4Ke02IrZTNEBYfgLiFn5bQi88SqNxjDcvQgy7?=
 =?us-ascii?Q?uB64dPhV9W+XoFno0w0oPkrlgSzcQ35cKw+mDq1mNAQdJce2Swkzccr+n9Rn?=
 =?us-ascii?Q?HJGOC1zxUGM5UUnOO8cwTpJM+6FcgZDMLf1/72ErzahvtA4Yt+p9WAkWV1Pf?=
 =?us-ascii?Q?cu28lSACk9OhhOsX6gAAnvfXxLIJJNzn+WpD9d/Fnpp+eCgqGsnjC0dGZsHG?=
 =?us-ascii?Q?JxQWSgjl/MOS9HG5WwoRzOgvPUCAB9nrxJLLoenTGVOhQz+mYitEuqyvESLO?=
 =?us-ascii?Q?HTBFkEuHMEBw0G535NumwySed1TmaW6pa3wAQCM0xrIWOOVle6i5TzH3i8/A?=
 =?us-ascii?Q?J3kB2CfJ5PkWTbT7vM0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KxGVBJl1vMvcstCskRdQwZYKo92cXAwN05GGLus5SYkM391wi+/WTvYVmh7m?=
 =?us-ascii?Q?1FXHXd1srIPhObXq6Zy7jg1s1HlAqlfzuiuGnujPicihSPtXivhfHTwhSANN?=
 =?us-ascii?Q?UYY3yiMlk6WKzuqxCU7Xs3cqZJinSveAsvjlvY6KMjnMPZKAoruI7jEyt1e0?=
 =?us-ascii?Q?8IxlHDAmuqn1+gQV5+ohu6hNNqi30cRxaRblz3Ndp3C9eWPtJfWdMDTn5CnQ?=
 =?us-ascii?Q?Rl2SfO3lV534re7CXDaaDztYt0tVUMtlGTt7igslGPvNmKpcGNnv9qvOOrRA?=
 =?us-ascii?Q?UnNzt4o4rBj7yVpvU15b+YKJFWKXkPpJwiyA54ivUmRx8+Uo4Bsm0TTtrviP?=
 =?us-ascii?Q?T4HNwwxl3oU/apD7aC5dZagHHhtTtm2rSyDi/RLmeI4X7BZvrYvnwv0A670s?=
 =?us-ascii?Q?Cqz0Xi+QypCXkOba0jz68yf6WvWq+VW2gWhIJ4MQVAZwz4VAdywUkWkvHhPc?=
 =?us-ascii?Q?rMN+j6HX5Erwry6XBx++y31PhHerTOrd260T9uTlA7CKm3cQtqhj8+Brjqnw?=
 =?us-ascii?Q?h54RRx85h3iKPqK0iQI/HMVuiEu8Zj/MrlZGA1TSHQ2LATO/cfJP0ot6akQ2?=
 =?us-ascii?Q?j0LEYHiIWgGZWvyaK/EQrdb0uyf85dzL6kblPiENjDicxW1BViiwqsNo6N5V?=
 =?us-ascii?Q?PqDB8J48nInS998tb/VyWbQE1OklsDxf1xOZFJBe1lHhl3vkcyG4KIpDLtuB?=
 =?us-ascii?Q?+WO7V7BmIefXy0g24xMHTPWNGvs3AC+GdRTZ5gI2AFvXt8SjtsryITYM59TI?=
 =?us-ascii?Q?8B0GI5XhtGTlmkxF+i0YJKqvbzBspvy+NL12NVI3GZDzzY/fuK3NrWwu/mwE?=
 =?us-ascii?Q?D3apluObD0TWQUXsloYIncK7Jrf8QYA3LMIJpX9Kd4PBTKdjdaroe1SybN4a?=
 =?us-ascii?Q?xu8gsYQfoRwNkMILCFmVb1TCdt6wuFQw+csgG5XjTJF/N/PEP2gFSv7xEu4F?=
 =?us-ascii?Q?KK0ED1aymieoQOTeGuPncW2nqUhT7paM75b4Z+Em4FrHj2lHQhY5GciEv5zK?=
 =?us-ascii?Q?1mW0PnGZ48fqLVVQQaF7FrLgLmTyO+dFL2fMkxKK9SQkAWjg8Jmh2YfmC7se?=
 =?us-ascii?Q?GCqM6iVGdN0lFqNIvZ5j5OSzndEkE85bgNUg2RufFvYlIqOk87vPREPnoHUN?=
 =?us-ascii?Q?GiyefEUt/Bv58ar3QfZrS+XCSLJ6o7sv5mNMfSeNWgm8nvMxg/FMWR8c/y8B?=
 =?us-ascii?Q?+rgqWvWkoDjNnrZdsJJ+O7PpY7EWaQrjoFmE4/lpu9TI4LcxmqcA+PNVTb4R?=
 =?us-ascii?Q?NXwzZOnsrAbeOYfw5uYILEjgN5u+umtPIbG1epwzocjxxhRfyBTUBUuG3sml?=
 =?us-ascii?Q?HPUsLkb/guyemGGOqjCEOVB+v+WzXVbDuM+6pEYuZWwXFgimeZO4JRQWY0AP?=
 =?us-ascii?Q?f+mO5zxJJ2MLRYEvxfzrk9c2thGAzyrB/xi1Vr2OBTvVbRMjlaquxSmHXdlz?=
 =?us-ascii?Q?HNR9u2MnFwXXKkoHY9Siz38/aRku/1e054HjN67vI+DBtp0Lex9bfL8M78wF?=
 =?us-ascii?Q?QPeMcPVtV4M+o7NsDlJkx6wAfS1UQyLZS5ujuAAT2XMKQmbxmXOlsDCjcWib?=
 =?us-ascii?Q?14zMeDi2zGQnpMFEH64+eVSxAzWrT5DtHYhj8dX9wQAmpTXW5GKTZHNfmtCk?=
 =?us-ascii?Q?EplPlBoqJI1cguJV+sS5NSfhHnQ4gP41aoAuY8CgvaPGakqL0ARdhVZ9FEE2?=
 =?us-ascii?Q?aU43jwQeA72ODxWTkjAAip7m5N9iiZoYqaAgyfYGmPgxu35z1C/pDXcV9kX/?=
 =?us-ascii?Q?1wiG9pB/HEaGJ6MWgf54gRIpNu0XwZ8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OuHdfmiFnkDy/RY5OFRKdV2A51893wgYzna6/A2jIoZlYakEePdLVbraKYrqYMfJnRaDQzTgmU+4kewuLMLLlTHGouZ8or5VW+Ry5B3u/UnkA2KAzyZUjs62ZzrJ23iSshwHby++dpWJqS01Ij26ntTGbdRu7uO9Rr6UN+mthZaLXQvgP48GuAapG04STPDpFc9i2zkIEjH8ArTWqXuF8bFOv/Qir6lkHMk23mAfmfrTScfzM6TUI7FIMBc3rehpJr5NvkBX4iWmhrZAVoRzvTCo46o6ZgOY1EEWU5dWi2T2PtvSn1TXnOwuYu0UbNbcPm2K9Yk9lj05osH9YNjqTF2I7VjZkuGY3ThMRMzucEuMI0EfcKLsUgm/NyLqdVSKsjlPHhQNgJM1kD8yrNhdmqlBzwKlcpa/Fb+hMUswC2MukWq6ZEECNjad0wa7Sinj0nZgr/BsbJ8WwP9kI/EcgG1FzOjQeJESY6I51lWnvtkIt2GYgXbnu1zAPvGDfn1xVjRDX4tVQTFy7abAlVLDT4VoNDB7DZ3i9wBUW4Sglz1oTid2TAmrUcZiWpbYeb/JY6w7Yd/LRz8TJ02Rjcfcwudnxl4I5ehg0IiRkKMXbTA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3b7f169-9455-4a04-45c4-08de63991c51
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 02:57:19.1420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ooHSfVebTimcJSjI4JkodBsfr6jEzah/E5WKJLFseYp5yVThd9nc8Vp5Tphhd/dbtSCt0EgZxzHNkRPAN7g/JkDyrLrphwj0uwpmGfHP6xQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6237
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_07,2026-02-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602040018
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDAxOCBTYWx0ZWRfXw1MUaCT+hP03
 pRl42ISrffMyOf4WlNyKjmhJo21EEgXx/OcXnDxCAHKzhp7h225UN00Qv4DAcLn0oejfU5O9cb7
 yk5FYQHmTRfVwEaf2jaX+NpZhb42K3jDqekSUxcLe8p7MQRZ/V2X4E/Qn5NuYt3nlMbl1vz9Jwp
 u6ft2TtrKnlhrXOOGkBpKTL/faOcMh1iI/zYEkDEZDueinJG8mZZ5PXtLduADD2KE/lsrOby660
 2cDsKcPgpicCxczIPSzjPLIeAcKswicOzWVHO+/d4c/SLw30MFkmdV5gInVcGzzewr9DENmIWWz
 iuYT2jmCQS7hmjCJ9tz1za9UzFKq4ubktd1ZrNejBuFFbbFjxT3Mh++sl97/P7CptQacCmz/bQD
 SK+mu8YVzyrnIL8E4bYsI9Wz3QSsAjj4n97yEuAgJTJD0tGKbF/ICmd2wJlTkkogmVRZ+qT7cRD
 4n/q5H6XBWEPabrDZOOgBxsIlbQZ9icnAYdyhmgU=
X-Proofpoint-ORIG-GUID: Vyvqetra7jzB0qkFaUCY3O-KTg1u9C4i
X-Proofpoint-GUID: Vyvqetra7jzB0qkFaUCY3O-KTg1u9C4i
X-Authority-Analysis: v=2.4 cv=VfL6/Vp9 c=1 sm=1 tr=0 ts=6982b594 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=4UmxapGgOvRovlyjj6YA:9 cc=ntf
 awl=host:13644


Bart,

> In single-doorbell (SDB) mode there is only a single request queue.
> Hence, it doesn't matter whether or not the SCSI host tagset is
> configured as host-wide. Configure the host tagset as host-wide in SDB
> mode because this enables a simplification of the hot path.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
