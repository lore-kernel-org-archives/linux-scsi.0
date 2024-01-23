Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F051E2114
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969491; cv=fail; b=LFPra9LN160PiXMkYW8addz3w5A1KSm2ajnq0xYbGE7r0olFC8roGTbtJ7LvZg8hy3YQAKP9TKwf7wvpDJlj6jNDKo5nDwF7LhcigbdpFX17kQBNgm5c8CKTMw94wOtfZDsZNZKYvqj+/j/emXKpFUzH+87p6ctRuYHT2gwvZMg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969491; c=relaxed/simple;
	bh=xIKUwZrg1Qm4PSa5C+70iUX+HOZO5K+NQct+3fWTgVY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DUym9pewKVcfVCyPKlRw511ZoP+wsKXPQ0lrITGs+M0LqbOxb/lpUZRcJpXMr6GmePYqjM4CFuPutsRVEdwulahmLGi10P45bmUsRmjeNanhunUNi+wnaru+dGxkwL4tSULlsB3nPZgbSg7SGlmGaVHLGmKbEUriOjT9Nr9Y4iw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Krca8nh/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=se3okOcf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Krca8nh/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="se3okOcf"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMopsQ026498;
	Tue, 23 Jan 2024 00:22:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=mEzr8XKbZ5PUhcNAiOILij/41wdOkln2wVhPAgoeeB4=;
 b=Krca8nh/Q/wUsDmMlfb6ypHPjk4YP8e2RQKWTCCz/Wh5FChjwwIRditJDqPlJuscvIth
 m38v+AoA8JGXGm+mKwO00vjO/Cj/Z3jm7P3iemk1w+kmlhfUW8iL5IHgXbbxeupmupjH
 IiL/6lpQsxRitV9x6yhF1YGk6gGHCpdlkn1a/aFmqNAdHu0Sr7tUpeWMr4Z9GKUD7ItT
 ZouDeN+YyqKYpRSGNM1pmLKTWJ6rSt1E/JxTX50IicucPK+t3VQhCGFkTvjWAX/juRxM
 m/aH7ogUqdKd3rMUMiDmx57y+vQKhwBxlI68B7A90GjLWXk7w5SgfPQX1LNKO6NOzswx 5w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr79vw0wc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:41 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMlq82016242;
	Tue, 23 Jan 2024 00:22:41 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vs32q0r12-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjZmoBEOk/N4bheh3XoL2nlJTvjMFb4YWxnKVmUQFvAvsU6QsjuqvHT1SmG6SQbGIUz9jEdgVmRrOC+bLWoUBat71+Z3qBfekjhWCgQtaiCTpr+I/iqw8o4J3XTTpAMQEewme62fmHdQocdkhA55VzTQlpDqvzSs2D2+O+ISXgNQz2kqgKpn0saV41+lBU30WIV4sxtTA/FJVNrlnwTWtpflrx//IDVLYQEF/likZc8ETxFbXmcm6qvdNtWqv2if4LCGYfgxWo2zj2KY5g3YJuTVpUINidnfw6JsfG7VYLz+G9RNlmc5Bcox+QNgtp4KeXSg80zMZl8K41QpLe/6DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mEzr8XKbZ5PUhcNAiOILij/41wdOkln2wVhPAgoeeB4=;
 b=R7HZgAX1IDxu/QXNrQETWYF3cMXmG5/FPIDCHBa7/m9k+H+Vv8JuqQVD1yvXKlZgNN864C+hTB67QgrUG3kRwAAuU3da/PNeUH/gl0XP8Ta9uX4JfietbjYZytQTc01njqPUiE1TM5ZChd/tqbn6+qaOZcIbMhywCVb4vbRBj2mC2Jediq+lxsGBXY6UUSFRHxzlRtb4Z5nYmNIkyEoU3PU0E/dkGtp2k6E1VpfbwvogtSlAkcvGmPLMO6qCpyTGvhScSwkrT/StffMCSCPE5nQ3f+K2zfpv06tXdsbP15E4Nz1Vco+wUZrjPZNve4/C60LznuYa+1YVspta+mEH7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mEzr8XKbZ5PUhcNAiOILij/41wdOkln2wVhPAgoeeB4=;
 b=se3okOcfpTQq0oJD6YP3QGsWeBnpVna/+bbt0ZSotu0ZSOr2SpzFZDnuDEq4sgtGNDDltyJxpLZmdZmozqXvVXXGacG04986FLzzcw9EZoXYV45E0Yukj0PzFDBSaBab4MkfWBoNRZ58g03A/Jv5tGOxzY3w/TwpLHfENP9anzY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB5340.namprd10.prod.outlook.com (2603:10b6:610:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Tue, 23 Jan
 2024 00:22:38 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 00:22:38 +0000
From: Mike Christie <michael.christie@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v13 11/19] scsi: ch: Have scsi-ml retry ch_do_scsi UAs
Date: Mon, 22 Jan 2024 18:22:12 -0600
Message-Id: <20240123002220.129141-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR08CA0029.namprd08.prod.outlook.com
 (2603:10b6:4:60::18) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB5340:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e2f792c-e01f-432d-ca5f-08dc1ba967fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	hoNl36n+DsuH5OgKUqwicJ3FEVAvNt0uoWEOeXnD28gE6l/W+Cl2uxcxk5EzkdGpMsii972NJjnMZ0dgrKweYV5hOwqKlB7VMdsP3Knk8meSOKuuI2AF3IrKzAomYb8mnKNVMAIPn54xRbXVMmFd1hezevdMAUc8JcIXo3kYDbfiAhvXFnDmWvYxD06C8uRO81LBOcDbA3/XIhF6fTA8wU62D3oA6ySSJ73MbTh0D8hLwKngfUa12tmknwP03FrK5/1YhKgvyMXowMdGPp5vrom2rHKQPw2/J2TrWMWAAw0vIbn/hfcodgjCqlxrOVH23yJxBuEHIjtDhwLawozfGh9pdykSO/tUO4VtM0GBwmE2Y4Iip5wHo41V+gSJbUAPNuVn8A9tNyYyLnmGjndfk2xW/lkA9kNBysomMVDPKMRx+OP6mshq09a4Ah999zmNnRJEMMxZ23dvZdr05PPoRZpR/NqZXZ+dzlm4S2yNFLCy2QVhgnx9jZneTg1S6lG52p3J8T28r54uhGCzJWBMNp3Gjqvgs+z6Ts7niQxUwKv8gKF5LowBeRAJ2G6yGxmdQJB8qWqeZnfHOMSFusFAnboz5vWTU7ZCk7Fjp061cli9uvTnfleB/Vokv4TFk6OX
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(346002)(376002)(230173577357003)(230922051799003)(230273577357003)(451199024)(186009)(64100799003)(1800799012)(2616005)(38100700002)(6512007)(5660300002)(6506007)(6666004)(83380400001)(1076003)(107886003)(26005)(478600001)(6486002)(66476007)(316002)(66946007)(66556008)(86362001)(8936002)(8676002)(4326008)(36756003)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?6hicmkJnSnr6HPKZKbby0VXWrhCBCBx+OCTqqFa/mw017QwGDJ85eOufeJUa?=
 =?us-ascii?Q?xeM13jcEuHZetLH6T0RsAuQxil3UHEUAp+jT3Jmfh9cCzznhJFsBUaqGpsab?=
 =?us-ascii?Q?KHo+JLAdaBnn1BZ1NzzQ3zOwSvcQGcNulJur89XC1iRi0EQ4cIa0ZqFgzyEi?=
 =?us-ascii?Q?XwK2j/YVQx9O7Xytu+IkJxprzrKc/AkxmDOsE2q9BfoF7N7LqzhzH0EqDngd?=
 =?us-ascii?Q?DSYSvjSsJVOP/u9LQEZhyU9LNClh9fVpsWl+Q4TbHZg5SzuaxzLvnX5xEYoY?=
 =?us-ascii?Q?DU5HRFBRCz9GZGanZJ5m3aSMigydZv77e4zFr5PpJ48xMCB8uxGbSv5iRoV3?=
 =?us-ascii?Q?AyJFkbUcHx2SfRmTnmvC5C1o6lHSTOxO5zgwdYNXiKcl9R8Nu5v6VaEBjHDk?=
 =?us-ascii?Q?GmQTGQuduKxWVA+1v0FpHz+9MjhKFpWeApgert3BjI1rxXMXsozwkEbkVWCd?=
 =?us-ascii?Q?mWxS7WmJNvr88BEioy7bC9qube2/DiXnfVsAnWwVHBavFF9eeMCeWYEecMFw?=
 =?us-ascii?Q?KFVovwnpEFPKrK9pmLvwrglOR3Bt2p5DNo3wMB7+/KFCRKtv81o16zbAP2TA?=
 =?us-ascii?Q?T5SkPu1ms7MGl8Th3oCBuZEMSAWEFac9/jd7aIHwk7N5z4RF1SoS9Apn6n7C?=
 =?us-ascii?Q?3j0p1KyGF6qvhNGx/ui+YcEYpOMAzadJS3e3s9XGMJoSGHHvdaghA783pBB1?=
 =?us-ascii?Q?vBLvshN4FssNH2Ft+BJl334XZFxUEMeLFYDtjyg6KcZxzhq0sM0vwIeIL+qP?=
 =?us-ascii?Q?gD4EY8isTJ/1egQkNQihOK8dRJg92UGcbylaSng7z0y1okWeY7OOPGty/+sS?=
 =?us-ascii?Q?8gA5z5hV79IxAs/EqH2Uq/UtZA3aMPYuWJw/q/sS/vp3+AaYgwHMAPRF/Knu?=
 =?us-ascii?Q?Wlqm11UE7B/7KH4P1YjtqO4Loeea4e47JnCzaMSiNYNaa9nqNcIxLQzrMLhL?=
 =?us-ascii?Q?NHn6hfIq3Vx0MwEa5rgVi+J4e/86rOB2wP9ojDeheYx68Cp7lSdY7km6EuS4?=
 =?us-ascii?Q?tTkMRAPdmEk+GPo3brrhlskiTR6Y/+jHd8XmWOZdHBvlthXPv5kTIH5gwA5R?=
 =?us-ascii?Q?xkoTI1U/iUF5SheT0CYwId+HOSbuoLbCjXgUlHBsjc2g7TkjnfSf2qRIAU0g?=
 =?us-ascii?Q?y3pG/Dc4+814zLxHtEvhR6aQLIlKps8UDbm1/O/L2tUnv1xr9GeKT7Ht2b5p?=
 =?us-ascii?Q?+WOZs/d/H3wFfQYssubouilZHvDjxuQuHixT059PY6t7Uu9Q+ALN0ynsFu2K?=
 =?us-ascii?Q?8/Z+bGmdRz08qJYgNbCpt30zYpSD+KYtJrTK9mQMg3oTTKM9mQCJ8ktm3DHw?=
 =?us-ascii?Q?HmUq+EleLuYFrUXQONctzrg8pCKoipZpVOvn3HC4mYX8WPT9XLxip2pW2Ars?=
 =?us-ascii?Q?QTzFaLJu9KHQt9oeCDie3Kye3VM74h3yw3BhG/bWtLoPAhqML8OIyrVWIvEA?=
 =?us-ascii?Q?KDWYg6jMr+CwBijbQEqRd1CXTMByBAvLwgMOquaw0Qabd2H+K87Ou2Q6fypu?=
 =?us-ascii?Q?moZbtrWHQtm9OUINqEPH9rfdVIfn0gy+T0WZlUhOyOOPm+2cinRKx6JtVWF+?=
 =?us-ascii?Q?h61UcGpENAiK9C5nKRGGWCsPYj/v20aQbt05KxpSDsBtM7R7OBDZXc0E/Vvk?=
 =?us-ascii?Q?Fg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	RoR9O4mVKEcR4lv3IemEQ3H+cc4khwJdBH4ngS4FRVDhwi/IKYpvQS7ng4fiqIZFvnYePRHeXwFFpShDpCv1PQFe6XsmiMkaW6d5LXkwTt5QXkI8rPjn8UNggUnTS3mKTn/uZsAtkkYFEpHWvQl6nJCqnJx3XnXTuCYhvHTgagBU4YzjlPxpHxuRdFPBmfX69+qMMIIamA13aw7VbJMGFaG6gBbfUOImHaxaJT0VR9zpY/oCQ5mm0FuGuefavHVSJmMSUAaN6SoHOKn5DRldEZRuuZmYJDL9imqJ3GIjvsTCweyxzWUPmPVpIeRfh12xQux7o2wQ8Q32Jutm3/VF28qP4LZeXmiD22RehhtRTDNrAylXAMyq8qxtxlhnEIseNhwbhL+kEfpnU8OAfaFe3mFCDOgP8uhfshP4iDZ1RJSl7NWD/2K+k0A/ELjtQiTfvOfPrQ2pF//bGSysAEvBHniTpnIMsPlmM0xyYUw5cam81/UX6AzdI4DbHa6W3LjAMG74AYLWHMkiCPTBISB3uSuYpW2dIA/rmQHl+1/QI43SSTfPdiObZ6RkYIozKcJcZF3G+n/CTK14/ey1Y9QSnijCC1YpPuzEqryFzkVUejE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e2f792c-e01f-432d-ca5f-08dc1ba967fc
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 00:22:38.9103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3iRoVwNldL9FShQlID5TuJMUDDeg/Awx0u+6USsWnXpjZYQzEnjOv5zTpFcbarIjYBMp0bfqTOrbO3QIJPELYKCj7lWjg05ILAPCX0EO06Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401230001
X-Proofpoint-GUID: h-o1kNBsL0CdfYcBmmvJTZaJoaAOwOIU
X-Proofpoint-ORIG-GUID: h-o1kNBsL0CdfYcBmmvJTZaJoaAOwOIU

This has ch_do_scsi have scsi-ml retry UAs instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ch.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 9d7fa097ae9e..1befcd5b2a0f 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -185,17 +185,29 @@ static int
 ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 	   void *buffer, unsigned int buflength, enum req_op op)
 {
-	int errno, retries = 0, timeout, result;
+	int errno = 0, timeout, result;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 
 	timeout = (cmd[0] == INITIALIZE_ELEMENT_STATUS)
 		? timeout_init : timeout_move;
 
- retry:
-	errno = 0;
 	result = scsi_execute_cmd(ch->device, cmd, op, buffer, buflength,
 				  timeout * HZ, MAX_RETRIES, &exec_args);
 	if (result < 0)
@@ -204,13 +216,6 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 		if (debug)
 			scsi_print_sense_hdr(ch->device, ch->name, &sshdr);
 		errno = ch_find_errno(&sshdr);
-
-		switch(sshdr.sense_key) {
-		case UNIT_ATTENTION:
-			if (retries++ < 3)
-				goto retry;
-			break;
-		}
 	}
 	return errno;
 }
-- 
2.34.1

