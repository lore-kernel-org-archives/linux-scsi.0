Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B217C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbiBISA1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiBISA0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:00:26 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9C1C0613C9
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:00:29 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HMhhF013360;
        Wed, 9 Feb 2022 18:00:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ovcfzim2u53MRaucZFQa4fFmUDqK1lxhZW3MP9CaoLo=;
 b=VcZx95yxKvFiuBArn4Bbfxj0KX2+0VPQNmB0SBkNEOk9WXep2WQDAJkueCr7hFxdOJ3R
 FGJxDeK4B4tMcp7wTjUtBenUOwomVOzLU2lu92Yy3dhxt6rnbS5Lo4KivQMZPHt7DQZK
 XfWc56AfEW8awpe9KdGasV+cBvtr1MI0Xx/nkLx+XKkcw7P2tH36KygtQOWF0Xhe/F6q
 fl9s9tFMiv6746t0z6MEqyjcHHtWRG70tPrySzYBEHFqtxrQ/ndPo+aLUzahKn+rd/u3
 8LVDIOJBsQhHyaJ9jSsuIlkCIIyIWwFthtVWenmxZ/CWWjLUXG2Ma2OIml7FGWfWI8/7 aw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e368txjw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:00:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219Ha2w3011031;
        Wed, 9 Feb 2022 18:00:23 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2045.outbound.protection.outlook.com [104.47.74.45])
        by aserp3020.oracle.com with ESMTP id 3e1h28pvmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:00:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLid22NIzSDJDeZJ+5ljiAqNR1+rIgD95+YeWJQGL4PsY6aCoa7zVUkvjT8KeX9GLKfOvKF2/sAefZ9KlD226fPeqP4H/vP5bo0AexTdLS7D/ckbCHhW2GtJTX0nohihepPrSvKrgiKR2BoZF4Z02RExSQFFb6JcuITz7CET4rwOOPNJpt7yFNtLjcjNPnzUfOT+D5LMItDSGEHYJw8JKunmuUP/muL3CHDwNqwDWQXXcFOKHHxIJy6j5GbYnFAR9vW4EobN/m/r/S+UqNNteyEIcIcrUdMCOwuwCqBnaR3CXEKd3LffYr/ab8vHRlg3n8eNU4tYL8Mpz7cfRHh3nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ovcfzim2u53MRaucZFQa4fFmUDqK1lxhZW3MP9CaoLo=;
 b=AKtkfvyhqBVbCfRYUsaubcEWwLZHp8hZ2897+N2GaqG4L2aGEmugWiG2nWb8G+Ey4FYkmFl5ZDtikzzgPR37i+Pv0ihe00ACecjk1A7UYosKA2K1RSDt7rllWJH47wYwfIqzA02XiWITQ/LB1N8J+ysaAdRxom8ByDolXyy8ww2LDbsYU5Dd7hMWXrMk0bAGSbFHNmWGvl76y0gTaQlQRmX1Kq7EFRPW9J14e1jqazQU5c7QlHbVWnBH+KH9niaDdlMw4zZFjPrnicMzFxWsFuOqQMVZV4r21qqAYArJgA642ZiLdgge04oQfFoprMB+4iNyvSpAu8pT9JiiXYlpNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovcfzim2u53MRaucZFQa4fFmUDqK1lxhZW3MP9CaoLo=;
 b=WZjkd7jna0qb8zPSdeTy5XypGFkiPtUS840xMjtZz5vMzAax3klTdNDiTNRVVoNT3f/pAzxe6Q8s7eLj49LEEnTdhGCTufVUxZcTwRRMCWgxpXRvgWiinEuhG9MAUvr7Qm4ip3Z9TqTtQ2TfPcCVPQ8gNzLh7GrCbbMGusKJzwQ=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BY5PR10MB4323.namprd10.prod.outlook.com (2603:10b6:a03:211::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 18:00:20 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:00:20 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 13/44] bfa: Stop using the SCSI pointer
