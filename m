Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D191429E;
	Sun,  7 Apr 2024 13:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712496023; cv=fail; b=arkPiImscMKyeM+LiV8IyQfAX/TmSG02wxpirXW9z40ekqkC+K0biY8xg8j553e3cLF8es/kZ48Vv5EeRQAcQ2IHs3gSqr0Kq1gmikXVWujYZFnPe2dAwoxLNxds/HmAtHi7UE4WOPSjhDuV7rAv8ZgL2yRCTSnxki3KqAc2hfo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712496023; c=relaxed/simple;
	bh=WFf9FhB+fg6X2hsmu7/gzohtZDDTjg5TaIewJ2kuWYk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=cJApF/gLbKAdGwd049i3yFaPdjjyjVQm9s+xaJkd7ZpM3fixlfpfD12/wZ9BmbStXNZZgpoWiIzASwdCFg6oprlFobKw9NpfR99HMIRhARll+A0JS9yiw0iotaGfesyhPU6eXN4NgftYBOhcsPfytsCqWnvZXukHH0tA3eiy/6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MOLzeE+z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WW4DM6G+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MOLzeE+z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WW4DM6G+"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 437Bpmhf003244;
	Sun, 7 Apr 2024 13:20:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=/ikt2BOFtR2N4dE9TQUHcoL7ZbI5cpyUzwjGNA9K01g=;
 b=MOLzeE+zyKeQ+UV2PkuDjENZxttl13njoaApmsaHkuCFXaI1miEgUdLmW13LCTFT/s3T
 XCT/4pPFsj7V4lAT89a52cU11KFgYbe+3XaiSimZ8w8D8o0UIijhXwcCIUls708TDjyg
 FN8SNwiEG66aXl5PD0i7Me8sOcSRaSDf9MEPahGjXusFNwCdrwanjf7N/HHgpj//7Ped
 dlvLkk7PyBhIGL+8VCP5wg+Q9p3Vq7UA9YgC4RZmaSQVL1iifkUJ4yki5bDuWxDxro4a
 wRiATeaStsiPYzybKe1FddOBxJnOtJUbAcHcFoZy0cY9Gl4Mc45f6nM3kRGImqC0vfxs Aw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xax9b1570-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 07 Apr 2024 13:20:05 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 437BhxP1002841;
	Sun, 7 Apr 2024 13:20:04 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xavuas529-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 07 Apr 2024 13:20:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rsb9xg77ocvxpP4EQoG71b1x818v3Kf6G0+NleFqH0XaopRZp3y2fkriNAc365vmlIgKJoHPg1xRpVr6z78G29LK5Cc5OEsg35QVn5rl9W9Rf54+SI/fx5yoWHhwR+l3ixrXS1tXjs1o8WWYeBts8I2WH08k9XaxOl9iSO4X3djf35h1Iy7ulIoU0LB3PPhkaOSKSkbqNletJFRp52TI6EGWuO2dOL5FzkdSGj4kEcX1TquCv67Ejs/iA0t9bNTh7y68s/nNYFalqEFVgwdyhAPrvCXN4q0NETtamTO++4wL/kR2VPS4rMOIyYl8kO+1DT4sLtiSkjNFR70AgUS/YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ikt2BOFtR2N4dE9TQUHcoL7ZbI5cpyUzwjGNA9K01g=;
 b=A/SAR4ozd0baVpbHXN96wtw6KSukYR2Ium+JsiThhbXOkQ7y0qIQt2HuRoAnZpWjsEs8dtg9i3CCi5A5Gqa/mSaKhxvm38vYNyxq+Qc4Bjuhtj7Rbtm+ZZfR9fdu7pRdjb8vAEfENXrTYVQccfI3xg23AcNw+WSG0oNOHiDRgMQuA5D4W5YS/F1acbXkAM4QJLysVm5IlzsGZabTOixdWvDGM8YFYEAc0U3HUeTBYHWbCAoyHjwct3q5uZ9AefYdxTcx7YMVjBaVLJCDztsxffvR1Y4o96FyOSTHpTBVUPB18FHlSXIBIWTzwu7RRlLClSilTLX7shT2j+CsK7s5Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ikt2BOFtR2N4dE9TQUHcoL7ZbI5cpyUzwjGNA9K01g=;
 b=WW4DM6G+zkiWM6CP4ua0EmpN9GpA0cT3gsBWNViMS3crnIgOs8lifPrB/Pwa3xHrrPLfvWgvg6kRFIK9UnN2+M20E89R2olH0C+EEMqYIU/95+JJT8qZKphc8lmoCYUUyM4+NZ0PvLlyHIGA3pZNEgjI+vAH/gIAdWAw9RH1NgQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5642.namprd10.prod.outlook.com (2603:10b6:510:f9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.54; Sun, 7 Apr
 2024 13:20:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59%4]) with mapi id 15.20.7409.042; Sun, 7 Apr 2024
 13:20:00 +0000
