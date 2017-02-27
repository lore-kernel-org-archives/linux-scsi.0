From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCHv2 0/5] SCSI EH cleanup
Date: Mon, 27 Feb 2017 22:10:13 +0000
Message-ID: <1488233398.2597.3.camel@sandisk.com>
References: <1487779650-1338-1-git-send-email-hare@suse.de>
         <1487908867.2907.3.camel@sandisk.com>
         <ef796d74-4425-92ab-d602-c0b66a8cf19d@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:12080 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751828AbdB0WV7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2017 17:21:59 -0500
In-Reply-To: <ef796d74-4425-92ab-d602-c0b66a8cf19d@suse.de>
Content-Language: en-US
Content-ID: <154F8CD8F61A1544B62A03909657FF6A@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jth@kernel.org" <jth@kernel.org>

On Fri, 2017-02-24 at 08:15 +0100, Hannes Reinecke wrote:
> scsi_abort_command() (ie the call which triggers async aborts) is only
> called if the .eh_timed_out() callback returns BLK_EH_NOT_HANDLED.
> So during reconnects we will not schedule any calls to async aborts.
> We _might_ have scheduled an async abort prior to a call to
> srp_reconnect_rport(), but that would be equivalent with calling
> srp_reconnect_rport() with commands still in flight.
> Is that even possible?
> If so, how do you handle these commands after reconnect returns?
> Any I_T_L nexus will be gone from the target, right?

srp_reconnect_rport() can proceed while commands are in flight. What will
happen is that no response will be received for the commands that are in
flight and hence that these commands will time out at the initiator side.
However, any newly submitted commands will be processed normally.

Bart.=
