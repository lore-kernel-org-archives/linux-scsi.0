From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] sd: use async_probe cookie to avoid deadlocks
Date: Tue, 21 Mar 2017 13:02:45 +0000
Message-ID: <1490101348.2602.3.camel@sandisk.com>
References: <1490098475-21884-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:32795 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756607AbdCUNDo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Mar 2017 09:03:44 -0400
In-Reply-To: <1490098475-21884-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <E6EAEEA90B60164E8B7CD47BB59096EF@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "hck@suse.de" <hck@suse.de>, "hare@suse.com" <hare@suse.com>

On Tue, 2017-03-21 at 13:14 +0100, Hannes Reinecke wrote:
> With the current design we're waiting for all async probes to
> finish when removing any sd device.
> This might lead to a livelock where the 'remove' call is blocking
> for any probe calls to finish, and the probe calls are waiting for
> a response, which will never be processes as the thread handling
> the responses is waiting for the remove call to finish.
> Which is completely pointless as we only _really_ care for the
> probe on _this_ device to be completed; any other probing can
> happily continue for all we care.
> So save the async probing cookie in the structure and only wait
> if this specific probe is still active.

Nice work! This may even help to reduce system boot time.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=
