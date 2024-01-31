Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98B3D294
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 02:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706668442; cv=fail; b=CBKgkgu9bU9IQRBd88jXYsbHBSZiAl/RjTSH2GpKhBo/jE2Ehvh15bRKeBhVv2qDBgglzONkArdMDifzGh/CnAP26JXkaB6GCsD1N4z9/CzAwBGELcKcQdSk4PaJjO81Kq+KQ/Llw8ReA4EEvqjxs1vrb+1osgTVAjHWR/ssi+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706668442; c=relaxed/simple;
	bh=VDEVulZhXHcsXKx1QlSbg64rFOgOeEVu7JVtUVt1dVI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mOGfFW/mbRbo/jQLjefXLjyRUqrtleT+KPxoWdelKQ6oki759eyziJEwUz8vTeIWcsSpkbu5OM8UTRlt9P2HocmxEgnWe1ajiznHLFiQxPGt/voHzUvB/4+wlLljEhwwWs7G1bBAXteB92ITdkwy3GHHCOQ2Budz0in+49o7hgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dw+mKLgA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=O/G86+mp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dw+mKLgA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="O/G86+mp"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxjC3030554;
	Wed, 31 Jan 2024 02:33:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=Zh9Pb+C7kGt+eXLKKrwKx31kgFhP8VMMZ+4CStmQ1X8=;
 b=Dw+mKLgAx+Twfb1ndwzNVu/OggX5CTiD854JXrdQ9KV9yknT1IPRrZLrTQhm+t/YfuGT
 XHdzu+g52eIranSaPEL7kRX9aejs4czqHCnu3NI8biaQsNrEnT2FSUVLDRCfzYzGjIfs
 iabFfOUTrlFOp2TWXM/Rx4GFYUBs2CLiYxCx6T/c2U8A8JMubwQ3eFVuCpn0/g0skkO5
 d63ID0jOqCHNrODPhXegqvvIduaCa+VV3DjuEcmjyi71iLVA79QJ+i0HcG1Fpgu99tRG
 nYosj/V60ECSUNfe879fPVbrZ1nimwgusp/r6jm1NnxsZeQ+pa6Qe7Zx87nsN2cpwQ1N jw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvsqb0khu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:33:57 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40V0HP5O007770;
	Wed, 31 Jan 2024 02:33:55 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9enakb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:33:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Le39b7WEXoPVOGcct7Bh7qANlEwPBxVnkvlxv7Lt5ez1umWo5UQgiCDfEJvQQ1nUoOnAwVcME+3ewLUsb8Xzg2JvSgCQnUTMxJDXaJLrSIiwBDZ7r0PjG1F+RN/4h4s45u1v64bzBP8qiAOFPTCi2ra8T8GlMlIT0FRRs9ydxx9t4uhK9hBwOJQ1DsZKqUqI5D24+RK7yU1XdlST4qhLPZne/+ZuTzg4bM9gKlQu7OFmkWjk4Xn17UtjtJ9w77piU/iQ8O1bqtoIfcetNtvfr8HSSzOqByDf8ZGRyYzAjqn2iducJ660zg+NeA3gpZU9SOisF2SauG1ziTN+XBIpKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zh9Pb+C7kGt+eXLKKrwKx31kgFhP8VMMZ+4CStmQ1X8=;
 b=bbgMb2oZNezYNHIHoH9JSx1yDizogdXbZ7uLb3nu47ScvaQwyApF9fpZCW5Ou2HrAGI/GG13aSU+0Rgslthlx+69P7uMRYW6+arUXHxEkNoI4Y3BhfdmP+cR6xXbdqUEVqSIOJ4qBC4eqaBot312X/Nl6KAM9h3wwL+9IaXO8qX4eAKm4WSjH2MNm3XHWKUeNCRzHjbJA1EHGcNSEZf5ZmP13MPd3aM1+DGO5p237OhDyEurQsiLUk5n+NK8D8sv/FM6/RtgDy4GRja6GADoTLf86liJr9AAxtmgbLTyFZNt9v+0UxZ/H3ygsxDfcgxfo7qBevhEgbEz2ojsMEFAVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zh9Pb+C7kGt+eXLKKrwKx31kgFhP8VMMZ+4CStmQ1X8=;
 b=O/G86+mpF5qZKjQd80rTzlN4ew578GTeBjOlrIqQ+epbbI51k0XBBY2/5yePOOU2kk3yhGi0LpGSt9E45Cw1gPEsH3RGYfahiMNnUs6tyeyC4jVz58tLVOcJjvNybdXLIOTGk+OteSO5TwrqDSKQJRTB4uE8BxU9fTqRlT+eV4A=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by MN2PR10MB4159.namprd10.prod.outlook.com (2603:10b6:208:1d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Wed, 31 Jan
 2024 02:33:21 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 02:33:20 +0000
Message-ID: <a754e8bc-e75b-487f-8619-a4a01f1fe805@oracle.com>
Date: Tue, 30 Jan 2024 18:33:18 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/17] lpfc: Copyright updates for 14.4.0.0 patches
Content-Language: en-US
To: Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, justin.tee@broadcom.com
References: <20240131003549.147784-1-justintee8345@gmail.com>
 <20240131003549.147784-18-justintee8345@gmail.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240131003549.147784-18-justintee8345@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0195.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::20) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|MN2PR10MB4159:EE_