Thread-Topic: [PATCH v2 13/44] bfa: Stop using the SCSI pointer
Thread-Index: AQHYHRD7ibHpQnGDSEOp/95AYIPVf6yLg6qA
Date:   Wed, 9 Feb 2022 18:00:20 +0000
Message-ID: <9415CBBD-EA37-4203-87CF-A54811397E86@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-14-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-14-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 574dff45-e386-4645-25d4-08d9ebf609bc
x-ms-traffictypediagnostic: BY5PR10MB4323:EE_
x-microsoft-antispam-prvs: <BY5PR10MB4323AF972E8CAEA5C3AA97D7E62E9@BY5PR10MB4323.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:309;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aCYh1rdWqY8sEQqyxkGjaIf/fCTVOOnUSkgosZpZmoohrSMQSiCOX48Ixpmaw9knEmapo48Et1dAfGCKbqS4XN4Zr8zRaqR5SjpljM++uhK3I0dxRgCOYNoVxeFSlzzVnkpPFneECTD6VpKrN0KcScviYOiDBHe23FsljTvwKoedXqH18yL7bUuMIN43b15/PJ99mgY2vatRCny0lBcJz/4EGTGqCvRK0RTqlSZCYdlqpR41DqhEcYPm6oBkvCITlWDnYJ+8y2XxMt1jJYebYZqdTgoiekR8OA8nL0xxRxNOkdXeCOSKPO1vlsDtFWLveILROp8VioXLUf4OyxQo4Ixi0fRiJlRItNJO8AQSH3rTQsXtJFRg0mOA496jPtk4tdgDxGPzO5DCw+AGDwz/62Ws4gJRL0zUuhPwa3aGBQbRFwSOiH9kM8Ddd9NMr6g8e9aAgFozuxDu5x4Ascw+SKn1sbpZUbRW8mz91iqEhp2aL03zXfTRKHTAsFH/d0T8rnKOmjEVW6STWnw9EpILafMfFfy+rtSBoicukzlPe8IS803V7sVRckbQYLo7kGAivq5DxKSjy265fauSkJnO4e1maUKbvwrgRBR43bRmianXGGWLQEU8WGPDcixGskrQrWGpuQsWFhEhLxUFEu0L8nKBnxJcwRJRq8C24BaiTYy4lmOxQ+EXyYBmB15gDIATl6CsySh87iqSXRki0nQJZMKB+7yjBPjhIC+vzFGn7/dI+fSZylziWh7QJZh4WA6l
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(66556008)(38070700005)(36756003)(8936002)(71200400001)(4326008)(8676002)(508600001)(2906002)(66476007)(66446008)(64756008)(33656002)(186003)(2616005)(44832011)(6506007)(66946007)(53546011)(86362001)(76116006)(6486002)(54906003)(5660300002)(6916009)(83380400001)(122000001)(6512007)(316002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lq7XI60/g5eUq2NA8M9+/mZhTOTRHgOMai1VnN8vyZ6M2vmHbqVOF5WBMUh1?=
 =?us-ascii?Q?J+6PzwDp/oXXPHQK3/DkybADFdpRlyvXk3DP2aDpXZyk6b7x41RdvNC0TDSd?=
 =?us-ascii?Q?U0eJGoW8WEd3ZoW7WtwnhNFksN5fVe641T770lCPiMkBXjI4lBdp2YjM9Mq/?=
 =?us-ascii?Q?EznBVXZy+qYp0Qkajoop6wwrganUu29JgskOjgKd0z+yQEBk1noAzcYHGvwu?=
 =?us-ascii?Q?A4cGjLxh1PS0suxHjgrDxyFKbTZImofUrs5rbSlvs39ybT/59ynx0hiBaYEP?=
 =?us-ascii?Q?9ZqsfQe+KrI7ioEt0bEGC6ZXvJ4C/4uh+NG9vdiP9dAJEMNrJGLdSw4vXs+D?=
 =?us-ascii?Q?zI0s4iqYVr9KkXWw/XEwmAxtBEIc876oUIcOihVozZNOcvTm+FZc5xHJRHCW?=
 =?us-ascii?Q?u/pg7wgJ5y8OgB0DV0ZiWwkTp1TbVQvu+3ds49erYhLku136f+Zr+Fa5K787?=
 =?us-ascii?Q?2/yoJwmOGDQKdHETABSjMmHnUOlIbJKyyZtRcc9jbdTXN+SobLPgzToTaz+6?=
 =?us-ascii?Q?FOR5796ZCV9g/I2a9xhJMgITEoNn7tQjZODV/SS5WXHLT6rdXG6XhvLFQTcS?=
 =?us-ascii?Q?Sam0dvM68tkhkAl1dpf91t0ntarzgMcmSmDx4qdv7pRZfxXLywmWs5m1R5QE?=
 =?us-ascii?Q?udV1x5hi/RNaHWEEAd3SAAukQK+vP16/A+PCWbtKIa7EtN7OvoOxXuyJXHiM?=
 =?us-ascii?Q?7p4Iwl5e/8OEZJtlWq/V/ruWM9rU3tqs31hzzzWZwHc0cH3GVmR0Qd9NVBcC?=
 =?us-ascii?Q?bjU1PUvHeTCKkM3TR/VRFF4u3B3/dqmzI5yC1jGoLSX/fw8BPSOv505zlbKH?=
 =?us-ascii?Q?jeRftWhaH05NmHLXn5b12jvzKKeJOExIpYeZaTR1fWqGKlPyXXlQz9aK1JfL?=
 =?us-ascii?Q?fZnav2lPv4o0qF5F5b+9RzFPKSg7629mDqALtTPPKkqbLortPZiOLQzvgdQr?=
 =?us-ascii?Q?iXp3Z0QuyMI4qNdaBLdL6pgH5AV/D9/BuNBjWcFj+CZD5yw9FwG9SWHwWCOH?=
 =?us-ascii?Q?Lgvf4DawQ0gBOtFs47UrPXxeHjCsAq96qaHZdMlK3HgCizNUbaX14xf1weEF?=
 =?us-ascii?Q?WcwL0hZGe4F8L4wpE0Idyryi4dSeISBPzgmJe8jYWSKt/gwFAxq1RjYoaYAL?=
 =?us-ascii?Q?3fOsoH3FZKMWD84bra3fADKpemupewiOQc3CjziSS4l9R3nMk6YM7Tg9PcAe?=
 =?us-ascii?Q?WIGh6cWa954zkEBV+l7iNF4BiGTuCfSB4GPoW/nAxKjBcvlSxfgHyCV+nQZf?=
 =?us-ascii?Q?a71L46+kZdEgLssel5tpz6q8zQGcEEYbWDwJ3aT3UCivXQuNdY+7D3USPcup?=
 =?us-ascii?Q?F//I27BArUWEw0KJT5aOt9DUdWZCXeg3rKEXK8T2rcHovgeb7ucwl+8gcS7G?=
 =?us-ascii?Q?chwi6qcK81HqmX716JBDHVfW6pKyVyo7PPKUVbGvDcirSPTd+NT+oX6yfKPG?=
 =?us-ascii?Q?+fY6sF1i2jzcaXkn2XWpqScmGVf3xBrJ1iihFascKg22Xtz6r7kZzshQ4p5+?=
 =?us-ascii?Q?S2vJFLFlMx3yH9wFxOC2oIamJqHc/dR7ivZElOTXvddwgb0f7MUS4CX+YWov?=
 =?us-ascii?Q?3m2a7kvXmjn4z40gPzrSKae2RXm5JEhHGKcALDlSBsYp905nIr6NZ7tOfwa1?=
 =?us-ascii?Q?jsrfdcqDuMQnL4G62nU4EXoocLomMsb0B5P3Zi+r9y2d1USiu9V+iYNDMp+V?=
 =?us-ascii?Q?A41ljq1X/DFhkGVy//2e4Z18kswNh7G3e31Mkc3KKV4Mdi0R?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <666F5473A09B3C4AB3995663B318FAAB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 574dff45-e386-4645-25d4-08d9ebf609bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:00:20.6505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2ZQwNVZ2Wmk39EiuxHiiZAl0CT8ECLBPZai3wmJGGHmpUu6adrsCRhBwzF+E4x0wcUEfaI13b4P69xo2hTcuy8Il3pcTa7heClJ9dih5BT4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4323
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090096
X-Proofpoint-ORIG-GUID: 2Yq1P1Acs6Mzq1o_eBDU4uRWNylaSnXo
X-Proofpoint-GUID: 2Yq1P1Acs6Mzq1o_eBDU4uRWNylaSnXo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd. This patch prepares for removal of the SCSI pointe=
r
> from struct scsi_cmnd.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/bfa/bfad_im.c | 27 ++++++++++++++-------------
> drivers/scsi/bfa/bfad_im.h | 16 ++++++++++++++++
> 2 files changed, 30 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
> index 759d2bb1ecdd..8419a1a89485 100644
> --- a/drivers/scsi/bfa/bfad_im.c
> +++ b/drivers/scsi/bfa/bfad_im.c
> @@ -150,10 +150,10 @@ bfa_cb_tskim_done(void *bfad, struct bfad_tskim_s *=
dtsk,
> 	struct scsi_cmnd *cmnd =3D (struct scsi_cmnd *)dtsk;
> 	wait_queue_head_t *wq;
>=20
> -	cmnd->SCp.Status |=3D tsk_status << 1;
> -	set_bit(IO_DONE_BIT, (unsigned long *)&cmnd->SCp.Status);
> -	wq =3D (wait_queue_head_t *) cmnd->SCp.ptr;
> -	cmnd->SCp.ptr =3D NULL;
> +	bfad_priv(cmnd)->status |=3D tsk_status << 1;
> +	set_bit(IO_DONE_BIT, &bfad_priv(cmnd)->status);
> +	wq =3D bfad_priv(cmnd)->wq;
> +	bfad_priv(cmnd)->wq =3D NULL;
>=20
> 	if (wq)
> 		wake_up(wq);
> @@ -259,7 +259,7 @@ bfad_im_target_reset_send(struct bfad_s *bfad, struct=
 scsi_cmnd *cmnd,
> 	 * happens.
> 	 */
> 	cmnd->host_scribble =3D NULL;
> -	cmnd->SCp.Status =3D 0;
> +	bfad_priv(cmnd)->status =3D 0;
> 	bfa_itnim =3D bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
> 	/*
> 	 * bfa_itnim can be NULL if the port gets disconnected and the bfa
> @@ -326,8 +326,8 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
> 	 * if happens.
> 	 */
> 	cmnd->host_scribble =3D NULL;
> -	cmnd->SCp.ptr =3D (char *)&wq;
> -	cmnd->SCp.Status =3D 0;
> +	bfad_priv(cmnd)->wq =3D &wq;
> +	bfad_priv(cmnd)->status =3D 0;
> 	bfa_itnim =3D bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
> 	/*
> 	 * bfa_itnim can be NULL if the port gets disconnected and the bfa
> @@ -347,10 +347,9 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
> 			    FCP_TM_LUN_RESET, BFAD_LUN_RESET_TMO);
> 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
>=20
> -	wait_event(wq, test_bit(IO_DONE_BIT,
> -			(unsigned long *)&cmnd->SCp.Status));
> +	wait_event(wq, test_bit(IO_DONE_BIT, &bfad_priv(cmnd)->status));
>=20
> -	task_status =3D cmnd->SCp.Status >> 1;
> +	task_status =3D bfad_priv(cmnd)->status >> 1;
> 	if (task_status !=3D BFI_TSKIM_STS_OK) {
> 		BFA_LOG(KERN_ERR, bfad, bfa_log_level,
> 			"LUN reset failure, status: %d\n", task_status);
> @@ -381,16 +380,16 @@ bfad_im_reset_target_handler(struct scsi_cmnd *cmnd=
)
> 	spin_lock_irqsave(&bfad->bfad_lock, flags);
> 	itnim =3D bfad_get_itnim(im_port, starget->id);
> 	if (itnim) {
> -		cmnd->SCp.ptr =3D (char *)&wq;
> +		bfad_priv(cmnd)->wq =3D &wq;
> 		rc =3D bfad_im_target_reset_send(bfad, cmnd, itnim);
> 		if (rc =3D=3D BFA_STATUS_OK) {
> 			/* wait target reset to complete */
> 			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
> 			wait_event(wq, test_bit(IO_DONE_BIT,
> -					(unsigned long *)&cmnd->SCp.Status));
> +						&bfad_priv(cmnd)->status));
> 			spin_lock_irqsave(&bfad->bfad_lock, flags);
>=20
> -			task_status =3D cmnd->SCp.Status >> 1;
> +			task_status =3D bfad_priv(cmnd)->status >> 1;
> 			if (task_status !=3D BFI_TSKIM_STS_OK)
> 				BFA_LOG(KERN_ERR, bfad, bfa_log_level,
> 					"target reset failure,"
> @@ -797,6 +796,7 @@ struct scsi_host_template bfad_im_scsi_host_template =
=3D {
> 	.name =3D BFAD_DRIVER_NAME,
> 	.info =3D bfad_im_info,
> 	.queuecommand =3D bfad_im_queuecommand,
> +	.cmd_size =3D sizeof(struct bfad_cmd_priv),
> 	.eh_timed_out =3D fc_eh_timed_out,
> 	.eh_abort_handler =3D bfad_im_abort_handler,
> 	.eh_device_reset_handler =3D bfad_im_reset_lun_handler,
> @@ -819,6 +819,7 @@ struct scsi_host_template bfad_im_vport_template =3D =
{
> 	.name =3D BFAD_DRIVER_NAME,
> 	.info =3D bfad_im_info,
> 	.queuecommand =3D bfad_im_queuecommand,
> +	.cmd_size =3D sizeof(struct bfad_cmd_priv),
> 	.eh_timed_out =3D fc_eh_timed_out,
> 	.eh_abort_handler =3D bfad_im_abort_handler,
> 	.eh_device_reset_handler =3D bfad_im_reset_lun_handler,
> diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
> index 829345b514d1..c03b225ea1ba 100644
> --- a/drivers/scsi/bfa/bfad_im.h
> +++ b/drivers/scsi/bfa/bfad_im.h
> @@ -43,6 +43,22 @@ u32 bfad_im_supported_speeds(struct bfa_s *bfa);
>  */
> #define IO_DONE_BIT			0
>=20
> +/**
> + * struct bfad_cmd_priv - private data per SCSI command.
> + * @status: Lowest bit represents IO_DONE. The next seven bits hold a va=
lue of
> + * type enum bfi_tskim_status.
> + * @wq: Wait queue used to wait for completion of an operation.
> + */
> +struct bfad_cmd_priv {
> +	unsigned long status;
> +	wait_queue_head_t *wq;
> +};
> +
> +static inline struct bfad_cmd_priv *bfad_priv(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
> +
> struct bfad_itnim_data_s {
> 	struct bfad_itnim_s *itnim;
> };

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

