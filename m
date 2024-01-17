Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CACBE49
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jan 2024 07:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.148.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705478354; cv=fail; b=TPY2o9LhE50FjyjwJzYCpP3PDXRXXfz5rROzPHUfQe9C906xJSImY0o4fkPBPmBpX6ZH056NyQTnF1XMCHdOSwmWVhrYP1gdOdFHES4FnsArHxtyMccAIZWb1TWAWCXtHGRznT2GkD4dKIXfvqNsOrly9PLeHPP6Q/F9VCBKOM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705478354; c=relaxed/simple;
	bh=H2yTpwa8oaxKEfuEMf2uo/1riA8IhXppC8JPiYrTz9g=;
	h=Received:Received:Received:Received:ARC-Message-Signature:
	 ARC-Authentication-Results:DKIM-Signature:Received:Received:From:
	 To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
	 In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
	 X-MS-TNEF-Correlator:x-dg-rorf:x-dg-ref:x-dg-refone:x-dg-reftwo:
	 x-dg-refthree:x-dg-reffour:x-dg-reffive:x-dg-refsix:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version; b=PG6b2ayhfVdY4Y4WTr+bivRshwyyxNPdpnAt5UlepSwPT449zBiiUJ9/aRKowMbja2xqsePX/rvDSE2DZTUL0jOhQQTdOvZtSh07tvNOhTGZ5gJkJuerN55ZrGsQkufAcsD3x3wqC4HJv7ush1GQ3p5jjZx9A39/cfEDW/KIr6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b=U/2/gLiv; arc=fail smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="U/2/gLiv"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 40H7jRtL028480;
	Tue, 16 Jan 2024 23:59:08 -0800
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3vpask813m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 23:59:08 -0800 (PST)
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.24/8.17.1.24) with ESMTP id 40H7x8PV026998;
	Tue, 16 Jan 2024 23:59:08 -0800
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3vpask813k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 23:59:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndlolJwDGdB0jQMM8N/X3llsze+x3RBwgMNh+d8Z5HHntioxQ3cvvqxkQsM2l3A0CRrW4fAhcLo/RxdRBtGQrp8TTMlCzlFGNNGayAtFulaQQhljmsP8g4cSxqAqqmNFOzsQbknrDtSh1qDDtvTRTTCj+y5iVMJM1/uUHZzp/sKqcVPWG4P+AmwLuXN9pLHjS2R/PyYp/N6gAMnGrXix8BStowogGIFUD5qRhMjn9xgbQwNO7+Xrm2IodBhKlEGbf6bsyX6SV4ip/s7q6JPaDW17/Aq7AFs3yERpx4lwcoCwrw1rb6lcT1W9p/RBNpRXf4jJQlYYTJp5jZS2SfVhkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0LGEm8gNzHPEBplqqcK8pJfPp2oGefKZaMGi4xsksw=;
 b=YpgIuvejbmwAO5A70Z+uJZLG9TFmJtSufm4Ki6er9v1eBcCBoereCYEfi+pHpoUoEyKDE4PxV8LnZj5AfxGrMZxNLgIvm9+r3Mm9J5X6MMKOAQA+NnSRZBSHQaQuDcZz/s1hOTvosGVVUqoY2B928OS9OGqwssFiwiXXFuZuwIB/kYqOkMTmlcfeXrdnIcVVWhHvff0Se8Ul42M/xmbChKX/q3mJ79wpfy2yTYDN97Q4PBOlpb+goLMQcBg475tbHOlBYrZ6SpMk4hlgCgCb9gqEIurnNCR/1WAZntIUeAHeREhGEgGexF7ntyGz6Mj8YdE6eOHEoCV6AzXL/HVPXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0LGEm8gNzHPEBplqqcK8pJfPp2oGefKZaMGi4xsksw=;
 b=U/2/gLivsWLPG4A1YlgQkbXav9HNkiZNMmJbxw0OSjJFAhoi/61yF5yzI19jQWBdSlq/8OXNoGyVl79YzrFS/BujrbXvbd+yBWZXSXlSLLkpgDAE1gHiwmGcIXrK3mbuXtte1zGq2sDzXT3VRrC+X2o3l6T2uUm+iHz5puS4uy0=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by SJ0PR18MB4431.namprd18.prod.outlook.com (2603:10b6:a03:3ba::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.23; Wed, 17 Jan
 2024 07:59:03 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::739c:1689:1669:2677]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::739c:1689:1669:2677%6]) with mapi id 15.20.7202.020; Wed, 17 Jan 2024
 07:59:03 +0000
