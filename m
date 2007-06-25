From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Mon, 25 Jun 2007 13:43:43 -0700 (PDT)
Message-ID: <668935.63901.qm@web31812.mail.mud.yahoo.com>
References: <27258.1182528999@bebe.enoyolf.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:36767 "HELO
	web31812.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751126AbXFYUnp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jun 2007 16:43:45 -0400
In-Reply-To: <27258.1182528999@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@enoyolf.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

--- Doug Maxey <dwm@enoyolf.org> wrote:
> On Fri, 22 Jun 2007 09:11:39 CDT, James Bottomley wrote:
> > On Thu, 2007-06-21 at 21:40 -0700, Mike Anderson wrote:
> > > James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > > > A proposal to display the correct form of the LUN would be useful if you
> > > > wish to make it? ...  The problem is really that SAM specifies a
> > > > possible 4 level structure with 4 possible address methods per level.
> > > > 
> > > > The well known LUNs should be simple; there are only three: Report Lun,
> > > > Access Controls and Target Log Pages.  The rest we really need input on.
> > > > For instance, I could see the vendors wishing us to combine a
> > > > multi-level flat addressing space into a single logical unit number,
> > > > whereas I could see them wanting us to supply some sort of hierarchy for
> > > > the peripheral and logical unit methods of addressing.
> > > > 
> > > > Since you're already using 2 level flat addressing, how do you want to
> > > > see that represented?
> > > 
> > > James, why would we would not want to display the lun per SAM4 4.6.2 as
> > > suggested by Stefan in a previous comment.
> > 
> > Because in a two LUN system, what was LUN 1 would then become LUN
> > 0x1000000000000 which looks a bit unpalatable.
> > 
> 
> Just my $.02.
> 
> If you use a pseries, and have to specifiy the LUN to the OFW on the later 
> releases, you must train the fingers to type the extra 12 chars.  
> 
> Iy you are watching an iSCSI target with tcpdump, you can observe the 
> PDU fields with the lun encoded thusly.   It may not be historical, but 
> is certainly more accurate to use the 0x1000000000000 as 64 bit (or 
> more correctly 8 bytes) encoded as hex.

Indeed it is more accurate to represent LUNs in 64 bit format.

It is even more accurate to represent them as u8 LUN[8], and possibly
print them as
  "0x%016llx"   ((unsigned long long) be64_to_cpu(*(__be64 *)(LUN))).

What I haven't been able to figure out is the source of the insistence
of bottomley et al., that SCSI Core should interpret the LUN structure
and that it should transform it into an integer entity, such that the
LUN space is enumerable.

But this discussion isn't new.  This is the 6th year that someone
brings the SCSU Core's LUN subject up.

I think the professional part of this audience would recognize the
significance of the intended entity which has interest in the
LUN structure when designing their storage (protocol) stacks.

   Luben

