From: Joerg Roedel <joro@8bytes.org>
Subject: Re: BUG: SCSI aic7xxx driver and AMD IOMMU
Date: Thu, 26 Mar 2015 16:52:49 +0100
Message-ID: <20150326155248.GW4441@8bytes.org>
References: <54E1FFFA.1060403@compro.net>
 <54F60D33.8090401@compro.net>
 <20150323150304.GQ4441@8bytes.org>
 <5511513D.6090106@compro.net>
 <20150325135937.GR4441@8bytes.org>
 <20150325151332.GT4441@8bytes.org>
 <5512E412.9040807@compro.net>
 <20150326124559.GV4441@8bytes.org>
 <55141E87.8040506@compro.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55141E87.8040506@compro.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Hounschell <markh@compro.net>
Cc: iommu@lists.linux-foundation.org, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org >> SCSI development list" <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Mark,

On Thu, Mar 26, 2015 at 10:58:15AM -0400, Mark Hounschell wrote:
> Sorry but CMA was still badly broken. I have a patch below that works.

In which way is it broken? What happens when you try to allocate memory
with dma_alloc_coherent?

> I've tested it with small (no CMA) and large (with CMA) dma's using
> dma_alloc_coherent. The patch below is just the "git diff" from your
> cloned tree piped to a file then copied into this email. If you require
> an official patch I can send one. Just let me know.

The main differences I can spot are that you change the order (first
CMA, then buddy) and you manually align the input size. I can see the
reason for the later, but why does CMA need to be tried first?

> Also, in my opinion, this CMA thing is clearly a BUG not a feature
> request. The AMD iommu clearly breaks CMA. I feel what ever fix
> you are happy with should be back ported to stable.

It is not a BUG, the interface definition for dma_alloc_coherent does
not specify that it can allocate infinite amounts of memory. So this
patch does not qualify for stable.


	Joerg
