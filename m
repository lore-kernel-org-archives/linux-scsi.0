From: Chris Webb <chris@arachsys.com>
Subject: Re: MD/RAID time out writing superblock
Date: Mon, 7 Sep 2009 12:59:27 +0100
Message-ID: <20090907115927.GU8710@arachsys.com>
References: <4A950FA6.4020408@redhat.com> <92cb16daad8278b0aa98125b9e1d057a@localhost> <4A95573A.6090404@redhat.com> <1571f45804875514762f60c0097171e6@localhost> <d086b110526f8bac2f562850dfc70b03@localhost> <4A970154.2020507@redhat.com> <4A9B8583.9050601@kernel.org> <4A9BBC4A.6070708@redhat.com> <4A9BC023.10903@kernel.org> <20090907114442.GG18831@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090907114442.GG18831@arachsys.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

Chris Webb <chris@arachsys.com> writes:

> I have a bitmap on the array, but sometimes when I remove and re-add a
> failed component, it doesn't seem to use the bitmap and does a lengthy full
> recovery instead. One example that's ongoing at the moment:-
> 
>       [=>...................]  recovery =  5.7% (40219648/703205312) finish=7546.3min speed=1463K/sec
>       bitmap: 34/126 pages [136KB], 8192KB chunk
> 
> which is rather painful and has to be throttled back with speed_limit_max to
> avoid the virtual machines running on top of it from having extremely poor IO
> latency.

I've also noticed that during this recovery, I'm seeing lots of timeouts but
they don't seem to interrupt the resync:

  05:47:39 ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
  05:47:39 ata5.00: cmd ec/00:01:00:00:00/00:00:00:00:00/00 tag 0 pio 512 in
  05:47:39         res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 0x4 (timeout)
  05:47:39 ata5.00: status: { DRDY }
  05:47:39 ata5: hard resetting link
  05:47:49 ata5: softreset failed (device not ready)
  05:47:49 ata5: hard resetting link
  05:47:49 ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
  05:47:49 ata5.00: configured for UDMA/133
  05:47:49 ata5: EH complete
  
  08:17:39 ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
  08:17:39 ata5.00: cmd ec/00:01:00:00:00/00:00:00:00:00/00 tag 0 pio 512 in
  08:17:39         res 40/00:00:35:83:f8/00:00:4d:00:00/40 Emask 0x4 (timeout)
  08:17:39 ata5.00: status: { DRDY }
  08:17:39 ata5: hard resetting link
  08:17:49 ata5: softreset failed (device not ready)
  08:17:49 ata5: hard resetting link
  08:17:49 ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
  08:17:49 ata5.00: configured for UDMA/133
  08:17:49 ata5: EH complete
  
  10:22:39 ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
  10:22:39 ata5.00: cmd ec/00:01:00:00:00/00:00:00:00:00/00 tag 0 pio 512 in
  10:22:39         res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 0x4 (timeout)
  10:22:39 ata5.00: status: { DRDY }
  10:22:39 ata5: hard resetting link
  10:22:49 ata5: softreset failed (device not ready)
  10:22:49 ata5: hard resetting link
  10:22:50 ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
  10:22:51 ata5.00: configured for UDMA/133
  10:22:51 ata5: EH complete

Cheers,

Chris.
