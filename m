From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what'smissing?
Date: Thu, 19 Jan 2012 16:39:53 -0500
Message-ID: <4F188DA9.3050804@redhat.com>
References: <4EF2026F.2090506@redhat.com> <DBFB1B45AF80394ABD1C807E9F28D157077DD22B19@BLRX7MCDC203.AMER.DELL.COM> <20111222155849.GD1388@redhat.com> <DBFB1B45AF80394ABD1C807E9F28D157077DD22D79@BLRX7MCDC203.AMER.DELL.COM> <4F0ADB0A.9020707@suse.de> <1326113987.2580.8.camel@localhost.localdomain> <D3F292ADF945FB49B35E96C94C2061B9159134BD@nsmail.netscout.com> <4F18429C.3020803@redhat.com> <D3F292ADF945FB49B35E96C94C2061B9159134EF@nsmail.netscout.com> <4F1844F0.1030406@redhat.com> <D3F292ADF945FB49B35E96C94C2061B9159135BF@nsmail.netscout.com> <4F18566A.2060107@redhat.com> <D3F292ADF945FB49B35E96C94C2061B915913815@nsmail.netscout.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127Ab2ASVmV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 16:42:21 -0500
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B915913815@nsmail.netscout.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Loke, Chetan" <Chetan.Loke@netscout.com>
Cc: Tom Coughlan <coughlan@redhat.com>, Hannes Reinecke <hare@suse.de>, tasleson@redhat.com, Shyam_Iyer@Dell.com, vgoyal@redhat.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

On 01/19/2012 04:30 PM, Loke, Chetan wrote:
>> From: Ric Wheeler [mailto:rwheeler@redhat.com]
>> Sent: January 19, 2012 12:44 PM
>> To: Loke, Chetan
>> Cc: Tom Coughlan; Hannes Reinecke; tasleson@redhat.com;
>> Shyam_Iyer@Dell.com; vgoyal@redhat.com; linux-fsdevel@vger.kernel.org;
>> linux-scsi@vger.kernel.org
>> Subject: Re: [LSF/MM TOPIC] linux servers as a storage server -
>> what'smissing?
>>
>> On 01/19/2012 12:32 PM, Loke, Chetan wrote:
>>>>> True, a single front-end won't see all of those LUNs/devices. So
>> not
>>>> a
>>>>> big concern
>>>>> about the front-end hosts.
>>>>>
>>>>> I am thinking of a use-case where folks can use a linux-box to
>>> manage
>>>>> their different storage arrays.
>>>>> So this linux box with 'libstoragemgmt + app' needs to
>>>>> manage(scan/create/delete/so on) all those LUNs.
>>>>>
>>>> People do have boxes with thousands of luns though&   file systems
> in
>>>> active use.
>>>> Both for SAN and NAS volumes.
>>>>
>>>> One of the challenges is what to do when just one LUN (or NFS
>> server)
>>>> crashes
>>>> and burns.
>>> The FS needs to go read-only(plain&   simple) because you don't know
>>> what's going on.
>>> You can't risk writing data anymore. Let the apps fail. You can make
>> it
>>> happen even today.
>>> It's a simple exercise.
>> Nope - it needs to be torn down and we need to be able to cleanly
>> unmount it.
>>
>> Letting an application see and read-only file system when the disk is
>> gone or
>> server down is not very useful since you won't get any non-cached data
>> back.
>>
> Sure, it's just a partial snapshot(aka cached-data) of the file-system.
>
> But writes that have to fetch the non-cached data, will unnecessarily
> issue I/O to the fabric. These orphaned I/O's cause more pain in the
> cleanup.
> And if caching is enabled on the front-side then it's all the more
> painful.
>
> We can go one extra step and make FS fail read I/O for non-cached data
> too
> to avoid more orphan IOs.

I don't really see this as a useful state. Read-only without a real backing file 
system or LUN is hit or miss, that file system should go offline :)

>
> Tearing down will happen sometime later. But don't you agree that
> something needs
> to happen before that? And that something is, read-only, which will
> eventually
> propagate to the users(example when you are copying a new file).
> Users will then report it to their IT/admins.
> This approach of serving the snap-shot(cached) file-system could serve
> some users for what it's worth. It's better than surprise-removal and
> issuing
> needless IOs(read - eh race conditions).
>
>> Also, if you have an ability to migrate that mount (same mount point)
>> to another
>> server or clone LUN, you want to unmount the source so you can remount
>> the data
>> under that same mount point/namespace....
>>
> Won't this be protocol specific.
>

Not really protocol specific. We need to be able to do a forced unmount and then 
do fail over (that varies depending on many things like your HA frame work and 
certainly the type of thing you are attempting to fail over)

Ric

