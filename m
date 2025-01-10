Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360F018C03A;
	Fri, 10 Jan 2025 21:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736545081; cv=fail; b=CY5MNLPHeLrdxwI+p/W/z7pA5MranNqmKRaFnzICIXSH1bOCAKOBTeHZ4e44+bvJRXFWBTHdAohOeRHMuDPz1mkH5JjhO+XL9DnM+7OS+Gy1XV2O+pmJaLQwn1K7oClTQI2HshEi1nRYROsMPV6s1A53qI3FLjIGWntP8f0tyBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736545081; c=relaxed/simple;
	bh=yuuCm6eUAwbFfDbdvldX4D53xd4AyvxdSSH3BJ4lT4w=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=JzVP/JVtGYlTtDMR67Yn8zJ90PlMSKutv/mAFRGW7QeKc/w8XyP/Lg+t+N8+mvjhhmaovDhppPtNuEDOGbT4eTzOdt0l9UEQ5JmVqmwxHib+kouV+Zf/CfgGSbB+l6R5i4rNgm9H8ywsZEru7zcc70CsKLYz8hvemrKnLVrpytY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HclEvzIp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=c0sFob+L; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HclEvzIp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="c0sFob+L"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBq4r014721;
	Fri, 10 Jan 2025 21:37:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=ANHOsloni14F6T3efj
	w/oA4Chfm+dWnHYSng/t5DK1E=; b=HclEvzIpW+6uIYjKZQnmQ5dphaHjQQ1dWF
	P9S07eSw7rFp0zxDZ+pgZkE5zXTu5mcdh1axC/xEpSNOgJmn6ynLrqbssBW6dyXw
	+qoiF8hRFpti9qAK1B08fALDKHBd2vWySSYaLWf8dd4nzN3d0lDq3QVV23J6r59d
	Va56Q8MX7gxt4pODlpjPKmZNnDJMvwuc+6REZQLU5dtqzkIG1LlKnCrOADFt7vfg
	jPlB9FWaIu9eVOGuVYoaSBh27WQZRYxHprN90W2wFZhq//iAIFo0VjtWg9Sfw/SS
	g9yzJ52Ma4Q0xFV2NJT8zXN3yxmgvu/gwhRMRWKrYkUsv9xvEzpg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442b8ukaym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:37:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AJOFFi004858;
	Fri, 10 Jan 2025 21:37:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xuecxaue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:37:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IFhaflYWngR2Av/gD+nV29z5Jfw4Vo/lG9Zb7nY706RpVVwI2TOx/tqg8wB4+JVJylqhkaxWqnd7FzKpNJyjjqslLLTvvOP5lo1c+r9Soi7F6Jh3F2I+Cg51BgqaGNmS/CZfHUx9UkHwjP+jBA35+R1uwDGuCJAgFCf/ziq77KWXFTXbU7yS7eaDIQ2EneF/Z+EEATpD+/hgQNVDuuOwAvXaBLqQnyhthgx+2mwFhDRFZrMEX20oN3iDlnpfWYs+bFORt9yfyEbLji6ffasCsQULH6Id/b34LoD9iAEMFAtAIiE/5PHgzZoeRWDvMKdVrAV25HaeF8a6afeOCxNWVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ANHOsloni14F6T3efjw/oA4Chfm+dWnHYSng/t5DK1E=;
 b=vw1LR+HiJrLR++EvEgnRxEjGOdJM7pfHXe0KGGOHUXsmJo3Lkra9GfFrfXLEDdBrrsFyuRQyRKSrJJ9AdQHH9m8Ql3jkzVCfB8Msn3GpUIQGsk+Ocm2ETVWQCezPk9zo1/CSKep5gLpVcX08MKZLGOSM+gESF0Z0RjWjUfxbbbhdCqXVxq1viFZrwuaxG8AtRUNkhAjROUppNxNL+sOxq44Kg1Tmvw9sQivJHPoMxSiDVyPFzKBHiEc3gkXp8hnXe3LQ/poo5+JLJpkThUmOCOvNIUUNee6TyHpQfn2si7Uh19UwVVOJZEgpkcbEk0FyAkPXkpEK/5STe1RYd12ySg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANHOsloni14F6T3efjw/oA4Chfm+dWnHYSng/t5DK1E=;
 b=c0sFob+LCIUEtq+GB8y0bXrwfXSx/w8K5WOHcn8qIOSNjLsL+SS4fQR/ltB/7REaZilnNVYqSLEnTLdP+dV5T7udrIawWK78APaTDK7tWh0HrZLf81nm+Qnamr/mr3mEA+SMTg4asYd1BCEvxP+GamvRc44TKijcATcQ15qcekA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO1PR10MB4707.namprd10.prod.outlook.com (2603:10b6:303:92::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.13; Fri, 10 Jan
 2025 21:37:26 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8335.012; Fri, 10 Jan 2025
 21:37:25 +0000
To: Daniel Wagner <wagi@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Costa Shulyupin <costa.shul@redhat.com>,
        Juri Lelli
 <juri.lelli@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Waiman Long <llong@redhat.com>, Ming Lei <ming.lei@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, storagedev@microchip.com,
        virtualization@lists.linux.dev, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v5 4/9] scsi: use block layer helpers to calculate num
 of queues
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250110-isolcpus-io-queues-v5-4-0e4f118680b0@kernel.org>
	(Daniel Wagner's message of "Fri, 10 Jan 2025 17:26:42 +0100")
Organization: Oracle Corporation
Message-ID: <yq15xmm73lg.fsf@ca-mkp.ca.oracle.com>
References: <20250110-isolcpus-io-queues-v5-0-0e4f118680b0@kernel.org>
	<20250110-isolcpus-io-queues-v5-4-0e4f118680b0@kernel.org>
Date: Fri, 10 Jan 2025 16:37:24 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0015.namprd19.prod.outlook.com
 (2603:10b6:208:178::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO1PR10MB4707:EE_
X-MS-Office365-Filtering-Correlation-Id: ed0f4294-0f7c-4cf8-e748-08dd31bef979
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v8mqykKxZ8GJYEJ2Bd84yJsddilRwB0E6veGT5D4Sd98UZmqx22KNTKYcsOP?=
 =?us-ascii?Q?q97REUol7NZQmgAWRslbQQzJAveaN+BT8hAn9MVxiJV7bFWc/vh1CHIxyjE4?=
 =?us-ascii?Q?ZcXkoaUpN7jFLaSZLMoOtg5AJu8ZQH2FCoM9aLexwzQ15gdTC3tQZr+OOaE7?=
 =?us-ascii?Q?88ho41Ubbj4Bn1szupIZ/vdiWvjkJvWAZyS0/FVzVdalhL6ZL7//w3Cxp3wo?=
 =?us-ascii?Q?bO8qYmcMZCFUvaN7+laOfKQsKtTLFBZmxRaMLk5E18JTdLb0y6h7errRWZQF?=
 =?us-ascii?Q?AJS975Dl/xzU5thSmrnQHrZy5L9Xpz2WBNVnQmfQAgPGh/5kENAEA1f45XJh?=
 =?us-ascii?Q?1ypEIjQtIIpudb3QnbLJ70wl8o3O241GBx+x3xRWNqdMU4vsPoVsTnnzAVQT?=
 =?us-ascii?Q?+7jZrLhhu9Hs0Uktf0RwKC5MfJuG3U9s1IKHPWYc58y7fiE6YtU6gY6xF2Qx?=
 =?us-ascii?Q?bcE26ivF9bslkoZT7z1i3Q/V/5adsVS+l6KK0MF26+jqdtaXnkQMo2XcpGAv?=
 =?us-ascii?Q?JvpALkQkqhePu5MZh4b8GDUJNz6LfakPDQZflitgHPDh9bSBzethI+gS20Tl?=
 =?us-ascii?Q?YwSPE22p6LfjaIxc+WgNM5ZHsNmzl39383YtjLzSMlLVJli94G+Ai2y4erLT?=
 =?us-ascii?Q?lT8LrUeYxffq9pGscYnW3Ge/ZJDNC9BwU7aGGYoc3fMgGf4YwxZwy8hubj8u?=
 =?us-ascii?Q?4JvrttuFZf48/gnDwUJ3AnzN+SgC5OPd3s9PS6op4Ut9zgEcCQt2HdHqdDxO?=
 =?us-ascii?Q?qUwDn1csOmCtJbdRF7gY0V+ZKd8VjKKQUQLEmLi277kcW4ARtjwlR6sRBO/R?=
 =?us-ascii?Q?GrdwIOCP/D/mUgSNh1wrCcOnTXVXIA4Ma9qcFy3VDsaadzhnR+VUReQDNCyQ?=
 =?us-ascii?Q?hDei6icT0pCl/hS9vOwChoMhGcgYaqm/Ov7RIBVyJQ4Ie1erIIDlOJpYUBW7?=
 =?us-ascii?Q?xYkbAa82sN5UwtPCG3Zy3PU7n8i2QaCyhHfpYsUaJ9bkbuMmpmC6MlON1Me1?=
 =?us-ascii?Q?iGFg4/LGogb1yFNIVolyDvLWwlUrwGFEsJoh/BqbFTv8BTU5Xz+cq+UMsSTq?=
 =?us-ascii?Q?848ZtQzswOKQDRY25CIBj0yFyXnDtcR291L/6P6mr0oAnb3anwcOCzCXaoGb?=
 =?us-ascii?Q?XkaBqSqPtqueLzm3czhOKDscoC5Wq6NkXvlaYqoO8m+cdA7wf2I9r1Lpaoc9?=
 =?us-ascii?Q?CtzAcNnNk9D38ipd4pB4XOCx9RvtIK3EfCBiDSEaKUsB9NgXaR2oGbjtT6JJ?=
 =?us-ascii?Q?05b0KOAfR1qxma8irbq9Yk3iA+PM74rk1L9YsvocuVj+Bx6upAgOHu63z2Qr?=
 =?us-ascii?Q?MJaIpRkyVCjQOt8pWo4wu3wTyarmV0JfWWHcYk5k43ua07FBjSje8RpTNJqH?=
 =?us-ascii?Q?LFOMtVakAYUoG+elQ8qA1NiDdwsa?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R5JXdw7oPN9LnRMxvAIqsXwxx4XkvnrnUem4OiGt3keCkmkIKJCBdelp/VuG?=
 =?us-ascii?Q?qT1oqv0mwzXmlYOsY3VWRMp7xHD4Yp3p8gr2tz/+hAotpklq9mSBQ16Dpl2T?=
 =?us-ascii?Q?Bkc+ZjfcW7+1WYVPZSAEBemCOw2d1xNJ2ZwXI4NGPme9ONK4anSThEG+L5u3?=
 =?us-ascii?Q?uKCpjr8v1nR5EZHM1fnR0q73FCEwu7J2LR0IQUDD7YQHmqrL3iBe06ZUZMMn?=
 =?us-ascii?Q?G5ysMAqq+9CZlsnqGAf/f1QHuajCSUrXgRG0PJpHMWHnfu0/RICYdHMya7l7?=
 =?us-ascii?Q?Bh0TOvr+pN78EWlSOfv5owm3P2XIBnvAZ13aGksA8dGdM4+fwtXHsS5ZrIWg?=
 =?us-ascii?Q?Al34AIAH7a0T7A/0HRhhmt4jgjyvpD22Ct11gmkMn5PvVLWNCE+rRJ09qc9C?=
 =?us-ascii?Q?NRdbX02tImANrmj4NqZGpxIAo1tFziS5rFaZMgE3QDP9LpWupH9MyX+ZTZyq?=
 =?us-ascii?Q?at3vYu07jeX4TU3NisQqCVvFOmVQ4yRycrnEN2Va2WlhpmS8hj1Z6sLs26um?=
 =?us-ascii?Q?WjC/Z08oJkCSEVWTPct4Jb3ARzHVcy1ob/mfBfMV09/JLowgiKSGY9DwOhcF?=
 =?us-ascii?Q?ZhV5fpH9uCPqcL8/zv0FW6eWw/55+crP/K+i8aEZFYnNYvvaD2QM3kQjyIL8?=
 =?us-ascii?Q?7nw58nvkVgOf0yB77DRmEyzyXMNJINJ3uUjSjwDVj4fYbxwD6pQcXxXBXRCV?=
 =?us-ascii?Q?9mozZehJlQi1/vdRPYNaFYYOn3oBpm+rPaOINpxF0tunlzr+NxWUmb30IriO?=
 =?us-ascii?Q?5GSu1M9NZu3dTTa1jIEnVxX7in14hqQQbIYF8rEEMOWxG7KIUOokuD0Z4nYx?=
 =?us-ascii?Q?0g90kboGmdEGf7sX/DQUC1nJ4ZrA6iCi879sGO3SlCyau7/F+dB3P0N4V4XK?=
 =?us-ascii?Q?d8+nqmU51Kb6r60miRw5g3+SxaF+rWP/qJZl3KnIG4N/wKiplzMMPzHoLJYU?=
 =?us-ascii?Q?AtYJVw1nKOWkLAAG0qETSV5XV4XuCtOCPO47bIqVYSKHYxVO6xB+Iup7aGS6?=
 =?us-ascii?Q?dpsAUHUC5h0LRNRHGotNbC6eGupy8un3rXDBNqpOFi4WXtEbALbpH0E3dg4U?=
 =?us-ascii?Q?rHj167vYXaxnyIrpfD3lS3S8CWA+N/2Zq3kO7lEI5vbHmTnIAjOGws8cJacJ?=
 =?us-ascii?Q?wHomSKOoKuf/cj1z9VNjNckBehWQzgo3gKbv6SYZPR3gC9RQ2HqDOYfjZ60F?=
 =?us-ascii?Q?gkl4+B5NDj8pEmQ5SLIIVrW9JlCjubAmfwNp/gyUFpBSAO/uuOfU03/LT8U2?=
 =?us-ascii?Q?wPH5hS7HWq/lm/M2WBJpldZmu8eMGBfLSqs4Ra6ZyogEGrEK01B+1RPTgb6w?=
 =?us-ascii?Q?JoW5aC0FH18XUn8QZwlQxyumNAJ3yG9sFJaeBnL08/b81tEDXwsVr80xD18a?=
 =?us-ascii?Q?UWPA8tze0cY9OG4qOUndknGwp3PBbzgPhhnZmDPnU1kGDZ49PSJX4FNtaXW5?=
 =?us-ascii?Q?hXaQcvHkFzGMKkzgwHpnhEiJ0fy4cggMfBhxk4kIODpt1wNGeBdi+irGLZA9?=
 =?us-ascii?Q?R5mqnGkCCxQEbWTafRuJPGCSB7YSqVVrXdRLYEw9Jsp9Fzy7wUFOGAuwqor4?=
 =?us-ascii?Q?wr5/ZmjAOEUWI8avjJ0fUok1sre5dSiOJGscjJ11f055Lmm+MJbe1EN1R6ta?=
 =?us-ascii?Q?5g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WUCVwmx85A0eh/TpFw+SUqjjQ4pbyjaKlaUNm428rk7F/eWhyIygNqw6vT8zKs94/EOm8yuOCqBKd3u18ORbCVmg/MMphQzYxoVcyARBO4ssikB5TxnL7IGUPsD9vDKlZVwhWS7Wq8DXe8hAK0BqFakb/ACsreZsJSJZ4116cKYrfV8aNyzlyrkckjxiD35FU6Q6vIn6iyn3KVUM8ua/UwJM+1H4of/yrEtqii9NTIt+sMlsPDo/ZUSZc0ZryZCPX0ELEg4M0WVLSbY/Jc7mZv/NYXMz1J9JgFA1S4CpPCGMdqKFBSUqrGDy20S2cRsbZFUIUGAibOjfG4E9GNEQ8cMFsIlnSUVjKyyPsTAguQ0MliZCG48FXnwb4vg1LGX1B4JjjMrmnBHUHZJCc9gfBW5+yCWOqNEf76+8yz82s89dCVxoErXM2SjxUlrWY9GK5VcgyeWQoQ4gg6/U+P6zxWus38WSNEsDCCDv2lUTQWezEWF3icFW9SEf1sEI8YSDtCKmL/4xsZ2WPkHK9LCmY994UnP1LikcOdDtxbygDisGAYcxcIVamIf+kqqFP8noXrDeHotmr3LT8m/CJx/lMj7HtHap0FizhnW0DGmVexo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed0f4294-0f7c-4cf8-e748-08dd31bef979
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 21:37:25.6985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VK2+6jWY0e9McEAi6cAFzH9Ifqwi1HhsoUTPIm5IHJutzn3t9hV7d7UPGSYTyZjkbE5hsVdLdTgLCTilRSVpec3v04b3DWRdbHwAOaj5AxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4707
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxlogscore=984 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100167
X-Proofpoint-ORIG-GUID: rWc5bVKOkjYEYIZoXaCksW3FwZfHGUEh
X-Proofpoint-GUID: rWc5bVKOkjYEYIZoXaCksW3FwZfHGUEh


Daniel,

> Multiqueue devices should only allocate queues for the housekeeping CPUs
> when isolcpus=managed_irq is set. This avoids that the isolated CPUs get
> disturbed with OS workload.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
