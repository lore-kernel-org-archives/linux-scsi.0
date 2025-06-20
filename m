Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF68D819
	for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2025 03:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750388455; cv=fail; b=NbDUn1FuiK8byz2nLNhScmmOucH3MNFxDs9dqscJB/0gKaYl25Kjky6gXK2ZbbQTN1k68BJKybvIA63zYpd6GuuwoLc/V4AU67v5IbrMplE8qQcDLL/cMYDC321/dPq/oKAY53pZVOAco4GVPiI/iJmoyoTKj86lOjwXn6F8w6U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750388455; c=relaxed/simple;
	bh=2yaTPLkFMRdFIYyL+wSNVjhPpOIEqwv5Fd6sXD4npjo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Nwgn8P/aIr3V1p629cR1cC9vAKOINMBQqLwb5biIWnKVIA6lu1L4Wzhr4B+WdfnM/T5YriV4xtssCz9wjRicseeAc9x8n0Ab0UurTRB9wscNBvwVSWWn/oJMacLxA8REc4LeqInuF0bNjEJnL9hS5t1vviWAGndDW/dY+OGVopA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CcX8wf3n; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vPLG4FnK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CcX8wf3n";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vPLG4FnK"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55K2teT8008681;
	Fri, 20 Jun 2025 03:00:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ahzFIokzWuFLht2FrV
	niNPzrxohDJjlQHj6vCrrGuv8=; b=CcX8wf3nHf/doml7SzhXB7MhYntgk9bwW/
	Z1I8airb7bBRfLAOTp6CBQ53AS0I92Olutwi2KN1VYVoIEpD7P249jyL5dvXe7Hz
	fSQuauFymIDj6hri29xOrF5lk/rGYT+vtyrqun9pZNydavEPp3zbfX+Un1cd6lBX
	Iou1gFN9nLMWHoL5Deuc5a0KtC0bEsWe8j/SHnnt+lX0R/0T9LeMv3v329G/AgQp
	KYGi7K5fOPrGQza47dabyal9/YtrlB84CFld/hxxh2lH6D2fXQKv1ThU5R0zSXaU
	LefExT3qhIpm6PPCb9+pE+UNobmD1nGK7f5LF7xvcSSHG1dRl4NA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 478yp4twfh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 03:00:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55K1NupC018393;
	Fri, 20 Jun 2025 03:00:49 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yhcewwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 03:00:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z3+Zmrz2sEWowHtq3mIhAs1J0baMl6GiWoHKBFTNiB1sLWySR63QxTLE6aUvv7VXVxGc1EagSUyrN8Ed3iDsMi5j/RqNSUcY4cV4xwILfzyO+OfqRQDJJsFMMB5XpzXtrvHxYrwIAcHabzT5wEZAdkXutRIhznMytWZIOTPhqEUK1nACmqHW0l2QM6748kvztmAWzXXrvZ/rAvhqO0+OmHo3M98UFpGphkuWBvlMN8SwQtAEQlYFzCfIf/wTIz7rMEQZ62BVnW2j+ZLl8BbD8nXlqXiBKdEd2uILdrOCHkMOafP6bNyHOmstieDfUtGtcyZW2jWh02o18NjDE6VEvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ahzFIokzWuFLht2FrVniNPzrxohDJjlQHj6vCrrGuv8=;
 b=yZuAmoLiKi2ohxD5F4hRkOSHiT749WfPLwobV0iPxGoCQnvumWBqP6x4LIGRqlXV0ZxYo7P/yNOng1x+A6bsHE4atspoJbmJ3guZHFd7FiTI56ath7l1FJqOkPSupTW1nVuSegW8aVSDDbKonhzhjqfKKlfAye3Ozh2Q0FH+TqI5mayse/LqRizRFRPzUNws4sK6PG5V5kEaJZI71rp8eKXP99KlSCusOuPEUpJQMgNn/0IzSs55B5qXgnevWIA879TOkCbj2OGNkLNYQDfH9XCEIvwiBj6fjSF+73XoDIDRlBA5lz1S80XgWdJ0SKPRw5l7BcRf5VkVIGTmAEyrMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahzFIokzWuFLht2FrVniNPzrxohDJjlQHj6vCrrGuv8=;
 b=vPLG4FnKR15+Y2G5PPIggf3xibx9O9d1nFkMjtp/vB8SjiFlfq1rBZUXoiMDupnpiLjUhWMs9lMkg02bSn8kxAfXgrnbDN26fNspnSvW4KnrMThLJfc2cjL7uLurGidQFrKygQGAdePDU7nOgSYruugsQPrwcJql5TxCsfeTk7k=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB5787.namprd10.prod.outlook.com (2603:10b6:a03:3dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.20; Fri, 20 Jun
 2025 03:00:46 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8857.020; Fri, 20 Jun 2025
 03:00:46 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash
 <sathya.prakash@broadcom.com>,
        Kashyap Desai
 <kashyap.desai@broadcom.com>,
        Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH 0/2] Improve ATA NCQ command error in mpt3sas and mpi3mr
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250606052747.742998-1-dlemoal@kernel.org> (Damien Le Moal's
	message of "Fri, 6 Jun 2025 14:27:45 +0900")
