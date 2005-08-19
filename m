From: Jeff Garzik <jgarzik@pobox.com>
Subject: libata error handling
Date: Thu, 18 Aug 2005 23:49:19 -0400
Message-ID: <430556BF.5070004@pobox.com>
References: <20050729050654.GA10413@havoc.gtf.org> <20050807054850.GA13335@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20050807054850.GA13335@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org


Tejun,

In an email I cannot find anymore, you asked why I was interested in 
converting libata to use the fine-grained EH hooks in the SCSI layer, 
rather than continued with the current ->eh_strategy_handler() method.

Several reasons:

1) The fine-grained hooks of the SCSI layer are somewhat standard for 
block devices.  The events they signify -- timeout, abort cmd, dev 
reset, bus reset, and host reset -- map precisely to the events that we 
must deal with at the ATA level.

But be warned of false sharing, as I talk about in #2...

2) When libata SAT translation layer becomes optional, and libata drives 
a "true" block device, use of ->eh_strategy_handler() will actually be 
an obstacle due to false sharing of code paths.  ->eh_strategy_handler() 
is indeed a single "do it all" EH entrypoint, but within that entrypoint 
you must perform several SCSI-specific tasks.

3) ->eh_strategy_handler() has continually proven to be a method of 
error handling poorly supported by the SCSI layer.  There are many 
assumption coded into the SCSI layer that this is -not- the path taken 
by LLD EH code, and libata must constantly work around these assumptions.

4) libata is the -only- user of ->eh_strategy_handler(), and oddballs 
must be stomped out.  It creates a maintenance burden on the SCSI layer 
that should be eliminated.


