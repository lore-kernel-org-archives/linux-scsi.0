Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB55738FA3;
	Sun, 31 Aug 2025 01:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756604943; cv=fail; b=GXPymDjIc1iAxefu3yr4wd5NKiUEzJF/M2RQ9EBUG3xHtADQDvCBeoNx1iNBDl01gN9aVmXJ2FB+C/JvbzMcji+KOB8Se9TBRIPfxAB4R3mBc3LryYLUBVur1rXAWI+T/joygZ/96SiadTcz+19/0v1w4nf7fM6IFM7CX7BpOks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756604943; c=relaxed/simple;
	bh=tRzgU2PtqRrc0pqRiDObbqjZmCfPlH5xAH52877tcoY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=sKqL9AAQ8CdZ8bKphLUdxKpx42mZD+S1+CahqZAaIlE0VPR8fRHXss24ouD+YegO9TFHzdVCGKdArPrXyIeGqrHYB7YoKSiBYjIkhYOVkpX5cjDBK6v3C4/5Jzhuw0EWPkPAjLJQMHElbVveoCJYCUSYDdSItWODIH83UTJxXVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HS1N7e6u; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gMm9oJEv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HS1N7e6u";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gMm9oJEv"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57V1SbIO016596;
	Sun, 31 Aug 2025 01:48:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=n6z3WjvAGnUA36/QOB
	/IRXBIJpbHxDim1+DEvC4uLrs=; b=HS1N7e6ugmoX9yE6xYxK4ngNokYukPaKLh
	AXupUf4ZaelCVkyKO14LqGfdQgCaU5HQ74FnxdBMGwqaA3THLyMcp30buFJ0Me5b
	ElukF/SB43EbNKgGNtuTx1el+xpFsPfrmYyuZdHD3GwlMq8eN9ADY1jiQKlCvjpl
	+/I+nkXmdw/TGdwV4iXadGa8g/1/L4gOSAFOsKEqXsm5pXxuTQDoe2cwuNyYzWeE
	jdK3EMYMG1WM0PX02mJgEZtuQrkBH03GDFqIIS4gavM1vXpEg0YhE14kzSEULiK2
	czZowKNk35Ec1nN9QEMiVdDkwwRIeSivH3R54UQbAZqn5Rmo8s/Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ussygkqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 01:48:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57V0MUFK004260;
	Sun, 31 Aug 2025 01:48:50 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr71v6c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 01:48:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fx5DpJZLPSSJry22ygY5YzpgXRy4QeXLFD0gLktDvL1OXymNJuFtEmyEXFW63D4XRrF7jIJKMtg6V7ILCobCPp+YgYtcQEN/Xp4v8SGRsQxPXejs2piltmEwShuWnaO18VWJcSQMYDPZ+FlxpWwUvGALEgkHVluxYF1j7K5/+JRBwv0vPVXJc27nyet+7Nej3hA+M14pKHKiEAEnCe7gci336uJorp3P1i/Z00I8hEDBxrKqA+CA0mnreoIj9X/5ydVI9OE0RXq4YA4njQagIszHKA3PpjzJShvfMkiR9/oGRQDw5G8Dg7rkEToFQuCFu+Ou6djturM1MXwuhDwKjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6z3WjvAGnUA36/QOB/IRXBIJpbHxDim1+DEvC4uLrs=;
 b=UdJiXEnLP/UL6VWHRsYSIfI63P5yWE/kZbmGwc+htKnZxAh1FZ6f804mWdC8CLUmoxzrGQQ0NIJAGFB8Onr1PCTSMFsjkMkPXjqgvW/xlx+/iicwI+hKDkJ+98JlHQDTPjaCRnuRJOx0i7ZHF6SyWB6KOr942TYTgIGfJ62gn0DJj4tHaVRx7gn3stbdrBZh18BzLxOGTpkA4D/v2t6qHKoKmQm0s880Q94Ey9F1pumg+nFhyeujZAObxd9nGrfZSKWgFgFjsEqzDDbMaSt35lRyOMR0wa1cODXSYkc69/LSaS1pFb6navCclQlzltGAAUgPx/bCca3n0dYsHKWb5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6z3WjvAGnUA36/QOB/IRXBIJpbHxDim1+DEvC4uLrs=;
 b=gMm9oJEvqkcDvHo7ub8Sz7tRZZbDTydR3F7jPFSKHsw1t1VS5SMal7fdZFKQ5VVKTMVR3CwVh012vw9y3jMiMW6TCRo/PFzs7BxRl7BJvOyUW/lTcxVdm/u7KBicGr7jk0YrD8kJW69DCm3pWVuOVaXNcQFH8MAvA99n4qwVYYI=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB4557.namprd10.prod.outlook.com (2603:10b6:a03:2d4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Sun, 31 Aug
 2025 01:48:47 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9073.021; Sun, 31 Aug 2025
 01:48:47 +0000
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] scsi: qla2xxx: Use secs_to_jiffies() instead of
 msecs_to_jiffies()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250828161153.3676-2-thorsten.blum@linux.dev> (Thorsten Blum's
	message of "Thu, 28 Aug 2025 18:11:53 +0200")
