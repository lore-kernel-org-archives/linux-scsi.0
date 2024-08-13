Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6F3AD21;
	Tue, 13 Aug 2024 01:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723513101; cv=fail; b=u3ycVfj9KG68PHwGS2pkgVH007hnwvMiG6p+Kb9UV0gH+N5AhUTj9IGo4s+QeCUMhGlR1djbY3uc2/jI39BQNHstPNFLfxHac1clkHe6vastJIbvt8+x+FlgzPihrEKa3dCbHZt5vlU0fbEvRVsnLK6pmtbHsdCbtmxrds3KN3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723513101; c=relaxed/simple;
	bh=88ecyQkwnjiFAxbjsgZAmKd8T6Ahstfe9hN5CQq6GBc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=rX+8VNEiSV6Qi+tZP94bUmmyirdDX66SRasoEKi/BZmrUeOnrimIN+MltLTA5vTdsWnaIsqxL9ryjZDf/al4Y6eR3t4ogRwl+HEAoNedVMUiJfCi/5Ly6IYPB/3IkzF/gVIryyE4jR90O4Pr3Yk5jNsQXeM6WN3DrJmqTc6cHEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H2kQalSE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TaHG98oC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H2kQalSE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TaHG98oC"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7JXd011553;
	Tue, 13 Aug 2024 01:38:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=SxvoPq6PZ+kImq
	mTLA3Tq9qXNbsIy4Lb7JGD7tr9Ycw=; b=H2kQalSE/k8Rk3ew5r992Vs6kmk00T
	36n4a5ClklTuzw+ks2ljksjyfSZfECQOB6nXl6VzZ2fxf7OAHkaa1VqObfsKSfz4
	sl+x6vX2NSJ3ofawoU9ZaswQ8aDPgIPL+wAOvi9JPQ3On9/KzWluI9BQdgZSixtm
	cJvUkcmm4vfYASwoPYtnBsBxnIxbLwjJwKL7O/SvBbjL1k+nauy6G2VXf+7nfGLb
	/iwHTzZ+9voJd6SVADVaMR8hnQPGwR8J/lZU2m5fWCuLQFIXEb0MynINfVX6QTSI
	dc5pXNQU1vjCrrd8zAT2l2AvN12uSL1HY7vtfeUANz6/lBvNMxilwSMA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wyttcx0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 01:38:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47CMYJfc017649;
	Tue, 13 Aug 2024 01:38:15 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2046.outbound.protection.outlook.com [104.47.51.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn8s3th-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 01:38:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qSP3yhoqMLvJmhVCPT/QdyV8sNeTPRscrWqgzlgEEd47KtVro6bDqNqsKLYzJZ9YZurIK/SStw5IFjlOIucpnd1BWH4HutPHgxU8NVMCQnOV/UyJpaowetomWbZpWzy0Yainll7IZ5C7WywrsLrx5+zjBfnKUG9TahZ+DfrMNyL3ig+iSGOGi5HdjQyDkI5XRbsqm/BkRLYcJbN8owj3pUY5fl/YVzXpbjhQxgw9wj8J8dxV9NDoh7+mIpJW8yGXTq+KLkK2bt+I1ibm288Ko/NAAiHSp2iHXKfg/L0Gzw/aPEaScU1FGXQc+5q3r/3sic7RZsqdctPbgIK0kfs/MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SxvoPq6PZ+kImqmTLA3Tq9qXNbsIy4Lb7JGD7tr9Ycw=;
 b=XblE8ps8YPvg6na663Ur/R6Mesd0B5rPQB0Ojg1hM0vPnwHy8mdk0roAfhZLgSkePfVHRy30hMoVDB8mKwl4kzloHm+5NphTE4d98tmhZK0A0nu/V4L/7F0Luuin2pfP529msbv6zHKRWxzvHvHM5c7Tp+HKvZymzd+uj95V88ahbEkCGnitSk7+YVD/wtQirmZIRBcTr7svk9H4hqRKUJGVodVIzaVVipRpVkeN16lUthiTva8XlCc0xah/YKVHjPe7fnSkH2Wt/nTEXemWRQUCxHqNBWYuy7gh6e4c9cCCPp5+A+iTDTlLZtkZ+Zf+YLobSeRCTjoUPGzcXsluew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SxvoPq6PZ+kImqmTLA3Tq9qXNbsIy4Lb7JGD7tr9Ycw=;
 b=TaHG98oCpckZ59Boj7k8X7v7ILtSxracmFeZx38/G/cTh6MPFhIQVKLgQBcJ6t41GfH9EB0kEe3eZIckmSzxI2c93/Qjrp5E050uNvj/gbV4XCnq0E4dJiddh7DQpsXFPdD08d4FtrTEC671gcGEH0Qxb2b8HSJ6GEPtRs3GfdU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4459.namprd10.prod.outlook.com (2603:10b6:806:11f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.13; Tue, 13 Aug
 2024 01:38:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7875.015; Tue, 13 Aug 2024
 01:38:13 +0000
To: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela
 <sebaddel@cisco.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: snic: Avoid creating two slab caches with the
 same name
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240807095709.2200728-1-pedro.falcato@gmail.com> (Pedro
	Falcato's message of "Wed, 7 Aug 2024 10:57:09 +0100")
Organization: Oracle Corporation
Message-ID: <yq1bk1xxkw9.fsf@ca-mkp.ca.oracle.com>
References: <20240807095709.2200728-1-pedro.falcato@gmail.com>
Date: Mon, 12 Aug 2024 21:38:10 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR04CA0033.namprd04.prod.outlook.com
 (2603:10b6:208:d4::46) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4459:EE_
X-MS-Office365-Filtering-Correlation-Id: 0927cb93-d514-46b6-4a3f-08dcbb3898a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3GasAu1seboJLxG9RJELcrsQlj3e7TwUR6ppWbKBXT6wgrFfu+fdF+ks3FJq?=
 =?us-ascii?Q?jLOcGZ6hwPI+fmpAM7+sEbtVdgCWemTr1p3RroNxO9ADLb6VaLsb0qsVVlST?=
 =?us-ascii?Q?aP9HaOyx8fZBkgf1O1EJATpMKBqxZ6dBOJzAY745Pg0gRGm/YZLZb+QK70l7?=
 =?us-ascii?Q?YCYU2oYAMR9l/0l9N6v01RGSUnNncVHxcpKzcSWrivgzQTutuh1NqIPcaQ/E?=
 =?us-ascii?Q?/GpJNV20pOBuhejdwv+I0IEN2capd6GhCjg2DRtDBwGodsZNpBz5T8f2y4L9?=
 =?us-ascii?Q?RmmC7fs3nGw1quSGbSogrnb9WFyaYli5Ysg2E/5jXbiIAwCfrgUBt7L+m3hu?=
 =?us-ascii?Q?d0lCdNRaEFwOlBcIfn1YoBDlsBxFmZOJiPaVM6Hcjwlx3p2kbLKBRmikPVg4?=
 =?us-ascii?Q?BCVaP/FSahGPfQYLbfr968VJjWt+lrWoknfvo9D6NL1467TOJUVQC7H8Eh/I?=
 =?us-ascii?Q?zHJqGopSHK54uF/ZXrvyQpzTwFiW5+gX8gvTgDvJ0EWMT1vZ6TJ/4mWpdQRH?=
 =?us-ascii?Q?mI91IsVkVZuXddJ3omsCVD2Up2R1yfSfFv3TvT7UbV1WEHoYl2iUgErEwyzS?=
 =?us-ascii?Q?XD3R+IUmtZEyM8qd7v5osfPTRlXkzaTuYlLF7CUM+Z6qkWjwpDLASNMsi2cq?=
 =?us-ascii?Q?N4VgEni2XlU7TUah0Rp9Irs7Hxw8HiEpPh1xDxhhlWs7iGz0qrY5VHH47gNE?=
 =?us-ascii?Q?Wkm5h0gY4D+A/ZSI85VrdTG7G59rnPtajVNqrX+ZsjWnwFsE9/mO1y+xG4/+?=
 =?us-ascii?Q?itHgG5rW8YmeCxr+SkXpRQebQWtktcDaFUcsYhvRAvG6sw1rG5fb5ip/T+KN?=
 =?us-ascii?Q?DTxVqt4DEeoPbYQ7sthY5Qy4qgObd96pa/NFjalkR+7cfhPJ9sMoeLgZjNlr?=
 =?us-ascii?Q?zSMTtdO4jL4Cy93u1Cy15nGvlK8A0lbq/P+7y6k7RDKfqe3X+a06xx/7m56U?=
 =?us-ascii?Q?5DlUS6fSsHKB/z66kJjggGpM2rNfy5E5JQt9elexa5Ff0vuKoLLABvAX8fRx?=
 =?us-ascii?Q?A7+2lFKW8SAuxWgRE62YwxwKNaRoZCITp1BrHEjgAKX0UEKawCUQ+INHTWKs?=
 =?us-ascii?Q?8eYF4eYEDdBMYEjGfusYwNOaleUCduyCGRnYBEDo2/dD43kaHPcbZABOOvub?=
 =?us-ascii?Q?rB9I/qPx92jGd7Fe2u9Yn8JuV4vQmZl5L+mX7hzAqCWxphZaKq6tUwy554Jq?=
 =?us-ascii?Q?ZloZxb4jufTpVARsLban6OYJdOA6mTUfj5QJs0HnLCysnW8D56VyOsKCAyGp?=
 =?us-ascii?Q?6lckQDmkvEicehr58Upb2tA/qK/yKd+RzqKwZ0KXS3HDQFvo3JADsMnsBEOE?=
 =?us-ascii?Q?jhWbr4/UQI6dd6F5n3a2jkpwwxl7CwTBXLn1ga0oMZbmbw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xugjkewpU2RAelGFryNclHUfxDWmjN00YfIz+LKA/rveJ9t089mRd2JcrHy3?=
 =?us-ascii?Q?6EQjytYKEYo3TU4ZF208fgJKoRCb+2d9OtyJmmiMx4nykXvfKSjedsRToBOe?=
 =?us-ascii?Q?Whw6SJ+A3TdoLdYk43cn8fhWtEdRbXsFf+KEfjYu3TwCrVRWdpMRJnMz/PWp?=
 =?us-ascii?Q?u10+mBGPWQlPzVmD4df/ZbpF5kM/Ca50qn8Zy+XgpPq7CVBBr5cXwUjffhHO?=
 =?us-ascii?Q?tIiai+kbe4Qj9zLT++4sHNGazVBIFp+6rJlFNtRMmSCtDZ5Dmf0CVCxZJT8P?=
 =?us-ascii?Q?tVcxRG61RjQDw2L7obIJwnx7D4TJBFKGbO6HRsJnosOpZdAgpGmfadkuXFDF?=
 =?us-ascii?Q?1dPkK1tUscl3PYMQcLCKQ9zJDV7JcjiFHPWFTqPATSoC4ZxbuohP0ceMcEz+?=
 =?us-ascii?Q?K6cdtuMtRoENSVD7gzQIr4KWwcjX9gsaumXfEnNDU4qvOtDPBCiraNFj4rw0?=
 =?us-ascii?Q?u/Swfh4ThyegFJz6NzKXWQrA+/13eatlUg613uflWRjuLeTrS4ITME3c4olv?=
 =?us-ascii?Q?yPyyFeWnWgzOqsTS2vdn1GXy0HhqsL000KUR03kOjtf1xAOyu+qKcbwD1kPT?=
 =?us-ascii?Q?DZlZsviYTnTkDEtMPGyOwBInE5Nh4XZRxiskg6ZC6eWtbzZWatTEyyCWW8nF?=
 =?us-ascii?Q?rqg8EBj4t51rKcpCWq5XH0GMuj9iFWDUj3yl8ZrKwksJw1I3uzBrJlhfdHtu?=
 =?us-ascii?Q?AE6jz3SOwRa2r9Qynmipaty4gFaz6CCLYdVFRiDrnUk65k4aoUlcqoC6jyob?=
 =?us-ascii?Q?y8N22/bdZ9ICJJmslIkbrsDFZUkwuITxf3XTDUFo5L5GHwLgLQaqa5Ys5qod?=
 =?us-ascii?Q?rcJCjGwKpEEDnEt2LlSKhwl/K4BzKqK0Vxlct32WKdEWmiurHNYrOSgQbZMJ?=
 =?us-ascii?Q?RS1xdR3lGBZ5CW4z4nt4nNDCvDoRyoAIeEkQfsSBeFxZ+wSuem+XpKhQReK+?=
 =?us-ascii?Q?Qqc3xiNRG3e5nJybS+DAE9w99KNiGsF/26nCZ4boj0lf7d0eq8bmY/LYdTex?=
 =?us-ascii?Q?Y2BeSrbANQ5+q1I8R5bEzeRX2PRnZE5qm7QBjdr3JS1M10YUbuSYb+huzAdz?=
 =?us-ascii?Q?GWalpJvZWlRbqzT0QZcMYQkdgH85+Eq8Qn4+BflUf7+U1q9YJCsZcDctZL60?=
 =?us-ascii?Q?d+xUx+kc50gDAUTctVpWNjBAoh9U/6S1gCprHOgnWvcBtK/9sJKZIQbk/Tuz?=
 =?us-ascii?Q?gS9vg58iK8CGBaOlvTnLB9TO+gbmb6Gj8UCgnGzdaiPFVOuYIvN1ktIm84jp?=
 =?us-ascii?Q?HC++Jx79ZlqhJZHEI31UFkWNHlOF2Kbxpx8cfqQkZryJCr/TfoQ/whUcTuqJ?=
 =?us-ascii?Q?X+RszeuR0eJ+hrLdIoaxjbBWSpdB2XZ/AYCt9vngGB37GQ8mO47nLVwU6NCC?=
 =?us-ascii?Q?qRcFzxEBG/qiCc5uz4pMAvFyRPvRYw5U9Y1nqaq140QQZCx+jGKbp5PH1CL7?=
 =?us-ascii?Q?pxYECiV/w+MgGVnmJKPYN8wpPek9o40+RcIYXn0aZ2enIQcWXttFD6aSuFZO?=
 =?us-ascii?Q?hTdJXK7ZnPz//kRxRk6k+75+I+SkLMQeShPsSLiUekXIpOw9J2C0cqlGK6KX?=
 =?us-ascii?Q?cHH1FJvf5cEAZBjUO9CU5Ezobt8uN00Ip+Ls1JSkGX1i0zfqdYWQkQ+jZVno?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vJQAX3puZHd9uoL8gZLlfQ5P5+0RLCItiI5S+Upogcfv4EaYo8CPV1uSBvT+VIF2+d6Ww5h7YAAmynmm8tpFmComXtfEQuv/SAtYSE9rYLeO1Fn8tJNZge4fHeN65RpoumUvec3TIFiRz3wk9+bNj3+NDTgwNEUVyiaiNkWOH8QFy0e4ZDLvLq8xcZlVn/BXh/hVhbJrJooAqd5iY+F9MKMy0VUDoHpaUN+p+gOlM1Me6aMGcwKJn/fZjfZZaFPFXZ4eAnI9lPR0HtiAhkaSexW4sePkBRONznisFDkRwJV/AUqj2P9SWg3kZMYuB1Fq08EqNX5LalHR4Nxl725DeDCvF4plaKTXt70EiRxTp2y7otacMULCwzQ5ug80n4iIB1wWCLu3K6lvF67pjMFJzw3qgZRn9vxMTm4SvhHAhuATCcCkTL2+3JAN5xVPCrHgQZkOqvldEzpFhk4A8XaChl82HJ8lRn1zAXOFrACLNMo4YnOLq2tPsMnMmlcM3KG0jdadlAdSrln3/w1pmaFKCVCJnIRe9PlZkKkfs9fuch+6lZbQOeQBvmQdiznL+dlN1ziaJIzsmXUZIhy5ebv/slZrA9xgUaDvsFe0uPM4CSw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0927cb93-d514-46b6-4a3f-08dcbb3898a4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 01:38:13.4116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2tld3hQc3mZIR5/Tvsj5/qNlleyKjEFUqRUdiOVRRETKAm+FGYVb6XQD8keOrbFKVMWkpSvckRYiwEs9zWF7D1qYlsa46N/K47/vLL2DqQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4459
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=665
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408130009
X-Proofpoint-ORIG-GUID: gvIvbsE_T5bib0WYNAqzQNazdE68KU_S
X-Proofpoint-GUID: gvIvbsE_T5bib0WYNAqzQNazdE68KU_S


Pedro,

> In the spirit of [1], fix the copy-paste typo and use unique names for
> both caches.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
