From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v8 6/7] sd: Implement support for ZBC devices
Date: Tue, 18 Oct 2016 13:22:11 -0500
Message-ID: <CAJVOszBUe2BoCWoKLXXi9DUgk7Mg08uX6a-+LcEdho63nQzOWQ@mail.gmail.com>
References: <1476772835-18541-1-git-send-email-damien.lemoal@wdc.com>
 <1476772835-18541-7-git-send-email-damien.lemoal@wdc.com> <x498ttlvbks.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:56356 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S964942AbcJRSWe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 14:22:34 -0400
Received: from pps.filterd (m0075552.ppops.net [127.0.0.1])
        by mx0a-00003501.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9IIJHW7014280
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2016 14:22:33 -0400
Received: from mail-yw0-f197.google.com (mail-yw0-f197.google.com [209.85.161.197])
        by mx0a-00003501.pphosted.com with ESMTP id 265krb1mdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2016 14:22:33 -0400
Received: by mail-yw0-f197.google.com with SMTP id u124so3520724ywg.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2016 11:22:32 -0700 (PDT)
In-Reply-To: <x498ttlvbks.fsf@segfault.boston.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>, Damien Le Moal <damien.lemoal@hgst.com>

On Tue, Oct 18, 2016 at 11:58 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Damien Le Moal <damien.lemoal@wdc.com> writes:
>
>> +     if (!is_power_of_2(zone_blocks)) {
>> +             if (sdkp->first_scan)
>> +                     sd_printk(KERN_NOTICE, sdkp,
>> +                               "Devices with non power of 2 zone "
>> +                               "size are not supported\n");
>> +             return -ENODEV;
>> +     }
>
> Are power of 2 zone sizes required by the standard?  I see why you've
> done this, but I wonder if we're artificially limiting the
> implementation, and whether there will be valid devices on the market
> that simply won't work with Linux because of this.

The standard does not require power of 2 zones.
That said, I am not aware of any current (or planned) devices other
than a power of 2.
Common zone sizes I am aware of: 256MiB, 128MiB and 1GiB.

Also note that we are excluding the runt zone from the power of 2 expectati=
on.

So conforming devices should (excluding a runt zone):
  - Have zones of the same size.
  - Choose a zone size that is a power of 2.

--Shaun

> -Jeff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-block" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=3Dhttp=
-3A__vger.kernel.org_majordomo-2Dinfo.html&d=3DDQIBAg&c=3DIGDlg0lD0b-nebmJJ=
0Kp8A&r=3DWg5NqlNlVTT7Ugl8V50qIHLe856QW0qfG3WVYGOrWzA&m=3DA15hLQb19nr4vdRr1=
Bbbn98FLSj_y-C0VI6FtiA9V_I&s=3DrVkinUiv-ZJHIfhlk2VVJM7S2dJtvxOCmwbKMuiOCPU&=
e=3D
