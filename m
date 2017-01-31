From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V3 08/24] aacraid: Added support for response path
Date: Tue, 31 Jan 2017 09:02:52 +0100
Message-ID: <20170131080252.GA3687@linux-x5ow.site>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170127192853.10082-9-RaghavaAditya.Renukunta@microsemi.com>
 <20170130095006.GE3603@linux-x5ow.site>
 <4D8E82A446BF54499747901DBDEB737A7B8A6DA3@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36253 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750927AbdAaIDM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Jan 2017 03:03:12 -0500
Content-Disposition: inline
In-Reply-To: <4D8E82A446BF54499747901DBDEB737A7B8A6DA3@avsrvexchmbx2.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>

On Mon, Jan 30, 2017 at 08:16:48PM +0000, Raghava Aditya Renukunta wrote:
> 
> 
> > -----Original Message-----
> > From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> > Sent: Monday, January 30, 2017 1:50 AM
> > To: Raghava Aditya Renukunta
> > <RaghavaAditya.Renukunta@microsemi.com>
> > Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> > scsi@vger.kernel.org; Dave Carroll <david.carroll@microsemi.com>; Gana
> > Sridaran <gana.sridaran@microsemi.com>; Scott Benesh
> > <scott.benesh@microsemi.com>
> > Subject: Re: [PATCH V3 08/24] aacraid: Added support for response path
> > 
> > EXTERNAL EMAIL
> > 
> > 
> > On Fri, Jan 27, 2017 at 11:28:37AM -0800, Raghava Aditya Renukunta wrote:
> > > This patch enables the driver to actually process the I/O, or srb replies
> > > from adapter. In addition to any HBA1000 or SmartIOC2000 adapter events.
> > >
> > > Signed-off-by: Raghava Aditya Renukunta
> > <raghavaaditya.renukunta@microsemi.com>
> > > Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> > >
> > > ---
> > 
> > Sorry for not completely reviewing the patchset before you reposted.
> > 
> > > @@ -475,16 +475,26 @@ int aac_get_containers(struct aac_dev *dev)
> > >
> > >       if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
> > >               maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
> > > -     fsa_dev_ptr = kzalloc(sizeof(*fsa_dev_ptr) *
> > maximum_num_containers,
> > > -                     GFP_KERNEL);
> > > -     if (!fsa_dev_ptr)
> > > -             return -ENOMEM;
> > > +     if ((dev->fsa_dev == NULL) ||
> > > +             (dev->maximum_num_containers != maximum_num_containers))
> > {
> > > +
> > > +             fsa_dev_ptr = dev->fsa_dev;
> > 
> > Comparison has precedence over logical OR. See
> > http://en.cppreference.com/w/c/language/operator_precedence
> 
> Acknowledged.  , I will remove the parentheses.
> The idea was to make it easier to read the code , if there were enclosed in 
> Parenthesis  (I dabbled a bit in lisp , and for me brackets makes it easier to read).

I think it makes it a bit less obvious and yes it kinda looks like LISP,
you're right.

> 
> > 
> > >
> > > -     dev->fsa_dev = fsa_dev_ptr;
> > > -     dev->maximum_num_containers = maximum_num_containers;
> > > +             dev->fsa_dev = kzalloc(sizeof(*fsa_dev_ptr) *
> > > +                             maximum_num_containers, GFP_KERNEL);
> > 
> > kcalloc()?
> 
> Yes kcalloc makes sense, but then an additional mem set would be required.
> Unless there is a kzcalloc or kczalloc?

No kcalloc() (and it's user-space counterpart calloc() give you zeroed out
memory). If you don't want a zero-fill kmalloc_array() would be the way to go.

Thanks for taking care of that,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
