From: Laurence Oberman <loberman@redhat.com>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Fri, 25 Nov 2016 09:46:05 -0500 (EST)
Message-ID: <805036857.58360.1480085165589.JavaMail.zimbra@redhat.com>
References: <1479738275.19792.24.camel@localhost.localdomain> <CAPrnrPAFSUL4C+N09-BUUm+7e84oxasaHb7-Ej-+8FuYOddRgA@mail.gmail.com> <2146476957.2165908.1479927335303.JavaMail.zimbra@redhat.com> <1479932524.28416.43.camel@localhost.localdomain> <20161125080758.5bh5jkcgvhw3xuvb@linux-x5ow.site> <CAPrnrPBcvBcNaZ5asJquRSp4Ann3xHVGSRbwLkvPF+YKJ6OpCw@mail.gmail.com> <20161125115317.llxd2lslf7ovitxd@linux-x5ow.site> <CAPrnrPBsBPH2B48QYLPCsdpg0LT7iBxc2+g+_xHPcDOjRf7f5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:52873 "EHLO
        mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932486AbcKYPnX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2016 10:43:23 -0500
In-Reply-To: <CAPrnrPBsBPH2B48QYLPCsdpg0LT7iBxc2+g+_xHPcDOjRf7f5A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eyal Ben David <bdeyal@gmail.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, "Ewan D. Milne" <emilne@redhat.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Eyal Ben David" <bdeyal@gmail.com>
> To: "Johannes Thumshirn" <jthumshirn@suse.de>
> Cc: "Ewan D. Milne" <emilne@redhat.com>, "Laurence Oberman" <loberman@redhat.com>, dgilbert@interlog.com,
> linux-scsi@vger.kernel.org
> Sent: Friday, November 25, 2016 7:36:34 AM
> Subject: Re: SG does not ignore dxferp (direct io + mmap)
> 
> On Fri, Nov 25, 2016 at 1:53 PM, Johannes Thumshirn <jthumshirn@suse.de>
> wrote:
> > On Fri, Nov 25, 2016 at 01:20:34PM +0200, Eyal Ben David wrote:
> >> Note that sg_mmap_read does not parse the SCSI sense, so the script
> >> might fail for other reasons (some SCSI error) and think its a zero
> >> byte corruption.
> >
> > But SCSI generic checks for errors and returns -EINVAL on CHECK_CONDITION
> > or
> > DRIVER_SENSE (and sets SG_INFO_CHECK in hdr.info).
> >
> Ah OK. We use async write/read instead of ioctl and forgot that ioctl
> checks the read.
> 
> > Anyways, can you test the patch Ewan found on one of your kernel's that are
> > known to fail?
> 
> All the examples I gave before were on physical hosts and storage at a
> testing lab.
> That would be difficult to do. Sorry.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

I applied just the patch myself and Ewan isolated to the 4.7.9 kernel and the issue is resolved for me.
I have 100000 loops of the test with no issue.

I repeated the test flushing cache each time as well to make sure

for i in `seq 1 100000`; do ./sg_mmap_read -d /dev/sg1 -l 0 -m -b | hexdump | grep 6300; done

for i in `seq 1 100000`; do ./sg_mmap_read -d /dev/sg1 -l 0 -m -b | hexdump | grep 6300; echo 3 > /proc/sys/vm/drop_caches;done

Johannes, you are reproducing another race in your test I think.

