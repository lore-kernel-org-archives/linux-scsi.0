From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: fw-sbp2: prepare for s/g chaining
Date: Sat, 19 Jan 2008 22:20:02 +0100
Message-ID: <47926982.6040805@s5r6.in-berlin.de>
References: <1200419579.9273.39.camel@localhost.localdomain>	<tkrat.dd08f05252acff9a@s5r6.in-berlin.de>
	<20080118123341D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20080118123341D.fujita.tomonori@lab.ntt.co.jp>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> On Tue, 15 Jan 2008 21:10:50 +0100 (CET)
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> +++ linux/drivers/firewire/fw-sbp2.c
>> @@ -1107,9 +1107,9 @@ sbp2_map_scatterlist(struct sbp2_command
>>  	 * elements larger than 65535 bytes, some IOMMUs may merge sg elements
>>  	 * during DMA mapping, and Linux currently doesn't prevent this.
>>  	 */
> 
> On a relate note, I fixed the IOMMU merge issue. The patches have been
> -mm though I'm not sure whether they will go into v2.6.25. The patches
> enable you to remove the following workaround if you configure the
> maximum sg element length.

Thanks, I will keep an eye on it.

> From a quick look, fw-sbp2 uses scsi-ml in a different way so it would
> be a bit trick to configure the maximum sg element length.
> 
> You call dma_map_sg with pci_dev::dev but don't call scsi_add_host
> with pci_dev::dev.
> 
> If you set the maximum sg element length to pci_dev::dev, and then
> call scsi_add_host with it, the block layer and the IOMMU send you
> proper size sg elements.

At the moment, the Scsi_Host instances map 1:1 to SBP-2 target
instances.  I have to think about whether we can map it to FireWire
controller instances instead.  (Besides, the s/g element length
limitation is actually a limitation of the SBP-2 protocol, not of
FireWire PCI cards.)
-- 
Stefan Richter
-=====-==--- ---= =--==
http://arcgraph.de/sr/

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
