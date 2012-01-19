From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what'smissing?
Date: Thu, 19 Jan 2012 12:44:10 -0500
Message-ID: <4F18566A.2060107@redhat.com>
References: <4EF2026F.2090506@redhat.com> <DBFB1B45AF80394ABD1C807E9F28D157077DD22B19@BLRX7MCDC203.AMER.DELL.COM> <20111222155849.GD1388@redhat.com> <DBFB1B45AF80394ABD1C807E9F28D157077DD22D79@BLRX7MCDC203.AMER.DELL.COM> <4F0ADB0A.9020707@suse.de> <1326113987.2580.8.camel@localhost.localdomain> <D3F292ADF945FB49B35E96C94C2061B9159134BD@nsmail.netscout.com> <4F18429C.3020803@redhat.com> <D3F292ADF945FB49B35E96C94C2061B9159134EF@nsmail.netscout.com> <4F1844F0.1030406@redhat.com> <D3F292ADF945FB49B35E96C94C2061B9159135BF@nsmail.netscout.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756762Ab2ASRqj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 12:46:39 -0500
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B9159135BF@nsmail.netscout.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Loke, Chetan" <Chetan.Loke@netscout.com>
Cc: Tom Coughlan <coughlan@redhat.com>, Hannes Reinecke <hare@suse.de>, tasleson@redhat.com, Shyam_Iyer@Dell.com, vgoyal@redhat.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

On 01/19/2012 12:32 PM, Loke, Chetan wrote:
>>> True, a single front-end won't see all of those LUNs/devices. So not
>> a
>>> big concern
>>> about the front-end hosts.
>>>
>>> I am thinking of a use-case where folks can use a linux-box to
> manage
>>> their different storage arrays.
>>> So this linux box with 'libstoragemgmt + app' needs to
>>> manage(scan/create/delete/so on) all those LUNs.
>>>
>> People do have boxes with thousands of luns though&  file systems in
>> active use.
>> Both for SAN and NAS volumes.
>>
>> One of the challenges is what to do when just one LUN (or NFS server)
>> crashes
>> and burns.
> The FS needs to go read-only(plain&  simple) because you don't know
> what's going on.
> You can't risk writing data anymore. Let the apps fail. You can make it
> happen even today.
> It's a simple exercise.

Nope - it needs to be torn down and we need to be able to cleanly unmount it.

Letting an application see and read-only file system when the disk is gone or 
server down is not very useful since you won't get any non-cached data back.

Also, if you have an ability to migrate that mount (same mount point) to another 
server or clone LUN, you want to unmount the source so you can remount the data 
under that same mount point/namespace....

ric

>
> Like others, I have seen/debugged enough weirdness when it comes to
> resets/aborts(FYI - 200+ hosts in a cluster).
> Because of NDA reasons I can't disclose a whole lot but folks have
> fixed/enhanced
> scsi stack to make resets/aborts fully robust. And you need folks who
> can debug
> 'apps/FS/block/initiator/wire-protocol/target-side' in one shot. Simple.
> So when you say 'crash&  burn' then either or 'all' of the above(minus
> the protocol handling) might need fixing.
>
>> You simply cannot "reboot" the server to clean up after one
>> bad mount when you have thousands of other happy users runs on
> thousands/hundreds
>> of other mount points :)
> Again, can't front-end can go read only and limit the outage w/o
> disturbing thousands of users?
>
>
> Chetan Loke

