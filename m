From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] iscsi_iser: convert to use the data buffer accessors
Date: Mon, 18 Jun 2007 13:07:19 -0500
Message-ID: <4676C9D7.6020003@cs.wisc.edu>
References: <dcbf60d819ad4d62643fc074968699563f25621b.1180539510.git.fujita.tomonori@lab.ntt.co.jp> <20070531033021L.fujita.tomonori@lab.ntt.co.jp> <4662C89F.1050002@voltaire.com> <20070618195608N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37239 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764864AbXFRSHc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jun 2007 14:07:32 -0400
In-Reply-To: <20070618195608N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: erezz@voltaire.com, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, rdreier@cisco.com

FUJITA Tomonori wrote:
> From: Erez Zilber <erezz@voltaire.com>
> Subject: Re: [PATCH 2/2] iscsi_iser: convert to use the data buffer accessors
> Date: Sun, 03 Jun 2007 16:56:47 +0300
> 
>> FUJITA Tomonori wrote:
>>
>>> iscsi_iser: convert to use the data buffer accessors
>>>
>>> - remove the unnecessary map_single path.
>>>
>>> - convert to use the new accessors for the sg lists and the
>>> parameters.
>>>
>>> TODO: use scsi_for_each_sg().
>>>
>>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>>> ---
>>>  drivers/infiniband/ulp/iser/iscsi_iser.c     |    4 ++--
>>>  drivers/infiniband/ulp/iser/iser_initiator.c |   14 ++++----------
>>>  2 files changed, 6 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c
>>> b/drivers/infiniband/ulp/iser/iscsi_iser.c
>>> index 1bf173d..effdee2 100644
>>> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
>>> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
>>> @@ -210,10 +210,10 @@ iscsi_iser_ctask_xmit(struct iscsi_conn *conn,
>>>         int error = 0;
>>>
>>>         if (ctask->sc->sc_data_direction == DMA_TO_DEVICE) {
>>> -               BUG_ON(ctask->sc->request_bufflen == 0);
>>> +               BUG_ON(scsi_bufflen(ctask->sc) == 0);
>>>
>>>                 debug_scsi("cmd [itt %x total %d imm %d unsol_data %d\n",
>>> -                          ctask->itt, ctask->sc->request_bufflen,
>>> +                          ctask->itt, scsi_bufflen(ctask->sc),
>>>                            ctask->imm_count, ctask->unsol_count);
>>>         }
>>>
>>> diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c
>>> b/drivers/infiniband/ulp/iser/iser_initiator.c
>>> index 3651072..9ea5b9a 100644
>>> --- a/drivers/infiniband/ulp/iser/iser_initiator.c
>>> +++ b/drivers/infiniband/ulp/iser/iser_initiator.c
>>> @@ -351,18 +351,12 @@ int iser_send_command(struct iscsi_conn     *conn,
>>>         else
>>>                 data_buf = &iser_ctask->data[ISER_DIR_OUT];
>>>
>>> -       if (sc->use_sg) { /* using a scatter list */
>>> -               data_buf->buf  = sc->request_buffer;
>>> -               data_buf->size = sc->use_sg;
>>> -       } else if (sc->request_bufflen) {
>>> -               /* using a single buffer - convert it into one entry SG */
>>> -               sg_init_one(&data_buf->sg_single,
>>> -                           sc->request_buffer, sc->request_bufflen);
>>> -               data_buf->buf   = &data_buf->sg_single;
>>> -               data_buf->size  = 1;
>>> +       if (scsi_sg_count(sc)) { /* using a scatter list */
>>> +               data_buf->buf  = scsi_sglist(sc);
>>> +               data_buf->size = scsi_sg_count(sc);
>>>         }
>>>
>>> -       data_buf->data_len = sc->request_bufflen;
>>> +       data_buf->data_len = scsi_bufflen(sc);
>>>
>>>         if (hdr->flags & ISCSI_FLAG_CMD_READ) {
>>>                 err = iser_prepare_read_cmd(ctask, edtl);
>>> --
>>> 1.4.4.4
>>>
>>>
>> Looks ok to me. I also ran some sanity tests and it works fine.
>>
>> Erez
> 
> Who acks this patch, Mike or Roland?
> 

I believe Erez is the iser maintainer. He normally sends patches to
Roland like how scsi driver maintainers send patches to James.
