Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DDC4502A;
	Sun, 31 Aug 2025 01:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756604608; cv=fail; b=kIzkhWDAR5wgaZF8LAvIZD2+AXS4j1ZU25Y/v7GBni98lRQc6NF0wGOymB7yRCgm+L73WDQpOEb4wPd/xNb8GW9lVbPLMFZOuJaeugXoja9YQzOcStftYhh0Hf86e6ZmsjzijmOjimwdsDmFLPOIgUu14xvrM84ut8ODHw8VJiQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756604608; c=relaxed/simple;
	bh=yojNIIT6+U+QRwrO1DrSN5m+9vYuSO6B8gaIhvRVfWo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=NAUskQTGb3qFdL5Lx7PsFM1aMoi6Ay+pfpbxYMKdRwhXVQVnNM1zr1i44qriMXgYK6XKnWp+VGJHgYiARWdY9z/CqQDfjZ42G0XJfRlquLFyuSawwiTj0pnWgneccKF2V0HHTen7MXhgmUvNsXMwa11+aax1XxOlZObWuRwhwbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dLk/RVra; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mezPobEK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dLk/RVra";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mezPobEK"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57V1e2Zt021447;
	Sun, 31 Aug 2025 01:43:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=lJ2780AeyAuQFLav+W
	3PTcPzeDtJWaGLQzF1vppMvAM=; b=dLk/RVract/HZn4U4FG7e/WCn0XjePWF0o
	53XePI/9gfPn9INTczuKpDAYyq9HqU6/W6oeEnBMfaSkgD04j8HpD4SFYyM6bO4F
	I75zqKfntIsOUXJ5mT4kK1pBgPOiFQVHyP7ttY1llTN6ILIKzfYN63cBYHFlhJjr
	bN6V24AggoOkTmS4dux4W24h6drZEBPNpNCtTXZ872Nl0XWw21qILFtgQ9PzhzkQ
	3pp05JUP0rcgc15GPcWxrO0v0Yy6v3ytsvDfiXWiQBpiyAJ6GGHExXo5bsatEzwv
	dGY7bRqdO5hAxah7HApP9COmCdYOk6boKQLIKbU/9RwKEwR7ZZwA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usmn8m5e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 01:43:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57V15DgG004329;
	Sun, 31 Aug 2025 01:43:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr71t47-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 01:43:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cGgUDQoy10+RCFMEt48kw15Py+c/ctsq9XuNABNiaDCPqxKdamJkosRK/+/6hbnEt5F5ezFn1Glk7B38+XCAk04eUsZPUPDYUOVz7kevTmb51fQcnBhEqLSApr6bnlV0WdjL/uxtw4VNrph6M6pEUblNWATA3V1csx3mSEHRmJvQzkGYSsaVipht0aKYD1JoG7RtVdkctbG9EpToGqU8aCAR5nan+3PSo51MAK9Y+0Bn6+ydF+uWI4OOGe9+jpWCNofvurTCDkFPbINGFIRqvzGZCk20oglLHUsTlumICqWlKI3IUlA8ZCC96GUZyJfiaPGafDDyPmOE1Z1DVOToFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lJ2780AeyAuQFLav+W3PTcPzeDtJWaGLQzF1vppMvAM=;
 b=Pe7xBkvA03KMbCa65Z2h8azOAopHcQCHC0PIV6a7dGqwSKm0p6eM8QZ3pMqHp74kbE38GsYhRe/qrN+A5VgHjn2TDkBrfIPn7+C1AVmp+alNwDpYeaJ+9k7mbYJi8Td/6IZhGkQyZnva6rv7bfvKYP5i4/cdfWi4fglHL4F2WTVuavgtreTxmEuyU7ihqgdBxCHoD/F9+0T+WTUWi5TrsGNONtizxCH/M1LiysAq5oSDZ4QHxrlJZ6XkpBSE+o9hSRgtVyGYBUykYJ/9X1AZGedDurGkHIlx9n07ZLx7t/UGypS0sYSHqMZUgCipsPwHlh9qQFOSLPHj/XX/1ZzxNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lJ2780AeyAuQFLav+W3PTcPzeDtJWaGLQzF1vppMvAM=;
 b=mezPobEKpD0Tc6V9NsODsms2V1bxtto5ph82U5EOlAA38/IagH4NPREHDCJbtRumPhWvsIEWg1/js6AcdLBwxwuj77EuhpUWLHtE3OfbPl+e+yNtBAyrsSSpnoztnaEfopch5uqbVn8FBqwrDi8+d0Gi5IVwyZwoZB52pNSUox0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS4PPF415C917DC.namprd10.prod.outlook.com (2603:10b6:f:fc00::d19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Sun, 31 Aug
 2025 01:43:07 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9073.021; Sun, 31 Aug 2025
 01:43:05 +0000
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Justin Tee <justin.tee@broadcom.com>,
        James Smart
 <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke
 <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] scsi: fc: Avoid -Wflex-array-member-not-at-end warnings
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <aK6hbQLyQlvlySf8@kspp> (Gustavo A. R. Silva's message of "Wed,
	27 Aug 2025 08:10:53 +0200")
Organization: Oracle Corporation
Message-ID: <yq13498feqz.fsf@ca-mkp.ca.oracle.com>
References: <aK6hbQLyQlvlySf8@kspp>
Date: Sat, 30 Aug 2025 21:43:02 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0155.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS4PPF415C917DC:EE_
X-MS-Office365-Filtering-Correlation-Id: f85020a0-8d2e-477c-cfba-08dde82fba49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oPSk5fi9e2JMEynzOggPhF57dv4phJDGAWdo2wi4+wo119ZQQjISZ4EgFpCX?=
 =?us-ascii?Q?jiBpZLZyuMdT7pjFLr3zjjZZ2CNaoazw6bui3fMouA5ueplc3rsjwso3W5q1?=
 =?us-ascii?Q?g4/K4uJMbMc9FbhAiTQUyWNOp3aOUBOO2S6La9GlJaFXaVMtLs70M7vjwm+h?=
 =?us-ascii?Q?pP3HSrW0JrFgQLxmfyxWo128VjbErVtCVo7BLe6ZszhVSUX2kwJwoK3fZ4SA?=
 =?us-ascii?Q?gVLs649rrNzch9iD4GH6vuuI3uZ7FyKSGSBuGre5Ytr8NbOY1AeLFrmia78I?=
 =?us-ascii?Q?9SNjKNzT7UeVoY8rNlS2qI8cX0CxQZ/3B+2rcVao4yyl02x5wz7kYQ3gZxgI?=
 =?us-ascii?Q?MOso//rV7QVjV9v4M+tRh2sPu9l3YbUNKkzeciOTQQMu7XEhu2D/7Ccb/juz?=
 =?us-ascii?Q?oJ/VDDEebX1Q9Lm967S9LyaZNc0uQHeHLHst58K8Rj1jiLh9oytjIhqKispE?=
 =?us-ascii?Q?Pm0GN0I1V/dPB4LbXhukiKSqCeaLWSXz3xASCCSb00CKBk+zr6H6ZxFoU4N7?=
 =?us-ascii?Q?cd8Xz5O101bnY/5lRftfHVoum4qeu8CBaZdXoVSgP448/XyDdr0PEVuRZaz5?=
 =?us-ascii?Q?gU/wkbTzUTw93ud9cHoQCA/ApIzzNbDJlTK33M6b74vM2XaSLSdfJmzbsGoA?=
 =?us-ascii?Q?GUr8Zx3E9+P1p21yzlXrxnUutGyO9K0Fd9OuScO3SEgTHC1bRsplz35SITO2?=
 =?us-ascii?Q?1xdVSZmNquL6pOqgW+qK7JJ7vieyoCI+NzjhXzr0slsXeQxGAibBNbo82XCW?=
 =?us-ascii?Q?Vb4M+ZZWTlHF0ITrz0KHZdoePnGzO+GXnZXAQEPxxsADH9SLgb2xqPDqquVO?=
 =?us-ascii?Q?fLHMCkzycYFzBebWlEeMWNhdI9aL58LQ1KtZAInqlfYzUGpMEA48qNpZkaYO?=
 =?us-ascii?Q?QGPUP1QwEhwIZXR2zNzGCoLjApnKzEvizZd1sdVpmGIbBzRKGIQW6b08OZ25?=
 =?us-ascii?Q?eLfCL22DLAFEA0fvIy4FrI/pxW5UgQUDKolTvvNB5z85moKaANqaXdmaxWIm?=
 =?us-ascii?Q?FrtFavTFtAulvWjCTxmkVM6i6CG5s4Z3W6JmpomLBL6T1bz31Xw1OIIBR6Hg?=
 =?us-ascii?Q?jSWV46cvqugWcYPDeqGfteNNwDcEUK1WMM2TMhNYuT9noUqoYzghW3zaEzWC?=
 =?us-ascii?Q?5lY5iJDHZ5OP63uWEl6qnY+zPlxiwbWgt2KVyAf/jPWeikUlAH8xa/37cdPW?=
 =?us-ascii?Q?3JA5bd/5JFQsTrhnYHHSGvWXwf82UTrESIGEX7Y9mDLZLQhazMlpOfyrF6i6?=
 =?us-ascii?Q?aBK5biOWeKPBjTPmcj3+t7M0nuTvHH/8dSjCo62ffrBaHIW6YxUiRcJWangp?=
 =?us-ascii?Q?tOD8kncK/b0xsFGd9zyDIHDz6yhr/Sg+AOR047hf7ysWDLt+owN8lNStBpD/?=
 =?us-ascii?Q?feijoE6RPK9Qr9/97dMbwZxaup7FX0mgu9+2vvok4XjQDqmvTdTWge1wa+aB?=
 =?us-ascii?Q?846wyixfli4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vgHKzSPXf0kAgY2Rm2lqbUo1dIHh7Ie5eOk63ywCZH10Q9bmA+4YzmvD+YNu?=
 =?us-ascii?Q?lxGbZ6B+s7PdPTIY3cbg5IK0LxcYzatOeginqNyUc9LP2Pxm3dnk7aCO6m/H?=
 =?us-ascii?Q?HzStB3w8W3ZhWJkpdwRb6qu07sGNtWWeq3kbfc2ZJkPJK6P47WHrFDOIq6eV?=
 =?us-ascii?Q?+Pac/OCb+ohhtaIiZEM5fcsOpHnt8wtV+A58apCq2+1+oItaPShNUcUKwdwZ?=
 =?us-ascii?Q?rxJXRLO0jtBBpWfkJF5ubiK3u7JOrDSyH5oDRxGBZhi/YH3tv9Ivigwi8ios?=
 =?us-ascii?Q?h0VXicmJzAG6x5UYa2QqmtF5d9bYjilNxyM9ksQqMkILS4W9nvZkUeh58YOB?=
 =?us-ascii?Q?b+X4fm50x8OA0Tiwph1e1SNC7RgtIUH8ua7Lfi9EZUg7UmMNbb2X/zFI1E2a?=
 =?us-ascii?Q?I/FUkqiH5dT6XyvnjiwCtwIAWF+J+bvHSWdxtfGk/uZaaGijl9YZHA5qP+L3?=
 =?us-ascii?Q?Inhij1VsO3YqpE+uP49gLKEl3+PTtnWS0YpEZaG+3FZ73w3oyteBzubt/GfB?=
 =?us-ascii?Q?DkMpA9/VOEdLttb8XZUGOpFukh44udjZfEY45JGyqMurfIW83Tq4uY7S21Ni?=
 =?us-ascii?Q?CmUvabL4n3XDYhZBQPaDWccT4WYR74VfnjVtm305wEoH15VqI73cFNgvOXNV?=
 =?us-ascii?Q?2Ce0+jQuDBHmW3b1/eifBCe9nMsM51sCRFPuj9QWd6OOSLpjtW4wjx4McAlq?=
 =?us-ascii?Q?Z6f31jjXKxnYW23qWY8cmhpMR9emR6iluqjxq9M3MXCQ42BGPfY91b6odJ/N?=
 =?us-ascii?Q?evaddD8m9epMnLSmc8oPT5mTnIh6FaKUkBLEWBdP+vThrnmlbbeAt32YvC3O?=
 =?us-ascii?Q?bswnzOBh+9so0xFBHnQkoQ4rYAq1DaFy1zSqpEWTWwxPtKrB/QbThc63VPJQ?=
 =?us-ascii?Q?NIjECzsLUqHW3f0Vy7nixbhNoTLycwLRRAnHh94kcc4k3V2SO4S1ggg0l3OF?=
 =?us-ascii?Q?rmEbN8b+8DlGazDZoks3qzK54Gu0imMZ+04Jb9Wl4unx6VXYuH/TtrUMvMzC?=
 =?us-ascii?Q?uz3OKnbZ5IKrGt+ofPs5UtnpqHIz8TQcXA60VjHdJCuNZbkQC6bs9i4OEK87?=
 =?us-ascii?Q?Zm2/37LLu6bbOIHfEs/vz6+Sk9HuND1TxZJ5Xu0AqLRGqRRpqQYV8ehMI5ut?=
 =?us-ascii?Q?XNmzz5S7Xz7rjCJah8cbFLqpsSkijX4dNkT32nQg6V2HAYn0vudkzGOomZT8?=
 =?us-ascii?Q?U/ARRzRs+womgyTau8STxUDmP2zoNLxsYaUQr6l+IJ4t2bboVjRZdOqBif7n?=
 =?us-ascii?Q?I+l8YsbcnCe8IjWCKIRfx9NAzxJmvpJRiG2WnTII1uCoJAE6g9jNGPKW99x6?=
 =?us-ascii?Q?dXHyjm28GcxuRPv7YSx4BvUoYkdGbhruRpebZVLHDybZzDiV+cMnTk0U0LJa?=
 =?us-ascii?Q?0tRy59WpwhQuGG5SqDMVWpgbkfo0UmdmjgQdXiWB49XgAaPhWAfascP87TKz?=
 =?us-ascii?Q?1N9xltMizjh3lxnH7PfK+sN2Kk9ijkUaMzKbm1e8CIJHdT6wcUdehF58kek8?=
 =?us-ascii?Q?Fglgslee2vpkx50IpimABdSIbSanr1002+WGVu0Is+T07Ew0Jbalq6aoYSyI?=
 =?us-ascii?Q?YURTJl2PXrf2xMYiyIg3zUJOwH5r6V3xoEouffdAawJ/+4H/t00g2OUK2u1A?=
 =?us-ascii?Q?Wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VIrV9HHLe2rFttHWtOgrUHxHtJOpCHx3q3PRelS61Ae82yQXLCmYVmGKHuGzCalA03aEV+I306gxSjM9m5w8WGx28HJJok++PpRX/sseuSl4blsUoap0eY0IAngZHBPspemKtUNyajHp7aS2SP9kanqlBzIL03MQjU6BgYGvRYvOVjKr/EKjpuik6+x2K6+7VM4Vb600r5oDpLEZBqcX2MshJe0MDuvFQ6huFD3gy3srJpOlqXSS+0JWIQq8fyUorUa7UhgiXflVh21uRUXzrAXXeM3frEaq5xlSQ6Aw3CBJnBVBQoErXzfUXd3RbY+VvyTOgIe68mmyy5AXqI65eD4HUn7vrWFhewUWAwRQN6MVIAqE++vgcl7E3QBZrzfNjW4pa+edgOJ61xG4tl15W0GIxF+hhPg82xyKv1JmV5bzpGewxvtlWIlxHZWsEa7a1FJ7dwtPNax5Fj/HHSoOnd8TvAxjbuxcKLRFHDOz4uCM4hd0TMlk9bqqYJiK2gerNxYKS3IXNsdYwi4s5aBy2xTp+UPqulJNuUFGuEJw9ns99R3aFYv/DnYcrXy3fdNMKZzWbQ1QCG1Kx0mF7t0B+9+C2FdhITKpkWTbZcXgpEM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f85020a0-8d2e-477c-cfba-08dde82fba49
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2025 01:43:05.0915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fTooWLilU3xxpFE4oGaOK+Uae93zhMELZLc5pqxKdSx/sj6IkPBXMl9HkxyyMt0q9r/7Np0OfzDL/hkqGV6lc41iIWLGiDIq3VCz09pGHBk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF415C917DC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-31_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=815 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508310017
X-Proofpoint-GUID: nMewiKB-rmBYvGsgfOnnmLNpp4BLBr2W
X-Proofpoint-ORIG-GUID: nMewiKB-rmBYvGsgfOnnmLNpp4BLBr2W
X-Authority-Analysis: v=2.4 cv=Of2YDgTY c=1 sm=1 tr=0 ts=68b3a8b8 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=dl1GdbNG0AlQaFgLmo8A:9 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX/pEeRm5a9Brz
 ZzdSy2TScjzCsuuhcKrWs94HHSzeR++3RPMUug/rzz4iCNbzlwqzf85yz9xscNRWLUngCaRZeEm
 byAHBfIPaa67xm0mEreDCBXjPUvCwt2BWqxLzWJN9QUj/MiAEpj4Bphku4yYdQ1LEbdfXmw8Lml
 NwD2nFo6vXrGs1AwPUkZkU8hlGBBM0GBrL0QpwWAdD9nyQ7Wkd/E1HRx5vAYbcaGB0GE8iwE4kc
 gsUaU3YrfF6kbMROXfK/KxYTK2DCkfjG5z5UMPVSStLOxP/IsLM6OhDBhz3VT8mXPEwMMZqka9w
 A0kFAG/bv7TdDyTkZhvtcc62W6HIxpnxzoOik/d5aa3Ei15G33oSgQLxpdX1u2DxO/gdjpSLtBo
 YD9YQNrZ


Gustavo,

> -Wflex-array-member-not-at-end has been introduced in GCC-14, and we
> are getting ready to enable it, globally.
>
> So, in order to avoid ending up with a flexible-array member in the
> middle of multiple other structs, we use the `__struct_group()` helper
> to create a new tagged `struct fc_df_desc_fpin_reg_hdr`. This
> structure groups together all the members of the flexible `struct
> fc_df_desc_fpin_reg` except the flexible array.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
