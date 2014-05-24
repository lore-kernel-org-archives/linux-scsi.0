From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] acornscsi: remove linked command support
Date: Sat, 24 May 2014 12:35:12 +0200
Message-ID: <538075E0.4080001@suse.de>
References: <1400926433.31526.89.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1400926433.31526.89.camel@x220>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>, Russell King <linux@arm.linux.org.uk>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/24/2014 12:13 PM, Paul Bolle wrote:
> The acornscsi driver was added in v2.1.88. It has always #undef-ed
> CONFIG_SCSI_ACORNSCSI_LINK near the top of acornscsi.c. And, just to =
be
> sure, it has also always triggered a preprocessor error if
> CONFIG_SCSI_ACORNSCSI_LINK was still defined. But, as far as I can se=
e,
> it has never even been possible to set SCSI_ACORNSCSI_LINK through
> kconfig, or its predecessors, in the first place.
>
> Let's remove the code involved.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
>
> Also interesting: SCSI_ACORNSCSI_TAGGED_QUEUE can be set through
> kconfig, but its macro will be #undef-ed at the top of acornscsi.c. I
> suppose that #undef could be dropped.
>
> And finally: CONFIG_ACORNSCSI_CONSTANTS has to be set manually. But i=
f
> we'd just drop the CONFIG_ prefix acornscsi.c would become a pet peev=
e
> free zone.
>
>   drivers/scsi/arm/acornscsi.c | 53 ---------------------------------=
-----------
>   1 file changed, 53 deletions(-)
>
> diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscs=
i.c
> index 059ff477a398..2e797a367608 100644
> --- a/drivers/scsi/arm/acornscsi.c
> +++ b/drivers/scsi/arm/acornscsi.c
> @@ -62,13 +62,6 @@
>    */
>   #undef CONFIG_SCSI_ACORNSCSI_TAGGED_QUEUE
>   /*
> - * SCSI-II Linked command support.
> - *
> - * The higher level code doesn't support linked commands yet, and so=
 the option
> - * is undef'd here.
> - */
> -#undef CONFIG_SCSI_ACORNSCSI_LINK
> -/*
>    * SCSI-II Synchronous transfer support.
>    *
>    * Tried and tested...
> @@ -160,10 +153,6 @@
>   #error "Yippee!  ABORT TAG is now defined!  Remove this error!"
>   #endif
>
> -#ifdef CONFIG_SCSI_ACORNSCSI_LINK
> -#error SCSI2 LINKed commands not supported (yet)!
> -#endif
> -
>   #ifdef USE_DMAC
>   /*
>    * DMAC setup parameters
> @@ -1668,42 +1657,6 @@ void acornscsi_message(AS_Host *host)
>   	}
>   	break;
>
> -#ifdef CONFIG_SCSI_ACORNSCSI_LINK
> -    case LINKED_CMD_COMPLETE:
> -    case LINKED_FLG_CMD_COMPLETE:
> -	/*
> -	 * We don't support linked commands yet
> -	 */
> -	if (0) {
> -#if (DEBUG & DEBUG_LINK)
> -	    printk("scsi%d.%c: lun %d tag %d linked command complete\n",
> -		    host->host->host_no, acornscsi_target(host), host->SCpnt->tag)=
;
> -#endif
> -	    /*
> -	     * A linked command should only terminate with one of these mes=
sages
> -	     * if there are more linked commands available.
> -	     */
> -	    if (!host->SCpnt->next_link) {
> -		printk(KERN_WARNING "scsi%d.%c: lun %d tag %d linked command compl=
ete, but no next_link\n",
> -			instance->host_no, acornscsi_target(host), host->SCpnt->tag);
> -		acornscsi_sbic_issuecmd(host, CMND_ASSERTATN);
> -		msgqueue_addmsg(&host->scsi.msgs, 1, ABORT);
> -	    } else {
> -		struct scsi_cmnd *SCpnt =3D host->SCpnt;
> -
> -		acornscsi_dma_cleanup(host);
> -
> -		host->SCpnt =3D host->SCpnt->next_link;
> -		host->SCpnt->tag =3D SCpnt->tag;
> -		SCpnt->result =3D DID_OK | host->scsi.SCp.Message << 8 | host->Scs=
i.SCp.Status;
> -		SCpnt->done(SCpnt);
> -
> -		/* initialise host->SCpnt->SCp */
> -	    }
> -	    break;
> -	}
> -#endif
> -
>       default: /* reject message */
>   	printk(KERN_ERR "scsi%d.%c: unrecognised message %02X, rejecting\n=
",
>   		host->host->host_no, acornscsi_target(host),
> @@ -2825,9 +2778,6 @@ char *acornscsi_info(struct Scsi_Host *host)
>   #ifdef CONFIG_SCSI_ACORNSCSI_TAGGED_QUEUE
>       " TAG"
>   #endif
> -#ifdef CONFIG_SCSI_ACORNSCSI_LINK
> -    " LINK"
> -#endif
>   #if (DEBUG & DEBUG_NO_WRITE)
>       " NOWRITE (" __stringify(NO_WRITE) ")"
>   #endif
> @@ -2851,9 +2801,6 @@ static int acornscsi_show_info(struct seq_file =
*m, struct Scsi_Host *instance)
>   #ifdef CONFIG_SCSI_ACORNSCSI_TAGGED_QUEUE
>       " TAG"
>   #endif
> -#ifdef CONFIG_SCSI_ACORNSCSI_LINK
> -    " LINK"
> -#endif
>   #if (DEBUG & DEBUG_NO_WRITE)
>       " NOWRITE (" __stringify(NO_WRITE) ")"
>   #endif
>
I'm all for it. Removing never-really-implemented feature on obsolete=20
hardware is always a good idea.

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
