From: Nitin Gupta <ngupta@vflare.org>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
 slot is freed)
Date: Thu, 13 Aug 2009 21:43:10 +0530
Message-ID: <4A843B96.3010200@vflare.org>
References: <200908122007.43522.ngupta@vflare.org> <Pine.LNX.4.64.0908122312380.25501@sister.anvils> <20090813151312.GA13559@linux.intel.com>
Reply-To: ngupta@vflare.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20090813151312.GA13559@linux.intel.com>
Sender: owner-linux-mm@kvack.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/13/2009 08:43 PM, Matthew Wilcox wrote:

>
> I am planning a complete overhaul of the discard work.  Users can send
> down discard requests as frequently as they like.  The block layer will
> cache them, and invalidate them if writes come through.  Periodically,
> the block layer will send down a TRIM or an UNMAP (depending on the
> underlying device) and get rid of the blocks that have remained unwanted
> in the interim.
>

This batching of discard requests is still sub-optimal for compcache. 
The optimal solution in this case is to get callback *as soon as* a swap 
slot becomes free and this is what this patch does.

I see that it will be difficult to accept this patch since compcache 
seems to be the only user for now. However, this little addition makes a 
*big* difference for the project. Currently, much of memory is wasted to 
store all the stale data.

I will be posting compcache patches for review in next merge window. So, 
maybe this patch can be included now as the first step? The revised 
patch is ready which addresses issues raised during the first review -- 
will post it soon.

Thanks,
Nitin

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
