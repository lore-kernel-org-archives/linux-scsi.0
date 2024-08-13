Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5179C125A9;
	Tue, 13 Aug 2024 01:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723514003; cv=fail; b=T9pwKrUQypGujjbm5GzOJjpTVnMO2su8wFahDM/Jp9sguR/br4hZJJC6wGi16mFYKCIobsdnJEBxUAE8nXlSfIO/x7kQUf8yZ70BKxTuS6xFrGzU6AT0V0gWjtwEzFw8CYkkt99YyzQ9YYXqG9V8+enLHVs3tkzf1plt1yl5qa4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723514003; c=relaxed/simple;
	bh=Hdq9yS/ZclNpQjMCrEy+j8t+qEJFhQNPdgcrzX27Wqk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Uq9gjeIfDjn3GUtQmFyS9KfgvVUWJJKpxbjlKnWCf0kQFBtEhwlLWJAEacEPaFozUbWKg5nqSNwtSmLNcRfKFOL8yM8gfVnq8NB+2GgglLGz1QKhK8y51DUa75RX+XA9eMugjgqoiNdp7Y8xsMG8tCpVbQXTCB970+4eoyqZ3IY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nZPA6pdc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MPwPF5pg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nZPA6pdc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MPwPF5pg"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47D1oX2K011577;
	Tue, 13 Aug 2024 01:53:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=ck6pb1o+rkJ4JJ
	CPNmdPljUT3FgxrPbXCuEz5nWku7A=; b=nZPA6pdcAq9YUKMAzRu1Mh12aMHqyv
	Du7G1ZAFiPA9ala9nd/W0eaO2rBvNO0w03YBETUk9XOtA659s7UILsiZAKOqsRWs
	FaThBEZ4+H6ALOceEmG5YXBBzCmsoIpLQBEy9I7R66xSQHu1N5W8ZOQ7TP/ua9Ij
	RlORCTKkWxUgDKuXLMdi70o6EfDIZ0P+RJ7DjagIMBPmkgcbwGBeSKUGHEIDSIqQ
	fL7SF+9G1E4R8t3/wQtFtvgWl8A3jvqRxW+oy2+6U5FR+uw3HOlwFe6NNvEw5flh
	y8wzbbpdHz9kxn3OXSabIwhPR12uggJKoYuDE525/WnYf+DvQHx/yvxw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40x08cn1pq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 01:53:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47CNNNnu000660;
	Tue, 13 Aug 2024 01:53:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn7vsdm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 01:53:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BGgO8no7A8vpdzUMGgoK2IX45NGJzkL2itEBkd4Gwa3B7huFfOK7JXmdo0KUjT/iRDfyIR1SYKgRqNrBrieqxwCFLDNX2Ws4chhfVRQ9kqNGjLEhWo12p4+kBir5jzLYk0dIigXvYX6mn4zuelM6H/J/dJmXk5UiB+i3vmEvZoqot5d2fUZUBjduX4ATT8Q7T2gyJzH/ilyVdhz+rkGXn5XDrnXUHN/0Bj82ppa94z01NQdgbsrITKQRPOTepdkLlMnRvpndI9EBKvqA1IzO/OodZ1WxmVw8v0mY8Jec+wiVsY0oY2PkQk8bg/w3ZI0UNjbZ/aSwBWSgb+EG7l3DJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ck6pb1o+rkJ4JJCPNmdPljUT3FgxrPbXCuEz5nWku7A=;
 b=Q0qvbAG+1WZX4LG6DR0+gQcjy38BQv2mta5yfCp88RUyEbGr8KKdAIUYydrjEzM90ydQal2ULM/aG4lMRKxW9sBwTnfgR6oDrvo4HlKWJipWnFNDC4lR7r0g+73E7to1xXStfEWZWMa/YLE87WsZBnite1V3fhYbhiPJaQo3U4fud6QFOYhDMVgj4P/4BVKdCx7hpGSnr1ZOmnE6gptZ5j2I8nozqyV/TB9sDzdxnKZHRnQpHBHvC2o2ac8FrA2wjKLE0+51na77VqWT9D1AVQkXnyhskB+JO4oV6ShaNfMCUVg2fZlS/i3WgBWdpaF4kPnDnsgxLFWGnKqT/8RHPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ck6pb1o+rkJ4JJCPNmdPljUT3FgxrPbXCuEz5nWku7A=;
 b=MPwPF5pgX9h6y9Bti9S8GqVun3WADkiCbnBp68NXdXZLJMNWm8muyOkOYIvtleP3q9IFPC4J9z+KuhkwYzXrPSsJoz+ATmclQ44+McZN4DwovZmJhesoJUrYqDwDW6ATedabNwfRfHmZ0Ou5VjF9IhPvJdqjIo1FuBF3HFkFRv8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CYYPR10MB7569.namprd10.prod.outlook.com (2603:10b6:930:bb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.8; Tue, 13 Aug
 2024 01:52:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7875.015; Tue, 13 Aug 2024
 01:52:57 +0000
To: Chaotian Jing <chaotian.jing@mediatek.com>
Cc: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <srv_heupstream@mediatek.com>,
        <stable@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: fix the return value of scsi_logical_block_count
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240807005907.12380-1-chaotian.jing@mediatek.com> (Chaotian
	Jing's message of "Wed, 7 Aug 2024 08:57:59 +0800")
Organization: Oracle Corporation
Message-ID: <yq1ttfpw5zs.fsf@ca-mkp.ca.oracle.com>
References: <20240807005907.12380-1-chaotian.jing@mediatek.com>
Date: Mon, 12 Aug 2024 21:52:52 -0400
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0067.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CYYPR10MB7569:EE_
X-MS-Office365-Filtering-Correlation-Id: 182500f2-62d8-453a-f3a8-08dcbb3aa79c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wwGHzY1g/mog5Dn4yt9lTXmxbxb6J4SJWtrQLCsnlFrl10Xlm6WFMyWyBSAj?=
 =?us-ascii?Q?aX0+ubATg+ciLxU8Uc9wh6CAqdKFPo9tH7dJvwvpwdgWvcem6mMiGNsB1tR1?=
 =?us-ascii?Q?BMTHLiHFzH9gO5YaqkzUFYT5dgnFdcNltGyU/ONIXKmW13/iVrlNsvgax1vy?=
 =?us-ascii?Q?EkX/vgleItCVam1R0HOJpmzZ1IqquuJsL5aYVMTpIa6P6unHHOwGWj19dXWC?=
 =?us-ascii?Q?yoG5zClM9U8NxafF622mrnrTqprMZbCDyieEiTFzQqzz36Qo+slVWqHzjR1O?=
 =?us-ascii?Q?8Cj1E63RBtdL1SVN+v+CO8j7xWpIRiRXFvp2YkpzD4KVoiNUf25x2YltwuXU?=
 =?us-ascii?Q?XC/8+ovC9HqlKenPHLAA85ekvFhL4BC4Y1C3IRVFv+1bs9PTYO+/INp70x1k?=
 =?us-ascii?Q?Eqo8jU6ba4uE+6mjhd3OZ6CwjdnYSaaec5pYfJ56eAhMEcqXRHxQ6FYP9SS+?=
 =?us-ascii?Q?UgVOyPmfaMqMT5PBbRk3aq7Pa14T0fZCFKC2PftFRSLaPb5NblTti26jDqUS?=
 =?us-ascii?Q?bQyaYtODvZgQ13jKFg+tpwArx81L7TB7DjXous7mDshlsLo34g7JOTkmuxgr?=
 =?us-ascii?Q?3uZlKCH6sHiCtlevBeReL27y6jhail4B3mNULrIgNIlc+F6S7Izc6piYr4M9?=
 =?us-ascii?Q?q1WMWW3CfQ/cQCo4v/MxumoOZisVsNyOrUYBGIqi+ztiibOw7OzCNo6hokAz?=
 =?us-ascii?Q?KVaXibVoTkF0xfoAxNWA6IRdzruIOG3nJvJ3pCwL+Z1zreCzbgpQz5SBVADa?=
 =?us-ascii?Q?azotMPWT+4jAbQ2gb641/8P8dyTDjUrFc1nYLQWhoJuFj2NsNtV5aTc/m04L?=
 =?us-ascii?Q?XvVW91Jjyx3uCdSCeNwhvMMQ4wqcFGM0bVH70SzlzCGURDOv9VCZnmqWyQih?=
 =?us-ascii?Q?w2O9rn0y9/2kRxkjUdYbM/unzU2SzRbkM9esrabKtC/Fs/GBthIBriug1lA0?=
 =?us-ascii?Q?lM8U2cgRIYUP3NesxQ8XGyI8Yb4w0JY0i8FuVFJ5hga1d+UmddHgZDtShKTN?=
 =?us-ascii?Q?nPqlHEdOueWyvcY0jtxMhEzivNTLyh40kravaPQjwiVsglmgXfg/W4HmzVQJ?=
 =?us-ascii?Q?UEMr4+l/wheTNisDSqW9STVuiyl9bA/PcJP0AIg4ll83eUfOm85rtC2DpvUP?=
 =?us-ascii?Q?p8+7DdvR5OzLyFIt1i8omgF0P5MbCbDCF54vimnErVhvpQ4Cce7fcAqAiiaB?=
 =?us-ascii?Q?hd+h6CJl56t0wGuVMsS+49u2nss77JbF85XK6H4UIVilhem2s+qrLhzpB7hO?=
 =?us-ascii?Q?9+Qc91jnf77r8s69+s3K+aGB6e99tH2G5NNfkYIyaBZkox6uu28d9fCPPDtp?=
 =?us-ascii?Q?xTHACVdVR6zlW4i881Y1dcOYiyN2fveTjE8irX7C+EPCdA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QhUMMcj1GwyTD97vlhzAm6K3/G/z4Ee3id4JoAgB+AQCvkHfg3Jgh2hC4muY?=
 =?us-ascii?Q?LAwUl/8J/UhAJZ6ZSCGSkIg3Kaa/1eYWb/hByeQ4L4qiRG37VOwsM2XShSGs?=
 =?us-ascii?Q?i7ziG2tLaaLarmSQk0OAEkmSJwyr7tAgiFoT/xQvoi7WOZXtkxbHjL82D0hR?=
 =?us-ascii?Q?5smVtcBO/xfLMj9U5smPPYlJnacS43VtCrIOwei2GqZO6k1etK6e+y9qSQpl?=
 =?us-ascii?Q?zN/f60s0mhzbXP4zm0v+K/xaAkh5EJCUKJ+LkE8pNmDNNDNMAdtgKvGU3KyE?=
 =?us-ascii?Q?vU8S7OtmHWMn5fAoSEFwpU76S223WUm/KkBUzgd2VjWtC+5h7iBWIcbz8cvw?=
 =?us-ascii?Q?700EAk8NU+Fa3wYt+WJEr9h456oc0XHryrGY88HQ8UnYh3x3w5fTVOh1MFoo?=
 =?us-ascii?Q?NC0SPCbRXz/kC+YMHIK6VOEJoQuOo0Ixh8CaRK5OhNJp7qu6eQJkwvUK/EDY?=
 =?us-ascii?Q?tcdYZ46A0eaPWEhCfZ5ZbGYuANm3fk4CPMvV4Z2zppF8hkKxrfvXsRSFofcK?=
 =?us-ascii?Q?PJow+VliBKIG1UEahU5nfVB3zNCkz996BwBJGQt0NAoE0MlnjJMozRnESA/t?=
 =?us-ascii?Q?BmLrRM7lD4Fb094NxVj1eFuPAsNMB23rqyexKAt9u2yMJSoUzXDy7dT+l5/C?=
 =?us-ascii?Q?whF6Ind+EqcdVaCSIGpgO2TQnEcdAnqgXTLwYBRSfpMpYCwCqKFY9B1ydV9X?=
 =?us-ascii?Q?gzEVOlTIsdXDb41Bsk6s7skFG2VoZ+v8+tI5fAfmSVBvf3FzD0Gpouxbxo49?=
 =?us-ascii?Q?Web+V2XXDC6duXje6wD42XfaCukXn401o3LD9Rr5R7Cv+u4YUohVI6lEiQrV?=
 =?us-ascii?Q?a7Q8kvNZqK9YHwzPdqMFtpttD84l/MDdGKgNSK04erZOotYFNingL4oMhVCT?=
 =?us-ascii?Q?Sy3Kvb6sEJOhs8cktWU9pDlBq98pzVjUOy0SKlTHTPOIVcX017nr0g/wvJco?=
 =?us-ascii?Q?92TaSyC5smbxprXtY/T1Pg1zBEw2D1jA7vNl0mcyf/0amg/0feTGWC1vsQ2T?=
 =?us-ascii?Q?rrQwIO+JW3wO+qeAVRQpwaEjHeFw4/Z820Aeoi7FIUdSSHFEw1K5Anyqt9Ok?=
 =?us-ascii?Q?8wuLtmSa5jaG08s/vpX3ZMARqSMJBBh4lmWGxf0Ei/AGhUxpyeK7daPb6/7H?=
 =?us-ascii?Q?nzmXGHrhaOh38stWtSOW7r4u+Y7DaH9GiAxeK2scge19MV/9M7EiWZcLHONB?=
 =?us-ascii?Q?WBm4IY/HqjocwY2LXjr4jK/3B5CT11xGqVgxo/nSVUeNuH7nRjPqRHPXDrQq?=
 =?us-ascii?Q?GdpXnu1DcDvOH5n7N7CgoZ8lHPf4TDr1s+4Id/W/HziNBdILLgmy2CH8P8xt?=
 =?us-ascii?Q?knWjMvnPq8ql52YLKzt3w+sO7v0S0zVzj6Z6fNX9KT71ImimYk+h+OyNk2/4?=
 =?us-ascii?Q?PNnwKOsCg8SAkyYy45YGXVhgxJm/2YTT7lIAZoK4ig19ICxnnXKN49xbPun9?=
 =?us-ascii?Q?Eiww/kkuIqRF0nYMuloKIXTPHKFsg2yGUOVv6/MmNPJm+aDToOpmkVA/o6hp?=
 =?us-ascii?Q?A0nDUfFAxBc8mOnP3KlLbt+eQ3EKH5lhjOBiMvZKj/Uq9esWu/BzwEL2DJxr?=
 =?us-ascii?Q?wGDlTJGMBICbxXo+vOEz/PFTtzeaIKwb25kHV0mF1nX7Fw3x9pqZyi0EHtBP?=
 =?us-ascii?Q?3A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SS2VxXWdq3EgrGXGGYhwcM7XcFdHVMXUURN51Tl9KamhXb73Us079bzygjmzm0n/Loqtr3XlX8jxsAH8ugVnn85Unu8dShjuRbhWVWpQPj75jCQmRksApDutyYmMsrgfqjNF6r+J3zJ9OCCIppc2bL4gJkEJ6ONUx5RF0qKlDSojPIgaL1wBxWeOkNwkNjUACKEURdNx66sb2PVuPatsOWiY6mVKZU1xWxcubKpdoA3Znc+bsLoDMzZoBM6RMPcgTXeO7x5szJBNjrTrxfo9vqg7oJH/s4axns/lPGlNljIrBIKMGuAwu653Po9UR0JZwo0hozfobvxUg7/vRJkC5V/rROvd4GYgZblqoSo++Wt+TZcBtExOTe4q4QYHq2u7wNMT20gLOoXnsVRUC86R9SbY1KGixU6Z5Hmi6Fbo+5xvrYTu3lP9hCCZx33uWQJgNrDKzaBylWwVYolUuUQo/yYaq2LjgE/6w2K1QDcsZsyKZYahpw8i4PNZHogbOzjaaolCEpa28pIjrLRQsw/Dvj+PtmU5IiAvO7oFrbMt6ytvzv0OZJ6rDpfQGgTxcwHzgk8E2ls0mXgvA2eCVV/rsWKd5LvQ4xuH2vwyacq5HLI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 182500f2-62d8-453a-f3a8-08dcbb3aa79c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 01:52:57.5098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X+8EMmK2AfeP0v5noyePK4wb1UxKC7mEOkcxCt+rd4IGrk/mgNCppPwy9FSBIGiRKVDxV69qtpEKHojosfEVX1gOBe82Cu93ahyKUMpPmwU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7569
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=793 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408130010
X-Proofpoint-ORIG-GUID: PVjiE6OfXQWv8gt6hdO1y43-FrFa9qR6
X-Proofpoint-GUID: PVjiE6OfXQWv8gt6hdO1y43-FrFa9qR6


Chaotian,

> @@ -236,7 +236,7 @@ static inline unsigned int scsi_logical_block_count(struct scsi_cmnd *scmd)
>  {
>  	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
>  
> -	return blk_rq_bytes(scsi_cmd_to_rq(scmd)) >> shift;
> +	return blk_rq_sectors(scsi_cmd_to_rq(scmd)) >> shift;
>  }

There's no point in shifting twice by converting to sectors first.
Please just remove the SECTOR_SHIFT subtraction.

-- 
Martin K. Petersen	Oracle Linux Engineering
