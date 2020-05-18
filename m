Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC02C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 06:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 957F2207D4
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 06:50:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="d0FutZVA";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="FkHJfmY4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgERGuB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 May 2020 02:50:01 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42628 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726040AbgERGuB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 May 2020 02:50:01 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04I6kYD3018943;
        Sun, 17 May 2020 23:49:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=/rtEJlp6KW2IrLWrWETm0GmaARpEqpxIecN1nfTEbzE=;
 b=d0FutZVAmidMt7AHLNnWomsLzmCGkV9aIlQr7Uwv/cutVh1lP8CxOYVzuGnGbhwb5r4d
 J5KKR2RCRQtYeh5enMHWrvUNSN0J5/X34ak3ns5mftTcC52HVuwlmYRA2uDTDnVQVK+e
 iM7yOtXi3IWax83U2/ZKZQd4tdW+HIEA2WNeeJdXVGzaQ+MTBe6N12NN5pM1PqUrwsfm
 EMhQObEcltqN1ZE75hSzbhu26HBgdP9vPNnRq53wkfjdDB4DGL2et0Y4IfOny17zNcyB
 T1qDfjz2pdGIfpp0x/50Ka72yvpOq+lLxq2NO+pj1KaHZnYKvWvnXNkufk0gWnSuAPOo ZQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 312dhqe30q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 17 May 2020 23:49:59 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 17 May
 2020 23:49:58 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.53) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 17 May 2020 23:49:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ApD3ENuOdbFOhfYM7/rZv+Jkrn1g1bFC6+cS1X2mg/KXh4PE1M9aIMZUbclBwiEEjeaCPE04QMk9Ih3pDnykME0eJpbFMAOjky2JZdXSQEeuncNnAON388HBftWpWMgrQ+UoeZS1Z/NkTstNQB/ufUUmIX7RAiOpD9oJiYN4OsUxe5+3UQZVSQ20IsmEkSHgNhylKv7PHJVamDbhgvtHb13txNmMpPffV7InqA4EhMkIvz+ZvkRyfJ8K9CewowrLBdJN6D58EzL61t8F1ySKiaCe+JbhrjsnhgIoy7Iqr7qGllQhE0FDxqT0wUqBkWIRUny0e3dHHmaMkGjFtHsumQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/rtEJlp6KW2IrLWrWETm0GmaARpEqpxIecN1nfTEbzE=;
 b=Lr3e5ummBALFM+1uy5BTzWURAiNxOKAwKg+WC6nN1WgHi2Mjwcc3MjaqAlJatXbWEm/8CIBAxkvonurCj5WLn0D6oEAJwYjZvDeI2lZDkjUeRvXvXqEBpWxZ7zKFoYPiuqPqSUUK1mKg80bDgF5x+vuAgWOFLeMC4/hb0bFyNmVLQv4oao5x9NE9QdsfyMWhLv5kFRdGuqADiHM/dRego1sGvL7NN9ok1FkVSJ5Xf2U84nXrCCsdduCtpy/2a3lQQxUB4bp5ktk6tKypi26FUCwrFE19D6TQ5xEfazGY+nStNFboQvoscjFszjh8KccDLGc6B2PYDFG1WirwH7fGrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/rtEJlp6KW2IrLWrWETm0GmaARpEqpxIecN1nfTEbzE=;
 b=FkHJfmY452r8GlOGLfbtp4gB6olXitjEHMxeYAWWgLPtr2HGZi85CvqrDWoVFwYbHa5Q+3mY0wtkdmXfU4Qqz23ZIJQZ1iRECK08QU08FtZDqi7B2bXuqGGuwxarIqrYKWZbp8bFtmLy6SZolVfvS1GCFMezWxZRSi3c81BaN/E=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM6PR18MB2572.namprd18.prod.outlook.com (2603:10b6:5:15e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.27; Mon, 18 May
 2020 06:49:57 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::4534:f910:753b:b037]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::4534:f910:753b:b037%3]) with mapi id 15.20.3000.033; Mon, 18 May 2020
 06:49:57 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     "rosattig@linux.vnet.ibm.com" <rosattig@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Arun Easi <aeasi@marvell.com>,
        Girish Basrur <gbasrur@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: Regarding - Patch - Fix crash on qla2x00_mailbox_command
