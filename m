Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8F5126F0A
	for <linux-scsi@vger.kernel.org>; Tue, 19 Aug 2025 02:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755570817; cv=fail; b=ayKZ2kEOuFzw/QTe3pQO8kd2eve+Xei46vNZFNo4ML2X3sCq1OG6kmnuaYUc8oavWTbDMgXtVUaa+c5sd9sr4HTlQjC9dUcWy/CapY6Cxo/529Jgg4ddz0ARysRiodZMlB3usnLJ9zMjK274PLWRUKeAEf77/p7lwpPr6A5AwzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755570817; c=relaxed/simple;
	bh=yMPVU+WAIMsUYhrdhDZ5w/IiXCGJVCOWXfyO9iQv5KE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=DyuGHor+Nv0IPJlEQ7Q251Vmds9gdzrilmS+EyHDJodMf6M7chZ8a2bvzSYkflLocxNMLTGKX7Un9HQAEEL9NPsCYAJxkEnmsoiWj/34fIJo7NFI+hBBbiwzePKP27dS/1lDoawS7xosj7ulsX7FYS1caeQVe/wE31vExgZCTeA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HjODmNgD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=y7qOkJnZ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HjODmNgD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="y7qOkJnZ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57IJgYK8012996;
	Tue, 19 Aug 2025 02:33:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TEf032COCPoSzbASnZ
	umbkdyows3eSzmwgpLN9A9ELA=; b=HjODmNgDH27fitUHSSctfWryrsDHMLtqd/
	MB+af6HWQNYxyWztuQ2oapDuRDzQrvDDqTFERQ+iJtgmS5M/Vns5XXvMVyrK9FhM
	vjTs3ZRUkUOzEM8DXtC7ubvuTuIDutFjMTe7fGLYNPOSwupY3KE6sKTS3u4TduTC
	GUDr5csUcloI/mEk1fF1MZghrJVxcxdjFSPk7AmWaapkpuQsNhORyY+jSyYhpkxS
	0zdFj4gT4yOfWnTjm6MF9d74LaZjxDFdO92s9N816Es2eurKh3PcooN/+/q4Kp8L
	PdRnhabISMLpOeuqQTfFoS3y1FXhhwvK679JAMyZgMtdR7F/HBUQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jgs5mb5k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 02:33:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57J0W7RL036849;
	Tue, 19 Aug 2025 02:33:28 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48jgea9qhq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 02:33:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xUI8E3N0s2OP/f3nl0TuLWuUtJRB4xsnIxq1NclqzxsYes0gSfgII+Rf6uhzwxM6SQMpB5fzRkhj9u+GGrajYvOe9kJb3pFQUbHmFvcMZKIZL/izQK4QrS8KClRVcCpJjW3MdcGAfdBQQRTPqEd2eVKjHZ7RaIGuby0vZrqCcYEMxJpGYNC6wfFLrPwBpqNrMfgYKubSsLSPV9tSXfWzZx8tVJ8Q/S4z1lGzf1TttvgYv9e8Y97xC+gUq79tC9+PPcPe0ytP0oIG5A4R1FUJw+Q6fUH65HeOX3e86KBXdvZXJwbtZcKy3pnX9o5doezmtAtoq4yxpg5ElUWlkn0dpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TEf032COCPoSzbASnZumbkdyows3eSzmwgpLN9A9ELA=;
 b=LnfVdNkXV3Kue8QAxBnrdGs5CEjrLOwprEWv9PuKN5erjij5iZ6Y6qSZYmyzp20FqjqzNv2BtbZ5yMQDRpuNpQL+Mj14zpbeodcyqHt3XNIBOduWR498yzlCh/UMdLjjLkH+M5IkirFFjQuD+hALmQdhG4Z8p2PqGs2fc8EPlJUb7xYF6/TxwGcQAkOG34p4PedXwqtXNwtOoHQCb+Fw5yBQoSTHmgMIdAoUe9bfwfGT5SLNInIVLCCpFi9Igrl1PxI6mHcLCf4ulXTs8bFhCGgDw38VSseQS+nt55dXq4Nxu3Cc0Tsrr8SUylTP1eQTvCn0MEZ0/8KDUW6FNAjOpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TEf032COCPoSzbASnZumbkdyows3eSzmwgpLN9A9ELA=;
 b=y7qOkJnZIrDKlBG3ZkXhDBzJvWeHnVX3cn5rfVDD9R6AXngkCFEXV8oucF757upsohw7RdDd2Q5Y4EhpsGy0hJ7TmOJ2CD55IhVzqw25RRVNH+RN9mnXvL8+P19i5x+1W775iW0mOqlYnyJ0+7jLnmfNW8iEHaIjPxZYugWigkk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM6PR10MB4153.namprd10.prod.outlook.com (2603:10b6:5:21d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 02:33:07 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Tue, 19 Aug 2025
 02:33:07 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/4] UFS driver bug fixes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250815155842.472867-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Fri, 15 Aug 2025 08:58:22 -0700")
