From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2 2/6] esp_scsi: Track residual for PIO transfers
Date: Mon, 15 Oct 2018 09:14:18 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1810150902430.10@nippy.intranet>
References: <cover.1539497520.git.fthain@telegraphics.com.au> <11a3a80e74a006040460fa051747e6a79c6382ce.1539497520.git.fthain@telegraphics.com.au> <CAMuHMdV-VUCeO_uOwOtF2Cu-eXria2n-wEaj1qMMnnFWcOSFeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdV-VUCeO_uOwOtF2Cu-eXria2n-wEaj1qMMnnFWcOSFeg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, scsi <linux-scsi@vger.kernel.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 14 Oct 2018, Geert Uytterhoeven wrote:

> 
> > Fixes: 6fe07aaffbf0
> 
> Fixes: 6fe07aaffbf0 ("[SCSI] m68k: new mac_esp scsi driver")
> 

Fixed.

> > Tested-by: Stan Johnson <userm57@yahoo.com>
> > Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> > Tested-by: Michael Schmitz <schmitzmic@gmail.com>
> 
> > --- a/drivers/scsi/esp_scsi.h
> > +++ b/drivers/scsi/esp_scsi.h
> > @@ -540,6 +540,8 @@ struct esp {
> >
> >         void                    *dma;
> >         int                     dmarev;
> > +
> > +       int                     send_cmd_residual;
> 
> unsigned int?
> 

My first thought was to use u32, same as esp_count. But it turns out that 
the end result really is an int --

static int esp_data_bytes_sent(struct esp *esp, struct esp_cmd_entry *ent,
                               struct scsi_cmnd *cmd)
{
        int fifo_cnt, ecount, bytes_sent, flush_fifo;

        ...
        bytes_sent = esp->data_dma_len;
        bytes_sent -= ecount;
        bytes_sent -= esp->send_cmd_residual;
	...
        return bytes_sent;
}

Apparently over/underflow is a real possibility, because there is a test 
for this in esp_process_event().

-- 

> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 
