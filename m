From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] driver model/scsi: synchronize pm calls with probe/remove
Date: Mon, 21 Mar 2005 09:40:04 -0500
Message-ID: <d120d500050321064028e255fe@mail.gmail.com>
References: <20050321091846.GA25933@htj.dyndns.org>
Reply-To: dtor_core@ameritech.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Received: from rproxy.gmail.com ([64.233.170.207]:60064 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261799AbVCUOkF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 09:40:05 -0500
Received: by rproxy.gmail.com with SMTP id g11so1013173rne
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2005 06:40:04 -0800 (PST)
In-Reply-To: <20050321091846.GA25933@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: mochel@digitalimplant.org, James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 21 Mar 2005 18:18:46 +0900, Tejun Heo <htejun@gmail.com> wrote:
> Hello, Dmitry, Mochel and James.
> 
> I've been looking at sd code and found seemingly bogus 'if (!sdkp)'
> tests with /* this can happen */ comment.  I've digged changelog and
> found out that this was to prevent oops which occurs if some driver
> gets stuck inside ->probe and the machine goes down and calls back
> ->remove.  IMHO, we should avoid this problem by fixing driver ->probe
> or ->remove callbacks instead of detecting and bypassing
> half-initialized/destroyed devices in pm callbacks.
> 
> This patch read-locks a device's bus using device_pm_down_read_bus()
> before invoking any pm callback.

Hi Tejun,

There are talks about getting rid of bus's rwsem and replacing it with
a per-device semaphore to serialize probe, remove, suspend and resume.
This should resolve entire host of problems including this one, if I
unrerstand it correctly.

Please take a look here:
http://seclists.org/lists/linux-kernel/2005/Mar/5847.html

-- 
Dmitry
