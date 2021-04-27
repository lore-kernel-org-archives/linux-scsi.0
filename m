Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 836AAC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 18:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5377260BBB
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 18:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236571AbhD0SJm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 14:09:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:51516 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235505AbhD0SJl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 14:09:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BC6A2B176;
        Tue, 27 Apr 2021 18:08:56 +0000 (UTC)
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        Steve Hagan <steve.hagan@broadcom.com>,
        Peter Rivera <peter.rivera@broadcom.com>,
        mpi3mr-drvr-developers <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        bvanassche@acm.org, thenzl@redhat.com
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-3-kashyap.desai@broadcom.com>
 <ee276aee-d1dd-822c-6e75-ea570b63c052@suse.de>
 <0337ec73d6925daecdf5ca4e7db490bd@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Subject: Re: [PATCH v3 02/24] mpi3mr: base driver code
Message-ID: <55c0bc87-e3cd-fba3-b39c-f3612d5deef5@suse.de>
Date:   Tue, 27 Apr 2021 20:08:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <0337ec73d6925daecdf5ca4e7db490bd@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/27/21 5:47 PM, Kashyap Desai wrote:
>>>
>>> mpi3mr_fw.c -	Keep common code which interact with underlying
>> fw/hw.
>>> mpi3mr_os.c -	Keep common code which interact with scsi midlayer.
>>> mpi3mr_app.c -	Keep common code which interact with
>> application/ioctl.
>>> 		This is currently work in progress.
>>>
>>
>> Meaning what? That it's not finished by the time of submission?
> 
> Hannes-
> 
> Current patch series has around 15K lines so we wanted to avoid something
> which can be delayed for better review.
> Application part is ready but it is many time going through API changes, so
> having something close to freeze is better for upstream submission.
> Once this set is committed , application support is possible in next series.
> 
>>> +
>>> +/**
>>> + * struct scmd_priv - SCSI command private data
>>> + *
>>> + * @host_tag: Host tag specific to operational queue
>>> + * @in_lld_scope: Command in LLD scope or not
>>> + * @scmd: SCSI Command pointer
>>> + * @req_q_idx: Operational request queue index
>>> + * @chain_idx: Chain frame index
>>> + * @mpi3mr_scsiio_req: MPI SCSI IO request
>>> + */
>>> +struct scmd_priv {
>>> +	u16 host_tag;
>>> +	u8 in_lld_scope;
>>> +	struct scsi_cmnd *scmd;
>>> +	u16 req_q_idx;
>>> +	int chain_idx;
>>> +	u8 mpi3mr_scsiio_req[MPI3MR_ADMIN_REQ_FRAME_SZ];
>>> +};
>>> +
>>
>> Why is this not of type MPI3_SCSI_IO_REQUEST, but rather a binary blob?
>>
> 
> Type MPI3_SCSI_IO_REQUEST is not static struct.  MPI spec designed to have
> dynamic size of " MPI3_SCSI_IO_REQUEST" but current code cannot work to
> handle dynamic size.
> In case of old MPT product (mpt3sas) most of the time we have always used
> 128 byte size from FW for MPI3_SCSI_IO_REQUEST and that may continue for
> this product as well.
> I have to discuss within a Broadcom and do changes in this area based on
> product support. For now, I have to consider your comment as TBD. Hope you
> are ok with it.
> 
Oh, that's okay. If the commands really are of different sizes then sure
you'd have to use a raw blob to avoid padding.

So:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