To: John David Anglin <dave.anglin@bell.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Bart Van
 Assche <bvanassche@acm.org>,
        linux-parisc <linux-parisc@vger.kernel.org>,
        linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: Broken Domain Validation in 6.1.84+
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <03ef7afd-98f5-4f1b-8330-329f47139ddf@bell.net> (John David
	Anglin's message of "Sat, 6 Apr 2024 12:16:15 -0400")
Organization: Oracle Corporation
Message-ID: <yq1wmp9pb0d.fsf@ca-mkp.ca.oracle.com>
References: <b0670b6f-b7f7-4212-9802-7773dcd7206e@bell.net>
	<d1fc0b8d-4858-4234-8b66-c8980f612ea2@acm.org>
	<db784080-2268-4e6d-84bd-b33055a3331b@bell.net>
	<028352c6-7e34-4267-bbff-10c93d3596d3@acm.org>
	<cf78b204-9149-4462-8e82-b8f98859004b@bell.net>
	<6cb06622e6add6309e8dbb9a8944d53d1b9c4aaa.camel@HansenPartnership.com>
	<03ef7afd-98f5-4f1b-8330-329f47139ddf@bell.net>
Date: Sun, 07 Apr 2024 09:19:57 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0045.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB5642:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	ENr3vZgZbMdxoEz5FpOVAouv6RC0JfLbHbOYledDTtqdrSqaT++dNomeZMB0gF4lSqdETDLqCP6ro2po++EuEUrE3Pq0S/43LLwp0wfWTqJdj8EeVczod/S2S/nR87E3oO1RQYrmw0IkzTxd1UjI+2fHWRxyHeCDHnsCoiNdwGYa6/OwtrDGfUCafSp0HSYbvwqsEdNPJy2kgpRb0X+rZhxvJ3/N4PV5g/Tyqz7lbWHh3uWBO6LGnQHAnWuJjGanyKzg5C9NlWcuOPnNov2JIpI3/+fNURJiKGGZNoU/N9BVMO1BdJCBwDQ76BGEXNCM1Ofezx1V9yfxnIR++0JZUOSdeFEqLrUotXEcziK69dOnf8xZwaM2oOPLc11ybc/X4LoBVyvAVLXCuCOP+NZ710i8aSZ8oF5G2Co55CKNKXFR/JiwmHdxe23IKIat/1Z52HGf3542I0FjnLs0+Xn/pUgBkU0ELDBweGyY429eh7CMrlcOOHKoK0sIEIqVNmVr4KLAG/R43L57mnRU9FPWywNf7Y6yzUec8Jx6Mu6V8wTIHgL4IZx4SJANnsaWiGP7cE6ocPCQ/IIuPlBcPnHbSV4KyApoTSyC1DF5+ZbDrbV6V3M+OET97rVfrs347yvN
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?fyRjcugTK4jbclECHkAO4HUSCL+/0PXBWs8k2+L3xf27kAvUZ7bQQs6weZef?=
 =?us-ascii?Q?uK++zzTLb+SsgYl01SwZC1pRlKGUPXMvWt4svy4gkYqM50zEofQR3ex6rCBG?=
 =?us-ascii?Q?lOdmQ9KC2DdNOt1wggtUPOeekgGUAJEnrmBirC8hNMMksjrvAqB2AbLGLghR?=
 =?us-ascii?Q?YVMmIkQZMCYBWc3i9iQ8NiR4ZhsiXbLS2lLGuvTNYB9+zn6e1Str493IOba3?=
 =?us-ascii?Q?j+WYkZTRVamfTFubz1AOFyOcdT3md55j/GLZj9TbKwcJlH5XTtVGB5Pvtzce?=
 =?us-ascii?Q?aSlIcQzWfV1zmLfxwMNmpviU0TpXFzifl9ZhCfsteYpV4C77JpoDUFYwCjBK?=
 =?us-ascii?Q?LgzNhNltKHP45/ddMOHQ7ozOE63pN+jn5YbhxFPStR/L6/nX82ggbfSHsgKn?=
 =?us-ascii?Q?1ofJSwTM4/nfsPOE+BDXnKlMApM/a82YlHwcBQZVh9NRREA5KvsaTZVadvXr?=
 =?us-ascii?Q?XWpezof8v0bEaFJhdHPkTnz6N6EsWqJ1VMgQhKk7bhUUusFhvM3+rYjdoQRj?=
 =?us-ascii?Q?qJB/Nfq+lNLTl1GbUSp5N7WeQAKnZW1jk0fOB1cWd/nQn8iBZvKfLjMUbtIh?=
 =?us-ascii?Q?Ppkqa9OfZpKfYAW3cEKErSG/jOTK38VT7hgXpV6UPnl+nbZMIyksEafU4oJP?=
 =?us-ascii?Q?wDjXUonlydbcUTlIfHOPuWsL0NK4jDTAmlWfotu8BgWnRnMI2lAsFK1nRT2/?=
 =?us-ascii?Q?LcC8mRSBtXP/bhrmV/0b9IDaRZcVhlh1+McYPxmN5vz/WwrrC9XGqA3rUTv4?=
 =?us-ascii?Q?Ni8U8bW7U+IlD/ljLsqNw//vgLpSOetnTk3RotPaOJ8jjrNeJzT4nwA08s5E?=
 =?us-ascii?Q?cKdzwBDOBSGyU/hnvZtFX70bYtyMQsBJzPds4CJrK1cXoJn0PYUm5Z4qPNFB?=
 =?us-ascii?Q?owgDLu3bcx1ORYL8/188Sphh1o7I65smVk1ipO2DVSRAkamXsUpHXrhZ766G?=
 =?us-ascii?Q?KgGmGBqw7HwL0KEw8FOZyjAAIlmbcKGM13qycicqGcaZOSdnK6XMzR34bdEE?=
 =?us-ascii?Q?E61U3Iben3rGuL4hoN4CuExRmHUrKd8SjceEEEB0y9zphtWC9UhC004TH2Hn?=
 =?us-ascii?Q?Xf2e2CrEjLwDWlfK7aBM3zm34qxoffdJ1hSMOFlZISvZJQIgVXsBOR6JYSDg?=
 =?us-ascii?Q?TVvqWbE8Nz34o03JkCg7iBl9OQR1aZhNPLKe1iNoZFXAnD5yHzz0t98+w2Aw?=
 =?us-ascii?Q?X2DD+m2kJYh+ECGw/h0wOE2dFQIMk592PwA5KzEKvyauwROHwd+OHcbUZGFb?=
 =?us-ascii?Q?u0K+60orCnQ+tmlB/+piBHKs5CWW7vMBcg3c6V53JwktzuS2yIzP6StTKtDb?=
 =?us-ascii?Q?qdx4jvSe6Cgt0Sz93nElw+N9CPO8rDghzOh/tlKl4wI+aKKQk7YXJC6dST9/?=
 =?us-ascii?Q?Mq6ruh1llqR2h+dB1gwV8QXvVJ88Hzu0DeeW7m7p6/uDXza5+SSy5Jrc4e4q?=
 =?us-ascii?Q?RfpCQFLIOxkgb6YpnxVnoHpIuVvbX3N8VB94brqOw26AFvi9UA7P/iPVwYs6?=
 =?us-ascii?Q?sY+uGvOKg+xwPxtXXBqXwK89afvqSK5/HhaNKoIgoIL9/mS5HOg3lRXJjltN?=
 =?us-ascii?Q?tyaZ8koEWTHN8+ezzn/PYiJXocpgn82bQTc5ORNwgg5kAfhSjUhLLoSkb1ql?=
 =?us-ascii?Q?7Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	jN5I0dHuGynKSgGxZfOiVxTnFg+1+2z/fLiE2PaES5A7E/O/w+R/IlW/FtVx1tVDGEUMLXiKUv+cGo7+IOpVOGLdp6er9ZuP1LKU1M3TGcVSP3fo9KXyvH+Q0rQgFvg3tUM+6bxNTTbi7kOAHy/shE9KRnikCzOvLHk1pvPEeqcUrXvGRwEgxXSfEtMrOqiXhiQ+p3+wWuJyWAAlcP4yuns4FMgGdDGtqWeraU4sgevV9WE8JC/fw2sqQWAb5ugDYIgneenLLZNhXbBAjXJCl4nlmdmrigr1RQmHmmX6v8rrQlu6UU/4T0lMH2j6OaWzvths/HCyN1vIs+NHCF8vmFoFgvGOSZYAa37dpfZTxcGF1B+LSgC5jZCnuOi5EUCSrBzSlZZk/zh1SbZJTT+hb12qfplIPwH1xQ8rssJhYjMfflVYj2JcAJd4EJnf715eeRwDMYHlRmHRz8l3YINe0ATvpncPONnOv+ku5r7y489N65VRa1XoKi2tpOuXannBzXTSHrNr0ojMUnhZhqJzDoMlMO6zGKT/Enka0Vk2Y3HwvDw8G5s4bs0pil6/kiDZ6eB5iUFYibzG+nVDHOiL/cwM6kZI+vXzWy7jul7mv/g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e84d5011-550c-4ce4-561e-08dc57056d44
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2024 13:20:00.1640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dqRvvuiaStj0Atl4AAbrg7YhHkxLQgSqHzRnJ1ZaMK6rxoxmeVEYN+JcFcbQ6xGUMJt+IzKZiDDxDPiN0l3YbwGp77uoBtaYUZe6CHWxyZk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5642
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-07_07,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404070106
X-Proofpoint-GUID: ut1iN2m_6Sz5uTHpke8fC756pxsn99L_
X-Proofpoint-ORIG-GUID: ut1iN2m_6Sz5uTHpke8fC756pxsn99L_


Dave,

> This change depends on the above change:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-6.1.y&id=b73dd5f9997279715cd450ee8ca599aaff2eabb9
>
> Thus, more than just the initial patch needs to be backed out.

I'd really prefer to not bring any of the intrusive scsi_execute changes
back to 6.1.

Could you please try the patch below on top of v6.1.80?

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

From 87441914d491c01b73b949663c101056a9d9b8c7 Mon Sep 17 00:00:00 2001
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 13 Feb 2024 09:33:06 -0500
Subject: [PATCH] scsi: sd: usb_storage: uas: Access media prior to querying
 device properties

[ Upstream commit 321da3dc1f3c92a12e3c5da934090d2992a8814c ]

It has been observed that some USB/UAS devices return generic properties
hardcoded in firmware for mode pages for a period of time after a device
has been discovered. The reported properties are either garbage or they do
not accurately reflect the characteristics of the physical storage device
attached in the case of a bridge.

Prior to commit 1e029397d12f ("scsi: sd: Reorganize DIF/DIX code to
avoid calling revalidate twice") we would call revalidate several
times during device discovery. As a result, incorrect values would
eventually get replaced with ones accurately describing the attached
storage. When we did away with the redundant revalidate pass, several
cases were reported where devices reported nonsensical values or would
end up in write-protected state.

An initial attempt at addressing this issue involved introducing a
delayed second revalidate invocation. However, this approach still
left some devices reporting incorrect characteristics.

Tasos Sahanidis debugged the problem further and identified that
introducing a READ operation prior to MODE SENSE fixed the problem and that
it wasn't a timing issue. Issuing a READ appears to cause the devices to
update their state to reflect the actual properties of the storage
media. Device properties like vendor, model, and storage capacity appear to
be correctly reported from the get-go. It is unclear why these devices
defer populating the remaining characteristics.

Match the behavior of a well known commercial operating system and
trigger a READ operation prior to querying device characteristics to
force the device to populate the mode pages.

The additional READ is triggered by a flag set in the USB storage and
UAS drivers. We avoid issuing the READ for other transport classes
since some storage devices identify Linux through our particular
discovery command sequence.

Link: https://lore.kernel.org/r/20240213143306.2194237-1-martin.petersen@oracle.com
Fixes: 1e029397d12f ("scsi: sd: Reorganize DIF/DIX code to avoid calling revalidate twice")
Cc: stable@vger.kernel.org
Reported-by: Tasos Sahanidis <tasos@tasossah.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Tasos Sahanidis <tasos@tasossah.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 31b5273f43a7..349b1455a2c6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3284,6 +3284,24 @@ static bool sd_validate_opt_xfer_size(struct scsi_disk *sdkp,
 	return true;
 }
 
+static void sd_read_block_zero(struct scsi_disk *sdkp)
+{
+	unsigned int buf_len = sdkp->device->sector_size;
+	char *buffer, cmd[10] = { };
+
+	buffer = kmalloc(buf_len, GFP_KERNEL);
+	if (!buffer)
+		return;
+
+	cmd[0] = READ_10;
+	put_unaligned_be32(0, &cmd[2]); /* Logical block address 0 */
+	put_unaligned_be16(1, &cmd[7]);	/* Transfer 1 logical block */
+
+	scsi_execute_req(sdkp->device, cmd, DMA_FROM_DEVICE, buffer, buf_len,
+			 NULL, SD_TIMEOUT, sdkp->max_retries, NULL);
+	kfree(buffer);
+}
+
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -3323,7 +3341,13 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 */
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
-
+		/*
+		 * Some USB/UAS devices return generic values for mode pages
+		 * until the media has been accessed. Trigger a READ operation
+		 * to force the device to populate mode pages.
+		 */
+		if (sdp->read_before_ms)
+			sd_read_block_zero(sdkp);
 		/*
 		 * set the default to rotational.  All non-rotational devices
 		 * support the block characteristics VPD page, which will
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index c54e9805da53..12cf9940e5b6 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -179,6 +179,13 @@ static int slave_configure(struct scsi_device *sdev)
 		 */
 		sdev->use_192_bytes_for_3f = 1;
 
+		/*
+		 * Some devices report generic values until the media has been
+		 * accessed. Force a READ(10) prior to querying device
+		 * characteristics.
+		 */
+		sdev->read_before_ms = 1;
+
 		/*
 		 * Some devices don't like MODE SENSE with page=0x3f,
 		 * which is the command used for checking if a device
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index de3836412bf3..ed22053b3252 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -878,6 +878,13 @@ static int uas_slave_configure(struct scsi_device *sdev)
 	if (devinfo->flags & US_FL_CAPACITY_HEURISTICS)
 		sdev->guess_capacity = 1;
 
+	/*
+	 * Some devices report generic values until the media has been
+	 * accessed. Force a READ(10) prior to querying device
+	 * characteristics.
+	 */
+	sdev->read_before_ms = 1;
+
 	/*
 	 * Some devices don't like MODE SENSE with page=0x3f,
 	 * which is the command used for checking if a device
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d2751ed536df..1504d3137cc6 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -204,6 +204,7 @@ struct scsi_device {
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
 	unsigned set_dbd_for_ms:1; /* Set "DBD" field in mode sense */
+	unsigned read_before_ms:1;	/* perform a READ before MODE SENSE */
 	unsigned no_report_opcodes:1;	/* no REPORT SUPPORTED OPERATION CODES */
 	unsigned no_write_same:1;	/* no WRITE SAME command */
 	unsigned use_16_for_rw:1; /* Use read/write(16) over read/write(10) */
