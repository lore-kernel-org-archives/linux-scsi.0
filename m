Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECCDC433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 15:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 550AF64E24
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 15:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhBVPfI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 10:35:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46059 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231774AbhBVPeV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 10:34:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614007971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x8XW2mCRRf+89WZK3Ih4GzFw4CEnzufsy9Vvz6UC9Ck=;
        b=AINKZmAv/9JgaFG2wwy1VLgYeSxhRmF7Ry16pL7HgLG17swLjoBFkuyZaqYykeJn2094Ss
        /qFKro8WMTKg8jxwsRzZLj6Ba6cdZz5uhTC76U+IQuPBaTq0XDMRXsIxeGdjJGtYHpwmHj
        7Ab8oa3G4kvQDKMVzO5UldCfmLYsh8o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-bLxl9io8Oail2GwckpTu_g-1; Mon, 22 Feb 2021 10:32:48 -0500
X-MC-Unique: bLxl9io8Oail2GwckpTu_g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D7D7AFA80;
        Mon, 22 Feb 2021 15:32:47 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCC9D60C04;
        Mon, 22 Feb 2021 15:32:45 +0000 (UTC)
Subject: Re: [PATCH 21/24] mpi3mr: add support of PM suspend and resume
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-22-kashyap.desai@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <a6ff2b4b-90e8-9659-ab99-a20571511d24@redhat.com>
Date:   Mon, 22 Feb 2021 16:32:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20201222101156.98308-22-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/20 11:11 AM, Kashyap Desai wrote:
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: sathya.prakash@broadcom.com
> ---
>  drivers/scsi/mpi3mr/mpi3mr_os.c | 85 +++++++++++++++++++++++++++++++++
>  1 file changed, 85 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 1708aca1a5cd..ac47eed74705 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
...
> +/**
> + * mpi3mr_resume - PCI power management resume callback
> + * @pdev: PCI device instance
> + *
> + * Restore the power state to D0 and reinitialize the controller
> + * and resume I/O operations to the target devices
> + *
> + * Return: 0 on success, non-zero on failure
> + */
> +static int mpi3mr_resume(struct pci_dev *pdev)
> +{
> +	struct Scsi_Host *shost = pci_get_drvdata(pdev);
> +	struct mpi3mr_ioc *mrioc;
> +	pci_power_t device_state = pdev->current_state;
> +	int r;
> +
> +	mrioc = shost_priv(shost);
> +
> +	ioc_info(mrioc, "pdev=0x%p, slot=%s, previous operating state [D%d]\n",
> +	    pdev, pci_name(pdev), device_state);
> +	pci_set_power_state(pdev, PCI_D0);
> +	pci_enable_wake(pdev, PCI_D0, 0);
> +	pci_restore_state(pdev);
> +	mrioc->pdev = pdev;
> +	mrioc->cpu_count = num_online_cpus();
> +	r = mpi3mr_setup_resources(mrioc);
> +	if (r) {
> +		ioc_info(mrioc, "%s: Setup resoruces failed[%d]\n",

A typo 					here ^
> +		    __func__, r);
> +		return r;
> +	}

