Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D2A7C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 01:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F016361104
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 01:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbhENB6S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 21:58:18 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:35879 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbhENB6S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 21:58:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1620957430; x=1652493430;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=zEJ1sQUU1wP3hH4/9GTHO/mZQw0o28J3XAtSdTpJMhs=;
  b=BNo9IlSk5I2DBWd8klCd5jwCEIuxeWtmsGAlwoOWagaawAKSx9U25K8x
   ClKi60XdyUpycZdIWnCL9z+Qpe+0QKix85bxgkhs5sk3KAvlWbCorC+VE
   QKpSVcjcl6OPX77fho0j4IPXX9yPQcbbW1Npg1cp+YOAIMdtBy1Z5ob/E
   BEEX/GQyQ42txnkZPMMyUSQBsMkyhbU0sv6jv+b4vuA4AMvZP52mvj31W
   ZRAy9VqNXBsFVvREt5rjUrI/2xS76YclkhrbNkdWrE1R7jf4gYRBtDlWN
   kUNnXciLJazbMQEoarvSGHpSCdxz9IYtPnJneU0z2MpztLh/cvcTjQVGa
   w==;
IronPort-SDR: g+zGb38FsynwgkUotcJ+Pkhf7f4tDiNJb7KCkdp1Cqqx63SEFwar6JXk7zlzIm96de2EPnO8mz
 xuKEyysk/9c/3+QKwQXcPN4OxGNOWyAKV71yKeXaEZLTE95XvK0GNNk3YJf0HGXCteN4kJZx4I
 GBMe0Ay66cZhdI/n/GiFTg+3LGjHe6eA6Vz73Kcz2zwethG0DL/IbOGklqWeLZgWmII1Z9OHeb
 ikZqdbF4HtmyMOb5F/12Qrnwor4fN6ngikmd+WOnpq/eYiKVN9Gt7EhwWGOAaKWTPZBUzBtubs
 UDE=
X-IronPort-AV: E=Sophos;i="5.82,298,1613404800"; 
   d="scan'208";a="272101042"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 14 May 2021 09:57:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7ucpOGcBedQJURtDVYDnouhV/UpxpxLCHKaXGQXSvLiKUXhGD0G2dURYKDgLkVOoP5GVFz/digLqzAhmfuZA/rxX36r2cVqAK1JwU4vfVgEea0JnJj0d8n9YXrBuWD6fWlODHR+Os/KydVQfB3u9LthML/41fjRPsoThd2ZvSX6vkmGrC+NCmQTJ29tGe3txRX4DLlnmIvAqAFcMfFqGFxI4a/0etsxIdkacYiUXmnGJeFFiMyzx6cOWuKkUsp6iOcc/Byj2BTb+8jx8k7d0mZAssjIzBc/By0kbK2hJRSbN7YDWQkblLyYprFzwti7lnXhMEYQAFfZeQDnz0GR3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jUpRUOwf3pqCGyMQC/lR3Bc7+IJ1w1T1ldJQmy8XxN8=;
 b=CssqaJjHBudsKemU2ufzVHRcmvY/87Se/8ijG0Xr3sQGqWXjWOOVz2Q/llePBLycYG+9IMwpYtBfdhuRe/HsMbBkrqaREJRxxDYV3EDMHhjW//uHBtKZF19yB3x8ki9AARgDTuEWthckFtIxuE8NREhZ8YQ+QJCuSN/U0RQoOAbSk1LEIa9kcW6QoSYPPwIHZvUO9e35R7ODmzQukOOpc+SUbjBGXZaAPDQ5jPCzTEAXJFbltXlX2VxyAT/5QyGlrXIAIa5qeSXz8gLHKOcZc+iRljgXrglWCKWvF8fWfjMx/iJhfTyjzSaN9oxIWlC7KTwrqnoXQhJUkHu3MKWI4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jUpRUOwf3pqCGyMQC/lR3Bc7+IJ1w1T1ldJQmy8XxN8=;
 b=MN65p/+JjkQ0tFGzp3darOj9HVb9B8KAdO+amW4bK9ieJy16oxRDd+M0UjrEnzWjvbEmHIHAmJS2N6X4QPMQCAAVnux92e/rzOJK7EvISLDW/kQj7FuK5SFuqsxCvMvXnoejfX2/ed+sDnf/0WX1ZH3f5lSBfZWRvMNUktUuZEQ=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM5PR04MB0813.namprd04.prod.outlook.com (2603:10b6:3:f9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 14 May
 2021 01:57:05 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4129.026; Fri, 14 May 2021
 01:57:05 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 1/8] core: Introduce scsi_get_sector()
