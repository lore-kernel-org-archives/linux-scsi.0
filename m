From: Tejun Heo <htejun@gmail.com>
Subject: Re: Kernel oops: 2.6.16-rc3-mm1 dvd mount
Date: Mon, 20 Feb 2006 23:17:41 +0900
Message-ID: <43F9CF85.1020500@gmail.com>
References: <43F4A5FE.3080601@feise.com> <43F96743.9050103@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pproxy.gmail.com ([64.233.166.177]:56917 "EHLO pproxy.gmail.com")
	by vger.kernel.org with ESMTP id S964935AbWBTORy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2006 09:17:54 -0500
Received: by pproxy.gmail.com with SMTP id i75so1112826pye
        for <linux-scsi@vger.kernel.org>; Mon, 20 Feb 2006 06:17:51 -0800 (PST)
In-Reply-To: <43F96743.9050103@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jfeise@feise.com
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@suse.de>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Tejun Heo wrote:
> This oops happened because get_request() was invoked with NULL @q.  It 
> seems like SCSI midlayer refcounting mixup.  I'll dig deeper and report 
> again as soon as I can find something concrete.

Hello, all & James.

I've bisected the patch series and the winner is #221 
git-scsi-misc.patch which seems to contain eight commits. I think SCSI 
people can hunt this down from now on. The bug happens whenever sr block 
device is accessed - mount, cat, whatever, and now it seems like some 
kind of data overrun.

Hope it helped.

-- 
tejun
