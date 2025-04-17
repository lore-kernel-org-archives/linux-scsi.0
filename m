Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB5A366
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2025 16:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744905768; cv=fail; b=IO93dZi6E/EdgxOcgY64/XXKQsLGNZyed3Mic2mnlACJBbx6djTB97fvK7hKeTF2tZvlTrT+mLs79yij1klL6XdaDl0asQ00DRKdEzmTB9IBOuKbgvlidpizeRX6f6+uhfaXzHGdZS6WWBB7PSw/1CLThmpVA7t/HLN3r9Pz8Rw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744905768; c=relaxed/simple;
	bh=YphqhmlA/rb5u7aWio1uKvUc4ZFf3je61xVytO/G5GY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Bj4JTDwfKFcMP66DFTj8WpCoOYsQZiZjHf8Ybsm4eEsk8i2aYhLYyZ9oCuqRW1tx7X2k4CrKQiNM0ZCqDuGZ0EWJQaGSZD7prZ1Sj6jTyjnJ1ry2mppPSZN8DNppAiwSMHY4ric5cl75rYWEflJv+rCuZ/hRO7wEcwkN8X3KCg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=jdZZ2dSb; arc=fail smtp.client-ip=40.107.244.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="jdZZ2dSb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lREmza+eK7nlmB/g8jHbrn0iZTB6xONCcEfjVFBHc7j+rdoyfQphIE8xUOGJOmmreal9P8RS6tPO5vkNY2fyNho2BjIFNZCqSQC2exUGaiIePM6Nr60u2Qtdvb8T3mP7AUGe3ivfS+w2+lnLrg0dOvZIFsiH7xP8daRpi2PL2MoKJDJBaYs+hHNedo1Riz4vcDo3l8g+HhnhUQBRlcTNoWjxnTcfWaDAcC9lQp7rb2KoFQe4+dcWFO02y25dTjd7KdRft3IkeHDeVoO+E3YDl/6OYmzv/cqtcEB3BWzv0IhNAECW00uoTHRsTg5tsIoSqoLg7bHTHAgQZYoOp7J4Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YphqhmlA/rb5u7aWio1uKvUc4ZFf3je61xVytO/G5GY=;
 b=LFvHHNOqC98sNagPxDCrU3iTySOGxvaAuuYaPpaf8XeL6fHkcpl1k1VdciAh2djHdKjh8EtXjaS2amQeTz8VN9DuNgaV+dIjfyBldDYWz6eeK3tJondIZNBYdXSrmNHhmFQoPx1bz+hQnusU446SFl0bK6+5nQi5BikgwmuJDlZMycXR8IbyF6xEb2uWuKeZqM0BhgseIPkiC4wDAJ1NCw3cxKIM+i/e2KuCKbKP2n9AWSkF0E6HZ+38vTlCpumv2KD7hix+sU+TZaFqzB9L5IGWZA4hyPNJmnTNf4CJdVaf5IGt6U78ONi09irPoNF9ezPogUlumwRBcSQrUfq5oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YphqhmlA/rb5u7aWio1uKvUc4ZFf3je61xVytO/G5GY=;
 b=jdZZ2dSbIVOmX2qR1Dmz8c1HuM3Y/I5cTc7Hy4AS0G6wOi5xMQQjlFcfaRapf2YfYSuGGnSHtZYkZeigIPHXE9YRex2LgMIPrbAGBYW+9RTt57BQskF4qjj5wK1QZKGvbuGEjNoaPui2FYmpH4S/kzOvWgSofr261FdWrVBZ3W382BaNk6cxiecUDRNQo2nzyVjpQ6fY6xcbSHcrQ9x5zDLpBujhzOKTmJBI+0LDg3q4sKKS0d8gxDSb4y1oD479GsiYxc96SPgpjRa2N+/w46UhOd6+w8VyXFYSk3YruAQXxKr1CwEMgIUGIhmJrS9BvaMScuLFyzqY+J8uNO1a9Q==
