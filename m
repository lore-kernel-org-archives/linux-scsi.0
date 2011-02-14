From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 14 Feb 2011 12:50:40 +0100
Message-ID: <AANLkTin3Zb3OQz0942-2bcpfwqd8dGGnHyBjmeYt0FwZ@mail.gmail.com>
References: <1297340495-13347-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1297340495-13347-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <AANLkTikWDxfTFeGqG36Z1dAdWLeXmN7r=AsR3fsjBok+@mail.gmail.com> <20110214181129X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39601 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab1BNLvN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2011 06:51:13 -0500
Received: by iyj8 with SMTP id 8so4718297iyj.19
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2011 03:51:13 -0800 (PST)
In-Reply-To: <20110214181129X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>

On Mon, Feb 14, 2011 at 10:11 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Mon, 14 Feb 2011 08:16:45 +0100
> Bart Van Assche <bvanassche@acm.org> wrote:
>
>> Are you sure that it is fine to pass values like MSG_SIMPLE_TAG as the
>> sixth argument of transport_init_se_cmd() ? As far as I know TCM
>> doesn' t support any of the MSG_..._TAG values.
>
> Oops, I'll send the next version soon.

Hi Tomo,

Two other issues I noticed are:
- send_rsp() sends back an SRP response with req_lim_delta = 1 before
srp_iu_put() is invoked. I think this is a race condition: it can
happen that the SRP initiator has received an SRP_RSP and sends a new
SRP_CMD before srp_iu_put() was invoked. On a heavily loaded system
that can trigger a queue overflow in the target.
- As anyone can see in the driver code (and as specified in the PAPR)
management datagrams (MADs) fall outside the SRP credit mechanism.
Hence not reserving one credit (assuming that the initiator makes sure
there is at most one outstanding MAD) for MAD can - at least in theory
- trigger a queue overflow.

Bart.
