From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 2.5.59] sim710: cleanup/remove most cli()'s
Date: 06 Feb 2003 10:35:45 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044549347.2331.58.camel@mulgrave>
References: <200302041123.06204@bilbo.math.uni-mannheim.de>
	<200302051603.48510@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id IAA08204
	for <linux-scsi@vger.kernel.org>; Thu, 6 Feb 2003 08:35:51 -0800
In-Reply-To: <200302051603.48510@bilbo.math.uni-mannheim.de>
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2003-02-05 at 09:03, Rolf Eike Beer wrote:
> Hi again,
> 
> I'm now looking for the best way to port this to use 53c700.c. This will 
> surely take a while, should I fix my fix and resend it or better leave this 
> unfixed until I find time to port it?

Do you actually have one of these (and is it EISA or MCA)?

I've got a MCA 710 in an old NCR3430 I can use.  I think the conversion
will only take a few days, I can try it out

> For today this fix should be enough. The second one is unneeded because 
> mca_register_driver does it.
> 
> Eike
> 
> Note: Please CC me, I'm not ...
> 
> --- linux-2.5.59-test/drivers/scsi/53c700.c     Fri Jan 17 03:21:40 2003
> +++ linux-2.5.59/drivers/scsi/53c700.c  Wed Feb  5 15:47:00 2003
> @@ -1769,7 +1769,7 @@
>         NCR_700_set_depth(SCp->device, NCR_700_get_depth(SCp->device) + 1);
> 
>         /* begin the command here */
> -       /* no need to check for NULL, test for command_slot_cound above
> +       /* no need to check for NULL, test for command_slot_count above
>          * ensures a slot is free */
>         slot = find_empty_slot(hostdata);
> 
> --- linux-2.5.59-test/drivers/scsi/NCR_D700.c   Fri Jan 17 03:21:39 2003
> +++ linux-2.5.59/drivers/scsi/NCR_D700.c        Wed Feb  5 15:47:02 2003
> @@ -340,7 +340,6 @@
>         .id_table = NCR_D700_id_table,
>         .driver = {
>                 .name = "NCR_D700",
> -               .bus = &mca_bus_type,
>                 .probe = NCR_D700_probe,
>         },

This is actually required by convention.  Just in case we ever move to a
unified driver registration model, it would use the bus type to test on.

James


