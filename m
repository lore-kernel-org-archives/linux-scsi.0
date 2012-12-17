From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 0/2] add per-device sysfs knob to enable unrestricted,
 unprivileged SG_IO
Date: Mon, 17 Dec 2012 15:27:49 +0100
Message-ID: <50CF2BE5.8070804@redhat.com>
References: <1352827513-29890-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1352827513-29890-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Il 13/11/2012 18:25, Paolo Bonzini ha scritto:
> Privilege restrictions for SG_IO right now apply without distinction to
> all devices, based on the single capability CAP_SYS_RAWIO.  This is a very
> broad capability, and makes it difficult to give SG_IO access to trusted
> clients that need access to persistent reservations, trim/discard, or
> vendor-specific commands.  One problem here is that CAP_SYS_RAWIO allows
> to escape a partition and issue commands that affect the full disk,
> thus making DAC almost useless.
> 
> For simplicity, this series attempts to solve one case only: you want
> to pass through almost everything, but still run as confined as possible.
> This is for example the case for virtualization, where more complex
> filtering can be done just as easily in userspace, in the virtual
> machine monitor.  (This does mean the filter can be subverted if the
> guest can escape the QEMU jail, but a more generic approach involving
> a bitmap was NACKed).
> 
> Ok for 3.8?

Ping... Jens, I haven't seen any pull request for 3.8 from you.  Are
these patches on your radar?  Tejun acked both of them.

Paolo

> v2->v3: change bitmap filter to boolean
> 
> Paolo Bonzini (2):
>   sg_io: pass request_queue to blk_verify_command
>   sg_io: introduce unpriv_sgio queue flag
> 
>  block/blk-sysfs.c      |   32 ++++++++++++++++++++++++++++++++
>  block/bsg.c            |    2 +-
>  block/scsi_ioctl.c     |    9 +++++----
>  drivers/scsi/sg.c      |    3 ++-
>  include/linux/blkdev.h |    6 +++++-
>  5 files changed, 45 insertions(+), 7 deletions(-)
> 
