From: Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
Date: Mon, 31 Aug 2009 08:21:07 -0400
Message-ID: <4A9BC033.9000909@pobox.com>
References: <004e01ca25e4$c11a54e0$434efea0$@ca>
 <9cfb6af689a7010df166fdebb1ef516b.squirrel@neil.brown.name>
 <4A948A82.4080901@redhat.com>
 <b585ed9f13649050bbc984869d081315.squirrel@neil.brown.name>
 <4A94905F.7050705@redhat.com> <005101ca25f4$09006830$1b013890$@ca>
 <4A94A0E6.4020401@redhat.com> <005401ca25ff$9ac91cc0$d05b5640$@ca>
 <4A950FA6.4020408@redhat.com> <92cb16daad8278b0aa98125b9e1d057a@localhost>
 <4A95573A.6090404@redhat.com> <1571f45804875514762f60c0097171e6@localhost>
 <d086b110526f8bac2f562850dfc70b03@localhost> <4A970154.2020507@redhat.com>
 <4A9B8583.9050601@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752757AbZHaMVb@vger.kernel.org>
In-Reply-To: <4A9B8583.9050601@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Ric Wheeler wrote:
..
>> The drive might take a longer time like this when doing error handling
>> (sector remapping, etc), but then I would expect to see your remapped
>> sector count grow.
> 
> Yes, this is a possibility and according to the spec, libata EH should
> be retrying flushes a few times before giving up but I'm not sure
> whether keeping retrying for several minutes is a good idea either.
> Is it?
..

Libata will retry only when the FLUSH returns an error,
and the next FLUSH will continue after the point where
the first attempt failed.

But if the drive can still auto-relocate sectors, then the
first FLUSH won't actually fail.. it will simply take longer
than normal.

A couple of those, and we're into the tens of seconds range
for time.

Still, it would be good to actually produce an error like that
to examine under controlled circumstances.

Hmm.. I had a drive here that gave symptoms like that.
Eventually, I discovered that drive had run out of relocatable
sectors, too.  Mmm.. I'll see if I can get it back (loaned it out)
and perhaps we can recreate this specific scenario on it..

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
