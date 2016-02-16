From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] fusion-mptbase: handle failed allocation for workqueue
Date: Tue, 16 Feb 2016 13:18:29 -0500
Message-ID: <1455646709.22112.412.camel@localhost.localdomain>
References: <1455591041-8667-1-git-send-email-wuninsu@gmail.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455591041-8667-1-git-send-email-wuninsu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Insu Yun <wuninsu@gmail.com>
Cc: nagalakshmi.nandigama@avagotech.com, praveen.krishnamoorthy@avagotech.com, sreekanth.reddy@avagotech.com, abhijit.mahajan@avagotech.com, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu
List-Id: linux-scsi@vger.kernel.org

On Mon, 2016-02-15 at 21:50 -0500, Insu Yun wrote:
> the failure of ioc->reset_work_q is checked,
> but not ioc->fw_event_q.
> 
> Signed-off-by: Insu Yun <wuninsu@gmail.com>
> ---
>  drivers/message/fusion/mptbase.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index 5dcc031..d4907a1 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -1996,6 +1996,13 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
>  	snprintf(ioc->fw_event_q_name, MPT_KOBJ_NAME_LEN, "mpt/%d", ioc->id);
>  	ioc->fw_event_q = create_singlethread_workqueue(ioc->fw_event_q_name);
>  
> +	if (!ioc->fw_event_q) {
> +		destroy_workqueue(ioc->reset_work_q);
> +		pci_release_selected_regions(pdev, ioc->bars);
> +		kfree(ioc);
> +		return -ENOMEM;
> +	}
> +
>  	if ((r = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
>  	    CAN_SLEEP)) != 0){
>  		printk(MYIOC_s_ERR_FMT "didn't initialize properly! (%d)\n",

This does not look correct to me.  The error path for the call to
mpt_do_ioc_recovery() after create_singlethread_workqueue() for
ioc->fw_event_q does other cleanup, including:

                list_del(&ioc->list);
                if (ioc->alt_ioc)
                        ioc->alt_ioc->alt_ioc = NULL;
                iounmap(ioc->memmap);

and

                kfree(ioc);
                pci_set_drvdata(pdev, NULL);

Here I think you are kfree()ing ioc while it is still on the &ioc_list,
which will cause a crash.

Note to Avago:  this code could use a symbolic return code identifier:

                if (r != -5)
                        pci_release_selected_regions(pdev, ioc->bars);

In general, with sequential allocation of resources like this, error
handling can be performed using a series of goto's to labels at the
end of the function that release the resources in reverse order.  This
avoids the duplication of code within the function, and reduces the
chance for errors when the function is later modified.  See init_sd
in drivers/scsi/sd.c for an example.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
