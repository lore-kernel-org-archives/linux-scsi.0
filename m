From: "Heinz, Michael" <mheinz@infiniconsys.com>
Subject: RE: Configuring the device_list in scsi_scan.c
Date: Thu, 30 May 2002 20:13:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <08628CA53C6CBA4ABAFB9E808A5214CB0C4D56@mercury.infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Well, to get our testing group working with the new device, I used
BFLAG_SPARSELUN, but the idea is to get away from having to alter
scsi_scan.c for each new RAID or SAN product that hits the market. 

Ultimately we're gonna ship our IB products and we really don't want to
have to explain to each customer why .Net recognizes their devices
automatically, but they have to manually patch the kernel for each of
their linux servers and add each RAID box they might want to put on
their SAN.

--
Michael Heinz
Infinicon Systems, Inc.
http://www.infiniconsys.com 

> -----Original Message-----
> From: Patrick Mansfield [mailto:patmans@us.ibm.com]
> Sent: Thursday, May 30, 2002 6:55 PM
> To: Heinz, Michael
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: Configuring the device_list in scsi_scan.c
> 
> 
> Did you add a BLIST_FORCELUN or BLIST_SPARSELUN entry?
> 
> If BLIST_FORCELUN, you should instead boot or load the adapter module
> with max_scsi_luns=value
> 
> BLIST_FORCELUN is really only need if you have a device that is broken
> scanning past LUN 0 (BLIST_NOLUN) but is not in the device_list.
> 
> BLIST_SPARSELUN really needs REPORT LUN scanning, I think someone at
> EMC has backported it to 2.4.x.
> 
> If you had to modify /proc to see the LUN, booting of a non-0 
> LUN device
> would not be easy, plus you would have to scan again.
> 
> I'd like to see a hotplug like interface for the device_list settings
> (at least in 2.5.x).
> 
> -- Patrick Mansfield
> 
> On Thu, May 30, 2002 at 05:18:29PM -0400, Heinz, Michael wrote:
> > We just ran into an issue where the RAID array we purchased 
> didn't quite
> > work with Linux, because only the first LUN was visible (Red Hat
> > 2.4.7-10).
> > 
> > I patched the kernel by adding the array to the device_list in
> > scsi_scan.c, but that seems obnoxious. It occurs to me that 
> it would be
> > straight forward to modify scsi.c and scsi_scan.c so that you could
> > write to /proc/scsi/scsi and add new entries to the 
> device_list; and a
> > module parameter that would let you add a single new entry to the
> > device_list right at load time.
> > 
> > Before I start fighting with my boss over whether I have 
> time to write
> > patches for the linux kernel - does this fix make sense?
> > -
> > To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
