Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91482010F8
	for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2024 10:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729246632; cv=fail; b=pR2QW7gXCyFs4yYZr8kpIy1W0A2VW5VEfLJuoCIABC9VsbgwzuVemgmwpGtIao7Tc2euW3kecUwZy8DCo9QhVG97XbYEdiBmU2Bp32C/yPf50/zB/ZUZSOjM4wkJ23+cu9FG+aTSO0kLaT0RZgdF1Gt5X/w/XnNBe0kIpcBoPhQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729246632; c=relaxed/simple;
	bh=tr6vP3OgvMczMti2Dh1W2q9eYo5mrdv+dsC6q0QVy98=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=XZhgzNT+WEn4YQoTHKudV9cFC+zipEgseToH1F/Vw2cYSg6decTPDZMkd/1JkUFLKmkp9lj1YgUGTpFYSWwYfvf/gcwXLRGnEuPFWRHWjy0szOa/5AKC4SyZZSYmHJJlh/PoFzynt+LvhY7c9Gl3ZGM4HydYwfro067EKQYFMIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=POvULESU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=G75Ex/Pa; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="POvULESU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="G75Ex/Pa"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49I9iiFI022326;
	Fri, 18 Oct 2024 10:17:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=4mRwQKmzZq41ZR1x
	sbsETIF++Cf9J9Wkz/W9zV9of6o=; b=POvULESUBhxZzsndBfTEOMATcjkEdz2F
	JV8zYgihLnaR6B5vHRhKrNvPHdrnUFpVmF2fAAEUXuBdq9p7abpKmH7BxMd1eBdW
	gfODS6ts/yR7EizJ8pKf68rnaqJ5WLW4BdY5DwuqsWCQoLXWLWM9oxD+OjlUeHzt
	GguNLwSduQfKSXjR4dqWw+8sBvYQ7O8KK9AuauTH+AJxM+Lz/kyBOmm+HWBKeryS
	vLq2aqLnmdRsP16PyN3cEzABK0qmuN+mIHVV0dxTtmkm3P31BKHJ7B1laUgfnO+Q
	EmujscrS2FYn0buRRyJhqrKmUKXAqM1JtUCh/OnTZbTk4ZHFFSDP9Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427gq7req9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Oct 2024 10:17:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49I9x6fM036099;
	Fri, 18 Oct 2024 10:17:05 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjhy0ce-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Oct 2024 10:17:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HPgd1CQhIBPDglMhM7wM8DgqlOtjytV4RjNCTGy1+Fdz5t6TCAlDy10o46VCAQnCynhwi05QqajM1Kox0sG/7VvXqAMjP8PmScrYhVoH/CJD8DPvCXW0s7Q/xpB3s5pCXX4453Qu1XCPvifxbFI3Xd7+0a7o4CpZWvpda1qTad25/AtO3ARnnWZrUJuboDt29bQsRplSRYl+KV9IZ82CxsG2L2q2pt7O9kVi4Ugl7E+uOrFvHId3HzxzqiHhpSx5a8Ja1LyVXJW/f3AMOxA9A8i6rBmdJITVfBJAIoPZ9eKkXK93bJuCO0eFA9qF+I2Q5rS20Py+VpWJTce27r/NOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4mRwQKmzZq41ZR1xsbsETIF++Cf9J9Wkz/W9zV9of6o=;
 b=dE9jUS3d0sMXWZEjSa9souWDnh1tzv5zTQ4hj6JFMIBHkFhmGKtoVu4+/I77gQ9yDbSx0AbyJx0hyDKfekDoW5KwNkZMGemhTZ0LSWJyP/+KVzij8stoS6ih3PC+DQDsaOM7w96J2kGY3OKEH/Xw8rtz/Z1yLJ8/4zvRj+w5+sgXbJBw4xlP/0njUEJyOShM/OOY0hPrGQXEyR1hZK7yvoeuVPcNFeEU3vuhBTEAW/FjBWSzzYWtJXhPSSZZwFwjqaLgUHMxXNPi1LrnKfIANVvfY+/DHDe+cQKWT+bRONMhuLOIixZx+KQL0kQAtzFYlaoltf4rSI2XwLU1FqKUBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4mRwQKmzZq41ZR1xsbsETIF++Cf9J9Wkz/W9zV9of6o=;
 b=G75Ex/PaSee3h9PPXWhiFEtcLi0G6pT3PKrd8U7J1PJQWO6dYb+wHpNT5FkRjMYxUzUAXucE+CQI0NVIeszoH8nBYn+Q7eoBGcGggykzz9fudiHCgHMo3CUx5/7Ihtr5ar8MOqy/TvbbX5GcMsfzU/kuMK15Bj3Cv9SjRYgLAm4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB5031.namprd10.prod.outlook.com (2603:10b6:408:117::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Fri, 18 Oct
 2024 10:17:03 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8069.020; Fri, 18 Oct 2024
 10:17:03 +0000
From: John Garry <john.g.garry@oracle.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, colin.i.king@gmail.com,
        dan.carpenter@linaro.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH] scsi: scsi_debug: Fix do_device_access() handling of unexpected SG copy length
