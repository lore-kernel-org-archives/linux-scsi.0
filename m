From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/2] [Target_Core_Mod/Persistent_Reservations]: Add Specify
 Initiator Port Capable (SPEC_I_PT=1) support
Date: Mon, 10 Aug 2009 17:27:10 -0400
Message-ID: <4A8090AE.1090701@interlog.com>
References: <1249793770.11105.235.camel@haakon2.linux-iscsi.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:39787 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbZHJV1Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Aug 2009 17:27:16 -0400
In-Reply-To: <1249793770.11105.235.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, James Smart <James.Smart@Emulex.Com>, Philipp Reisner <philipp.reisner@linbit.com>

Nicholas A. Bellinger wrote:
> Hello,
> 
> This patch adds exhaustive support for handling SPEC_I_PT=1 processing of fabric dependent
> TransportIDs in PROUT SA REGISTER ops containing SCSI Initiator port/device identifiers as
> defined by spc4r17.

[snip]

> Here is what it looks like in action doing a PROUT SA REGISTER with SPEC_I_PT: from a
> local initiator port (debian) for a remote initiator port (opensuse) using sg_persist
> from an Open-iSCSI Initiator:
> 
> 	initiator# sg_persist -vvv --out --device /dev/sde --register --param-rk=0 --param-sark=0x1234ffff -T 5 -X  05,0,33,32,69,71,6E,2E,31,39,39,36,2D,30,34,2E,64,65,2E,73,75,73,65,3A,30,31,3A,31,36,36,31,66,39,65,65,37,62,35,00
> 	number of tranport-ids decoded from command line (or stdin): 1
> 	  Decode given transport-ids:
> 	      Transport Id of initiator:
> 	        iSCSI name: iqn.1996-04.de.suse:01:1661f9ee7b5
> 	open /dev/sde with flags=0x800
> 	    inquiry cdb: 12 00 00 00 24 00
> 	      duration=4 ms
> 	  LIO-ORG  IBLOCK  3.0
> 	  Peripheral device type: disk
> 	open /dev/sde with flags=0x802
> 	    Persistent Reservation Out cmd: 5f 00 05 00 00 00 00 00 44 00
> 	    Persistent Reservation Out parameters:
> 	 00     00 00 00 00 00 00 00 00  00 00 00 00 12 34 ff ff    .............4..
> 	 10     00 00 00 00 08 00 00 00  00 00 00 28 05 00 33 32    ...........(..32
> 	 20     69 71 6e 2e 31 39 39 36  2d 30 34 2e 64 65 2e 73    iqn.1996-04.de.s
> 	 30     75 73 65 3a 30 31 3a 31  36 36 31 66 39 65 65 37    use:01:1661f9ee7
> 	 40     62 35 00 00                                         b5..
> 	      duration=12 ms
> 	PR out: command (Register) successful

[snip]

The additional length field in the TransportID above is a bit
strange.vRefer to spc4r20.pdf table 406 on page 482. I would
interpretvthe above additional length as 3332h which is
possible but notvprobable. Looking at the data I think the
additional lengthvshould be 24h (22h round up to 24h because
of the "multiplevof 4" rule).

Looks like sg_persist needs a better way of representing
TransportIDs that contain iSCSI names. Possibilities might be:
   ... -X 05,0,0,24,iqn.1996-04.de.suse:01:1661f9ee7b5
or
   ... -X 05,0,iqn.1996-04.de.suse:01:1661f9ee7b5

Both variants could trigger on "iqn" (is "IQN" allowable)?
In the latter case sg_persist could work out the iSCSI name
length, round it up if necessary and insert it in the
transportID.

Doug Gilbert
