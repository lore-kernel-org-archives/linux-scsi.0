Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91990C433FF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 18:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FF72206C2
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 18:00:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="b6XHbPnC";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="QZWk1VqP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfHLSAZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 14:00:25 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:16839 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbfHLSAZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 14:00:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565632825; x=1597168825;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=/lS/qKtCo63AiHHtzKp9qRIK2jbP/snX1++4B7Em8ps=;
  b=b6XHbPnCkj9eWdVE6p1kOVNke7eBmqTs9dxf9JdbKoXjV+k8nA+QWUNQ
   FHuoZpXO/Q8/NrFpDx96smJeg29u24NN6mj/RYr8raP+zXa5yk/6zxpRn
   bLPq9uqQKqD5NzTZ+8NRNKwk49qPZgeip2ARtbBk5dSItSV3KNB1b5Cg5
   O4AJ2/CS9AkBCsScHGR3AL4U8s0bYN4DyhO4Ky8BLXuL1gP31sCHqDCk8
   caxqVDJkjgy2K3W8kTJzcOH02Iec2mRLtadRTJs5fYqjx3ncdwgADutTq
   7eDUJluckttGbqLJuNoZ9y1Y1T4fE6/7JFkbLn58UalkJmzVRrYXcePKN
   Q==;
IronPort-SDR: ZR9i/RpeqnycmDgxdn3MkghW2mX79+VlvOtZDM5g3bLzo9hxxxzjwUThcdHJ9PiqGsiw5mGrP5
 RXg+/PX1E16yc0H2pUI1XIH2CM0VBLdjte2yD34IGZG+rF4qlRPwuqSgoOxwRDRMDsYiD2FqqE
 5MqIaSJm6SIqpdeXz0KRESzCf+C8wQJKb8KYn64dSZI8pySP1Pu9r3KaSsLA7kUTSc8qCNDv/x
 OdxAab4NZ+sPLiqIVVtrH05q+ZsihAQm9W8FRmbqjhzpzbMA0MRyWX6x4pvtPnXen8nhZtO1xL
 SHI=
X-IronPort-AV: E=Sophos;i="5.64,378,1559491200"; 
   d="scan'208";a="117262144"
Received: from mail-co1nam03lp2055.outbound.protection.outlook.com (HELO NAM03-CO1-obe.outbound.protection.outlook.com) ([104.47.40.55])
  by ob1.hgst.iphmx.com with ESMTP; 13 Aug 2019 02:00:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epZ6lUOiLh1o2nsaLN4EC2qvKIsK5O91XO8x8XBhzNo5eMiCaeD2GBXNWro6qbIw6/UOiJPAAVBdYGR+G9+NHms6VZ56Up1Qtb9dJPcG4FxSOS8TluE7ur6T4tKcZXwtHJHviTAwahGYXNVtq/1Ck4rTQ6a9lWu3hDJ5ueNcLL9IvKYXnjwQcprLX4c4Zc3ujWtMYIZUIn2YR08QBsls82CXvaSXcYlIc0iXKveF0PgUQ8a2MZLeSoJ4qjtRmAWTePcQ/S06ctlIVD54twMOrV0dkuxZWePakIeQ5mycyz+kpgwKAfrM9oNDCFMa/SV/1DrNDz5JhBZNuFK1bFtgbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8m2ifUliA4OBqrjDM/H1Aag76HJDGRwkA2iHRlawRYU=;
 b=FHYlFce5cU8yiPAaLg+USpctqZZ150Ae8u1hj+WrXtk5/boqjiOCDHh18yh6svjXiFS//0yzw25dO6DShPKtoH7nSMbwGok1JUaiHrDCTLiNeBFjLHNTRYxbXNhHqKlkqgrIHcfH5jMIUMKpVuekBtOVWNgvcWAHNAnaVVbK2zepMU529Z9aLNP267tnGckfIiSx9CZ4u4l9zE5v8OYdJSwoXDg/3tzeA3u0ouWjEJUr2384A5bEzPSahfK/f5muNqjWtUemzHMlzQOrTRZB5byKEshkjjbWdWapTwi+bqarwdchcLwNpbPt+77nKoRTOYYRKRpM5IXRKtnuZBAelQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8m2ifUliA4OBqrjDM/H1Aag76HJDGRwkA2iHRlawRYU=;
 b=QZWk1VqPY6v4ZhPdBESBFT1/U90D0/c4/OCnjlUk96B4fTPikcrC+l3yb9IOsmxcX6At1zfrGM0CBNAfPaor8La5Unw5FZYINTDPdS6d2x3VHmqqh6uZzPtNJUKnKGgukzH+vsGSC5LWpTexNaOCHjOSkPEChjJaq2rk+Zk0sfU=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.58.207) by
 BYAPR04MB4712.namprd04.prod.outlook.com (52.135.240.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Mon, 12 Aug 2019 18:00:22 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::a538:afd0:d62a:55bc]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::a538:afd0:d62a:55bc%7]) with mapi id 15.20.2157.020; Mon, 12 Aug 2019
 18:00:22 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        Mike Christie <mchristi@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] tcmu: avoid use-after-free after command timeout
