From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: RE: aic7xxx & st - why does sym driver don't like odd count on wide
 bus?
Date: Wed, 13 Aug 2003 23:43:21 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0308132323440.2923@kai.makisara.local>
References: <000201c361a3$609273c0$e0019d89@cybernetics.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:31962 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S275525AbTHMUnX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Aug 2003 16:43:23 -0400
In-Reply-To: <000201c361a3$609273c0$e0019d89@cybernetics.com>
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: 'Wu Zhou' <zhouwu@cn.ibm.com>, linux-scsi@vger.kernel.org

On Wed, 13 Aug 2003, Tony Battersby wrote:

> >       You ever said that sym driver doesn't like odd counts
> > on wide bus.
> > What I want to know is why. Is this a defect?
>
> I had a disagreement with the author of the driver over this issue a
> long time ago.  See the list archive:
>
> http://marc.theaimsgroup.com/?t=101018223200001&r=1&w=2
>
I remember this discussion and looked at it again. I have run into this
problem also at other places than the st driver.

I agree with you and think that the low-level driver should handle this.
Gerard Roudier (author of sym53c8xx_2) had the opinion that the
pass-through user or high-level driver should handle this (i.e., see that
the transfer length is even if it detects that it is using a wide SCSI
HBA).

I agree that it is not convenient (to put it mildly) for every user to
determine whether the HBA can support odd transfer lengths. In addition to
future SCSI standards, this should include other transports using the SCSI
midlevel driver (USB, IEEE1394, ide-scsi, ATA-SCSI, ...).

A high-level driver using direct transfers between user space and device
has an additional problem: it can't simply increase the transfer length
because it does not know if there is memory mapped to the writing process
beyond the buffer (not to mention the security aspects). The solution is
to use an intermediate buffer but this is awkward. The HBA driver or
hardware are the only places where padding the data can be possibly done
safely without much extra work.

Gerard seems to have a firm opinion and I have decided to live with the
current situation. If I need odd write transfers (very rare because I can
control what I want to write), I use another HBA.

-- 
Kai
