From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ibmvscsi: use GFP_ATOMIC with dma_alloc_coherent in
 map_sg_data
Date: Fri, 11 Jan 2019 10:24:33 -0800
Message-ID: <20190111182432.GA5469@infradead.org>
References: <1547089136-20264-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <20190110150703.GA26696@infradead.org>
 <1214b6b5-92f2-7789-7530-36a0d16323c5@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1214b6b5-92f2-7789-7530-36a0d16323c5@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, james.bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 10, 2019 at 12:11:53PM -0800, Tyrel Datwyler wrote:
> This allocation isn't a single use allocation. The driver is just lazy about allocating our ext_list area for large SG lists (ie. SG_ALL). When the driver was first written it only supported up to 10 indirect SRP buffers. James Bottemley added the large SG support back in 2005 with the commit referenced here in the fixes tag "4dddbc26c389". We only allocate the ext_list when we come across a SG list requiring more than 10 indirect buffers. Once allocated we will reuse if already allocated.

I think the right fix is to just allocate the buffer for the ext_list
as part of the scsi command using the .cmd_size field in the host
template, and then dma map it in queuecommand and unmap it on
completion. 
