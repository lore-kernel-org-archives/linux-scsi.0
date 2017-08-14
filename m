From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/6] bsg: fix kernel panic resulting from missing
 allocation of a reply-buffer
Date: Mon, 14 Aug 2017 18:33:38 +0200
Message-ID: <20170814163338.GB18228@bblock-ThinkPad-W530>
References: <20170810093217.GL24539@lst.de>
 <20170810221038.GA918@bblock-ThinkPad-W530>
 <20170811083808.GA5497@lst.de>
 <20170811091415.GA8099@lst.de>
 <20170811134929.GA1249@bblock-ThinkPad-W530>
 <20170811143649.GA32381@lst.de>
 <20170811153203.GA31625@bblock-ThinkPad-W530>
 <20170811153553.GA6372@lst.de>
 <20170811160142.GB31625@bblock-ThinkPad-W530>
 <20170813143940.GA3772@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170813143940.GA3772@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Sun, Aug 13, 2017 at 04:39:40PM +0200, Christoph Hellwig wrote:
> On Fri, Aug 11, 2017 at 06:01:42PM +0200, Benjamin Block wrote:
> > When the BSG interface is used with bsg-lib, and the user sends a
> > Bidirectional command - so when he gives an input- and output-buffer
> > (most users of our interface will likely do that, if they wanna get the
> > transport-level response data) - bsg will allocate two requests from the
> > queue. The first request's bio is used to map the input and the second
> > request's bio for the output (see bsg_map_hdr() in the if-statement with
> > (op == REQ_OP_SCSI_OUT && hdr->din_xfer_len)).
> > 
> > When we now allocate the full space of bsg_job, sense, dd_data for each
> > request, these will be wasted on the (linked) second request. They will
> > go unused all the time, as only the first request's bsg_job, sense and
> > dd_data is used by the LLDs and BSG itself.
> > 
> > Right now, because we don't allocate this on each request, those spaces
> > are only allocated for the first request in bsg-lib.
> > 
> > Maybe we can ignore this, if it gets to complicated, I don't wanne
> > prolong this unnecessary.
> 
> We have the same 'issue' with bidirection scsi commands - it's a side
> effect of having two request structures for these commands, and the
> only real fix would be to have a single request structure, which would
> be nice especially if we can't do it without growing struct request.
> 

Alright, I was not aware of that. That is fair then. Thx.


                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block
-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
