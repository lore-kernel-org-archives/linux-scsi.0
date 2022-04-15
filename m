Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45602C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Apr 2022 12:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353747AbiDOMqJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Apr 2022 08:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353766AbiDOMqI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2022 08:46:08 -0400
Received: from smtp.digdes.com (smtp.digdes.com [85.114.5.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AC8C90C7
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2022 05:43:38 -0700 (PDT)
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by mail.digdes.com
 (172.16.96.60) with Microsoft SMTP Server (TLS) id 14.3.498.0; Fri, 15 Apr
 2022 15:42:31 +0300
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by
 DDSM-MAIL01.digdes.com (172.16.100.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.12; Fri, 15 Apr 2022 15:42:31 +0300
Received: from smtp.digdes.com (172.16.96.24) by DDSM-MAIL01.digdes.com
 (172.16.100.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2375.12 via Frontend
 Transport; Fri, 15 Apr 2022 15:42:31 +0300
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (104.47.17.173)
 by relay.digdes.com (172.16.96.24) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Fri, 15 Apr 2022 15:42:31 +0300
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTHDSfJXEd+ZF6NrQODP61Je0dnjay2ZpwvJNkErUwMR2QUaqvYlRW7ZIVUH/1GrONhO/td7ymOpkt1MGW3tdg/WUuFfk+mJ1m94ApVmHg7FtHNpoTP1nNsnLitxL8JZ0wTUA7o5csN/DWJa+t03nvK6M0PQ0j2ylfKiFHl1q/UVfKJ14akFc/lnEjLll2IKDvAUfEwOjOY2+NtKphKlvnoe/CHtB0pFC8k3Ish5f0gNxez6rBVcXtuDXhVudewF1syD7F6/UCbG4EXyehP921oMCcl3SIOZuJ5uFUoe2A46qi9JmafzKhKQLlSGn0l8to9wLb6nmcfCJdqDDpb3BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jwnsXjghJMriGNJ40ms1bvXOK0icnKT0if3Ux0OEVwM=;
 b=jTL5uEFStLeSFwjRRj0CcQytGsbyzt4kmyIQemCoiSOdgB8K6kdXxMMHwq7+cOYy9C8TgG/1lkPhgaUEecngeBCbufuC/NrjCm/0WflaxXd00bBWZ86pnPnA5JGiYbJQAu6vVHy178Ya9Wnq20I197erSYXGLZ3bB5m8nZLMGCQZw0VqJK7ng1HYmbs61FIKxzJCqXoc+q3dwR0uZU2cWiWqzLM4k+FkslbdDLdni3OZjCYMCVqLVcoXcmAwfT7DPsZ27w4t9tqzRIcaHYaZghSYk/j8ZB4027U0kYAOoGj4/xZDG7bpsCfJ1SbyGbQ8H7XVrT5e2tyKex8PYz8DEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raidix.com; dmarc=pass action=none header.from=raidix.com;
 dkim=pass header.d=raidix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=digdes.onmicrosoft.com; s=selector2-digdes-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwnsXjghJMriGNJ40ms1bvXOK0icnKT0if3Ux0OEVwM=;
 b=l3hzL5XbohdO3Fy8S123QQTj/1DhuvY6tDeyY0J2picNf0lBESxRWtO1CQ84xRNOZthzBrCSDBjhG4fOF10q5/KsK0qHyi76vpBiwg1fW/2dUsrvdg0JdR9GQDsVWxaGjnEaol/a185nIKDjy+df9KDlgBXi5DTLWvdG9MCES2s=
Received: from AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:403::6)
 by AS8PR10MB4519.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:2e2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 15 Apr
 2022 12:42:29 +0000
Received: from AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::74ca:aa66:a112:d987]) by AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::74ca:aa66:a112:d987%3]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 12:42:29 +0000
From:   Chesnokov Gleb <Chesnokov.G@raidix.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [PATCH 2/2] qla2xxx: Fix missed DMA unmap for aborted cmds
Thread-Topic: [PATCH 2/2] qla2xxx: Fix missed DMA unmap for aborted cmds
Thread-Index: AQHYUMYtkLBbKidY90SJACyXGZHZ2A==
Date:   Fri, 15 Apr 2022 12:42:29 +0000
Message-ID: <AS8PR10MB4952D545F84B6B1DFD39EC1E9DEE9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: c0caa8e8-5278-c7bb-7451-4ffacdaec45d
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raidix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 449a68fe-b835-4be5-31b4-08da1edd6780
x-ms-traffictypediagnostic: AS8PR10MB4519:EE_
x-microsoft-antispam-prvs: <AS8PR10MB4519444E429D86332F9475049DEE9@AS8PR10MB4519.EURPRD10.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gmCIbQoGnEiQrAaNcJSdSYjDjGnHXZjbIH5KNtaLNN1On1DtIOrbtqE/ngZKdHBep/FT/bNXU+Y7qnz8fTFbJ96ITqt3TXp0UcxdkjkEyvfn0Trh62Oh373qKJi/BVBa/ZAmha5HNgjHR3ql1bdVoPEVZT3f2vP/DKJixu3ZQyto4sUMwxBNpPvdhllCBhR66ChzzMotMqGxZFTD7a4paKiZE7tqR+ouv1mfZjBa+BUxgiqbR85AnaULaDNhWKHFIDZTNLhJ5mi0sJAsOSdbF3Tpe221AcXU6kI8IbPKYX75DKFvjn0WuNSAp7V+cab8CfXkAlEcSvCQLCT0Tv1lRu0wPoAkvz9a2uRBl1yMDAWdnB6/gRoGip9E0qczsw9T/9PJ3NnIQgpInycNiIiaeXTWsf1k0qXR5bR9Lppl4kuJNFB+jSioGpTkd3dUZHU008NbGqGTMpb5SoGg2T3uqVw+Peoc5d3sARAPcC9F4k6le2rDTdE2q1RS7DmJTwS0MddwCK/9xmEBAI8KHoNVJIvQc31hAySQj4X87Kncm4oOBN48VSFBvFdYsrvLvMHFaV9KoxTsX2lLCox72m8cbHHjhlpvOJ1e8HVU7oK1HurMriSg2C4t7/m0Y3WVcF/zR/7372J12J2gkBH3vfWboQS6lRtdkR5QyDl6tPgHgCQBP/4NbADYWpfVeuFtsG1FY2My2cRKFF879+a+B/ox+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(64756008)(66946007)(76116006)(9686003)(2906002)(38070700005)(122000001)(71200400001)(33656002)(55016003)(8936002)(316002)(186003)(5660300002)(52536014)(7696005)(66446008)(26005)(66476007)(8676002)(66556008)(83380400001)(6506007)(91956017)(6916009)(38100700002)(508600001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?NInTtHrOM1JZIM1jce6zFcVah10jNeoYmcOyhWzXA2jQEdU8qe+FxdLmrE?=
 =?iso-8859-1?Q?ddj+vvqTWHll6ExMaZRKX6qhWTGWpH0BTp2buHzAUMdRp8ZAnddW90O6mQ?=
 =?iso-8859-1?Q?yoYL0GvvoGCwJVH37BD+Ti8z8X8FqLE58AwlBCx/8MMx+CahzLEJ1z/id4?=
 =?iso-8859-1?Q?uvZrlc512QB+wFQhWqbd6Cu+OVUcAP49g7NLXFGr5t+8OBzNIAGixNOlQI?=
 =?iso-8859-1?Q?GgfBMUccZhme5sVac4YupGIu4zlXMaFcjThR+9r+BlSYq9Dcm1ULlUOCSZ?=
 =?iso-8859-1?Q?1Wbl57y/RHMzVGTtA/+6KROxI5kKWiNdasNBfLmAhS+Zou9uqa9zcvAcyU?=
 =?iso-8859-1?Q?J+cRwcWER7zHNjZh/PVyRpEgkV7XWFHuLY6P3B7srjRx5IFRdjAwArulyY?=
 =?iso-8859-1?Q?cB7IBOqj3p0Q3DcooeaNSmJeHTnhQPy3uoQhTOk/udE20GwVnDyIMtggUV?=
 =?iso-8859-1?Q?yVOwlRhkLaicEhgS13mPavyrUbqdSF0rNFGEzJy3L2H3qIw4BqQvs4fJZw?=
 =?iso-8859-1?Q?qEPDaEbA4GebUf7jkXEjfrZ7WoEacyAgHrEWRkC78fy42RITnrJzuiM2sH?=
 =?iso-8859-1?Q?Z9aUet6Sy0OPzk1yvOXLihVI+QZcsbLhyf2LJokxKOK4z7ZUU90RAWDc07?=
 =?iso-8859-1?Q?2I614iUAtbzwX/asXCKc29QnayAFKQr3X61BcfgcLClwOYtlbSEF/Ai12T?=
 =?iso-8859-1?Q?oca3FUPm68/b8plLR3fLKQDliV+UREE2nPgzDHvA1RB6XYyNfrR/TfYwdY?=
 =?iso-8859-1?Q?leZ0NAShFkTUQyniAQ3EuvHYmX8e7DQwXGJoTFQ1P6kNIMz6/WhM3u44cJ?=
 =?iso-8859-1?Q?4YHwjrnklF5z9X51W9qHROZCNG92+x9KLBfApd6fgGL1t1oZxwFinqM7bZ?=
 =?iso-8859-1?Q?gte1E1YucV7tI4z+wR/xupMVkVh8QgsJaBPL79zDl6k/fHefey15iyGlLh?=
 =?iso-8859-1?Q?FFaKQaCUTyA0r0Gtm6hoHj6f5jSpcUc3ICrqS89QOpE++yzhsmsBRpePYh?=
 =?iso-8859-1?Q?HpTdVkNI/S0fDqjZECtceb3Jb7kMeOKGz3swjWlbHQhedLEjTxkpnmWF00?=
 =?iso-8859-1?Q?4Yaoz7jHXNX6q6aLegtTJQdHpoBWZneUgf+rc+ASj+sPzjoo0bu3OFjogS?=
 =?iso-8859-1?Q?H5cdm1FPQFW6d1GFk7KKVBksPyBjnrr39RoKGkfnowz1DRdgPy6w8f0ZV+?=
 =?iso-8859-1?Q?TAT/QJTLJEW/4h4ePzyI59+RZopzW4RY7Ygn2ojgIlmdVO6EE9CxWR85JR?=
 =?iso-8859-1?Q?SfJC5U/Fb8wOviaIwbLZiwB0Xu56OsOsL2lUbnnXz9O6GSmz+BgNd2zbSb?=
 =?iso-8859-1?Q?KAATb+CK1caCf/ZsIB3baq3zQIYISvSo5XYzIyL3edojAkfiebdO2fPEOT?=
 =?iso-8859-1?Q?u7VocIIRd0sdKGIgFZaPap2qpVPb6Yi6RuTJ3B2OTzgxvBUwMKm7CuryWw?=
 =?iso-8859-1?Q?HtlLkL1SsbOW78P+puE+K9bruQZRPHsth+YCRfEa+28dHk2w/pGcjeEJUP?=
 =?iso-8859-1?Q?jSbk1ZKNA/MKT/nyW1djW4th0V5TsluEHIxmWiJIcknqJUsx44QRP4sW2+?=
 =?iso-8859-1?Q?FgH1abdMN1XgyIoOdHM8wJNzQEaP7yk8id+LMhLN0J+HFw0DtyySNuVtYM?=
 =?iso-8859-1?Q?yZFWXsGSjXRSnEDsZGt2aMWFYWl4ki6mkn9ZBla5cV7v8D2bCK/4LK897y?=
 =?iso-8859-1?Q?+kBBwmT3wKAMgRRjBvfBG+UM6hRyE2cEw7gxAbsyScpJ/OG+P2Nqm/ggHJ?=
 =?iso-8859-1?Q?udfkJkOvCv2AA7qqHAaBTw5W4o1pi+F+MkdTlo9AzUdCipjpDxMqZ4Dlaw?=
 =?iso-8859-1?Q?7mSXD3S4ZQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 449a68fe-b835-4be5-31b4-08da1edd6780
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 12:42:29.8781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70c55e28-9cd7-4753-937e-c751128a9d38
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wbCXgTD2R5nuy4TZiooK8cdskzl6ySnsPX/+nSYltSn6+6TeIMyhpvetyxMfa6XmhpBoMMdl+5ixNP/HTeZWsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR10MB4519
X-OriginatorOrg: raidix.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Aborting commands that have already been sent to the firmware can=0A=
cause BUG in qlt_free_cmd(): BUG_ON(cmd->sg_mapped)=0A=
=0A=
For instance:=0A=
- command passes rdx_to_xfer state, maps sgl, sends to the=0A=
  fimware=0A=
- reset occurs, qla2xxx performs ISP error recovery,=0A=
  aborts the command=0A=
- target stack calls qlt_abort_cmd() and then qlt_free_cmd()=0A=
- BUG_ON(cmd->sg_mapped) in qlt_free_cmd() occurs because sgl was not=0A=
  unmapped=0A=
=0A=
Thus, unmap sgl in qlt_abort_cmd() for commands with the aborted flag=0A=
set.=0A=
=0A=
Signed-off-by: Gleb Chesnokov <Chesnokov.G@raidix.com>=0A=
---=0A=
 drivers/scsi/qla2xxx/qla_target.c | 3 +++=0A=
 1 file changed, 3 insertions(+)=0A=
=0A=
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_t=
arget.c=0A=
index 2d30578aebcf..a02235a6a8e9 100644=0A=
--- a/drivers/scsi/qla2xxx/qla_target.c=0A=
+++ b/drivers/scsi/qla2xxx/qla_target.c=0A=
@@ -3826,6 +3826,9 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)=0A=
 =0A=
 	spin_lock_irqsave(&cmd->cmd_lock, flags);=0A=
 	if (cmd->aborted) {=0A=
+		if (cmd->sg_mapped)=0A=
+			qlt_unmap_sg(vha, cmd);=0A=
+=0A=
 		spin_unlock_irqrestore(&cmd->cmd_lock, flags);=0A=
 		/*=0A=
 		 * It's normal to see 2 calls in this path:=0A=
-- =0A=
2.35.1=0A=
