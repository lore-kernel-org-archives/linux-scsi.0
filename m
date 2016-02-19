From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2] fusion-mptbase: handle failed allocation for workqueue
Date: Fri, 19 Feb 2016 14:46:25 +0100
Message-ID: <56C71CB1.9040500@redhat.com>
References: <1455770459-905-1-git-send-email-wuninsu@gmail.com>
 <20160218090043.GQ18134@c203.arch.suse.de>
 <1455813615.22112.473.camel@localhost.localdomain>
 <1455814515.22112.476.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455814515.22112.476.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: emilne@redhat.com, Johannes Thumshirn <jthumshirn@suse.de>
Cc: Insu Yun <wuninsu@gmail.com>, nagalakshmi.nandigama@avagotech.com, praveen.krishnamoorthy@avagotech.com, sreekanth.reddy@avagotech.com, abhijit.mahajan@avagotech.com, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu
List-Id: linux-scsi@vger.kernel.org

On 18.2.2016 17:55, Ewan Milne wrote:
> On Thu, 2016-02-18 at 11:40 -0500, Ewan Milne wrote:
>> It also appears to me upon further inspection that the existing code has
>> other problems.  In particular, once mpt_mapresources() has returned
>> with a nonzero error code, it looks like iounmap() should be called, but
>> it is not in the case of a failed allocation of reset_work_q.  I'm also
>> not sure why pci_release_selected_regions() is only called for the case
>> of mpt_do_ioc_recovery() returning != -5 when it is called whenever
>> there is a failed allocation of reset_work_q.
>>
>> Consider the attached patch (untested, because I don't have hardware):
>> It shows what I would do for labels & error handling.  If the rc != -5
>> case of return from mpt_do_ioc_recovery() could be eliminated, then
>> another label "out_free_fw_event_q:" could be added prior to the other
>> error cases at the end, and all the code after the printk() in that path
>> could be replaced by "goto out_free_fw_event_q;"
>>
>> 	if ((r = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
>> 	    CAN_SLEEP)) != 0){
>> 		printk(MYIOC_s_ERR_FMT "didn't initialize properly! (%d)\n",
>> 		    ioc->name, r);
>> 		goto out_free_fw_event_q;
>> 	}
>> ...
>>
>> out_free_fw_event_q:
>> 	destroy_workqueue(ioc->fw_event_q);
>> 	ioc->fw_event_q = NULL;
>>
>> out_remove_ioc:
>> ...
>>
>> However I do not know if that change is legitimate.
>>
>> -Ewan
> There is an error in the patch attached in my previous mail.
> Please refer to the attached PATCH v2 RFC.

Looks fine to me, do you we could add this change to your patch ?


diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index a4f362b3b4..4a42c1534c 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -2012,6 +2012,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
                if (ioc->alt_ioc)
                        ioc->alt_ioc->alt_ioc = NULL;
                iounmap(ioc->memmap);
+               if (pci_is_enabled(pdev)
+                       pci_disable_device(pdev);
                if (r != -5)
                        pci_release_selected_regions(pdev, ioc->bars);

@@ -2019,7 +2021,6 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
                ioc->reset_work_q = NULL;

                kfree(ioc);
-               pci_set_drvdata(pdev, NULL);
                return r;
        }

@@ -2052,13 +2053,13 @@ out_remove_ioc:
        list_del(&ioc->list);
        if (ioc->alt_ioc)
                ioc->alt_ioc->alt_ioc = NULL;
-       pci_set_drvdata(ioc->pcidev, NULL);

        destroy_workqueue(ioc->reset_work_q);
        ioc->reset_work_q = NULL;

 out_unmap_resources:
        iounmap(ioc->memmap);
+       pci_disable_device(pdev);
        pci_release_selected_regions(pdev, ioc->bars);

 out_free_ioc:

-tomash

>
> -Ewan
>
