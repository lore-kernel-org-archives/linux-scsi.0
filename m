Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980652DA776;
	Tue, 14 Oct 2025 21:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478484; cv=fail; b=QSwH1p9xUtfHUq7IsAVpbHFesX3xdub0/jOrhoMBJUBC8Yk60FGdsuG97ozXdFbte6L3CxBH6MZEu9c3daWfDadSF9PAkhnkzKwkhHNETg0Bw9ATOcO2FQSACPuFWUJKvxDsD7Ip/FpZD/leNiUDRpuOkQcdTQzPsEau4WCusrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478484; c=relaxed/simple;
	bh=O2nj8iyI9tw16Mn0dXApDsq8hTqANjBok/G6Dt1Dn4o=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ilgGnD2zKlMriLp0OqF8cM82IK9BzqZBCJ3g6KqPFzsJLqjHiDMRyrfuevSaBUkk7TpAqfHUUvSvSxKkcYkYHypdP6bNLr1ZfnUC+4WyOPsDgdGC50ku+oJn1X9reDnzUIQvQLMXd43RfzmMYM8HfrUh9wTbEiUvlKUDSAfzJzI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KyCXFvax; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nTmrVMQ8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KyCXFvax";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nTmrVMQ8"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59EEfFID001907;
	Tue, 14 Oct 2025 21:47:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=NgEkOVKMMFrTu8jBCA
	iRCZcZoGfGbqyiGgdqiv9fRFc=; b=KyCXFvaxJNTglfQxR005s8hFiyNqvdtbip
	Dbx7RLb+H7dEyiKqvEYpOeOfM7KOGWL7JDOPdTKnzYFsGW+6AHIPdMm4nQMjA2kv
	mE/p+97UA+x7D+kGQLWUikERBs+G4a56oByb+7z6tkdDnIDEtz5TsOjIKkbqCC0r
	KACfMH6zIYfdlaaWiHZIsH30ZiMFshTcxgQ8uwP4OhPQhL/NjKfQCYWDkzYOxc61
	lnMckq5SKGRyNdoaEWLWUbdF+9gSTbVNX7/ihYMxNEHdGOWIOnp4FjJYwSE48cwC
	2KbqIQXoGF88Woi3+5vZWamPY1WWwXv285/UtXSSV3yyoWpb4Q3w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdtyncxb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 21:47:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59EKhUC2017456;
	Tue, 14 Oct 2025 21:47:56 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010052.outbound.protection.outlook.com [52.101.61.52])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp99n9j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 21:47:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WVG/ZfzkSRxHUnCy6QOC45G+CHcKyzmSBSekkLNft85tev156vlUnyIM6AGRzGy32nutBdrSdOfq4oxcb8F55crY0GgfSe1eJM7Ws+FY7KIOS27uy82UPY1vKOWfH/lz7xk6F/dcq6w07wW1jdKc2Oh3X5wd/K/lbsk0Jr/qSFaoUqBJfVuOFpxKp4a+oYlEe+sPF4/UzFf13wzaE+lUHj5vJsp7LAwOkoco3vBIcEV8FtgBw+ubQjV5ikpSBEcatOzIB8+Kn/qrKw98B0ejeJrNI+hNH2r0bP0dMEdqrRdz0+l5futaV7z4V77utXkl7c/wgoRiNZ2eYOEGFD0xBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NgEkOVKMMFrTu8jBCAiRCZcZoGfGbqyiGgdqiv9fRFc=;
 b=ffiVQoxpI60G5rUvY67WTk8PuWqopITDj2dq7wFPHwsuALthPs641hcYb800WoJKwNFORYpdEaW+1Fh44nM1FKv2pUSdPvmm6wb6NpuAIorhXGVWvBfbufkJ9vDbjY/CX7NXh3Cl7ILKTxJATGXuYMWtJH4upQWFawGyC019vWkIbN7C8K4Blifio0lY4YIS/Is4FVyTKwkNDcZmrXITkOoGHbhu+Yhi55767E/R7wOTGvpVZYm2p8EoJiTdzzQXYrKSXVk7GgatuhQAQPn883CcPSv/rZRJFb2FnPH8yHNt1oAARftndb/OtuuwmddZ3TZfXXfuJly5nQ+8vgY5qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgEkOVKMMFrTu8jBCAiRCZcZoGfGbqyiGgdqiv9fRFc=;
 b=nTmrVMQ8pHDIUK2gIdZVmajWdVsCpYhL20B2+IDXamnT+G8cNtdgTf6egngWZJq/h132ZVq0p+i+uWSl6z24U5GRMb4ikRDxB3/O6FTzaAaqcSn7cYZSO+Ww46yYM6ZikyQSvlxfghy/tfsvTSXcDAMegxMlU6SfDXuUshmtUZg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB6644.namprd10.prod.outlook.com (2603:10b6:806:2af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Tue, 14 Oct
 2025 21:47:52 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 21:47:52 +0000
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena
 <sumit.saxena@broadcom.com>,
        Shivasharan S
 <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil
 <chandrakanth.patil@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2][next] scsi: megaraid_sas: Avoid a couple
 -Wflex-array-member-not-at-end warnings
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <aM1E7Xa8qYdZ598N@kspp> (Gustavo A. R. Silva's message of "Fri,
	19 Sep 2025 13:56:29 +0200")
Organization: Oracle Corporation
Message-ID: <yq1qzv5b1gd.fsf@ca-mkp.ca.oracle.com>
References: <aM1E7Xa8qYdZ598N@kspp>
Date: Tue, 14 Oct 2025 17:47:50 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0001.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB6644:EE_
X-MS-Office365-Filtering-Correlation-Id: 336a0dbb-8f35-453f-baa9-08de0b6b5381
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wlH+F16A3LxsFzzU74CkwRSbwfAgrQnmTTJdP3X+6Ru8E/Sk5wU5BYOLw7fW?=
 =?us-ascii?Q?rH0wUGY8OXo6xS2e7BISM+B9ybW6KIwgcNDnxiHdUSNpO4rll/Sb8uy7KCtC?=
 =?us-ascii?Q?ENqYmIZ7RtAAr3OXHJ8mX9ALgJnvCR15M1zKvQONlcsFXAZKgP3KB6tJ4EqA?=
 =?us-ascii?Q?CFiro2Wz+p18xKPFep1Hfba/CTIAjZ2PqZrnb+2T60s18IE+kY6DDnfh8DYk?=
 =?us-ascii?Q?Ik7dx3SOep9Kg3E3FExc0+RCcIptAvrymnxyGz1rl0eG3Ww/vs4cuOV4m2U0?=
 =?us-ascii?Q?Q9DNM7zWdG5hV9j0NzJS4FwK4nQrmwNRRGHB78ts9Z/DyGm9iztxh9A06X0g?=
 =?us-ascii?Q?zni+Nx2rj4uEZHj0sZMmCcTWiSIJMoAKfPMp3fz6Ig7uuMD+nLrS6aYyWFhH?=
 =?us-ascii?Q?2QuoP1IDSqWHYz3+QScLgkiCMbjtg+V4P7Q8cQc/ilCTYUlc4sE6mpBEpxPq?=
 =?us-ascii?Q?yqIvWPzTi5Vlrwb3XV01hapLlQehlY6CXjwmvT31rBX+/brKTCiMWwRZ8/9T?=
 =?us-ascii?Q?MFkba7wxJeeG9FMxZ1WfUe7VY5LkLoddqEDlUnBdlm3rpBmEbWxak9tLnJvo?=
 =?us-ascii?Q?r13TUxohe7EuA8LyDyHIrhcEVouI+vJ6eVbdCJBgQxmZa2pwSwIAmgwTWa7Y?=
 =?us-ascii?Q?/xjAs+R01KvXMnLbLUiPISDNAdgfDAkMMxER6Ub9IHCyWMbivhnTio05wP9N?=
 =?us-ascii?Q?hpCDZ4dryDwDEIZfvBSSAeZK9VyqSFqnEDMTqYWAQtpy4cGW1SNkBaXmHDel?=
 =?us-ascii?Q?Zv03MzZLSqzHha0bvMEPjuyny0Dwx9FSNu2TyDQ4LrMH36H5NWyqLHOX0iEN?=
 =?us-ascii?Q?CUEh2wqu5xVUDtzGYtyBnDxECv7ta7rzHQMpd3C3MrYH8bzi0Njc4lSKX6ms?=
 =?us-ascii?Q?gl3k3T4EL1EA3/bOTA48WSEIgaqqzucp+UI9D7otQjZ5etfuPRzz1MUpwLBo?=
 =?us-ascii?Q?1j//M9wEBK0Oe06XGXdzlkkOj5YPgLOiWR6ZHxzzMQq2fWoLXO09yy9yOzsd?=
 =?us-ascii?Q?/PD+igsjeD9UuChZJoR5FlctgZoGgfzn5bJwCzsNXmHL2izdGYs0Aoj4NJKd?=
 =?us-ascii?Q?TjH7WHolZqso6n2DMHMCzq9i6+qBWa+RL+vLqdCLD8Uvogll6wbfmBec9frY?=
 =?us-ascii?Q?ECnAIrKDRtl5MG5xtdRTk79+UarijiD9Im7fDJLF3YRe7RUFTL6l6iMnEOZv?=
 =?us-ascii?Q?jRRp2km9bol1AFbj2izjIvYsab3Z2s+mNk8U3LW67Jor1ovR6/f4uxTmOdXx?=
 =?us-ascii?Q?o6SgLPS4UhrEOUvHzmwz8TDJME9x/AbBKU+MynV+yHp7V5MypfGkokIUmeUO?=
 =?us-ascii?Q?dRQ36RN+szCYB7aYX/VxgLPT9Q3UWyg9XSPXgAQpR59qVJNtId5nLByQkTlb?=
 =?us-ascii?Q?FgwaRkAhbtjAULLZEUird7+rdHhaAHVpT4DFf0+cq7i6V33UUVa3L9LDzRcI?=
 =?us-ascii?Q?XSwbBj1RRz4Yf3WkS8SlWItngptjlrwb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6m5Mk9XzfqHcnyOgmir+zA28azlVqOSeTY2yi/XvgO4qdvyurbq0nxvuXYJn?=
 =?us-ascii?Q?fpCORdegBOfVxZ3QIapZ77jBLr9DiAqPAUV+va9daLcSLsExV3DvWsNZF4xe?=
 =?us-ascii?Q?Dgk0Eww5zbC6FWr1wJ9RL5F9knhKajRLbhigWf/c75HyaemIVZFIddDsox06?=
 =?us-ascii?Q?AqPrnL4HMTWzTgzKySld2TXiXkamHaSvhex6V63M7UzOK3da1bOuvXYfZEWr?=
 =?us-ascii?Q?rKcF6XcPYvm3UtEIryOyGFJ1yY1lEYyqovvsAkijdQ0MASG0VkJgCZyEF092?=
 =?us-ascii?Q?QksH4qOe9vM+33Dllu8VR6U613nGO7413HxJZjIfmaNCa9OocXlQvbqgSKg4?=
 =?us-ascii?Q?uBOCyQbDBTzn7ZDFvw7Y4WfhcX3OzvTcCkkI+ehVWGDHHl/45a6dWazZWxBa?=
 =?us-ascii?Q?3RFQRyZOkbKzA2v1m2Zjt/A4HBKajcZGhpjV32OzmavZ4lMFpl8xoChiGEWF?=
 =?us-ascii?Q?FLbSE5Sxdc4Lt9HTY5fPwapNB1h4ImR8ztFZ4Kr1Y0kzwJaHoizoy6iclJ46?=
 =?us-ascii?Q?kwsKZQ2oKwp8J8mdv7C2nBfzX0OKy5xFk3g96wx12uoSDym+YgkL0l+RShCb?=
 =?us-ascii?Q?n5Fjlw4XzoqzZxwQ19DDJhQuvvx0Url5EcCQ4FaSyZfNWtKeYGCc6rdUunx3?=
 =?us-ascii?Q?Jmf8JDxC0AOGGXxoVhZ8w1NS2zrpDctyZKbZlqGatLljP4avv5UiLYxv5LuQ?=
 =?us-ascii?Q?G40VHnhuAZz51s2YXzJyP593EKv79wXFnrw5SSzXXj4Hm+r1PkwBIBgg4eA9?=
 =?us-ascii?Q?Ba8pMawHuJIfYgXziUUgGxzgiVy2IN+iwQXSEzPcJSiCVHPWn3cJPD3ApO79?=
 =?us-ascii?Q?0CDeC/gXmZwf220Djo91J6972GD9B/Yzj47um9OVuuu93tVQwKo9fGpcmpqm?=
 =?us-ascii?Q?CCKCafM1kb1YGBwuaYfkTgjUWYFBKnIDFH8VHtco8eyQqBXECc90j9OqyKM7?=
 =?us-ascii?Q?vpnnh7IuLrULDJHczHsJdFayF+vJg6TzkaAXchG+LiXfQseRFIyHy+SgBYRD?=
 =?us-ascii?Q?j07K+zVAFHtqRzPrxoePZMpZX4KwlZ7IrI8yKaoPnPZv6x1lz9dxMKMWOF6w?=
 =?us-ascii?Q?tHOhQtlsxMIdx7LuRXSTTeiVfA/KCiBFekvv3tlu/a2I5nHwPzGVlB/bMjY5?=
 =?us-ascii?Q?TEFRn8au8eFsUHoZFg1CWpotMiVfW0rZCxPYBVgrDKXPnqJcycSVO4Ji+kVH?=
 =?us-ascii?Q?TYyuzik2YczPLoZB/M3Q0LtmOCaGwVwv2TH2ZNPMZI/nNU0lHYNRaK7lA31R?=
 =?us-ascii?Q?TmPAITYKRtJ29ALKmtWn5TCHcL8aLRdTJQiKIzW6JgWKxiDTuuE1Uyyc9vLD?=
 =?us-ascii?Q?LoeLcqMaKIvrATR2mAIgZ+w6HwaOBgmKrljYkTIodxLUTsi0AIdc7MfL/9E0?=
 =?us-ascii?Q?QuzY2TeF4i+ccuwBInkxBZj7szeO4TeIxRicdIrfW6KKU6aSGLX4dnfT0qw6?=
 =?us-ascii?Q?+7KvXzpwzX82Kr2enR8efmuOjSpoonw2AFLehnlludXqjrFjjinvHvuKlMfm?=
 =?us-ascii?Q?QmybLf0bfef+OHouCGCDvW7yNmE+JTWlrSEYhsq3V18/daQ7+4bZxpcTTBm5?=
 =?us-ascii?Q?orZV72wuDruckQC8AuppduhJXSZdp4nIhmm7WdXxLrePc+iJlGzPxlRad3Bg?=
 =?us-ascii?Q?mA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	96sEr3U/Rdj4ZSASz7+mN5JPKZoOZp+AfVWfWjEWrkrikMPqTtk77tWQdQqZcQ1ANIKrhOIMxDWUwmkc0CfytpbWxbGyRqqX1390maxI7Bynh8v55hnx3xoKAW1dXwX6HJmd7kwSYH/vC7njR3W51N/fie4jCGikrq8gqKIoFa5oKTlE+ctdzTjDYjMDf2qKQHM+pe+w9szKvXMbcDJ2SYO3yRaK35FaE9mepCl11OiMNuquTwlX4eYAUElY6nChPiEWIu9zWBbjcxbH2k4w+5WJlIfHRhG6jjm8lnTWlzrUpvVrzKfqZXiNeST1Nbkdbakvpw80grssmgZYH8IPPx3JsrvyC2fZBdKYKgQgijL+P/js+/Tq1Xp8P0ShCasZLmzLR8KeFABMT/yP1hLyRcz9huTzoxf4wdVyqNTauB+NCorvBCeIF1DYdOItog6lkCaOHFGtY6znjVRgyBiQD+YwCk5BsPE4j15bjy8zxJ/H72xiyb0TjPHJlx+WfCQnJ/3Cu3qWncuVKmJtwOaCxoh3CwwnGsOYc9wTAkYfWvTJ12FAgqJ0aCGNWVoRQPe3e0xefS3UdirBVHEZ6n8Z/ARS3ZWEEHzch83agH/huZM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 336a0dbb-8f35-453f-baa9-08de0b6b5381
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 21:47:52.5428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: slu4Tac23owVgnsxNcvJR0bbv3AiYDBrlhMHgIIFJ36M5Tz8FCI15j3iL8aoEVj9lFPe2Vza9d1TbmY7Y3dDjcnNn02ZzpuP8XcTnjQQ3R8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6644
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 mlxlogscore=756 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510140147
X-Proofpoint-GUID: -Bm4p3lLvjIp9zNXHm2X93VUzKloiVH0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNyBTYWx0ZWRfX1r1Ldg6ERvQx
 UEfHwCveQfxbtrRRisAKVn3NuUHYHMKO2+qL2a5TUiRgj0wqUhfyrBHI4stx87aJOR81lpyWXeF
 04VXixRRTg6KvBZ+JO2+ipaebvrvOu3P8u3cEv/+g0OGw+8+nu41hjKJuuRh0+6VUmLzujMBbph
 skklFiUYptQeys/rV59w3OKmBuMpT/TnXfpg+E7VL5NUOlO+zlL/jOkdlU7TkSYaXoaG6k0qbNb
 28b9HLtJg44EB1EnEbr/pkZYvflf8aWF3d1Lzy2h+1VIljS40aORIDPCGNRvLKBraUUCNJvhrBp
 rbWdLGjAPSMjtXim0rjbpzn/py/IWFtWVA+KjwKvHnCQ6tdYEcPHIDEmnhVrmRra346NATyRaSg
 mrsB7F/BG/LiOoZ7vqO5UlNeif+EgA==
X-Authority-Analysis: v=2.4 cv=OolCCi/t c=1 sm=1 tr=0 ts=68eec50c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=W12DiMFBgLdbyJZWUR4A:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: -Bm4p3lLvjIp9zNXHm2X93VUzKloiVH0


Gustavo,

> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> getting ready to enable it, globally.
>
> Use the new TRAILING_OVERLAP() helper to fix the following warnings:
>
> drivers/scsi/megaraid/megaraid_sas_fusion.h:1153:31: warning:
> structure containing a flexible array member is not at the end of
> another structure [-Wflex-array-member-not-at-end]
> drivers/scsi/megaraid/megaraid_sas_fusion.h:1198:32: warning:
> structure containing a flexible array member is not at the end of
> another structure [-Wflex-array-member-not-at-end]
>
> This helper creates a union between a flexible-array member (FAM) and
> a set of MEMBERS that would otherwise follow it --in this case `struct
> MR_LD_SPAN_MAP ldSpanMap[MAX_LOGICAL_DRIVES_DYN]` and `struct
> MR_LD_SPAN_MAP ldSpanMap[MAX_LOGICAL_DRIVES]` in the corresponding
> structures.
>
> This overlays the trailing members onto the FAM (struct MR_LD_SPAN_MAP
> ldSpanMap[];) while keeping the FAM and the start of MEMBERS aligned.
>
> The static_assert() ensures this alignment remains, and it's
> intentionally placed inmediately after the corresponding structures
> --no blank line in between.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
