From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/3] libosd: osd_dev_info: Unique Identification of an
 OSD device
Date: Sun, 27 Sep 2009 10:13:28 +0200
Message-ID: <4ABF1EA8.3020000@panasas.com>
References: <4AA4ED94.2050805@panasas.com>	 <1252322784-19390-1-git-send-email-bharrosh@panasas.com> <1253123262.4842.39.camel@mulgrave.site> <4AB21D55.9040000@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:18222 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753390AbZI0IN1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Sep 2009 04:13:27 -0400
In-Reply-To: <4AB21D55.9040000@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

On 09/17/2009 02:28 PM, Boaz Harrosh wrote:
> On 09/16/2009 08:47 PM, James Bottomley wrote:
>>> +		sprintf(dev_str, "/dev/osd%d", i);
>>
>> Embedding specific forms user device paths into the kernel really looks
>> wrong here ... why are you doing this?  What happens if the user uses
>> udev to give them different names?
>>
> Two things
> 
> [1]
> These names are created here below, exactly as shown. Now udev usually
> creates more links and soft-links, I've never seen a delete?
> (I agree that maybe a comment or a define could help readability as this
>  format string is repeated twice, though slightly different).
> Lets say that "udev can do anything but not delete the primary file created
> by Kernel", as a prerequisite.
> 
> [2]
> I could easily just add a global device list, like all the other parts of
> the Kernel are trigger happy to shoot this problem.
> But I hate it.
> All these devices are already held on a Kernel structure called the name_space.
> The life_time rules, locking, reference counting, and visibility, is bug-free and
> tried out to the bone. Why should I have to reinvent the wheel? Why introduce all
> these subtle corner cases, and sleepless debugging nights?
> 
> The way I see it Kernel keeps my devices for me and gives me a "Key" to fetch for
> them. The key is the name.
> 
> That said. I'll do what people want, it is 5 minutes to put all these on a global
> list_head. It's not lack of effort on my part.
> 

I'm resending the same patch with minor changes:
1. Same defined format-string is now used both at creation of device
   and at look-up, so it is clear that these must and are the same.
2. I've added a comment to osduld_info_lookup that documents it's behavior
   So it should be clear from the get go and there are no surprises.

I'm using this code for a long time now, under a pNFS setups, and what can
I say, it does the job. 
Also I like the fact that I can use the same code as osduld_path_lookup()
and open a file handle on the device, which solved some bugs in the past.

Please consider for inclusion.

The other two trivial patches are independent please include those as well.

(I'll post as ver2 in reply to original patch)

Thanks
Boaz
