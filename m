Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82B537C937;
	Tue, 21 Apr 2026 06:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776751542; cv=fail; b=KsejoGjy2JppCJfSc5YgxrzbyTf9sJRPv7mj6kwLW2na4y8fikzO4Z2UrofcsW1z4H+uJDCPhkHTkZL9vOT14KligvU2P2MAMIdSy+PJsH1o8hlH5b221BVOAXTbqoetS3lh55JFNW5q81vXg1pLQFHY1i8+yMsjnHy+7CJk3jc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776751542; c=relaxed/simple;
	bh=kWPjzstAI4bPw/9R34UKip5Jt2rLjJD2+4fF4CIp/TE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H+H3LRGrzOo/xtvOJZn6Fmo08yTXUjjplKFhMwxr8s80SZ3RsyB9pCw/ioa+RWO0YDxhFmNGT88f9fwq7xUPHN7DpIf1knGCijhK8aLKvYDCmbdvtHNw7SRs454QrAVALKH4YoU5BnrhJvxjYXATqjCJcCiM3clg5FjaPcycpNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=PRlTWf+c; dkim=fail (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=IFU+O4bf reason="signature verification failed"; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PRlTWf+c";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="IFU+O4bf"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776751539; x=1808287539;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=kWPjzstAI4bPw/9R34UKip5Jt2rLjJD2+4fF4CIp/TE=;
  b=PRlTWf+c2omz1QyJdSgsF5mrix6TqluxrIyJYOpCBl5BBRXeX5PCHD5Y
   a103JYFtLH7+4VB2tW28GAxxQqlmoWSuiPyQATubuW63ZUcfEV3Wsfp1Q
   lhNhidlNAV4DsFyHbRAiQ0Q9rw9yoiqi0YgUR+8Yvdl/hOsc4nyH7C8kw
   WC8S9IoUn2dBQjQrMK9QyCofzy6VBrI4cBJfsvHBt6mOPM3CKf8/ft/4U
   7g2YEeBZ0OZQ390UXDsbdLTgzLdJ3hWxGOwrL7X2WXam24OKAsiVBS+Hx
   sticVfhskS7q5NW6NWI2y/7Fh2YfB6OApsQvyRGk8GgC95AAQrf1p2zQ0
   A==;
X-CSE-ConnectionGUID: tt7lwlYpQnSZT3gB89y6Hg==
X-CSE-MsgGUID: sndHZEedSPKmGzpvx87soA==
X-IronPort-AV: E=Sophos;i="6.23,191,1770566400"; 
   d="scan'208,223";a="144907763"
Received: from mail-eastus2azon11010016.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.16])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Apr 2026 14:05:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wND4iok6PuSA9bdO3Z6N6X8RubHs0pIjdxyJ1YdTKmYSEBicscI0adeBW6QMajNaSqIGFHLmx39zgo1aGjkoWdS/5lYUkPeP44DKR3GT4EdynT/vi1M/NXjlJ6s6qgfSfPQ3JT/CoHcBBkAtLdCPckvcBUcthiHlmmgbYzvNeMBKWwOOyMRfZNxPK+3TqUsX8dBJQojKZkczuwWTP80VM9sYWZdQAX5Mx7gjXIXGEgk6E1Da3Wo19DWYd5eYsZtx33XKolLIbNdhAcvl5F9Uie5Ar2XjxSrQHTr5HpijEwn1BFEZvBcVGHE+cUlChYEE/tBJjCFIhEG6jm/62T2kiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jTfeZxNELQrvs3c6R2dsW9ntHap60Oq7+50mdxRo/Hg=;
 b=No+9l4lMuXrzzypBmhxugDYvKI3w/3EBr9Yk1txCvam0WQuACglShuZi9M8KjRMxNjUYXwPT5CVX0EKUWhfOdQ8yzpvqhY3/nBY+4opPGDZcaEfhFPf2cDUNXfxzprkCHxUIUcWBYuTW0nHkrx45JNr85E8lVFY+CJIU1cJumabHJli9TsJBH0aKwWW79KcC3P8eSVWouThPqh6jbjHnrbmrdbw3UNPz39h1X/jV7OYSiss2WkpM0sILC+0hP03BOjSbmbwKEQdr04jof3de742fVHQyNoZjS08Wx/mj/9GPIdhgAro/F4lhQleIJB1P0ViMWepgCXgJFin4pwGgKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jTfeZxNELQrvs3c6R2dsW9ntHap60Oq7+50mdxRo/Hg=;
 b=IFU+O4bfsr5RX1wI3VSBADoNTjhugyaFN/cbRwS+egik0ZeK2GeKGLS/lfzavQ12RintHwNsGO4JNCMVUgPnR5aKnA4AZJarjVs2js0d79msfjcC8l2wR6XPJqjz8Ocyrd1NJmcHpiq82+GMyNBLUNBJFhGDFj82Dnah9WPRb3w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by CH2PR04MB6981.namprd04.prod.outlook.com (2603:10b6:610:a0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Tue, 21 Apr
 2026 06:05:27 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729%6]) with mapi id 15.20.9818.033; Tue, 21 Apr 2026
 06:05:27 +0000
