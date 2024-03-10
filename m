Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8CE3B19D
	for <linux-scsi@vger.kernel.org>; Sun, 10 Mar 2024 21:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710107975; cv=fail; b=hYCIy7a8ZJBWmu/dTHCfT4jIWhG2HOr7n51GqrNQD6AgXif6DJv5EEv9KTJOFzqIaOHUcZ6Ymy5CVh6X3UIsaB1jpEgewUyGe2YBpiOjsF00GajgL6BBiMpROcmu64hD5lK34EFvffWhPZA89SIsG+RTe65MOlRREPBKY4nrZCs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710107975; c=relaxed/simple;
	bh=E134NDV+9iz5awe/rTxYF84IpKNHvh63YAXMsxg4TrA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=FjC+k0GwAglOF8DuwvFaP0q3f9AaYkzLXIRrP+4mv0n99rWS1KygtyL2hl2nZ4ceG4Z1fKtl1AMATme6gdBupdrkxQt46f/EQYNzdMunUsjyv6kC6SaE/LwUj7DtxX0a/C/jYUOsm5EJuVoTbbs94JkyN+o52VEOSGbRjWukX9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NkLSf7S9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Z2BWsUXG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NkLSf7S9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Z2BWsUXG"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42AJi33K029517;
	Sun, 10 Mar 2024 21:59:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=2ZVX8G+ITGCnaTPTXLEg3NbRXvwv9C63jNAqxs4QuDQ=;
 b=NkLSf7S9QAGrYZzRwaeWY4vjNIHYqCeyOFweaxa1GoXTxwx87C7juCh5Dfl66idj3S9L
 uxRF7qC8++33c1XOKgHS0H6MNmiSWRpgdYxf0ee5v8vRUwggI3Dr8Qu7i9stGgofLSyW
 Zi2ebdJbwg6MWTlAEGbFHnb2EJcbRS/+v0tpNi93Rg/bCh3eRrJuxqh6uSbC8I4bBHis
 LimIurgkz4nT5Pg3emNfT22Svb/WtOMWQSugFVQywxtnuraji1Oj7ZlitQ5Go3Actt+e
 9WWowslUlqBQbjuow7T2796NKOu/HWl36oaEB2KM7FWp8svOhQVt4/MjPEl3qqAnDo+x 3w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wrfcu9rne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 10 Mar 2024 21:59:12 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42AKIQNX019806;
	Sun, 10 Mar 2024 21:59:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wre74ycwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 10 Mar 2024 21:59:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fT8r8H+BHrBkkikbOc47StgmD8gl/OGLbFWgzlebFO6Zaa+6ARPWh2veaRxHMhj9EcZcujpahYUcoQ38Ah9AxZ3VwM+qTQb2cyq295pfYYTHg9kDlYzJxzNEIHJEHujU6XGdhd2OQkDuq0ekeS0q8B0WWuFsnC1i2BduWf/c5obIn98n+VZZWWtBd6iLx2jcAe/i5PweHEONvd6KoyiNLbcNyBEx2ATyVW79Uk6j05CV2WaPmrHcoMSYeC1zJSNJ/1Xok0bUBSkHpIzZ9+7bA9KN8NeyR7GVslZnzoyIH+8zQX3F7cvC0jzLwonojcueuE9U6613XbJbKTH5uKlhCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ZVX8G+ITGCnaTPTXLEg3NbRXvwv9C63jNAqxs4QuDQ=;
 b=nMVKZOAWmTSgPc1kNd5BbJKbIDzpITLr2JagtX47Gy1+C69TDzJeCSIQoQJmrELUVZSVv30gxQ+eoeItJjcDFRggeI0ipKq7xfvMgzYPeeChqjMSCTSrKjfI3OkmzWjEpr4owKMTIM/vUY2anMahETC+dllIdBf5Kq/7stKpUb1pZcnttS+GEh/AYVQsPH+d+R1j5ze2CJQFBIeETqqM6k3cJAqE4W2jIlWoW6eI2s8LgLzPeiGq3kN9089BdTwk64+OlpOWmG6YyHYnOpQA59TJCWSvlp+ki7Na+cfZ0Qw7ET8yIQS+d3f974NQI0NmgJZS9GVtZTOgxslneybBcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ZVX8G+ITGCnaTPTXLEg3NbRXvwv9C63jNAqxs4QuDQ=;
 b=Z2BWsUXGcR7kJKP4WKUIOnddLddDBexsTbEXs0wgbl1nkhdU8jh7ntp/uV01mup1U0GsN/osogUk/301qNd0Opp00OICoo60LUZXGiKYJ/G6WiE7gG9VHpnXKovlfdpxVUobIKNUZibJEKqZFPjXZfhbrH0+kEPuC1QTvz9zg8I=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB7729.namprd10.prod.outlook.com (2603:10b6:510:30d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.33; Sun, 10 Mar
 2024 21:59:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59%4]) with mapi id 15.20.7362.031; Sun, 10 Mar 2024
 21:59:10 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Douglas
 Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley"
 <jejb@linux.ibm.com>
