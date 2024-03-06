Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED2E1E519
	for <linux-scsi@vger.kernel.org>; Wed,  6 Mar 2024 13:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709731186; cv=fail; b=uL4ynz9cwyVzrLYOl9gg1B87Y8RSB3z1fkhue6vqK3yqP12hS/2xIMXlqAzvUDWZEctL48JhyWv/XvhepOd19XKSsTWyaXTLNvHML63DasCrms/bIqV4YywWN/tPklrhHTNdE1KYQlJFp7z9sAZ298+v66X1RjXT5xzE3BLqkCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709731186; c=relaxed/simple;
	bh=7ysdYV5XCdeqwxlIfJcUBVEGDOgzRaYD235vTgLxRRE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IBqZjhuPAa0aK4FlHzOtIHSqLCDpNheZFNVhpGBdRogXhXqun31wbopIV0ye9t1CWfq5HGNN98n5TDdkkAmxaPWNL1bDcGDoWns1bOLqHhh9E0JWiQnaVUkpiqvbbn5FVyc1yAV3fFav5pk2pNpCuIW5s8nkDvMY0OHKvp2Vb2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ScfFVDvZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ysHDDnB5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ScfFVDvZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ysHDDnB5"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 426AWx0V026788;
	Wed, 6 Mar 2024 13:19:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=DIkNtEYjLwuQIwTOByAH+lf96U1TED2/a/vImtAfrzk=;
 b=ScfFVDvZofcvsGDSFQb5haUwsADxMFJh4lcjWWT9+/k91SzLJzYpjdl/r+Aznxl7VbHu
 y6CRk9JwzXsMUR9l+/JsGgyuc+wpJ1bI3CnTMLWa9uwzr/YqHKs+PAsAhKffM1gPfNDk
 ezc9bAl6H3F/8b7+wrBbOdEzJZ6sB5cSlANzWxgT1G9ISxfgjjthg236p0TRk4pBk6ZR
 64/4UW8GqBN9NSwCG+tvMa0xLnLQjuxYrrxRKcB3LdE1vwOUEw5WMNmXc/ID9z8+hcWM
 fP182LSvBUWVnlKnOnInDhPgpSI6KY72RQRDsjuUfw7vvCl35B5t7CzGv3Mfe3meCyw6 8g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wkvnv0wt3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Mar 2024 13:19:25 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 426C1WgI027574;
	Wed, 6 Mar 2024 13:19:25 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wktj9ufcb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Mar 2024 13:19:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hvj4HMguT2Kd0P977Oy2auMaOxspQSoalcZtZtCOtkQW6i9UgGHcsrIai0W75Fa6yysXK/ouSGJljinnqmbUy58yIWJEu3nlmtQiu45H3wW+6k189vz/OQy+khIVHf8r03GvO5HgvNgUHQ9h8AL6sQOOr25e7U3yMOWIeqvefTyMlEFdvw399ksGQLK5f++YIMaDI7ufTqCqdlbhERTkJfW5+g+eorQVZsAVvOwcMYOzYs0NdEr4FginF9D4Z1pKJxg5CtM+RjyN1eaPjoogT6yQPyiWtzHJjG1ufHKbXhw/rvk7ltyyGvfI7NMVgmpUCApCwT6JINQD3QQM3NY21A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DIkNtEYjLwuQIwTOByAH+lf96U1TED2/a/vImtAfrzk=;
 b=n8z/JkJTDOFYlNb9BuEOWMJBiy511NcaZHIJz9cw1k0yksHS6SOE7yVCrQhur2xiYzyT2EjZkXNzLr+52r6FVFtY9NUi/vJwmlkWC9+/AKvemrgtx+OkgTxMihrPWYIRQl5EyjAerKfon4D7a8xaw8cyFzJVUvIEL/jT0FWzynpEosP/lrcpgbksbXc+iGSpeEgvD3Rrl3r7pX7dIpg7sB6iTLPszWBhd2bXMtb4F25thX7UWkyYSOdiIneQfz6k4/gOYhvnhTHXlaQx0CKdn3BtAKpCPrF0J2/foVuUXrB+hPAIklarj+tFzcvthk3NPQkm4gnpRNtBi5iDkVlPuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIkNtEYjLwuQIwTOByAH+lf96U1TED2/a/vImtAfrzk=;
 b=ysHDDnB5qlIMCkc79XThlVVztA31AxHrmUNHME6Iw7xkUON4GUPuklocD1TQrvALBtxFG3rHLhAJduwr7v0oxUvt+rT+qYGLLx912qrJYbi/OW1UgtnTyfbCacPTuLD3+xeWhV8NdwlwcF7twuIq4OERSDpTTS98RDssm7KP5Wo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB7359.namprd10.prod.outlook.com (2603:10b6:208:3fc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.40; Wed, 6 Mar
 2024 13:19:22 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 13:19:22 +0000
Message-ID: <cd54668a-8f01-46d8-a597-3dc25ad1ad00@oracle.com>
Date: Wed, 6 Mar 2024 13:19:19 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi_debug: Make CRC_T10DIF support optional
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240305222612.37383-1-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240305222612.37383-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P123CA0001.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB7359:EE_
X-MS-Office365-Filtering-Correlation-Id: 32669001-ab30-4bad-8f5c-08dc3de009c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	X/Brh0ho5wsEAl3mZ8ETwZd+kBbw+SsAT1jB1ys1Jcvyy6kF3zncTzpxI6evD8RjG8aEpSvveWTRHeSs23nHtp61oymH2hN3NqMFnAjMA9OD/wNnXNgmWPo/SaRuJywQ0jgDk2rsL16P1S0FRmj3cp79NR3sYBGIVqw4kU7LnrvcEGK4cDAP8goIQf/7Hggh5LPJtcHN446mqBuiqkworCKE17feyRKdISsKWT7F5YeEpPTnjMtLojc+KoEIrPZqE3JVmMASkzhvfqAibKulPm2sUogLPEmHBG8/VNDa+tJpLvmiWz7arzowiHqgdLZkeC6R4jeIQ7j90Wix9GAJawwEk3DwpOx9nz3hIHfjtVTkzF3OfTZluJ6k5nAbNM8xI8uVi/b+4XFhUPPVSaYn/wH86bBoK4Iz/fDqTo3jBHk9+te0pkdr9APuO/hCVLpqtLb3ShzrVuc+t4g4pJvMakeOCYLncc+bvKtzIohWPjRaqckMOiWXSh/3PUSd/wTNmCiYQnxobTLuwJyR7gN9UiFZdrWTwn+ZiMAjQV5/7G9GmHEyXhgH3hg07m9Lf7L+RJiCTrH19Iyt5T1+LOWX6A8JBlI3Oyrj4+N5qououhDTgNqbHehg9nw0BLut+b8JGbl5chyEX1Wj+roF/9DzT+LQgKrvynsXGFFifM36HZY=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?L3JSOFF5TlYwamZZT3ZCN2hYcnMvUnpiUk0vTi9TcFNtSVZGTkJqanA1NTBp?=
 =?utf-8?B?TTZiV3NTS3F6M0lWcEdwNEl5cDdXRFd6SGJIdmpTZGt2K1ZpYTVRWERYakI4?=
 =?utf-8?B?bEdIanFvYWtpTkxjNXFyRDdrL2tUaTFKQzJJWnpQTFhuczJTaGhwTm5nY2Fv?=
 =?utf-8?B?WkFPRXZGbTRPdVlCOUI2NzBxTUJ0QkNHT1NtM3J1YzQzemthKzE4Wi9RTEx2?=
 =?utf-8?B?NzRoNk5seE8wY3h6RHduYjlNd2NsemZwbnRaWVdrWnJwMG9TQUlCbHkyOC9N?=
 =?utf-8?B?S2h0czM1Q0JjYnNJSlRGWHNLbWs4eVZpcksxSGZhTHFsTmRnMmhIMEhMTVBS?=
 =?utf-8?B?M0tZN1k2d051M1J5MURDczc4QTBBZDR5MkhTbitwdDhPalI5cFJrbXlnanpw?=
 =?utf-8?B?WS9McWxwSHFTS3AreUZaRnNtRTZjaXo3emhqc1g1R1BqaVBXSDQxN3E3RTY0?=
 =?utf-8?B?ZHZ0WVJuUHNGNzVMRW9pWi9adVZjcTJLckRuRGRDRFhhWE1FUUkzZ3IybGxu?=
 =?utf-8?B?WXFReWtNZzAzVlZUQUhUNXlzV216MS8vZ0ZGUWR6QXZmVml0ZXNLNGFRR3V2?=
 =?utf-8?B?bFZnbXRWQlJ1aG42MWFST2tDUlBVN1dNaUJ1dld4d3RYTG1ZMmwzcTJDdUZK?=
 =?utf-8?B?ODY4SGhmRVVINXJFNitJM2VNeE5wK25XYzRWTlQ5bWVIMWRDSUgrOTF5Vm5x?=
 =?utf-8?B?ajRWNG5BWWNRNVhmbU5QUEhRNlV6VlJoUzJGQ29LUWpyVVhTajRkYnFnWGxT?=
 =?utf-8?B?ZVI1bVlNckJJWDd6N0c0aHIwVzhLQWptaTllYUNRTFArRjZvTE1OWWtFaWZV?=
 =?utf-8?B?M3Iwd1dXaUIrcDcrVWpYbGJ3WDFaY2NWZDBGNGE4ZzdBeUJWQVE5WWlHVmVH?=
 =?utf-8?B?NjU4VjF0Rm92M3EzVTBNaThNREtGU0NjZjVhdjE0YWMzVEVWSWFxV0JmdVhN?=
 =?utf-8?B?Y3c2QzhiTnUxOFRJOG1WenJtcEpncEhPYlVSa0l4UnlZUGs2YkFDVjNSYVdO?=
 =?utf-8?B?WjlWWWZQZGJOZDVhZGVjTTR0NlJkUFRaU1BxVXVmbWs5eGNsSCtpVERhYUNs?=
 =?utf-8?B?L3Y3OWFlbVJEL05RRTE4YW1UMUw5Q25LR215VWpIbWh5eHVHVEd6S0toQzVu?=
 =?utf-8?B?b1U5Z3BiUWgrQ3ZERUM2dnM1NmhNanIxWmh1SURlSER6dklpZXpNdFZQRGcr?=
 =?utf-8?B?OFBSdFprMnBFbmVXYjMvVXFzckkxZTFGYU5CMWtMY3VWOXoydlVhVndDODA3?=
 =?utf-8?B?S2ZLamdYdzJEb2NVaU9zQmJBZWNYZWhBZkFHdWxRT1NpYS80UU9LOEhEd1BI?=
 =?utf-8?B?K0xBQ1ROczI3ZUthai9lSmhJQTZoRGtEZHlZbzlrcHd1STB6SHR4RjNMaTJX?=
 =?utf-8?B?SU1Od0E4bk1uWkk2VDFDeVJCd3p1b0RrU1pYaFpoa2ZvcjhZakZCSHdjTXRm?=
 =?utf-8?B?RmY5eDdjOWNoZkUyaWlZYnYyOUlUVitWbWVNYXNrOFBadVZGeHM5Q2RCbzVK?=
 =?utf-8?B?dGlkMTFVaDMxV2NyM3J6RStkOW53Qng0MUdhZmkvekJFdGR0M3Ztd291bzVV?=
 =?utf-8?B?YWYzdGFUVE1pU2RqWStjNUREQVFKd0lhdTZETTVZYTRqUGt4dTZ3VjlJRUpj?=
 =?utf-8?B?WDA0ZFZ6SWZHL2FFWnkxRGhzeWUwZ2txdi81dStpcWIwMllldXVXblZraFoy?=
 =?utf-8?B?WmliSkNUejhXelhhVHlkMmlyUzJsTFlneWIwbkIyVnE3aHFCYzF3V0tjREpX?=
 =?utf-8?B?Wmh5VCt6amNUNTd3WVIvT1FtbW9OcGovQ1BzZG5tTlR3elNzR0prMytFVGdR?=
 =?utf-8?B?cFdXcEJmSHlHcERReDhULzVBYzRxVm02Zjc2ODA2aWNsYnE0VlhkWGxObml6?=
 =?utf-8?B?WHdvakZUVmtETFlnMSszUG04VGJzMFdWQkNuTU84ZnREdFVGMCtIUG40blFz?=
 =?utf-8?B?b0xEOHNRRml0UHc1Z1lTT1hnNVNWYTlyeCtIUiszOGpOejRMRi9EbEwyUDNT?=
 =?utf-8?B?UDVzZXd2M0VyOUErQTNYMThtTUE0bDA1VGh6Y0I3MkZmWkM4ay96ZGJPL2lS?=
 =?utf-8?B?T1Y5c2dsc3F4MGRUREEzeDNoWkxDVkF3QlBCSDV1UlNaK3hid2pHVXhheUN5?=
 =?utf-8?Q?RvQKytLDibblmArkG1xGEtazD?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	GlxeiGm2r/xjlJJn8FKACmKhem1A0JJUTrzOYBkDMGTJL/G6MyzQ+X9hGyXfyJY9ntvhqTeNcsdeavXGsFLV0c6cvHaj0b5cXvTsiZ35lkszuDl5PRL+uYS4M//27H+3NOpmQwY6H2VtRxjOHLneiOS/UGP9bCWqtYOySsvuQgIcr21BXPPZX5TAzpwK+wl9F0NiX6pWzUVhCjWo3TqOgOuhb0ef8dZoGeyGRG5KhPlMmG1bADWqFn78xQPlaWuUexxn7Kp91LtXlAJGCuXT+UY7h0jU2Bpz8DHxVRFsl4VVlaB1yGp3NyQzjTncpZlEnWduiLnJD7JHIMrLZPuk2Rwv0MtyQsD3BY6jAF/8I6B3ScDTiXJuEkEq7/1+rDyM9aWS+DPCUOZez3FF4RsjvwwMj3aKkvv/elXDExjojwEslnBs4x7oUHkwwVBE+ccFOEuAdInM923ZvWxDALEaFeAYJK3Q61X1e6ck4p38k2AaIKFwkcMVaKoTrbCwueICe/7qoWzZ0YL3zENupYDgwQ+myswxpW4uPnRjmqMftm9Otj1m3oNZRcqazGc1c4YKeUW8bIbvr5Q8UAHR84v8EieVEh1KoWVy6bqToWoPEoE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32669001-ab30-4bad-8f5c-08dc3de009c4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 13:19:22.7456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EgJ9h/bF0lKmlnSVwR/z7mIP/n5roPPtk7l38HSnLoyjCPbpgcfXQKRkIXrNCcchTQS5lxl/eqzp4Mf2Mi1fcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7359
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-06_08,2024-03-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403060107
X-Proofpoint-ORIG-GUID: 6D9hfv6iyCH1NEEp_BMJsFxGVM4zl-1P
X-Proofpoint-GUID: 6D9hfv6iyCH1NEEp_BMJsFxGVM4zl-1P

On 05/03/2024 22:25, Bart Van Assche wrote:
> Not all scsi_debug users need data integrity support. Hence modify the
> scsi_debug driver such that it becomes possible to build this driver
> without data integrity support. The changes in this patch are as
> follows:
> - Split the scsi_debug source code into two files without modifying any
>    functionality.
> - Instead of selecting CRC_T10DIF no matter how the scsi_debug driver is
>    built, only select CRC_T10DIF if the scsi_debug driver is built-in to
>    the kernel.
> 
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

> ---
> 
> Changes compared with v1: made the patch description more detailed.
> 
>   drivers/scsi/Kconfig                          |   2 +-
>   drivers/scsi/Makefile                         |   2 +
>   drivers/scsi/scsi_debug-dif.h                 |  65 +++++
>   drivers/scsi/scsi_debug_dif.c                 | 224 +++++++++++++++

inconsistent filename format: scsi_debug-dif.c vs scsi_debug_dif.h - is 
that intentional?

>   .../scsi/{scsi_debug.c => scsi_debug_main.c}  | 257 ++----------------
>   5 files changed, 308 insertions(+), 242 deletions(-)
>   create mode 100644 drivers/scsi/scsi_debug-dif.h
>   create mode 100644 drivers/scsi/scsi_debug_dif.c
>   rename drivers/scsi/{scsi_debug.c => scsi_debug_main.c} (97%)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 3328052c8715..b7c92d7af73d 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -1227,7 +1227,7 @@ config SCSI_WD719X
>   config SCSI_DEBUG
>   	tristate "SCSI debugging host and device simulator"
>   	depends on SCSI
> -	select CRC_T10DIF
> +	select CRC_T10DIF if SCSI_DEBUG = y

Do we really need to select at all now? What does this buy us? 
Preference is generally not to use select.

>   	help
>   	  This pseudo driver simulates one or more hosts (SCSI initiators),
>   	  each with one or more targets, each with one or more logical units.
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 1313ddf2fd1a..6287d9d65f04 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -156,6 +156,8 @@ obj-$(CONFIG_SCSI_HISI_SAS) += hisi_sas/
>   
>   # This goes last, so that "real" scsi devices probe earlier
>   obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
> +scsi_debug-y			+= scsi_debug_main.o
> +scsi_debug-$(CONFIG_CRC_T10DIF) += scsi_debug_dif.o
>   scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o \
>   				   scsicam.o scsi_error.o scsi_lib.o
>   scsi_mod-$(CONFIG_SCSI_CONSTANTS) += constants.o
> diff --git a/drivers/scsi/scsi_debug-dif.h b/drivers/scsi/scsi_debug-dif.h
> new file mode 100644
> index 000000000000..d1d9e57b528b
> --- /dev/null
> +++ b/drivers/scsi/scsi_debug-dif.h
> @@ -0,0 +1,65 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _SCSI_DEBUG_DIF_H
> +#define _SCSI_DEBUG_DIF_H
> +
> +#include <linux/kconfig.h>
> +#include <linux/types.h>
> +#include <linux/spinlock_types.h>
> +
> +struct scsi_cmnd;

Do you really need to have a prototype for this? I'm a bit in shock 
seeing this in a scsi low-level driver.

> +struct sdebug_dev_info;

How is this specific to dif? This should be defined in a common header 
file if used by both scsi_debug_main.c and scsi_debug_dif.c

> +struct t10_pi_tuple;
> +
> +extern int dix_writes;

For whos benefit is this in a dif header file?

dix_writes is defined in main.c, so surely this extern needs to be in 
scsi_debug_dif.c or a common header

For me, I would actually just declare this in scsi_debug_dif.c and have 
scsi_debug_dif_get_dix_writes() or similar to return this value. This 
function would be stubbed for CONFIG_CRC_T10DIF=n

> +extern int dix_reads;
> +extern int dif_errors;
> +extern struct xarray *const per_store_ap;
> +extern int sdebug_dif;
> +extern int sdebug_dix;
> +extern unsigned int sdebug_guard;
> +extern int sdebug_sector_size;
> +extern unsigned int sdebug_store_sectors;

I doubt why all these are here

> +
> +/* There is an xarray of pointers to this struct's objects, one per host */
> +struct sdeb_store_info {

this is not specific to dif, yet in a dif header

> +	rwlock_t macc_lck;	/* for atomic media access on this store */
> +	u8 *storep;		/* user data storage (ram) */
> +	struct t10_pi_tuple *dif_storep; /* protection info */
> +	void *map_storep;	/* provisioning map */
> +};
> +
> +struct sdeb_store_info *devip2sip(struct sdebug_dev_info *devip,
> +				  bool bug_if_fake_rw);
> +
> +#if IS_ENABLED(CONFIG_CRC_T10DIF)
> +
> +int dif_verify(struct t10_pi_tuple *sdt, const void *data, sector_t sector,
> +	       u32 ei_lba);

Is this actually used in main.c?

I do also notice that we have chunks of code in main.c that does PI 
checking, like in resp_write_scat() - surely dif stuff should be in 
dif.c now

> +int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
> +		     unsigned int sectors, u32 ei_lba);
> +int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
> +		      unsigned int sectors, u32 ei_lba);
> +
> +#else /* CONFIG_CRC_T10DIF */
> +
> +static inline int dif_verify(struct t10_pi_tuple *sdt, const void *data,
> +			     sector_t sector, u32 ei_lba)
> +{
> +	return 0x01; /*GUARD check failed*/

leave space before and after /* and */

> +}
> +
> +static inline int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
> +				   unsigned int sectors, u32 ei_lba)
> +{
> +	return 0x01; /*GUARD check failed*/
> +}
> +
> +static inline int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
> +				    unsigned int sectors, u32 ei_lba)
> +{
> +	return 0x01; /*GUARD check failed*/
> +}
> +
> +#endif /* CONFIG_CRC_T10DIF */
> +
> +#endif /* _SCSI_DEBUG_DIF_H */
> diff --git a/drivers/scsi/scsi_debug_dif.c b/drivers/scsi/scsi_debug_dif.c
> new file mode 100644
> index 000000000000..a6599d787248
> --- /dev/null
> +++ b/drivers/scsi/scsi_debug_dif.c
> @@ -0,0 +1,224 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +#include "scsi_debug-dif.h"

I always find it is strange to include driver proprietary header files 
before common header files - I guess that is why the scsi_cmnd prototype 
is declared, above

> +#include <linux/crc-t10dif.h>
> +#include <linux/t10-pi.h>
> +#include <net/checksum.h>
> +#include <scsi/scsi_cmnd.h>
> +

Thanks,
John
