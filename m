From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 08/08] scsi: fix hot unplug sequence
Date: Wed, 23 Mar 2005 13:50:49 +0900
Message-ID: <4240F5A9.80205@gmail.com>
References: <20050323021335.960F95F8@htj.dyndns.org>	 <20050323021335.4682C732@htj.dyndns.org> <1111550882.5520.93.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from wproxy.gmail.com ([64.233.184.194]:15224 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262671AbVCWEu4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2005 23:50:56 -0500
Received: by wproxy.gmail.com with SMTP id 71so53097wri
        for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2005 20:50:54 -0800 (PST)
In-Reply-To: <1111550882.5520.93.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

  Hi,

James Bottomley wrote:
> On Wed, 2005-03-23 at 11:14 +0900, Tejun Heo wrote:
> 
>>	When hot-unplugging using scsi_remove_host() function (as usb
>>	does), scsi_forget_host() used to be called before
>>	scsi_host_cancel().  So, the device gets removed first without
>>	request cleanup and scsi_host_cancel() never gets to call
>>	scsi_device_cancel() on the removed devices.  This results in
>>	premature completion of hot-unplugging process with active
>>	requests left in queue, eventually leading to hang/offlined
>>	device or oops when the active command times out.
>>
>>	This patch makes scsi_remove_host() call scsi_host_cancel()
>>	first such that the host is first transited into cancel state
>>	and all requests of all devices are killed, and then, the
>>	devices are removed.  This patch fixes the oops in eh after
>>	hot-unplugging bug.
> 
> 
> This is actually simply reversing this patch:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=109268755500248
> 
> And all it does is give us the previous consequences back.
> 
> The oops isn't in the eh it's in the usb-storage eh routine.

  Well, but it's because scsi midlayer calls back into usb-storage eh 
after the detaching process is complete.

> However, the current host code does need fixing, but the fix is to move
> it over to a proper state model rather than the current bit twiddling we
> do.

  I agree & am working on it.  This patch was mainly to verify Jens' oops.

-- 
tejun

