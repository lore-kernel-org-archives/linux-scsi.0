Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FFD29A2
	for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2025 03:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761274828; cv=fail; b=hwTtbU84Lr2lv5C3zD3/H3C7rCdLHJsAA1Nys6gT1JyCMiktDcsWOQfzrH9MoPxGULiU7EEEgHivj+eZ9cdCqdGbyG++aKPtxPAIrPsYrn/Se13WRbWUvLnoWO9jdTrBNvyDIT5xea2GFyCNxTrUMkg8EGFXTy1k5H4JslkFZDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761274828; c=relaxed/simple;
	bh=TTzkQKc5Jw3ob58fhhTmx6V7WzUPsotKdHfY4iq0ftI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=NVbqNSlRvC2NAOPVjxcKoe/ZoqgahgV1yIlQG67pu2LMVQKHJzVSRkKMhfToKDdQfVrYdaVtDzdhPARxahTcIKGiOrhOluSgVb6frW9LF2N+znp9BUMHrplRhT5bKM30uzJbidma4eVGg1HJrBxYWk6yUwKBZg8KHwUKmAC4D8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c3AvCTXV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fgh9zY58; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c3AvCTXV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fgh9zY58"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59NLNN6C023960;
	Fri, 24 Oct 2025 03:00:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wNgsJX12IrMnUc5JXg
	5WO4Xzz9nSn5zUmKwgfhymcjE=; b=c3AvCTXVcbvYzq3nzsEDa2Jxu/A/aO6eqa
	5X3RqGOqiaSHiTJZaNQSkT2VRGKZ1bApCc4u2+3HTW6fS6Q8A9eU3hqpHEmL6IYI
	/OpwProvltK0IgCtQ93QfFSx2S+pllXYWNRAinCxE8du9l9QKpb4FeyQfRTFngJ4
	6zgaQNP+ugRE5JMVuwpxTBsrzZAlS1rkpX5SvhFfqL0IUY+DA1W8IJ7wcScv3Ecq
	HaifDw5aVdyVbHSl3Wb3hUND3zb0VgDHGK3tABg6F4EPG+9JqLfbyX5hQiA5RD8j
	jft+KzkKbs3N+4/9ROzR1gCj4HEAiWFhsnUvAZrh48TyR6c6s7Xw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xvd0utxm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 03:00:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59O0vTAH022256;
	Fri, 24 Oct 2025 03:00:09 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011047.outbound.protection.outlook.com [40.93.194.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bgcxnm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 03:00:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZSQUJTOo0+VX8kfW/xjnmzLcKDDVkHF4xwHHoNKIF1Um4FJPD1XIGlspvvcYcqMYr4oj/S8lbnMWIodDfD3pk6kO64wkrWCY7iB433bFzYMoqjegO3d/pRITUWRCJMi6GqKjLO1uJBNg6j42sbTJk825RPotE68MeFUOJ/hOEfyxuc/Q73qtddiUianV5uPsZ02a77LV61ASZkqmy4yl/QS9ZaexhG8ypV5Sp8z8Ur5TWNMwoDQT1L/fj/lWFQiOLy0CC+zLEUDLCaFxwwtxo2kZN9Z7+QgnRrQMChZ6UZxQ25xt3cOJD7p1w+1c3tNqggzNB5/qKNed8Rd3AYSCCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wNgsJX12IrMnUc5JXg5WO4Xzz9nSn5zUmKwgfhymcjE=;
 b=tDLPxpHF5oeJ9TAdzs/YsBr8R3j8UZ5PCAYEP//IJ8t3haJMLF9AW2R1s+V+E0B5mNFIU3QrO8sChkWPmgpzdXVvTYKN/Q9d2xVbaCzsY/iGfbxqH/TVLnQnugSkSwAPgPIFIa+tSawhZZevF9qi/uv5APFpX/F1DbFXwWbxigYmOA8aPMUGLTwWucAx9fzc0vd4eq/o8645D/JAw8FONl2f06H19JkV6WKbP9uztQGeFvA9Df+3uv3rZzlqOzSzSpyHLBKNOmAh/HGxfHUG9peV2Ocefhc0eg1lWvc5HdHNxI4wPKrwYBcn+GjocKNwyYlhzKTMNilOABw6ffJ4Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNgsJX12IrMnUc5JXg5WO4Xzz9nSn5zUmKwgfhymcjE=;
 b=fgh9zY58t3/7FyXdwgP8vbUmM+OnzUClGBqlCfDAR9+NuzdrWiB2SmrokROZPbmkX5XDYULbN6lSYjd5aFLxYXfB196UFm5+6X8PcN84A3QhaaQR9JnSGhYH5q5rQ8lbLZIfmsgfHjEQ0XnGo4lD5IMtUNdw1RDJPITL42dR4M0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB7512.namprd10.prod.outlook.com (2603:10b6:8:165::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 03:00:06 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 03:00:06 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        willy@infradead.org, hare@suse.com, linux-scsi@vger.kernel.org,
        bvanassche@acm.org, ming.lei@redhat.com
Subject: Re: [PATCH] scsi: advansys: Don't call asc_prt_scsi_host() ->
 scsi_host_busy()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251023085451.3933666-1-john.g.garry@oracle.com> (John Garry's
	message of "Thu, 23 Oct 2025 08:54:51 +0000")
Organization: Oracle Corporation
Message-ID: <yq17bwlxavq.fsf@ca-mkp.ca.oracle.com>
References: <20251023085451.3933666-1-john.g.garry@oracle.com>
Date: Thu, 23 Oct 2025 23:00:04 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0162.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::35) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB7512:EE_
X-MS-Office365-Filtering-Correlation-Id: 853d9a8e-8b43-45a4-58ad-08de12a96fc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NXpGvS9Hdvc1nUgU+VF1LTmSeZKEcWqzC6BN34fmZhi5vrRToTQIijgViVPe?=
 =?us-ascii?Q?NQ+zQ6gpODvaHXl3XMuRHqpf8Z5Y9SHr8PEa9F30IfzzfrVGw118HjWJ3X/6?=
 =?us-ascii?Q?rpoaX8hFQ/yI3O1BdBcOrGQlZVV9AUWJfhYFXkjd5vSLCxZ0xktrnAWTmv5E?=
 =?us-ascii?Q?jrNIgdz+qgNL8vHMWp1Lve8qwcFIjkHAgY90l87WRPnW1ewdXZ6Q7mCePLU3?=
 =?us-ascii?Q?sQGQHU3Cjjt4uTPzn7AKbk0slVL19Q8+132EFon0NSw5z1fOMZwVntr7kOIp?=
 =?us-ascii?Q?9F3J0rrl+I7xtKFIB8BWseJMCFS0E+IXq0uQTe4vJyFgvD6bIq+bLjO6WKGJ?=
 =?us-ascii?Q?eX8vi1xCm1G9skK5dRfca5lChxT13+YKyUWlRYVpVRyP34+2ticyFp2WpT1H?=
 =?us-ascii?Q?0/P+JuDDP/LF88KZtMUKwQolZ+EjallF8pQfOinEKnDKlB2gIphJneFGniTK?=
 =?us-ascii?Q?Qh5ptfac0QDpXFDb2Hac55EMZvaL/7HH3Mpqba8U+cJbRCayEOqhwEtQn5t1?=
 =?us-ascii?Q?u6v9l6amdeI4usII44tX+yz7pDfNHYfGVAXPfcEM3xtCfMrYm2l4YOPp2lA4?=
 =?us-ascii?Q?0wOiUsBJcvyNc2e8mSVROkPtU/hC6+7W6+8QEYPxjgqr1zjpCyHGafLWZjBu?=
 =?us-ascii?Q?IZ6eycUHt9okvJW7csF+2AN0hp1O3s3yedJKHJ+SD8N1VkBIh6eTNhIVxRP2?=
 =?us-ascii?Q?/zcGMxY+5rSz3r87db/mTDHrollbqUzt6KogQ3W2YDQBn5WzSn0KEL/qvY9V?=
 =?us-ascii?Q?DY/WenFGVUdWIDXX7g9/xK1lBcWBqTFzE8az2w6UNdfceE9i2Y9lixMV36z8?=
 =?us-ascii?Q?7E+sJVIGjshcovbsABtbLBTCMgQ58hmc/tPGnZ2Ryq+H98RKn9IQ7NhgjAxM?=
 =?us-ascii?Q?IVJTWIhLhJNxrQ2hijMccf3E9VQ6dNBBSNuvZvwXBMs++Q5OYXOypCUvMm33?=
 =?us-ascii?Q?U0NokOxbvexa4JzwJW5ATkzlOy9rjy+Qj3ozeyrXxsbfZPM2ZIw9i8+5KC7V?=
 =?us-ascii?Q?RyNYJ511ZNyUqdOMm96DF4nkgH4M8W5rmJQTsOSk63ZDvGnhfa5+Rju4f1b6?=
 =?us-ascii?Q?BN9tA+hHr0Ugm2NQ/h6F9x5JTIT49quSZkcnsAn/O3hJaS0D9pmc3P3/tG+P?=
 =?us-ascii?Q?2yQiUHPA6/8IjojBrMGJfkUA1GrvVOuNSpJ2cLunme2kQCDaJVWHBjkHtMcJ?=
 =?us-ascii?Q?YDSgiPoNZUzUbTc51sik4S83j8MHZSGJ2yi8Gvzo+9aP3jBgmFbbIMVvVy1+?=
 =?us-ascii?Q?FL33CmNh6Ms4NkFMpbN4xier5UTmjkxoqpLfJXs4JXVyOH/c3V1PDaOuHCpL?=
 =?us-ascii?Q?TtgVQe1zKa13pPvfGrjFT3uhIodrm9I3X65y3vFlf4b16lktJjL5NqHBT1Q1?=
 =?us-ascii?Q?HxQipyudWJNIYX53MONVAtBpWY2gHAEi5L1IIP9ARnoWh8UqqeqvJBTvJ185?=
 =?us-ascii?Q?fd8wVPgt9n5KefnOLxNn0nzIAnlIwvIR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4zkaxn9zzV1fmbY44B5bfcOYuyhBDYRpnIxXjAc4UDU0L8E3DJPE+YW3u5Pj?=
 =?us-ascii?Q?eJci97QYkt2I6D9UrYK55w4NSq+xrCOHh2GzEplQybms+7tIQJ9u6VoRdYpE?=
 =?us-ascii?Q?CNzKZYm6fs2v6nDQPcfI1dEekX7jfhMzTEdfyX1W3v6toyGFy1bwG11FIMo8?=
 =?us-ascii?Q?LT3u2cpf4K+hHU9ZnmfNH/XRX5Vyybn4z6AfB1tl16XacDQ4xZpOUbAEFka5?=
 =?us-ascii?Q?M7xqSVA7yVYFTe2gapnma7NnFkYx9RzJ+nxPrN+ALErJ8dnfH11q4RUWMu+W?=
 =?us-ascii?Q?m1X3HwK+NHGA5riTzlrraFdYzpitKroUeV2ObgAfkxWJybFEAe1MONKgRfJ/?=
 =?us-ascii?Q?rBctsvwoAluDl8caKcc/4k1jDW1E6rWFDsE7dt0hDGLhK41dDLbR+ukdaDt7?=
 =?us-ascii?Q?Rl2qZfSWOgrZC+brU7g5EM4f+QkD1yZ+b+ZQiiTXrG6mnES4n0iikaxoGZtn?=
 =?us-ascii?Q?rkcYsP0zwnwcMqq9xXnjKHAIH2fYZacZ/HIJRfntRvTsCkMJ7rymBnKzKH3W?=
 =?us-ascii?Q?YcFUqpNtwr4trx/qyI26cP/65ewH9LfqoLIa1Rg1GT4/rCCNWfO7Z+tx7SkE?=
 =?us-ascii?Q?+afRmV/6Co/E9XjxEktHhLIobTgs8sdHcz9tCCiP85P1DVlP1h9qy+dfH0oo?=
 =?us-ascii?Q?08ZglUFS/DzLKP8BP/wuALxzRZ1NYyKkeBAJho0SKUc/Xd1xoZnVtHi/QLQK?=
 =?us-ascii?Q?DYL6yjoHawS1qMiayPU8GvkruqeVWWaVGXFRsAdiahv/ODX6H8oqWvkTwZW2?=
 =?us-ascii?Q?qp/arsLXMRCjwq3GgfyePGtHWVv9H0KaFZcOXVEWGfgdq6+brIH0q+AT+zVV?=
 =?us-ascii?Q?uHofhoiHzAeBjYLiuht0fjU1SoCeWwnGr9h2BP8XNZwlLAJ/ZG1LIcI/aLBP?=
 =?us-ascii?Q?tD169mTYl2KhJioX1gOBRRRHcrkT9AhneLVTsdW/OXnBxuSl4QrMWDaGX8es?=
 =?us-ascii?Q?L45E1GGklK/eqg5+S//5roIvENE0U+4mY87z9t46SDtwF+dVA759Ta+vUMcX?=
 =?us-ascii?Q?XNHHx2ZaPl7PHAAIWhm7GnOHKNeKj8rSBAJT2aAOJB7T9Um9FT/dyBKS3aOU?=
 =?us-ascii?Q?sbIac2+8FSpFX4NpE72Wand2/4YhjnIwA1+9tAunAoEbBGLTCLNlh4weeB98?=
 =?us-ascii?Q?JAqzLdBhT7zle9E/1LGl7zkp29QZIkhbFKOkI9EjRbuFZC/lYPIDjWn7ifqL?=
 =?us-ascii?Q?hMczu77QPp68MSnv7vfKFN6d2k0NtVyRrLrVw/F7SyK6wEBH1KNDkBRUixeH?=
 =?us-ascii?Q?xRkroEQEtEXGRNLKO2hE+TFKJMI19XtQaVa7jDhuDRXzNG/GqVkJ+89LiGlC?=
 =?us-ascii?Q?nRFm1WJ/6yXm62v18gSWeZVhcrA8u10sGOvXzMZ0ywIIs8zhJqtfVTAZc/Qj?=
 =?us-ascii?Q?5CrkUWsqKiYQtOyjI+NnvaOVdCW3fyIy0gvGSWwp1ADKdT9uNB2vfpAym7rS?=
 =?us-ascii?Q?22rwmTyJOFXNCMbG6mvhW67/cRyhEJf8bp9qPuEpykOWTAY0yElu2+giRm8z?=
 =?us-ascii?Q?2H/ZbALyNhfaQGuOeLeMMIJU9WtZaqOIrexaQClG0sFXq1Ri3AbEyGZu51oD?=
 =?us-ascii?Q?hAng1/oOOizESiUescbFnGBzlui/HsCGaPDcdTWoJct0z2lVAHYSgCkciqRO?=
 =?us-ascii?Q?1w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZSLOrWw8tbkwD34QL17lY5h2kIjI5+nInkXxmM9TpACzUwXibOoM07DXDJtLWMaU6ZoZYTnFC17o/p3JxlWx7vUIzb6meTbU8GtEGknVUPKenI2dffU344Olc2chRxLNE5NH3TAKCQNxO/8dHFI11ASllKdxqhUvMUDmELw9zUVhzmxs3ms9S242D627HT37DqbluCg6BwKHtX3UVpZqpoOzB8RSCTO+Dynm9mMhkOc8P8os4zXIWDF+CSk98xmogY51wP4SUeetpHWSKKCkssnn+TLkfCzHfO/XnsIyB+IsIoTslEeXUYLBeGSCIgJ+2qT0Lfp0IaS83+GmQ5MIwlrlZs6D4hwvM8uYB/rV9lHH/HUcPVNq9trfQBRGovL9PiPK6MkVzwE3JDvFiVVqDR8UazeSky3OGF6y9f9iYnTd6pJ+TOwamQw13FKaE+pQVjkkFHw8ITt7IqQQQO55UShESy2+AaLAVRkpmiv0Juc3iJMw+mFuJLXBxEZ+FDsYyOMPzhIF2ixYnSC+IoH7VKekANZu6DCZowHUDB7yzjTPTG39bIONcejT/8RakgM7sFF1cmw0UxkIFWltWe/BTgcSZ1U4XvaWBLeA4zLBB6Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 853d9a8e-8b43-45a4-58ad-08de12a96fc7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 03:00:06.8599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7I9jIlU85EHQt7EYkwoUJFDgIYldNOPp3xsuZdKWvsYm+c8FbWqg3dTzx/KAyV+JGikjbydi0tIgIJBD2FOeGENrAL14fUB7sh0EzNdlpH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7512
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-23_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=827
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510240026
X-Proofpoint-ORIG-GUID: 9VaAujeuWffdnOss3SFisFwGBB8SjnG1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MyBTYWx0ZWRfX/c5cg5SjQ5b6
 2vV/xCnPKLYKcXtU/CN5naE91AjSdfB96OfweQV/5UL3vJuhA+7+SYwAMy532mDOJQeXULBS7zs
 331Y3TW0M6/pr6q3RAscvfCdOyK8i8tZ5ETAYY9ZAAMlnCpOX+07omrNTjPlqL5Ojs1OyMaJ5VW
 1LdyfQSoeJIX75pgazqhz5+qj+2L6yujCzLZyTlGRzkvjI7WFiX5fCGaKv9YGrAaqQ8Ic9MJxAQ
 ljpH48lKc+Tzs1KsIKFR7bKdg0gtNG9PTmA2SvVbm61fO6Iz5JLfxWYWSrNzilW+pZWFtdKbWQg
 WLH4WNDYFibPql76FiZ+jP018/UzhypOmplT1a8DMJEQ77z8AXU6FEptfTY9H/AktADR6N2Wjoa
 prTEFWmeAdNSVfF8DUnQ6K6ZhWDcL9/cMSz/5tgukaiw52jTP8M=
X-Proofpoint-GUID: 9VaAujeuWffdnOss3SFisFwGBB8SjnG1
X-Authority-Analysis: v=2.4 cv=D9RK6/Rj c=1 sm=1 tr=0 ts=68faebba b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=98RGhV0BuE0kd5lWGHsA:9
 a=zZCYzV9kfG8A:10 cc=ntf awl=host:13624


John,

> The driver calls asc_prt_scsi_host() -> scsi_host_busy() prior to
> calling scsi_add_host(). This should not be done, and has raised
> issues for other drivers, like [0].
>
> Function asc_prt_scsi_host() only has a single callsite, as above,
> where the shost busy count would always be 0.
>
> Avoid printing the shost busy count to avoid this problem.

-- 
Martin K. Petersen
