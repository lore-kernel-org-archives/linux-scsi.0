Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86B038FA3
	for <linux-scsi@vger.kernel.org>; Sun, 31 Aug 2025 01:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756605022; cv=fail; b=XNbeJ4BBxyGZmRHteeP4dUGxXLeOfMROHgnMlHFGnGU1Ngj2P2npP7ZqT2999YdNw+b4bWZBJcv5MCOjrgjb1jCVUUVRfbqzQ6pKcufihRjhIpigTAwgrcsnqumWy/DpkF7ePhT04xzMkQwzw8xLoxt12IDSxl1M8v44Lugflpw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756605022; c=relaxed/simple;
	bh=auq8dmpRFPonitfjDWFHrbCYykUpAk1MYulUYBHOgfc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=HjdTAD2KIUcJ2JLz5HjlCQsyV1xsbJ6WbVYHqYz2TTy709HHXWU5Kxx3Myqj/MxC79m8YD25VmVwst21N5hoTOwtwsoAe/MQWhCnoR+qfI2aPJ2qAPEibjyCJx/49WICLeH+z/HXNejxuvX4D+qPofTtXoGIcfIB0Vsislc1nAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RNDW4jx3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=t30dhSsU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RNDW4jx3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="t30dhSsU"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57V1PjIH001518;
	Sun, 31 Aug 2025 01:50:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=mj2QixvK9pBqQ64kfF
	6GxfbZteGRETxjXZuHCF1eDSU=; b=RNDW4jx3/+Ixk+QthWMyuzpuDEJyLVQJ8M
	lGX33F3TE/gLcjAD9ErPkuTKIOITT6kYYm+Ko1m8dWJU9uWNxZtcbPS5wA1+v829
	E/CFa8dT4UEzmmzsEiu5edubRbVlbi4wKhIGPmNaCqxQLSr2d2syqy/vkWX9v9SB
	8DNeO4MxgpAO18iFDtnv/8NYvZ85U5iCbNJ2zEQSX7jbCa8Jvy2OtZTvgOYjH6iF
	VWR4WjisXvP7BvToP++4Z0Ly1fsyh4D14kcs67G6GpG5H+27fHFBX9LXAnPHnCzi
	WJUdeQrGzXzNFppYHZC2mLHuxyf7pvRAtDX+XVgKifSm1KZ3vAqg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usmn8m7y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 01:50:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57V1ZmGu025037;
	Sun, 31 Aug 2025 01:50:11 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2056.outbound.protection.outlook.com [40.107.212.56])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr6ssuv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 01:50:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sdi8exOI35cjl7uB+HpS9ZALJXr1WC61LdgyxVpTPlE6iD+Oh/oxC8UJgZyL7525epWX/7h4EJvyeTPg5KDWi7kEdyKKmY7nuQOoktpkQZjDSivzehCrFWqkgNvW6+a2SImWnNIGq+Lq7sg91tJ5LMPF0QgFiqtZ/mi8I5rnfWpNGqK8aLAGSlsRGloPVPUsPPI7jxiMqwSHJhpktTX/Cz+09aomSNrqZCJ5f2zsMW4qxxBzGNRWuzmDUBRJaYBLbUSnLhaclxF7YFr2Cf0KwY1rjCV4FJ1+xLxgATP+TRfi2AAii6ysLtUVZI97kz6z7EGdPy1zxWPhTydy2OklwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mj2QixvK9pBqQ64kfF6GxfbZteGRETxjXZuHCF1eDSU=;
 b=kKprn0akjnrgeVNHdUvazKnWTKh4O2ynfcKvhJQXA99sDLpNy+Z8F8kl7Ffvi6aPEIGQ8PdPbH7RNCnkHhLYjTb4ud+LyXF1iyQgblLj7ZnnypGzh2OZd4d322apjJhskmMcJLDqGIP3XPTyJ9iUrL+fowPyMr8qlJOnmQmiQzwauAHmmaLEWrDDS11kcWGCdG3tJMzmConxW0E2UhLYamVsYGLBRjt7noFQ7DPb/4o8hXxDo0GqqCUQTpZ3paPW2pjbHK562G0Tdxypc2hNAACwrurw1lMGGesSPZ3kDXsnGV8LnthkznC35Nwwp0cq2qo6sGYL8Qq6CcMRcbpe/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mj2QixvK9pBqQ64kfF6GxfbZteGRETxjXZuHCF1eDSU=;
 b=t30dhSsUsu4xrY5pSqcMaa/yMYRSZ3jeDIz590Vk5n5w5tV7jutmjrNv/zyj8DJxxxr1fJSAlRZlZSpKotm2RXkSY0qxkX+9mfRQC4MvEiS4yJts5lteDT/l//0d5Wm2aWrj9meBF7Y37bXkvA5npHEcW9nZCM5VABaF3baw86c=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB4557.namprd10.prod.outlook.com (2603:10b6:a03:2d4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Sun, 31 Aug
 2025 01:50:08 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9073.021; Sun, 31 Aug 2025
 01:50:08 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Peter Wang
 <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Bao D.
 Nguyen" <quic_nguyenb@quicinc.com>,
        Huan Tang <tanghuan@vivo.com>
