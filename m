Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62B51624EA;
	Tue, 29 Jul 2025 04:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753763034; cv=fail; b=Z9IDVLQQjJdUHC3tE7EbLVIvfaMoMTTav5falWpOhBsnjTdmKNZ7g8NVGFb853jhTqI2IBxHgId6CJAg9fpisrUlC8XhLjxi+ySYRHlm0ahsOQAisAN9/vkVd9T2Hjr/dbADTSMHwEBhmP7cFQwvSa9kGApvxms5f8XgFUJIR7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753763034; c=relaxed/simple;
	bh=vQqcGbbSSd+h6oYyc/tNaCLTE50OTD+LrUCEiwAFY8E=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=OcbrJXqglThay7K+qMwc0lzHbVvLwJcfzGBbmqzul7Oc6jynk/miNlqnfLD3NzIKLcsmn48usEH8Tez2379DZHPXInvvH3PNz6bzbNj7wAYEnGWO6AZHmgDibf3VG9GK2RHwgJ8QS5+eFZETlp6KXIEGS2NGqESuhTPdWnzYrHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GrlITxxU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wIXoJ54s; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GrlITxxU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wIXoJ54s"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56SLfqdj018048;
	Tue, 29 Jul 2025 04:23:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2QKf16twp4siun7A7/
	79mfcsJeQAARPfUhsmXgMdMaY=; b=GrlITxxU0u3Fa+zN9ehRHiiFDDjVxY2Dex
	lASqgfdhP/VLkqHzDcq27SERznl1IZ4Dl3SKyFrmEZP6ZgOhsLHWrPP/QteG1k+n
	cCbVeOb0v3q4AKNwJzuk6yix/sDorXofID4wVjztGVUOQK+PDHpgkqFdvg0lQhfL
	5NHehfMHvhU0jM6UMi8FMOrTJRvdO04A4cX50fkAo9m447ucbCrlmru0tvPjK2im
	QZ/Kr7XGihh3yLmeqVcxIFDiT/GD6cEGtgtnFNHsRiwO/k3ijm4NoUS2jr5N+NS0
	qizaJz0d+tUGollmXljEmsbWJeqUwcwNKE18FDCOo0T/TGahlQtg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q4yet5q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 04:23:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56T4DFvN021096;
	Tue, 29 Jul 2025 04:23:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nffpc5j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 04:23:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=USGAsBTq1zs6Ihr62LzLrbhmWQZKeokkHxPwF/vt6qsgshcHLAdjSPkPocou+UzQWIdiQj4y6uYFCDs11iUXjbrP+arN3Fk5qoPujKQ1+iEc2kJwtc0Cd2qKlL9Buczoxy+4BBVDCQ8Ej/nv360WKaSWu/HcNKhrVkWhuOMzMlM6Nk8MK5hA1fzpPAFP19DxwwglqgGAl77p9TIVOlqIbGbClclwp1/cT2ee55f30WBZn3GIz17+9qBMgfQobQB3f+Qy4lPWc/KYGEWB0nATmAPol1TZcvm6zX8sm053+lIJmR1C60TdJvvHbh7l1DTPNRLEi720HaKRw2SAdPDtQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2QKf16twp4siun7A7/79mfcsJeQAARPfUhsmXgMdMaY=;
 b=vLBLsJ7pt9y0QkT/8ANFkhz8NSg5Gy9wJTLBOpvVLgoVWTrkRIWnFVk/JfJYEgPzAbR1U1BN6XQGK+93VmEK+bB07IglX4bOSDvMwMG+o/7Amq0zFnB8ypn933sxFfyzgK+b8iL3Pjrew4tDPdHOLCqScDyKX/f9jDyKnb0mn1JoN2+m31hHpdxBTdrHTFLfN30LunuhQ3PEtOwkW2yWJnsCB9ERVi+BWyRcbK5xPi6x/zCbKel5jS8UQ6PIl0xqHCcO71XpLYIp9ijd3nDHRgZihgpny6hf9KfO68zQP6gfAJ7RK5BNfXVrjdFAkYw/3OHK4QxiKDU8w1X4RO+YGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2QKf16twp4siun7A7/79mfcsJeQAARPfUhsmXgMdMaY=;
 b=wIXoJ54siDCx2eRnL5V8i5MPWIDQtyz6wiemCyaH21m5I48tAV8/5m7oygrvMcRNDZKWcrriJGz+uaKfzOD4m4RqHvVH3XOxVcngrs5xWeSxm0MiHWzjQXjd3waeJKPA9nQ9Tz0roUYKvVIUTQWxKcYs6MBUP+BvpzmVsFT0JO8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB6899.namprd10.prod.outlook.com (2603:10b6:208:421::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.24; Tue, 29 Jul
 2025 04:23:24 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 04:23:24 +0000
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
        =?utf-8?Q?Csord=C3=A1s?= Hunor
 <csordas.hunor@gmail.com>,
        Coly Li <colyli@kernel.org>, hch@lst.de, linux-block@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, "yukuai (C)"
 <yukuai3@huawei.com>
Subject: Re: Improper io_opt setting for md raid5
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <c8c4d140-4ca4-9998-dea3-62341a28c7c5@huaweicloud.com> (Yu Kuai's
	message of "Mon, 28 Jul 2025 17:02:47 +0800")
Organization: Oracle Corporation
Message-ID: <yq1zfcnljtw.fsf@ca-mkp.ca.oracle.com>
References: <ywsfp3lqnijgig6yrlv2ztxram6ohf5z4yfeebswjkvp2dzisd@f5ikoyo3sfq5>
	<bdf20964-e1ee-45a9-bf24-3396e957ff67@gmail.com>
	<2b22f745-bbd5-4071-be9b-de9e4536f2d5@kernel.org>
	<6ab1be6e-380b-d4aa-dd71-f53373a66e29@huaweicloud.com>
	<655cb7e6-897a-4fab-a8ce-8832f2bc7274@kernel.org>
	<4767823c-2332-b3e1-67a6-2d7f55b48156@huaweicloud.com>
	<a1626eef-9846-4824-a899-2fbd8e369fac@kernel.org>
	<9c6f300a-f78f-de6e-4b99-453df377c7ba@huaweicloud.com>
	<fa2f9406-4ee8-45f9-a784-b5042e9f4411@kernel.org>
	<c8c4d140-4ca4-9998-dea3-62341a28c7c5@huaweicloud.com>
Date: Tue, 29 Jul 2025 00:23:22 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:510:339::33) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB6899:EE_
X-MS-Office365-Filtering-Correlation-Id: 33036121-1c7d-42c3-3438-08ddce57a8b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r9pb1tqjDBFxB8llPtOs4div+M+atjNIE736dKBet+02ngKI3Bc0W7YrgQc6?=
 =?us-ascii?Q?dWu6FJcgBE8y1CVFN/tEGvvWDmVxkF92gbNDxwMIfHr83KKWYA/f18OfW2fa?=
 =?us-ascii?Q?UTl+f00ur9fk/R6VcT65jUYgEMVoW/omdp0hYix7J0Hv9Sj4wCvPk9Fx9vgD?=
 =?us-ascii?Q?aETYbobY2j77eJb/MLX6f9dBDfVGMO3X9MQFacX7lI87kP1yipAVDQyotL7r?=
 =?us-ascii?Q?BdJfFxzaYjIpRVJaE4N4F7s8Hu7QzJZluP8yjKf7TXtw129J5tP1Vz67qKYS?=
 =?us-ascii?Q?3nC6n/dTj1teHRGKiHqTV+7/mT3dPQ8spu1BGRCnuVPWyR9X95A/UAtjDXtn?=
 =?us-ascii?Q?zXhYIOAsG8MPRTCpyMvEkQqNSZV3xpPH5N2sINLR54BTORyTKIrl3Y1FnDSA?=
 =?us-ascii?Q?sTogGpVjqVCjBjm+L6XDj+1rixIoZt+ZNUa4c7eOSW41o+SeSe6npcOSoR0q?=
 =?us-ascii?Q?NAGDemGwKvG0pb5W1HGZrUuO9m4Y/8qXlQ+0v0jqaUvxUgEln4rbK4LsXeIW?=
 =?us-ascii?Q?jCFMMrmxsRy0O16S/N9EdhkV0C4na59RZfOJ3KusULkrcL1ygHSfmL6SRpqs?=
 =?us-ascii?Q?FYx8HLLuVXcgO36cp0D/mpngzhnHI6bnvVOLLC0bFX+T4+IAiFmO4rcKjNcH?=
 =?us-ascii?Q?mWBxiDDzmFFXKUWiAvAkwdGGnTsSddDBpwUfA26Yzczrgk7FB0aqEcCJ4sOZ?=
 =?us-ascii?Q?Yl00fwzwHKEiXqcXhf/MPr2ELXVl3jyVPCgE0DyhjZ/++NFQC0IyXiCLCj8i?=
 =?us-ascii?Q?AIK15wm3TV6m3SqSvXdYULXIJ/s16cZvDWZewSNMjJlE4iEWly7nZymTfsdl?=
 =?us-ascii?Q?QdWJYDN4xKy0vKUyNDQQ0xZRXvsKz6ON0UGHQdrw9YIaO4d1QwtoXc0AyO5N?=
 =?us-ascii?Q?4bEKJuq7nuKLNQZgl1MHrmUvA0KxYptj3v9Tp2LdMSpLecLfHKlCaHE2hp+p?=
 =?us-ascii?Q?L4sYXFW85omYFhqI5a1t8daD7APpZLdBR4WN1xPDaIz1BJyDOOdw7A6/aTMz?=
 =?us-ascii?Q?vwKQ8Vy3pmp8HCOY7SXrLUshcQZBmkp364yJNiqc993LKz+jy5LDkuJv9QOv?=
 =?us-ascii?Q?8SOFWw15cxTSkrWDhDCNLYJ7MVRnUxUAlAek/jIVPwd4F0/44K1FFsTZD4G2?=
 =?us-ascii?Q?SV27OdAoTZC27w0Zg9W/fsVVNP6UFlt81UJGuN6XEZzq30RtY3YHInP3KqPw?=
 =?us-ascii?Q?AMESUAHVlMq0Zzd1D7HHSK3dclGq0Mp3eBU88Uuz8Qk4dOw9YI8BGtoumg0J?=
 =?us-ascii?Q?EgeLWuWxm1Iv4UrTlQGwYZqMB0FR4fbFagabrdfo84YjRi5SpJ8CfmjVRQBW?=
 =?us-ascii?Q?Z5GSXvGHu4QuUeZnn3O6HRnkv+Il3aHHGJT6QfwifZ9HE+OUlNa+v7ah9YWW?=
 =?us-ascii?Q?h7v9r9JbMW/0+ZHqZAzJ45Ar+Un80aqkr2y09qcSAUj6eJ9FufW0C4OJmDUS?=
 =?us-ascii?Q?4VoCVCcx0wI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rLxfQvGFBVff57GcPoZe2coX1IAMqYKpMYajsLZSMYZXL40oGebeyok4h+V6?=
 =?us-ascii?Q?96qGXhTknvYLKTNAFcBdabAVmK8aH+6nKNx0eR+F7vrAaP8w/le1iWP7yEEr?=
 =?us-ascii?Q?SgtvfdFgPQ3MMpvXEljvUztuhJbkyHoara4/qfGqP3rkuLdCKVBCYNg+weG3?=
 =?us-ascii?Q?qKHFiEcA2X1dx/0F0oKsPNpBSVAjQCz/tkUfgtU7Z85qoPAVPTV9bMEfFq0e?=
 =?us-ascii?Q?IpE5aVjtwotkZWjph2PLy9fE7a1UCWi5/haOBmQocF4QQFwnltbPrAsG5Dec?=
 =?us-ascii?Q?bDK1FZIFeoApt6RMjd9xXFLog/q8wrxajeVmpQaiQ/dzJ4vBURGOw9EhkAp6?=
 =?us-ascii?Q?EevqVYqzJDAj//zmfZkjMebcRfUrHe9On+hwvUaSCl0h5HK4ZLFtt2gxsA4U?=
 =?us-ascii?Q?hJMdPeFYI4JVmYbQn5beXGz2xamsYAiGaGh7JIqNW3CbGdiZRUa+Q8k33yAv?=
 =?us-ascii?Q?QsiaiJRkviWmppxOi+d5LaufIu16zaCNGdL55gGf9MSbo6pFuEiEyGS8onNm?=
 =?us-ascii?Q?U7dxH0Dqai45SSTT8zWgpi4xIM4KFemWjl1nECDTcbuLicQMOow/huSVrUBm?=
 =?us-ascii?Q?xYXFnsihZN2B2rjnGC2a2B9u9ANKYPsMsG7fZUGnU1sYbYsGmDfX5OmVeKeQ?=
 =?us-ascii?Q?UrXOJHY2LN9DpYUGrvjowd+CXF8rNkAgMVwc576kwrALX6eFzNgqFUCP/BJv?=
 =?us-ascii?Q?2/mBpx3WMwLshfmD+vkYOA77BsOz4tzWgokbSUCibVCgSvJvYYvRG9Uy265r?=
 =?us-ascii?Q?0pMoB+eGf/LohN6znJmFYerC8FzLBe5E4iPhrzT6+Z2A/xVgpZN5eNVm7foI?=
 =?us-ascii?Q?xzlK4lvFm2xieg971nVmvr23hmcM6W2zy2bs715pzJuRJo/L15hd/6bzByJ3?=
 =?us-ascii?Q?wrdpe+pt3mGfS7MNgIEKJgqOFjBZPfLYX35dVq3f+EfgqfQW1S0eWgGA0Rw6?=
 =?us-ascii?Q?SnANK83RIcpNLlO2GsPT8EclaJiYqBL3QpBtQzauQjy6PabH0++CmO9QIoaw?=
 =?us-ascii?Q?dfXCJnG98EoQGU1hw6fYzTE0k4A/cX39NcItsuBoz7wB4CsfeoS//FdWde98?=
 =?us-ascii?Q?qQjp12BQVakNYTvL9mgqlqABV8ct6jqwgSJgnfAAFvxfpKhn9xSO0Vvv8EB5?=
 =?us-ascii?Q?gOXGKb7RdlIuDmd5g2zTD+Nd40oo1xj5SSOEAVfAYV4OFFqXHN75VMP7YBb8?=
 =?us-ascii?Q?H9fWj0k/muSix72A7xuDJhXKC+G5f9OcNDDpcOO0QAt391JPUM1BGLqdH6dM?=
 =?us-ascii?Q?ObejU5PWm6XeGruwEFRp5aYr1ZfDzBAyVwqWPjLKr3UN4Wt7FzFZM2lZkQyO?=
 =?us-ascii?Q?SMr8wpgbRlX4cc9rYTVU0FeniUyoofkOSG8dU70qKLt6yRmkpsIdGETsOMsU?=
 =?us-ascii?Q?JATp3A5qDa1F6U+uAYWDz1zL9l/kuQWHsB5e7twgwbdfO9hNE92M33iBCiJf?=
 =?us-ascii?Q?G6cYG9hCeAJC7cIwElrndkt/3F0H1bvbumFtScs5RQqJQ+jqAq8Cp/RsHfkX?=
 =?us-ascii?Q?24Dp+0aR84qVm7njNBxH09x3aA3WH/u/Kio+vMEpsan8vYzi27XkvLuiRw+c?=
 =?us-ascii?Q?Wl1T8Gh9q1yLSOVyaesi5JiWi5emOxvejk0hEhHF7IFpqIHYL5owr64n46sr?=
 =?us-ascii?Q?7Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YqtPK+5H0Bo2hLjzG4cjfZjXsgFXQ9yJhYxKkpAO5fljFqYdEguScmuyhM90XKfbh3MkU96f3YnCPBynl8iLBXB4xwbqmF1w4dBqPTOhPzY6j5vzM9/tHud9GWek1hDg1x/RAPzUliHwYvC5hxW4K6ISdGH1HPJ3DIl/jwGwQkauKj/ERJB1RnzQqmw7VDBABswQLYAdgfhLRDMk2MdVWw5FMCqqjH9B0eHjmRdRgcgVtTMWntsiJjzgBRSHdBfYq5BvqLFcmXw65g61HanRFWJouvky1umDBHTsVAcuIy62l2er8hq+5ul3pluzESxCiwf+18c5sf7H3eZocdLigseXTI4v1obdy7JgczBCUXW4q7GH1Rb5eX/h7RGc4ekXUz2eGbblMGBiaIkIHNV3/L6AUyCb1v2qbKwMjvGOnguDKTt/lVcktkr4jAUG1teZN48K5l2LqNlWoZHAZHJ0xwzebmm+1Zr3L20/T6Q9knHQWGrzH4KGEPz/kwZ6TZA3idxlMdIrhS7imWrDYjFcsUbggsoTpzqbN7g48N2obFqc6MbcqDZoaUXVG+iCveP9El5TY0TyVHgauPnXoluQMApwg67wOh9H6vK+opJ2nBo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33036121-1c7d-42c3-3438-08ddce57a8b4
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 04:23:24.6224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yzNwwJ38zO9+/RtbinDHpgsdQtpes0KTkzJL2Tgo7/k78x1C6n/dNOi2omnhRi4XZuA3fiSTU+JUljH/21YzTjn/J6/mLxMvnYRiP75TyRs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6899
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_01,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507290030
X-Proofpoint-GUID: r11VjCA2TqMjyXHtc-Y1pc1pvx1nSnE9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDAyOSBTYWx0ZWRfX9diZJdZiTLiD
 dcEZic91TSYM+yRR9L/qMKq2QwS3eP9GmWBu8NhXqyAs73DHhRKqcT3v4ue4LTNu8i/rXT1Auvf
 HIVT3VYM9AIMpVVQDazGv5XHuMI5202lGsByjcxbKkAckxgOVCmvjXq5qAEh2+HerRZ9uIyEEWU
 S+Md0tnLCR3csbvnJ3Ur3emOxdYdHcYhTa/MpbdtwFJzJtA/F0+ULMHxUku5eVC1Wpe16n53cMh
 c4Gy7tcVaBBSFMiyYc98MXZ9Xz/Q4fUuy0qp3YYGc1ZBSw9EhvcOfrYQOZrZZue3mID4McgrBTW
 6jTskM9UMaFqt2xCrIkzZ98Ph51GDMNGACGrgJ5DcGUn3JVc2KH+NqsetPBdGPhERQVnNwM4Vo0
 w5eZZ0i4bbyTgqMCvrAAxkdI5AxDUjvtDqs0mRLhfo8bIQWTC2gEeY/6HyJa8FJ74pIHho0n
