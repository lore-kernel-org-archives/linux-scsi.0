Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1DA101F2
	for <linux-scsi@vger.kernel.org>; Wed, 17 Sep 2025 02:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758076275; cv=fail; b=MsW5Y1npgfcXjU5M8HTkVcyFhVKBmmU9kAO1rOr+Na06ckihXn79vBsuzih+vpxuIJthchh0udKNBLYBOqSIeXEVV/8dg+VAB6jE3Y72H0GbV1yF2t9X4Yx3VIbSO7R8atLmRROxOTcRr0xVxVmudIJDYZsrOVIqIfKAF6EEYbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758076275; c=relaxed/simple;
	bh=AWFDHkTZKYcQquErbybPHbktagbvhmfMSso6wFAcbm8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=MPWsyo+X/JRwe65WfSkGY9WDbStIIy4mKGq0N/PqPV/rZQz18wD3a7ob1y5+yxWer/jvS8Pfy6+DjzGS2SfpBTPFRPKlGcIqEDr3KU499BVbdrDPoXWF0xLnrcEW9oNHTodQChDezVQ1k/RFe4KCzN2fvn9p6rUXJ22D+O+dROM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qoR+NT0U; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QyI3zs6G; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qoR+NT0U";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QyI3zs6G"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GLZR5o013176;
	Wed, 17 Sep 2025 02:31:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wqRWc2WO5HbTn5JEQ4
	onPsKbL7oDbRtshKzllrA4Mow=; b=qoR+NT0UWRCnFDKdVEMQQ+7bsnahD2dAVA
	A8yneB9ZVi8OuaexEqhw4XNKtzuLMjU/fhdGGmqXRpuy5RV14KUuPerU47UkXuSu
	rC2iVW0hRYzWlvSMNLUYoUq7et+b0FlPYRPTbQYZ02fzNxpLKphmWofATTVL/085
	5TFV7xj5H2xe4qEWPGy0TfHK53AuLKsjv08t91A4U7HVcbTZYmoWXZ4sten9rhum
	hnhxutDLDrpHAFVlJ6YgB2svKO91ywT+UuHWVKJAFKd8lazB9ceygSZUAt7Elmyy
	XVriWPNe5M2341VLZ2T0MIGZhPEMNRe0e95jU26fgP7EwF04Phig==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx9r9fp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 02:31:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58H0F3cI027207;
	Wed, 17 Sep 2025 02:31:08 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010020.outbound.protection.outlook.com [52.101.193.20])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2ken71-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 02:31:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ybdf2RkaFDovgRsnrao6MuROD2RYiMPcZjc8ayxmTr00c2iQhAkJNxuJwtKmvllBcoWI0UDx8C+uXp2oEtz6jsmGTWv/m/l3NKKG9tSgL7aZHusaYKcO9H7tLcT9UPIcq3fpUiIXT+reiThn3iLFa7qe+PvK5/KK9HlYd5dtB1xwAJuvfqmqu7WlVCteLcMgHmws91NNo1y7CLbySbIhBhGt6KFYOuVp1Nln0gt7/fgsHP5GSheKCwKQlI7kSBWEzTUEHKlf3f566TXdqiAydQvKe2CyEF32k24v6TI2hHCHNUfEOdrvTcj61NCAHuCNsAQjtd1E2f0hfLBBKRbaJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wqRWc2WO5HbTn5JEQ4onPsKbL7oDbRtshKzllrA4Mow=;
 b=fvGDL8HmjLfSSDM/vjub+kzHnYIlOBqa90wR+h5k3IyqSbY6DzN08L0iwE8zkJ5DivxWRIQQHig0mgte61/q5Qo04YPJlAoYWnefs4vnixc+aujQg0oEfdT/byXVVLPy9YBnsjQNrW0O0/MMrgS5z5tpb44Nfq2SolT2FoBM3sKJwpLFYVRv2I39MimqcXKjRL0lOAtCEneRJdXx71xRIxJsTsjnXOhP0TkSxxhkyWrKUst3IceGYbapfb/MlH0qpu5cVQUhFdmN1dVwohE1D+BN60s8NF96oI6RuEwMOMbinMI8EEYDJK9c7IktGHGgZpAtj0YHLnJQ5d6N1Svcpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wqRWc2WO5HbTn5JEQ4onPsKbL7oDbRtshKzllrA4Mow=;
 b=QyI3zs6G7jEfWuqt6i3kXn3mXCbBZF+mR8AsR6n0ek8RMrpy2E5NQaskR/RZFrV2i8yIwYxtWOi31duWQrtBE1JQSmlUhJayv6WJ9yLwtQQfxJQHuG2bhKiZm+WLvPq23ocMrRaxucvNGQwg/COic7IYmNE4+bn4cCqp3Y14lZk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB4559.namprd10.prod.outlook.com (2603:10b6:a03:2d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Wed, 17 Sep
 2025 02:31:00 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 02:31:00 +0000
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH 00/14] Update lpfc to revision 14.4.0.11
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250915180811.137530-1-justintee8345@gmail.com> (Justin Tee's
	message of "Mon, 15 Sep 2025 11:07:57 -0700")
