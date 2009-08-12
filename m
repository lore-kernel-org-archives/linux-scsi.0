From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] [Target_Core_Mod/Persistent_Reservations]: Add
	Specify Initiator Port Capable (SPEC_I_PT=1) support
Date: Tue, 11 Aug 2009 17:17:40 -0700
Message-ID: <1250036260.31984.32.camel@haakon2.linux-iscsi.org>
References: <1249793770.11105.235.camel@haakon2.linux-iscsi.org>
	 <4A8090AE.1090701@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from n12a.bullet.mail.mud.yahoo.com ([209.191.125.177]:37209 "HELO
	n12a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932130AbZHLARl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Aug 2009 20:17:41 -0400
In-Reply-To: <4A8090AE.1090701@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, James Smart <James.Smart@Emulex.Com>, Philipp Reisner <philipp.reisner@linbit.com>

On Mon, 2009-08-10 at 17:27 -0400, Douglas Gilbert wrote:
> Nicholas A. Bellinger wrote:
> > Hello,
> > 
> > This patch adds exhaustive support for handling SPEC_I_PT=1 processing of fabric dependent
> > TransportIDs in PROUT SA REGISTER ops containing SCSI Initiator port/device identifiers as
> > defined by spc4r17.
> 
> [snip]
> 
> > Here is what it looks like in action doing a PROUT SA REGISTER with SPEC_I_PT: from a
> > local initiator port (debian) for a remote initiator port (opensuse) using sg_persist
> > from an Open-iSCSI Initiator:
> > 
> > 	initiator# sg_persist -vvv --out --device /dev/sde --register --param-rk=0 --param-sark=0x1234ffff -T 5 -X  05,0,33,32,69,71,6E,2E,31,39,39,36,2D,30,34,2E,64,65,2E,73,75,73,65,3A,30,31,3A,31,36,36,31,66,39,65,65,37,62,35,00
> > 	number of tranport-ids decoded from command line (or stdin): 1
> > 	  Decode given transport-ids:
> > 	      Transport Id of initiator:
> > 	        iSCSI name: iqn.1996-04.de.suse:01:1661f9ee7b5
> > 	open /dev/sde with flags=0x800
> > 	    inquiry cdb: 12 00 00 00 24 00
> > 	      duration=4 ms
> > 	  LIO-ORG  IBLOCK  3.0
> > 	  Peripheral device type: disk
> > 	open /dev/sde with flags=0x802
> > 	    Persistent Reservation Out cmd: 5f 00 05 00 00 00 00 00 44 00
> > 	    Persistent Reservation Out parameters:
> > 	 00     00 00 00 00 00 00 00 00  00 00 00 00 12 34 ff ff    .............4..
> > 	 10     00 00 00 00 08 00 00 00  00 00 00 28 05 00 33 32    ...........(..32
> > 	 20     69 71 6e 2e 31 39 39 36  2d 30 34 2e 64 65 2e 73    iqn.1996-04.de.s
> > 	 30     75 73 65 3a 30 31 3a 31  36 36 31 66 39 65 65 37    use:01:1661f9ee7
> > 	 40     62 35 00 00                                         b5..
> > 	      duration=12 ms
> > 	PR out: command (Register) successful
> 
> [snip]
> 
> The additional length field in the TransportID above is a bit
> strange.vRefer to spc4r20.pdf table 406 on page 482. I would
> interpretvthe above additional length as 3332h which is
> possible but notvprobable. Looking at the data I think the
> additional lengthvshould be 24h (22h round up to 24h because
> of the "multiplevof 4" rule).
> 

Yes, I ran into a problem with the additional length of the iSCSI
Transport ID with sg_persist -X when I was testing this patch.  I ended
up adding some additional logic to the LIO-Target fabric module's iSCSI
Initiator TransportID parser that would extract the additional length
from the TransportID, and then compare against strlen() of the passed
TransportID, which works with iSCSI TransportIDs because they are NULL
terminated)

If the extracted additional length does not match the strlen() for the
processed TransportID, the latter will be returned as the correct value
to generic target code PR doing the processing.

> Looks like sg_persist needs a better way of representing
> TransportIDs that contain iSCSI names. Possibilities might be:
>    ... -X 05,0,0,24,iqn.1996-04.de.suse:01:1661f9ee7b5
> or
>    ... -X 05,0,iqn.1996-04.de.suse:01:1661f9ee7b5
> 

This would be great, even better would be to get rid of the prefix from
-X all together (not sure if that is possible for other types of
Transport IDs) and just have sg_persist generate the '05' prefix for
passed iqn's that are defining a iSCSI Initiator Device, and generate
the '45' for passed iqn's containing the ',i,0x<ISID>' defining a iSCSI
Initiator Port.

> Both variants could trigger on "iqn" (is "IQN" allowable)?
> In the latter case sg_persist could work out the iSCSI name
> length, round it up if necessary and insert it in the
> transportID.
> 

I don't do any strict checks in LIO-Target fabric code for using lower
case 'iqn', and I don't recall any wording in RFC-3720 about this.  Of
course, I have never seen anyone using a upper case 'IQN' prefix before,
so it is probably safe to assume only lower case.

Thanks for your comments Doug!

--nab



