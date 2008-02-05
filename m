From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH RESEND number 2] libata: eliminate the home grown dma
 padding in favour of that provided by the block layer
Date: Tue, 05 Feb 2008 09:06:31 +0900
Message-ID: <47A7A887.2040307@gmail.com>
References: <1199138168.3110.12.camel@localhost.localdomain>	 <1200698057.3111.68.camel@localhost.localdomain>	 <1201894847.3134.59.camel@localhost.localdomain>	 <47A37AF3.3030503@garzik.org>	 <1201900175.3134.67.camel@localhost.localdomain> <47A52F23.70506@gmail.com>	 <1202013174.3187.69.camel@localhost.localdomain>	 <47A56F2B.4040904@gmail.com>	 <1202049511.3318.13.camel@localhost.localdomain>	 <47A5DA5F.3070209@gmail.com>	 <1202055156.3318.58.camel@localhost.localdomain>	 <47A66A39.7090800@gmail.com> <47A6D9F2.5060102@gmail.com>	 <47A72475.5040106@gmail.com> <1202142222.3096.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1202142222.3096.26.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> Plus, tape devices are also ATAPI and since the problem seems to be
> handling of ATAPI pio commands, they need all of this too.  It really
> is, I think, better just to do the setup in the libata slave configure
> if the device is atapi.

If no SCSI HBA needs it, fine.

> For all the rest, I think code demonstrates better ... well, except the
> sata_fsl.c update ... you leave in qc->n_iter, but it's only ever set to
> zero ... doesn't that cause this driver to break?

Probably.  I was gonna cross check with your patch while splitting.
They seem mostly identical so I'll probably use your patch with some
modifications.

> I analysed all the places you use the expanded data length.  To keep the
> true length in the request and add the drain if necessary, I think
> requires this update over my published libata drain patch.  I've also
> added the request accessor to the drain buffer.  Could you verify this
> actually works?  If it does, it's better than all the additions to block
> and sr.  It would probably help to resend the series rebased against git
> current.

No, it doesn't.  Drain needs to extend the sg table too and it makes
controllers lax about buffer overruns for commands they shouldn't be.
Gee.. What's the deal with extra four bytes?  If you're worried about
the size of struct request, chopping off PC request part into a separate
struct would be far better strategy than making what's already confusing
more confusing.

Thanks.

-- 
tejun
