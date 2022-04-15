Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BABBC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Apr 2022 12:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353755AbiDOMqK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Apr 2022 08:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353762AbiDOMqH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2022 08:46:07 -0400
X-Greylist: delayed 67 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 Apr 2022 05:43:36 PDT
Received: from smtp.digdes.com (smtp.digdes.com [85.114.5.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE27CC7496
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2022 05:43:36 -0700 (PDT)
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by relay.digdes.com
 (172.16.96.24) with Microsoft SMTP Server (TLS) id 14.3.498.0; Fri, 15 Apr
 2022 15:42:26 +0300
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by
 DDSM-MAIL01.digdes.com (172.16.100.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.12; Fri, 15 Apr 2022 15:42:26 +0300
Received: from smtp.digdes.com (172.16.96.56) by DDSM-MAIL01.digdes.com
 (172.16.100.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2375.12 via Frontend
 Transport; Fri, 15 Apr 2022 15:42:26 +0300
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (104.47.17.174)
 by relay2.digdes.com (172.16.96.56) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Fri, 15 Apr 2022 15:42:26 +0300
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJhLoPWIQhiwDVIyrZjBs6/pyPB1sDmJkcsMbdmKyQwlmU3OktO18VqhOtSyKL3MeK3w0xfB8tj6YkLn8cgcwF8/TaO/KF/1ycZ1orEb1Mqn4ZGiFl3sCTNumXm1KYV75G3tMCpnDGdXthpmld43Lj90TU+Hf2URIZpOkV63AjxsOgX1c2/cb00JNnc1jKUglTtUYscp1gCsBJXgLvWnnRgWEeKFq16t9JpHpERp2ochYoqPpgR9RY9OJGhDXiOjpXKuzDJF/WGIT90LsaS0BW/hRtXPaGFrnUa0htMuMI9PmTH0zAtsH1fDdOTJofX6E9JHUmI8kugDwIdVDMkVpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NBwVL/WQw9H7kOeiROa5jfGWN+5d/fkEQyChIU+mQ/o=;
 b=aPFFw1D2LNDs34C331Djia49PyMgApSx0okW6x1NFGTkii86X+wxeHz8QlazjeqEWJX3wuUMQukUq8BPH7DxBQ+3EeFsXukLOcn1Nqxtp+3vMinSRAGhROerAUY7Ws8jugWfwxP3hgLMt8f/7pLxCga88+ATS9D2738FbR1Oq1+E2o18KsWgDV+m4KB3lIKm7GoPoFLcs6W8M6ABulh7d/XTUueKEp4+O80oHgRARHOkedDn6CxWwCpMqOahnYt/pN9rqtqiaFhM74GNbKNLAaynL1dfPp6RBYeOPEDL1HDlYzb5PPpG7Rj76sOhYjWYQEWsnpv+LmbAArm9NkJLDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raidix.com; dmarc=pass action=none header.from=raidix.com;
 dkim=pass header.d=raidix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=digdes.onmicrosoft.com; s=selector2-digdes-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBwVL/WQw9H7kOeiROa5jfGWN+5d/fkEQyChIU+mQ/o=;
 b=Cpm8szQ0O0LH/nHxrRhO6fMAx+TYFGKTrksEK28aVrDexUecFru39Orn8k4JyHM7xNi4w/tsdCBd5OQrv16N1hLIlRDkW3Z1aFIjrFzBTk7JaOwOfD8YjDA8DWRsGaw5TBuZP3ASIuhVql92xufjgHAElQDc4iUdnTUbrStn1tA=
Received: from AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:403::6)
 by AS8PR10MB4519.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:2e2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 15 Apr
 2022 12:42:25 +0000
Received: from AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::74ca:aa66:a112:d987]) by AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::74ca:aa66:a112:d987%3]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 12:42:25 +0000
From:   Chesnokov Gleb <Chesnokov.G@raidix.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/2] qla2xxx: Remove free_sg command flag
Thread-Topic: [PATCH 1/2] qla2xxx: Remove free_sg command flag
Thread-Index: AQHYUMYWYkt1LwLtU0eGmzdW21PURA==
Date:   Fri, 15 Apr 2022 12:42:24 +0000
Message-ID: <AS8PR10MB4952747D20B76DC8FE793CCA9DEE9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 8ad1690c-d667-7a20-e5e8-149fb4163c2c
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raidix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85e54aa4-5398-425a-e153-08da1edd6497
x-ms-traffictypediagnostic: AS8PR10MB4519:EE_
x-microsoft-antispam-prvs: <AS8PR10MB451900CF8C10EDD592E1BDDC9DEE9@AS8PR10MB4519.EURPRD10.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K5tkARijj1a416AU0Km1mUAjsb0lDqmqnfrK2FduzZc0Epxzgu1g0IPQhucF0Y5O5aek3Es4nWImNjdbYw/Cv8aRx7OqSUhDe+Kb9m3Bd+kzB/4wn1rDDAeHyg18wdKoKniREwS59kqypPsg5fqWQTo9u69e9WfD/UDE1No3NKLjGrnt1s3fcX6AUfQ9Gofb2fHqbRDFk8KlRjxd+id3aPALPh6RuNvE5iKZgGYZRor0Emdl3U/NdVGIhMM/lOz0JBHf94vVTvwJ8ONZxOrX7fcbNhRqC+0ayUQTd/zffGaiwdNjFgnp47BZD1bFJ8N7q1Q5/wyunxHR1N/xjMUA4kLHnFdd/C9e0FngYiJeuMxHQhSQ2YFZyjldLwwXosAfbvoDK5DHRWaXRhXcbb+KkdsZiAY9Hi1XEV/n8pujH/q3/g7LMpy4W3gz4lB53o7MKvhphQwS6k33zBST6QgwkkfOAh/tZWYAhFGXHx99+1kOKxWnImK7wYA3V9cwTaGGemak1vHWxqZBIquesnYfU7Bva6uh34BZYKs0C0KZahs1QMIYkmt3qhXBg9SUvclNQH7iXE+3Hs+4S1ix9/AEOZFhhzNq0lAUVGMklHTF/yI3Ka4FJqb1+jTCeoWvfdfG2P3fGPFF3vejPcDVO84VX/zeuy3RB+kdR+CD2rPSEAW5xuUqXLDxvMx6J9jHe8b6pgXPFu14926e6nnDQeraEw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(64756008)(66946007)(76116006)(9686003)(2906002)(38070700005)(122000001)(71200400001)(33656002)(55016003)(8936002)(316002)(186003)(5660300002)(52536014)(7696005)(66446008)(26005)(66476007)(8676002)(66556008)(83380400001)(6506007)(91956017)(6916009)(38100700002)(508600001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?/VEjBCUOSyrroHev21IAhXiWMQC1jVHOdpycKIWLt/sQZANHaTKMZOQTMr?=
 =?iso-8859-1?Q?v1KbQadYSAHx6pcGaLEOYHBrHMljPXeBvYI3vOSVA7FV1f5KfWoPGrzNgV?=
 =?iso-8859-1?Q?KkcFt/kTwFLdXg6OOwNd53oHB4qe+tQWlXcRDZm36piWJSa65AaiQpTLg3?=
 =?iso-8859-1?Q?0Zfi17gndBd3FOy6FsYScB/UP821xgIoCiKCZQIYyz1FzrjPgC6FyUoVV9?=
 =?iso-8859-1?Q?Xbt7/rmZsH28NTnREDtBJDd6BPL+/VPqp2UIHYoFeCVthd+uAMZDjmw6Ol?=
 =?iso-8859-1?Q?bWnjNf7RQOj/Cq/6DuWeKzSzb0DATPNEktPjqfo8+o9t3YwCm6D4SEHTZj?=
 =?iso-8859-1?Q?mQj3N6KkBbWivLUU5U6e6Sh8b2q7dSwK/yMbxBYQ4IicEDtNoMCr+F41F3?=
 =?iso-8859-1?Q?W0v81lU+gvzAVgJIwrtA/SMB5PP5C6HJZQtOBHsYEPK3z1X5deZSa7ZaOs?=
 =?iso-8859-1?Q?nw6xevTFqWtbR7NQhClgpLP9kos8qK7bU4WaKx6oS7D6p7RuLZTCjWB5Ho?=
 =?iso-8859-1?Q?X2L2Ya38SehlyRW5IGACEAYaD5UuqXwT6TITvBizyfTlIhkpkrQLzzhZNG?=
 =?iso-8859-1?Q?oqAlTtARJ25A/7ViRVhJkBYzLPE3lDXcaA8wE25JBsaylW2LMuM5232AVp?=
 =?iso-8859-1?Q?Ssbvme7td7cXc8tMCTT3ewtwzxE5/Xexm25FVQYOjLKoqEFZgj7uveHhfW?=
 =?iso-8859-1?Q?mEWBKRaV5RPku5DazN7oe7R6xzJ3i3qbDFKzZ21RBXrgcCf9LpRA90AB/k?=
 =?iso-8859-1?Q?7Kwpv1HrTx4Ggl+xNY58yITTYmAg1kWUpltdtwaZLpuuTtIsQl/q4omT1a?=
 =?iso-8859-1?Q?I20QLbXUZFjmU6noBCYUroOMQTkxRejNmTnd+V3lJ0t0mfzxqjgeq2uSEl?=
 =?iso-8859-1?Q?yGfd3sv1GON6dVB7VdCqJrztayuMkRiNN8DE2SAI+OppMtAqyCmvvAifeS?=
 =?iso-8859-1?Q?v5gS6uzOayF5ezF2nMs5+ZEIUBJFjZc6PdxMP15ssbrEFA7neQECYW4rkS?=
 =?iso-8859-1?Q?+/PAMBTtu49Rp4f6IJ+8145ffNR6gn9wej+e0bcmBfB4+U3VE7F2VVOlFS?=
 =?iso-8859-1?Q?lb9vXK5BYRswkCyq01mBNKPDeFtg2/RMmKyyBFPkyyslPLbbCSVc+FWM9h?=
 =?iso-8859-1?Q?T10WUvmVSSulqouLNLJWlKKs+9T35t1AlpzTcU5La+uo9DlxuOKIckTqhA?=
 =?iso-8859-1?Q?z7OfNCI9u5MUBE47/E/whGIUJSogYvVS/WQ0kRtVjB8hjqDnhWftBDnj06?=
 =?iso-8859-1?Q?IFvqIWw8LCg2BmmUMGwGcU6m6nnWky32uCY8gcEHJWQmqf6MBFm4Na0gbw?=
 =?iso-8859-1?Q?CTlmZ9q+98T6XHB8SIJGS3m5k2JOXFm+8ABUSsOtJCxW7Ec8kGXPMq4FGd?=
 =?iso-8859-1?Q?3j/dSGcmQhuPEhbfEidG5AiaiRJHWQW0VvupEl+1KsetE46J4jQUfcRREt?=
 =?iso-8859-1?Q?Tog0lWm4OWJNJQDA7LnVLWWd02ROaBe3K7hUwas3YYpTm3yKzkbgjRR/wq?=
 =?iso-8859-1?Q?Qmey79OYCmn3Q98TxVa+9n/feLeMCl+yFBuvaLWmY6T88f/EMzdvtkkXSC?=
 =?iso-8859-1?Q?CYGZCMxu+NZNsZC3r+jj/pM5mdkXQl3ntgH5IkvDUOXkgqGX3yI54rudoR?=
 =?iso-8859-1?Q?e0eIt4hXhqHZSO/9IKV7APgRiuSFWr1ZwphhCmituJq/XWNmlYXwZvsOgI?=
 =?iso-8859-1?Q?38Fx8rYDsXEkNQgXXxVTlRZl+igelSX3aAMRoQQ5ETjid6OcdR2VKfstje?=
 =?iso-8859-1?Q?wSsxqSZ0Vpz0xbBhJBbNkWmpvcL9AIKVRDlEfFTGf3IsqzXi2Nn8JbWSgq?=
 =?iso-8859-1?Q?zMVh1Pptrg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 85e54aa4-5398-425a-e153-08da1edd6497
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 12:42:24.9065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70c55e28-9cd7-4753-937e-c751128a9d38
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mYVPy39gxBg5quE7Jqm0Dn1+rn+q/1vHqZXAOToWmDgDFu3/eZwtkQlyROClxhZVqzxtUAEomIHxhkl4WPQ4pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR10MB4519
X-OriginatorOrg: raidix.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The use of the free_sg command flag was dropped in 2c39b5ca2a8c=0A=
("qla2xxx: Remove SRR code"). Hence remove this flag and its check.=0A=
=0A=
Signed-off-by: Gleb Chesnokov <Chesnokov.G@raidix.com>=0A=
---=0A=
 drivers/scsi/qla2xxx/qla_target.c | 2 --=0A=
 drivers/scsi/qla2xxx/qla_target.h | 1 -=0A=
 2 files changed, 3 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_t=
arget.c=0A=
index 85dbf81f3204..2d30578aebcf 100644=0A=
--- a/drivers/scsi/qla2xxx/qla_target.c=0A=
+++ b/drivers/scsi/qla2xxx/qla_target.c=0A=
@@ -3863,8 +3863,6 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)=0A=
 =0A=
 	BUG_ON(cmd->sg_mapped);=0A=
 	cmd->jiffies_at_free =3D get_jiffies_64();=0A=
-	if (unlikely(cmd->free_sg))=0A=
-		kfree(cmd->sg);=0A=
 =0A=
 	if (!sess || !sess->se_sess) {=0A=
 		WARN_ON(1);=0A=
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_t=
arget.h=0A=
index 156b950ca7e7..de3942b8efc4 100644=0A=
--- a/drivers/scsi/qla2xxx/qla_target.h=0A=
+++ b/drivers/scsi/qla2xxx/qla_target.h=0A=
@@ -883,7 +883,6 @@ struct qla_tgt_cmd {=0A=
 	/* to save extra sess dereferences */=0A=
 	unsigned int conf_compl_supported:1;=0A=
 	unsigned int sg_mapped:1;=0A=
-	unsigned int free_sg:1;=0A=
 	unsigned int write_data_transferred:1;=0A=
 	unsigned int q_full:1;=0A=
 	unsigned int term_exchg:1;=0A=
-- =0A=
2.35.1=0A=