Date: Tue, 21 Apr 2026 15:05:18 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: Haris Iqbal <haris.iqbal@ionos.com>, Daniel Wagner <dwagner@suse.de>, 
	Chaitanya Kulkarni <chaitanyak@nvidia.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, 
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Bart Van Assche <bvanassche@acm.org>, 
	Hannes Reinecke <hare@suse.de>, hch <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
	"sagi@grimberg.me" <sagi@grimberg.me>, "tytso@mit.edu" <tytso@mit.edu>, 
	Christian Brauner <brauner@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>, 
	"willy@infradead.org" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"amir73il@gmail.com" <amir73il@gmail.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF TOPIC] : blktests: status,
 expansion plan for the storage stack test framework
Message-ID: <aecQorgpAE9nGcJa@shinmob>
References: <31a2a4c2-8c33-429a-a2b1-e1f3a0e90d72@nvidia.com>
 <459953fa-5330-4eb1-a1b4-7683b04e3d45@flourine.local>
 <aY77ogf5nATlJUg_@shinmob>
 <CAJpMwyis1iZB2dQMC4VC8stVhRhOg0mfauCWQd_Nv8Ojb+X-Yw@mail.gmail.com>
 <ae47ef06-3f66-4aab-b4ab-f3ae2b634f87@wdc.com>
