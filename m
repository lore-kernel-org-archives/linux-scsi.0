Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB1A1C5D77
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 03:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755227967; cv=fail; b=gSXg0bvy0quSJeg7R8OYnhhzan9TXi17Iaky+UHNmCpf4+HN2mDfzJr2lysEmU9l3EHx4T3sret7DsNXqUkVmn69bhxLp+o8lZFgMaiXbKMnVCQ+jiRvwkWqaLhPe3jtyxkC110m/qHRoTgW/XrsH/zGzDIo9L89J9L9ynlLqqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755227967; c=relaxed/simple;
	bh=x9t2Z7hmit+p0D/rTe77I/fssIq4wcBRy3IyveKL9NQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=jOt/4LVH1MkmX44g9Bg5um9vvLAfxjK2ytNq5pV0KCzaSQXmWV8wvS3EKDoy1Yy02eokVdgZIdg3fta6YkQUVpPrROnsmLsIudG9Y9PDx8SHJzywFruk1A8yNzgZ9AJuXQFT2+f6l+3/0Yzt+d35zhLaBW74HF4oOpohLyTWSaw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X7ekIymt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LgKMelo0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X7ekIymt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LgKMelo0"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57EHfo1g020800;
	Fri, 15 Aug 2025 03:19:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=NvmgK6eNymWj1wQ62a
	DWUIpv2MemHwaAGhY8bYiEBNs=; b=X7ekIymtzJg3PYFruby1OpN7oi4wG6+evp
	bslaApYAoW9Aa7orxdqpnHbV+sFMfUuOYD+wDirWTpyIXct92a6d/Okxyck2nbdJ
	8Nmp/Hy5gkC63VuizeDSyQty54yzgVv8SOyuePxgjT0hxQ4HrsFnz0cSiNNQeX6o
	hDDgtU5V07Jaw6ukxCJUXM1rhDrVSF/fJ2+ew30CZwOV2Jhvp9V4dSv8Hjiqfg5S
	d9nAmKzXsO71GIcOGwNQfmoCJ/X6tYJ6ORt/xKSsFOzjmBQspeJA4CwjPvNce8q6
	0xzyIHM6fVTludWZR1cOcqNHUotkMGagm13vAVVAfQJSNgxv0XKQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dxcfbf1g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 03:19:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57F31SCk038543;
	Fri, 15 Aug 2025 03:19:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsm3ym0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 03:19:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vO/WzAnACFZKpCvRDc8XxX5FyTbiAYS/qcD1AGR0bQLwBsRNt2PEWNrTO4OVGCegkgqMybL9bzXRp1yb6XfOAw1G/VfBv0OjerqRoXUElIvIBq74L656XwxKAIOi+BP8ojdi80L4k8TtBBC58WtpI8nt/7Mfn+hYyEJKUOPwlkrarQSyk5gA17fwqnkF/TID5Nuw45g8QACnJKDieeTgEqhwSauGs3kgMkrDZfyHSI/fiyTFLIKM27Xm0sptzl2JzeT/oAGrK5F3dNiAXU4aOBmSBLbKIN9Qh9/qxrv45DyM8CNzghbm1qPj1BfsBNWGoiRxeEO1YzuKLRR4zMh+9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NvmgK6eNymWj1wQ62aDWUIpv2MemHwaAGhY8bYiEBNs=;
 b=WGgq7YP8R3p6HPhzwAdkUHZHUd5iOqEYyW153vPpa++SAka0uHk2LK0kDASOt49J7pYF6GYW5WQwr+MB6GdF4I48anHbIuyjEVCKDUlCXH3ethm0scUX7ICEbc0hcgxiZuINpL9AGU6h25gfw7mUFA5nMhsJRcIIaWbUsITlNf5JJfyCD2Cw9KyVt7TvFoTYha54Npd/KcxZDgAxgW/NqfXgSypfWrpUmPwDNyq38Ov/rh1a0Yb4FRUYiip9/66b9bZ+qaqIS5oJHP3tApYydwzyjFQo3HUHeu/dUp38A/UsDFzT8sRa2YV4shPb97+OqxT1+VxRuV0niXWKutmG1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NvmgK6eNymWj1wQ62aDWUIpv2MemHwaAGhY8bYiEBNs=;
 b=LgKMelo01TNojXvf0VPOez49c+1nD++2PjQsOyQSH+6XVgmo3Y/eNMc3ory6DjTc3s0s55wAUroL9RTdWZUc/Ya0+JJbN5IMgJUdY47NG7/DRvxsIsh4koHWalQozKNPYiSLFKc7FiQEyf3GoY+0HqA2nHNhWH60aORsIZ7/tH8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY8PR10MB6516.namprd10.prod.outlook.com (2603:10b6:930:5c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Fri, 15 Aug
 2025 03:19:07 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 03:19:07 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <yi-fan.peng@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: Re: [PATCH v1 00/10] ufs: host: mediatek: Provide features and
 fixes in MediaTek platforms
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250811131423.3444014-1-peter.wang@mediatek.com> (peter wang's
	message of "Mon, 11 Aug 2025 21:11:16 +0800")
Organization: Oracle Corporation
Message-ID: <yq1h5y9qnso.fsf@ca-mkp.ca.oracle.com>
References: <20250811131423.3444014-1-peter.wang@mediatek.com>
Date: Thu, 14 Aug 2025 23:19:04 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY8PR10MB6516:EE_
X-MS-Office365-Filtering-Correlation-Id: 37eb4769-7934-4c5b-6a77-08dddbaa7e9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XXGF3LIGV9zaYD8XR4LR94Tsc2jZZxkVoxmEiXFkndgMZ7hMfNmTnWTyuufz?=
 =?us-ascii?Q?VJ4S5v0QMJJzfmKIqFBPbdoNALJof08WaZOwtzWPvLqEACrorRKDy1AycJRF?=
 =?us-ascii?Q?hn6JCHhfbo8TQfO9/KBiaIJnkJfMWK2xeMnKTqB7JTFRXkDmNU5Qw6UqH64U?=
 =?us-ascii?Q?a2ZK3zPQY1HFsvheOG95f+jnCa7+jg3rUIeeJnNTu+5iN8vDKBHWtHnuI5tR?=
 =?us-ascii?Q?EYGB3KpT7muYdrSZDjahmEYMoGYvf0KltqQdVuCcgmtegNEm1M96Hqewbn3L?=
 =?us-ascii?Q?WTzlME9tNiQ67yA4GtQI6ZFMydS2Jot0MXclK67X1WlzwSW0JVGcvt/X36KJ?=
 =?us-ascii?Q?yeaw/erHWRUMKIgDO/c5qOlDWAkvCbxRJtH0ptXqhDU4EWv618Mtl1kEMdao?=
 =?us-ascii?Q?uD3V5wzaOeXmGAwfL54Vcyqemlnf1A3sMYXwa+CV6pfHPJ5OqNQ5I0lRwN/I?=
 =?us-ascii?Q?Cq8/fUcX20/yuLrRn5pxu/ekng3rgnryIcN7b78MaoACnScdVTFW7hp+C/7W?=
 =?us-ascii?Q?5dQGhLRLaoVJO9HCWwoQYFW68xCXuMFDOESNNvECkjgRDaUhugLkKnnm+U9U?=
 =?us-ascii?Q?y+wxiamiRZKxtJ0K9DY7boF6R61yDr6X3PyWhyohMiLdkNBUUoFSDXvHQ9Uc?=
 =?us-ascii?Q?P3588PZQSFXM7K5KWpDb7hODlTrTWPAZSJB5jU78KidD+aemUfIIVmTU7o8O?=
 =?us-ascii?Q?YMqVTxb4jeuikXp3XZB5dmn5ukRrQZhe9XH2aS6N/ySKWPoCcI8wUI/pFSdU?=
 =?us-ascii?Q?tVWzbbn3n06fSMTCADdvc21Arj+CLLmQLBWAMCVAUerAlAolelIUyDNAREWH?=
 =?us-ascii?Q?IwK1t6x96wvIH0JnZWwoZz4pvixgRgi3oiev1Dx1J3H6ESUOIsropUcSKuDP?=
 =?us-ascii?Q?/cX2P69j20brEx3vaBABWG77Ar7g7Sx5b9n4Pn28lFLi8Aj/wBOPOce2moRY?=
 =?us-ascii?Q?zSRLIGfDvDJyVhxplkMOvRwOcoV6LtG18nBIAJrTbymJRQF/jXtf++Ub3Z8T?=
 =?us-ascii?Q?LWK4xA/zs3me+tj4k6EFMOXszxNS2vuSb/dt+cIFD2t2Yw0+iCCz61hLKSl2?=
 =?us-ascii?Q?q4Qe0pTG/UdeuRg/WexrJ5KfYCQrx/BeM0KMz/gsNjBadHpdu/fa3xeibNhE?=
 =?us-ascii?Q?QS9JlS0I909sMPLNE9MJ8sOYT/9CG221y/lSrcmrWWvxgcLQBE7h6HsPdQLt?=
 =?us-ascii?Q?GiWREvmgNHPIL1lBpJHBaUSjrk99xMu0GL8mOoMnOXolpGM0n6qd8nUD98/+?=
 =?us-ascii?Q?lOM/zAPcSjZI8RVvNA0TX7aajIS2Kr9t1bUQ36NC3nr44rqLHVEsQiuH88i9?=
 =?us-ascii?Q?QWQJXNR5/cM/s7D+CvH5MJNZ5wct9rswlrK8rUNqzsh9RvwFZdu1WVvy6DLc?=
 =?us-ascii?Q?4wehR7rfhmyX2IPS9oKpizz72HXLNrVaL5M2beZnigqPxE13BA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W00+ePlhh3vM905csSiARCL3GbluQh2TvprzhWN5JZrgYs7oi74EH0BPLVXB?=
 =?us-ascii?Q?lzi0vpsZSQcWRhErubnz01vKBXbLl56+A+tu+CJsWyvBecUZsFxn62mCzeZ1?=
 =?us-ascii?Q?UGls8LIr2WXBrAKmroMGNlpXhzjLIjRdm5e7Tq4JOvxdqVNXepU99leJPLAc?=
 =?us-ascii?Q?w+mXMKhBgFcrEylTAE2gfo9/pFLNEdTEtVBb26R8HfwjddoGCS5wSdz9IY/z?=
 =?us-ascii?Q?srZeC1jAiJ7KOEAFCEeoeitkdJBYKwd3gwkQHKw44W24HVt+Gn2v1nUekvpZ?=
 =?us-ascii?Q?UexIe21mT8xmpgdPeF4AGpa3tihmEBaXYxXWxBnHrCbCRPZTpWYux+B4Ss4Q?=
 =?us-ascii?Q?uc8Xouxpkh2I5BQuJPdjSTsejZmqoBtDfcQh9oIWJDW1/qHy8I59l2mhmQtG?=
 =?us-ascii?Q?KS1TjwaktBekKH8UbV1YcHYfEWoVCsOdQ5Ozek9U/APbEe8N/zkhanqvsyjN?=
 =?us-ascii?Q?IWi92BlNkN2acMw3DTWB22qqaSMXbqzXC7m31BBnpoCAvCGNGZKgVBkhRrXD?=
 =?us-ascii?Q?gf1GxoOJB1sF3q9t4f82S03VJ1xMZ7yF3VK2LuXYwxqIIewRV5JSw3hniM/t?=
 =?us-ascii?Q?0FSkKqd5IolXLo+phQaiwFu7MPxVSmmg+czm86gTCIooYfMFpCdsgWtDHAfZ?=
 =?us-ascii?Q?9rSOeNUIne+ZWm952/4izfZ2d1eDDLc62p7fJiE0PkCAHlyJIFqwvZVQaySE?=
 =?us-ascii?Q?iQrYmhTWOU1QzGUIOBy4xuiWBnfWZJd+w4Ff8SsRr3piKjOXksAIakKxPNrk?=
 =?us-ascii?Q?svI6ffFFGipHUIrXI3v7F4IedXXRKeo46fF/fOEOf/bKAeWtUI5O2xFXmjZ4?=
 =?us-ascii?Q?msYuvkkPYsoESqFb9PCFTccuWKUV8P2FKfOXEDBOKKVjEu/1WYKr2Gqx3+bG?=
 =?us-ascii?Q?SBuF8m1ItweF0itPmwtcshjFNukad4fnM3BFzc8SdE1Ea3lOz0Yyz4fK2V3m?=
 =?us-ascii?Q?Lzz5nRhENtKTbKl6E3UBUft43wU03YsbXFMuP4/y6HdiII2sTVlTiEejI+x+?=
 =?us-ascii?Q?P+Zii1AUimh5xqiV7GlSbINVGelQWBT2/9+fQZ7Fk0WCNl2kbmQRjVsRtxJI?=
 =?us-ascii?Q?yqfk8orvIykre46h2xRYfprxA6cRM3G9HRDPp28wenz+wWTpRrSf68DcqX2q?=
 =?us-ascii?Q?dkvT4Hnc5JVHkIkbgfvdCNsFnWxA+yY/rZ/7ab3aHTD4NO3jOSj3iVSZIWOq?=
 =?us-ascii?Q?0fg8gnDyBe7F79x8VJFnGgkNz9wODC9Yz1K41EJfFznklquBKvJvYzV42cWm?=
 =?us-ascii?Q?xsEYcJ3aDYmxdOccXX0blEogmjvNTsWTwqHLf9gIcq5DIRYaJUdyXOp3ST2I?=
 =?us-ascii?Q?FzO23m3DjTjnQ1Qmg6BFyQyLS5Yn7+vFIYi6vWbgJKaAl27r0X9y0VMSEIO7?=
 =?us-ascii?Q?qU4HOFv8YvXLFY3u/uUEctX/UExaeE/nB4W6+u56I+bjLqDkdMuQirsWZSSe?=
 =?us-ascii?Q?Ybu1pOgptGtod4cqmfz58v15g4tLFvM7zeSkJTIveS3PEroE3IYz+bTjpOIb?=
 =?us-ascii?Q?3GkPruFQxrdz7vr3nulW+MGjGhpuSH8srKIkAXUrEYcc2zZ2kRorshXK6JOK?=
 =?us-ascii?Q?8xKYONRcBGkw55U6vvUx8RZ/FWts+ps9W++tJqUFYD5yNyjdImdFPujRPl+J?=
 =?us-ascii?Q?XA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K4zSzFtzlUdNM6AJ91PdJ6o0xnMutiyBjzEFEBibnF2FSxQLnOqJB42yMLwsEzma4VkNYF2LLMFEK4jT9JXxyxGLzcgO44Fcu7QLxulGydOxjr3BV7A+IILD7lT2q0x4UYNTm9+zQlwjH8wlRw0eWFaYljE1a3SV1OE7j3KQn7QHDG5gKRr+jqGjYzNKsN8wbZ9YsyjMHyA4QI6fiKu+bljWGm6IQ8IG6H8oCMdSJMR/jbOhwf11t/Jw1IRYRPjWBUjhzuGuWaghYzP1HCaOCj+zFwwh2GtZSekpPRIcNDlyR4ZjAhgCjpp9Rc5UUCwQZp1S7yYTryPUZa0hCG8aUfejZX5RTFGF122loujEAsb5R5V3eyi9G4gBhL3J2Ab9idu59cVG/bITSOninGbGj1B9FAZw8kl20Bw9/Y5RhoE1YfapSiOJdeeOEh2JEnnDnwaw7rsOj0Zr8PGfGMUr3ShT64RpIsV9GRTm5iMgiuvyGsOW2NIwVx8KtW8doa3BMUhDd617rDXEpakGNQ+SXOuuD+e0kxHrhCC+Bl1yOvArM6NNk4/MgDpxBsycg/VSdpi7Lld1Pguhl2+xq7pI76AuiqFKRHprp1or3SWShdI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37eb4769-7934-4c5b-6a77-08dddbaa7e9b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 03:19:07.3666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fimQFm8ZjpjZWuxUktN32r++DyeruBWsHHA/nIKJV5b6ff8yNk7qVxIWp8zEttR6Rf9FtRWKOtOAwB87lpsKggdyyRCV5vvZReuJOEznKGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6516
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 suspectscore=0 mlxlogscore=709 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508150024
X-Proofpoint-GUID: WGlmMevBTMerfrhYd8NGXN11tNeryVBB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDAyNCBTYWx0ZWRfX3ZFNxnXIlLVB
 d1zhnUYg5qPQg+0A0SlvMS634D1RCtk4/fZbTPS2H+0uGCNdLKDimDVg6uEk4+FHYNW3KHs9aHg
 xgYPYYz4CvJQCjGf/ob8CH2RqV7BrgVieq4Q8Nig0mxa6QVQypZ0jeZ7c0dZ7DELjpFs97EqH+5
 yy6+RJ3CBZ9vvB9aJE3RDlc1DKv+yflMpQZ3gRl8acQZe9kKlxe/YSyV367B2qdUd+r89c8BBo/
 QSoY1bHCQm8hyxd4N3j+dGDwBZCkLbKoWMINQvxoJSWboNx03ZgCo7q/cLoGZoYCDGGQoG+ldwt
 2EAW2UeFVgTe+THv5CrPjvQ01VAmJ6EGHRg3vvh+Q8DkvE9SUbryn/bv+py4h+N2hEASZtnw1Rs
 qNvnEP4EvcmnjXQ7RlvU3v492o4/6QJ5xF6RPdydVdJsHIMHevHo1tYCJctulk9b3YqaSH3E
X-Authority-Analysis: v=2.4 cv=W8M4VQWk c=1 sm=1 tr=0 ts=689ea72e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=BdrA9yahslMVlmzdRrYA:9 cc=ntf awl=host:12070
X-Proofpoint-ORIG-GUID: WGlmMevBTMerfrhYd8NGXN11tNeryVBB


Peter,

> This series fixes some defects and provide features in MediaTek UFS
> drivers.

Applied to 6.18/scsi-staging, thanks!

Please make sure you use imperative mood in your commit descriptions.
Every patch started with "This patch <does something>" instead of "<Do
something>".

-- 
Martin K. Petersen
