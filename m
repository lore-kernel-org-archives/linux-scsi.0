From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] Split SCSI header files
Date: Mon, 6 Apr 2015 17:08:42 +0200
Message-ID: <20150406150842.GA23569@lst.de>
References: <55217B00.6030706@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54410 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbbDFPIo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Apr 2015 11:08:44 -0400
Content-Disposition: inline
In-Reply-To: <55217B00.6030706@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sun, Apr 05, 2015 at 08:12:16PM +0200, Bart Van Assche wrote:
> Move the constants that are used by both initiator and target
> drivers into the new header file <scsi/scsi_proto.h>.

This part looks mostly good, and I would prefer this to be a patch on
it's own. One little nitpick below.

> Move the
> functions that are used by both subsystems into <scsi/scsi_lib.h>.
> Rename drivers/scsi/scsi_lib.c into scsi_ini_lib.c. This change
> will allow to modify the SCSI target code such that the initiator
> SCSI header files are no longer included. Note: the SCSI target
> driver patch is available for review at

I don't really like renaming the file that has most of the initiator side
SCSI code that way.  If we really have to rename it in some way I'd suggest
just merging it into scsi.c as we call forth and back between the two all
the time.

Maybe we can use scsi_common.c/h/.ko to avoid these moves, although I'd
prefer to just duplicate this tiny amount of code.

> +/*
> + * MAX_COMMAND_SIZE is:
> + * The longest fixed-length SCSI CDB as per the SCSI standard.
> + * fixed-length means: commands that their size can be determined
> + * by their opcode and the CDB does not carry a length specifier, (unlike
> + * the VARIABLE_LENGTH_CMD(0x7f) command). This is actually not exactly
> + * true and the SCSI standard also defines extended commands and
> + * vendor specific commands that can be bigger than 16 bytes. The kernel
> + * will support these using the same infrastructure used for VARLEN CDB's.
> + * So in effect MAX_COMMAND_SIZE means the maximum size command scsi-ml
> + * supports without specifying a cmd_len by ULD's
> + */
> +#define MAX_COMMAND_SIZE 16
> +#if (MAX_COMMAND_SIZE > BLK_MAX_CDB)
> +# error MAX_COMMAND_SIZE can not be bigger than BLK_MAX_CDB
> +#endif

This clearly is a limitation of the Linux SCSI initiator, so having it
in the _proto.h header seems like a bad idea.  For now I'd suggest to
keep it where it is, but an additional patch to remove MAX_COMMAND_SIZE
and use BLK_MAX_CDB everywhere would be even better.

> @@ -19,9 +19,8 @@
>  /*
>   * By default we use 32-byte CDBs in TCM Core and subsystem plugin code.
>   *
> - * Note that both include/scsi/scsi_cmnd.h:MAX_COMMAND_SIZE and
> - * include/linux/blkdev.h:BLOCK_MAX_CDB as of v2.6.36-rc4 still use
> - * 16-byte CDBs by default and require an extra allocation for
> + * Note that both MAX_COMMAND_SIZE and BLOCK_MAX_CDB as of v4.0-rc1 still
> + * use 16-byte CDBs by default and require an extra allocation for
>   * 32-byte CDBs to because of legacy issues.

This comment is incorrect.  There aren't any legacy issues, we just decided
to handle > 16 byte CDBs in the slow path.  I'd suggest you remove this
sentence (and the next one) entirely instead of trying to fix it up.
