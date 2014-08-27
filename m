From: worley@alum.mit.edu (Dale R. Worley)
Subject: Re: Problem with USB-to-SATA adapters (was: AS2105-based enclosure
 size issues with >2TB HDDs)
Date: Wed, 27 Aug 2014 15:21:49 -0400
Message-ID: <201408271921.s7RJLnRw009577@hobgoblin.ariadne.com>
References: <87801b450dee41dda169a3aa2dd2baf6@serv030.corp.eldorado.org.br>
	 <1408972618.10300.35.camel@linux-fkkt.site>
	 <201408261939.s7QJdg4B013031@hobgoblin.ariadne.com> <1409083158.3812.66.camel@jarvis.lan>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qmta08.westchester.pa.mail.comcast.net ([76.96.62.80]:50344
	"EHLO qmta08.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933812AbaH0TVv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2014 15:21:51 -0400
In-reply-to: <1409083158.3812.66.camel@jarvis.lan>
	(James.Bottomley@HansenPartnership.com)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

> From: James Bottomley <James.Bottomley@HansenPartnership.com>

> Did you try read capacity 16 on it?  What happened?  (the AS2105 rejects
> read capacity 16, so there's no reliable way to deduce the capacity of
> drives over 2TB).

OK, I had to track down which package contains sg_readcap.

The adapter that fails gives this output:

    # sg_readcap --16 /dev/sdb
    bad field in READ CAPACITY (16) cdb including unsupported service action

The adapter that succeeds gives this output:

    # sg_readcap --16 /dev/sdc
    Read Capacity results:
       Protection: prot_en=0, p_type=0, p_i_exponent=0
       Logical block provisioning: lbpme=0, lbprz=0
       Last logical block address=5860533167 (0x15d50a3af), Number of logical blocks=5860533168
       Logical block length=512 bytes
       Logical blocks per physical block exponent=0
       Lowest aligned logical block address=0
    Hence:
       Device size: 3000592982016 bytes, 2861588.5 MiB, 3000.59 GB

Dale
