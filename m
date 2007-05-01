From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: BAD_SG_DMA panic in aha1542
Date: Tue, 1 May 2007 14:46:23 +0100
Message-ID: <20070501144623.361d37f0@the-village.bc.nu>
References: <20070501021032.61120DBA1@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1423542AbXEANmq@vger.kernel.org>
In-Reply-To: <20070501021032.61120DBA1@gherkin.frus.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bob Tracy <rct@gherkin.frus.com>
Cc: James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> That's as close as it gets without redoing everything from scratch.
> I'll give Alan's and James' patches a go within the next 13 hours.
> 
> (Alan: what *else* would you name a variable associated with a bounce
> buffer besides Zebedee?  Thanks for the occasion to smile...)

The one I sent has a memory leak but it won't matter for basic testing.
Or you can change the final bit to


        scsi_normalize_sense((char *)sense, sizeof(*sense), &sshdr);
        
        if (zebedee != cgc->buffer) {
                if (cgc->data_direction == DMA_FROM_DEVICE)    
                        memcpy(cgc->buffer, zebedee, cgc->buflen);
                kfree(zebedee); /* Time for bed */        
        }

Alan
--

`I can hear you.` ,said Florence. `It s not true. Noddy and I are just
good friends.`