From: Nilesh Javali <njavali@marvell.com>
To: Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: RE: [PATCH v3 0/3] UIO_MEM_DMA_COHERENT for cnic/bnx2/bnx2x
Thread-Topic: [PATCH v3 0/3] UIO_MEM_DMA_COHERENT for cnic/bnx2/bnx2x
Thread-Index: AQHaQvWFlTbZvCVV1Emjm5ji1fC4brDdr6+g
Date: Wed, 17 Jan 2024 07:59:03 +0000
Message-ID: 
 <CO6PR18MB4500FE6C01C22BBED8B49C5BAF722@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20240109121458.26475-1-njavali@marvell.com>
In-Reply-To: <20240109121458.26475-1-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: 
 =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbmphdmFsaVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLTQ0M2VhOTcyLWI1MGUtMTFlZS05NGIyLWY4NGU1?=
 =?us-ascii?Q?ODllYWQzOVxhbWUtdGVzdFw0NDNlYTk3NC1iNTBlLTExZWUtOTRiMi1mODRl?=
 =?us-ascii?Q?NTg5ZWFkMzlib2R5LnR4dCIgc3o9IjQ1MjYiIHQ9IjEzMzQ5OTUxOTM5NjYy?=
 =?us-ascii?Q?NDQwOSIgaD0idUI2dllLRmFRK3JoUFEzYzNPdjVudXdrWmNzPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBQmdXQUFB?=
 =?us-ascii?Q?Wk9GSUhHMG5hQWRkYTJIQ2xxSVByMTFyWWNLV29nK3NaQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQnVEd0FBM2c4QUFEb0dBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFFQkFBQUE5UmVuTHdDQUFRQUFBQUFBQUFBQUFKNEFBQUJoQUdRQVpB?=
 =?us-ascii?Q?QnlBR1VBY3dCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY0FC?=
 =?us-ascii?Q?bEFISUFjd0J2QUc0QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBWXdCMUFITUFkQUJ2QUcwQVh3QndBR2dBYndCdUFHVUFiZ0Ix?=
 =?us-ascii?Q?QUcwQVlnQmxBSElBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVB?=
 =?us-ascii?Q?Y3dCMEFHOEFiUUJmQUhNQWN3QnVBRjhBWkFCaEFITUFhQUJmQUhZQU1BQXlB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdN?=
 =?us-ascii?Q?QWRRQnpBSFFBYndCdEFGOEFjd0J6QUc0QVh3QnJBR1VBZVFCM0FHOEFjZ0Jr?=
 =?us-ascii?Q?QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBB?=
 =?us-ascii?Q?WHdCekFITUFiZ0JmQUc0QWJ3QmtBR1VBYkFCcEFHMEFhUUIwQUdVQWNnQmZB?=
 =?us-ascii?Q?SFlBTUFBeUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFB?=
 =?us-ascii?Q?QUFJQUFBQUFBSjRBQUFCakFIVUFjd0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFj?=
 =?us-ascii?Q?d0J3QUdFQVl3QmxBRjhBZGdBd0FESUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFB?=
 =?us-ascii?Q?R1FBYkFCd0FGOEFjd0JyQUhrQWNBQmxBRjhBWXdCb0FHRUFkQUJmQUcwQVpR?=
 =?us-ascii?Q?QnpBSE1BWVFCbkFHVUFYd0IyQURBQU1nQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVpBQnNBSEFBWHdCekFH?=
 =?us-ascii?Q?d0FZUUJqQUdzQVh3QmpBR2dBWVFCMEFGOEFiUUJsQUhNQWN3QmhBR2NBWlFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJrQUd3QWNBQmZB?=
 =?us-ascii?Q?SFFBWlFCaEFHMEFjd0JmQUc4QWJnQmxBR1FBY2dCcEFIWUFaUUJmQUdZQWFR?=
 =?us-ascii?Q?QnNBR1VBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFB?=
 =?us-ascii?Q?QUFBQUFBQUFnQUFBQUFBbmdBQUFHVUFiUUJoQUdrQWJBQmZBR0VBWkFCa0FI?=
 =?us-ascii?Q?SUFaUUJ6QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFCZ0FBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
 =?us-ascii?Q?Q2VBQUFBYlFCaEFISUFkZ0JsQUd3QVh3QndBSElBYndCcUFHVUFZd0IwQUY4?=
 =?us-ascii?Q?QWJnQmhBRzBBWlFCekFGOEFZd0J2QUc0QVpnQnBBR1FBWlFCdUFIUUFhUUJo?=
 =?us-ascii?Q?QUd3QVh3QmhBR3dBYndCdUFHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnRBR0VBY2dC?=
 =?us-ascii?Q?MkFHVUFiQUJmQUhBQWNnQnZBR29BWlFCakFIUUFYd0J1QUdFQWJRQmxBSE1B?=
 =?us-ascii?Q?WHdCeUFHVUFjd0IwQUhJQWFRQmpBSFFBWlFCa0FGOEFZUUJzQUc4QWJnQmxB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUcwQVlRQnlBSFlBWlFCc0FGOEFjQUJ5?=
 =?us-ascii?Q?QUc4QWFnQmxBR01BZEFCZkFHNEFZUUJ0QUdVQWN3QmZBSElBWlFCekFIUUFj?=
 =?us-ascii?Q?Z0JwQUdNQWRBQmxBR1FBWHdCb0FHVUFlQUJqQUc4QVpBQmxBSE1BQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFHRUFjZ0J0QUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refthree: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJ?=
 =?us-ascii?Q?QUFBQUFBSjRBQUFCdEFHRUFjZ0IyQUdVQWJBQnNBRjhBWndCdkFHOEFad0Jz?=
 =?us-ascii?Q?QUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBRzBB?=
 =?us-ascii?Q?WVFCeUFIWUFaUUJzQUd3QVh3QndBSElBYndCcUFHVUFZd0IwQUY4QVl3QnZB?=
 =?us-ascii?Q?R1FBWlFCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0Fi?=
 =?us-ascii?Q?QUJmQUhBQWNnQnZBR29BWlFCakFIUUFYd0JqQUc4QVpBQmxBSE1BWHdCa0FH?=
 =?us-ascii?Q?a0FZd0IwQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJ0QUdFQWNnQjJBR1VBYkFCc0FGOEFjQUJ5QUc4QWFn?=
 =?us-ascii?Q?QmxBR01BZEFCZkFHNEFZUUJ0QUdVQWN3QmZBR01BYndCdUFHWUFhUUJrQUdV?=
 =?us-ascii?Q?QWJnQjBBR2tBWVFCc0FGOEFiUUJoQUhJQWRnQmxBR3dBYkFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?MEFZUUJ5QUhZQVpRQnNBR3dBWHdCd0FISUFid0JxQUdVQVl3QjBBRjhBYmdC?=
 =?us-ascii?Q?aEFHMEFaUUJ6QUY4QVl3QnZBRzRBWmdCcEFHUUFaUUJ1QUhRQWFRQmhBR3dB?=
 =?us-ascii?Q?WHdCdEFHRUFjZ0IyQUdVQWJBQnNBRjhBYndCeUFGOEFZUUJ5QUcwQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reffour: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VB?=
 =?us-ascii?Q?QUFBYlFCaEFISUFkZ0JsQUd3QWJBQmZBSEFBY2dCdkFHb0FaUUJqQUhRQVh3?=
 =?us-ascii?Q?QnVBR0VBYlFCbEFITUFYd0JqQUc4QWJnQm1BR2tBWkFCbEFHNEFkQUJwQUdF?=
 =?us-ascii?Q?QWJBQmZBRzBBWVFCeUFIWUFaUUJzQUd3QVh3QnZBSElBWHdCbkFHOEFid0Ju?=
 =?us-ascii?Q?QUd3QVpRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnRBR0VBY2dCMkFH?=
 =?us-ascii?Q?VUFiQUJzQUY4QWNBQnlBRzhBYWdCbEFHTUFkQUJmQUc0QVlRQnRBR1VBY3dC?=
 =?us-ascii?Q?ZkFISUFaUUJ6QUhRQWNnQnBBR01BZEFCbEFHUUFYd0J0QUdFQWNnQjJBR1VB?=
 =?us-ascii?Q?YkFCc0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFB?=
 =?us-ascii?Q?QUFBQUFBQWdBQUFBQUFuZ0FBQUcwQVlRQnlBSFlBWlFCc0FHd0FYd0J3QUhJ?=
 =?us-ascii?Q?QWJ3QnFBR1VBWXdCMEFGOEFiZ0JoQUcwQVpRQnpBRjhBY2dCbEFITUFkQUJ5?=
 =?us-ascii?Q?QUdrQVl3QjBBR1VBWkFCZkFHMEFZUUJ5QUhZQVpRQnNBR3dBWHdCdkFISUFY?=
 =?us-ascii?Q?d0JoQUhJQWJRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFD?=
 =?us-ascii?Q?ZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIUUFaUUJ5QUcwQWFRQnVBSFVB?=
 =?us-ascii?Q?Y3dBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCdEFHRUFjZ0Iy?=
 =?us-ascii?Q?QUdVQWJBQnNBRjhBZHdCdkFISUFaQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQU9nWUFBQUFBQUFBSUFBQUFBQUFBQUFnQUFBQUFB?=
 =?us-ascii?Q?QUFBQ0FBQUFBQUFBQUFhQmdBQUdRQUFBQmdB?=
