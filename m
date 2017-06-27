From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: Permanently change thin provisioning method from user space?
Date: Tue, 27 Jun 2017 17:01:31 -0400
Message-ID: <1498597291.10198.21.camel@localhost.localdomain>
References: <CAA91j0VCH06Xfk2Hx6ooDnd4+9+Sv1Z+2TY7MmQmgKLoiB0=+A@mail.gmail.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50626 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753295AbdF0VBc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Jun 2017 17:01:32 -0400
In-Reply-To: <CAA91j0VCH06Xfk2Hx6ooDnd4+9+Sv1Z+2TY7MmQmgKLoiB0=+A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2017-06-27 at 14:02 +0300, Andrei Borzenkov wrote:
> I'm facing storage system that while generally advertising support for
> WRITE_SAME_16 with UNMAP in reality fails this request depending on
> exact volume configuration. This configuration is done on storage side
> and may happen after host initially discovered LUN.
> 
> I though about simply overriding kernel auto-detect with UNMAP using
> sysfs scsi_disk/.../provisioning_mode attribute, but it appears kernel
> may re-evaluate it in some cases, so changes do not stick. Is it
> possible to permanently restrict it per-device (or per-vendor/device)?
> 
> TIA
> 
> -andrei

sd_fops->revalidate_disk() will cause the properties that cause the
provisioning_mode to be evaluated to be re-read, and sd_config_discard()
to set the determined mode.  We might want to re-think this, since the
user overrode what was probed earlier.  However, we might also want to
automatically handle the storage capabilities changing, so I'm not sure.

I think we should figure out how best to handle devices/arrays that aren't
correctly handling WRITE SAME(16) w/UNMAP, I've seen a few cases of this
recently with a certain FC array and it looks to me as if the problem
there was that it was advertising MAXIMUM WRITE SAME LENGTH of zero
in the block limits VPD page, but a MAXIMUM UNMAP LBA COUNT of 65536.
My reading of SBC-4r13 6.6.4 is that a WRITE SAME(16) w/UNMAP has
a length limited by the MAXIMUM WRITE SAME LENGTH, and that is what
sd.c implements, but I'm suspicious that the array treated a WRITE SAME(16)
w/UNMAP of 2097152 blocks as an UNMAP and failed it w/ILLEGAL COMMAND,
INVALID FIELD IN CDB.

I don't actually have one of these arrays, I'm trying to gather more info.

-Ewan
