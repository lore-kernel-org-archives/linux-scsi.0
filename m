Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C37F30648C
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 03:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763610173; cv=fail; b=IQtcaJ5L2NqKAybFmRFoimj7mAGmRVt+EMpK240Kh/CL5poqaEiTkW2ROXzOP1WpsM2VOaTtUhMwutSxQYnm0i91lqsnjeB6z1h6xSgeeuOmV09TbHob6X9bcZSJcQG4FNUtjBwouxUAxD5rPyyLjgL99nHQ3JCM5lkpo0iaHjA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763610173; c=relaxed/simple;
	bh=JoyJeD4CIFrMpJxvRE1+rR12EUYWntBNew4BktgeBBs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=d8aCxPovGNatc5Bl39UeefasnA+PN3cxq0cs3oJSpRnexikMEUxCCD3Qel8o5JthvqT5fLom0cCjZAAH37zwwKR7H1GIxi6MiT7CDiwpnwZAUxQ280DEu3fIlk5BUzhl07jrTOnbt2dh1Xj8l6tMXuustHrG5xvbJVVfwCyjuI0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fEJZzz2O; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yeLxzokA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fEJZzz2O";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yeLxzokA"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1NOGh016558;
	Thu, 20 Nov 2025 03:42:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dehPOPY/E6u5KULTlE
	uuBveUm0mZ9UfYQ3ChUc081cw=; b=fEJZzz2OxEytTF3u2TMhdcs7caKjfDmhIq
	dZnzFtzhI2yISCeMzcIBk6nXvX2bWlNyQRbrZJThbozuILAhvCiXv7Il6xkB09GM
	c0sBVZ+ipEHppYDhKqgJ2RedUyTHhc8ss0hRW0+wi6VOr2DD395CuU67KXq32tdO
	BxqKC/LUhlzD/ufMZ5sx6+2G02Gp3M7h8lSCmahuzomnEDT3EevXTGlPgLytzv25
	TrObU5K0PoRDuo9mtafgBV1A46IkEJJslmAZicLkHF03HhGq0QE1DDp7uFJUZS/7
	L9GIUhDxZ0wqeAiJo+YidS0pKv8TRmPsFXqPk1L/yrxNzocCDKEw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbc07rb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 03:42:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK0VObL039878;
	Thu, 20 Nov 2025 03:42:36 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012051.outbound.protection.outlook.com [52.101.43.51])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefynt6pa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 03:42:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tLlk+punrEoDf2ZvBlybqA8ag7k562wUPKDg7XXD1nZudxgbGYTAb/Kk0dUg3ozewW2vqaACVdFbbrDKkMvRPHh5S0qSxGj9qvvS4wOH4nmBsmMkS9pxf3KLoUFq65HHr15pZCEuxd5olpYrXVMdJ0p94LkyeYDM4Uq+MaoAH2Nuv9ZG2Xbmr2ItwY/myZLo2B4Ar1828Myh4HjSej+1N43owUg8Qo2bqctj+LE7CUUbx6repv714BmJ8c7uT3XD5GH9NULCFYc0UgqfL8a8Q/kEW7ajL0VONnNyJ5A8Vx6BgoEQdZLM1OH4omwYmgrEVbMq8loQRZsjIjK8gwkrfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dehPOPY/E6u5KULTlEuuBveUm0mZ9UfYQ3ChUc081cw=;
 b=tH41nvSEiOF9sC2ZEXT7nYgzUtLL0yvqshWbTeEiQVtjIBQuBno//+TOm/FBcNWir61YwfQ1VldmC4T/43wbiW27LGJFX1h6XaA3aq8E5UqLvx+O+0ty143SoFZ7Hk+UD1bfsa5uYG8ZGCwABeF/5gKPoLEQVx0uKTvkjI7t3tYRDBOhSispPkFGEjbhtdfGyhT6nOOSJEcBVyImGohjkmK1r/1Xc0Lyhs66/lAS9kiXFEgdt2Mps4Mp1CnS4us4gglwcZrgmJdotbFTQn6RPN6000SF6a2zi8wzOzbYVtvwHtdZZxl+w1fWfgh6BkuEsrsIJAfGftrD9QdahMzwDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dehPOPY/E6u5KULTlEuuBveUm0mZ9UfYQ3ChUc081cw=;
 b=yeLxzokAuN6gRpQfllHHJzadJtLplMo5DONW13wBxiNngrgyQJn1TUg8k/GB3BBPa6+qmfaHM5tTZWrZNnaiT2zOJCiOwXZRq+SMsie4iQKfMFLYkKWaZibMauXOjvsGWKM0BOVvosp3C1QyBUtrQErawCcStNhGM1Hsh5WH1NE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA4PR10MB8633.namprd10.prod.outlook.com (2603:10b6:208:56c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 03:42:33 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 03:42:33 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: scsi_debug: Support injecting unaligned write errors
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251113174151.1095574-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Thu, 13 Nov 2025 09:41:51 -0800")
Organization: Oracle Corporation
Message-ID: <yq1qztt8j4v.fsf@ca-mkp.ca.oracle.com>
References: <20251113174151.1095574-1-bvanassche@acm.org>
Date: Wed, 19 Nov 2025 22:42:31 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0070.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:2::42) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA4PR10MB8633:EE_
X-MS-Office365-Filtering-Correlation-Id: b8f8403c-8057-4693-9b83-08de27e6d6fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Vmk8rXYwicQYow12xIPaaErzZEpIkuU2TXV+XDezfjs87yRB12WtVOOT6+Y6?=
 =?us-ascii?Q?rHCst5P718aCpQH+I+CqvcgMCyzTBOiEeMQLsXLuaDKdamIZmLt8VoqebBRS?=
 =?us-ascii?Q?/Grmby4XQXqpKsFlUT8WazbcEVW2pHkA8MLZNn7Uz6TLXaq0EOa4R3Y4/lN1?=
 =?us-ascii?Q?eRsccn5j8lj1P1M7ovcTDS0iqDt9PddisnoZzqRIFAKjby3iNbp9Nw6kGJ7+?=
 =?us-ascii?Q?V1pqC1ImGEK9eZqNeMhhti3SBL/heZJhvXIiJz49YH5YOPrgQ+2e699csVCR?=
 =?us-ascii?Q?a6wWnOsOmFHMshwQUa1cacQjn9R8lLdn0kmPOR0K2VVMz/3cVx2/dKaTwttK?=
 =?us-ascii?Q?BpMgaJ4c2jFrnxyU397PxQNCi8+uMIbw2oJkebmuht3d2uY46ymCumqu5W1m?=
 =?us-ascii?Q?pyePKr8xrFoacI6PVFIplOxv4hBbZyzFrvRL2MQgagHZreS40PQfOxDAamzk?=
 =?us-ascii?Q?SMlefFAblOZs0ZrvWe4incH+OWkWpwMJQwfubht/CQDeABgi0zFDO+5lpNKB?=
 =?us-ascii?Q?pY/yV7jlPEwFqHUKYyATg7t21XV3fRstoFNLc1WKMqYTC25v3XCl6jx0V98k?=
 =?us-ascii?Q?Sj/nD94L//f1QCtkzA3D0Sqwx2rGQXn4Im7b81cYZTZwIjd9O/jcskj3HSv0?=
 =?us-ascii?Q?DtHELM5jIWFAYtIomDKbGnZjZsyJ2/heNE2NagCQSsfGVL2eGLES4QCMs+WT?=
 =?us-ascii?Q?56k3ea7RToPFuBHDe/z9Yp1iOQvxrPVtiH5N22QD3WVr7Vhce4O8fmRXzV7Q?=
 =?us-ascii?Q?MJqXhGznQyMV3cwjK6oYRJMqIOS8Hl66ox73Y8UBg1qSjqzdp+OugvJevxg0?=
 =?us-ascii?Q?T3HAeh933BahX5S/KfJBWUpAG94Kg9F41OgfE5RBFypxxO5tyqTBmLw6OG+e?=
 =?us-ascii?Q?osU2i0ubT5nHu8SnLomNrqDDWOOgwqctALExombz66kYOqAD+/RlQwoPEM7c?=
 =?us-ascii?Q?RDu3I3ieA+J7JHBaxlDTETzRmCISngqltjwj6tR1gT+NvE500fVooKIlY/cc?=
 =?us-ascii?Q?KygZauCzKvyEk7zZ3vWzWI2dptFMV9YrjYGwLpC0Oo6bgRP0DN3IYX9+V4ug?=
 =?us-ascii?Q?r23gH3oUxetmOpYxzGUrTJKQKCVAXwAEgdX1WHhfUM2FANHrt8QpuNkgtflC?=
 =?us-ascii?Q?Ahm1W61WqbkkkRJWIbFPA6TiyBbvPof65mZN7I9iKdNCLRAZbmYIaUufYMWu?=
 =?us-ascii?Q?G6kJ5+9elO29WvjiQZBQyt4n4IBd2ah4V5b3XoiMhM6Yax0MvBa/0ztrmCvI?=
 =?us-ascii?Q?HGlhvp6t3GdYCmq0JazfFq+pfpvPbRCh1RZSAPCUARQCnhDvAewcjGiQ0W5M?=
 =?us-ascii?Q?S0HduAu386vUbZZ+7NVSd4eTtsCeGEwBHHgeifXDTKNiINjInS3mZlmJoGv7?=
 =?us-ascii?Q?DKb/jSq+9V3lOXkyBPUC1lDEoAlleNS/FNWDeiINYQ/8E2BaXc8Vgl0TXMbl?=
 =?us-ascii?Q?lwkIGjzZ9hxnfzIwIjzAscLJe9Whw72t?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hrT0kK1Zj/xlIj6ubYH8z+4AKuUtehxadbjeFswBvaXOfPZrYdLEbL/m2wIp?=
 =?us-ascii?Q?LzEla9wiaeoiBz83nUqLA3GGE+ZhlXXPYd1rQhOMrztnwa8Viy7yES6lEetC?=
 =?us-ascii?Q?NPxhWzWISvdSrxbP+DQIoDuJhBQl6un5ntMbC7nEeq2thr5O3lQ8wvwksKw7?=
 =?us-ascii?Q?dwYFfcr8mZPNE9O4MuXf7M62h00pZzm4QbdUTFM2bVpGhYk2VLTV/cqBOObQ?=
 =?us-ascii?Q?Csr7cp2pWOAvdsVBGqYU6NuaNeKpgxLmnglDcxsH1FAZ5N3faRhWR060lQIW?=
 =?us-ascii?Q?n+/6WF02vJOJc5PCuy0Gl8i9Ew6TcFwXwlB+HECKOoqIgPNar1ssLL+FiVSE?=
 =?us-ascii?Q?7Cqgt+Vx/N7fJplCcLxIvTWge8akaw2F8etXMUD/wQaurJFlvMKPMjzjSELm?=
 =?us-ascii?Q?FggBJ+DhGH/IuL6gAgZYjNPEN9vwmfCZNcWQRFK7SSo4w+pAFsgYyh+mcZwS?=
 =?us-ascii?Q?rWAyahmPu0Heo/Lk/e4H2hSo7Z1dGOpTkv0vuDhkuglLENHNaC4Oq2C6ZXnM?=
 =?us-ascii?Q?0OQKsXdXfMDI5ScEmxWUfF6VWt6T1EGTNmYdjWmu1KdJMr80C+VfF3oBlTZN?=
 =?us-ascii?Q?7PeCoLUHLGFCSC3NeLfkEclDUqWGpAvLfFwnhv0yzdVDyK4T8CekH46+9g3w?=
 =?us-ascii?Q?AuBvNBusyGbwKmnIVUBpCCzPS3eGy5iON8C7Pu4tggF7mQgnXh2Pc8d/28bu?=
 =?us-ascii?Q?sxOzHJUCSyq1RbvEqG0OIXU+SYAI5lcMXOJx6eu6pRiTh2viuN8hbS7q22Hq?=
 =?us-ascii?Q?Ukaw7kixDMlhknAGNoIEu6/uhoM9xywBn10hqKgHiEFILhaQhFurTQS/Pzz8?=
 =?us-ascii?Q?ISFaWJH8KiKKQKdVa+NZvDf9Keu5bMaqr/Ylf+s0brVunIIeBTxbkrlb3vRy?=
 =?us-ascii?Q?Nq24e43/Zn8Ba3+zsghqwm7DNQaqTti1NjHLoVrCPyQYcrmdywp/4qdCjxuO?=
 =?us-ascii?Q?kQ6GSmh0kyux7aAvCbeVCpxyadBKw+E57JKJGGLNFsLU9AvmLXeR2yDa07Pc?=
 =?us-ascii?Q?JbQpXDLK3CnKukgQQX52+lmWmeQE4W868AD9aBIFIjy1T7tk5Yp/G9nM9rae?=
 =?us-ascii?Q?0FH5MlhxzHFmvvAVlVLaNHbS5UPIu+9xaAhvxFw9sth+R7yx8vnG9yBTm6/p?=
 =?us-ascii?Q?aw2QjJceRnoRbmoJ2uZFYUQlHdnf1Y8DUOGSLdFGXbDuCQ3Df2BRlYcHhIb4?=
 =?us-ascii?Q?xFavXoKJp9MFH2XSKTftdUIJ8oAHgmEouh/rNFvW6jCl0MAR68zth1aali42?=
 =?us-ascii?Q?eYxF8TL9OyV/O/P1N9+PyDihqeWqvgVGWBnriaSBIX6nSdVciBWpyI+UbdKO?=
 =?us-ascii?Q?GfGHYpKFUiY4a2c1pOxc1kX1Nd38RRDpBM5eMKO5iBAGdbsCpn3/qiSexLay?=
 =?us-ascii?Q?Rz/JfQDqJMbALxs+YD31g8z6C9fDg3pVWQWDNNU5cHqIQIr42Zb0FEp2mFA1?=
 =?us-ascii?Q?yZ7UJzHHTCSD5ixx8/qEfRd7jXzpJziWASYV8EDQt1J+fvSWnMKxZDNFOQg1?=
 =?us-ascii?Q?AalbF4fiCazM0IFw500CXC7auZuXMEOvGu6n6ZSurHeyau3+QSYw8AGGroxn?=
 =?us-ascii?Q?NHk0LZPXJ3J+8SM5+0G34215YcaNu8ggymRDVUluGcrq2WmV6AJUhZLxV+9I?=
 =?us-ascii?Q?LA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XHlDtf4SuRrDJEYZBwEQzKCEJUJi9BBLjFooedqOmDIexR4sWuE/fNOUGtvNp+worOkkVG0P6kYYb5udyGWqgBgaCBSsdT/nzKS2LhzSwO3NKItamzDdeDd477N8QH4krJCEUdgkXbF7y8Cau1f/683xwXmdVmlUlOl429KH8sQvpCWkKg8LQqfMufq8UWYJR2aTiet5lIYNJ3Vt8DfUVP8fnFsxQwUyyTD69/W/oVLcnE2ijD4SOuValiUvdAJqcF1Yths+JMHMn70I2KMNys4/Db8TMGxrs0stRovK8wbVIh3GAtLRV7q4Z1hK8JK3HqLfaxjmYYYz4Qdz696dBNWm2YxQKTybryPnjBPPjCYu2PIQs+YoUpnV/fUh38nzAKdvFGIO42/TpYjF+9/ZSBE/g9sTorjbj8qIlXU3OmejTV8tNukhP5nM6+S1ri9izv9iPprj5/qAI/FGMbMaAgxJNnmpbs89lmZWGi+9F8aRh3ih41e8k2nKzOwAic3qaegD6iGDKQDvOI4m91OO6vOY55XgqO9MF2raWzUZLVqBGZ1a+QrzKr/tpkNn7X6z+x4p+qYK0lrVV67VNqeQsPqfgxuslsFuzgectoacDPI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8f8403c-8057-4693-9b83-08de27e6d6fb
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 03:42:33.6953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 42kNXelVSs6k13lwPl1CmjhGmzqlPGvJ3D9pNWoga5ch2yMW3e5Ks/SZ9Q5vJQS8xPjXNx8/p4sQ3R1MaYaESgu19AUSt7Lp3HokeSG5OKw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8633
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=800 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200017
X-Proofpoint-GUID: GuVZktgRyK29RCanIdeC8gdevoK3Wxk3
X-Authority-Analysis: v=2.4 cv=JZyxbEKV c=1 sm=1 tr=0 ts=691e8e2d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9 cc=ntf
 awl=host:12099
