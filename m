Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC91D1A83ED;
	Tue, 30 Sep 2025 20:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759263066; cv=fail; b=f1+EtAhl/+hkyWPiGmZEyogdzsf4Edwf3RfyojwAx5IsGbH+icj4SoJp563wip+dpnmapuZE9ERYz5y/XykpfrwRtQpuK+1CGlBKfo1AvbEACyiNLzJrGLx4AU/yvwArKG5VlA+Eh6tOfR1dl0ISlLC/JIFQC9gv8Hzr0Oi78B0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759263066; c=relaxed/simple;
	bh=OXK86H8KRHTo+JZ7ocnIFBDodQ+qDPepq/tlbYmdWgA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Xu7w0gOzqoMQS8z3ZVNFvY9apYEb4XTWUZbKF+9bHLIw3LbAJMP37MNjdQ7n3Xxr6VXJwuDxG5dK/TtVwoupdz/hLBEJD0JYU5nY+iPlkNLzJclHEHrkIiCKGNTSD6RKqWiJLkaHW8xzpClsLcPWpQhuny+hSG0cdm1s4g2g7Mo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bG8Szfti; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zq3e+HaS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bG8Szfti";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zq3e+HaS"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58UIP2BZ013033;
	Tue, 30 Sep 2025 20:10:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=KqhhbyNKQbn4aAUbua
	7lOFfazlzA5N5fONgTIy6zHVE=; b=bG8Szfti8vCh7T63TdJoLjgqYTZMLiKcsU
	5565/dBUpNxpUSWsVg38CK8dabqJWIPVHBOYNybNlMPvXFQD96r7o9o430/UBAM2
	po5z9codi1tbdmT9QUHVR0+KcdRZBzQSz4y7zmRMHre9ZXnDy/8BAAvDnRVOHBZp
	v6QvXZDj6DrfuGCSAOqNnDhjDaysnQ6ONLamsIJdsPHxCuOe/wUOHnGDY7vyMbkt
	5toLw31SK7PLg5BjB1M9vp6j1LncA1LSEulbsIZMDC6iBSWdvNgv3We1AbKf93MC
	NuMKDLcJXGYUGztYx9uBhAiLGz5Vu7SJvqAZofhAh9OK0btYQt9g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49gmf1r5us-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 20:10:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58UKA7BP001926;
	Tue, 30 Sep 2025 20:10:51 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012014.outbound.protection.outlook.com [52.101.48.14])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49e6cevfy1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 20:10:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FC48xkYAMYj1/YwwO2K7dlb7zy2eszqOyw9HT1UrEZtUVOdk4EqGf0+XQ3jhvnSZPaZguTh5OSTpmW1ROOx1y1D8s1V7cSQAejox+qnjnocs58aQ2FTtbvwi/mCJLP6Irmn9jRXwlye8CRFpTtLAra/1EIdnsgwgfKf4oTvJK+K04jdMFThdPoBm4+OAo8V+0sQrMHi1RGv5qwR4D8ODjF4Yin6QwSoj9LgNT2QBWWy3LHCfJgGcqHxS4E9XHFTiAp01H7VwpTpZmznHfzCdbuEWixK4wjcHb1Zp6qXKyLXExBpH714cEsVGSqMJxbun0Uc11Hp5f2XWa4nKHjLLuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KqhhbyNKQbn4aAUbua7lOFfazlzA5N5fONgTIy6zHVE=;
 b=BqyZzCZ2+p4ANyMY6CK2qH+Fqh1Y3oAgc3gId15NeNJeZ14uIDrDwt57CCEOP9v6OYflEOWJ+54JdTuJGA47T34HZ/qbyKOTGVkA1688BJcXIHVOy07DlVs1x4Zo2OxB5Yx6yELzCPQfseLOOptrLrT3k1CgKc+kp3CbRhTQuDxigNZCfKm89387sUwQVvJI5qJGewDHCBXRnpOxuBXRrFXSzvHAtvgkACSWC1tgZM6tAztWV5PIBHmhbuI9isixUE1w2r9l5/TlXzmS09LSJ59kEY++loyYsEtq/qer2WN1P0Tz1SWB0ymD7bkgMDok0X+oPDbCdK4B3HFKIeElpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KqhhbyNKQbn4aAUbua7lOFfazlzA5N5fONgTIy6zHVE=;
 b=zq3e+HaSqGoytOFyGxdC5U1i/mA6Y+SSODyTU9NwsDQhJFti0MJHOLENZoyb7nZSH8usx/kmZ+1MTEsAMNPLwbGa64yvXaRUEn+XEgCnQ+OomwRCtJVp+m0RGRwoH23NC/vHAUR/a02eZU9xOZ6alota9acDS+VSVU0FLcBUQYQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO6PR10MB5650.namprd10.prod.outlook.com (2603:10b6:303:14f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 20:10:47 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9160.017; Tue, 30 Sep 2025
 20:10:47 +0000
To: HOYOUNG SEO <hy50.seo@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
        kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgs@samsung.com,
        h10.kim@samsung.com
Subject: Re: [PATCH v2] scsi: ufs: core: Include UTP error in INT_FATAL_ERRORS
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250930061428.617955-1-hy50.seo@samsung.com> (HOYOUNG SEO's
	message of "Tue, 30 Sep 2025 15:14:28 +0900")
Organization: Oracle Corporation
Message-ID: <yq18qhvn1kz.fsf@ca-mkp.ca.oracle.com>
References: <CGME20250930061604epcas2p3f341c32c50f267aa6bd3ae0e82adfbf3@epcas2p3.samsung.com>
	<20250930061428.617955-1-hy50.seo@samsung.com>
Date: Tue, 30 Sep 2025 16:10:46 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQ1P288CA0007.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO6PR10MB5650:EE_
X-MS-Office365-Filtering-Correlation-Id: 070e9ef6-6d95-4de1-30aa-08de005d71df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oZtklHe4KAvpSlM618154ijOFHjRiHf1Ft9g1IImaqugaYLUqkpcf6S48pEO?=
 =?us-ascii?Q?9Mz0qzknP9NKK1u86shXRtg9s/WXdOp56OTMJMQOnWVRdt0Nyq3hBk3nm3nr?=
 =?us-ascii?Q?HF5auHzPBWS7wFNuJVHxKNCeGTLLWA/TUFFYmhy641blYTjYYibTLfenxCmb?=
 =?us-ascii?Q?9GSlKcr4N059WdXzud6SG0IX+hFmMU5LIN59thGQua/ldUGcjLsFAHZ3FVNk?=
 =?us-ascii?Q?QOYTIfwtBE4xL6bNqb5XMcODoS+R0FfaQ/lRghMAezA764zKFJ0VI7nwPPq1?=
 =?us-ascii?Q?0+9to6EBM4ya3S4P8lBNSn1Nap2bBROeEIrOgHrl43BsiZ8QZpIWXhyMPepx?=
 =?us-ascii?Q?RCuraxW7e/YrT0O3KWqF7vWfaX4Pv90XCLbHK2/yVI+nNitqHKdpT9gj9uC+?=
 =?us-ascii?Q?sP1UhQ07XZGWctU4r0EXK6fYUEOeAFvq3ikflotCF+Bub7/lRwy2tF7iHge5?=
 =?us-ascii?Q?xrQ+OfZ5MKOvuhJnITSDu9/ifi+wg3CGgllln8ql5knStowvquj8PY89INfj?=
 =?us-ascii?Q?O0wU4GVIgX0Pja3IcmMjhkuz1BSmYfJCQnYLS2FNDM9kLmZIFZRcA68A62pr?=
 =?us-ascii?Q?GCVkb3dRWKU/e1sv+P58/O40X8Y/gjVDIP9gSNpm3F7lGM6OSxHhmgIinhy8?=
 =?us-ascii?Q?u1pzIbX9ltiAWgCOQQO4Vxmaa07v3mNmyD2xDc4TS+4VPb/cxtMr9Zy3Zdbu?=
 =?us-ascii?Q?ZAqIOzJTDQ55OXBHzMWoLpMOdewsic2rYRIWlsma6IOyYLKBb51dyeq+X2vO?=
 =?us-ascii?Q?sUXN18Xr0Kk1sNvypRImYHomsN03zxSUZSqwr3AancDjvAd3wqune+wngWTs?=
 =?us-ascii?Q?vRFnvnEh9zUaw3DTKQWxBdlKVbRY8zz4Liffy6+z26Zo2pBKQdNMDe4BTPaj?=
 =?us-ascii?Q?rTtoKmgeh/wLLae08tHYYswMiWzjZ61DCwLhBqTB2aynfoEAjlIP+au2LLs+?=
 =?us-ascii?Q?AQndM2dPvdr9kU79qb5Tu4TktpmemlRuQlZcYpFqvbC8GLClVO+zSiBTW8ux?=
 =?us-ascii?Q?1orSWzXd2l2JY09gnRWaOcE/w97ROV7lUndjo7n7eLAsDbax+OUImi4vK4hf?=
 =?us-ascii?Q?iC1F51oNzwCrq6TzCgUKRqyKX/LmC1HhpOrxzMDr865HYY3ACzDOzSghhnXZ?=
 =?us-ascii?Q?YpodlV7WVXAR7D1v1QWdI7MkQ1yEp/Qt0FGw7tDjq5c5QK3wdIv2VL2pzkJN?=
 =?us-ascii?Q?49n/sG2lhXB6U/LT87sJhkFZdcdOyG5CIyDqt/niDFFjVTU8/5LwDxPQTAVn?=
 =?us-ascii?Q?UoK+QiM9Oewj9jrrur6JE8FVzG7Txk6koKnpm9Qhv1t7gEvREIQn+XOqqtde?=
 =?us-ascii?Q?fr7j3fw/Livqzj7/gX7a9e0rexmnC0deXV2szk90Ky4ocy2yAV8Fv/cPvFvP?=
 =?us-ascii?Q?8raOa8zKfeXA5Iq9A/V1Dk1Z4Xu9+AA7BX6TIBJeSd43FT1p5AsO99JkvAkl?=
 =?us-ascii?Q?Do4hJrdYRdGHc6Fc8foeaboUmoY115/O?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j3YavE04oaYSESwaHV2Nw9cO8Kr/WZF6D3OY94+XTkxcVk9bQhf+4ZNDxPTg?=
 =?us-ascii?Q?2/HIp2dywKZVJ5ouDpL+G+PwGzyosTAKMbhbgSVXZb3sZr1apHPHN8f62YN8?=
 =?us-ascii?Q?TxrBHtiNoj4MifO0PnO9s/F0p/+uiOAUO+niY0fHFIz6MoWC9rHDKG4gH9Qp?=
 =?us-ascii?Q?gbbE5GEOVmQH39QdJ/JlWctd/e7I6nnXwwBG3+vnVaTb2wEyJUciyzsKi2lG?=
 =?us-ascii?Q?GlgDzCzA9xtLbKLBz999I2hIFo+TGFL5EMA6Ndb+30zB0xvoGRgrc+DKbqEa?=
 =?us-ascii?Q?9mfM1nB7o1CW3QyXHV9+oBqI2Zg60vjlJGl7qaSqy/pWB8JTdAipWPLLTcIM?=
 =?us-ascii?Q?IHMh7vN7f+Kd5FBa/mdAsV7zE29WssMhGHH/mwFQqJ4gMrTKiPOD3jfT0Jvg?=
 =?us-ascii?Q?aaKRqdgD4N0Wj+LxSwT7Mqc+G0ryb6u19xPfShtyRulDJKuciMCdxKsUEOaZ?=
 =?us-ascii?Q?dFyKAfIUDVj28Blq25QkCxIhdf3m2jgjKVjvjPobCyVTYv36nr+4ypOHUk+j?=
 =?us-ascii?Q?em+52/oCm+idg4pBgj07+qJI0SC1cUdBsRgvVixP+fitDcxFKoOjGKqewShL?=
 =?us-ascii?Q?4UpX3akmVeYF92jTrNAKKTWFTz6ve38WmMFbp9xLZPohHebQj1q2ZiegPAXn?=
 =?us-ascii?Q?umYW/GEIGvBuZjSgivRH/EcBphoYLsf8e/BYstTEG5+QrLOZOEGgGvhBpodX?=
 =?us-ascii?Q?tPZpYd9Rumsi+JBTCg7nFoJPccfxSNAzK3jkCB5Gs2ZOBCIfSIqQCHUVzJJG?=
 =?us-ascii?Q?73RdWwqw8xZmh5m+hS7AdmEanqYDy170Pw/PBhZQR6aUpyKXIRkH9pXqk8jS?=
 =?us-ascii?Q?vdrEUq7c/uxqumIAs+8CJAz9LIma7GfoExl2nntzyVPtJ3bVKjxoNUypT+CN?=
 =?us-ascii?Q?KF1vAdLHuiSlZMuWc+JL+nloaqoRsH5i//5rRpTh13AK5Q+iJsZwGNNsjj9z?=
 =?us-ascii?Q?8g2YxfEa1Goi2sYPOrMBfBW10YsZpR2VJQoNHKRH4UCfxjOYvftC3REW+M1d?=
 =?us-ascii?Q?vmiVbzxLWCObo4m0TCLSpwdknlWky0VWtLT7JxL9Y2JZNx0q5V8xZu7JJC/E?=
 =?us-ascii?Q?yWVz9wYgsPVpDtgtta93JtJrSc5ME9WVOKkQiValhiaO/j+1kVzjdg5Mle2T?=
 =?us-ascii?Q?adw8OXp7u02Bl4nzy7UVSL6H+vxtX7rXK7HtAqNnOJkZx780Ul+ObrTjFb+7?=
 =?us-ascii?Q?/PHzSh6KMR0oTVr71i6j9Ux6VU23DOH8Q+VwxwlKHTVqiNh4dfFHggK2APAp?=
 =?us-ascii?Q?ubTroms6srDifkYituOcq4X+mJzvWvq5mVvaFURPg4UXDOFMOQWWLaMaavXT?=
 =?us-ascii?Q?QifttcwbKORVJy/FjkIV781YKnDN55cVV9G3nuLUMVhbrC0T1maVpAHKLYX8?=
 =?us-ascii?Q?Jb9pzI1NOpSqc289qGz6p2c475Ugt9aMe0TPbuXsAnLweWQBzwx7w5oPWW5o?=
 =?us-ascii?Q?NAK0wLPSmu+1NXKvokPrXqsXtUwxjxbKGKaPeHLfUWKzb+cxGR33hZNjF81u?=
 =?us-ascii?Q?jA26ZIMAGIUqtVudsA+Lv0zDyJUsgVnpzQX8wy6Uh7Oy4gcKGX0j6suTNbHb?=
 =?us-ascii?Q?W+Eu50olHi0oRj0u09r1vR49XedW9dC8oTU+tlTCoqJWarDXmnDq4ggVJ3u2?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E6lPV59C25KM0Yq11PCB9Y7FQYdEsnT/OxqIk/MOeHsrID8RgVkgGnmfFHQK5Ch+o3Y+feGY45bzIieqrClymJ6S3pF/89+/dtc7eGgks70Ji8waHQ8B6+pyctRUykNzVnzIPR1+L59AYwdegMyQqghOyZdmb4LAVk9pcREl6h9GvNSLi9QWca2DUNyHWG3qmLO3+i6tZmfylie+qY0eCCMwM80bOuQOE+C0oPF9di/s4Kl7KInhpPj3p1MBctUKMkm+AnP+u5nYeYVu5lsqZtCurFlWRNaJLu6+E0Bg4bNfRK8x8ZmCqfvc8uOqbXxwsmx6TjyHNR5xHLKpMIilZ5lBnzy1V8PtcoQFCJLWg7jKcKRrWch8ihDqabeVRAypoMUfMPexJ6iKmsSEDvIwpds5zIvotySEEo2XZfy+NDK3TR9Uxy6VECSWLLDtbukCdEStKk/5U07ywEg3cUukZar+yjHai7Ny30HA6O/o92+0c2a+IgGBnCztxfEPpCK+QUL2SXar9DVreiwwAYoUQ7vt2UTFCIi+u2ItYs+nHU9Xe1nuBCSTsGeUBHVY582diVecNFbgF9uA2/ltwfgj3APG4Hxr1D1BOvB31qBUd6A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 070e9ef6-6d95-4de1-30aa-08de005d71df
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 20:10:47.6970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DG0jRN9w1UJ2GReZesLuNAOaEZFdz98R4nEasILHKNq+d3aJisYEu3Bz9AGDEgT4TK2tdJg2+Kx5ArAiZWG3EWtwNi6MlaBce2qVk8mCHx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5650
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-30_04,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509300183
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDE2NyBTYWx0ZWRfXxtdUYdyq/Kjl
 odQwjW9Zlr+M+VWISx12oC2APcpN7Tnx3q5Ksvzvz/spv4XVi1ETCd0Ch468LGsWqST40KtE0uf
 i7g78EXRs6PIcI1EIL4lBN+7F3AE5sJ8NKb7mQb4qcLHl9F5h6HtBj5Mw173bF7wyEx93R5wcQf
 3FGN3rmfMxA9IncY8diLre2RISCv6YRTVIc/iWWdEBpUpWahfdx0TRPfJimXuTC3d3reBcSuPij
 d6T/a5yusFdMvRX286A2ZQrL5OhELI/O6FkXu3QOLuYuqJ7gxDmeFScDw9fL/s5T9pKN71JpTgV
 mSDJVJuugWriSqVOk4ce7InH/QxoowRVF7zCL5XU2VbJ6/cevnNW8yin/MORJjIiBKnLmvAUtky
 SXGh14T/bgubAVvpvLeRaaxipv6V0NRQYaOXrFZ0vpU8r05edsc=
X-Authority-Analysis: v=2.4 cv=K/cv3iWI c=1 sm=1 tr=0 ts=68dc394c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=NrHL2xUlxmK80PaC5t8A:9 cc=ntf awl=host:12089
X-Proofpoint-GUID: xrpp0Mb7lqqCAVOEpUuBthCfHRdQZzbQ
X-Proofpoint-ORIG-GUID: xrpp0Mb7lqqCAVOEpUuBthCfHRdQZzbQ


> If the UTP error occurs alone, the UFS is not recovered. It does not
> check for error and only generates io timeout or OCS error. This is
> because UTP error is not defined in error handler. To fixed this,
> added UTP error flag in FATAL_ERROR. So UFS will reset is performed
> when a UTP error occurs.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
