Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0222823BD06;
	Fri,  3 Apr 2026 01:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775180948; cv=fail; b=S9EM00s6chWvRkI3YXHie7dBeyvwSA8Yz7cKaQeXWYT0myQu/yz4pehROUfjUt8UIN4xbhc8NMeqJ54OjmmCz3j27Ugx6I1Qvp1GhHr6hz7zjWLR3IVVI19Zcvk9phFCzH3g8CytK8x2YmYsJUPxm+wYJYO5TiZCose4PcE5MD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775180948; c=relaxed/simple;
	bh=PqdHonXXTGfnhwBGYubTru50EZC7NygDRRWqaCZIc/Y=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=sqqPqSrQlnURD23PQlpwi32tYJgbrq2Mhh/Uzr7kWtc1sQnhwzUcuYTXICS+JrGXWbp1FJXx4XAbMLb+RCuKeVPT8o2h+H5HtXOVVSOp1iZjdujBj1DKb6fqgNpGtfq3GNuvhpeo4J7LVPoCZMzQx/DoGLfZJ4cN8iBIKNmh60s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C4N6nucY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AdiwmeiF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C4N6nucY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AdiwmeiF"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632FDcSu2209768;
	Fri, 3 Apr 2026 01:48:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=F+ZC+7OZUNQJ7+o+LW
	Zv8UzsjQjb6hxv/rXWAxEyve8=; b=C4N6nucYxiOYf8dkApA7gx+cg0H5E0xNaX
	5hwmDgqoAxoe+nArSekX2w/T0zYS8tg0MZn8bEwzfE5YgELSg2Lwqo56hEK+IJpZ
	P3ej6qglFvZ7ZSyNEGo1MF5HLN1O2zvvBctYkdOKdS6fyhPuVqXv9YmrQk/ojkCh
	R/3tmUtsXwnyqsTn69VdTvoiL0Tr1gMtmL65q9hwO/2cHnJSlwNlcyU1zrKTXhTr
	6FeU5t+CmOQ0HjQ5hrtgjjiJZz0oKRHpFW9w6Q4pGfWJQJ9g9uLeU+0UoHHOnIwm
	dueFnJdKv39LFZ1+si8dOBdyqO8khnJIjOfNPIuqi3UIMYESc72g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d66v5sdxk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:48:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 632NVLkU039560;
	Fri, 3 Apr 2026 01:48:05 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010020.outbound.protection.outlook.com [52.101.85.20])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d65em05p7-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:48:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FPqB8XzqEoBRXvv05fOD+tgX0Ty8qnXfOqrU22ID3XQSz/Vy5gQiwfQEXFNgGhX5JdULWO5RdMahD4iHh/bVtFfAg52bU5UQV0yp5arRz74xPTaN/hvs/cu8fQEI1iXxjWSZJIBKkOrIajFmAsazMGDIoDSW9GJPl2pMyAxj7O+3JZTHDo5ecCrJ+go/mgg55Cz7nQRYWaftWrw6R2AkLP9YAUbPlrgfL8WTEVBNW2XvNQNXFJrWYnLQtsmISZ8+Cl8KWZuuZY3xZU7DOi8or4bn1E5d/AqaY3VUH+1acL5PM3VbKe0TDG6MuROwLhnSe3JXnydxgmvc88EuHrr2wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+ZC+7OZUNQJ7+o+LWZv8UzsjQjb6hxv/rXWAxEyve8=;
 b=YIlIGDXzUIOyKhPkdpsPxLkHg/K0/oaiHAaZ1TGcEvgQxovgBLrPSjdT7Jw5jaJO4CJV9hxJwQuevHjIvUtbgTrz7MdK6PXmT8ot6z/xfVya5S228mzcYlcxRYcnlTCvqwKV1vHjf3Ayu2HY0ySXd0Zw0j+GUBYL6eUg9VJ0wROm91v0aa2sERAJAE7SMP0pVI2X/vh3S9eRM1VJEIXa2Kke5HCX9syrUCbMf5MrrWR3FkHN1cAqhQxQXiS7R6HwfLENrFNeJ56PbI77HezbU4J17AMokTBcplVWDmWCzouEK6EctTr88ozaStgj1irL3N2VqtbL1ut4lwGJOThbLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+ZC+7OZUNQJ7+o+LWZv8UzsjQjb6hxv/rXWAxEyve8=;
 b=AdiwmeiF+oDoDeDQVrAQMDJ9iI4ELrk/8VKu+dwiBteijDrxkykFxXYzmHmD3kljLNWopI+L2wJkMrvoLvomYzdbUv7JvyqQQB030w81fuojPCAT8KSewY5mEzMwWTLW7eItSrEVx/FcxlkmqgWH34zCPEfWvVYVL5dkTw190UQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB4496.namprd10.prod.outlook.com (2603:10b6:a03:2d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.23; Fri, 3 Apr
 2026 01:48:00 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9769.018; Fri, 3 Apr 2026
 01:48:00 +0000
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: <axboe@kernel.dk>, <kbusch@kernel.org>, <hch@lst.de>, <sagi@grimberg.me>,
        <mst@redhat.com>, <aacraid@microsemi.com>,
        <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <liyihang9@h-partners.com>, <kashyap.desai@broadcom.com>,
        <sumit.saxena@broadcom.com>, <shivasharan.srikanteshwara@broadcom.com>,
        <chandrakanth.patil@broadcom.com>, <sathya.prakash@broadcom.com>,
        <sreekanth.reddy@broadcom.com>,
        <suganath-prabu.subramani@broadcom.com>, <ranjan.kumar@broadcom.com>,
        <jinpu.wang@cloud.ionos.com>, <tglx@kernel.org>, <mingo@redhat.com>,
        <peterz@infradead.org>, <juri.lelli@redhat.com>,
        <vincent.guittot@linaro.org>, <akpm@linux-foundation.org>,
        <maz@kernel.org>, <ruanjinjie@huawei.com>, <bigeasy@linutronix.de>,
        <yphbchou0911@gmail.com>, <wagi@kernel.org>, <frederic@kernel.org>,
        <longman@redhat.com>, <chenridong@huawei.com>, <hare@suse.de>,
        <kch@nvidia.com>, <ming.lei@redhat.com>, <steve@abita.co>,
        <sean@ashe.io>, <chjohnst@gmail.com>, <neelx@suse.com>,
        <mproche@gmail.com>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <virtualization@lists.linux.dev>,
        <linux-nvme@lists.infradead.org>, <linux-scsi@vger.kernel.org>,
        <megaraidlinux.pdl@broadcom.com>, <mpi3mr-linuxdrv.pdl@broadcom.com>,
        <MPT-FusionLinux.pdl@broadcom.com>
Subject: Re: [PATCH v10 09/13] isolation: Introduce io_queue isolcpus type
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260401222312.772334-10-atomlin@atomlin.com> (Aaron Tomlin's
	message of "Wed, 1 Apr 2026 18:23:08 -0400")
Organization: Oracle Corporation
Message-ID: <yq1se9c24s9.fsf@ca-mkp.ca.oracle.com>
References: <20260401222312.772334-1-atomlin@atomlin.com>
	<20260401222312.772334-10-atomlin@atomlin.com>
Date: Thu, 02 Apr 2026 21:47:59 -0400
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0138.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::8) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB4496:EE_
X-MS-Office365-Filtering-Correlation-Id: 44277dbe-8066-496d-fbe9-08de912309a8
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
 pV0UBQRhQjAQjUox5IWj2MANfnAYL2eDcy+1SPIVPrTKzbaWG3vMOkJNKpb1ORl1n0vWBenNf5kIVFhFJgkFMp2hofTdV4t5xXBFPUxlKnXco13LGoxFPuoA9djjVfnpqkGx5yLerWbqK5bJ3yTCQSIbZ/+NiUYnVIIozNSmblYo5T3OYdnRcuILITqZy6PIxOvJJl0ad+MNz91GP69uKM7kFTaZVCNUp9Z/Hk4jCDEUU4MtkM0362fZf9WuF9ZyP9PJFvEHOoBUbBxeZL/7bhbLVGq4sLQ2FbnV9xr6RVHfluFSbNfO18fB80SHuyhDwm2XQyv15/uz9dTScOFLCdEGLhBEFjexle0FkAA7L2sDMIM0HMYr4LgdVK6Wzz0b9AEigNenkgYA9jxh1U5XGbteYeAu4gTBivTHqH4WIBR5DnWjfKkSIBSbq/7XUo+X3AyK4VQWgJVXrOyy8+4z3HaQvAFJ6v/6IYusx9E5BQfQBJww4mT+LhT1v37ALC5Sg1+deSzYxQH6J3gxoY/V7u5xr4icHAd1Xcqytq6RnSQhZGIMbrPW1MuPXleiuZ4ZFW3kt+jyu4BvC491EC4sRdz6842WQUuMCJJxCDEaktytAWy35F7k2LihDUSzf9qAFIXcCB8fRq+kn58H2r/CTuEtYBAyYptPG9YBHMWVi5iup16up4Xv2BVr31d6C1R2OX3KYaGIHtVHSPfKYHdhHk38eRaTdGvp+ElVQFotBNo=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?qiU7AQ7+O1ibtcaxND90IQ7lDodx3CJuMPuNnTrx0ATIWdd0sfOZe/pV7FpA?=
 =?us-ascii?Q?FKYs48QJBGwK/74ysBIKt9VRK38dk6ID5/Ty9/mlm2jnwUwY/ZMLsi44uuX0?=
 =?us-ascii?Q?9VSaj0/fV4cJVLEFbnhXbdKi+ucORgM1Ukn+Iau9tHVPQ3NcfvQ9Iq8NvVtH?=
 =?us-ascii?Q?9QVhGdTxxntFFPVpCyMPuy9SfU3MTdhLGs2LRTalr688cYC9kAppabGdsU1Z?=
 =?us-ascii?Q?37I0kqKYNQC0SjOE0k7w064fA3aMsNXwR1KHaxpTLV3Fiz5YxsFASoXozE9J?=
 =?us-ascii?Q?dcQFXKYpDhSi6oJgGEdVlTUS5xxioErWAaeP4/eYJUuXEc7dgZ6es76iCGW1?=
 =?us-ascii?Q?b3ieYgMfWeyGnJMbjw3e2awtRdh5KmjRfHZ3Rs5OcFSyOQcPZh10gyBJN9lO?=
 =?us-ascii?Q?M60jl8Rr1+tf85pWIm1uUgnrBBPbUDakrUnvEd/0f8SePGfo9JjVBVZbO1+e?=
 =?us-ascii?Q?oY1iMKMeGqkWsJLDLR+Zp8lCusa3xs/DdBTNfXPClPh3DyaOcds6rsm/vArH?=
 =?us-ascii?Q?5qAQpb4R+24FkoQ94+gFDFV2ypRGGlxqN1lR4TxPyxPVClIJY6QczBfBiWbT?=
 =?us-ascii?Q?w+7weDRUYmIYCOTgo9Aj72ochj+OPQBUR+e3kZi9SaeW75wBrJqQ2HpO9CKP?=
 =?us-ascii?Q?Sqj2Jhf7M+a8s13IM0RDPm4LlBEI46xmVpOMDLHLLO27bECYrbBeraB/Ya0O?=
 =?us-ascii?Q?KAGqBDTNFZeat+bvZo6vvFGGmfCt4GBfaQuNZal1tcngBnzt4srnJ48PImgX?=
 =?us-ascii?Q?JNmrYcsRAQsd8D9Jew940OIn9MXf+Mjb0CHSYeV6rMqG2AHqYs69VRDDOzN5?=
 =?us-ascii?Q?wYuJChveG/Jr6GIjMRojMsz+FE33jsQiNH5h7zcKuqn6ieQBD0/0QweV+j+j?=
 =?us-ascii?Q?iNex4AFLqzZoVOPUrXnHptafKQsM/oUTYsnDns6oOd+v3TS1kTSW3yBQUg53?=
 =?us-ascii?Q?Ng6Lie0/J6gN/TsMIdYfpaoJ0OFbFJB1lecMt/0WM/V0IMcuy/BaNOWVwJf2?=
 =?us-ascii?Q?KIZnDnB6oEETOOJ7Y95+qj0UqsuqwumMnExzTAzntwjRE2cxy5qHYuwS++tE?=
 =?us-ascii?Q?soJO5mUqjkhHDd6YtrvvG/84tsIwd/QPWMRlwVd1uFNdN647vTxpgybKZPzf?=
 =?us-ascii?Q?aqKMOWGKkfIOp1LCYIGmpnr/WaEkVUuBBPeiBuKFG6FcaVqiL4jjZVBhbWqu?=
 =?us-ascii?Q?URxsN+HePGrtsYWdigldCjwqWWCSlXHZISbmgV8dJwMH1d7Iww8jo5y4eUDK?=
 =?us-ascii?Q?SpFOnvyCs7aJFqIhTcbhAbIYE3tlfmguuSmzXeyDDfdmStfakBFVO+JzQ+K4?=
 =?us-ascii?Q?6pXcjfixPWuEnN3nSnXwzLfXUtNpnHMwNf4AdlLkSy6blqvy+qxW2iWPq6FH?=
 =?us-ascii?Q?/ThS+14MiY8VXcK1jXC88P0kRA1oZRSrQyte1NR7ldfnQJJBqmeVs8/cRm5a?=
 =?us-ascii?Q?k1jBZkch8RdewpcqumjnFRguKCwppKF7gchCM30i22vlW+2TiL7Pr91tEyM/?=
 =?us-ascii?Q?dHuDK6RW3jou5QnSiNOIqOTGj+p+7EIInw7xm7kdwwtXrCQ9ZODesFs6E/GM?=
 =?us-ascii?Q?Bg3+A7t7nD0wYQuUxwGrerfGANPWzesGJT8eiWEPkc3lySpWVYz2oTsCSk5X?=
 =?us-ascii?Q?5zhhmjWzaGxS0uFs64gS803rd5h8MnLKLeosqBg8CmaEcO/VyogHy7ZEU1xB?=
 =?us-ascii?Q?J92WGVt/iEiiuwtkwXD9Q2DCg3HiGDO2M5pD3P5tVSPbutBbQA8F4NXKVMuI?=
 =?us-ascii?Q?9KEGLFYE8rSkPm+MHSnL0xQeEvqahJY=3D?=
