From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [REPOST #3][PATCH 1/6] lpfc 8.1.7 : Adding statistics reset	callback
 for FC transport
Date: Thu, 03 Aug 2006 09:56:02 -0400
Message-ID: <44D20072.8030105@emulex.com>
References: <OF72A08B9B.60EB1A87-ON422571BF.002BABC0-422571BF.002BE417@de.ibm.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60611 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932424AbWHCN4R
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Aug 2006 09:56:17 -0400
In-Reply-To: <OF72A08B9B.60EB1A87-ON422571BF.002BABC0-422571BF.002BE417@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <AHERRMAN@de.ibm.com>
Cc: linux-scsi@vger.kernel.org


Andreas Herrmann wrote:
>> Adding statistics reset callback for FC transport
> 
> Now lpfc is the second FC driver that stores old stats data in
> order to reset FC host stats. (zfcp is the other one.)
> 
> Shouldn't this stuff be moved into scsi_transport_fc?
> So the default for scsi_transport_fc would be to store
> a stats-offset (as you call it) together with seconds since
> last reset. So every FC lldd gets the reset-stats functionality
> for free.
> Of course an lldd is able to register its own reset-callback
> (maybe because the reset is implemented in hardware)
> to replace the default handler.
> 
> This just came into my mind when reviewing your patch.

In looking at what could be different:

- the handling of the "seconds from last reset" is common and could/should
   go into the transport.

- I don't know that i'd change the stats data though...
   I assume you are wanting to move the stats data from a LLD struct to a
   transport struct: I shied away from this initially, as I allowed for
   the data structure to be "hot" - e.g. the LLD is updating values in the
   fast path. There are better cacheline attributes if you let the driver
   manage it's own structure. Thus the call from the transport to fill in
   a reported structure. Granted, for lpfc (at least) much of the LLD
   data is passive as the hardware does the "hot" work.

   Another reason - I shy away from the driver reaching directly into
   transport structures to change values, in order to avoid race conditions.
   I've tried to only do this on static data, so the access is only at
   creation.

I'll look into posting a patch for the "seconds from last reset".
However, I would approach it that for now, the lpfc patches go in as is.
Then, the patch would add the transport support and update the drivers
accordingly (lpfc & zfcp included).

-- james s


