Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F1B4C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 00:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59B9921E6F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 00:22:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="b4/YzjkH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfKLAWL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 19:22:11 -0500
Received: from mail-eopbgr750057.outbound.protection.outlook.com ([40.107.75.57]:38411
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726845AbfKLAWK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Nov 2019 19:22:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1q3egKKozU9x7pvdnHJ6fIcR+PybCYgiNxUB1nlY/R5EaOWfRmyo4LlDhKMD5pJg2WvshW0dYEb7OC6socQT/h8XXPleUlHg4EP78dRaJLSh6vepq8qWqcFimgsJIBaD9FlHbGCgnuxCr9GOvNYtjjUeqoigCQwctGrdueC+JgJuW6eEI5fjVZpiqFeNOXucbZuEMYStt4dX56BGeb0w2pV6/RsVi9wip9Ds6yUhsAL4rYax+yedetGFrgb/ff5LA4RHqKgVacO+HEZMd46Mo62HIa7LLePP0lWo/cZ3wPVYDR6nAc7kw+1f8FvYTePXBkiDKwDTwejIOPXKrjUTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBiKyGYyS3EHRso7ARZJfx5BUgZBQFi1x18mfUXBqDo=;
 b=dPsMfMy4F50Uv4VM4PdTdALv9vrsRHOWlqL35DitMTL5STovVGVa1bS5Ef4fOkHZgAVkrd4Sm2Ng/X2BodqwyQ8y8tG+y/rHeJIsJhv0Uld0L0S3Ou6F4rcFvcYibeIkRokmhpyQdjpw1dq8MAXV4p2bHcrC5aDGFmW7hz6DL4zie2Zs29am7fB56BMeUNuUJiK+AnqLFczTS7gh4+RHAt8Bopb3x+ZzyxVyF1jSpNDGC1169gQn+a3yU+1mhSAd45SWg+pR8u+WV5keSHbCb/mGeJOTHrJ5aYi50E4arZa5ICZlsUO8Gw/7rfGskC2gFL5Z1obuZVXfy8nTO8jSHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBiKyGYyS3EHRso7ARZJfx5BUgZBQFi1x18mfUXBqDo=;
 b=b4/YzjkHOnwZZbpYrdVEBGbYVFviNyaXq0xdBdiq1ow84Y+vNwa0cPb1d2pBfPvgYTlQXjtiHK7bTetpCTIva6ztaNtFL5kOeiLzLwcuhvOq3xI1xAThqObFzh6El5BkjglMEmImryPjJgORXO5jk7yRj7+MiRG+utUrji206jk=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5524.namprd08.prod.outlook.com (20.176.29.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Tue, 12 Nov 2019 00:22:07 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 00:22:07 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RESEND PATCH v1 2/2] scsi: ufs: fix potential bug which ends in
 system hang-up
Thread-Topic: [RESEND PATCH v1 2/2] scsi: ufs: fix potential bug which ends in
 system hang-up
Thread-Index: AdWY7zJAma1zW/nRRquYw3rlm915iQ==
Date:   Tue, 12 Nov 2019 00:22:07 +0000
Message-ID: <BN7PR08MB5684BD2FEE5153F7AF96F146DB770@BN7PR08MB5684.namprd08.prod.outlook.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTZlMzVlZGZiLTA0ZTItMTFlYS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw2ZTM1ZWRmYy0wNGUyLTExZWEtOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjI0MzEiIHQ9IjEzMjE3OTkxNzIzNDk4MzEzNSIgaD0iL2RNVlI4bDhjYWJaWjE2aXY2SnVYaDNhdGpnPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.96]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cac8e4e6-d16e-4d72-ba9d-08d767065a12
x-ms-traffictypediagnostic: BN7PR08MB5524:|BN7PR08MB5524:|BN7PR08MB5524:|BN7PR08MB5524:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR08MB55244A40543BDAFF6227F43BDB770@BN7PR08MB5524.namprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(199004)(189003)(71190400001)(71200400001)(26005)(186003)(66066001)(6116002)(3846002)(2906002)(66476007)(476003)(9686003)(102836004)(52536014)(74316002)(7696005)(55236004)(486006)(6506007)(7416002)(33656002)(2201001)(4326008)(99286004)(55016002)(14454004)(478600001)(2501003)(86362001)(76116006)(66946007)(305945005)(8936002)(316002)(66446008)(8676002)(7736002)(6436002)(110136005)(54906003)(5660300002)(64756008)(66556008)(14444005)(256004)(81166006)(81156014)(25786009)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5524;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LIOSYMAR9Ve+Uxv0MDqtx3svujWlCht3Ta/4NMBAysIdauoThyzTUhLJAhRzfp++BugigZISgd36hzYJt+qBDcr1G6Y9b2GU5BjkoNE+OUX5QUhBsTm6ghYCFhUvOwh3DIhOXma02UJTJv5jGn98jcVYbD6TJFI/JngDvVAiYP6ygowoBGWB3t8vnb1xmKS4TYBFEFAk0lPYkyz8R21dLfYWitd6agN7/PGa1Q/RfQffjnZZ+mvuuPT5tY5fEsUWeL9AJgy3ur31EHHGJh4loOogPhjWX/5cwJK1nimoOgq268yLqpDNrAEWc3mlxyLvvorDrld9fcfobCQ1TSBK57Wc6ELYdxUaub5Vvtp6pkZAneL7B8qZBK230ZWwPA86Atg7b4uEzDacMKSXDkud6gEJXmeVo/dRQDTamkr3wXr1hl/3SFgXyW63r6cZzmEu
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cac8e4e6-d16e-4d72-ba9d-08d767065a12
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 00:22:07.3728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eE3vYXCYb9TelJi4VgJrk8nkTX+kTMy3NbMG5kTREPRHKb3ZPKDVITcMwwgMzturkPJbm7PTW0+SZsxHtPEq1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5524
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bean Huo <beanhuo@micron.com>

