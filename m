From: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Subject: RE: [2.4.21] Spurious ABORTs
Date: Tue, 27 Sep 2005 15:48:21 -0400
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57060CD1E1@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56539 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932173AbVI0Tsz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Sep 2005 15:48:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'Christoph Hellwig' <hch@infradead.org>, "'hch@lst.de'" <hch@lst.de>, "Kolli, Neela Syam" <Neela.Kolli@engenio.com>

>
>On Tue, 2005-09-27 at 13:10 -0400, Bagalkote, Sreenivas wrote:
>> What do you mean by "actually do a reset"? I see that 
>firmware doesn't 
>> have any pending commands. So I simply return success from 
>reset routine.
>> Do you see any problem in this? After a hundred or so such 
>cycles, the 
>> system is frozen. I should also tell you that if I introduce abort 
>> handler and return success for all the completed commands, I 
>don't see the OS hang.
>
>Well, yes, for two reasons
>
>1. you do clustering, so a reset request could be from a 
>reservation breaking protocol
>

I don't have clustering setup. So this is definitely not the reason.

>2. The fact that the eh activated indicates something went 
>wrong.  If you take no corrective action and the test unit 
>ready that follows the reset fails or times out then the 
>device will be taken offline.
>

Heavy IOs are going on in the FW while it is rebuilding RAID arrays.
We expect some of the commands to timeout. But the key is recover
gracefully. I see that FW is completing _all_ the commands albeit 
after timing out. When the reset handler is called after all the
commands are out of the door, I simply return success. Can this
potentially cause any issues?

Thanks for your quick responses.
Sreenivas