Subject: Re: [PATCH v2] scsi_debug: Make CRC_T10DIF support optional
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <ef5dd96c-0de6-43bc-ba64-05729329ba2f@oracle.com> (John Garry's
	message of "Fri, 8 Mar 2024 09:45:47 +0000")
Organization: Oracle Corporation
Message-ID: <yq1cys1eoma.fsf@ca-mkp.ca.oracle.com>
References: <20240305222612.37383-1-bvanassche@acm.org>
	<cd54668a-8f01-46d8-a597-3dc25ad1ad00@oracle.com>
	<4fbd2106-1e39-4fd9-b0e0-411105e80bb7@acm.org>
	<218b4bb9-ced8-4480-8b6d-24969180053c@oracle.com>
	<2f2c14e4-1a8c-4472-9ac4-887b8b0f2689@acm.org>
	<ef5dd96c-0de6-43bc-ba64-05729329ba2f@oracle.com>
Date: Sun, 10 Mar 2024 17:59:06 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO6P123CA0034.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB7729:EE_
X-MS-Office365-Filtering-Correlation-Id: 35a01136-21e7-4e15-1276-08dc414d50c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	0gTc9rcFyuu85ut4Vlr8dVUvcvSiPFmUDgBurEvKhZTBD+WQR3YGMs4vXKnmyn+SX41zt6sZIDfLQYNbTK1Txig4jNVU4RczhYfLvkTpvPfYJg78/Cn7W/YgD6n00dZBHoCrNT61jKYbRhVJ+yvXaYSnAu4pJrGU/xQ4MIpI1fPYA6Ukuu+UUcsXCdXLLv4D/6Lhhptx48+ZIirPXp1nm+zpli+zpo/9f45qwe/gJ94JIvwEyH/kheDOAniQv1nBxX5bmdhKxvbR2Efm9aWpTvRvY0LEblKPu7XQ/0StakHSAQU6xX0pzym+7VWQi3bHXrHJgNunII6IURTJzQMSswOlLxF2jp1gatAfp2/bTH7K9AkySMyM+icde87Xl9kXvQkaWbhyWf7tVTjxC1sLxPSQ+Pb4c9AaOdzHfZ7tFuAgMa5wxGUKkfhJgYzHujalIFOcuK7yBYY5bhg6aGcRhTID9EVyAcW5268cojCUUWVSWdF6skep+/pixjNnm7Iqwi4D24VXVx4itao+6ouowAI77iuXvbls95CQLNpxO6Isxh1DC82lqnrz+QubIKbPRvxadIpVTJDr+eTmQ+RaMf4Fm5Bx9aC+CRqZySQL3FOTtbi8ZY3LVrhwhmacO33+/oa0waG6o2uZOSDL9kEZmiUt8BrkZghaRxEUqhd5NRM=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?kbz0dh0Sx2bRW7c/ZXoGauOERnv7r5TZFGEGxhTya041jqQ74XPHj55fTdgz?=
 =?us-ascii?Q?SjwgMMRSE7Q4sHRfdN/8p31Cb8tPTHyERfvfCjinHxxx4DzS3pLV9OIvkEaF?=
 =?us-ascii?Q?gX2PUs35Lq3Fzo/xi1YTpe32rZhLYRT81fWz8bNYiVcXVvcuedvHxXddv6si?=
 =?us-ascii?Q?oKGql7Ndhsf5Jf3zYcHPJ2L4GNKxYv2VCSDvZ1UsYqdkJCMnAAbzzZJYpM8W?=
 =?us-ascii?Q?B7LYdrW+6VAG9uDMI9vlXxx8Yt4J8H1m1N8E+EQk0p+u1H1YH+gT9lEMeR+J?=
 =?us-ascii?Q?5oEmsH0bxU7SsN1UfY3j4V1or8QO6psh+nrJ/pU1u8eObG7tB4+qeIECbhk9?=
 =?us-ascii?Q?ntyX1rQ3qIG2BkhL1EfGsitayVu0wh5V5taWhbKew9UYSNnALYFZBeadYIz1?=
 =?us-ascii?Q?PhTFWGfg5ymVKg3Cj8i6NV03jZZh7lCgL2EquuzmEExdNEWRv6OOjT/U8EgG?=
 =?us-ascii?Q?c/pBDOpbzX31xHgFwjdsQbWQeW9b8NBe6qdaobLY8JrVWjFunPe7uXs0M4DB?=
 =?us-ascii?Q?beSS6e/bru0MB0oT874Wlpoty9Jbs+IF9QTqsZoz9aPrhTnHeOg+aVx5O7lO?=
 =?us-ascii?Q?/Vnlbh74df3FOYx9POcFmsFTF8AI5pYudaLTT/nVIkcgG7Q65yXhgv9c6Tu2?=
 =?us-ascii?Q?kX50FQ80TKFUC/dU4Ok3KXpGl5DtnFm3Snapwq5WLt58TYsau+XBQTeR34sQ?=
 =?us-ascii?Q?uVzLzM6aqxXOLCEz0eUQ9Z8mbq7kChoZOGGUsvQDwKAG9EcOU8mPSe5PT2XO?=
 =?us-ascii?Q?D22NLoXp0mB8+1jxgrnYesSkYkxmASXWuR1UknbcoHO6SeSPI57TdWohgjGE?=
 =?us-ascii?Q?QXOxfKlszmWnUFk13CNUxNFODX2sAUip1RGCMFeSsBIxBgzi/RtrCKJRN2i0?=
 =?us-ascii?Q?2NfFHjVF6pI1b2IllDucDfhYC3ttAFPA02jDEmePwM4meMXTW3v8inGOMuRh?=
 =?us-ascii?Q?zghRYM6WQ8RCIIL7vhhtOE7pYg8zJcLr1Rjr5aPGl8u0TSTA5yVuWILTypCU?=
 =?us-ascii?Q?FkBX1cAOdQ8KWFbC9ay83waMs6FSxMuSeuV3eiTrzS4vVNKYJkbhvztWTEjF?=
 =?us-ascii?Q?dWB+RBLTBXDZsBMGCkeQ1vVfvVP7zG02d7mia0gBoKg0oZbAAQ/r12ks/EI6?=
 =?us-ascii?Q?xpYuwx4qQG+7z7wWVEFZkKmWOTxy8AYYR8AsJv9qxwBl+h8IYQwAZQb3Nj0b?=
 =?us-ascii?Q?zqhTFL+iS/0RmYjCDegcUA3dMFeXkdsGSNe40rZ+acxG/+jMzCNvqKeYatgj?=
 =?us-ascii?Q?yZu+f/pxtj/wR6AiWX6MX7+uHsorylRxTh6CPupdPnPrShoT32BNoG+iyAWh?=
 =?us-ascii?Q?dsJ9pXoOftcrlY2zFjDrSsvvhs2PXz77R6YAdhqPvOnFXoobUNAO+6JhnkIU?=
 =?us-ascii?Q?f/myMUytnv6JKwwFimwjr/PGOnccUH+8cYDj2xsn0Gw0U/4stlWKjd6dCcVn?=
 =?us-ascii?Q?eRbtvELxwAtUElLoLfXAOZWWPWKvQLrYmS4qN4GnPHh13pTDZgqF+t7rkCcc?=
 =?us-ascii?Q?IpjvDdECUVL3wz1haA9qzMnxF2QAgbVxHordwyN4RJVis4efxVGqJ9eZwQGS?=
 =?us-ascii?Q?9IDKbu/lZmHOdKgR5TAmi2/crSDfNtwSJjLWSTXDmvqvqxNCELFg6SeSWIf2?=
 =?us-ascii?Q?SA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	GmkjZGx32QFLG2rMYo7B8JumOjIdv6lDxQknjEl9DkElXakonrImwaQ646VoPZCfA5vdBEpcAdRMFg5JZloLqX2i5YMSOP0V4vNAxOUJ0MC4prQvpA+q55ZRvF+5BjNLfyVxtwArzEavIz3JD8TuBbiljOe3XObrAcqpo+K9VrIxIUeJE0+lP3hmKe7GBEpQyog1dq+RR7WmeZVuuIyOEekx9OXhWfk9BkX2GPIqdnsFL3OxWgN95GtE6jGLS/m7Jeyr2HxIAgHtIbRkiEVDlahX122hPGw9Yr5hyj3C0dg45faJ6GbBqxsRmy7fPjYF8HKTZSQjElp6vSmwanCx32pvGSV356RJz2mNbnmYCZuqOGwV2gfjcJNkbsYp6eVJABqhbOTASNn1OQvyH2PIJAv6gr7mwR0ksl6KUs84sHb9wyS1B6Kx+jjDZ9OhjHB/u4Bs4d5OEv7iPKuA/vFA4+p3ghkWkIDNW3D3tV8iDzCLNd930QNln7ITRmbFsihYPqqOSsFsN7ZJeUv5fCxmppXLmBGLG7Mjy8EnI3m0TFn1UNQQ0HHbmc2DNxNd7p8MZvSyxnSBUW29kzbguBJbW+HbtFq1rVwe6zxL/NU5G/4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35a01136-21e7-4e15-1276-08dc414d50c4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2024 21:59:10.4016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5XNoCvi58z21zi6cQw2zYic45qRm+PloIltAjFGKlekSEGPpL93LarAqM+Iv4oSnZ9sTwAN1IB11Uem6SGKoJe3tOEZBrpmU+S6P2BXMVMs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7729
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-10_14,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=799
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403100179
X-Proofpoint-ORIG-GUID: Krl_WYt2-dg1VhqIitrI671sCirfc4pg
X-Proofpoint-GUID: Krl_WYt2-dg1VhqIitrI671sCirfc4pg


John,

> scsi_debug is complex, to put it gently. I don't see any value in
> splitting it into further files, spreading the complexity. More
> especially when there seems to be little gain. scsi_debug requires
> CRC_T10DIF, so let it have it.

Yeah, I'm not sure this is worth the effort. It's a debug driver.

-- 
Martin K. Petersen	Oracle Linux Engineering
