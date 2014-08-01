From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1.3 4/18] arcmsr: limit max. number of SCSI command
 request
Date: Fri, 1 Aug 2014 05:35:52 -0700
Message-ID: <20140801123552.GB30397@infradead.org>
References: <1406882389.10378.46.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1406882389.10378.46.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> @@ -2220,8 +2220,7 @@ static int arcmsr_queue_command_lck(stru
>  		arcmsr_handle_virtual_command(acb, cmd);
>  		return 0;
>  	}
> -	if (atomic_read(&acb->ccboutstandingcount) >=
> -			ARCMSR_MAX_OUTSTANDING_CMD)
> +	if (atomic_read(&acb->ccboutstandingcount) >= acb->maxOutstanding)
>  		return SCSI_MLQUEUE_HOST_BUSY;

The scsi midlayer already takes care of this check for you.
