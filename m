From: Rafael Tinoco <rafaeldtinoco@kernelpath.com>
Subject: Re: [PATCH] scsi: libiscsi: Allow sd_shutdown on bad transport
Date: Sun, 31 Dec 2017 10:48:16 -0200
Message-ID: <CABdQkv_6pEVLxeRwJAEg+GLn1X1NrMT9rXDpyoxMU4eucD5OWw@mail.gmail.com>
References: <1512683953-5959-1-git-send-email-rafael.tinoco@canonical.com> <yq1zi6cg5xv.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34127 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbdLaMss (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Dec 2017 07:48:48 -0500
Received: by mail-wr0-f196.google.com with SMTP id 36so11703919wrh.1
        for <linux-scsi@vger.kernel.org>; Sun, 31 Dec 2017 04:48:47 -0800 (PST)
In-Reply-To: <yq1zi6cg5xv.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Rafael David Tinoco <rafael.tinoco@canonical.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, Jay Vosburgh <jay.vosburgh@canonical.com>, Daniel Axtens <daniel.axtens@canonical.com>, Dragan Stancevic <dragan.stancevic@canonical.com>

Hello Lee,

I saw there was a reply from Lee to googlegroups
(https://goo.gl/x8LhFm). I haven't responded before because I was
subscribed only to linux-scsi@, my bad.

Yes, it worked as expected.

>From your question:

> Rafael:

> Did you test this change, i.e. shutdowns no longer hang, under test
> circumstances, with this change?

Yes, my start work was:

https://pastebin.ubuntu.com/26292711/

And the tests during devel:

https://pastebin.ubuntu.com/26292701/
https://pastebin.ubuntu.com/26292702/

And finally with the submitted patch the expected behavior:

https://pastebin.ubuntu.com/26292706/ -> just 1 session
https://pastebin.ubuntu.com/26292708/ -> multiple sessions

Note:

[   78.427670]  session6: iscsi_eh_cmd_timed_out scsi cmd
ffff88b2ef499160 timedout
[   78.427671]  session6: iscsi_eh_cmd_timed_out sc on shutdown, handled
[   78.427671]  session6: iscsi_eh_cmd_timed_out return shutdown or nh

[   78.437637]  session7: iscsi_eh_cmd_timed_out scsi cmd
ffff88b2f161c160 timedout
[   78.438366]  session7: iscsi_eh_cmd_timed_out sc on shutdown, handled
[   78.439004]  session7: iscsi_eh_cmd_timed_out return shutdown or nh

[   78.441551]  session8: iscsi_eh_cmd_timed_out scsi cmd
ffff88b2ef49a160 timedout
[   78.442278]  session8: iscsi_eh_cmd_timed_out sc on shutdown, handled
[   78.442914]  session8: iscsi_eh_cmd_timed_out return shutdown or nh

[  109.149438]  session2: iscsi_eh_cmd_timed_out scsi cmd
ffff88b2ef1fd560 timedout
[  109.150251]  session2: iscsi_eh_cmd_timed_out sc on shutdown, handled
[  109.150969]  session2: iscsi_eh_cmd_timed_out return shutdown or nh

[   78.427506] sd 8:0:0:1: tag#0 Done: TIMEOUT_ERROR Result:
hostbyte=DID_OK driverbyte=DRIVER_OK
[   78.427662] sd 7:0:0:1: tag#0 Done: TIMEOUT_ERROR Result:
hostbyte=DID_OK driverbyte=DRIVER_OK
[   78.439548] sd 9:0:0:1: tag#0 Done: TIMEOUT_ERROR Result:
hostbyte=DID_OK driverbyte=DRIVER_OK
[  109.146728] sd 3:0:0:1: tag#0 Done: TIMEOUT_ERROR Result:
hostbyte=DID_OK driverbyte=DRIVER_OK

the iscsi_eh_cmd_timed_out logic after the ping timeouts.

And then:

[   78.427678] sd 7:0:0:1: tag#0 Done: SUCCESS Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[   78.443456] sd 8:0:0:1: tag#0 Done: SUCCESS Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[   78.447592] sd 9:0:0:1: tag#0 Done: SUCCESS Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[  109.151582] sd 3:0:0:1: tag#0 Done: SUCCESS Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK

The iscsi_queuecommand logic setting RESULT to DID_NO_CONNECT when
queueing under shutdown on disconnected transport.

[   78.427683] sd 7:0:0:1: Notifying upper driver of completion (result 10000)
[   78.445899] sd 8:0:0:1: Notifying upper driver of completion (result 10000)
[   78.450035] sd 9:0:0:1: Notifying upper driver of completion (result 10000)
[  109.154495] sd 3:0:0:1: Notifying upper driver of completion (result 10000)

> [side note: we *really* need an open-iscsi test suite! Anybody?]

I'm interested in creating/helping (specially now that I read big part
of the code because of this bug).

> As long as the upper levels handle this correctly, I'm good with it.

Yes, check it out. At the end:

[  109.354984] sd 8:0:0:1: tag#0 0 sectors total, 0 bytes done.
[  109.355596] sd 8:0:0:1: [sda] Synchronize Cache(10) failed: Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[  109.356980] reboot: Restarting system
[  109.357392] reboot: machine restart

You see the "sync cache failed" message (important to see you couldn't
sync that disk and you might need to fix userland shutdown order) with
DID_NO_CONNECT (since the sd_shutdown tries to sync 3 times you might
see lots of DID_NO_CONNECT errors, for all sessions, but all of the
commands will be handled after this change, and upper layer informed
of the error).

I hope that answers you. Let me know if you want me to provide any
other information.

Cheers
-Rafael

On Thu, Dec 21, 2017 at 12:39 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>> If, for any reason, userland shuts down iscsi transport interfaces
>> before proper logouts - like when logging in to LUNs manually, without
>> logging out on server shutdown, or when automated scripts can't
>> umount/logout from logged LUNs - kernel will hang forever on its
>> sd_sync_cache() logic, after issuing the SYNCHRONIZE_CACHE cmd to all
>> still existent paths.
>
> Chris and Lee: Please review. Thanks!
>
> --
> Martin K. Petersen      Oracle Linux Engineering
