From: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [patch] Re: SCSI logging sucks
Date: Fri, 09 Feb 2007 17:45:39 -0500
Message-ID: <45CCF993.1030501@redhat.com>
References: <45CA0716.5060803@redhat.com> <20070207153530.70412bc3.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423348AbXBIWow (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Feb 2007 17:44:52 -0500
In-Reply-To: <20070207153530.70412bc3.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, jejb <james.bottomley@steeleye.com>

Randy Dunlap wrote:
> Patch for Documentation/kernel-parameters.txt is below.
> Want more/different?
>
>
> Is this part of drivers/scsi/Kconfig correct??
>
> """
> config SCSI_LOGGING
> 	bool "SCSI logging facility"
> 	depends on SCSI
> 	---help---
> 	  This turns on a logging facility that can be used to debug a number
> 	  of SCSI related problems.
>
> 	  If you say Y here, no logging output will appear by default, but you
> 	  can enable logging by saying Y to "/proc file system support" and
> 	  "Sysctl support" below and executing the command
>
> 	  echo "scsi log token [level]" > /proc/scsi/scsi
>
> 	  at boot time after the /proc file system has been mounted.
>
> 	  There are a number of things that can be used for 'token' (you can
> 	  find them in the source: <file:drivers/scsi/scsi.c>), and this
> 	  allows you to select the types of information you want, and the
> 	  level allows you to select the level of verbosity.
> """
>
>   
I have no clue whether that works, but looking at scsi.c it would
seem it doesn't.  I only see add-single-device and remove-single-device
in there.
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Minor corrections and additions to 'scsi_logging_level', as pointed out
> by Chuck Ebbert.
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  Documentation/kernel-parameters.txt |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> --- linux-2620-work.orig/Documentation/kernel-parameters.txt
> +++ linux-2620-work/Documentation/kernel-parameters.txt
> @@ -1444,7 +1444,10 @@ and is between 256 and 4096 characters. 
>  			Format: <vendor>:<model>:<flags>
>  			(flags are integer value)
>  
> -	scsi_logging=	[SCSI]
> +	scsi_logging_level=	[SCSI] a bit mask of logging levels
> +			See drivers/scsi/scsi_logging.h for bits.  Also
> +			settable via sysctl at dev.scsi.logging_level
> +			(/proc/sys/dev/scsi/logging_level).
>  
>  	scsi_mod.scan=	[SCSI] sync (default) scans SCSI busses as they are
>  			discovered.  async scans them in kernel threads,
>   

Patch looks good. The script from IBM looks even better.

