Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE651D435F
	for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2025 02:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761272178; cv=fail; b=fI9XOCvAy/DkLsYu3OmWkmwvW869KcYHS38SWOUOPjEsJQcN14J2T/0MSVLMNt+0k08oqqadBepAScz7lsfsha6u/dgJflPOc5QG8JOm/x4IefcMgxANusi06mtSkEQDzKmZBssm6AorVTIGVjSKxHhRiOWrrIf0oZuQ3UfALMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761272178; c=relaxed/simple;
	bh=gadeu7qbL4fN2fyzzVwjzFfvUipLnca5Eow3Wswg6Wo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=KNDWWflkVGu5RasuYmE+dJJz/RAX9ooSb1q9WRQtekqqaxCO4woStJMjGTOtfCNs0RwPKbHC/JQqN9te+lOLzLF18m/oDyLX+adxhAQ9kDLtQuTtKIo5tvhQenFJ1dS83WzWmcMghuLHOZBjqObBSWC1Avv1jQIOU+IU7IXxSFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Jva+U/iM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=apVBmdM8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jva+U/iM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="apVBmdM8"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59NLNSq8020269;
	Fri, 24 Oct 2025 02:16:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=CgpvIa9oVttRVptP9b
	oYluw0rqqd6gQZ9WamPZm+tI0=; b=Jva+U/iMZmB7Kze9eL2F3rg99aTFJGxRvZ
	9E73KzBbeHD+R51NUaIiJK+TAPTLifveM894gy5E3kAonK4E2NCPuxbqaqemDXsL
	gvxrkZ7Hul6QwvhNYYsKF5gUjU8pjXmXwCl08daQNZPH0R4e4bCXOsa01GYBZO1H
	6doiTb1CVj3Bi81k6XnP/1SK+ys5l900xOt/o5NWlbiXgIK61CyB/cLfr/bhSqkM
	DApoZUM1/SnRRTfbJG/CVSX3wdAVArOT4Ff2qymV8R/EXYfDX728dVlygyOY6hyh
	Q563x4kHzdwxcdujWMOpQRtEmHnJjSDkaOsU/kMK6Lj13BFzaUFg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xvcybu3f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 02:16:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59NNAI5b012170;
	Fri, 24 Oct 2025 02:16:07 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012043.outbound.protection.outlook.com [52.101.43.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bfj83x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 02:16:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RuIK44pmbMjcLGt2aVoB5KvhhZmH/cWt4tJR3Yh3ZdMfM5xxANQhcbfFqR8J4jyJs/kggVAI/egRvxx4pmBhYJ+ZBYrN/c84Keph8KemnXpIu1R3bjzPbzo6itokeK19PdSn2yV1Rtq/D6a5ItJ83YfVEg1O47itpQXGbqdu/VCpfIgncoS2FRS15kH9wIVMhmKYMPChLka42JjE+SjzBUP0UsLbc0CAB39rD11CzkgthOPgvEGTphhrhE2EvQ+L16tquL7g1Ta8kSjARs1OI60rCxp1xWI1LN0eHheJf9+wslOu7CzzupVlHingsxrVC+5b4+2pr7kn2wEcYCeiNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CgpvIa9oVttRVptP9boYluw0rqqd6gQZ9WamPZm+tI0=;
 b=xpWIMU1NiVpAYXaCM0N45cWHhBI/2dA6I9twhkh+Deo1e2P+HiLKgp1JhxAQa6FYOHKVMx/A4J+albX+S0ORRYPmGR+7hN+W/rAFmY3EdxMwLGE62NGSX8s879QTi4tMybtTjfrgVINqnzW9VXgQRSB29bJV6sEI7YEkikZLxQEFiT7zV/RhbTJLKkVwf9Qgy2nCc3shfz3H9ZuRiBxBWH9EDOKi+slYvi8gDNeSD9lERRcP+XOiJlUiAZpP8Vx/kX3rrgw/utsrdpv86zqBMmlbipYLjC7ajs+es3xPtiFYiVrTT4qztRdki4SpZY0I7UWs2gcIdHdDBK1DzBr7ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CgpvIa9oVttRVptP9boYluw0rqqd6gQZ9WamPZm+tI0=;
 b=apVBmdM8wrljIbplK7SN6T/w1gaSiqiav/vgBOJMNK0qx+8CcaqgrJDkeVllBCNcPorWfvYZQ66EoAo9SxQ2RNilfbQdesGF3rLygb40V0KeZUVwNE458vR4YIf1ayNniU5sI7dHxx7VTHc6KMhyrJ/HeRTA9BjDp/yHBftKwlQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB5169.namprd10.prod.outlook.com (2603:10b6:208:331::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 02:16:04 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 02:16:04 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/8] Eight small UFS patches
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <0747ab58-1895-4753-b4a0-4e93bd7091ff@acm.org> (Bart Van Assche's
	message of "Thu, 23 Oct 2025 10:29:54 -0700")
Organization: Oracle Corporation
Message-ID: <yq1jz0lxd76.fsf@ca-mkp.ca.oracle.com>
References: <20251014200118.3390839-1-bvanassche@acm.org>
	<yq1ms5j4raz.fsf@ca-mkp.ca.oracle.com>
	<ueff6kzx4imwyz4bqxgls34lg7mw6oyi73yyyyiqtitbxu7p2v@rhlok6yvytj7>
	<f761feb4-6b58-4778-9417-067993a484fd@acm.org>
	<b5rfpnuhhewqmnaqa2uzivmo3byzommrjeanoawn5x5vargt2y@7vl7r2uw7kjo>
	<0747ab58-1895-4753-b4a0-4e93bd7091ff@acm.org>
Date: Thu, 23 Oct 2025 22:16:02 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0010.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:6a::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB5169:EE_
X-MS-Office365-Filtering-Correlation-Id: 89030f7f-f000-4e53-ae61-08de12a348f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ipB1dDEnsajfcuE7WlSJmUx+m9YDigE9ruBY+yisN+khOddlb6yApETnAdFw?=
 =?us-ascii?Q?mscVwb6giIhCzRBT7QAUyyB6j374hholwICjFOyNBXE1BQnYO103BVHpsmrs?=
 =?us-ascii?Q?ceaUiaYl3GgnMnC/S2M1mH3i8qyK6+3ZcqYlX0puo3hQnLsJ56Y4FTLGpjIW?=
 =?us-ascii?Q?nWw25PdejzgOnNXRp6nuRH+XOEwy4HTHUZ8X7d9VE65v3T1j0iTW2F2s3BMm?=
 =?us-ascii?Q?/ZAZaEDMQKJq20C1rMHuQOm6dvEZwsxxLv+4l1wDYW4k433dmmkKz5+66PAN?=
 =?us-ascii?Q?LssFycXKbIXJfQHhY7Ol3vvGzJ7MfWm/DMCKFXRRJxclOxQ+XgCXpLD8Kf1K?=
 =?us-ascii?Q?nxPYsW5lBjy+ZiARzQyRjvCuosY4lWaTp4PgZ4tbt5EuCSqeBMXHRfE3kB7j?=
 =?us-ascii?Q?SRObYSR+htvYwCdMwGynZFAa1R0kk5lyWI7wpy9v7OViiYe3C3YtETAqJVkj?=
 =?us-ascii?Q?tjVTFbOpnI6rsrmCZcjLkHWlNSEkIL+UoTep16ckoSLCIvOU9EE0SLkIPA82?=
 =?us-ascii?Q?66NugIRf6GnFfmsBPz9xj/s93x5DEH+79ckxcmgeJijR0Heuh6CshsQP3K+e?=
 =?us-ascii?Q?p8zgPjR6ye1/BSgnnnKwRVTB5FUJbkh+PVnx/uWIWXaV3EOFcHSyhDqsbUvM?=
 =?us-ascii?Q?fzG0WJNroO8tYVmXxD+rXlHgkCt8kU/7gqzy8BoCPu5LN5BJBkpQTOB5F5Ii?=
 =?us-ascii?Q?XVAQJyymcxOuR2wUzaOGQoWjCLgsvdm5Gn/w0pAZ0nIQHYwJTk2wrbZTvj7U?=
 =?us-ascii?Q?oPT9Al8Hq2lzNRMTT/AkNGol62FhnppzFC/dbxKqierGhnwNlZF28wMEmXxB?=
 =?us-ascii?Q?sEqkn178hs+CILIjvCzNR+bFhuV7pH2k+jvPDk/K0W0D8KB5Yfhm+lfKbLSe?=
 =?us-ascii?Q?qspbqWc3uX8mv4RYQ77vpe405A5Ib7E/Heiz8fYytxNrqHgQx7b1M5nP4AOK?=
 =?us-ascii?Q?OV3BGZodLoGnUsEKViHZpRBSYxhpbVmyy8+t5YQ9cBFtcEsp50Q6lDoxLZ44?=
 =?us-ascii?Q?wzVddaURgW9d9wtnoARKN6l8F+Xa/evajZ3t3K8E9iSzzZ1G7cpaf/zcZCva?=
 =?us-ascii?Q?ZhWhRnIvwuCaBIK5LIDG9czm6kYBqI5Ue9MgLElWidpm2laHfbG0Ihm6xdFx?=
 =?us-ascii?Q?PX1fhLdhi36xe1aMmqupNbRqmXaLPeWF3pGZ5k+HSI26jSlkOk1gppROYA86?=
 =?us-ascii?Q?pYZX6vH3H1nbPlt4MiwCOUb5i+AaQ1QFJ2IJ/eBiDhJ9ZaNaFX6uOLl6QY50?=
 =?us-ascii?Q?hH6JvOsKo9cQz3wElrnA7UDTxAATJVzHbYx/Z+1erYP1tIpxRTrt1gsv+I7l?=
 =?us-ascii?Q?iGcVoKQ7y/a61D6y+cmHO1I8TAHqBnD/tphmQ7GZxQaN3ily0Ax2soX6S+GT?=
 =?us-ascii?Q?I0G81ceU5Epk/ywODbsYoU2q3gcfUa6tqx32+3ZmSQJ547w/vy1nniKKl+Ea?=
 =?us-ascii?Q?xOdGydU6bOcpHObASYFst6xk42ekjM0g?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qZijHFZR3d70FR8EwGkXm2hhBTREr7I4iScunq70Q9pE60bOEiIEjuohRHeK?=
 =?us-ascii?Q?FY0b6u7lCPI6DMyQ1VCQ/O4XL639HeQHWa79lklEfhgxq3YfxJi0vzTkuHFz?=
 =?us-ascii?Q?Q+Fkxra+99a5GqyHvCaCwJG+/BR1eBpGKLfuxIAXbEvsea4COg9moprV5YoI?=
 =?us-ascii?Q?+UQhHJNQ7CLj9dhn5PSuxH+p9qhWa/YSoU/GrEt1HLEfZvHCjtv0y38h/9BU?=
 =?us-ascii?Q?7vpgbjmxMPgYstEenzOJpK0clMoJAzP6yIODWiVXxx8pIZLPaq0MEVBx2Wvg?=
 =?us-ascii?Q?UPFK0NJlvQ20v7H1xBXE5anx56SpQFrJW7rbm05WrEzCFY42Klfm+/9ufDMd?=
 =?us-ascii?Q?BdAq9F1VkLVN1jRQxcVP+JQ1jIdIKUFh6UGSXT2/jN2KBpVlOaBCxIegzjnk?=
 =?us-ascii?Q?YqOTEA+N+pVPC1vHSBDR6tsEx+4iUjdWOz1RFjoBWJTymycvH+NIBgkQPJ0x?=
 =?us-ascii?Q?1ZVvwX1pT0hoZLfAM+BwoMvqHlODE7skf+uVcLAe9fEA4VbTdOtCNfsXY6Rf?=
 =?us-ascii?Q?ECouBtmwh9gBblQev1cEQES6t25CSB/ZdiKU60gG5a6jklu1x9enoes6pR5H?=
 =?us-ascii?Q?tw3PhoF0WxpgE7rHO1+SjsXkM5Hm9sOFnX3p9aUcB6xCXoDU4MAq6960s+x2?=
 =?us-ascii?Q?5s7WLXJQm1kQ7qBFZ0Gj+UsRO0f6dChxBWIIHG4hrWbJb6y43bgZAwHB1yhs?=
 =?us-ascii?Q?kba777ur5lHrw6p6uOY5P+Soa6NIQxRP9cJZVBsjY9oigkJ2aDJuL8H4psTp?=
 =?us-ascii?Q?EOFtSMyEXift4KdsXeOJuIaAb/0nFUDfdrfzabeGDBcSYL4T/sX7+fa7rxnQ?=
 =?us-ascii?Q?sYNSaXR3UaVbWqcDK9XQM+FmZk+Pw3IcPMSkeX1YkfRYb+AWCtR74C8en0Yg?=
 =?us-ascii?Q?NdJFOzSXWKmGPryd+wacQYOTsi270ytwpY/gNMUWhjj0z4lksOKHypC65Jw+?=
 =?us-ascii?Q?En8EKDweX5gyiCCE1roOWzbABcBBXI/8j45ynzzAXhgJNPoOl5FivZMGfzay?=
 =?us-ascii?Q?EVcK+mwnMn6h4gCw7Xrhy3d+1UJvKHUJYHQg/NxGfnezyEGTpbwqmNNyCG/c?=
 =?us-ascii?Q?WYrgIAeZGNU5BC2MQPafaG3UwOdw8EFO/+sKYCZeICGo+0dYHsVzwVQb1nah?=
 =?us-ascii?Q?/5wqXE2XVRQkG6bzNezNzJlsTAFz/c4IpXgzyMjKuZ8VsFMzFWE495DNtkxg?=
 =?us-ascii?Q?gpk4iDgGsPgjcXmgzIpT1Gdc+RgQ3Xv1mhKAUZ7F3A0PSikAwhS4H0IKCH50?=
 =?us-ascii?Q?II3wZqll1smG6g4GBQUATtoxOOQS7HzBBLeV8+f3OG1IISME288HHlr3yqbY?=
 =?us-ascii?Q?E9xALxtIMQoQ5bzfTtXRTfOHQgAr+xRI49+od4wRB6i3o9M+jsoHlc6X/TfV?=
 =?us-ascii?Q?tGMZNEpN85Lc/2Nk0MtRTFgfYNcQ8CMq0Kl/co819qWINfOS7MPvXfgK8Dx3?=
 =?us-ascii?Q?0zwYscEsT0LkDSDZrh7T7obDqTjYo/k1TBPfM9+cuTfyO8HACXnRgwnwfOor?=
 =?us-ascii?Q?hohuPwugePUEP7AW/zzsdq2fnARvti9D/qUVmoAeUiU04I3i45sysAv9hz2E?=
 =?us-ascii?Q?da7Ij4znIBRQFQxAMMPHMOUhiUPHgY3QlBEP3XIaH14MQMyg/QGbGg9Wh+L6?=
 =?us-ascii?Q?FA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hH144UEU4AD2+S6zb+JTtdCrjnJBsotjpJSypDWqHvx/2W2S3QHRSnUrBpUoi/mijrLMPYomdJS9qNgdFQjdL5+l0OHObQkpYYbdc3nRpll40jUekSKrhdSzwWJf1bo7MZtcsropQ6+hrtRcPTrP+FYfd3f5jTsK7XMTZC1RKlUWkR5+52RaHxjxvAuLRuIce2Ex4DR3w8DoocuGKu5IAfyXmL2QoGGfxA2rIaVrSKTk4zhgrpIelxg1mXeTaK0+DqJbP0cXkJJBp5RbncUn3jeUvBg2Y1zsFlRyl7Z2YoDxaXkCxDUxg8w21O+HsY+ufApD9G1lCw+wWSQwf/5x533zuhwdK4ceWFsdUhJmdmqgVKtenQ0rsYim5lThqqoqOmVd+U1oJcSzGVGPBAzTTS7nImFHQESsXBETq9+uCXYvSM/R5z1QwfRrMI5YRv0pxqu9FWSmEmyepRlLIqKU5ItgfgKCfFea7mQJ+OQ442KpQaPF9bSph39cYA2Um/Y9Q2sm/I7wPBdvZljCv58Kn9LjCS56N4ePgzD+TM+5jqslRWQ5xmUMUoR+Fg04sb0JVS7AmFN1GvBuWrX3wej3osw2TfYRm8RQy0SLABI/2pA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89030f7f-f000-4e53-ae61-08de12a348f3
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 02:16:04.7239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zf1EYujdZJF3SIx4GZENKmJ1TQNTFPZmcuKO8XSIPCTtaBCuKhPnLQJnLwj8yCKNdm9HU/OCQ/qAVBO+8F/HtVsryCbMuMsYfvwX+KzKVL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5169
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-23_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510240018
X-Authority-Analysis: v=2.4 cv=GqlPO01C c=1 sm=1 tr=0 ts=68fae168 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=4KqvmaxTm405Lt3BozwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MyBTYWx0ZWRfX96Ol00zxNtoF
 aIn0hLH4hht90xczDlO5lDnc0wGg++vhvfYHVg2/zO2IvdNjxnC09XVCbjESeKoR8AoiiQoo5Jw
 tjfZH45MnRFQoe/1ZpmNB13eXWgSdBY5qVYr4vtfwTuZsQPPJPV0LEwox28+b9ds5nmdUSft3xH
 ItjHmkSumu8IqJI1/9AbRzCHhsMDzadcFZNsW3YOi01OIkI/vp7pnNmTyIJFbKK8qTP91r5d9te
 6WUGTxqgWRG5TnKFeUoGRnvwJaur1ibjm+xPF3LjkJiTL30ljgH7kzctbtwoooMH/ah1x50GL7N
 7VXeLF7CNPl/W/1CyIO9p6ON4+2IvYKKMxjmGbhzHZc1YoXyTsPh5EufhJRH2c7IM+D9OQ7EhqI
 POgV/+rVJBo5fgaOUDWEN2XqLNpXIA==
X-Proofpoint-GUID: XlqgVA9mbX8slB5BWAiJG8XsyUGaCCPl
X-Proofpoint-ORIG-GUID: XlqgVA9mbX8slB5BWAiJG8XsyUGaCCPl


Bart,

> Martin, is it still possible to migrate the first two patches from
> this series from the staging branch to the fixes branch?
>
> Please note that patch 1/8 from this series is fine but incomplete and
> that I plan to post a follow-up patch soon.

I did consider taking the first two through fixes but was concerned
about conflicts given your large impending series.

But I'll shuffle them over. Will have to redo the merge but that's OK.

I can always pull fixes into staging once Linus has merged the two
commits in question. That way I am the one who gets to resolve the
conflict.

-- 
Martin K. Petersen
