From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 27/32] scsi_data_buffer
Date: Thu, 18 Oct 2007 10:27:34 +0200
Message-ID: <471718F6.6070206@panasas.com>
References: <4716529B.7020107@panasas.com>	<20071018084008Z.fujita.tomonori@lab.ntt.co.jp>	<4717106E.7040404@panasas.com> <20071018165723L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:5213 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750878AbXJRI2S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 04:28:18 -0400
In-Reply-To: <20071018165723L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, tomof@acm.org, matthew@wil.cx, mdharm-scsi@one-eyed-alien.net, rmk@arm.linux.org.uk, stern@rowland.harvard.edu, davem@davemloft.net, hch@infradead.org, linux-scsi@vger.kernel.org, bhalevy@panasas.com, pw@osc.edu

On Thu, Oct 18 2007 at 9:57 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> On Thu, 18 Oct 2007 09:51:10 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> On Thu, Oct 18 2007 at 1:40 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>>> On Wed, 17 Oct 2007 20:21:15 +0200
>>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>>
>>>>   In preparation for bidi we abstract all IO members of scsi_cmnd,
>>>>   that will need to duplicate, into a substructure.
>>>>
>>>>   - Group all IO members of scsi_cmnd into a scsi_data_buffer
>>>>     structure.
>>>>   - Adjust accessors to new members.
>>>>   - scsi_{alloc,free}_sgtable receive a scsi_data_buffer instead of
>>>>     scsi_cmnd. And work on it.
>>>>   - Adjust scsi_init_io() and  scsi_release_buffers() for above
>>>>     change.
>>>>   - Fix other parts of scsi_lib/scsi.c to members migration. Use
>>>>     accessors where appropriate.
>>>>
>>>>   - Old I/O members are kept for backward compatibility, since
>>>>     not all of scsi-ml/ul is converted yet. Once done they will
>>>>     be removed in a closing patch. (Other wise the patchset will
>>>>     not be bisectable)
>>> (snip)
>>>
>>>> @@ -114,6 +112,22 @@ struct scsi_cmnd {
>>>>  	int result;		/* Status code from lower level driver */
>>>>  
>>>>  	unsigned char tag;	/* SCSI-II queued command tag */
>>>> +
>>>> +	union {
>>>> +		struct scsi_data_buffer sdb;
>>>> +		/*
>>>> +		 * FIXME: Here for compatibility with unconverted drivers.
>>>> +		 *        Must be kept in sync with exact type and order
>>>> +		 *        of struct scsi_data_buffer members.
>>>> +		 */
>>>> +		struct {
>>>> +			unsigned __deprecated request_bufflen;
>>>> +			int __deprecated resid;
>>>> +			unsigned short __deprecated use_sg;
>>>> +			unsigned short __deprecated place_holder_sg_alloc;
>>>> +			void __deprecated *request_buffer;
>>>> +		};
>>>> +	};
>>>>  };
>>> If we add something like this, why couldn't we merge the
>>> scsi_data_buffer patchset when I submitted last month?
>>>
>>> I thought that I wait you to fix all the old LLDs, then will send a
>>> clean scsi_data_buffer patchset.
>> We do have all the old LLDs fixed. After this patchset the entire tree
>> is clean. I have just forgot to send the last [33/33] patch that removes
>> this. I have just sent it now, sorry.
>> (The change log above explains exactly why this is done here)
> 
> As I said, I can't see why we need this compatibility hack in the
> first place.
> 
> We need to wait patches 1-26 to be merged. After that, we can merge
> clean scsi_data_buffer patchset (without the compatibility hack).
> 
No.
It is here so we can separate the patches 27 to 32 and still be
bisect-able and running at each patch. Other wise all 27-32 patches
must be a single patch. This is the only reason why this is done.
At patch [33/33] this is removed and be done with.
James and Linus have stated lots of times that they want every stage
of the tree compiling running and complete. I took it to hart, and
I don't mind the extra effort.

Boaz