Content-Type: multipart/mixed; boundary="h373hom54itlhfgm"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ae47ef06-3f66-4aab-b4ab-f3ae2b634f87@wdc.com>
X-ClientProxiedBy: TYCP286CA0205.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:385::9) To SN7PR04MB8532.namprd04.prod.outlook.com
 (2603:10b6:806:350::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR04MB8532:EE_|CH2PR04MB6981:EE_
X-MS-Office365-Filtering-Correlation-Id: 452fc71e-7312-4540-5498-08de9f6bfbdc
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|19092799006|366016|6049299003|4053099003|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	OmH5cS0eJ5Tt2Du4Isyvxv2ynXDVbCV+wNEgbWHdRD18rbDx/An9Zs3ESqPYcV2mLOPy+Z+e+FIZTgUxhTuWMI07jaG5B577OKCbJR7QxfZyOSr6OP7/JuYRGfRJRujFYZlxxsk1FaVJaz8SGVkqXFGSMhciJybY6DBhFgzm3aAK0AdeG4uh5QJuHuO9/172z3z5bZ8k5SSeEZsJyXwaRBLet+6XoM03rKcXniKMFuu5RHFT2xFYbt134RqVsrkJavi+JDwq+jePXdMe4luKunTth3CweV+aRexYXKfOXan4dfnc+q09cLpVOqOvKEsf+7uAAiSCDYWezeX8oNUFqaWJnpRn5QeL+FphsS701EW2QqHTWwr/jSdW25Sbnn0YvWU6OQAgPWCfEhIIRySxjFcZv44EDiICxuFNCEU9l/g6dK6safJIcva5RCSvPIQMmFRI4WycWGTTHwALf1n4GCLZ3vR3Clnbcoge8X2EKlPi+ad5tWR0DoDOBskk7dV8nL+hwCVhVxfyBihBleLKTwj3XGQff1GfrwIbd+6YkoCjrAmuyDTZcry90K3JfbzYTm+2H4hCjP55fOKrBewRQuI1+Vy1ds48F5+2r/qTopNPt0dGxn+1aZS97EKZPzt8dfDXZ+hpbtz71Kq53IplOxdmTVCgX1meMXoezGTrQY27jgu+DECH1c6ZfNrPB/1kFBXWPk/9VN4sThdkGX/8zFeLN4f0jT2lwHt1LFjPXLA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(19092799006)(366016)(6049299003)(4053099003)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?kIERulUMOc/ErWdusRcBLh2EKNwU6k+6/6/hxBjnMaeYnWl2iG+KcXGIbD?=
 =?iso-8859-1?Q?H58D+VVa/NsuCdzjMeS3WN6a81ak2SdJrxhTGc4wHe6JvKXu7cp7dw4BTX?=
 =?iso-8859-1?Q?/9HNFZ5RQYw+6PNt87+K85wSM14P6RXLyJHVfMAzaJrbw2TPk2Z/e6ncpZ?=
 =?iso-8859-1?Q?jN3mLFOfihMJTg/Sa4W9O0BuJRVP76dzFkmAm9I5Ze9J9Oencq25CApxRK?=
 =?iso-8859-1?Q?WmIEWjs64TC7RP6pwzKTcqhOQBAQwvCQbo1bhqcmFmpyHdxKu8qA2/YQm0?=
 =?iso-8859-1?Q?BYg/OeOTpxrifaFto3ksTwtkin0ZXklZTijGtLT/Zj4WkYcqVKBtDr7cSo?=
 =?iso-8859-1?Q?jGwAaPlg3p9MEbVuT1Z3CIRuq3z6mKJZVtVa5e77Z6XXo1PMPe2XLcl5NM?=
 =?iso-8859-1?Q?wWE4OLJR5/xqHrOGokq8UzjVYic+m/s4aT4l5uonlfzOugzZBDYI19ISjY?=
 =?iso-8859-1?Q?YeT3tpmKJYDh1fEZmx9mjKV4ojpQD6N030dsAxVAtUZp+CUL7U3VLgerTp?=
 =?iso-8859-1?Q?+56ZkZdKvSHTKRHuWkpF3uatSe0AWfhUIPz9gXzI9hAROd9tIuBCikAoI8?=
 =?iso-8859-1?Q?gYQbgZFM6j6+kdjzRxO0jc+lhfLoMdcqY1APYRBNIW7fc0l/s/2d+8rMjB?=
 =?iso-8859-1?Q?MesSOsmcLXDw5oI+TRk1efG3g3l1owJQsGWKF/4VeRjS+dS4ikigPmsCJm?=
 =?iso-8859-1?Q?7OayeqCWXKfETyQROBSEfHPhRtvGFsCmdN7jhNWY6AKmkV0I+/tbtrsIOf?=
 =?iso-8859-1?Q?PAdyqI4OPtQxa7iUd7a9FLfev9PqLzAYSi55KtsxV0GTXUIPpnFvAzMFIv?=
 =?iso-8859-1?Q?k5y2cJyT5V+UF26hv0yGZkMQv0SGUJxFEGj5t7e1JRNA0CAaRRI0/ZAE8a?=
 =?iso-8859-1?Q?rvXMBuv95R5PhUQmkTJJ6EkPNC/ZyaXwTiq+IukSJu0ckMDILnFlmrmjF0?=
 =?iso-8859-1?Q?VeOoBBtdKvzE0G7ElX21DDS66EzmTUUA8eTNAiDJ7s0N90Ac+NfBCx4D7J?=
 =?iso-8859-1?Q?3mWYyK9YoUAJGBy8KBKN2Gd+h/WjmRlMavtHA/ORnmttc1UWtENfd4i4FX?=
 =?iso-8859-1?Q?M/SRO3n5iaSz7Kak//b1d+XKc34Qi/3eyG+pkt/YG5ZyTWfMgwxMDZfUwZ?=
 =?iso-8859-1?Q?rH7PPn6ni1IZoMRcsBdJBVXsjYeJI1jijoD4sfE3gjsC1yIm2tMbITehoU?=
 =?iso-8859-1?Q?GpcyB4LsVLQatS02EH8KTMnHhdpDyDRjx1kMHj5VJxHkSK8u8OoZmdL5Xm?=
 =?iso-8859-1?Q?dXM1Hzd3qCc4oNd3yvFr1qNVie28kjoU9rpswPgNCXXh1Y/rQ+vGSHJg3D?=
 =?iso-8859-1?Q?LTPOp6z509PtMbC7rodULovlvNhFOdAzn8uSPWfb4rRWQo65vZcsfhpReX?=
 =?iso-8859-1?Q?hRA0cgaMoI/PqhGojnTXYO/YHCywvgwnWGHYM1oh9a2iuksL1NttIfjn6m?=
 =?iso-8859-1?Q?kPMEnZM1SW/ajEAdY29XRNSl1NTCj1R4iKm8RMlrgA01gCcylNFP4T5spT?=
 =?iso-8859-1?Q?Q6ea3MtkAQdBbhyGrYrDtoeQAJ6SepT+gFbfePLxJrvUSk0dnOHpOo9lGZ?=
 =?iso-8859-1?Q?hnNjKn7p9GiTnj4xNOxyXSrhKTuZ5EYAORjCRQmTP+CDpXjed1UCF/I6vG?=
 =?iso-8859-1?Q?qeU3zapHd+T45uKG4dGr+0mAxj4Bb+38pSTI3gMJc2IfR/x93zYu1TB9EB?=
 =?iso-8859-1?Q?wzZg502c1S3snEC6LMS2IiXvMUG6GdAmPXtWreiqs6oKuerXbL8iZgzwXb?=
 =?iso-8859-1?Q?BiW+6y2rBvllk5ePwwMGCt/42aX2cocncBe5sCAdalcQrQqQrpAqVdkUe8?=
 =?iso-8859-1?Q?dqQpTKbLrUy77IG8Arw1phnSr5/v1wo=3D?=
X-Exchange-RoutingPolicyChecked:
	jtWyeCePC46AxDqxDAbdmV70m/fITf6+HeAbt+FZbPIhmDfg088ILGWME7Ap/oIYRHKJkj0NcxJUoXJnbKY1UbIbDMzxv1i0ZcE7vJkmUWuECMbFEriVjH+vLIwLiKpXTmMaGFlEraLnRVaGlBP2In0poRp7fANKpXNwYSwKVnwjo17FioHCu852f62QnzdhjUHPCHOLRTnMEqVAK/BprNTaCXHTl5F6Q3eHNpJwr0mZ0W+mPpijSlsyrGp8yxiEJHVrXdpHtXrSYd7H63I7M4jbfW6tz+21FygJ4HBINd+TNGZFhQ2+YW39VRrzE67jJjtIfXSxqIsC5ggjCqCmaQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Wq0AJEDi3KmxG17cazp0BKboKx6fU/G168tCZH1+syMgwF+V6cwRp0F4GU5sKvtjDHbNLhM8WxPBZm3stzC1WkDx6ptWLKQjbaNqaHuovZOgCjrQcZQiV3pVobct6QjZNmSIlbYuhctYwGvZBpljZLYZD+/gq4Z0396w2g2x07bq7wuUnG47IhHBtXDyhbqmpWG3uGwLsWd8YOGz5McwIqtpvc0Jr1LeqQqxus02UqcQz0iSQwhO57KtpktcwiTpPdf6Ze0quFAQ0jiRqMqzkMhlEby4UIGn6onhw3UMY8BnviEMTVmShvqx7JxfueZmaarQmkCLC7lSJwv06Zx25Nm6xkml4tVXTz8CVdV3MbYWOShf7zUC+uq6bEhFIvNbPtMK3J1EmTJA76Q2T6thqHZFsu9MeqlEyN+DP8I2EQrUQ+44uZECiTz+bq1xIvyUc9Vi/5QrnZarOAMP3TL5BfzbQJ8JEMwgV7zaXHjp+QD1cdHetwVyEX7baMqHoXqLn/7RK8DPdmdcMzuqomdvaOAvREuM2qs5koiXMvpX39HlUU6A0Bg3BqXWZ/kE7KVmNDEH9C9sHJA0crBBnmq2ab+UpFxFRfDGMq146ovv+ZCoG1a6VLdMuTaUH9O9FFj3
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 452fc71e-7312-4540-5498-08de9f6bfbdc
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 06:05:27.4369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o9lah2fBDwCpEyoTfkEzcHabB5tE6DYD89r1dh4zmoqqfi/Ln+myUokxmaQ7uh8okiICPmKRofI7vlIAX/ACV0uK4dDRTDktgtRWnv/IsSo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6981

--h373hom54itlhfgm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Feb 23, 2026 / 07:44, Johannes Thumshirn wrote:
> On 2/15/26 10:18 PM, Haris Iqbal wrote:
> >>  From my view, blktests keep on finding kernel bugs. I think it demonstrates the
> >> value of this community effort, and I'm happy about it. Said that, I find what
> >> blktests can improve more, of course. Here I share the list of improvement
> >> opportunities from my view point (I already mentioned the first three items).
> > A possible feature for blktest could be integration with something
> > like virtme-ng.
> > Running on VM can be versatile and fast. The run can be made parallel
> > too, by spawning multiple VMs simultaneously.
> 
> This is actually rather trivial to solve I have some pre-made things for 
> fstests and that can be adopted for blktests as well:
> 
> vng \
>      --user=root -v --name vng-tcmu-runner \
>      -a loglevel=3 \
>      --run $KDIR \
>      --cpus=8 --memory=8G \
>      --exec "~johannes/src/ci/run-fstests.sh" \
>      --qemu-opts="-device virtio-scsi,id=scsi0 -drive 
> file=/dev/sda,format=raw,if=none,id=zbc0 -device 
> scsi-block,bus=scsi0.0,drive=zbc0" \
>      --qemu-opts="-device virtio-scsi,id=scsi1 -drive 
> file=/dev/sdb,format=raw,if=none,id=zbc1 -device 
> scsi-block,bus=scsi1.0,drive=zbc1"
> 
> and run-fstests.sh is:
> 
> #!/bin/sh
> # SPDX-License-Identifier: GPL-2.0
> 
> DIR="/tmp/"
> MKFS="mkfs.btrfs -f"
> FSTESTS_DIR="/home/johannes/src/fstests"
> HOSTCONF="$FSTESTS_DIR/configs/$(hostname -s)"
> TESTDEV="$(grep TEST_DEV $HOSTCONF | cut -d '=' -f 2)"
> 
> mkdir -p $DIR/{test,scratch,results}
> $MKFS $TESTDEV
> 
> cd $FSTESTS_DIR
> ./check -x raid
> 
> I'm not sure it'll make sense to include this into blktests other than 
> maybe providing an example in the README.

I guess the example can be added in contrib/. This idea interested me, so I did
some quick scripting and created the patch attached. I did some blktests runs
with virtme-ng, and found that:

- virtme-ng allows to skip kernel installation step. Fast and useful as Haris
  pointed out.
- systemd does not look working well with virtme-ng, even when I specify the
  --systemd option. This will be a condition difference from normal
  blktests runs.

I hope that the patch will help discussion at the conference.

--h373hom54itlhfgm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-contrib-add-scripts-to-run-blktests-with-virtme-ng.patch"

From 4a310c98f674e65218fb7e33e3b176a85d897333 Mon Sep 17 00:00:00 2001
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Date: Tue, 21 Apr 2026 14:26:01 +0900
Subject: [PATCH blktests RFC] contrib: add scripts to run blktests with
 virtme-ng

It takes rather long time to run blktests repeatedly for debug target
kernels because of the time to install the test target kernel to the
test target system. To reduce the turn around time, virtme-ng [1] is
useful. Add helper scripts to run blktests using virtme-ng per
suggestion by Johaness [2].

After building a kernel in ~/linux, the command lines below will run
blktests on the built kernel. With this, kernel installation step is no
longer required.

 $ KDIR=~/linux contrib/run-vng loop/010
 virtme: waiting for virtiofsd to start
 virtme: use 'microvm' QEMU architecture
 early console in setup code
 Probing EDD (edd=off to disable)... ok
 [    0.000000][    T0] Linux version 7.0.0 (shin@shinmob) (gcc (GCC) 15.2.1 20260123 (Red Hat 15.2.1-7), GNU ld version 2.45.1-4.fc43) #22 SMP PREEMPT_DYNAMIC Mon Apr 13 15:44:07 JST 2026
 [    0.000000][    T0] Command line: virtme_hostname=vng-blktests-runner nr_open=2147483584 virtme_link_mods=/home/shin/linux/.virtme_mods/lib/modules/0.0.0 virtme_initmount0=tmp virtme_rw_overlay0=/etc virtme_rw_overlay1=/lib virtme_rw_overlay2=/home virtme_rw_overlay3=/opt virtme_rw_overlay4=/srv virtme_rw_overlay5=/usr virtme_rw_overlay6=/var virtme_rw_overlay7=/tmp virtme_console=ttyS0 console=ttyS0 earlyprintk=serial,ttyS0,115200 panic=-1 virtme.exec=`L2hvbWUvc2hpbi9CbGt0ZXN0cy9ibGt0ZXN0cy9jb250cmliL3J1bi1ibGt0ZXN0cy1xdWljayBsb29wLzAwMQ==` virtme.ssh virtme_ssh_channel=vsock virtme_ssh_cache=/home/shin/.cache/virtme-ng/.ssh virtme_chdir=home/shin/Blktests/blktests/contrib debug loglevel=3 init=/usr/lib/python3.14/site-packages/virtme/guest/bin/virtme-ng-init
 [    0.000000][    T0] x86/split lock detection: #DB: warning on user-space bus_locks
 [    0.000000][    T0] BIOS-provided physical RAM map:
 [    0.000000][    T0] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff]  System RAM
 [    0.000000][    T0] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff]  device reserved
 [    0.000000][    T0] BIOS-e820: [gap 0x00000000000a0000-0x00000000000effff]
 [    0.000000][    T0] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff]  device reserved
 [    0.000000][    T0] BIOS-e820: [mem 0x0000000000100000-0x00000000bfffefff]  System RAM
 [    0.000000][    T0] BIOS-e820: [mem 0x00000000bffff000-0x00000000bfffffff]  device reserved
 [    0.000000][    T0] BIOS-e820: [gap 0x00000000c0000000-0x00000000feffbfff]
 [    0.000000][    T0] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff]  device reserved
 [    0.000000][    T0] BIOS-e820: [gap 0x00000000ff000000-0x00000000fffbffff]
 [    0.000000][    T0] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff]  device reserved
 [    0.000000][    T0] BIOS-e820: [mem 0x0000000100000000-0x000000013fffffff]  System RAM
 [    0.000000][    T0] printk: legacy bootconsole [earlyser0] enabled
 Poking KASLR using RDRAND RDTSC...
 Clean up /tmp/results ...
 loop/001 (scan loop device partitions)
 loop/001 (scan loop device partitions)                       [passed]
     runtime    ...  14.610s
 Run logs:
 [   90.927921][    T1] reboot: Power down