Organization: Oracle Corporation
Message-ID: <yq1wm5xyfnl.fsf@ca-mkp.ca.oracle.com>
References: <20250915180811.137530-1-justintee8345@gmail.com>
Date: Tue, 16 Sep 2025 22:30:58 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0102.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:3::38) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB4559:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a7562b6-cec1-44dd-9867-08ddf5923d5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ynZ0Lzv1VdUQ630A38qyZSCWYQpp6vQ/mFAUWHPXnB297jk2fa9EZ8GXjPRN?=
 =?us-ascii?Q?qHFCeC2KeMRzuDQWuAEOpC/txH0b8BsrWZnK728I+yMoREIXHASxBU94G5wg?=
 =?us-ascii?Q?V2ChUjj9ibNltzeRPHXKZX5dVgEd0kdNBx7jSAQGcdS14syLUR0tchba6LiM?=
 =?us-ascii?Q?CcgrrO84zcTdfp6NcWYsPn7DbAzC2HYsX145+w1fq4mptmEjYLJxPaHcSds5?=
 =?us-ascii?Q?GgRwaseHdwqKbissucWprcVqUW379r7UKarll6v5rCmDlloRPxo6RuIbtOwF?=
 =?us-ascii?Q?IEmdMVMDKk98rXg2HWVFh1e58gCFetWexz0Roz53vtwJILKOYUGLCsi7Rsqf?=
 =?us-ascii?Q?0ZN494cRfHLE7o1IZoZIPuf10Tz3rc0zVDrclq7MMmwK48udrOtJro5Dtl5k?=
 =?us-ascii?Q?/lRb2CzWGDnnDQvqeSGbYy1jVF9wpR4PzBG4+IBQ9ikLWx9fj+DMnXwHM2Lq?=
 =?us-ascii?Q?+a0OqMAL/NVpRnUcM5UoWBJalP60aZ4BcAHKiuN6kl7Ljavxr6zVz/QIYqAc?=
 =?us-ascii?Q?9t1+1LoHkjs8Pj0eN3GiVa+dqTri7bXyHD9KkbgvmiyNhuqhzHPKlPkCFd/j?=
 =?us-ascii?Q?UNLhAxbNa3v+SL2xVfE+nSjkhMZJM7eFHgiIjdSBlvGeVG8P9BGN6m0WDYW6?=
 =?us-ascii?Q?iWez3jXSbZFcLqb69pEPggCF30xmBF8ntrYfRC+z8Ju/oOdf70ZDKxfR8ZwO?=
 =?us-ascii?Q?evatsCOOPA28iKkgfAX1hilVxP4yUoa4DLANZhaHWLV4dyc6ksh6VszDgN6Q?=
 =?us-ascii?Q?ZtOFPw5wHpAwB9ZOQLlMS39xIpGZjcMGk/ukCCQAlhcsrXfkbl4KSVADeVS/?=
 =?us-ascii?Q?cJHqiqnK7ouJ80D8wayYixY7+RbSjV4YgziMTs9j+F1cEHQzuHF5a2sL8PdT?=
 =?us-ascii?Q?S29PR522tk+BsioX3rCsMnyEYQllRTVFDckyIbl33asC6wJDYt56qRm4fEkL?=
 =?us-ascii?Q?62jQs7GhZ6z5qQ8mJC/MxnxjyEIu9HtkYzddMKtcAziISqhyCkr/CXwU/lTz?=
 =?us-ascii?Q?aLftz+Hj8sv8gwQAZTWYu7icSMqexC048SIsi5FyP/tmIFsy63gwcmSraxaD?=
 =?us-ascii?Q?Pis/jDD+4roGH2En/z38i41VPBhrvZUC3s265DnMOtM321TI6kDVHyuGGy8+?=
 =?us-ascii?Q?yyIwQHGg07GZcPlbOGEXBkT4W6ljtlRF47coaQ/XPC7vuDxjbGeJ0ika7aWi?=
 =?us-ascii?Q?gGEXk1t+lrOw6iipBPZ3X7IAwJV1hQLkJiMDGGRogc9bMlpvTyb0deL77W37?=
 =?us-ascii?Q?Abu/YUetaOEjap2e4Ab0bYhiWjHNwu/10EgbXF49TApsInGgNBb2B4akTaMn?=
 =?us-ascii?Q?XPIFjfGAOOIuzqLBSubMKjy6lJW9nGZYT8MhE14zAdGPOAaYx/+++jg0/P2i?=
 =?us-ascii?Q?SalzAds6NrubVtE10rPHd5OEOfX4ztRTKlXcDHkSceIg9yIhNLOPUm7OKHDo?=
 =?us-ascii?Q?EMjLURr3NTs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?29DfrZEfgO+0ZImJ5sVPfAZtZkIEl+4uJOX6cUJlTfFgkuf0ev/YXK76nMHk?=
 =?us-ascii?Q?RgxMxv1gFxB83aZxuIfNsiRnTuPiCglMhpuM3AEqEhpXUI1hsVb0iB9IAvn0?=
 =?us-ascii?Q?PPAvelgnAiEct/hxhRUrxa7VGOTbaPx2Wxnlam2CiijZC5PVyGGW8Cla2Rzq?=
 =?us-ascii?Q?bPJqkgOhWMBRFgmFCqGeHXN1m/T6qi4GKawNKYmLVfymF/YpQWP33zJToF72?=
 =?us-ascii?Q?mesCAiJ304IjV9oqIhVelMOimzW7o6KB+yB02MfLqvAEuNnjYAj93CdYj+Zv?=
 =?us-ascii?Q?w/NGn+qhKjKIPKdjO4uTXGHV2CjNpX7tumS5qsUuTHmEt+AtSOW92KGNPm9A?=
 =?us-ascii?Q?HkmX0To1LcyXwiW0zAbDky7PjxT9NFSxTfNQPQNl6CILP5wdYPDwVdYY7nkL?=
 =?us-ascii?Q?B2e6KKHCAfbP6fHgapEes4jjiVoQ0X22lbkmBGe/zpKqZWB7UrZXYq1DcvTi?=
 =?us-ascii?Q?9bhw/O3lhz2ysjspMxiMTltpQ/p3z5KGxtLkQAY3bgNjx7nDMwNp8qH5a9v9?=
 =?us-ascii?Q?LBpsUoNk4dZ/mEQrO1FICi4epBGiyLm7n3beU6YWcCJ1BCm4KXR4a37+g4Pm?=
 =?us-ascii?Q?x9NA6zZ4YlQdpgW4Z++yBWtm9qbgoXbq2mUjmJ+il+W7oXCheIqmP8wlEXeL?=
 =?us-ascii?Q?1VOYcM2KZfcKpOpaCu115wK4Q1S099gBfLe2E0wHdncydgxfzTHONxl0hbxJ?=
 =?us-ascii?Q?O87u4XhtW0t43jafoTanaXiG8GBSS+M8hkcUbv8lbdQiZN/zVuI4Z7eW5yBv?=
 =?us-ascii?Q?l+mg1BqX2lXnPZYgALtl2DOJS/LhbWe69/+Z6UlHtIzVOnaMqH3JvW5XRnpw?=
 =?us-ascii?Q?FpBtfo2twk7qScQouTOKXnHh85268azb7WCO/0vVW5irP6ltVbI8KlfE12LD?=
 =?us-ascii?Q?ZkdMA2kPpfCK3tkuxkA1I91wYatyG6vDbeMdcjbTu/YlogHTGz0yYLdK68AU?=
 =?us-ascii?Q?zv7CbjYPrczk4khKLyjBPWxFOzhrulaPub4m8yne0QSu2l9FzKqVjq7y/9jE?=
 =?us-ascii?Q?o39BwAgUFLMJhq+oBsMSwLRjg+MtHHlAanhVoAvnQnKPa8pmx10Yh9Vgq4tT?=
 =?us-ascii?Q?oW3nLm45Ro7pj4Mcg0j7Dv9fobHCH2dwK5AcaZtJ/vgsX708Bw28m33S/Ft7?=
 =?us-ascii?Q?YUJZ0YMkMMqg2FT++ZV4KdDK+Nx43q7ZmfqSrw1rFb8PDGl116QS22vaXOVJ?=
 =?us-ascii?Q?BU7wR9dKVhvrFnbV/fOHG0gT/kWK6+dUzPCI8l571rDdQP/JPgMpGX5EIsm1?=
 =?us-ascii?Q?4pQ74aTaPCpsVnUw1dAMWhGuyHt+tfyvhyy0VCBmQrk4Rzl4x5m9vUK/2+tu?=
 =?us-ascii?Q?7y6LZrFs3mIJh8/KoOctiYUqJfZPMK5MN0VaTVrZnmSepePDTN0ldD3Wpi0a?=
 =?us-ascii?Q?2tDlcnOfTzgLVgb6z5ypiL8gMDxRoVI7dHMPf98NG3Y+jdJ2PttWy9/Tpiyo?=
 =?us-ascii?Q?aD7QC6qmZrPJNVhYVlOchBIVMRAZnZzCWMwg+bno4lqnAi8U7/XvpLWEWMCe?=
 =?us-ascii?Q?aK5CMDv6SX03Gu8WnaKFTZQ7hllITYk+VJD6irmGZuPawfULqBfq0/r3yF32?=
 =?us-ascii?Q?phi/13mKeFKebMpHsUUTtVkNY2ZaimqwPdUSSu93AOIUcUp7G3jmVHjPAcTT?=
 =?us-ascii?Q?sg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bcTq4DO54gg+PHrV2uPHd+EY/x2JAaEeI9A9zRRt1WSGSG32vRirlYJcT7hSEg6Rpdng/rwHhcVrbRJvVkx9FTiZhoiF3FDjQRF0Lk72sJAeDyIZBQOgIoh7sSgPaWEE7cXnbO3BjzwBQohFbPiZ05fN2v8nkxIljfX90Q1iLKsYgdDdf+OfyaolDLBcaCYvz53i81HiZpNhJGb5Y32sJlbarEJY7eWujiC4uhlOaxqFPKz4Ft3MtdhXBlHk9ZWAvTpuzJF6x5cR488dwG1sWTV5kqieCfNou5QUiAK7mGDUIv2H2a+UowIY1q3Ok4FQrhIEOgNUUPC4Y99W5euLtYog/RLolmoLjP4t+aZlh/poo5B5RdsgDnZyS4bzQE8U3r84Df0OFQmWTpH37sSweLEyKMtOFrD9dNOmcPk5XPiqOibsMjyWEb+p40l5pW82hdh9RN7x+56k1dZX1eAI9fAHZ+WxRN45GpsxX881uZuafgXE2gYSO/gzX5VbkcukUDX2gVGQoBTqLH11NEtMBxl+Ow28GZdb8xm5KJVSZf7RU1yIfoZlVGm3KykYenJMNsic5dJTDdFYexLUxCRXZDIQLnRar61wlc/nEjzmyXk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a7562b6-cec1-44dd-9867-08ddf5923d5e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 02:31:00.1293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YO2XdOwUhz0pMjyGj4FoU6SCgxvIbe6faiq+eXMsi+/MXOEd3SlRFXui0JD4VHv+HMUFRpF4YLZvb0f1zSiSV+Ow8ijde8IxV/0yhtVuhIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-16_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=683 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509170023
