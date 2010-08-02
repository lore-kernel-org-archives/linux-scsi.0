From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] relaxed barrier semantics
Date: Mon, 02 Aug 2010 14:38:18 +0400
Message-ID: <4C56A01A.1050107@vlnb.net>
References: <20100729194904.GA17098@lst.de> <4C51DCF1.3010507@redhat.com> <25F5E16E-968D-4FEF-8187-70453985B19B@dilger.ca> <20100729230406.GI4506@thunk.org> <4C52CBFF.6090406@vlnb.net> <20100730130957.GA26894@lst.de> <4C52D2E0.5000609@vlnb.net> <20100730133410.GA27996@lst.de> <4C52D728.6070008@vlnb.net> <20100730142025.GA29341@lst.de> <20100731004756.GC3273@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:55587 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab0HBKid (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2010 06:38:33 -0400
In-Reply-To: <20100731004756.GC3273@quack.suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>
Cc: Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Ric Wheeler <rwheeler@redhat.com>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

Jan Kara, on 07/31/2010 04:47 AM wrote:
> On Fri 30-07-10 16:20:25, Christoph Hellwig wrote:
>> On Fri, Jul 30, 2010 at 05:44:08PM +0400, Vladislav Bolkhovitin wrote:
>>> Yes, but why not to make step further and allow to completely eliminate
>>> the waiting/draining using ORDERED requests? Current advanced storage
>>> hardware allows that.
>>
>> There is a few caes where we could do that - the fsync without metadata
>> changes above would be the prime example.  But there's a lot lower
>> hanging fruit until we get to the point where it's worth trying.
>    Umm, I don't understand you. I think that fsync in particular is an
> example where you have to wait and issue cache flush if the drive has
> volatile write cache. Otherwise you cannot promise to the user data will be
> really on disk in case of crash. So no ordering helps you.

Isn't there the second wait for journal update?

>    And if you are speaking about a drive without volatile write caches, then
> fsync without metadata changes is just trivial and you don't need any
> ordering.

A drive can reorder queued SIMPLE requests at any time doesn't matter if 
it has volatile write caches or not. So, if you expect in-order requests 
execution (with journal updates you do?), you need to enforce that order 
either by ORDERED requests or (local) queue draining.

Vlad
