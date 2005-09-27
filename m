From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [2.4.21] Spurious ABORTs
Date: Tue, 27 Sep 2005 11:32:56 -0500
Message-ID: <1127838777.4814.44.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E57060CD1DD@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:31899 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964985AbVI0QdC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Sep 2005 12:33:02 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57060CD1DD@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'Christoph Hellwig' <hch@infradead.org>, "'hch@lst.de'" <hch@lst.de>, "Kolli, Neela Syam" <Neela.Kolli@engenio.com>

On Tue, 2005-09-27 at 12:18 -0400, Bagalkote, Sreenivas wrote:
> When I return SUCCESS to the spurious ABORTs, the systems keeps
> running. I am getting aborts for commands that I completed as
> early as 60+ seconds ago. Could somebody please tell me what in
> SCSI layer can cause it to do this?

Well, 2.4 is somewhat more eccentric than 2.6 as far as SCSI goes.
However, I can guess about this one.  If a command is completed after it
times out, you still get error handling for it (this is actually still
true in 2.6).  When the system becomes aware of a need for error
handling it quiesces the driver (i.e. waits for all outstanding commands
to time out or return) before beginning the eh thread.  So, if a bunch
of commands are failing, you can complete one that has already timed out
and still receive an ABORT for it ages afterwards.

James


