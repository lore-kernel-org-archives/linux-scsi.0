From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 06/12] target: Add memory allocation for
 bidirectional commands
Date: Sat, 24 Aug 2013 16:44:05 -0700
Message-ID: <1377387845.32763.149.camel@haakon3.risingtidesystems.com>
References: <1377147250-10125-1-git-send-email-nab@daterainc.com>
	 <1377147250-10125-7-git-send-email-nab@daterainc.com>
	 <20130824151817.GA15588@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130824151817.GA15588@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, James Bottomley <JBottomley@Parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2013-08-24 at 08:18 -0700, Christoph Hellwig wrote:
> >  static int
> > +transport_generic_get_mem_bidi(struct se_cmd *cmd)
> 
> Except for the fields touched in struct se_cmd this is a duplication
> of transport_generic_get_mem.  I'd suggest to factor that one into
> a new helper:
> 
> static int
> target_alloc_sgl(struct scatterlist **sgl, unsigned int **nents,
> 		u32 length, gfp_t gfp_mask)
> {
> 	..
> }
> 
> and then call that one from transport_generic_new_cmd directly,

Sounds reasonable enough, doing that bit of refactoring now..

> including opencoding the actual BIDI case there as a first step.
> 

Not sure why this needs to be opencoded for BIDI, instead of just doing
target_alloc_sgl(&cmd->t_bidi_data_sg, ...) for the two SCF_BIDI ||
SCF_COMPARE_AND_WRITE cases in transport_generic_new_cmd()..?

--nab
