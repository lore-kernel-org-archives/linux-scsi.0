From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Fri, 16 Jan 2009 00:24:51 +0100
Message-ID: <496FC5C3.1010401@s5r6.in-berlin.de>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp> <496E4B93.4000507@cybernetics.com> <20090114213917.GB22543@kroah.com> <496E6853.1010005@s5r6.in-berlin.de> <496E6CE1.9040404@cybernetics.com> <496E7993.70307@s5r6.in-berlin.de> <496F4C7B.2030707@cybernetics.com> <496F62CC.8000007@s5r6.in-berlin.de> <496F7DB6.6090506@cybernetics.com> <496F84AA.9060708@s5r6.in-berlin.de> <496F8C91.9050208@cybernetics.com> <496FA001.1000501@s5r6.in-berlin.de> <496FAE09.2040207@cybernetics.com> <496FB168.6080407@s5r6.in-berlin.de> <496FB744.90501@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45861 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258AbZAOXZ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 18:25:27 -0500
In-Reply-To: <496FB744.90501@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Greg KH <greg@kroah.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

Tony Battersby wrote:
> Stefan Richter wrote:
>> I wrote that there is a bug if you have a reference while the reference
>> count is zero.
>>   
> Being pragmatic, I call that a _philosophical_ objection rather than a
> bug because the code does actually work in practice as far as I can
> tell.  But you can call it a bug if you like.  If you want me to give in
> and call it a bug, then you will have to come up with an actual case
> where the code fails to do the right thing - memory use after free,
> double free, memory leak, oops, etc.

I understood that you want to fix bugs which are caused by lack of
reference counting.

You fix it by /reference count estimation/.
(Yet you could also fix it by /reference counting/.)

Actual reference counting would have the benefit that it works not only
right after your fix, but it will continue to work when people proceed
to modify sg, provided they follow the sound, proven, straight-forward,
familiar rules of reference counting:
  - r++ when a copy of a reference is made.
  - r-- when a reference is given up.
Sure, it will also continue to work if those who modify sg follow the
ad-hoc rules of your special reference count estimation, which are:
  - ...
  - ...
  - ...

I recommend to stick to the semantics of "refcount == 0 means there is
no reference anymore" because it's simple and robust.  This is
pragmatism.  I recommend it over "refcount == 0 means that there are,
hmm, still some references somewhere, but believe me, you can ignore
those" because that's not very pragmatic in code which is supposed to be
maintainable and to not crash people's machines.

In the subsystems which I maintain, I made the experience that reference
counting is easier to get right and keep right than some locking tricks
around reference stores or whatever other lifetime assumptions.

Anyway.  Fix sg in whatever way you prefer; you are doing the work, your
opinion counts.  Mine doesn't, as I don't contribute the code.

(I spoke up nevertheless because the idea came up in this thread to
change lib/kref in a way which is only useful to buggy refcounting.
This worried me..)
-- 
Stefan Richter
-=====-==--= ---= -====
http://arcgraph.de/sr/
