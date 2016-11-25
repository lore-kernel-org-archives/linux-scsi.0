From: Eyal Ben David <bdeyal@gmail.com>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Fri, 25 Nov 2016 14:36:34 +0200
Message-ID: <CAPrnrPBsBPH2B48QYLPCsdpg0LT7iBxc2+g+_xHPcDOjRf7f5A@mail.gmail.com>
References: <1479738275.19792.24.camel@localhost.localdomain>
 <1ca8515f-abd2-7428-8baa-dca879833be3@interlog.com> <1479752642.19792.43.camel@localhost.localdomain>
 <20161122083759.xeifuex3xxfimuwz@linux-x5ow.site> <1479839407.28416.21.camel@localhost.localdomain>
 <CAPrnrPAFSUL4C+N09-BUUm+7e84oxasaHb7-Ej-+8FuYOddRgA@mail.gmail.com>
 <2146476957.2165908.1479927335303.JavaMail.zimbra@redhat.com>
 <1479932524.28416.43.camel@localhost.localdomain> <20161125080758.5bh5jkcgvhw3xuvb@linux-x5ow.site>
 <CAPrnrPBcvBcNaZ5asJquRSp4Ann3xHVGSRbwLkvPF+YKJ6OpCw@mail.gmail.com> <20161125115317.llxd2lslf7ovitxd@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34825 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752780AbcKYMhf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2016 07:37:35 -0500
Received: by mail-io0-f193.google.com with SMTP id h133so9261148ioe.2
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 04:36:35 -0800 (PST)
In-Reply-To: <20161125115317.llxd2lslf7ovitxd@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Ewan D. Milne" <emilne@redhat.com>, Laurence Oberman <loberman@redhat.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org

On Fri, Nov 25, 2016 at 1:53 PM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On Fri, Nov 25, 2016 at 01:20:34PM +0200, Eyal Ben David wrote:
>> Note that sg_mmap_read does not parse the SCSI sense, so the script
>> might fail for other reasons (some SCSI error) and think its a zero
>> byte corruption.
>
> But SCSI generic checks for errors and returns -EINVAL on CHECK_CONDITION or
> DRIVER_SENSE (and sets SG_INFO_CHECK in hdr.info).
>
Ah OK. We use async write/read instead of ioctl and forgot that ioctl
checks the read.

> Anyways, can you test the patch Ewan found on one of your kernel's that are
> known to fail?

All the examples I gave before were on physical hosts and storage at a
testing lab.
That would be difficult to do. Sorry.
