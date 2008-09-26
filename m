From: Tammy <tammy000@gmail.com>
Subject: Re: [PATCH git latest] drivers/scsi: fixing wrong comment before new_buffer_tape()
Date: Fri, 26 Sep 2008 11:05:00 -0500
Message-ID: <7fcc02550809260905oa17880fi80c94eaacb33dba3@mail.gmail.com>
References: <20080925174948.GA14180@carmen.cs.uiuc.edu>
	 <20080926111300.1dd34009@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:54021 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYIZQFC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2008 12:05:02 -0400
Received: by fk-out-0910.google.com with SMTP id 18so972676fkq.5
        for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2008 09:05:00 -0700 (PDT)
In-Reply-To: <20080926111300.1dd34009@lxorguk.ukuu.org.uk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>> Removing the wrong comment.
>> The lock is needed before calling new_tape_buffer(), at least in some cases.
>> So the comment above new_tape_buffer() is inconsistent with the code and
>> may mislead developers.
>>
>> I simply removed the wrong comment, as I am not sure if the lock is required
>> in all situations. If so, we should add "Caller must hold os_scsi_tapes_lock".
>>
>> Signed-off-by: Lin Tan <tammy000@gmail.com>
>
> Looks true to me for the current versions of the code. In fact it is only
> ever called from the initialisation function that I can see so chunks of
> the code could simply go away as well as bits of the comment. Ditto the
> one in drivers/scsi/st.c
>
> Acked-by: Alan Cox <alan@redhat.com>
>

I am sorry I didn't quite understand. You mean it is true that caller
must hold os_scsi_tapes_lock?

new_tape_buffer in drivers/scsi/st.c is called without the lock, but
the new_tape_buffer in drivers/scsi/osst.c
is called with the lock. Both comments says no lock is needed. Should
the two new_tap_buffer functions have similar usage?

BTW, I am on the mailing list now, so I no longer need to be
personally CC-ed. Thanks.

Lin
