From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 12/15] megaraid_sas: MFI adapter's OCR changes
Date: Thu, 28 Jan 2016 16:42:49 +0530
Message-ID: <2d1edcb95703bd130dffd7a05df2d4a8@mail.gmail.com>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
 <1450445228-26571-13-git-send-email-Sumit.Saxena@avagotech.com> <569E46C1.7060104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:36688 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964950AbcA1LMw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 06:12:52 -0500
Received: by mail-lf0-f51.google.com with SMTP id h129so24927934lfh.3
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2016 03:12:51 -0800 (PST)
In-Reply-To: <569E46C1.7060104@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@avagotech.com>

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Tuesday, January 19, 2016 7:53 PM
> To: Sumit Saxena; jbottomley@parallels.com; hch@infradead.org;
> martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org; kashyap.desai@avagotech.com
> Subject: Re: [PATCH 12/15] megaraid_sas: MFI adapter's OCR changes
>
> On 18.12.2015 14:27, Sumit Saxena wrote:
> > Optimized MFI adapters' OCR path, particularly
> megasas_wait_for_outstanding() function.
> >
> > Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> > Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas_base.c |  104
> > +++++++++++++++--------------
> >  1 files changed, 54 insertions(+), 50 deletions(-)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> > b/drivers/scsi/megaraid/megaraid_sas_base.c
> > index 5eaf6fd..cc843d6 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> > @@ -2456,15 +2456,19 @@ void megasas_sriov_heartbeat_handler(unsigned
> long instance_addr)
> >   */
> >  static int megasas_wait_for_outstanding(struct megasas_instance
> > *instance)  {
> > -	int i;
> > +	int i, sl, outstanding;
> >  	u32 reset_index;
> >  	u32 wait_time = MEGASAS_RESET_WAIT_TIME;
> >  	unsigned long flags;
> >  	struct list_head clist_local;
> >  	struct megasas_cmd *reset_cmd;
> >  	u32 fw_state;
> > -	u8 kill_adapter_flag;
> >
> > +	if (atomic_read(&instance->adprecovery) ==
> MEGASAS_HW_CRITICAL_ERROR) {
> > +		dev_info(&instance->pdev->dev, "%s:%d HBA is killed.\n",
> > +		__func__, __LINE__);
> > +		return FAILED;
> > +	}
> >
> >  	if (atomic_read(&instance->adprecovery) !=
> MEGASAS_HBA_OPERATIONAL)
> > {
> >
> > @@ -2521,7 +2525,7 @@ static int megasas_wait_for_outstanding(struct
> megasas_instance *instance)
> >  	}
> >
> >  	for (i = 0; i < resetwaittime; i++) {
> > -		int outstanding = atomic_read(&instance->fw_outstanding);
> > +		outstanding = atomic_read(&instance->fw_outstanding);
> >
> >  		if (!outstanding)
> >  			break;
> > @@ -2540,65 +2544,65 @@ static int megasas_wait_for_outstanding(struct
> megasas_instance *instance)
> >  	}
> >
> >  	i = 0;
> > -	kill_adapter_flag = 0;
> > +	outstanding = atomic_read(&instance->fw_outstanding);
> > +	fw_state =
> > +instance->instancet->read_fw_status_reg(instance->reg_set) &
> > +MFI_STATE_MASK;
> > +
> > +	if ((!outstanding && (fw_state == MFI_STATE_OPERATIONAL)))
> > +		goto no_outstanding;
> > +
> > +	if (instance->disableOnlineCtrlReset)
> > +		goto kill_hba_and_failed;
> >  	do {
> > -		fw_state = instance->instancet->read_fw_status_reg(
> > -					instance->reg_set) &
> MFI_STATE_MASK;
> > -		if ((fw_state == MFI_STATE_FAULT) &&
> > -			(instance->disableOnlineCtrlReset == 0)) {
> > -			if (i == 3) {
> > -				kill_adapter_flag = 2;
> > -				break;
> > -			}
> > +		if ((fw_state == MFI_STATE_FAULT) ||
atomic_read(&instance-
> >fw_outstanding)) {
> > +			dev_info(&instance->pdev->dev,
> > +				"%s:%d waiting_for_outstanding: before
issue
> OCR. FW state = 0x%x, oustanding 0x%x\n",
> > +				__func__, __LINE__, fw_state,
> atomic_read(&instance->fw_outstanding));
> > +			if (i == 3)
> > +				goto kill_hba_and_failed;
> >  			megasas_do_ocr(instance);
> > -			kill_adapter_flag = 1;
> >
> > -			/* wait for 1 secs to let FW finish the pending
cmds */
> > -			msleep(1000);
> > +			if (atomic_read(&instance->adprecovery) ==
> MEGASAS_HW_CRITICAL_ERROR) {
> > +				dev_info(&instance->pdev->dev, "%s:%d OCR
> failed and HBA is killed.\n",
> > +				__func__, __LINE__);
> > +				return FAILED;
> > +			}
> > +			dev_info(&instance->pdev->dev, "%s:%d
> waiting_for_outstanding: after issue OCR.\n",
> > +				__func__, __LINE__);
> > +
> > +			for (sl = 0; sl < 10; sl++)
> > +				msleep(500);
>
> 		ssleep(5); ?
>
> > +
> > +			outstanding = atomic_read(&instance-
> >fw_outstanding);
> > +
> > +			fw_state = instance->instancet-
> >read_fw_status_reg(instance->reg_set) & MFI_STATE_MASK;
> > +			if ((!outstanding && (fw_state ==
> MFI_STATE_OPERATIONAL)))
> > +				goto no_outstanding;
> >  		}
> >  		i++;
> >  	} while (i <= 3);
> >
> > -	if (atomic_read(&instance->fw_outstanding) && !kill_adapter_flag)
{
> > -		if (instance->disableOnlineCtrlReset == 0) {
> > -			megasas_do_ocr(instance);
> > +no_outstanding:
> >
> > -			/* wait for 5 secs to let FW finish the pending
cmds */
> > -			for (i = 0; i < wait_time; i++) {
> > -				int outstanding =
> > -					atomic_read(&instance-
> >fw_outstanding);
> > -				if (!outstanding)
> > -					return SUCCESS;
> > -				msleep(1000);
> > -			}
> > -		}
> > -	}
> > +	dev_info(&instance->pdev->dev, "%s:%d no more pending commands
> remain after reset handling.\n",
> > +		__func__, __LINE__);
> > +	return SUCCESS;
> >
> > -	if (atomic_read(&instance->fw_outstanding) ||
> > -					(kill_adapter_flag == 2)) {
> > -		dev_notice(&instance->pdev->dev, "pending cmds after
> reset\n");
> > -		/*
> > -		 * Send signal to FW to stop processing any pending cmds.
> > -		 * The controller will be taken offline by the OS now.
> > -		 */
> > -		if ((instance->pdev->device ==
> > -			PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
> > -			(instance->pdev->device ==
> > -			PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
> > -			writel(MFI_STOP_ADP,
> > -				&instance->reg_set->doorbell);
> > -		} else {
> > -			writel(MFI_STOP_ADP,
> > -				&instance->reg_set->inbound_doorbell);
> > -		}
> > +kill_hba_and_failed:
> > +
> > +	fw_state =
instance->instancet->read_fw_status_reg(instance->reg_set)
> & MFI_STATE_MASK;
> > +	if (instance->disableOnlineCtrlReset ||
> > +		atomic_read(&instance->fw_outstanding) ||
> > +		(fw_state == MFI_STATE_FAULT)) {
>
> You have tested all that many times before (fw_state etc.), so when you
after all
> that have arrived at kill_hba_and_failed: please just kill the HBA and
return
> FAILED.

Agree..will be accommodating this while resending patch.
>
> > +		/* Reset not supported, kill adapter */
> > +		dev_info(&instance->pdev->dev, "%s:%d killing adapter
scsi%d"
> > +			" disableOnlineCtrlReset %d fw_outstanding %d \n",
> > +			__func__, __LINE__, instance->host->host_no,
> instance->disableOnlineCtrlReset,
> > +			atomic_read(&instance->fw_outstanding));
> >  		megasas_dump_pending_frames(instance);
> > -		atomic_set(&instance->adprecovery,
> MEGASAS_HW_CRITICAL_ERROR);
> > -		return FAILED;
> > +		megaraid_sas_kill_hba(instance);
> >  	}
> >
> > -	dev_notice(&instance->pdev->dev, "no pending cmds after reset\n");
> > -
> > -	return SUCCESS;
> > +	return FAILED;
> >  }
> >
> >  /**
