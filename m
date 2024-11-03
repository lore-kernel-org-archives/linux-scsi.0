Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F36238F97;
	Sun,  3 Nov 2024 00:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730594086; cv=fail; b=cy/U8Ynd83GougmdvVMnc7yNpW7ohu3MF+7K9YbIyp4OcWM3kjvsy5pJ3WQvv36Q6xFxN6qN0KcoFzGM9hLONvlsxw17l+vWcxgTR+JX8eG/x2MAkr3fingZMALrJCw1wT6P30FXWMnxCGHwBYIO9UokI7AjnshR09mKZX8Wqsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730594086; c=relaxed/simple;
	bh=guPPygL+0T8tgTB+uxjtILv8SmENMoe9yPEPjNf/mL4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=GTT9ygRzFxqvyaj30ObNJb/5HcT5lIU4If5jUnW4ztXJ7ct0Og5GJS6rdx7uKaFQOf3qo9R0dKpkdWRLwWB990sNFPfw58LavB0Q5gMseUlZvvuLjVQgRzyotvvEk3oR0FSmQWJIeHWkAeyIErZJzwgVQQE5bs0y3iIITbk1bKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=S4I2oA0n; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=i2SIo5C4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S4I2oA0n";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="i2SIo5C4"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A2Nsesk031802;
	Sun, 3 Nov 2024 00:34:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=O6w04n1Zu7SoRuJ5Dx
	pIovAdXc860TjqXDNsq2SiQV4=; b=S4I2oA0nQYdIglZingvQeOCynzktO2H0FD
	LGBD0LCcJ18JuFMNC4caGjINyQF0DzEzeu/lt7Hvw9KOaG6Uq3tsgmWI5RIBAKK0
	lqHK6UslW/A/QlNSScH64TfxyvS1u7lOKeax9vyPRWO/xk4YtoT3uFchS0ELN2M+
	Ql4sQzXwzpwgAhckDJPZoZv0TZl2MleDZc62nIV5QklKQWstD589lHsSDAX66516
	syftOcd7D+ZoElPCp6+5ZHeU31D6WJOxgFzEH3bcmjpsvrOD1fQL0KQYduh1h0+3
	pN5Fe/Q/J34y0437/Q8p6LgsOdHgV9Ko5hsfAa4hbgUbpn/n8snA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nagc0qav-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Nov 2024 00:34:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A2IcTlc036787;
	Sun, 3 Nov 2024 00:34:31 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2044.outbound.protection.outlook.com [104.47.55.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nah4bjxj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Nov 2024 00:34:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aUL0GvauEuvnb5I6b3xLOKGX8w4RJeMgmSvbqO81Natvs4U8PaOBONNMQNzk5eDFgILTpdSKPi/iXDsP9D9w8FI/4lytmkw0Ja63wYUkA5HLU7ubyA3ANznOz1hk9sT5PfFt81Ml/7+Ot5yiDXEOAmMKrHOra2DCScZMZaAPEaCBa8HOGg1sPpQ//HG7RRcA5Xz41X8JExy0I+YySSJT6d+AeO8wGymJCv7Ud9FwJ+NjqHlgmMtxqjjT8Sf3/6hdh0JfWNRRBBPxEinN9fldieKNsrhifjo77a81UxomDeNWuJV4pmdr01Sf9gzNqNYFm5O6udaTieJqIQ9NYDN0Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O6w04n1Zu7SoRuJ5DxpIovAdXc860TjqXDNsq2SiQV4=;
 b=tolgFfOE6AE0BFFslyZhxPnvIJIjypTUGysfIUp//zON5ta9L11pyOxev5Q9HHKn55XZZtYi/USbaCrN0rvDTf+ZN6cGL/Bptjyh81xXuQmwcg3pL3lDj+WMfy9nK03rJgOY+LxEydCyg13qsnmn+ui04glHTLZyAQGO5gaw8QHXvpt42cYbD/J5Jc5UKPkSAm7XLAjkt1hPiIyfc9BM+BO9jAO+TS/yjhWgq6dN0vKIJh74Bp52834+k64AMZZRaX/cjhm9dC5PHhJvNDw//qch4acuqQFMtH7yHbsVCPwwr+epnrm2rShL5tnKD4lXw5tT9r9hhuNL0tDmOj2B7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O6w04n1Zu7SoRuJ5DxpIovAdXc860TjqXDNsq2SiQV4=;
 b=i2SIo5C4HlTcJjSdG2GGgk6gzYO+BFUsDhOSLrWNR3BukX4CJ7FZ0wpT79kn0LCcwPky6i17PVzz8+lbsLGMP3r5i53+prMfIEcmZi+yzt4b9qXmjrxKSHH0rqIrNgrtXQb3eaYj12iHKBBi4dCFEXi8iZcrQNoDFEOn8u5evqw=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by CH3PR10MB7235.namprd10.prod.outlook.com (2603:10b6:610:124::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.29; Sun, 3 Nov
 2024 00:34:28 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%4]) with mapi id 15.20.8114.015; Sun, 3 Nov 2024
 00:34:28 +0000
