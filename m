Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE18C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 21:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24BF32313E
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 21:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbhAOV7c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jan 2021 16:59:32 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:42383 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbhAOV7b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2021 16:59:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610747969; x=1642283969;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WZu9fHKUVrFyfVUXGFqrCxMGXtM7DuPDcPkELs1uhfA=;
  b=BTIziuKcoR6VXZErSVLUfM2eq9BTmcjgQ8ETF2i6bvacWfHPpeH296FZ
   jcOhIFDn/kMEYf755nbYRwLAL9gPcZ4mdCFITWvyM8aY/liJUrzZgowwD
   6jVe5kfWDe8xzrOqlGum4woZ/myho/A3r97RrSi1bjPi/NMzFtkc+XJmY
   oLq1Ic7No500C6gLP1oxJ7hgU1T7wzpuUT26vKCKE60WyKBcIQn+m1/CU
   aC4kd7FKHWSszxfxYXzfeJQidPXXRixUNd9dY8N5WNH5Q9nES2O021Z/A
   YEvgUCUsmHQ3pXk8Rgcg12SDC25XYwDtQ+jtTFACag25D9YThQcx6mQCl
   w==;
IronPort-SDR: Gc7WrB8eCfiRbNapH0cS6p6wVbLkMxQhlEW0jdcZ+JvIhms2X9CkVD3nmzJkwDZXCW955arDRe
 4cu1/54xEj5fJ0M2t/CGlVJj0WS66szfQvTiCvyTTy8Ogm2mZQ5rlnKnAsBdudrymZSuSbOPxr
 eWTpQGZN4dZyGyV+6Ev9pjxeLpEaUWoIEnyYCC1Y25XXJeevtypE3WdQ9JQR4ruQw7qVSIkXr3
 X3N0ssLiNm4bY6COe+UES5f27SA2AWad8rHZczVMWDvWeTtUhmXjQLjXNuqWSnqpT9JbXTJRyR
 C9M=
X-IronPort-AV: E=Sophos;i="5.79,350,1602572400"; 
   d="scan'208";a="106148774"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jan 2021 14:58:13 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 15 Jan 2021 14:58:13 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Fri, 15 Jan 2021 14:58:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XFK7BlH814V+qS3+YKaA6Kzq/fzNX/r9R/Dj4poz1yeTm9LsvdKAKI1647kOp24eZgvF3doQqd+NupS3HiGkihqs+B+MWl6elcPUdE1HxPA9ZUltfXKhHb2o+nk3yzY/h5kf1Pi4i+eONnEw1caBvc8Av8in/yXFhBGvWTz5fYnH9hQf8lt1kEGFFQOGl3im/A4AS09/FUQCbuR2ONR1FOS67s4tE7QeprjnkY436RmzYGNmy2qI42ZKk4ZwnvXxKHvnwnzO3rTddXitsP8Z4DZpyK5nUKS+J4rI2rKzv3HZMcUPAT09MtAIF/UkRMQmR6PVAtKykngfp3Y+F9AmlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34IBtQ19/sUj80vrgGOUFjUH7fQ1AJf7fO7nfBxvT0k=;
 b=eSGB8sXSs75jm6nLNQTsgw7+/z/WZMYQP8xaXHSawJi1Q92WSuV6iP8sv04+ctDuQJRyA+AFIxCg6/0t+02xH78KwVAcYDQUQB+0xMNb8AzBVuAc479o67M3yYs2rJ/fjTkPLOhiiRHBjCxOkUCLpGBdVPhGYIaSRG7eCth7wLT+XGpLF+nBZ5yJpPdOb+/x/VkMvj9pTbdVpCIHaCtKwlN0Umcxt+cwQV4KUNFBnnLI/D841BACwow0A044yzjJoLC4GQfZ2qlCSluIHLdVLDXdN1tIbkiPChwzJ5JKgBAbAyzNPVFbiT6k+6uGh5jI39bA7d0vB59nMfH1/ACi3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34IBtQ19/sUj80vrgGOUFjUH7fQ1AJf7fO7nfBxvT0k=;
 b=o44N3zsVQx6/qbJ2yXB7v7zTZUMP5pA7m7EzaLQrSQnzP45DNMkxp2yL4uF+L/mqETt5a6gJdLRdxSmvdnJ8+Pz+ZQmUQmUWroMPKYl/pEDV+gpVSqMlBNq+K+fv48bXO/n6jVnZt8yrIgGhgfFwfROr3D1PznQY2WD8WLVAvTE=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA0PR11MB4608.namprd11.prod.outlook.com (2603:10b6:806:94::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Fri, 15 Jan
 2021 21:58:12 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3763.010; Fri, 15 Jan 2021
 21:58:12 +0000
From:   <Don.Brace@microchip.com>
To:     <mwilck@suse.com>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH V3 10/25] smartpqi: add stream detection
Thread-Topic: [PATCH V3 10/25] smartpqi: add stream detection
Thread-Index: AQHWzzSOKn4QrDsgQku1LXlhmHAIXaodB+8AgAeahqA=
Date:   Fri, 15 Jan 2021 21:58:12 +0000
Message-ID: <SN6PR11MB2848CADB704B64E66413637BE1A70@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763251860.26927.14463337801880165741.stgit@brunhilda>
 <8912abe0d7b0b39bfe2efff16db58ec888a8d6d6.camel@suse.com>
