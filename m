Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6193516B3A1;
	Tue,  4 Mar 2025 02:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741054513; cv=fail; b=EKCghaD+vMh7+NeHfxQkhdBli5QEkLeRn9h0oDceMMinmmRkjritiDd04imYYQdbCZkHhSUSy1fanT4+s9A6U/uTONcX75dn+Ch8vycW9u0CDhrXArdpyxHbUKpo84bYKguUcWNfFO2HO+chKOx9YyL3Ih6UsAQmJEriMh5DmnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741054513; c=relaxed/simple;
	bh=UW5ljT+aIFIye233AAYBUKRYIlXzmFCH9L7/iREYCdk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=EFoE4/0+oTdvPy8aeU91u8YPdJYGBFGFpXHPsOSQFb8Diqug5aggww7DPukXZdiLajFM9bQSMDLar2af4mYBz30mc1w5+7HHQcJwviCTISseog8ct8IqW8FqU1NLwwE4aXVO3ALgom20ezs1UXF/ASCKgWspUj0nTn/dYVh6HLg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FHq0DcwW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SyQSopMF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FHq0DcwW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SyQSopMF"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5241MfRx017684;
	Tue, 4 Mar 2025 02:15:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=9K4hcOR6xg65y8lWxS
	GwFxqKTqHKZ0Vrjly931SIPoc=; b=FHq0DcwWra/X96yNTS/Wfpx8j0NGIubY8V
	XxwrOJ0CkTcy790gUhsAZqQ9cqtEC7+zhigKiNwhddjzC5IE+l1ZHOOAeK0Xq1UI
	1KZt8/ufHcUORdU1X6gk8Hv+oNfIHbVRtMh73HOkJJTV9cd2ahZRd4crxDnvA06W
	6wV9X5sYdL4SaWD6P5NvtQORpphV6hmZ10a9DUscq4l5ajdrgip7ALHx+BWNfpoR
	Q4htBRSlsCScuNsmBSbDAmq27VwTg0NM++4JGO40uQiEMP2gh8Ak6G6wT5qtZBYN
	H/6SM+sYrhDTZqp4EAKJU/phivFLDJkMiTDro9vc+MMxgJ2BKOug==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u81v1eg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:15:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5241tW8j015691;
	Tue, 4 Mar 2025 02:15:07 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2046.outbound.protection.outlook.com [104.47.70.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rp9hu6f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:15:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aPyW8JEqlmd70CGPJuofG0N6FoDWw3eR3vhhjwtAzdaz3YNd+/3ToArkOLWSV+arVgO3mNx+KY6Zi8yWugrQXicecJmB8ibN2Pnpy1gJvfjjlsd/n/89A62uIUkGtt54+8k6J2kFyNBhiP5s0w2CZnldo3qyjxp4xeRLGcnbR2rHDXwDZL4+AORhUtTbxbcf7M3MS1ZWqahvbK/BMRilcHX9Vn49SST69JZj92dUXOib7JCUW9WiyCOOPltltTEbWDVhmFxoHHhKJdBA2CtqHvhHnEMuGrX19UgAeFBRIM95kI5u+G3fwc3aJM4VBlv+HquXEzrGaJwVpmgehYUOAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9K4hcOR6xg65y8lWxSGwFxqKTqHKZ0Vrjly931SIPoc=;
 b=GtH4Tvu0MxAeeQDBH81F+pvrOgK0B1+W+r3yNweC7XNPzyPS6Gvh9b/Q9u2Jpc7dMynu1RkZXU2oj3csYQumFnWBYrSwh5FvKvugKkYOJfbpfk2/86bMvcShX8RDDaKgb/aW1+lpgbITVtcYDrEaoIxS2WB9hMopIfGEoW/LX205/LDayG5p7JO36jAdrZK8tDSQRWjblwwkyNf0+qFq64hVocnSgo20IoRpVrcoL8xsFGcUyyBhJyYQFNO0TQbvtvoI/EknAeY6oyXOByfqzdCvBM4yLKeR9fh1tiyMRJ5SzTUsLU1aeqIY5fSNQzTOfA8gwVxGDWez1W3h5yn1IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9K4hcOR6xg65y8lWxSGwFxqKTqHKZ0Vrjly931SIPoc=;
 b=SyQSopMFatf8OtK8PK+8F2oS+VMQ8FxjhfNzxUBamD1xZQwDUyWd6PCmsAKms9T+OEst8ZrphPZLXvhZiSJ6PNyFEu5LDegm4kV6D9n92tRl25qdDFnLlzBFVmrGJwVAipOMek9uznyHeuQ4fSq59RtHCTBZFAucZeY4ADQWX4g=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB4964.namprd10.prod.outlook.com (2603:10b6:208:30c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Tue, 4 Mar
 2025 02:15:05 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8489.028; Tue, 4 Mar 2025
 02:15:05 +0000
To: Colin Ian King <colin.i.king@gmail.com>
Cc: James Smart <james.smart@broadcom.com>,
        Dick Kennedy
 <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: lpfc: Fix spelling mistake "Toplogy" ->
 "Topology"
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250227225046.660865-1-colin.i.king@gmail.com> (Colin Ian
	King's message of "Thu, 27 Feb 2025 22:50:46 +0000")
Organization: Oracle Corporation
Message-ID: <yq1eczdv8wt.fsf@ca-mkp.ca.oracle.com>
References: <20250227225046.660865-1-colin.i.king@gmail.com>
Date: Mon, 03 Mar 2025 21:15:03 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0027.namprd22.prod.outlook.com
 (2603:10b6:208:238::32) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB4964:EE_
X-MS-Office365-Filtering-Correlation-Id: 9792445f-2d74-4992-6672-08dd5ac260ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MZCLKXkf0brKyA5z9LEweDzItTBizQS8qrW3EQIAfGjsrjpOy9j8Pvd5epLe?=
 =?us-ascii?Q?+OoHNG21ZT2NBAGhwEX8l6qM/xzeRCBytclykDrafO696hmkwJ85b8L12GZ7?=
 =?us-ascii?Q?MrM+x4RGCWd/S2b38NuShcHJEShRd/IoNco3rSgM2qzHd07LMgGuAKrYJJaA?=
 =?us-ascii?Q?cCOAxgKH071IGqIOysCy2fQ3jKW0ts/d21SEuDFL14t5wfU/JQ/29kdyezsE?=
 =?us-ascii?Q?Lczq8eEzpWc2hngENmuD4M68enXCGyj1zsz30UZFjF3gP5HR+Yxj3yl2TxRE?=
 =?us-ascii?Q?7Bp/Se9k/eKXhfxwS+vgvCyJcd3dfKtowIlVykZQ9DJ2JfBU2e3BBUrnS9eG?=
 =?us-ascii?Q?ZEHbNgUc4FRAlJVW9dP2iqYSNx4YkM6jdG4bFFCn1Yd9B5znZMfuTxugkTs5?=
 =?us-ascii?Q?8nEnu0iHs3KGy0AiR6HJ3Ul3d24m5xqmG9xfq6CsqBiEId3EPaqyBnV+iuRT?=
 =?us-ascii?Q?bYj4L6ZR3lp1sUqtW6IIiwv6wsYB7r7MjwhtiTEsMmfzVJ/OcPFr7wmKUxhL?=
 =?us-ascii?Q?x5pPU1STs9Lsz6gnPy4QgAmtVj1DyHkrjo3js2i9FY7CoHsECKxe/maQZTnc?=
 =?us-ascii?Q?NPyC4EnJYjoS9PTUr7LB9zXG4s705E+V7lo8pe9fApXxPz8JDKw2FpVWT3Hv?=
 =?us-ascii?Q?UHHhhjVp8gC8j5FHpzGkCHMTbGFwve3kLh+XydDV9vM4JKG1DYwHnrt1i0te?=
 =?us-ascii?Q?CHwAvbFk3jZGMoqhZU/JTJOlGjTyc6JLZPNHHoSTaP8IcC2k1Dp7bmA8++9n?=
 =?us-ascii?Q?M1qjrqR2IVmVl7eLIhoonhtibJ7Z5fhwIoEHWe+9Bxjh7xz1cEh5i+/churY?=
 =?us-ascii?Q?iyC7kPYpi5NtmQnHH9v/bPlTaj1ls3YYlYe41XrmtqTKtkjLzfSDgRVDVZiH?=
 =?us-ascii?Q?JVcBmEN4gWCdZGW3ZXzS+KxcDs05Cf5yw5vBmUPgaz6qLrAsy+KP9GATmmUZ?=
 =?us-ascii?Q?Brewh8dlDaLyBESrZkrdj8wMNWpc2LVDzBsEPrwABn/70hke8hPGYE7e2Fhd?=
 =?us-ascii?Q?UQ0hHV9hvwy7s7HsKLnARx/pArcMJeJKClyjPEzlQ9KEdLjafOy3SKmoIxgV?=
 =?us-ascii?Q?1KYauxhztI1D/zvYtXZKzcfB/wz5tMd+VEbxZql3/8vZoyUES17+hlAMq1IY?=
 =?us-ascii?Q?EzeWzDwez4LXb9tx1JVPAUGwFiZDdMI0Nc85PBYgkwFtw6T00GEaxbEa/xHv?=
 =?us-ascii?Q?42EX+GSuEEmxsrxHSnTtjpKc0Z8L8y+SmllVSrVvqS8gNtubBEPK1egQfYl5?=
 =?us-ascii?Q?qk3L/TV91EnMfPXUmm1CzsEVQCyGf4kaKxwEjQJFXqOC2aFv2U+ziqGoFZ5i?=
 =?us-ascii?Q?nFA/VGLnFDs+5+po0SIpchjjI69cr4tg+JyJ8EgJY1VixEsAxDfCaReVz8Sf?=
 =?us-ascii?Q?L3VHCD+AT/Jp1wDO96QclNZtlsCH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t1yC/5YrMSuLzdWnrFuuqlSHCix2EoQDuBpOOyYfw1olGuh2AoLNu+34b9Kt?=
 =?us-ascii?Q?TMDoAc5AnsbIy0LVbyrnQZYOMqXQ/sd89hurhNrgNjjSNkvV0lObBCmqGEfp?=
 =?us-ascii?Q?ImRsbuRDs5W1W+ekOGAcT70h/28gHUlgHDSCnHnPz75i608i0tww/9C5RJ7v?=
 =?us-ascii?Q?45UoggkwTOky8pJrKukoWfmQCuXThdXEerP+mkFHD8w9YbA5Md7skgO9W0gC?=
 =?us-ascii?Q?wPAvMJjRqewbZ+RJ0wdZNQSV7QoolhxnuHVbUkx5hohg16lw5Tp3u6JRJ05P?=
 =?us-ascii?Q?lPr+SucocrMDSJZkzEDw27QWPG2mYRAFbX3UDWZhDZn4JFUilMG+jrb4/rtt?=
 =?us-ascii?Q?sFraHaqqiU6PlW2Jj57zmGP6F7jWrJnpIML8SGzvfW4gsDiF9DtZ2LaGQG7+?=
 =?us-ascii?Q?h8ffIP0Xmp0yr6toqRYutAjvVWc7l31h3wdLmPeEwalqIOliawsxAwaHYtxC?=
 =?us-ascii?Q?wtcNgbx9lTAmPWSrZ+VEvywSnL0hcr5//mJ+QOKp+6dlRedIYWnhw9Zm2noH?=
 =?us-ascii?Q?wi2dHK+FAODbdj2UMR4//7bjsN7ftLYZ12rUB9gwlDiF8xnY46PxCdb8MWM4?=
 =?us-ascii?Q?DmBITZ+JniXQJ5WYh4pkUnfO2tHW6UZi4D4dasW5THH19muGutvWYQgJiy6z?=
 =?us-ascii?Q?zmGCYWUJrnetMdxrt/G4ZVjqfumTO3ZXAYNR8R9e5T/PArpXyrq8eNe0wGE7?=
 =?us-ascii?Q?pX7e7OZclAWS3GThzriEtwgB6l/tlzgKmzruadNqfM6K0VAuNbQ1G3CI6GlP?=
 =?us-ascii?Q?2ad5T9iPw4HvDyZt+SeDYXjLiDUqRPNzpYy8UfsVSatLKVxsAKPkij59VJMB?=
 =?us-ascii?Q?IuGN8PGcmb8GW37nSIwjsEbQMXCrTuZGfZoViOs3h1ovbiq6gw05WAB40enT?=
 =?us-ascii?Q?6w+sO/JSdMJEwB3yYs1g+2/TkkXgDXHjtKL2YzhAJa0GuMLilmjy5eTkfq4W?=
 =?us-ascii?Q?AU89nvFPzdtnzGzM3i0zW8kMOlQsDdnI0Zo9lOCw1J0sjQirlLg7KkWu4iY7?=
 =?us-ascii?Q?bJJt8jkBkLrGr5BbGUjSwHnypCDIiI58CkDzFwWB5Sq+O2a/g2TT762A1l3d?=
 =?us-ascii?Q?phPM3chkAdmL8yjWmrjQeOxUZrxmiOkGVzQBAMpJINDadBnh6Ms8KoC5+cPH?=
 =?us-ascii?Q?NetXz3zQexaELa+vTKCO9dY1Ng3bK5KEAHdrT/6T6Zq3fvRwoe4WSS7j+prQ?=
 =?us-ascii?Q?C7giNnh+Zs0JOz43qZe2C7RhvpdFSHg08p4XJF9ehUulK6d7coc7209dkASM?=
 =?us-ascii?Q?z1JpJ3M+nbqlHm5AkWHVZOwgaybttpqGjZkQ/a7xDU3GFod8qyLIlMsao98D?=
 =?us-ascii?Q?K28Ncmkl1rH7/nQktgPuwjnHfeO51PGRVoTIkT+lHfljmA6Ju7fEO2dFRex+?=
 =?us-ascii?Q?y9jMBHimEifVvTwBuuj+POCCMRrLytOumfT0qX2ridcj51RqnGr/8CoBiZHf?=
 =?us-ascii?Q?OJPwwzl6tQO0YJai1cTBRq4Cnw+BeKP32zQNm13vFfgr3gffwHAwJBPw8SEi?=
 =?us-ascii?Q?KrR8kXJjEG32NfGT9URfJde7gLdfEyy+yvSmaXYKCnfDBYZ/V6ozhIhfzbOK?=
 =?us-ascii?Q?hBxa0bjxXurbxIpS6ADAL93GP0D2gptT8zI7TFEYupNrgfu5dGgteQPi2VWr?=
 =?us-ascii?Q?uA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	O+VVvWzQR2wf2ym0KIhoZf4hzXslLj5Of8OJPrAScDLTFxcPO2hdIYAh+h9z8fwvPwUt8jSM2aGHLKHJ4393lsKK/U9bQ4VU3SDgAuzfUC/tcqS/M0fe49FpXRzpvuCGeaIKL/BxTw4dQ/3r8twjeZilVetKfjSgVpZuCKO+w1Dh6sEoGG9EMZlBfoznhaBD2Prqwqt4MA6AS/WvRsqpLdKbU4xCOBSm46SbMtCqcaZY9JIfwHwxjSGeORGETCBjddRUHp/uo3N+G0HCkFBH3KdUpTxcaxXP3nMyUv9AT3ZJi6pJJKc6XWKoYTnkXxKwn/NcN/CncubVF/iEHr6mw0+wOx4gfPSxQI9Pt0u63YCIj2LBsZ8C8O5xh5PCU25IBA2PG9si7lIleM1xbWZQ77iUMoq3V91aIFSS0LoT+Hm/8GUOpIdV+dRzdA/sndlVcVhHF+SkplmNNhch3uVFKm2K7V0TpuDl5u+CxQ316qnxK5+TBN3m/9+4ZKE2zqAgNG+1llsA7lBqMn+17oWfvgOWJMdOhV/zkCaNjirSJrP2eMreQoZhdb0qnJREz3Z241AGFMPUEzSmfUnnxUxaCM2W5SMXuQ9ld7mmCIt5nJU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9792445f-2d74-4992-6672-08dd5ac260ce
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 02:15:05.1907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xGasUZKC6Elizoco204MSb+sR620/3LuxAmu+Gc5vZMR37hbs40VMwbn5tSQY7z003v07Kg1+ItcbZobJAan+U7bsOFX5s3dcyFKJVikVyI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4964
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_01,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=874 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503040018
X-Proofpoint-GUID: cKdOamUroXOonRdSqO7Mkb_RHK3RI5ks
X-Proofpoint-ORIG-GUID: cKdOamUroXOonRdSqO7Mkb_RHK3RI5ks


Colin,

> There is a spelling mistake in a lpfc_printf_log message. Fix it.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
