From: AJ Lewis <alewis@redhat.com>
Subject: Re: [ANNOUNCE] iSCSI Initiator Core Stack v1.6.1.20
Date: Fri, 25 Feb 2005 09:18:24 -0600 (CST)
Message-ID: <20050225.091824.97479573.alewis@redhat.com>
References: <1109187935.15154.164.camel@haakon>
	<x05mzttr8aw.fsf@null.msp.redhat.com>
	<1109317829.5848.22.camel@haakon>
Mime-Version: 1.0
Content-Type: Multipart/Signed; protocol="application/pgp-signature";
 micalg=pgp-sha1;
 boundary="--Security_Multipart(Fri_Feb_25_09_18_24_2005_092)--"
Content-Transfer-Encoding: 7bit
Received: from mx1.redhat.com ([66.187.233.31]:28602 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262716AbVBYPSl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2005 10:18:41 -0500
In-Reply-To: <1109317829.5848.22.camel@haakon>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick@pyxtechnologies.com
Cc: linux-scsi@vger.kernel.org

----Security_Multipart(Fri_Feb_25_09_18_24_2005_092)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

On Thu, 24 Feb 2005 23:50:29 -0800, "Nicholas A. Bellinger" <nick@pyxtechnologies.com> wrote:
> On Thu, 2005-02-24 at 14:51 -0600, AJ Lewis wrote:
> > I've gotten this setup and
> > running, but I can't seem to talk to my iscsi target.  The initiator
> > detects it, but it can't recognize the type:
> > 
> > iCHANNEL[0] - No defined iSCSI Authentication Methods, skipping SecurityNegotiation phase.
> > iCHANNEL[0] - iSCSI login successful on CID: 0 to 192.168.44.19:3260,2
> > iCHANNEL[0] - Incremented iSCSI connection count to 1 to node: iqn.1992-08.com.netapp:sn.33615311
> > iCHANNEL[0] - Established iSCSI session to node: iqn.1992-08.com.netapp:sn.33615311
> > iSCSI Core Stack[1] - Incremented number of active iSCSI sessions to 1.
> > scsi: unknown device type 31
> >   Vendor: NETAPP    Model: LUN               Rev: 0.2 
> >   Type:   Unknown                            ANSI SCSI revision: 04
> > 
> > Any ideas on why this wouldn't be working?  Is there a configuration
> > step I'm missing?
> > 
> 
> This looks like an unknown/unsupported SCSI Peripheral device type in
> the INQUIRY response data.  Is this LU just a sequential access device
> that is setting those bits to some different value?

Well, the cisco linux-iscsi initiator works just fine with it, so I
don't think it's an issue with the NetApp and linux.  With the
linux-iscsi initiator, /proc/scsi/scsi looks like this:

Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: NETAPP   Model: LUN              Rev: 0.2 
  Type:   Direct-Access                    ANSI SCSI revision: 04


With the pyx initiator, it looks like this:
 Host: scsi6 Channel: 00 Id: 00 Lun: 00
  Vendor: NETAPP   Model: LUN              Rev: 0.2 
  Type:   Unknown                          ANSI SCSI revision: 04

> It would certainly be interesting to see with Ethereal what is in the
> INQUIRY response data that Linux could possibly not support. :-)

Hrm...don't have anything setup to do that ATM, but I could probably
get something going...

> > Also, are you planning on updating the docs for the user tools at all?
> > There are several steps missing in the current README, and the man
> > page lists some parameters incorrectly and misses other entirely.
> > 
> 
> There are a couple of things I would like to be accomplished in the near
> feature for the user tools:
> 
> 1) Complete documentation of iSCSI Channel Management optertions by way
> of updated initiator-ctl manual pages and basic HOWTO for iSCSI Logical
> Unit Management Screnarios for iSCSI SAN Adminstitrators.
> 2) Initial release of authentication daemon using CHAP, with eventual
> support for RFC 3720 defined SRP.
> 3) Work towards supporting the Internet Storage Naming Service (iSNS)
> standard and assoicated open source implementations for discovery and
> device information for iSCSI Target Nodes and other storage resources.

And for the kernel side, it looks like:

 1) /proc -> sysfs conversion
 2) ioctl -> sysfs conversion
 Both of which include integration of the iscsi transport class discussed
 on this list

Out of curiousity, what does this initiator offer that the linux-iscsi
initiator doesn't?  (http://linux-iscsi.sourceforge.net/) I'm just
curious what you see as advantages this implementation has.

Regards,
--
AJ Lewis                                   Voice:  612-638-0500
Red Hat Inc.                               E-Mail: alewis@redhat.com
720 Washington Ave. SE, Suite 200
Minneapolis, MN 55414
   
Current GPG fingerprint = D9F8 EDCE 4242 855F A03D  9B63 F50C 54A8 578C 8715
Grab the key at: http://people.redhat.com/alewis/gpg.html or one of the
many keyservers out there...



----Security_Multipart(Fri_Feb_25_09_18_24_2005_092)--
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCH0HC9QxUqFeMhxURAuXcAJ9n8xcw8tP7fZsXWE7zaT/xa7g+QACfemxP
yc8zRlv8yJXAHHBZhn7bpGI=
=7GDE
-----END PGP SIGNATURE-----

----Security_Multipart(Fri_Feb_25_09_18_24_2005_092)----
