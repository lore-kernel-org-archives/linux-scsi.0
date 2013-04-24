From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: T10 WCE interpretation in Linux & device level access
Date: Wed, 24 Apr 2013 07:00:36 -0400
Message-ID: <5177BB54.9090905@redhat.com>
References: <5176E3E8.3000809@redhat.com> <1366747622.1939.6.camel@dabdike> <51770DAA.4020409@tributary.com> <94D0CD8314A33A4D9D801C0FE68B402950DFB8F2@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397Ab3DXLAw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Apr 2013 07:00:52 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402950DFB8F2@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Jeremy Linton <jlinton@tributary.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "Black, David" <david.black@emc.com>, "Knight, Frederick" <Frederick.Knight@netapp.com>

Hi Rob,

Comments inline below.

On 04/24/2013 01:44 AM, Elliott, Robert (Server Storage) wrote:
> If the writeback cache is enabled (per the WCE bit in the Caching mode page),
> prudent software uses the FUA bit in WRITE commands when writing metadata
> and/or sends the SYNCHRONIZE CACHE command at important checkpoints to
> ensure the data is not going to be lost due to a power loss.  Some
> database software is particularly prolific at sending these commands.
>
> Around 2003, many RAID controllers with non-volatile writeback caches honored
> the SYNCHRONIZE CACHE command, flushing the entire cache to the drives.  This
> started causing timeouts as non-volatile write cache sizes grew.  Recently,
> it's even causing trouble on individual disk drives with growing volatile
> write caches.
>
> The intent of software using these commands and bits was unclear - it could be:
> a) ensure data is in non-volatile cache (and will eventually be flushed)
>     or on the medium; or
> b) ensure data is on the medium (so the drives are ready for removal).



Linux issues SYNCHRONIZE_CACHE commands when we need to make sure that the data 
needs to be crash safe (after a transaction commit from a file system journal, 
an explicit fsync call or write system call with O_SYNC set).

If the cache is nonvolatile (i.e., the target will have it after a power outage 
or reboot), we are fine - pretty much your (a) clause above.

Not sure we have thought through (or can control) how an array would handle 
pulling a drive from behind a RAID controller that has not flushed its state.
>
> As a short-term fix, many RAID controllers assumed intent (a) and started
> interpreting the SYNCHRONIZE CACHE command as a NOP and ignoring the FUA bit.

We have seen problems with some RAID controllers that leave the write cache 
enabled on back end drives - their cache is battery backed, but the cache on 
those backend drives is exposed to certain data loss on a power outage.

It would be nice if they always disabled the write cache on the backend drives 
*or* advertised WCE and propagated the SYNCHRONIZE_CACHE commands to each drive 
when we send them down.
>
> Surprise removal of a drive from a RAID controller is risky even if software
> has run SYNCHRONIZE CACHE, since the RAID controller might be doing other
> activity in the background. So, there are other reasons to justify assuming
> that the user just won't do that.
>
> Afraid of breaking software with intent (b) (which was more likely in the
> days of floppy disks, Bournelli Boxes, and other removable block devices),
> T10 chose to clarify that the original meaning was (b) and added new
> FUA_NV and SYNC_NV bits to let software express intent (a).  The hope
> was that devices would implement the bits and software would start using
> them at appropriate times.
>
> Unfortunately, the short-term fix worked well enough that it still prevails
> today, and most standalone removable media block devices have disappeared.
> There is not much software actually sending the FUA_NV and SYNC_NV bits
> and few devices honoring the bits per the standard.
>
> As an SBC-3 letter ballot comment, I recently submitted T10 proposal
> 13-050 (see http://www.t10.org/doc13.htm) to obsolete the SYNC_NV and
> FUA_NV bits and change the meaning of the commands without those bits
> to intent (a), reflecting what the industry has actually done.

This is definitely something that we should review and take into account going 
forward.

It does sound like we have a lot of confusion around WCE meaning in the storage 
industry today though, which leads me to think that we will need to allow raw 
block accessing applications to manually override our flush settings (reluctantly!).

Regards,

Ric

>
>
>
>
>
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Jeremy Linton
> Sent: Tuesday, April 23, 2013 5:40 PM
> To: James Bottomley
> Cc: Ric Wheeler; linux-scsi@vger.kernel.org; Martin K. Petersen; Jeff Moyer; Tejun Heo; Mike Snitzer; dgilbert@interlog.com
> Subject: Re: T10 WCE interpretation in Linux & device level access
>
> On 4/23/2013 3:07 PM, James Bottomley wrote:
>
>> I bet they don't; they probably obey the spec.  There's a SYNC_NV bit
>> which if unset (which it is in our implementation) means only sync your
>> non-NV cache.  For a device with all NV, that equates to nop.
> 	Yes, linux leaves the SYNC_NV bit unset in scsi_setup_flush_cmnd().
>
> The draft specs, and a couple others I have laying about says: says the device
> shall sync cache to medium for both volatile and non volatile cache data if
> SYNC_NV is _unset_.
>
> With it set, the table could be more confusing!
>
> For volatile cache blocks with SYNC_NV set "If a non-volatile cache is present,
> then the device server shall synchronize to non-volatile cache or to the medium.
> If a non-volatile cache is not present, then the device server shall synchronize
> to the medium".
>
> And for Non-volatile cache with it set "No Requirement"
>
>
> Which to me says, don't expect any particular behavior if you set this bit and
> have NV it could flush to medium, flush to NV cache, or do nothing at all. But
> it seems pretty clear that with it unset its probably going to get synchronized
> to the medium.
>
>
> If T10 were to do something, maybe they could stop putting bits in the docs that
> aren't guaranteed to do anything (fill in rant).
>
> As for linux, seems the state of the spec really doesn't leave any good options
> other than provide the user the ability to disable the flush_cmnd() if  the
> NV_SUP bit is set. Or maybe a white list (ick!)...
>
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

