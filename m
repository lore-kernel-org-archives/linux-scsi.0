From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RESEND PATCH v3] scsi: stex: Remove use of struct timeval
Date: Fri, 30 Oct 2015 13:45:08 +0100
Message-ID: <5927653.jpoZ2K5FqB@wuerfel>
References: <20151030083040.GA31741@tina-laptop> <56335B69.4010502@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56335B69.4010502@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Tina Ruchandani <ruchandani.tina@gmail.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, y2038@lists.linaro.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Friday 30 October 2015 12:58:33 Hannes Reinecke wrote:
> > @@ -1076,7 +1069,7 @@ static int stex_ss_handshake(struct st_hba *hba)
> >       h->req_cnt = cpu_to_le16(hba->rq_count+1);
> >       h->status_sz = cpu_to_le16(sizeof(struct status_msg));
> >       h->status_cnt = cpu_to_le16(hba->sts_count+1);
> > -     stex_gettime(&h->hosttime);
> > +     h->hosttime = cpu_to_le64(ktime_get_real_seconds());
> >       h->partner_type = HMU_PARTNER_TYPE;
> >       h->extra_offset = h->extra_size = 0;
> >       scratch_size = (hba->sts_count+1)*sizeof(u32);
> > 
> Just remove 'hosttime' altogether. It serves no purpose whatsoever.
> 
> 

Are you sure? It is defined in a struct that is shared with the HBA
as part of hba->dma_mem, so unless you have access to the firmware,
it's hard to guess what it might be used for inside of the firmware.

	Arnd