Organization: Oracle Corporation
Message-ID: <yq1cyazt8w7.fsf@ca-mkp.ca.oracle.com>
References: <20250606052747.742998-1-dlemoal@kernel.org>
Date: Thu, 19 Jun 2025 23:00:36 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN0PR10CA0011.namprd10.prod.outlook.com
 (2603:10b6:408:143::13) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB5787:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c378c8b-7390-444d-399f-08ddafa6a6d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?H8NbtOG0Gb+gDmuA0qrLB7bV/DYUj3hATBkb68T973hpKIaWErCRxcE+7Wtt?=
 =?us-ascii?Q?42HU8nNSV3rSWohxhfcxRCaBCJMMUmkNim1nUTLwvnuI63p9ALlQJQBOsPis?=
 =?us-ascii?Q?StibbO0d5DGJ5nW0An6btMR0I0cLXzMVceN2QWWjjZX7pcabN2DIHfnC1bXo?=
 =?us-ascii?Q?2ReR99N9nS1eoCv1Ba7eEfD6fTnGvnro2Ei9dGUdLa5FIYYyIsKZzngPr28G?=
 =?us-ascii?Q?rKFT/3rY6EvcRp8YpUGWfi2+f/u588gCi5As9DxLoF2zSCW5bQJwGuNwpLrX?=
 =?us-ascii?Q?mytghh0t5Tgog+TiEktWN1ZEdOC+sgPXEIxWUkVO/TQOyQuTrGgSkg7G9CgS?=
 =?us-ascii?Q?xWjYD2JlUq7r3rbkREdZJ6T0ogjVqcawno/953/PXYqxbE2oxKSUuGLmYpJA?=
 =?us-ascii?Q?2rpM+VEnfAbd8MUWn+3+4Mh3ljyvtop1uA7bvTduEixQolRSsSPatOHSmr2j?=
 =?us-ascii?Q?HLMR4A2Kk7APHUgjz4m9kXRc5VTaSubwkIthBdtiK99GY3ZQIUKLhWY5djER?=
 =?us-ascii?Q?yLw5plaRnFmQ61fTtC0w0aasyCqIUMW831baL1zhR01TiPjFDMcESCCf7mEH?=
 =?us-ascii?Q?ZivkiBaJSrP5p9yJwbeHwNB4TU1xC7ulIshJyTuoXXOYjb6wILCY4LsRvAwq?=
 =?us-ascii?Q?AE3ggcJ9BLHUl59SPlG9zZ1tB+GCwKBKJIOzxBtG0OKLaojJYZVysw9skH5a?=
 =?us-ascii?Q?YYO1f4qmj0/N3FVU0FWzvpCDMNQDk2FPnZeZniJgO/tcHuYibPuk5JX2SreI?=
 =?us-ascii?Q?cFdaY9kNZgyvpxXcw3gdZSltZDEmoa4IUJl8VeVzQb3U63aoSWEiZoRWcusx?=
 =?us-ascii?Q?jMh4firL0UuuJ+adoC+j/OcvHA1ZxKqA+1lSTKSjSZ1hghG/pjWkip+5JCs6?=
 =?us-ascii?Q?pTtFo3ugck4EVzaaa1yogJ7rvATIU+2MB+PBcUVHU2WQH3iAdRYmKmapgfRJ?=
 =?us-ascii?Q?xB6dYFpmc3jMmc8Rq60DBAwq1bmo50qzpLMb7UYRSROtktpJTw07IN9AgPZH?=
 =?us-ascii?Q?vTl+D9R5Zfag1kDeEpUb5ERVAii7GKTE9sGVNNhWVnRIYyMcwdUlPJ0cp3l+?=
 =?us-ascii?Q?R3AfG3kNpSqjCn5FXcHmA6A/4CSWTGyTUQrSHRphoy7bkokdKpe/IbSOBuvN?=
 =?us-ascii?Q?L2Slxn0XgNyhci9mqdJ5KR0IKucZa2VkmKpWrD5XPZd9fBodcg2GUSC6IJ5Y?=
 =?us-ascii?Q?LA81UloqWaiiHgZO/DPdi9s3aNZomkT+Ri3Yryy67XGNq8E/pZgmoDCjhC8e?=
 =?us-ascii?Q?hBUzReXLpJSOSzpa4PtISxarQVta+qhw438K3w6go5YyPpGAvTRtELOkhPbt?=
 =?us-ascii?Q?TLX85kmdohVbs/bsXnyKQWI7JBzKV8hjCTOLlSktGY3limr4S3cuYCkugVy1?=
 =?us-ascii?Q?VMOL+RvS8+tI9ml4v6gNmPz/FKD9gAcK4c6XItMrGGw603T3ee5k3GhMLGj1?=
 =?us-ascii?Q?zOxmHFwMxro=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nP8WQ2+79S6VJz3Vs6xJFlhQ/wRpjNRFYNg/mnoiAcJmYUnKexx/yWOw7CQe?=
 =?us-ascii?Q?jjP1mjUZLE2U+k+ywsbvd5V1keGY2Wjje6xcJaM1dDL2ow0WchtsBuYKaJW4?=
 =?us-ascii?Q?zNFiTx2rPz+z6lnXWyIp6ta9P4j++mn/e+Xx93VZ8oEGuicDMIYRIxS/cQqf?=
 =?us-ascii?Q?PLxWmuOUlxyoL7j1QAHR3H1tRkutRm8MiWyH+mGUeEZsI1I2jLSa1BQS0K/D?=
 =?us-ascii?Q?9M67O8kZBSQ+738PqibeXLy5M6IzUrZOs5cNKgFyDG8jY2+8shuRcL5W/Jna?=
 =?us-ascii?Q?kBdBhyB9LhDB3ad5XGkFSuQwNROKFQ47pr18cN2Tr5AO4ca4atUfaId9muEm?=
 =?us-ascii?Q?JL7Hw6mblGscGm3d7A2USL6eG29JK8LJJG0CKb4Jck3D7Uq8PikPvCNJhPDZ?=
 =?us-ascii?Q?avK+zfKF1jB+DcSo6rMfBZt680e5GejV7aJJEsjLMNxowX1cX3+nA+5jaxs5?=
 =?us-ascii?Q?uBuE0iDbx1x6xZ+r24YISTM71YLiXS7y51VPf08A0dBY6IOdjk455HnsppSj?=
 =?us-ascii?Q?B3kr28FhhLGXSzDRA30jNJPQq47GFrlptwVBIP009Uvaq9au5H7kRCDJUfYR?=
 =?us-ascii?Q?PYmovZjbNFGJiRIn5+zOGVJHLjPN8KSE7PwUyodyh6iVoOaz8lUs1P8m/zdT?=
 =?us-ascii?Q?g+lyQEtcBqBqnHuolDh2m3icqUb1haKOnIMCtjbH23Ge6J+AMMvE2i+st0kT?=
 =?us-ascii?Q?sCSbtNxmxDWT3rjTqjatEY2FvlP4IhkSThPpKGBQP4l8UXl/MPxNWuZChKV7?=
 =?us-ascii?Q?5QRaxXAL4QgHFRHWZcxfsaEHdfs/9isL/rv3GfCnJ5ahOi3zXe9T+Vk/0Yzg?=
 =?us-ascii?Q?Idjx3/C/NonMA/05uFNmBW3aR7ERY4xFdoJ77Ho90oo6sj1TUShFl6Ad1mQK?=
 =?us-ascii?Q?4otw3LiH1AytUG2wmSlKbEXPVPxDWy5BO41in9wY1E4Uyy00M8xlYDCJJAkg?=
 =?us-ascii?Q?GeZmLh5LKvOPnJz2Gyqzh2T7SNn+Ej5OUlhM+avXd5Pc5W90JbW+h7Fi6XC3?=
 =?us-ascii?Q?bWr8sdNX2cCn31QF5c69HOoSbKFFuFu0ao7YZ4jg2suvaWDK9GpaQDliDVze?=
 =?us-ascii?Q?seX9XQ/ruVGibs0rJ+wU2I5fHimFF9E0rZyqkmYHDxY6AqHkcBydsAl0Opyy?=
 =?us-ascii?Q?7vIztwUo1HTmkTHylC/zsD9sUiuYTXKr5rvCDsCU0d7HZPLYEcmmFBKAIa+b?=
 =?us-ascii?Q?/mzOLnzAh8QydAGxF59da0KPHjlliChcvFaGXi/KiPOdGUyC3SAHIT6Nyhgh?=
 =?us-ascii?Q?LShjpEjxn7sHidI415iPTNoMQesTkm396eNYQLjB+MXy9pce6ZiJup/tdOsf?=
 =?us-ascii?Q?MUqIoQGYjX/UIrg9hZCkxNriV/XUu+tjEv81bfLe43FHSzAeuRwdEcDSfBSN?=
 =?us-ascii?Q?2XLu3/7vRKdz6Q49bWvtXqhuD8KAcDtfnpcJH8XY7MJiIKstI6PlSgVqs8Vc?=
 =?us-ascii?Q?ujl4RCg3MCA6cr0vNHIFkmdoYoD+6wISQ2RzBJcGStc3G+akt4sn8ZzHiJQ+?=
 =?us-ascii?Q?NVJT17Lobgu3+pT8H/jCpujOVZxy1aUv1Wgt/unYjjQMzIiZVz0mtZ7fn+DO?=
 =?us-ascii?Q?Wg2OeiProwObyNw5UYElWd5luYE9rGHOfLMBYShFvDI43j5JPsvnEGQJorFE?=
 =?us-ascii?Q?dQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8gmQsZ4T7IAWs91IwIdJ61qefQ3Vhq86X3uU0jve26KUN4jJ+iFSCSD723Ckq/t/4t1F4TPdLHxzt525gCH+6a7hhZvCokAtxFcPY/LjJZ8psauP7ubNaz8iv22Dhy68VrCzV1xeYKKTZKdUxUgo20KI1AYpl8vIioqSadyV2HQdbFpN1oRtCvNih4y9hBucJr8pAKR2vtf403qEcy7XyTF6IXbobZrcSSr8m/tqpzwg0G9yedLx8qblwgiro9vEWWzA5phUrtRvvkzJJIiQD6xs7c8keTyvK0TN/J4VrtNpjHxhEMLdhPiAzE/92ABy/lqiXA/1BBYsRC0ANAbDME3snL4jLCz1KDNLvMEF0TZjnNHQ/6o2VGB1vXApSPm1gzVq+pCySviQbtJG0hHtfrolphiBVatDsTudWO0GN8JXsIpjTf7Ne671AHElGHtzVYyThDNwKGxKQ+6pBtHkkPAFpDfri70tKcnURM57cc93pd0dpQ2LiaMpNxS0dh1Z7/kit7ce5B8tyWBu4THTjWyPdMJzBTiqCBR2ktnAiSesWcUApN5PEs1zlt0skAsR3Iioro9mtRwjTzO+hmaG4YMYH6CeDFo5aWSEW/QQgcc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c378c8b-7390-444d-399f-08ddafa6a6d7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 03:00:45.9139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rez9DCNUvAHpR/nW4XC5WAFsl8Ks53jJmoD4uRKkxwAYOo/tQEuSYIjq6HSp0mBxqZwdqDUt/81pW1uWU8M/LaGodJy2zPVdYdCkETCGz/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5787
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-20_01,2025-06-18_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506200021
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIwMDAyMSBTYWx0ZWRfX3d+T6yZ4/ftv Ppnl8KsOgB88O5iDeNtBWRwwxVGXSJHxUhEshTUcXH4tY1OALQ1u17xG/aUh2FvXSvelHwoWrTS oyK1Ggyikh404rafnIvb/Uka5ef0ExhwvbKayZtzkesYMo5DpiXCxu1jiXrAZ9w70QbWBcit2i1
 Dvs8TA8+kEFqmIhC006GkpG5TiA1AsjmQy3Zr2aHly1FVj8eCN9fDu4lydVIZtAMNxdacqnDUcd 08zXss/INZ4BznheDoKZWAvlsRkr4tuQ8gASAolGiR5ngAFFzHLLX9vDtH1JgyEks4c9BPKtWGX OGkhkkhY7cDirZPXFKaBsKXslXoVb/PHbD7vYRDQwC5HATTCsz3i73xYkn+6rN+JeBLu3oAhZ0h
 l/S+Riplep47vr5gW9yAoVQEfi2rEeEvOI2sCLu6mNPNKT3zsHrYhaxcGzNzP90uLevaM7vS
X-Authority-Analysis: v=2.4 cv=K5EiHzWI c=1 sm=1 tr=0 ts=6854cee1 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9
X-Proofpoint-GUID: RIYZiNXz948Aj58JkifcYGqtH6zfS_7k
X-Proofpoint-ORIG-GUID: RIYZiNXz948Aj58JkifcYGqtH6zfS_7k


Damien,

> Two similar patches for the mpt3sas and mpi3mr drivers to improve the
> handling of NCQ command terminated due to an NCQ command failure.
> These so-called collateral aborts must be retried immediately but that
> must be done without incrementing the command retry counter.
> Otherwise, these collateral abort commands may endup being failed due
> to other NCQ command errors.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
