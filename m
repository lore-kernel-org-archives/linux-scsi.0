From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2
Date: 14 Sep 2004 14:51:19 -0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <1095187885.2007.33.camel@mulgrave>
References: <41471163.10709@rtr.ca> <414723B0.1090600@pobox.com>
	<1095186343.2008.29.camel@mulgrave>  <20040914183502.GA23277@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20040914183502.GA23277@havoc.gtf.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Mark Lord <lkml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2004-09-14 at 14:35, Jeff Garzik wrote:
> The lock is taken in the SCSI layer with spin_lock_irqsave(), but the
> low-level driver cannot perform the exact opposite,
> spin_unlock_irqrestore().  The best they can do is spin_lock_irq(),
> which isnt 100% the same.

That's what they do if you look.

The eh_ stubs are only called from the eh_ thread, so it's safe to
enable interrupts as well.

The business of the mid-layer taking the locks is an annoying holdover
from the "drivers don't need to do locking" mentality.  Unfortunately
most drivers now simply drop the locks immediately they begin an eh_
entry point and reacquire them just prior to returning ... which makes
all the eh code look messy.

James