X-Exchange-RoutingPolicyChecked:
	GaNdQXuyRC7oIw7XziL7jDPCkl7MyqieVRLg3VzrS9EzJ0NPKjGCi2K1XnwPZJdbf5E6AutM54PR++CYvZuvy6bTDoLt5BHE+JEx9ZGnsVDsw/kfovHIt92DGs4Fbk/bFhd//GiXeRjGBGzV/NV9VvHZDxtTnZnrToqKaD9C3bFj9N9fNngwK6xNWeuaiIOi8v6Tx+RwIxexmvNIwuhcYEI5JgVZtImMdzaf5aiYLWune5Spb+GvAoSmLbUXoKPeiAWRaq3M/kFKTH24HcE4xiuDeE1sus6PE+bO93RBDz9+Do76zx+KEmL1LSQ0cDiijBLhi9UUmfdSyVWScWE86A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HMVuUyYQUNIXKwZ+0eTBYlTCV/sPCEvxVkJxsoL47TE0J3yEBsKOOEKZ5g3PMCpx+0viRxL/HBF/NG/svrikEeVlx0ZS71tDysDhYrmkeX7jVuFt52Snr9O8rcodks1NYmPHvcQjKdKtInO0bpq1JLe0vGlMIVEoQDlGwUSbJbTx20LCQRRJUxY2TRzNPh1TJsluzBVD92eVErptslNlDSxU+bA6etGYMAv+Gy9N5r2V7H2mjB3o2EnzbeRWAemj+tp4elWR1OEUItZti8D9G1zb6AHMBVJMBYQga4lPaQfTcluvQr7KLrOWkspfRaVYHmkl8+qSfMwjx5So0FKintAgfvQChqbaDdKQqCsWfFDZ9OX4hW5/0cQl0O/wHYNGIkPl6bsSpYMzNP7I4jlwvBfRvoLsfG2rr38P+o8nFDr4h6DDUe/nY6JH+nr3EF2/vTtExO1KsO5A0vQktjpzChbJGHsOOTubscavP7IgTSKaXy2B+pq6yZ9wVS1gTPXnYoBuS3+xYhNyyXfLJvjy0zxZmgAZD+Qrcx44wxJJKmpJ8GW4P8PvXko/8udSgooSyhfHDTPGkF9oiTnk1ltBuhYhsXYvspddI1gfN6Hajoc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44277dbe-8066-496d-fbe9-08de912309a8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 01:48:00.6663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4e0M1PVTfoAG1J82p2fRLznXQA67ZKz8sU26MWDeQYvKYWdR1OEnaLatrgH5P4PX05h9gAHkfJIH7DsB4UEtlo5EJj7wTfDIJRCwbMaHzRM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4496
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604030014
X-Proofpoint-GUID: r1Yisx7I42lI-vH_dfMEPMNoOSvQcINk
X-Authority-Analysis: v=2.4 cv=G7cR0tk5 c=1 sm=1 tr=0 ts=69cf1c56 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=mg_oENNr3j6OL62c5q0A:9 cc=ntf
 awl=host:12292
