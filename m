From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH UPDATED block#for-2.6.31 2/3] block: set rq->resid_len
 to blk_rq_bytes() on issue
Date: Sun, 17 May 2009 20:32:58 +0900
Message-ID: <4A0FF5EA.3020805@gmail.com>
References: <4A0D86DB.9000203@kernel.org> <4A0D87D2.7090806@gmail.com> <4A0E0650.1020500@gmail.com> <4A0FCF52.7070406@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A0FCF52.7070406@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Borislav Petkov <petkovbb@googlemail.com>, Pete Zaitcev <zaitcev@redhat.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, Eric Moore <Eric.Moore@lsi.com>, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hello, Boaz.

Boaz Harrosh wrote:
> Surly this is not enough. This is not the only place rq->__data_len
> gets a value.  Specifically it can be added to in blk_rq_append_bio.
> You must then update all places that set rq->__data_len to also set
> rq->resid_len.

Right, nice spotting, but I think those are the only two places.  You
now see why I don't like that append thing.  :-)

> Alternatively you could do a single:
> +	rq->resid_len = blk_rq_bytes(rq);
> 
> inside  blk_fetch_request(q) or before the call to prep_fn, or even at
> __elv_add_request().

I think I'll just add resid_len adjustment there right after
__data_len manipulation.  That code path should really go away
eventually.

Thanks.

-- 
tejun
