Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BB417CF
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2024 02:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706062030; cv=fail; b=HODUimtwcpi+Mbs/SdMvCEvYhTa47jlYKm8f41FL7WXuuArrVSC0f6TX5+pCxn7ZQZGIsh3nk3tqkX2+H32tEHkTxUvEi8shxPVy/BNdJKHyVjCdhih8L3iPW5cK94Vy1sibKlwmyw0bF7SrklVKC7shWuObqFowEFIpTDFWDh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706062030; c=relaxed/simple;
	bh=q0a7N4NQtARo3S/nIzIS5qzcUrXiZLA5eX0qL0UHlNw=;
	h=To:Cc:Subject:From:Message-ID:References:Date:In-Reply-To:
	 Content-Type:MIME-Version; b=ZLZaCq+OdE6wAfQI4KVB0aTaYel2j9H6dkxe2hhYt1cYlpOu0u8hEHhMdKx8uLFhZNCFFmwRJsabmwPDUyx84u2fRvxp57hsLZhSwpEIXchq8U+Wqxw8RPM4vgWXBafvAJfHDmKDgkY5Tu4Ynh7lC0wJE3e3akbCYh9pcSh/0jo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YTHq3ZpY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xiyUlzxP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YTHq3ZpY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xiyUlzxP"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40NMuMpb011663;
	Wed, 24 Jan 2024 02:07:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=OL++luOzCaOK/Vemf1FoUc9NNMYK5GvTLNdN8BP5UAI=;
 b=YTHq3ZpYPQO1+TchTxLvvr0wzM0QDU8F3+lERCMD5rKretUqf8vN1QPrU9cDeepYwitG
 5aoI5+/Jm8J5ZjyD5t9RsXLlNeEo/ohAH8rFYhNwt0jEJd3n454TuiUHoQGnAPtP27uf
 ka90VYWPK2Gcdp0cQ+pUlsD3ERgPiez3N8cR6X4D68u8kP5M/zAQEZPckacDlftqZ4jo
 XaQrtZeZb8B3M5+w/dQoapGFpQ3irmHvwtoU8MY0MYpIOkOslAbHqqqOJY4Ij0o171+x
 B5wyBX/TbQlFdL9pClkR4OZfaCnL+d++YH+vMYmVM6ckF9Nq06lYRpsYVlAdS6H41wxy og== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7cuqxs4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Jan 2024 02:07:00 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40O1Llma040800;
	Wed, 24 Jan 2024 02:06:59 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vs3167a15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Jan 2024 02:06:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a21XOk6AE69xe2FZqQtbnldZr0iwbj8qejAAu9wrLzQxjLHonhzRKkMoZvUjiK5k0l90yfAPKyDfZf6ihsR1/eNbRkw6VHozPHdxRDNKDf5YWY3EK+XNJ7Ao7u57FGCZwm0HMtdV/0e6/HwHV0k1de3+DZwFpKToGpa0ya+YkeyaZ81ODltuucYelo2zPbFIdU7X7kQricKnyL09iObEPmp9GAxDhF3C7t9T98fGjZUJw+yZFRZFTxlXLdDwnOG+C2cK4bBjrq7UGQthNxNzp60nqjsAleM6fPMUwcvaRWuTkV2O/Bqv48L67V5Xl8uzvi/2p/C73LiTmN3u0jgDHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OL++luOzCaOK/Vemf1FoUc9NNMYK5GvTLNdN8BP5UAI=;
 b=EmkS6RTR7S0FYpjs8C7RluFh9M8m782bjtcMTncxiTUBbyuH2+Fg3QSXrLqq42DG+jJgzEi5NJC7bcVT6UQy1MkH4G8Oy09N1riwJuSHjcKWlH5pxCH5mxkdL3aB64cCM3YMv901U8SLYfvog2xobyqQ33SrXIe9TvA/nMv5HdP+cQ9wwMA7rH9lRGvL/MXFSxG4fQ6jarKkB6Eij7udfDhNdTX1tNmQ3g1IDezQE3QxhvvzQ9ef7vRqHfLhZazj2pHi35xJxps46xFPhHn0Vv0rHlc0bydZJD0rRSLrZnm/egsklFvmxlryMrwbkF2tarWs5slmpGW+L+jk8iQxUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OL++luOzCaOK/Vemf1FoUc9NNMYK5GvTLNdN8BP5UAI=;
 b=xiyUlzxPgoRUiWUbOVT5HhObUcACke9GQ5GTxK+TPEjTie18SVhdyu3WNUpmDpYgCPfBPpcV9wstPzu2E1mbz/2n9tnoHtRdgQiwyf4liLjzG014BomlY3wPHlR2HPcSyWdAOcZWQb/ghrb0xHHDDdpL9eXGrzsmD7Q4+ljUNpg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5747.namprd10.prod.outlook.com (2603:10b6:510:127::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Wed, 24 Jan
 2024 02:06:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::3676:ea76:7966:1654]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::3676:ea76:7966:1654%4]) with mapi id 15.20.7202.035; Wed, 24 Jan 2024
 02:06:57 +0000
