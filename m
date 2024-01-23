Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F141509B5
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969367; cv=fail; b=jon/v2M4Zo8nY3ZZsgppz/m1/ruNpfBJ6a/EWbF3lUcwgmoni4bCtw3PLg+LSh0JgUldqkflasP0dg8Qe1KMuFgIFSVJR6H1ifNUaLRbkLktpWSHX3d0RumDsheLtb72c00mzOmhZqKOY0rRsv60QjYZ9UYgLSqWmaeugOjDPlc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969367; c=relaxed/simple;
	bh=scXG9iXLukNXvkFYi0kNNqwujuiEBvY5tSnEBvgpoLU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QOMvdvuWf33Ntu+dpiXS78xwcjP/0gUhfd6Pv2YH8qQFJ8oIOXzZ4/MjF5UV3RN3WO6am/mNQZEESh0usvISW2ZmzIU/V94MA2qwIINXbrX4qkRCBjF8uckLAva4ON7UOT+IxHTaoMc9+9jhwILsceD35P5pARMsmrPy3QcIkZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kqAy2cuR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U3rWnnQd; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kqAy2cuR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U3rWnnQd"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMoqpp004060;
	Tue, 23 Jan 2024 00:22:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=C07KMcUHZ2EkGwvMAvKm12nEN9TLFWcp1tsph6aLJss=;
 b=kqAy2cuRppRpd731roTRs3GVWxBu1f+FnA1wUKbGpX1itMuZwdggyyZDJ5qiX763atJD
 DEf2lwfBJvh9xvhkmOo+RhHdtyyLEb9eNBJb9VY5IOgtH73/Bio6VnFF0mawmsygR8Ua
 cBQn6uUn8uFt3/ovtQ+z7Czd0NAu03g7WJRkPkaBljc7R8wamZInyrhAvrd/Hvn3VoC0
 tZjSzgsUYfZ/4fCs+D84/NzSYwLBLkA7h2Sa0JsUJNvqwaFU8FiVruBHhevjzZq97Px/
 bwwi0wwCDXBjKQKq6Duomq4NZNS35h+um129y7Y80FmVNeQWYtGxMPsCBhGHAg+i95p/ aQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7cxvw4j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:39 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMpnhA016243;
	Tue, 23 Jan 2024 00:22:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vs32q0qyp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxhB/CGGXQLSO/HMPLpoXRkBhra0PsZ8ay95IYPaoiEuXlQCIKI+FQqaCSfvIdv/vj8/70Fzxdq+8bY4Xzy/PQxr9h4zQBpNrujCnjrOligSoMKVeEXd+Q1RzxNUlFCfgRgE16Qcd2UMKHGrIEspk2pTL8JYSD4xCUHkEF/Nu7JIgJVj5cqRZ3hrJQ4kpXzOQjeqBhfJAQQ4nSJJs5y5ZRaJmH8vkXPcDcovXImtVOAU64N9Hydoz+Z25tIvFFbQL6PUCCSvB05OqVgarlzymbIPjVyUbcwU19fuPN8qkFxbQh7EQ3t6w5auKsjrL264O7/Hzrb9DC5CPw7Xz+WsNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C07KMcUHZ2EkGwvMAvKm12nEN9TLFWcp1tsph6aLJss=;
 b=CVq/b3Z5zo133j65HzcunBgHRdCl1JC5gvMWxUkN7fZnDpl8eRVMizEsPLrdqr3dx94Buc9ph0DSEfKEWPvqPdmZL3uIM9ixsQVVd5VyDoFfPAOG1nepx6gXuKlyFHBvWiHC5F2VVKQQvuoKyTd2eSJz7aqRXZKxP3Vpz5EiJ+MlZ3IBQEDBX2d+ywRbl1Ifn+hLoS3ffIGQKAiAJAZCCJ8u+MWAbpfzNgorgspswl7LY6vmhIPxKZB1ik5gE/yAOQQmr1E3MZb4HDWeizCC+xBPeFssrFMS10oK1QxeRT2UqiW9GV/18TiFRzV5W49JoAXnA85l7fQNRR57C5xEjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C07KMcUHZ2EkGwvMAvKm12nEN9TLFWcp1tsph6aLJss=;
 b=U3rWnnQdY/HMQEZiSe/3slJe5QBjTzrzesJ1z4n0vjqaVLwVqG3pQuKCjjPklP0AOy94kY7uehK3GlVVlbnomUAlnCDQDKv8jj89X9RPlNZgGBikslbNIlNJHZfpzUY75pN+lt/HK0kNETIFGBSl3qG3c7F/Z/1zR7KBh0YjBEo=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB5340.namprd10.prod.outlook.com (2603:10b6:610:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Tue, 23 Jan
 2024 00:22:36 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 00:22:36 +0000
From: Mike Christie <michael.christie@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v13 09/19] scsi: sd: Have scsi-ml retry sd_sync_cache errors
Date: Mon, 22 Jan 2024 18:22:10 -0600
Message-Id: <20240123002220.129141-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0316.namprd03.prod.outlook.com
 (2603:10b6:8:2b::17) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB5340:EE_
