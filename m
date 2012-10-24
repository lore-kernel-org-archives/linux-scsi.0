From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Drivers: scsi
Date: Thu, 25 Oct 2012 07:25:20 +0900
Message-ID: <1351117520.2494.8.camel@dabdike>
References: <1351095938-12204-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351095938-12204-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-10-24 at 09:25 -0700, K. Y. Srinivasan wrote:
> When the low level driver returns SCSI_MLQUEUE_DEVICE_BUSY,
> how is the command retried; I suspect the retry is done after some delay.

Delay depends mainly on I/O pressure and the unplug timer in the block
layer.

> Is this delay programmable? If the device state changes,
> can the low level driver notify upper layers that it can now handle
> the command that it had failed earlier with SCSI_MLQUEUE_DEVICE_BUSY.

In theory, you can call blk_run_queue() from the event handler that sees
the device become ready.  I don't think any driver actually does this,
but I can't see it would cause any problem.

James
