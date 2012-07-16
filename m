From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH 5/7] target: Check sess_tearing_down in target_get_sess_cmd()
Date: Mon, 16 Jul 2012 16:21:10 -0700
Message-ID: <CAL1RGDVNouDHfvKt-WryhhxswC8a8sd+gP-eg3aVDkgB8wU_Bw@mail.gmail.com>
References: <1342461882-5848-1-git-send-email-roland@kernel.org>
 <1342461882-5848-6-git-send-email-roland@kernel.org> <1342480139.18004.309.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1342480139.18004.309.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 16, 2012 at 4:08 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> However, I'm still leaning towards a way to do this for tcm_qla2xxx that
> does not require all fabric callers to handle target_submit_cmd()
> exceptions directly..
>
> How about a special target_get_sess_cmd() failure callback to free
> se_cmd when target_get_sess_cmd() fails, but not actually send a SCSI
> response back out to the fabric here during session shutdown..?

I guess that's OK, although I'm not sure it ends up being cleaner.  If
you look at my 4/7 patch, you see that all target_submit_cmd callers
have an error path where they handle terminating commands that
fail processing just before calling submit_cmd anyway.

eg for qla2xxx we'll need a callback to call qlt_send_term_exchange()
in addition to the error path call that qlt_do_work() has anyway.
Similarly tcm_fc ends up with a second call to ft_send_resp_code_and_free().
etc.

But I don't really have a strong feeling about this, if the view is that
submit_cmd() should never return failure directly then I'm OK with that.

> That said, I'm going to commit this patch (slightly changed to keep
> target_submit_cmd() returning void for now) but I'd still like a better
> way of handling this particular failure without propagating up the
> return value.

OK, I'll take a look at how you handle this...

 - R.
