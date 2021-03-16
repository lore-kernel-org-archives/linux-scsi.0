Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7CCDC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 16:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6133665101
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 16:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237704AbhCPQaH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 12:30:07 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:56402 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238716AbhCPQaF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 12:30:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615912205; x=1647448205;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EV1GsPche4ShBWGnAvR+lKlw9JRAzvqU9GRlcunKq1Y=;
  b=SpIzqe4jUyKrSgxmRryBAaRatNfzJ4+shpnu8VSlZic0mZirR790QnJ/
   jd4W98uRudLdf5TuxiX4fx4EH+EiPS/tlw/ye1Sa4UhyFHbJW4yipWLQi
   ZNBQ7DuLfYhEbvetUHUDq9OYUH5m9bBm0/bi1Z7yOzFuUIuul7h2wsA/3
   ESj4Y879XRGHpZCn8Vcwl4EZKAG38frdni7m9mkgJtVylUt7XdWr2MuaD
   Iaqw1o31viX+/VpAt2oH4eXgRGJJ4OTeYqn4QAISG3RcOCul65IOy9Ggi
   yIyL0cSsIAqveABiDj9LrHlONCdI2n3dapDOkomSCtbuxho/FWvAo9ycq
   g==;
IronPort-SDR: LEuxF0n67h5ZIIffNwoN62Qh4lH7RVg22EV7oRCY2S+MixvbyzNGz2+gIBOt/bFAFwu4ArMvVi
 auketdcUXObBM58MSdWQs/RhqcbK/QrApK1DWl/ljuImaMFw6/z8qkI7COEwy36xF16C47DLAQ
 +LVhCtlmufn9GhTLetpZpYMbZMBaN2TruX36HlDLW5PRpxKtQ3ZWnGQPl+6gwnR11JEXzOqr24
 DG6VnRPZMTx+e+Y72yRu+TD0suCHzJMcHTcOKdLc2td4L5MLcNOdDfSVPsyGp6fbFmNqFXW1Re
 RqI=
