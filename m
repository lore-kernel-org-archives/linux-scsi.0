Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B752550AA
	for <linux-scsi@vger.kernel.org>; Mon,  7 Apr 2025 18:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744052151; cv=fail; b=LGyu/p4LOWsG0esxae6+VmC1D2TSdhfloxYKGeinBD8NgOCq9WnKwChm/0MAB1U2mWjCGFsmJwh3Cf/FD9olk/Qz3ZGBuppt2kMAuNYZPyAQFvd1UnOlR83hHvh/6L8T9Ri8TisrjfUVBwYK9r8SX7luoVWlEEThnMn5fphLR/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744052151; c=relaxed/simple;
	bh=4ohADG7krc3tEx153xO29UGCgsCLWwiB1nayVyqeqhk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=AUz+OLl1Nrc3CDqKCHWohmXOmfUfWItPR7X/5mch0RxdUOafCr9yfMGFVajOWiZzByMc8SH2VLFI8ZstbZyF8ASddDf36e9kAIbVdX8ycn5R/NbQ56bPIntKW7YOubAW/oI8r7PNQLXhywQ0DRqxcBfNLEWRZNaEfZCED2XwAz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LaqVeeNT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oJmHYtzo; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LaqVeeNT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oJmHYtzo"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 537H0vmN016513;
	Mon, 7 Apr 2025 18:55:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=t5VnGxgaDEBs5pxn9c
	N5CXJY9b19Auwsy3USN9KfWF4=; b=LaqVeeNTSXwZwmvZz/cLg0kLqvToswAlGz
	+o49ke3MWNve5mOhduT4Obb0ppVPEE+HmeqPvgi97V7uxmkRmPNJP1e7WaMEUL1y
	Vypix0WAUKtJTQSQQG5tsfgyk7RKZbAJH/Rb3T2ITsKJOX7h+vjH6EjNi3buJ5or
	sN3u4k1IKtHCqfAUq9ngFBp5xxUFfjci8SizjJ5jwxtFSGPAcLkPxeE+gkpw0VWB
	XDcx3SdluQCfcaMiUwDzNsnsLMalf02tRahI1dnZVWBN2nGam9Kd5UW4BAJ/yHLy
	UHfYypetxFij22hBXhKGwPJFdEKoOhLUJh8pc8XxDZp1VlD8rXBA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45tvjcub0c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Apr 2025 18:55:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 537HcfeF016546;
	Mon, 7 Apr 2025 18:55:34 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2171.outbound.protection.outlook.com [104.47.73.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45tty87qm7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Apr 2025 18:55:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G4SgAuOHbE0s9qjP11JcRe0iyKflvgJVwiPA+Is/mRx4AcNizUBMLXfxrYO9J4LLjB4tVf+v7ykTBXOIO+bjhLj26xJ0uczJoNP5DjS8UaQPldv7Up0XkWAzd+qQgERGtdSgX9tqFoL/lvTVdb+30gmtna5QlTlKg5FLywE8DtvuKQfROULe0nbT9J9yeZn0DHhGvxEJoTVXFy2xnMOD3rY8D0aqfX/OmUf6PI+EmsRFEmYp4Z7JwCj3oxsZ/ekipiDvHuaYQh0slAECMy3rSeuSQCJJXi8NN+IJ3i3KwCq1krCOFhsgvcu8a6+P6rFGAm4QZyudmlqDzIYaG9jd7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t5VnGxgaDEBs5pxn9cN5CXJY9b19Auwsy3USN9KfWF4=;
 b=HHZpegyC19DqZslmCX3yvWhHQO03sxBCGBHATwatdMSMfWn9tMFlxya2TfjBpsCn1ezNbJtqPINH2jOhw8z15sxq3U3+fmrotzjzWaX03ZG+ahCGk/zE+uuqpTPM+/HYrxWGROz7Xvez0uhFmsx8UHp7ROxlSEaVRiSG9ai4Cd+uJDSadkE6MuBu5rcZXA04pUYw18JuXdz7WbfkynkkNIQZUlOD5GSOEGQ/9uC2+nXZDduMedtDLt83xViAWQ0FYA4LNSA7x0VnNWeE3vJHaolnN4KbAPgssdwqAfmt0rpFkIDpoP87q08Au6W9K6RXtlgBQF6I5GwFlyUt2X4eBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5VnGxgaDEBs5pxn9cN5CXJY9b19Auwsy3USN9KfWF4=;
 b=oJmHYtzoG3vYz2rE/4VwmaAqCwyJUaIu6TdSXEAyUFzCdbkMgHBqdXlop0gP/ecNW4uxxuc2BPv8Fwh681nyZjiADTu91Nl8SmqJVNiS7ihLekEa6KTTYdBLQZclXqWkgSwQzurqPmGV+9ixIc7uQ8QSW6YXwCURQQqIaTtqSM8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB4496.namprd10.prod.outlook.com (2603:10b6:a03:2d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.41; Mon, 7 Apr
 2025 18:55:26 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%3]) with mapi id 15.20.8606.033; Mon, 7 Apr 2025
 18:55:26 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Fix a race condition related to
 device commands
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <1c08cc57-60dc-4efc-870d-6b9688c85b2d@acm.org> (Bart Van Assche's
	message of "Mon, 7 Apr 2025 09:59:16 -0700")
