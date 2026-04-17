Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6611C373BF1
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 23:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776467284; cv=fail; b=T1UHk+sdENtyIz1GWwsTmtgYLz8zvOI/Aa4rKovLXvT4nfbAy6BGI8VPtEzOZZIA+xr+JAdnh4jA/v/mRnNB6PeHI4ILMZ/eYvH0VIpuTUUQ3DsiooeDLAqmDZtYwkUuS7Up2ma/ZE4ccIBvSkq8GM2JT+8aNnYcjOIE0nxBPuo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776467284; c=relaxed/simple;
	bh=r3GQJ9Vxc/4UNsCVWM5wsksdzRPjgLrjtVKwqZy3hyo=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=CjYXZU1q9gG75xGxKEkP2cwKGbsOafGU2ucqydywjcxQOO+WNrIitXlnj0/jOb41dmMXgc0ALQISRZd3hkV+mHK12Dizm7NjLI2cFpSLejUDvxo9iZ7TjbPrpZwT8qtgBA9OZCD4L7atb5F8tv7FXLizHw6848gHbpaDlKkzUtw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pCSAiMFY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nUNO+mVh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pCSAiMFY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nUNO+mVh"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63HKfeRp1431670;
	Fri, 17 Apr 2026 23:07:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=r3GQJ9Vxc/4UNsCV
	WM5wsksdzRPjgLrjtVKwqZy3hyo=; b=pCSAiMFYTmWEIC735gZhv67NrzGK063D
	w+mMpTI3h9Ga2l+crUzEU6HbugK+MP4Cw3iwQQp83g3bksd6Thot8wlwAOKfABAz
	iGY5mtu6XsplWFMD1/G54OvdmJZh1K65rNGr35n4TzmXPBPiJ/OEdVUp4XygF3F5
	q6hhVTSiA5z1jAUvEq2sM2PykeeGBUf0Vqc72b7rHjW5LvtY7vbUXqULPLurLBzK
	l/jNGhEdLKON3YH1UGO5eI9H7tSYcgyXyD2TO0Uz7npjzqiR3j9WC8z7f/ZoYuzl
	iH0bweieN5xF//iCHl+qvYezvcnjEcBOwMBguF45qwMRfdkyLtjRgA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh85qjpvp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Apr 2026 23:07:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63HN4QNM001796;
	Fri, 17 Apr 2026 23:07:56 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013025.outbound.protection.outlook.com [40.93.201.25])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nschsn-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Apr 2026 23:07:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vNCoBAvo9N7A5WGHfqR1vjdo9jNMeq0FV4kKdkUFLY5YebaJp4CqDzXA6TtTtxJUYp0CZnElXThaggizxEcHqZAJoMxIEwP+kWXD3WIww0UjrAVyGngohyIGmV80BMbHwja8f7IbFZ8VduF0e1ReyddDy8eY1vZMXU6jjXZsiIbWfZDT91q3ozVSLL+66mdUtAzIjdrOr2Qo+9sv+lUrLN5csAa5ACUU86aCey2qlpLrRb8/Nbq0du1A3lxrhf+UadpzUXwQexF6Ra4l7mb/TUbaErY2GcLwWsVMwbblSDjJNiXR8iIWE6/xP6tGFJzOKkShdF8fN7xdkEJ5bxl16g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r3GQJ9Vxc/4UNsCVWM5wsksdzRPjgLrjtVKwqZy3hyo=;
 b=E4OF0dQkAciQJV85b9uzL6WCsWFUl67kz+2abVMYtyrtEWusDagbNlzo52OLd7tDVJCRhIUdF5DVMd+TvKtIgN0pGV0na0J1feOpLJUUSegw0bTXMd3/nVKL2DcvYtkVhHSn5Owl3Wmj64tuS1t0/9lnrPIM7RNbwBkAyVIaKBkNyy5JFvaNnBg1zZ8EUPkex8TYJ5LkPn6v8ewDyyPGyVJVUsGQYpcNnKJ9D6trMz0HxkfPhlu2LwxSyfmupUHcLOyQvQfg+zUvJ+BbnXfb9Vo4uTBMosbGQ07uNCJwzUIv4SiyIGz4EmGfEbJN6vN8ELfhgVk0znBmEwNMry7f9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r3GQJ9Vxc/4UNsCVWM5wsksdzRPjgLrjtVKwqZy3hyo=;
 b=nUNO+mVhc7NsWv5xTEffsxHz/trPIOMmU4ysWpH9t2U7az9IaFIyTo5h1SXqI+tkHtNExQBuS+6ut3VT2MYPZz2POSaLyTkGtMB56aICb0pVGo5p/AxRAS6i9nAvUDq0O8pahC4cCZFl2kA19DHMY2W/61/43Z1yk4sNSXlTciM=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by MN2PR10MB4205.namprd10.prod.outlook.com
 (2603:10b6:208:1d3::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Fri, 17 Apr
 2026 23:07:54 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c%3]) with mapi id 15.20.9818.023; Fri, 17 Apr 2026
 23:07:53 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, virtualization@lists.linux.dev,
        mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
        eperezma@redhat.com