x-dg-reffive: 
 =?us-ascii?Q?QUFBQUFBQUFZUUJrQUdRQWNnQmxBSE1BY3dBQUFDUUFBQUFCQUFBQVl3QjFB?=
 =?us-ascii?Q?SE1BZEFCdkFHMEFYd0J3QUdVQWNnQnpBRzhBYmdBQUFDNEFBQUFBQUFBQVl3?=
 =?us-ascii?Q?QjFBSE1BZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VBYmdCMUFHMEFZZ0JsQUhJ?=
 =?us-ascii?Q?QUFBQXdBQUFBQUFBQUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY3dCekFHNEFYd0Jr?=
 =?us-ascii?Q?QUdFQWN3Qm9BRjhBZGdBd0FESUFBQUF3QUFBQUFBQUFBR01BZFFCekFIUUFi?=
 =?us-ascii?Q?d0J0QUY4QWN3QnpBRzRBWHdCckFHVUFlUUIzQUc4QWNnQmtBSE1BQUFBK0FB?=
 =?us-ascii?Q?QUFBQUFBQUdNQWRRQnpBSFFBYndCdEFGOEFjd0J6QUc0QVh3QnVBRzhBWkFC?=
 =?us-ascii?Q?bEFHd0FhUUJ0QUdrQWRBQmxBSElBWHdCMkFEQUFNZ0FBQURJQUFBQUFBQUFB?=
 =?us-ascii?Q?WXdCMUFITUFkQUJ2QUcwQVh3QnpBSE1BYmdCZkFITUFjQUJoQUdNQVpRQmZB?=
 =?us-ascii?Q?SFlBTUFBeUFBQUFQZ0FBQUFBQUFBQmtBR3dBY0FCZkFITUFhd0I1QUhBQVpR?=
 =?us-ascii?Q?QmZBR01BYUFCaEFIUUFYd0J0QUdVQWN3QnpBR0VBWndCbEFGOEFkZ0F3QURJ?=
 =?us-ascii?Q?QUFBQTJBQUFBQUFBQUFHUUFiQUJ3QUY4QWN3QnNBR0VBWXdCckFGOEFZd0Jv?=
 =?us-ascii?Q?QUdFQWRBQmZBRzBBWlFCekFITUFZUUJuQUdVQUFBQTRBQUFBQUFBQUFHUUFi?=
 =?us-ascii?Q?QUJ3QUY4QWRBQmxBR0VBYlFCekFGOEFid0J1QUdVQVpBQnlBR2tBZGdCbEFG?=
 =?us-ascii?Q?OEFaZ0JwQUd3QVpRQUFBQ1FBQUFBR0FBQUFaUUJ0QUdFQWFRQnNBRjhBWVFC?=
 =?us-ascii?Q?a0FHUUFjZ0JsQUhNQWN3QUFBRmdBQUFBQUFBQUFiUUJoQUhJQWRnQmxBR3dB?=
 =?us-ascii?Q?WHdCd0FISUFid0JxQUdVQVl3QjBBRjhBYmdCaEFHMEFaUUJ6QUY4QVl3QnZB?=
 =?us-ascii?Q?RzRBWmdCcEFHUUFaUUJ1QUhRQWFRQmhBR3dBWHdCaEFHd0Fid0J1QUdVQUFB?=
 =?us-ascii?Q?QlVBQUFBQUFBQUFHMEFZUUJ5QUhZQVpRQnNBRjhBY0FCeUFHOEFhZ0JsQUdN?=
 =?us-ascii?Q?QWRBQmZBRzRBWVFCdEFHVUFjd0JmQUhJQVpRQnpBSFFBY2dCcEFHTUFkQUJs?=
 =?us-ascii?Q?QUdRQVh3QmhBR3dBYndCdUFHVUFBQUJhQUFBQUFBQUFBRzBBWVFCeUFIWUFa?=
 =?us-ascii?Q?UUJzQUY4QWNBQnlBRzhBYWdCbEFHTUFkQUJmQUc0QVlRQnRBR1VBY3dCZkFI?=
 =?us-ascii?Q?SUFaUUJ6QUhRQWNnQnBBR01BZEFCbEFHUUFYd0JvQUdVQWVBQmpBRzhBWkFC?=
 =?us-ascii?Q?bEFITUFBQUFnQUFBQUFBQUFBRzBBWVFCeUFIWUFaUUJzQUd3QVh3QmhBSElB?=
 =?us-ascii?Q?YlFBQUFDWUFBQUFBQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUdjQWJ3QnZB?=
 =?us-ascii?Q?R2NBYkFCbEFBQUFOQUFBQUFBQUFBQnRBR0VB?=
