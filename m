Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4B92512F9
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 15:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693831; cv=fail; b=ZlB4vd/rVRYfXC+khT5h9XIwCJYcprp7Rh/SbE+sXa7j0MHaVuyY/20E+/nAuBGnHQW0oTzF7g8aSG6EwFWIjmz+NYe1sZWWo7l1qhhYL+XM51i5EYaJ2IGyr3vSgh9CfxdSbM9ir7qOPksHoao+nq+WXnITUChQm1neGMnJ5Ss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693831; c=relaxed/simple;
	bh=DVL6/qMWJpjPmklGdQARCAAPEx+f11UP2YQKCUwgxek=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=u+YbqE5V1p4SPCQWRa238iQCcI1vPKIm5rQFyOUfrqifVpPkCwJ/mxZld/p0rVNA28XSESMe7H6r79DakrxqGMYbSsToMXHpOFb3QZD3pU+oAO0Xb/wPJNImJB9YlLDLQQB0us416dVzXplESfXvDZYrREvcqSCwmfgQvcTMCXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gg+7Kfit; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=x5aocE7E; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gg+7Kfit";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="x5aocE7E"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 533BHcUP013091;
	Thu, 3 Apr 2025 15:23:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=Ei1NMaTijFFzRPXmNq
	soZpjwe2+c3YfwJJf3ZihczAc=; b=gg+7KfitwOwQUr4u1c9t0uYIPJMvWkaupT
	4E/oCUFSqdEm0eqyvH1koK4NxpPca3/YYVKVajEbovXmjQSDXX91h8EN+6MiI/8P
	CdGV3v3m1xFcfWOZ94sObgmLdv1YZpvdfjr2vaRveYc+kNjiokhB/kNrM2GVp1Si
	JD4mp8IcAK4hJkUAQn0wg3AqczvBZwhWgCECldufqX/nWcTophKsHC+8Jiv1+cuV
	TiCHwDYb8fLp9siy8SwtbS9CiiyotRse+odRfEyRuX588G7DCnt5YY7vMVgdIqy5
	/Wa/uuQqPqo2O7GxSXuw/tUCBt/JAszTcmIrgmzVLpdipbQgty7A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p9dtn30t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 15:23:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 533DovAH017277;
	Thu, 3 Apr 2025 15:23:46 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2044.outbound.protection.outlook.com [104.47.58.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45p7acaweh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 15:23:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VEQGhwrz67ulgbdYgXqYtRBcfkOCZhfi0n/c2Sl5ftGq9TnrcmDMBIf7JFMlNUDBrVJDunsOB/dL3A4mOH3ER/Gi+pxrqjik0Swayqc2zt/m0V4SfZgNgqhHRZys7FVSq/XrhLqN7J3Da9LxHwnyat+JxR1x9C0tB35R3e6WlrfL0Qr9HOi3id/U/Op0i+HKbAfnaHjgPA5WT43mJmXoFe71S6J/2pju9ed3RqxZNePUzmDsechQZjm9xleHrZOEjL7+bT1woaEWGnKEZ4HelDmaLeHQhV8Z9L7ZXJvGsadwl/zqu1jc+Mfq3GNHiXE8UtdETMpvlVEM6iEEquPRzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ei1NMaTijFFzRPXmNqsoZpjwe2+c3YfwJJf3ZihczAc=;
 b=SBP/ZgiZZKRPuApe3NimIYHE06Hs40O6c3kOZYT/H8QIOR+T2c975rfiCzjLcJtmk6d8/T6cN6NMwt4JFer5DU7XuUYieEmOSDHCk1LVAHcY6aDbeffNMCzhtV/BnG3MVR/IieILBGgl/0Kh4rlUVELe4w4+ydc/NV4F9qCAyoZSedyvtEhpC8VB5fYbNKsVoTdFvUBmp90szBgJayDdEqraWrIlQ42aWNXZOVCjCs1cS1p9v6fIWfS9GbrsHw2AvJgpPnfIAnFiqxXvWSeAcd0U6uHmYNgqwR4nwHzHag/9NiPoxo6Y7oxqAHhIVDNGNLpK90lxxMEbI2pFcnYc3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ei1NMaTijFFzRPXmNqsoZpjwe2+c3YfwJJf3ZihczAc=;
 b=x5aocE7ENgbdJ9/K0qhXJeb2kI9Udyi0A2LN1hN7U0xRF2zvjjM4JYbvb/9YcRf1BFzvsG/RCJvm0/lJqQr9Yx+/BeugPI0VkVr3iJ4gx67CZORQJ7nWinGeDvJkZf4/VzDDawQ4qaYLp2VEprM6h+4edeAh91/9eSsB2Hurjkw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB5801.namprd10.prod.outlook.com (2603:10b6:a03:423::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.39; Thu, 3 Apr
 2025 15:23:41 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8583.043; Thu, 3 Apr 2025
 15:23:41 +0000
To: Chandrakanth Patil <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, sumit.saxena@broadcom.com,
        prayas.patel@broadcom.com, rajsekhar.chundru@broadcom.com,
        Chandrakanth
 Patil <chandrakanth.patil@broadcom.com>
Subject: Re: [PATCH 1/2] megaraid_sas: Block zero-length ATA VPD inquiry due
 to firmware bug
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250402193735.5098-1-chandrakanth.patil@broadcom.com>
	(Chandrakanth Patil's message of "Thu, 3 Apr 2025 01:07:34 +0530")
Organization: Oracle Corporation
Message-ID: <yq1semptgm2.fsf@ca-mkp.ca.oracle.com>
References: <20250402193735.5098-1-chandrakanth.patil@broadcom.com>
Date: Thu, 03 Apr 2025 11:23:37 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO6P265CA0026.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::16) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB5801:EE_
X-MS-Office365-Filtering-Correlation-Id: c4b4c128-9a36-43df-4c7b-08dd72c383e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GzpOtJ/AJ2klKhJ4GmLOXHQMT651ERJzpH8LQCn9NxCFo64/+eMMLVgZ/UXQ?=
 =?us-ascii?Q?ep6SQf9NwVDOvCKZt98Wq7nh5DfsCdL5COZqqOlKd0fkbFDmLCyjh1la0xCo?=
 =?us-ascii?Q?rOgvZpTMB7udk+PfeEhVo2j6LyEYRqXl80dI8YANWF+HO08JP46qyqIGqYiE?=
 =?us-ascii?Q?TQmbxGbxL9uznBPlKyflBUilzCeVM5FJjoIXFohCDyG5xGPgs/DmbIH+4EwY?=
 =?us-ascii?Q?8iKhnUwJGcC6Un/pm+dmbLeIRfNoLRiBhcjkCrvGXJbzni9mIJG5QS5Uxuj4?=
 =?us-ascii?Q?Nu8pu6xr0APXtyq4Uae3p9Qd83rdbiJvtZp0ql3g6nh74toLDjpappbQYbfo?=
 =?us-ascii?Q?t8L0AiBa1iBNbaGOhD0ZRZG0+DSAGfetEf1l7BJuqjjFwL81JzfVXo2RwWpm?=
 =?us-ascii?Q?4cD8FP5rINM6vgFv3igYcFV24WwIJrZkUsj3nehSdvbOlYVI8BxSU3MrByW6?=
 =?us-ascii?Q?6fv1v8qebuAL/7KAPaB+h34cSBCqgROeWOnZLxBR3WfeWT9okazL2tcCkKcr?=
 =?us-ascii?Q?mNfPIVi/0DTx+6zj4AyYc+VoIU/iTYIskwkplQiXDWwU2iL7GT8kheyCpWRJ?=
 =?us-ascii?Q?deBcHFCoSpSY3snJFMStVwxcdfjc4d1frVMhlfDV3PxznJp2a/QKT7CtutJr?=
 =?us-ascii?Q?RdfW0WzD+Ebrov9ehYPZACMV0g3a8XL5/BcTUgxQw8b8Thk/iFW+9S4ZUlrX?=
 =?us-ascii?Q?Cd7lu2QRIhZe6/oHFLU62ERhpIRsWBPHfiSgPI080fgT/qnKx9pmFAJoQ2yI?=
 =?us-ascii?Q?bU677UOGUZHmaBFYlhs74d3nTnUbUTlhKYI0mK95yVbLhu1OZdQcEbLdgsg8?=
 =?us-ascii?Q?Zsb1jtR0lNH8Lz1n7C9J0l3Sz4K5vU0F1Eieh74taIyHBg98sgN/4xkctRZX?=
 =?us-ascii?Q?CNX0MkKqcp6dmvK3rauM9ROCjvmVfFxvW7CJRv/qo3m6n0Y2+RYcECyKOMdA?=
 =?us-ascii?Q?iM0Za93iaCI0Jbg2bn9z0BqKiOz86jyFIrNrk4qu8/5fLTJUe49q5PeSbwBZ?=
 =?us-ascii?Q?6BXDrrv961oYFyNz2How66rmit02nzcfnVUyJ7ga7zlL4UeLzVk8Z9VsKjXF?=
 =?us-ascii?Q?/c8yS7tzEhD4pp21gfu849S1NM5RchePyJouYc0rWHAVNFgmUxiKb1T1iNv0?=
 =?us-ascii?Q?OUjheIFEXk0F2a1hlgM/kSjf6/mUbxnzDEGsC/GJfLdXal9TlN1Vr+oObkSw?=
 =?us-ascii?Q?MvQybcVCfi6Jrz1hriL7mVdN24xUyLGtnZgmM0ruQ9Wr5WhV4vPn5BbFpVSj?=
 =?us-ascii?Q?vj3WI9mx05biLIcyYv3lgmE2qhdbYrRvCwpgWI+eAAE+NMOGFLnqe5gticc5?=
 =?us-ascii?Q?+6yNxu5ZnRds/IKZd2KzUax062WdZIXwvysa+gm+Tqal8X+cQF4YEDQm5dXR?=
 =?us-ascii?Q?MvBh1zU4bKQ/+1rrDtNgfsy8drLGp05AfYvKNxqySVWqx97fO1cC+PDF4b3o?=
 =?us-ascii?Q?ySf+LIxcDQ2ct8O5jLQ1OerRT6CVo64M?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D40bpqMDlc96xw4JB4FyeQAmRuKTJDS1PgP7UmsevcgK4sIb7gwEmjatFHux?=
 =?us-ascii?Q?8cH+uHa4bA7IbG/3p9sFETt3REfXLhhhiNAjoALPaukmuWDEERveIfzT+rsw?=
 =?us-ascii?Q?Oc/ldy1uRho3taW5KXWYcUiFuWq9TI9qlEZTHxcAz3217lyAcYJRvUhcj5i5?=
 =?us-ascii?Q?9Uwk0tWDEhxZmeg3v+82RLPDoDuRlJtQ4YDeGcCXj2HH2pqrus5LmW4kver/?=
 =?us-ascii?Q?mHrL0VAxpFIZEnHagbR/YZJ/LZ9qJJqYew6Vk4qY4xs6nfyY3KiwdDJjUA+0?=
 =?us-ascii?Q?wtlqfu1EIa3evOLD7eSpHyJ+67qwxkhTyZNhNqVD+DVT8xzZMl/Q5gWJMMX4?=
 =?us-ascii?Q?8An45MjbUWW3HXWVgUMHjU/NMue6f6FyetG8+MdmN34L1K9NjBG3eWdinaL3?=
 =?us-ascii?Q?tS9lRzUNmTiMYfbkitXFDBE2uS2J1PgBQobSlTVI0CCFOnm9Bcw/cOIndZQA?=
 =?us-ascii?Q?mjM7XTEh9e+9IzcmtDR/14XHl3ioyBtCsxxnfDFDqxUraECkcK02N4t1N3dv?=
 =?us-ascii?Q?cRAZiBrmvJpuZJrNOQGEeOQDjtkfc5Ep3WSltpYDpWpDqpNGWKaf5DbXCCr4?=
 =?us-ascii?Q?Nn8Nfdff6ZTlYe5ls3O6YbLlXvELBoiqhFkixk8tSBkSIE9FUIfMLtLnGDsQ?=
 =?us-ascii?Q?skumTrFcSEPnKsLueXSzGFJ0PDSDzz8sODNuACOOa3tNZI2b0pycO/mw/PbF?=
 =?us-ascii?Q?9rp933AlGYqIAqFsrjnlmkfsYyViJhi/QfhJ/jwGJHhrXJHjVuYnm5i6kdNA?=
 =?us-ascii?Q?yocxXtalknL1wNPlhzPca7e0slsLRef2Quf5yRBRn8l7bdpb5yk0UK3Jqzlb?=
 =?us-ascii?Q?ny5VJtXppqXNaJazLGuhpO0b/+OrBe71BW5vzbIjzwdSBQYhtgPtpTzNIan4?=
 =?us-ascii?Q?i3nN8Z/utNcsHkrSoqTZf/3lX018oBEivAMEsXduITuliydRvZrDMUDZ1GPJ?=
 =?us-ascii?Q?36YhuuL79l8ejyhevmraslkJE0uzO8FM0LzBxL8pudBSe5qpjQJ5bEBaZpbJ?=
 =?us-ascii?Q?kglOLH7xHu/zevUS4SpW2NR0ldxvH8ZB47dNtxq5fCqanRKkbJtItz8D6d8s?=
 =?us-ascii?Q?zzo8WdcYhhdzJFxPLI0y8x1ua63erHmOS3Zjcnja0sd3GljX5RVzHEoKCCaW?=
 =?us-ascii?Q?mHojSBwodNfSDDPmq7VqNSukzEGrLb4M0C3KrGPgQWpxcRQAFUyYIKhZ+Dvj?=
 =?us-ascii?Q?U3EAq/yiCDM7x4Y6taiRUQpB6lWAPT56ksIXRPbJ67k1JDCYssSnqEy/cDWn?=
 =?us-ascii?Q?FDiiJDsdHh31yhwLQuXNE58Agv4foRsIsa6i3bV1diSGf6uz2oG0U4KzvN1h?=
 =?us-ascii?Q?pqe7DO+ZyvJ96k52QxFSB8TDexcLoAtAY1MTTbAuQDW9j32i/t/mlxftLvWZ?=
 =?us-ascii?Q?oJ4Wq0pV2p+hlVuIqmqYOkW3lWa6IR+jPH0nSWS4iyiA5Qm2KR0wMdF35clW?=
 =?us-ascii?Q?YKritL+RYrD8CMc6VDWWd0dCMuW4p9JD3RlTGcmK8z9k024hq4+8nc2wPXLO?=
 =?us-ascii?Q?5TueuBB5H3bIUKuWW/afneM0OLNxzAX3phe0ID1jbVVCmZsndn7Dh+H/3+o6?=
 =?us-ascii?Q?MN9b+LEBGcK1e8OXKkoUqOV6sElsY9EMX1jruiQLp0zNH7T7h15FVnSqC2t2?=
 =?us-ascii?Q?BA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uurt9mLNrDQhLwqVH4zd2AG4cGkvffAaFH5Ylq+nYcZ2+Z54wLL7Q5PCVhVpFkA6lWA5UdsI8O8EjvC/ppkUw2/sFMcbhfHrPo1XmjyIFcmVKHhd21SIK2XiHMst3d+yEgrMqlWBAyNNb4QiO1redAYlS5sF8cLwdwbBSxJLv21BNpDv+JXJV8YfavkJ4kJwzFswupDt0o3d4bq08uFRGZ3GIjOz19GbNvWoj8yIL5Y6PPjvhvZZ0h2xKK7HDn/+hWqv0Nr0kUWD6y85DPff/1KprDKOHhLtz+gbAbk+GJ9Zf0D9IX+dltma55bguUeXdp/YuXhw/OGDDPclnPtYuDLxhVwdWpP/k/A4XUld24Y8JljB8iJFf+vDX3740qLrYP+qKPf8TiR21XvDROBGX545E1VpStDAE0j1uTWOz+13HlS9rmmsR9SOKcvYXckVTHs+AlW/UkRrykzkRyrmCUFXme7jmIaI/AWOvj2l7VefLu8/Z9TpuQZqFq3tyiMT0K5Tjg0SZADoqO0Nu2maeHqX21gu0CVr6oRPfTynJl6OAVqg+tbVGBpJNYC8c1k+u72fVXDoM+rigFH72VXs/9hvCbb2zDfvIig62jMSPXA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4b4c128-9a36-43df-4c7b-08dd72c383e7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2025 15:23:41.4893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OzjUI0uABL+koAPysuZtMZM4oL9G2f9SZHJ6EhUVVqk7ltJibv5D1RHfMQbFEa7Pk5VIASNabBLzPp51Q4lnAwaTqLz/QnE4d0euw5dSRmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5801
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-03_06,2025-04-02_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxlogscore=912 suspectscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504030074
X-Proofpoint-ORIG-GUID: -Z60-Z2PSQRxxJpkVBzssUAwypVhiBTS
X-Proofpoint-GUID: -Z60-Z2PSQRxxJpkVBzssUAwypVhiBTS


Chandrakanth,

> There is a firmware bug where ATA VPD inquiry commands with zero data
> length are not handled and fail with a non-standard return status code
> 0xf0.

Applied to 6.15/scsi-staging. Thanks for getting this fixed, much
appreciated!

-- 
Martin K. Petersen