X-Proofpoint-ORIG-GUID: r1Yisx7I42lI-vH_dfMEPMNoOSvQcINk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDAxNCBTYWx0ZWRfXzI3E+711KSni
 inWdTr26KRy/3ovAZJFSVeiHhg0LTcbA1Zc5fdlHKF9eoDqU6cvCJl/jJunGGxXJ7lZ3ldd1UG2
 /IxnU+6Cp8OKsr6xQnELXUo1V2Ak+V8zfCExA2G3pq8JU52YyOocDoVZ5F4zETReRxaXaogNEJ9
 Pn/2e27OaB6XmxdfZrpEIBzXh17dOfISt8fQYKcIaXxwTXPPkS1xSaBfH+6DGnZbplyZF99zCE3
 P/mwgQ0iXb1NVBjLbxSNRussD0MYdGXG/Vg/nj6Nivpn+6ct51u3/31GfIQ7u3cT0SpkIZgvOXt
 hpgGaTsgTMYTfnXZCknvdNEzP6Oo3251kyY+cAju/YzVq4DVVqN1x4JFB5sGBenHHEbatnWRCtB
 CtisAMdNKBcH/Fel2jaeIWGwZET1fn4+u63pWEQ2wGb88o1hxmb8wIoKt0FPdIMN9cB+f57KsEp
 hSS0P629avAAGizLB6TgFmyCpuOyeZS3Af72hOgw=


Aaron,

> Multiqueue drivers spread I/O queues across all CPUs for optimal
> performance. However, these drivers are not aware of CPU isolation
> requirements and will distribute queues without considering the
> isolcpus configuration.
>
> Introduce a new isolcpus mask that allows users to define which CPUs
> should have I/O queues assigned. This is similar to managed_irq, but
> intended for drivers that do not use the managed IRQ infrastructure

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
