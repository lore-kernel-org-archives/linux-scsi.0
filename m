From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] FC pass thru - Rev IV
Date: Tue, 25 Nov 2008 10:47:57 -0500
Message-ID: <492C1E2D.2050300@emulex.com>
References: <1227043498.4949.21.camel@ogier> <C49C4ADF-8DA1-4D86-AEBB-AC46A04FCA62@qlogic.com> <492B1685.4020709@emulex.com> <F285E2FA-64A5-4BB6-ACC4-1B31EB19AFE6@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42550 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbYKYPrR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Nov 2008 10:47:17 -0500
In-Reply-To: <F285E2FA-64A5-4BB6-ACC4-1B31EB19AFE6@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "andrew.vasquez@qlogic.com" <andrew.vasquez@qlogic.com>, "sven@linux.vnet.ibm.com" <sven@linux.vnet.ibm.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>



Seokmann Ju wrote:
>>>> +
>>>> +             spin_unlock_irq(q->queue_lock);
>>>> +
>>>> +             ret = fc_req_to_bsgjob(shost, rport, req);
>>>> +             if (ret) {
>>>> +                     req->errors = ret;
>>>> +                     spin_lock_irq(q->queue_lock);
>>>> +                     blk_complete_request(req);
>>> Shouldn't this be blk_end_bidi_request()/blk_end_request()?
>> A good question, that I was hoping to have cleared up. If this was
>> true, there were a lot of errors in the last passthru code.
> I'm not sure whether the previous code had the
> 'blk_complete_request()' somewhere in the code, but my main concern
> was to make sure that the code completes the requests in such a way so
> that it remove the requests from the timeout_list by hitting
> blk_delete_timer().

Hopefully, Jens, Fujita, or Boaz can give us some guidance...

I'd really like to ensure I'm calling the right callback :
a) if it differs based on being a bidi request or not
b) if it differs based on based on whether I've called blk_rq_map_sg()
c) if I don't dequeue it, whether my "goose queue" is handled right.

I found the blk api to be rather confusing on what when.

-- james