To: Baolin Liu <liubaolin12138@163.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Baolin Liu
 <liubaolin@kylinos.cn>
Subject: Re: [PATCH v1 v1] target: fix incorrect function name in pr_err
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241030021800.234980-1-liubaolin12138@163.com> (Baolin Liu's
	message of "Wed, 30 Oct 2024 10:18:00 +0800")
Organization: Oracle Corporation
Message-ID: <yq18qu188am.fsf@ca-mkp.ca.oracle.com>
References: <20241030021800.234980-1-liubaolin12138@163.com>
Date: Sat, 02 Nov 2024 20:34:25 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0198.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::18) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|CH3PR10MB7235:EE_
X-MS-Office365-Filtering-Correlation-Id: c022faba-2996-4e43-ba27-08dcfb9f4698
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?c+CkFJm8ZyVNsiYKZNRc48jd5rT/HkZ6aRql4ROn7OdWqCzlSM24qhKvQSx4?=
 =?us-ascii?Q?ybC1HSsH1ZQIEzCMREPHfAbiBo0IuB6ia2ri77Ub65wCkUYp7mSCSZbj7LI1?=
 =?us-ascii?Q?ih9OE3nRfWNO1Ewuu/BIInOeU+RF8Gypxm7W4aX2u4NKVGGLS0EosuSSYrLP?=
 =?us-ascii?Q?drJEOD96KdFFOWmSsydc3ZEReE8+h2Tf420k7py17zfRaCpepDFHHmivS7DS?=
 =?us-ascii?Q?h3PG85peb21Jjng0W7UjlYKL0xwId/cUtgQrrRVagx+pyF87iYiKPoiqbHbt?=
 =?us-ascii?Q?XXg3o8JpPGMBeaQ7evBR9nEPTq5pSMy05XL+LY61MLiv+VqEggXsqE7Fs20k?=
 =?us-ascii?Q?6WlqtFZ0pzE3P/3Wu5c96Of5KJWbtpLoT6pX+1FWCc8xg9FEdnF04twOsYwk?=
 =?us-ascii?Q?kSDc+OA7LRLyDAlF07IDGTnAkrT0b5zZ6nYdXJ4YIDEGsHoP1qnuhzAn7cOB?=
 =?us-ascii?Q?7X4JLIqzZzyGphb3+1dt2xslask5gQkTNEh4A+RCCRSu5Vc6vWn8VTDyHS6r?=
 =?us-ascii?Q?pwX8lFMqxl4GHsXOYxHI6n7uhuxBoKOHyGcOURA77+jgk9UGxEolJd6g0BzP?=
 =?us-ascii?Q?Kule4BURKDal9n93C4PUuZVwI6qdhfv6Qcaq1kw7NCRLoKAva/kJK9kMTrct?=
 =?us-ascii?Q?++BlMwJ0TbGGY5pCkD9LiBVbMKtC7Zzoa2J+032HtReC6Z7EW6GNHxsOjMw9?=
 =?us-ascii?Q?kWuxEvFlzMqeZUQW8RnMHMD8TjrTb1iQIT56jMP2bcKH0T6/EevS4n6rp6o6?=
 =?us-ascii?Q?ESVGDN1jO5blOfadUxNw89B/L9D8ouzfwcUndOa/QsvFX+sdrk0Y+8eVwBMK?=
 =?us-ascii?Q?dh8y7c6LNohlq/y2VLRRvYI/8ZdE2NA9XDgc18Pz4n/Nc7/xsxPDdlQ30p0B?=
 =?us-ascii?Q?5cUBdkPsXwCYKdpfF1tsFe6f76KbyRtcLLAWJZoFl2+6wE5WLwfg4I67DXJ7?=
 =?us-ascii?Q?KN7D+qB6ffULPaRrOcbV8bcvq9geXrZ+pHTdVGE44mWGahHNq1/HZtAZaDk5?=
 =?us-ascii?Q?6ocqdl4jAc9n+qB59Yv5g9qQ8psPNUHpH1ziE/zYFG1Vx6Kq/yfslxm/hz8Q?=
 =?us-ascii?Q?wV5PFcgFAU8GGjvsyf59RoJvGYVXpxlRJ6DVNPo6vMNDOXAGyq6sPyJQrw6Y?=
 =?us-ascii?Q?ua+ymtPcrJHgVRkg8UKqEwivTx3DP7MV9TFfCLb6KEknxK6ZI+bXdyVmSP14?=
 =?us-ascii?Q?Ats09gHR9zuuqVHglnjNvnI6z7sDKrkfAhWpKHCBlPUYtcUbbA/vFG4lDdO/?=
 =?us-ascii?Q?Jxv87+TfVShQqeoHPivKnIWZbo2bXJCA/FWcWx5CUVKADjUO19BedGiq45dE?=
 =?us-ascii?Q?3DU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2VHRIo6hvaA+DR7xIxyMCtQJzrZimalTWUr5ix0tz5W1JQAqI6Gb1o/vIsUP?=
 =?us-ascii?Q?de+8as21KKJbj6CZHaMdsrudHLr/1CpuLRAtLVGlUVEcjlEP/xBLTrSzYARe?=
 =?us-ascii?Q?FJsylls38egGuPKDakZciT4eq/cPBcs9WS3CldNTY18HEy3sCFjcU8gJseWp?=
 =?us-ascii?Q?02PySCF5SMh4Nx+ECz4O2YrXnxtOf4Fo6FmA/PT8Pb0/AXA1BwmhCe4Sh1us?=
 =?us-ascii?Q?OUPuGDIPQPcLLGiF2uU5O+Jtnz4JboxZ7O+2lkYd+pD1Wf5zJEMvCQuJ7Lhs?=
 =?us-ascii?Q?UCqPqs7qtH0gt6OSnDGyitfKH33g9IZbtNfAuWGFtyl26jkFibBWJURGW2nQ?=
 =?us-ascii?Q?MleNAij4XaY0HZBKEsAIDQvKcYcOysfZpovKKQpsHsjIR6E0FgTTRaFzX91r?=
 =?us-ascii?Q?wWJt0sBkKGeg0ikCFz7Vh4bVV2lYG9bkhQpKhR4ly/H84MMcXXM0c69cTJat?=
 =?us-ascii?Q?5vEMwKOk1AzZreyYrGQPERc0pGcLkgXPEEImtzLmQ4Uot+zqnHle5gGGrwXb?=
 =?us-ascii?Q?SPpf4HxeFz1QxRkTakfU6Hagprl2K2Rq6vLz5+MTPtCnkl8nvCeKQsfzvvd5?=
 =?us-ascii?Q?953kcc+s2KzwWMBwrSbwaA4eMnJlUQmYKd02yJloQKEBiuE4Ck6j4yfoP8mv?=
 =?us-ascii?Q?EfKywmIYBdG36LCYzLos0pGXlOuGYF3wtN+y/VcyV9xFs6yXjOSSytl0TRdh?=
 =?us-ascii?Q?h8+93ai4J4D4DWau8RbAkR2BCV0oYcq2eTRnFKAsC3YlfuMHFSROm9oNFGJB?=
 =?us-ascii?Q?1XWNCiUkPNPM755al9P4XJhNJ2na84s+5HPulkJ4F0XYtrTjmfZaSM6XBNn9?=
 =?us-ascii?Q?edp5VbtBETwt9dUM7dGGHcjUVxP0VBlhN2fKl8iPU4sl+mpehbVbFNcDySu1?=
 =?us-ascii?Q?etq7c0PQ9SeLmjQeScu/7qXcKlUMHxl+4g/XcyHk2hY6a6Zkb+cdVGSY7FZr?=
 =?us-ascii?Q?lA6S2W/ppcHyfwetX/WQkLRxQUGPzHlfl4efiIeizDQX+j/nayXwIQC+ozyK?=
 =?us-ascii?Q?p5AK8EIVJaWsxvIR45N2XSWpiDhYuFeiku+g+Rjg2SrE9Qg28WwzfoAhr/DD?=
 =?us-ascii?Q?BjAQpIDqowF/jwWceFsfBAkjFdpw917lOY8NYdFciU91TWl2PkxvZ+3ApSag?=
 =?us-ascii?Q?3AYkAFxPxT+OWufp144dyeiA/yXgyGIBBcdObu0dIUP0hHljzz9U6BH+w3PT?=
 =?us-ascii?Q?+cyHRV1/wpIw/8lABGKvdO8RhYPTjNfcGOlf95A5jLcVJMmA+WTBYKY6hJw0?=
 =?us-ascii?Q?FqRRVkTSkHfRY1isRScgKKtOaNawRVNdaTMwuke+uMFjK/o0Q98ao79g9iOU?=
 =?us-ascii?Q?ZF6/8xVIb/NNx9fVN4ak1F1Hz1u3kYwSunCQWdDATcSc9K95BT01/9/wc/Hu?=
 =?us-ascii?Q?r3l4MtykbqbbAAQFitp5rf4CM5FG3X6P9YlkK1huB3hrZDHT/Yq0I3G6pad7?=
 =?us-ascii?Q?iCR0UpAIO79TLgr4A3k/XMZLBGyStHc8hFtXmc8UCATfm60dJFOO7tq5aLQT?=
 =?us-ascii?Q?ngGGdzmUFioDuFHXP7S99MSQRAA8qSvnVNu3iJz5SayQNBm9vGLD3xTgEMAM?=
 =?us-ascii?Q?QNx6Zsnr8km/XGgMtwm296RNND2tbWqZ3DWbFq5DbKdRzSw8nBtvIfQ5yLQd?=
 =?us-ascii?Q?0A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3HJZl9gIdT0d2SZlXMO9wuL2E4syeFEzJVmKdUI+cCCQbOisbBp2iLSROQZBU4zF2Alu0bq+GxWgQ2RtRfRIU8mbKym/9YXYfDYyKU0M4AEO15dQ7w/rG0gGVhoDD49j/gm+x5c1csKNyXvO4QIaSx4vD5glK0xM85GkRh/VpoaF/N0l2bFrKu4t/C/fAG1JJO3wzEdyzUOSmhE+8hp0e2NVP+pER7KV2oBgJVJVWhx/StfskH7cWATD22jKGJUJc5Y+XrZDr7T1EqyZRC9i3dRT9/c1i7KQJBT8Bbaqhi40Sdqy1NRT0Q43I9NNdo62i+YdCyspyDpQC0BN8GjLnOf2cTqUz0tW9yhi+Yf963vWuA+6SKCctzoq7jKMc/5BFrRjprreV/9Iws1CFe53+XjQqrOLBhIakxIVKh5ZnuhfvUyKOOko4Lu/g9arUSHASf5k4Gqv4s0k0glhpize/C4diso+OXbNB40xB7zSQYRNY2DS3Z9GSjmt/7UcPrAzizEyaj8KnUU4yz4M/Pzj1Uqn6zMkcP0cppX9KAGxMKfCEUyCXBNy+XwEdrW7XqYbk/x+Mk1L7XpS9MbRiS0pMICF2nynBt498aP7VubAtMA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c022faba-2996-4e43-ba27-08dcfb9f4698
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2024 00:34:28.4102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kJLjLKih+1IgRM5Nh7o7IZd2v6gZztXeVt/bbSDxXJeGfep35xhxieepgiaLSDCxv7/J/XMjYP7lIit7S+DymXPiSdT6kO0uWfMG9/Eyt7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7235
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-02_23,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=874
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411030003
X-Proofpoint-ORIG-GUID: F18fm1DMlrP4jjmgliBxHQKDilxjrMt1
X-Proofpoint-GUID: F18fm1DMlrP4jjmgliBxHQKDilxjrMt1


Baolin,

> in pr_err(),bdev_open_by_path() should be renamed to
> bdev_file_open_by_path()

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
