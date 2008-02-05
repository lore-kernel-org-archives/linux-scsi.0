From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH RESEND number 2] libata: eliminate the home grown dma
 padding in favour of that provided by the block layer
Date: Tue, 05 Feb 2008 09:43:08 +0900
Message-ID: <47A7B11C.10607@gmail.com>
References: <1199138168.3110.12.camel@localhost.localdomain>	 <1200698057.3111.68.camel@localhost.localdomain>	 <1201894847.3134.59.camel@localhost.localdomain>	 <47A37AF3.3030503@garzik.org>	 <1201900175.3134.67.camel@localhost.localdomain> <47A52F23.70506@gmail.com>	 <1202013174.3187.69.camel@localhost.localdomain>	 <47A56F2B.4040904@gmail.com>	 <1202049511.3318.13.camel@localhost.localdomain>	 <47A5DA5F.3070209@gmail.com>	 <1202055156.3318.58.camel@localhost.localdomain>	 <47A66A39.7090800@gmail.com> <47A6D9F2.5060102@gmail.com>	 <47A72475.5040106@gmail.com>	 <1202142222.3096.26.camel@localhost.localdomain>	 <47A7A887.2040307@gmail.com> <1202171564.3096.147.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1202171564.3096.147.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

Hello,

James Bottomley wrote:
>> No, it doesn't.  Drain needs to extend the sg table too 
> 
> The patches do extend the sg table.

Hmm... Where?

>> and it makes controllers lax about buffer overruns for commands they shouldn't be.
> 
> So adjust the qc->nbytes to show no drain element in libata ... although
> the extra element gets mapped, the HBA will be none the wiser if there's
> zero length allocated to it.  Thus the entire system behaves exactly
> like the drain element isn't present.  The block layer is really just
> making the drain element available ... you don't have to use it.

Adjusting qc->nbytes isn't enough.  libata will have to trim at the end
of sglist.  With both draining and padding, it means libata will have to
trim one sg entry and a few more bytes.  Block layer is behaving
differently and in a very noticeable way, it's sending inconsistent
values in data_len and sg list.

>> Gee.. What's the deal with extra four bytes?  If you're worried about
>> the size of struct request, chopping off PC request part into a separate
>> struct would be far better strategy than making what's already confusing
>> more confusing.
> 
> Well, we are trying to slim down the request structure and scsi_cmnd
> structure.  However, there's no inherent advantage to counting this all
> in the block layer.  Think of it just as a transparent passthrough.
> You've told the block layer to make sure you have room for a drain
> element when it constructs the SG list, which it does.  Whether you use
> it (by adding blk_rq_drain_size() on to the actual length you hand down)
> or not is entirely up to you ... there's no need to push the decision on
> that one into the block layer, since use or not is pretty much a cost
> free thing.

Okay, I see your point.  The biggest problem is that by doing that blk
layer breaks a pretty important rule - keeping data len consistent with
sg list and the bugs it's gonna cause will be very subtle and dangerous.
 This is definitely where we can spend four extra bytes.

Thanks.

-- 
tejun
