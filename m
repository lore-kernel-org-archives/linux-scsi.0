Return-Path: <SRS0=qcVN=CF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5848EC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 07:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C620207DF
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 07:35:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fEVwLGGY";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="g4m1+zfO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgH0HfJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 03:35:09 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54532 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728029AbgH0HfH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Aug 2020 03:35:07 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07R7V05E029173
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2020 00:35:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=MjxuuvDkSlC8PWAX4UnJyPkVMpIxwvF0XzowfowN3fo=;
 b=fEVwLGGYbm5HIY5ZmihPHPUDdsk9YJhmH/2qCUopfAt67GRDEVoaUY4P2OULLfSozVJx
 TVHLYACjRfn33nAXYQKzTW1OViYCb7lsNgiWnF1R7e4eACaqkqZtiKAUEbVCG70dfvWV
 PnqiQhTIA6TTqvD3RKb2BT2bAJkxvA5Gm5S7JcaDtVcqCxFuCeawl+gG11f6RINligqU
 FgooPWqLftYB7vsuA1xOs5CGr94WlMoRa7f2RbDkXCSPPk5H22n5ps3NMXVt92LVPDua
 k9O2rhMrKVrfKxxwauedOhKjRhsFgO25d82rl4D+YX10MxRSJrpeUs+7IObTVMyMMzZM Ng== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3330qpwkkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2020 00:35:07 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 Aug
 2020 00:35:06 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 Aug
 2020 00:35:05 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 27 Aug 2020 00:35:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WA71GYkRlIaaGXJwwRm91Hh9klIqBJ4vSilBCVg+HdbIPl61uw0tqwxb/lvyZ1JabsEtpDeD04gxXxUztxnOqRukccKjuc6p/QVY5R3VtRQ02MlEK2cMzOCAU27AwZ18ENJJjByIX/l31qMS9xZaczKCEl7b5FWBFRF/5PiwuqtD+ci20yNtjPkqMBbYWNyaFRdY4AYD3eYd4roqedL1bStKDMy+V5FTAUVOp2EW62IlEDaPjvqsv41sE8AMbOk9v263ubbi2RusD7zg7Y+xevxrzAlFSPBtzCv7sbwg0Jrfeibd/xQXQUUpHA7zLQ2qTHbEklM/PUd6tebd93mE4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MjxuuvDkSlC8PWAX4UnJyPkVMpIxwvF0XzowfowN3fo=;
 b=h7pww/VO1EhNBU/ruHpLCx57d1lJS8T9imxLf5ELafzM/u8fODLw1zlASj95xXTu6RT+aNnZqWgJ7AMUwqHncHK4tcjankJ931eWqkFgK2SQ+J5TmUWTl9COyI+v97JIwoC2ZvWMLTOAR6TCaohU9o/PLGl+LZcJSigAheIgG4bZHSSNC88jSLtlCLcTXwW1Mn/p5R5XSVGcwvt+A5u9+pjE/Nfty5VYe1+VjRmiY+tfWTh7ct0Bw9UFBY5yj9mMaMUdHDqnVGlUPtNIYPo3addC00LuoP8VOPi6St/8BJbVvorxCgKjjdaNIObrdSo6wsnRXWsn0SrrZOyzrL1AZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MjxuuvDkSlC8PWAX4UnJyPkVMpIxwvF0XzowfowN3fo=;
 b=g4m1+zfOu5tS01M1vzWOppXImG+Z15u0zbLeed+Na1jqoljVuCYHIcHlDPfB1+DhIsF+NRJ9nnHzBPxZwOoCVIUDoHzcqNZlpiau18soAsNdX0l2Atg3+vclzxsZb0u02l8WJ1EYMChOTDRBxGXjL/Bb6x7vbUim57M5ICISX5o=
Received: from SN1PR18MB2301.namprd18.prod.outlook.com (2603:10b6:802:28::28)
 by SA0PR18MB3472.namprd18.prod.outlook.com (2603:10b6:806:9c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Thu, 27 Aug
 2020 07:35:04 +0000
Received: from SN1PR18MB2301.namprd18.prod.outlook.com
 ([fe80::80c1:ad02:2a2:afba]) by SN1PR18MB2301.namprd18.prod.outlook.com
 ([fe80::80c1:ad02:2a2:afba%3]) with mapi id 15.20.3326.019; Thu, 27 Aug 2020
 07:35:04 +0000
From:   Javed Hasan <jhasan@marvell.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] [bug report] scsi: libfc: Free skb in fc_disc_gpn_id_resp()
 for valid cases
