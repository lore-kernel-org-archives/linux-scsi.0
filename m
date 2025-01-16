Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967AE22CF35;
	Thu, 16 Jan 2025 17:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737047052; cv=fail; b=TYkhumEKitxSygcSIhVjAjj/UBCSEgK55DD36AB/ITcldZry+xOnqJCtal0eR4P4+aRb1P7HdK9A/ZJVU55Nf2pfFvfRoqkPilUnu6RFToAriJiEJ/gOYgZM1Vegf2k3NsL09qevUtFFx0zoyR38hJO3kxkaUjHmPvMCLONT3lc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737047052; c=relaxed/simple;
	bh=dUlhcUCj8f2/JTQL0EU9BTcfLDv7Camrflv4JRfojd4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=aJDRrxCC4O1UR89oFz8gfaOetNw3/9RXSA7BCB+USGwic/+6x3yxTLejMiaEH3mt1OZCG+4M899S3YKfSHSaF76mFBczvRqpDwHKP2npYQY11Gmy49rit/UEJUfGjU/E7uDdBpkvJ2z2KKIXKOO2pjxyo8SzFvjVqFEDsY27WGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cSppoJGa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ey1di1sN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cSppoJGa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ey1di1sN"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GH0hJ1032379;
	Thu, 16 Jan 2025 17:03:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=okhhPf6nr61TUVt/
	LFvQjm6cXhmZ1tbLnOtkx1pQM/E=; b=cSppoJGa2LEraRFlMNcztL6BEQ3K22EU
	FqqSk2NZMR6Vb6QPQ8OJoHmdrPtwfzXdwp0Oayp6PXmzrZ3S4hrQulDhwx1EljDJ
	5AFH2x/0QnMrCGd5MurTt4/xxO+uWbbL+3sAPHlOslA7Gsd6N+j1YbM8SsiiaiWq
	X3XXj9w6WuDrx5UJpwkW33CWGdwKXznO2hGkuOmFMOqQRsDV0rk9EO+HgKOQEOM9
	nRYqRVycoCTy3Dltbb2cQRsoKxYGuf7yzxnht6YKHAvMdv1IjwiMEi0Xk3d0n4vQ
	3b7V7D76Y8ucZ6TOw6KmBSHXZE7xPpK1ZaZEBk2dtNJ7P7l92A4v2w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 446pdx1j2s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 17:03:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50GGdKse034799;
	Thu, 16 Jan 2025 17:03:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 443f3b24he-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 17:03:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GjMPhoK9nMgqOCiu1ATBMhuiw9s25TMbVQIJBXN5UVLR5frsz4PaoAOnCHBOJabbsTSaNh9d3p3k/MxiUYSfcR3AerPShjmCTUcls6g6RKURKWjUde1w6VgAL7b5+Zr7lGr9PaA6MxkkqFra2riXQyTA7RQnmmybt0HBC/iLG+JPfiXvRBkBl1GTo0gHHw3ugL7zpBTIiJ5xEOcNxOnnpCAj5xcdsXGlKzwwdVE7PYe09KUjy/sY+DqFO1zMEoPBSPksFc2oUuiJlkeaOH4+I0tmBEZRqRGoPc8Faj9O2opr4YAljWpw1khQ393B7GGaIRh8aEMlP9yPlvF8irDM/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=okhhPf6nr61TUVt/LFvQjm6cXhmZ1tbLnOtkx1pQM/E=;
 b=UhnVQd0PVITdyAIU6ZMDoppiTS/Ztn4pEczqsPRwsW7jzNQP2OEKAAheQsE54BREJAFrXcuDmMqGcHI2hA7mg2MnrQm5PSyqwxe5HNblY/mYDoyWvOq7ys9gyyePfO9r42DaN/BvPUY6hd7PNamWjbLCq16cKqaKi/ednv46UsctxA35kJpD+hIF13lfs+AKCuL8Tu2g3EjXaorWL1bHOOkuGYQrFpnVoJkOM8ANQNVBmAbsB6ljQD1P5rOOJJWs4vWGUO3ccXehS1nN6/7wxEV7ICISJC4PBo6Qqq5AJsdfGLsP9vEVs1uf9Yvx590ONu9lhGUEd/PplL+EI4HVQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=okhhPf6nr61TUVt/LFvQjm6cXhmZ1tbLnOtkx1pQM/E=;
 b=Ey1di1sNd7OyCuZFKu/biZsiXAcy/1qt/4YBi1yYRZATQfsuovIFr5fiZgdYUzaqNJE4oGG17LQGPpqoUeK8o/LJxtuCwW5WDPTm/qIsnyem4+Pa54i6yqnLGyMHwxgEnUQtFGphWgN4/LQ2ED9MKJRLmHj9ug1/8d3G7Pu0ZGw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BL3PR10MB6235.namprd10.prod.outlook.com (2603:10b6:208:38e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Thu, 16 Jan
 2025 17:03:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 17:03:28 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, mpatocka@redhat.com, hch@lst.de
Cc: song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org, sagi@grimberg.me,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC v2 0/8] device mapper atomic write support
Date: Thu, 16 Jan 2025 17:02:53 +0000
Message-Id: <20250116170301.474130-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0021.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::34) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BL3PR10MB6235:EE_
X-MS-Office365-Filtering-Correlation-Id: 1591cc4c-26b9-4dae-5796-08dd364fb277
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/HB+lgsVIUnAVPvs7PZ1xgF/ir8fkP9VuAHItNBh0SfKzjyWewiQAJqov/61?=
 =?us-ascii?Q?rlQ6ts/5wP9cz+iFC3fpytZGSl9etY2rT/mFEKmIeGLNV99b/+FXbVDy1OGw?=
 =?us-ascii?Q?mJR0aShd/yIe2mu2FdD1HP7DZjygyPmVxEg8Z+oAgQ0Fwci8O1rpezWWnXJL?=
 =?us-ascii?Q?OaJFE5qGbECLBekNJokvpCDgRnGqYIzpsAXqn1ge9t0UXuaZ3rPF+WC2dh24?=
 =?us-ascii?Q?XL0fJef5pcsQ9dBB3mJbLFfLqm/+DmKavQGbeo0qvFUrm9wFE1bYb6Ch1teL?=
 =?us-ascii?Q?/r2/7NsCi74pIfM+5rngVJotr3xi4QYAkrvUDb4k21nQ6bntT4qXJeM/DB7D?=
 =?us-ascii?Q?CqhcGF8nt26PmYT8NNu0mtfKb/HHBxb/6lBKZ1pcDmXBPaHQ02uOI6dZ4Wq5?=
 =?us-ascii?Q?E3sSgo/cl02LVABEpOgAvuuRbn524MUSgYHI+jP/kno3k8l06yZKun5+VgrC?=
 =?us-ascii?Q?Ocd8WvQ7xRLPt36HvE1LSMkgwqu9rzCGVFFl+FV5IoseeHH5TOlXXImGzMn6?=
 =?us-ascii?Q?qytPmWMX41aM3hDrKvr5w0mzfJSaXEf8fVPzUSZnU19oN8oruB4ha0JuGmZ3?=
 =?us-ascii?Q?k68R+p7oSw/iUQ0q3zG2jicqL0D0jKmqR4WxTSaA2QPl/fNMKOQmCV0vFZfK?=
 =?us-ascii?Q?dzcmCS5VLmjdOU6K0E48jFivgCiNyRa/y0UGsERzMTZRp5NnOV0GCHprWLUI?=
 =?us-ascii?Q?utTydJNcjrTIg3SryUNWuMGa7oHE2dqTM5OMt0T2e5GZCZM0Qt5x51vHD0rK?=
 =?us-ascii?Q?wNN2MAFka04MPloeRJ/udEvJ01pAq+3v9Mad2rMXybWFJkf42qCdFyoDD2F7?=
 =?us-ascii?Q?cD1Y+ka8tNBbrUZExm7aNcJGO1my6vdqeUhWgkQMKBwb/1QYvJs1SyHiDrVu?=
 =?us-ascii?Q?uhQe+MQ3C1yExxp++7B/Q+tzAnVpddAD+D7dlsY3dBe7Oz+yiWq8LJ2OMX/x?=
 =?us-ascii?Q?JnPIx33cCaV7tFR+AWkc76SXhJRqeq9yoAjgNFBJqiVibz3hQdK7jEPV4voT?=
 =?us-ascii?Q?Oa8O51GzGEbXx0L6sAsIMHzRAqZeXpuOCnoVnIXvLyhqM/UOxExOYeY27hcU?=
 =?us-ascii?Q?b/21A+C+LZUp0uQ0greUvrNVtTqw92Ybb0TLkLJgHN5bQKFNFalTqlTAwquG?=
 =?us-ascii?Q?BbmDRATYQda30JT1+iZDyTh7n/SSGfpBDfryvBgIWmMrICp5voQF2AefWfQ7?=
 =?us-ascii?Q?sNSlpjI045rRPUPSs6S/8mvkx1yw+Mni8JSqiTTaNA0BiPFsl/g5LySpFCln?=
 =?us-ascii?Q?uLC/hv/sQNJe1ZBsNOTZFlxNzxffS0uGxZiGC/AKydOXcJQ2IaM4ymTcr1pd?=
 =?us-ascii?Q?2oRTVSWLX3WCtI8uAu/8Qt++JKlt7wuvXyh71TT16esmLJOoUKvcQBFuLnbe?=
 =?us-ascii?Q?FvfD8MBlwp4pC8djDHlvxYl7uZgR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nIRdHNm8sjFM28T9qJEeSdNRo4g/40ALoNp0tcwbCjkRHr0N+0IAckY673ZS?=
 =?us-ascii?Q?gt1KZ9188A5e8zUpx0MEqhAcpyb+ec6zRir7QTHd3iDohqPKE0O02sSihjgf?=
 =?us-ascii?Q?5P54gLhkHx793uq3sXzFNQsAJ47+zv9NmRHMHXWLcTMthiHIfGnhhqTCB/Bo?=
 =?us-ascii?Q?SXqTNuDrUofcdDfTPEoaZS9tIdD/KzzrMGoiHB7ncPy95SiooZXyiA2bU4ae?=
 =?us-ascii?Q?lWOAU3XvY+pCdhIWiZt7cNWXTPRaqr0lU/a9Xr7y+4P4rbOXBWCr/MVo+IUo?=
 =?us-ascii?Q?IQkSOebaDoHi5QZrwvbwzgKi5qyGI5/iLX5Vkjeijs6qM7NqADVS87A9jMDT?=
 =?us-ascii?Q?/vAJM3mQA1ZUWU0XTXoa4FrPkAOsq0qGBM6gWwwAeLOEfnaEU2lF67k75wp4?=
 =?us-ascii?Q?rV5op5brfbE/Vy1w2J2/KOsuiCNop4gbyg+qMYunLnJJIMjn2RVDdhD0+qA6?=
 =?us-ascii?Q?jMOpRwdIL41e1hkB1+/vxzl8wsZG9AEaOkD6srXmHgvi5Uyurz7VzpXxrF3j?=
 =?us-ascii?Q?16cpdbFnxRxB5qQ4sRFRUhBwVnFvlOu5Ohvn4vrcWmD3USeU/WU3qQt3UJEz?=
 =?us-ascii?Q?9X5B0mLVwP/GN0f8IoCxUQUFPl5nWMISe65gLxTC76+PUGYAwuZkmd3GmkOh?=
 =?us-ascii?Q?nJo8FWw/ykUH3XiF3GrhJajEGZ3XrEiRWwYgnRlOdErJvYbxuYrQushukquN?=
 =?us-ascii?Q?ouyRklvIBsGasz3uPbXzkv4NlU+sf2WuqxNK2rJFlDGlhiw949XBREhH+OAj?=
 =?us-ascii?Q?hRn5kJLum/TPUaUqm1dl3BMIpcZPsrXJQKB/dxP0bqv2zy/u7UU6Je2Nqe/o?=
 =?us-ascii?Q?tE3Tv49AzZBZGXtL6EJd5/WVZZ6rlTLhdQay3y8aH4Htg9ZK1QdnkK5RxObP?=
 =?us-ascii?Q?W0MkQAwR6SaDy9Z2KEebo8DknyrKtKRq8wrefqQJ7Yqrhw056IiT6L9lzJ/Z?=
 =?us-ascii?Q?Ltj3ISHGFPrKzj9eE7LKbssoA9zkgGdQn3pvgx2z/9XbRa2B5PInm/oV7pjy?=
 =?us-ascii?Q?ECbIeWsDHLXErhq8kqd1Lb88ER6iazWCk5t+0QS1YD9BygFJDnftvdFicla2?=
 =?us-ascii?Q?1BRT62eshyJbz52LXi4hT5254VFooTQuczsHWI98a9UAFoYk7vWeCr7yKp7U?=
 =?us-ascii?Q?0cEsiQTYmU5WE2pHjNOw5kt4Hc2J8QW1kzWwn1EtwTV5xJZJNMuZHKXNsPo1?=
 =?us-ascii?Q?QvLcVF24cypxGx8oBlPVME/N07y+Ea6KD5MH5dgD4GNIeyNU3KGTTMbY0MBj?=
 =?us-ascii?Q?N2FrF+EG3oH1zV5KqobPMAcm0iHYbPKhKvAXqHwAT+15mNHsnpXSc3soSJg3?=
 =?us-ascii?Q?QOU8B9WjR6OZMxw27IsRmSpl17zehpnOW5g4xsPLDVwg0zMi75eMD4O8pDrn?=
 =?us-ascii?Q?kNUo00hd7n9QrjiPadX5fYRvgrlXS9SlwiBdNFdrX7lzHQEB2OtLKaW9vn+n?=
 =?us-ascii?Q?r1vQcOwDugoKnVpwbfsZtJjE6wxMV+NLXHFdBeWZwfi1/dGxshL+C4gKL/P4?=
 =?us-ascii?Q?q/9t3vupW0Dkn9x0sARHx9Fx3ah+3Eld0bC6A79SowHzkZa09M1/6MQUE90T?=
 =?us-ascii?Q?nlYwaRij5DBz5X4/jAJYjsfwTvmXeKxF5NbYslxWJTE7LUnX3U65IeeXuZ1p?=
 =?us-ascii?Q?jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nMEt0HheJvJOaT2RqlCB171k2WJBaSqvInC7WGLZfwDfBZhbEwxTbnTaCq2vbQ7kv76hNXRkmy53MORDFeAy4A/zi/wbcGLX7Ui42GAlxNdrVPUIL9WpNLHdIQsZLVZmye/YNQZspclHVvJyVPykEhMxmHDjqOIBgIDENNbzuO4OsIqE4bTe7jE71A1A529fRL+jBtVFc2ufO7meVRYj/ajgYREvM3qR39g1nuVmmOXGDEUjN7Qa+fb3nHJpym/KhPL88L1FycfcKaXbU56PSZ+rjyOM2LrtSYM4NHF7jNr4GLChdYf+2C9AV8N9ZY8rWlhQ+iXwCQM9qtVvUa2+yTEhaVL+Q3RhYVwCg2ClAXEoN8KvqFebnJvcEBuuKn0zTQ4vesCPJpT0RoLEZZ7JFNOcqot1I4G7vb0LtIvPZkeZxfnC2sxD1PRfiXydB0fJdXEVUIOesbmHXtz1AlHAfpP66T9bGROmcV/YFVr7dbkMo9Xyispsi8jSHr6N4Xff7rhYLomzPCwELD9H/7DydOTByBlm2UCWA7+tIqOet3OHn24ZGcsR1AI2S53240q8fV9VJl/WkNEdyktL0CsbhClz4BU/9kd31CM2KugwFa0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1591cc4c-26b9-4dae-5796-08dd364fb277
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2025 17:03:28.2356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ye2OFLk4IRGUVWhYQoB5JboVXe58TSiUOxQMrTlXRcgKdkWvgjsd7K3eOVtG60wu/LuOMnquHcWMPm8XSX9jvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6235
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_07,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501160128
X-Proofpoint-GUID: aoUoxVFHD8C86hk-HN71M3FzdeannkZw
X-Proofpoint-ORIG-GUID: aoUoxVFHD8C86hk-HN71M3FzdeannkZw

