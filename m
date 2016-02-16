From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] fusion-mptbase: handle failed allocation for workqueue
Date: Tue, 16 Feb 2016 15:52:20 -0500
Message-ID: <1455655940.22112.429.camel@localhost.localdomain>
References: <1455591041-8667-1-git-send-email-wuninsu@gmail.com>
	 <1455646709.22112.412.camel@localhost.localdomain>
	 <CAGoFzNfFtxHRYz_UF1qS-wWhwNapffBx9xrMA2Lu51FGeTmo7w@mail.gmail.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGoFzNfFtxHRYz_UF1qS-wWhwNapffBx9xrMA2Lu51FGeTmo7w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Insu Yun <wuninsu@gmail.com>
Cc: nagalakshmi.nandigama@avagotech.com, praveen.krishnamoorthy@avagotech.com, sreekanth.reddy@avagotech.com, abhijit.mahajan@avagotech.com, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Taesoo Kim <taesoo@gatech.edu>, Yeongjin Jang <yeongjin.jang@gatech.edu>, "Yun, Insu" <insu@gatech.edu>, Changwoo Min <changwoo@gatech.edu>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-02-16 at 13:33 -0500, Insu Yun wrote:
> 
> 
> On Tue, Feb 16, 2016 at 1:18 PM, Ewan Milne <emilne@redhat.com> wrote:
>         On Mon, 2016-02-15 at 21:50 -0500, Insu Yun wrote:
>         > the failure of ioc->reset_work_q is checked,
>         > but not ioc->fw_event_q.
>         >
>         > Signed-off-by: Insu Yun <wuninsu@gmail.com>
>         > ---
>         >  drivers/message/fusion/mptbase.c | 7 +++++++
>         >  1 file changed, 7 insertions(+)
>         >
>         > diff --git a/drivers/message/fusion/mptbase.c
>         b/drivers/message/fusion/mptbase.c
>         > index 5dcc031..d4907a1 100644
>         > --- a/drivers/message/fusion/mptbase.c
>         > +++ b/drivers/message/fusion/mptbase.c
>         > @@ -1996,6 +1996,13 @@ mpt_attach(struct pci_dev *pdev,
>         const struct pci_device_id *id)
>         >       snprintf(ioc->fw_event_q_name, MPT_KOBJ_NAME_LEN,
>         "mpt/%d", ioc->id);
>         >       ioc->fw_event_q =
>         create_singlethread_workqueue(ioc->fw_event_q_name);
>         >
>         > +     if (!ioc->fw_event_q) {
>         > +             destroy_workqueue(ioc->reset_work_q);
>         > +             pci_release_selected_regions(pdev, ioc->bars);
>         > +             kfree(ioc);
>         > +             return -ENOMEM;
>         > +     }
>         > +
>         >       if ((r = mpt_do_ioc_recovery(ioc,
>         MPT_HOSTEVENT_IOC_BRINGUP,
>         >           CAN_SLEEP)) != 0){
>         >               printk(MYIOC_s_ERR_FMT "didn't initialize
>         properly! (%d)\n",
>         
>         This does not look correct to me.  The error path for the call
>         to
>         mpt_do_ioc_recovery() after create_singlethread_workqueue()
>         for
>         ioc->fw_event_q does other cleanup, including:
>         
>                         list_del(&ioc->list);
>                         if (ioc->alt_ioc)
>                                 ioc->alt_ioc->alt_ioc = NULL;
>                         iounmap(ioc->memmap);
>         
>         and
>         
>                         kfree(ioc);
>                         pci_set_drvdata(pdev, NULL);
> 
> 
> Oh yes. Right. 
> I just copied from above error handling code.
> 
> 
>  
>         
>         Here I think you are kfree()ing ioc while it is still on the
>         &ioc_list,
>         which will cause a crash.
>         
>         Note to Avago:  this code could use a symbolic return code
>         identifier:
>         
>                         if (r != -5)
>                                 pci_release_selected_regions(pdev,
>         ioc->bars);
> 
> 
> What is -5? it seems strange for me.
> 
> Is it error code? then it is better to use macro.

The comments above mpt_do_ioc_recovery() say:

 *      Returns:                                                                                                                                                                                                   
 *               0 for success                                                                                                                                                                                     
 *              -1 if failed to get board READY                                                                                                                                                                    
 *              -2 if READY but IOCFacts Failed                                                                                                                                                                    
 *              -3 if READY but PrimeIOCFifos Failed                                                                                                                                                               
 *              -4 if READY but IOCInit Failed                                                                                                                                                                     
 *              -5 if failed to enable_device and/or request_selected_regions                                                                                                                                      
 *              -6 if failed to upload firmware

and yes, it would be better to use a macro (symbolic value) hence my
comment to Avago.                                                                                                                                                      
> 
> 
>         
>         In general, with sequential allocation of resources like this,
>         error
>         handling can be performed using a series of goto's to labels
>         at the
>         end of the function that release the resources in reverse
>         order.  This
>         avoids the duplication of code within the function, and
>         reduces the
>         chance for errors when the function is later modified.  See
>         init_sd
>         in drivers/scsi/sd.c for an example.
>         
>         Reviewed-by: Ewan D. Milne <emilne@redhat.com>
>         
>         
> 
> 
> Then in summary, after failing allocation, I need to call
> 
> 
> list_del(&ioc->list);
> if (ioc->alt_ioc)
>   ioc->alt_ioc->alt_ioc = NULL;
> iounmap(ioc->memmap);
> kfree(ioc);
> pci_set_drvdata(pdev, NULL);
> 
> 
> right?

I think you also need this:

                if (r != -5)
                        pci_release_selected_regions(pdev, ioc->bars);

                destroy_workqueue(ioc->reset_work_q);
                ioc->reset_work_q = NULL;

prior to your kfree(ioc) call.

Alternatively it looks like the code to create the ioc->fw_event_q could
be moved up to be right after the code to create the ioc->reset_work_q,
that might simplify the code a little bit as the ioc has not been added
to the &ioc_list and pci_set_drvdata() has not yet been called.

Note however that a failed call to mpt_do_ioc_recovery() still needs to
perform all the recovery actions, including destroying both work queues,
so consider putting the error handling code at the end of the function
as I mentioned above.  Otherwise, you should add:

                destroy_workqueue(ioc->fw_event_q);
                ioc->fw_event_q = NULL;

prior to the call to destroy_workqueue(ioc->reset_work_q) in that path.

-Ewan

> 
> 
> -- 
> Regards
> Insu Yun
