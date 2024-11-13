Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6202DF42
	for <linux-scsi@vger.kernel.org>; Wed, 13 Nov 2024 00:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731457230; cv=fail; b=JFeT7wDXn8eM9QBwjUJebqn39x/jVL5g4nVI1l7bvzBM/X4nos3L1Z/pGQwf15ybAWXvgqTkAy3hBcce7XpK0f9ivI6eGvFuEhf+XdR31jSwMWGmdhZyTwDU96zDyiXurRPA6IhvfdFJUmuSVnDmCqbyCS55fKTMXsfWrFxjoyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731457230; c=relaxed/simple;
	bh=B5/Kj4DTe1ggPEx1+AhGHmgdGhUuuGpqdKFi1PpD+5Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ij+F7Ng0xTQWp1S21QY2pLGYvtSrF7YD3T8DuPErOX3RokdQpi8qnoGbzuRHOGFzWkQo+eFqAvPNJUxtt3RwiF3tFfCcachi22+3ruWQ6ecCVkFUTX3/G1SOd28WWL8RJxgIHDhHuJlFKZSjsO1wmXVeWJg1q2fTisjpWs8qR2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WG9ku7/M; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hEeQusZb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WG9ku7/M";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hEeQusZb"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACN1Q2J030595;
	Wed, 13 Nov 2024 00:20:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=w1SCrIkhpOTigL2H/V21/xLD2TH+0c8jbMTQuxZLje0=; b=
	WG9ku7/MjTArwzlvw/geqFGs2V49/RjRUIMrTVSyw/w+iXu1gAAMe+Qx8TXgeVmV
	+NSf9ajWXCu4at78/vRdGEOeGRyHSCBFaSxHuGxfmG1LWi9ICuXl9QqmpT2EXar7
	UMZAdyNQLNbFloO0UE3YFY/0aDtfZAN1jeMHuoJOAksK/GbgOMDBtn2ZUXgOuPBm
	znFtLVRR1hR7Msa0LawhYwBE9iJQNEGYdmkcaYkOn3i1PESk/IEOajfA3KWPDkI4
	ogHEAeF8LgIGF2mXUrnVFdQV1GbSV1dGc1YeRJBRn+bh8VjINmIH1en0DM1qrLN9
	woviESytYteVVVU5Hwk1Fg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0henngk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Nov 2024 00:20:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACN2nGG007980;
	Wed, 13 Nov 2024 00:20:11 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2042.outbound.protection.outlook.com [104.47.70.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx68v8ev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Nov 2024 00:20:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I4u56zwyw64nYDpY8I4y52yyqmD8eFhegtNiiR/mGXFCqOX6tsnmCBi0NK55/ZG1YhpUtjsGlymkcM8w8dF4VtqSQfAuel47/0R8fNAvhnGX9ZnBu3El0HDXr7Fet1k2gviak3WoavHJxRe20isPjbh52GQslVQTK6eee2XVxb2kg+6z0jK1C6ysArlfqAFDV8/iKqOc6F+yf1YoHDh4hs/vJOknVhE0uyn5qVy9qIXDxqjDuzEgqlxtB1H75rAWo9bphcH9ST6LbOsTbz/DEGv1VLi636BgFB8NQI4PLEtBJiwujJCk3IyaR/LXS8jeby8Lfd3t+66wijOBHZ5Y7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w1SCrIkhpOTigL2H/V21/xLD2TH+0c8jbMTQuxZLje0=;
 b=hk66tkkoKTTVi3LWInYYaH9VrC7MLWq5aR8rLLnhgwSgTkrev02xEV/ael0rnaB1RYVds2fyuDi3ISCc64RS0IP+4qFkhjBV6SO/yUe2ejwWn/L7vwPZTLmD7GH9t5k+TiS9nYXz5wZXiMUwMTiVq/sjU+Gomcy9CXllYPxG5SwqfqyF+0308FYFzbvBg1xz3Y+ed6eOf1ZRbsRT/1TU+YWMXzryrl1ySJsbtYoUFNzqcko6mJAgVtQcO1IWMW9n9APoejJIJxu0vnDtB8wOViTYYXO+D+NAbHf39YShlsqEYe40kfW1qa5d0LwhZtbwQzccuPaflUFh1ycYLEis2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w1SCrIkhpOTigL2H/V21/xLD2TH+0c8jbMTQuxZLje0=;
 b=hEeQusZbJw+zB3ixmc2+LRg9LyDLT175B5s77y+Od8BVbcpdePHwpPOtTpJFelzdIUKST4bXWm8CEyvrIaFCXVxJGPvSk9EjaIEijgFmvm1Q1qN4EqrhO64iFEDNJN7ywU6PAlChIiHBoD1lYWrUUU6fiWbglXUHdIks+z0OZmk=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by PH0PR10MB4584.namprd10.prod.outlook.com (2603:10b6:510:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 00:20:08 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%7]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 00:20:08 +0000
From: Himanshu Madhani <himanshu.madhani@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
CC: Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: Re: [RFC v1 1/8] scsi: Add multipath device support
Thread-Topic: [RFC v1 1/8] scsi: Add multipath device support
Thread-Index: AQHbMmKbh5KJrB6Du0a/g46XZ3stZrK0KZKAgAA1GoA=
Date: Wed, 13 Nov 2024 00:20:08 +0000
Message-ID: <172B10EB-813A-42F3-9878-DF8A35AFCB56@oracle.com>
References: <20241109044529.992935-1-himanshu.madhani@oracle.com>
 <20241109044529.992935-2-himanshu.madhani@oracle.com>
 <04024572-acc5-44cf-9505-b5cd2bf83a2f@acm.org>
In-Reply-To: <04024572-acc5-44cf-9505-b5cd2bf83a2f@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3776.700.51.11.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR10MB7959:EE_|PH0PR10MB4584:EE_
x-ms-office365-filtering-correlation-id: 501c3642-6efc-4ef1-6cf3-08dd0378ee45
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?yyaaQunqTDobArnpSR0olnfP978NtBTPc6JjmEoQH8FxO4XhAiXZ/rsmVpM4?=
 =?us-ascii?Q?Faz/nh1zQIFQI4ooukEAw2ggULDl7EotxUvQOozp2KoHJExCUJxhECoVGeVw?=
 =?us-ascii?Q?zeiTV9br4+otCY3XJP96NanvzWTmEcKarCfR1qSzIG0/JC1JFcA7akDMVLc6?=
 =?us-ascii?Q?TfkmJPjOcKqq51jlvxnzk6qBQNstYi7S4fNZwMNKVRJ9rOT6Lf67MG6UjbG0?=
 =?us-ascii?Q?q/nhUrl8SEZurcIcu8cvIEJLhGAwSSaOK1SwfvpMRN+GZ1F26OA3NB7IFBYo?=
 =?us-ascii?Q?h9bd61Ik0HeVM+uj+bBc3L/M5Ds/I6v/X8mn7VnJC/gJv3z9y9e2bVowkOuS?=
 =?us-ascii?Q?S7e2paqwrKWkLJCmWslkMMCixFfMkw/DE79JWKrKWgHd1nMmOV7NJ/PQJdIc?=
 =?us-ascii?Q?Tjk/bxu2tsRd8HOO3qYFT4tta9Ia8pIh6lf2a+R0inCezCGx+foPIE47+SNA?=
 =?us-ascii?Q?RmUMEBKHY8SWgi+LO2cwMU4/htqrgfXB26BER3lAURagmSV0GgFIH3Yv/j5E?=
 =?us-ascii?Q?QlI6kI+Kwn9DApIkSsTGvaSuCqFdoWT0/U38wpNmFWfPQLObZLIZAzhVTfFD?=
 =?us-ascii?Q?o6zqEcOBR/f9l3UabVgEHm8cYF0JwtDMj3b5/uEaY0y6SuvM3N/0CJPw+B5o?=
 =?us-ascii?Q?FO5RJFEWi5kCe9ksPehHMLTRskEDbOSm4xCgSjzBXurEVk2Zu6d7NPcDtin5?=
 =?us-ascii?Q?nPV5S7lgQybxaIE/AJzsnts1zvW/Cq6E5WLRVhxGv4NiG7JQfKoAOk4WPFZ9?=
 =?us-ascii?Q?oRXYjins+vNkIPoN74K26ornZUGClKASsMYc+/X6feb10oVdv9H2sj6fGSwp?=
 =?us-ascii?Q?6rb4edJ4sJDnUrIvIvVngKG1q0huRHzBDkYVSTTinl66uLw0qakcKKDpBUQn?=
 =?us-ascii?Q?RyAQPz2aUSOaantiffE3oLGi0ewTjptEYGw6t6qIdSvbGM+cpMqkLHyw4huC?=
 =?us-ascii?Q?RxhUOhAYvEw8jR8si+PqiHliDCbQPbYDAMDMzjyxtaibt24aWMouGskyxZQh?=
 =?us-ascii?Q?H9IF+HjpBixMc2RovOLj+dHeFDAFLJFqI4Mk+HPgahZndMsg464MGRoCNIpk?=
 =?us-ascii?Q?SPMyGkAPK3wdvPwVT2hnuuGGzVeBCIBelt3dRJ9uN7Io3/MFvan1ZTWQSKNT?=
 =?us-ascii?Q?pJZQ4kHlMlotJvBjSjggqvdQs+x3zQaj+edtrAIYsdGOeJbk8VL02G5b8MmZ?=
 =?us-ascii?Q?Fgb1VNQQs/ZQKsb/NcMFMDJ2uQu1CDZeHiBrzba1VB8joVhuFT5kCtZMrWlf?=
 =?us-ascii?Q?A+WmpU0XX8UqvuArVTD/UDOpuIJUXm/9chTCiad4LygqOIzF4XGG69LRI8rB?=
 =?us-ascii?Q?Kyw7Ia6M8dQ3BZ8BiAyB3j5jZL7PwT/zFIqZpgFRr/K3iLNBYijLKLmpde5p?=
 =?us-ascii?Q?MQg6GhI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?t089aOrbw7A3gPoqwLIw6sMm7a7KRL9INsX6HwZOOjSRN0Pu72msxD6Q6y5N?=
 =?us-ascii?Q?cG/hzhrB5T8m6VGtY6vwEMT8/+hzZuEjO/xoVdhZhGpYj7V0nQM+omX3ddKV?=
 =?us-ascii?Q?1XjFE7Y11W1qdZdiKgXn69OeBNCbfBo1DgIOjt5Wlct22DoCQNi8BzEwALzB?=
 =?us-ascii?Q?OPRL0P/+0f4hg4Rzer52+nsVQsn1jyj8kWNV27sxERDtqGsyKK2WZgaEwOlj?=
 =?us-ascii?Q?fP7PfNDm538Qx3HyiSfe4yz1Lp/4PO7nuvDkf4TPdwvprwJHXeGax0OGJtVo?=
 =?us-ascii?Q?i8CXc+nuXx0+7Tv+Z2ybEgBB7i6IALV3uTpXzh3gOwAoyVJO7tORcLVJAfo3?=
 =?us-ascii?Q?fxGBoCE8PCeDviI5kV1YtoKiox+T82K0L/WDLZ7l8vvec4Bo8g7jP2KdpKnb?=
 =?us-ascii?Q?2GWQOQNHLDfrvHZasBr+VcF/4OIEhnbkQl3DkovVAw165QR11EqAqED7itwU?=
 =?us-ascii?Q?C5p798B3VyIa6tRMSVvuyKLBqcXrAWRWTNqnFFwQXSCbFkAAV/u7QF4yw6TI?=
 =?us-ascii?Q?pSo0jY4QmC2Nfxho68EaHgViX/VYZIkmHLq8Y0EevdNy0DTXgT386lUXuNxQ?=
 =?us-ascii?Q?zgcJdDcnq9Ei+TNBesmOKs1ciJoBdvn/Ig0Hnyj9ilj9Y+5tuPgfNTOMsYYY?=
 =?us-ascii?Q?7nFbvR0HYN4LeIgZKa0dDoE/eVwlFbBYL8/pgaEr3v8wmzNuV0WlRM1rnVer?=
 =?us-ascii?Q?alTkm1OgrTCuxxqoJ+g7UO7mPH/4g918IOJAoCGQJqt+W+8zBD0rqHcSkMKT?=
 =?us-ascii?Q?q1MPOKngnnbFs1E/NK7/ky9+boVT+tj4Yh5AWp6UKeKkhjth+UoCK/s3FNkJ?=
 =?us-ascii?Q?qbz0gOD+YwfFdv2ZLocVEpzWOEqBdtEwGfungVtElt+cl0gWfH9TOW68VamA?=
 =?us-ascii?Q?uA/NG9vC5D8nao20jqwAZ5Xsqgjhtj/MFWL39jUI5WUwODdX2m2cQEMWmLn8?=
 =?us-ascii?Q?PdmSt+ZSxKASpnuAhVcpioDJwj16o7Ksp9WkqNT6UE2vs00R5J38iQku4HB2?=
 =?us-ascii?Q?JVscEzzyRxPMR84pHiSB831hejCZRM+jG5FY8Nlp4IpRdcDJQgx3qSj4A19R?=
 =?us-ascii?Q?gZ5wLqbgtCO4F3u7aAbYSgn0qVd2NEmAOF2sAmUVagsXxtVgYuAW13Cjlqli?=
 =?us-ascii?Q?gUWICxIOmxN/AWNShPcuAVOC5A+f628qEg9glH2U3XtB4GX01u3w9fwKCX/u?=
 =?us-ascii?Q?pukuk3p/7JxaizL2wgaNIsL8q5OBG4f1/e7yjX0ranm+uOIKkRHAPuUqmzcd?=
 =?us-ascii?Q?gkFf+M7Lc1yf/0kdCmG6VxVVDtymnG0hmFedlASGCg/JraamLtQcDoPbAaY9?=
 =?us-ascii?Q?0dTXWLrnvwoO9/qBc37xvd1PFXr62MaMDgwq6mbQaFZ97s32U6p/Oa1lvSMl?=
 =?us-ascii?Q?aLJZOnoMhgcOb7rUzqBAJudD+KrqivDX3zRrH3Q6iUh2t+0W1fkrY3NXEyu9?=
 =?us-ascii?Q?NgpsmV92bqe8CieV2WBgtAsiG9p4B2Ije2eMCLiuuZL89RSoM3lg4aQTZIYu?=
 =?us-ascii?Q?FhuPArYnYpwThbQY9w4qW0Rt2AqqUeqCKMfv8unBIxujU1hPBD1pEHjI4K+g?=
 =?us-ascii?Q?BSEi0ac7i5R+S4Q7pf1fc+oKqjX4Hx7NVXoT/NxVrVwky+lu2t+5qJF24Jh1?=
 =?us-ascii?Q?5g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <41E2514E8337094998A66B5DEB2C3E29@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1fpJjBxYmCfXPN+m1FcsR+vk/gsHD67QsS37O0tYt9D5W4QnJPciPm5aT3AmvR7HXvuYm7Tv4+iMiRvtLPnjsLla7HR2hzt9dcWEyt0i3wNv8E8pkLiTu5oXiPh4zyXrAe/KOysJbnCoMHRi+dmdLKBjM+sxUvRa9HqZQ0CEMkbdmHkCtQQw48PYfoI6KJr6V2KWmeoAGtVnHKxvspII5y4+urljpN9hJxdBXduea57vj03Ruwh7X/wc1Pb0MbTQq+CDYL1j+AQpG5yuOeQw3Tc6EYBgVbiQNOEBXJGwVhWpKJQU/rRY3fCFg/WwcmKhMbeVkFcsgyWsGphFA0c6+mtS3p5mHjBIxs7SeSRD5JkF2/7/7Inj8/TFM4DFAr3Acm+JBw9IpRl70aHVgkWLosgvtqFdzYBmAf/Jpw6sQZF4hQaZYau8kvlFsNnWIkplOLetW+bDsKQuETcOpFyuNJMf4iMq1mxtt+Li0pP2a+1xRi52IEof6o07Uw0mKO37xVukxDV1jZF1ZqWlU+PMzcO3Q3zaLukUTmzdclWN9pKYrSnNrsxWN8YTjclbvvSnGiDg2Eaa0n+DMHE5I+icaJ+zQddI9i0S3taYuIwscXA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 501c3642-6efc-4ef1-6cf3-08dd0378ee45
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2024 00:20:08.4874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mxx1pdYct6Me84ljQQZaWyOyZ2rfrOxQIsvupYsI/tWQuLOz6VoWlYZK3E7CJJXk9AlES8k9W7g3gLJnnqaNeeI22Y3r+05DWSUSelYtWCk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4584
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_09,2024-11-12_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411130001
X-Proofpoint-ORIG-GUID: eDOPdPAFvzab9IvbLxpLG-vIxrjdKaC0
X-Proofpoint-GUID: eDOPdPAFvzab9IvbLxpLG-vIxrjdKaC0



> On Nov 12, 2024, at 13:09, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> On 11/8/24 8:45 PM, himanshu.madhani@oracle.com wrote:
>> + switch(sdev->mpath_state) {
>> + case SCSI_MPATH_OPTIMAL:
>> +    if (distance < found_distance) {
>> +    found_distance =3D distance;
>> +    sdev_found =3D sdev;
>> +    }
>=20
> Please follow the Linux kernel coding style. As an example, I have never
> seen anyone else indenting statements under a case label in the kernel
> with four spaces. You may want to run the entire patch series through
> clang-format.
>=20
Sure will do that.=20
> Thanks,
>=20
> Bart.

