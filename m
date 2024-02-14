Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3043A13A89A;
	Wed, 14 Feb 2024 20:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707942069; cv=fail; b=gVrwG5scKJmMLfgN6XKZvMKkV6r0X2E5AbWS3nr9zef8Os/Qc/HcILXglUL1cJdhVGHu/mkdAG6QYFQNvbVXVQeGt3rJYEWZXGUgfiD1KD8LTM8enYGSsFUbXODJGrxQ8leLykwC6joRRpRpOdsKk1g4r1lfdRo/meCsOUyKdGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707942069; c=relaxed/simple;
	bh=8RWZO9jSrJSQVvlV9sa1x+YuCVtQhNh21tFlDjaJHrA=;
	h=To:Cc:Subject:From:Message-ID:References:Date:In-Reply-To:
	 Content-Type:MIME-Version; b=iFVU9ZoiuH8qO6ibjVWHFOXZSyYz8ZMhFn6XgCdy2GQWDMIe7hpWBNkMxrxvF0YVkvaRAqiG7irrwBRVZG6YssR/AUL6OcmP4kDtvrBPj1ZCt0SftuIAq+rXd8LVwoMEQkqavab7SbUXGPVeOWVgISE1UQ/Sr+YIlELoMX7nnOU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UvaP0SGQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zOY6sXLj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UvaP0SGQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zOY6sXLj"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41EIdevC026498;
	Wed, 14 Feb 2024 20:20:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=QcDVfIJUeBiNWj/4dfEqxy3sGVH1v7vcp/T7J3Hho88=;
 b=UvaP0SGQUNJ0qVKD5MGHkPOVOxfGtl2dG0iOl1z3b7JH3FUkD9MVreoSC3AWZ1rAxE5D
 REwOrW4QTYVa9WY3FNIlCsj8EOel6q3V+26WE8TEmSk1ziXNHZZ1NqkMLXhAOyRwlfvL
 be5wN5cGVxh+mKHLZsPhKQ4+HHR5XZ+6KId0deQ9VtbDeR89DLxgu+rLZ3ynaeHuxuo5
 jfkn5mzjBcNVIEb1JJIhV+kZYfFLWb8oHeH/0PW/L8f6igZc7t9nwJrrL5QH0u7pzT1/
 x2c0P/i+0bcOCEJsZoCRuIpjR8x2lZ5i66y3XfOL4B3FcsGWqxdlR/AMPgh08G8dDHbv JA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w9301g72n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Feb 2024 20:20:58 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41EJaamS031501;
	Wed, 14 Feb 2024 20:20:57 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w5yk9faqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Feb 2024 20:20:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j05lcjYOb+7fxOSWlGlVs3eQCtdtlMZ/+t8cYeTr4w6+OuW3HdDKrb3xcsxWfZIywwoZZbrEDwsrjPXiWS5QrrBMGdpr0oK5t7EZ2j7MHyoR6Sn5bSNGUStI5JmlhVQ0rmkCOfkOIZcdDx/NEdTH4FOz0YhZSYPqzq5S4yuIq2sIWNwmB2eU8C0G+ILnEyQ8CsDbkzFIZsz+qa02A/B2lSdl+2ytJsac6Ly0TcD4a7//pLm0ubFsAhyOmjAeNJRhjk7nrOO858rx07o29OeCLwViBXSJQPoblQYk85fUP8PWin5srYtmDIWwqcjuIEOS1QPMKZkqMzAz5hyZw3NolQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QcDVfIJUeBiNWj/4dfEqxy3sGVH1v7vcp/T7J3Hho88=;
 b=dWBbOthDJJGSA94D1ui5a4fmirkWB0dTJupGSeY1VRo+ih9G3UU61wYNRcs+T2qAgpwq1WfFVejc5dfyV+ObLNdUeRj+d87E2leQgLJnv40CTUISuqWsFqcyXMz9WNP94iots9a9dP0NR30K+xpoOqsh0JMYBlZ0EE31yHJ6l4Zx1gaoh9KMD4MRklgFaRnUK3wIf9BXgN/1ccLMBzc+NH5+Pk379sZeDV2t8mZmDrp/bFQWsWWHjNRYhaF9+dVCW0rb9o7IuzMVWt8KEktg/wMRmiOw0dzyOp5ZaMaFmlu/Lx6eGpAm9uyukyA7r97sWO0bgZtaozyLLc8xSleLkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcDVfIJUeBiNWj/4dfEqxy3sGVH1v7vcp/T7J3Hho88=;
 b=zOY6sXLjcHb51djbvvsNHAzgZAoAmmeern5RoXleAKr/u20gDmIsM6pNBo3G6e0NxQ87Iz8lUOe74VOER+X+uj5ECNp5qZ1lA6kyuztJazhCjX8wwN0pon1F3hbCF5yyCZ+6vdzSayTWweW4Tble8Nxbc2JKx73RGe0UG+/hFNA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB5647.namprd10.prod.outlook.com (2603:10b6:a03:3da::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.41; Wed, 14 Feb
 2024 20:20:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1b19:1cdf:6ae8:1d79]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1b19:1cdf:6ae8:1d79%4]) with mapi id 15.20.7292.027; Wed, 14 Feb 2024
 20:20:55 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        belegdol@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: core: Consult supported VPD page list prior to
 fetching page
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1plwyhlc6.fsf@ca-mkp.ca.oracle.com>
References: <20240214182535.2533977-1-martin.petersen@oracle.com>
	<a0f6d397-8162-4e89-a1ff-99540c70fa00@acm.org>