X-Proofpoint-ORIG-GUID: oI_kt0RtnxMSQCACIo1k9BpWlaJsoeFK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX1E1L+erL6Qar
 md6s+eTz3UW8oxjo3XaDQhBLN+e0il5lhXbYYOyUbWF+OOhCHhaMRZWTGu6D/E1P/NNwKE/lq3w
 uX0R3V5jafXoDdvJT3q/CIA8R3h82sb2oiU2pBBLIaY5FJmuzdeePFDuuQqF32wvz2NT4I7JFWV
 CuFVIyodQ0zfExdr88MavvTrU4rcRyTZ9FjqEcAhJeD4l8kbOj3VoS0U88hTZ9yePCCtqwl5Ids
 8WY4Rh5FzfMyh5P7NK575jtaWWcabFdNSMobjMDf2kAC65WgajnHpzXUasIMr6WVKwNPLllJ3UV
 LoJQPkbqMpgYEGDhB4OvLIuweSGQxzRld0ravfrkPMu1StsYsjR9N+BR10Aa1uLIVGqlHqDKVVN
 mWMnL0tQbwJCGY1JzCTHy1xakX9fOA==
X-Proofpoint-GUID: oI_kt0RtnxMSQCACIo1k9BpWlaJsoeFK
X-Authority-Analysis: v=2.4 cv=C7vpyRP+ c=1 sm=1 tr=0 ts=68ca1d6e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=mBL3zNLc6on7ygk0mooA:9 cc=ntf awl=host:12083


Justin,

> Update lpfc to revision 14.4.0.11
>
> This patch set contains clean up of unused members in various structs,
> bug fixes related to discovery and resource allocation, and updates to
> handling of debugfs entries.

Applied to 6.18/scsi-staging, thanks!

PS. You forgot the MAINTAINERS update.

-- 
Martin K. Petersen
