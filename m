From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v6 1/4] sg: use rwsem to solve race during exclusive open
Date: Wed, 28 Aug 2013 14:26:18 +0400
Message-ID: <1377685578.2005.50.camel@dabdike>
References: <1377662419.2005.12.camel@dabdike>
	 <1377684472-7815-1-git-send-email-vaughan.cao@oracle.com>
	 <1377684472-7815-2-git-send-email-vaughan.cao@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41172 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752742Ab3H1K0X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Aug 2013 06:26:23 -0400
In-Reply-To: <1377684472-7815-2-git-send-email-vaughan.cao@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: joern@logfs.org, dgilbert@interlog.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2013-08-28 at 18:07 +0800, Vaughan Cao wrote:
> @@ -331,17 +330,20 @@ sg_open(struct inode *inode, struct file *filp)
>         }
>         if ((sfp = sg_add_sfp(sdp, dev)))
>                 filp->private_data = sfp;
> -       else {
> +               /* retval is already provably zero at this point
> because of the
> +                * check after retval =
> scsi_autopm_get_device(sdp->device))
> +                */
> +       else
> +               retval = -ENOMEM;
> +
> +       if (retval) {
> +sem_out:

There's still no need for the double if.  You know the value of retval
in each of the legs of the first if; its only non zero for the else leg,
so you can combine them thus:

        if ((sfp = sg_add_sfp(sdp, dev)))
                filp->private_data = sfp;
               /* retval is already provably zero at this point because of the
                * check after retval scsi_autopm_get_device(sdp->device))
                */
       else {
               retval = -ENOMEM;
 sem_out:
...

James



