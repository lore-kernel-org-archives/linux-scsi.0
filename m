From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/2] ib_srpt: Make srp_max_req_size module parameter use S_IRUGO|S_IWUSR
Date: Sun, 6 Nov 2011 12:46:13 +0100
Message-ID: <CAO+b5-qEUcheRYWfiak1p=a01YZNX+ggQNT5phfDtOYtJZLmOw@mail.gmail.com>
References: <1320578141-27048-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65272 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab1KFLqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Nov 2011 06:46:15 -0500
In-Reply-To: <1320578141-27048-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>

On Sun, Nov 6, 2011 at 12:15 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> This patch converts the srp_max_req_size module parameter to R/W acce=
ss
> so that it's accessable when built as CONFIG_INFINIBAND_SRPT=3Dy. =A0=
This

accessible ?

> includes adding srpt_device->max_req_size that is assigned during
> srpt_add_one() and referenced directly from there.

I'm not sure it makes sense to store a copy of this parameter in the
srpt_device structure. If the HCA driver code (e.g. mlx4) is also
built into the kernel instead of as a separate module, any changes of
srp_max_req_size after ib_srpt and HCA driver initialization finished
won't have any effect.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
