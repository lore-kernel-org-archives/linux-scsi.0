From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] make fc transport removal of target configurable
Date: Tue, 13 Jun 2006 14:37:39 -0500
Message-ID: <448F1403.6090903@sgi.com>
References: <448DF5DA.3070800@sgi.com>	 <20060613070714.GA16358@infradead.org> <448E9C34.6070707@emulex.com>	 <448EDCEB.50702@sgi.com> <1150221599.3441.54.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:28392 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751184AbWFMThv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jun 2006 15:37:51 -0400
In-Reply-To: <1150221599.3441.54.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: James.Smart@Emulex.Com, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>



James Bottomley wrote:
> On Tue, 2006-06-13 at 10:42 -0500, Michael Reed wrote:
>> Mounted file systems have no clue either.  Even with no activity on the
>> fs, if the target stays missing beyond the device loss timeout and then
>> returns, the file system cannot be accessed without intervention.
>>
>> When the target does return, the file system has to be unmounted and
>> remounted on a new "sd" device.  This is even if there was no activity
>> on the file system while its target was absent, i.e., it wouldn't otherwise
>> require an unmount/remount.
> 
> But lets examine the options:  If you leave an uncontactable target
> hanging around, the SCSI error handler will activate anyway when the
> command timeout passes (currently 30s) and the device will be offlined.

Not really true as the transport holds off the error handler until the
transport dev loss timer expires.

And afterwards, commands are returned immediately with DID_NO_CONNECT.
The device is never offlined (with my patch applied).

> Bringing it back online will require user intervention and likely
> necessitate an unmount and a remount to repair the filesystem anyway.

With the unpatched code, the device transitions from ONLINE - BLOCKED - CANCEL -
DEL.  Then the infrastructure is removed.  With the new code, it
transitions from ONLINE - BLOCKED - ONLINE.  Subsequent access to the
device results in i/o errors with a status of DID_NO_CONNECT.

	duck /root# dd if=/dev/md0 bs=128k count=1 of=/dev/null
	sd 5:0:13:0: SCSI error: return code = 0x10000
	end_request: I/O error, dev sdj, sector 0
	Buffer I/O error on device md0, logical block 0
	sd 5:0:11:0: SCSI error: return code = 0x10000
	end_request: I/O error, dev sdh, sector 0
	Buffer I/O error on device md0, logical block 4dd:
	reading `/dev/md0'sd 5:0:13:0: SCSI error: return code = 0x10000
	: Input/output error

The layer issuing the i/o can decide what to do with the device.

> Even if you go further and hold off the error handler, what this will do
> is slowly hang the system since anything that touches an inode on the
> blocked target will be put into D wait.  I really think pro-actively
> removing the target is better than either of the other two options.

The error handler is only held off during the dev loss period.  Once
the timer expires, the target is unblocked and pending commands issue
and terminate with DID_NO_CONNECT.  If there are no pending commands,
nothing bad happens.  Many multi-path drivers know to change paths when
"EIO" is returned, so, no EIO, no path switch, even if a prolonged
absence occurs.

The system does not slowly hang.  It remains responsive and behaves in
an expected manner.

> 
> The device loss timer represents an acceptable compromise between the
> need to keep the target across short disconnect/reconnect events and the
> need to keep the system functioning.

The new parameter doesn't really change the usage of the device loss timer.
It still will result in failed i/o when it expires.  It just leaves the
infrastructure around so that if/when the target returns, the reference
holders can resume using it.  This is the desired behavior.

The system remains fully functional with no unexpected delays.

Mike

> 
> James
> 
> 
