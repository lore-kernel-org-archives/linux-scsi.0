From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH][SCSI] sr: Remove sr_mutex just like sd_module to optimize
 multi-drive performance
Date: Tue, 05 Nov 2013 10:03:47 -0700
Message-ID: <527924F3.7090800@kernel.dk>
References: <CAO4Pk4xtaz2qwNJcfkNqK3CMAccGqr-i7UK+=fB0yxyoLp=tmA@mail.gmail.com> <52792039.2020405@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:34933 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab3KEREG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2013 12:04:06 -0500
In-Reply-To: <52792039.2020405@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, yang jun <yangjun.donglife123@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11/05/2013 09:43 AM, Douglas Gilbert wrote:
> On 13-11-01 11:46 AM, yang jun wrote:
>> The sr_mutex is not necessary, so we can delete it.
> 
> It is ironic that you are removing a mutex that serializes
> the access to various calls in the sr driver at the same
> time we are proposing to add a mutex to the open()
> and release() calls in the sg driver. The sg driver's
> proposed mutex is finer grained than sr_mutex: one per
> device.
> 
> My guess would be that splitting sr_mutex out to
> a per device mutex will be safer and get the performance
> gain that you seem to be after.

Agree - the mutex should be retained, but make it per-device instead.
That will fix your original issue as well.

-- 
Jens Axboe

