Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96BA1C3A5A8
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 17:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C14521883
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 17:39:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="p60g+dYR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730195AbfIDRjj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 13:39:39 -0400
Received: from mail-eopbgr740042.outbound.protection.outlook.com ([40.107.74.42]:53760
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726495AbfIDRji (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Sep 2019 13:39:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kINiszOohR4rxFJh2L/+RKF/maJ2Vy7Ej91vMYTWEZqafzRfQljeTcUwJLStxMgC/jwil8v1wGRiQ16KmQXSXJZitml9DYSIxF/z8C2wt+Ue7HvmvRmfLw+3fIIwHnF+tjg7z0rtMEFSA97Nd1IIGl4d6yor+y3IPlfGD1OHtrwYIlqwdDxWxvhfJ0/53INOm5+DkDqy2JBTDXg8D/KtsodWd6f0+w7yILp7DzF67A89R4WQTuV4Q/b6W5BfS1jBOc9Ct/gpcPPkYANntg7fltaB0Oj7Oa+RMfbbz1QJNe8BqVHePtnUMD4Zntb7yArO85g9LiYwee5KlT+O4Q2UDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4SZnKkm+iwVgdPTz12B0Scz1ynBjcUNByi4NiB9+qE=;
 b=dxr6XOIhW1BJJ4z/NxlmBS0ql5dOQfOtg5qIAgDImA7zyG1Bu4OzZhSWMrVyVygvzQ9Qt8fMZk/yuX3LXNmSJwqnqem8JNj2TWZqb44wWx3OnBOR15S/9kYin7LhtCCaoFTjn0hPDCEK8WM/+p4Go2Cl2SVCdMFgM228e0GFpCmUpMGH0G38y5dCORg2xWQ6fLkTdti/j50ujC6rGdC5QDx5fIllHVj1rMtxCL2wji8gy0KFXMapY7Bacl8NDbRrgTbXpRiyzuT5gqF3yejojU8MjIXZKqLv/fLmPWUHX2EbOQUyvSDys6BJLJO4YR0UAIDPCVhETPDnvyhes8BBDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4SZnKkm+iwVgdPTz12B0Scz1ynBjcUNByi4NiB9+qE=;
 b=p60g+dYRGohkwhqonJ3ekX9Tv2bemzfAtTpxmio+a1E8P5HlUyBo+KwaFLno4adAUu1pDMzK9mhbAJVrTL8O7HhD9UzlEOC8zsnOiy2xQoJ4IQw783uCz13aoRyHdOruxAAxc2c+F2bd+28nbLKoXJ80F19cRV2DyOKzp5uW1EY=
Received: from BY5PR19MB3176.namprd19.prod.outlook.com (10.255.160.21) by
 BY5PR19MB3779.namprd19.prod.outlook.com (10.186.132.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14; Wed, 4 Sep 2019 17:38:54 +0000
Received: from BY5PR19MB3176.namprd19.prod.outlook.com
 ([fe80::844f:102f:5181:c074]) by BY5PR19MB3176.namprd19.prod.outlook.com
 ([fe80::844f:102f:5181:c074%3]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 17:38:53 +0000
From:   Matt Lupfer <mlupfer@ddn.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: virtio_scsi: unplug LUNs when events missed
Thread-Topic: [PATCH] scsi: virtio_scsi: unplug LUNs when events missed
Thread-Index: AQHVYnmgUCG1mM4ObEKGSGCIQ1xBzg==
Date:   Wed, 4 Sep 2019 17:38:53 +0000
Message-ID: <20190904173848.GD4571@tesla>
References: <20190903170408.32286-1-mlupfer@ddn.com>
 <20190904051230-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190904051230-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR13CA0040.namprd13.prod.outlook.com
 (2603:10b6:404:13e::26) To BY5PR19MB3176.namprd19.prod.outlook.com
 (2603:10b6:a03:184::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mlupfer@ddn.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [107.128.241.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ccc882e-40fa-49ef-a448-08d7315ec139
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BY5PR19MB3779;
x-ms-traffictypediagnostic: BY5PR19MB3779:
x-microsoft-antispam-prvs: <BY5PR19MB3779C0203D12908CBD9DE7A7AEB80@BY5PR19MB3779.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(366004)(136003)(376002)(39850400004)(396003)(346002)(189003)(199004)(54906003)(316002)(86362001)(71200400001)(3846002)(6246003)(53936002)(66066001)(6436002)(6512007)(9686003)(6116002)(4326008)(71190400001)(2906002)(33656002)(25786009)(5660300002)(1076003)(305945005)(66946007)(66476007)(66556008)(64756008)(66446008)(256004)(8676002)(14454004)(81156014)(81166006)(102836004)(186003)(6486002)(11346002)(7736002)(6506007)(386003)(99286004)(6916009)(26005)(33716001)(476003)(52116002)(446003)(486006)(478600001)(76176011)(229853002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR19MB3779;H:BY5PR19MB3176.namprd19.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: ddn.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KgnNTKc7uxlITf7XjJn00W5d2uCT+DRLTIcxH/MRcruxX4gDU6a7VXiSB+94MlVh2x1YZghUucnOY9EAy56mZVWNxHA0eVJ/+rkOK5CWWdOkIHA61z4SDl+XIBNr6Pc9jhN9MKIkyiZQjsjg+xpE3LOl4MOFqro2BPpn/sZ8MouBIzeua5jroSPJqB8CiDzKx26DI8xhPZg2IMxIDeEZhMNLmpGZ8N56zJn+fkudDKjAmdI4rTLdYx0nQPq+bnDcOLj0y1mGtb/WtNa+4SSC4nEVyabzDKkwJ0wlAAMTM8rVmvQsYdxns651Z/j3ggPMLmq7J6/32HfKrehVJBt0dGw9TkpM7JhJ2uNFAC0XqrYNkokhsL/S5IYl5QQzVgbCwnib+P4pQNVUnP81pV9Kq7yQrewQ2tRi3TEhfYVR59Q=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9E6EF2CD85D60640882F4949EBBE43CB@namprd19.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ccc882e-40fa-49ef-a448-08d7315ec139
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 17:38:53.8669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y9gEUsjK3jKzRParRw274mw5ceHXydyv76bZjIEnhfec04QL205Swr6ees1Q1qPU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR19MB3779
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 04, 2019 at 05:14:33AM -0400, Michael S. Tsirkin wrote:
> On Tue, Sep 03, 2019 at 05:04:20PM +0000, Matt Lupfer wrote:
>> The event handler calls scsi_scan_host() when events are missed, which
>> will hotplug new LUNs.  However, this function won't remove any
>> unplugged LUNs.  The result is that hotunplug doesn't work properly when
>> the number of unplugged LUNs exceeds the event queue size (currently 8).
>>
>> Scan existing LUNs when events are missed to check if they are still
>> present.  If not, remove them.
>>
>> Signed-off-by: Matt Lupfer <mlupfer@ddn.com>
>> ---
>>  drivers/scsi/virtio_scsi.c | 31 +++++++++++++++++++++++++++++++
>>  1 file changed, 31 insertions(+)
>>
>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>> index 297e1076e571..18df77bf371b 100644
>> --- a/drivers/scsi/virtio_scsi.c
>> +++ b/drivers/scsi/virtio_scsi.c
>> @@ -324,6 +324,36 @@ static void virtscsi_handle_param_change(struct vir=
tio_scsi *vscsi,
>>  	scsi_device_put(sdev);
>>  }
>>
>> +static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
>> +{
>> +	struct scsi_device *sdev;
>> +	struct Scsi_Host *shost =3D virtio_scsi_host(vscsi->vdev);
>> +	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
>> +	int result, inquiry_len, inq_result_len =3D 256;
>> +	char *inq_result =3D kmalloc(inq_result_len, GFP_KERNEL);
>> +
>> +	shost_for_each_device(sdev, shost) {
>> +		inquiry_len =3D sdev->inquiry_len ? sdev->inquiry_len : 36;
>> +
>> +		memset(scsi_cmd, 0, sizeof(scsi_cmd));
>> +		scsi_cmd[0] =3D INQUIRY;
>> +		scsi_cmd[4] =3D (unsigned char) inquiry_len;
>> +
>> +		memset(inq_result, 0, inq_result_len);
>> +
>> +		result =3D scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
>> +					  inq_result, inquiry_len, NULL,
>> +					  2, 3, NULL);
>
>
> Where do the weird 2 and 3 values come from?
>
> Most callers seem to use SD_TIMEOUT, SD_MAX_RETRIES...
>

The value of 3 retries is from scsi_probe_lun() in scsi_scan.c.

The value of 2 seconds is arbitrary, but equals SCSI_TIMEOUT.
scsi_inq_timeout in scsi_scan.c is complicated for reasons unknown to
me, but is quite a bit longer, more in line with SD_TIMEOUT.

I will send a V2 patch with the SD_TIMEOUT and SD_MAX_RETRIES macros
from drivers/scsi/sd.h.

Thanks for taking a look.

Matt
