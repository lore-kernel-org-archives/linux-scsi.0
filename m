From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH 5/7] target: Check sess_tearing_down in target_get_sess_cmd()
Date: Tue, 17 Jul 2012 09:34:49 -0700
Message-ID: <CAL1RGDUVaF_GGwN_0nYD2X87Sa0hwiihuua9HJgK=CJ7HiFv_w@mail.gmail.com>
References: <1342461882-5848-1-git-send-email-roland@kernel.org>
 <1342461882-5848-6-git-send-email-roland@kernel.org> <1342480139.18004.309.camel@haakon2.linux-iscsi.org>
 <CAL1RGDVNouDHfvKt-WryhhxswC8a8sd+gP-eg3aVDkgB8wU_Bw@mail.gmail.com>
 <CAL1RGDWgbdsQr1=YMdFyRt=h5Mr40mtXRExUgD_88YPzOnkMkw@mail.gmail.com> <1342490218.18004.382.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1342490218.18004.382.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 16, 2012 at 6:56 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>> Do you have a plan for how to handle this?  Do we really want to plumb
>> through another callback to tell the fabric driver to free the command
>> in this case?

> I need to think more about this ahead of changing it back again for-3.6
> now that other fabrics have the assumption of target_submit_cmd() would
> not fail.

> There is a clear case with qla2xxx for just changing it back (we might
> end up doing that just yet) but I wanted to get the other important bits
> into for-next into place first..

Sleeping on things, I now feel pretty strongly that having target_submit_cmd
return an error value for "immediate" errors where the command does not
make it into the target core is the right approach.

Freeing commands is already one of the most confusing and complex parts
of the target code, with "check_stop_free," "cmd_wait_comp" and
"SCF_ACK_KREF."  Adding another code flow back to the fabric driver
with yet another set of semantics around freeing a command seems like
it's making things even harder to maintain.

On the other hand, every caller of target_submit_cmd() in the tree already
has an error path where it handles problems it detects right before calling
target_submit_cmd(), and so it's trivial to share that for problems detected
inside target_submit_cmd().  If you look at patch 4/7, pretty much the
only changes are like going from

    target_submit_cmd(...);

to

    if (target_submit_cmd(...))
        goto err;

and in fact the ->handle_cmd() wrapper that qla_target uses to call
target_submit_cmd via tcm_qla2xxx already has a return value that
qla_target handled properly!

I guess another approach would be to split target_submit_cmd() into
the target_get_sess_cmd() part and the rest of it, and have fabric
drivers handle errors queueing commands but not have to worry about
the submit cmd part failing.  But I'm not sure that's any better.

Andy, any feelings about this one way or another?  Christoph?

Thanks,
  Roland