Thread-Topic: [EXT] [bug report] scsi: libfc: Free skb in
 fc_disc_gpn_id_resp() for valid cases
Thread-Index: AQHWeGt/Ax1yOSO1UkG29EBM5bpICKlIlu5g
Date:   Thu, 27 Aug 2020 07:35:04 +0000
Message-ID: <SN1PR18MB2301081291FDFC88F0C97C1DC7550@SN1PR18MB2301.namprd18.prod.outlook.com>
References: <20200821125226.GA34517@mwanda>
In-Reply-To: <20200821125226.GA34517@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.208.69.115]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b07c397-f81a-4ab8-3189-08d84a5bb6eb
x-ms-traffictypediagnostic: SA0PR18MB3472:
x-microsoft-antispam-prvs: <SA0PR18MB347209B15707EBCA20E8D07AC7550@SA0PR18MB3472.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 48du4vmqpgmF6+UXcxyS228ZvbB31v9hi7vYJwLIP8W5zR1Apd8/WORCC0CuKHXrHFVmilV03/5pyLeMBQI0FKSHWAJ+78exIqSYSodg54LAcnSbb2G0G8/u6pry9tretX0i0Wi6g5pNC41a59fVAWwtOuqAAHadr2qLxC5ixQNzsQVBXFXi92eeFpECYfLN8CPL7278cX0Vt9O1TheAZAT28geVjxLfdxdy983KQdjp2+1mf5GNLfLLRoIeD+EoF61dD647Zv7fjVRdbZ3iCJPCmbADLOsu9h/fV/s8wMKQuMoFpoiqsHUuRi7Z62BIET0Pi2pJUOJMk2zj0Wlo8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR18MB2301.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(26005)(6506007)(53546011)(64756008)(2906002)(66446008)(83380400001)(86362001)(66556008)(66476007)(76116006)(66946007)(9686003)(316002)(55016002)(6916009)(71200400001)(8676002)(52536014)(33656002)(186003)(5660300002)(478600001)(8936002)(7696005)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: msFMBOnJuseGPML0xDXHfw1bW+61cbBMkSEFqd8WtR6bJiCtCmBz646vFmxtPWpIDj1DK6YH0RSaQ8MH+9oHqGELOYNrRWHh6iAAfGPrIAdvD7LveEjqpvt1LkGYgP3WfGwY+2hujEokUCz9VwrqBxNQ3Y8gsThIg4YHJVP6ZKSpv0guNcvzOWaTxCgnQtQU9o/MZfkGDohvloW6apqDfUYifzUuURngaWmziaOffXFHU6bz++bZi0LfMyf5Z4QFh6Tie7Wzepi2Fa8y4kU0GyHt2L0zznUpxzxi5Vw48wDqluwDhVOmZptZDOTy2r6PDPtrN9YvDliGy/Ghlav9t7oSqWPRjZlBXQ2vEyUGULLKp8YqO8kKHLc7eIWgUyQEx5kjMiFxpq7iwdlAr/4f1jNWT+LP9z23NotqH2WwiObEKN9hZCVyMVQLM/44ZMN+0Pm1NPkNUdNMipqbmEqojiyfgBkX3KzlnF0J9/qNE31Hlu3TdLNENRIkwg3OKEUkXJAH2w/POoggr7PBzlD/iEfRn3yQav/mGyjyRDeh8MPfCOWzo05JQcXUhdqXME2biOy+8Po40qHBaoLNwHfZs/9lzyguzWDsADC7V30lnrH9IIeOPko8jA0ACHE6IEpSaxmaiZ/LePpODObpHk2cfA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN1PR18MB2301.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b07c397-f81a-4ab8-3189-08d84a5bb6eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2020 07:35:04.3981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /1XNDGW47KFa844xWk6xJ3QSvRgkWNAKwHHMaKs9SRnjY23tjsGmzP7X6/EpZYk5HsFCrH9kxy62xF+f19NWYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR18MB3472
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_02:2020-08-27,2020-08-27 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Dan,

Please find my comments inline.

-----Original Message-----
From: Dan Carpenter <dan.carpenter@oracle.com>=20
Sent: Friday, August 21, 2020 6:22 PM
To: Javed Hasan <jhasan@marvell.com>
Cc: linux-scsi@vger.kernel.org
Subject: [EXT] [bug report] scsi: libfc: Free skb in fc_disc_gpn_id_resp() =
for valid cases


Hello Javed Hasan,

