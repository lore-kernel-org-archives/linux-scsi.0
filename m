From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH] target: Allow for target_submit_cmd() returning errors
Date: Wed, 18 Jul 2012 16:38:27 -0700
Message-ID: <1342654707.18004.711.camel@haakon2.linux-iscsi.org>
References: <1342568261-15616-1-git-send-email-nab@linux-iscsi.org>
	 <1342569948.18004.541.camel@haakon2.linux-iscsi.org>
	 <50067D85.5090900@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50067D85.5090900-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>, Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-usb <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-07-18 at 11:10 +0200, Sebastian Andrzej Siewior wrote:
> On 07/18/2012 02:05 AM, Nicholas A. Bellinger wrote:
> >> index 02ace18..9ddf315 100644
> >> --- a/drivers/usb/gadget/tcm_usb_gadget.c
> >> +++ b/drivers/usb/gadget/tcm_usb_gadget.c
> >> @@ -1060,7 +1060,10 @@ static void usbg_cmd_work(struct work_struc=
t *work)
> >>   	tpg =3D cmd->fu->tpg;
> >>   	tv_nexus =3D tpg->tpg_nexus;
> >>   	dir =3D get_cmd_dir(cmd->cmd_buf);
> >> -	if (dir<  0) {
> >> +	if (dir<  0 ||
> >> +	    target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
> >> +			      cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
> >> +			      0, cmd->prio_attr, dir, TARGET_SCF_UNKNOWN_SIZE)) {
> >>   		transport_init_se_cmd(se_cmd,
> >>   				tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
> >>   				tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
> >> @@ -1069,12 +1072,7 @@ static void usbg_cmd_work(struct work_struc=
t *work)
> >>   		transport_send_check_condition_and_sense(se_cmd,
> >>   				TCM_UNSUPPORTED_SCSI_OPCODE, 1);
> >>   		usbg_cleanup_cmd(cmd);
> >> -		return;
> >>   	}
> >> -
> >> -	target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
> >> -			cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
> >> -			0, cmd->prio_attr, dir, TARGET_SCF_UNKNOWN_SIZE);
> >>   }
> >>
> >>   static int usbg_submit_command(struct f_uas *fu,
> >
> > Looking at this part again target_submit_cmd() has been moved ahead=
 of
> > target_init_se_cmd() in the exception path, which ends up getting c=
alled
> > twice during a target_get_sess_cmd() failure..
> >
> > It looks like usbg_cmd_work() + bot_cmd_work() will need some work =
if
> > they intends to use a non zero failure to signal exception here, wi=
thout
> > invoking a CHECK_CONDITION and sense.  Actually, I'm not even sure
> > sending a CHECK_CONDITION here after the target_submit_cmd() is goi=
ng to
> > work for other fabrics drivers, but it appears to work with usb-gad=
get.
> > (Sebastian..?)
>=20
> For UAS the status/ sense URB is sent right away (without any data) a=
nd
> this worked the last time I tested.

<nod>, thanks for the re-clarification on this..  ;)

> For BOT things are a little complicated. What I do is to send empty
> data (to fill the data pipe) and send a bad status so the other side
> learns that the transfer failed somehow. The sense information is los=
t.
> What I should do is to queue this sense data for the next MODE_SENSE
> request which will be coming soon. Right now WinXP repeats a failed
> command thrice if MODE_SENSE returns no error. "This" is on my to-fix
> list=E2=80=A6
>=20

Ok, so I think the special case for usb-gadget where is able to call
transport_send_check_condition_and_sense() should be OK for the single
target_get_sess_cmd() -> target_submit_cmd() failure case..

This is not going to be safe for just about every other fabric AFAICT,
so I think we need a comment here to describe that fact..

> > So for the moment, lets fix the double se_cmd init and make things =
a
> > little easier to read..   Sebastian, please have a look and double =
check
> > that the (dir<  0) + target_submit_cmd() failures cases are both go=
ing
> > to work as expected whilst sending a CHECK_CONDITION response.
>=20
> The sense code should only be sent once and
> transport_send_check_condition_and_sense() sets
> SCF_SENT_CHECK_CONDITION and checks for it so doing it twice should n=
ot
> do any harm right? But grep does not say when this flag gets removed.
>=20

Correct.  The SCF_SENT_CHECK_CONDITION bit does not get removed ahead o=
f
fabric descriptor release.

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
