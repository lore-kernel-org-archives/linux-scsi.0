From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] SCSI Core cmd allocation 3/3
Date: Sat, 11 Jan 2003 18:03:55 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030111180355.B2225@infradead.org>
References: <3E1A2140.3000408@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E1A2140.3000408@splentec.com>; from luben@splentec.com on Mon, Jan 06, 2003 at 07:37:20PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Jan 06, 2003 at 07:37:20PM -0500, Luben Tuikov wrote:
> This patch introduces slab allocation of SCSI command structs
> with (currently) one backup scsi command struct per host in
> host->free_list.

Like James I liked the idea, but I think the patch has a few issues.
(the comments are in addition to what James already said).

> struct scsi_cmnd * scsi_get_command(struct Scsi_Host *host, int alloc_flags);

We only have two callers of this, one is scsi_getset_command and the other
is used for allocating the freelist.  For the latter most of the code in
this function is superflous, it just needs the kmem_cache_alloc.

I'd suggest just using the kmem_cache_alloc directly for the freelist and
merging it into your current scsi_getset_command.  While at it the name
scsi_get_command should be transfered to it also :)

> void scsi_put_command(struct scsi_cmnd *cmd);
> void scsi_setup_command(struct scsi_device *dev, struct scsi_cmnd *cmd);
> 
> static inline struct scsi_cmnd * scsi_getset_command(struct scsi_device *dev,
>                                                      int flags);
> For when the device is known (most of the cases).
> 
> Also:
> 
> int scsi_create_cmdcache(struct scsi_core_data *scsi_core);
> int scsi_destroy_cmdcache(struct scsi_core_data *scsi_core);
> 
> struct scsi_core_data is a holder of all global SCSI Core data.

I don't like the scsi_core_data concept.  We don't need a struct for it as
all variables not exported from scsi_mod.ko are the SCSI core data per
defintion.  Adding a struct container is just obsfucation.

> diff -Naur -X /usr/src/dontdiff linux-2.5.54-2/drivers/scsi/aic7xxx/aic79xx_osm.c linux-2.5.54-3/drivers/scsi/aic7xxx/aic79xx_osm.c
> --- linux-2.5.54-2/drivers/scsi/aic7xxx/aic79xx_osm.c	2003-01-06 11:57:22.000000000 -0500
> +++ linux-2.5.54-3/drivers/scsi/aic7xxx/aic79xx_osm.c	2003-01-06 17:16:13.000000000 -0500
> @@ -971,7 +971,7 @@
>   	struct	 ahd_linux_device *dev;
>   	u_long	 flags;
> 
> -	ahd = *(struct ahd_softc **)cmd->host->hostdata;
> +	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;

Hmm, you seem to include some parts of the previous patch?

> +
> +/* inline funcs: */
> +
> +/* scsi_getset_command: allocate, set and return a command struct,
> +   when the device is known.
> +*/
> +static inline struct scsi_cmnd *scsi_getset_command(struct scsi_device *dev,
> +						    int flags)
> +{
> +	struct scsi_cmnd *cmd;
> +
> +	if (!dev) return NULL;
> +	if (!dev->host) return NULL;
> +	scsi_setup_command(dev, (cmd = scsi_get_command(dev->host, flags)));
> +	return cmd;
> +}				
> +

Your code wants some updates to match Documentation/CodingStyle.

> -EXPORT_SYMBOL(scsi_allocate_device);
> +/* Obsolete! Use scsi_get_command() or scsi_getset_command(). */
> +/* EXPORT_SYMBOL(scsi_allocate_device); */

Just remove it.  We have that comment and the code history in SCCS
once it's applied.

