From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT PULL] isci merge candidate
Date: Fri, 13 May 2011 14:45:07 -0700
Message-ID: <4DCDA663.2040202@intel.com>
References: <1305317680.21099.83.camel@dwillia2-linux> <BANLkTim3igaB8XXQkDY6GEutWfbK-o840A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTim3igaB8XXQkDY6GEutWfbK-o840A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, David Milburn <dmilburn@redhat.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org

On 05/13/2011 01:34 PM, Linus Torvalds wrote:
> On Fri, May 13, 2011 at 1:14 PM, Dan Williams<dan.j.williams@intel.com>  wrote:
>>
>> [ Linus, only cc'ing you in case a new-driver merge exception can be
>> entertained at this very late date.  James made clear he needed this in
>> advance of rc7, and this still needs Christoph's ack, but I would be
>> remiss not to send this after reaching this milestone...]
>
> So I can merge new drivers at any stage in the development cycle, but
> I only do that for drivers with mass appeal.
>
> What's the likely user base of this?

This storage controller is integrated into the chipset that will be the 
basis for upcoming workstation / server platforms.

> Why is it a SCSI driver rather than SATA? Why is it so f&*%ing big?

It's a SAS (serial-attached-scsi) driver so it ties in to libsas rather 
than libata (libsas itself ties in to libata for tunnelling SATA 
protocol over SAS).  The size is attributable to the fact that all 
protocol handling for non-fast path i/o is handled by software.  There 
are still cleanups that can be made, but likely not on the on the same 
order of what we have already done.

> The size may be a massive improvement over what it has been, but if
> this is some kind of replacement for the current AHCI situation, it's
> still a massive step backwards.

So it's not a replacement for AHCI and AHCI will still be included in 
this chipset.  However, AHCI in this timeframe only gives you up to 
4-ports at 3Gb/s and 2-ports at 6Gb/s direct attached SATA.  This 
controller in comparison includes up to 8-ports 6Gb/s of SAS/SATA 
connectivity allowing drives to optionally be connected through an 
expander topology.

> So what does that mean in practical terms:
>
>   "This driver supports the 6Gb/s SAS/SATA capabilities of the upcoming
> Intel(R) C600 series chipset family"
>
> exactly? What's the market for that C600 series?

Standard workstations and servers.

> Does that chipset
> also do some AHCI emulation capability (making this driver be a "if
> you need full capabilties thing" etc) Yadda yadda.

Yes.  We expect the majority of platforms to populate at least some of 
the AHCI ports.  That being said populating zero AHCI ports is also a 
valid configuration option and some platform vendors may take this route.

> I don't want to merge 30k lines of driver that nobody will practically
> speaking actually use.

I will note that if a user is on a platform without AHCI they will be 
missing ATAPI support as that was a feature of the isci driver that was 
deferred while the cleanup/rewrite was happening.

--
Dan