To: <peter.wang@mediatek.com>
Cc: <chun-hung.wu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>, <tun-yu.yu@mediatek.com>,
        <eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>,
        <chu.stanley@gmail.com>
Subject: Re: [PATCH v1 0/3] ufs: host: mediatek: Provide fixes in MediaTek
 platforms
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14jf3zdrb.fsf@ca-mkp.ca.oracle.com>
References: <20231221110416.16176-1-peter.wang@mediatek.com>
Date: Tue, 23 Jan 2024 21:06:54 -0500
In-Reply-To: <20231221110416.16176-1-peter.wang@mediatek.com> (peter wang's
	message of "Thu, 21 Dec 2023 19:04:13 +0800")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:217::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB5747:EE_
X-MS-Office365-Filtering-Correlation-Id: 2539d3b7-3ce4-48d4-039f-08dc1c81248b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	D/z058Z/n7SsLsySHq0CYtM5ImV5SGqnjS75H3pOP3Rix63J8fylDf4Ns6T63cpQZ63nJ+kVv19mm79D3oK7avn42deLkK/rP11orpDfAwps6cFkohw9frCUlSGSOSz7jChGn54jbkqgixXtxXxUxXq8iTQjq+AqlTP3WZi0LcokAdC2wxxMIGm7A5xRUU5QN9zgjf0uEOz+gZlOTJA5JWG9ywFhYPIquUD2IWzaucNfia2nRYhRGGFdYCJtEwvnW/MPcg46hDz8/Rxjm06gKyiF5UsHq1h4Sx038Y7c1S3GAs3expFfEEBWZOcMlNct64NfZCD20htgOmKaqyALNQa0iscUWkZ+ktjoX6bfsq5e3DXkRQYP4UKW+tmvyKmmzkDdmQFH7sUgB343bm13+lkuEx/HNDC6lMsGweNSzvVJaFCT34Ur8D8x0gBHsefEPjGd88tQWqXE49H4eEAQMBtBwYA5BfYUlN9Fu+GEH0VfmKAVNta6g++eaifU52HmErbBi3FQ964JymybZBf3Rcv6pWMrKD5LmiHZoBXJnknTZr0dFEVTyfATUO2srnis
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(366004)(39860400002)(376002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(26005)(6506007)(36916002)(6666004)(41300700001)(6512007)(6916009)(558084003)(478600001)(54906003)(5660300002)(66476007)(66946007)(316002)(8936002)(8676002)(7416002)(4326008)(6486002)(38100700002)(2906002)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?NCuBfY5kI+BjbCzeox+58/XU/+Z3Rs0zz2jk20usPb5WL46eaa9SN8Wq1aeJ?=
 =?us-ascii?Q?50176KGyfRwcQPcmSRyfm+HLtjhuo42Wj8LkBfSqb+UD+WakMtgWJdVUmpJ7?=
 =?us-ascii?Q?iO0aNJJIZVxbeCU2SY0oq/dcjISQQBA4edvmuStvm1OdhWq54vqiewjuNsKQ?=
 =?us-ascii?Q?kxXuK6mD3BT2MGUxoxuUjcdc3z1B1vtqW7ywsCK0XW9w9S4CNlNHcbJ+Jgmi?=
 =?us-ascii?Q?xCauV4hbdzRgagoNZAB25V6qUO0+CC+vaUSpPXticQBbhN6tNkIkmBmqr0lO?=
 =?us-ascii?Q?lqDFxwbOekqLVnUjvPe5naHfplFH/5/rzvLvv6AKDXecwTBZN1bzH11QKA5d?=
 =?us-ascii?Q?x7Q1j7h6SVmkIYStlIExeDe3rItz2XiHtW2oJXkmktQVu9iFmsThgUlnudJ5?=
 =?us-ascii?Q?R36ZzpBHCsPmbzyHLUTIgf/gFBL2+tbw09MoBNcr57QDJRkBNHP0RGjQx46O?=
 =?us-ascii?Q?d3rgyjgeGgPxF7XQKOF9iUnykpNugVi7aV/oLFbUMgdX+x7MmAhbdFogfjK8?=
 =?us-ascii?Q?c/7fhTXRjwPxsKRv510VGE48wINr4UEQ4UkvHabR3WiKi9d319jRHLBjyvR3?=
 =?us-ascii?Q?hOOjaIdOLWw8qhMUvKDH/gfkjCxT9ivckKhfnkI2Q9tlleOOc8MNBAr4vLcR?=
 =?us-ascii?Q?kHO4UcaYd/fDwv0bg/OR/WjhaWzqQuC4K2BK4z2FKxr9evo9XP1FxgmftdPF?=
 =?us-ascii?Q?mOKnbS8Zu45UCYrh7w0Tebar86t2bT1RaurtP6GMuoKQo96pYxZgYuRomZG0?=
 =?us-ascii?Q?5WhRVAFKSZjiZtaIH8Q+RF+1AIg0euRLTLV8TVfqC+xZdFbrskWpBEdC802h?=
 =?us-ascii?Q?sgxP68cVs1DPnU9ouYVZi9V27vKk0R23dcV6smqTldk7YExbGsPwZxlMmFVm?=
 =?us-ascii?Q?sz3dMVuYrCpbG23JvzGKqtVyB64L+ujTfn+gGFvg7qdQISufZSnqW7zYMApg?=
 =?us-ascii?Q?SIV8q8Hzgfr/M2gRYg/nvbnik9mq9kgDCoBPaDTsJhlJoHZwAAZdKREdnkR3?=
 =?us-ascii?Q?auWt6mnjCzSQgJjYpvoT6Ui3raxWZBMevzznqtfAv1PyRr9e9N3Bh5t1s4VJ?=
 =?us-ascii?Q?D4VFrtaviHBYTHQQaX2KRh0vBwqJEK0pa4PanfwqbGDZp3bZ4ik67E79hb91?=
 =?us-ascii?Q?lV0fEA0OYObLT6tURSsN3zlPJSN58wuWOZ40zsx4SFcGFKnB0Oq4g0r88Gdh?=
 =?us-ascii?Q?O4BSVTyu5nwZWadEamHqt9Cm4Mp4OMidoOutyqwfjDVL760JHOIpK2dbvrsQ?=
 =?us-ascii?Q?7VXtkgqkaWoMFbSyePueL+r4cNtpCX3fqmFBPZy0OCH7qTvcgi9Ril9pGlz7?=
 =?us-ascii?Q?qAXvUb6JGxki4EAI2PU7E8ihiPCylRXMO+wDm2lZs7MtMSuCvXQsskBjY7Aq?=
 =?us-ascii?Q?L6kMRwNmtxfkC1g0FpUcM5JX2pcTeeq4FKm2rbBHzjCIQzZpS0u1ueCjlvMk?=
 =?us-ascii?Q?bGPA3x5trlUu0u+LpSlo6D/OQWYJZ6SQDg/OVvdfx2tChUaV3uBjZujpckMT?=
 =?us-ascii?Q?ehbpdzcLC6UgqKynFZXfZJHAm45qesXOLqX1eubtcWkJkVk6BO8gSMV3etsS?=
 =?us-ascii?Q?GDRQ2crJgNxVuVwAQCmpHG7k8dTcJhHpkQE1PENvnL75ayd8K+pF03rzUO+o?=
 =?us-ascii?Q?2A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ppS8Pef0xqD2HnOO17KKq51EvMSwVn/dujJPkwNoBneRkBQauAO0kOfnN+0YoIkLnuLwEXNZ23NkA9NoJzZz788sx4fvYF2BF0pL6OmQwKJzEm37j/tneLVlhvdQYcc623gH990fL7LZ7oX9tnDYbw2I3pMthBad7v0KnHJSywX6qh5TYj52GVu54ybVowWxuSSirV75NdQtC3YvXlSoyTf86PQuc9qLnzpR24XaAPQFeqt2EZQQG9M1SK5pcICjjdTmKBrJ0/vcrZlS7hNH2PWCEIbo3P2Ja164whf/TYiZlLXvZZvQycIYErtMFospupT6HwVIYZkXcOJivgdXMvPZe9aNlYb2t2rQ3jYmZb4C5ioNYrE4h0paHo5K8684R8BAhuYDdSGpjjNOg9qfKjDsx0IvHgmcoxtCN5jr4bow3xtE51XeQRPQxir2Qc0gf6GY/qtkFLi7P+/iUEBcBN/cKuJd04AL1zQbT4351W0In44tABf1V7vDCxrA1cofgMKz+mC90RV3dnH3nAgI+eiFw+K7hcClpoSrE8LcC8J04HfqaNhPX+YsnAYPGDWjjcEUM0qH6Sm01VWG1EDjDIEpXViBUdyuCGW5A2quEtQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2539d3b7-3ce4-48d4-039f-08dc1c81248b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2024 02:06:57.0191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Okxfvd8lYQgLJJYueSl1dN7MpplGnrE25vNA3zpkNTAY81JurS8r1BFSDzMl4IeiEKJ4NeM2ym+eTqYl5MmnXfRUMy4Mz8jeuGtSOtsp8R0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5747
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-23_15,2024-01-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=770 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401240014
X-Proofpoint-ORIG-GUID: vfO-WNHcgqA5t2fpEHSe-PxG70HwOALN
X-Proofpoint-GUID: vfO-WNHcgqA5t2fpEHSe-PxG70HwOALN


> This patch fix MediaTek platform exit hibern8 and mcq related error.

Applied to 6.9/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
