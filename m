From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [patch 18/30] Fix |/|| confusion in fusion driver
Date: Tue, 8 May 2007 11:06:59 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7070C8E5@NAMAIL4.ad.lsil.com>
References: <200704260735.l3Q7ZK79024259@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35043 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbXEHRHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 13:07:21 -0400
Content-class: urn:content-classes:message
In-Reply-To: <200704260735.l3Q7ZK79024259@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, dmueller@osuse.de

On Thursday, April 26, 2007 1:35 AM, Dirk Mueller wrote:

> 
> This patch corrects a |/|| confusion in 
> mptscsih_copy_sense_data.  Using ||
> means that the data that ends up being written is (almost always) 1,
> instead of being bit-wise or'ed.
> 
> Cc: Eric Moore <eric.moore@lsi.com>
> Cc: James Bottomley <James.Bottomley@SteelEye.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/message/fusion/mptscsih.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff -puN 
> drivers/message/fusion/mptscsih.c~fix--confusion-in-fusion-dri
> ver drivers/message/fusion/mptscsih.c
> --- 
> a/drivers/message/fusion/mptscsih.c~fix--confusion-in-fusion-driver
> +++ a/drivers/message/fusion/mptscsih.c
> @@ -2463,9 +2463,9 @@ mptscsih_copy_sense_data(struct scsi_cmn
>  				ioc->events[idx].event = 
> MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE;
>  				ioc->events[idx].eventContext = 
> ioc->eventContext;
>  
> -				ioc->events[idx].data[0] = 
> (pReq->LUN[1] << 24) ||
> -					
> (MPI_EVENT_SCSI_DEV_STAT_RC_SMART_DATA << 16) ||
> -					(sc->device->channel << 
> 8) || sc->device->id;
> +				ioc->events[idx].data[0] = 
> (pReq->LUN[1] << 24) |
> +					
> (MPI_EVENT_SCSI_DEV_STAT_RC_SMART_DATA << 16) |
> +					(sc->device->channel << 
> 8) | sc->device->id;
>  
>  				ioc->events[idx].data[1] = 
> (sense_data[13] << 8) || sense_data[12];
>  


Thanks, I agree with the change, however shouldn't we be changing:

>  ioc->events[idx].data[1] = > (sense_data[13] << 8) || sense_data[12];
>  

to

>  ioc->events[idx].data[1] = > (sense_data[13] << 8) | sense_data[12];
>  


And in the  mptbase.h, the definition of the struct should be changed
from 

> typedef struct _mpt_ioctl_events {
>	u32	event;		/* Specified by define above */
>	u32	eventContext;	/* Index or counter */
>	int	data[2];		/* First 8 bytes of Event Data
*/
> } MPT_IOCTL_EVENTS;

to

> typedef struct _mpt_ioctl_events {
>	u32	event;		/* Specified by define above */
>	u32	eventContext;	/* Index or counter */
>	u32	data[2];		/* First 8 bytes of Event Data
*/
> } MPT_IOCTL_EVENTS;