In-Reply-To: <8912abe0d7b0b39bfe2efff16db58ec888a8d6d6.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e47ada3-d093-4f44-3c96-08d8b9a0a747
x-ms-traffictypediagnostic: SA0PR11MB4608:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB46088875D28A405F5134BE9EE1A70@SA0PR11MB4608.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QwujIqRXDGzKFdhmoR/0QhZOwm/F6fL5/JLEQ4LlaT02QHvt77CUa8/ibXT2DBzTfsDkVNTKUHImsqmW8bS+YjmMppZVJo5f4KmPjBUx9LTS8nYm4nh+KmaNPKD5hiInuWsLKqFN1i5wRmBrOk+HRAe7hq5A50QgUfEPZr9UIz5c2ojkTCJNHFLrhR0cmRkBmxywKs4UYGnddYWahcvA7slfVNV1FQopyyOTgncJcwVBbWFEK1/6fm6e72mvC66jET9i2B/xn1RveGFF7lYpS4jYSO+Po1A3o3jJBXY8Klc+w6HYD7FKYSzWTUhjEC1D3bjf+IjRummycGQYxzC4Qie7Cs3010JNbIy4y6wskKmmgK2T45pahmRC4kM4hCCQU/IxXS5YSabd1yeYl0Wg9770yvCBaeLL2g5wtyObo7RJUK41Qg/u1ZLQ31EeClaC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(39860400002)(136003)(346002)(6506007)(53546011)(83380400001)(4326008)(8676002)(26005)(110136005)(5660300002)(33656002)(186003)(4001150100001)(7696005)(2906002)(86362001)(64756008)(66446008)(76116006)(66476007)(66946007)(9686003)(55016002)(66556008)(478600001)(8936002)(71200400001)(316002)(921005)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?XkreVgVjGjrOecj3Uis+h6CQa6aF77TKt/xlFhDGNR4YQtzdCurUuVSIbZ5b?=
 =?us-ascii?Q?uEPNUyDND2bDZLXdtIhjHq6CsqiaDsd1rykqdMVGHZzqUqemVZ66UfFLTqFa?=
 =?us-ascii?Q?BlZR/e6I8ZHWIo4c2LNEen7MpNPGJXd+MHycaERdK8UU2hYdTkIUETVILbrB?=
 =?us-ascii?Q?5ynd5OycDg2uvPf35MA5mbKpkFfYAuFVHj30GhGuxm+akdlfh/hP7hX5ld+B?=
 =?us-ascii?Q?1pzyXaq9VGQ9DGoVlNaimgxUPDI/RGzoW/NhhdGVQDbAesJvyb4hBYJdxPLp?=
 =?us-ascii?Q?x4zEapT7uIXktCZe5td9st6GEeNB+PgRQqxiLwuBSG4i3fb0/dWn6BjzrSiD?=
 =?us-ascii?Q?Lt5QwEvevLovH9y3ciVdwqaT+dRd7XD6pUdPyL3cNUM81StOSqcienil/zEw?=
 =?us-ascii?Q?rSzSzEuo8sh2AM6vQisEIXLXi5pQoBU+guc2BL6/T4PhI1WvfjjMvq6+X5JN?=
 =?us-ascii?Q?Sra5COHMTAmXuMRmGcRomvvu82c3EDTryHORWsWrmuBF+bP/alXvjipivqjJ?=
 =?us-ascii?Q?5sQIxZW22dNoynojH+FZ1+GS98sHjlHyAkb/mG055y7z0XClfH1oOdIS0wu5?=
 =?us-ascii?Q?Xh0SvfOqQUB9PHvUFyKWHdG7IFTyAvaHxD7Pn/f7GLmXJMuGjemEnZfuai7l?=
 =?us-ascii?Q?woySd9VssLloVvaoqNVdnGh7nd9WQGgIhZM2Q1iGD0Qv48JlYTixk1A61MlC?=
 =?us-ascii?Q?W7UMFyxG0ojirTNHxalmyuKEG9baLMqX2HFjMtu6tjKFBtJ1hQtybZQZ7Bq8?=
 =?us-ascii?Q?KfEn1Uc1s4oiFHvvRGZlbl68aolMxN9vIkSMER6oZ8MbzksZ6QNCNzWZk6t5?=
 =?us-ascii?Q?uwivltfKBzs4xrQ0t+UsxSAvJf9uDRaY3bvEbQwzUzgPNPlTaCTZ/7Tuigzo?=
 =?us-ascii?Q?785zls8n3RDrj+BFb11ccE9UEVd2eZzIAZ58v1BxKnoNA/0GlMhFvl+xq25c?=
 =?us-ascii?Q?B6EfxvmJoOw6hcpfvdVmhMfxMUiJIbYqMBlMtuX+Izs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e47ada3-d093-4f44-3c96-08d8b9a0a747
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2021 21:58:12.3325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ccj9/W5L1FobOuNp9gaV7GTKgB57eMyA6dQp6JBaTtYk0lDCb4uVzKFjYHFL7eryjpZtfVrxgcj+BWCLWfg5Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4608
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Martin Wilck [mailto:mwilck@suse.com]=20
Sent: Thursday, January 7, 2021 6:14 PM
To: Don Brace - C33706 <Don.Brace@microchip.com>; Kevin Barnett - C33748 <K=
evin.Barnett@microchip.com>; Scott Teel - C33730 <Scott.Teel@microchip.com>=
; Justin Lindley - C33718 <Justin.Lindley@microchip.com>; Scott Benesh - C3=
3703 <Scott.Benesh@microchip.com>; Gerry Morong - C33720 <Gerry.Morong@micr=
ochip.com>; Mahesh Rajashekhara - I30583 <Mahesh.Rajashekhara@microchip.com=
>; hch@infradead.org; jejb@linux.vnet.ibm.com; joseph.szczypek@hpe.com; POS=
WALD@suse.com
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH V3 10/25] smartpqi: add stream detection

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

