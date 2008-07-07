From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 04/16] git-scsi-misc: fix SCSI_DH build errors
Date: Mon, 07 Jul 2008 17:10:55 -0500
Message-ID: <1215468655.3274.45.camel@localhost.localdomain>
References: <200807040647.m646lPjk017478@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58484 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754135AbYGGWLD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2008 18:11:03 -0400
In-Reply-To: <200807040647.m646lPjk017478@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, sekharan@us.ibm.com, agk@redhat.com, andmike@us.ibm.com, hare@suse.de, michaelc@cs.wisc.edu, randy.dunlap@oracle.com

On Thu, 2008-07-03 at 23:47 -0700, akpm@linux-foundation.org wrote:
> From: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> Do not automatically "select" SCSI_DH for dm-multipath. If SCSI_DH
> doesn't exist, just do not allow  hardware handlers to be used.
> 
> Handle SCSI_DH being a module also. Make sure it doesn't allow DM_MULTIPATH
> to be compiled in when SCSI_DH is a module.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Alasdair G Kergon <agk@redhat.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Mike Anderson <andmike@us.ibm.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/md/Kconfig     |    2 +-
>  drivers/md/dm-mpath.c  |    2 ++
>  include/scsi/scsi_dh.h |   12 +++++++++++-
>  3 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff -puN drivers/md/Kconfig~git-scsi-misc-fix-scsi_dh-build-errors drivers/md/Kconfig
> --- a/drivers/md/Kconfig~git-scsi-misc-fix-scsi_dh-build-errors
> +++ a/drivers/md/Kconfig
> @@ -252,7 +252,7 @@ config DM_ZERO
>  config DM_MULTIPATH
>  	tristate "Multipath target"
>  	depends on BLK_DEV_DM
> -	select SCSI_DH
> +	depends on SCSI_DH || !SCSI_DH

This is a bit horrible.  It's not very obvious what it means and it
critically depends on the current !m == m behaviour.

>  	---help---
>  	  Allow volume managers to support multipath hardware.
>  
> diff -puN drivers/md/dm-mpath.c~git-scsi-misc-fix-scsi_dh-build-errors drivers/md/dm-mpath.c
> --- a/drivers/md/dm-mpath.c~git-scsi-misc-fix-scsi_dh-build-errors
> +++ a/drivers/md/dm-mpath.c
> @@ -664,6 +664,8 @@ static int parse_hw_handler(struct arg_s
>  	request_module("scsi_dh_%s", m->hw_handler_name);
>  	if (scsi_dh_handler_exist(m->hw_handler_name) == 0) {
>  		ti->error = "unknown hardware handler type";
> +		kfree(m->hw_handler_name);
> +		m->hw_handler_name = NULL;

This looks like some type of separate bug fix ... it's certainly not
mentioned in the change log and has nothing to do with modular compile
problems.

James


