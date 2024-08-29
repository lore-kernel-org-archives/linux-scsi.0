Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2098D49626;
	Thu, 29 Aug 2024 01:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724895270; cv=fail; b=gwi0fsCf3+nm8o98HCZNsaGlnj7kE3mCWHdysFW9zweA9YaH9q2CMo/5jTECByiPmkphaeEc/R6d08Ht05ecbredufm+G7YJfhASAmlagWlko/IY2y/M29z+S7a++C8vd4B9dz7WT05/gf3KHPwFJp+jN1NI1CpGLneMsOPEiPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724895270; c=relaxed/simple;
	bh=RZDDS8wVpjQDI7XwuydU6RrpOfKCauEiWI+ZsXDczSY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=esPSL4eZJpCvdWmH5EFYfW1wxjLnCWVG9673TARRxA7LA/+Eh1siX10TUU1CHOaBE+Y+HELKAzlYZerLXelu5Ab4XVsSE0AiZpsghh9Oa/6rGshma5WGjq/XfZ8ZE2NVEPei+2RjcaFGwgX1lh2wawqwkaPRqAMWy2w7CmXp5b0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SzpgKrUx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hXLTNHK6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SzpgKrUx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hXLTNHK6"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47SKieYU005842;
	Thu, 29 Aug 2024 01:32:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=EDB7MVmADuPpaE
	flj/KkRM014Fhj81rq9Wat26vIPo0=; b=SzpgKrUxfRLFJMUkOVsGE6BkfLo/iy
	m36gujQ0wzTtZaVTu8GMDetRSF7ukKlZFjg3zaB6vwY8EV2CwyuyXFwk47YBumTf
	n3QnDKPRRlDdwe3xqARewSfeRw9KtzqBrhN6pq1+e0n9HSC7kBtkjKIPT+B9Ujtp
	YpdMZQX2pO+JuBz+9gX1tf5xRtLu9wqCe5OeMyxtSvJh+THJ5SnNXex0RY2ZlB/B
	6yC3Mq1/k8Z+M+aLxKFEudp6AbaidcPst1/61Y0WBfqe/zP4kH2SABF2Uj4fjHcx
	3rZ9SGX2GL+7U2uVnVQsVH0GSPMAGroR7g4nUJlvKxV41rYyO9FocXiQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pugu530-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 01:32:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47SMtbqg020104;
	Thu, 29 Aug 2024 01:32:18 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 418j8ptjq4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 01:32:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zska0HclN+fHvgOo/jSFEyf5dU3aYpVmAKyopo69jmxGb07Bq8FTkTR4MkpaubRPmaK8VpOwT3l1QTg3Y0/mwmKI1QcU63UrDLKs4nR3cRmob/z19sWyQa2BjTMOyn0rEyaveOLMS1l63MKpfTgBDjyo5ImPw2B2yLRHOqh9UpJbseGHa5nnMWAkl5GX6vIqAS+6t5Z1kiNUA48P4mmFBDAKb6EHbO6Y7QLnoxz9kpG5Q+LDdsEJE3aw/Tw6UT7s/MWdCERu6zC4GGbcIfvw/rNi8g3oDbPQRqcSTbGlG9tMS6azbST47qdjly1J5Hjosoa5GNsZ+GxvNOJ7n65YJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EDB7MVmADuPpaEflj/KkRM014Fhj81rq9Wat26vIPo0=;
 b=T1ZdIf0SF/dms0zslzSlypUOq0tybTraYXoKsD2GjQel1K+oB7TfX4GUygGXqbQT54NGGuy+V01/lhsFqPc2B1KjJZRPhOER7JWQSFefBuVlFx5WJRCp8YXpuYwv5a0K+sxiOM0F67jXEkL+KdGbdnkRh19CZ/Xw2JNG0X+XDnyxlOJxKmD6pEMh1zks+q6TlmpbPPsmAQwfia+Er1m7VdWxT9cbxqT3ugsIeL4w0VEgf7ZGr7HJT4CMSvn1BfbtOKYGGYytMgwBKREkfP2CnTo4ajv9hw6ceagu7vXNmwmqLZbSHgXe/G4eqbYTKN/sazjce4WoNhWP5BuFD3cI5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EDB7MVmADuPpaEflj/KkRM014Fhj81rq9Wat26vIPo0=;
 b=hXLTNHK6dqGvJ2M0U0DRRx/A0OA37qS+gXUm7VkEGBmsxc1lHkpoK54kyDjK5FUdHh0oRSEFpuUKjGHbxLE3frcpp6pnOzq5+heDeLpF0zsLpqu/TgF+jEC07vmxRW+Lgl3OLJ1JHPQjdATZ2Y0CWPVJ4K2D5UW+YqEtKvFgJhw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by LV3PR10MB8202.namprd10.prod.outlook.com (2603:10b6:408:28c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.19; Thu, 29 Aug
 2024 01:32:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%6]) with mapi id 15.20.7918.017; Thu, 29 Aug 2024
 01:32:15 +0000
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Quinn Tran <quinn.tran@cavium.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Bart Van Assche
 <bvanassche@acm.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Remove the unused 'del_list_entry' field
 in struct fc_port
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <69155321ab26c1f4d473d5bb6cd44b59b9b6a020.1724094686.git.christophe.jaillet@wanadoo.fr>
	(Christophe JAILLET's message of "Mon, 19 Aug 2024 21:11:43 +0200")
Organization: Oracle Corporation
Message-ID: <yq17cc0dsh5.fsf@ca-mkp.ca.oracle.com>
References: <69155321ab26c1f4d473d5bb6cd44b59b9b6a020.1724094686.git.christophe.jaillet@wanadoo.fr>
Date: Wed, 28 Aug 2024 21:32:13 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0211.namprd03.prod.outlook.com
 (2603:10b6:408:f8::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|LV3PR10MB8202:EE_
X-MS-Office365-Filtering-Correlation-Id: c990120e-e566-4c18-eeae-08dcc7ca69f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JQeGuiAM/keahnWwFqUNXYlR7XMhJkQemYhb7IDUwJ+pQYA7bfC3BRDOBcsG?=
 =?us-ascii?Q?tIRIPw4fmyv/OyiwXcAIJJTEHCQiqo3vVJFGtw6cOZSt4tHGD39v2Wt4NLwe?=
 =?us-ascii?Q?QYv65JQ4b3ebQi1Uje0EKps09lVAKNxzul/pKNrshmtH3lhaJ0R00AcKE7ej?=
 =?us-ascii?Q?NsikgXjHhOTLrqnZCIiIsmvi80JXbk0U6ndOuGXjLkjgXdHy2+eRT1Ttz3Ag?=
 =?us-ascii?Q?WADriq3uCaMU6uZXEix2sTbwrbn52V+Lw58zk8xKOmhXtIbam0sXJVptSq2K?=
 =?us-ascii?Q?w8OMEcmaSd1vfQoR99m1W+LOQMAJ9a+soXgCiIbVnkb6tQEpYz91QWoSgcrV?=
 =?us-ascii?Q?i0re73OhBRY6zrQvUF6vDX5Ok2eonB2MjbOvBmOIavUbS512zs7TjhBkWr7d?=
 =?us-ascii?Q?4RZNyjLibdG9A9NGNZK4jV87XU8KYT9aytGNP2nHQ+8mr41BbrLwfdq9tcy4?=
 =?us-ascii?Q?LbiK1rqS8e3K5D4cjsbEy4bh0zxfQ3L24OmJ5lWv175wcLYbOhHL7a2xhAuw?=
 =?us-ascii?Q?bbeXJFDdreEJsSe9C7E6YmDn72i/xhksj2Lbpo+VN1bKNbVbOUGAqvKUzrwE?=
 =?us-ascii?Q?vQGArY5MCUkQ397/+1aurRURIkM2tMKN4GJ7N3zRHLJrmaExlozsEKUKtThr?=
 =?us-ascii?Q?omzq4dyZRlqcTyAgjWnRxann+I+oSdrz5oHF7xdLxUyTEDHU/+XxtoZdtvDT?=
 =?us-ascii?Q?VKhHYsNoHrVIc+xAZ0dvPlhh+QSxRvN7Q4hNEGVeNudPJzZ9aEfvSlYpnWGB?=
 =?us-ascii?Q?xzIlLnssrhvNnloXgT/a9X06HtTA/exXi4iwfBeWtdHSbdxhRSSiWYms5WHF?=
 =?us-ascii?Q?72YPoVAkbkSE+ECIgXWt8qAiorUGsgqfoBzYuIKHm8Ul8IBnR0zXxFjiwtqb?=
 =?us-ascii?Q?XKypnXTm2W7Hn2Bq1/Y0q1H8HldzIMJ2FiHhAehUfxm3eqjSxg2nDpS7clVv?=
 =?us-ascii?Q?eGOrzSdlK3N++eZevV4TtZNjrv6L36/bqnMwe5yVGe8rpBDyvoQ9S0N9uymP?=
 =?us-ascii?Q?tCg2NiN0GDzLZM02xPSfu0ETpXQzNKBg5/7tBl85VWvGeL4DnLNiNx538/Nx?=
 =?us-ascii?Q?XQZBQR6ZgqMEOJXA/0QvY5/tPesXpuvRzavz1TmgkJ0od2WRAFzNi9w4flf8?=
 =?us-ascii?Q?1Y5/fkbHOagjlaA/jnvQ+IkIKMypgQN3ieoxzDV+iGHgwdC32yOEqahdcOnU?=
 =?us-ascii?Q?9r1ubbzOVFYqvfagf1iP8qtTdFZNUb5WyyB22wHjaYcp9TAyFfMhAUThtF20?=
 =?us-ascii?Q?ufPGYD1/uGV0sSbLrdFOumcw1FLWkKpJTJnp0c1OVV8kiYeNKkCJ3Uf1/hyA?=
 =?us-ascii?Q?kXi0HG0szenZw9AtPMA350xD9INjwWLPoLK7WxHIBkG6rQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jAaPh0FhP4+K5WJ9TD0MgULTrap0EJoZfk/+xaejo3yK87mwFXNtQkYqgpmz?=
 =?us-ascii?Q?N8EJBzZaVts/7sf7SINXdRp4tSLokiqTXdDaCbTY/QH6sn7t31xaGG4lUz9T?=
 =?us-ascii?Q?bc5U5SNxKyIYIlTrVbr195vW/rY7oE2JfYnOcKFUuFEfFluCRbPvcPAHueOC?=
 =?us-ascii?Q?v3tPIrMT+tCfA+aSA8E9cnNt32N7Y37L3rTBhRDu9FbRXPL+6gxAG2y7I558?=
 =?us-ascii?Q?6JGl8WDfUsAnHd2sF1/BMhSWmDRyzL+6p0jwlHw8SF5lfsgrlzi2oh6eTclD?=
 =?us-ascii?Q?4ob5PqrIFS0up/hT5XvsV99YiZvgmR+jx+XtGmOb+UOlCtwBXfBSP9TsKCcR?=
 =?us-ascii?Q?9HmltQlqqhXjd9se3RFYVew0GtN3uPuD/zZdsYMua+RrkGzxVZY/ktVAVqWJ?=
 =?us-ascii?Q?Ol+KYjU3B5pXF4W2k01vbdT6vSUB0ELX/YzpH1J5sAVlR9uePKoI8+69W9Oj?=
 =?us-ascii?Q?vuvdjgBg3EfKW6aeRgByazXcEnvU1jZQG5dbbMWeWar6Oy8sS5A7IF5fTkcb?=
 =?us-ascii?Q?WAdaIdjF2vYyfm9xZVTrthuwZUSOKaz8A/RuowWFMzfUznMaKosXZODreSJ/?=
 =?us-ascii?Q?5X3roeWkCcrAZHJ5oMzzHTFBe6oMqXTGcZnfYa0mlFCu1R5DZUXyFtC+h31x?=
 =?us-ascii?Q?D/FRRMQKDRFUS2jiaXz9N6XUU2FjUJ7MO5IcbLrunpVrH2GErqCHHiUBD89x?=
 =?us-ascii?Q?4nHDCKqQTQ2tQiQwJLzj591yhlh3P7mPCjIyrLW6ojkJTlo+lzY0J+9+pyvD?=
 =?us-ascii?Q?HIrYrE2bstFiivW5z1XamA/Q/MDE+SUHaoaj0qXg8gMmYIrLVWmGTxR7u02j?=
 =?us-ascii?Q?7wRc7YKRNfWo1PTwq7DuzT+4UZCEMveKJXJEQTSwHHPzR6yBHRL8vHvsVvp+?=
 =?us-ascii?Q?mheOcP+uWt/sJfYVI2mzqGojBQ8iZmI/7w3/+dQfbBwT5TkZ+h1QNEwiI0yr?=
 =?us-ascii?Q?0i9qkDlWxV0N3GHICNZtHZN2xnXcV4ZbwGO7wrVD3ZY0MELgjOryctIYGBMV?=
 =?us-ascii?Q?sFbruplGdLhh82d5GGlZ6QC8k+7ERA6wPmWqu7h+QrDVxbtTKyEmU5ERbZqA?=
 =?us-ascii?Q?V2UuWh0qbzV+vrNhc55+TcSIqzzwqkelWP1B4X1yDHBkhfAUzHjsWL4hoQuI?=
 =?us-ascii?Q?dDMGCEcuLoKU96fatdLjmzTyV3OKCS5D/v6y/FVgOMJyfII40wYhbkMd3CSR?=
 =?us-ascii?Q?KPZ52DbkYFRjRJshRND5JGvDYPbqd+hzH8nsS9gz6inEGLb9m2hkGV8L3ANq?=
 =?us-ascii?Q?vm1OPP6QewAsPFP4REuITWvCAYovHd9NuBP1UotJeEHLeohTPFKQCNFxJ6KP?=
 =?us-ascii?Q?OuIdOIKXge0242a/9qim4T8s9DafSOhSeQ91bU7mhWuLBWf1L1u1N/8vJ3DZ?=
 =?us-ascii?Q?LbOozHNgiGLKfaJcKpoPoS6Dr4Pg1uEcimY+O8JKEhVdjw9FDaRepWZoHjTy?=
 =?us-ascii?Q?AKWdN9qOQSFDhHP11WnEdRhGLJCdCbvPxQsNr5KxdfAQKqLOmkqSj8XNn/9z?=
 =?us-ascii?Q?CYu04++Ucv/ksWgTIszW5UAalnRBmpgpeh8o4nmlPIF5+g535Hg+ePme4wk5?=
 =?us-ascii?Q?JR0YBulAq5ZNqViSObsugqVsG9FMbYYZFIpU//CUj0tnXbfNWBPTSko/n9sz?=
 =?us-ascii?Q?uA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	x/lLYWCSkhzaI//mJuQKCc6COraX8bvBa6zpSgAHJVeNfSM91yk9RaJ+9xhDgi2uPtvD3nFzA/pkrx11C0nlJ5BPjRn5bkvSzikoUBiZjDUKHof4PIGHRlx7nkn8MJVTdWEAKWygJ9LS3Ty2qb6ccQzzkvtsE6u/+Mu0aZ8C3lEA8/t9QSb9D63VRimEMWkx241TM7chap2QIwDcSuPwb5tbU0S2i9iioh+zufxbSYB9jV0pvEs+HhZEx/yQp0i1tCVb+8Ub9LUBrAfZgmmbAjKun6zLdeWFr15lz+oHENcZCsvLu2ez4+/Vk1ZbkfKUEvNzkBOjfhoiHLBRWXKYsW987tDMILCPTjfbcnCuniVG6aPxPBxgEJVHZVb722Qs/xXwkT4t3YOFTEPelbpb/zTDGUNC5XcHGXlgzX2Q5Lpx1Ri4QcYIMIMctvLEfhEj1gktlDJ9yYbY3s4OmyWb0VfGTfa1oJ6IXkOLfGBRk3ANXBur/1mnbqd+NLXg88/7OlhuJXoTbkMMLxpGEUCabee83wz+meOhFHbP51IE4ShzRKF7OlGcQsppZY1gUlJj7jXTErPfpfQsiRVdZexwYw+nA4QnItgz0+N7K+VcVfI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c990120e-e566-4c18-eeae-08dcc7ca69f6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 01:32:15.5793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bH7nukPE6HMCnOmWekGqmK2ackV/BVA5tOgAvVbVLPO44U+ZXsfvk8EsEtGQQE70+0bwIMPaKdMGkS7kh5mw5wNqSYvHPKsoLI76tNuCmkw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8202
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-28_10,2024-08-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408290010
X-Proofpoint-GUID: H4ORjg1NR9AhA6FfG9S_cZiXwJvUAcca
X-Proofpoint-ORIG-GUID: H4ORjg1NR9AhA6FfG9S_cZiXwJvUAcca


Christophe,

> The 'del_list_entry' field in "struct fc_port" is unused.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
