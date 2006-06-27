From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] scsi_scan.c: bug fix: starget use after free issue
Date: Tue, 27 Jun 2006 12:39:02 -0400
Message-ID: <44A15F26.3070608@emulex.com>
References: <1150390560.29774.32.camel@localhost.localdomain> <1151423925.3340.32.camel@mulgrave.il.steeleye.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50834 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1161180AbWF0QjH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jun 2006 12:39:07 -0400
In-Reply-To: <1151423925.3340.32.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

And we've already seen this, even without this change - e.g. the target was
2/3's torn down when we created a new one....

what this really sounds like then is that we need to stop the teardown and
reuse the structure - or - figure out a way to make the kobj teardown happen
sooner so that we reuse the namespace (or disconnect the namespace and the
structures).

-- james

James Bottomley wrote:
> On Thu, 2006-06-15 at 12:55 -0400, James Smart wrote:
>> When reaping the starget, after all sdev's have been removed, the starget
>> was queued for deletion via usercontext, but was left on the shost's
>> __targets list. Another scanning thread can match the starget and use it, 
>> causing reference after free problems.
>>
>> This patch unlinks the starget at the same time it is scheduled for deletion.
>>
> This cannot be done this way.  The problem it will introduce is that
> we'll think the target has gone and possibly reallocate its name before
> device_del is called on it (which means if the new device gets added, it
> will return -EEXIST and everything will go wrong).
> 
> Where is the actual reference coming from ... perhaps the using place
> should simply be checking the state.
> 
> James
> 
> 
> 
