From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] scsi: hpsa: how to destroy your files
Date: Thu, 01 Sep 2011 11:50:38 -0700
Message-ID: <1314903038.3067.27.camel@dabdike>
References: <20110721181605.31672.36250.stgit@beardog.cce.hp.com>
	 <1314890642.2823.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20110901160724.GN9189@beardog.cce.hp.com>
	 <1314898815.2823.33.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CAL1RGDWu4mBE3=0BC3iNnvfSSuT2pfGrXsBZBU-VB+tqZx7DeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDWu4mBE3=0BC3iNnvfSSuT2pfGrXsBZBU-VB+tqZx7DeA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, scameron@beardog.cce.hp.com, Jon Mason <mason@myri.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-09-01 at 10:58 -0700, Roland Dreier wrote:
> > OK I found the bad commit,I got lucky... I lost some files but my
> > machine was able to complete the bisection. CC involved people
> 
> > # bad: [b03e7495a862b028294f59fc87286d6d78ee7fa1] PCI: Set PCI-E Max Payload Size on fabric
> 
> Hi Eric,
> 
> I guess it would be useful to see "lspci -vv" output with a "good" kernel
> and with that bad patch applied.  Most likely we should see some difference
> somewhere in the MaxPayload fields in the PCI Express capability of
> some device.
> 
> Either the RAID controller or something else lies, and puts a value
> in the DevCap that it can't actually support, or else the patch is
> buggy and puts something out of range in a DevCtl somewhere.


While we investigate, I think the problems produced by the patch (data
corruption) are serious enough to warrant reverting it, please Jesse.

Thanks,

James
