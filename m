Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41179C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 14:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1F9164F06
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 14:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhBYONO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 09:13:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24823 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229596AbhBYONM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Feb 2021 09:13:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614262306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e42Bhcv/j7R1K+cvJUGVhipLrWMT4j0PHZxpZDxA2AM=;
        b=Na7QVtisQnIDfyG9IJc6T2zPowg4qbnnjOuREDKWUlU0T/dSED+cBMe+L16eftave5X/zT
        /uWYjwTKONi9pDbdb/IaIhWsYsmHXr6FUg4GoLHM0BZaiFofjcidP5XIvwp8CaT6eJ++Q7
        FrKf0/J9e9QB8F9OgJeXBdGp60fIeYM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-uv69UIn1PUKN167oFleOOw-1; Thu, 25 Feb 2021 09:11:42 -0500
X-MC-Unique: uv69UIn1PUKN167oFleOOw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79A5C50741;
        Thu, 25 Feb 2021 14:11:40 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4C635C224;
        Thu, 25 Feb 2021 14:11:38 +0000 (UTC)
Subject: Re: [PATCH 04/24] mpi3mr: add support of queue command processing
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        Steve Hagan <steve.hagan@broadcom.com>,
        Peter Rivera <peter.rivera@broadcom.com>,
        mpi3mr-drvr-developers <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-5-kashyap.desai@broadcom.com>
 <2faf0f39-67f5-a7c4-2e64-eb52d8da961f@redhat.com>
 <5c535a4374339ecf4521fb53a34e2823@mail.gmail.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <b7b9f72e-5678-6edd-5978-0e4933912b8b@redhat.com>
Date:   Thu, 25 Feb 2021 15:11:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <5c535a4374339ecf4521fb53a34e2823@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/25/21 2:24 PM, Kashyap Desai wrote:
>>>   * mpi3mr_slave_destroy - Slave destroy callback handler
>>>   * @sdev: SCSI device reference
>>> @@ -126,10 +658,114 @@ static int mpi3mr_target_alloc(struct
>>> scsi_target *starget)  static int mpi3mr_qcmd(struct Scsi_Host *shost,
>>>  	struct scsi_cmnd *scmd)
>>>  {
>>> +	struct mpi3mr_ioc *mrioc = shost_priv(shost);
>>> +	struct mpi3mr_stgt_priv_data *stgt_priv_data;
>>> +	struct mpi3mr_sdev_priv_data *sdev_priv_data;
>>> +	struct scmd_priv *scmd_priv_data = NULL;
>>> +	Mpi3SCSIIORequest_t *scsiio_req = NULL;
>>> +	struct op_req_qinfo *op_req_q = NULL;
>>>  	int retval = 0;
>>> +	u16 dev_handle;
>>> +	u16 host_tag;
>>> +	u32 scsiio_flags = 0;
>>> +	struct request *rq = scmd->request;
>>> +	int iprio_class;
>>> +
>>> +	sdev_priv_data = scmd->device->hostdata;
>>> +	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
>>> +		scmd->result = DID_NO_CONNECT << 16;
>>> +		scmd->scsi_done(scmd);
>>> +		goto out;
>>> +	}
>>>
>>> -	scmd->result = DID_NO_CONNECT << 16;
>>> -	scmd->scsi_done(scmd);
>>> +	if (mrioc->stop_drv_processing) {
>>> +		scmd->result = DID_NO_CONNECT << 16;
>>> +		scmd->scsi_done(scmd);
>>> +		goto out;
>>> +	}
>> Hi Kashyap,
>> for what is the above test needed (stop_drv_processing) it looks like
> other
>> drivers don't need to protect exit function in this was (for example
> mpt3sas).
> Tomas, This driver code Is still under active development and I will
> review this (marking as TBD).
> Not only this area, but there are many more optimization possible in
> mpi3mr driver.
> We want to start with stable version of driver and gradually improve.
> <mpi3mr> as multiple h/w queue support and mpt3sas is single queue h/w.
> Due to some h/w differences we have noticed some issue are very frequent
> for mp3mr vs mpt3sas.
> 
> We can opt other way around as well. We can remove this check now and when
> we find the bug we can add the fix with root cause details.
> Let me know if you are OK to keep this check now or add it whenever it is
> required.

You may keep it as it is and remove later if you think that it is safer.
I was only curious how this could be triggered.


> 
> Kashyap
> 
>> Regards,
>> Tomash

