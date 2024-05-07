Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EC24A0A
	for <linux-scsi@vger.kernel.org>; Tue,  7 May 2024 01:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715047097; cv=fail; b=mVxoYyqQhtV5RaTxLWegprvNGDPgmLjg4akwpBgUMyhOy6sIll7UJ4OR4mKnvVAC2cSFxtw1vCRX1PhzjkJSxXrkI/nvr8XDGGjpKldO1N5YA1G4MKShSml4hTPQBgr+HXsgKCfMqmvyOAcxmioCF6MMn1pGEx2tuKVMala6NYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715047097; c=relaxed/simple;
	bh=UCl+BIaVjJTTqoKCeCCfZ7fTxKoeLi6JTYP1Tra99mA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=eb53rtISwzf98X0p/MoQf441u00QOwMFzlYx38Rn1KGcEULYM2/qL/c71e/bJmrm0W1HbgDo1veIYxwfzIHjuYH5a+gSl4So5zY2gWycEk7tDO2TXzuCWp0h2tN453+cByOnbi/Ae8xufOOAIJznEuJ+aP7antW6p+McaCGvR7M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OpnnPGg5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=n4S8HEPY; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OpnnPGg5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="n4S8HEPY"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446MqQTk031533;
	Tue, 7 May 2024 01:58:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=JPHyBbkKFkTEGYApT0mCO/7kA9UeAJ2g9QtoFSefDLs=;
 b=OpnnPGg57UXmD6Ba3sasifYcCD0qquGYD1q7gCyL5r1qoSvLjVLvY3XNDV2ojw85e+tc
 znHa8oL1yj94v9xnZueBLTeJ3wuNwu3HWisy3o6dnOFL7BP6Z9faJgx2plPJ/NQQzFbc
 coUSYCAmLBe2JmtCD1tpDFSgdmgi/a/cQTdfqy4aqq4SOY9ZU+Bx0tmBH+QnpfzHisI2
 i2pCYDSrXm/aRK8NCtAZZ/Nr7mf+2BNF351jOvBkSp+DeOQVAKdcMZPDUl3afvD00BoI
 FEVpVd1vuZ1udVBkkjgMKkYW6rVsYuTOpYNv3YCKoakpOVA71IXcHXfV7nxKH80flV0C Qw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwdjuuut5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 01:58:12 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4470G24m029268;
	Tue, 7 May 2024 01:58:11 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbfcm59v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 01:58:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVU2IdFewRXUnfxSnDzVEen/adYwSB5+plb+ZUCuoSLm+2ARhVp0+oUt7QAMK6/fMFMbKWgXL6tL30XAgrObVrWB+l8FGD7OibUzJGs7JU07NoJ9Ok2RMuZgdx0jU5TLnA5Y2IYnpiGYV5KlYxwM+KN7dDdn1vonmZbe7aiKUFaswh8wfH1NS5JBoZppmDNtyzhvoPcfzxBVLVYXBAGK5ZweyjLmQ9hpu07JWzU9/MvgUV0lvslE5LNTnQJyVmnCNPTfxIWR4dI3l5I1HRUPj4J2Tm03P8AhxjoqNa0kEArWRqQ/FYkhQiSa4/1xmdfLldJn1lG4N1dSAreUAy0Eyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JPHyBbkKFkTEGYApT0mCO/7kA9UeAJ2g9QtoFSefDLs=;
 b=DwVIPBkUcrTFm8tW5wr+KxiZKMboV7K25lg5+rSGMELFkk+Oi5p1r5Jg6LOvPAj5sqX3RpYWrZZ744PW7B9hiZKI62YtOLYhKVnsmMh9RAJGYyjR1+k168EJRRRlF69qD6Z0qe5Ilsx29rBHONxxhfhLgyOOqThlnC0JxXiAC84dXinmj9B5tQSR6ESygVVvp95CoZf41sIrJVnPnFFnXJy/q1wGFZJw4JVXgy8JamZrHYjsuvph9Huj38498S9H3xDkOoHoMIvWR0raEkCPkhHZCSKbKBgO8bfH9nshKyQTJZqF62avIihibXMMUgAxNHuBo5KOknxt66PNEydfXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPHyBbkKFkTEGYApT0mCO/7kA9UeAJ2g9QtoFSefDLs=;
 b=n4S8HEPYbF11XIIYe/faGmM4zZ0Cob+RNXBe1JU923BPZHbQGkTr1Bz07BvrEw38eFyY2W2ufRG74M8gqLW+GyiusSK0Fw/L916pc5q/ROqNc93HMkWYQvsN88qG78wPhGbXB0g5tX/sCdxHVxaoYHYAfJf8OurEgACrEzzpcSE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CO1PR10MB4676.namprd10.prod.outlook.com (2603:10b6:303:9e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 01:58:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 01:58:08 +0000
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH 0/8] Update lpfc to revision 14.4.0.2
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240429221547.6842-1-justintee8345@gmail.com> (Justin Tee's
	message of "Mon, 29 Apr 2024 15:15:39 -0700")
