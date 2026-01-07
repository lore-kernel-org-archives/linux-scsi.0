Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C032E8B97
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 08:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767776398; cv=fail; b=rDMvfEG2UVn1gZ6BgbPIyS5jtHT1HBL6oiIUZV05P86/JM052AfdVegzFn+a7vKeuv5yvpaKrdFcB//OHE8BhC24S1/IuT8shX10TevdQEh8et7VsYhNzwKetefhxDwKOGZWzynVIS/hWkz0vHiLIORKIWhcn/GHGob7dsgW8zI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767776398; c=relaxed/simple;
	bh=kTF6iZ51aW0/AUpKRG+G0h9MzeX0pxW9Ke6IZxZDoXw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ru67zkEgt2RcszHVMFYoA7GR5a7CpVSMoIj0h1RV8tXU5DKV9ukkdd73dPrbWRhQgcoqfaZvn0Bn751n8dpfudxIXsiBB7psXrgfjnRPYjJ1TPGD4FUXWvZ3SRR3eEKdJGOs6jmiCjTIoaUM8GyKl4KvxPt6c8UC7bg6bUbBl94=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FyMRR/ti; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Xxfa4Y9B; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FyMRR/ti";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Xxfa4Y9B"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6078R6o02070462;
	Wed, 7 Jan 2026 08:59:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=emFACyqn1Q8dg2qdtRTgchy4dzi+qMlmfUxp+ykz9II=; b=
	FyMRR/tiNOes8ZYtAxgt4YbOVGgYiZS2jPUAB9hcVBHaaBYsuyy1fb8PNo2MW8UU
	F6Zs7QPJY8jfpf+QOTdFEoUyBJx4Br56y/ilas89Q5IfWaoh0dUC2/nMhxWoWis8
	/QBzvzTPK2Unmyot8/sKpNa86gpOVSBSZLZ4hifHBzxBuC6bO69pQamGHWdYucfQ
	1YgoHCrOW0g/wLhZOVBLpOXP7ILCbUVESy74KjzXE/g8U7i9vhZcjhWOB+N7t7Ea
	4HYY0UAWdQuiXCfjKt4/ovgqmi2S6JHeIOvnnolz6hRHN7H2Wb8s0fyer50DisD8
	wZu1NVGDmk01sVl2XuyWEg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhkysr0xq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 08:59:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60783Sh4026776;
	Wed, 7 Jan 2026 08:59:02 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012070.outbound.protection.outlook.com [40.93.195.70])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj9c0h2-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 08:59:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HHKZD/3upPRGEU5ajDBunNRLnVdtUBl035jhGI1noxH6D04jqik1/hfl0U6JnRJinCeG/HQcUcdecszYRS0UY7FZU5nfOSQOaCRqtG+ygybo3uJU6HHhr6n2/sXoROhCs2UX4ZTRDY887DIhrnOg/hA/UM4NjZD8wgJtNt75KldeR37UR3PBCoJATSYR/Jugw6dMfURYt4j2ClImKAMq0yrP8UAaoVElGMxPhmZMGn/PY3ZU9jFZ4sJ2Y8ZmJ6/dQR9B+SbGO1TIXpRoyQlWMuGen6PDThpmsTXMspO4Rqsd+H72gkvQyy7KkJlPeamqxoW2bASiIYcPQNP2n1nzJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=emFACyqn1Q8dg2qdtRTgchy4dzi+qMlmfUxp+ykz9II=;
 b=dhFbYOGZ3t02b1WUfDC1N2RfzAAVsKYFobFbi/ToP9LAoWnsg0K6ZzZH94tx8fL3ZLmPSvsgJdgMGrDGPRLiGHYX6l9cdztASAnLDHQqfdzxA5Y/4SXyzU6ZYbTA8UTtsN2Zgd4/6cUbvbcHPDYH+N+copq5/aFuWPcRn6NPjBE6r+xpL0QOYs3BYt3wyuUjqTZvWuw/F2L2WHGyt6mmN/o8fJ/8U0b//WFnKRbAQYVI4p/35RN0A5MrrvQum7jXswPGcUKi0uFdJnC5cH9JbR7kIDc/hS6ouekdKBoG0DI2nNljjLHGsIYMa/ykLRbFZZKsszm0izprF6x6kA2hIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=emFACyqn1Q8dg2qdtRTgchy4dzi+qMlmfUxp+ykz9II=;
 b=Xxfa4Y9Bc9knq3/vokTV57jQ7i5xSw3oSL6onGS4R9E+KIhhp1zxunXVA7gvY2sLHW1xKCFvq9yFxX2RIOYKV+PElAmCSc1hqxLddmyyzWEVsj3jWxdQvvGh1XH/RftmzXpZvNmzT7eeWLpDpy2MX/touSyEHZ/ZiRFKAzwWdPo=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SJ1PR10MB5977.namprd10.prod.outlook.com
 (2603:10b6:a03:488::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 08:58:57 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861%8]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 08:58:57 +0000
