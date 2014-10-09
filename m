From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] vhost-scsi: Take configfs group dependency during VHOST_SCSI_SET_ENDPOINT
Date: Thu, 09 Oct 2014 10:49:47 +0200
Message-ID: <54364C2B.5000206@redhat.com>
References: <1412825695-15134-1-git-send-email-nab@daterainc.com> <1412828062.31947.50.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1412828062.31947.50.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Il 09/10/2014 06:14, Nicholas A. Bellinger ha scritto:
> AFAICT from qemu code, the ioctl VHOST_SCSI_CLEAR_ENDPOINT is always
> called during shutdown in order to release the endpoint and drop this
> new configfs dependency.

As far as I can see, the only path leading to the ioctl is
vhost_scsi_set_status->vhost_scsi_stop.  That only happens if the guest
driver resets the device upon shutdown, or via vhost_scsi_unrealize as
you pointed out.  But unrealize() is only called when a device is
hot-unplugged.

It does not happen if you close QEMU with SIGTERM, ctrl-c, or with the
"quit" command, because no attempt is done to bring down the VM data
structures (or free memory, or close file descriptors) in case of a
fatal exit.  The kernel should do that for us.

Besides that...

> The question is, what happens when qemu crashes..?  Is there currently
> an assurance that VHOST_SCSI_CLEAR_ENDPOINT is called via the normal
> VirtioDeviceClass->unrealize() when qemu exits abnormally..?

... of course nothing is called if you SIGKILL QEMU.

Paolo
