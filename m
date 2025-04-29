Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83A01953A9
	for <linux-scsi@vger.kernel.org>; Tue, 29 Apr 2025 01:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745891118; cv=fail; b=dBjOYzFHSNuo9nLBUR4BYpYhZpyQ+KdB1SdACWwM4YGHDcBZM5lghENhSJk8/ngneNjh7+7DJh7LlLk7RPSdpGszpQ5eN0rfJg92ryOUZnlGc1Bp9F+yPT+vNK9l8EKZz7AljBbdekhYX5JnyO7GWVeuWTu6ED6DvhvcgsBN0f4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745891118; c=relaxed/simple;
	bh=AfEzDWmq7IgvmX1Gw9ZOylIACF87p+zlotCxW9byuS8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=TTwDphCMo3Mq17/bVa8kHSA6O08P32JkYg4NkCctZl1Op6XCNpM1CuR9xvtUjwIS4gdZs1h4f353nwNF/oPLo+8Dz+lzg1QRHb8laFhUvX6mtl5+q/RHu1kJrIv/lsdE2D7rvcbP4vUlvxWzlQI0DZsqS2bdF4nnL2TNSZ0r8WA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=W5i3oxTi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GddFmh98; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W5i3oxTi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GddFmh98"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53T1g07Y007649;
	Tue, 29 Apr 2025 01:45:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=KGdU2CvT2dpw0XB+2f
	ABv25zAlOEBe3PT8eMSA0qMDQ=; b=W5i3oxTiFLnmIDjXm65KYiCFtZMgNqBHvX
	6gXTpLBRrOxLTImhcCv1uwOKCEmG2uYEd95/7e+AzL23MY1Fa+gXV1LKtnDC5bWI
	tMA09HEyPlqYhf8jM3KYgnvdYiaV+gszF2yLFgLBB79Y+Xegh0ebnzbzXHevbCiM
	VmbHVjvN92Pibpr/fLvmDzF4KSHs9KpjgEdCP9t3l6feREDAl5Hbf3um64I4ft+E
	ZByfLU0FE5wFKhPK5eshHVRT6TPLpG/wAQVSVpTYpHmYbXrU0/XIscodwtzNum5o
	60PFdAOQh1zzjW7v/5JDfp0qO8hJ6f0BAA3ge8Ir54JOL6isLYng==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46amre0127-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 01:45:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53SNs6lh033456;
	Tue, 29 Apr 2025 01:45:06 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2171.outbound.protection.outlook.com [104.47.73.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 468nx96x6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 01:45:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HZK8fpEiwydGPhjlDFxFD6fr7YZCV497LSGfpiAFKMqyyEMzcLYW8b2ZRs0bIl/Zt35JSvdOVtv6Bres2qB/5ovKdzlph0sJnwJ9ehGGo8sIfqb9VorHBQFzFid083ZrcvcnilWEOyo0qCJl44VT6hZBqH1N2+OShpAgdcBAFl84NpenYNoF7f0cR0ac3UMhlIu/ADHQNfj2hAwBGBLtkSxQytTC48U4fpNxIT7tPz01aEymCTZK+yP63yovFJGa3m3sDMsbcUjgInZZZrOl9kgUUzQmAfH2XFQ8diMscQg11aEr+XkWXEwUDJyViIDAZKmKSo2Ve9faeZYa0LGV0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KGdU2CvT2dpw0XB+2fABv25zAlOEBe3PT8eMSA0qMDQ=;
 b=JVD+9X56CBZPYm+mY3BwoakABawCYEnbpqwTMrJezoz4XI7z8Fz5hHQEXNi/ELpA1KkWikrBqN2SJhGHFoEl0RNT5JxP+zV66TnGwwB2f+w7CG/gLucTYKJ8AS4rJKd2oNLgCdpMuGIOOdKkhY/LwWb8ZMLYzGcMrEXWhhOIdsa5o5w+SCxZRH0UbCBi/zGvoFHzNvyj3nQURRnjv958Pc7XdMlsgIBY/Wdsb6hcTcjAcoakW9HYrbrBhnGD1v4OyL98huMgvlloObYaT/hRNLsTPhk3MLYjIelnUyc5Wqn7VNMWJxkuNM6nhYQBVusOnA+a7lSpEdFWzlhKfy7FpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KGdU2CvT2dpw0XB+2fABv25zAlOEBe3PT8eMSA0qMDQ=;
 b=GddFmh98Ba0/2q2jiVEGzgJjTLXd6jd3psoijI2pMOzE08wWfKKIgEqP10pA6AfueHfdz48jAEryBrG5PHB6kGQjJiZFNOjhHyBIhte6hvvNM15XWLSiwPZBl3ad2yAUIHj9SQrmpf/37OpKMgr00amceoQDX+pbmzrxYK/XgwA=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 CH2PR10MB4213.namprd10.prod.outlook.com (2603:10b6:610:7f::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8655.36; Tue, 29 Apr 2025 01:45:02 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680%5]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 01:45:02 +0000
To: Don Brace <don.brace@microchip.com>
Cc: <scott.teel@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <jeremy.reeves@microchip.com>,
        <hch@infradead.org>, <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <cameron.cumberland@suse.com>,
        Yi Zhang
 <yi.zhang@redhat.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/5] smartpqi updates
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250423183229.538572-1-don.brace@microchip.com> (Don Brace's
	message of "Wed, 23 Apr 2025 13:32:24 -0500")
