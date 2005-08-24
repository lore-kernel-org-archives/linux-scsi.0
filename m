From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Re: [RFC PATCH 1/4] convert block layer drivers to
	blkerr error values
Date: Wed, 24 Aug 2005 14:27:27 -0500
Message-ID: <430CCA1F.7070408@cs.wisc.edu>
References: <1124874238.10888.18.camel@max> <20050824192132.GA20663@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050824192132.GA20663@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: axboe@suse.de, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> On Wed, Aug 24, 2005 at 04:03:58AM -0500, Mike Christie wrote:
> 
> 
>>-#define end_io_error(uptodate)	(unlikely((uptodate) <= 0))
>>+enum {
>>+	BLK_SUCCESS = 0,	/* Must be zero for compat with old usage */
>>+	BLKERR_IO,		/* Generic I/O error */
>>+	BLKERR_NOTSUPP,		/* Operation is not supported */
>>+	BLKERR_WOULDBLOCK,	/* Operation would block */
>>+	BLKERR_FATAL_DRV,	/* Fatal driver error */
>>+	BLKERR_FATAL_DEV,	/* Fatal device error */
>>+	BLKERR_FATAL_XPT,	/* Fatal transport error */
>>+	BLKERR_RETRY_DRV,	/* Driver error, I/O may be retried */
>>+	BLKERR_RETRY_DEV,	/* Device error, I/O may be retried */
>>+	BLKERR_RETRY_XPT,	/* Transport error, I/O may retried */
>>+};
> 
> 
> Do you need to add and use a BLKERR_TIMEOUT? As we can't determine the
> problem area for a timeout, and if it can or should be retried.
> 

I was hoping we could figure this out. In the patches, if a command 
times out and eh kicks off I was just returning BLKERR_RETRY_DEV. This 
guessing occurs for a lot of errors becuase we do not know what exactly 
happened. the reason for the timeout could have been a device problem or 
transport problem. Some help in figuring this type of thing out is 
needed in other places.
