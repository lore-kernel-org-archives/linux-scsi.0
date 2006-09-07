From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_transport_sas: make minimum and maximum linkrate
 settable quantities
Date: Wed, 06 Sep 2006 23:38:48 -0400
Message-ID: <44FF9448.1030800@torque.net>
References: <1157588722.3469.33.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56282 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1422689AbWIGDi5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Sep 2006 23:38:57 -0400
In-Reply-To: <1157588722.3469.33.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> According to SPEC, the minimum_linkrate and maximum_linkrate should be
                        ^                    ^
                    programmable       programmable
> settable by the user.  This patch introduces a callback that allows the
> sas class to pass these settings on to the driver.

There are also "hardware" variants of min/max_linkrate.

Hmmm. I get a bit confused reading the above. Are you talking
about a SAS initiator that this machine controls (i.e. a "host"),
an expander phy in a visible SAS domain, a visible SSP target
(e.g. a SAS disk) and/or a visible SATA device? All of them?
Will all levels (i.e. initiator, expander and targets) have
these fields (if they exist) represented by an attribute
in sysfs?

The SATA device is easy to rule out (as is a SATA port selector).
There may be some way of doing linkrate changes via the
SATA command set.

SSP targets (e.g. SAS disks) have the "phy control and discover"
mode subpage. The SAS disks that I have examined (all from
one manufacturer) do not allow the programmable min/max_linkrate
fields to be changed by the user (i.e. the changeable
mode page bits are all zero). Worse still, their product
manuals say that both ports (phys) will negotiate the
same linkrate which will be the linkrate first attained.
Looking at the spec (sas2r05b section 10.2.7.2.3), it just
says all _other_ fields in that mode subpage shall not be
changeable. So your "should be settable" statement above
is a bit strong. How about "might be settable for SSP
targets".

As for expanders, the PHY CONTROL SMP function allows
those fields to be changed on a phy and the spec implies
those changes shall be obeyed, if they are still in place
when the next link/bus reset occurs. However the spec says
that function "may be implemented" so it is not required.

The SAS HBAs (initiators) that I have fought with allow
those fields to be changed. Being able to make a HBA
initiator phy do a link or hard reset required correspondence
with the LLD maintainers, in my experience :-)


Another thing worth pointing out is that the negotiated
physical link rate only applies to one point to point
physical link. The link rate can be changed by altering
these fields associated with the phy at either end of the
physical link, and then doing a link (or hard) reset from
either end to force a renegotiation.

Also folks playing with these fields should realize that
link reset is the appropriate type of reset to issue to
cause a linkrate change. A hard reset will do it as well
but may cause additional collateral damage. For example,
if any phy on a SAS target device does a hard reset
sequence, then all LUs within that target device receive
a LU reset: clearing out all SCSI commands in progress and
those pending. The idea with link reset is that only the link
layers and below are impacted, as longer of the renegotiation
succeeds in a timely fashion. Setting the prog_max_linkrate
to 1.5 Gbps at one end of physical link while setting the
prog_min_linkrate to 3 Gbps at the other end will cause
the renegotiation following a link reset to fail.

Doug Gilbert
