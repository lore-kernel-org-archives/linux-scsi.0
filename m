Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161C21E51FF
	for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2025 08:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741768344; cv=none; b=AdXPoV5ZCwDIIpyiQ3lZSZEWOeJ4NxSuYC/3I/Sct5oA0fW/aNPnb5TJMzOujRuZyQNTauc4G9ELRaPIZ7+q7+vyRldxirN9iDFLD/9wp3FzthYnkudkxVIGHv8f9IkeFZE2R350IvPcIEK58JlSTmlA3qi2GZR+YCu0NbsC5pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741768344; c=relaxed/simple;
	bh=mBOvNN8vkxHE5gT4uejFzHPyGp0eWzXZh4TqaUL3o1g=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bAJoH/QKfoObmytMGNcxni7E6gKYK+fr2EUDkFnn7yQOMBvw/VUl9/1gPg2RggHLz67yzG/IeQ6Xm282ylQ5ZVYXwrDbNgl37STANfjWZ5x7nS8C4f/VqyropZaIs7LvdekjxRzBDHX86AaMSbQ94G20H4CEDBH+ONaP49J1ULc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WmLmcrtN; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WmLmcrtN"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-390e3b3d3f4so3144949f8f.2
        for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2025 01:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741768340; x=1742373140; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UpGDby7znR5SvIhJ6mrGwI6hVfAue1KCc6ZdSGDORsY=;
        b=WmLmcrtNy/5r8bejDQkX9eyeuBYXhL725+dRnKMff9IHVog591LWS87qP9FwLi+XVq
         aE/oZQRGTmoAeRGPYmplOXTDx/FUPo+4FRwBFhHySDRIi7CVbTHr4bLdlC3mUcJ2lTmS
         0NJgmXQCMOAXFzifLIV+5AAzFjrFq1m1RB2gAmwOkoaQi9EMJzgnCqqmGeaA4ChyPQRD
         EepMn42u40B9FLRf2B64UqqhUe98xrhcc7ITWaU9AGo6DjCQqRD/ip8j5qbRcMPiqAER
         Svl7xTFtGgzHyNBWN3W2aFNLiIkt+fp0nyjcBPTLEA8cBhGNz/49EPgA7Gc2hw62qzPB
         jewQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741768340; x=1742373140;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UpGDby7znR5SvIhJ6mrGwI6hVfAue1KCc6ZdSGDORsY=;
        b=oKjyjeQh8sBqQpGtRdID5yePQSrCHUvWJuMvS2ilK9LVQwPhApdT0HABn7Lvouznsb
         +CamTw40ddTK134XOH20ExDdYuWB+EjjC2z1de/rdfponeT2UhYOhNsciF6jJ9eYVNic
         PnbYmr1mon9uu4IVr743+G/8o3qUq3bxgnuKXqz0QS4e4cG7iikT6R3k5NxxY2nfEzxB
         si1+L/qN05uviBnNKUJyysPYC932Yh5aWUGBjhrJ8bTkyWqJQx2LDDv5AzuSpEZ0NFS9
         BW9RBZZxruy5ocQftBNoUDY1701t9lLeX+SyY2Tv+hwB4Vcq5E83N5dT5uVy+JLR1N2w
         TlbA==
X-Forwarded-Encrypted: i=1; AJvYcCXjEmKXW9Y0aAMCoCtVMaj4xLLLDu4PYExiYZjInysDAK/+tyZ0wkPYO+N8KYzE5fX3HbVloDSnj8Hw@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf1siFcoUQ9+HrC1yKZoD+XDqwgLQpoHYQXg3b/kkqC/EUEKLS
	teztqrS9hYdDxz1W+FXTCX3v41QmQZNkS8GE/+HL2r+EPo1dTY/ebYouhgM/mQY=
