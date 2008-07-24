From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH/RFC v3] allow userspace to modify scsi command filter on per device basis
Date: Wed, 23 Jul 2008 18:11:58 -0700
Message-ID: <e9c3a7c20807231811n23785a12jfac8647f698e82a@mail.gmail.com>
References: <48584252.5030901@interlog.com> <48592233.6040408@redhat.com>
	 <6cf6b73e0806260310n5988b59dycb0aeab3b0f5c930@mail.gmail.com>
	 <20080626233633E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.228]:6936 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbYGXBMA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jul 2008 21:12:00 -0400
Received: by wx-out-0506.google.com with SMTP id h29so2470777wxd.4
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2008 18:11:59 -0700 (PDT)
In-Reply-To: <20080626233633E.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: adel.gadllah@gmail.com, pjones@redhat.com, dgilbert@interlog.com, matthew@wil.cx, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Thu, Jun 26, 2008 at 7:36 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
>> Jens can we add merge this for .27 or does anyone still has objections?
>
> I think that this patch makes sg's permission stricter. So this could
> break the existing user-space applications.

Yes, it seems to have broken a simple routine I had to retrieve the
disk serial number from /dev/sg0.  Works fine if I run the ioctl on
/dev/sda.

Can we consider this a regression or am I doing something wrong?  The
following returns 2 on post-2.6.26 mainline and 0 otherwise.

#include <string.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <scsi/scsi.h>
#include <scsi/sg.h>

int scsi_get_serial(int fd, void *buf, size_t buf_len)
{
        unsigned char inq_cmd[] = {INQUIRY, 1, 0x80, 0, buf_len, 0};
        unsigned char sense[32];
        struct sg_io_hdr io_hdr;

        memset(&io_hdr, 0, sizeof(io_hdr));
        io_hdr.interface_id = 'S';
        io_hdr.cmdp = inq_cmd;
        io_hdr.cmd_len = sizeof(inq_cmd);
        io_hdr.dxferp = buf;
        io_hdr.dxfer_len = buf_len;
        io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
        io_hdr.sbp = sense;
        io_hdr.mx_sb_len = sizeof(sense);
        io_hdr.timeout = 5000;

        return ioctl(fd, SG_IO, &io_hdr);
}

int main(void)
{
        char buf[255];
        int fd;
        int ret;

        fd = open("/dev/sda", O_RDONLY);
        ret = scsi_get_serial(fd, buf, sizeof(buf));
        if (ret != 0)
                return 1;
        fd = open("/dev/sg0", O_RDONLY);
        ret = scsi_get_serial(fd, buf, sizeof(buf));
        if (ret != 0)
                return 2;

        return 0;
}
