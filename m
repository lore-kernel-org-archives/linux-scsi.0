From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH 5/7] scsi: ufs: Refactor descriptor read for write
Date: Mon, 4 Jun 2018 08:40:56 -0700
Message-ID: <CAE=gft5ZDX-T5qHYy7AJqDkfNr4-yVpTFzZq_FPS86LfFQnvfA@mail.gmail.com>
References: <20180529181740.195362-1-evgreen@chromium.org> <20180529181740.195362-6-evgreen@chromium.org>
 <21ce321eb2d81d59d6e4578669b8287b9ac4d29f.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <21ce321eb2d81d59d6e4578669b8287b9ac4d29f.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart.VanAssche@wdc.com
Cc: jejb@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, Vinayak Holikatti <vinholikatti@gmail.com>, Stanislav.Nijnikov@wdc.com, Gwendal Grignou <gwendal@chromium.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 4, 2018 at 1:41 AM Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
>
> On Tue, 2018-05-29 at 11:17 -0700, Evan Green wrote:
> >       /* Check whether we need temp memory */
> >       if (param_offset != 0 || param_size < buff_len) {
> > -             desc_buf = kmalloc(buff_len, GFP_KERNEL);
> > +             desc_buf = kzalloc(buff_len, GFP_KERNEL);
> >               if (!desc_buf)
> >                       return -ENOMEM;
> > +
> > +             /* If it's a write, first read the complete descriptor, then
> > +              * copy in the parts being changed.
> > +              */
>
> Have you verified this patch with checkpatch? The above comment does not follow
> the Linux kernel coding style.

Yes, but I probably forgot to add that switch that turns on even more
checks. Will fix.

>
> > +             if (opcode == UPIU_QUERY_OPCODE_WRITE_DESC) {
> > +                     if ((int)param_offset + (int)param_size > buff_len) {
> > +                             ret = -EINVAL;
> > +                             goto out;
> > +                     }
> > +
> > +                     ret = ufshcd_query_descriptor_retry(hba,
> > +                                             UPIU_QUERY_OPCODE_READ_DESC,
> > +                                             desc_id, desc_index, 0,
> > +                                             desc_buf, &buff_len);
> > +
> > +                     if (ret) {
> > +                             dev_err(hba->dev,
> > +                                     "%s: Failed reading descriptor. desc_id %d, desc_index %d, param_offset %d, ret %d",
> > +                                     __func__, desc_id, desc_index,
> > +                                     param_offset, ret);
> > +
> > +                             goto out;
> > +                     }
> > +
> > +                     memcpy(desc_buf + param_offset, param_buf, param_size);
> > +             }
>
> The above code is indented deeply. I think that means that this code would become
> easier to read if a helper function would be introduced.

Ok.
>
> Additionally, I think locking is missing from the above code. How else can race
> conditions between concurrent writers be prevented?

Hm, yeah I think this followed along with my thinking that there
wouldn't be multiple processes provisioning at once. This function
will always write a consistent version of one caller's view, but
multiple callers might clobber each other's writes. I can explore
adding locking.
-Evan