Organization: Oracle Corporation
Message-ID: <yq15xin3fmy.fsf@ca-mkp.ca.oracle.com>
References: <20250423183229.538572-1-don.brace@microchip.com>
Date: Mon, 28 Apr 2025 21:45:00 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0257.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::22) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|CH2PR10MB4213:EE_
X-MS-Office365-Filtering-Correlation-Id: 61120bc4-bb91-4058-38f4-08dd86bf752a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VqD5hr/ioc5C3eVdXqNsWjhYqwpKsEkOdZMKCXdhHIT6SJyI51NXYT0fuAwb?=
 =?us-ascii?Q?aKWV2EWQ0AJlRwvygIkaKjG1g03JMhxxdjY1a8CKmx7h0lVs2qUIIc1D+43t?=
 =?us-ascii?Q?Z+2kTPVOhsOB6W9HvikwPmrvPx08P0qakQ4JEjMtpC5XR6ejTayXW1COtoUQ?=
 =?us-ascii?Q?gpj5/Uc6z2jYt2P1DwtpPxxUyNS1ZQQxVF5Jhj0vDyp3W4ecywynZseIz7l4?=
 =?us-ascii?Q?NCcZ1N2Ibgs4e19Rux4OldHgnFliTcS+Z5yb/OTzbAHMtRDQJ/NzE6LUTAdX?=
 =?us-ascii?Q?9+MV3zIm68cuF06GTbMObk4TmEPND7xnUhSVdcwL2Q/2qGtXAqvNqPsRlogI?=
 =?us-ascii?Q?bQkshA1ZEMBHmD08Za7N0Y0ofwQG8O1FzgIFZpinOA+wV0cIJql9NqVVU2Fr?=
 =?us-ascii?Q?/AL3JpjcQM0VcdvTOxOZP7h7cjc5lOV4L9IRXnLo3B7cfA+quGKdGPEA1EJr?=
 =?us-ascii?Q?eWvKKY6b0iWlgCwrNi9h7fG8SKePBnQUIDiZLTWC37Yz23dKCGo7uyy9n7We?=
 =?us-ascii?Q?IaQyrDJDCiN4axDS5DG2cY9NeqvD11vNRnU1WpbJZzkmaexrrR2iaaFBsk38?=
 =?us-ascii?Q?1txlZ0uD4XpG1z/k+4mnsXrXCakU5YG3im/VfOdg3ozHl5qEKTGW2mQdVtD9?=
 =?us-ascii?Q?w2uteZFiGKU3mph9Mgkx9AbqDlmiR1srDqEwzT1+hgoC0Lo0oWzkgVdjkX/n?=
 =?us-ascii?Q?oxYxKsWuhJh+yrV9abKcLm3APOIBSx8I5v5hNQQiqPcKRHOnt2beWii0wPng?=
 =?us-ascii?Q?DXMG+c4NYEex50YOmXBDg93rDI7fGCnLwtRf0rm5CseE53qbC5AWQgnyUtLt?=
 =?us-ascii?Q?q6Y9Lfoa4PnvgwbTUzon+d2x1ACPcIQs3oxJz+SqvuHOpn46CnePSXEf8yMq?=
 =?us-ascii?Q?CYH4vTTsrdIkbMOWw6uEfbnINllvW+Y35DPR7aUrHf5fGW4ZQ4m1bEvXpIiL?=
 =?us-ascii?Q?aj2C6medlCRuemPtRtiEra483RRQyo29cezxi9YGbidV2qaUu3cXJhBdH4Yb?=
 =?us-ascii?Q?nxodgfrYBLUetKWe/dX4eyQayHCaJmY/NcUvZ6vXT7lLc8lQseCvOUb3CHIR?=
 =?us-ascii?Q?fOUY7uUkIiuJBXFr7IjbzYaJILGRMfcyIn2BBJf4oIis19y7wvVZUPfS2ST+?=
 =?us-ascii?Q?jr/APzzIPYKg3XOt7TazxSw58YU0hE3IzE0oEy6YiR5Dh2c84FC8xrntsByC?=
 =?us-ascii?Q?J+q37sGoAcVD7T+vGpdb3X6zIdJPiqcsThM/h4EwB4/IK9RNvlXduujWaDT7?=
 =?us-ascii?Q?ah2JWGVEF1x1t5DOCm30Q5ionfvYxb2GuTfI8O7e/jEIWylpDNBCZq7ID4Ag?=
 =?us-ascii?Q?5f3SG/gDeVCJAgP4xL8rrFUVQdnCySfSW8RrgUw3YB5HW9KBOCeiZGVuyGzc?=
 =?us-ascii?Q?EqSDnNu8h8gxw7ZhN9eXzTJCa+1Sr9P8qvQIvdDNRoW8tvHd/Cc2+gVxill1?=
 =?us-ascii?Q?t9JzFxLjEoU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1khadIxOiYwg8n/Vfqjy5U72Q9nikFxBVNq0zhvbKAA0n+NYmkxJ1adgj9oT?=
 =?us-ascii?Q?82x22PWGGdhL4OMwpcflK4UftFHEFzKMy6Evt0qOCAFZJLM2UlUSRvisDmRe?=
 =?us-ascii?Q?cgqQIFY0FmVj1KBczLNEJ1A7a0hJ+aRT815EBnXtUE9cmxAaZFa8o+yvY1iM?=
 =?us-ascii?Q?CTCLF3NcI06fXafKK/bhmiZTiYnHvix1/ULVybt9uscKJ+R38bGLUknPWSSM?=
 =?us-ascii?Q?eaD0S6xSjM96esoitFgDca43IBxbRYgXMqg19BH1rfKf7TiEApMAUR94ychp?=
 =?us-ascii?Q?x/Jz7T/yeiMd0DXffdmTOcBWZai/dA/m02hogsxWXQwasonL2D3JtBX31BRf?=
 =?us-ascii?Q?PXTF+sk+drYh/CTycG5I2qc5y1SjfI8jQu3i9mNmR/M7AVYX/p1kmntGAgfy?=
 =?us-ascii?Q?PytkvFhmaXtgmoRuRrDV/0aRqLLU/npY+WvVzfnjWyIv3kcGKgezcMaD16Ww?=
 =?us-ascii?Q?TWcKWzEFJJ9CB2gFmlMiJJAL4Xopm/buaP+2xMvYBYnL3ma+yVTSDuJTHs/V?=
 =?us-ascii?Q?AzHqRD8VEqvLX2V+GDoh2UrfmTip+FBAABk3Rk9G3h5+v1yBxXDSDd1ZfvB4?=
 =?us-ascii?Q?4zym0urTw+zXfaujPDfsvwQDJSRVxpbHAXb6Zhwfv4e1mO3m1QGl8gfz0R4R?=
 =?us-ascii?Q?JYcIK74sSCen45zqT3T2eIa+21oRmFKA7iURZXEM3cYnIPiY/nHLC9OFZECe?=
 =?us-ascii?Q?V9KO/0hl1rmqId7O91iXFhaSuS3t3b8QNyL1g96mjiGDjWGDyiIFBzYhvAeu?=
 =?us-ascii?Q?grWPoM0Vazzn2Pj1OKLXwQYEaRHGO6Igkf1siBBzzL4vjB+pJTifb4NqfxRt?=
 =?us-ascii?Q?YPkuqAIuvkaJz7FfnDH4f48n4/T2llA5yuYV0ApepnCM2CQuQ6O+3V3Owllz?=
 =?us-ascii?Q?lSeSJmdtTs5qv4n8N0ULEQ136ONkFOkI+65v9DKjR6ZGTnnKlt/E3zp81Gz8?=
 =?us-ascii?Q?x+cl3Vp0a+7VCXs2alOtkLlETEf/JQ7lnoZnY2GZlR2KFuwFMk38DZydAdlA?=
 =?us-ascii?Q?73OA4YaFsxHz1AXWxSXQ0R4wummwbDvkxkFQid//To/8rvFxso6LfsDWo6ac?=
 =?us-ascii?Q?8Ua72UmDZ79NajJgk6XE5as4XG6rZWd9Q5XdRSTMoK10iqAwzmGQ/JW89Vwu?=
 =?us-ascii?Q?GqIWmniBEKnSjTGcrcrOZjpY2C3w6K9UQb4WQzdovSn2G9IDJAIcKvkCVOH7?=
 =?us-ascii?Q?hcI9QN73iemHq9BL7sVWLvzwnQR1OokTL+FCN561W0auxLMTNFTPH1En0Gt3?=
 =?us-ascii?Q?YzW1HKOJzqOYu5rCK1cWMo/jxWnppc3+JhVc7GEPDVw7QMA1IVfmO5tmjbkn?=
 =?us-ascii?Q?ZJjisnMA5qkE00xhkD61IZQoo14kEneAhK6nl5fEOp8W7AYAYgAMtb02UxJG?=
 =?us-ascii?Q?TzdZxuoSHF5iDSALsmRNRio9Mj2rv/Wr787xlOP+QXkQpUZNMNft+9VlMGqy?=
 =?us-ascii?Q?XYbRQa93mmIZ8oWOGH1eQwS01gHj/0jlsMInQ27Mq99wiz6l2Jg8fIMk72kq?=
 =?us-ascii?Q?creWWeeFKmgCL5ipw6KsMN35LvsMmb8ZHi7uTivHtH5UE4eOF0JlFIFZNIBc?=
 =?us-ascii?Q?xbxGCj5OI+NfHfgWRledc9J9YhFYy0SsqYnzCEV0+MLg/91dQotZLnLM06a2?=
 =?us-ascii?Q?fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ntY/woeImBpWBNsPFm0T1xsWe4cYqONPjbD+0mhvZG8LTJhUFzNrfVW771DmcJ868/Fo6kiwKphAXrd8XjEXm93NATOpfAD5IZ2PlpL6WQ4w6Ur80BYlT+BsatwLBYeADryNmeOL/QuHa/2RC6JQ22qO/Oi5dBvv1Z9XMm2onYF+YNTCe/7CIZyoRhC7JJifW3og2tx7GtWHTG0PM1hMyaF5eEi4gSF7ctHHWiO7GVJyWymqhFq6Cw6JOF4SvTiybfgzF/zqdWNdbsxwhFub2O/4Hhz8sBOX9KTBP9QqC4CGA5QpQ+wNt+hEZTGsFNMIo4+xtnN/3XFdRt1QXt+dm4iKBuNPFPj6/lGN3GjO98s4PAYhfCc7zTuhYiMSNB/E8F6IhTPywQBimzS3NA3B/bZWJ1wQ+5QdYj9jDL5MdpNxZb6xr7oQgAnXQ+H8pLyXMhzuV2tVDkcp4p5WuRKYP94QRQy3S0m1aVpLf0w+RgRFEzuiXeiPeVDGbgjMoxXnEJNg9XDlTuyFj7jMmLaLyEhrMVYOKMQ9OUZMYSqER2riLWD9ETF6f3eaQ3DZYG4HTG/RD9SP4JJsWHFSWGodAmqgwthoKsypl6UkNgcur9c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61120bc4-bb91-4058-38f4-08dd86bf752a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 01:45:02.6146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U4/sYiQxgYHilXhfdZYCnfrTdljvM9850dHEAsd7OOraGK5b0CV/DLfyfBaKztID7JQQfL/L6Udc2uQ8BJ7sTQ0lhvURzgjZ95gc87HlmAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_01,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=825 adultscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2504290011