Subject: Re: [PATCH] ufs: core: Move the tracing enumeration types into a
 new file
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250829153841.2201700-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Fri, 29 Aug 2025 08:38:16 -0700")
Organization: Oracle Corporation
Message-ID: <yq1qzwsdzul.fsf@ca-mkp.ca.oracle.com>
References: <20250829153841.2201700-1-bvanassche@acm.org>
Date: Sat, 30 Aug 2025 21:50:06 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0112.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB4557:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a174c30-53f9-4b4b-8ccd-08dde830b6e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D0S9i1TohgWcb2FdMgVkHnGhOuFsQP0WpsgyILR7amV5+OXUrCDgTPDBbHMw?=
 =?us-ascii?Q?0Z/FpXRYSIyvJ+SYOCFEWA/i1Gl0/dgutite6b8nVlH0aIMmiCwFkxnQmsFt?=
 =?us-ascii?Q?umSotK+eyTF9suc4/hYEkguoHqsR3crvH5Avr0cCaV/wXrg5A6GDYyQB4ALI?=
 =?us-ascii?Q?HnQuaKzQoihSu2Tc1KgrrXz6gjovvVP2P3Lgc43on/B0dmE8v7myo2wZu8d3?=
 =?us-ascii?Q?JIRhC7SC0IJXCTFqmIE84+WX1HlEPkKWSXr0I43MbCfgFlSJAw/Q3AQAhm+3?=
 =?us-ascii?Q?9RR1kHdrj1Y23dZ8gc4PkdI4B2+I/I4/d7QS5XL4l7Es677Ij5AXoovqd63z?=
 =?us-ascii?Q?kIqgfAcIyYU/fecV+suMBs9CMswwuBPEEbFnhHkzKsoXRVfvZIrns+Zm2ofk?=
 =?us-ascii?Q?yzTJOJDi3AiRVj4DZskDHUw33+L74TprqbnwzUkjhXQtr2QEasWRL9AHLySi?=
 =?us-ascii?Q?nA1jj3teKRHM8YF2sdWBTeYOji+Ka1b2wtyFt3a/oRMLPGf0AHCpHjKBj16t?=
 =?us-ascii?Q?YXn57ICvKT6z+khwwhJW01Ux/dNIt42jV+s1yDDy86wi25A4J1Wh7//dpA6/?=
 =?us-ascii?Q?+QHaNa7YWDoG+3d318yKT2kPAKEeiwhXQULmR3HLVOkFy0EchZ2rHor7ZUJv?=
 =?us-ascii?Q?k9xwlqWyw+qvXuIY8XagNdevarrQGz3yyogviB41MQ6Zn9uoGmuckHIYRZXC?=
 =?us-ascii?Q?pmBGRidjvNtfpYK0ahr3xuHweoDZwY465/JHsy9fMDXElgNfiE7k3W8+XsDm?=
 =?us-ascii?Q?bnHilMfpM+3v8RjdfZR0vgj5apfOIdibWvbv7Y0hravWM/Ci2K77mtysUh0r?=
 =?us-ascii?Q?3nhSSS8fSbIw0dFZ0BQjqkHNT4gJqe5eJ3RZ7wzB4MOaab/Y+hPN0j1fn9KC?=
 =?us-ascii?Q?PB0wZWvKMRPeibcB8ohizdWMtYP555t1QwDgyOBOZOJ1lPjnHSP4jXpHMPUI?=
 =?us-ascii?Q?Ik9do9hlnP8VPOhpv/GZH8MHWAW+fooAOdfp6mijv9FCz4kZHxejjJa/oHX/?=
 =?us-ascii?Q?YIr2a69N3bbJ5OqUrAyOtUtvfsJGCp/rhAnUqECmC5vcMZPgc+kosa0Kvhno?=
 =?us-ascii?Q?oP8aIz8/8Fo+0UhbO2HRBWRBC9cyp1vovSOcNnxKyvL6M9kIwA3QZGJHQXxS?=
 =?us-ascii?Q?kRVQte9qTqU3VNNoNHUHIKfwlXnBRx8fnBTil4WShnUOBA80x4G5uuIuJS9S?=
 =?us-ascii?Q?XIjow7iG8H3jEAGuf9SIkMRWFxcP0u4+U1kwoXMKTJFvMmlpRYKR8sneUbQu?=
 =?us-ascii?Q?i9cByKXizHYrKaunGiibO+Ow+TCa/69JOWi9VXVFvt6NNG4iI0cAVT6IyQCa?=
 =?us-ascii?Q?Q+kQMMm7o+0J6IWTyKHIWjRvshGnkVNnGiWVteuRjlFnBhQ7QJ1jYLxe8d0I?=
 =?us-ascii?Q?w01gwMyzt2WCGcM0AbpOg6aK2DxxcsO33Rh0pTP5ifUBQuPKBUiK16sSxIhb?=
 =?us-ascii?Q?VpnPrPOhavY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gxRylGU93fmaNbne1Y2wkqhN38vNruICXHi5CwoUKiNq+gh8CYTP/qMQEKSA?=
 =?us-ascii?Q?aEvEvTL0Mo0Q/ntEvIRvFig2CuECB1P5uoD9lfiOESjROSNsPqyhkcOWUn3K?=
 =?us-ascii?Q?n3tzUsbe/pnZXoillrEHHcRSznScOTw6zlqZgzVnKqlmzh78VKJJqGeaW0bw?=
 =?us-ascii?Q?xW+TWiEygPPlxBLJEWsAO9rfYAJgYKmfjd8Fcv1+g3HPfWI6VzOe8XXFn1KY?=
 =?us-ascii?Q?0/Rc+qb2USyHz7AJ30r63XeaOzwNLCc07qGaExWN1puumligrt7hAjg5wpfr?=
 =?us-ascii?Q?fVnx9FzVK9zARVbiFDV6AxABa2Ka5Kfp0S62MomKoyhSxOJY1Qpn7k20BOyX?=
 =?us-ascii?Q?cQyP6o0fVpp6d2+DqSjP7RVI0CVF85SWF5CfeqCZN0KhWxZr9JzuUuuFiTgQ?=
 =?us-ascii?Q?n89D/omhOEi/3b6Kt+917subHWg7ccyccMM6ys0N+PrO0FLF9RvWI97HIzJx?=
 =?us-ascii?Q?eRBwmqQYjuGYyk9FRwY0jpU5W2ehGGQijsgfizDzoGj2Xlu4lfL3HEstUa/+?=
 =?us-ascii?Q?2Mc3I3o4M7kDoI8z9V/ViMDdaHtpILRw326Dp/ra/vMvxH8W4rbgETSSchiP?=
 =?us-ascii?Q?qx4CGoY418aax4v7UkrbRdCTod12++24Dea/XURP0rHh0FQTH1+Db/hl3Ooj?=
 =?us-ascii?Q?5zjEE/vu+YW1E1K9CTR98dDzDee32HHlU32U7RHSOvwqUuEYpyxWDv726KBE?=
 =?us-ascii?Q?kKuZPtkIK4Uy3Acvxc67RHh5tBgYP6o6vDJw9sInlCJ3MpCSSOqxHsQ4TYx1?=
 =?us-ascii?Q?vzuSMDMjnSXP42C2XQEFZQTBWxPLMM/XUUghQbzZNcsmHNRmaVRHllubHUZL?=
 =?us-ascii?Q?Xws618okCK/3v/owMgg0g5XAaEZKcdPMF15shO4ApzWD7LC97jZs51qPeJwr?=
 =?us-ascii?Q?VhDR6JBGJ8EKUq+DQFDL2LWeAlpPnjKuLhGAULGw7649VmCRaKfBTUhjnGDO?=
 =?us-ascii?Q?I1LSp2kLx/PvqLbdcu1PWs7ctmwU8FhD3oeTcoB9WfueBuHPHL7STspwq2Ns?=
 =?us-ascii?Q?HjPy7t6NsQAV05xIpm/lKNzVto/p8z2Xw75tz/TrtVxh/OoNkrudKw+zCr69?=
 =?us-ascii?Q?5BcdsxnQusZiuSx69lZatJPv7Rq6sNwcG+tfa9FMX3mFqK25ISd1NxwTgbjL?=
 =?us-ascii?Q?iep/LZP4mXf0OKua+vqn1KS5ns+UnNbjbBRemiMrDHPa3JTmlQ6kh39o43sX?=
 =?us-ascii?Q?Gb6Sfmwdm+acVavKaFCZJZPtiExNvzbMyfK4lWWjHVujNI3WS6AL9GggBiJb?=
 =?us-ascii?Q?7OtzRML4Ww1GhRmdJWsaZIl5rPIk0lz9c+JFuU0hXCCZmVBhWPcGsRaaGkUl?=
 =?us-ascii?Q?Mxu24XH7+3Wmod5wmKZMgT9ukUavJJyeHsJl461u4KMl/TYJ+PBM8U89DbhE?=
 =?us-ascii?Q?8FjalK9t1QfrTM31SVXQEHqpqKo1rB1ZY3dUyKC8jZFgtxqOyNdPTY+HfVqp?=
 =?us-ascii?Q?Gxt9uGw6rWEiz6GupAxs0tprrXXxYNda97sMjoR7FlYp8CWLQFGMVOeIaodp?=
 =?us-ascii?Q?6HC1Uwvc123V/m7kTSuUx9OTCf8z0xRjy0ntYC2vnODWvrIUNJvst+6WHvkO?=
 =?us-ascii?Q?ANdC4WoY37HVVDoc5DrbSnDfz9M/NVww6dL1ty6j/UKRqHZiJd7jddzrmyF1?=
 =?us-ascii?Q?nA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+SWWCwqVEuM4xUTh58Uy0JiM5H7/eWWorqEGp31Jxx4ppTLUvVMl0iGEOvYi2gakOC+vNmkaM8w4VXLzi6UHEssN6HNiOYSh0nvmJkJOSqeKZVufvSDWGecRUmaueZV2a5o6OAE6sVuVLQ0xpOvHMnxYjTaOHbsE2lyzPEPm3zHxJzJ4tor+Lse/hwG8ttUQET2+HZVpXn/FWDG9x8ZcO+lrk/Y/IYFoylZW9nYEEfZr7oDxsRPtdTHVyywprkvUTRSbdweX6w4SkCZ23Foj4u94FOM7Ow9Ba1cInSEuTfVDpWTvkfKwKIR6BvqOvk9vLrZ/mzfBfzcUMP1qEBEuoqSl47ImIPHwPkp8odoiegMmlI3UYrTAQd/x4X9I72Rd+cgkveYZRT9/lfhnWTQ8KpWs5bga9g2zXMWSRdv6QGnnOkKcsATXkNbhpSpaf2i+qLG+hbnZH8xO2DreT/n2ihtTLawBNRUF0cWUiZOp7YbuvQWZvd3x6SXVKZLRxnT5iKEROFbG63+sFiNhBbp8NqGjg9vvIGsqVkUiiYqaTsC/VC5fssU+EKdxXXDG3jjf2NgOs1LLIbZA+36mujOEe5IkXlsXUQVHa+gUdtXvmFI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a174c30-53f9-4b4b-8ccd-08dde830b6e5
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2025 01:50:08.2204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K1LVaZWYoln1Wj1xbgz/ZrtuRtWHNOGUumcvs0QinoPknMtCJxUZzhC5Fk8P+VQ+nlcfYhy5UKm15hvi+1ibjNUaIxrw0m6k8YOC7B/VJEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4557
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-31_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=756 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508310018
X-Proofpoint-GUID: idy5DoqErcsev-db80ZeldGY463Zkob0
X-Proofpoint-ORIG-GUID: idy5DoqErcsev-db80ZeldGY463Zkob0
X-Authority-Analysis: v=2.4 cv=Of2YDgTY c=1 sm=1 tr=0 ts=68b3aa54 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfXxdLjT1iFNEYw
 R46DrlYQ/PIh9R5x5DSO2KUM0R4IjG9Vhh8BDYR0UQ26aOjBCkCm0wIq/5kNsYLnKNV0pqvuK18
 x/rS0VRL74M2jYX1gOOTqd5oZTmsTPuvjWenuWHRIH/DAte8tzG/VDoeMuWIY0A4smNaz+M3y+q
 +Q4L4Ds/STnk/ON9B3hY4w/d5idsM7LQYQPPPPwjZ5xWXNBpsjJQuYAwHif/4tgwr+z5pINJnqA
 9X+INCxBtJ+KUdhsNNcRYOW8G73hXmctEk4Mim9NiIFAhVAFCKudMrW2rKqupxNWAvVzYWgOJux
 x2R2spKMpyDc5iJzCAP5x986Rcp00Y0ik9WhYURbZ5lWII40UR+xvfMWHXheQxWh/NVYJPwffk9
 1eRLkDRz


Bart,

> The <ufs/ufs.h> header file defines constants and data structures
> related to the UFS standard. Move the enumeration types related to
> tracing into a new header file because these are not defined in the
> UFS standard. An intended side effect of this patch is that the
> tracing enumeration types are no longer visible to UFS host drivers.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