On Thu, 2020-12-10 at 14:35 -0600, Don Brace wrote:
> * Enhance performance by adding sequential stream detection.
>   for R5/R6 sequential write requests.
>   * Reduce stripe lock contention with full-stripe write
>     operations.

I suppose that "stripe lock" is used by the firmware? Could you elaborate a=
 bit more how this technique improves performance?

> +       /*
> +        * If controller does not support AIO RAID{5,6} writes, need
> to send
> +        * requests down non-AIO path.
> +        */
> +       if ((device->raid_level =3D=3D SA_RAID_5 && !ctrl_info-
> >enable_r5_writes) ||
> +               (device->raid_level =3D=3D SA_RAID_6 && !ctrl_info-
> >enable_r6_writes))
> +               return true;
> +
> +       lru_index =3D 0;
> +       oldest_jiffies =3D INT_MAX;
> +       for (i =3D 0; i < NUM_STREAMS_PER_LUN; i++) {
> +               pqi_stream_data =3D &device->stream_data[i];
> +               /*
> +                * Check for adjacent request or request is within
> +                * the previous request.
> +                */
> +               if ((pqi_stream_data->next_lba &&
> +                       rmd.first_block >=3D pqi_stream_data->next_lba)
> &&
> +                       rmd.first_block <=3D pqi_stream_data->next_lba
> +
> +                               rmd.block_cnt) {

Here you seem to assume that the previous write had the same block_cnt.
What's the justification for that?

Don:
There is a maximum request size for RAID 5/RAID 6 write requests. So we are=
 assuming that if a sequential stream is detected, the stream is comprised =
of similar request sizes. In fact for coalescing, the LBAs need to be conti=
nuous or nearly contiguous, otherwise the RAID engine will not wait for a f=
ull-stripe.

I have updated the patch description accordingly.

> +                       pqi_stream_data->next_lba =3D rmd.first_block +
> +                               rmd.block_cnt;
> +                       pqi_stream_data->last_accessed =3D jiffies;
> +                       return true;
> +               }
> +
> +               /* unused entry */
> +               if (pqi_stream_data->last_accessed =3D=3D 0) {
> +                       lru_index =3D i;
> +                       break;
> +               }
> +
> +               /* Find entry with oldest last accessed time. */
> +               if (pqi_stream_data->last_accessed <=3D oldest_jiffies)
> {
> +                       oldest_jiffies =3D pqi_stream_data-
> >last_accessed;
> +                       lru_index =3D i;
> +               }
> +       }
> +
> +       /* Set LRU entry. */
> +       pqi_stream_data =3D &device->stream_data[lru_index];
> +       pqi_stream_data->last_accessed =3D jiffies;
> +       pqi_stream_data->next_lba =3D rmd.first_block + rmd.block_cnt;
> +
> +       return false;
> +}
> +
> +static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct
> scsi_cmnd *scmd)
>  {
>         int rc;
>         struct pqi_ctrl_info *ctrl_info; @@ -5768,11 +5842,12 @@=20
> static int pqi_scsi_queue_command(struct Scsi_Host *shost,
>                 raid_bypassed =3D false;
>                 if (device->raid_bypass_enabled &&
>                         !blk_rq_is_passthrough(scmd->request)) {
> -                       rc =3D
> pqi_raid_bypass_submit_scsi_cmd(ctrl_info, device,
> -                               scmd, queue_group);
> -                       if (rc =3D=3D 0 || rc =3D=3D SCSI_MLQUEUE_HOST_BU=
SY)
> {
> -                               raid_bypassed =3D true;
> -                               atomic_inc(&device->raid_bypass_cnt);
> +                       if (!pqi_is_parity_write_stream(ctrl_info,
> scmd)) {
> +                               rc =3D
> pqi_raid_bypass_submit_scsi_cmd(ctrl_info, device, scmd, queue_group);
> +                               if (rc =3D=3D 0 || rc =3D=3D
> SCSI_MLQUEUE_HOST_BUSY) {
> +                                       raid_bypassed =3D true;
> +                                       atomic_inc(&device-
> >raid_bypass_cnt);
> +                               }
>                         }
>                 }
>                 if (!raid_bypassed)
>



