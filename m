From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH 4/7] target: Allow for target_submit_cmd() returning errors
Date: Mon, 16 Jul 2012 16:05:44 -0700
Message-ID: <CAL1RGDVpak+0MGjDQhX_Jg9q_+6aWi6k=KRttoTr=GU6Xf_KxA@mail.gmail.com>
References: <1342461882-5848-1-git-send-email-roland@kernel.org>
 <1342461882-5848-5-git-send-email-roland@kernel.org> <1342479605.18004.302.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1342479605.18004.302.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Chris Boot <bootc@bootc.net>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Mark Rustad <mark.d.rustad@intel.com>, "Signed-off-by: Sebastian Andrzej Siewior" <bigeasy@linutronix.de>, Felipe Balbi <balbi@ti.com>, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 16, 2012 at 4:00 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> Mmmm.  The original target_submit_cmd() code had been propagating up a
> return value, but then we decided (via Agrover's patch) that it made
> more sense for target_submit_cmd() to always handle exceptions via
> normal TFO callbacks, and not have the fabric worry about the return
> here..
>
> Also, I'm not sure if the error paths that this patch now accesses after
> target_submit_cmd() failure are going to deal with different types of
> target_submit_cmd() failures correctly.
>
> So NACK for the moment, as I don't really see why this is necessary in
> the first place..?

Read on in the series to see why this is needed; in short, for qla2xxx
at least, we need a race-free way to check for sess_tearing_down
atomically with actually adding the command to sess_cmd_list.

I'm OK with returning failure via callback, but

 a) I'm not sure we can use the normal TFO callbacks in case
    we can't add the command to sess_cmd_list (seems like it
    opens the door to other use-after-frees in qla2xxx at least)
 b) Maybe it's OK if we say that failure to add the command to
    the sess_cmd_list is the only time submit cmd fails?

The qla2xxx race/use-after-free is definitely real, we hit it in testing
here with active IO across ACL changes.

 - R.
