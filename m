From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Prevent busy looping
Date: Wed, 11 Jun 2008 08:05:02 +0100
Message-ID: <20080611080502.4aa43980@core>
References: <20080416151305.8788.63912.stgit@denkblock.local>
	<20080416163152.GK12774@kernel.dk>
	<87r6d5l9pb.fsf@denkblock.local>
	<20080417071335.GR12774@kernel.dk>
	<87ve2gc1bn.fsf@denkblock.local>
	<484F7A8D.1040809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <484F7A8D.1040809@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> Elias's synthetic test case triggered infinite loop because it wasn't
> a proper ->qc_defer().  ->qc_defer() should never defer commands when
> the target is idle.

Target or host ? We *do* defer commands in the case of an idle channel
when dealing with certain simplex controllers that can only issue one
command per host not one per cable (and in fact in the general case we
can defer commands due to activity on the other drive on the cable).

Alan