x-dg-refsix: 
 =?us-ascii?Q?Y2dCMkFHVUFiQUJzQUY4QWNBQnlBRzhBYWdCbEFHTUFkQUJmQUdNQWJ3QmtB?=
 =?us-ascii?Q?R1VBY3dBQUFENEFBQUFBQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhBQWNn?=
 =?us-ascii?Q?QnZBR29BWlFCakFIUUFYd0JqQUc4QVpBQmxBSE1BWHdCa0FHa0FZd0IwQUFB?=
 =?us-ascii?Q?QVhnQUFBQUFBQUFCdEFHRUFjZ0IyQUdVQWJBQnNBRjhBY0FCeUFHOEFhZ0Js?=
 =?us-ascii?Q?QUdNQWRBQmZBRzRBWVFCdEFHVUFjd0JmQUdNQWJ3QnVBR1lBYVFCa0FHVUFi?=
 =?us-ascii?Q?Z0IwQUdrQVlRQnNBRjhBYlFCaEFISUFkZ0JsQUd3QWJBQUFBR3dBQUFBQUFB?=
 =?us-ascii?Q?QUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFBWHdC?=
 =?us-ascii?Q?dUFHRUFiUUJsQUhNQVh3QmpBRzhBYmdCbUFHa0FaQUJsQUc0QWRBQnBBR0VB?=
 =?us-ascii?Q?YkFCZkFHMEFZUUJ5QUhZQVpRQnNBR3dBWHdCdkFISUFYd0JoQUhJQWJRQUFB?=
 =?us-ascii?Q?SElBQUFBQUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIQUFjZ0J2QUdvQVpR?=
 =?us-ascii?Q?QmpBSFFBWHdCdUFHRUFiUUJsQUhNQVh3QmpBRzhBYmdCbUFHa0FaQUJsQUc0?=
 =?us-ascii?Q?QWRBQnBBR0VBYkFCZkFHMEFZUUJ5QUhZQVpRQnNBR3dBWHdCdkFISUFYd0Ju?=
 =?us-ascii?Q?QUc4QWJ3Qm5BR3dBWlFBQUFGb0FBQUFBQUFBQWJRQmhBSElBZGdCbEFHd0Fi?=
 =?us-ascii?Q?QUJmQUhBQWNnQnZBR29BWlFCakFIUUFYd0J1QUdFQWJRQmxBSE1BWHdCeUFH?=
 =?us-ascii?Q?VUFjd0IwQUhJQWFRQmpBSFFBWlFCa0FGOEFiUUJoQUhJQWRnQmxBR3dBYkFB?=
 =?us-ascii?Q?QUFHZ0FBQUFBQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhBQWNnQnZBR29B?=
 =?us-ascii?Q?WlFCakFIUUFYd0J1QUdFQWJRQmxBSE1BWHdCeUFHVUFjd0IwQUhJQWFRQmpB?=
 =?us-ascii?Q?SFFBWlFCa0FGOEFiUUJoQUhJQWRnQmxBR3dBYkFCZkFHOEFjZ0JmQUdFQWNn?=
 =?us-ascii?Q?QnRBQUFBS2dBQUFBQUFBQUJ0QUdFQWNnQjJBR1VBYkFCc0FGOEFkQUJsQUhJ?=
 =?us-ascii?Q?QWJRQnBBRzRBZFFCekFBQUFJZ0FBQUFFQUFBQnRBR0VBY2dCMkFHVUFiQUJz?=
 =?us-ascii?Q?QUY4QWR3QnZBSElBWkFBQUFBPT0iLz48L21ldGE+?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR18MB4500:EE_|SJ0PR18MB4431:EE_