X-Authority-Analysis: v=2.4 cv=d4/1yQjE c=1 sm=1 tr=0 ts=68102f22 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=XR8D0OoHHMoA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=5l6GhO9zH3y6Mqvy608A:9
X-Proofpoint-GUID: 9vdexUxyCwU5w8gyab6fPDgOxgoTL6oc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDAxMSBTYWx0ZWRfX6Qars+9sxg92 lE5/fenUBaOGmem2HOOnl0rQuQa5ZLi6VrujuG8s3EnOAjWBBNYAE/Ko6APaGNibVpQttaZaA6n /B01h/mkUmczhLpsf3sSPhRguHqHOEYjpXznxzIAtB2JhtclYo/ryhO0PlYmfz3PwFinA+pEk41
 qTEvrhrUDjdnNfF+p+kwb62AiR6zdbgunPCwMvbufaQX+/EW7NXE1NI5rGzfxHUoZ0YdGvb7TrE bSm8R53vINQMAAvGtHB/6pL7tCRP3LuzMOrR1qL3BbUo15Gt3lPzChcQQH7Cje7IyGDUVYpvGtb s9g4WlUUiDjLzqLhgFQQX4P6SVg4veoW5tV8Qdz5IT4i30MPyjVY8Ru/zReuIBUQdqquOGjIsG4 b1+X9DFO
X-Proofpoint-ORIG-GUID: 9vdexUxyCwU5w8gyab6fPDgOxgoTL6oc


Don,

> These patches are based on Martin Petersen's 6.16/scsi-queue tree
>   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>   6.16/scsi-queue

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