X-Authority-Analysis: v=2.4 cv=ZMjXmW7b c=1 sm=1 tr=0 ts=68884cc3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10
 a=GoEa3M9JfhUA:10 a=w_wZsh2bTFdgxw3ZPYcA:9 cc=ntf awl=host:12071
X-Proofpoint-ORIG-GUID: r11VjCA2TqMjyXHtc-Y1pc1pvx1nSnE9


> Ok, looks like there are two problems now:
>
> a) io_min, size to prevent performance penalty;
>
>  1) For raid5, to avoid read-modify-write, this value should be 448k,
>     but now it's 64k;

You have two penalties for RAID5: Writes smaller than the stripe chunk
size and writes smaller than the full stripe width.

>  2) For raid0/raid10, this value is set to 64k now, however, this value
>     should not set. If the value in member disks is 4k, issue 4k is just
>     fine, there won't be any performance penalty;

Correct.

>  3) For raid1, this value is not set, and will use member disks, this is
>     correct.

Correct.

> b) io_opt, size to ???
>  4) For raid0/raid10/rai5, this value is set to mininal IO size to get
>     best performance.

For RAID 0 you want to set io_opt to the stripe width. io_opt is for
sequential, throughput-optimized I/O. Presumably the MD stripe chunk
size has been chosen based on knowledge about the underlying disks and
their performance. And thus maximum throughput will be achieved when
doing full stripe writes across all drives.

For software RAID I am not sure how much this really matters in a modern
context. It certainly did 25 years ago when we benchmarked things for
XFS. Full stripe writes were a big improvement with both software and
hardware RAID. But how much this matters today, I am not sure.

>  5) For raid1, this value is not set, and will use member disks.

Correct.

>
> If io_opt should be *upper bound*, problem 4) should be fixed like case
> 5), and other places like blk_apply_bdi_limits() setting ra_pages by
> io_opt should be fixed as well.

I understand Damien's "upper bound" interpretation but it does not take
alignment and granularity into account. And both are imperative for
io_opt.

> If io_opt should be *mininal IO size to get best performance*,

What is "best performance"? IOPS or throughput?

io_min is about IOPS. io_opt is about throughput.

-- 
Martin K. Petersen
