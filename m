Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54388120A
	for <linux-scsi@vger.kernel.org>; Wed,  8 May 2024 16:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715184378; cv=fail; b=EioiexSAQhsvhKd+LplItyDZUbwnVruhlb+R6e+2QwWgDBIfkWovk1mSg3blJpyOA/RQTfcZ1O+oi3BcmPe/BNLxiNPTAXBQZhgMlJHQoCkWwprTYiSKFVj0sF2xTsWIMENZiTgDmSq+07yhKsK+m8qZCssJ9Ow7rUDLn6TCnpA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715184378; c=relaxed/simple;
	bh=y+oV5wMbhNpGcmN2pQL57y6zORWyHsqRbWV6ObQsifw=;
	h=Message-ID:Date:From:Subject:To:Content-Type:MIME-Version; b=jokAmnfxh2f/2OyYiINQ5u1XZLOiN7imOBgT8wmc3qAsPrEiANQIQ9XZHI+BegOejy3O8Ei7tmC1i6j7e2K3EaKFsefTLK45g+dXYcIMxlXlMwjF4xCrpytabHLtzAbj/J18nCNWaU23l4Qj16w7elfblmNOcI8kPRlg7gkaeeE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E2OuH+Uo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Z9QHZgLf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E2OuH+Uo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Z9QHZgLf"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 448CNuFM025366
	for <linux-scsi@vger.kernel.org>; Wed, 8 May 2024 16:06:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : content-type : content-transfer-encoding :
 mime-version; s=corp-2023-11-20;
 bh=gfCdhx+L94KQBmeeCr0A6NbXMUUgU8B9wwK6muKSrAI=;
 b=E2OuH+UotRub1rlb+5Lv31AuHrCMGdTZg5cSB8DyEBZu/gSMW4P5J5vvbOZhU3+kOVXX
 TtTNERI7QTHhEvK1ZhUKgF/sPITIS7KC24aZidTPS0r7aFoTrL2oZyrY+zgsm12E8KnZ
 lKeoqqnfON3xErISr//NHW6Axl0byPwo+N1VE+k/GyFQ96pu7fjqWX2upMcGmK2Hcdfv
 oDJNiEWuchi+zgyKfHhGhrbP/Lt1+ryDcjHwWUlsQJsErtazH8udPq8WFx6AJpeeYbpa
 oJ4kF/SK8vgpzGGUVAIh/W7OcCqZriLSuu++B00BhCtJxmmD1QIduVNPwvT2rzKWg/Hg KA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xysfvj7sf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 08 May 2024 16:06:15 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 448FmJOJ024308
	for <linux-scsi@vger.kernel.org>; Wed, 8 May 2024 16:06:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xysfnh1cv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 08 May 2024 16:06:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h6+nkGOPfdHENdJWN2ijgUgdNu7dnjIXNxhcuJtOA9lGaZ1/KEhb1zJMh6qQfNy3L537rjOV8qCkKnN6TeLncAR0elPapSqoK453y2vAmq4H/EIvji8oJyW5Pd1V2HgIHbqCkiQhla439TcR6t+YDM3RUYHC3k2au9MPcnraHyUYjHkfAoWUSMWtj40cgBJshhdS2Nwtu0pNfP/pa2THMTDuZE/irbqihjBxgGn3Yl+KrlO/zTkxK6Z8R3OpGgNUH6aIOTewd1AA1l4zYXu4Yv/FPwO5AXNUq/aRA7WHzRxUtxlinkgrBDZ46w/m19glNKs/77Ugn387yUuVneEC5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gfCdhx+L94KQBmeeCr0A6NbXMUUgU8B9wwK6muKSrAI=;
 b=l5tcmGOLt1sIdL5FEINM9dwu03dSh+WskkCfoU+2sydcq2PNKmuhv+lrkCvpYfVPPYsP08YF7sr+4F+x6QetWFoQz+k6o1wkjN/Wdxt1FkEhNzbvDMKU1v29kKENUODikkBwlk9GpyhIf/kGnRpPVLpoSvzrDgsXn89vzwgV6OtiybteC33qSCAV2D+SgBUzjJfK+0AdDyO80FFeUfAvfuRESEq+Oy8fD3PLws6rwsqUCe0pfBEP3iNC7JHP0fKA8jDu9f5zoNa0R2w0UY6xOW2JkOdnDJmkGBRu2bafFL7jFjFPTNAmDdy3Se/MngWo7WrA9vrTh3wvYBDR/p6SxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfCdhx+L94KQBmeeCr0A6NbXMUUgU8B9wwK6muKSrAI=;
 b=Z9QHZgLfpEn+nGYMtHhQCEJh2hteiGcTp1nf1LX9km7H5/7cF+8Lss12TxyD/dYZO5Ku7KDU4GSW2U0A9bV4bJlSK+WEqYgeowXZDsL/vhn/BvKx9fIh7/h2vbncFGEDUOntGfq6LPd9ARk+y8/svKBa0PMYodxWURlCy8+MgvM=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by PH7PR10MB7012.namprd10.prod.outlook.com (2603:10b6:510:272::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Wed, 8 May
 2024 16:06:11 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%4]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 16:06:08 +0000
