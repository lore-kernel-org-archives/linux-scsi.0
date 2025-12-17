Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BFC72634
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2025 03:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765942804; cv=fail; b=aJkgSQZ1E3XdQq0h2xQpo3sN2/pH2s15Hl161+E/nG4YmLTEdKqsWfeL8SlcJLLWHr2Zs/m480OkH+x4ypPhencqdbGWgSsGp/pYPMQed7Gdeqk4PBivIYKIMzuKCiLWuAz4eDQfpuDK0xu8HtXpkGFxBINjUyQVoSjGq6EnSzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765942804; c=relaxed/simple;
	bh=knxlC4pcsZR4wIcdDRiK4WE7ySZ0NstQTuSM/L/NkpA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=b3jdsho8nw0IM3VFbnz1440eVmjxuJ6rDzEQ6ibqWuK6+hNeaee7ln+/lJUhKhyuYrhSfU5bo/+425+6s4lfTFDCpjAHCpg1JNRrX1HrpLDNY3lce53DFV0FjK+fzGFDL882xOPBD4RQvzwrLVvk4U7YIaROpAZz34AI3KcNXAQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KlWqZGs9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QdjdsgLV; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KlWqZGs9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QdjdsgLV"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH0uJb91588720;
	Wed, 17 Dec 2025 03:40:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=a9ClxIhy9CDdI3gKQZ
	mXaArwQJwVhDYYnhe9JQ/Wu28=; b=KlWqZGs9G69kn/OlK6oAwR10oH54UxZnou
	Gf+eLeS9kqm1h27tae9kqchqi4jUYxiZObcEJswZuCJzIjfPeO+VEkxj42ASeCr8
	RYBPbInImEAoJhIA+0+XCc+KsvQz36WCBxW+S9jHIWCx+6bFYjGVcsVouconyX/e
	NB3PFSWgJx8n8k6uzgVetQNeb24Z0nt8vrsOZ4Ugc8uSVAUb/+JJh0Mk+MUvdlhX
	0opzCqUE5pYpKBWpBORDt07pkLpAd1lHHhFGa+FYuNcASyfew/J7InMCzgGAKQsU
	tzWskdoFjrmMIlPD31SqOIqY2ByyOoeSplY0ZJ3TS9+WIfWAlWhA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xx2d4qd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 03:39:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BH10At9016716;
	Wed, 17 Dec 2025 03:39:59 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011065.outbound.protection.outlook.com [40.93.194.65])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkmj1jr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 03:39:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y73+X0lFqgvhr8/10zD9TH8ttaG4xtU2OzmeJlbFtpE7TIKh5aNk3PwCBkeHD7T3gthqCotRy0Rn5Sawv4Bp4BQYWmWaKMMOoq3JaOD6ThNPVOVm2MlBvGM2kFeQAJASYIzOg2glEt7gEgj9mQYFL/mmFvb/r1Ylkq1vvDywqosjQBiN8niy58nND4bAcDxtNne4v1dzPX98eHQWa55V8c7jOtTMWJwWpkMTFko4DfDdjlLVQIYUfElhK/tn2kaCxWFZyNgXUloWwDGZpA1ofzzgtpXOBgdM3R5N71x8erdFIu0/fUWAMa6Af0StE085nWO4bsG3wTMRr//XRF/fxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a9ClxIhy9CDdI3gKQZmXaArwQJwVhDYYnhe9JQ/Wu28=;
 b=X8IdQrJj4vX5OTzZTPnRcnFY51dzAzp5Fjotval+BXP1Tm+8v7p0siU+g5PSNRfLhi0ssrIKyXhbFMRGV/yaEi9cyHgYY7ozuK/0mDOeDzeKtuLg5irdKqBKbYPEuYB0tzqwxuk9FI7LHZJ0KvotRi0flj29Chtdy8sknNFf3e/b+pF3ChCPsWf1ad4H/mKGQemJV6By1H4vlQOJlqGMJjtP03ma2niVX7pf8ZwBP5SecNqHI0qUAaM70FtSrisOCR4nxBRtkp+rUy4vC4DQAhEdkuetx3Hx8R0RoZDJjoKWxydtayUGHF45t0B1zNsBucFLj24tcpBRY+rtdHJ7Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9ClxIhy9CDdI3gKQZmXaArwQJwVhDYYnhe9JQ/Wu28=;
 b=QdjdsgLVTNM+u9q2r2Le/JokoQXBgn6rzJzau1c/GXm8e3hON4nlwTWAITvw4o3FFt7WoblTcOXS4KPfa2s6VrM3jO3Y/AJFLDsHY6DaxHAfIGAgos7J+gKdVcOJzCb0rvck6ot+LX8tInox05yJzfR+ok7bweNTTbR6HyTT84c=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA4PR10MB8471.namprd10.prod.outlook.com (2603:10b6:208:55e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 03:39:51 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 03:39:51 +0000
To: Nilesh Javali <njavali@marvell.com>
Cc: <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <agurumurthy@marvell.com>,
        <sdeodhar@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>
Subject: Re: [PATCH v3 00/12]  qla2xxx: Misc feature and bug fixes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251210101604.431868-1-njavali@marvell.com> (Nilesh Javali's
	message of "Wed, 10 Dec 2025 15:45:52 +0530")
Organization: Oracle Corporation
Message-ID: <yq1o6nx4w3m.fsf@ca-mkp.ca.oracle.com>
References: <20251210101604.431868-1-njavali@marvell.com>
Date: Tue, 16 Dec 2025 22:39:49 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0140.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA4PR10MB8471:EE_
X-MS-Office365-Filtering-Correlation-Id: 4639f0e2-7c96-40ba-341c-08de3d1def65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+xmVN2QIUbntIBI7qHtCRKcAy60/VtU3zisef/n8ETsNjkluKO/zHLxMIcDD?=
 =?us-ascii?Q?Q2pHlVDK1l1jtLgvoVD2dlnn5vUDhkm9ykX7hQqj+9DrZ9zggxME4KmhGNIT?=
 =?us-ascii?Q?6MUmo6SF2kY/IhWyI7ZWsayjXwo5MaQ+jIg6NffvKvFFadBwKaY5Z5Qbq0hY?=
 =?us-ascii?Q?fjZnmfTQS+PgMCEv2Hx/f27tm+uybnlpx8y5nYI6wbnmSFC1AOiUCh71R2KC?=
 =?us-ascii?Q?Agk2tdNPKH2hLoD0TJrzYeofUPRYHghMyuCGln0eU9OAOrzeTARpVjXYePIk?=
 =?us-ascii?Q?AF/Ot2dCKPpXrQDfFX2eo3EeqLcpo7dWHQa4Wg9qGbvW32C7l9QtmGNrMTj6?=
 =?us-ascii?Q?G4z+5Y6grXlZhmkmX6swkQIVL1zydTO6bk7fC1fwQugWHcgao+WjNsAFxOcd?=
 =?us-ascii?Q?ZcCvYNlC/E84wdVZPQv7cppRWLSYRoXrZaUKQlgL6wUc0mUxdO8940fLrl0h?=
 =?us-ascii?Q?hmZuXm6LWv7lO0jHT7ICaVU+aiAU/7naWf3eQbq4vvBjs7nccp+zrYyVl59B?=
 =?us-ascii?Q?CWML8mmhe9nycBu7pHzbq2+3+9NrlFdmDu1ImWeDZ+iJZQ93fQ73QnOF9/n5?=
 =?us-ascii?Q?XRDISNPcdz5GqJy34pxo+rEUVX+T77Ko+99yQk38wzhIYBgL8dGT0uhOp17i?=
 =?us-ascii?Q?RvXV2A4LP+tHx3FWRqtV2ew0iQyo0ZIop9g2FomV9YiBqOlX0S5ejTP+/xO4?=
 =?us-ascii?Q?oVMjy0OmG4bxiVSPOocXg0E6REl0sOlEV5+3CzuWWu1wDt+6SQ6OAm7xsAFZ?=
 =?us-ascii?Q?/Ag5PiwwpbXHr6jKDRhj40RY732wZoK7dwfZaxDVcvCC9Qv1wdiJicwVSWBt?=
 =?us-ascii?Q?J5wwSDLPN0xl+7DF3wLu331D+hh94wjs9ZW7LLh0aGBhKAxCaG7vGFRm7jYQ?=
 =?us-ascii?Q?DnPz7TEn95sOKV6azV/qUWLS49z3CIymT9UUZocpYRv94G8HvG09XzsO5Jvw?=
 =?us-ascii?Q?nIEp+5CUsTqQViOHj/EgSuL4AhSzIlJQFRTPHB04bVbSzqSzfdMAcAbFK4TL?=
 =?us-ascii?Q?UPypoe028a1IMVH4wvHiAcHg/bK6BpBWwA+xnQwdKxMySqHOwBHYMhaIy0Cj?=
 =?us-ascii?Q?QrIPVXSdARMzVQgxNhBhhFHGaB5BvYPCgb7NqUKYdYyBXbkFki5+mB5iObVZ?=
 =?us-ascii?Q?Q+xHoq/nWyOVAMoYUTQkcty2CwzbnANZksaI8F/ma/6WxM2Ppr0RJMlr+JFA?=
 =?us-ascii?Q?KbPStyLHgw9Ca1i3OqjexUq96HOxYyn5Oq8cEobBnuwv+R5vBpUlbmUMcVmY?=
 =?us-ascii?Q?nj3xRQWUTTnTmYlIexecX0S5dxBb66G2DjrzIfbJBR/7sOhKL5nRqtHHouHm?=
 =?us-ascii?Q?+4ST8kYJbipXsZmR5xHYnnRZTgwTufZIJ4TlHPeJoL7F41xwtAmndViat26m?=
 =?us-ascii?Q?wUyOP6DnUja8WeNv0pseQw0+M6Qzo7sAq9ZFBaypY1tMEHAmPTto8H/ilsYU?=
 =?us-ascii?Q?6fMA6AjagE8BUgdQyd7xEepB5WN803QX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g5x6H8Q4+gudzS4merHGg1fcMIl1Et/FChqug1DfZCQpFjKqmjiVU1KgCtqG?=
 =?us-ascii?Q?MobwmO4w9DaBwlWkZi2egITeM4uWqVJGUtO/bllPVaW/JdGDqaMOZ+BvwZeF?=
 =?us-ascii?Q?nhhAVNxIxZsDiPQ/yppGe3yDLFXpXANSqwDciOaTeHzcVXfb61N3WQdjlynj?=
 =?us-ascii?Q?s8Hd2+xxTDV3tnDc8p3+hzaLBhZ0AXnLUhGeHcSJApGYbR/5nzAA/+1X6W39?=
 =?us-ascii?Q?XQcJuTZzMhyZCRu2Rtl/Ii73QOMqF03hk/kdhwoHO+lo/EAoMsxBxnq3RLFI?=
 =?us-ascii?Q?zym12QPa6U+HcYhG3O3OcX4Xb0a+GtdDk7iaC0eguvdOsyaBSKMrdLX9AG3V?=
 =?us-ascii?Q?rA1P3lLgLTa7+y6TvWOVtkSY0ssrUOGsWC1cGAl3dtY7UKnBaIPxkg1us6tX?=
 =?us-ascii?Q?RSKyQgVEp0YpVGaIXjyOG2AqL1m5HuQuGjJqONArt5SUhBgH9heaSvGN+1Jc?=
 =?us-ascii?Q?PHaBDaTH2V7HFrvML5eyd2Q52EXKCYred74hM370JeKjoJv9MFXg/G0hxClS?=
 =?us-ascii?Q?94iQ1SVcF9g6XbjR9TZraJ/xGZLP33pR46eIgEcQk+jWkb/QShRxThDn7ZDT?=
 =?us-ascii?Q?m1Ga3CBoZ+tXzijwUCKRJ/scc3mUqmjDozF66cjhEO9mWsWieGA1hR/l08V9?=
 =?us-ascii?Q?LnFIbsXccRmFkdI6OkspBa038uWBacGAZDZDXAyYBOTY+QtwgWUcdHIwtpQ6?=
 =?us-ascii?Q?wfm+wj215OXGNcrCAQco1WXtazIOD9xz7xk/yNVPtWrlw1Rf8swp30Zq0NJ7?=
 =?us-ascii?Q?rr7sLZS+QCkzhcaA8zA7Z32w9S6nucC2OtpJP/uzNuPrj7yANirHsIKCD2NB?=
 =?us-ascii?Q?R59dlvZgfKsy9a4bBTaUYAJYSvnkQFfXHfoCyUAb52++xlQP1uvGfRJt08Ne?=
 =?us-ascii?Q?Zj0R89p0BWkxmT+dvIRmjtD/9M0u/2YPLzJJ7TfTLFhlcOZH49+IF6nSGryX?=
 =?us-ascii?Q?stpZyfpwMNbIoJQUgrs3DrW4An4vPigMuqvrQ8xzCGhrxv59SawNeb5Jiem6?=
 =?us-ascii?Q?sa8PcuSqOfCxe8vc3mGCvdab+c1ARfZBqY2A6JoTSLWexdc4JKzkc2WNN5zM?=
 =?us-ascii?Q?MeCLucH0G84ckhJOPRzR/8g4GHC0WUtRQes6vRRMZJiECBdaLdhxIgnIfheg?=
 =?us-ascii?Q?DGlb4PEQYN8AObZK+aM5H8UeADqtmggLF5pa0I1DszoeF1dWHqMwdMB0c1AO?=
 =?us-ascii?Q?kzfCiHmVOAWkpWmN0CbtKdVgedcA7X3rlh8969lUcpAO+u58zMdrEBMyinFa?=
 =?us-ascii?Q?iDpvwDRdDFKjmM/bALJU8GcU0wfktjhr9TSWmEpN8AuCWiQfjE2/Rz89gArC?=
 =?us-ascii?Q?Khayz6umD5OJp593omcZjCVZ8l1qkZeHR0AeWd0Moe3/mEy18li9QGjOsHSy?=
 =?us-ascii?Q?S+dAqvLckd98+wIb57iRJU5/6WW8/0vnYqD2MTnrpSq8nwRbx7KLdn1CConO?=
 =?us-ascii?Q?U8Ns/He87P3EimbAnDTCazupMIBrdrspUBBtvBulikwxZMZFLMO8HaMwkWpY?=
 =?us-ascii?Q?ubUOeQt80WJKvq6jql1PxdK048n/lFrdehQlf+XaanbVAOco5hWc2kZXR+dh?=
 =?us-ascii?Q?4D6eu2gRmmC71JtlfmNxrIDgnmAX7SMqXgnX1xWrCMuCmbCkerFds7ZR7/Gw?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ej9axKblg41wZ+SDV652z4u0CI0toSwn/AX/uhfC4RgAdd3u+EfFadaDal/ODueM4F4+EL7mLCdu2p2lTSDdPI8qtULR7XGB8f+sEVUz9zB5nVp4/Zrvws7BHKmYF/2Lh+2BuUqJh04n2MdgpNBUWod57bAoCfVOKfujE+sBgWs80o+cuZC4BcKeG9HsAokeYfWjUKWTa6zJJVJFp8Xi/F6sHc3GfQE6mdyBtviitabelyJVk0xldGVaY+vcIvStem1nZANq81xiSZZR2Yr3fUhMGDFme31IQmxjsQJvgYlW/20Wjh04cQqxAVSrJ01gAajWJZrGGyx7f19HQ6kJ8Pil9yjtfonalqujBHR/mVXG7pdgWcpaeBDTqww5KrA14fmGttNIfCh5DDChCliUYyYLAZWtp3Qidxb2WXQs2RlgsBCmaMWJXtLFz8rkNeSJ3e2RuN0mV4wjTweM7vjsxh1yNkv6yrzB27j2a5GklN1O03QC1xaYrzLN3KuH8fT1DR1NxDWbn2TFdSoOvDMJrU/0jzJ8rK8bEJwsYwD28PJOvpnIVcmM1rdtZlYLrIenqDuJi+6P54JhugHivkHVC/yCmMRdXIXomj8gp8iRpDk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4639f0e2-7c96-40ba-341c-08de3d1def65
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 03:39:51.4173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UdZUJ+dXnDOB+xMap4QcTcPudzpjjUDI9odrIs72H7o8J7AhG+cNrPAp1875CZcDdnZtavc/spOFpUWcgCPRuF+sEJmbYtympgrTXYUbRkg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8471
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_03,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=749
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170027
X-Authority-Analysis: v=2.4 cv=B8W0EetM c=1 sm=1 tr=0 ts=6942260f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=4UmxapGgOvRovlyjj6YA:9 cc=ntf
 awl=host:12110
X-Proofpoint-ORIG-GUID: lK3JVZKpeuXgOJPCzMKhOJGiC4IFaBSD
X-Proofpoint-GUID: lK3JVZKpeuXgOJPCzMKhOJGiC4IFaBSD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDAyNyBTYWx0ZWRfX6TxoR5jMWnYR
 +gk1LjWTVc3l3rrDf4t6AYK7dGEG4yKRT2Ud/xUBlq253+GDY+Xz5wG1j/rA8fZr+OXWuo7oEy9
 evIl+ve4aSINGNo5WfCbXKY82k84Fv4r2+0sCHOMArp+ePyDN8hpM0EyhyeaeyCa7E5C5XCfN8c
 pbHaMDD6xQOLDeQ/k0Zg1bUamXl0B+MhMb3iJd2aToXYy03+6LgNygDqM1q2ivfM8ZcIMW1uINp
 23k5g7RpKh04FE96f5eAUd+R37esK+Q+4v3UqYLZ3jDQAlNtiTp5wzgvnqb4isbEKjNiZdj3HqM
 h3tRjKItd9ZeRyNgjA8G0FEGHYuAxxOiIo7TLQgGiQ+jrahafN+rcKfqElEi0+dlRKHdpyoud6u
 X4hT6suKuOFuTvJyD7drfq/Li7Uf5Q/foIwAe861ZBPPTpGWw94=


Nilesh,

> Please apply the qla2xxx driver load flash FW mailbox support along
> with miscellaneous bug fixes to the scsi tree at your earliest
> convenience.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