X-MS-Office365-Filtering-Correlation-Id: 2de2c860-d279-4911-0635-08dc1ba96666
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	gPCuAd3u9M9IetbOplY7DMCwTQxX1/4i8KbW1lV9MMTBL9y0od2Gc9RuiXphoxZccsNgUdSs3IV6A6Bu2IEuX0s/6fwEqJgkI5AfeAW8vibkd3aD5fTw7Ixq1jjALhOJNd4I6t2lvtguQbZXe6DGEX+w16zzI53PCLl13AK6WcJgeA1SNqMJQ23ReR85bXx4aWfxWOH0VWrhYz4lPalGQuCxNweFMVKN2ShOtL9BHfJU2zhjK3pM0gZ5r7lW8EFqdphCcoMdyZZj0hP+62srErwM4QBQHGiM4+BiZ6/09dzk1drBpynXTv/mDAynqMQOMKtI8He8Pq6A3u6EC6FVv6IoOJnPrrDHJ+nYRxqO6JyDiRwdrbOpV/ka9o6fMh9h27b2b+ytYLqd6hDU8diiViAlCOco8PMH/EImmszkYO9dkCh/hDFf8XIYoQ+cPBTKx5rZlPs1v7cfoFg0DwUrmfoYRzHRGL6AKht7VCxCq7/aHCQze31+FLqn4Y1LADwy+/jkPg0//QIZXQ6t3eE+mo7zUpRZ6sxLKWkYyl9Pu36S+VGsb/D51tMiJwJj56cX
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(346002)(376002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(2616005)(38100700002)(6512007)(5660300002)(6506007)(6666004)(83380400001)(1076003)(107886003)(26005)(478600001)(6486002)(66476007)(316002)(66946007)(66556008)(86362001)(8936002)(8676002)(4326008)(36756003)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?q9Z3IksLfZoi3KrgmDg80MfxvxSt9aXR+Bwxn64+zHkJmQeNezBMkqi+4HRK?=
 =?us-ascii?Q?1igTL5IZyc/PxVJzBcuPnTfdDjnhahchP6aFIG4c3WI5DOH7NSQuSlQBwEu8?=
 =?us-ascii?Q?n6yRQCTI4xmod5QBh+vdQe5x1IpWwjn4C0+iVxHDssmQK06hNNyTTAg3MwcS?=
 =?us-ascii?Q?fucFhCP/O4UEmFE8YMCEHs/KUtyQLc0OfveJJ3BMI+jyteGiMhzh+FRnAl8d?=
 =?us-ascii?Q?kgZDsU5llRAYTsfGVZgwZe83EkdtDFslnVNbjVKmTj0F0Hz9oAakmpTZzr1I?=
 =?us-ascii?Q?AOLci2deHtwRMnaIZQ5Pjo4aZonuZKzDN6PgMiSzAIuqkjG3QB2KJZAxUn8z?=
 =?us-ascii?Q?a6CM91SG4M04Ztxv2qluyhMARKDDrTerg1KQtvrGp5cQ9KDimKgzXnE2cdnQ?=
 =?us-ascii?Q?czWJHhReoMNU2J67XaAszLKtoBrcWrE4yGPkpxBr9q1ZIdt1btRDGIdugmot?=
 =?us-ascii?Q?9GTQTzjLVFHU8GNhKn6XxSsAvxOu8DsM9Eqb3/Fv0RG10CYis/N3skbJsIM3?=
 =?us-ascii?Q?ULoWFhetJ45iV/q5cFR+KpxMRoYV3snwAsT7MbuPfE6XihzmjYfd6YZIMLc/?=
 =?us-ascii?Q?yXouFK4HZ3tKo2IWzQQii7aAt1mi3oEkOe6vLHVwiW6TqR3M84uPIn3kCs2S?=
 =?us-ascii?Q?WngtwzSgE5K9BV1nkUbPcjnmbsEnlc4J05SouFNXLeBQfqGNxZJqh4ifmAD0?=
 =?us-ascii?Q?mfB08usFoweUJcBssk4ULUC/NV9Vtv/vf2QJmjrYgWHYUFS6l4bWaBGuRUHN?=
 =?us-ascii?Q?OmCoGnAiyd7dR5rqCyk+JdCdTipxY5r9kVnrB8KKCjoJ8qVclEnfd4ZqZEY3?=
 =?us-ascii?Q?B4zhS0muoItQPV7Ia4w0DXX6DUdYc+KEdPCTLJGY1nbRWASJIREY8rRVDkYQ?=
 =?us-ascii?Q?x8RmJV3AnUHtyHlh4pQXXUZyThIiBa682KYAx/GBf/DQ8M+DTNkp5T4xu6hy?=
 =?us-ascii?Q?pcv+4Gvt+JoFs/PFC6L2ZavjSWc326RAoxgPSRpLSQ6Mu9hrg4axuYR0iUq6?=
 =?us-ascii?Q?PoqMIkv5HwGOJC93N493AGRBAdpZXKChZ45l/1ulOz7XcHiagNy9LxjzhE19?=
 =?us-ascii?Q?uOGDy389ywzKX++nhiEjEYQLhnRXhU+aan3/i/A/QPcX3Y8fb3esx4F5EZDH?=
 =?us-ascii?Q?efYt8hyGs9IeoJA7zzIaLy2WKnOfovr/qhDSsG7f1t6rdi8JX3l3E77DMl92?=
 =?us-ascii?Q?zsUt1ycPlrVp+rOGvbw6aoGIzA1omJx6tmK3IQxPTJgEl43MVE+KiieZhvDG?=
 =?us-ascii?Q?zCef2UuO4Q96//QASk60Nob+YGjq8cGTha3ng9aTClKK3S/gIwOxe0yaxMBY?=
 =?us-ascii?Q?APuJ4HfMy1hlOnC0JxPf169vmAk+t8+gaCZT7uGc4HAM6XHfIP1tguC/ZWLf?=
 =?us-ascii?Q?P4hH+PxR5JteWk9QIsy7WcGRqwevMBGbpqL0jBBWGvuXhHLUQhOYUgHb19F4?=
 =?us-ascii?Q?m8o3Tsx6FznCtssoBOGLvX+mjOoDcaZIk6VjdQH7qYaNaB0tNai9+owPy+sM?=
 =?us-ascii?Q?WIsp1zbRiFQzCaXTeVJWkR6ujSKbu1YQduL0MWTxRWp4hv9Ih3ScfLXVEGks?=
 =?us-ascii?Q?C+2jYmS+nZn7pw7/C7ZIvZyGGODfSWdfRA+hkSGLmZXJqtOOhRjqYMND74/y?=
 =?us-ascii?Q?EA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	22IqXqU9T8MwyhsTayPcL9s6JLHWfwLXUTAtUst6bE19B868qWLoqruUQO1ACHM3we/e4rUyx1Cj8PH7WdGRKa3aYniCug/gUnH0DHgwfv3w50AHp3busrauFClAKNRZdJ3iyx+N1U4VhleDYzTPpR4DJi1NOA0OJb1P16ULko8IDp0T5m0tbv0JvGtEd/lNfxY4mt5QR5NBTBS0LUgq5KZ4qz8ImLzGowpnUamAShWKOx8k4G4o9U3iluCCcZv2+qqbZSbDyEmV5YLJHm5TUGqMAgd/vzOzyhB9WE1+3tVNC7VJA78DEWOvN1/CKFwOZzkjgydXEGkqpOP4fLmOhamzCCE88T312jA5hD2/eErdrOMZJQH/6q6fPZ9tJW/gNBwVZQP/T9MWM04cdFfu2Kpb/s/bheSUcNoKZaEeP4H61vnMGw9rxhINSSED3SuwXqvcN6WGF6GrvrWAxGJnc8fNlDlZZ/m2yoO97QzmYldINUoikJzYDMvTQZ7RxOmNri7UHZC/oxgjzynfxVE0ICWI2xk0nEBsGh7Wr96le9fIq6r3i8yQoKwHOBrg9YDyq//d5wdwovxhQswjDNPMBm8goq9LTjWgZi7unrAXzww=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2de2c860-d279-4911-0635-08dc1ba96666
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 00:22:36.2197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tT3GhN215l6NkXvx/DG0QuEdZWmQl25xap/lUleakXtxnlhdNl2VtYkEULgqIvgc1X6rwlAshWmqvSXOoy2mY81LAcrBtZrCAj9K41yWFnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401230001
X-Proofpoint-ORIG-GUID: RNWtzW3kVD5hUqrMwQlD9rCFR0rSOXSy
X-Proofpoint-GUID: RNWtzW3kVD5hUqrMwQlD9rCFR0rSOXSy

This has sd_sync_cache have scsi-ml retry errors instead of driving them
itself.

There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cb240015bde5..c2068d83c812 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1645,36 +1645,35 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 
 static int sd_sync_cache(struct scsi_disk *sdkp)
 {
-	int retries, res;
+	int res;
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
+	/* Leave the rest of the command zero to indicate flush everything. */
+	const unsigned char cmd[16] = { sdp->use_16_for_sync ?
+				SYNCHRONIZE_CACHE_16 : SYNCHRONIZE_CACHE };
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failure_defs[] = {
+		{
+			.allowed = 3,
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
 		.req_flags = BLK_MQ_REQ_PM,
 		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	for (retries = 3; retries > 0; --retries) {
-		unsigned char cmd[16] = { 0 };
-
-		if (sdp->use_16_for_sync)
-			cmd[0] = SYNCHRONIZE_CACHE_16;
-		else
-			cmd[0] = SYNCHRONIZE_CACHE;
-		/*
-		 * Leave the rest of the command zero to indicate
-		 * flush everything.
-		 */
-		res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
-				       timeout, sdkp->max_retries, &exec_args);
-		if (res == 0)
-			break;
-	}
-
+	res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0, timeout,
+			       sdkp->max_retries, &exec_args);
 	if (res) {
 		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
 
-- 
2.34.1