Received: from PH7PR11MB7570.namprd11.prod.outlook.com (2603:10b6:510:27a::8)
 by MW3PR11MB4761.namprd11.prod.outlook.com (2603:10b6:303:53::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.21; Thu, 17 Apr
 2025 16:02:42 +0000
Received: from PH7PR11MB7570.namprd11.prod.outlook.com
 ([fe80::f249:c679:94d9:9898]) by PH7PR11MB7570.namprd11.prod.outlook.com
 ([fe80::f249:c679:94d9:9898%6]) with mapi id 15.20.8632.030; Thu, 17 Apr 2025
 16:02:41 +0000
From: <Sagar.Biradar@microchip.com>
To: <john.g.garry@oracle.com>, <jmeneghi@redhat.com>, <hare@suse.de>,
	<martin.petersen@oracle.com>, <pheidologeton@protonmail.com>,
	<kernel@roadkil.net>, <maokaman@gmail.com>
CC: <James.Bottomley@HansenPartnership.com>, <linux-scsi@vger.kernel.org>,
	<thenzl@redhat.com>, <mpatalan@redhat.com>, <Scott.Benesh@microchip.com>,
	<Don.Brace@microchip.com>, <Tom.White@microchip.com>,
	<Abhinav.Kuchibhotla@microchip.com>, <Sagar.Biradar@microchip.com>
Subject: RE: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IRQ
 affinity
Thread-Topic: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IRQ
 affinity
Thread-Index:
 AQHbcz0tB0IW0OqxSE2ZE7WljSjIKbNEoY/mgAEygn2AAAvHAIALTSb+gAXu44CAFbT0AIACK52AgBRSlDCAABw/AIAlBv7Q
Date: Thu, 17 Apr 2025 16:02:41 +0000
Message-ID:
 <PH7PR11MB75700EF6E59755BD99F780A8FABC2@PH7PR11MB7570.namprd11.prod.outlook.com>
References: <20250130173314.608836-1-sagar.biradar@microchip.com>
 <yq1mseqwoaa.fsf@ca-mkp.ca.oracle.com>
 <PH7PR11MB757026166DDB8068830AE420FAFF2@PH7PR11MB7570.namprd11.prod.outlook.com>
 <8433b8b8-bb9a-43e0-a760-d8745d28d0d9@redhat.com>
 <yq1eczsjaaz.fsf@ca-mkp.ca.oracle.com>
 <2eca14e0-3978-440f-a4a4-32c9c61baad4@redhat.com>
 <84a87c16-0738-460d-b83f-55f8181d536e@suse.de>
 <c3f77605-3061-461f-8406-8eb0493c71cd@redhat.com>
 <PH7PR11MB7570A7E66942E50167648A56FAA72@PH7PR11MB7570.namprd11.prod.outlook.com>
 <01aaa273-f068-4013-b4ce-25cab5ad7d4f@oracle.com>
In-Reply-To: <01aaa273-f068-4013-b4ce-25cab5ad7d4f@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB7570:EE_|MW3PR11MB4761:EE_
x-ms-office365-filtering-correlation-id: b5b1d754-6ecb-44d4-69d3-08dd7dc9489c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Q2dxaFVjYWRtZ2JWZ0U5emY2YUlJWFBGOFNaQXVZaUJRY3NWcFkwRkZ1MENq?=
 =?utf-8?B?R3VUeVBtTldPd2NqS2gxcm9lMGdJQlVJU2RqUkFDcE04ekJRcmRXTmVLNzlT?=
 =?utf-8?B?MkxFL2VPUTByQ3pYM2swR09zb2pmekFEMUtFNmFnSEJieGhPMStaQ05jaWZz?=
 =?utf-8?B?SGNRQU83Z3FteE1WVWNmL2pXZklKQzg2NXlkNTdkR3J2UjlNWnQycktzVUtq?=
 =?utf-8?B?cHlGTW9pQmdjaVZjSnFtUzBvQ2pvMnFQdDQ1d2cwclBGZ29VdFl4TVNVa2tD?=
 =?utf-8?B?dFQxTUE0c2RVSHVKenBMTEl0WXdJT2xDODZmT053dG9JZ1BsVVhNWkVTRCtH?=
 =?utf-8?B?eG8vUitudVZJMC9aSXZyYXdzdkZDNlVJK0M4NzZkNFd6b0liVkxUSEdNNGZr?=
 =?utf-8?B?U2ZFeXZVN2RvK28zZHo0NUF4N1Q2eENpUVdtMU1XL3Q4dHdEbzdmSGRjZExJ?=
 =?utf-8?B?UXZ6RFl1RDQxZ2RwMVU3aGZpY1htbVhramJUa0JnMTJYdlJ1ZExaQ2cyWkFn?=
 =?utf-8?B?cGJFVVUxMlFzTnhDOWZiN2RVMmxPQmVnMnhWMmo1ZkMrRExQVGIwZ1g3U1N5?=
 =?utf-8?B?dm1jd3NCQjZKWDY1MENKNHoxWW5tSzVaSCtDZUJ3SzNZa2dQSFY5STRobEpm?=
 =?utf-8?B?N0s1djQwWkFHQmpGMkZRbVpqME1pVkRuV0QrTWdmbFN5emYxeXRtSFBMYUs5?=
 =?utf-8?B?bjVDWDJ4QWpvVjlBV3kvaGphNFRxR2JTNENyeVo4RUZIVXJTT2dQWkhmRklO?=
 =?utf-8?B?aWRtU0E5QU9JWDFwd2dBa2FpUjFsc29KbUEzSWNGNUE2dUhUS2xPS2Vtc3ZG?=
 =?utf-8?B?VWJEOHhXQVhRU2tXOUltR1FsVW51OEhyRGhpZytZdHpJbVMxcDJJbHZLRjNG?=
 =?utf-8?B?NkdqcTdtQytVZHNlQkc3RUJac3NFSFcvRmQ4QTRSQUNZUDgvdlY2dUxRTC95?=
 =?utf-8?B?TFJscXFtNXBZRUNNSXlEWjgzQytzTXJaZ3QxUzJpRmRiYXVWcXhtallWK25X?=
 =?utf-8?B?UHVPOE1OWHVXZ2xHSE84cXBFQng1Ymd3QWI4aFBSaXVvTUUyUWxxNjFrTFU0?=
 =?utf-8?B?dFhkb1pzQW1yRy9LV2FQTTJ4Y3VxWU5iNENkd1R5NGRkTTI5UVg2b2s1MGxB?=
 =?utf-8?B?NjVlY0poemFIMHJzT2E4UlB2TUE1bGZocDcvYk40NWdERU5Obm8vUjYxM0hv?=
 =?utf-8?B?QTAxbWgxK0MvNnBEcHRtUEl2MFc0ZWp5YTRSaTFobjhMcjhseEtjUEpBQlEy?=
 =?utf-8?B?RHdVY2JGWXJEZzN6bnE1VGI5U2dxR3hNRzlYSzRoNjVaYzlnWTMyU083MlM1?=
 =?utf-8?B?a3BicEhscndMb1JKREtXN0JyNHRuRTc0cElDdHZUbXA4M0JtVXhGc3NWenpi?=
 =?utf-8?B?UWtRUWFTdm8wVFFETnMwL283REcvSE9NcUFrZjJpejhZbTZON0tOcWNwUUxn?=
 =?utf-8?B?NTEyQmpiZFpBN1VQb3h0b0F2QmgvY1BNQW8vQ1lhWW9SZnA4WjRyQ2ErSmhY?=
 =?utf-8?B?UWk4SXBFOXp6Q2xrc0F1QWp6byttVEtFcUpmVjlsUk5ldklKNFF2aFh4bzBj?=
 =?utf-8?B?dUVrSjZQell2bXhRRzlZYjRpRktwQTd4T2NwSmcrekJOeTNmZGNCc091Rndu?=
 =?utf-8?B?bzc5U011dVlZTEY2ZVcydlRHTXpqeVBhenFYem9ldnVSbU9nY2FUYkRnK3RI?=
 =?utf-8?B?NDJxMU5IV1p5N1RVc2NZZjJEcGtyZ1hodzlRbEZjVnFzQlI0cW8yd2xYLzNN?=
 =?utf-8?B?ZkpjTGxEUHFsTU9MOFEvajlZakdPbXZrWjdhQXB6V3FBY2ZLSk9sTmdoUkVI?=
 =?utf-8?B?djBsWFBjV21vczdRSFBXSFRXa0RycEdJczdpUTJjb1NvNWx2Q3Ewc3N0aTFm?=
 =?utf-8?B?M0p1UENaR29aNmIwNUtuVGRObFRUc0prN1RzT1k3ZWQrY0MxeWY2Q213Y3du?=
 =?utf-8?B?WXo2RnJyZkN1MnF0R2F0ZUZrVGJGdHEvNFYzY1VyTmdMUlpQWURWdGY0bUVP?=
 =?utf-8?B?L0VUc1NDN3BBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB7570.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NGVnSDdvSnlyOHZ2WlFsMGVma2x2SXdoT2VQY1RkR3JmMmhkZjFKRVB2N05o?=
 =?utf-8?B?aEp0cFdYV3BVNFEyaTR6UEFhckNBbnVud1FDYVRVOEljSDFkcjlMN1lNYlU1?=
 =?utf-8?B?LzZWZlFYNGROV3JXUncvQzlPbDgyc2hIOHo0ZUlPSHExUVpueGdTNUpKQm03?=
 =?utf-8?B?dEZzTlRJdEJMN2pkc3VZdXBDb1B6ekp5YXkrUVJTZCtDMGN4Tkpka3c4Q0Mw?=
 =?utf-8?B?QVlIWFoxNDVzUGtBeWdzbU5qVDRkc0VydFYreVRNRXJnSTRBSGswOFplS3Ji?=
 =?utf-8?B?R2hUSVZ5RG5QZ0kxYmoxY1pMRnU5ejdMU0NpbGFmTFFZcFhrMjZCV0JSbkNF?=
 =?utf-8?B?NXQ4Q2NXZWxadExrYnJCTDVPR21tclg0c1VIZGFmVkRMTXhUWDU0TzNGZFVo?=
 =?utf-8?B?NEtPeHVyMTFGVElac1NKZDlDVTNjL1NVbEJzR1BkcVJUc0ZwcEl6Szk4Z09G?=
 =?utf-8?B?RThvMW9YQVJxZlpBRzZPb2FzOXR6RTVseHgvejZOQk1QK0FhVEsvVTNSY1V6?=
 =?utf-8?B?OWVMQ0NaQ2lsV1FZWnc1cElsOEh4N3RneXdnM1FQaDB5SXBxNFFmUWxiUE1Q?=
 =?utf-8?B?bmRzTlpqYUlqQ3h0d1FCb0RDakV4WFVBZ0JyQUlEV1FGK3hMZ2t4UHdVdk1V?=
 =?utf-8?B?YThjUHhTcDQ2VXEvSGJQMnBiT0FnMDFyOEJMWlQyWnVoRzE3ZkdDYXFkTUZT?=
 =?utf-8?B?L084Sjl0TmtvS3pQZ2Y4WmhCODFHQTVURVpEQU4xa1R6QjZiUC9tNnZhdWpz?=
 =?utf-8?B?R0kzVkZQZVlZNENkNjRWNGtvYkR2cnZSQ3RFWkdIZU9iQ2FtV3Z6R0ttdEo0?=
 =?utf-8?B?V2dwaXRuUG1aMUNNcG5yeFh2b0loc2lkWVd2cTdaZlI5UWtrMERyY1RRVDl1?=
 =?utf-8?B?RkJyZHpPVEM0T2N6K2kybmVlb0ZYTGRKQUd3Y2Y5eWZ3MVh5VUkwUTRHM1pD?=
 =?utf-8?B?Y2hwcVZHcDJ1TlhGZUpYYWhJOWhFRjBKMjBXRi8xSXdhSmFDN0FaTkw3ZmFO?=
 =?utf-8?B?YWF0TjlBUmgzQUo0YTBzeHo0MHdGcWVtYWttSFRjOGswd0trSk02YytHUW5L?=
 =?utf-8?B?NmN3Z1ltWEN4WWE4b05lZVpHWjB0ZWRtUFRGc2hJQ2VwU01qYlk1RGdBOTdQ?=
 =?utf-8?B?a05VbDJYdGpoUmQzS2gvZXdqTGZ3SW8yWXA5QnlUMkk0VVRkRjBBb0JROWYv?=
 =?utf-8?B?S0xseHgyQjNXNnhxaVNvZVQvZFRFdnJkWHVjTm1hWGdaYU82R28weCtSdlpa?=
 =?utf-8?B?MHVTZTF1b3kzQjJ5cEZ4NEprQjAzWmJGTW5GNkRMZnNieFlNR2Mya2lJc043?=
 =?utf-8?B?MXY1K01DQW8rRGNSSjZtMmlLTGlVajJraDhJaHpxOXNqTGx0VDNwM3Q1cFNa?=
 =?utf-8?B?Q3V5dDVRZk85ODd1L2dEd29vU3BGVmgxeDFhblIwT2o1ZEhYWUVsbG40cHBD?=
 =?utf-8?B?RlUwcEZhVllSTkVKUEg5bzR2UEZUVkJpbU1kRk9VOVhTM1krdGVtcEc5SGFi?=
 =?utf-8?B?NTdEajY4M0dXTXFqcEVaaEFqSzVXaytrRGdKUE9KMnZnVnRBTGxWMDI5WHpB?=
 =?utf-8?B?VUJQUjJoN2xVZ1dhV0JuOFg1TGZOcHkvOEVTYUkwL2RPb1hOMHJCZndHa3pr?=
 =?utf-8?B?a2M2U0VvMWY5dWlzRFJEcW45WVdzMkl5WnRlek5JQ08vZkxCc0xqbHNjZW9T?=
 =?utf-8?B?TjBXYW5TSm9tQnpHKzVzOUtYWHpjV0R1LzJKUjlaNExGV2lCUXFZYTk1OUZ1?=
 =?utf-8?B?WnBEdzQ3MmljemQ2VXNGalkvTWUvQlJ4bWEvQkcvdEhibkFMWVdUZ1YzNGgr?=
 =?utf-8?B?N0lyNVV6dDhZV3prMnk4SlZVRXdnbDhodmJWOUk5SDltYVk3elB6MElNbWVD?=
 =?utf-8?B?TmNtdG9NUjRMS0xmaU9xcmswcWFkNnA2akFMYm1VaFdDSHdMRytpeWpCank5?=
 =?utf-8?B?RDNBeWlHZUJwY1hqdmJveTB4clB2aFR0TXpNV2taTmNIVDBpTXBNT1E0N0dM?=
 =?utf-8?B?RXl0UTlRRDhndUswdFQyZUcvY0VxUS9xUzkvT1lkYm9YTjFDMDZGd01JUE9l?=
 =?utf-8?B?aklKS2RucWYrWklHNWh3cDA2MkVmcHRyNUo0YzFpZG5HTkZqbWtvY0VHdHlp?=
 =?utf-8?Q?bJnIiAKQKY+wuD296LHFirHFP?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microchip.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB7570.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b1d754-6ecb-44d4-69d3-08dd7dc9489c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2025 16:02:41.6400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z8jELfSXy6ZMlTyjyt7PwiE4LZjsQV9src5TI7GRnZqGLi1g+pEns1i5kQUUQsgJgu6kdwrFt09L9O9dz0pub+ehdjNyoy5YLPwWX2RY8HE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4761

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9obiBHYXJyeSA8am9o
bi5nLmdhcnJ5QG9yYWNsZS5jb20+DQo+IFNlbnQ6IE1vbmRheSwgTWFyY2ggMjQsIDIwMjUgNjo1
NSBQTQ0KPiBUbzogU2FnYXIgQmlyYWRhciAtIEMzNDI0OSA8U2FnYXIuQmlyYWRhckBtaWNyb2No
aXAuY29tPjsNCj4gam1lbmVnaGlAcmVkaGF0LmNvbTsgaGFyZUBzdXNlLmRlOyBtYXJ0aW4ucGV0
ZXJzZW5Ab3JhY2xlLmNvbTsNCj4gcGhlaWRvbG9nZXRvbkBwcm90b25tYWlsLmNvbTsga2VybmVs
QHJvYWRraWwubmV0Ow0KPiBtYW9rYW1hbkBnbWFpbC5jb20NCj4gQ2M6IEphbWVzLkJvdHRvbWxl
eUBIYW5zZW5QYXJ0bmVyc2hpcC5jb207IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOw0KPiB0
aGVuemxAcmVkaGF0LmNvbTsgbXBhdGFsYW5AcmVkaGF0LmNvbTsgU2NvdHQgQmVuZXNoIC0gQzMz
NzAzDQo+IDxTY290dC5CZW5lc2hAbWljcm9jaGlwLmNvbT47IERvbiBCcmFjZSAtIEMzMzcwNg0K
PiA8RG9uLkJyYWNlQG1pY3JvY2hpcC5jb20+OyBUb20gV2hpdGUgLSBDMzM1MDMNCj4gPFRvbS5X
aGl0ZUBtaWNyb2NoaXAuY29tPjsgQWJoaW5hdiBLdWNoaWJob3RsYSAtIEM3MDMyMg0KPiA8QWJo
aW5hdi5LdWNoaWJob3RsYUBtaWNyb2NoaXAuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBb
djJdYWFjcmFpZDogUmVwbHkgcXVldWUgbWFwcGluZyB0byBDUFVzIGJhc2VkIG9uIElSUQ0KPiBh
ZmZpbml0eQ0KPiANCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVu
IGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdw0KPiB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0K
PiBPbiAyNS8wMy8yMDI1IDAwOjE2LCBTYWdhci5CaXJhZGFyQG1pY3JvY2hpcC5jb20gd3JvdGU6
DQo+ID4+Pj4NCj4gPj4+PiBJJ3ZlIGFkZGVkIHRoZSBvcmlnaW5hbCBhdXRob3JzIG9mIEJ1Z3pp
bGxhIDIxNzU5OVsxXSB0byB0aGUgY2MgbGlzdCB0bw0KPiA+Pj4+IGdldCB0aGVpciBhdHRlbnRp
b24gYW5kIHJldmlldy4NCj4gPj4+Pg0KPiA+IEhpc3RvcmljYWxseSwgdGhlIGFhY3JhaWQgZHJp
dmVyIHJlbGllZCBvbiB0aGUgY2FuX3F1ZXVlIG1lbWJlciBvZiB0aGUNCj4gc2NzaV9ob3N0IHN0
cnVjdHVyZSB0byBkZXRlcm1pbmUgdGhlIHRvdGFsIG51bWJlciBvZiBjbWRzIHRoZSBGVyBjb3Vs
ZA0KPiBtYW5hZ2UuDQo+ID4gV2l0aCBGVyBzdXBwb3J0aW5nIDMyIHF1ZXVlcywgZWFjaCBjYXBh
YmxlIG9mIGhhbmRsaW5nIDMyIGNvbW1hbmRzLA0KPiB0aGUgdG90YWwgY29tbWFuZCBjYXBhY2l0
eSB3YXMgZWZmZWN0aXZlbHkgMTAyNCAoMzIqMzIpLg0KPiA+DQo+ID4gVGhpcyBsaW1pdCBpcyBh
IEhXL0ZXIGxpbWl0YXRpb24gc3BlY2lmaWMgdG8gdGhlIGFhY3JhaWQgY29udHJvbGxlciwgd2hp
Y2gNCj4gcmVzdHJpY3RzIGVhY2ggcXVldWUgdG8gYSBtYXhpbXVtIG9mIDMyIGNtZHMuDQo+ID4N
Cj4gPiBTdGFydGluZyBmcm9tIGtlcm5lbCB2ZXJzaW9uIDYuNCwgdGhlIGludHJvZHVjdGlvbiBv
ZiB0aGUgbWFwIHF1ZXVlDQo+IG1lY2hhbmlzbSB0cmVhdGVkIGFsbCBxdWV1ZXMgYXMgaGF2aW5n
IHRoZSBzYW1lIGNhcGFjaXR5IGFzIGNhbl9xdWV1ZSwNCj4gaW5hZHZlcnRlbnRseSBleGNlZWRp
bmcgdGhlIDEwMjQgY29tbWFuZCBsaW1pdC4NCj4gPiBDb25zZXF1ZW50bHksIHJlbHlpbmcgc29s
ZWx5IG9uIHNjc2lfaG9zdC0+Y2FuX3F1ZXVlIGJlY2FtZSB1bmZlYXNpYmxlLg0KPiA+IFRvIGFk
ZHJlc3MgdGhpcywgdGhlIHBhdGNoIGludHJvZHVjZXMgbG9naWMgdG8gZHluYW1pY2FsbHkgYXNz
aWduIGNhbl9xdWV1ZQ0KPiBiYXNlZCBvbiB0aGUgbnVtYmVyIG9mIGF2YWlsYWJsZSBNU0lYIHZl
Y3RvcnMgKGkuZS4sIHRoZSBudW1iZXIgb2YgcXVldWVzKQ0KPiBtdWx0aXBsaWVkIGJ5IDMyLg0K
PiANCj4gSSBoYXZlIG5vdCByZWFkIGFsbCB0aGlzIHRocmVhZCwgYnV0IC4uLi4NCj4gDQo+IGlu
IGNhc2UgdW5rbm93biwgaWYgeW91IHNldCBzaG9zdC0+aG9zdF90YWdzZXQgd2hlbiBzZXR0aW5n
DQo+IHNob3N0LT5ucl9od19xdWV1ZXMgPiAxLCB0aGlzIG1lYW5zIHRoYXQgdGhlIHRvdGFsIHF1
ZXVlIGRlcHRoIG9mIHRoZQ0KPiBhZGFwdGVyIChmcm9tIGJsb2NrIGxheWVyIFBvVikgPT0gZWFj
aCBIVyBxdWV1ZSBkZXB0aCA9PSBzaG9zdC0NCj4gPmNhbl9xdWV1ZQ0KPiANCj4gSWYgeW91IGRv
bid0IHNldCBzaG9zdC0+aG9zdF90YWdzZXQsIHRoZW4gdG90YWwgcXVldWUgZGVwdGggKGZyb20g
YmxvY2sNCj4gbGF5ZXIgUG9WKSBpcyBzaG9zdC0+Y2FuX3F1ZXVlICogc2hvc3QtPm5yX2h3X3F1
ZXVlcw0KPiANCg0KVGhhbmtzIGZvciB0aGUgY2xhcmlmaWNhdGlvbiBhbmQgbWFraW5nIGEgdmFs
aWQgcG9pbnQuIA0KSSdtIGN1cnJlbnRseSBleHBsb3JpbmcgYW4gYXBwcm9hY2ggd2hlcmUgc2hv
c3QtPmhvc3RfdGFnc2V0IGlzIGV4cGxpY2l0bHkgc2V0IHRvIDEsIA0KYW5kIHNob3N0LT5jYW5f
cXVldWUgaXMgY2FsY3VsYXRlZCBhcyB0aGUgdG90YWwgbnVtYmVyIG9mIHN1cHBvcnRlZCBjbWRz
IGFjcm9zcyBhbGwgcXVldWVzIChlLmcuLCBudW1fcXVldWVzICogMzIpLCANCmFzIHNob3duIGlu
IHRoZSBpbml0aWFsaXphdGlvbiBsb2dpYzoNCg0KCXNob3N0LT5ucl9od19xdWV1ZXMgPSBhYWMt
Pm1heF9tc2l4Ow0KCXNob3N0LT5jYW5fcXVldWUgICAgPSBhYWMtPnZlY3Rvcl9jYXA7IC8vIHdo
ZXJlIHZlY3Rvcl9jYXAgPSBtYXhfbXNpeCAqIDMyDQoJc2hvc3QtPmhvc3RfdGFnc2V0ICA9IDE7
DQoNClRoZSBnb2FsIGlzIHRvIGNvbmRpdGlvbmFsbHkgZW5hYmxlIE11bHRpUSBzdXBwb3J0IGlu
IGNvbmZpZ3VyYXRpb25zIHdoZXJlIENQVSBvZmZsaW5pbmcgaXMgcmVxdWlyZWQsDQp3aGlsZSBt
YWludGFpbmluZyBvcHRpbWFsIHBlcmZvcm1hbmNlIGluIHRoZSBkZWZhdWx0IGNhc2UuDQpTaW5j
ZSBob3N0X3RhZ3NldCA9IDEsIGJsay1tcSB0cmVhdHMgY2FuX3F1ZXVlIGFzIHRoZSB0b3RhbCB0
YWdzZXQgc2l6ZSwgbm90IHBlci1xdWV1ZS4gDQpUaGlzIHNldHVwIGVuc3VyZXMgd2Ugc3RheSB3
aXRoaW4gdGhlIGZpcm13YXJlLWltcG9zZWQgMTAyNC1jb21tYW5kIGdsb2JhbCBsaW1pdC4gDQpU
YWcgYm91bmRzIGFyZSBjaGVja2VkIGluIGFhY19maWJfYWxsb2NfdGFnKCksIGFuZCByZXNlcnZl
ZCBGSUJzIGFyZSBhbGxvY2F0ZWQgZnJvbSBhIHNlcGFyYXRlIHJhbmdlLg0KDQpSZWFsbHkgYXBw
cmVjaWF0ZSB0aGUgaGVhZHMtdXAg4oCUIHRoaXMgYmVoYXZpb3IgaXMgYmVpbmcgZmFjdG9yZWQg
aW4gd2hpbGUgcmVmaW5pbmcgdGhlIGRlc2lnbi4NCg0KPiA+IFRoaXMgYXBwcm9hY2ggZW5zdXJl
cyBjYW5fcXVldWUgY29ycmVjdGx5IHJlZmxlY3RzIHRoZSBoYXJkd2FyZeKAmXMgdG90YWwNCj4g
Y29tbWFuZCBjYXBhY2l0eSwgcHJldmVudGluZyBpc3N1ZXMgY2F1c2VkIGJ5IGV4Y2VlZGluZyB0
aGUgMTAyNCBsaW1pdC4NCj4gPiBCdXQgdGhpcyBjaGFuZ2UgY2F1c2VzIGEgcGVyZm9ybWFuY2Ug
ZHJvcCBpbiBzb21lIGNvbmZpZ3VyYXRpb25zLg0KPiA+IEl0J3MgaW1wb3J0YW50IHRvIG1lbnRp
b24gdGhhdCB0aGUgcGF0Y2ggZG9lcyBub3QgbW9kaWZ5IHRoZSBxdWV1ZSBkZXB0aA0KPiBpdHNl
bGYgYnV0IHJhdGhlciBhbGlnbnMgY2FuX3F1ZXVlIHdpdGggdGhlIGhhcmR3YXJlJ3MgZml4ZWQg
bGltaXQuDQo+ID4NCj4gPiBGb3IgY29tcGFyaXNvbiwgY29tcGV0aXRvciBjb250cm9sbGVycyB0
eXBpY2FsbHkgc3VwcG9ydCB1cCB0byAyNTYNCj4gY29tbWFuZHMgcGVyIHF1ZXVlIHdpdGggYW4g
b3ZlcmFsbCBjYXBhY2l0eSBvZiA4MTkyICgyNTYqMzIpIGNtZHMgb3INCj4gbW9yZS4NCj4gPiBX
aGlsZSB0aGUgYWFjcmFpZCBjb250cm9sbGVyJ3MgZGVzaWduIGhhcyBzdHJpY3RlciBoYXJkd2Fy
ZSBjb25zdHJhaW50cywgdGhlDQo+IHBhdGNoIGVuc3VyZXMgaXQgZnVuY3Rpb25zIG9wdGltYWxs
eSB3aXRoaW4gdGhlc2UgbGltaXRzIGFuZCBoZW5jZSB0aGUNCj4gcmVkdWNlZCBwZXJmb3JtYW5j
ZS4NCj4gPg0KPiA+IENvbmNsdXNpb24gOg0KPiA+IEEgZ2VuZXJpYyBmaXggaXMgbm90IHByYWN0
aWNhbCAtIGdpdmVuIHRoZSBwZXJmb3JtYW5jZSBkcm9wLg0KPiA+IEFzIEpvaG4gTWVuZWdoaW5p
IHN1Z2dlc3RlZCwgaW5zdGVhZCBvZiBhIG1vZHBhcmFtIHdlIGNvdWxkIGVtYmVkIHRoZQ0KPiBz
YW1lIGZpeCBpbnNpZGUgYSBrY29uZmlnIG9wdGlvbi4NCj4gPg0KPiA+IFNob3VsZCBJIHN1Ym1p
dCBhIG5ldyB2ZXJzaW9uIHdpdGggdGhlIGtjb25maWcgb3B0aW9uPw0KDQo=