X-Gm-Gg: ASbGncvAD7xZrpbdBffboyrueAdTTRN831h6oKDa2gz3GqlRKHUYIEqQug5vwwkEHcL
	AmWKwcBIHtlX4ZsCbtX4Oy0YqX31cbqMAAnZM8hmUnpJLgwZOkYJ6LDLnYXDiyDzhdJZyXEIegS
	DhBEVccfH9RCiW7KB7Y+hVVW8L0J4vL2AlWPKOUA0H2CAo7d0o/avt60Ze4CZeahhbK01fepHJ4
	B5b4vlIsNWO/tX3s3HGX5LcsA/Gu+qxs1pRdnOD8Rs91yzc+VVZtjIAbHBnZvfzDvW1574ZELD+
	sqr5q09/7D4tKmSjwcGHlI6s2azAVwjSOia1mEpchI10HAMeti9yLvIjyLbN
X-Google-Smtp-Source: AGHT+IEI0drddyJXD49kXMlW63MY90jiOPv6W++/q3Y4ORWlQJvu794PHRx2EGkFNk9vmyi3+1H1SQ==
X-Received: by 2002:a05:6000:1f82:b0:391:3fde:1da with SMTP id ffacd0b85a97d-3913fde033cmr15793708f8f.16.1741768340229;
        Wed, 12 Mar 2025 01:32:20 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3912bfb7aefsm20097486f8f.20.2025.03.12.01.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 01:32:19 -0700 (PDT)
Date: Wed, 12 Mar 2025 11:32:16 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [bug report] scsi: mpi3mr: Task Abort EH Support
Message-ID: <85a9f887-096a-4189-9290-6c79784d94ae@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Chandrakanth Patil,

Commit bde2ff79ee14 ("scsi: mpi3mr: Task Abort EH Support") from Mar
5, 2025 (linux-next), leads to the following Smatch static checker
warning:

	drivers/scsi/mpi3mr/mpi3mr_os.c:3845 mpi3mr_issue_tm()
	warn: missing error code here? 'scsi_cmd_priv()' failed. 'retval' = '0'

