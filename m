Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BB41A700
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jan 2024 04:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gqdonHH+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tjEB2gYf"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40433sH7009776;
	Thu, 4 Jan 2024 04:11:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=jESuyd1T2I0lDqZcGZpEk+Sx33cyyvu38MxH5CijJ0Y=;
 b=gqdonHH+9dP7JlP52UGeuAqxYw6jS8gDh0CfYVD6PwsFnyhycYAqf0lttrGUOp7bb/df
 W09wjliEf44BuSxvROiJsvKmZQIOCa4veffUdQgMmyfs0VO3CkFCX1zzuYWWUtMhVPXN
 WyYrtpWYX8xnPGNdQjEY2SNuiHxIG0MyANmFKQguM8Z1A2rxGlz00xIqvy7a9P9NbwF4
 pOnD4e2Co7zspGujxgbhNY69nBod2oeqyZV4zxg2AOVYAeydVQZeNeqVf9mO8CP/BNdd
 bFSGS90NySGgUX0Vw2C64CC4vzRb0HXLreo/ICppxXgNZRyvjDQ3YTfTTwJXrP0GL4ID og== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vab3axa1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Jan 2024 04:11:09 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40440lTb027018;
	Thu, 4 Jan 2024 04:11:09 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vdn9a8hp8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Jan 2024 04:11:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjwpCxveOQ/V7KqBAOp0OsgGQaBlhKRWElZUGpWxBYaJDv7ydDUd56D96N9PbTRigoePfIVS2YPlk+W4GYzMZs3QZwyiB6QZVgb32dB72mdmnoLOO6uZa8+fvAVQxeAYdrApnVrO3CiwqrbiuPgeZa2biAWwH3BfYTgSx60FsEXs3Vgx7UxwPguY7pMwFUu/aQsIaqfT6foxkHaf+5kWMq0IrFxToBfr6efOUiMmKq0bj1oKSCWFHcQ0TFhFfR3airs4nmiDLoDizvDX2SWPJaXBy9VrXwp6nOJOtK+JQ2LXKgRimek7/EyXSubAgl2WI26tojOLS3FbhdhK/HbP1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jESuyd1T2I0lDqZcGZpEk+Sx33cyyvu38MxH5CijJ0Y=;
 b=kw/eG21fCG+QkmwfGhpm4Kzo3Lqm3ySjw9zTgzMHNt2blJCKuRqMvoehp/X6d6KIi46BUdh1HxuOjeG+Pmx6nFWJE353CKs/ubnFpCz9AqGeMGXwBtWIqeXIRDjlQcJnJnBFrOY+nLKcKVN3VZazrwiVsseVX4aRTEFXbdbUiQ1GChDCOTWJDZo4V3NrAirma10N0xAW5gs0yzGAXrDLwSdyOq7hcnSSZ5ERkB6ojPr/mCeqKdN/oZCY+X6I7hSDZnCj9MtnXvF0fOSN9G4aTSIcKVSptXzKsHCnU26k0+baee3mQmfSfy4uEhTBhbCJgdL7xOboIk9NgvBSV5jTxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jESuyd1T2I0lDqZcGZpEk+Sx33cyyvu38MxH5CijJ0Y=;
 b=tjEB2gYfVi7nYMrAZ61CER2Lyp/jH1vfddK66O1XmsQOEEFfZKu0XpSZK1Bi5ATpopWInf10p9s8D5PwYMdpkTj9EtQWlSTlq5O4FZSKgqD5+3FEo1JnSe1SjJ9EiBWB3g8P7iGJuk74UliG5zNJe10pBb0A55SVmn6PPRrcfwc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH3PR10MB6738.namprd10.prod.outlook.com (2603:10b6:610:149::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.14; Thu, 4 Jan
 2024 04:11:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972%4]) with mapi id 15.20.7159.015; Thu, 4 Jan 2024
 04:11:05 +0000