Organization: Oracle Corporation
Message-ID: <yq1a58rstcs.fsf@ca-mkp.ca.oracle.com>
References: <20250314225206.1487838-1-bvanassche@acm.org>
	<yq1cyeb9pjp.fsf@ca-mkp.ca.oracle.com>
	<1c08cc57-60dc-4efc-870d-6b9688c85b2d@acm.org>
Date: Mon, 07 Apr 2025 14:55:24 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0706.namprd03.prod.outlook.com
 (2603:10b6:408:ef::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB4496:EE_
X-MS-Office365-Filtering-Correlation-Id: 7af001a8-8320-4c69-f816-08dd7605c21d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nUlu3rZ3bZj60nrOVNVd+MArsDQ6YCox1Vh1q1evwJjVutxNgJDm34PAmQyg?=
 =?us-ascii?Q?GjEUJ1BLUWh8eA8/7Wlqf6elu8Psi2lM5c8fxrrqPFmq0U+rKAjx5ty0d4SF?=
 =?us-ascii?Q?zMXjUIz0/LvyPMZW+H2P/WzFm+ps/qWM99jmjiMfKF/RT+JN0cPhHcmGuJ6D?=
 =?us-ascii?Q?/R4xsCzeG2FoxWHh/0LgD6Ngrshh5NFbynXPyKghU/b7JTuGnZOlI8Ol6fLX?=
 =?us-ascii?Q?86fp6RzZEPGNVuxhVizd87CvoHKwRXVuyidyhfDmHQP/Xe1+nJuvCZ4wAkKs?=
 =?us-ascii?Q?SxaJKLEYKDKZMcfs9bFzFA2fc86nNI9muY/HRj8yiYH0l9sm5GqoOkpyXsca?=
 =?us-ascii?Q?wF5XcDVjtAu2vtVe0XCMolB5EQgxb21+fGBE4zgrMcepRg4ZYg1SXu5mG0C5?=
 =?us-ascii?Q?rKOrBQaPaNW6DV2aNfG2yfeHmYDvmXYOtpilr3OSRsuekaovQKM0QmZ0tU8V?=
 =?us-ascii?Q?UeOVA2UCS5Tlx79JJyYtCqRY4p/XFNLzFXLO+9/6Srv94EEY1Sf2galHBNV7?=
 =?us-ascii?Q?+fx/cjxQl5lVbXyggJCMmJ2XBUVuIzdU8tZ72pl7KopwByvH7/bFaKbYjcGY?=
 =?us-ascii?Q?xF2l90BngxtkVAWghdpIdmaKxg6XgQ0AXZ4AH3+DTatJ7btWPf+wmJWE/Qgj?=
 =?us-ascii?Q?JgcmN3Avrron/PErZKsjvD2BgaFzFiQeac8TqPiWKB2utmaVlRvXccR60Tqw?=
 =?us-ascii?Q?QRskipSe98GSCyaTxDiqYViTaaRmOFo7Njf+Ses4NnJmL91Wh2gRg78PWYJk?=
 =?us-ascii?Q?94UQbbTZiRqOsxiuF71RA62yRtnf96D7sieXkL3pEczbyvXukaW+lAIVUErf?=
 =?us-ascii?Q?sy1vEKGybZwKzyRkWhbk34LPkc6AGrx1t1wyWSxAuRazdvw3b3QfgxGUm5DR?=
 =?us-ascii?Q?g97hgAlw8sStWLZFmKltPfD7iBfj0GSfaJiTC1Z5DKknUxH/ZY2+ZarbIpQ8?=
 =?us-ascii?Q?rYHzdSnLQURRV8j8KzpWxOnC+EQUHoscr9Xr7+OL0WXgmQMzZuGYSmqmYRgU?=
 =?us-ascii?Q?eS8wwG6V74ycUM9WhPO26dRWyz+ZF7g5It2eznLCUhjBMIRw1Ft5doENxbdJ?=
 =?us-ascii?Q?0ZDD92IS0cQC1tA58kvxzWASPf/FG4kXs8DDJ8fNk+SnCwY2ZcHZnehJEKQj?=
 =?us-ascii?Q?Q0V1BucCKGcNa+inB5uXgc79u/QBuDt76+8Q6Srhlj04POs5aYNHSBjEaaQU?=
 =?us-ascii?Q?g5F+goH5H6qpavgsqTjc6tm3gqgl2K02CUNNSZqhUZNKeUB70vnAjut7vqs8?=
 =?us-ascii?Q?pV6WBNPNA9Tw8wucVFskthmQjZ3zSkhSyarasVTMlJHJeA305Nf1kCTmd6mL?=
 =?us-ascii?Q?OLapaquydy4cykP6r4uqRpR+iA/dLBs4qx0NNjkYuYcODplLLOXnY5LfR2KJ?=
 =?us-ascii?Q?S5fYOuY2qQkGJidd++jcx7StcYZkm34ZsRiuyCX7J3ut2kwkFZdqGNX1Z05p?=
 =?us-ascii?Q?cPZRN6YZbss=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x5kGTITLQ7K8fd68HTcxlE+qmK1yJUFp8o9Sk3pLphJE3WI1B261GcjFeeAY?=
 =?us-ascii?Q?Ghf73gd5weKOwnX8dmqw9MDNm/bmg/hd1x/dJPigpZP7fGDTIu73FdzQFM9g?=
 =?us-ascii?Q?AER1xqDJ6WqoszBQXQr49IcZTL34L0iWNKPc7ysXi/ig+TjRbva6SWQVMzWZ?=
 =?us-ascii?Q?hTGMvswv5F0nacknmPmJKG5dVdV6Ah4sRgK30vh90UlTFbTsmAPfCsISqCMp?=
 =?us-ascii?Q?8Lxx2bnEPW4DEE7aKdXBtlVdZuJcqSPM/HuNHYAoqPMwpghWuWVS9vHeTfoQ?=
 =?us-ascii?Q?JOP6a4tmXlaWgL+hFWtP5bScW4bVCFteqfwn2dXPSjiCnc4tP6tQHNzX+cR4?=
 =?us-ascii?Q?++h5GMqca+SiwxdHJHFwD15z0jdpJ7MH/2cUcgWYy9gMpmRDNQpOYqnECrRJ?=
 =?us-ascii?Q?Mk/bKJqu5+u768MrnbBboqBw2eD8Y55CdHKvzP2D1irYI2XyzM9fc9zV75S2?=
 =?us-ascii?Q?1SbTVQ5VM3BW3DnPXwgA0EXckEgJ3LHYNFKMTO2PhAYLFtbYHQvI22jYKnl3?=
 =?us-ascii?Q?2YPm25T+NX/Xc1uj2CBu6GJRN6tXMV4guFGaEobFoRqyuwp6EAAakBKjymB6?=
 =?us-ascii?Q?4mx2S0YZ56IciCV2Hb0aEnF3nn6tfpmEP1bO2HjwUbPiCn0hZGs48SZGhi8O?=
 =?us-ascii?Q?UdDFVuS0D2hKmGmHRhz0waeJ6SQe2Pt0M+Pw7zRvQXzjN7iQRSbhSlS9gdh3?=
 =?us-ascii?Q?BDao0/QrMPL4J9UVo+hla8SKEZf2qPYrdR1NIDUDW+SKKlE9qqp1cHuZTeb8?=
 =?us-ascii?Q?VGuSPtCJvhmon09EjOy4jipPntHFJ3Uxx1Y2orA59CfAu3KdMOGwU/xqqnsv?=
 =?us-ascii?Q?bZXxTShWrxJ6SxA3YQ/8yvNMfKZsd3rquTIgpKnvy527CBnGrPJdoy720IV6?=
 =?us-ascii?Q?ZunyxTF4rHATj+myXd0vQWfatGOg3qWRGxahwYY2/FgCSD0Oe02XBCBNVVgk?=
 =?us-ascii?Q?6hevdwJ3IuKCsqdVAoO/0nA8OcBURrk5/HRJTJ9pY8i1dSp2hJQmTynthVlD?=
 =?us-ascii?Q?ZN9/lSQQFiPTZuSNO+kLjdTxDwh8bxuxz1QG2mouUn+jtM5UCkrti3VSi2oZ?=
 =?us-ascii?Q?FDIZaOn5a0wKhni82gWUDoBCQKz4tXUcKLuz06O1CzOsNqJYKq17AmLat+hQ?=
 =?us-ascii?Q?SWELLLZRlBujuDO+/6h+QWIpLamlfHU79ha6ZcXfOURPpmA7kwlt+bQZ6zsT?=
 =?us-ascii?Q?T92U/LYcK5MWlFDoTzZYnrxeBX6ydAJL9pJ0S/vY9jBi0q3t7wD5d564o+fr?=
 =?us-ascii?Q?2YxAXZnLX7gbPQmwANT6mF+KsstPD6WphIVZgaol4+611gihEZBcrjbA60Z1?=
 =?us-ascii?Q?hmwdnBd98EiWURe9r1prUZC8oQPvuaLdMwX6yqmtlyczLCGaA2j6b+90Cmf4?=
 =?us-ascii?Q?liao3k4YEsjMpUaF/TgS73XKxdwu+xxr13+RBu6hM18yCalXCcgRE6uxD57y?=
 =?us-ascii?Q?Ymq9Og2elRFWg1+b4jIHw395JZG65YZaT4YtgeS1+Uh3qiQAtAGIBlKzGSvz?=
 =?us-ascii?Q?LUCu3PqGkmBFlC0FrW+EkctNU2XBbWQx6aDPx/X4XhXjv1Zm7YCAdfSnf+eT?=
 =?us-ascii?Q?7paL89+zgEb0E/ChxV1LkBtfvl1pLSDhqeLQsTV8Zbgq2u1lbF0Mo9tbr7Lr?=
 =?us-ascii?Q?Og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UOjHt8a0VTIKsQ2kqEYnSkDKbQbJXNyYgK19ZDzgLt+vqnZcrhKvZ92kQ3RQOIIN/TEZ5fYO/l7JH5O1HEh054cikFEjPXFTUNCUU17DbdvLUFKdQphYkmzL/D1PZhex7bQlW0wrzlSpY82jULRsryf3fhUoK52qdc56FuOqIcQuBgKzeSdWE47sjl62doKuZ8Zw7eh4j3iFH+wBLg4BO4FgVVgA6U+y2l3P7lNhVNqQ242S8J2bv53Gkh0dKW6UdRH+DNR+ZLNM1av5YfMbCiamuXR0HtrHBx1VXlvrkludTXmLLHLfy6Gp56kHhKAPAokkZ0sz4YW+KuE7/BlztwAfYM1EOeX1oU/uWlAGxcy8D7K0jw1rrctS3PM0k8uoN3lRdw/WaMt6+x5n8+FWkvIOVrRNO5dHQP/vRM41Fxkkd+6A5QJmTb54aZKv67tZAYJZJ0eWNQjQXiDXjD3yi1rDRCNvMz2sH9TNufugpx7J/SKszWrnoS5X370ONmRUHgt+bcOF1wSt4UGyhyi4RFe8iQeHDLLTy/QAxpCrHTLX21zrwr7M++efce173Vuts548bfmR3oBDYKTarAPPv1hF+NEAH4WQIYjOPepN2RY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7af001a8-8320-4c69-f816-08dd7605c21d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2025 18:55:26.1345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T4cwNK05qOWblIq6Nr0FfO3dZAJyYoQ9msHiSmhms20dlzIAWhRocuB5uEbxq/N3XQS5ctfWa4BrMQu+hnJpLdRWWKF9EiyIKN9WpPFGjfw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4496
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-07_05,2025-04-07_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504070131
X-Proofpoint-ORIG-GUID: DCM6-tTEVw_MnjIitSZalmz0DC3GJUjr
X-Proofpoint-GUID: DCM6-tTEVw_MnjIitSZalmz0DC3GJUjr


Hi Bart!

> Has a pull request already been sent to Linus for the changes on the
> 6.15/scsi-staging branch?

scsi-staging is just for seeing what breaks. Patches aren't considered
submission material until they show up in either scsi-queue or
scsi-fixes.

However, commit 20b97acc4caf ("scsi: ufs: core: Fix a race condition
related to device commands") is in scsi-queue and thus technically ready
for submission.

Is there a problem with this patch?

If I were to drop it, I'd have to redo a few things in staging. I can do
that, but at this stage I'd prefer an incremental patch.

-- 
Martin K. Petersen
