From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2
Date: Tue, 14 Sep 2004 14:35:02 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040914183502.GA23277@havoc.gtf.org>
References: <41471163.10709@rtr.ca> <414723B0.1090600@pobox.com> <1095186343.2008.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S269184AbUINSnJ@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1095186343.2008.29.camel@mulgrave>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mark Lord <lkml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 14, 2004 at 02:25:35PM -0400, James Bottomley wrote:
> Sleeping in the eh paths is fine (as long as you drop the locks that the
> EH thread has uselessly taken for you).  Indeed it's often required
> since the return is supposed to tell the eh thread whether the action
> was successful or not.

I'm not sure this true for all arches?

The lock is taken in the SCSI layer with spin_lock_irqsave(), but the
low-level driver cannot perform the exact opposite,
spin_unlock_irqrestore().  The best they can do is spin_lock_irq(),
which isnt 100% the same.

	Jeff