Thread-Topic: [PATCH v3 1/8] core: Introduce scsi_get_sector()
Thread-Index: AQHXSEioBqfPd8Xb0kGZzDKNkVOtlQ==
Date:   Fri, 14 May 2021 01:57:05 +0000
Message-ID: <DM6PR04MB7081023AB631BF6F2013CC09E7509@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210513223757.3938-1-bvanassche@acm.org>
 <20210513223757.3938-2-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:38b4:55f3:e349:30b0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cac6c952-6e9d-4db8-c4cf-08d9167b9341
x-ms-traffictypediagnostic: DM5PR04MB0813:
x-microsoft-antispam-prvs: <DM5PR04MB0813E6AE3031ECA0C7F2218DE7509@DM5PR04MB0813.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u7U0RwocxoCn0EcsqbwDUGhIGeLs0flLZaG8wVm8qqvlfEAyGbw7RhG+B2WwFQF0a1agpZhkmaSWSkOMoBOS03DOi6bHgmIY19xcH5geb0H824QaRvamj7/qDwna/Cy27M8PAHgyrRw8SP4n4IhbviF840W51ku1f71sYmHNdSpeom2A8BcOer/C4dw2f05hHwYtyE+ApU2Pa0zynKM14R9n30prScNNnu+uPrS9mTd8BwIHtisOaGWirzrQ/k5PO19BWACrBO3U6mM6UaSTcd7R3ot8plaEa1ErjRt6MLBbYLc4pCUEtIcOvF514tDwNlPc2i2IripoonXrWFefOpyVHuPki19N/lO+iiAIpcXnRtnRcTnvpzE92ZUZDasbbxYf0VoaXdfUnYlzlnkx9w0nxU90Dr53D9R/ejutYpU0nW1FZvnwBMm+1JfyxNJDKwF52Uz7rHZfFt91LXaH6PzlJm6XBkNhdAe+TOeJ0IqOTsssvBtKaRjMEG6AjilN1mDro4v0qYe22Ud4Ba/aoao896RvmhUwycUU2vLAIryP7bBR2GWNmy4OP1iNko1M8jIO/PNw8wpIdtC49A3DVbc0ci4+eagOJ9GTMgcqeME=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(9686003)(33656002)(83380400001)(55016002)(4326008)(71200400001)(478600001)(2906002)(53546011)(38100700002)(122000001)(8936002)(186003)(66476007)(64756008)(316002)(8676002)(91956017)(86362001)(110136005)(6506007)(54906003)(5660300002)(66946007)(76116006)(66446008)(52536014)(7696005)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Za2BwrkLCpu0tPh6brHT2UQP4KpBYoSDUZqfszIzmPyj1F99SUustR7+vbUF?=
 =?us-ascii?Q?99IsGpGXdxoiDUxmtHY6lOj3Jt3AzV1kVHZdWJPPBbJ0cOUDBvK2wRr1IjxI?=
 =?us-ascii?Q?ivg5spy16hCPXOr6rOTQPcfCyMCb+KYd0MQb022PfWHw4wIWocU2LvJs72jZ?=
 =?us-ascii?Q?T5BAEz+7/RvwIbB+UvhkUfHo7l2qrL8rNYBXuJjxS4vhX3PwiRqjwnIp7gsw?=
 =?us-ascii?Q?gf4hComtQapzrdZ0hDnfzWUb15pF/j10Llkoh50JUcOzZEner0EshPBbenst?=
 =?us-ascii?Q?jKNdopfSg7FeJMGGuzt9rjGZ1VWCO8dHvBn3y6/9vELOFaQSo/fpxKLdh3ld?=
 =?us-ascii?Q?0kgyyvazQCLXgQf5lBrF7mhDANDVY4wTt23dA7qKxqylzhhybsaSUSgEdq+A?=
 =?us-ascii?Q?WmdVpx8kwqfYs/YEDVE6pGw4BgKvRwlOQjAYyhpW7C6GIspVVawnfYhq4cHB?=
 =?us-ascii?Q?bB6ucfCX1SKuYI1MFcSPPxuyGEZtrUgcoqNYjpJLpUScR8KoFMtpU3LB6MIj?=
 =?us-ascii?Q?QKimBFTMM26Q6txS8DpMeWQvjJ+6jybrklQflvq4297nhbAWfzkueZF23bxx?=
 =?us-ascii?Q?T3FcdV89LQ2h4IDrry9SWNc1selCy/W6w78zpNMVTi4GRIzS8AMLEfEZ/+1u?=
 =?us-ascii?Q?mU1Iq2uRPYiRBLanom7/U7Y43osYnvwL6Fy3e39EZIGwDT0MneWowuxXIo7t?=
 =?us-ascii?Q?O8Qdjr/HvVhZJkABhMO6mh4PWYi91X3x7TPQU+t8cw7Ck8luBCahZVtECXB2?=
 =?us-ascii?Q?GMBOpWYc3Jk+91RUOvq5L92RY0bjAEKs+Sx3cxiR/mdFPqSOgxZRlySnrktH?=
 =?us-ascii?Q?b4rxArbFQ9GozvDCRuqg6WnUqy7lZRksuCxM7lnVKF04TFY4sMqoBLaRZ9cT?=
 =?us-ascii?Q?lAu8egwuc7AePswtbvmZEC4QzX0h1cr3c1TJsfuuGaBMiL3Ccgtp+WrgmX1O?=
 =?us-ascii?Q?qWrr9eEbfzcVcPC0hWZf8btBQgi5VHeQMHlveaAfHOnVyO2Uet1+PlKf18CV?=
 =?us-ascii?Q?NyfJsuAOTQFhQc5y663oO+pXCBYxr/NJeIiDStCH7y9/pRy5cKbugq68PJr8?=
 =?us-ascii?Q?k8bEoDQzTWWVYoL0UZ7hYcIXVwycuh5PPLpF8CLhnKPEz32DbJ267g+r4t6E?=
 =?us-ascii?Q?LDDWUvhOoWFpzKMNE3MYNa178zNDkHLYzqPKY2m4EwLxXyYvd/jN+OhSYpFj?=
 =?us-ascii?Q?Eu/NEogwnLJ+xxIYdQlgwZhpYU2IEDN9oydW7l/qS3tljE+FIA2xrNkl9VYm?=
 =?us-ascii?Q?cfA5ZPG3oKSXZ8o3bYUL62Z4NBWudffwvPV+Vd1vA9JKQxAdXL9Zp3RCntL7?=
 =?us-ascii?Q?IOLGLhpFHUYdeKRwSCxQ7rexN9HwsNRb0aAoJIeX4xUdC2NUF5GsYcKcPN7n?=
 =?us-ascii?Q?CLssRw1lf6AkQSCb35E8gSZ4ikWaIKModTdzm5/691f6/FouIA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cac6c952-6e9d-4db8-c4cf-08d9167b9341
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 01:57:05.5178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +yukPNYu6Ufy5hFiyC2pm5wSSXd5a09cLE0NdXLVrW4RMo3Wsk52SRuKJNCsJSGkb+jb/OAkx9EiojQfNb9mJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0813
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/05/14 7:38, Bart Van Assche wrote:=0A=
> Since scsi_get_lba() returns a sector_t value instead of the LBA, the nam=
e=0A=
> of that function is confusing. Introduce an identical function=0A=
> scsi_get_sector(). A later patch will remove scsi_get_lba().=0A=
> =0A=
> Cc: Christoph Hellwig <hch@lst.de>=0A=
> Cc: Ming Lei <ming.lei@redhat.com>=0A=
> Cc: Hannes Reinecke <hare@suse.de>=0A=
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>=0A=
> ---=0A=
>  include/scsi/scsi_cmnd.h | 5 +++++=0A=
>  1 file changed, 5 insertions(+)=0A=
> =0A=
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h=0A=
> index bc5535b269c5..7f55faa70301 100644=0A=
> --- a/include/scsi/scsi_cmnd.h=0A=
> +++ b/include/scsi/scsi_cmnd.h=0A=
> @@ -289,6 +289,11 @@ static inline sector_t scsi_get_lba(struct scsi_cmnd=
 *scmd)=0A=
>  	return blk_rq_pos(scmd->request);=0A=
>  }=0A=
>  =0A=
> +static inline sector_t scsi_get_sector(struct scsi_cmnd *scmd)=0A=
> +{=0A=
> +	return blk_rq_pos(scmd->request);=0A=
> +}=0A=
> +=0A=
>  static inline unsigned int scsi_prot_interval(struct scsi_cmnd *scmd)=0A=
>  {=0A=
>  	return scmd->device->sector_size;=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
