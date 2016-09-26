From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: UFS API in the kernel
Date: Mon, 26 Sep 2016 14:22:59 -0500
Message-ID: <CAJVOszALc04xgNujHi2YdCGpTXNWDoyLVwYT2uSYy6faDLqmYA@mail.gmail.com>
References: <c6a8636a-98e6-61d0-ff4b-350fb3869699@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00003501.pphosted.com ([67.231.152.68]:47436 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S965069AbcIZTXZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Sep 2016 15:23:25 -0400
Received: from pps.filterd (m0075028.ppops.net [127.0.0.1])
        by mx0b-00003501.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8QJMZXm027366
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2016 15:23:24 -0400
Received: from mail-yb0-f200.google.com (mail-yb0-f200.google.com [209.85.213.200])
        by mx0b-00003501.pphosted.com with ESMTP id 25q42g9y1n-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2016 15:23:19 -0400
Received: by mail-yb0-f200.google.com with SMTP id 2so317617427ybv.3
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2016 12:23:19 -0700 (PDT)
In-Reply-To: <c6a8636a-98e6-61d0-ff4b-350fb3869699@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Thu, Sep 22, 2016 at 10:21 AM, Joao Pinto <Joao.Pinto@synopsys.com> wrot=
e:
> Hi!
>
> I am designing an application that has the goal to be an utility for Unip=
ro and
> UFS testing purposes. This application is going to run on top of a recent=
 Linux
> Kernel containing the new UFS stack (including the new DWC drivers).
>
> I am considering doing the following:
> a) Create a new config item called CONFIG_UFS_CHARDEV which is going to c=
reate a
> char device responsible to make some IOCTL available for user-space appli=
cations
> b) Create a linux/ufs.h header file that contains data structures declara=
tions
> that will be needed in user-space applications

I am not very familiar with UFS devices, that said you should have an
sgX chardev being created already so you can handle SG_IO requests.
There also appear to be some sysfs entries being created.

So between sg and sysfs you should be able to handle any user-space
out of band requests without resorting to making a new chardev.

Adding more sysfs entries, if you need them, should be fine.

You may find it easier to expand on the existing interfaces than to
get consensus on a new driver and ioctls.

Hope this helps,
Shaun

> Could you please advise me about what the correct approach should be to m=
ake it
> as standard as possible and usable in the future?
>
> Thank you very much for your help!
>
> regards,
> Joao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=3Dhttp=
-3A__vger.kernel.org_majordomo-2Dinfo.html&d=3DDQICaQ&c=3DIGDlg0lD0b-nebmJJ=
0Kp8A&r=3DWg5NqlNlVTT7Ugl8V50qIHLe856QW0qfG3WVYGOrWzA&m=3DvJFB6pCywWtdvkgHz=
9Vc0jQz0xzeyZlr-7eCWYu88nM&s=3DyiQLPFpqmMrbqLZz1Jb3aNqOje2dRMLJHEzUDobwcXc&=
e=3D



--=20
Shaun Tancheff
