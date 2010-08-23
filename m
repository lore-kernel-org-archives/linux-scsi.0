From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [dm-devel] [PATCHSET block#for-2.6.36-post] block: replace barrier
 with sequenced flush
Date: Mon, 23 Aug 2010 12:49:54 -0400
Message-ID: <4C72A6B2.4070900@redhat.com>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100820132214.GA6184@lst.de> <4C6E9CAF.5010202@redhat.com> <4C7269E9.9070304@kernel.org> <20100823124815.GA20095@lst.de> <4C727E96.5020801@redhat.com> <4C727F2B.6060501@fusionio.com> <4C729171.3030605@redhat.com> <20100823164522.GA9528@atlas.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100823164522.GA9528@atlas.home>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>, "tytso@mit.edu" <tytso@mit.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/23/2010 12:45 PM, Sergey Vlasov wrote:
> On Mon, Aug 23, 2010 at 11:19:13AM -0400, Ric Wheeler wrote:
> [...]
>> (2) hardware raid cards with internal buffer memory and on-card battery backup
>> (they sit in your server, disks sit in jbod like expansion shelves). These are
>> fine if the drives in those shelves have write cache disabled.
>
> Actually some of such cards keep write cache on the drives enabled and
> issue FLUSH CACHE commands to the drives.  E.g., 3ware 9690SA behaves
> like this at least with SATA drives (the FLUSH CACHE commands can be
> seen after enabling performance monitoring - they often end up in the
> "10 commands having the largest latency" table).  This can actually be
> safe if the card waits for the FLUSH CACHE completion before making
> the write cache data in its battery-backed memory available for reuse
> (and the drive implements the FLUSH CACHE command correctly).

Yes - this is certainly one way to do it. Note that this will not work if the 
card advertises itself as a write through cache (and we end up not sending down 
the SYNC_CACHE commands).

At least one hardware RAID card (I unfortunately cannot mention the brand) did 
not do this command forwarding.

ric

