Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3382842A96
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 02:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776738434; cv=fail; b=jOMNU9ahJPP4X1yvYLh+gPWW79ONqu/r6YReo4iOHmgoO4srF/0Af3tMuks43XZT7FvRWjwawxtzTTFsTlLewQFywDlWtBDwAeOrPFby+TwVHmZFSTk+va079qovvyyo4toyawxEhSq/FjnMYUpQc24Gelz+Gm+TE1/ojwYoaFQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776738434; c=relaxed/simple;
	bh=eJAjgu1aJEPKAa8kow3MY60g9VH3sEHo+yoMRcx3cu4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=dHRtbQP4KqVDeQ2A1WGi/UfLi2KJfmNdgkpmVFT3xrbWav7zkqpZHd+bW9K+W0C/0c6Ok7yANmvYGZdVXCC8vldkp87W0zeaOcTjT6puoGZBNyUy5aRG72ss81GNKpcL82sk/FuRSeed335zP6z1gRU27DrIO/LH0jXxmQ0p6Kk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b7Ua90EX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FGgBkUFj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b7Ua90EX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FGgBkUFj"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KLuM6q1996731;
	Tue, 21 Apr 2026 02:27:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dGQ4Jzq8vDQ6sdo51N
	Ga+zpTsscXl17K0v5piVMkA48=; b=b7Ua90EXXcdYWcXYRchaNWQP3YG0eCVthe
	kB1LWxqdYhTgdSZnaGIMwyXrcM0NkdWUzJp8NI+C9MmUS7VHd07YmiNMVQ00Xudf
	Mp2083srQEjDFobTDh8/hXgMe/f/Q8JeOBvZ9QAKarcHQpyNkJfV+zIaolyI2rb3
	CDELPeauUDvX1ug18T+KOwREyYMW+x8DEeQG0XGpwb/XyVUHq71VtXBeviJEuBWW
	B5b0zBEuMG8K9EY2fPpJsxxMtEJbltY+A4wVdrm1HWfKgdRgg5nhKxmtlV1tLEBA
	HZkFQBjfvdI9TWcZm9oY6FLOvLoa7zfLP3gmAI+QXhCO37YnYemQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dm2bych0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 02:27:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63L2QKYE002490;
	Tue, 21 Apr 2026 02:27:08 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010057.outbound.protection.outlook.com [52.101.201.57])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dn1bneys1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 02:27:08 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nBJDIXYsnlcmK4uJdGsGasQw5jS8xfzJUhuf08lcabCRk7R2GSGJtC39HjCQQ1fpMMZ9PjeJPzgorkglbu2ns9d2D7ufG+0y8F2kmORMISrkdXnFz3q55oVR1O391/fxmTBf46NXmz3ysRfiMKPq7N9j7SXJ+lNrbEPQXk/hwmqaBavUytDOvvxH6YPZzaU0VT3z8KbOI4kNMrx8ld20hYn/SIlijCBg5G+hFH7yWFD5GjcI7I73b4zFufLut1ZBlkTZeXZPvEv0J5joGR2zYgxm4BweZKVIxcTnu/RejXjr0QGuCGSyvtAetgIOBZepwDhGpwvCChM2Nb9fywid8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dGQ4Jzq8vDQ6sdo51NGa+zpTsscXl17K0v5piVMkA48=;
 b=SqdYlSY5lSqXkVfqhcmoPJo0x8gxNtidOiwoxtJucqS97CZEF75L469patt4UAmVLIsx2uB+xGGswOt3PRXTIfiwpCvlc+8Nvrdhq5WOQHeW73Ppete9ZGqJsnL/8ZKAPOIyqsaZJ1UUvZ987s6yW+KTdl/oSD0DZZ+ekzutVRmmElSY1xsPWoRp8c0xOM08YbWLVTK/YyzAJNAHUak+JccvYM7gV51CV3Tw5uRDIzk9RLHrOE71Fp59uCcDl6OguLsX0C8JiUkXIOAJmlb+7jlvfTt0UXyhIngjlnv2SjhaXssHWprRnZ2lPic5OIehlwmyQjqKmL/C30ew0yLryQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGQ4Jzq8vDQ6sdo51NGa+zpTsscXl17K0v5piVMkA48=;
 b=FGgBkUFjT4FCKli2q+mKfrGVlrgJTgHSKFm8O1H3zRi4qI4pVAiQNUC/1xjirQX/bie99JG76bDOnU6nsby0j4VAggYnFssBUyOXjZb0/+EGFk0wy2l9iDqIszr5EqnrhBG9/mp4HfWOcbRghPquLb5HMAoVP/UK5k6qySUbtiQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB997624.namprd10.prod.outlook.com (2603:10b6:8:315::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.30; Tue, 21 Apr
 2026 02:27:06 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9818.033; Tue, 21 Apr 2026
 02:27:06 +0000
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, Don.Brace@microchip.com
Subject: Re: [PATCH] scsi: smartpqi silence a recursive lock warning
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260414124118.23661-1-thenzl@redhat.com> (Tomas Henzl's message
	of "Tue, 14 Apr 2026 14:41:18 +0200")
Organization: Oracle Corporation
Message-ID: <yq1mryxoxoz.fsf@ca-mkp.ca.oracle.com>
References: <20260414124118.23661-1-thenzl@redhat.com>
Date: Mon, 20 Apr 2026 22:27:05 -0400
Content-Type: text/plain
X-ClientProxiedBy: CH5PR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:610:1f0::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB997624:EE_
X-MS-Office365-Filtering-Correlation-Id: 21a0cfdb-e38b-4c39-3ada-08de9f4d7b2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	7TxIlTjQBXo1VR+VwI48TfBUG1BV313aeGevNI/NXdudqVEcsEr0wDt0c9WrKtiVc4RyhIQvR9yhIMul7+Eb1s/6hp4a0/VpE5F1Xaes8xeUY6cdTWdybMYWbtEXE1AV6N16iLHj1t0XCILWXsECOkuUUPJZAC7f4SHOOqtzB0eimNz6SRdrkXT2IaYAwMxx4C443ksyAIbfQLoRCGotPeChDiPSMrbucYEoFg8+2Z7fkD83VnWqjRmu6WpuyJNwRxWTjuBGLyVs5ZgyHx4S/C6Dqj42jjDhwjS6DNePHFa3tSVDQokTsKEaOQp7q4SDswe37Bhn87R9vZ29nN+t2LP1b2tuviARI3hh1MSDrrfvC9lYIAF79Wopfx/QcmForDtK1qut+TmszepMEO9gnC/nCkxJwTGvhTC89n4igzebfPNKgSrmuPEyiYavbJHZ/d1E6G9ULyeoHWtA2+bczzPZeLd2H9ZCbJC+PWpV3XMQieHiHVa8/6W3xYlK9qAn77J4Yre4Tf1A3EQcLlAM0e7R81Yx6KbdOguPkzgXrLhkyviQy8qQY6vF0V3DNdcdF+De8uIS1JHxJ3CbLD5OcsrJoSB9D/woo/T1THIO3iAwyPsvk14pXQcTS+Ex7NhlkebNTUx6aaVZ+mR7MFLUrQO0Ev6pTilE27uf4LrNw7mIyg9VbMTDfm8Vv3Fr8+O3f9KdRKdWGtOET2w4V0hpcIGOpyvZSHCcBjj9VHjf+ew=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WJeWUylOd7iMvPeBsvDs0yRyOh0wmqo/0LL8JS87XaSqOHzdUMedjBgjbwD0?=
 =?us-ascii?Q?yWJ6U6RqFtz9+j2v6Ud9h/IvnlrHjao/HB5xG6O/nIApIIpjLSxBqmH+sIpO?=
 =?us-ascii?Q?bYbVzDgTWSonV/rfNYEsGNhJKhC4Ww008hZD4mL4Ta22but97TL2Lgnxd5Zw?=
 =?us-ascii?Q?RQTn7nBmKC07h9/PYIgu4B2JS9x+zEn9l9FgQcpGP84/ygvQcNDjLcbl/leF?=
 =?us-ascii?Q?H5L64XKc1dqriR1ZhZB16uFQgtMt2SsER7qWaz7bQ2cYkmqwBQUKM3lV0+Kf?=
 =?us-ascii?Q?ijAzXqk0ADeCAw7No0KaBqcnKbyV8aJ7ZBzXapWuU7NAC0LWDcwSLdtAvgGw?=
 =?us-ascii?Q?AFn9KhiC6iE302p0Kjc4QXAIDnHEAkvNySyQvEOqcw+BiVIhExsVyFt4aJOF?=
 =?us-ascii?Q?tqQIVwtUmxT6kiqFOxzlNrYEnws99sFZoPdOsEUuQJEnXpmhcQIakImuRlt7?=
 =?us-ascii?Q?DLHDNalhgj7wWXQp2/BTQhm2Aup03NF9Vnn16tomt2i7FhYI4UCbXzXvRn+v?=
 =?us-ascii?Q?fumwmnSue1YJz/beEu5aVmAQFHQtHjfUY4JfKFke1kr3OuivwgoZfGJKgjF/?=
 =?us-ascii?Q?Wll9oBah04GCWcUX6lcsRMESElIaWrLYmhwowDv5z5q39oGtSjEDuOwTUdtK?=
 =?us-ascii?Q?KcwDZwoplknHKBBydbnbKm3W6muZIveC/gTWqxiPyUWg88Qw/my+WjQxPSY+?=
 =?us-ascii?Q?l3QnxC1I5a27Nvu24JPnyayKYKfYotirHGjTqP+Z0p4THTEXkKN39dDjct8b?=
 =?us-ascii?Q?D8IdcXKhILA9dzG82K9yEp5H/PIO+rBAgv9qdfnv/h1fDoaL3cqGPh3jd7vg?=
 =?us-ascii?Q?p0yei2K7pvFr0YOc8l79ivvon8cSZUUQGXD4DP7D3h/EIEGupGr8W+adieuM?=
 =?us-ascii?Q?A8kurUIRG9TiJeMpY8m1g54PbzeBeY45Q9Ro/0khXwzyORo2TKS/uZxtQqi3?=
 =?us-ascii?Q?nX3jJ5Z1UqUBvFnuF+8j/0fgvBshsxGrc0t2OWvZ1mnK90xPotzk5snMwGOF?=
 =?us-ascii?Q?iAi6VQzFF/pLGU0eM3uNHJtbPNM7mHd2tnRLWx1qtz2Hk7Cf8wIvYXqfnNh3?=
 =?us-ascii?Q?t7Yu7Qh3kUCy9EEi/aZtUErRnJTWPZDY7aApodpWA1vOqV60my3kG8v30xTO?=
 =?us-ascii?Q?9i4miOg4JHSxGkNKQP1Ai5A3V6Emaj/Q4ibwQ62RH+XPqYXikL7OIxf3sNgB?=
 =?us-ascii?Q?utjCMRh1G5Hd7Jcwhv9Tsai6kTu5+swYf+6+HljSL9e9pjZ+kDWi4CwhAUSM?=
 =?us-ascii?Q?9kUDN6Eb3Hol4SeEr2KtDFfd+G3EuO9hCR35iN8rFVbVnOVwaPGYvT2uOS1Q?=
 =?us-ascii?Q?ZzQqUhdQrfnvoB58GZWPo9mLD/LEp3SM1rEU7xf17J0QIkrXG0F5zwAAEDAj?=
 =?us-ascii?Q?AGxlEYpMS9A/r1mDQ4C2CKJOX+76ylUxGW1ebAZdgwF/o0qdnfgOryvqwGKp?=
 =?us-ascii?Q?6DB1snDgCBKJY7cxud0AEvgdCjRqWPtvDvEyRMaNWyV1q5aJtdngfxeaof39?=
 =?us-ascii?Q?IbXIqTozrDwsgvGAbyjXBdwm5mBwTQ43jhLkXWtHHhhGpJvjuGb7eqR6TGOS?=
 =?us-ascii?Q?lJo5oxVL1dFDI/8eo0syF8MBzjNFzvYeCe2JKKXwgXkYgg084Kv6mh2mD/4U?=
 =?us-ascii?Q?UWSljnpSaGTzAZ6oQZ59q1Gsz7F/SEEW6eqXsktPYsTbOBK3rmmTuOP1+FYk?=
 =?us-ascii?Q?HSEEXU8jNX9ChKHGnFqT8LaXhb/1LedI1W8ZuTKFc+PmWOm4BwL9QwHMfL9R?=
 =?us-ascii?Q?8uyCUIqUrl5yxQyKtwfb55ZkjU4l05M=3D?=
X-Exchange-RoutingPolicyChecked:
	RjM3ZfZdGmL7o88Pucl39KXTEtKnUmVR40IozXSzmvvCqN/v0RyP1Ru/uMn2mBq90X3JPNXxGzruxBCIKFWF0IqAzf0Xk8mzc8dQU9kYrjWNpwwEOqKeIZdiFz4KqLiCXn+Ss+RNfeJ/eHq6EwCeAKKDNF4Luyi9nG+eS9lfnhUj1nPAdeZ5UEeH0hqXCSZ5mk1qwdYlEL/PtZgtH5yfPEe5rDaYmoumWZAU7geD12tTTtU0eSCvcpb5tZxLcOFlts+KeiacZE4hOfKVXJy1wmlPaAYW0bhEiG8/F5h/lKU/PF55iuEy5scA0r7etznQc4Ln9TxS4Xs5FVLjqtlFFg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aJ5K08Y79H6DYukY5bEjsloFjFWTVw7OLDiDqSY5SZheaOKEUxlUuHWm4c93pa9gOGv8OK4G5kWS3QFxqX0oGumrrs4MV9C3XMSIKSqhrKcHnFulgYKGRwKpcS+7DYMBXxgoe5syhRHYB0QF/N9/eleJNqJB0/zpwjMqWHx5lfaY5ox5H+bON2UZYLrBXNQRGQo+sH8qlzCjzniBc/40gP2Ej+xr7zP1KG8bocMNOzrazjdKi4G2NeLfhLD4SyXLh5r4SshaHBNkSkgDs82k1CxtTt4V6wlWLFPPTIlQMg4pDy2o12ZMMVfXQd1IcFoeX7ANQXVNA83+fLa4j0tyNN1kPl9J5jzRq9uawurugxrCmZko0tZU2KAfrS+amlVTcZM/LVbw+ndHJObBCI+6KCeX4Gkc7B9bTdzXVu/2dhyUryQvKCnP52sBGcZYGRyxITeBMTzTQ3dayhzQDzdQaO/jfe9eQHtbD5pVWRKlZH6xp8FyiPeRYxgVwPVgRO/OYpSVFQRHbgxdZF05kP1eB1H/Gs7Hp0VpqfJZVHHt/QblQrabOqqS509vLg5Ie7X0tIC1+7X5MD6f3mwEi0adx8vn/N7OokHncp9S1gHOezw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21a0cfdb-e38b-4c39-3ada-08de9f4d7b2d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 02:27:06.2406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b9xs6OVPi40+5sjLvRw05UtQGbIw9/eLdHD3CIwdoW3K+ejsI5YBILDXDilt4QZ5IkxOHwnz5pUTF0DjT9baN2+7NZLG5wnaFsveejaZ9pw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB997624
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_05,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=766 lowpriorityscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604210022
X-Authority-Analysis: v=2.4 cv=SO5ykuvH c=1 sm=1 tr=0 ts=69e6e07d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=nlWIzMlcSzFcEpfx2W0A:9 cc=ntf awl=host:12291
X-Proofpoint-ORIG-GUID: 5L6ADqAl4UgRZLf_UyCWRQidgXr1DnyG
X-Proofpoint-GUID: 5L6ADqAl4UgRZLf_UyCWRQidgXr1DnyG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDAyMiBTYWx0ZWRfXzkA3qDQ6ZSa6
 kqmTs4lOJMaysKnF2muhizuzwlh3IUqjs6n2UlKsnr6ER5u9NLBIMFo45Jrnd2TdYfL65kOY+D7
 CBczfQ/9qeLekD7mWZlUPgzXzCDN4MpovmP/MZBbEMc0ecXSon9x2UbKA/rXhN2TeUs/yONkyMc
 wa+Ev7F5R/f+JeM80U9aqJaDkeRfXvlS0g/eE9KjR//Ww9PIYiOHrGXjQnz0cddhUwftApvqaEt
 jjp9zD2uiT6BM6ulMK8T1RBRrsFH/LvzREbNf6DtaIGL3efo+3V4RvaCcuWuc9oxJDPu4DfyTnF
 N8u/I1MFyLMrPvpBKZY6dDGrup2I4EW6Kz37D9iKIkrExHzD1kmVHh+6R4lC/ekkDRbNmbXIN93
 Rp4OSs8ZDQCCXe+QZiZIckEX2G2vKRLw9XJQhCGDyxj/fObKLt1Oc/CpNh94G7jVXrwBW2Ca26e
 s5srp/Rc2Znipxuu1pFH0DFyIFAYGnU+p4Yeb2LI=


Tomas,

> On systems with multiple controllers debug kernel shows WARNING:
> possible recursive locking detected during shutdown. Each controller
> does have its own ctrl_info (and mutex) and that isn't correctly
> recognized by debug kernel.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
