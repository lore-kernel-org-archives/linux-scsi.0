From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: aacraid: Add a small delay after IOP reset
Date: Tue, 19 Sep 2017 16:15:32 -0300
Message-ID: <68bec00d-cdc6-3e3e-3f01-fa7c22d29fa2@linux.vnet.ibm.com>
References: <20170919151156.29412-1-gpiccoli@linux.vnet.ibm.com>
 <20170919153712.GA15496@infradead.org>
 <6958d5da-8f9a-ff6b-ccea-16c335b24530@linux.vnet.ibm.com>
 <20170919155222.GA24688@infradead.org>
 <1505840736.2971.12.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1505840736.2971.12.camel@HansenPartnership.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>
Cc: aacraid@microsemi.com, linux-scsi@vger.kernel.org, RaghavaAditya.Renukunta@microsemi.com, david.carroll@microsemi.com, brking@linux.vnet.ibm.com, dougmill@linux.vnet.ibm.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/19/2017 02:05 PM, James Bottomley wrote:
> Actually, the whole problem sounds like a posted write.  Likely the
> write that causes the reset doesn't get flushed until the read checking
> if the reset has succeeded, which might explain the 100% initial
> failure.  Why not throw away that first value if it's a failure and
> then do your polled wait and timeout on the reset success.  We should
> anyway be waiting some time for a reset to be issued, so even on non-
> posted write systems we could see this problem intermittently.
> 
> James
> 

Thanks for this suggestion James.

I tried to remove the sleep and did a dummy read to register using
readl() - issue reproduced.

I did expect that, since in aac_is_ctrl_up_and_running() we indeed read
a register and if it shows us reset is not complete, we wait and read it
again. So, we can think in this 1st read as a dummy one heheh

My theory here is that we're observing a failure similar to one we
already did in some specific NVMe adapters - the readl before some delay
(in nvme it was 2s) corrupts the adapter FW procedure. It's as if the
adapter doesn't like to deal with this read while the reset procedure is
ongoing. So, we wait a bit to issue a readl and everything goes fine.

Cheers,


Guilherme
