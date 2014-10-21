From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] vhost-scsi: Take configfs group dependency during
 VHOST_SCSI_SET_ENDPOINT
Date: Wed, 22 Oct 2014 01:23:28 +0300
Message-ID: <20141021222328.GA18051@redhat.com>
References: <1412825695-15134-1-git-send-email-nab@daterainc.com>
 <1412828062.31947.50.camel@haakon3.risingtidesystems.com>
 <54364C2B.5000206@redhat.com>
 <54366830.4050009@redhat.com>
 <1413918331.19021.27.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1413918331.19021.27.camel@haakon3.risingtidesystems.com>
Sender: kvm-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 21, 2014 at 12:05:31PM -0700, Nicholas A. Bellinger wrote:
> Hey Paolo,
> 
> On Thu, 2014-10-09 at 12:49 +0200, Paolo Bonzini wrote:
> > Il 09/10/2014 10:49, Paolo Bonzini ha scritto:
> > > 
> > > It does not happen if you close QEMU with SIGTERM, ctrl-c, or with the
> > > "quit" command, because no attempt is done to bring down the VM data
> > > structures (or free memory, or close file descriptors) in case of a
> > > fatal exit.  The kernel should do that for us.
> > 
> > ... and in the case of vhost-scsi, doesn't it do that when
> > vhost_scsi_release calls vhost_scsi_clear_endpoint?
> > 
> 
> Thanks for the extra clarifications here.
> 
> The SIGTERM, ctrl-c and "quit" command cases happen as you describe, and
> invoke vhost_scsi_release() -> vhost_scsi_clear_endpoint() to drop the
> endpoint reference.
> 
> AFAICT, it's the SIGKILL case that is problematic both with and without
> this patch.  With the patch, the configfs dependency on the vhost-scsi
> endpoint group is left in place, thus preventing the group (and
> underlying target_core_mod) from being removed until a
> VHOST_SCSI_CLEAR_ENDPOINT with the same wwpn is called to drop the
> original reference.
> 
> Without the patch, the group can still be removed at any time, but any
> subsequent VHOST_SCSI_SET_ENDPOINT attempts with the original wwpn will
> fail after SIGKILL, because the original reference is still in place.
> 
> So I held off on pushing this patch to -rc1 for the moment, but even
> with the above limitation preventing group shutdown after SIGKILL, I
> think it's still better to obtain the configfs dependency to prevent the
> removal of endpoints while there are active references.
> 
> That said, I'm still unsure how to address the SIGKILL case, and what's
> the most sane way to drop dead references after it happens, and how
> vhost-scsi should be differentiating between dead and active references.
> 
> Any ideas..?
> 
> --nab

Need to use some other file (not sysfs), cleanup on release.

-- 
MST