Thread-Topic: [PATCH v2] tcmu: avoid use-after-free after command timeout
Thread-Index: AQHVUHIgO5axZ6IT/ESs5nhTjFMRQw==
Date:   Mon, 12 Aug 2019 18:00:22 +0000
Message-ID: <BYAPR04MB5816B8BFAE68F477F5A0C8D3E7D30@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190811182510.1706-1-dmitry.fomichev@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.44.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b249963a-013f-4ad3-3e04-08d71f4ef24b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB4712;
x-ms-traffictypediagnostic: BYAPR04MB4712:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB47129802DF4487F7E736086AE7D30@BYAPR04MB4712.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 012792EC17
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(199004)(189003)(186003)(2501003)(229853002)(5660300002)(446003)(256004)(26005)(14444005)(6436002)(25786009)(55016002)(9686003)(8936002)(86362001)(33656002)(6506007)(71190400001)(71200400001)(53546011)(76176011)(102836004)(53936002)(6246003)(7696005)(66446008)(66556008)(64756008)(66946007)(66476007)(316002)(66066001)(74316002)(305945005)(76116006)(8676002)(478600001)(7736002)(14454004)(81166006)(81156014)(476003)(2906002)(486006)(3846002)(99286004)(52536014)(6116002)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4712;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xOhyLvdGQJctuKtIVQrraMvxUu8oVsExG2gGTmvR8NikEp7O3ECbUXOT54QwSmN52uN7zJFhJcGwzGRqDBjZssASwPKRIxYzAVJmgLPKSBPuGkdkUzbKV+muJiVCHrHme0WvjvmQ+ZtmTwsQNeEaNjpnwVEaQ1aykER9ASN9Niz1zOk4LhGojyU7iWSaVE8E9vLGZlhYzuQAKOF85gd6iAUwflBV7luQw4KKaKaZ29oVUwezBFNrO6N8wOAW2Dj3bkhHqs1aDBnJJWS7Lx1Q5TscQWxZjUni/GKAaGXfpMtv9iLVzPFukpGuhMw8qpk3pGzQQLMtUY0y5weVeT78e1RXhhr/uYc6XT1LdgQUILebGQFE0kAuO245nj/6qZdNKOQUB7Ie9TZO2Rn6pZZB5Q6oT/tosEUG2f778cEgKBo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b249963a-013f-4ad3-3e04-08d71f4ef24b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2019 18:00:22.8512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hyx1RSOv90H9FngNBTXvd4/EmBhnd0vMprnJOLSnUABKlDmmqAwSKTKgeYAJPkji+jxJ+kVGHsnBxYo4ho9vmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4712
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/08/11 11:25, Dmitry Fomichev wrote:=0A=
> In tcmu_handle_completion() function, the variable called read_len is=0A=
> always initialized with a value taken from se_cmd structure. If this=0A=
> function is called to complete an expired (timed out) out command, the=0A=
> session command pointed by se_cmd is likely to be already deallocated by=
=0A=
> the target core at that moment. As the result, this access triggers a=0A=
> use-after-free warning from KASAN.=0A=
> =0A=
> This patch fixes the code not to touch se_cmd when completing timed out=
=0A=
> TCMU commands. It also resets the pointer to se_cmd at the time when the=
=0A=
> TCMU_CMD_BIT_EXPIRED flag is set because it is going to become invalid=0A=
> after calling target_complete_cmd() later in the same function,=0A=
> tcmu_check_expired_cmd().=0A=
> =0A=
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>=0A=
> ---=0A=
>  drivers/target/target_core_user.c | 9 +++++++--=0A=
>  1 file changed, 7 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_co=
re_user.c=0A=
> index 04eda111920e..661bb9358364 100644=0A=
> --- a/drivers/target/target_core_user.c=0A=
> +++ b/drivers/target/target_core_user.c=0A=
> @@ -1132,14 +1132,16 @@ static void tcmu_handle_completion(struct tcmu_cm=
d *cmd, struct tcmu_cmd_entry *=0A=
>  	struct se_cmd *se_cmd =3D cmd->se_cmd;=0A=
>  	struct tcmu_dev *udev =3D cmd->tcmu_dev;=0A=
>  	bool read_len_valid =3D false;=0A=
> -	uint32_t read_len =3D se_cmd->data_length;=0A=
> +	uint32_t read_len;=0A=
>  =0A=
>  	/*=0A=
>  	 * cmd has been completed already from timeout, just reclaim=0A=
>  	 * data area space and free cmd=0A=
>  	 */=0A=
> -	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags))=0A=
> +	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {=0A=
> +		WARN_ON_ONCE(se_cmd);=0A=
>  		goto out;=0A=
> +	}=0A=
>  =0A=
>  	list_del_init(&cmd->queue_entry);=0A=
>  =0A=
> @@ -1152,6 +1154,7 @@ static void tcmu_handle_completion(struct tcmu_cmd =
*cmd, struct tcmu_cmd_entry *=0A=
>  		goto done;=0A=
>  	}=0A=
>  =0A=
> +	read_len =3D se_cmd->data_length;=0A=
>  	if (se_cmd->data_direction =3D=3D DMA_FROM_DEVICE &&=0A=
>  	    (entry->hdr.uflags & TCMU_UFLAG_READ_LEN) && entry->rsp.read_len) {=
=0A=
>  		read_len_valid =3D true;=0A=
> @@ -1307,6 +1310,7 @@ static int tcmu_check_expired_cmd(int id, void *p, =
void *data)=0A=
>  		 */=0A=
>  		scsi_status =3D SAM_STAT_CHECK_CONDITION;=0A=
>  		list_del_init(&cmd->queue_entry);=0A=
> +		cmd->se_cmd =3D NULL;=0A=
>  	} else {=0A=
>  		list_del_init(&cmd->queue_entry);=0A=
>  		idr_remove(&udev->commands, id);=0A=
> @@ -2022,6 +2026,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, =
u8 err_level)=0A=
>  =0A=
>  		idr_remove(&udev->commands, i);=0A=
>  		if (!test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {=0A=
> +			WARN_ON(!cmd->se_cmd);=0A=
=0A=
May be WARN_ON_ONCE() similarly to the previous one ? No strong opinion abo=
ut it=0A=
though.=0A=
=0A=
>  			list_del_init(&cmd->queue_entry);=0A=
>  			if (err_level =3D=3D 1) {=0A=
>  				/*=0A=
> =0A=
=0A=
Apart from the optional nit above:=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