Organization: Oracle Corporation
Message-ID: <yq1jz30xcq1.fsf@ca-mkp.ca.oracle.com>
References: <20250815155842.472867-1-bvanassche@acm.org>
Date: Mon, 18 Aug 2025 22:33:05 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8PR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM6PR10MB4153:EE_
X-MS-Office365-Filtering-Correlation-Id: c5de0892-60d6-47a6-da6c-08dddec8bb46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RKYGeb+GOjkSOor1gEwL5Pw4sklkXOwxZZcijZwaxdZCN964rmwr9zUJTrf0?=
 =?us-ascii?Q?9H5gWvjVEtqWVrPHBqU73Q8SlYDjq7WQOZsb8EmoWlWqOz7o6GSB9uZ5y/uk?=
 =?us-ascii?Q?mUp4CdRbAkc6C7+CV0YBNzZqPxkJYB/Y43MMMdvLVu5cnCbxIT1HWAzyPjEl?=
 =?us-ascii?Q?Oe6X7m8CYhwFNcjGzetjpPS6g6gNpAQxFqzpDpwDbeHnQWLOsbYD56jqV5cS?=
 =?us-ascii?Q?0mMgJSk1lYkdW1vKEbFgb6Hb7ili/NvfVjWalG19Ih1GwjkI3VRg+nhpqdjO?=
 =?us-ascii?Q?3N+lcTUp4bjaEzWmGnAnFzEzLtuIxMBGMOWhafXAKSBe9KOn0JXRgMBSAFjm?=
 =?us-ascii?Q?oxsuFgS3CeGWl7ET3bT3/0DwmRNbHqwP8b5qsPhHirS4nwMsFfaIdfdIJkTv?=
 =?us-ascii?Q?YJk/tnszCVAepXq9Q5l4ZZaMKb8JR+dVFY+BaGrnJzNwbA/JaFm2UCsxRf3q?=
 =?us-ascii?Q?QR1noihVcq4OQ2PEFCbtTTh3N9lTWdF24vHnN3ERL83fP4tDZfkZg6G5MxDv?=
 =?us-ascii?Q?4j5HLO/fEX+hIVna4kO59Yy8MR2SkAKTEZZv0iVZEk8Vl+wXqDC0hhTgf6eB?=
 =?us-ascii?Q?uUEwybXU3SerxbtlRJStjZ0bKGB5HpifNK8+Phq+dO51o3A4QLh0/oaSPMik?=
 =?us-ascii?Q?Y3m0GN7i6csIDV2S/IM5jCmS9QEPYcIXEysQm1jFmFT0NZ/VMOGt4To+qtgw?=
 =?us-ascii?Q?dyVJOeu+Zu54bD9r/I+9UlMwCstM5DDwpR2MGDahul0BryxhbCVut13LNBjq?=
 =?us-ascii?Q?Hx7LIzlkFh005CKlctbdK+mhcPbPWglVxd+bmUglI6SvrDCnHcvAXJWXWPQX?=
 =?us-ascii?Q?sf4hbYprmPo2dZ91RQzkYDqgg72txj61Qlqn41OaHuBGzwGGKgsext8blPQW?=
 =?us-ascii?Q?8A/9F35IWyKpTxdi5+XWh/+M0ijMkRK6Dig5Us8mqwDR8cyZ0QLJRLdGz6O3?=
 =?us-ascii?Q?/Wof2HyezbPzsx+eC6OWO2cUhEgznYjHNIG4Er4cOcROFB8Ysbqmph1oMPoO?=
 =?us-ascii?Q?WCnZ7ZNRrqPxADvJek5MmWmmkzXPvb/t+NbwbnS7V5JlrV7Hcjewu3idmhJq?=
 =?us-ascii?Q?fJyT4nzkitjjB8ZHhJZ/V4ddJnWTdjb0qZNAlJhmKt51K61Kezb6AyzwoBpx?=
 =?us-ascii?Q?dJqhopkG8ZOS3RPIb03e2/OOqQXwW+zk+TE6W445nKQlkl71+Rzdpwgo+KtY?=
 =?us-ascii?Q?hbl6yNtv3KEXaso4pw55ame2BaGdWtZE2w853w+qlvX3R5qx09iZ2kpMcvU3?=
 =?us-ascii?Q?w5JLnuYAboz6+f2rVRUq9r/Rnhw+O9fJUqy9rdx/CLzPw77oLcNlqtihbzwC?=
 =?us-ascii?Q?YcR10bv/APZx5KhBxk9P+PKD2/VVFe95sz8bTzbMk/8X7qjIPJOIwiLtlEZv?=
 =?us-ascii?Q?W0iN1Q9fxkROdpXUrsAu2YScinngLguoKa51b9UgzulZZSdkJo77zM3nx/UK?=
 =?us-ascii?Q?iDE6yKyP51g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GXbqMRnIm0akbojuv0EHJE9v8xG5p3YIho4lGj77twFjfCyjW35XVW5nVsP0?=
 =?us-ascii?Q?Eq3VFH96eeTwivWJVjyScPdOxi6uaQevSamLAJj+e6nKu37Rk5m7YECkX/BT?=
 =?us-ascii?Q?a57OldAdt44TxERpAAMl1zZxpo7bQaqnqduwT/bqqC6O1yBGXBalnhMqUVzE?=
 =?us-ascii?Q?sBzT84fWoLGHawBYmf/FLOCsJv4MVtRgp1lNW32NI+wiA6PADvuYqjccLjx2?=
 =?us-ascii?Q?smusKKoon24ezlwijiBKhFf+OGu3jkoxBBH2errz4XIof/BBDeor487ytUt8?=
 =?us-ascii?Q?6APPkSJGGIccDttStkSMH9+i9QcKvhGJ2hA6CL+K03of8MTMNEUhQcm/yktM?=
 =?us-ascii?Q?xTuLR6PRLGVzbaIUgKcLxUvAiGgam35+OoGJK1SUfmYKH/Zaqd2458k9bBgI?=
 =?us-ascii?Q?J/zDptRB6mfslSpIY9nqHF7yn53gmDIreCy8lJhUGEPBWId7KZcpN6Otk8ec?=
 =?us-ascii?Q?HaJiaEMWF8JpYHGUuSF4RbMlt51XJNghnEUqaM5zqp+jmmM0JXSFMAJui+Sl?=
 =?us-ascii?Q?MqG+neD0tVyym56qZkwvTi9KwxoBCiPohW5BLluGDVQtnuwAcn261dYi4B1L?=
 =?us-ascii?Q?ymmvLSA3TFztYdtBhd44Pt8dit7swIGxfiqZcsUoby2vH9Ulyfx5k2F5KEOP?=
 =?us-ascii?Q?7H3cZFl4+M1tCBKdw6n3IrIR2wB4MmJXWJYPX/4Eli8eX9Hjz8FcgtaMEqWO?=
 =?us-ascii?Q?vjt3gQtEV5HUWW94OGaGRJrfJTPL70cmjG0nnDrEnD9M1C0OSxlvhe6ek8hQ?=
 =?us-ascii?Q?0OJr7teu1fvMtCpodsc1dNA59UziO9qVrHCqKY30c1rjNhvK9r7Z4C9whiyb?=
 =?us-ascii?Q?5r/vwr615zz6td4GOw4QmGvadanfQE/aH/1uRyGVxZsrL6Ts3Y2mTISNsEDZ?=
 =?us-ascii?Q?4Sm5edlViWT/AN8fLK4iTPUFHd4ijGgIPbh6D537ReT24YfZd8LH9eP0VCGn?=
 =?us-ascii?Q?NzGM0B2AcNYBlXgjxhaOEb6WVjekeblmu/EQkt/9UmJzmre1M+IgBoavIVzW?=
 =?us-ascii?Q?k3u3aU+Fbr29LHCcz4zqwbqwWUVlafapnUmV/9UIYwwqJY28sT7MVHLiz5iR?=
 =?us-ascii?Q?jwhYr4MF3ddIaPqBjnnrkN+r0kzIIzCP2JMuWxNf0ltAjM2HbRf5jtUjDmU8?=
 =?us-ascii?Q?BBsfSYz1Q6Ad7p0hQbVYO03RgHerO8RSJlyJhPBTVoheMc665c6IH7f4oxzR?=
 =?us-ascii?Q?QIJzFOtkqS01t8iLzadEAYHnQThW5qtmgCVx8qjXFcY6bETQ88sPnSzwIgMh?=
 =?us-ascii?Q?9dy9ChteRyC52lGMhyHYDJHzSyPsgA4Rh5XXAetBDy07wN8r2/gDu6FEDkxl?=
 =?us-ascii?Q?CHWddRYl+ZtyDyciSenBnKDF4S/gOAlzZNYBYYAQ77mM26slRMSHZ7+Jfwfg?=
 =?us-ascii?Q?2STSlpymnx6dFDtZ8w6fqq5t5ptC9W0ozEyJzu76CHQ4bnnAkP6QmhKfe7eQ?=
 =?us-ascii?Q?h1vdzXPums6fCwO2XGjTNJoAF+UDVFndofqhm5h0Jehu6UGM+3Df15HvA0Vk?=
 =?us-ascii?Q?tD0ldT9fdgQEtKwS292NGrkaN+oHWJ3c7RjEYVL/Fp5hQQIgxQSW1l/OkLHm?=
 =?us-ascii?Q?4TACTckQeE7NN38fL7YNIgzoH/v2c6+lRj7FbGXJmHuwAKDYHBHYFwEwMoSa?=
 =?us-ascii?Q?pQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wvnJy0OF7gTmEwxugwm00q99Wtf8D4qbEXhQIfxIrRDWO8s7GHoa8/k6Ty5a9wFgOmWl9MhirW/X14J9yZY1lFFbEHFlv2vWUS9CDHE5Fxg4E6ULiPc0sDn8K5979JhvtSs4vrrNFpRL2QmEFXO77a+LpYb0W1uiqSUY/MTYT/L/voI5V/Goh0s7t1wgsUeYJoaVRXAfKWJnaJMWw6MtIgnEOLgiWkeGEeAkGS5wk1/CkBxawm0EsKRmv71aG6/VyNNTasgkx37uHuRKryvP15Q4I1/1l+jNCEH5OZlZE7auwWQCYrnpFK6yFBOFW89tUJmBMF36Z/WFnu9WQhhW4mwOEUgCPLrKZpScBn96oIxm884PWhCaqIWdfDHXAHcT636HyAoyIshLxu/GF6zurakHY7aymsOvri7iBOpDp1iI5zEDple7iyZ33D+MZF9mXBjtFwkmNOdjUEnNlOH6/vSv45o9x6Dg5u0OxpDNI2UjVA49KbJP87VB+MZLYpcJ1MXicGcJnGbc3JCH3hqJEe2c/QwLLSrJSHtok47n4KQYNPKXImuz0+XIvfLL234z+vGUGHb/Uih+MpArmj2iS2nC/1X3Rbcw1GFfUTxbR1k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5de0892-60d6-47a6-da6c-08dddec8bb46
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 02:33:07.4352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pk4mtofyU+eW+GtGZcPd9aW245n4JlUHSvhTqwtbBm3Bj73YEYDLm+HF0WTCsjVSsq83lQWeW25FNC0NVPAzuN70j1SM/VUGolZLUJA2jEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4153
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=629 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508190023
X-Authority-Analysis: v=2.4 cv=DLiP4zNb c=1 sm=1 tr=0 ts=68a3e279 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=8u6wpUVmjFQVkGZwwtgA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDAyMyBTYWx0ZWRfXyfO6kJvhmVGQ
 3fea8VkznsY04TMX4sjPkU6kY2+Gr9z+yCIQvPvTs0HrrF0uyG/uNJkyJo4OseotKdBpfh0jwI6
 tGg5PoPVRBDZHJwpSFFg0PGkMSXo3YV2KliqSJ0YhhnTzS5FmdpKmaKALerYdJAdXfDs1nXB4TG
 6TZ0j85KFO97c/UEN0bawmXtj2QpJOm+T5Ur0FMT8qVhZEfbtzJgBh+vUrYCPH0D2bGSz/7B+Wv
 f5GuszsyUhAwhHMyK40ogkjTYDLhwmwWqeHP7YiVASayJpMbXr2Wd5pTK4fNsBtb3MQ8/c4lCL9
 ZA7K8ZfuLpKgBk2F8TGNhZGtsR7fNXg9Zbn9ypViKTKcPVJ+7E//tXytesbYHrDaT039YwLTcFk
 9+sjjDgGB78zaWZxG5K6V6epzCFQw0csyNM1L6FGIUtcThvcJNvHrOO9TstpJajVAeiNM3ul
X-Proofpoint-ORIG-GUID: 5yKtXcT3O7PQY55FFNCr7tz2MtZQE5n7
X-Proofpoint-GUID: 5yKtXcT3O7PQY55FFNCr7tz2MtZQE5n7


Bart,

> This patch series includes three bug fixes and one rename patch for
> the UFS driver. Please consider this patch series for the next merge
> window.

Applied to 6.17/scsi-fixes, thanks!

-- 
Martin K. Petersen
