From: Mark Hounschell <markh-n2QNKt385d+sTnJN9+BGXg@public.gmane.org>
Subject: Re: BUG: SCSI aic7xxx driver and AMD IOMMU
Date: Thu, 26 Mar 2015 13:09:45 -0400
Message-ID: <55143D59.40005@compro.net>
References: <54E1FFFA.1060403@compro.net> <54F60D33.8090401@compro.net>
	<20150323150304.GQ4441@8bytes.org> <5511513D.6090106@compro.net>
	<20150325135937.GR4441@8bytes.org>
	<20150325151332.GT4441@8bytes.org> <5512E412.9040807@compro.net>
	<20150326124559.GV4441@8bytes.org> <55141E87.8040506@compro.net>
	<20150326155248.GW4441@8bytes.org>
Reply-To: markh-n2QNKt385d+sTnJN9+BGXg@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20150326155248.GW4441-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
Cc: iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org >> SCSI development list" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 03/26/2015 11:52 AM, Joerg Roedel wrote:
> Hi Mark,
>
> On Thu, Mar 26, 2015 at 10:58:15AM -0400, Mark Hounschell wrote:
>> Sorry but CMA was still badly broken. I have a patch below that works.
>
> In which way is it broken? What happens when you try to allocate memory
> with dma_alloc_coherent?
>

I got Oops on both the alloc and free and I had to hit the reset button.

>> I've tested it with small (no CMA) and large (with CMA) dma's using
>> dma_alloc_coherent. The patch below is just the "git diff" from your
>> cloned tree piped to a file then copied into this email. If you require
>> an official patch I can send one. Just let me know.
>
> The main differences I can spot are that you change the order (first
> CMA, then buddy) and you manually align the input size. I can see the
> reason for the later, but why does CMA need to be tried first?
>

I believe that is how dma_alloc_coherent works. If  CMA is present it 
uses it. Even for small allocations. If not present then it does the 
best it can. That patch was derived by looking at the Intel iommu driver 
works properly. Maybe you should take a look at that.

>> Also, in my opinion, this CMA thing is clearly a BUG not a feature
>> request. The AMD iommu clearly breaks CMA. I feel what ever fix
>> you are happy with should be back ported to stable.
>
> It is not a BUG, the interface definition for dma_alloc_coherent does
> not specify that it can allocate infinite amounts of memory. So this
> patch does not qualify for stable.
>
>

I don't care what the "the interface definition for dma_alloc_coherent" 
says. If it does not describe it's use with CMA, it is outdated. Maybe 
the "interface definition for dma_alloc_coherent" was done before CMA 
was implemented.

Maybe you should be looking at CMA Documentation.  Unfortunately there 
does not yet seem to be any in the Documentation dir. Probably because 
CMA is supposed to be transparent to the DMA API. You know, one should 
not need to details about it, etc...

It is a BUG. To access CMA you use dma_alloc_coherent. You have 
completely highjacked that function.  You have broken CMA. PERIOD. That 
is a BUG.

Regards
Mark