Thread-Topic: Regarding - Patch - Fix crash on qla2x00_mailbox_command
Thread-Index: AdYs34wgPovt6PIETKCcIWSIOZymMA==
Date:   Mon, 18 May 2020 06:49:57 +0000
Message-ID: <DM6PR18MB30346814DE1F5807188A844CD2B80@DM6PR18MB3034.namprd18.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.vnet.ibm.com; dkim=none (message not signed)
 header.d=none;linux.vnet.ibm.com; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [103.195.202.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02b5d366-1096-4e69-52d6-08d7faf7ada4
x-ms-traffictypediagnostic: DM6PR18MB2572:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB2572B6B26067D4C623D9DC35D2B80@DM6PR18MB2572.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04073E895A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fgxeQiz/E/Xt/sdT/HozkLfTjJZyHQkOeVLB4WT/KAIM1zqiOg90jWPHOEsLIm/49hs5gghHhPEiOWWJGN+tsT2kCwzE2olAMebtOPjOFrMn+0afxR7oneFYNq+A4tL3PTEXO/Mi3VA1INecSG9v7mKwAmnMaPyckXtpny3pHz37GDnDktqPlNFxw+cQZvgd7lVrlJac/S1SBCK5GzTMiS82PAjFClthhRU181cXfVlPeTFIJaV+yyeDLu06lEyBLTMOwsEnzKY0EU2XDpeE6yNAKrmZG0e3EnWWI8Ya9hqmJcdCv9zLaq3Q+hhGii8F6YwF7BJQ+75Nl0nQxjSAntS+3iJo8+hX6Ypkvd5QbSWX50jFH5/zjXORMB9VtWFwny37LbZn86sTcRzKs7desZMXATwse3n2oRM3dZxuL5QbQ4IxHaBAji5CEFXqZ5RC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39850400004)(396003)(366004)(136003)(376002)(86362001)(71200400001)(76116006)(2906002)(55016002)(4326008)(52536014)(66446008)(66946007)(66556008)(66476007)(64756008)(316002)(54906003)(6506007)(26005)(186003)(107886003)(6916009)(7696005)(9686003)(5660300002)(478600001)(33656002)(8676002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: RJRrcnDo6+9sq0djEE55yhXsjbe07zQa5hN+abDEjI2vj+BkEfv2JthRlqQHaUulijtTLyAtVg9u1sLTA2F/XhlPQh3ffALbioXIYQv6HePSvM5BzfgZCMfw5FlLPxETqNQbUTmuvGUgAyqlvEl4T2tvkOusldssYiCGDwX0oxZq1pp6H6KdXAKcmhAye9NP2rOEQX5VIalgqQP2RxuHgweuuawhP5YcxkpdaChH6F1WTqInKaucTC6DP41R5qaD6Rok2lDSAwn8EkKSqepD+GlQ/1EH4B0BfBkKD/fl5Ot0yw4mU7svOUcvF0reClCTHsvB6uy30nMCZrM5XCqDUYrQVJnRjmZE08AEapGUxqshS/pi1qX5sUMlVjDvNoTQNupz6NRnzQu7pF+ujp05EINIUzQXLr7w8FN7VTCQFBwLyiTr2ru34y6QyCMW77yqj0ZNyp5Sl+t6Ae+s8jCnJ/FNDOzC2PvTkw5CVnfif738ForwXwifUna2SI5mqxMX
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b5d366-1096-4e69-52d6-08d7faf7ada4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2020 06:49:57.2048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OuDuP2OVpZvQ8lBBNsOQ/4hHB70T5TJMGM2GQveF0ETahc+sipINc1HD6Wmhsc4FX0qkgGXTx3XUGVAU1bayrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2572
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_02:2020-05-15,2020-05-18 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi  Rodrigo,
We are seen regression introduced by below patch for QLA 82XX HBAs. On unlo=
ad, the disable interrupt, mailbox command (MBX 0x10) fails because of this=
 patch and leaves the FW/HW in unstable state. The next load fails with ini=
tialization FW timing out.
The only way out of this is to reboot the server. I  and  test team have tr=
ied to reproduce an original problem that is fixed by below patch but we do=
n't have any luck.

We would like to revert the below patch but would like to address original =
problem as well. Can you share more details about the NULL pointer derefere=
nce? Which data structure was NULL and what was the test case?

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
git show 3cb182b3fa8b7a61f05c671525494697cba39c6a
commit 3cb182b3fa8b7a61f05c671525494697cba39c6a
Author: Rodrigo R. Galvao <rosattig@linux.vnet.ibm.com>
Date:   Mon May 28 14:58:44 2018 -0300
=20
    scsi: qla2xxx: Fix crash on qla2x00_mailbox_command
=20
    This patch fixes a crash on qla2x00_mailbox_command caused when the dri=
ver
    is on UNLOADING state and tries to call qla2x00_poll, which triggers a
    NULL pointer dereference.
=20
    Signed-off-by: Rodrigo R. Galvao <rosattig@linux.vnet.ibm.com>
    Signed-off-by: Mauro S. M. Rodrigues <maurosr@linux.vnet.ibm.com>
    Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
=20
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.=
c
index d8a36c1..7e875f5 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -292,6 +292,14 @@ static int is_rom_cmd(uint16_t cmd)
                        if (time_after(jiffies, wait_time))
                                break;
=20
+                       /*
+                        * Check if it's UNLOADING, cause we cannot poll in
+                        * this case, or else a NULL pointer dereference
+                        * is triggered.
+                        */
+                       if (unlikely(test_bit(UNLOADING, &base_vha->dpc_fla=
gs)))
+                               return QLA_FUNCTION_TIMEOUT;
+
                        /* Check for pending interrupts. */
                        qla2x00_poll(ha->rsp_q_map[0]);
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Thanks,
~Saurav
