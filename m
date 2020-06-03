Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333CDC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 10:33:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC4D920734
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 10:33:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mV4cer5F";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="m/Ztj6j7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgFCKdL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Jun 2020 06:33:11 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:65300 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgFCKdK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2020 06:33:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591180389; x=1622716389;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3JgqJHABiOz5aCT0LNv05qLsEuStUUV14W1mNyxeQAY=;
  b=mV4cer5FGMy9vrJ8YF6EqCJziABjLhYSPOu63sMfOH2JME5Kuk9BOOaZ
   HP9ShvNsMPZdwKvyA+n2XpB/tnPVebM+FMWcwj8wENn4+UUE5x9BXDfGN
   nnV84qpXdnQ+5ECf1F4xvMMXx8MyxZh+ZxjOjBkP70KLGVi6jTB2yGvru
   tJqY+dlil+JXW3ktKGj45T6WNy1g2062dzD8PhwXyO3rsNi9D/v39oHT1
   tozIeNoS8DemOapErEjtftuj/vcb9DQJqazdkv1PJw1jtW1fBWb0tdsJH
   cjBedsiQo6qZMeSe30R8tD54f8EtYCN+s4GdT8nM3pZEHYPI9n+LVfvKG
   g==;
IronPort-SDR: BBqJcqeSLCZQ/d9S0kfvA8a3XCKIwYo/0nWOc/jXqqgfJGPBPvcovJDPdyuzcxZ0yrqzkrs+hX
 QgjXI96+20nanp/+mrmVSEzoqtq+j5GWkbQ5aiKfkOJQxQZojDE2aFjSdyAy5bDnas/S5E8/87
 //NQLo600KFVx8FqhKY8awmiLoKbkTTqbsHqra7lK6poZ1tnPokRiXKkvaZ3/51WmPVmQfiEr7
 W9vzXlJ8bZEBx3vLKHhfqWaYW4jC3cXFNTLVIhz31MKR7c11Em8d8R6g7KUFrxXpi99i+eWVvb
 2oQ=
X-IronPort-AV: E=Sophos;i="5.73,467,1583164800"; 
   d="scan'208";a="248192977"
