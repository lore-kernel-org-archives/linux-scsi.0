Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9A84C62
	for <linux-scsi@vger.kernel.org>; Thu, 25 Apr 2024 01:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714006951; cv=fail; b=Nip34bTvp88/6OIYQ1j1e0AlU/PCCTZIggqs1rboIIfETba5QA93IKeZ2KaRbJ+rGOH/OB580sBxlOqaj3Nk0FT86hXDBtiBzjkceFAbIgovLAfHkOtnewj2C5Pa/zIsw9nqqjdhLiMzAqWPtl4nbhhO1plURLUf3JKCefcWNpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714006951; c=relaxed/simple;
	bh=lWTALTETvOS8LTsJK1CTLklp5MN5n0sypAUcFtgnilc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=AWlqfZDOJSxocqeweky1k6bwPrkVXWHbUVmFwng9dfw8JQ6LMfd1Sw3uvFpyLNqRbnNbHJbpnoy1tl/tgZ8pEUbOppRjQN75/XINjun9pXA2WxwG+3ugWsGtDcnfDFQjtrrWlDUk7Q0XcgKrbohottpeFx2VW/Ur9kqWHA0lrto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Lpjm7PDA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lkyMIZ1s; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lpjm7PDA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lkyMIZ1s"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43P0iT46006388;
	Thu, 25 Apr 2024 01:01:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=sv6R/kAyirdbR2X344ncFkE8HTJLWI8k9PxjDizXmpM=;
 b=Lpjm7PDAeXAxkxTAIE900sZ3y0DHs6dOro4duRIiQ9dy+24kvPn41fI+UsOCPEAFdcXP
 ZeD8KYWIcFPuSzaRwZOLl7/7YteD7XNvg9qnJN9SkOd3DqYO4cSjy9s4C+ltNEYXJoZD
 7j4F1I5yOD+LgCrwATrYg4eHQaZb+rCi3UdLswwsGFYPwwiUGz/2h3XTetegypQ9JYOr
 QkEfbbIpwN3YLyaC+vDYPlyTJvraZMqvO5QRPWjI3QW6HqciMk/fwcxR2dr25HjvkK4b
 ZOsf0Qjt3C9iRYuCLhZb3HjtPh9AicZwwdSQwz+6KP37Gmd6AYKVoL95/FwIyCUYuYJ6 rA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xm4a2j69w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 01:01:53 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43ONFAAK001768;
	Thu, 25 Apr 2024 01:01:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xm45a8ff2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 01:01:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HQciM111LpiAv3JsqXbL7vL2yblrlDhWW3ymuoE9/0PJP9AOXH0n+yBAqA2MU+Y/j5XtwvezeTVbHqCuy1DVESFoCM4UB9W/UsPsOl+AxapAIe3h/PVnWD+A6dwj3DWWAGRkzvZGXNePPQfOHUhRIRPESZObo2l+k0lp/DTcd3+5UrJdGEr46ZBDUjWWRGpu3KHrHpkdWeBplBBYtOKP2pFuM0weGVuigLQXXoWhWYMeuMbuFtnvSVPOlp6wlAzDfB5VtA3XvduSSSX59MQLx3LRQPkQraG6d9NhIMDCYIeNrfzz28IJpdJMW9GjvleDT6cmq2I5Q+ngOVHLQzal0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sv6R/kAyirdbR2X344ncFkE8HTJLWI8k9PxjDizXmpM=;
 b=DtGIf1nzHZd7sgJ+XKdJ1gcX6+wiaqEeWSbTI6NChGP77Y7v2u2oG6MhXB9uW36f6wDcBBC8Un6vY+hkAWh/JzDkfZVx/TxjkFP6H9aMu1KGl1ZTKShkX0SFSHdPgmJI4QZtZ/qK9Oda5Z8g5Ik5WlpELor0SrDn7DO8ELfUNiBOD5xUURlTJPlokR7jIgJn+s1ku9qfOyfo7IMony5JVn9Lb2ScatIv8mGv5wmcAKnV7XBqkqddvL3wwDAz7I9WkDEEKqpczB7PkThmr6qnjo0htdzQ7Ijb3RORNlE1z/AnV+DaOUbHvPUkjpyJ0tCjrq+jxEut13NNiF5pk6Dqog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sv6R/kAyirdbR2X344ncFkE8HTJLWI8k9PxjDizXmpM=;
 b=lkyMIZ1sZ+ryMOd20ELeeFg4XE4d5jbLVmWKy+LNmh5F36x8ym2RLtdaiveIMHDcvJ7r7y1IJLKEGi063UdLgPT9ssn6Qm8vCLEnRtXObocf2AhiGatyrdMeNalxe4/wnJC7h1y2ZbRdDC/Y3Atz7/b2ZGGu+w1BfA/wHko3taY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB7266.namprd10.prod.outlook.com (2603:10b6:930:7c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Thu, 25 Apr
 2024 01:01:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7472.045; Thu, 25 Apr 2024
 01:01:50 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger
 <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>,
        Stanley Jhu
 <chu.stanley@gmail.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        ChanWoo
 Lee <cw9316.lee@samsung.com>,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: Re: [PATCH] scsi/ufs: Fix ufshcd_mcq_sqe_search()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240410000751.1047758-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Tue, 9 Apr 2024 17:07:45 -0700")
Organization: Oracle Corporation
Message-ID: <yq1seza8dc7.fsf@ca-mkp.ca.oracle.com>
References: <20240410000751.1047758-1-bvanassche@acm.org>
Date: Wed, 24 Apr 2024 21:01:48 -0400
Content-Type: text/plain
X-ClientProxiedBy: CY8PR11CA0005.namprd11.prod.outlook.com
 (2603:10b6:930:48::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB7266:EE_
X-MS-Office365-Filtering-Correlation-Id: 436aa179-87af-4e34-19f2-08dc64c34a29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?V0ZM2xmEZmvKANCp6wXxhpDUsNaoBzUKsI1xTSAUjlMPDigpb/h2ncwbcw0x?=
 =?us-ascii?Q?gg2xegLxt6JuT31UPQoBQnbkZDL+B/etWf5Q7EFJvSS8Lvyo2lERRMNmOkWd?=
 =?us-ascii?Q?PfoLq0MF1uVkJEmBc6dleYGi+Cy3ZxjmheBO9RYrx4noCtZczyWw971GWE8C?=
 =?us-ascii?Q?QaAEqY0mONTQY80IglW/E43VgWX/xGOgwmMthX4A0xvDwz61I+j1jfNQ1Dar?=
 =?us-ascii?Q?ZVrdLXJ3vSICCAhigAMrVIt08kyjOdfz6JdP2XAwZy1DUEfVY0TIm0MooSQ7?=
 =?us-ascii?Q?PEBBq5EtFr36On8aStM6/l1IDVzN8kMT9hb0fLCS6RwxKJyzk53OnumM1k1E?=
 =?us-ascii?Q?N50BjG06HTrrtK1drdoNxbY3s0U8yP5j8I1b/mbEezUf0x/V8jgzzO5Kzs59?=
 =?us-ascii?Q?p0tp/ibTDjRcLerNJaKButtaRZIIJuoV/6uNyVf9+QY5aPvv3x77DqERA45R?=
 =?us-ascii?Q?4axpX7G7WppffIYwK4WnmR4crwCXnvlPFLuu+fTdhWNEoEsv/hkWCnnp43eU?=
 =?us-ascii?Q?+NcDkn1lpV69UisqQYZKkKoYGGOFykr41ErdEBVyy8Tjwb1vzeeuXeHWP1kE?=
 =?us-ascii?Q?KuQwU+V0vKp0cSWXaYC25doDLUX84ATLlwbcyzqCENwrj/V48lH/nOuiiQo4?=
 =?us-ascii?Q?+XScjRemt0kGGItK6HWalKqgE5q1JcOCg/EcnAcVySVwGVh/GN8f1UGsin3C?=
 =?us-ascii?Q?gdxOBsbUf6rNh90jmT73Z0ilZJG0hInCaPfZR25RbY+N5+WAgxS7HWrLF8W7?=
 =?us-ascii?Q?w1UkFMyTNZhk5XJPifeW03ZobNXHlWuPneWbjDH2Cj+UShLtLqt4rYo8bArS?=
 =?us-ascii?Q?6DhdtehABGVENap5SnnYLePHv1Wa87+r3FRaaSrXaCa4TOq+yefD6WC38Ioa?=
 =?us-ascii?Q?znHeUnNqfjZi9e/8gk82ZlRPjRpHI4erfnRj2U69x2Jne4d/XjmkqHdMEPPH?=
 =?us-ascii?Q?LoK0PEghmCBjLwB11Oc3fRYuuXrnf7XKw3j1nnTowA56MFvTs948h3L1/QVj?=
 =?us-ascii?Q?jzotVwMZ96p/RllmUsnnLGxtHq3DpdCdxaC4qky1j1cU5lkoaBSOkqL7IH40?=
 =?us-ascii?Q?cXEmNq1SRPRROkdNO/VhGZUYQ5tBz/0NcOzY9Vya8OsPssRmnQo+TEwOmoOk?=
 =?us-ascii?Q?hcpoMswJG6d/BWl95DsZwvs3j0iWdiYWJTiu+5JKLx/HLijSIZyKX2lJB6Vy?=
 =?us-ascii?Q?hQlts0Imi9HZJtnoQjnxnwK/iwd+0RlQrHSBV/h8Mi6wFjs0oHdBQZHp5KZi?=
 =?us-ascii?Q?3Tz0cRUxZefGO9QHzWjwRVDYJ+2sG2U2QlgGwjZZQw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?GNn47Yw16Ml+92oa5LIbiEUTiA19iArL/F+E8Nhz7HBTUHI5/K786Uo2I2ya?=
 =?us-ascii?Q?CkDYPv67Ce3A298ShZQ2D28IW6gZOgE7zkEK/VmBR7wgVDgO704LGMcDYM1a?=
 =?us-ascii?Q?+fN1vJxCtg3d/ui2hk6OCQotsJZS6SnDi9IBhRpzvRs/1BTm2SOsACnvZer1?=
 =?us-ascii?Q?QrR1XEw/TMD+TzlKbcdQpXp4iir79YB9yTUVu8TEaGlKS6DTLpEtx+JwpN9I?=
 =?us-ascii?Q?9Npgs69vKzDBMQgAhj9jq9porJEub8eK5AyjzE9TH90BwLkMWIBnRJmuwd5e?=
 =?us-ascii?Q?GZDateV5TzYi3pdC0C8MfpejOC93cpeC/CBQ9CotJr3dj1AUKYiKEHgR/wNj?=
 =?us-ascii?Q?T8o1h5e7u+vjuzTV+eyG3GIRyCLp5HKLleVH9LX+wqMPHGQjRuzydaJOnoa+?=
 =?us-ascii?Q?AmUgSDSQi0uhTmfDB7Z8SwTFAri0Cq4nD5FVCZi/V/ayWdwC65YhcgcM8uO1?=
 =?us-ascii?Q?p0mKOClzZGgNWToJWnUq6PGl0x97mLRNO1pEDKWHEhK4bd00+r0J7j9yTRMI?=
 =?us-ascii?Q?WAcgOjFzEtHzrp13i6nbWXLNT7JVUoQ/2LGvoFm8evinn7Qfn3zeqvBG4b5d?=
 =?us-ascii?Q?6duDVjeCPdgzfWYRw2Iceec/BL/eLwGSoaJ7fqUPA3G5fNAa1kIq+y+TLmqo?=
 =?us-ascii?Q?VmVo1dSDA4Vvk8p7+1ZwT6D+uXX6TnshYf3bKbBd+ObbPeOWBA4OO9ASKbRc?=
 =?us-ascii?Q?N4nNJDrGfYjT6SM1z58Dv3GwFEKMXGsuyWkn0kZHb4dvN0D3nnpVWEK5mlFB?=
 =?us-ascii?Q?7b1OfRxF4LBwx/iOJlf0lWWZ9dRDrR9uxdKz3S+AeYCAIdFjDFhbNbAYyW7G?=
 =?us-ascii?Q?t0UqwwW/IYYn9UmOMkg7L7FMAKZM5GWz0Zw+VMOj/u1WqX7QdfmLPTs4RbEp?=
 =?us-ascii?Q?6pQYqxVLDac17GgQ7LXch55E/XCRDMgq8vW+KH+ZovSosyHNUYe2nCj/hWdu?=
 =?us-ascii?Q?4YKmKFCxkOJ7HWUWQLKu+VnunzIiyw5mi3+qfDjM2C8AMQtQP85tCVgRKSsr?=
 =?us-ascii?Q?Lxb6Z68VGnJYCwnAwScop3XsBE8rSWPAUpv27B5BldZEi02rn/7A0X9IEEX/?=
 =?us-ascii?Q?vSHT/zhkDSeWXa0UXkQ5kxt8RdOqoVL4Nie3OR3brsTeuftwQhTefXwPRPwo?=
 =?us-ascii?Q?AA2XflHYJze6BjQ+896FQprt/+leWsEpITDqfM08p01tdK4XgG/VCP0SBS4Z?=
 =?us-ascii?Q?z/BOagYxyoFaPlvczHi8xstjhFlBvmG/9lIUoSfpQz/D2PG5CvT+Z7Zfg1T0?=
 =?us-ascii?Q?6lyxQYZrrnkDb0CUHRGt5iNFc3Qlohf2kXP/3mPAkTU0r94wZRrHdNpNO5RP?=
 =?us-ascii?Q?axCJKYOnszuvNe+JVPcNJQEVdqT9iM8wM4wQfTmI9MvS6NszssocXcbhP0it?=
 =?us-ascii?Q?TSuVhfdZH7Wu1CRm9EW6OcEVc9y97FRXfMsUjHxlhauTX2CotK/jqKW1uSDC?=
 =?us-ascii?Q?2ZKBakKC8vSLjvHOhjUniGjxlmmblosCtFzT64n6IW1IkQeRD0ZWrjpN4XSo?=
 =?us-ascii?Q?WQYbAETvX/8LvPv/v9JdI8yNmchX4tBntq4H4YRJnyOpWX+VB5i44j+Z4kqQ?=
 =?us-ascii?Q?iPx5HV0SyzDO182asthmUyhy/JpV9wc7jxKyYFLB/Erjcbk+4LfDorM6l5Bj?=
 =?us-ascii?Q?5Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	jY6Kwc82DdTY2F7xiT+J5/JWCiqqxG8T4ILc7U1BVUrTpRNjU0/44ib1Vl2wtlQ9ZN909Pd3ZUzdMMDgHIqNfnCsASo3YptaSAkjHuVFn9aYuv4j/s+Yq/VohVb0gem/+3LERaB4H/SnAbl85/jPX5CZ2VKoNDvpiRrX6NBoF/IolEKnwLcW2NYd1mVOcWBNdGfQRyp6LnWRkLX2MaiZ4QO+1eCq0Tw3Xt6aKu0vHnZhtoNSyxqh8P9RtCxXmSKKuDI9auF39qsIdR7P6Bgprw3V6TU2smOFjlbJtea1S328qL7OqdG9e5Q/BJpo9pfO7XNFLEUdnRc1jEUxvQT4zSezvtWbVVz1sLE+mRIfP4AIoraS7VTKCJ8qDLEjJO+bLva9f0B8qQe/uoa7DruxxDqneecaHWkG/AAAxsAkLlGSmeVQ5qA6x7K6p75IDN+IJV7wn/2CYu16WrI4leZvflLv26R1isTbJ19+Zi4cM7htC4VfC+1l0/q3p/d+PI9Juh5KTPEpkAGJo6IZ3YzULSTjUbRYJzpDXlzO6JrhELYZZIyE1NngLlN/tViyS4UZqj3plMC9b+uevqHW9AnUhpwKmzAN4lFs18ZxH/JmR6k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 436aa179-87af-4e34-19f2-08dc64c34a29
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 01:01:50.6266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QWZAIbK+gkd8l0Ygm0SGm3UuFp67byXS3M7G1vFQmQNxT8jeDcTwLwGEzqPJDVsCMvW/EXzdm2ipjxGqTZVZhyqNLVcdCqD5THFuEwaVOxk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7266
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_21,2024-04-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=947 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404250005
X-Proofpoint-GUID: aG4AirdFjHaLyBj3E5ZQE2-LQkST00pE
X-Proofpoint-ORIG-GUID: aG4AirdFjHaLyBj3E5ZQE2-LQkST00pE


Bart,

> Fix the calculation of the utrd pointer. This patch addresses the following
> Coverity complaint:

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
