From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 10/24] uas: zap_pending: data urbs should have
 completed at this time
Date: Sun, 14 Sep 2014 11:29:47 +0100
Message-ID: <1410690587.2270.2.camel@jarvis>
References: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
	 <1410604011-3828-11-git-send-email-hdegoede@redhat.com>
	 <54149BA6.3010305@cogentembedded.com> <54155F49.8060904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52529 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752396AbaINK3v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Sep 2014 06:29:51 -0400
In-Reply-To: <54155F49.8060904@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, 2014-09-14 at 11:26 +0200, Hans de Goede wrote:
> Hi,
> 
> On 09/13/2014 09:31 PM, Sergei Shtylyov wrote:
> > Hello.
> > 
> > On 9/13/2014 1:26 PM, Hans de Goede wrote:
> > 
> >> The data urbs are all killed before calling zap_pending, and their completion
> >> handler should have cleared their inflight flag.
> > 
> >> Do not 0 the data inflight flags, and add a check for try_complete succeeding,
> >> as it should always succeed when called from zap_pending.
> > 
> >> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >> ---
> >>   drivers/usb/storage/uas.c | 10 +++++-----
> >>   1 file changed, 5 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> >> index 08edb6b..85bbc1d 100644
> >> --- a/drivers/usb/storage/uas.c
> >> +++ b/drivers/usb/storage/uas.c
> >> @@ -145,6 +145,7 @@ static void uas_zap_pending(struct uas_dev_info *devinfo, int result)
> >>       struct uas_cmd_info *cmdinfo;
> >>       struct uas_cmd_info *temp;
> >>       unsigned long flags;
> >> +    int err;
> > 
> >    Er, I don't see why this variable is necessary.
> > 
> > [...]
> >> @@ -152,12 +153,11 @@ static void uas_zap_pending(struct uas_dev_info *devinfo, int result)
> >>           struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd,
> >>                                 SCp);
> >>           uas_log_cmd_state(cmnd, __func__);
> >> -        /* all urbs are killed, clear inflight bits */
> >> -        cmdinfo->state &= ~(COMMAND_INFLIGHT |
> >> -                    DATA_IN_URB_INFLIGHT |
> >> -                    DATA_OUT_URB_INFLIGHT);
> >> +        /* Sense urbs were killed, clear COMMAND_INFLIGHT manually */
> >> +        cmdinfo->state &= ~COMMAND_INFLIGHT;
> >>           cmnd->result = result << 16;
> >> -        uas_try_complete(cmnd, __func__);
> >> +        err = uas_try_complete(cmnd, __func__);
> >> +        WARN_ON(err != 0);
> > 
> >    Why not:
> > 
> >         WARN_ON(uas_try_complete(cmnd, __func__));
> > 
> 
> This was discussed already during v1 of this patch-set, WARN_ON may
> not have a side-effect, as it may be defined as an empty macro.

Must have missed the discussion, but whoever said that loses all their
review points.  We're very careful to make sure that even in the case
where WARN_ON and BUG_ON (and indeed any macros) are compiled out, the
side effects are still accounted for.  This is the canonical definition
of WARN_ON in the compiled out case:

#define WARN_ON(condition) ({						\
	int __ret_warn_on = !!(condition);				\
	unlikely(__ret_warn_on);					\
})

So the compiler will eliminate the statement only if there are no side
effects.

James


