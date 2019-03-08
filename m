From: Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH] usb: uas: fix usb subsystem hang after power off hub
 port
Date: Fri, 08 Mar 2019 17:52:08 +0100
Message-ID: <1552063928.29776.2.camel@suse.com>
References: <AE5419EAB4965843B3C0C1FE29F1FFE5872241@JPYOKXMS103.jp.sony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AE5419EAB4965843B3C0C1FE29F1FFE5872241@JPYOKXMS103.jp.sony.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kento.A.Kobayashi@sony.com, gregkh@linuxfoundation.org, stern@rowland.harvard.edu
Cc: usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fr, 2019-03-08 at 09:13 +0000, Kento.A.Kobayashi@sony.com wrote:
> The usb_reset_and_verify_device included in usb_reset_device fails
> with -ENODEV after power off hub port, and the -ENODEV error will
> be reported to uas_eh_bus_reset_handler and upper layer, so it
> doesn't need to do rebind if -ENODEV happens.

Hi,

no I am sorry, that is an assumption you just cannot make.
Anything can trigger a reset. That being SCSI is the common
case certainly, but not the only case. And in those cases
we cannot depend on upper layers doing the right thing, if
we just ignore an error.

NACK

	Sorry
		Oliver
