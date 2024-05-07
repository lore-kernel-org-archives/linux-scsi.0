Received: from mx0b-00154904.pphosted.com (mx0b-00154904.pphosted.com [148.163.137.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A87C13C9A2
	for <linux-scsi@vger.kernel.org>; Tue,  7 May 2024 08:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.137.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715071496; cv=fail; b=WRvhP+paVSFVs0546ukj/jUfyMWLpSUBckL/LSuVFuZOUMSo9WgmvIl2oRsCQkW1Q7WpZbScYsBiWU2i9T2Uf/Id/7vOBwNulsdj5gUR/R/iFpTW+fqDphYrqLSaF6/o4A4ixYtwfnHYjsTxIXldPKWKRKIBPqjQV59cwCFh78s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715071496; c=relaxed/simple;
	bh=L8wWZ51QK0n3EdAkBf3XIw5N4dF4B9vmHw2JKvww6jw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MnCRTYZJQ3zrzeAPxtdaaa15ohAc6s52O7YV9cWhL7SEgnM2VGh+Aw64jSCvmPy8OUv2CYLpFRHky9gbz1PYFS72agx+9lb58Z2/EsRM+2WBIGi0MsTa9zbTii8sVf3U3iboZv4PjZR+kAY/x532FLHoPDj9QnutQPT2KEgOBzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=Q1BgHYVH; arc=fail smtp.client-ip=148.163.137.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="Q1BgHYVH"
Received: from pps.filterd (m0170394.ppops.net [127.0.0.1])
	by mx0b-00154904.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44733QAZ027512;
	Tue, 7 May 2024 04:44:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=L8wWZ51QK0n3EdAkBf3XIw5N4dF4B9vmHw2JKvww6jw=;
 b=Q1BgHYVHqacZAnXIxa+SBe14JeASqHL4FeUOM6yUEaIsfjUUYvCpXFrByKHD9PxBC4C8
 1xtZj/WejBSHaFlVKlLq9iB+TaT9NkLk9HiyzMBYb4z+/n+pIDZtD7861I1ILagJJ0Ap
 V5SLwwlLJ5CZVifCzo94VSb9UkVyLoX0MEnOkWL4l4Qadr7kEJt++eanUIQLC4SEtmPk
 WI3yD85T5cG5Mdm+hE3L+NwNznRjB500iNSE9YqXM50TAsDn44HVIk8l+aYf2MvmgY4R
 MVWgtX7TwQ0kZzcwspSbV3BZwaqYPsxTcpnLOxSfilJ92cTP/JOs2C2dMcABUEM1IFw5 yg== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
	by mx0b-00154904.pphosted.com (PPS) with ESMTPS id 3xwfk6u4pv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 04:44:44 -0400
Received: from pps.filterd (m0134746.ppops.net [127.0.0.1])
	by mx0a-00154901.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4475psQo035203;
	Tue, 7 May 2024 04:44:43 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 3xyeh92gvn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 04:44:43 -0400
Received: from m0134746.ppops.net (m0134746.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4478bwDe007286;
	Tue, 7 May 2024 04:44:43 -0400
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 3xyeh92gvc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 04:44:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YOjV6UQ5UXfry1ciQIYcIjnyy2WVfJQj+dI86zEpaKKekKL09BYiHWpFgr5aGRmJgn2KyipJJOz0BhK44pc/W46UFPKkzpdbqF1gWM1eVYKetPwQrvI+vgDNAoIomDw7Uw2z8BG/fDZwDbYgGrf+00K5d3A7Y8Ufgf7avs2Bj60mB/39Dfp+iyMIEPFuLLBXJu0L/yWZyIicLbnFswisCN04DCBWoE3EKJfleTTuIA1rHFi5S4Xb1RVJOeliX1SznUrb94iuZHc3eCeDG3vXr/02gT2CkMu47n/uZ06Vc7LTzGScPe/w0um2dYW3Tp75ej2iQodL37wejMG0UAJDww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L8wWZ51QK0n3EdAkBf3XIw5N4dF4B9vmHw2JKvww6jw=;
 b=nbJ1hQdz1tZEPQg4whdf3MKFwONNMRk9gvvcYF3ldoJmpjh4VGVjnvDCXs0MqrlNdLo/938vigHt1iRyl7aNfRRLBLyCRsOSCJP+uI71P1+NBznL6g6rSsjefcWEEdW05a95As/DMmmxmLehBgOGHfHMAOPHqjH2SV/3kd9L90IMW+88pGe/gm/Qx0edBaIJDHl4+hBEhn1D12LgdY4jJvn80kJ5HkI1Zyc3tW6hIRnqVOPHNvjmMSdfD/a7zTkGItxbYmspSub1iw6cT3kfQmQtQDdsVOgxHTGSctjwQfTwiYx//jgwgwVTPEZd+5n2bhlixcBMciFoK3i9EyjMIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
Received: from PH0PR19MB5411.namprd19.prod.outlook.com (2603:10b6:510:fb::13)
 by BL3PR19MB5257.namprd19.prod.outlook.com (2603:10b6:208:338::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 08:44:39 +0000
Received: from PH0PR19MB5411.namprd19.prod.outlook.com
 ([fe80::d042:8333:1fbb:a72a]) by PH0PR19MB5411.namprd19.prod.outlook.com
 ([fe80::d042:8333:1fbb:a72a%5]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 08:44:39 +0000
From: "Li, Eric (Honggang)" <Eric.H.Li@Dell.com>
To: John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
        "james.bottomley@hansenpartnership.com"
	<James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
Thread-Topic: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
Thread-Index: 
 AdqWJbfhv3GSaG0rTeK0+6km85YpNwADuoMAACHtcIAABC5uMAEPIjxwADJmXIAATNqvUAALeYiAAIffgZAAQPLpEA==
Date: Tue, 7 May 2024 08:44:39 +0000
Message-ID: 
 <PH0PR19MB5411390C5A29A953CAA70062C4E42@PH0PR19MB5411.namprd19.prod.outlook.com>
References: 
 <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <09dd80bb-09f9-481f-a7a7-b9227b6f928f@oracle.com>
 <b1a5552c-689e-d220-88d3-56d24752be5b@huawei.com>
 <SJ0PR19MB5415831DB91059696672B163C4172@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <SJ0PR19MB54152CB3D611259510902505C41A2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <c004da1f-b9fe-4641-9d0f-162eabde0101@oracle.com>
 <PH0PR19MB54115A3BDCD9319781FA652FC41F2@PH0PR19MB5411.namprd19.prod.outlook.com>
 <823ab904-33a3-4ed0-8794-cb36b9ad636b@oracle.com>
 <SJ0PR19MB5415F1D35AFB4039A426079CC41C2@SJ0PR19MB5415.namprd19.prod.outlook.com>
In-Reply-To: 
 <SJ0PR19MB5415F1D35AFB4039A426079CC41C2@SJ0PR19MB5415.namprd19.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
 MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_ActionId=23897db1-d484-46ad-a8fc-ed148c0c503c;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_ContentBits=0;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_Enabled=true;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_Method=Privileged;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_Name=Public
 No Visual
 Label;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_SetDate=2024-05-07T08:23:52Z;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR19MB5411:EE_|BL3PR19MB5257:EE_
x-ms-office365-filtering-correlation-id: 7738f261-d761-49a8-bc76-08dc6e71eec8
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?L2QvNFV2S1hILzdFOHZveS8yRWtsSWZoZE9qaThQRkY2TThBUEt3RG1xcEQ2?=
 =?utf-8?B?aHBRb3VOU1Y4R2hYdFFlWG10OC9wRjM5RlhTd21uRkNqbmwzRmNOMzdIdmxH?=
 =?utf-8?B?dElPZWhkQm5ZVi81ci9UVXNLV2ZMRU41ZSs2Q0RMM3Yvb01RMzkzQlhaNmcw?=
 =?utf-8?B?ZU44dWZ4SStmTCtPc1JvMWRiR2NNTEZ0eHNrd1JIM2RWS0FFN08rUk83eXJv?=
 =?utf-8?B?NkhIT29pVTJ3MVhFME5BUjVYdHlJV1NGTm1YSUZVY3FFSTMwVm5vOEs4TkNW?=
 =?utf-8?B?ZDBBWHhmSDFCcGVaK2VyVmx5b1hZVnZNZlJJTjh1MElYV3RMMVJnK21zb203?=
 =?utf-8?B?dG5aVlhoTUxGRTdpNFJrSzdrWnJBZHNMNXA3cHRrVTZwUW9ZcHBVV2crdE5H?=
 =?utf-8?B?eHNYVDN4SGx0RmplOUhLRk1mVGQzMWlBN2svUTltNmFvcy81ZTJjc25pOVhW?=
 =?utf-8?B?RUdFSDNYalEzc1M2SHFYbXhVaENxNUc1R21PZDBRby9hMXVLcHJDQUtEcE9Q?=
 =?utf-8?B?QW1BWWZiL0JGVjF1aENXTXVHL1kxSFpjcTd3NzEvY2VzSThHaE5rQ1FscStE?=
 =?utf-8?B?aUJtbTNqRUcwUTZNQnowS0NIRWx5eEEyYkc1QS9DOFdNNzdXRkJoSVJUeXpk?=
 =?utf-8?B?UlplS09oK21PaTg1eWM3VEwrblI2ZDJwZHhiVExFbGdXRHJTbnBFYnpndDR6?=
 =?utf-8?B?M1BGM2cxWlB3TlFDSGoxb21hUUNKUm05K1EzRGlreDZyY2FPZHJQcXhtdkxO?=
 =?utf-8?B?S2hjVVZMS0d0VUNRZXFHYTdFMkg3RDVTVmVrMUl4ckg2ZUZ5ckZKQWZwbGlv?=
 =?utf-8?B?ZTFmV0ZEcnc1UWV1Tzk4UUd5K0gzOS9EUkQvMFhkeTBsM1dERnpwdVNqVFZt?=
 =?utf-8?B?aVNEbHpWUkpQSDR0MDV5Q2FVSWN1N080aW5GMGRpaWgvaVRYL3I4ZDFLdUFE?=
 =?utf-8?B?WjB1S0xZYzJJdU1FdzVWeml3dHZMUjV0enhEanBncXpwQWJxQjI1QVBodmZm?=
 =?utf-8?B?a2tZZWd5U0J0YUg5cThhREx0Ulc0QzBjTXZQbzJCWEljMXRLWXpCNnFZazJD?=
 =?utf-8?B?UHA5T3ZPYjhQSXhIZXZScmtBdVlFMEVqZ1RlNjdKRXNSdDJWQklZMUx6M0cw?=
 =?utf-8?B?citPNElJV1M4K2wrRU13YStPVyt3dHErcTRlTzIyMTlQN1Uvd3AyVTBiU0JM?=
 =?utf-8?B?WHJJVnpPWUNrcmQwcjNiWk91R3A0a2xHV0FMTm1WbWxYSnBEcWxOUW55T0pt?=
 =?utf-8?B?MWE0NHdydHZidDRCK3oyZWdtYjh1UjZUai9TZjRhL0ZnbXdJd0FZazkxaHZ0?=
 =?utf-8?B?S0xaYTdvMEZtMlB1S3Uva0VPcHIzYzlmUlBHNjdkdHB2MFVxc2k1cVlmWkhQ?=
 =?utf-8?B?RkRNVVVkMkI2bXJ5bDBpdDJoTlhWa1R3UDhpTzdCUGJaSEZvcEJXcmdZeVlI?=
 =?utf-8?B?dnRaSEltcmtzNGpBTnhnMExjdnJCaTN6YnlUU3FBdVhob1UrL3l5b2NrWXc5?=
 =?utf-8?B?TytkM0lUamlHcnBYOS9ZRnlXVXRKdTVkTHNZZHFNSG5qMitsLzMvSXpJUXYr?=
 =?utf-8?B?R1JLQ3BiRGo0NWRRam96bGlnVWw0L1ZoM013QlJFcGozV0UzOVlmRmJLaE5z?=
 =?utf-8?B?UFZKV1VZMWxLTW5YMy9uVzZ4MkhoU2tUNWJFaGFvS1NZT1ErS0JmbFFvTG1w?=
 =?utf-8?B?YVk1M0F2RnJkNStJbnUvSG1TQUNLMjBGWk0zb0c1M1owR0tqODhXWGVkcDkv?=
 =?utf-8?B?Z0dRQkhPSzFlRU5zSThOZnNFeU5GYklkNU40VzdXNCt0c3BzZWgxUm1ZSDhF?=
 =?utf-8?B?VVhscHZMNjFXc3dOdzRvUT09?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR19MB5411.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?cHhMZVg0ZVVBdlk4QURQM3FLWGxWMVF3d0tXbjBiMmVSSWZneUswa25wMFJx?=
 =?utf-8?B?RXJESnNSTU9kZFJOVEpLWXhjOXNDdkdLQTlhckVqKzZIYVlyZFA0K0ozeE54?=
 =?utf-8?B?WnFYZGxQamRHL3UxLzBLdk43Q2xaVUUvRFZrZTVzMU4zUFZCbVJHR1B2Vnpx?=
 =?utf-8?B?Q1grMlErRTBUTHFEWVNGS2xON3d1NjlGemh5Yk1wdndwa1ZLMG8xSk5UNmta?=
 =?utf-8?B?VkNQV3l5dWJGVThWZTRUakVBVDBwSDdXcEtqUUlHUkxvNnFDaTVoa1hhRDhj?=
 =?utf-8?B?WUltOThiQi9LNmZIWm8xMEN6TEljOUd3a2pnWHB0OFJ4aVQxazJ3STZWUHNL?=
 =?utf-8?B?MUFDb0IyUThBbjU2NWFqdTBSUTVsd3RCQitjTVZadlduenI1SEJBYXRKdmY0?=
 =?utf-8?B?clNMRHNPOGZ4dW5PTEhlaUNjNHNTVkYxY0lYeHlDeER3dnp3Mmk4SkthUVhj?=
 =?utf-8?B?a051bE96eXFWNkdxUTVQNi9kelhlM1NnR0ZvVktIRlZLcStramV0TURwQXVq?=
 =?utf-8?B?MjBJbXNlSEVERmxyM1dDVExacEdyYUt0T0NvSTVOZkJ1SzJEK0tNdE51UCtT?=
 =?utf-8?B?M0pUR21HZ01PWkJib2k1N1B5YmZMKzEwbklRNjhITlQrcFdxd3BwR1J2ZnEz?=
 =?utf-8?B?T3RkUlg4MkxUbUxSR08yYTRvT2xCT21SRGNWYjFQeFZhT0pSUnFNTW8xcFZU?=
 =?utf-8?B?RUNUaFNSeUFaQW1vVXltUnFaUXdycTJzU1dRemxkbjF6bjAvellWTmNtanQw?=
 =?utf-8?B?VXBNNzVMNjN6a01CZ2VzOUU2R3lTTFYvc1RyMVNJZGZuaDBtRi9VcitwZk1G?=
 =?utf-8?B?YlFKMW9IV2dUREttWG9FWHBGc3Z3cjczNHdGUDZCUXRRWldlajNNbzg4Rk5h?=
 =?utf-8?B?SWFzQjlmTDNrSkd6TFcwZzBXR2VPOSt4QmdUOTNsOFByRjBtZnMwWFcxZmdJ?=
 =?utf-8?B?ZFd6NmQ5b0xSdUswS2xzSTBDZk9ZRWxRVXYyWHNibDhNSVpSaklObzVUdWN5?=
 =?utf-8?B?OXpLUmEvbU9Za0lFdFFxNEJsYzRrMFc3TGN3OEJudnBRdHFCaG5kMC96NW5J?=
 =?utf-8?B?VVM2UUpCaDB2ZTl2cW45NUEvTlNxaDhCY2FEOFFlR3dRMUR1Y0plRU9SSkow?=
 =?utf-8?B?L09UOFU5NVJnQXhCWkh5TlhEaHlXQ3BXaHlrbUxEWmpUSC96c1lYbS8vSjU1?=
 =?utf-8?B?T0RLRWdRZEdJZEgyYUR5aHhWZG1VQ3Q4aUs1UDZ0OHpwRWRwVXlTaVY0aFZI?=
 =?utf-8?B?QjRqa0Z4cHdqTERrZ2tqUXZwT1VJVG0zeUtjUWl0NVBBMXdDT0FzMWFjRmVE?=
 =?utf-8?B?djNpc2pCaFdQWm5hSFhCdE94MnlzdElqanBDY3l6Smg0WE4yNU1FRTlscldL?=
 =?utf-8?B?S041THdCK1dUV0J0dWZDSEVJUThiUmM4UUdjK1lvaWNUMkFLMGNoYkJTeVY4?=
 =?utf-8?B?ZlFBRVBmZ1grU2tjejdIMENabXRZRDB5VHhJUTFYc2lLMlI2cmNGS2ZQNVNX?=
 =?utf-8?B?dmd2VWNuZlB0ZE1BeWxGMW9uTXNsY0ZKOGt2bDY5NUdBTHUxOExmS2I4SG9U?=
 =?utf-8?B?RTR2bEZTVzhWbGxiL3l4YjR0Q2FYdlptWS9zdnhjTmpYN3ZUSjUwRGhLSnEr?=
 =?utf-8?B?TEN4bHVCYXpORmx3aVNMZFlqZzNjRlA5K2JJZ3FiZVh3NDVnalR2a2h5bFZF?=
 =?utf-8?B?eHdZWDJzajRtU2l6bm1xWEljZzJWbkJudnphMlZQT1hZdG9NbFJoYjZrT1RE?=
 =?utf-8?B?dEphc3l3VEZyRkZJWjNDWnpUeDNUakMrMWFhVVk1KzJhQkpySEVWUk13Ri8w?=
 =?utf-8?B?YjdoS3JjWkx1WnVqL3JzTDZMNmdHazV0SEtIWGsrcFhYYVU2K3dqT1RSazJI?=
 =?utf-8?B?bUl3MmxjNk9jNUtuMWRCRUFGazh6N25qUk1iWER6TUpLdjh6OWF0TERLQkVi?=
 =?utf-8?B?OU9HbkJIUXhVWVVNdTdnUlVsVXA1M2ZsMm1LTEVLNkJGZmlkMHNLYnlGV3Fa?=
 =?utf-8?B?STY4NDFhdjJrdnRHTGJOa0dCVTFUbExJelB3OHZYVkIrOTA0Y0o5YU5rdUFH?=
 =?utf-8?B?anVwK2phN2M5SVB5Q2czTVdUV0hQQWN2WUdzWlRGUUVzK0E0YUJiUUc1N1RG?=
 =?utf-8?Q?TyvY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR19MB5411.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7738f261-d761-49a8-bc76-08dc6e71eec8
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2024 08:44:39.5847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZId2q926ALCq0l8y+C54tEq31/zqOeGWraGONb17h2Hb+ZgcJeWR/JdH+CaZn+/NUWnMAfvmRHGGCyuTRNhYHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR19MB5257
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_03,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 impostorscore=0 adultscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2404010000 definitions=main-2405070059
X-Proofpoint-ORIG-GUID: -7SI70UqAhMaImI4omPuBhXCzbieRhDK
X-Proofpoint-GUID: -7SI70UqAhMaImI4omPuBhXCzbieRhDK
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 impostorscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070059

UmVzZW5kIHRoaXMgZW1haWwuDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJv
bTogTGksIEVyaWMgKEhvbmdnYW5nKQ0KPiBTZW50OiBNb25kYXksIE1heSA2LCAyMDI0IDk6NTAg
QU0NCj4gVG86IEpvaG4gR2FycnkgPGpvaG4uZy5nYXJyeUBvcmFjbGUuY29tPjsgSmFzb24gWWFu
IDx5YW5haWppZUBodWF3ZWkuY29tPjsNCj4gamFtZXMuYm90dG9tbGV5QGhhbnNlbnBhcnRuZXJz
aGlwLmNvbTsgTWFydGluIEsgLiBQZXRlcnNlbiA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+
DQo+IENjOiBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSRTogSXNzdWUg
aW4gc2FzX2V4X2Rpc2NvdmVyX2RldigpIGZvciBtdWx0aXBsZSBsZXZlbCBvZiBTQVMgZXhwYW5k
ZXJzIGluIGEgZG9tYWluDQo+IA0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4g
RnJvbTogSm9obiBHYXJyeSA8am9obi5nLmdhcnJ5QG9yYWNsZS5jb20+DQo+ID4gU2VudDogRnJp
ZGF5LCBNYXkgMywgMjAyNCA0OjMzIFBNDQo+ID4gVG86IExpLCBFcmljIChIb25nZ2FuZykgPEVy
aWMuSC5MaUBEZWxsLmNvbT47IEphc29uIFlhbg0KPiA+IDx5YW5haWppZUBodWF3ZWkuY29tPjsg
amFtZXMuYm90dG9tbGV5QGhhbnNlbnBhcnRuZXJzaGlwLmNvbTsgTWFydGluIEsNCj4gPiAuIFBl
dGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4NCj4gPiBDYzogbGludXgtc2NzaUB2
Z2VyLmtlcm5lbC5vcmcNCj4gPiBTdWJqZWN0OiBSZTogSXNzdWUgaW4gc2FzX2V4X2Rpc2NvdmVy
X2RldigpIGZvciBtdWx0aXBsZSBsZXZlbCBvZiBTQVMNCj4gPiBleHBhbmRlcnMgaW4gYSBkb21h
aW4NCj4gPg0KPiA+DQo+ID4gW0VYVEVSTkFMIEVNQUlMXQ0KPiA+DQo+ID4gT24gMDMvMDUvMjAy
NCAwNDoxNSwgTGksIEVyaWMgKEhvbmdnYW5nKSB3cm90ZToNCj4gPiA+IEpvaG4sDQo+ID4gPg0K
PiA+ID4gSSBhZ3JlZSB0aGF0IHRoZSBjYWxsIHRvIHNhc19leF9qb2luX3dpZGVfcG9ydCgpIGlz
IG5vdCBtYW5kYXRvcnkuDQo+ID4gPiBJbiBmYWN0LCBzb21lIGxvZ2ljIGhlcmUgaXMgc2ltaWxh
ciB0byB0aGF0IGZ1bmN0aW9uLiBXZSBkb24ndCBuZWVkDQo+ID4gPiB0byBkbyBpdCBhZ2Fpbi4N
Cj4gPiA+IEJ1dCBqdXN0IHVwZGF0aW5nIHRoZSBwaHlfc3RhdGUgbWF5IG5vdCBiZSBlbm91Z2gu
IEkgc3VwcG9zZSB5b3UNCj4gPiA+IHN0aWxsIG5lZWQgdG8gYWRkIHRoYXQgUEhZIGludG8gdGhl
IGNvcnJlc3BvbmRpbmcgd2lkZSBwb3J0IGJ5DQo+ID4gPiBjYWxsaW5nDQo+ID4gPiBzYXNfcG9y
dF9hZGRfcGh5KCkgYW5kIHVwZGF0ZSBwaHktPnBvcnQuDQo+ID4gPiBKdXN0IHVwZGF0aW5nIHRo
ZSBwaHlfc3RhdGUgbWF5IGF2b2lkIHRoZSBwb3J0IGRpc2FibGVkIGluIHRoaXMNCj4gPiA+IGlz
c3VlLCBidXQgb3RoZXIgbWlzc2luZyBwaWVjZSBvZiB3b3JrIG1heSBjYXVzZSBvdGhlciBpc3N1
ZXMuDQo+ID4gPg0KPiA+DQo+ID4gSWYgeW91IGNoZWNrIHRoZSBjb21taXQgaW4gd2hpY2ggdGhh
dCBjYWxsIHRvIHNhc19leF9qb2luX3dpZGVfcG9ydCgpDQo+ID4gd2FzIG9yaWdpbmFsbHkgYWRk
ZWQgLSAxOTI1MmRlIC0gaXQgd2FzIGFkZGVkIHRvZ2V0aGVyIHdpdGggdGhlDQo+ID4gY29tbWVu
dCAiRHVlIHRvIHJhY2VzLCB0aGUgcGh5IG1pZ2h0IG5vdCBnZXQgYWRkZWQgdG8gdGhlIHdpZGUg
cG9ydCwNCj4gPiBzbyB3ZSBhZGQgdGhlIHBoeSB0byB0aGUgd2lkZSBwb3J0IGhlcmUiLiBIb3dl
dmVyIHRoZSBjb2RlIHRvIHNldCBwaHlfc3RhdGUgPQ0KPiBQSFlfU1RBVEVfRElTQ09WRVJFRCBh
bHJlYWR5IGV4aXN0ZWQgYmVmb3JlIHRoYXQgY29tbWl0Lg0KPiA+DQo+ID4gV2hlbiBhbGwgdGhh
dCBjb2RlIHdhcyByZW1vdmVkIGluIGExYjZmYjk0N2Y5MjMsIEkgYW0ganVzdCB3b25kZXJpbmcN
Cj4gPiBpZiB3ZSBoYXZlIGtlcHQgdGhlIHBoeV9zdGF0ZSA9IFBIWV9TVEFURV9ESVNDT1ZFUkVE
IGNvZGUuDQo+ID4NCj4gPiBBbnl3YXksIHdvdWxkIHdlIHJlYWxseSBqb2luIGEgd2lkZXBvcnQg
d2l0aCB0aGUgZG93bnN0cmVhbSBleHBhbmRlcj8NCj4gPiBJIHdvdWxkIGp1c3QgYXNzdW1lIHRo
YXQgd2Ugd291bGQgYmUgY3JlYXRpbmcgYSBuZXcgd2lkZXBvcnQsIGFuZCBhDQo+ID4gc3Vic2Vx
dWVudCBzY2FubmVkIHBoeSB3b3VsZCBiZSBhZGRlZCB0byBpdC4NCj4gDQo+IFtFcmljOiBdIEkg
ZG9uJ3QgdGhpbmsgdGhlIGNvZGUgcmVtb3ZlZCBpbiBhMWI2ZmI5NDdmOTIzIGlzIHRoZSByaWdo
dCB3YXkgdG8gZml4IHRoaXMgaXNzdWUuDQo+IEl0IGp1c3QgaGFwcGVuZWQgYXZvaWRpbmcgdGhp
cyBpc3N1ZSBvY2N1cnJpbmcuDQo+IEkgdGhpbmsgdGhlIHJvb3QgY2F1c2Ugb2YgdGhpcyBpc3N1
ZSBpcyB0aGUgb3JkZXIgb2YgZnVuY3Rpb24gY2FsbHMgdG8NCj4gc2FzX2Rldl9wcmVzZW50X2lu
X2RvbWFpbigpIGFuZCBzYXNfZXhfam9pbl93aWRlX3BvcnQoKS4NCj4gTXkgY29uY2VybiBoZXJl
IGlzIHdoZXRoZXIgb3Igbm90IHdlIHN0aWxsIG5lZWQgdG8gY29uZmlndXJlIHJvdXRpbmcgb24g
dGhlIHBhcmVudCBTQVMNCj4gZXhwYW5kZXIgYmVmb3JlIGNhbGxpbmcgc2FzX2V4X2pvaW5fd2lk
ZV9wb3J0KCkuDQo+IFRoaXMgcGFydCBvZiBsb2dpYyBpcyBub3QgcHJlc2VudCBwcmV2aW91c2x5
IGFuZCBJIGRvbid0IGhhdmUgZW52aXJvbm1lbnQgdG8gdGVzdCB0aGlzLg0KPiANCj4gQmFjayB0
byB5b3VyIHF1ZXN0aW9uLCBJIGJlbGlldmUgd2UgZG8gbmVlZCB0byBqb2luIGEgd2lkZXBvcnQg
dG8gZG93bnN0cmVhbSBleHBhbmRlci4NCj4gQ2hhbmdpbmcgdGhlIHBoeV9zdGF0ZSB0byBQSFlf
U1RBVEVfRElTQ09WRVJFRCB3aWxsIHNraXAgc2Nhbm5pbmcgdGhvc2UgUEhZcywgYnkNCj4gbm90
IGNhbGxpbmcgdGhlIGZ1bmN0aW9uIHNhc19leF9kaXNjb3Zlcl9kZXYoKSB0byBzdWJzZXF1ZW50
aWFsIFBIWXMgd2l0aGluIHRoaXMgcG9ydCAoc28NCj4gdGhpcyBpc3N1ZSB3b3VsZG7igJl0IGhp
dCkuIEJ1dCB0aG9zZSBQSFlzIGFyZSBub3QgYXNzb2NpYXRlZCB3aXRoIGEgU0FTIHBvcnQuIFRo
aXMgbWF5IHRyaWdnZXINCj4gb3RoZXIgaXNzdWVzIChmb3IgZXhhbXBsZSwgYW55IGNoYW5nZSBj
b3VudCBjaGFuZ2VkIG9uIHRoYXQgUEhZLCBvciBTQVMgdG9wb2xvZ3kgaW4gc3lzZnMsDQo+IGV0
Yy4pDQo+IA0KPiA+DQo+ID4NCj4gPiA+IEVyaWMgTGkNCj4gPiA+DQo=
