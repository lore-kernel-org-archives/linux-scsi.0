From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] driver model/scsi: synchronize pm calls with probe/remove
Date: Tue, 22 Mar 2005 13:57:02 +0900
Message-ID: <423FA59E.5030406@gmail.com>
References: <20050321091846.GA25933@htj.dyndns.org> <d120d500050321064028e255fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from wproxy.gmail.com ([64.233.184.201]:1910 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262367AbVCVE6G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 23:58:06 -0500
Received: by wproxy.gmail.com with SMTP id 71so1423187wra
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2005 20:58:01 -0800 (PST)
In-Reply-To: <d120d500050321064028e255fe@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dtor_core@ameritech.net
Cc: mochel@digitalimplant.org, James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

  Hi, Dmitry.

Dmitry Torokhov wrote:
> On Mon, 21 Mar 2005 18:18:46 +0900, Tejun Heo <htejun@gmail.com> wrote:
> 
>>Hello, Dmitry, Mochel and James.
>>
>>I've been looking at sd code and found seemingly bogus 'if (!sdkp)'
>>tests with /* this can happen */ comment.  I've digged changelog and
>>found out that this was to prevent oops which occurs if some driver
>>gets stuck inside ->probe and the machine goes down and calls back
>>->remove.  IMHO, we should avoid this problem by fixing driver ->probe
>>or ->remove callbacks instead of detecting and bypassing
>>half-initialized/destroyed devices in pm callbacks.
>>
>>This patch read-locks a device's bus using device_pm_down_read_bus()
>>before invoking any pm callback.
> 
> 
> Hi Tejun,
> 
> There are talks about getting rid of bus's rwsem and replacing it with
> a per-device semaphore to serialize probe, remove, suspend and resume.
> This should resolve entire host of problems including this one, if I
> unrerstand it correctly.
> 
> Please take a look here:
> http://seclists.org/lists/linux-kernel/2005/Mar/5847.html
> 

  Yeap, sounds great.  Hmmm.. as the final result will (and should) be 
the same for inidividual drivers (no overlapping callback invocations), 
how about incorporating my patch before implementing the proposed fix 
such that we can get rid of the awkward semantic first?  The proposed 
change should change the same part of code anyway, so I don't think this 
would be a hassle.

  Thanks.

-- 
tejun

