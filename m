From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: aacraid: Add a small delay after IOP reset
Date: Tue, 19 Sep 2017 12:49:21 -0300
Message-ID: <6958d5da-8f9a-ff6b-ccea-16c335b24530@linux.vnet.ibm.com>
References: <20170919151156.29412-1-gpiccoli@linux.vnet.ibm.com>
 <20170919153712.GA15496@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170919153712.GA15496@infradead.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: aacraid@microsemi.com, linux-scsi@vger.kernel.org, RaghavaAditya.Renukunta@microsemi.com, david.carroll@microsemi.com, brking@linux.vnet.ibm.com, dougmill@linux.vnet.ibm.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/19/2017 12:37 PM, Christoph Hellwig wrote:
> On Tue, Sep 19, 2017 at 12:11:55PM -0300, Guilherme G. Piccoli wrote:
>>  	src_writel(dev, MUnit.IDR, IOP_SRC_RESET_MASK);
>> +
>> +	msleep(5000);
> 
> src_writel is a writel, and thus a posted MMIO write.  You'll need
> to have to a read first to make it a reliable timing base.
> 

Just for my full understanding - you're saying a readl BEFORE
src_writel() or AFTER src_writel() ?

I could add a read to some dummy register, but notice it was a sequence
of readl's on aac_is_ctrl_up_and_running() that caused the failure of
reset...

Thanks
