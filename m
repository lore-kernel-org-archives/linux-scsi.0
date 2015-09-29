From: =?utf-8?B?IlTDs3RoIEF0dGlsYSI=?= <atoth@atoth.sote.hu>
Subject: Re: twa generates WARNING upon boot
Date: Tue, 29 Sep 2015 21:17:58 +0200
Message-ID: <72da6fd103a0504fe9cd0a3967345cc9.squirrel@atoth.sote.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atoth.sote.hu ([195.111.75.211]:36104 "EHLO atoth.sote.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965309AbbI2TSI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 15:18:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, Thx PaX Team <pageexec@freemail.hu>

2015.Szeptember 29.(K) 20:33 id=C5=91pontban James Bottomley ezt =C3=AD=
rta:
> On Tue, 2015-09-29 at 20:25 +0200, "T=C3=B3th Attila" wrote:
>> 2015.Szeptember 29.(K) 20:02 id=C5=91pontban James Bottomley ezt =C3=
=ADrta:
>> > On Tue, 2015-09-29 at 10:37 -0700, James Bottomley wrote:
>> >> On Tue, 2015-09-29 at 18:49 +0200, "T=C3=B3th Attila" wrote:
>> >> > 2015.Szeptember 27.(V) 23:19 id=C5=91pontban adam radford ezt =C3=
=ADrta:
>> >> > > On Sun, Sep 27, 2015 at 4:56 AM, "T=C3=B3th Attila"
>> <atoth@atoth.sote.hu>
>> >> > > wrote:
>> >> > >> The 3ware card is a 9650SE-12ML running in a Asus Z8PE-D12X
>> >> > >>
>> >> > >
>> >> > > Can you re-try with Christoph's patch:
>> >> > >
>> >> > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.g=
it/commit/?id=3D118c855b5623f3e2e6204f02623d88c09e0c34de
>> >> >
>> >> > As I've told this patch has been already included in the kernel=
 I'm
>> >> using
>> >> > (4.1.7-hardened-r1, which is based on 4.1.7).
>> >> > Out of curiosity I've reverted the patch and the WARNING no lon=
ger
>> >> appears
>> >> > during boot...
>> >>
>> >> Ah, it looks like there's a bug in the patch, it doesn't take int=
o
>> >> account that the driver has a minimum sg map length and it copies=
 for
>> >> things under that, so we're likely unmapping something that wasn'=
t
>> >> mapped.   It's slightly hard to fix given that the indicator flag
>> we'd
>> >> use for this is gone in that patch; does this fix the warning?
>> >
>> > Actually, strike that, it would still barf on internally generated
>> > commands (and it's recursively calling twa_scsi_dma_unmap).  This =
does
>> a
>> > partial revert of the state check which should pick up all cases t=
he
>> > input didn't go through the mapping.
>>
>> Just to be clear before I try something out.
>> In this latter patch you are resurrecting TW_PHASE_SGLIST, which has
>> been
>> ment to be removed in Christoph's patch from the header.
>> I guess I have to reintroduce those phase defines on top of the chan=
ges
>> below in your latest email.
>> Or please let me know what should I exactly try out.
>
> Heh, sorry forgot the header change.  This should be the complete pat=
ch
> attached.

After applying your latest patch I can see no more WARNINGs upon reboot=
!

Please note, that apart from the culprit 3w-9xxx commit
(https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D118c855b5623f3e2e6204f02623d88c09e0c34de),
two other parent commits were introducing similar changes to 3w-xxxx an=
d
3w-sas drivers
(https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D9cd9554615cba14f0877cc9972a6537ad2bdde61,
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/=
?id=3D579d69bc1fd56d5af5761969aa529d1d1c188300).
Those two may also need similar treatment.

Many thanks:
Dw.
--=20
dr T=C3=B3th Attila, Radiol=C3=B3gus, 06-20-825-8057
Attila Toth MD, Radiologist, +36-20-825-8057

> ---
>
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index add419d..751ed66 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -151,7 +151,13 @@ static void
> twa_scsiop_execute_scsi_complete(TW_Device_Extension *tw_dev, int re
>  static char *twa_string_lookup(twa_message_type *table, unsigned int
> aen_code);
>
>  /* Functions */
> +static void twa_scsi_dma_unmap(struct scsi_cmnd *SCpnt)
> +{
> +	if (SCpnt->SCp.phase =3D=3D TW_PHASE_SGLIST)
> +		scsi_dma_unmap(SCpnt);
> +}
>
> +
>  /* Show some statistics about the card */
>  static ssize_t twa_show_stats(struct device *dev,
>  			      struct device_attribute *attr, char *buf)
> @@ -1339,7 +1345,7 @@ static irqreturn_t twa_interrupt(int irq, void
> *dev_instance)
>  				}
>
>  				/* Now complete the io */
> -				scsi_dma_unmap(cmd);
> +				twa_scsi_dma_unmap(cmd);
>  				cmd->scsi_done(cmd);
>  				tw_dev->state[request_id] =3D TW_S_COMPLETED;
>  				twa_free_request_id(tw_dev, request_id);
> @@ -1582,7 +1588,7 @@ static int
> twa_reset_device_extension(TW_Device_Extension *tw_dev)
>  				struct scsi_cmnd *cmd =3D tw_dev->srb[i];
>
>  				cmd->result =3D (DID_RESET << 16);
> -				scsi_dma_unmap(cmd);
> +				twa_scsi_dma_unmap(cmd);
>  				cmd->scsi_done(cmd);
>  			}
>  		}
> @@ -1762,15 +1768,18 @@ static int twa_scsi_queue_lck(struct scsi_cmn=
d
> *SCpnt, void (*done)(struct scsi_
>  	/* Save the scsi command for use by the ISR */
>  	tw_dev->srb[request_id] =3D SCpnt;
>
> +	/* Initialize phase to zero */
> +	SCpnt->SCp.phase =3D TW_PHASE_INITIAL;
> +
>  	retval =3D twa_scsiop_execute_scsi(tw_dev, request_id, NULL, 0, NUL=
L);
>  	switch (retval) {
>  	case SCSI_MLQUEUE_HOST_BUSY:
> -		scsi_dma_unmap(SCpnt);
> +		twa_scsi_dma_unmap(SCpnt);
>  		twa_free_request_id(tw_dev, request_id);
>  		break;
>  	case 1:
>  		SCpnt->result =3D (DID_ERROR << 16);
> -		scsi_dma_unmap(SCpnt);
> +		twa_scsi_dma_unmap(SCpnt);
>  		done(SCpnt);
>  		tw_dev->state[request_id] =3D TW_S_COMPLETED;
>  		twa_free_request_id(tw_dev, request_id);
> @@ -1845,6 +1854,8 @@ static int
> twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
>  				if (sg_count < 0)
>  					goto out;
>
> +				srb->SCp.phase =3D TW_PHASE_SGLIST;
> +
>  				scsi_for_each_sg(srb, sg, sg_count, i) {
>  					command_packet->sg_list[i].address =3D
> TW_CPU_TO_SGL(sg_dma_address(sg));
>  					command_packet->sg_list[i].length =3D cpu_to_le32(sg_dma_len(sg=
));
> diff --git a/drivers/scsi/3w-9xxx.h b/drivers/scsi/3w-9xxx.h
> index 0fdc83c..c88d5bd 100644
> --- a/drivers/scsi/3w-9xxx.h
> +++ b/drivers/scsi/3w-9xxx.h
> @@ -324,6 +324,10 @@ static twa_message_type twa_error_table[] =3D {
>  #define TW_CURRENT_DRIVER_BUILD 0
>  #define TW_CURRENT_DRIVER_BRANCH 0
>
> +/* Phase defines */
> +#define TW_PHASE_INITIAL 0
> +#define TW_PHASE_SGLIST  1
> +
>  /* Misc defines */
>  #define TW_9550SX_DRAIN_COMPLETED	      0xFFFF
>  #define TW_SECTOR_SIZE                        512
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
