From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] multipath: Evaluate request result and sense
	code
Date: Thu, 19 Nov 2009 13:58:36 -0600
Message-ID: <4B05A36C.2030409@cs.wisc.edu>
References: <20091119122503.413AD3A174@ochil.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091119122503.413AD3A174@ochil.suse.de>
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
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hannes Reinecke wrote:
> As we now see the result for every command we
> can use it to make some more elaborate choices
> if we should retry the request on another path.
> 
> This solves a potential data corruption when
> a request is being terminated with RESERVATION
> CONFLICT and queue_if_no_path is active; the
> request will be queued until the reservation
> status changes and then transmitted.


I had the same bz. To handle it I just converted the error to some other 
-EXYZ value. But like I said in my patch that I sent to the list I did 
not like it much.

I thought of going the route you did in this patch, but thought it was 
too scsi specific. Does dasd want advanced error handling? If not, then 
I am fine since for hw handlers we assume they are always scsi_dh modules.