Organization: Oracle Corporation
Message-ID: <yq1wm6kdzwt.fsf@ca-mkp.ca.oracle.com>
References: <20250828161153.3676-2-thorsten.blum@linux.dev>
Date: Sat, 30 Aug 2025 21:48:45 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQXPR0101CA0060.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:14::37) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB4557:EE_
X-MS-Office365-Filtering-Correlation-Id: 9118a4f4-6512-4159-2065-08dde83086b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q2+HLqlSY4l7pxC/i5Cgww/woX03ton9j/OwGaRCqbeAfcDm+5aBP2MdGC4t?=
 =?us-ascii?Q?5Nb5oYj8YIRKWIzPFUIkx7mMdN7tQGNKIj0SlYt2ytyb3lrXri0lXJlohQHI?=
 =?us-ascii?Q?QIG23EAGsxZ5jBjFgiRR6fqBoTdR4Vzih7v3Zgm3/TfT1Wz48LZf7pr9v+t+?=
 =?us-ascii?Q?gCAKwr2LNK3EAIj4l7hdl6eolkqLabSzy4EINSL3qwJfXUv+cFBjiUV/iETg?=
 =?us-ascii?Q?ZJyPttjV7QhksY9VHOJZB96x9l3FYoSyO6l1F0HfC7cFrdTZXm/xcfLe6mq6?=
 =?us-ascii?Q?RDT0dJFpzGuTdjNU0I3jCZIVh0C9hSQVEOAs6xjZaK680MVuXn9oMGyUdzti?=
 =?us-ascii?Q?XiFW/MnJdGsRlk7waFccCrHFITv9Qo0I0R9yz5U1e2alWg2/IQR+bS9R4Lbv?=
 =?us-ascii?Q?fXMIlg9kpS9NStei61t3niTKw2yA1ph0uUm/xCyPOVoIv6typABd3161Ru9o?=
 =?us-ascii?Q?oS17Ib2pyfxHBqK8uDy4RzUgqv9bz8QwYnap+TTCD1nH/ewL5IXll4I1Iv3c?=
 =?us-ascii?Q?2kmSrGtiguwH8cPh1pQ/qVfmPpnmgoga/ZHPiunspMIAk5buqLr6ye7/4TM7?=
 =?us-ascii?Q?GWgfShDPFIevzu1Lm4SMoRl2Qvziw4wVjoCFmnJfTcG7qRzbAdjcbJz69Lpv?=
 =?us-ascii?Q?Z5FfTgmnlpYATqHmDjIdmqMOFfijKxxxPttY7m4L2WToMvUJKCy321x81bF7?=
 =?us-ascii?Q?NqwgfOvZ6SyHEZGqZZZFf6wfchoRGn9m7gI6IHdeQ6F6NG/UwF3TiZCkDpEQ?=
 =?us-ascii?Q?Gp2++9IyyYqDwHV6Q1qrrAP3q8MEOrptG7zR6LLKjUIOM/71w7Yv8OQsJKZq?=
 =?us-ascii?Q?0kxygxQ92QoEVtDOI2W0aL1kHKHjyvCLXpxOhEkwGUODQM1PxQyeImNG64c1?=
 =?us-ascii?Q?ARZGN6eZM7J46ltIweY80jkB6hhdJ7S3cwbENN47yJ/FoxTe2ul7lu+rjHN8?=
 =?us-ascii?Q?b0DD2f0jLUiEzW2sdim7w0zaWO/v5KmM3lAUhkCKoah1Bm617QssWirTv9v2?=
 =?us-ascii?Q?cvE4cU/EZdBD/33wk3QM++MnHp4zlBIsuiRHqpO0k3PXiMoDTZR3RwSG2PxP?=
 =?us-ascii?Q?QvtxkSQz889QNfRbfDTA3Fd8x8L0CCoOwN7RJ/XqFQSEGHloLV5sPaVDEfhN?=
 =?us-ascii?Q?PefXDSaSQzp+OlMyXlILVv1vRsE01HWcPqp3EaWFjpSAR2BqsaU5GuA3hjhS?=
 =?us-ascii?Q?Pjh50vKyeRBqEszmvX0HqrxvzHVsAVKoTCQvEj0amd8c+m++qHaBjbYYYUH3?=
 =?us-ascii?Q?/JZdghXFiZvQP13OAUJtnLIMj44NXj6/ul3qSOwU0x5lXLBcZrIhf7kqmOuS?=
 =?us-ascii?Q?0pi0ZDODOjZ3MnWdpRfMh+lSsIA3RQQ/LtKdIaWlRUO3PWnrwHRzR1hHcycc?=
 =?us-ascii?Q?65SE+dpDIMcfxjJ00j0Nh4lch0v/GJQhqGccoZu0g59kI+pARA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UeBbSKpOjfaJvqN92+r+8ll52VdNGTMK9jnl/nluOUE2eY2VLUzefeVEJmco?=
 =?us-ascii?Q?RSW0W4Bs+5TNNPeyzcijsrpjBAQECiX0qG+tDLl7QphwACdu4w7idM4umO8R?=
 =?us-ascii?Q?MnPwjlZFwCrXChncn1PQqiE5mH/g3wbbqpHTdys91OHdI1/8nsW2KZbET+32?=
 =?us-ascii?Q?kr7p/yo0hA59fRkslsH021tF/BfRLMtyNQwCXMD0O4vh3jnljhnNRHrT/iRc?=
 =?us-ascii?Q?VYJF+5VgJtvw74mizMF3y6MDuZcrWmP7tVD1lVptg/m3gZTESfYhlnB+Eary?=
 =?us-ascii?Q?FH8ZoEIInij2d1ystW4NUkNeU8FKsn33Hsugl9BDmEUEQLPaxz/g1hzxbpVj?=
 =?us-ascii?Q?Z0NUMJGVq4kMiAQXZEBlJFlyVxf9RL6uMWWcW2ParX2EznNRmzDXXQAW8hFc?=
 =?us-ascii?Q?xAVEU+jZxzoDqbfpMSAI4IqYh2CroP+I51lDSdxphh/oeZZ2Uqi50XRYaNyM?=
 =?us-ascii?Q?Jpx3uRFIlrWBFrqSk2C0X4AOowYcWwDncToPruSUwevtaJdti6FvkJVLWiai?=
 =?us-ascii?Q?i+LUBcFNbHKUJIyBp2Ul//nIyNRLjUFKgVi5eAvG0rbMvnS8gCxhVuwPUhik?=
 =?us-ascii?Q?083Twpm0rF7OMN+uU2KNwlEL/oHgYX6MxN3CJtBNTyAAnKxJZbp3hy9sA2dW?=
 =?us-ascii?Q?SijqA0c4S/sRQGEv4qE3IltpZ3vqFeD/AcqDpCW2HL1RAQLx4MQ5x+nvRSGI?=
 =?us-ascii?Q?wHZy7aa5gM5GXs64T6lV9kMkWvxo70RB+hjAU2VHINXXZlIzL7RjtydCKj5I?=
 =?us-ascii?Q?aD+SkIVCfJNZCCnLDLBFYM1HCAcZnCCkISUPdbAkX88hEQ5bPt3cNkuXRg4b?=
 =?us-ascii?Q?hS1NIQJKWhiMHyidStlN0xZHCK9zyUhLIb109q0kYAtPMq9pK+fOzHUdUBeB?=
 =?us-ascii?Q?jvdrXJnqP0hF8WAUnrIKpuh73jRu1bzRU3XMcFA7B3L4QAKDhkfy7g2NbcgN?=
 =?us-ascii?Q?XAbsKesaJtXT6zImX0RczHJrpL/zsgX+vbMBj0tXZQh1pGa/QkwcAOuSXvta?=
 =?us-ascii?Q?M50lAyCnAENLtHPChAIGceBHSk95j7o564/ntiv7Tl72bQvWypAcB+0LoxQk?=
 =?us-ascii?Q?5kQ3g6VHT7MVLBERzfx3y+LOI/QY06jNYcEBYJvVGiX0OTIDyst1V242BauQ?=
 =?us-ascii?Q?HAuMF4EetYFA6Dwi0g2O2fdZIV/+hcZlbNKvTbxay51/m21gBx9Ne7GLIxBT?=
 =?us-ascii?Q?zB7iEpdLgiteE4w7Du7Kxgz31t8I4Xjxk/Gyu3WpIGNH0bh2Q9ubNoZaEMjQ?=
 =?us-ascii?Q?xDc+4keIlegBar93ByVN6OOH6dxV+kFPaQUESlZ7nTSJEG3eYvIQrNnf5Kv7?=
 =?us-ascii?Q?hBU7mnYJeZDhwwplL4rH9iDl13714kN3fuH59DAqJtNy2kxYxZR8aTI4VB/z?=
 =?us-ascii?Q?R6WqEnwAe1zROZHQxqa87d3fOTWc44SxTTT/ltF1P2biNLb2W+JhO+vEZWLg?=
 =?us-ascii?Q?4OjsGPeqzOp9wkAcW3hrZVbJIwVeQRbTtEh5eNwhIXgpOHF5fB3uL5oMHvbi?=
 =?us-ascii?Q?vlg5HBwPNfje4Gb7rIdKbB5LFolATqSKKPIt344sXWp/ScmUMrjG892lUe2f?=
 =?us-ascii?Q?xG8pDkzmRpHWYDh0FL3kbica02hUh8Rvfk1ETU9ttryv0Z95IQIddd7cBWFb?=
 =?us-ascii?Q?xA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WsAkVxVAZazXmgPlfGM9GNn8mH199LGSagkXB08YydnMxClOvlMRyLVzTKNXA01yMkvHmJkjD+I6EwGaW/yX4mycY3Y/fX3jOA3g1k5Sf7xY7pyGEYLF6k2OXWYQ/R5md6n7HsxTPiieBqlSBGuFCmle57PAKNZyaiKT0leb/jrUhgHM6L3QEF5kOZ7zqJKJQVmGdmq08XQK+TDB9mTHzhlbexHKZUC+gfjTou52Z30UwZGP+iQZD5xXo/fQOSYRYtoJPop+gkqJv6xCxiT3VYCN8/aNDXldqa/uqqJIiQACr4P4DfUKaUWeBGJzGWlCwcs9TjRSpPkxJDxoXfkXd+Jc8QhBM9t9U8JxfzzdyccIGxNr2xNy8/AA7rilSi/Z+6MUMlBw9qltFFqzKgkMMuEieK7RA4aJ2jtznyB8NI/gZFDm/TjN3B6trtHI66h24WMUlCgOX7KiAU1hWcOcc8Fkh1/zUkgqGWn/lasovUuFF+DnSOTvpRF5pmX+rH8atbOb9Az+iPexYJqr5D8of8IgupxKp3BJ4BjuUacB0gNY2Gan93z9/mTuNP2ybTEuPKmnM4DLNqdtFgF4MFsK7oGwZ43e8wasO5+k9F0GXi4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9118a4f4-6512-4159-2065-08dde83086b1
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2025 01:48:47.4005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f8PRFPREEgHWzSn1Phou4fQVg7FL652I7GF4pw9qqQg5o/jEW9PPYjd2d8m9XChsQUPOIW0QcByouBSPjhVwKSlbrYG5qDClngHrY6vVqoI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4557
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-31_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=779 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508310018
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzNCBTYWx0ZWRfX2QYGa6/79yZ4
 KxOcKKlePZd8hsWE36gh3e4iO+dOm48Z2yXnE4VGwiOTqo09BnhcKT8CInt4YvsNmXousi7PAX2
 3csXT8Pxc9evq1vQTcHQ7PGaZy4RSefFgf46SZCaVhoDMRlb/zNefa9wzCOInZKvlWERTJy9nls
 zHIfyzoqZhhvROF2vcRHMwehE9nMbrp0p+vVDz4vWrskbj6bGKTT88aGIG/l1ArzUvKOpc/js9p
 wu59x6hTlYctaw6TymHMf32LitXkK6eny7O6D78Yt4POHKnzKLvaOFLGLDTjkmgIoBRzS42KYqa
 XndMJhoht0mlu3m8UntN/0LaETGbVAjAS3s47GP1XheOX/WsVf7sekHynvTeXRVYkfgBB3Tjtni
 s6EMGKvc
X-Authority-Analysis: v=2.4 cv=X/9SKHTe c=1 sm=1 tr=0 ts=68b3aa02 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: qCCphcyAz4Yf1JPFNqLC5yw0PL6cekWy
X-Proofpoint-GUID: qCCphcyAz4Yf1JPFNqLC5yw0PL6cekWy


Thorsten,

> Use secs_to_jiffies() instead of msecs_to_jiffies() and avoid scaling
> 'ratov_j' to milliseconds.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
