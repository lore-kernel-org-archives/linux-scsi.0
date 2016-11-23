From: Laurence Oberman <loberman@redhat.com>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Wed, 23 Nov 2016 13:55:35 -0500 (EST)
Message-ID: <2146476957.2165908.1479927335303.JavaMail.zimbra@redhat.com>
References: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com> <CAPrnrPBOrkzz5f5rVE4jBkEEvEQRoeo73y50V6cVNgP3c5yzNg@mail.gmail.com> <1479738275.19792.24.camel@localhost.localdomain> <1ca8515f-abd2-7428-8baa-dca879833be3@interlog.com> <1479752642.19792.43.camel@localhost.localdomain> <20161122083759.xeifuex3xxfimuwz@linux-x5ow.site> <1479839407.28416.21.camel@localhost.localdomain> <CAPrnrPAFSUL4C+N09-BUUm+7e84oxasaHb7-Ej-+8FuYOddRgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:46772 "EHLO
        mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932959AbcKWSzk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2016 13:55:40 -0500
In-Reply-To: <CAPrnrPAFSUL4C+N09-BUUm+7e84oxasaHb7-Ej-+8FuYOddRgA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eyal Ben David <bdeyal@gmail.com>
Cc: "Ewan D. Milne" <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, dgilbert@interlog.com, linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Eyal Ben David" <bdeyal@gmail.com>
> To: "Ewan D. Milne" <emilne@redhat.com>
> Cc: "Johannes Thumshirn" <jthumshirn@suse.de>, dgilbert@interlog.com, "Laurence Oberman" <loberman@redhat.com>,
> linux-scsi@vger.kernel.org
> Sent: Tuesday, November 22, 2016 3:55:44 PM
> Subject: Re: SG does not ignore dxferp (direct io + mmap)
> 
> On Tue, Nov 22, 2016 at 8:30 PM, Ewan D. Milne <emilne@redhat.com> wrote:
> >
> > I see the behavior (zero byte) on the 4.4.34, 4.5.7, 4.6.7, and 4.7.10
> > -stable kernels.  But not (of course) on 4.8.10 -stable.
> >
> > It doesn't look like the sg driver, might be something in the mmap code?
> 
> 
> A kernel guy colleague suggested to look at copy_from_user / copy_to_user
> code.
> It was changed in 4.8
> 
> It was OK with 3.13  (Ubuntu 14.04) but from some kernel (prior or equal to
> 4.4)
> until 4.7 we see the bug. It was somehow fixed at 4.8.
> 
> In order to fully understand what happened, there are two changes to find.
> They might not even be related.
> 
> Thanks!
> Eyal
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

So 4.7.9 fails and 4.8.0 works and 4.8.0 is a rebase so we have 

[loberman@localhost linux-stable-4.8.10]$ git log --oneline v4.7.9..v4.8 | wc -l
14552

No obvious single commits stand out for me for copy_from* or copy_to*
There is this:

3fa6c50 mm: optimize copy_page_to/from_iter_iovec
6e05050 sh: fix copy_from_user()
e697100 x86/uaccess: force copy_*_user() to be inlined

I will have to do this the hard way with bisects to figure out which commit addresses this.

Back when I have had enough time to do it.

Thanks
Laurence
