From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: fw-sbp2: enforce s/g segment size limit
Date: Wed, 13 Aug 2008 11:38:22 +0200
Message-ID: <48A2AB8E.1090102@s5r6.in-berlin.de>
References: <489CB8D8.60908@s5r6.in-berlin.de>	
	<20080809063159F.fujita.tomonori@lab.ntt.co.jp>	
	<489CC17F.7000208@s5r6.in-berlin.de>	
	<20080809071744I.fujita.tomonori@lab.ntt.co.jp>	
	<tkrat.8f7aa8cea95d423b@s5r6.in-berlin.de>	
	<tkrat.fa7d9c31f0c263fb@s5r6.in-berlin.de>
	<da824cf30808111252m1decf08fk7ce3405105e1ceef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <da824cf30808111252m1decf08fk7ce3405105e1ceef@mail.gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Grant Grundler <grundler@google.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Grant Grundler wrote:
> On Sat, Aug 9, 2008 at 11:21 AM, Stefan Richter
>> -                       orb->page_table[j].low = cpu_to_be32(sg_addr);
>> -                       orb->page_table[j].high = cpu_to_be32(l << 16);
> 
> I didn't check the rest of the driver - but it would be good if it
> explicitly called dma_set_mask() or  pci_dma_set_mask() with a 32-bit
> mask value. Most drivers assume 32-bit and that's why I point this
> out.

I thought about this and currently think that I should not do this. 
There is the API to set the mask, but there is no API to _decrease_ the 
mask only.  The SBP-2 protocol driver should not set DMA_32BIT_MASK if 
any other driver already set for example DMA_31BIT_MASK for whatever reason.

For now, this is no issue.  FireWire low-level drivers exist only for 
controllers with 32 bit local bus addressing capability.  I am sure that 
somebody will remember to modify the SBP-2 driver(s) if there will ever 
be a controller type and a driver for it which can address more than 4 GB.

On the other hand, we also currently have no reason to set a smaller 
mask.  We recently discovered a chip bug which requires DMA_31BIT_MASK 
for a special mode of data reception (only for cache-coherent DMA 
though), but we now work around this chip bug by simply falling back to 
an alternative mode.
-- 
Stefan Richter
-=====-==--- =--- -==-=
http://arcgraph.de/sr/

-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