x-ms-office365-filtering-correlation-id: 6d101bb1-c57a-4877-cf27-08dc17322bd8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 N0Nrk1Gg1FbpW6PNyJ525c4DBevWCpm/qYdrzTxB9zNpzQQllQXg87Ekey05Smj/WRs8sBc/T9aEtpndwtZuRTY2OKvZqhU3Dp25pi8YytJNm+xv90qSwim3dDm0YtA5XrfG0/D2eY9lSn2kIyMnTHW0JNFf7gxwJul6+P6hKp69Eil2o5hTjWGm1YvLdXMkAnfhL2PUYpv6wJmAnyD4cfSWhUcG37uWKpzSaXqeibgY/zEtOA7yySPZQvieWJBOfy5YqWWzcK41BQpIJ2z7cP45ejEcx6ivi8KDSYUtoceSXXpxYJIFgZHL0iUQKmyVB1RwxQneYFVEtf7OyAReYInKjaepnTiVATraO/gHVV0upmdSzkGVqXS9wkM5EGXFz8KpXzr8LjMD3pIJLfWOXwyVux1JCmIPzoN53sovLK1q5GhQtwRCwSxuusYdrHAOc5MSHIqCJ9g0WHE7eUhf+l6ZAgIRjnXO2d4e/6BZp+hj4DGSkwtkY5R/0r659b6EBl9HNZ+D/QJfyaGSgons7MURwY68EaNw9cbzyeL5vp3Ih2OZamEBnnojrgHjcxbPZMRTgS3XGz2Bzf3+sk71selPTYRWPgJfRljsU2VG0+KRlKE59AD+QA3396BXyCnxLlvN1w9aMb3X6BwfQvDGEmWhQwoDCHj6WiLacms6wU4=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(366004)(396003)(136003)(230173577357003)(230273577357003)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(122000001)(2906002)(33656002)(41300700001)(86362001)(38100700002)(110136005)(54906003)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(6506007)(7696005)(316002)(9686003)(53546011)(71200400001)(478600001)(8936002)(8676002)(83380400001)(5660300002)(52536014)(4326008)(26005)(38070700009)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?5NvArblDjDYUVHUaIsE5rYlRuH0AvT2e9DD1Bmutno0PINbIYFC81TXsZLfK?=
 =?us-ascii?Q?C94sDOMbrzPwjvqXg3tPHqRTztF5TwqWNFznQ9aRCTWKVJolCe2X7vEXIgz4?=
 =?us-ascii?Q?vDoVVFzIFuHNb9MOgQxe31YGWpGOSy7t9jCEZF6M3Hu5jfmknwloAj24Iyy9?=
 =?us-ascii?Q?I9dSwAs/bn0ZHnJpeUSgNqQH9GFMpgviL03QMA3JCYNtghdeXJ41GbFcipVu?=
 =?us-ascii?Q?YpK7QRJNaSFz2TRl+vPzpjFtBWBx/OoOhrdqOxFWC2MpojGrYb/pgW/DyR3R?=
 =?us-ascii?Q?YZslVVMlbCAH1/5P6f3O4072iDZAx2MRLDpXP7k/IXlpfZUNuUzDOp6ixRMV?=
 =?us-ascii?Q?KBxVnDO5u3fuwpCl+uRKRVCZIbCR1SXNHXmXfapKs2wNKmikUi/9FfJaxRK9?=
 =?us-ascii?Q?7h9WCo5ZLdbAECzRhl0nXa/0UsYu6fV55ElcINrP1v7LDFYnvfwit0UauJUj?=
 =?us-ascii?Q?TE8eVXBNzm7KKYCFp93E6TBs3Eyjp04S22wpmolTqn8GRbNN6QGEo897BnRA?=
 =?us-ascii?Q?POaK2YiP62b5w1rupVLOJ0rHu9NrcsXnummf2BjSTmmBk/3hPonJZnmx89+1?=
 =?us-ascii?Q?hn94jcW+J5c73tHuO/+swKqNN+HEX6jrg4zjDdgz9xMV9xOpoBz6SRVd2ZDM?=
 =?us-ascii?Q?aBk0l/RJ2nlTA2Z6xOW+9JjvLQZfafv1rCpMClrc9m2ZbYuD/YqOT1vQiDSg?=
 =?us-ascii?Q?NNL7ucz2BEkoCPpEe4hMkzGeF00ZLHmzbmsGs4IMFY1FiyhkoX9dJe4y9wjk?=
 =?us-ascii?Q?2yv+wQtqCdjsvfwxusJL9Iji2jKUw3YWMsrTH4QMuFgvlZGK4gub/eAE8O9n?=
 =?us-ascii?Q?YHxuWtqrKxj640Y8RoL+kZLBN0AOobUpyKc+JhSonKRhM6pdCQXG9GUbBMvn?=
 =?us-ascii?Q?Qsme2to7P8J643/Uj/aP4NfIvGSur4CigtkoyyDozwCdCbxm+6xZpdBThi6u?=
 =?us-ascii?Q?Ju/SskXlkM67PL9/bAmrPh0+ZTXApusWm3ZGDVXqU5RPvKHHi0YU1BkeQy+M?=
 =?us-ascii?Q?PZf7oPrkSTis+TS0Dc8V078ZVjFBoi03f+bU+oqWEbocPxbq9qlaOSxEbJL/?=
 =?us-ascii?Q?Hd9AyEh7wSswUvZhECjh1206qDKcbtZa6EqDvlKif7km53J8Ani+HQ6swgjS?=
 =?us-ascii?Q?rDE8+mLKZxCgdTQdYiLAvmmTKjp60VFK5CsP6+TMuKcxnMmVjaQtlQxnDMVy?=
 =?us-ascii?Q?OKMeSFzku47M+1XVPepsiliN949RCSq5si6wTrXrENRvYi4QiJf4Wxmo344q?=
 =?us-ascii?Q?mBc4j3yXAR7577JDvErxIG2R30sUH66FjSXfShXm5imET8jR41xBEq+fM0bt?=
 =?us-ascii?Q?I1pFIFTp3dfbpQfpr6XRs/MrOvc9luqkLKXCTbOwjoSu9hYFBVdxp7uE/AyF?=
 =?us-ascii?Q?vSx65l0j3366UEbIczItMfOwV+uZG8h2qJR92urai9+PDvBYy/hQJdBz9Vtz?=
 =?us-ascii?Q?B64i8Tdm8hgsoWcxzW4aBSSG07y8iTY7iFrlHgCeObYV0EiecsPAA1v/XzG6?=
 =?us-ascii?Q?uN9NesuYuibEiUpfpvKJtNvQZ21+QsE3f+AxZxc6tRWiJh7T6voHT7wzEGVJ?=
 =?us-ascii?Q?mw2q5ryX/LqSFPeOEUtmOjMdDX3w8Kh3JcCGx2X8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d101bb1-c57a-4877-cf27-08dc17322bd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2024 07:59:03.0722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1G7XMW7XnHXjFfrq4+SOk8jNdCRnkM191wNCBCQ8ffSPp3Voru/hAFAukpnPqbB1S7YY21ckvNyJ7OGhNskOqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB4431
