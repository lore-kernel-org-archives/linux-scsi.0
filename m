From: "Allexio Ju" <allexio.ju@gmail.com>
Subject: RE: [PATCH] aacraid: Add likely() and unlikely()
Date: Tue, 27 Mar 2007 09:17:44 -0700
Message-ID: <a02278b00703270917w5dcaaf25y92e31dfd6e920b91@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.234]:49538 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932819AbXC0QRq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Mar 2007 12:17:46 -0400
Received: by wr-out-0506.google.com with SMTP id 76so2014164wra
        for <linux-scsi@vger.kernel.org>; Tue, 27 Mar 2007 09:17:45 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: arjan@infradead.org
Cc: mark_salyzyn@adaptec.com, linux-scsi@vger.kernel.org

On Thu, 2007-03-22 at 2007 2:24 AM, Arjan van de Ven wrote:
> (I assume you're aware that likely/unlikely should only be
> used for 99:1 or higher ratios, this one looks correct for sure)
Could you share details of reasons why those macros should be used in the way?
I thought those macros simply tell compiler to layout code in such a
way that minimizes unnecessary jumps.

Thank you,

Allexio

> On Wed, 2007-03-21 at 15:43 -0400, Salyzyn, Mark wrote:
> > Add some likely() and unlikely() compiler hints in some of
> the aacraid
> > hardware interface layers. There should be no operational
> side effects
> > resulting from this patch and the changes should be mostly
> benign on
> > x86 platforms.
> >
> > ObligatoryDisclaimer: Please accept my condolences
> regarding Outlook's
> > handling of patches attachments.
> >
> > This attached patch is against current scsi-misc-2.6
>
> -               if((fibptr->flags & FIB_CONTEXT_FLAG_TIMED_OUT)){
> +               if(unlikely(fibptr->flags &
> + FIB_CONTEXT_FLAG_TIMED_OUT)){
>                         return -ETIMEDOUT;
>                 } else {
>                         return 0;
>
> while you're at it, please remove the extra {}'s as well
>
> (I assume you're aware that likely/unlikely should only be
> used for 99:1 or higher ratios, this one looks correct for sure)
