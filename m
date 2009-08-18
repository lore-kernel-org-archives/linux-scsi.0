From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Bidirectional data transfers from SCSI layer
Date: Tue, 18 Aug 2009 11:04:29 +0300
Message-ID: <4A8A608D.9000909@panasas.com>
References: <97a757510908172322y7a42df80n5bf7f21fbca16e13@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:28029
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751243AbZHRIEe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Aug 2009 04:04:34 -0400
In-Reply-To: <97a757510908172322y7a42df80n5bf7f21fbca16e13@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Madhavi Manchala <madhavi.lscsi@gmail.com>
Cc: linux-scsi@vger.kernel.org

On 08/18/2009 09:22 AM, Madhavi Manchala wrote:
> Dear All,
> 
> I have seen that SCSI supports bi-directional commands
> DMA_BIDIRECTIONAL. However, I did not get such type of commands in my
> mass storage driver. My device supports bi-directional data transfers.
> My question is, how can I get such type of requests to my mass storage
> driver? If so, how can I handle the IN and OUT buffers? Are there
> separate buffers for both? Is there any support for the bi-directional
> in the current SCSI implementation? I am currently using the 2.6.28
> kernel code.
> 
> We have only one pointer for data buffer instead of two, one for data
> OUT and one for data IN in command block. There is only one length
> variable. How can we use the OUT and IN buffers? How can I pass
> different IN length and OUT length to lower stack from SCSI layer?
> 
> Is there any thing need to be changed in the SCSI layer code to handle
> the bi-directional data transfers?
> 
> Please point to me some links which shows the bi-directional data transfers.
> 
> Thanks in advance.
> 
> With Regards,
> Madhavi M.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Bidi is fully supported since 2.6.25

If you want example of how to issue bidi commands you can see these two files:
block/bsg.c
drivers/scsi/osd/osd_initiator.c

Basically you allocate two struct request one for OUT one for IN. You map
some memory on them and do "out_req->next_rq = in_req;" And you execute
the out_req.
These two request will go together as one bidi request.

On the scsi-driver side you do:

	if (scsi_bidi_cmnd(cmnd)) {
		in_sgl = scsi_in(cmnd)->table.sgl;
		in_nents = scsi_in(cmnd)->table.nents;
		in_bytes = scsi_in(cmnd)->length;

		/* Same thing for out */
		out_sgl = scsi_out(cmnd)->table.sgl;
		...
	}

scsi_in() and scsi_out() will return a pointer or NULL if the
cmnd does not have a buffer in this direction. So for example
scsi_in() is always used on receive regardless if it is a bidi
or a uni_read.

NOTE: in bidi_commands
	scsi_bidi_cmnd(cmnd) == true;
	but
	cmnd->sc_data_direction == DMA_TO_DEVICE;
	DMA_BIDIRECTIONAL is *never* returned from scsi
	and it means something else inside the DMA engines.

For example driver that supports bidi see:
drivers/scsi/iscsi_tcp.c
drivers/scsi/scsi_debug.c
(Search for "scsi_in" and "scsi_out")

What type of scsi-device are you using? what bidi commands?

Have a good day
Boaz