This series introduces initial device mapper atomic write support.

Since we already support stacking atomic writes limits, it's quite
straightforward to support.

Personalities dm-linear, dm-stripe, and dm-raid1 are supported here, and
more personalities could be supported in future.

This is still an RFC as I would like to test further.

Based on 3d9a9e9a77c5 (block/for-6.14/block) block: limit disk max
sectors to (LLONG_MAX >> 9)

Changes to v1:
- Generic block layer atomic writes enable flag and dm-table rework
- Add dm-stripe and dm-raid1 support
- Add bio_trim() patch

John Garry (8):
  block: Add common atomic writes enable flag
  block: Don't trim an atomic write
  dm-table: atomic writes support
  dm: Ensure cloned bio is same length for atomic write
  dm-linear: Enable atomic writes
  dm-stripe: Enable atomic writes
  dm-io: Warn on creating multiple atomic write bios for a region
  dm-mirror: Support atomic writes

 block/bio.c                   |  4 ++++
 block/blk-settings.c          |  6 ++++--
 drivers/md/dm-io.c            |  1 +
 drivers/md/dm-linear.c        |  3 ++-
 drivers/md/dm-raid1.c         |  3 ++-
 drivers/md/dm-stripe.c        |  3 ++-
 drivers/md/dm-table.c         | 29 +++++++++++++++++++++++++++++
 drivers/md/dm.c               |  3 +++
 drivers/md/raid0.c            |  2 +-
 drivers/md/raid1.c            |  2 +-
 drivers/md/raid10.c           |  2 +-
 drivers/nvme/host/core.c      |  1 +
 drivers/scsi/sd.c             |  1 +
 include/linux/blkdev.h        |  4 ++--
 include/linux/device-mapper.h |  3 +++
 15 files changed, 57 insertions(+), 10 deletions(-)

-- 
2.31.1

