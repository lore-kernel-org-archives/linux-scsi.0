From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: [PATCH RFC] move scsi parts of dm hw handlers to
	scsi layer
Date: Fri, 21 Jul 2006 08:57:47 -0400
Message-ID: <20060721125747.GA29177@vienna.egenera.com>
References: <1153480817.8030.15.camel@max>
	<581472.1153482088210.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <581472.1153482088210.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, agk@redhat.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Rumor has it that on Fri, Jul 21, 2006 at 01:41:28PM +0200 Hannes Reinecke said:
> IIRC this is
> 
> 'DGC' 'DISK'
> 'DGC' 'RAID 10'
> 'DGC' 'RAID 5'
> 
> Hrmph. There is one bit which doesn't quite work out.
> While the hardware handler knows how to handle error codes and how to
> switch
> paths for a specific device, it doesn't know _when_ to switch it.
> I don't think it's a clever idea to switch paths whenever you encounter
> an
> passive path. Seems like you could do a nice ping-pong that way ...


Yes. I agree that having the handlers in SCSI is a better place for
them. However, the architectural decision to have multipath knowledge
at a higher level makes that harder. Some sort of interface into 
the scsi layer handlers from the dm/block layer would be more needed. 
That way dm or some piece that has the knowledge of the multipath 
situation can trigger the failover. 

There will still be a need to bubble up information from the decoded 
error codes so higher layers can make the correct decision. 
Such an interface would need to be in both directions.



Cheers,
Phil


> 
> Cheers,
> 
> Hannes
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Software Architect                            165 Forest St.
(508) 858-2628                            Marlboro, MA 01752
