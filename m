From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCHv2 1/1] SCSI: update hosts module to use idr index
 management
Date: Tue, 06 Oct 2015 10:17:34 -0700
Message-ID: <1444151854.2245.18.camel@HansenPartnership.com>
References: <cover.1444085255.git.lduncan@suse.com>
	 <1a69690d615610c1dee725db7e6d81cf2db28266.1444085255.git.lduncan@suse.com>
	 <20151006094040.GA24624@infradead.org> <56140188.6070107@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56140188.6070107@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-10-06 at 10:14 -0700, Lee Duncan wrote:
> On 10/06/2015 02:40 AM, Christoph Hellwig wrote:
> >>  struct Scsi_Host *scsi_host_lookup(unsigned short hostnum)
> >>  {
> >> -	struct device *cdev;
> >> -	struct Scsi_Host *shost = NULL;
> >> -
> >> -	cdev = class_find_device(&shost_class, NULL, &hostnum,
> >> -				 __scsi_host_match);
> >> -	if (cdev) {
> >> -		shost = scsi_host_get(class_to_shost(cdev));
> >> -		put_device(cdev);
> >> -	}
> >> +	struct Scsi_Host *shost;
> >> +
> >> +	spin_lock(&host_index_lock);
> >> +	shost = idr_find(&host_index_idr, hostnum);
> >> +	spin_unlock(&host_index_lock);
> >> +
> >>  	return shost;
> > 
> > How does this actually grab a reference to the host?
> 
> Good catch -- I should have noticed that.
> 
> I will resubmit the patch.

I'll wait to see what you produce, but I don't think, using a separate
idr array, you can close the race window between lookup and get.  One of
the nice things about using the cdev iterator is that the get is part of
the lookup process.

James