X-Proofpoint-ORIG-GUID: 2pqiYSSiaWzwoeO79qUsNS2VcuwPbtq0
X-Proofpoint-GUID: qkKWnk4Wdv7nKCWZIvtlA_bKo3SG5YQ0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-17_04,2024-01-16_01,2023-05-22_02

A gentle reminder if this patch set can be reviewed.

Thanks,
Nilesh

> -----Original Message-----
> From: Nilesh Javali <njavali@marvell.com>
> Sent: Tuesday, January 9, 2024 5:45 PM
> To: martin.petersen@oracle.com; lduncan@suse.com; cleech@redhat.com
> Cc: linux-scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-
> Storage-Upstream@marvell.com>; jmeneghi@redhat.com
> Subject: [PATCH v3 0/3] UIO_MEM_DMA_COHERENT for cnic/bnx2/bnx2x
>=20
> During bnx2i iSCSI testing we ran into page refcounting issues in the
> uio mmaps exported from cnic to the iscsiuio process, and bisected back
> to the removal of the __GFP_COMP flag from dma_alloc_coherent calls.
>=20
> In order to fix these drivers to be able to mmap dma coherent memory via
> a uio device, without resorting to hacks and working with an iommu
> enabled, introduce a new uio mmap type backed by dma_mmap_coherent.
>=20
> While converting the uio interface, I also noticed that not all of these
> allocations were PAGE_SIZE aligned. Particularly the bnx2/bnx2x status
> block mapping was much smaller than any architecture page size, and I
> was concerned that it could be unintentionally exposing kernel memory.
>=20
> v3:
> - fix warnings reported by kernel test robot
>   and added base commit
> v2:
> - expose only the dma_addr within uio and cnic.
> - Cleanup newly added unions comprising virtual_addr
>   and struct device
>=20
> Chris Leech (3):
>   uio: introduce UIO_MEM_DMA_COHERENT type
>   cnic,bnx2,bnx2x: use UIO_MEM_DMA_COHERENT
>   cnic,bnx2,bnx2x: page align uio mmap allocations
>=20
>  drivers/net/ethernet/broadcom/bnx2.c          |  2 +
>  .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 10 +++--
>  drivers/net/ethernet/broadcom/cnic.c          | 20 +++++++---
>  drivers/net/ethernet/broadcom/cnic.h          |  1 +
>  drivers/net/ethernet/broadcom/cnic_if.h       |  1 +
>  drivers/uio/uio.c                             | 40 +++++++++++++++++++
>  include/linux/uio_driver.h                    |  2 +
>  7 files changed, 66 insertions(+), 10 deletions(-)
>=20
>=20
> base-commit: ed340d13aa1db6773667ed4bf907738df203fbda
> --
> 2.23.1