To: Don Brace <don.brace@microchip.com>
Cc: <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <jeremy.reeves@microchip.com>,
        <david.strahan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/3] smartpqi updates
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18r55agcb.fsf@ca-mkp.ca.oracle.com>
References: <20231219193653.277553-1-don.brace@microchip.com>
Date: Wed, 03 Jan 2024 23:11:04 -0500
In-Reply-To: <20231219193653.277553-1-don.brace@microchip.com> (Don Brace's
	message of "Tue, 19 Dec 2023 13:36:49 -0600")
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0046.namprd17.prod.outlook.com
 (2603:10b6:510:323::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH3PR10MB6738:EE_
X-MS-Office365-Filtering-Correlation-Id: 7014ae08-93d8-428d-6234-08dc0cdb2c1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Ia+QmI3LeOF9BBD99KAopFswt3B/QgpKW4Au+G+dVZHfgY4qxmVKAv6H0De2p4kxejeQT2y5UlSOYE1ZBW0JFcx//CsVkI6fcYmUbBS3/0V1gRN9A3ATb+YouhevkoKQPuqWntVrnO8Mqc6RA64CGZ4VAz+Y/zUOf2t44evNgvBqbFL+dgirxHV/HEzVBex3hmGzw8pi7pALT18NSVDIiqv5sd/1cYzuhliRGUK0TboiBeVnoidYSGTNhKMlLN/QXJpMi7x/csY9TGbb+B4K3Q9sFRT5gS00/L3sh5/kY04nS2clF617cluxMRWLVYJSY8xDXnkCjjcZs5u+jFxOwQJOpWAKovP05ZgOqTMLvDUAkEzQ54+8xEB7iW75R6z0mqS8aJ4o31c55r++kvei7EPQRBwUTx6RBGDSiWwFEqefr53oGBaOzSo2A/HctXHFLVhTj16ohnd0Zc+YCAIzdMsoIUahZ93n70mVdCKsBvFGCG+itldsHPbnFBnS5f4iOHbNZ3jJkptPrVobyH05vjrbXCRpNkv++41FN9KN7qqXc/q+Y4KfcQmf/fLKOkJC
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(376002)(366004)(346002)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(6506007)(6512007)(86362001)(36916002)(478600001)(26005)(54906003)(66946007)(83380400001)(66476007)(66556008)(6486002)(6916009)(316002)(4326008)(8936002)(8676002)(7416002)(2906002)(38100700002)(41300700001)(15650500001)(5660300002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?zWl64eLyvV6dGAyZGA8JmMkIFKzCic7qyqHcpYNIuzSSptjH4Rh0QVzlaYaJ?=
 =?us-ascii?Q?BqeJKaNGM2YDeSrg9BCv2XnSAtfUAs9HQ7OuMxHpMEqMT+GyEe9wz5POcJDH?=
 =?us-ascii?Q?PV2cTHzLlDYCu7ygmYF/O7qsvhoThl45+M/a/L0l7R74+N9chXrlQZISPnd/?=
 =?us-ascii?Q?3QeG4f4Z2SQnlE0wOwM1Xed0xHz0malx9jZ0p7kKQssJatO3DpQqLUIJtHSP?=
 =?us-ascii?Q?8d1FAb9ZsQJjDXAzTn9yzFnD9sUwOWFFEU/9sZRwOenMeWCvjDkEMAYb5Fzv?=
 =?us-ascii?Q?2k/xKeWr6fjNvGiV7rixOzU9FV4ihmI/muMW7ms/OmfjAJUhZqfXvULZCrnp?=
 =?us-ascii?Q?1Vhdvq1xAnRH2Q8clotkrpbEQVK2UvSzcJysDauVIfdtr/UWkr5aMHBxThPp?=
 =?us-ascii?Q?R49ayVZIBtYiLF+6cCN19pGtCiof6oB3hl/J3uIoWUlrvZU4PMBGv0y6z+zc?=
 =?us-ascii?Q?hwhzGujMgGiuFyC2LEmfDTZmoOY2vs4Pu47KS4iTTXItMcObn33d3E93cl22?=
 =?us-ascii?Q?R9MjPtIdyVd7zmK2a5Idgah2zGvAxaT6eSir75uqlNmtsw9Urg7i+KKCUopD?=
 =?us-ascii?Q?Pl6UVyEvgLRBxW8Zfwim4JSf/ZaoTkW1ZhS3lCfCZoP5dF8enmQO+g3HDI00?=
 =?us-ascii?Q?wYeh8643qsSoaOGlA7wN4TDNQ43EpiUMP2v3WAgRHCnejzTaXdpJ+hZSz87o?=
 =?us-ascii?Q?mRwRaXC3Q8EkPh4nOU1skFOA7GgvMowl6zvLOQK8n3TSfuH/3lcPyH8qVJoP?=
 =?us-ascii?Q?MBPkBzcMM83ONi9RkIaF9W8TP5D8bkPZberp0Kh52RFReFmG50RDH3LU6EKP?=
 =?us-ascii?Q?HAITwihGr9i5frRO6xaExj7m5wNUSqEXwhmeQxlxevtf4bGEUP5Cwiy12/Dv?=
 =?us-ascii?Q?cWSLPQZKg8pInSZp/Ww0ty7qFQfYECwD//x/OR2tS66uLg0Lu9mAo+XfPWBx?=
 =?us-ascii?Q?emmPT8BOZ8wwQ7Ff/4yVMKtAsm4FGt9tLqw6DbZP3zv25nABiWVVKW/OeFSV?=
 =?us-ascii?Q?Z8uP+lAL9EoP/JaD3UGvFXH7TZt4wrLywGFSBKcKOhP7ID74aHnFs3tRLBkt?=
 =?us-ascii?Q?absTyKJDnZKXvoKhKBb72qeiNeiF7W7zfrgRMJJVIeOvlI4q1TT3NmGLLPdv?=
 =?us-ascii?Q?sJf3zQYCCP2rpAXkMHCHqARLfh/0LHLvaXL4PXF3OyyrOwedG7Uw2McHHp2b?=
 =?us-ascii?Q?P/jNnk6BjtvYcbrhsBy0/aS44LBPEcDQsW2wMCD78Qvi9b06QcDm1PA0+uVY?=
 =?us-ascii?Q?Qw8A7xYdWNaGOE0ZufJkmuwDbcG1vJd43m1Wh3YK3MA0rqW4IwXjgWaTLjsZ?=
 =?us-ascii?Q?fFeFmgg5Rr1HsAO+nMu9AvGgvqvAwfZA9gjK97oKl3WsZl7HnZUk0lVkeZer?=
 =?us-ascii?Q?j8rlzrl4l1ZZaE/Fc7ubbrd8pnzegIFabkZDl7C2TaQXtfFQHCuYLkYJ7F9v?=
 =?us-ascii?Q?AlKW2pgVadWxItR2TPJn86V7c6wlQpaeTX3chq7WkxOb4IEZViS1vhYeybk4?=
 =?us-ascii?Q?ERTwRScNh/Mi9wqiIdIMOhNGOykWI7ur0354X9LUSN31RoLCx+ED/KCCYUlC?=
 =?us-ascii?Q?h2QEf5zQm8OdIxevHNOmrnzxFKXUI4G5Hrnalb/GhrBxlrA9cPBqZOiD/K3R?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	txMxdr+FHaoaM2sJRADdSHQFX3+6NaUQNBlBjSOZEubwRKx0PVxmj9ltepE4YRZOpPDU21TN0JhlBrpBEO+UI8ilsEkPFCnNazC8YvuevP3qnCNrGBvK0EDdFNAj3Yr+qfxRn1qqj01qRl546ysZD6mQfqcEuoE/yOLCxIHTCH9TXxn9d1mxsTqv+ogHnkz2fCQJxZXhlfHkX2URdoj9o4/dTWJWwUmJCwBy8n6G7uAoVdWHKyHrvGdEgvuwxr4sHP+x+3yhYIt5fTBS8T3QF39QZgC0FbZpioYDvVJ7XeNf6kik9UYf+ZrWk8r0qY+fTf0BvsfakKS+XrU/Pq3XpILTfSNzEPOTR0ycISVYwAw1Hk+HEN14asjPhcn03oc+p+MijBArMQHq8NVQGq+fIhrTMfUYyPT6n4YZ0hWW1rdZPVhWh4tWn5n3wZ/lsnU4s727AOk7r2qCz+pDbge5bT1JhrT8VuMThQi9O4k0pXjEnNaFLkP8WzUqeNeKoN6YZO2I5gCqxKjVUVHxpRgbnZEIZGqE5Aq3/U+OaUbjMUWhClRvjiWKc/cV+8chmVQ93+GIxWqoXOGc/aH7xExmDBRNlhYA1aQlfU+7YECOAUs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7014ae08-93d8-428d-6234-08dc0cdb2c1d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2024 04:11:05.8316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hPbSKY+0Nc8a+UTSi3C7Wo6opT83wddlak5kq7GwbutS1HvJmgAoOSdzBCmhHooWxOoviXIg4mLlJbNvPn1EH9cDQdHH8Gg91KknXbG8mHo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6738
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-03_10,2024-01-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=790 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401040025
X-Proofpoint-GUID: 5d5v5QDRUQlxO88fQHoE6la4ImdF1j0H
X-Proofpoint-ORIG-GUID: 5d5v5QDRUQlxO88fQHoE6la4ImdF1j0H


Don,

> The only functional change to smartpqi is correction of a race
> condition during a scan/rescan operation. The device->rescan flag can
> be updated by multiple threads causing issues.

Applied to 6.8/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
