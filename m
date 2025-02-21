Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2360533EA
	for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2025 02:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740106146; cv=fail; b=gu05zO6NzGNVGQ8Fi9ZTO+n2SbSdIYGO62+oWmoyuJmRrk23DiHs2NkoJKdUcuL6FONsQMDzGhaBMV2pbalfA7Xctb8Jo0t6foTEToR4wspEivKfauiRriYlX3M5LK87ksXs8aV4bCBsn3YK1dY3tD1QzvtcEWGsPQVsSJYBEFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740106146; c=relaxed/simple;
	bh=kJl+nxFWjGWMHkeZB0GcFLMGYrOcR+/ChIVj+6RcK0w=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Z9IfxFsb88Ge9dgCuKqLMtd83BFp/C1bqoMradYjDlJnPDv22epczXPAEiIqA+f5k78B4Lrcgk2Y3/uLnZn4sry18znXsD5oLfNwwWwc8cfC784JTGhEKQ8OppokRSCz2ajfIuNTMGBEXLJzBgXCnBAgE+qNHNvEMajGhx1Szvk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=InacZ127; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zk1xOLy2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="InacZ127";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zk1xOLy2"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51KLrkqb014041;
	Fri, 21 Feb 2025 02:49:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=/T7238igCWBsiJQXoD
	t48Udt1OKmR+aApcNQq+xBYrQ=; b=InacZ1270PD85WiswQ10rtBCtf7eJwxZQr
	9cU8NGYEDDuTFStoCfZtGayqyGdpgprSToZ8AKYjT8jQ79kpogF64kzO+YNK2wMM
	6NBbxl5VapAa566Tl/Xh5wunTJ9H5TK1zift6oqRADLIQt8iSM3nO+IxPbaOCd1X
	w7R1JWwNRMY+5RkKQW0ngSXySfvF9mRcdE7QOU5EAMGwXpn2H6GeBZ8oHsIS2+UI
	pKEwfj3y5Xu4quKlK9o/7Oki6qgStGw/nsEuyTBJBrEr2vtQgXga+B59Mc3iUa/L
	fi0xaflf3ZauerB06hSi7AJxqZ7/BN/aQC3TfcbXccayXoktGMWQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00nnenj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Feb 2025 02:49:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51L1AIYD009688;
	Fri, 21 Feb 2025 02:49:01 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44w09etabv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Feb 2025 02:49:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mJ53uad/hCH+kkx5W5CHBRBnBbzrYgbvHHvmWGPJq1k//WdimMa6Wm/xZPyFWwIi1IBsUen138cbdF0ZDlbLzjtHca50ud4T74+7RJowhCH65BMWh1FeWnI3d7d+JCi2pTVG5U559SmiWFclrtm7OYH/W3f6nJYmqy4OVnJ2kS7RnZ506Y0QSMZ+HJcgA3M8GvMKynRV0cS4eNIj9gF8LXaoG8B43mqHplv2K96AUAodVBGkikYyx/OaGs/USJjRtf2AuZ+x3GqjabsqwnINMfnmnO/OmIwwwUfyHSv2kFKOR3WIPJjzj0nvIK4LJgaPEje0a8oEScPTN6CyGgX+eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/T7238igCWBsiJQXoDt48Udt1OKmR+aApcNQq+xBYrQ=;
 b=JdjhefFL219XPRu07qF8bK0s2eeuWTlyan/zz+iblurLD7Ya2Sgg9EnbDNkjAKhtaW0gMrTXtjGc5IA8UlAPcJnjrMJgUbKEoiRgCgLtPMKexZyexPzRa/KThKdxiwrDeydU2awcvaLWrYJ+L7W0bOcOQg5qb8kl/5nnH2O9CEmj/EPnqXYtYeG5dXEGDpecSGFQfvtAfnXLYq1uZoCU05djnGtKBSqvXa240QxobD/AWyXYK3/w101XhJLTG59yC/mvnItPjgCN5xKhMUxI01YpE5veUD6O8vKOelQ/7+T7WUI9vGR9WRrSpwXSok9xT941f+PxUt1lbY8acBCjdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/T7238igCWBsiJQXoDt48Udt1OKmR+aApcNQq+xBYrQ=;
 b=zk1xOLy2HsJjcdhAwV1Fmf6ZyK92qgTFY92XDb/ZReWm6xwoz+N16kv6A0SdZs3tSRuIPMjADqepK4KsIyxEAlSmfh61XW3PWVZfCmtdH8CnY4st0SYMyE0SfaOGDuXn72WRrktLsVRsmRIe9IUH6EMbko0+FCG/RoXJnDh8DVU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM4PR10MB7389.namprd10.prod.outlook.com (2603:10b6:8:10f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.24; Fri, 21 Feb
 2025 02:48:59 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8466.015; Fri, 21 Feb 2025
 02:48:59 +0000
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, ranjan.kumar@broadcom.com,
        suganath-prabu.subramani@broadcom.com, sumit.saxena@broadcom.com
Subject: Re: [PATCH 0/5] mpt3sas driver udpates
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <1739410016-27503-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
	(Shivasharan S.'s message of "Wed, 12 Feb 2025 17:26:51 -0800")
Organization: Oracle Corporation
Message-ID: <yq18qq0j9mc.fsf@ca-mkp.ca.oracle.com>
References: <1739410016-27503-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Date: Thu, 20 Feb 2025 21:48:56 -0500
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::31) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM4PR10MB7389:EE_
X-MS-Office365-Filtering-Correlation-Id: 64ad3096-1b41-416d-73f5-08dd52224ac5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tIHIJuLExhk/j+r7MziIS2n5hn0iaU1WQiMbtj8xXoRBOy0sstoKDWr4/cGX?=
 =?us-ascii?Q?OYYuXh1Blwj8lvaOk30kcAjU8U1PHMZ1KLDkisebNMBXeY++7tw+IJiGBWlX?=
 =?us-ascii?Q?syrrGBwiVaDVnUnlT8F8U+dkfMzi3l6gNXXwabyNAVJ1r6k/r79hCa5yszOj?=
 =?us-ascii?Q?m6+OnJimvCx7ciENv7gKkXgnsswjoLLej2OGh5J29ojIbBkz1vtpmNti47/s?=
 =?us-ascii?Q?CnJWhOtcznXJ2qZaWgclMQV9j8iELB+zU3ZWGTQXmXPVM0vvjl1JLAU/smg/?=
 =?us-ascii?Q?BclE+0jx8cwVAZyeLAmydI0TR/GLH76ywQPHYYAQgiOzbrRzrw719QRG7eot?=
 =?us-ascii?Q?WhT2ZpXlZ+GxQpd41WaSmSpBbH8bhblA+3QB5WtRqu1BKQAcInXCHybsV64t?=
 =?us-ascii?Q?AiI5nLEPOv/dQ/mU6z/krgteozMbP5nyrX2EUOoi5i6EEZPdCoBoT0ykkERo?=
 =?us-ascii?Q?uc7Ls4npi9ApNxSO/ORla+lDN7YU4LD1+cwOi8/zlsgYQ9Yr2GW9ZK3DFf2l?=
 =?us-ascii?Q?lQcnRHpRDN8ZP+nBzD8JpBo6NLxxoxAph6FXPRryf7c5gOxTP5qj4IiNmke/?=
 =?us-ascii?Q?eoc3ilJvEv2SH7YB4QvTFFoewnmiZaoheIU18u5hDeywv2EbaxC+6TOL4JUV?=
 =?us-ascii?Q?eWbsW2wy5yRoz5L9V8CCVxo3SPziKAHaWtHPGancHxC2dPPyYlV5yFJBT90h?=
 =?us-ascii?Q?zt+W5kJFTe9WZp2NNvVL1TOagbYrP1U44g2+RsXWgnCVWCGjnUEjyY7LjNky?=
 =?us-ascii?Q?97BBePX+kF5d7uesxjj/OPV3v3aqgM3XFulcDZUmiQ4PjUoPMK8gAkl+OnDZ?=
 =?us-ascii?Q?jz1zIx/3y8oGzcBBihcP8vrzT5TVSaXQty84HVOghgY9nO+gDeqqukHgTVvP?=
 =?us-ascii?Q?CdFC02hkwC0LGu507gcxaAdwkU996dpeSOPwnck347Y6BPEvEfR5z8wkW2Bg?=
 =?us-ascii?Q?HPZMKYC+q0D0uoB4cp+mTmAQ1ij/57urRMe6hEGF0US1i1tvy6U5vJZBcy0U?=
 =?us-ascii?Q?OQh2CwpTSk2bvyZjTrkaKekRiJxeFo0Jfu8RtuV1ttVa1w1w6s2h5NffnH/M?=
 =?us-ascii?Q?5+4F1dgbs3IfrGXgcl3f0dGrShpVuxnln0i6UDgp8XvYCA54yI8KyrSXEILl?=
 =?us-ascii?Q?f2Zktn/gOOO3o0fKlVyxClxgsSRylAVebow2lnhJWSNrE6d8COTov1ACwDOZ?=
 =?us-ascii?Q?PYFkb5iJLCyCT9luw6KP8oO8l6Yp8Nq86fXi9uCes5yjPQzDa1LMZ5teHXE5?=
 =?us-ascii?Q?tS0ayh/ryICdORbAV73xpJ87Y9rv5U26LDFFWMCL2AxE/ySO/6QmJWvfLZ4F?=
 =?us-ascii?Q?OMn0CBshd9klG8UuINaChaBpv2SGtgsgeGwyRX9YKoytT8NLGeb7oMPMT7V9?=
 =?us-ascii?Q?XZ6psZ7n8gFsjCPrvxuQeaYG9OXk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RZm4N2iG5bSsNzXCD55+/mf8MiQ+NVdHHJY6vXkv5W/dQIixL0IeAudv8UtD?=
 =?us-ascii?Q?l4GOetM9QjsnYX7PJupLIqx4IfHizMRdW7omnsMZNJDJrL+kBxCYEYiVKib0?=
 =?us-ascii?Q?iRmwk6FRNCLPLEnixnJpJlxMoIflJAKXBzdI+eaVeKcU9nzWMri4gEyoBFj/?=
 =?us-ascii?Q?XdijiYXZUQSAhuIlZEparuJdOZ8VZoK90sXdT2osUnLY5i173wRkodyPsON5?=
 =?us-ascii?Q?EXXk8go2Lj9LLG99PrNeZV+og9KPgAG9/NyAtlsKNI5TnaaVLJKAmZVZ4SZP?=
 =?us-ascii?Q?mxQpwA3QlkS7QvNbhxSpKgQZlXpB3BryDHQ4299vYZxgX9Kdw2m/+nGUiPQD?=
 =?us-ascii?Q?dP7y+DeOaFFz2LJFqJpCp6CV45uI416rSzYr2iOkjcWnUXALsB7NBeThoCHw?=
 =?us-ascii?Q?ccZQdUzYK2wg7OFCllFFntDYATRyu9vHwYXdfyr2TnDz6iChSXOIiY+P21XN?=
 =?us-ascii?Q?ZUQt45L3U/+KR7bciE+52PWk943kaGZr6wh8wtaJ0SXbbyqdl89YSBisyDHl?=
 =?us-ascii?Q?M4XTMEVycjtHFzydxz6dF7kj+Ciq+pgW7KT1FSSCcOeqYeBPaVeanILD6a1j?=
 =?us-ascii?Q?rz6y8MCpel9PZFONHcgHPjTzd66xOOeas2bu9qReddvqBTzIjBhMuAbfEAZe?=
 =?us-ascii?Q?WHq4KX6gJvj7R+aYsglO7bld9Qyf6aGsqLOSuj5BUhziAUPgoALYQEejgjag?=
 =?us-ascii?Q?cir6nCqCc98Vs/5CxDdQ+4PYp8IGe/JNYaWSwBLO0XLWgdJj+p7T4TnT5Wp0?=
 =?us-ascii?Q?7d2v8TkMHjaLzm0jbirw14O+xeN1TR95QloS1v2bYZPnY1aA4nrNTaFvL+No?=
 =?us-ascii?Q?8Fv498qViUexCGeXai+1JrwKKtuHPkocTA4xWg+LpGl8WklndhUNfOTCH2ai?=
 =?us-ascii?Q?iALJIyGd+UeDuf+HkPV8tZoOcDP8x+UyccNYOJ5U7rmufbslLs6dy1kvcgZ6?=
 =?us-ascii?Q?OKdbrTTJR9wfW3j1ZmImgC+26JkXpmKDHPxVaQ+Fw2OUTnKJgjP+HLTi0uAW?=
 =?us-ascii?Q?RZwobItKlOJOvKUtuXCcaGPDUqTiHA+HV3ZCKtLkLDVKWQwhXjY48vRCUvKy?=
 =?us-ascii?Q?ogk6+2mJ9dBVMccoKSvx2EIsPMpr4+u+cBPtVvFAV40p5yR1oUAbOM+x1OJ0?=
 =?us-ascii?Q?jojmW8Owf+60PSwfeQpYrUbW/7pkBn+q6/ms3TN3UDlfUxMtSuxpVIrGskpq?=
 =?us-ascii?Q?4ghXdVmUE994CdionULj9J800+nQ22ZoZyzlrnz9ie1fSEd/X/n995JdGhPX?=
 =?us-ascii?Q?xL2cagOzFFOkzfHSCaMI2cQUn6wyN1gveb9iYa0GaxZgWTlwYcDH7FnIO8mP?=
 =?us-ascii?Q?Q6ebsqAM4mDdOo83jgn2SuDuQ2QZMlOxb1s8BzalfvCybrJ/Qn0zoZuzhdQY?=
 =?us-ascii?Q?PIJdBfJi25n5K4FHUyl9lG2+ruY7IswegVErKNlytuviXzgqYlDvqgZ9SJjL?=
 =?us-ascii?Q?o/WdQDp5sJ3QMjP+qCGtULOkJmV8oLm+NY7LWmgeaCEgmcmWn/61I+RlUQq3?=
 =?us-ascii?Q?atzYnbASIHlmrANa1HKsbHcL/24qSetsMvm8EX2ZwefsNpK42C3EnXmZWFJ2?=
 =?us-ascii?Q?AWUbdfW3vNkNmLbh/+FttxMS6KyrAXd7eWZ2XJCzCoUGjh7kX/SIENc5PE57?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fNvY0scg3uABXqBbfJlPqEXXAYi5XTds2nCMKXl9GbiEEa+V6p2mbtfMYgvse01el7mf4cDFyuSg2jBTpjgkTteOpVz2WQcipJGfzCwn1A9FzjppxnnTilSPht6UncskQvSeJQ/JZ7EpSdMFPnTzQxIVnGEJpX2gzYrIGlK4NQcys9UdOSh4NXv4svzyfC18Rxrj59O0rSo7zASGWrfZsyKB8ELzYM9hsvLsGa/Not3SXmvZGiw1iQhM3Z2yJBc/Rc3YDpZtcvvPGrvcbj5eP124UpaphD+6muH3GL87uBxnnJY+ODqXj7Vh5E8gQM5XOJSdXTRtRTFpG7sBJ0SbOcQ5LOB/jvCUbeTBzXgsx1p4qR0euTMOsMGAv6kErd4Iddji9PfLy5KbK2ivmH3KhTjdlsvCC5kvKviy6Zs/dp+F2M1J0QqFXLbxrbIqxFKCKkE8RM4wTyUyCIu1amGhRvX54vOfCSOUxEVW/17yaWhaABPuZGEOcoqCFtSVMqi0anaABj1v2PDZbLIBcfVaKZOypFzFHCfGzT9oDMxpKDW7KkBYo1U1ZwT8OwDBS2IlKXoPsiFRJVUHFbLdThQavbQy7Ol4lv/9jUv3Nb4RfVE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ad3096-1b41-416d-73f5-08dd52224ac5
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2025 02:48:59.4334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cQkNqpDt85CoDmRGKmXgVnWueOpY5TGSol1y3MQscIQwmv1O3V2IOS718z24bbIJVs7WK0AmMrM+yt7E2JJJ2qJYgyaWcJwv2FOByN1dqgc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7389
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-20_09,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=671 phishscore=0
 bulkscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502210019
X-Proofpoint-ORIG-GUID: zSQNIgzj2BuQbjI8bGa7YHedLX5ofTXj
X-Proofpoint-GUID: zSQNIgzj2BuQbjI8bGa7YHedLX5ofTXj


Shivasharan,

> This patch series adds support for the MCTP passthrough function over
> the MPI interface for management commands. Also fix issue related to
> task management handling during IOCTL timeout.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