Subject: [PATCH 0/4] scsi: Support devices that don't have a cmd_per_lun limit
Date: Fri, 17 Apr 2026 17:57:20 -0500
Message-ID: <20260417230751.117836-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0155.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::10) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|MN2PR10MB4205:EE_
X-MS-Office365-Filtering-Correlation-Id: 58d56d16-b1b2-444b-8ddc-08de9cd627c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	FjPJYRJeRJw8M+egxHdqtja7ZLQrQ3MImjIjF00l/pYtmnbrx6t/kAoA6IGLVRYD+tgLZ4+yQHmtlbqz2mcxU/LxdlzpiUo/LQDpHwpSRe0/oeVZx8L6T1A/WoSM+uOhaqmmLHNupp+xUg4LBz+cTbuV9MNz3v83v99/o+hsjr5I08R/8S/1YS6IBwzMXwVJCsIxJEeRl2He0UpFFNuNOHDyC5S0KM7HFr1e/4tMFb+tu3xa1z+BIoXAh/M5QwrhGpdL4rQQkUBJZvzO9EaqPOmXpQmfZvbHI4iJW/6QycZgyCt2Wv3VjZVbmOtLo/UaF1ZnfzQwiZgV72ci3D7NzpQZpbownWy8pAY3hTwUOWF40IOokYUx4rvi1M3v/iHEnRATnV8RwA0ed5zAYIUgpbigBc8rPXIdRQQuTHi1e6QvjwSRgQb7BeMI4M5aWXcl9i2Y9uSBUC7AqQpPnHtmS2ZC++wO58y1NzzlB2k2lEfkaDl5lDG4IKKxp3gbiGhPGlY0RtEEBeWJIfEwJ8aABBcish9QzMFKHA0n6OD83aozkitEStMpHpvNXmZDvcsZdKPfC7KRW1LkNJVWbTD0QnLqozpefKi2e+/e44Ajuued/ozTkm3AB/q3pdQyCyVWGAEXwJYmK27MLFFie/IZPwkuJta+NVRg4dH/u+WrtAklaqN2hPxonQEX4uegxGjiAyxfxJOqAA7CPUi1dKIJZldDSIa54FqlIfWnNLpqlmo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pFue774dYIeVfKc07ktT5Nce8iUBkYtLLezegM//07KRlMKC+2nYLRPTr3dk?=
 =?us-ascii?Q?3zYsGl6CU8INIH0X6UhtSJCZZKEgboKlDb0LlDCZjtxfR3NDHTFMTsuWk7Aw?=
 =?us-ascii?Q?i2EZ0MlKoVINQk3kn3vz1koAnh/uusmEXyOogfd78ZL71L0s1J9AD5oQRz7A?=
 =?us-ascii?Q?PAzcL/oTd7JymyaohQ2GvRkbwm892mK6q84OEkO8lkW69jXHXNu1B3GMs77j?=
 =?us-ascii?Q?OqalIVqtD/1w/4FbeMknamxzr8Jg0sMIafvqEpE8UP4Uh7H9bCnrNOSWGE84?=
 =?us-ascii?Q?xOWDkqILf5BffDkl6958Y6BGz0umydPWXnHQjN+MusqxhipaWQ21Y+LFp7F7?=
 =?us-ascii?Q?Tnjhq4KSL57nkGkr2v41AoI3eQZB5qSrvrScq4irc2B0sgNNSMKPNIVMdoik?=
 =?us-ascii?Q?Rgyh4l9gmNKZTkp9/iy2sV/MTc6NKViqb8x52DtZ/zGGTWh9nxCFy5F12Soy?=
 =?us-ascii?Q?I2mX/iuRPmVACfN7uF2aFRh/82jh4ygMfWnA5k6xSk5ZVILyxgInbRvJX7Lo?=
 =?us-ascii?Q?MpvT257yiR/HZsG+VMwdQvvvcCCWy1zjwShM0NpGESEOG1UWkMXt++4VPP0h?=
 =?us-ascii?Q?BlL2rtZQg8NhbhD8FpELboRiBDGplw8PSVsBHBK9FFknmA5oWhxRjB7WS+9+?=
 =?us-ascii?Q?N3etFiFCQZy4pUL0vdihX9kt5hNA62nHGc9MeMFkz6wdrGOg//qEZU0NjQEZ?=
 =?us-ascii?Q?c3fbaO6KyhLK3EiLAKYQWMZXauILn1iRtk06YbDU1Qi+FTgdxgCwerKwMzea?=
 =?us-ascii?Q?8yX9WN3sMvdZo8G9uuj0o60wApA9oRISvr54I6SB3plxDZTivIwBo8obkIVF?=
 =?us-ascii?Q?RO79kSq0UuXqKrdqRpoWdBXY5W7F6tCtBXA1Q4oCM0KY84N9Cr5cJKTPC1Ay?=
 =?us-ascii?Q?y6SVa62Gh0ZCLu/uiPoYG6z23eR+kH+nJJcFqs1OMmt/wvxH7hRbBkENg3OM?=
 =?us-ascii?Q?vIRgkPO3qW9rzlaSg1P1WKZOX/5mmQjreaCqevuz3bx0fEJHhWOFKT1zkLID?=
 =?us-ascii?Q?o+ymU4xwyV2JLoeBKRThfliBjGQFAQqxoX6kXVGH1pBfr7ySvX4Q7xRfDBCJ?=
 =?us-ascii?Q?FUZ47zKX1ygFYa0S8Yw5h23Gg2IW29trmy0WrvgrLTeizs+i5jbDT8U0URZn?=
 =?us-ascii?Q?7pqAIjWa2SlBX3l4cEZ1mmiGjTrpb9bfyI/Bo13h5OkC7wkVOk25v/Yd1Uzh?=
 =?us-ascii?Q?yWJKXRe9UQXXUj77vGeV2zMIEbl1cVaD4pBc5dHnvhuECgpoHI1KdTFPIl4j?=
 =?us-ascii?Q?pbyKXMVGJd/aGXnq1iBSgvzXpDzz+fT/AdxkTQ6+NBOVln3OkZ8SyGiwLiqR?=
 =?us-ascii?Q?wz33fRtAwQ2UTRtokBOcB3Gh86nzaA2eqxTrd7ErWtFak+EhLlSryy1On1Cj?=
 =?us-ascii?Q?i9QO4M/FOt+qIQgrOCUVwfhvadSEu+lB7/2obs4KwOYpAeNcom13EUgKSXrK?=
 =?us-ascii?Q?cQw/gV0KdEuEtyfSRQQ6STcm4VagAFLA6lta2toQbJceotUcWVubv0MHidLZ?=
 =?us-ascii?Q?CJlReP9KsQTftiQZJt+S2GIFYWdivTD/TkJYS0A0wRjgOKvgnsQgChN0bkJP?=
 =?us-ascii?Q?K0JRGUOdyVuhmFX1Yl4iFAgv6lTIfIXcdCexcWJoQfWISV3wgXCMlKPm2DK6?=
 =?us-ascii?Q?5o+icFfyp0gBaaIhcfXKwcOSR/Ei425/YtAFtenWqzl1BNsTR94jlG07aRK9?=
 =?us-ascii?Q?isSc2sZKTrIObCEhflVGfX1ony9hqkk2qhYYCiIEeQWk/3yDe6gQRtV2Ti9T?=
 =?us-ascii?Q?GHk5IFP3SUESjNdYOmixBBxgFYy3JpM=3D?=