X-IronPort-AV: E=Sophos;i="5.81,254,1610434800"; 
   d="scan'208";a="113434774"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2021 09:30:04 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 16 Mar 2021 09:30:04 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Tue, 16 Mar 2021 09:30:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VS4g9eIBQyQxT9GBiXWkcPHpeD3xEHTsMsdeEZZ9REC4yBgizcgTVRBbp2YaCaRsTYivqxoIIRrY2NRfj5z3YlzoABFEjmYvfiR8YOlpHTe7dqNFa+qZMqbzjkVdjxvDh4l1ySiPqb1+51aNGoL1eKRsQcc3m3b3vYifqOXigl8L94SaSvD0Izx7R93G+upMaHCns3LKvqjnopGs9+C6OVMG7gEZrlMBEkcQuJe67SSuDEH+KtMMRqKLF5v/zJhJuEJZtTgoGzPUZyBgmK5ZMvwgeBP6Vy1KzOrOGvy35CxkMKD0L5dYiQi54dA2RriEYASbfNXOs+M8CWZp4Lrtyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5oya9Mxn5lrIkzZi/5DUT8Y5MdmZjTFsigjS+b5kvFQ=;
 b=mNDX7sRgU6l0Y6q2BIGO5uzy+Ij4Al2hZATxhAy0jZnqTiU+QP1CKfSn+i1QwOq23ipqXZh9EqhK8Myd+7w5+pK8E21MT5jvvnGIhF3ZaL7qO73TBv2KZK48oH1sI99T4Hzhjoh99wYULTl8SuD8MGtv4WiSBIfuoA/SncAg9fUEKg0N8TIOvT4rWTUcy8UzcPXLBGI7wVhnlP9aXiHCtv98UTK6FyBhk7x7sD6VOTEEW4qxgRSgyWuCSYbEA1+UvlIKiMmlJnkO/vo3IFAU/Vj16fQRpsnSBnO+IfJvBFJJaP+E2m7FsFiMlz2yg3C99PCAMwmuMj3RTqR2Q6HAuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5oya9Mxn5lrIkzZi/5DUT8Y5MdmZjTFsigjS+b5kvFQ=;
 b=LGUFAdGBXwy63RC0eXa0HjqxbNMXxFVy4IcuEW3jVGuQpci20+VHa6K6EaE8hNGBkCph37TAINlk7EhKBBtnqVNnPQwloCI3/cSk/LmzJvJITgdml+zzR6SrtMqpPUnaAgA/YYMHiyv8ZhFXsMB5yRG01TCWw1c5Zn+03q+NJnI=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB2703.namprd11.prod.outlook.com (2603:10b6:805:59::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 16:30:00 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 16:30:00 +0000
From:   <Don.Brace@microchip.com>
To:     <slyfox@gentoo.org>, <linux-kernel@vger.kernel.org>
CC:     <linux-ia64@vger.kernel.org>, <storagedev@microchip.com>,
        <linux-scsi@vger.kernel.org>, <jszczype@redhat.com>,
        <Scott.Benesh@microchip.com>, <Scott.Teel@microchip.com>,
        <thenzl@redhat.com>, <martin.petersen@oracle.com>,
        <glaubitz@physik.fu-berlin.de>
Subject: RE: [PATCH] hpsa: fix boot on ia64 (atomic_t alignment)
Thread-Topic: [PATCH] hpsa: fix boot on ia64 (atomic_t alignment)
Thread-Index: AQHXF4722AqRbCqQukSHQNjL/VV846qGzRcg
Date:   Tue, 16 Mar 2021 16:30:00 +0000
Message-ID: <SN6PR11MB2848561E3D85A8F55EB86977E16B9@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <5532f9ab-7555-d51b-f4d5-f9b72a61f248@redhat.com>
 <20210312222718.4117508-1-slyfox@gentoo.org>
In-Reply-To: <20210312222718.4117508-1-slyfox@gentoo.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gentoo.org; dkim=none (message not signed)
 header.d=none;gentoo.org; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58f613ef-0047-424b-d963-08d8e898becb
x-ms-traffictypediagnostic: SN6PR11MB2703:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB270350C4F51D21B9324CB77AE16B9@SN6PR11MB2703.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A32ELwSnY6KAJV6H/xH0QyIZpo1D4K4P9IK0ETMHW/RybijxSZswnE3YGG0ad1XBIjkhiHJGXBBsPcu82Mouqgl+zM5l5Q0TBOfFeuHSmBmBj+Mg77GdyseImDGGVb/qtvJycnrc7DHBbmwQyHzEkTUFwBsehAKNeTmrghttkv8n7mpUAi/4g9inV102FpjBdIkLFDjH583G1IdrhewHIho86s59fQEDwpJ0+0IWISpgpngg8kX3zplDeUubdou9YK6CVqdACNF67LfUNStHbxAWcQzVE0IOW5ph32hWBk0unYeaMh+lHwNCumO95VnrBPJFldtw1ddIiTx9p7mtGRJyM/DBxDnM5LmbrL/EcVOldi1yh7x8zGKWp2C71lZFosdOX/FgvF5AJ4tJL2jDxVEdhTcwk7eZYB0Oo6FoQ/TKQuRLXbK/QS/nugn7mDxAOhs+XRvWt5bR3KFxuc4sm1JqQY8lGuNgqBr49J7tAxuc+DMDh41UEY1pfe6eOnLY0oi4rh52YTiHejIOZXWu+34cuosVOzhZHES6sgsspC/wd0EIqudWXq4850y6uEsi4f0RPMwXitJSzskj6VJGApWr7Ehv3seFFkMnmBcb/VCY8VKQSJiezVCoImyylPAnoBXXFgxXu7A3Grx7SELegg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39850400004)(136003)(346002)(396003)(366004)(966005)(6506007)(5660300002)(71200400001)(54906003)(26005)(76116006)(52536014)(4326008)(110136005)(2906002)(64756008)(66476007)(66946007)(316002)(7696005)(9686003)(66556008)(66446008)(55016002)(33656002)(86362001)(8936002)(83380400001)(478600001)(8676002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?66SJxaad/qk8mUtGzZMp0HrUuda4l44yUEvR9YjEYgoprrz/rhV6GyL6x+XM?=
 =?us-ascii?Q?/WGGUn6WHVcNiIX8T8yQB7Do8KFH0EaVCm5UVcloY9QhWZprRqjxxKIrJuvP?=
 =?us-ascii?Q?V+m8mOEmYd6wNuFHD1IZOKkbaZDYgPO2gujid+uAYYc63La7WxfGDBUNiyU5?=
 =?us-ascii?Q?Sh3tGNmEjxMkBMVf+sECCEI3Juer1X4SbqwFR3WozvEFlB8WKn8gZViLhz+i?=
 =?us-ascii?Q?xC/xp23G/ZPE6rDpc2nNg6QYKpxVW8kgK20KoPqLdu4Ez0QtPKZnitaX/3BE?=
 =?us-ascii?Q?WEvraPHeDOWyPXfE6TnsEq8Usxw37gC1h1sI+zKHR3UQkK3UklSklmobfrvs?=
 =?us-ascii?Q?KckMX2267apfT5FXEhGK0hVRyLwflfreGve3uq8DPDLgqFmc8fs3JCqVWLHk?=
 =?us-ascii?Q?8yyiBiHZZ1GWZN81Yc6qWtA5OQJjCULIxh8xQpum22WJwPk6o+xGtFLgpVw1?=
 =?us-ascii?Q?7juaXic6tO95iIVQaVP1LO6Z37QWzZomdUzkCH/iYFi0e1LP790WlX0ZX6R7?=
 =?us-ascii?Q?1tbPQf2Ktx+2VvqFcIMIdF9U3qYx95WLlk3EDuTYlnKMCZURt6jNsiegNIbP?=
 =?us-ascii?Q?V7m/B5QvDzTqmv4kgSmLo5l9RJC1mFNNZ9vKb+VtTcNbya/WDspTzlUd+HzX?=
 =?us-ascii?Q?Tuic0d7/UzcADlcu2PMJJ14qZ7o6fdp/I63RuvwaDf9+B7VSAwhhQIhucXUJ?=
 =?us-ascii?Q?BzENI9T5i+6ZZUvU8eAcpg9/vDGXhiTljjDOQuUZGFzIWScQN0O7DmRK06qS?=
 =?us-ascii?Q?caNUw+YO/BNRXQHMltT+pqtJJuT8bq+sROg3kmdS3JN4rWwmqr4N8N3zcYTE?=
 =?us-ascii?Q?YhTTkZoHLiU+UZfc3s17Tpvz6NOaKoIQbbF7XTyMGFrZyyBnN93ytf4CRTw6?=
 =?us-ascii?Q?oHIatp5k6V7fNKC1svwpzqAbiJplwAMVTrc3B+xOW0LUzIUKNpK06c6Nmx2a?=
 =?us-ascii?Q?JW8ND9LzPyijEZIG025KxJWibVu/aIaBULe9ovfBCUGvX1DMw3qvCOU6ZWV7?=
 =?us-ascii?Q?wl/D7m1O4ca05Hk9GqQxtr9B9FPs9jqVpMyi1iLiDdrLxnKNvljTOK7uaPK0?=
 =?us-ascii?Q?zGb6xJoPUmh52XQh2s0/z1QnNgIiMslOONiBbRCbL/ZkwZgbyAzkoOvZVapu?=
 =?us-ascii?Q?3QU9kqfF9vlKaa/P8QyU+AfBv2aype/dz5CPlMvAzTkGZuMDOe6MY1hX5u7n?=
 =?us-ascii?Q?cEMSXcKeDDCl5ryg4J+yTScGGnZDqGfLzejVr+DVmRoapW+YZT4NnkY56E2s?=
 =?us-ascii?Q?dJLlcP/EM37TDjnSnBdIUeXmDX7z6ZzPY/43kbZwUUUBK7zEsAfJsPebAkQP?=
 =?us-ascii?Q?7fI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58f613ef-0047-424b-d963-08d8e898becb
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 16:30:00.5789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rACOBv81SIDME/i//ZIPrCk2ohSbeQocXoz8Qcx7d0bgBklEw7ybb1n9FU3FQ/39Wj3bbCh7mqWIlnykGnoaQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2703
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Sergei Trofimovich [mailto:slyfox@gentoo.org]=20
Subject: [PATCH] hpsa: fix boot on ia64 (atomic_t alignment)

The failure initially observed as boot failure on rx3600 ia64 machine with =
RAID bus controller: Hewlett-Packard Company Smart Array P600:

    kernel unaligned access to 0xe000000105dd8b95, ip=3D0xa000000100b87551
    kernel unaligned access to 0xe000000105dd8e95, ip=3D0xa000000100b87551
    hpsa 0000:14:01.0: Controller reports max supported commands of 0 Using=
 16 instead. Ensure that firmware is up to date.
    swapper/0[1]: error during unaligned kernel access

Here unaligned access comes from 'struct CommandList' that happens to be pa=
cked. The change f749d8b7a ("scsi: hpsa: Correct dev cmds outstanding for r=
etried cmds") introduced unexpected padding and un-aligned atomic_t from na=
tural alignment to something else.

This change does not remove packing annotation from struct but only restore=
s alignment of atomic variable.

The change is tested on the same rx3600 machine.

CC: linux-ia64@vger.kernel.org
CC: storagedev@microchip.com
CC: linux-scsi@vger.kernel.org
CC: Joe Szczypek <jszczype@redhat.com>
CC: Scott Benesh <scott.benesh@microchip.com>
CC: Scott Teel <scott.teel@microchip.com>
CC: Tomas Henzl <thenzl@redhat.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Don Brace <don.brace@microchip.com>
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Suggested-by: Don Brace <don.brace@microchip.com>
Fixes: f749d8b7a "scsi: hpsa: Correct dev cmds outstanding for retried cmds=
"
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 drivers/scsi/hpsa_cmd.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h index d126bb=
877250..617bdae9a7de 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -20,6 +20,9 @@
 #ifndef HPSA_CMD_H
 #define HPSA_CMD_H

+#include <linux/build_bug.h> /* static_assert */ #include=20
+<linux/stddef.h> /* offsetof */
+
 /* general boundary defintions */
 #define SENSEINFOBYTES          32 /* may vary between hbas */
 #define SG_ENTRIES_IN_CMD      32 /* Max SG entries excluding chain blocks=
 */
@@ -448,11 +451,20 @@ struct CommandList {
         */
        struct hpsa_scsi_dev_t *phys_disk;

-       bool retry_pending;
+       int retry_pending;
        struct hpsa_scsi_dev_t *device;
        atomic_t refcount; /* Must be last to avoid memset in hpsa_cmd_init=
() */  } __aligned(COMMANDLIST_ALIGNMENT);

+/*
+ * Make sure our embedded atomic variable is aligned. Otherwise we=20
+break atomic
+ * operations on architectures that don't support unaligned atomics like I=
A64.
+ *
+ * Ideally this header should be cleaned up to only mark individual=20
+structs as
+ * packed.
+ */
+static_assert(offsetof(struct CommandList, refcount) %=20
+__alignof__(atomic_t) =3D=3D 0);
+
 /* Max S/G elements in I/O accelerator command */
 #define IOACCEL1_MAXSGENTRIES           24
 #define IOACCEL2_MAXSGENTRIES          28
--
2.30.2

Thank-you for your testing.
I would rather you add the atomic_t alignment check only. The current patch=
 under review has other changes...
https://patchwork.kernel.org/project/linux-scsi/patch/161540317205.18786.58=
21926127237311408.stgit@brunhilda/





