From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Always pass result and sense on request
	completion
Date: Thu, 10 Dec 2009 19:31:48 +0200
Message-ID: <4B213084.1010200@panasas.com>
References: <20091119122454.71A7D3A174@ochil.suse.de>	
	<4B20C417.4020201@suse.de> <1260463457.2457.80.camel@mulgrave.site>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1260463457.2457.80.camel@mulgrave.site>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@suse.de>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/10/2009 06:44 PM, James Bottomley wrote:
> On Thu, 2009-12-10 at 10:49 +0100, Hannes Reinecke wrote:
>> Hi James,
>>
>> would you mind commenting on this patch?
>> We really need this if we ever want to be able to do proper error code
>> handling from multipath.
> 
> OK, not keen on the way you're setting req->errors.
> 
> Our big problem with FS requests is deferred or corrected errors
> (basically we never want the FS to think we had a problem with them).  I
> think it's currently OK because block tends to believe the returned
> error code rather than req->errors ... I'd just hate it if that changed
> and suddenly lots of stuff broke.
> 

>From what I understood, req->errors is for private block-driver use and has
no meaning to the block layer. It expects a translation of req->errors to
a Linux error code passed to the blk_end_request which will be set to the
bio and passed to the async_done function. Only the block-driver understand
the format of req->errors.

Perhaps we must make sure there is an agreement between
	(returned-error == 0) == (req->errors == 0)

I know scsi-ml makes sure of that, so should the device manager.

> I think you're just looking for the sense data, so could you look at
> that and not set req->errors?
> 

I agree that the req->errors bits where not understood outside of scsi
up till now. Is multipath only compatible over scsi block devices?

> James
> 

Boaz
