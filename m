From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Bug in the scsi_id (0.9 version) utility
Date: Fri, 14 Mar 2008 08:38:34 -0500
Message-ID: <1205501914.2904.9.camel@localhost.localdomain>
References: <alpine.LRH.1.00.0803130824450.30028@ss.netgate.net>
	 <20080314060831.GA18884@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <20080314060831.GA18884@linux.vnet.ibm.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: brooks@netgate.net, linux-hotplug@vger.kernel.org, Brian.Fehling@citrix.com, xen@netgate.net, cases.634568.7962_21175.de8b732451@cases.netsuite.com, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2008-03-13 at 23:08 -0700, Mike Anderson wrote:
> adding a linux-scsi cc as others may have comments on checking of reserved
> fields.
> 
> brooks@netgate.net <brooks@netgate.net> wrote:
> >
> > The utility makes the assumption that a reserved field in the 
> > identification descriptor returned by a SCSI page 83 response will be 
> > filled with "0x00". The Solaris iSCSI target implemenation (and possibly 
> > others) instead fills the field with "0XFF". As a result the utility 
> > assumes that the Solaris target is a SCSI-2 device and (incorrectly) parses 
> > the response as such. The Solaris box actually uses the latest released 
> > SCSI command set (SPC3):
> >
> >     http://www.t10.org/ftp/t10/drafts/spc3/spc3r23.pdf
> >
> > The fix was simple, check for 0x00 and for 0xFF instead of checking for 
> > !0x00. Since this code is generally only used discovery discovery it's a 
> > low risk change.
> >
> > As I understand it there's nothing in the SPC2/3 spec that states that 
> > "0x00" should be written to the reserved field of the identification 
> > descriptor so I'm not sure this is the best way to determine the device 
> > type command set. 

This is incorrect; SPC does specify zero in reserved fields.

> The SAM definitions section and the SPC Keywords section provides a
> definition of what should be in a reserved field.

And just to make it totally plain, this is what it says:

3.3.9 reserved: A keyword referring to bits, bytes, words, fields and
code values that are set aside for future standardization. A reserved
bit, byte, word or field shall be set to zero, or in accordance with a
future extension to this standard. Recipients are not required to check
reserved bits, bytes, words or fields for zero values. Receipt of
reserved code values in defined fields shall be reported as an error.

So your implementation is a spec violation.  You're just lucky SPC4
leaves it reserved.  If they ever decided to implement something there,
not only would you be in spec violation, you'd likely be claiming some
property your device doesn't support.

> That said we are not required to be checking the reserved fields for zero
> but in this case we are doing so to work around another device issue.
> 
> Instead of adding yet another device work around to the "if" which
> makes it hard to rework the code in the future as you do not know how many
> vendor, models are running through certain non compliant checks (i.e. more
> than the intend models may exhibit like behavior).
> 
> We possible should look at updating how we handle not compliant behavior.
> scsi_id.config is available but that must not be useful in all cases as
> the standard page 83 code has a check for the pre-spc3-83 case even though
> it is selectable through the config file and command line. 

Some type of blacklist might work: we're already starting to find USB
devices that aren't too happy with VPD inquiries.

James


