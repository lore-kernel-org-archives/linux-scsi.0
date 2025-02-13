Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E7838F83
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 03:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739417157; cv=fail; b=NOR7SBUR5nZUsoNRF2QC3LsolVvhZ7vTsO0c6XpgtcnOLsvtrevXrVvrPgPpcgytRTkAZP57/NRD5DbKk95sRkiX5Ojl+Iwt+hv9q7t8L3qcE97vrfV+aSdTLHcXjGGhfhTZB/R/AOeMsvrh0QE2nhiFp2gCmQRpYAh7NTNTLgA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739417157; c=relaxed/simple;
	bh=o51YqpIYBtb0Muot9HhFyvWJhOfD+2hspSrno8FEQc8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=GwpLMjyjiQjabS0bdEd/X4G4ul+CzgoPnWG90pPieGC0N+GWZR/XLiMMgUd3lizY2BSIeI9wQQgBeauriQGLLbQnr+pBCc71lZMucHiyWO5wFs5fgbCiokhDYprNDW800z/9YypGuHpHs8ntt6Kyz4ge1rHvU1/5aeAXAkb2hKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cVi0N7yi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Uv9XGylT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cVi0N7yi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Uv9XGylT"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51D1qAc9017186;
	Thu, 13 Feb 2025 03:25:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=iw//ie9Q7PRaENElSj
	xQy3/Gi2PY2M24uhcu/RSsj1Y=; b=cVi0N7yiZtYoOYgRHFi4SxOFZN2aLk9c9g
	+gVS4/fhY98M2/6n7dQq+joo9uVSJhk8VwauwrBloIqCDIP7wDlysLJ5K9YIRj25
	U96+ayhWYhSNPWfoQ4DfOBXgqzcnh+AeOJyxGaVPgPPLzUVzmCPivvT65adUOtUk
	wK8XtOM6URA4ihe1Ux8upllKd/hBZy4kpEB/U6teHCAGK8qNRQiBg7CYjrSUmhl4
	SRn71xhp7mmj9PdqoHsrcurQBCKi6e1AglpBcqHyMcyN9ffJTT8wrxL7f8smzuBM
	ZRXnro8MKXRZ8edMLXpScoWOQWA1OuIBjc1ZbQ4jsXsMe5mIfzyQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0t48qcc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 03:25:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51D1EsGT009852;
	Thu, 13 Feb 2025 03:25:28 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2171.outbound.protection.outlook.com [104.47.73.171])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44nwqhf3sr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 03:25:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UvfshSy4NqdFzjXvtVFtnJRvMxyQh/Z8UDQ/j5/9jqICJidHUlE3pUnGVv36uI3Icg5NRP2ls4/XOrPAV7RTqJzHS5bJkeomSbv14UHhZ5Z4noWBNJa8HBNVS6mRUbvg2zddFfOciPycYRLJ4f1mDngYhaon1fjJZ/OBlUg8X7TbVfzzHd5KU0SvvRvmitsWfBf6PtBvZzgblORkbVoqj9U9IHmpv233zIW0rlL76stB/i7FK4rDRNTmveTkr5fhPqB/vxSX8h1mGC3MKuHVVAUtx779KT47ts73lOPiWaA47//+cdGkiqsI9MPBnMDnH94jZQ4PO16zPGjDX1QKXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iw//ie9Q7PRaENElSjxQy3/Gi2PY2M24uhcu/RSsj1Y=;
 b=jE4ICDdxpfQEQCMelehNjUqcxr6mqVWPk5qk+2qRxDoptQgHReCASq6luUARQjahujXTH/0vr+Fkne+qzK3LnlgmxfRtBIEMP31lA7BwTr4f6rHKps4tKogY/SmSuB0ftNAb5EBTxcyJPrpaRzT5jcLS90FfS8S3hN2z2mGYfncoHia+JPVj2JUtN1wBQdlw5XCl5foo+Q3XWorOx4VJSt0F6iaelIJn+vKndr1pvQdV/EjdwHOeTANMJ2SDx/U5D4UJeu5QfaUP/JzYjpCIVRvKWES7KGkCmlnUi7oOxKjqdgPsvHLG0qzSmKR0SAaju8RG1f5amOy+zFDHd4pA4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iw//ie9Q7PRaENElSjxQy3/Gi2PY2M24uhcu/RSsj1Y=;
 b=Uv9XGylTkaDvgpbmfBWINlAs0xr3V2rGju0I1nvhMPvMqYhOif2A8KhnfHjAqakRXIOHNsnse8b7lvbnRAVhIX83d0Q1L509tNy2b1I0KuUufoK8NnOSDUlZKpicFeC0mHm/EiyMT+GzlIBtJRGaUwRH2djnlFwnpf3/BrW2pw4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB6366.namprd10.prod.outlook.com (2603:10b6:806:256::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Thu, 13 Feb
 2025 03:25:25 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8445.013; Thu, 13 Feb 2025
 03:25:25 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Alim Akhtar
 <alim.akhtar@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Peter
 Wang <peter.wang@mediatek.com>,
        Manivannan Sadhasivam
 <manivannan.sadhasivam@linaro.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Matthias Brugger
 <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>,
        Bean Huo <beanhuo@micron.com>, Ziqi Chen <quic_ziqichen@quicinc.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?=
 <u.kleine-koenig@baylibre.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Philipp Stanner <pstanner@redhat.com>,
        Minwoo Im
 <minwoo.im@samsung.com>, Avri Altman <avri.altman@wdc.com>,
        Eric Biggers
 <ebiggers@google.com>
Subject: Re: [PATCH] scsi: ufs: Constify the third pwr_change_notify() argument
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250212213838.1044917-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Wed, 12 Feb 2025 13:38:02 -0800")
Organization: Oracle Corporation
Message-ID: <yq134giv84k.fsf@ca-mkp.ca.oracle.com>
References: <20250212213838.1044917-1-bvanassche@acm.org>
Date: Wed, 12 Feb 2025 22:25:24 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN0PR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:408:e4::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB6366:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ee31dc6-d055-4c43-4a07-08dd4bde0e7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TATq+l/GhdztT5bpxEcxIUf68ZYof7ztJJREz7eGFcc0d4xJ48SJMROnY68C?=
 =?us-ascii?Q?G/LEY8ajVQyruanssuhksuO7TapKmK4caW/LppM3w8iw8w4zA0atIR8zZJRr?=
 =?us-ascii?Q?okLzftX+uM3mDmaMIde+QfTECwTZtA8ZjWJuC1+5Td9fgeMy1mivkuoiC4le?=
 =?us-ascii?Q?/GuDrGx1jI98Aqy/Rlrzk418X/BoNfwOz20oSElkcuK/UyggB6NyqhIhnUkY?=
 =?us-ascii?Q?pxpNT/bSlyXUOGQzrOBWyC8okDbdinZtYmNMNrOsuYh+3lKze7m/NSiqqCvC?=
 =?us-ascii?Q?5fovxI3Yr16p+p4bctV3k0ksUT8fVc2y1XXHQr58odNLeGYR68aw6YVKwnrW?=
 =?us-ascii?Q?5JwnNxrONTiiBDr63qHypcJEl+IhyVsvvKSzeUDG7KB0UiOTpEu35jNy598l?=
 =?us-ascii?Q?zA92skF4Th47NkMvENUQZDDpMUL+hYHtaRR/T7OGVCrD8YQiUb4g8P9p+F3Q?=
 =?us-ascii?Q?mxJfwLmwMDJXRBfjT2G9sqpFSJVBkYsDJGu2wp0u2b6LzncPfuF6pu1j6mbD?=
 =?us-ascii?Q?Ud1XGs404KEQWuhUbBuyzStSSA6RC/4HqMJU+ksI2/mngsfVgn6zNIu3EsP9?=
 =?us-ascii?Q?9DEdz6vCVolRl4hNA1ggN9lmcIkhvwFuG/MTwUij3/XDMVu7ekV4Fh7SQQ5S?=
 =?us-ascii?Q?75Xkkm7eyemsCnrNPXnH5YYwe4InXdlT6NbsVCnRgWzPuW0C+WwkvMXHQypv?=
 =?us-ascii?Q?8T8DxAkFGtBKrIuTukc1uXQ+eyWvqrYWylgP/9N/Ps1kzVD43kGoZ0++9LOR?=
 =?us-ascii?Q?3bIzrF8HXoeMY4ZPdP17qk5vhiUJiltSbhyUkU9Cz7ZI8BQ6fD3S+LnyHPtK?=
 =?us-ascii?Q?68tH3vdis/5l26eHj7Vvfw3wFFt6PjpQrCOxRvH7g48uscqBWFjvw+9kjChR?=
 =?us-ascii?Q?PDdm0Bxpl9fFFz1bGexqI93K/XiyDKcyKUcOV1nf52R2CvnfW0wMvDbP+E2h?=
 =?us-ascii?Q?vqHtofZcOfrcY6hYh8CWufyRpiGugFSGCvO4ksoodW4A/TI/GSQjLnjyHc0z?=
 =?us-ascii?Q?Vd3w6zDyNNtNw/x98g5zGpHTAn6qu0HbLGAKWqmvLuEeOG2BM+6XzG6K+Lh2?=
 =?us-ascii?Q?zbWC0X4nDrv+Q+qunrJU1bOS8+tZcxob9+BrR4gE/0XBdXj1GeewIKO7mfU3?=
 =?us-ascii?Q?dBWASVtZ4HznyhBrxWauvW9ecUh84VOLYFthhI+tciYv5ymC+4G+67NWh6Ut?=
 =?us-ascii?Q?AxTx9GbGpBnJDpZJ7PS97H8rIvvmECVwE76aqa86cX5TuPnCDnvUfGUUkMDe?=
 =?us-ascii?Q?ApwjtX5WdVOs7hL5yOmiiB5DLtHkx1QcpDJW9INw14CnVpUt1kpauBSeRu8s?=
 =?us-ascii?Q?Lv+fRbdjohs1cRP/GXmhomFWxEsjsyPFzLovQ4gMI/6l9+IcLHL1igrBgZTW?=
 =?us-ascii?Q?MUkVXQ39JHB9iXJBW/IYtFWCfSLb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7YcroJMAvKgBJxAhihh5j59clLNKgyZ6rkCO0ttjGTklfkFuH+CtXQp5f+oV?=
 =?us-ascii?Q?1nViGkpSI7tXhpD23D8TJ1AOq7S/7JSuJVldCTW7nGchyH0mw81S9VU2MAA5?=
 =?us-ascii?Q?cnArsaXQsitq5vew7B2wwyhOUoxqxCe1zSsXP+/qz/dhVFxEthXJjuiOBLah?=
 =?us-ascii?Q?tyq8SJQgcyGmX7nKDUEeXZqDsnDVq7oLk+Ym/nvIQKJ5pgnSER5dbxtIYw7v?=
 =?us-ascii?Q?PvMF1cjHruB/A1W6wVS2gyOIhxz6dJTbM5DfYpnLCG/HLbMnttyFmrL+Hvjo?=
 =?us-ascii?Q?1sTRh1YPpvzi5TL4X23a/T+EIpLRwlfXyIkhYuU+bjJCgbmXeFlvnVCV4Rio?=
 =?us-ascii?Q?cQTPXBiJ10MLLefCWt5Otjyma2bTfi4hRhbZACEPcWN+RYP5DVjP4ANuPRtl?=
 =?us-ascii?Q?wpuRBeW14icYOoPr8SHIZE0eujiDBPpbfGGKehdzH0vlw5je7e3pKDvWEZFm?=
 =?us-ascii?Q?1uITZVIMYoFwuId60bSD+l3jMhLjvgpyFP7+Do1F1SqBKp1RMj3jFsqh2lLk?=
 =?us-ascii?Q?8cmXdyLnA47RB0O47JjtVmP9gEV1EHdUxhD5CAsANTdJoud/o8FUcosYMB6U?=
 =?us-ascii?Q?UEZqWv1RnvpIEHkJw0pQ8LTKHdICrlQHWRJ7Swt2OV70SJtQ2XZhbZb+teF1?=
 =?us-ascii?Q?z6uye5mEbCJcE1VNX7ce5quPceXfjbdCZelr1HblX18gyre9zjZc7fMdqgF2?=
 =?us-ascii?Q?sTiIoLG4CJYKEWLClg9QWE7iNiT4GolZSJAL6EsqUTvod3fzalDfDBZ2sgj4?=
 =?us-ascii?Q?aVXTZNHOqgmnsmxxgTtWKxxGHkNbnbMHQHfg0TbS82aJUqsWcK0v9NC5Ytl9?=
 =?us-ascii?Q?k0ynJrdBOSWbpQkyzXHfI4wrxvt4djgz1VuDy6f0iaeL/heAxBGL2f4v19kt?=
 =?us-ascii?Q?EeBVnaPY6FS5uZpsit7eAVazr5WA7v94CWlxe05/OyxDP1BVPD1lLR1utQv7?=
 =?us-ascii?Q?7GPYpQWttISAmsycqHlXVkK95gn6V8IiHx0fnHs7OdPB3pYz8D20S7aAe72y?=
 =?us-ascii?Q?OBfy4dnwESWb7EERif3xiZMTexoeeywNHO8jSZbimoUOaWq3P5ICUSP4V/Dn?=
 =?us-ascii?Q?mAjCMYY68v6x/DZ8a7SQrXXD9bFS3MyIzVjWWIhoCX27VY/SRKwbhK3rP8RT?=
 =?us-ascii?Q?pmZCmDmUE3mhZ7DtoL+XHLeg3oI2ZdRymCiS4Bm5blWYmexE2ej1iWrOBQXS?=
 =?us-ascii?Q?xObwfDmusN4h3dRhvWbau/GkdJ+tA0sdwSN6oDPdWbOq5Jf8FrYJxoej7yJv?=
 =?us-ascii?Q?fWLNtHRIrXhu/DacXnv8RFN9tlTunRD+/yp/y82sWy8EdKdnwba/DyAjxXUb?=
 =?us-ascii?Q?UnCs3VcvCSzzcvU4clywBWPOpFIEpMGxMDi5Al00eyAvX1VzWj4SIrtEiLML?=
 =?us-ascii?Q?AKJl+qI9GxZlP7RsErAkFfVqg9G3VT63dHLREjlvoDjEXFviq7hOE+BE9wZw?=
 =?us-ascii?Q?V1dX2Pl09QOyqIcmHKV6MI6IyyL3s6jr3PTIin2VLb/pC73cvFBbm29/3yrH?=
 =?us-ascii?Q?SPxRqcvsaXXMUxYTax3a/GfQ7t8T785RR55vK3YEEoRGw2BJ8NLmZx7vdjYH?=
 =?us-ascii?Q?edASYpy8ueiWI2y++P7WT9LlSLna4lvmy10S7MGbR+Ro6E1I1yQh6XamIuIx?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	odsBsTYLy8FAXro+lFO6a5bUCoiG/HH7P1icN8kPqdyph0nAbyQrEw44izQlhf82x3QQOv8uVTDxYUfsAyNOEblxyxlHsgUGPW+w5lI92bTU+B0W2BtCmfuIfdjPgcL/DqQlbXMRk61kypXTpn4O7C/kRm+rzAo41CHvu8adHzk5AFmC0sKauVirEta8oEiyMid9oI8swbf/Vvftl+4xmgO7wwHSj3KZZDIweiNoxToWJBVKPsLoIt6/1NqXGjrVY6QuNMxSxN3F6e8HlpPLJXMi5VBB0DXFm27DbJYgBuhkf8Wv6bRvTtBdSovJ725po5Z8ujCjBQSOnxP36QqLrD2TpcZBF2r8Jgk4FiY4KUmkNOqB++yjIIsBVZPKxT3IXtQEULwn9Zl72jJJuAb0fO0bgHt15rUAZtDbSWnzLUBBDiF4UvvoIFPKK76/djkvdab793FMT0kEfpHtoPdkl9Ndb7TfhI1IFn1cRx7FjbzK0nsTI5SEpk8ljvexT1gZEHKGz9wmaza4FZF5Phcq8ahaTE1r2h2hpqk9gx+/X/2NHS8N6PDHm9iLWxM4VeOM9AdbSAtiPnaBxOnnJydPEX5lnLw+N5U/Z0saP0myWU8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ee31dc6-d055-4c43-4a07-08dd4bde0e7c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 03:25:25.5588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DvDj7PBf9wD+bBJELGWvpRoLSb4fevA2MQUWb2X26XMAbPSveS+VhRz32P/yo0E3VBfDk6pAkQKfDH1s5EHTTTF7HTrwx2t2hqlW9VdHsrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6366
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-13_01,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502130025
X-Proofpoint-ORIG-GUID: rd52QvFb7hGhzg6BAX_RKrKlEGRRAFVR
X-Proofpoint-GUID: rd52QvFb7hGhzg6BAX_RKrKlEGRRAFVR


Bart,

> The third pwr_change_notify() argument is an input parameter. Make
> this explicit by declaring it 'const'.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
