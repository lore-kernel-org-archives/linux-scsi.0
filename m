From: David Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH] aacraid: prevent out-of-bounds access due to changing
 fip header sizes
Date: Fri, 5 Aug 2016 16:58:57 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A15FA6047@avsrvexchmbx1.microsemi.net>
References: <1470299764-96617-1-git-send-email-jthumshirn@suse.de>
 <423FD6710FB8FB4F8728F93591889F9A15FA5D6A@avsrvexchmbx1.microsemi.net>
 <20160805080555.6yq4lnvs2i3up2z3@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160805080555.6yq4lnvs2i3up2z3@c203.arch.suse.de>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Pengfei Wang <wpengfeinudt@gmail.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

[snip]
> > >                 goto cleanup;
> > >         }
> > >
> > > +       if (size != le16_to_cpu(kfib->header.Size)
> > > +                       + sizeof(struct aac_fibhdr)) {
> > > +               retval = -EINVAL;
> > > +               goto cleanup;
> > > +       }
> > > +
> > >         if (kfib->header.Command == cpu_to_le16(TakeABreakPt)) {
> > >                 aac_adapter_interrupt(dev);
> > >                 /*
> > > --
> > > 1.8.5.6
> > >
> >
> > NAK, size is the MAX((header.size+hdr), sender_size). I will send a patch
> tomorrow which will insure that neither of those values is larger than size on the
> second fetch.
> >
> > Thanks, -Dave
> 
> 
> OK, not sure if I understood you correctly, did you mean something like that:
> 
> diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
> index b381b37..a671b54 100644
> --- a/drivers/scsi/aacraid/commctrl.c
> +++ b/drivers/scsi/aacraid/commctrl.c
> @@ -118,6 +118,10 @@ static int ioctl_send_fib(struct aac_dev * dev, void
> __user *arg)
>                 goto cleanup;
>         }
> 
> +       size = max((le16_to_cpu(kfib->header.Size)
> +                      + sizeof(struct aac_fibhdr)),
> +                     le16_to_cpu(kfib->header.SenderSize));
> +
>         if (kfib->header.Command == cpu_to_le16(TakeABreakPt)) {
>                 aac_adapter_interrupt(dev);
>                 /*
> @@ -127,7 +131,7 @@ static int ioctl_send_fib(struct aac_dev * dev, void
> __user *arg)
>                 kfib->header.XferState = 0;
>         } else {
>                 retval = aac_fib_send(le16_to_cpu(kfib->header.Command), fibptr,
> -                               le16_to_cpu(kfib->header.Size) , FsaNormal,
> +                               size , FsaNormal,
>                                 1, 1, NULL, NULL);
>                 if (retval) {
>                         goto cleanup;

Hi Johannes,

The max that I was referring to was earlier in the function;

	 */
	size = le16_to_cpu(kfib->header.Size) + sizeof(struct aac_fibhdr);
	if (size < le16_to_cpu(kfib->header.SenderSize))
		size = le16_to_cpu(kfib->header.SenderSize);

Usually, SenderSize is the amount of space available for return data, while Size if the command size. 
Your original patch would have caused an error if the application was expecting any return data, larger than
The space of the command. For example, a container command is about 50 bytes, while arcconf would set
SenderSize to 512-sizeof(struct aac_fibhdr). I think you will get a better idea with the patch I'll send today.

Thanks, -Dave
