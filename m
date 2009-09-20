From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: MD/RAID time out writing superblock
Date: Sun, 20 Sep 2009 12:46:27 -0600
Message-ID: <4AB67883.3010500@gmail.com>
References: <20090917115728.GA13854@arachsys.com> <4AB2596D.10809@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4AB2596D.10809@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Chris Webb <chris@arachsys.com>, Neil Brown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

On 09/17/2009 09:44 AM, Tejun Heo wrote:
>> Thanks Neil. This implies that when we see these fifteen second
>> hangs reading /proc/mdstat without write errors, there are genuinely
>> successful superblock writes which are taking fifteen seconds to
>> complete, presumably corresponding to flushes which complete but
>> take a full 15s to do so.
>>
>> Would such very slow (but ultimately successful) flushes be
>> consistent with the theory of power supply issues affecting the
>> drives? It feels like the 30s timeouts on flush could be just a more
>> severe version of the 15s very slow flushes.
>
> Probably not.  Power problems usually don't resolve themselves with
> longer timeout.  If the drive genuinely takes longer than 30s to
> flush, it would be very interesting tho.  That's something people have
> been worrying about but hasn't materialized yet.  The timeout is
> controlled by SD_TIMEOUT in drivers/scsi/sd.h.  You might want to bump
> it up to, say, 60s and see whether anything changes.

It's possible if the power dip only slightly disrupted the drive it 
might just take longer to complete the write. I've also seen reports of 
vibration issues causing problems in RAID arrays (there's a video on 
Youtube of a guy yelling at a Sun disk array during heavy I/O and the 
resulting vibrations causing an immediate spike in I/O service times). 
Could be something like that causing issues with simultaneous media 
access to all drives in the array, too..
