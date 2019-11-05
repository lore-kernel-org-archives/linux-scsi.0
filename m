Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3D8C010A2
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 11:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3E0621D71
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 11:59:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="MAnMWtsj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730880AbfKEL7Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 06:59:25 -0500
Received: from mail-eopbgr680068.outbound.protection.outlook.com ([40.107.68.68]:58733
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730852AbfKEL7Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 5 Nov 2019 06:59:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SD/4SKUC7c5bnvDbR/JFQKWd9ZIaJ0ybNY429zsOFAijeKdG5y5vDzD6Cd3Sbro4pevK26jSXQNLfvkMPi5/8gxvtrUZyWbSgaHLAJ2mvArD8V2ESuMOezZUbv0aMpAq0uxpbAT+N/OYmx7XgIR2dFb4bB6zqSyDT0JtAp6ibQb3MWQTv2wx3cMtc9sa9t1Zxvb+OAJUo8jgHS/nqsr4aks5bHVHEUTCLvCPmTOupkVq0AtWQ8QD5JE/PjALd0xiO2tN/tFyHMsoOIaTQe8EaDs+QM+Y5p1wD3N+r5OuSsP/ZelOqlzITk9tXC9YcssUwcfEFrwuOtLaRBwPF3dWjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+Ilo+jdGTnOpGPC697uwjPm8HfUTFISStZr2Rqf408=;
 b=B7C8QlUQyJH0TofgjkaXPp7ClGsInrNhtUR+xdsFwzRiqSMCCjvkxax1nPYMYfmSe1p+0dBeOId63xufVwbbsYlJxQdkg7SvdNrKQS6BLXGFpaGrrZko8Rtt+tUsfvhFiVid3jGHsHYfi9T0XVpZKIqkPjqrEkDxG9z2cUFzhR6Ym2w3El2XPdPgdtqKB3IU9WqurM8jIVuGwJWEdUfLmttrjVx8iBRCZD/rsdcaQkyGeoBSgBsv8dWdzI/N3u82ngK+2G8JwKROn1WeL2ZWkO9UZD8XdmwBP9tQnLr1Z2vsH+vYrsZ7CEjL1Cnuc+QMkajlkUZcTjCSpwMxTCNpDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+Ilo+jdGTnOpGPC697uwjPm8HfUTFISStZr2Rqf408=;
 b=MAnMWtsj6bkRSio2XK1MAytHaR6txD9lXu23g0rfawUWv5QKPazHPP/3X75+FOUzqgvLdCWrv6z3PlfyMYy3HCzWMzm5WR/wmPgYGVp655NNuLTaIdRe5FJNLwOCHnQ2waW29iCgXthDLrRxrH4Uuv6qzWw/X5F8SnMuIW0rirk=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5172.namprd08.prod.outlook.com (20.176.177.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 11:58:42 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 11:58:42 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: RE: [EXT] [PATCH RFC v2 2/5] ufs: Use reserved tags for TMFs
Thread-Topic: [EXT] [PATCH RFC v2 2/5] ufs: Use reserved tags for TMFs
Thread-Index: AQHVk3Hu+vKK5UpByE6NhmIiHnKyoqd8eXOQ
Date:   Tue, 5 Nov 2019 11:58:42 +0000
Message-ID: <BN7PR08MB56849F96E16115321F44F257DB7E0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20191105004226.232635-1-bvanassche@acm.org>
 <20191105004226.232635-3-bvanassche@acm.org>
In-Reply-To: <20191105004226.232635-3-bvanassche@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTlhNGNlNTE2LWZmYzMtMTFlOS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw5YTRjZTUxOC1mZmMzLTExZTktOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjMwMjkiIHQ9IjEzMjE3NDI4NzE5NDI4NjcxNSIgaD0iRnhjNWNKY3U5czNGRis2RUVqUXBsemZjcTA0PSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f6ee9b9-eba4-48be-1c9c-08d761e78120
x-ms-traffictypediagnostic: BN7PR08MB5172:|BN7PR08MB5172:|BN7PR08MB5172:
x-microsoft-antispam-prvs: <BN7PR08MB5172D0A28093B016BE8CCB5CDB7E0@BN7PR08MB5172.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(366004)(346002)(189003)(199004)(478600001)(71190400001)(305945005)(3846002)(25786009)(6116002)(66446008)(110136005)(71200400001)(64756008)(76116006)(66556008)(256004)(14444005)(99286004)(66946007)(52536014)(86362001)(54906003)(66066001)(6246003)(4326008)(7416002)(55016002)(9686003)(6436002)(55236004)(7696005)(102836004)(76176011)(7736002)(316002)(66476007)(11346002)(446003)(5660300002)(26005)(14454004)(476003)(486006)(8936002)(8676002)(33656002)(81166006)(81156014)(6506007)(2906002)(186003)(74316002)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5172;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oq/wcBDG69V77XZA7ADCjCEz73ZLD27zOHfsEBnuGd3j+iw7HK6BQ51A2N5i7SPk+7VazgFj/Pr7cK1axhRQWL5+rvsrbbZsbt9IY3mLb5HAPphgcdZ0JlSOcVIOsjlqGd/9+7PrBn6aaSaIZm2vq386sV15MQzs6U9kJvQVnjtCF1x+baZsK13fhbZGWvO1mtV7R486Ms9d6+9AgDA5L1l/77DVPvAHfl2hZa3p/l/aFiUFsAlfb3rCJ57rt33QDv+N9DK9gHYehsiWbHNED5BZcsZtzA76hRHUu+R0+oFakxUPoj6VporQ40eksbPKkSpXhUjlBPct4T0rq3BwCr9/nV2gjguo0eeqhdgH7hGl/Xc/z4yC5DXGA3m8i7grTaQEHd8tuBVvKZTQu2gsoAzn+bl7zo8mzRGN9NyQxULElApaWPv0+kQs/0NJhW0K
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f6ee9b9-eba4-48be-1c9c-08d761e78120
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 11:58:42.6250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: arE2EwnwLQm7kvJsVknaYjqb2BdSUPntVGt3vKsxo59YTnLYuFqM5QK2jNuucIpeTVPLKszI7XjdqKaALD91Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5172
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Bart

>=20
> Reserved tags are numerically lower than non-reserved tags. Compensate th=
e
> change caused by reserving tags by subtracting the number of reserved tag=
s
> from the tag number assigned by the block layer.
>=20
> Cc: Yaniv Gardi <ygardi@codeaurora.org>
> Cc: Subhash Jadavani <subhashj@codeaurora.org>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 9fc05a535624..3e3c6257a343 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2402,7 +2402,7 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>=20
>  	hba =3D shost_priv(host);
>=20
> -	tag =3D cmd->request->tag;
> +	tag =3D cmd->request->tag - hba->nutmrs;
>  	if (!ufshcd_valid_tag(hba, tag)) {
>  		dev_err(hba->dev,
>  			"%s: invalid command tag %d: cmd=3D0x%p, cmd-
> >request=3D0x%p", @@ -5965,7 +5965,8 @@ static int
> ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
>=20
>  	host =3D cmd->device->host;
>  	hba =3D shost_priv(host);
> -	tag =3D cmd->request->tag;
> +	tag =3D cmd->request->tag - hba->nutmrs;
> +	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));

Changing request tag number here is not proper way, we have trace tool usin=
g this tag to track request from block,
SCSI to UFS layer. If tags being changed in UFS driver, there will be a con=
fusion.=20

>=20
>  	lrbp =3D &hba->lrb[tag];
>  	err =3D ufshcd_issue_tm_cmd(hba, lrbp->lun, 0, UFS_LOGICAL_RESET,
> &resp); @@ -6036,7 +6037,7 @@ static int ufshcd_abort(struct scsi_cmnd *c=
md)
>=20
>  	host =3D cmd->device->host;
>  	hba =3D shost_priv(host);
> -	tag =3D cmd->request->tag;
> +	tag =3D cmd->request->tag - hba->nutmrs;
>  	lrbp =3D &hba->lrb[tag];
>  	if (!ufshcd_valid_tag(hba, tag)) {
>  		dev_err(hba->dev,
> @@ -8320,7 +8321,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem
> *mmio_base, unsigned int irq)
>  	/* Configure LRB */
>  	ufshcd_host_memory_configure(hba);
>=20
> -	host->can_queue =3D hba->nutrs;
> +	host->can_queue =3D hba->nutrs + hba->nutmrs;
> +	host->reserved_tags =3D hba->nutmrs;


hba->nutmrs is for task management, relevant door-bell register is bit0-bit=
7 validate.=20
If my understanding is correct, UFS task management requests normally issue=
d by UFS layer, rather than upper layers.=20
Before issuing task management request, UFS driver layer will apply a free =
slot, see ufshcd_get_tm_free_slot().
I don't think it is necessary to change host->can_queue size by adding task=
 management depth hba->nutmrs.

>  	host->cmd_per_lun =3D hba->nutrs;
>  	host->max_id =3D UFSHCD_MAX_ID;
>  	host->max_lun =3D UFS_MAX_LUNS;
> --
> 2.24.0.rc1.363.gb1bccd3e3d-goog
=20
//Bean
