From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [2.4.21] Spurious ABORTs
Date: Tue, 27 Sep 2005 12:18:21 -0500
Message-ID: <1127841501.4814.53.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E57060CD1DF@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:412 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964943AbVI0RS0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Sep 2005 13:18:26 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57060CD1DF@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'Christoph Hellwig' <hch@infradead.org>, "'hch@lst.de'" <hch@lst.de>, "Kolli, Neela Syam" <Neela.Kolli@engenio.com>

On Tue, 2005-09-27 at 13:10 -0400, Bagalkote, Sreenivas wrote:
> What do you mean by "actually do a reset"? I see that firmware doesn't
> have any pending commands. So I simply return success from reset routine.
> Do you see any problem in this? After a hundred or so such cycles, the 
> system is frozen. I should also tell you that if I introduce abort handler
> and return success for all the completed commands, I don't see the OS hang.

Well, yes, for two reasons

1. you do clustering, so a reset request could be from a reservation
breaking protocol

2. The fact that the eh activated indicates something went wrong.  If
you take no corrective action and the test unit ready that follows the
reset fails or times out then the device will be taken offline.

James


