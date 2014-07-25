From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH 5/6] qla2xxx: Prevent removal and board_disable race
Date: Fri, 25 Jul 2014 15:45:00 -0400
Message-ID: <alpine.OSX.2.00.1407251542200.2212@administrators-macbook-pro.local>
References: <1403100139-1798-1-git-send-email-joe.lawrence@stratus.com> <1403100284-1872-1-git-send-email-joe.lawrence@stratus.com> <alpine.OSX.2.00.1407251118340.1035@administrators-macbook-pro.local> <20140725150017.61a0cdc1@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:22979 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761140AbaGYTpJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jul 2014 15:45:09 -0400
In-Reply-To: <20140725150017.61a0cdc1@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>, Bill Kuzeja <william.kuzeja@stratus.com>, Dave Bulkow <david.bulkow@stratus.com>


On Fri, 25 Jul 2014, Joe Lawrence wrote:

> On Fri, 25 Jul 2014 11:23:02 -0400
> Chad Dupuis <chad.dupuis@qlogic.com> wrote:
>
>>
>>
>> On Wed, 18 Jun 2014, Joe Lawrence wrote:
>>
>>> Introduce mutual exclusion between the qla2xxx_remove_one PCI driver
>>> callback and qla2x00_disable_board_on_pci_error, which is scheduled as
>>> board_disable work by qla2x00_check_reg{32,16}_for_disconnect:
>>>
>>> * Leave the driver-specific data attached to the underlying PCI device
>>> intact in qla2x00_disable_board_on_pci_error, so that qla2x00_remove_one
>>> has enough breadcrumbs to determine that any board_disable work has been
>>> completed.
>>>
>>> * In qla2xxx_remove_one, set a bit to prevent any subsequent
>>> board_disable work from scheduling, then cancel and wait until pending
>>> work has completed.
>>>
>>> * Reuse the PCI device enable count check in qla2x00_remove_one to
>>> determine if board_disable has occured.  The original purpose of this
>>> check was unnecessary since the driver remove function wasn't called
>>> when the probe fails.
>>>
>>> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
>>> ---
>>> drivers/scsi/qla2xxx/qla_def.h |    1 +
>>> drivers/scsi/qla2xxx/qla_isr.c |    3 ++-
>>> drivers/scsi/qla2xxx/qla_os.c  |   31 +++++++++++++++++++------------
>>> 3 files changed, 22 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
>>> index 1267b11..7c441c9 100644
>>> --- a/drivers/scsi/qla2xxx/qla_def.h
>>> +++ b/drivers/scsi/qla2xxx/qla_def.h
>>> @@ -3404,6 +3404,7 @@ typedef struct scsi_qla_host {
>>>
>>> 	unsigned long	pci_flags;
>>> #define PFLG_DISCONNECTED	0	/* PCI device removed */
>>> +#define PFLG_DRIVER_REMOVING	1	/* PCI driver .remove */
>>>
>>> 	uint32_t	device_flags;
>>> #define SWITCH_FOUND		BIT_0
>>> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
>>> index 2741ad8..ee5eef4 100644
>>> --- a/drivers/scsi/qla2xxx/qla_isr.c
>>> +++ b/drivers/scsi/qla2xxx/qla_isr.c
>>> @@ -117,7 +117,8 @@ qla2x00_check_reg32_for_disconnect(scsi_qla_host_t *vha, uint32_t reg)
>>> {
>>> 	/* Check for PCI disconnection */
>>> 	if (reg == 0xffffffff) {
>>> -		if (!test_and_set_bit(PFLG_DISCONNECTED, &vha->pci_flags)) {
>>> +		if (!test_and_set_bit(PFLG_DISCONNECTED, &vha->pci_flags) &&
>>> +		    !test_bit(PFLG_DRIVER_REMOVING, &vha->pci_flags)) {
>>
>> In our remove function we set a bit that we are unloading:
>>
>> set_bit (UNLOADING, &base_vha->dpc_flags);
>>
>> could this be used instead?
>
> Hi Chad,
>
> Thanks for the comments.
>
> I think with a little bit of code shuffling this could be accomplished.
> My goal with the patchset was to try and present the problem/fix as
> plain as possible.  It was easiest to collect all the atomic bits I
> needed inside a single variable.  Should I be tacking on such flags to
> 'dpc_flags' ?

Now that I see your explanation, it makes sense how you did it.  My 
concern had been that we introduce more flags which could theoretcially 
introduce more points for race conditions but dpc_flags in pretty 
overloaded as it is.

>
>>
>>> 			/*
>>> 			 * Schedule this (only once) on the default system
>>> 			 * workqueue so that all the adapter workqueues and the
>>> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
>>> index 39c9953..51cba37 100644
>>> --- a/drivers/scsi/qla2xxx/qla_os.c
>>> +++ b/drivers/scsi/qla2xxx/qla_os.c
>>> @@ -3123,15 +3123,25 @@ qla2x00_remove_one(struct pci_dev *pdev)
>>> 	scsi_qla_host_t *base_vha;
>>> 	struct qla_hw_data  *ha;
>>>
>>> +	base_vha = pci_get_drvdata(pdev);
>>> +	ha = base_vha->hw;
>>> +
>>> +	/* Indicate device removal to prevent future board_disable and wait
>>> +	 * until any pending board_disable has completed. */
>>> +	set_bit(PFLG_DRIVER_REMOVING, &base_vha->pci_flags);
>>> +	cancel_work_sync(&ha->board_disable);
>>> +
>>> 	/*
>>> -	 * If the PCI device is disabled that means that probe failed and any
>>> -	 * resources should be have cleaned up on probe exit.
>>> +	 * If the PCI device is disabled then there was a PCI-disconnect and
>>> +	 * qla2x00_disable_board_on_pci_error has taken care of most of the
>>> +	 * resources.
>>> 	 */
>>> -	if (!atomic_read(&pdev->enable_cnt))
>>> +	if (!atomic_read(&pdev->enable_cnt)) {
>>
>> Should we also add a check here that this is a disconnection before
>> freeing these structs?  The original intent of the check for
>> pdev->enable_cnt is to make sure we don't try to dereference an already
>> freed struct if probe failed.
>
> I'm not exactly sure what you're asking here.  In my tests, when .probe
> return -ERRNO, .remove was not called.  Is there another call path into
> qla2x00_remove_one?
>
> The reason I didn't completely cleanup qla_hw_data in
> qla2x00_disable_board_on_pci_error and re-purposed the PCI enable count
> check, was that I needed some way of determining that any
> board_disable work was out of the way before proceeding with
> qla2x00_remove_one.
>
> The patch's set_bit / cancel_work_sync above (along with the test_bit
> before board_disable schedule) should be ensuring that the
> board_disable won't be running or rescheduling in the future.
>
> If qla2x00_disable_board_on_pci_error got as far as actually disabling
> the PCI device, then qla2x00_remove_one's check on its enable count
> would be verifying that.  If the device is still enabled, then
> qla2x00_remove_one knows that board_disable didn't clean up the device.
>
> Would it be clearer if I used an explicit scsi_qla_host flag to
> indicate that state?

Thanks for the explanation.

>
>>
>>> +		scsi_host_put(base_vha->host);
>>> +		kfree(ha);
>>> +		pci_set_drvdata(pdev, NULL);
>>> 		return;
>>> -
>>> -	base_vha = pci_get_drvdata(pdev);
>>> -	ha = base_vha->hw;
>>> +	}
>>>
>>> 	qla2x00_wait_for_hba_ready(base_vha);
>>>
>>> @@ -4791,18 +4801,15 @@ qla2x00_disable_board_on_pci_error(struct work_struct *work)
>>> 	qla82xx_md_free(base_vha);
>>> 	qla2x00_free_queues(ha);
>>>
>>> -	scsi_host_put(base_vha->host);
>>> -
>>> 	qla2x00_unmap_iobases(ha);
>>>
>>> 	pci_release_selected_regions(ha->pdev, ha->bars);
>>> -	kfree(ha);
>>> -	ha = NULL;
>>> -
>>> 	pci_disable_pcie_error_reporting(pdev);
>>> 	pci_disable_device(pdev);
>>> -	pci_set_drvdata(pdev, NULL);
>>>
>>> +	/*
>>> +	 * Let qla2x00_remove_one cleanup qla_hw_data on device removal.
>>> +	 */
>>> }
>>>
>>> /**************************************************************************
>>>
>
> Regards,
>
> -- Joe
>
