Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E8913790B;
	Tue, 10 Jun 2025 01:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749520409; cv=fail; b=Rms/R5OGPms7O77nK7hl6Z8vDBBWyTM/TiFcFpmaSC/+b4FGGzpD6mROodxjQN5rd4xwYxZc+9EveC8YE9g1ruo6EJ4niS+ctSJs6NjVMoRVNOgjnWjWkiUitdAPfTAFG/qDnG3+B9RUrnUeIAU3JsOgaCTjWMwiCXfc+1Sa64w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749520409; c=relaxed/simple;
	bh=laN7nZTbpEACUjFNrOhnatHRhR4D/Z9oHQmHkWqhDwU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=qzgoPnO3SDErOT88KT+D7Th7+5YQE6gIJGGfn3/x6zheHi50dMyUh9AZJ8GVMWlhwEvg1Er1mnlnMzsDeD72jlVNMBQe+HD92riiFZQmkDjzmHeOhMTGbTihD4gdAbTQ36FHxfZ5maMvElWfC84pOa/kI3EaULqjDgQdPrQ0OyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HIX6w0g8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=riFoGw+6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HIX6w0g8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="riFoGw+6"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 559FTxQ4031185;
	Tue, 10 Jun 2025 01:53:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=77MxvL8afI2+xwYMXD
	4hZrB6HPS8AbmlyPy6BzamG7s=; b=HIX6w0g8A/PckIyx/9TNcXW8JEeCKVaAjz
	os/ZI1E+LikcAt7HE1O9Ha8FkPS4QtMck+ZO55fy7lQCoTYLaOE7bbHbQp3m6Q9/
	C1iiOcE3PQ/Xopistth7WA7A3UiUm7f8pSQ05n0wBnBwo/SmaKI8p1lXEBAqHSqE
	iB5VV5RsIMSBlPczVvDmv3ti/+k/fzwTmxWjS1xt4LvjoUxt1gWliWSBT3CaRjKr
	ULhcADajPlvyiH38mqrAUO2E968esKc2bhiJKonN4a/zp85N7V8l7+BIYtNk52Rm
	jZucrcQKtPJaWrsPNUPeUzZ2Nd6aGoCTYfQLgmQ3/uHSk1WqljsA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474d1v391q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 01:53:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55A1ebN8020654;
	Tue, 10 Jun 2025 01:52:48 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bv8uf3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 01:52:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qH7LGr+cLzbo/3f9isHMgwKcK4Aukq6tLTI2yRImr0AGNGSX6VIXqbLMsxscWJkgUh0HlWeIyS1ON2yyVy/Ck7xR+fJ5cM51X04sPcVqB0EQHRh0JGYmlJf5de97xcUgzLKMma1igmDVoKB0psirF4pmXlpfeE28nvpvf3vH4jxU8SEcT161FPa9MgLZYHhzKbMcjhZF8paCHFLh4SfTiMhHMO4iKFilR8sKZbZgGozLGBwQFLaoCekpSMEh1c3aOhKdULor3KlALRgmrmV6CtZzjQHHvtz981K3jxHIYqQFYyG75micDcKJDnmuphRVCkR0ia5lACJ64aTXc3pkVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=77MxvL8afI2+xwYMXD4hZrB6HPS8AbmlyPy6BzamG7s=;
 b=wRHVs0z2R2DpRoJ40rTtTeSlYs1By3ianoa/w8XP8X90yHXGbex04s9XnNLgo64m36jazCTCQvXwW3Ns4qvSbBAmVPaijslVCdy4HTafs24D/DIj7Z5/78x1fndx6OjIVw9INlfsYjcpicSGJSru82BIoyfqZn+Vr5mdNk+eDnQ3mtlUWyd/pYUM7wy/ODcHdTWsJ5fbaWK6yuQpV/JpzjgIASeE9jsqLTr+kTy42evzAvPqkoH7RTL3zfAprxcKzesEv0mXz4xEJ0joV6e2u8nVlZUFev5nRuTYsO57dtn+fQUxOo+uYlN9acj8qzqjkO0H2Xhcvh4oUeaZLPhfgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77MxvL8afI2+xwYMXD4hZrB6HPS8AbmlyPy6BzamG7s=;
 b=riFoGw+6495qh34y3cMmAqMLqvktLu7hb4aWewcyp+6n/NCB2ODeL9z8EucpKpYZ35P0GavTxo9YcGjYVQniHR0wJ65IwAuewN0dxOmQjoCr+UCVlpDUc3HQvfFKQREGIvje8g2qxwZWw4OhIwxLER0puOxROCfMyBnSxYZZS7Q=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA2PR10MB4793.namprd10.prod.outlook.com (2603:10b6:806:110::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.24; Tue, 10 Jun
 2025 01:52:46 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8813.024; Tue, 10 Jun 2025
 01:52:45 +0000
To: Huan Tang <tanghuan@vivo.com>
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
        beanhuo@micron.com, peter.wang@mediatek.com, quic_nguyenb@quicinc.com,
        quic_ziqichen@quicinc.com, keosung.park@samsung.com,
        viro@zeniv.linux.org.uk, gwendal@chromium.org,
        manivannan.sadhasivam@linaro.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, opensource.kernel@vivo.com,
        Wenxing
 Cheng <wenxing.cheng@vivo.com>, Bean Huo <huobean@gmail.com>
Subject: Re: [PATCH v6] ufs: core: Add HID support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250523064604.800-1-tanghuan@vivo.com> (Huan Tang's message of
	"Fri, 23 May 2025 14:46:04 +0800")
Organization: Oracle Corporation
Message-ID: <yq1v7p45pny.fsf@ca-mkp.ca.oracle.com>
References: <20250523064604.800-1-tanghuan@vivo.com>
Date: Mon, 09 Jun 2025 21:52:43 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0114.namprd03.prod.outlook.com
 (2603:10b6:a03:333::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA2PR10MB4793:EE_
X-MS-Office365-Filtering-Correlation-Id: 0347916b-44f0-4974-43e5-08dda7c17ed9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pk1uWWm/lE4yXjOQXGwHi3pN6E09C0+IU8RIZDDULPpWbr2c6F3GyagCpV9/?=
 =?us-ascii?Q?QL1KpfDC7XJY5d3Rn6LHtCLSFzRUAJSNQI/6FmPC918Tn4sU1LLtuKhI1FYt?=
 =?us-ascii?Q?kMXoLhCJ5XJQ2CV5gHRkYsuL5TcLFA7lTAbD+38Fl2Xai4mT5g3+fwSjV9ll?=
 =?us-ascii?Q?kVx0ZEBOw6KD6jBFVB19Qrqs0ro2Skb2W7FApu1obcrh2eBXRsAmpIbIH0Wt?=
 =?us-ascii?Q?aCPdJgmO+EdONXnGQ4rjvZaRPkt3J/XfELghywdjQQfs/tYW9DGqG24blptW?=
 =?us-ascii?Q?OJnC7ZlkSP6pWjjPKSXWXaG45voJao2cx3LOBIr3xHfXb5z45tShjZzHqM6r?=
 =?us-ascii?Q?BzIJEzvix2T0gF53gwFQz2PHqj7MLIKEFLzZpRiC3xJLk/H5IBXfpXfuLET1?=
 =?us-ascii?Q?mVgXIdQNNMvA18Rkvn9OvqgIz0qYmNtHGpIB/vvOe2RDsl1nBZ5KfSVYVmMg?=
 =?us-ascii?Q?Slq/IOKHz/5PRTt0x8qMhDbEqaqY3kumJYSEf8w9TATm9dOTEXYx7Yu0EHPx?=
 =?us-ascii?Q?PBO9q9mPJBGWB3Ciz/jux8U3fyO2JhRxKIrSBz4Y94Z+/PKJpfFzhJtutKrK?=
 =?us-ascii?Q?t053haxiILVnKw+Yo52xx6lgr25EMiS2mneGMSk45SYgfXw7J8zWUxsC87RH?=
 =?us-ascii?Q?+V6QL0S7m1iu2EWISN7Bhr2Aicj2/GQtb+biJZGm+qdvNCHjfPYkWPuAbJ79?=
 =?us-ascii?Q?7g/5xcvyaw89hikXFFdkgA3fiAGkKt4bCSuTnJx1Idyss9qGqT+kOocB8u5W?=
 =?us-ascii?Q?xn3DDd0rJi+2WGsP5PKC6ahlBNMDG0Td8Cth2nHf3deAfEHKyAYzMYAaXsuB?=
 =?us-ascii?Q?NHtT/OLHv2DXrmX45NjyVg1iYYKPNPyInGx7GzBOTlQCf5cMjLPzlJLP9x9K?=
 =?us-ascii?Q?W3CXGrSdRB/UWljcdRLTejZbIUN3DfZeGla4Gr8rJpPQuWFVdgPIlwsePdbq?=
 =?us-ascii?Q?4/Vj0Kp7pRDOs+/TxlOJBpUR2kn2NO0qzWUabMSZTV5Ax+AlWv48guNZfFD+?=
 =?us-ascii?Q?S7niCBd7ktcPdo1PLLNHFzGxxmTn/twRmJbz3npZJw7pgTPmhX/XLIUpa0w0?=
 =?us-ascii?Q?FNp+cqxctdqu7ZxNk2/d1QnHPlyBSXqdoZIQuq518izzFOKbecbGpJhB32kp?=
 =?us-ascii?Q?LzX4qWyHT3+6h5E+HwaFc/d95SF/uZv89ID4amm33bS0ce4UavjV5DKnJR5a?=
 =?us-ascii?Q?ou7BoHL8A97L5LXhYgR7KLPpbflRlGY5879ry+QlcfePqn1CXxgDUoVYRP/U?=
 =?us-ascii?Q?FqoYHZufp9Oz8MDDc8tLVRnuXPiZ0h3WCikWY/f4nBx7qtYXJWcSOpc+Qkyy?=
 =?us-ascii?Q?7Q3DEs32QJw/h6GjfwO4XqTWY9JWU3KEtxuoJj78RS2k5E/L1CnYcARFlweA?=
 =?us-ascii?Q?monFs8etcQ5/wDvwms1gbjkp+DvsxHLeF8bEH2vsLgaX/qXynBkwBdFMj6lG?=
 =?us-ascii?Q?26YoJi/WpGg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bL+FlpgS8ciZPp38BTBbs6h/P1YUFVQogvrwTOvTVHqQ42E8LYEBIJSoUstN?=
 =?us-ascii?Q?TWSO4lCWzum2GlT4P0rjK/UE8IntNYy9uPqUBya7c39AjNNFDJ00We8ZI96A?=
 =?us-ascii?Q?2si7LS4Gte/miL56BTZ7NtLn9OrPI6SCjEh0AMkhW+w9HnKKTtLU1WSa79Uz?=
 =?us-ascii?Q?nfVypZRXMoBjjJgjAKsBR92gtr+qd/eiJHtk+uey+JZ6qEYTuWX53QyiVs7N?=
 =?us-ascii?Q?UQqCluig7qkHjPAcWeHfIotH/xqmE0h1nXzXPRVImnIiJxvL4QSsXvAsMaIc?=
 =?us-ascii?Q?TWRvYcSSjMP8BaPv4jJOz0r+AYZn0TpbrUNc17xRYdC5Z2A9dA9T27vTIv64?=
 =?us-ascii?Q?WqeCXhLmRrluVUyzrVPuNHgZB0lglAoOunU8jgvzrDy+T/WFve+51ouOq1ea?=
 =?us-ascii?Q?6SUNLAXoomE3Mv58QBIeeraCh3ij20bC4OYLPBJhaZEnBCbxs+y+Nap7Vem8?=
 =?us-ascii?Q?N1KNdvQvHlAVgZVV6p1WHtBCr71LnoEh+Az6xl+1Uk9ljQtvGVN0l+nI0pGi?=
 =?us-ascii?Q?wu1RIMKFQv2+BroJwYENMMvg818E0q8wymPcs8tEAce2daALfXJJL0WL3ie5?=
 =?us-ascii?Q?hbA4nhnX2uZBuH1fQid8EYQ3IREEZj3exOen564VUePxVmn3Imq1w97UK+VF?=
 =?us-ascii?Q?YM50rDeL1+8MZ6vqDridcL2m9dLbVGQVPuiRG0ZPxzj+kFV614Zqgr9XT8Q0?=
 =?us-ascii?Q?ih60ShikJp/ozh0nsCoO5XFug3R8sOdEj3eKIE6SwAgAbaZrv7Q9XQIv2Joe?=
 =?us-ascii?Q?byElbIOh2Xv8MWAkAw9xgwTjqsh0UBDZJiiVeCG0lNDnIO8/RNvlsblEaiuf?=
 =?us-ascii?Q?7MSTtNzr0iITelZGuQjO9VgWk2FX5ujwCFA2hv4EzyDSE5nfG6j3as1/RTAh?=
 =?us-ascii?Q?Aetm+xiHUnsy9tGe44O6buQEG+d6ghHcVrkS6kfukk0lBQ8ul/5ome4QTNna?=
 =?us-ascii?Q?hdU4y2QZVZq9pVfAFtJA8OYRpCsnKDzUAuVbsOJvai3HfJTBmdKTeq8OMMS5?=
 =?us-ascii?Q?bdf6aU7JCHtTp+Fc9MDzGwXKgO6xYUxu6yY3MkUrXQ+Up7XbMKM8yZsJuc9f?=
 =?us-ascii?Q?vFnnjn9yIZ068rT5rapKsV1UnAo0d9PRFriyuonrvkli6BDOMqtsFSBWv3Ap?=
 =?us-ascii?Q?ZpP1hBhIeEUWl2TuodiLBLxZWzUlbfhDNIiK2shkbVTg4U5W3T+gHqVtF9OU?=
 =?us-ascii?Q?KpMHhbEQnjxxUj9E6p62kvcF+G1N3Q9id6q/FBPO4GZ3tRb2c07w1+2cgftC?=
 =?us-ascii?Q?eJxysC99/abFCRrlnGRzM+CiiN1Mh6MNrj9WlwzlSaQjTA29hlVOlsOTLczk?=
 =?us-ascii?Q?vNOQPDvGEApYowSLD/RlgcP2ccsO3HKEo+1P2gf4/YRNe8P3PgyFfS/MnMG7?=
 =?us-ascii?Q?etl9lxWq9CTUKMaQ5bZNwTqrx+MEKa0Fmhhd5UqiIgZTB4hzRtOuImePW6HG?=
 =?us-ascii?Q?C3Xm5vrbARxNi1tU/fu8vHC5KDq/3+IGqU0LhGWlBagmPuGNN6r/kHZvPS1f?=
 =?us-ascii?Q?1nLMucUA7K9bugrUk6yCCb2epjZoEB6ilCTbxSuAqGYoTI2ZJi/Ii6UKr4Mb?=
 =?us-ascii?Q?CmCW15+vCAYp1JqepXDV1feF8XDIWvHHkg18Lzp0gSuzTp6Ej3WPH45mnNBw?=
 =?us-ascii?Q?nQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FkxsfPs9KfrPrV6LkP86RNv1Pf57yyNZvWnTRHhuERJ6M+hG+lVxO3nsRr80lOTedXUR9r2DbP5OhmZiKJFxKex4NIvB2iJkE6UKXlPu00u2C1/AYHuMH9Ns1P0D83b+BDFmIvRJSOxRbJlO3y2WHZBwDj2ALQoykRgFnSzHMIcnSzggJDYxgva/VFpTb21ZRLKkFazhd+1BIrUtA0mwzFjQ9wZbtuFUa9YdwN91z8lG+9EjNt36aDywdfDgBtAeAInh25izJi+HoS89enh24jQibmOShjZ5Gj8CLx5mE0O8Uum+uyU2r07o5Xfbm/Qwhb4WRtrrJGGTSQIMG1EiJH6GJDp8anXwFSal3z50W1xy71D4e+DX7mUXrPvFV2HojWTljM87Ir/EZaSDKPi9/ExRfN+L2lehi5njt472dgr6nuNMHcCKP8BvKTL3X/034lTMRtn1Wue6ZneNSF3f7jV6UsBbJnu0evYXLOEllOt0Dmj2ibChzFO3PMLTAXP8h4Ii34yhkV4/PslCyaPE6ecG3gbreQgUnvLe22Svk5zMLirbhdgkVzR1+N010uRdfqjgCNZD7c5pExtjzFdtEz3OJXVOVGooECfTTHNdgGk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0347916b-44f0-4974-43e5-08dda7c17ed9
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 01:52:45.6567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XhsOyXLh1Sqq8w0UxkyQbtZC9ZpdvLCX0J/QdUZtyBL5SVR/+SWvwB5rHufbUxo0dPDfeirKSvKDSUJyTcYVztsMTA50khXFWfGEr3BDWUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4793
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-10_01,2025-06-09_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506100012
X-Proofpoint-GUID: F-5T7aI7MoS3gG5ok-R1mcNnO-Yc8kSa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEwMDAxMyBTYWx0ZWRfX5zfcLYyA6VRs CgOg0J1jFoIzGAJPi92y0KfYXU7yPeO87ZvWCymP69fmMqGx4zjrYW1WaqUrKVTubPe4Q8qyPsE jdAEJeX7EWx8AMZotav586hu7GE27wO0lGa/aw4UIIOnSNRVm4SzLvUCr4Ch3ifdl3y2OCd+25P
 IT5ziaaR297guliHfAMOcok7K+U/QpIuxiYDypbe+wgR5M8fRi1ZKxrFkmhYOJ5vdpElJr41l3M 9QusbohNhZsDQ763Nv4EwZpi5C+pLwhixvu8ssoJX+bljzFAJTYJ+xjmUEBA6v+XKC1S1f+H/vO ozaWArC/eP9fuRrDSgqURDDdjloJROX2WQmVB7ou9eKxI83nyBZWDx6UFwL6W3OJmTzjv3D2YhG
 mobKk7BSNyU+OauJsIJgzaMt8KDiDhMUuO6utn9nI+LltL3SlQX0tL5WJocuAKzX+JwyqEVC
X-Proofpoint-ORIG-GUID: F-5T7aI7MoS3gG5ok-R1mcNnO-Yc8kSa
X-Authority-Analysis: v=2.4 cv=d731yQjE c=1 sm=1 tr=0 ts=68478ffd b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9 cc=ntf awl=host:13206


Huan,

> Follow JESD220G, support HID(Host Initiated Defragmentation)
> through sysfs, the relevant sysfs nodes are as follows:
> 	1.analysis_trigger
> 	2.defrag_trigger
> 	3.fragmented_size
> 	4.defrag_size
> 	5.progress_ratio
> 	6.state
> The detailed definition of the six nodes can be found in the sysfs
> documentation.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
