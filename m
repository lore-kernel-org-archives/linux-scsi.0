Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8478CC4708F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 13:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 670DE613B4
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 13:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbhFANem (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 09:34:42 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:54382 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbhFANeS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 09:34:18 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9F0D31FD2D;
        Tue,  1 Jun 2021 13:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622554356; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8EgX4/gt6sf5LNtGNiTJv0P7r5aa3weWoiMybJOBVqI=;
        b=Qiw0uDRnl2GvbWidgHYmXvXvVwwLcqtF40kn5PWmmwBw+Cy6pKQ+a2I1mApehFLYVMErfy
        Ugm8sZAwIHv5ONF9Hdx42U4q9ivuXvhjGrwDPAb/+/jPspoUlZkebTcgOLXeVnbpN0Fi4O
        mfYO9hy1A57czgxNN3omK2FCGnQCtAE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622554356;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8EgX4/gt6sf5LNtGNiTJv0P7r5aa3weWoiMybJOBVqI=;
        b=7uVgbeUYa2u74wUocV48rULZ7voYzXHR7ru2p8KWaQKCu5Be/D6B70NHpR19mVpRegqzz4
        MriCrqSZ4n4b+PBw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 7725A118DD;
        Tue,  1 Jun 2021 13:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622554356; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8EgX4/gt6sf5LNtGNiTJv0P7r5aa3weWoiMybJOBVqI=;
        b=Qiw0uDRnl2GvbWidgHYmXvXvVwwLcqtF40kn5PWmmwBw+Cy6pKQ+a2I1mApehFLYVMErfy
        Ugm8sZAwIHv5ONF9Hdx42U4q9ivuXvhjGrwDPAb/+/jPspoUlZkebTcgOLXeVnbpN0Fi4O
        mfYO9hy1A57czgxNN3omK2FCGnQCtAE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622554356;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8EgX4/gt6sf5LNtGNiTJv0P7r5aa3weWoiMybJOBVqI=;
        b=7uVgbeUYa2u74wUocV48rULZ7voYzXHR7ru2p8KWaQKCu5Be/D6B70NHpR19mVpRegqzz4
        MriCrqSZ4n4b+PBw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 0fR9G/Q2tmAQCgAALh3uQQ
        (envelope-from <hare@suse.de>); Tue, 01 Jun 2021 13:32:36 +0000
Subject: Re: [PATCH v6 06/24] mpi3mr: add support of event handling part-1
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20210520152545.2710479-1-kashyap.desai@broadcom.com>
 <20210520152545.2710479-7-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <084f32dc-b209-b8ba-bc7a-51408f661564@suse.de>
Date:   Tue, 1 Jun 2021 15:32:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210520152545.2710479-7-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/20/21 5:25 PM, Kashyap Desai wrote:
> Firmware can report various MPI Events.
> Support for certain Events (as listed below) are enabled in the driver
> and their processing in driver is covered in this patch.
> 
> MPI3_EVENT_DEVICE_ADDED
> MPI3_EVENT_DEVICE_INFO_CHANGED
> MPI3_EVENT_DEVICE_STATUS_CHANGE
> MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE
> MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST
> MPI3_EVENT_SAS_DISCOVERY
> MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR
> 
> Key support in this patch is device add/removal.
> 
> Fix some compilation warning reported by kernel test robot.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> 
> Cc: sathya.prakash@broadcom.com
> ---
>  drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h | 1880 ++++++++++++++++++++++++++
>  drivers/scsi/mpi3mr/mpi/mpi30_sas.h  |   33 +
>  drivers/scsi/mpi3mr/mpi3mr.h         |  204 +++
>  drivers/scsi/mpi3mr/mpi3mr_fw.c      |  197 ++-
>  drivers/scsi/mpi3mr/mpi3mr_os.c      | 1457 +++++++++++++++++++-
>  5 files changed, 3768 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
>  create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_sas.h
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
