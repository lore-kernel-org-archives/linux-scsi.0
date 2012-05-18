From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 4/4] firewire: sbp2: remove overzealous alignment
	constraints
Date: Fri, 18 May 2012 21:08:55 +0200
Message-ID: <20120518210855.43cc7e0b@stein>
References: <4FB67AFC.7090402@ladisch.de>
	<4FB67BDD.2030707@ladisch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <4FB67BDD.2030707@ladisch.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Clemens Ladisch <clemens@ladisch.de>, linux-scsi@vger.kernel.org
Cc: linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On May 18 Clemens Ladisch wrote at linux1394-devel:
> The SBP-2/3 specifications do not require any alignment of data
> buffers; only their own data structures need to be quadlet-aligned.

SBP-2 clause 3.1.2.24 requires that system memory accepts quadlet r/w
access.  Memory which is not aligned at quadlet boundaries is not
accessible by quadlet accesses per IEEE 1394 clause 6.2.5.2.2.

> This patch is perfectly safe because there is no actual change:
> the SCSI framework uses a default block queue DMA alignment of
> 32 bits anyway.

This code was added after recommendation to set it explicitly in the
driver:
http://marc.info/?l=linux-scsi&m=120137366708017
http://thread.gmane.org/gmane.linux.kernel.firewire.devel/11424

It is probably not going to happen that somebody decreases the SCSI
default.  But perhaps we should still keep this explicit...?

> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> ---
>  drivers/firewire/sbp2.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> --- a/drivers/firewire/sbp2.c
> +++ b/drivers/firewire/sbp2.c
> @@ -207,9 +207,8 @@ static const struct device *lu_dev(const struct sbp2_logical_unit *lu)
>  #define SBP2_MAX_CDB_SIZE		16
> 
>  /*
> - * The default maximum s/g segment size of a FireWire controller is
> - * usually 0x10000, but SBP-2 only allows 0xffff. Since buffers have to
> - * be quadlet-aligned, we set the length limit to 0xffff & ~3.
> + * The maximum SBP-2 data buffer size is 0xffff.  We quadlet-align this
> + * for compatibility with earlier versions of this driver.
>   */
>  #define SBP2_MAX_SEG_SIZE		0xfffc
> 
> @@ -1530,9 +1529,6 @@ static int sbp2_scsi_slave_alloc(struct scsi_device *sdev)
> 
>  	sdev->allow_restart = 1;
> 
> -	/* SBP-2 requires quadlet alignment of the data buffers. */
> -	blk_queue_update_dma_alignment(sdev->request_queue, 4 - 1);
> -
>  	if (lu->tgt->workarounds & SBP2_WORKAROUND_INQUIRY_36)
>  		sdev->inquiry_len = 36;
> 

-- 
Stefan Richter
-=====-===-- -=-= =--=-
http://arcgraph.de/sr/

------------------------------------------------------------------------------
Live Security Virtual Conference
Exclusive live event will cover all the ways today's security and 
threat landscape has changed and how IT managers can respond. Discussions 
will include endpoint security, mobile security and the latest in malware 
threats. http://www.accelacomm.com/jaw/sfrnl04242012/114/50122263/