When I ran the script on my Fedora 43 testnode for some test groups, I
observed hangs at nvme/010 and nvme/012. Also I observed a failure at
loop/010. Some fixes will be required in blktests and kernel to run the
new script in stable manner.

Of note is that the script does not support test target block device
pass-through yet.

[1] https://github.com/arighi/virtme-ng
[2] https://lore.kernel.org/linux-block/ae47ef06-3f66-4aab-b4ab-f3ae2b634f87@wdc.com/

Suggested-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 contrib/run-blktests-quick | 27 +++++++++++++++++++++++++++
 contrib/run-vng            | 18 ++++++++++++++++++
 2 files changed, 45 insertions(+)
 create mode 100755 contrib/run-blktests-quick
 create mode 100755 contrib/run-vng

diff --git a/contrib/run-blktests-quick b/contrib/run-blktests-quick
new file mode 100755
index 0000000..9324c38
--- /dev/null
+++ b/contrib/run-blktests-quick
@@ -0,0 +1,27 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-3.0+
+# Copyright (C) 2026 Western Digital Corporation or its affiliates.
+
+declare DIR LOGDIR BLKTESTS_DIR
+
+DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
+BLKTESTS_DIR="${DIR}/../"
+
+LOGDIR="/tmp/results"
+
+if [[ -e $LOGDIR ]]; then
+	echo "Clean up ${LOGDIR} ..."
+	rm -rf $LOGDIR
+fi
+mkdir -p "$LOGDIR"
+
+cd "$BLKTESTS_DIR" || exit
+
+cat > config << EOF
+QUICK_RUN=1
+TIMEOUT=10
+EOF
+
+./check -o "$LOGDIR" "$@"
+echo "Run logs: ${LOGIDR}"
+
diff --git a/contrib/run-vng b/contrib/run-vng
new file mode 100755
index 0000000..9aa4b91
--- /dev/null
+++ b/contrib/run-vng
@@ -0,0 +1,18 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-3.0+
+# Copyright (C) 2026 Western Digital Corporation or its affiliates.
+
+declare DIR
+declare -a BLKTESTS_OPTS
+DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
+
+if (($#)); then
+	BLKTESTS_OPTS=("$@")
+else
+	BLKTESTS_OPTS=(block nvme loop scsi)
+fi
+
+vng \
+ --user=root --verbose --name vng-blktests-runner --cpus=4 --memory=4G \
+ --append loglevel=3 --run "$KDIR" --ssh \
+ --rwdir=/tmp --exec "$DIR/run-blktests-quick ${BLKTESTS_OPTS[*]}"
-- 
2.53.0


--h373hom54itlhfgm--
