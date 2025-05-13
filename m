Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A722F1B4141
	for <linux-scsi@vger.kernel.org>; Tue, 13 May 2025 02:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747102727; cv=fail; b=AN/fyvrc4nUXczWC1KnSL27dQ7uwkS6lPoCE6ePEjJwy0rofQAQ8zd6SPzJE4zIAm7thNVBYnpoFKflNZxYPpnwCWnrmyFAn2ljTWhhqF7+vDybaqYDro8wPa31TnmMMqUDqxH6B/0FHTNkQ5+QLlINnVrqgYUzW5zvgqAm0fN0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747102727; c=relaxed/simple;
	bh=aYXb3TAXrLZM7WZfQS7DyJkTJEWckenpo/F4kCttM7Y=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=eAX71vkCQR/fDVANnsa0U3097HslKv8IMn/Vgbpcudj6EZ2BNGd7rRHdAWCXPapT+NQ4gmUTARSIs7qrCwR5p127I1xTRLkPHuAhjbXTYQJGtTQkwmhSNht1Q88pyQ0Y3qxd4sKBvtRK1gjfaxc5spHunVJNw92CSNdIY07fDw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HBkynrj4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=W00L31Aa; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HBkynrj4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="W00L31Aa"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54D1CTul013876;
	Tue, 13 May 2025 02:18:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/vydSx6phhao1NM16U
	hqPd2+Za77fFhVm8z0ttJUMck=; b=HBkynrj4UDsQJ9otJ/RdwZ1e5/ubXmRdM4
	ktuCL24RuLEoy3YPdwS68b+JJeWB6Os7HktpXqz2yo0v3+BQWvwPV/dFbMlon/IA
	u9+7lT75ErHQU+RwKPRO4DKoMASU4z5pX/roiz5EHGvkx7sYvZItHwPnKLAy/fKz
	5mfoVnorHqdoaeHYSdO0YFw9repddj48fFtFUtiOxOL+/7qM/t+x5c40g3nWM1I4
	2K4sHbPamGEJwJv79lDA1OyC7LEfoyaQGyHRL9pVgXgqYkFwQZ8CskVs3attqC3t
	Tkhc/JtOdJj/J2CJic5uYwF0CyBorjKjILAM/APfpu/sS3UHLLIQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46j0gwkthf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:18:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54D0Fft0002961;
	Tue, 13 May 2025 02:18:23 GMT
Received: from cy4pr05cu001.outbound.protection.outlook.com (mail-westcentralusazlp17010006.outbound.protection.outlook.com [40.93.6.6])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46jwx3rjfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:18:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EFOYs+0Kr6YPc1AcoI6vQfBgWTnWslUY+WE70/nd+kv2CAYhahhk49EZCbwUJaJrfMc0kftD/zrx9HJNCqZYGqZZhcfr01oIhFel6kYjV16+WxKnLCqvvNfobIuIXf3BnPK5dtKgeZG+qe2XlLqnRCRZLtXk3bwDsem5QTHsZ1R1AYFgLIyu1kNvuBXbmG0F/up5Dn4x3lm3WfoorIrwCeP3DWo+zL3oC2H7bXsZliaMhCiGCaFerI1BBC0PMLHdBkXuut/KOqmcNLJ2suebQ5+T99vYC0JmR4+wWzmpPenm1XpxHZ3uvCqph2ZpkSkQ3FXqbdHdQ06p2hzah8Kq3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/vydSx6phhao1NM16UhqPd2+Za77fFhVm8z0ttJUMck=;
 b=Igq9xgCnuA99+SiZyMAD8RJ0HH+DU4ysTp+gsU+5PiXQkvORLAILL2JkSEM2mZ3hEdtbdOA3OlgkA6fMUOF3x3YXf+1B/Q+B0A+R7Di8kJ6c4v5J6JgV/Vmyb7sf1urjMIl6i5YeadbbJyFhHrJSyyNk7KKNtGHsyLsUicIWn5J5RIB7/P0PYxUISCMf1ZZtwT9xIyWHDlusY+MwKvdYzfSphNwf666o6A8htp1PjfFTkBSo3LamNrn9KD3k3jWjg0mI1HqZU/ybwC9iCGXNcvjklF/fR1KVAoQyaTuc1bEFQHfMsTnnYpjFrqLv5eAW+rNn4X020TRDnyJTZz3D0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/vydSx6phhao1NM16UhqPd2+Za77fFhVm8z0ttJUMck=;
 b=W00L31AaIJ8PKbt70mKada4N5CFMBqkzihJr2QfK+wp8QizzWda9Q3fnx3qsNBry8F22jc4rGMWlHu6lyuB87kyExhQXDd9qdqnov63ohDO9rvuHckkXtb3vZ6JonriZa4gRlWoCmxDQ1YBQFHyAT6Uf0eZp8xE11EGa6B9QwhY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB6099.namprd10.prod.outlook.com (2603:10b6:208:3ac::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.27; Tue, 13 May
 2025 02:18:00 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 02:17:59 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, bvanassche@acm.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        John
 Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] scsi: remove the stream_status member from
 scsi_stream_status_header
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250505060640.3398500-1-hch@lst.de> (Christoph Hellwig's
	message of "Mon, 5 May 2025 08:06:37 +0200")