The patch ec007ef40abb: "scsi: libfc: Free skb in
fc_disc_gpn_id_resp() for valid cases" from Jul 29, 2020, leads to the foll=
owing static checker warning:

	drivers/scsi/libfc/fc_disc.c:638 fc_disc_gpn_id_resp()
	warn: '&fp->skb' double freed

drivers/scsi/libfc/fc_disc.c
   568  static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame =
*fp,
   569                                  void *rdata_arg)
   570  {
   571          struct fc_rport_priv *rdata =3D rdata_arg;
   572          struct fc_rport_priv *new_rdata;
   573          struct fc_lport *lport;
   574          struct fc_disc *disc;
   575          struct fc_ct_hdr *cp;
   576          struct fc_ns_gid_pn *pn;
   577          u64 port_name;
   578 =20
   579          lport =3D rdata->local_port;
   580          disc =3D &lport->disc;
   581 =20
   582          if (PTR_ERR(fp) =3D=3D -FC_EX_CLOSED)
   583                  goto out;
   584          if (IS_ERR(fp)) {
   585                  mutex_lock(&disc->disc_mutex);
   586                  fc_disc_restart(disc);
   587                  mutex_unlock(&disc->disc_mutex);

This call to fc_disc_restart(disc); was added in the commit, but it wasn't =
mentioned in the commit message so I suspect it was committed by mistake.
[JH] : This is the part of the fix. I just moved the fc_disc_restart here f=
or case IS_ERR(), where we need to do fc_disc_restart() without doing free =
of "fp".
   588                  goto out;
   589          }
   590 =20
   591          cp =3D fc_frame_payload_get(fp, sizeof(*cp));
   592          if (!cp)
   593                  goto redisc;
   594          if (ntohs(cp->ct_cmd) =3D=3D FC_FS_ACC) {
   595                  if (fr_len(fp) < sizeof(struct fc_frame_header) +
   596                      sizeof(*cp) + sizeof(*pn))
   597                          goto redisc;
   598                  pn =3D (struct fc_ns_gid_pn *)(cp + 1);
   599                  port_name =3D get_unaligned_be64(&pn->fn_wwpn);
   600                  mutex_lock(&rdata->rp_mutex);
   601                  if (rdata->ids.port_name =3D=3D -1)
   602                          rdata->ids.port_name =3D port_name;
   603                  else if (rdata->ids.port_name !=3D port_name) {
   604                          FC_DISC_DBG(disc, "GPN_ID accepted.  WWPN c=
hanged. "
   605                                      "Port-id %6.6x wwpn %16.16llx\n=
",
   606                                      rdata->ids.port_id, port_name);
   607                          mutex_unlock(&rdata->rp_mutex);
   608                          fc_rport_logoff(rdata);
   609                          mutex_lock(&lport->disc.disc_mutex);
   610                          new_rdata =3D fc_rport_create(lport, rdata-=
>ids.port_id);
   611                          mutex_unlock(&lport->disc.disc_mutex);
   612                          if (new_rdata) {
   613                                  new_rdata->disc_id =3D disc->disc_i=
d;
   614                                  fc_rport_login(new_rdata);
   615                          }
   616                          goto free_fp;
   617                  }
   618                  rdata->disc_id =3D disc->disc_id;
   619                  mutex_unlock(&rdata->rp_mutex);
   620                  fc_rport_login(rdata);
   621          } else if (ntohs(cp->ct_cmd) =3D=3D FC_FS_RJT) {
   622                  FC_DISC_DBG(disc, "GPN_ID rejected reason %x exp %x=
\n",
   623                              cp->ct_reason, cp->ct_explan);
   624                  fc_rport_logoff(rdata);
   625          } else {
   626                  FC_DISC_DBG(disc, "GPN_ID unexpected response code =
%x\n",
   627                              ntohs(cp->ct_cmd));
   628  redisc:
   629                  mutex_lock(&disc->disc_mutex);
   630                  fc_disc_restart(disc);
   631                  mutex_unlock(&disc->disc_mutex);
   632          }
   633  free_fp:
   634          fc_frame_free(fp);
                ^^^^^^^^^^^^^^^^^
Then this free was added.


   635  out:
   636          kref_put(&rdata->kref, fc_rport_destroy);
   637          if (!IS_ERR(fp))
   638                  fc_frame_free(fp);
                        ^^^^^^^^^^^^^^^^^ But there was already a free here=
 so it was a double free.
[JH] : I removed this if() section. Now there is only one fc_frame_free() w=
hich is present just after free_fp:
   639  }

[JH] : Thank you for pointing out.

regards,
dan carpenter
