Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAD92AE68
	for <linux-scsi@vger.kernel.org>; Tue, 13 May 2025 02:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747103859; cv=fail; b=pSD12wezKrHRSDUSFJqqJ6em4XW+/KNy9gpisfTFXYS+IODq0tSWSH7aJfVaJsaENacn+ZuFu4cEyjsmQa0JYZZIIknSZL9hGywiMVc4Zu0h6iCh38Fs9szWDpdad2tvpdinBkQR9tySZ8gz2LYnelkcnFUbBPVeE5P2WI+Yxpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747103859; c=relaxed/simple;
	bh=+OYFgnr56Yhwh9//qrvEffLoIfF+cBNGIkuGj/e+mO8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=hSeCDT6mIGJ6dqXYWceAeOiv5nWJUgyV5o1oHn6vyklQtdlxxoXrUYWWbQdZzC4HVa1M4ViAKl91QDDTb5Xwlj5O5PzJYKigyqYVP8JCsdwjInRy3fJ+CBMNrYqgMLuVYSV+Sa4Dr5iVIczh7OqH4AxC/zWXQdooXXteolNNcr4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qyjLjpHz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jWkRDAfG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qyjLjpHz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jWkRDAfG"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54D1DZE1004353;
	Tue, 13 May 2025 02:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=yeO8WTT5nQSmUZ5/pK
	ahZSNoNbheSWg7GUOGkKacTiw=; b=qyjLjpHzzZw0EJUOwjPnLMFBRPKhBEMEKx
	m83U6aaCQwnEykB/0eZA32fcSdDR2mRKyyG2+oo1ttS6hONr9zibeZuLCsf2ibvp
	hyM7Eoxj2UfjN7es6LI4f+ZMySjgXqx51A2UnYfOykBslJ6ZpPN8CFTyLS7bdbvS
	CnYR6ETHVY5e4HpCE/b96A0pBcnf63kBQrL94i4pCmMymVRhygFYFJZ0TacethAw
	Fkkmu0qJPv7SWCsGqjGWL1bfRt1ZbyK3QJNvw++lpjZIheQcQbJGwaTCPR73VTWE
	XBO4HRjjnFZSboof+u+KvH2E+QMSXlWB2OsRl4hLbqy5+DxyFeNQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46j059uv3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:37:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54D0rpIY015485;
	Tue, 13 May 2025 02:37:14 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazlp17010001.outbound.protection.outlook.com [40.93.1.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46hw883vft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:37:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K3H16QXEFUvxZLr1jzvH0z8xOTHA6La1fRC9Fqdd/MMagR9pbc+ptz91Oa7mriuWX3iqDsC1HzAgiux13iOK7FxSxRLh3YRf4BXbL+PcGvAnKvSsaeIyXqTXHSxKUhXD/jOCgEID87ohMW8u0fbPUma4Hst7hkQtBkje49WwjediPV0QQ8LXAB+kk43ENL171OakIASzqngnSNoSCA164LIbksOpTaRbo0UMOndZ/kP9Ekx7Gg5I4WDqC8Z9WARDkmChuLr489wjK0sk88TFY8TKZFp3VVh6O7NW9l5kMBaK7L0a07pA2BOj+cndevcWNlTQnaTF4bjF0fO651DCSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yeO8WTT5nQSmUZ5/pKahZSNoNbheSWg7GUOGkKacTiw=;
 b=Ssm850wusZ/s+WTShCMzE7FVHl6NfhnfVYqrOuZcvI7aBaa+cD8Uz+vPkyfXDs8O838dQZwvy76H5GwVRDnSEOvw5MJd4t/YMgSX1MZHXabJx4g29rU7u//doZaWGqhqz6D6DQyzA5JJcsXC1uWuzxkWdlfrq5eMevkwrKWrhWqtsyZkjZnFqwNsQ13rEenKc684wrv05GtO+K4aSuzM3XAqVfKSRt2ZL7lyFuHk2jHlgznf10fPqL/zLN7jo7L5JmSyTskWf5HTtY79PLjuYcRa5isKWoJnHEGxQNgxPZiPzFO+yolwGQX+GDVGGw2lRkzqIn38ZZGZLUTlcf/A0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yeO8WTT5nQSmUZ5/pKahZSNoNbheSWg7GUOGkKacTiw=;
 b=jWkRDAfGO8u0/QCQTN1JsPCoipbrYT2gagzR53KXwLb+MUpc/jtEV9YTTktmojdhWtkGiggD3smbqL7be8CmBu8ObXMUtIzovH92AO9rLldglujgFP+1J9Am3yoRe8hG0l3vOQigeGy6RrFJUjyQg2fyPL7iBF5An5Y98xFg58o=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM3PPF5816B0BC4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Tue, 13 May
 2025 02:37:12 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 02:37:12 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <yi-fan.peng@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>,
        <quic_ziqichen@quicinc.com>
Subject: Re: [PATCH v3] ufs: core: change hwq_id type and value
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250509021648.412098-1-peter.wang@mediatek.com> (peter wang's
	message of "Fri, 9 May 2025 10:16:12 +0800")
Organization: Oracle Corporation
Message-ID: <yq1h61pqlrm.fsf@ca-mkp.ca.oracle.com>
References: <20250509021648.412098-1-peter.wang@mediatek.com>
Date: Mon, 12 May 2025 22:37:11 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0036.namprd13.prod.outlook.com
 (2603:10b6:208:160::49) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM3PPF5816B0BC4:EE_
X-MS-Office365-Filtering-Correlation-Id: 56ccd753-37d6-47af-1f06-08dd91c710bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sfr2yWhQ/ubOiHDXjIuEBsT3Gw6W0RBM7/TUOlwuzzF3yjPEGDDTVljhau8v?=
 =?us-ascii?Q?oUNHgTaz6a6SrrUD9acVTHYJM73X+tnoJmRs96a/wt0yYWkswrnDg/iEJZx1?=
 =?us-ascii?Q?eEQLjaiw36LDqwiuA1+W3PiRsRX1SL/9lJ06CF7cIaPpsVYFNn4FnkPNIhC6?=
 =?us-ascii?Q?eKTXIL+5uGM3zD+tm65yBs73FKHI+nKMOFVbIGB6Q8rgsP7iUzPBiilx+vkm?=
 =?us-ascii?Q?OEUKuh7A8MRlQ3UJoAPUGLAhKUNTzui1NorVDCZ0nWrmtvwRG4phCq/6aikj?=
 =?us-ascii?Q?Cupg2hn15ostZGTkZyGg55EwXa/nWDNDbp1IYA+BbmC2rc8NoFUsk6HrYm3E?=
 =?us-ascii?Q?nLcsVETpE+SZMCbVj4Hm15TMn9xuu51M+43ZCpWxagIfWrXredMVivnX4zs9?=
 =?us-ascii?Q?C47H80+34i24B1riiYaDkcR5ZAjCJyz3Wi7baDeL8PODt7gmKBZBzK2yZlJl?=
 =?us-ascii?Q?72CXmOCwO51DyWYgxAE9maLIxI5LjPkGSW1E9q/CCra8G4KQp5/M8fAHBg89?=
 =?us-ascii?Q?wAjEMwvmMP67+EfEjzwrU/ywdo5StUXLZkIl+/E2RYnSQz1np3zBMBJA6wiC?=
 =?us-ascii?Q?Afb5NZ8c448nDaSP87W6m3JX35mPjsZ3y9OX9zea+1h1/jAU2WbTf9mnY9e+?=
 =?us-ascii?Q?oQqku25PSRhHWECHl1bKmwoXxBwqgk8S2FAO0pJoPHK6jH4GSqLQdcxr6kWd?=
 =?us-ascii?Q?HUCMI/gkhFot7IASxnuW18F9FguNCCxE1rlXqHf/k3XlGF5d0MGSoQnu++vv?=
 =?us-ascii?Q?UtT+CvYc2o2UFtKzc2VsTgUvAgXmMY5bVaRmF4+zFmq3aqQziyxE69kVhkoL?=
 =?us-ascii?Q?GDqblA5kZiNPWBrj+FPvFUOlJiKypcaVuqWZLgDXeoNCDc21oFM455tvx83k?=
 =?us-ascii?Q?9ezjn0MFEYjaQBHFSnZE803RiCvoU8to4rFpBqXewk9X5u/qP1WDMuleNJGh?=
 =?us-ascii?Q?FtbZGo344UQ3/UDxW0pyXOZP3BpM4V+6A19pJDaE2lLWdDpUlpVgAaKQRxjz?=
 =?us-ascii?Q?dO3+vaaOnxKAf9671US9MxUbRxiZgo6WbQ6bp9M1VALUqfJ0NdzTmA/QVmAs?=
 =?us-ascii?Q?bxl/KVCa7GanHfeHRYafcItdFhip79XAOeI0pevv2Zm7mn08xKD0cLJjkjF4?=
 =?us-ascii?Q?U3fzfVdRv++iRI1d+erxaw4bGNHCo+2uNCYqlS7M886obKrw955N3sxI2WJQ?=
 =?us-ascii?Q?hODArssHfu9iayijYTwHCve5gN4HiOlHsAoDzqLJqMDfv7VzdjCiWKVmkzqt?=
 =?us-ascii?Q?zR4ghgkv4A4lByIWKQgu+6l+GhMDlCEgcb+tAvFiQGFz9BNzngFcWLHA7p2+?=
 =?us-ascii?Q?JXBmP8b2PKPieWCF7gjM3qDwb7/aOtqkrARuZho6UzSRhGa9FpVyfbSMzL+4?=
 =?us-ascii?Q?sK2VbjyVEk85oFw7GXkTNlq15euyxQtPWGgCXv6bbmxaRX49p6lodfL6LwSR?=
 =?us-ascii?Q?9RiJLP8L1EY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pLklequgv0ytcm0/DCen+QBDh7gcEtlvDeoaYV8M04NVu/RbQmekevHSauAb?=
 =?us-ascii?Q?epaF5F6DK2JML8S1RXgBH6K7eOI1oabGbgcWqrFGatY0IjFBYE7EF3DGulZA?=
 =?us-ascii?Q?39ZPGlQdEivivgC9WprbUaKgGIFKXePGxcdVEWTQngvmlu/JNpcxM+MmKpcC?=
 =?us-ascii?Q?i12rEAA8CmvjJs9QeMbPJFC8S4AlD2ceKfR1BOVGICdt+mPlZA2mvKXFNFG+?=
 =?us-ascii?Q?NvVrHEGeu5y+d+YrIIf8CuVm8RZaPOsFqAQUQGEGlnngzFne+MWgyMWtfTh/?=
 =?us-ascii?Q?g83XD/Y/eYQ1QoMnf9mkhHw7/0RWYS5lkd8eeomcJkqwQUpLGCbEutkRkkH9?=
 =?us-ascii?Q?TFDVJ5kRn9Ue8Qh7u8plK5Ka69cSBYKu9I0r47T0QA88C5QGb1EVSr72G8g/?=
 =?us-ascii?Q?KEK0nenl7DE4nyTbfyECQLcXgb3YWA04Z/OcEdRRVSX+IwaDLjLv0iWB/Kh/?=
 =?us-ascii?Q?YqJ0LueyH1muk8jYHrXMV8hZZJU5M1eJIEkJqIJoZneB5tHcVcGWCcOQCpaS?=
 =?us-ascii?Q?9s9jNaVpb4r96yMUT9dc9498Aj4KcyUlljEHkW9UYp+p2fkfOmvf0usJFDzv?=
 =?us-ascii?Q?MOlVaRAgKFxHVKeBTU8pqBsB8vRp811C2bXIeZTz3ux1OZl7ZivRlnxR3vIa?=
 =?us-ascii?Q?8wiRe2J26KixMcnzJYHePFTqPYdGbhO4NlhkeA8CDmCpL8sWkdev7N8p0C0b?=
 =?us-ascii?Q?LdCMKacc9wS/d5Hmp3uFK/1dXepl1p2PVRTp4fd7FwnQJQ0SW5c5EoCHDhIu?=
 =?us-ascii?Q?7ZtX8Wv6MTKVOjtih0ckiM+HA4CM3lpVL10WWNRG6Xaibr7WRWMvJ3bmHVYR?=
 =?us-ascii?Q?MGfjzFAEmmiHDDgR5LRfFZuK4HUcdMlRQDzTjlVfkbn4zIL7p7DZoTeUVoJ5?=
 =?us-ascii?Q?Y4g9MQUWQ3BrlAn+3z7yB/iQQM8+8GEDTwQG/eZswpRRN4ZgWaLweYwD7mIx?=
 =?us-ascii?Q?n1eLeUbp5JwJM/lNWzdpSD58GqeEzsoKHYaZvEuFa4CST4HLV4nmEd/7xJ7b?=
 =?us-ascii?Q?Bs5AU1UQ/jXloc9T/QPYt3KR3sURsV1xJE56DgjunBCbiFZb+JMGnwsclMiX?=
 =?us-ascii?Q?gTueHYYLaoT9hniNT9ttcHLDHLMQk0u7vO53u+NJQK72fLrdLvHSDhyUXcqt?=
 =?us-ascii?Q?9t/3p/NR7P+0HBspohl2rb8YvjfDS+4qxFu/HpYnMInH/AFd26Q6fcXZKPpi?=
 =?us-ascii?Q?eD1kqq0Yv1ht26PMiiQgMFfTHx67rtnh185vfaUvRH9siB8qAQxwzdM+xUST?=
 =?us-ascii?Q?U9fJPiB9+0XvOk7CVbqjmFygH/PTzV/38eBIq/I+tvdzxg0ROL4JLSXw1DZ0?=
 =?us-ascii?Q?RUr4y9ADv3A6FCaibBOQb0cgSos2ejnjG1n16C9+NfqTiAlx6MpVupTR5Eoz?=
 =?us-ascii?Q?Fy5ebXHhpsp3IxoikpCeBZka3NNEIaAlRoILgxX6mTUDEfz2uYz5DEwqjG4Y?=
 =?us-ascii?Q?BaLAMKLu/0vKgTsO+IEX6HnF5AZtx+Zc+CddZm2izEWNFe0+HO+z6GHPNHtr?=
 =?us-ascii?Q?UPbQGlx3Mo97wCfwgxhE6Bdcqo0FtywUza5dOZjDbg3vsGEjz4FTAALI2QG2?=
 =?us-ascii?Q?juVzs9DiE1pFKaoQY+rBOWfdIEsPlfWEhBwWZDdwy7yhIuWxOX2f8l+tyCey?=
 =?us-ascii?Q?rQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gqShSs6KSqEf7GUl8+d8oKkMps5IHlYVpU8XbL6kitDSj1LI8ayqiDwmmX13Wyd2OvM7j7QofgLRvhV7LXN1WwtGIQykGnEEDwY4Ddx2fuZuNTQ0VMYgwviEUqAWbOBpwnaXRbsV6sC/23G9KUJXfQeiOx/ndSxP47U7Fx9AeVMv18iwZFJLssH5Fj4QasXVB34jCqQ9ZnXK9InECZzdm11/9JxpVvsQYnnO/I/IbrepnH4qXkj1EmLHosNQoVPXvXrjIvitLgpOK5eXVYRq6q43BB7OpySSqXYYOHTxg+9JO0PMR9muI9w9LustwDz8pMctl57KMqYpjqJcMjaqxaavA83Qc1adFev0pBKlQhDGDNBRxi/FTzirpVsEl6/+G+G4gxko61rP5pJDaYH/33Li4hdbFyP+2uUkbzaHxhLNsosBDBsodk//ZdC4rtbEJ3DibUuC3CImn9vDlwvmY3u4fY9egE+RyNsHmHQYfb5/kBax5Cw+APJZjre48yH9JWbREPy6GijX2Qa28h+3rQfRcAHLoO7w+tvqeVVQ7SWHjiscUBzULrl/1cw3b9QgBpIv0P/ar+bTjvbSoxQcU0u8adtCB4N1rIDxiXEetoM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56ccd753-37d6-47af-1f06-08dd91c710bf
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2025 02:37:12.3494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LGcy+fsjHAdNig/NnQNc74Zus/yNRvHRFosnonHeKtMIqfZsNOYUyZhQ8xEGzngROpQiYuG6ts4IFblfr9ORizx84z8PcZ3GzHMQeHifYu4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF5816B0BC4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505130022
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAyMyBTYWx0ZWRfX5hwWGAK+23Nu pZbkJfOT+E8x7PacG0704cSSGU94sTw+9XnwVq3jVN36RWcozNIlc4vD1JWrfcyqD5HMagvkAuL KpASLV+kPOOA582bwfHyts8JMD5my6ZPGjyvp4OF0egkS1VAxqpARHLZ08IhuQM2EpLw9KO+Djs
 lPHAftlQBahWE/0/euYHSjt0q3PTQbtL1a0AxE3Z7fdO96e9na5FdXdtRPbfTMLiz1YQqm35j4J ZSHHKshDDOfhdUQBClXiLm0xPzlZ0TxX3CLBvZgpgV34Nibg0bItb6TV+LkMOpM2syTtUFdukZm h0Nh3mHnqH3j0brh3TnWMTSUMftqsPdl74RC3iC1YYp4RS5wCTTFTgt3Gr2L51zQ25sVcRoxW6r
 XKsg5mWIPTUSYGAJI2vrz9iA5d2MHJdP3glq2p2DcFMxx/zRBv62/lc8xLUuA6W3mamxU/9Y
X-Authority-Analysis: v=2.4 cv=RPmzH5i+ c=1 sm=1 tr=0 ts=6822b05b cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=l6_WW2K9cobEqHbMLiYA:9
X-Proofpoint-ORIG-GUID: XwGh9hrkJXFkE6ew3oyyi6BAxMtlPKR3
X-Proofpoint-GUID: XwGh9hrkJXFkE6ew3oyyi6BAxMtlPKR3


> Change the type of hwq_id to u32 because the member id of struct
> ufs_hw_queue is u32 (hwq->id) and the trace entry hwq_id is also u32.
> Set hwq_id to 0 if mcq is not supported, as SDB mode only supports one
> hardware queue.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
