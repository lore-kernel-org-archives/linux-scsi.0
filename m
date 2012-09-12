From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 3/3] block: add back command filter modification via
 sysfs
Date: Wed, 12 Sep 2012 13:41:24 +0100
Message-ID: <20120912134124.55d968ef@pyramind.ukuu.org.uk>
References: <1347449133-26476-1-git-send-email-pbonzini@redhat.com>
	<1347449133-26476-4-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1347449133-26476-4-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


> +ssize_t blk_filter_store(struct request_queue *q,
> +			 const char *page, size_t count, int rw)
> +{
> +	unsigned long okbits[BLK_SCSI_CMD_PER_LONG], *target_okbits;
> +	bool set;
> +	const char *p = page;
> +	char *endp;
> +	int start = -1, cmd;
> +
> +	if (!q->cmd_filter) {
> +		q->cmd_filter = kmalloc(sizeof(struct blk_cmd_filter),
> +					GFP_KERNEL);
> +		blk_set_cmd_filter_defaults(q->cmd_filter);
> +	}
> +

This also needs CAP_SYS_RAWIO otherwise you have a capability escalation
path.

I'm not really in favour of this patch as is. It's not as flexible as
doing it with a BPF filter which if we are going to have a new API is
going to be cleaner, faster and has a clear understood API plus tools.

With BPF you can do things like enabling command A with option B on a
specific device for a certain block range.
