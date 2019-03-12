From: Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH] usb: uas: fix usb subsystem hang after power off hub
 port
Date: Tue, 12 Mar 2019 16:37:27 +0100
Message-ID: <1552405047.21557.7.camel@suse.com>
References: <AE5419EAB4965843B3C0C1FE29F1FFE5872241@JPYOKXMS103.jp.sony.com>
         <1552063928.29776.2.camel@suse.com>
         <AE5419EAB4965843B3C0C1FE29F1FFE587268B@JPYOKXMS103.jp.sony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AE5419EAB4965843B3C0C1FE29F1FFE587268B@JPYOKXMS103.jp.sony.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kento.A.Kobayashi@sony.com, gregkh@linuxfoundation.org, stern@rowland.harvard.edu
Cc: usb-storage@lists.one-eyed-alien.net, Jacky.Cao@sony.com, Kan.Iibuchi@sony.com, No.Tanaka@sony.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mo, 2019-03-11 at 08:36 +0000, Kento.A.Kobayashi@sony.com wrote:
> Hi,
> 
> > no I am sorry, that is an assumption you just cannot make.
> > Anything can trigger a reset. That being SCSI is the common case certainly, but not the only case. And in those cases we cannot depend on upper layers doing the right thing, if we just ignore an error.
> 
> While we investigate this issue, we debugged and found usb_reset_and_verify_device will return -NODEV before enter post_reset operation.

Yes, this can happen.

> And the return value(-ENODEV) will be returned to error handler.
> uas_eh_device_reset_handler->usb_reset_device -> usb_reset_and_verify_device (return -ENODEV) Then I wrote that commit message that we think even if we ignore "ENODEV" in post reset to avoid hang issue but the error will also be reported to error handler.
> #If ignore an error and the error will not be reported then it is not good.

Well, what do we do now? Are you saying that the state model SCSI is
using is wrong?

> Additional information about usb-storage driver(usb/storage/usb.c) in usb_stor_post_reset() function, it always return 0 that means rebind will not be execute and this issue doesn't happen.

I am afraid this is only partially correct. The device descriptors can
still fail to match.

	Regards
		Oliver
