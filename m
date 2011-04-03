From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: PMP and SEMB messages to SEP
Date: Sun, 03 Apr 2011 14:38:22 -0400
Message-ID: <1301855902.2631.39.camel@mulgrave.site>
References: <20110114165957.GH16039@MAIL.13thfloor.at>
	 <20110114170407.GE978@htj.dyndns.org>
	 <20110114173759.GI16039@MAIL.13thfloor.at>
	 <20110117154042.GG27123@htj.dyndns.org>
	 <1295281131.3015.44.camel@mulgrave.site>
	 <20110117171836.GI27123@htj.dyndns.org>
	 <1295284906.3015.136.camel@mulgrave.site>
	 <20110117172415.GK27123@htj.dyndns.org>
	 <20110125030740.GB24024@MAIL.13thfloor.at>
	 <1295964854.4955.21.camel@mulgrave.site>
	 <20110403173903.GK25397@MAIL.13thfloor.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20110403173903.GK25397@MAIL.13thfloor.at>
Sender: linux-ide-owner@vger.kernel.org
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2011-04-03 at 19:39 +0200, Herbert Poetzl wrote:
> >> So, any thoughts on how and where to add the PMP to the devices
> >> available for sending SCSI or ATA commands to?
> 
> >> I'm willing to try to add the required code, but I'm sure I'll
> >> benefit from a few hints from the experts ...
> 
> > Well, I'm not sure I'd count as an expert on this piece:
> > I haven't read the relevant ATA standards. 
> 
> > From what I understand, SES packets are encapsulated over 
> > an ATA command for SEMB.
> 
> correct, just that it can be any protocol (it's just another
> bus, usually i2c) with the common protocols being SES and
> SAF_TE AFAIK
> 
> > In that case, it should be fairly simple to recognise
> > this and present a SCSI device which simply encapsulates
> > everything sent to it over this protocol. 
> 
> do you have any pointers for me how that is done for SCSI?

I don't think I understand the question.  It happens automatically for
anything part of the SCSI domain.  For SEMB you have to unwind the
encapsulation and expose the resulting device into the SCSI domain for
the SES ULD to attach, presumably as a libata target or LUN.  If you're
asking for basic documentation about how SCSI works, that's in
Documentation/scsi/ plus some of the kernel docbook stuff.

> > That would allow the ses ULD to attach seamlessly.
> 
> any pointers to such an SES ULD (maybe for testing)?

it's drivers/scsi/ses.c

James


