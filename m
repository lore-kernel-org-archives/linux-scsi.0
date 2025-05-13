Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2432F1C862C
	for <linux-scsi@vger.kernel.org>; Tue, 13 May 2025 02:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747103975; cv=fail; b=G+/TOUcrkaeGI8z7GHicZJ0x9u+0/uGxhOEXb5zqmgfCTIywty/bv4nwEyHr+4m2MqkCOomMm+Uf7cKylN3vfjYAsm8fNUlIortu3FIStnU1HX78xhlKhnqH3yjWzeROqffPuq2DhTQhStQPgJru6NOyWefeHrKOHY0MHPySpmA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747103975; c=relaxed/simple;
	bh=wt0Rm9FYGPxUIdoyhLtlJnHFxGdvUF308vE0Dyq7ric=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=RATIol6NcSxhTKyfRUzMIKoIBFLFjMLF7CoYTfMUaIuk8Z2dvRd5dgN8Hg2Eav7Nlh8MY+5dREXGoljTSfAtLgO4f4841l+XyMFsoqE0TInJMfSE4nFpciQt39sRd0dpbUN1UFpByqzYhyVj7QSr9stAQkKsbYgj/d8K7BwQQuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nuDhWXVa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NLTUmkPD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nuDhWXVa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NLTUmkPD"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54D1Btcd000701;
	Tue, 13 May 2025 02:39:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=49PpAqOmrFr3/fakpe
	CqXbyr1/bUdzfnZAVWV+hCElQ=; b=nuDhWXVaDFY1sRS+nUWgm3cVqLJXkjQ5DW
	w7ESnBK3B/j9l+8c7UtKkCv4ibGakiCjyo7xXuPF4WAekoQuw+NAu3mXsbG9W6ZP
	WOjX1W2fNgtYbOySkFu6A5oavTu1OE2R++4FAJ81sWUUf/dX++sZybE+5zPDkUdY
	UMn8201kArbBvLNlgOvrc9U1xs6KPEBoWwG6JSRjzJ83pc63YHdqs339GmrBVLod
	WwdrXbTXRyjiptMTSdqsaYeP7MrO8ycqSKSIiiAKQKkhqtTKjmM0f3lBH+OJZfSj
	e9DL1iihu93MqvsGvBjHDB46GTUsdbStt93qK+XygQ6RmhrC8XwQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46j0epkrqb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:39:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54D2C2r3015481;
	Tue, 13 May 2025 02:39:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46hw883w54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:39:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vZCKPHulhbbu4WSiW5dLHDnclN8cO/3BHPSQVEemTLc3Nx4AdbW/XDIwIFuhzVw1R3zTwqc9a5k8eFC+Eg5+eDi6N4d6EVURonTDvzaC73CUYQ/XrU+ocY0kZ8OjZrTuHg34iC+JTVqyaAlSkZMKlMKandq6CNT0kcE9ScDhi6OvShbj7WcqOSVEh5RArFWiwpeaWTAISGpiM8jtzlRkP69ewl1mvctpN7S5tfPGx/bCVPzRBS7gjMyydUlpzjTKrYUqba5BIVEJqTcc9UAo3bZ5KCsuPVt39rsBhJTSW85iZLlQDIDNZSe+OocRqm0MLdeKvLgjpYjpe7MSnfnO3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=49PpAqOmrFr3/fakpeCqXbyr1/bUdzfnZAVWV+hCElQ=;
 b=jX28gzt/afSF6GBn+ccpxgRjFuyf1SJvTYmChQXceqs/eqp/h9ufB022oGMfnJNNc5XYbTaQYlbJEs7rXNmgBHE1o6NP9tTkYRJSfb3Dhcg7dLrCYg2Pz3hnAzwUyuy8PZVB5lMxPhmGTq7spXEqdgJg28s6KenoOixSTvwAW6CTMiz64tEkwLnWSbwC+aCDtSacDRiXRpEXmadTPK+1NAWsWb9LpRR352eVtqs5AGGyn1gSzruTgawPE6fepwASVtjitLDltvQPq8gOYhROaThhl7Anb/FJNPFfBsUwTFWFwGpbjoor6q6Z4HZfi3i/bj/vfWhJI35s9W1hN2ly5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49PpAqOmrFr3/fakpeCqXbyr1/bUdzfnZAVWV+hCElQ=;
 b=NLTUmkPDFVzR5M+7/yE3fwtf7shi1LXgVVbrRMvXx0Gm5fyhU4yTw71Xxeib8zpsc4MN4twneiwV7cb8BezVee2faa4e99ghm0Cw26afCv6bWBI3fcPr9E57uFyRv5Hp0IGxaoKJNlnDnkbknYPvzDCe82l1H8bzv+LgVOZbjuA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ2PR10MB7733.namprd10.prod.outlook.com (2603:10b6:a03:57b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Tue, 13 May
 2025 02:39:08 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 02:39:08 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <yi-fan.peng@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: Re: [PATCH v2] ufs: core: support updating device command timeout
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250510080345.595798-1-peter.wang@mediatek.com> (peter wang's
	message of "Sat, 10 May 2025 16:01:01 +0800")
Organization: Oracle Corporation
Message-ID: <yq1bjrxqlof.fsf@ca-mkp.ca.oracle.com>
References: <20250510080345.595798-1-peter.wang@mediatek.com>
Date: Mon, 12 May 2025 22:39:07 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0374.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ2PR10MB7733:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d87106f-3655-42f4-501e-08dd91c7561e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dF9W4oVw8sZjsluF45wqtEARfYGc4K4KpvyGnwskKMwLnlNz3ajMzppl8Y7R?=
 =?us-ascii?Q?y8qHs6bJEVj64qanRNwUzk8x4n4DkNooYWCtQnvAgDdUDXBC0qqYQQ69RNVc?=
 =?us-ascii?Q?MDQjaHWn9Ue1xC62NpZyQ1mXlgCh4JVFA+IJq2BhkdALOHYaOU6V003lZ+k6?=
 =?us-ascii?Q?rID2ks6Md0LZTcClWha/sUvxep/h3xu6thwZ9805koBjJ1X41mbe8Qu1csLo?=
 =?us-ascii?Q?XEX3c/rkN21I1kfsBcvQbFL5hQLZxpJHFPowSUAWFaypiE5e69F9xzVu47DL?=
 =?us-ascii?Q?xrWJTNndi/4KUaRFpoF9MUYEsFjQXND/8fa1f6Qt/4O9RbV3hjB9Sy/PapEF?=
 =?us-ascii?Q?kI09aX0gstMn5OAqdP2/v6nKNZQoBJfzSC3ZMc/41x6uj2TwNRlC2FC3asQb?=
 =?us-ascii?Q?1XJ3quhRQF9/MlBrNWR6i0qb9cvkk4dlzvwJJXOXukbKVsj79yLXFh0PqjGQ?=
 =?us-ascii?Q?XEe5X8dXWG5bNXTAd/ntyCiUjHM9uAUEZXsfs41N4mlmeNpPOfbT8N5gsID6?=
 =?us-ascii?Q?rO2UvE0kElvYPszn/Ul00ak62JVDUufqyM7PwSuCdNqNOhQmtMasOaY0Ld7w?=
 =?us-ascii?Q?bXVGj8h4kXS3/7l7Zqa0OxIiEB12Q7gzdbjcSC+lXo1G9JI48MK60T8znBx4?=
 =?us-ascii?Q?7Oxki6Sk7hZDWzYLD7F9dZ0zidNauWjwotnooB+W19CCN2HLYBY2OIWoQjqW?=
 =?us-ascii?Q?JgNzwVf98FyQxzMmA9aVtT5f/3IYUILnA1JDR+XWijGaz4CfJNRWwL1noKe6?=
 =?us-ascii?Q?5+TKflS1Nf6QHDEslers0CyOIbvX/JWfW0OtSrMbAer52BdzfWXrXpLb9upn?=
 =?us-ascii?Q?/9H/wbxX1Ts0++Xyv+tBqJCX8RKvKySS+1dbZ3wi/84MW5oavoAZVKjXhSNn?=
 =?us-ascii?Q?4AB6sSCmq9N1NgFhmvWEZeUgN6U5C8d5ctq6MGBBGlfYeNF7+Rj8UOPSOBIh?=
 =?us-ascii?Q?zn1mEKIA7VJIRnJEvysGCdYDC+3pHmpiWwcHVIm430EcJeKzOqY/n1jzRIrb?=
 =?us-ascii?Q?ZTitc73w+O1bp9B07dYtsvIO7eIprAUVTCj93wShEjCVflZiAbp6L92O2cs2?=
 =?us-ascii?Q?sBpu4wV4Pm9oxH/3GYRcCQysTeFP+c7n2lAJxUl/Ux0/eysHJTabXLkx4pWD?=
 =?us-ascii?Q?Oz3J+YJ1d5SLSAc8TbqRWUYoim0pgATBBwVR7HcQe0BqCK3qeg0rgRvVhWC5?=
 =?us-ascii?Q?JDTaikbHD+ccVEljgKdflJtXwAoQNJUSCz7LAG/6ZudU2MpwW+8ZtzO5xAc3?=
 =?us-ascii?Q?19uUIPQmrYUY5XIaIGPVyklwF6ZWbJzet+63KR6DVwMeF6GXl/fTKRrj/NPG?=
 =?us-ascii?Q?ngqOs56bpzKCScWJXuLwHOVs11U0Sa3zgH5lLgeT4/BGCEFovbIBIxsgtVR6?=
 =?us-ascii?Q?UENtXoJnHse3WmQ+rBHTtEeK0XocRjacC0ap222f96xRGh4KvYmw6dwTZdlb?=
 =?us-ascii?Q?vkxVc2IkMG0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U61dPsdL8lX/z74vLh8RDrNbxys6bTnmgSFoshkDcqXzugFAOR0tjddZkSCd?=
 =?us-ascii?Q?UHTM8Iu88pv4IND5Wd3y4Zu5Oa97pHqTuGNN1TK+0ThDAZpueUfTyVKU7V4d?=
 =?us-ascii?Q?7fR9xpuGydhYIBXTXL/hc+slWs+mKX9Qman7alqsz6N4Zok1Q5yKLCofSBj8?=
 =?us-ascii?Q?xQTVJOHFXpJ2evBb2ezluh0LAnH2KNjFGM36QkAXkHBO6vSn39/damOcozjQ?=
 =?us-ascii?Q?Shd9rhiyV5UgpYhc9Zk45LdFwI1aM9OLxSHitbf6Cfhiy9Vk9o9FtiWoDCHu?=
 =?us-ascii?Q?yDJ4p1swV37JEWcNtx1FBwMOesOr5skii6jD2sQnMVzP8thQbAT6Dl8lYZ4F?=
 =?us-ascii?Q?+IiuAOFIAsJr/naacN0aTkq4pR6+C3fK43WB7fWVpHTC+7IzeW+Sc5dgxxbb?=
 =?us-ascii?Q?QHKv4b89kiWL+EJQMQayxeJuA/dndgEHCEsd7Kt69Jpus2gkpdJaktJPJHoc?=
 =?us-ascii?Q?FXiYD6Deq1VmhOEEjVmZBwfoNQz2DmvAnJPk86B9RrAW74hGICAGvqIuaiAP?=
 =?us-ascii?Q?2aH6DMjP0GoP7InsHsuhnPcu60VtGKFWAn6nFhdkxOsRl+UcJuPIWFrXAFHw?=
 =?us-ascii?Q?SwbQTGL6sA7pK5zuFi71AxHdoTHTCZINWcYBm1VOEx5OpKR/h5NRcnyuydgd?=
 =?us-ascii?Q?2OfdxyeJwX+34dvBpYM49GoPJSsuxUOD4hPYEXtMX4U7O+9FTfgVUQLMvAbv?=
 =?us-ascii?Q?PiVbcysKrtPiw01QxMDUWd5OKXQYmftJGPhR0MkQy2tQrAfgL6vgMJGxL1gE?=
 =?us-ascii?Q?Nr51yJ3pBUeFSB3huK1j1iojrBhDto4dRgTniIBG4aXyvhbBPdMppdUhJqBB?=
 =?us-ascii?Q?XmQGCtLOt+ZZjX1xzi6rp6Yv21wcNb5FIbB+BwNxtLNR49YUG3zpTrAGrQE7?=
 =?us-ascii?Q?Eu/kvFNcmfAV2yQ8LGpPLUOu87OVDfjg8d4wjRyfPUZeWurbYSY+5n4sdCIy?=
 =?us-ascii?Q?BEFdjUqEaSoXNYJTENhPaFB1Iw8NIIf1KR06pj5ALoW+o9yojv2vjTGYQ+EY?=
 =?us-ascii?Q?oRdVbGg7P5O+Ubo8iCRiJX+0qCanocg95kgUHo48WfEHRmeMckiEfUAOGK+O?=
 =?us-ascii?Q?iedDkCwW881aQVd104SgmcOkcshgcbI1UdKWcuHI2SsQy4I9r/7S+FfTrTCK?=
 =?us-ascii?Q?NrAYOv9BfTwpClJ7sXtu5wYQo1o6xtw2PjMzV8uAIZAphCpaaCXGm6LhodSo?=
 =?us-ascii?Q?nPeQfavrGRqKdVYN+ZMJSeTWKBEfDhC88capXVDO6mStEiHXFhaLsBGjyFCd?=
 =?us-ascii?Q?XHnS9K/4XgpDUg3MFEuTFdUXEMlhunviH8Pq2L7BOCPC4VS4URfM/z5so5/s?=
 =?us-ascii?Q?6LqE1QRkq8ot7+P2YmrhHnmiLLxALxwjiS4ACzs2EsJ0jvfLSsOBQoydR+Y2?=
 =?us-ascii?Q?GYBnFTqkICE6mb7fWiwZcIp5lJ/pBn2/sq0B9mAKmS7UXYrqO9tEksiD4a0F?=
 =?us-ascii?Q?UZ1vXdvxnLLaTLgEAyosporAsy/HLa53q6px7+imJmr/XEkqNomudvu2f9ZE?=
 =?us-ascii?Q?lakxZezMSX+cW9xmbRTWfj47AT+gRqVk1ysV3s+3tUx+HnHSUuxjSCLLxeTd?=
 =?us-ascii?Q?cQLlQvTI3N94JdfWh7Hl6Zh8CLOXhHYkaksJrRFIHMWW/X/Dv4ViHMXfza+e?=
 =?us-ascii?Q?SA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Czy/FYxcKWW6bY7JgPgdCJZQ0w0rJdf6PjjhUe1dxQ1JlbqtQaZRhNLxFgax+HyMX1PeaxblaeX7MwgGd/ngco7CvHObghwNZd4DddwisKKyt2LPkbfuL9H5p/OtR5o3m7PYIDLET2tQfdGK0A13qAwbbK88wRmK2sjyyc7zKmszWRznXJgJ6z4sgikqqylBMQ12R0bgcXy3uml/TElbxR9qVBPFT8IIDw81BLZzMamvhnXsFRwHp0pqfQS0Y3Npdoy7zsLWDsAQudacFACl/dfR0dL8j/+0ojhal7p0wYamAltS1lnkfp2JAJdrO8BNxfmCuIpIU4osKiVxbRdcJYuZ8fxT6KGOcKJzLylyw9CHgN+Hy5nwXe5LGxAnL11RU+JeOS2aj5x7e3noSxjdJrv1yYhhovCsXTGhwKqImKi7GRPZxHK0wkZ9+S/VWEHCK4hOiPvVE3iTPECNieerw/UTZBzkro3IU8jXJM4pdy9WhQNRS+VCcHoKZJ6A8F3KWfntEQuO8o16s3efNlb0prrWRTZo6LlNtXjQz624I6jMnDCUG/XpFuN7ZlQbWZ09RrN2j/zDCaLF831e5ZAUie3oIFynTPZ/ZJAth2azjNA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d87106f-3655-42f4-501e-08dd91c7561e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2025 02:39:08.7450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R7FUPJV9RvdOz0+BxrVai+GsL6cBmKKandTQMqKZQ++eYsGPDQfyg9XbMqPvwROeGUcCiU1cHyHgyyEPQcglEL3XGzB93YQwkMSXc/SdAVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7733
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505130023
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAyMyBTYWx0ZWRfX0rXR11sQv/9O /zOjZ78zIHf3r5AWGXKdQjoJezRFl7NMcBogl3KSlriWvpej0xC99rfFAC8fyQPhPDuzx5B1mVV 3+DAkExta77YMAJ7xIcV0qTQDYB93+zLT8sIcKpr7ZEgkgZGQ70ggFKe47RGZNkr/NgVJafReHF
 qE3eGL/TwCOokWu40NsZRYHKVXAtlrw0XyY5Jc/9Eht+gtXw/ybl6e+5zm4Sp/prH8Z2apfGQ5q L0DBjmZ0ekV+P9EDDP1XcGyDhhZzkGODSJzMI0S4uoBUsam8WcGuFijEU7CJnoMpjzxl1EEX580 e0AmilkaI0PHnUf46UGHzxvGQBF0FAvkG+gDtKDXLpBppacoeseU/c98nY3RmvutHmWo70oI6oR
 4jioazrQFEzCi4Xp8TRdgeRt87d4FItzJrpicKcuMzUXdBqeZP8keqo1eNdBEqVQq45k+jUV
X-Authority-Analysis: v=2.4 cv=DO6P4zNb c=1 sm=1 tr=0 ts=6822b0d0 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9
X-Proofpoint-ORIG-GUID: BZwsZtJbES_ip6oenktAoVpL0i5XnTEL
X-Proofpoint-GUID: BZwsZtJbES_ip6oenktAoVpL0i5XnTEL


> The default device command timeout remains 1.5 seconds, but platform
> drivers can override it if needed.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