drivers/scsi/mpi3mr/mpi3mr_os.c
    3784 int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
    3785         u16 handle, uint lun, u16 htag, ulong timeout,
    3786         struct mpi3mr_drv_cmd *drv_cmd,
    3787         u8 *resp_code, struct scsi_cmnd *scmd)
    3788 {
    3789         struct mpi3_scsi_task_mgmt_request tm_req;
    3790         struct mpi3_scsi_task_mgmt_reply *tm_reply = NULL;
    3791         int retval = 0;
    3792         struct mpi3mr_tgt_dev *tgtdev = NULL;
    3793         struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data = NULL;
    3794         struct scmd_priv *cmd_priv = NULL;
    3795         struct scsi_device *sdev = NULL;
    3796         struct mpi3mr_sdev_priv_data *sdev_priv_data = NULL;
    3797 
    3798         ioc_info(mrioc, "%s :Issue TM: TM type (0x%x) for devhandle 0x%04x\n",
    3799              __func__, tm_type, handle);
    3800         if (mrioc->unrecoverable) {
    3801                 retval = -1;
    3802                 ioc_err(mrioc, "%s :Issue TM: Unrecoverable controller\n",
    3803                     __func__);
    3804                 goto out;
    3805         }
    3806 
    3807         memset(&tm_req, 0, sizeof(tm_req));
    3808         mutex_lock(&drv_cmd->mutex);
    3809         if (drv_cmd->state & MPI3MR_CMD_PENDING) {
    3810                 retval = -1;
    3811                 ioc_err(mrioc, "%s :Issue TM: Command is in use\n", __func__);
    3812                 mutex_unlock(&drv_cmd->mutex);
    3813                 goto out;
    3814         }
    3815         if (mrioc->reset_in_progress) {
    3816                 retval = -1;
    3817                 ioc_err(mrioc, "%s :Issue TM: Reset in progress\n", __func__);
    3818                 mutex_unlock(&drv_cmd->mutex);
    3819                 goto out;
    3820         }
    3821         if (mrioc->block_on_pci_err) {
    3822                 retval = -1;
    3823                 dprint_tm(mrioc, "sending task management failed due to\n"
    3824                                 "pci error recovery in progress\n");
    3825                 mutex_unlock(&drv_cmd->mutex);
    3826                 goto out;
    3827         }
    3828 
    3829         drv_cmd->state = MPI3MR_CMD_PENDING;
    3830         drv_cmd->is_waiting = 1;
    3831         drv_cmd->callback = NULL;
    3832         tm_req.dev_handle = cpu_to_le16(handle);
    3833         tm_req.task_type = tm_type;
    3834         tm_req.host_tag = cpu_to_le16(htag);
    3835 
    3836         int_to_scsilun(lun, (struct scsi_lun *)tm_req.lun);
    3837         tm_req.function = MPI3_FUNCTION_SCSI_TASK_MGMT;
    3838 
    3839         tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, handle);
    3840 
    3841         if (scmd) {
    3842                 if (tm_type == MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
    3843                         cmd_priv = scsi_cmd_priv(scmd);
    3844                         if (!cmd_priv)
--> 3845                                 goto out_unlock;

scsi_cmd_priv() is pointer math and it can't return NULL.  Should we
just delete this impossible NULL check?  Otherwise it should return an
error code.

    3846 
    3847                         struct op_req_qinfo *op_req_q;
    3848 
    3849                         op_req_q = &mrioc->req_qinfo[cmd_priv->req_q_idx];
    3850                         tm_req.task_host_tag = cpu_to_le16(cmd_priv->host_tag);
    3851                         tm_req.task_request_queue_id =
    3852                                 cpu_to_le16(op_req_q->qid);
    3853                 }
    3854                 sdev = scmd->device;
    3855                 sdev_priv_data = sdev->hostdata;
    3856                 scsi_tgt_priv_data = ((sdev_priv_data) ?
    3857                     sdev_priv_data->tgt_priv_data : NULL);
    3858         } else {
    3859                 if (tgtdev && tgtdev->starget && tgtdev->starget->hostdata)
    3860                         scsi_tgt_priv_data = (struct mpi3mr_stgt_priv_data *)
    3861                             tgtdev->starget->hostdata;
    3862         }
    3863 
    3864         if (scsi_tgt_priv_data)
    3865                 atomic_inc(&scsi_tgt_priv_data->block_io);
    3866 
    3867         if (tgtdev && (tgtdev->dev_type == MPI3_DEVICE_DEVFORM_PCIE)) {
    3868                 if (cmd_priv && tgtdev->dev_spec.pcie_inf.abort_to)
    3869                         timeout = tgtdev->dev_spec.pcie_inf.abort_to;
    3870                 else if (!cmd_priv && tgtdev->dev_spec.pcie_inf.reset_to)
    3871                         timeout = tgtdev->dev_spec.pcie_inf.reset_to;
    3872         }
    3873 
    3874         init_completion(&drv_cmd->done);
    3875         retval = mpi3mr_admin_request_post(mrioc, &tm_req, sizeof(tm_req), 1);
    3876         if (retval) {
    3877                 ioc_err(mrioc, "%s :Issue TM: Admin Post failed\n", __func__);
    3878                 goto out_unlock;
    3879         }
    3880         wait_for_completion_timeout(&drv_cmd->done, (timeout * HZ));
    3881 
    3882         if (!(drv_cmd->state & MPI3MR_CMD_COMPLETE)) {
    3883                 drv_cmd->is_waiting = 0;
    3884                 retval = -1;
    3885                 if (!(drv_cmd->state & MPI3MR_CMD_RESET)) {
    3886                         dprint_tm(mrioc,
    3887                             "task management request timed out after %ld seconds\n",
    3888                             timeout);
    3889                         if (mrioc->logging_level & MPI3_DEBUG_TM)
    3890                                 dprint_dump_req(&tm_req, sizeof(tm_req)/4);
    3891                         mpi3mr_soft_reset_handler(mrioc,
    3892                             MPI3MR_RESET_FROM_TM_TIMEOUT, 1);
    3893                 }
    3894                 goto out_unlock;
    3895         }
    3896 
    3897         if (!(drv_cmd->state & MPI3MR_CMD_REPLY_VALID)) {
    3898                 dprint_tm(mrioc, "invalid task management reply message\n");
    3899                 retval = -1;
    3900                 goto out_unlock;
    3901         }
    3902 
    3903         tm_reply = (struct mpi3_scsi_task_mgmt_reply *)drv_cmd->reply;
    3904 
    3905         switch (drv_cmd->ioc_status) {
    3906         case MPI3_IOCSTATUS_SUCCESS:
    3907                 *resp_code = le32_to_cpu(tm_reply->response_data) &
    3908                         MPI3MR_RI_MASK_RESPCODE;
    3909                 break;
    3910         case MPI3_IOCSTATUS_SCSI_IOC_TERMINATED:
    3911                 *resp_code = MPI3_SCSITASKMGMT_RSPCODE_TM_COMPLETE;
    3912                 break;
    3913         default:
    3914                 dprint_tm(mrioc,
    3915                     "task management request to handle(0x%04x) is failed with ioc_status(0x%04x) log_info(0x%08x)\n",
    3916                     handle, drv_cmd->ioc_status, drv_cmd->ioc_loginfo);
    3917                 retval = -1;
    3918                 goto out_unlock;
    3919         }
    3920 
    3921         switch (*resp_code) {
    3922         case MPI3_SCSITASKMGMT_RSPCODE_TM_SUCCEEDED:
    3923         case MPI3_SCSITASKMGMT_RSPCODE_TM_COMPLETE:
    3924                 break;
    3925         case MPI3_SCSITASKMGMT_RSPCODE_IO_QUEUED_ON_IOC:
    3926                 if (tm_type != MPI3_SCSITASKMGMT_TASKTYPE_QUERY_TASK)
    3927                         retval = -1;
    3928                 break;
    3929         default:
    3930                 retval = -1;
    3931                 break;
    3932         }
    3933 
    3934         dprint_tm(mrioc,
    3935             "task management request type(%d) completed for handle(0x%04x) with ioc_status(0x%04x), log_info(0x%08x), termination_count(%d), response:%s(0x%x)\n",
    3936             tm_type, handle, drv_cmd->ioc_status, drv_cmd->ioc_loginfo,
    3937             le32_to_cpu(tm_reply->termination_count),
    3938             mpi3mr_tm_response_name(*resp_code), *resp_code);
    3939 
    3940         if (!retval) {
    3941                 mpi3mr_ioc_disable_intr(mrioc);
    3942                 mpi3mr_poll_pend_io_completions(mrioc);
    3943                 mpi3mr_ioc_enable_intr(mrioc);
    3944                 mpi3mr_poll_pend_io_completions(mrioc);
    3945                 mpi3mr_process_admin_reply_q(mrioc);
    3946         }
    3947         switch (tm_type) {
    3948         case MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET:
    3949                 if (!scsi_tgt_priv_data)
    3950                         break;
    3951                 scsi_tgt_priv_data->pend_count = 0;
    3952                 blk_mq_tagset_busy_iter(&mrioc->shost->tag_set,
    3953                     mpi3mr_count_tgt_pending,
    3954                     (void *)scsi_tgt_priv_data->starget);
    3955                 break;
    3956         case MPI3_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET:
    3957                 if (!sdev_priv_data)
    3958                         break;
    3959                 sdev_priv_data->pend_count = 0;
    3960                 blk_mq_tagset_busy_iter(&mrioc->shost->tag_set,
    3961                     mpi3mr_count_dev_pending, (void *)sdev);
    3962                 break;
    3963         default:
    3964                 break;
    3965         }
    3966         mpi3mr_global_trigger(mrioc,
    3967             MPI3_DRIVER2_GLOBALTRIGGER_TASK_MANAGEMENT_ENABLED);
    3968 
    3969 out_unlock:
    3970         drv_cmd->state = MPI3MR_CMD_NOTUSED;
    3971         mutex_unlock(&drv_cmd->mutex);
    3972         if (scsi_tgt_priv_data)
    3973                 atomic_dec_if_positive(&scsi_tgt_priv_data->block_io);
    3974         if (tgtdev)
    3975                 mpi3mr_tgtdev_put(tgtdev);
    3976 out:
    3977         return retval;
    3978 }

regards,
dan carpenter
