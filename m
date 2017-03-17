From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [ANNOUNCE]: Broadcom (Emulex) FC Target driver - efct
Date: Fri, 17 Mar 2017 00:10:21 +0000
Message-ID: <1489709408.2574.26.camel@sandisk.com>
References: <ced2ff0a-05ee-b85e-b41a-f912cab9e267@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:30258 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752193AbdCQAWn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2017 20:22:43 -0400
In-Reply-To: <ced2ff0a-05ee-b85e-b41a-f912cab9e267@gmail.com>
Content-Language: en-US
Content-ID: <E75081436ECA3648ADAA03F620741E0F@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jsmart2021@gmail.com" <jsmart2021@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2017-02-27 at 15:28 -0800, James Smart wrote:
> I'd like to announce the availability of the Broadcom (Emulex) FC Target=
=20
> driver - efct.

Hello James,

Sorry but I have not yet had the time to do a full review. But I would like
to already share the following feedback:
* efct_io_find_tgt_io() looks up an I/O request in a list. The lookup is
  protected by a spinlock but callers are expected to increase the I/O
  request reference count after the lock has been released. This looks wron=
g
  to me and most likely means that there are race conditions related to I/O
  request lookup. Have you considered to move the kref_get() call into
  efct_io_find_tgt_io() such that it can occur with the spinlock held?
* If an ABTS is received then efct_process_abts() (indirectly) calls
  target_submit_tmr(). That last function may or may not decide to call
  efct_lio_queue_status(), depending on whether or not the TAS bit has been
  set. efct_lio_queue_status() sends back a SCSI response to the initiator
  (see also __transport_check_aborted_status() and
  transport_send_task_abort()). Is it allowed by the FC spec to send back a
  SCSI response after an ABTS has been received? Is that SCSI response sent
  before or after the BLS ABTS response?

Thanks,

Bart.=
