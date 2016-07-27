From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [dm-devel] dm-mq and end_clone_request()
Date: Wed, 27 Jul 2016 12:06:12 -0700
Message-ID: <81581dc1-46d1-193b-748f-54a0524634f6@sandisk.com>
References: <20160720142727.GA57399@redhat.com>
 <1ca6d31d-f175-9daa-9ddd-17d653851ceb@sandisk.com>
 <20160720183321.GA20223@redhat.com>
 <84d9dc64-0c10-ed1a-7bc1-e656874853a5@sandisk.com>
 <20160725175344.GA23000@redhat.com> <20160725212325.GA23961@redhat.com>
 <1490356d-2c0e-d94a-7a88-5e8bc89953ef@sandisk.com>
 <20160726011607.GA77078@redhat.com>
 <577bc6d5-9c78-b6d3-10f7-10626c0da516@sandisk.com>
 <20160727140828.GA5692@redhat.com>
 <20160727155215.GA12197@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0065.outbound.protection.outlook.com ([104.47.38.65]:32448
	"EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757190AbcG0TGV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2016 15:06:21 -0400
In-Reply-To: <20160727155215.GA12197@octiron.msp.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Marzinski <bmarzins@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 07/27/2016 08:52 AM, Benjamin Marzinski wrote:
> if you look in drivers/md/dm-ioctl.c at do_resume(), device mapper
> internally does a suspend when you call resume with a new table loaded.
> That's when these suspends are happening.
>
> In the userspace tools, this happens in the DM_DEVICE_RESUME calls after
> dm_addmap_reload(), which loads the new table.  These all happen in the
> domap() function.

Thanks Ben for chiming in. As far as I can see md->map is only used in 
the I/O submission path but not in the I/O completion path. So why to 
suspend and resume I/O before activating the new map? Do you think it 
would be safe to activate the new map without suspending and resuming I/O?

Thanks,

Bart.
