Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012002.outbound.protection.outlook.com [52.101.43.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CA5258CE5;
	Wed,  1 Jul 2026 14:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782914504; cv=fail; b=eLZ6BrKwIBh6z761GhgILET2vOx+1GJODYE58XgdZ80EY6mAl2iZCgQqZ6SR7CrPSm2mIBxe85iTMgl5kGj2sxziI5OiMZhyYbrDZubJmbvo3Ozxtg2JXITx1IT2gjo/9OiszI+OG9MtOExygiQp5U3T+DJpI8ADbGvBk2bAZig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782914504; c=relaxed/simple;
	bh=1DxNEGj9NUoo3hE0EA8jtYIOtzn1a+/OWDfMESh944o=;
	h=References:From:To:CC:Subject:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=KvK9pcNvuVQiKSDtUOuyKxUNKCGh6PfKZNn0Xuia7AH6IUS04kW+Jf+uY+JO0S2LB+yC3DwgUdUjPsj4I1rdX0/VNJAtzk6a+Yt/Fu3orYCo+TAOfSg3PZtH7ULYxh5uHSdFVHWT8DYnwkrHiEMt8RqfbeQT+Imu+RqgruECWeg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PT/vRVul; arc=fail smtp.client-ip=52.101.43.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PT/vRVul"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xYGQGnj2GZgLhx1Y5hc4CRs5fYvWfLirZTxDZN633g70/QzcwW0WbJkCgY6c/XPT+X3H3VyLlbUhsS3KV6oJ/EWEWoD+RPTU2QZFrrLQOzBE9ECuQUEYIEZdf2mYKnQOPd3LE/x7UbIOxa1qAegpTkA8lrYwHrTUPBdQY3v6JDSp7Ekwd1pPwKhNbaM9RjJJ2RGCHdqr4B8cbkVIx2ar5tQ52B4xLt9FVaZkWIZWWFvQU/xtxlpHvcFBqSFNvZScVCDLEffLkYWz6ZD8krnrM5OcaCzPeRUEKAtSDjBNJhrD/qnYmpyQG9UyQ1lIcN2ovQ+xV8UYqwHjxUYvx1IZrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y9hP4k3So7cvT0iAfuN1pnBvVtkOp3DzaD3/tMN98lc=;
 b=l4Z/7UhoCvilRORqcbaKfao58zP4oEWDu58mPExd1IEuNBJt1AI6i2AsWoT2SfsXfWR3ztPKw2eAe7Bxcvl8OAx73KLBXn8wlokSllJe/hsINrGtyUxSnJfU6PlZqwlDLjACie8s1Q6Fe1BUTdFmVEse1n3Oo9Vd6P/vrpCBp7aFmIf1IrObSYFz156UIDxiXCdG3H4kKqg4ti4aCZDkcJ84ZmMzcqlISiOeHrTzXrP3DQ3HUzRVWOjByteuyYTBBrQs+eZgsMht0ETbwiJH2WZ47eFmcjrBqYfk2+ZeAEsPSADjU/gfmy7W2D2s2Es54Ga8oQENb9HleyQOjTqsdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9hP4k3So7cvT0iAfuN1pnBvVtkOp3DzaD3/tMN98lc=;
 b=PT/vRVul7UgcLrtzHvNtI6/Ps/X9cBklNWubSEoSyjwogX04BzSfPexI4R2RSRbtdz6XqxUCQ1RrOF88+wJzYGSLcjixAfBTqt2wqDsfmYUvl3j8d5GzEH07/UedfEa79gT7yQmupwTXgM63hrv9kwCYMC15GJ99LWb1PWHV4ajiUwnhJDHXpECvRlseNFbVb11tkdKQjHj2lDlVzhPxG3u80O/YHYRpaVHwcGyt+47a0iMEpPfZeiDXwGAsgOm4nL6spr10/wCPSNmJ9TxrRknTqunxUZF5p7yZbIDoIGnHIDEnG7vwebapmQFQB/vpb5Iq6dEYUP5my4NcEzTpJA==
Received: from SJ0PR03CA0175.namprd03.prod.outlook.com (2603:10b6:a03:338::30)
 by BL3PR12MB6401.namprd12.prod.outlook.com (2603:10b6:208:3b1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 1 Jul 2026
 14:01:34 +0000
Received: from CO1PEPF000066EA.namprd05.prod.outlook.com
 (2603:10b6:a03:338:cafe::3) by SJ0PR03CA0175.outlook.office365.com
 (2603:10b6:a03:338::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.19 via Frontend Transport; Wed, 1
 Jul 2026 14:01:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000066EA.mail.protection.outlook.com (10.167.249.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Wed, 1 Jul 2026 14:01:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 1 Jul
 2026 07:00:58 -0700
Received: from fedora (10.126.231.37) by rnnvmail201.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 1 Jul
 2026 07:00:45 -0700
References: <20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net>
 <20260630-pci_id_fix-v2-4-b834a98c0af2@garyguo.net>
User-agent: mu4e 1.8.14; emacs 30.2
From: Petr Machata <petrm@nvidia.com>
To: Gary Guo <gary@garyguo.net>
CC: Bjorn Helgaas <bhelgaas@google.com>, Zhenzhong Duan
	<zhenzhong.duan@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, "GOTO
 Masanori" <gotom@debian.or.jp>, YOKOTA Hiroshi
	<yokota@netlab.is.tsukuba.ac.jp>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Vaibhav Gupta <vaibhavgupta40@gmail.com>, "Jens
 Taprogge" <jens.taprogge@taprogge.org>, Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David
 S.  Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	<linux-pci@vger.kernel.org>, <driver-core@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
	<linux-scsi@vger.kernel.org>, <industrypack-devel@lists.sourceforge.net>,
	<netdev@vger.kernel.org>
Subject: Re: [PATCH v2 4/7] mlxsw: don't keep pci_device_id
Date: Wed, 1 Jul 2026 15:57:50 +0200
In-Reply-To: <20260630-pci_id_fix-v2-4-b834a98c0af2@garyguo.net>
Message-ID: <87y0fu24jb.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066EA:EE_|BL3PR12MB6401:EE_
X-MS-Office365-Filtering-Correlation-Id: 7428bff3-5619-43fd-5fc7-08ded779421e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|7416014|376014|1800799024|36860700016|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	WRS7BcZtddcB1wjGZoUf4DsMLe9NX3ggQrCjpsiuiDtGQQUMz1svfJipsQvp4rofXTorSU1VRAcQIJLkE2En8wyGhW6IJKFP8hnZ3LBLNIkm/7Qa3oiwS9mMfu78VZcUDbCiHPXDaae52/LIu1vbxQB7xRKFFE+r2ID66rv2813ilFWLJrq6WOtbHnmJkqzpM+m9deQ2yxZdAESM2E7o4qoR0hF0cf3h7FQIOiUdfdXKJijdzz/uMFZyDegRUREf5b3e6I67k0EiwzUWDi55RPTX7IzpHcq0wZ2prc9ulcPJxeKkALj+/jkQWqBjaGUd9NPa6wPWiigzOL5Eyalk1hP/5x8ls7lY9P7tBQYaf+9zuv8KKC2OmtH1DqrA07sX9c6ln07whCT4UlE8Cntm50JeYItf3ILfHSHlUMyXbRJ+3tc0NK8iAcklin1UJ3my51+kbGYKE+DguDDJpVveTDGQKPTp0fyuur3lz3sLi89LGesZN1L/6E5G1cFSE7MFWJIlRwrt2bohP7SQyuIRO0BX4S8RxGiInLTqM+M/o20vlUzutPtPr89zN7WeGLilxf8vbijMrbJRJ/osl24A6MIm3ke2e0fOkHZ+5t4FPd9ih7zTn4mdHpCNKb4VfJkfnZhxCBbHUSE5ry2dlkCTitHXWpU09Mr24/mUVlUxsVzsCd3YnZPPuTAzyx00pBmifvR1Qk9rz6ZGQ7fKjUqu5g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(7416014)(376014)(1800799024)(36860700016)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	z/Oz7TqXNIF8CuI/ozfVzNT0iBXlTL1hUSpKiNZRpVxznYxR0OtBfZTdtnhAwoLRDDna19iXHTp8HaEPaqMIV2qlaYpbkiNyAdID0B/wBld1XyjWHVN7ZBrE9fX6X8kxY6G0MOWaAvVZQIsRNiM+HC1kIHkuPnnfpaeuVgHmJ/xpHxDQLP377iEJFD/0az6IhIIWVxrYiwktsPcWaeV7joZKiNklT9RYyCLniFbkfpLbPck6GkDzW1+FSxb+EgqiVB3U2CgYnWDUfMA5Ji8AFejbY8KmCfyzz/9zVmIkDxlWJA0TujC+geUbMgaI8qjUxgDuyWv+Q+hHwLs9uSIQIGhLOWuesYLC6X55LVSPeW08Mv6dzAXzSBMkHfjcntfrmv+ptn78mC5YWEtsfYtkOntuv3P+VHCl1M5RqUjemSzIf7kLEehziv2NVPqkpMZe
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 14:01:32.9006
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7428bff3-5619-43fd-5fc7-08ded779421e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6401


Gary Guo <gary@garyguo.net> writes:

> pci_device_id is not guaranteed to live longer than probe due to presence
> of dynamic ID. This stored ID is unused so remove it.
>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/pci.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
> index 0da85d36647d..bfe3268dfdc1 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c

> @@ -1768,7 +1767,6 @@ static void mlxsw_pci_mbox_free(struct mlxsw_pci *mlxsw_pci,
>  }
>  
>  static int mlxsw_pci_sys_ready_wait(struct mlxsw_pci *mlxsw_pci,
> -				    const struct pci_device_id *id,
>  				    u32 *p_sys_status)
>  {
>  	unsigned long end;

I see, we used this to detect whether we are on SwitchX-2. Support far
that was dropped ages ago in commit b0d80c013b04 ("mlxsw: Remove
Mellanox SwitchX-2 ASIC support").

Good cleanup, thanks.

Reviewed-by: Petr Machata <petrm@nvidia.com>
