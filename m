From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V4 09/16] staging: rtsx: use sg helper to operate
 scatterlist
Date: Mon, 17 Jun 2019 11:24:46 +0200
Message-ID: <20190617092446.GA8707@lst.de>
References: <20190617030349.26415-1-ming.lei@redhat.com>
 <20190617030349.26415-10-ming.lei@redhat.com> <20190617082706.GI7455@lst.de>
 <20190617091524.GB31002@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20190617091524.GB31002@ming.t460p>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, devel@driverdev.osuosl.org, Hannes Reinecke <hare@suse.com>, Benjamin Block <bblock@linux.ibm.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, James Smart <james.smart@broadcom.com>, "Ewan D . Milne" <emilne@redhat.com>, Jim Gill <jgill@vmware.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Brian King <brking@us.ibm.com>, Finn Thain <fthain@telegraphics.com.au>, "Martin K . Petersen" <martin.petersen@oracle.com>, Kim Bradley <kim.jamie.bradley@gmail.com>, "Juergen E . Fischer" <fischer@norbit.de>, Christoph Hellwig <hch@lst.de>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-scsi@vger.kernel.org

> +		struct scatterlist *sg = *cur_sg ?:
> +				(struct scatterlist *)scsi_sglist(srb);
> +

No need for the cast here.  And I have to say I hate that GNU C
non-standard shortshut in ? :.

Why not simply:

		struct scatterlist *sg = *cur_sg;

		if (!sg)
			sg = scsi_sglist(srb);

Which is a little more verbose, but much more readabe.

The rest of the patch looks fine to me.