Received: from mail-bn8nam11lp2177.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.177])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jun 2020 18:33:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fciJU0x8BdOq7o/kQG8s+dlF59pdZY1VPyWmzKDk0A5GNx2CXw9O3a/JfUooC66D7qD9nJhneuphJuL6UDyh4Qex8AQSvTdV5Nj5gNYoGiPQ+S3lIMd0qCU4npGdQfbOBOtOOCGSBd1pqRicJQzpFsQIWzomOTruu6qybU8Mhb+gtsiMlLio+G+cxjQO04NQVWL7ALppTzqRnO631yzL17Wb5ERZ/xu5qWSN3lzo05nTb39+xqMh9Ppi1y38U8imchPA55imDW9RVM1mG3auRyYWKbkUopBw0QYuXIfPNTU97SUfbk4gih3m0hPT8VnDp2FFZAGsuQhlhJSH+XXUkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4txuZCKzCb1dE6hDVr7hduAanZnCPbg2kIMcrGiQBYw=;
 b=CvPIfzhiBv39ABCgwFKoA0EjTJhxZRAflS1rPuPHpd8xL49kB+9CgG3XD4F48swUYM77Lc2E++LYGnLs4e2Kp1Ix+Ip5UnUBCm88Htjbi5bjjRLLq/4omoaZIaOPaxB0If7BFNAk/SNYeGMf8iaB3yV2qlqZrVFsEapGWxF7NsJLADu+0AIvZsyojbUfUww9jBzeM/IwQpPXMi5NOyfKkIwI68e9gFthLYghAvvhNb+y1E/JLIiA9aHYuqR+6sF+4S/LDSfwcC5SwhH1W7LMBajWK0RNF/H13gD2Xf+2MVUyu7oupPv5yPKGDxHwoJEMOJsXYTNbDuvJ4TvFT1fGuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4txuZCKzCb1dE6hDVr7hduAanZnCPbg2kIMcrGiQBYw=;
 b=m/Ztj6j7R0FOhCnauu5cGWZC5r0ETVr+7lSJI80XcARIefTcSC9AqGWdxIgNWokbKNKi8rncsFHzZSs9ju5ohOA5WdQTga8DoimqnG70drAhyTEL41FFHYAav5xSKRRH3oDbn5/1m7lIuMgu2U6yUbrk3sD4VSqAUV9Vj4zC/K4=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4160.namprd04.prod.outlook.com (2603:10b6:805:35::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Wed, 3 Jun
 2020 10:33:07 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3045.024; Wed, 3 Jun 2020
 10:33:07 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "beanhuo@outlook.com" <beanhuo@outlook.com>
Subject: RE: [RESENT PATCH v5 0/5] scsi: ufs: cleanup ufs initialization
Thread-Topic: [RESENT PATCH v5 0/5] scsi: ufs: cleanup ufs initialization
Thread-Index: AQHWOYgzVXSXGkWzo0uf2LkGVl3MGKjGsYEw
Date:   Wed, 3 Jun 2020 10:33:06 +0000
Message-ID: <SN6PR04MB4640D2F7B62C15D00682C1D4FC880@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200603091959.27618-1-huobean@gmail.com>
In-Reply-To: <20200603091959.27618-1-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c91e6dd1-a6d7-428a-2b3b-08d807a98135
x-ms-traffictypediagnostic: SN6PR04MB4160:
x-microsoft-antispam-prvs: <SN6PR04MB4160DE0765D775D3250D3B35FC880@SN6PR04MB4160.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:949;
x-forefront-prvs: 04238CD941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TV0CJ8LPRSn+oL8uR4s8YtEZ4vMYAz/K9kEUO1iJCh3gOhQ1dIKMs9J7iVyn7SLw5928qbdMLLQ4RByFBxnQKSF8lH3tHF77VgMJ4LkRlel6pqQD65FBUiSurlkN57r2IeRdCQJmCwJMMB7GZdytHXqLpsu0AwN9xqslY9t3l5pYZwoOAWDu34LJUEghuW+fYg/9yIOPYSXIj4sNiNoqXxL9orl1TTdgYmVVJIyoFr4csha7E7dtk9s2rOL7DR5Xly8P1JAhftO/W8vvRPRE27Gn/eJLcvW4VUySTg+b5sCB10m5l2uImN8wX63Vn4mFqbF40pgqubz3ZAQBXrBa8VOg/sNXTUrIun3FXlKj9v0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(55016002)(33656002)(7696005)(54906003)(110136005)(86362001)(66946007)(9686003)(66556008)(66476007)(8936002)(478600001)(2906002)(66446008)(52536014)(64756008)(186003)(5660300002)(71200400001)(316002)(6506007)(8676002)(26005)(7416002)(83380400001)(4326008)(76116006)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: LnVQ7bARMKy5wRU8AeEpeF6Mh5qhF6vCnmvgVhXpr0T/Yauz2Vj4/kIRwxc+H6J+7iSsUAvH4q93GmmduyBfxJvc1LhMT0iEFvGeG7KXNko4p2VefurDSVr/Qrf39LjI0ikU0BlGDUECURgD1w7WrOgNz3a4ZC4SfvgLwQ5JVlO2w7EzxVJ2Ql5XjyBBxbNRtMyqLSNDArC4Bm5RvObTADqtIAxlpU2GcZGJR2lBRF6vDo4UFm5doiCWfS8xG+GKY74vZ8dMMIMI37aDlP8iYTqqJ1M7+AW9tNrqogB+bclkP3ziLjb2bxGKS37Ji5MMiUBH+973deDCx3MbK7JTGGK/PO0kQ/jjEFZcg3KZZkH4RIU/odS7T+0Qyl89nKF+jJoG+zHPLapTOeUMqVfLAuqVNKVLceWsiKU0gDa40ImKnC9t0O0kv9dcbvdcPbE98wRh18z7ZJaou8vABC6NDOMxT2fwf9s3mFX3mgadJt0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c91e6dd1-a6d7-428a-2b3b-08d807a98135
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2020 10:33:07.0098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cG75g4/bcG24L71Gykb+rJdS3WRPzfaRgKnrwXBWspLCsz8/QTiJq3q4NBp5NXt680iIwjw3hJ6FL6TG3993sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4160
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks fine to me.
Thanks,
Avri

=20
>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> Resent this patchset since linux-scsi@vger.kernel.org and
> linux-kernel@vger.kernel.org rejected my email
>=20
>=20
> Cleanup UFS descriptor length initialization, and delete some unnecessary
> code.
>=20
> Changelog:
> v4 - v5:
>     1. Rebased patch
>     2. In the patch 3/5, change "param_size > buff_len" to
>        "(param_offset + param_size) > buff_len"
>=20
> v3 - v4:
>     1. add desc_id >=3D QUERY_DESC_IDN_MAX check in patch 4/5 (Avri Altma=
n)
>     2. update buff_len to hold the true descriptor size in 4/5 (Avri Altm=
an)
>     3. add new patch 3/5
>=20
> v2 - v3:
>     1. Fix typo in the commit message (Avri Altman & Bart van Assche)
>     2. Delete ufshcd_init_desc_sizes() in patch 3/4 (Stanley Chu)
>     3. Remove max_t() and buff_len in patch 1/4 (Bart van Assche)
>     4. Add patch 4/4 to compatable with 3.1 UFS unit descriptor length
>=20
> v1 - v2:
>     1. split patch
>     2. fix one compiling WARNING (Reported-by: kbuild test robot
> <lkp@intel.com>)
>=20
> Bart van Assche (1):
>   scsi: ufs: remove max_t in ufs_get_device_desc
>=20
> Bean Huo (4):
>   scsi: ufs: delete ufshcd_read_desc()
>   scsi: ufs: fix potential access NULL pointer while memcpy
>   scsi: ufs: cleanup ufs initialization path
>   scsi: ufs: add compatibility with 3.1 UFS unit descriptor length
>=20
>  drivers/scsi/ufs/ufs.h     |  11 +-
>  drivers/scsi/ufs/ufs_bsg.c |   5 +-
>  drivers/scsi/ufs/ufshcd.c  | 207 +++++++++----------------------------
>  drivers/scsi/ufs/ufshcd.h  |  16 +--
>  4 files changed, 54 insertions(+), 185 deletions(-)
>=20
> --
> 2.17.1

