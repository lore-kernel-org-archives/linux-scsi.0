Received: from alln-iport-4.cisco.com (alln-iport-4.cisco.com [173.37.142.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D5A3E4C71
	for <linux-scsi@vger.kernel.org>; Mon,  4 May 2026 17:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.91
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777916746; cv=fail; b=f302tVlgWauiXaPlc/29nUC606+nrON1J7ZKt2VIPiIyoqjcgDIBJBHY4ZwGHLkK2IWMvsK1SsuTTL+XmI0u71QiQDMTtgVlmeavXu4MXd07UoEDFIYjaJr8AtqqGdosePHJ/10IO0Z3mk8bbPdgMIQhlL3Rkap3RmPtYUIMNho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777916746; c=relaxed/simple;
	bh=Dad3/wMP1V2Y325Zq08LeVqmxamr0zAziCZISnno/u8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b8bqfupU2xDb9KZ0YGDluPn2AEBXzeJUiZ6fPpfgbznT0ehcxbHNNKLhzlTI/ti5EZ7oZmBhzzyTDMrID7X/VUVF+X6W4Ted7u+dqHuO/CoaAwjWjYSyeqOxuB64bGHoirJi13mRkywN4QTRv50xMt34PjqRkw8fcUwN7cD4bFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=SmOKLICm; arc=fail smtp.client-ip=173.37.142.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="SmOKLICm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=18821; q=dns/txt;
  s=iport01; t=1777916743; x=1779126343;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AoywvkKrYl4mFMKAwi4thsgbetBOYIW2tDKCrOrWq6s=;
  b=SmOKLICm4yT7szoepuLfgcp/LYck3J48gu/zRfkGMe2DH7EzebfFMv8q
   KuFjwUszvW1FCnSt8CAKLd+PUT7PXA+n72HjA9x/9FR2sfWckpbni0wO7
   BQwnah/6NLLszv31Fvg3zeOrhmqjoXEq+KqcWVaI1QW8Axn63UU7ZgxT/
   VTY/3EK/eXYcCl3zqRHriauc8BLAuRqmk/hTg+kbnY3wa58gpAg6aLpwv
   9tIh6geUjb8DixTpB1GH9xZ/ATribtiMRpOs2sOmZBOsns61k9wPux03Y
   C9Ra5JZwohUzYyCsHcTVVt2kpqmwK6JTH4DuWzgVqv7AxaP+Lfp0pJl2B
   g==;
X-CSE-ConnectionGUID: 0kaTjHa7REqxP39+vdOfVA==
X-CSE-MsgGUID: RYEayt6CR0i/DOiSZNUDag==
X-IPAS-Result: =?us-ascii?q?A0ByBQBp2vhp/5D/Ja1agS6BK4FuKimCFhJJiCMDhSyGW?=
 =?us-ascii?q?IIhA6AZDwEBAQ0CUQQBAYUGAo0xAiY3Bg4BAgQBAQEBAwIDAQEBAQEBAQEBA?=
 =?us-ascii?q?QELAQEFAQEBAgEHBYEOE4ZchloBAQEBAgESFRM/EAIBCBgeEDElAgQBDQUIG?=
 =?us-ascii?q?oIIgyUnAwECqzMBgT0Ciip4gQEzgQHgMBQBgTiIWAGFdoR6JxuCDYEVQoJoP?=
 =?us-ascii?q?oRFhBOCLwSCDRWBDoF+fIwfUngcA1ksAVUTFwsHBYEjQwMqLy0jSwUtHYEjI?=
 =?us-ascii?q?R0XFR9YGwcFEiEqbmt0LFwaDiEkEVlCOAtJBYFyAoIeGV8jLwNOdgMLbT03F?=
 =?us-ascii?q?BsDBIE1BYpVHQ+CIQ9jIgp/gSp5kmwBgyuwHwqEHKIOF6prmQYio0kGhSUCB?=
 =?us-ascii?q?AIEBQIQAQEGgX4mgVlwFYMiUxkPji0WyxN4PQEBBwIHDQMLgWiQAASBeQEB?=
IronPort-PHdr: A9a23:Nrtz2xOQsaaTqVVgPgol6nc2WUAX0o4cdiYc7p4hzrVWfbvmotLpP
 VfU4rNmi1qaFYnY6vcRk+PNqOigQm0P55+drWoPOIJBTR4LiMga3kQgDceJBFe9LavCZC0hF
 8MEX1hgl0w=
IronPort-Data: A9a23:fG1G96/eaRZnvSuoNatQDrUD1X+TJUtcMsCJ2f8bNWPcYEJGY0x3x
 2EdUW6Da/iPNjH3LtEiOYW+80NQ78CGytZrSQdkpH1EQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4EzrauS9xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4mpyyHjEAX9gWAsbzpIs/vrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2luPoQk+MZ+Xltj7
 Owgc2FOcBykidyflefTpulE3qzPLeHxN48Z/3UlxjbDALN+HtbIQr7B4plT2zJYasJmRKmFI
 ZFGL2AyMVKZP0En1lQ/UPrSmM+rj2PjcjlRq3qepLE85C7YywkZPL3Fb4GPIY3QHJ4P9qqej
 lj30m3oHk8xDoSejhai80meoNLjlCyuDer+E5X9rJaGmma7wm0VFQ1TTlCgoNGnhUOkHdFSM
 UoZ/mwpt6dayaCwZsP2Uxv9pDuPuQQRHoIPVeY78wqKjKHT5m51G1Q5c9KIU/R/3OceTj0x3
 VjPlNTsbQGDepXPIZ5B3t94dQ+PBBU=
IronPort-HdrOrdr: A9a23:wWVhNaontPBSJdKGODrhscwaV5skLNV00zEX/kB9WHVpm5Oj5q
 OTdaUgtSMc1gxxZJh5o6H/BEDhex/hHZ4c2/h2AV7QZniWhILOFvAs0WKC+UytJ8SQzJ8m6U
 4NSdkbNDS0NykEsS+Y2nj3Lz9D+qj7zEnAv463pBkdL3AOV0gj1XYENu/xKDwOeOAyP+tDKH
 Pq3Ls+m9PPQwVxUu2LQlM+c6zoodrNmJj6YRgAKSIGxWC15w+A2frRKTTd+g0RfQ9u7N4ZnF
 TtokjU96+ju/a0xlvm0XPP75NZod3lytFSLs2BgMoYJ1zX+0eVjYJaNIGqjXQQmqWC+VwqmN
 7Dr1MLJMJo8U7ceWmzvF/ExxTg+CxG0Q6g9XaoxV/Y5eDpTjMzDMRMwahDdAHC1kYmtNZglI
 pWwmOisYZNBx+oplW+2zGIbWAuqqOHmwtkrQchtQ0YbWLYUs4JkWUrxjIQLH7HJlOj1GloKp
 g0MCiW3ocnTbrTVQGrgoAo+q3tYl0DWjGbX0MFpsuZlxJSnHx/0g8k4fZ3pAZbyHr4IKM0u9
 gt9c9T5exzZ95TYqRnCOgbR8yrTmTLXBLXKWqXZU/qDacdJhv22tXKCZgOlaiXkaYzvdMPsY
 WEVEkduX85ekroB8HL1JpX8grVSGH4WTj20MlR65Vwp7W5HdPQQGC+YUFrl9Hlr+QUA8XdVf
 r2MJVKA+X7JW+rHYpSxQXxV5RbNHFbWswIvdQwXU6Iv6vwW8fXn/2edOyWKKvmED4iVG+6Cn
 wfXCLrLMEF9UyvUm+QummmZ5osQD2JwXtdKtmvwwFI8vl+CmRliHlhtWiE
X-Talos-CUID: 9a23:ohOPQGMEfVRZ3+5DACpuyEw0E58fX2TN9CyBYFG0LmhXYejA
X-Talos-MUID: =?us-ascii?q?9a23=3AqCQZeAxQgVH7vwpWrSvRCphm6HiaqJ6fJUkcjcs?=
 =?us-ascii?q?tgZGFcgBXOgyvqgmbS4Byfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-07.cisco.com ([173.37.255.144])
  by alln-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 04 May 2026 17:45:37 +0000
Received: from alln-opgw-5.cisco.com (alln-opgw-5.cisco.com [173.37.147.253])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-07.cisco.com (Postfix) with ESMTPS id DFB8B180003D9
	for <linux-scsi@vger.kernel.org>; Mon,  4 May 2026 17:45:36 +0000 (GMT)
X-CSE-ConnectionGUID: pWXsUE99SyyIxpax6+YbMA==
X-CSE-MsgGUID: qIfjtJyoSr2o2gJ8oRctaA==
Authentication-Results: alln-opgw-5.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.23,215,1770595200"; 
   d="scan'208";a="53120863"
Received: from mail-bn1pr07cu00300.outbound.protection.outlook.com (HELO BN1PR07CU003.outbound.protection.outlook.com) ([40.93.12.0])
  by alln-opgw-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 04 May 2026 17:45:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BfT2StVMxf7KhUJnTJapyqScTliPXqVntzrIHKPPoW6eK5oQGSwLY0CzAmsLAeDNx8VK5oPgy4TGpzSR2CF/FHAW6BYKA76dDOSDa4B+cYnzvxX0zNwMuut1AZFRo8QimnpCp29RZH/83jtkYkCa/7vNKUKQZ2aPPCYpxCVwrxEdIFyWr85Uf63N6WQBiarFl/dkTDvS0ujYSbVSRDYNwcHfQ7YJ70fEpTBuc1usrjfDpq6sbq8KwCNc8mO+JzZIaoj8d6BXJsrZvuNX1UZj32Ans4xXSj284rRYHZ68+bN0KVMrfFMLXU5v9qc6Dzu1B9YqOaA/xyfIeN/yr7XDJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AoywvkKrYl4mFMKAwi4thsgbetBOYIW2tDKCrOrWq6s=;
 b=UMCRb784vPdLKe6vlB4ALs6rN4nM2ulpDpQlqmFi05QsZI/EkXwUAMDEcRp3F+IhbqfFIgJ+GRIVJANQuM0EodKWfQM4m32j5Plm7GDe0L2fFaQINVsbU5YZSJY77WIBqgtF/iF+0TYgbr4jH5NVTl1q4OfYbNDj1lJw7LjlGgZlkGLBCcTGDfgd2qxwl4wYkO7z7UU9fJO+LC8sqKhO7hqNMX+9LyO1DhdJFrX44kcxi0bU5km1TaaDubCJ/Iq2lsFxXoArgmqCnLUpe9De7CiUCn2qnkbcViYQWhgxHHn/w7rRV1FP0tEX8m/WWe8AuSA6W+uwE1r5BfZXjuTqIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by PH8PR11MB7095.namprd11.prod.outlook.com (2603:10b6:510:215::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 17:45:33 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db%3]) with mapi id 15.20.9870.023; Mon, 4 May 2026
 17:45:33 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Marco Elver
	<elver@google.com>, "Satish Kharat (satishkh)" <satishkh@cisco.com>,
	"Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Arulprabhu Ponnusamy (arulponn)"
	<arulponn@cisco.com>, "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, "Arun
 Easi (aeasi)" <aeasi@cisco.com>
Subject: RE: [PATCH v2 26/56] scsi: fnic: Enable lock context analysis
Thread-Topic: [PATCH v2 26/56] scsi: fnic: Enable lock context analysis
Thread-Index: AQHc2M6BkZ/K3jZPzUalfn62FnJiL7X+J3wg
Date: Mon, 4 May 2026 17:45:33 +0000
Message-ID:
 <SJ0PR11MB5896FDA167869A62035A34ACC3312@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20260430182130.1978347-1-bvanassche@acm.org>
 <20260430182130.1978347-27-bvanassche@acm.org>
In-Reply-To: <20260430182130.1978347-27-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|PH8PR11MB7095:EE_
x-ms-office365-filtering-correlation-id: 06453578-5e08-43c8-bd2d-08deaa04f101
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|22082099003|56012099003|38070700021;
x-microsoft-antispam-message-info:
 ZOETQYcTGrFy6sBlyIrprlCug8O/3TA2d5sfk4ieF3lp/9LcD114f4wd/JpfSxWYdD9wJUIAHY2/nhfcr+gmJSfFOl1cc1zdg5nhNT1XQQNMeMMpTamWtjU6aKFgihklOiyYpbgmfQjcGnEcfG2KAfsJoLvnN0+gLonjUmhq5O1xGm8MCv8MxPOuxbas48fc3asDTqKWFU7kPBcJSQpr6/68PDtu4h6mhoomo/AfFB3gNZS/MEpFDR1Z/9MCjiJOTv/LwzFJ3yXuuCSpHt7uNuBDdOeJKmgc5Ka1SXsTIlOKKYw5PrD0ckcV7p/POJ/AuCPnAleTynnZW5nMe8P22tAAVIaW+BQrl1htoueCBKUzbT8tAsO/OAJVVGL8ho5r+8QyylCacGigI+9+1It7mnrFm3DYB9yqmebpK75J3T3baYrFFVpMvWa4f+dQZ1qIuCJk3iPOdZZH4p878+wSv63rQDAqxnv7Otr2XRo1meOBs/c44s93O5zOIqwCods/o6vrD6JYbLOMq3BsP1yFuSeaK6xn6TSsRACdGLg6COcfF9T/W2KGpFQPs8Kw26MVIq91Hj0B27QjXcIpsaKdtHDjHmajShFXQvkc7rIG5BHsSko2V1/ZBcitK+HVJmrqiLXaCAbc4TuC0+a122oaGYFxpSBzNbpscS/bjXW8inVR3OK2rNoYsqitvZtvNVa19mh3QqS6EMUmCDqL/AyCuNxeQvJyja9SwKeKHDe4Wyi3NLahxLhbu19q7/S0hOT0
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?YGAwsVoQwK0C1q4f5r14KKjHNuNr3nOprKUOTQ19wliuVgROkx2C2LTMgBQM?=
 =?us-ascii?Q?n5/nb7xZfEX8IhMQ2qq3jH3YM36SvtHJdeQMAc3+XK97GKk91j+xdY9J1ucX?=
 =?us-ascii?Q?FGrr6iUBMevo20I8mCBhjTJcd09TR3CLfr6PVpssQkUF5nkG03EJPZxkad+X?=
 =?us-ascii?Q?U24H9K0FYQsBMMAuhPyPUiq3bxbX2YJV86w0zQ8QekhaqRCZXMm/hrIdyf4W?=
 =?us-ascii?Q?9Z7I2BfyRY5/JkgOQozEAv5Z2VrYY4DIrbmXJbrSFLSS0aWS0RAfIDrl5/bm?=
 =?us-ascii?Q?MJMHvU2pxdTiNRsl0oHJQjPCuU+kRbqWkgfG4irJHb4WKyi95WBW0bU/a5iB?=
 =?us-ascii?Q?hcaX5uNgLm9NTt45Agie+hgPzHlV+Ybb+65e/ctZ/ynU9womMOwGnCkC2rQw?=
 =?us-ascii?Q?zW8REacLg1qVK/mSq1mMdTmgjK7hZ54v8fQep2FLVMVX+0s+sShm5xaAgcTr?=
 =?us-ascii?Q?gCnZnOSqjosbu1I/6Mm+ap6aJcAKfDWTS0sCHvVFM8dMC10sI0L9HRPF/rE9?=
 =?us-ascii?Q?NObzXDT8QN5ycAIzCa7o94iqgmUSMAJb6FdhlWyUdnUc360ZvyhdzYTw33f+?=
 =?us-ascii?Q?hCXYrN9hEETFNLTOhTb4auTTHDyXpmwfJmAfLmwgXNEkVakxQ2irGj2MmoC2?=
 =?us-ascii?Q?cWF3o956+itc+au8XTgZRu5XdYRxk5nnFMNj7FQTVDNNMpKtvHJEbErwUwEY?=
 =?us-ascii?Q?6qvmSmIUHn3rpD68P2hM8ETFUMRPzc8Y9h6SciVzVfrQNTeuf+2Z8KlL/VaW?=
 =?us-ascii?Q?e+JTfl9NLVVM1feDGfv57NTOW1lnHUnLnYxwlis1RPMJMq13CCtfUHvx0H0O?=
 =?us-ascii?Q?YZUsGN1PMXYN9/34CWp978mVPMO0NUxJP3M8fOurK6/HRMj75jNTcMliWRZ9?=
 =?us-ascii?Q?Rx3Wj/toKsikCQrTYVf9/Sqym7nLc8kh3lf+zQXHM7aGldrAadQqVOe1CRRT?=
 =?us-ascii?Q?iUGKv1YQPzzEKrnTHsHEhEbWr26UjSXu7+BNRNDGGOO87iqe0Wi6515f6ewT?=
 =?us-ascii?Q?wX5B8oMzlcPno0z8f/my/JS9rxsqJMVsutYmhCyvy5Irhz3dV2s0hN5j8Tnb?=
 =?us-ascii?Q?y5i2xIxkv58ikFN4iCLfJ6/FD3XjhPiymVmxAhNfBNIS+YG2Z3D6EAcdEQAc?=
 =?us-ascii?Q?wF3EyKxJGi0Uhj2bSm4xPdSTULJ2Kx1/dpnsJtFZs7utlbvyXdQkT7TUxrUL?=
 =?us-ascii?Q?uGz8Z3XLVHjVPuyj6xuhl4sCrtz+5fjCblyNypv1sEnycMo9ON0Rzeaped4A?=
 =?us-ascii?Q?rBu0bIETKZNuFzFpLjwyAl456GdAv0Ug7KNPnBnc4tiJf02E4ITO5iBGUvYM?=
 =?us-ascii?Q?aWTg5EgVO/2mua/Ti3ncLW+4W9XqUfH7iKHZdK/NKCiZn08VjViPq3LgvL+K?=
 =?us-ascii?Q?UfZTfJmmEP8nUJ1cSsFuTHKdXgTGnvcpWvtxRy37LtlFkH05FtjB+fvuds/G?=
 =?us-ascii?Q?kXq2L0hiHdUQFeHJfO/Emvp5trBAd7wt9es0yP2PUrTQcKBYIq88Y8o7AP6h?=
 =?us-ascii?Q?P82O3MpgxFoaDsydkz8IeOGZq8U8jrTK16iCDgBwP+eBnlHsd+wGCSvg5KNY?=
 =?us-ascii?Q?sk/OPI669seP9OWsFWF3P+uRvuU+esFd8KnrTbDuHmHq6M+Jb+VrIiuY5aEw?=
 =?us-ascii?Q?xmnmfk27ENKdNL4VX3zhDFLFy8iFL8+sv15cHYISPJxmrJA0z+dGtuL8oKlS?=
 =?us-ascii?Q?UaK8DEShOSVxLCcHgSgmIwPPROlZCLF2LBVOOpGGH2WD1UNn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	LXR5lEYwfTVJjnA1eFdY5s3Za5LZvpe+UgfY6fDCUGb9lmuSJ2q6YFeXq5Mn4ELcZbwTYl9ES1V06auTnnqSFsnie9u29CCHMkVV85byN4aafUvsojRrMQ+382lWqCarof3/X7puWUfIKzs4UMyXrgB2wGglmXuLVdgs6/xV3hA3zFEbTfITdXdbrPJOAywddyiazwjOK8hRZLMFZQWw7JC/QvZbmdZ4kFPSq4f9gpViptcY/1Wv1Enp6J9vDVUF0j0xLFRLhIASu2tCDQWsdIMk0LPo7RtgGBHbqu1PTdZRuTUECm+EcOBN5NQtY7JjTWpSR4ir639OMivNqeqh9A==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06453578-5e08-43c8-bd2d-08deaa04f101
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2026 17:45:33.3156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mPmHLfO5ukOc2lNj+QaS7cAn89yvJ7wLG477/uAoHvRyImM4dkiTixVlUzNImG3V/5tT3ZvqU1aCxopYzvDAXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7095
X-Outbound-Client-TLS: ANONYMOUS;alln-opgw-5.cisco.com [173.37.147.253];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 173.37.147.253, alln-opgw-5.cisco.com
X-Outbound-Node: rcdn-l-core-07.cisco.com

On Thursday, April 30, 2026 11:20 AM, Bart Van Assche <bvanassche@acm.org> =
wrote:
>
> Document locking requirements with __must_hold(). Suppress complaints
> about conditional locking in fnic_device_reset() with __acquire() and
> __release().
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/fnic/Makefile    |  3 ++
>  drivers/scsi/fnic/fdls_disc.c | 52 +++++++++++++++++++++++++++++++++--
>  drivers/scsi/fnic/fip.c       |  2 ++
>  drivers/scsi/fnic/fnic_fcs.c  |  6 ++++
>  drivers/scsi/fnic/fnic_scsi.c |  4 +++
>  5 files changed, 65 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/fnic/Makefile b/drivers/scsi/fnic/Makefile
> index c025e875009e..4cd6c7972d05 100644
> --- a/drivers/scsi/fnic/Makefile
> +++ b/drivers/scsi/fnic/Makefile
> @@ -1,4 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
> +
> +CONTEXT_ANALYSIS :=3D y
> +
>  obj-$(CONFIG_FCOE_FNIC) +=3D fnic.o
>
>  fnic-y       :=3D \
> diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.=
c
> index 554dea767885..0ac12edb7df1 100644
> --- a/drivers/scsi/fnic/fdls_disc.c
> +++ b/drivers/scsi/fnic/fdls_disc.c
> @@ -391,6 +391,7 @@ static void fdls_reset_oxid_pool(struct fnic_iport_s =
*iport)
>  }
>
>  void fnic_del_fabric_timer_sync(struct fnic *fnic)
> +     __must_hold(&fnic->fnic_lock)
>  {
>       fnic->iport.fabric.del_timer_inprogress =3D 1;
>       spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> @@ -399,8 +400,8 @@ void fnic_del_fabric_timer_sync(struct fnic *fnic)
>       fnic->iport.fabric.del_timer_inprogress =3D 0;
>  }
>
> -void fnic_del_tport_timer_sync(struct fnic *fnic,
> -                                             struct fnic_tport_s *tport)
> +void fnic_del_tport_timer_sync(struct fnic *fnic, struct fnic_tport_s *t=
port)
> +     __must_hold(&fnic->fnic_lock)
>  {
>       tport->del_timer_inprogress =3D 1;
>       spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> @@ -411,6 +412,7 @@ void fnic_del_tport_timer_sync(struct fnic *fnic,
>
>  static void
>  fdls_start_fabric_timer(struct fnic_iport_s *iport, int timeout)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       u64 fabric_tov;
>       struct fnic *fnic =3D iport->fnic;
> @@ -436,6 +438,7 @@ fdls_start_fabric_timer(struct fnic_iport_s *iport, i=
nt timeout)
>  static void
>  fdls_start_tport_timer(struct fnic_iport_s *iport,
>                                          struct fnic_tport_s *tport, int =
timeout)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       u64 fabric_tov;
>       struct fnic *fnic =3D iport->fnic;
> @@ -631,6 +634,7 @@ fdls_send_logo_resp(struct fnic_iport_s *iport,
>  void
>  fdls_send_tport_abts(struct fnic_iport_s *iport,
>                                        struct fnic_tport_s *tport)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       uint8_t *frame;
>       uint8_t s_id[3];
> @@ -674,7 +678,9 @@ fdls_send_tport_abts(struct fnic_iport_s *iport,
>       /* Even if fnic_send_fcoe_frame() fails we want to retry after time=
out */
>       fdls_start_tport_timer(iport, tport, 2 * iport->e_d_tov);
>  }
> +
>  static void fdls_send_fabric_abts(struct fnic_iport_s *iport)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       uint8_t *frame;
>       uint8_t s_id[3];
> @@ -846,6 +852,7 @@ static void fdls_send_fdmi_abts(struct fnic_iport_s *=
iport)
>  }
>
>  static void fdls_send_fabric_flogi(struct fnic_iport_s *iport)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       uint8_t *frame;
>       struct fc_std_flogi *pflogi;
> @@ -906,6 +913,7 @@ static void fdls_send_fabric_flogi(struct fnic_iport_=
s *iport)
>  }
>
>  static void fdls_send_fabric_plogi(struct fnic_iport_s *iport)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       uint8_t *frame;
>       struct fc_std_flogi *pplogi;
> @@ -998,6 +1006,7 @@ static void fdls_send_fdmi_plogi(struct fnic_iport_s=
 *iport)
>  }
>
>  static void fdls_send_rpn_id(struct fnic_iport_s *iport)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       uint8_t *frame;
>       struct fc_std_rpn_id *prpn_id;
> @@ -1057,6 +1066,7 @@ static void fdls_send_rpn_id(struct fnic_iport_s *i=
port)
>  }
>
>  static void fdls_send_scr(struct fnic_iport_s *iport)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       uint8_t *frame;
>       struct fc_std_scr *pscr;
> @@ -1112,6 +1122,7 @@ static void fdls_send_scr(struct fnic_iport_s *ipor=
t)
>  }
>
>  static void fdls_send_gpn_ft(struct fnic_iport_s *iport, int fdls_state)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       uint8_t *frame;
>       struct fc_std_gpn_ft *pgpn_ft;
> @@ -1171,6 +1182,7 @@ static void fdls_send_gpn_ft(struct fnic_iport_s *i=
port, int fdls_state)
>
>  static void
>  fdls_send_tgt_adisc(struct fnic_iport_s *iport, struct fnic_tport_s *tpo=
rt)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       uint8_t *frame;
>       struct fc_std_els_adisc *padisc;
> @@ -1236,6 +1248,7 @@ fdls_send_tgt_adisc(struct fnic_iport_s *iport, str=
uct fnic_tport_s *tport)
>  }
>
>  bool fdls_delete_tport(struct fnic_iport_s *iport, struct fnic_tport_s *=
tport)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       struct fnic_tport_event_s *tport_del_evt;
>       struct fnic *fnic =3D iport->fnic;
> @@ -1293,6 +1306,7 @@ bool fdls_delete_tport(struct fnic_iport_s *iport, =
struct fnic_tport_s *tport)
>
>  static void
>  fdls_send_tgt_plogi(struct fnic_iport_s *iport, struct fnic_tport_s *tpo=
rt)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       uint8_t *frame;
>       struct fc_std_flogi *pplogi;
> @@ -1361,6 +1375,7 @@ fnic_fc_plogi_rsp_rdf(struct fnic_iport_s *iport,
>  }
>
>  static void fdls_send_register_fc4_types(struct fnic_iport_s *iport)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       uint8_t *frame;
>       struct fc_std_rft_id *prft_id;
> @@ -1421,6 +1436,7 @@ static void fdls_send_register_fc4_types(struct fni=
c_iport_s *iport)
>  }
>
>  static void fdls_send_register_fc4_features(struct fnic_iport_s *iport)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       uint8_t *frame;
>       struct fc_std_rff_id *prff_id;
> @@ -1480,6 +1496,7 @@ static void fdls_send_register_fc4_features(struct =
fnic_iport_s *iport)
>
>  static void
>  fdls_send_tgt_prli(struct fnic_iport_s *iport, struct fnic_tport_s *tpor=
t)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       uint8_t *frame;
>       struct fc_std_els_prli *pprli;
> @@ -1553,6 +1570,7 @@ fdls_send_tgt_prli(struct fnic_iport_s *iport, stru=
ct fnic_tport_s *tport)
>   * Currently this assumes to be called with fnic lock held.
>   */
>  void fdls_send_fabric_logo(struct fnic_iport_s *iport)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       uint8_t *frame;
>       struct fc_std_logo *plogo;
> @@ -1652,6 +1670,7 @@ void fdls_tgt_logout(struct fnic_iport_s *iport, st=
ruct fnic_tport_s *tport)
>  }
>
>  static void fdls_tgt_discovery_start(struct fnic_iport_s *iport)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       struct fnic_tport_s *tport, *next;
>       u32 old_link_down_cnt =3D iport->fnic->link_down_cnt;
> @@ -1702,6 +1721,7 @@ static void fdls_tgt_discovery_start(struct fnic_ip=
ort_s *iport)
>   * pointing to it will be freed later
>   */
>  static void fdls_target_restart_nexus(struct fnic_tport_s *tport)
> +     __must_hold(&((struct fnic_iport_s *)tport->iport)->fnic->fnic_lock=
)
>  {
>       struct fnic_iport_s *iport =3D tport->iport;
>       struct fnic_tport_s *new_tport =3D NULL;
> @@ -2482,6 +2502,7 @@ static void fdls_tport_timer_callback(struct timer_=
list *t)
>  }
>
>  static void fnic_fdls_start_flogi(struct fnic_iport_s *iport)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       iport->fabric.retry_counter =3D 0;
>       fdls_send_fabric_flogi(iport);
> @@ -2490,6 +2511,7 @@ static void fnic_fdls_start_flogi(struct fnic_iport=
_s *iport)
>  }
>
>  static void fnic_fdls_start_plogi(struct fnic_iport_s *iport)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       iport->fabric.retry_counter =3D 0;
>       fdls_send_fabric_plogi(iport);
> @@ -2508,6 +2530,7 @@ static void fnic_fdls_start_plogi(struct fnic_iport=
_s *iport)
>  static void
>  fdls_process_tgt_adisc_rsp(struct fnic_iport_s *iport,
>                          struct fc_frame_header *fchdr)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       uint32_t tgt_fcid;
>       struct fnic_tport_s *tport;
> @@ -2598,6 +2621,7 @@ fdls_process_tgt_adisc_rsp(struct fnic_iport_s *ipo=
rt,
>  static void
>  fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
>                          struct fc_frame_header *fchdr)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       uint32_t tgt_fcid;
>       struct fnic_tport_s *tport;
> @@ -2632,6 +2656,8 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *ipo=
rt,
>       if (tport->state !=3D FDLS_TGT_STATE_PLOGI) {
>               FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
>                            "PLOGI rsp recvd in wrong state. Drop the fram=
e and restart nexus");
> +             /* Tell the compiler that tport->iport =3D=3D iport. */
> +             __assume_ctx_lock(&((struct fnic_iport_s *)tport->iport)->f=
nic->fnic_lock);
>               fdls_target_restart_nexus(tport);
>               return;
>       }
> @@ -2719,9 +2745,11 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *ip=
ort,
>       fdls_set_tport_state(tport, FDLS_TGT_STATE_PRLI);
>       fdls_send_tgt_prli(iport, tport);
>  }
> +
>  static void
>  fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
>                         struct fc_frame_header *fchdr)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       uint32_t tgt_fcid;
>       struct fnic_tport_s *tport;
> @@ -2758,6 +2786,8 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *ipor=
t,
>       if (tport->state !=3D FDLS_TGT_STATE_PRLI) {
>               FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
>                            "PRLI rsp recvd in wrong state. Drop frame. Re=
starting nexus");
> +             /* Tell the compiler that tport->iport =3D=3D iport. */
> +             __assume_ctx_lock(&((struct fnic_iport_s *)tport->iport)->f=
nic->fnic_lock);
>               fdls_target_restart_nexus(tport);
>               return;
>       }
> @@ -2872,6 +2902,7 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *ipor=
t,
>  static void
>  fdls_process_rff_id_rsp(struct fnic_iport_s *iport,
>                       struct fc_frame_header *fchdr)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       struct fnic *fnic =3D iport->fnic;
>       struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
> @@ -2945,6 +2976,7 @@ fdls_process_rff_id_rsp(struct fnic_iport_s *iport,
>  static void
>  fdls_process_rft_id_rsp(struct fnic_iport_s *iport,
>                       struct fc_frame_header *fchdr)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
>       struct fc_std_rft_id *rft_rsp =3D (struct fc_std_rft_id *) fchdr;
> @@ -3020,6 +3052,7 @@ fdls_process_rft_id_rsp(struct fnic_iport_s *iport,
>  static void
>  fdls_process_rpn_id_rsp(struct fnic_iport_s *iport,
>                       struct fc_frame_header *fchdr)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
>       struct fc_std_rpn_id *rpn_rsp =3D (struct fc_std_rpn_id *) fchdr;
> @@ -3090,6 +3123,7 @@ fdls_process_rpn_id_rsp(struct fnic_iport_s *iport,
>  static void
>  fdls_process_scr_rsp(struct fnic_iport_s *iport,
>                    struct fc_frame_header *fchdr)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
>       struct fc_std_scr *scr_rsp =3D (struct fc_std_scr *) fchdr;
> @@ -3162,6 +3196,7 @@ fdls_process_scr_rsp(struct fnic_iport_s *iport,
>  static void
>  fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *iport,
>                            struct fc_frame_header *fchdr, int len)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       struct fc_gpn_ft_rsp_iu *gpn_ft_tgt;
>       struct fnic_tport_s *tport, *next;
> @@ -3260,6 +3295,7 @@ fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *i=
port,
>  static void
>  fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport,
>                       struct fc_frame_header *fchdr, int len)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
>       struct fc_std_gpn_ft *gpn_ft_rsp =3D (struct fc_std_gpn_ft *) fchdr=
;
> @@ -3396,6 +3432,7 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport,
>  static void
>  fdls_process_fabric_logo_rsp(struct fnic_iport_s *iport,
>                            struct fc_frame_header *fchdr)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       struct fc_std_flogi *flogo_rsp =3D (struct fc_std_flogi *) fchdr;
>       struct fnic_fdls_fabric_s *fdls =3D &iport->fabric;
> @@ -3449,6 +3486,7 @@ fdls_process_fabric_logo_rsp(struct fnic_iport_s *i=
port,
>  static void
>  fdls_process_flogi_rsp(struct fnic_iport_s *iport,
>                      struct fc_frame_header *fchdr, void *rx_frame)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       struct fnic_fdls_fabric_s *fabric =3D &iport->fabric;
>       struct fc_std_flogi *flogi_rsp =3D (struct fc_std_flogi *) fchdr;
> @@ -3586,6 +3624,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport,
>  static void
>  fdls_process_fabric_plogi_rsp(struct fnic_iport_s *iport,
>                             struct fc_frame_header *fchdr)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       struct fc_std_flogi *plogi_rsp =3D (struct fc_std_flogi *) fchdr;
>       struct fc_std_els_rjt_rsp *els_rjt =3D (struct fc_std_els_rjt_rsp *=
) fchdr;
> @@ -3847,6 +3886,7 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_=
iport_s *iport,
>  static void
>  fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
>                            struct fc_frame_header *fchdr)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       uint32_t s_id;
>       struct fc_std_abts_ba_acc *ba_acc =3D (struct fc_std_abts_ba_acc *)=
fchdr;
> @@ -4204,6 +4244,7 @@ fdls_process_els_req(struct fnic_iport_s *iport, st=
ruct fc_frame_header *fchdr,
>  static void
>  fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
>                         struct fc_frame_header *fchdr)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       uint32_t s_id;
>       struct fnic_tport_s *tport;
> @@ -4393,6 +4434,7 @@ fdls_process_plogi_req(struct fnic_iport_s *iport,
>
>  static void
>  fdls_process_logo_req(struct fnic_iport_s *iport, struct fc_frame_header=
 *fchdr)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       struct fc_std_logo *logo =3D (struct fc_std_logo *)fchdr;
>       uint32_t nport_id;
> @@ -4433,6 +4475,8 @@ fdls_process_logo_req(struct fnic_iport_s *iport, s=
truct fc_frame_header *fchdr)
>               FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
>                                        "tport fcid 0x%x: Canceling disc t=
imer\n",
>                                        tport->fcid);
> +             /* Tell the compiler that tport->iport =3D=3D iport. */
> +             __assume_ctx_lock(&((struct fnic_iport_s *)tport->iport)->f=
nic->fnic_lock);
>               fnic_del_tport_timer_sync(fnic, tport);
>               tport->timer_pending =3D 0;
>       }
> @@ -4470,6 +4514,7 @@ fdls_process_logo_req(struct fnic_iport_s *iport, s=
truct fc_frame_header *fchdr)
>
>  static void
>  fdls_process_rscn(struct fnic_iport_s *iport, struct fc_frame_header *fc=
hdr)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       struct fc_std_rscn *rscn;
>       struct fc_els_rscn_page *rscn_port =3D NULL;
> @@ -4603,6 +4648,7 @@ fdls_process_rscn(struct fnic_iport_s *iport, struc=
t fc_frame_header *fchdr)
>  }
>
>  void fnic_fdls_disc_start(struct fnic_iport_s *iport)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       struct fnic *fnic =3D iport->fnic;
>
> @@ -4943,6 +4989,7 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_i=
port_s *iport,
>
>  void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
>                                                 int len, int fchdr_offset=
)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       struct fc_frame_header *fchdr;
>       uint32_t s_id =3D 0;
> @@ -5061,6 +5108,7 @@ void fnic_fdls_disc_init(struct fnic_iport_s *iport=
)
>  }
>
>  void fnic_fdls_link_down(struct fnic_iport_s *iport)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       struct fnic_tport_s *tport, *next;
>       struct fnic *fnic =3D iport->fnic;
> diff --git a/drivers/scsi/fnic/fip.c b/drivers/scsi/fnic/fip.c
> index 132f00512ee1..da8a8e9ffea4 100644
> --- a/drivers/scsi/fnic/fip.c
> +++ b/drivers/scsi/fnic/fip.c
> @@ -610,6 +610,7 @@ void fnic_common_fip_cleanup(struct fnic *fnic)
>   * and clean up and restart the vlan discovery.
>   */
>  void fnic_fcoe_process_cvl(struct fnic *fnic, struct fip_header *fiph)
> +     __must_hold(&fnic->fnic_lock)
>  {
>       struct fnic_iport_s *iport =3D &fnic->iport;
>       struct fip_cvl *cvl_msg =3D (struct fip_cvl *)fiph;
> @@ -687,6 +688,7 @@ void fnic_fcoe_process_cvl(struct fnic *fnic, struct =
fip_header *fiph)
>   * @frame: Received ethernet frame
>   */
>  int fdls_fip_recv_frame(struct fnic *fnic, void *frame)
> +     __must_hold(&fnic->fnic_lock)
>  {
>       struct ethhdr *eth =3D (struct ethhdr *)frame;
>       struct fip_header *fiph;
> diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
> index 063eb864a5cd..99f9fe13dfe4 100644
> --- a/drivers/scsi/fnic/fnic_fcs.c
> +++ b/drivers/scsi/fnic/fnic_fcs.c
> @@ -925,6 +925,7 @@ void fnic_free_wq_buf(struct vnic_wq *wq, struct vnic=
_wq_buf *buf)
>  void
>  fnic_fdls_add_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tpo=
rt,
>                                       unsigned long flags)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       struct fnic *fnic =3D iport->fnic;
>       struct fc_rport *rport;
> @@ -964,6 +965,7 @@ fnic_fdls_add_tport(struct fnic_iport_s *iport, struc=
t fnic_tport_s *tport,
>  void
>  fnic_fdls_remove_tport(struct fnic_iport_s *iport,
>                                          struct fnic_tport_s *tport, unsi=
gned long flags)
> +     __must_hold(&iport->fnic->fnic_lock)
>  {
>       struct fnic *fnic =3D iport->fnic;
>       struct rport_dd_data_s *rdd_data;
> @@ -1013,6 +1015,8 @@ void fnic_delete_fcp_tports(struct fnic *fnic)
>       unsigned long flags;
>
>       spin_lock_irqsave(&fnic->fnic_lock, flags);
> +     /* Tell the compiler that fnic->iport.fnic =3D=3D fnic. */
> +     __assume_ctx_lock(&fnic->iport.fnic->fnic_lock);
>       list_for_each_entry_safe(tport, next, &fnic->iport.tport_list, link=
s) {
>               FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
>                                        "removing fcp rport fcid: 0x%x", t=
port->fcid);
> @@ -1037,6 +1041,8 @@ void fnic_tport_event_handler(struct work_struct *w=
ork)
>       struct fnic_tport_s *tport;
>
>       spin_lock_irqsave(&fnic->fnic_lock, flags);
> +     /* Tell the compiler that fnic->iport.fnic =3D=3D fnic. */
> +     __assume_ctx_lock(&fnic->iport.fnic->fnic_lock);
>       list_for_each_entry_safe(cur_evt, next, &fnic->tport_event_list, li=
nks) {
>               tport =3D cur_evt->arg1;
>               switch (cur_evt->event) {
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.=
c
> index 6ee3c559e129..a757b20756ad 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -2617,6 +2617,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>                * allocated by mid layer.
>                */
>               mutex_lock(&fnic->sgreset_mutex);
> +             /* Fake __release() to keep the lock context analyzer happy=
. */
> +             __release(&fnic->sgreset_mutex);
>               mqtag =3D fnic->fnic_max_tag_id;
>               new_sc =3D 1;
>       }  else {
> @@ -2803,6 +2805,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>
>       if (new_sc) {
>               fnic->sgreset_sc =3D NULL;
> +             /* Fake __acquire() to keep the lock context analyzer happy=
. */
> +             __acquire(&fnic->sgreset_mutex);
>               mutex_unlock(&fnic->sgreset_mutex);
>       }
>

Acked-by: Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan
