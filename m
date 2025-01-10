Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A7520A5E4
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jan 2025 22:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736548738; cv=fail; b=ozASmnyycpqicnpTtzyDiUGZNJd9EY4kqOUY6nsd3R9Vn+jhP3GyXH7q2YDac9K4qXdqqL/CxbW4AYm02kWkbJD30bprO8xfJX9/mGmDjY337PkMSLaS2K6mB1Y7iV/wD6MVsvW/vJWhIPGAl5iPva8abdMQGwSLXWCMBoQjewQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736548738; c=relaxed/simple;
	bh=wlHM+I+voTfJ0xNxidHz3VuOkVnToTFaQ+YhLR/TL5Y=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=iaMEB7bTC/l5dItkr2KgGcb3FUgrn7wWknvMliQJNhgLpsW2ULBSV9CG2TWcWkFxk29sUUAUinRmqAVQJrRjHk2jIFCbhNjvH5aC/v2RxgcApgKM+EYqNNR4bTvlh88K5R1FY9/g2tvFqf2ZQG6pJeriDqQhj6tUyPtohG3BMsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I7tOUrHy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wTgVqHt0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I7tOUrHy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wTgVqHt0"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBppd022229;
	Fri, 10 Jan 2025 22:38:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=rcPsN4KCIrh5gUjsqY
	yuRgmF4hI/haToiLo9UlrIHSs=; b=I7tOUrHy0piD8FczoJcQwWxf9PGBhn23WR
	BLTTw56a+MBYx8mrY8BgUrlT6B4VU21dkqPIsjR3D7tlsJ1W4vD28oIkTBvF4W1m
	4Iw1wHUXyAhHIuTETk+43QPvws52pjzlFoDA+u3VOvJLOFCHHxWs62GqkeXtPmQu
	taI0CN4/ZztmHh2wEdciEEt+784+czNq+E4DFPDqjzx0lEP8HhKM2Eigs3MA/jNJ
	QU2xKpfRh8M1i7d9wVwfvBtwhzFbzfslPoDBVlj165jywYSm1tM4VpwMctqFHFSh
	GDqtugAfeVBzOMoT/flC63w5LQ2MSiaPe0tmdQCIz0/OPTSGBdvA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xudcc452-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 22:38:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AKNtM6027475;
	Fri, 10 Jan 2025 22:38:51 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xued80d2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 22:38:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rMUKexwKXmjzOQa6jpr7gWC+vKnY+E8b0nwcBaNEwxsfmwvm3iP6JWdQXSs4c6xJfXf0Y2Z+pN17Jo7w2RkSM4jCGC4IkFWMYvQOUzBfaDYFlNIsQ0u+fhjOP/b9jHr5CoGLbHus23ERWmSmMaha3231uoD9TYH9pthk0/MCTMWaA/RWVdb7zWpWHeKdnUDWh8h5hKCykedf5mkGA84qMbccHNr3XwfYT/xQVNwLApddOkmfNndRGVv7bGIDfTX9nwfoP04TE32Haze1S4hzWQe+oMyaCLgPviJDRXLY8TjZ0H49So3J0hB3WgUY5dX3w6nbK7z1/DsIVLbW912LuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rcPsN4KCIrh5gUjsqYyuRgmF4hI/haToiLo9UlrIHSs=;
 b=xPwmP7b4zXAXBbscwX+NBS9qoKnRBZCorooWqqm4aFmkP+0scrmB5hbal6owtA7lvr9ZtUJmrsDMpAQM/SJHP2pHUaWda0q/jM7jR7wd8e8LEDiV+WBGFXfnWCMaqUAqm8vogrFWTguzN5KziyA4+D/ad6kpkxyNYfJ9y+TJAoXOrECQgeyUkCOzcnmoDbXrtzuo6PkYsDvkTqw6aDRWyeFaOglXIAyc/VGJjPtjVuKxtYX/mLSfaBNYREnxthyjvJruEvXpzaNGaCS3GpAJnndZbueA+uYaEIq17U3XGkuTD0RBZS2OVIPrlicPIOFIfp7Q26gydelERkR0hJTDEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcPsN4KCIrh5gUjsqYyuRgmF4hI/haToiLo9UlrIHSs=;
 b=wTgVqHt0UdI/ptxrRtdokJwKOFZ2HAaeUp9ZBvVmNCkjYWx+qINNr7lgNz18OQQYmdlN8LgbUq7S9f5cfLi2UL33MYRMA2Ro3y5uKphzxGis8oFB51iIkdSLuPuLdsBx2zJNJEkXICWxiGBTlzWnf+Y+GZoJ+3M5V2cbYRW7jds=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY8PR10MB6443.namprd10.prod.outlook.com (2603:10b6:930:61::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Fri, 10 Jan
 2025 22:38:49 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8335.012; Fri, 10 Jan 2025
 22:38:49 +0000
To: Xiaosen He <quic_xiaosenh@quicinc.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, vvvvvv@google.com,
        quic_jianzhou@quicinc.com, quic_cang@quicinc.com
Subject: Re: [PATCH v3] scsi: use unsigned int variables to parse partition
 table
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241115030303.2473414-1-quic_xiaosenh@quicinc.com> (Xiaosen
	He's message of "Thu, 14 Nov 2024 19:03:03 -0800")
Organization: Oracle Corporation
Message-ID: <yq1v7um47qo.fsf@ca-mkp.ca.oracle.com>
References: <20241115030303.2473414-1-quic_xiaosenh@quicinc.com>
Date: Fri, 10 Jan 2025 17:38:47 -0500
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0049.namprd03.prod.outlook.com
 (2603:10b6:208:32d::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY8PR10MB6443:EE_
X-MS-Office365-Filtering-Correlation-Id: acf40d41-e914-4ea4-62d3-08dd31c78cde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AEnJuZjnlWPS1Na+w2mFGrCsHW5hmbSewF87z8zJ4HzQE8KuzpUP+4AmNihD?=
 =?us-ascii?Q?OvjIQRNVJ3rOA2UDhz08xEhDBCUA/ms8T11eHanmVtKDeNv2ovF4lZxDLOrl?=
 =?us-ascii?Q?NEGLs5hIUVkETbMAaDsDf2OAa/Bh15cg5QrTK5M3dwpBMtrLBtJ05Znfk0sZ?=
 =?us-ascii?Q?IIbQhNas+rc+BJEYAGlOLIYQ2pkh5vmKSWMGBqPQAO9kLm/GyjV8ZDf2Dqz5?=
 =?us-ascii?Q?nVtsjvUBXGbQpPI6zaDNJ/AactCHuN8E4ykPQcaiYeBrmyVfa0t7GGYFSyx1?=
 =?us-ascii?Q?8W5a0yipA/rGIlfTeNAm/QpFAQD3y4oiPdJ9dlgOB2Mzydwp1GuApoeB8qEu?=
 =?us-ascii?Q?0i3JL5xScgo48la8yy9pRKmgZcY/4vqQCpYvGfWtj7fno5OG2sEa1Uv2UTL6?=
 =?us-ascii?Q?BvogAI41Ps2mqwCKH7iPsibS9VOM4XZRWocj+a5r2aUArJ/aXN1t46XgeJKW?=
 =?us-ascii?Q?RXsM7m92oyWVT++cO0I2cjzO1Sa8b1cNVYVzIRHk+6DYxltGI6aZFD9kHrz+?=
 =?us-ascii?Q?5ocPPsJryfNIgFv+In9A9+z+1HnGHqQDgDErhZ8sM33ZORU95XBy8Cr7QRvY?=
 =?us-ascii?Q?lEDOBSXQF9cIP5Et+U/y8/kKyUoGNv2Q08otxe5/NaQKk8k/JjnHRBRp2+YD?=
 =?us-ascii?Q?NLHDgX8JUuEb75jJGGbV3HKN6itM3QHaBr4wFRdlpkbvgeAbjo0fQormS3kv?=
 =?us-ascii?Q?mtFScbeVoSEfG0oWB/DsiJX9u14dmMGyxD7BThqjInr0JtL0lk6ETjsAXdQJ?=
 =?us-ascii?Q?fFHw8J8eVAIXBZmxnbcqBYed0h7akdkhZxfsyzSp/QJWUaCYSHtS/Oij99KT?=
 =?us-ascii?Q?k7vuBzHDvcFzVL/FYYYD2l4aSmwhEbi45UNYT/iRqfsvnpeHtmmN6m45LZ/c?=
 =?us-ascii?Q?bvhVRDohPfBBfTLuqV2z3ThrpPhcop4AwooZpUb70eI8ccKOThJU4QYPNUrJ?=
 =?us-ascii?Q?LDsyQaycWxYdBTzi6FCZ2ASYO/NCK5nC383skFHaGkYRLeJ+Nvj19zhLIGpr?=
 =?us-ascii?Q?IseFkiSIwQx2NXtMiQ8VFWkySbVvw8MaJ4ing00p6Tgs34GUGFRlbHhlHXCO?=
 =?us-ascii?Q?IB+/At9f+U3qdRUfZmoVGqKRWmGYuHvRYdsu7+vOMM74NqZm7Jloucul4Gb+?=
 =?us-ascii?Q?8sqGi3KHSYJLhnBYlNQN1u3KzxsxQ8BI+SV91JA/p2JlBE8OqAm47VKmZz+w?=
 =?us-ascii?Q?SwayEFwvPQmkuQnEFrw/2n7MSg/ty5SUfQwn+zcAoqiTPxJCG5cct6QTG4n3?=
 =?us-ascii?Q?Tm/eeNeSruq0EuKWIfG+Gh7kH4hfjeuNxugofkiPruWvGJC6WV8vOve3Fa6o?=
 =?us-ascii?Q?I+4zxW4FJjinBJAQZDGEWavCXEA9R+wRQK4uyWyB+G6UU+eLkgMxWrQU51oL?=
 =?us-ascii?Q?dOlc+locVAlID+Ft3eiXq/jXO2X4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s7GD4EfR3ixqVMC8yPgnTFcAr7DeQE5I45Z8fpD/4zyqEzdK+1ZS5NFCpl7g?=
 =?us-ascii?Q?/2UMJfaN7BX1Eh82Sa4QlETJXDyyHlz5YG4Fr8h7R6i6XKEyoLQIzkzY6WQM?=
 =?us-ascii?Q?fZiP/9R6S1UpNDTWseHgnxERjwyW1MCGpBjMVcQLXS3na7+9abRItwojM27z?=
 =?us-ascii?Q?7CUMHew9iYibV1rFxY6AP2o2Ge6aa+lc8CB3bzkPQzgm6YWpeAwHsl+WxfH9?=
 =?us-ascii?Q?4rTqFIwiFnryYlojjPb1M3Y8A5Zyn8vc5RCkGdUvOJBdPFKV/IonXVLF+axV?=
 =?us-ascii?Q?eFpQc1AjzhnK2xqu78CmIasAVJ4gsFBR+WRAM73vgtMBchff+xSM1sz+hK6Y?=
 =?us-ascii?Q?gUEL/Jj1SDEODa5AS5Q3XMDecgwua7wcv+gsuqZmk02GXHXZiv0f5s6PuSDH?=
 =?us-ascii?Q?rfeeCEidLdRBkQbToeCWR768TwdvqsmG650+19mQ6soHELCqUxAod8I6BzlA?=
 =?us-ascii?Q?BQgdBiYjfG4KoalChCwWxPBkRg6lu7guUklQLU+r3cbjLy6v9VXK7mGiyxAH?=
 =?us-ascii?Q?QTIJ0vyuXzU6hPXnYCieG3Dbdi8PHImFpE6UFmqDh3xCXJZBe0JfaG+kxQpX?=
 =?us-ascii?Q?WEiJivQlfMFV1bFmzJWe50kIfuPUXRmscHwyp33wOQaZWVO9elGH8+HZ6YdY?=
 =?us-ascii?Q?+8rPR1krf9dgT7agx8z3SAPLiHMCzcnOGaHv9UCpj+WElF8OCPLsSfDEWSY6?=
 =?us-ascii?Q?EavonsZZVEdGqRX/qBx8zH8mVf8J7POgM9RxpkMTOqejzQkHL1TMJzsEwWmJ?=
 =?us-ascii?Q?5sKh+lcf2y24gaVHJFFlgObnWz3y82qD4kek1b4vnib5zn2pd4uRe3eHJQHY?=
 =?us-ascii?Q?JdByqpo6NzdeFvbp/ZWJZ1l+ZPZrIAMdC1/E5nSLOYPrpmgAOg2+PtutiWdm?=
 =?us-ascii?Q?J3sZG/SG4ynZt2VEMQLijFzueqJLNjlpuw/GcDAibZLIxHCRPKhG3oZksqcp?=
 =?us-ascii?Q?UtRgsY4CO8ATg72/oBP7/RjOOS07LWh+kMihdxzebR3tpjmJz3Gn8ys1MvlM?=
 =?us-ascii?Q?5aWx+LPopaAKhPRcxzp3Y1SFe+3thp8+NHb64jA5YUwxvF0dwhViT77zJJKh?=
 =?us-ascii?Q?DDwoDVjMQ5igwqz1YASaXB7k+OD+ysxa1HTg1rmvO3/vpREh1sYwNuMcUfNu?=
 =?us-ascii?Q?v08r52gRfcV5RSVGuEfd40ZUY30ouWujqnkMcFUvEwBWELAqZpWbUPHnrjf7?=
 =?us-ascii?Q?GWgkCzmtkt8scoJMwdMAQXO7zF7faCCNg+IjMdoBYyct+m+rjkhMTr0uJDIA?=
 =?us-ascii?Q?4BN1XVeH5aIXu2zYvfOG23PwgvrmNUjpm5V4SGGwkB/lIPWc4amIe02N+QF0?=
 =?us-ascii?Q?IyCXpSaEX66iGA/y1+qmzXQyjK9g3t1CqoVAdyG0AGoxA3ky0wf49PY/JycF?=
 =?us-ascii?Q?/Admcb01OuEstD1DQ6aa2AEI/2QI0OUTp73fSjhSw3549tK3QvX9goCRBGhv?=
 =?us-ascii?Q?aR12YjsAmbj+S8HZhCjBBQG2s5VQBnjnnXQejCTsoSX2Lx33yCEGexYXtxLG?=
 =?us-ascii?Q?P8M1i097aDam1xWduHaz2Y6WLl5ouWR4KTOxK4RMW7WLLSOsdPiho4qgfUzk?=
 =?us-ascii?Q?UzquwulTKLR1W1bytrDO/fjz+aiBhzYV9fkz9t/7zMwqmxubXBm4zAN5IYIv?=
 =?us-ascii?Q?/A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ehvqhwgnz1E/W8MwLNh+83PdxxyE0PITWBg5C6LOUsbKwfYIcov1eL7jiAmTNttindJzdDitXs18J7c9cVhVrhpVTbI748SV2mq3awsfUocrf3AhksODov6f+OpToTZeah3w85kDKyRZujves7J0yhHMSzUBMEKGTjXBPxsr2rqJYQLSvxFSHFwJxATVbJ6Mk+1oo+tHfzZmadDIMRVM1QROT2HMRj+o6/wrti6B+6Acb7fPpRfh1j6ydVz3Z4zwlIKpBFG8Ytcx3mE2QUYMh67EOPhQ8TI+HcrO+WQ75h9ZPu+OU4lxHZ/GMQ0WKBS9F3QhnfViOj4ZDxggUk5VkX7kK0oXk3jinn+TQwJZxWQ94MrxCWOVOvltwCnB/Tjh2AwoeYxvzGuTD32/lkokHtuaKtg8U5oixGbzs3L7q+IRJCAdpCJuXzS+2zDvye6oGFslr6Ba5ncyosXvGWie17ckoJNgqpPS3Trr973krIENlj7kuq3PoiPM3l8F7McPTtE+PQ6vz/Hx9oeuNdiGLizn0kCJ675KDeL0kzQr1NSHbeDqmEsYBCFUkRDVSE+kbzZ5msdylcJPdNVYKOGj0iaEOwchd5KcuRhJTgv6PxA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acf40d41-e914-4ea4-62d3-08dd31c78cde
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 22:38:49.0365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LqvGd6O/jhRPvRnYWI4oiK2BYSzHjMARqo8fv9SQzhQzaniEyN61jcuvMUVqAyQdavoQH5FpMB7me7Ww41dUY2DhJK0oykPJZXL6K6i/S8w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6443
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=750 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100174
X-Proofpoint-ORIG-GUID: o4fbCjIM-mIvLI35fNKuLEeCnNsXtoUy
X-Proofpoint-GUID: o4fbCjIM-mIvLI35fNKuLEeCnNsXtoUy


Xiaosen,

> signed integer overflow happened in the following multiplication,
> ext_cyl*(end_head+1)*end_sector = 0x41040*(0xff+1)*0x3f = 0xffffc000,
> the overflow was caught by UBSAN and caused crash to the system,
> use unsigned int instead of signed int to avoid integer overflow.

This patch is against a very old kernel. Please see commit a10183d744fb
("scsi: simplify scsi_partsize") which was merged back in 2020.

-- 
Martin K. Petersen	Oracle Linux Engineering
