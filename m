Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51592361D2;
	Thu, 16 Jan 2025 17:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737047194; cv=fail; b=mSMmPCe24Uh2735TiO1Gw8KsGJO+MC3FLIGy05hX+0GSmSP7cLicOoAVZZZ7rf0sRc+QrarZTt8ZdqsalAur2c0RdS7FqdbpsyLO1AW2EuhTEx7BMHzEKqoeebXreWFX9fdxN07/VsNbn/o00tmRhgDqDErj0P/PqbZAllbPT1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737047194; c=relaxed/simple;
	bh=WVK7kX8E1NpBqJ91SvGnTE9DNZLJXPr1+93G7tZ2AAU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=D+9BV+bzkrxOItIqn/m2RIoV1cVpc7Krljk+cZAvmD0tlNVSoUsa1Sg9iDxVx03XyDHapDQd/1cVxZL4sA2HwReeEANMgn7H0zlu2GhRV9umOrAOEG6gRsVFxuIcs4WOQPAvQfXU2lnVqbPv71DVlKP4E6n8H2jGbmUYyFa2wD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ATPlvr85; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EO87jqFP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ATPlvr85";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EO87jqFP"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GH0gdj031094;
	Thu, 16 Jan 2025 17:03:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=TCTJVN532bVZAncgKvzDqXBSoXjd/ZmsO8Ixp48uo/g=; b=
	ATPlvr85Xrv5wOlTl9dPSOjfG62134WNqKcXl7WUhxHxVo0YBbLeYFPQpsMiQ6k2
	+gjqa9gzeh9kZjRkm/VhZ6j9Qk1FAW/vetN+g6PnxuNkLrq3BwwT0tgmNuOSD4cL
	N/lKtzNEfWdjnN6xC9dYxuwQHmUUFs2hWVDZZEoOgYgaPidsTahWYxp2XquDL1bZ
	APSQHk8nAVD3rzW8R5/IzAvEuivI3DjKgjuCSZAuXARw4y9fAP6lVH/n+Bo07Y7n
	BKN+VR+Vz8ibCRINAQQxudgd5k+/4+A8P/ivIHJ2jv25Yw9Doeu0IrZpNmN27ZsC
	Kf1sR8vvBCB3YdipsHtnyA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 443g8sjr64-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 17:03:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50GGKEfN034967;
	Thu, 16 Jan 2025 17:03:43 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2049.outbound.protection.outlook.com [104.47.70.49])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 443f3b24qw-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 17:03:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cnZ8pObg2WoiT3uRcJoZ+pKMHvOaehbSswJjYJI9FOtGCmqYk4eLvc6/ICWdRR3rT9jN3PzqyM5aYS9NVVPBXLTj3xviQtN4TiIVhjbWJWFixQ4+BNMpvQ3l5A1glfiTcXfQG+5f8VFuHBUiGleUiKNJbui3dWSV6bRRcZh5qNfWGWFxjVbNue+ULvqof7ZsF0jUI7C3SoSBT5lmiBFRWd0/Q1gNkN0sKul2d44PPpBxN4DDC5lk2GJ5GTwRm6VbevWA1/jKhuypr2JDWhEmWdaNdyrXvUe68pz9Iq3rgrSvSlSmxcJUIDHWAf3+x0MPB0sMeO9j9IJAKfsNQG/VrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TCTJVN532bVZAncgKvzDqXBSoXjd/ZmsO8Ixp48uo/g=;
 b=mP+fuvMUy6XVBCr+wrjA421Kmyur++qvkBfNXMYjekXSoRX2fkicNnLfjCaVOQ7restiiuPhhQXsEIgDcDB6mCijLHgPIOIDQwz+Rue2ttgD73zBco9pYSiXRJ0FtTfEYr+nxE6HjBRNznZ0oKLm1esSxwKnY3to1wI9O7qFz1MEQ+8CYnklnUo7D5qnAS54jLIYpac/d0zVROdCubEAXkFn9Kl5xa7g5WpNJPZHSXBkSyKwkcshguGg5dYZTSeWUSB10OnhzTl3kwt17WHaD84wYSNCrUj6uO2wy9qPdtPi6Fnj5HW83VopOaYOEzxttn6SRSfbCn3XqmrEvQcCNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TCTJVN532bVZAncgKvzDqXBSoXjd/ZmsO8Ixp48uo/g=;
 b=EO87jqFPtco82J5yLo8NikPFo+KyrUyBHgd1foats09TEdxF7p0wLcAbp7kB4rJM1N41wuvBPn4020eks08CDfqZRTrERWCnPHPwUG1lgFjUQ4oVvAC/1bYgrP7VT4MrPMlNAKNFt9xS8YqHg5nEkcGLTjcSmtMX9wti3tf5JZo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB5829.namprd10.prod.outlook.com (2603:10b6:510:126::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Thu, 16 Jan
 2025 17:03:41 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 17:03:41 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, mpatocka@redhat.com, hch@lst.de
Cc: song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org, sagi@grimberg.me,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC v2 7/8] dm-io: Warn on creating multiple atomic write bios for a region
Date: Thu, 16 Jan 2025 17:03:00 +0000
Message-Id: <20250116170301.474130-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250116170301.474130-1-john.g.garry@oracle.com>
References: <20250116170301.474130-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0050.namprd15.prod.outlook.com
 (2603:10b6:208:237::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB5829:EE_
X-MS-Office365-Filtering-Correlation-Id: d0ad238a-da47-42f3-05bf-08dd364fba86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FbogFAk0xC8Ao5Nf6wMKjEbhAVImU+QMGJ5ntNcfeXtDFOlSC6YGpGs0LugB?=
 =?us-ascii?Q?e5KLr7Md3A6AsFqrwYywsXAWhj1M1K284/YZxriUBPOY69cZ1wZxw6Xkm43f?=
 =?us-ascii?Q?fPU04YU2qAcvrqpw0zWpkp+9tWTT+paTPWEwr8TJJIVf1i9q5TW01e7xo6n+?=
 =?us-ascii?Q?BUNC1nYqy5bArclzT95kdq20GhoP4o3oL309Zw022IW9QaQO4xVH5kkkdQTi?=
 =?us-ascii?Q?L37uwXWmKYkmPVX9kO65lPk4qpj3tSXRsbUSjNLMx2rKxHm7QO8hRBvhdzoA?=
 =?us-ascii?Q?p/sfAF3QUxJUYxyCb8FJbaN4l+l8mm7/2oAbYsy32eYGRfwCR9LJDPlfuFak?=
 =?us-ascii?Q?2//ToFmhK4Xd1YhVa2sPTfQcQgJ8mcxNLe6ub2pc8eEoYIdBVSo6O0L+NGd6?=
 =?us-ascii?Q?0Yfx95oOKGxoyu+aA9xtrvdXc64CxSB9Wp6xIQB5C0AgRbCRT4Cz+SOEPfN5?=
 =?us-ascii?Q?sKOqFFhbV810jbYrXo3cDm0CTtW/8qflkcaSITv2rWaaL5Wf9eOyiOU4lO2r?=
 =?us-ascii?Q?APk5fclaPUAadqBftEC2tFhRwBUa8XLFBCOyUVvC4HzkUYRXlVUJ2naLe71Z?=
 =?us-ascii?Q?9wUi0QCTQVGx/ZeoQ2q9Sg4t0iMP+2seL94GrGk2PVzjX+8TO0fUP2dnfFxY?=
 =?us-ascii?Q?9aWCvFl4vm4vXmZ7r5BPrA7GB1PYXyAga+Rb4Psrba4zHXDlUNTNKDwgUWpB?=
 =?us-ascii?Q?bvGozYWkIf/C9rfP9NCKO8Yh2nPoxEPN4mShdO++E1YBXSpZsrBDmHhi2Miz?=
 =?us-ascii?Q?mQvG/qzAPX+RzyauNQFO5Lo/+DA8O7LSAqFO3YJ9nW62miF6uDXzKn4/PLkt?=
 =?us-ascii?Q?6jIrijkeRPm+UBA/vFz3CqV+nTiIxgULMrJffN375SW3DkUcHfzUr5EYWbjp?=
 =?us-ascii?Q?n6d/GafcrdPa2kNvNrXAeHpuGdgfVAoaJRuXhIqjsiRogM2kf/x7ViYGBmnD?=
 =?us-ascii?Q?/N6O5hUekRvi14sb9xHgGp40GqNqSNvv1baeMCLwQ4lrT+M7Fi25gbCpF0Mk?=
 =?us-ascii?Q?4A4sT5W3DqknXPc7bBR+/DlcddMw0sFrbNhX4+ts/p2TK2wCMpX49zqr2IWI?=
 =?us-ascii?Q?UlO0M+Sg+zcurvQK16Qxh1wd1Ge/IW0W6/vXZPRcULFh6oeiTKdP4M8Tpict?=
 =?us-ascii?Q?sJMKQ+OeIo9swJMTzhbdyWYcmgA/jNxKFBqX1c6GvoBDIDcOCVsf7sORouRD?=
 =?us-ascii?Q?X56p5meBbqxYLvxXjqvTfkrgGPzdI6mXMQcbG3d4+B6IS3Wr0S9sf0S79ire?=
 =?us-ascii?Q?J8qVluzrioL57iUgkVp+kmDXbF6MM5ti6c0CVHz4+60Nnus6cHV//puoUdRr?=
 =?us-ascii?Q?5L9vOzjDtXGb0v/iteqb/VLcIF6AS1CWXxcPwluVEaPtMB3Wfoiup4/51YEy?=
 =?us-ascii?Q?YbaPsPdBh7p7XhE7/bDBs/gNxroY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UriOZ9nvUW62NTPwUFNz1LX3FdcxheBMFn4z6M+6gJGwWo5oRNrPV255fk8V?=
 =?us-ascii?Q?OZnp739ai0umOc9LRY4Pcfmx0HnGMakRO1/t9PzWY/ZO+jiJ0df6ZcRgpMG9?=
 =?us-ascii?Q?BU3m1xO34OiL45CMvZgte8bWL/p0iUdffZoJXREyJEw1LD5YbgTvZ/mQCrTo?=
 =?us-ascii?Q?ZsEHhHVIjBB90IYeA0rCCHIhIY4s1xhA2EHXH4mjrVt3WjsJcm1iuwPoVUr1?=
 =?us-ascii?Q?TNPacBTXVYJNeZJB9BtZupB7bY/3zxJmmBmDicbzofGnk/BqAsE9dG1GJT0x?=
 =?us-ascii?Q?O0/ckw/hxO2LTjK5aRZuLtUYML/R0I0mxwkM9tuugvlxc9u/oA1YQgbUaaDz?=
 =?us-ascii?Q?vyp2NNmBXMpBQmOBz+EETcOT8lRozPYe0Tv/y9fMazGlqo56qehlULJuvcSX?=
 =?us-ascii?Q?gUmM4HYnfVrBUKIGWxC+LbBwzMyLgKA0lIBUYCOzeZdfiZ1D41ysIkOFc49q?=
 =?us-ascii?Q?YqN8Lq3FJx2pmtpezAq1KKbCpyDk+e9SotVM5ljrVfm883h8UGskiPvV1f67?=
 =?us-ascii?Q?Y3tM+YZ+8zeB5ekh0kawRzwFJ58l9j/OJT/v2mc++UkaljoUXd2A1Jzb1x/U?=
 =?us-ascii?Q?RnVE/U6bDf9Zb8iJrlPKDS1ZS1WEkxujAraJtLZ2Q9lcPpUfwSEkRgT5MbAZ?=
 =?us-ascii?Q?AIWMzOeAd2m4zdBR9NhpuxByr9ohJH/ISBpz1QJT6I/XwqR+XoCkwoOCv/r9?=
 =?us-ascii?Q?9xX8FLmNjQC6d/hvmVccv80fXC2q1WFSAjmhSym7Snu06zGL0uLkRYXrGLJ0?=
 =?us-ascii?Q?RzVS0bDuSH/yyTn92nSZqumcS2gZNjRy/xx5kxTdSLJRoR6jlSlZrT6X5OxN?=
 =?us-ascii?Q?xGFrY/Qti6eif+pc3mc41cw3CVgytIXF0tLgu3MDFGz/YHQ44NRXuVCfjTud?=
 =?us-ascii?Q?DdS8fciNOjIXYlO2l1GsKbaw6AYmJ+UUj3NkgAgKGqWbQosB3/YfclgZPEN8?=
 =?us-ascii?Q?rcPFGPJgK8XJWBW5fVKsyCEGcjLMvTPI0liYE1jwlmY9xFL0vNM1EOy25Uil?=
 =?us-ascii?Q?huHQVk/uXaCN9CUK7IE4T3+gBsYYCx6Di59eR3Yvk5fO3BE9Pmb7pHG15wsx?=
 =?us-ascii?Q?UbjfF5dpRgdC/ueopiRHN+Dh4eNnr5dbP5gyb2EuJzKVCvpCtjjGSNJ+oI+Q?=
 =?us-ascii?Q?LZfEYPZghGmbHLSo4fgcjUx0OXzwwImQvchPe0yNdG+N6XvaseluxjcqSYjs?=
 =?us-ascii?Q?rVyxUYB+tTz7kjuM0Q4X9JNPqdaQa5XumFaHG4fGQVHKJR0ic6verQUQ0nND?=
 =?us-ascii?Q?Tpo3aN0LVA9vxf69WREwTq6JgjyVsoHgX1k1LE76rG2ndQWZhuOY1rTzsiMx?=
 =?us-ascii?Q?qi7H6ZIumcPcIjiSxkxXerfNvUUcv2PD6ZWHVyXS/MNsB/s7PBkCDViCO6eu?=
 =?us-ascii?Q?kpIoorfQrFiGs7y1RlmIeS4IV13DxEo0oDDCiX4P7l724mOjsBvceyX4nyVx?=
 =?us-ascii?Q?csJcWryfr2YPQgMTZhnpHwUoKu9io7F5kfOXWOp781UjoG4g4yi842Q4sm21?=
 =?us-ascii?Q?zyCE6oSPq+r3tmWpQ5WMCtOES1jzqvG7Aocu8+YdK04SgddAq48Cld5CAp+h?=
 =?us-ascii?Q?yOpBSBdjBpjXTi3ra3Er2dJtTd+wmzqxGwQoiGuQWpwk45PzCgWFodDwfvIL?=
 =?us-ascii?Q?6Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WPANiRl1duq6ra4ll7UhWAM0g0b1O9mwvCs6PtKjpXbKX4J+8PiydUs3Pz8mIdbFPt16i+grnhllNmO3evdJ4XDWwvF+xlQj/PRmAKJ57CPcbrlcrLCiwlmphkJQUuxZd/Jpucwc8tSiAgHhLVgm3O62kCzvZZIZVdu6EHnzwpmy9AMwkDE89TFGWs0QAJ4dN8ejx1XeiL7ETwnmEjz6teX6S708U4fHJJZKfGTmzRdAa3/5huQljs110bQ7wqEBhIPKkv7Hw/aH039PvzM8G4B7AYiyyooZhmVDJ0gYDvF53SDmkB61/h3V58sNcoBzCoJ6obAyEBElk76511EwNd0vEWcIGPw8a159cX4dwtXV/yoamfVKkx6a3YfTxfQe4NihEgxNWG1IXrEYeRdKxCpzyzdYm/GbmeYKworbUDChZ6eKB6FuVvLZoTzmpghxvM/WwmgSLjMu1DZc329lL5t4E5VKEOQg67fydB+N7XWh94+OQYLxTq4Ktn/zmxVjJqzzm9dDECGbW7ShhYqn87Evdx+xqPnY9uNNuTZ7AVikZRMs9/d1UNWRHZAha4JnOvgjiEpk32PeI6ILiQKCy5LvKPeodNE8KEIPalQCwoY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0ad238a-da47-42f3-05bf-08dd364fba86
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2025 17:03:41.7207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2tqP2OBZ826d9/R0ekg/M+yNMZA2T20lVkSNEtgd8Ccx4cIiOZBLrRjdomNNSnB9cMPXZItfZKxD2+OCA6L1qQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5829
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_07,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501160128
X-Proofpoint-GUID: pS9oUmxsKtto7_zKcUfvbXYF7L2sASmk
X-Proofpoint-ORIG-GUID: pS9oUmxsKtto7_zKcUfvbXYF7L2sASmk

A region should just be for a single atomic write, so warn when we are
creating many. This should not occur if request queue limits are properly
configured.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index d7a8e2f40db3..c37668790577 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -379,6 +379,7 @@ static void do_region(const blk_opf_t opf, unsigned int region,
 
 		atomic_inc(&io->count);
 		submit_bio(bio);
+		WARN_ON_ONCE(opf & REQ_ATOMIC && remaining);
 	} while (remaining);
 }
 
-- 
2.31.1

