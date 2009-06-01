From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC][PATCH] Introduce the parameter to limit scsi timeout
 count
Date: Mon, 01 Jun 2009 20:02:38 +0000
Message-ID: <1243886558.4203.31.camel@mulgrave.int.hansenpartnership.com>
References: <4A2428B5.9000701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33264 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754618AbZFAUCm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jun 2009 16:02:42 -0400
In-Reply-To: <4A2428B5.9000701@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Takahiro Yasui <tyasui@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2009-06-01 at 15:15 -0400, Takahiro Yasui wrote:
> Hi,
> 
> I would like to solve an issue related to scsi timeout.
> 
> A storage can break down in the way that it does not respond to
> scsi commands such as read/write, while a storage successfully
> respond to scsi commands such as test unit ready.
> (It may depend on implementation of storage.)
> 
> When this type of a device trouble happens, the scsi-mid layer
> detects timeout for the device and the scsi-mid layer tries to
> recover the error. Then, scsi-mid layer detects that the device
> has been recovered by the result of Test Unit Ready.
> 
> Therefore, the state of the device is not changed to offline
> and user application can continue to issue I/Os to the device.
> This may cause timeout errors repeatedly on the same device,
> and application can not do proper actions quickly.
> 
> To solve this issue, let me propose the sysfs parameter to
> limit scsi timeout count in scsi-mid layer. This parameter
> is tunable as a module parameter to address the issue at
> system boot.
> 
> * example
> 
>  - Limit a scsi timout count to 1
>     # echo 1 > /sys/block/<sdX>/device/max_timeout_cnt
> 
>  - Display a current timeout count
>     # cat /sys/block/<sdX>/device/iotimeout_cnt
> 
>  - Load scsi module with a default scsi timeout count (5)
>     # insmod scsi_mod.ko max_timeout_count=5
> 
> I appreciate your comments and suggestions.

It doesn't really look like a good solution to the problem you're
describing, particularly if it's just a few isolated arrays.

The code you propose would certainly catch things like usb devices which
are known for random timeouts; plus a lot of SCSI/ATA devices suffer
isolated timeouts because of I/O load.  Global code like this could end
up offlining them.

Which arrays are these, and what's the taxonomy of the failure ... if
TUR succeeds, perhaps there's another command for the arrays we could
send that would fail or timeout ... or perhaps there's a different way
they should be recovered.

James