Date: Fri, 18 Oct 2024 10:16:55 +0000
Message-Id: <20241018101655.4207-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0148.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::33) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB5031:EE_
X-MS-Office365-Filtering-Correlation-Id: 03f00847-f79c-499a-bbe2-08dcef5e02d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5dgd1J41m8op9uh2aK2y3NpzCq8ZSV8a0wojbYLqJ1h19Tw3Ly9X5K8vQLHB?=
 =?us-ascii?Q?+kPS4wy1vqBUtV4ehGPlHXF6TZ/H7XP1KcMIXf9baMJFbI4bfiLuquf7d8fj?=
 =?us-ascii?Q?j2e3o8upyMj8gZpWyNUa0LOgzMnKBadrbzi9JERQ/sZsQpPeBdJ0sp/kYGfH?=
 =?us-ascii?Q?AZiTsP5dKWxZ6Jgozhou84b4tOxiNcCKACMltgt8ETOb9+95XS772PJVw+qi?=
 =?us-ascii?Q?KR4VlVsHZC9asFvquUitvhKsE/pnUYuiMXI5DYwsMFPCtK1yXVR0R5Fbs6b6?=
 =?us-ascii?Q?6eOitTKigjgOCTk45cAOPKzKYPYvr2V5MchvdOJjeTppNCJBVE6QGsoAEiiN?=
 =?us-ascii?Q?soGEHJqcXMm6E1Y4eJGXfohVjw5qVh5tLuqVLWdYBsiYO/AXMWy1mONVXhKt?=
 =?us-ascii?Q?cN+AzwTArAq7IpvcFVFdb/nYYGP9Rv6hDZwmgxDJyT/m7Oy/b0KjK9+PFfbu?=
 =?us-ascii?Q?+Q5O9idkaHZ63AHizhJs1vkStMmFN6I9IJN6sOdesJJ498Va0v3kIG/oUdqE?=
 =?us-ascii?Q?bjwb8xERod9nVcUOOJhd5Ag94jVP9R37KBtcv2yTLjYSP9YuWOo3pV1MU3H+?=
 =?us-ascii?Q?mBdKd+FS3X/sVwCICvzsZAnndGgk5XoBkLqqdcn97NC72xR8e5tYfsfJ7b3R?=
 =?us-ascii?Q?tQdW8FMuSz3qS5rVZEJiW1pr8+AjAFFu/jK66ocsJOw6H7CNJMKAb/LkenTP?=
 =?us-ascii?Q?cz0p/w1eiV0sJFHXoEHESnzTlV0zSeSA8flf9lZtZDJSPbkyR5qYbByXz6H5?=
 =?us-ascii?Q?2sJR1JWMnMQQDC8LuSX4waYGV3qHk8BU9bXTYe8HDXF+/2BhAEVZrQFi9kSM?=
 =?us-ascii?Q?hbyIiYIdWwYAOnR7E49L4RfCjFhnRo0n9BwXs+JEWm2P3URT6t/lVGVEptRH?=
 =?us-ascii?Q?954lx0QwI/tYnoauFDJGjhCqwm6RU7E+NKTFsixL9hIB2C6HQb4GeBF6Hqkd?=
 =?us-ascii?Q?DvkXekmuCY/kQSjVm8qi8oZQ0EdIGMXVNWpECAbFzEIVUOf2vjVPxbsn6aVb?=
 =?us-ascii?Q?isBZPhwhgMkP1irnkYA5Qn23sl8v+D3DbTKZGMYEPZl/imRkV+VASYcCgbyB?=
 =?us-ascii?Q?5uQWGITNu9PJ9nguQShv8OUsDOT4uuGhWLRPmcoAeV0j5jcWvRLZuGRIYyRp?=
 =?us-ascii?Q?jlltWqzGYfQYdoEZ2AqnF0S+lswe9slYtVDxySg4o3y9dLP2Jex+UnUB5gLt?=
 =?us-ascii?Q?h2fm8xRLME6Z3AFRJVFth0VsHs7eoOJHyH0UuPLTIlvlbYH0ua33BFL2oJmG?=
 =?us-ascii?Q?DxuJgGxuoB+R/c/BLqiFmt94nPG5H/Be8ghCl8tt6IAJ5qMfZKh5T0YJIoxS?=
 =?us-ascii?Q?wvxAS8W0fcpD6mGDBHKv7A0z?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EcKX/LPZsm6vR4Fs/PUk2z3fPtTF96XfRcQljVXSay8kqvEDqpSQsR3Wcayx?=
 =?us-ascii?Q?uqEvT8ZF/Sfdkx8AGq9cOLu1pRunVvRdVo0oWgkFtpE+aB+k+VE+aKXBRYEX?=
 =?us-ascii?Q?sl+Je8cn8ND0TjCMmzKv9ksTPLl9uXe4SB804xyetOv7hO5JnsHnO4ix2JfM?=
 =?us-ascii?Q?dET/414dbqSElPuaOJgiFD+tXHBenygBxcX6mpihxmCJRIWC3y0tU19FS/ym?=
 =?us-ascii?Q?9nakrdaaJjn5tn2fBYpAtE+/1Lqg6R6xdpTElXFbuKqg/S5EzQ3TOrzao6id?=
 =?us-ascii?Q?Kt9Qu2+9I3aPBqFKX85851f1NabReUwBHguxvgprSlH+tvFbjv2kNfdDfuZE?=
 =?us-ascii?Q?mPZzjqzPD9lwKADmYI9HjFEJlruYdMyZnRTrBvFAesSZsmc7ZtpLGrgeKW8c?=
 =?us-ascii?Q?xcviZRD0qbim8n+8qI6fbGtdqMSuq/B8mE4fuqNjc2GYMFckGaKjb1qrQ/Gl?=
 =?us-ascii?Q?vTWuTlcbBbAKUTWSIi/OEb3xX6DPlMx+6Vg5J1SenU8NJMSLuNbVoqB/Bkve?=
 =?us-ascii?Q?6P/JMiBSr7FvKbLWlcVnogsCYPNcIvL2zAUUjPBHPK9exw9686YTzQ/ZCiuY?=
 =?us-ascii?Q?4YdkYa0lpGaNrfpgKXrWsKmiXiJd+C0cR1gDk/BElDvtzSGWM5eE0zs6ZPyk?=
 =?us-ascii?Q?rM2qCS0EoXobNkb/YVjJZTKE1gDKgU5o/T7AjwM6mMpFsi+t/HtZ5xAoJp4l?=
 =?us-ascii?Q?qYsfD9WVTWo2cWySVTW0w5EsU1ftTxITnAWh6GzSok2Oon9ZgU2ToiivVV4M?=
 =?us-ascii?Q?8huONYhYAOVUvD3n00SjRfHeb6GGexbPqfuuQVxzXkB0is5dFxAa3BWvNNm5?=
 =?us-ascii?Q?lRDwdgeMLFhBivn2KvWSS830tKeevaXMD4wuQjR8/3OEU6wgNgnrurZxGfSF?=
 =?us-ascii?Q?L4Bg1LYxGhcin9LeIpKddqcRBmkuVd1D1ZtwbtiZvIWBnG5kfaPzTrv8Ytar?=
 =?us-ascii?Q?dANXsDkCLdasvm6/JHYOj0pgNWETqoi9wrsdga34aP/MuNfAt6wGpuZsCQ1i?=
 =?us-ascii?Q?ss1Xw2d9Gd8zWDBJjica27lm8agk37xU8pLw7dbcywfiX0yT2hIwBFeKcWq4?=
 =?us-ascii?Q?P1KftEAkN7xYkEke4jwIFVUbGtEeZQcw9D58Rh9CxQAuCnjoEaFSIMs42AKP?=
 =?us-ascii?Q?nUcuBDUd9kQvbUMovmDIoA6UAb9UHHqaar/k8sTUV1XcCa83sbW8y34AlQj5?=
 =?us-ascii?Q?+xn9+d2YecBViOfp6XyjygxzT4Z741JTSuZw4Xz6XV5y7AFhvXi4HDBLUl+4?=
 =?us-ascii?Q?vqImJba3W3V5J81RovSgxeK56GPg3zBqJlBoQ2+C38z547NynfNSNfK9Sbbv?=
 =?us-ascii?Q?KcK15451pkQ2S/2F6TJlNIgznGb+C7MvDcU1nh3hQNl9YVwoT1Xmr7x7NoHu?=
 =?us-ascii?Q?HkM0RDG20Fmv8QqN/8m53A1Mb8OP5Fy167pEvan+PSM7P9okoL/ii1GTMrqd?=
 =?us-ascii?Q?bFNflpYE5M9Lgug9oYRxdL9hsBvK3yPCETYeTNncVKCQhiAdI1OoiadHxXU3?=
 =?us-ascii?Q?gNLNTkgBJq0dhnfKpTVE3Q+zT5L9OyV/flsYTtqH9ZW2mCI4u9njF2YGwSq1?=
 =?us-ascii?Q?noT0CDwIyaLGtrEXjnBy6bRO0355tA/GkhZ/vFEp?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JmsfYZk3MJ/L/Nr/lWVkXcJsIpU+d0fIfrFwJRQs1WNQXcfO8tBqGTByzAfhtcqfFM03iPGqR2s7Klf9yCQOK59IH6WcZqsYQ8ZTrdg7fXkAfmLMy4DzxV+h/w2OvA7nz8EVJL30iarZdK4VYcTt78dCrKfX0TJZ0aiW6S7TSCUW7Zt7NZcEtAVyo5UzH0FgWCR+kEQYaUsLp475crb763bpeu4O75WqM8N1VklHP9uIhOKT0KVoH4jEFhH6N12bI6vx/lza7l/Ux76GZZivhF3J2+/Wk9EqEQJspAF6L3mUg+BDz97ptsyB+A07Tf+NxR1gApvuka1drGuy1FdoRBThLdlDySnjN1m55Cul9oDyGfpHlvaxq/GJXelkAQGe0Y7+6tZkUfMrWphonlJtN0rI97CRkK+lKdCiQMA5ldhCkbPRGPhXX/V+5gUXLvJsg3KMrsgOJkf8xygJXatx4B8XCi86o8o6P5DL/6Ppb/cvRG2Xq0Myaienz1CdsVxxgq/2dX+6w1Zn9y/YcouXIZdPOBV/658u/dwn+Rfi5JHiwDyZnqh2vAcO4pZI+b2rm6YFwRt2b6CuXOzalSLT3BwRSxKZqx4m4x31DL25q+U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03f00847-f79c-499a-bbe2-08dcef5e02d3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2024 10:17:03.4485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aF05Rsw/QQiGszVnJ865fB/atu4gyYexyOlxSPZqPQSGo4qTk1+R5nrgff0TibM4klN4OqwdHnUF5BWSsz52bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5031
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-18_06,2024-10-17_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410180065
X-Proofpoint-ORIG-GUID: wIOV6ES_v5OROTe1K0BG1jabDT-L-Qs7
X-Proofpoint-GUID: wIOV6ES_v5OROTe1K0BG1jabDT-L-Qs7