Organization: Oracle Corporation
Message-ID: <yq14ixps18q.fsf@ca-mkp.ca.oracle.com>
References: <20250505060640.3398500-1-hch@lst.de>
Date: Mon, 12 May 2025 22:17:57 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0073.namprd03.prod.outlook.com
 (2603:10b6:a03:331::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB6099:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c559ee2-49fb-4399-6e20-08dd91c4619f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/FKcNpgVh48PwFL3YFUoMLv++v15qc10dzjYx5GQ0E5Bcx2iN43BjisKcnYw?=
 =?us-ascii?Q?Q4GrYbNXrpleAhsg3g+wuKzq866rIfc3+C10zH6x82+nnYN0Zt8cfope+zE2?=
 =?us-ascii?Q?4I142AOmmHhQSulRV0oSS4EQq+uJeiQ/CLpJALnGJcZMYuluWNrbcIKkocnz?=
 =?us-ascii?Q?X15nGnK2P6kjBnxI54aWbpG+7ySVnKkvXUVER+8KvhnQ1KFZt49S2R6CKE7G?=
 =?us-ascii?Q?6Fw8WQEgGjNzAzW6VthonyowtNZFfXRS88bNb0FZcHaioD4dNK3moakXatV2?=
 =?us-ascii?Q?xz6T9OaG67XqgVLQxZA3/OT8WOqr1C6nlDXEl/laNpXWTwSNETr8AlmAZo7u?=
 =?us-ascii?Q?U4MUvd7gAV0AfGhkkzXMkLVVpT7/f20Er61UPOIvRvp6c9gl4tpwsk9DxVC8?=
 =?us-ascii?Q?IZHw+LIVAgCkmKTwHYkdKtRJeklrBjNa9B4VHUkrF8tp/9kGMFngyR37sRjp?=
 =?us-ascii?Q?ZG5bX7x6sdZRPQW0Gesegad+kX1t7YZUzcmy+L+cpYY/3mHypUd5+oAjlpzz?=
 =?us-ascii?Q?nkuSlAbwFpZrsqiguXYywu1tYZCt/VVur8vB+PEAtphkZJbqmVMnoHlO2Lvk?=
 =?us-ascii?Q?qcoJOd3Y432yuZbctzPOLa569UQalJI209T/kfN1Doy888azu2KYnbCDa6Z0?=
 =?us-ascii?Q?BcADJ4lVsnYmk+/n+efDSfibu3zRlf9L3Fr4S2kU2Xep9pKDJEeJtfhkjisA?=
 =?us-ascii?Q?7rBtQbf1CXnpoKIsVIahIdZv4Cve5Ulhe6D8waNWQlopBAvtiwJcOKfWq5oA?=
 =?us-ascii?Q?GNuXQ3VYDFnvnk909QHJvM0N5npaFMwdzwEZkztfhf66jqtYScyijXUDLmII?=
 =?us-ascii?Q?YAlzgntB8Xff3nJaxeZv+v9L3EPS/vNum8C+f0zmKsc6OJY5eYNZuIoH3EoA?=
 =?us-ascii?Q?25mjnWgQZFEryDD2jXTFFIeVVf2ZzATNHWM6YvyZd41AGTYeC9unlgjbFRk+?=
 =?us-ascii?Q?kuijgf0HPYeVLak/g4Wbg6ESONuX38386LLJRVfdLxWukPdRCFcKaFk7kmhj?=
 =?us-ascii?Q?hzzs0JbTBTbAcvltj2DjpPFWsmvL5g1Uav4GkkT+f63dFHuF0poMiFDQKA26?=
 =?us-ascii?Q?ftWK/2MR4uLuv2H/jYWc7Dt4LBdD+ty/lf2FtXyJVWxg3NhxLP/gKpzqXfOK?=
 =?us-ascii?Q?xzkozRA/3la8mi+un0WpqKzMx382euKmPsVif9JNvWbqv3oqGXExBY78yVh6?=
 =?us-ascii?Q?p2+beRWwU9tprCeUxIvzDyGlIls8mbU7UGt9U2mG+i9hFVpYBt8zAJrOa9if?=
 =?us-ascii?Q?Z1xFpn4Qp4Igc41tD+t39I/wQIRbYLPEmafbLaiaCnTRX2mH4+7y2uGEmiA6?=
 =?us-ascii?Q?h/RAovY1VOr6VqgQ62O4rF7AmPJpcjEQCIEsdQq13EqC9jxzGqQbafdEPtH9?=
 =?us-ascii?Q?0CriYa/tV8DB4hQjUhBA4jETc5G0QJL2wRwh8QfkKEpdt0YGLjInzHPcBRMm?=
 =?us-ascii?Q?kENCs0GZ6UE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?52g0NQR4843qQ5NZ83JPwbWy9mZWqmOO9hsSCqvODFhNAr78Zyx1eHjvhNBW?=
 =?us-ascii?Q?5pDNkJhvtY5RrbiaA/FluhEDVeu7ZcvN7caOiN69mxoUvyCDRjVaepndd+fp?=
 =?us-ascii?Q?O0xnZefu/WYQceE4UtwGImmB4vTc22geZHTJPFitNj4ZxN8ZLhtKz/BIFbYG?=
 =?us-ascii?Q?Nv331eMoLkHtkzbg3OUkBcjTHHU6d52WQQTEFTx/+ZlZKJS7en7WO4xM+w/j?=
 =?us-ascii?Q?2LaU+usq7Bx85nu7ng2Z40N7O7VyiL4xDckZTsJ7oy8QS/kDE1+B231eh0Mu?=
 =?us-ascii?Q?DEsdGMlGitYcWgdf4vOgnMrw80odOIrGuWoAhF7FZOE12YwzAWVfYVEK08tY?=
 =?us-ascii?Q?/L4Nrg24zI7GmB9onUBhm76vsCYDAshzg8aQ5qSo2cHCO143lSHuGtzmFNTz?=
 =?us-ascii?Q?J1z/CspT32/flwZ1aOINEA7OvISDg93DWjC4zRZ9vfxVl8M+sQA1EpVpXyfT?=
 =?us-ascii?Q?4pCY0CSnZNWe1bzfToS24al2kSAfOb2PMeUZTGWeVgWiLmmVhCHyxccew5yQ?=
 =?us-ascii?Q?o5Cpoi5Lc5VoPkMRStiBqMOOXbseTMcatQYN4vP/LuVtRYHmMbY7pXy8mbm8?=
 =?us-ascii?Q?VvJz56YVzwZNw2iFye5Ryam7iJqCw61rhGExc44hHVdQ8sU/wyVRLUVPf/XE?=
 =?us-ascii?Q?FTxWoYrmHWD5SuP94UVBdzmMRngulpD9IRUHKLsBn6g61AwlcxeImums+OXR?=
 =?us-ascii?Q?+dOSkLiddqbOtUqdGxDjTyZ7CcBuYRYANjI6LBRBtA6uR9Msik3eTNc8h+rS?=
 =?us-ascii?Q?hgZ8Fum6vuqIQ12zZN3hBR4mMS4CzwvrFCq6xQG3IjJlrI3SUQhkpDy+Tm2G?=
 =?us-ascii?Q?owGep52/IU8Tb7gxeSrZQJ/+doA6T7UOh/kbqaNc7E1XWQ+wQNhE8lOiiq8Z?=
 =?us-ascii?Q?iI6i5JDS9kTv5tckZivizP0857RP4fW+ecQTY6yULRZcETokvutuTQgP30n3?=
 =?us-ascii?Q?KAocFHr0k1zVS9m6lds9hgqXT9LE/8nr5nWWHdzaYtHxnjQq/fcL9E/EY4+U?=
 =?us-ascii?Q?tuxoeygJ5lIT4Ybvk1ECZpmiaMyk0agyzYRIHG4Z3NeHL4+bdTPBUVIzKiKY?=
 =?us-ascii?Q?HhB03ADjFCv8bGFqkEKVfR1oh/4tJ7ALUkqeD1Ez51TuKzCvc8a2pu8rNDtY?=
 =?us-ascii?Q?jF+RXXNyGu6NR5oND3bs/Y0WenFyfitQouuFFPbplxAXUgxeRX4oC+OIYe0l?=
 =?us-ascii?Q?kezdflj8MjWEoVOQRESJcvHFA1dTKIoFqcOp97ZN1LVTUnEdb3SEvcPApHH8?=
 =?us-ascii?Q?OE7BIrc4DzjlZGvX/oP0lwZ6yesfeFn7KXxT+jYnhA375o7l1LmiFF+mWCLT?=
 =?us-ascii?Q?eJcLSM7QIdOgYfHCZVtEwpFHY71VriUDQXDjI1hEhhKy9Eul475F/mXZ+X7j?=
 =?us-ascii?Q?GvRmg043ROd8OcTe0sskRphHHM9Wsdsuml4QsDiIHVTRng/X7W6nCP11MC+y?=
 =?us-ascii?Q?lxEszSM7r9ojT0dFcXuKhnDgQ4tijtYQvNvcZ4usG0zI7YWAv9ih8/aYGgFZ?=
 =?us-ascii?Q?qie67QbV9QJUIWWpWi1wCDoztC6Ck2xbc4PzdMHHe+tACeHXc6x4dVfK5oQA?=
 =?us-ascii?Q?X+601d9q01vdO1PhQrs8XIovL5USJ0hEEBFCe5bgAA2mrFFoBU8/R3jbszgB?=
 =?us-ascii?Q?Og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	58GcXMslkExAXBss68v62rwEoQznzItPP/JfJoIa6ZpN0jVprn56XCgtvDClXjVgF2s526tjJiTjY0Qr7CEMIX0O97T9spJQmXjlAQr5g2B1bWWjAfjkPc733fDtCQzzodsEcEJGXTbw6uCdfBY0Qk9tqTdbxmbdOYJfbHUp8r3l6M4kYEI0Tg0TuPWC+sBOrtYMl3YO6RKzLc0ttoueoDpL0M2WgnUmqziNrlIJcrbWPxij1KJSi1nwT3dAZw291VbRGCJbCGDkBeUgyRPUXQfEljQb1mg5rB9u/KJYbIi/BKTmJa2C9dt9Q4Wj/yqHXYlx9olWejKDy6BA6cizggkT2j6UhOtcWr4NNyRDZeMHP3HQ9/n4gAytHKML4dqbWDkIN+FTQh9XCV1Jx4ZBDPkaNt5LTvY3wbslDArsaYL3mekIiNSJd25d/pBpfTmt74jYxAhmKYf8/+ha/maiIQrC/ruGpFDHdQQig28Rko+tXzdRI9IAmejmT0V8GJoLloDEezng0hFiISU7g1NzoN8UoEXP0dttx6U9h3TrWVdtKJRsWdi0OD0lVPWd5LGpjRM40lPRdLmkkbFt6yjmd8kSgCNbisHquCGdazE2gfw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c559ee2-49fb-4399-6e20-08dd91c4619f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2025 02:17:59.5918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9f3CEGHbBDsBiaoFYz4++8VWDqYANo0ymnJRnFrazfhjP3o9p+p6mnTI83FVPtbfqZac8uPE//TYkOLkQ1FX46uGekyTwfOwQ/H/zhJpYqw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6099
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=859 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505130020
X-Authority-Analysis: v=2.4 cv=M8hNKzws c=1 sm=1 tr=0 ts=6822abf0 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9
X-Proofpoint-GUID: KPkyYGvxzgLD66fCU4WLgXfN2lnFGgH-
X-Proofpoint-ORIG-GUID: KPkyYGvxzgLD66fCU4WLgXfN2lnFGgH-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAxOSBTYWx0ZWRfXx/uSFwW9gRJ1 jTgre7VAa6g8AyJefIkh0IJJj27uxq5FX9b3jMWGLYbF1yK/xOyxNcnMLHV5hNa61Ib7Gxsmrap QRZk53K5TBZ1lPvCy1Cf2lG8fxtDkNfBz/HN5rOqxHwKRYIsrIT4dfTc0AXAPvAaFT9WngQLGVA
 dzYW8ZO7vjiljDeXMH9QG6FsPYBNL/1MwHK6MfMLzFgXh8nJetOfz8YgtlDGlbXWkabtc1TN3BM hjRUw+B7cC3ryYM/SdUmYk4pZq6iCipt9zEvgmSUrBoSFAi1sBN0W7O5/WLdsAbqVa5nd7Mv6nA uqat73LE2h/0ljBGuBviftSDv2E5Xx5TkJL3h6vV8J+UTxK0qT6AqrHX2cjNlCBEhqyXh183KbY
 lJakqDWclqOUA410jgh1BLQhxj1U8/FRxfmASaYQmPqkaqOvwTUVzR/G3LSJ/5+N/FvYLoBg


Christoph,

> Having a variable length array at the end of scsi_stream_status_header
> only cause problems. Remove it and switch sd_is_perm_stream which is
> the only place that currently uses it to use the scsi_stream_status
> directly following it in the local buf structure.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
