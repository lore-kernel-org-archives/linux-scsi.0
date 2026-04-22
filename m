Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C12C3A168B
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 18:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776881121; cv=fail; b=sVnscdKfjd0moHvfSC8iZbVQJFuM/EJMoPigxIIMDhBrDmlpfqVfUVAEIE03va4cz0ZM2I1o0edw0sMCIka/33pZMzG3tsb3E3/hR3UT+40IYN9QGqTOaqChBi7A5tTYwkX0mxuidUxBrDVIqXLQ2FIxiajwgZmLkZMJyS1sWkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776881121; c=relaxed/simple;
	bh=68WaJCFHocht1hn23VxTJMHfSslkr5cHGo41JzvrB8I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R7q560FGmVbA3ul+BdxVR7CdHdztG7IQqPHSB/v9V+jtWzBd+lcc1GLQyBuscR8p6iywgDimXSY8kfzdv39jEEOIibWT5RN830XiLv+CFgjsa8kASsalJf/qSzquU+Lqtdndqgz4ogz1X1MGeviwGhicjsB/+8qzl3YeJ4mj7vo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PnH303sj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UqNk6o2Z; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PnH303sj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UqNk6o2Z"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63M9FYSj2586207;
	Wed, 22 Apr 2026 18:05:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6DnSALO54RZkqEYRSZO1EwTQA49x8TdWWQassuXcZ6I=; b=
	PnH303sjiJDzJuHYop4+mSRV5slR6vNKK/L2B0Uvw40FbBHD0GKxt8yi0gy+jsqQ
	harflFq8gZTob/J+XG4OC3ZxdgS/7fRxTwud+kd1vFAU7Nc/Ft/Z2nkBqbKo/zUr
	dniYvcZA7/Ud1g6tS+ldwGlzv+9aKtXS7W170DDUd9bpxZbu9t+UsKl+3cBEebY3
	dCwPKvZL1iXhVUuTthzp9seNw4PPlvS+1A9u8rghup51ZVIud1g6e+i5s7P2yPkf
	Yp6FYcc/gf27YnoGMuT0nBmCWI/gM63uhdiy5mVnJz6NLmDKsFzJIbkyPy3KGDoM
	f+MjvHi1My34Kyi5H412Dg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dpenrhv9x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 18:05:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63MI1QBt028823;
	Wed, 22 Apr 2026 18:05:15 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012056.outbound.protection.outlook.com [40.107.200.56])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dpjjqjr5h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 18:05:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A3IZgW46ncazfJHv0W3iHIhoBF/reglkRrf+qhahPz+BQ87Ty05pjAq3V0wSHeUhOGZ0Uq67xVFojmjrh31gCuGFHSVpAsWmwjeL8wUjJ9GxNB+MCkDDxV4Ga9KYpl/e31zIXBSIetEWutVXM6D4LeIeQlXYNPi7vIHLOQzMTwhOsQbnL9lvU6r/bW6GtD/3sIdeljCewDLeQ2w/pCB9IcvM55f82tjxCVlg7PjMqLrfwExjKFcADZSg0/zdbDoB4n9SvGfBiSqC0rw8DGm/c7+IoglLtWbx1VDBpWsXl4FUtqgV/4v9NeXYQmjlEE4Tx+gW44GwlpMOwHL564jZ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6DnSALO54RZkqEYRSZO1EwTQA49x8TdWWQassuXcZ6I=;
 b=FRsJLlslncw9z1GEfAZxQOAfI0gqtonG9ep7jY42ATir3QICfQy6glklck1pnnz0S0+KpPvC6rpjCOHgW7WCHBgX82qtGskiE/+pP9wLMIWcFr1P2iWueGa0vTCA1evqhpCjcN7LnjLUHSiNeAlmv4NUZhq21myqw+dgEGxhphxl7+t29ztoR0A01XdZIyei0AqkIQSOklv7yTIWedNWn//iudEAT31XYZtLQKYSbtrshTtYYlLqyFdeW+mdWCF30q2Ty31ocDnxsxCNhpRZzt8cd25Ig3CZYkxGhb1RTVlzh5oBGfrIzeO3PRmIPOI2SqvsFjpjCr6JwNMZdLmQ/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DnSALO54RZkqEYRSZO1EwTQA49x8TdWWQassuXcZ6I=;
 b=UqNk6o2Z9BhXPrhI+OZra4b57skC+kcmBNYyENUlYOWun5GWBI6x6OY+L7mnPEVbLPpODM0nHtwzmQziKgCXsbwdVmvCPNE/lF1qEVQeAKsCjscZRQ2l58kqKuF67t3gVA+3FcrZqDfeKFAZCrad7wwVyC7JgiD2a9vca4tyRJk=
