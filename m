From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Fri, 25 Oct 2002 17:14:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210252214.g9PMEhD04705@localhost.localdomain>
References: <axboe@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id PAA07572
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2002 15:15:02 -0700
In-Reply-To: Message from Jens Axboe <axboe@suse.de>
   of "Fri, 25 Oct 2002 21:47:12 +0200." <20021025194712.GC1203@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@digeo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Badari Pulavarty <pbadari@us.ibm.com>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Doug Ledford <dledford@redhat.com>

I think it may be bound up in another SCSI hang scenario I've been seeing.  
I've instrumented the done on already done (and the locking in the SCSI 
request fn).

The scenario I see is:

driver rejects command.  Mid layer requeues.  Several commands go by.  Now I 
get a done on an already done command.  Unfortunately, the **** dump_stack() 
doesn't print a trace so I still don't know where the command is coming from.

I'll keep looking.

James


