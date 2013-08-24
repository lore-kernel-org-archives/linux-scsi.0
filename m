From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH-v2 06/12] target: Add memory allocation for bidirectional
 commands
Date: Sat, 24 Aug 2013 08:18:17 -0700
Message-ID: <20130824151817.GA15588@infradead.org>
References: <1377147250-10125-1-git-send-email-nab@daterainc.com>
 <1377147250-10125-7-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1377147250-10125-7-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

>  static int
> +transport_generic_get_mem_bidi(struct se_cmd *cmd)

Except for the fields touched in struct se_cmd this is a duplication
of transport_generic_get_mem.  I'd suggest to factor that one into
a new helper:

static int
target_alloc_sgl(struct scatterlist **sgl, unsigned int **nents,
		u32 length, gfp_t gfp_mask)
{
	..
}

and then call that one from transport_generic_new_cmd directly,
including opencoding the actual BIDI case there as a first step.

If we go down your proposed route for COMPARE and WRITE we'd also
allocate that buffer there, although I think there is a more elegant
way to do that, but more on that later.
