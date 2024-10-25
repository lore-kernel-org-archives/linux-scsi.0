Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE00524F
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2024 18:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729882735; cv=fail; b=mw/xwamLsSrlf5cXQNN/QJR+4NxQgSfAWjw4k2hPuUA00mAeT5ku2akuic6fkXSPc2q8MbDjjWuO+snwpNHJSg3Dkoi/iRwbq6z31j3NHSCfuwIKys7v8gwTGanYml7cTAkKehElKYha0FPyBWNowFRpUQzHXoG9h2yiv6ANtbw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729882735; c=relaxed/simple;
	bh=MExdOtfAxmEgDDXvH2QBYfQ3EzKr+MbIioL8NgEV2QY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Tl8aZoJ03gKlTwP7n/oEAhhMGJOcHy2GA6U+DV/2GZZJultBnfeBkAUHeq4iyH4xNiysH6iE6iCPFv6CN6IB9fdUFNi7Cni1aa3mgB1PvDSYYeJr3p5WQ1pc8VJzdMcWLi4PrZM6b9GuvMhNCaILx8Gh3KsBRlPznINiSuADb6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=meo+wUDO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=m4c/A+OS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="meo+wUDO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="m4c/A+OS"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49PG0Wpc031979;
	Fri, 25 Oct 2024 18:58:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=BVXqoCRDOQ+ff1FNWD
	H60IJyX0x+adBinPJ207UwTx4=; b=meo+wUDOgF9lVD0l8hvFcZJ93LFWLIlDrS
	2cds4ZxI9xE4JyDOO27fnpoF3FJPzXSDTzkD/TS2bPkjUjOf2pDRgMNqdSmb1gE9
	gNQoEv90q6iF0EH2GBzPMglf3d3ifP0cM2Dyc/VeMxmhLh+PPZCGN23TfoGXU7Je
	IQs1X7lFckwDB0NZTGyCUv0HjnyArl+RmZJbZ9+VGqG190COT/3bf/NyAdC+nOGx
	gyviRruCYBWjbdUa8FXfUyPq318GK2Ns4IbOIesgJmxT3QvKdzYX4jC3BeTE6c5Y
	vdyTASW3ChvTP9x0gc8XAbYoREDDOI3gv4kURoQcBCo2KqjwgLHg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c55v5q00-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 18:58:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49PHpJ6a015671;
	Fri, 25 Oct 2024 18:58:21 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42emhcnand-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 18:58:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FrctCU1SoSJ3rlZfkvS4fy2L8m64PKk+c/mTqOSEI10hjaT4gQhk/9riOVckZcI+TxAk08jl6unWTw54yNnV8phSWrUB0pQKJazXobupstVC9Hf3Hmek5TQY5foO4yCTfPpqdAXjVoSVErv/iojzT+gGIXIgVXjeo92gvlDZU07ZL4yoA/y9oWLdFh5JUGsj1G1e/pepXTb72Jtkdu70ZSGh/xVvE32dA05fg7fpLM4m2Ykevrrhk8NWl7feKUlMzIL9syclPsv6xZtzcqBHBpCvY4ApA5PprzeDIMSp/pa3F1JevFqBAh6gxD9UKcgH4k2myqE5HARDJWUrfOaqDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BVXqoCRDOQ+ff1FNWDH60IJyX0x+adBinPJ207UwTx4=;
 b=S13wGf4oPeVV/HZ7PuHDnjW+ALy6ZCkFZac5XY/lyw4KdJDcQZTqujRLwu1aN6mlWfUf91bEEMwwiwLqAlv0dRDFRELT7mwAKxTgw58Y+0TD3eRRTapeqVNQOn4yD+Hs2BJ6ycX96FBFz2BBrCA/QY4FKwY3otMt+hKXXlGRzza9CJL37Y56VytW/QgYP04Nk6d6JHZ3ftYtyePvd+yJjl7+0Q4Ozs4q19MaDWcEWAhEphVd1OCUrzKDJfsD7VhioQ0/gyg3V8qWPtjjXmNpXzqQOrzpfh/t1OKwoipAPI+wREdRWgGAKfn2d18Tz1CY9hJf7Z/wDdTwyQe1LUOu/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVXqoCRDOQ+ff1FNWDH60IJyX0x+adBinPJ207UwTx4=;
 b=m4c/A+OSnT3E9WbuHmZBytrtzs22Q1iE4EdcOvA7QRvjFGmTc2oZq/dm2BdgDPQ6pVVsrmUbqyz/oFDs1N79BtL06Llz3X7Sr3C06usK2kcBRtgzL5d6Do8B8YZ7KbhAmtWDUKKx77/pQ8YMbNaNZzY/1zrGiDOtWUFH6KA5u40=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by IA1PR10MB7485.namprd10.prod.outlook.com (2603:10b6:208:451::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.17; Fri, 25 Oct
 2024 18:58:18 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8069.018; Fri, 25 Oct 2024
 18:58:18 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Yoshihiro Shimoda
 <yoshihiro.shimoda.uh@renesas.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Avri Altman
 <avri.altman@wdc.com>,
        Andrew Halaney <ahalaney@redhat.com>, Bean Huo
 <beanhuo@micron.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        Eric
 Biggers <ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Make DMA mask configuration more
 flexible
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241018194753.775074-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Fri, 18 Oct 2024 12:47:39 -0700")
Organization: Oracle Corporation
Message-ID: <yq14j50f1s0.fsf@ca-mkp.ca.oracle.com>
References: <20241018194753.775074-1-bvanassche@acm.org>
Date: Fri, 25 Oct 2024 14:58:17 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN8PR15CA0067.namprd15.prod.outlook.com
 (2603:10b6:408:80::44) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|IA1PR10MB7485:EE_
X-MS-Office365-Filtering-Correlation-Id: a7555fa1-49e6-46c4-2594-08dcf526fd13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U3uPq1gORsh0uRRa4JM9VD1kQaZt7bdo4u7C7CuOWNx/acelgaRXr0u0BLOA?=
 =?us-ascii?Q?zXykeEcOuiwq9zbRgprBuGvtgET2VJ8s2vF1IFnosHMiq9F069kKll9enbID?=
 =?us-ascii?Q?YVXek6M9m/vuxTGoCo18EPyQL6zSmwXet9MDm6FxOWHx6Ajw6KdCEXuNM+fR?=
 =?us-ascii?Q?8ynnkDmjUOPKKomPa0dgQpu9XRhiT1iyV6BKgmQY31gCrmAZNQXwGDkasQNz?=
 =?us-ascii?Q?AO925FkOk/fMDDieHJFVViTOW3OsNOsZpl6HIFYY74yTs6Q7B83xG8LyoEU9?=
 =?us-ascii?Q?OAbtNXgayOsGTY97F1M3qJdypQOEOiO1KDzcJKENp6FyIo8WtmsSwqTErg+C?=
 =?us-ascii?Q?1TOZcEbzjGmDI5uvplgTAdh2UP7jlkBAfVVwylGLXMO1yp4PTk+A+OIxnjsj?=
 =?us-ascii?Q?W2LJrUs3r3PbdI7XYqsmGg4lwfHRyrG8lewK7Ako1xYkPwq2taBz1Iwh26yK?=
 =?us-ascii?Q?RXjBy9piqmpKmy7Zv7mLKqtun9HuhLEbUU78iVXaGapa4PHkqyTj+HiROksI?=
 =?us-ascii?Q?+2Rg0ys9RRnVj3mXxaPQkIZy3no/3YMbYS7vG7b3rEjiXvJq1KSu3RcKeafp?=
 =?us-ascii?Q?yIev9m4OMPvjogxuF3SlJwz1z7a0YBqG/iyDVQl/uj8yAkFjBY7aewqhbD8H?=
 =?us-ascii?Q?vbqWk8xVh/Nk7UKme8bfLfJwpry3Evax7Q/0pMygLZgDO9p284Rs/H8zvHlC?=
 =?us-ascii?Q?Zr1AhNmRAUJhvQYhP1VW/77ZcFBWxUIWLi7/SuZUKbA7FC9wNF9jipspb4vF?=
 =?us-ascii?Q?/WF5BYH4+u8ZUy0fI7jI8Mt+06xDOiFmkyWO6NIkG9cAEDmX7IxyXHdYZW8o?=
 =?us-ascii?Q?RyG6fxzg/MaWs4Z6NuMwrW/71ybtwm0Wl8BqnHFwn5xx6wFJ4wvX/FELKYPO?=
 =?us-ascii?Q?zJgVVQEDpla0BbJ0sykaRsx6Y9k1aJEC9T2Mfgg85P90gfNXVWPQGCktqv1N?=
 =?us-ascii?Q?WaS2npRz+2QtwddPDL5Jhdrxzn/8IjOh5vhVR0aK4YPCaZ1UJml7+PUxT/P8?=
 =?us-ascii?Q?rXuirpPxTldRZPykD2n3gMmB0uNf+pnO+sjHDTxtxIpbc5pUGNP3d8YPP3A4?=
 =?us-ascii?Q?BZEOjHf+fwXfr4QqP3HvHIlSo8P3OCImu5SdFomf1TsTOdioduqhEdqP9CV2?=
 =?us-ascii?Q?wiU06+OCsCqouenhlgU9tvtSqbeDywevN7Ezca8lcWDLFWF2StX6CgDxeQLq?=
 =?us-ascii?Q?Msvf8O4wLnp0zudfgMqze78+8A8avxqqeiFgOICEpiekAuPLh8wK1HyYZwrM?=
 =?us-ascii?Q?Lv2ZWckZ4L8LgzDMEphoxstdnmSZfkWEqBQF9S9B2SE86lFnx8OmZXk4KrVK?=
 =?us-ascii?Q?Q/Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ifEc5+N5Oh2XSSr5maQmt1A+/icwrJeSfmXGan5Cm2lC+cAQ1Ufut5saoYtt?=
 =?us-ascii?Q?+Pa4A5Rdm/BKuxGsI+malx81nhxEurHbQi7+xFJTOml1YH0YNSKCNJWvsT48?=
 =?us-ascii?Q?mhXK6i75YVp4UJpKdDGGletbPvK2LdeumaYC2npvwzzPMGTm2+bHsfMJeptd?=
 =?us-ascii?Q?MqpNvwSM6Eagtg3PCK3DSRBV6YVx9ANxOgZevLa9JvER0kZY4FLfIRcHg+VH?=
 =?us-ascii?Q?IlQcgAGRNOqa8AWNPecLpegd6407gcA0/v2/aNrs6IpOa5xQO4TOCu1fDlBM?=
 =?us-ascii?Q?rg7OwmDFzhqWOy6tRNFJP2Orl4yVHOrFxGFOGZ2sLDH79g6FBQEfxw+VRhT5?=
 =?us-ascii?Q?RTQFBBkSpgnOdDM17X74yx+qsKkCF0DtSE6e0RCnECdYRyJRxq8JcaMH5mjH?=
 =?us-ascii?Q?tN25jp/p8XJjEcezaubDOlCbRgtXK9sitIWkKH1cHI6l7tSQmBAy7+OcIZNU?=
 =?us-ascii?Q?fWbQC/EAYkI7CW74Jel6naYFXmO4aXOWAU7nbhaRv9+GrY8OCAz1KBM8v0hB?=
 =?us-ascii?Q?EA/WZ1Hhx89ABc+GY5q90Qj/+rTqyYs/0szfmyjIOY+END+FroGukGsRcu72?=
 =?us-ascii?Q?FueYifPkm9XW0kuxh67ADoiF2EUCQ5Q+RpmCH/+IIU0QKkHQ4V3CvB02svVT?=
 =?us-ascii?Q?sphXZYVNpQVN38E6U701FDWcJd8IC5/dJPkSrdX48dXlSmwSEGbgAOzCA4nK?=
 =?us-ascii?Q?Fo4oTIGcG5BTGWUQ6E4AuMYhB1DAvZ2W5wiFpDvdXv+3z0oiKo5mYs9cO8eb?=
 =?us-ascii?Q?dV8ri9cahEv1p+P63CvEA9kHHdZgm6T12CNafmuDgYwpSPdaIJiUI+4C8Ppr?=
 =?us-ascii?Q?dYmyDn1V8Obr0YQKhk6Vm4N6ClqXpFBKURGMJ7Wpi9vughK54LqNHDhecpMw?=
 =?us-ascii?Q?C15/aSUjLl3Y4xzziPu5wMK279bM3hOCjsxVXc+XRKsqovpa4bNpaLb9qDqz?=
 =?us-ascii?Q?UK9W7VxNA2BHyv+Aux+strGL9bGN/NBe86Jz+7RTG6DOlDxi5HGSk2cqVxrW?=
 =?us-ascii?Q?hukmmoDsIesukVQX9zUUUSdzCUlPsl0Ocgyjaw1Wum6uD9pZoYymLxW1TcIk?=
 =?us-ascii?Q?KJo7ki/Sq+PSBacFHx5jIqABjgD4STcJRYIR35IjX3zfT+vtBUvX8szV8eS3?=
 =?us-ascii?Q?KPCt7N9AWa8j+01wGpJChwKQaxi9CvdhlnSdeyD9tx6y86a8ZsfjP+eg24Su?=
 =?us-ascii?Q?pzPhCpo3HiMTGtBKzdTx1l0li6X3/Vce4pU+rsRbMQlt8I+jC8CnrnnEC1fR?=
 =?us-ascii?Q?Xv0XFXNzKeVcZ+pDL3tRiBKedBxi9T+8L55NxgRGkaoZ0ZIA4PyyoVFjmr5+?=
 =?us-ascii?Q?g31aVjL1OwqM/HZ1DLs/LZ1lnUVA+Frahkd0fov6FcA+GtGh1IY9Ahg7mXHv?=
 =?us-ascii?Q?gKsgejnGCXdFThqDVIJqUtGj2i4mxjYiBf9JHNdNUY7Ih7QG9aqVl9FEla1g?=
 =?us-ascii?Q?D+KkEWzQB5h0031JNLyoln8v6iWmhaLvdRfy87Vu1Y1nMvFRKzlUKwxrBoUs?=
 =?us-ascii?Q?8cqLlpzkxlMy4XPrl+MgVO66H7fqcEAkOxEL4veYq1DBJYtxX0wdIcEYKL8D?=
 =?us-ascii?Q?EK99iOi2gpb4IIUY6F+GGb9otQn3u7UlRdsbIOXazE9fEEy1FRfXd4WH4wT4?=
 =?us-ascii?Q?Bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NstPMnw1F3UALvoumwzlHdPlLkPDrKhy4My7XDAwAl/fujR1iDjby2zb4aol+qe7WPatPQwgi7qJY3PKorsRwnH2jiK5UyFr2g6O1AJl1Jhqrpc1ZRslmtP61pkUYbzzScv6FZ24k/KMOCf0GmuwN2j15OaGTLXkug4zFpykLctHxJWxjWvF01tv8cljPvv4CcyrRYehQGTptvqLIM0O1fY3Qc4CCblfqoJi+pVMQzOtqIH0CKE3csgMFrzpvhl3pR2b96xbeO7k1ni71PLTXlRRq46KkVl/uoW7yN9qB59wl3LNqR1NPIqjkA+CRL15+RfxWwgur1JHjTjRN2ltgieyND/Ny0AsqJRpyKGnQ5w/aVkfjdb7zwKFLz2SGEOTb4ES7kr4z89Eq23Fcb/hkzRxz2W5p/jv4S8cF1VEcFaDibeoW4++2sj/dVgAKI2H9kZ1EqPrvcbgTSlPUzDp1ZjSqVVfbzXpr9eQAA7jFL5y07SB0o2LxqgmCCFjduDt926kjxN9URTj2omUnQmuz/xJ5WUY0TD+Am1kCONd/hAwCIKVaOjUHuHRr9BWd8wYfGAblw3LdGlwqk/f9ey5oYUbkVz/WAyZPg4Q/QxG+i4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7555fa1-49e6-46c4-2594-08dcf526fd13
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2024 18:58:18.4201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 23nTBBx4ZQAlIy5w46GfjIevGKLxlNwubEVf3iZ360H6mbAiOBPNGDxWVUHXsGd40nPR+M3UpBJsXz5l6RXL/8RiVpX9TU2NLcqqLldUx8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7485
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-25_14,2024-10-25_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410250145
X-Proofpoint-GUID: bQq63-a0dju3vWpwzNLIxVCMhTmtWe5n
X-Proofpoint-ORIG-GUID: bQq63-a0dju3vWpwzNLIxVCMhTmtWe5n


Bart,

> Replace UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS with
> ufs_hba_variant_ops::set_dma_mask. Update the Renesas driver
> accordingly. This patch enables supporting other configurations than
> 32-bit or 64-bit DMA addresses, e.g. 36-bit DMA addresses.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