Message-ID: <6510d236-cc06-428e-9d28-c1a104f408dd@oracle.com>
Date: Wed, 7 Jan 2026 08:58:43 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Change the return type of the .queuecommand()
 callback
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Niklas Cassel <cassel@kernel.org>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        Nihar Panda <niharp@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Khalid Aziz <khalid@gonehiking.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Russell King <linux@armlinux.org.uk>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar
 <kartilak@cisco.com>,
        Don Brace <don.brace@microchip.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, Brian King <brking@us.ibm.com>,
        Hannes Reinecke <hare@suse.de>, Lee Duncan <lduncan@suse.com>,
        Chris Leech <cleech@redhat.com>,
        Mike Christie
 <michael.christie@oracle.com>,
        Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>,
        Kashyap Desai
 <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        GOTO Masanori <gotom@debian.or.jp>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Juergen Gross <jgross@suse.com>,
        Stefano Stabellini
 <sstabellini@kernel.org>,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Easwar Hariharan <easwar.hariharan@linux.microsoft.com>,
        Allen Pais <apais@linux.microsoft.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Guixin Liu <kanie@linux.alibaba.com>,
        Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20260106185310.2524290-1-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260106185310.2524290-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0124.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b9::16) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SJ1PR10MB5977:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dbbf261-24be-4f30-8c29-08de4dcafde3
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?ZWxsdEppa1g3QXR6VTVSR05SejNkaitmdGdZbksyT2FwbmpEeDR3Z01QbVBt?=
 =?utf-8?B?L1dNRkJSbWw5cm54UHlOUlZ4R2hZWmd3dmtLU0owRFlFcHprOVBTdU16S3NJ?=
 =?utf-8?B?VStMM1hBSTYyaEFVNGdJZjVQc04zcUczZGRkNnI4NVRiZnlReGUvdFB2dVR0?=
 =?utf-8?B?SUk4Y0M0QWkvU043RHhEVk0rM0k4MUVaNW1IY1ljaU90SlFmbk9DMnBIbEc2?=
 =?utf-8?B?QlpEUi9taEorVld2a3BTSzdVZVRFZ254UW9sNjJUNi9pbFdRRnlYYnlEbGpD?=
 =?utf-8?B?WCtJNGZjRW5sSWtyTlU2L2FRVnVGV3Iya01QRlM2Z3IrcFVFZ3hBUHVPUFVH?=
 =?utf-8?B?QXRVb3VhRVRmNkxHU2YzbUFpN3d0ZFRZZjlDb3Rram9xN3crZGhTREZEaTUz?=
 =?utf-8?B?RGtGVDRrOVp6YmZUQzFibjJZMHFDc0lnZ0dqNzgzVHZSWERYaVlEUDNoMU9s?=
 =?utf-8?B?L0JqdFlrOUtxQUEvM2NLbFJwUDBQTHBwdTY3Q1BBcnlqZjkxelhtRTQzY3VW?=
 =?utf-8?B?by9jRldTU1crczZzNVA4RTdpZ0xJZ0Fzd1FsMEVwQ1lzM0VuWmtaaGQzR0dH?=
 =?utf-8?B?cEJ3ZXpVZzZkb2pqVitTdGMyQlIxeFBsVEpSWmorYmRZaERGNm1vWGpPanJ3?=
 =?utf-8?B?a3drQlNIRVdKUjJvRWZTT0JoMGtUWWVOMWZ3cjZ2WDJTeVVxd1drZVBhN1Vo?=
 =?utf-8?B?VW5rUHJPSDc2SEk2Zzc3STlubFhydjY0TzJ0a1A0aTBVdlZodCtscG1QZytS?=
 =?utf-8?B?SURuUWV1dHZ1aGIwRStPbkhLREtPM2VPV2p2YnJSaldyYm40ajFLcFFJcnlM?=
 =?utf-8?B?RWRYREJSK0pTTlZlelIzbS9jNGNDeitkbGJhUU9hWVVUaGRXeEVYRzlrcy9K?=
 =?utf-8?B?TSsvVFVJUVVoRjNtR29nTTkyRG14aDFvVENjejFIM0xiWnBsZUF5WlZJVmRG?=
 =?utf-8?B?YytDTmlYY09YQzRUMXMrRWduSHdzM0g4M1dGbVExTWRnZmp5UGY5dFZVZnZO?=
 =?utf-8?B?SWVoVnRnRS9EMlN5bHhOZUVPbTZrZ3k5em1jaWtUUmNxcGtsVi9BVTNzbEJq?=
 =?utf-8?B?V2JMMSsvWGl2M2ZCWDk2eUJMa0dJNVpPcFY0ZHZGK2hvb2poZUNyU2FCcVNH?=
 =?utf-8?B?UHlpVnArUnI3U2I1eksxRGtvRWVTT2FpUkhHZnZpQkdDK0cvalk2SjJIR25l?=
 =?utf-8?B?UXVKZ280UW5pUTdWVTkyZTNmYkIyOVVKV3FZaEhmRVFsWC92N2hhMVk0S21y?=
 =?utf-8?B?em82U01JMUNzK3FnOGZpbEJHamFGM2NsY3o5TEtwM2JJWmF0K1lyUHJIazJv?=
 =?utf-8?B?MWdHR1ZqU0pJNVN1bXRDdXdHeXQ2TzR6clBIazBVK3ZiMkpMUmE5OXZDWVd4?=
 =?utf-8?B?OUh5S1lsa1YvZG5OYm1pSzhUWlErUjFkQkgzY1VnSmZHZmxIbDFUSWxIeHRs?=
 =?utf-8?B?VWFhamxsNzFEZkwyS0tBblU2Yk1JTFV1VDRhNS9QUnBrYzlQNzYwMllVaTI0?=
 =?utf-8?B?SzkzbVZmYk9aQVhHVmNDb3ZIY2pDTVJuQXFuemFuVGVtZy8rT0pXNGJmU3Js?=
 =?utf-8?B?QjRqZ25td1plRWxFR2UzSDdZVWcwc2FuaWp1R3JkSHpCQVF5U014NWVaMUdD?=
 =?utf-8?B?VEFEWm9CekJNNjYxRlBJRzZqZnFxWUNXKzdzeXFrUDJHc0RzYUVBRTZNOVhE?=
 =?utf-8?B?ZGFOQWM2WHY1RERXYzJpK0ZFZmZIbHJQSXNESEwwTldjQzNiVkRzSjA1c3lY?=
 =?utf-8?B?RWExd1V5eHZYdCtGcitibzBpZG45WVI4QmlYbEJXazY0RHlpMlcvSmZycEN5?=
 =?utf-8?B?eC9RUVU5MVEyK25pV3c2ZmRxYmYwaVRpWHFoc3ZvaWlnaFc0WnpPdzRJUHpG?=
 =?utf-8?B?UGErUXd4QWprWDNxWnphU3cxSUVsMm5sRGVDakY2Yy9TUjNZLzZ4ak5BQXdD?=
 =?utf-8?Q?teneWrs6nR18Ch1M8lkKlH8UBsRgh3Qw?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?dnJzU096dStGVnZQWFJrTFM0eitpcUlTVmxPWWhVMXdpcHRzOHoyTXROLzli?=
 =?utf-8?B?TnVJZG1SZkM1ZmZkRUt2Sm5FZklmczJQeG1yc2lIMzNEaktpKzRvbi85VDVY?=
 =?utf-8?B?YmVwcTRIU3ZLUnRNL2dGaUtIOUxYT0tFUHIwc2V3dmszNzdIZ1ZuYW80UFZD?=
 =?utf-8?B?REJBV21QdWZZblczSE93OTlCd0hWTnAwOW11SG5JUjZvNk1ZVDNRUUVLZm9x?=
 =?utf-8?B?MStlQmlQeWcycWxKVFlyY3QzSlZjVjJoVTJsR2cwSGxKVHVlTnRVMVJRTXRo?=
 =?utf-8?B?N1ZEcjlBWTlPcTIyNm9kREF0ZzVnZHAyR3dYc3NHUnErUWxzc1plRDFCcXMv?=
 =?utf-8?B?VTdUVTNmMVB2ajlJNFNDS2FYU3c3ZTZQRlh1NHJ6R2N4MlpjejhTdXZweThV?=
 =?utf-8?B?K0JtcDYyL0FaRkxPSzFtNVkvS3FiVjBSQnBkVEdONzBieUpXVnlaMXN6K3Fl?=
 =?utf-8?B?dGxyRmVFUWVEcGZCNXVicHF6ZDNCNll0R3NiS09ZbkFLeEVkS2cvTzVWVFdp?=
 =?utf-8?B?bnIyM2R0aHI0K2tQVW1xd2RicjZoQ2E3V1JqSUEvdzVhcHZ4UHZ2a1NNUnFt?=
 =?utf-8?B?K3ZMZWRnemxPU0lLMUhVdkdXL1JFUmU4eTJCcXdOMDIxdElDQkdSM0U3Q1hO?=
 =?utf-8?B?M0hoakpjcE54TlgvTFE1NHpKaGZMZnJzdVVKK1gvQS9Pb1BCalhhTUxkdWhS?=
 =?utf-8?B?aUd0YmdsQVhobGhBRWxhUVlLckdCcjhIZG45MWlZZUZoTmh6eEZlLzU1U1U1?=
 =?utf-8?B?SmxUcDIwMGY4dk55cHJUUGxlb0xJazV3cndmWDZ3cDRJdDRCMFk2bFJtSUUz?=
 =?utf-8?B?eXZJWnBzcEZxNkhSTmQvVHBhMFlMaE0xL3IwWGMxY055aFZ6TEtZMXRFNC9N?=
 =?utf-8?B?ZHJjR3FsSHRVZ3BkbDBjbFNaRTdsTU5wdGZnbERIS296WFhpaTlzckwxZE4x?=
 =?utf-8?B?dFgvVXJQRFdKdzZlR3lMNHlHdUx0WFB2Nkp6NmlHa29POUJjZzdNdzlEU0JD?=
 =?utf-8?B?VDVhK0EvNm1rS0VtaEd0ODl0YTFyMHFrU3FURzEwZVROQUhJM1NLNllUdlBU?=
 =?utf-8?B?dG14cnhxWS9DMUJnVnJiRFJyUGZ3cVNselp6YW5BSlBubTVKa05QbVRNYWFt?=
 =?utf-8?B?NHZNMUZDVHdocWpNS3pTWEVIR2NINE5aaEdpWFZGTVhxNnQ2aGNOR1VFaUxW?=
 =?utf-8?B?TFlVWEFTL01xNTU0bkpMV3VjSmZ4Q0thWlNQSmx2Y0lKUDltem9kMmVwSU5l?=
 =?utf-8?B?a3ZGMHplV0Z6Z2JVbXFYUEVYeDlOL014c0htaU5kNllIRytCbkxmVVEwOGdD?=
 =?utf-8?B?QlhDaE9lRCsyaFNmeGxMeGJnODEySm5DMTZ1NTBUbDlvUnJUaU92cGtpMTZQ?=
 =?utf-8?B?ZGNmWG8vQjNmbW1kSUFDSUo3OHFRTWgrZEZZbjNyNW1NZW8yOEJ5eUJad2Fj?=
 =?utf-8?B?aGkwMk4xc0ExRTk4d3R4VXJLeXVoR0FoYy9DS3R3aUQ4TnM3YTF0WFJXL0Vw?=
 =?utf-8?B?WWZvaXpaSXhOT3Y1ZzBQTjE2Z0p0a1FLZ2RieldZSEtLKzNmYTF0L2lXMlBY?=
 =?utf-8?B?NlB3ZTJ5U3ZKWk9Sa051elZaVHNIcDlIcUVzZlRMSS9idEh1QU5tYngxUDdM?=
 =?utf-8?B?cjdUYUhadlY1b1prdm0vT0ZjU0RQc0c2VVNsYTQ5c1M3VWRoTXliQzdHaGhW?=
 =?utf-8?B?NVJsWDhFYmVldGx6aDRGK25hMlZlWWR3dkkwdFgyRGI2UnR4dFl6bUY2MnZF?=
 =?utf-8?B?SktPdXhoVmRZbjRBc3FyNms2MGpVTHZORFN6MXd3TWlpTGNhU0d4YjhxQnRw?=
 =?utf-8?B?UktVL2IydE9Wdmd5OGlUTDVic053dHJuU1RNRHc2ekVSVGVJR1NZMUlxNk85?=
 =?utf-8?B?cG9LeFFpVExYakRiOEdkaXpVUVpCdlF6T3V0KzZzN2RKdHNVMVZwU2F6bEtU?=
 =?utf-8?B?WXhlU1RLVjlPdWRqN0xTMFNYQk5yMVltTFNwZGFQR1htKzJ1M3FZVExmemZ4?=
 =?utf-8?B?OHVOQ2YzY3lnKzFmMTU1cGE1K290ajAxM05aSmZlbEZ5TDBJSXVPOExlYk5n?=
 =?utf-8?B?ZE5RL3pDUjlVZUcySmxwc2hDbG9pMXhoS2VtYmt0K1B1V3lNcW82V1gyb2Nz?=
 =?utf-8?B?VHp2QWxiSzBIdXBDOTkweUp6ZGtSSmwzbUVMU0J2SXFmclQrdVkxcGhaZm0x?=
 =?utf-8?B?OWhyK3VOVldwaVNsMGUxdkM2eDVFUExxbWxFdHU4TzM1ZjAvdi9ydk9lYkIv?=
 =?utf-8?B?QVAremV0bjRNZ2doNkFjRHl0SUQxcnFUQllpaS9mQWdZdUZLVEZVSGlwNkVp?=
 =?utf-8?B?ZkU1d2JuaWpXVFpVV2NMeGl5MGIyR3daSXZUZlovcGM1VzFoSmxHWFR0K2s3?=
 =?utf-8?Q?Xi+vHwSlyfN3ubcE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rSStahqxL2095RGco3KdYw6eJVtJ9uoEaDwmaajTqXxj4OLQ0ocCVqjFnwvr+WjNlLLytRSwe4XR6hJgmc1TZIcS7I1uanerA1861jpVNIjPJ769Ke1wJD4i6Ml50Tw9wwnYnVGxyUcCrGfWOf/cGhr8Yj1IBe76mv62OrceyMZY9PKQE5KQr/WYR/3VZpsEmPQCdKS/K47WEzbQOc5fVze64VslXrvjvi0p3uxE8kwjVxyCnJN67WkrEZXaA6yjyXvMiD8FFHbf5bpzPBx7xXQZsVTp+C+eQg6co/M41P5RnqWHRBWr6QUHZpBsbROS+MgJzs9MmzHEIk+JbFitQZL+c3shVPM+7IFrgG9/XBgV+I8WJmqyjC/QjPGqZNGpWLNbwlcIN8Hkm2VpjgVzWDo+uAyUyRNs3hhoQSYdixC+77nofpv6WjLnaYwj3SqW0/uLiX6CHKJrWupaoETLAuBz9u78MlvRnDdNf7FrNy7QwHN4mNGN07QsqZc9Vbw5vRIm7wblCFn+BGvuZnIPwljeG5+DptCw9E+gY/k4iQUtoqv3T7MroV1yGtnUWgsUWJm6xp7DroQxJysvHCdBUHS7v8tIS2jEjJK+BnnmS8E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dbbf261-24be-4f30-8c29-08de4dcafde3
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 08:58:57.4595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BbV6H7WuSp2rTgbQNr3k5EQ66ELU/HnveBQmSEJduEWf3nDHyOVS+eCC/8B4U3Ty0uQ9cqmghOJ0xr6syTorGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5977
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601070072
X-Authority-Analysis: v=2.4 cv=T4iBjvKQ c=1 sm=1 tr=0 ts=695e2057 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=N54-gffFAAAA:8 a=QCjwJgFvEY8hP7U-hLAA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: wjlIykYadeaUnR6CGvKJJJgRn6_AnJIw
X-Proofpoint-GUID: wjlIykYadeaUnR6CGvKJJJgRn6_AnJIw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA3MiBTYWx0ZWRfX6QT44xkwW4VV
 w4J+MK/62b0Xw7EzCwypjt8mmJPcMU0zPouWe2Tct8/msXlG8eS1WaBVsj76UvMVDx9wCH878zv
 CKIGrrabqEGV/76q8sjF5LHAroP+qA0Pdd3vWFUIW7DYz4WM/ZVNPpl9ntM7KKI6dHYjh7slwXU
 BIeQUK/A6lzPwojhP2X8IO1rlfRdwpcKYNX0lU+CWJINZYncz84nBnS9CHR2XBM0VTNk0UTyfEB
 unjyXTyCu93SvpSUNpVCFOW5BZtqcjkZgkymPDojWawduIxUOERAL1Hwm7WU0W/B2au6evjQ0Gc
 oPODtCFN39qLk2PYQnSz4UAoniXrLFz/PCeUJ+TCtZ8CWgc+QcMNfkIaujw6M8U+wzQSo8Ob7Nt
 DldynR/SxnAzlz2TGKGROhz0N0TlSSAtsqvSrxF926/fYnJmw+klq3e/7ZcIJm9+9saQ131erc7
 geo1rHk1Ub0CHIiF5Uw==