If the sg_copy_buffer() call returns less than sdebug_sector_size, then we
drop out of the copy loop. However, we still report that we copied the
full expected amount, which is not proper.

Fix by keeping a running total and return that value.

Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Reported-by: Colin Ian King <colin.i.king@gmail.com>
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d95f417e24c0..9be2a6a00530 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3651,7 +3651,7 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
 	enum dma_data_direction dir;
 	struct scsi_data_buffer *sdb = &scp->sdb;
 	u8 *fsp;
-	int i;
+	int i, total = 0;
 
 	/*
 	 * Even though reads are inherently atomic (in this driver), we expect
@@ -3688,18 +3688,16 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
 		   fsp + (block * sdebug_sector_size),
 		   sdebug_sector_size, sg_skip, do_write);
 		sdeb_data_sector_unlock(sip, do_write);
-		if (ret != sdebug_sector_size) {
-			ret += (i * sdebug_sector_size);
+		total += ret;
+		if (ret != sdebug_sector_size)
 			break;
-		}
 		sg_skip += sdebug_sector_size;
 		if (++block >= sdebug_store_sectors)
 			block = 0;
 	}
-	ret = num * sdebug_sector_size;
 	sdeb_data_unlock(sip, atomic);
 
-	return ret;
+	return total;
 }
 
 /* Returns number of bytes copied or -1 if error. */
-- 
2.31.1