Received: from PH3PPF8C8C3D129.namprd10.prod.outlook.com
 (2603:10b6:518:1::7b6) by MW5PR10MB5713.namprd10.prod.outlook.com
 (2603:10b6:303:19a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Wed, 22 Apr
 2026 18:05:12 +0000
Received: from PH3PPF8C8C3D129.namprd10.prod.outlook.com
 ([fe80::6b83:fd:b694:9db3]) by PH3PPF8C8C3D129.namprd10.prod.outlook.com
 ([fe80::6b83:fd:b694:9db3%8]) with mapi id 15.20.9818.033; Wed, 22 Apr 2026
 18:05:11 +0000
Message-ID: <603eee86-9914-4ac8-b937-a38922e69a45@oracle.com>
Date: Wed, 22 Apr 2026 13:05:09 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] scsi: Support devices that don't have a cmd_per_lun
 limit
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, virtualization@lists.linux.dev,
        mst@redhat.com, pbonzini@redhat.com, eperezma@redhat.com
References: <20260417230751.117836-1-michael.christie@oracle.com>
 <20260420173352.GB405461@fedora>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260420173352.GB405461@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0089.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::34) To PH3PPF8C8C3D129.namprd10.prod.outlook.com
 (2603:10b6:518:1::7b6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF8C8C3D129:EE_|MW5PR10MB5713:EE_
X-MS-Office365-Filtering-Correlation-Id: 4348e9e9-94bf-44be-d20e-08dea099b24f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	pQ+DEW8o8659UdmLIbhpybH61OFLUHVncZlSPRwi0OcFXdirzQVJr/XKjcAl3Mx12n2kUtspaZWf97f4tHZnQ8X9D8pXqRH8ckMHFFFgFUOWp6Z/u+yM7nSIGqndJmKO1CP1mmSgWO8YBpk9gGw0tMYJshaxGk6nWpCKOwVazZMth7RpAkjtXgoqdiienojAwIMF0NXZbO39vPQArAgceDkFQoz+c/ipC7j5rQtf3ZsiXTwumMjdsLmILYPq9M8UWhe280voiKNfABtHLH4nQk2wFz3XeSANqCGFSSIIVRhvHCs52tKGVWQ5N6THgbfTstw8IR/TC2oot0eAJNnrWUbUJchIXvqfPhv2TlWcNZgmCDxGF1XS686PDBGvi/Pbn2MdtngRThnPn58Lthc8v8S6qEawSi2VpPVqm1Gdv2Eq64SrFtKEonpUlxgkn6RPE0OZPDfkUSO4XOOe+PxRmlg1VjbQGZCy3FL6aKqqz36DOq9vf5U6H7si7N7Fvm+HHy1PdpSYlWIQQJ1e5lM4W4Wo3Vzolx8IB3RvzfUNvkA6hpWlwFn3gPe0DCnbLmyV9JUrGSwzSnvPfsut7P0ewggiaMu894Rf4m48xrjOajQKkJebGDfHe9GLN0Lz7sRg1MAIaHj0e22Ft+ZXjFFvYNJYf2NDA2NpDTX3bP6vW6dU7ruxFqEnLIUfX7RwnCKNys0LkIdfBkfzns5BRedBHC4us2rdQqkOnWGzHGZkXE4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF8C8C3D129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M0VaWjNXYVRGbi9xeGlPd2hMKzRFYXRDR1hmenhOQUIwSGN2MG5yQlRZMytr?=
 =?utf-8?B?eTBqMTZWY2RJSU81T1dsYWhIamZxM0JHMEw0R2M1RzBib0Jud3lNekM2Um1V?=
 =?utf-8?B?T0pMdjVFQkYwenYzQWtHZGVBUHozaHBjK2VpaE00NTF3dHNCNTZINVlXU0xp?=
 =?utf-8?B?SDl6LzBQMXhSbU1CT0FQcS9yMmthK3FSUHZhdmtiWEtPYVhBbjg5VUd5aG1z?=
 =?utf-8?B?NlNHbVlmNHdvR3hBQVhUbzJtNkl2eTlKZDNhQW9tc0lqL0FhY1lsQWV5bkRE?=
 =?utf-8?B?OG9Zb2xxR2F5T201Q1FJcm1yaVR6L3VieEtjVk00SGlvYjZ6dmVLd1dsUExG?=
 =?utf-8?B?VlpNcUhpWStnT3BLVXVGUWVGN3IyUmM4Z2RpdHh4WWg4c1BEa0phQnhVS3Fr?=
 =?utf-8?B?ZnM1bHYvZWJsZGRIWWFLOEZKa2FmZHdCWFFocmkrSzQyNkgyVFdGbnByVmxi?=
 =?utf-8?B?L3Y4MjF3TFpkTHp1N2sySnB2MkxyM2xzUXhiSzBjL1NqOUpFdGdmcmVycWhT?=
 =?utf-8?B?dnpOcTB1QWhIL0FpRlZDNGdHeHB4dHVpZkRWblVzRXJaTG9CY3UzWUVCNys4?=
 =?utf-8?B?SlZNQnVhcUE4aDFQSzR0RUd6YURaakNRVzg5TXZoa2tWTDlqRlJjeUcyR0sz?=
 =?utf-8?B?ak5LK082NGJHaVRWSlNDZlhVR3lMeGV0anJ0TTVMRmswNkZpMGFqd1h5ZGp3?=
 =?utf-8?B?VHpJMGlrSmxTa2k5alp1RVNUdjRGeHpPaHUwazlobmN1N29yV0tTN2ErelI0?=
 =?utf-8?B?SjRrRElROVpzMVRRRUl1LzV3ZHJTZ2ZDK0h5M0dGYVRFTDVvc0tEUjNpNDZX?=
 =?utf-8?B?endFekZwRW02emVKVEtRU0lnYUNrK2hZUHVhZmR3d216cSt0dmN1ZlVmYXZD?=
 =?utf-8?B?VnNFbjErdFE3TVNqdm16Ymhka2VlRzIwM1lRUlk0Z0xiS0RlSDFIcGdnVDFH?=
 =?utf-8?B?MHhhS3d4KzYzRUNTa0NQMmJxVW5PLzVPZVUzQ0VGSHJoYkt3S3lvOVNwY2lJ?=
 =?utf-8?B?eFBTQStrN1EzbzZtck83NkJ2ZDJSNHRoM2w1OGpMR1lzN2FqK3Zla0xtRlVN?=
 =?utf-8?B?ZmRELzUyTGJMbG9aaG4xWm95WDZtSVhSM0p6dFVjWk5MTXVVdHVtL3ArZUF4?=
 =?utf-8?B?UTNFVU9MRkJqSUlxZzVXaHhha2E4cHJLWHJsT2NKa29aVVY1TUhQaFJuamEr?=
 =?utf-8?B?UkNwdXRFcGhycWtuM3hMNXpmcVNFeHJZc1dtY2NaTEtCcXRGWG8xVzF6blVC?=
 =?utf-8?B?anlwNWlkaTFSY2xOdWg3eEZ0QldmZzBpUzFoRkNXcDZrV1U2Q29NUnM4bVor?=
 =?utf-8?B?SC9YMlA0TXpaUmhCRFZoTFFIWlFFZ0FwVllPUG83YjVaNWZmR0VxcWhmcS9M?=
 =?utf-8?B?U2puZzMzS0h6c1RLSEo2N2o4Q3hTTFFhMFEwRUV2SU53bUlCcEx0Q1pOYTJE?=
 =?utf-8?B?eVEwZ3FwZitmL2FvQkJTOGE3V3R6alZVSWpVbGlnNnNOVU1PWHpZc2NSQ0pW?=
 =?utf-8?B?SmhqR3NlWVc2UE94bFRBdE9qTjJiM0VESE1YZWFxVGdxVkoxV1NxWVc1cU55?=
 =?utf-8?B?cXk1ZFRMUk1DdmhSOTJuSEpmakhCakU3NnI5akxwbUVBcVh0bXMwOC9sRVhC?=
 =?utf-8?B?UEhOcWVPOVRqRnlhMDFPR0ZPd2R1YnRKcE5zUWlrOERzMDRjYTRwZUM3MnJZ?=
 =?utf-8?B?dXFNeGtVVW9taHJEOHliNlhrSUcxYVlxaGcvd25FSU51UkU2YTB3OGw5c3hx?=
 =?utf-8?B?NnVvSmZmRHc5c3oxd1lib0drenI0NkpObEo5bUpvZUhaNW5lWURkUHdWMWll?=
 =?utf-8?B?aUlmRzJqKytHSm9ZSDJGS1hXdS9KWXVkLytTL21ZRjJqN2ZwOE5TZmRVeGhK?=
 =?utf-8?B?WG9xdUltY2JLN1FrRHZwL0N3bFR0MFhKdi9rVVpYL0llN1VrUzBGaWhTMExC?=
 =?utf-8?B?RGN0R3paVUo0YTRPbDNWaDE5UlA5SFhlSXRjV1RwYVBJNzRZaGRmRys4MXZP?=
 =?utf-8?B?TlNEdUZ6ZDVuZnF5QUtEQTZGcGlHSXpIcHI1ejUxUy9oNmRGTWtWKzNZa1Fx?=
 =?utf-8?B?QWxsaEdxNjdxUkhGbTM3SWt5bjFBYUlOc3QxVkNBZUdEb1A4L0U0OXRtTDYw?=
 =?utf-8?B?dWZKOEV5WWlEYW5lbWgwaFVSd0hjK2dIbTl1K29xZUJySjV3QnVEdlllK1Ux?=
 =?utf-8?B?NnU2OHZIeTQrWURhWjdWUTNnUU9aZkoxYlQ2QU5kL2xySnVWcHgvRXNuTnla?=
 =?utf-8?B?eDlPUDk0TWoyS0ppaUxHSGtjSmEvUU9TWkRLdnhTRzZBSk5mQnVCWEdRYXFV?=
 =?utf-8?B?UTRDYmtld2N3SDc2cFlxa0duYzk0OGM4RllQSmM4V1U1SDJ1NGk2UGtSZ3JE?=
 =?utf-8?Q?Zo9DSjlVGShmgiBY=3D?=
X-Exchange-RoutingPolicyChecked:
	W+z5EgMav/oreRtjAjHfx90JHdTMuZ9GJS77Jyq14z7zP5E/CPAVUpY/F79lYzCfOKXdIb4kiidZe1ts5nM+j/i7iQ8DTgyu/8OezK5CIatH3cZ0JJReUexHuHxTlPOQYxaE1MsSVDwyVrk1mP8rcphtzblYGK/SOatlxZIulzC1xZlqp9PN3qeokHQHD2MDpGCkKKd0NscQpEPahy9tFmqqQq2irJIQAM/+TuEm6Kbm0Xnhn3CPz7H8uGRnp2rhMz5rWV7Ff/le75IC5GdGxH0Q7rxqFdHlq9+4KK6WDV6BJ4Bde6XxSpQ/cH6UuN5jmHrBQ9tu7LqmIBnnpDnUig==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	y7s5mfgDeEr+RN0gdOIQTcXk2QcJMHA0m0uKKfm8F7bdXsWBGYxJBE758ttoKQ3sYyw8lk9QiOlIwE1Acf+6rgQedl23sLnfwP1YSrIz4tQqR9w/coMpL2McSVX8Tdo9cgE+SQc4tOIVTJ+Kw4mWAg1djHXEanSZykzp+dz1JzuM8yzoIh45YvA6OVuOXyFS7ReCsxl8GeGS98S39X+oyDVwQgcxpRGLpi8Etg1TyLcf/k7ExbaxxVXCk2VcytwacLT7BJ8uP8/hgEKVrVSGpsA6zVBPsbCY0D/1E4iVPxA9vRzN8uonvpuWBIqo++vt/K+MxxQQnIsPi+u7O1kxgvzq8G6o3XJDuUsF7u6hz5NGnQoBjUzqg8e2IBtp8QQTdqwA+8ht4K8EO3JDGOGk/7dAaCzDOsxSFA4KPW/seafsxljZXyNrnNf9NmcA9eE5UsBisQJhNdZ1tlOHpQjKu22FZ2SrkuAFf8x2gI/2IhSY/d2pl1UXENUxzljrGUW+3Ro6Z3ljCxskHLL3IoSTEdyC0Q7Cc8Ao5WgKnYrkpvpRNNVA+7nN6ogNuorwDbbBzncaHSm7JMk5KcKEBix7QP+60x7cQVXFOz9KrGu4Qro=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4348e9e9-94bf-44be-d20e-08dea099b24f
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF8C8C3D129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 18:05:11.8236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sq//W7EJalbGklsbu/czQ+Ao7NOG3fhIp6CjBlI/eNZEbhsuCWlB8brj/eub6oCosLPsch8YpOuENIOi/M4ojDoqj7G4v9uyAeu4fbjAcik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5713
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604220174
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDE3NCBTYWx0ZWRfXwPFVoN4NRDc0
 klzQKVu0Z98cCJWDbm385vmfOgkBuKMMZj2WVvhldJNJ8U0sPYGWQ6KETTIuGqb5qtKaGFVWOLi
 +zpIdyUt17vWPyxBaaF8+AkzaImG3Kf7AB6hHs575oEVgBHOKuqbtF1A45RFVWOukLlLCal5/CQ
 aBbNkhZg7yn1tjzltVUlxF8k+xxDCfejbD/o/1svW0ernsy6KcBTSiECpQdWQVafNvRIuGfZcvW
 mt3z5GFsOfyVpU4x77a/jX1SyRlsppnD+qngKpblUQbSSfkGdNi0lX8SvzA+ujGCOhLyu13LgOO
 H5pWQkQheWszHuq4orngBOLdMK2avjbTiGznNmcfTjk23qHxfj5Cjjtftd/pp7k2Qm+zWjNs06l
 7+gg0g9QWpqtZYx4IcDQPUuE5AeIN1yDYnncXBgSwN48A2rf/qlB/ujbIOdPTvQ/zVdj4DIGaA9
 liSnYK8gJhBIHsO8HMBwpttsxsKTBG2RkvDPfUFk=
X-Proofpoint-GUID: E0xkUWW_IJmpj_Bye7CASLkl3_16k2J4
X-Proofpoint-ORIG-GUID: E0xkUWW_IJmpj_Bye7CASLkl3_16k2J4
X-Authority-Analysis: v=2.4 cv=JeKMa0KV c=1 sm=1 tr=0 ts=69e90ddc b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=qyMZKJSYC01LAxPVKcIA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12291

On 4/20/26 12:33 PM, Stefan Hajnoczi wrote:
> On Fri, Apr 17, 2026 at 05:57:20PM -0500, Mike Christie wrote:
>> The following patches were made over Linus's and Martin's 7.1 trees.
>> They fix an issue where for virtio-scsi we export a lot of non-scsi
>> devices but are getting throttled by the cmd_per_lun_limit too early.
>> For example we export 1 or more NVMe or block devices and would like
>> to just pass command to them in way where virtio-scsi's hw queue
>> limits match the physical hardware. Or in some cases we are doing
>> cgroup based throttling on the host side, and we don't want the guest
>> to block IO when the host knows we have extra bandwidth.
>>
>> The patches add a new cmd_per_lun value so drivers can indicate
>> when to avoid tracking queueing at the device wide level. They
>> then rely on just the block layer hw queue limits. And the patches
>> convert virtio-scsi. They also fix some can_queue related issues
>> discovered while testing/reviewing.
> 
> Hi Mike,
> Is there a difference between setting cmd_per_lun to U32_MAX with your
> patches versus setting cmd_per_lun to the virtqueue size without your
> patches (this can already be done today without code changes in the
> driver)?

The problem today is that cmd_per_lun doesn't take into account the
multiqueue queues (virtqueues in virtio) so we have a low limit of 1024
commands total. On a 32-128 vCPU VM we can easily hit that as there's
lots of IO submission threads spread over lots of those CPUs. CPUs are
then mapped to block mq queues which are mapped to virtqueues so we are
hitting them hard.

That 1024 value comes from QEMU which limits virtqueue_size to 1024.
We could increase that to 4096 or 32K or whatever. The problem is that
we would then be wasting a lot of memory as we would be allocating lots
of really large virtqueues that would go underutilized (we are submitting
10s of thousands of total IOs but not to just a single queue).

So a possibly good balance between not having to use a magic number
(U32_MAX) plus having to update the spec would be to:

1. Fix up scsi-ml and virtio-scsi so they allow cmd_per_lun to be
greater than can_queue (virtqueue_size for virtio-scsi).

2. Increase the scsi-ml cap cmd_per_lun cap from 4096 to S16_MAX
(scsi-ml uses a short for cmd_per_lun).

The only drawback to this would be that for each scsi_device we track
running IO with a sbitmap. For my cases, we don't need it, so it would
be a waste of memory. For a S16_MAX worth of commands I think it would
be 128K wasted so not too bad for us as we don't have lots of these
types of high perf devices per VM.