X-Exchange-RoutingPolicyChecked:
	MqqcDl1keUWzPXh3qWEt+tWfzZCGxERRKDhLtL3zfX8KGnT2X6Bj5hwevDituE+MtpaRWGGQPTipg5m7eoEmL/ufgeSEjuaogwyowgAUBeLMUvG90OiptKmzYlzZApMNzU7TdGSzNgDRF5YsWy8nj7QGxSaSfl72wu3g6TwNANEjqYNUa6YSj5KYQSiyemWVyI5sYkV5LR/djxf22GsQaGAL31/Yzpa1FhmLtYUPkBCLsH/Zw0d4awfmiknh0uLuuGCXyPTnhYimKlIjqAlcCODhrwVa8YevRjSfe0gx8j1EQuZbaPurMBJqlNZvzg62c3CtxHhmXeJd3hgzFV25kw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6PoW/r06UW5LsaOG7iPM+w1spYgr2ljwjDVLSsqaNG9GKN8mgduRu3ITtKwzdAYT3solROB8zMiZ9XK9hSk/uTToDWMu6yTMgwgJZ/0gcbEYWShNeBD95TchWFtmW+nHdpKtuzwQY/DytAIg70uCXp5mb/BmHv7MSTvPL+xua7Ev65zZjA7AzULG+0BqlOWxWzS45hvdCmAblpx49WxsWVUSkL0cnOXaslf3eKm1ItKgcPfu7Ow2t71rfndNCIH4mMNMYLq1ZYxknLrI28XI/JQAa7XeR8kVgSefP63fVs+IIQXAafpSUVb8fZA9tMVC4xvflx/hVrifuX6sREW5meOwwyVZAAhi63P0C2NLYZQAv3oWl5zXaewp2hfhjoruYAuohU+QvswaRe8wOWJN0roFcvbii/hViRLrGMwVnFM1IgLQifUT3gyZLDf7MQ0gIl3sjMtUwtHlJiR6pq+wWUWTBfrzgGD40ZL+iBbj6kATUNMRnYtC9EgdGzF/I5QwcEpD6T2t6iNAOo6I4SGJ2mAOGTtIEXE1ICRtgeUfM4yll3VUviBnN2rTTn4bifk3UiYjVpnrvP/LuGjB8JKu/8BKlR8LMUcXgOETC9lq8ak=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58d56d16-b1b2-444b-8ddc-08de9cd627c8
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 23:07:53.8784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bvQKyilE9Ih0aw7jWZwdFmKVe1Lk4iJNasxqkvAPB7Ra+vJ4NHr7plXV3Ab4TPxxByHcTRpdrXBaQwR+mZHrz+QzUVDfCSZYqja5/bhg8uI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-17_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2604070000
 definitions=main-2604170232
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDIzMSBTYWx0ZWRfX67rGhHvb612A
 3ZG26GudCbmp1vwC+Z1fTiR3Hdv6EARiozSHPjblU2x7jMkp5dZ7z29j2SF6bK7Ya+jZ+hU+kfE
 418ykn/xJnG4Pfx8Y5XtWvnESbfwC6GG0YcIqc3TOgwL3aLuWev0E574E9C+sZROp35GQiDWS4i
 g1B25uo0CNhzpFRixdc/nsrEYCOUM5B7aUkhAzuMfmLsbKyNWlHjAqY0BHsidpfvwJnENlLMkHF
 oMeYxO2buGAxotOtoEoxVMNizgzPfO3CyCkFaS1QeCazFsrm1S1ahJ57w6+EpuUdxzxQndrW0zY
 mrBVWZwvQZft5Timt0WuX4sDW92MJAjdNJsknCn8NSJxtwxjaiuMvdZPzmKMOhHQ+BGRwLT083e
 dxmNK9/fhJa0JTtqRJpijMDFAOOnft4zJga5pb0rm3KtmqYyj7uBichGiGvndAzfALbK94n/ok4
 hm+zgZSrg8RkwwN8mNbUcb+KtBhg/+61yTGb4HbA=
X-Proofpoint-GUID: O3-5bra0USW8X87jDI2pzBfJ-4P3M24J
X-Authority-Analysis: v=2.4 cv=V49NF+ni c=1 sm=1 tr=0 ts=69e2bd4d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=WBuUaUV0VVPIaIq0ZWQA:9 a=zZCYzV9kfG8A:10 cc=ntf
 awl=host:13825
X-Proofpoint-ORIG-GUID: O3-5bra0USW8X87jDI2pzBfJ-4P3M24J

The following patches were made over Linus's and Martin's 7.1 trees.
They fix an issue where for virtio-scsi we export a lot of non-scsi
devices but are getting throttled by the cmd_per_lun_limit too early.
For example we export 1 or more NVMe or block devices and would like
to just pass command to them in way where virtio-scsi's hw queue
limits match the physical hardware. Or in some cases we are doing
cgroup based throttling on the host side, and we don't want the guest
to block IO when the host knows we have extra bandwidth.

The patches add a new cmd_per_lun value so drivers can indicate
when to avoid tracking queueing at the device wide level. They
then rely on just the block layer hw queue limits. And the patches
convert virtio-scsi. They also fix some can_queue related issues
discovered while testing/reviewing.

