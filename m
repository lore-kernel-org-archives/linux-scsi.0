Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8943A12B86
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 02:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706668623; cv=fail; b=fdkDSM8vjhg6/CUgvYk/rbbjQmz4GrGcaRwbOd6fCWabNWe4iq3OOjEOf5yR7MfExeDIIkNK+7ZNpxvMg7z1qoY0rynRojLMzVJ110wwvx59HwWsS1USYiim1e1WlULFyRsPl7aDgolIM03O/YsG9AwxkPCL4co8Y6Db2xTelQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706668623; c=relaxed/simple;
	bh=RF07v8WZVd1YW7rkuRVELI1GMlZ3I2FyyuLi3pEUyO4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oAeCeuUiONBe6daIKmI+UodkHAIdjTzIUeFpGoGT+/LzLSZLfcBfu2N+p8kEo2TCKNh/8tO90va/sJ8Nf3BRVgSy/3huv9IC+8dPgqvQ8ka4FBtT43zREDTvBtuEDXCbhqgUAY2zrbC5OugabB9lFgp3I+pe2JS7eKbPVWhrjb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ISGs4KWq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kO1l/sFc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ISGs4KWq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kO1l/sFc"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxaec021724;
	Wed, 31 Jan 2024 02:36:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=h8F8scEEeU4IEQZ7n+Gcf7/bvkdGbV394BkJwfXjymw=;
 b=ISGs4KWqtVykTfU8yKsPFwHxSJiSjpssTFQolqj8Y/c2AtXmuVo8KRHGppEeoKCI++nL
 /D3mjrnSGltv8TJhrqOmE+4zP+f3rAteodBZMzx7L1jxC8znmRa89zM/wAD3AMVdRF8/
 dohffHxL67PZAVdk6Kg7b/J8Q9Qriii5g7S5R1gOvzy6YmU+5FL9VPTtdF519BUYzSKC
 Az4jHfWdBnwrtUwFMfRJfqKLV4iXcDmd/VeE0f6BdRI7nAJymoQDV6Dpj87XVi+a+aB/
 f/oiquetX9rD4Wvzl9pmdIRwMbprQ4IwjGHmtZuFvoPkisMPfalZ8yVnFKXBisww/+VV aw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvtcv0nkp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:36:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40V0Agcf035346;
	Wed, 31 Jan 2024 02:36:57 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9e5t0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:36:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aDlGYWsoJH/Rcz9G7NGhk+a85pGFIoqkygG8U0eiMkJRO5OAcmJNDiZSVdoyKxRtZhlMY3JZBpYkwpAzLVHa12BMvrxSCKgrlTGrYlQNAaIyMsn7e+3UAhqsPO2wKxfPRrVItwzpkZZAmOeuEqpf8+Dc2Suzvmpqi/ninEbJ+XAX/SCUBUV3BL2F8j0bsFcpA9vu8knT4Qiv3X48qcqwF0s5iQLK0CCcatvScWYvibiZUDzTcSeQRVC8JawZMPOOY6UHJjex8LSihMP3mcmjQD2mL4xFgYC98WiVhh7go7EY/Dq7h5zdHruxjdXmKKJVMiAbt6VEYcl4sKjANGza7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h8F8scEEeU4IEQZ7n+Gcf7/bvkdGbV394BkJwfXjymw=;
 b=B/j1Ytxe01HobwEi4U44jX1wTU2fLxDzRnCk6Ze/mCE6HxrMFucr+iJ53bTXKNa6r4mELpvnsCtnGAYpIO+vVFfUxps4mImnkGhc4/w5k2aOAxpzXw7TGEoMNPKu7gTjwgC9SkqDnV/fiyt4kj3FqCWnj7KQ/jCWXtUauzcnzdX4AqvvT1TprTAqieEPlhwxZVTYwB+0yYbaLOVk2bGQ3m81W27tboTBctsjvEVf87esCUAZi5I6ga1K1WFFVREfVEchmyTv6mmkLRyvljdzCZLixxNYnKTxHyMbGhaKAp5Nf0Ea6cRWcdPG4CIK54Z4Z61xUN9Hmauc2ZRXP669Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8F8scEEeU4IEQZ7n+Gcf7/bvkdGbV394BkJwfXjymw=;
 b=kO1l/sFcjwieRYAYZfI0Y2kPc35SRAfC8lvvJ0TpdGtURhIvKE8f2ZMCOzXTZxLoHdUT3q0nvftM5yc4cHL0JFakNA+ve0R5Q07X1+X4yYzFD2eEAMS0uaKQSNMNqxo3M4hwoFSpUiU3J+jtfwAIYjpPRtb0C5jafzW00nAMMr0=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by MN2PR10MB4159.namprd10.prod.outlook.com (2603:10b6:208:1d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Wed, 31 Jan
 2024 02:36:54 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 02:36:54 +0000
Message-ID: <81e436d2-9f42-48bd-a7ee-903893cb7334@oracle.com>
Date: Tue, 30 Jan 2024 18:36:54 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/17] lpfc: Allow lpfc_plogi_confirm_nport logic to
 execute for Fabric nodes
