From: <Kento.A.Kobayashi@sony.com>
Subject: RE: [PATCH] usb: uas: fix usb subsystem hang after power off hub
 port
Date: Mon, 15 Apr 2019 00:27:43 +0000
Message-ID: <AE5419EAB4965843B3C0C1FE29F1FFE5899C80@JPYOKXMS103.jp.sony.com>
References: <1554823007.161891.6.camel@acm.org>
 <Pine.LNX.4.44L0.1904091232370.1599-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1904091232370.1599-100000@iolanthe.rowland.org>
Content-Language: ja-JP
Sender: linux-kernel-owner@vger.kernel.org
To: stern@rowland.harvard.edu, bvanassche@acm.org
Cc: martin.petersen@oracle.com, jejb@linux.ibm.com, oneukum@suse.com, gregkh@linuxfoundation.org, usb-storage@lists.one-eyed-alien.net, Jacky.Cao@sony.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi

>The unbind happens from inside the SCSI EH callback.  If that really is not allowed, we'll need to change it.  Or we can just change it regardless, since the effort required is pretty small.
>
>Kento, please try the patch below.  Does it help with your problem?

Thank you for suggestion about this problem.
I confirmed your patch fixes this problem.
I think you change policy for error handler to not calling unbind, right?
In addition, I have a question about this patch.
Could you please tell me why it should not be allowed that the unbind is occurred from eh callback?

This patch will ignore all error which is returned from usb_reset_and_verify_device.
But my patch will ignore error only being returned ENODEV case.
I think side effect of your patch is bigger than my patch.
So I want to know why the unbind is occurred from eh callback should not be allowed.

Regards,
Kento Kobayashi
