From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: PMP and SEMB messages to SEP
Date: Tue, 25 Jan 2011 09:14:14 -0500
Message-ID: <1295964854.4955.21.camel@mulgrave.site>
References: <20110113192558.GE16039@MAIL.13thfloor.at>
	 <20110114142018.GA978@htj.dyndns.org>
	 <20110114165957.GH16039@MAIL.13thfloor.at>
	 <20110114170407.GE978@htj.dyndns.org>
	 <20110114173759.GI16039@MAIL.13thfloor.at>
	 <20110117154042.GG27123@htj.dyndns.org>
	 <1295281131.3015.44.camel@mulgrave.site>
	 <20110117171836.GI27123@htj.dyndns.org>
	 <1295284906.3015.136.camel@mulgrave.site>
	 <20110117172415.GK27123@htj.dyndns.org>
	 <20110125030740.GB24024@MAIL.13thfloor.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20110125030740.GB24024@MAIL.13thfloor.at>
Sender: linux-ide-owner@vger.kernel.org
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-01-25 at 04:07 +0100, Herbert Poetzl wrote:
> On Mon, Jan 17, 2011 at 06:24:15PM +0100, Tejun Heo wrote:
> > On Mon, Jan 17, 2011 at 11:21:46AM -0600, James Bottomley wrote:
> > > Expanders aren't SCSI devices either ... that means they don't
> > > appear as visible to standard SCSI mechanisms like INQUIRY (SMP
> > > isn't a SCSI protocol it's a SAS extension). They just appear as
> > > part of the topology in the device tree.
> 
> > Ah, okay.  Then, things would be much simpler.  I was worrying about
> > how it would map to SCSI layer including INQUIRY emulations and all
> > those stuff.  Thanks for the info.
> 
> So, any thoughts on how and where to add the PMP to the devices
> available for sending SCSI or ATA commands to?
> 
> I'm willing to try to add the required code, but I'm sure I'll
> benefit from a few hints from the experts ...

Well, I'm not sure I'd count as an expert on this piece:  I haven't read
the relevant ATA standards.  From what I understand, SES packets are
encapsulated over an ATA command for SEMB.  In that case, it should be
fairly simple to recognise this and present a SCSI device which simply
encapsulates everything sent to it over this protocol.  That would allow
the ses ULD to attach seamlessly.

James