In function __ufshcd_query_descriptor(), in the event of an error
happening, we directly goto out_unlock, and forget to invaliate
hba->dev_cmd.query.descriptor pointer. Thus results in this pointer
still validity in ufshcd_copy_query_response() for other query requests
which go through ufshcd_exec_raw_upiu_cmd(). This will cuases __memcpy()
crash and system hangs up, log shows as below:

Unable to handle kernel paging request at virtual address
ffff000012233c40
Mem abort info:
   ESR =3D 0x96000047
   Exception class =3D DABT (current EL), IL =3D 32 bits
   SET =3D 0, FnV =3D 0
   EA =3D 0, S1PTW =3D 0
Data abort info:
   ISV =3D 0, ISS =3D 0x00000047
   CM =3D 0, WnR =3D 1
swapper pgtable: 4k pages, 48-bit VAs, pgdp =3D 0000000028cc735c
[ffff000012233c40] pgd=3D00000000bffff003, pud=3D00000000bfffe003,
pmd=3D00000000ba8b8003, pte=3D0000000000000000
 Internal error: Oops: 96000047 [#2] PREEMPT SMP
 ...
 Call trace:
  __memcpy+0x74/0x180
  ufshcd_issue_devman_upiu_cmd+0x250/0x3c0
  ufshcd_exec_raw_upiu_cmd+0xfc/0x1a8
  ufs_bsg_request+0x178/0x3b0
  bsg_queue_rq+0xc0/0x118
  blk_mq_dispatch_rq_list+0xb0/0x538
  blk_mq_sched_dispatch_requests+0x18c/0x1d8
  __blk_mq_run_hw_queue+0xb4/0x118
  blk_mq_run_work_fn+0x28/0x38
  process_one_work+0x1ec/0x470
  worker_thread+0x48/0x458
  kthread+0x130/0x138
  ret_from_fork+0x10/0x1c
 Code: 540000ab a8c12027 a88120c7 a8c12027 (a88120c7)
 ---[ end trace 793e1eb5dff69f2d ]---
 note: kworker/0:2H[2054] exited with preempt_count 1

This patch is to move "descriptor =3D NULL" down to below=20
the labe "out_unlock".

Fixes: d44a5f98bb49b2(ufs: query descriptor API)
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 55d66059f608..2b82b4eab3e7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3003,10 +3003,10 @@ static int __ufshcd_query_descriptor(struct ufs_hba=
 *hba,
 		goto out_unlock;
 	}
=20
-	hba->dev_cmd.query.descriptor =3D NULL;
 	*buf_len =3D be16_to_cpu(response->upiu_res.length);
=20
 out_unlock:
+	hba->dev_cmd.query.descriptor =3D NULL;
 	mutex_unlock(&hba->dev_cmd.lock);
 out:
 	ufshcd_release(hba);
--=20
2.7.4
