Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352B47E105
	for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2025 01:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742261935; cv=fail; b=Q+21IeqI+rbC5EBet5yyk2tg11vhc5lxQnMamwkLcviBr1afs6RHou4YIlMX3WxLc9lMamaahn/mSluoqfPNjq3ZOKCu/SiE0HEw1maiQnH4mE2+7PQbTQ354drR9F7x9BDqqaRfjoYGPJLLhqGUxmr2XuXhh9ejfg6bf9xQj1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742261935; c=relaxed/simple;
	bh=VYbV0LS10wm3u1+P5/xTZoB8SMEHM70udcVzHkSmRNk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=bJGuw0vinhJiP6tsYcSR6rnWuzG1k2tfUsvoB+Hd6YNhGevqciXbOy20iNHp+/SJLZg+dTsnPxLtY1+brW8IkByOLuMQzmhHugXnfmnk/YopQ2S5jSLHqqL1wZwYksd0In9YYb3sqMRh9PMwJU9pox5Tlf0fRhUs61EEOZex2kk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UmKHNWJf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kQ/IKzZQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UmKHNWJf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kQ/IKzZQ"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLttsY022513;
	Tue, 18 Mar 2025 01:38:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=fkntaGGxgumMNviMhX
	Tr943JXkfQRNo0zcaf9ZZgM1s=; b=UmKHNWJfVnymL6sbfmgcTDrnuWTEzvPYMW
	1S0zfTgRD9esZoISR9+2+4Iv/awae/+uW+1O09H5bl5uSrQ3gDdpWa1rm11LNc4A
	ekabjXrslbVFQBlf1gEntR98eb2q2UrZ3FgpjusIq6atIij2tt+huEqGcCFUsnYc
	55+KdAVmCALwub/9/BLttkBRat7q6Os7Ku8kntdneMd9rqKde2THchvN/hun1JgQ
	CcMxSP19E6Tp9ZU9nNdSpLREDNZBXEdft9N+PuHMJXTYVCcgRlR1BkDMhUlb+IW5
	ZQjqm2mu+SJPZYbQZCAgrrbxj5enpeShaBYTfKzYVw33vMJQfo6A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1n8c5fq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 01:38:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52I0HnGi009562;
	Tue, 18 Mar 2025 01:38:45 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45dxkxxms2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 01:38:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YbdvWQ3hVmWVCrz7Z4jw62l3K3MjomB/+sYk93Y3QbxlxTN/6oUes15/70b6Iw1GMogR+O+/qRQ4AryDtKNTOsvs3Tmv/Pg1KSAHVxi+VSS0D52YBH99Q/E23aSCGAFxi0Wu6eI2oeFM/2oDBB4T4tMyh5QcL71hdppyQRgBEKsft/ipjbmZPuHb8rvqAQISzVNnSuwDq750P3P4E31nTSESyDOILO6+/uZ6cLf9o9MxFW2Y7oCtJJKcCC3oCpIzWnfUXG1wEO0Cwy8yafzt72yFVyaer0dDOMreblR8jGYyVHStdxxEAeKQbntbofkhSejZzh+DDpIUeZEym1F09w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fkntaGGxgumMNviMhXTr943JXkfQRNo0zcaf9ZZgM1s=;
 b=Ud9lYtAZk8oyR75ayEciy5eV3vidp/NMFfBEP62NLPgc20joF1LY+hB5INNpH5PbjKcK+UeHmLK3liSr69qg8M3meE2o8Cj0UiFEuWmEFEuJn2xIrPGaJlTsdkl41UXVKB21XgZ4AO/RVXbpAsvSbNpdRO4sP3ZGooOb+Gv9QD/F9n3vuYKLKvoLGOzyptS7bQ0wOMgFRB41HMpUiWZ48FET8bRt7z75RPf68PC37wsw2KDbTIvLWjedpXM6iHIljYksPe7g3m+MSZZwwlMzrWoeFGIVw/bNNvvg34S7grTch8fG3YNUAso5bekuy35XXbhfARGdSEzqejCw5xTntg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fkntaGGxgumMNviMhXTr943JXkfQRNo0zcaf9ZZgM1s=;
 b=kQ/IKzZQw7vhF6bmcs0QD0pEjVKm466XZtg1QWymdAEyvbWD8runcnRKM/cihAMIafjuKdgBchLpAHy/wrKoCnonvXQ6Lr0q/NmZNUwdlbVPgxSp6hoBFGTbQ3ynWyndLGDoSi6Xg9Gqe3AERaPKgTOSHaEoY3g1vlRNtyfPIVU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH3PPFBE2296547.namprd10.prod.outlook.com (2603:10b6:518:1::7c4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 01:38:42 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 01:38:42 +0000
To: Ryan Lahfa <ryan@lahfa.xyz>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Samy Lahfa
 <samy+kernel@lahfa.xyz>, vt@altlinux.org,
        chandrakanth.patil@broadcom.com, kashyap.desai@broadcom.com,
        linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, sumit.saxena@broadcom.com
Subject: Re: megaraid_sas: multiple FALLOC_FL_ZERO_RANGE causes timeouts and
 resets on MegaRAID 9560-8i 4GB since 5.19
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <bdptpiqtujqtlco5aopy2e3psmormwqwl2umwkdwygmnqlaxam@5cryrc7ehrcu>
	(Ryan Lahfa's message of "Sat, 15 Mar 2025 18:12:08 +0100")
Organization: Oracle Corporation
Message-ID: <yq15xk7dsu7.fsf@ca-mkp.ca.oracle.com>
References: <20240216100844.aabjlexbwq6ggzs2@altlinux.org>
	<20250309135728.3140904-1-samy+kernel@lahfa.xyz>
	<yq134fkpapb.fsf@ca-mkp.ca.oracle.com>
	<bdptpiqtujqtlco5aopy2e3psmormwqwl2umwkdwygmnqlaxam@5cryrc7ehrcu>
Date: Mon, 17 Mar 2025 21:38:38 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO6P265CA0013.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH3PPFBE2296547:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c9d77b7-3815-4355-d427-08dd65bd9d9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?360AQgFaKGgcrY6N20xl+WuqSQdqJwcK9CjiZRT4OnnPtmnJQrN4NlJ00BfP?=
 =?us-ascii?Q?Q4vK+gf9H+SJNivV9SJeIO2tD6TnS59KB7VdMMbT36vGZfje9CFeZJfhwLT+?=
 =?us-ascii?Q?eMadRe/L89CyqQws15WbKQCn1Pp9pM9LdpRazWlycjrKOsxg809nGi4MQYE4?=
 =?us-ascii?Q?wfc1x7ezqVgiQw4sEhacH2rFCuln2JQwyTR5vKuiFhXUgRzztTVxp+2f+MJh?=
 =?us-ascii?Q?PO0P1sr1Qq+pjOYdf8TLgB0BOPdl61PxyyrPjS1b9MJYqAFgwBLNVV/lOZiS?=
 =?us-ascii?Q?m5lapjrnj50gn9+otso9JRvHcQOX2xNtdPrYTc1H7eRkwXnEjUHG6e8yBt9y?=
 =?us-ascii?Q?fBWgdTvG4BQgJoUeBMJfH9ajMg1jg/Px+nMRm4EKdmz1Jnbl8XPRyigsUPwS?=
 =?us-ascii?Q?zX5jHQaufCRpYV3iv9atfW58TlsuOQ41lMQyUB6NRdnA1oTaqaJz/jrqZ14c?=
 =?us-ascii?Q?mByqPCmfSWk9qjitw8zQCqKTsTByjOTPKb1IJ6OJ4Wqj02N/lKPGf2tcMeep?=
 =?us-ascii?Q?6qGuqrlxvZsS6lbCboai+9WmQNQsqMrZKm2UGNJVItvIbfn8hyjxW8Cl0rJj?=
 =?us-ascii?Q?R1VLwsvHzBPmR9ROqwBYRJKPJKVv1H49O6DEJgNOPvkekx+OjA2BnjLdioi5?=
 =?us-ascii?Q?eGGKTP+u0lStWkW7dmTlB/en9F2hsa8ucEF66ZikjemhVy4IZTa7kJanfVnF?=
 =?us-ascii?Q?esFLG/b96Fo/Ji14snHJsGNrCW4ecQMFayuxdwXExjey5JLXqwk97e0Kqx6k?=
 =?us-ascii?Q?JuFGsSyw+eQrTmL9zKal/qT86ofNMSnNbKr+1ly/q2r0a3NzSGdCNrNa4lIZ?=
 =?us-ascii?Q?6388mVcV3ElByHB5aXWny9ND3Dp844WPc7BiED8TvSZRh/ARtsQZ3LJsaR5F?=
 =?us-ascii?Q?rKN3rQZZ3Z9BdmZhSFwaD+jOPg8pxp+uTDwQDgwzOuIZsaOy8UR0v8eVks7H?=
 =?us-ascii?Q?+IUvVZjJBz6JavTFzwi373IA8yfBSvQ1oG9BNPDVV5ni+LbCJ6JfyTyVqzyX?=
 =?us-ascii?Q?hTFMu1sQSQEdQT1SEJc2tl61C+FDKvNLsihKoMuE5Q+NicwLOsnteAef8VIV?=
 =?us-ascii?Q?XqDUk+d1p8vExaMuEFc57sa886CVs5wKKXNTL8HbRGe1Z8gWzMf1ko4PaLbE?=
 =?us-ascii?Q?Li1vWyeKjZJnYBBdwwWroBwcs7xhqby05aIKlMWyvikQXXrJl0l7SXCSA9Nd?=
 =?us-ascii?Q?UBbD3B0KnPZpqPST/deH6mDM/CVuw3x7gxub/bDd7eXNMEu/ORtdAapVLE/F?=
 =?us-ascii?Q?Rv8CIcyv+T8n9EER4y8K1RbH6SOuQEJwxVfUlGPPo5jqVEHB9tm7EXdS6OVF?=
 =?us-ascii?Q?dG4Jc/g+KXJYEXXg4+ckOsIEPKsIMT6jkSqzVs2YKWGeu8y0IckO0mzpNrZw?=
 =?us-ascii?Q?//KU6WwzdUH145/7GcVtg4fbYqEk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/Xyv8wQreuyiI8TQxuQGDz0hDmlSqWHeXu4GyajcshArtRa83FsvTjTfm2Fa?=
 =?us-ascii?Q?a2WJiOb84QSSmrF6qrmdu2BTlLUSd30i/r0F9iD5mjtDiAiWBXv8KzMlCmHb?=
 =?us-ascii?Q?nKWT+XJVg7eL7gqCOvV9M2BQlkUgJlQufIhJm8e4vHqAr5qk+Rr7GRs0etU/?=
 =?us-ascii?Q?agWDmuhegzcaB5JYT2Szydvhz7lSeAhlDUs9x0Ag52TrQQvZbjaqKM4DM3WX?=
 =?us-ascii?Q?FXLwGLlwO27xko+59ufOJVVUoAbQTs7tekzVMlUhI+h2q3DNoyUi3DHlyADM?=
 =?us-ascii?Q?UUK/X1mWIbo77Iv6uLxDsYt0l9vTRb/dVuOZ6LX1KQLmYd6l6wCrxhT2m0E3?=
 =?us-ascii?Q?SfHryfsX/Z1rFNR5Dnvi9dmK1de1jtKBq/799eN3Yb+vCohZa9zj+EkusT/M?=
 =?us-ascii?Q?8SVeTNpky8F6OHYiQqDhFFAWWYMEKVlb4blflaxqN6fun0OYSpIjZunCM/Sd?=
 =?us-ascii?Q?SaPkGyG0NJ94fnMVRd8c0kcBwYZvRsudXD7rdFgXW1sscozO0AqyPXEdUWVK?=
 =?us-ascii?Q?54Ir6r1qFJL+Yr1VZNwmoyqkpUGTKutmffPmTtkJvKUasI/R2y1xfz7GARyX?=
 =?us-ascii?Q?66LZ4zCYWfKl+JUYD0m5QSbQUPlou9E3PmmucQATPDBzHiglNfkcx3a9pNMq?=
 =?us-ascii?Q?uW+aHRbrfnGv6p8hh48gaSu4aW3tSL26W12x4+8UisjGsQDPZecBQC2WDC+E?=
 =?us-ascii?Q?zKgRd05qFbyjYK+7vkfdMkzOBVYmtmslnrsaaAO8/CB99jVBJPAS1GDyzcg9?=
 =?us-ascii?Q?tta/uHWjAFJbCXGmZ/kWRHnj9att4eJ9wxUZvFq8iTkadxgdsWwNLc1PbukI?=
 =?us-ascii?Q?viKvbo7APEW1XcX0J7aRgF9pxhlGlWMxQTyBAEAoGz8WfmJN0aYcuhN4KLZ4?=
 =?us-ascii?Q?Ay64ULofTVHU1Y6xEPmhzUEb8SgHzDsn0ZpCTcgei6ArFs6kB7DFGMppDV1X?=
 =?us-ascii?Q?YQlgGyPKO8SHukwKEkbDply25qZjiz+UGP+E5Q+d9R/v9L1CLMnErU1MRHUZ?=
 =?us-ascii?Q?78k7OV8hLRv6OlVYAiDEOn1HZ9dNdR+6C4VLnYQ1r3xBvHMp9aafGTZTRy9a?=
 =?us-ascii?Q?uAhrNpydNxutlTXsZKY1F1V87eFe9g9ZHaO7yj/IvLNbJxCR0RsilKR2tIaq?=
 =?us-ascii?Q?LomKSYRGKO9oCXF1JjHtAXt8F6AGehPAR93szXqvEC3cwRqc3+HMvtK9HcVF?=
 =?us-ascii?Q?TTicEVy9I8MAoTXgwPqGfCZ4n7xv4ewbXQVR7BpwR5cLLhib5RYOpSYfj2dk?=
 =?us-ascii?Q?wsvi6PELdMUDdSBdjMVoPoqBnciJ4IKYY5MAgMnqiY5NJNcnmdLwBK95tQlg?=
 =?us-ascii?Q?Q6tlVf2xOvuuJCQjZfwnU1mP1H5uCEeyeim2Y5qeKPW4dbUElMl6y5XX/zaA?=
 =?us-ascii?Q?17zSNdyTUTQI4HSQZ1riAYTeTLFFzINGUAIYEXDbcmEjZDdXDZ1iv6mv4QI6?=
 =?us-ascii?Q?wrHomp4gRNTMmKF4rQuj5lF/xdGus5eKHqlPW5IVe/kc9Hu5zylA1JZwvHCw?=
 =?us-ascii?Q?2xBl4UmDbMX11Htg24zmvF5r6I5plEQ9FrXur+6D6xyabrhZuLO5FMOgSTnu?=
 =?us-ascii?Q?eEmdxdZzifagdaF7JfG6CpJEd5FAe7cQkD/4qUJd98q4ZLiDL8EZtt3A/VHn?=
 =?us-ascii?Q?FQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rX45eaECIRiN0C+OuLVxDK4KYwN2UMYSmQbEhWxfpmSI1ge7bcEGrHPpsFqcyOgbwU2CWCiO6pbJugwqymS+smlQTMU5D34Anpu6EEvIo58e28haqiqo1OVosI/GXJRXEc6aHtI7ucAPaoGICX+Ly6kK4pUdyaKqD9qBv7p8ZTuPU62+YRrn/Rk2o1ul7uHJ5SWFzP/4G7rmXVHeoRbxgl+6chFCQoKbxWlvya1yLKFeHivFQuMHMkRem1L1l7vkWDk9eRG4/wvXh3P+juU+JKpH9cyZPMlNLk/RJut1biGMZrt/2g+w83bn4aGOneVaX7EjzGN3HPw3dDoXjkhAgesUsXdBxTARk04H5rM/GGOfUAFVzwantboJBw85mTs/M8wl49ltMvaQxeU+Fv4fs+6b+zDStemLQMUl9BxWWLmFQfHLxoOBPNY6plL66ytyi8hynQSgorxGWjHez3XPAnVfNArr/MZEqsBBafH5f12XxsV6c8yC7J7Zv4YCQc0Yf/SPmMtUR8+l4UwrMCKaWvHy/5mJ23qse8ojkNqLJT9DCEUARqxBcwxkLSrADyCQPDk6Ad32otqCiO6p3CJ/nxGenrNJMT2TWekUN1Yom8w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c9d77b7-3815-4355-d427-08dd65bd9d9f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 01:38:42.5340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ofWhUW8ON++Hn/dOeCo/am+ifmftLCuS7iNF13FaNFGYONSPDM4dbqmt9fKATB3n5B03Vg+3Ipskzp73VTC0NEJNnG/mxq4EI+Qq+qmEqhA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFBE2296547
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-18_01,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=631
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503180010
X-Proofpoint-ORIG-GUID: 6ULitIcKropIZ8YCFIfp08WdCod-fceN
X-Proofpoint-GUID: 6ULitIcKropIZ8YCFIfp08WdCod-fceN


Ryan,

> Tested, this works, I do not see the error we reported earlier.
>
> Tested-by: Ryan Lahfa <ryan@lahfa.xyz>

Thanks for testing!

Broadcom: This fix never made it into a driver update. Please submit a
formal patch. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