X-Proofpoint-ORIG-GUID: GuVZktgRyK29RCanIdeC8gdevoK3Wxk3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX70E/Apukrhnf
 u7g3haOWeHrCwxWw3pqRATP0JO/ZWOU93Eri3vRNrYt75cNPmJ+Be08Wqld+DbvvtbNZbWY/MG9
 FsqrAnTpB+lUJJ7pw0GPCskmbTTLntj2E+kRxf4WkEULdyJAFvJof4isky8vyAHuuNKL2NPnZGo
 YfwwWj4zF4fJ3PeQQzVg/AnB3yXgRJQkS1hlvApkS5zntu/ou0Cjj9eN109aJLQbwHseS4QdBzV
 gqlWC4pkoN8qAkgptx7NeAO5KY/xKjg7Eqq0+hemlXvxq4CKuGV41ClT9bXLeImUx2SJO6m67k3
 6+SWmdiTPvxLn3Ec7KVpquON0M0JYKT45rAnlJcQZUHeYFrqCYvwkjGuLtSsu0xCYSopJOI3mpz
 fkZ0oU+6i5C9CnPGZ+33Qc3+d1GoWfI3eLJ6P+g9NYqQrXUkzMA=


Bart,

> Allow user space software, e.g. a blktests test, to inject unaligned
> write errors.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