Organization: Oracle Corporation
Message-ID: <yq17cg6xu24.fsf@ca-mkp.ca.oracle.com>
References: <20240429221547.6842-1-justintee8345@gmail.com>
Date: Mon, 06 May 2024 21:58:04 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0083.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CO1PR10MB4676:EE_
X-MS-Office365-Filtering-Correlation-Id: 4faaabb4-7342-448c-4f67-08dc6e3924b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?zIsq4UCuAWXqHxqyT4v8ocoPxoic+9BI4q+hglZOFS3+tHLR2zkML9SU6Xg3?=
 =?us-ascii?Q?MnUnugp/3cRPV7mcd/EzfZiq7CcYqNG07ZZlFClTCrZO5jIVdbHuf6+OrbUW?=
 =?us-ascii?Q?SG/glEMmyUdwbPLDsC5Oqv7T+NDGEPqMUHfpWPl8EJ99EfIBUQQ6/BeQKbF1?=
 =?us-ascii?Q?EqPuzAOS9UnigzbGmbqHWnSR/erTedXk0+sOj1HJfnboIpeLgje6ZFoFmjst?=
 =?us-ascii?Q?9uKqV92+elzrKIY+qCOpZ9dqzSIcz6rqLf3jc7zETk/nvNAFAEmI/h/ymqEz?=
 =?us-ascii?Q?ceUzfSg8rLe4CgtyEARxEm41xeaU9l2tTECB+t731kwEdjhSJF6FJacxq8VA?=
 =?us-ascii?Q?yH054CAYNNvS7tXLnbJT5IT9DxfTD03OWv2vD+zTCzdFme+lIg14ildgpgyH?=
 =?us-ascii?Q?nX9d0U4cTnyVAEcgHGBpEJQwhYO+YkX3Vfiq92Mnh9IrLF2mQDOjnPVHiQiP?=
 =?us-ascii?Q?CWoyT7HrJOy9ifOezmEGTANKlN99teoJO9fE7dpbh3+CCh9/pk0oQ7RE8ZgT?=
 =?us-ascii?Q?M6ECXrBXWst5a/WHuEZ0xQk2ZoJi9iOpPhByBGOEqByZ1U++d6RvoZkw7Kw7?=
 =?us-ascii?Q?TmmPxry8WcTs8t3S9SDDTvFa+Casu0asW8D3vUT2ZHaMVLdhyv+fJhnEIqQ7?=
 =?us-ascii?Q?W01tSrdtkk69RnwBAAeFDNfkTGCdAcKBhHGPY492+VG1EpTHse3dPTV5qiXu?=
 =?us-ascii?Q?68TA8fY6mspht2N96CDPjVmAgn4WchmoBlGr4DQVKGyxQJfJCnhooLgM/Lgn?=
 =?us-ascii?Q?9nA+/RSxF7F5rjI/4W1WHCnx9HJ4lahkcjGPMsPFU9Bem1TbErIEJBM7TutF?=
 =?us-ascii?Q?vH+yt052t/ucJvmxCYSIVmQiCHFnFb29HkaAwrmxwPN9qj4Cy9bKA+NvBNX6?=
 =?us-ascii?Q?7qxV/kgBPmhdhNEMhvJ4RtGZ4O4ck9DW10aVYXAkRXPoQ0CJDLr8wwttRIo4?=
 =?us-ascii?Q?jjHqPtke9y1e+STm+efsvvgUcYmKQmXZqJplngaWWbyiRrgythVqeg6Oqbze?=
 =?us-ascii?Q?jzOUzDP/uKk8svxnkMN+VqoZOlQ3b2qXTplLGWfp5xp7E4n9mgIUlGLvaQ9D?=
 =?us-ascii?Q?jGSAlx67J5mb6YKP0GdNC6PlrkJoilZsNframr//ScLz4W/7aV4F3pGCmjKr?=
 =?us-ascii?Q?CQt0treAHPrVX++Idf+dW0DyNDkSXzEP7irwpKXwSf8ru9bwUn1e3r/C4utU?=
 =?us-ascii?Q?HqQKXvRqDNOtwBhelRxkhpTzk0HsKPIlqlxCRO9FpZ/L7GDBgG3boBhCDiPo?=
 =?us-ascii?Q?SvASRJ/taUUetmDLWyCMtOFVknb4noXfaCu7fwfC9g=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?/m9Aoip/7p52W58yhPeZQGNrSV8Z6Pg8MUQ2YdhM1W4ZjBeFi6qsRQB2Ytoh?=
 =?us-ascii?Q?62Dz2YLk3BPWp4Vc2t47BhaWqro2Sq90nKx/ltOI8pcnxZdYOOkeJD5yXbVm?=
 =?us-ascii?Q?NR3tltdppTNJLoTSYnRz/VpL4ArNCUAaxTWCuyzzSh/I7MgoCBTVV1qmAQtE?=
 =?us-ascii?Q?zhZKqkT2phCHATIq5BKJk3DHoRqcbZ6TDs+m4HNql6TezxZHvmQxXHJWW917?=
 =?us-ascii?Q?clE/jbejV7FAGHWGM5qj9Gb3mpW5wRdNzM4kbAOvcgoLl/0B05e/Xx0c0BBo?=
 =?us-ascii?Q?q9VQNQJFXaFocJPPfHSo5aK8KhWtI1yOlqgma4iHBfR8bzddwD86G69nXvZe?=
 =?us-ascii?Q?7cPdzaGxtyK1BguoR6jFfa1egQmU3QfmUZ5GdvuLyza659jDn/ES9lryr66j?=
 =?us-ascii?Q?rLGJddTcakW28KbjY2i4bKS9q2U6l0qs5fh/UX7JTtBNeDLqKoFhvfQyhTK7?=
 =?us-ascii?Q?8YWDl67QmZD9I/FWG4c73KZ5xUKZIZvaXZfPGY0jM9/PzzDB5z5BOdJa6bOD?=
 =?us-ascii?Q?nHNWT99rExcgU5RJ9p486CyniEFIQnNPXfNEGtqt6RlRZ0LTyixi83/XnLht?=
 =?us-ascii?Q?qalBzRmPrsjLyt9Hqu4nUOaIOlBIR6QmHKeRRiR4RIWBhc96tZ69a3wNGM75?=
 =?us-ascii?Q?nZ5Lf186BnMQGWO/YXyxnVKwcANLCdmTi6+NdfYcZME2fjgO0KzlCnk/WOvw?=
 =?us-ascii?Q?IDSObjS+WWjjUOfCpPsVQrn6yM1S/x0ROHKpgGQy+8aZ6E8bv8ostJQozcYU?=
 =?us-ascii?Q?pNItwBt3szcwZbgO2w13WmbViOLT/dOocwgcTXXm/DjujQl5nbaAIgejYHBG?=
 =?us-ascii?Q?GWM/UBfURBK4nGiRFeJn3uJS04r77xHDpsI1CrGK7Ca+LKDt7iTigbkATlEP?=
 =?us-ascii?Q?F62x6lXHloL8VdQ+jx5KP5MXCtXBUgtchCDIUH0OSjlXvsN0wps1U9grLOSu?=
 =?us-ascii?Q?f32Tz3hGCTFqOxlYQjEBapk8oAXy24SHGDgceiCu7AJOj7QKVUMOgvGVNVXf?=
 =?us-ascii?Q?isTKJCSMZWhoqucQ0fA1A5MNPFOganXS71hcgrIaBcvCFbn5kJ8AT2PP7ATm?=
 =?us-ascii?Q?/C5rQuLVIv0hK8B2t/XwcaxngzQHNiiTMF83+lnCAEdqu27CqqvADfsnd4P9?=
 =?us-ascii?Q?BFP7kkPmow3HDGsHgl/aLXvqb3evGvZCcgj2djcFE1HrOadrCw4qDAXE2n7v?=
 =?us-ascii?Q?jFmEZeSmDmIsCMIk4AKogLgY5gcFwfQRJE3lSZa+oZlAfh8d0eD6vMT48Ad0?=
 =?us-ascii?Q?uHPJBVmWBxbNeH1PirOwfBzrfLyuUUfJXI2wc/FxbN3JeOdkPMO5CICaCwij?=
 =?us-ascii?Q?R+v5TMXpbeyJP62pBW2JIP7vWaYNfkz09apj5cK5Lgts+qqxFbU+i0CxZTXY?=
 =?us-ascii?Q?JYw+HBvMNny8abUg1MehND78FPoJE4ZnknFOOUm8BNRT6mc6NICQM2OJtN7A?=
 =?us-ascii?Q?V5HMdJDd/Y3cZcs+7QHGNwwUG/IooUu03OGo8jlgzh2e/NOJg+vaErxf8J+c?=
 =?us-ascii?Q?BhDyRdHJhIUazL3Ra5SBM8G8Wl7aIR0sQzJ+CXbvICB+ZGlaz/zSROg1Yy3F?=
 =?us-ascii?Q?F6uwbLqonnVx/EItHDyXhKCFw3/USMmGVmdhF3xIq6cYcYjdpbHMWinKsI5z?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	bdG96OTEzK7HkTSHpm4Y7+rDVeTFppXyJMM5006LYBlpm8csNEHvcBtAgwtdEYPnZsCh3SqQuJ3IexPJ0UZtzhxAmKbc63RFVu2uJXh01F+p1uNTHq+g9AQp2sMfatKY01HMT1RTF8XcT7r8fQYSW9VkOoqtQy8wtTawSSE3wLADqAP3VhoomhbC7Jt4bMOOVYg6h4Xvu+SYe9Cs1ioUa+wysxBmWWxv04aA+w7/8T8WEYpBFDGaADTDV+281TVn2SFIxTUSPJDvxu1mf1poEA+2Y7G0wB8K7uILC734iRsj+5eiYOrFQp7c0RaQUvc596wmZyegDrjjaJl9ibuWA5iN4diKhejYm0eljH4v34F0IIfUgpPo0nDNVapTfbg+xRsyy5LSJT2xzy0ApRb6k+/lEEkmm8iwkvzXVo5KA3TAVDLRiyZXcZ+8DGQXkCjJrtd4tZ0i66DxOGnxridk3f8y6boRLeBDNl53xPxX5M8LrMyDjhp44cCKN62xKcG5tU8R5AzW0r/wu24Mcza8QtkkJt5D85oAhr/XcQWVCxp7wmVo8SM0ZndJ99F2hWRsr8SDMpc0vaSYCVn47ks2NTBKZIwWeVADcykuY9qTh1g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4faaabb4-7342-448c-4f67-08dc6e3924b0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 01:58:08.8436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VEWHk+VHiCCmubD2tgDlHEE3IvbEb+0KkzeOAprS6DYGFWWMDM6yd9O59Fw4N8yYpvSieKx4Gj15nUAqKQ5MvMdA5Qw6blV0RY3ohh4ojAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4676
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_19,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070014
X-Proofpoint-ORIG-GUID: ndigsWF-K54QAcLGbszk7fKPRKBr6lCf
X-Proofpoint-GUID: ndigsWF-K54QAcLGbszk7fKPRKBr6lCf


Justin,

> Update lpfc to revision 14.4.0.2
>
> This patch set contains updates to log messaging, a bug fix related to
> unloading of the driver, clean up patches regarding the abuse of a
> global spinlock, and support for 32 byte CDBs.
>
> The patches were cut against Martin's 6.10/scsi-queue tree.

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
