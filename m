From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC PATCH 2/4] convert dm to blkerr error values
Date: Fri, 16 Sep 2005 14:50:31 -0500
Message-ID: <432B2207.4000001@cs.wisc.edu>
References: <C2EEB4E538D3DC48BF57F391F422779321ACB7@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321ACB7@SRMANNING.eng.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "goggin, edward" <egoggin@emc.com>
Cc: dm-devel@redhat.com, axboe@suse.de, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

goggin, edward wrote:
> Mike,
> 
> Can't dec_pending now see different error values for the
> possibly multiple bio clones of a single original bio?

Yep.

> How should it decide which error gets propagated up to
> the original bio?

Have no idea really. We have this problem if the bio gets partially 
completed with different errors for different parts too. I think this 
can happen in SCSI if the front were to get a medium error.


> 
> Looks like the old code and your new code just take the error
> value from the last completed bio which has an error.  While
> this was probably OK when the only error value was -ENXIO, we
> may now need some logic in dec_pending to decide which error
> value has more significance.
> 

Yeah all of that was on the TODO under my comment:

>>Some temporary crap I will fix is the dec_pending fucntions.
