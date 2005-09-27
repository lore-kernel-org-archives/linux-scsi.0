From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [2.4.21] Spurious ABORTs
Date: Tue, 27 Sep 2005 15:10:45 -0500
Message-ID: <1127851845.4823.23.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E57060CD1E1@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:36253 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750969AbVI0UKu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Sep 2005 16:10:50 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57060CD1E1@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'Christoph Hellwig' <hch@infradead.org>, "'hch@lst.de'" <hch@lst.de>, "Kolli, Neela Syam" <Neela.Kolli@engenio.com>

On Tue, 2005-09-27 at 15:48 -0400, Bagalkote, Sreenivas wrote:
> >1. you do clustering, so a reset request could be from a 
> >reservation breaking protocol
>
> I don't have clustering setup. So this is definitely not the reason.

You might not, but others do.  If you return success to a reset request
without doing anything then the device will stay reserved by the other
system.  i.e. you'll break clustering setups.

> >2. The fact that the eh activated indicates something went 
> >wrong.  If you take no corrective action and the test unit 
> >ready that follows the reset fails or times out then the 
> >device will be taken offline.
> >
> 
> Heavy IOs are going on in the FW while it is rebuilding RAID arrays.
> We expect some of the commands to timeout. But the key is recover
> gracefully. I see that FW is completing _all_ the commands albeit 
> after timing out. When the reset handler is called after all the
> commands are out of the door, I simply return success. Can this
> potentially cause any issues?

As long as the Test Unit Ready that follows the reset succeeds, then no,
this will work and it shouldn't cause any issues other than the
clustering one.

James


