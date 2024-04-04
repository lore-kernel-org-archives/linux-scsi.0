Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF826F06B
	for <linux-scsi@vger.kernel.org>; Thu,  4 Apr 2024 22:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712270646; cv=fail; b=THklouaR5rVRHl0M88oFEn1+Lywrihho6tmu4Wl0HcH7zX8y/mlj3udedVGzC0f4HSI5kn9M9w2hzO96RklGs6BIehR690V7vta3CA8pAFAbIXznhS4pHRBN5Gr2WHsbbV35Zi3p3kTwxTncJGTuyPqXNMsvqkxWTbZNIm53Ox8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712270646; c=relaxed/simple;
	bh=3BQsd+ISd+GIK5lbPSBksucSr1gGVQW2FTqt0EECq5g=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Q3sSpk6UJW9nesde+h6yawoQH2uY1sKoNIbtlDkmTHAR2HnWDsTMXZGnf4JrqoMdlem5xa4/kYrl3TomIDq+Bj9jnCsyPOwrM7cFuZkm9qOZ7WEWfsRkKEqRSjHRJCVgiXTrkPTy9zMpDYqgRqIPMq6Hax73RLjggqpFXP5yvkk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Lbfwox7r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FGJ1/dQT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lbfwox7r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FGJ1/dQT"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 434KxUnm029384;
	Thu, 4 Apr 2024 22:43:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=qCU58vzHhgiIfhwzPwE5T4fTpPFw7Cgp78tiK5yTqFI=;
 b=Lbfwox7rs3ECg2WDb06keaDRbb4c1dv9/YzVOO/HE4R6CObk3DlrIliI5v/l5tAr7Z0S
 3CEFKOdyUIBlINvkNugE1cr3OPsgPOQ0QbMXhpNeOqAbUiwpXKdqDiPt3o0en6SlYsSk
 odJfSKUQ8qt/jRpwF7NFtQ5+3AH0ll6NDEPyMKxaOXuO+QPazmGi2wRFyzx1x8/sPIH1
 l2fHDmeKXvOppizVp/wCq2iyB5hxxUHdlS7JVi0Z9gL3PTRH4uIq9iUEhV5hQlZIzT04
 lx3VjCqqZEsvTre2x31Na1W9mdFHyfwLjGXLDv7hrpKsHCabhnQKQlSx3mIBcnICS4FL UQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x9epujdce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Apr 2024 22:43:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 434Lje3l030568;
	Thu, 4 Apr 2024 22:43:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x9emqd80p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Apr 2024 22:43:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHfsK89o0eJcvPrMtgjN/0oh9HYZ3C3DUtEUTmUfSzXyh727CRgyjXyPllSrw0NqDtlenY39FpeXn1yO2M9mT3ZyBhAJvs3rdiMPQS4a4Y54fCBGcoOyvYNpONGKso2yl1Nr0Hq8Lrl1cCG+PtiS/EaeGw6g52Lr7OotGVCIRofvvI9NoHnp7M/NRj8/Lk0hzhHak9LdJh6dG0aa0vZFcuUExqlAfwahUK05yuaO8KNn4I1/CLLMhkSWla2lbomu4tp9qjBVRDLvptbhEivYBW4xj0ah8ZDtqe/2b9LXRal8AjSmZuVePItTkLm3YSEATxwvD+eENy2itkdmUw/82g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qCU58vzHhgiIfhwzPwE5T4fTpPFw7Cgp78tiK5yTqFI=;
 b=OvRgA6FJiJjGPuUFROHFTWI6MqP/5LW+EkYRttxjOb0yrn3KJM/V5seVQUg+jSHCC54DvYxlkRQuJSxF3nOKlhpAtjhNdc4d/zdjrph6Qvs1h9MIaF+Ai2wedHK5cOfQGVuU4AkiTH48DEuSCFompWUmbu65dJ5wibUXK6V123f5IgTHa+5ETj+XzV8q1sy4RcyXnNsdxK/5aiIkS1HZaj0MIDFGYIG2FFryompQo2o9IIeYdno4SBdjPAUrSXYRf7QIh6lUYYF21CvCeTb6rVEHYH7zIaMIGo8KhQiZDCYRJw7LJVwN4e9eFHVXptJxz1f6kbNNKIU9b2qdVNxVBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qCU58vzHhgiIfhwzPwE5T4fTpPFw7Cgp78tiK5yTqFI=;
 b=FGJ1/dQTpYT3H6iQFdVuVW5XzsmIy87umdwDqbgMh1XX45TXrD0D0RPcbZJxfki2cxIr/4CISGximMHCkVClv8ngtw5EESTa9j0P0u4S0/eIPixJtZEQtDmubCDvn+RFWA3kkIrgyEraFl6rAm72FwQKEv71QLV9VFWLnuWMh3U=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH0PR10MB5163.namprd10.prod.outlook.com (2603:10b6:610:dd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Thu, 4 Apr
 2024 22:43:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59%4]) with mapi id 15.20.7409.042; Thu, 4 Apr 2024
 22:43:55 +0000
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Justin Stitt <justinstitt@google.com>, Charles Bertsch
 <cbertsch@cox.net>,
        linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: startup BUG at lib/string_helpers.c from scsi fusion mptsas
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <784db8a20a3ddeb6c0498f2b31719e5198da6581.camel@HansenPartnership.com>
	(James Bottomley's message of "Thu, 04 Apr 2024 18:33:38 -0400")
Organization: Oracle Corporation
Message-ID: <yq18r1svjk7.fsf@ca-mkp.ca.oracle.com>
References: <5445ba0f-3e27-4d43-a9ba-0cc22ada2fce@cox.net>
	<CAFhGd8pTAKGcu2uLzUDDxto1sk5-9zQevsrXp-xL0cdPcGYaGg@mail.gmail.com>
	<5ac64c472d739a15d513ad21ca1ae7f8543ad91c.camel@HansenPartnership.com>
	<CAFhGd8pg78F1vkd6su6FeF3s0wgF8BdJH+cOUsUdqLmuK6O+Pg@mail.gmail.com>
	<f8b8380bf69a93c94974daaa4e2d119d8fcc6d0f.camel@HansenPartnership.com>
	<784db8a20a3ddeb6c0498f2b31719e5198da6581.camel@HansenPartnership.com>
Date: Thu, 04 Apr 2024 18:43:53 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH0PR10MB5163:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	rJ21lHVC2in2yFvmW+WAUVInBOXFJ65tE30Us243in5jgqhIaNaY6K8LM63qPyIhrsKCnzMzwIFMRCVbQs3CTTolw3dljdVEC93LaXEziIU+B1TmPDdW07U6a5GHKBszQf9N7rxG6ERFDRunuv3F7tSmbtGuYeYhxMP7sqnLT8kDSVaKFXdbEn4wP66nEf9HxAQg+QxIZxaP0w9M2ucKwdCmNtvtX4CPJIiQex6zUAy9E3ZNxflmsvAoXoMPLg6ZCCb/hjYFO6hxuWF2ER26d2x4HXsBXUjc9PYheYWn2NlmRW1CNgClF3qvFlLfXPg346qZjEBLrle/tUhOdCuwjfEH9xULWzSPUyV5nWamZrJeF0pJbA8NTTXMxQUUyMEmdxdJe4psXAWYgba8pdenA5dE6Ub3j27Pvc7KIzKPm242L1mwaMBxXPPw3/3T+GsRdqNVjMfHRlOOH3HxcNneXbQXgOP2DvC8kzJHlaaDtCZd3Gcfh1ajjozfclPwE+qnEFrDLjiBbC/WTTaWTmp7puRZyktQewid2zbWNg5NfJscyGtzdTbVGC80cM4iw3cC9QNxNvZaEbkg0ZM5Sa0X8KRcIgK5r+M0HKO8DS/X22bNcPYLWTJXYLz2jVbRV7NOH3JpjP9mzK/1lpo9dDEuqODjWbCNBSfmiRYyf9qVZH4=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?l/ne9Xjs55mlufPaWe5wPzWItokUAetvgmpHA1JTP/PRGDTTepLaQtvOajKb?=
 =?us-ascii?Q?XFwMIzid4s+Eco+QcWMdnh1lJOQWl2fhh21h08XnlSqr+fdr5LM6N0zQcRII?=
 =?us-ascii?Q?aoirnU410GVG1aqlI0mUjbnvSnHozMXIyjnW4CVVBo0lLHPTUckUJz80Jub7?=
 =?us-ascii?Q?lSZvxJgzwPnwbWlUd0+JQ41j+eb48kSZaHaIEp+wdpGqyXuBI6zSsqrWsoOi?=
 =?us-ascii?Q?iQdVHAMtBU3e1cg1wF4D/5CkBiYZ3/6PiK0C890AUFKTMflePJozk3q3h+hN?=
 =?us-ascii?Q?RI15UItX5NGB6LhszLb7z9TMzlkP/UCDLGAc/lQHRxrKbMuEx1LcXEt82PwR?=
 =?us-ascii?Q?a1tomv+Rba5+BQulrmsd+oGuzrIrBQFtMSGtVLQX+ykiSy/phcposgHCnlBA?=
 =?us-ascii?Q?43LDWhS49seFzd8OQb4MErt75Vro4X3xWEcjWUeMncgcuwXpdsW0r5wpCDFI?=
 =?us-ascii?Q?XrwaZ11toAN37DQ7e4Y2gh5Vv+FBa9M8Zrd8nWA1uMt3CRo8dl2MGMMo5cZW?=
 =?us-ascii?Q?4GTmCMYpqwYxcxnIamNT1wejnyltHY+pHXmR1vpGisxCI+YJvuCPbxDVYg32?=
 =?us-ascii?Q?RCnfAlAgSAZjzD/qYHI+AueTQYXFi8EUqPY9cSgM0WR0kHfGTOgr/zKzzL83?=
 =?us-ascii?Q?3rgOEw0KhNISA9JvFchD65udL30i00HhJekrdDZNHvMMyMiAHX/abcDoOwfP?=
 =?us-ascii?Q?ece3uqwHTukmz4drk/g3JCo01WCLIqWpxrreVYmkj8qG2KrOR0NlfU+vM1yi?=
 =?us-ascii?Q?WH3y6EEEfSqEjH4PEl1ozEX8IKsS6eUb0AEgReTtRMEGbXlo6El5W0DOzCkX?=
 =?us-ascii?Q?UE2wUrVz/UBUW5r+MZ1q5WbYNRyA8tv1VIItwrMBchwTw0zKurt3c599185U?=
 =?us-ascii?Q?dEfmaatfJS1AxOlCx65VjYv11RTenBWP8ZRUimVB0lqdQFmeKNqWs4GtRPcD?=
 =?us-ascii?Q?EfAaB21Mtsrguf9qG2cWETUpmz371nltEAsDKobydMiinX0uiBa3ajz9bhcD?=
 =?us-ascii?Q?ZGbgnV7zT20ae3XU91yPxl7jpmD+Juq9T7vFrT0Rs4Ghzq0rrMLGj1zu+wZC?=
 =?us-ascii?Q?dXIa6wM1B3Nrme0LozSdzaQRg4mat86SxMuhJvuuDsZqOK/gYUKa7bZ7+2TP?=
 =?us-ascii?Q?lP38JCPhCzcPvwod92pEHzNH+SmU4s3fB+F5Eu029oBJ/cwWUPbuvZBczA4T?=
 =?us-ascii?Q?/pnFcZDi3nCXiJ5j5jYS+Fafu+MRf1hrnLIVrPHe/y5myyKz0c25q9ag+gkh?=
 =?us-ascii?Q?fHgbu+vkWp8qWzIQBGWJclTzc5tuqnTIbA9Co0/pVH0E/rfrhQni35d1NEOm?=
 =?us-ascii?Q?qzvppXEca6bU0G6/y9gpxWmFnGaaB695k6T/Dz88MepAmQrNhBF+PPh2AUPK?=
 =?us-ascii?Q?iK6pSNNGpYHYntHt4I8JkHTjq5E6L62VnIj07vcGzTTGbu7X0lBaKi5PTMhc?=
 =?us-ascii?Q?aGwBox85lE9HZJgs9h2VDdUIbpph/D34nWREj57P8y/kjhQuWzzaaIaW4xCX?=
 =?us-ascii?Q?XLPX5eSfJeO71zMCr14V16RpETpY/qARZoRwV46ap0s7n6iVoECY0ziKdf5Y?=
 =?us-ascii?Q?ElN/7+Rg47bQFSFEwG0Rzt5p5HeBU+Bzfij+xSt30Btq8WkWLHy28aq5SKDB?=
 =?us-ascii?Q?Bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	mTOdfQFXkbCUeAi3cisxzk4bBdHXsTl1BaOjCuCOcMvgdPRxDgn53d3dmddZrwFOhzG3wtMdaAi06M+o9PhhOoLSw9OGWWbEdNt956wZ0GbCZNHDg2yzzNXEQy4tHAWgEHdoW0HIwdQUyRI2DUyDoEHpmbEQTigq3w/yf/ByLjApye3hKlRHJaJq+uads2bUXGzs3U+tkwWFK6oJndKzxB7x350B42ANADgJ09F5i/zTaY6b4619lFNRITTmBSvcp4gKLO0tHNFmShloCTbE5lXTyEbZEBwdIGmlodB73JmOUfvZb9ZNBhVKhMuI5F7GXMgPdsRDmu++w/wpw7hLBHldUdel6AE4WvfF59SyM7oBrUk4DAMptX3O9f2fxAh3gEMJKUSeD/Wn3/rItR+LrX8tXu1mzH+Pj4rCZa1n6r1mE7n6laubsUs+ZY4icxaCaIrig4yHD94CJ01W/sp8MzgU1SvpKbBP656BvDatjuWrrgda3plxjkJfCmikbFoA+BtIp4ckDPuMf5y6PpUyCSnCLjWTurJIedADHfCKXN2EbJpMJ2VJ0Az2BbODze/0J1C4g0lGnVpzM5bE1SK0SDC4gF+N2lh7Rg6VoPHAfo0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b35f0bc2-9761-4059-61b5-08dc54f8b55f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2024 22:43:55.2273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BBgpFUMzAwGCb6xUcBEr6sB1pHXDmspCFxJKtAsbIy/L+RTfRTUwc4ZkC+wouz88rsFGjXWIscgIRDqRX5yeedI5eOY/lLQbITToWwu9QII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5163
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-04_19,2024-04-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=963
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404040163
X-Proofpoint-ORIG-GUID: Jsc04G2-oKIxWHtK941h89IwXxl09KKU
X-Proofpoint-GUID: Jsc04G2-oKIxWHtK941h89IwXxl09KKU


James,

> But additionally this is a common pattern in SCSI: using strncpy to
> zero terminate fields that may be unterminated in the exchange
> protocol so we can send them to sysfs or otherwise treat them as
> strings.

Yep, it's such a common pattern. I frankly don't know why our string
handling deals so poorly with fixed-length strings.

-- 
Martin K. Petersen	Oracle Linux Engineering
