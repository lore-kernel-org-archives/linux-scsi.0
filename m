Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06896653
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 00:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726187724; cv=fail; b=LzysassUt3xBXUkUjoAVjFCHWpkBH39i0Z1AoN4XmiiDl5vu79sjfAjDdWGrGSUX0M7hL/JJ9xjUtaVb5BbkfYCAiEhtuT5VrZIS6HGf6gK/iRZpPzPCV0b5tsgtqgrFcG9ZQWdVu1jp1qe91IkHZUoqffV20hXA41mq+2qpieE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726187724; c=relaxed/simple;
	bh=Hwg2yTQqk5L0XJsoImIc94lH15CwMr52SO1gYvXQhic=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=n61cadlKy1pawy7dIKARCoEFUytVxhDwlmlUgb5whPCaiP3EGIzqgU4XqpTAiAxSM/n4AvrGyW/J7wXWJ50FcEDxLHrEd+bWdbrkLcR/ar1cgZVZu+buWo7QmMUsF6Wp/WHChMjMcFdncJZikGEm3x+Ix+0eQb18MZp1Ds4I92c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mWm2/2gA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PMGHPW7F; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mWm2/2gA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PMGHPW7F"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBYOb007339;
	Fri, 13 Sep 2024 00:35:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=CFRSoIBYiWxNEu
	H7CrSqL7UuGVG/k9QtBXWwq32bK78=; b=mWm2/2gAcbjtnB+mN0bJ2Pc+DBtby/
	2Cp/JsHSwnMU4rGP+6ujcbTi/hOSV2+bHYBP2CQ0dlth3kfPx78stRObnjk9H+GJ
	2SJ45RiXRTIn29VFtZy6slnfujY3MGBRJIraXj0N6dOHbqDda6FuBlPTONN7+z9O
	yKBUYCWzLyZYcrpQf1elLAYYrTaU9EUxpaTHGQkxW8hqKUjNiTyQoh5AIdqGPr0t
	iHBqYFXK9lhPUW4MgPxjorTM44P8h6j7/pBzbWy6XOB2T09EaZPoeYPJxenDsNLD
	0HTnqW/ocXjVDJ0oFi8fIEdvtNc9mRj4Cf1Q5gCcMMeFvlv3Ersuh3uA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41geq9v488-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:35:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CN0ebZ031602;
	Fri, 13 Sep 2024 00:35:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9cfpkt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:35:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J0c+eXG/2gKSA7abiLR01Q+wTreAWMpyrFAc0ME1f5hpvz4sCW4oQuzygQ1XgSMAu9rMvke4GsnNGPyoL1Yr2aiI8UZPbwlUwDEKxhT/SyI5Pk85s6biQwdOn/hO5O9wYS9bWQvl1x3UaFcTMpEHavS6HcxobDocewNxIDvp3GGRTjmnhdpesBM7ynd/LWtGLSgpqdHCKyE+hHzkXZz6PJ+NxRwWCPC3v7vrs8xOvKygC+Tkgb4H1mEzRqK8RbD3mk5+AxZ6+rL/hGaKSn5PE435YK/oxmxuYdwjlF5aRkXhccFI/Hh2v06xbr1FOQqDjHkK+O25o+YgdPOprL+1iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFRSoIBYiWxNEuH7CrSqL7UuGVG/k9QtBXWwq32bK78=;
 b=jgOzwfbDCMFq597QAM1t+Em5OxbxObWvMXCtpDReD2fi+B8t/1ycpIh+h6fqDK1dcY6uzWgvuyVUkVRESDL6ddpqxhvh829I8w1dkutiqSuZOwO/IS382EkSABHdEOlV+q5HZXZNcuvpTaVS31kvf4DwnyZMUXZ+x7lISdKTcUAJZxBNlfnwxsu3XSRdO7xuA6pody2rwUBR4GjI4/lcB+DRiGv09crgM6+OAKmkxJhAb8jBdx/fYppkDqHDqJxnRiiP156J/S8chNybaCu6DUKSow3bRNlKD9OuwPJ+gupBjVSvu+A2uso63bdsXfEsALF6yH/6F884xTMT5tz5ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFRSoIBYiWxNEuH7CrSqL7UuGVG/k9QtBXWwq32bK78=;
 b=PMGHPW7F90WWmbnbHW4cOsXL2IkzI93UwQ2OJ7i9N0ODt5dkNOTrM6degqtLHdAuHlg00Ov5uhArATugxtpHPZ6Tlk/xkB62AQOfqb7Nis5mY8eyzX9HBH8pchv0li6C1XXoak1D77UXhpAz9+Yre61eeLIrk25VquuV/P8CEC8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH3PR10MB7161.namprd10.prod.outlook.com (2603:10b6:610:12b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.8; Fri, 13 Sep
 2024 00:35:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 00:35:13 +0000
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, chandrakanth.patil@broadcom.com,
        sathya.prakash@broadcom.com, jjurca@redhat.com,
        sumit.saxena@broadcom.com, ranjan.kumar@broadcom.com
Subject: Re: [PATCH v2] mpi3mr: a performance fix
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240903144729.37218-1-thenzl@redhat.com> (Tomas Henzl's message
	of "Tue, 3 Sep 2024 16:47:29 +0200")
Organization: Oracle Corporation
Message-ID: <yq14j6kxufd.fsf@ca-mkp.ca.oracle.com>
References: <20240903144729.37218-1-thenzl@redhat.com>
Date: Thu, 12 Sep 2024 20:35:10 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0482.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH3PR10MB7161:EE_
X-MS-Office365-Filtering-Correlation-Id: 43bd0e6c-4fba-4f7a-735a-08dcd38bee7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0Jyd5+329mmOH9GWB7TzCzObNlcOer2mFaP7da7a3a/7YvYQgUnBdKE386RR?=
 =?us-ascii?Q?LwWUC+0LcaZ4cEp0FBBbJomRjRXpvyh2nQdryLXbi3bEi57B56q6SYmkt78v?=
 =?us-ascii?Q?XpUj+IxiGfVcJoVUXQGiQ+XZ/lkK2061hNHzHeLXDNYK0clKZ5cnz22QPpqL?=
 =?us-ascii?Q?EAJ6jjgyRPc2xVDxU/jSedKT7phcBzdZRT+hmTrABV/RUWwq8/fhfU+XE6LF?=
 =?us-ascii?Q?8gUFrDZ3/644YltFWi0u0hHzNCjo20JQ+zI2CoQFeWcCfKOuB+vlVuuDLVVV?=
 =?us-ascii?Q?ePh1cYMPgi1rKKQ5gx8t92xsi4SjUHuxH+GJ+MTCijYiD37D6l7qUhKgQnLq?=
 =?us-ascii?Q?20jByWtl2CXhU/RstCU5xPEJRs8hHOnSHUSPGj/7pW9waf2rrqhG31vdbJfP?=
 =?us-ascii?Q?QVDIZCe/qLSUq5D/Fp0ChVNW2rqf5Jt08uGi7EqnP4Ls9MDvZaSyGzbXF5vi?=
 =?us-ascii?Q?uMg7YCiJUKlSvfOz0JtHdPEeatw1ES65HHFg4hazJbgt0u4If64J0K26TU75?=
 =?us-ascii?Q?q/saaKHVQMO2+qO/RfyXmdWKTz4Pxul3J0b7g+2NL9t23buZAhTYPsUJo9jJ?=
 =?us-ascii?Q?umEP20Tm6JIf1z9MtvdBwi3XY/Bbb7zH3vjPZshJ1Q4Pszl9JvbE61zS+vVn?=
 =?us-ascii?Q?g8WrZRDY6HC3o0xBrABW4bvNg6gzuqKccqeakSDZMhcaIcUDTUpL1m/2ylZP?=
 =?us-ascii?Q?5C9yVZ5BTv7cBvjflovq36Jl6/ONzi0aiN2C6jGpyuWQ2RC0NYtXgN4KRq8I?=
 =?us-ascii?Q?nqe2gJC48w2tKeiulXvcDff8oR8I/LhskngBuXupQeukw0Fdfrv0E8nLfN6D?=
 =?us-ascii?Q?3TdlUFNPLJ8T4PUh8JCzL0tO8FyC5f5wSDRYjAaISDqCrcWUJHxWLyQmi2bK?=
 =?us-ascii?Q?nxUKTc3gvEPEfljcQnGwIrLcjY83AMTluSRmewbFFj4tg877lkE1YwL1OlmE?=
 =?us-ascii?Q?e6ja/8nTNgAf+sP2Mu2xVQODKp6O+I0to2Ol9h4/J0LHwxDAI3gzX1+oLoM0?=
 =?us-ascii?Q?xK/S0zQhLi1lSz4epPz+/5x4CwamOX15B7aSR+mtjvnh/XWtBNl28U3tgdfz?=
 =?us-ascii?Q?MAZfyZugZhh0/zLtug/0rSzVDNd2//gfEJPQfBU7ccidoWKhMQAiHV/ZQlUH?=
 =?us-ascii?Q?8S3nSRk5SBUwJPdKHp3433H6KGBqfwn1hXH/Li39V5IUVSPr2T270EeGp1Ku?=
 =?us-ascii?Q?7l7wcp5+PkdfBUu9/CznC+Ig8f5438b5I+rDFwUxb+DKjjmPB46nAevsDhwL?=
 =?us-ascii?Q?pKcTIlJKHrCsKR8imI3WThryHBVHljCWeeGOy6280+/QSgHw6uW6iBpdA+vV?=
 =?us-ascii?Q?xIpdYFZtSlozLVlLmQ3AHttWG3PLzQCQKf8pQtw4uf+lwA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rqLCLqXIYubY01vtUhxgtUaHp1ednsovQN507Xj/h78TNdTvMgeDo9nY/a0z?=
 =?us-ascii?Q?olu/VyHklOBvUntO7mXLhQDi/goA4muZ6QcCrxwLKdaiWLQyJ/5cUtvRXh4S?=
 =?us-ascii?Q?sGxGixlz67GwI9SiWTKyL1ZaFFI3mJuuedySTCcEsuC/YX9Wtux4SNskZN9n?=
 =?us-ascii?Q?IZZ766PVhrg7kDM9DGrBJhBFr8lxuqnp5o7eNqdBGAK4kfxlQlZVfa3/AmWL?=
 =?us-ascii?Q?uMJR/Nko0Kf0IRyLQGAxV8e+QtlL972KqkqkLU6KR9Dml+cCLUeU8+sCVOxQ?=
 =?us-ascii?Q?G7/S4rwGNMnMHtk9Sk+eOkHmfVePhckt66YPbXzOuSDIp1m/ADWmbGWwciD8?=
 =?us-ascii?Q?aqg5bUfrqYTkvulyF4NmMw36PAnZeWpwQjXMYC/xKnRstLVitqWfGFdxiDiJ?=
 =?us-ascii?Q?iJkm7xPXZp2U8Cyr4gAhO1g8QxuY64BYeohfaHpOEXlk5No5Wkco7+czI7r4?=
 =?us-ascii?Q?YewWIGW1V0ykhSSVi6ys244buBwS8o5tko0N/3GBkohtfjhxCYkbzL60FBbe?=
 =?us-ascii?Q?T6CQJC5e+JF8YB3jUyqN0z6EazhN/PfVEH3fyayS4+rd2DL4YbEU/wKKqw68?=
 =?us-ascii?Q?2ucHb/48voHFfemaYEQg2OWP5HATtc8svLUUdj4qJrVonu2q+TohAlLxsjNX?=
 =?us-ascii?Q?FN+AKpBK0DXTT/HF0ZuHkKhP8p22h2Rc3AKZVGsgUAwL7YhvngtIBVAvzUa8?=
 =?us-ascii?Q?3DMltgACtmGHopbbNoTbnHIs5xwqHq9no8P0s7yO7bfVWTJtPtXrGYIWrKi/?=
 =?us-ascii?Q?VFbZJZc6uHQrX1FRC1meEPyGzFNNlbNYOpjNjy4csp+39ZLRHj4oDd6+eZvq?=
 =?us-ascii?Q?wSOUlgAfhbMffOjbkvDa8OcAt61gKALoMdt4WPMtCCdAt1bvqxaifpNQZxzh?=
 =?us-ascii?Q?UGLatTIW/mG8dxFmdu7kwFkecR0aSBeNXGeudpfd9xTJXPm8vZPYiLOt57cD?=
 =?us-ascii?Q?ex82PF6G3ajM9DsviTARvHMqqDO5nIvDmQC6ec2/J/LDGZWtkgK91EK2xinU?=
 =?us-ascii?Q?OH6eeMMgZm4OIjXR1oCCmE684wjKNH8nQOnWBT+0NumfGsU4m/3DKW6q4TD8?=
 =?us-ascii?Q?SPFBXaBrvZ/iP/+0WkHA1xV355Xv8UhmJToTPzYePtLXyuAKbb28HMTIm8bE?=
 =?us-ascii?Q?1REExMvEXE6hrgAjBq9vCk1eGf5rgK368a/IJUdadyluaIggURYEgn8M9de7?=
 =?us-ascii?Q?sAJTJs5htaf4uecmzNWsd2UefqXmaPJebB7BS+p+5k2TGuPl5q+UvVEFlEoZ?=
 =?us-ascii?Q?tHKkyILU5/Svyoufsf4bfmirOzOkzRIV5UkfsIvOnuDAidJj6HmVrQistmOQ?=
 =?us-ascii?Q?4jVMX88u2ncOMpnz4jkxATODKmJi/ySP4UebUVWR+WVHkZCyNSoW0pNO0BqZ?=
 =?us-ascii?Q?sCYkuyInLOgjMcVECAvNSlXZyFnFvowzAfoiKdfo+62LXNI6HDIJ7gZyuHz1?=
 =?us-ascii?Q?G/qqOuMpRXO2zdn4Zj2Zd33sSkfnGZyTw8stBXj0luyvRlMB1ZNPolM7SN29?=
 =?us-ascii?Q?88gxWkeF3i10cn2K8OAYaPnXCDUUVoTrZhwgqXIpeuZkQ6hxriCm4v4QyM+g?=
 =?us-ascii?Q?Ui/+JfY89MXHa9+F9eGWvVemsUPrSOW79BzsQKQM7EFgO8H49/30aviKP+eu?=
 =?us-ascii?Q?5Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	k+iJdvQoIPm7T7hnc+hmGAIi83cQ9NB2Q/BShtRj1ZHwsUp9mFZ8lRNe1ungzhaIDZQHWMDzCP8zJDlvJ36LpshnHbo0SInHmRR9ZQgAFL5w9GLkIl6lRcEt2jBEIItd4mNUeTjoyywQLA5SwUx6FkcazrcTdnlhvxT4yzop7E7IW+/MWbF9I/HJz3oO6nQRMTDfdI2ZLTWfqbdR3hSZaAV81d1NHpd3kGBIm9PySkyHpFrG3KzwXCr/+5kDSqPK34wCs/h89sVYIwjI/XeXr+m1REfiSMicYDbnxTxUNHRZkueFAJQwCB+kqksLcAG4mTymjubpqv2EvZ6Pptk2xhc+mDW5FXyyybLYlRYUDxdjyd7B9WTbJbMgKk6O7K2i8GXsw8BEUidPa6QSHWLuDoWu60s5q71WUhEx0DZnj722ERmRObrYVpJLQzqsOlKR/E/Mt7SNoPxjLz4RJFqd07faAUwfGkpw4vVaHGUI1vhWb3Idu6Y2jjbKh6lvwPzCCK/s8PxOt/1c5yKb09UYtxlU2U7IEM+FOOujWwD41EN15YCNd3yOUjupDNrZOlM+I3/bMWQ8+Ch81rorWwj0jnHf9maVXSkP+BJrLMgDt18=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43bd0e6c-4fba-4f7a-735a-08dcd38bee7d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 00:35:13.5788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1H6RIctNO+P321SD2O05+qlj0SApQhuOo1VH5EdXLBfd2HTgliiMTUvha7wRdK8GsRBDyGnxuqyxwHHf2YUw3YI8bVItOgr5U5WhYs82qPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7161
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_10,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409130002
X-Proofpoint-ORIG-GUID: g3vliWdMZBQSMoNMb-Kn2lvYSaWS05SG
X-Proofpoint-GUID: g3vliWdMZBQSMoNMb-Kn2lvYSaWS05SG


Tomas,

> Commit 0c52310f2600 ("hrtimer: Ignore slack time for RT tasks in
> schedule_hrtimeout_range()") effectivelly shortens a sleep in a
> polling function in the driver. That is causing a performance
> regression as the new value of just 2us is too low, in certain tests
> the perf drop is ~30%. Fix this by adjusting the sleep to 20us (close
> to the previous value).

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