Date: Wed, 14 Feb 2024 15:20:53 -0500
In-Reply-To: <a0f6d397-8162-4e89-a1ff-99540c70fa00@acm.org> (Bart Van Assche's
	message of "Wed, 14 Feb 2024 10:44:35 -0800")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB5647:EE_
X-MS-Office365-Filtering-Correlation-Id: 05037362-5e68-4200-92f9-08dc2d9a72ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	ADspnyoCDJkTrbiPG9xNH4TbUOI5t7Nt2bWT4nhHMo3u+LGmUvLp94zWMLvd0YLwm+ocDMu89zKKvG8Uz9z+qID3hd6oN0+8PB3brYNKBVvL63996CnHzvgOf4XpdYFaPMHQT6oZQGHl20j+zZLjtouWLSyuWzxoW8eQFc8x/VfoKQwvmd9xl4ov8VwbIibYvsWnzJhS7ma50yT7Mil05k480O4zX/o9kk5F8qKQHpnEHlYy0wcu2p+4ELC0QEZBKnq3oIygUGfXXL8iT7FeVqwaBf4LiG5Xua/sLFRODX9W84mNHrIfqLYewHpBxDAemLZgNnIusPLKnqqjTUZg3BWLbRMMA8zTeYdA7xEGW4vGmuEZaCxIJ8gEkECWnMQEUKpGQHgJfnzyfMEJP4Sp51HGDApVdvKDCsR0aFRr66Q797TYO2v3QOqHS3w7szJzwYcCNxfFU0q29lPwcRbEVNoUxFt2NID6rw8coWTG5rSTtStFbjF7UYj+HxpPdqW8/jvPSO+2d+wjb6XZbQOOIY9DMS++4HIvthemk1+wbU176Qt5tJ+9LLUSRorzVabe
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(366004)(396003)(346002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(66556008)(5660300002)(53546011)(41300700001)(26005)(478600001)(8936002)(8676002)(36916002)(66476007)(66946007)(4326008)(6916009)(6506007)(6512007)(316002)(6486002)(86362001)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?DBu6ckz9FH3h34eO+TtnGXIbN5mDRPm08QTzHlVerNtX+MOzSV0DXD5j22bK?=
 =?us-ascii?Q?jdINax7mevP4V3rrdmhsjM6wdb2plHifPJMM1ZVJ6D3AMYxETgMOq4D2mkyT?=
 =?us-ascii?Q?WxVM2JcPn3gOEIVISxl0Xm4c/x635Crxvlo3yYIuyQval4QP2sDQkMryTud/?=
 =?us-ascii?Q?JpDbB2FX3f8GX/C640CpjI0FoH+AXXi0eSlwzM4lyFVCGheI+H5gnaDgV3q/?=
 =?us-ascii?Q?Vi6xQAUB7eFrK4ZKxMbG9OHSYS9S8JFIoH9IfcMpGQboZcu5jDnldyzZYOi2?=
 =?us-ascii?Q?IODVPHX0ohw0VCNoxdxxsxfgS4b0zTqGK9E9QXXyDgJXO4VHi9EHnfhsr+IE?=
 =?us-ascii?Q?TOYOWAxro7SQQoaLJ7ZmxfPu3YFjiZKMP9erHYCgXdd0+27KupxuDMJLUcJ5?=
 =?us-ascii?Q?CzYKK8c+SZa4Dchrg8e2N3aFBu280kjAZry/whINtg+GtZyy/QNkQOWQyr6o?=
 =?us-ascii?Q?ON9s5UhO4bIMB2jwkj8nKZZbfMqO3a95etNo0o6RgzOvt9aUNXeL4j96MhnR?=
 =?us-ascii?Q?aCALQSosShZXzaJu5Ji3zQQayxSNRdfaJ2UfkHgAyfEK0VFEjEVNjeAiJFJH?=
 =?us-ascii?Q?egtncwM9CuORPuWOcj8IszG0tQZz7fh1mOih+9w9appJ970pVRvBHgUjBitZ?=
 =?us-ascii?Q?H+gZYGvgwg/9mlp/zD+ibMqn4C9SiLjEq5IG3RSuEmRHTcrQIjNQXSmasPtp?=
 =?us-ascii?Q?Grr7CPWKs+JugRsgjeaFpKl9A4i4tTn/EAUYOQA7CsyZztKF4Y7BJ/8C/nt9?=
 =?us-ascii?Q?rJ5wWEOQP53tWdQfOmkgDBBYkP3sEbXAoO+emOs0gwxIduwAvfWkbp2936L8?=
 =?us-ascii?Q?fYJujDzfmt61ro11nbcZxO8HE1u0PCyZGwjTqxmFZZJx/WISzXR8Azaep7oR?=
 =?us-ascii?Q?As4W6e8dIvDL71OYVdiUPFKu911J8UpIEb6Yf9u/RogDBKTWOHTN7B2uOoZY?=
 =?us-ascii?Q?V4evn4SMNmlWOHdpULMsVWhh3OkEo767fIoLh6gqMzbUWCPbbzOAE/2JcDph?=
 =?us-ascii?Q?OhYspf2NI83e4STljI4b9z6cKc6nvArm6MV2dpYhbsCMKOvNrV5CBB5dQIg3?=
 =?us-ascii?Q?RgjecGeQ5EowuxXzSg+56YX9PnFeuWnNMY6FpnmZgfEHACaxpcZFxhiJvLc1?=
 =?us-ascii?Q?ypcQ9a89cM+vyxC4F1WBWeNjH70NPWlarXQI3FZMgn6eGJ4JYWJkPt/bu0gr?=
 =?us-ascii?Q?aBYenKdGPYPEmeOPA7DMd/5T4HZIdv7YSqwPGb2mdGJruqeupOdJtHW3svll?=
 =?us-ascii?Q?rRYlFKnK0qC1zQ+B5c1fJ8IlooahuuPXdW7iITxkWZkOxVwo0wPu4Hc+OjqV?=
 =?us-ascii?Q?F+meSxzuhmzb0hD6yn2+ARLh7XcOXUVvc6GMyfXAlEhVwSohRt9lcPUC4EX4?=
 =?us-ascii?Q?H9BqoSCUI4iayvr2uAQEiHqJom9GJc7eRkwdlv6C0sV5fSDs9IrvfhP83Kae?=
 =?us-ascii?Q?iUDAEvCEQjF0HccjOte1c2bPalmFvNr30g2ycCYix4f7z1RNp751gQ8dT3EI?=
 =?us-ascii?Q?xJfokU1yk1CD4owajLPiRduJIkSlYicdgSls9GWO27Vgz5GTjNkHreAOF7+O?=
 =?us-ascii?Q?TpXVRkiYKggjSPZV+qR0HvEuJcdPGUWoXsaPUMgA/wm0/708I831BTaEjM+8?=
 =?us-ascii?Q?pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	sa/cLSzrzRvIFbawiRnn+qSPpSVo8u7LCVKvY8yycqpfCXgE/DUjHIdmyjBLcOL9D56RvwsCVo2uJL3CaUkDThpKbfekuLGirc5nTIOH51Dbx3zFTrF8m4JjDwVL+sN+rOThi5fNerQk8+hIVKzF0GIrhPkzHqxtUxLbUXm67bYUZTRRj68XcnOGmULGiUV2xxnosoxeKJ6Vorv78R0UVyQ9LzTkw+hSFDPrQ/VnDcMb/jl/as89N1CpdYnQQE1vYkZ8kn4WVOSDBX8l9TpJeekuLE0228tLa5Kcv325Wemv0BXpBa19HaMgTvote0vKHz2Bkxa/bIY7YZvs7X2sppd3XFI6OPlYQfnfW/CBWy06U77e+ofG4CF/XW3nib21v+S6sBLo/xdSw8ve8a6Gmho6+eq3zLk6iDRhw+leiYxuv8kpHa/6EDhm7zsEZPAOfXHJz1ox0TBKOdhyJEnt+w2MkG9ujdLaBkfmK3J042Ra8UbJUz5NcPHcYQMYERXa+wP5CmlaX8ScQUHcoYzjIMgwulhYnLzrj/XKX/L4JkJq+7z6Ts+gvM7Fbf1rTSDqJgKapaCV5MrII89wJOR0UNJ49i/AdlBF34ewzhahoD4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05037362-5e68-4200-92f9-08dc2d9a72ca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2024 20:20:55.4899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4wZTw6kHttBj0aEaTr1e/8QHT7Aa1ON8Ub1yS6M0XzRqxA4ht+TnCATnE8pbFgpYej3+sL0o31miwEXwG0fUBYm0FXszf57/NiJkm9O6AqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5647
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-14_12,2024-02-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=976 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402140159
X-Proofpoint-GUID: zAj-hTlvfXiZd507oXaZe0fFjZl-svGi
X-Proofpoint-ORIG-GUID: zAj-hTlvfXiZd507oXaZe0fFjZl-svGi


Hi Bart!

> On 2/14/24 10:25, Martin K. Petersen wrote:
>> +		for (unsigned int i = SCSI_VPD_HEADER_SIZE ; i < result ; i++) {
>> +			if (vpd[i] == page)
>> +				goto found;
>> +		}
>
> Can this loop be changed into a memchr() call?

Would you prefer the following?

	/* Look for page number in the returned list of supported VPDs */
	result -= SCSI_VPD_HEADER_SIZE;
	if (!memchr(&vpd[SCSI_VPD_HEADER_SIZE], page, result))
		return 0;

I find that the idiomatic for loop is easy to understand whereas the
memchr() requires a bit of squinting. But I don't really have a strong
preference. I do like that the memchr() gets rid of the goto.

>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>> index cb019c80763b..6673885565e3 100644
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -102,6 +102,7 @@ struct scsi_vpd {
>>     enum scsi_vpd_parameters {
>>   	SCSI_VPD_HEADER_SIZE = 4,
>> +	SCSI_VPD_LIST_SIZE = 36,
>>   };
>>     struct scsi_device {
>
> Since these constants are only used inside drivers/scsi/scsi.c, how about
> moving these constants into the drivers/scsi/scsi.c file?

Sure!

-- 
Martin K. Petersen	Oracle Linux Engineering
