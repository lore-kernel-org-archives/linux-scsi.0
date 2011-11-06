From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/2] ib_srpt: Make srp_max_req_size module parameter use S_IRUGO|S_IWUSR
Date: Sun, 6 Nov 2011 13:54:23 +0100
Message-ID: <CAO+b5-qeurR2=oH6Gtcrg=nW1N3Mc-jSUMMC-0sarFxKAm=-TQ@mail.gmail.com>
References: <1320578141-27048-1-git-send-email-nab@linux-iscsi.org>
	<CAO+b5-qEUcheRYWfiak1p=a01YZNX+ggQNT5phfDtOYtJZLmOw@mail.gmail.com>
	<1320581400.5859.449.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53877 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab1KFMyY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Nov 2011 07:54:24 -0500
In-Reply-To: <1320581400.5859.449.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>

Met vriendelijke groeten,

On Sun, Nov 6, 2011 at 1:10 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> On Sun, 2011-11-06 at 12:46 +0100, Bart Van Assche wrote:
>> On Sun, Nov 6, 2011 at 12:15 PM, Nicholas A. Bellinger
>> <nab@linux-iscsi.org> wrote:
>> > This patch converts the srp_max_req_size module parameter to R/W a=
ccess
>> > so that it's accessable when built as CONFIG_INFINIBAND_SRPT=3Dy. =
=A0This
>> > includes adding srpt_device->max_req_size that is assigned during
>> > srpt_add_one() and referenced directly from there.
>>
>> I'm not sure it makes sense to store a copy of this parameter in the
>> srpt_device structure. If the HCA driver code (e.g. mlx4) is also
>> built into the kernel instead of as a separate module, any changes o=
f
>> srp_max_req_size after ib_srpt and HCA driver initialization finishe=
d
>> won't have any effect.
>
> So it sounds like srp_max_req_size with CONFIG_INFINIBAND_SRPT=3Dy is=
 not
> really going to be of much use anyways. =A0What about just leaving it=
 as
> read-only..?

Another option is to copy the value of that parameter into struct
srpt_rdma_ch at SRP login time. That way any change of that parameter
won't have any effect for active sessions but will have effect for all
future logins.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