X-MS-Office365-Filtering-Correlation-Id: 25e24a63-1314-4306-d7c4-08dc2204fd69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	sFMXoA1zxVYDKkwqGCXquQ7ncCH3Gk8Aqm6iJyN3rFFWLEligWXcsKH3YnK3By1nrV9NKG3DGxhF1+8DL4yuBpwtTh/9JBUsTGsr2KznpGfnap1As+mGO5UYUf05b5vi12CQVoe8JMHDfhDwlD0H5e3j7b3VplPtXGwyj+oHFN0p6U22ymjXnp1i4sj0qyw5ez5ocN/032HNgUnvKsbLRlJwt2zcr60HjqosJkzwbqaW5GJBAZXnLot+JgXtbe5ZEvM97kuJLRcZ2stfXyTMtBCqcz50dpSWtFdI8iNWATVcrM4o7SSmmBXludH4Gq3nWCSgNY/svQxyYopTZS4MmWUxTxJRJ1XmqHZLbZhBu2IujNVaF2s9J8eSjdWB7gwyCqrL1tU1ADJwVGW8R/CH3oXYU4FqEziZvBKFxXTh3d+bFW6EOWdCFB4s2X8pxYizkM9n/AT6IxjZ1NSC4uXZpARz+hHrq5XFmmotfPC3DVjJ+WxAIpo/7a4AQ6ZlZqWLKOTegXrOEuoqP6lI3PwNPkUySLpxiS6e/wwxj4SnH6rEr2EJkiRqzvjHBpu/vrfEyRT/eLUB4L+DMmsRb+wL01y3merMZJrlRZA7xNnS/8neP+yYtZIYy2VNY99Pw0qQPlcVrgzoHLPfkEAdlQCsqw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(136003)(346002)(366004)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(31686004)(30864003)(5660300002)(66946007)(26005)(6486002)(66556008)(66476007)(2906002)(83380400001)(15650500001)(53546011)(6512007)(36916002)(6506007)(8676002)(478600001)(8936002)(316002)(44832011)(2616005)(4326008)(36756003)(38100700002)(41300700001)(86362001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RWpQR2JKaUEvTUw2MnlIeUswVnBJOUZ2QXpQRW93MEZiMDN4VVlMd0FhOE9C?=
 =?utf-8?B?TFBKZC9UcnZoVVhBT3BnMlMyc1Q5b0VoK25uTDVTN01LazNvS0Fjb21oVytD?=
 =?utf-8?B?YUlWanpzRkdMVWE0MWYrY3oxWURySWVpMU5rcWNPTllNRyszVXdhRzl6a2w3?=
 =?utf-8?B?a1VaYjJBU3g2a2psdy9RNUt5eitlUmJERERaZHhLNmZLOXorbzI5Smd4N0Z5?=
 =?utf-8?B?OEJCMVI3ejNPVjVBeW5NS0NVSVdYUFU3cjJ5YlIwbUxCWElwT2dKejFvNTJE?=
 =?utf-8?B?NUpQK1llQkZrK2RxanV3Q0w1aHBOcDBDNGdxRXdxTnp1MnYrMXhyN3F3U3VV?=
 =?utf-8?B?RHpJZWJaRDZwS1hXM2MvcDluSHh3OGdNY1o4a3VBZkN0VyszNHdnRFJVazdi?=
 =?utf-8?B?ekE1azBBQW5uZW5rUXk4QVNXbFFUL1pXZDNNV25wOWE4QWFaRlNwN01JYlZu?=
 =?utf-8?B?ZzlvbkdMRDVSZ1A4Q3owNHlabkRWQjBaWmZhTFNvbk95S2FyWERRN1ZWellT?=
 =?utf-8?B?M2dNUFZCVzdxQ2ZVQndJSHhZeWdGbUdrTE9mSzlHTGsvc1daK2FlVmwrWVdq?=
 =?utf-8?B?K1JFa1hKQ01XYjFnVElDVnBuaXFvSlJBZS90RVpjK2NCeU5RcUs3bnp4U2dH?=
 =?utf-8?B?WVgwRTEydGN5N01odUNyWDFWUW9SaVlGY1pnQ1FZTlB1Y3RaaHRneHozSnFr?=
 =?utf-8?B?dXp1Z2NkTTZ5SHBDaEp0ZHVNdkRBQ2ZjYkE5TVJPYlQ5TzlqR2N6ay96WnhT?=
 =?utf-8?B?Um9Yc1k4ZUFKUnFpcmxyc2c5V2Q0bGtCcndQM3pTNm5Zd2hvUU9NdG16SlRZ?=
 =?utf-8?B?ci8zM08ycHR2RTVhYzkvWmd2TkUra2pkSWNJUStoMkw5UVd6ZGRrbmtRNnM3?=
 =?utf-8?B?ZStEQmx5ZU5JN1RWM1Z3dWx5ZUhid0swMkMramlyZGJ2RGkxdVlVclBSVUd4?=
 =?utf-8?B?QlRqTnlJYmt0UVl2VXkrclVCeldRMGdOZ0NpRDhGQ21wUHZsaDJmWWFNeFJl?=
 =?utf-8?B?OTVKVEs4eXlvV051TzJUS3BzTlJzNzgxQUFsaG9GMFZPeDg3TTB6blIrangv?=
 =?utf-8?B?UnZ0aE05VkdzWWFrZDRwY1gxREczYnRuaHlJQVBmdzlGbE5Yc3ZjR0tqOGhC?=
 =?utf-8?B?dGxUcW5wWTIxLzc2azJSS2dpMzRKNFBPSWNjWENUeGhJTHkxZzdCUzNsMjRm?=
 =?utf-8?B?cXZyVGdDTFA4RFlVRFJMNXRxZzlRR1lUczFZLzVIOTlLSXRSZG9oR3djQWJz?=
 =?utf-8?B?L2grR0lvWDI2bnZaWlNmMTZCUXFrWHV2cXU0c1VWSkNYNERKdWxPbG1PWlBT?=
 =?utf-8?B?Q0tUTTdNVXNmbmJvcEpSZ3I0MjYxeEFwZ29MMjJmMGEzTFZrUU5ESzIyUmEx?=
 =?utf-8?B?K0tDTE15bnhmVkxlZ0tlcW84bytwL1FJelVadkZEZStURWVtbk5SdERsOXd0?=
 =?utf-8?B?WlA3QmFMZjJNbWErTXpHcEl5emdRaE1hRXA1bzVMZkkyKzlYT1ZYMGVMNWRG?=
 =?utf-8?B?WTdBRi9JQS8zVXpPYTh5ZkVrWExSTWhsZzFRRFhqb0RXbVp6cHEvNTNUdjJv?=
 =?utf-8?B?UERMSHkzMy9kckVMVHorY0xwRm53c1RmVlRwbTZmaDFVbjZodHpmMXlDSmZ2?=
 =?utf-8?B?cWVTMUJDTTRZZ1pxOWVPdEJqT2hUSGNWRXB4NmRSTU1ZbkcvTVc4TER5WExs?=
 =?utf-8?B?dHFDUUtMelluSUJSdzFJemVaVS9meFRoWlFmaWRZNHM4WWN0bEptcDBJWjFu?=
 =?utf-8?B?WXp5WjdKWDRkTnJBeDlmN1hoSzlQaFdUdUR3blVqUDBMMWswOCtXWWV2UlZD?=
 =?utf-8?B?QXNrZWpCWmFKcE8rMzBKcUV6bXgxazVWMlNmODVydTcvU2ExN3R2RU1HVmRM?=
 =?utf-8?B?eUJNMlg1aGtKM1dqMFltL2xDU3J4QUZ1TmozbWRBWnlYc0U3ZjRUdDIzbzdq?=
 =?utf-8?B?alRuUSs3R2grWTFxd1VQY1Axa28yM2NyT3JTdlZFaWlBa05pUHRPMlVCMUZ4?=
 =?utf-8?B?SEVoTWF5RUtCSUx0elpveWdaSVZhbks3QmFuWkx4bHkwVEdPZm5kNzNNcjRt?=
 =?utf-8?B?WXJ4M09GWWxud1FjVkNzWE1hWmQzNGxoa25iN3plS3FWdmRtTm44KzZDbWNs?=
 =?utf-8?B?dVo0cnJicUZuTzhYY0pyRDFNOHhLbDlaN1UyS2V5YVVyYTZNTFUvWjlDd25u?=
 =?utf-8?B?dUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Uh0R/J834gdcUpf94A92h+u5P3uJykv3ZFoyVVAkDKcOVg4TYD2PYUZZ7vLT5pBn85+51wwH4YHDh+WSmVCAXTeDFO6SdNaMtNbu6XeyPKzXxO8ppND6LlXLLNGcLUjJ70+lcu/6h4xAtecImr/BqMNU2D089XYwhLF7VIIu+zPCMVRgSYY3tPN1yo6b3sHWahtZyQJSExHFHaOGRtVnrhgsIa8AnP+XMSy9U8GnQpTatG8EAxkliH0nBY1rz/Lt8zJCdNWXmE5t2uqjgUVLPrBvCOpDywZ6bqMGxzXNv0UodIPJGJVOqW5bs6cbynKhAuN306Ogxu16gvd0sD7aJyqu9WNqUli2ijNZbU8GsLG1aPVqtHh08lT+8G6eqfvf/27ObtEPwLfConkwRRNNe+n/iQX8HnW8+z86/Dv6Olr5Q7jNHf3N1OAZP9ZAJx5EhYwjvpA6v6/dMGI9driTmHePoHxoKdP+CgCgwLqd+VAFg3QEzZA5fkznRrZknw0qfSoHX+e3cWqXhAnsJIKM3StWF8FEqFb4pBpFLFasGkog32m2HRxP5u3UdWxXcblMiikt8VLhPKeISjCHLHYcGMK6fuyexiqbrSQdAGr/+uU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e24a63-1314-4306-d7c4-08dc2204fd69
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 02:33:20.7906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mko1qssMdkZQW4whUaoVv52OxHTPAiHNNLF4QoMLVajQ9GxRYr6UtO9Y0gW2+tnCIfQLui7muHLYkPDszLmJbJLDr8jUZ8e6bYCq630+JRY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4159
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_14,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401310020
X-Proofpoint-GUID: wEt61x_oxaedfUIamPijITW71AvETGsi
X-Proofpoint-ORIG-GUID: wEt61x_oxaedfUIamPijITW71AvETGsi



On 1/30/24 16:35, Justin Tee wrote:
> Update copyrights to 2024 for files modified in the 14.4.0.0 patch set.
> 
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc.h           | 2 +-
>   drivers/scsi/lpfc/lpfc_attr.c      | 2 +-
>   drivers/scsi/lpfc/lpfc_bsg.c       | 2 +-
>   drivers/scsi/lpfc/lpfc_ct.c        | 2 +-
>   drivers/scsi/lpfc/lpfc_debugfs.c   | 2 +-
>   drivers/scsi/lpfc/lpfc_els.c       | 2 +-
>   drivers/scsi/lpfc/lpfc_hbadisc.c   | 2 +-
>   drivers/scsi/lpfc/lpfc_hw4.h       | 2 +-
>   drivers/scsi/lpfc/lpfc_init.c      | 2 +-
>   drivers/scsi/lpfc/lpfc_mbox.c      | 2 +-
>   drivers/scsi/lpfc/lpfc_nportdisc.c | 2 +-
>   drivers/scsi/lpfc/lpfc_nvme.c      | 2 +-
>   drivers/scsi/lpfc/lpfc_nvmet.c     | 2 +-
>   drivers/scsi/lpfc/lpfc_scsi.c      | 2 +-
>   drivers/scsi/lpfc/lpfc_sli.c       | 2 +-
>   drivers/scsi/lpfc/lpfc_version.h   | 4 ++--
>   drivers/scsi/lpfc/lpfc_vport.c     | 2 +-
>   17 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
> index b863f87ff9e7..30d20d37554f 100644
> --- a/drivers/scsi/lpfc/lpfc.h
> +++ b/drivers/scsi/lpfc/lpfc.h
> @@ -1,7 +1,7 @@
>   /*******************************************************************
>    * This file is part of the Emulex Linux Device Driver for         *
>    * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
> + * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
>    * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
>    * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>    * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index 55289abb6cf7..365c7e96070b 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -1,7 +1,7 @@
>   /*******************************************************************
>    * This file is part of the Emulex Linux Device Driver for         *
>    * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
> + * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
>    * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
>    * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>    * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
> index 095914854dda..d80e6e81053b 100644
> --- a/drivers/scsi/lpfc/lpfc_bsg.c
> +++ b/drivers/scsi/lpfc/lpfc_bsg.c
> @@ -1,7 +1,7 @@
>   /*******************************************************************
>    * This file is part of the Emulex Linux Device Driver for         *
>    * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
> + * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
>    * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
>    * Copyright (C) 2009-2015 Emulex.  All rights reserved.           *
>    * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
> index 2a0c6a4df090..b30765b9689a 100644
> --- a/drivers/scsi/lpfc/lpfc_ct.c
> +++ b/drivers/scsi/lpfc/lpfc_ct.c
> @@ -1,7 +1,7 @@
>   /*******************************************************************
>    * This file is part of the Emulex Linux Device Driver for         *
>    * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
> + * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
>    * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
>    * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>    * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
> index 03abc401c5f2..ab5af10c8a16 100644
> --- a/drivers/scsi/lpfc/lpfc_debugfs.c
> +++ b/drivers/scsi/lpfc/lpfc_debugfs.c
> @@ -1,7 +1,7 @@
>   /*******************************************************************
>    * This file is part of the Emulex Linux Device Driver for         *
>    * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
> + * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
>    * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
>    * Copyright (C) 2007-2015 Emulex.  All rights reserved.           *
>    * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index d21178b5d093..90513bfc7ae6 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -1,7 +1,7 @@
>   /*******************************************************************
>    * This file is part of the Emulex Linux Device Driver for         *
>    * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
> + * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
>    * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
>    * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>    * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index f97817ac463d..a7a2309a629f 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -1,7 +1,7 @@
>   /*******************************************************************
>    * This file is part of the Emulex Linux Device Driver for         *
>    * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
> + * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
>    * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
>    * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>    * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
> index f6b1168304f3..367e6b066d42 100644
> --- a/drivers/scsi/lpfc/lpfc_hw4.h
> +++ b/drivers/scsi/lpfc/lpfc_hw4.h
> @@ -1,7 +1,7 @@
>   /*******************************************************************
>    * This file is part of the Emulex Linux Device Driver for         *
>    * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
> + * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
>    * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
>    * Copyright (C) 2009-2016 Emulex.  All rights reserved.           *
>    * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 345a7d5784d8..88b2e57d90c2 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -1,7 +1,7 @@
>   /*******************************************************************
>    * This file is part of the Emulex Linux Device Driver for         *
>    * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
> + * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
>    * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
>    * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>    * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
> index 162a0df8b60e..f7c41958036b 100644
> --- a/drivers/scsi/lpfc/lpfc_mbox.c
> +++ b/drivers/scsi/lpfc/lpfc_mbox.c
> @@ -1,7 +1,7 @@
>   /*******************************************************************
>    * This file is part of the Emulex Linux Device Driver for         *
>    * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
> + * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
>    * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
>    * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>    * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
> index 24f171045abe..8e425be7c7c9 100644
> --- a/drivers/scsi/lpfc/lpfc_nportdisc.c
> +++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
> @@ -1,7 +1,7 @@
>   /*******************************************************************
>    * This file is part of the Emulex Linux Device Driver for         *
>    * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
> + * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
>    * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
>    * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>    * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
> index c3daf158bc2a..09c53b85bcb8 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.c
> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
> @@ -1,7 +1,7 @@
>   /*******************************************************************
>    * This file is part of the Emulex Linux Device Driver for         *
>    * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
> + * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
>    * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
>    * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>    * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
> index 255189eda388..8258b771bd00 100644
> --- a/drivers/scsi/lpfc/lpfc_nvmet.c
> +++ b/drivers/scsi/lpfc/lpfc_nvmet.c
> @@ -1,7 +1,7 @@
>   /*******************************************************************
>    * This file is part of the Emulex Linux Device Driver for         *
>    * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
> + * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
>    * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
>    * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>    * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 07e941da8a16..81fb766c7746 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -1,7 +1,7 @@
>   /*******************************************************************
>    * This file is part of the Emulex Linux Device Driver for         *
>    * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
> + * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
>    * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
>    * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>    * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 1aad39015ee0..1f8a9b5945cb 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -1,7 +1,7 @@
>   /*******************************************************************
>    * This file is part of the Emulex Linux Device Driver for         *
>    * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
> + * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
>    * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
>    * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>    * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
> index 573c9721ea0a..56f5889dbaf9 100644
> --- a/drivers/scsi/lpfc/lpfc_version.h
> +++ b/drivers/scsi/lpfc/lpfc_version.h
> @@ -1,7 +1,7 @@
>   /*******************************************************************
>    * This file is part of the Emulex Linux Device Driver for         *
>    * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
> + * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
>    * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
>    * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>    * EMULEX and SLI are trademarks of Emulex.                        *
> @@ -32,6 +32,6 @@
>   
>   #define LPFC_MODULE_DESC "Emulex LightPulse Fibre Channel SCSI driver " \
>   		LPFC_DRIVER_VERSION
> -#define LPFC_COPYRIGHT "Copyright (C) 2017-2023 Broadcom. All Rights " \
> +#define LPFC_COPYRIGHT "Copyright (C) 2017-2024 Broadcom. All Rights " \
>   		"Reserved. The term \"Broadcom\" refers to Broadcom Inc. " \
>   		"and/or its subsidiaries."
> diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
> index 35dc6b74cb01..0f79840b9498 100644
> --- a/drivers/scsi/lpfc/lpfc_vport.c
> +++ b/drivers/scsi/lpfc/lpfc_vport.c
> @@ -1,7 +1,7 @@
>   /*******************************************************************
>    * This file is part of the Emulex Linux Device Driver for         *
>    * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
> + * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
>    * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
>    * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>    * EMULEX and SLI are trademarks of Emulex.                        *

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