Content-Language: en-US
To: Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, justin.tee@broadcom.com
References: <20240131003549.147784-1-justintee8345@gmail.com>
 <20240131003549.147784-6-justintee8345@gmail.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240131003549.147784-6-justintee8345@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0287.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::22) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|MN2PR10MB4159:EE_
X-MS-Office365-Filtering-Correlation-Id: 69a94c2b-11b7-4613-a054-08dc22057cf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	HYhcWpm8bfgf11LS4dwk0APKgdAmLRJI+KR1elEWtekW8KX1mmtCvt2Tik7uEn+C8gx8xKQ3Jag7mhV80mUSqDrXmAWbx2u2jusYolqUAgbrI7Ee/MKjy4QJRFCzFFCKyFgcrDtFc6VXKuGt/D8QzTcNddEjMOXOwkwWAE+WWO3IJSkrfZh9nTfOZR2j76GHHcCG1Yz32pV7dlCZl1nsW78KMhKyHcwVEzWgLEtjHwKVRf3wesnAYCO84XUFg0/OZgsccgGK59MLkYScBjD7fj1mYsvXJ3/oF1MQ+WFF8k5+8Sn05dbwnbC3t1sA6qz03toJ5nAd2VCOeOAB7X0OO3JWUw6mn4J5b+5y1PrtXojM8JQ1oyrvhlhUbJC+4QsAgvnxDVIOxFy4tDkLMsPEOhuYP3tlvAy4NmbuB9Q/9THXIGk5URhy+u12Nb+2BH6H2OE2Gh80gF2nOvV3aFr4hPhdPr/tLeAbKB8kXnHrznZKEybRIv4BlkcnpFFFuvOx8XyZ9ifauzlT41PL4OqWyNDnGRrYQ9Yagrg/c9y9jjTrRtgk/YDHJNSE7UxEMPkFOVvFmisO3G3ET+eO8IS0uKsjCtvGAQqCa+69ifSQ9jeMbPary4CRPCO+0OStGegK2mWOlsfiiVeZiW479R4nqw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(136003)(346002)(366004)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(31686004)(5660300002)(66946007)(26005)(6486002)(66556008)(66476007)(2906002)(83380400001)(53546011)(6512007)(36916002)(6506007)(8676002)(478600001)(8936002)(316002)(44832011)(2616005)(4326008)(36756003)(38100700002)(41300700001)(86362001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Q21sN1BJYlc1MldIY0paRks0VDBoNnFVRWdKM2wrNk9aUmY2RXkvVVpoTEVJ?=
 =?utf-8?B?NVVjYnovZjNFUkJIc3JuVjFQRW5JdVkxdnJ0NFFIZDhZeXQ1V2RwelgwQ0Zm?=
 =?utf-8?B?bDBnaTkrai85UUZod09FRHVjVXZMM0NVK1A3eUFFam5NL0hiSUxjdCtzVGFw?=
 =?utf-8?B?cWlHR0FhV0JveTJQTWdDaDU5bHk1VG94bHZ2bTVzM1dDRjN4NUlxNWJxMVZY?=
 =?utf-8?B?WnppSUR5ZzNGZERmOU5aTXI5MHRFcnYwRHNqc3pHZ2FLZVhKbVplWWJwMmIw?=
 =?utf-8?B?aXBPd29vcUtqVkNtZjhsVHpkOCtMV1BVa3BPWW8vQlduSzNPdkgyOEJNNVdz?=
 =?utf-8?B?OHdMWEZXR2xHdGg4SWZuY2JJYTg3V1dvM3dvdytremNua2NqUEFXUlJIY0No?=
 =?utf-8?B?WkU2c0I0amhWNGNKTEwwa3djSmRVOFpSZFBPcC82c3hHai94dGRZSlpoVjht?=
 =?utf-8?B?ZFZ5bWpzNnl4WlhSYUZMK01ZZHNiaXg5ZFdRSmdRZ3Zuc0Z0Q1JBOFhOM3hp?=
 =?utf-8?B?QXpGaDlKT1UwL2NhVU93V1lJUWVPUG4rWEJtOHhLaWtXWDVHdmZkbHFZMGpF?=
 =?utf-8?B?bVI0TUxGdXhzR052L2lyZDNydmV5Y1JZRWp0VnJid3cvcnFOc2lHZDJjS2pD?=
 =?utf-8?B?cEd2S1YvQ0Y3VDRKd1RpNTZoQVU0ekdrNFhCQURFN3g1OGhFUm5nTXV5Z09x?=
 =?utf-8?B?c0lWVTc2WFkyb0tnS1c4VGZNa1FROUttZHlPT3NlRXJlWWUwZCs5S2JEdkNG?=
 =?utf-8?B?dXFIWERwRWpVcTZMcjg5TFZTRUErT2lpTGkvMndDWkp3azRGS3pqUkozYXlm?=
 =?utf-8?B?UW82N3F2L1ArYlptSjI1Zi9UQkcwN0tkZ2FYU05jcVVrYTJZOFlCYmhhM1hC?=
 =?utf-8?B?QjJyZ2NJUGYzZWtWREdPeXFzK0t5VktQdUp6WmtkbWZUazRKY24rSDdSWVJh?=
 =?utf-8?B?YkR3SWFSdmxLZk5JMUNYaXpaa1NFc0xieFVxRTM1cnMvaFRyZUc4MnYvS3No?=
 =?utf-8?B?L1FYZWJ3WkVyYmtOSnFyS2FqakR3bHBzYTFVbEtxR3RRLytvL2lDUWg0bDg0?=
 =?utf-8?B?RnhUb0I1TEhQTUxzdmxiVVcvcDRqR1JEUS9qa2dSeXd2UHpDNzVUUTlyZFlM?=
 =?utf-8?B?WXArZWN3MytHcXlKZlZYYm5zeFVTOFJtUDBxZlFMOWFlMk1BSC9lR3lhUU1S?=
 =?utf-8?B?MmF6SnFkL2g1NnVaMElXcGhsY0drQ01maGc5TkJTMXMzQVFIQ3czdS95dFBo?=
 =?utf-8?B?cEJMaDVaYjFIRXhpYlByN2tQV1hQeGNLWWNGT1Rud1V5MWl5M0M4Q1UxanF4?=
 =?utf-8?B?NFdIQUh0Z2o1NE93RFRSZHR2OGU2SUw3b0dseDUrdjNXb2JhQ2dtSUZGdjZs?=
 =?utf-8?B?M3F2OTkyeS8zaHI5ZE5VLzU3WjVUSGFsditUZWx0MnMyTWFQSzk1dlRiR0tQ?=
 =?utf-8?B?YXc2V2VvUlYxNmt2NDBEZkcvZWNjbTdTbDZrVS9VYXlSRGRVcXNDODJFR0FV?=
 =?utf-8?B?ZGJPWFBQV1dsRGptbEpCQ25oellENzFMMG1zZ3ZuRUUyS0tYdktOb0p6TTZI?=
 =?utf-8?B?dmpHWm1kcnI3NjB4NFREbDlYeWlYOU1nQ0NneStDdS9kc0dycmRTMkZNNWY5?=
 =?utf-8?B?Rzd1RmIwVHJBditWTkJEU2o0V1RpMzN0bml2SERwKzBBbVd1ZHgrQVlBaFNr?=
 =?utf-8?B?THNjOC9QZnZaN2VrMkxKdERCWWV0YmZremhCamFoczVIZmlwQXFGUzVVMlFM?=
 =?utf-8?B?Q1dmSFJFcFpZOTdPOWJQM0VJZUtRVHltbEVuamU2Y3hxT0p0bVNaY3Y5T3Ja?=
 =?utf-8?B?UmRwOGk5SGo0SmJpYzVmU2ZnZU1XdnlzTGlHbXVIcUNPOFdiVWVkaUUzRHFD?=
 =?utf-8?B?MDVlalYwZVM5QzhOckI0UlZVUWhoM1JmV1FLa0JVNjJuNXBwWTY4OUNxcjln?=
 =?utf-8?B?bzlja2VMYzJXdXk2Wmx3SHVuSnBlRlNlbnpxa1ZMbm9mY1NEV0dZbG1EYlM2?=
 =?utf-8?B?bEo2clp6b1FvUTc1MHczMi9mRUZsVlhxb2ExOE5JOFA1bUZESm5Nd2NPaDBG?=
 =?utf-8?B?bk4xajIxTlgrLzR6dmV3NDhnNDQ5ZTRWaUhua3c2N3RWU2lqMnB5akpUSzZJ?=
 =?utf-8?B?UjU2VThseVJLVG9KdzJwTjd3TTVURlF3VzRudENKcGNwb3ZFUDNjWGlEcFJY?=
 =?utf-8?B?cmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	7CJ2NSopK8Nnw5nJCXmi0a5NxzAZfz34b5nsKLVKomfFpzwEtB+0pHeo/HnsgLZqyYLVfwEZoEV1K+8d8N+vvIMZgfFGVMko6qBAu7HmiZTsCl740cyI08DoK0VryVBhfV03V76WBDRbNRLAnVJC5bAOSCgzFFM/C31vS8yk3hHsgeMqc0yyC4YBx8ETChAPsa6KJbYZujiAhfSQ5ZTXMSjeBqYpa6IPbqAJQKJJW3WNmtgkwoJFuG4jfhxK0B0uZZvk7ldD2e97wnoVtrG86xRj8tW5BWPBsNgRKkvXgWr6BdNVtZz62fjraTu5Bj31gdmW9y4uFP6fGiSAyPYP3lhjDi9cWB5qd6DZHQ7QZ/LHffixAOWvWz5acyIfr1+MCOZZLAZmrlIu9cgIuj/l9wVc+RkulvfNg8wuHuvUh2jv4wsbxxglPmsfmNvLfmIi6e0gblTdcEWyAbGvES8wNzkhceYdZZhBLw6HDXgJBq0ECUFgvAfP1CgvUpBW9pUiRmnZu9UWyJoTQuF0c/h8Cbc73fGWi8spRzFwcKfcKHlxSkY6pO5zUTSyCAmdLRFIF6mRwrM9gJCzmlWO4gsorSWrEdLFrJK6cgbajTXkaBo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69a94c2b-11b7-4613-a054-08dc22057cf5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 02:36:54.7791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n8VuHSgJX06ervXCLtfg6JtG1NQ3vpiPFHA4xTVocD1Z8YA4rAU8asn3MBT08aEYxMHPP7KrlxjynD1E4BFJcNIrpqg5SAr7NT0Ae4T3OPA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4159
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_14,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401310020
X-Proofpoint-ORIG-GUID: AdWS8swexbbg367AdgU7XzElyCiHP_2d
X-Proofpoint-GUID: AdWS8swexbbg367AdgU7XzElyCiHP_2d



On 1/30/24 16:35, Justin Tee wrote:
> Remove the early return NLP_FABRIC check in lpfc_plogi_confirm_nport
> because it is possible for switch domain controllers to change WWPN.
> 
> As a result, allow lpfc_plogi_confirm_nport to detect that a new ndlp
> should be initialized in such cases.  The old ndlp object will be cleaned
> up when dev_loss_tmo callbk executes.
> 
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc_els.c | 49 +++++++++++++++++++++++-------------
>   1 file changed, 32 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 4d723200690a..a17c66e31637 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -1696,18 +1696,13 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
>   	struct serv_parm *sp;
>   	uint8_t  name[sizeof(struct lpfc_name)];
>   	uint32_t keepDID = 0, keep_nlp_flag = 0;
> +	int rc;
>   	uint32_t keep_new_nlp_flag = 0;
>   	uint16_t keep_nlp_state;
>   	u32 keep_nlp_fc4_type = 0;
>   	struct lpfc_nvme_rport *keep_nrport = NULL;
>   	unsigned long *active_rrqs_xri_bitmap = NULL;
>   
> -	/* Fabric nodes can have the same WWPN so we don't bother searching
> -	 * by WWPN.  Just return the ndlp that was given to us.
> -	 */
> -	if (ndlp->nlp_type & NLP_FABRIC)
> -		return ndlp;
> -
>   	sp = (struct serv_parm *) ((uint8_t *) prsp + sizeof(uint32_t));
>   	memset(name, 0, sizeof(struct lpfc_name));
>   
> @@ -1717,15 +1712,9 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
>   	new_ndlp = lpfc_findnode_wwpn(vport, &sp->portName);
>   
>   	/* return immediately if the WWPN matches ndlp */
> -	if (!new_ndlp || (new_ndlp == ndlp))
> +	if (new_ndlp == ndlp)
>   		return ndlp;
>   
> -	/*
> -	 * Unregister from backend if not done yet. Could have been skipped
> -	 * due to ADISC
> -	 */
> -	lpfc_nlp_unreg_node(vport, new_ndlp);
> -
>   	if (phba->sli_rev == LPFC_SLI_REV4) {
>   		active_rrqs_xri_bitmap = mempool_alloc(phba->active_rrq_pool,
>   						       GFP_KERNEL);
> @@ -1742,11 +1731,37 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
>   			 (new_ndlp ? new_ndlp->nlp_flag : 0),
>   			 (new_ndlp ? new_ndlp->nlp_fc4_type : 0));
>   
> -	keepDID = new_ndlp->nlp_DID;
> +	if (!new_ndlp) {
> +		rc = memcmp(&ndlp->nlp_portname, name,
> +			    sizeof(struct lpfc_name));
> +		if (!rc) {
> +			if (active_rrqs_xri_bitmap)
> +				mempool_free(active_rrqs_xri_bitmap,
> +					     phba->active_rrq_pool);
> +			return ndlp;
> +		}
> +		new_ndlp = lpfc_nlp_init(vport, ndlp->nlp_DID);
> +		if (!new_ndlp) {
> +			if (active_rrqs_xri_bitmap)
> +				mempool_free(active_rrqs_xri_bitmap,
> +					     phba->active_rrq_pool);
> +			return ndlp;
> +		}
> +	} else {
> +		if (phba->sli_rev == LPFC_SLI_REV4 &&
> +		    active_rrqs_xri_bitmap)
> +			memcpy(active_rrqs_xri_bitmap,
> +			       new_ndlp->active_rrqs_xri_bitmap,
> +			       phba->cfg_rrq_xri_bitmap_sz);
>   
> -	if (phba->sli_rev == LPFC_SLI_REV4 && active_rrqs_xri_bitmap)
> -		memcpy(active_rrqs_xri_bitmap, new_ndlp->active_rrqs_xri_bitmap,
> -		       phba->cfg_rrq_xri_bitmap_sz);
> +		/*
> +		 * Unregister from backend if not done yet. Could have been
> +		 * skipped due to ADISC
> +		 */
> +		lpfc_nlp_unreg_node(vport, new_ndlp);
> +	}
> +
> +	keepDID = new_ndlp->nlp_DID;
>   
>   	/* At this point in this routine, we know new_ndlp will be
>   	 * returned. however, any previous GID_FTs that were done

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