Message-ID: <e35e1368-34b7-4b3b-a08e-e2292d3a4a6e@oracle.com>
Date: Wed, 8 May 2024 09:06:06 -0700
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
Subject: scsi-cli tool for storage devices
To: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0091.namprd05.prod.outlook.com
 (2603:10b6:a03:334::6) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|PH7PR10MB7012:EE_
X-MS-Office365-Filtering-Correlation-Id: dc0dad97-89d2-4534-084b-08dc6f78c5d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?VXl3ck9UTWkwSE9idDM5M2R3RFpoZUpja2NKWVB6cjJUdHRDY3lMSVdnanJ6?=
 =?utf-8?B?WisxOWpMaWtSb1JNLy9VZTE2SXBEaEU5dVhPeURWc3JzN21rd3BnczR1QXJ3?=
 =?utf-8?B?cXFBQXRKVnZDdnA4aXA1OXN0Z2pJTzNtK1Y0a3l5RFh4ZUk4ZFlIN1pDUlEr?=
 =?utf-8?B?MGQxSmhNSlZNNGZrTnJ6YnBZRzkvQS83ZkNJREpNOW9MQm1UcERHZm4yZFFG?=
 =?utf-8?B?dENrU2V5MzFKUUFjazBlVVUyNWpQcG5LSjRhT0Y0SFYvQXMzUzgwS3pYMzVl?=
 =?utf-8?B?NERoN01iYm1MWkV5Q2FidGtic2hTM2ltVnM3Qmo2MllFbUFPZ2N6OENUYkRT?=
 =?utf-8?B?c3JHNWJhemtPdzcwSDFnK1lwYUdKU3hSODVCelRGRmxiWWVYUkZKbEVxZnll?=
 =?utf-8?B?SzQ3QzJSUmNzQVd1LzF3UkVpS3hWZGUrWjEvSnN4R1NKNUR3ZEVaWWp0VS8y?=
 =?utf-8?B?QXp0RFc5SDVVQXRUbEFrUGMvVU9lNEFlTmpNSE5qc2UvcW81NXVRLythRXRs?=
 =?utf-8?B?YkdUdDZHYUNnZEtlSm1YbWpBMmJJdTBpRzJmdnVuRFl5d0xiekhERmEwc0VF?=
 =?utf-8?B?SzVuL1BJeEVkUEQ2NnU0Tng1UlRxZlpCT1Y2SlJWUWxUOVAxbkNrOFhqSWE4?=
 =?utf-8?B?d24zUEJFZEFVem9sWkVydnNEVjRjTEZUREpEaTduajZSZ3l2cWJQd3BlUFZo?=
 =?utf-8?B?OTVxb2hHelFQdys5YWU1QVZNRmhDVlR5UWZVcTQ5aTF1UURvcVpjeFdzUzhQ?=
 =?utf-8?B?TnpMZzRHejN6aGtSM1c2eWtTQU9yZzhnT1ZDck1Dd2RzNTVBeEl2VHQwVTM3?=
 =?utf-8?B?ZTlFbmlvNWZuMHBQYlI5QnNyMGxMUU5YWVROUTlIQkttei9VclRKVTdwZTFw?=
 =?utf-8?B?MEVXOEJ3VnRkb3hvRXpwUk5IUUEyc1VCTHI5VWRQOXFaYXMxcXJKQ2tFTHV2?=
 =?utf-8?B?aHVmM292YThHY0JtR1luZGJNQm9zTG5sVWFnUVRSb3VhVEY5eXN4MXBYazk4?=
 =?utf-8?B?WTdEbDN5Smd1dC9Wd21KRG5YZm9lWTlyZXhlMk9GZEI2K0dPVXh3V0IvUkZy?=
 =?utf-8?B?OGhJMnA3NmFWd2g1K0dZOVJQM2ZoQ2xydElnWkFaTWNnUUtwaXVKQnNrSlNF?=
 =?utf-8?B?ZzF1cXZPUTdZb3NEZWNFTjFKUytXb3E4bTlxMDBGalhWZXptbGhXZDBYTFVm?=
 =?utf-8?B?aW15QUhJdWJOOUVWV2pFdkYxV2VQUmZFOHJvTFBYLzE2UG9pR2VCUVNaU3Mw?=
 =?utf-8?B?N01iaTcrWUlSVFcwMVVFdm1hWlBEQ3o4eUo4MDVNenNFOTgzQlNYVUtVOG05?=
 =?utf-8?B?TGFieVpGeVUreFNlVGR0ZW5rMlYvcHY3Uk9yLzBDMVIzNWJocVBJWm1Xc3BK?=
 =?utf-8?B?Q2xXY1VOTmUvZlNnMCs3a09hb01TR1A1TUhIQkdRcklkdC9DZi82bUQrbTlJ?=
 =?utf-8?B?TlZkRWY1T0t3dFNBcWkzUUlaUHhXNVlRajNNaHY2Vnh2T1JwZk01Vkw3eVRZ?=
 =?utf-8?B?U3hybnlGLzRGTTc2a25NeVhWc0FwNXJ3KzFJWUNZQUVTSVpCZGhSYThaakZS?=
 =?utf-8?B?Y3B4WndDZHQvR1Z1QVlUcFZONnl0MFhpcGtnQnFzaHpTbnhEaWU5U3RDcHJj?=
 =?utf-8?Q?qeG6isGH9Miz15HEER3hOOjVMlSU6vT6hYDEz9Ud8+vI=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Y0RHR3FmZGNwZW5iR2R6eUNHc2NYN1BSdGJPY3g3L3h0cHV0bVVidFpsSi80?=
 =?utf-8?B?cUJPSkVKY0VjMXBBdGV2bll4UGp5aG4rSHIxSzd3blpFNGJycnpSenczRVZU?=
 =?utf-8?B?enZzUU91bFM3NXdvbUZvNXZVdk5sK3dKSS9vM1Zqbk0wNjR5UGNwSW1ZVm9T?=
 =?utf-8?B?L3FXQUt4Wkc2RS8ycEV0dlRGOUVtd0hOd3lxaS82R0ZEa09KRmVjT3lFemJP?=
 =?utf-8?B?azVSSHViWmpOWU56RTdzVnFTdWg1cHk2cjh3UE1odW1lMzlhZ3dJN1BWYzM3?=
 =?utf-8?B?QmZnSm90UmhOamloQ3BZb3BpZUdmbFd0eitNcjhCVEczVG54NUlJQUFqQTFw?=
 =?utf-8?B?UnE2ZmlnQVJ5YjBCc3lJSUl2L0lPZlZjNHBCQWFEd2hFbUZ4SkpQejdlNU10?=
 =?utf-8?B?NnloVFR1VHVld0dCMjArUnpRSVlhVmx4UzkxcXJWV0NhaVVvOEFJMUtSVU80?=
 =?utf-8?B?ZSsvRURrQjBWSVNvMVhEVXJuWnFvNmJCZE9CSDdPdjVrc3FuRFpnT2xPM0tp?=
 =?utf-8?B?WktKYjZUdldES201VUJTLytuZStKeUFJYzhRbzkxSGljcXJLK3IwSWZUUk1v?=
 =?utf-8?B?MUVRZzBCVkFrUWZublQwV1JGT05QTDRTQWk0Nkh2UytIeEZSWVdleDhuT2NC?=
 =?utf-8?B?dytTMHhoT2hoRk1UOW5sOXBxWisrVUpLalRQTUVzWk5FbVB6ZFFrcTJTaEt0?=
 =?utf-8?B?QXFVSllVQWNVV2l3ZmI0ZHpUUDdpSERwUTEyUVpmQWlTbEQ0VjBqR0hOdEtF?=
 =?utf-8?B?TmZHK2lJd29qdEUrU0tFYnhXVGMrUmFmOFhsTC9yOFo5Z3V3WTZaNGMzMnlp?=
 =?utf-8?B?NHBvd3B4a2dOUWN0S3BWdzV0WHR4bmsxSkdpbENCdjZvMGFUb01zVUtEbUZ3?=
 =?utf-8?B?emhmdE8yRldBT0hvcTZMWEh2U1NibStKTktiVUpHdExZVmxLS0pUVlFBN0Vw?=
 =?utf-8?B?eXhucGZWY3FYbHdJbFZCNXl3QUhoMzlMYUU2L1JsUFFQamZDd2MvalpBb2Ry?=
 =?utf-8?B?NS9lMkc3a1NBNnc0TVVJdXlrY2hmLy9nbFRVZS9Hb0MyZ1hjR05WQWNuTS9Y?=
 =?utf-8?B?ZmRLRGpxb2plQTBnb3M3NFRIRzMvTHc4TW5Ud1lpTlBIaGxpMElLNVFZY0ha?=
 =?utf-8?B?TDN0b0xJay84TXNtN2xoTG4xTkY4TFhudU85ZGlRQzB0YkV1Wm5xTWJKWWJ6?=
 =?utf-8?B?dzQ1eklvdmJERG8wNHVielFxNytHYWVSbFlzbTMvNE01M0J0Y3cwV29GbnVa?=
 =?utf-8?B?czlOVEZ2K3RpbnM1VzN3MEZWK1E4M2U3eFlnbFlkZ3lZNGpabStkbmJIUWZ6?=
 =?utf-8?B?Wm8rTGg3RCswR2QrUDl1Z05PT1JpSHVqdExGTVAvQ056V2w4NXBnMXc2QWdp?=
 =?utf-8?B?UVh6Wi9xdkZ6RW5GWXNRdFl5QlJXOFRsc2dzWWIrSDdvdzJ4UnJucEpGbVBh?=
 =?utf-8?B?cEdyZ1BEYk5EQkErbUtjTy8veVpGREhmOTZBSW45UVB1Q1JBSEFsMGw5eG8r?=
 =?utf-8?B?Z2NmOE9YT2puWG9lN3lPTlQ4b0VBY25rNHkrdnE3K2U0VllFOHlHWFdmNmw4?=
 =?utf-8?B?TDI3NmFQOFJOQWlvOU5zenBPM0ZDQ2w1b25xQkpoUXZQWmplVlNHYnJoSnU1?=
 =?utf-8?B?OTFXNDNiekt5TzJ6eTdSbDF6NWMzcW16MW13OFIxejl1aW5aSE1lalFOdU0w?=
 =?utf-8?B?dzF2Q2JQWHA2NisrOFpNVFRvYncyNXRqb0F3bkhTaXhmNktDUnR1cVpreG1F?=
 =?utf-8?B?alRBU2JxdGFTQTNkeU9id2k1WXpDUUVza0xrd1grYnBLcUplSHkrc2Zuby9Y?=
 =?utf-8?B?eFphME1SQmZFMGIvMFhQRHpSN0hKR253ajJDSTZ4aUhQQjMxVWljYTRSYTgv?=
 =?utf-8?B?OFJGY0J6TWV3WFdOY3dRenZBSVVvVDZpdE9FSUN6R3ExQ2dMTUxObHJtbmlu?=
 =?utf-8?B?enZGSytyVUVLM3cwVkozQjAzM24zQjZPMC81RTJiQVBEWkpFVlpiamcxVWd3?=
 =?utf-8?B?MXJMRXhDV0VLSkN1RmhSeXBITGxqWUpmSmswTjZQL1cvQkpqUnE5cnlYUm5y?=
 =?utf-8?B?VnRZOHJLaWtqZkRBWDNjMFo1djhUVDhteWV1V1czcHRSM05pa3lwaThmdkpE?=
 =?utf-8?B?Uk9idDhuU0l6VHdIMzk3SkZkRDBtdTZiTkNKQVZsTWMyNTdFblI0dFY3QkY0?=
 =?utf-8?B?VEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	iOo6XvkfZjung3f2z1LarVEj9G73ylLGJrQ20rJENxR/1e6D1WthvA97dUsTomZNShGv/873bRqB/CvV3acNvBNo1lM+NhmdUeH0ddYgEFFZZ0z4eRguW0dl7BKs+iqUo0/7X5UmoEKXPZEjUsJ+Ghh1w67xnOpdsL45+dHwww7XDVAeCP30Pc3mHe/qLaQTq6qvzaghu04kzlzB8vEqQHDHNx7P05rIWQH4HkTAEVDxCriNAHq6qxnyka+CpXZs3/Og3OZSBcoQvycFbS+XFHgxmYQR2w8BXUqRasd1q+ryU2mleXL9UEF+15/lGPPZ5fOjwsafqX37wUS3MjpyfYwN9432vXsiC07z2AVmLc+eNvDpGdcnTmeNbfdpOIRg0MnHY46XCScFLN0MHP+jPhhsrnJy1eZY2e5tVW99d3FDvzamAtucT1H6bnYOFDRo5gwH7swQU/vz4YW18MTY34OpFJr8sGYbatecFR/r5SSAsfbY5c6pi025eWNt7VAQF+GfuW+HiIk48glsoUj+qBdNx7njW0Lg9o2BF64Je+WFrvnfndTFCTW9rhpT+Dh2oemqUefwih5WYwf8DlH+W98KInxZppqqVG5QWWcjTtI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc0dad97-89d2-4534-084b-08dc6f78c5d8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 16:06:08.7722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Adz7JpNm1qNzp0wl5Gz+0BS61MYPWa86yrjPOPXi4ssV6i7XCKTjPUREhaCq/VCUAv/Gms8gRGeC0iTJOvqFINs1qqpzApD0q9duMExmG4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7012
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-08_09,2024-05-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405080116
X-Proofpoint-ORIG-GUID: yFRkQVvWhHWDHA_ZXMoQLolVRwUFmQWp
X-Proofpoint-GUID: yFRkQVvWhHWDHA_ZXMoQLolVRwUFmQWp

Hello Folks,

I have been working on the scsi-cli [1] tool to help find information 
for various storage devices from the host in a simple, readable format 
with no knowledge of sysfs hooks.

scsi-cli tool is a very lightweight tool which aims to provide details 
of storage devices on a system in a very user-friendly way. Any user 
trying to figure out devices on the system should be able to issue a 
simple, easy to remember sub-command such as "list" to get display of 
all the devices present in the system in a summary form. If the user 
needs to get more details for a specific device, then "show" sub-command 
with the device type and device name input will display more detail 
information for the device in question. Additional commands such as 
'stats' provide statistical data for the device. More sub-command 
support will be added in future release.

In this early release, I am supporting Fibre channel and Block disk 
devices. An iSCSI transport provides limited information at the moment, 
and more details will be enhanced based on request and feedback. 
Additional transports will be added in the future releases.

In this initial release few commands such as list, stats, show are 
supported and other command support will be added soon. When this tool 
is instantiated, it will display placeholders for the commands that will 
be supported in the near future.

I encourage everybody to take a look and provide input/suggestions on 
how this tool can be improved.

1. https://github.com/oracle-samples/scsi-cli

-- 
Himanshu Madhani                                Oracle Linux Engineering
