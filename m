From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH v1.3 4/18] arcmsr: limit max. number of SCSI command
 request
Date: Mon, 04 Aug 2014 12:00:55 +0800
Message-ID: <1407124855.5217.23.camel@Centos6.3-64>
References: <1406882389.10378.46.camel@Centos6.3-64>
	 <20140801123552.GB30397@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140801123552.GB30397@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-08-01 at 05:35 -0700, Christoph Hellwig wrote:
> > @@ -2220,8 +2220,7 @@ static int arcmsr_queue_command_lck(stru
> >  		arcmsr_handle_virtual_command(acb, cmd);
> >  		return 0;
> >  	}
> > -	if (atomic_read(&acb->ccboutstandingcount) >=
> > -			ARCMSR_MAX_OUTSTANDING_CMD)
> > +	if (atomic_read(&acb->ccboutstandingcount) >= acb->maxOutstanding)
> >  		return SCSI_MLQUEUE_HOST_BUSY;
> 
> The scsi midlayer already takes care of this check for you.
> 

Hello Christoph,

We have 4 types of Adapter that some adpaters have command queue less
than ARCMSR_MAX_OUTSTANDING_CMD.
So we have to check outstanding command number here.

Thanks for your comment.
Ching
