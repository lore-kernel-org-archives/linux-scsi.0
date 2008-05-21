From: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 1/3][-mm] add class_reclassify macro
Date: Wed, 21 May 2008 10:05:42 +0800
Message-ID: <a8e1da0805201905p4c74f309r4dc09ee919102a1d@mail.gmail.com>
References: <20080520095553.GA3201@darkstar.te-china.tietoenator.com>
	 <20080520030232.fc91b64e.akpm@linux-foundation.org>
	 <a8e1da0805200405t10fae448w589449e75a5abec6@mail.gmail.com>
	 <20080520103045.2bb0a033.akpm@linux-foundation.org>
	 <20080520173640.GP2638@parisc-linux.org>
	 <20080520122356.63bd0000.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:36365 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595AbYEUCFq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 May 2008 22:05:46 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1280542tic.23
        for <linux-scsi@vger.kernel.org>; Tue, 20 May 2008 19:05:43 -0700 (PDT)
In-Reply-To: <20080520122356.63bd0000.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, greg@kroah.com, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, May 21, 2008 at 3:23 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 20 May 2008 11:36:41 -0600
> Matthew Wilcox <matthew@wil.cx> wrote:
>
>> On Tue, May 20, 2008 at 10:30:45AM -0700, Andrew Morton wrote:
>> > Well what are these lockdep warnings?  Normally such a warning means that
>> > we have a locking bug. I _assume_ that you've determined that the warnings
>> > are false-positives?
>>
>> Andrew, we already discussed this on the thread you started that you
>> then ignored ...
>
> rofl.
>
> All pertinent information should be in a patch's changelog.  Then this
> sort of confusion will not occur.

My wrong. should do this in advance.

>
>> > The warning which Mariusz Kozlowski discovered ("Subject: Re:
>> > 2.6.26-rc2-mm1: possible circular locking dependency detected") was
>> > triggered by the "class semaphore to mutex" conversion and it looks
>> > like a real bug to me.  Would your patch prevent warnings such as that
>> > one from being available to us?
>>
>> The problem is that you add one type of class which then adds devices
>> that are of another class.  This is not a bug.  My proposal is to give
>> each sysfs class its own lock class; Dave's is to only do it for the
>> two classes he knows about that do this.
>
> Well that sounds reasonable.  I'm not sure that we should introduce
> generic-looking helper infrastructure to do it, however.
>
> Anyway I'll happily sit back and let you guys and Greg sort this one out ;)
>