On 06/01/2026 18:52, Bart Van Assche wrote:
> Let the compiler verify whether a valid value is returned by the
> .queuecommand() implementations by changing their return type from 'int'
> into 'enum scsi_qc_status'. No functionality has been changed.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---

Using enum scsi_qc_status over an int makes the code less condense... 
scsi_qc_sts might have been a better name, although I do realise that 
this was introduced in another change.

BTW, are there any drivers which were not passing back a scsi_qc_status 
type? I assume not.

On 06/01/2026 18:52, Bart Van Assche wrote:
 > +static enum scsi_qc_status sbp2_scsi_queuecommand(struct Scsi_Host 
*shost,
 > +						  struct scsi_cmnd *cmd)
 >   {
 >   	struct sbp2_logical_unit *lu = cmd->device->hostdata;
 >   	struct fw_device *device = target_parent_device(lu->tgt);
 >   	struct sbp2_command_orb *orb;
 > -	int generation, retval = SCSI_MLQUEUE_HOST_BUSY;
 > +	int generation;
 > +	enum scsi_qc_status retval = SCSI_MLQUEUE_HOST_BUSY;

I suggest trying to maintain the reverse fir tree style, when possible. 
I do realise that it is not the case here, but it was close.


> index e87cf7eadd26..41ba6e7e799a 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -84,13 +84,15 @@ struct scsi_host_template {
>   	 *
>   	 * STATUS: REQUIRED
>   	 */
> -	int (* queuecommand)(struct Scsi_Host *, struct scsi_cmnd *);
> +	enum scsi_qc_status (* queuecommand)(struct Scsi_Host *,

please remove unnecessary whitespace before "queuecommand"

> +					     struct scsi_cmnd *);
>   
>   	/*

On 06/01/2026 18:52, Bart Van Assche wrote:
 >   #define DEF_SCSI_QCMD(func_name) \
 > -	int func_name(struct Scsi_Host *shost, struct scsi_cmnd *cmd)	\
 > +	enum scsi_qc_status func_name(struct Scsi_Host *shost,		\
 > +				      struct scsi_cmnd *cmd)		\
 >   	{								\
 >   		unsigned long irq_flags;				\
 >   		int rc;		

why not an enum scsi_qc_status?

Note I have not fully gone through the change in the patch.
